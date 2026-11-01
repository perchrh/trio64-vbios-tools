#!/usr/bin/env python3
"""mutants.py - do the emulator tests notice when a BIOS feature does nothing? (mutation testing)

    python3 emu/mutants.py --rom S3V2P15.BIN --ref REF2047.BIN [-j 2] [-k text] [--list]

Each mutant is the ROM with one feature turned into a no-op; emu/tests.py runs on it (fast tests first,
stop at the first failure). A mutant is killed when a test fails, and survives when every test passes:
then no test notices that the feature is missing.

Mutants
  int10  one INT 10h function or subfunction returns at the ROM's entry with every register unchanged
         (tests.py --noop; the calls POST makes itself still run)
  Each mutant runs only the tests that can see it: those that call its INT 10h function, or execute or
  read its changed ROM bytes (one profile run of every test on the unchanged ROM first, kept in
  emu/logs/profile.json for that ROM). An INT 10h call of a test that takes more than --call-limit
  instructions (10 million) is a hang and kills the mutant.
  ret    a call target of the p12-p14 code returns at once (a RET at its first byte): wfill, wmove,
         bfill, the mode set hook, ...
  revert one patch site of the reference BIOS put back as it was (needs --ref): a data change, a jump
         to new code, one VCO-fixed refresh entry. The p12-p14 speed patches do the same work as the
         reference code, so only the tests that check how they work (rom_patches, S3TEST) can kill them

The sign-on and the checksums are kept valid in every mutant. Results go to stdout and to
emu/logs/mutants.txt; the exit code is 1 when a mutant survived that is not in EXPECTED.
"""
import argparse, os, subprocess, sys, tempfile, time
from concurrent.futures import ThreadPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(SRC, 'rompatch'))

NASM = os.environ.get('NASM', 'nasm')       # --nasm: the assembler, also passed to tests.py
ORDER = ('post,rom_patches,vga_registers,vga_palettes,mono,errors,display_switch,stores,s3compat_vga,s3compat_vbe,windows,vgalog,'
         'vgalog_mem,s3alias,s3regs,dos_exe,vshow,s3test,s3compat_full')


def int10_mutants():
    out = []

    def add(name, **pat):
        out.append(('int10 ' + name, ','.join('%s=%X' % kv for kv in pat.items())))
    for ah in (0x00, 0x01, 0x02, 0x03, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0C, 0x0D, 0x0E, 0x0F, 0x1B):
        add('AH=%02X' % ah, ah=ah)
    for bh in (0, 1):
        add('AH=0B BH=%d' % bh, ah=0x0B, bh=bh)
    for al in (0x00, 0x01, 0x02, 0x03, 0x07, 0x08, 0x09, 0x10, 0x12, 0x15, 0x17, 0x18, 0x19, 0x1A, 0x1B):
        add('AX=10%02X' % al, ax=0x1000 + al)
    for bl in (0, 1):
        add('AX=1013 BL=%d' % bl, ax=0x1013, bl=bl)
    for al in (0x00, 0x01, 0x02, 0x03, 0x04, 0x10, 0x11, 0x12, 0x14, 0x20, 0x21, 0x22, 0x23, 0x24, 0x30):
        add('AX=11%02X' % al, ax=0x1100 + al)
    for bl in (0x10, 0x20, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36):
        add('AH=12 BL=%02X' % bl, ah=0x12, bl=bl)
    for al in (0, 1, 2, 3):
        add('AX=13%02X' % al, ax=0x1300 + al)
    for al in (0, 1):
        add('AX=1A%02X' % al, ax=0x1A00 + al)
    for al in (0, 1, 2):
        add('AX=1C%02X' % al, ax=0x1C00 + al)
    for f in (0x4F00, 0x4F01, 0x4F02, 0x4F03, 0x4F08, 0x4F0A):
        add('AX=%04X' % f, ax=f)
    for dl in (0, 1, 2):
        add('AX=4F04 DL=%d' % dl, ax=0x4F04, dl=dl)
    for bh in (0, 1):
        add('AX=4F05 BH=%d' % bh, ax=0x4F05, bh=bh)
    for bl in (0, 1, 2, 3):
        add('AX=4F06 BL=%d' % bl, ax=0x4F06, bl=bl)
    for f, bls in ((0x4F07, (0, 1)), (0x4F09, (0, 1)), (0x4F10, (0, 1, 2)), (0x4F15, (0, 1))):
        for bl in bls:
            add('AX=%04X BL=%d' % (f, bl), ax=f, bl=bl)
    add('AX=4F14 BL=0', ax=0x4F14, bl=0)
    for bx in (0x0001, 0x0101, 0x0201, 0x0202, 0x0302):
        add('AX=4F14 BX=%04X' % bx, ax=0x4F14, bx=bx)
    return out


def fix(d):
    d[0x7FFF] = 0
    d[0x7FFF] = (-sum(d[:0x8000])) & 0xFF


def ret_mutants(rom):
    import s3patch
    _, lab = s3patch.assemble(s3patch.bios_symbols(), NASM)
    out = []
    for k in ('wfillt', 'wfill', 'wmove', 'bfill0', 'bfill', 'bfilla', 'dfdn', 'hook', 'boost', 'bl3',
              'basefix', 'lfbchk', 'crtc8'):
        if k == 'crtc8':
            continue                        # a CRTC table, not code
        d = bytearray(rom)
        d[lab[k]] = 0xC3
        fix(d)
        out.append(('ret %s' % k, bytes(d)))
    return out


def revert_mutants(rom, ref):
    """One mutant per patch site outside the new code areas: contiguous changed bytes (gaps of up to
    3 equal bytes joined), each put back to the reference."""
    import s3patch
    sym = s3patch.bios_symbols()
    new = [(s3patch.FREE_START, s3patch.FREE_END), (sym['P13A'], sym['P13A'] + 41),
           (sym['P13B'], sym['P13B'] + 21), (sym['P13C'], sym['P13C'] + 14), (0x7FFF, 0x8000)]
    m = s3patch.re.search(rb'Version 2\.04\.07', rom[:0x100])
    new.append((m.start(), rom.index(b'\x00', m.start()) + 1))    # the sign-on
    inside = lambda i: any(a <= i < b for a, b in new)
    diff = [i for i in range(0x8000) if rom[i] != ref[i] and not inside(i)]
    runs = []
    for i in diff:
        if runs and i - runs[-1][1] <= 4:
            runs[-1][1] = i
        else:
            runs.append([i, i])
    out = []
    for a, b in runs:
        d = bytearray(rom)
        d[a:b + 1] = ref[a:b + 1]
        fix(d)
        out.append(('revert %04X-%04X' % (a, b), bytes(d)))
    return out


# mutants that survive and why: no emulator test can see them (the result is the same) or the model
# lacks the hardware
EXPECTED = {
    'int10 AH=12 BL=20': 'the BIOS has no alternate print screen: a RET in 2.04.07 too (S3COMPAT WARN)',
    'int10 AX=4F15 BL=1': 'the model has no DDC lines; S3COMPAT reads the EDID on the card only',
    # refresh entries of S3 modes 3Dh/4Dh (VESA 119h/11Ah, 1280x1024 at 15/16 bpp, 2.5 MB): the card
    # and the model have 2 MB, so the BIOS refuses these modes and no test can set them
    'revert 084F-0850': '1280x1024x15/16 at 43 Hz: needs 2.5 MB, refused with 2 MB (--vram 4 kills it)',
    'revert 0879-087A': '1280x1024x15/16 at 85 Hz: needs 2.5 MB, refused with 2 MB (--vram 4 kills it)',
}


def run(m, rom_path, tmp, timeout, tests, limit, vram):
    name, what = m
    args = [sys.executable, os.path.join(HERE, 'tests.py'), '-x', '--nasm', NASM, '--tests', ','.join(tests), '--vram', str(vram),
            '--call-limit', str(limit), '--logs', tempfile.mkdtemp(dir=tmp)]
    if isinstance(what, str):
        args += ['--rom', rom_path, '--noop', what]
    else:
        p = os.path.join(tmp, name.replace(' ', '_') + '.bin')
        open(p, 'wb').write(what)
        args += ['--rom', p]
    t0 = time.time()
    try:
        r = subprocess.run(args, capture_output=True, text=True, timeout=timeout)
        out = r.stdout
    except subprocess.TimeoutExpired as e:
        return name, 'killed', 'timeout (hang)', time.time() - t0
    for line in out.split('\n'):
        if line[15:19] == 'FAIL':
            return name, 'killed', line[:14].strip() + ': ' + line[21:100].strip(), time.time() - t0
    hits = [l for l in out.split('\n') if l.startswith('noop:')]
    if hits and hits[0].startswith('noop: 0 '):
        return name, 'SURVIVED', 'never called by any test', time.time() - t0
    return name, 'SURVIVED', '', time.time() - t0


def matches(spec, calls):
    pats = [{k: int(v, 16) for k, v in (f.split('=') for f in spec.split(','))}]
    for ax, bx, dl in calls:
        v = {'ax': ax, 'ah': ax >> 8, 'al': ax & 0xFF, 'bx': bx, 'bh': bx >> 8, 'bl': bx & 0xFF, 'dl': dl}
        if any(all(v[k] == x for k, x in p.items()) for p in pats):
            return True
    return False


def main():
    global NASM
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[1])
    ap.add_argument('--rom', required=True)
    ap.add_argument('--ref', help='the reference BIOS 2.04.07 (32 or 64 KB) for the revert mutants')
    ap.add_argument('-j', type=int, default=os.cpu_count() or 1)
    ap.add_argument('-k', default='', help='only mutants whose name contains this text')
    ap.add_argument('--list', action='store_true')
    ap.add_argument('--timeout', type=int, default=1800)
    ap.add_argument('--vram', type=int, choices=(2, 4), default=2,
                    help='video memory of the model (tests.py --vram): 2 MB (the card) or 4 MB')
    ap.add_argument('--call-limit', type=int, default=10_000_000,
                    help='instructions an INT 10h call of a test may take in a mutant before it counts as a hang')
    ap.add_argument('--profile', metavar='FILE', default=os.path.join(HERE, 'logs', 'profile.json'),
                    help='per-test INT 10h calls and ROM bytes (tests.py --profile on the unchanged ROM); made '
                         'when missing or for another ROM')
    ap.add_argument('--resume', metavar='FILE', help='take the results of the mutants already in FILE (an earlier '
                    'mutants.txt) and run only the others')
    ap.add_argument('--nasm', default=NASM, help='nasm executable or path (default $NASM or nasm; NASM 3.02)')
    a = ap.parse_args()
    NASM = os.path.abspath(a.nasm) if '/' in a.nasm or os.sep in a.nasm else a.nasm
    rom = open(a.rom, 'rb').read()
    ms = int10_mutants() + ret_mutants(rom)
    if a.ref:
        ms += revert_mutants(rom, open(a.ref, 'rb').read()[:0x8000])
    ms = [m for m in ms if a.k in m[0]]
    if a.list:
        for n, _ in ms:
            print(n)
        return 0
    tmp = tempfile.mkdtemp(prefix='mutants_')
    res = []
    done = {}
    if a.resume and os.path.exists(a.resume):
        for line in open(a.resume):
            if line[25:33].strip() in ('killed', 'SURVIVED'):
                done[line[:25].strip()] = line.rstrip('\n')
    # which tests can see each mutant: one run of every test on the unchanged ROM records per test the
    # INT 10h calls and the ROM bytes it executes or reads; a mutant runs only the tests that call its
    # function or reach its bytes (in ORDER), and survives at once when no test does
    import hashlib, json
    sha = hashlib.sha256(rom + open(os.path.join(HERE, 'tests.py'), 'rb').read()).hexdigest()   # ROM and tests
    prof = None
    if os.path.exists(a.profile):
        prof = json.load(open(a.profile))
        if prof.get('rom') != sha or prof.get('call_limit') != a.call_limit or prof.get('vram', 2) != a.vram:
            prof = None
    if prof is None:
        pf = os.path.join(tmp, 'profile.json')
        r = subprocess.run([sys.executable, os.path.join(HERE, 'tests.py'), '--nasm', NASM, '--rom', a.rom, '--profile', pf,
                            '--call-limit', str(a.call_limit), '--vram', str(a.vram), '--logs', tempfile.mkdtemp(dir=tmp)],
                           capture_output=True, text=True)
        if r.returncode:
            print('the unchanged ROM does not pass every test (with --call-limit %d):\n%s' % (a.call_limit, r.stdout))
            return 2
        prof = {'rom': sha, 'call_limit': a.call_limit, 'vram': a.vram, 'tests': json.load(open(pf))}
        json.dump(prof, open(a.profile, 'w'))
    order = [t for t in ORDER.split(',') if t in prof['tests']]

    def tests_for(m):
        name, what = m
        if isinstance(what, str):
            return [t for t in order if matches(what, [tuple(c) for c in prof['tests'][t]['calls']])]
        changed = [i for i in range(0x8000) if what[i] != rom[i]]
        return [t for t in order if any(a0 <= i <= b0 for a0, b0 in prof['tests'][t]['rom'] for i in changed)]
    todo = []
    for m in ms:
        if m[0] in done:
            continue
        ts = tests_for(m)
        if not ts:
            why = 'never called by any test' if isinstance(m[1], str) else 'no test executes or reads these bytes'
            done[m[0]] = '%-24s %-8s %-70s %5.0fs' % (m[0], 'SURVIVED', why, 0)
            continue
        todo.append((m, ts))
    logf = os.path.join(HERE, 'logs', 'mutants.txt')
    os.makedirs(os.path.dirname(logf), exist_ok=True)
    with ThreadPoolExecutor(a.j) as ex, open(logf, 'w') as lf:
        for m in ms:
            if m[0] in done:
                line = done[m[0]]
                print(line, flush=True)
                lf.write(line + '\n')
                res.append((m[0], line[25:33].strip()))
        for name, st, why, dt in ex.map(lambda mt: run(mt[0], a.rom, tmp, a.timeout, mt[1], a.call_limit, a.vram), todo):
            line = '%-24s %-8s %-70s %5.0fs' % (name, st, why or EXPECTED.get(name, ''), dt)
            print(line, flush=True)
            lf.write(line + '\n')
            res.append((name, st))
    surv = [n for n, s in res if s == 'SURVIVED']
    bad = [n for n in surv if n not in EXPECTED]
    print('%d mutants, %d killed, %d survived (%d not expected)' % (len(res), len(res) - len(surv), len(surv), len(bad)))
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
