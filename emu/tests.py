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
  version          the tests are for the newest ROM: the ROM under test carries the sign-on of its level in
                   common/version.inc (ROMVER 2.04.07-p21, VROMVER 1.03-08-p1, TROMVER 1.5-07-p2), where
                   the patchers read it and S3TEST expects it; an older ROM fails here
  post             the ROM initialises and hooks INT 10h into C000
  rom_patches      what S3TEST cannot check: sign-on ROMVER, the checksum and 32 KB size of the lower
                   half and the upper 32 KB a copy of it (#78; p15-p21 were built with zeros there) in the file, the mode set clear (bank 0 zeroed, CR6A back to 0, EAX bits 31-16 kept
                   across 4F02), the booster (p18: on after a banked 4F02, real base in CR6D; p16: on
                   after the window function by far call in AH=00 mode 59h; p17: off under Windows
                   enhanced mode, INT 2Fh AX=1600h asked once per mode set), the
                   fast 4F05 path (result, CR6A, EBX/EDX kept, at most 10 port accesses once the
                   booster is on), the window function by far call, EAX/ECX kept across the 32-bit VGA
                   clear and font load, the 32-bit registers kept across the p13 text and planar scrolls,
                   the mode 13h scroll (p21), AH=09h and an AH=0Eh line feed that scrolls, and the FIFO fix (CR90 bit 7) with the bit set as the card leaves it
                   after a VESA mode; all failures listed. The other patches are S3TEST's checks
  vplus_patches    (our Trio64V+ ROM 1.03-08-pN, rompatch/vplus, with --chip vplus) the ROM file (sign-on of
                   the level s3vpatch.py builds, checksum, 32 KB), the mode set clear (bank 0 zeroed, EAX
                   bits 31-16 kept), the booster (on after a banked 4F02 and the window function after AH=00
                   69h, off under Windows enhanced mode with INT 2Fh asked once per mode set, the PCI base
                   back in CR59/CR5A at the next mode set), the ATC flip-flop reset after the mode set, the
                   fast 4F05 path (result, CR6A, x4 in planar modes, the sequencer index and the 32-bit
                   registers kept, at most 6 port writes where 1.03-08 needs 10; BH=1 and a bad BH as
                   1.03-08), the 32-bit registers kept across the clears, font load, text, planar and 13h
                   scrolls, AH=09h and AH=0Eh; all failures listed. On this ROM the tests tagged patch run
                   only when tagged vplus too (version, stores, vplus_patches), and the failures 1.03-08
                   itself has (VPLUS_BASE: errors, windows, s3compat_full) pass with a note
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
                   above the single-clock limit, the CR86 and CR90/CR91 rules in 012Eh, 010Fh, 0131h,
                   0134h and 012Ah, which are clean on the card) and the lines that judge video memory through banks,
                   the LFB or planar windows above 64 KB, which the model does not have
  vgalog           VGALOG installs, writes the file header with the chip and ROM block (CR2D-CR30, CR36,
                   ROM size, SR10/SR11, the ROM version) and logs 32 bytes per call, returns the BIOS
                   results with the caller's interrupt flag; second install refused, /H, /U closes the
                   file and unhooks; /M and /T files carry the same block
  vgalog_mem       VGALOG /M keeps the calls in memory (AH=0Eh skipped, nested BIOS calls with their depth,
                   registers in and out, SR10/SR11 and CR58-5A/6D after), /D writes them in call order,
                   the S3 locks are put back, /U unhooks, /D afterwards is refused
  vgalog_trace     VGALOG /T: every OUT the BIOS makes in the mode sets AX=0003h and 4F02h 101h is in the
                   trace in order with its value, behind the marker of its call; other calls not traced,
                   INT 1 put back after each mode set, the trap flag clear on return
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
                   IBM registers); under Windows (INT 2Fh AX=1600h answering 04h) the driver's banked
                   4F02 calls (bit 15, CX = lines, DX = 3D4h, from VGALOG) leave CR59/CR5A at the PCI base, where the driver turns its linear window on;
                   AH=00h with AL bit 7 keeps the text (IBM)
  display_switch   (emulator only) AH=12h BL=35h AL=02h: AL=12h and the state saved at ES:DX (IBM)
  v2_writes        (emulator only, Trio64V2 model) the datasheet rules about writes (docs/chip-rules.md):
                   CR26 = 00h after CR39 = A5h on every mode set, with CR23 = 00h at that moment although
                   CR23 was 5Ah before the mode set (V2-REG-5, p19), CR40 bit 0 and CR66 bit 0 changed
                   only with the screen off or in vertical retrace (V2-REG-6); modes 03h, 12h, 13h, 101h,
                   111h, 112h
  post_delay       (p20) POST waits with RAM refresh off (CR88 bit 6) before the graphics engine reset
                   (CR66 = 02h): PIT channel 2 is loaded with 0014h there (0Ah in AX, doubled for mode
                   3), not with the CR88 word left in AX (8110h in 2.04.07 and 2.04.11)
  ddc              (p19) VBE 4F15 BL=00h, the DDC probe: AX = 004Fh, every access to the serial port
                   register (MMIO A000:FF20h) with interrupts off, the delays on PIT channel 2 set with
                   B6h (never the 86h latch command of 2.04.07) and the probe's 0255h delay loaded as
                   04AAh (the count in AX, doubled for mode 3); the model has no monitor, so BX = 0000h
  engine_init      (emulator only, Trio64V+/UV+/V2 models) a BIOS that uses the graphics engine writes
                   BEE8h index D and E before its first command (ENG-1); skipped when it uses none
  -t cga,vbe       run only the tests with one of these categories (TAGS: mda cga ega vga vbe s3 rom
                   patch call tools card emu vram; --list shows them; vram = depends on the memory size)
  stores           (emulator only) the p11-p14 speed patches write video memory with 32-bit stores: mode
                   set clears, text/planar/13h scrolls, AH=09h, font load (the share per operation)
  --chip v2|vplus|uvplus|trio64|trio32   the chip of the model (default v2, the card)
  --vram 1|2|4     the video memory CR36 reports (2 MB, the card; 4 MB, the chip maximum; 1 MB, a Trio64V+ or
                   Trio64 card before an upgrade). The BIOS finds the size at POST (it writes CR36 bits 7-5
                   after testing the last 64 KB of 4 and 2 MB); the model answers with the size given here
  -j N             run N tests at a time in separate processes (make emu-test uses every CPU)
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
from vgaemu import Machine, REGNAMES, CHIPS  # noqa: E402
from unicorn import UC_HOOK_INSN, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE  # noqa: E402
from unicorn.x86_const import (UC_X86_REG_EAX, UC_X86_REG_EBX, UC_X86_REG_ECX, UC_X86_REG_EDX, UC_X86_REG_ESI, UC_X86_REG_EDI,  # noqa: E402
                               UC_X86_REG_AX, UC_X86_REG_CX, UC_X86_REG_EBP, UC_X86_REG_IP, UC_X86_REG_SI, UC_X86_REG_DI, UC_X86_REG_BP,
                               UC_X86_REG_DS, UC_X86_REG_ES, UC_X86_REG_EFLAGS,
                               UC_X86_REG_BX, UC_X86_REG_DX, UC_X86_REG_CS, UC_X86_REG_SS, UC_X86_REG_SP,
                               UC_X86_INS_IN, UC_X86_INS_OUT)

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.dirname(HERE)


NASM = os.environ.get('NASM', 'nasm')   # the assembler for the tests that build code (--nasm, make NASM=...)


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
        # our patched BIOS (2.04.07-pN sign-on) or another one (the stock BIOS of a Trio64-family card):
        # the tests tagged 'patch' check our patches and are skipped on another BIOS
        self.ours = bool(re.search(rb'Version 2\.04\.07-p\d+', self.rom[:0x100]))
        # our Trio64V+ ROM (1.03-08-pN, rompatch/vplus): the tests tagged 'patch' run on it only when
        # they are tagged 'vplus' too (the shared speed patches, its own patch test)
        self.vours = bool(re.search(rb'Version 1\.03-08-p\d+', self.rom[:0x100]))
        # our Trio64 ROM (1.5-07-pN, rompatch/trio64): likewise with the tag t64
        self.tours = bool(re.search(rb'Version 1\.5-07-p\d+', self.rom[:0x100]))
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
    """The tests are for the newest ROM: the ROM under test carries the sign-on of the level in
    common/version.inc (ROMVER, VROMVER for our Trio64V+ ROM, TROMVER for our Trio64 ROM), which the
    patchers write and S3TEST expects."""
    vwant = latest('vplus/s3vpatch.py')
    twant = latest('trio64/s3tpatch.py')
    if c.tours:
        m = re.search(rb'Version ([0-9.]+-\d\d-p\d+)', c.rom[:0x100])
        got = m.group(1).decode() if m else '(no sign-on)'
        check(got == twant, 'the ROM is %s, the tests are for the newest Trio64 ROM %s (make trio64-rom OUT=...)' % (got, twant))
        return twant
    if c.vours:
        want = vwant
        m = re.search(rb'Version ([0-9.]+-\d\d-p\d+)', c.rom[:0x100])
        got = m.group(1).decode() if m else '(no sign-on)'
        check(got == want, 'the ROM is %s, the tests are for the newest Trio64V+ ROM %s (make vplus-rom OUT=...)' % (got, want))
        return want
    want = latest()
    m = re.search(rb'Version ([0-9.]+(-p\d+)?)', c.rom[:0x100])
    got = m.group(1).decode() if m else '(no sign-on)'
    check(got == want, 'the ROM is %s, the tests are for the newest ROM %s (make v2-rom ... OUT=S3V2%s.BIN)'
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
def romver(name='ROMVER'):
    """The ROM version S3TEST is built to expect (common/version.inc): ROMVER on a Trio64V2, VROMVER on a
    Trio64V+."""
    t = open(os.path.join(SRC, 'common', 'version.inc')).read()
    return re.search(r"%%define %s '([^']*)'" % name, t).group(1)


def latest(patcher='s3patch.py'):
    """The newest ROM version in the repository, which the patcher builds: common/version.inc, where the
    patchers read their level (ROMVER for rompatch/s3patch.py, 2.04.07-p21; VROMVER for
    'vplus/s3vpatch.py'; TROMVER for 'trio64/s3tpatch.py')."""
    return romver({'s3patch.py': 'ROMVER', 'vplus/s3vpatch.py': 'VROMVER', 'trio64/s3tpatch.py': 'TROMVER'}[patcher])


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
        chk(rom[0x8000:0x10000] in (rom[:0x8000], bytes(0x8000)), 'the upper 32 KB is neither a copy of the lower '
            '32 KB (#78) nor zeros (p15-p21 as built before)')
    cr = m.r['crtc']
    base = (cr.get(0x59, 0), cr.get(0x5A, 0))           # the PCI base the BIOS found at POST
    m.mu.mem_write(0xA0000, b'\x55' * 0x10000)
    m.mu.reg_write(UC_X86_REG_EAX, 0x12340000)        # p11 clears with 32-bit stores: EAX bits 31-16 kept
    m.int10(0x4F02, bx=0x0101)
    eaxh = m.mu.reg_read(UC_X86_REG_EAX) >> 16
    chk(eaxh == 0x1234, 'mode set: EAX bits 31-16 = %04X after 4F02 101h, the caller had 1234' % eaxh)
    chk(m.mem(0xA0000, 0x10000).count(0) == 0x10000, 'mode set clear: bank 0 at A0000 not zeroed by 4F02 101h')
    chk(cr.get(0x6A, 0) == 0, 'mode set clear: CR6A = %02X afterwards, expected bank 0' % cr.get(0x6A, 0))
    # p18: without Windows the banked 4F02 turns the booster on (64 KB linear window at A0000, the real
    # base kept in CR6D), so every bank switch path gets it; it stays on through 4F05
    chk(base[0] and not base[1] and cr.get(0x58, 0) & 0x13 == 0x10 and (cr.get(0x59, 0), cr.get(0x5A, 0)) == (0, 0x0A)
        and cr.get(0x6D) == base[0], 'booster not on after 4F02 101h: CR58 %02X, CR59/5A %02X%02X, CR6D %02X'
        % (cr.get(0x58, 0), cr.get(0x59, 0), cr.get(0x5A, 0), cr.get(0x6D, 0)))
    m.int10(0x4F05, bx=0, dx=0)
    chk(cr.get(0x58, 0) & 0x13 == 0x10 and (cr.get(0x59, 0), cr.get(0x5A, 0)) == (0, 0x0A) and cr.get(0x6D) == base[0],
        'booster not on after 4F05 in 101h: CR58 %02X, CR59/5A %02X%02X, CR6D %02X'
        % (cr.get(0x58, 0), cr.get(0x59, 0), cr.get(0x5A, 0), cr.get(0x6D, 0)))
    # p17/p18: under Windows enhanced mode (INT 2Fh AX=1600h returns AL=04h) the booster stays off after
    # 4F02 (CR58-5A as the reference, for the S3 Windows 9x driver) and after 4F05, and CR6D = 01h
    # remembers it, so INT 2Fh is asked once per mode set; the next mode set clears the mark and
    # without Windows the booster goes on again
    m.mu.mem_write(0x7E00, bytes.fromhex('b0042efe060800cf00'))  # mov al,4 / inc byte [cs:8] / iret
    ivt2f = m.mem(0x2F * 4, 4)
    m.mu.mem_write(0x2F * 4, struct.pack('<HH', 0, 0x07E0))
    m.int10(0x4F02, bx=0x0101)
    m.int10(0x4F05, bx=0, dx=1)
    m.int10(0x4F05, bx=0, dx=2)
    asked = m.mem(0x7E08, 1)[0]
    chk(cr.get(0x58, 0) & 0x10 == 0 and cr.get(0x59, 0) == base[0] and cr.get(0x6D) == 1 and cr.get(0x6A) == 2,
        'Windows: booster on or bank wrong (CR58 %02X, CR59/5A %02X%02X, CR6D %02X, CR6A %02X)'
        % (cr.get(0x58, 0), cr.get(0x59, 0), cr.get(0x5A, 0), cr.get(0x6D, 0), cr.get(0x6A, 0)))
    chk(asked == 1, 'Windows: INT 2Fh asked %d times in one mode, expected once' % asked)
    m.mu.mem_write(0x2F * 4, ivt2f)
    m.int10(0x4F02, bx=0x0101)
    chk(cr.get(0x58, 0) & 0x13 == 0x10 and cr.get(0x6D) == base[0],
        'no booster after Windows ended (the CR6D mark not cleared?): CR58 %02X, CR6D %02X'
        % (cr.get(0x58, 0), cr.get(0x6D, 0)))
    # p22: a linear base of 01xxxxxxh (CR6D = 01h while the booster is on, the value of wcheck's refusal
    # mark): the next mode set puts the base back and clears CR6D, and the booster goes on again
    m.int10(0x0003)
    cr[0x59] = 0x01
    m.int10(0x4F02, bx=0x0101)
    on1 = cr.get(0x58, 0) & 0x13 == 0x10 and cr.get(0x6D) == 0x01
    m.int10(0x0003)
    back = (cr.get(0x59, 0), cr.get(0x5A, 0), cr.get(0x6D, 0))
    m.int10(0x4F02, bx=0x0101)
    chk(on1 and back == (0x01, 0x00, 0x00) and cr.get(0x58, 0) & 0x13 == 0x10 and cr.get(0x6D) == 0x01,
        'base 01000000h: booster %s, after mode 03h CR59/5A/6D %02X %02X %02X (expected 01 00 00), then '
        'CR58 %02X CR6D %02X (booster expected on again)' % ('on' if on1 else 'off', back[0], back[1], back[2],
                                                             cr.get(0x58, 0), cr.get(0x6D, 0)))
    m.int10(0x0003)
    cr[0x59] = base[0]
    m.int10(0x4F02, bx=0x0101)
    m.int10(0x4F05, bx=0, dx=0)
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
    # p16: the window function turns the booster on too; it matters for the S3 modes set with INT 10h
    # AH=00 (59h = 101h), which do not pass the end of 4F02 (a program that never calls 4F05)
    m.int10(0x0059)
    chk(cr.get(0x58, 0) & 0x10 == 0, 'booster on after AH=00 59h: CR58 %02X' % cr.get(0x58, 0))
    m.mu.reg_write(UC_X86_REG_BX, 0)
    m.mu.reg_write(UC_X86_REG_DX, 2)
    m.mu.reg_write(UC_X86_REG_CS, 0)
    m.mu.reg_write(UC_X86_REG_SS, 0)
    m.mu.reg_write(UC_X86_REG_SP, 0x7000)
    m.mu.emu_start(0x7D10, 0x7D15, count=100000)
    chk(cr.get(0x58, 0) & 0x13 == 0x10 and cr.get(0x5A) == 0x0A and cr.get(0x6A) == 2,
        'window function (far call) in 101h: booster not on or bank wrong (CR58 %02X, CR5A %02X, CR6A %02X)'
        % (cr.get(0x58, 0), cr.get(0x5A, 0), cr.get(0x6A, 0)))
    for ax, bx in ((0x0003, 0), (0x0013, 0), (0x1114, 0)):  # p12: 32-bit clear and font load, EAX kept
        m.mu.reg_write(UC_X86_REG_EAX, 0x9ABC0000 | ax)
        m.mu.reg_write(UC_X86_REG_ECX, 0x9ABC0000)
        m.int10(ax, bx=bx)
        high = [m.mu.reg_read(reg) >> 16 for reg in (UC_X86_REG_EAX, UC_X86_REG_ECX)]
        chk(high == [0x9ABC, 0x9ABC], 'AX=%04X: EAX/ECX bits 31-16 changed: %s' % (ax, ['%04X' % h for h in high]))
    # p13: the text and planar scroll fills, the window moves and AH=09h use EAX for 32-bit stores; AH=0Eh
    # reaches the scroll from its fast path without the dispatcher, so the helpers must keep EAX; p21:
    # the mode 13h scroll (p12) too
    last = {0x03: 0x184F, 0x12: 0x1D4F, 0x13: 0x1827, 0x0D: 0x1827}
    for mode, calls in ((0x03, ((0x0601, 0x1F00, 0, 0x184F), (0x0702, 0x0700, 0x0305, 0x0A15),
                                (0x0941, 0x001E, 5, 0))),
                        (0x12, ((0x0601, 0x0E00, 0, 0x1D4F), (0x0701, 0x0300, 0x0305, 0x0A16))),
                        (0x13, ((0x0601, 0x0100, 0, 0x1827), (0x0602, 0x0100, 0x0204, 0x1420),
                                (0x0702, 0x0100, 0x0204, 0x1420))),
                        (0x0D, ((0x0703, 0x0600, 0x0102, 0x0A10),))):
        m.int10(mode)
        for ax, bx, cx, dx in calls + ((0x0200, 0, 0, last[mode]), (0x0E0A, 7, 0, 0)):
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


def t_vplus_patches(c):
    """Our Trio64V+ ROM (1.03-08-pN, rompatch/vplus): the ROM file, the booster with the Windows check,
    the base back at the next mode set, the fast 4F05 path and the window function, the attribute
    controller flip-flop after the mode set, the 32-bit registers kept across the 32-bit clears, font load
    and scrolls (the shared speed patches themselves: stores). Only on the Trio64V+ and UV+ models."""
    if not c.vours:
        raise Skip('not our Trio64V+ ROM (1.03-08-pN)')
    if Machine.chip not in ('vplus', 'uvplus'):
        raise Skip('Trio64V+ ROM (--chip vplus)')
    m = c.machine()
    fails = []

    def chk(cond, what):
        if not cond:
            fails.append(what)

    rom = c.rom
    chk(('Version ' + latest('vplus/s3vpatch.py')).encode() in rom[:0x100], 'sign-on: %s not in the first 256 bytes'
        % latest('vplus/s3vpatch.py'))
    chk(sum(rom[:0x8000]) & 0xFF == 0, 'checksum of the lower 32 KB is not 00')
    chk(rom[2] == 0x40, 'ROM header size byte %02X, expected 40h (32 KB)' % rom[2])
    if len(rom) > 0x8000:
        chk(rom[0x8000:] == rom[:0x8000], 'the upper 32 KB is not a copy of the lower 32 KB (#78)')
    cr = m.r['crtc']
    base = (cr.get(0x59, 0), cr.get(0x5A, 0))           # the PCI base, 1.03-08 keeps bits 31-24 in CR6B
    chk(base[0] and not base[1] and cr.get(0x6B) == base[0], 'POST: CR59/5A %02X%02X, CR6B %02X'
        % (base[0], base[1], cr.get(0x6B, 0)))

    def booster():
        return cr.get(0x58, 0) & 0x13 == 0x10 and (cr.get(0x59, 0), cr.get(0x5A, 0)) == (0, 0x0A)

    def regs():
        return 'CR58 %02X, CR59/5A %02X%02X, CR6B %02X, CR6D %02X, CR6A %02X' % tuple(
            cr.get(i, 0) for i in (0x58, 0x59, 0x5A, 0x6B, 0x6D, 0x6A))
    m.mu.mem_write(0xA0000, b'\x55' * 0x10000)
    m.mu.reg_write(UC_X86_REG_EAX, 0x12340000)        # the clear with 32-bit stores keeps EAX bits 31-16
    m.int10(0x4F02, bx=0x0101)
    eaxh = m.mu.reg_read(UC_X86_REG_EAX) >> 16
    chk(eaxh == 0x1234, 'mode set: EAX bits 31-16 = %04X after 4F02 101h, the caller had 1234' % eaxh)
    chk(m.mem(0xA0000, 0x10000).count(0) == 0x10000, 'mode set clear: bank 0 at A0000 not zeroed by 4F02 101h')
    # the banked 4F02 turns the booster on (64 KB linear window at A0000h); it stays on through 4F05
    chk(booster() and cr.get(0x6A, 0) == 0, 'booster not on after 4F02 101h: ' + regs())
    m.int10(0x4F05, bx=0, dx=1)
    chk(booster() and cr.get(0x6A) == 1, 'booster not on after 4F05 in 101h: ' + regs())
    # the next mode set puts the real base back (1.03-08 from CR6B, and the hook)
    m.r['aff'] = 1                                     # the ATC flip-flop at data: the hook resets it
    m.int10(0x0003)
    chk(cr.get(0x58, 0) & 0x10 == 0 and (cr.get(0x59, 0), cr.get(0x5A, 0)) == base,
        'mode 03h after the booster: base not back: ' + regs())
    chk(m.r['aff'] == 0, 'ATC flip-flop not reset after the mode set')
    m.int10(0x0013)
    chk(cr.get(0x58, 0) & 0x10 == 0, 'booster on in mode 13h: ' + regs())
    # under Windows enhanced mode (INT 2Fh AX=1600h returns AL=04h) the booster stays off after 4F02 and
    # after 4F05, and CR6D = 01h remembers it, so INT 2Fh is asked once per mode set; the next mode set
    # clears the mark and without Windows the booster goes on again
    m.mu.mem_write(0x7E00, bytes.fromhex('b0042efe060800cf00'))  # mov al,4 / inc byte [cs:8] / iret
    ivt2f = m.mem(0x2F * 4, 4)
    m.mu.mem_write(0x2F * 4, struct.pack('<HH', 0, 0x07E0))
    m.int10(0x4F02, bx=0x0101)
    m.int10(0x4F05, bx=0, dx=1)
    m.int10(0x4F05, bx=0, dx=2)
    asked = m.mem(0x7E08, 1)[0]
    chk(cr.get(0x58, 0) & 0x10 == 0 and cr.get(0x59, 0) == base[0] and cr.get(0x6D) == 1 and cr.get(0x6A) == 2,
        'Windows: booster on or bank wrong: ' + regs())
    chk(asked == 1, 'Windows: INT 2Fh asked %d times in one mode, expected once' % asked)
    m.mu.mem_write(0x2F * 4, ivt2f)
    m.int10(0x4F02, bx=0x0101)
    chk(booster() and cr.get(0x6D, 0) == 0, 'no booster after Windows ended (the CR6D mark not cleared?): ' + regs())
    # the fast 4F05 path from the INT 10h entry runs without the dispatcher: it keeps the registers
    # itself, puts the sequencer index back and writes fewer ports (1.03-08: 10 OUTs, the unlock of
    # CR38/CR39 twice and SR08 saved, set and restored; the fast path: 6)
    outs = [0]
    h1 = m.mu.hook_add(UC_HOOK_INSN, lambda uc, p, s, v, u: outs.__setitem__(0, outs[0] + 1), None, 1, 0, UC_X86_INS_OUT)
    for reg in (UC_X86_REG_EAX, UC_X86_REG_EBX, UC_X86_REG_ECX, UC_X86_REG_EDX, UC_X86_REG_ESI, UC_X86_REG_EDI):
        m.mu.reg_write(reg, 0x56780000)
    m.r['si'] = 0x02
    res = m.int10(0x4F05, bx=0, dx=3)
    high = [m.mu.reg_read(reg) >> 16 for reg in (UC_X86_REG_EBX, UC_X86_REG_ECX, UC_X86_REG_EDX, UC_X86_REG_ESI, UC_X86_REG_EDI)]
    m.mu.hook_del(h1)
    chk(res['ax'] == 0x004F and res['bx'] == 0 and res['dx'] == 3 and cr.get(0x6A) == 3,
        '4F05 in 101h: AX=%04X BX=%04X DX=%04X CR6A=%02X' % (res['ax'], res['bx'], res['dx'], cr.get(0x6A, 0)))
    chk(high == [0x5678] * 5, '4F05: 32-bit register halves changed: %s' % ['%04X' % h for h in high])
    chk(m.r['si'] == 0x02, '4F05: sequencer index %02X afterwards, the caller had 02h' % m.r['si'])
    chk(outs[0] <= 6, '4F05 set window: %d port writes, the fast path needs at most 6' % outs[0])
    res = m.int10(0x4F05, bx=0x0100)                   # get window: the normal path
    chk(res['ax'] == 0x004F and res['dx'] == 3, '4F05 BH=1: AX=%04X DX=%04X, expected 004F, bank 3'
        % (res['ax'], res['dx']))
    res = m.int10(0x4F05, bx=0x0200, dx=4)             # bad BH: refused by 1.03-08, bank unchanged
    chk(res['ax'] == 0x014F and cr.get(0x6A) == 3, '4F05 BH=2: AX=%04X CR6A=%02X, expected 014F, bank 3'
        % (res['ax'], cr.get(0x6A, 0)))
    m.int10(0x0012)                                    # planar: the bank is in 16 KB units (x4)
    m.int10(0x4F05, bx=0, dx=1)
    chk(cr.get(0x6A) == 4, '4F05 in mode 12h: CR6A = %02X, expected 04h (bank x 4)' % cr.get(0x6A, 0))
    # the window function (far call): bank set, and the booster on for the S3 mode set with INT 10h
    # AH=00 (69h = 101h), which does not pass the end of 4F02
    m.int10(0x0069)
    chk(cr.get(0x58, 0) & 0x10 == 0, 'booster on after AH=00 69h: ' + regs())
    m.int10(0x4F01, cx=0x0101, es=0x3000, di=0)
    off, seg = struct.unpack('<HH', m.mem(0x3000C, 4))
    m.mu.mem_write(0x7D10, b'\x9A' + struct.pack('<HH', off, seg) + b'\xF4')
    m.mu.reg_write(UC_X86_REG_BX, 0)
    m.mu.reg_write(UC_X86_REG_DX, 6)
    m.mu.reg_write(UC_X86_REG_CS, 0)
    m.mu.reg_write(UC_X86_REG_SS, 0)
    m.mu.reg_write(UC_X86_REG_SP, 0x7000)
    m.mu.emu_start(0x7D10, 0x7D15, count=100000)
    chk(booster() and cr.get(0x6A) == 6, 'window function (far call) in 69h: booster not on or bank wrong: ' + regs())
    for ax, bx in ((0x0003, 0), (0x0013, 0), (0x1114, 0)):  # 32-bit clear and font load: EAX/ECX kept
        m.mu.reg_write(UC_X86_REG_EAX, 0x9ABC0000 | ax)
        m.mu.reg_write(UC_X86_REG_ECX, 0x9ABC0000)
        m.int10(ax, bx=bx)
        high = [m.mu.reg_read(reg) >> 16 for reg in (UC_X86_REG_EAX, UC_X86_REG_ECX)]
        chk(high == [0x9ABC, 0x9ABC], 'AX=%04X: EAX/ECX bits 31-16 changed: %s' % (ax, ['%04X' % h for h in high]))
    # the text and planar scroll fills, window moves and AH=09h use EAX for 32-bit stores; AH=0Eh reaches
    # the scroll without the dispatcher, so the helpers keep the 32-bit registers
    for mode, calls in ((0x03, ((0x0601, 0x1F00, 0, 0x184F), (0x0702, 0x0700, 0x0305, 0x0A15),
                                (0x0941, 0x001E, 5, 0))),
                        (0x12, ((0x0601, 0x0E00, 0, 0x1D4F), (0x0701, 0x0300, 0x0305, 0x0A16))),
                        (0x13, ((0x0601, 0x0100, 0, 0x1827), (0x0602, 0x0100, 0x0204, 0x1420),
                                (0x0701, 0x0100, 0, 0x1827), (0x0702, 0x0100, 0x0204, 0x1420))),
                        (0x0D, ((0x0703, 0x0600, 0x0102, 0x0A10),))):
        m.int10(mode)
        for ax, bx, cx, dx in calls + ((0x0200, 0, 0, {0x12: 0x1D4F, 0x03: 0x184F}.get(mode, 0x1827)), (0x0E0A, 7, 0, 0)):
            for reg in (UC_X86_REG_EAX, UC_X86_REG_EBX, UC_X86_REG_ECX, UC_X86_REG_EDX, UC_X86_REG_ESI, UC_X86_REG_EDI):
                m.mu.reg_write(reg, 0x9ABC0000)
            m.int10(ax, bx=bx, cx=cx, dx=dx)
            high = [m.mu.reg_read(reg) >> 16 for reg in (UC_X86_REG_EAX, UC_X86_REG_ECX, UC_X86_REG_ESI, UC_X86_REG_EDI)]
            chk(high == [0x9ABC] * 4, 'mode %02X AX=%04X: EAX/ECX/ESI/EDI bits 31-16 changed: %s'
                % (mode, ax, ['%04X' % h for h in high]))
    check(not fails, '%d of the checks failed:\n    ' % len(fails) + '\n    '.join(fails))
    return 'booster, Windows check, fast 4F05, ATC flip-flop, 32-bit registers'


def t_t64_patches(c):
    """Our Trio64 ROM (1.5-07-pN, rompatch/trio64): the ROM file, the refresh defaults (no mode runs
    interlaced, 800x600 at 60 Hz), the removed interlaced-only modes refused, the booster with the Windows
    check (mark in CR52 bit 3, INT 2Fh asked once per mode set), the PCI base back after a mode set, the
    S3 register lock left as Phoenix leaves it, the ATC flip-flop reset, S3's fonts (AX=1130h, plane 2),
    4F15 without VDIF, the window function, the sequencer
    index kept by the window set and get (4F05 BH=0 and 1), the 32-bit
    registers kept across the clears, font load, scrolls, AH=09h and AH=0Eh, and the display FIFO M
    (CR54) within the memory bandwidth in the packed modes (p2). Only on the Trio64 model."""
    if not c.tours:
        raise Skip('not our Trio64 ROM (1.5-07-pN)')
    if Machine.chip != 'trio64':
        raise Skip('Trio64 ROM (--chip trio64)')
    m = c.machine()
    fails = []

    def chk(cond, what):
        if not cond:
            fails.append(what)

    rom = c.rom
    chk(('Version ' + latest('trio64/s3tpatch.py')).encode() in rom[:0x100], 'sign-on: %s not in the first 256 bytes'
        % latest('trio64/s3tpatch.py'))
    chk(sum(rom[:0x8000]) & 0xFF == 0, 'checksum of the lower 32 KB is not 00')
    chk(rom[2] == 0x40, 'ROM header size byte %02X, expected 40h (32 KB)' % rom[2])
    cr = m.r['crtc']
    base = (cr.get(0x59, 0), cr.get(0x5A, 0))

    def booster():
        return cr.get(0x58, 0) & 0x13 == 0x10 and (cr.get(0x59, 0), cr.get(0x5A, 0)) == (0, 0x0A)

    def regs():
        return 'CR58 %02X, CR59/5A %02X%02X, CR52 %02X, CR6A %02X, CR38/39 %02X/%02X' % tuple(
            cr.get(i, 0) for i in (0x58, 0x59, 0x5A, 0x52, 0x6A, 0x38, 0x39))
    chk(base[0] and not base[1] and cr.get(0x52, 0) == 0x80, 'POST: CR59/5A %02X%02X, CR52 %02X (expected 80h)'
        % (base[0], base[1], cr.get(0x52, 0)))
    # S3's fonts (1.03-08, the same as 2.04.07), all five tables whole: AX=1130h finds each, the moved 8x16
    # font and 9x16 table too
    vref = os.path.join(os.path.dirname(HERE), 'reference', '64vplus', '1_03_08.bin')
    if os.path.exists(vref):
        v = open(vref, 'rb').read()
        for bh, so, ln in ((3, 0x526C, 0x400), (4, 0x566C, 0x400), (2, 0x5A6C, 0xE00), (6, 0x6998, 0x1000),
                           (5, 0x686C, 301), (7, 0x7998, 324)):
            r = m.int10(0x1130, bx=bh << 8)
            chk(m.mem(r['es'] * 16 + r['bp'], ln) == v[so:so + ln], 'AX=1130h BH=%d: not S3\'s font' % bh)
        # the mode set and AX=1114h load them into plane 2 through the moved addresses: S3's 8x16 glyphs,
        # and in the 9-dot modes 03h and 07h all 19 of S3's 9x16 alternate glyphs on top
        alt = {v[0x7998 + i * 17]: v[0x7998 + i * 17 + 1:0x7998 + i * 17 + 17] for i in range(19)}
        for ax, nalt in ((0x0003, 19), (0x0007, 19), (0x1114, 0)):
            m.int10(ax)
            g = [bytes(m.planes[2][c * 32:c * 32 + 16]) for c in range(256)]
            plain = [c for c in range(256) if c not in alt and g[c] != v[0x6998 + c * 16:0x6998 + c * 16 + 16]]
            got = sum(g[c] == alt[c] for c in alt)
            chk(not plain and got == nalt, 'AX=%04X: plane 2 %d glyphs not S3\'s 8x16, %d of 19 alternate glyphs '
                '(expected %d)' % (ax, len(plain), got, nalt))
    # VBE 4F15 without VDIF (the model has no monitor on the DDC lines): BL=00h answers 004Fh with BX = 0000h
    # and BL=01h fails, as on 1.5-07, after its 50-frame watch for a DDC1 monitor (DDC1 kept); BL=02h, read
    # VDIF, fails at once (1.5-07 also watched 50 frames first)
    m.int10(0x0003)
    for bl, ax, bx, lo, hi in ((0, 0x004F, 0x0000, 45, 60), (1, 0x014F, 0x0001, 45, 60), (2, 0x014F, 0x0002, 0, 1)):
        t = m.t
        r = m.int10(0x4F15, bx=bl, es=0x3000, di=0)
        frames = (m.t - t) * 70 / 1193182
        chk(r['ax'] == ax and r['bx'] == bx and lo <= frames < hi, '4F15 BL=%d: AX=%04X BX=%04X, %.1f frames '
            '(expected %04X %04X, %d to %d frames)' % (bl, r['ax'], r['bx'], frames, ax, bx, lo, hi))
    # the defaults: no interlace, 800x600 at 60 Hz (line total 1056, VESA DMT)
    for mode in (0x101, 0x103, 0x105, 0x107, 0x111, 0x114, 0x117, 0x110, 0x116, 0x204, 0x205, 0x208):
        r = m.int10(0x4F02, bx=mode)
        if r['ax'] != 0x004F:
            continue
        chk(not cr.get(0x42, 0) & 0x20, 'mode %03Xh runs interlaced (CR42 %02X)' % (mode, cr.get(0x42, 0)))
    m.int10(0x4F02, bx=0x103)
    htotal = (cr.get(0x00, 0) + (0x100 if cr.get(0x5D, 0) & 1 else 0) + 5) * 8
    chk(htotal == 1056, '103h: line total %d, expected 1056 (800x600 at 60 Hz)' % htotal)
    for mode in (0x106, 0x118, 0x119, 0x11A, 0x120):
        r = m.int10(0x4F02, bx=mode)
        chk(r['ax'] == 0x014F, '4F02 %03Xh (removed, interlaced only): AX=%04X, expected 014F' % (mode, r['ax']))
    m.int10(0x4F00, es=0x3000, di=0)
    ptr = struct.unpack('<HH', m.mem(0x3000E, 4))
    lst = m.mem(ptr[1] * 16 + ptr[0], 80)
    modes = [struct.unpack_from('<H', lst, i)[0] for i in range(0, 80, 2)]
    modes = modes[:modes.index(0xFFFF)] if 0xFFFF in modes else modes
    left = sorted(set(modes) & {0x106, 0x118, 0x119, 0x11A, 0x120})
    chk(not left, '4F00 still lists %s' % ', '.join('%03Xh' % v for v in left))
    # the booster: on after a banked 4F02, through 4F05; the base back at the next mode set
    m.mu.mem_write(0xA0000, b'\x55' * 0x10000)
    m.mu.reg_write(UC_X86_REG_EAX, 0x12340000)
    m.int10(0x4F02, bx=0x0101)
    chk(m.mu.reg_read(UC_X86_REG_EAX) >> 16 == 0x1234, '4F02 101h: EAX bits 31-16 changed')
    chk(booster(), 'booster not on after 4F02 101h: ' + regs())
    m.int10(0x4F05, bx=0, dx=1)
    chk(booster() and cr.get(0x6A) == 1, 'booster not on after 4F05 in 101h: ' + regs())
    lock = (cr.get(0x38, 0), cr.get(0x39, 0))
    m.r['aff'] = 1
    m.int10(0x0003)
    chk(cr.get(0x58, 0) & 0x10 == 0 and (cr.get(0x59, 0), cr.get(0x5A, 0)) == base, 'mode 03h: base not back: ' + regs())
    chk(m.r['aff'] == 0, 'ATC flip-flop not reset after the mode set')
    chk((cr.get(0x38, 0), cr.get(0x39, 0)) == lock, 'S3 register lock %02X/%02X after mode 03h, %02X/%02X before'
        % (cr.get(0x38, 0), cr.get(0x39, 0), lock[0], lock[1]))
    # Windows enhanced mode: no booster, CR52 bit 3 set, INT 2Fh asked once; cleared at the next mode set
    m.mu.mem_write(0x7E00, bytes.fromhex('b0042efe060800cf00'))
    ivt2f = m.mem(0x2F * 4, 4)
    m.mu.mem_write(0x2F * 4, struct.pack('<HH', 0, 0x07E0))
    m.int10(0x4F02, bx=0x0101)
    m.int10(0x4F05, bx=0, dx=1)
    m.int10(0x4F05, bx=0, dx=2)
    chk(cr.get(0x58, 0) & 0x10 == 0 and cr.get(0x52, 0) & 0x08 and cr.get(0x6A) == 2, 'Windows: booster on or bank wrong: ' + regs())
    chk(m.mem(0x7E08, 1)[0] == 1, 'Windows: INT 2Fh asked %d times in one mode, expected once' % m.mem(0x7E08, 1)[0])
    m.mu.mem_write(0x2F * 4, ivt2f)
    m.int10(0x4F02, bx=0x0101)
    chk(booster() and not cr.get(0x52, 0) & 0x08, 'no booster after Windows ended (CR52 bit 3 not cleared?): ' + regs())
    # 4F05 BH=1 and a bad BH as Phoenix answers them; the window function turns the booster on in AH=00 69h
    res = m.int10(0x4F05, bx=0x0100)
    chk(res['ax'] == 0x004F, '4F05 BH=1: AX=%04X' % res['ax'])
    # the window set and get read SR04 and put the sequencer index back (Phoenix leaves 04h)
    for bx, dx, want in ((0x0000, 3, None), (0x0100, 0, 3)):
        m.r['si'] = 0x02
        res = m.int10(0x4F05, bx=bx, dx=dx)
        chk(res['ax'] == 0x004F and m.r['si'] == 0x02 and (want is None or res['dx'] == want),
            '4F05 BH=%d: AX=%04X DX=%04X, SR index %02X after it (02h before)' % (bx >> 8, res['ax'], res['dx'], m.r['si']))
    res = m.int10(0x4F05, bx=0x0200, dx=4)
    chk(res['ax'] != 0x004F, '4F05 BH=2: AX=%04X, expected a refusal' % res['ax'])
    m.int10(0x0069)
    chk(cr.get(0x58, 0) & 0x10 == 0, 'booster on after AH=00 69h: ' + regs())
    m.int10(0x4F01, cx=0x0101, es=0x3000, di=0)
    off, seg = struct.unpack('<HH', m.mem(0x3000C, 4))
    m.mu.mem_write(0x7D10, b'\x9A' + struct.pack('<HH', off, seg) + b'\xF4')
    for reg, v in ((UC_X86_REG_BX, 0), (UC_X86_REG_DX, 6), (UC_X86_REG_CS, 0), (UC_X86_REG_SS, 0), (UC_X86_REG_SP, 0x7000)):
        m.mu.reg_write(reg, v)
    m.mu.emu_start(0x7D10, 0x7D15, count=100000)
    chk(booster() and cr.get(0x6A) == 6, 'window function (far call) in 69h: booster not on or bank wrong: ' + regs())
    for ax in (0x0003, 0x0013, 0x1114):
        m.mu.reg_write(UC_X86_REG_EAX, 0x9ABC0000 | ax)
        m.mu.reg_write(UC_X86_REG_ECX, 0x9ABC0000)
        m.int10(ax)
        high = [m.mu.reg_read(reg) >> 16 for reg in (UC_X86_REG_EAX, UC_X86_REG_ECX)]
        chk(high == [0x9ABC, 0x9ABC], 'AX=%04X: EAX/ECX bits 31-16 changed: %s' % (ax, ['%04X' % h for h in high]))
    for mode, calls in ((0x03, ((0x0601, 0x1F00, 0, 0x184F), (0x0702, 0x0700, 0x0305, 0x0A15), (0x0941, 0x001E, 5, 0))),
                        (0x12, ((0x0601, 0x0E00, 0, 0x1D4F), (0x0701, 0x0300, 0x0305, 0x0A16))),
                        (0x13, ((0x0601, 0x0100, 0, 0x1827), (0x0602, 0x0100, 0x0204, 0x1420),
                                (0x0701, 0x0100, 0, 0x1827), (0x0702, 0x0100, 0x0204, 0x1420))),
                        (0x0D, ((0x0703, 0x0600, 0x0102, 0x0A10),))):
        m.int10(mode)
        for ax, bx, cx, dx in calls + ((0x0200, 0, 0, {0x12: 0x1D4F, 0x03: 0x184F}.get(mode, 0x1827)), (0x0E0A, 7, 0, 0)):
            for reg in (UC_X86_REG_EAX, UC_X86_REG_EBX, UC_X86_REG_ECX, UC_X86_REG_EDX, UC_X86_REG_ESI, UC_X86_REG_EDI):
                m.mu.reg_write(reg, 0x9ABC0000)
            m.int10(ax, bx=bx, cx=cx, dx=dx)
            high = [m.mu.reg_read(reg) >> 16 for reg in (UC_X86_REG_EAX, UC_X86_REG_ECX, UC_X86_REG_ESI, UC_X86_REG_EDI)]
            chk(high == [0x9ABC] * 4, 'mode %02X AX=%04X: EAX/ECX/ESI/EDI bits 31-16 changed: %s'
                % (mode, ax, ['%04X' % h for h in high]))
    # the display FIFO M (CR54 bits 7-3, #75), from the bandwidth: 112 of the FIFO's 128 bytes drain in
    # t = 112 x MCLK / (DCLK x bytes per pixel) MCLKs, two entry cycles and an access take 23 and each
    # access 6 (p3, #82; p2 counted 5), so M = (t - 23) / 6 at most (README "Trio64 ROM"). Every packed mode keeps M at or below it (the ROM
    # only lowers Phoenix's values); at the default MCLK (54.9 MHz) with 2 or 4 MB 103h, 105h and 114h have
    # it exactly, since Phoenix's own values there are higher (with 1 MB, a 32-bit memory bus, Phoenix's own
    # values are lower than the formula, which counts the 64-bit bus, and stay). The MCLK from the SR10/SR11
    # the POST loads.
    seq = m.r['seq']
    mn, mm = (seq[0x10], seq[0x11]) if 0x10 in seq and 0x11 in seq else (rom[0x3B6], rom[0x3B5])
    mclk = 14318.18 * ((mm & 0x7F) + 2) / (((mn & 0x1F) + 2) << ((mn >> 5) & 3))
    for mode in (0x101, 0x103, 0x105, 0x107, 0x110, 0x111, 0x112, 0x113, 0x114, 0x115, 0x116, 0x117):
        if m.int10(0x4F02, bx=mode)['ax'] != 0x004F:
            continue
        n, dm = seq.get(0x12, 0), seq.get(0x13, 0)
        dclk = 14318.18 * ((dm & 0x7F) + 2) / (((n & 0x1F) + 2) << ((n >> 5) & 3))
        bpp = ((cr.get(0x67, 0) >> 5) + 3) // 2
        t = 112 * mclk / (dclk * bpp)
        lim = [max(0, int(x - 23) // 6) if x < 31 * 6 + 23 else 31 for x in (t - 0.5, t + 0.5)]
        got = cr.get(0x54, 0) >> 3
        exact = mode in (0x103, 0x105, 0x114) and mclk < 56000 and Machine.vram >= 2
        chk(got <= lim[1] and (not exact or got >= lim[0]), '%03Xh: CR54 M = %d, expected %s %d (t = %.1f MCLKs, '
            'MCLK %.2f MHz, DCLK %.2f MHz, %d bytes per pixel)' % (mode, got, 'about' if exact else 'at most',
                                                                   lim[1], t, mclk / 1000, dclk / 1000, bpp))
    check(not fails, '%d of the checks failed:\n    ' % len(fails) + '\n    '.join(fails))
    return 'defaults, removed modes, booster, Windows check, lock, ATC flip-flop, 32-bit registers, FIFO M'


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


def skips_counted(text, tool):
    """The SKIP lines (tests and steps the chip, its ROM or the memory leave out) and the 'Skipped: N' of
    the summary agree; returns the SKIP lines."""
    lines = [l for l in text.split('\r\n') if '  SKIP: ' in l]
    m = re.search(r'Skipped: (\d+)', text)
    check(m and int(m.group(1)) == len(lines), '%s: summary %s, %d SKIP lines' % (tool, m and m.group(0), len(lines)))
    return lines


def t_s3test(c):
    com = c.tool('S3TEST.COM')
    v = '/V' if has_verbose() else ''
    r1 = c.machine().run_com(com, v)
    c.save('S3TEST', r1)
    check(r1.exit and r1.exit[0] == 'exit', 'S3TEST did not end: %s' % (r1.exit,))
    out = r1.stdout.decode('latin1')
    check('Passed:' in out, 'no summary line')
    tl = tagged(out, 'S3TEST')
    skips_counted(out, 'S3TEST')
    results = [l for cat, l in tl if l.endswith(('PASS', 'FAIL'))]
    for cat, l in tl:
        m = re.match(r'Mode ([0-9A-F]{4}) ', l)
        check(not m or cat == mode_cat(int(m.group(1), 16) & 0xBFFF), 'S3TEST: %s line in category %s' % (l[:9], cat))
    want = 30 if c.ours else 24             # the Trio64V+ and Trio64 sets have no LFB, 4F06 BL=3, 512x384 and pedestal lines
    check(len(results) >= want, 'only %d result lines' % len(results))
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
    rr = c.machine(keys=[]).run_com(com, '/R /S', max_insn=6_000_000_000)   # robot: no keys at all
    out = rr.stdout.decode('latin1')
    want = vesa_supported(c.machine())
    miss = [v for v in want if 'Mode %04X' % v not in out]
    check(rr.exit == ('exit', 0) and 'stopped' not in out and '/R results:' in out and want and not miss,
          'VSHOW /R /S did not run through the modes without keys: %s, missing %s' % (rr.exit, miss))
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
    nasm = shutil.which(NASM)
    if not nasm:
        raise Skip('%s not found (--nasm)' % NASM)
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
    nasm = shutil.which(NASM)
    if not nasm:
        raise Skip('%s not found (--nasm)' % NASM)
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
    skips_counted(r.stdout.decode('latin1'), 'S3COMPAT')
    names = ('4F00 capabilities', '4F04 state masks', 'VBE invalid', 'VBE undefined', '4F0A table',
             '4F10 power', '4F15 DDC', '4F14 S3 OEM', 'DCLK VCO')
    tests = [l for l in lines if l.startswith(names) and re.search(r'  (PASS|FAIL [0-9A-F]+|WARN [0-9A-F]+|INFO)$', l)]
    check(len(tests) == len(names), 'only %d of the %d VBE lines: %s' % (len(tests), len(names), tests))
    # the model has no DDC lines: 4F15 must say so (INFO), everything else PASS; another BIOS may lack
    # the VBE 2.0 functions or the S3 OEM 4F14h: INFO there
    bad = [l.strip() for l in tests if not l.rstrip().endswith('PASS') and
           not ((l.startswith('4F15') or not c.ours) and l.rstrip().endswith('INFO'))]
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
    skips_counted(r0.stdout.decode('latin1'), 'S3COMPAT')
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
                  # Accepted datasheet warnings, checked on the card with p18 (S3COMPAT, VSHOW /R and /A,
                  # 30 October 2026): the five modes show a clean picture at the edges and line ends.
                  # 012Eh, 010Fh (320x200) WARN 80: End Horizontal Blank is 00h, so CR86 = 00h cannot be
                  #   "1 less" (V2-REG-3); the reference 2.04.07 sets the same registers.
                  # 0131h, 0134h (320x240) WARN 80: the same rule; EHB 00h comes from the ROM's 320x240
                  #   timing (VESA 640x480 at 60 Hz halved), the reference has 2Fh there.
                  # 012Ah (640x480x24) WARN 82: 02 = DCLK 75.16 MHz (3 x 25.05 MHz) above the 75 MHz packed
                  #   24 limit, 80 = L1 (CR90/CR91) FFh where V2-REG-4 wants EFh; both as in the reference.
                  r'VESA 012E .*WARN 80$', r'VESA 010F .*WARN 80$', r'VESA 0131 .*WARN 80$',
                  r'VESA 0134 .*WARN 80$', r'VESA 012A .*WARN 82$',
                  r'.*INFO$']
# with 4 MB the BIOS (2.04.07, unchanged by the patches) offers modes whose default DCLK is above the
# datasheet maximum for their depth (50 MHz at 32 bpp, 95 MHz at 15/16 bpp): WARN 02, as 106h
S3COMPAT_KNOWN_4MB = [r'VESA 0118 .*WARN 02$', r'VESA 0164 .*WARN 02$', r'VESA 0119 .*WARN 02$',
                      r'VESA 011A .*WARN 02$']


def t_s3compat_full(c):
    """The whole S3COMPAT (/Q: without the 2 MB VRAM pattern test) on the model."""
    com = c.tool('S3COMPAT.COM')
    m = c.machine()
    r = m.run_com(com, '/Q', max_insn=3_000_000_000)
    c.save('S3CFULL', r)
    # a BIOS that clears video memory with the graphics engine, which the model does not run
    ge = [r'4F02 clear / D15 keep memory .*FAIL 0002$'] if m.ge_cmds else []
    check(r.exit and r.exit[0] == 'exit', 'S3COMPAT did not end: %s' % (r.exit,))
    tests = [l for _, l in tagged(r.stdout.decode('latin1'), 'S3COMPAT')]
    skips = skips_counted(r.stdout.decode('latin1'), 'S3COMPAT')
    # #72: the CR90 check of the VGA lines is the Trio64V2's (on the Trio64 CR90 reads as CR10);
    # #73: no LFB test without an LFB (VBE 1.x)
    cr90 = any('CR90 is a Trio64V2 register' in l for l in skips)
    check(cr90 == (Machine.chip != 'v2'), 'CR90 SKIP line %s on the %s model' % ('present' if cr90 else 'missing', Machine.chip))
    m.int10(0x4F01, cx=0x101, es=0x3000, di=0)
    lfb = bool(m.mem(0x30000, 1)[0] & 0x80)
    nolfb = any('no linear frame buffer' in l for l in skips)
    check(nolfb != lfb, 'LFB test: 4F01 offers %s LFB, SKIP line %s' % ('an' if lfb else 'no', 'present' if nolfb else 'missing'))
    want = 230 if c.ours else 120       # another BIOS: fewer modes (17 in the Trio64 BIOS 1.4), no 4F14h
    check(len(tests) >= want and b'Time spent' in bytes(r.stdout), 'only %d result lines' % len(tests))
    bad = [l.strip() for l in tests if not l.endswith('PASS') and
           not any(re.match(p, l) for p in S3COMPAT_MODEL_LIMITS + ge + S3COMPAT_KNOWN +
                   (S3COMPAT_KNOWN_4MB if Machine.vram == 4 else []))]
    check(not bad, '%d lines not PASS:\n    ' % len(bad) + '\n    '.join(bad))
    lim = sum(1 for l in tests if any(re.match(p, l) for p in S3COMPAT_MODEL_LIMITS + ge))
    return '%d lines, %d judged by memory the model lacks' % (len(tests), lim)


def vgalog_info(c, m, blk, what):
    """The chip and ROM block VGALOG writes (32 bytes): CR2D-CR30 and CR36 as the model's chip reports
    them, the ROM size byte, SR10/SR11 as the POST left them, and the word after "Vers" in the ROM's
    first 256 bytes."""
    ids = CHIPS[Machine.chip]['ids'][:4]
    cr36 = {1: 0xD2, 2: 0x92, 4: 0x12}[Machine.vram]
    if Machine.chip in ('trio64', 'trio32'):
        cr36 |= 0x0C if Machine.vram == 4 else 0x08
    v = re.search(rb'Vers\S*\s+([^\s(]{1,15})', c.rom[:0x100])
    want = bytes(ids) + bytes([cr36, c.rom[2], m.r['seq'].get(0x10, 0), m.r['seq'].get(0x11, 0)]) + \
        (v.group(1) if v else b'').ljust(16, b'\0') + bytes(8)
    check(blk == want, '%s: chip and ROM block %s, expected %s' % (what, blk.hex(' '), want.hex(' ')))
    return (v.group(1) if v else b'').decode()


def t_vgalog(c):
    if not os.path.exists(os.path.join(SRC, 'vgalog', 'vgalog.asm')):
        raise Skip('no vgalog/ in this tree')
    com = c.tool('VGALOG.COM')
    m = c.machine()
    ri = r = m.run_com(com, '', seg=0x2000)
    check(r.exit and r.exit[0] == 'tsr', 'VGALOG did not stay resident: %s' % (r.exit,))
    log = r.files.get('VGALOG.BIN')
    check(log is not None, 'VGALOG.BIN not created')
    check(log[:16] == b'VGALOGF1' + bytes(8), 'no file-mode header: %r' % bytes(log[:16]))
    ver = vgalog_info(c, m, bytes(log[16:48]), 'file mode')
    del log[:48]                                # the records follow
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
    check(len(log) == 3 * 32, 'VGALOG.BIN has %d bytes after the header, expected 96 (3 logged calls)' % len(log))
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
    nasm = shutil.which(NASM)
    if not nasm:
        raise Skip('%s not found (--nasm)' % NASM)
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
    check(m.mem(0x1000 * 16 - 16, 3) == b'M\x00\x10' and m.mem((0x1000 + 0x60) * 16, 1) == b'Z',
          'no MCB in front of the PSP, or the resident block not shrunk to 60h paragraphs with a free block after')
    seg = struct.unpack('<H', m.mem(0x86, 2))[0]
    check(seg == 0x1010, 'INT 21h vector %04X, expected the hook in the program (1010)' % seg)
    return 'MZ program ran, hooked INT 21h, stayed resident'


def t_vgalog_mem(c):
    """VGALOG /M keeps INT 10h calls in its ring buffer (text output skipped, nested BIOS calls with their
    depth, registers in and out, SR10/SR11 and CR58-5A/6D after); /D writes them in call order, and with
    no call yet it writes no file and says so. With another INT 10h hook after it (Windows in a DOS box)
    /D and the install check still find it, /U refuses."""
    com = c.tool('VGALOG.COM')
    m = c.machine()
    r = m.run_com(com, '/M', seg=0x2000)
    check(r.exit and r.exit[0] == 'tsr', 'VGALOG /M did not stay resident: %s' % (r.exit,))
    r0 = m.run_com(com, '/D', seg=0x4000)           # no call yet: no file, a message instead
    check(r0.exit == ('exit', 0) and 'VGALOG.BIN' not in r0.files
          and b'No events registered, not writing output file' in r0.stdout,
          '/D with no calls: exit %s, files %s, output %r' % (r0.exit, sorted(r0.files), r0.stdout[-80:]))
    calls = [(0x0003, {}), (0x0E41, dict(bx=7)), (0x4F02, dict(bx=0x0101)), (0x4F05, dict(bx=0, dx=2)),
             (0x1130, dict(bx=0x0200)), (0x0003, {})]
    ret = {}
    for ax, kw in calls:
        res = m.int10(ax, **kw)
        ret[ax] = res
        check(res['flags'] & 0x200, 'AX=%04X returned with interrupts disabled' % ax)
        if ax == 0x4F02:                # what the record of this call must hold: the registers after it
            sr, cr = m.r['seq'], m.r['crtc']
            after = bytes([sr.get(0x10, 0), sr.get(0x11, 0), cr.get(0x58, 0), cr.get(0x59, 0), cr.get(0x5A, 0)])
    check(ret[0x1130]['es'] == 0xC000 and ret[0x1130]['cx'] == 16, 'AX=1130h result changed by VGALOG: %s' % ret[0x1130])
    rd = m.run_com(com, '/D', seg=0x4000)
    check(rd.exit == ('exit', 0), '/D ended with %s' % (rd.exit,))
    b = rd.files.get('VGALOG.BIN')
    check(b is not None and b[:8] == b'VGALOGM2', 'VGALOG.BIN has no memory-mode header')
    total, n, flags = struct.unpack_from('<IHH', b, 8)
    check(flags == 0, 'header flags %04X without /T' % flags)
    vgalog_info(c, m, bytes(b[16:48]), '/M')
    recs = [b[48 + 32 * i:80 + 32 * i] for i in range(n)]
    check(len(b) == 48 + 32 * n, 'VGALOG.BIN is %d bytes for %d records' % (len(b), n))
    top = [struct.unpack_from('<H', x, 2)[0] for x in recs if x[23] == 0]
    check(top == [0x0003, 0x4F02, 0x4F05, 0x1130, 0x0003], 'calls at depth 0: %s (AH=0Eh must be skipped)'
          % ['%04X' % a for a in top])
    nested = [x for x in recs if x[23] > 0]
    # the 2.04.07 BIOS calls AX=1130h itself in the mode set; another BIOS need not nest a call at all
    check((nested or not c.ours) and all(struct.unpack_from('<H', x, 2)[0] == 0x1130 for x in nested),
          'no nested AX=1130h from the BIOS during the mode set')
    r101 = [x for x in recs if struct.unpack_from('<HH', x, 2) == (0x4F02, 0x0101)][0]
    check(struct.unpack_from('<H', r101, 14)[0] == 0x004F and r101[26:31] == after,
          '4F02 101h record: AX out, SR10/11 or CR58/59/5A wrong: %s (registers %s)' % (r101.hex(), after.hex()))
    check(m.r['crtc'].get(0x38) != 0x48 or m.r['seq'].get(8) != 0x06, 'S3 registers left unlocked')
    # Another program hooks INT 10h after VGALOG, as Windows 9x does in a DOS box: /D and the install
    # check find the resident copy through the MCB chain, /U (only as the last hook) refuses
    vec = m.mem(0x40, 4)
    m.mu.mem_write(0x0600, b'\xEA' + vec)              # 0060:0000 jmp far to VGALOG
    m.mu.mem_write(0x40, struct.pack('<HH', 0, 0x0060))
    rw = m.run_com(com, '/D', seg=0x4000)
    bw = rw.files.get('VGALOG.BIN')
    check(rw.exit == ('exit', 0) and bw is not None and bw[:8] == b'VGALOGM2',
          '/D behind another INT 10h hook: exit %s, output %r' % (rw.exit, bytes(rw.stdout)[-100:]))
    rt = m.run_com(com, '/M', seg=0x4000)
    check(rt.exit == ('exit', 1), 'second /M behind another hook not refused: %s' % (rt.exit,))
    rn = m.run_com(com, '/U', seg=0x4000)
    check(rn.exit == ('exit', 1), '/U behind another INT 10h hook not refused: %s' % (rn.exit,))
    m.mu.mem_write(0x40, vec)
    ru = m.run_com(com, '/U', seg=0x4000)
    check(ru.exit == ('exit', 0), '/U ended with %s' % (ru.exit,))
    rd2 = m.run_com(com, '/D', seg=0x4000)
    check(rd2.exit == ('exit', 1), '/D after /U not refused')
    c.save('VGALOGM', rd)
    return '%d calls, %d of them nested' % (n, len(nested))


def t_vgalog_trace(c):
    """VGALOG /T traces the port accesses of the mode sets: every OUT the BIOS makes during AX=0003h and
    4F02h 101h is in the trace, in order and with its value (the model's own record of the OUTs as the
    reference), behind a marker that names the call's record; the reads are there (kind 1), polling loops
    take one event with repeats, other calls (AH=0Eh, 4F05h) are not traced, INT 1 is put back after each
    mode set and /U unloads."""
    com = c.tool('VGALOG.COM')
    m = c.machine()
    i1 = m.mem(4, 4)
    r = m.run_com(com, '/T', seg=0x2000)
    check(r.exit and r.exit[0] == 'tsr', 'VGALOG /T did not stay resident: %s' % (r.exit,))
    check(b'port trace' in bytes(r.stdout), '/T install message: %r' % bytes(r.stdout)[-120:])

    def want(port):
        return 0x3B0 <= port <= 0x3DF or 0xCF8 <= port <= 0xCFF or port & 0x3FD == 0x2E8
    seen = {}                           # call -> the BIOS's OUTs as (port, value, kind), not VGALOG's own
    cur = [None]

    def out(uc, port, size, val, ud):
        if cur[0] is None or uc.reg_read(UC_X86_REG_CS) == 0x2000:
            return
        ev = seen.setdefault(cur[0], [])
        if want(port):
            ev.append((port, val & 0xFF, 0))
        if size >= 2 and want(port + 1):
            ev.append((port + 1, (val >> 8) & 0xFF, 2))
    h = m.mu.hook_add(UC_HOOK_INSN, out, None, 1, 0, UC_X86_INS_OUT)
    calls = [(0x0003, {}), (0x0E41, dict(bx=7)), (0x4F02, dict(bx=0x0101)), (0x4F05, dict(bx=0, dx=1))]
    for ax, kw in calls:
        cur[0] = ax
        res = m.int10(ax, **kw)
        check(not res['flags'] & 0x100, 'AX=%04X returned with the trap flag set' % ax)
        check(m.mem(4, 4) == i1, 'AX=%04X: INT 1 not put back after the call' % ax)
    cur[0] = None
    m.mu.hook_del(h)
    rd = m.run_com(com, '/D', seg=0x4000)
    check(rd.exit == ('exit', 0), '/D ended with %s' % (rd.exit,))
    b = rd.files.get('VGALOG.BIN')
    check(b is not None and b[:8] == b'VGALOGM2', 'VGALOG.BIN has no memory-mode header')
    total, n, flags = struct.unpack_from('<IHH', b, 8)
    check(flags == 1, 'header flags %04X with /T, expected 0001 (trace part follows)' % flags)
    vgalog_info(c, m, bytes(b[16:48]), '/T')
    recs = [b[48 + 32 * i:80 + 32 * i] for i in range(n)]
    t = 48 + 32 * n
    check(b[t:t + 8] == b'VGALOGT1', 'no trace part after the %d calls' % n)
    ttot, tn = struct.unpack_from('<II', b, t + 8)
    check(len(b) == t + 16 + 4 * tn and tn == ttot, 'trace part: %d events in total, %d in the file, %d bytes'
          % (ttot, tn, len(b) - t - 16))
    evs = [struct.unpack_from('<HBB', b, t + 16 + 4 * i) for i in range(tn)]
    # split at the markers: call number -> events (repeats expanded)
    bycall, num, reads, reps = {}, None, 0, 0
    for port, val, k in evs:
        if k & 3 == 3:
            num = port
            continue
        check(num is not None, 'trace events before the first marker')
        check(k >> 2 < 63, 'a repeat count saturated (%04X)' % port)
        reps += k >> 2
        if k & 3 == 1:
            reads += 1 + (k >> 2)
            continue
        bycall.setdefault(num, []).extend([(port, val, k & 3)] * (1 + (k >> 2)))
    marked = {struct.unpack_from('<H', x, 0)[0]: struct.unpack_from('<H', x, 2)[0] for x in recs}
    top = {struct.unpack_from('<H', x, 2)[0]: struct.unpack_from('<H', x, 0)[0] for x in recs if x[23] == 0}
    check(set(bycall) <= set(marked), 'markers name no logged call: %s' % sorted(set(bycall) - set(marked)))
    traced = sorted('%04X' % marked[k] for k in bycall if marked[k] in (0x0E41, 0x4F05))
    check(not traced, 'calls traced that are no mode set: %s' % traced)
    for ax in (0x0003, 0x4F02):
        # the call's own events and those of the calls the BIOS made from inside it, in program order
        got, on = [], False
        for port, val, k in evs:
            if k & 3 == 3:
                on = port == top[ax] or (on and port != top[ax] and marked.get(port) not in (0x0003, 0x4F02, 0x0E41, 0x4F05))
                continue
            if on and k & 3 != 1:
                got.extend([(port, val, k & 3)] * (1 + (k >> 2)))
        exp = seen.get(ax, [])
        first = next((i for i, (a, e) in enumerate(zip(got, exp)) if a != e), None)
        check(got == exp and exp, 'AX=%04X: %d OUT events traced, %d made by the BIOS; first difference at %s: '
              '%s / %s' % (ax, len(got), len(exp), first, got[first] if first is not None and first < len(got) else '-',
                           exp[first] if first is not None and first < len(exp) else '-'))
    ru = m.run_com(com, '/U', seg=0x4000)
    check(ru.exit == ('exit', 0), '/U ended with %s' % (ru.exit,))
    c.save('VGALOGT', rd)
    return '%d events: %d OUTs in 0003h, %d in 4F02h 101h, %d reads, %d repeats merged' % (
        tn, len(seen.get(0x0003, [])), len(seen.get(0x4F02, [])), reads, reps)


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
    def rows(ls):                       # SR17 (the clock synthesizer test counter) runs: not compared
        out = [l for l in ls if l[:2] in ('SR', 'CR', 'GR') or l.startswith('PCI00:')]
        return [l[:6 + 3 * 7] + 'xx' + l[6 + 3 * 7 + 2:] if l.startswith('SR10:') else l for l in out]
    check(rows(dos) == rows(win) and len(rows(dos)) == 2 + 16 + 1 + 1, 'DOS and Win32 snapshots differ:\n%s\n%s'
          % ('\n'.join(rows(dos)), '\n'.join(rows(win))))
    sr, cr = dict(m.r['seq']), dict(m.r['crtc'])   # the values the model holds (the BIOS set them)
    want = ['SR10: %02X %02X' % (sr.get(0x10, 0), sr.get(0x11, 0)),
            'CR50: ' + ' '.join('%02X' % cr.get(0x50 + i, 0) for i in range(11))]
    check(all(w in '\n'.join(dos) for w in want), 'snapshot values (SR10/11, CR50-5A in 101h) not as the '
          'registers hold them: %s' % want)
    for snap in (dos, win):                     # CRC5, CRCA, CRCB: CR45, CR4A, CR4B on a Trio64 (#74)
        crc0 = [l for l in snap if l.startswith('CRC0:')][0].split()[1:]
        check([crc0[i] for i in (5, 10, 11)] == ['--'] * 3, 'CRC5, CRCA, CRCB read: %s' % crc0)

    def hook(ms):
        if ms == 300:
            m.r['seq'][0x10], m.r['seq'][0x11] = 0x41, 0x28
        if ms == 500:
            m.r['crtc'][0x54], m.r['crtc'][0x47] = 0x10, 0x05
    rw = m.run_pe32(exe, '"C:\\TOOLS\\S3REGS32.EXE" /W 1 watch', sleep_hook=hook)
    text = rw.files['S3REGS.TXT'].decode('latin1')
    ch = text[text.index('WATCH'):text.index('END OF WATCH')].split('\r\n')[1:-1]
    exp = ['+300 SR10 %02X->41' % sr.get(0x10, 0), '+300 SR11 %02X->28' % sr.get(0x11, 0),
           '+500 CR54 %02X->10' % cr.get(0x54, 0)]
    if Machine.chip in ('trio64', 'trio32'):    # CR80-CRFF mirror CR00-CR7F there: CRD4 is CR54; CRC7 (CR47,
        exp += ['+500 CRD4 %02X->10' % cr.get(0x54, 0)]  # the cursor) is ignored like CR47 (#74)
    exp = [e for e in exp if e[10:12] != e[14:16]]  # a register that already held the value: no line
    check(ch == exp, 'watch lines: %s, expected %s' % (ch, exp))
    rh = m.run_pe32(exe, 'S3REGS32 /?')
    check(b'/W n' in rh.stdout, 'S3REGS32 /? shows no parameter list')
    open(os.path.join(c.logs, 'S3REGS.TXT'), 'wb').write(r.files['S3REGS.TXT'] + r32.files['S3REGS.TXT'] + rw.files['S3REGS.TXT'])
    return 'DOS and Win32 snapshots equal, watch logs 3 changes'


# ---------------------------------------------------------------- emulator-only suites
# These change the equipment word, switch between the monochrome and the colour adapter addressing
# and feed the BIOS invalid input: harmless on the model, not something to do to the test machine.
# Expected values from the IBM PC AT and PS/2 BIOS interface (INT 10h) and the VBE 2.0 specification.

def vesa_supported(m):
    """The modes of the 4F00h list that 4F01h marks as supported; uses 3000:0000-05FF."""
    m.mu.mem_write(0x30000, b'VBE2' + bytes(508))
    m.int10(0x4F00, es=0x3000, di=0)
    loff, lseg = struct.unpack('<HH', m.mem(0x3000E, 4))
    out = []
    for k in range(120):
        v = word(m, lseg * 16 + loff + 2 * k)
        if v == 0xFFFF:
            break
        r = m.int10(0x4F01, cx=v, es=0x3000, di=0x400)
        if r['ax'] == 0x004F and m.mem(0x30400, 1)[0] & 1:
            out.append(v)
    return out


def vbe_version(m):
    """The VBE version 4F00h reports (0 when it fails); uses 3000:0000-01FF."""
    m.mu.mem_write(0x30000, b'VBE2' + bytes(508))
    r = m.int10(0x4F00, es=0x3000, di=0)
    return word(m, 0x30004) if r['ax'] == 0x004F else 0


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
    # the modes of the 4F00h list that 4F01h marks unsupported, and numbers that are no mode at all; every
    # mode whose picture (bytes per line x lines, x 4 planes in the 16-colour modes) does not fit into the
    # memory 4F00h reports must be among them (2 MB: 118h, 164h, 119h, 11Ah of the 2.04.07 list)
    m.mu.mem_write(0x30000, b'VBE2')
    m.int10(0x4F00, es=0x3000, di=0)
    loff, lseg = struct.unpack('<HH', m.mem(0x3000E, 4))
    mem = word(m, 0x30012) * 0x10000
    big, toobig = [], []
    for k in range(120):
        v = word(m, lseg * 16 + loff + 2 * k)
        if v == 0xFFFF:
            break
        m.int10(0x4F01, cx=v, es=0x3000, di=0x400)
        mi = m.mem(0x30400, 0x20)
        if not mi[0] & 1:
            big.append(v)
        if mi[0] & 0x10 and word(m, 0x30410) * word(m, 0x30414) * (4 if mi[0x1B] == 3 else 1) > mem:
            toobig.append(v)
    chk(set(big) >= set(toobig), '%d KB: modes too large for the memory not marked unsupported: %s'
        % (mem // 1024, ' '.join('%03X' % v for v in toobig if v not in big)))
    m.int10(0x4F02, bx=0x0101)
    s0 = vga_state(m)
    for bx in big + [0x01FF, 0x017F, 0x0200]:
        r = m.int10(0x4F02, bx=bx)
        chk(r['ax'] != 0x004F, '4F02 BX=%04X accepted' % bx)
        chk(vga_state(m) == s0, '4F02 BX=%04X (refused) changed the video state' % bx)
    if vbe_version(m) >= 0x0200:                            # 4F09h is VBE 2.0
        m.mu.mem_write(0x30000, bytes([0x15, 0x2A, 0x3F, 0]))    # 4F09h at the last entry: blue, green, red
        r = m.int10(0x4F09, bx=0, cx=1, dx=255, es=0x3000, di=0)
        chk(r['ax'] == 0x004F and tuple(m.dac[255]) == (0x3F, 0x2A, 0x15), '4F09 entry 255: %04X %s'
            % (r['ax'], m.dac[255]))
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
    Windows 9x display driver of S3 uses 4F00, 4F02 and 4F08 and needs CR59/CR5A at the PCI base after its
    banked 4F02 (README, Windows 9x driver test)."""
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
    vbe = word(m, BUF * 16 + 4)
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
        if vbe < 0x0200:                # 4F09h is VBE 2.0
            continue
        pal = bytes((3 * i + k * 85) & 0xFF for i in range(256) for k in range(4))
        m.mu.mem_write(BUF * 16 + 0x2000, pal)
        int10w(m, dict(eax=0x4F09, ebx=0, ecx=256, edx=0, edi=0x2000), es=BUF)
        o = int10w(m, dict(eax=0x4F09, ebx=1, ecx=256, edx=0, edi=0x3000), es=BUF)
        rd = m.mem(BUF * 16 + 0x3000, 1024)
        width = 8 if caps & 1 else 6
        msk = 0xFF if width == 8 else 0x3F
        exp = bytes((b & msk) if k % 4 != 3 else rd[k] for k, b in enumerate(pal))
        chk(o['eax'] & 0xFFFF == 0x4F and rd == exp, '%03Xh 4F09 palette not read back as written (%d bits)' % (v, width))
    # the mode sets VGALOG recorded from the S3 driver (stock BIOS 2.04.11): banked 4F02 with bit 15, CX =
    # lines, DX = 3D4h; then the driver turns its own linear window on (CR58 = 92h) at CR59/CR5A, so
    # they must still hold the PCI base the BIOS found at POST (the p15 booster moved them to 000Ah:
    # garbage on the desktop)
    m2 = c.machine()
    cr2 = m2.r['crtc']
    m2.mu.mem_write(0x7E00, bytes.fromhex('b004cf'))      # INT 2Fh AX=1600h: Windows 98 (enhanced mode)
    m2.mu.mem_write(0x2F * 4, struct.pack('<HH', 0, 0x07E0))
    base = (cr2.get(0x59, 0), cr2.get(0x5A, 0))
    for v, lines in ((0x101, 480), (0x103, 600), (0x111, 480), (0x114, 600), (0x105, 768), (0x112, 480)):
        if v not in modes:
            continue
        o = int10w(m2, dict(eax=0x4F02, ebx=0x8000 | v, ecx=lines, edx=0x3D4))
        got = (cr2.get(0x59, 0), cr2.get(0x5A, 0))
        chk(o['eax'] & 0xFFFF == 0x4F and got == base, 'driver 4F02 %04Xh: AX=%04X, CR59/5A %02X%02X, the PCI '
            'base %02X%02X expected' % (0x8000 | v, o['eax'] & 0xFFFF, got[0], got[1], base[0], base[1]))
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


def t_v2_writes(c):
    """Trio64V2 datasheet rules about writes, which only the model can see (docs/chip-rules.md):
    V2-REG-5: the BIOS writes 00h to CR26 on each mode set, with A5h in CR39 first ('Synchronization 2',
    section 4.2), and CR23 must be 00h when CR26 is written: CR23 is set to 5Ah before each mode set (a
    driver may leave it set after vertical interpolation, section 3.2.2), so the BIOS has to clear it
    first (p19; the reference 2.04.07 writes CR26 only); V2-REG-6: CR40 bit 0 and CR66 bit 0 change only with the screen off (SR01 bit 5) or in
    vertical retrace (section 4.1). Checked for VGA modes 03h, 12h, 13h and the VESA modes 101h, 111h
    and 112h. Only on the Trio64V2 model (--chip v2)."""
    if Machine.chip != 'v2':
        raise Skip('Trio64V2 rules (--chip v2)')
    m = c.machine()
    errs = []
    sets = [('03h', lambda: m.int10(0x03)), ('12h', lambda: m.int10(0x12)), ('13h', lambda: m.int10(0x13)),
            ('101h', lambda: m.int10(0x4F02, bx=0x101)), ('111h', lambda: m.int10(0x4F02, bx=0x111)),
            ('112h', lambda: m.int10(0x4F02, bx=0x112))]
    for name, fn in sets:
        m.r['crtc'][0x23] = 0x5A                # as a driver may leave it (vertical interpolation)
        m.wlog = []
        fn()
        log, m.wlog = m.wlog, None
        if not any(reg == 'CR' and i == 0x26 and v == 0 and cr39 == 0xA5
                   for reg, i, v, old, sr01, vr, cr39 in log):
            errs.append('%s: no CR26 = 00h with CR39 = A5h (V2-REG-5)' % name)
        cr23 = 0x5A
        for reg, i, v, old, sr01, vr, cr39 in log:
            if reg == 'CR' and i == 0x23 and cr39 == 0xA5:
                cr23 = v
            elif reg == 'CR' and i == 0x26 and cr23:
                errs.append('%s: CR26 written with CR23 = %02Xh (V2-REG-5)' % (name, cr23))
                break
        for reg, i, v, old, sr01, vr, cr39 in log:
            if reg == 'CR' and i in (0x40, 0x66) and (v ^ old) & 1 and not sr01 & 0x20 and not vr:
                errs.append('%s: CR%02X bit 0 %d->%d with the screen on outside retrace (V2-REG-6)'
                            % (name, i, old & 1, v & 1))
    m.int10(0x03)
    check(not errs, '%d: %s' % (len(errs), '; '.join(errs[:8])))
    return '%d mode sets' % len(sets)


def t_post_delay(c):
    """p20: the POST step at 14C6h turns RAM refresh off (CR88 bit 6), waits with the DDC delay (5F4Eh),
    resets the graphics engine (CR66 = 02h, then 00h) and turns refresh on again. 2.04.07 and 2.04.11
    load the count 0Ah into BX, but the delay takes AX, which still holds the CR88 index and value
    (4088h with CR88 = 00h): 13.8 ms instead of 8 us with the 2.04.11 delay (p19). Here: between the
    CR88 write that sets bit 6 and the CR66 = 02h write, PIT channel 2 is loaded with 0014h (0Ah doubled
    for mode 3)."""
    if not c.ours:
        raise Skip('p20 POST delay (our ROM only)')
    m = Machine(c.rom)
    ev, st = [], {'lo': None, 'ci': None}

    def out(uc, port, size, val, ud):
        if port in (0x3D4, 0x3B4):
            if size == 2:
                ev.append(('CR', val & 0xFF, val >> 8))
            else:
                st['ci'] = val & 0xFF
        elif port in (0x3D5, 0x3B5) and st['ci'] is not None:
            ev.append(('CR', st['ci'], val & 0xFF))
        elif port == 0x43:
            st['lo'] = None
        elif port == 0x42:
            if st['lo'] is None:
                st['lo'] = val & 0xFF
            else:
                ev.append(('PIT2', st['lo'] | (val & 0xFF) << 8, None))
                st['lo'] = None
    m.mu.hook_add(UC_HOOK_INSN, out, None, 1, 0, UC_X86_INS_OUT)
    m.post()
    on = [i for i, e in enumerate(ev) if e[0] == 'CR' and e[1] == 0x88 and e[2] & 0x40]
    check(on, 'POST never sets CR88 bit 6 (RAM refresh off)')
    rst = [i for i, e in enumerate(ev) if e[0] == 'CR' and e[1] == 0x66 and e[2] == 0x02 and i > on[0]]
    check(rst, 'no graphics engine reset (CR66 = 02h) after CR88 bit 6')
    loads = [e[1] for e in ev[on[0]:rst[0]] if e[0] == 'PIT2']
    check(0x0014 in loads, 'PIT channel 2 loads between refresh off and the engine reset: %s, expected 0014h'
          % (' '.join('%04X' % x for x in loads) or 'none'))
    return 'refresh off, PIT channel 2 loaded with 0014h, engine reset'


def t_ddc(c):
    """p19: the DDC code of VBE 4F15 as in the S3 BIOS 2.04.11. BL=00h (the probe the S3COMPAT 4F15 line
    makes): returns 004Fh; every access to the serial port register (A000:FF20h through MMIO) happens
    with interrupts off (2.04.11 pushf/cli around the operation, p19 ddcin/ddcout); the delays program
    PIT channel 2 with B6h (mode 3, low then high byte) and never write 86h, the latch command 2.04.07
    sent before loading a count; the probe's delay of 0255h arrives in AX (5E07, 2.04.07 loaded BX) and
    so is loaded as 04AAh (mode 3 counts by 2). The model has no monitor on the DDC lines: BX = 0000h.
    p22: on the card a latch within about 1.7 us of a load can still read the loaded count; the model
    returns it for the first latch after each load here, and every delay must read the counter again
    (p19 to p21 ended the wait on that first reading)."""
    if not c.ours:
        raise Skip('p19 DDC code (our ROM only)')
    m = c.machine()
    pit43, loads, mmio = [], [], []
    st = {'lo': None, 'fresh': False}
    reads = []                                  # latches of channel 2 after each load (FFFFh loads not counted)
    pit_count = m._pit_count

    def first_reads_loaded(ch):
        v = pit_count(ch)
        if ch == 0x42 and reads:
            reads[-1] += 1
            if st['fresh']:
                st['fresh'] = False
                return m.pit[ch]['reload'] or 0x10000
        return v
    m._pit_count = first_reads_loaded

    def out(uc, port, size, val, ud):
        if port == 0x43:
            pit43.append(val & 0xFF)
            st['lo'] = None
        elif port == 0x42:
            if st['lo'] is None:
                st['lo'] = val & 0xFF
            else:
                loads.append(st['lo'] | (val & 0xFF) << 8)
                if loads[-1] != 0xFFFF:
                    reads.append(0)
                    st['fresh'] = True
                st['lo'] = None

    def acc(uc, kind, addr, size, val, ud):
        mmio.append(bool(uc.reg_read(UC_X86_REG_EFLAGS) & 0x200))
    h1 = m.mu.hook_add(UC_HOOK_INSN, out, None, 1, 0, UC_X86_INS_OUT)
    h2 = m.mu.hook_add(UC_HOOK_MEM_READ | UC_HOOK_MEM_WRITE, acc, None, 0xAFF20, 0xAFF20)
    m.mu.ctl_remove_cache(0xC0000, 0xC8000)
    r = m.int10(0x4F15, bx=0x0000)
    m.mu.hook_del(h1)
    m.mu.hook_del(h2)
    check(r['ax'] == 0x004F, '4F15 BL=00h returned AX=%04X' % r['ax'])
    check(mmio, 'no access to the serial port register A000:FF20h')
    check(not any(mmio), '%d of %d serial port accesses with interrupts on' % (sum(mmio), len(mmio)))
    check(0x86 not in pit43, 'PIT channel 2 latch command 86h written (the 2.04.07 delay)')
    check(0xB6 in pit43, 'PIT channel 2 never set with B6h')
    check(0x04AA in loads, 'the probe delay 0255h not loaded as 04AAh (loads: %s)'
          % ' '.join('%04X' % x for x in loads[:8]))
    short = sum(1 for n in reads if n < 2)
    check(reads and not short, '%d of %d DDC delays ended on their first counter reading (the loaded count, p22)'
          % (short, len(reads)))
    return '%d serial port accesses, %d PIT loads, every delay read the counter at least twice, BX=%04X' % (
        len(mmio), len(loads), r['bx'])


def t_engine_init(c):
    """ENG-1 (docs/chip-rules.md): the power-on values of BEE8h index D and E are undefined, so software
    writes both before the first graphics engine command (Trio64UV+ update ER010-B item 4, about the
    Trio64V+ data book; Trio64V2 section 4.1). Through POST, mode 03h and the VESA modes 101h, 103h,
    105h, 111h, 112h: when the BIOS issues an engine command (9AE8h), BEE8h index D and E were written
    before the first one. Trio64V+, Trio64UV+ and Trio64V2 models; skipped when the BIOS uses no engine."""
    if Machine.chip not in ('vplus', 'uvplus', 'v2'):
        raise Skip('Trio64V+ family rule (--chip vplus, uvplus or v2)')
    m = c.machine()
    m.int10(0x03)
    for mode in (0x101, 0x103, 0x105, 0x111, 0x112):
        m.int10(0x4F02, bx=mode)
    m.int10(0x03)
    if not m.ge_cmds:
        raise Skip('the BIOS issues no graphics engine command')
    missing = {0xD, 0xE} - m.ge_first
    check(not missing, 'first engine command without BEE8h index %s written before (ENG-1)'
          % ' and '.join('%X' % i for i in sorted(missing)))
    return '%d engine commands, BEE8h D and E written first' % m.ge_cmds


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


TESTS = [('version', t_version), ('post', t_post), ('rom_patches', t_rom_patches), ('vplus_patches', t_vplus_patches), ('t64_patches', t_t64_patches), ('vga_registers', t_vga_registers),
         ('vga_palettes', t_vga_palettes),
         ('s3test', t_s3test), ('vshow', t_vshow), ('s3compat_vga', t_s3compat_vga), ('s3compat_vbe', t_s3compat_vbe), ('s3compat_full', t_s3compat_full),
         ('vgalog', t_vgalog), ('vgalog_mem', t_vgalog_mem), ('vgalog_trace', t_vgalog_trace), ('s3alias', t_s3alias),
         ('s3regs', t_s3regs), ('dos_exe', t_dos_exe), ('mono', t_mono), ('errors', t_errors), ('windows', t_windows), ('display_switch', t_display_switch), ('stores', t_stores),
         ('v2_writes', t_v2_writes), ('post_delay', t_post_delay), ('ddc', t_ddc), ('engine_init', t_engine_init)]

# Categories of each test (tests.py -t, --list): the standard the expected values come from (mda, cga,
# ega, vga = the IBM BIOS of that adapter; vbe = VESA; s3 = the chip and its datasheet; rom = the image
# itself), patch (our changes to the reference BIOS; with vplus the test runs on our Trio64V+ ROM
# 1.03-08-pN too, with t64 on our Trio64 ROM 1.5-07-pN, otherwise only on 2.04.07-pN), call (how the BIOS is called: registers, flags,
# invalid input), tools (our DOS tools, not the BIOS), and where it runs: card = a tool that also runs
# on the card, whose hardware log decides; emu = only in the emulator. vram: the result depends on
# the video memory size (the VESA mode list, 4F06 maximum, the mode set clear of the whole memory, the
# LFB window size in CR58); make emu-test runs these again with --vram 4. The others (VGA modes and
# functions, the tools) give the same output with 2 and 4 MB.
TAGS = {
    'version': 'rom patch vplus t64 emu', 'post': 'rom emu', 'rom_patches': 'rom patch emu vram',
    'vga_registers': 'mda cga ega vga emu', 'vga_palettes': 'cga ega vga emu',
    's3test': 'rom cga ega vga vbe s3 patch vplus t64 card vram', 'vshow': 'vbe tools card vram',
    's3compat_vga': 'cga ega vga card', 's3compat_vbe': 'vbe s3 card vram', 's3compat_full': 'cga ega vga vbe s3 card vram',
    'vgalog': 'tools card', 'vgalog_mem': 'tools card', 'vgalog_trace': 'tools card', 's3alias': 'tools patch card', 's3regs': 'tools s3 card',
    'dos_exe': 'tools emu', 'mono': 'mda emu', 'errors': 'call cga ega vga vbe emu vram',
    'windows': 'call vga vbe emu vram', 'display_switch': 'vga emu', 'stores': 'cga ega vga patch vplus t64 emu',
    'vplus_patches': 'rom vbe patch vplus emu vram', 't64_patches': 'rom vbe patch t64 emu vram',
    'v2_writes': 's3 emu', 'post_delay': 'rom patch emu', 'ddc': 'vbe patch emu', 'engine_init': 's3 emu',
}


# rough run times (s, 2 MB) to start the long tests first when they run in parallel
DURATION = {'s3compat_full': 480, 'vshow': 330, 's3compat_vbe': 200, 's3test': 90, 'windows': 60,
            'stores': 55, 's3compat_vga': 45}


# Our Trio64V+ ROM keeps these failures of its base 1.03-08, outside the backport (docs/vplus-backport.md,
# "Left as in 1.03-08"); the unpatched 1.03-08 fails the same lines. A test of that ROM whose failure lines
# all match passes with a note; any other line still fails it.
VPLUS_BASE = {
    # 1.03-08 sets the modes that need more memory than the card has (2 MB: 1024x768x16M, 1280x1024x32K/64K;
    # 1 MB also 107h, 112h, 115h-117h, 120h); the state then differs for the later refused calls too
    'errors': (r'4F02 BX=01(07|12|1[5-9A]|20) accepted',
               r'4F02 BX=0(1(07|12|1[5-9A]|20)|1FF|17F|200) \(refused\) changed the video state'),
    # 4F06 uses 32-bit registers and the 1.03-08 dispatcher saves the 16-bit ones only
    'windows': (r'4F06 set: upper halves changed: ',),
    # the DCLK VCO at 101 MHz in 320x200 15/16/32 bpp: the Trio64V+ post divider cannot reach 12.6 MHz with
    # the VCO in range; interlaced: 1600x1200, and with 4 MB 1024x768x16M and 1280x1024x32K/64K, whose
    # non-interlaced clocks are above the Trio64V+ limits for the depth
    's3compat_full': (r'VESA 010[DEF] 320x200x(15|16|32) .*VCO 101\.02MHz .*FAIL 0200$',
                      r'VESA 0120 1600x1200x8 .*WARN 50$', r'VESA 011[89A] .*WARN 10$'),
}


# Our Trio64 ROM keeps these of its base Phoenix 1.5-07 (docs/trio64-backport.md, "Left as in 1.5-07"); the
# unpatched 1.5-07 gives the same lines.
T64_BASE = {
    # with 1 MB Phoenix sets the modes that need more memory (107h, 112h, 115h-117h; the removed 118h-120h
    # did the same), and the state then differs for the later refused calls too
    'errors': VPLUS_BASE['errors'],
    # 4F06 uses 32-bit registers and the Phoenix dispatcher saves the 16-bit ones only
    'windows': (r'4F06 set: upper halves changed: ',),
    # S3COMPAT's run leaves a register state behind that differs from its baseline, on 1.5-07 as on our ROM
    's3compat_full': (r'Mode 03 after all tests vs baseline .*WARN 01$',),
}


def base_only(c, name, msg):
    """The number of failure lines when every one is a known failure of the base BIOS of our Trio64V+ or
    Trio64 ROM (VPLUS_BASE, T64_BASE), else 0."""
    lines = [l.strip() for l in msg.split('\n')[1:] if l.strip()]
    pats = VPLUS_BASE.get(name, ()) if c.vours else T64_BASE.get(name, ()) if c.tours else ()
    ok = lines and pats and all(any(re.match(p, l) for p in pats) for l in lines)
    return len(lines) if ok else 0


def run_test(c, name, fn, verbose):
    """One test: returns (result text, failed, seconds)."""
    t0 = time.time()
    bad = False
    try:
        tags = TAGS[name].split()
        if 'patch' in tags and not (c.ours or c.vours and 'vplus' in tags or c.tours and 't64' in tags):
            raise Skip('not our patched BIOS')
        note = fn(c)
        res = 'PASS' + ('  (%s)' % note if note else '')
    except Skip as e:
        res = 'SKIP  %s' % e
    except Exception as e:  # noqa: BLE001 - report every kind of failure as a test result
        n = base_only(c, name, str(e))
        if n:
            return 'PASS  (%d line%s as in %s)' % (n, 's' if n > 1 else '', '1.03-08, VPLUS_BASE' if c.vours
                                                     else '1.5-07, T64_BASE'), False, time.time() - t0
        bad = True
        res = 'FAIL  %s' % e
        if verbose:
            import traceback
            traceback.print_exc()
    return res, bad, time.time() - t0


def _worker(args):
    c, name, verbose = args
    print('%-14s started' % name, flush=True)
    res, bad, dt = run_test(c, name, dict(TESTS)[name], verbose)
    return name, res, bad, dt, Machine.noop_hits


def run_parallel(c, tests, a):
    """Run the tests in a.j processes (fork: the Machine settings are inherited), the long ones
    first; prints each result when it is done. Returns the number of failed tests."""
    import multiprocessing
    order = sorted(tests, key=lambda t: -DURATION.get(t[0], 5))
    failed = hits = 0
    ctx = multiprocessing.get_context('fork')
    with ctx.Pool(a.j) as pool:
        for name, res, bad, dt, h in pool.imap_unordered(_worker, [(c, n, a.v) for n, _ in order]):
            failed += bad
            hits += h
            first, _, rest = res.partition('\n')
            print('%-14s %-60s %5.0fs' % (name, first, dt) + ('\n' + rest if rest else ''), flush=True)
            if a.x and failed:
                pool.terminate()
                break
    if a.noop:
        print('noop: %d INT 10h calls matched %s' % (hits, a.noop))
    return failed


def main():
    global NASM
    ap = argparse.ArgumentParser(description='emulator tests for the Trio64V2 VBIOS tools')
    ap.add_argument('--rom', required=True, help='64 KB VBIOS image')
    ap.add_argument('--build', default=os.path.join(SRC, 'build'), help='folder with the built .COM files')
    ap.add_argument('--nasm', default=NASM, help='nasm executable or path for the tests that assemble code (default: '
                    '$NASM or nasm on the PATH; the project uses NASM 3.02)')
    ap.add_argument('-k', default='', help='run only tests whose name contains this text')
    ap.add_argument('-t', default='', help='run only tests with one of these categories (comma list: mda, cga, '
                    'ega, vga, vbe, s3, rom, patch, call, tools, card, emu, vram)')
    ap.add_argument('--list', action='store_true', help='list the tests with their categories')
    ap.add_argument('-v', action='store_true', help='print tracebacks')
    ap.add_argument('--logs', default=os.path.join(HERE, 'logs'),
                    help='folder for the tool output and /V debug files (default emu/logs)')
    ap.add_argument('--coverage', metavar='FILE',
                    help='record which ROM bytes the tests execute and read (all machines together) into FILE '
                         '(32 KB of code flags, then 32 KB of data flags, for emu/codemap.py)')
    ap.add_argument('--tests', default='', help='comma list: run these tests in this order (default all)')
    ap.add_argument('--skip', default='', help='comma list: leave these tests out (CI runs the longest ones in a '
                    'job of their own)')
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
    ap.add_argument('-j', type=int, default=1, metavar='N',
                    help='run N tests at a time, each in its own process (default 1; not with --coverage, '
                         '--profile or --calls). Each test prints a line when it starts and its result when done')
    ap.add_argument('--chip', choices=('v2', 'vplus', 'uvplus', 'trio64', 'trio32'), default='v2',
                    help='the chip the model is (vgaemu.CHIPS): v2 = Trio64V2/DX (the card, default), vplus = '
                         'Trio64V+, uvplus = Trio64UV+, trio64 = Trio64, trio32 = Trio32; ID registers, PCI device and the PLL post divider follow it')
    ap.add_argument('--vram', type=int, choices=(1, 2, 4), default=2,
                    help='video memory CR36 bits 7-5 report after POST: 2 MB (the card, default), 4 MB (the '
                         'maximum of every Trio64-family chip but the Trio32) or 1 MB (a Trio64V+ or Trio64 '
                         'card before an upgrade); the model still has one 64 KB window, no banked or linear memory')
    a = ap.parse_args()
    if a.chip == 'trio32' and a.vram == 4:
        ap.error('--vram 4: the Trio32 takes at most 2 MB (CR36 bits 7-5 = 000b is reserved on it)')
    Machine.vram = a.vram
    Machine.chip = a.chip
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
    NASM = os.path.abspath(a.nasm) if os.sep in a.nasm or '/' in a.nasm else a.nasm
    c = Ctx(a.rom, a.build, a.v, a.logs)
    failed = 0
    tests = TESTS
    if a.tests:
        byname = dict(TESTS)
        tests = [(t, byname[t]) for t in a.tests.split(',')]
    tests = [(n, f) for n, f in tests if a.k in n and (not a.t or set(a.t.split(',')) & set(TAGS[n].split()))
             and n not in a.skip.split(',')]
    if not c.ours:
        print('The ROM is not our patched BIOS (no 2.04.07-pN sign-on): the tests tagged patch are skipped'
              + (' unless tagged vplus (our Trio64V+ ROM 1.03-08-pN)' if c.vours else
                 ' unless tagged t64 (our Trio64 ROM 1.5-07-pN)' if c.tours else ''))

    if a.j > 1 and not (a.coverage or a.profile or a.calls):
        failed = run_parallel(c, tests, a)
        print('%d failed; tool output and /V debug logs in %s' % (failed, a.logs))
        sys.exit(1 if failed else 0)
    for name, fn in tests:
        if a.x and failed:
            break
        cur[0] = name
        if a.profile:
            Machine.calls = prof.setdefault(name, {'cov': [], 'calls': set()})['calls']
        print('%-14s ' % name, end='', flush=True)       # the test that is running now
        res, bad, dt = run_test(c, name, fn, a.v)
        failed += bad
        first, _, rest = res.partition('\n')
        print('%-60s %5.0fs' % (first, dt) + ('\n' + rest if rest else ''), flush=True)
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
