# Clean-room specification, part C: VBE 1.2 and the S3 extensions (Trio64)

This part specifies the VESA BIOS Extension of the Trio64 (S3 86C764X) video BIOS built on SeaVGABIOS:
functions 4F00h-4F08h as VBE 1.2 (VS911022) defines them, the mode list and the mode information of
each mode, the window (bank) function, the logical scan line and display start functions, the DAC
width, and, as a second step, the S3 mode numbers reachable through INT 10h AH=00h and the S3 OEM
function 4F14h. It covers items 3 and 5 of `docs/seavgabios-trio64.md`. The register timings of each
mode (CRTC, PLL, FIFO) belong to item 2 and are referred to, not repeated; the standard INT 10h
functions are in `docs/bios-rules.md`; the data book rules in `docs/chip-rules.md`.

Written 1 November 2026 from the sources below. Everything here is behaviour: inputs, outputs, register
values or formulas, error cases. The observed results of the reference ROM are kept apart, in
`docs/cleanroom/oracle-c-vbe.md` (dirty side only).

## Conventions

- **Sources.** Short names:

  | Short name | Document |
  | --- | --- |
  | VBE12 | VESA Super VGA BIOS Extension, Standard VS911022, 22 October 1991, VBE version 1.2 (the retyped text, README "VESA standards"); cited by its section numbers (4 mode numbers, 5 windows, 6.1 status, 6.2-6.10 functions 00h-08h) |
  | VBE20 | VESA BIOS Extension Core Functions 2.0, Rev. 1.1 (`standards/vesa/vbe20.pdf`), for the shared definitions (4.1 status, 4.3 ModeInfoBlock, 4.7-4.11); never a source of a 2.0-only feature |
  | T32/64 | S3 Trio32/Trio64 data book, March 1995 (`datasheets/`), by section, table, figure or register |
  | chip-rules | `docs/chip-rules.md`, by rule ID (CLK-1, T64-MEM-6, ...) |
  | bios-rules | `docs/bios-rules.md`, by rule ID (B00-4, BDA-14, ...) |
  | VGADOC | Finn Thoegersen's VGADOC 4b, `standards/thoegersen/` (VESA.TXT, S3.TXT) |
  | DMT | VESA DMT pixel clocks as published industry figures: 640x480 at 60 Hz 25.175 MHz, 800x600 at 60 Hz 40.000 MHz, 1024x768 at 60 Hz 65.000 MHz, 1280x1024 at 60 Hz 108.000 MHz; 640x400 at 70 Hz is the IBM VGA 400-line timing, 25.175 MHz (bios-rules MODE-11) |
  | Haakenson | B. Haakenson, "Examining the VESA VBE 2.0 Specification", DDJ July 1995 (README "VESA standards") |
  | README | this repository's README, for the behaviour of programs and drivers logged on the cards (VGALOG, S3REGS) |
  | AGENTS | the project's hard rules for the ROM (`AGENTS.md`) |

- **IDs.** `VBE-n` the VBE functions and the mode list, `S3M-n` the S3 mode numbers through AH=00h,
  `OEM-n` the S3 OEM function 4F14h. An ID is never reused for another rule.
- **Strength.** *must*: the standard or the data book requires it, or a test of the project fails
  without it; a violation is a FAIL. *should*: the standard recommends it, or it is a decision of this
  specification that a public source supports; a WARN at most. *note*: information, never a FAIL.
  *observed*: taken from black-box behaviour of BIOS images or of programs, not from a standard
  (every S3M and OEM rule that is not about the VBE principle); WARN or INFO at most.
- **Checked by.** An S3COMPAT line, S3TEST line or emulator test (`emu/tests.py`), or "not checked"
  with the test that would check it.
- **Terms.**
  - *Listed mode*: a mode number of the 4F00h mode list (VBE-10). *Available mode*: a listed mode
    whose 4F01h ModeAttributes bit D0 is 1 in the present memory configuration (VBE-12).
  - *Packed modes*: memory model 04h (8 bits per pixel). *Direct colour modes*: memory model 06h
    (15, 16 and 32 bits per pixel). *Planar modes*: memory model 03h (4 planes, 4 bits per pixel).
  - *Bpp*: bytes per pixel, 1 (8 bpp), 2 (15 and 16 bpp), 4 (32 bpp).
  - *M*: the installed video memory in bytes, TotalMemory x 65536 (1, 2 or 4 MB, sized at POST from
    CR36 bits 7-5, T64-MEM-5). *Plane memory*: M / 4 in the planar modes (bytes per plane), M in the
    others.
  - *Current mode*: the mode of the last successful mode set (AH=00h or 4F02h).
- **General rule.** A register not named in a rule's outputs is returned as the caller gave it, the
  upper halves of the 32-bit registers included (AGENTS "Preserve the registers callers rely on";
  emu t_windows checks it with garbage in the upper halves). The direction flag is kept.
- Values are hexadecimal with an h suffix, offsets of the info blocks in hex.

## General VBE rules (all functions)

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| VBE-1 | Every VBE call is INT 10h with AH = 4Fh and the function in AL. The status is returned in AX: AL = 4Fh means the function is supported, AH = 00h success, AH = 01h failure. A VBE 1.2 BIOS uses only these two AH values: every failure of this BIOS returns AX = 014Fh (the VBE 2.0 codes 02h and 03h are not returned) | VBE12 6.1; VBE20 4.1 (02h, 03h added by 2.0) | must (004Fh/014Fh), should (no 024Fh/034Fh) | S3COMPAT 'VBE invalid subfunctions refused' (each refusal must not be 004Fh); not checked for 024Fh/034Fh: a test calling each failure case and comparing AX with 014Fh would |
| VBE-2 | A failed call (AX = 014Fh) changes nothing: no register other than AX, no video memory, no BIOS data, no VGA or S3 register | VBE12 6.4 ("If the mode cannot be set, the BIOS should leave the video environment unchanged"); VBE20 4.10 note ("fail the Function call and make no changes") | must | emu t_errors (refused 4F02h modes: video state unchanged; 4F14h refusals); S3COMPAT '4F01/4F02 reject invalid mode 17Fh' (fail 4: current mode unchanged) |
| VBE-3 | AL values the BIOS does not implement (09h-FFh in the first version, including 4F10h, 4F14h, 4F15h, which are out of scope) return with AL other than 4Fh (AX = 0100h is acceptable) and change nothing; in particular the current mode (4F03h) stays | VBE12 6.1 ("AL != 4Fh: function is not supported"), 6 ("Subfunction numbers ... reserved for future use"); `docs/clean-room.md` "Scope" | must | S3COMPAT 'VBE undefined functions 4F0B-4F1F' (fail 1 a 004Fh, 2 the mode changed); S3COMPAT '4F14 S3 OEM functions' (INFO when AL is not 4Fh) |
| VBE-4 | The VBE functions do not enable interrupts when the caller called with IF = 0, and return with the caller's IF | README "Windows 9x driver"; emu t_windows | must | emu t_windows (every call returns with IF = 0 and no timer tick) |
| VBE-5 | Index registers: after every VBE call (and the far window function) the sequencer index (3C4h) and the CRTC index (3D4h) hold what the caller left in them; the S3 register locks (SR08, CR38, CR39) are left as found, and CR40 bit 0 too, except where a mode set (4F02h) or a 4F04h restore sets it as part of the mode | AGENTS ("A BIOS call of our ROMs leaves the index registers it touches as it found them"); `docs/seavgabios-trio64.md` item 1 (lock as found) | must (3C4h), should (3D4h) | S3TEST 'VBE 4F05 regs, SR index, CR6A, planar, LFB' (fail bit 2, 3C4h after 4F05); emu t64_patches (SR index after 4F05 BH = 0 and 1); 3D4h not checked: a test like t64_patches reading the CRTC index after each 4F0xh would |
| VBE-6 | A function that is valid only in a VESA mode (4F05h, 4F06h, 4F07h) and is called in a standard mode 00h-13h returns 014Fh and changes nothing (see open question 7) | VBE12 6.7 (window parameters come from 4F01h, which covers listed modes only); decision of this specification | should | not checked: a test calling 4F05h-4F07h in modes 03h and 13h and comparing the registers |

## The mode list and the modes (4F00h list, 4F01h, 4F02h)

How the list is derived: the VBE 1.2 modes (VBE12 4) whose 60 Hz (VESA DMT) or 70 Hz (640x400, IBM)
timing fits the Trio64's colour mode clock limits (CLK-1) and whose picture fits 4 MB at most. The
Trio64 has no packed 24-bit mode (CLK-2), so the 16.8M modes store a pixel in 32 bits (T32/64 CR50
bits 5-4 = 11b: "True color (24 bits/pixel) is handled by this setting, with the upper byte unused";
colour mode 13, table 8-1).

| Mode | Resolution | Memory model | Bits per pixel | Planes | BytesPerScanLine (default) | Picture bytes | Pixel clock | Colour mode (CR67 bits 7-4, T32/64 table 8-1) | Fits |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 100h | 640x400 | 04h packed | 8 | 1 | 640 | 256000 | 25.175 MHz (70 Hz) | 0 (0000b), limit 80 MHz | 1 MB |
| 101h | 640x480 | 04h packed | 8 | 1 | 640 | 307200 | 25.175 MHz | 0, 80 MHz | 1 MB |
| 102h | 800x600 | 03h planar | 4 | 4 | 100 | 60000 per plane | 40.000 MHz | VGA 16-colour path through the LUT, 80 MHz | 1 MB |
| 103h | 800x600 | 04h packed | 8 | 1 | 800 | 480000 | 40.000 MHz | 0, 80 MHz | 1 MB |
| 104h | 1024x768 | 03h planar | 4 | 4 | 128 | 98304 per plane | 65.000 MHz | as 102h, 80 MHz | 1 MB |
| 105h | 1024x768 | 04h packed | 8 | 1 | 1024 | 786432 | 65.000 MHz | 0, 80 MHz | 1 MB |
| 107h | 1280x1024 | 04h packed | 8 | 1 | 1280 | 1310720 | 108.000 MHz | 8 (0001b, two pixels per VCLK, VCLK 54 MHz, limit 67.5 MHz; CLK-3) | 2 MB |
| 110h | 640x480 | 06h direct | 15 | 1 | 1280 | 614400 | 25.175 MHz | 9 (0011b), 80 MHz | 1 MB |
| 111h | 640x480 | 06h direct | 16 | 1 | 1280 | 614400 | 25.175 MHz | 10 (0101b), 80 MHz | 1 MB |
| 112h | 640x480 | 06h direct | 32 | 1 | 2560 | 1228800 | 25.175 MHz | 13 (1101b), 50 MHz | 2 MB |
| 113h | 800x600 | 06h direct | 15 | 1 | 1600 | 960000 | 40.000 MHz | 9, 80 MHz | 1 MB |
| 114h | 800x600 | 06h direct | 16 | 1 | 1600 | 960000 | 40.000 MHz | 10, 80 MHz | 1 MB |
| 115h | 800x600 | 06h direct | 32 | 1 | 3200 | 1920000 | 40.000 MHz | 13, 50 MHz | 2 MB |
| 116h | 1024x768 | 06h direct | 15 | 1 | 2048 | 1572864 | 65.000 MHz | 9, 80 MHz | 2 MB |
| 117h | 1024x768 | 06h direct | 16 | 1 | 2048 | 1572864 | 65.000 MHz | 10, 80 MHz | 2 MB |

Left out, with the reason: 106h (1280x1024x4, 108 MHz above the 80 MHz of the LUT path; clock doubling
exists for 8 bpp only, CLK-1, CLK-3); 118h (1024x768x32, 65 MHz above the 50 MHz of colour mode 13);
119h and 11Ah (1280x1024 at 15/16 bpp, 108 MHz above 80 MHz); 11Bh (both reasons); 108h-10Ch (text,
outside the first version's scope of packed modes, open question 1); 10Dh-10Fh (320x200 direct colour,
open question 2; `spec-b-modeset.md` MODE-102 also leaves them out). The planar modes 102h and 104h are
in the list here; their register programming is not in `spec-b-modeset.md` (its MQ-9). A lower refresh than 60 Hz or an interlaced timing is not used to bring a mode in
(`docs/seavgabios-trio64.md` "Scope": 60 Hz or more).

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| VBE-10 | The mode list (4F00h VideoModePtr) holds, in this order, 100h, 101h, 102h, 103h, 104h, 105h, 107h, 110h, 111h, 112h, 113h, 114h, 115h, 116h, 117h, then FFFFh. The list is the same with 1, 2 and 4 MB; whether a mode fits is told by 4F01h bit D0 (VBE-12) | VBE12 6.2 ("Some of the returned modes may not be available due to the video board's current memory ... configuration"; the application checks with function 1); the derivation above (CLK-1, CLK-2, CLK-3, DMT) | should (the content is this specification's choice), must (FFFFh end) | S3COMPAT 'Standard modes 100-107,110-11A listed' (INFO on the Trio64: lists 106h, 118h-11Ah as missing); emu t_errors (every listed mode too large for the memory is marked unsupported) |
| VBE-11 | A mode fits when its picture fits the memory: BytesPerScanLine x YResolution <= plane memory (VBE terms: one complete image). With 1 MB 107h, 112h, 115h, 116h and 117h do not fit; with 2 and 4 MB every listed mode fits | VBE12 6.3 (D0 "Mode supported in hardware ... in the present video configuration"); the table above | must | emu t_errors (bytes per line x lines, x 4 planes in the 16-colour modes, not above the memory, else marked unsupported); S3TEST 'VBE  Mode 0107 (over 1 MB) ... SKIP' on 1 MB |
| VBE-12 | 4F01h, 4F02h and the S3 numbers (S3M) treat a listed mode that does not fit as not supported: 4F01h answers 004Fh with D0 = 0 and every other field valid; 4F02h answers 014Fh and changes nothing (VBE-2) | VBE12 6.3, 6.4 | must | emu t_errors ('4F02 BX=... accepted', '(refused) changed the video state') |

### INT 10h AX=4F00h: return Super VGA information

Input ES:DI = a buffer of 256 bytes. The VbeInfoBlock of VBE 1.2: 00h VESASignature (4 bytes), 04h
VESAVersion (word), 06h OEMStringPtr (far pointer), 0Ah Capabilities (4 bytes), 0Eh VideoModePtr (far
pointer), 12h TotalMemory (word), 14h Reserved (236 bytes).

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| VBE-20 | Output AX = 004Fh; every register other than AX is returned as given (ES and DI included) | VBE12 6.2 ("All other registers are preserved") | must | S3COMPAT '4F00 VESA sig' (fail 1 status) |
| VBE-21 | Exactly 256 bytes are written at ES:DI, whatever the caller put in the signature field: a 'VBE2' signature does not make a 1.2 BIOS write 512 bytes. Bytes 14h-FFh (Reserved) are written as 00h | VBE12 6.2 ("The information block size is 256 bytes"); VBE12 6.3 notes (unused fields zero, from 1.1); Haakenson (the 512-byte block and 'VBE2' are 2.0) | must (256), should (zeros) | S3COMPAT '4F00 VESA sig' (warn 1 wrote past 256 bytes); S3COMPAT '4F00 VBE2 sig, 512 byte block' (fail 1 past 512) |
| VBE-22 | VESASignature = 'VESA' (56h 45h 53h 41h); VESAVersion = 0102h | VBE12 6.2; `docs/seavgabios-trio64.md` item 3 | must | S3COMPAT '4F00 VESA sig' (fail 1: signature, version below 1.2) |
| VBE-23 | OEMStringPtr: a far pointer into the ROM (segment C000h) to an ASCII string ending in 00h, of this BIOS's own wording (open question 3); it is never a string of another BIOS | VBE12 6.2 ("There are no restrictions on the format of the string"); `docs/clean-room.md` item 2 ("our own OEM strings") | must (pointer, NUL), should (wording) | S3COMPAT 'OEM string:' (INFO, prints it) |
| VBE-24 | Capabilities = 00000000h: bit D0 = 0, the DAC has a fixed width of 6 bits per primary (VBE-80); D1-D31 reserved = 0 | VBE12 6.2; T32/64 section 8 ("three 256 6-bit word color look-up table (LUT) RAMs"), 14.7 (3C9h: "The least significant 6 bits of each byte") | must | S3COMPAT '4F00 capabilities vs 4F08' (fail 1 bit 0 against 4F08h, 2 bit 1 set) |
| VBE-25 | VideoModePtr: a far pointer to the list of VBE-10 as words, ending in FFFFh, kept in the ROM (not built inside the caller's 256-byte block, which a VBE 1.x program may copy or reuse) | VBE12 6.2 (ROM or RAM allowed); VBE20 4.2 note on the Reserved field (2.0 allows the list there) | must (list, FFFFh), should (in ROM) | S3COMPAT '4F00 VESA sig' (warn 2 mode list inside the caller's buffer) |
| VBE-26 | TotalMemory = M / 65536: 16 (0010h) with 1 MB, 32 (0020h) with 2 MB, 64 (0040h) with 4 MB, from the memory size found at POST (CR36 bits 7-5) | VBE12 6.2 ("number of 64kb blocks of memory currently installed"); T64-MEM-5 | must | S3COMPAT '4F00 VESA sig' (prints the KB); S3COMPAT '4F14 S3 OEM functions' compares SI with it; emu tests run with 1, 2 and 4 MB (`vram` tag) |
| VBE-27 | 4F00h works in any current mode and changes no video state | VBE12 6.2 | must | not checked separately: compare the VGA state before and after 4F00h (emu t_errors' vga_state) |

### INT 10h AX=4F01h: return Super VGA mode information

Input CX = mode number, ES:DI = a buffer of 256 bytes. The ModeInfoBlock of VBE 1.2 (offsets from
VBE20 4.3, the same for 1.2; VGADOC VESA.TXT):

| Offset | Field | Value in every listed mode | Source |
| --- | --- | --- | --- |
| 00h | ModeAttributes (word) | VBE-31 | VBE12 6.3 |
| 02h | WinAAttributes | 07h (supported, readable, writeable) | VBE12 6.3; VBE12 5.2.1 (single window) |
| 03h | WinBAttributes | 00h (no window B) | VBE12 6.3 |
| 04h | WinGranularity (word, KB) | 64 | VBE12 5.1.2; T32/64 CR6A ("64K pages") |
| 06h | WinSize (word, KB) | 64 | T32/64 CR31 bit 3 ("fixed 64K map at A0000H") |
| 08h | WinASegment | A000h | T32/64 CR31 bit 3 |
| 0Ah | WinBSegment | 0000h (window B not supported; unused fields are zero) | VBE12 6.3 notes |
| 0Ch | WinFuncPtr (far pointer) | the window function in the ROM, never 0 (VBE-50) | VBE12 6.3, 6.7 |
| 10h | BytesPerScanLine | the table's default (packed and direct: XResolution x Bpp; planar: XResolution / 8) | VBE12 6.3 |
| 12h | XResolution | the table | VBE12 4 |
| 14h | YResolution | the table | VBE12 4 |
| 16h | XCharSize | 8 | VBE-33 |
| 17h | YCharSize | VBE-33 | VBE12 6.3 |
| 18h | NumberOfPlanes | 1 (packed, direct), 4 (planar) | VBE12 6.3 |
| 19h | BitsPerPixel | 8, 4, 15, 16 or 32 (the table) | VBE12 6.3; VBE12 4 ("32K (1:5:5:5)") |
| 1Ah | NumberOfBanks | 1 | VBE12 6.3 ("For modes that don't have scanline banks ... set to 1") |
| 1Bh | MemoryModel | 04h, 03h or 06h (the table) | VBE12 6.3 |
| 1Ch | BankSize | 0 | VBE12 6.3 |
| 1Dh | NumberOfImagePages | VBE-34 | VBE12 6.3 |
| 1Eh | Reserved | 01h | VBE12 6.3 ("will always be set to one in this version") |
| 1Fh-26h | Red, Green, Blue, Rsvd MaskSize and FieldPosition | VBE-35 | VBE12 6.3; T32/64 figures 8-3 to 8-5 |
| 27h | DirectColorModeInfo | 00h (VBE-36) | VBE12 6.3 |
| 28h-FFh | Reserved | 00h | VBE12 6.3 notes ("zero out all unused fields ... exactly 256 bytes") |

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| VBE-30 | CX = a listed mode, with or without bit 15 (the no-clear flag of 4F02h, answered as without it): AX = 004Fh, exactly 256 bytes written at ES:DI, every register other than AX as given. CX not a listed mode (standard modes 00h-13h, 17Fh, 106h, 118h, 200h, 1FFh, and any number with bits 9-14 set): AX = 014Fh, nothing written | VBE12 6.3 ("mode number must be one of those returned by Function 0"; "exactly 256 bytes"); VBE12 4 (bits 9-14 reserved = 0) | must (bit 15: should) | S3COMPAT '4F01 writes 256 bytes only'; S3COMPAT '4F01/4F02 reject invalid mode 17Fh' (fail 1); emu t_errors |
| VBE-31 | ModeAttributes: D0 = 1 when the mode fits (VBE-11), else 0; D1 = 1 always; D2 = 1 only in modes where the BIOS's output functions (AH=09h, 0Ah, 0Ch, 0Dh, 0Eh, 06h, 07h, 13h) work over the whole picture, which needs no bank switching only in 102h (60000 bytes per plane, inside the 64 KB window), so D2 = 1 in 102h and 0 in the others unless the BIOS implements banked output there; D3 = 1 (colour, CRTC at 3D4h); D4 = 1 (graphics); D5-D15 = 0 (reserved in 1.2: no VBE 2.0 bits such as D5 "not VGA compatible" or D7 "linear frame buffer"). So 001Bh or 001Ah in the packed and direct modes, 001Fh/001Eh in 102h | VBE12 6.3 (D1 "must be set to a 1"; D2 "If bit D2 is 1 then the BIOS must support all of the standard output functions"; D5-D15 reserved); VBE12 3 | must | S3COMPAT 'VESA nnnn' lines (INFO when D0 = 0; fail 1, 4); emu t_errors (D0 against the memory) |
| VBE-32 | Window fields as in the table above: one window A of 64 KB at A000h, readable and writeable, placed on 64 KB boundaries; no window B (WinBAttributes 00h, WinBSegment 0000h) | VBE12 5.1.1, 5.2.1, 6.3; T32/64 CR6A, CR31 bit 3 | must | S3COMPAT 'VESA nnnn' lines (fail 2: window A not 64 KB granularity/size at A000h, readable and writable) |
| VBE-33 | XCharSize = 8; YCharSize = the tallest of the BIOS fonts 16, 14 and 8 that divides YResolution: 16 in the 400-, 480-, 768- and 1024-line modes, 8 in the 600-line modes (600 is no multiple of 16 or 14). The same cell is what AH=0Fh's columns (0040:004Ah = XResolution / 8), the rows (0040:0084h = YResolution / YCharSize - 1) and INT 43h use after the mode set (VBE-44) | VBE12 6.3 ("size of the character cell in pixels"); bios-rules B00-16, BDA-12, BDA-13 | should | not checked: a test comparing 4F01h's cell with 0040:0084h/0085h after 4F02h |
| VBE-34 | NumberOfImagePages = (plane memory / (BytesPerScanLine x YResolution)) rounded down, minus 1, at most 255; 0 when the mode does not fit. Values: 1 MB: 100h 3, 101h 2, 102h 3, 103h 1, 104h 1, 105h 0, 110h/111h 0, 113h/114h 0. 2 MB: 100h 7, 101h 5, 102h 7, 103h 3, 104h 4, 105h 1, 107h 0, 110h/111h 2, 112h 0, 113h/114h 1, 115h 0, 116h/117h 0. 4 MB: 100h 15, 101h 12, 102h 16, 103h 7, 104h 9, 105h 4, 107h 2, 110h/111h 5, 112h 2, 113h/114h 3, 115h 1, 116h/117h 1 | VBE12 6.3 ("number of additional complete display images that will fit into the VGA's memory"); VBE20 4.3 ("total number minus one") | must (formula), should (planar: M / 4 per plane, open question 4) | S3COMPAT 'VESA nnnn' lines (fail 4: (pages + 1) x pitch x lines, x 4 in planar modes, above the memory) |
| VBE-35 | Direct colour fields (memory model 06h only; 0 in the packed and planar modes): 15 bpp: red 5 at 10, green 5 at 5, blue 5 at 0, reserved 1 at 15. 16 bpp: red 5 at 11, green 6 at 5, blue 5 at 0, reserved 0 at 0. 32 bpp: red 8 at 16, green 8 at 8, blue 8 at 0, reserved 8 at 24 (size, position). These are the Trio64's pixel layouts | VBE12 6.3 (MaskSize, FieldPosition; "set to 0 in modes using a MemoryModel that does not have pixels with component fields"); T32/64 figure 8-3 (15 bpp: bit 15 = 0, R4-R0 in bits 14-10, G 9-5, B 4-0), figure 8-4 (16 bpp: R 15-11, G 10-5, B 4-0), figure 8-5 (24 bpp: R in PA 23-16, G 15-8, B 7-0), CR50 bits 5-4 (upper byte of 32 unused) | must | S3COMPAT 'VESA nnnn' lines (fail 4: masks not 5:5:5, 5:6:5 or 8:8:8 at those positions, sum against BitsPerPixel) |
| VBE-36 | DirectColorModeInfo = 00h in every mode: D0 = 0, the direct colour modes bypass the LUT (fixed colour ramp); D1 = 0, the reserved bits are reserved (figure 8-3 shows bit 15 of the 15-bit pixel as 0) | VBE12 6.3; T32/64 8.1.3, 8.1.5 ("LUT Bypass"), figure 8-3 | should | not checked: a test reading offset 27h of every mode |
| VBE-37 | The far pointer at 0Ch is the same in every mode or differs per mode; a program takes it again after each mode set. It is a valid ROM address in every listed mode, whether or not the mode fits | VBE12 6.7 notes ("this function may be different among video modes ... obtained after each set mode") | must (valid), note (per mode) | S3COMPAT '4F05 bank set/get + WinFuncPtr' (fail 2 no WinFuncPtr) |

### INT 10h AX=4F02h: set Super VGA video mode

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| VBE-40 | Input BX only: bits 8-0 the mode, bits 14-9 reserved (0), bit 15 = 1 keeps video memory. CX, DX and the other registers are no input (S3's Windows 9x driver calls 4F02h with CX = lines and DX = 3D4h) and come back as given; output AX = 004Fh or 014Fh | VBE12 4, 6.4; README "Windows 9x driver test" (the driver's 4F02h calls) | must | emu t_windows (the driver's 4F02h calls); S3COMPAT 'VESA nnnn' (fail 8 4F02 failed) |
| VBE-41 | BX = a listed mode that fits (with or without bit 15): the mode is set (timing and registers: item 2 of the plan) and AX = 004Fh. BX = a listed mode that does not fit, an unlisted number from 100h up, or any BX with bits 14-9 not 0 (for example 4101h, 017Fh, 01FFh, 0200h): AX = 014Fh and nothing changes (VBE-2) | VBE12 6.4; VBE12 4 (D9-D14 reserved) | must | S3COMPAT '4F01/4F02 reject invalid mode 17Fh' (fail 2, 4); emu t_errors (refused modes: AX and the video state) |
| VBE-42 | BX below 100h (BH = 0): BL is a standard or OEM mode number and is set exactly as INT 10h AH=00h with AL = BL would set it (bios-rules B00 rules), including the S3 numbers (S3M-1); BX bit 15 with BH bits 6-0 = 0 (8000h-80FFh) sets that mode without the clear, as AH=00h with AL bit 7. A number AH=00h does not support gives 014Fh and no change. Afterwards 4F03h returns BX = 00xxh (or the VESA number of an S3 number, S3M-1). BL bit 7 is open question 5 | VBE12 4 ("regular VGA modes may be initialized through VESA BIOS function 02h, simply by placing the mode number in BL and clearing the upper byte"; "OEM-defined modes may be initialized in the same way"); bios-rules B00-4, B00-23 | must (BL = 00h-13h), should (the rest) | not checked: a test comparing the VGA state after 4F02h 0003h/0013h and AH=00h 03h/13h (emu refcompare style) |
| VBE-43 | The clear (BX bit 15 = 0): all of video memory, M bytes, is written with 00h (every byte in the packed and direct modes; all four planes in the planar modes), not only the first image, so off-screen pages are clean too. Bit 15 = 1: video memory is not written at all. In both cases 0040:0087h bit 7 is set to bit 15 (as AH=00h does with AL bit 7) | VBE12 6.4 ("0 = Clear video memory"); VBE12 6.5 notes (D7 of 0040:0087h "set if the mode was set without clearing memory"); bios-rules B00-4, BDA-14 | must (cleared/kept), should (all M bytes) | S3COMPAT '4F02 clear / D15 keep memory' (marks in bank 0 and the last bank: fail 1 cleared despite D15, 2 not cleared without it); emu rom_patches/t64_patches (bank 0 zeroed after 4F02h 101h) |
| VBE-44 | After a successful 4F02h of a listed mode, the state is (besides the mode's timing of item 2): window A at bank 0 (CR6A bits 5-0 = 0 with CR35 bits 3-0 = 0 and CR51 bits 3-2 = 0, so that bank 0 really maps the first 64 KB, VBE-53) and CR31 bit 0 = 1 (CPU base address enabled); display start 0 (CR0C = CR0D = 0, CR69 bits 3-0 = 0, CR31 bits 5-4 = 0, CR51 bits 1-0 = 0); the logical scan line the table's default (VBE-60, CR13 with CR51 bits 5-4, CR43 bit 2 = 0); DAC width 6 bits (VBE-80); the DAC loaded as AH=00h loads it for mode 13h (packed and direct modes) or mode 12h (planar), with the same palette loading and grey summing switches (bios-rules B00-10 to B00-12, B12.31); the attribute flip-flop reset (bios-rules B00-9) | T32/64 CR6A, CR35, CR51, CR31 bits 0 and 5-4, CR69 ("When a non-zero value is programmed in this field, bits ... of the old ... are ignored"); VBE12 6.10 ("The DAC palette width is assumed to be reset to standard VGA 6-bits per primary during a ... Set Super VGA Mode"); bios-rules B00-9, B00-10 | must | emu rom_patches / t64_patches (CR6A back to 0 after the mode set; ATC flip-flop); S3COMPAT 'VESA nnnn' (fail 800 memory mapping: CR31 bit 0 for modes above 64 KB); emu t_windows (6-bit DAC and palettes after the driver's sequence) |
| VBE-45 | BIOS data after 4F02h of a listed mode: 0040:0049h = the mode's 7-bit S3 number (S3M-1), so that AH=0Fh returns a number with which AH=00h sets the mode again; 0040:004Ah = XResolution / 8; 0040:0084h = YResolution / YCharSize - 1; 0040:0085h = YCharSize; 0040:004Eh = 0; cursor positions 0040:0050h-005Fh = 0; 0040:0062h = 0; 0040:0063h = 3D4h; INT 43h points to the ROM font of YCharSize (8x16 or 8x8); 0040:0087h bit 7 = BX bit 15 (VBE-43). The VESA mode number itself is kept where 4F03h finds it (VBE-46) | VBE12 3 ("VESA recommends that whatever value returned by VGA BIOS function 0Fh ... should be used to reinitialize the video mode through VGA BIOS function 00h"); bios-rules B00-16, B00-17, B00-19, BDA-12, BDA-13 | should (VBE12 says "recommends"), must for 0087h bit 7 | S3COMPAT 'AH=00 nnh = VESA nnnn' lines (fail 1 AH=0Fh or 40:49 mode number wrong); not checked otherwise: a test reading these BIOS data after 4F02h 101h and 103h |
| VBE-46 | The BIOS keeps the 15-bit number of the last mode set (bit 15 cleared) in its BIOS data, part of the BIOS data state of 4F04h (VBE-73) | VBE12 6.5; VBE12 3 ("the BIOS should keep track of the last Super VGA mode in effect") | must | S3COMPAT '4F04 save/restore round trip' (fail 8 mode not 101h after the restore) |
| VBE-47 | 4F02h sets the mode whatever mode was current before (a standard mode, another VESA mode, the same mode); the result does not depend on the previous mode | bios-rules B00-22 | must | S3COMPAT pass 2 ('Mode nnh' after VESA modes); S3COMPAT 'VESA nnnn' lines run in list order |

### INT 10h AX=4F03h: return current video mode

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| VBE-48 | Output AX = 004Fh, BX = the current mode: the 15-bit VESA number after 4F02h of a listed mode or after AH=00h with an S3 number that has a VESA number (S3M-1); 00xxh (xxh = 0040:0049h, bit 7 clear) after a standard mode or an S3 number without a VESA number. Bit 15 (no clear) is never returned, even when the mode was set with it. Every register other than AX and BX as given | VBE12 6.5 and its notes ("the memory clear bit will not be returned in BX"); VBE12 7 step 4 ("If a non-VESA ... mode is in effect, only the lower byte in the mode number is filled. The upper byte is cleared") | must | S3COMPAT '4F02 clear / D15 keep memory' (prints 4F03 after 8101h); S3COMPAT 'VBE undefined functions' (fail 2); S3TEST 'VBE  4F03 in boosted 101h (0101)' |

### INT 10h AX=4F04h: save/restore Super VGA video state

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| VBE-70 | Input DL = 00h size, 01h save, 02h restore; CX = state mask (bits 3-0); ES:BX = buffer for DL = 01h and 02h. DL = 03h-FFh: 014Fh, nothing changed. CX with a bit of 15-4 set: 014Fh (see open question 8 for CX = 0) | VBE12 6.6 | must (DL), should (CX bits 15-4) | S3COMPAT '4F04 state masks' (fail 40 DL = 3 accepted) |
| VBE-71 | DL = 00h: AX = 004Fh, BX = the number of 64-byte blocks the save of the classes in CX needs, every other register as given. Each single class needs at least one block, and no single class more than CX = 000Fh | VBE12 6.6 ("Number of 64-byte blocks to hold the state buffer") | must | S3COMPAT '4F04 state buffer size' (fail 1); S3COMPAT '4F04 state masks' (fail 1: a single class 0 blocks or more than all four) |
| VBE-72 | DL = 01h saves the classes of CX at ES:BX, writing no more than BX x 64 bytes as DL = 00h gave for the same CX; DL = 02h restores them from a buffer saved with the same CX by this BIOS. Both return AX = 004Fh and every other register as given (BX is an input here and is kept). The layout of the buffer is the BIOS's own (bios-rules B1C-6) | VBE12 6.6 | must | S3COMPAT '4F04 save/restore round trip' (fail 1) |
| VBE-73 | The classes: D0 hardware state = the standard VGA registers, the same content as AH=1Ch class bit 0 (bios-rules B1C-2: MISC, feature control, SR01-SR04, CR00-CR18, AR00-AR14, GR00-GR08, the indexes, the CRTC base, the latches); D1 BIOS data state = the BIOS data of AH=1Ch class bit 1 (bios-rules B1C-4) plus the VESA mode number of VBE-46; D2 DAC state = as AH=1Ch class bit 2 (bios-rules B1C-5); D3 Super VGA state = the S3 registers of VBE-74. No S3 register is in D0: AH=1Ch must stay IBM-compatible and holds none, and 4F04h is "a superset" of it | VBE12 6.6 and its notes ("function 1Ch ... has not been extended to save the Super VGA video state ... no room for the Super VGA state"; "The complete Super VGA video state (except video memory) should be saveable/restoreable by setting ... 000Fh"); bios-rules B1C-2, B1C-4, B1C-5 | must (CX = 000Fh restores everything), should (the split) | S3COMPAT '4F04 state masks' (fail 2 mask 4 DAC entry 7, 4 mask 2 cursor position, 8 mask 1 display start CR0C/CR0D, 10h the DAC-only restore changed the display start, 20h mask 8 failed); S3COMPAT '4F04 save/restore round trip' (fail 2 registers, 4 DAC, 8 mode) |
| VBE-74 | D3 holds at least the S3 registers a VESA mode set and functions 4F05h-4F07h program: CR31, CR32, CR33, CR34, CR35, CR3A, CR3B, CR3C, CR40 bit 0, CR42, CR43, CR45-CR4F (hardware cursor), CR50, CR51, CR53, CR54, CR55, CR58, CR5D, CR5E, CR60, CR67, CR69, CR6A; SRB, SR12, SR13, SR15, SR18; and the Advanced Function Control register 4AE8h (bits 0, 2, 4, 5). It holds none of: the lock registers (SR08, CR38, CR39: left as found, VBE-5), the strapping registers CR36, CR37, CR68, the PCI base CR59/CR5A (written at POST only, through read-modify-write, T64-REG-2), CR6B/CR6C, SRA (memory configuration set at POST, T64-MEM-3), the MCLK (SR10, SR11), the graphics engine | T32/64 register descriptions (sections 14-18), 11.4.2 table 11-3 (the registers of a mode's bitmap), 9.2 (clock loading); chip-rules T64-REG-1, T64-REG-2, T64-MEM-5, T64-MEM-6 | must (the registers S3COMPAT compares), should (the rest of the list) | S3COMPAT '4F04 save/restore round trip' (compares MISC, SR01-04, CR00-18, CR31, 3A, 3B, 3C, 42, 43, 50, 51, 54, 5D, 5E, 60, 67, 69, SR12, SR13, SR15, SR18, GR05, GR06, AR10 after save in 101h, mode 03h, restore) |
| VBE-75 | The restore of D3 follows the data book's write rules: the DCLK through SR12/SR13 with the load sequence (T64-PLL-1, REG-1: SR15 bit 5 never left 1), CR54/CR60 with the screen off (T64-MEM-1), CR3B only with CR34 bit 4 (T64-MEM-2), CR40 bit 0 by read-modify-write; the S3 locks are opened for the restore and put back as found | chip-rules T64-PLL-1, REG-1, T64-MEM-1, T64-MEM-2, T64-REG-1 | must | S3COMPAT 'VESA nnnn' rules (fail 1000 SR15 bit 5) are not run after 4F04h; not checked: run S3COMPAT's regchk after a 4F04h restore |

### INT 10h AX=4F05h: CPU video memory window control, and the window function

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| VBE-50 | Input BH = 00h set, 01h get; BL = window number; DX = window position in granularity units (64 KB) for the set. Only window A exists: BL = 00h. BL other than 00h, or BH other than 00h/01h: AX = 014Fh, nothing changed | VBE12 6.7; VBE-32 (no window B) | must (BH), should (BL = 01h refused) | S3COMPAT 'VBE invalid subfunctions refused' (fail 1: 4F05h BH = 02h); emu t64_patches (BH = 2 refused); BL = 01h not checked: a test calling 4F05h BX = 0001h and comparing CR6A |
| VBE-51 | Set (BH = 00h), packed and direct modes: DX = the 64 KB page of video memory that appears at A000:0000h; valid DX = 0 to TotalMemory - 1; CR6A bits 5-0 = DX, CR6A bits 7-6 kept (reserved). Output AX = 004Fh, every other register as given (the INT 10h form) | VBE12 5.1.1, 6.7; T32/64 CR6A ("upper 6 bits (19-14) of the CPU base address ... up to 4 MBytes of display memory via 64K pages"; "Bit 0 of CR31 must be set to 1") | must | S3COMPAT '4F05 bank set/get + WinFuncPtr' (fail 1 get bank); S3TEST 'VBE  4F05 set bank 3 / get (004F 0003)'; S3TEST 'VBE  4F05 regs, SR index, CR6A, planar, LFB' (CR6A, registers kept); emu t64_patches |
| VBE-52 | Set, planar modes (102h, 104h): a 64 KB step of the CPU window is 64 KB of each plane, 256 KB of video memory, so CR6A bits 5-0 = 4 x DX; valid DX = 0 to TotalMemory / 4 - 1 | T32/64 CR6A (64K pages of display memory); VGA planar addressing (one CPU byte address = one byte in each of 4 planes: T32/64 section 13, standard VGA mapping); derived | should | S3TEST 'VBE  4F05 regs, SR index, CR6A, planar, LFB' (planar 102h bank x 4 in CR6A, on our ROMs) |
| VBE-53 | Because a zero CR6A field hands the CPU base address back to CR35 bits 3-0 and CR51 bits 3-2, those old fields are 0 in every VESA mode (VBE-44) and 4F05h never sets them to anything else, so DX = 0 maps the first 64 KB | T32/64 CR6A ("When a non-zero value is programmed in this field, bits 3-0 of CR35 and 3-2 of CR51 ... are ignored"), CR35, CR51 bits 3-2 | must | not checked: a test that sets CR35 to 05h by hand before 4F02h and checks that bank 0 after 4F02h is CR35 = 0 |
| VBE-54 | DX above the valid range (VBE-51, VBE-52): AX = 014Fh, CR6A unchanged (see open question 9 for the far call) | VBE12 6.7 (window position in video memory); VBE-2 | should | not checked: a test of 4F05h DX = TotalMemory with 1, 2 and 4 MB |
| VBE-55 | Get (BH = 01h): AX = 004Fh, DX = the current window position in granularity units, read from CR6A bits 5-0 (divided by 4 in the planar modes), so a bank set through the window function or by the program itself is reported; every register other than AX and DX as given | VBE12 6.7 | must | S3COMPAT '4F05 bank set/get + WinFuncPtr' (fail 1, 8: get after the far call; the get starts with DX = FFFFh) |
| VBE-56 | The window function (WinFuncPtr, VBE-37) is called with a far CALL and returns with a far RET (RETF), with BH, BL, DX as for 4F05h (AH, AL need not be loaded). It does what 4F05h BH = 00h/01h does. Registers: AX and DX may be changed (VBE 1.2 callers expect them destroyed; returning the status in AX as 4F05h does is allowed), DX holds the position after a get; BX, CX, SI, DI, BP, DS, ES and the upper halves of the 32-bit registers are kept; the 3C4h index and the S3 locks as found (VBE-5). It runs with any DS and ES, does not change IF, uses only a few words of the caller's stack, and calls no INT | VBE12 6.7 notes ("In the far call version, no status information is returned ... the AX and DX registers will be destroyed"; "does not need to load either AH or AL"); VBE20 4.8 note; AGENTS (index rule) | must | S3COMPAT '4F05 bank set/get + WinFuncPtr' (fail 4 far call does not switch, 8 get after the far call); emu t64_patches (window function in mode 69h) |
| VBE-57 | 4F05h and the window function work in every listed mode that fits; called in a standard mode they refuse (VBE-6). The window function, called in a standard mode, changes nothing | VBE12 6.3 (window fields only for listed modes); VBE-6 | should | not checked (as VBE-6) |

### INT 10h AX=4F06h: set/get logical scan line length

Registers (T32/64 11.4.1 "Offset", table 11-3; CR13, CR43, CR51): the line offset is a 10-bit value,
CR13 bits 7-0 with CR51 bits 5-4 as bits 9-8 (CR43 bit 2 is an older bit 8, ignored when CR51 bits
5-4 are not 00b); the distance in bytes between two lines is the offset times 8 in the enhanced
(doubleword) mapping of the packed and direct modes (CR31 bit 3 = 1) and times 2 in the byte mode of
the planar modes (as in mode 12h).

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| VBE-60 | BL = 01h get: AX = 004Fh, BX = bytes per scan line (from the registers), CX = BX / Bpp in the packed and direct modes, BX x 8 in the planar modes, DX = plane memory / BX rounded down (the logical lines that fit). Right after 4F02h these are the table's BytesPerScanLine, XResolution, and M / BytesPerScanLine | VBE12 6.8; T32/64 11.4.1 (Offset x 2, 4 or 8) | must | S3COMPAT 'VESA nnnn' (fail 40: 4F06h BL = 1 pitch differs from 4F01h) |
| VBE-61 | BL = 00h set, CX = desired pixels per line: the BIOS takes the smallest line that holds max(CX, XResolution) pixels on the hardware's step: packed and direct: bytes = max(CX, XRes) x Bpp rounded up to a multiple of 8, offset = bytes / 8 (CR13 = offset bits 7-0, CR51 bits 5-4 = offset bits 9-8, CR43 bit 2 = 0); planar: bytes = max(CX, XRes) / 8 rounded up to a multiple of 2, offset = bytes / 2. Output as BL = 01h (BX, CX = the actual pixels per line, which may be more than asked, DX). Only CR13, CR51 bits 5-4 and CR43 bit 2 change; the display start registers and every other register stay as they were | VBE12 6.8 notes ("The next larger value will be selected that will accommodate the desired number of pixels, and the actual number of pixels will be returned in CX"); T32/64 CR13, CR43 bit 2, CR51 bits 5-4, 11.4.2 table 11-3 | must | S3COMPAT '4F06 logical width 1024/2048/max' (fail 1: set 1024 in 101h gives BX = CX = 1024, DX >= 480, and the CR13/CR51 pitch 1024) |
| VBE-62 | The largest line: offset 3FFh, that is 8184 bytes in the packed and direct modes and 2046 bytes (16368 pixels) in the planar modes. A CX whose line would be longer gives AX = 014Fh and no change. A line whose YResolution lines do not fit the plane memory (BX x YResolution > plane memory) is refused the same way, so DX >= YResolution after every successful set | T32/64 CR13 with CR51 bits 5-4 (10 bits); VBE12 6.8 (DX "based upon the new scan line length and the total memory installed"); VBE20 4.9 (too large: a failure) | must (8184), should (the memory refusal) | emu t_errors ('4F06 CX=FFF8h': BX x DX within the memory when accepted); S3COMPAT '4F06 logical width' (DX >= 480) |
| VBE-63 | BL = 02h and 03h (VBE 2.0: set in bytes, get maximum) and BL = 04h-FFh: AX = 014Fh, nothing changed | VBE12 6.8 (only 00h, 01h); VBE20 4.9 (02h, 03h are 2.0) | should | S3COMPAT 'VBE invalid subfunctions refused' (fail 10: 4F06h BL = 4); S3COMPAT '4F06 logical width' prints 'BL=2/3 not in VBE 1.x' on a 1.x BIOS |

### INT 10h AX=4F07h: set/get display start

Registers (T32/64 CR0C, CR0D, CR31 bits 5-4, CR51 bits 1-0, CR69): the display start address is 20
bits, CR0C (bits 15-8) and CR0D (bits 7-0) with CR69 bits 3-0 as bits 19-16 (CR31 bits 5-4 and CR51
bits 1-0 are older forms of bits 17-16 and 19-18, ignored while CR69 bits 3-0 are not 0). Its unit is
4 bytes in the packed and direct modes (doubleword mode, CR31 bit 3 = 1) and 1 byte of each plane in
the planar modes (byte mode).

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| VBE-64 | BL = 00h set, CX = first pixel of the line, DX = first line (zero-based): byte offset = DX x BytesPerScanLine (the current one, VBE-60) + CX x Bpp in the packed and direct modes, + CX / 8 in the planar modes; start = offset / 4 (packed, direct) or offset (planar), rounded down; CR0C = start bits 15-8, CR0D = start bits 7-0, CR69 bits 3-0 = start bits 19-16, CR31 bits 5-4 = 0, CR51 bits 1-0 = 0 (so a start below 64K units is not taken from stale old fields). So the horizontal step is 4 pixels at 8 bpp, 2 at 15/16 bpp, 1 at 32 bpp and 8 in the planar modes; the attribute controller's pixel panning (AR13) stays 0 (open question 10). Output AX = 004Fh, every other register as given. BH is reserved: the BIOS does not judge it | VBE12 6.9; T32/64 CR0C/CR0D (standard), CR31 bits 5-4, CR51 bits 1-0, CR69 ("When a non-zero value is programmed in this field, bits 5-4 of CR31 and 1-0 of CR51 ... are ignored"), 11.4.2 table 11-3 (CR31 bit 3 doubleword mode) | must | S3COMPAT '4F07 start incl. CR69 above 256K' (CR0C/CR0D/CR69 hold (y x 640 + x) / 4 at (8, 100) and (0, 3000) in 101h; fail 1); S3COMPAT 'VESA nnnn' (fail 80 4F07 get/set) |
| VBE-65 | The set is refused (AX = 014Fh, no change) when the start does not fit the 20-bit register: offset / 4 above FFFFFh in the packed and direct modes, offset above FFFFFh in the planar modes. A start inside the register range but at or beyond the end of the installed memory is accepted in this version (the display wraps or shows undefined memory); whether to refuse it is open question 11 | T32/64 CR69 (20 bits, "up to 4 MBytes"); VBE12 6.9 (no limit given); VBE20 4.10 note (fail when the start is not available) | must (register range), note (memory) | S3COMPAT '4F07 start' (y = 3000 in 101h, offset 1.92 MB, must be accepted with 1, 2 and 4 MB; on 1 MB it is beyond memory but inside the register range); not checked: a refusal test with y = 8000h in 112h |
| VBE-66 | The set takes effect at the next frame; the BIOS does not wait for the vertical retrace (waiting is the VBE 2.0 BL = 80h; see open question 12 for BL = 80h on this BIOS) | VBE12 6.9 (no retrace option); VBE20 4.10, Haakenson (BL = 80h new in 2.0) | note | S3COMPAT '4F07 start' tests BL = 80h only from VBE 2.0 on |
| VBE-67 | BL = 01h get: AX = 004Fh, BH = 00h, and CX, DX from the registers: offset = start x 4 (packed, direct) or start (planar), with start taken from CR69 bits 3-0 when not 0, else from CR31 bits 5-4 and CR51 bits 1-0; DX = offset / BytesPerScanLine, CX = (offset mod BytesPerScanLine) / Bpp (packed, direct) or x 8 (planar). So the get returns the start as the hardware has it, the requested CX rounded down to the step of VBE-64 | VBE12 6.9 ("BH = 00h Reserved and will be 0") | must | S3COMPAT '4F07 start' (fail 1: the get after the set returns x and y; it starts with CX = DX = FFFFh) |
| VBE-68 | BL other than 00h, 01h (and 80h, open question 12): AX = 014Fh, nothing changed | VBE12 6.9 | must | S3COMPAT 'VBE invalid subfunctions refused' (fail 20: 4F07h BL = 2) |

### INT 10h AX=4F08h: set/get DAC palette control

The Trio64's RAMDAC has three LUTs of 256 6-bit words feeding 8-bit DACs, and the palette ports
(3C7h-3C9h) carry 6 bits per primary; no register selects an 8-bit LUT (T32/64 section 8, figure 8-1,
14.7 3C7h/3C8h/3C9h, SR18, CR55: none has a width bit; table 4-3's 8 bits are the DAC converters,
used by the LUT bypass of the direct colour modes).

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| VBE-80 | BL = 00h set, BH = desired bits per primary: the width stays 6 whatever BH asks (8 is not available; the next lower available value is 6, and nothing below 6 exists); output AX = 004Fh, BH = 06h. Nothing in the hardware changes | VBE12 6.10 notes ("If the Super VGA is not capable of selecting the requested palette width, then the next lower value that the Super VGA is capable of will be selected. The resulting palette width is returned"); T32/64 section 8, 14.7 | must (BH = 6 returned, never 8) | S3COMPAT '4F08 DAC width (6 bit hardware)' (fail 1 claims 8 bits or reports other than 6); S3COMPAT '4F00 capabilities vs 4F08' (fail 1: AH = 0 with BH = 8 while D0 = 0); emu t_windows (S3's Windows 9x driver sets 8 bits, then mode 03h has a 6-bit DAC) |
| VBE-81 | BL = 01h get: AX = 004Fh, BH = 06h | VBE12 6.10 | must | S3COMPAT '4F08 DAC width (6 bit hardware)' |
| VBE-82 | The answers of VBE-80 and VBE-81 are the same in every mode (standard, packed, direct, planar): 1.2 has no "invalid in this mode" code (the VBE 2.0 AH = 03h in direct colour modes is not used) | VBE12 6.10; VBE-1 | should | not checked: 4F08h in 111h and 03h compared with 101h |
| VBE-83 | BL = 02h-FFh: AX = 014Fh, BH unchanged | VBE12 6.10 | must | S3COMPAT 'VBE invalid subfunctions refused' (fail 40: 4F08h BL = 2) |

## S3 mode numbers through INT 10h AH=00h

VBE 1.2 asks for a 7-bit number per Super VGA mode (VBE12 3: AH=0Fh must return a number that AH=00h
can set again). No public S3 document gives the numbers (README "Missing documents"). Two S3
numberings are known from BIOS images (README, S3ALIAS header): the older one that Pinball
Illusions' S3 driver uses, and the one of S3's 2.04 BIOSes, where 49h and 4Bh are other modes.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| S3M-1 | Every listed VESA mode has a 7-bit number in 14h-7Fh. INT 10h AH=00h with that number in AL bits 6-0 sets the same mode as 4F02h with the VESA number (registers, memory, DAC, BIOS data, VBE-43 to VBE-45); AL bit 7 = 1 keeps video memory and sets 0040:0087h bit 7 (bios-rules B00-4). Afterwards 0040:0049h holds the number, AH=0Fh returns it (with bit 7 as 0040:0087h bit 7, bios-rules B0F-1), and 4F03h returns the VESA number | VBE12 3; bios-rules B00-4, B0F-1 | must (VBE12 3 as this BIOS's choice) | S3COMPAT 'AH=00 nnh = VESA nnnn' lines (fail 1 AH=0Fh or 40:49 wrong, 2 registers differ from the 4F02h set, 4 first/last byte through the window), INFO on a chip other than the Trio64V2 when its table differs |
| S3M-2 | 49h sets 640x480 in 256 colours (VESA 101h) and 4Bh sets 800x600 in 256 colours (VESA 103h): Pinball Illusions' S3 driver sets its tables with these numbers through AH=00h | README (S3ALIAS.COM: "sets 640x480x256 with INT 10h AH=00 mode 49h and 800x600x256 with mode 4Bh, the numbers of an older S3 BIOS") | observed | emu t_s3alias checks the TSR's mapping, not the ROM; not checked: a test of AH=00h 49h and 4Bh against 4F02h 101h and 103h (S3COMPAT 'AH=00 nnh' with this BIOS's table) |
| S3M-3 | An S3 number whose mode does not fit the memory (VBE-11) is treated as an unsupported mode number: nothing changes (bios-rules B00-23, emu t_errors) | VBE-12; bios-rules B00-23 | should | emu t_errors (invalid mode numbers keep the video state) |
| S3M-4 | 4F02h with BX = the S3 number (BH = 0) sets the mode as AH=00h does (VBE-42) | VBE12 4 ("OEM-defined modes may be initialized in the same way") | must | not checked: 4F02h 0049h against AH=00h 49h |
| S3M-5 | The numbers of the other listed modes, and whether 49h and 4Bh are their only numbers or a second number each (one number per mode is enough for VBE12 3), are open question 13 | VBE12 3 (the number is "up to the OEM") | note | - |
| S3M-6 | The 7-bit numbers 00h-13h are the standard modes; 14h-7Fh numbers not given to a mode are unsupported (bios-rules B00-23) | VBE12 4 ("OEMs have defined extended video modes in the range 14h to 7Fh"); bios-rules MODE-1, B00-23 | must | emu t_errors (AL = 14h-18h, 1Bh, 1Fh, 20h, 60h, 7Fh: no change); the numbers given to modes must avoid those the test uses, or the test changes |

## S3 OEM functions (INT 10h AX=4F14h)

No S3 document on 4F14h is at hand; the behaviour below is that of the S3 BIOSes 2.04.07 and 2.04.11
for the Trio64V2, observed in the emulator and recorded in `docs/chip-rules.md` "S3 OEM functions
(4F14h)" (OEM-1 to OEM-6 there). Every rule here is derived from that observed behaviour. None of the
Trio64 BIOSes examined there offers 4F14h.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| OEM-1 | First version: 4F14h is not offered. Every AX = 4F14h call returns AL other than 4Fh and changes nothing (VBE-3) | `docs/clean-room.md` "Scope" (VBE 1.2 at most); chip-rules "S3 OEM functions" (no Trio64 BIOS has 4F14h) | should | S3COMPAT '4F14 S3 OEM functions' (INFO "not offered"); emu s3compat_vbe accepts INFO on a ROM that is not ours |
| OEM-2 | When offered (second step): BL = 00h, BH = 00h, query: AX = 004Fh, BX = version of the OEM functions (value open question 14), CX = 0003h, SI = TotalMemory (VBE-26), DI = the PCI device ID (8811h on the Trio64, T64-ID-1) | chip-rules OEM-1 (observed: BX 0010h or 0411h, CX 0003h, SI, DI = 8901h on the V2); T64-ID-1 | observed | S3COMPAT '4F14 S3 OEM functions' (fail 1: AX, DI = PCI device ID, SI = 4F00h's memory) |
| OEM-3 | BL = 01h, BH = 00h, set refresh: CX = a listed mode, DI = a rate in Hz from that mode's list (OEM-5): AX = 004Fh; the next set of that mode (4F02h or AH=00h) runs at that rate. The current mode is not changed by the call | chip-rules OEM-2 (observed) | observed | S3COMPAT '4F14 S3 OEM functions' (fail 8, 10 the rate measured after the mode set, 20 the start rates written back) |
| OEM-4 | BL = 01h, BH = 01h, get refresh: CX = a listed mode: AX = 004Fh, DI = the rate the next set of that mode uses | chip-rules OEM-3 (observed) | observed | S3COMPAT '4F14 S3 OEM functions' (fail 8) |
| OEM-5 | BL = 01h, BH = 02h, list refresh: CX = a listed mode, DX = index (0 first): AX = 004Fh, DI = the rate in Hz of that entry, DX = the next index, 0 after the last entry. Every rate listed is one the BIOS can set for the mode (its timing: item 2, 60 Hz or more, within the clock limits CLK-1 and the PLL rules PLL-1, PLL-2) | chip-rules OEM-4 (observed); CLK-1, PLL-1, PLL-2 | observed (interface), must (every listed rate within the data book limits) | S3COMPAT '4F14 S3 OEM functions' (fail 8); S3COMPAT 'DCLK VCO at every refresh rate' (`tvco`: every listed rate set and its PLL checked) |
| OEM-6 | BL = 02h, BH = 02h, mode list: DX = index (0 first): AX = 004Fh, CX = a mode, DX = the next index, 0 after the last. The modes are those of the 4F00h list that 4F01h marks as fitting (D0 = 1), in the list's order | chip-rules OEM-5 (observed) | observed | S3COMPAT '4F14 S3 OEM functions' (fail 2) |
| OEM-7 | BL = 02h, BH = 03h, mode information: CX = a listed mode: AX = 004Fh, EDI = XResolution x 65536 + YResolution, SI bits 7-0 = BitsPerPixel, both as 4F01h gives them | chip-rules OEM-6 (observed) | observed | S3COMPAT '4F14 S3 OEM functions' (fail 4) |
| OEM-8 | Refusals: BL = 03h-FFh, a BH not listed above for its BL, a CX that is no listed mode, a DI rate not in the mode's list (for example 59 Hz, 0 Hz, 100 Hz for 103h): AX = 014Fh, and the stored refresh choices (and every register) unchanged | chip-rules "S3 OEM functions" (014Fh "for a failed or unknown subfunction"); VBE-2 | observed (code), must (no change) | emu t_errors (4F14h refusals: BX = 0001h with DI = 59 and 0, 103h at 100 Hz, BX = 0301h, 0801h, 0008h, 000Fh, CX = 0177h; CR41/CR52/CR6B unchanged) |
| OEM-9 | Where the refresh choice is kept is a convention of this BIOS (plan item 4): on the Trio64 it is never kept in CR6B, whose bit 7 and bits 1-0 have hardware meanings, nor in CR6C or CR6D | chip-rules T64-MEM-6, "Datasheet errors" (CR6B); AGENTS ("Do not keep marks in CR6B-CR6D": CR6D is no Trio64 register) | must | emu t_errors watches CR41/CR52/CR6B on refusals; not checked otherwise |
| OEM-10 | Registers: as every VBE function (general rule); outputs only those named per subfunction (EDI as a whole is an output of BH = 03h only) | VBE12 6 (all other registers preserved); chip-rules "S3 OEM functions" | observed | emu t_windows style test with garbage in the upper halves; not checked for 4F14h |

## Open questions

1. VESA text modes 108h-10Ch (80x60, 132x25/43/50/60): VBE 1.2 defines them and a Trio64 BIOS may offer
   them (the S3 132-column modes). The first version's scope (`docs/seavgabios-trio64.md` item 3) names
   the packed modes only. Are 109h and 10Ah wanted (CRTC from the 132-column VGA timing, 9-dot or
   8-dot cells, B800h window, 4F01h memory model 00h with WinGranularity/WinSize 32 KB)? Which
   character height and refresh?
   A client that uses them: FreeDOS MODE (`MODE CON COLS=132`) walks the 4F00h list, takes the
   modes whose 4F01h attributes say supported text mode, matches XResolution/YResolution as columns
   and rows, and sets the mode with 4F02h; without 108h-10Ch it cannot give 132 columns.
   Decided by the FreeDOS 1.4 target (1 November 2026): the text modes MODE reaches are required,
   109h-10Ch and 108h (`docs/cleanroom/freedos-1.4.md` FD-14, FD-15, and the open question there on
   the number 0449h holds in them).
2. 320x200 direct colour 10Dh-10Fh: VBE 1.2 modes that need a double-scanned 70 Hz timing with a
   12.59 MHz pixel clock, below the lowest PLL output (135 MHz / 8 = 16.9 MHz, PLL-1, PLL-2), so only
   with the dot clock halved from 25.175 MHz (SR01 bit 3) in an enhanced mode, which the data book does
   not describe (`spec-b-modeset.md` MODE-102 and MQ-9 leave them out). Wanted, if the card shows the
   halved clock works?
3. OEM string wording (VBE-23): the project's own text. Does any driver or program match the OEM string
   (for example on "S3" or "Trio64") to pick its Trio64 code path? If one does, the string must contain
   that word; the README's Windows 9x driver findings say nothing about it.
4. NumberOfImagePages in the planar modes (VBE-34): this specification counts M / 4 bytes per plane
   (102h: 3, 7, 16 pages with 1, 2, 4 MB). Can the Trio64's planar modes reach video memory above
   256 KB per plane through CR6A (VBE-52) and the display start (VBE-64)? Check on the card with
   VSHOW in 102h after 4F05h DX = 4 and 4F07h past 256 KB per plane; until then a BIOS may report the
   pages of 256 KB per plane (3 in 102h, 1 in 104h).
5. 4F02h with BH = 0 and BL bit 7 set (0083h, 00E9h): AH=00h semantics (mode BL & 7Fh without the
   clear) or a refusal? Haakenson reports that some 1.2 programs used bit 7 as the no-clear flag.
6. 4F02h with bit 14 set (4101h, C101h): reserved in 1.2 and refused here (VBE-41). Windows 98's
   driver brought DOS boxes back with 4F02h C101h on the Trio64V2's VBE 2.0 BIOS (README); does it do
   so on a VBE 1.2 BIOS, where 4F01h offers no linear buffer? A VGALOG /M log of Windows 98 on the
   Trio64 card with this ROM decides it.
7. 4F05h-4F07h in the standard modes 00h-13h (VBE-6): VBE 1.2 says 4F06h and 4F07h "are also valid in
   text modes", which may mean VESA text modes only. Refuse (this specification) or support them on
   the VGA registers (SeaVGABIOS does, through its stdvga line length and display start)? With
   support, the text mode units: 4F06h CX in pixels = columns x character width; 4F07h DX in pixel
   lines = rows x character height (the start address counts characters).
8. 4F04h with CX = 0 (no class): 004Fh with BX = 0 (or the size of a header only), or 014Fh? VBE 1.2 does
   not say.
9. The window function cannot report an error (VBE 1.2 far call): with DX out of range, does it leave
   CR6A as it is, or take DX modulo the memory? This specification leaves CR6A unchanged.
10. 4F07h pixel step: the attribute controller's horizontal pixel panning (AR13) could give a one-pixel
    step at 8 and 15/16 bpp in the enhanced modes; does it act there on the Trio64 (the data book
    describes AR13 only for VGA modes)? If yes, should 4F07h use it (VBE 1.2 does not ask for it)?
11. 4F07h start near the end of memory: refuse when the displayed page (YResolution lines) does not fit
    between the start and the end of memory (as VBE 2.0 4.10 advises, "does not allow for a full
    page"), or accept as long as the start itself is inside memory? S3COMPAT's '4F07 start' sets
    y = 3000 in 101h (1.92 MB) and expects success also on 1 MB cards; refusing full pages beyond
    memory would need that test changed for 1 MB. Does the Trio64 wrap the display address at the end
    of memory?
12. 4F07h BL = 80h (VBE 2.0: set during vertical retrace): refuse on this 1.2 BIOS (VBE-68), or accept as
    BL = 00h with a wait for the retrace, for 2.0 programs that do not check the version?
13. The S3 numbers of the listed modes other than 101h and 103h (S3M-5), and of S3's 2xxh VESA-range
    numbers used by S3 drivers: S3's Windows 9x driver set 207h (1152x864x8) through 4F02h on the
    Trio64V2 (README "Windows 9x driver test"). Which numbers, which resolutions, and is 1152x864 at
    60 Hz (GTF, not in DMT 1.0) wanted? The reference's numbering is in the oracle file; the leak review
    decides whether it may cross the wall as observed behaviour (as the 4F14h rules do).
14. 4F14h query version (OEM-2): the S3 2.04 BIOSes return 0010h (2.04.07) or 0411h (2.04.11). Which
    version should a Trio64 BIOS report so that a program that checks it accepts the functions, and is
    CX = 0003h a count or a mask of the BL values?
15. Should 4F02h refuse a listed mode whose picture fits but whose pixel clock at the selected refresh
    (OEM-3) exceeds CLK-1? With only 60 Hz entries (item 2) every listed mode fits CLK-1; the question
    arises with higher rates.

## Sources disagree

- **BitsPerPixel of the 1:5:5:5 modes.** VBE12 6.3 says "BitsPerPixel is always defined to be the total
  memory size of the pixel, in bits" (that would be 16), while its own mode table calls 110h "32K
  (1:5:5:5)" and VBE implementations and the project's tests use 15 (S3COMPAT 'VESA nnnn' fail 4
  compares the sum of the red, green and blue mask sizes with BitsPerPixel). VBE-31 and the mode
  table follow 15; the 32-bit modes give 32 (the total size), as both readings agree there.
- **RsvdFieldPosition.** The retyped VBE 1.2 ModeInfoBlock listing has no RsvdFieldPosition, but its
  text describes the field; VGADOC VESA.TXT and VBE20 put it at offset 26h, and only with it do the
  fields and the 216 reserved bytes add up to 256. The table above follows VBE20 and VGADOC.
- **Subfunction range.** VBE12 6 says VS900602 defines subfunctions 00h-07h and "08h through 0FFh are
  reserved", while 6.10 of the same document defines 08h. 08h is a 1.2 function (VBE-80).
- **Error codes.** VBE12 6.1 defines AH = 00h and 01h; VBE20 4.1 adds 02h (not supported in the current
  hardware configuration, for example 4F06h too large) and 03h (invalid in the current video mode,
  for example 4F08h in a direct colour mode, 4F05h in a linear mode). This 1.2 BIOS uses 01h for all
  (VBE-1); SeaVGABIOS's vbe.c returns 034Fh in some of these cases and must be changed.
- **Display start not available.** VBE12 6.9 says nothing; VBE20 4.10 says to fail and make no change.
  VBE-64 rounds the pixel down to the hardware's step (accepting the call), VBE-65 refuses only what
  the registers or the memory cannot hold.
- **4F08h below 6 bits.** VBE12 6.10 selects "the next lower value that the Super VGA is capable of";
  for a request below 6 there is none. VBE-80 returns 6.
- **CR35 units.** T32/64 CR35 calls bits 3-0 "CPU Base Address bits 17-14" and says they "define the CPU
  address base in 64 KByte units"; CR6A gives its bits as 19-14 "via 64K pages". This specification
  uses CR6A and keeps CR35 bits 3-0 at 0 (VBE-53), so the units of CR35 do not matter.
- **The no-clear bit.** VBE12 4 and 6.4 use bit 15; Haakenson reports 1.2 programs that used bit 7.
  VBE-40 follows the standard; bit 7 with BH = 0 is open question 5.

## What changes in SeaVGABIOS's vbe.c (for the clean side)

Behaviour differences between SeaVGABIOS's VBE (branch `claude/slim-vgabios`, public LGPLv3 code) and
this part, so the clean side knows what to change: 4F00h reports 0300h (VBE-22: 0102h), writes the
VBE 2.0 strings and 512 bytes for a 'VBE2' caller (VBE-21) and builds the mode list in the caller's
Reserved field (VBE-25); 4F01h sets ModeAttributes bit 5 "not VGA compatible" (VBE-31: reserved in
1.2), WinBSegment 0 (as here), computes the image pages with 64 KB rounding (VBE-34), sets
DirectColorModeInfo bit 1 in 32-bit modes (VBE-36); 4F05h, 4F06h, 4F08h, 4F09h return 034Fh in some
cases (VBE-1); 4F06h accepts BL = 02h (VBE-63) and 4F07h BL = 80h (VBE-68, open question 12); 4F04h
already refuses CX bits 15-4 and DL above 2 (VBE-70).
