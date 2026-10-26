#!/usr/bin/env python3
"""test_s3patch.py - checksum tests for the ROM patcher s3patch.py (needs python3 and nasm).

    python3 rompatch/test_s3patch.py --stock STOCK.BIN [--ref REF2047.BIN] [--p12 S3V2P12.BIN]
                                     [--p13 S3V2P13.BIN] [--nasm nasm]
    make rom-test STOCK=STOCK.BIN [REF=REF2047.BIN] [P12=S3V2P12.BIN] [P13=S3V2P13.BIN]

STOCK.BIN is the 64 KB dump of the card (BIOS 2.04.11), REF2047.BIN the 32 KB S3 reference BIOS
2.04.07, S3V2P12.BIN / S3V2P13.BIN builds to compare with byte by byte. No ROM image is in the
repository.

Tests
  stock_p12      the stock image patched to p12 (--target p12): SHA-256 165c2185..., byte-identical to
                 --p12 when given, sign-on 2.04.11-p12
  stock_p13      the stock image patched to p13 (the default target): SHA-256 5c3242cb..., byte-identical
                 to --p13 when given, sign-on 2.04.11-p13
  p13_vs_p12     p13 differs from p12 only in the p13 code and patch sites, the sign-on and the checksum
  ref_p12/p13    (with --ref) the 2.04.07 reference plus the stock upper half: SHA-256 c13fcbe0... (p12)
                 and b050b045... (p13), sign-ons 2.04.07-p12/-p13
  ref_novco      --no-vco-fix keeps the 16 reference refresh entries below 170 MHz
  checksums      in every result both 32 KB halves sum to 00, byte 7FFFh is the one that makes the
                 lower half sum to 00, the upper half equals the input's, 55AAh headers in place
  vco            every DCLK refresh entry runs its VCO in 170-340 MHz
  refusals       nothing is written and the exit code is 1 for: an already patched image, one byte
                 changed at a patch site (with the checksum corrected), a wrong checksum, an unknown
                 version, a 32 KB input without --upper
Exit code 0 when every test passed.
"""
import argparse, hashlib, os, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import s3patch  # noqa: E402

SHA = {('stock', 'p12'): '165c2185c98e4dbad25013b71dc0b26f0fe14aab0ab7fd1975961e4a3839e772',
       ('stock', 'p13'): '5c3242cb5510754a76e0c0612790afcfb684948494a62d5f5ec033e189105d45',
       ('ref', 'p12'): 'c13fcbe0daefa43871087c7b3c80b8b1312aa73934a28989f0972756f61badd6',
       ('ref', 'p13'): 'b050b04536cd4a2d0faeacd05d9a044c457dff8e61b3eb8f2fae2353bb2ac024'}
# p13 bytes that may differ from p12 in the stock image: sign-on, the p13 blocks, the p13 patch sites
P13_RANGES = [(0x0070, 0x00AB), (0x1227, 0x1235), (0x1442, 0x1457), (0x2EE0, 0x2F12), (0x3131, 0x3135),
              (0x317C, 0x3189), (0x351E, 0x3527), (0x59E1, 0x5A0A), (0x7F58, 0x7F71), (0x7FAF, 0x7FB7),
              (0x7FFF, 0x8000)]
failed = []
NASM = 'nasm'


def result(name, ok, info=''):
    print('%-12s %s%s' % (name, 'PASS' if ok else 'FAIL', '  ' + info if info else ''))
    if not ok:
        failed.append(name)


def run(tmp, data, args=(), upper=None):
    """Run s3patch.py on data; returns (exit code, output bytes or None, stderr)."""
    inp, out = os.path.join(tmp, 'in.bin'), os.path.join(tmp, 'out.bin')
    if os.path.exists(out):
        os.remove(out)
    open(inp, 'wb').write(data)
    cmd = [sys.executable, os.path.join(HERE, 's3patch.py'), inp, '-o', out, '-q', '--nasm', NASM] + list(args)
    if upper is not None:
        up = os.path.join(tmp, 'upper.bin')
        open(up, 'wb').write(upper)
        cmd += ['--upper', up]
    r = subprocess.run(cmd, capture_output=True, text=True)
    return r.returncode, (open(out, 'rb').read() if os.path.exists(out) else None), r.stderr.strip()


def image_checks(img, upper):
    errs = []
    if len(img) != 0x10000:
        return ['size %d' % len(img)]
    if sum(img[:0x8000]) & 0xFF or sum(img[0x8000:]) & 0xFF:
        errs.append('half checksums %02X/%02X' % (sum(img[:0x8000]) & 0xFF, sum(img[0x8000:]) & 0xFF))
    if img[0x7FFF] != (-sum(img[:0x7FFF])) & 0xFF:
        errs.append('byte 7FFF')
    if img[0x8000:] != upper:
        errs.append('upper half changed')
    if img[:2] != b'\x55\xAA' or img[0x8000:0x8002] != b'\x55\xAA':
        errs.append('55AA header')
    return errs


def vco_out(img):
    return [e for e in s3patch.refresh_entries(img) if not 170 <= s3patch.pll(img[e + 4], img[e + 5])[0] <= 340]


def main():
    global NASM
    ap = argparse.ArgumentParser(description='checksum tests for s3patch.py')
    ap.add_argument('--stock', required=True, help='64 KB stock image (BIOS 2.04.11)')
    ap.add_argument('--ref', help='32 KB S3 reference BIOS 2.04.07')
    ap.add_argument('--p12', help='p12 build to compare with')
    ap.add_argument('--p13', help='p13 build to compare with')
    ap.add_argument('--nasm', default='nasm', help='nasm executable passed to s3patch.py')
    a = ap.parse_args()
    NASM = a.nasm
    stock = open(a.stock, 'rb').read()
    tmp = tempfile.mkdtemp(prefix='t_s3patch_')
    results, imgs = [], {}

    for tgt, given in (('p12', a.p12), ('p13', a.p13)):
        rc, img, err = run(tmp, stock, ['--target', tgt])
        sha = hashlib.sha256(img).hexdigest() if img else ''
        ok = rc == 0 and sha == SHA[('stock', tgt)] and b'Version 2.04.11-%s\r\n' % tgt.encode() in img[:0x100]
        info = 'SHA-256 %s' % sha[:16] if ok else (err or 'SHA-256 %s' % sha)
        if ok and given:
            same = open(given, 'rb').read() == img
            ok, info = same, info + (', identical to ' if same else ', differs from ') + os.path.basename(given)
        result('stock_' + tgt, ok, info)
        if img:
            results.append(('stock ' + tgt, img, stock[0x8000:]))
            imgs[tgt] = img
    if 'p12' in imgs and 'p13' in imgs:
        out = [i for i in range(0x10000) if imgs['p12'][i] != imgs['p13'][i]
               and not any(lo <= i < hi for lo, hi in P13_RANGES)]
        result('p13_vs_p12', not out, 'differences outside the p13 ranges: %s' % ', '.join('%04X' % i for i in out[:8])
               if out else '%d bytes differ, all in the p13 ranges'
               % sum(1 for i in range(0x10000) if imgs['p12'][i] != imgs['p13'][i]))

    if a.ref:
        ref = open(a.ref, 'rb').read()
        for tgt in ('p12', 'p13'):
            rc, rimg, err = run(tmp, ref, ['--target', tgt], upper=stock)
            sha = hashlib.sha256(rimg).hexdigest() if rimg else ''
            ok = rc == 0 and sha == SHA[('ref', tgt)] and b'Version 2.04.07-%s\r\n' % tgt.encode() in rimg[:0x100]
            result('ref_' + tgt, ok, 'SHA-256 %s' % sha[:16] if ok else (err or 'SHA-256 %s' % sha))
            if rimg:
                results.append(('ref ' + tgt, rimg, stock[0x8000:]))
        rc, nimg, err = run(tmp, ref, ['--no-vco-fix'], upper=stock)
        low = len(vco_out(nimg)) if nimg else -1
        result('ref_novco', rc == 0 and low == 16 and not image_checks(nimg, stock[0x8000:]),
               '%d entries below 170 MHz kept' % low)

    errs = ['%s: %s' % (n, e) for n, im, up in results for e in image_checks(im, up)]
    result('checksums', results and not errs, '; '.join(errs) or ', '.join(
        '%s %02X/%02X' % (n, im[0x7FFF], im[0xFFFF]) for n, im, up in results))
    bad = ['%s %04X' % (n, e) for n, im, up in results for e in vco_out(im)]
    result('vco', results and not bad, ', '.join(bad) or 'all entries in 170-340 MHz')

    cases = []
    if 'p13' in imgs:
        cases.append(('already patched', imgs['p13'], ()))
    t = bytearray(stock)
    t[0x211A] ^= 1                                  # cmp ah,0Eh changed, checksum made right again
    t[0x7FFF] = (-sum(t[:0x7FFF])) & 0xFF
    cases.append(('patch site changed', bytes(t), ()))
    t = bytearray(stock)
    t[0x2EE7] ^= 1                                  # a p13 site (text scroll fill)
    t[0x7FFF] = (-sum(t[:0x7FFF])) & 0xFF
    cases.append(('p13 site changed', bytes(t), ()))
    t = bytearray(stock)
    t[0x7FFF] ^= 0x55
    cases.append(('bad checksum', bytes(t), ()))
    t = bytearray(stock)
    i = t.index(b'2.04.11')
    t[i:i + 7] = b'2.04.99'
    t[0x7FFF] = 0
    t[0x7FFF] = (-sum(t[:0x8000])) & 0xFF
    cases.append(('unknown version', bytes(t), ()))
    cases.append(('32 KB without --upper', stock[:0x8000], ()))
    bad = []
    for name, data, args in cases:
        rc, out, err = run(tmp, data, args)
        if rc != 1 or out is not None or not err:
            bad.append(name)
    result('refusals', not bad, 'not refused: ' + ', '.join(bad) if bad else '%d inputs refused' % len(cases))
    print('%d failed' % len(failed))
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main())
