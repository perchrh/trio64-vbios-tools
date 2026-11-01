# Trio64V2/DX ROM (775): fixes and improvements

What 2.04.07-pN (the level in [`common/version.inc`](../common/version.inc), now p22) changes against the S3 reference BIOS
2.04.07, each with the issue that has the details: what was wrong or missing, the cause, the effect
and how it is tested. The build, the byte-level changes, what was borrowed, not taken or omitted, and
what is left are in [`docs/775-rom.md`](775-rom.md); the speed measured on the card is in README "Speed". The Trio64V+
and Trio64 ROMs carry backports of many of these ([`docs/765-changes.md`](765-changes.md), [`docs/764-changes.md`](764-changes.md)).

| Change | Kind | Level | Issue |
| --- | --- | --- | --- |
| Blank pedestal off (black level); the card's POST flags and CR80 value | picture | before p9 | [#63](https://github.com/perchrh/trio64-vbios-tools/issues/63) |
| 60 Hz defaults for 1280x1024 and 1600x1200 | picture, fix | p6 | [#64](https://github.com/perchrh/trio64-vbios-tools/issues/64) |
| 640x480 class at 800 pixels per line | picture | p6 | [#65](https://github.com/perchrh/trio64-vbios-tools/issues/65) |
| 320x240 at 60 Hz (131h-133h) | picture | before p9 | [#66](https://github.com/perchrh/trio64-vbios-tools/issues/66) |
| 1600x1200: 1200 displayed lines | fix | p14 | [#56](https://github.com/perchrh/trio64-vbios-tools/issues/56) |
| DCLK VCO in 170-340 MHz (XFree86 range) | fix | p14 | [#57](https://github.com/perchrh/trio64-vbios-tools/issues/57) |
| Memory clock 59.96 MHz | speed | before p9 | [#58](https://github.com/perchrh/trio64-vbios-tools/issues/58) |
| MCLK build option, `make roms` | speed | p16 and later | [#112](https://github.com/perchrh/trio64-vbios-tools/issues/112) |
| Banked VESA booster (with the Windows check, the base kept in CR6D) | speed | p7, p17, p18, p22 | [#47](https://github.com/perchrh/trio64-vbios-tools/issues/47) |
| Fast 4F05 set window | speed | p12 | [#59](https://github.com/perchrh/trio64-vbios-tools/issues/59) |
| 32-bit clear of every S3/VESA mode set | speed | p11 | [#60](https://github.com/perchrh/trio64-vbios-tools/issues/60) |
| 32-bit VGA mode set clear, font load, mode 13h scroll | speed | p12 | [#61](https://github.com/perchrh/trio64-vbios-tools/issues/61) |
| 32-bit text and planar scrolls, AH=09h | speed | p13 | [#62](https://github.com/perchrh/trio64-vbios-tools/issues/62) |
| Attribute controller flip-flop reset after a mode set | fix | p7 | [#52](https://github.com/perchrh/trio64-vbios-tools/issues/52) |
| FIFO fetch (CR90 bit 7) off in VGA modes | fix | p7 | [#53](https://github.com/perchrh/trio64-vbios-tools/issues/53) |
| 512x384x8: CR50 pixel length | fix | p8 | [#54](https://github.com/perchrh/trio64-vbios-tools/issues/54) |
| 4F06 BL=3: the real maximum line length | fix | p8 | [#55](https://github.com/perchrh/trio64-vbios-tools/issues/55) |
| DDC (4F15): delay, probe count, interrupts off | fix | p19 | [#49](https://github.com/perchrh/trio64-vbios-tools/issues/49) |
| POST delay before the engine reset | fix | p20 | [#48](https://github.com/perchrh/trio64-vbios-tools/issues/48) |
| CR23 = 00h before CR26 | fix | p19 | [#50](https://github.com/perchrh/trio64-vbios-tools/issues/50) |
| Mode 13h scroll keeps EAX | fix | p21 | [#51](https://github.com/perchrh/trio64-vbios-tools/issues/51) |
| DDC delay without the first-reading race | fix | p22 | [#86](https://github.com/perchrh/trio64-vbios-tools/issues/86) |
| Booster base and Windows mark kept apart | fix | p22 | [#87](https://github.com/perchrh/trio64-vbios-tools/issues/87) |
| The 32 KB twice in the 64 KB image | fix | p15, p22 | [#78](https://github.com/perchrh/trio64-vbios-tools/issues/78) |

## In detail

The ROM is the S3 Trio64V2/DX reference BIOS 2.04.07 with the changes below in the lower 32 KB; the
upper 32 KB is a copy of it ([`docs/775-rom.md`](775-rom.md), "The build"). The lower half checksums to 0. Every change keeps
the standard VGA modes (00h-13h) and the VESA modes compatible, and the RAM stays in 1-cycle EDO mode.
Video memory of 2 MB and 4 MB is supported (the 86C775 maximum). In the CGA, MDA and EGA modes the ROM
behaves exactly like the reference (`make 775-ref-compare`); the changes there only make it faster. About
100 bytes of the lower 32 KB are free: 0x7CD9-7CFA, 0x7E36-7E3F, 0x7E59-7E5F, 0x7E79-7E7F,
0x7F51-7F57, 0x7FB7-7FBF, 0x7FE3-7FFE.

Picture and monitor

- **Black level** ([#63](https://github.com/perchrh/trio64-vbios-tools/issues/63)): the blank pedestal is off at POST (header flag 0xD1 bit 1 cleared, SR1A bit 5 never
  set): the deepest black, no grey lift.
- **60 Hz defaults for 1280x1024 and 1600x1200** ([#64](https://github.com/perchrh/trio64-vbios-tools/issues/64)) (CR41/CR52 refresh fields): they work on 60 Hz LCDs;
  the reference defaults to rates LCDs reject.
- **640x480 class at exactly 800 pixels per line** ([#65](https://github.com/perchrh/trio64-vbios-tools/issues/65)) (the reference has 792/796) in the 640x480 and
  320x240 tables: the VESA 640x480 @ 60 Hz line (31.3-31.5 kHz), so one LCD preset covers every mode
  of that class.
- **320x240 at 60 Hz** (131h, 132h, 133h; [#66](https://github.com/perchrh/trio64-vbios-tools/issues/66)): new CRTC tables, 640x480 @ 60 Hz halved horizontally and
  double scanned, so LCDs see a standard 640x480 @ 60 Hz signal without scaling waves; 132h/133h at 2
  clocks per pixel.
- **1600x1200 (120h)** ([#56](https://github.com/perchrh/trio64-vbios-tools/issues/56)): vertical display end 1200 lines (CR12 AFh), as 4F01 reports; the reference
  shows 1201.
- **DCLK PLL in the XFree86 range** ([#57](https://github.com/perchrh/trio64-vbios-tools/issues/57)): 22 refresh entries of the reference ran the VCO at 145-162 MHz,
  inside the datasheet range (135-340 MHz) but below the 170 MHz minimum XFree86 uses; new M/N/R give
  exactly the same pixel clock with the VCO in 170-340 MHz (smallest R, then smallest N). The data book
  itself allows 135-340 MHz, which the tools and the patcher's result check use; the moved entries
  stay because the ROM was built and tested with them (`--no-vco-fix` leaves them as in 2.04.07).
  Each mode's refresh list starts at the entry its mode table pointer gives and runs downwards to the
  entry with bit 7 of byte 2 set.
- 1280x1024x16 colours (106h) keeps the VESA DMT timing (108 MHz, 64 kHz, 60 Hz): 14% above the 95 MHz
  single-clock datasheet limit but clean on the card; a reduced-blanking timing made a
  1280x1024-incapable LCD report out of range.

Speed

- **Memory clock 59.96 MHz** ([#58](https://github.com/perchrh/trio64-vbios-tools/issues/58); other clocks: the MCLK build option, [#112](https://github.com/perchrh/trio64-vbios-tools/issues/112)) (SR11=41h, SR10=42h, VCO 239.8 MHz) instead of 50.11 MHz: about 20% more
  memory bandwidth; 59.96 MHz is the 1-cycle EDO maximum (16.67 ns). CR36 bits 3-2 stay 00. The CR88
  bit 1 tweak of the reference compares SR10/SR11 with the old MCLK values and so stays off.
- **Banked VESA booster** ([#47](https://github.com/perchrh/trio64-vbios-tools/issues/47), [#87](https://github.com/perchrh/trio64-vbios-tools/issues/87)): the banked 8/15/16/24/32 bpp modes use the linear path through a 64 KB
  window at A0000h; the real LFB base is kept in CR6D and restored on the next mode set, and 4F01 and
  4F05/4F03 report it correctly. Banked writes at 83.7 MB/s, as fast as the LFB. It is switched on at
  the end of a banked 4F02, so every way of switching banks gets it (INT 10h 4F05, the window
  function, the 4F0A protected-mode code, programs that write CR6A themselves), and by the first bank
  switch (4F05 set window or the window function) in the S3 modes set with INT 10h AH=00, which do
  not pass the end of 4F02. It stays off while Windows runs in enhanced mode (INT 2Fh AX=1600h,
  asked once per mode set and remembered as CR6D = 01h): Windows 98's S3 driver needs CR58-CR5A as
  the reference leaves them after a banked 4F02, and restores a full-screen DOS box wrongly when the
  booster was on in it (README "Windows 9x driver test").
- **Fast 4F05 set window** ([#59](https://github.com/perchrh/trio64-vbios-tools/issues/59)): AX=4F05h BH=0 is handled at the INT 10h entry (unlock, CR58 test, SR04 for
  planar banks, CR6A; the 3C4h index is kept): 6 port writes and 3 reads instead of 13 writes and
  about 6 reads, 4.3 us per call on the card. Get and errors are unchanged; in a banked mode with the
  booster still off (an AH=00 S3 mode) the first call turns it on, as the window function does.
- **32-bit video memory stores** where the reference uses 8- or 16-bit ones, with the same result:
  - ([#60](https://github.com/perchrh/trio64-vbios-tools/issues/60)) the 2 MB clear of every S3/VESA mode set (rep stosd through the same 64 KB banks; the clear is
    most of a VESA mode set's time)
  - ([#61](https://github.com/perchrh/trio64-vbios-tools/issues/61)) the clear of modes 00h-13h and the font load into plane 2 (every text mode set and AX=11xxh):
    mode set 03h with 9368 video writes instead of 20632, 12h/13h 16384 instead of 32768
  - ([#61](https://github.com/perchrh/trio64-vbios-tools/issues/61)) AH=06h scrolls in mode 13h (moves and fills, full screen and windows; AH=07h keeps the original
    code)
  - ([#62](https://github.com/perchrh/trio64-vbios-tools/issues/62)) AH=06h/07h in the text modes: the blank fill (the clear screen of most programs and every line an
    AH=0Eh scroll adds) and the window line moves and fills, in both directions
  - ([#62](https://github.com/perchrh/trio64-vbios-tools/issues/62)) AH=06h/07h in modes 0Dh-12h: the set/reset fill (the moves stay bytes: write mode 1 copies through
    the 8-bit latches)
  - ([#62](https://github.com/perchrh/trio64-vbios-tools/issues/62)) AH=09h in the text modes, both page paths

Fixes

- **Attribute controller** ([#52](https://github.com/perchrh/trio64-vbios-tools/issues/52)): an input status read after every mode set resets the index/data
  flip-flop, for programs that write port 3C0h right after a mode set.
- **FIFO fetch** ([#53](https://github.com/perchrh/trio64-vbios-tools/issues/53)): CR90 bit 7 is cleared after setting any VGA mode 00h-13h; fixes stripes and garbage
  in Mode X and 360-wide modes after a VESA mode (Quake 360x200).
- **512x384x8 (151h)** ([#54](https://github.com/perchrh/trio64-vbios-tools/issues/54)): CR50 40h, the correct graphics engine pixel length (the reference has the
  reserved 10b).
- **VBE 4F06 BL=3** ([#55](https://github.com/perchrh/trio64-vbios-tools/issues/55)): the real maximum line length, BX = min(8184, memory / lines) rounded down to 8 and
  CX = BX in pixels (4368 in 101h with 2 MB, 8184 with 4 MB; the reference returns 546).
- **DDC (VBE 4F15), as in the S3 BIOS 2.04.11** (the card's stock BIOS), p19 ([#49](https://github.com/perchrh/trio64-vbios-tools/issues/49)):
  - The delay the DDC code waits between line changes sets PIT channel 2 with B6h (mode 3, low then
    high byte). 2.04.07 wrote 86h, only the latch command, loaded the count in whatever access mode
    channel 2 had and never read the latch; the 8254 ignores a second latch while one is pending, so
    the first read gave a stale count and most delays came out far too short.
  - The probe passes its 0255h delay in AX (5E07h); 2.04.07 loaded BX, so the delay used whatever AX
    held.
  - Interrupts are off for the whole 4F15 operation, so a timer interrupt cannot stretch a clock
    pulse.
  - All three are the 2.04.11 code. POST calls the same delay once (14E5h); see the next item.
  - The card connects the DDC lines to the VGA connector, and the DDC2 path works: with p21, Windows
    98 identified a Dell 2021FP from its EDID read over DDC2 (31 October 2026) instead of showing a
    generic Plug and Play monitor.
- **POST delay before the graphics engine reset** (p20, [#48](https://github.com/perchrh/trio64-vbios-tools/issues/48)): POST turns RAM refresh off (CR88 bit 6, a
  register the datasheet calls valid only for the Trio64V2/GX), waits, resets the graphics engine
  (CR66 = 02h, then 00h) and turns refresh on again. The wait loads its count 0Ah into BX, but the
  delay routine takes AX, which still holds the CR88 index and value (4088h when CR88 was 00h). With
  the broken 2.04.07 delay that was a random wait, often near 0; with the 2.04.11 delay (the stock BIOS
  and p19) it was 13.8 ms. The ROM loads AX = 000Ah: 8 us, as S3 meant (2.04.11 has the same mix-up).
  No visible effect is expected: POST is 14 ms shorter (2290 to 2276 ms on the emulator's virtual
  clock), and RAM refresh is off for 8 us instead of 13.8 ms on a GX card. The short wait of 2.04.07
  worked on cards everywhere, and at POST the video memory holds nothing worth keeping.
- **CR23 before CR26** ([#50](https://github.com/perchrh/trio64-vbios-tools/issues/50)): every mode set writes CR23 = 00h, then CR26 = 00h (p19). Trio64V2 datasheet
  section 4.2: CR23 "must be 00H before CR26 is written", and "the BIOS must write 00H to [CR26] upon
  each mode set (assuming CR23 is at its default value of 00H)". A driver that used vertical
  interpolation for a video window (section 3.2.2) may leave CR23 set; 2.04.07 wrote only CR26.
  2.04.11 clears CR23 first when the mode in the BIOS data area is above 13h; the ROM does it on every
  mode set (CR23 is reserved, 00h by default).
- **Mode 13h scroll keeps EAX** (p21, [#51](https://github.com/perchrh/trio64-vbios-tools/issues/51)): the 32-bit mode 13h scroll (p12, `p12ext.asm` scr13) used EAX
  bits 31-16 without saving them. AH=06h/07h pass the dispatcher, which saves the 32-bit registers,
  but AH=0Eh takes its fast path at the INT 10h entry, so a line feed on the last row in mode 13h
  returned EAX bits 31-16 = 0000h; the reference keeps them. Found 30 October 2026 while backporting
  to the Trio64V+ (whose dispatcher saves only 16-bit registers). S3TEST's mode 13h scroll line checks
  it (fail bit 10h), the emulator test rom_patches too.
- **DDC delay without the first-reading race** (p22, [#86](https://github.com/perchrh/trio64-vbios-tools/issues/86)): the p19 delay compared its first PIT
  reading with the loaded count, so a latch within about 1.7 us of the load ended the wait at once and
  the DDC clock ran at bus speed again. The first comparison is now against FFFFh, and the control
  word is written once, inside the cli. The emulator test `ddc` makes the first latch read the loaded
  count and checks that every delay reads the counter again.
- **Booster base and Windows mark kept apart** (p22, [#87](https://github.com/perchrh/trio64-vbios-tools/issues/87)): CR6D held both the booster's saved linear
  base (bits 31-24) and the Windows refusal mark 01h, so a base at 01xxxxxxh was taken for the mark at
  the next mode set and lost. The mode set hook now restores the base first and clears CR6D after it,
  then forgets the mark. The emulator test `rom_patches` runs the booster with base 01000000h.
- **The card's POST flags** (0xD1 = 05h) and CR80 POST value (00h) ([#63](https://github.com/perchrh/trio64-vbios-tools/issues/63)).
