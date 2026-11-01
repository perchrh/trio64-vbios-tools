# A clean-room Trio64 BIOS

Notes of 31 October 2026 on how a Trio64 video BIOS of our own could be written without copying
Phoenix's or S3's code, and what documentation is missing for it. Nothing here is started yet. This
is not legal advice: before anything is distributed, a lawyer should look at the process.

## The idea

Today's Trio64 ROM is Phoenix's 1.5-07 with our patches (docs/764-rom.md), so it cannot be
given away freely. A clean-room implementation would replace it with code of our own that behaves
the same towards programs, drivers and the card:

- the **dirty side** (this repository, riplin's annotated disassembly, the reference ROMs, everyone
  and every agent who has read them) writes a specification of the behaviour, with no code in it;
- the **clean side** (a separate AI agent in a separate session, with no access to the dirty
  material) implements the BIOS from that specification, the public standards and the data book,
  and checks it with black-box tests.

## Why riplin's repository cannot be the clean base

riplin's repository is an annotated disassembly of the Phoenix 1.5-07 EDO build: it holds Phoenix's
code as instructions, which is exactly what the clean side must never see. Its MIT licence covers
riplin's annotations, not the Phoenix bytes (AGENTS.md). Forking it and adding information would
make the base itself dirty. It stays what it is today: a map for the dirty side, used to find
routines and data while writing the specification.

## The process

1. **Specification.** The dirty side writes what each interface does, as behaviour: inputs, outputs,
   side effects, error cases and timing requirements. No instruction sequences, no routine
   structure, no copied tables or byte values except facts from public standards (IBM, VESA) or the
   data book.
2. **Leak review.** Before handing it over, someone reads the specification for anything that
   expresses Phoenix's code or data rather than behaviour, and removes it.
3. **Separate repository.** The specification, the public documents and the clean tests go into a
   repository of their own. The clean agent works only there, with no access to this repository,
   riplin's, or the reference ROMs.
4. **Questions go through the wall.** When the clean side needs to know something, it asks; the
   dirty side answers with behaviour (for example "4F01 for 103h returns WinGranularity 64"), and
   the answer is added to the specification, where the leak review sees it.
5. **Black-box oracle.** The reference ROM may be run in the emulator on the dirty side to answer
   behaviour questions and to compare results; only pass/fail and observed behaviour go across.
6. **Similarity check.** The finished ROM is compared with Phoenix's 1.5-07 and S3's ROMs for long
   identical byte runs; any found is investigated.

A caveat: no one can prove that an AI agent never saw Phoenix or S3 BIOS code in its training. The
separate session and the similarity check reduce that risk; they do not remove it.

## Public documents for the clean side

The clean side may read the IBM VGA references, the Trio64 data book, and the parts of the VESA
standards that one of our BIOSes implements (README "VESA standards"): VBE 2.0 and VBE 1.2, VBE/DDC
1.0 (4F15) with the DDC1 and DDC2B signalling of DDC 1.0 to 3, VBE/PM 1.0 (4F10) with DPMS 1.0, DMT
1.0 Rev. 0.7 and GTF 1.0 for the timings, and the Mode 6Ah standard; of the secondary references in
README "VESA standards", the first VBE (VS891001) and Haakenson's article on the changes from VBE
1.2 to 2.0, which describe behaviour our BIOSes have; VBE 1.2 is at hand as a retyped text. VGADOC
(`standards/thoegersen/`, freeware whose licence allows any use of its information) describes the
standard INT 10h functions, the VGA, EGA and CGA registers and the S3 registers. Nothing beyond what our BIOSes
do concerns the clean-room implementation: VBE 3.0, VBE/SCI, VBE/AF and the EDID structure stay out
of its specification. The timing values of the ROM can then come from DMT and GTF instead of from
Phoenix's tables. VESA allows only VBE 2.0 to be posted online, so the others go to the clean side as
files of their own, not in a public repository.

At hand on 1 November 2026 (uploaded by the owner, kept outside the repository unless their terms allow
it): VBE 1.2 (VS911022, the text of 22 October 1991; its mode table restates 6Ah as 102h, which with
VBE 2.0 covers the Mode 6Ah standard), VBE 3.0, Ralf Brown's Interrupt List, IBM's "Personal System/2
and Personal Computer BIOS Interface Technical Reference" (April 1987: the INT 10h functions at first
hand), the PCI BIOS Specification 2.1 and the PCI Local Bus Specification 2.3 (the option ROM header,
the start-up call and the VGA palette snoop), DMT, GTF 1.1, Ferraro's "Programmer's Guide to the EGA,
VGA and Super VGA Cards" and a German BIOS reference book. VBE/PM 1.0 (4F10h) is summarised in VBE 2.0
and 3.0, VBE/DDC (4F15h) is described in VBE 3.0, and VBE 1.1 and the Mode 6Ah standard are restated
in VBE 1.2 and 2.0, so none of them is needed on its own; for DPMS
1.0, the X Window System's DPMS extension (https://xorg.freedesktop.org/docs/Xext/DPMS.pdf) and the
states On, Standby, Suspend and Off (the VESA DPMS article on Wikipedia) stand in until the standard
itself is at hand.

## What we have

- `docs/bios-rules.md`: 323 rules for the standard functions (INT 10h AH=00h-1Ch, the BIOS data
  area, the published tables) from public sources, with the open questions still to settle in the
  emulator: the start of item 1 below.
- `docs/chip-rules.md`: 92 rules from the data books (clock limits, memory timing, register
  meanings), each with its source.
- S3TEST and S3COMPAT: checks against the IBM VGA tables, the VBE 2.0 specification, VESA DMT and
  the data book, written to the AGENTS.md rule that expected values come from independent sources.
- The emulator (`emu/`): our own code, a VGA and S3 register model with a small DOS. Its tests need
  a review first: some expectations were taken from the reference ROMs' behaviour (for example the
  Trio64 base lists), and `refcompare` uses the reference ROM as its oracle, which is acceptable
  only on the dirty side.
- The README's Windows 9x driver findings (what S3's driver expects from the BIOS) and
  docs/764-rom.md (the Trio64 card, its memory, the DDC wiring).

## What is missing, in order of size

1. **A function-by-function interface specification.** For every INT 10h function and subfunction
   the ROM supports: the registers in and out, the BIOS data area fields written, what happens to
   video memory, the DAC and the VGA and S3 registers, the error returns, and which registers are
   left as found (the AGENTS.md index register rule). The AH=1Bh state table and the AH=1Ch save
   buffer formats belong here.
2. **The VBE specification.** The version reported, our own OEM strings, the exact mode list with
   the memory each mode needs, the field values of each mode's information block (4F01), the window
   semantics of 4F05, and which of 4F06-4F10 and 4F15 are supported and how.
3. **Per-mode register rules.** Timings named as VESA DMT or IBM entries, not as Phoenix's bytes.
   The S3 extended registers (CR31-CR6A, SR15, SR18 and the rest) as data book formulas: for
   example CR3B = CR00 - 5, and the display FIFO M and N values (CR54, CR60) from the bandwidth of
   the mode and the MCLK (data book section 7.4, #75).
4. **The POST procedure.** Chip detection, the PCI setup, memory sizing (1, 2 and 4 MB; 4 MB fast
   page only), loading the MCLK, keeping the board's strapping (CR36, CR68), the interrupt vectors,
   the BIOS data area, the sign-on, the PCI ROM header and the checksum.
5. **The conventions other software relies on.** What drivers and utilities expect to find:
   S3's Windows driver takes the PCI base from CR59/CR5A; Phoenix keeps refresh indexes in CR41 and
   CR52 bits 7-4; which scratch bits are free for us; DDC through the General Output Port (CR5C) and
   the General Input Port (port 3C8h, CR55 bit 2). Whether a driver reads the refresh indexes needs
   finding out.
6. **Fonts.** Phoenix's and S3's font bitmaps are not ours to give away. A licensed or newly drawn
   8x8, 8x14 and 8x16 set (with the 9-dot alternates) in the style of the era is needed.
7. **A card configuration table.** The values that differ from one card maker to the next (the
   MCLK, CR5C's General Output Port value, the timing bytes) as inputs of the build, like today's
   `MCLK=` option.
8. **The non-functional requirements.** 32 KB of ROM, real mode, a 386 or later, the speed goals
   (32-bit stores, the booster), and the AGENTS.md hard rules for the ROM.
9. **A traceability matrix.** Each specification item mapped to the test that checks it, so the
   clean side knows when it is done and the dirty side can see what is untested.

## Scope, base and licence (31 October 2026)

- **First version:** the standard VGA functions and the S3 mode set, without DDC (4F15), power
  management (4F10) and VBE 2.0; VBE 1.2 at most.
- **Free implementations to build on instead of writing everything new:**
  - SeaVGABIOS (the `vgasrc` directory of SeaBIOS, LGPLv3): C compiled with `gcc -m16`, so real-mode
    code that uses the 386's 32-bit registers, the kind of "32-bit" our ROMs use. It has the
    standard VGA functions (`stdvga.c`, `vgabios.c`, `vgafb.c`) and chip modules (Cirrus, Bochs,
    Geode, ATI) but no S3 module. An S3 Trio64 module written from the data book on top of it would
    leave the clean-room effort to the S3 part.
  - **Size:** SeaVGABIOS with VBE does not fit 32 KB, so it must be slimmed down before we can use
    it. Built on 31 October 2026 from `perchrh/seabios_fork` (gcc 13.3, `CONFIG_VGA_PCI=y`):

    | Build | Size |
    | --- | --- |
    | Plain VGA without VBE (`VGA_STANDARD_VGA`, `VGA_VBE=n`) | 32768 bytes (32322 used) |
    | Plain VGA with VBE | 35840 bytes |
    | QEMU Bochs VBE (`VGA_BOCHS`) | 39424 bytes |
    | QEMU Cirrus (`VGA_CIRRUS`) | 39424 bytes |

    Our ROMs have 32 KB (the lower half of the 64 KB image), and an S3 module with the mode set,
    the clock synthesis and the VBE mode list comes on top. Candidates for slimming:
    - the code of the other chips, already left out by the build options;
    - SeaVGABIOS's own fonts, if the ROM takes the FreeDOS cpidos ones (about 9 KB for 8x8, 8x14 and
      8x16);
    - the extra stack (`VGA_ALLOCATE_EXTRA_STACK`);
    - 32-bit code that gcc makes larger than hand-written 16-bit code.

    The plain VGA build also runs POST and modes 03h, 12h and 13h in our emulator.
  - The Bochs/LGPL VGABios (LGPL 2.1 or later), the code SeaVGABIOS grew from.
  - Code taken from either is used under its licence, not rewritten from a specification, so
    the clean-room rules apply only to what we write ourselves.
- **Fonts:**
  - FreeDOS cpidos 3.0 (Henrique Peron, GPL 2 or later): code page 437 at 8x8, 8x14 and 8x16;
    the 9-dot alternate glyphs we derive ourselves.
  - The fonts SeaVGABIOS carries come from Joseph Gil's FNTCOL16 collection, whose individual
    fonts it calls public domain; they look like IBM's VGA font, so their origin is less clear.
- **Licence of the result:** LGPLv3 code and GPL-2-or-later fonts can both be used under GPL 3, so
  the ROM would be GPL 3 (or later). Code under GPL 2 only (DOSEMU, if its licence says so) cannot
  be combined with LGPLv3 or GPL 3 code: use it as a reference for facts only.
- **The owner's wish (1 November 2026): public domain, no licence at all.** What follows from it:
  - No code from SeaBIOS (LGPLv3), the FreeDOS fonts (GPL) or any emulator may go into the ROM; they
    stay sources of facts only, like the standards. The ROM is then written in full by the clean side,
    probably in assembly: the owner also wants the VGA functions no slower than our Trio64 ROM p3,
    while CGA, EGA and MDA may be slower (the comparison of the slim SeaVGABIOS with p3 decides how
    much the C code costs; `docs/seavgabios-trio64.md`).
  - Fonts: an 8x8, 8x14 and 8x16 set that is itself public domain, or drawn anew. SeaVGABIOS's fonts
    are called public domain but equal IBM's (`docs/cleanroom/README.md` "Font origin").
  - The specification, the tests and the tools stay as they are; only what goes into the ROM image
    must be free of other people's licences.
  - Public domain is not recognised everywhere (in Norway the author's moral rights cannot be given
    up); a waiver with a permissive fallback licence, such as CC0 1.0 or the Unlicense, gives the same
    result where public domain is not available. To settle with the lawyer of this document.
- **More sources the clean side may read:**
  - Michael Abrash's Graphics Programming Black Book (freely published by the author): the VGA
    hardware (latches, write modes, Mode X), not the BIOS functions.
  - Francois Gervais, "Programmation des cartes graphiques CGA, EGA, VGA" (Sybex): the BIOS
    functions and registers.
  - DOSEMU 1.0.1 source: its VGA emulation and video BIOS tables and formulas, as facts.
- **Open-source programs as secondary sources** (checked 1 November 2026). They are public and the
  clean side may read them, but they rank below the standards and the data book, as VGADOC does:
  where they disagree, the standard or the data book decides. Three conditions:
  1. Facts (a formula, a mode number, a calling convention, a timing) may be cited in the
     specification. Code copied into the ROM comes under its licence: GPL 2 or later and MIT are
     compatible with a GPL 3 ROM; GPL 2 only is not, so such a source is used for facts only.
  2. An emulator models what programs needed, not the chip: no display FIFO, no memory timing,
     simplified CRTC values. Its values are checked against the data book before they are used.
  3. A table in an emulator may have been taken from a vendor's BIOS (an S3 mode list, SVGA register
     tables). Cite such tables for facts only (numbers, resolutions, colour depths), never copy them,
     and the leak review treats them as observed BIOS behaviour (`docs/cleanroom/LEAK-REVIEW.md`,
     check 5).

  | Source | Licence | Use |
  | --- | --- | --- |
  | SeaBIOS and SeaVGABIOS (the base, branch `claude/slim-vgabios` of perchrh/seabios_fork) | LGPLv3 | The PCI option ROM call (AX = bus, device and function) and the "PCIR" data structure its build script writes; the standard INT 10h functions and IBM's parameter tables; its code is used under its licence |
  | DOSBox-X (`src/hardware/vga_s3.cpp`, `src/ints/int10_vesa.cpp`, `int10_modes.cpp`) | GPL 2 or later (file headers) | The emulator to read first (decision of 1 November 2026): cross-check of the S3 PLL formula, CR67 and the high-colour modes, the S3 mode numbers and the VBE functions. Closer to our chips than DOSBox Staging: it models the Vision864, Trio32/Trio64 and Trio64V+ as separate cards (CR2E 11h for the Trio64, revision 40h for the Trio64V+) and cites the Vision864 and Trio32/Trio64 data books in its comments; condition 3 for its mode tables |
  | DOSBox Staging (`src/hardware/video/vga_s3.cpp`, `src/ints/int10_vesa.cpp`, `int10_modes.cpp`) | GPL 2 or later (SPDX header) | Lower tier: read only where DOSBox-X says nothing. Cross-check of the S3 PLL formula, CR67 and the high-colour modes, the S3 mode numbers and the VBE functions; condition 3 for its mode tables |
  | X.Org server `hw/xfree86/common/vesamodes` | XFree86 Project licence (MIT style) | 34 modelines "distilled from" VESA DMT 1.0 Rev. 0.8 (1998): pixel clock, horizontal and vertical totals, sync positions and polarities, for example 640x480 at 60 Hz (25.175 MHz, 800 x 525), 800x600 at 60 Hz (40 MHz, 1056 x 628), 1024x768 at 60 Hz (65 MHz, 1344 x 806). A stand-in for DMT until DMT itself is at hand |
  | Linux `drivers/gpu/drm/drm_edid.c`, the table `drm_dmt_modes[]` | MIT | The DMT modes as a second copy, to check `vesamodes` against |
  | Linux `drivers/video/fbdev/core/modedb.c`, `vesa_modes[]` | GPL 2 (the kernel's COPYING) | DMT timings, facts only (GPL 2 only) |
  | 86Box `src/video/vid_s3.c` (from PCem) | GPL 2 (COPYING; the file header states no "or later") | A closer model of the Trio64 than DOSBox (register behaviour, the high-colour modes); facts only |
  | FreeDOS MODE (`modevga.c`, `modecon.c`, github.com/FDOS/mode) | GPL 2 ("GPL (v2)" in the headers, no "or later"): facts only | A client of the standard functions: 25, 28, 43 and 50 lines through the AH=11h font loads and AH=12h BL=30h scan lines, 40 and 80 columns, and 132 columns through the VBE text modes: it lists 4F00h, takes every mode whose 4F01h attributes say supported text mode (XResolution and YResolution in characters) and sets it with 4F02h. A BIOS without VBE text modes (108h-10Ch) gives no `MODE CON COLS=132` |
  | FreeDOS DISPLAY (github.com/FDOS/display) | GPL 2 or later | Code page switching on CGA, EGA and VGA: which font loads (AX=1100h, 1110h) it makes and how it reloads the font after a mode set; what DOS programs expect of AH=00h and the font functions |
  | FreeDOS GRAPHICS (github.com/FDOS/graphics) | GPL 2 (COPYING): facts only | Screen printing: the memory layout of the CGA, EGA and VGA graphics modes and of MDA/Hercules, read pixel by pixel; a check of the mode table's memory organisation |
  | FreeDOS NANSI (github.com/FDOS/ansi) | GPL 2 or later | An ANSI console driver: its use of the BIOS text output (AH=02h, 06h, 07h, 09h, 0Eh) and of the BIOS data area fields (columns, rows at 0040:0084h, cursor positions, active page) |
  | FreeDOS FDAPM (`dpmsfunc.asm`, github.com/FDOS/fdapm) | GPL 2 or later | Monitor power states through VBE/PM 4F10h; for when 4F10h comes into scope |

  None of them answers the memory refresh, the board's CR5C wiring or the memory timing: those need the
  datasheet of the card's memory chips and the board itself.

## Next steps (when started)

- The plan for basing it on the slim SeaVGABIOS: `docs/seavgabios-trio64.md`.

- Create the separate specification repository with the skeleton of items 1-9.
- Review the emulator tests for expectations taken from the reference ROMs, and move the clean
  ones to the new repository.
- Decide the base (SeaVGABIOS or our own code) and the font source (above).
