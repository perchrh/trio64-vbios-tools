# Trio64V2/DX VBIOS test tools

DOS tools written while modifying the video BIOS of a Gainward S3 Trio64V2/DX card
(86C775, 2 MB EDO 40 ns, board ICUVGA-GW503A, PCI 5333:8901). The current ROM is 2.04.11-p12.
The ROM image itself is not in this repository; the changes it carries are described below.

All tools share one version number, currently 0.8 (set in `common/version.inc`), and print it on their first line of output.
All tools need a 386 or later and run in plain DOS (no EMM386 needed), except S3REGS32.EXE, which
is for the Windows 9x desktop.

| Tool | Purpose | Run |
| --- | --- | --- |
| VSHOW.COM | VESA mode viewer: test picture, measured refresh and line frequency, LCD line pattern, interactive menu, run through all modes | `VSHOW /H` for the parameter list |
| S3TEST.COM | Regression test for the ROM patches (signature, clocks, EDO, pedestal, refresh and line length, booster, LFB, 4F05/4F06, CR50, flip-flop) | `S3TEST > S3TEST.LOG` |
| S3ALIAS.COM | TSR for Pinball Illusions' S3 driver: INT 10h AH=00 mode 49h becomes 59h (640x480x8), 4Bh becomes 5Ah (800x600x8) | `S3ALIAS` before starting the game, `S3ALIAS /U` to unload, `/H` for help; not with S3TEST or S3COMPAT |
| VGALOG.COM | TSR that logs every INT 10h AH=00 mode set and VBE 4F01/4F02/4F06 call of any program to VGALOG.BIN, committed before and after each call, so it survives a freeze. `/M` keeps the last 1024 INT 10h calls of any kind (not text output) in memory instead, for Windows 9x; `/D` writes them | `VGALOG` (or `VGALOG /M`), then start the program; `VGALOG /D` to write the memory log, `VGALOG /U` to unload, `/H` for help; record formats in `vgalog/vgalog.asm` |
| S3REGS.COM | Register snapshot (SR, CR, GR, PCI, BIOS and VBE mode) appended to S3REGS.TXT, with a label; changes nothing | `S3REGS label` |
| S3REGS32.EXE | The same snapshot from the Windows 9x desktop (Win32 console program), and `/W n` logs every register change for n seconds | `S3REGS32 label`, `S3REGS32 /W 60 label` |
| S3COMPAT.COM | VGA/SVGA/VESA compatibility test: IBM reference registers and palettes, 350-line text modes, VGA BIOS functions, every VESA mode, datasheet rules, VRAM | `S3COMPAT > S3COMPAT.LOG` (`/Q` skips the VRAM test; VSHOW shows single modes) |

Each source file starts with a header that says what is tested and which outcome is expected, and
each test routine has a comment block with its fail and warn bits.

All tools share one version number and S3TEST checks for one ROM version; both are set in
`common/version.inc` (`VERSION`, `ROMVER`) and can be overridden for a build, for example
`make clean && make VERSION=0.9 ROMVER=2.04.11-p13`.

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

## VBIOS changes in 2.04.11-p12

p12 differs from the stock 2.04.11 dump in the lower 32 KB only. The upper 32 KB (Trio64V+ BIOS
1.03-08, for an older card) is byte-identical to stock, both halves checksum to 0, and every change
keeps the standard VGA and VESA modes compatible. The RAM stays in 1-cycle EDO mode. About 57 bytes of the
lower 32 KB are still free (0x7F58-7F70, 0x7FAF-7FBF, 0x7FE3-7FEF, 0x7E3E-7E3F). p10 (an extra
VESA mode 182h, 320x400x8) was withdrawn and is in neither p11 nor p12.

| Area | Change | Effect |
| --- | --- | --- |
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
| Mode set clear | The 2 MB video memory clear of every S3/VESA mode set (p11) writes 32-bit words (rep stosd) instead of 16-bit ones, through the same 64 KB banks | Half the bus transactions; the clear is most of the 81 ms a mode set took on p9 (no change with the no-clear bit) |
| VGA mode set (p12) | The clear of video memory in modes 00h-13h (2C38h) and the font load into plane 2 (1224h, every text mode set and AX=11xxh) write 32-bit words | Mode set 03h about half the video memory writes (9368 instead of 20632), modes 12h/13h 16384 instead of 32768 |
| VBE 4F05 (p12) | AX=4F05h BH=0 (set window) is handled at the INT 10h entry: unlock, CR58 test (refused in linear modes as before), SR04 for planar banks, CR6A; the 3C4h index is kept | 6 port writes and 3 reads instead of 13 writes and about 6 reads (15 us per call on the card with p9); get, errors and the window function (far call) are unchanged |
| Mode 13h scroll (p12) | AH=06h moves and fills with 32-bit words, full screen and windows; AH=07h keeps the original code | Half the video memory reads and writes |
| 512x384x8 (151h) | CR50 table byte 60h to 40h | Correct graphics engine pixel length (was the reserved 10b) |
| VBE 4F06 BL=3 | Rewritten: BX = min(8184, memory / lines) rounded down to 8, CX = BX in pixels | Real maximum line length (4368 for 101h instead of 546) |

### Byte-level changes

Offsets are in the 64 KB image (C000:offset when shadowed); everything from 0x8000 up is untouched.

| Offset | Stock | p12 | Purpose |
| --- | --- | --- | --- |
| 0x0079 | 2.04.11 | 2.04.11-p12 | Sign-on string (copyright line moved into the padding before 0x00AB) |
| 0x00C7-00C8 | 28 41 | 41 42 | MCLK PLL at POST: SR11 (M) = 41h, SR10 (N/R) = 42h |
| 0x00D1 | 07 | 05 | POST flags: bit 1 (blank pedestal) cleared |
| 0x00DE | 08 | 88 | CR41 refresh fields: 1280 field = 4 (60 Hz) |
| 0x00DF | 80 | 81 | CR52 refresh fields: 1600 field = 1 (60 Hz) |
| 0x04C1-04C4 | 5E 4F 50 81 | 5F 4F 50 82 | 640x480x8/x32 @ 60 Hz: line total 800, blank end moved |
| 0x089F-08A3 | C1 03 82 48 33 | 40 7E 82 3C 28 | 320x240x8 refresh entry: CRTC table 0x7E40, 60 Hz, PLL 25.06 MHz |
| 0x08AD-08B1 | F5 0C 82 48 33 | 60 7E 82 3C 28 | 320x240x15/16 refresh entry: CRTC table 0x7E60, 60 Hz |
| 0x095C | 60 | 40 | CR50 for 512x384x8 / x32 |
| 0x0B1A-0B1D | C2 9F A0 85 | C3 9F A0 86 | 640x480x15/16 @ 60 Hz: line total 800 |
| 0x1224-1226 | push ax / push cx / mov cl,bh | jmp 7D82 | Font load: 32-bit copy per character (p12) |
| 0x143D-1441 | mov es,[cs:1D53] | jmp 7FC0, nop x2 | Mode set clear: bank loop with rep stosd at 0x7FC0 |
| 0x211A-211C | cmp ah,0Eh | jmp 7CFB | INT 10h entry: fast 4F05 BH=0 (p12) |
| 0x2C38-2C3A | xor bl,bl / mov es,bx | jmp 7D62 | VGA mode set clear with rep stosd (p12) |
| 0x3200-3202 | cmp cx,[044Ah] | jmp 7D9E | Mode 13h scroll: 32-bit AH=06h (p12) |
| 0x20DE-20DF | 86 26 | 80 7E | INT 10h AH=00 jump table entry: mode set via the hook at 0x7E80 |
| 0x56FE-5700 | call 2686 | call 7E80 | VBE 4F02: mode set via the hook |
| 0x5718-571D | mov word [4FE],0 | call 7EF0, nop x3 | VBE 4F02 end: booster |
| 0x59DC-59E0 | mov ax,3FF / xor dx,dx | call 7F71 / jmp 59D9 | VBE 4F06 BL=3: corrected routine |
| 0x5CF4-5CF7 | mov ax,bx / or ax,ax | call 7F3E / nop | LFB base read: real base from CR6D while the booster is on |
| 0x5D12-5D14 | and ax,1000h | call 7F4F | 4F05/4F03 linear-mode test ignores the booster's 64 KB window |
| 0x7E40-7E58 | 00 | CRTC table | 320x240x8 @ 60 Hz |
| 0x7E60-7E78 | 00 | CRTC table | 320x240x15/16 @ 60 Hz |
| 0x7E80-7F57 | 00 | code | Mode set hook, LFB base restore, booster, base fix, linear test |
| 0x7F71-7FAE | 00 | code | 4F06 BL=3 routine |
| 0x7CFB-7E3D | 00 | code | p12: fast 4F05 (7CFB), VGA clear (7D62), font load (7D82), mode 13h scroll (7D9E); source `p12ext.asm` with the ROM build |
| 0x7FC0-7FE2 | 00 | code | Mode set clear: 16384 x rep stosd per 64 KB bank (CR6A), EAX kept for the caller |
| 0x7FFF | 77 | AA | Checksum of the lower 32 KB |

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

- The 8x14 font is missing in the stock BIOS (S3COMPAT WARN 01 for AX=1130h BH=2 and mode 10h).
- An LFB is offered on the planar mode 104h (S3COMPAT WARN 20), as in stock.
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
