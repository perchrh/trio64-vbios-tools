# Trio64V2/DX VBIOS test tools

DOS tools written while modifying the video BIOS of a Gainward S3 Trio64V2/DX card
(86C775, 2 MB EDO 40 ns, board ICUVGA-GW503A, PCI 5333:8901). 

The new ROM image itself is not in this repository. The modifications done to the reference bios are in `rompatch/`
as well as the patcher that builds the new ROM image from the reference BIOS.

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
above its range, so do not run these tools with one. The `/H` help of each tool says so, and
`VSHOW /I` shows it once on the screen before the mode list.

All tools share one version number and S3TEST checks for one ROM version; both are set in
`common/version.inc` (`VERSION`, `ROMVER`) and can be overridden for a build, for example
`make clean && make VERSION=0.9 ROMVER=2.04.07-p18`.

## Building

NASM 3.02 (the ROM build needs exactly 3.02, see ROM patcher):

    make            # Linux, macOS, WSL
    build.bat       # DOS or Windows with nasm.exe on the PATH

A NASM that is not on the PATH is given with `NASM`, for example a copy in the working tree (the
folder `nasm/` is ignored by git):

    make NASM=nasm/nasm-3.02/nasm
    make emu-test ROM=S3V2P19.BIN NASM=nasm/nasm-3.02/nasm
    make rom OUT=S3V2P19.BIN NASM=nasm/nasm-3.02/nasm
    set NASM=nasm\nasm-3.02\nasm.exe & build.bat

Every target uses it: the tools, the ROM build (`rom`, `rom-test`) and the emulator tests, which
assemble code themselves too (`emu/tests.py --nasm`, `emu/mutants.py --nasm`; both also read the
environment variable `NASM`). A relative path is made absolute. `make` warns when the assembler is
not NASM 3.02.

The .COM files land in `build/`, with `RUNALL.BAT` (from `runall.bat`): it runs S3TEST, S3COMPAT and
`VSHOW /R`, all with `/V /S`, writes S3TEST.LOG, S3COMPAT.LOG, VSHOW.LOG and their .DBG files next to
them, and beeps (`echo` of Ctrl-G) when done. `/S` skips the monitor warnings, so only start it with a
monitor that takes 91 kHz or refuses it (an LCD). `common/` holds the /V debug log code the test tools
share.

## Emulator tests

`emu/` runs the video BIOS and the DOS tools in an emulated PC, so changes can be checked before a
hardware run. The tests need python3 and the unicorn package from PyPI (listed in `pyproject.toml`),
NASM, and the 64 KB ROM image of the card, which is not in this repository:

    python3 -m venv .venv
    .venv/bin/pip install .
    make emu-test ROM=path/to/S3V2P19.BIN

`make emu-test` runs every test with 2 MB and then again, with 4 MB, the seven whose result depends on
the memory size (tag `vram`: rom_patches, s3test, vshow, s3compat_vbe, s3compat_full, errors, windows;
the others give the same output with both sizes). `make emu-test ROM=... VRAM=4` runs every test with 4 MB (the CR36 strapping of a 4 MB card; the
86C775 supports 2 and 4 MB): the BIOS then lists the modes up to 4 MB (1280x1024x15/16, 1152x864x32,
1024x768x32) and the tests expect what follows from 4 MB (4F06 BL=3 maximum line 8184, the modes 4F01
marks supported). With 4 MB S3COMPAT gives WARN 02 for 1024x768x32, 1152x864x32 and 1280x1024x15/16:
their default pixel clock is above the datasheet maximum for the depth, as in the reference BIOS.

The tests are independent: `make emu-test` runs as many at a time as the machine has CPUs, each in
its own process, the long ones (the full S3COMPAT, VSHOW /R, the S3COMPAT VBE part) first; `JOBS=1`
runs them one after the other, `python3 emu/tests.py -j N` sets the number. The full S3COMPAT run
(about 8 minutes) is the lower limit of the total time.

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

### Other Trio64-family BIOSes

`--chip` (`v2`, `vplus`, `uvplus`, `trio64`, `trio32`) makes the model that chip: its PCI device ID and
revision, CR2D-CR2F, the PCI subsystem ID (Trio64V2 only) and the width of the PLL post divider R (3
bits on the Trio64V2 only). The Trio64UV+ (86C767, device 8814h) is found by the tools too; it shares
system memory (UMA), which neither the tools nor the model know about, so only its register rules are
judged. The tools
find the chip themselves (`common/chip.inc`) and judge the clocks by that chip's datasheet limits.
With a ROM that is not our patched BIOS (no `2.04.07-pN` sign-on) the tests tagged `patch` (version,
rom_patches, stores, s3test, s3alias) are skipped, and the others take their expected values from the
standards or from the registers the BIOS set, not from our BIOS:

    python3 emu/tests.py --rom TRIO64VP.BIN --chip vplus

S3COMPAT follows the BIOS too: on a VBE 1.x BIOS the VBE 2.0 functions (4F06 BL=2/3, 4F07 BL=80h,
4F09, 4F0A) are INFO "not in VBE 1.x", a BIOS without the S3 OEM functions 4F14h gets INFO, and on a
chip other than the Trio64V2 a missing standard VESA mode and the S3 mode number table of the 2.04
BIOS are INFO. A default refresh other than the VESA 60 Hz rate is WARN 40 (a choice of the BIOS, not
an error), an interlaced mode is judged by its frame (twice the lines of a field) and not held to the
56-90 Hz range.

Chip rules: S3COMPAT judges the registers the BIOS programs by the datasheet rules of the chip it
found; `docs/chip-rules.md` lists every rule with its ID, chips, source and the result bit that checks
it. On the Trio64V2 a DCLK VCO outside 135-340 MHz (the datasheet range) is FAIL 200; inside it but
below 170 MHz (the minimum of XFree86, not of the datasheet) it is WARN 08. The Trio64V2 POST part also
checks SR1A bit 4 and the PCI subsystem ID handover (ROM C000:0040-0043 to CR81-CR84, CR37 bit 2
cleared), and its VESA lines CR32 bit 3 (FAIL 1000) and the CR86 and CR90/CR91 rules (WARN 80; on this
ROM 012Eh, 010Fh, 0131h, 0134h and 012Ah, see Known remaining items). The emulator test `v2_writes`
(tag `s3 emu`, Trio64V2 model only) checks the rules that concern writes: CR26 = 00h after CR39 = A5h
on every mode set, and CR40 bit 0 and CR66 bit 0 changed only with the screen off or in vertical retrace.

On every chip S3COMPAT also checks the MCLK against the chip's maximum (60 MHz on the Trio32/64 and
Trio64V+, 66.67 MHz on the Trio64UV+), PLL M and N of at least 1, packed 24 bpp by either encoding
(SRB 78h or CR67 0111b, 75 MHz, not on a Trio64), no clock doubling with the Streams Processor on, SR15
bit 5 not left set, and on the Trio64V+ family the CR66 combination the Trio64UV+ update calls a system
hang (FAIL 1000). The emulator test `engine_init` checks that a BIOS that uses the graphics engine
writes BEE8h index D and E first.

What the emulator finds in the stock BIOSes at hand (2 MB; the card logs decide):

- Trio64V+ BIOS 1.03-08 (VBE 1.2): 320x200 at 15/16/32 bpp with the DCLK VCO at 101 MHz, below the
  135 MHz datasheet minimum (FAIL 200); 1600x1200x8 interlaced at a 98 Hz field rate (WARN 50);
  4F02 sets 118h, 119h and 11Ah, which 4F01 marks unsupported, and a refused 4F02 changes the video
  state; 4F06 clears the upper halves of EAX, ECX and EDX (windows test).
- Trio64 BIOS 1.4-04 (Phoenix, VBE 1.2): 1280x1024 with PLL N = 0 (the datasheet minimum is 1, FAIL
  200), 1024x768 and 1280x1024 interlaced (WARN 10/50), 800x600 at 56 Hz (WARN 40), no 115h, 118h,
  119h, 11Ah (INFO), the 8x8 upper half font of another design (WARN 02), and 4F06 as above. It
  clears video memory with the graphics engine, which the model does not run (4F02 clear: model
  limit).

### Test categories

Every test has categories: the standard its expected values come from (`mda`, `cga`, `ega`, `vga`:
the IBM BIOS of that adapter; `vbe`: VESA; `s3`: the chip and its datasheet; `rom`: the image itself),
`patch` (our changes to the reference BIOS), `call` (how the BIOS is called: registers, flags, invalid
input) and `tools` (our DOS tools), and where it runs: `card` (a tool that also runs on the card, so
the hardware log decides) or `emu` (emulator only). `python3 emu/tests.py --list` shows them;
`-t cga,ega` runs only those tests.

S3TEST and S3COMPAT put the category in a 5-column field in front of every result line (`ROM`, `MDA`,
`CGA`, `EGA`, `VGA`, `VBE`, `S3`) and end with one summary line per category, for example

    EGA  Mode 10h                                   Hz 70.0/70.0 31.4kHz H800 V449  WARN 01
    VBE  4F07 start incl. CR69 above 256K           PASS
    ...
    VGA  PASS 28  FAIL 0  WARN 0  INFO 0

A BIOS mode is in the category of the adapter that introduced it (07h/0Fh MDA, 00h-06h CGA, 0Dh-10h
EGA, 11h-13h VGA, VESA modes VBE); a BIOS function in that of the BIOS that defined it (AH=00h-0Fh
and 13h CGA, AH=10h AL=00h-03h, AH=11h and AH=12h BL=10h/20h EGA, the DAC functions, AH=12h BL=30h-36h
and AH=1Ah-1Ch VGA). The emulator tests check that every result line has a category, that mode lines
have the right one, and that the summary counts the lines. Logs from before this change have no
category column: compare from the sixth column.

### Test coverage

    pip install .[coverage]          (capstone, for emu/codemap.py)
    make coverage ROM=path/to/S3V2P19.BIN

runs every emulator test while recording which ROM bytes execute, then `emu/codemap.py` finds the
code of the lower 32 KB by recursive descent from the POST entry, every executed block and every
direct jump, call and word jump table, and reports the share the tests executed. Data (tables,
fonts, strings, padding) and code nothing reaches (the routines our patches jump around) do not
count. `--list` gives the code ranges no test runs. The goal is at least 80 %; 2.04.07-p18 is at
86.5 % (15119 of 17471 bytes). The parts still not run include the display switch (AH=12h BL=35h),
the mono/colour adapter switch in the mode set, MDA (3B4h) paths and error paths.

### EGA/CGA against the reference BIOS

    make ref-compare ROM=S3V2P19.BIN

runs 2389 INT 10h calls in the CGA, MDA and EGA modes (00h-07h, 0Dh-10h) on the unpatched reference
BIOS and on the ROM (mode sets at 200, 350 and 400 lines, scrolls with random windows, text and pixel
output, palettes, pages, fonts, AH=12h, AH=1Ah, AH=1Ch) and compares the registers a program gets
back, the BIOS data area, video memory, the DAC and the standard VGA registers after each call. For
the current ROM there is no difference: the patches in those paths (32-bit text scroll, planar fills,
AH=09h, VGA clear, font load) only change how fast it is done, and the mode set hook, the memory
clock and the pedestal only touch S3 extended registers, which are not compared.

## ROM patcher

`rompatch/` holds the code the ROM carries (nasm sources, assembled at their ROM offsets, with the
2.04.07 addresses they use in `bios.inc`) and `s3patch.py`, which applies the whole current change set
(level p19) to the S3 reference BIOS 2.04.07. It needs python3 (no packages) and NASM:

    python3 rompatch/s3patch.py reference/v2/2_04_07.bin -o S3V2P19.BIN
    make rom OUT=S3V2P19.BIN

The input is the 32 KB reference BIOS (or a 64 KB image with it in the lower half; the rest is not
used). The repository carries it as `reference/v2/2_04_07.bin`, the default of `IN` for `make rom` and
of `REF` for `make rom-test` and `make ref-compare`; `IN=...` or `REF=...` selects another copy. The
result is 64 KB: the patched BIOS, then 32 KB of zeros. Only 2.04.07 is accepted. Every patch site is
compared with the original code first (the replaced routines in full), and the result is checked
before it is written: the lower half sums to 00 and declares 32 KB, the upper half is zeros, every
DCLK VCO is in 170-340 MHz, and with the known reference image the SHA-256 is the one of the build
that passed every emulator test (f563989b...).

That SHA-256 holds for NASM 3.02, the assembler of the project. Another NASM version may encode some
instructions differently (NASM 2.16.01 puts the REP prefix before the operand-size prefix of REP
MOVSD/STOSD, 3.01 and 3.02 after it; such an image works the same), and then the result check fails: s3patch names the assembler and the blocks whose
code differs from the tested build, writes nothing to OUT and keeps the image in OUT.untested, only
for a comparison; do not flash it. Build with 3.02 instead, for example
`make rom OUT=S3V2P19.BIN NASM=nasm/nasm-3.02/nasm`.

    python3 rompatch/test_s3patch.py --ref reference/v2/2_04_07.bin [--stock STOCK.BIN] [--rom S3V2P19.BIN]
    make rom-test [STOCK=STOCK.BIN] [ROM=S3V2P19.BIN]

runs the checksum tests: the pinned SHA-256 (and the same bytes as `--rom`), the lower half sums to
00 with the right byte at 7FFFh, the upper half zeros, the VCO range, every refresh entry with M 1-127,
N 1-31 and a defined R code (pllcodes), the free bytes still 00, a 64 KB
input giving the same result whatever its upper half holds, `--no-vco-fix`, and the inputs that must
be refused (already patched, three patch sites changed, a wrong checksum, and with
`--stock` the card's stock 2.04.11).

## Continuous integration

`.github/workflows/ci.yml` runs on GitHub Actions for pushes to main, pull requests and by hand (the
Actions tab, "Run workflow"). The repository is public, so the GitHub-hosted runners it uses are free;
changes that touch only `*.md`, `docs/` or `datasheets/` do not start a run, and a newer commit on the
same branch cancels the running one.

Every run builds NASM 3.02 from its release source (cached between runs) and the tools with `make`;
the .COM files are kept as the artifact `tools` for 14 days. It then builds the ROM from the S3
reference BIOS 2.04.07 in `reference/v2/2_04_07.bin` (`make rom`, `make rom-test` with the pinned
SHA-256) and runs `make emu-test` and `make ref-compare` on it, each even when an earlier one failed;
the emulator logs are kept as the artifact `emu-logs` (without .BIN files), the patched ROM image is
not kept. The hardware logs remain the final word, as for the emulator tests run by hand.

`.github/workflows/coverage.yml` runs `make coverage` (the 80 % goal, with the list of code no test
reaches) on the same ROM, for pushes to main and by hand only: pull requests do not start it, as it runs
every emulator test once more. Its logs are kept as the artifact `coverage-logs`.

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

Findings (S3REGS.TXT and VGALOG.BIN from the card, Windows 98 SE, October 2026):

- The driver (S3_2.DRV / S3VDD.VXD 4.10.01.2108-2.41.07) sets every desktop mode through VBE 4F02 with
  bit 15 set and bit 14 clear (banked, memory not cleared), CX = lines, DX = 3D4h: 101h, 103h, 107h,
  111h, 112h, 114h, 115h, 117h, 120h and 207h (1152x864x8). Afterwards it writes CR58 = 92h itself
  (linear on, 2 MB window) and takes the linear address from CR59/CR5A, which it expects at the PCI
  base (E000h). It never uses CR6D. At start it calls 4F15 and 4F10 and sets mode 10h, at exit
  mode 03h twice and 4F03.
- That is why the booster is refused while Windows runs in enhanced mode: a booster switched on by
  the driver's banked 4F02 leaves CR59/CR5A = 000Ah, and the driver turns its 2 MB window on at
  A0000h (garbage on the desktop). And with the booster on in a full-screen DOS box (VSHOW 101h, 103h),
  Windows restored the box after Alt+Tab with MISC = 63h (the fixed 25 MHz clock, 400-line sync), which
  the monitor could not show, every time; without the booster this happens only once in many tries, as
  with the stock BIOS. With the ROM the desktop snapshots show CR6D = 01h (the refusal), CR58 92h and
  CR59/CR5A E000h, and VSHOW in a full-screen box comes back after Alt+Tab as with the stock BIOS. The
  emulator test `windows` replays the driver's 4F02 calls with an INT 2Fh that answers Windows.
- Windows brings a full-screen DOS box back with its own 4F02 call (8101h, 8103h, C101h; CX = 0,
  DX = 03E0h), and the desktop with 4F02 8115h; the mode set hook restores CR59/CR5A from CR6D when a
  booster was on in plain DOS before.
- The driver keeps the memory clock the BIOS sets (59.96 MHz with the ROM, 50.11 MHz with the stock
  BIOS) on the desktop, in DOS boxes and through video playback, and uses the BIOS pixel clocks,
  also the VCO-moved ones (800x600: SR12/SR13 63h/6Eh, 40.09 MHz, VCO 320.7 MHz).
- CR90/CR91 (L1) is set by the driver to (bytes per line / 8) - 1 in every mode (V2-REG-4); CR86 stays
  00h with an End Horizontal Blank above 1 (V2-REG-3).
- The stock BIOS leaves CR90 = 81h, CR91 = 8Fh (the L1 of 800x600x32) in mode 03h after Windows and in
  a full-screen DOS box; the FIFO fix of the ROM clears bit 7 there (CR90 01h).
- 1280x1024 and 1600x1200 give "out of range" on an LCD with the stock BIOS and no error in Windows:
  the driver chooses no refresh rate, and the stock defaults (CR41 = 08h, CR52 = 80h, as in the
  reference) are interlaced timings (107h about 87 Hz fields at 46.7 kHz, 120h about 98 Hz fields at
  63.7 kHz). Windows then goes back to the previous mode (4F02 207h right after 107h or 120h). The ROM
  sets 60 Hz for both.
- Full-screen MPEG video in Media Player 6 sets 4F02 8111h with CX = 240 (the driver's 320x240 mode,
  made from 111h). The first such video after boot shows wrong colours (YUV-like green), later ones
  are right, with the stock BIOS as with the ROM: the driver or DirectShow.
- Programs in plain DOS: Warcraft II (DOS/4GW) and VIDSPEED set their banked modes with 4F02 (0101h,
  0113h) and get the booster from the mode set (CR58 90h, CR59/CR5A 000Ah after the call, CR6D E0h
  afterwards); Warcraft II switches banks through the 4F0A protected-mode code (5B5E-5CB5, unchanged
  from the reference), which never calls 4F05. Warcraft II tested fully. After Windows' "Restart in
  MS-DOS mode" it hangs before the first picture, with the stock BIOS as with the ROM; booted straight
  to DOS it runs.
- A snapshot taken in AUTOEXEC.BAT shows the Windows boot logo's registers (MISC 63h, GR05 50h), not mode
  03h, although the BIOS data area says 03h; take the text mode baseline from DOS safe mode instead.
- S3REGS32 run while a DOS box is full screen, and S3REGS in a windowed DOS box, show the values the
  driver's port trapping returns (SR all 00h, A8h and 3Fh fill), not the chip; S3REGS in a full-screen
  DOS box reads the real registers.

S3REGS.TXT format (S3REGS and S3REGS32 write the same):

    S3REGS 1.0 [label] DOS                    or  S3REGS32 1.0 [label] Win32
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

## Features and changes compared to the reference BIOS 2.04.07

The ROM is the S3 Trio64V2/DX reference BIOS 2.04.07 with the changes below in the lower 32 KB; the
upper 32 KB is zeros (the ROM header declares 32 KB). The lower half checksums to 0. Every change keeps
the standard VGA modes (00h-13h) and the VESA modes compatible, and the RAM stays in 1-cycle EDO mode.
Video memory of 2 MB and 4 MB is supported (the 86C775 maximum). In the CGA, MDA and EGA modes the ROM
behaves exactly like the reference (`make ref-compare`); the changes there only make it faster. About
100 bytes of the lower 32 KB are free: 0x7CD9-7CFA, 0x7E36-7E3F, 0x7E59-7E5F, 0x7E79-7E7F,
0x7F51-7F57, 0x7FB7-7FBF, 0x7FE3-7FFE.

Picture and monitor

- **Black level:** the blank pedestal is off at POST (header flag 0xD1 bit 1 cleared, SR1A bit 5 never
  set): the deepest black, no grey lift.
- **60 Hz defaults for 1280x1024 and 1600x1200** (CR41/CR52 refresh fields): they work on 60 Hz LCDs;
  the reference defaults to rates LCDs reject.
- **640x480 class at exactly 800 pixels per line** (the reference has 792/796) in the 640x480 and
  320x240 tables: the VESA 640x480 @ 60 Hz line (31.3-31.5 kHz), so one LCD preset covers every mode
  of that class.
- **320x240 at 60 Hz** (131h, 132h, 133h): new CRTC tables, 640x480 @ 60 Hz halved horizontally and
  double scanned, so LCDs see a standard 640x480 @ 60 Hz signal without scaling waves; 132h/133h at 2
  clocks per pixel.
- **1600x1200 (120h):** vertical display end 1200 lines (CR12 AFh), as 4F01 reports; the reference
  shows 1201.
- **DCLK PLL in the XFree86 range:** 22 refresh entries of the reference ran the VCO at 145-162 MHz,
  inside the datasheet range (135-340 MHz) but below the 170 MHz minimum XFree86 uses; new M/N/R give
  exactly the same pixel clock with the VCO in 170-340 MHz (smallest R, then smallest N).
  Each mode's refresh list starts at the entry its mode table pointer gives and runs downwards to the
  entry with bit 7 of byte 2 set.
- 1280x1024x16 colours (106h) keeps the VESA DMT timing (108 MHz, 64 kHz, 60 Hz): 14% above the 95 MHz
  single-clock datasheet limit but clean on the card; a reduced-blanking timing made a
  1280x1024-incapable LCD report out of range.

Speed

- **Memory clock 59.96 MHz** (SR11=41h, SR10=42h, VCO 239.8 MHz) instead of 50.11 MHz: about 20% more
  memory bandwidth; 59.96 MHz is the 1-cycle EDO maximum (16.67 ns). CR36 bits 3-2 stay 00. The CR88
  bit 1 tweak of the reference compares SR10/SR11 with the old MCLK values and so stays off.
- **Banked VESA booster:** the banked 8/15/16/24/32 bpp modes use the linear path through a 64 KB
  window at A0000h; the real LFB base is kept in CR6D and restored on the next mode set, and 4F01 and
  4F05/4F03 report it correctly. Banked writes at 83.7 MB/s, as fast as the LFB. It is switched on at
  the end of a banked 4F02, so every way of switching banks gets it (INT 10h 4F05, the window
  function, the 4F0A protected-mode code, programs that write CR6A themselves), and by the first bank
  switch (4F05 set window or the window function) in the S3 modes set with INT 10h AH=00, which do
  not pass the end of 4F02. It stays off while Windows runs in enhanced mode (INT 2Fh AX=1600h,
  asked once per mode set and remembered as CR6D = 01h): Windows 98's S3 driver needs CR58-CR5A as
  the reference leaves them after a banked 4F02, and restores a full-screen DOS box wrongly when the
  booster was on in it ("Windows 9x driver test").
- **Fast 4F05 set window:** AX=4F05h BH=0 is handled at the INT 10h entry (unlock, CR58 test, SR04 for
  planar banks, CR6A; the 3C4h index is kept): 6 port writes and 3 reads instead of 13 writes and
  about 6 reads, 4.3 us per call on the card. Get and errors are unchanged; in a banked mode with the
  booster still off (an AH=00 S3 mode) the first call turns it on, as the window function does.
- **32-bit video memory stores** where the reference uses 8- or 16-bit ones, with the same result:
  - the 2 MB clear of every S3/VESA mode set (rep stosd through the same 64 KB banks; the clear is
    most of a VESA mode set's time)
  - the clear of modes 00h-13h and the font load into plane 2 (every text mode set and AX=11xxh):
    mode set 03h with 9368 video writes instead of 20632, 12h/13h 16384 instead of 32768
  - AH=06h scrolls in mode 13h (moves and fills, full screen and windows; AH=07h keeps the original
    code)
  - AH=06h/07h in the text modes: the blank fill (the clear screen of most programs and every line an
    AH=0Eh scroll adds) and the window line moves and fills, in both directions
  - AH=06h/07h in modes 0Dh-12h: the set/reset fill (the moves stay bytes: write mode 1 copies through
    the 8-bit latches)
  - AH=09h in the text modes, both page paths

Fixes

- **Attribute controller:** an input status read after every mode set resets the index/data
  flip-flop, for programs that write port 3C0h right after a mode set.
- **FIFO fetch:** CR90 bit 7 is cleared after setting any VGA mode 00h-13h; fixes stripes and garbage
  in Mode X and 360-wide modes after a VESA mode (Quake 360x200).
- **512x384x8 (151h):** CR50 40h, the correct graphics engine pixel length (the reference has the
  reserved 10b).
- **VBE 4F06 BL=3:** the real maximum line length, BX = min(8184, memory / lines) rounded down to 8 and
  CX = BX in pixels (4368 in 101h with 2 MB, 8184 with 4 MB; the reference returns 546).
- **DDC (VBE 4F15), as in the S3 BIOS 2.04.11** (the card's stock BIOS), p19:
  - The delay the DDC code waits between line changes sets PIT channel 2 with B6h (mode 3, low then
    high byte). 2.04.07 wrote 86h, only the latch command, loaded the count in whatever access mode
    channel 2 had and never read the latch; the 8254 ignores a second latch while one is pending, so
    the first read gave a stale count and most delays came out far too short.
  - The probe passes its 0255h delay in AX (5E07h); 2.04.07 loaded BX, so the delay used whatever AX
    held.
  - Interrupts are off for the whole 4F15 operation, so a timer interrupt cannot stretch a clock
    pulse.
  - All three are the 2.04.11 code. POST calls the same delay once (14E5h), so POST now waits there
    as with the stock BIOS (13.8 ms; To do).
  - Whether this card connects the DDC lines to the VGA connector is
    not known: Windows 98 showed a generic monitor with the stock 2.04.11 (To do).
- **CR23 before CR26:** every mode set writes CR23 = 00h, then CR26 = 00h (p19). Trio64V2 datasheet
  section 4.2: CR23 "must be 00H before CR26 is written", and "the BIOS must write 00H to [CR26] upon
  each mode set (assuming CR23 is at its default value of 00H)". A driver that used vertical
  interpolation for a video window (section 3.2.2) may leave CR23 set; 2.04.07 wrote only CR26.
  2.04.11 clears CR23 first when the mode in the BIOS data area is above 13h; the ROM does it on every
  mode set (CR23 is reserved, 00h by default).
- The card's POST flags (0xD1 = 05h) and CR80 POST value (00h).

### Byte-level changes

Offsets are in the 64 KB image (C000:offset when shadowed), in 2.04.07; everything from 0x8000 up is
zeros. Code blocks are listed with their labels; the sources are in `rompatch/`.

| Offset | 2.04.07 | p19 | Purpose |
| --- | --- | --- | --- |
| 0x006F | 2.04.07 | 2.04.07-p19 | Sign-on string (the copyright line moves into the zero padding after it) |
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
| 0x1224-1226 | 50 51 8A | E9 3B 6B | font load: rep movsd per character |
| 0x1227-1234 | old font loop (dead after the jump) | code | `p13bfa.asm`: bfilla 1227 |
| 0x143D-1441 | 2E 8E 06 48 1D | E9 80 6B 90 90 | S3/VESA mode set clear: rep stosd |
| 0x1442-1453 | old clear loop (dead after the jump) | code | `p13move.asm`: wmove 1442 |
| 0x1A62-1A65 | B8 26 00 EF | E8 63 62 90 | mode set: CR23 = 00h before CR26 = 00h (`cr2326`) |
| 0x20D3-20D4 | 7B 26 | 80 7E | INT 10h AH=00 table: mode set via the hook |
| 0x210F-2111 | 80 FC 0E | E9 E9 5B | INT 10h entry: fast 4F05 BH=0 |
| 0x2C2D-2C35 | 9 bytes | 9 bytes | VGA mode set clear: in place, rep stosw replaced by a jump to wfill |
| 0x2ED5-2EDF | 11 bytes | 11 bytes | text scroll full width: blank fill with wfill |
| 0x2EE4-2EF5 | 18 bytes | 18 bytes | text scroll window: line moves with wmove |
| 0x2EF6-2F06 | 17 bytes | 17 bytes | text scroll window: blank lines with wfill |
| 0x3126-3129 | 33 C0 F3 AA | E8 2F 4E 90 | planar scroll full width: fill with bfill |
| 0x3171-317D | 13 bytes | 13 bytes | planar scroll window: fill lines with bfilla |
| 0x31F5-31F7 | 3B 0E 4A | E9 86 4B | mode 13h scroll AH=06h: 32-bit |
| 0x3513-3515 | F3 AB C3 | E9 AF 24 | AH=09h text: char/attribute with wfill |
| 0x3519-351B | F3 AB C3 | E9 A9 24 | AH=09h text, page > 0: with wfill |
| 0x56DD-56DF | E8 9B CF | E8 A0 27 | VBE 4F02: mode set via the hook |
| 0x56F7-56FC | C7 06 FE 04 00 00 | E8 77 26 90 90 90 | VBE 4F02 end: `b4f02`, the replaced instruction, then the booster unless Windows runs |
| 0x584B-584E | 52 53 8B DA | E9 19 25 90 | VBE window set (4F05 BH=0 slow path, window function): booster on, then the replaced code in `wsetx` |
| 0x59BB-59BF | B8 FF 03 33 D2 | E8 B3 25 EB F8 | VBE 4F06 BL=3: corrected routine, then mov ah,0 / ret |
| 0x59C0-59E2 | old 4F06 BL=3 code (dead after the call) | code | `p13fill.asm`: wfillt 59C0, wfill 59C5 |
| 0x5CCF-5CD2 | 8B C3 0B C0 | E8 6E 22 90 | LFB base read: real base while the booster is on |
| 0x5CED-5CEF | 25 00 10 | E8 CF 1F | 4F05/4F03 linear test ignores the booster window |
| 0x5D01-5D03 | E8 68 B5 | E8 CD 1F | VBE 4F15: interrupts off for the DDC operation (`ddcin`, then GETCRTC) |
| 0x5D54-5D56 | E8 19 BF | E8 7E 1F | VBE 4F15 end: interrupts on again (`ddcout`, then SR0D restore) |
| 0x5E07 | BB | B8 | VBE 4F15 probe: mov ax,0255h, the delay count in AX (2.04.07: mov bx) |
| 0x5F4E-5FBA | old DDC delay | code | `ddcwait.asm`: ddcwait 5F4E, the 2.04.11 delay (5FB4-5FBA: nop) |
| 0x7C8B-7CC7 | 00 | code | `wincheck.asm`: wcheck 7C8B (no booster under Windows enhanced mode), wclear 7CAF, lfbchk 7CBF. 0x7C8A is not free: it is the high byte of the word count at 0x7C89 that the descender glyph load at 0x3FC7 reads |
| 0x7CC8-7CD8 | 00 | code | `p19.asm`: cr2326 7CC8, ddcin 7CD1, ddcout 7CD5 |
| 0x7CFB-7E35 | 00 | code | `p12ext.asm`: int10x 7CFB (the fast 4F05 path turns the booster on), wsetx 7D67, b4f02 7D71, font 7D7A, scr13 7D96 |
| 0x7E40-7E78 | 00 | tables | `crtc240.asm`: crtc8 7E40, crtc16 7E60 |
| 0x7E80-7F50 | 00 | code | `hooks.asm`: hook 7E80, bon 7EF3, basefix 7F40 |
| 0x7F58-7F70 | 00 | code | `p13bfill.asm`: bfill0 7F58, bfill 7F5A |
| 0x7F71-7FAE | 00 | code | `vbe4f06.asm`: bl3 7F71 |
| 0x7FAF-7FB6 | 00 | code | `p13df.asm`: dfdn 7FAF |
| 0x7FC0-7FE2 | 00 | code | `clear32.asm`: clear 7FC0 |
| 0x7FFF | 0B | 8A | Checksum of the lower 32 KB |

### Borrowed ideas

No code was copied from another project; the ROM code was written for this BIOS, except the DDC delay
(`ddcwait.asm`), which reproduces the routine of S3's own BIOS 2.04.11, the same vendor and code base
as the reference 2.04.07 the ROM is built on.

| Item in the ROM | Origin | What was taken |
| --- | --- | --- |
| FIFO fetch fix | [S3VBEFIX](https://github.com/wbcbz7/S3VBEFIX) 0.6.1 by Artem Vasilev (wbcbz7), WTFPL | The diagnosis and the fix: clear CR90 bit 7 when a VGA mode is set |
| Attribute flip-flop reset | S3VBEFIX | The idea: a dummy read of the input status register (3DAh) after the mode set |
| Booster | S3VBEFIX, which credits SVGATRIX.TXT; the 64 KB linear window at A0000h is documented in the Trio64V+ datasheet | The register sequence CR58 AND ECh, CR59=00, CR5A=0Ah, CR58 OR 10h. Saving the real base in CR6D and restoring it in the ROM's own mode set is our design |
| LFB mode set handling | S3VBEFIX | Only the observation that the booster's base must be restored before an LFB mode; implemented differently |
| Refresh and LCD timings | Not from S3REFRSH | The ROM carries the timings itself: VESA DMT 640x480 @ 60 Hz (800x525) and the BIOS's own 640x480 tables halved for 320x240 |
| Memory clock 59.96 MHz | Trio64V2 datasheet | PLL values chosen to meet the 16.67 ns 1-cycle EDO limit |
| DDC fixes, CR23 before CR26 | S3 BIOS 2.04.11 (the card's stock BIOS); Trio64V2 datasheet section 4.2 | The DDC delay routine, the probe's count in AX and interrupts off during 4F15 as in 2.04.11; CR23 = 00h before CR26 on every mode set (2.04.11 does it only after modes above 13h) |

### Not taken from 2.04.11: AX in the 4F0A protected-mode code

The S3 BIOS 2.04.11 (the card's stock BIOS) saves AX in its VBE 4F0A protected-mode functions (set
window, display start, palette) and restores it before the return. 2.04.07, and so this ROM, returns
AX = 004Fh from them, the real-mode status. The ROM keeps that:

- VBE 2.0 section 4.13: "Currently undefined registers may be destroyed with the exception of ESI,
  EBP, DS and SS". AX has no defined output there, so both conform.
- A program that checks AX = 004Fh after the call, as after INT 10h, works only with 004Fh returned;
  with AX kept it gets its own AX back, often 4F05h, because callers load the same registers as for
  the real-mode call. Only a program that relies on AX surviving, which the specification does not
  allow, gains from 2.04.11's change, and none is known.
- Warcraft II switches banks through this code and works with the ROM.

The ELSA Winner 1000/T2D BIOS (ELSA 6.01.00, built on S3's 1.01.04) and S3's 1.01.04 have no reason
to be compared here: 1.01.04 has no 4F0A, and ELSA's own 4F0A reports a wrong table length.

### Kept outside the ROM

| TSR | Fixes | Why not in the ROM |
| --- | --- | --- |
| S3ALIAS.COM (`s3alias/`) | Pinball Illusions' S3 driver: AH=00 mode 49h becomes 59h, 4Bh becomes 5Ah | Remapping S3 mode numbers in the ROM would break programs that use this BIOS's own numbering |

### Omitted: 1-cycle linear addressing (CR87 bit 1, SR15 bit 7)

The Trio64V2 datasheet (section 3.5) describes a faster linear addressing path: CR87 bit 1 = 1
enables 1-cycle linear addressing of video memory, "the memory must be capable of supporting this
mode", and the default with SR0A bit 7 and SR15 bit 7 set is 2-cycle operation. It was tried on top
of the booster in 640x480x8 (101h) with a write benchmark and a 320 KB pattern check:

| SR15 bit 7 | CR87 bit 1 | Write speed | Data errors |
| --- | --- | --- | --- |
| 0 | 0 | 83683 KB/s | 0 |
| 1 | 0 | 83683 KB/s | 65536 |
| any | 1 | hang | - |

There is no speed gain with this card's memory, SR15 bit 7 corrupts data and CR87 bit 1 hangs the
machine, so neither bit is set by the ROM. The Trio64V+ datasheet (SR15 bit 7, "2 CYC MWR") says the
2-MCLK write "can allow 2 MCLK operation for MCLK frequencies between 55 and 57 MHz"; the ROM's MCLK of
59.96 MHz is above that window, which fits the data errors.

### Known remaining items

- The 8x14 font is missing in the BIOS (S3COMPAT WARN 01 for AX=1130h BH=2 and mode 10h).
Solution: [8x14 font support as a TSR](https://www.bttr-software.de/products/fix8x14/). It uses the same font as the S3 Trio64. 
- An LFB is offered on the planar mode 104h (S3COMPAT WARN 20), as in stock and the reference.
- Mode 106h runs at 108 MHz, above the datasheet single-clock limit (S3COMPAT WARN 02).
- S3COMPAT WARN 80 in 012Eh, 010Fh, 0131h and 0134h: End Horizontal Blank is 00h, so CR86 = 00h cannot
  be 1 less (V2-REG-3). The reference sets the same registers in 012Eh and 010Fh; 0131h and 0134h get
  it from the ROM's 320x240 timing (the reference has 2Fh there).
- S3COMPAT WARN 82 in 012Ah (640x480x24): DCLK 75.16 MHz, 3 x 25.05 MHz, above the 75 MHz packed 24
  limit (02), and L1 (CR90/CR91) FFh, 2048 bytes per line where 1920 need EFh (V2-REG-4, 80); both as
  in the reference.
- These five modes show a clean picture on the card (edges and line ends, S3COMPAT and VSHOW /R,
  30 October 2026), so the emulator test `s3compat_full` accepts the five lines. Every graphics mode
  VSHOW /A shows is clean on the card with p18 in plain DOS (30 October 2026).
- The BIOS writes SR04 = 03h in text modes where IBM writes 02h; bit 0 is reserved on the VGA and
  reads back as 0 on the card, so programs see the IBM value.

### To do

- Measure the booster with VIDSPEED in plain DOS: first with the stock BIOS, then with the latest ROM,
  and write both banked results here. VIDSPEED's banked mode (4F02 0113h) gets the booster (VGALOG:
  CR58 90h, CR59/CR5A 000Ah after the call).
- DDC on the card (p19): run S3COMPAT with the Eizo connected; its 4F15 line shows whether the probe
  now finds DDC2. If it still reports caps 0000, the board probably does not connect the serial port
  lines to the VGA connector (pins 12 and 15); Windows 98 showed a generic monitor with the stock
  2.04.11, which has the same DDC code.
- POST delay with the count in BX: at 14E5h the POST code sets CR88 bit 6, then calls the DDC delay
  (5F4Eh) with `mov bx,000Ah`, but the delay takes its count in AX; AX holds the CR88 index and value
  there (4088h with CR88 = 00h before, as on the card: 13.8 ms) instead of 0Ah (8 us). 2.04.11 has the
  same mix-up. Fix it (AX = 000Ah) and test the result on the card.
- Clear video memory with the Trio64V2 graphics engine at VESA mode sets (idea from the Trio3D BIOS,
  which fills video memory with its 2D engine at POST, and the Phoenix Trio64 BIOS 1.4, which clears
  with the engine): could cut the 2 MB clear of about 39 ms to a few ms. Needs most of the free bytes,
  must leave the engine idle and in a clean state for Windows and DOS programs, and the emulator would
  need an engine model to test it.

## Sources

- `docs/chip-rules.md`: every chip rule the tools check, with its ID and datasheet source.
- S3 Trio64V2/DX and GX datasheet (preliminary): MCLK limits per memory type and DCLK limits, the
  DCLK VCO maximum of 340 MHz, the 3-bit DCLK R divider (SR12 bit 7), CR36 memory types, CR87 1-cycle
  linear addressing, CR90/CR91 FIFO, the PCI subsystem ID (section 3.8), SR1A, CR23/CR26, CR32, CR40,
  CR66 and CR86 rules.
- XFree86 / X.Org xf86-video-s3, `s3_Trio64DAC.c`: the DCLK PLL range 170-340 MHz for the
  Trio64V2/DX/GX, which S3COMPAT uses as its WARN limit and the ROM patcher for every refresh entry
- S3 Trio64V+ (86C765) datasheet, from the S3VBEFIX repository: PLL formula and VCO range, CR67 colour
  modes, SR15/SR18 clock doubling, CR31/CR58/CR59-5A linear addressing, CR50, CR51, CR43, CR5D/CR5E.
- [S3VBEFIX](https://github.com/wbcbz7/S3VBEFIX) source and README, plus SVGATRIX.TXT and vbe20.txt.
- VESA BIOS Extension (VBE) 2.0 specification; VESA DMT; VESA CVT 1.1.
- VGATEST by Kent Quirk and Ed McNierney, PC Tech Journal, November 1988 (IBM reference tables).
- VBETest/Lite (SciTech) and X-VESA 1.0.3: test ideas for S3COMPAT and VSHOW.
- [DOS compatibility tests by gona.mactar.hu](https://gona.mactar.hu/DOS_TESTS/): known S3 issues.
- The stock 2.04.11 dump, disassembled to locate the mode set, refresh tables and VBE handlers.
- The S3 reference BIOS 2.04.07, the base of the current ROM, compared with 2.04.11 to find the same
  routines and tables at its addresses, and on 30 October 2026 instruction by instruction: 2.04.11
  fixes the DDC delay and adds CR23 = 00h before CR26 (both in p19), keeps AX in the 4F0A code (not
  taken, see above) and counts planar modes per 256 KB in 4F01 (not taken: 2.04.07's NumberOfImagePages
  is the correct count).
- Compared on 30 October 2026, nothing better to take: the ELSA Winner 1000/T2D BIOS 6.01.00 (S3's
  1.01.04 plus about 3 KB from ELSA: VBE 2.0, LFB, its own mode numbers 212h-218h, 75 Hz defaults, a
  65 MHz MCLK; same S3 DDC code, delays on PIT channel 0; it has S3's 8x14 font, which needs 3.5 KB
  this ROM does not have free), S3's 1.01.04 (VBE 1.2, no LFB) and the S3 Trio3D BIOS 2.0B.07 (the same
  2.0x code base as 2.04.07: its clear, scroll and text routines are 2.04.07's; its new code is
  Trio3D-specific, among it a POST memory test that fills video memory with the Trio3D 2D engine).
- VBE 2.0 specification section 4.13: the registers the 4F0A protected-mode functions may destroy.
- Reviewed on 28 October 2026, nothing new for the 86C775: riplin's annotated disassembly of the
  Phoenix S3 Trio64 BIOS 1.5-07 EDO for the Trio32/Trio64 (86C764x, PCI 5333:8811),
  [hag `research/s3/bios/86c764x.asm`](https://github.com/riplin/hag/blob/main/research/s3/bios/86c764x.asm),
  and the VOGONS thread
  [I disassembled an S3 Trio64 BIOS and am annotating it](https://www.vogons.org/viewtopic.php?t=96638).
  It is another code base than the S3 reference 2.04.07, so no addresses or tables carry over, and it
  has no patches yet (a slowdown fix and more VBE modes are only planned). Its settings (SR0A bit 7
  2-MCLK writes at a 55 MHz MCLK, CR3B = horizontal total - 7, CR54/CR60 for 1 MB) belong to another
  chip and BIOS and are no new evidence for the SR15/CR87 result above. The thread's dual-card
  description (40:87 bit 1 selects MDA or CGA replacement) is standard VGA behaviour, which the ROM
  keeps unchanged from the reference. Licence: hag is MIT (Copyright (c) 2023 riplin), which covers
  riplin's own annotations and code but not the reproduced Phoenix/S3 ROM bytes and tables; VOGONS
  posts carry no licence. Nothing from either was copied.
