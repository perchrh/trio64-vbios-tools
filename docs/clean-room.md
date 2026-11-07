# A clean-room Trio64 BIOS

Notes of 31 October 2026 on how a Trio64 video BIOS of our own could be written without copying
Phoenix's or S3's code, and what documentation is missing for it. Nothing here is started yet. This
is not legal advice: before anything is distributed, a lawyer should look at the process.

## The idea

Today's Trio64 ROM is Phoenix's 1.5-07 with our patches ([docs/764-rom.md](764-rom.md)), so it cannot be
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
riplin's annotations, not the Phoenix bytes ([AGENTS.md](../AGENTS.md)). Forking it and adding information would
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

The reading order, and which guide outranks which, is
[`docs/cleanroom/readings.md`](cleanroom/readings.md). Ralf Brown's Interrupt List outranks
Ferraro's book; both outrank VGADOC (6 November 2026).

The clean side may read the IBM VGA references, the Trio64 data book, and the parts of the VESA
standards that one of our BIOSes implements (README "VESA standards"): VBE 2.0 and VBE 1.2, VBE/DDC
1.0 (4F15) with the DDC1 and DDC2B signalling of DDC 1.0 to 3, VBE/PM 1.0 (4F10) with DPMS 1.0, DMT
1.0 Rev. 10 and GTF 1.1 for the timings, and the Mode 6Ah standard; of README "VESA standards" and
"Secondary references", the first VBE (VS891001) and Haakenson's article on the changes from VBE
1.2 to 2.0, which describe behaviour our BIOSes have; VBE 1.2 is at hand as a retyped text. VGADOC
([`standards/thoegersen/`](../standards/thoegersen/), freeware whose licence allows any use of its information) describes the
standard INT 10h functions, the VGA, EGA and CGA registers and the S3 registers. Nothing beyond what our BIOSes
do concerns the clean-room implementation: VBE 3.0, VBE/SCI, VBE/AF and the EDID structure stay out
of its specification. The timing values of the ROM can then come from DMT and GTF instead of from
Phoenix's tables. VESA allows only VBE 2.0 to be posted online, so the others go to the clean side as
files of their own, not in a public repository.

In the repository (5 November 2026): VBE 1.2 as [`standards/vesa/vbe12.txt`](../standards/vesa/vbe12.txt)
(VS911022; its mode table restates 6Ah as 102h, which with VBE 2.0 covers the Mode 6Ah standard),
PCI Local Bus Specification 2.3 as [`standards/pci/pci23.pdf`](../standards/pci/pci23.pdf) (the option
ROM header, the start-up call and the VGA palette snoop), and DMT 1.0 Rev. 10 as
[`standards/vesa/VESA-DMT-1.0-Rev10.pdf`](../standards/vesa/VESA-DMT-1.0-Rev10.pdf). Clean-room extracts of
the pages the leak review needs are under
[`docs/cleanroom/primary-extracts/`](cleanroom/primary-extracts/).

Still owner's copies outside the repository unless their terms allow posting: VBE 3.0, Ralf Brown's
Interrupt List, IBM's "Personal System/2 and Personal Computer BIOS Interface Technical Reference"
(April 1987: the INT 10h functions at first hand), the PCI BIOS Specification 2.1, GTF 1.1 and
Ferraro's "Programmer's Guide to the EGA, VGA and Super VGA Cards". VBE/PM 1.0 (4F10h) is summarised
in VBE 2.0 and 3.0, VBE/DDC (4F15h) is described in VBE 3.0, and VBE 1.1 and the Mode 6Ah standard are
restated in VBE 1.2 and 2.0, so none of them is needed on its own. E-DDC 1.2 (2007) describes DDC2B;
it drops DDC1, for which DDC 1.0 or 2.0 is still missing; hardwarebook.info's "VGA (VESA DDC)" page
gives the connector pins, and Joe Miseli's Xorg talk of 2007 the history of EDID and DDC. VESA's DPM
Standard Release A (2003, https://web.archive.org/web/20100628042359/http://www.vesa.org/summary/sumdpm.mht)
replaces DPMS 1.0 and keeps only On and Off; for Standby and Suspend, which 4F10h sets, the X Window
System's DPMS extension (https://xorg.freedesktop.org/docs/Xext/DPMS.pdf) stands in for DPMS 1.0.
A link collection for that subject, not itself a standard, is
https://grokipedia.com/page/VESA_Display_Power_Management_Signaling . Its sync table cites the
X.Org extension: On both active, Standby horizontal inactive and vertical pulsed, Suspend horizontal
pulsed and vertical inactive, Off both inactive. The reading order is
[`docs/cleanroom/readings.md`](cleanroom/readings.md).

### The X11 project

The X.Org X11 project is a source of information about DPMS and about the other display material it
publishes (the DPMS extension document above, and the EDID and DDC notes already cited from the 2007
Xorg conference). Its DPMS client, read 6 November 2026, is Digital Equipment Corporation, 1996, under
the notice in those files: `dpms.h`, `dpmsconst.h`, `dpmsproto.h` and `DPMS.c`. The facts are used;
the code is not copied into a ROM.

What those files state:

- The extension name is "DPMS" and the version is 1.2.
- The levels are On 0, Standby 1, Suspend 2 and Off 3 (`dpmsconst.h`). `DPMS.c` rejects any other level.
- Timeouts are ordered: if off is not 0 it is at least suspend, and if suspend is not 0 it is at least
  standby. Zero means that timeout is unused.
- They do not say which sync signals Standby, Suspend or Off turn off. VBE 4F10h, as VGADOC
  [`standards/thoegersen/VESA.TXT`](../standards/thoegersen/VESA.TXT) records it, uses 00h On, 01h
  Standby, 02h Suspend and 04h Off, so Off is not the same number as in the X11 client.

## What we have

- [`docs/bios-rules.md`](bios-rules.md): 323 rules for the standard functions (INT 10h AH=00h-1Ch, the BIOS data
  area, the published tables) from public sources, with the open questions still to settle in the
  emulator: the start of item 1 below.
- [`docs/chip-rules.md`](chip-rules.md): 74 rules, from the data books apart from a few identification rules
  taken from S3's drivers (marked *derived* or "information"): clock limits, memory timing, register
  meanings, each with its source.
- S3TEST and S3COMPAT: checks against the IBM VGA tables, the VBE 2.0 specification, VESA DMT and
  the data book, written to the [AGENTS.md](../AGENTS.md) rule that expected values come from independent sources.
- The emulator ([`emu/`](../emu/)): our own code, a VGA and S3 register model with a small DOS. Its tests need
  a review first: some expectations were taken from the reference ROMs' behaviour (for example the
  Trio64 base lists), and `refcompare` uses the reference ROM as its oracle, which is acceptable
  only on the dirty side.
- The README's Windows 9x driver findings (what S3's driver expects from the BIOS) and
  [docs/764-rom.md](764-rom.md) (the Trio64 card, its memory, the DDC wiring).

## What is missing, in order of size

1. **A function-by-function interface specification.** For every INT 10h function and subfunction
   the ROM supports: the registers in and out, the BIOS data area fields written, what happens to
   video memory, the DAC and the VGA and S3 registers, the error returns, and which registers are
   left as found (the [AGENTS.md](../AGENTS.md) index register rule). The AH=1Bh state table and the AH=1Ch save
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
6. **Fonts.** Phoenix's and S3's font bitmaps are not ours to give away. Chosen on
   2 November 2026 ([#145](https://github.com/perchrh/trio64-vbios-tools/issues/145)): the five Joseph Gil FNTCOL16 files in
   [`src/roms/fonts/`](../src/roms/fonts/) (#141), with ROM tables built by [`fonts.py`](../src/roms/fonts/fonts.py).
   Owner decision of 5 November 2026: that source is **closed** for the project (Gil notice + generated
   tables; see [`docs/cleanroom/asset-manifest.md`](cleanroom/asset-manifest.md)).
7. **A card configuration table.** The values that differ from one card maker to the next (the
   MCLK, CR5C's General Output Port value, the timing bytes) as inputs of the build, like today's
   `MCLK=` option.
8. **The non-functional requirements.** 32 KB of ROM, real mode, a 386 or later, the speed goals
   (32-bit stores, the booster), and the [AGENTS.md](../AGENTS.md) hard rules for the ROM.
9. **A traceability matrix.** Each specification item mapped to the test that checks it, so the
   clean side knows when it is done and the dirty side can see what is untested.

## Decisions of 2 November 2026 (#145)

The owner's answers to the outside review ([`docs/cleanroom/review-2026-11-02.md`](cleanroom/review-2026-11-02.md),
[#145](https://github.com/perchrh/trio64-vbios-tools/issues/145)). They replace what the section "Scope, base and licence" below says
where the two differ; that section is kept as the record of how the decision was reached.

- **Base: empty.** The clean ROM is a full new video BIOS, written from scratch by the clean side from
  the specification, the public standards and the data book. No code of SeaVGABIOS, the Bochs VGABios,
  an emulator or a vendor BIOS goes into it.
- **SeaVGABIOS** is a comparison implementation: a source of facts and a ROM to test the
  specification and the tests against, not a base.
- **Fonts:** Joseph Gil's FNTCOL16 files in [`src/roms/fonts/`](../src/roms/fonts/), as our patched ROMs use them since
  #141, with tables generated by [`fonts.py`](../src/roms/fonts/fonts.py). Closed for the project on
  5 November 2026 ([`docs/cleanroom/asset-manifest.md`](cleanroom/asset-manifest.md)): Gil's notice is the
  permissive basis; FreeDOS cpidos is not an alternative.
- **Size budget:** the whole BIOS in 32 KB. The fonts take about 9.7 KB (8x8 2048, 8x14 3584 and 8x16
  4096 bytes, plus the 9-dot alternates), which leaves about 23 KB for code and tables. Not measured
  yet; a milestone that does not fit says so before the next one starts.
- **Release terms: the MIT licence** for our original code, tests and specifications, and for the clean
  ROM. This replaces the public domain wish of 1 November 2026 (below). An MIT ROM can carry the Gil
  fonts under that folder's notice; it cannot carry LGPL or GPL code, which stays a source of facts
  only, as before. The MIT licence file is [`LICENSE.md`](../LICENSE.md); the asset manifest is
  [`docs/cleanroom/asset-manifest.md`](cleanroom/asset-manifest.md).
- **Distribution:** no workflow uploads a patched ROM image any more (README "Continuous
  integration"). The reference ROMs stay in [`reference/`](../reference/) for now; they are to be removed later and
  fetched from theretroweb.com by URL and SHA-256 instead (README "To do"). The Trio64V2 2.04.07 and
  1.01.04 are not on theretroweb yet.
- **Scope: four milestones, and a tentative fifth** (decided 2 November 2026, [#145](https://github.com/perchrh/trio64-vbios-tools/issues/145); this answers the review's F5). All are judged on the DSP-3364P, in order:
  1. **Milestone 1: the card posts.** The system BIOS finds and runs the ROM, and the monitor shows a
     picture with readable text. Some graphical glitches are allowed. Nothing after POST is required.
  2. **Milestone 2: MS-DOS 6.22 and EDIT.** MS-DOS 6.22 boots on the card; the MS-DOS EDIT program
     starts, loads a file, edits it and saves it, without significant graphical glitches or other
     problems.
  3. **Milestone 3: Superscape 3D Bench 1.0c.** Under MS-DOS, the benchmark loads and runs without
     significant graphical glitches.
  4. **Milestone 4: Chris's 3D Benchmark.** Under MS-DOS, the benchmark loads and runs without
     significant graphical glitches in both its 320x200 mode and its 640x480 VESA mode.
  5. **Milestone 5 (tentative): FreeDOS.** FreeDOS boots on the card
     ([`docs/cleanroom/freedos-1.4.md`](cleanroom/freedos-1.4.md) lists what FreeDOS 1.4 asks of the video BIOS).

  Milestone 3 needs only standard VGA: mode 13h and the DAC block load AX=1012h. Milestone 4 is the
  first that needs VBE: VESA mode 101h (640x480 in 256 colours, banked; recorded on a card on
  2 November 2026, [`docs/cleanroom/milestone-calls.md`](cleanroom/milestone-calls.md)). It brings in part C (4F00h, 4F01h for 100h
  and 101h, 4F02h, the window function, which the program reaches without an INT 10h call) and part
  B's mode set for that one mode. Everything else stays outside the current scope: the other S3 and
  VESA modes, 132 columns and 50 lines, other games and Windows; those documents are kept for later
  milestones.
- **The contract of each milestone** is recorded on the card before the clean side starts it: the
  INT 10h calls of its programs, with `VGALOG /M` under a working ROM, then `VGALOG /D`. The text
  output functions are not logged there, so a list of those comes from a trace or from the standard.
  Milestones 2 (EDIT), 3 and 4 are recorded ([`docs/cleanroom/milestone-calls.md`](cleanroom/milestone-calls.md)).
  Milestone 2 acceptance boots without `CONFIG.SYS` / `AUTOEXEC.BAT` and with an empty PATH (M2-BOOT in
  [`docs/cleanroom/decisions-milestones-1-4.md`](cleanroom/decisions-milestones-1-4.md)), so CLS / DOSKEY
  surround is out of the contract. Text-output functions VGALOG omits still come from the standard or a
  fuller trace where EDIT needs them.
- **Scope of the leak review:** a clean-room implementation of milestones 1-4. Only what the clean side
  needs for them crosses now and is reviewed; milestone 5 and later get their own review when they are
  set ([`docs/cleanroom/LEAK-REVIEW.md`](cleanroom/LEAK-REVIEW.md) "Scope of this review").

## The parts of the clean ROM

What the clean ROM has to do besides the standard VGA functions (INT 10h AH=00h-1Ch,
[`docs/bios-rules.md`](bios-rules.md)), numbered as the specifications cite them. Parts A, B and C of
[`docs/cleanroom/`](cleanroom/) specify them; the milestones above decide which are needed when.

1. **Chip start-up at POST** (part A): the S3 register unlock and the lock left as found, the memory
   size, the memory clock, the PCI base, the enhanced mode set-up and the graphics engine reset. The
   memory type (CR36 bits 3-2) and the strapped timings (CR68) are the board's and left alone. The
   memory clock is a build input with a default of 50.11 MHz (owner's decision, 7 November 2026; part
   A, POST-23).
2. **The S3 mode set** (part B): the packed VBE 1.2 modes 100h-117h and the return to the standard
   modes 00h-13h.
3. **VBE 1.2** (part C): 4F00h-4F08h, version 0102h, the window (bank) function, the logical scan
   line and display start, the DAC width.
4. **The conventions programs and drivers rely on** (part A): the PCI base in CR59/CR5A, the register
   state after a mode set, the indexes as found after every call.
5. **The S3 mode numbers and 4F14h** (part C, a later step): AH=00h with S3 mode numbers and the S3
   OEM functions.
6. **The PCI option ROM header and the sign-on** (part A).

Scope of the first version: the standard VGA functions; VBE 1.2 for the packed modes 100h-117h that
the card can show at 60 Hz or more, never interlaced, banked through a 64 KB window at A0000h; no VBE 2.0, no 4F10h
(power management), no 4F15h (DDC); a 32 KB image, built twice into the 64 KB EEPROM image (the board
maps the upper half, #78). Optional later: a 64 KB linear window for the banked modes, VBE 2.0, 4F15h,
4F10h.

## Scope, base and licence (31 October 2026)

- **First version:** the standard VGA functions and the S3 mode set, without DDC (4F15), power
  management (4F10) and VBE 2.0; VBE 1.2 at most.
- **Free VGA BIOS implementations:** SeaVGABIOS (the `vgasrc` directory of SeaBIOS, LGPLv3; C
  compiled with `gcc -m16`, with the standard VGA functions and modules for other chips, none for S3)
  and the Bochs/LGPL VGABios it grew from (LGPL 2.1 or later). They are comparison implementations and
  sources of facts (the table below); no code of theirs goes into the ROM.
- **Fonts:**
  - FreeDOS cpidos 3.0 (Henrique Peron, GPL 2 or later): code page 437 at 8x8, 8x14 and 8x16;
    the 9-dot alternate glyphs we derive ourselves.
  - The fonts SeaVGABIOS carries come from Joseph Gil's FNTCOL16 collection, whose individual
    fonts it calls public domain; they look like IBM's VGA font, so their origin is less clear. Our
    patched ROMs build their fonts from Gil's files since #141 ([`src/roms/fonts/`](../src/roms/fonts/), with his notice and
    the provenance); the 9-dot alternates come from the same collection, so none need deriving.
- **The owner's wish (1 November 2026): public domain, no licence at all.** Replaced on 2 November
  2026 by the MIT licence ("Decisions of 2 November 2026" above); what it led to still holds, except
  the release terms. What follows from it:
  - No code from SeaBIOS (LGPLv3), the FreeDOS fonts (GPL) or any emulator may go into the ROM; they
    stay sources of facts only, like the standards. The ROM is then written in full by the clean side,
    probably in assembly: the owner also wants the VGA functions no slower than our Trio64 ROM p3,
    while CGA, EGA and MDA may be slower. An emulator comparison of SeaVGABIOS's C code with p3
    (instructions per call, 1 November 2026) gave mode sets, fonts and the palette 0.85-2.2 times p3,
    text output and the cursor 1.5-2.8, text scrolls about 4, mode 12h pixels 12-23 and AH=09h over
    2000 characters 121: the hot paths need hand-written assembly.
  - Fonts: an 8x8, 8x14 and 8x16 set that is itself public domain, or drawn anew. SeaVGABIOS's fonts
    are called public domain but equal IBM's ([`docs/cleanroom/README.md`](cleanroom/README.md) "Fonts").
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
     specification. No code of theirs goes into the ROM, which is MIT and written from scratch
     ("Decisions of 2 November 2026").
  2. An emulator models what programs needed, not the chip: no display FIFO, no memory timing,
     simplified CRTC values. Its values are checked against the data book before they are used.
  3. A table in an emulator may have been taken from a vendor's BIOS (an S3 mode list, SVGA register
     tables). Cite such tables for facts only (numbers, resolutions, colour depths), never copy them,
     and the leak review treats them as observed BIOS behaviour ([`docs/cleanroom/LEAK-REVIEW.md`](cleanroom/LEAK-REVIEW.md),
     check 5).

  | Source | Licence | Use |
  | --- | --- | --- |
  | SeaBIOS and SeaVGABIOS (the comparison implementation, branch `claude/slim-vgabios` of perchrh/seabios_fork) | LGPLv3 | The PCI option ROM call (AX = bus, device and function) and the "PCIR" data structure its build script writes; the standard INT 10h functions and IBM's parameter tables; facts only, no code goes into the ROM (decision of 2 November 2026) |
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

- Create the separate specification repository with the skeleton of items 1-9.
- Review the emulator tests for expectations taken from the reference ROMs, and move the clean
  ones to the new repository.
- The base (empty, our own code), the font source (Gil's FNTCOL16 files) and the four milestones are
  decided ("Decisions of 2 November 2026").
- Apply the independent leak-review returns recorded in [`docs/cleanroom/README.md`](cleanroom/README.md),
  then re-review the changed files before exporting the clean allowlist (#145).
