# The text mode fonts (#141)

The font tables of all three ROMs are built from the files in this folder by [`fonts.py`](fonts.py), and
the patchers write them into the ROMs:
- [`s3patch.py`](../s3patch.py): in place, 2.04.07-p24 on;
- [`vplus/s3vpatch.py`](../vplus/s3vpatch.py): in place, 1.03-08N-p5 on;
- [`trio64/s3tpatch.py`](../trio64/s3tpatch.py): in place of Phoenix's tables, 1.5-07-p5 on. Before p5 it took them from S3's Trio64V+ BIOS.

The Trio64 build no longer reads the Trio64V+ reference image, and the fonts in our ROMs now come from
our own source files.

## Source

Joseph (Yossi) Gil's EGA/VGA screen font collection, FNTCOL16.ZIP, version 1.6. It is attached to issue
#141, as downloaded from
`http://ftp.lanet.lv/ftp/mirror/x2ftp/msdos/programming/misc/fntcol16.zip`; SHA-256 of the zip:
`10204dec39122dc6f...` (the zip's `__Source.txt`).

Five font files are copied from it **unmodified**, together with Gil's [`COPYLEFT.TXT`](COPYLEFT.TXT):

| File | SHA-256 | Gil's description (00-FILES.LST) | Used for |
| --- | --- | --- | --- |
| `VGA-ROM.F08` | 75c79a7e... | VGA builtin font at height 8 | the 8x8 table |
| `VGA-ROM.F14` | 657ca658... | VGA builtin font at height 14 | the 8x14 table |
| `VGA-ROM.F16` | c7dd5990... | VGA builtin font at height 16 | the 8x16 table, and the 9x16 alternates |
| `PP_ROMAN.F16` | 3c817b93... | Like cp437.f16. Different diactricts. | the 8-dot shapes of 19 characters |
| `STANDARD.F14` | 87df0bb1... | Hercules+ font: Standard rom like chars | the 9x14 alternates (20 characters) |

## Licence

From Gil's `COPYLEFT.TXT`:

> No one can claim any copyright on the fonts in this archive. They have been collected from numerous
> sources. Legally speaking, you are *free* to do with the individual fonts whatever you like.
> Individual fonts are in the public domain.

The compilation itself is "(c) Copyright 1991,1992 Joseph (Yossi) Gil". Its notice permits use and
redistribution "in any way (including conversion to another format), provided that my name and addresses
and this notice is preserved". It also asks people not to cause confusion by distributing modified
versions of the fonts.

So this folder keeps `COPYLEFT.TXT` whole, with Gil's name and addresses:
- yogi@cs.technion.ac.il, yogi@cs.ubc.ca, yogi@umiacs.umd.edu;
- Joseph Gil, P.O. Box 3148, Jerusalem, Israel.

The five files stay byte for byte as in the collection. The combined tables are built at build time
and named for what they are: our ROMs' tables, not a font of Gil's collection.

No code or data is taken from another project:
- SeaVGABIOS's `vgasrc/vgafonts.c` holds the same three VGA-ROM tables and says where they come from. It only pointed us to this collection.
- The five font files of our ROMs before p24/p5 (S3's) are byte for byte the tables built here (see Check below).

## How the tables are built

The VGA BIOS keeps two shapes for some characters:
- **9-dot modes** (720 pixels across: 00h-03h and 07h): the attribute controller adds a ninth column after each glyph (blank, or a copy of the eighth for C0h-DFh), so a glyph may use all eight columns.
- **8-dot modes** (graphics modes, the VESA text modes): the eighth column has to stay blank, or the characters touch.

The main 8x14 and 8x16 tables therefore hold the 8-dot shapes. The mode set loads a short alternate table over them in the 9-dot modes; AX=1130h returns these as BH=5 and BH=7.

| Table | Built from | Size |
| --- | --- | --- |
| 8x8 (BH=3, 4) | `VGA-ROM.F08` | 2048 |
| 8x14 (BH=2) | `VGA-ROM.F14` | 3584 |
| 8x16 (BH=6) | `VGA-ROM.F16`, with the 8-dot shapes of 1Dh 30h 4Dh 54h 56h-5Ah 6Dh 76h-78h 91h 9Bh 9Dh 9Eh ABh ACh from `PP_ROMAN.F16` | 4096 |
| 9x14 alternates (BH=5) | `STANDARD.F14` at 1Dh 22h 2Bh 2Dh 4Dh 54h 56h-5Ah 6Dh 76h 77h 91h 9Bh 9Dh 9Eh F1h F6h, then 00h | 301 |
| 9x16 alternates (BH=7) | `VGA-ROM.F16` at the 19 characters above, then 00h | 324 |

`PP_ROMAN.F16` differs from `VGA-ROM.F16` only at those 19 characters and at the shades B0h-B2h. At B0h-B2h it blanks the eighth column; the tables keep `VGA-ROM.F16`'s shades, whose pattern runs on into the ninth column.

SeaVGABIOS uses `VGA-ROM.F16` as it is and no alternate tables. It thus shows the 9-dot shapes in every mode, and in the 8-dot modes the eighth column of M, W, T and the others touches the next character. These tables keep IBM's arrangement instead.

## Check

`python3 src/roms/fonts/fonts.py` prints the SHA-256 of each table and checks them against the pinned
values. The five tables equal, byte for byte, the ones in S3's Trio64V+ BIOS 1.03-08N:
- 8x8 at 526Ch;
- 8x14 at 5A6Ch;
- 9x14 alternates at 686Ch;
- 8x16 at 6998h;
- 9x16 alternates at 7998h.

The 8x8, 8x16 and 9x16 alternates also equal the ones in 2.04.07 (62E0h, 6AE0h, 7AE0h). So our ROMs show the same pixels as before, and the patchers refuse a base whose table at those places is a different one.

2.04.07 has no 8x14 font: AX=1130h BH=2 returns the 8x16 one. Adding it would take 3584 bytes; the p24 build has no run of free (zero) bytes longer than 64, so the 775 ROM still lacks it (AGENTS.md).
