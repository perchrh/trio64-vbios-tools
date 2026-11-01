# Oracle for part C (VBE 1.2, S3 mode numbers, 4F14h): the reference ROM in the emulator

DIRTY SIDE ONLY. This file records what the reference ROM `reference/trio64/1_5_07.bin` (Phoenix S3
Trio64 BIOS 1.5-07, VBE 1.2) returns in the emulator, and compares it with the rules of
[`docs/cleanroom/spec-c-vbe.md`](spec-c-vbe.md). It is used to check the clean ROM and to answer questions through the
wall; its values do not go into the specification unless a rule there derives them from a public
source.

## How it was run

1 November 2026, [`emu/vgaemu.py`](../../emu/vgaemu.py) with `Machine.chip = 'trio64'`, `Machine.vram` = 1, 2 and 4, the
32 KB image doubled to 64 KB, `m.post()`, then `m.int10(...)` from mode 03h; registers from `m.r`,
memory with `m.mem`. Buffers at 3000:0000h prefilled with CCh to see what is written. The emulator
models registers and a planar window, not banked or linear video memory, so the clear of 4F02h and
data through the window are not observed here. Scripts: in the session scratchpad (orc1.py to
orc9.py); they are plain calls of the API above and can be retyped from this description.

## 4F00h

| Item | 1 MB | 2 MB | 4 MB | Spec rule | Agrees? |
| --- | --- | --- | --- | --- | --- |
| AX | 004Fh | 004Fh | 004Fh | VBE-20 | yes |
| Bytes written | 256 (also with 'VBE2' in the signature) | 256 | 256 | VBE-21 | yes |
| Reserved 14h-FFh | all 00h | all 00h | all 00h | VBE-21 | yes |
| Signature, version | 'VESA', 0102h | same | same | VBE-22 | yes |
| OEM string | C000:4D10h "S3 Incorporated. Trio64" | same | same | VBE-23 | pointer in ROM yes; the wording is the reference's own and must not be copied |
| Capabilities | 00000000h | same | same | VBE-24 | yes |
| Mode list | C000:4D28h (in ROM): 100 101 102 103 104 105 106 107 109 10A 110 111 112 113 114 115 116 117 118 119 11A 120, FFFFh | same | same | VBE-10, VBE-25 | pointer in ROM and static list: yes. Content differs: the reference also lists 106h, 109h, 10Ah, 118h, 119h, 11Ah, 120h (interlaced or above the CLK-1 limits at 60 Hz; our patched 1.5-07-pN removes 106h, 118h-11Ah, 120h as interlaced only, emu 764_patches) |
| TotalMemory | 16 | 32 | 64 | VBE-26 | yes |
| Other registers | kept | kept | kept | VBE-20 | yes |

## 4F01h

Common to every listed graphics mode in the reference: WinAAttributes 07h, WinBAttributes 00h,
WinGranularity 64, WinSize 64, WinASegment A000h, WinBSegment A000h, WinFuncPtr C000:4CC5h, banks 1,
BankSize 0, Reserved 1Eh = 01h, DirectColorModeInfo 00h, 28h-FFh zero, nothing past 256 bytes.
CX = 8101h is accepted as 101h, 4101h refused; 003h, 012h, 013h, 06Ah, 108h, 10Bh-10Fh, 11Bh, 17Fh: 014Fh.

| Mode | Attr 1/2/4 MB | BPL | XxY | Cell | Planes, bpp, model | Pages 1/2/4 MB | Masks (R, G, B, Rsvd: size/pos) |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 100h | 1B/1B/1B | 640 | 640x400 | 8x16 | 1, 8, 4 | 3/7/15 | 0 |
| 101h | 1B/1B/1B | 640 | 640x480 | 8x16 | 1, 8, 4 | 2/5/12 | 0 |
| 102h | 1F/1F/1F | 100 | 800x600 | 8x8 | 4, 4, 3 | 3/3/3 | 0 |
| 103h | 1B/1B/1B | 800 | 800x600 | 8x8 | 1, 8, 4 | 1/3/7 | 0 |
| 104h | 1B/1B/1B | 128 | 1024x768 | 8x16 | 4, 4, 3 | 1/1/1 | 0 |
| 105h | 1B/1B/1B | 1024 | 1024x768 | 8x16 | 1, 8, 4 | 0/1/4 | 0 |
| 106h | 1B/1B/1B | 160 | 1280x1024 | 8x16 | 4, 4, 3 | 0/0/0 | 0 |
| 107h | 1A/1B/1B | 1280 | 1280x1024 | 8x16 | 1, 8, 4 | 0/0/2 | 0 |
| 109h | 0F/0F/0F | 264 | 132x25 | 8x16 | 4, 4, 0 (text, window B800h, 32 KB) | 157/60/122 | 0 |
| 10Ah | 0F/0F/0F | 264 | 132x43 | 8x8 | 4, 4, 0 (text) | 91/183/112 | 0 |
| 110h | 1B/1B/1B | 1280 | 640x480 | 8x16 | 1, 15, 6 | 0/2/5 | 5/10 5/5 5/0 1/15 |
| 111h | 1B/1B/1B | 1280 | 640x480 | 8x16 | 1, 16, 6 | 0/2/5 | 5/11 6/5 5/0 0/0 |
| 112h | 1A/1B/1B | 2560 | 640x480 | 8x16 | 1, 32, 6 | 0/0/2 | 8/16 8/8 8/0 8/24 |
| 113h | 1B/1B/1B | 1600 | 800x600 | 8x8 | 1, 15, 6 | 0/1/3 | as 110h |
| 114h | 1B/1B/1B | 1600 | 800x600 | 8x8 | 1, 16, 6 | 0/1/3 | as 111h |
| 115h | 1A/1B/1B | 3200 | 800x600 | 8x8 | 1, 32, 6 | 0/0/1 | as 112h |
| 116h | 1A/1B/1B | 2048 | 1024x768 | 8x16 | 1, 15, 6 | 0/0/1 | as 110h |
| 117h | 1A/1B/1B | 2048 | 1024x768 | 8x16 | 1, 16, 6 | 0/0/1 | as 111h |
| 118h | 1A/1A/1B | 4096 | 1024x768 | 8x16 | 1, 32, 6 | 0/0/0 | as 112h |
| 119h | 1A/1A/1B | 2560 | 1280x1024 | 8x16 | 1, 15, 6 | 0/0/0 | as 110h |
| 11Ah | 1A/1A/1B | 2560 | 1280x1024 | 8x16 | 1, 16, 6 | 0/0/0 | as 111h |
| 120h | 1A/1B/1B | 1600 | 1600x1200 | 8x16 | 1, 8, 4 | 0/0/1 | 0 |

Against the specification:

- VBE-30, VBE-31, VBE-32, VBE-35, VBE-36, VBE-37: agree for the modes both have (attributes 1Bh/1Ah,
  1Fh for 102h with D2 = 1; the window fields; the direct colour masks; DirectColorModeInfo 0).
- WinBSegment: the reference returns A000h with window B not supported; the specification says 0000h
  (VBE12 6.3 notes: unused fields zero). Either passes S3COMPAT; a test comparing the clean ROM with this
  oracle must not compare offset 0Ah.
- D0 (VBE-11): agrees for every mode of the specification's list at 1, 2 and 4 MB (107h, 112h, 115h,
  116h, 117h unsupported at 1 MB only).
- Cell (VBE-33): agrees (8x8 in the 600-line modes, 8x16 elsewhere), derived independently there.
- Pages (VBE-34): agree for every packed and direct mode at every size. Differ in the planar modes: the
  reference counts 256 KB per plane at every size (102h 3, 104h 1), the specification M / 4 (102h 3/7/16,
  104h 1/4/9). Open question 4 of the specification.
- Modes only in the reference: 106h, 109h, 10Ah, 118h-11Ah, 120h (see the 4F00h table).
- The 2xxh numbers (not in the list) are accepted by 4F01h and 4F02h: 201h 640x480x8, 202h 800x600x4,
  203h 800x600x8, 204h 1024x768x4, 205h 1024x768x8, 208h 1280x1024x4 (BytesPerScanLine 1024 for all
  six; 208h is reported with 4 bits per pixel, although AH=00h 4Fh, its 7-bit form, sets CR67 = 11h, the
  clock-doubled 8-bit colour mode), 207h 1152x864x8 (BPL 1152), 213h 640x400x32 (BPL 2560); all
  attributes 1Bh at 2 MB.

## 4F02h and 4F03h

| Call (2 MB) | Reference | Spec | Agrees? |
| --- | --- | --- | --- |
| 4F03h in 03h, 12h, 13h | 004Fh, BX = 0003h, 0012h, 0013h | VBE-48 | yes |
| 4F02h 0003h, 0013h | 004Fh, 0049h = 03h/13h | VBE-42 | yes |
| 4F02h 0083h, 8003h, 8013h | 004Fh, mode set, text kept, 0087h bit 7 set | VBE-42 (8003h yes), open question 5 (0083h) | 8003h yes; 0083h: the reference applies AL bit 7 |
| 4F02h 0101h | 004Fh, 0049h = 69h, 0087h = 60h, AH=0Fh 5069h, 4F03h 0101h | VBE-45, VBE-48, S3M-1 | yes (the 7-bit number is the reference's) |
| 4F02h 8101h | 004Fh, 0087h = E0h, AH=0Fh 50E9h, 4F03h 0101h (no bit 15) | VBE-43, VBE-48 | yes |
| 4F02h 017Fh, 4101h, 0181h | 014Fh, 4F03h unchanged | VBE-41 | yes |
| 4F02h 006Ah | 004Fh, 4F03h 0102h | VBE-42, S3M-4 | yes |
| 4F02h 0106h | 004Fh (interlaced in 1.5-07) | not listed: 014Fh | differs (list) |
| 4F02h 0107h, 0112h, 0115h, 0116h, 0118h, 0119h with 1 MB | 004Fh: the reference sets them although 4F01h marks them unsupported | VBE-12: 014Fh, no change | DIFFERS: the reference does not check the memory in 4F02h (emu t_errors would flag it) |
| BIOS data after 4F02h 101h | 0049h 69h, 004Ah 0050h, 004Ch 1000h, 004Eh 0000h, 0062h 00h, 0084h 1Dh, 0085h 0010h, 0087h 60h | VBE-45 | yes (004Ch is not specified) |
| INT 43h after 101h | C000:6E30h (8x16 font) | VBE-45 | yes |
| DAC after 101h, 111h | the mode 13h default (entry 1 = 00 00 2A, 16 = 0, 255 = 0) | VBE-44 | yes |
| DAC after 102h | the EGA palette (entry 7 = 2A 2A 2A, 20 = 2A 15 00) | VBE-44 | yes |
| Registers after 4F02h 101h | CR31 09h, CR35 00h, CR51 00h, CR6A 00h, CR58 03h, display start 0 | VBE-44 | yes |
| Registers kept | BX, CX, DX, SI, DI, BP, ES kept | VBE-40 | yes |

## 4F04h (2 MB, in 101h)

| Call | Reference | Spec | Agrees? |
| --- | --- | --- | --- |
| DL = 0, CX = 1, 2, 4, 8, 0Fh | BX = 2, 2, 13, 2, 16 blocks | VBE-71 (each > 0, each <= all) | yes |
| DL = 0, CX = 0 | 004Fh, BX unchanged | open question 8 | - |
| DL = 0, CX = 10h, FFh | 004Fh, BX unchanged / 16: bits 15-4 ignored | VBE-70: 014Fh | differs |
| DL = 3 | 014Fh | VBE-70 | yes |
| AH=1Ch CX = 1, 2, 4, 7 | BX = 2, 2, 13, 15 | - | (for comparison) |
| Save CX = 1 in 111h, mode 03h, restore | standard VGA registers back (MISC, SR, CR00-17, GR, AR); CR31, 32, 34, 3A, 3B, 3C, 40, 50, 54, 60, 67, 6A not back; 4F03h 0003h | VBE-73 (D0 = standard registers only) | yes |
| Save CX = 8, mode 03h, restore | CR31, 32, 34, 3A, 3B, 3C, 40, 50, 54, 60, 67, 6A back; standard registers not | VBE-73, VBE-74 | yes (the reference's D3 includes CR6A, CR40) |
| Save CX = 0Fh, mode 03h, restore | everything back, 4F03h 0111h, 0049h 71h | VBE-73, VBE-46 | yes |

## 4F05h and the window function

| Call (2 MB) | Reference | Spec | Agrees? |
| --- | --- | --- | --- |
| 101h, BH = 0, DX = 1, 5, 10h, 1Fh | 004Fh, CR6A = DX, CR35 = CR51 = 00h, CR31 09h | VBE-51 | yes |
| 101h, DX = 20h, 3Fh, 40h, 100h (above 2 MB) | 004Fh, CR6A = 20h, 3Fh, 40h (bit 6 written), 00h (low byte) | VBE-54: 014Fh, CR6A unchanged; CR6A bits 7-6 kept | DIFFERS: no range check, reserved bit 6 written |
| BH = 1 | 004Fh, DX = CR6A | VBE-55 | yes |
| BL = 1 (window B), set and get | 004Fh, acts on CR6A as window A | VBE-50: 014Fh | differs |
| BH = 2 | 014Fh | VBE-50 | yes |
| BL = 2 | 004Fh (acts as window A) | VBE-50: 014Fh | differs |
| 102h and 104h, DX = 1, 2, 3 (1 and 4 MB too) | CR6A = 04h, 08h, 0Ch; get returns DX | VBE-52 | yes |
| In mode 03h, DX = 2 | 004Fh, CR6A = 08h | VBE-57: 014Fh | differs |
| In mode 13h, DX = 2 | 004Fh, CR6A = 02h with CR31 05h (bit 0 set: the window of mode 13h moves) | VBE-57: 014Fh | differs |
| Far call, BX = 0000h DX = 6 | CR6A 06h; AX = 004Fh; BX, CX, SI, DI, BP, DS, ES kept; flags changed | VBE-56 | yes (AX status allowed) |
| Far call, BX = 0100h | DX = 6 (get), AX = 004Fh | VBE-56 | yes |
| Far call, BX = 0200h | AX = 014Fh, CR6A unchanged | VBE-56 | yes |
| Sequencer index after 4F05h set/get and the far call (02h before) | 04h | VBE-5: 02h | DIFFERS (our patched 1.5-07-pN restores it, emu 764_patches) |
| CRTC index after 4F05h | 6Ah | VBE-5 | differs |

## 4F06h

| Call (2 MB) | Reference | Spec | Agrees? |
| --- | --- | --- | --- |
| 101h get | BX 640, CX 640, DX 3276 (0CCCh); 1 MB 1638, 4 MB 6553 | VBE-60 | yes |
| 101h set 641, 700 | BX = CX = 648, 704 (8-byte step); CR13 51h, 58h | VBE-61 | yes |
| 101h set 1024, 2048, 4096, 8184 | 1024 (CR13 80h), 2048 (CR13 00h, CR51 10h), 4096 (CR51 20h), 8184 all accepted at 1, 2 and 4 MB (8184: DX 128 at 1 MB, 256 at 2 MB, 512 at 4 MB) | VBE-61, VBE-62 | yes where 480 lines fit (1024 and 2048 everywhere, 4096 at 2 and 4 MB, 8184 at 4 MB); the reference also accepts 4096 at 1 MB and 8184 at 1 and 2 MB, which VBE-62 refuses (the 480 lines do not fit) |
| 101h set 8192, 9000, FFFFh | 014Fh | VBE-62 | yes |
| 101h set 0, 1 | 004Fh, back to 640 | VBE-61 (max(CX, XRes)) | yes |
| 111h set 641 | BX 1288, CX 640 | VBE-61: CX 644 | DIFFERS: the reference returns fewer pixels than asked |
| 111h set 700 | BX 1400, CX 696 | VBE-61: BX 1400, CX 700 | DIFFERS (CX rounded down by 4 pixels, the line holds 700) |
| 111h set 2048, 4096 | 4096 bytes accepted; 8192 bytes refused | VBE-62 | yes |
| 112h set 641 | BX 2568, CX 640 | VBE-61: CX 642 | differs |
| 102h get | BX 100, CX 800, DX 5242 (2 MB / 4 / 100) | VBE-60 | yes (DX with M / 4) |
| 102h set 640 | BX 80, CX 640, CR13 28h (2-byte units) | VBE-61: max(640, 800) = 800, BX 100 | DIFFERS (the reference goes below XResolution) |
| 102h set 641 | BX 80, CX 640 | VBE-61 | differs (fewer than asked) |
| 102h set 9000 | BX 1126 (CR13 33h, CR51 20h), CX 9008 | VBE-61, VBE-62 | step and registers agree; VBE-62 refuses it at 1 and 2 MB (600 lines x 1126 bytes above the plane memory) and accepts it at 4 MB |
| 102h set 0 | BX 26, CX 208 (CR13 0Dh) | VBE-61: 800 | DIFFERS (an odd result) |
| BL = 2, 3, 4 | 014Fh | VBE-63 | yes |
| In 03h and 13h | 014Fh | VBE-6 | yes |

## 4F07h

| Call (2 MB) | Reference | Spec | Agrees? |
| --- | --- | --- | --- |
| 101h set (8, 100) | CR0C:CR0D 3E82h = (100 x 640 + 8) / 4, CR69 0; get 8, 100 | VBE-64, VBE-67 | yes |
| 101h set (3, 100), (1, 0), (2, 0), (5, 0) | rounded down to 4 pixels; get 0, 0, 0, 4 | VBE-64, VBE-67 | yes |
| 101h set (0, 3000) | 004Fh, start 75300h: CR0C 53h CR0D 00h CR69 07h; CR31 bits 5-4 and CR51 bits 1-0 stay 0 | VBE-64 | yes |
| 101h set (0, 7FFFh) | 014Fh | VBE-65 | yes |
| 101h, pitch 4096, y = 500 at 1 MB (2 MB offset) | 004Fh | VBE-65 (accepted, open question 11) | yes |
| 101h, pitch 4096, y = 1600 | 014Fh (beyond the 20 bits) | VBE-65 | yes |
| 111h set (3, 100) | get 2, 100 (2-pixel step) | VBE-64 | yes |
| 112h set (3, 100), (5, 0) | exact (1-pixel step) | VBE-64 | yes |
| 112h set (0, 3000) at 2 MB | 014Fh (7.68 MB, beyond the 20 bits) | VBE-65 | yes |
| 102h set (8, 100) | start 2711h = 100 x 100 + 1 (bytes per plane); (3, 100) gives x 0; (100, 1) gives x 96 | VBE-64 (planar: 8-pixel step in plane bytes) | yes |
| 102h set (0, 3000) | 004Fh, start 493E0h (CR69 04h) | VBE-64, VBE-65 | yes |
| AR13 after any set | 00h | VBE-64 | yes |
| BL = 80h | 004Fh | VBE-68: 014Fh (open question 12) | differs (the reference accepts the 2.0 value) |
| BH = 1 with BL = 0 | 004Fh, set done | VBE-64 (BH not judged) | yes |
| BL = 2 | 014Fh | VBE-68 | yes |
| In mode 03h, set (0, 16) | 004Fh, start 0500h (16 x 80: lines times columns, not rows); get DX 16 | VBE-6: 014Fh | differs |

## 4F08h

| Call | Reference | Spec | Agrees? |
| --- | --- | --- | --- |
| BL = 0, BH = 8, 6, 4 (in 101h, 111h, 03h) | 004Fh, BH = 6 | VBE-80, VBE-82 | yes |
| BL = 1 | 004Fh, BH = 6 | VBE-81 | yes |
| BL = 2 | 014Fh | VBE-83 | yes |

## Other AL values

4F09h-4F0Fh, 4F11h-4F14h, 4F16h-4F1Fh, 4F80h, 4FFFh: AX = 4F00h, nothing else changed (VBE-3: yes;
AL is 00h). 4F10h answers 004Fh with BX = 0710h (VBE/PM, out of this version's scope: VBE-3 refuses
it). 4F15h answers 004Fh (DDC, out of scope). 4F14h is not offered (OEM-1: yes).

## Index registers and locks

After 4F00h, 4F01h, 4F03h, 4F04h, 4F06h, 4F08h the sequencer index is as the caller left it (02h); after
4F02h it is 08h, after 4F05h and 4F07h 04h. The CRTC index is left at 36h, 39h, 67h, 6Ah or 0Dh
depending on the function. CR38/CR39 read 48h/A5h after each call in this run. VBE-5 requires both
indexes as found: the reference differs for 3C4h after 4F02h, 4F05h, 4F07h and for 3D4h everywhere.

## S3 mode numbers through AH=00h (2 MB)

The reference's numbering (AL, what it sets, what 4F03h then returns). For the leak review: these are
the reference's choices; only 49h and 4Bh rest on a public source (README, Pinball Illusions).

| AL | Mode set | 4F03h | AL | Mode set | 4F03h |
| --- | --- | --- | --- | --- | --- |
| 49h | 640x480x8, pitch 1024 | 0201h | 6Ch | 1024x768x4 | 0104h |
| 4Ah | 800x600x4, pitch 1024 | 0202h | 6Dh | 1024x768x8 | 0105h |
| 4Bh | 800x600x8, pitch 1024 | 0203h | 6Eh | 1280x1024x4 | 0106h |
| 4Ch | 1024x768x4 | 0204h | 6Fh | 1280x1024x8 | 0107h |
| 4Dh | 1024x768x8 | 0205h | 70h-72h | 640x480 15/16/32 bpp | 0110h-0112h |
| 4Eh | 1152x864x8 | 0207h | 73h-75h | 800x600 15/16/32 bpp | 0113h-0115h |
| 4Fh | 1280x1024 (4F01h 208h: 4 bpp, pitch 1024; the set leaves CR67 = 11h) | 0208h | 76h-78h | 1024x768 15/16/32 bpp | 0116h-0118h |
| 52h | 640x400x32 | 0213h | 79h, 7Ah | 1280x1024 15/16 bpp | 0119h, 011Ah |
| 54h | 132x43 text | 010Ah | 7Ch | 1600x1200x8 | 0120h |
| 55h | 132x25 text | 0109h | | | |
| 68h | 640x400x8 | 0100h | | | |
| 69h | 640x480x8 | 0101h | | | |
| 6Ah | 800x600x4 (the VESA 6Ah) | 0102h | | | |
| 6Bh | 800x600x8 | 0103h | | | |

All other AL values 14h-7Fh leave mode 03h. AL = C9h sets 49h without the clear (0087h bit 7 set,
4F03h 0201h). Every VESA mode set through 4F02h stores its 6xh/7xh number in 0040:0049h.

Against the specification: S3M-1 (AH=00h, 0049h, AH=0Fh, 4F03h) agrees; S3M-2 agrees in resolution and
depth, but the reference's 49h and 4Bh are its 2xxh modes with a 1024-byte pitch (4F01h 201h/203h:
BytesPerScanLine 1024), not 101h/103h (640 and 800 bytes): a program that draws with a 640-byte pitch
in 49h would see a wrong picture on the reference. Pinball Illusions works on the reference (its
driver likely sets the pitch or uses 1024); the specification ties 49h/4Bh to 101h/103h. Open
question 13 should settle whether 49h and 4Bh keep the 1024-byte pitch (a test with the game on the
clean ROM decides).

## Summary of differences (reference against the specification)

1. 4F02h sets modes 4F01h marks unsupported (1 MB) (VBE-12).
2. 4F05h: no range check, reserved CR6A bit 6 written, window B and BL = 2 accepted, works in standard
   modes and moves mode 13h's window (VBE-50, VBE-54, VBE-57).
3. 4F06h: CX below the asked pixels in 15/16/32 bpp and planar; pitch below XResolution in 102h; odd
   result for CX = 0 in 102h; widths whose YResolution lines do not fit the memory are accepted
   (VBE-61, VBE-62).
4. 4F07h: BL = 80h accepted; works in mode 03h with lines x columns (VBE-6, VBE-68).
5. 4F04h: CX bits 15-4 ignored (VBE-70).
6. Planar NumberOfImagePages counted on 256 KB per plane (VBE-34, open question 4).
7. Index registers (3C4h after 4F02h, 4F05h, 4F07h; 3D4h) not restored (VBE-5).
8. Mode list: 106h, 109h, 10Ah, 118h-11Ah, 120h listed (VBE-10); WinBSegment A000h (VBE-32 table).
9. 49h/4Bh are 1024-pitch modes, not 101h/103h (S3M-2).
