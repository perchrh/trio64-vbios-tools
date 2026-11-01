# Plan: the slim SeaVGABIOS on the Trio64 card

How the slimmed SeaVGABIOS (branch `claude/slim-vgabios` of perchrh/seabios_fork, 26320 bytes with
VBE) becomes a video BIOS for the ExpertColor DSP-3364P (S3 86C764X Trio64, 2 MB fast page memory) under
the clean-room rules of `docs/clean-room.md`. Written 1 November 2026; nothing here is started yet.

## Scope of the first version

- The standard VGA functions (INT 10h AH=00h-1Ch) from SeaVGABIOS as they are.
- VBE 1.2: 4F00-4F08 for the packed modes 100h-117h that the 2 MB card can show at 60 Hz or more, banked
  through a 64 KB window at A0000h. No VBE 2.0 (no linear frame buffer field, no protected-mode
  interface), no 4F10 (power management), no 4F15 (DDC); `docs/clean-room.md` "Scope".
- SeaVGABIOS's fonts (8x8, 8x14, 8x16). Its 9x14 and 9x16 alternate tables are empty placeholders, so
  the 9-dot text modes use the 8-dot glyphs with the VGA's ninth-column rule; FreeDOS cpidos fonts and
  derived 9-dot glyphs can follow.
- 32 KB, built twice into the 64 KB EEPROM image (the board maps the upper half, #78).

## What SeaVGABIOS lacks for the Trio64

The S3 vendor functions are only a part. In order of need:

1. **Chip start-up at POST** (data book sections 5, 9, 13; `docs/chip-rules.md`):
   - Unlock the S3 registers (SR08 = 06h, CR38 = 48h, CR39 = A5h) and leave the lock as the chip had it
     at the end of every call, as the Phoenix BIOS and Windows' driver expect.
   - Memory size found by test and written to CR36 bits 7-5 (data book 5.1: the BIOS determines it,
     boards need not strap it; 1, 2 or 4 MB), the memory type from CR36 bits 3-2 (strapped, never written); CR68 (strapped timings) left alone.
   - The memory clock: SR10/SR11 with the SR15 load sequence (PLL-1, PLL-2). The card's own value is
     69.8 MHz (22h 25h); the build option and the known pairs of `s3patch.KNOWN_MCLK_8811` carry over.
   - The PCI base: CR59/CR5A from PCI BAR0 (the Windows 9x S3 driver reads them, README "Windows 9x
     driver test"); CR58 linear addressing off at POST.
   - Enhanced mode setup: CR40 bit 0, CR31, CR32, CR33, CR34 (CR3B enable), CR3A, CR43, CR53, CR66;
     the graphics engine reset and BEE8h index D and E written before the first engine command
     (ENG-1).
   - Refresh (CR3A), the display FIFO start (CR3B = CR00 - 5, T64-MEM-2).
2. **The S3 mode set** (an `s3trio.c` module next to `clext.c`, the Cirrus module, as the pattern):
   - The VESA modes' CRTC timings from VESA DMT (640x480, 800x600 and 1024x768 at 60 Hz or more,
     1280x1024 at 60 Hz in 8 bpp only on 2 MB), with the S3 overflow registers CR5D and CR5E.
   - The pixel clock: SR12/SR13 computed from the DMT clock (PLL-1, PLL-2, the 135-270 MHz VCO), MISC
     bits 3-2 = 11b, clock doubling for 8 bpp above 80 MHz (CLK-1).
   - The colour mode: CR67 (8, 15, 16, 24 bpp), CR50 (screen width and pixel length), CR13/CR51 (pitch),
     CR31/CR32 (memory mapping), CR58 (window size).
   - The display FIFO: CR54 (M) and CR60 (N) from the bandwidth, the formula of our ROM p3 (6 MCLKs per
     access, #82), written with the screen off (T64-MEM-1).
   - Back to VGA: the S3 registers reset so that modes 00h-13h behave as on a plain VGA.
3. **VBE 1.2**: SeaVGABIOS's `vbe.c` reports VBE 3.0. For 1.2: version 0102h, the 1.2 info block
   (no OEM software rev, vendor or product strings beyond the OEM string), 4F01 without the 2.0 fields,
   4F05 and the far window function setting CR6A (bank) with CR31/CR35/CR51 as the data book says,
   4F06/4F07 (logical width CR13/CR51, display start CR0C/CR0D/CR31/CR69), 4F08 (DAC width: 8 bits
   only if the data book's RAMDAC section allows it, otherwise 4F08 answers 6).
4. **The conventions programs and drivers rely on** (`docs/clean-room.md` item 5): CR59/CR5A hold the
   PCI base; the VGA register state after 4F02 as the S3 Windows 9x driver expects (its sequence is in
   the emulator test `windows`); the sequencer and CRTC indexes as found after every call.
5. **The S3 mode numbers** (AH=00h with 4Fh and up, for example 49h/4Bh that Pinball Illusions uses,
   README) and **4F14h** (the S3 OEM functions, `docs/chip-rules.md` "S3 OEM functions"): a second
   step, from the behaviour our tools log, not from BIOS code.
6. **The PCI ROM header and sign-on**: vendor 5333h, device 8811h, class 030000h, one 32 KB image;
   SeaVGABIOS's slim config builds QEMU's IDs and no sign-on string.

Optional later: the booster (64 KB linear window for banked modes), VBE 2.0, 4F15 DDC (the board's GOP
wiring is still open, `docs/trio64-backport.md` "Pending"), 4F10.

## Size budget

| Part | Bytes (estimate) |
| --- | --- |
| Slim SeaVGABIOS with VBE today | 26320 |
| VBE 3.0 to 1.2 (smaller info blocks) | -200 |
| POST start-up (unlock, MCLK, base, enhanced setup, engine reset) | 500-700 |
| S3 mode set (DMT timing table for about 10 modes, PLL computation, colour modes, FIFO M) | 1500-2000 |
| 4F05 bank and window function, 4F06/4F07 extensions | 200-300 |
| PCI header, sign-on | 100 |
| Total | about 28500-29200 of 32768 |

The first step fits without more slimming; the S3 mode numbers and 4F14h (step 5) take the rest.

## Clean-room steps

1. The dirty side (this repository) writes the specification for items 1-6 as behaviour, from the
   data book, `docs/chip-rules.md`, `docs/bios-rules.md` and black-box logs of the reference ROM in the
   emulator; the leak review reads it (`docs/clean-room.md` "The process").
2. The clean side writes `vgasrc/s3trio.c` and the Kconfig entry `VGA_S3TRIO` in the SeaBIOS fork from
   the specification, the data book and SeaVGABIOS (LGPLv3, used under its licence).
3. Tests before the card:
   - The emulator's Trio64 model (`emu/`, `--chip trio64`) runs POST and every mode; S3TEST, S3COMPAT and
     VSHOW run on it (`make emu-test ROM=... CHIP=trio64`; tests tagged `patch` are skipped for a ROM
     that is not ours).
   - `scripts/vgaemu_check.py` (seabios_fork) compares the standard functions with the plain build.
   - The similarity check against Phoenix 1.5-07 and the S3 ROMs (no long identical byte runs).
4. On the card, with a way back:
   - Keep the card's own ROM image and a second graphics card (or a machine that can flash the card
     blind) at hand, as for every ROM so far.
   - Flash the 64 KB image (the 32 KB twice), cold boot, then RUNALL (S3TEST, S3COMPAT, VSHOW /R, VGALOG,
     S3REGS), the games of the earlier runs and Windows 98 with video playback.

## Upstream slimming changes (SeaBIOS)

Already prepared on branches of the fork (`upstream/vga-no-direct-modes`, 1792 bytes;
`upstream/vbe-no-edid`, 384 bytes). Further candidates, simplest first, sizes from the slim build:

| Change | Saving | Size of the change | Why it is easy to check |
| --- | --- | --- | --- |
| A separate debug level for the VGA BIOS (`VGA_DEBUG_LEVEL`, default the main `DEBUG_LEVEL`), so the system BIOS can keep its debug output while the VGA ROM drops its own | 2766 | Kconfig option and one `#define` | no code path changes; default unchanged |
| The four default palettes computed at use instead of stored as tables | 960 | one file, `stdvga.c` | the generated values can be compared byte for byte with the old tables by a test script |
| An opt-in `VGA_OPTIMIZE_SIZE` (-Oz and five flags that make 16-bit code larger when on) | 670 | Kconfig option and Makefile flags | opt-in; gcc-version dependent, which the maintainers may want measured |
| The mode registers kept once, in the static video parameter table | 1048 | about 440 lines in `stdvga.c`/`stdvgamodes.c` | larger; the emulator trace and QEMU screendumps show no change, but the review takes longer |

Not proposed: reaching the BIOS data area through %gs (-328 bytes, but a new rule for every entry point
and a risk for other hardware types).
