# Oracle for part A: POST state observed (dirty side only)

This file stays on the dirty side. It records what the reference ROM and our patched build do at POST
and in the conventions of [`spec-a-post.md`](spec-a-post.md), observed in the emulator, and what the card logs in
[README.md](../../README.md) and [docs/764-rom.md](../764-rom.md) show, and compares each with the rules. It is used to check the
clean ROM; none of its values may be copied into the specification. Observed 1 November 2026.

## How it was observed

- Reference: `reference/trio64/1_5_07.bin` (Phoenix S3 Trio64 1.5-07, CP764 build, 32 KB; doubled to
  64 KB for the emulator). Patched: 1.5-07-p3 built with `s3tpatch.py --size 64 --mclk 69.8` (NASM
  2.16 here; that build reports itself as the tested code with only the MCLK changed).
- Emulator: [`emu/vgaemu.py`](../../emu/vgaemu.py), `Machine.chip = 'trio64'`, `Machine.vram` 1, 2 and 4; `m.wlog` for the
  SR/CR writes in order, an extra `UC_HOOK_INSN` OUT hook for the other ports, a wrapper around
  `Machine._pcibios` for the PCI BIOS calls. The scripts were throw-away (scratchpad); each step below
  says what was read. Model limits as in the spec ("Emulator limits"): registers start at 00h, CR2D-CR30
  and CR36 answer fixed values, BAR0 is CR59/CR5A, no PLL, no missing memory, 9AE8h reads busy.
- Tests: `emu/tests.py --chip 764 --tests post,windows,engine_init` and S3TEST run on the model
  (`Machine.run_com`) with the reference ROM.
- Card: the S3REGS values quoted in [docs/764-rom.md](../764-rom.md) ("On the card", "The DSP-3364P's memory")
  and [README.md](../../README.md) ("Windows 9x driver test"; that record is from the Trio64V2 card).

## POST of 1.5-07 in the emulator (2 MB)

Port writes other than the VGA index/data ports, in order: 3C3h = 01h, 46E8h = 10h, 102h = 01h,
46E8h = 08h, 4AE8h = 00h, 42E8h = 9000h, 42E8h = 5000h, MISC 23h, A6h, 23h, A3h (sense), 4AE8h = 02h,
3B8h = 01h, MISC 67h, 4AE8h = 02h, MISC 63h, 4AE8h = 07h, BEE8h = 1000h, 2000h, 3FFFh, 4FFFh, E040h,
AAE8h FFFFh twice, A6E8h 0000h twice, BAE8h 0027h, BEE8h A000h, 86E8h, 82E8h 0000h, 96E8h 0FFFh,
BEE8h 0FFFh, 9AE8h = 40B3h (one engine command: a rectangle fill, the memory clear), MISC 67h twice,
4AE8h = 02h.

PCI BIOS calls: B102h (find 5333:8811), B109h word at 04h, B10Ch byte 04h = 03h (I/O and memory on),
B109h word at 12h (BAR0 high word).

S3 register writes, in order of first appearance (later writes repeat the same set for each internal
mode set): CR38 48h, CR39 A5h, SR08 06h; SR14 03h then 00h; CR5C 43h; CR66 00h; CR6B E0h, CR6C 00h;
SR1B 00h, SR1A 41h (no Trio64 registers); SR10 41h, SR11 2Ch (54.89 MHz); SR12 49h, SR13 55h; SR18
00h; SR15 00h then 03h; CR42 00h; SRA 80h; CR40 31h then 30h; CR31 05h, CR50 00h, CR51 00h, CR53 00h,
CR54 38h, CR55 00h, CR58 03h, CR5D 00h, CR5E 00h, CR60 07h, CR61 80h, CR62 A1h (no Trio64 registers),
CR67 00h, CR69 00h, CR6A 00h, CR32 40h, CR33 00h, CR34 00h, CR35 00h, CR3A 05h, CR3B 5Ah, CR3C 10h,
CR43 00h, CR45 00h, SR0B 00h; CR40 F0h; CR30 55h (a read-only register); SR09 00h; CR40 F1h; CR59 E0h,
CR5A 00h (the base, rewritten unchanged); SR18 40h; memory sizing: CR36 1Ah, CR6A 1Fh, CR36 9Ah,
CR6A 00h (2 MB; with 4 MB: CR36 1Eh, SRA C0h, CR6A 3Fh); CR50 10h then 00h; CR41 00h, CR52 00h; at the
end SR08 00h, CR38 00h, CR39 00h.

State after POST (2 MB): SR08 00, SR09 00, SRA 80, SRB 00, SRD 00, SR10 41, SR11 2C, SR12 49, SR13 55,
SR14 00, SR15 03, SR18 40; CR31 05, CR32 40, CR33 00, CR34 00, CR35 00, CR36 9A (model strap), CR38 00,
CR39 00, CR3A 05, CR3B 5A, CR3C 10, CR40 F0, CR41 00, CR42 00, CR43 00, CR45 00, CR50 00, CR51 00,
CR52 00, CR53 00, CR54 38, CR55 00, CR58 03, CR59 E0, CR5A 00, CR5C 43, CR5D 00, CR5E 00, CR60 07,
CR61 80, CR62 A1, CR66 00, CR67 00, CR69 00, CR6A 00, CR6B E0, CR6C 00. MISC 67h. Index registers
after POST: 3C4h = 04h, 3D4h = 0Fh, 3CEh = 06h. With 4 MB: SRA C0h. 1 MB: as 2 MB (the model does not
model the missing megabyte, so the reference writes the 2 MB code; the model still reads 1 MB).

BIOS data area after POST (all sizes): 0449h 03h, 044Ah 0050h, 044Ch 1000h, 0460h 0E0Dh (cursor 0Dh-0Eh),
0463h 03D4h, 0465h 29h, 0466h 30h, 0484h 18h, 0485h 0010h, 0487h 60h, 0488h 09h, 0489h 11h, 048Ah
0Bh, 04A8h C000:3A09h. Vectors changed: INT 10h, 1Fh, 42h, 43h, 6Dh (INT 6Dh = INT 10h = C000:56C6h).
No other byte of 0400h-07FFh changed. The screen after POST is blank (no sign-on shown).
4F00 TotalMemory: 16, 32, 64 (follows the model's CR36). AH=12h BL=10h: BX = 0003h.

The p3 build (MCLK 69.8): the same, with SR10 22h, SR11 25h and CR52 80h written at the end.

S3TEST on the model with the reference ROM: 'ROM checksum = 00' PASS; 'Chip ID' 88 11 00 E1, PCI 8811
rev 00 (the model's values); 'MCLK SR10 SR11' 41 2C 54885/70000 kHz PASS; 'CR36 memory type' 9A EDO
INFO; 'VBE 4F05 regs, SR index ...' FAIL 02 (the 3C4h index left at 04h).

## Comparison with the rules

| Rule | Reference 1.5-07 (emulator) | p3 | Card | Agrees? Why |
| --- | --- | --- | --- | --- |
| POST-1 (BDF from AX) | finds the device with B102h, does not use AX | same | - | differs in method; behaviour the same on a one-card system |
| POST-2 (wake-up) | 46E8h 10h, 102h 01h, 46E8h 08h, preceded by 3C3h = 01h | same | - | agrees; the extra 3C3h write relates to open question 3 |
| POST-3, POST-4 (unlock, CR40 RMW) | CR38 48h, CR39 A5h, SR08 06h; CR40 written 31h/30h, later F0h/F1h | same | - | unlock agrees; CR40 differs: bits 7-6 (reserved, "=0") are written 1. The model starts CR40 at 00h, so the F0h comes from the ROM's own value, not a kept bit |
| POST-5 (identification) | CR30 written 55h (read-only register) | same | S3TEST Chip ID line on the card: not in the docs | the write is harmless on the chip (read-only); a clean ROM must not copy it |
| POST-8, POST-36a (locked after POST) | SR08 00h, CR38 00h, CR39 00h, CR40 bit 0 = 0 | same | - | agrees |
| POST-9 (Command register) | writes 03h unconditionally with B10Ch | same | PCI command on the card: 0003h (model table from the Trio64V2 card) | agrees in result; the rule sets the bits only when clear |
| POST-11, CONV-1 (CR59/CR5A = BAR0) | CR59/CR5A E000h (rewritten from the BAR high word, also kept in CR6B/CR6C) | E000h after POST; 000Ah after a banked 4F02 without Windows (the booster), E000h with the Windows check | BAR0 E0000000h, CR6B E0h (S3REGS); with the stock ROM and the V2 card the desktop shows CR59/CR5A E000h | agrees after POST; the booster of our ROM is outside the clean scope (CONV-2) |
| POST-13 (CR58) | 03h: linear off, window size 4 MB | 03h after POST; 10h after banked 4F02 (booster) | V2 card under Windows: 92h written by the driver | agrees (bit 4 = 0, bit 7 = 0) |
| POST-14, POST-15 (CR36) | writes CR36 bits 7-5 (1Ah then 9Ah, or 1Eh with 4 MB) keeping bits 4-0; 4 MB tried only with fast page | same | CR36 = 8Eh (2 MB, fast page, PCI) | agrees: the reference sizes by test and writes bits 7-5, as T32/64 5.1 says; the card's 100b is the BIOS's write, so its strap is unknown |
| POST-17 (SRA bit 6) | SRA C0h with 4 MB fast page, 80h otherwise | same | - | agrees for bit 6 |
| POST-18 (CR37, CR68 not written) | not written | same | CR68 = 8Dh (bit 7 = 1, RAS low 3.5, precharge 2.5, stretch 01b) | agrees |
| POST-20, open question 5 (SRA) | SRA bit 7 = 1 (2-MCLK writes) at 54.89 MHz, also in the 69.8 MHz build | same | the card's own BIOS (same code) runs 69.8 MHz, so presumably bit 7 = 1 there too (not read) | bit 7 at 54.89 MHz agrees with T64-MEM-4; above 57 MHz it is open |
| POST-21 to POST-23 (MCLK) | 41h 2Ch, 54.89 MHz, VCO 219.5 MHz | 22h 25h, 69.80 MHz, VCO 139.6 MHz | the card's own BIOS: 22h 25h (69.8 MHz); with p1: 41h 2Ch kept by Windows | agrees with POST-21, POST-22; the rule of POST-23 gives the same pairs for 55 and 69.8 MHz |
| POST-24, POST-25 (SR15) | SR15 written 00h then 03h and left 03h: bit 1 = 1, bit 0 = 1 left set | same | - | differs: T64-PLL-1 says bit 0 "should be cleared to 0 after loading to prevent repeated loading". The reference never clears it after POST |
| POST-28 (SR14) | SR14 = 03h (both PLLs powered down) then 00h, and the reference waits on SR17 (the model's SR17 counts) | same | - | differs: the reference uses the S3 test registers to restart the PLLs; the rule leaves them alone (open question 6 is about the settling instead) |
| POST-30 (engine reset) | 42E8h 9000h (bits 15-14 = 10b, reset; bit 12 set) then 5000h (bits 15-14 = 01b, enabled; bit 12 set) | same | - | agrees in the reset sequence; bit 12 is reserved in T32/64 (written 1 by the reference) |
| POST-31 (4AE8h) | 0000h first, then 02h and 07h during POST, 02h at the end | same | - | differs: the reference leaves 4AE8h = 02h (bit 1, reserved in T32/64) after POST; 07h during its engine clear (enhanced on, 4-bit) |
| POST-32 (BEE8h D and E) | writes index 0, 1, 2, 3, 4, A and E (E040h) before its first engine command; index D is never written | same | - | differs from POST-32 for index D (T32/64 gives D a defined power-on value, so the reference relies on it; a warm boot after a program that set D would misplace the clear) |
| POST-33 (engine command bit 0, idle wait) | the one command 40B3h has bit 0 = 1; the model reads 9AE8h busy and the reference does not hang there | same | - | agrees |
| POST-36e (SRD) | not written | same | - | differs: the reference relies on SRD being 00h at POST (a warm boot after DPMS off is not handled) |
| POST-36h (SR18) | 40h (bit 6 = 1: 1-DCLK LUT write) | same | - | differs from the power-on value; open question 7 |
| POST-36i (CR31) | 05h (bit 0 bank enable, bit 2 16-bit VGA memory bus) | same | - | bit 3 = 0 agrees; bits 0 and 2 are part B's choice |
| POST-36j (CR32) | 40h (bit 6: 256 KB wrap) | same | - | agrees (bit 4 = 0) |
| POST-36m (CR3A) | 05h: alternate refresh on, count 1 per line | same | - | open question 8 |
| POST-36s (CR54, CR60) | CR54 38h (M = 7), CR60 07h in mode 03h; CR61 80h, CR62 A1h (Vision864 registers, no Trio64 meaning) | same | - | part B; CR61/CR62 must not be copied |
| POST-36w (CR5C) | 43h | same | 43h after POST; 41h after Windows (the driver changes bit 1) | open question 9 |
| POST-36x (CR66) | 00h | same | - | agrees |
| POST-36y (CR69, CR6A) | 00h after the sizing | same | - | agrees |
| CONV-10 (CR41, CR52, CR6B, CR6C) | CR41/CR52 00h; CR6B E0h, CR6C 00h (copy of the base) | CR52 80h (800x600 at 60 Hz) | CR52 80h with p1-p3; CR6B E0h | the clean ROM may differ; no driver reads them (README) |
| POST-37 (BDA, vectors) | 0487h 60h, 0488h 09h, 0489h 11h, 048Ah 0Bh, 04A8h set; INT 10h, 1Fh, 42h, 43h, 6Dh | same | - | agrees with BDA-14 to BDA-19 and TAB-28/30 |
| POST-38 (no other BDA bytes) | none written | same | - | agrees |
| POST-39 (sign-on shown) | nothing on the screen after POST | same | the card shows a picture at POST (backport doc) | open question 10 |

## Lock state and index registers after calls (1.5-07 and p3 in the emulator)

Each call entered once with the chip locked (SR08 00h, CR38 00h, CR39 00h) and once unlocked (06h,
48h, A5h), with 3C4h = 02h, 3D4h = 0Eh, 3CEh = 05h before the call:

| Call | SR08 after | CR38/CR39 after | 3C4h, 3D4h, 3CEh after |
| --- | --- | --- | --- |
| AH=00h 03h, 12h, 13h | 00h in both cases | 48h/A5h in both cases | 04h or 08h, 67h, 06h or 08h |
| 4F00h, 4F01h, 4F03h, 4F06h, 4F07h, 4F08h, 4F10h, 4F15h | as found | 48h/A5h in both cases | 02h (kept), 36h/39h/67h/55h, 05h (kept) |
| 4F02h (101h, 8103h, 114h) | 00h in both cases | 48h/A5h | 08h, 67h (p3: 38h), 08h |
| 4F05h set and get | as found | 48h/A5h | 1.5-07: 04h, 6Ah, 05h; p3: 02h (kept), 6Ah, 05h |
| AH=12h BL=10h, AX=1A00h, AH=0Fh | as found | as found | 02h, 0Eh, 05h (all kept) |
| CR40 bit 0 | 1 after a mode set to an S3 mode, 0 after a VGA mode set | - | - |

Against CONV-8 and CONV-9: the reference differs. Its mode sets relock SR08 but leave CR38/CR39
unlocked (48h/A5h) whatever was found; every VBE call leaves CR38/CR39 unlocked; CR40 bit 0 stays 1
after an S3 mode. The CRTC index is not kept by any call that touches S3 registers; the sequencer index
is changed by mode sets and, in 1.5-07, by 4F05 (p3 fixes 4F05 only). [AGENTS.md](../../AGENTS.md) says "Phoenix relocks
the S3 registers after its calls": in the emulator only SR08 is relocked (by mode sets), CR38/CR39 are
not. A program written for this BIOS may therefore find the CRTC S3 registers unlocked after a VESA
call (open question 12 of the spec).

## The Windows 9x driver conventions

- `emu/tests.py --chip 764 --tests windows` with the reference ROM: FAIL, one check: "4F06 set:
  upper halves changed: eax A55A4F06->0000004F, ecx 855A0400->00000400, edx 955A0000->00000800" (CONV-4;
  [docs/764-rom.md](../764-rom.md) "Left as in 1.5-07" lists it). Every other check passes: CR59/CR5A stay
  E000h after the driver's banked 4F02 calls (CONV-1), every call returns with IF = 0 and no tick
  (CONV-5), mode 03h after the driver is IBM's (CONV-7).
- `engine_init` is skipped on `--chip 764` (the rule is tagged for the Trio64V+ family): the
  reference would fail it for index D (above).
- Card (Trio64V2 card, README): the driver's sequence as CONV-3 lists it; CR58 = 92h and CR59/CR5A =
  E000h on the desktop; the MCLK kept. On the DSP-3364P under Windows 98 (backport doc): the driver
  sets its modes through the BIOS (CR54 of mode 114h seen on the desktop), keeps SR10/SR11 = 41h 2Ch,
  leaves SR12/SR13 at 42h 2Bh and CR5C at 41h.

## The option ROM of the reference

`reference/trio64/1_5_07.bin`: 32768 bytes; 55h AAh 40h; PCI data structure at 0208h: "PCIR", 5333h,
8811h, VPD 0000h, length 0018h, revision 00h, class 00 00 03, image length 0040h, code revision 0000h,
code type 00h, indicator 80h. Byte sum over 32 KB = 00h. At 001Eh the text "IBM VGA Compatible BIOS."
(so "IBM" at 1Eh). Sign-on "Phoenix S3 TRIO64 Enhanced VGA BIOS. Version 1.5-07" within the first
256 bytes. Our 64 KB images carry the 32 KB twice (#78); the DSP-3364P's own ROM is 1.5-07 of 11/16/95
with the same header layout.

Against ROM-1 to ROM-5: agrees (the clean ROM's header fields are the same by the PCI specification
and the chip's IDs; only the code revision and the sign-on text differ). ROM-8: the reference's
sign-on contains "Version " within C000:0000h-00FFh, as S3TEST expects; the clean ROM's text must be
its own.

## Card values used by the rules (for the check on the card)

| Register | Card (DSP-3364P) | Source |
| --- | --- | --- |
| CR36 | 8Eh: 2 MB (BIOS-written), fast page, PCI | [docs/764-rom.md](../764-rom.md) "On the card" |
| CR68 | 8Dh: 64-bit bus, RAS low 3.5, precharge 2.5, stretch 5 ns | same |
| BAR0, CR6B | E0000000h, E0h | same |
| SR10/SR11 | 22h 25h with the card's own BIOS (69.8 MHz); 41h 2Ch with p1 | same; README "MCLK build option" |
| CR52 | 80h with our ROM | same |
| CR5C | 43h after POST, 41h after Windows | same |
| CR80-CRFF | read back as CR00-CR7F | same; chip-rules "Datasheet errors and gaps" |

A clean ROM on the card should show: CR36 bits 7-5 = 100b and bits 3-2 = 11b, CR68 = 8Dh unchanged,
CR59/CR5A = E000h after POST and every call, SR10/SR11 = the build's pair, SR15 = 02h, SR08/CR38/CR39 =
00h after POST, CR45 bit 0 = 0, CR58 bit 4 = 0.
