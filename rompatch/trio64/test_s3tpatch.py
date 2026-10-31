#!/usr/bin/env python3
"""test_s3tpatch.py - checksum and table tests for the Trio64 ROM patcher s3tpatch.py (needs python3 and nasm).

    python3 rompatch/trio64/test_s3tpatch.py [--ref 1_5_07.BIN] [--rom S3T64P1.BIN] [--nasm nasm]
    make trom-test [TREF=...] [ROM=S3T64P1.BIN]

--ref is the 32 KB Phoenix S3 Trio64 BIOS 1.5-07 (default reference/trio64/1_5_07.bin), --rom a build to
compare with byte by byte.

Tests
  build          1.5-07 gives the tested build: the SHA-256 pinned in s3tpatch.py (NASM 3.02) over the
                 lower 32 KB, sign-on 1.5-07-p1, 64 KB with the 32 KB twice (the default, #78), the
                 lower 32 KB byte-identical to --rom when given (a 32 or 64 KB image)
  checksums      the 32 KB sum to 00 (byte 7FFFh makes it so) and have the 55AAh header with 32 KB size
  tables         every mode's refresh list starts with a non-interlaced entry, the five interlaced-only
                 modes are gone from the mode table, the VESA lists and the mode map, every kept entry is
                 byte for byte the one of 1.5-07 (only bit 7 of a new first entry set), and no list
                 reaches into the code placed after the lists
  fonts          all five font tables are those of 1.03-08 (--vref) byte for byte, end to end from 5720h
                 to 7F90h, and the eight references to the moved 8x16 font and 9x16 table point at their
                 new places; --fonts-only changes only the fonts, those references and the checksum byte
  ddc            the 4F15 sites carry their new bytes and the VDIF code (DDC_FREED) is zero
  unchanged      outside the tables, the fonts, the patch sites (DDC ones too), the code blocks, the
                 zeroed VDIF code, the sign-on and the checksum every byte is as in 1.5-07
  oem_build      a 1.5-07 build with other memory timing bytes in its refresh entries and another MCLK
                 (as the card makers' builds differ) is patched too and keeps them
  input_64k      a 64 KB image with 1.5-07 in the lower half gives the same result, whatever its upper half
  size32         --size 32 gives the same lower 32 KB alone
  mclk           --mclk 50, 55 and 60 give a valid MCLK PLL pair within 0.5 MHz at 3B5h and change nothing
                 else but the checksum; 61 MHz and 39 MHz are refused (MEM-1: 60 MHz on the Trio64); with
                 --overclock 69.8 and 100 MHz are valid, 101 MHz and --overclock without --mclk refused
  refusals       nothing is written and the exit code is 1 for: an already patched image, one byte changed
                 in the code (1000h-7EFFh), a wrong checksum, the Trio64V+ BIOS 1.03-08
Exit code 0 when every test passed.
"""
import argparse, hashlib, os, struct, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)
import s3tpatch  # noqa: E402

failed = []
NASM = 'nasm'


def result(name, ok, info=''):
    print('%-12s %s%s' % (name, 'PASS' if ok else 'FAIL', '  ' + info if info else ''))
    if not ok:
        failed.append(name)


def run(tmp, data, args=()):
    """Run s3tpatch.py on data; returns (exit code, output bytes or None, stderr)."""
    inp, out = os.path.join(tmp, 'in.bin'), os.path.join(tmp, 'out.bin')
    if os.path.exists(out):
        os.remove(out)
    open(inp, 'wb').write(data)
    cmd = [sys.executable, os.path.join(HERE, 's3tpatch.py'), inp, '-o', out, '-q', '--nasm', NASM] + list(args)
    r = subprocess.run(cmd, capture_output=True, text=True)
    return r.returncode, (open(out, 'rb').read() if os.path.exists(out) else None), r.stderr.strip()


def fixsum(b):
    b = bytearray(b)
    b[0x7FFF] = 0
    b[0x7FFF] = (-sum(b[:0x7FFF])) & 0xFF
    return bytes(b)


def table_check(ref, img):
    """The table property of the tables test: [] when it holds, else the problems."""
    errs = []
    modes, mend, chains = s3tpatch.lists_of(img)
    rmodes, _, rchains = s3tpatch.lists_of(ref)
    gone = set(s3tpatch.REMOVE) & {m for _, m, _, _ in modes}
    if gone:
        errs.append('modes still listed: %s' % ', '.join('%02X' % m for m in gone))
    ilace = {bytes.fromhex(b): e for e, b in s3tpatch.ILACE.items()}
    for m, ch in chains.items():
        old = [ref[e:e + s3tpatch.ENT] for e in rchains[m] if e not in s3tpatch.ILACE]
        new = [bytearray(img[e:e + s3tpatch.ENT]) for e in ch]
        if new:
            new[0][2] &= 0x7F
            if old:
                old = [bytearray(x) for x in old]
                old[0][2] &= 0x7F
        if [bytes(x) for x in new] != [bytes(x) for x in old]:
            errs.append('mode %02X: refresh entries differ from 1.5-07' % m)
        if any(bytes(img[e:e + 5]) in ilace for e in ch):
            errs.append('mode %02X: an interlaced entry is left' % m)
    last = max(e for ch in chains.values() for e in ch) + s3tpatch.ENT
    sym = s3tpatch.s3patch.bios_symbols(os.path.join(HERE, 'bios.inc'))
    if last > sym['TBON']:
        errs.append('the refresh lists end at %04X, after the code at %04X' % (last, sym['TBON']))
    vl, a = [], s3tpatch.VLIST
    while struct.unpack_from('<H', img, a)[0] != 0xFFFF:
        vl.append(struct.unpack_from('<H', img, a)[0])
        a += 2
    if set(vl) & set(s3tpatch.REMOVE.values()):
        errs.append('VESA list still has %s' % sorted(set(vl) & set(s3tpatch.REMOVE.values())))
    return errs


def main():
    global NASM
    ap = argparse.ArgumentParser(description='checksum and table tests for s3tpatch.py')
    ap.add_argument('--ref', default=os.path.join(REPO, 'reference', 'trio64', '1_5_07.bin'), help='32 KB Phoenix Trio64 BIOS 1.5-07')
    ap.add_argument('--vref', default=os.path.join(REPO, 'reference', 'vplus', '1_03_08.bin'), help='32 KB Trio64V+ 1.03-08 (must be refused)')
    ap.add_argument('--rom', help='a build to compare with')
    ap.add_argument('--nasm', default='nasm', help='nasm executable passed to s3tpatch.py')
    a = ap.parse_args()
    NASM = a.nasm
    ref = open(a.ref, 'rb').read()[:0x8000]
    tmp = tempfile.mkdtemp(prefix='t_s3tpatch_')

    rc, img, err = run(tmp, ref)
    want = 'Version %s-%s' % (s3tpatch.VERSION, s3tpatch.LEVEL)
    ok = rc == 0 and img is not None and len(img) == 0x10000 and img[0x8000:] == img[:0x8000]
    lo = img[:0x8000] if img else b''
    sha = hashlib.sha256(lo).hexdigest() if img else ''
    ok = ok and sha == s3tpatch.RESULT_SHA and want.encode() in img[:0x100]
    info = 'SHA-256 %s' % sha[:16] if ok else (err or 'SHA-256 %s' % sha)
    if ok and a.rom:
        same = open(a.rom, 'rb').read()[:0x8000] == lo
        ok, info = same, info + (', identical to ' if same else ', differs from ') + os.path.basename(a.rom)
    result('build', ok, info)
    if not img:
        print('%d failed' % len(failed))
        return 1
    errs = []
    if sum(img) & 0xFF:
        errs.append('checksum %02X' % (sum(img) & 0xFF))
    if img[:3] != b'\x55\xAA\x40':
        errs.append('55AA header with 32 KB size')
    result('checksums', not errs, '; '.join(errs) or 'checksum byte %02X' % img[0x7FFF])
    errs = table_check(ref, img)
    result('tables', not errs, '; '.join(errs[:4]) or '%d interlaced entries and %d modes gone, kept entries unchanged'
           % (len(s3tpatch.ILACE), len(s3tpatch.REMOVE)))
    errs = []
    if os.path.exists(a.vref):
        v = open(a.vref, 'rb').read()
        where = {}
        for name, so, ln, _, at in s3tpatch.S3FONTS:
            where[name] = at
            if img[at:at + ln] != v[so:so + ln]:
                errs.append('%s font at %04X is not S3\'s' % (name, at))
        for a_, old in s3tpatch.FONT_REFS.items():
            want = where['8x16'] if old == 0x6E30 else where['9x16 alternate']
            if struct.unpack_from('<H', img, a_)[0] != want:
                errs.append('font reference %04X not %04X' % (a_, want))
        rc, fref, err = run(tmp, ref, ['--fonts-only'])
        if rc or not fref:
            errs.append('--fonts-only: ' + err)
        else:
            fonts = set(range(*s3tpatch.FONTS))
            for a_ in s3tpatch.FONT_REFS:
                fonts |= {a_, a_ + 1}
            if any(fref[i] != ref[i] for i in range(0x7FFF) if i not in fonts) or \
                    any(fref[i] != img[i] for i in fonts) or sum(fref) & 0xFF:
                errs.append('--fonts-only changes other bytes or not the same fonts')
    else:
        errs.append('no %s' % a.vref)
    result('fonts', not errs, '; '.join(errs) or 'the five tables of 1.03-08, %d references moved; --fonts-only the same'
           % len(s3tpatch.FONT_REFS))
    errs = []
    for a_, _, new in s3tpatch.DDC_SITES:
        if img[a_:a_ + len(new.split())] != bytes.fromhex(new):
            errs.append('site %04X' % a_)
    for lo, hi, _ in s3tpatch.DDC_FREED:
        if img[lo:hi] != bytes(hi - lo):
            errs.append('%04X-%04X not zero' % (lo, hi - 1))
    result('ddc', not errs, '; '.join(errs) or '4F15 sites patched, %d bytes of VDIF code zero'
           % sum(hi - lo for lo, hi, _ in s3tpatch.DDC_FREED))
    # every changed byte belongs to the tables, the fonts, a site, a block, the sign-on or the checksum
    sym = s3tpatch.s3patch.bios_symbols(os.path.join(HERE, 'bios.inc'))
    allowed = set(range(*s3tpatch.LISTS)) | set(range(s3tpatch.MTAB, 0x0631)) | set(range(s3tpatch.VLIST, 0x4DE0))
    allowed |= set(range(*s3tpatch.FONTS))
    for a_, old, _ in s3tpatch.DDC_SITES:
        allowed |= set(range(a_, a_ + len(old.split())))
    for lo, hi, _ in s3tpatch.DDC_FREED:
        allowed |= set(range(lo, hi))
    for a_ in s3tpatch.FONT_REFS:
        allowed |= {a_, a_ + 1}
    for lo, hi in s3tpatch.DROPPED + s3tpatch.UNUSED:
        allowed |= set(range(lo, hi))
    for name, org, room, _ in s3tpatch.BLOCKS:
        o = sym[org] if isinstance(org, str) else org
        allowed |= set(range(o, o + room))
    for k, off in s3tpatch.SITES.items():
        allowed |= set(range(off, off + len(s3tpatch.SIG.get(k, '?? ?? ??').split())))
    allowed |= set(range(sym['WSET'], sym['WSET'] + 5)) | set(range(0x44, 0xE4)) | {0x7FFF}
    diff = [i for i in range(0x8000) if img[i] != ref[i] and i not in allowed]
    result('unchanged', not diff, 'changed elsewhere: %s' % ', '.join('%04X' % i for i in diff[:8]) if diff else
           '%d bytes differ, all in the tables, fonts, sites, blocks, sign-on, checksum' % sum(1 for i in range(0x8000) if img[i] != ref[i]))
    # another card maker's build: other timing bytes (entry bytes 5-8) and MCLK
    oem = bytearray(ref)
    for e in range(s3tpatch.LISTS[0], s3tpatch.LISTS[1], s3tpatch.ENT):
        oem[e + 5] ^= 0x10
        oem[e + 6] ^= 0x10
    oem[0x3B5:0x3B7] = b'\x79\x46'                  # 55.04 MHz, as the 1.5-07 EDO build
    oem = fixsum(oem)
    rc, oimg, err = run(tmp, oem)
    ok = rc == 0 and oimg is not None and not table_check(oem, oimg) and oimg[0x3B5:0x3B7] == b'\x79\x46'
    result('oem_build', ok, err or 'other timing bytes and MCLK kept')
    rc, img64, err = run(tmp, ref + bytes([0x5A]) * 0x8000)
    result('input_64k', rc == 0 and img64 == img, err or 'same result')
    rc, small, err = run(tmp, ref, ['--size', '32'])
    result('size32', rc == 0 and small == img[:0x8000], err or '32 KB, the same lower half')
    bad = []
    for mhz in ('50', '55', '60'):
        rc, out, err = run(tmp, ref, ['--mclk', mhz])
        if rc or not out:
            bad.append('%s MHz: %s' % (mhz, err))
            continue
        m, nr = out[0x3B5], out[0x3B6]
        vco = 14.31818 * (m + 2) / ((nr & 0x1F) + 2)
        f = vco / (1 << ((nr >> 5) & 3))
        diff = [i for i in range(0x8000) if out[i] != img[i] and i not in (0x3B5, 0x3B6, 0x7FFF)]
        if not (1 <= nr & 0x1F and not nr & 0x80 and 135 <= vco <= 270 and abs(f - float(mhz)) < 0.5) or diff:
            bad.append('%s MHz: %02X %02X (%.2f MHz), %d other bytes differ' % (mhz, m, nr, f, len(diff)))
    for mhz in ('61', '39'):
        rc, out, err = run(tmp, ref, ['--mclk', mhz])
        if rc != 1 or out is not None:
            bad.append('%s MHz not refused' % mhz)
    for mhz in ('69.8', '100'):                     # the overclock: up to twice 50 MHz, with --overclock only
        rc, out, err = run(tmp, ref, ['--mclk', mhz, '--overclock'])
        f = (14.31818 * (out[0x3B5] + 2) / ((out[0x3B6] & 0x1F) + 2) / (1 << ((out[0x3B6] >> 5) & 3))
             if rc == 0 and out else 0)
        if abs(f - float(mhz)) >= 1 or f > 100:      # 100 MHz: 99.43, the nearest PLL step below
            bad.append('%s MHz with --overclock: %s %.2f MHz' % (mhz, err, f))
    for args in (['--mclk', '101', '--overclock'], ['--overclock']):
        rc, out, err = run(tmp, ref, args)
        if rc != 1 or out is not None:
            bad.append('%s not refused' % ' '.join(args))
    result('mclk', not bad, '; '.join(bad) or '50, 55, 60 MHz valid at 3B5h, 61 and 39 MHz refused; with '
           '--overclock 69.8 and 100 MHz valid, 101 MHz refused')
    code = bytearray(ref)
    code[0x3000] ^= 1
    cases = [('already patched', img), ('code byte changed', fixsum(code)),
             ('bad checksum', ref[:0x7FFF] + bytes([ref[0x7FFF] ^ 0x55]))]
    if os.path.exists(a.vref):
        cases.append(('Trio64V+ 1.03-08', open(a.vref, 'rb').read()[:0x8000]))
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
