# Part B, item 2: the S3 mode set (VBE 1.2 packed modes) and the return to VGA

Behaviour specification for the clean-room Trio64 BIOS (`docs/seavgabios-trio64.md`, "What SeaVGABIOS
lacks", item 2): what a mode set must program for the packed VBE 1.2 modes 100h-117h on the S3
86C764X Trio64 (the ExpertColor DSP-3364P: 2 MB of fast page memory; 1 and 4 MB boards too), and what
a mode set of a standard mode 00h-13h must undo afterwards. Written 1 November 2026 on the dirty side
from the Trio32/Trio64 data book, VESA DMT, the IBM VGA references and VGADOC; nothing here comes from
a BIOS image or BIOS source. Every value is a rule or the result of a formula given here; the tables
of derived values can be recomputed from the rules.

## Conventions

- **Format** as `docs/bios-rules.md`: | ID | Rule | Source | Strength | Checked by |.
- **IDs.** `MODE-` followed by a number from 101 on. `docs/bios-rules.md` already uses MODE-1 to
  MODE-13 for the standard mode definitions, and an ID is never reused, so this part starts at
  MODE-101. `MQ-n` are the open questions of this part.
- **Strength.** *must*: the data book says must, never or gives a hard limit, or a standard (DMT, IBM)
  fixes the value; a violation is a FAIL. *should*: the data book recommends it, or it is the choice
  this specification makes among valid ones; a WARN at most. *derived*: a formula of ours resting on
  the data book's description (the display FIFO M); a card run is the final check. *note*: information.
- **Sources.** T32/64 = S3 Trio32/Trio64 data book, March 1995 (section, table or register); rule IDs
  of `docs/chip-rules.md` (PLL-1, CLK-1, T64-MEM-1, ...); DMT = VESA Display Monitor Timing standard
  1.0 rev. 0.7 (the published timings below are industry figures); IBM = the IBM VGA register values as
  `docs/bios-rules.md` cites them (VGATEST); VGADOC = `standards/thoegersen/` (S3.TXT, VGAREGS.TXT);
  VBE 1.2 = the VESA BIOS Extension 1.2.
- **Checked by.** S3COMPAT lines run in the emulator and on the card: 'VBE VESA nnnn' (one line per
  mode; fail bits 10 refresh outside 56-90 Hz, 100 CRTC geometry vs 4F01, 200 data book colour mode and
  clock rules, 400 refresh vs the rate the registers predict, 800 memory mapping rules, 1000 data book
  register rules; WARN 02 DCLK above the data book maximum, 10 interlace, 40 default rate not DMT) and
  'Mode nnh' / 'Mode nnh after xxxx' (the VGA modes, from a clean state and after a VESA mode). S3TEST
  'VBE Mode nnnn' lines (status, measured refresh, line total). Emulator tests of `emu/tests.py`
  (t_s3compat_vbe, t_s3compat_vga, t_s3compat_full, t_errors, t_windows, t_t64_patches) with
  `--chip trio64`. "not checked" names the test that would.
- **ASCII only**, as every document of the project.

## Terms

- **Pixel clock**: the DMT (or IBM) clock of the timing, in MHz.
- **DCLK**: the output of the DCLK PLL, fREF x (M+2) / ((N+2) x 2^R), fREF = 14.31818 MHz, programmed
  in SR12 (N bits 4-0, R bits 6-5) and SR13 (M bits 6-0) (PLL-1, PLL-2). In every mode of this part
  DCLK is programmed to the pixel clock.
- **VCLK**: the clock that latches pixels into the RAMDAC: DCLK, or DCLK / 2 with SR15 bit 4 = 1
  (T32/64 9.3).
- **Colour mode**: CR67 bits 7-4 (T32/64 table 8-1): mode 0 (0000b, 8 bpp, one pixel per VCLK),
  mode 8 (0001b, 8 bpp clock-doubled, two pixels per VCLK), mode 9 (0011b, 15 bpp), mode 10 (0101b,
  16 bpp), mode 13 (1101b, 24-bit colour in 4 bytes, the upper byte unused; CR50 bits 5-4 = 11b).
- **B**: bytes per pixel in memory: 1 (modes 0 and 8), 2 (modes 9 and 10), 4 (mode 13).
- **Character clock (CC)**: the unit of every horizontal CRTC register (T32/64 table 11-2). **PPC**:
  pixels per character clock; **DPC**: DCLK periods per character clock (MODE-109).
- **Timing** of a mode: pixel clock; horizontal active, front porch, sync width, back porch (pixels)
  and sync polarity; vertical active, front porch, sync width, back porch (lines) and polarity. Totals:
  Htotal = sum of the four horizontal values, Vtotal likewise.

## Mode table

The VBE 1.2 mode numbers 100h-117h (VBE 1.2 mode list). "Offered" are the packed modes this part
covers; their memory need is pitch x YRes with pitch = XRes x B (MODE-125). Fits: the mode needs at
most that much video memory (1 MB = 1048576 bytes).

| Mode | Resolution | Colours | B | Colour mode (CR67 7-4) | Pitch (bytes) | Memory (bytes) | 1 MB | 2 MB | 4 MB | Timing (MODE-104) | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 100h | 640x400 | 256 | 1 | 0 (0000b) | 640 | 256000 | yes | yes | yes | IBM 400-line, 70 Hz | offered |
| 101h | 640x480 | 256 | 1 | 0 | 640 | 307200 | yes | yes | yes | DMT 640x480 60 Hz | offered |
| 102h | 800x600 | 16 (planar) | - | - | 100 per plane | 240000 | yes | yes | yes | - | not a packed mode: part C (VBE-10) |
| 103h | 800x600 | 256 | 1 | 0 | 800 | 480000 | yes | yes | yes | DMT 800x600 60 Hz | offered |
| 104h | 1024x768 | 16 (planar) | - | - | 128 per plane | 393216 | yes | yes | yes | - | not a packed mode: part C (VBE-10) |
| 105h | 1024x768 | 256 | 1 | 0 | 1024 | 786432 | yes | yes | yes | DMT 1024x768 60 Hz | offered |
| 106h | 1280x1024 | 16 (planar) | - | - | 160 per plane | 655360 | - | - | - | - | not offered (MODE-102) |
| 107h | 1280x1024 | 256 | 1 | 8 (0001b), clock-doubled | 1280 | 1310720 | no | yes | yes | DMT 1280x1024 60 Hz | offered with 2 or 4 MB |
| 108h-10Ch | text 80x60, 132x25, 132x43, 132x50, 132x60 | 16 | - | - | - | - | - | - | - | - | text modes: outside this part (MQ-9) |
| 10Dh, 10Eh, 10Fh | 320x200 | 32K, 64K, 16M | 2, 2, 4 | - | - | - | - | - | - | - | not offered (MODE-102) |
| 110h | 640x480 | 32K (5:5:5) | 2 | 9 (0011b) | 1280 | 614400 | yes | yes | yes | DMT 640x480 60 Hz | offered |
| 111h | 640x480 | 64K (5:6:5) | 2 | 10 (0101b) | 1280 | 614400 | yes | yes | yes | DMT 640x480 60 Hz | offered |
| 112h | 640x480 | 16M (8:8:8) | 4 | 13 (1101b) | 2560 | 1228800 | no | yes | yes | DMT 640x480 60 Hz | offered with 2 or 4 MB |
| 113h | 800x600 | 32K | 2 | 9 | 1600 | 960000 | yes | yes | yes | DMT 800x600 60 Hz | offered |
| 114h | 800x600 | 64K | 2 | 10 | 1600 | 960000 | yes | yes | yes | DMT 800x600 60 Hz | offered |
| 115h | 800x600 | 16M | 4 | 13 | 3200 | 1920000 | no | yes | yes | DMT 800x600 60 Hz | offered with 2 or 4 MB |
| 116h | 1024x768 | 32K | 2 | 9 | 2048 | 1572864 | no | yes | yes | DMT 1024x768 60 Hz | offered with 2 or 4 MB |
| 117h | 1024x768 | 64K | 2 | 10 | 2048 | 1572864 | no | yes | yes | DMT 1024x768 60 Hz | offered with 2 or 4 MB |

The timings (DMT figures; 640x400 from the IBM VGA 400-line timing):

| Timing | Pixel clock | H active, front porch, sync, back porch (total) | H sync | V active, front porch, sync, back porch (total) | V sync | Line rate | Frame rate |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 640x400 70 Hz (IBM) | 25.175 MHz | 640, 16, 96, 48 (800) | negative | 400, 12, 2, 35 (449) | positive | 31.47 kHz | 70.09 Hz |
| 640x480 60 Hz (DMT) | 25.175 MHz | 640, 16, 96, 48 (800) | negative | 480, 10, 2, 33 (525) | negative | 31.47 kHz | 59.94 Hz |
| 800x600 60 Hz (DMT) | 40.000 MHz | 800, 40, 128, 88 (1056) | positive | 600, 1, 4, 23 (628) | positive | 37.88 kHz | 60.32 Hz |
| 1024x768 60 Hz (DMT) | 65.000 MHz | 1024, 24, 136, 160 (1344) | negative | 768, 3, 6, 29 (806) | negative | 48.36 kHz | 60.00 Hz |
| 1280x1024 60 Hz (DMT) | 108.000 MHz | 1280, 48, 112, 248 (1688) | positive | 1024, 1, 3, 38 (1066) | positive | 63.98 kHz | 60.02 Hz |

Derived per mode (MODE-109 to MODE-116, MODE-119): the horizontal values in character
clocks (counter positions from 0 = first active pixel), the vertical values in lines, the PLL setting
by the data book procedure and the rates it gives.

| Mode | PPC | HT (CC) | Active (CC) | Sync start-end (CC) | Blank width (CC, MODE-112, MODE-113) | V total | V sync start-end | PLL M, N, R | DCLK (MHz) | Frame rate (Hz) | CR5D bits 3/5 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 100h | 8 | 100 | 80 | 82-94 | 19 | 449 | 412-414 | 40, 1, 3 | 25.057 | 69.76 | no |
| 101h | 8 | 100 | 80 | 82-94 | 19 | 525 | 490-492 | 40, 1, 3 | 25.057 | 59.66 | no |
| 103h | 8 | 132 | 100 | 105-121 | 31 | 628 | 601-605 | 54, 3, 2 | 40.091 | 60.45 | no |
| 105h | 8 | 168 | 128 | 131-148 | 39 | 806 | 771-777 | 89, 3, 2 | 65.148 | 60.14 | no |
| 107h | 8 | 211 | 160 | 166-180 | 50 | 1066 | 1025-1028 | 104, 5, 1 | 108.409 (VCLK 54.20) | 60.25 | no |
| 110h, 111h | 4 | 200 | 160 | 164-188 | 39 | 525 | 490-492 | 40, 1, 3 | 25.057 | 59.66 | no |
| 112h | 8 | 100 | 80 | 82-94 | 19 | 525 | 490-492 | 40, 1, 3 | 25.057 | 59.66 | no |
| 113h, 114h | 4 | 264 | 200 | 210-242 | 63 | 628 | 601-605 | 54, 3, 2 | 40.091 | 60.45 | no |
| 115h | 8 | 132 | 100 | 105-121 | 31 | 628 | 601-605 | 54, 3, 2 | 40.091 | 60.45 | no |
| 116h, 117h | 4 | 336 | 256 | 262-296 | 79 | 806 | 771-777 | 89, 3, 2 | 65.148 | 60.14 | both (blank 63 + 16 CC, sync 26 + 8 CC) |

## Mode list and memory

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| MODE-101 | The packed modes offered are 100h, 101h, 103h, 105h, 107h and 110h-117h, each with the resolution, colours and memory layout of the mode table. A mode is offered only when its memory need (pitch x YRes, the "Memory" column) fits the video memory found at POST (CR36 bits 7-5: 1, 2 or 4 MB, T64-MEM-5): with 1 MB, 107h, 112h, 115h, 116h and 117h are not offered. A mode not offered gets AX = 014Fh from 4F02 (nothing is changed) and mode attribute bit 0 = 0 from 4F01 | VBE 1.2 (4F01 ModeAttributes bit 0 "mode supported in hardware", 4F02 status 014Fh); T64-MEM-5 | must | emu t_errors (1 MB: 4F02 of 107h, 112h, 115h-117h); S3COMPAT 'VBE VESA nnnn' INFO for unsupported modes; S3TEST 'VBE Mode 0107 (over 1 MB) SKIP' |
| MODE-102 | Not offered: 106h (1280x1024 in 16 planar colours needs 108 MHz in a 4-bit VGA-style mode, which has no clock doubling; colour mode 0 allows 80 MHz, CLK-1) and 10Dh-10Fh (320x200 at 70 Hz needs a 12.59 MHz pixel clock, below the lowest PLL output, 135 MHz / 8 = 16.9 MHz, PLL-1 with R at most 3; whether SR01 bit 3 can halve the dot clock in an enhanced mode is MQ-9). No mode is offered interlaced, and no mode whose timing exceeds the colour mode's clock limit (MODE-120): 1024x768 in 16M colours (65 MHz > 50 MHz in mode 13) and 1280x1024 in 32K/64K colours (108 MHz > 80 MHz in modes 9/10) do not exist on the Trio64 at 60 Hz | T32/64 table 8-1 (CLK-1), 9.1 (PLL-1); `docs/seavgabios-trio64.md` scope (60 Hz or more, never interlaced) | must | emu t_errors; S3COMPAT 'VBE VESA nnnn' (WARN 10 interlace, WARN 02 DCLK above the maximum) |
| MODE-103 | The installed memory decides; the board's memory type (fast page or EDO, CR36 bits 3-2) changes no value of this part except through the MCLK in the FIFO formula (MODE-136) | T64-MEM-3, T64-MEM-5 | note | not checked |

## Timing

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| MODE-104 | Each offered mode has one timing, the one in the mode table: the DMT 60 Hz timing of its resolution (640x480, 800x600 with line total 1056, 1024x768, 1280x1024), and for 100h the IBM VGA 400-line timing at 70 Hz (25.175 MHz, 800 x 449), as the project's hard rule keeps 70 Hz for 640x400. No other refresh rate is selectable in the first version | DMT; IBM (`docs/bios-rules.md` MODE-11: 70 Hz at 400 lines); AGENTS.md hard rules (VESA timings, 70 Hz for 640x400) | must | S3COMPAT 'VBE VESA nnnn' WARN 40 (default rate not DMT) and fail 10; S3TEST 'VBE Mode nnnn' (measured refresh within 1.5 Hz, line total 800/1056/1344/1688) |
| MODE-105 | Never interlaced: CR42 bit 5 = 0 (CR42 = 00h; bits 4-0 and 7-6 are reserved in the Trio64 book). CR3C (interlace retrace start) is used only with CR42 bit 5 = 1; it is written 00h, as the data book's non-interlaced example does | T32/64 CR42, CR3C, table 11-4 ("CR3C 00: not used for this non-interlaced mode") | must (CR42), should (CR3C) | S3COMPAT 'VBE VESA nnnn' WARN 10 (interlace) |
| MODE-106 | Sync polarity in MISC (3C2h) bit 6 (1 = negative HSYNC) and bit 7 (1 = negative VSYNC), from the timing: 640x480 and 1024x768 negative/negative, 800x600 and 1280x1024 positive/positive, 640x400 negative HSYNC and positive VSYNC (the VGA's 400-line code). The other MISC bits in the packed modes: bit 0 = 1 (colour I/O at 3Dxh), bit 1 = 1 (RAM enabled), bits 3-2 = 11b (DCLK from SR12/SR13), bit 5 = 1 (odd/even page bit, as in IBM's graphics modes): MISC = 2Fh plus the polarity bits | DMT (polarities); IBM (400-line polarity, bits 0, 1, 5); T64-PLL-1 (bits 3-2 = 11b) | must (polarity, bits 3-2), should (bit 5) | not checked (a test reading MISC bits 7-6 against the timing in S3COMPAT 'VBE VESA nnnn') |
| MODE-107 | The pixel clock is met within 0.5 %, the tolerance of the data book's PLL procedure (MODE-119); the frame and line rates follow from the DCLK actually produced (table above: 59.66 Hz for 640x480, 60.45 Hz for 800x600) | T32/64 9.1 step 3 | must | S3COMPAT 'VBE VESA nnnn' fail 400 and WARN 40 (1.5 Hz) |

## Character clocks and the CRTC registers

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| MODE-108 | Every horizontal CRTC value is a count of character clocks; a character clock is 8 dots (SR01 bit 0 = 1, the 8-dot clock, in every packed mode; SR01 bit 3 = 0, no dot clock halving) | T32/64 table 11-2, SR1 bits 0 and 3 | must | S3COMPAT 'VBE VESA nnnn' fail 400 |
| MODE-109 | Pixels per character clock (PPC) and DCLKs per character clock (DPC) by colour mode: mode 0 (8 bpp): 8 and 8; mode 8 (8 bpp clock-doubled, VCLK = DCLK / 2, two pixels per VCLK): 8 pixels per character clock, 8 DCLKs; modes 9 and 10 (15 and 16 bpp): 4 pixels per character clock, 4 DCLKs, so every horizontal value is twice that of the same resolution in 8 bpp; mode 13 (4 bytes per pixel): 8 and 8. Example: 640x480 has HT = 100 CC in 8 and 32 bpp, 200 CC in 15 and 16 bpp | T32/64 table 8-1 (pixels per VCLK), 8.1.2, 9.3; VGADOC S3.TXT CR46/CR47 ("For 64k modes this value should be twice the actual X co-ordinate"); the 15/16 bpp factor is not stated in the data book (MQ-1) | must | S3COMPAT 'VBE VESA nnnn' fail 400 (measured refresh against the rate the registers give with this rule; the factor 2 is WARN 01): passed on the DSP-3364P for 110h-117h on 31 October 2026 (card run of the S3COMPAT 'VBE VESA nnnn' lines) |
| MODE-110 | CR43 bit 7 (horizontal counter double mode) = 0 and CR43 bit 2 (old offset bit 8) = 0: CR43 = 00h. The horizontal values are programmed as counted by MODE-109, not halved for the double mode | T32/64 CR43, table 12-1 ("Bit 7 of CR43 doubles the parameter size") | should | not checked (MQ-1) |
| MODE-111 | With HT = Htotal / PPC, HA = Hactive / PPC, HSS = (Hactive + front porch) / PPC and HSE = (Hactive + front porch + sync width) / PPC (all integers for the timings of this part): Horizontal Total CR00 (bit 8 in CR5D bit 0) = HT - 5; Horizontal Display End CR01 (bit 8 in CR5D bit 1) = HA - 1; Start Horizontal Blank CR02 (bit 8 in CR5D bit 2) = HA; Start Horizontal Sync CR04 (bit 8 in CR5D bit 4) = HSS; End Horizontal Sync CR05 bits 4-0 = the low 5 bits of HSE; End Horizontal Blank (MODE-112) in CR03 bits 4-0 and CR05 bit 7. CR03 bit 7 = 1 and bits 6-5 = 0 (no display enable skew); CR05 bits 6-5 = 0 (no sync skew) | T32/64 table 11-2, CR0-CR5, CR5D; VGADOC VGAREGS.TXT (CR03 bit 7, skew bits) | must | S3COMPAT 'VBE VESA nnnn' fail 100 (geometry), fail 400; S3TEST 'VBE Mode nnnn' (line total) |
| MODE-112 | Horizontal blanking covers everything outside the active display: it starts at HA and ends at HT - 1 (End Horizontal Blank = the low 6 bits of HT - 1). It must never end inside the active display, which a value of HT or above would do (the 6-bit compare then matches in the next line) | T32/64 table 11-2 (End Horizontal Blank: "least significant six bits of the character clock counter value at which horizontal blanking ends") | must | not checked (a check of CR02/CR03/CR05 against CR00/CR01 in S3COMPAT 'VBE VESA nnnn') |
| MODE-113 | The 6-bit blank end and the 5-bit sync end limit the blank to 64 and the sync pulse to 32 character clocks. A longer pulse uses CR5D bit 3 (BLANK extended by 64 DCLKs) or CR5D bit 5 (HSYNC extended by 32 DCLKs), with the end value programmed that many character clocks (64 / DPC, 32 / DPC) earlier. Of the modes of this part only 116h and 117h need both: blank 79 CC = 63 + 16, sync 34 CC = 26 + 8 (DPC 4). Every other mode: CR5D bits 3 and 5 = 0 | T32/64 CR5D bits 3 and 5, table 11-2; the DCLK unit in 15/16 bpp is MQ-2 | must | S3COMPAT 'VBE VESA 0116', 'VBE VESA 0117' fail 400 (the total only); the pulse widths are not checked |
| MODE-114 | Sync positions as DMT gives them, measured from the first active pixel; no pipeline offset is added (MQ-3) | DMT; T32/64 table 11-2 | should | not checked (a monitor's position and the sync width readout on a card) |
| MODE-115 | Vertical registers, with Vtotal, Vactive and the porches in lines: Vertical Total CR06 (bit 8 CR07 bit 0, bit 9 CR07 bit 5, bit 10 CR5E bit 0) = Vtotal - 2; Vertical Display End CR12 (bits 8, 9, 10: CR07 bits 1 and 6, CR5E bit 1) = Vactive - 1; Vertical Retrace Start CR10 (bits 8, 9, 10: CR07 bits 2 and 7, CR5E bit 4) = Vactive + front porch; Vertical Retrace End CR11 bits 3-0 = the low 4 bits of (Vactive + front porch + sync width); Start Vertical Blank CR15 (bits 8, 9, 10: CR07 bit 3, CR09 bit 5, CR5E bit 2) = Vactive - 1 (the data book: "scan lines at which vertical blanking begins - 1"); End Vertical Blank CR16 = the low 8 bits of Vtotal - 1 | T32/64 table 11-2, CR5E; VGADOC VGAREGS.TXT (CR07, CR09) | must | S3COMPAT 'VBE VESA nnnn' fail 100, 400 |
| MODE-116 | Line compare = 7FFh, above every scan line, so the screen is not split: CR18 = FFh, CR07 bit 4 = 1, CR09 bit 6 = 1, CR5E bit 6 = 1 | T32/64 CR5E bit 6, table 12-1; VGADOC VGAREGS.TXT (CR18) | must | not checked (1280x1024: a line compare of 3FFh would split the last line; S3COMPAT could check CR18/CR07/CR09/CR5E against YRes) |
| MODE-117 | The other CRTC registers of a packed mode: CR08 = 00h (no preset row scan); CR09 bits 4-0 = 0 (one scan line per row) and bit 7 = 0 (no double scan); CR0A = CR0B = 00h (no cursor in a graphics mode, as IBM's graphics modes); CR0C = CR0D = 00h (display start 0, MODE-128); CR11 bit 7 = 1 (CR00-CR07 write protected afterwards, as IBM leaves it), bits 6-4 = 0; CR14 = 00h and CR17 = E3h (CR31 bit 3 = 1 forces doubleword addressing and overrides CR14 bit 6 and CR17 bit 3; CR17 bit 7 = 1 enables the syncs, bits 1-0 = 11b no CGA/Hercules address substitution, bit 2 = 0 no line count doubling) | T32/64 CR31 bit 3, table 11-3; IBM (CR0A/CR0B 00h, CR11 bit 7, CR17 bits 7, 1-0 in the graphics modes; `docs/bios-rules.md` B00-18); VGADOC VGAREGS.TXT | should | S3COMPAT 'VBE VESA nnnn' fail 100 (CR09, CR17 enter the geometry) |
| MODE-118 | CR5D and CR5E hold only the overflow and extension bits named above (CR5D bit 6 is bit 8 of CR3B, MODE-134); every other bit is 0: CR5D bit 7 (bus grant terminate bit 8; BREQ is off, CR50 bit 2 = 0), CR5E bits 7, 5 and 3 (reserved) | T32/64 CR5D, CR5E | must | not checked |

## Pixel clock

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| MODE-119 | DCLK = the pixel clock in every mode of this part (in the clock-doubled mode too: SR15 bit 4 then halves it into VCLK, MODE-122). M, N and R come from the data book procedure: R is the code with 135 MHz <= 2^R x f <= 270 MHz; then for N = 1, 2, 3, ...: M = round(f x (N+2) x 2^R / 14.31818) - 2, and the first N whose M lies in 1-127, whose VCO 14.31818 x (M+2) / (N+2) lies in 135-270 MHz and whose output is within 0.5 % of f is taken. SR12 = R x 20h + N (bit 7 = 0, reserved on the Trio64), SR13 = M (bit 7 = 0). Results: 25.175 MHz: M 40, N 1, R 3 = 25.057 MHz (-0.47 %); 40 MHz: M 54, N 3, R 2 = 40.091 MHz (+0.23 %); 65 MHz: M 89, N 3, R 2 = 65.148 MHz (+0.23 %); 108 MHz: M 104, N 5, R 1 = 108.409 MHz (+0.38 %) | T32/64 9.1 (the procedure and the constraints), SR12, SR13; PLL-1, PLL-2; "round" is MQ-4 | must (constraints, 0.5 %), should (the first N) | S3COMPAT 'VBE VESA nnnn' fail 200 (PLL N, R code, VCO), fail 400; S3COMPAT 'DCLK VCO at every refresh rate' (`tvco`) |
| MODE-120 | Clock limits by colour mode (CLK-1): mode 0 at most 80 MHz DCLK; mode 8 at most 67.5 MHz VCLK (135 MHz pixel rate); modes 9 and 10 at most 80 MHz; mode 13 at most 50 MHz. The offered modes stay within them: 8 bpp up to 65.1 MHz in mode 0 and 108.4 MHz (VCLK 54.2 MHz) in mode 8; 15/16 bpp up to 65.1 MHz; 4 bytes per pixel up to 40.1 MHz. Also DCLK >= half the PCI clock (16.7 MHz at 33 MHz), "to ensure valid writes to the PLLs" | T32/64 table 8-1, table 4-6 note 1 and 2 (CLK-1, CLK-6) | limit | S3COMPAT 'VBE VESA nnnn' WARN 02 |
| MODE-121 | Loading the DCLK: SR12 and SR13 are written, MISC bits 3-2 = 11b, then the value is loaded either immediately (SR15 bit 5 written 1 and then 0, read-modify-write, never left 1) or by the delayed path (SR15 bit 1 = 1, left 1; the load follows after a short, variable time). This part takes the immediate load, which the data book recommends for predictable timing. The immediate load also loads the MCLK from SR10/SR11, which must still hold the value POST loaded. SR15 bit 1 stays 1 in every mode; SR15 bit 0 (MCLK load) is 0 after the call | T32/64 9.2, SR15 (REG-1, REG-3, T64-PLL-1) | must (bit 5 never left 1, MCLK registers unchanged), should (immediate path) | S3COMPAT 'VBE VESA nnnn' fail 1000 (SR15 bit 5 left set) |
| MODE-122 | Clock doubling, for 8 bpp above 80 MHz (only 107h): CR67 bits 7-4 = 0001b (mode 8), SR15 bit 4 = 1 (DCLK / 2 gives VCLK; SR15 bit 6, DCLK inversion, = 0) and SR18 bit 7 = 1 (RAMDAC clock doubled mode enabled). The CRTC is programmed with 8 pixels per character clock (MODE-109). In every other mode, VGA modes included, CR67 bits 7-4 are not 0001b, SR15 bit 4 = 0 and SR18 bit 7 = 0; a mode set after 107h clears them. The other bits of SR15 and SR18 are kept as POST set them | T32/64 8.1.2, 9.3, table 4-6 note 2 ("For DCLK rates above 80 MHz, clock doubling is used"), SR15 bits 4 and 6, SR18 bit 7, SRB (CLK-3) | must | S3COMPAT 'VBE VESA 0107' fail 200 (CLK-3); emu t_s3compat_vbe |
| MODE-123 | CR67 bit 0 (VCLK phase) = 0 and bits 3-1 (reserved) = 0 in every mode. SRB = 00h in the packed modes of the Trio64 (bit 3, packed 24 bpp mode 12, exists on the Trio32 only, CLK-2) | T32/64 CR67, table 11-4 (CR67 = 00 for 8 bpp), SRB; MQ-13 for mode 8 | should (bit 0), must (SRB bit 3) | S3COMPAT 'VBE VESA nnnn' fail 200 ('packed 24 on a Trio64') |

## Colour mode and memory layout

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| MODE-124 | CR67 bits 7-4 by mode: 0000b for 100h, 101h, 103h, 105h; 0001b for 107h; 0011b for 110h, 113h, 116h; 0101b for 111h, 114h, 117h; 1101b for 112h and 115h (24-bit colour stored in 4 bytes per pixel, blue in the lowest byte, the upper byte unused) | T32/64 table 8-1, 8.1.5, CR67, CR50 bits 5-4 ("True color (24 bits/pixel) is handled by this setting, with the upper byte unused") | must | S3COMPAT 'VBE VESA nnnn' fail 4 (colour masks), fail 200 |
| MODE-125 | Pitch (bytes from one scan line to the next) = XRes x B: 640, 800, 1024, 1280 in 8 bpp; 1280, 1600, 2048 in 15/16 bpp; 2560, 3200 with 4 bytes per pixel. The offset register in doubleword units: CR13 (bits 7-0) and CR51 bits 5-4 (bits 9-8) = pitch / 8, with CR43 bit 2 = 0. The 4F01 BytesPerScanLine and 4F06 report this pitch | T32/64 table 11-2 (Offset "multiplied by ... 8 (doubleword mode)"), CR13, CR51 bits 5-4, CR43 bit 2; table 11-3 | must | S3COMPAT 'VBE VESA nnnn' fail 100 (pitch vs 4F01), fail 40 (4F06) |
| MODE-126 | CR50: bits 7-6 with bit 0 as the high bit = the screen width code of XRes for the graphics engine (640: 001b, 800: 010b, 1024: 000b, 1280: 011b); bits 5-4 = the pixel length (00b one byte, 01b two bytes, 11b four bytes); bits 3-1 = 0 (bit 2 BREQ off; bits 3 and 1 reserved) | T32/64 CR50, table 11-3 | must | S3COMPAT 'VBE VESA nnnn' WARN 04 (pixel length) |
| MODE-127 | CR31 = 09h: bit 3 = 1 (enhanced memory mapping, doubleword addressing, fixed 64 KB map at A0000h), bit 0 = 1 (the 64 KB bank comes from CR6A, which 4F05 sets), bit 1 = 0 (no 2Kx1K map), bit 2 = 0, bits 5-4 = 0 (the display start bits 17-16 are in CR69), bit 6 = 0 (high speed text font fetch: text modes above 40 MHz only) | T32/64 CR31, table 11-3, table 11-4 (CR31 = 09); T64-CLK-2 | must (bit 3, bit 0), should (the rest) | S3COMPAT 'VBE VESA nnnn' fail 800 (mapping), fail 20 (first and last byte through the window); S3TEST 'VBE 4F05 set bank 3 / get' |
| MODE-128 | After the mode set the display starts at byte 0 and the window shows bank 0: CR0C = CR0D = 00h, CR69 = 00h, CR31 bits 5-4 = 0, CR51 bits 1-0 = 0 (display start); CR6A = 00h, CR35 bits 3-0 = 0, CR51 bits 3-2 = 0 (CPU base). A later display start (4F07) goes to CR0C, CR0D and CR69 bits 3-0 (bits 19-16) and a bank (4F05) to CR6A; the old fields stay 0 | T32/64 CR31, CR35, CR51, CR69, CR6A | must | S3TEST 'VBE 4F05 set bank 3 / get'; S3COMPAT 'VBE VESA nnnn' fail 80 (4F07) |
| MODE-129 | CR32 = 00h in the packed modes: bit 6 = 0 (no wrap at 256 KB, so banks above 256 KB reach their memory), bit 4 = 0 (no interrupt generation); the other bits are reserved | T32/64 CR32 | must (bit 6) | S3COMPAT 'VBE VESA nnnn' fail 20 (last byte through the window) |
| MODE-130 | CR3A = 15h in the packed modes: bit 4 = 1 (attribute controller shift registers for 8, 16 and 32 bit modes), bit 2 = 1 with bits 1-0 = 01b (one memory refresh cycle per scan line, the data book's example), bit 3 = 0 (no top-of-memory text), bit 5 = 0 (high speed text font writing: text above 40 MHz only), bit 7 = 0 (PCI read bursts allowed; setting it needs CR66 bit 7 first, T64-PCI-1). The refresh count is MQ-5 | T32/64 CR3A, table 11-4 (CR3A = 15); T64-CLK-2 | must (bit 4), should (refresh) | S3COMPAT 'VBE VESA nnnn' fail 200 |
| MODE-131 | Banked access (VBE 1.2): linear addressing off, CR58 bit 4 = 0 (and 4AE8h bit 4 = 0, which is ORed with it); the CPU reaches the frame buffer through the 64 KB window at A0000h with CR31 bit 0 and CR6A. CR58 bits 1-0 (window size) do not act while bit 4 = 0; they are left as POST set them and must never name more than the installed memory. CR58 bits 7 (RAS precharge adjust) and 3 (VL-Bus latch delay) are board settings, kept as found | T32/64 CR58, 13.1, 4AE8h bit 4; VGADOC S3.TXT CR58 ("Must be less than or equal to video memory size"); `docs/seavgabios-trio64.md` (VBE 1.2, banked, no linear frame buffer) | must (bit 4), should (bits 1-0) | S3TEST 'VBE Mode nnnn' (CR58 column); S3COMPAT 'VBE VESA nnnn' fail 800 |
| MODE-132 | Enhanced functions for the packed modes: CR40 bit 0 = 1 (enhanced register access, read-modify-write), then 4AE8h bit 0 = 1 (enhanced, non-planar modes) and bit 2 = 0 (8 or more bits per pixel; CR50 bits 5-4 tell 8, 16 and 32 apart), bits 4 and 5 = 0 (no linear addressing, no MMIO), reserved bits 0. In a VGA mode 4AE8h bits 0 and 2 = 0. Whether CR40 bit 0 stays 1 after the call is MQ-7 | T32/64 11.4.2, 4AE8h register description (bit 2: 0 = 8 or more bits/pixel), CR40 | must | not checked (the emulator does not model 4AE8h; a write log of port 4AE8h in emu/tests.py) |
| MODE-133 | Sequencer, graphics controller and attribute controller in the packed modes as in IBM's mode 13h, the 256-colour VGA mode: SR01 = 01h (8-dot clock, screen on at the end), SR02 = 0Fh, SR03 = 00h, SR04 = 0Eh (chain 4, extended memory, no odd/even); GR00-GR04 = 00h, GR05 = 40h (256-colour shift), GR06 = 05h (graphics; the map is fixed by CR31 bit 3), GR07 = 0Fh, GR08 = FFh; AR00-AR0F = 00h-0Fh, AR10 = 41h, AR11 = 00h, AR12 = 0Fh, AR13 = 00h, AR14 = 00h. With CR3A bit 4 = 1 AR10 bit 6 does not halve VCLK | IBM (mode 13h values, `docs/bios-rules.md` B00-7); T32/64 9.3 (the halving needs CR3A bit 4 = 0), CR31 bit 3 | should | S3COMPAT 'VBE VESA nnnn' fail 20; not checked register by register |

## Display FIFO

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| MODE-134 | Start of the display FIFO fetch: CR3B (bit 8 in CR5D bit 6) = CR00 - 5, in the character clocks of the mode (so 15/16 bpp values are in their doubled units), and CR34 bit 4 = 1 to enable it. The value lies in the horizontal blanking of every offered mode (HT - 10 >= HA) | T32/64 7.4, CR3B, CR34 bit 4, table 11-4 (T64-MEM-2) | must | not checked (a check CR3B = CR00 - 5 with CR34 bit 4 in S3COMPAT 'VBE VESA nnnn' regchk) |
| MODE-135 | N parameter: CR60 = FFh in every packed mode, so the FIFO is always filled to full before memory is released | T32/64 7.4, CR60, table 11-4 (CR60 = FF: "ensures that the FIFO will always be filled before the memory is released") | should | not checked |
| MODE-136 | M parameter, CR54 bits 7-3 (bits 2-0 = 0), maximised without a FIFO underrun. With MCLK = the memory clock POST loaded (from SR10/SR11 by the PLL-1 formula), DCLK = the programmed pixel clock (MODE-119, before any halving), B = bytes per pixel and D = the FIFO bytes the display may drain before a refill must start (112 of the 128-byte FIFO with 2 or 4 MB, 16 entries of 8 bytes; 56 of the 64-byte FIFO with 1 MB, 16 entries of 4 bytes): t = D x MCLK / (DCLK x B) MCLKs; M = floor((t - 23) / 6), at least 0 and at most 31. The 23 MCLKs are two entry cycles of 9 MCLKs and one access, then 6 MCLKs per further access. Values at the 54.9, 60 and 69.8 MHz MCLKs of the builds at hand, 2 MB: 100h, 101h 31, 31, 31; 103h 21, 24, 28; 105h 11, 13, 16; 107h 5, 6, 8; 110h/111h 16, 18, 22; 112h 6, 7, 9; 113h/114h 8, 10, 12; 115h 2, 3, 4; 116h/117h 4, 4, 6. 1 MB: 100h/101h 16, 18, 22; 103h 8, 10, 12; 105h 4, 4, 6; 110h/111h 6, 7, 9; 113h/114h 2, 3, 4 | T32/64 7.4 ("One entry cycle requires 6-9 MCLKs; one page mode cycle requires 2 MCLKs"; FIFO 32 or 64 bits by 16; M maximised without underrun; fill bandwidth 120 or 240 MB/s), CR54 (T64-MEM-1); the cost model stated in this rule (6 MCLKs per access, between the data book's 2 and 6-9), checked on the DSP-3364P: windowed video streaked at M = 19 in 114h with 54.9 MHz and not at 69.8 MHz (issues #75, #82) | must (no underrun), derived (the formula) | not checked in the emulator (it has no bus model); on the card: windowed video in 114h at the build's MCLK (issues #75, #82) |
| MODE-137 | Every offered mode leaves t >= 29 at an MCLK of 54.9 MHz or more (lowest: 115h, t = 38; 1 MB: 113h/114h, t = 38), so M >= 1 there. The display's own byte rate DCLK x B (at most 160.4 MB/s, 115h) stays below the page mode fill rate of 4 x MCLK (2 or 4 MB, 64 bits per 2 MCLKs) or 2 x MCLK (1 MB): a build whose MCLK fails this for a mode does not offer that mode | T32/64 7.4 (fill bandwidth 120 / 240 MB/s at 60 MHz) | derived | not checked |
| MODE-138 | CR54 and CR60 are written with the screen off (SR01 bit 5 = 1) | T32/64 7.4 ("The M and N parameters should only be changed with the screen turned off"), T64-MEM-1 | should | not checked (the emulator write log records SR01 at each write: emu t_v2_writes style test for CR54/CR60) |

## Order of the programming

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| MODE-139 | Before the first S3 register: SR08 = 06h (extended sequencer registers), CR38 = 48h (CR30-CR3F), CR39 = A5h (CR40-CRFF). At the end the three lock registers hold what they held before the call. CR35 bits 5-4 (horizontal and vertical timing locks) = 0 while the timing registers are written; CR11 bit 7 = 0 while CR00-CR07 are written and 1 at the end | T32/64 11.2 (T64-REG-1), CR35, CR11; `docs/seavgabios-trio64.md` item 1 (the lock as found) | must | emu t_t64_patches (lock state after the calls); S3COMPAT 'VBE VESA nnnn' |
| MODE-140 | The screen is off (SR01 bit 5 = 1) from before the first timing, clock or FIFO register write until the last one; it is turned on (bit 5 = 0) at the end, after the clock is loaded | T32/64 7.4 (M and N with the screen off), SR1 bit 5 | should (must for CR54/CR60, MODE-138) | not checked |
| MODE-141 | A sequencer reset (SR00 = 01h, then 03h) around the MISC and SR01 writes, as VGA programs do, is allowed; on the Trio64 SR00 bits 1-0 have "no function", so the clock change does not depend on it. SR00 = 03h when the call returns | T32/64 SR0; IBM (SR00 = 03h, `docs/bios-rules.md` B00-8) | note (reset), must (03h at the end) | S3COMPAT 'Mode nnh' fail 1 (SR00) |
| MODE-142 | Clock order: SR12 and SR13 first, then MISC (bits 3-2 = 11b), then the load (MODE-121), then the clock-doubling bits (CR67, SR15 bit 4, SR18 bit 7), all with the screen off; CR54 is computed from the DCLK actually programmed | T32/64 9.2 (the load example writes 3C2h, SR12, SR13, then SR15) | should | not checked |
| MODE-143 | A mode set leaves the sequencer, CRTC and graphics controller index registers as the caller left them, and the attribute flip-flop in the index state | AGENTS.md (indexes as found); `docs/bios-rules.md` B00-9 | must | S3TEST 'VBE 4F05 regs, SR index' (4F05); S3TEST 'VGA ATC flip-flop reset by mode set' |

## Return to a standard VGA mode (00h-13h)

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| MODE-144 | A mode set of 00h-13h (AH=00h, or 4F02 with a VGA mode number) after any packed mode produces exactly the registers, BIOS data and memory of the same mode set from a clean state (B00-22): the standard registers get IBM's values (B00-7) and every S3 register that a packed mode changes is reset to its VGA state (MODE-145 to MODE-149) | `docs/bios-rules.md` B00-7, B00-22; AGENTS.md (standard modes unchanged) | must | S3COMPAT 'Mode nnh after xxxx' (pass 2, every line as in pass 1); S3COMPAT 'Mode 03 after all tests vs baseline'; make tref-compare |
| MODE-145 | Colour mode and clocks back to VGA: CR67 = 00h; SR15 bit 4 = 0 and bit 6 = 0; SR18 bit 7 = 0; SRB bits 7-3 = 0; CR33 bit 3 = 0 (VCLK from DCLK, halved by the chip when AR10 bit 6 = 1 and CR3A bit 4 = 0, which makes mode 13h work); MISC bits 3-2 from IBM's table (00b 25.175 MHz, 01b 28.322 MHz), for which the chip loads its own PLL values into SR12/SR13, with SR15 bit 1 = 1 (left 1) and SR15 bits 5 and 0 = 0. SR12/SR13 are not written for a VGA mode | T32/64 9.2, 9.3, SR12, SR13, SR15, SR18, CR33 bit 3 (T64-CLK-1, REG-3) | must | S3COMPAT 'Mode nnh after xxxx' fail 8 (refresh 70/60 Hz), fail 40 (refresh vs registers); S3COMPAT 'Mode 13h' |
| MODE-146 | Memory mapping back to VGA: CR31 bit 3 = 0 (IBM mapping: GR06 selects the window), bits 5-4 = 0, bit 1 = 0, bit 6 = 0 (all VGA modes run at 28.3 MHz or less); CR31 bits 0 and 2 may be 1 (bit 0 with a bank of 0 changes nothing; bit 2, the 16-bit VGA memory path, is the data book's option for text modes, MQ-8). CR32 bit 6 = 1 (wrap at 256 KB, VGA compatibility). CR35 bits 3-0 = 0, CR51 = 00h, CR69 = 00h, CR6A = 00h; CR58 bit 4 = 0 and 4AE8h bits 0, 2, 4 = 0; CR50 = 00h; CR43 = 00h | T32/64 CR31, CR32 bit 6 ("For standard VGA compatibility ... this bit is set to 1"), CR35, CR50, CR51, CR58, CR69, CR6A, 4AE8h; T64-CLK-2 | must (bit 3, 5-4, CR51, CR69, CR6A, CR58 bit 4), should (CR32 bit 6) | S3COMPAT 'Mode nnh after xxxx' fail 10 (memory in the mode's window); S3TEST 'VGA Mode nnnn' (CR58 column) |
| MODE-147 | Timing extensions back to VGA: CR5D = 00h, CR5E = 00h, CR42 = 00h, CR3C = 00h; CR34 bit 4 = 0 (the VGA's own fetch start; CR3B then has no effect); CR3A bit 4 = 0 (attribute controller in its 4-bit configuration), bit 3 = 0, bit 5 = 0; CR3A bits 2-0 (refresh) as MQ-5 decides | T32/64 CR3A, CR34, CR5D, CR5E, CR42 | must | S3COMPAT 'Mode nnh after xxxx' fail 1, 8 |
| MODE-148 | Display FIFO in the VGA modes: CR60 = FFh and M by the formula of MODE-136 with the display byte rate of the VGA modes (at most 12.6 MB/s: 4 bytes per 8 pixels at 25.175 MHz in the planar modes, 1 byte per 2 dots in 13h, 3 bytes per 9 dots at 28.322 MHz in text), which gives M = 31 (CR54 = F8h) at every MCLK of 40 MHz or more and every memory size; written with the screen off | T32/64 7.4, CR54, CR60 (T64-MEM-1); whether M acts in VGA modes is MQ-6 | derived | not checked (S3TEST timings and VIDSPEED in the VGA modes on the card) |
| MODE-149 | CR40 bit 0 = 0 at the end of a VGA mode set (enhanced registers locked again by read-modify-write, after checking that the graphics engine is idle, 9AE8h bit 9 = 0), unless the lock rule of MODE-139 says it was 1 before the call | T32/64 11.2.2 (T64-REG-1) | should | not checked |
| MODE-150 | Registers this part never writes in a mode set, VGA or packed: SR10/SR11 (MCLK), CR36, CR37, CR68 (strapping), CR59/CR5A (linear base, the PCI BAR), CR41, CR52, CR6B, CR6C (BIOS flag registers; item 5 of the plan), CR66, CR53, SRA, SRD | T32/64 CR36, CR37, CR68, CR59-5A (T64-REG-2), CR6B (T64-MEM-6); AGENTS.md (strapping) | must | S3COMPAT POST lines; emu t_windows (CR59/CR5A after 4F02) |

## Worked example: 114h (800x600, 64K colours) on a 2 MB board at MCLK 54.9 MHz

From the DMT 800x600 timing (40 MHz; 800, 40, 128, 88; 600, 1, 4, 23; positive syncs) with colour mode
10 (PPC 4, DPC 4, B 2):

- HT = 1056 / 4 = 264, HA = 200, HSS = 840 / 4 = 210, HSE = 968 / 4 = 242 (32 CC, no extension),
  blank 200 to 263 (63 CC, no extension). CR00 = 259 (CR5D bit 0 = 1, CR00 = 03h), CR01 = 199 = C7h,
  CR02 = 200 = C8h, CR03 = 80h + (263 and 1Fh) = 87h, CR05 bit 7 = bit 5 of 263 = 0, CR04 = 210 = D2h,
  CR05 bits 4-0 = 242 and 1Fh = 12h.
- Vtotal 628: CR06 = 626 low byte; VDE 599, VRS 601, VRE 605 and 0Fh = 5, VBS 599, VBE 627 low byte;
  line compare 7FFh.
- PLL: R = 2 (160 MHz VCO); N = 1: M = round(40 x 3 x 4 / 14.31818) - 2 = 32, 40.57 MHz (1.4 %, no);
  N = 2: M = 43, 40.27 MHz (0.67 %, no); N = 3: M = 54, 40.091 MHz (0.23 %): SR12 = 43h, SR13 = 36h.
- Pitch 1600: CR13 = 200 = C8h, CR51 bits 5-4 = 0. CR50 = 80h + 10h = 90h. CR67 = 50h.
- CR3B = 259 - 5 = 254 = FEh, CR5D bit 6 = 0; CR34 bit 4 = 1; CR60 = FFh.
- t = 112 x 54.886 / (40.091 x 2) = 76.7 MCLKs; M = floor((76.7 - 23) / 6) = 8: CR54 = 40h.
- MISC = 2Fh (positive syncs, PLL clock); CR31 = 09h, CR32 = 00h, CR3A = 15h, CR42 = 00h, CR43 = 00h,
  CR58 bit 4 = 0, CR5E = 40h, SR15 bit 4 = 0, SR18 bit 7 = 0.

## Open questions

1. **MQ-1** 15/16 bpp: the data book does not say that the CRTC counts 4 pixels per character clock in
   colour modes 9 and 10 (MODE-109). VGADOC's CR46 note and the card's measured refresh (S3COMPAT fail
   400 passes on the DSP-3364P with that rule) support it. Does CR43 bit 7 (horizontal counter double
   mode) offer the same with 8-pixel values, and should it be used instead?
2. **MQ-2** CR5D bits 3 and 5 extend BLANK and HSYNC by 64 and 32 "DCLKs": in 15/16 bpp, is that 16 and
   8 character clocks (DCLK = pixel clock, 4 per character clock), as MODE-113 assumes for 116h/117h?
   A card readout of the sync width (monitor information) would settle it.
3. **MQ-3** Pipeline offset: IBM's VGA tables place HSYNC two character clocks later than DMT's 640x480
   position (CR04 = 54h for 656 pixels). Does the Trio64's enhanced mode pipeline need an offset too
   for the DMT sync to come at the DMT position? MODE-114 adds none.
4. **MQ-4** T32/64 9.1 step 2 writes M = [f x (N+2) x 2^R / fREF] - 2 with brackets that may mean
   rounding or truncation. MODE-119 rounds to the nearest integer; with truncation the first N meeting
   0.5 % changes for 40 and 65 MHz.
5. **MQ-5** Memory refresh per scan line (CR3A bits 2-0 with bit 2 = 1, or CR11 bit 6 when bit 2 = 0):
   the data book's example (1 per line) is a 1024x768 mode at 75 Hz (about 60 kHz). At 31.5 kHz (640x480,
   640x400 and the VGA modes) one refresh per line gives 31500 per second; the DRAM's refresh need
   (cycles per ms of the V53C16256H and of EDO parts) is not in the project's notes. Which count should
   each mode use, and should the VGA modes keep IBM's CR11 bit 6 = 0 (3 per line) with CR3A bit 2 = 0?
   Partly answered (1 November 2026): the DSP-3364P carries four Mosel Vitelic V53C16256H-50 (256K x
   16 fast page DRAM, 50 ns); the family's data sheet (Mosel 1993 memory data book, V53C16256/18256)
   asks for 512 refresh cycles in 8 ms, one every 15.6 us. Assuming one refresh per CRTC line,
   blanking lines included, a mode needs at least line rate / 64 kHz cycles per line, rounded up: 3 at
   31.5 kHz (2.03), 2 at 37.9 kHz (800x600, 1.69) and 48.4 kHz (1024x768, 1.32), 1 at 64 kHz and above
   (1280x1024). One per line (CR3A = 15h) is below the data sheet in every mode under 64 kHz, as is
   the data book's example at its 60 kHz (0.94). Still open: whether the chip refreshes on every line
   including vertical blanking, and other boards' parts (EDO parts of the Trio64V+/V2 cards).
6. **MQ-6** Does the M parameter act in the VGA modes on the Trio64 (MODE-148), and is M = 31 there safe
   on the card? The Vision968 book uses M in VGA modes only, the Trio64 book does not limit it.
7. **MQ-7** CR40 bit 0 after a packed mode set: left 1 so a driver can use the graphics engine at once,
   or restored as found (MODE-139)? Which do the Windows 9x driver and DOS programs expect?
8. **MQ-8** CR31 bit 2 (16-bit VGA memory bus) in the planar and CGA graphics modes: the data book calls
   it useful in text modes "when VGA graphics controller functions are typically not used". Safe in
   0Dh-12h, or 0 there?
9. **MQ-9** Answered for the modes: part C (`spec-c-vbe.md` VBE-10) offers the planar 102h and 104h
   through the VGA 16-colour path and no VBE text modes 108h-10Ch. Still open: 10Dh-10Fh (320x200 at 70 Hz in high colour) be possible with SR01 bit 3 halving a 25.175 MHz
   DCLK in an enhanced mode?
10. **MQ-10** Display start units for 4F07 (VBE part): does CR0C/CR0D/CR69 count 4-byte or 8-byte units in
    the enhanced modes with 2 MB (64-bit bus) and with 1 MB?
11. **MQ-11** The 1 MB FIFO (MODE-136): is the cost per access the same 6 MCLKs with the 32-bit bus? No
    1 MB card has been run.
12. **MQ-12** At 60 MHz the DSP-3364P showed white dots in windowed video with the 5-MCLK model (#82);
    the 6-MCLK model of MODE-136 is not yet confirmed at 60 MHz.
13. **MQ-13** CR67 bit 0 (VCLK phase) in clock-doubled mode 8: the data book's example (CR67 = 00h) is a
    mode 0 setting; is bit 0 = 0 right for mode 8 too?
14. **MQ-14** SR01 bit 5: on the Trio64V2 the screen off takes effect up to 3 HSYNCs later (V2-REG-6);
    must a Trio64 mode set wait before it writes CR54/CR60? The Trio64 book is silent.
15. **MQ-15** Answered by part C: 4F01 BitsPerPixel of 112h and 115h is 32 with an 8-bit reserved
    field (the 4-byte memory format; the Trio64 has no packed 24-bit mode).

## Sources disagree

- T32/64 table 11-3 says 4AE8h bit 2 "selects between 4 (=0) and 8 (=1) bits/pixel"; the 4AE8h register
  description says 0 = 8 or more bits per pixel, 1 = 4 bits per pixel. MODE-132 follows the register
  description.
- T32/64 table 4-6 note 2 gives "the maximum DCLK rate with clock doubling" as 67.5 MHz, table 8-1 the
  same 67.5 MHz as the mode 8 DCLK with a 135 MHz pixel rate: both mean VCLK, the halved clock; the PLL
  itself runs at the pixel rate (MODE-119, MODE-122).
- T32/64 CR69 description: bits 3-0 hold display start bits 19-16; table 12-1 says the start address is
  20 bits with "bits 4-0 of CR69". MODE-128 uses bits 3-0.
- T32/64 9.3 says DCLK halving for 4-bit modes "is enabled by setting bit 4 of SR15 to 1 and clearing
  bit 3 of CR33"; the CR33 bit 3 description has the halving follow AR10 bit 6 or CR3A bit 4 alone.
  MODE-145 keeps SR15 bit 4 = 0 in the VGA modes (mode 13h measures 70 Hz on the card with it 0).
- T32/64 9.1 puts N in "bits 15-11 of SR12" and 9.2 gives the power-on DCLK as 25.125 MHz; the register
  descriptions (bits 4-0; 25.175 MHz) are followed (`docs/chip-rules.md` "Datasheet errors").
