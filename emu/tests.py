#!/usr/bin/env python3
"""tests.py - emulator tests for the Trio64V2 VBIOS and the DOS tools (needs python3 and unicorn).

    python3 emu/tests.py --rom S3V2P9.BIN [--build build] [-k name] [-v]
    make emu-test ROM=S3V2P9.BIN

The ROM image is not in the repository; pass the 64 KB image of the card. The tools run with /V;
their output (NAME.LOG) and debug files (NAME.DBG, VGALOG.BIN) are kept in emu/logs (--logs).
Run against the stock ROM, s3test (and the FIFO line of rom_patches) list everything the patches add. The tools are taken from
--build (run make first). Each test prints PASS, FAIL (with the reason) or SKIP; the exit code is 1
when a test failed. The emulator models the VGA/S3 registers, one 64 KB planar window and a virtual clock
that drives the PIT, the BIOS tick and the retrace bit (see vgaemu.py). It has no banked or linear
video memory and no real bus speed, so those results stay with the hardware runs.

Tests
  post             the ROM initialises and hooks INT 10h into C000
  rom_patches      what S3TEST cannot check: sign-on ROMVER and the checksums of both 32 KB halves in
                   the file, the mode set clear (bank 0 zeroed, CR6A back to 0, EAX bits 31-16 kept
                   across 4F02), and the FIFO fix (CR90 bit 7) with the bit set as the card leaves it
                   after a VESA mode; all failures listed. The other patches are S3TEST's checks
  vga_registers    every VGA mode in s3compat/vgaref.inc (incl. the 350-line text modes): the 62 standard
                   registers and the AH=1Bh state block equal the IBM reference
  vga_palettes     default DAC after each mode set: 256-colour table (13h), CGA (04h-06h, 0Dh, 0Eh),
                   EGA (all others)
  s3test           S3TEST runs to the end; every check passes except the two the model cannot judge
                   (banked memory, throughput); with /V the output is the same and S3TEST.DBG is well
                   formed
  vshow            VSHOW 101 runs; with /V the output is the same and VSHOW.DBG is well formed
  s3compat_vga     S3COMPAT's VGA and Mode X part (built with nasm from the source with the rest cut
                   out): every test passes (registers, BIOS data, refresh, planar memory, palettes),
                   only the known mode 10h warning; with /V the output is the same and S3COMPAT.DBG
                   is well formed
  vgalog           VGALOG installs, logs 32 bytes per call and returns the BIOS results with the
                   caller's interrupt flag; second install refused, /H, /U closes the file and unhooks
  vgalog_mem       VGALOG /M keeps the calls in memory (AH=0Eh skipped, nested BIOS calls with their depth,
                   registers in and out, SR10/SR11 and CR58-5A/6D after), /D writes them in call order,
                   the S3 locks are put back, /U unhooks, /D afterwards is refused
  s3alias          S3ALIAS install, mapping 49h->59h and 4Bh->5Ah, refused second install, /H, /U
  s3regs           S3REGS.COM and S3REGS32.EXE (the Win32 one on a 32-bit CPU with the same register
                   model, vgaemu.run_pe32) write the same snapshot, keep indexes and locks, and
                   S3REGS32 /W logs register changes with their time (cursor registers ignored)
  dos_exe          the emulated DOS runs an MZ program built with nasm: relocation, memory blocks
                   (62h/4Ah/48h), and an INT 21h hook that turns the program's own AH=4Ch into AH=31h
"""
import argparse, os, re, shutil, struct, subprocess, sys, tempfile, time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from vgaemu import Machine, REGNAMES  # noqa: E402
from unicorn.x86_const import UC_X86_REG_EAX  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.dirname(HERE)


class Skip(Exception):
    pass


def check(cond, msg):
    if not cond:
        raise AssertionError(msg)


# ---------------------------------------------------------------- reference data from vgaref.inc
def read_vgaref():
    t = open(os.path.join(SRC, 's3compat', 'vgaref.inc')).read()
    lines = [l.strip() for l in t.split('\n')]
    ents = []
    i = 0
    while i < len(lines):
        l = lines[i]
        if l.startswith('db') and 'mode, memtype' in l:
            f = l.split(';')[0].split()[1].split(',')
            mode, memtype = int(f[0], 16), int(f[1], 0)
            regs = [int(x, 16) for x in lines[i + 2].split(';')[0][3:].split(',')]
            ds = [int(x, 16) for x in lines[i + 3].split(';')[0][3:].split(',')]
            ents.append((mode, memtype, regs, ds))
            i += 4
        else:
            i += 1
    k = t.index('dac_col:')
    dac = []
    for l in t[k:].split('\n')[1:]:
        l = l.strip()
        if not l.startswith('db'):
            break
        dac += [int(x, 16) for x in l[2:].split(',')]
    return ents, bytes(dac)


def ega(i):
    c = lambda hi, lo: (0x2A if i & hi else 0) + (0x15 if i & lo else 0)
    return (c(4, 0x20), c(2, 0x10), c(1, 8))


def cga(i):
    n = 0x15 if i & 0x10 else 0
    r, g, b = (0x2A if i & 4 else 0) + n, (0x2A if i & 2 else 0) + n, (0x2A if i & 1 else 0) + n
    if (i & 0x17) == 6:
        g = 0x15
    return (r, g, b)


# ---------------------------------------------------------------- helpers
class Ctx:
    def __init__(self, rom, build, verbose, logs):
        self.rom = open(rom, 'rb').read()
        self.build = build
        self.verbose = verbose
        self.logs = logs
        os.makedirs(logs, exist_ok=True)

    def save(self, name, res):
        """Keep a tool run in the log folder: NAME.LOG (stdout and stderr) and every file it created."""
        with open(os.path.join(self.logs, name + '.LOG'), 'wb') as f:
            f.write(bytes(res.stdout))
            if res.stderr:
                f.write(b'\r\n--- stderr ---\r\n' + bytes(res.stderr))
        for fn, data in res.files.items():
            with open(os.path.join(self.logs, name + '-' + fn if not fn.startswith(name) else fn), 'wb') as f:
                f.write(bytes(data))

    def machine(self, keys=None):
        m = Machine(self.rom, keys)
        seg, off = m.post()
        return m

    def tool(self, name):
        p = os.path.join(self.build, name)
        if not os.path.exists(p):
            raise Skip('%s not built (run make)' % p)
        return open(p, 'rb').read()


def has_verbose():
    return os.path.exists(os.path.join(SRC, 'common', 'vdebug.inc'))


def check_dbg(dbg, name):
    """A /V debug file: every line a D: record, INT 10h records balanced, ends with D:END lost=0."""
    check(dbg is not None, '%s was not created' % name)
    lines = dbg.decode('latin1').split('\r\n')
    if lines and lines[-1] == '':
        lines.pop()
    check(lines, '%s is empty' % name)
    bad = [l for l in lines if not l.startswith('D:')]
    check(not bad, '%s: line without D: tag: %r' % (name, bad[:1]))
    n_in = sum(1 for l in lines if l.startswith('D:I10>'))
    n_out = sum(1 for l in lines if l.startswith('D:I10<'))
    check(n_in == n_out, '%s: %d INT 10h calls but %d returns' % (name, n_in, n_out))
    check(lines[-1] == 'D:END lost=0', '%s: last line %r, expected D:END lost=0' % (name, lines[-1]))
    for l in lines:
        if l.startswith('D:I10<') and 'T=' in l:
            t = int(l.split('T=')[1])
            check(t < 50_000_000, '%s: implausible call duration %r' % (name, l))
    return lines


# ---------------------------------------------------------------- tests
def t_post(c):
    m = Machine(c.rom)
    seg, off = m.post()
    check(seg == 0xC000, 'INT 10h vector %04X:%04X, expected C000:xxxx' % (seg, off))


def t_vga_registers(c):
    ents, _ = read_vgaref()
    m = c.machine()
    errs = []
    for mode, memtype, regs, ds in ents:
        tag = '%02Xh%s' % (mode, ' 350' if memtype & 0x80 else '')
        if memtype & 0x80:
            m.int10(0x1201, bx=0x30)
        m.int10(mode)
        snap = m.snapshot()
        for j, (a, e) in enumerate(zip(snap, regs)):
            if REGNAMES[j] == 'SR0':
                continue
            if REGNAMES[j] == 'SR4':                       # bit 0 reserved, reads 0 on the chip
                a, e = a & 0xFE, e & 0xFE
            if a != e:
                errs.append('%s %s=%02X(%02X)' % (tag, REGNAMES[j], a, e))
        sb = m.state_block()[4:51]
        for j, (a, e) in enumerate(zip(sb, ds)):
            off = j + 4
            if off in (0x26, 0x2D):                          # model artefacts (equipment, flags)
                continue
            if mode == 0x10 and off in (0x22, 0x23):         # known: 8x14 font missing in the ROM
                continue
            if a != e:
                errs.append('%s DS+%02X=%02X(%02X)' % (tag, off, a, e))
        if memtype & 0x80:
            m.int10(0x1202, bx=0x30)
    check(not errs, '%d differences: %s' % (len(errs), ' '.join(errs[:12])))
    return '%d modes' % len(ents)


def t_vga_palettes(c):
    ents, dac_col = read_vgaref()
    m = c.machine()
    errs = []
    for mode, memtype, regs, ds in ents:
        if memtype & 0x80:
            m.int10(0x1201, bx=0x30)
        m.int10(mode)
        d = m.dac_bytes()
        if mode == 0x13:
            if d[:744] != dac_col[:744]:
                errs.append('13h not the IBM 256-colour table')
        else:
            f = cga if mode in (4, 5, 6, 0x0D, 0x0E) else ega
            for i in range(64):
                if tuple(d[3 * i:3 * i + 3]) != f(i):
                    errs.append('%02Xh%s entry %02X %s' % (mode, ' 350' if memtype & 0x80 else '', i,
                                                         d[3 * i:3 * i + 3].hex()))
                    break
        if memtype & 0x80:
            m.int10(0x1202, bx=0x30)
    check(not errs, '; '.join(errs))


# ---------------------------------------------------------------- the patches on top of the stock ROM
def romver():
    t = open(os.path.join(SRC, 'common', 'version.inc')).read()
    return re.search(r"%define ROMVER '([^']*)'", t).group(1)


def t_rom_patches(c):
    """What S3TEST cannot check on the card or in the model: the ROM file itself and the FIFO fix with
    CR90 bit 7 set the way the chip leaves it after a VESA mode (the model does not set it). Every other
    patch is checked by S3TEST, which t_s3test runs here and which also runs on the hardware."""
    m = c.machine()
    fails = []

    def chk(cond, what):
        if not cond:
            fails.append(what)

    rom = c.rom
    chk(romver().encode() in rom[:0x100], 'sign-on: %s not in the first 256 bytes' % romver())
    chk(sum(rom[:0x8000]) & 0xFF == 0, 'checksum of the lower 32 KB is not 00')
    if len(rom) >= 0x10000:
        chk(rom[0x8000:0x8002] == b'\x55\xAA', 'upper 32 KB has no 55AAh ROM header')
        chk(sum(rom[0x8000:0x10000]) & 0xFF == 0, 'checksum of the upper 32 KB is not 00')
    cr = m.r['crtc']
    m.mu.mem_write(0xA0000, b'\x55' * 0x10000)
    m.mu.reg_write(UC_X86_REG_EAX, 0x12340000)        # p11 clears with 32-bit stores: EAX bits 31-16 kept
    m.int10(0x4F02, bx=0x0101)
    eaxh = m.mu.reg_read(UC_X86_REG_EAX) >> 16
    chk(eaxh == 0x1234, 'mode set: EAX bits 31-16 = %04X after 4F02 101h, the caller had 1234' % eaxh)
    chk(m.mem(0xA0000, 0x10000).count(0) == 0x10000, 'mode set clear: bank 0 at A0000 not zeroed by 4F02 101h')
    chk(cr.get(0x6A, 0) == 0, 'mode set clear: CR6A = %02X afterwards, expected bank 0' % cr.get(0x6A, 0))
    m.r['crtc'][0x90] = cr.get(0x90, 0) | 0x80        # as a VESA mode leaves it on the card
    m.int10(0x0003)
    chk(cr.get(0x90, 0) & 0x80 == 0, 'FIFO fix: CR90 bit 7 still set after mode 03 (CR90 = %02X)' % cr.get(0x90, 0))
    check(not fails, '%d of the checks failed:\n    ' % len(fails) + '\n    '.join(fails))
    return 'ROM file and FIFO fix as expected'


# S3TEST lines that cannot pass in the emulator (no banked video memory, no real bus speed)
S3TEST_MODEL_LIMITS = ('Banked data check', 'Banked write throughput')


def t_s3test(c):
    com = c.tool('S3TEST.COM')
    v = '/V' if has_verbose() else ''
    r1 = c.machine().run_com(com, v)
    c.save('S3TEST', r1)
    check(r1.exit and r1.exit[0] == 'exit', 'S3TEST did not end: %s' % (r1.exit,))
    out = r1.stdout.decode('latin1')
    check('Passed:' in out, 'no summary line')
    results = [l for l in out.split('\r\n') if l.rstrip().endswith(('PASS', 'FAIL'))]
    check(len(results) >= 30, 'only %d result lines' % len(results))
    bad = [l.strip() for l in results if l.rstrip().endswith('FAIL') and not l.startswith(S3TEST_MODEL_LIMITS)]
    check(not bad, '%d checks not PASS:\n    ' % len(bad) + '\n    '.join(bad))
    if v:
        check_dbg(r1.files.get('S3TEST.DBG'), 'S3TEST.DBG')
        r0 = c.machine().run_com(com, '')
        check(r1.stdout == r0.stdout, 'output differs without /V')
    return 'exit code %d' % r1.exit[1]


def t_vshow(c):
    com = c.tool('VSHOW.COM')
    v = ' /V' if has_verbose() else ''
    r1 = c.machine().run_com(com, '101' + v)
    c.save('VSHOW', r1)
    check(r1.exit and r1.exit[0] == 'exit' and r1.exit[1] == 0, 'VSHOW 101 ended with %s' % (r1.exit,))
    rh = c.machine().run_com(com, '/H')
    check(b'VSHOW' in rh.stdout and b'/L' in rh.stdout, '/H shows no parameter list')
    if v:
        r0 = c.machine().run_com(com, '101')
        check(r1.stdout == r0.stdout, 'output differs without /V')
        lines = check_dbg(r1.files.get('VSHOW.DBG'), 'VSHOW.DBG')
        check('D:TEST mode 0101' in lines, 'no D:TEST mode 0101')
        check(any(l.startswith('D:REG CR00:') for l in lines), 'no register dump')
        check(any(l.startswith('D:FRM n=31') for l in lines), 'no frame timing')


def build_s3compat_vga(tmp):
    """S3COMPAT with POST/setup tests and everything after the VGA and Mode X part cut out."""
    nasm = shutil.which('nasm')
    if not nasm:
        raise Skip('nasm not found')
    t = open(os.path.join(SRC, 's3compat', 's3compat.asm')).read()
    cuts = [("        call setup\n        call post_tests\n", ""),
            ("        call modex_all\n        PS 13,10,'--- VGA BIOS functions ---',13,10\n",
             "        call modex_all\n        jmp emu_end\n        PS 13,10,'--- VGA BIOS functions ---',13,10\n"),
            ("        call cleanup\n", "        call cleanup\nemu_end:\n")]
    for a, b in cuts:
        check(t.count(a) == 1, 'cannot cut s3compat.asm at %r' % a[:40])
        t = t.replace(a, b)
    shutil.copy(os.path.join(SRC, 's3compat', 'vgaref.inc'), tmp)
    src = os.path.join(tmp, 's3cvga.asm')
    open(src, 'w').write(t)
    out = os.path.join(tmp, 'S3CVGA.COM')
    inc = os.path.join(SRC, 'common') + os.sep
    subprocess.run([nasm, '-f', 'bin', '-i' + inc, '-i' + tmp + os.sep, '-o', out, src], check=True, cwd=tmp)
    return open(out, 'rb').read()


def t_s3compat_vga(c):
    with tempfile.TemporaryDirectory() as tmp:
        com = build_s3compat_vga(tmp)
    v = '/V' if has_verbose() else ''
    r0 = c.machine().run_com(com, v)
    c.save('S3COMPAT', r0)
    check(r0.exit and r0.exit[0] == 'exit', 'S3COMPAT did not end: %s' % (r0.exit,))
    lines = r0.stdout.decode('latin1').split('\r\n')
    tests = [l for l in lines if l.startswith(('VGA ', 'Mode ', 'Text 80x50')) and
             re.search(r'  (PASS|FAIL [0-9A-F]+|WARN [0-9A-F]+|INFO)$', l)]
    check(len(tests) >= 17 + 6, 'only %d VGA/Mode X lines' % len(tests))
    bad = [l.strip() for l in tests if not l.rstrip().endswith('PASS') and
           not (l.startswith('VGA 10h') and l.rstrip().endswith('WARN 01'))]     # known: no 8x14 font
    details = [l.strip() for l in lines if l.startswith('      ')]
    check(not bad, '%d tests not PASS:\n    ' % len(bad) + '\n    '.join(bad + details[:6]))
    if v:
        r1 = c.machine().run_com(com, '')
        check(r1.stdout == r0.stdout, 'output differs without /V')
        dl = check_dbg(r0.files.get('S3COMPAT.DBG'), 'S3COMPAT.DBG')
        check(sum(1 for l in dl if l.startswith('D:TEST')) >= len(tests), 'fewer D:TEST records than tests')
    return '%d tests' % len(tests)


def t_vgalog(c):
    if not os.path.exists(os.path.join(SRC, 'vgalog', 'vgalog.asm')):
        raise Skip('no vgalog/ in this tree')
    com = c.tool('VGALOG.COM')
    m = c.machine()
    ri = r = m.run_com(com, '', seg=0x2000)
    check(r.exit and r.exit[0] == 'tsr', 'VGALOG did not stay resident: %s' % (r.exit,))
    log = r.files.get('VGALOG.BIN')
    check(log is not None, 'VGALOG.BIN not created')
    m.com = r                                   # keep collecting the resident copy's DOS writes
    m.stdout_is_file = True
    m.psp = 0x2000
    m.handles = {5: 'VGALOG.BIN'}
    calls = [(0x0003, 0, 0x0003), (0x4F02, 0x101, 0x004F), (0x4F01, 0x101, 0x004F), (0x0E41, 0, None)]
    for ax, bx, want in calls:
        res = m.int10(ax, bx=bx, cx=0x101, es=0x3000)
        check(res['flags'] & 0x200, 'AX=%04X returned with interrupts disabled' % ax)
        if want is not None:
            check(res['ax'] == want, 'AX=%04X returned AX=%04X' % (ax, res['ax']))
    m.com = None
    c.save('VGALOG', ri)
    check(len(log) == 3 * 32, 'VGALOG.BIN has %d bytes, expected 96 (3 logged calls)' % len(log))
    recs = [log[i:i + 16] for i in range(0, len(log), 16)]
    check([x[0] for x in recs] == [ord('B'), ord('A')] * 3, 'records not B/A pairs')
    rh = m.run_com(com, '/H', seg=0x4000)
    if b'/U' not in rh.stdout:
        return 'no /U in this version'
    r = m.run_com(com, '', seg=0x4000)
    check(r.exit == ('exit', 1), 'second install not refused: %s' % (r.exit,))
    r = m.run_com(com, '/U', seg=0x4000)
    check(r.exit == ('exit', 0), '/U failed: %s %r' % (r.exit, bytes(r.stdout)))
    check(5 not in m.handles, 'VGALOG.BIN not closed by /U')
    seg, off = struct.unpack('<HH', m.mem(0x42, 2) + m.mem(0x40, 2))
    check(seg == 0xC000, 'INT 10h vector not restored: %04X:%04X' % (seg, off))
    n = len(log)
    m.com, m.handles = ri, {5: 'VGALOG.BIN'}   # a resident copy would write here again
    m.int10(0x0003)
    m.com = None
    check(len(log) == n, 'still logging after /U')
    r = m.run_com(com, '/U', seg=0x4000)
    check(r.exit == ('exit', 1), 'second /U not refused: %s' % (r.exit,))


def t_s3alias(c):
    com = c.tool('S3ALIAS.COM')
    m = c.machine()
    runs = []
    run = m.run_com

    def logged(com_, tail, seg):
        r = run(com_, tail, seg=seg)
        runs.append(('S3ALIAS %s' % tail).encode() + b' -> ' + repr(r.exit).encode() + b'\r\n' + bytes(r.stdout))
        open(os.path.join(c.logs, 'S3ALIAS.LOG'), 'wb').write(b'\r\n'.join(runs))
        return r
    m.run_com = logged
    r = m.run_com(com, '/H', seg=0x3000)
    if b'/U' not in r.stdout:
        raise Skip('S3ALIAS without /U and /H')
    r = m.run_com(com, '/U', seg=0x3000)
    check(r.exit == ('exit', 1), '/U without an installed copy: %s' % (r.exit,))
    r = m.run_com(com, '', seg=0x2000)
    check(r.exit and r.exit[0] == 'tsr', 'install: %s' % (r.exit,))

    def mode(n):
        m.int10(n)
        return m.mem(0x449, 1)[0]
    check(mode(0x49) == 0x59 and mode(0x4B) == 0x5A, '49h/4Bh not mapped to 59h/5Ah')
    check(mode(0x03) == 0x03, 'mode 03 changed')
    r = m.run_com(com, '', seg=0x4000)
    check(r.exit == ('exit', 1), 'second install not refused: %s' % (r.exit,))
    r = m.run_com(com, '/U', seg=0x4000)
    check(r.exit == ('exit', 0), '/U failed: %s %r' % (r.exit, bytes(r.stdout)))
    check(mode(0x49) == 0x49, '49h still mapped after /U')


EXE_SRC = r"""
bits 16
org 0
        mov ax,0                        ; relocated: the load segment
        mov ds,ax
        mov dx,msg
        mov ah,9
        int 21h
        mov ah,62h                      ; shrink the program block, then allocate one above it
        int 21h
        mov es,bx
        mov bx,40h
        mov ah,4Ah
        int 21h
        jc fail
        mov bx,10h
        mov ah,48h
        int 21h
        jc fail
        mov ax,3521h                    ; hook INT 21h: our own AH=4Ch becomes AH=31h
        int 21h
        mov [old],bx
        mov [old+2],es
        mov dx,hook
        mov ax,2521h
        int 21h
        mov ax,4C00h
        int 21h
fail:   mov ax,4C02h
        int 21h
hook:   cmp ah,4Ch
        jne .c
        mov ah,31h
        mov dx,60h
.c:     jmp far [cs:old]
old     dd 0
msg     db 'MZ OK',13,10,'$'
"""


def build_exe(tmp):
    """A small MZ program (one relocation, stack after the image) built from EXE_SRC with nasm."""
    nasm = shutil.which('nasm')
    if not nasm:
        raise Skip('nasm not found')
    src = os.path.join(tmp, 'mz.asm')
    open(src, 'w').write(EXE_SRC)
    subprocess.run([nasm, '-f', 'bin', '-o', os.path.join(tmp, 'mz.bin'), src], check=True)
    img = open(os.path.join(tmp, 'mz.bin'), 'rb').read()
    total = 32 + len(img)
    hdr = struct.pack('<2s13H', b'MZ', total % 512, (total + 511) // 512, 1, 2, 0x10, 0xFFFF,
                      (len(img) + 15) // 16, 0x100, 0, 0, 0, 0x1C, 0) + struct.pack('<HH', 1, 0)
    return hdr.ljust(32, b'\0') + img


def t_dos_exe(c):
    """The emulated DOS runs an MZ program: relocation, 62h/4Ah/48h with MCBs, and an INT 21h hook that
    sees the program's own AH=4Ch (how S3VBE20 and other TSR kits stay resident)."""
    with tempfile.TemporaryDirectory() as tmp:
        exe = build_exe(tmp)
    m = c.machine()
    r = m.run_exe(exe, '', seg=0x1000)
    check(bytes(r.stdout) == b'MZ OK\r\n', 'output %r (relocation or AH=09h)' % bytes(r.stdout))
    check(r.exit == ('tsr', 0, 0x60), 'ended with %s, expected the hook to turn AH=4Ch into AH=31h' % (r.exit,))
    check(m.mem(0x1000 * 16 - 16, 1) == b'Z', 'no MCB in front of the PSP')
    seg = struct.unpack('<H', m.mem(0x86, 2))[0]
    check(seg == 0x1010, 'INT 21h vector %04X, expected the hook in the program (1010)' % seg)
    return 'MZ program ran, hooked INT 21h, stayed resident'


def t_vgalog_mem(c):
    """VGALOG /M keeps INT 10h calls in its ring buffer (text output skipped, nested BIOS calls with their
    depth, registers in and out, SR10/SR11 and CR58-5A/6D after); /D writes them in call order."""
    com = c.tool('VGALOG.COM')
    m = c.machine()
    r = m.run_com(com, '/M', seg=0x2000)
    check(r.exit and r.exit[0] == 'tsr', 'VGALOG /M did not stay resident: %s' % (r.exit,))
    calls = [(0x0003, {}), (0x0E41, dict(bx=7)), (0x4F02, dict(bx=0x0101)), (0x4F05, dict(bx=0, dx=2)),
             (0x1130, dict(bx=0x0200)), (0x0003, {})]
    ret = {}
    for ax, kw in calls:
        res = m.int10(ax, **kw)
        ret[ax] = res
        check(res['flags'] & 0x200, 'AX=%04X returned with interrupts disabled' % ax)
    check(ret[0x1130]['es'] == 0xC000 and ret[0x1130]['cx'] == 16, 'AX=1130h result changed by VGALOG: %s' % ret[0x1130])
    rd = m.run_com(com, '/D', seg=0x4000)
    check(rd.exit == ('exit', 0), '/D ended with %s' % (rd.exit,))
    b = rd.files.get('VGALOG.BIN')
    check(b is not None and b[:8] == b'VGALOGM1', 'VGALOG.BIN has no memory-mode header')
    total, n = struct.unpack_from('<IH', b, 8)
    recs = [b[16 + 32 * i:48 + 32 * i] for i in range(n)]
    check(len(b) == 16 + 32 * n, 'VGALOG.BIN is %d bytes for %d records' % (len(b), n))
    top = [struct.unpack_from('<H', x, 2)[0] for x in recs if x[23] == 0]
    check(top == [0x0003, 0x4F02, 0x4F05, 0x1130, 0x0003], 'calls at depth 0: %s (AH=0Eh must be skipped)'
          % ['%04X' % a for a in top])
    nested = [x for x in recs if x[23] > 0]
    check(nested and all(struct.unpack_from('<H', x, 2)[0] == 0x1130 for x in nested),
          'no nested AX=1130h from the BIOS during the mode set')
    r101 = [x for x in recs if struct.unpack_from('<HH', x, 2) == (0x4F02, 0x0101)][0]
    check(struct.unpack_from('<H', r101, 14)[0] == 0x004F and r101[26:28] == b'\x42\x41' and r101[28] == 0x90
          and r101[29:31] == b'\x00\x0A', '4F02 101h record: AX out, SR10/11 or CR58/59/5A wrong: %s' % r101.hex())
    check(m.r['crtc'].get(0x38) != 0x48 or m.r['seq'].get(8) != 0x06, 'S3 registers left unlocked')
    ru = m.run_com(com, '/U', seg=0x4000)
    check(ru.exit == ('exit', 0), '/U ended with %s' % (ru.exit,))
    rd2 = m.run_com(com, '/D', seg=0x4000)
    check(rd2.exit == ('exit', 1), '/D after /U not refused')
    c.save('VGALOGM', rd)
    return '%d calls, %d of them nested' % (n, len(nested))


def t_s3regs(c):
    """S3REGS (DOS) and S3REGS32 (Win32, run on the same register model) write the same snapshot of SR, CR,
    GR and PCI, leave indexes and locks as found, and S3REGS32 /W logs register changes."""
    com, exe = c.tool('S3REGS.COM'), c.tool('S3REGS32.EXE')
    m = c.machine()
    m.int10(0x4F02, bx=0x0101)
    before = (m.r['si'], m.r['gi'], m.r['ci'], m.r['crtc'].get(0x38), m.r['crtc'].get(0x39), m.r['seq'].get(8))
    r = m.run_com(com, 'test label')
    check(r.exit == ('exit', 0), 'S3REGS ended with %s' % (r.exit,))
    dos = r.files['S3REGS.TXT'].decode('latin1').split('\r\n')
    r32 = m.run_pe32(exe, 'S3REGS32.EXE test label')
    check(r32.exit == ('exit', 0), 'S3REGS32 ended with %s' % (r32.exit,))
    win = r32.files['S3REGS.TXT'].decode('latin1').split('\r\n')
    after = (m.r['si'], m.r['gi'], m.r['ci'], m.r['crtc'].get(0x38), m.r['crtc'].get(0x39), m.r['seq'].get(8))
    check(before == after, 'indexes or locks changed: %s -> %s' % (before, after))
    check(dos[0].startswith('S3REGS ') and dos[0].endswith('[test label] DOS') and win[0].endswith('[test label] Win32'),
          'header lines: %r %r' % (dos[0], win[0]))
    rows = lambda ls: [l for l in ls if l[:2] in ('SR', 'CR', 'GR') or l.startswith('PCI00:')]
    check(rows(dos) == rows(win) and len(rows(dos)) == 2 + 16 + 1 + 1, 'DOS and Win32 snapshots differ:\n%s\n%s'
          % ('\n'.join(rows(dos)), '\n'.join(rows(win))))
    check('SR10: 42 41' in '\n'.join(dos) and 'CR50: 40 00 81 00 F8 00 00 00 90 00 0A' in '\n'.join(dos),
          'snapshot values (SR10/11, CR58-5A in 101h) not as the BIOS set them')

    def hook(ms):
        if ms == 300:
            m.r['seq'][0x10], m.r['seq'][0x11] = 0x41, 0x28
        if ms == 500:
            m.r['crtc'][0x54], m.r['crtc'][0x47] = 0x10, 0x05
    rw = m.run_pe32(exe, '"C:\\TOOLS\\S3REGS32.EXE" /W 1 watch', sleep_hook=hook)
    text = rw.files['S3REGS.TXT'].decode('latin1')
    ch = text[text.index('WATCH'):text.index('END OF WATCH')].split('\r\n')[1:-1]
    check(ch == ['+300 SR10 42->41', '+300 SR11 41->28', '+500 CR54 F8->10'], 'watch lines: %s' % ch)
    rh = m.run_pe32(exe, 'S3REGS32 /?')
    check(b'/W n' in rh.stdout, 'S3REGS32 /? shows no parameter list')
    open(os.path.join(c.logs, 'S3REGS.TXT'), 'wb').write(r.files['S3REGS.TXT'] + r32.files['S3REGS.TXT'] + rw.files['S3REGS.TXT'])
    return 'DOS and Win32 snapshots equal, watch logs 3 changes'


TESTS = [('post', t_post), ('rom_patches', t_rom_patches), ('vga_registers', t_vga_registers),
         ('vga_palettes', t_vga_palettes),
         ('s3test', t_s3test), ('vshow', t_vshow), ('s3compat_vga', t_s3compat_vga),
         ('vgalog', t_vgalog), ('vgalog_mem', t_vgalog_mem), ('s3alias', t_s3alias),
         ('s3regs', t_s3regs), ('dos_exe', t_dos_exe)]


def main():
    ap = argparse.ArgumentParser(description='emulator tests for the Trio64V2 VBIOS tools')
    ap.add_argument('--rom', required=True, help='64 KB VBIOS image')
    ap.add_argument('--build', default=os.path.join(SRC, 'build'), help='folder with the built .COM files')
    ap.add_argument('-k', default='', help='run only tests whose name contains this text')
    ap.add_argument('-v', action='store_true', help='print tracebacks')
    ap.add_argument('--logs', default=os.path.join(HERE, 'logs'),
                    help='folder for the tool output and /V debug files (default emu/logs)')
    a = ap.parse_args()
    c = Ctx(a.rom, a.build, a.v, a.logs)
    failed = 0
    for name, fn in TESTS:
        if a.k not in name:
            continue
        t0 = time.time()
        try:
            note = fn(c)
            res = 'PASS' + ('  (%s)' % note if note else '')
        except Skip as e:
            res = 'SKIP  %s' % e
        except Exception as e:  # noqa: BLE001 - report every kind of failure as a test result
            failed += 1
            res = 'FAIL  %s' % e
            if a.v:
                import traceback
                traceback.print_exc()
        first, _, rest = res.partition('\n')
        print('%-14s %-60s %5.0fs' % (name, first, time.time() - t0) + ('\n' + rest if rest else ''), flush=True)
    print('%d failed; tool output and /V debug logs in %s' % (failed, a.logs))
    sys.exit(1 if failed else 0)


if __name__ == '__main__':
    main()
