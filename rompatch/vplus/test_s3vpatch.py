#!/usr/bin/env python3
"""test_s3vpatch.py - checksum tests for the Trio64V+ ROM patcher s3vpatch.py (needs python3 and nasm).

    python3 rompatch/vplus/test_s3vpatch.py [--ref 1_03_08.BIN] [--ref775 2_04_07.BIN] [--rom S3VPP1.BIN] [--nasm nasm]
    make 765-rom-test [REF765=...] [ROM=S3VPP1.BIN]

--ref is the 32 KB S3 Trio64V+ BIOS 1.03-08 (default reference/64vplus/1_03_08n.bin), --ref775 the Trio64V2
reference 2.04.07 (default reference/v2/2_04_07.bin; it must be refused), --rom a build to compare with
byte by byte.

Tests
  build          1.03-08 gives the tested build: the SHA-256 pinned in s3vpatch.py (NASM 3.02), sign-on
                 1.03-08-pN, 32 KB, byte-identical to --rom when given
  checksums      the 32 KB sum to 00 (byte 7FFFh makes it so) and have the 55AAh header with 32 KB size
  free_space     the bytes of the free block 7AE0-7FEF that no code uses are still 00, and 'Cardex1'
                 at 7FF0h is kept
  unchanged      outside the patch sites, the code blocks, the table edits of p2 (the interlaced modes and
                 refresh entries), the sign-on and the checksum every byte is as in 1.03-08 (the DCLK
                 values among them: no VCO fix on the Trio64V+)
  input_64k      a 64 KB image with 1.03-08 in the lower half gives the same result, whatever its upper
                 half holds
  size64         --size 64 gives the same 32 KB twice (#78)
  mclk           --mclk 50, 55 and 60 (1-cycle EDO) and 60 (fast page) give a valid MCLK PLL pair within
                 0.5 MHz in that memory type's entry and change nothing else but the checksum; 61 MHz and
                 39 MHz are refused (MEM-1: 60 MHz on the Trio64V+)
  refusals       nothing is written and the exit code is 1 for: an already patched image, one byte
                 changed at a patch site (INT 10h entry, text scroll fill, VGA clear), a wrong checksum,
                 the Trio64V2 reference 2.04.07
Exit code 0 when every test passed.
"""
import argparse, hashlib, os, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)
import s3vpatch  # noqa: E402

failed = []
NASM = 'nasm'


def result(name, ok, info=''):
    print('%-12s %s%s' % (name, 'PASS' if ok else 'FAIL', '  ' + info if info else ''))
    if not ok:
        failed.append(name)


def run(tmp, data, args=()):
    """Run s3vpatch.py on data; returns (exit code, output bytes or None, stderr)."""
    inp, out = os.path.join(tmp, 'in.bin'), os.path.join(tmp, 'out.bin')
    if os.path.exists(out):
        os.remove(out)
    open(inp, 'wb').write(data)
    cmd = [sys.executable, os.path.join(HERE, 's3vpatch.py'), inp, '-o', out, '-q', '--nasm', NASM] + list(args)
    r = subprocess.run(cmd, capture_output=True, text=True)
    return r.returncode, (open(out, 'rb').read() if os.path.exists(out) else None), r.stderr.strip()


def corrupt(img, off):
    t = bytearray(img)
    t[off] ^= 1
    t[0x7FFF] = (-sum(t[:0x7FFF])) & 0xFF
    return bytes(t)


def mclk_cases(tmp, ref, img, entries, run):
    """--mclk: 50, 55 and 60 MHz for edo1 and the highest allowed value for fpm give a valid MCLK PLL pair
    (M 1-127, N 1-31, SR10 bit 7 clear, VCO 135-270 MHz) within 0.5 MHz of the request in the entry of
    that memory type, and differ from the default build only there and in the checksum byte; values
    outside the limits are refused. Returns the problems."""
    bad = []
    for mhz, mt in (('50', 'edo1'), ('55', 'edo1'), ('60', 'edo1'), ('60', 'fpm')):
        rc, out, err = run(tmp, ref, ['--mclk', mhz, '--memtype', mt])
        if rc or not out:
            bad.append('%s MHz %s: %s' % (mhz, mt, err))
            continue
        a = entries[mt]
        m, nr = out[a], out[a + 1]
        vco = 14.31818 * (m + 2) / ((nr & 0x1F) + 2)
        f = vco / (1 << ((nr >> 5) & 3))
        diff = [i for i in range(0x8000) if out[i] != img[i] and i not in (a, a + 1, 0x7FFF)]
        if not (1 <= m <= 127 and 1 <= nr & 0x1F <= 31 and not nr & 0x80 and 135 <= vco <= 270
                and abs(f - float(mhz)) < 0.5) or diff or sum(out[:0x8000]) & 0xFF:
            bad.append('%s MHz %s: M %02X N/R %02X (%.2f MHz, VCO %.1f), %d other bytes differ'
                       % (mhz, mt, m, nr, f, vco, len(diff)))
    for mhz, mt in [('61', 'edo1'), ('61', 'fpm'), ('39', 'edo1')]:
        rc, out, err = run(tmp, ref, ['--mclk', mhz, '--memtype', mt])
        if rc != 1 or out is not None:
            bad.append('%s MHz %s not refused' % (mhz, mt))
    return bad


def main():
    global NASM
    ap = argparse.ArgumentParser(description='checksum tests for s3vpatch.py')
    ap.add_argument('--ref', default=os.path.join(REPO, 'reference', '64vplus', '1_03_08n.bin'),
                    help='32 KB S3 Trio64V+ BIOS 1.03-08')
    ap.add_argument('--ref775', default=os.path.join(REPO, 'reference', 'v2', '2_04_07.bin'),
                    help='32 KB Trio64V2 reference 2.04.07 (must be refused)')
    ap.add_argument('--rom', help='a build to compare with')
    ap.add_argument('--nasm', default='nasm', help='nasm executable passed to s3vpatch.py')
    a = ap.parse_args()
    NASM = a.nasm
    ref = open(a.ref, 'rb').read()[:0x8000]
    tmp = tempfile.mkdtemp(prefix='t_s3vpatch_')

    rc, img, err = run(tmp, ref)
    sha = hashlib.sha256(img).hexdigest() if img else ''
    want = 'Version %s-%s\r\n' % (s3vpatch.VERSION, s3vpatch.LEVEL)
    ok = rc == 0 and len(img) == 0x8000 and sha == s3vpatch.RESULT_SHA and want.encode() in img[:0x100]
    info = 'SHA-256 %s' % sha[:16] if ok else (err or 'SHA-256 %s' % sha)
    if ok and a.rom:
        same = open(a.rom, 'rb').read()[:0x8000] == img
        ok, info = same, info + (', identical to ' if same else ', differs from ') + os.path.basename(a.rom)
    result('build', ok, info)
    if not img:
        print('%d failed' % len(failed))
        return 1
    errs = []
    if sum(img) & 0xFF:
        errs.append('checksum %02X' % (sum(img) & 0xFF))
    if img[0x7FFF] != (-sum(img[:0x7FFF])) & 0xFF:
        errs.append('byte 7FFF')
    if img[:3] != b'\x55\xAA\x40':
        errs.append('55AA header with 32 KB size')
    result('checksums', not errs, '; '.join(errs) or 'checksum byte %02X' % img[0x7FFF])
    sym = s3vpatch.s3patch.bios_symbols(os.path.join(HERE, 'bios.inc'))
    ranges = s3vpatch.used_ranges(sym)
    used = set(i for lo, hi in ranges for i in range(lo, hi))
    lo, hi = s3vpatch.FREE_START, s3vpatch.FREE_END
    stray = [i for i in range(lo, hi) if img[i] and i not in used]
    unused = [i for i in range(lo, hi) if not img[i]]
    ok = not stray and img[0x7FF0:0x7FF7] == b'Cardex1'
    result('free_space', ok, 'nonzero outside the blocks: %s' % ', '.join('%04X' % i for i in stray[:8]) if stray
           else '%d bytes 00 in %04X-%04X, Cardex1 kept' % (len(unused), lo, hi - 1) if ok else 'Cardex1 changed')
    # every changed byte must belong to a patch site, a block, the sign-on or the checksum
    sites = set()
    for k, off in s3vpatch.SITES.items():
        if k != 'cr59':
            sites.update(range(off, off + len(s3vpatch.SIG.get(k, '?? ??').split())))
    sites.update(range(sym['WSET'], sym['WSET'] + 4))
    for off, b in (s3vpatch.S3TAB_DROP, s3vpatch.S3TAB_TAIL, s3vpatch.VLIST, s3vpatch.VENT):   # p2 tables
        sites.update(range(off, off + len(b.split())))
    sites.update(off + 2 for off in s3vpatch.ILACE_END)
    sites.update(i for off in s3vpatch.HALF_DCLK for i in (off + 3, off + 4))
    signon = set(range(0x3F, 0x8F))
    diff = [i for i in range(0x8000) if img[i] != ref[i] and i not in used | sites | signon | {0x7FFF}]
    result('unchanged', not diff, 'changed outside the patches: %s' % ', '.join('%04X' % i for i in diff[:8])
           if diff else '%d bytes differ, all at patch sites, code blocks, sign-on, checksum'
           % sum(1 for i in range(0x8000) if img[i] != ref[i]))
    rc, img64, err = run(tmp, ref + bytes([0x5A]) * 0x8000)
    result('input_64k', rc == 0 and img64 == img, err or 'same result')
    rc, big, err = run(tmp, ref, ['--size', '64'])
    result('size64', rc == 0 and big == img + img, err or '64 KB, the 32 KB twice')

    bad = mclk_cases(tmp, ref, img, s3vpatch.MCLK_ENTRY, run)
    result('mclk', not bad, '; '.join(bad) or '50, 55, 60 MHz edo1 and the fpm maximum valid, out-of-range values refused')
    s = s3vpatch.SITES
    cases = [('already patched', img),
             ('INT 10h entry', corrupt(ref, s['int10'] + 2)),
             ('text scroll fill', corrupt(ref, s['txfull'] + 7)),
             ('VGA clear', corrupt(ref, s['vclr'] + 10)),
             ('bad checksum', ref[:0x7FFF] + bytes([ref[0x7FFF] ^ 0x55]))]
    if os.path.exists(a.ref775):
        cases.append(('Trio64V2 2.04.07', open(a.ref775, 'rb').read()[:0x8000]))
    bad = []
    for name, data in cases:
        rc, out, err = run(tmp, data)
        if rc != 1 or out is not None or not err:
            bad.append(name)
    result('refusals', not bad, 'not refused: ' + ', '.join(bad) if bad else '%d inputs refused' % len(cases))
    print('%d failed' % len(failed))
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main())
