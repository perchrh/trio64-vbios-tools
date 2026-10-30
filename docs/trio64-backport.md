# Porting to a Trio64 BIOS

What of our Trio64V+ ROM (1.03-08-p1, `rompatch/vplus`, docs/vplus-backport.md) could go into a video
BIOS for the Trio64 (86C764), and on which base. Collected on 30 October 2026 for the ExpertColor
DSP-3364P (86C764-P, 1 MB EDO 50 ns upgraded to 2 MB). Its stock BIOS is not dumped yet; the findings
below come from the Trio64 BIOS images at hand, run in the emulator on the Trio64 model
(`emu/tests.py --chip trio64`), and from the Trio32/Trio64 data book (March 1995). Nothing here has
run on a card.

Scope as for the Trio64V+: no VBE 2.0 functions. No ROM is built yet; this is the plan.

## Base BIOS candidates

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

The free space is the deciding difference. The Trio64V+ code takes 590 bytes in 1.03-08 (the hook and
booster 200, the fast 4F05 path, font load and mode 13h scroll 287, the fills and moves about 90, the
32-bit clear 35); only 1.4-04 has room for all of it. The zero runs in the sign-on area (87-120
bytes from 10Ch-12Dh) and a 64-byte zero block near 3B00h-3D00h in each Phoenix image may be free too;
whether any code or table reads them is not checked yet (coverage records reads).

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

**Recommendation:** Phoenix 1.5-07, S3's reference for the Trio64, as the card's own dump: a patcher can
assert only the shared code (1000h-7EFFh) and the patch sites, so it fits every 1.5-07 build and keeps
the card's memory clock and timing bytes. Its 164-179 free bytes hold the VGA speed patches; the
booster and the rest need the sign-on padding and the 64-byte block to be free, or a smaller booster.
Phoenix 1.4-04 is the fallback with room for everything; it has no 115h (800x600x16M), 118h-11Ah or
120h (1600x1200), which 1.5-0x lists. 1.03-08 only if an S3-built image matters more than the FIFO
work it needs.

## What ports, and how

| Change of our ROMs | On a Phoenix Trio64 BIOS |
| --- | --- |
| 32-bit VGA mode set clear, font load, mode 13h scroll (with EAX kept, p21), text and planar scrolls, AH=09h text | The sites match, so `speed_sites` and the shared .asm files (`p13*.asm`, the vext.asm font and scr13 code) apply with the Phoenix addresses. The emulator shows for 1.5-07 the same 8- and 16-bit stores as for 1.03-08 (mode set 03h 4096 bytes and 16520 words, 13h/12h 32768 words, mode 13h scroll 32000 words, mode 12h clear 38400 bytes, font load 4096 bytes). Size: about 240 bytes (font 28, scr13 120, wfill 35, dfdn 8, bfill 25, wmove 21; bfilla in the dead bytes after the font jump). |
| S3/VESA mode set clear (32-bit) | Not needed: Phoenix clears with the graphics engine (no CPU stores in 4F02 in the emulator, which does not run the engine; the README noted this for 1.4-04 before). |
| Booster: 64 KB linear window at A0000h in banked modes | The chip has it: CR58 bits 1-0 = 00b is a 64 KB window, CR59/CR5A its position, and with CR31 bit 0 the bank in CR6A is added (data book section 13, CR58). Phoenix 1.5-07 keeps the PCI base in CR6B from POST and writes CR59 back from it (CR5A = 00h) at every mode set, as 1.03-08 does (emulator; the other Phoenix versions not checked), so vhooks.asm's approach fits. 4F02's mode set call matches the m4f02 signature (the place for the booster after a banked 4F02). The window set code (4F05 and the window function) is Phoenix's own: its sites have to be found and asserted anew. |
| Windows enhanced mode check | Generic code (INT 2Fh AX=1600h). Its refusal mark lives in CR6D on our ROMs; the Trio64 data book documents no CR6D. CR6C ("reserved for use by the S3 BIOS", Phoenix writes 00h at POST) is the candidate, once it is confirmed that Phoenix does not use it otherwise. CR6B is not: on the Trio64 its bit 7 and bits 1-0 also have hardware meanings (PD bus size, signal timing). |
| Fast 4F05h | Phoenix's 4F05 takes 10 port accesses (1.03-08: 16, our fast path: 9), so the gain is small. The INT 10h entry matches, so the jump point exists; lowest priority. |
| Attribute controller flip-flop reset after the mode set | Generic; needs the AH=00 table entry and the 4F02 call redirected to a hook, as in vhooks.asm. The dispatcher has the same layout (the int10 signature matches); the table address is still to be read from the code. |
| PLL N = 0 in 1280x1024 (106h, 107h) | New for this base (not in our ROMs): the data books require N >= 1 (PLL-2). The same clock, 75.16 MHz, comes from M = 40, N = 2, R = 1 (VCO 150.3 MHz) instead of M = 19, N = 0: a data patch with byte assertions, as the VCO fix of s3patch.py. |
| MCLK build option | A single MCLK entry in these BIOSes (1.4-04: 38Dh, SR11 then SR10; 1.5-07: 3B5h), not one per memory type: `MCLK=` would set that entry, at most 60 MHz (MEM-1). `expertcolor.BIN` runs 69.8 MHz, above the data book maximum; a ROM of ours for that card would stay at or below 60 MHz unless the README rule is changed for it. Whether its 50 ns EDO keeps up at a given clock is the card's question (S3COMPAT's VRAM test). |
| DCLK VCO fix | As on the Trio64V+: R has 2 bits, so a clock below 16.9 MHz cannot have its VCO in range. The Phoenix images show no VCO below 135 MHz in the emulator; nothing to do. |

## Does not apply to the Trio64

The FIFO fix (CR90/CR91, Trio64V2), CR23/CR26 (Trio64V2), the POST delay in AX (CR88, Trio64V2/GX),
the DDC fixes (2.04.07 code), the black level (SR1A is a Trio64V2 register), and everything VBE 2.0.

## Left as they are

The refresh defaults (800x600 at 56 Hz, 1024x768 interlaced) and the 8x8 upper font are choices of
the Phoenix BIOS; changing them means new CRTC tables and refresh entries, which is a feature, not a
port. 4F06's 32-bit registers and 4F02 accepting modes that do not fit the memory are the same faults
as in 1.03-08 (docs/vplus-backport.md, "Left as in 1.03-08").

## Memory

The Trio64 takes 1, 2 or 4 MB, EDO only up to 2 MB (fast page memory for 4 MB, T64-MEM-3). The
DSP-3364P has 2 MB EDO after its upgrade. Whether the Phoenix BIOSes size the memory at POST as the S3
BIOSes do is not checked yet (the data book says the S3 BIOS does).

## Steps

1. Dump the DSP-3364P's BIOS (S3REGS and a ROM dump, as for the other cards) and compare it with
   `expertcolor.BIN`.
2. If it is Phoenix 1.5-07 (likely), patch it: assert the shared code 1000h-7EFFh and the patch
   sites, keep its first 4 KB (the card's clock and timing). First the VGA speed patches, then the
   booster if the sign-on padding and the 64-byte block turn out to be free; Phoenix 1.4-04 if all of
   it is wanted at once.
3. A patcher in the style of `rompatch/vplus/s3vpatch.py` with the Phoenix addresses, the N = 0 data
   patch and the MCLK entry; emulator tests on the Trio64 model (`CHIP=trio64`), a Trio64 test set in
   S3TEST, then the card.
