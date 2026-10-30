# Porting to a Trio64 BIOS

What of our Trio64V+ ROM (1.03-08-p1, `rompatch/vplus`, docs/vplus-backport.md) could go into a video
BIOS for the Trio64 (86C764), and on which base. Collected on 30 October 2026 for the ExpertColor
DSP-3364P (86C764-P, 1 MB EDO 50 ns upgraded to 2 MB). Its stock BIOS is not dumped yet; the findings
below come from the Trio64 BIOS images at hand, run in the emulator on the Trio64 model
(`emu/tests.py --chip trio64`), and from the Trio32/Trio64 data book (March 1995). Nothing here has
run on a card.

Scope as for the Trio64V+: no VBE 2.0 functions. No ROM is built yet; this is the plan.

## Base BIOS candidates

There is no S3-built Trio64 BIOS among the images (no "S3 86C764 Video BIOS", as there is "S3 86C765
Video BIOS 1.03-08" for the Trio64V+). The Phoenix BIOSes carry S3's code ("Copyright 1992-1993 S3
Incorporated") for the VGA functions: the signatures of our speed patch sites match them byte for byte,
at other addresses. Their VBE and mode set code is their own.

| Image | BIOS | Our signatures | Free space at the end | MCLK at POST | Emulator findings (Trio64 model, 2 MB) |
| --- | --- | --- | --- | --- | --- |
| `S3Trio64_1_14-04.bin` (also uploaded 30 October 2026, identical) | Phoenix 1.4-04 | 16 of 23 | 755 bytes (7D0Ch) | 51.9 MHz | PLL N = 0 in 106h/107h (FAIL 200); 800x600 at 56 Hz (WARN 40); 1024x768 interlaced (WARN 50, 10); 8x8 upper font of another design (WARN 02); 4F06 changes EAX/ECX/EDX bits 31-16 |
| `1-30.bin` (miroCRYSTAL, uploaded 30 October 2026) | Phoenix 1.5-04 | 16 of 23 | 243 bytes (7F0Ch) | 53.7 MHz | as 1.4-04, plus 1600x1200 interlaced (WARN 50) and 4F02 setting 118h-11Ah with 2 MB (errors) |
| `expertcolor.BIN` (the name suggests the DSP-3364P) | Phoenix 1.5-07, "764 M70" | 16 of 23 | 179 bytes (7F4Ch) | 69.8 MHz | as 1.5-04, plus MCLK above the data book maximum of 60 MHz (FAIL 2) |
| `86c764xtrio64.BIN` | Phoenix 1.5-07 EDO | 16 of 23 | (as 1.5-07) | 55.04 MHz | 1.5-07 with the EDO MCLK and other memory timing bytes in its mode tables (121 bytes differ) |
| Stealth 64 DRAM (uploaded 30 October 2026) | Diamond 2.05 | 15 of 23 | 58 bytes (7FC5h) | 59.96 MHz | hangs in 4F02 and AH=00 60h (C000:1826h); every VGA mode fails the IBM state block (DS+25h) and mode 12h runs at 72 Hz (MISC EFh): not a base |
| `numbernine.BIN`, ELSA Winner 1000, Stealth 64 2.09 | Number Nine 2.03.10, ELSA 1.02.00, Diamond 2.09 | 15-16 of 23 | not checked | not checked | OEM code bases, not examined further |

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

**Recommendation:** the card's own stock BIOS once dumped, if it is one of these Phoenix BIOSes, since
its board settings (memory timing bytes, MCLK) belong to that card. If it is 1.5-07 like
`expertcolor.BIN`, its 179 free bytes hold only part of the port (see below). Phoenix 1.4-04 is the
fallback with room for everything; it has no 115h (800x600x16M), 118h-11Ah or 120h (1600x1200), which
1.5-04 lists.

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
2. Choose the base by its free space: everything on 1.4-04; on 1.5-07 first the VGA speed patches,
   then the booster if the sign-on padding and the 64-byte block turn out to be free.
3. A patcher in the style of `rompatch/vplus/s3vpatch.py` with the Phoenix addresses, the N = 0 data
   patch and the MCLK entry; emulator tests on the Trio64 model (`CHIP=trio64`), a Trio64 test set in
   S3TEST, then the card.
