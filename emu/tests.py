#!/usr/bin/env python3
"""tests.py - emulator tests for the Trio64V2 VBIOS and the DOS tools (needs python3 and unicorn).

    python3 emu/tests.py --rom S3V2P9.BIN [--build build] [-k name] [-v]
    make emu-test ROM=S3V2P9.BIN

The ROM image is not in the repository; pass the 64 KB image of the card. The tools run with /V;
their output (NAME.LOG) and debug files (NAME.DBG, VGALOG.BIN) are kept in emu/logs (--logs).
Run against the stock ROM, rom_patches and s3test list everything the patches add. The tools are taken from
--build (run make first). Each test prints PASS, FAIL (with the reason) or SKIP; the exit code is 1
when a test failed. The emulator models the VGA/S3 registers, one 64 KB planar window and a virtual clock
that drives the PIT, the BIOS tick and the retrace bit (see vgaemu.py). It has no banked or linear
video memory and no real bus speed, so those results stay with the hardware runs.

Tests
  post             the ROM initialises and hooks INT 10h into C000
  rom_patches      every change on top of the stock 2.04.11 ROM on its own, all failures listed: sign-on
                   ROMVER, checksum, MCLK 59.96 MHz, pedestal off, 60 Hz defaults for 1280/1600, ATC
                   flip-flop reset, FIFO fix (CR90), booster and LFB base restore, 4F01/4F03 with the
                   booster, 4F06 BL=3, CR50 in 151h, and the refresh and line length of the patched
                   timings (computed from the programmed registers)
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
  s3alias          S3ALIAS install, mapping 49h->59h and 4Bh->5Ah, refused second install, /H, /U
"""
import argparse, os, re, shutil, struct, subprocess, sys, tempfile, time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from vgaemu import Machine, REGNAMES  # noqa: E402

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


def refresh(m, xres):
    """Refresh in Hz and total pixels per line that the programmed registers define (vgaemu.frame)."""
    hz, pix, period, vtot = m.frame(xres)
    return hz, pix


# VESA mode, expected refresh in Hz, expected total pixels per line (0 = not checked), patch
TIMINGS = [(0x012E, 70.0, 0, 'stock 70 Hz'),
           (0x0131, 59.7, 400, 'p4b: 320x240x8 at 60 Hz (640x480 halved)'),
           (0x0133, 59.7, 400, 'p5/p6: 320x240x16 at 60 Hz'),
           (0x0101, 59.7, 800, 'p6: 640x480x8 with an 800-pixel line'),
           (0x0111, 59.7, 800, 'p6: 640x480x16 with an 800-pixel line'),
           (0x0141, 72.2, 0, 'stock 72 Hz'),
           (0x0103, 60.3, 0, '800x600 at 60 Hz'),
           (0x0105, 60.1, 0, '1024x768 at 60 Hz'),
           (0x0106, 60.2, 0, 'p9: 1280x1024x4 VESA DMT 60 Hz'),
           (0x0107, 60.2, 0, 'p6: 1280x1024 default 60 Hz'),
           (0x0120, 60.0, 0, 'p6: 1600x1200 default 60 Hz')]


def t_rom_patches(c):
    """Every change on top of the stock 2.04.11 ROM, checked on its own; all failures are reported."""
    m = c.machine()
    fails = []

    def chk(cond, what):
        if not cond:
            fails.append(what)

    rom = c.rom
    ver = romver().encode()
    chk(ver in rom[:0x100], 'sign-on: %s not in the first 256 bytes' % romver())
    chk(sum(rom[:0x8000]) & 0xFF == 0, 'checksum of the lower 32 KB is not 00')
    seq, cr = m.r['seq'], m.r['crtc']
    base = cr.get(0x59, 0)                    # the real LFB base (bits 31-24), set before the BIOS ran
    # POST
    chk((seq.get(0x10), seq.get(0x11)) == (0x42, 0x41),
        'MCLK: SR10/SR11 = %02X/%02X, expected 42/41 (59.96 MHz)' % (seq.get(0x10, 0), seq.get(0x11, 0)))
    chk(seq.get(0x1A, 0) & 0x30 == 0x10, 'pedestal: SR1A = %02X after POST, expected bit 5 = 0, bit 4 = 1'
        % seq.get(0x1A, 0))
    chk(cr.get(0x41, 0) & 0xE0 == 0x80, 'refresh default 1280x1024: CR41 = %02X, expected bits 7-5 = 100b (60 Hz)'
        % cr.get(0x41, 0))
    chk(cr.get(0x52, 0) & 0x07 == 0x01, 'refresh default 1600x1200: CR52 = %02X, expected bits 2-0 = 001b (60 Hz)'
        % cr.get(0x52, 0))
    # attribute controller flip-flop
    m.int10(0x0003)
    m.r['aff'] = 1
    m.int10(0x0003)
    chk(m.r['aff'] == 0, 'flip-flop: the ATC flip-flop is still in the data state after a mode set')
    chk(seq.get(0x1A, 0) & 0x20 == 0, 'pedestal: SR1A bit 5 set after mode 03')
    # booster and LFB base
    m.int10(0x4F02, bx=0x0101)
    c58, c59, c5a, c6d = cr.get(0x58, 0), cr.get(0x59, 0), cr.get(0x5A, 0), cr.get(0x6D, 0)
    chk(c58 & 0x13 == 0x10 and (c59, c5a) == (0, 0x0A) and c6d != 0,
        'booster: 101h has CR58/59/5A/6D = %02X/%02X/%02X/%02X, expected LA on with a 64 KB window, '
        '000Ah and the real base %02X in CR6D' % (c58, c59, c5a, c6d, base))
    chk(c6d in (0, base), 'booster: CR6D = %02X, expected the real base %02X' % (c6d, base))
    chk(m.int10(0x4F03)['bx'] == 0x0101, 'booster: 4F03 in 101h does not return 0101h')
    m.int10(0x4F01, cx=0x0101, es=0x3000, di=0)
    phys = struct.unpack('<I', m.mem(0x30028, 4))[0]
    chk(phys == base << 24, 'booster: 4F01 PhysBasePtr %08X, expected the real base %08X' % (phys, base << 24))
    r6 = m.int10(0x4F06, bx=3)
    chk((r6['bx'], r6['cx']) == (4368, 4368), '4F06 BL=3 in 101h: %d/%d, expected 4368/4368' % (r6['bx'], r6['cx']))
    chk(seq.get(0x1A, 0) & 0x20 == 0, 'pedestal: SR1A bit 5 set in 101h')
    m.r['crtc'][0x90] = cr.get(0x90, 0) | 0x80        # as a VESA mode leaves it
    m.int10(0x0003)
    chk(cr.get(0x59, 0) == base and cr.get(0x5A, 0) == 0,
        'base restore: mode 03 after 101h has CR59/5A = %02X/%02X, expected %02X/00'
        % (cr.get(0x59, 0), cr.get(0x5A, 0), base))
    chk(cr.get(0x90, 0) & 0x80 == 0, 'FIFO fix: CR90 bit 7 still set after mode 03 (CR90 = %02X)' % cr.get(0x90, 0))
    chk(cr.get(0x58, 0) & 0x10 == 0, 'base restore: linear addressing still on in mode 03')
    m.int10(0x4F02, bx=0x4101)
    chk(m.int10(0x4F03)['bx'] == 0x4101, 'LFB: 4F03 in 4101h does not return 4101h')
    chk(cr.get(0x59, 0) == base, 'LFB: CR59 in 4101h = %02X, expected the real base %02X' % (cr.get(0x59, 0), base))
    m.int10(0x4F02, bx=0x0151)
    chk(cr.get(0x50, 0) == 0x40, 'CR50: 151h (512x384x8) has CR50 = %02X, expected 40h' % cr.get(0x50, 0))
    # timings
    for mode, want, hpix, what in TIMINGS:
        m.int10(0x4F01, cx=mode, es=0x3000, di=0)
        xres = struct.unpack('<H', m.mem(0x30012, 2))[0]
        m.int10(0x4F02, bx=mode)
        hz, h = refresh(m, xres)
        if hz is None or abs(hz - want) > 0.5:
            fails.append('timing %03Xh (%s): %s Hz, expected %.1f' % (mode, what, 'unknown' if hz is None
                                                                       else '%.1f' % hz, want))
        elif hpix and h != hpix:
            fails.append('timing %03Xh (%s): %d pixels per line, expected %d' % (mode, what, h, hpix))
    m.int10(0x0003)
    check(not fails, '%d of the patches missing or wrong:\n    ' % len(fails) + '\n    '.join(fails))
    return 'all patches present'


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


TESTS = [('post', t_post), ('rom_patches', t_rom_patches), ('vga_registers', t_vga_registers),
         ('vga_palettes', t_vga_palettes),
         ('s3test', t_s3test), ('vshow', t_vshow), ('s3compat_vga', t_s3compat_vga),
         ('vgalog', t_vgalog), ('s3alias', t_s3alias)]


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
