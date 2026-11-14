# S3 Trio64 family video BIOS tools

Video BIOSes, DOS test tools and an emulator for the S3 Trio64 family: the Trio64 (86C764X), the
Trio64V+ (86C765) and the Trio64V2/DX (86C775), all PCI 5333h. For each chip the project builds a
patched video BIOS from a reference BIOS (fixes, speed, 60 Hz defaults, an MCLK build option), tests it
in its own emulator and on real cards, and prepares a clean-room BIOS of its own (`docs/clean-room.md`).

Preliminary benchmarks [show about 10% performance improvement](https://github.com/perchrh/trio64-vbios-tools/issues/109#issuecomment-6608972948)

| Chip | ROM | Reference BIOS | Test card(s) | Fixes and improvements | Description |
| --- | --- | --- | --- | --- | --- |
| Trio64 86C764X and 86C764-P | 1.5-07-pN (`make 764x-rom`, `make 764p-rom`) | Phoenix 1.5-07 | ExpertColor DSP-3364P, 2 MB fast page | [docs/764-changes.md](docs/764-changes.md) | [docs/764-rom.md](docs/764-rom.md) |
| Trio64V+ 86C765 | 1.03-08N-pN (`make 765-rom`) | S3 1.03-08N | STB Powergraph 64, Hercules Terminator 64 | [docs/765-changes.md](docs/765-changes.md) | [docs/765-rom.md](docs/765-rom.md) |
| Trio64V2/DX 86C775 and Trio64V2/GX 86C785 | 2.04.07-pN (`make 775-rom`) | S3 2.04.07 | Gainward GW503A, 2 MB EDO 40 ns | [docs/775-changes.md](docs/775-changes.md) | [docs/775-rom.md](docs/775-rom.md) |

Each fix and improvement is listed in the chip's changes document with the GitHub issue that describes
it: what was wrong or missing, the cause, the effect and how it is tested.

Other documents: [docs/chip-rules.md](docs/chip-rules.md) (the data book rules the tools check),
[docs/bios-rules.md](docs/bios-rules.md) (the standard video BIOS behaviour),
[docs/vgalog.md](docs/vgalog.md) (the VGALOG.BIN log formats), and [docs/clean-room.md](docs/clean-room.md)
and [docs/cleanroom/](docs/cleanroom/README.md) (the clean-room BIOS, written from scratch).

A [collection of S3 Trio video bioses](https://archive.org/details/s3-trio-vbioses) is available from archive.org

## Speed

What the three ROMs make faster than their reference BIOSes, on every chip:

- **Banked SVGA modes** ([#47](https://github.com/perchrh/trio64-vbios-tools/issues/47)): the booster, a 64 KB linear window at A0000h behind the banked window, makes
  banked writes as fast as a linear frame buffer. S3TEST's banked write line on the cards: 82.5 MB/s
  on the Trio64V2 (2.04.07-p22), 83.3 MB/s on the Trio64 (1.5-07-p3), 79.9 MB/s on both Trio64V+ cards
  (1.03-08-p1 at a 50 MHz MCLK).
- **32-bit video memory stores** ([#60](https://github.com/perchrh/trio64-vbios-tools/issues/60), [#61](https://github.com/perchrh/trio64-vbios-tools/issues/61), [#62](https://github.com/perchrh/trio64-vbios-tools/issues/62)) in the mode set clears, the font load, the text, planar and mode 13h
  scrolls and AH=09h: half the store operations or fewer (mode set 03h: 9368 writes instead of 20632 on
  the Trio64V2; per-call counts in `docs/765-rom.md`).
- **Fast 4F05 set window** ([#59](https://github.com/perchrh/trio64-vbios-tools/issues/59)) at the INT 10h entry: 6 port writes instead of 10 to 13.
- **Memory clock** ([#58](https://github.com/perchrh/trio64-vbios-tools/issues/58), [#112](https://github.com/perchrh/trio64-vbios-tools/issues/112)): by default 50.11 MHz on every ROM since 2.04.07-p26, 1.03-08N-p6 and
  1.5-07-p6, the clock of S3's own BIOSes for 1-cycle EDO (also of the test card's stock 2.04.11), so the
  default build is no faster there than the reference; a faster clock for the card's memory is a build
  option (`make roms`, "MCLK build option"). p9 to p25 of the Trio64V2 ROM ran 59.96 MHz.

The project's target machines are hosts from an Intel Pentium 75 to an AMD K6-400 (recorded
8 November 2026); performance reasoning and expectations for the ROMs assume that range. The
VIDSPEED run below was measured on an 80486, a slower host than the target range, so its absolute
numbers are conservative for it.

VIDSPEED in plain DOS on the Trio64V2 card (80486, 31 October 2026), once with the card's stock BIOS
2.04.11 and once with 2.04.07-p21. p22 changed only the DDC delay and where the booster keeps
the saved base, nothing these numbers measure. The values are bytes per millisecond written with 32-bit stores
(VIDSPEED's third line per mode), then read; the system RAM lines of both runs are equal, so the
machine was the same.

| Mode | Stock write | p21 write | Factor | Stock read | p21 read |
| --- | --- | --- | --- | --- | --- |
| 640x400x256 | 23135 | 87360 | 3.8 | 2585 | 7267 |
| 640x480x256 | 23103 | 87360 | 3.8 | 2585 | 7257 |
| 800x600x256 | 22514 | 86907 | 3.9 | 2467 | 7119 |
| 1024x768x256 | 21178 | 86016 | 4.1 | 2385 | 6832 |
| 1280x1024x256 | 20580 | 82626 | 4.0 | 2340 | 6717 |
| 640x480x16bit | 22011 | 87360 | 4.0 | 2420 | 7035 |
| 1024x768x16bit | 17805 | 81029 | 4.6 | 2285 | 6709 |
| 800x600x24bit | 16541 | 76241 | 4.6 | 2226 | 6725 |
| 320x200x256 (mode 13h) | 44043 | 53718 | 1.22 | 4476 | 4476 |
| 640x480x16 (mode 12h) | 21991 | 26932 | 1.22 | 2580 | 2597 |
| 80x25 text | 39384 | 51200 | 1.30 | 4096 | 4413 |

- **Banked SVGA modes (the booster):** writes 3.8 to 4.6 times faster, reads 2.8 to 3 times. All of
  them reach 76-87 MB/s, as fast as the linear frame buffer; S3TEST's banked throughput line measures
  83 MB/s. With the stock BIOS the deeper modes were slower than the 8 bpp ones; with the booster they
  are about equal. 16-bit stores gain 15-60 % (the booster takes them too); 8-bit stores stay at about
  10 MB/s, the bus limit.
- **VGA and text modes (no booster):** about 22 % more in mode 13h and the 16-colour modes, 30-35 % in
  text: the memory clock of p21, 59.96 MHz instead of 50.11 MHz (20 % more). Since p26 the default build
  runs 50.11 MHz again; `make 775-rom MCLK=60` gives the clock of this run.
- Other observations of the same run (refresh lines, the booster state per mode): `docs/775-rom.md`,
  "The VIDSPEED run".

VIDSPEED for the Trio64 and Trio64V+ ROMs against their cards' stock BIOSes is still to be run.

## Chip codes

Make targets, file names, the emulator's `--chip` and the build variables name the chips by their S3 part
number; the documentation also uses the market names.

| Code | Market name | S3 part | PCI ID | Make targets | `--chip`, `CHIP=` | Version, reference, size variables |
| --- | --- | --- | --- | --- | --- | --- |
| 785 | Trio64V2/GX | 86C785 | 5333:8901 | `775-rom` (the same ROM: S3's 2.04.07 is the "86C775/86C785 Video BIOS"; the clock option has an `sgram` entry for the GX) | `775` | as 775 |
| 775 | Trio64V2/DX | 86C775 | 5333:8901 | `775-rom`, `775-rom-test`, `775-ref-compare` | `775` | `VER775`, `REF775`, `SIZE775` |
| 765 | Trio64V+ | 86C765 | 5333:8811 (revision 4xh or 5xh, bit 6 set) | `765-rom`, `765-rom-test`, `765-ref-compare` | `765` | `VER765`, `REF765`, `SIZE765` |
| 764X | Trio64 PnP (MCLK 50-70 MHz) | 86C764X | 5333:8811 (CR2F 20h, 30h, 03h or 12h) | `764x-rom`, `764-rom-test`, `764-ref-compare` | `764x` (or `764`) | `VER764`, `REF764`, `SIZE764` |
| 764P | Trio64 (MCLK 50-60 MHz) | 86C764-P | 5333:8811 (another CR2F) | `764p-rom` (tests as 764X) | `764p` (or `764`) | as 764X |
| 767 | Trio64UV+ | 86C767 | 5333:8814 | none (no ROM of ours) | `767` | |
| 732 | Trio32 | 86C732 | 5333:8811 (CR2E 10h) | none (no ROM of ours) | `732` | |

The PCI revision (00h) does not tell the 764X from the 764P, but CR2F does: S3's Windows 95 driver
2.41.07 names the 764X parts by their maker (20h GS, 30h NEC, 03h UMC, 12h TSMC, "86C764..pnp") and
any other value the plain 86C764 ([docs/764-rom.md](docs/764-rom.md) "Chip variants by CR2F"). The
tools follow it (`chippart` in `src/tools/common/chip.inc`, T64-ID-2): the S3 part on the Chip ID lines of
S3TEST and S3COMPAT, `CHIPID /Q` and the REPORT archive name is 86C764X for those four codes and
86C764-P for any other (`runall-86c764-p.zip`), and S3TEST's INFO line "Chip variant by CR2F" names the
maker. The DSP-3364P reads 20h, a GS part as its marking says. The emulator's `764x` (and `764`) model
reports CR2F 20h, its `764p` model 00h; the PCI revision is 00h on both.

The emulator's test tags follow the codes too: `765` and `764` mark the tests that run on our Trio64V+ and
Trio64 ROMs (`765_patches`, `764_patches`), and `775_writes` is the Trio64V2-only test.

The three ROMs share the patcher library (`src/roms/s3patch.py`), the version file
(`src/tools/common/version.inc`), the tools and the emulator.

The patched ROM images are not in this repository: `src/roms/` holds the changes to the reference
BIOSes and the patchers that build the images from them. 

All tools need a 386 or later and run in plain DOS (no EMM386 needed), except S3REGS32.EXE, which
is for the Windows 9x desktop.

| Tool | Purpose | Run |
| --- | --- | --- |
| VBESHOW.COM | VESA mode viewer: test picture, measured refresh and line frequency, LCD line pattern, interactive menu, run through all modes. `/O CR54=1F` (repeatable, up to 8) overrides a register (SR/CR/GR/AR with a 1-2 digit hex index and value) after each mode set, before the picture and the measurement, with the S3 locks (SR08, CR38, CR39) opened for the write and put back; the override line prints once at the start. The bench toggles of [#200](https://github.com/perchrh/trio64-vbios-tools/issues/200) (CR43 bit 7, CR67 bit 0, CR54 the FIFO threshold M, the HSYNC offset, AR13 pixel panning) become one-boot A/B runs with the measured refresh and the picture as the readout | `VBESHOW /H` for the parameter list |
| VGASHOW.COM | Standard-mode viewer (MDA/CGA/EGA/VGA modes 00h-13h, set with AH=00h): list, one mode, or all in turn (/A, /R); test pattern per mode (checker in text modes, 16 bars in graphics modes) with measured refresh and line frequency; the CRTC and status ports come from MISC bit 0, so the mono modes are measured at 3B4h/3BAh (#193). All standard modes are at most 31.5 kHz and 70 Hz | `VGASHOW /H` for the parameter list |
| S3TEST.COM | Regression test for the ROM patches (signature, chip and its CR2F variant, clocks, memory type, pedestal, refresh and line length, booster, LFB, 4F05/4F06, CR50, flip-flop, VGA clear, font load, scrolls in modes 13h, text and planar, AH=09h, timings); the test set follows the chip from PCI (`src/tools/common/chip.inc`: device id and, on 8811h, revision bit 6, then CR2E; on 8901h, CR6F bit 0 for Trio64V2/DX vs /GX), and the Chip ID INFO line prints the S3 part number (86C732, 86C764X or 86C764-P by CR2F, 86C765, 86C775, 86C785, 86C767); our Trio64V2, Trio64V+ or Trio64 ROM, or on the Trio32 only the tests that need no ROM of ours | `S3TEST > S3TEST.LOG` |
| CHIPID.COM | Prints the chip identification alone (CR2D-CR30, CR6F, PCI device/rev, market name, S3 part), using the same `src/tools/common/chip.inc` routines as S3TEST; also names Trio3D (8904h, 86C365) and Trio3D/2X (8A13h, 86C362/86C368); `/Q` (`-q`) prints only the S3 part (86C775, ...); `/Z` (`-z`) renames `runall.zip` to `runall-<part>.zip` from `chipid.out` when the DOS can rename to a long name. Windows 98 DOS can create a long name and cannot rename an existing file to one, so `/Z` changes nothing there; RUNALL uses REPORT | `CHIPID`, `CHIPID /Q` |
| ROMVER.COM | Prints the video ROM version S3TEST's signature line reads, using the same scan (`src/tools/common/romver.inc`): "Version " in C000:0000-00FF, then at most 12 characters. `/Q` (`-q`) prints only that version | `ROMVER`, `ROMVER /Q` |
| MCLK.COM | Shows, sets or tests the memory clock. Without a switch it only reports, and changes nothing: the chip, the amount and type of video memory, the memory clock the BIOS programmed, and the range the datasheet gives for the chip, from the lowest PLL pair at or above 50 MHz (SR10=41h SR11=28h, 50.114 MHz; 50 MHz is the EDO clock of the Trio64V+ feature list, the data books give no minimum) to the datasheet maximum (MEM-1, V2-MEM-1; 60 MHz for the Trio64, not the 70 MHz board policy). `/S 57.5` sets the PLL pair at or below the request and leaves it, without a memory test, until the BIOS sets its own clock at the next boot; it refuses a request below the lowest pair or above the cap (the datasheet maximum plus 25 percent), and above the datasheet maximum it asks for Y first. It reads SR10/SR11 back and ends with one result line: "Memory clock set to 57.272 MHz (requested 57.500 MHz, SR10=41 SR11=2E read back): OK" (exit 0), or a line starting "ERROR:" that says why the clock was not changed (exit 1; after a wrong read-back the clock found at the start is put back). `/T` tests steps of 0.5 MHz from the lowest pair up to the cap, `/T /P` finer steps (the next PLL pair at least 0.1 MHz higher), `/T /I 52.5` starts higher; it always asks for Y once before the first clock change (on stderr, with the range it will program), and any other key ends the run without touching the PLL (exit 1). The "Recommended max" line names a clock the run tested and passed, at least 1 percent below the highest that passed (the highest such step), followed by the `/S` command that sets it, or "none" when no tested step is that low (run again with a lower `/I`). After `/T` the clock found at the start is restored. `/Y` answers yes to the question of `/S` and `/T` without reading a key, for a batch file (the log says "Confirmed: /Y given"; `/Y` alone is a bad argument). Not part of RUNALL. `/A 0|1` (with /S or /T) also sets or clears SRA bit 7, the 2-MCLK write cycles (spec-a Q5 of [#200](https://github.com/perchrh/trio64-vbios-tools/issues/200)): with /S the bit is left set for what follows (the S3COMPAT VRAM test at that clock), with /T finish puts it back as found. `/D ms` (with /S or /T) replaces the default two-tick wait after each PLL load with a PIT-channel-2 wait of the given milliseconds (0 = none, at most 3000), so a sweep per delay answers how long the memory takes to become reliable after an MCLK load (spec-a Q6) | `MCLK`, `MCLK /S 57.5`, `MCLK /S 70 /Y`, `MCLK /T`, `MCLK /T /Y`, `MCLK /T /P`, `MCLK /T /I 52.5`, `MCLK /S 59.96 /A 1`, `MCLK /T /D 5` |
| REPORT.COM | Packs the RUNALL logs into one ZIP by calling ZIP.EXE (Info-ZIP zip 2.32, 16-bit, shipped as `src/tools/report/ZIP.EXE`, license `ZIP-LICENSE.txt`; deflate, method 8, which Info-ZIP's unzip reads; ZIP.EXE needs about 455 KB free DOS memory, so REPORT shrinks its own block to its 64 KB first) and creates it as `runall-<part>.zip` (a slash in the part becomes a hyphen). If that create is refused, the name is `<part>.ZIP` (86C775.ZIP; 86C764-P gives 86C764.ZIP). No part: `RUNALL.ZIP` | `REPORT` |
| S3ALIAS.COM | TSR for Pinball Illusions' S3 driver: INT 10h AH=00 mode 49h becomes 59h (640x480x8), 4Bh becomes 5Ah (800x600x8) | `S3ALIAS` before starting the game, `S3ALIAS /U` to unload, `/H` for help; not with S3TEST or S3COMPAT |
| VGALOG.COM | TSR that logs every INT 10h AH=00 mode set and VBE 4F01/4F02/4F06 call of any program to VGALOG.BIN, committed before and after each call, so it survives a freeze. `/M` keeps the last 1024 INT 10h calls of any kind (not text output) in memory instead, for Windows 9x (`/XL` with it: a 128 KB ring, the last 4096 calls, about 130 KB of memory); the text and pixel calls it skips (AH=02h, 03h, 08h, 09h, 0Ah, 0Ch, 0Dh, 0Eh, 13h) are counted, and `/D` appends the nine counts as a `VGALOGC1` part at the end of VGALOG.BIN; `/D` writes them (with none yet it writes no file and says "No events registered, not writing output file"); it commits the file and flushes the DOS buffers and a SMARTDRV write-behind cache (AH=68h, AH=0Dh) before it says the file is written, so the machine may be reset right after it ([#158](https://github.com/perchrh/trio64-vbios-tools/issues/158)). `/T` is `/M` with a port trace: during each mode set (AH=00h, 4F02h) it single-steps the BIOS and keeps every VGA, PCI configuration and S3 engine port access with its value, in program order, the last 16384 in a second 64 KB ring (about 100 KB resident; a traced mode set runs slower), so a card run shows what the ROM programs and in which order. `/P` is `/T` that also traces the program itself after each of its 4F02h calls (its port accesses, with those of the BIOS calls it makes), until 12288 new events, its next mode set or an instruction that would switch to protected mode; it shows how a program changes the bank or programs the DAC and CRTC through the ports, and the program runs much slower until the trace ends by itself. `/W` is `/M` with a window function hook: the WinFuncPtr a 4F01h call returns points to VGALOG, which logs the program's far calls through it (the first 64 as records, all counted) and jumps on to the BIOS's routine, so a log shows whether a program changes the bank with the window function, with INT 10h 4F05h or with its own port writes. Every VGALOG.BIN starts with the chip (CR2D-CR30), CR36, the MCLK the POST set and the ROM's version word, read at install, so logs of different cards and ROMs can be told apart | `VGALOG` (or `VGALOG /M`, `VGALOG /T`, `VGALOG /P`, `VGALOG /W`), then start the program; `VGALOG /D` to write the memory log, `VGALOG /U` to unload, `/H` for help; record formats in [docs/vgalog.md](docs/vgalog.md) and `src/tools/vgalog/vgalog.asm` |
| S3REGS.COM | Register snapshot (SR, CR, GR, PCI, BIOS and VBE mode) appended to S3REGS.TXT, with a label; changes nothing | `S3REGS label` |
| S3REGS32.EXE | The same snapshot from the Windows 9x desktop (Win32 console program), and `/W n` logs every register change for n seconds | `S3REGS32 label`, `S3REGS32 /W 60 label` |
| S3COMPAT.COM | VGA/SVGA/VESA compatibility test: IBM reference registers and palettes, 350-line text modes, VGA BIOS functions (also AH=13h, CGA scroll, graphics XOR, fonts, the video save pointer table), every VESA mode, the VBE functions (also 4F04 masks, 4F0A, 4F10, 4F14, 4F15), datasheet rules, VRAM. After the VESA functions the bench observations of [#200](https://github.com/perchrh/trio64-vbios-tools/issues/200): the 4F07 display start near the end of memory (spec-c 11) and the planar 102h pages past 256 KB/plane (spec-c 4) always run; `/U` adds the SR18 bit 6 palette load stress (spec-a Q7), `/N s` the retention check (spec-b MQ-5: pattern written, s seconds waited, verified), `/B` sets CR31 bit 2 (the 16-bit VGA bus, spec-b MQ-8) for the whole run, restored by cleanup | `S3COMPAT > S3COMPAT.LOG` (`/Q` skips the VRAM test; VBESHOW shows single modes) |

Each source file starts with a header that says what is tested and which outcome is expected, and
each test routine has a comment block with its fail and warn bits. S3TEST and S3COMPAT end their log
with `Time spent: x.y s`, the run time measured with the BIOS tick. S3TEST's VBE 4F05 line checks the
3C4h sequencer index (fail bit 2) and the SR08 lock key after the bank switch (fail bit 20h) separately
([#237](https://github.com/perchrh/trio64-vbios-tools/issues/237); bit 20h compares bits 3-0 only, the
lock key - SR8 bits 7-4 are reserved, "x = don't care", Trio32/Trio64 data book 14.2 SR8 page 14-9, and
on the 86C764X card they do not read back as written: 06h written, 46h read), and with `/V` logs the
raw values around the call as a `D:4F05` record, so a card run names the register that moved.

Monitor: VBESHOW and S3TEST set modes up to a 75 kHz line frequency (1600x1200 at 60 Hz), S3COMPAT up
to 91 kHz (1280x1024 at 85 Hz in its 4F14 refresh test). An LCD refuses a signal it cannot show (out
of range) and takes no harm; an old fixed-frequency or low-end CRT can be damaged by a line frequency
above its range, so do not run these tools with one. The `/H` help of each tool says so, and
`VBESHOW /I` shows it once on the screen before the mode list.

All tools share one version number, and S3TEST checks for one ROM level per chip; all are set in
`src/tools/common/version.inc` (`VERSION`; `VER775`, `VER765`, `VER764`) and can be overridden for a build, for
example `make clean && make VERSION=0.9 VER775=2.04.07-p18`.

## Building

NASM 3.02 (the ROM build needs exactly 3.02, see docs/775-rom.md, "The build"):

    make            # tools and every chip's ROM (make tools && make roms)
    make tools      # the DOS tools into build/ (including CHIPID.COM, ROMVER.COM, REPORT.COM, MCLK.COM and ZIP.EXE)
    make roms       # every chip's ROM at its memory clocks into build/roms/
    make clean      # removes build/ (tools and ROM images)
    build.bat       # DOS or Windows with nasm.exe on the PATH (tools only)
    make dist       # the release zip, build/trio64-tools-<VERSION>.zip ("Release zip")

A NASM that is not on the PATH is given with `NASM`, for example a copy in the working tree (the
folder `nasm/` is ignored by git):

    make NASM=nasm/nasm-3.02/nasm
    set NASM=nasm\nasm-3.02\nasm.exe & build.bat
    make 775-rom OUT=S3V2P24.BIN NASM=nasm/nasm-3.02/nasm
    make emu-test ROM=S3V2P24.BIN NASM=nasm/nasm-3.02/nasm

Every target uses it: the tools, the ROM build (`775-rom`, `775-rom-test`) and the emulator tests, which
assemble code themselves too (`emu/tests.py --nasm`, `emu/mutants.py --nasm`; both also read the
environment variable `NASM`). A relative path is made absolute. `make` warns when the assembler is
not NASM 3.02.

The .COM files land in `build/`, with `RUNALL.BAT` (from `runall.bat`): it loads VGALOG in memory
mode (`VGALOG /M /XL`: a 128 KB ring, the last 4096 INT 10h calls), takes an S3REGS snapshot ("before
tests"), then runs each test tool (S3TEST, S3COMPAT, `VBESHOW /R`) with `/V /S`: another S3REGS snapshot
first ("before S3TEST" and so on; S3REGS appends to S3REGS.TXT), then the tool, then `VGALOG /D` with the
dump renamed to VGALOG0.BIN, VGALOG1.BIN, ... (one per tool run; `VGALOG /U` and `/M /XL` between the tools
start a fresh session, so each file's call counter covers only that tool and holds its last 4096 INT 10h
calls). RUNALL.BAT deletes S3REGS.TXT at its start and each VGALOGN.BIN before the rename, so a run packs
only its own files even when CLEAN.BAT was not run first (#240). At the end a second snapshot ("after tests") and
`VGALOG /D` write VGALOG.BIN, and it beeps (`echo` of Ctrl-G) when done. It leaves the .LOG and .DBG files,
S3REGS.TXT, VGALOG.BIN and the VGALOG0.BIN... dumps next to them. It then copies the run's own
S3REGS.TXT (not the one AUTOEXEC.BAT and Windows runs leave in the root) as S3REGS3.TXT, and runs REPORT.
REPORT writes one deflate ZIP (method 8, RFC 1951; Info-ZIP's unzip reads
it) of the logs, the .DBG files, S3REGS.TXT, S3REGS3.TXT and every VGALOG*.BIN (VGALOG.BIN and the per-tool
VGALOG0.BIN... dumps), but not itself: it enumerates the files and calls ZIP.EXE
(`ZIP.EXE -q <archive> <names...>`, in as many execs as the 126-byte command tail holds, since
ZIP.EXE updates the archive it finds), waiting for each with INT 21h AH=4Dh. ZIP.EXE is Info-ZIP's
16-bit zip 2.32 (`src/tools/report/ZIP.EXE`), which runs on any 8086+ but wants about 455 KB of
contiguous free DOS memory, so REPORT first shrinks its own block (AH=4Ah) to its 64 KB - the
stack at PSP:FFFEh must stay inside the block, because DOS saves the return from the exec on the
caller's stack, where the child's memory block must not reach. A file that
is missing is a warning on stderr and is left out. The archive is created under the part name, not
renamed into it: Windows 98 DOS can create a long name and cannot rename an existing file to one, which
is why `CHIPID /Z` leaves `runall.zip` in place. The name is `runall-<part>.zip` (for example
`runall-86c775.zip`; a slash in the part becomes a hyphen). If the DOS refuses the long-name create,
the 8.3 name is `<part>.ZIP` (for example `86C775.ZIP`). With no part, the name stays RUNALL.ZIP.
After the new archive is written, REPORT deletes a leftover `runall.zip` and the other form of this
part's name. VGALOG stays resident afterwards (`VGALOG /U`
unloads it); while it is loaded, every INT 10h call takes a little longer, which shows only in the timing
lines (INFO). `CLEAN.BAT` (from `clean.bat`) deletes what a run leaves behind before the next one, in the
current folder: the .DBG files, the four .LOG files, S3REGS.TXT, S3REGS3.TXT, CHIPID.OUT, every VGALOG*.BIN
(VGALOG.BIN and the VGALOG0.BIN... dumps) and the ZIP archive the run leaves (`<part>.ZIP` such as
`86C765.ZIP`, `runall-<part>.zip` when the DOS takes the long name, `RUNALL.ZIP` with no part, and any copy
renamed by hand, such as `86c765-hercules.zip`). Run each card's RUNALL in its own folder: on the shared
disk, two runalls writing the same names at once cross the FAT chains, and the files then start mid-line
with another run's content (the 11 November 2026 `86c765-hercules.zip` bundle). `/S` skips the monitor
warnings, so only
start it with a monitor that takes 91 kHz or refuses it (an LCD). `src/tools/common/` holds the /V
debug log code the test tools share.

RUNALL.BAT works the same on a card with its stock BIOS, and the logs then describe that BIOS and card:
S3TEST fails its ROM signature (the line shows the version found) and the tests of our changes where
the stock BIOS lacks them (the refresh rates and the register values are in the FAIL lines), while the
MCLK, memory type, chip ID, timings, S3COMPAT, VBESHOW, S3REGS and VGALOG results are as useful as on our
ROM. `S3TEST /C` runs only the tests that apply to any ROM, for a short pass/fail answer.
In the emulator, `make stock-test` does the same with the three stock reference ROMs (below).

## Emulator tests

`emu/` runs the video BIOS and the DOS tools in an emulated PC, so changes can be checked before a
hardware run. The tests need python3 and the unicorn package from PyPI (listed in `pyproject.toml`),
NASM, and the 64 KB ROM image of the card, which is not in this repository:

    python3 -m venv .venv
    .venv/bin/pip install .
    make emu-test ROM=path/to/S3V2P24.BIN

`make emu-test` runs every test with 2 MB and then again, with 4 MB, the seven whose result depends on
the memory size (tag `vram`: rom_patches, s3test, vbeshow, s3compat_vbe, s3compat_full, errors, windows;
the others give the same output with both sizes); on the Trio64 (`CHIP=764`, `764x`, `764p`) and the
Trio32 it leaves the 4 MB run out and tests 2 and 1 MB only. `make emu-test ROM=... VRAM=4` runs every test with 4 MB (the CR36 strapping of a 4 MB card; the
86C775 supports 2 and 4 MB): the BIOS then lists the modes up to 4 MB (1280x1024x15/16, 1152x864x32,
1024x768x32) and the tests expect what follows from 4 MB (4F06 BL=3 maximum line 8184, the modes 4F01
marks supported). With 4 MB S3COMPAT gives WARN 02 for 1024x768x32, 1152x864x32 and 1280x1024x15/16:
their default pixel clock is above the datasheet maximum for the depth, as in the reference BIOS.

The tests are independent: `make emu-test` runs as many at a time as the machine has CPUs, each in
its own process, the long ones (the full S3COMPAT, VBESHOW /R, the S3COMPAT VBE part) first; `JOBS=1`
runs them one after the other, `python3 emu/tests.py -j N` sets the number. The full S3COMPAT run
(about 8 minutes) is the lower limit of the total time.

`make emu-test` uses `.venv` when it exists, otherwise `python3`; `pip install unicorn` into any
environment works as well. ROM images (`*.bin`, `*.BIN`) are ignored by git, so the image can sit in
the working copy without being committed.

Every ROM and every emulator test in one go:

    make test-all NASM=nasm/nasm-3.02/nasm [CLOCKS_775=60] [CLOCKS_765=...] [CLOCKS_764X=...] [CLOCKS_764P=...]

`make test-all` builds every chip's ROM at its memory clocks (`make roms`, "MCLK build option") and runs
`make emu-test` on each image with the chip model of its folder (775, 765, 764x, 764p) and the memory
sizes emu-test uses for that chip. The logs go to `emu/all/<image>` (for example `emu/all/775M60`, with
`emu/all/775M604` for 4 MB and `emu/all/775M601` for 1 MB). A failing image does not stop the others; the
last line names every image that failed, and make then fails. The `CLOCKS_*` variables choose the images,
as for `make roms`; with the defaults that is twelve images, each at least as long as one `make emu-test`.

The patches are checked by S3TEST, which the `s3test` emulator test runs
and which also runs on the card: run against the stock image it fails 25 lines (signature, MCLK,
pedestal, 60 Hz defaults, refresh and line length of the patched timings, booster and LFB base,
4F01/4F03/4F06, CR50, flip-flop). `rom_patches` adds only what S3TEST cannot check: the sign-on and
the checksums of both 32 KB halves in the file, and the FIFO fix with CR90 bit 7 set the way the card
leaves it after a VESA mode (the model does not set it; since p25 mode 03h must leave the bit, mode 13h
must clear it, [#166](https://github.com/perchrh/trio64-vbios-tools/issues/166)). The other tests check the BIOS registers, state blocks and
default palettes of every VGA mode against the IBM reference, that S3TEST, VBESHOW and the VGA part of
S3COMPAT run and give the same output with and without /V, the /V debug file format, and VGALOG and
S3ALIAS install and unload. The tools run with /V; their output and debug files are kept in
`emu/logs/` (S3TEST.LOG, S3TEST.DBG, ...). The emulator models the VGA and S3 registers, the card's
1, 2 or 4 MB of video memory behind the banked A0000 window (CR6A, or CR35/CR51 with CR31 bit 0;
packed bytes or the four interleaved planes), and a virtual clock that drives the timer, the BIOS
tick and the retrace bit from the programmed timing (see `emu/vgaemu.py`), so refresh rates, banked
and planar memory tests mean something there. It has no linear frame buffer at the CR59/CR5A base
(INT 15h AH=87h reports "not supported") and no real bus speed: the LFB lines, the banked write
throughput and the monitor stay with the hardware logs, which decide. `emu/cover.py` lists the ROM
bytes that a broad INT 10h workload never touches.

`s3compat_full` runs the whole S3COMPAT on the model; only the lines that need the LFB (INT 15h
AH=87h) are left to the card. In the model, read mode 1 (colour compare), the GR03 rotate and logic
functions, the DAC state register and the PIC are modelled too, so the VGA BIOS function tests of
S3COMPAT all run there.

### Chip models and stock BIOSes

`--chip` (`775`, `765`, `767`, `764`, `764x`, `764p`, `732`; "Chip codes") makes the model that chip: its PCI device ID and
revision, CR2D-CR2F (on the Trio64 CR2F 20h for `764x` and `764`, 00h for `764p`, T64-ID-2), the PCI subsystem ID (Trio64V2 only) and the width of the PLL post divider R (3
bits on the Trio64V2 only) and the memory type strapped in CR36 bits 3-2 (EDO, 10b, on the Trio64
and Trio32, fast page on the Trio64 with 4 MB; `--vram 4` is refused for the Trio32, whose maximum is
2 MB, and on the Trio64 it is a run by hand only: no 4 MB Trio64 card was built, so `make emu-test` and
CI stop at 2 MB there). The Trio64UV+ (86C767, device 8814h) is found by the tools too; it shares
system memory (UMA), which neither the tools nor the model know about, so only its register rules are
judged. The tools find the chip themselves (`src/tools/common/chip.inc`) and judge the clocks by that chip's datasheet limits.
With a ROM that is not our patched BIOS (no `2.04.07-pN` sign-on) the tests tagged `patch` (version,
rom_patches, stores, s3test, s3alias) are skipped, and the others take their expected values from the
standards or from the registers the BIOS set, not from our BIOS:

    python3 emu/tests.py --rom TRIO64VP.BIN --chip 765

Our Trio64V+ ROM (`1.03-08N-pN` sign-on, section "Trio64V+ ROM") is in between: of the `patch` tests it
runs those also tagged `765` (version, stores, s3test, and `765_patches` for its own patches), and
the failures it keeps from 1.03-08 (below) pass with a note (`VPLUS_BASE` in `emu/tests.py`). Our
Trio64 ROM (`1.5-07-pN`, section "Trio64 ROM") likewise with the tag `764`, `764_patches` and
`T64_BASE`.

S3TEST picks its test set by the chip it finds (`src/tools/common/chip.inc`), before the first test. On a
Trio64V2 it checks our 2.04.07 ROM (VER775), on a Trio64V+ our 1.03-08 ROM (VER765: the booster
without the CR6D base, no pedestal, refresh default, LFB, 4F06 BL=3 or 512x384 lines, its own mode
list), on a Trio64 our Phoenix 1.5-07 ROM (VER764: as on the Trio64V+, with its own mode list), and
on any other chip (the Trio32), where there is no ROM of ours, only the tests that need none (checksum,
chip, MCLK against the data book, memory type, VGA clear, font load, scrolls, AH=09h, timings); the
version found is then INFO. The MCLK line compares the clock with the maximum for the chip (the data
book's; on the Trio64 70 MHz, T64-MEM-7)
and the strapped memory type, so a ROM built with another MCLK passes as long as it is within it.

S3COMPAT follows the BIOS too: on a VBE 1.x BIOS the VBE 2.0 functions (4F06 BL=2/3, 4F07 BL=80h,
4F09, 4F0A) are INFO "not in VBE 1.x", a BIOS without the S3 OEM functions 4F14h gets INFO, and on a
chip other than the Trio64V2 a missing standard VESA mode and the S3 mode number table of the 2.04
BIOS are INFO. A default refresh other than the VESA 60 Hz rate is WARN 40 (a choice of the BIOS, not
an error), an interlaced mode is judged by its frame (twice the lines of a field) and not held to the
56-90 Hz range.

Chip rules: S3COMPAT judges the registers the BIOS programs by the datasheet rules of the chip it
found; `docs/chip-rules.md` lists every rule with its ID, chips, source and the result bit that checks
it. On the Trio64V2 a DCLK VCO outside 135-340 MHz (the datasheet range; the books word 135-270 MHz as
"should", and the V2 book raises only the DCLK PLL maximum to 340 MHz and states no minimum, V2-PLL-1/2)
is FAIL 200. The Trio64V2 POST part also
checks SR1A bit 4 and the PCI subsystem ID handover (ROM C000:0040-0043 to CR81-CR84, CR37 bit 2
cleared), and its VESA lines CR32 bit 3 (FAIL 1000) and the CR86 and CR90/CR91 rules (WARN 80; on this
ROM 012Eh, 010Fh, 0131h, 0134h and 012Ah, see docs/775-rom.md, "Known remaining items"). The emulator test `775_writes`
(tag `s3 emu`, Trio64V2 model only) checks the rules that concern writes: CR26 = 00h after CR39 = A5h
on every mode set, and CR40 bit 0 and CR66 bit 0 changed only with the screen off or in vertical retrace.

On every chip S3COMPAT also checks the MCLK against the chip's maximum (60 MHz on the Trio32 and
Trio64V+, 70 MHz on the Trio64, 66.67 MHz on the Trio64UV+), PLL M and N of at least 1, packed 24 bpp by either encoding
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
the IBM BIOS of that adapter; `vbe`: VESA; `s3`: the chip and its datasheet; `775-rom`: the image itself),
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

S3COMPAT's DAC checks (the default DAC of every VGA mode, fail bit 20, and AX=101Bh, fail bit 1)
confirm a wrong entry before they fail: they read the DAC a second time, then make the BIOS call
again (the mode set, or mode 13h and AX=101Bh) and read it a third time. A FAIL means the value was
wrong all three times, so the BIOS loaded it wrong twice. Wrong once is WARN 02 (right on the second
read: a port read glitch) or WARN 04 (right after the call again: a DAC write that did not land), as
the rule "a FAIL must mean the BIOS is wrong" asks. Why: the 86C775 card with 2.04.07-p25 failed
`AX=101B grey summing vs IBM` with `DAC#39=27(25)` and `Mode 13h after 0120` at entry 68h in one run,
values the BIOS code cannot produce (its grey of entry 39h is 25h, and pass 1 matched the whole
mode 13h table), and the Trio64V+ card had the same one-byte miss at entry 7Eh once
([docs/765-rom.md](docs/765-rom.md)). The line prints the first read's entry, its value and the
expected one (`DAC#39=27,25,25 exp 25,25,25`) and the outcome (`ok on 2nd read`, `ok after the call
again`, `again same` or the third read's wrong entry); /V adds a `D:DAC` record per read. Repeated
WARN 02 or 04 points at DAC port timing on that machine, not at the BIOS.

A test or step that the chip, its ROM, the memory size or an option leaves out is not silent: S3TEST
and S3COMPAT print it with its name, `SKIP:` and the reason, and count these lines in the summary
(`Skipped: N`). They are not results, so the PASS/FAIL counts and the summary by category leave them
out. Examples: on the Trio64V2 with our ROM S3TEST skips nothing, and S3COMPAT names the 8x14 glyph
checks (no 8x14 font in 2.04.07) and the Trio64UV+ register rules; on a Trio64V+ or Trio64 S3TEST
names the Trio64V2-only lines (pedestal, refresh defaults, the VBE 2.0 lines) and, on a 1 MB card,
the modes above 1 MB; on a chip without a ROM of ours, everything that needs one. VBESHOW /A and /R name
a mode that needs more memory than the card has with both sizes. The emulator tests check that the
summary counts the SKIP lines.

### Test coverage

    pip install .[coverage]          (capstone, for emu/codemap.py)
    make coverage ROM=path/to/S3V2P24.BIN

runs every emulator test while recording which ROM bytes execute, then `emu/codemap.py` finds the
code of the lower 32 KB by recursive descent from the POST entry, every executed block and every
direct jump, call and word jump table, and reports the share the tests executed. Data (tables,
fonts, strings, padding) and code nothing reaches (the routines our patches jump around) do not
count. `--list` gives the code ranges no test runs. The goal is at least 80 %; 2.04.07-p21 is at
86.6 % (15135 of 17487 bytes). The parts still not run include the display switch (AH=12h BL=35h),
the mono/colour adapter switch in the mode set, MDA (3B4h) paths and error paths. The Trio64V+ ROM 1.03-08-p1
(`make coverage ROM=S3VPP3.BIN CHIP=765`) is at 87.1 % (13200 of 15163 bytes), its new code all run. The Trio64 ROM
(`CHIP=764`) was at 85.2 % (13341 of 15650 bytes) at 1.5-07-p1, its new code all run; the FIFO code
of p2 and p3 came after that measurement.

### EGA/CGA against the reference BIOS

    make 775-ref-compare ROM=S3V2P24.BIN

runs 2389 INT 10h calls in the CGA, MDA and EGA modes (00h-07h, 0Dh-10h) on the unpatched reference
BIOS and on the ROM (mode sets at 200, 350 and 400 lines, scrolls with random windows, text and pixel
output, palettes, pages, fonts, AH=12h, AH=1Ah, AH=1Ch) and compares the registers a program gets
back, the BIOS data area, video memory, the DAC and the standard VGA registers after each call. For
the current ROM there is no difference: the patches in those paths (32-bit text scroll, planar fills,
AH=09h, VGA clear, font load) only change how fast it is done, and the mode set hook, the memory
clock and the pedestal only touch S3 extended registers, which are not compared.

### Other emulators to test with

We want to test compatibility with [rust-dos](https://github.com/dividebysandwich/rust-dos) (GPL-2.0 or
later, a DOS and Windows 9x emulator in Rust). It emulates an S3 Trio64 and ViRGE among its video cards and
provides a VBE 2.0 of its own, without a BIOS image. What we want to know:

- whether our tools (S3TEST, S3COMPAT, VBESHOW, VGALOG, S3REGS) run on its Trio64 and what they report
  about its registers and VBE answers, against the data book and our three ROMs;
- whether it can load a video BIOS image of ours (an option ROM at C000h) instead of its built-in one;
  if so, it is a second emulator for the ROMs and for the clean ROM's milestones;
- whether the velocity9x Trio64 driver works there with the mode query fix
  ([michaeldale/velocity9x#19](https://github.com/michaeldale/velocity9x/pull/19)); velocity9x's issue
  [michaeldale/velocity9x#4](https://github.com/michaeldale/velocity9x/issues/4) reports the driver
  installing on rust-dos's S3 machine and then staying in 16 colours after the reboot, which is what a
  refused 4F02h looks like (the driver falls back to 640x480 in 16 colours).

Not started; DOSBox-X (machine types for the Vision864, Trio32, Trio64 and Trio64V+) is the other
candidate (`docs/clean-room.md`).

## Trio64V2/DX ROM

`src/roms/` holds the code the ROM carries and `s3patch.py`, which applies the current change set
(level p24) to the S3 reference BIOS 2.04.07 in `reference/775/2_04_07.bin`, with byte assertions at
every patch site, the SHA-256 of the input's code outside the OEM area (CODE_SHA, 0100h-7FFDh) and the
SHA-256 of the build that passed the emulator tests. The result is 64 KB, the
patched 32 KB twice (`SIZE775=32`: the 32 KB alone, for a 32 KB EEPROM). All three ROM targets default
to 64 KB. It needs python3 (no packages) and NASM 3.02:

    make 775-rom OUT=S3V2P24.BIN [SIZE775=32]
    make 775-rom-test [STOCK=STOCK.BIN] [ROM=S3V2P24.BIN]
    make emu-test ROM=S3V2P24.BIN
    make 775-ref-compare ROM=S3V2P24.BIN

What the ROM changes, each with its issue: [docs/775-changes.md](docs/775-changes.md). The byte-level
changes, what was borrowed and what was left out: [docs/775-rom.md](docs/775-rom.md), with the build and
the patcher tests in its section "The build".

## Trio64V+ ROM

`src/roms/vplus/` builds 1.03-08N-pN from the S3 Trio64V+ BIOS 1.03-08N (86C765, VBE 1.2) in
`reference/765/1_03_08n.bin`: backports of the Trio64V2 ROM's speed patches and fixes, and fixes of
1.03-08's own faults, each with its issue in [docs/765-changes.md](docs/765-changes.md). The build, what
does not apply to the Trio64V+ and the per-call costs: [docs/765-rom.md](docs/765-rom.md).

    make 765-rom OUT=S3VPP5.BIN [SIZE765=32]       (64 KB, the 32 KB twice; SIZE765=32: 32 KB, for a 32 KB EEPROM)
    make 765-rom-test [ROM=S3VPP5.BIN]
    make emu-test ROM=S3VPP5.BIN CHIP=765 [LOGS=emu/vlogs]
    make 765-ref-compare ROM=S3VPP5.BIN

Square brackets in these lines mark options: type `SIZE765=32`, not `[SIZE765=32]`.

`s3vpatch.py` works as `s3patch.py`: byte assertions at every patch site (the shared speed patches use
the same signatures and the same .asm files, assembled with the 1.03-08 addresses of
`src/roms/vplus/bios.inc`), the checksum, and the SHA-256 of the build that passed the emulator tests.
`test_s3vpatch.py` checks that build, the checksum, that every changed byte belongs to a patch, and
the refusals (an already patched image, changed patch sites, a wrong checksum, the Trio64V2 2.04.07).
In the emulator tests the ROM runs on the Trio64V+ model (`CHIP=765`): `765_patches` checks its
patches, `stores` the 32-bit stores, and the tests for the 2.04.07 patches are skipped. On the STB
Powergraph 64 and the Hercules Terminator 64 (1 November 2026, p1 at 50 MHz): S3TEST without a FAIL,
S3COMPAT with the three FAILs 1.03-08 has, Windows 98 and video playback working (`docs/765-rom.md`, "On
the cards"). 1.03-08N-p5 on the Hercules card (2 November 2026): S3TEST 26 PASS, 0 FAIL; S3COMPAT 138
PASS, 0 FAIL, 2 WARN (AH=12h BL=20h, 106h at 108 MHz), 10Dh-10Fh at their rate with the halved dot clock
of p2; Windows, video playback and the fonts look right ([docs/765-rom.md](docs/765-rom.md), "On the
Hercules card: 1.03-08N-p5"). 1.03-08N-p8 on the Hercules card (11 November 2026): the SR15 bit 4 write
under the synchronous reset did not latch there, so 10Dh-10Fh ran at 62.6 kHz, 119.2 Hz (S3TEST 4 FAIL,
S3COMPAT 3 FAIL, "Signal Error" on the Eizo in VBESHOW; results/86C765-p8-hercules.ZIP and
results/pictures/invalid_signal.jpg, kept local). 1.03-08N-p9 (same card, same run day,
results/86C765-p9-hercules.ZIP, kept local) changed nothing: the SR15 write is dropped because the mode
set has relocked SR8, and while SR8 is locked the extended sequencer registers SR9-SR6F ignore writes
(V+ 18.1, SR8), so 10Dh-10Fh still ran at 62.6 kHz, 119.3 Hz, "invalid signal". 1.03-08N-p10 writes SR15
bit 4 with SR8 = 06h around the write and relocks after, and the emulator now models that lock; on the
Hercules card (11 November 2026, results/86C765-p10-hercules.ZIP, kept local) the write latched (SR15 =
13h) and all three modes measured 59.6 Hz, 31.2 kHz, 525 lines, but the picture at p8-p10's 525-line frame
was wrong: 10Dh/10Eh squished into the top 400 of 525 lines, 10Fh blank. 1.03-08N-p11 reverts the frame to
1.03-08's 449 lines: with the halved DCLK the modes run at 31.3 kHz, 69.8 Hz, the VESA 70 Hz and exactly
the timing registers the stock Phoenix BIOS of the STB card programs and displays correctly; the picture
of 10Dh-10Fh in VBESHOW with p11 is still for a card to show
([`docs/765-rom.md`](docs/765-rom.md), "10Dh-10Fh").

## Trio64 ROM

`src/roms/trio64/` builds 1.5-07-pN for the Trio64 (86C764) from the Phoenix S3 Trio64 BIOS 1.5-07 in
`reference/764/1_5_07.bin` (the CP764 build), the reference BIOS S3 gave the card makers for the
Trio64, as far as the 14 Trio64 images at hand show (no S3-built one among them). Its changes, each with
its issue: [docs/764-changes.md](docs/764-changes.md) (backports of the Trio64V2 ROM's speed patches and
fixes, no interlaced timings, S3's font layout from public domain sources (`src/roms/fonts`), the display FIFO M from the memory bandwidth). The build, the
space map, what 1.5-07 still gets wrong and the base candidates: [docs/764-rom.md](docs/764-rom.md). The
ROM is for the **S3 86C764X** (Trio64 PnP, rated for a 70 MHz MCLK); for the earlier 86C764-P use
`make 764p-rom` (50-60 MHz).

    make 764x-rom OUT=S3T64P5.BIN [SIZE764=32] [MCLK=55]   (64 KB, the 32 KB twice; SIZE764=32: 32 KB)
    make 764-rom-test [ROM=S3T64P5.BIN]
    make emu-test ROM=S3T64P5.BIN CHIP=764 [LOGS=emu/tlogs]
    make 764-ref-compare ROM=S3T64P5.BIN

The 64 KB images of all three ROMs (Trio64, Trio64V+ and Trio64V2) carry the 32 KB twice, so a board
finds the BIOS whichever half of its 64 KB EEPROM it maps; the PCI ROM header declares one 32 KB image,
the last, so firmware that reads the ROM through PCI ignores the copy. The ExpertColor DSP-3364P maps the upper half: with zeros
there (the layout of the Trio64V2 ROM, whose card maps the lower half) the card stayed dark at POST
while the PC booted ([#78](https://github.com/perchrh/trio64-vbios-tools/issues/78), 31 October 2026).

`s3tpatch.py` checks the 1.5-07 code (1000h-7EFFh, the same in every 1.5-07 build) and the layout of
its tables, so a card's own 1.5-07 dump can be patched as well; it keeps that card's memory clock and
timing bytes. The emulator test `764_patches` checks the ROM's changes, `stores` its 32-bit stores, and
S3TEST runs its Trio64 set. On the ExpertColor DSP-3364P (31 October 2026): S3TEST 26 PASS, 0 FAIL,
banked writes at 81.7 MB/s with the booster; S3COMPAT's 49 FAILs there were test bugs, fixed in the
tools ([#72](https://github.com/perchrh/trio64-vbios-tools/issues/72), [#73](https://github.com/perchrh/trio64-vbios-tools/issues/73); docs/764-rom.md, "On the card"). 1.5-07-p5 on the same card (2 November 2026): S3TEST
26 PASS, 0 FAIL; S3COMPAT 135 PASS, 0 FAIL, 1 WARN (AH=12h BL=20h); Windows, video playback and
the fonts look right ([docs/764-rom.md](docs/764-rom.md), "On the card: 1.5-07-p5").

## PoC option ROM

`src/poc-pci-rom/` builds a generic PCI option ROM for any conventional PCI card (PCI 2.1 and later):
at POST it prints its identity banner ("PoC PCI option ROM 1.0" and the card's vendor:device
IDs, read from its own PCIR) on INT 10h and beeps high-low high-low (1200/600 Hz) on the PC
speaker, holds the text for about 1 s more and returns CF=0. One 32 KB image with a valid checksum at offset 0, the rest of the part
padded with FFh, so a BIOS scanning the ROM window finds one image and runs it once. The file size
is `POC_PAD` in KB and names the default output (`OUT` overrides): 64 KB -> `build/roms/poc/HELLO64K.ROM`,
128 KB -> `HELLO128K.ROM`; `POC_OFFSET` (KB) places the image at that offset instead of 0. A PCI 2.1 POST
skips an image whose vendor/device IDs do not match the card, so pass the card's real IDs with
`VENDOR`/`DEVICE` (hex, from `lspci -nn` or the like). The image sits in the first 32 KB; keep the
file no larger than the part (a bigger file wraps around when flashed and overwrites the image), and
use `POC_OFFSET` only for a board that maps the upper block of its decode window.
Details, flashing and the emulator run: [docs/poc-rom.md](docs/poc-rom.md).

    make clean poc-rom VENDOR=0x10B7 DEVICE=0x9055 NASM=nasm/nasm-3.02/nasm   (3C905B-TX; 64 KB)
    make poc-rom POC_PAD=128 VENDOR=0x10EC DEVICE=0x8139   (RTL8139D; 128 KB)
    make poc-rom OUT=HELLO.ROM POC_PAD=32 VENDOR=0x8086 DEVICE=0x1229   (Intel 82557, 32 KB)
    python3 emu/poc_test.py [ROM image, default build/roms/poc/HELLO64K.ROM]

## MCLK build option

Every chip's ROM at its memory clocks in one go, into `build/roms/<chip>-<level>/` (the level from
`src/tools/common/version.inc`) with 8.3 names for a DOS disk (chip code, M, clock):

    make roms [CLOCKS_775="50 55 60"] [CLOCKS_765=...] [CLOCKS_764X="55 60 70"] [CLOCKS_764P=...]

| Chip | Folder and files | Clocks | ROM |
| --- | --- | --- | --- |
| 775 (Trio64V2/DX) | `775-P26/775M50.BIN` ... | 50, 55, 60 MHz | 2.04.07-p26, 64 KB (`SIZE775=32` for 32 KB), the clock in the edo1 entry |
| 765 (Trio64V+) | `765-P10/765M50.BIN` ... | 50, 55, 60 MHz | 1.03-08N-p10, 64 KB (`SIZE765=32` for 32 KB), the clock in the edo1 entry |
| 764X (Trio64 PnP) | `764X-P6/764XM55.BIN` ... | 55, 60, 70 MHz | 1.5-07-p6, 64 KB (`SIZE764=32` for 32 KB) |
| 764P (86C764-P) | `764P-P6/764PM50.BIN` ... | 50, 55, 60 MHz | 1.5-07-p6, 64 KB |

The two Trio64 models get the same ROM; `make 764x-rom` and `make 764p-rom` differ only in the MCLK range
the build option accepts: 50-70 MHz on the 86C764X, 50-60 MHz on the 86C764-P (T64-MEM-7; above it only
with `OVERCLOCK=1`). The 86C764X floor was 55 MHz up to 1.5-07-p5; it is 50 MHz since p6, so that the
default clock is one the option accepts too.


    make 775-rom OUT=S3V2P26-55.BIN MCLK=55 [MEMTYPE=edo1]
    make 765-rom OUT=S3VPP6-55.BIN MCLK=55 [MEMTYPE=edo1]

Both BIOSes pick the memory clock at POST from a small table, by the memory type the card is strapped
for (CR36 bits 3-2, set by resistors on the board and kept by the BIOS). `MCLK` sets the entry of
`MEMTYPE` (the Trio64 ROM has one entry for every type) to the nearest MCLK PLL setting (M 1-127, N 1-31, R 0-3, VCO 135-270 MHz) at or below the
data book limit; the other entries stay at the default. Without `MCLK` every entry of every ROM holds
50.11 MHz (SR11 = 28h, SR10 = 41h), the clock S3's own Trio64V2 and Trio64V+ BIOSes use for 1-cycle
EDO (owner's decision, 7 November 2026). The build prints the frequency it got (50 gives 50.11 MHz, 55
gives 55.04 MHz, 60 gives 59.96 MHz).

| Chip, ROM | MEMTYPE | Entry | Default | Data book maximum |
| --- | --- | --- | --- | --- |
| Trio64V2, 2.04.07-p26 | edo1 (1-cycle EDO, the test card) | C7h | 50.11 MHz (as 2.04.07 and the card's stock 2.04.11; p9-p25: 59.96) | 60 MHz (V2-MEM-1) |
| | fpm (fast page and 2-cycle EDO) | C9h | 50.11 MHz (2.04.07: 59.96) | 66.67 MHz (15 ns; the book gives no separate 2-cycle EDO value) |
| | sgram (Trio64V2/GX) | CBh | 50.11 MHz (2.04.07: 66.2) | 66.67 MHz |
| Trio64V+, 1.03-08N-p6 | edo1 | A8h | 50.11 MHz (as 1.03-08N; 1.03-08: 52.79) | 60 MHz (16.67 ns cycle, table 4-6, MEM-1) |
| | fpm (fast page and 2-cycle EDO) | A6h | 50.11 MHz (1.03-08N: 59.96) | 60 MHz |
| Trio64, 1.5-07-p6 | (one entry for every type) | 3B5h | 50.11 MHz (the input's own pair replaced; 54.9 MHz in the reference) | 70 MHz (T64-MEM-7; the data book gives 60 MHz, MEM-1) |

At 50.11 MHz the Trio64V2 ROM's POST sets CR88 bit 1 again (PD bus delay of 1/2 MCLK on memory writes),
as 2.04.07 does when the chip is revision 06 (CR2F bits 3-0), the card has 1-cycle or 2-cycle EDO (CR36
bit 2 = 0) and SR10/SR11 hold exactly 41h/28h; at 59.96 MHz (p9-p25) the bit stayed off. The card ran
the `MCLK=50` build of p25 with the bit on (S3REGS: CR88 = 02h) and S3TEST and S3COMPAT found no
error (7 November 2026).

On the Trio64 ROM `MCLK` goes up to 70 MHz, above the data book's 60 MHz: our tools take 70 MHz as the
Trio64's limit (T64-MEM-7), the clock card databases give for the 86C764X (vgamuseum), and the ExpertColor DSP-3364P runs it (its own
BIOS: 69.8 MHz, PLL bytes 25h 22h, model tag "764 M70"):

    make 764x-rom OUT=S3T64P5.BIN MCLK=69.8

The display FIFO M follows the build's clock (since p2, [#75](https://github.com/perchrh/trio64-vbios-tools/issues/75); docs/764-rom.md): windowed video on
that card, which streaked at 54.9 MHz with Phoenix's values, was clean with p2 at 55 and 69.8 MHz; the
card run of p3 at 60 MHz is open ([#82](https://github.com/perchrh/trio64-vbios-tools/issues/82)), and so is one of the 50.11 MHz default of p6.

On the Trio64 and Trio64V+ ROMs `MCLK` takes the PLL pair other Trio32/Trio64/Trio64V+ BIOSes use when
one lies within 0.5 MHz of the request (`s3patch.KNOWN_MCLK_8811`, from the survey in
docs/764-rom.md: 42h 41h for 59.96 MHz in 9 images, 46h 79h for 55.04 MHz, 22h 25h for 69.80
MHz and others), and computes the closest setting only when none does; the build log names the pair and
where it came from. So `MCLK=70` builds 69.80 MHz, the card's own setting, and `MCLK=53` 52.80 MHz.

Up to 70 MHz the build prints no warning and S3TEST's and S3COMPAT's MCLK lines pass. Above 70 MHz, up to 100 MHz
(twice 50 MHz, the lowest MCLK these BIOSes run), only with `OVERCLOCK=1` (s3tpatch.py `--overclock`):
the card owner's choice, never a default; the build says OVERCLOCK in its result line.

The Trio64V+ feature list names 50 MHz for EDO and 1-cycle EDO; the timing table allows 60 MHz, which
S3COMPAT checks (MEM-1); 1.03-08N runs 50.11 MHz, 1.03-08 52.79 MHz. Below 40 MHz the option refuses (the data
books give no minimum; it guards against typing errors). Without `MCLK` the build is the tested one and
its SHA-256 is checked; with it the patcher also makes the default build, checks that one's SHA-256,
and refuses the result if it differs anywhere but the MCLK entry, the constant the Trio64's FIFO code
derives from the MCLK and the checksum (#143). The clock itself is judged on the card: S3TEST's MCLK line and S3COMPAT's POST line compare it with the
data book limit for the strapped type, and S3COMPAT's VRAM test (without /Q) shows whether the memory
keeps up. Which clock a given card's memory runs at is not a data book question: the default, 50.11 MHz,
is the lowest of S3's own BIOSes; a faster build is checked with the VRAM test on the card before it is
kept.

## Video memory sizes

The data books allow 1, 2 or 4 MB on the Trio64, Trio64V+ and Trio64V2 (Trio32: 0.5 to 2 MB; on the
Trio64 4 MB needs fast page memory, on the Trio64V2/GX SGRAM is 1 or 2 MB). No build option is needed:
both BIOSes find the size at every POST. They write 4 MB into CR36 bits 7-5, test the last 64 KB bank,
then 2 MB, and write the size that holds (2.04.07 at 19C0h, 1.03-08 at 0E80h); the data books say the
same ("the S3 BIOS determines this value directly and writes it to CR36_7-5 after reset"). So a card
upgraded from 1 to 2 MB, or from 2 to 4 MB where the board has the sockets, works with the same ROM.
Phoenix 1.5-07, the Trio64 ROM's base, does the same, but tries 4 MB only on a Trio64 strapped for fast
page memory (CR36 bit 2), as the data book allows (docs/764-rom.md, "Memory"). The emulator
answers with a fixed size (`--vram`): `make emu-test` runs the tests whose result depends on the size with
2 and 4 MB (the Trio32 only with 2 MB, its maximum; the Trio64 too, as no Trio64 card was built with 4 MB (decided 7 November 2026): its 4 MB run is left to
`make emu-test ... CHIP=764 VRAM=4` or `tests.py --chip 764 --vram 4` by hand, and CI does not run it),
and on every chip also with 1 MB, the smallest configuration. The Trio64 and Trio32 models are strapped EDO (CR36 bits 3-2 = 10b), the Trio64 with 4 MB fast
page (11b).

## Continuous integration

`.github/workflows/ci.yml` runs on GitHub Actions for pushes to main, pull requests and by hand (the
Actions tab, "Run workflow"). The repository is public, so the GitHub-hosted runners it uses are free;
changes that touch only `*.md`, `*.pdf`, `docs/`, `datasheets/` or `standards/` do not start
a run, and a newer commit on the same branch cancels the running one. Emulator test jobs (the chip/clock
matrix and the stock-ROM runs) start when `src/roms/**`, `src/tools/**` or `emu/**` changed, or on a
manual run; `make roms` and the release zip still run on every CI start.

NASM 3.02 (the ROM targets need exactly that version) comes from the `ci-deps` release: every job
downloads `nasm-3.02-linux-x86_64.tgz` with `gh release download`, checks it against
`nasm-3.02-linux-x86_64_SHA256.txt` and builds 3.02 from the official release source only when the
asset is missing or fails the check. An agent in a fresh Ubuntu 26.04 x86-64 sandbox (the runners'
image; the binary needs glibc 2.38 or newer) does the same instead of building:

    gh release download ci-deps --repo perchrh/trio64-vbios-tools \
        -p 'nasm-3.02-linux-x86_64.tgz' -p 'nasm-3.02-linux-x86_64_SHA256.txt'
    sha256sum -c nasm-3.02-linux-x86_64_SHA256.txt
    tar xzf nasm-3.02-linux-x86_64.tgz        # the binary is nasm/nasm-3.02/nasm

Tool and ROM sources live under `src/tools/` and `src/roms/`. `make` builds both; `make tools` and
`make roms` build one or the other; `make clean` removes `build/` (tools and ROM images). CHIPID.COM,
ROMVER.COM, REPORT.COM, MCLK.COM and ZIP.EXE are part of the tools list and of the release zip.

The job "All ROMs (make roms) and the release zip" builds every chip's ROM at its memory clocks, to show
that they all build, and the release zip (`make dist`). When `src/roms/**` changed, the tests also run
as parallel jobs on the slowest and the fastest memory clock of each chip; each job builds the one image it
tests (`make 775-rom MCLK=50` and so on). Each job tests its image with 2 MB of
video memory, then runs the tests tagged `vram` (the ones whose result depends on the memory size) with
4 MB and with 1 MB (the Trio64 jobs with 1 MB only); the other tests do not run again at the other sizes:

| Job | What it runs |
| --- | --- |
| All ROMs (make roms) and the release zip | `make roms`: every chip's ROM at its memory clocks (775, 765, 764X, 764P), built and not kept; `make dist`: the artifact `trio64-tools-<VERSION>` (kept 90 days, tools only) |
| Trio64V2 50 MHz: 2, 4 and 1 MB, patcher, EGA/CGA | `775M50.BIN`; `make 775-rom-test` (builds the default ROM and checks its pinned SHA-256), `make 775-ref-compare` |
| Trio64V2 60 MHz: 2, 4 and 1 MB | `775M60.BIN` |
| Trio64V2 50 MHz: s3compat_full 2 MB | `775M50.BIN`: the longest test alone |
| Trio64V2 60 MHz: s3compat_full 4 MB | `775M60.BIN`: the longest test alone |
| Trio64V+ 50 MHz: 2, 4 and 1 MB, patcher, EGA/CGA | `765M50.BIN`; `make 765-rom-test`, `make 765-ref-compare` |
| Trio64V+ 60 MHz: 2, 4 and 1 MB | `765M60.BIN` |
| Trio64 764X 55 MHz: 2 and 1 MB, patcher, EGA/CGA | `764XM55.BIN`; `make 764-rom-test`, `make 764-ref-compare` |
| Trio64 764X 70 MHz: 2 and 1 MB | `764XM70.BIN` |
| Trio64 764P 50 MHz and 60 MHz: 2 and 1 MB | `764PM50.BIN`, `764PM60.BIN` (one job each) |
| Stock ROM 775, 765, 764x (informational) | `make stock-test`: every tool and emulator test, the ones tagged `patch` too (tests.py `--stock`), on the stock reference ROM; failures are expected and do not fail the run; the logs are the artifact `stock-logs-<chip>` (14 days) |
| build-and-test | passes when every row passed and every ROM built (the check name branch rules can require); the stock jobs are not part of it |

Every job builds NASM 3.02 from its release source (cached between runs), the tools with `make` and its
ROM from the reference BIOS in `reference/`; the patcher tests build the default ROM (without `MCLK`) and check
it against the pinned SHA-256. The split uses `make emu-test VRAM=... EMUARGS=...` (tests.py `--tests`,
`--skip`, `-t vram`), which works by hand too. The first step of the ROM job, and of the coverage
workflow, is `python3 emu/similarity.py --self-test` (a second). A job that fails keeps its emulator logs as an artifact
`emu-logs-<job>` (without .BIN files) for 7 days. No workflow uploads a patched ROM image (decided 2 November 2026,
[#145](https://github.com/perchrh/trio64-vbios-tools/issues/145)): the images carry S3's and Phoenix's code, so
each job builds its image and keeps it in the runner's temporary folder. The one artifact meant to be kept is the release zip
(`trio64-tools-<VERSION>`, "Release zip"). The hardware logs remain the final word, as for the emulator
tests run by hand.

## Release zip

    make dist [ROMS=1]

builds the tools and packs them into `build/trio64-tools-<VERSION>.zip` (VERSION from
`src/tools/common/version.inc`, now 1.0.1): `trio64/tools/` with VBESHOW, S3TEST, S3COMPAT, S3ALIAS, VGALOG, S3REGS,
CHIPID, ROMVER, REPORT, ZIP.EXE, S3REGS32.EXE, RUNALL.BAT and CLEAN.BAT. CI builds it on
every run and keeps it as the artifact `trio64-tools-<VERSION>` for 90 days; the download is that zip.
`ROMS=1` adds `trio64/roms/` with every chip's ROM at its memory clocks (`make roms`); the default leaves
the ROMs out: the patched images carry S3's and Phoenix's code, so they are built from the reference
BIOSes with `make roms` rather than handed out.

`.github/workflows/coverage.yml` runs `make coverage` (the 80 % goal, with the list of code no test
reaches) on the same ROM, for pushes to main and by hand only: pull requests do not start it, as it runs
every emulator test once more. Its logs are kept as the artifact `coverage-logs`.

## Debug log (/V)

VBESHOW, S3TEST and S3COMPAT take `/V`. It writes a second file, `VBESHOW.DBG`, `S3TEST.DBG` or
`S3COMPAT.DBG`, in the current directory. Its only purpose is to show how the code ran on the real
card, so problems can be found and fixed from a log instead of guessed at. The normal output is the
same with or without /V. The debug file contains:

- the environment: the NASM version that assembled the tool (`D:ENV NASM=`, the first line), CPU,
  DOS version, memory, interrupt vectors, system BIOS date, the video ROM
  version (`D:ENV ROM=`, the same scan as S3TEST, S3COMPAT and ROMVER), header and checksum, the BIOS
  data area and the PCI configuration of the display controller
- every INT 10h call the tool makes (and nested calls the BIOS makes itself) with all registers in and
  out and the duration in PIT counts
- a register dump (SR, GR, CR00-18, CR30-6F, CR80-9F, AR, DAC 0-15, video BIOS data) after every test or
  shown mode, with the normal result line copied next to it
- the 4F00, 4F01 and AH=1Bh blocks as hex, per-frame timer counts of every refresh measurement and the
  first memory mismatches with address, expected and read value
- S3COMPAT: every read of a DAC check (`D:DAC try=n`, see below) with the first wrong entry's values

The file is committed before every mode set and VBE call (except 4F05), so after a freeze its last
lines show the call that hung. The INT 10h hook passes the 32-bit registers through unchanged. Expect a debug file of 1-2 MB for S3COMPAT and a longer run.
The line format is described at the top of `src/tools/common/vdebug.inc`.

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
   `VGALOG /D`. Bring S3REGS.TXT and VGALOG.BIN back. `VGALOG /D` also works in an MS-DOS prompt while
   Windows runs: it finds the copy loaded before Windows through the DOS memory chain, since Windows
   hooks INT 10h after it in a DOS box.
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
  A0000h (garbage on the desktop). And with the booster on in a full-screen DOS box (VBESHOW 101h, 103h),
  Windows restored the box after Alt+Tab with MISC = 63h (the fixed 25 MHz clock, 400-line sync), which
  the monitor could not show, every time; without the booster this happens only once in many tries, as
  with the stock BIOS. With the ROM the desktop snapshots show CR6D = 01h (the refusal), CR58 92h and
  CR59/CR5A E000h, and VBESHOW in a full-screen box comes back after Alt+Tab as with the stock BIOS. The
  emulator test `windows` replays the driver's 4F02 calls with an INT 2Fh that answers Windows.
- Windows brings a full-screen DOS box back with its own 4F02 call (8101h, 8103h, C101h; CX = 0,
  DX = 03E0h), and the desktop with 4F02 8115h; the mode set hook restores CR59/CR5A from CR6D when a
  booster was on in plain DOS before.
- The driver keeps the memory clock the BIOS sets (59.96 MHz with the ROM up to p25, 50.11 MHz with
  the stock BIOS and the default build since p26) on the desktop, in DOS boxes and through video playback, and uses the BIOS pixel clocks,
  also the VCO-moved ones (800x600: SR12/SR13 63h/6Eh, 40.09 MHz, VCO 320.7 MHz).
- CR90/CR91 (L1) is set by the driver to (bytes per line / 8) - 1 in every mode (V2-REG-4); CR86 stays
  00h with an End Horizontal Blank above 1 (V2-REG-3).
- The stock BIOS leaves CR90 = 81h, CR91 = 8Fh (the L1 of 800x600x32) in mode 03h after Windows and in
  a full-screen DOS box. Through p24 the ROM cleared bit 7 in every VGA mode; since p25 ([#166](https://github.com/perchrh/trio64-vbios-tools/issues/166))
  it clears bit 7 only in mode 13h (Mode X / 360-wide entry), so mode 03h after Windows matches stock
  again (CR90 81h) while Mode X and Quake 360 still get a clean 13h.
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

    S3REGS 1.0.1 [label] DOS                  or  S3REGS32 1.0.1 [label] Win32
    MISC=EF FEAT=00 PEL=FF MODE=59 VBE=0101 TICK=00000032   (MODE and VBE only from DOS)
    SR00: 16 bytes SR00-SR0F                  SR10: SR10-SR1F
    CR00: ... CRF0: 16 rows of CR00-CRFF      (CR45, CR4A, CR4B, CRC5, CRCA, CRCB shown as --, not read)
    GR00: GR00-GR08
    PCI00: 16 dwords of the PCI configuration header of 5333:8901
    WATCH 120 s, ...                          (S3REGS32 /W only) then lines "+<ms> CR54 18->10"
    END OF WATCH                              followed by the closing snapshot

S3REGS32 reads the ports directly, which Windows 9x allows a Win32 program for ports no virtual
device traps; on Windows NT it ends with an exception. It keeps the 3C4h, 3CEh and 3D4h indexes,
SR08, CR38, CR39 and CF8h as found, and never touches the attribute controller or the cursor colour
stack (CR45, CR4A, CR4B). On the Trio32/Trio64 CR80-CRFF are CR00-CR7F again (the chip decodes CRTC
index bits 6-0 only), so CRC5, CRCA and CRCB are left out as well, and the watch ignores CRC6-CRCF
as it ignores CR46-CR4F ([#74](https://github.com/perchrh/trio64-vbios-tools/issues/74)). It is built by NASM alone: the PE header is written out in
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

## To do

- Replace the stock BIOSes in `reference/` with links to their pages on theretroweb.com plus their
  SHA-256, which the patchers check (today they refuse an image whose code differs from the reference's:
  the byte assertions at the patch sites, and CODE_SHA over the rest, #143); `make roms`
  and the tests then take the files from where the user saved them. CI downloads them once and keeps
  them in its cache for as long as the cache allows (a key on the SHA-256 values, so the files are
  fetched again only when the list changes), so no run depends on theretroweb being reachable.
  Decided 1 November 2026, to be done later; confirmed 2 November 2026
  ([#145](https://github.com/perchrh/trio64-vbios-tools/issues/145)): the reference files stay in `reference/`
  until then, and are then removed and replaced with the downloads. Status of 1 November 2026: the Trio64 reference is on
  theretroweb (DataExpert CP764, [docs/764-rom.md](docs/764-rom.md)), and since 2 November 2026 the
  test card's own BIOS too ([DataExpert DSP-3364P](https://theretroweb.com/expansioncards/s/dataexpert-dsp3364p),
  SHA-256 1056fcee..., not a build base); the Trio64V+ reference is its
  1.03-08N (from p4, [#129](https://github.com/perchrh/trio64-vbios-tools/issues/129), [docs/765-rom.md](docs/765-rom.md)); the Trio64V2 2.04.07 and
  2.04.11 are not there yet.
- Possible option `/M:50` for S3TEST, S3COMPAT and VBESHOW (future work, noted 30 October 2026), so
  that one ROM can be tested on several cards with different memory speeds without flashing each
  clock (`make roms` builds the clocks as separate images): the tool sets the memory
  clock to the given MHz for its run, then puts back the clock the BIOS set at POST when it ends (a
  known state, as for the screen and the PIT). Design notes:
  - Setting it: the nearest MCLK PLL pair (M 1-127, N 1-31, R 0-3, VCO 135-270 MHz, as the
    `MCLK=` build option computes it) into SR11/SR10, then SR15 bit 0 set and cleared to load it
    (T64-PLL-1; SR15 bit 5 never left set, REG-1). A value above the data book limit for the chip and
    the strapped memory type is refused.
  - It holds through the run: neither 2.04.07 nor 1.03-08 writes SR10/SR11 after POST, and the
    SR15 = 03h of their mode sets only reloads what SR10/SR11 hold (emulator, 30 October 2026).
  - Results: the MCLK line keeps judging the BIOS's POST clock (read before /M changes it) against
    the data book; an INFO line shows the clock /M set; the debug log records both (raw SR10/SR11).
    The VRAM test of S3COMPAT then runs at the /M clock, which is the point of the option.
  - The ROM's own clock for a card is still set with `make 775-rom MCLK=...`; /M is for testing.
- Possible TSR (not for the ROM): the 64 KB linear window at A0000h in VGA mode 13h, as the "VGA mode
  13h speed up" of S3 Speed Up 3.11 (Dietmar Meschede, 1997; it needs his S3 VBE/Core 2.0 TSR, so it
  does not run with this ROM). The booster does not cover mode 13h: it needs CR31 bits 0 and 3
  (banking with enhanced mapping), which mode 13h does not set, so chained 320x200x256 games (for
  example Duke Nukem 3D in its 320x200 VGA mode) write through the slower chain-4 path. Not a ROM
  default: Mode X/Mode Y games set mode 13h and then switch to unchained planar access, which the
  linear window bypasses (S3 Speed Up warns that DOOM breaks), and a BIOS cannot know which program
  will do that. As an opt-in TSR in the S3ALIAS style; gain not measured.

## Sources

### Missing documents

Documents the project does not have; what depends on them is marked where it is used.

- Trio32 datasheet of its own: the Trio32/Trio64 book (March 1995) covers both chips, but rules of the
  Trio32 alone were left out (`docs/chip-rules.md`), and the OEM function survey has no Trio32 entry.
- Trio3D (86C365) and Trio3D/2X (86C362/86C368) datasheets: their BIOSes were compared with the Trio64V2
  ROM (`docs/775-rom.md`, "Not taken" and "Not used"; Sources), but no chip rule is written for them, and nothing from those BIOSes
  is taken where it depends on the chip.
- Trio64V2/DX & GX: only the preliminary book (changes from the Trio64V+) is at hand, no final edition.
- An S3 document on the BIOS interface: the S3 OEM functions (4F14h) and the S3 mode numbers are known
  only from BIOS images (`docs/chip-rules.md`, "S3 OEM functions (4F14h)").
- VESA standards our ROMs implement that neither the repository nor the owner's copies hold: DDC 1.0
  (August 1994) or 2.0 for the DDC1 mode, which E-DDC 1.2 no longer describes and which the Trio64 ROM
  keeps in 4F15, and DPMS 1.0 (August 1993) for the Standby and Suspend states, which DPM Release A
  dropped. The rest is covered by the copies under "VESA standards": E-DDC 1.2 for DDC2B, E-EDID
  A1 and A2 for the EDID data, VBE 2.0 and 3.0 for 4F15 (VBE/DDC) and 4F10 (VBE/PM), VBE 1.2 and 2.0
  for VBE 1.1 and the Mode 6Ah standard (6Ah as 102h), DMT and GTF 1.1 for the timings.
- Richard Wilton's "Programmer's Guide to PC Video Systems" (2nd edition, 1994): worth having, not
  needed.

### VESA standards

The VESA documents our ROMs implement or the tools check against. In the repository under
`standards/vesa/`: VBE 2.0 (`vbe20.pdf`), VBE 1.2 (`vbe12.txt`) and DMT 1.0 Rev. 10
(`VESA-DMT-1.0-Rev10.pdf`). The others remain the owner's copies outside the repository (file
names in brackets, as of 2 November 2026); the links are public copies.

- [VESA BIOS Extension (VBE) Core Functions Standard 2.0](https://www.phatcode.net/res/221/files/vbe20.pdf),
  Rev. 1.1 (November 1994; `standards/vesa/vbe20.pdf`; [text version](https://web.archive.org/web/20081211174813/http://docs.ruudkoot.nl/vbe20.txt)): 4F00-4F0A, the info blocks, the mode numbers. The Trio64V2 ROM is VBE
  2.0, and S3TEST and S3COMPAT check against it.
- [Super VGA BIOS Extension Standard #VS911022](https://www.phatcode.net/res/221/files/vbe12.txt)
  (VBE 1.2, 22 October 1991; `standards/vesa/vbe12.txt`); the text retyped by "Patch" (VESASP12.ZIP)
  is also at
  [discmaster](https://discmaster.textfiles.com/view/10567/HPAVC%20CD-ROM.iso/pc/PCGPEV10.ZIP/VESASP12.TXT)
  and [archive.org](https://web.archive.org/web/20090114055246/http://docs.ruudkoot.nl/vesasp12.txt). It is
  the version the Trio64V+ and Trio64 ROMs report. What a 1.2 BIOS must do beyond 1.0: every
  ModeInfoBlock field valid (the direct colour fields in memory models 6 and 7), ModeAttributes bit
  D1 always 1, unused fields zero and exactly 256 bytes returned (from 1.1), the direct colour memory
  model, 4F08 (DAC width, reset to 6 bits by a mode set), and the advice that INT 10h AH=0Fh return a
  number with which AH=00h sets the last Super VGA mode again. The retyped ModeInfoBlock listing
  leaves out RsvdFieldPosition, which its text describes. Clean-room extract:
  [`docs/cleanroom/primary-extracts/vbe-1.2-status-and-ah0f.md`](docs/cleanroom/primary-extracts/vbe-1.2-status-and-ah0f.md).
- [VBE 1.0](https://web.archive.org/web/20131211151957/http://www.gemixtes.de/super-vga-bios-extension-standard-vs891001/)
  (Super VGA BIOS Extension, VS891001, 1 October 1989), as transcribed on the Gemixtes blog: 4F00-4F05,
  the 15-bit mode numbers from 100h, mode 6Ah as 102h, window granularity; the base of VBE 1.2.
- VESA and Industry Standards and Guidelines for Computer Display Monitor Timing (DMT) 1.0,
  [Rev. 10](https://glenwing.github.io/docs/VESA-DMT-1.10.pdf) (29 October 2004;
  `standards/vesa/VESA-DMT-1.0-Rev10.pdf`) and
  [Rev. 13](https://glenwing.github.io/docs/VESA-DMT-1.13.pdf) (2013; `VESA-DMT-1.13.pdf`); and the
  [VESA Generalized Timing Formula (GTF) Standard 1.1](https://glenwing.github.io/docs/VESA-GTF-1.1.pdf)
  (2 September 1999; `VESA-GTF-1.1.pdf`; 1.1 adds only the "Secondary GTF" curve to 1.0 of 8 December
  1996, the default curve is unchanged): the timing references of the tools and the refresh tables.
  Clean-room extract of 640x480 at 60 Hz:
  [`docs/cleanroom/primary-extracts/dmt-640x480-60hz.md`](docs/cleanroom/primary-extracts/dmt-640x480-60hz.md).
- [VESA Enhanced Display Data Channel (E-DDC) Standard 1.2](https://glenwing.github.io/docs/VESA-EDDC-1.2.pdf)
  (26 December 2007; `VESA-EDDC-1.2.pdf`): DDC2B over the I2C bus,
  EDID at A0h/A1h, for the DDC2 work on the Trio64. It drops the DDC1 mode ("No support for the DDC1
  mode of operation"), which our ROMs still offer in 4F15.
- DPM Standard Release A (3 March 2003; owner's copy of VESA's page
  [sumdpm.mht](https://web.archive.org/web/20100628042359/http://www.vesa.org/summary/sumdpm.mht),
  its front matter and contents): it replaces DPMS 1.0 of 20 August 1993 and defines only the On and
  Off modes, signalled through the syncs. The Standby and Suspend states that 4F10h also sets come from
  DPMS 1.0, for which the X Window System's DPMS extension stands in. The X11 project is a source for
  that extension and for the other display material it publishes; what its 1996 DPMS client states is
  in [docs/clean-room.md](docs/clean-room.md) ("The X11 project").
- DDC on the VGA connector: [hardwarebook.info, "VGA (VESA DDC)"](https://www.hardwarebook.info/VGA_(VESA_DDC)),
  the pins (12 SDA, 15 SCL, 9 +5 V) for the DDC2 work on the Trio64 board; EIZO, FlexScan F67/FX-D7
  T68/TX-D7 User's Manual (1999), whose D-Sub pin assignment confirms DDC2B on pins 12 (Data) and
  15 (Clock) with no pin 9 on a period CRT; and Joe Miseli (Sun
  Microsystems), [EDID, Display Technology and VESA](https://www.x.org/wiki/Events/XDC2007/Notes/Xorg_2007-EDID-JMiseli.pdf)
  (Xorg Developer's Conference, 8 February 2007; `Xorg_2007-EDID-JMiseli.pdf`), the history of EDID,
  E-EDID, DDC and E-DDC.

Owner's copies of standards our ROMs do not implement, so neither the ROMs nor the clean room depend
on them:
[VESA BIOS Extension (VBE) Core Functions Standard 3.0](https://pdos.csail.mit.edu/6.828/2018/readings/hardware/vbe3.pdf)
(September 1998; `vbe3.pdf`; refresh
control through 4F02 with a CRTCInfoBlock and 4F0B, for a later level; its 4F15 description is used
above),
[VESA BIOS Extension Serial Control Interface (VBE/SCI) Standard 1.0](https://web.archive.org/web/20051221092948/http://www.vesa.org/Public/VBE/vbesci10-2w.pdf)
(July 1997; `vbesci10-2w.pdf`; 4F15 BL=10h-16h, raw access to the DDC lines, which would let a tool
probe the Trio64 board's DDC wiring), the
[VESA Enhanced Extended Display Identification Data Standard, Release A, Revision 1](https://glenwing.github.io/docs/VESA-EEDID-A1.pdf)
(February 2000; `VESA-EEDID-A1-DDC3.pdf`; EDID 1.3, the data 4F15 carries) and
[Release A, Revision 2](https://glenwing.github.io/docs/VESA-EEDID-A2.pdf) (2006; `VESA-EEDID-A2.pdf`;
EDID 1.4), and
[VESA BIOS Extension/Accelerator Functions (VBE/AF) 1.0, Revision 0.7](https://web.archive.org/web/2005/http://www.vesa.org/public/VBE/VBE-AF07.pdf)
(August 1996; `VBE-AF07.pdf`; a loadable accelerator driver, not a ROM function), and the
[VESA Coordinated Video Timings (CVT) Standard 1.2](https://glenwing.github.io/docs/VESA-CVT-1.2.pdf)
(8 February 2013; the owner's copy; CVT dates from 2003). CVT generates new timings and does not change
the DMT and IBM entries our ROMs use. Two of its points bear on them: a border (CVT's margin) counts as
active and blanking lies outside it, as in DMT (spec-b MQ-16); and a display reads the sync polarities
with the vertical sync width, where a sync of 3 lines or less marks a non-CVT (DMT, GTF) timing, so the
IBM 400- and 350-line timings (2-line syncs, mixed polarities) are not taken for CVT ones.

### Other references

Owner's copies, outside the repository: IBM's "Personal System/2 and
Personal Computer BIOS Interface Technical Reference" (April 1987), Ralf Brown's Interrupt List, Richard
Ferraro's "Programmer's Guide to the EGA, VGA and Super VGA Cards" (3rd edition, 1994), and the PCI BIOS
Specification 2.1 (`docs/clean-room.md`, "Public documents for the clean side"). The PCI Local Bus
Specification 2.3 is in the repository as [`standards/pci/pci23.pdf`](standards/pci/pci23.pdf)
(clean-room extract of section 6.3:
[`docs/cleanroom/primary-extracts/pci-2.3-section-6.3.md`](docs/cleanroom/primary-extracts/pci-2.3-section-6.3.md)).

### Secondary references

- VGADOC 4b by Finn Thoegersen (1991-95), freeware: nine of its files are in `standards/thoegersen/`
  with its licence (`standards/README.md`). VGABIOS.TXT is a reference for the standard INT 10h
  functions, VGAREGS.TXT, EGAREGS.TXT and CGA.TXT for the registers, S3.TXT for the S3 chips up to
  the Trio64 (registers, IDs, S3 INT 10h functions, board mode lists), PCI.TXT for the PCI BIOS.
  Its [VESA.TXT](https://pdos.csail.mit.edu/6.828/2004/readings/hardware/vgadoc/VESA.TXT) summarizes
  VBE 1.0 to 2.0 and 4F10 (VBE/PM: BL=00h capabilities, 01h set, 02h get the power state, the BH
  bits) with the VBE standard numbers (1.0 VS891001, 1.1 VS900602, 1.2 VS911022): a quick reference
  until VBE/PM itself is at hand. It has errors (4F0A takes BL=00h and returns one table, not BX =
  function), so the standards decide.
- Brad Haakenson, ["Examining the VESA VBE 2.0 Specification"](https://web.archive.org/web/20240508053621/https://www.drdobbs.com/architecture-and-design/examining-the-vesa-vbe-20-specification/184409592),
  Dr. Dobb's Journal, July 1995: what VBE 2.0 changed from 1.2, which is where our VBE 2.0 and 1.2
  ROMs differ. The VbeInfoBlock grew from 256 to 512 bytes (asked for with "VBE2"); only bit 15 of
  the mode number means "do not clear" (some 1.2 programs used bit 7); 4F06 sets the longest line the
  hardware takes instead of failing, and takes bytes as well as pixels; 4F07 BL=80h waits for the
  vertical retrace; 4F09 and 4F0A are new; 4F05 has no effect in a linear mode.
- Myles Strous, ["SuperVGA/VESA programmer's notes"](http://www.faqs.org/faqs/pc-hardware-faq/supervga-programming/)
  1.0 (about 1994): an application programmer's view of VBE 1.2, with its function list and the mode
  list 100h-11Bh; a cross-check of the mode numbers, and the pointers to Ralf Brown's list, Ferraro
  and Wilton (Missing documents).
- Toby Opferman, ["How To Use Super VGA (VESA 1.x Non-Linear)"](https://web.archive.org/web/20120328134352/http://www.opferman.net/Text/svga.txt):
  banking through 4F05 and the window granularity as an application does it; a check of how
  programs use 4F01 and 4F05, nothing more.
- OSDev wiki, ["VESA Video Modes"](https://wiki.osdev.org/VESA_Video_Modes): an application
  programmer's guide to VBE 3.0 (finding a mode by its 4F01 fields, BytesPerScanLine, the pixel
  format fields, the VGA-compatible bit 5, LFB modes with bit 14). A check of what programs look at
  in 4F01, not a source for the BIOS side. One statement in it is wrong for our ROMs: it gives the
  reserved byte at ModeInfoBlock offset 1Eh as 0 in VBE 1.0-2.0 and 1 in 3.0, but VBE 1.2 says it is
  always 1, VBE 2.0 lists it with 1, and our three ROMs return 1 (emulator, 31 October 2026). Its
  links to further tutorials (DJGPP's VESA guide, monstersoft's introduction) add nothing for us.
- Michael Abrash,
  [Graphics Programming Black Book](https://web.archive.org/web/20250308094138/https://www.drdobbs.com/parallel/graphics-programming-black-book/184404919)
  (1997; the author published it freely, Dr. Dobb's hosts the chapters as PDFs): how the VGA
  hardware behaves for the programmer who bypasses the BIOS and programs it directly - latches,
  write modes, chain-four and unchained memory, the CRTC behind Mode X and 360x480, the split
  screen, the DAC. IBM's VGA only: it says nothing of the BIOS functions, SVGA, VESA or any S3
  chip, so it is a hardware cross-check, not a BIOS source. The clean side may read it too
  ([docs/clean-room.md](docs/clean-room.md), "More sources the clean side may read").
- David Brackeen, [256-Color VGA Programming in C](https://web.archive.org/web/20251115151342/http://www.brackeen.com/vga/)
  (1996, a five-part tutorial): how a program drives mode 13h and the unchained mode - pixels,
  lines, bitmaps, the DAC palette. It is more about programming against the modes than about the
  hardware, and its author disclaims its accuracy and its code. A check of what DOS games assume
  of the VGA modes, nothing more.

Looked at and not used: the list of chipsets with VBE 2.0/3.0 (xerxys.info), and vbespy and vbetool,
Linux tools that run a card's video BIOS to log or replay its mode sets (the emulator in `emu/` does
this for our ROMs).

### Rules, data books and BIOS images the work rests on

- `docs/chip-rules.md`: every chip rule the tools check, with its ID and datasheet source.
- `docs/bios-rules.md`: 323 behaviour rules for the standard video BIOS (INT 10h AH=00h-1Ch, the BIOS
  data area, the published tables), each with its public source (Ferraro, RBIL, VGADOC, IBM via
  VGATEST) and the test that checks it; open questions and source disagreements per section.
- S3 Trio64V2/DX and GX datasheet (preliminary): MCLK limits per memory type and DCLK limits, the
  DCLK VCO maximum of 340 MHz, the 3-bit DCLK R divider (SR12 bit 7), CR36 memory types, CR87 1-cycle
  linear addressing, CR90/CR91 FIFO, the PCI subsystem ID (section 3.8), SR1A, CR23/CR26, CR32, CR40,
  CR66 and CR86 rules.
- S3 Trio64V+ (86C765) datasheet, from the S3VBEFIX repository: PLL formula and VCO range, CR67 colour
  modes, SR15/SR18 clock doubling, CR31/CR58/CR59-5A linear addressing, CR50, CR51, CR43, CR5D/CR5E.
- [S3VBEFIX](https://github.com/wbcbz7/S3VBEFIX) source and README, plus SVGATRIX.TXT and vbe20.txt.
- VESA BIOS Extension (VBE) 2.0 specification; VESA DMT; VESA CVT 1.2; the other VESA standards in
  "VESA standards" above.
- VGATEST by Kent Quirk and Ed McNierney, PC Tech Journal, November 1988 (IBM reference tables).
- VBETest/Lite (SciTech) and X-VESA 1.0.3: test ideas for S3COMPAT and VBESHOW.
- [DOS compatibility tests by gona.mactar.hu](https://gona.mactar.hu/DOS_TESTS/): known S3 issues.
- The stock 2.04.11 dump, disassembled to locate the mode set, refresh tables and VBE handlers.
- The S3 reference BIOS 2.04.07, the base of the current ROM, compared with 2.04.11 to find the same
  routines and tables at its addresses, and on 30 October 2026 instruction by instruction: 2.04.11
  fixes the DDC delay and adds CR23 = 00h before CR26 (both in p19), keeps AX in the 4F0A code (not
  taken, `docs/775-rom.md`) and counts planar modes per 256 KB in 4F01 (not taken: 2.04.07's NumberOfImagePages
  is the correct count).
- Compared on 30 October 2026, nothing better to take: the ELSA Winner 1000/T2D BIOS 6.01.00 (S3's
  1.01.04 plus about 3 KB from ELSA: VBE 2.0, LFB, its own mode numbers 212h-218h, 75 Hz defaults, a
  65 MHz MCLK; same S3 DDC code, delays on PIT channel 0; it has S3's 8x14 font, which needs 3.5 KB
  this ROM does not have free), S3's 1.01.04 (VBE 1.2, no LFB) and the S3 Trio3D BIOS 2.0B.07 (the same
  2.0x code base as 2.04.07: its clear, scroll and text routines are 2.04.07's; its new code is
  Trio3D-specific, among it a POST memory test that fills video memory with the Trio3D 2D engine).
- VBE 2.0 specification section 4.13: the registers the 4F0A protected-mode functions may destroy.
- Reviewed on 28 October 2026, nothing new for the 86C775: riplin's annotated disassembly of the
  Phoenix S3 Trio64 BIOS 1.5-07 EDO for the Trio32/Trio64 (86C764x, PCI 5333:8811) in
  [hag `research/s3`](https://github.com/riplin/hag/tree/main/research/s3), its
  [`bios/86c764x.asm`](https://github.com/riplin/hag/blob/main/research/s3/bios/86c764x.asm),
  and the VOGONS thread
  [I disassembled an S3 Trio64 BIOS and am annotating it](https://www.vogons.org/viewtopic.php?t=96638).
  It is another code base than the S3 reference 2.04.07, so no addresses or tables carry over, and it
  has no patches yet (a slowdown fix and more VBE modes are only planned). Its settings (SR0A bit 7
  2-MCLK writes at a 55 MHz MCLK, CR3B = horizontal total - 7, CR54/CR60 for 1 MB) belong to another
  chip and BIOS and are no new evidence for the SR15/CR87 result (`docs/775-rom.md`, "Omitted"). The thread's dual-card
  description (40:87 bit 1 selects MDA or CGA replacement) is standard VGA behaviour, which the ROM
  keeps unchanged from the reference. Licence: hag is MIT (Copyright (c) 2023 riplin), which covers
  riplin's own annotations and code but not the reproduced Phoenix/S3 ROM bytes and tables; VOGONS
  posts carry no licence. Nothing from either was copied. Read again on 30 October 2026 for the Trio64
  ROM, whose base is that BIOS: it confirms the patcher's assumptions (window set and get, the CR41/CR52
  refresh fields, CR6B/CR6C as the PCI base, the memory sizing) and showed the sequencer index that 4F05
  left at 04h; docs/764-rom.md, "Cross-check with riplin's annotated disassembly".

### Windows DDKs (owner's copies, dirty side only)

- [`ddk/`](ddk/) (untracked, in `.gitignore`) holds the installed Windows 95, 98, Me and XP DDKs. The 98 DDK
  ships S3's own Windows 98 driver sources as samples: `ddk/98DDK/src/display/vdd/s3` and `vdd/s3v` (sample
  mini-VDDs, S3.VXD and S3VSMP, for the 911/928/864/964/732/764 and the 765/775/ViRGE/M-series) and
  `ddk/98DDK/src/display/mini/s3v` (a full mini display driver: `S3VSMP.drv`, `s3vsmp.dll`, `s3vsmp.vxd`, with
  the 2D engine, DirectDraw, Direct3D and the LPB video port); its INFs and code name the Trio64V2,
  PCI 5333:8901. The Me and XP DDKs carry no S3 samples (3Dlabs Permedia only; the Me DDK's Direct3D
  reference rasterizer has the S3TC texture-compression file, a ViRGE feature). Licence: the DDK EULA
  licenses, not sells, the product; its copyright clause grants no rights at all in third-party content,
  which is what the files marked "Copyright (c) 1996 S3 Inc." are; even Microsoft's own sample code may be
  distributed only as part of an application, with royalties for other uses, and is "AS IS". So the DDKs are
  copyrighted owner's copies: never committed, never quoted in a committed file, no code, table or register
  sequence copied from them into anything of ours, and never cited as provenance. Dirty-side use only, as a
  map and an oracle; anything that must cross is re-sourced to the data books, PCI-IDS, the standards, or
  observed black-box behaviour on our cards. Read on 11 November 2026. The cross-checks it confirmed, each
  *derived* from S3's driver code and dirty-side only (none of them is needed as provenance):
  - CR59/CR5A are the linear-addressing-window base on the Trio64V2 as well: the Trio32/64 book documents
    them (also settable via PCI BAR0) and the V2 book's "Register Changes" table does not list them; MMIO
    mirrors the VGA registers at base+8000h+port (83C4h/83D4h).
  - The driver writes refresh indexes into CR52 bits 7-4 and CR41 bits 1-0 after a mode set; the books
    define CR41/CR52 as BIOS flag (scratch) registers, so the clean ROM may leave them 0, and driver
    compatibility stays an open black-box question (the planned VGALOG card logs).
  - On the Trio64V2, DDC2/I2C goes through the serial port at MM FF20h (the V2 book's SPCLK/SPD pins,
    programmed via MMFF20), not the CR5C/3C8h wiring the older Trio64 book documents.
  - The driver never touches CR87 bit 1 or SR15 bit 7; the V2 book's 1-cycle linear addressing text and our
    card's rejection of those bits (`docs/775-rom.md`, "Omitted") stand.
  - The driver does not compute the display FIFO M from bandwidth for the Trio64V2; it pins fixed CR54/CR60
    values (INI-overridable), so the 764 book's 9+2*M text (T64-MEM-8) needs no driver-derived constant.
  - Memory size reads CR36 bits 7-5 (000b = 4 MB and down), as the 764 book documents; CR36 bits 3-2 are the
    EDO/SGRAM strapping, as both books document.
  - MCLK is only read back from the PLL registers SR10/SR11 that the BIOS loaded; the default 50.11 MHz is
    public arithmetic (14.31818 MHz x 42 / (3 x 4) = 50.11 MHz, VCO 200.5 MHz, under the 60 MHz 1-cycle EDO
    limit), see [`spec-a-post.md`](docs/cleanroom/spec-a-post.md) POST-22/POST-23; no BIOS provenance needed.
  - Trio64V2 errata noted only there: CR8504 does not read back on the Trio64V2, and planar mode has a CPU
    read problem.

### DirectX 8 SDK (owner's copy, dirty side only)

- [`dx8sdk/`](dx8sdk/) (untracked, in `.gitignore`) is the Microsoft DirectX 8.0 SDK: headers, libraries,
  vendor-neutral samples and the EULAs in `dx8sdk/doc/DirectXEULAs/`. Same posture as the DDKs: the SDK
  EULA licenses, not sells, the product, so the folder is never committed and nothing from it is copied or
  cited as provenance. Its only S3 content is the DXT1/DXT3/DXT5 texture formats, commented "S3 texture
  compression technique" (`d3dxcore.h`, `d3d8types.h`, `ddraw.h`): S3TC, a ViRGE-era feature the Trio64V2
  (86C775) does not have - the V2 book's feature list is 2D acceleration and video only and mentions no
  texture compression at all, and the V+ book's "compressed" refers to Scenic/MX2 video over the LPB.
  No Trio, ViRGE or PCI 5333:8901 reference exists anywhere in the SDK's text; its
  samples are Microsoft's own vendor-neutral code. Noted on 11 November 2026, dirty side only: the SDK has
  no information relevant to the VBIOS work; the S3 driver source for this chip family stays the 98 DDK
  samples recorded above.
