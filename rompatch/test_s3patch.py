#!/usr/bin/env python3
"""test_s3patch.py - checksum tests for the ROM patcher s3patch.py (needs python3 and nasm).

    python3 rompatch/test_s3patch.py --ref REF2047.BIN [--stock STOCK.BIN] [--rom S3V2P16.BIN] [--nasm nasm]
    make 775-rom-test REF=REF2047.BIN [STOCK=STOCK.BIN] [ROM=S3V2P16.BIN]

REF2047.BIN is the 32 KB S3 reference BIOS 2.04.07, STOCK.BIN (optional) the 64 KB dump of the card
(its 2.04.11 must be refused), S3V2P16.BIN a build to compare with byte by byte. No ROM image is in the
repository.

Tests
  build          the reference gives the tested build: SHA-256 of the lower 32 KB 5e532240... (NASM 3.02),
                 sign-on 2.04.07-p22, byte-identical to --rom when given (a 64 KB --rom with zeros above,
                 as p15-p21 were built, compares by its lower 32 KB)
  checksums      the lower 32 KB sums to 00 (byte 7FFFh makes it so) and has the 55AAh header with
                 32 KB size, the upper 32 KB is a copy of the lower (#78)
  vco            every DCLK refresh entry runs its VCO in 170-340 MHz
  pllcodes       every DCLK refresh entry has M 1-127, N 1-31 and an R code the datasheet defines (SR12
                 bits 7-5: with bit 7 set only 100b), docs/chip-rules.md PLL-2 and V2-PLL-3
  free_space     the bytes of the free blocks 7C8B-7FEF that no code uses are still 00, so a later level
                 can use them
  input_64k      a 64 KB image with the reference in the lower half gives the same result, whatever
                 its upper half holds
  novco          --no-vco-fix keeps the 22 refresh entries below 170 MHz and still checksums
  mclk           --mclk 50, 55 and 60 (1-cycle EDO) and 66 (fast page) give a valid MCLK PLL pair within
                 0.5 MHz in that memory type's entry and change nothing else but the checksum; 61 MHz for
                 1-cycle EDO, 67 MHz for fast page and 39 MHz are refused (V2-MEM-1)
  refusals       nothing is written and the exit code is 1 for: an already patched image, one byte
                 changed at a patch site (p12, p13 and p14 sites, with the checksum corrected), a wrong
                 checksum, another BIOS version (the stock 2.04.11, with --stock)
Exit code 0 when every test passed.
"""
import argparse, hashlib, os, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import s3patch  # noqa: E402

failed = []
NASM = 'nasm'


def result(name, ok, info=''):
    print('%-12s %s%s' % (name, 'PASS' if ok else 'FAIL', '  ' + info if info else ''))
    if not ok:
        failed.append(name)


def run(tmp, data, args=()):
    """Run s3patch.py on data; returns (exit code, output bytes or None, stderr)."""
    inp, out = os.path.join(tmp, 'in.bin'), os.path.join(tmp, 'out.bin')
    if os.path.exists(out):
        os.remove(out)
    open(inp, 'wb').write(data)
    cmd = [sys.executable, os.path.join(HERE, 's3patch.py'), inp, '-o', out, '-q', '--nasm', NASM] + list(args)
    r = subprocess.run(cmd, capture_output=True, text=True)
    return r.returncode, (open(out, 'rb').read() if os.path.exists(out) else None), r.stderr.strip()


def image_checks(img):
    errs = []
    if len(img) != 0x10000:
        return ['size %d' % len(img)]
    if sum(img[:0x8000]) & 0xFF:
        errs.append('lower checksum %02X' % (sum(img[:0x8000]) & 0xFF))
    if img[0x7FFF] != (-sum(img[:0x7FFF])) & 0xFF:
        errs.append('byte 7FFF')
    if img[0x8000:] != img[:0x8000]:
        errs.append('upper half not a copy of the lower')
    if img[:3] != b'\x55\xAA\x40':
        errs.append('55AA header with 32 KB size')
    return errs


def pll_bad(img):
    return [e for e in s3patch.refresh_entries(img) if s3patch.pll_rule(img[e + 4], img[e + 5])]


def vco_out(img):
    return [e for e in s3patch.refresh_entries(img) if not 170 <= s3patch.pll(img[e + 4], img[e + 5])[0] <= 340]


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
    for mhz, mt in (('50', 'edo1'), ('55', 'edo1'), ('60', 'edo1'), ('66', 'fpm')):
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
    for mhz, mt in [('61', 'edo1'), ('67', 'fpm'), ('39', 'edo1')]:
        rc, out, err = run(tmp, ref, ['--mclk', mhz, '--memtype', mt])
        if rc != 1 or out is not None:
            bad.append('%s MHz %s not refused' % (mhz, mt))
    return bad


def main():
    global NASM
    ap = argparse.ArgumentParser(description='checksum tests for s3patch.py')
    ap.add_argument('--ref', required=True, help='32 KB S3 reference BIOS 2.04.07')
    ap.add_argument('--stock', help='64 KB stock dump of the card (its 2.04.11 must be refused)')
    ap.add_argument('--rom', help='a build to compare with')
    ap.add_argument('--nasm', default='nasm', help='nasm executable passed to s3patch.py')
    a = ap.parse_args()
    NASM = a.nasm
    ref = open(a.ref, 'rb').read()
    stock = open(a.stock, 'rb').read() if a.stock else None
    tmp = tempfile.mkdtemp(prefix='t_s3patch_')

    rc, img, err = run(tmp, ref)
    sha = hashlib.sha256(img[:0x8000]).hexdigest() if img else ''
    ok = rc == 0 and sha == s3patch.RESULT_SHA and b'Version 2.04.07-%s\r\n' % s3patch.LEVEL.encode() in img[:0x100]
    info = 'SHA-256 %s' % sha[:16] if ok else (err or 'SHA-256 %s' % sha)
    if ok and a.rom:
        rom = open(a.rom, 'rb').read()
        same = rom == img or (len(rom) == 0x10000 and rom[:0x8000] == img[:0x8000] and rom[0x8000:] == bytes(0x8000))
        ok, info = same, info + (', identical to ' if same else ', differs from ') + os.path.basename(a.rom)
    result('build', ok, info)
    if not img:
        print('%d failed' % len(failed))
        return 1
    errs = image_checks(img)
    result('checksums', not errs, '; '.join(errs) or 'lower %02X, upper 32 KB a copy' % img[0x7FFF])
    bad = vco_out(img)
    result('vco', not bad, ', '.join('%04X' % e for e in bad) or 'all entries in 170-340 MHz')
    bad = pll_bad(img)
    result('pllcodes', not bad, ', '.join('%04X' % e for e in bad) or 'all entries M 1-127, N 1-31, defined R')
    used = set()
    sym = s3patch.bios_symbols()
    for name, org, room, want in s3patch.BLOCKS:
        org = sym[org] if isinstance(org, str) else org
        used.update(range(org, org + room))
    free = [i for i in range(0x7C8B, 0x7FF0) if img[i] and i not in used]
    unused = [i for i in range(0x7C8B, 0x7FF0) if not img[i]]
    result('free_space', not free, 'nonzero outside the blocks: %s' % ', '.join('%04X' % i for i in free[:8])
           if free else '%d bytes 00 in 7C8B-7FEF' % len(unused))
    rc, img64, err = run(tmp, ref + bytes([0x5A]) * 0x8000)
    result('input_64k', rc == 0 and img64 == img, err or 'same result')
    rc, nimg, err = run(tmp, ref, ['--no-vco-fix'])
    low = len(vco_out(nimg)) if nimg else -1
    result('novco', rc == 0 and low == 22 and not image_checks(nimg), err or '%d entries below 170 MHz kept' % low)

    bad = mclk_cases(tmp, ref, img, s3patch.MCLK_ENTRY, run)
    result('mclk', not bad, '; '.join(bad) or '50, 55, 60 MHz edo1 and the fpm maximum valid, out-of-range values refused')
    s = s3patch.SITES
    cases = [('already patched', img[:0x8000]),
             ('p12 site (INT 10h entry)', corrupt(ref, s['int10'] + 2)),
             ('p13 site (text scroll fill)', corrupt(ref, s['txfull'] + 7)),
             ('p14 site (VGA clear)', corrupt(ref, s['vclr'] + 10)),
             ('bad checksum', ref[:0x7FFF] + bytes([ref[0x7FFF] ^ 0x55]))]
    if stock and len(stock) == 0x10000:
        cases.append(('stock 2.04.11', stock[:0x8000]))
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
