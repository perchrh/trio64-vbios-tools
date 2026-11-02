"""fonts.py - the text mode fonts of our three ROMs, built from Joseph Gil's public domain font collection.

    import fonts
    fonts.F8, fonts.F14, fonts.F16      the 8x8, 8x14 and 8x16 tables (256 glyphs each)
    fonts.ALT14, fonts.ALT16            the 9x14 and 9x16 alternate tables (IBM layout: character
                                        code, then 14 or 16 rows; ends with 00h)
    python3 rompatch/fonts/fonts.py     checks the source files and prints the tables' SHA-256

The source is FNTCOL16.ZIP (Gil's "fntcol16", version 1.6), whose COPYLEFT.TXT says the individual fonts
are in the public domain; the files below are copied from it unmodified (README.md has the details and
the SHA-256 of each). Nothing is taken from a BIOS or from another project's code.

    VGA-ROM.F08   8x8                          "VGA builtin font at height 8"
    VGA-ROM.F14   8x14                         "VGA builtin font at height 14"
    VGA-ROM.F16   8x16, with the 9-dot shapes   "VGA builtin font at height 16"
    PP_ROMAN.F16  8x16, with the 8-dot shapes   "Like cp437.f16. Different diactricts."
    STANDARD.F14  8x14, with the 9-dot shapes   "Hercules+ font: Standard rom like chars"

Why two shapes. In the 9-dot text modes (720 pixels across: 00h-03h, 07h) the attribute controller
draws a ninth, blank column after each glyph (a copy of the eighth for C0h-DFh), so a glyph may use all
eight columns; in the 8-dot modes (graphics modes, the VESA text modes) the eighth column must stay
blank or neighbouring characters touch. The VGA BIOS therefore keeps the 8-dot shapes in its 8x14 and
8x16 tables and a short "alternate" table per height that the mode set loads over them in the 9-dot
modes (AX=1130h BH=5 and 7). VGA-ROM.F16 holds the 9-dot shapes of 19 characters (the ones of the 9x16
alternate table), PP_ROMAN.F16 their 8-dot shapes; VGA-ROM.F14 holds 8-dot shapes only and STANDARD.F14
the 9-dot shapes of the 20 characters of the 9x14 alternate table. The tables below take the 8-dot shapes
for the main tables and the 9-dot ones for the alternates, so 8-dot and 9-dot modes both look right.
(SeaVGABIOS, from the same collection, uses VGA-ROM.F16 as it is and no alternates: 9-dot shapes in every
mode, the eighth column touching the next character in the 8-dot modes.)

Checked (2 November 2026): the five tables equal byte for byte the ones S3's BIOSes carry (1.03-08N, and
2.04.07 for the 8x8, the 8x16 and the 9x16 alternates), so our ROMs show what they showed before; the
SHA-256 values below pin that.
"""
import hashlib, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))

# SHA-256 of the files as they are in FNTCOL16.ZIP (README.md)
SOURCES = {
    'VGA-ROM.F08': '75c79a7e7fa423dda67ec6d6d76cec86b63f85677726368750c75b0920ddf319',
    'VGA-ROM.F14': '657ca6588b6bf729f0ed71a3d3c781a465bd30cdfb11eb5fc7e27594c0717ea1',
    'VGA-ROM.F16': 'c7dd5990fa5401649cf69e9bbb4c8a51f86865939b9318281a27de7f314eda3a',
    'PP_ROMAN.F16': '3c817b9339899f7d74f9d3243a150982d714ba64638851b1c8b09d9ae20c4c25',
    'STANDARD.F14': '87df0bb12b3da5d3adeb562f515dbe229c8c2ae998e99367b5bd5ad915ab122a',
}

# the characters of the alternate tables: their 9-dot shapes differ from the 8-dot ones
ALT16_CHARS = (0x1D, 0x30, 0x4D, 0x54, 0x56, 0x57, 0x58, 0x59, 0x5A, 0x6D, 0x76, 0x77, 0x78, 0x91, 0x9B,
               0x9D, 0x9E, 0xAB, 0xAC)
ALT14_CHARS = (0x1D, 0x22, 0x2B, 0x2D, 0x4D, 0x54, 0x56, 0x57, 0x58, 0x59, 0x5A, 0x6D, 0x76, 0x77, 0x91,
               0x9B, 0x9D, 0x9E, 0xF1, 0xF6)


def _read(name, height):
    data = open(os.path.join(HERE, name), 'rb').read()
    if len(data) != 256 * height or hashlib.sha256(data).hexdigest() != SOURCES[name]:
        raise SystemExit('%s: not the file of FNTCOL16.ZIP (size or SHA-256)' % name)
    return data


def _glyph(table, height, c):
    return table[c * height:(c + 1) * height]


_vga8 = _read('VGA-ROM.F08', 8)
_vga14 = _read('VGA-ROM.F14', 14)
_vga16 = _read('VGA-ROM.F16', 16)
_roman16 = _read('PP_ROMAN.F16', 16)
_std14 = _read('STANDARD.F14', 14)

F8 = _vga8
F14 = _vga14
# 8x16: VGA-ROM.F16, with the 8-dot shapes of the 19 alternate characters from PP_ROMAN.F16 (PP_ROMAN
# differs from VGA-ROM.F16 there and in the shades B0h-B2h only, which stay as in VGA-ROM.F16)
F16 = b''.join(_glyph(_roman16 if c in ALT16_CHARS else _vga16, 16, c) for c in range(256))
ALT16 = b''.join(bytes([c]) + _glyph(_vga16, 16, c) for c in ALT16_CHARS) + b'\x00'
ALT14 = b''.join(bytes([c]) + _glyph(_std14, 14, c) for c in ALT14_CHARS) + b'\x00'

# SHA-256 of the tables as built (the bytes S3's BIOSes carry, see the docstring)
TABLE_SHA = {
    'F8': '75c79a7e7fa423dda67ec6d6d76cec86b63f85677726368750c75b0920ddf319',
    'F14': '657ca6588b6bf729f0ed71a3d3c781a465bd30cdfb11eb5fc7e27594c0717ea1',
    'F16': 'a8bad6fd78475a6bc2a05438c19207a9bb8c0f4f4099f60384e158cdc3eba580',
    'ALT14': 'eeca821495071577f416370bb31f075aff1344d2170a1696901e708b8ac61b17',
    'ALT16': 'ebaabb3ef79a22c92935d68766b4543b3851289921b7806a0e82345635c8e224',
}


def check():
    """Every table has the SHA-256 it is pinned to; returns a list of the ones that differ."""
    tabs = {'F8': F8, 'F14': F14, 'F16': F16, 'ALT14': ALT14, 'ALT16': ALT16}
    return [n for n, t in tabs.items() if hashlib.sha256(t).hexdigest() != TABLE_SHA[n]]


if __name__ == '__main__':
    for n, t in (('F8', F8), ('F14', F14), ('F16', F16), ('ALT14', ALT14), ('ALT16', ALT16)):
        print('%-6s %5d bytes  SHA-256 %s' % (n, len(t), hashlib.sha256(t).hexdigest()))
    bad = check()
    print('every table as pinned' if not bad else 'differ from the pinned SHA-256: ' + ' '.join(bad))
    sys.exit(1 if bad else 0)
