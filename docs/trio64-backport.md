# The Trio64 ROM (1.5-07-p1)

Our changes ported to the Trio64 (86C764) on the Phoenix S3 Trio64 BIOS 1.5-07, in `rompatch/trio64`.
Built and checked in the emulator on 30 October 2026 for the ExpertColor DSP-3364P (86C764-P, 1 MB EDO
50 ns upgraded to 2 MB); not yet run on a card. The choice of base is below ("Base BIOS candidates").

    make trom OUT=S3T64P1.BIN [VSIZE=64] [MCLK=55]   (rompatch/trio64/s3tpatch.py, 32 KB)
    make trom-test ROM=S3T64P1.BIN
    make emu-test ROM=S3T64P1.BIN CHIP=trio64
    make tref-compare ROM=S3T64P1.BIN

Base: `reference/trio64/1_5_07.bin`, the CP764 build of Phoenix 1.5-07 (08/19/96, MCLK 54.9 MHz,
SHA-256 6a28c6b2...). Every 1.5-07 build at hand has the same code from 1000h to 7EFFh; the patcher
checks that code (SHA-256) and the layout of the tables, so another card's own 1.5-07 dump is patched
too and keeps its memory clock and timing bytes (checked with `expertcolor.BIN`, `86c764ptrio64.BIN` and
the "1.5-07 EDO" build). It refuses the Britek "VIEWTOP" build (other sign-on text) and `86c764x2.bin`
(a "V2680" tag at 7FF0h, where code goes).

## What 1.5-07-p1 carries

| Change | How |
| --- | --- |
| No interlaced defaults | The 11 refresh entries that run interlaced (CR42 bit 5, found by setting every mode at every refresh index in the emulator) are removed. The modes that also have non-interlaced rates (1024x768 and 1280x1024 at 8, 15 and 16 bpp, and the 2xxh modes 204h, 205h, 208h with the same timings) now default to their lowest non-interlaced rate: 1024x768 at 59.8 Hz (65.3 MHz), 1280x1024 at 60.3 Hz (112.2 MHz, clock-doubled). |
| Interlaced-only modes removed | 106h (1280x1024x4), 118h (1024x768x16M), 119h and 11Ah (1280x1024x32K/64K) and 120h (1600x1200) exist on the Trio64 only interlaced (1600x1200 at 60 Hz needs 162 MHz, the chip maximum is 135 MHz; the others need clocks above the single-clock limits for their depth, CLK-1). They are gone from the mode table, both VESA lists (4F00 no longer lists them, 4F02 refuses them with 014Fh) and the mode map. |
| 800x600 at 60 Hz | POST writes CR52 = 80h instead of 00h: the refresh index of the 800x600 modes is 1, the 60.7 Hz entry (VESA DMT, line total 1056) instead of 56 Hz. Phoenix writes CR41/CR52 only at POST; a refresh utility can still choose another rate. |
| 32-bit speed patches | VGA mode set clear, font load, mode 13h scroll (with EAX kept), text and planar scrolls, AH=09h: the shared `speed_sites` and .asm files, the same signatures as in 2.04.07 and 1.03-08. |
| Booster with the Windows check | On after a banked 4F02 and at the window set with BH = 0 (4F05 and the window function both call Phoenix's window set at 5123h). The refusal mark is CR52 bit 3 (`tbon.asm` says why not CR6C or CR6D). Phoenix relocks the S3 registers after its calls and its unlock routine changes AX, so the code unlocks itself and leaves CR38/CR39 as found. |
| ATC flip-flop reset | In the mode set hook (AH=00 table and 4F02's call). |
| MCLK build option | `MCLK=` sets the single MCLK entry at 3B5h, at most 60 MHz (MEM-1); without it the build's own clock stays. |

Not applied: the fast 4F05 path (Phoenix's 4F05 already takes 10 port accesses), the 32-bit S3/VESA
mode set clear (Phoenix clears with the graphics engine), the base restore (Phoenix writes CR59 from
CR6B and CR5A from CR6C bit 7 at every mode set), the PLL N = 0 fix (the N = 0 entries were the
interlaced 1280x1024 ones, now removed), the Trio64V2 register fixes and VBE 2.0.

## Where the code went

The removed entries and modes freed 384 bytes in nine places; with two zero runs the stock BIOS never
reads (checked with a broad INT 10h workload in the emulator) that is enough for all of it:

| Range | Was | Now |
| --- | --- | --- |
| 0B4C-0BCF (132) | the end of the refresh lists after their compaction | `tbon.asm`: bon, unlk, relk |
| 0831-0870 (64) | the 1600x1200 register block | `tlock.asm`: wcheck; `tglue.asm`: h4f02, wsetp |
| 0604-0630 (45) | the end of the mode table | `font32.asm` |
| 0140-0183 (68) | zero padding after the second sign-on block | `thook.asm` |
| 7F52-7FFE (173) | zeros at the image end, after the 9x16 alternate font table (its 00h at 7F51h, and its last glyph's blank rows, look free but are not) | `scr13.asm` |
| 4EBE-4EED (48) | the 4F01 records of 118h-120h | `p13fill.asm` |
| 0D79-0D91, 0DDD-0DF5 (25 each) | CRTC tables only removed entries used | `p13bfill.asm`, `p13move.asm` |
| 4E2E-4E39 (12) | the 4F01 record of 106h | `p13df.asm` |
| 0EAC-0EB9 (14) | the old font loop after the font jump | `p13bfa.asm` |

Free after the build: 4D70-4D81 and 4DD1-4DDF (the ends of the VESA lists and the mode map), the rest of
0604h and 0B4Ch, and about 40 bytes of sign-on padding.

## Checked in the emulator (Trio64 model)

`make trom-test`: the tables (no list starts with an interlaced entry, every kept entry unchanged), every
other byte unchanged, another maker's timing bytes and MCLK kept, the MCLK option, the refusals.
`make emu-test CHIP=trio64` with 2, 4 and 1 MB: `t64_patches` (defaults, removed modes, booster, Windows
check, lock state, ATC flip-flop, 32-bit registers), `stores`, `s3test` (the Trio64 set) and the others;
`make tref-compare`: the CGA, MDA and EGA modes behave as in 1.5-07. S3COMPAT's VESA lines: every mode
non-interlaced, 800x600 at 60.7 Hz. Test coverage (`make coverage CHIP=trio64`): 84.6 % of the code, every byte of
the new code among it.

## Left as in 1.5-07

The emulator tests pass these on our Trio64 ROM with a note (`T64_BASE` in `emu/tests.py`); the
unpatched 1.5-07 gives the same lines:

| Test | 1.5-07 behaviour |
| --- | --- |
| errors (1 MB) | 4F02 sets 107h, 112h and 115h-117h, which need more than 1 MB (1.5-07 also set 118h-120h, now removed). |
| windows | 4F06 changes the upper halves of EAX, ECX and EDX (the dispatcher saves only the 16-bit registers). |
| s3compat_vga, s3compat_full | The upper half of the 8x8 font (AX=1130h BH=4) is Phoenix's own design (WARN 02); S3COMPAT's run leaves a register state behind that differs from its baseline (WARN 01). |
| s3test | Phoenix's window set reads SR04 and leaves the sequencer index at 04h: S3TEST's 4F05 line FAIL 02. A save and restore of the index in our window set entry would fix it for BH = 0; not done. |

Phoenix's 1024x768 and 1280x1024 timings and its 640x480x16 use other line totals than VESA DMT
(1352, 1760 and 796 pixels); S3TEST's Trio64 mode list does not check them.

## Base BIOS candidates (30 October 2026)

No S3-built Trio64 BIOS turned up among 14 Trio64 images (no "S3 86C764 Video BIOS", as there is "S3
86C765 Video BIOS 1.03-08" for the Trio64V+). What S3 gave the card makers for the Trio64 appears to be
the Phoenix BIOS: its sign-ons say "Copyright 1992-1993 S3 Incorporated" or "Copyright (c) 1987-95,
Phoenix & S3 Inc.", it carries S3's code for the VGA functions (the signatures of our speed patch sites
match byte for byte, at other addresses), and the 1.5-07 builds of six makers share their code
byte for byte from 1000h to 7EFFh and differ only in the first 4 KB: sign-on, memory clock and the
per-mode memory timing bytes (24 to 214 bytes). So Phoenix 1.5-07 is in effect S3's configurable
reference BIOS for the Trio64, set up by each card maker; its VBE and mode set code differs from
S3's own Trio64V+ BIOS 1.03-08.

| Image | BIOS | Our signatures | Free space at the end | MCLK at POST | Emulator findings (Trio64 model, 2 MB) |
| --- | --- | --- | --- | --- | --- |
| `S3Trio64_1_14-04.bin` (also uploaded 30 October 2026, identical) | Phoenix 1.4-04 | 16 of 23 | 755 bytes (7D0Ch) | 51.9 MHz | PLL N = 0 in 106h/107h (FAIL 200); 800x600 at 56 Hz (WARN 40); 1024x768 interlaced (WARN 50, 10); 8x8 upper font of another design (WARN 02); 4F06 changes EAX/ECX/EDX bits 31-16 |
| `1-30.bin` (miroCRYSTAL, uploaded 30 October 2026) | Phoenix 1.5-04 | 16 of 23 | 243 bytes (7F0Ch) | 53.7 MHz | as 1.4-04, plus 1600x1200 interlaced (WARN 50) and 4F02 setting 118h-11Ah with 2 MB (errors) |
| `5-52.bin` (V7-Mirage P-64 5.52, SPEA/Video Seven, uploaded twice) | Phoenix 1.5-06 | 16 of 23 | 195 bytes (7F3Ch) | 59.96 MHz | as 1.5-04 |
| `expertcolor.BIN` (the name suggests the DSP-3364P) | Phoenix 1.5-07, "764 M70" | 16 of 23 | 179 bytes (7F4Ch) | 69.8 MHz | as 1.5-04, plus MCLK above the data book maximum of 60 MHz (FAIL 2) |
| `dataexpertcp764.BIN` = `W27E257 CP764 V1.5-0 7.BIN` (uploaded) | Phoenix 1.5-07 | 16 of 23 | 179 bytes | 54.9 MHz | the 1.5-07 code; 24 bytes differ from `expertcolor.BIN` |
| `Britek BP-S341 (S3 Trio64).BIN` (uploaded) | Phoenix 1.5-07 as "VIEWTOP Graphics BIOS", "S3 Trio64X (764X)" | 16 of 23 | 164 bytes | 52.5 MHz | the 1.5-07 code |
| `86c764xtrio64.BIN`, `86c764ptrio64.BIN`, `86c764x2.bin` | Phoenix 1.5-07 (one "EDO") | 16 of 23 | 179 bytes | 55.0-55.5 MHz | the 1.5-07 code with other memory timing bytes |
| `2-24-00.bin` (uploaded) | ELSA Winner 1000TRIO 2.24.00 (06/26/96), DPMS, DDC1 | 15 of 23 | 147 bytes (7F6Ch) | 59.96 MHz | ELSA's own VBE code: 75 Hz defaults, OEM modes 204h-418h, 4F06 BL=2/3, 4F07 and 4F04 fail, 4F01 changes EAX/EBX/EDX bits 31-16, PLL N = 0 in 106h, FAIL 200 in 208h (1280x1024x4) |
| Stealth 64 DRAM 2.05 (uploaded) | Diamond 2.05 | 15 of 23 | 58 bytes (7FC5h) | 59.96 MHz | hangs in 4F02 and AH=00 60h (C000:1826h); every VGA mode fails the IBM state block (DS+25h) and mode 12h runs at 72 Hz (MISC EFh): not a base |
| `numbernine.BIN`, ELSA Winner 1000 1.02.00, Stealth 64 2.09 | Number Nine 2.03.10, ELSA, Diamond | 15-16 of 23 | not checked | not checked | OEM code bases, not examined further |

Every image reports PCI 5333:8811h, which the Trio32, Trio64 and Trio64V+ share; none is for an
older chip (the Vision864/964 have other device IDs).

The signatures that match in every Phoenix image: the VGA mode set clear (vclr), the font load (font),
the mode 13h scroll (scr), the text scroll fills and window moves (txfull, txwmov, txwfil), the planar
scroll fills (plfull, plwin), AH=09h text (ah09a, ah09b), the INT 10h entry (int10, INT_AH0E), 4F02's
call of the mode set (m4f02), GETCRTC, RDREG and SEG_SCR. They do not match: the S3/VESA mode set
clear (clr), the 4F05 and window function code (w4f05, wfn, WSET), UNLOCK and the mode set entry
(MODESET), and the CR59 write of 1.03-08 (cr59).

The free space was the deciding difference: 1.5-07 has 173 bytes at its end, the Trio64V+ code takes
about 590 bytes in 1.03-08, and only 1.4-04 (755 bytes) had room for all of it as it was.

### S3's own Trio64V+ BIOS 1.03-08 on a Trio64

The one S3-built BIOS of the family at hand. It does not check for the Trio64V+ (only the stepping in
CR2F, 44h or 54h, for CR66), so it would run on a Trio64; on the emulator's Trio64 model its results
are those on the Trio64V+ model. The model does not know which registers exist only on the
Trio64V+, so the register writes of 1.03-08 and Phoenix 1.5-07 over POST and 16 mode sets were compared
and checked against the Trio32/Trio64 data book:

| Register | 1.03-08 | Phoenix 1.5-07 | Trio64 data book |
| --- | --- | --- | --- |
| CR54, CR60 (display FIFO M and N parameters) | always 30h, 0Fh | per mode: CR54 28h-F8h, CR60 07h-FFh | M and N must be chosen per mode and memory width so that the display FIFO never underruns (section 7.4, T64-MEM-1): the main risk, picture corruption in demanding modes, which only the card shows |
| CR34 | 08h, 18h | 00h, 10h | bit 3 reserved |
| SRD | 02h | not written | bit 1 reserved (bit 0 feature connector, bits 7-4 DPMS) |
| SR1C | 02h | not written | not documented |
| CR37 | 0Fh | not written | harmless: chip on, normal operation, internal clocks; bits 7-5 are BIOS monitor information |
| CR5C (general output port) | 03h | 43h | board wiring: the card maker's value |
| CR40, SR14, SR15, CR66, CR67 | V+ values | Phoenix values | not compared in detail |

It would also identify as "S3 86C765" and "Trio64V+" (4F00 OEM string). So 1.03-08 as a Trio64 base
means more than the backport: per-mode FIFO parameters, no reserved bits, the card's CR5C, and new
names, all to be proven on the card.

**Chosen:** Phoenix 1.5-07, S3's reference for the Trio64 (30 October 2026). The space for the whole
port came from removing the interlaced entries and modes (above), not from an older base.

## Does not apply to the Trio64

The FIFO fix (CR90/CR91, Trio64V2), CR23/CR26 (Trio64V2), the POST delay in AX (CR88, Trio64V2/GX),
the DDC fixes (2.04.07 code), the black level (SR1A is a Trio64V2 register), and everything VBE 2.0.

## Memory

The Trio64 takes 1, 2 or 4 MB, EDO only up to 2 MB (fast page memory for 4 MB, T64-MEM-3). Phoenix
sizes the memory at POST as the S3 BIOSes do (CR36 written with 4 MB, then 2 MB, in the emulator), so the
DSP-3364P's upgrade from 1 to 2 MB needs no other ROM. The emulator tests run with 1, 2 and 4 MB.

## Pending

- Dump the DSP-3364P's BIOS (and S3REGS) and patch that dump: if it is `expertcolor.BIN`, its MCLK is
  69.8 MHz, above the data book's 60 MHz; build it with `MCLK=60` or lower and check the memory with
  S3COMPAT's VRAM test.
- S3TEST and S3COMPAT logs from the card.
