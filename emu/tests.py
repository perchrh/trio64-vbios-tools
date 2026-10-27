#!/usr/bin/env python3
"""tests.py - emulator tests for the Trio64V2 VBIOS and the DOS tools (needs python3 and unicorn).

    python3 emu/tests.py --rom S3V2P15.BIN [--build build] [-k name] [-v]
    make emu-test ROM=S3V2P15.BIN

The ROM image is not in the repository; pass the 64 KB image of the card. The tools run with /V;
their output (NAME.LOG) and debug files (NAME.DBG, VGALOG.BIN) are kept in emu/logs (--logs).
Run against the stock ROM, s3test (and the FIFO line of rom_patches) list everything the patches add. The tools are taken from
--build (run make first). Each test prints PASS, FAIL (with the reason) or SKIP; the exit code is 1
when a test failed. The emulator models the VGA/S3 registers, one 64 KB planar window and a virtual clock
that drives the PIT, the BIOS tick and the retrace bit (see vgaemu.py). It has no banked or linear
video memory and no real bus speed, so those results stay with the hardware runs.

Tests
  version          the tests are for the newest ROM: common/version.inc ROMVER (what S3TEST expects) is
                   the level rompatch/s3patch.py builds (2.04.07-p15), and the ROM under test carries
                   that sign-on; an older ROM fails here
  post             the ROM initialises and hooks INT 10h into C000
  rom_patches      what S3TEST cannot check: sign-on ROMVER, the checksum and 32 KB size of the lower
                   half and the zero upper 32 KB (p15) in the file, the mode set clear (bank 0 zeroed, CR6A back to 0, EAX bits 31-16 kept
                   across 4F02), the fast 4F05 path (result, CR6A, EBX/EDX kept, at most 10 port
                   accesses), the window function by far call, EAX/ECX kept across the 32-bit VGA
                   clear and font load, the 32-bit registers kept across the p13 text and planar scrolls,
                   AH=09h and an AH=0Eh line feed that scrolls, and the FIFO fix (CR90 bit 7) with the bit set as the card leaves it
                   after a VESA mode; all failures listed. The other patches are S3TEST's checks
  vga_registers    every VGA mode in s3compat/vgaref.inc (incl. the 350-line text modes): the 62 standard
                   registers and the AH=1Bh state block equal the IBM reference
  vga_palettes     default DAC after each mode set: 256-colour table (13h), CGA (04h-06h, 0Dh, 0Eh),
                   EGA (all others)
  s3test           S3TEST runs to the end; every check passes except the two the model cannot judge
                   (banked memory, throughput); with /V the output is the same (except the Time spent
                   line) and S3TEST.DBG is well formed
  vshow            VSHOW 101 runs; with /V the output is the same and VSHOW.DBG is well formed; the
                   monitor note is in the /H and /? help of VSHOW, S3TEST and S3COMPAT, shown once
                   before the VSHOW /I list, and S3TEST, S3COMPAT and VSHOW (a mode, /A) print it on
                   stderr with a key prompt, where Esc cancels (/S prints nothing)
  s3compat_vga     S3COMPAT's VGA, Mode X and VGA BIOS function parts (built with nasm from the source
                   with the rest cut out): every test passes (registers, BIOS data, refresh, planar
                   memory, palettes, AH=01h-1Ch, AH=13h, CGA scroll, graphics XOR, AX=1120h-1124h, the
                   video save pointer table), only the known 8x14 font warnings (mode 10h, AX=1130h
                   BH=2, AX=1122h); with /V the output is the same and S3COMPAT.DBG is well formed
  s3compat_vbe     S3COMPAT's extra VBE function tests alone (4F00 capabilities vs 4F08, 4F04 per state mask,
                   invalid subfunctions and undefined functions refused, 4F0A table layout, 4F10 DPMS
                   states and SR0D sync control, 4F14 S3 OEM functions with the refresh rates measured):
                   all PASS, 4F15 INFO (the model has no DDC lines)
  s3compat_full    the whole S3COMPAT /Q (every VESA mode banked and linear, the S3 modes, the VESA
                   functions, pass 2): every line PASS except the known BIOS warnings (8x14 font, 106h
                   above the single-clock limit) and the lines that judge video memory through banks,
                   the LFB or planar windows above 64 KB, which the model does not have
  vgalog           VGALOG installs, logs 32 bytes per call and returns the BIOS results with the
                   caller's interrupt flag; second install refused, /H, /U closes the file and unhooks
  vgalog_mem       VGALOG /M keeps the calls in memory (AH=0Eh skipped, nested BIOS calls with their depth,
                   registers in and out, SR10/SR11 and CR58-5A/6D after), /D writes them in call order,
                   the S3 locks are put back, /U unhooks, /D afterwards is refused
  s3alias          S3ALIAS install, mapping 49h->59h and 4Bh->5Ah, refused second install, /H, /U
  s3regs           S3REGS.COM and S3REGS32.EXE (the Win32 one on a 32-bit CPU with the same register
                   model, vgaemu.run_pe32) write the same snapshot, keep indexes and locks, and
                   S3REGS32 /W logs register changes with their time (cursor registers ignored)
  mono             (emulator only) monochrome addressing: mode 07h from colour and back (CRTC port, MISC,
                   equipment word bits 4-5, BDA), text output, cursor and scrolls at B000, 350 lines,
                   mode 0Fh pixels and characters, every DCC table pair through AX=1A01h/1A00h, a mixed
                   sequence of mono and colour mode sets
  errors           (emulator only) invalid input changes nothing: undefined AH values keep every
                   register, invalid mode numbers, undefined AH=10h/11h/12h/1Ah subfunctions keep AL,
                   AX=1C03h, DF set by the caller, refused 4F02h modes, 4F09h at the last entry,
                   4F14h refusals (CR41/CR52/CR6B unchanged), 4F06h widths that do not fit
  windows          (emulator only) the ways Windows calls the BIOS, from Microsoft's documented
                   interfaces (VideoPortInt10, the INT 10h interface of Windows 2000 and later) and the
                   calls of S3's Windows 9x driver (4F00, 4F02, 4F08): 30 calls with DS = ES = a buffer
                   segment and garbage in the upper register halves give the same results, buffers
                   and video state as with clean registers and keep the upper halves; every call
                   returns with IF=0 and no timer tick; the driver sequence 4F00, 4F01 for every mode,
                   4F02, 4F08 to 8 bits, 4F09 palette, back to mode 03h (6-bit DAC, EGA palette, the
                   IBM registers); AH=00h with AL bit 7 keeps the text (IBM)
  display_switch   (emulator only) AH=12h BL=35h AL=02h: AL=12h and the state saved at ES:DX (IBM)
  -t cga,vbe       run only the tests with one of these categories (TAGS: mda cga ega vga vbe s3 rom
                   patch call tools card emu; --list shows them)
  stores           (emulator only) the p11-p14 speed patches write video memory with 32-bit stores: mode
                   set clears, text/planar/13h scrolls, AH=09h, font load (the share per operation)
  --vram 2|4       the video memory the CR36 strapping reports (2 MB, the card; 4 MB, the chip maximum)
  --tests a,b      run these tests in this order; -x stops at the first failure
  --noop SPEC      mutation test: INT 10h calls matching SPEC return unchanged (emu/mutants.py)
  --profile FILE   per test: the INT 10h calls and the ROM bytes it executes or reads (emu/mutants.py)
  --call-limit N   instructions an INT 10h call of a test may take (default 50 million)
  --coverage FILE  records the ROM bytes all tests execute and read, for emu/codemap.py (test coverage)
  dos_exe          the emulated DOS runs an MZ program built with nasm: relocation, memory blocks
                   (62h/4Ah/48h), and an INT 21h hook that turns the program's own AH=4Ch into AH=31h
"""
import argparse, os, re, shutil, struct, subprocess, sys, tempfile, time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from vgaemu import Machine, REGNAMES  # noqa: E402
from unicorn import UC_HOOK_INSN, UC_HOOK_MEM_WRITE  # noqa: E402
from unicorn.x86_const import (UC_X86_REG_EAX, UC_X86_REG_EBX, UC_X86_REG_ECX, UC_X86_REG_EDX, UC_X86_REG_ESI, UC_X86_REG_EDI,  # noqa: E402
                               UC_X86_REG_AX, UC_X86_REG_CX, UC_X86_REG_EBP, UC_X86_REG_IP, UC_X86_REG_SI, UC_X86_REG_DI, UC_X86_REG_BP,
                               UC_X86_REG_DS, UC_X86_REG_ES, UC_X86_REG_EFLAGS,
                               UC_X86_REG_BX, UC_X86_REG_DX, UC_X86_REG_CS, UC_X86_REG_SS, UC_X86_REG_SP,
                               UC_X86_INS_IN, UC_X86_INS_OUT)

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
def t_version(c):
    """The tests are for the newest ROM: S3TEST's expected version (common/version.inc) is the level
    s3patch.py builds, and the ROM under test carries that sign-on."""
    want = latest()
    check(romver() == want, 'common/version.inc ROMVER is %s, but rompatch/s3patch.py builds %s: update ROMVER'
          % (romver(), want))
    m = re.search(rb'Version ([0-9.]+(-p\d+)?)', c.rom[:0x100])
    got = m.group(1).decode() if m else '(no sign-on)'
    check(got == want, 'the ROM is %s, the tests are for the newest ROM %s (make rom ... OUT=S3V2%s.BIN)'
          % (got, want, want.split('-')[-1].upper()))
    return want


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
    """The ROM version S3TEST is built to expect (common/version.inc)."""
    t = open(os.path.join(SRC, 'common', 'version.inc')).read()
    return re.search(r"%define ROMVER '([^']*)'", t).group(1)


def latest():
    """The newest ROM version in the repository: the level rompatch/s3patch.py builds (2.04.07-p15)."""
    t = open(os.path.join(SRC, 'rompatch', 's3patch.py')).read()
    lv = re.search(r"^LEVEL = '([^']*)'", t, re.M).group(1)
    ver = re.search(r"^VERSION = '([^']*)'", t, re.M).group(1)
    return '%s-%s' % (ver, lv)


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
    chk(rom[2] == 0x40, 'ROM header size byte %02X, expected 40h (32 KB)' % rom[2])
    if len(rom) >= 0x10000:
        chk(rom[0x8000:0x10000] == bytes(0x8000), 'the upper 32 KB is not all zeros (p15)')
    cr = m.r['crtc']
    m.mu.mem_write(0xA0000, b'\x55' * 0x10000)
    m.mu.reg_write(UC_X86_REG_EAX, 0x12340000)        # p11 clears with 32-bit stores: EAX bits 31-16 kept
    m.int10(0x4F02, bx=0x0101)
    eaxh = m.mu.reg_read(UC_X86_REG_EAX) >> 16
    chk(eaxh == 0x1234, 'mode set: EAX bits 31-16 = %04X after 4F02 101h, the caller had 1234' % eaxh)
    chk(m.mem(0xA0000, 0x10000).count(0) == 0x10000, 'mode set clear: bank 0 at A0000 not zeroed by 4F02 101h')
    chk(cr.get(0x6A, 0) == 0, 'mode set clear: CR6A = %02X afterwards, expected bank 0' % cr.get(0x6A, 0))
    # p12: the fast 4F05 path from the INT 10h entry runs without the dispatcher, which saves the 32-bit
    # registers; it must keep them itself and use few port accesses
    io = [0]
    h1 = m.mu.hook_add(UC_HOOK_INSN, lambda uc, p, s, v, u: io.__setitem__(0, io[0] + 1), None, 1, 0, UC_X86_INS_OUT)
    h2 = m.mu.hook_add(UC_HOOK_INSN, lambda uc, p, s, u: io.__setitem__(0, io[0] + 1), None, 1, 0, UC_X86_INS_IN)
    for reg in (UC_X86_REG_EAX, UC_X86_REG_EBX, UC_X86_REG_EDX):
        m.mu.reg_write(reg, 0x56780000)
    res = m.int10(0x4F05, bx=0, dx=3)
    high = [m.mu.reg_read(reg) >> 16 for reg in (UC_X86_REG_EBX, UC_X86_REG_EDX)]
    m.mu.hook_del(h1)
    m.mu.hook_del(h2)
    chk(res['ax'] == 0x004F and cr.get(0x6A) == 3, '4F05 in 101h: AX=%04X CR6A=%02X' % (res['ax'], cr.get(0x6A, 0)))
    chk(high == [0x5678, 0x5678], '4F05: EBX/EDX bits 31-16 changed: %s' % ['%04X' % h for h in high])
    chk(io[0] <= 10, '4F05 set window: %d port accesses, the fast path needs at most 10' % io[0])
    m.int10(0x4F01, cx=0x0101, es=0x3000, di=0)        # the window function (far call) is unchanged
    off, seg = struct.unpack('<HH', m.mem(0x3000C, 4))
    m.mu.mem_write(0x7D10, b'\x9A' + struct.pack('<HH', off, seg) + b'\xF4')
    m.mu.reg_write(UC_X86_REG_BX, 0)
    m.mu.reg_write(UC_X86_REG_DX, 6)
    m.mu.reg_write(UC_X86_REG_CS, 0)
    m.mu.reg_write(UC_X86_REG_SS, 0)
    m.mu.reg_write(UC_X86_REG_SP, 0x7000)
    m.mu.emu_start(0x7D10, 0x7D15, count=100000)
    chk(cr.get(0x6A) == 6, 'window function (far call) BX=0 DX=6: CR6A = %02X' % cr.get(0x6A, 0))
    for ax, bx in ((0x0003, 0), (0x0013, 0), (0x1114, 0)):  # p12: 32-bit clear and font load, EAX kept
        m.mu.reg_write(UC_X86_REG_EAX, 0x9ABC0000 | ax)
        m.mu.reg_write(UC_X86_REG_ECX, 0x9ABC0000)
        m.int10(ax, bx=bx)
        high = [m.mu.reg_read(reg) >> 16 for reg in (UC_X86_REG_EAX, UC_X86_REG_ECX)]
        chk(high == [0x9ABC, 0x9ABC], 'AX=%04X: EAX/ECX bits 31-16 changed: %s' % (ax, ['%04X' % h for h in high]))
    # p13: the text and planar scroll fills, the window moves and AH=09h use EAX for 32-bit stores; AH=0Eh
    # reaches the scroll from its fast path without the dispatcher, so the helpers must keep EAX
    for mode, calls in ((0x03, ((0x0601, 0x1F00, 0, 0x184F), (0x0702, 0x0700, 0x0305, 0x0A15),
                                (0x0941, 0x001E, 5, 0))),
                        (0x12, ((0x0601, 0x0E00, 0, 0x1D4F), (0x0701, 0x0300, 0x0305, 0x0A16))),
                        (0x0D, ((0x0703, 0x0600, 0x0102, 0x0A10),))):
        m.int10(mode)
        for ax, bx, cx, dx in calls + ((0x0200, 0, 0, 0x184F if mode != 0x12 else 0x1D4F), (0x0E0A, 7, 0, 0)):
            for reg in (UC_X86_REG_EAX, UC_X86_REG_EBX, UC_X86_REG_ECX, UC_X86_REG_EDX, UC_X86_REG_ESI, UC_X86_REG_EDI):
                m.mu.reg_write(reg, 0x9ABC0000)
            m.int10(ax, bx=bx, cx=cx, dx=dx)
            high = [m.mu.reg_read(reg) >> 16 for reg in (UC_X86_REG_EAX, UC_X86_REG_ECX, UC_X86_REG_ESI, UC_X86_REG_EDI)]
            chk(high == [0x9ABC] * 4, 'mode %02X AX=%04X: EAX/ECX/ESI/EDI bits 31-16 changed: %s'
                % (mode, ax, ['%04X' % h for h in high]))
    m.r['crtc'][0x90] = cr.get(0x90, 0) | 0x80        # as a VESA mode leaves it on the card
    m.int10(0x0003)
    chk(cr.get(0x90, 0) & 0x80 == 0, 'FIFO fix: CR90 bit 7 still set after mode 03 (CR90 = %02X)' % cr.get(0x90, 0))
    check(not fails, '%d of the checks failed:\n    ' % len(fails) + '\n    '.join(fails))
    return 'ROM file and FIFO fix as expected'


# S3TEST lines that cannot pass in the emulator (no banked video memory, no real bus speed)
S3TEST_MODEL_LIMITS = ('Banked data check', 'Banked write throughput')
RESULT_RE = r'  (PASS|FAIL [0-9A-F]+|FAIL|WARN [0-9A-F]+|INFO)$'
CATS = ('ROM', 'MDA', 'CGA', 'EGA', 'VGA', 'VBE', 'S3')


def mode_cat(mode):
    """The category of a BIOS mode: the IBM adapter that introduced it, VBE for VESA modes."""
    if mode >= 0x100:
        return 'VBE'
    mode &= 0x7F
    return 'MDA' if mode in (7, 0x0F) else 'CGA' if mode <= 6 else 'EGA' if 0x0D <= mode <= 0x10 else 'VGA'


def tagged(text, tool):
    """The result lines of S3TEST/S3COMPAT as (category, line without the category column); every
    result line must start with a category in a 5-column field, and the summary by category at the
    end must count the same lines."""
    lines = text.split('\r\n')
    out = []
    last = None                                     # the test line a continuation line belongs to
    for l in lines:
        m = re.match(r'^(%s) +(?=\S)' % '|'.join(CATS), l)
        if m and m.end() == 5:
            last = m.group(1)
        if re.search(RESULT_RE, l.rstrip()):
            if l.startswith('      ') and last:     # the result after detail lines (S3COMPAT initial state)
                out.append((last, l.strip()))
                continue
            check(m and m.end() == 5, '%s: result line without a category column: %r' % (tool, l))
            out.append((m.group(1), l[5:].rstrip()))
    sums = {}
    for l in lines:
        m = re.match(r'^(%s) +PASS (\d+)  FAIL (\d+)(?:  WARN (\d+))?  INFO (\d+)$' % '|'.join(CATS), l)
        if m:
            sums[m.group(1)] = (int(m.group(2)), int(m.group(3)), int(m.group(4) or 0), int(m.group(5)))
    if sums:
        got = {}
        for cat, l in out:
            k = 0 if l.endswith('PASS') else 1 if re.search(r'FAIL( [0-9A-F]+)?$', l) else 2 if 'WARN' in l[-8:] else 3
            got.setdefault(cat, [0, 0, 0, 0])[k] += 1
        check({k: tuple(v) for k, v in got.items()} == sums, '%s: summary by category %s, the lines give %s'
              % (tool, sums, got))
    return out


def t_s3test(c):
    com = c.tool('S3TEST.COM')
    v = '/V' if has_verbose() else ''
    r1 = c.machine().run_com(com, v)
    c.save('S3TEST', r1)
    check(r1.exit and r1.exit[0] == 'exit', 'S3TEST did not end: %s' % (r1.exit,))
    out = r1.stdout.decode('latin1')
    check('Passed:' in out, 'no summary line')
    tl = tagged(out, 'S3TEST')
    results = [l for cat, l in tl if l.endswith(('PASS', 'FAIL'))]
    for cat, l in tl:
        m = re.match(r'Mode ([0-9A-F]{4}) ', l)
        check(not m or cat == mode_cat(int(m.group(1), 16) & 0xBFFF), 'S3TEST: %s line in category %s' % (l[:9], cat))
    check(len(results) >= 30, 'only %d result lines' % len(results))
    bad = [l.strip() for l in results if l.rstrip().endswith('FAIL') and not l.startswith(S3TEST_MODEL_LIMITS)]
    check(not bad, '%d checks not PASS:\n    ' % len(bad) + '\n    '.join(bad))
    if v:
        check_dbg(r1.files.get('S3TEST.DBG'), 'S3TEST.DBG')
        r0 = c.machine().run_com(com, '/S')
        check(no_time(r1.stdout) == no_time(r0.stdout), 'output differs without /V')
        check(b'kHz' not in bytes(r0.stderr or b''), 'S3TEST /S: the monitor warning is still printed')
    check(b'75 kHz' in bytes(r1.stderr or b'') and b'Press any key' in bytes(r1.stderr or b''),
          'S3TEST: no monitor warning with a key prompt on stderr')
    return 'exit code %d' % r1.exit[1]


def t_vshow(c):
    com = c.tool('VSHOW.COM')
    v = ' /V' if has_verbose() else ''
    r1 = c.machine().run_com(com, '101' + v)
    c.save('VSHOW', r1)
    check(r1.exit and r1.exit[0] == 'exit' and r1.exit[1] == 0, 'VSHOW 101 ended with %s' % (r1.exit,))
    check(b'75 kHz' in bytes(r1.stderr or b'') and b'Press any key to continue' in bytes(r1.stderr or b''),
          'VSHOW 101: no monitor warning with a key prompt on stderr')
    rh = c.machine().run_com(com, '/H')
    check(b'VSHOW' in rh.stdout and b'/L' in rh.stdout, '/H shows no parameter list')
    # the monitor note: in the /H help of VSHOW, S3TEST and S3COMPAT, and once before the /I list
    for tool, k in (('VSHOW.COM', 75), ('S3TEST.COM', 75), ('S3COMPAT.COM', 91)):
        for sw in ('/H', '/?'):
            r = rh if (tool, sw) == ('VSHOW.COM', '/H') else c.machine().run_com(c.tool(tool), sw)
            out = r.stdout.replace(b'\r\n', b' ')
            check(r.exit == ('exit', 0) and b'%d kHz' % k in out and b'CRT can be damaged' in out,
                  '%s %s: no monitor note in the help' % (tool, sw))
    for tool, k, arg in (('S3TEST.COM', 75, ''), ('S3COMPAT.COM', 91, ''), ('VSHOW.COM', 75, '101')):
        r = c.machine(keys=[0x011B]).run_com(c.tool(tool), arg)
        err = bytes(r.stderr or b'').replace(b'\r\n', b' ')
        check(r.exit == ('exit', 0) and b'%d kHz' % k in err and b'Press any key to continue' in err
              and b'PASS' not in bytes(r.stdout), '%s: the monitor warning, then Esc does not cancel' % tool)
    ri = c.machine(keys=[0x011B]).run_com(com, '/I')
    check(ri.exit == ('exit', 0) and b'75 kHz' in ri.stdout and b'Esc to cancel' in ri.stdout,
          'VSHOW /I: no monitor note before the list (Esc there quits)')
    r2 = c.machine(keys=[0x1C0D, 0x011B]).run_com(com, '/I')
    check(r2.stdout.count(b'75 kHz') == 1, 'VSHOW /I: the monitor note is not shown exactly once')
    if v:
        r0 = c.machine().run_com(com, '101 /S')
        check(no_time(r1.stdout) == no_time(r0.stdout), 'output differs without /V')
        check(b'kHz' not in bytes(r0.stderr or b''), 'VSHOW /S: the monitor warning is still printed')
        lines = check_dbg(r1.files.get('VSHOW.DBG'), 'VSHOW.DBG')
        check('D:TEST mode 0101' in lines, 'no D:TEST mode 0101')
        check(any(l.startswith('D:REG CR00:') for l in lines), 'no register dump')
        check(any(l.startswith('D:FRM n=31') for l in lines), 'no frame timing')


def no_time(out):
    """The output without the 'Time spent:' line of S3TEST and S3COMPAT (the run time differs with /V)."""
    return re.sub(rb'Time spent: [0-9.]+ s\r\n', b'', bytes(out))


def build_s3compat_vga(tmp):
    """S3COMPAT with POST/setup tests and everything after the VGA BIOS functions cut out."""
    nasm = shutil.which('nasm')
    if not nasm:
        raise Skip('nasm not found')
    t = open(os.path.join(SRC, 's3compat', 's3compat.asm')).read()
    cuts = [("        call setup\n        call post_tests\n", ""),
            ("        PS 13,10,'--- VESA BIOS ---',13,10\n",
             "        jmp emu_end\n        PS 13,10,'--- VESA BIOS ---',13,10\n"),
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


def build_s3compat_vbe(tmp):
    """S3COMPAT with only the VBE function tests of vesa_more (4F00/4F08, 4F04 masks, invalid and
    undefined functions, 4F0A table, 4F10, 4F15), which need no banked or linear video memory."""
    nasm = shutil.which('nasm')
    if not nasm:
        raise Skip('nasm not found')
    t = open(os.path.join(SRC, 's3compat', 's3compat.asm')).read()
    cuts = [("        call setup\n        call post_tests\n", ""),
            ("        mov byte [pass],1\n", "        mov byte [pass],1\n        call vesa_more\n        jmp emu_end\n"),
            ("        call cleanup\n", "        call cleanup\nemu_end:\n")]
    for a, b in cuts:
        check(t.count(a) == 1, 'cannot cut s3compat.asm at %r' % a[:40])
        t = t.replace(a, b)
    shutil.copy(os.path.join(SRC, 's3compat', 'vgaref.inc'), tmp)
    src = os.path.join(tmp, 's3cvbe.asm')
    open(src, 'w').write(t)
    out = os.path.join(tmp, 'S3CVBE.COM')
    inc = os.path.join(SRC, 'common') + os.sep
    subprocess.run([nasm, '-f', 'bin', '-i' + inc, '-i' + tmp + os.sep, '-o', out, src], check=True, cwd=tmp)
    return open(out, 'rb').read()


def t_s3compat_vbe(c):
    with tempfile.TemporaryDirectory() as tmp:
        com = build_s3compat_vbe(tmp)
    r = c.machine().run_com(com, '')
    c.save('S3CVBE', r)
    check(r.exit and r.exit[0] == 'exit', 'S3COMPAT did not end: %s' % (r.exit,))
    lines = [l for _, l in tagged(r.stdout.decode('latin1'), 'S3COMPAT')]
    names = ('4F00 capabilities', '4F04 state masks', 'VBE invalid', 'VBE undefined', '4F0A table',
             '4F10 power', '4F15 DDC', '4F14 S3 OEM', 'DCLK VCO')
    tests = [l for l in lines if l.startswith(names) and re.search(r'  (PASS|FAIL [0-9A-F]+|WARN [0-9A-F]+|INFO)$', l)]
    check(len(tests) == len(names), 'only %d of the %d VBE lines: %s' % (len(tests), len(names), tests))
    # the model has no DDC lines: 4F15 must say so (INFO), everything else PASS
    bad = [l.strip() for l in tests if not l.rstrip().endswith('PASS') and
           not (l.startswith('4F15') and l.rstrip().endswith('INFO'))]
    check(not bad, '%d tests not PASS:\n    ' % len(bad) + '\n    '.join(bad))
    return '%d tests' % len(tests)


def t_s3compat_vga(c):
    with tempfile.TemporaryDirectory() as tmp:
        com = build_s3compat_vga(tmp)
    v = '/V' if has_verbose() else ''
    r0 = c.machine().run_com(com, v)
    c.save('S3COMPAT', r0)
    check(r0.exit and r0.exit[0] == 'exit', 'S3COMPAT did not end: %s' % (r0.exit,))
    lines = r0.stdout.decode('latin1').split('\r\n')
    tl = tagged(r0.stdout.decode('latin1'), 'S3COMPAT')
    tests = [l for _, l in tl]
    for cat, l in tl:
        m = re.match(r'Mode ([0-9A-F]{2})h', l)
        check(not m or cat == mode_cat(int(m.group(1), 16)), 'S3COMPAT: %s in category %s' % (l[:12], cat))
    vga = [l for l in tests if l.startswith(('Mode ', 'Text 80x50'))]
    func = [l for l in tests if l.startswith(('AH=', 'AX=', 'DAC '))]
    check(len(vga) >= 17 + 6, 'only %d VGA/Mode X lines' % len(vga))
    check(len(func) >= 35, 'only %d VGA BIOS function lines' % len(func))
    known = (('Mode 10h', 'WARN 01'), ('AX=1130 BH=2', 'WARN 01'), ('AX=1120-1124', 'WARN 01'),   # no 8x14 font
             ('Chip ID', 'INFO'), ('AH=12 BL=20', 'WARN 01'))     # 2.04.07 has no alternate print screen
    bad = [l.strip() for l in tests if not l.rstrip().endswith('PASS') and
           not any(l.startswith(a) and l.rstrip().endswith(b) for a, b in known)]
    details = [l.strip() for l in lines if l.startswith('      ')]
    check(not bad, '%d tests not PASS:\n    ' % len(bad) + '\n    '.join(bad + details[:6]))
    if v:
        r1 = c.machine().run_com(com, '/S')
        check(b'kHz' not in bytes(r1.stderr or b''), 'S3COMPAT /S: the notice is still printed')
        check(no_time(r1.stdout) == no_time(r0.stdout), 'output differs without /V')
        dl = check_dbg(r0.files.get('S3COMPAT.DBG'), 'S3COMPAT.DBG')
        check(sum(1 for l in dl if l.startswith('D:TEST')) >= len(tests), 'fewer D:TEST records than tests')
    return '%d tests' % len(tests)


# S3COMPAT lines that judge video memory through the 64 KB banks, the LFB (INT 15h AH=87h) or a planar
# window above 64 KB, which the model does not have; and the known warnings of the BIOS itself
S3COMPAT_MODEL_LIMITS = [r'VESA 4[0-9A-F]{3} linear .*WARN 20$', r'VESA 010[46] .*FAIL 0020$',
                         r'4F05 bank set/get \+ WinFuncPtr .*FAIL 0004$',
                         r'Banked window and LFB same memory .*WARN 01$']
S3COMPAT_KNOWN = [r'Mode 10h .*WARN 01$', r'AX=1130 BH=2 8x14 font .*WARN 01$', r'AX=1120-1124 .*WARN 01$',
                  r'VESA 0106 .*WARN 02$', r'AH=12 BL=20 .*WARN 01$',       # no alternate print screen
                  r'.*INFO$']
# with 4 MB the BIOS (2.04.07, unchanged by the patches) offers modes whose default DCLK is above the
# datasheet maximum for their depth (50 MHz at 32 bpp, 95 MHz at 15/16 bpp): WARN 02, as 106h
S3COMPAT_KNOWN_4MB = [r'VESA 0118 .*WARN 02$', r'VESA 0164 .*WARN 02$', r'VESA 0119 .*WARN 02$',
                      r'VESA 011A .*WARN 02$']


def t_s3compat_full(c):
    """The whole S3COMPAT (/Q: without the 2 MB VRAM pattern test) on the model."""
    com = c.tool('S3COMPAT.COM')
    r = c.machine().run_com(com, '/Q', max_insn=3_000_000_000)
    c.save('S3CFULL', r)
    check(r.exit and r.exit[0] == 'exit', 'S3COMPAT did not end: %s' % (r.exit,))
    tests = [l for _, l in tagged(r.stdout.decode('latin1'), 'S3COMPAT')]
    check(len(tests) >= 230, 'only %d result lines' % len(tests))
    bad = [l.strip() for l in tests if not l.endswith('PASS') and
           not any(re.match(p, l) for p in S3COMPAT_MODEL_LIMITS + S3COMPAT_KNOWN +
                   (S3COMPAT_KNOWN_4MB if Machine.vram == 4 else []))]
    check(not bad, '%d lines not PASS:\n    ' % len(bad) + '\n    '.join(bad))
    lim = sum(1 for l in tests if any(re.match(p, l) for p in S3COMPAT_MODEL_LIMITS))
    return '%d lines, %d judged by memory the model lacks' % (len(tests), lim)


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


# ---------------------------------------------------------------- emulator-only suites
# These change the equipment word, switch between the monochrome and the colour adapter addressing
# and feed the BIOS invalid input: harmless on the model, not something to do to the test machine.
# Expected values from the IBM PC AT and PS/2 BIOS interface (INT 10h) and the VBE 2.0 specification.

def int10x(m, ax, bx=0, cx=0, dx=0, si=0, di=0, bp=0, es=0, std=False):
    """INT 10h like Machine.int10, optionally with DF set by the caller; returns all 16-bit registers."""
    mu = m.mu
    mu.mem_write(0x7D00, (b'\xFD' if std else b'\xFC') + b'\xCD\x10\xF4')
    for reg, v in ((UC_X86_REG_AX, ax), (UC_X86_REG_BX, bx), (UC_X86_REG_CX, cx), (UC_X86_REG_DX, dx),
                   (UC_X86_REG_SI, si), (UC_X86_REG_DI, di), (UC_X86_REG_BP, bp)):
        mu.reg_write(reg, v)
    for reg, v in ((UC_X86_REG_CS, 0), (UC_X86_REG_SS, 0), (UC_X86_REG_SP, 0x7000), (UC_X86_REG_DS, 0),
                   (UC_X86_REG_ES, es), (UC_X86_REG_EFLAGS, 0x202)):
        mu.reg_write(reg, v)
    mu.emu_start(0x7D00, 0x7D03, count=Machine.call_limit)
    if mu.reg_read(UC_X86_REG_IP) != 0x7D03:
        raise AssertionError('INT 10h AX=%04X did not return within %d instructions' % (ax, Machine.call_limit))
    return {k: mu.reg_read(r) for k, r in (('ax', UC_X86_REG_AX), ('bx', UC_X86_REG_BX), ('cx', UC_X86_REG_CX),
                                            ('dx', UC_X86_REG_DX), ('si', UC_X86_REG_SI), ('di', UC_X86_REG_DI),
                                            ('bp', UC_X86_REG_BP), ('es', UC_X86_REG_ES))}


def word(m, a):
    return struct.unpack('<H', m.mem(a, 2))[0]


def vga_state(m):
    """Standard VGA registers, BIOS data area, video memory and DAC (to see that nothing changed)."""
    r = m.r
    return (r['misc'], tuple(r['seq'].get(i, 0) for i in range(5)), tuple(r['crtc'].get(i, 0) for i in range(0x19)),
            tuple(r['gc'].get(i, 0) for i in range(9)), tuple(r['atc'].get(i, 0) for i in range(0x15)),
            m.mem(0x400, 0x100), m.mem(0xA0000, 0x20000), tuple(bytes(p) for p in m.planes), tuple(map(tuple, m.dac)))


def text_pattern(r, c):
    return ((7 * c + 13 * r) & 0xFF) | ((((5 * c + 11 * r) & 0x7F) | 0) << 8)


def t_mono(c):
    """Monochrome addressing (mode 07h at B000, CRTC at 3B4h, mode 0Fh) and the equipment word."""
    m = c.machine()
    fails = []

    def chk(cond, what):
        if not cond:
            fails.append(what)

    def setequip(bits):
        m.mu.mem_write(0x410, struct.pack('<H', (word(m, 0x410) & ~0x30) | bits))
    # 1. mode 07h from colour, mode 03h back: CRTC port, MISC bit 0, equipment bits 4-5 (IBM VGA BIOS:
    #    30h for the monochrome modes, 20h for 80-column colour), geometry
    for eq in (0x20, 0x30):
        setequip(eq)
        m.int10(0x07)
        chk(word(m, 0x463) == 0x3B4 and m.r['misc'] & 1 == 0, 'mode 07h (equipment %02X): CRTC %04X MISC %02X'
            % (eq, word(m, 0x463), m.r['misc']))
        chk(word(m, 0x410) & 0x30 == 0x30, 'mode 07h: equipment video bits %02X, expected 30h' % (word(m, 0x410) & 0x30))
        chk((m.mem(0x449, 1)[0], m.mem(0x44A, 1)[0], m.mem(0x484, 1)[0], m.mem(0x485, 1)[0]) == (7, 80, 24, 16),
            'mode 07h: BDA mode/columns/rows/height %s' % m.mem(0x449, 1).hex())
        m.int10(0x03)
        chk(word(m, 0x463) == 0x3D4 and m.r['misc'] & 1 == 1 and word(m, 0x410) & 0x30 == 0x20,
            'mode 03h after 07h: CRTC %04X MISC %02X equipment %02X' % (word(m, 0x463), m.r['misc'], word(m, 0x410) & 0x30))
    # 2. text in mode 07h: B000, cursor in the 3B4h CRTC
    m.int10(0x07)
    m.mu.mem_write(0xB0000, b''.join(struct.pack('<H', text_pattern(r, k)) for r in range(25) for k in range(80)))
    m.int10(0x0200, bx=0, dx=0x0102)
    m.int10(0x0951, bx=0x0070, cx=3)
    chk(m.mem(0xB0000 + (80 + 2) * 2, 6) == b'\x51\x70' * 3, 'mode 07h AH=09h: B000 cells %s' % m.mem(0xB0000 + 164, 6).hex())
    cr = m.r['crtc']
    chk((cr.get(0x0E, 0) << 8 | cr.get(0x0F, 0)) == 80 + 2, 'mode 07h cursor in CR0E/CR0F (3B4h): %04X'
        % (cr.get(0x0E, 0) << 8 | cr.get(0x0F, 0)))
    r = m.int10(0x0800, bx=0)
    chk(r['ax'] == 0x7051, 'mode 07h AH=08h: %04X' % r['ax'])
    m.int10(0x0E5A, bx=0)
    chk(m.mem(0xB0000 + (80 + 2) * 2, 2) == b'\x5A\x70', 'mode 07h AH=0Eh did not write at the cursor')
    # scroll up 2 in a window, down 1 full screen: every cell against the pattern
    m.mu.mem_write(0xB0000, b''.join(struct.pack('<H', text_pattern(r, k)) for r in range(25) for k in range(80)))
    m.int10(0x0602, bx=0x0700, cx=0x0305, dx=0x0A14)
    exp = [[text_pattern(r, k) for k in range(80)] for r in range(25)]
    for r in range(3, 11):
        for k in range(5, 21):
            exp[r][k] = text_pattern(r + 2, k) if r <= 8 else 0x0720
    m.int10(0x0701, bx=0x0F00, cx=0, dx=0x184F)
    exp = [[0x0F20] * 80] + exp[:24]
    got = struct.unpack('<2000H', m.mem(0xB0000, 4000))
    bad = [(r, k) for r in range(25) for k in range(80) if got[r * 80 + k] != exp[r][k]]
    chk(not bad, 'mode 07h AH=06h/07h: %d cells differ, first %s' % (len(bad), bad[:3]))
    # 3. 350 lines: 14-line characters (IBM: AH=12h BL=30h AL=1 then the mode set)
    m.int10(0x1201, bx=0x30)
    m.int10(0x07)
    chk(m.mem(0x485, 1)[0] == 14 and m.mem(0x484, 1)[0] == 24, 'mode 07h at 350 lines: height %d rows %d'
        % (m.mem(0x485, 1)[0], m.mem(0x484, 1)[0] + 1))
    m.int10(0x1202, bx=0x30)
    # 4. mode 0Fh (640x350 monochrome graphics, planes 0 and 2): pixel values 0, 1, 4, 5 read back,
    #    a character reads back, CRTC at 3B4h
    m.int10(0x0F)
    chk(word(m, 0x463) == 0x3B4 and word(m, 0x410) & 0x30 == 0x30, 'mode 0Fh: CRTC %04X equipment %02X'
        % (word(m, 0x463), word(m, 0x410) & 0x30))
    for k, v in enumerate((0, 1, 4, 5, 1, 0)):
        m.int10(0x0C00 | v, bx=0, cx=100 + k * 37, dx=50 + k * 41)
        r = m.int10(0x0D00, bx=0, cx=100 + k * 37, dx=50 + k * 41)
        chk(r['ax'] & 0xFF == v, 'mode 0Fh AH=0Ch/0Dh pixel %d: read %d' % (v, r['ax'] & 0xFF))
    m.int10(0x0200, bx=0, dx=0x0304)
    m.int10(0x0941, bx=0x0001, cx=1)
    r = m.int10(0x0800, bx=0)
    chk(r['ax'] & 0xFF == 0x41, "mode 0Fh AH=09h/08h: read %02X, expected 'A'" % (r['ax'] & 0xFF))
    m.int10(0x0601, bx=0, cx=0, dx=0x184F)       # up one row: the 'A' is now in row 2
    m.int10(0x0200, bx=0, dx=0x0204)
    r = m.int10(0x0800, bx=0)
    chk(r['ax'] & 0xFF == 0x41, "mode 0Fh AH=06h: 'A' not one row up (read %02X)" % (r['ax'] & 0xFF))
    # 5. display combination code: each pair of the BIOS's DCC table (save pointer table, secondary
    #    table, DCC table; 4-byte header, then 2 bytes an entry: the alternate, then the active display)
    #    set with AX=1A01h reads back with AX=1A00h as the same pair: BX in either order (the BIOS, as
    #    IBM's, gives the display that matches the current mono/colour addressing as the active one), and
    #    BDA 48Ah holds the index of that table entry (IBM PS/2)
    sp = struct.unpack('<HH', m.mem(0x4A8, 4))
    sec = struct.unpack('<HH', m.mem(sp[1] * 16 + sp[0] + 16, 4))
    pairs = []
    if sec != (0, 0):
        dcc = struct.unpack('<HH', m.mem(sec[1] * 16 + sec[0] + 2, 4))
        t = m.mem(dcc[1] * 16 + dcc[0], 4 + 2 * 16)
        pairs = [(t[5 + 2 * k], t[4 + 2 * k]) for k in range(min(t[0], 16))]    # (active, alternate)
    chk(pairs, 'no DCC table found through 0040:00A8')
    for k, (a, b) in enumerate(pairs):
        r1 = m.int10(0x1A01, bx=(b << 8) | a)
        r2 = m.int10(0x1A00)
        chk(r1['ax'] & 0xFF == 0x1A and r2['bx'] in ((b << 8) | a, (a << 8) | b) and pairs.index((a, b)) ==
            m.mem(0x48A, 1)[0], 'AX=1A01h BX=%04X: read back %04X, index %d (expected %d)'
            % ((b << 8) | a, r2['bx'], m.mem(0x48A, 1)[0], k))
    m.int10(0x1A01, bx=0x0008)
    # 6. mono and colour modes in turn: every switch leaves the BIOS data and MISC consistent
    for mode in (0x07, 0x12, 0x0F, 0x03, 0x07, 0x07, 0x01, 0x0F, 0x13, 0x07):
        m.int10(mode)
        mono = mode in (0x07, 0x0F)
        chk(m.mem(0x449, 1)[0] == mode and word(m, 0x463) == (0x3B4 if mono else 0x3D4) and
            (m.r['misc'] & 1) == (0 if mono else 1) and word(m, 0x410) & 0x30 == (0x30 if mono else 0x20),
            'mode %02X in the sequence: BDA %02X, CRTC %04X, MISC %02X, equipment %02X'
            % (mode, m.mem(0x449, 1)[0], word(m, 0x463), m.r['misc'], word(m, 0x410) & 0x30))
    m.int10(0x03)
    check(not fails, '%d of the checks failed:\n    ' % len(fails) + '\n    '.join(fails))
    return 'mode 07h/0Fh, equipment word, %d DCC pairs' % len(pairs)


def t_errors(c):
    """Invalid input: the BIOS must refuse it and change nothing."""
    m = c.machine()
    fails = []

    def chk(cond, what):
        if not cond:
            fails.append(what)

    m.int10(0x03)
    # 1. undefined functions: AH=14h-19h, 1Dh-4Eh, 50h-FFh return every register as given, change nothing
    s0 = vga_state(m)
    for ah in list(range(0x14, 0x1A)) + list(range(0x1D, 0x4F)) + list(range(0x50, 0x100)):
        ax = (ah << 8) | 0x5A
        r = int10x(m, ax, bx=0x2222, cx=0x4444, dx=0x6666, si=0x7777, di=0x8888, bp=0x9999, es=0x1234)
        chk(r == dict(ax=ax, bx=0x2222, cx=0x4444, dx=0x6666, si=0x7777, di=0x8888, bp=0x9999, es=0x1234),
            'AH=%02Xh changed registers: %s' % (ah, r))
    chk(vga_state(m) == s0, 'undefined functions changed the video state')
    # 2. invalid mode numbers for AH=00h: the mode stays (no mode in the BIOS tables)
    for mode in (0x14, 0x15, 0x16, 0x17, 0x18, 0x1B, 0x1F, 0x20, 0x60, 0x7F):
        m.int10(0x03)
        s0 = vga_state(m)
        m.int10(mode)
        chk(vga_state(m) == s0, 'AH=00h AL=%02Xh changed the video state (mode now %02X)' % (mode, m.mem(0x449, 1)[0]))
    # 3. undefined subfunctions: AH=10h, 11h, 12h, 1Ah keep AL (AL = 12h/1Ah means supported), change
    #    nothing
    m.int10(0x03)
    s0 = vga_state(m)
    bad = [(0x1000 | al, 0) for al in (0x04, 0x05, 0x06, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x11, 0x14, 0x16, 0x1C, 0x1D, 0x1F)]
    bad += [(0x1100 | al, 0) for al in (0x05, 0x06, 0x0F, 0x13, 0x15, 0x1F, 0x25, 0x2F, 0x31, 0x40)]
    bad += [(0x1200, bl) for bl in (0x00, 0x0F, 0x11, 0x1F, 0x21, 0x2F, 0x37, 0x3F, 0x40, 0xFF)]
    bad += [(0x1A02, 0), (0x1AFF, 0)]
    for ax, bl in bad:
        r = int10x(m, ax, bx=bl, cx=0, dx=0, es=0x3000)
        chk(r['ax'] == ax, 'AX=%04Xh BL=%02Xh: AX=%04X (AL changed: claims support)' % (ax, bl, r['ax']))
    chk(vga_state(m) == s0, 'undefined subfunctions changed the video state')
    s0 = vga_state(m)
    int10x(m, 0x1C03, cx=0x0007, bx=0, es=0x3000)      # AL=1Ch comes back for any AL (known), but no change
    chk(vga_state(m) == s0, 'AX=1C03h changed the video state')
    # 4. the caller's direction flag: a scroll and a string write with DF set give the same result
    for std in (False, True):
        m.int10(0x03)
        m.mu.mem_write(0xB8000, b''.join(struct.pack('<H', text_pattern(r, k)) for r in range(25) for k in range(80)))
        m.mu.mem_write(0x30000, b'Hello')
        int10x(m, 0x0602, bx=0x1E00, cx=0x0203, dx=0x0C30, std=std)
        int10x(m, 0x1301, bx=0x0007, cx=5, dx=0x1010, bp=0, es=0x3000, std=std)
        out = m.mem(0xB8000, 4000)
        if not std:
            ref = out
    chk(out == ref, 'DF set by the caller changes AH=06h/13h results')
    # 5. VBE: unsupported mode, invalid ranges, OEM errors
    m.int10(0x4F02, bx=0x0101)
    s0 = vga_state(m)
    # the modes of the 4F00h list that 4F01h marks unsupported (too large for the memory: 118h, 164h,
    # 119h, 11Ah with 2 MB), and numbers that are no mode at all
    m.mu.mem_write(0x30000, b'VBE2')
    m.int10(0x4F00, es=0x3000, di=0)
    loff, lseg = struct.unpack('<HH', m.mem(0x3000E, 4))
    big = []
    for k in range(120):
        v = word(m, lseg * 16 + loff + 2 * k)
        if v == 0xFFFF:
            break
        m.int10(0x4F01, cx=v, es=0x3000, di=0x400)
        if not m.mem(0x30400, 1)[0] & 1:
            big.append(v)
    if Machine.vram == 2:
        chk(set(big) >= {0x118, 0x164, 0x119, 0x11A}, '2 MB: 118h/164h/119h/11Ah not all marked unsupported: %s'
            % ' '.join('%03X' % v for v in big))
    m.int10(0x4F02, bx=0x0101)
    s0 = vga_state(m)
    for bx in big + [0x01FF, 0x017F, 0x0200]:
        r = m.int10(0x4F02, bx=bx)
        chk(r['ax'] != 0x004F, '4F02 BX=%04X accepted' % bx)
        chk(vga_state(m) == s0, '4F02 BX=%04X (refused) changed the video state' % bx)
    m.mu.mem_write(0x30000, bytes([0x15, 0x2A, 0x3F, 0]))    # 4F09h at the last entry: blue, green, red
    r = m.int10(0x4F09, bx=0, cx=1, dx=255, es=0x3000, di=0)
    chk(r['ax'] == 0x004F and tuple(m.dac[255]) == (0x3F, 0x2A, 0x15), '4F09 entry 255: %04X %s' % (r['ax'], m.dac[255]))
    s0 = vga_state(m)
    cr0 = {k: m.r['crtc'].get(k, 0) for k in (0x41, 0x52, 0x6B)}
    for bx, cx, di in ((0x0001, 0x0101, 59), (0x0001, 0x0101, 0), (0x0001, 0x0103, 100), (0x0301, 0x0101, 60),
                       (0x0801, 0x0101, 60), (0x0008, 0, 0), (0x000F, 0, 0), (0x0001, 0x0177, 60)):
        r = int10x(m, 0x4F14, bx=bx, cx=cx, di=di)
        chk(r['ax'] != 0x004F, '4F14 BX=%04X CX=%04X DI=%d accepted' % (bx, cx, di))
    chk({k: m.r['crtc'].get(k, 0) for k in (0x41, 0x52, 0x6B)} == cr0, '4F14 refused calls changed CR41/CR52/CR6B')
    r = m.int10(0x4F06, bx=0, cx=0xFFF8)
    if r['ax'] == 0x004F:                            # VBE 2.0: accepted only if the memory holds it
        chk(r['bx'] * r['dx'] <= Machine.vram * 1024 * 1024, '4F06 CX=FFF8h: %d bytes x %d lines do not fit %d MB'
            % (r['bx'], r['dx'], Machine.vram))
    m.int10(0x03)
    check(not fails, '%d of the checks failed:\n    ' % len(fails) + '\n    '.join(fails))
    return 'undefined functions and subfunctions, invalid modes, DF, VBE refusals'

R32 = (('eax', UC_X86_REG_EAX), ('ebx', UC_X86_REG_EBX), ('ecx', UC_X86_REG_ECX), ('edx', UC_X86_REG_EDX),
       ('esi', UC_X86_REG_ESI), ('edi', UC_X86_REG_EDI), ('ebp', UC_X86_REG_EBP))


def int10w(m, regs, ds=0, es=0, flags=0x202, count=None):
    """INT 10h with 32-bit registers and DS/ES as the Windows INT 10h interfaces pass them
    (VIDEO_X86_BIOS_ARGUMENTS / INT10_BIOS_ARGUMENTS). Returns the 32-bit registers, DS, ES; raises
    when the call does not return within count instructions (a hang)."""
    mu = m.mu
    mu.mem_write(0x7D00, b'\xCD\x10\xF4')
    for k, r in R32:
        mu.reg_write(r, regs.get(k, 0))
    for reg, v in ((UC_X86_REG_CS, 0), (UC_X86_REG_SS, 0), (UC_X86_REG_SP, 0x7000), (UC_X86_REG_DS, ds),
                   (UC_X86_REG_ES, es), (UC_X86_REG_EFLAGS, flags)):
        mu.reg_write(reg, v)
    mu.emu_start(0x7D00, 0x7D02, count=count or Machine.call_limit)
    if mu.reg_read(UC_X86_REG_IP) != 0x7D02 or mu.reg_read(UC_X86_REG_CS) != 0:
        raise AssertionError('INT 10h EAX=%08X did not return (hang at %04X:%04X)'
                             % (regs.get('eax', 0), mu.reg_read(UC_X86_REG_CS), mu.reg_read(UC_X86_REG_IP)))
    out = {k: mu.reg_read(r) for k, r in R32}
    out['ds'], out['es'] = mu.reg_read(UC_X86_REG_DS), mu.reg_read(UC_X86_REG_ES)
    return out


def t_windows(c):
    """The ways Windows calls the video BIOS (emulator only), from Microsoft's documented interfaces:
    VideoPortInt10 and the INT 10h interface of Windows 2000 and later pass 32-bit registers and DS/ES
    with a buffer below 1 MB; the calls may come with interrupts off (VDM, x86 BIOS emulator); the
    Windows 9x display driver of S3 uses 4F00, 4F02 and 4F08 (README, Windows 9x driver test)."""
    fails = []

    def chk(cond, what):
        if not cond:
            fails.append(what)

    BUF = 0x2000                                        # the buffer segment (Int10AllocateBuffer-like)
    calls = [('4F00', dict(eax=0x4F00, edi=0)), ('4F01 101h', dict(eax=0x4F01, ecx=0x101, edi=0x200)),
             ('4F01 111h', dict(eax=0x4F01, ecx=0x111, edi=0x200)), ('4F02 101h', dict(eax=0x4F02, ebx=0x101)),
             ('4F03', dict(eax=0x4F03)), ('4F05 set', dict(eax=0x4F05, ebx=0, edx=1)),
             ('4F05 get', dict(eax=0x4F05, ebx=0x100)), ('4F06 get', dict(eax=0x4F06, ebx=1)),
             ('4F06 set', dict(eax=0x4F06, ebx=0, ecx=1024)), ('4F07 set', dict(eax=0x4F07, ebx=0, ecx=8, edx=4)),
             ('4F07 get', dict(eax=0x4F07, ebx=1)), ('4F08 set 8', dict(eax=0x4F08, ebx=0x0800)),
             ('4F08 get', dict(eax=0x4F08, ebx=1)), ('4F09 set', dict(eax=0x4F09, ebx=0, ecx=16, edx=0, edi=0x300)),
             ('4F09 get', dict(eax=0x4F09, ebx=1, ecx=16, edx=0, edi=0x400)), ('4F0A', dict(eax=0x4F0A, ebx=0)),
             ('4F10 query', dict(eax=0x4F10, ebx=0, edi=0)), ('4F10 get', dict(eax=0x4F10, ebx=2)),
             ('4F14 query', dict(eax=0x4F14, ebx=0)), ('4F15 query', dict(eax=0x4F15, ebx=0, ecx=0)),
             ('4F02 3', dict(eax=0x4F02, ebx=3)), ('AH=0F', dict(eax=0x0F00)), ('AH=12 BL=10', dict(eax=0x1200, ebx=0x10)),
             ('AX=1A00', dict(eax=0x1A00)), ('AH=1B', dict(eax=0x1B00, ebx=0, edi=0x500)),
             ('AX=1C01', dict(eax=0x1C01, ecx=7, ebx=0x600)), ('AX=1C02', dict(eax=0x1C02, ecx=7, ebx=0x600)),
             ('AH=00 12h', dict(eax=0x0012)), ('AH=06', dict(eax=0x0600, ebx=0x0700, edx=0x1D4F)),
             ('AH=00 03h', dict(eax=0x0003))]
    # 32-bit callers: the same results with garbage in the upper halves, which stay as they were
    # (a 16-bit BIOS function returns 16-bit results; 4F0A returns ES = C000; the S3 OEM query 4F14
    # BL=00 returns ESI and EDI as 32-bit values, as BL=02 BH=03 does EDI)
    HI = 0xA55A0000
    runs = []
    for dirty in (False, True):
        m = c.machine()
        m.mu.mem_write(BUF * 16 + 0x300, bytes(range(64)))
        res = []
        for name, regs in calls:
            r = dict(regs)
            if dirty:
                r = {k: v | (HI ^ (i << 28)) for i, (k, v) in enumerate((k, r.get(k, 0)) for k, _ in R32)}
            o = int10w(m, r, ds=BUF, es=BUF)
            res.append((name, r, o, m.mem(BUF * 16, 0x800), vga_state(m)))
        runs.append(res)
    for (name, _, o0, b0, s0), (_, rin, o1, b1, s1) in zip(*runs):
        lo = lambda o: {k: (v & 0xFFFF if k[0] == 'e' else v) for k, v in o.items()}
        chk(lo(o0) == lo(o1), '%s: other 16-bit results with the upper halves set: %s / %s' % (name, lo(o0), lo(o1)))
        chk(b0 == b1, '%s: other buffer contents with the upper halves set' % name)
        chk(s0 == s1, '%s: other video state with the upper halves set' % name)
        hi = [k for k, _ in R32 if (o1[k] ^ rin[k]) & 0xFFFF0000 and not (name == '4F14 query' and k in ('esi', 'edi'))]
        chk(not hi, '%s: upper halves changed: %s' % (name, ', '.join('%s %08X->%08X' % (k, rin[k], o1[k]) for k in hi)))
        chk(o1['ds'] == BUF and (o1['es'] == BUF or name == '4F0A'), '%s: DS/ES not kept (%04X/%04X)' % (name, o1['ds'], o1['es']))
    # interrupts off and no timer tick (a VDM or the x86 BIOS emulator of 64-bit Windows may deliver
    # no IRQ 0): every call returns; mode sets, scroll, palette, DPMS, refresh, DDC
    m = c.machine()
    m._ticks = lambda: 0x1234
    for name, regs in calls + [('4F02 105h', dict(eax=0x4F02, ebx=0x105)), ('4F02 112h', dict(eax=0x4F02, ebx=0x112)),
                               ('4F10 off', dict(eax=0x4F10, ebx=0x0401)), ('4F10 on', dict(eax=0x4F10, ebx=0x0001)),
                               ('4F14 set', dict(eax=0x4F14, ebx=0x0001, ecx=0x101, edi=72)),
                               ('4F15 read', dict(eax=0x4F15, ebx=1, ecx=0, edx=0, edi=0)),
                               ('AH=00 13h', dict(eax=0x0013)), ('AH=00 03h', dict(eax=0x0003))]:
        try:                                            # the DDC read bit-bangs 128 bytes: 60M instructions
            int10w(m, regs, ds=BUF, es=BUF, flags=0x002, count=200_000_000 if name == '4F15 read' else None)
        except AssertionError as e:
            chk(False, '%s with IF=0 and no tick: %s' % (name, e))
    # the S3 Windows 9x driver: 4F00, 4F01 for the modes, 4F02, 4F08 to 8 bits, the palette, a mode
    # change, back to text. VBE 2.0: 4F08 BH = the width set; mode 03h after it as IBM's (6-bit DAC,
    # the EGA palette, the registers of vgaref.inc)
    ents, _ = read_vgaref()
    m = c.machine()
    m.mu.mem_write(BUF * 16, b'VBE2')
    o = int10w(m, dict(eax=0x4F00, edi=0), es=BUF)
    chk(o['eax'] & 0xFFFF == 0x4F and m.mem(BUF * 16, 4) == b'VESA', '4F00: %04X' % (o['eax'] & 0xFFFF))
    caps = m.mem(BUF * 16 + 10, 1)[0]
    loff, lseg = struct.unpack('<HH', m.mem(BUF * 16 + 14, 4))
    modes = []
    while len(modes) < 120:
        v = word(m, lseg * 16 + loff + 2 * len(modes))
        if v == 0xFFFF:
            break
        modes.append(v)
    for v in modes:
        o = int10w(m, dict(eax=0x4F01, ecx=v, edi=0x1000), es=BUF)
        chk(o['eax'] & 0xFFFF == 0x4F, '4F01 %03Xh: %04X' % (v, o['eax'] & 0xFFFF))
    for v in (0x101, 0x103, 0x105):
        o = int10w(m, dict(eax=0x4F02, ebx=v), es=BUF)
        chk(o['eax'] & 0xFFFF == 0x4F, '4F02 %03Xh: %04X' % (v, o['eax'] & 0xFFFF))
        o = int10w(m, dict(eax=0x4F08, ebx=0x0800))
        if caps & 1:
            chk(o['eax'] & 0xFFFF == 0x4F and (o['ebx'] >> 8) & 0xFF == 8, '%03Xh 4F08 to 8 bits: AX=%04X BH=%d'
                % (v, o['eax'] & 0xFFFF, (o['ebx'] >> 8) & 0xFF))
            o = int10w(m, dict(eax=0x4F08, ebx=1))
            chk((o['ebx'] >> 8) & 0xFF == 8, '%03Xh 4F08 get after set 8: BH=%d' % (v, (o['ebx'] >> 8) & 0xFF))
        pal = bytes((3 * i + k * 85) & 0xFF for i in range(256) for k in range(4))
        m.mu.mem_write(BUF * 16 + 0x2000, pal)
        int10w(m, dict(eax=0x4F09, ebx=0, ecx=256, edx=0, edi=0x2000), es=BUF)
        o = int10w(m, dict(eax=0x4F09, ebx=1, ecx=256, edx=0, edi=0x3000), es=BUF)
        rd = m.mem(BUF * 16 + 0x3000, 1024)
        width = 8 if caps & 1 else 6
        msk = 0xFF if width == 8 else 0x3F
        exp = bytes((b & msk) if k % 4 != 3 else rd[k] for k, b in enumerate(pal))
        chk(o['eax'] & 0xFFFF == 0x4F and rd == exp, '%03Xh 4F09 palette not read back as written (%d bits)' % (v, width))
    o = int10w(m, dict(eax=0x0003))
    o = int10w(m, dict(eax=0x4F08, ebx=1))
    chk((o['ebx'] >> 8) & 0xFF == 6, 'mode 03h after the driver: DAC width %d bits, expected 6' % ((o['ebx'] >> 8) & 0xFF))
    d = m.dac_bytes()
    chk(all(tuple(d[3 * i:3 * i + 3]) == ega(i) for i in range(64)), 'mode 03h after the driver: not the EGA palette')
    regs3 = [e for e in ents if e[0] == 3 and not e[1] & 0x80][0][2]
    snap = m.snapshot()
    sr4 = lambda j, v: v & 0xFE if REGNAMES[j] == 'SR4' else v     # SR4 bit 0 reserved (as vga_registers)
    diff = [REGNAMES[j] for j, (a, e) in enumerate(zip(snap, regs3)) if REGNAMES[j] != 'SR0' and sr4(j, a) != sr4(j, e)]
    chk(not diff, 'mode 03h after the driver: registers differ from IBM: %s' % ' '.join(diff))
    # AH=00h with AL bit 7 (IBM: keep video memory; BDA 0487h bit 7 set while the mode runs)
    m.int10(0x03)
    m.mu.mem_write(0xB8000, b''.join(struct.pack('<H', text_pattern(r, k)) for r in range(25) for k in range(80)))
    keep = m.mem(0xB8000, 4000)
    m.int10(0x83)
    chk(m.mem(0xB8000, 4000) == keep, 'AH=00h AL=83h cleared the text')
    chk(m.mem(0x449, 1)[0] == 3 and m.mem(0x487, 1)[0] & 0x80, 'AH=00h AL=83h: BDA mode %02X, 0487h %02X'
        % (m.mem(0x449, 1)[0], m.mem(0x487, 1)[0]))
    m.int10(0x03)
    chk(m.mem(0xB8000, 4) == b'\x20\x07\x20\x07' and not m.mem(0x487, 1)[0] & 0x80, 'AH=00h AL=03h after 83h: no clear')
    check(not fails, '%d of the checks failed:\n    ' % len(fails) + '\n    '.join(fails))
    return '%d calls with 32-bit registers, IF=0 without tick, the 9x driver sequence (%d modes)' % (len(calls), len(modes))


def t_display_switch(c):
    """AH=12h BL=35h display switch (emulator only: on the card AL=02h turns the video off). IBM: AL=02h
    switches the active video off and saves its state in the 128-byte buffer at ES:DX, AL = 12h when
    supported."""
    m = c.machine()
    m.int10(0x03)
    m.mu.mem_write(0x30000, b'\x55' * 128)
    r = m.int10(0x1202, bx=0x35, es=0x3000, dx=0)
    check(r['ax'] & 0xFF == 0x12, 'AX=1202h BL=35h: AL=%02X, expected 12h (supported)' % (r['ax'] & 0xFF))
    check(m.mem(0x30000, 128) != b'\x55' * 128, 'AX=1202h BL=35h: nothing saved in the switch state buffer')
    m.int10(0x1203, bx=0x35, es=0x3000, dx=0)
    m.int10(0x03)
    return 'AL=02h: AL=12h, state saved'


def t_stores(c):
    """The p11-p14 speed patches do their video memory work with 32-bit stores (the reference BIOS uses
    8- and 16-bit ones, the same result): the share of the bytes written to A0000-BFFFF by 4-byte stores,
    per operation. Only this shows that one of those patch sites is in place (emu/mutants.py)."""
    ops = [('mode set 03h (VGA clear, p14)', None, lambda m: m.int10(0x03), 90),
           ('mode set 12h (VGA clear)', None, lambda m: m.int10(0x12), 90),
           ('mode set 13h (VGA clear)', None, lambda m: m.int10(0x13), 90),
           ('03h AH=06h full clear (p13)', 0x03, lambda m: m.int10(0x0600, bx=0x0700, cx=0, dx=0x184F), 90),
           ('03h AH=06h window (p13 wmove/wfill)', 0x03, lambda m: m.int10(0x0602, bx=0x0700, cx=0x0205, dx=0x1440), 90),
           ('03h AH=07h window', 0x03, lambda m: m.int10(0x0702, bx=0x0700, cx=0x0205, dx=0x1440), 90),
           ('03h AH=09h page 0 (p13)', 0x03, lambda m: m.int10(0x0941, bx=0x0007, cx=200), 90),
           ('03h AH=09h page 1 (p13)', 0x03, lambda m: (m.int10(0x0501), m.int10(0x0941, bx=0x0107, cx=200)), 90),
           ('13h AH=06h full (p12)', 0x13, lambda m: m.int10(0x0608, bx=0x0100, cx=0, dx=0x1827), 90),
           ('13h AH=06h window (p12)', 0x13, lambda m: m.int10(0x0602, bx=0x0100, cx=0x0204, dx=0x1420), 90),
           ('12h AH=06h full (p13 bfill)', 0x12, lambda m: m.int10(0x0600, bx=0x0100, cx=0, dx=0x1D4F), 90),
           ('12h AH=06h window (p13 bfilla)', 0x12, lambda m: m.int10(0x0602, bx=0x0100, cx=0x0205, dx=0x1440), 5),
           ('03h AX=1114h font load (p12)', 0x03, lambda m: m.int10(0x1114, bx=0), 90)]
    fails = []
    for name, mode, fn, need in ops:
        m = c.machine()
        if mode is not None:
            m.int10(mode)
        sz = {}

        def wr(uc, acc, a, size, v, ud):
            sz[size] = sz.get(size, 0) + size
        h = m.mu.hook_add(UC_HOOK_MEM_WRITE, wr, None, 0xA0000, 0xBFFFF)
        fn(m)
        m.mu.hook_del(h)
        tot = sum(sz.values())
        pct = 100.0 * sz.get(4, 0) / tot if tot else 0
        if pct < need:
            fails.append('%s: %.0f%% of %d bytes by 32-bit stores, expected at least %d%%' % (name, pct, tot, need))
    check(not fails, '%d operations not 32-bit:\n    ' % len(fails) + '\n    '.join(fails))
    return '%d operations' % len(ops)


TESTS = [('version', t_version), ('post', t_post), ('rom_patches', t_rom_patches), ('vga_registers', t_vga_registers),
         ('vga_palettes', t_vga_palettes),
         ('s3test', t_s3test), ('vshow', t_vshow), ('s3compat_vga', t_s3compat_vga), ('s3compat_vbe', t_s3compat_vbe), ('s3compat_full', t_s3compat_full),
         ('vgalog', t_vgalog), ('vgalog_mem', t_vgalog_mem), ('s3alias', t_s3alias),
         ('s3regs', t_s3regs), ('dos_exe', t_dos_exe), ('mono', t_mono), ('errors', t_errors), ('windows', t_windows), ('display_switch', t_display_switch), ('stores', t_stores)]

# Categories of each test (tests.py -t, --list): the standard the expected values come from (mda, cga,
# ega, vga = the IBM BIOS of that adapter; vbe = VESA; s3 = the chip and its datasheet; rom = the image
# itself), patch (our changes to the reference BIOS), call (how the BIOS is called: registers, flags,
# invalid input), tools (our DOS tools, not the BIOS), and where it runs: card = a tool that also runs
# on the card, whose hardware log decides; emu = only in the emulator.
TAGS = {
    'version': 'rom emu', 'post': 'rom emu', 'rom_patches': 'rom patch emu',
    'vga_registers': 'mda cga ega vga emu', 'vga_palettes': 'cga ega vga emu',
    's3test': 'rom cga ega vga vbe s3 patch card', 'vshow': 'vbe tools card',
    's3compat_vga': 'cga ega vga card', 's3compat_vbe': 'vbe s3 card', 's3compat_full': 'cga ega vga vbe s3 card',
    'vgalog': 'tools card', 'vgalog_mem': 'tools card', 's3alias': 'tools card', 's3regs': 'tools s3 card',
    'dos_exe': 'tools emu', 'mono': 'mda emu', 'errors': 'call cga ega vga vbe emu',
    'windows': 'call vga vbe emu', 'display_switch': 'vga emu', 'stores': 'cga ega vga patch emu',
}


def main():
    ap = argparse.ArgumentParser(description='emulator tests for the Trio64V2 VBIOS tools')
    ap.add_argument('--rom', required=True, help='64 KB VBIOS image')
    ap.add_argument('--build', default=os.path.join(SRC, 'build'), help='folder with the built .COM files')
    ap.add_argument('-k', default='', help='run only tests whose name contains this text')
    ap.add_argument('-t', default='', help='run only tests with one of these categories (comma list: mda, cga, '
                    'ega, vga, vbe, s3, rom, patch, call, tools, card, emu)')
    ap.add_argument('--list', action='store_true', help='list the tests with their categories')
    ap.add_argument('-v', action='store_true', help='print tracebacks')
    ap.add_argument('--logs', default=os.path.join(HERE, 'logs'),
                    help='folder for the tool output and /V debug files (default emu/logs)')
    ap.add_argument('--coverage', metavar='FILE',
                    help='record which ROM bytes the tests execute and read (all machines together) into FILE '
                         '(32 KB of code flags, then 32 KB of data flags, for emu/codemap.py)')
    ap.add_argument('--tests', default='', help='comma list: run these tests in this order (default all)')
    ap.add_argument('-x', action='store_true', help='stop at the first failure')
    ap.add_argument('--noop', default='', metavar='SPEC',
                    help='mutation test: INT 10h calls matching SPEC do nothing, e.g. "ah=06" or '
                         '"ax=4F14,bl=02" (hex values; several patterns separated by ";"), see emu/mutants.py')
    ap.add_argument('--calls', metavar='FILE', help='write every distinct INT 10h call after POST (AX BX DL, '
                    'hex, one per line) to FILE (emu/mutants.py: which functions the tests call)')
    ap.add_argument('--profile', metavar='FILE', help='write per test the INT 10h calls and the ROM bytes of the '
                    'lower 32 KB it executes or reads to FILE (JSON, for emu/mutants.py: which tests can see a change)')
    ap.add_argument('--call-limit', type=int, default=Machine.call_limit,
                    help='instructions an INT 10h call of a test may take before it counts as a hang (default %d; '
                         'the 4F15h EDID read of the windows test has its own 200 million)' % Machine.call_limit)
    ap.add_argument('--vram', type=int, choices=(2, 4), default=2,
                    help='video memory the CR36 strapping reports: 2 MB (the card, default) or 4 MB (the '
                         '86C775 maximum; the model still has one 64 KB window, no banked or linear memory)')
    a = ap.parse_args()
    Machine.vram = a.vram
    assert set(TAGS) == {n for n, _ in TESTS}, 'TAGS and TESTS differ'
    if a.list:
        for n, _ in TESTS:
            print('%-15s %s' % (n, TAGS[n]))
        return
    Machine.call_limit = a.call_limit
    prof, cur = {}, ['']
    if a.profile:
        init0 = Machine.__init__

        def init_prof(self, *args, **kw):
            init0(self, *args, **kw)
            prof.setdefault(cur[0], {'cov': [], 'calls': set()})['cov'].append(self.track_coverage())
        Machine.__init__ = init_prof
        Machine.calls = set()
    if a.calls:
        Machine.calls = set()
    if a.noop:
        Machine.noop = [{k.strip().lower(): int(v, 16) for k, v in (f.split('=') for f in pat.split(','))}
                        for pat in a.noop.split(';')]
    covs = []
    if a.coverage:
        init = Machine.__init__

        def init_cov(self, *args, **kw):
            init(self, *args, **kw)
            covs.append(self.track_coverage())
        Machine.__init__ = init_cov
    c = Ctx(a.rom, a.build, a.v, a.logs)
    failed = 0
    tests = TESTS
    if a.tests:
        byname = dict(TESTS)
        tests = [(t, byname[t]) for t in a.tests.split(',')]
    for name, fn in tests:
        if a.k not in name:
            continue
        if a.t and not set(a.t.split(',')) & set(TAGS[name].split()):
            continue
        if a.x and failed:
            break
        cur[0] = name
        if a.profile:
            Machine.calls = prof.setdefault(name, {'cov': [], 'calls': set()})['calls']
        print('%-14s ' % name, end='', flush=True)       # the test that is running now
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
        print('%-60s %5.0fs' % (first, time.time() - t0) + ('\n' + rest if rest else ''), flush=True)
    print('%d failed; tool output and /V debug logs in %s' % (failed, a.logs))
    if a.calls:
        with open(a.calls, 'w') as f:
            for ax, bx, dl in sorted(Machine.calls):
                f.write('%04X %04X %02X\n' % (ax, bx, dl))
    if a.noop:
        print('noop: %d INT 10h calls matched %s' % (Machine.noop_hits, a.noop))
    if a.profile:
        import json
        out = {}
        for name, d in prof.items():
            touched = bytearray(0x8000)
            for cc, dd in d['cov']:
                for i in range(0x8000):
                    if cc[i] or dd[i]:
                        touched[i] = 1
            runs, i = [], 0
            while i < 0x8000:
                if touched[i]:
                    j = i
                    while j < 0x8000 and touched[j]:
                        j += 1
                    runs.append([i, j - 1])
                    i = j
                else:
                    i += 1
            out[name] = {'calls': sorted(d['calls']), 'rom': runs}
        with open(a.profile, 'w') as f:
            json.dump(out, f)
    if a.coverage:
        code, data = bytearray(0x8000), bytearray(0x8000)
        for cc, dd in covs:
            for i in range(0x8000):
                code[i] |= cc[i]
                data[i] |= dd[i]
        open(a.coverage, 'wb').write(bytes(code) + bytes(data))
        print('coverage of %d machines in %s: %d bytes executed, %d read as data'
              % (len(covs), a.coverage, sum(code), sum(data)))
    sys.exit(1 if failed else 0)


if __name__ == '__main__':
    main()
