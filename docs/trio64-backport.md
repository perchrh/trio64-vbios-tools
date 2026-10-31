# The Trio64 ROM (1.5-07-p2)

Our changes ported to the Trio64 (86C764) on the Phoenix S3 Trio64 BIOS 1.5-07, in `rompatch/trio64`.
Built and checked in the emulator on 30 October 2026 for the ExpertColor DSP-3364P (S3 86C764X, marked
86C764GSpnp rev A, E0A2AA; 2 MB of fast page memory, four Mosel Vitelic V53C16256HK50; "The DSP-3364P's memory" below); first run
on that card on 31 October 2026 ("On the card" below). The choice of base is below ("Base BIOS candidates").

The ROM is for the **S3 86C764X** (Trio64), the chip of the ExpertColor DSP-3364P (marked 86C764GSpnp),
rated for a 70 MHz MCLK (vgamuseum; the card's own BIOS runs 69.8 MHz). PCI device lists name two
chips under 5333:8811: "86C764 Trio64 (Integrated '864, DAC and clock chip, 208pin) Rev. 01" and
"86C764X Trio64 PnP". The 86C764X is the later one, with Plug and Play for PCI; the earlier **86C764**
(86C764-P on PCI cards, also made for the VL-Bus) likely accepts only the data book's 60 MHz (not
verified: no 86C764 card at hand). On an 86C764 keep the default build (54.9 MHz) or build with
`MCLK=60` at most. The tools do not tell the two apart (the same PCI ID), so S3TEST's and S3COMPAT's
MCLK lines accept up to 70 MHz on both.

    make trom OUT=S3T64P2.BIN [TSIZE=32] [MCLK=55]   (rompatch/trio64/s3tpatch.py; 64 KB with the 32 KB twice, TSIZE=32: 32 KB)
    make trom-test ROM=S3T64P2.BIN
    make emu-test ROM=S3T64P2.BIN CHIP=trio64
    make tref-compare ROM=S3T64P2.BIN

Base: `reference/trio64/1_5_07.bin`, the CP764 build of Phoenix 1.5-07 (08/19/96, MCLK 54.9 MHz,
SHA-256 6a28c6b2...). Every 1.5-07 build at hand has the same code from 1000h to 7EFFh; the patcher
checks that code (SHA-256) and the layout of the tables, so another card's own 1.5-07 dump is patched
too and keeps its memory clock and timing bytes (checked with `expertcolor.BIN`, `86c764ptrio64.BIN` and
the "1.5-07 EDO" build). It refuses the Britek "VIEWTOP" build (other sign-on text) and `86c764x2.bin`
(a "V2680" tag at 7FF0h, where code goes).

## What 1.5-07-p2 carries

| Change | How |
| --- | --- |
| No interlaced defaults | The 11 refresh entries that run interlaced (CR42 bit 5, found by setting every mode at every refresh index in the emulator) are removed. The modes that also have non-interlaced rates (1024x768 and 1280x1024 at 8, 15 and 16 bpp, and the 2xxh modes 204h, 205h, 208h with the same timings) now default to their lowest non-interlaced rate: 1024x768 at 59.8 Hz (65.3 MHz), 1280x1024 at 60.3 Hz (112.2 MHz, clock-doubled). |
| Interlaced-only modes removed | 106h (1280x1024x4), 118h (1024x768x16M), 119h and 11Ah (1280x1024x32K/64K) and 120h (1600x1200) exist on the Trio64 only interlaced (1600x1200 at 60 Hz needs 162 MHz, the chip maximum is 135 MHz; the others need clocks above the single-clock limits for their depth, CLK-1). They are gone from the mode table, both VESA lists (4F00 no longer lists them, 4F02 refuses them with 014Fh) and the mode map. |
| 800x600 at 60 Hz | POST writes CR52 = 80h instead of 00h: the refresh index of the 800x600 modes is 1, the 60.7 Hz entry (VESA DMT, line total 1056) instead of 56 Hz. Phoenix writes CR41/CR52 only at POST; a refresh utility can still choose another rate. |
| 32-bit speed patches | VGA mode set clear, font load, mode 13h scroll (with EAX kept), text and planar scrolls, AH=09h: the shared `speed_sites` and .asm files, the same signatures as in 2.04.07 and 1.03-08. |
| Booster with the Windows check | On after a banked 4F02 and at the window set with BH = 0 (4F05 and the window function both call Phoenix's window set at 5123h). The refusal mark is CR52 bit 3 (`tbon.asm` says why not CR6C or CR6D). Phoenix relocks the S3 registers after its calls and its unlock routine changes AX, so the code unlocks itself and leaves CR38/CR39 as found. |
| S3's fonts | All five font tables of 1.03-08 (byte for byte those of 2.04.07, the Trio64V2 card's) replace Phoenix's: 8x8, 8x14, the 9x14 alternate table, 8x16 and the 9x16 alternate table, end to end from 5720h to 7F90h. S3's 9-dot alternate tables have 20 and 19 entries, Phoenix's 18 and 17, 63 bytes more in all: the 8x8 and 8x14 fonts and the 9x14 table keep their addresses, the 8x16 font moves from 6E30h to 6E4Dh and the 9x16 table from 7E30h to 7E4Dh, and Phoenix's eight references to these two (six mov bx/si and two words of the AX=1130h table at 315Ah; riplin names no others) are rewritten with byte assertions. The mode 13h scroll moved behind the fonts and its window path to 0130h (below). No hardware reason against the transplant: the BIOS copies the glyphs into plane 2 as on every VGA. |
| ATC flip-flop reset | In the mode set hook (AH=00 table and 4F02's call). |
| VDIF deleted | For space (31 October 2026). VBE 4F15 BL=02h, read VDIF (a format VESA withdrew), now fails with AH=01h at once; 1.5-07 first spent the 50-frame DDC1 watch on it. Its routine (52E1h-5341h, 97 bytes) is zeroed (`DDC_FREED`), and two sites with byte assertions (`DDC_SITES`) end BL=02h at the dispatcher, so nothing refers to the freed code. DDC1 and DDC2B stay byte for byte as in 1.5-07: Windows 95 Plug and Play (BL=00h, then BL=01h) reads the EDID of DDC2B monitors and of the era's monitors that speak DDC1 alone. DDC1 was deleted too for a few hours on 31 October 2026 and put back the same day; its detection is what makes 4F15 take about 0.73 s without a DDC monitor. |
| Sequencer index kept by 4F05 | Phoenix's window set (5123h) and get (5148h) read SR04 (chain 4) and left the 3C4h index at 04h. Both reads now go through `sr04` (`twin.asm`), which reads SR04 and writes the index back as found, for 4F05 and the window function, BH = 0 and 1. The data book does not require it (it defines the registers, not what a BIOS call leaves in an index); S3's own 2.04.07 and 1.03-08 leave the index as found, and S3TEST's 4F05 line expects that (fail bit 2). |
| MCLK build option | `MCLK=` sets the single MCLK entry at 3B5h, up to 70 MHz, the limit our tools take for the Trio64 (T64-MEM-7; the data book gives 60 MHz, MEM-1); above 70 MHz only with `OVERCLOCK=1`; without it the build's own clock stays. |
| Display FIFO M from the bandwidth (p2, #75) | Phoenix writes CR54 (M, bits 7-3) from its mode table, values chosen for its interlaced defaults and a faster MCLK; with the 60 Hz defaults and 54.9 MHz the FIFO ran dry in windowed video at 800x600x16 (M = 19). `fifo` (`tfifo.asm` in the 97 bytes of the deleted VDIF code, `tfifo2.asm` in the sign-on padding 00AEh-00E3h) runs in the mode set where Phoenix writes CR67 (DCLK, CR3A and CR54 are set by then, the screen still off) and in the packed modes (CR3A bit 4) lowers M to (t - 18) / 5 - 1, t = 112 x MCLK / (DCLK x bytes per pixel): the MCLKs in which the display drains 112 of the FIFO's 128 bytes, less two entry cycles of 9 MCLKs, at 5 MCLKs per access (the data book: 2 per page cycle, 6-9 per entry cycle; the card streaked at M = 19 with 54.9 MHz and not at 69.8 MHz, which puts the mean between 3.5 and 4.7). It never raises M. 112 x MCLK in kHz is a constant in the code that the patcher writes from the build's MCLK pair, so `MCLK=` builds follow. At 54.9 MHz in the emulator: 103h 31 to 25, 105h 31 to 14, 107h 26 to 6, 113h/114h 19 to 10, 115h 4 to 3, 116h/117h 5 to 4; 101h, 110h-112h and the VGA modes unchanged. |

Not applied: the fast 4F05 path (Phoenix's 4F05 is short: 6 OUTs for a bank in 101h in the emulator, 14 in 1.5-07-p1 with the booster check and the sequencer index kept), the 32-bit S3/VESA
mode set clear (Phoenix clears with the graphics engine), the base restore (Phoenix writes CR59 from
CR6B and CR5A from CR6C bit 7 at every mode set), the PLL N = 0 fix (the N = 0 entries were the
interlaced 1280x1024 ones, now removed), the Trio64V2 register fixes and VBE 2.0.

## Where the code went

The removed entries and modes freed 384 bytes in nine places; with two zero runs the stock BIOS never
reads (checked with a broad INT 10h workload in the emulator) that is enough for all of it. S3's fonts
take the first 63 bytes of the zeros at the image end, so the blocks were packed tighter on 30 October
2026 and the mode 13h scroll split in two (`scr13w.asm` holds its window path where `bios.inc` defines
SCR13W; the Trio64V+ build assembles it as before, byte-identical):

| Range | Was | Now |
| --- | --- | --- |
| 0B4C-0BCF (132) | the end of the refresh lists after their compaction | `tbon.asm`: bon, relk (0B4C-0BA5); `thook.asm`: hook (0BA6-0BCE) |
| 0831-0870 (64) | the 1600x1200 register block | `tlock.asm`: wcheck, unlk (all 64 bytes) |
| 0604-0630 (45) | the end of the mode table | `font32.asm` (0604-061F) |
| 0130-0183 (84) | zero padding after the second sign-on block (in use up to 012Ch in the builds at hand) | `scr13w.asm`, the window path of the mode 13h scroll (0130-0181) |
| 7F91-7FFE (110) | zeros at the image end, after S3's fonts | `scr13.asm` without its window path (7F91-7FE4) |
| 4EBE-4EED (48) | the 4F01 records of 118h-120h | `p13fill.asm` (4EBE-4EE0) |
| 0D79-0D91, 0DDD-0DF5 (25 each) | CRTC tables only removed entries used | `p13bfill.asm`; `p13move.asm` (0DDD-0DEE), `tglue.asm`: h4f02 (0DEF-0DF4) |
| 4E2E-4E39 (12) | the 4F01 record of 106h | `p13df.asm` (4E2E-4E35) |
| 0EAC-0EB9 (14) | the old font loop after the font jump | `p13bfa.asm` |
| 4D70-4D81 (18) | the end of the first VESA list after its compaction | `twin.asm`: sr04 (4D70-4D7C) |
| 4DD1-4DDF (15) | the end of the VESA mode map after its compaction | `twset.asm`: wsetp (all 15 bytes) |
| 52E1-5341 (97) | the VDIF code of 4F15, deleted for space | `tfifo.asm`: fifo, the FIFO M computation (all 97 bytes, p2) |
| 00AE-00E3 (54) | zero padding after the first sign-on block (the p2 sign-on ends at 00ABh) | `tfifo2.asm`: fifo2, its second part (00AE-00DE, p2) |

Free after the build (p2): 7FE5-7FFE (26), 0620-0630 (17), 4EE1-4EED (13), 00DF-00E3, 4D7D-4D81,
4E36-4E39, 0182-0183, 0BCF, 0DF5, about 75 bytes in all; the FIFO code took the 97 bytes of the VDIF code
and the sign-on padding. Kept by decision (31
October 2026): the 8x14 font with its 9x14 table (3885 bytes), to preserve the style of the era, and DDC1.
Further candidates, not taken: the S3 2xxh mode numbers (100-300 bytes in pieces; 1152x864 at 207h and
640x400x32 at 213h exist only there), 4F10 power management (71 bytes) and the refresh entries below
60 Hz. Merging Phoenix's repeated code into subroutines would give at most 903 bytes (117 repeats of
8 bytes or more), about 250-350 after the repeats that cannot be merged, spread over about a hundred
places; not done (the 486 instruction set adds nothing for size, the 386 one only in rewritten routines). Not free,
although zero: the 64 bytes at 3CE9h are an empty slot of the VGA parameter table, which programs read
through the save pointer table.

## Checked in the emulator (Trio64 model)

`make trom-test`: the tables (no list starts with an interlaced entry, every kept entry unchanged), every
other byte unchanged, another maker's timing bytes and MCLK kept, the MCLK option, the refusals.
`make emu-test CHIP=trio64` with 2, 4 and 1 MB: `t64_patches` (defaults, removed modes, booster, Windows
check, lock state, ATC flip-flop, sequencer index after 4F05 BH = 0 and 1, S3's fonts in AX=1130h and
plane 2, 4F15 answers as 1.5-07's with BL=02h failing at once, 32-bit registers), `stores`, `s3test` (the Trio64 set) and the others;
`make tref-compare`: the CGA, MDA and EGA modes behave as in 1.5-07 with S3's fonts (`--fonts-only`); `make trom-test`
checks the fonts against 1.03-08 byte for byte. S3COMPAT's VESA lines: every mode
non-interlaced, 800x600 at 60.7 Hz. Test coverage (`make coverage CHIP=trio64`): 85.2 % of the code, every byte of
the new code among it.

## Left as in 1.5-07

The emulator tests pass these on our Trio64 ROM with a note (`T64_BASE` in `emu/tests.py`); the
unpatched 1.5-07 gives the same lines:

| Test | 1.5-07 behaviour |
| --- | --- |
| errors (1 MB) | 4F02 sets 107h, 112h and 115h-117h, which need more than 1 MB (1.5-07 also set 118h-120h, now removed). |
| windows | 4F06 changes the upper halves of EAX, ECX and EDX (the dispatcher saves only the 16-bit registers). |
| s3compat_full | S3COMPAT's run leaves a register state behind that differs from its baseline (WARN 01). Phoenix's 8x8 upper half (WARN 02, its own design) is gone with S3's fonts. |

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
| `expertcolor.BIN` (the name suggests the DSP-3364P) | Phoenix 1.5-07, "764 M70" | 16 of 23 | 179 bytes (7F4Ch) | 69.8 MHz | as 1.5-04, plus MCLK above the data book maximum of 60 MHz (FAIL 2 then; within the 70 MHz the tools take since T64-MEM-7) |
| `trio64_expertcolor_dsp3364p.bin` (dumped from the DSP-3364P itself, 86C764X, 2 MB EDO 50 ns, uploaded 31 October 2026) | Phoenix 1.5-07 of 11/16/95, "764 M70" (SHA-256 1056fcee...) | not checked (refused, see below) | 557 bytes (7DD2h) | 69.8 MHz | an earlier 1.5-07 build: its 4F15 has DDC1 only (BL=00h/01h, no DDC2B, no VDIF), 384 bytes less code, so everything from about 528Ah (the VBE/DDC code, the fonts) lies 384 bytes lower and the words that point there differ. Its first 4 KB are those of the CP764 build apart from 52 bytes: the model tag and dates, the 8x8 font pointer at 01B1h, the header word at 003Ch (no code reads it), and the MCLK at 3B5h (25h/22h, 69.8 MHz); the per-mode memory timing bytes are the same |
| `dataexpertcp764.BIN` = `W27E257 CP764 V1.5-0 7.BIN` (uploaded) | Phoenix 1.5-07 | 16 of 23 | 179 bytes | 54.9 MHz | the 1.5-07 code; 24 bytes differ from `expertcolor.BIN` |
| `Britek BP-S341 (S3 Trio64).BIN` (uploaded) | Phoenix 1.5-07 as "VIEWTOP Graphics BIOS", "S3 Trio64X (764X)" | 16 of 23 | 164 bytes | 52.5 MHz | the 1.5-07 code |
| `86c764xtrio64.BIN`, `86c764ptrio64.BIN`, `86c764x2.bin` | Phoenix 1.5-07 (one "EDO") | 16 of 23 | 179 bytes | 55.0-55.5 MHz | the 1.5-07 code with other memory timing bytes |
| `2-24-00.bin` (uploaded) | ELSA Winner 1000TRIO 2.24.00 (06/26/96), DPMS, DDC1 | 15 of 23 | 147 bytes (7F6Ch) | 59.96 MHz | ELSA's own VBE code: 75 Hz defaults, OEM modes 204h-418h, 4F06 BL=2/3, 4F07 and 4F04 fail, 4F01 changes EAX/EBX/EDX bits 31-16, PLL N = 0 in 106h, FAIL 200 in 208h (1280x1024x4) |
| Stealth 64 DRAM 2.05 (uploaded; also 2.02 of 01/19/95 and 2.09 of 10/31/95, uploaded 31 October 2026) | Diamond 2.05, PCI 5333:8811, VBE 1.2 with the OEM string "S3 Incorporated. Vision864" | 15 of 23 | 58 bytes (7FC5h) | 59.96 MHz | hangs in 4F02 and AH=00 60h (C000:1826h; in 2.02 at 17D0h): it waits for the graphics engine's busy bit (9AE8h bit 9), which the model reads as FFFFh. With 9AE8h reading idle (a probe, not the model) every mode sets. Its display FIFO M (CR54) is 1 to 3 in every packed mode in all three versions (114h: 2, 103h: 3, 105h: 1), where Phoenix 1.5-07 has 19 and 31 and our p2 10, 25 and 14 at 54.9 MHz: a vendor that shipped far smaller M (#75). Every VGA mode fails the IBM state block (DS+25h) and mode 12h runs at 72 Hz (MISC EFh): not a base |
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

The Trio64 takes 1, 2 or 4 MB, EDO only up to 2 MB: CR36 bits 7-5 = 000b is "4 MBytes (Trio64 only)",
and fast page memory is required for 4 MB (T64-MEM-3), because the second bank needs pin 50 as RAS1,
which with EDO is the second OE. The Trio32 takes at most 2 MB. Phoenix sizes the memory at every POST
(ConfigureAndClearVideoMemory, 12DCh, in riplin's disassembly): only when CR36 bit 2 says fast page mode
and the chip is not a Trio32 it sets SRA bit 6 (pin 50 = RAS1) and tests 4 MB; then 2 MB, then 1 MB, and
writes the size found into CR36 bits 7-5. So the DSP-3364P's upgrade from 1 to 2 MB needs no other ROM,
and a 4 MB Trio64 card is fast page memory by the data book and by the BIOS. The emulator straps the
Trio64 as EDO (CR36 bits 3-2 = 10b) with 1 and 2 MB and as fast page (11b) with 4 MB; the Trio32 model
has no 4 MB run.

## Cross-check with riplin's annotated disassembly

riplin's annotated disassembly of the 1.5-07 EDO build (hag `research/s3/bios/86c764x.asm`, MIT licence
for the annotations; README "Sources") names each routine with its ROM offset. The code from 1000h on is
the same in every 1.5-07 build, so its offsets are those of our base. Read on 30 October 2026 against what
the patcher assumes; nothing was copied from it.

| Our assumption | riplin | Result |
| --- | --- | --- |
| WSET 5123h is the window set, called by 4F05 (4CB3h) and the window function (4CC5h), then 5148h for BH = 1 | SetVideoMemoryWindow 5123h, GetVideoMemoryWindow 5148h, both called only from CPUVideoMemoryControl 4CB3h and DirectCallableCPUVideoMemoryControl 4CC5h | agrees; both read SR04 through 4640h (the sequencer index fix above) |
| CR41 and CR52 bits 7-4 hold 3-bit refresh indexes, written only at POST | BIOS flag table: 640x480 in CR52 bits 6-4, 800x600 in CR52 bit 7 and CR41 bits 1-0, 1024x768 in CR41 bits 4-2, 1280x1024 in CR41 bits 7-5; ClearBIOSFlags 0E97h writes both 00h; the mode set reads CR52 masked with F0h | agrees; CR52 = 80h gives 800x600 index 1, and CR52 bit 3 (our Windows mark) is masked off by Phoenix's only reader |
| CR6B/CR6C hold the linear base, copied to CR59/CR5A at each mode set | "Extended BIOS Flag 3/4": POST stores the high word of PCI BAR0 there (0F4Eh; on the VL-Bus the word at 019Ch, 0780h), the mode set copies CR6B to CR59 and CR6C bit 7 to CR5A (0307h) | agrees: CR6C is BIOS data, not free for a mark. New: the data book gives CR6B bit 7 the PD bus width and bits 1-0 a signal stretch (T64-MEM-6), and BAR0 is 8 MB aligned, so a base below 2 GB writes bit 7 = 0 (32-bit PD bus, 1 MB) and a base such as E1000000h sets bit 0; on the VL-Bus Phoenix writes 07h. Whether the chip takes this from a register write is open: S3REGS on the card (CR6B, CR36, PCI BAR0) shows it |
| Memory size found at POST | ConfigureAndClearVideoMemory 12DCh: 4 MB only with fast page strapping on a Trio64 (SRA bit 6 for RAS1), then 2 and 1 MB | new detail, see Memory above |
| The 1600x1200 register block 0831h-0870h is used only by the removed mode | a word at 01C7h holds 0871h, the address right after that block ("might point to 0871h") | our code ends at 086Eh and 0871h is unchanged |
| The 64 zero bytes at 3CE9h | an empty entry of the VGA parameter table | not used for code |

## The DSP-3364P's memory

The card carries four Mosel Vitelic V53C16256HK50 (SOJ-40): 256K x 16 **fast page mode** DRAM, 50 ns,
2 MB in all; not EDO, as the card had been described. The datasheet (Mosel Vitelic V53C16256H,
preliminary) gives for the -50 grade: RAS access tRAC 50 ns, column access tCAA 24 ns, fast page cycle
tPC 28 ns min, read/write cycle tRC 90 ns min, RAS pulse tRAS 50 ns min, RAS precharge tRP 30 ns min,
CAS pulse tCAS 14 ns min, CAS precharge tCP 7 ns min.

The Trio64 counts its memory cycles in MCLKs (Trio32/Trio64 data book section 7): a page mode cycle
takes 2 MCLKs, RAS stays low 3.5 or 4.5 MCLKs and precharges 2.5 or 3.5 MCLKs (CR68 bits 2 and 3,
strapped on the board, never written by Phoenix), so a row cycle takes at least 6 MCLKs. With the
fastest CR68 settings:

| | -50 needs | 69.8 MHz (14.3 ns, the card's BIOS) | 60 MHz (16.7 ns) | 55 MHz (18.2 ns) |
| --- | --- | --- | --- | --- |
| Page cycle, 2 MCLKs | tPC 28 ns | 28.7 ns | 33.3 ns | 36.4 ns |
| RAS low, 3.5 MCLKs | tRAS 50 ns | 50.1 ns | 58.3 ns | 63.6 ns |
| RAS precharge, 2.5 MCLKs | tRP 30 ns | 35.8 ns | 41.7 ns | 45.5 ns |
| Row cycle, 6 MCLKs | tRC 90 ns | **86 ns, too short** | 100 ns | 109 ns |

At 69.8 MHz the parts work at the edge of their page cycle and RAS time, and the row cycle is too short
unless CR68 selects 4.5 MCLKs RAS low or 3.5 MCLKs precharge (then 100 ns); the chip is above the data
book's 60 MHz (MEM-1) either way, within the 70 MHz our tools take for it (T64-MEM-7). At 60 MHz every -50 timing holds with any CR68 setting: build the
card's ROM with `MCLK=60`. S3REGS with the stock BIOS shows the board's choices: CR68 bits 3-0 (the
timings) and CR36 bits 3-2 (11b fast page, 10b EDO: what the strapping tells the chip; with fast page
Phoenix also tries 4 MB at POST and settles on the 2 MB found).

## On the card (31 October 2026)

The default build (1.5-07-p1, MCLK 54.9 MHz, 64 KB image) on the ExpertColor DSP-3364P: a picture at
POST, Windows detects the card, the text font looks right (the glyphs are byte for byte the Trio64V2
card's; S3COMPAT's 8x8 upper half check passes, which Phoenix's own font failed). The picture looked
softer than on the Trio64V2 card: the analog output of the board, not the ROM.

- **S3TEST:** 26 PASS, 0 FAIL. Banked write throughput 81.7 MB/s (the booster on a Trio64, as on the
  Trio64V2 card); every mode at its 60 Hz class rate, non-interlaced; the sequencer index kept by 4F05.
- **S3COMPAT:** 88 PASS, 48 + 1 FAIL, all test bugs, fixed in the tools: the 48 VGA lines failed with
  `CR90=80(00)` (the CR90 check is the Trio64V2's, #72) and the LFB cross check ran without an LFB
  (#73). The VRAM test passed at 54.9 MHz.
- **VSHOW /R:** every listed mode; **VGALOG:** 7303 calls, none with an error.
- **S3REGS:** CR36 = 8Eh (fast page, 2 MB, as the V53C16256HK50), CR68 = 8Dh (RAS low 3.5 MCLKs,
  precharge 2.5 MCLKs, the fastest strapping: at the stock 69.8 MHz the row cycle was 86 ns against
  the chips' 90 ns), CR6B = E0h with BAR0 E0000000h (bit 7 set, so the PD bus width question of
  T64-MEM-6 does not arise on this machine), CR52 = 80h (800x600 at 60 Hz).
- **CRTC index aliasing:** CR80-CRFF read back as CR00-CR7F (CR90 = CR10, CRA0 = CR20, ...): the
  Trio64 decodes index bits 6-0 only. A write meant for CR80 and up lands in CR00-CR7F, so code for
  the later chips (the Trio64V2's CR90 FIFO fix, CR86) must never run on a Trio64. The emulator's
  Trio64 and Trio32 models alias the same way since 31 October 2026.
- **Timings:** mode set 03h 1.3 ms, 4F05 26.8 us, but 4F02 101h with the clear 157 ms against 39 ms on
  the Trio64V2 card: Phoenix's graphics engine clear of the 2 MB is four times slower than the
  32-bit CPU clear of 2.04.07-p11. A candidate for a later level (see Pending).
- **4F15:** caps 0000 (no DDC answer); the board is from 1994, when DDC was new, and may not connect
  the lines (Pending).
- **VIDSPEED** (31 October 2026, the 86C764X marked 86C764GSpnp rev A): 32-bit writes 86.9 MB/s in 640x480x8,
  as on the Trio64V2 card (87.4 MB/s: the CPU and bus are the limit there), but less as the display
  takes more of the memory: 73.6 MB/s in 1024x768x8 (Trio64V2 86.0), 53.1 in 1280x1024x8 (82.6),
  44.4 in 1024x768x15 (81.0), 36.8 in 800x600x32. The DSP-3364P has fast page memory at 54.9 MHz,
  64 bits per page cycle of 2 MCLKs, about 220 MB/s, of which 1024x768x15 at 65 MHz takes 130 MB/s for
  the display; the Trio64V2's 1-cycle EDO has twice the bandwidth. The standard VGA modes (planar 20
  MB/s against 26.5, text 34 against 51) are the chip and its memory, not the ROM. The 132-column
  text modes are the slowest (17 MB/s in 132x25); Phoenix's FIFO values for 109h/10Ah are a candidate
  for a look. VIDSPEED's "264x25" and "160x50" are its own names for 132x25 and 80x50, and its kHz
  figure is the visible lines times the refresh rate: 132x43 has 344 lines here (8x8 font) and 387 on
  the Trio64V2 (8x9 font of 2.04.07).
- **VGALOG** during VIDSPEED: 298 calls, all with CF clear and every VBE call 004Fh; the other
  chipsets' probes (FE00h, 7000h, BF03h, 6F00h, 5F00h) came back unchanged, as they should. MCLK
  54.9 MHz in every record. The banked VBE modes run with CR58 = 10h and CR59/CR5A = 000Ah: linear
  addressing on with a 64 KB window at A0000h, the booster (#47) switched on at the end of 4F02. Not
  in Phoenix's mode list, so not measured: 106h (1280x1024x4) and 10Dh-10Fh (320x200 high and true
  colour).
- **Windows 98:** the desktop, DXDIAG and the user interface work; video playback (AVI and MPEG,
  windowed and full screen) shows horizontal streaks over the whole screen, most likely display FIFO
  underruns: p1's MCLK (54.9 MHz) gives the memory 21 % less bandwidth than the card's own 69.8 MHz,
  while its 60 Hz defaults ask more of it than the card BIOS's 56 Hz and interlaced ones, with the
  same FIFO values (#75, Pending). S3REGS32 during playback: the desktop is 800x600x16 (CR67 = 50h,
  40.27 MHz) with the BIOS's FIFO values of mode 114h (CR54 = 98h, M = 19; CR60 = FFh), so the driver
  sets its modes through our BIOS; the MCLK stays at 54.9 MHz. Full screen, the player switches to
  640x480x16 (25.18 MHz, CR54 = 58h, M = 11), and the streaks are gone; windowed, at 800x600x16, they
  show. The display FIFO (16 entries of 8 bytes) must outlast an M period: by the data book's count
  (an entry cycle of up to 9 MCLKs, M page cycles of 2 MCLKs, then the entry cycle of the refill)
  800x600x16 drains 82 of its 128 bytes at 54.9 MHz; if the CPU and engine accesses miss the page,
  each of the M + 1 cycles can take an entry cycle, and the FIFO runs dry at M = 19 (277 bytes), but
  not in 640x480x16 at M = 11 (107 bytes).
- **S3REGS before and after Windows 98:** the driver keeps the ROM's MCLK (SR10/SR11 41h 2Ch). It
  leaves SR12/SR13 at its last pixel clock (42h 2Bh, 40.3 MHz, 800x600 at 60 Hz; unused in mode 03h,
  which takes the fixed 28.322 MHz clock), the hardware cursor registers CR47-CR4F changed, and CR5C
  41h instead of 43h (GOP bit 1, one of the DDC lines in S3's design, below). The dump read the
  cursor colour stack through CRC5, CRCA and CRCB, a tool bug fixed since (#74).

## Pending

- The DSP-3364P's own BIOS (dumped 31 October 2026, table above) is an earlier 1.5-07 build that
  `s3tpatch.py` refuses (other code). It needs no support: the CP764 reference has the same card
  settings, apart from the memory clock, and newer DDC code (DDC1 and DDC2B). Build the card's ROM from
  the reference with `make trom OUT=S3T64P2.BIN MCLK=60` (the data book maximum; the card ran at 69.8
  MHz) or `MCLK=55` (the CP764 build's own 54.9 MHz), and check the memory with
  S3COMPAT's VRAM test (without /Q). Take S3REGS before flashing, with the stock BIOS: SR10/SR11
  should read 22h/25h (69.8 MHz). The Trio64 has two clock PLLs only, DCLK (pixel clock) and MCLK
  (memory and graphics engine), and Phoenix's POST loads the pair at 3B5h/3B6h into SR11/SR10 (and
  the N/R byte into SR1A, with SR1B = 00h; neither is in the Trio32/Trio64 data book). The memory's
  own speed (50 ns) is in CR68 bits 3-0, strapped on the board and never written by Phoenix: RAS low
  3.5 or 4.5 MCLKs, RAS precharge 2.5 or 3.5 MCLKs, a CAS/OE stretch of 0-6.5 ns; at 69.8 MHz 3.5
  MCLKs are 50.1 ns.
- S3COMPAT again on the card with the fixed tools (#72, #73): no FAIL expected.
- Video playback streaks under Windows 98 (#75): windowed at 800x600x16 only (above), gone at
  69.8 MHz (T64DUP70). p2 computes M from the bandwidth (table above); to check on the card with the
  default build (54.9 MHz): windowed video at 800x600x16, VIDSPEED, and S3REGS32 /W for CR54 (expected
  50h, M = 10, in 114h).
- The S3/VESA mode set clear: Phoenix's graphics engine clear takes 157 ms for 2 MB on the card (39 ms
  with the 32-bit CPU clear on the Trio64V2). The 2.04.07 `clear32.asm` (35 bytes) would fit the free
  space; Phoenix's clear routine (121Eh) and its callers need a look first.
- DDC2 on this board (asked for 31 October 2026). 1.5-07's DDC1 and DDC2B code is in the ROM, byte
  for byte as Phoenix wrote it, so no new code is needed if the board is wired the way that code
  expects, which is S3's design for the Trio64 (data book 10.3, 10.4; the chip has no DDC pins of its
  own, the serial port came with the Trio64V+): the General Output Port (CR5C, an external latch on
  GD7-0 strobed by STWR) drives the lines, bit 0 SDA and bit 1 SCL (54CCh), and the General Input
  Port (port 3C8h with CR55 bit 2 = 1, an external buffer strobed by STRD) reads SDA in bit 0 (54E6h,
  CR55 set at 528Fh). On the card 4F15 BL=00h found neither DDC1 nor DDC2B (caps 0000). Steps:
  (1) look at the board for the GOP latch and the GIP buffer (74-series chips on the GD lines next to
  the Trio64) and for traces to pins 12 (SDA) and 15 (SCL) of the VGA connector; (2) a probe in
  S3COMPAT /V that sets CR55 bit 2, writes CR5C bits 1-0 = 00b, 01b, 10b, 11b and logs the raw 3C8h
  values as D: records: a missing buffer gives the DAC write index or a floating bus whatever is
  written, a wired SDA follows bit 0. If the board wires other GOP or GIP bits, the two routines take
  a byte patch each; a DDC2 of our own would have about 75 bytes free since p2 (the FIFO code took the 97 at 52E1h). If
  pins 12 and 15 are not connected, no ROM can help.
