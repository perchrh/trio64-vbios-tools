# Trio64V2/DX VBIOS test tools

DOS tools written while modifying the video BIOS of a Gainward S3 Trio64V2/DX card
(86C775, 2 MB EDO 40 ns, board ICUVGA-GW503A, PCI 5333:8901). The current ROM is 2.04.07-p14: the S3
reference BIOS 2.04.07 with our changes, and the card's own Trio64V+ BIOS in the upper half. The ROM
image itself is not in this repository; the changes it carries are described below, and `rompatch/`
holds their source and the patcher that builds the image from the reference BIOS.

All tools share one version number, currently 0.8 (set in `common/version.inc`), and print it on their first line of output.
All tools need a 386 or later and run in plain DOS (no EMM386 needed), except S3REGS32.EXE, which
is for the Windows 9x desktop.

| Tool | Purpose | Run |
| --- | --- | --- |
| VSHOW.COM | VESA mode viewer: test picture, measured refresh and line frequency, LCD line pattern, interactive menu, run through all modes | `VSHOW /H` for the parameter list |
| S3TEST.COM | Regression test for the ROM patches (signature, clocks, EDO, pedestal, refresh and line length, booster, LFB, 4F05/4F06, CR50, flip-flop, VGA clear, font load, scrolls in modes 13h, text and planar, AH=09h, timings) | `S3TEST > S3TEST.LOG` |
| S3ALIAS.COM | TSR for Pinball Illusions' S3 driver: INT 10h AH=00 mode 49h becomes 59h (640x480x8), 4Bh becomes 5Ah (800x600x8) | `S3ALIAS` before starting the game, `S3ALIAS /U` to unload, `/H` for help; not with S3TEST or S3COMPAT |
| VGALOG.COM | TSR that logs every INT 10h AH=00 mode set and VBE 4F01/4F02/4F06 call of any program to VGALOG.BIN, committed before and after each call, so it survives a freeze. `/M` keeps the last 1024 INT 10h calls of any kind (not text output) in memory instead, for Windows 9x; `/D` writes them | `VGALOG` (or `VGALOG /M`), then start the program; `VGALOG /D` to write the memory log, `VGALOG /U` to unload, `/H` for help; record formats in `vgalog/vgalog.asm` |
| S3REGS.COM | Register snapshot (SR, CR, GR, PCI, BIOS and VBE mode) appended to S3REGS.TXT, with a label; changes nothing | `S3REGS label` |
| S3REGS32.EXE | The same snapshot from the Windows 9x desktop (Win32 console program), and `/W n` logs every register change for n seconds | `S3REGS32 label`, `S3REGS32 /W 60 label` |
| S3COMPAT.COM | VGA/SVGA/VESA compatibility test: IBM reference registers and palettes, 350-line text modes, VGA BIOS functions (also AH=13h, CGA scroll, graphics XOR, fonts, the video save pointer table), every VESA mode, the VBE functions (also 4F04 masks, 4F0A, 4F10, 4F14, 4F15), datasheet rules, VRAM | `S3COMPAT > S3COMPAT.LOG` (`/Q` skips the VRAM test; VSHOW shows single modes) |

Each source file starts with a header that says what is tested and which outcome is expected, and
each test routine has a comment block with its fail and warn bits. S3TEST and S3COMPAT end their log
with `Time spent: x.y s`, the run time measured with the BIOS tick.

Monitor: VSHOW and S3TEST set modes up to a 75 kHz line frequency (1600x1200 at 60 Hz), S3COMPAT up
to 91 kHz (1280x1024 at 85 Hz in its 4F14 refresh test). An LCD refuses a signal it cannot show (out
of range) and takes no harm; an old fixed-frequency or low-end CRT can be damaged by a line frequency
above its range, so do not run these tools with one. Each tool prints this on stderr before it sets a
mode.

All tools share one version number and S3TEST checks for one ROM version; both are set in
`common/version.inc` (`VERSION`, `ROMVER`) and can be overridden for a build, for example
`make clean && make VERSION=0.9 ROMVER=2.04.07-p15`.

## Building

NASM 2.x (tested with 2.16.01):

    make            # Linux, macOS, WSL
    build.bat       # DOS or Windows with nasm.exe on the PATH

The .COM files land in `build/`. `common/` holds the /V debug log code the test tools share.

## Emulator tests

`emu/` runs the video BIOS and the DOS tools in an emulated PC, so changes can be checked before a
hardware run. The tests need python3 and the unicorn package from PyPI (listed in `pyproject.toml`),
NASM, and the 64 KB ROM image of the card, which is not in this repository:

    python3 -m venv .venv
    .venv/bin/pip install .
    make emu-test ROM=path/to/S3V2P9.BIN

`make emu-test` uses `.venv` when it exists, otherwise `python3`; `pip install unicorn` into any
environment works as well. ROM images (`*.bin`, `*.BIN`) are ignored by git, so the image can sit in
the working copy without being committed.

They take about three minutes. The patches are checked by S3TEST, which the `s3test` emulator test runs
and which also runs on the card: run against the stock image it fails 25 lines (signature, MCLK,
pedestal, 60 Hz defaults, refresh and line length of the patched timings, booster and LFB base,
4F01/4F03/4F06, CR50, flip-flop). `rom_patches` adds only what S3TEST cannot check: the sign-on and
the checksums of both 32 KB halves in the file, and the FIFO fix with CR90 bit 7 set the way the card
leaves it after a VESA mode (the model does not set it). The other tests check the BIOS registers, state blocks and
default palettes of every VGA mode against the IBM reference, that S3TEST, VSHOW and the VGA part of
S3COMPAT run and give the same output with and without /V, the /V debug file format, and VGALOG and
S3ALIAS install and unload. The tools run with /V; their output and debug files are kept in
`emu/logs/` (S3TEST.LOG, S3TEST.DBG, ...). The emulator models the VGA and S3 registers, one 64 KB planar window
and a virtual clock that drives the timer, the BIOS tick and the retrace bit from the programmed
timing (see `emu/vgaemu.py`), so refresh rates and planar memory tests mean something there. It has
no banked or linear video memory and no real bus speed: those results, and the monitor, stay with
the hardware logs, which decide. `emu/cover.py` lists the ROM bytes that a broad INT 10h workload
never touches.

`s3compat_full` runs the whole S3COMPAT on the model; only the lines that judge video memory through
the banks, the LFB or planar windows above 64 KB are left to the card. In the model, read mode 1
(colour compare), the GR03 rotate and logic functions, the DAC state register and the PIC are now
modelled too, so the VGA BIOS function tests of S3COMPAT all run there.

### Test coverage

    pip install .[coverage]          (capstone, for emu/codemap.py)
    make coverage ROM=path/to/S3V2P14.BIN

runs every emulator test while recording which ROM bytes execute, then `emu/codemap.py` finds the
code of the lower 32 KB by recursive descent from the POST entry, every executed block and every
direct jump, call and word jump table, and reports the share the tests executed. Data (tables,
fonts, strings, padding) and code nothing reaches (the routines our patches jump around) do not
count. `--list` gives the code ranges no test runs. The goal is at least 80 %; 2.04.07-p14 is at
82.6 % (14362 of 17394 bytes). The parts still not run include the display switch (AH=12h BL=35h),
the mono/colour adapter switch in the mode set, MDA (3B4h) paths and error paths.

### EGA/CGA against the reference BIOS

    make ref-compare REF=REF2047.BIN UPPER=STOCK.BIN ROM=S3V2P14.BIN

runs 2389 INT 10h calls in the CGA, MDA and EGA modes (00h-07h, 0Dh-10h) on the unpatched reference
BIOS and on the ROM (mode sets at 200, 350 and 400 lines, scrolls with random windows, text and pixel
output, palettes, pages, fonts, AH=12h, AH=1Ah, AH=1Ch) and compares the registers a program gets
back, the BIOS data area, video memory, the DAC and the standard VGA registers after each call. For
2.04.07-p14 there is no difference: the patches in those paths (32-bit text scroll, planar fills,
AH=09h, VGA clear, font load) only change how fast it is done, and the mode set hook, the memory
clock and the pedestal only touch S3 extended registers, which are not compared.

## ROM patcher

`rompatch/` holds the code the ROM carries (nasm sources, assembled at their ROM offsets, with the
2.04.07 addresses they use in `bios.inc`) and `s3patch.py`, which applies the whole current change set
(p14) to the S3 reference BIOS 2.04.07. It needs python3 (no packages) and NASM:

    python3 rompatch/s3patch.py REF2047.BIN --upper STOCK.BIN -o S3V2P14.BIN
    make rom IN=REF2047.BIN UPPER=STOCK.BIN OUT=S3V2P14.BIN

REF2047.BIN is the 32 KB reference BIOS; `--upper` takes the upper 32 KB, the Trio64V+ BIOS 1.03-08,
from the stock dump of the card (or a 32 KB file of it), unchanged. Only 2.04.07 is accepted. Every
patch site is compared with the original code first (the replaced routines in full), and the result
is checked before it is written: both halves sum to 00, the upper half is unchanged, every DCLK VCO
is in 170-340 MHz, and with the known reference image and stock upper half the SHA-256 is the one of
the build that passed every emulator test (f7ed681c...). The CR88 bit 1 tweak of the reference keeps
comparing SR10/SR11 with the old MCLK values, so it stays off at 59.96 MHz, as in the 2.04.11 builds
before p14.

    python3 rompatch/test_s3patch.py --ref REF2047.BIN --upper STOCK.BIN [--rom S3V2P14.BIN]
    make rom-test REF=REF2047.BIN UPPER=STOCK.BIN [ROM=S3V2P14.BIN]

runs the checksum tests: the pinned SHA-256 (and the same bytes as `--rom`), both halves sum to 00
with the right byte at 7FFFh, the VCO range, the free bytes still 00, a 64 KB input giving the same
result, `--no-vco-fix`, and seven inputs that must be refused (already patched, a p12, a p13 and the
p14 patch site changed, a wrong checksum, a 32 KB image without `--upper`, the stock 2.04.11).

## Debug log (/V)

VSHOW, S3TEST and S3COMPAT take `/V`. It writes a second file, `VSHOW.DBG`, `S3TEST.DBG` or
`S3COMPAT.DBG`, in the current directory. Its only purpose is to show how the code ran on the real
card, so problems can be found and fixed from a log instead of guessed at. The normal output is the
same with or without /V. The debug file contains:

- the environment: CPU, DOS version, memory, interrupt vectors, system BIOS date, the video ROM header
  and checksum, the BIOS data area and the PCI configuration of the display controller
- every INT 10h call the tool makes (and nested calls the BIOS makes itself) with all registers in and
  out and the duration in PIT counts
- a register dump (SR, GR, CR00-18, CR30-6F, CR80-9F, AR, DAC 0-15, video BIOS data) after every test or
  shown mode, with the normal result line copied next to it
- the 4F00, 4F01 and AH=1Bh blocks as hex, per-frame timer counts of every refresh measurement and the
  first memory mismatches with address, expected and read value

The file is committed before every mode set and VBE call (except 4F05), so after a freeze its last
lines show the call that hung. Expect a debug file of 1-2 MB for S3COMPAT and a longer run.
The line format is described at the top of `common/vdebug.inc`.

## Windows 9x driver test

What S3's Windows 9x driver (Trio64V+/V2 driver 4.10.01.2108-2.41.07, `S3_2.DRV` and the mini-VDD
`S3VDD.VXD`) does with the card can be seen without disassembling it: the function names in
`S3VDD.VXD` show that it can set the memory clock to 50 MHz and back, fixes clocks after DOS boxes,
post-processes VESA calls 4F00, 4F02 and 4F08, and traps the VGA and S3 ports of DOS boxes. The
tools record what it actually does:

1. In AUTOEXEC.BAT before Windows starts: `VGALOG /M` (33 KB resident), then `S3REGS before Windows`.
2. On the Windows desktop, for each display setting of interest (for example 640x480x8 60 Hz,
   800x600x16, 1024x768x8, 1280x1024x8 and 1600x1200x8 at 60 Hz, and the 24/32-bit depths):
   `S3REGS32 1024x768x8 60Hz`, typed in an MS-DOS prompt window (it runs as a Win32 program) or in
   Start, Run.
3. One watched run: `S3REGS32 /W 120 events` (snapshot, 120 s of changes, closing snapshot). During
   it: open an MS-DOS prompt, switch it to full screen (Alt+Enter) and back, close it; play a video
   (ActiveMovie, AVI or MPEG, so the overlay is used); change the resolution once.
4. In an MS-DOS prompt: `S3REGS dos box windowed`, then Alt+Enter and `S3REGS dos box full screen`.
   These may show virtual values (the driver traps the ports of DOS boxes); compare with step 2.
5. Exit to DOS (Shut Down, "Restart in MS-DOS mode", or leave WIN.COM): `S3REGS after Windows`, then
   `VGALOG /D`. Bring S3REGS.TXT and VGALOG.BIN back.
6. For a comparison, the same with the stock ROM (step 2 and 5 are enough).

What to look for: SR10/SR11 on the desktop, in a full-screen DOS box and afterwards (does the driver
run the memory at 50 MHz?); CR54, CR60, CR90-CR93, CR66, CR67, CR85, CR86, CR87 and SR15 (memory
arbitration, FIFO, 1-cycle linear addressing) per mode, against what our BIOS sets for the same mode;
CR58-CR5A and CR6D (does the driver use CR6D, which our booster uses, or rely on CR59/5A being the PCI
base); and in VGALOG.BIN which INT 10h calls Windows makes to our BIOS and with which registers.

S3REGS.TXT format (S3REGS and S3REGS32 write the same):

    S3REGS 0.8 [label] DOS                    or  S3REGS32 0.8 [label] Win32
    MISC=EF FEAT=00 PEL=FF MODE=59 VBE=0101 TICK=00000032   (MODE and VBE only from DOS)
    SR00: 16 bytes SR00-SR0F                  SR10: SR10-SR1F
    CR00: ... CRF0: 16 rows of CR00-CRFF      (CR45, CR4A, CR4B shown as --, not read)
    GR00: GR00-GR08
    PCI00: 16 dwords of the PCI configuration header of 5333:8901
    WATCH 120 s, ...                          (S3REGS32 /W only) then lines "+<ms> CR54 18->10"
    END OF WATCH                              followed by the closing snapshot

S3REGS32 reads the ports directly, which Windows 9x allows a Win32 program for ports no virtual
device traps; on Windows NT it ends with an exception. It keeps the 3C4h, 3CEh and 3D4h indexes,
SR08, CR38, CR39 and CF8h as found, and never touches the attribute controller or the cursor colour
stack (CR45, CR4A, CR4B). It is built by NASM alone: the PE header is written out in
`s3regs/s3regs32.asm`. The emulator runs it on a 32-bit CPU with the same register model
(`vgaemu.Machine.run_pe32`).

## S3COMPAT reference data

`s3compat/vgaref.inc` holds everything S3COMPAT compares against, so a build needs nothing else:

- the standard VGA register values and the INT 10h AH=1Bh state block per mode, and IBM's default
  256-colour DAC table. These were generated once from the IBM reference tables shipped with
  VGATEST (Kent Quirk and Ed McNierney, PC Tech Journal, November 1988: CRTC.COL, GENERAL.COL,
  DSTATE.COL, DAC.COL), cross-checked against the VGA parameter table in the BIOS, which matches
  VGATEST for every mode VGATEST covers. We do not consider these VGA tables copyrighted.
- the 350-line text modes 0*, 1*, 2* and 3*, from the IBM VGA parameter table (entries 13h-16h).
- the VESA to S3 internal mode mapping, from the BIOS tables at 0xE37 and 0xEA5.

The EGA and CGA default palettes are not tables: S3COMPAT computes them from the IBM rules
(EGA: 2Ah per primary bit, 15h per secondary bit; CGA: bit 4 adds 15h to all three, colour 6 is brown).

## VBIOS changes in 2.04.07-p14

p14 differs from the S3 reference BIOS 2.04.07 in the lower 32 KB; the upper 32 KB is the card's
Trio64V+ BIOS 1.03-08 (for an older card), byte-identical to the stock dump. Both halves checksum to
0, and every change keeps the standard VGA and VESA modes compatible. The RAM stays in 1-cycle EDO
mode. p1-p13 were built on the card's stock 2.04.11 and carried over unchanged in function. In the
emulator, 5980 scroll, text and teletype calls leave the same registers, memory and VGA state with
the 2.04.07 builds of p12, p13 and p14 (and with 2.04.11 p12 and p13), and 855 mode set, font and
VESA calls the same with 2.04.07 p13 and p14. About 200 bytes of the lower 32 KB
are free: 0x7C8A-7CFA (113 bytes, free in the reference only), 0x7E1E-7E3F, 0x7E59-7E5F,
0x7E79-7E7F, 0x7FB7-7FBF, 0x7FE3-7FFE. p10 (an extra VESA mode 182h, 320x400x8) was withdrawn.

| Area | Change | Effect |
| --- | --- | --- |
| Base | The S3 reference BIOS 2.04.07 instead of the card's stock 2.04.11 (p1-p13 were built on 2.04.11), with the card's POST flags (0xD1 = 05h) and CR80 value (00h) | The same patches at the reference's addresses; its DCLK table is fixed (next row) |
| DCLK VCO | 22 refresh entries of the reference ran the DCLK VCO at 145-162 MHz (each mode's refresh list starts at the entry its mode table pointer gives and runs downwards to the entry with bit 7 of byte 2 set); new M/N/R give the same pixel clock with the VCO in 170-340 MHz (smallest R, then smallest N; several are the values of the 2.04.11 table) | The PLL in its specified range in every mode (S3COMPAT checks it) |
| 1600x1200 (120h) | The reference's CRTC table has a vertical display end of 1201 lines (CR12 B0h); AFh as in 2.04.11 | 1200 lines, as 4F01 reports (S3COMPAT FAIL 0100 found it, in the emulator) |
| Memory clock | MCLK 50.11 MHz to 59.96 MHz (SR11=41h, SR10=42h, VCO 239.8 MHz) | About 20% more memory bandwidth; 59.96 MHz is the 1-cycle EDO maximum (16.67 ns). CR36 bits 3-2 stay 00 |
| Black level | Blank pedestal off at POST (header flag 0xD1 bit 1 cleared, SR1A bit 5 never set) | Deepest black, no grey lift |
| Attribute controller | Input status read after every mode set resets the index/data flip-flop | Fixes programs that write port 3C0h right after a mode set |
| FIFO fetch | CR90 bit 7 cleared after setting any VGA mode 00h-13h | Fixes stripes and garbage in Mode X and 360-wide modes after a VESA mode (Quake 360x200) |
| 320x240x8 (131h) | New 60 Hz timing: 640x480 @ 60 Hz halved horizontally, double scanned | LCDs see standard 640x480 @ 60 Hz, no scaling waves |
| 320x240x15/16 (132h, 133h) | Same 60 Hz timing at 2 clocks per pixel | Same as 131h |
| 640x480 class | Line total 792/796 to 800 pixels in the 640x480 and 320x240 tables | Exact VESA 640x480 @ 60 Hz line of 800 pixels (31.3-31.5 kHz); one LCD preset covers every mode of that class |
| 1280x1024, 1600x1200 | Default refresh 60 Hz (CR41 and CR52 refresh fields) | Works on 60 Hz LCDs; stock defaulted to rates LCDs reject |
| 1280x1024x16 colours (106h) | Stock VESA DMT timing kept (108 MHz, 64 kHz, 60 Hz) | 14% above the 95 MHz single-clock datasheet limit but clean on this card; the CVT reduced-blanking timing tried in p8 made a 1280x1024-incapable LCD report out of range |
| Banked VESA speed | Booster: banked 8/15/16/24/32 bpp modes use the linear path through a 64 KB window at A0000h; real LFB base kept in CR6D and restored on the next mode set; 4F01 and 4F05/4F03 read it correctly | Banked writes at 83.7 MB/s, as fast as the LFB; VESA 1.2 games much faster |
| Mode set clear | The 2 MB video memory clear of every S3/VESA mode set (p11) writes 32-bit words (rep stosd) instead of 16-bit ones, through the same 64 KB banks | Half the bus transactions; the clear is most of the 81 ms a mode set took on p9 (no change with the no-clear bit); 38.3 ms on the card with p12 |
| VGA mode set (p12) | The clear of video memory in modes 00h-13h (2C2Dh) and the font load into plane 2 (1224h, every text mode set and AX=11xxh) write 32-bit words | Mode set 03h about half the video memory writes (9368 instead of 20632), modes 12h/13h 16384 instead of 32768; mode set 03h 3.0 ms on the card (4.4 ms with p9) |
| VBE 4F05 (p12) | AX=4F05h BH=0 (set window) is handled at the INT 10h entry: unlock, CR58 test (refused in linear modes as before), SR04 for planar banks, CR6A; the 3C4h index is kept | 6 port writes and 3 reads instead of 13 writes and about 6 reads (15 us per call on the card with p9, 4.3 us with p12); get, errors and the window function (far call) are unchanged |
| Mode 13h scroll (p12) | AH=06h moves and fills with 32-bit words, full screen and windows; AH=07h keeps the original code | Half the video memory reads and writes |
| Text scroll (p13) | AH=06h/07h in text modes: the blank fill (full width, the clear screen of most programs and every line an AH=0Eh scroll adds) and the window line moves and fills use 32-bit stores, in both directions (the full-width move was 32-bit in stock) | A full-screen clear 1000 writes instead of 2000; windows half the writes per line |
| Planar scroll (p13) | AH=06h/07h in modes 0Dh-12h: the set/reset fill writes 32-bit words; the moves stay bytes (write mode 1 copies through the 8-bit latches, a wider access would copy only the last byte) | A mode 12h clear 9600 writes instead of 38400 |
| AH=09h text (p13) | Character and attribute written with 32-bit stores (both page paths) | Half the writes for counts above 1 |
| VGA mode set clear (p14) | The p12 clear moved back in place: `xor bl,bl / mov es,bx / xor di,di / jmp wfill`, the same 9 bytes as the original `rep stosw` routine, using the p13 word fill | 32 bytes of free space back; the same 32-bit clear |
| 512x384x8 (151h) | CR50 table byte 60h to 40h | Correct graphics engine pixel length (was the reserved 10b) |
| VBE 4F06 BL=3 | Rewritten: BX = min(8184, memory / lines) rounded down to 8, CX = BX in pixels | Real maximum line length (4368 for 101h instead of 546) |

### Byte-level changes

Offsets are in the 64 KB image (C000:offset when shadowed), in 2.04.07; everything from 0x8000 up is the
card's Trio64V+ BIOS, unchanged. Code blocks are listed with their labels; the sources are in `rompatch/`.

| Offset | 2.04.07 | p14 | Purpose |
| --- | --- | --- | --- |
| 0x006F | 2.04.07 | 2.04.07-p14 | Sign-on string (the copyright line moves into the zero padding after it) |
| 0x00C7-00C8 | 28 41 | 41 42 | MCLK PLL at POST: SR11 = 41h, SR10 = 42h (59.96 MHz) |
| 0x00D1 | 02 | 05 | POST flags: blank pedestal off (bit 1), the card's board flags (bits 0 and 2) |
| 0x00D3 | 10 | 00 | CR80 POST value 00h, as on the card |
| 0x00DE-00DF | 08 80 | 88 81 | CR41/CR52 refresh fields: 1280x1024 and 1600x1200 default 60 Hz |
| 0x04C1-04C4 | 5E 4F 50 81 | 5F 4F 50 82 | 640x480x8/x32 @ 60 Hz: line total 800 |
| 0x063B-063C | 36 43 | 6E 63 | DCLK PLL M, N/R for 40.09 MHz (70 Hz): VCO 160.4 to 320.7 MHz, same pixel clock |
| 0x0649-064A | 36 43 | 6E 63 | DCLK PLL M, N/R for 40.09 MHz (70 Hz): VCO 160.4 to 320.7 MHz, same pixel clock |
| 0x069D-069E | 63 48 | 63 63 | DCLK PLL M, N/R for 36.15 MHz (85 Hz): VCO 144.6 to 289.2 MHz, same pixel clock |
| 0x06AB-06AC | 63 48 | 63 63 | DCLK PLL M, N/R for 36.15 MHz (56 Hz): VCO 144.6 to 289.2 MHz, same pixel clock |
| 0x06B9-06BA | 36 43 | 6E 63 | DCLK PLL M, N/R for 40.09 MHz (60 Hz): VCO 160.4 to 320.7 MHz, same pixel clock |
| 0x070D-070E | 28 22 | 3D 41 | DCLK PLL M, N/R for 75.17 MHz (70 Hz): VCO 150.3 to 300.7 MHz, same pixel clock |
| 0x071B-071C | 1F 21 | 40 41 | DCLK PLL M, N/R for 78.75 MHz (75 Hz): VCO 157.5 to 315.0 MHz, same pixel clock |
| 0x0737-0738 | 1F 21 | 40 41 | DCLK PLL M, N/R for 78.75 MHz (43 Hz): VCO 157.5 to 315.0 MHz, same pixel clock |
| 0x0761-0762 | 1F 01 | 40 21 | DCLK PLL M, N/R for 157.50 MHz (85 Hz): VCO 157.5 to 315.0 MHz, same pixel clock |
| 0x07B5-07B6 | 63 48 | 63 63 | DCLK PLL M, N/R for 36.15 MHz (85 Hz): VCO 144.6 to 289.2 MHz, same pixel clock |
| 0x07C3-07C4 | 63 48 | 63 63 | DCLK PLL M, N/R for 36.15 MHz (56 Hz): VCO 144.6 to 289.2 MHz, same pixel clock |
| 0x07D1-07D2 | 36 43 | 6E 63 | DCLK PLL M, N/R for 40.09 MHz (60 Hz): VCO 160.4 to 320.7 MHz, same pixel clock |
| 0x0825-0826 | 28 22 | 3D 41 | DCLK PLL M, N/R for 75.17 MHz (70 Hz): VCO 150.3 to 300.7 MHz, same pixel clock |
| 0x0833-0834 | 1F 21 | 40 41 | DCLK PLL M, N/R for 78.75 MHz (75 Hz): VCO 157.5 to 315.0 MHz, same pixel clock |
| 0x084F-0850 | 1F 21 | 40 41 | DCLK PLL M, N/R for 78.75 MHz (43 Hz): VCO 157.5 to 315.0 MHz, same pixel clock |
| 0x0879-087A | 1F 01 | 40 21 | DCLK PLL M, N/R for 157.50 MHz (85 Hz): VCO 157.5 to 315.0 MHz, same pixel clock |
| 0x0895-0896 | 20 01 | 42 21 | DCLK PLL M, N/R for 162.27 MHz (60 Hz): VCO 162.3 to 324.5 MHz, same pixel clock |
| 0x089F-08A3 | C1 03 82 48 33 | 40 7E 82 3C 28 | 320x240x8 refresh entry: CRTC table 7E40h, 60 Hz, 25.06 MHz |
| 0x08AD-08B1 | F5 0C 82 48 33 | 60 7E 82 3C 28 | 320x240x15/16 refresh entry: CRTC table 7E60h, 60 Hz |
| 0x08DB-08DC | 36 23 | 6E 43 | DCLK PLL M, N/R for 80.18 MHz (60 Hz): VCO 160.4 to 320.7 MHz, same pixel clock |
| 0x0913-0914 | 36 23 | 6E 43 | DCLK PLL M, N/R for 80.18 MHz (60 Hz): VCO 160.4 to 320.7 MHz, same pixel clock |
| 0x094B-094C | 28 22 | 3D 41 | DCLK PLL M, N/R for 75.17 MHz (60 Hz): VCO 150.3 to 300.7 MHz, same pixel clock |
| 0x0959-095A | 28 42 | 3D 61 | DCLK PLL M, N/R for 37.59 MHz (70 Hz): VCO 150.3 to 300.7 MHz, same pixel clock |
| 0x095C | 60 | 40 | CR50 for 512x384x8/x32 |
| 0x0967-0968 | 28 42 | 3D 61 | DCLK PLL M, N/R for 37.59 MHz (70 Hz): VCO 150.3 to 300.7 MHz, same pixel clock |
| 0x0B1A-0B1D | C2 9F A0 85 | C3 9F A0 86 | 640x480x15/16 @ 60 Hz: line total 800 |
| 0x0CEE | B0 | AF | 1600x1200 @ 60 Hz: CR12 vertical display end AFh, 1200 lines (the reference has 1201) |
| 0x1224-1226 | 50 51 8A | E9 3B 6B | font load: rep movsd per character (p12) |
| 0x1227-1234 | old font loop (dead since p12) | code | `p13bfa.asm`: bfilla 1227 |
| 0x143D-1441 | 2E 8E 06 48 1D | E9 80 6B 90 90 | S3/VESA mode set clear: rep stosd (p11) |
| 0x1442-1453 | old clear loop (dead since p11) | code | `p13move.asm`: wmove 1442 |
| 0x20D3-20D4 | 7B 26 | 80 7E | INT 10h AH=00 table: mode set via the hook |
| 0x210F-2111 | 80 FC 0E | E9 E9 5B | INT 10h entry: fast 4F05 BH=0 (p12) |
| 0x2C2D-2C35 | 9 bytes | 9 bytes | VGA mode set clear: in place, rep stosw replaced by a jump to wfill (p14) |
| 0x2ED5-2EDF | 11 bytes | 11 bytes | text scroll full width: blank fill with wfill (p13) |
| 0x2EE4-2EF5 | 18 bytes | 18 bytes | text scroll window: line moves with wmove (p13) |
| 0x2EF6-2F06 | 17 bytes | 17 bytes | text scroll window: blank lines with wfill (p13) |
| 0x3126-3129 | 33 C0 F3 AA | E8 2F 4E 90 | planar scroll full width: fill with bfill (p13) |
| 0x3171-317D | 13 bytes | 13 bytes | planar scroll window: fill lines with bfilla (p13) |
| 0x31F5-31F7 | 3B 0E 4A | E9 86 4B | mode 13h scroll AH=06h: 32-bit (p12) |
| 0x3513-3515 | F3 AB C3 | E9 AF 24 | AH=09h text: char/attribute with wfill (p13) |
| 0x3519-351B | F3 AB C3 | E9 A9 24 | AH=09h text, page > 0: with wfill (p13) |
| 0x56DD-56DF | E8 9B CF | E8 A0 27 | VBE 4F02: mode set via the hook |
| 0x56F7-56FC | C7 06 FE 04 00 00 | E8 F6 27 90 90 90 | VBE 4F02 end: booster |
| 0x59BB-59BF | B8 FF 03 33 D2 | E8 B3 25 EB F8 | VBE 4F06 BL=3: corrected routine, then mov ah,0 / ret |
| 0x59C0-59E2 | old 4F06 BL=3 code (dead since p8) | code | `p13fill.asm`: wfillt 59C0, wfill 59C5 |
| 0x5CCF-5CD2 | 8B C3 0B C0 | E8 6C 22 90 | LFB base read: real base while the booster is on |
| 0x5CED-5CEF | 25 00 10 | E8 5F 22 | 4F05/4F03 linear test ignores the booster window |
| 0x7CFB-7E1D | 00 | code | `p12ext.asm`: int10x 7CFB, font 7D62, scr13 7D7E |
| 0x7E40-7E78 | 00 | tables | `crtc240.asm`: crtc8 7E40, crtc16 7E60 |
| 0x7E80-7F57 | 00 | code | `hooks.asm`: hook 7E80, boost 7EF0, basefix 7F3E, lfbchk 7F4F |
| 0x7F58-7F70 | 00 | code | `p13bfill.asm`: bfill0 7F58, bfill 7F5A |
| 0x7F71-7FAE | 00 | code | `vbe4f06.asm`: bl3 7F71 |
| 0x7FAF-7FB6 | 00 | code | `p13df.asm`: dfdn 7FAF |
| 0x7FC0-7FE2 | 00 | code | `clear32.asm`: clear 7FC0 |
| 0x7FFF | 0B | D8 | Checksum of the lower 32 KB |

### Borrowed ideas

No code was copied from another project; all ROM code was written for this BIOS.

| Item in the ROM | Origin | What was taken |
| --- | --- | --- |
| FIFO fetch fix | [S3VBEFIX](https://github.com/wbcbz7/S3VBEFIX) 0.6.1 by Artem Vasilev (wbcbz7), WTFPL | The diagnosis and the fix: clear CR90 bit 7 when a VGA mode is set |
| Attribute flip-flop reset | S3VBEFIX | The idea: a dummy read of the input status register (3DAh) after the mode set |
| Booster | S3VBEFIX, which credits SVGATRIX.TXT; the 64 KB linear window at A0000h is documented in the Trio64V+ datasheet | The register sequence CR58 AND ECh, CR59=00, CR5A=0Ah, CR58 OR 10h. Saving the real base in CR6D and restoring it in the ROM's own mode set is our design |
| LFB mode set handling | S3VBEFIX | Only the observation that the booster's base must be restored before an LFB mode; implemented differently |
| Refresh and LCD timings | Not from S3REFRSH | The ROM carries the timings itself: VESA DMT 640x480 @ 60 Hz (800x525) and the BIOS's own 640x480 tables halved for 320x240 |
| Memory clock 59.96 MHz | Trio64V2 datasheet | PLL values chosen to meet the 16.67 ns 1-cycle EDO limit |

### Kept outside the ROM

| TSR | Fixes | Why not in the ROM |
| --- | --- | --- |
| S3ALIAS.COM (`s3alias/`) | Pinball Illusions' S3 driver: AH=00 mode 49h becomes 59h, 4Bh becomes 5Ah | Remapping S3 mode numbers in the ROM would break programs that use this BIOS's own numbering |

### Omitted: 1-cycle linear addressing (CR87 bit 1, SR15 bit 7)

The Trio64V2 datasheet (section 3.5) describes a faster linear addressing path: CR87 bit 1 = 1
enables 1-cycle linear addressing of video memory, "the memory must be capable of supporting this
mode", and the default with SR0A bit 7 and SR15 bit 7 set is 2-cycle operation. It was tried on top
of the p7 booster in 640x480x8 (101h) with a write benchmark and a 320 KB pattern check (VLIN2):

| SR15 bit 7 | CR87 bit 1 | Write speed | Data errors |
| --- | --- | --- | --- |
| 0 | 0 | 83683 KB/s | 0 |
| 1 | 0 | 83683 KB/s | 65536 |
| any | 1 | hang | - |

There is no speed gain with this card's memory, SR15 bit 7 corrupts data and CR87 bit 1 hangs the
machine, so neither bit is set by the ROM.

### Known remaining items

- The 8x14 font is missing in the BIOS (S3COMPAT WARN 01 for AX=1130h BH=2 and mode 10h).
- An LFB is offered on the planar mode 104h (S3COMPAT WARN 20), as in stock and the reference.
- 106h runs at 108 MHz, above the datasheet single-clock limit (S3COMPAT WARN 02).
- The BIOS writes SR04 = 03h in text modes where IBM writes 02h; bit 0 is reserved on the VGA and
  reads back as 0 on the card, so programs see the IBM value.

## Sources

- S3 Trio64V2/DX and GX datasheet (preliminary): MCLK and DCLK limits, the 3-bit DCLK R divider
  (SR12 bit 7), CR36 EDO modes, CR87 1-cycle linear addressing, CR90/CR91 FIFO.
- XFree86 / X.Org xf86-video-s3, `s3_Trio64DAC.c`: the DCLK PLL range 170-340 MHz for the Trio64V2/DX/GX, which S3COMPAT uses for every VESA mode
- S3 Trio64V+ (86C765) datasheet, from the S3VBEFIX repository: PLL formula and VCO range, CR67 colour
  modes, SR15/SR18 clock doubling, CR31/CR58/CR59-5A linear addressing, CR50, CR51, CR43, CR5D/CR5E.
- [S3VBEFIX](https://github.com/wbcbz7/S3VBEFIX) source and README, plus SVGATRIX.TXT and vbe20.txt.
- VESA BIOS Extension (VBE) 2.0 specification; VESA DMT; VESA CVT 1.1.
- VGATEST by Kent Quirk and Ed McNierney, PC Tech Journal, November 1988 (IBM reference tables).
- VBETest/Lite (SciTech) and X-VESA 1.0.3: test ideas for S3COMPAT and VSHOW.
- [DOS compatibility tests by gona.mactar.hu](https://gona.mactar.hu/DOS_TESTS/): known S3 issues.
- The stock 2.04.11 dump, disassembled to locate the mode set, refresh tables and VBE handlers.
- The S3 reference BIOS 2.04.07, the base of the current ROM, compared with 2.04.11 to find the same
  routines and tables at its addresses.
