#!/usr/bin/env python3
"""test_s3p12.py - checksum tests for the ROM patcher s3p12.py (needs python3 and nasm).

    python3 rompatch/test_s3p12.py --stock STOCK.BIN [--ref REF2047.BIN] [--p12 S3V2P12.BIN] [--nasm nasm]
    make rom-test STOCK=STOCK.BIN [REF=REF2047.BIN] [P12=S3V2P12.BIN]

STOCK.BIN is the 64 KB dump of the card (BIOS 2.04.11), REF2047.BIN the 32 KB S3 reference BIOS
2.04.07, S3V2P12.BIN the p12 build to compare with byte by byte. No ROM image is in the repository.

Tests
  stock_p12      the stock image patches to the p12 build: SHA-256 165c2185..., and byte-identical to
                 --p12 when given; sign-on 2.04.11-p12
  checksums      in every result both 32 KB halves sum to 00, byte 7FFFh is the one that makes the
                 lower half sum to 00, the upper half equals the input's, 55AAh headers in place
  vco            every DCLK refresh entry runs its VCO in 170-340 MHz
  ref_p12        (with --ref) the 2.04.07 reference plus the stock upper half: SHA-256 c13fcbe0...,
                 sign-on 2.04.07-p12, the same checks; with --no-vco-fix 16 entries stay below 170 MHz
  refusals       nothing is written and the exit code is 1 for: an already patched image, one byte
                 changed at a patch site (with the checksum corrected), a wrong checksum, an unknown
                 version, a 32 KB input without --upper
Exit code 0 when every test passed.
"""
import argparse, hashlib, os, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import s3p12  # noqa: E402

P12_SHA = '165c2185c98e4dbad25013b71dc0b26f0fe14aab0ab7fd1975961e4a3839e772'
REF_SHA = 'c13fcbe0daefa43871087c7b3c80b8b1312aa73934a28989f0972756f61badd6'
failed = []
NASM = 'nasm'


def result(name, ok, info=''):
    print('%-12s %s%s' % (name, 'PASS' if ok else 'FAIL', '  ' + info if info else ''))
    if not ok:
        failed.append(name)


def run(tmp, data, args=(), upper=None):
    """Run s3p12.py on data; returns (exit code, output bytes or None, stderr)."""
    inp, out = os.path.join(tmp, 'in.bin'), os.path.join(tmp, 'out.bin')
    if os.path.exists(out):
        os.remove(out)
    open(inp, 'wb').write(data)
    cmd = [sys.executable, os.path.join(HERE, 's3p12.py'), inp, '-o', out, '-q', '--nasm', NASM] + list(args)
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
    return [e for e in s3p12.refresh_entries(img) if not 170 <= s3p12.pll(img[e + 4], img[e + 5])[0] <= 340]


def main():
    ap = argparse.ArgumentParser(description='checksum tests for s3p12.py')
    ap.add_argument('--stock', required=True, help='64 KB stock image (BIOS 2.04.11)')
    ap.add_argument('--ref', help='32 KB S3 reference BIOS 2.04.07')
    ap.add_argument('--p12', help='p12 build to compare with')
    ap.add_argument('--nasm', default='nasm', help='nasm executable passed to s3p12.py')
    a = ap.parse_args()
    global NASM
    NASM = a.nasm
    stock = open(a.stock, 'rb').read()
    tmp = tempfile.mkdtemp(prefix='t_s3p12_')

    rc, img, err = run(tmp, stock)
    sha = hashlib.sha256(img).hexdigest() if img else ''
    ok = rc == 0 and sha == P12_SHA and b'Version 2.04.11-p12\r\n' in img[:0x100]
    info = 'SHA-256 %s' % sha[:16] if ok else (err or 'SHA-256 %s' % sha)
    if ok and a.p12:
        same = open(a.p12, 'rb').read() == img
        ok, info = same, info + (', identical to ' if same else ', differs from ') + os.path.basename(a.p12)
    result('stock_p12', ok, info)
    results = [('stock', img, stock[0x8000:])] if img else []

    if a.ref:
        ref = open(a.ref, 'rb').read()
        rc, rimg, err = run(tmp, ref, upper=stock)
        sha = hashlib.sha256(rimg).hexdigest() if rimg else ''
        ok = rc == 0 and sha == REF_SHA and b'Version 2.04.07-p12\r\n' in rimg[:0x100]
        result('ref_p12', ok, 'SHA-256 %s' % sha[:16] if ok else (err or 'SHA-256 %s' % sha))
        if rimg:
            results.append(('ref', rimg, stock[0x8000:]))
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
    if img:
        cases.append(('already patched', img, ()))
    t = bytearray(stock)
    t[0x211A] ^= 1                                  # cmp ah,0Eh changed, checksum made right again
    t[0x7FFF] = (-sum(t[:0x7FFF])) & 0xFF
    cases.append(('patch site changed', bytes(t), ()))
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
