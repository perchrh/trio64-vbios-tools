#!/usr/bin/env python3
"""cover.py - which bytes of the video BIOS (C000:0000-7FFF) are ever executed or read as data.

    python3 emu/cover.py --rom S3V2P15.BIN [--min 32]

Runs POST, every VGA mode (also at 200 and 350 lines), every S3 mode from the ROM's mode table, every
VESA mode in the 4F00 list (banked, linear, no-clear) with 4F03-4F09, the other VBE functions
(4F00-4F0A, 4F10, 4F14, 4F15) and the standard INT 10h functions in several modes, then prints the
ranges that were never touched (at least --min bytes) with their share of zero bytes. Used to look for
space in the ROM: an untouched range is a candidate to study, not proof that it is dead (error paths,
other memory sizes and monitor types are not exercised).
"""
import argparse, os, struct, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from vgaemu import Machine  # noqa: E402

BUF = 0x0800


def workload(m):
    I = m.int10
    for mode in range(0x14):
        for alt in (0, 1, 2):
            I(0x1200 | alt, bx=0x30)
            I(mode)
    I(0x1202, bx=0x30)
    rom = m.mem(0xC0000, 0x8000)
    o = 0x158
    while rom[o] != 0xFF and o < 0x400:              # S3 internal modes from the mode table
        I(rom[o])
        o += 9
    m.mu.mem_write(BUF * 16, b'VBE2')
    I(0x4F00, es=BUF, di=0)
    off, seg = struct.unpack('<HH', m.mem(BUF * 16 + 0x0E, 4))
    modes, a = [], seg * 16 + off
    while len(modes) < 120:
        v = struct.unpack('<H', m.mem(a, 2))[0]
        a += 2
        if v == 0xFFFF:
            break
        modes.append(v)
    for v in modes:
        I(0x4F01, cx=v, es=BUF, di=0x400)
        for f in (v, v | 0x4000, v | 0x8000):
            I(0x4F02, bx=f)
            I(0x4F03)
            for bl in (0, 1, 2, 3):
                I(0x4F06, bx=bl, cx=1024)
            I(0x4F05, bx=0, dx=1)
            I(0x4F05, bx=0x100)
            I(0x4F07, bx=0, cx=8, dx=10)
            I(0x4F07, bx=1)
            I(0x4F09, bx=0, cx=4, dx=0, es=BUF, di=0x600)
            I(0x4F09, bx=1, cx=4, dx=0, es=BUF, di=0x600)
    for dl in (0, 1, 2):
        I(0x4F04, dx=dl, cx=0x0F, es=BUF, bx=0x100)
    for bx in (0x0800, 0x0600, 0x0001):
        I(0x4F08, bx=bx)
    for bl in (0, 1, 2):
        I(0x4F0A, bx=bl)
    for bx in (0, 0x101, 0x201, 0x401, 0x801):
        I(0x4F10, bx=bx)
    for bl in range(16):
        I(0x4F14, bx=bl, cx=0x101)
    for bl in (0, 1, 2):
        I(0x4F15, bx=bl, es=BUF, di=0x400)
    for mode in (3, 1, 7, 0x12, 0x13, 0x0D, 0x10):
        I(mode)
        I(0x0100, cx=0x0607); I(0x0200, dx=0x0510); I(0x0300); I(0x0400); I(0x0501); I(0x0500)
        I(0x0601, bx=0x0700, dx=0x184F); I(0x0701, bx=0x0700, dx=0x184F); I(0x0800)
        I(0x0941, bx=0x1E, cx=3); I(0x0A42, cx=2); I(0x0B00, bx=1); I(0x0C05, cx=10, dx=10)
        I(0x0D00, cx=10, dx=10); I(0x0E41); I(0x0E0D); I(0x0E0A); I(0x0F00)
        for al in range(0x1C):
            I(0x1000 | al, bx=0x0102, cx=0x0203, dx=0x0400, es=BUF)
        for al in (0, 1, 2, 3, 4, 0x10, 0x11, 0x12, 0x14, 0x20, 0x21, 0x22, 0x23, 0x24):
            I(0x1100 | al, bx=0x0E00, cx=1, es=BUF)
            I(mode)
        for bh in range(8):
            I(0x1130, bx=bh << 8)
        for bl in (0x10, 0x20, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36):
            I(0x1200, bx=bl)
            I(0x1201, bx=bl)
        for al in (0, 1, 2, 3):
            I(0x1300 | al, bx=7, cx=3, es=BUF)
        I(0x1A00); I(0x1A01, bx=8); I(0x1B00, es=BUF)
        for al in (0, 1, 2):
            I(0x1C00 | al, cx=7, es=BUF)
    I(3)


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[1])
    ap.add_argument('--rom', required=True)
    ap.add_argument('--min', type=int, default=32, help='smallest untouched range to list')
    a = ap.parse_args()
    rom = open(a.rom, 'rb').read()
    m = Machine(rom)
    code, data = m.track_coverage()
    m.post()
    workload(m)
    used = [c or d for c, d in zip(code, data)]
    print('executed %d bytes, read as data %d bytes, untouched %d of 32768' %
          (sum(code), sum(data), used.count(0)))
    i = 0
    while i < 0x8000:
        if used[i]:
            i += 1
            continue
        j = i
        while j < 0x8000 and not used[j]:
            j += 1
        if j - i >= a.min:
            z = sum(1 for b in rom[i:j] if b == 0)
            print('%04X-%04X %5d bytes, %3d%% zero' % (i, j - 1, j - i, 100 * z // (j - i)))
        i = j


if __name__ == '__main__':
    main()
