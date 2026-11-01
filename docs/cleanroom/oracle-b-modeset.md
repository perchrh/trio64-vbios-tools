# Oracle for part B, item 2: the S3 mode set (dirty side only)

**This file stays on the dirty side.** It holds register values observed from the reference ROM and
from our patched build in the emulator, next to the values derived in [`spec-b-modeset.md`](spec-b-modeset.md). It is used
to check the clean ROM and to explain where the derived rules and the reference ROM part; it must not
be handed to the clean side, and no value in it is a source for the specification.

Written 1 November 2026.

## What was run

- ROMs: `reference/trio64/1_5_07.bin` (Phoenix 1.5-07, CP764 build, MCLK 54.89 MHz; "1.5-07" below)
  and our 1.5-07-p3, built with `make 764x-rom OUT=/tmp/claude-0/oracle-p3.BIN NASM=...` (SHA-256 of the
  32 KB f6eb2bf0..., "identical to the tested build"; "p3" below).
- Emulator: [`emu/vgaemu.py`](../../emu/vgaemu.py), `Machine.chip = 'trio64'`, `Machine.vram` = 1, 2 and 4. For each mode a
  fresh machine: POST, 4F01 (CX = mode), then 4F02 (BX = mode) with the write log on; the registers
  after the call (`m.r`), the DCLK from SR12/SR13 and the rate from `Machine.frame()` (the model's
  rule: 15/16 bpp and clock-doubled modes count twice, SR15 bit 4 halves). For the VGA modes: POST then
  AH=00h, and POST, 4F02 of 101h, 107h, 117h or 112h, then AH=00h. Port 4AE8h was logged with a
  wrapper around `Machine._out` (the model does not store it).
- The scripts are in the session's scratchpad (not in the repository): `dump.py` (packed modes),
  `vga.py` (VGA return), `aeport.py` (4AE8h), `derive.py` / `oracle.py` (the spec's formulas and these
  tables).
- Limits of the model: no auto-load of SR12/SR13 when MISC bits 3-2 select 25/28 MHz (so SR12/SR13 keep
  the last PLL value in the VGA modes here, the chip would not), no bus or FIFO model (M cannot be judged),
  no 4AE8h state.

## Summary of agreement

- **Agree with the derived rules in both ROMs:** colour modes (CR67 bits 7-4), pitch (CR13/CR51), CR50
  width code and pixel length (except the reserved bit 1, below), CR31 = 09h, CR32 = 00h, CR34 bit 4 = 1,
  CR3A = 15h, CR43 = 00h, CR60 = FFh (except 112h), the clock-doubling bits of 107h (CR67 mode 8, SR15
  bit 4, SR18 bit 7), the 15/16 bpp doubled horizontal values (CR01 = 9Fh for 640, C7h for 800, FFh +
  CR5D for 1024), MISC bits 3-2 = 11b, the screen off around every timing, clock and FIFO write, 4AE8h
  (03h packed, 06h planar, 02h VGA: bit 0 enhanced, bit 2 = 0 for 8 bpp and up, which confirms the
  4AE8h register description against table 11-3; Phoenix also sets the reserved bit 1).
- **p3 against the derived values:** the same DMT line totals for 800x600 (1056) and the same FIFO M in
  every 2 MB packed mode but 110h/111h (p3's formula is the spec's, but p3 only lowers Phoenix's table
  value: 11 there, where the formula gives 16), and p3 computes M with 112 bytes at 1 MB too. p3 keeps Phoenix's non-DMT timings for 1024x768 (line 1352), 1280x1024 (1760 x 1056 at 112.16
  MHz) and 640x480 in 15/16 bpp (796 x 526).
- **1.5-07 at its defaults** runs 800x600 at 56 Hz (36.15 MHz, line 1024), and 1024x768 and 1280x1024
  interlaced (CR42 bit 5 = 1); p3 removed those ([docs/764-rom.md](../764-rom.md)).

## Differences, with the reason

| Item | Derived (spec) | 1.5-07 | p3 | Why |
| --- | --- | --- | --- | --- |
| 100h sync polarity | MISC 6Fh: HSYNC negative, VSYNC positive (the VGA's 400-line code) | EFh (both negative, the 480-line code) | EFh | Phoenix keeps one MISC for 640-wide modes; the spec follows IBM's 400-line polarity (MODE-106). A monitor that sizes by polarity may show 100h with the wrong height on the ROMs |
| 1280x1024 sync polarity | 2Fh (DMT: positive) | EFh | EFh | Phoenix's 1280x1024 timing is not DMT |
| 800x600 PLL | M 54, N 3, R 2: 40.091 MHz (+0.23 %) | 36.15 MHz (56 Hz entry) | M 43, N 2, R 2: 40.27 MHz (+0.67 %) | p3's entry is outside the data book's 0.5 % (T32/64 9.1 step 3); the spec takes the first N within 0.5 % |
| 1024x768 timing | DMT: 65.148 MHz, 1344 x 806, 60.14 Hz | interlaced, 44.74 MHz | 65.327 MHz (+0.50 %), line 1352, 59.87 Hz | Phoenix's non-DMT entry ([docs/764-rom.md](../764-rom.md) "Left as in 1.5-07"); the PLL is 0.503 % off, just outside 0.5 % |
| 1280x1024 timing | DMT: 108.409 MHz, 1688 x 1066, 60.25 Hz | interlaced, 75.17 MHz | 112.159 MHz, 1760 x 1056, 60.35 Hz | Phoenix's non-DMT entry |
| 640x480 in 15/16 bpp | HT 200 CC (800 pixels), VT 525 | 199 CC (796 pixels), VT 526 | the same as 1.5-07 | Phoenix's 15/16 bpp table is one character clock short and one line long; 59.84 Hz |
| Horizontal sync start | DMT position (CR04 = HSS) | one character clock later in 640x480 (53h for 52h) and 800x600x16 (D3h for D2h); 640x400 two later (54h, IBM's value) | as 1.5-07 | pipeline offset or Phoenix's choice (MQ-3) |
| Horizontal blank | HA to HT - 1 | IBM-style values in the 640 modes (100h: IBM's 13h values, CR03 82h, CR05 80h); in 115h the end is counter 128 plus CR5D bit 3 (+64 DCLKs = 8 CC), past HT = 132 | as 1.5-07, and the same in p3's 103h (60 Hz entry) | read literally, the 103h/115h extension reaches 4 CC into the next line; no picture fault is reported on the card |
| Vertical blank | Vactive - 1 to Vtotal - 1 | IBM-style border values (E7h/04h in 640x480) | as 1.5-07 | IBM's 640x480 values; DMT has no border |
| CR3B | CR00 - 5 | CR00 - 7 | CR00 - 7 | Phoenix's choice ([docs/chip-rules.md](../chip-rules.md) "Related chip: the Vision864"); both lie in the blank |
| Line compare bit 10 (CR5E bit 6) | 1 (7FFh) | 0 (3FFh) | 0, except 107h (1) | 3FFh is above every line of the 1.5-07 modes but the last of 1280x1024; p3 sets bit 6 in 107h |
| CR50 bit 1 (reserved) | 0 | 1 in 113h, 114h, 115h | 1 also in 103h | Phoenix's table byte |
| GR05 / AR10 | 40h / 41h (IBM 13h) | 00h / 01h in the 800, 1024 and 1280 modes | as 1.5-07 | with CR3A bit 4 = 1 both work (T32/64 9.3) |
| CR60 in 112h | FFh | 1Ch (N = 28) | 1Ch | Phoenix's table |
| CR67 bit 0 in 107h | 0 | 1 (11h) in its interlaced entry | 0 (10h) | MQ-13 |
| CR58 | bit 4 = 0 (banked), size bits as POST | 03h (4 MB window size with 2 MB, bit 4 = 0) | 10h (the booster: linear addressing on with a 64 KB window at A0000h) | the booster is optional later ([`docs/seavgabios-trio64.md`](../seavgabios-trio64.md)); Phoenix's size 11b exceeds 2 MB (VGADOC: must not) |
| SR15 after POST | bit 0 = 0 (MODE-121) | 03h: bit 0 (MCLK load) left 1 after POST, 02h after a VESA mode set | the same | T64-PLL-1 says bit 0 must be cleared after loading |
| DCLK load path | immediate (SR15 bit 5 1 then 0) | delayed: SR15 written 00h then 02h (bit 1) after SR12/SR13 | the same | both allowed (T32/64 9.2); the spec prefers the immediate one |
| FIFO M | MODE-136 | Phoenix's table (31 in most 8 bpp modes, 19 in 113h/114h, 26 in 107h, ...) | MODE-136 at 2 and 4 MB; at 1 MB Phoenix's 1 MB table lowered by the 112-byte formula | p3 does not know the 32-bit bus; Phoenix has a separate 1 MB table |

## Write order observed (both ROMs, every packed mode)

Screen off first (SR00 = 01h, SR01 bit 5 = 1, SR00 = 03h), then a VGA-like base (CR00, CR54 = 38h,
CR60 = 07h, CR67 = 00h, CR3B), then SR12, SR13, SR15 = 00h then 02h, then the mode's CR00, CR54, CR60,
CR3B, CR67 (and SR15 = 12h, CR67 again in 107h), and the screen on (SR01 = 01h) last. Every CR54, CR60,
SR12, SR13 and SR15 write happens with SR01 bit 5 = 1, as MODE-138 and MODE-140 ask.

## Memory size (1 and 4 MB)

- **1 MB, both ROMs:** 4F01 gives ModeAttributes 001Ah (bit 0 = 0, not supported) for 107h, 112h, 115h,
  116h and 117h, but 4F02 still sets them (AX = 004Fh). MODE-101 refuses them (014Fh). p3 additionally
  refuses 106h (removed) at every size.
- **1 MB FIFO M (CR54 bits 7-3), derived (D = 56) against p3:** 100h 16 / 31, 101h 16 / 21, 103h 8 / 14,
  105h 4 / 6, 110h-111h 6 / 6, 113h-114h 2 / 3 (at 54.9 MHz). p3 is above the derived value in 100h,
  101h, 103h, 105h and 113h/114h; no 1 MB card has been run (MQ-11).
- **4 MB:** p3 gives the same registers as with 2 MB (only the 4F01 page counts differ). The 1.5-07 run
  at 4 MB covered 100h-10Eh and agreed with its 2 MB values there.

## Return to the VGA modes

For modes 00h-07h and 0Dh-13h, from a clean POST and after 4F02 of 101h, 107h (clock-doubled), 117h
and 112h, in both ROMs:

- The standard registers (MISC, SR00-04, CR00-18, AR00-14, GR00-08) are the same in all five cases.
- The S3 registers are the same in all five cases and in every VGA mode: SRB 00h, SR18 40h (bit 7 = 0),
  CR31 05h, CR32 40h, CR33 00h, CR34 00h, CR35 00h, CR3A 05h, CR3B 5Ah, CR3C 10h, CR40 F0h, CR42 00h,
  CR43 00h, CR50 00h, CR51 00h, CR53 00h, CR54 38h (M = 7), CR58 03h, CR5D 00h, CR5E 00h, CR60 07h,
  CR67 00h, CR69 00h, CR6A 00h; 4AE8h = 02h.
- Differences only: SR12/SR13 keep the VESA mode's PLL values in the model (the chip reloads them from
  MISC bits 3-2; a model limit) and SR15 is 03h after POST and 02h after a VESA mode (bit 0).
- Against the spec: CR31 05h (bits 0 and 2, allowed by MODE-146, MQ-8), CR32 bit 6 = 1, CR3A bits 2-0 =
  101b (1 refresh per line, MQ-5), CR54/CR60 = 38h/07h where MODE-148 derives F8h/FFh (MQ-6), CR58
  size bits 11b with 2 MB (MODE-131), CR40 bit 0 = 0 (MODE-149).

## Per mode: derived values against the two ROMs (2 MB, MCLK 54.89 MHz)

"Derived" = the formulas of [`spec-b-modeset.md`](spec-b-modeset.md) (DMT or IBM timing, data book PLL procedure, MODE-136 M).
SR18 and CR58 show only the bit the spec fixes (bit 7, bit 4); the other bits are POST's. Rates are
the emulator's (`Machine.frame()`); an interlaced mode shows its field rate.

#### 100h: 640x400, 8 bpp, 70

Equal in all three: SR12 61, SR13 28, SR15 02, SR18 b7=0, CR67 00, CR00 5F, CR01 4F, CR02 50, CR06 BF, CR07 1F, CR09 40, CR10 9C, CR11 8E, CR12 8F, CR13 50, CR31 09, CR32 00, CR34 10, CR3A 15, CR42 00, CR43 00, CR50 40, CR51 00, CR54 F8, CR5D 00, CR60 FF.

| Register | Derived | 1.5-07 | 1.5-07-p3 |
| --- | --- | --- | --- |
| MISC | 6F | EF | EF |
| CR03 | 83 | 82 | 82 |
| CR04 | 52 | 54 | 54 |
| CR05 | 9E | 80 | 80 |
| CR15 | 8F | 96 | 96 |
| CR16 | C0 | B9 | B9 |
| CR3B | 5A | 58 | 58 |
| CR58 | b4=0 | b4=0 | b4=1 |
| CR5E | 40 | 00 | 00 |
| DCLK (MHz) | 25.057 | 25.057 | 25.057 |
| Line total (pixels) | 800 | 800 | 800 |
| Rate (Hz, emulator) | 69.76 | 69.76 | 69.76 |
| FIFO M at 54.9 MHz | 31 | 31 | 31 |
| GR05 / AR10 | 40 / 41 | 40 / 41 | 40 / 41 |

#### 101h: 640x480, 8 bpp, 60

Equal in all three: MISC EF, SR12 61, SR13 28, SR15 02, SR18 b7=0, CR67 00, CR00 5F, CR01 4F, CR02 50, CR06 0B, CR07 3E, CR09 40, CR10 EA, CR11 8C, CR12 DF, CR13 50, CR31 09, CR32 00, CR34 10, CR3A 15, CR42 00, CR43 00, CR50 40, CR51 00, CR54 F8, CR5D 00, CR60 FF.

| Register | Derived | 1.5-07 | 1.5-07-p3 |
| --- | --- | --- | --- |
| CR03 | 83 | 02 | 02 |
| CR04 | 52 | 53 | 53 |
| CR05 | 9E | 9F | 9F |
| CR15 | DF | E7 | E7 |
| CR16 | 0C | 04 | 04 |
| CR3B | 5A | 58 | 58 |
| CR58 | b4=0 | b4=0 | b4=1 |
| CR5E | 40 | 00 | 00 |
| DCLK (MHz) | 25.057 | 25.057 | 25.057 |
| Line total (pixels) | 800 | 800 | 800 |
| Rate (Hz, emulator) | 59.66 | 59.66 | 59.66 |
| FIFO M at 54.9 MHz | 31 | 31 | 31 |
| GR05 / AR10 | 40 / 41 | 40 / 41 | 40 / 41 |

#### 103h: 800x600, 8 bpp, 60

Equal in all three: SR15 02, SR18 b7=0, CR67 00, CR01 63, CR07 F0, CR09 60, CR12 57, CR13 64, CR15 57, CR31 09, CR32 00, CR34 10, CR3A 15, CR42 00, CR43 00, CR51 00, CR60 FF.

| Register | Derived | 1.5-07 | 1.5-07-p3 |
| --- | --- | --- | --- |
| MISC | 2F | EF | 2F |
| SR12 | 43 | 48 | 42 |
| SR13 | 36 | 63 | 2B |
| CR00 | 7F | 7B | 7F |
| CR02 | 64 | 63 | 63 |
| CR03 | 83 | 80 | 80 |
| CR04 | 69 | 67 | 69 |
| CR05 | 19 | 10 | 19 |
| CR06 | 72 | 6F | 72 |
| CR10 | 59 | 58 | 58 |
| CR11 | 8D | 8A | 8C |
| CR16 | 73 | 00 | 00 |
| CR3B | 7A | 74 | 78 |
| CR50 | 80 | 80 | 82 |
| CR54 | A8 | F8 | A8 |
| CR58 | b4=0 | b4=0 | b4=1 |
| CR5D | 00 | 00 | 08 |
| CR5E | 40 | 00 | 00 |
| DCLK (MHz) | 40.091 | 36.153 | 40.270 |
| Line total (pixels) | 1056 | 1024 | 1056 |
| Rate (Hz, emulator) | 60.45 | 56.49 | 60.72 |
| FIFO M at 54.9 MHz | 21 | 31 | 21 |
| GR05 / AR10 | 40 / 41 | 00 / 01 | 00 / 01 |

#### 105h: 1024x768, 8 bpp, 60

Equal in all three: MISC EF, SR15 02, SR18 b7=0, CR67 00, CR01 7F, CR13 80, CR31 09, CR32 00, CR34 10, CR3A 15, CR43 00, CR50 00, CR51 00, CR5D 00, CR60 FF.

| Register | Derived | 1.5-07 | 1.5-07-p3 |
| --- | --- | --- | --- |
| SR12 | 43 | 42 | 42 |
| SR13 | 59 | 30 | 47 |
| CR00 | A3 | 9A | A4 |
| CR02 | 80 | 7F | 7F |
| CR03 | 87 | 9D | 07 |
| CR04 | 83 | 81 | 83 |
| CR05 | 94 | 17 | 95 |
| CR06 | 24 | 97 | 25 |
| CR07 | F5 | 1F | F5 |
| CR09 | 60 | 40 | 60 |
| CR10 | 03 | 80 | 02 |
| CR11 | 89 | 84 | 88 |
| CR12 | FF | 7F | FF |
| CR15 | FF | 80 | FF |
| CR16 | 25 | 00 | 25 |
| CR3B | 9E | 93 | 9D |
| CR42 | 00 | 20 | 00 |
| CR54 | 58 | F8 | 58 |
| CR58 | b4=0 | b4=0 | b4=1 |
| CR5E | 40 | 00 | 00 |
| DCLK (MHz) | 65.148 | 44.744 | 65.327 |
| Line total (pixels) | 1344 | 1272 | 1352 |
| Rate (Hz, emulator) | 60.14 | 86.01 (field rate, interlaced) | 59.87 |
| FIFO M at 54.9 MHz | 11 | 31 | 11 |
| GR05 / AR10 | 40 / 41 | 00 / 01 | 00 / 01 |

#### 107h: 1280x1024, 8 bpp, 60

Equal in all three: SR15 12, SR18 b7=1, CR01 9F, CR02 A0, CR12 FF, CR13 A0, CR31 09, CR32 00, CR34 10, CR3A 15, CR43 00, CR50 C0, CR51 00, CR5D 00, CR60 FF.

| Register | Derived | 1.5-07 | 1.5-07-p3 |
| --- | --- | --- | --- |
| MISC | 2F | EF | EF |
| SR12 | 25 | 20 | 21 |
| SR13 | 68 | 13 | 2D |
| CR67 | 10 | 11 | 10 |
| CR00 | CE | C0 | D7 |
| CR03 | 92 | 83 | 1A |
| CR04 | A6 | A4 | A5 |
| CR05 | 14 | 19 | 1D |
| CR06 | 28 | 18 | 1E |
| CR07 | 5A | B2 | 52 |
| CR09 | 60 | 60 | 40 |
| CR10 | 01 | 01 | 03 |
| CR11 | 84 | 85 | 86 |
| CR15 | FF | 00 | 00 |
| CR16 | 29 | 18 | 00 |
| CR3B | C9 | B9 | D0 |
| CR42 | 00 | 20 | 00 |
| CR54 | 28 | D0 | 28 |
| CR58 | b4=0 | b4=0 | b4=1 |
| CR5E | 51 | 00 | 55 |
| DCLK (MHz) | 108.409 | 75.170 | 112.159 |
| Line total (pixels) | 1688 | 1576 | 1760 |
| Rate (Hz, emulator) | 60.25 | 88.66 (field rate, interlaced) | 60.35 |
| FIFO M at 54.9 MHz | 5 | 26 | 5 |
| GR05 / AR10 | 40 / 41 | 00 / 01 | 00 / 01 |

#### 110h: 640x480, 15 bpp, 60

Equal in all three: MISC EF, SR12 61, SR13 28, SR15 02, SR18 b7=0, CR67 30, CR01 9F, CR02 A0, CR07 3E, CR09 40, CR12 DF, CR13 A0, CR31 09, CR32 00, CR34 10, CR3A 15, CR42 00, CR43 00, CR50 50, CR51 00, CR5D 00, CR60 FF.

| Register | Derived | 1.5-07 | 1.5-07-p3 |
| --- | --- | --- | --- |
| CR00 | C3 | C2 | C2 |
| CR03 | 87 | 84 | 84 |
| CR04 | A4 | A3 | A3 |
| CR05 | 1C | 1B | 1B |
| CR06 | 0B | 0C | 0C |
| CR10 | EA | E9 | E9 |
| CR11 | 8C | 8B | 8B |
| CR15 | DF | E7 | E7 |
| CR16 | 0C | 04 | 04 |
| CR3B | BE | BB | BB |
| CR54 | 80 | 58 | 58 |
| CR58 | b4=0 | b4=0 | b4=1 |
| CR5E | 40 | 00 | 00 |
| DCLK (MHz) | 25.057 | 25.057 | 25.057 |
| Line total (pixels) | 800 | 796 | 796 |
| Rate (Hz, emulator) | 59.66 | 59.84 | 59.84 |
| FIFO M at 54.9 MHz | 16 | 11 | 11 |
| GR05 / AR10 | 40 / 41 | 40 / 41 | 40 / 41 |

#### 111h: 640x480, 16 bpp, 60

Equal in all three: MISC EF, SR12 61, SR13 28, SR15 02, SR18 b7=0, CR67 50, CR01 9F, CR02 A0, CR07 3E, CR09 40, CR12 DF, CR13 A0, CR31 09, CR32 00, CR34 10, CR3A 15, CR42 00, CR43 00, CR50 50, CR51 00, CR5D 00, CR60 FF.

| Register | Derived | 1.5-07 | 1.5-07-p3 |
| --- | --- | --- | --- |
| CR00 | C3 | C2 | C2 |
| CR03 | 87 | 84 | 84 |
| CR04 | A4 | A3 | A3 |
| CR05 | 1C | 1B | 1B |
| CR06 | 0B | 0C | 0C |
| CR10 | EA | E9 | E9 |
| CR11 | 8C | 8B | 8B |
| CR15 | DF | E7 | E7 |
| CR16 | 0C | 04 | 04 |
| CR3B | BE | BB | BB |
| CR54 | 80 | 58 | 58 |
| CR58 | b4=0 | b4=0 | b4=1 |
| CR5E | 40 | 00 | 00 |
| DCLK (MHz) | 25.057 | 25.057 | 25.057 |
| Line total (pixels) | 800 | 796 | 796 |
| Rate (Hz, emulator) | 59.66 | 59.84 | 59.84 |
| FIFO M at 54.9 MHz | 16 | 11 | 11 |
| GR05 / AR10 | 40 / 41 | 40 / 41 | 40 / 41 |

#### 112h: 640x480, 24 bpp, 60

Equal in all three: MISC EF, SR12 61, SR13 28, SR15 02, SR18 b7=0, CR67 D0, CR00 5F, CR01 4F, CR06 0B, CR07 3E, CR09 40, CR10 EA, CR11 8C, CR12 DF, CR13 40, CR31 09, CR32 00, CR34 10, CR3A 15, CR42 00, CR43 00, CR50 70, CR51 10, CR5D 00.

| Register | Derived | 1.5-07 | 1.5-07-p3 |
| --- | --- | --- | --- |
| CR02 | 50 | 51 | 51 |
| CR03 | 83 | 02 | 02 |
| CR04 | 52 | 53 | 53 |
| CR05 | 9E | 9F | 9F |
| CR15 | DF | E7 | E7 |
| CR16 | 0C | 04 | 04 |
| CR3B | 5A | 58 | 58 |
| CR54 | 30 | 38 | 30 |
| CR58 | b4=0 | b4=0 | b4=1 |
| CR5E | 40 | 00 | 00 |
| CR60 | FF | 1C | 1C |
| DCLK (MHz) | 25.057 | 25.057 | 25.057 |
| Line total (pixels) | 800 | 800 | 800 |
| Rate (Hz, emulator) | 59.66 | 59.66 | 59.66 |
| FIFO M at 54.9 MHz | 6 | 7 | 6 |
| GR05 / AR10 | 40 / 41 | 40 / 41 | 40 / 41 |

#### 113h: 800x600, 15 bpp, 60

Equal in all three: MISC 2F, SR15 02, SR18 b7=0, CR67 30, CR00 03, CR01 C7, CR02 C8, CR06 72, CR07 F0, CR09 60, CR12 57, CR13 C8, CR15 57, CR31 09, CR32 00, CR34 10, CR3A 15, CR42 00, CR43 00, CR51 00, CR5D 01, CR60 FF.

| Register | Derived | 1.5-07 | 1.5-07-p3 |
| --- | --- | --- | --- |
| SR12 | 43 | 42 | 42 |
| SR13 | 36 | 2B | 2B |
| CR03 | 87 | 06 | 06 |
| CR04 | D2 | D3 | D3 |
| CR05 | 12 | 13 | 13 |
| CR10 | 59 | 58 | 58 |
| CR11 | 8D | 8C | 8C |
| CR16 | 73 | 00 | 00 |
| CR3B | FE | FC | FC |
| CR50 | 90 | 92 | 92 |
| CR54 | 40 | 98 | 40 |
| CR58 | b4=0 | b4=0 | b4=1 |
| CR5E | 40 | 00 | 00 |
| DCLK (MHz) | 40.091 | 40.270 | 40.270 |
| Line total (pixels) | 1056 | 1056 | 1056 |
| Rate (Hz, emulator) | 60.45 | 60.72 | 60.72 |
| FIFO M at 54.9 MHz | 8 | 19 | 8 |
| GR05 / AR10 | 40 / 41 | 00 / 01 | 00 / 01 |

#### 114h: 800x600, 16 bpp, 60

Equal in all three: MISC 2F, SR15 02, SR18 b7=0, CR67 50, CR00 03, CR01 C7, CR02 C8, CR06 72, CR07 F0, CR09 60, CR12 57, CR13 C8, CR15 57, CR31 09, CR32 00, CR34 10, CR3A 15, CR42 00, CR43 00, CR51 00, CR5D 01, CR60 FF.

| Register | Derived | 1.5-07 | 1.5-07-p3 |
| --- | --- | --- | --- |
| SR12 | 43 | 42 | 42 |
| SR13 | 36 | 2B | 2B |
| CR03 | 87 | 06 | 06 |
| CR04 | D2 | D3 | D3 |
| CR05 | 12 | 13 | 13 |
| CR10 | 59 | 58 | 58 |
| CR11 | 8D | 8C | 8C |
| CR16 | 73 | 00 | 00 |
| CR3B | FE | FC | FC |
| CR50 | 90 | 92 | 92 |
| CR54 | 40 | 98 | 40 |
| CR58 | b4=0 | b4=0 | b4=1 |
| CR5E | 40 | 00 | 00 |
| DCLK (MHz) | 40.091 | 40.270 | 40.270 |
| Line total (pixels) | 1056 | 1056 | 1056 |
| Rate (Hz, emulator) | 60.45 | 60.72 | 60.72 |
| FIFO M at 54.9 MHz | 8 | 19 | 8 |
| GR05 / AR10 | 40 / 41 | 00 / 01 | 00 / 01 |

#### 115h: 800x600, 24 bpp, 60

Equal in all three: MISC 2F, SR15 02, SR18 b7=0, CR67 D0, CR00 7F, CR01 63, CR02 64, CR04 69, CR05 19, CR06 72, CR07 F0, CR09 60, CR12 57, CR13 90, CR15 57, CR31 09, CR32 00, CR34 10, CR3A 15, CR42 00, CR43 00, CR51 10, CR60 FF.

| Register | Derived | 1.5-07 | 1.5-07-p3 |
| --- | --- | --- | --- |
| SR12 | 43 | 42 | 42 |
| SR13 | 36 | 2B | 2B |
| CR03 | 83 | 80 | 80 |
| CR10 | 59 | 58 | 58 |
| CR11 | 8D | 8C | 8C |
| CR16 | 73 | 00 | 00 |
| CR3B | 7A | 78 | 78 |
| CR50 | B0 | B2 | B2 |
| CR54 | 10 | 20 | 10 |
| CR58 | b4=0 | b4=0 | b4=1 |
| CR5D | 00 | 08 | 08 |
| CR5E | 40 | 00 | 00 |
| DCLK (MHz) | 40.091 | 40.270 | 40.270 |
| Line total (pixels) | 1056 | 1056 | 1056 |
| Rate (Hz, emulator) | 60.45 | 60.72 | 60.72 |
| FIFO M at 54.9 MHz | 2 | 4 | 2 |
| GR05 / AR10 | 40 / 41 | 00 / 01 | 00 / 01 |

#### 116h: 1024x768, 15 bpp, 60

Equal in all three: MISC EF, SR15 02, SR18 b7=0, CR67 30, CR01 FF, CR02 00, CR13 00, CR31 09, CR32 00, CR34 10, CR3A 15, CR43 00, CR50 10, CR51 10, CR60 FF.

| Register | Derived | 1.5-07 | 1.5-07-p3 |
| --- | --- | --- | --- |
| SR12 | 43 | 42 | 42 |
| SR13 | 59 | 30 | 47 |
| CR00 | 4B | 38 | 4D |
| CR03 | 9F | 00 | 0D |
| CR04 | 06 | 03 | 07 |
| CR05 | 80 | 0F | 09 |
| CR06 | 24 | 97 | 25 |
| CR07 | F5 | 1F | F5 |
| CR09 | 60 | 40 | 60 |
| CR10 | 03 | 80 | 02 |
| CR11 | 89 | 84 | 88 |
| CR12 | FF | 7F | FF |
| CR15 | FF | 80 | FF |
| CR16 | 25 | 00 | 25 |
| CR3B | 46 | 31 | 46 |
| CR42 | 00 | 20 | 00 |
| CR54 | 20 | 28 | 20 |
| CR58 | b4=0 | b4=0 | b4=1 |
| CR5D | 7D | 75 | 7D |
| CR5E | 40 | 00 | 00 |
| DCLK (MHz) | 65.148 | 44.744 | 65.327 |
| Line total (pixels) | 1344 | 1268 | 1352 |
| Rate (Hz, emulator) | 60.14 | 86.28 (field rate, interlaced) | 59.87 |
| FIFO M at 54.9 MHz | 4 | 5 | 4 |
| GR05 / AR10 | 40 / 41 | 00 / 01 | 00 / 01 |

#### 117h: 1024x768, 16 bpp, 60

Equal in all three: MISC EF, SR15 02, SR18 b7=0, CR67 50, CR01 FF, CR02 00, CR13 00, CR31 09, CR32 00, CR34 10, CR3A 15, CR43 00, CR50 10, CR51 10, CR60 FF.

| Register | Derived | 1.5-07 | 1.5-07-p3 |
| --- | --- | --- | --- |
| SR12 | 43 | 42 | 42 |
| SR13 | 59 | 30 | 47 |
| CR00 | 4B | 38 | 4D |
| CR03 | 9F | 00 | 0D |
| CR04 | 06 | 03 | 07 |
| CR05 | 80 | 0F | 09 |
| CR06 | 24 | 97 | 25 |
| CR07 | F5 | 1F | F5 |
| CR09 | 60 | 40 | 60 |
| CR10 | 03 | 80 | 02 |
| CR11 | 89 | 84 | 88 |
| CR12 | FF | 7F | FF |
| CR15 | FF | 80 | FF |
| CR16 | 25 | 00 | 25 |
| CR3B | 46 | 31 | 46 |
| CR42 | 00 | 20 | 00 |
| CR54 | 20 | 28 | 20 |
| CR58 | b4=0 | b4=0 | b4=1 |
| CR5D | 7D | 75 | 7D |
| CR5E | 40 | 00 | 00 |
| DCLK (MHz) | 65.148 | 44.744 | 65.327 |
| Line total (pixels) | 1344 | 1268 | 1352 |
| Rate (Hz, emulator) | 60.14 | 86.28 (field rate, interlaced) | 59.87 |
| FIFO M at 54.9 MHz | 4 | 5 | 4 |
| GR05 / AR10 | 40 / 41 | 00 / 01 | 00 / 01 |
