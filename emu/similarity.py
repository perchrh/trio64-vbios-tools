#!/usr/bin/env python3
"""similarity.py - long identical byte runs between a candidate ROM and the reference ROMs.

    python3 emu/similarity.py CANDIDATE.BIN [--min 32] [--ref FILE ...] [--fonts S-E ...] [--tables S-E ...]

The clean-room check of docs/clean-room.md ("The process", step 6) and docs/seavgabios-trio64.md
("Clean-room steps"): a ROM written from the specification must not share long byte runs with the
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
                ('trio64/1_5_07.bin', '64vplus/1_03_08.bin', 'v2/2_04_07.bin')]


def rom32(path):
    d = open(path, 'rb').read()
    if d[:2] == b'\x55\xAA' and d[2]:
        d = d[:d[2] * 512]
    return d


def runs(cand, ref, k, minlen):
    """Maximal common runs: index every k-byte window of ref, extend matches both ways."""
    index = {}
    for i in range(len(ref) - k + 1):
        w = ref[i:i + k]
        if w.count(w[0]) == k:                  # one byte value: padding, never the start of a run
            continue
        lst = index.setdefault(w, [])
        if len(lst) < 32:                       # a window repeated more often is table filler
            lst.append(i)
    found = {}
    i = 0
    while i <= len(cand) - k:
        best = None
        for j in index.get(cand[i:i + k], ()):
            a, b = i, j
            while a > 0 and b > 0 and cand[a - 1] == ref[b - 1]:
                a -= 1
                b -= 1
            e, f = i + k, j + k
            while e < len(cand) and f < len(ref) and cand[e] == ref[f]:
                e += 1
                f += 1
            if best is None or e - a > best[2] - best[0]:
                best = (a, b, e)
        if best and best[2] - best[0] >= minlen and len(set(cand[best[0]:best[2]])) > 1:
            if best[0] not in found or found[best[0]][2] < best[2]:
                found[best[0]] = best
            i = best[2]
        else:
            i += 1
    return sorted(found.values())


def main():
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
    fonts = [tuple(int(x, 16) for x in r.split('-')) for r in a.fonts]
    tables = [tuple(int(x, 16) for x in r.split('-')) for r in a.tables]

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
