#!/usr/bin/env python3
"""tests.py - emulator tests for the Trio64V2 VBIOS and the DOS tools (needs python3 and unicorn).

    python3 emu/tests.py --rom S3V2P9.BIN [--build build] [-k name] [-v]
    make emu-test ROM=S3V2P9.BIN

The ROM image is not in the repository; pass the 64 KB image of the card. The tools are taken from
--build (run make first). Each test prints PASS, FAIL (with the reason) or SKIP; the exit code is 1
when a test failed. The emulator has no video memory model and no real timing (see vgaemu.py), so the
tests only check what the model can judge: BIOS register values, BIOS data, palettes, VBE results,
and that the tools behave the same with and without /V.

Tests
  post             the ROM initialises and hooks INT 10h into C000
  vga_registers    every VGA mode in s3compat/vgaref.inc (incl. the 350-line text modes): the 62 standard
                   registers and the AH=1Bh state block equal the IBM reference
  vga_palettes     default DAC after each mode set: 256-colour table (13h), CGA (04h-06h, 0Dh, 0Eh),
                   EGA (all others)
  s3test           S3TEST runs to the end; the checks the model can judge pass; with /V the output is the
                   same and S3TEST.DBG is well formed
  vshow            VSHOW 101 runs; with /V the output is the same and VSHOW.DBG is well formed
  s3compat_vga     S3COMPAT's VGA and Mode X part (built with nasm from the source with the rest cut
                   out): no default-DAC failures and no register differences except the known model
                   artefacts; with /V the output is the same and S3COMPAT.DBG is well formed
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
    def __init__(self, rom, build, verbose):
        self.rom = open(rom, 'rb').read()
        self.build = build
        self.verbose = verbose

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


S3TEST_MUST_PASS = ['ROM checksum', 'MCLK SR10 SR11', 'CR36 memory type', 'SR1A pedestal off',
                    'Refresh defaults', '4F03 in boosted 101h', '4F05 set bank 3', '4F03 in linear 4101h',
                    '4F06 BL=3', 'CR50 in 512x384x8']


def t_s3test(c):
    com = c.tool('S3TEST.COM')
    r0 = c.machine().run_com(com, '')
    check(r0.exit and r0.exit[0] == 'exit', 'S3TEST did not end: %s' % (r0.exit,))
    out = r0.stdout.decode('latin1')
    check('Passed:' in out, 'no summary line')
    for name in S3TEST_MUST_PASS:
        line = [l for l in out.split('\r\n') if l.startswith(name)]
        check(line and line[0].rstrip().endswith('PASS'), 'not PASS: %s' % (line[0] if line else name))
    if has_verbose():
        r1 = c.machine().run_com(com, '/V')
        check(r1.stdout == r0.stdout, 'output differs with /V')
        check_dbg(r1.files.get('S3TEST.DBG'), 'S3TEST.DBG')
    return 'exit code %d' % r0.exit[1]


def t_vshow(c):
    com = c.tool('VSHOW.COM')
    r0 = c.machine().run_com(com, '101')
    check(r0.exit and r0.exit[0] == 'exit' and r0.exit[1] == 0, 'VSHOW 101 ended with %s' % (r0.exit,))
    rh = c.machine().run_com(com, '/H')
    check(b'VSHOW' in rh.stdout and b'/L' in rh.stdout, '/H shows no parameter list')
    if has_verbose():
        r1 = c.machine().run_com(com, '101 /V')
        check(r1.stdout == r0.stdout, 'output differs with /V')
        lines = check_dbg(r1.files.get('VSHOW.DBG'), 'VSHOW.DBG')
        check('D:TEST mode 0101' in lines, 'no D:TEST mode 0101')
        check(any(l.startswith('D:REG CR00:') for l in lines), 'no register dump')
        check(any(l.startswith('D:FRM n=31') for l in lines), 'no frame timing')


ALLOWED_DETAIL = re.compile(r'^(SR04=03\(02\)|DS\+26=..\(..\)|DS\+2D=..\(..\))$')


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
    r0 = c.machine().run_com(com, '')
    check(r0.exit and r0.exit[0] == 'exit', 'S3COMPAT did not end: %s' % (r0.exit,))
    lines = r0.stdout.decode('latin1').split('\r\n')
    tests = [l for l in lines if l.startswith(('VGA ', 'Mode ', 'Text 80x50')) and
             re.search(r'  (PASS|FAIL [0-9A-F]+|WARN [0-9A-F]+|INFO)$', l)]
    check(len(tests) >= 17 + 6, 'only %d VGA/Mode X lines' % len(tests))
    dac = [l for l in lines if 'DAC#' in l]
    check(not dac, 'default DAC wrong: %s' % dac[:2])
    bad = []
    for l in lines:
        if l.startswith('      '):
            for tok in l.split():
                if not ALLOWED_DETAIL.match(tok):
                    bad.append(tok)
    check(not bad, 'unexpected differences: %s' % ' '.join(bad[:10]))
    if has_verbose():
        r1 = c.machine().run_com(com, '/V')
        check(r1.stdout == r0.stdout, 'output differs with /V')
        dl = check_dbg(r1.files.get('S3COMPAT.DBG'), 'S3COMPAT.DBG')
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


TESTS = [('post', t_post), ('vga_registers', t_vga_registers), ('vga_palettes', t_vga_palettes),
         ('s3test', t_s3test), ('vshow', t_vshow), ('s3compat_vga', t_s3compat_vga),
         ('vgalog', t_vgalog), ('s3alias', t_s3alias)]


def main():
    ap = argparse.ArgumentParser(description='emulator tests for the Trio64V2 VBIOS tools')
    ap.add_argument('--rom', required=True, help='64 KB VBIOS image')
    ap.add_argument('--build', default=os.path.join(SRC, 'build'), help='folder with the built .COM files')
    ap.add_argument('-k', default='', help='run only tests whose name contains this text')
    ap.add_argument('-v', action='store_true', help='print tracebacks')
    a = ap.parse_args()
    c = Ctx(a.rom, a.build, a.v)
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
        print('%-14s %-60s %5.0fs' % (name, res, time.time() - t0), flush=True)
    print('%d failed' % failed)
    sys.exit(1 if failed else 0)


if __name__ == '__main__':
    main()
