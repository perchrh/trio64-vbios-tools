# Backporting to a Trio64V+ BIOS

What of this ROM's changes (2.04.07-p1 to p20, README "Features and changes") could go into a video
BIOS for the Trio64V+ (86C765). Collected on 30 October 2026; the test hardware, a specific Trio64V+
card, is still to come, so the base BIOS is not settled yet.

Scope: VBE 2.0 functions are not backported (linear frame buffer modes, 4F0A, 4F09, 4F06 BL=3 and the
other VBE 2.0 additions). The Trio64V+ BIOSes at hand offer VBE 1.2.

## Assumed base: S3 Trio64V+ BIOS 1.03-08

The S3 BIOS 1.03-08 ("S3 86C765 Video BIOS", 09/03/96), as in the upper 32 KB of the Gainward
GW503A stock dump, is assumed as the base: S3's own BIOS for the chip, from the same 1.0x code base as
the Trio64V2 BIOS 1.01.04. A Phoenix Trio64V+ BIOS (1.01-05, 1.02-02) is another code base: none of the
patch sites below would match it, and the work would start over.

## Fits directly

| Change in this ROM | Why it fits the Trio64V+ |
| --- | --- |
| 32-bit video memory stores (p11-p14): S3/VESA mode set clear, VGA mode set clear, font load into plane 2, mode 13h scroll, text scrolls (full width, window moves and blank fills), planar scrolls, AH=09h text | Every routine these patches replace is in 1.03-08 byte for byte (the `s3patch.py` signatures match), at other addresses. The patch code can be reused with the 1.03-08 addresses. |
| Booster: the 64 KB linear window at A0000h in banked modes, with the real base kept and restored at the next mode set | Not a VBE 2.0 function but a speedup of banked modes. The Trio64V+ data book documents the linear addressing registers (CR58, CR59/CR5A), and S3VBEFIX applies the booster to Trio64/V+ cards with VBE 1.2 BIOSes. The Windows enhanced mode check (p17/p18) comes with it. |
| Fast 4F05h set window | 4F05h is a VBE 1.2 function. |
| Attribute controller flip-flop reset after the mode set | Plain VGA behaviour, the same on every chip. |
| DCLK VCO inside the datasheet range | 1.03-08 runs the DCLK PLL VCO at 101 MHz in 320x200 at 15, 16 and 32 bpp (10Dh-10Fh), below the 135 MHz datasheet minimum (PLL-1; S3COMPAT FAIL 200). The VCO fix of `s3patch.py` (a larger post divider R and new M/N for exactly the same pixel clock) corrects it, with the Trio64V+ range 135-270 MHz instead of the Trio64V2 one. |

## Does not apply to the Trio64V+

| Change in this ROM | Why not |
| --- | --- |
| FIFO fetch fix (CR90 bit 7 cleared in VGA modes) | CR90/CR91 (primary stream FIFO fetch) exist on the Trio64V2 only; the S3VBEFIX README names the bug for the Trio64V2 and the Trio3D. |
| CR23 = 00h before CR26 = 00h (p19) | CR23 and CR26 are Trio64V2 registers (datasheet section 4.2); 1.03-08 writes neither. |
| POST delay before the engine reset in AX (p20) | It concerns CR88, a Trio64V2/GX register; 1.03-08 has neither that code nor the BX mix-up. |
| DDC delay fix (p19) | The 1.03-08 DDC delay programs PIT channel 0 correctly (control word 36h), so it has not the 2.04.07 latch bug. Its one flaw: each 4F15h call resets the system timer to the standard 18.2 Hz, which a program that sped the timer up would notice. Moving the delay to channel 2, as 2.04.11 does, is optional and minor. |
| Black level (blank pedestal off) | In this ROM it is SR1A bit 5 through the POST flags; the Trio64V+ data book mentions neither a pedestal control nor SR1A. |
| DCLK VCO at 170 MHz or more | The 170 MHz minimum comes from XFree86 and applies to the Trio64V2 only (V2-PLL-2); the Trio64V+ VCO range is 135-270 MHz (PLL-1). |
| 4F06 BL=3 maximum line length | A VBE 2.0 function, out of scope. |
| 1600x1200 at 60 Hz | The Trio64V+ reaches 135 MHz only with clock doubling (CLK-1), so 1600x1200 runs interlaced on it. |

## Depends on the card

| Change in this ROM | What decides it |
| --- | --- |
| MCLK 59.96 MHz | 1.03-08 sets 52.79 MHz (SR10 = 42h, SR11 = 39h). 59.96 MHz is within the Trio64V+ limit of 60 MHz (MEM-1), but whether the memory of a card runs at it is decided on that card, with the VRAM test of S3COMPAT. |

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

## Per-call costs (emulator): 1.03-08 against 2.04.07-p20

Port accesses and video memory stores (bytes / words / dwords) per INT 10h call.

| Call | 1.03-08 | p20 |
| --- | --- | --- |
| Mode set 03h | 4096 / 16536 / 0 | 0 / 152 / 9216 |
| Mode set 13h, 12h | 0 / 32768 / 0 | 0 / 0 / 16384 |
| 4F02 101h with clear (2 MB) | 0 / 1048576 / 0 | 0 / 0 / 524288 |
| 4F05 set window | 16 port accesses | 9 port accesses |
| AH=06h scroll, mode 03h | 0 / 80 / 960 | 0 / 0 / 1000 |
| AH=06h scroll, mode 13h | 0 / 32000 / 0 | 0 / 0 / 16000 |
| AH=06h clear, mode 12h | 38400 / 0 / 0 | 0 / 0 / 9600 |
| AH=09h, 80 characters, mode 03h | 0 / 80 / 0 | 0 / 0 / 40 |
| Font load 8x16 (AX=1114h) | 4096 / 0 / 0 | 0 / 0 / 1024 |

The same numbers as the reference 2.04.07 gives for these calls: the p11-p14 speed patches would bring
1.03-08 the same reduction. Palette loads, pixels, AH=0Eh and the graphics-mode AH=09h are equal.

## Pending

- The test card: its BIOS (S3 1.03-08 or another) decides the base and the addresses; S3TEST and
  S3COMPAT logs from it.
