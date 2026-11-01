# Standard video BIOS: behaviour rules (CGA, EGA, VGA functions of INT 10h)

This file describes what a VGA-compatible video BIOS must do, function by function, as behaviour a
caller can observe: registers in and out, flags, the BIOS data area, video memory, the I/O port state
and the interrupt vectors. It covers the IBM-compatible part of our ROMs, INT 10h AH=00h-1Ch, the BIOS
data area and the tables a VGA BIOS publishes; no VBE and no S3 registers (those are in
`docs/chip-rules.md`). Like chip-rules.md it is meant as part of a clean-room specification
(`docs/clean-room.md`): someone who has never seen a BIOS image or BIOS source should be able to
write a compatible BIOS from it.

## Conventions

- **Sources.** Every rule rests on a public source: Ferraro (R. Ferraro, Programmer's Guide to the
  EGA, VGA and Super VGA Cards, 3rd edition, 1994; cited by section), RBIL (Ralf Brown's Interrupt
  List, release 61, 2000; cited by entry and table number), VGADOC (Finn Thoegersen's VGADOC 4b,
  `standards/thoegersen/`), or IBM (the IBM VGA BIOS behaviour as VGATEST, PC Tech Journal, November
  1988, gives it, encoded in `s3compat/vgaref.inc` and the S3COMPAT checks). Nothing here comes from a
  BIOS image or BIOS source. Behaviour no public source settles is listed under "Open questions" in
  each section, to be answered by running the reference ROMs in the emulator, not written as a rule.
- **IDs.** `B` + AH in hex (`B00-1`); with an AL subfunction `B` + AX (`B1012-1`); for AH=12h, whose
  subfunction is in BL, `B12.30-1`; `BDA-n` the BIOS data area; `TAB-n` the published tables (TAB-1
  to TAB-12 the font and functionality tables in the section on AH=11h-1Ch, TAB-13 on the parameter
  and save pointer tables in the section on the mode set); `MODE-n` the mode definitions. An ID is
  never reused for another rule.
- **Strength.** *must*: IBM behaviour that programs rely on; a violation is a FAIL. *should*:
  documented, but BIOSes differ; a WARN at most. *note*: a known difference between BIOSes or
  documents; never a FAIL.
- **Checked by.** The S3COMPAT line, S3TEST line or emulator test (`emu/tests.py`) that checks the
  rule, or "not checked". `make v2-ref-compare` compares every call in the CGA, EGA and MDA modes with
  the unpatched reference BIOS: it finds regressions, it does not prove IBM behaviour.
- **General rule.** A register not named in a rule's outputs is returned as the caller gave it.
- **Sources disagree** lists, per section, where Ferraro, RBIL and VGADOC differ and which the rule
  follows.

Written 31 October 2026 from the sources above; the open questions are not yet settled.

## Mode set and the state it leaves (AH=00h, AH=0Fh, BIOS data area, published tables)

What a mode set must produce: the standard modes 00h-13h, what AH=00h does to the registers, video
memory, palette, font, cursor and the BIOS data area, how AH=0Fh reports the mode, every BIOS data area
field a VGA BIOS owns, and the tables it publishes through 0040:00A8h. Terms used below:

- 0040:00xxh is the BIOS data area, 0000:00xxh an interrupt vector. **Text modes**: 00h-03h and 07h.
  **Graphics modes**: 04h-06h, 0Dh-13h. **Monochrome modes**: 07h and 0Fh; all others are colour modes.
- **Scan line choice**: 200, 350 or 400 lines, selected with AH=12h BL=30h for the next text mode set
  (B12.30-1) and kept in 0040:0089h bits 7 and 4 and 0040:0088h (BDA-15, BDA-16).
- **Parameter table entry**: the 64-byte entry of the video parameter table that a mode set uses
  (TAB-13 to TAB-15). **State block**: the buffer AH=1Bh fills (RBIL #00040); IBM's state blocks per
  mode (VGATEST) are the reference for many BIOS data area values below, because the state block copies
  them (offset 04h = 0040:0049h, 05h = 004Ah, 07h = 004Ch, 09h = 004Eh, 0Bh = 0050h, 1Bh = 0060h,
  1Dh = 0062h, 1Eh = 0063h, 20h = 0065h, 21h = 0066h, 23h = 0085h).
- A register not named in a rule's outputs is returned as the caller gave it.
- The `TAB-` rules of this section are numbered from TAB-13 on, after the font and functionality table
  rules TAB-1 to TAB-12 of the section on AH=11h-1Ch.

The S3COMPAT lines named below also run in the emulator (emu t_s3compat_vga). 'Mode nnh' means the
S3COMPAT lines "Mode nnh" of the VGA mode pass (modes 00h-06h, 0Dh, 0Eh, 10h-13h at 400/480 lines and
00h-03h at 350 lines, each run twice: from a clean state and right after a VESA mode); their fail bits
are 1 registers vs IBM, 2 BIOS data/AH=0Fh/AH=1Bh, 8 refresh, 10 memory, 20 default DAC. Modes 07h and
0Fh have no IBM table in the project; emu t_mono covers them. `make v2-ref-compare` compares the ROM with
the unpatched reference BIOS in modes 00h-07h and 0Dh-10h at 200, 350 and 400 lines, with and without
the clear; it finds regressions, it does not prove IBM behaviour.

### Mode definitions (00h-13h)

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| MODE-1 | A VGA BIOS supports modes 00h-07h and 0Dh-13h. 08h-0Ch are no VGA modes (08h-0Ah PCjr/Tandy, 0Bh and 0Ch reserved for the EGA BIOS); the static functionality table marks them unsupported (TAB-2) | RBIL INT 10/AH=00h (#00010); Ferraro 11.2 Table 11.2, Table 9.18; VGADOC VGABIOS.TXT (AH=00h) | must | S3COMPAT 'Mode nnh' (00h-06h, 0Dh, 0Eh, 10h-13h); emu t_mono (07h, 0Fh); S3COMPAT 'AH=1B static functionality table' |
| MODE-2 | Video buffer: B800h for 00h-06h, B000h for 07h, A000h for 0Dh-13h | RBIL #00010; VGADOC VGABIOS.TXT; Ferraro 11.2 | must | S3COMPAT 'Mode nnh' fail 10 (memory test in the mode's window); emu t_mono (B000h in 07h) |
| MODE-3 | Text modes: 00h and 01h are 40x25, 02h, 03h and 07h 80x25 characters. Character cell and screen: at 400 lines (the VGA default) 9x16, 360x400 (40 columns) or 720x400 (80 columns); at 350 lines 8x14 in 00h-03h (320x350, 640x350) and 9x14 in 07h (720x350); at 200 lines 8x8 (320x200, 640x200), shown double-scanned on 400 lines. 07h has no 200-line form | Ferraro 11.2 Table 11.2; RBIL #00010; RBIL MEM 0040:0088h note (#M0025: "200-line CGA in 400-line double scan"); Ferraro 11.13.3 | must | S3COMPAT 'Mode nnh' and 'Mode nnh 350' fail 1 (00h-03h); emu t_mono (07h at 400 and 350 lines); make v2-ref-compare (200, 350, 400 lines) |
| MODE-4 | Graphics modes: 04h and 05h 320x200 in 4 colours, 06h 640x200 in 2, 0Dh 320x200 in 16, 0Eh 640x200 in 16, 0Fh 640x350 monochrome (planes 0 and 2: black, video, blink, intensified), 10h 640x350 in 16, 11h 640x480 in 2, 12h 640x480 in 16, 13h 320x200 in 256 colours | Ferraro 11.2 Table 11.2; RBIL #00010; VGADOC VGABIOS.TXT | must | S3COMPAT 'Mode nnh'; emu t_mono (0Fh pixel values 0, 1, 4, 5) |
| MODE-5 | Text grid of the graphics modes (for AH=02h, 09h, 0Eh): 40x25 in 04h, 05h, 0Dh and 13h; 80x25 in 06h, 0Eh, 0Fh and 10h; 80x30 in 11h and 12h. Cell 8 pixels wide; 8 lines high in 04h-06h, 0Dh, 0Eh, 13h, 14 in 0Fh and 10h, 16 in 11h and 12h | Ferraro 11.2 Table 11.2; Ferraro 11.9.4 Table 11.6 (columns); IBM (VGATEST state block 22h, 23h) | must | S3COMPAT 'Mode nnh' fail 2 (state block columns, rows, height) |
| MODE-6 | 00h, 02h and 05h are the "black and white" forms of 01h, 03h and 04h. On a VGA they program the same registers and the same default palette as their colour forms; they differ only in the CGA mode select copy 0040:0065h (bit 2) and in the mode number | Ferraro 11.2 ("these modes are identical"); IBM (VGATEST: the same register and DAC tables for 00h/01h, 02h/03h, 04h/05h; 0065h = 2Ch/28h, 2Dh/29h, 2Ah/2Eh) | must | S3COMPAT 'Mode nnh' fail 1, 2, 20 |
| MODE-7 | Display pages: 8 in 00h-03h and 07h (at every scan line count), 1 in 04h-06h, 8 in 0Dh, 4 in 0Eh, 2 in 0Fh and 10h, 1 in 11h-13h | Ferraro 11.2 Table 11.2; IBM (VGATEST state block 29h) | must | S3COMPAT 'Mode nnh' fail 2 (state block 29h; 07h and 0Fh not checked) |
| MODE-8 | Page length (0040:004Ch, from the parameter table): 0800h in 00h/01h, 1000h in 02h/03h and 07h, 4000h in 04h-06h, 2000h in 0Dh, 4000h in 0Eh, 8000h in 0Fh and 10h, A000h in 11h and 12h, 2000h in 13h; page p starts at p times this length (AH=05h, B05-1). The same values at 200, 350 and 400 lines | IBM (VGATEST state block 07h); Ferraro Table 9.3 (07h, 0Fh); RBIL INT 1D (#01263: 0800h, 1000h, 4000h) | must | S3COMPAT 'Mode nnh' fail 2 (07h and 0Fh not checked) |
| MODE-9 | The 2000h of mode 13h is IBM's value although the picture takes 64000 bytes: a program must not size the buffer of 13h from 0040:004Ch | IBM (VGATEST state block 07h of 13h) | note | S3COMPAT 'Mode 13h' fail 2 (2000h is expected) |
| MODE-10 | Colours (AH=1Bh state block 27h): 16 in the text modes 00h-03h and in 0Dh, 0Eh, 10h, 12h; 4 in 04h, 05h; 2 in 06h, 11h; 256 in 13h; 0000h (monochrome) in 07h and 0Fh | IBM (VGATEST state block 27h); RBIL #00040 ("0000h = mono") | must (should for 07h, 0Fh) | S3COMPAT 'Mode nnh' fail 2 |
| MODE-11 | Scan lines and refresh: 200-line graphics modes (04h-06h, 0Dh, 0Eh, 13h) are double-scanned to 400 lines; 0Fh, 10h and 350-line text have 350 lines; 400-line text 400; 11h and 12h 480. The vertical rate is 70 Hz for 200, 350 and 400 lines and 60 Hz for 480 lines | IBM (VGATEST register tables: CR09 bit 7, CR12; the refresh column of vgaref); Ferraro 11.2 Table 11.2 | must | S3COMPAT 'Mode nnh' fail 1 (registers), 8 (refresh within 1.5 Hz), 40 (refresh vs CRTC and clock) |
| MODE-12 | Character width: the 400-line text modes are 9 dots wide (SR01 bit 0 = 0); at 350 lines 00h-03h are 8 dots wide and 07h 9 dots; at 200 lines 8 dots. In the colour text modes AR10 = 0Ch (blink, line graphics: the ninth column of characters C0h-DFh repeats the eighth) | Ferraro 11.2 Table 11.2; RBIL #00010; IBM (VGATEST SR01, AR10) | must | S3COMPAT 'Mode nnh', 'Mode nnh 350' fail 1 |
| MODE-13 | The scan line choice (B12.30-1) affects only the text modes; every graphics mode has a fixed number of lines (MODE-11) | Ferraro 11.13.3; RBIL INT 10/AH=12h/BL=30h | must | S3COMPAT 'AH=12 BL=30 350 / 400 scan lines' |
| MODE-14 | Monochrome addressing: in 07h and 0Fh the CRTC and input status 1 are at 3B4h/3BAh (MISC bit 0 = 0) and 0040:0063h = 3B4h; in every other mode at 3D4h/3DAh (MISC bit 0 = 1) and 0040:0063h = 3D4h | RBIL MEM 0040:0063h; Ferraro 9.5.3; IBM (VGATEST MISC and state block 1Eh = 3D4h) | must | emu t_mono (07h, 0Fh and back, a sequence of mono and colour modes); S3COMPAT 'Mode nnh' fail 1, 2 |
| MODE-15 | A VGA sets every mode on whatever display is attached ("all modes on all displays", AH=1Bh state block 2Dh bit 0 = 1); a monochrome mode on a colour display, or a colour mode on a monochrome display, is not refused | IBM (VGATEST state block 2Dh: 21h text, 01h graphics); RBIL #00041 bit 0; RBIL MEM 0040:0089h bit 0 | should | S3COMPAT 'Mode nnh' fail 2 (2Dh); emu t_mono (07h on a colour equipment word) |
| MODE-16 | 43- and 50-line text are not modes: a program sets 03h (07h) and then loads the 8x8 font with AX=1112h (at 350 or 400 lines). AH=0Fh still reports 03h (07h) | RBIL #00010 note [17]; RBIL INT 10/AH=0Fh | note | S3COMPAT 'Text 80x50 (AX=1112)' |

### INT 10h AH=00h: set video mode

Programs the hardware for a mode and resets the BIOS state that belongs to it.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B00-1 | Input AL bits 6-0 = mode, AL bit 7 = 1 keeps the video memory (B00-4). No output is defined: IBM documents "Output: none" | Ferraro 11.2.1 ("Output Parameters: None"); RBIL INT 10/AH=00h | must | S3COMPAT 'Mode nnh'; emu t_windows (AL=83h) |
| B00-2 | BX, CX, DX, SI, DI, BP, DS and ES come back as the caller gave them | Ferraro 11.2.1 (no output); RBIL INT 10/AH=00h | should | make v2-ref-compare (registers against the reference BIOS) |
| B00-3 | AL on return differs between BIOSes: some return 30h (modes 00h-05h, 07h), 3Fh (06h) or 20h (above 07h), one returns the CRT mode byte, others AL unchanged. A program must not depend on AL | RBIL INT 10/AH=00h ("Return: AL = video mode flag (Phoenix, AMI BIOS)"); VGADOC VGABIOS.TXT | note | make v2-ref-compare (AL against the reference BIOS) |
| B00-4 | AL bit 7 = 1: the mode is set as usual (registers, BIOS data, palette, font, cursor), but video memory is not erased. 0040:0049h receives the mode without bit 7, and 0040:0087h bit 7 is set; a mode set with AL bit 7 = 0 clears 0040:0087h bit 7 again | Ferraro 11.2.1 ("Erasure During Mode Change"); RBIL INT 10/AH=00h note ("IBM standard modes do not clear the screen if the high bit of AL is set"); RBIL MEM 0040:0087h bit 7 (#M0024); Ferraro Table 9.26 bit 7 | must | emu t_windows (AL=83h: text kept, 0049h = 03h, 0087h bit 7 set; then AL=03h clears and resets the bit); make v2-ref-compare (AL bit 7 in 00h-07h, 0Dh-10h) |
| B00-5 | AL bit 7 = 0: video memory is erased. Text modes: the text buffer holds blanks (character 20h, attribute 07h) in every page (B800:0000h-7FFFh, B000:0000h-7FFFh in 07h); graphics modes: every pixel is 0 (B800:0000h-7FFFh in 04h-06h; all four planes of A000h in 0Dh-13h) | Ferraro 11.2.1 ("the display memory is erased"); fill values: IBM (as S3TEST encodes them) | must (erased), should (fill values) | S3TEST 'VGA mode set clear 13h 12h 03h' (fail 1 A000h 00h in 13h, 2 all planes 00h in 12h, 4 B800:0000h-7FFFh 0720h in 03h) |
| B00-6 | Text modes keep the font in plane 2 whatever bit 7 says: the clear writes planes 0 and 1 only (B00-14 loads the font). With bit 7 = 1 the character codes and attributes stay in planes 0 and 1, so a change from a text to a graphics mode without the clear shows them, and the font, as pixels | Ferraro 11.2.1 ("the character ASCII codes, attributes, and the current character fonts are loaded into the four planes") | should | S3TEST 'Font load 8x16 and 8x8 in plane 2' (after a mode set); make v2-ref-compare (the four planes) |
| B00-7 | Registers: MISC, SR01-04, CRTC 00h-18h, AR00-13h and GR00-08h get the values of the mode's parameter table entry (TAB-13, TAB-15); for the standard modes these are IBM's values. AR14h (colour select) = 00h and the feature control register = 00h | RBIL MEM 0040:00A8h (#M0041, #M0042); Ferraro 9.2.2, Table 9.31; IBM (VGATEST register tables) | must | S3COMPAT 'Mode nnh' fail 1 (62 registers); emu t_vga_registers; make v2-ref-compare |
| B00-8 | The registers are written with the screen blanked and the sequencer reset; when the call returns, the screen is on (SR01 bit 5 = 0), the sequencer runs (SR00 = 03h) and the attribute controller shows the palette (PAS = 1). The CRTC protect bit CR11 bit 7 is set as in IBM's tables, so a program clears it before it writes CR00-07 | IBM (VGATEST: SR00 = 03h, SR01 bit 5 = 0, CR11 bit 7 = 1); Ferraro 10.6.1 (PAS) | must | S3COMPAT 'Mode nnh' fail 1; S3TEST 'VGA ATC flip-flop reset by mode set' |
| B00-9 | The attribute flip-flop is reset before the BIOS uses 3C0h, whatever state the caller left it in; after the call it is in the index state | Ferraro 10.6.1 (the flip-flop "cannot be interrogated or saved") | should | S3TEST 'VGA ATC flip-flop reset by mode set' (flip-flop left in the data state before the call, index state after) |
| B00-10 | Default palette (0040:0089h bit 3 = 0): AR00-0Fh and the overscan AR11 come from the parameter table and the DAC is loaded: in 13h IBM's 256-colour table; in 04h-06h, 0Dh, 0Eh the CGA palette; in 00h-03h at 350 and 400 lines and in 10h-12h the EGA palette | IBM (VGATEST DAC.COL, EGA/CGA palettes); Ferraro 11.13.4 ("the default palette ... during following mode sets") | must | S3COMPAT 'Mode nnh' fail 20 (first 64 entries; 13h the whole table); emu t_vga_palettes |
| B00-11 | EGA palette, DAC entry i (0-3Fh), 6-bit values: red = 2Ah if bit 2 + 15h if bit 5, green = 2Ah if bit 1 + 15h if bit 4, blue = 2Ah if bit 0 + 15h if bit 3. CGA palette, entry i: n = 15h if bit 4 else 0; red = 2Ah if bit 2 + n, green = 2Ah if bit 1 + n, blue = 2Ah if bit 0 + n, except that i with bits 4, 2-0 = 0, 110b (brown) has green 15h | IBM (VGATEST palette formulas as emu `ega()` and `cga()` encode them) | must | S3COMPAT 'Mode nnh' fail 20; emu t_vga_palettes |
| B00-12 | With grey summing on (0040:0089h bit 1 = 1) the DAC is loaded with grey values (B12.33-2); with default palette loading disabled the palette registers, the overscan and the DAC are left unchanged (B12.31-2). The dynamic save area receives the mode's AR00-0Fh and AR11 (B10-7) | Ferraro 11.13.4, 11.13.6; RBIL MEM 0040:0089h (#M0027) | must | S3COMPAT 'AH=12 BL=31 default palette loading', 'AH=12 BL=33 grey summing on mode set', 'Video save pointer table 0040:00A8' fail 1 |
| B00-13 | After the defaults, a user palette profile (TAB-24) whose mode list holds the mode overrides the attribute and DAC registers it names | RBIL MEM 0040:00A8h (#M0038 offset 0Ah, #M0049) | should | not checked |
| B00-14 | Text modes: the ROM font of the cell height is loaded into block 0 of plane 2 (8x8 at 200 lines, 8x14 at 350, 8x16 at 400), each glyph in a 32-byte slot; in the 9-dot modes (07h at 350 lines, every text mode at 400) the 9x14 or 9x16 alternate glyphs replace their 8-dot ones. SR03 (character map select) = 00h | Ferraro 11.2 Table 11.2 (cell sizes), 11.12.1 (32-byte slots); RBIL INT 10/AX=1130h (#00021, the alternate tables); IBM (VGATEST SR03 = 00h) | must | S3TEST 'Font load 8x16 and 8x8 in plane 2' (checked after AX=1114h); S3COMPAT 'Mode nnh' fail 1 (SR03); make v2-ref-compare (plane 2) |
| B00-15 | After the ROM font, an alphanumeric character set override (TAB-18, TAB-19) and a second alphanumeric override (TAB-23) whose mode lists hold the mode are loaded | RBIL MEM 0040:00A8h (#M0037, #M0046, #M0047) | should | S3COMPAT 'Video save pointer table 0040:00A8' fail 2, 4 (mode 03h at 400 lines) |
| B00-16 | Graphics modes: INT 43h (0000:010Ch) points to the ROM font of the cell height: 8x8 in 04h-06h, 0Dh, 0Eh and 13h, 8x14 in 0Fh and 10h, 8x16 in 11h and 12h; unless a graphics character set override (TAB-20) lists the mode, then to its font | RBIL INT 43 ("graphics data for characters 00h-7Fh of the current font in 8x8 dot modes, graphics data for all characters in 8x14 and 8x16 modes"); Ferraro 11.12.15; IBM (VGATEST state block 23h: 8, 14, 16) | must | S3COMPAT 'AX=1130 BH=1 INT43 in mode 13'; S3COMPAT 'Video save pointer table 0040:00A8' fail 8, 10h (mode 12h override) |
| B00-17 | Cursor: all eight cursor positions (0040:0050h-005Fh) = 0000h, active page 0040:0062h = 0, page start 0040:004Eh = 0000h and the CRTC start address CR0Ch/CR0Dh = 0 | Ferraro 11.2.1 ("Host Memory Affected": 44Eh, 450h, 462h); IBM (VGATEST state block 09h-1Ah, 1Dh; CR0C/CR0D = 00h) | must | S3COMPAT 'Mode nnh' fail 1, 2 |
| B00-18 | Cursor shape: 0040:0060h and CR0Ah/CR0Bh get the mode's cursor start and end lines from the parameter table: start 0Dh, end 0Eh in the 400-line text modes, start 0Bh, end 0Ch at 350 lines (0040:0061h = start, 0040:0060h = end); 0000h in the graphics modes, which show no cursor | IBM (VGATEST state block 1Bh: 0D0Eh, 0B0Ch, 0000h; CR0A/CR0B); Ferraro 11.2.1 ("460 = Cursor mode") | must | S3COMPAT 'Mode nnh', 'Mode nnh 350' fail 1, 2; emu t_vga_registers |
| B00-19 | BIOS data set by every mode set: 0040:0049h, 004Ah, 004Ch, 004Eh, 0050h-005Fh, 0060h, 0062h, 0063h, 0065h, 0066h, 0084h, 0085h, 0087h bit 7, and the equipment word bits 5-4 (0040:0010h); the values are those of BDA-1 to BDA-13 | Ferraro 11.2.1 ("Host Memory Affected"); RBIL MEM 0040:0049h-0066h, 0084h, 0085h | must | S3COMPAT 'Mode nnh' fail 2; emu t_mono |
| B00-20 | BIOS data a mode set keeps: the cursor emulation flag (0040:0087h bit 0), the scan line choice, palette loading, grey summing and display switching bits of 0040:0089h, 0040:008Ah and 0040:00A8h. They are choices for later mode sets (AH=12h BL=30h-35h, AX=1A01h) | RBIL INT 10/AH=12h BL=30h-35h ("at next mode set"); RBIL MEM 0040:0087h-008Ah; Ferraro 11.13.3-11.13.7 | should | S3COMPAT 'AH=12 BL=31 default palette loading', 'AH=12 BL=33 grey summing on mode set' (kept across mode 03h); emu t_mono (0040:008Ah) |
| B00-21 | The mode set reads the parameter table and the overrides through the pointer at 0040:00A8h at each call, so a program can change a mode by pointing 0040:00A8h at a RAM copy of the tables | RBIL MEM 0040:00A8h (#M0037 note "copy to RAM to alter, then update 40h:A8h") | should | S3COMPAT 'Video save pointer table 0040:00A8' (overrides through a RAM copy; the parameter table pointer is copied unchanged) |
| B00-22 | A standard mode set gives the same registers and BIOS data whatever mode was set before it, a Super VGA mode included: no state of the previous mode survives | Ferraro 11.2.1 ("It is advisable to use the interrupt 10 hex feature ... This ensures that all of the features ... are properly handled") | must | S3COMPAT pass 2 ('Mode nnh after xxxx', every line as in pass 1); S3COMPAT 'Mode 03 after all tests vs baseline' |
| B00-23 | Mode numbers the BIOS does not support (08h-0Ch, and 14h-7Fh where no extended mode exists): no public source says what happens. A program sets the mode and checks it with AH=0Fh | RBIL #00010 (08h-0Ch not VGA modes); RBIL INT 10/AH=05h note (verify with AH=0Fh) | note | emu t_errors (AL = 14h-18h, 1Bh, 1Fh, 20h, 60h, 7Fh: the video state does not change) |

### INT 10h AH=0Fh: get current video mode

Reports the mode, the number of columns and the active page from the BIOS data area.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B0F-1 | No input. Output AL = current mode (0040:0049h), AH = number of character columns (low byte of 0040:004Ah), BH = active page (0040:0062h) | RBIL INT 10/AH=0Fh; Ferraro 11.9.4 (Table 11.5); VGADOC VGABIOS.TXT | must | S3COMPAT 'Mode nnh' fail 2 (AL = mode, AH = columns, BH = 0); make v2-ref-compare |
| B0F-2 | AL bit 7 is 1 when the last mode set was made with AL bit 7 = 1 (no clear), as 0040:0087h bit 7 records it | RBIL INT 10/AH=0Fh note; Ferraro 11.9.4; RBIL MEM 0040:0087h bit 7 | must | not checked (emu t_windows checks 0040:0087h bit 7, not AH=0Fh) |
| B0F-3 | Columns: 40 in 00h, 01h, 04h, 05h, 0Dh, 13h; 80 in 02h, 03h, 06h, 07h, 0Eh-12h | Ferraro Table 11.6; RBIL #00010 | must | S3COMPAT 'Mode nnh' fail 2 |
| B0F-4 | In 43- and 50-line text AL is 03h (07h on monochrome): the font functions change the rows, not the mode number | RBIL INT 10/AH=0Fh note | should | not checked |
| B0F-5 | BL, CX, DX, SI, DI, BP, DS, ES come back as given | RBIL INT 10/AH=0Fh (returns AX and BH only) | should | make v2-ref-compare (AX=0F00h in modes 00h-07h, 0Dh-10h) |
| B0F-6 | The values come from the BIOS data area, not from the hardware: after a program has programmed the registers itself, AH=0Fh reports the last BIOS mode | Ferraro 9.3.2 (the BIOS keeps its state in host memory); Ferraro 11.9.4 (Table 11.5) | note | not checked |

### BIOS data area fields of a VGA BIOS

What each field holds, who writes it and when. A VGA BIOS keeps its state here and reads it back
(the EGA registers were write-only); a program that changes the hardware directly must keep these
fields consistent or set the mode again.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| BDA-1 | 0040:0010h (equipment word) bits 5-4, initial video mode: 00b adapter with its own BIOS, 01b 40x25 colour, 10b 80x25 colour, 11b 80x25 monochrome. A VGA mode set makes them 11b for 07h and 0Fh and 10b for every colour mode, so that programs that read the equipment word find the active display | RBIL MEM 0040:0010h (#M0006); VGADOC VGABIOS.TXT (0:410h) | should | emu t_mono (30h after 07h and 0Fh, 20h after 01h, 03h, 12h, 13h, whatever the word held before) |
| BDA-2 | 0040:0049h (byte): current mode, 00h-13h, without the no-clear bit. Written only by AH=00h | RBIL MEM 0040:0049h; Ferraro 11.2.1, Table 9.8; VGADOC VGABIOS.TXT | must | S3COMPAT 'Mode nnh' fail 2 (state block 04h); emu t_mono, t_windows (03h after AL=83h) |
| BDA-3 | 0040:004Ah (word): number of character columns (MODE-3, MODE-5). Written by AH=00h | RBIL MEM 0040:004Ah; Ferraro 11.2.1, 9.5.3 | must | S3COMPAT 'Mode nnh' fail 2 (state block 05h) |
| BDA-4 | 0040:004Ch (word): length of one page in bytes (MODE-8). Written by AH=00h; in text modes also by the font functions that recalculate (AX=1110h-1114h) | RBIL MEM 0040:004Ch; Ferraro 11.2.1; RBIL INT 10/AX=1110h | must | S3COMPAT 'Mode nnh' fail 2 (state block 07h) |
| BDA-5 | 0040:004Eh (word): offset of the active page in the video buffer, in bytes. 0 after AH=00h; AH=05h sets it to page x 0040:004Ch | RBIL MEM 0040:004Eh; Ferraro 9.5.3, 11.2.1 | must | S3COMPAT 'Mode nnh' fail 2 (state block 09h); S3COMPAT 'AH=05 pages (mode 03 p3, mode 0D p7)' |
| BDA-6 | 0040:0050h-005Fh (8 words): cursor position of pages 0-7, column in the low byte (0050h + 2p), row in the high byte (0051h + 2p). All 0000h after AH=00h; written by AH=02h and by the output functions that move the cursor (AH=0Eh, AH=13h AL bit 0 = 1) | RBIL MEM 0040:0050h; VGADOC VGABIOS.TXT ("col, row"); Ferraro 11.3.2 | must | S3COMPAT 'Mode nnh' fail 2 (state block 0Bh-1Ah); S3COMPAT 'AH=01/02/03 cursor + emulation' |
| BDA-7 | 0040:0060h (word): cursor shape as AH=01h received it in CX: 0040:0060h = end line (CL), 0040:0061h = start line (CH). Set by AH=00h (B00-18) and AH=01h (B01-2) | RBIL MEM 0040:0060h (start and end line); VGADOC VGABIOS.TXT ("hi=startline, lo=endline"); IBM (VGATEST state block 1Bh) | must | S3COMPAT 'Mode nnh' fail 2 (state block 1Bh); S3COMPAT 'AH=01/02/03 cursor + emulation' fail 2 |
| BDA-8 | 0040:0062h (byte): active display page. 0 after AH=00h; written by AH=05h | RBIL MEM 0040:0062h; Ferraro 9.5.5 | must | S3COMPAT 'Mode nnh' fail 2 (state block 1Dh); S3COMPAT 'AH=05 pages ...' |
| BDA-9 | 0040:0063h (word): CRTC index port, 3B4h in 07h and 0Fh, 3D4h otherwise (MODE-14). Written by AH=00h | RBIL MEM 0040:0063h; Ferraro 9.5.3; VGADOC VGABIOS.TXT | must | emu t_mono; S3COMPAT 'Mode nnh' fail 2 (state block 1Eh) |
| BDA-10 | 0040:0065h (byte): copy of the CGA/MDA mode select register (3D8h/3B8h): bit 0 80-column text, 1 graphics, 2 black and white, 3 video enabled, 4 640-pixel graphics, 5 blink. After AH=00h: 2Ch, 28h, 2Dh, 29h, 2Ah, 2Eh, 1Eh in modes 00h-06h and 29h in 07h. AX=1003h changes bit 5 (B1003-2) | RBIL MEM 0040:0065h (#M0018); IBM (VGATEST state block 20h, modes 00h-06h) | must (00h-06h), should (07h) | S3COMPAT 'Mode nnh' fail 2 (state block 20h) |
| BDA-11 | 0040:0066h (byte): copy of the CGA colour select register (3D9h): bits 3-0 colour, 4 intensity, 5 palette. After AH=00h: 30h in 00h-05h, 3Fh in 06h (B0B-8 for the other modes); AH=0Bh updates it (B0B-7) | RBIL MEM 0040:0066h (#M0019); IBM (VGATEST state block 21h) | must | S3COMPAT 'Mode nnh' fail 2 (state block 21h) |
| BDA-12 | 0040:0084h (byte): number of character rows minus one: 24 in every standard mode except 11h and 12h (29). Written by AH=00h and by the font functions that recalculate (AX=1110h-1114h, 1121h-1124h) | RBIL MEM 0040:0084h; Ferraro 9.5.3; IBM (VGATEST state block 22h, which holds the rows: 25, 30) | must | S3COMPAT 'Mode nnh' fail 2 (state block 22h); emu t_mono (24 in 07h) |
| BDA-13 | 0040:0085h (word): character height in scan lines (bytes per glyph): 16, 14 or 8 in the text modes after the scan line choice; 8, 14 or 16 in the graphics modes (MODE-5). Written by AH=00h and the font functions | RBIL MEM 0040:0085h; Ferraro 9.5.3; IBM (VGATEST state block 23h) | must | S3COMPAT 'Mode nnh' fail 2 (state block 23h); emu t_mono (14 at 350 lines, 16 at 400) |
| BDA-14 | 0040:0087h (byte), video control: bit 7 last mode set without clear (B00-4); bits 6-5 video memory (n + 1) x 64 KB, 11b on a VGA; bit 4 reserved; bit 3 = 1 video system inactive; bit 2 wait for display enable; bit 1 monochrome display; bit 0 = 1 cursor emulation disabled (AH=12h BL=34h). Set up at POST; bit 7 is written by every mode set, bit 0 only by AH=12h BL=34h | RBIL MEM 0040:0087h (#M0024); VGADOC VGABIOS.TXT; Ferraro Table 9.26 | must (bits 7, 6-5, 0), should (others) | emu t_windows (bit 7); make v2-ref-compare (whole data area) |
| BDA-15 | 0040:0088h (byte), switches: bits 3-0 the EGA configuration switches (#M0026), bits 7-4 the feature connector bits read at POST. With 0040:0089h bit 4 = 0 the next text mode set gives 350 lines if bits 3-0 are 3h or 9h and 200 lines otherwise; RBIL and VGADOC say the VGA sets the low nibble to 9h after a mode set | RBIL MEM 0040:0088h (#M0025, #M0026); VGADOC VGABIOS.TXT; Ferraro Table 9.27 | should | make v2-ref-compare (whole data area) |
| BDA-16 | 0040:0089h (byte), mode set options: bits 7 and 4 the scan line choice (00b 350, 01b 400, 10b 200); bit 6 display switching enabled; bit 5 reserved; bit 3 = 1 default palette loading disabled; bit 2 monochrome display; bit 1 grey summing on; bit 0 = 1 VGA active (all modes on all displays). Written at POST and by AH=12h BL=30h, 31h, 33h, 35h | RBIL MEM 0040:0089h (#M0027); VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=12 BL=30 ...', 'AH=12 BL=31 ...', 'AH=12 BL=33 ...'; emu t_vga_registers (state block 2Dh, which repeats bits 0-3) |
| BDA-17 | RBIL and VGADOC add that a VGA mode set resets bit 7 and sets bit 4 of 0040:0089h; that would make a 200- or 350-line choice last one mode set only. Programs repeat AH=12h BL=30h before each mode set when they need a scan line count | RBIL MEM 0040:0089h (#M0027 notes); VGADOC VGABIOS.TXT | note | not checked |
| BDA-18 | 0040:008Ah (byte): index of the active display combination in the DCC table (TAB-22). Set at POST and by AX=1A01h (B1A01-1); AX=1A00h reads the pair through it | RBIL MEM 0040:008Ah; VGADOC VGABIOS.TXT | should | emu t_mono (AX=1A01h, every pair) |
| BDA-19 | 0040:00A8h (dword): far pointer to the save pointer table (TAB-16). Set at POST to the table in the ROM; a program may point it to a copy in RAM, and the BIOS then uses the copy at the next call (B00-21) | RBIL MEM 0040:00A8h (#M0037 note); VGADOC VGABIOS.TXT; Ferraro 9.2.2 | must | S3COMPAT 'Video save pointer table 0040:00A8' (points it to a RAM copy and back) |
| BDA-20 | The VGA BIOS owns only 0040:0049h-0066h, 0084h-008Ah and 00A8h, and the video bits of 0040:0010h; it does not write 0040:0067h-0083h or 008Bh-00A7h (cassette/restart, keyboard, disk and timer data of the system BIOS) | RBIL MEM 0040:0067h ff.; Ferraro 9.3.2, Table 9.8 | must | make v2-ref-compare (the whole 0040:0000h-00FFh page against the reference BIOS) |

### Video parameter table and save pointer table

The tables a VGA BIOS publishes through 0040:00A8h. They start in ROM; the BIOS reads them at every
mode set, and a program alters them by copying them to RAM and changing the pointer to them.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| TAB-13 | Parameter table entry, 64 bytes: 00h columns, 01h rows minus one, 02h character height, 03h-04h page length (word), 05h-08h SR01-04, 09h MISC, 0Ah-22h CRTC 00h-18h, 23h-36h AR00-13h, 37h-3Fh GR00-08h. Bytes 00h-04h are copied to 0040:004Ah, 0084h, 0085h and 004Ch at the mode set | RBIL MEM 0040:00A8h (#M0042); VGADOC VGABIOS.TXT; Ferraro Table 9.2, Table 9.31 | must | not checked directly (vgaref.inc was cross-checked once against the ROM's table); S3COMPAT 'Mode nnh' fail 1, 2 (the values that come from it) |
| TAB-14 | Entry order, 29 entries on a VGA (23 on an EGA): 00h-03h modes 00h-03h at 200 lines; 04h-0Eh modes 04h-0Eh (08h-0Ch unused on a VGA); 0Fh-10h modes 0Fh-10h with 64 KB; 11h-12h modes 0Fh-10h with more than 64 KB; 13h-16h modes 00h-03h at 350 lines; 17h modes 00h/01h at 400 lines; 18h modes 02h/03h at 400 lines; 19h mode 07h at 400 lines; 1Ah-1Ch modes 11h-13h | RBIL MEM 0040:00A8h (#M0041); VGADOC VGABIOS.TXT; Ferraro Table 9.30 (EGA part) | must | not checked |
| TAB-15 | Entry of a mode: 00h-03h: the mode number at 200 lines, mode + 13h at 350, 17h (00h, 01h) or 18h (02h, 03h) at 400; 07h: 07h at 350 lines, 19h at 400; 04h-06h, 0Dh, 0Eh: the mode number; 0Fh, 10h: 11h, 12h (a VGA has 256 KB); 11h-13h: 1Ah-1Ch | RBIL #M0041; VGADOC VGABIOS.TXT | must | not checked |
| TAB-16 | Save pointer table, 7 doublewords (far pointers, offset first): 00h parameter table (always valid); 04h dynamic save area or 0; 08h alphanumeric character set override or 0; 0Ch graphics character set override or 0; 10h secondary save pointer table (VGA, always valid); 14h and 18h reserved, 0 | RBIL MEM 0040:00A8h (#M0037); VGADOC VGABIOS.TXT; Ferraro 9.2.2, Table 9.29 | must | S3COMPAT 'Video save pointer table 0040:00A8' (copies the 7 pointers and uses 04h, 08h, 0Ch) |
| TAB-17 | Dynamic save area, 256 bytes: 00h-0Fh the last values written to AR00-0Fh, 10h the overscan AR11, 11h-FFh reserved. Filled by mode sets and the palette functions when its pointer is not 0 (B10-5, B10-7) | RBIL #M0045; VGADOC VGABIOS.TXT | must | S3COMPAT 'Video save pointer table 0040:00A8' fail 1 |
| TAB-18 | Alphanumeric character set override: 00h bytes per character, 01h block to load (0 normal), 02h-03h number of characters, 04h-05h first character code, 06h-09h far pointer to the glyphs, 0Ah displayable rows (FFh: as calculated), 0Bh onward the modes it applies to, ended by FFh | RBIL #M0046 | must | S3COMPAT 'Video save pointer table 0040:00A8' fail 2 |
| TAB-19 | At a mode set of a listed text mode, the override is loaded after the ROM font as AX=1110h loads a font (block, count, first code, height; the BIOS data and the CRTC follow the height, B1110-1); a row count other than FFh sets the rows (0040:0084h = rows - 1) | RBIL #M0046; RBIL INT 10/AX=1110h | should | S3COMPAT 'Video save pointer table 0040:00A8' fail 2 (glyphs in plane 2), 4 (0040:0085h = 16) |
| TAB-20 | Graphics character set override: 00h displayable rows, 01h-02h bytes per character, 03h-06h far pointer to the font, 07h onward the modes, ended by FFh. At a mode set of a listed graphics mode: INT 43h = the pointer, 0040:0085h = bytes per character, 0040:0084h = rows - 1 | RBIL #M0048; Ferraro Table 9.29 ("aux char generator") | should | S3COMPAT 'Video save pointer table 0040:00A8' fail 8 (INT 43h), 10h (0040:0085h, 0040:0084h) |
| TAB-21 | Secondary save pointer table (VGA): 00h length in bytes including this word (1Ah); 02h DCC table (always valid); 06h second alphanumeric character set override or 0; 0Ah user palette profile or 0; 0Eh, 12h, 16h reserved, 0 | RBIL #M0038; VGADOC VGABIOS.TXT | must | emu t_mono (reaches the DCC table through it) |
| TAB-22 | DCC table: 00h number of entries, 01h version, 02h highest display type code in the table, 03h reserved, 04h onward one byte pair per entry (display types of #M0040). AX=1A00h/1A01h use it (B1A00-3) | RBIL #M0039, #M0040 | must | emu t_mono (every pair) |
| TAB-23 | Second alphanumeric character set override (IBM layout): 00h bytes per character, 01h block to load (normally not 0), 02h reserved, 03h-06h far pointer to the font, 07h onward the modes, ended by FFh. It adds a second 256-character set, for 512 characters in a listed text mode | RBIL #M0047 (with the note that "authorities differ" on the layout) | should | not checked |
| TAB-24 | User palette profile: 00h underlining (01h on in all text modes, 00h on in monochrome text modes only, FFh off in all text modes); 01h-03h reserved; 04h-05h number of attribute registers (0-17); 06h-07h first attribute register (0-16; 16 is the overscan); 08h-0Bh far pointer to their values; 0Ch-0Dh number of DAC registers (0-256); 0Eh-0Fh first DAC register; 10h-13h far pointer to their values, three bytes (red, green, blue) each; 14h onward the modes, ended by FFh | RBIL #M0049; RBIL #M0045 (the 17 attribute values: 16 palette registers and the overscan) | should | not checked |
| TAB-25 | Every mode list in these tables ends with FFh; a mode not in the list leaves the override unused for that mode set | RBIL #M0046-#M0049 | must | S3COMPAT 'Video save pointer table 0040:00A8' (overrides listed for one mode) |
| TAB-26 | The BIOS writes none of these tables except the dynamic save area; they may be in ROM. The pointers 08h, 0Ch of the save pointer table and 06h, 0Ah of the secondary table are 0 unless a program installs an override | RBIL #M0037, #M0038 notes ("table initially in ROM, copy to RAM to alter") | should | not checked |

### Font vectors INT 1Fh and INT 43h

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| TAB-27 | INT 1Fh (0000:007Ch) and INT 43h (0000:010Ch) are data pointers, not handlers; a program must not call them | RBIL INT 43 ("this is not a callable vector"); RBIL INT 1F ("SYSTEM DATA") | must | not checked |
| TAB-28 | After POST, INT 43h points to the ROM 8x8 font (codes 00h-7Fh are what CGA graphics modes take from it) and INT 1Fh to 1024 bytes of 8x8 glyphs for codes 80h-FFh; the VGA BIOS sets both when it initialises the video vectors | Ferraro 11.1 ("initializes the video vectors"), Table 9.7; RBIL INT 1F, INT 43 | should | S3COMPAT 'AX=1120-1124 graphics fonts' fail 1 (INT 1Fh after AX=1120h only) |
| TAB-29 | AH=00h sets INT 43h in the graphics modes only (B00-16); no public source says what it holds after a text mode set, or whether a mode set touches INT 1Fh | RBIL INT 43; Ferraro 11.12.10, 11.12.15 | note | not checked |
| TAB-30 | INT 42h holds the system BIOS's INT 10h handler that an EGA or VGA adapter BIOS replaced (not on the PS/2 built-in VGA); many VGA BIOSes also point INT 6Dh to their own entry. Calls with an AH the adapter does not handle go to INT 42h | RBIL INT 42 ("relocated default INT 10 video services"), INT 6D ("many VGA - video BIOS entry point"); Ferraro 11.1 (AH above 1Ch "another interrupt is invoked. This interrupt is number 42 hex"), Table 9.7 | note | emu t_errors (undefined AH values return every register unchanged) |

### Open questions

1. AH=00h with an unsupported mode number (08h-0Ch, 14h-7Fh, and with AL bit 7 set, 88h-8Ch,
   94h-FFh): is it ignored with every register and the whole video state unchanged, or is it mapped to
   another mode? Does it set 0040:0087h bit 7 or 0040:0049h before it gives up?
2. AH=00h: what does AL hold on return for each mode (unchanged, 20h/30h/3Fh, or something else)? Are
   bits 31-16 of the 32-bit registers kept?
3. Mode 07h or 0Fh set while the equipment word (0040:0010h bits 5-4) says colour, and a colour mode
   while it says monochrome: is the requested mode set as asked (the CRTC moved to 3B4h/3D4h), or is it
   replaced by mode 00h or 07h? Is the equipment word changed in either case?
4. Which DAC does a mode set load in 07h and 0Fh (a monochrome palette, or the EGA palette), in the
   200-line text modes (CGA or EGA palette), and what do entries 40h-FFh hold after a mode set of a mode
   other than 13h (left as they were, or written)?
5. Does every mode set with default palette loading on also set the PEL mask (3C6h) to FFh, and does it
   do so with palette loading disabled?
6. Does the clear erase all of video memory (every plane of A000h-BFFFh, 256 KB) or only the mode's
   window? In 04h-06h, is B800:0000h-7FFFh written as 0000h, and does the clear of a text mode write
   0720h in every page of B800:0000h-7FFFh?
7. 0040:0089h after a mode set: are bits 7 and 4 kept (the 200/350-line choice lasts until the next
   AH=12h BL=30h) or is bit 7 reset and bit 4 set (BDA-17)? Is the low nibble of 0040:0088h 9h after a
   colour mode, 8h after a 200-line colour text mode, and Bh after 07h/0Fh?
8. 0040:0087h after a mode set: are bits 3 (inactive), 2 (wait for display enable) and 1 (monochrome
   display) cleared or set according to the mode, or left as POST set them? Is 0040:0089h bit 2
   changed by the mode set of 07h or 0Fh?
9. Mode 07h with 200 lines selected (AH=12h BL=30h AL=00h): 350 or 400 lines, and which font?
10. 0040:0060h and CR0Ah/CR0Bh after a mode set of a 200-line text mode: 0607h (the 8x8 cell), or the
    400-line value 0D0Eh? And after 07h at 350 and 400 lines? Is cursor emulation applied to the
    mode's own cursor value?
11. 0040:0065h and 0040:0066h after a mode set of 0Dh-13h: written (1Eh and 3Fh, as IBM's state blocks
    show) or left from the previous mode? The IBM values could be what mode 06h left before.
12. INT 43h after a mode set of a text mode: unchanged, or set to a ROM font? Does any mode set
    change INT 1Fh?
13. Alphanumeric override: is it applied when its height does not match the scan line choice (a
    14-line font in a 400-line mode)? Is its row byte stored in 0040:0084h as rows or rows - 1? Is the
    font loaded with recalculation (CRTC changed) as AX=1110h, or without as AX=1100h?
14. Graphics override: is its row byte stored as rows - 1, and does it apply in modes 04h-06h, where
    the glyphs of codes 80h-FFh come from INT 1Fh?
15. Second alphanumeric override: is it loaded only when its height equals 0040:0085h, and which bits of
    SR03 select its block (attribute bit 3 = 1)?
16. User palette profile: is the underline byte applied when default palette loading is disabled, and
    what value goes into CR14h (character height - 1 for "on", 1Fh for "off")? Is the attribute index
    16 written to AR11h (overscan), skipping AR10h? Is the profile applied in a mode without underline
    (graphics modes)?
17. Does the mode set keep AL bit 7 of 0040:0087h when it is called through AH=11h (the font functions
    that "cause a mode set")? 
18. Do all 29 entries of our ROM's parameter table follow the order and layout of TAB-14 and TAB-15
    (entries 08h-0Ch and 0Fh-10h included), so that a program that reads an entry through
    0040:00A8h finds the registers the mode set programs?
19. What does the ROM's save pointer table hold at POST: a dynamic save area pointer of 0, override
    pointers of 0, and a secondary table of length 1Ah?
20. Does a mode set with interrupts disabled by the caller leave IF as found? Does it enable interrupts
    during the clear?
21. AH=0Fh: is BL returned unchanged, and is AH the low byte of 0040:004Ah even when the word is above
    255?

### Sources disagree

1. Cursor positions 0040:0050h: Ferraro 9.5.4 puts the row in the even byte and the column in the odd
   one; RBIL and VGADOC give the column in the low (even) byte, as AH=02h's DL/DH order does. The rules
   follow RBIL (BDA-6).
2. Cursor shape 0040:0060h: Ferraro 9.5.4 says the low byte holds the start line; VGADOC says
   "hi=startline, lo=endline", RBIL calls the word big-endian, and IBM's state block 1Bh (0D0Eh with
   CR0Ah = 0Dh start, CR0Bh = 0Eh end) has the end line in the low byte. The rules follow VGADOC and
   IBM (BDA-7).
3. Cursor emulation bit 0040:0087h bit 0: Ferraro Table 9.26 gives 1 = emulate; RBIL and VGADOC give
   1 = emulation disabled, as AH=12h BL=34h uses it. The rules follow RBIL (BDA-14).
4. Pages of 02h/03h: VGADOC gives 4 pages (the CGA value); Ferraro Table 11.2, RBIL #00010 (EGA, VGA)
   and IBM's state block give 8. The rules follow IBM (MODE-7).
5. Pages of 0Fh/10h: Ferraro Table 11.7 (OCR) reads "F-10: 0-7"; his Table 11.2, RBIL and VGADOC give
   2 pages. The rules follow Table 11.2 (MODE-7).
6. Page lengths: Ferraro Table 9.3 prints 16,386 for 4000h and 8,196 for 2000h (misprints of 16,384 and
   8,192). The rules use the hex values of IBM's state blocks (MODE-8).
7. Ferraro Table 11.2 gives mode 03h at 200 lines as 720 by 200 pixels; with an 8x8 cell and 80
   columns it is 640x200, as RBIL has it (MODE-3).
8. Ferraro Table 11.6 lists mode 5 among both the 40- and the 80-column modes; RBIL #00010 and IBM's
   state block give 40 columns (B0F-3).
9. The 0040:00A8h pointer: Ferraro 9.2.2 and RBIL describe a pointer to the save pointer table; Ferraro
   Table 9.29 lists the pointers themselves at 0000:04A8h-04B7h, and calls the fourth a "text" auxiliary
   character generator. The rules follow RBIL and Ferraro 9.2.2 (BDA-19, TAB-16, TAB-20).
10. AH=1Bh offset 22h: RBIL #00040 calls it "number of rows - 1"; IBM's state blocks hold 25 and 30, the
    rows, while 0040:0084h holds 24 and 29. BDA-12 uses IBM's values.
11. 0040:0089h after a mode set: RBIL and VGADOC say bit 7 is reset and bit 4 set (BDA-17), which would
    undo a 200- or 350-line choice after one mode set, while Ferraro 11.13.3 and RBIL INT 10/AH=12h
    BL=30h describe the choice as taking effect "at the next mode set" without saying how long it
    lasts. BDA-17 is a note; open question 7 settles it on our ROMs.
12. Return value of AH=00h: Ferraro gives no output; RBIL and VGADOC list AL values of some BIOSes. The
    rule is a note (B00-3).

## Cursor, pages and character output (AH=01h-0Eh, 13h)

The text cursor, the display pages, scrolling, character and pixel output and the string functions.
Terms used below:

- **Text modes**: 00h-03h (B800h) and 07h (B000h). **CGA graphics modes**: 04h/05h (4 colours, 2 bits a
  pixel) and 06h (2 colours, 1 bit a pixel), packed at B800h with the even scan lines from B800:0000h and
  the odd ones from B800:2000h, 80 bytes a line, pixel 0 in the high bits of a byte (Ferraro 7.4.3,
  7.4.4, 7.4.6). **Planar modes**: 0Dh, 0Eh, 0Fh, 10h, 11h, 12h at A000h. **256-colour mode**: 13h at
  A000h, one byte a pixel, 320 bytes a line.
- **Cursor of page p**: the word at 0040:0050h + 2*p, column in the low byte, row in the high byte
  (Ferraro 11.3.2, RBIL MEM 0040:0050h). **Active page**: 0040:0062h. **Page start**: 0040:004Eh.
  **Page length**: 0040:004Ch. **Columns**: 0040:004Ah. **Last row**: 0040:0084h (rows minus one).
  **Character height**: 0040:0085h. **CRTC**: the port in 0040:0063h (3D4h, or 3B4h in modes 07h and 0Fh).
- **Cell** in a graphics mode: one character position, 8 pixels wide and 0040:0085h scan lines high
  (Ferraro 6.7.12 table 6.17: 8 in 04h-06h, 0Dh, 0Eh, 13h; 14 in 0Fh, 10h; 16 in 11h, 12h).
- **Graphics font**: in modes 04h-06h the 8x8 patterns of codes 00h-7Fh are at the INT 43h vector
  (0000:010Ch) and those of 80h-FFh at the INT 1Fh vector (0000:007Ch), at (code - 80h) * 8; in the other
  graphics modes INT 43h points to all 256 patterns, 0040:0085h bytes each (Ferraro 6.7.6, 6.7.12, 7.1.5,
  7.1.6; RBIL INT 1F "SYSTEM DATA", INT 43 "VIDEO DATA").

### AH=01h: set cursor shape

Sets the first and last scan line of the text cursor, scaled to the character height when cursor
emulation is on.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B01-1 | Input CH = start line (bits 4-0) and cursor options (bits 6-5), CL = end line (bits 4-0). Nothing is returned | Ferraro 11.3.1; RBIL INT 10/AH=01h (#00013); VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=01/02/03 cursor + emulation' |
| B01-2 | CX is stored as given in 0040:0060h (CL, end line, at 0060h; CH, start line, at 0061h), before any scaling: AH=03h returns the caller's value, not the one written to the CRTC. There is one shape for all pages | Ferraro 11.3.1 (host memory 460h/461h), 9.3 table; RBIL INT 10/AH=01h note ("returns unmapped cursor shape"); RBIL MEM 0040:0060h | must | S3COMPAT 'AH=01/02/03 cursor + emulation' fail 2 (0607h back after emulation) |
| B01-3 | The shape goes to CR0Ah (cursor start: bits 4-0, bit 5 = cursor off) and CR0Bh (cursor end: bits 4-0). With cursor emulation off (0040:0087h bit 0 = 1, set by AX=1201h BL=34h) the values go there unchanged: CX = 0607h gives CR0Ah = 06h, CR0Bh = 07h | Ferraro 11.3.1 ("Registers Affected: Cursor Start, Cursor End"), 11.13.7; RBIL MEM 0040:0087h bit 0; RBIL INT 10/AH=12h BL=34h | must | S3COMPAT 'AH=01/02/03 cursor + emulation' fail 8 |
| B01-4 | With cursor emulation on (0040:0087h bit 0 = 0) in a text mode, CX is taken as a shape in an 8-line CGA cell and scaled to the character height (0040:0085h) before it goes to CR0Ah/CR0Bh. The IBM values: CX = 0607h (CGA underline) in mode 03h at 400 lines (16-line font) gives CR0Ah = 0Dh, CR0Bh = 0Eh | IBM (VGATEST); Ferraro 11.13.7, 6.6.3; RBIL INT 10/AH=12h BL=34h ("remap cursor start/end according to the current character height in text modes") | must | S3COMPAT 'AH=01/02/03 cursor + emulation' fail 1; v2-ref-compare (AX=0100h CX=0607h in modes 00h-07h, 0Dh-10h) |
| B01-5 | Scaling classes under emulation (Ferraro): a cursor-off request (CH bit 5 = 1) and an overbar (start and end both 3 or less) are not changed; an underline (end at most start + 2) is moved to the bottom lines of the cell; a full block (start 2 or less) gets its end on the last line of the cell; a half block (start above 2) starts at half the cell height and ends on the last line | Ferraro 11.13.7 tables 11.23 and 11.24 (the scan of the tables is garbled; read with 6.6.3) | should | only CX = 0607h (S3COMPAT); v2-ref-compare for 0607h |
| B01-6 | On a VGA a start line greater than the end line shows no cursor (on an EGA the cursor wraps into two parts); the BIOS writes such a value without correcting it | Ferraro 11.3.1, 6.6.3 | note | not checked |
| B01-7 | CH bits 6-5 = 01b (for example CX = 2000h) hides the cursor: CR0Ah bit 5 = 1 | RBIL (#00013); Ferraro 11.3.1 (Cursor On/Off field) | should | not checked |
| B01-8 | In graphics modes no cursor is shown; the shape is still stored in 0040:0060h | Ferraro 11.3.1 | should | not checked |

### AH=02h: set cursor position

Sets the cursor of one page; the hardware cursor follows when that page is displayed.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B02-1 | Input BH = page, DH = row, DL = column. DL goes to 0040:0050h + 2*BH, DH to 0040:0051h + 2*BH. Nothing is returned | Ferraro 11.3.2; RBIL INT 10/AH=02h; RBIL MEM 0040:0050h; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=01/02/03 cursor + emulation' fail 4; v2-ref-compare |
| B02-2 | When BH is the active page (0040:0062h) in a text mode, the cursor location CR0Eh (high byte) / CR0Fh (low byte) becomes 0040:004Eh / 2 + DH * 0040:004Ah + DL (the page start in characters plus the position in the page), at the CRTC of 0040:0063h | Ferraro 11.3.2 ("Registers Affected: Cursor Location High, Cursor Location Low"), 11.3.3 | must | S3COMPAT 'AH=01/02/03 cursor + emulation' fail 4 (mode 03h: 5*80+16); emu t_mono (mode 07h, CRTC at 3B4h) |
| B02-3 | For a page other than the active one only the BIOS data area changes; the hardware cursor stays where it is (the cursor of a page that is not displayed is not visible) | Ferraro 11.3.2 | must | not checked |
| B02-4 | Eight positions are kept, one per page 0-7, whatever the mode; RBIL names the pages 0-7 in modes 00h/01h, 0-3 in 02h/03h (CGA) and 0 in graphics modes | Ferraro 11.3.2 ("eight sections"); RBIL INT 10/AH=02h | should | not checked |
| B02-5 | In graphics modes the position is kept although no cursor is shown: AH=08h, 09h, 0Ah, 0Eh and 13h use it | Ferraro 11.3.1, 11.3.2 | must | S3COMPAT 'AH=09/08 graphics char mode 04/0D/12/13' |

### AH=03h: read cursor position and shape

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B03-1 | Input BH = page. Output DH = row, DL = column from 0040:0050h + 2*BH; CH = start line, CL = end line from 0040:0060h (the value given to AH=01h, B01-2) | RBIL INT 10/AH=03h; VGADOC VGABIOS.TXT; Ferraro 11.3.3 | must | S3COMPAT 'AH=01/02/03 cursor + emulation' fail 2, 4 |
| B03-2 | The position comes from the BIOS data area, not from CR0Eh/CR0Fh, so the cursor of a page that is not displayed comes back as set | Ferraro 11.3.3 | must | not checked |
| B03-3 | AX on return: Phoenix BIOSes return AX = 0000h; a program must not rely on it | RBIL INT 10/AH=03h; VGADOC VGABIOS.TXT | note | not checked |
| B03-4 | Many BIOSes return the colour default 0607h while a monochrome display is attached (RBIL: a bug); the rule is B03-1, the stored value | RBIL INT 10/AH=03h note | note | not checked |

### AH=04h: read light pen position

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B04-1 | The VGA has no light pen: the BIOS returns AH = 00h (pen not triggered) | Ferraro 11.4.1 ("available for the EGA only"); RBIL INT 10/AH=04h "(except VGA)"; VGADOC VGABIOS.TXT "(EGA Only)" | must | S3COMPAT 'AH=04 light pen not present' |
| B04-2 | With AH = 00h, BX, CX and DX carry no data. On an EGA with AH = 01h: DH, DL = character row, column; CH = pixel row (modes 04h-06h) or CX = pixel row (modes with more than 200 lines); BX = pixel column | RBIL INT 10/AH=04h; Ferraro 11.4.1 | note | not checked |

### AH=05h: select active display page

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B05-1 | Input AL = page. The BIOS sets 0040:0062h = AL and 0040:004Eh = AL * 0040:004Ch, and the CRTC start address CR0Ch (high) / CR0Dh (low) to 0040:004Eh in byte mode (CR17h bit 6 = 1, the planar modes) or 0040:004Eh / 2 in word mode (CR17h bit 6 = 0, the text modes). Nothing is returned | Ferraro 11.5.1; RBIL INT 10/AH=05h; RBIL MEM 0040:004Eh, 0040:0062h | must | S3COMPAT 'AH=05 pages (mode 03 p3, mode 0D p7)' fail 1, 2; v2-ref-compare |
| B05-2 | Page starts are multiples of the page length: mode 03h page 3 at 3000h (length 1000h), mode 0Dh page 7 at E000h (length 2000h) | IBM (VGATEST); Ferraro 7.3.2 tables 7.7 and 7.9 | must | S3COMPAT 'AH=05 pages (mode 03 p3, mode 0D p7)' fail 2 |
| B05-3 | The hardware cursor moves to the saved position of the new page (0040:0050h + 2*AL), computed as in B02-2 | Ferraro 11.3.3 ("the Cursor Location Registers store the location of the cursor associated with the current display page") | must | v2-ref-compare (AX=0501h, 0500h: CR00-18h against 2.04.07) |
| B05-4 | Video memory is not changed: the new page shows what was written to it before | Ferraro 11.5.1 | must | v2-ref-compare (video memory after AX=0501h) |
| B05-5 | Pages per mode: 8 in 00h/01h, 8 in 02h/03h and 07h on EGA/VGA (4 on a CGA), 8 in 0Dh, 4 in 0Eh, 2 in 0Fh and 10h, 1 in 04h-06h and 11h-13h | Ferraro tables 7.7, 7.8, 7.9; RBIL (#00010) | should | S3COMPAT 'AH=05 pages' (mode 03h page 3, mode 0Dh page 7) |
| B05-6 | A page number the mode does not have: what the BIOS does is not defined; RBIL tells programs to read the page back with AH=0Fh | RBIL INT 10/AH=05h note | note | not checked |

### AH=06h and AH=07h: scroll a window up or down

AH=06h scrolls up, AH=07h down, on the active page; AL=0 clears the window.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B06-1 | Input AL = number of lines, BH = fill attribute (text) or colour (graphics), CH, CL = row, column of the upper-left corner, DH, DL = row, column of the lower-right corner, both inclusive, in character cells. AH=06h moves the contents of the window up by AL rows and blanks the AL rows at its bottom; AH=07h moves them down and blanks the AL rows at its top. Nothing is returned | Ferraro 11.6.1, 11.6.2; RBIL INT 10/AH=06h, 07h; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=06/07 scroll full and window'; S3TEST 'Text scroll AH=06h/07h cells'; v2-ref-compare (AL = 0, 1, 2, 5, random windows) |
| B06-2 | AL = 0 blanks the whole window | Ferraro 11.6.1, 11.6.2; RBIL INT 10/AH=06h, 07h | must | S3TEST 'Text scroll AH=06h/07h cells', 'Planar scroll 12h/0Dh AH=06h/07h' (fail 10h, 20h), 'Mode 13h scroll AH=06h/07h/0Eh' (fail 8); S3COMPAT 'AH=06/07 CGA graphics scroll 04h/06h' (fail 8) |
| B06-3 | Text modes: a blank cell is the character 20h with attribute BH, at B800h (B000h in mode 07h) | Ferraro 11.6.1 ("blank lines with a new attribute"); RBIL INT 10/AH=06h | must | S3COMPAT 'AH=06/07 scroll full and window'; emu t_mono (mode 07h, every cell) |
| B06-4 | Only the window changes: every cell (text) or byte of every plane (graphics) outside it keeps its value | Ferraro 11.6.1 ("without disturbing the rest of the screen") | must | S3TEST 'Text scroll AH=06h/07h cells', 'Planar scroll 12h/0Dh AH=06h/07h', 'Mode 13h scroll AH=06h/07h/0Eh' (every cell, byte or pixel); emu t_mono |
| B06-5 | The page scrolled is the active page (from 0040:004Eh); there is no page input | RBIL INT 10/AH=06h, 07h note; VGADOC VGABIOS.TXT | must | not checked on pages other than 0 |
| B06-6 | Graphics modes: the window is in cells (8 pixels wide, 0040:0085h scan lines high); every scan line and every plane of a cell moves with it. In mode 13h a cell is 8 bytes by 8 lines; in modes 04h/05h 2 bytes by 8 lines, in 06h 1 byte by 8 lines, 4 lines in each interleaved half of B800h | Ferraro 11.6.1, 6.7.12 table 6.17, 7.4.3 | must | S3COMPAT 'AH=06/07 CGA graphics scroll 04h/06h'; S3TEST 'Planar scroll 12h/0Dh AH=06h/07h', 'Mode 13h scroll AH=06h/07h/0Eh'; emu t_mono (mode 0Fh); v2-ref-compare |
| B06-7 | Graphics fill: BH is the colour of the blank pixels. Planar modes: each byte of the blank area is FFh in the planes whose bit in BH is 1 and 00h in the others; mode 13h: each byte is BH | Ferraro 11.6.1 (BH fills the new lines); RBIL INT 10/AH=06h | must | S3TEST 'Planar scroll 12h/0Dh AH=06h/07h' (every byte of the four planes), 'Mode 13h scroll AH=06h/07h/0Eh' |
| B06-8 | Modes 04h-06h: BH is stored as a byte in every byte of the blank area, so in 04h/05h it is a pattern of four 2-bit pixels (BH = 55h: colour 1 everywhere) and in 06h of eight 1-bit pixels | IBM (VGATEST) | should | S3COMPAT 'AH=06/07 CGA graphics scroll 04h/06h' (every byte of B800h); v2-ref-compare |
| B06-9 | BX, CX, DX, SI, DI, BP, DS and ES come back as the caller gave them (RBIL names destroying BP a bug) | RBIL INT 10/AH=06h, 07h BUGS | should | v2-ref-compare (registers against 2.04.07); emu t_rom_patches (bits 31-16 of EAX, ECX, ESI, EDI) |

### AH=08h: read character and attribute at the cursor

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B08-1 | Input BH = page. Text modes: AL = character, AH = attribute of the cell at the cursor of page BH, read from B800h (B000h in mode 07h) + BH * 0040:004Ch + 2 * (row * 0040:004Ah + column) | Ferraro 11.7.1; RBIL INT 10/AH=08h; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=08/09/0A/0E text I/O mode 01/03'; emu t_mono (mode 07h: 7051h); v2-ref-compare |
| B08-2 | Graphics modes: the BIOS compares the pixels of the cell at the cursor with the patterns of the graphics font and returns the code of the first that matches in AL; AL = 00h when none matches | Ferraro 11.7.1; RBIL INT 10/AH=08h note | must | S3COMPAT 'AH=09/08 graphics char mode 04/0D/12/13'; emu t_mono (mode 0Fh) |
| B08-3 | The patterns compared are those of the graphics font (see the terms above): in modes 04h-06h codes 00h-7Fh from INT 43h and 80h-FFh from INT 1Fh, in the other graphics modes 256 codes from INT 43h | Ferraro 11.7.1, 6.7.12, 7.1.5; RBIL INT 43 | should | codes below 80h only (S3COMPAT 'AH=09/08 graphics char mode 04/0D/12/13') |
| B08-4 | A cell of background pixels only reads as 00h, not 20h: a space cannot be read in a graphics mode | Ferraro 11.7.1 ("Reading a Space") | should | v2-ref-compare (modes 04h-06h, 0Dh-10h) |
| B08-5 | A pixel counts as part of the character when its colour is not 0: a glyph written by AH=09h in colour 3 reads back in modes 04h, 0Dh, 12h and 13h | IBM (VGATEST); Ferraro 11.7.1 (colour compare) | should | S3COMPAT 'AH=09/08 graphics char mode 04/0D/12/13' |
| B08-6 | Graphics modes return no attribute: AH has no defined value | Ferraro 11.7.1; RBIL INT 10/AH=08h ("text mode only") | note | not checked |
| B08-7 | BX, CX, DX, SI, DI, BP, DS and ES come back as given (RBIL: some BIOSes destroy BP in graphics modes, some clones SI or DI, and DOS saves them for that reason) | RBIL INT 10/AH=08h notes and BUG | should | v2-ref-compare |

### AH=09h: write character and attribute at the cursor

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B09-1 | Input AL = character, BL = attribute (text) or colour (graphics), BH = page, CX = count. The character is written CX times from the cursor of page BH; the cursor does not move. Nothing is returned | Ferraro 11.7.2; RBIL INT 10/AH=09h; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=08/09/0A/0E text I/O mode 01/03' fail 1; S3TEST 'AH=09h text char/attribute count'; emu t_mono |
| B09-2 | Text modes: CX consecutive cells get character AL and attribute BL; a count that runs past the end of the row continues at the start of the next row (the cells follow each other in memory). Every other cell keeps its value | IBM (VGATEST, as S3TEST encodes it); Ferraro 11.7.2 | must | S3TEST 'AH=09h text char/attribute count' (CX = 1, 2, 3, 5, 80, every cell); S3COMPAT 'AH=08/09/0A/0E text I/O mode 01/03' |
| B09-3 | Control codes are not interpreted: 07h, 08h, 0Ah and 0Dh are written as characters, and the cursor does not move | RBIL INT 10/AH=09h note | must | v2-ref-compare (random AL) |
| B09-4 | The page need not be the active one: the cells are on page BH (B800h + BH * 0040:004Ch in text modes) | Ferraro 11.7.2; RBIL INT 10/AH=09h | must | S3TEST 'AH=09h text char/attribute count' fail 20h (page 1) |
| B09-5 | Graphics modes: the pattern of AL comes from the graphics font (terms above) and fills the cell at the cursor, one font byte per scan line | Ferraro 7.1.5, 7.1.6, 11.7.2 | must | S3COMPAT 'AH=09/0A graphics glyph and XOR' (the glyph of AX=1130h), 'Video save pointer table 0040:00A8' (graphics font override) |
| B09-6 | Graphics modes, BL bit 7 = 0: the whole cell is replaced. Pixels whose font bit is 1 get the colour (BL bits 1-0 in 04h/05h, bit 0 in 06h, bits 3-0 in the planar modes), pixels whose font bit is 0 get colour 0 | IBM (VGATEST, as S3COMPAT encodes it); Ferraro 11.7.2 differs (see "Sources disagree") | should | S3COMPAT 'AH=09/0A graphics glyph and XOR' fail 1, 2, 4, 8 (modes 04h, 06h, 0Dh, 12h); v2-ref-compare |
| B09-7 | Graphics modes other than 13h, BL bit 7 = 1: the colour is XORed into the pixels whose font bit is 1; the other pixels keep their value. Writing the same character twice so restores the cell | Ferraro 11.7.2, 7.1.7; RBIL INT 10/AH=09h | must | S3COMPAT 'AH=09/0A graphics glyph and XOR' |
| B09-8 | Mode 13h: BL is the 8-bit colour of the character pixels; bit 7 is part of the colour, not an XOR flag | RBIL INT 10/AH=09h ("in <256-color graphics mode") | should | not checked |
| B09-9 | Graphics modes: the CX cells follow each other to the right along the row; a count larger than the cells left in the row gives an undefined picture | Ferraro 11.7.2; RBIL INT 10/AH=09h note; VGADOC VGABIOS.TXT | note | not checked |
| B09-10 | Graphics modes with more than one page (0Dh, 0Eh, 0Fh, 10h): the cell is on page BH (A000h + BH * 0040:004Ch); in modes with one page BH selects nothing | Ferraro 11.7.2 | should | not checked |
| B09-11 | BX, CX, DX, SI, DI, BP, DS and ES come back as given | RBIL INT 10/AH=08h notes (the same dispatcher) | should | v2-ref-compare; emu t_rom_patches (bits 31-16) |

### AH=0Ah: write character only at the cursor

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B0A-1 | As AH=09h (B09-1, B09-2, B09-3, B09-4), but in text modes only the character byte of each cell is written; the attribute bytes keep their values and BL is not used | Ferraro 11.7.3; RBIL INT 10/AH=0Ah; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=08/09/0A/0E text I/O mode 01/03' fail 2; v2-ref-compare |
| B0A-2 | Graphics modes: exactly as AH=09h (B09-5 to B09-10): BL is the colour and bit 7 the XOR flag | Ferraro 11.7.3; RBIL INT 10/AH=0Ah | must | S3COMPAT 'AH=09/0A graphics glyph and XOR' (AH=0Ah writes the glyph too) |

### AH=0Ch: write pixel

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B0C-1 | Input AL = colour, BH = page, CX = column, DX = row, in pixels from the upper-left corner. One pixel is written; the cursor and the active page do not change. Nothing is returned. The function is for graphics modes only | Ferraro 11.9.1; RBIL INT 10/AH=0Ch; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=0C/0D pixels mode 04/06/0D/0E/10/11/12/13'; emu t_mono (mode 0Fh); v2-ref-compare |
| B0C-2 | Mode 13h: AL (all 8 bits) is stored at A000:(DX * 320 + CX); there is no XOR | RBIL INT 10/AH=0Ch ("except in 256-color modes"); IBM (VGATEST) | must | S3COMPAT 'AH=0C/0D pixels mode 13' fail 4 |
| B0C-3 | Modes 04h/05h: AL bits 1-0, mode 06h: AL bit 0, go into the packed byte of the pixel at B800h (B800:0000h for even DX, B800:2000h for odd DX, 80 bytes a line, CX / 4 or CX / 8 bytes in) | Ferraro 7.4.3, 7.4.4, 7.4.6 | must | S3COMPAT 'AH=0C/0D pixels mode 04/06' |
| B0C-4 | Planar modes: AL bits 3-0 are the pixel's bits in planes 0-3, at byte DX * bytes per line + CX / 8, bit 7 - (CX mod 8); only the planes the Map Mask register enables are changed | Ferraro 11.9.1; Ferraro 7.4.10-7.4.14 | must | S3COMPAT 'AH=0C/0D pixels mode 0D/0E/10/11/12'; emu t_mono (mode 0Fh, colours 0, 1, 4, 5) |
| B0C-5 | AL bit 7 = 1 (all modes but 13h): the colour bits are XORed into the pixel; writing the same value twice restores it | RBIL INT 10/AH=0Ch; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=0C/0D pixels mode ...' fail 2 |
| B0C-6 | Modes with more than one page (0Dh, 0Eh, 0Fh, 10h): the pixel is on page BH, BH * 0040:004Ch bytes into A000h, displayed or not. In modes with one page BH is ignored | Ferraro 11.9.1; RBIL INT 10/AH=0Ch note; VGADOC VGABIOS.TXT | should | not checked (page 0 only) |
| B0C-7 | In text modes the function is not defined | RBIL INT 10/AH=0Ch ("valid only in graphics modes") | note | not checked |

### AH=0Dh: read pixel

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B0Dh-1 | Input BH = page, CX = column, DX = row. Output AL = the colour of the pixel: the byte in mode 13h, 0-3 in modes 04h/05h, 0-1 in 06h, the bits of planes 0-3 as bits 0-3 in the planar modes (the pixel addressed as in B0C-2 to B0C-4) | Ferraro 11.9.2; RBIL INT 10/AH=0Dh; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=0C/0D pixels mode ...' fail 1; emu t_mono; v2-ref-compare |
| B0D-2 | The page is chosen as in B0C-6: a pixel of a page that is not displayed can be read | Ferraro 11.9.2 | should | not checked |
| B0D-3 | Graphics modes only (as B0C-7) | RBIL INT 10/AH=0Dh | note | not checked |

### AH=0Eh: teletype output

Writes one character at the cursor and moves the cursor on, as a terminal does.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B0E-1 | Input AL = character, BL = foreground colour (graphics modes only), BH = page (see B0E-2). A printable character is written at the cursor and the cursor moves one column right. Nothing is returned | Ferraro 11.9.3; RBIL INT 10/AH=0Eh; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=08/09/0A/0E text I/O mode 01/03' fail 4; emu t_mono |
| B0E-2 | The character goes to the active page (0040:0062h) at its cursor | Ferraro 11.9.3 ("on the active page"); RBIL INT 10/AH=0Eh (BH = page; IBM ROMs of 1981 need BH = the active page) | should | v2-ref-compare (random BH in modes 00h-07h, 0Dh-10h) |
| B0E-3 | Text modes: only the character byte is written; the attribute of the cell keeps its value | Ferraro 11.9.3 | must | emu t_mono (5A70h after AH=09h left attribute 70h); v2-ref-compare |
| B0E-4 | Graphics modes: the character is drawn in colour BL as AH=09h with CX = 1 draws it | Ferraro 11.9.3; RBIL INT 10/AH=0Eh | must | v2-ref-compare (modes 04h-06h, 0Dh-10h) |
| B0E-5 | After a printable character in the last column (0040:004Ah - 1) the cursor goes to column 0 of the next row | Ferraro 11.9.3 | must | S3COMPAT 'AH=13h write string' fail 10h (the same handling) |
| B0E-6 | CR (0Dh): the cursor goes to column 0 of the same row; nothing is written | RBIL INT 10/AH=0Eh ("do the expected things"); IBM (VGATEST, as S3COMPAT encodes it); Ferraro table 11.4 differs (see "Sources disagree") | must | S3COMPAT 'AH=13h write string' fail 1 |
| B0E-7 | LF (0Ah): the cursor goes one row down in the same column; nothing is written | Ferraro 11.9.3 table 11.4 | must | S3COMPAT 'AH=13h write string' fail 1 |
| B0E-8 | BS (08h): the cursor goes one column left, not past column 0; nothing is written or erased | Ferraro 11.9.3 table 11.4 | must | S3COMPAT 'AH=13h write string' fail 1 |
| B0E-9 | BEL (07h): the speaker sounds; nothing is written and the cursor stays | Ferraro 11.9.3 table 11.4; RBIL INT 10/AH=0Eh | must | S3COMPAT 'AH=13h write string' fail 1 (BEL not written) |
| B0E-10 | A line feed on the last row (0040:0084h), or a wrap past the last column of the last row, scrolls the whole screen (rows 0 to 0040:0084h, columns 0 to 0040:004Ah - 1) of the active page up one line; the cursor stays on the last row | Ferraro 11.9.3; RBIL MEM 0040:0084h | must | S3COMPAT 'AH=13h write string' fail 20h; S3TEST 'Mode 13h scroll AH=06h/07h/0Eh' fail 10h |
| B0E-11 | Text modes: the new line gets the attribute of the far-left character of the bottom line (one attribute a line is assumed) | Ferraro 11.9.3 table 11.4 | should | v2-ref-compare |
| B0E-12 | The new cursor is stored in 0040:0050h + 2 * page and, in text modes, written to CR0Eh/CR0Fh as AH=02h does | Ferraro 11.9.3 | must | S3COMPAT 'AH=08/09/0A/0E text I/O mode 01/03' fail 4 |
| B0E-13 | BX, CX, DX, SI, DI, BP, DS and ES come back as given, also when the screen scrolled (RBIL: destroying BP there is a bug) | RBIL INT 10/AH=0Eh BUG | should | S3TEST 'Mode 13h scroll AH=06h/07h/0Eh' fail 10h (EAX bits 31-16); emu t_rom_patches; v2-ref-compare |

### AH=13h: write string

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B13-1 | Input AL = write mode (bit 0: move the cursor, bit 1: the string holds character, attribute pairs), BH = page, BL = attribute (AL bit 1 = 0), CX = number of characters, DH, DL = row, column of the first character, ES:BP = string. Nothing is returned | RBIL INT 10/AH=13h; Ferraro 11.14.1 table 11.25; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=13h write string' |
| B13-2 | AL = 0 or 1: every printable character is written with attribute BL (character and attribute, as AH=09h with CX = 1). AL = 2 or 3: each printable character is followed in the string by its attribute byte, and is written with it | Ferraro 11.14.1; RBIL INT 10/AH=13h | must | S3COMPAT 'AH=13h write string' fail 1, 8 |
| B13-3 | CR, LF, BS and BEL act as in AH=0Eh (B0E-6 to B0E-9) and are not written; with AL = 2 or 3 they have no attribute byte: the next byte is the next character | Ferraro 11.14.1; RBIL INT 10/AH=13h ("recognizes CR, LF, BS, and bell") | must | S3COMPAT 'AH=13h write string' fail 1, 8 |
| B13-4 | CX counts characters, control characters included, not bytes | RBIL INT 10/AH=13h; Ferraro 11.14.1 | must | S3COMPAT 'AH=13h write string' |
| B13-5 | Writing starts at DH, DL on page BH, which need not be the displayed page; other pages are not written | Ferraro 11.14.1 ("directs the output to the selected page"); RBIL INT 10/AH=13h | must | S3COMPAT 'AH=13h write string' fail 40h (page 1) |
| B13-6 | The cursor moves on as in AH=0Eh: wrap at the end of a row, and a line feed or wrap on the last row scrolls the screen up one line | Ferraro 11.14.1 | must | S3COMPAT 'AH=13h write string' fail 10h, 20h |
| B13-7 | AL bit 0 = 1: the cursor of page BH is left after the last character (0040:0050h + 2*BH; CR0Eh/CR0Fh when BH is the active page). AL bit 0 = 0: the cursor of page BH is as it was before the call | Ferraro 11.14.1 table 11.25; RBIL INT 10/AH=13h | must | S3COMPAT 'AH=13h write string' fail 2, 4, 40h |
| B13-8 | When the string scrolls, the IBM VGA scrolls the active page, also when BH names another page | RBIL INT 10/AH=13h BUG; Ferraro 11.14.1 | note | not checked |
| B13-9 | Graphics modes: printable characters are drawn as AH=09h draws them, in colour BL (or the attribute byte) | RBIL INT 10/AH=13h; Ferraro 11.14.1 | should | S3COMPAT 'AH=13h write string' fail 80h (mode 12h: the character reads back with AH=08h) |
| B13-10 | AL bits 7-2 are reserved (0); IBM documents AL = 10h, 11h, 20h and 21h as private | RBIL INT 10/AH=13h | note | not checked |

### Open questions

Behaviour to confirm in the emulator (our ROMs against the reference BIOSes):

1. AH=01h with emulation on: what goes to CR0Ah/CR0Bh for a start line above the end line, for CL = 0,
   for CH or CL of 20h or more, for the 8-line fonts of the 200-line modes and for the 14-line fonts?
2. AH=01h: does CH with bits 6-5 = 10b or 11b (40h-7Fh) hide the cursor (RBIL #00013) or show it at CH
   bits 4-0? Are CR0Bh bits 6-5 (cursor skew) written as 0?
3. AH=01h in a graphics mode: is the value scaled, and are CR0Ah/CR0Bh written at all?
4. Which functions of this group return AX as given? (Some BIOSes return values in AX after AH=01h,
   02h, 05h, 06h, 07h, 09h, 0Ah or 13h, for example the attribute or a CRTC index.)
5. AH=02h and AH=03h in modes 04h-06h with BH not 0: which page's position is stored and returned?
6. AH=02h: are a row past 0040:0084h or a column past 0040:004Ah - 1 stored unchanged, and what goes to
   CR0Eh/CR0Fh? In graphics modes, are CR0Eh/CR0Fh written?
7. AH=03h with BH above 7: what comes back?
8. AH=04h: do BX, CX and DX come back as given when AH = 00h?
9. AH=05h with a page the mode does not have (AL above the page count, or above 7, or above 0 in modes
   04h-06h and 11h-13h): is it refused (0040:0062h unchanged) or taken?
10. AH=06h/07h with AL larger than the window height: is the whole window blanked as with AL = 0?
11. AH=06h/07h with the lower-right corner beyond the screen, or the upper-left corner below or right of
    the lower-right one: is the window clipped, ignored, or written past the screen?
12. AH=06h/07h in mode 13h: is the cell height 8 whatever 0040:0085h holds? In the planar modes, are BH
    bits 7-4 ignored, and which values do SR02h and GR00h-GR08h hold afterwards?
13. AH=06h/07h and AH=13h: is the result the same when the caller's direction flag is set? (emu
    t_errors requires it of our ROMs.)
14. AH=08h in modes 04h-06h while the INT 1Fh vector is 0000:0000h: are codes 80h-FFh compared at all?
15. AH=08h in graphics modes: is AH returned as 00h? Are GR05h and GR07h (read mode, colour don't care)
    back at their mode-set values afterwards?
16. AH=09h and AH=0Ah with CX = 0: is nothing written, or 65536 characters?
17. AH=09h and AH=0Ah in text modes with a count that runs past the end of the page or of the video
    buffer: where do the extra cells go?
18. AH=09h in the planar modes: are all four planes written whatever the Map Mask register holds
    (Ferraro 11.7.2 says only the enabled planes), and which value does SR02h hold afterwards?
19. AH=09h in mode 13h: do the background pixels of the cell get colour 0, colour BH (as RBIL reports of
    the ET4000 BIOS), or keep their value? Is BH ignored as a page there?
20. AH=09h in modes 04h-06h for codes 80h-FFh while the INT 1Fh vector is 0000:0000h: which pattern is
    drawn?
21. AH=09h, 0Ah, 0Ch, 0Dh in graphics modes with more than one page: is page BH honoured in modes 0Dh,
    0Eh, 0Fh and 10h?
22. AH=0Ch and AH=0Dh in a text mode: is anything written, and what is AL after AH=0Dh?
23. AH=0Ch and AH=0Dh with CX or DX outside the screen: is the pixel written into the memory past the
    page (or the next line), or refused?
24. AH=0Dh: what is AH on return?
25. AH=0Eh: does BH select the page, or is the active page always used? In modes 04h-06h?
26. AH=0Eh in text modes when the screen scrolls: is the fill attribute that of the far-left character
    of the bottom line (Ferraro), or that of the cell at the cursor after the line feed? In graphics
    modes, is the new line filled with colour 0?
27. AH=0Eh in graphics modes: does BL bit 7 XOR the character as in AH=09h?
28. AH=0Eh BEL: what frequency and duration, and are the PIT channel 2 and port 61h left as found?
29. AH=0Eh with the cursor below the last row (row above 0040:0084h): does the screen scroll, and where
    does the cursor end?
30. AH=13h with CX = 0, or with AL bits 7-2 not 0: is nothing done, the cursor unchanged?
31. AH=13h to a page that is not displayed: when the string scrolls, from which page does the fill
    attribute come, and where does that page's cursor end?
32. AH=13h: do ES and BP come back as given?
33. Do all functions of this group keep bits 31-16 of the 32-bit registers? (v2-ref-compare, S3TEST and
    emu t_rom_patches check some of them.)

### Sources disagree

1. CR in AH=0Eh: Ferraro table 11.4 moves the cursor to column 0 of the next line; RBIL and VGADOC say
   only "do the expected things", and the IBM behaviour S3COMPAT encodes is column 0 of the same row.
   B0E-6 follows the IBM behaviour (a CR LF pair would otherwise skip a line).
2. The page of AH=0Eh: Ferraro writes on the active page; RBIL and VGADOC list BH = page number (and the
   1981 IBM PC ROMs need BH to be the active page). B0E-2 follows Ferraro; open question 25.
3. The page of AH=13h: Ferraro 11.14.1 lists BH as the page the output goes to, but its text says that on
   an 80286 AT BH is ignored and the active page written; RBIL says BH is the page and only the scroll
   acts on the active page (an IBM VGA bug). B13-5 and B13-8 follow RBIL and Ferraro's parameter list.
4. The background of a character in graphics modes (AH=09h/0Ah): Ferraro 11.7.2 says background pixels
   are not written ("writing a space ... has no effect"); the IBM behaviour S3COMPAT encodes writes them
   as colour 0 when bit 7 is clear. B09-6 follows IBM.
5. XOR in mode 13h: RBIL limits the XOR bit of AH=09h, 0Ah and 0Ch to graphics modes with fewer than 256
   colours; VGADOC says "in graphics mode". B09-8 and B0C-2 follow RBIL.
6. Matching in AH=08h: RBIL says only characters drawn with white pixels are matched in graphics modes;
   Ferraro describes a compare against the background colour, and S3COMPAT reads back a character drawn in
   colour 3 in modes 04h, 0Dh, 12h and 13h. B08-5 follows Ferraro and S3COMPAT.
7. The count of AH=09h/0Ah in text modes: Ferraro limits it to the end of the page; RBIL is silent;
   S3TEST, after the IBM BIOS, lets a count run on into the next rows. B09-2 follows S3TEST within the
   page; open question 17 asks about the end of the page.
8. The upper 128 characters in graphics modes: Ferraro 11.7.1 and 11.7.2 say only codes 00h-7Fh are
   reachable through the BIOS font in graphics modes unless INT 1Fh is set, without naming modes; Ferraro
   6.7.12 and 7.1.5 limit INT 1Fh to modes 04h-06h; RBIL INT 43 says the vector holds codes 00h-7Fh "in
   8x8 dot modes" (which would include 0Dh, 0Eh and 13h). The rules follow Ferraro 6.7.12 and 7.1.5: INT
   43h holds all 256 codes outside modes 04h-06h.
9. AH=03h input: Ferraro 11.3.3 lists no input register; RBIL and VGADOC take the page in BH. B03-1
   follows RBIL.
10. AH=04h outputs: Ferraro 11.4.1 calls BX the "vertical pixel column" and CX the "horizontal pixel
    raster line" and does not separate CH from CX; RBIL gives CH (modes 04h-06h) or CX (more than 200
    lines) as the pixel row and BX as the pixel column. B04-2 follows RBIL; a VGA returns AH = 00h anyway.
11. CH bits 6-5 of AH=01h: RBIL (#00013) says any value other than 00b hides the cursor on EGA/VGA, while
    the VGA CRTC has only one cursor-off bit (CR0Ah bit 5, Ferraro 6.6.3). B01-7 covers 01b only; open
    question 2.
12. Pages of modes 02h/03h: VGADOC's mode table gives 4 pages (an EGA line); Ferraro table 7.9 and RBIL
    (#00010) give 8 on EGA and VGA. B05-5 follows Ferraro and RBIL.

## Colours: AH=0Bh and AH=10h

The functions that set and read the colour registers: the CGA palette call AH=0Bh, the attribute
controller palette registers (AX=1000h-1009h) and the DAC colour registers (AX=1010h-101Bh). Terms
used below: ARxx is attribute controller register xx (written through port 3C0h, read through 3C1h);
PAS is bit 5 of the attribute address register at 3C0h (palette address source); the DAC is the
256-entry colour table at 3C7h-3C9h; the dynamic save area is the buffer that the doubleword at offset
04h of the save pointer table (0040:00A8h) points to, when that doubleword is not zero.

The S3COMPAT lines named below also run in the emulator (emu t_s3compat_vga). `make v2-ref-compare`
compares the ROM with the unpatched reference BIOS, not with IBM: it finds regressions, it does not
prove IBM behaviour.

### INT 10h AH=0Bh: CGA background, border and palette

Sets the background and border colour (BH=00h) or selects one of the two CGA palettes (BH=01h), as
the CGA colour select register (3D9h) did.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B0B-1 | Input BH=00h: BL bits 3-0 = colour (bit 0 blue, 1 green, 2 red, 3 intensity), BL bit 4 = intensity select (in 320x200 graphics: the intensified foreground colours). BH=01h: BL = palette ID, 00h background/green/red/brown, 01h background/cyan/magenta/white. No output | RBIL INT 10/AH=0Bh/BH=00h and BH=01h; Ferraro 11.8; VGADOC CGA.TXT (3D9h) | must | S3COMPAT 'AH=0B CGA background, border, palette'; make v2-ref-compare (BX=0005h and 0101h in modes 00h-07h, 0Dh-10h) |
| B0B-2 | The colour goes into the attribute registers in their RGBI coding: BL bits 2-0 as bits 2-0 and the intensity (BL bit 3) as bit 4 (BL=01h gives 01h, BL=09h gives 11h in bits 4-0) | Ferraro 11.10.1 Table 11.8 (RGBI monitor column); IBM (VGATEST) mode 04h-06h tables (intense colours 10h-17h) | should | S3COMPAT 'AH=0B ...' (BL=01h and 04h only, no BL with bit 3 set) |
| B0B-3 | BH=00h in a text mode (00h-03h, 07h): the colour goes into the border only, AR11 (overscan); AR00-0Fh are not changed | RBIL INT 10/AH=0Bh/BH=00h ("border only in text modes") | must | S3COMPAT 'AH=0B ...' fail 40h (AR11 = 04h in mode 03h; AR00 unchanged is not checked); make v2-ref-compare |
| B0B-4 | BH=00h in modes 04h and 05h: the colour goes into the background, AR00, and the border, AR11 | VGADOC CGA.TXT (3D9h in 320x200: bits 3-0 the background colour); RBIL INT 10/AH=0Bh/BH=00h | must | S3COMPAT 'AH=0B ...' fail 8 (AR00), 10h (AR11) |
| B0B-5 | BH=00h in modes 04h and 05h: BL bit 4 sets the intensity of the three foreground colours: AR01-03 become the colours of the current palette (0040:0066h bit 5) with bit 4 = BL bit 4. Palette 1, BL=01h: AR01-03 = 03h/05h/07h | VGADOC CGA.TXT (3D9h bit 4 "alt. intens. colors"); IBM (VGATEST) mode 04h (AR01-03 = 13h/15h/17h with 0066h = 30h) | should | S3COMPAT 'AH=0B ...' fail 20h |
| B0B-6 | BH=01h in modes 04h and 05h: AR01-03 = 02h/04h/06h (palette 0: green, red, brown) or 03h/05h/07h (palette 1: cyan, magenta, white), each plus 10h when the intensity bit 0040:0066h bit 4 is set. Only BL bit 0 is defined. AR00 and AR11 are not changed | Ferraro 11.8 (the colours), Ferraro Table 11.8 (coding); IBM (VGATEST) mode 04h (13h/15h/17h after the mode set) | must | S3COMPAT 'AH=0B ...' fail 1 (palette 0: 12h/14h/16h), 4 (palette 1: 13h/15h/17h) |
| B0B-7 | 0040:0066h (copy of the CGA colour select value): BH=00h replaces bits 4-0 with BL bits 4-0; BH=01h replaces bit 5 with BL bit 0. The other bits are kept | RBIL MEM 0040h:0066h (#M0019); Ferraro 11.8 ("466 hex current color"), Ferraro 9.3.2 Table 9.8 | must | S3COMPAT 'AH=0B ...' fail 2 and 4 (bit 5), 20h (bits 5-0 = 21h after BH=01h BL=01h, then BH=00h BL=01h) |
| B0B-8 | Starting point: after a mode set 0040:0066h is 30h in modes 00h-05h (palette 1, intensity) and 3Fh in modes 06h and 0Dh-13h | IBM (VGATEST) AH=1Bh state block offset 21h, which holds 0040:0066h (RBIL INT 10/AH=1Bh #00040) | must | emu t_vga_registers (state block offset 21h); S3COMPAT 'Mode nnh' lines fail 2 |
| B0B-9 | AH=1Bh state block offset 21h ("current setting of port 3x9h") returns 0040:0066h, so it follows every AH=0Bh call | RBIL INT 10/AH=1Bh (#00040) | should | not checked after AH=0Bh |
| B0B-10 | The function was made for modes 04h and 05h; in mode 06h and the EGA/VGA graphics modes (0Dh-13h) BIOSes differ, and a program should not rely on AH=0Bh there | Ferraro 11.8 (modes 4 and 5; mode 6 "in some nonstandard EGA implementations"); RBIL INT 10/AH=0Bh/BH=01h note ("newer cards support it in many or all graphics modes") | note | make v2-ref-compare (modes 06h, 0Dh-10h: the same as the reference BIOS) |
| B0B-11 | Every attribute register value AH=0Bh writes (AR00-0Fh, AR11) is also stored in the dynamic save area, when there is one (offsets 00h-0Fh, 10h; see B10-5) | RBIL MEM 0040h:00A8h (#M0045: "last data written to" the palette and overscan registers) | should | not checked |
| B0B-12 | Every register comes back as the caller gave it | RBIL INT 10/AH=0Bh ("Return: nothing") | should | make v2-ref-compare (registers against the reference BIOS) |

### INT 10h AH=10h: rules for every subfunction

What all the palette and DAC subfunctions share: the subfunction list, registers, the attribute
controller state they leave, the dynamic save area, and how grey summing and default palette loading
(AH=12h BL=33h, BL=31h) act on them.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B10-1 | Subfunctions in AL: 00h-03h, 07h-09h, 10h, 12h, 13h, 15h, 17h-1Bh. Any other AL (04h-06h, 0Ah-0Fh, 11h, 14h, 16h, 1Ch-FFh) changes nothing and returns AX and every other register unchanged | RBIL INT 10/AX=1000h-101Bh (the VGA subfunctions it lists; other AL values are vendor functions) | should | emu t_errors (AL=04h-06h, 0Bh-0Fh, 11h, 14h, 16h, 1Ch, 1Dh, 1Fh) |
| B10-2 | Only the registers named as outputs change: BH for 07h and 08h, DH/CH/CL for 15h, BL for 19h, BX for 1Ah. All others, AX included, come back as given | RBIL INT 10/AX=1000h-101Bh (returns); RBIL AX=1015h ("AX destroyed by some BIOSes") shows that BIOSes differ | should | make v2-ref-compare (AX=1000h, 1001h, 1003h, 1007h, 1010h, 1013h against the reference BIOS) |
| B10-3 | The calls that write the palette registers (AL=00h, 02h, and AH=0Bh) do it with PAS = 0, and every subfunction that selects an attribute register leaves PAS = 1 before it returns, so that the display uses the palette again (with PAS = 0 the screen shows no picture) | Ferraro 10.6.1 (PAS: 0 host access, 1 display access); VGADOC VGAREGS.TXT (3C0h bit 5) | must | not checked |
| B10-4 | A subfunction works whatever state the caller left the attribute flip-flop in: the BIOS resets it by reading Input Status 1 (3BAh/3DAh) before its first access to 3C0h. The state it leaves is not defined by any public source: a program reads 3BAh/3DAh before its own next use of 3C0h | Ferraro 10.6.1 and chapter 10 introduction (the flip-flop "cannot be interrogated or saved"); VGADOC VGAREGS.TXT (3C0h) | should (reset before use), note (state left) | not checked (S3TEST 'VGA ATC flip-flop reset by mode set' covers the mode set only) |
| B10-5 | Dynamic save area: when the save pointer table holds one (0040:00A8h, offset 04h not zero), every write of AR00-0Fh or AR11 by AL=00h-02h (and AH=0Bh) is also stored there: offsets 00h-0Fh = AR00-0Fh, offset 10h = AR11 (overscan). The area exists because the EGA registers cannot be read | RBIL MEM 0040h:00A8h (#M0037, #M0045); VGADOC VGABIOS.TXT (save area) | should | not checked (S3COMPAT 'Video save pointer table 0040:00A8' checks only what the mode set stores) |
| B10-6 | IBM's original VGA BIOS stores the AX=1001h border at offset 11h of the save area instead of 10h, so a program may find it at either offset | RBIL INT 10/AX=1001h ("BUG"); VGADOC VGABIOS.TXT (AX=1001h) | note | not checked |
| B10-7 | A mode set with default palette loading on fills the dynamic save area with the AR00-0Fh and AR11 values of the mode. When a user palette profile overrides the defaults, the area gets the defaults, not the profile values | RBIL MEM 0040h:00A8h (#M0045 and its note) | should | S3COMPAT 'Video save pointer table 0040:00A8' fail 1 (mode 03h) |
| B10-8 | The read subfunctions (07h-09h, 15h, 17h, 19h, 1Ah) read the hardware registers, so they also return values a program wrote to the ports itself; they do not read the save area | Ferraro 11.10.5 (palette registers readable on the VGA), 11.11.4 | must | S3COMPAT 'AX=1010/1015, 1012/1017 DAC' fail 4 (direct readback through 3C7h/3C9h agrees) |
| B10-9 | Grey summing on (0040:0089h bit 1 = 1, set by AH=12h BL=33h AL=00h): AX=1010h and AX=1012h store the grey value of B101B-2 in all three components of each entry instead of the given red, green and blue | Ferraro 11.13.6 (summing "during Mode Set and during calls that affect the Color Registers"); RBIL INT 10/AH=12h/BL=33h; RBIL MEM 0040h:0089h bit 1 | should | not checked (S3COMPAT 'AH=12 BL=33 grey summing on mode set' checks the mode set only) |
| B10-10 | Grey summing acts on the DAC only: AL=00h-03h, 13h, 18h and AH=0Bh work the same with it on. AX=1015h and 1017h return what the DAC holds (the grey values after a summed write) | Ferraro 11.13.6 ("Registers affected: if enabled, all 256 Color Registers") | should | not checked |
| B10-11 | AX=101Bh sums whether grey summing is on or off | Ferraro 11.11.7 (the summing "occurs automatically when this call is invoked") | must | S3COMPAT 'AX=101B grey summing vs IBM' (summing off) |
| B10-12 | Default palette loading (AH=12h BL=31h, 0040:0089h bit 3) concerns mode sets only: with it disabled, AH=0Bh and every AH=10h subfunction still write the registers | Ferraro 11.13.4 ("during following mode sets"); RBIL INT 10/AH=12h/BL=31h | should | S3COMPAT 'AH=12 BL=31 default palette loading' fail 2 (AX=1010h with loading disabled, kept by mode 03h, read by AX=1015h) |

### AX=1000h: set one palette register

Writes one attribute register; mostly used for the 16 palette registers.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1000-1 | BL = register 00h-0Fh, BH = value (6 bits, 00h-3Fh): ARxx = BH. Other attribute registers are not changed | Ferraro 11.10.1, 10.6.2; RBIL INT 10/AX=1000h | must | S3COMPAT 'AX=1000/1007 palette register' fail 1 (mode 12h); make v2-ref-compare (BX=0302h) |
| B1000-2 | BL = 10h-14h writes the other attribute registers: 10h mode control, 11h overscan, 12h colour plane enable, 13h horizontal panning, 14h colour select. RBIL calls this undocumented and advises leaving AR10 to the BIOS | Ferraro 11.10.1 (the call covers every attribute register); RBIL INT 10/AX=1000h (#00017) | should | not checked |
| B1000-3 | In mode 13h the palette registers form the low 4 bits of the DAC address and should not be changed by a program; whether the BIOS refuses AX=1000h there is not stated | Ferraro 11.10 (256-color mode) | note | not checked |

### AX=1001h: set the overscan (border) register

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1001-1 | BH = border colour 00h-3Fh, in the palette register coding: AR11 = BH. Other attribute registers are not changed | Ferraro 11.10.2; RBIL INT 10/AX=1001h | must | S3COMPAT 'AX=1001/1008 overscan' fail 1; make v2-ref-compare (BX=0400h) |

### AX=1002h: set all palette registers and the overscan

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1002-1 | ES:DX -> 17 bytes: bytes 00h-0Fh go into AR00-0Fh, byte 10h into AR11. The table, ES and DX are not changed | Ferraro 11.10.3; RBIL INT 10/AX=1002h (#00018) | must | S3COMPAT 'AX=1002/1009 all palette regs' fail 1 |
| B1002-2 | BH is no input; RBIL advises callers to pass BH=00h because of some adapters, so a BIOS ignores BH | RBIL INT 10/AX=1002h | note | not checked |

### AX=1003h: blink or background intensity

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1003-1 | BL=00h: AR10 bit 3 = 0 (attribute bit 7 selects 16 background colours); BL=01h: AR10 bit 3 = 1 (attribute bit 7 blinks, 8 background colours). The other AR10 bits are not changed | Ferraro 11.10.4 (Table 11.11), 10.6.3 (B/I); RBIL INT 10/AX=1003h | must | S3COMPAT 'AX=1003 blink/intensity' fail 1, 2 (mode 03h); make v2-ref-compare (BX=0000h, 0001h) |
| B1003-2 | 0040:0065h bit 5 shows the state (1 = blinking) | RBIL INT 10/AX=1003h note, RBIL MEM 0040h:0065h (#M0018); VGADOC VGABIOS.TXT (AX=1003h) | should | not checked |
| B1003-3 | AH=1Bh state block offset 2Dh bit 5 shows the state (0 intensity, 1 blinking); after a mode set it equals AR10 bit 3 of the mode | RBIL INT 10/AX=1003h note, AH=1Bh (#00041); IBM (VGATEST) state blocks (2Dh = 21h in text modes, 01h in graphics modes) | should | emu t_vga_registers (offset 2Dh after mode sets only); not checked after AX=1003h |
| B1003-4 | BH is no input; RBIL advises BH=00h because of some adapters | RBIL INT 10/AX=1003h | note | not checked |

### AX=1007h: read one palette register

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1007-1 | BL = register 00h-0Fh (palette) or 10h-14h (the other attribute registers); returns BH = its current value. Only BH changes | Ferraro 11.10.5; RBIL INT 10/AX=1007h (#00017) | must | S3COMPAT 'AX=1000/1007 palette register' fail 2; make v2-ref-compare (BL=03h) |

### AX=1008h: read the overscan register

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1008-1 | Returns BH = AR11 (00h-3Fh). Only BH changes | Ferraro 11.10.6; RBIL INT 10/AX=1008h | must | S3COMPAT 'AX=1001/1008 overscan' fail 2 |

### AX=1009h: read all palette registers and the overscan

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1009-1 | ES:DX -> 17-byte buffer: bytes 00h-0Fh get AR00-0Fh, byte 10h gets AR11 (the AX=1002h layout). Only those 17 bytes are written; ES and DX are not changed | Ferraro 11.10.7; RBIL INT 10/AX=1009h (#00018) | must | S3COMPAT 'AX=1002/1009 all palette regs' fail 1 |

### AX=1010h: set one DAC colour register

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1010-1 | BX = entry 00h-FFh, DH = red, CH = green, CL = blue, each 0-63: the entry gets these values (6 bits; the DAC keeps bits 5-0). With grey summing on, see B10-9 | Ferraro 11.11.1; RBIL INT 10/AX=1010h; VGADOC VGAREGS.TXT (3C9h bits 5-0) | must | S3COMPAT 'AX=1010/1015, 1012/1017 DAC' fail 1; make v2-ref-compare (BX=5) |

### AX=1012h: set a block of DAC colour registers

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1012-1 | BX = first entry, CX = number of entries, ES:DX -> 3 x CX bytes, red, green, blue per entry (0-63 each). Entries BX to BX+CX-1 get the triples in order; the table, ES, DX, BX and CX are not changed. With grey summing on, see B10-9 | Ferraro 11.11.2 (Table 11.12); RBIL INT 10/AX=1012h | must | S3COMPAT 'AX=1010/1015, 1012/1017 DAC' fail 2 (16 entries at 20h, read by AX=1017h), 4 (read back through 3C7h/3C9h) |
| B1012-2 | Up to 256 entries from any start. A count that runs past entry FFh, CX = 0 and CX > 256 are not defined by a public source. The DAC write index (3C8h) is 8 bits wide and steps to the next entry after each triple, so a block written as one run continues at entry 00h after FFh | Ferraro 11.11.2 ("any number of registers, up to the maximum of 256 ... starting at an arbitrary register number"); VGADOC VGAREGS.TXT (3C8h) | note | not checked |

### AX=1013h: select the colour paging mode or the colour page

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1013-1 | BL=00h selects the paging mode from BH: BH=00h four pages of 64 entries (AR10 bit 7 = 0), BH=01h sixteen pages of 16 (AR10 bit 7 = 1). The other AR10 bits are not changed | Ferraro 11.11.3 (Table 11.13), 10.6.3 (IPS); RBIL INT 10/AX=1013h; VGADOC VGAREGS.TXT (3C0h index 10h bit 7) | must | S3COMPAT 'AX=1013/101A colour paging' fail 1; make v2-ref-compare (BX=0100h) |
| B1013-2 | BL=01h selects page BH: with four pages, page 0-3 goes into AR14 bits 3-2 (DAC address bits 7-6); with sixteen pages, page 0-15 goes into AR14 bits 3-0 (DAC address bits 7-4) | Ferraro 11.11.3, 10.6.3 (IPS and the colour select fields) | must | S3COMPAT 'AX=1013/101A colour paging' fail 1 (sixteen pages, page 3) |
| B1013-3 | After a mode set: four pages, page 0 (AR10 bit 7 = 0, AR14 = 00h in every standard mode) | IBM (VGATEST) register tables | must | emu t_vga_registers (AR10, AR14); S3COMPAT 'Mode nnh' lines fail 1 |
| B1013-4 | Not valid in mode 13h, where the 8-bit pixel value addresses the DAC; what a BIOS does there is not stated | RBIL INT 10/AX=1013h note; VGADOC VGABIOS.TXT (AX=1013h) | note | not checked |

### AX=1015h: read one DAC colour register

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1015-1 | BX = entry (pass BH = 00h, see "Sources disagree"); returns DH = red, CH = green, CL = blue, each 0-63 (bits 7-6 zero) | Ferraro 11.11.4; RBIL INT 10/AX=1015h; VGADOC VGAREGS.TXT (3C9h) | must | S3COMPAT 'AX=1010/1015, 1012/1017 DAC' fail 1; S3COMPAT 'AH=12 BL=31 default palette loading' fail 2, 4 |
| B1015-2 | AX, BX and DL come back unchanged on most BIOSes, but some destroy AX (Tseng ET4000 8.00n returns AX=00C9h): a caller does not rely on AX | RBIL INT 10/AX=1015h | note | not checked |

### AX=1017h: read a block of DAC colour registers

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1017-1 | BX = first entry, CX = number of entries, ES:DX -> buffer of 3 x CX bytes, which gets red, green, blue (0-63 each) of entries BX to BX+CX-1. Only those bytes are written; ES, DX, BX and CX are not changed | Ferraro 11.11.5; RBIL INT 10/AX=1017h | must | S3COMPAT 'AX=1010/1015, 1012/1017 DAC' fail 2 |
| B1017-2 | The range rules of B1012-2 apply (up to 256 entries from any start; past FFh, CX = 0, CX > 256 not defined) | Ferraro 11.11.5; VGADOC VGAREGS.TXT (3C7h: the read index steps after three reads) | note | not checked |

### AX=1018h, AX=1019h: PEL mask

Undocumented in IBM's references, but in RBIL and VGADOC and used by programs.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1018-1 | AX=1018h: BL is written to the PEL mask, port 3C6h, which is ANDed with every pixel's DAC index | RBIL INT 10/AX=1018h; VGADOC VGABIOS.TXT, VGAREGS.TXT (3C6h) | should | S3COMPAT 'AX=1018/1019 PEL mask' fail 1 (0Fh), 4 (FFh) |
| B1018-2 | The BIOS initialises the PEL mask to FFh; a mask set with AX=1018h stays until the BIOS sets it again | Ferraro 10.7.5; VGADOC VGAREGS.TXT (3C6h: "should be set to FFh") | should | not checked |
| B1019-1 | AX=1019h: returns BL = the PEL mask read from 3C6h | RBIL INT 10/AX=1019h; VGADOC VGABIOS.TXT | should | S3COMPAT 'AX=1018/1019 PEL mask' fail 2 |

### AX=101Ah: read the colour paging state

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B101A-1 | Returns BL = paging mode (AR10 bit 7: 00h four pages of 64, 01h sixteen pages of 16) and BH = current page (AR14 bits 3-2 with four pages, AR14 bits 3-0 with sixteen) | Ferraro 11.11.6, 10.6.3; RBIL INT 10/AX=101Ah | must | S3COMPAT 'AX=1013/101A colour paging' fail 1 (BX = 0301h after AX=1013h BX=0100h and 0301h; BX = FFFFh on entry, so a call that does nothing fails) |
| B101A-2 | The result follows the registers, so it also reflects AR10 and AR14 written by AX=1000h (BL=10h, 14h) or by a program | Ferraro 11.11.6 (the paging mode "is determined by" the IPS field) | should | not checked |

### AX=101Bh: sum DAC colour registers to grey

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B101Bh-1 | BX = first entry, CX = number of entries: red, green and blue of each entry BX to BX+CX-1 are replaced by one grey value G. Other entries and all registers are not changed | Ferraro 11.11.7; RBIL INT 10/AX=101Bh | must | S3COMPAT 'AX=101B grey summing vs IBM' (all 256 entries of the mode 13h table) |
| B101B-2 | G = 0.30 x red + 0.59 x green + 0.11 x blue of the entry's 6-bit values, within 1 of (30 R + 59 G + 11 B + 50) / 100; G is 0-63, and an entry that is already grey keeps its value (the weights sum to 1) | Ferraro 11.11.7 (Equation 11.1), 11.13.6 (Equation 11.6); IBM (VGATEST) | must | S3COMPAT 'AX=101B grey summing vs IBM' fail 1 (every entry within 1 of the formula applied to IBM's default table) |
| B101B-3 | The range rules of B1012-2 apply (up to 256 entries from any start; past FFh, CX = 0, CX > 256 not defined) | Ferraro 11.11.7 ("any number of Color Registers, up to the maximum of 256 ... beginning at any Color Register index") | note | not checked |

### Open questions

To settle by running the ROMs in the emulator.

AH=0Bh:

1. BH=00h with BL bits 7-5 not zero: are they ignored, or do they reach 0040:0066h (BL bit 5 then
   changing the palette bit)?
2. BH=00h with BL bit 3 set: does the attribute register value keep bit 3 as well as getting the
   intensity in bit 4 (BL=08h giving 18h), or only bit 4 (10h)?
3. BH=00h in modes 0Dh-13h: which of AR00, AR01-03 and AR11 change? Does the call also rewrite AR01-03
   with CGA palette colours in the planar and 256-colour modes?
4. BH=00h in mode 06h: does BL set the background (AR00), as in modes 04h/05h, or the foreground
   (AR01), as the CGA colour select register does in 640x200?
5. BH=00h in text modes: does BL bit 4 change anything besides 0040:0066h (for example AR10 bit 3, as
   the CGA's intense background bit would)?
6. BH=01h in text modes 00h-03h and in mode 07h: are AR01-03 changed, and is 0040:0066h bit 5 updated?
7. BH=01h in modes 06h and 0Dh-13h: are AR01-03 rewritten (in mode 06h that changes the foreground
   colour, which is AR01-0Fh = 17h after the mode set)?
8. BH=01h with BL other than 00h/01h: is only bit 0 used? BH other than 00h/01h: ignored, or treated
   like 01h?
9. Does AH=0Bh store what it writes in the dynamic save area, and the border at offset 10h or 11h?

AH=10h:

10. In which state is the attribute flip-flop left after each subfunction (index or data state), and
    what does the attribute address register hold (for example 20h: index 0 with PAS = 1)?
11. Do AH=0Bh and AX=1000h-1003h wait for the vertical retrace before writing (up to one frame per
    call)?
12. Do AX=1012h, 1017h and 101Bh blank the screen while they run, and if so, do they leave SR01 bit 5
    (screen off) as the caller had it, or always cleared (turning on a screen that AH=12h BL=36h
    AL=01h had turned off)?
13. AX=1000h and AX=1002h in mode 13h: refused, or carried out?
14. AX=1000h with BL=10h-14h: is the dynamic save area written, and at which offset (BL=10h at offset
    10h would overwrite the saved overscan)? BL=11h: offset 10h or 11h?
15. AX=1000h and AX=1007h with BL = 15h-FFh: what is written or returned?
16. AX=1003h with BL other than 00h/01h: only bit 0 used? Does it update 0040:0065h bit 5? Does it
    act in graphics modes too?
17. AX=1010h, 1012h, 1015h, 1017h, 101Bh with BH not zero (BX > FFh): is BH ignored?
18. AX=1012h, 1017h, 101Bh with CX = 0: nothing, or 65536 entries (the whole table 256 times)? With
    CX > 256, or BX+CX > 256: does the transfer continue at entry 00h?
19. AX=1010h and AX=1012h with 0040:0089h bit 2 (monochrome display) set and bit 1 clear: are the
    values summed to grey?
20. AX=1019h: is BH returned as given, or as 00h?
21. AX=1013h with BL other than 00h/01h; with BL=00h and BH above 01h (only bit 0 used?); with BL=01h
    and a page above 3 in four-page mode (masked to 2 bits?); and in mode 13h: what happens?
22. AX=101Bh rounding: is G = (30 R + 59 G + 11 B + 50) / 100, or does the BIOS round halves down
    (+49)? Both stay within the tolerance of B101B-2.
23. A mode set with default palette loading disabled (AH=12h BL=31h AL=01h): is the dynamic save area
    still filled, and is the PEL mask still set to FFh?
24. AH=10h with 0040:0087h bit 3 set (video system inactive): does any subfunction act?
25. Do all subfunctions keep AX (AX=1015h in particular, see B1015-2)?

### Sources disagree

1. Ferraro 11.10.2 calls the overscan register "Attribute Register 10 hex"; it is 11h (Ferraro
   10.6.4, RBIL #00017, VGADOC VGAREGS.TXT). The rules use 11h.
2. The save area offset of the border: RBIL #M0045 and VGADOC put the overscan at offset 10h, and
   both say IBM's original VGA BIOS writes the AX=1001h border at 11h. The rules follow 10h (B10-5)
   and list IBM's offset as a note (B10-6).
3. AX=1015h input: Ferraro gives BX, RBIL and VGADOC give BL. B1015-1 follows Ferraro and asks callers
   for BH=00h, which works either way (open question 17).
4. AX=1017h: Ferraro lists ES:DX under "Output Parameters" and calls BX/CX "Color Register to set";
   RBIL and VGADOC give ES:DX as an input buffer. The rule follows RBIL.
5. AX=101Bh: Ferraro's Listing 11.1 truncates the grey value (a C conversion to unsigned char) and
   loops from start_reg to number_regs inclusive, a wrong count; the IBM formula as the project
   encodes it from VGATEST rounds. B101B-2 follows the formula with a tolerance of 1, which covers
   truncation and rounding, and the count of Ferraro's text and RBIL.
6. AX=1013h in mode 13h: RBIL and VGADOC say the call is not valid there; Ferraro says nothing. B1013-4
   is a note (open question 21).
7. AH=0Bh: Ferraro 11.8 limits it to modes 4 and 5 (mode 6 in some implementations) and says to use it
   only in an EGA mode; RBIL documents BH=00h for text modes (border only) and notes that newer cards
   support BH=01h in many or all graphics modes. The rules follow RBIL for text modes (B0B-3) and IBM
   mode 04h for the graphics side, and leave the other graphics modes as a note (B0B-10).
8. AH=0Bh palette 0: Ferraro names colour 3 brown, RBIL "brown/yellow". Both are right: the IBM CGA
   palette shows 06h as brown and the intensified 16h as yellow. The rules give the attribute values.
9. AX=1003h state: VGADOC says there is no function to read it and points to 0040:0065h bit 5; RBIL
   adds that on the VGA AH=1Bh offset 2Dh bit 5 gives it. Both are rules (B1003-2, B1003-3).
10. AX=1018h/1019h: RBIL and VGADOC mark them undocumented, Ferraro leaves them out. They are should
    rules, not must.
11. Ferraro 10.6.3 (IPS) describes the two segmentations the wrong way round in its first paragraph
    (the "first" one, sixteen groups, is then explained with the six palette bits and C67, which is
    the four-group case); its field values (0: palette bits 5-4 give DAC bits 5-4, 1: C45 gives them)
    and Table 11.13 are consistent with RBIL. The rules follow the field values.

## Fonts, alternate select and state (AH=11h, 12h, 1Ah, 1Bh, 1Ch)

Notation: 0040:00xxh is the BIOS data area, 0000:00xxh an interrupt vector. "Text modes" are 00h-03h
and 07h; "200/350/400 lines" is the scan line count chosen with AH=12h BL=30h for the next text mode
set. A register not named in a rule's outputs is returned as the caller gave it (the general rule of
this document). Rules about the font tables and the static functionality table are `TAB-` rules at
the end of this section.

### AX=1100h-1104h: load a text font into plane 2 (no recalculation)

Load a user font (00h) or a ROM font (01h 8x14, 02h 8x8, 04h 8x16) into a character block.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1100-1 | AX=1100h: ES:BP = user table, CX = number of characters, DX = first character code, BL = block (0-7 on a VGA), BH = bytes per character (at most 32). The table holds CX glyphs of BH bytes each, one after the other. Returns nothing | RBIL INT 10/AX=1100h; Ferraro 11.12.1; VGADOC VGABIOS.TXT | must | S3COMPAT 'AX=1100-1104, 1110 text fonts' (fail 1) |
| B1100-2 | Glyph k of the table goes to plane 2 at the block's base + (DX + k) x 32: every character has a 32-byte slot whatever its height; the first BH bytes of the slot are written | Ferraro 11.12.1 ("Display Memory Affected") | must | S3COMPAT 'AX=1100-1104, 1110 text fonts' (fail 1: glyph 41h of block 0) |
| B1100-3 | Block n (BL) lies in plane 2 at 0K, 16K, 32K, 48K for n = 0-3 and at 8K, 24K, 40K, 56K for n = 4-7, the places character map n has for SR03 | VGADOC VGAREGS.TXT (3C4h index 3); Ferraro 11.12.1 (eight 8 KB blocks on the VGA) | must | S3COMPAT and S3TEST (block 0 only) |
| B1100-4 | AX=1101h, 1102h, 1104h: BL = block; load all 256 glyphs of the ROM 8x14 (01h), 8x8 (02h) or 8x16 (04h) font, the tables AX=1130h BH=02h, 03h (with 04h) and 06h point to | RBIL AX=1101h, 1102h, 1104h; Ferraro 11.12.2, 11.12.3, 11.12.5 | must | S3COMPAT 'AX=1100-1104, 1110 text fonts' (fail 2, 4, 8); S3TEST 'Font load 8x16 and 8x8 in plane 2' (1104h is checked through 1114h); WARN on a BIOS without 8x14 font (AX=1130h BH=02h gives the 8x16 table, the known gap of the 2.04.07 base) |
| B1100-5 | For text modes only. The text in planes 0 and 1 is kept (the video buffer is not cleared), and afterwards the sequencer and graphics controller again give the mode's normal text access at B000h/B800h. RBIL, VGADOC and Ferraro describe this as "a mode set without clearing the buffer" | RBIL AX=1100h ("will cause a mode set ... without clearing the video buffer"); VGADOC VGABIOS.TXT; Ferraro 11.12.1 | should | `make v2-ref-compare` (1111h-1114h); not checked against IBM |
| B1100-6 | AL=00h-04h do not recalculate: 0040:0084h, 0040:0085h, 0040:004Ch and the CRTC keep their values (only AL=10h-14h recalculate, B1110-*) | RBIL AX=1110h ("equivalent to AX=110xh except that ..."); VGADOC VGABIOS.TXT | should | not checked |
| B1100-7 | The 8x14 font of AX=1101h is the plain 8x14 table; whether the 9x14 alternates (AX=1130h BH=05h) are applied is not settled (see "Sources disagree") | RBIL AX=1101h ("the monochrome patterns are 8x14") | note | not checked |

### AX=1103h: set block specifier

Select the character blocks used for attribute bit 3 = 0 and 1.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1103-1 | BL is written to the character map select register SR03 unchanged: bits 1-0 and 4 select the block for characters with attribute bit 3 clear, bits 3-2 and 5 the block for attribute bit 3 set. Nothing else changes; returns nothing | RBIL AX=1103h (#00020); VGADOC VGABIOS.TXT, VGAREGS.TXT; Ferraro 11.12.4 | must | S3COMPAT 'AX=1100-1104, 1110 text fonts' (fail 40: SR03 = 05h, then 00h) |
| B1103-2 | With two different blocks selected, attribute bit 3 chooses the block and still also feeds the colour; to get 8 colours with 512 characters the caller sets the colour plane enable register (AX=1000h BL=12h BH=07h) itself; AX=1103h does not | Ferraro 11.12.4 | note | not checked |

### AX=1110h-1114h: load a text font and recalculate

As AX=1100h-1104h (same inputs, same plane 2 contents), then the screen geometry is adapted to the
new character height. Meant to be called right after a mode set, with page 0 active.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1110-1 | AX=1110h, 1111h, 1112h, 1114h load plane 2 exactly as AX=1100h, 1101h, 1102h, 1104h (B1100-1 to B1100-4) | RBIL AX=1110h; VGADOC VGABIOS.TXT; Ferraro 11.12.6-11.12.9 | must | S3COMPAT 'AX=1100-1104, 1110 text fonts' (fail 10); S3TEST 'Font load 8x16 and 8x8 in plane 2' |
| B1110-2 | The caller has set the mode just before and page 0 is active; results are not defined otherwise | RBIL AX=1110h; Ferraro 11.12.6 | must (caller) | not checked |
| B1110-3 | 0040:0085h (word) = the new height H (BH for 1110h; 14, 8, 16 for 1111h, 1112h, 1114h) | RBIL AX=1110h ("bytes/character is recalculated"); RBIL MEM 0040:0085h | must | S3COMPAT 'AX=1100-1104, 1110 text fonts' (fail 20), 'AX=1111 font load rows/height', 'AX=1112 ...', 'AX=1114 ...' (fail 1) |
| B1110-4 | 0040:0084h = rows - 1, rows = scan lines / H rounded down, scan lines = 400, 350 or 200 as the text mode was set (mode 03h at 400 lines: 8x8 gives 49, 8x14 27, 8x16 24) | RBIL AX=1110h ("max character rows is recalculated"); Ferraro 11.12.6 (Equation 11.4) | must | S3COMPAT 'AX=1111/1112/1114 font load rows/height' (fail 1), 'AX=1100-1104, 1110 text fonts' (fail 20: 0484h = 49) |
| B1110-5 | CR09 bits 4-0 (maximum scan line) = H - 1 | Ferraro 11.12.6 ("Maximum Scan Line Register"); RBIL AX=1110h (R09) | must | S3COMPAT 'AX=1111/1112/1114 font load rows/height' (fail 2), 'AX=1100-1104, 1110 text fonts' (fail 20: CR09 = 7) |
| B1110-6 | Vertical display end (CR12 with CR07 bits 1 and 6) = rows x H - 1 in 350- and 400-line modes, rows x H x 2 - 1 in 200-line (double-scanned) modes: the lines left over below the last full row are not displayed | Ferraro 11.12.6 (Equations 11.2, 11.3, Overflow Register); RBIL AX=1110h (R12) | must | not checked (S3COMPAT reads CR12 only for AH=12h BL=30h) |
| B1110-7 | The cursor is set to the bottom of the new cell: CR0A (cursor start) = H - 2, CR0B (cursor end) = H - 1 | Ferraro 11.12.6 (VGA values) | should | not checked |
| B1110-8 | 0040:004Ch (page length) is recalculated from the new row count: rows x columns (0040:004Ah) x 2 | Ferraro 11.12.6 (Equation 11.5); RBIL AX=1110h ("CRT buffer length is recalculated") | should | not checked |
| B1110-9 | Text in planes 0 and 1 is kept; the mode number (0040:0049h) and columns stay | RBIL AX=1110h; Ferraro 11.12.6 | must | S3COMPAT 'AX=1100-1104, 1110 text fonts' (mode 03h, 50 rows after 1110h) |

### AX=1120h-1124h: graphics-mode fonts

Set the font the graphics modes use for character output (AH=09h, 0Ah, 0Eh). No video memory is
loaded: the pointer is kept in a vector.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1120-1 | AX=1120h: ES:BP = a table of 128 8x8 glyphs for character codes 80h-FFh; the BIOS stores it in the INT 1Fh vector (0000:007Ch = BP, 0000:007Eh = ES). Nothing else changes | RBIL AX=1120h; Ferraro 11.12.10, Table 9.7 | must | S3COMPAT 'AX=1120-1124 graphics fonts' (fail 1) |
| B1120-2 | AX=1121h: ES:BP = user font, CX = bytes per character, BL = row specifier; AX=1122h, 1123h, 1124h: the ROM 8x14, 8x8 and 8x16 fonts (the tables of AX=1130h BH=02h, 03h, 06h) with BL. The pointer goes into the INT 43h vector (0000:010Ch offset, 0000:010Eh segment) | RBIL AX=1121h-1124h; Ferraro 11.12.11-11.12.14, Table 9.7 | must | S3COMPAT 'AX=1120-1124 graphics fonts' (fail 2, 8) |
| B1121-1 | Row specifier BL: 01h 14 rows, 02h 25 rows, 03h 43 rows; 0040:0084h = rows - 1 | RBIL AX=1121h; Ferraro Tables 11.17-11.20 | must | S3COMPAT 'AX=1120-1124 graphics fonts' (fail 2: BL=1-3) |
| B1121-2 | BL=00h: the row count is DL (0040:0084h = DL - 1) | RBIL AX=1121h; VGADOC VGABIOS.TXT | should | S3COMPAT 'AX=1120-1124 graphics fonts' (fail 4: DL=20) |
| B1121-3 | 0040:0085h = the font height: CX for 1121h, 14, 8, 16 for 1122h, 1123h, 1124h | RBIL MEM 0040:0085h; RBIL AX=1121h (CX) | must | S3COMPAT 'AX=1120-1124 graphics fonts' (fail 2, 8; WARN 01 for 1122h when the 8x14 table is the 8x16 one, the known gap of the 2.04.07 base) |
| B1121-4 | Neither the CRTC nor video memory changes: these calls only record a pointer and the row count. They are meant to be called right after a graphics mode set; results at other times are not defined | RBIL AX=1120h-1124h ("results are unpredictable at other times"); Ferraro 11.12.10-11.12.14 (no registers affected) | should | not checked |

### AX=1130h: get font information

Return a font pointer and the current text geometry.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1130-1 | BH = pointer specifier; returns ES:BP: 00h the INT 1Fh vector (0000:007Ch), 01h the INT 43h vector (0000:010Ch), 02h ROM 8x14 font, 03h ROM 8x8 font (characters 00h-7Fh), 04h ROM 8x8 font characters 80h-FFh, 05h ROM 9x14 alternate table, 06h ROM 8x16 font, 07h ROM 9x16 alternate table | RBIL AX=1130h; VGADOC VGABIOS.TXT; Ferraro 11.12.15, Table 11.21 | must | S3COMPAT 'AX=1130 BH=3 8x8 font', 'AX=1130 BH=4 8x8 upper half', 'AX=1130 BH=6 8x16 font', 'AX=1130 BH=2 8x14 font' (WARN 01: 8x16 table, no 8x14 font), 'AX=1130 BH=1 INT43 in mode 13' |
| B1130-2 | For BH=00h and 01h the pointer is the vector's current content, whatever set it (AX=1120h-1124h, a mode set, a program) | RBIL AX=1130h; Ferraro 11.12.15 | must | S3COMPAT 'AX=1130 BH=1 INT43 in mode 13', 'AX=1120-1124 graphics fonts' |
| B1130-3 | CX = 0040:0085h, the height of the font on the screen now, not that of the requested font | RBIL AX=1130h ("not the requested font!") | must | S3COMPAT 'AX=1130 BH=3 8x8 font' (fail 1: CX = 16 in mode 03h) |
| B1130-4 | DL = 0040:0084h, the highest row number (rows - 1). The IBM EGA returned the row count instead; a VGA BIOS returns rows - 1 | RBIL AX=1130h (BUG note); VGADOC VGABIOS.TXT; Ferraro 11.12.15 | must | S3COMPAT 'AX=1130 BH=3 8x8 font' (fail 1: DL = 24) |
| B1130-5 | The ROM pointers (BH=02h-07h) are the same on every call and in every mode | Ferraro 11.12.15 (pointers into the BIOS ROM) | should | S3COMPAT (the font tests compare pointers between calls) |

### AH=11h: other AL values

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B11-1 | Only AL = 00h-04h, 10h-12h, 14h, 20h-24h and 30h are defined; for any other AL the BIOS changes nothing (registers, BIOS data, video memory, video registers) | RBIL INT 10/AH=11h entries (the list of subfunctions); Ferraro 11.12 | should | emu t_errors (AL = 05h, 06h, 0Fh, 13h, 15h, 1Fh, 25h, 2Fh, 31h, 40h) |

### AH=12h BL=10h: get EGA information

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B12.10-1 | Returns BH = 00h when the colour CRTC address (3Dxh) is in use, 01h when the mono address (3Bxh) is; BH is always changed (callers test for an EGA or later by calling with BH = FFh) | RBIL AH=12h/BL=10h; Ferraro 11.13.1 | must | S3COMPAT 'AH=12 BL=10 EGA info' (BX = 0003h in mode 03h) |
| B12.10-2 | BL = memory code from 0040:0087h bits 6-5: 00h 64 KB, 01h 128 KB, 02h 192 KB, 03h 256 KB; a VGA returns 03h | RBIL AH=12h/BL=10h, MEM 0040:0087h; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=12 BL=10 EGA info' |
| B12.10-3 | CH = feature connector bits (0040:0088h bits 7-4 moved to bits 3-0), CL = configuration switches (0040:0088h bits 3-0) | RBIL AH=12h/BL=10h (#00022, #00023), MEM 0040:0088h; VGADOC VGABIOS.TXT | should | `make v2-ref-compare` does not call it; not checked |
| B12.10-4 | Some BIOSes change AH on this call; a caller cannot rely on AH | RBIL AH=12h/BL=10h ("AH destroyed ... Tseng") | note | not checked |

### AH=12h BL=20h: select alternate print screen

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B12.20-1 | Sets the INT 05h vector (0000:0014h) to a print-screen routine in the video BIOS that prints the number of rows the screen has (0040:0084h + 1), not only 25 | RBIL AH=12h/BL=20h; VGADOC VGABIOS.TXT | should | S3COMPAT 'AH=12 BL=20 alternate print screen' (WARN 1 when INT 05h does not point into the video BIOS segment; the 2.04.07 base does nothing) |
| B12.20-2 | The routine keeps the print-screen status in 0050:0000h: 01h while printing, 00h when done, FFh after an error | RBIL MEM 0050:0000h; Ferraro 11.13.2, Table 11.22 | should | not checked |
| B12.20-3 | Some adapters disable print-screen instead of enhancing it | RBIL AH=12h/BL=20h | note | not checked |

### AH=12h BL=30h: select scan lines for text modes

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B12.30-1 | AL = 00h 200, 01h 350, 02h 400 scan lines; returns AL = 12h. Takes effect at the next mode set of a text mode (00h-03h, 07h); the current screen and the graphics modes do not change | RBIL AH=12h/BL=30h; VGADOC VGABIOS.TXT; Ferraro 11.13.3 | must | S3COMPAT 'AH=12 BL=30 350 / 400 scan lines' (fail 1 AL, 2 350 lines, 4 400 lines); S3COMPAT 'Mode xxh 350' lines; emu t_mono (mode 07h at 350 lines) |
| B12.30-2 | After AL=01h, mode 03h has 350 displayed lines (vertical display end 349) and 0040:0085h = 14; after AL=02h, 400 lines and 16 | IBM (VGATEST: the 350-line entries of vgaref.inc); Ferraro 11.13.3 | must | S3COMPAT 'AH=12 BL=30 350 / 400 scan lines'; emu t_vga_registers |
| B12.30-3 | The choice is kept in the BIOS data area: 0040:0089h bits 7 and 4 = 00b 350, 01b 400, 10b 200 lines; for 350 and 200 lines the switch nibble 0040:0088h bits 3-0 says EGA (3h or 9h: 350) or CGA emulation (any other: 200) | RBIL MEM 0040:0088h, 0040:0089h (#M0025, #M0027); VGADOC VGABIOS.TXT | should | not checked |
| B12.30-4 | 200 lines cannot be used for mode 07h | Ferraro 11.13.3 | note | not checked |

### AH=12h BL=31h: default palette loading on mode set

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B12.31-1 | AL = 00h enable, 01h disable; returns AL = 12h. Kept in 0040:0089h bit 3 (1 = loading disabled) | RBIL AH=12h/BL=31h, MEM 0040:0089h; VGADOC VGABIOS.TXT; Ferraro 11.13.4 | must | S3COMPAT 'AH=12 BL=31 default palette loading' (fail 1) |
| B12.31-2 | While disabled, a mode set leaves the palette registers (AR00-0Fh), the overscan register and the DAC unchanged; enabled again, the next mode set loads the defaults | Ferraro 11.13.4; RBIL AH=12h/BL=31h | must | S3COMPAT 'AH=12 BL=31 default palette loading' (fail 2, 4: DAC entry 1 in mode 03h) |

### AH=12h BL=32h: video enable/disable

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B12.32-1 | AL = 00h enable, 01h disable CPU access to the video memory and the I/O registers (the video subsystem enable, 3C3h or 46E8h); returns AL = 12h | RBIL AH=12h/BL=32h; VGADOC VGABIOS.TXT; Ferraro 11.13.5, 3.x (3C3h, 46E8h) | should | S3COMPAT 'AH=12 BL=32 video disable/enable' (fail 1: AL = 12h both ways, CR01 unchanged after enable) |
| B12.32-2 | Disable then enable gives the same video state as before | Ferraro 11.13.5 | must | S3COMPAT 'AH=12 BL=32 video disable/enable' |

### AH=12h BL=33h: grey-scale summing

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B12.33-1 | AL = 00h enable, 01h disable; returns AL = 12h. Kept in 0040:0089h bit 1 (1 = enabled) | RBIL AH=12h/BL=33h, MEM 0040:0089h; VGADOC VGABIOS.TXT; Ferraro 11.13.6 | must | S3COMPAT 'AH=12 BL=33 grey summing on mode set' (fail 1) |
| B12.33-2 | No colour register changes at the call. While enabled, every later mode set and every DAC load through the BIOS writes grey = 0.30 R + 0.59 G + 0.11 B into all three components; disabled again, a mode set loads the colours | Ferraro 11.13.6 (Equation 11.6); IBM (VGATEST grey summing formula) | must | S3COMPAT 'AH=12 BL=33 grey summing on mode set' (fail 2: mode 13h entry 1 within 1 of the formula, 4: colour back after disable) |

### AH=12h BL=34h: cursor emulation

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B12.34-1 | AL = 00h enable, 01h disable cursor emulation (AH=01h cursor shapes given for an 8-line cell are scaled to the character height); returns AL = 12h. Kept in 0040:0087h bit 0 (1 = disabled) | RBIL AH=12h/BL=34h, MEM 0040:0087h; VGADOC VGABIOS.TXT; Ferraro 11.13.7 | must | `make v2-ref-compare` (AX=1200h BL=34h); not checked against IBM |

### AH=12h BL=35h: display switch

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B12.35-1 | AL = 00h initial adapter video off, 01h initial planar video on, 02h switch active video off, 03h switch inactive video on; ES:DX = a 128-byte buffer in which the BIOS saves or from which it restores the switched video state; returns AL = 12h when supported | RBIL AH=12h/BL=35h; VGADOC VGABIOS.TXT; Ferraro 11.13.8 | should | emu t_display_switch (AL=02h: AL = 12h and the buffer written; on the card AL=02h turns the video off, so not run there) |
| B12.35-2 | The BIOS writes no more than 128 bytes at ES:DX | RBIL AH=12h/BL=35h; Ferraro 11.13.8 | must | not checked (t_display_switch fills exactly 128 bytes) |
| B12.35-3 | Switching between two adapters only matters where both decode the same addresses (a planar video and an adapter); a single-card system rarely uses it | Ferraro 11.13.8 | note | not checked |

### AH=12h BL=36h: video screen on/off

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B12.36-1 | AL = 00h screen on (SR01 bit 5 = 0), 01h screen off (SR01 bit 5 = 1); returns AL = 12h. Video memory, the mode and the other registers are kept | Ferraro 11.13.9 ("Screen Off (SO) field of the Clocking Mode Register"); RBIL AH=12h/BL=36h; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=12 BL=36 screen off/on (SR01.5)' (fail 1) |
| B12.36-2 | With the screen off, the screen shows a single colour; RBIL says the colour of DAC entry 0, so a blank screen needs DAC 0 black | RBIL AH=12h/BL=36h | note | not checked |

### AH=12h: other BL values

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B12-1 | For a BL the BIOS does not support, AL is not 12h (AL is returned as given) and nothing changes; "AL = 12h" is how a caller tells a supported subfunction | Ferraro 11.13.3-11.13.9 ("any other value: call was invalid"); RBIL AH=12h ("AL = 12h if function supported") | should | emu t_errors (BL = 00h, 0Fh, 11h, 1Fh, 21h, 2Fh, 37h, 3Fh, 40h, FFh) |

### AX=1A00h, 1A01h: display combination code

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1A00-1 | AX=1A00h returns AL = 1Ah, BL = active display code, BH = alternate display code | RBIL AX=1A00h; VGADOC VGABIOS.TXT; Ferraro 11.15.1 | must | S3COMPAT 'AH=1A display combination code' (BX = 0008h on a colour VGA alone) |
| B1A00-2 | Codes: 00h no display, 01h MDA with mono display, 02h CGA with colour display, 04h EGA colour, 05h EGA mono, 06h PGA, 07h VGA with analog mono display, 08h VGA with analog colour display, 0Ah-0Ch MCGA, FFh unknown; 03h and 09h reserved | RBIL #00039, #M0040; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=1A display combination code' |
| B1A00-3 | The pair comes from the display combination code table (save pointer table 0040:00A8h -> secondary save pointer table, offset 02h -> DCC table: byte 00h number of entries, 04h onward one byte pair per entry), entry number 0040:008Ah | RBIL MEM 0040:008Ah, MEM 0040:00A8h (#M0037, #M0038, #M0039) | should | emu t_mono (every pair of the table) |
| B1A01-1 | AX=1A01h: BL = active, BH = alternate display code; returns AL = 1Ah. The BIOS records the combination: 0040:008Ah = the number of the table entry that holds the pair, so that AX=1A00h returns it | RBIL AX=1A01h, MEM 0040:008Ah; VGADOC VGABIOS.TXT; Ferraro 11.15.1 | must | S3COMPAT 'AH=1A display combination code' (AL = 1Ah); emu t_mono (read back, 0040:008Ah) |
| B1A-1 | AL = 02h-FFh: not supported, AL returned as given, nothing changes | RBIL AX=1A00h ("AL = 1Ah if function was supported") | should | emu t_errors (AX=1A02h, 1AFFh) |
| B1A-2 | AX=1A00h is the usual VGA presence test; a VGA BIOS supports it | RBIL AX=1A00h | must | S3COMPAT 'AH=1A display combination code' |

### AH=1Bh: functionality/state information

Fill a 64-byte buffer with the current state and a pointer to the static functionality table.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1B-1 | BX = 0000h (implementation type), ES:DI = 64-byte buffer; returns AL = 1Bh and the buffer filled. Exactly 64 bytes are written | RBIL AH=1Bh; VGADOC VGABIOS.TXT; Ferraro 11.15.2 | must | S3COMPAT 'AH=1B static functionality table' (AL), 'Mode xxh' lines (fail 2) |
| B1B-2 | Offset 00h: far pointer (offset, then segment) to the static functionality table (TAB-1) | RBIL #00040; VGADOC; Ferraro Table 9.10 | must | S3COMPAT 'AH=1B static functionality table' |
| B1B-3 | Offsets 04h-21h: the BIOS data 0040:0049h-0066h in the same order: mode, columns (word), page length (word), page start (word), cursor positions of pages 0-7 (8 words), cursor type (word), active page, CRTC address (word), the 3x8h and 3x9h settings | RBIL #00040; VGADOC VGABIOS.TXT (state table and Memory list); Ferraro Table 9.10 | must | S3COMPAT 'Mode xxh' lines (fail 2, against IBM for modes 00h-06h, 0Dh-13h and the 350-line text modes); emu t_vga_registers |
| B1B-4 | Offset 22h: number of character rows (0040:0084h + 1), 25 in mode 03h | IBM (VGATEST); VGADOC VGABIOS.TXT; Ferraro Table 9.10 note 2 | must | S3COMPAT 'Mode xxh' lines (fail 2; WARN 1 for mode 10h with the 8x16 font) |
| B1B-5 | Offset 23h: character height (word, 0040:0085h) | RBIL #00040; IBM (VGATEST) | must | S3COMPAT 'Mode xxh' lines (fail 2) |
| B1B-6 | Offsets 25h, 26h: active and alternate display codes, as AX=1A00h returns in BL and BH (08h and 00h for a colour VGA alone) | RBIL #00040; Ferraro Table 9.10; IBM (VGATEST) | must | S3COMPAT 'Mode xxh' lines (fail 2); emu t_vga_registers skips 26h |
| B1B-7 | Offset 27h: colours of the mode (word): 16 in 00h-03h, 0Dh, 0Eh, 10h, 12h; 4 in 04h, 05h; 2 in 06h, 11h; 256 in 13h; 0 (monochrome) in 07h and 0Fh | IBM (VGATEST) (all but 07h, 0Fh); Ferraro Table 9.15 (07h, 0Fh); RBIL #00040 ("0000h = mono") | must | S3COMPAT 'Mode xxh' lines (fail 2) |
| B1B-8 | Offset 29h: display pages of the mode: 8 in 00h-03h, 07h, 0Dh; 4 in 0Eh; 2 in 0Fh, 10h; 1 in 04h-06h, 11h-13h | IBM (VGATEST); Ferraro Table 9.15 (07h, 0Fh) | must | S3COMPAT 'Mode xxh' lines (fail 2) |
| B1B-9 | Offset 2Ah: scan line code 00h 200, 01h 350, 02h 400, 03h 480. Text modes at 400 lines 02h, at 350 lines 01h; 04h-06h, 0Dh, 0Eh, 13h 00h; 0Fh, 10h 01h; 11h, 12h 03h | IBM (VGATEST); RBIL #00040; Ferraro Table 9.11 | must | S3COMPAT 'Mode xxh' lines (fail 2) |
| B1B-10 | Offsets 2Bh, 2Ch: the character blocks of SR03: 2Bh the block for attribute bit 3 clear (SR03 bits 4, 1, 0), 2Ch the block for attribute bit 3 set (SR03 bits 5, 3, 2); both 00h after a mode set | RBIL AX=1100h note ("offsets 2Bh and 2Ch"), #00020, #00040; IBM (VGATEST: 00h) | should | S3COMPAT 'Mode xxh' lines (fail 2, only the 00h of a fresh mode) |
| B1B-11 | Offset 2Dh, miscellaneous flags: bits 3-0 = 0040:0089h bits 3-0 (0 all modes on all displays / VGA active, 1 grey summing on, 2 mono display, 3 default palette loading disabled); bit 5 = 1 when attribute bit 7 means blink (AR10 bit 3), 0 for background intensity; bits 7-6 = 0. IBM: 21h (text) and 01h (graphics) with bit 4 masked | RBIL #00041; VGADOC VGABIOS.TXT (0040:0089h); IBM (VGATEST) | must | S3COMPAT 'Mode xxh' lines (fail 2, bit 4 ignored); emu t_vga_registers skips 2Dh |
| B1B-12 | Offset 2Dh bit 4 = cursor emulation enabled (0040:0087h bit 0 clear) by RBIL and VGADOC; the IBM reference data show 0 in text modes with emulation enabled. Programs must not depend on it | RBIL #00041; VGADOC VGABIOS.TXT; IBM (VGATEST) | note | S3COMPAT 'Mode xxh' lines ignore it |
| B1B-13 | Offsets 2Eh-30h: 00h. Offset 31h: memory code as AH=12h BL=10h (0040:0087h bits 6-5; 03h = 256 KB on a VGA). Offsets 33h-3Fh: 00h on a VGA without flat panel (RBIL defines 33h for flat-panel PS/2 systems) | RBIL #00040, #00044; VGADOC VGABIOS.TXT; IBM (VGATEST: 31h = 03h) | must | S3COMPAT 'Mode xxh' lines (fail 2: 2Eh-32h) |
| B1B-14 | Offset 32h, save pointer state flags: bit 0 512-character set active, 1 dynamic save area present, 2 alphanumeric font override active, 3 graphics font override active, 4 palette override active, 5 DCC override active (the save pointer table at 0040:00A8h and its secondary table); 00h with the BIOS's own tables | RBIL #00043; VGADOC VGABIOS.TXT; IBM (VGATEST: 00h) | should | S3COMPAT 'Mode xxh' lines (fail 2: 00h only) |

### AH=1Ch: save/restore video state

Save the video hardware, BIOS data and DAC into a caller's buffer and restore them later.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B1C-1 | CX selects the state classes: bit 0 video hardware, bit 1 BIOS data area, bit 2 DAC state and colour registers; bits 3-15 reserved (0). Any combination of bits 0-2 is valid | RBIL AH=1Ch (#00048); VGADOC VGABIOS.TXT; Ferraro 11.15.3 | must | S3COMPAT 'AH=1C save/restore video state' (CX = 7) |
| B1C00-1 | AX=1C00h: returns AL = 1Ch and BX = the buffer size for the classes in CX, in 64-byte blocks | RBIL AH=1Ch; VGADOC; Ferraro 11.15.3 | must | S3COMPAT 'AH=1C save/restore video state' (fail 1; the size is printed) |
| B1C00-2 | The size is large enough: AX=1C01h with the same CX writes no more than BX x 64 bytes at ES:BX | RBIL AH=1Ch ("number of 64-byte blocks needed") | must | not checked |
| B1C01-1 | AX=1C01h: ES:BX = buffer; saves the classes in CX; returns AL = 1Ch | RBIL AH=1Ch; Ferraro 11.15.3 | must | S3COMPAT 'AH=1C save/restore video state' |
| B1C02-1 | AX=1C02h: ES:BX = a buffer saved before with the same CX; restores those classes; returns AL = 1Ch. After a save in one mode, a mode set and the restore, the video state is the saved one | RBIL AH=1Ch; Ferraro 11.15.3 | must | S3COMPAT 'AH=1C save/restore video state' (mode 03h with cursor 5,5 and DAC entry 1 changed, mode 13h, restore: fail 2 registers, 4 mode byte, 8 DAC entry 1) |
| B1C-2 | Hardware class: the index registers of the sequencer, CRTC, graphics controller and attribute controller, feature control, SR01-SR04, CR00-CR18, AR00-AR13 (palette AR00-0Fh, then AR10-AR13), GR00-GR08, the CRTC base address (3B4h/3D4h) and the four latches; the restore puts all of them back, including the latches | RBIL #00049; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=1C save/restore video state' (fail 2: 62 standard registers against IBM mode 03h) |
| B1C-3 | Hardware class layout as RBIL gives it: 00h-03h indexes (sequencer, CRTC, graphics, attribute), 04h feature control, 05h-08h SR01-SR04, 09h (see open questions), 0Ah-22h CR00-CR18, 23h-32h AR00-0Fh, 33h-36h AR10-13h, 37h-3Fh GR00-08h, 40h-41h CRTC base address, 42h-45h latches of planes 0-3 | RBIL #00049; VGADOC VGABIOS.TXT | should | not checked (the buffer is used as a whole) |
| B1C-4 | BIOS data class: the video BIOS data of 0040:0049h onward (mode, columns, page data, cursor, CRTC address, rows, height, control and switch bytes, the save pointer); the restore puts back the mode byte and the cursor | RBIL AH=1Ch note ("the 96 bytes from 0040h:0049h-00A8h") | must | S3COMPAT 'AH=1C save/restore video state' (fail 4: 0040:0049h = 03h; the cursor through CR0E/CR0F) |
| B1C-5 | DAC class layout: 00h DAC read/write mode, 01h pixel address, 02h pixel mask, 03h-302h 256 colour triples, 303h colour select (AR14); the restore loads all 256 entries and these registers | RBIL #00050; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=1C save/restore video state' (fail 8: DAC entry 1) |
| B1C-6 | Where the classes lie in the buffer, and anything else in it, is the BIOS's own: a caller keeps the buffer as an opaque block and restores with the CX it saved with | RBIL AH=1Ch (only the class formats are given) | should | not checked |
| B1C-7 | Saving may disturb the video registers; a program should restore right after saving (the saved data are correct) | RBIL AH=1Ch note ("many BIOSes corrupt the video registers when saving the state") | note | S3COMPAT restores after the mode set; not checked separately |
| B1C-8 | AL = 03h-FFh is not supported and must not change the video state; AL other than 1Ch tells the caller it failed | Ferraro 11.15.3 ("1C hex: call was valid; any other value: invalid"); RBIL AH=1Ch | should | emu t_errors (AX=1C03h: no state change; AL = 1Ch is accepted there as known behaviour of our base) |
| B1C-9 | AX=1C00h with CX nonzero is a better VGA presence test than AX=1A00h (some EGA cards answer 1A00h) | RBIL AH=1Ch, AX=1A00h | note | not checked |

### Static functionality table (the table AH=1Bh points to)

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| TAB-1 | 16 bytes: 00h-02h supported modes (one bit a mode: 00h bits 0-7 modes 00h-07h, 01h modes 08h-0Fh, 02h bits 0-3 modes 10h-13h), 03h-06h reserved, 07h text scan lines supported (bit 0 200, 1 350, 2 400), 08h character blocks available in text modes, 09h maximum active character blocks, 0Ah-0Bh miscellaneous function flags (word), 0Ch-0Dh reserved, 0Eh save pointer function flags, 0Fh reserved | RBIL #00045; VGADOC VGABIOS.TXT; Ferraro Table 9.16 | must | S3COMPAT 'AH=1B static functionality table' (bytes 00h-02h and 07h) |
| TAB-2 | A VGA: 00h-02h = FFh, E0h, 0Fh (modes 00h-07h, 0Dh-0Fh, 10h-13h; no 08h-0Ch) and 07h = 07h | Ferraro Table 9.17, Table 9.18; IBM (VGATEST mode set) | must | S3COMPAT 'AH=1B static functionality table' (fail 1) |
| TAB-3 | 03h-06h, 0Ch, 0Dh, 0Fh are 00h on IBM's VGA; some vendors use 03h-06h for their extended mode numbers | RBIL #00045 (IBM reserved, Tseng) | note | not checked |
| TAB-4 | 0Ah-0Bh, bit set = supported: 0 all modes on all displays, 1 grey summing, 2 font loading, 3 palette loading enable/disable, 4 cursor emulation, 5 EGA palette (AX=1000h-1003h), 6 colour palette (DAC), 7 colour register paging, 8 light pen, 9 save/restore (AH=1Ch), 10 intensity/blink (AX=1003h), 11 display combination code (AH=1Ah). A VGA: FFh, 0Eh (no light pen) | RBIL #00046; VGADOC VGABIOS.TXT; Ferraro Tables 9.17, 9.20 | should | not checked |
| TAB-5 | 08h and 09h: Ferraro's VGA example gives 2 and 8 (in that order); RBIL's field names suggest 8 blocks available and 2 active for a VGA. Programs should not depend on them | Ferraro Table 9.17; RBIL #00045 | note | not checked |
| TAB-6 | 0Eh, save pointer function flags (bit 0 512-character set, 1 dynamic save area, 2 alphanumeric font override, 3 graphics font override, 4 palette override, 5 DCC extension); Ferraro's example gives 00h | RBIL #00047; VGADOC VGABIOS.TXT; Ferraro Table 9.17 | note | not checked |
| TAB-7 | The table is static: the same contents (and pointer) whatever the mode or state | Ferraro 9.4.4 ("the values do not change during the operation of the VGA") | should | not checked |

### Font tables (AX=1130h, INT 1Fh, INT 43h)

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| TAB-8 | ROM fonts 8x8 (BH=03h), 8x14 (02h) and 8x16 (06h): one glyph of N bytes (8, 14, 16) per character, top scan line first, character c at offset c x N, bit 7 the leftmost pixel, 1 = foreground; 256 characters (the 8x8 font in two halves of 128, B1130-1) | Ferraro 11.12.1, 11.12.15; RBIL AX=1130h | must | S3COMPAT 'AX=1130 BH=3 8x8 font', 'AX=1130 BH=6 8x16 font' (glyph 01h), 'AX=1130 BH=4 8x8 upper half' (glyph 80h) |
| TAB-9 | The glyphs are the IBM PC character set (code page 437) | IBM (glyph 01h and 80h as S3COMPAT encodes them) | should | S3COMPAT 'AX=1130 BH=3/6' (fail 2: glyph 01h), 'AX=1130 BH=4 8x8 upper half' (WARN 02 for another design, FAIL when blank) |
| TAB-10 | Alternate tables (BH=05h 9x14, 07h 9x16): entries of one byte character code followed by N glyph bytes (14 or 16); a code byte 00h ends the table. They replace the 8-dot glyphs of characters that need the ninth column in 9-dot text modes | RBIL AX=1130h (#00021); Ferraro 11.12.1 | must | not checked |
| TAB-11 | INT 1Fh (0000:007Ch) points to 128 8x8 glyphs for codes 80h-FFh, used in the CGA graphics modes 04h-06h; INT 43h (0000:010Ch) to the graphics-mode font (the 8x8 lower half or a 256-character font of 0040:0085h bytes) | Ferraro 11.12.10, 11.12.15, Table 9.7 | must | S3COMPAT 'AX=1120-1124 graphics fonts', 'AX=1130 BH=1 INT43 in mode 13' |
| TAB-12 | After a mode set of 13h the INT 43h vector points to the ROM 8x8 font (the BH=03h table) | Ferraro 11.12.15; IBM (VGATEST: 0040:0085h = 8 in mode 13h) | must | S3COMPAT 'AX=1130 BH=1 INT43 in mode 13' (fail 1) |

### Open questions

Behaviour the public sources leave open, to be settled by running our ROMs in the emulator.

1. Does AX=1100h-1104h (and 1110h-1114h before their recalculation) reprogram the whole mode (CRTC,
   attribute registers, DAC, cursor, BIOS data) as a mode set would, or only put back the sequencer
   and graphics registers it changed to reach plane 2?
2. Which registers does a text font load leave changed: SR02, SR04, GR04, GR05, GR06 back at the
   mode's values; is the screen blanked during the load and turned on again afterwards?
3. In each 32-byte character slot, are the bytes after the first BH left as they were or cleared?
4. AX=1100h/1110h edge cases: CX = 0 (nothing, 256, or 65536 characters?), CX above 256 or DX + CX
   above 256 (wrap within the block, stop, or write into the next block?), DX above 255, BH = 0,
   BH above 32, BL above 7 (masked to 3 bits?).
5. AX=1101h-1104h and 1111h-1114h in a graphics mode: do they load plane 2 anyway, change nothing, or
   change the BIOS data?
6. Does AX=1101h/1111h apply the 9x14 alternates in a 9-dot mode, or load the plain 8x14 font only?
7. AX=1110h-1114h: is 0040:004Ch exactly rows x columns x 2, or rounded (for example + 256), and is
   it written only when it grows? Are 0040:0062h (active page), 0040:004Eh (page start) and
   CR0C/CR0D set to 0, and is the cursor shape in 0040:0060h updated with CR0A/CR0B?
8. AX=1110h-1114h: is CR14 (underline location) changed, and to H - 1 or H? Are CR09 bits 7-5 kept?
   Are 0040:0084h, 0040:0085h and CR09 recalculated in mode 07h the same way as in mode 03h?
9. Do the undefined AL values of AH=11h (05h-0Fh, 13h, 15h-1Fh, 25h-2Fh, 31h-FFh) change nothing
   and keep AL, or does any of them act as a defined subfunction?
10. AX=1121h-1124h with BL above 03h: what row count results, and is 0040:0084h changed? Does
    AX=1121h write only the low byte of 0040:0085h (CL) or the whole word (CX)?
11. AX=1130h with BH = 08h-FFh: what comes back in ES:BP, and do CX and DL change? Are AX, BX and DH
    kept on every BH?
12. Is the AX=1130h BH=04h pointer always the BH=03h pointer + 400h (one contiguous 256-character
    8x8 table), so that programs that index the BH=03h table with codes 80h-FFh work?
13. AH=12h BL=10h and BL=20h: is AL changed (to 12h or anything else), and are all registers other
    than BX and CX kept by BL=10h?
14. AH=12h BL=30h with AL = 03h-FFh: refused (AL not 12h), or taken as one of 200/350/400? With a
    mono display active, is the switch nibble of 0040:0088h still written?
15. AH=12h BL=31h, 33h, 34h, 36h with AL = 02h-FFh: refused, or treated as 01h (any nonzero AL)?
16. AH=12h BL=32h: which register does the BIOS write (3C3h bit 0 or 46E8h bit 3), and on a card that
    cannot disable itself, does the call still return AL = 12h?
17. AH=12h BL=35h: which AL values write the 128-byte buffer and which read it; what does it hold
    (the equipment bits of 0040:0010h, 0040:0049h-0066h, 0040:0084h-008Ah, 0040:00A8h, the INT 05h,
    1Dh, 1Fh and 43h vectors?); with AL other than 00h-03h, what is AL on return? Does AL=00h call
    the system BIOS (INT 42h) or swap the INT 42h and INT 6Dh vectors?
18. AH=12h BL=20h: the alternate print-screen routine prints rows 0 to 0040:0084h of the active page
    with 0040:004Ah columns; does it replace codes 00h, 0Ah-0Dh by spaces, put the cursor back, and
    ignore an INT 05h while 0050:0000h = 01h?
19. AX=1A00h: when the current mode uses the mono CRTC (3B4h) and the stored pair has a mono and a
    colour display, is the mono display returned as the active one (BL and BH swapped against the
    table entry)? When 0040:008Ah is beyond the table, is BX = FFFFh?
20. AX=1A01h with a pair that is in no table entry: is 0040:008Ah set to FFh, left unchanged, and is
    AL = 1Ah returned anyway?
21. AH=1Bh with BX not 0000h: is the buffer written, and what is AL? What is AH on return (unchanged,
    or another value)? Does the call leave the attribute controller index (and its palette address
    source bit) and the other index registers as it found them?
22. AH=1Bh offset 2Dh bit 4 on our ROMs: set or clear with cursor emulation enabled? Bits 7-6: always
    0?
23. Static functionality table bytes 08h, 09h, 0Ah, 0Bh and 0Eh of our ROMs: which values, and do
    they match the functions the ROM supports (TAB-4 to TAB-6)?
24. AX=1C00h: which BX for CX = 1 to 7? (From the public class formats alone: hardware 70 bytes,
    BIOS data 96 bytes, DAC 772 bytes.) Is there a header in the buffer (offsets of the classes),
    and where do the classes start?
25. AH=1Ch with CX = 0, or with reserved CX bits 3-15 set: is AL = 1Ch returned, and is anything
    saved, restored or written? What is AL for AX=1C03h-1CFFh?
26. AH=1Ch hardware class offset 09h: SR00 (as RBIL and VGADOC name it) or the miscellaneous output
    register (as offset 09h of a parameter table entry is)? Are the attribute index and the palette
    address source bit restored?
27. Does saving the hardware class change video memory (to read the latches, for example at offset
    FFFFh of the A000h window), or leave the screen turned on (palette address source set) when it
    was off?
28. AH=1Ch BIOS data class: exactly which bytes (0040:0010h equipment bits, 0040:0049h-0066h,
    0040:0084h-008Ah, 0040:00A8h-00ABh?) and which interrupt vectors (05h, 1Dh, 1Fh, 43h?) does it
    save and restore?
29. AH=1Ch restore of the DAC class: is the DAC left in the saved read or write mode with the saved
    pixel address (adjusted for the auto-increment in read mode)?
30. Are BX, CX and DX kept by AX=1C01h and 1C02h, and BX by AH=12h BL=30h-36h?

### Sources disagree

- AH=1Bh offset 22h: RBIL #00040 says "number of rows - 1"; VGADOC says "number of rows", Ferraro
  Table 9.10 note 2 says one more than the EGA's 0040:0084h, and the IBM reference data (VGATEST)
  have 19h (25) in mode 03h. The rule (B1B-4) follows IBM: rows.
- AH=1Bh offset 31h: Ferraro Table 9.13 gives 0 = 64 KB, 1 = 128 KB, 2 = 256 KB, 3 = 384 KB; RBIL,
  VGADOC and Ferraro 11.13.1 itself give 03h = 256 KB, and IBM has 03h. The rule (B1B-13) follows
  RBIL.
- AH=1Bh offset 2Dh bit 3: Ferraro Table 9.12 reads "1 = palette and colour registers loaded"; RBIL
  and VGADOC "default palette loading disabled" (0040:0089h bit 3). The rule (B1B-11) follows RBIL.
- AH=1Bh offset 2Dh bit 4: RBIL and VGADOC say "cursor emulation enabled", and Ferraro's typical
  values (Table 9.15: 31h in text, 11h in graphics) have it set; the IBM reference data have 21h and
  01h. The rule is a note (B1B-12); S3COMPAT ignores the bit.
- Static functionality table 08h/09h: Ferraro Table 9.17 has 2 blocks available and 8 active, the
  reverse of what RBIL's field names suggest for a VGA. Note (TAB-5).
- Static functionality table 0Eh: Ferraro's example has 00h; RBIL defines the bits without a value.
  Note (TAB-6).
- AH=1Bh offset 33h: RBIL defines a display information byte (flat panel) and 12 reserved bytes;
  VGADOC 13 reserved bytes. Both give 00h for a VGA without flat panel (B1B-13).
- AX=1130h CX: RBIL "bytes/character of on-screen font (not the requested font!)"; Ferraro 11.12.15
  "the number of bytes per character in the selected character set"; VGADOC "bytes/character". The
  rule (B1130-3) follows RBIL.
- AX=1130h specifiers: Ferraro 11.12.10 and 11.12.11 say the AX=1120h and 1121h pointers are read
  with BH=01h, and 11.12.14 says the 8x16 pointer with BH=08h; Ferraro Table 11.21, RBIL and VGADOC
  give BH=00h INT 1Fh, 01h INT 43h, 06h 8x16. The rule (B1130-1) follows the table.
- AX=1121h-1124h with BL=00h: Ferraro 11.12.11-11.12.13 allow it on the EGA only (but Table 11.20
  lists it for 1124h); RBIL and VGADOC list it without restriction. The rule (B1121-2) follows RBIL,
  as *should*.
- AX=1121h-1124h, what changes: Ferraro names "the Graphics Mode Auxiliary Character Generator Table"
  as the host memory affected; RBIL and Ferraro's own text (11.12.11) put the pointer into the INT 43h
  vector. The rule (B1120-2) follows RBIL.
- AX=1110h-1114h cursor: RBIL and VGADOC give CR0A = H - 2 and CR0B = 0 (the EGA's values); Ferraro
  11.12.6 gives the VGA CR0A = H - 2, CR0B = H - 1. The rule (B1110-7) follows Ferraro, as *should*.
- AX=1110h-1114h CR09: RBIL and VGADOC write "R09 = bytes/char - 1 (mode 7 only)"; Ferraro sets the
  maximum scan line in every text mode. The rule (B1110-5) follows Ferraro; S3COMPAT checks it in
  mode 03h.
- AX=1110h-1114h CR14: RBIL and VGADOC give R14 = bytes/char ("BUG: should be 1 less"); Ferraro does
  not mention CR14. No rule; open question 8.
- AX=1101h: Ferraro 11.12.2 calls it the 9x14 monochrome set (the 8x14 font with the 9x14
  supplement); RBIL says the patterns are 8x14. The rule (B1100-4, B1100-7) follows RBIL; open
  question 6.
- AH=12h BL=20h: Ferraro 11.13.2 says the programmer supplies the print handler and loads INT 05h;
  RBIL and VGADOC say the call installs the video BIOS's own routine. The rule (B12.20-1) follows
  RBIL.
- Print-screen status: Ferraro 11.13.2 puts it at 500h, Ferraro 9.3.2 at 0000:0100; RBIL at
  0050:0000h (= 0000:0500h). The rule (B12.20-2) follows RBIL.
- AH=12h BL=30h: Ferraro 11.13.3 lists the miscellaneous output register as affected; RBIL (and
  Ferraro's own text) say the choice takes effect at the next mode set. The rule (B12.30-1) follows
  RBIL.
- AH=12h BL=35h buffer: RBIL uses ES:DX for AL=00h-03h, VGADOC for AL=00h, 02h, 03h, Ferraro 11.13.8
  for AL=00h and 01h (and none for 03h). The rule (B12.35-1) follows RBIL; open question 17.
- Display combination codes: Ferraro Table 11.26 lists codes 0 and 1 as the MDA (0 with no monitor);
  RBIL, VGADOC and Ferraro Table 9.21 have 00h = no display. The rule (B1A00-2) follows RBIL.
- AH=1Ch hardware state: RBIL and VGADOC write "0Ah 25 BYTEs CRTC registers 0-8", an evident misprint
  for CR00-CR18 (25 bytes, the next field at 23h); both name offset 09h "sequencer register 0" (open
  question 26). Ferraro gives no layout. B1C-2 and B1C-3 read the CRTC field as CR00-CR18.
- AH=1Ch BIOS data class: RBIL says "the 96 bytes from 0040h:0049h-00A8h"; no other source gives its
  contents. B1C-4 states only what the tests can check; open question 28.

