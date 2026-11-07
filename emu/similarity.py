#!/usr/bin/env python3
"""similarity.py - long identical byte runs between a candidate ROM and the reference ROMs.

    python3 emu/similarity.py CANDIDATE.BIN [--min 32] [--ref FILE ...] [--fonts S-E ...] [--tables S-E ...]

The clean-room check of docs/clean-room.md ("The process", step 6) and docs/cleanroom/README.md
("Checking the clean ROM (on the dirty side)"): a ROM written from the specification must not share long byte runs with the
BIOSes the dirty side read. The default references are the three in reference/ (Phoenix 1.5-07,
S3 1.03-08, S3 2.04.07); --ref adds others (and replaces the defaults when given).

Every maximal run of at least --min bytes (default 32) that occurs in both images is listed with its
offsets, once per candidate offset (the longest match). Runs made of one byte value (padding) are left
out. A run inside a font table of the candidate (give the tables with --fonts START-END, hex offsets
in the candidate) is marked FONT: font data may match by design (IBM-compatible glyphs) and is judged
separately from code. A run inside a table a public standard defines (the IBM video parameter table,
for example; --tables START-END) is marked STD. A run counts as FONT or STD when at least 90 % of its
bytes lie in such ranges; the exit code counts only the other runs.

Exit code 0 when no run outside those ranges reaches --min, 1 otherwise.
"""
import argparse, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
DEFAULT_REFS = [os.path.join(REPO, 'reference', p) for p in
                ('trio64/1_5_07.bin', '64vplus/1_03_08n.bin', 'v2/2_04_07.bin')]


def rom32(path):
    d = open(path, 'rb').read()
    if d[:2] == b'\x55\xAA' and d[2]:
        d = d[:d[2] * 512]
    return d


def runs(cand, ref, k, minlen):
    """Every maximal common run of minlen bytes or more (one value repeated, padding, excepted).

    Exhaustive (#144: an earlier version kept only the first 32 places of each k-byte window of ref and
    could miss a run): every place of every window is indexed, and a match is extended both ways along
    its diagonal (ref offset - candidate offset) once; later seeds inside a run already found on that
    diagonal are skipped, so repeated windows do not make the search quadratic. A run of minlen >= k
    bytes always has a k-byte window that is not one repeated value unless the whole run is one value.
    For each stretch of the candidate the longest run is reported; a run whose candidate bytes lie
    wholly inside a longer reported one is left out. Returns [(cand start, ref start, cand end)]."""
    index = {}
    for i in range(len(ref) - k + 1):
        w = ref[i:i + k]
        if w.count(w[0]) == k:                  # one byte value: padding, never the start of a run
            continue
        index.setdefault(w, []).append(i)
    done = {}                                   # diagonal -> candidate end of the last run found on it
    allruns = []
    for i in range(len(cand) - k + 1):
        for j in index.get(cand[i:i + k], ()):
            d = j - i
            if done.get(d, -1) > i:
                continue
            a, b = i, j
            while a > 0 and b > 0 and cand[a - 1] == ref[b - 1]:
                a -= 1
                b -= 1
            e, f = i + k, j + k
            while e < len(cand) and f < len(ref) and cand[e] == ref[f]:
                e += 1
                f += 1
            done[d] = e
            if e - a >= minlen and len(set(cand[a:e])) > 1:
                allruns.append((a, b, e))
    out = []
    for a, b, e in sorted(allruns, key=lambda r: (r[0] - r[2], r[0])):
        if not any(s <= a and e <= t for s, _, t in out):
            out.append((a, b, e))
    return sorted(out)


def merge(ranges):
    """Overlapping or touching (start, end) ranges, end inclusive, joined (#144: the coverage test
    counted an overlap twice)."""
    out = []
    for lo, hi in sorted(ranges):
        if out and lo <= out[-1][1] + 1:
            out[-1] = (out[-1][0], max(out[-1][1], hi))
        else:
            out.append((lo, hi))
    return out


def self_test():
    """The case the window cap missed (#144): every 16-byte window of a 32-byte run occurs 33 times
    earlier in the reference (two families of copies, each with one byte changed at an end), the run
    itself once at the end; and overlapping exclusion ranges. Returns the number of failures."""
    import random
    rnd = random.Random(2)
    run = bytearray(rnd.randrange(1, 255) for _ in range(32))
    fa, fb = bytearray(run), bytearray(run)
    fa[31] ^= 0xFF
    fb[0] ^= 0xFF
    ref = bytes((fa + b'\0') * 33 + (fb + b'\0') * 33) + bytes(5) + bytes(run) + bytes(5)
    cand = b'\x77' * 300 + bytes(run) + b'\x77' * 300
    fails = 0
    if runs(cand, ref, 16, 32) != [(300, 2183, 332)]:
        print('self-test: the run behind 66 near copies was not found')
        fails += 1
    if merge([(0x10, 0x30), (0x20, 0x40), (0x41, 0x50), (0x60, 0x70)]) != [(0x10, 0x50), (0x60, 0x70)]:
        print('self-test: ranges not merged')
        fails += 1
    print('self-test: %d failed' % fails)
    return fails


def main():
    if sys.argv[1:] == ['--self-test']:
        return 1 if self_test() else 0
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('candidate')
    ap.add_argument('--min', type=int, default=32, help='shortest run to report (bytes, default 32)')
    ap.add_argument('--ref', action='append', help='reference image (repeatable; default the three in reference/)')
    ap.add_argument('--fonts', action='append', default=[], metavar='START-END',
                    help='hex offset range of a font table in the candidate (repeatable)')
    ap.add_argument('--tables', action='append', default=[], metavar='START-END',
                    help='hex offset range of a table a public standard defines (repeatable)')
    a = ap.parse_args()
    cand = rom32(a.candidate)
    fonts = merge([tuple(int(x, 16) for x in r.split('-')) for r in a.fonts])
    tables = merge([tuple(int(x, 16) for x in r.split('-')) for r in a.tables])

    def inside(s, e, ranges):
        return sum(max(0, min(e, hi + 1) - max(s, lo)) for lo, hi in ranges) >= 0.9 * (e - s)
    k = min(16, a.min)
    bad = 0
    for ref_path in a.ref or DEFAULT_REFS:
        ref = rom32(ref_path)
        rs = runs(cand, ref, k, a.min)
        print('%s: %d run(s) of %d bytes or more' % (os.path.relpath(ref_path, REPO), len(rs), a.min))
        for s, r, e in rs:
            kind = 'FONT' if inside(s, e, fonts) else 'STD' if inside(s, e, tables) else ''
            bad += not kind
            print('  candidate %04X-%04X  reference %04X  %4d bytes  %-4s  %s'
                  % (s, e - 1, r, e - s, kind, cand[s:min(e, s + 16)].hex(' ')))
    print('%d run(s) outside the font and standard table ranges' % bad)
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
