# Backporting to a Trio64V+ BIOS

What of this ROM's changes (2.04.07-p1 to p21, README "Features and changes") could go into a video
BIOS for the Trio64V+ (86C765), and what the Trio64V+ ROM in `rompatch/vplus` carries. Collected on
30 October 2026. The test hardware, a specific Trio64V+ card, is still to come; until its logs exist,
the build is checked in the emulator only.

Scope: VBE 2.0 functions are not backported (linear frame buffer modes, 4F0A, 4F09, 4F06 BL=3 and the
other VBE 2.0 additions). The Trio64V+ BIOSes at hand offer VBE 1.2.

## The build: 1.03-08-p1

    make 765-rom OUT=S3VPP1.BIN             (rompatch/vplus/s3vpatch.py, 32 KB; VSIZE=64 for a 64 KB EEPROM)
    make 765-rom-test ROM=S3VPP1.BIN
    make emu-test ROM=S3VPP1.BIN CHIP=vplus
    make 765-ref-compare ROM=S3VPP1.BIN

Base: the S3 BIOS 1.03-08 ("S3 86C765 Video BIOS", 09/03/96) in `reference/64vplus/1_03_08.bin`, the
upper 32 KB of the Gainward GW503A stock dump (SHA-256 0da79703...). S3's own BIOS for the chip, from the
same 1.0x code base as the Trio64V2 BIOS 1.01.04. A Phoenix Trio64V+ BIOS (1.01-05, 1.02-02) shares
S3's code for the VGA functions (the speed patch signatures match, checked 30 October 2026) but has its
own VBE and mode set code: the booster, 4F05 and mode set hook sites would have to be found anew, as
docs/trio64-backport.md describes for the Phoenix Trio64 BIOSes. The Hercules Graphite Terminator BIOS
D2g (09/19/97, PCI 8811h) matches every signature of 1.03-08, at other addresses.

| Change | In 1.03-08-p1 |
| --- | --- |
| 32-bit video memory stores: S3/VESA mode set clear, VGA mode set clear, font load into plane 2, mode 13h scroll, text scrolls (full width, window moves and blank fills), planar scrolls, AH=09h text | Every routine these patches replace is in 1.03-08 byte for byte: `s3vpatch.py` checks the same signatures as `s3patch.py`, at other addresses, and assembles the same files (`clear32.asm`, `p13*.asm`) with the 1.03-08 addresses of `rompatch/vplus/bios.inc`. wmove and bfilla use the dead bytes after the clear and font load jumps, as in 2.04.07; the rest is in the free block 7AE0h-7D2Dh. |
| Booster: the 64 KB linear window at A0000h in banked packed modes | On at the end of a banked 4F02 and at the first bank switch (4F05 or the window function), as 2.04.07-p18 (`vhooks.asm`). The real base needs no save: 1.03-08 keeps the PCI base (bits 31-24) in CR6B from POST and writes it back to CR59 (CR5A = 00h) at every mode set (1015h); the mode set hook does it too, before the mode set. |
| Windows enhanced mode check | As 2.04.07-p17: no booster while INT 2Fh AX=1600h reports Windows in enhanced mode, asked once per mode set (CR6D = 01h marks the refusal; 1.03-08 does not use CR6D). |
| Fast 4F05h set window | At the INT 10h entry (`vext.asm`): 6 port writes where 1.03-08 needs 10 (the dispatcher unlocks CR38/CR39 twice and saves, sets and restores SR08). 1.03-08 neither keeps the bank at 0040:04FE nor refuses 4F05 with linear addressing on, so neither does the fast path. |
| Attribute controller flip-flop reset after the mode set | In the mode set hook, for AH=00 and 4F02. |
| DCLK VCO inside the datasheet range | Not possible on the Trio64V+, see below. |

The mode 13h scroll keeps EAX on the Trio64V+: the 1.03-08 dispatcher saves only the 16-bit registers,
so the 2.04.07 code (`p12ext.asm`), which uses EAX bits 31-16 without saving them, would hand them back
changed after every AH=06h in mode 13h. The emulator test `vplus_patches` checks it. The same code in
2.04.07-p20 did this through AH=0Eh, which bypasses the 32-bit dispatcher there; fixed in p21.

Checked in the emulator (Trio64V+ model): `make 765-rom-test` (the pinned SHA-256, checksum, every changed
byte at a patch site, the free bytes still 00, the refusals); `make emu-test CHIP=vplus` with 1, 2
and 4 MB, where every test that applies passes, `vplus_patches` and `stores` among them, apart from the
1.03-08 failures below; `make 765-ref-compare`: 2389 calls in the CGA, MDA and EGA modes behave as in
1.03-08. The S3COMPAT logs of the emulator runs (the whole S3COMPAT with 2 and 4 MB, its VBE part, its
VGA part) and the VSHOW /R log are line for line those of 1.03-08, apart from the sign-on. Test coverage
(`make coverage CHIP=vplus`): 87.1 % of the code, every byte of the new code among it.

## The VCO fix: not possible on the Trio64V+

1.03-08 runs the DCLK PLL VCO at 101 MHz in 320x200 at 15, 16 and 32 bpp (10Dh-10Fh): 12.62 MHz with
the post divider at its maximum (R = 3, divide by 8). The datasheet minimum is 135 MHz (PLL-1). The
`s3patch.py` fix raises R and scales M/N for the same pixel clock, but the Trio64V+ R has two bits
(SR12 bits 6-5); the third bit that allows divide by 16 is a Trio64V2 addition (V2-PLL-3). The lowest
DCLK the Trio64V+ reaches with the VCO in range is 135 / 8 = 16.9 MHz, so 12.62 MHz cannot come from a
VCO of 135 MHz or more. Another clock scheme for these modes (twice the clock with doubled pixels) would
change the mode programming, not a PLL value; it was not tried. S3COMPAT keeps its FAIL 200 for the
three modes, as on 1.03-08.

## Left as in 1.03-08

Failures the emulator tests find in 1.03-08 itself, outside the backport; the unpatched 1.03-08 has
them all. On our Trio64V+ ROM the tests pass them with a note (`VPLUS_BASE` in `emu/tests.py`), so any
other failure still shows.

| Test | 1.03-08 behaviour |
| --- | --- |
| errors (1 and 2 MB) | 4F02 sets the modes that need more memory than the card has, which its own 4F01 marks unsupported: with 2 MB 118h (1024x768x16M), 119h and 11Ah (1280x1024x32K/64K), with 1 MB also 107h, 112h, 115h-117h and 120h; a refused mode should leave the video state as it is. With 4 MB the test passes. |
| windows | 4F06 changes the upper halves of EAX, ECX and EDX: it uses 32-bit registers and the 1.03-08 dispatcher saves the 16-bit ones only. The test calls the BIOS the ways Windows does and expects the upper halves kept. |
| s3compat_full | FAIL 200 in 10Dh-10Fh (the VCO above); WARN 50 for 1600x1200, which runs interlaced at 98 Hz, the most the chip allows. With 4 MB also WARN 10 (interlaced) for 118h (1024x768x16M) and 119h/11Ah (1280x1024x32K/64K): non-interlaced, their pixel clocks would be above the Trio64V+ limits for the depth (CLK-1: 50 MHz at 32 bpp, 80 MHz at 15 and 16 bpp; 60 Hz needs 65 and 108 MHz). |

Both 4F02 and 4F06 could be fixed in the ROM (a memory check in the 4F02 mode lookup, a wrapper that
keeps the 32-bit registers around 4F06); neither is part of this backport.

## Does not apply to the Trio64V+

| Change in this ROM | Why not |
| --- | --- |
| FIFO fetch fix (CR90 bit 7 cleared in VGA modes) | CR90/CR91 (primary stream FIFO fetch) exist on the Trio64V2 only; the S3VBEFIX README names the bug for the Trio64V2 and the Trio3D. |
| CR23 = 00h before CR26 = 00h (p19) | CR23 and CR26 are Trio64V2 registers (datasheet section 4.2); 1.03-08 writes neither. |
| POST delay before the engine reset in AX (p20) | It concerns CR88, a Trio64V2/GX register; 1.03-08 has neither that code nor the BX mix-up. |
| DDC delay fix (p19) | The 1.03-08 DDC delay programs PIT channel 0 correctly (control word 36h), so it has not the 2.04.07 latch bug. Its one flaw: each 4F15h call resets the system timer to the standard 18.2 Hz, which a program that sped the timer up would notice. Moving the delay to channel 2, as 2.04.11 does, is optional and minor. |
| LFB base read and linear mode test fixes (p7) | 1.03-08 has no linear frame buffer modes (VBE 1.2): 4F01 returns no base, and its 4F05 and 4F03 do not test CR58. |
| Black level (blank pedestal off) | In this ROM it is SR1A bit 5 through the POST flags; the Trio64V+ data book mentions neither a pedestal control nor SR1A. |
| DCLK VCO at 170 MHz or more | The 170 MHz minimum comes from XFree86 and applies to the Trio64V2 only (V2-PLL-2); the Trio64V+ VCO range is 135-270 MHz (PLL-1). |
| 4F06 BL=3 maximum line length | A VBE 2.0 function, out of scope. |
| 1600x1200 at 60 Hz | The Trio64V+ reaches 135 MHz only with clock doubling (CLK-1), so 1600x1200 runs interlaced on it. |

## Depends on the card

| Change in this ROM | What decides it |
| --- | --- |
| MCLK 59.96 MHz | 1.03-08 picks its MCLK by the strapped memory type: 52.79 MHz (SR10 = 42h, SR11 = 39h, entry A8h) for 1-cycle EDO, 59.96 MHz (A6h) for fast page and 2-cycle EDO. 1.03-08-p1 keeps both; `make 765-rom MCLK=... [MEMTYPE=edo1|fpm]` sets one, at most 60 MHz (MEM-1; README "MCLK build option"). Whether the memory of a card runs at a higher clock is decided on that card, with the VRAM test of S3COMPAT. |
| Memory size | 1, 2 or 4 MB in the data book. 1.03-08 sizes the memory at every POST (0E80h: 4 MB, then 2 MB, else 1 MB, written to CR36 bits 7-5), so a card upgraded from 1 to 2 MB needs no other ROM. The emulator tests run with 1, 2 and 4 MB. |

## Already right in 1.03-08

- 1280x1024 defaults to 60 Hz (108 MHz), 640x480 has 800 pixels per line (VESA DMT), 640x400 runs
  at 70 Hz.
- The 8x14 font is in the ROM (AX=1130h BH=2 and mode 10h pass).
- 1.03-08 has no 320x240, 400x300 or 512x384 modes, so the changes of this ROM to them (320x240 at
  60 Hz, CR50 for 512x384) have nothing to apply to; adding such modes would be a new feature, not a
  backport.
- 1600x1200 (120h) runs interlaced (98 Hz field rate, S3COMPAT WARN 50), the most the chip allows.

## S3COMPAT on 1.03-08 (emulator, Trio64V+ model)

133 passed, 6 failed, 3 warnings, 13 INFO. Of the failures, three are emulator limits that this ROM
shows too (104h and 106h judge planar memory above 64 KB, 4F05 the banked window: the model has
neither), and three are the low DCLK VCO in 10Dh-10Fh above. The warnings: AH=12h BL=20h (alternate
print screen, as in this ROM), 1600x1200 interlaced, and the LFB modes, which VBE 1.2 does not have.
4F14h (S3 OEM functions) and 4F0A are not offered.

## Per-call costs (emulator): 1.03-08, 1.03-08-p1 and 2.04.07-p20

Port accesses and video memory stores (bytes / words / dwords) per INT 10h call.

| Call | 1.03-08 | 1.03-08-p1 | 2.04.07-p20 |
| --- | --- | --- | --- |
| Mode set 03h | 4096 / 16536 / 0 | 0 / 152 / 9216 | 0 / 152 / 9216 |
| Mode set 13h, 12h | 0 / 32768 / 0 | 0 / 0 / 16384 | 0 / 0 / 16384 |
| 4F02 101h with clear (2 MB) | 0 / 1048576 / 0 | 0 / 0 / 524288 | 0 / 0 / 524288 |
| 4F05 set window | 16 port accesses | 9 port accesses | 9 port accesses |
| AH=06h scroll, mode 03h | 0 / 80 / 960 | 0 / 0 / 1000 | 0 / 0 / 1000 |
| AH=06h scroll, mode 13h | 0 / 32000 / 0 | 0 / 0 / 16000 | 0 / 0 / 16000 |
| AH=06h clear, mode 12h | 38400 / 0 / 0 | 0 / 0 / 9600 | 0 / 0 / 9600 |
| AH=09h, 80 characters, mode 03h | 0 / 80 / 0 | 0 / 0 / 40 | 0 / 0 / 40 |
| Font load 8x16 (AX=1114h) | 4096 / 0 / 0 | 0 / 0 / 1024 | 0 / 0 / 1024 |

The mode sets of 1.03-08-p1 take 10 port accesses more than 1.03-08 (the hook), a banked 4F02 30 more
(the hook and the booster).

Palette loads, pixels, AH=0Eh and the graphics-mode AH=09h are equal in all three.

## Pending

- The test card: S3TEST and S3COMPAT logs from it with 1.03-08 and 1.03-08-p1. If its BIOS is not
  1.03-08, the base and the addresses follow that BIOS.
- S3TEST has a Trio64V+ test set (since 30 October 2026): on a Trio64V+ it expects VROMVER
  (1.03-08-p1) and checks this ROM's patches (README "Other Trio64-family BIOSes"). S3COMPAT and VSHOW
  apply as they are.

## Test cards

The cards at hand (30 October 2026); their stock BIOSes are to be dumped before anything is flashed.

| Card | Chip | Memory | FCC ID | This ROM |
| --- | --- | --- | --- | --- |
| STB (1995), H0A3CC | Trio64V+ 86C765 | 2 MB | EKSUSA765PCI | 1.03-08-p1 applies to the chip; the STB stock BIOS may be an STB build of another S3 version |
| Gainward VGA-GW503 (1996) | Trio64V+ | 2 MB EDO (the board maximum) | ICUVGA-GW503 | the likely source of 1.03-08 (the GW503A dump carries it in its upper half) |
| Hercules Terminator 64 | Trio64V+ | 2 MB | ICUVGA-GW503C | probably the same board family: the FCC ID has the grantee code and board name (ICU, GW503) of the Gainward cards |
| ExpertColor DSP-3364P (1994), E0A2AA | Trio64 86C764X | 2 MB fast page: four Mosel Vitelic V53C16256H-50 (256K x 16, 50 ns, 512 refresh cycles in 8 ms), two soldered (date 9602) and two in sockets (the upgrade from 1 MB); CR36 = 8Eh (fast page) | LUT-DSP3364P | none: a Trio64, not a Trio64V+. Do not flash 1.03-08-p1 on it. The tools run on it; S3TEST runs only the tests that need no ROM of ours |
| Gainward Genesis EV | Trio64V2/DX | 2 MB EDO | ICUVGA-GW503A | the Trio64V2 ROM (2.04.07-pN): the test card |

On the Trio64 the data book allows EDO only with 1 or 2 MB (fast page memory for 4 MB, T64-MEM-3).
Before flashing a Trio64V+ card, compare its stock BIOS with 1.03-08: the board flags, the subsystem ID
and the MCLK table may differ between makers.
