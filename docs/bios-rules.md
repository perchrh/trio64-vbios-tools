# Standard video BIOS: behaviour rules (CGA, EGA, VGA functions of INT 10h)

This file describes what a VGA-compatible video BIOS must do, function by function, as behaviour a
caller can observe: registers in and out, flags, the BIOS data area, video memory, the I/O port state
and the interrupt vectors. It covers the IBM-compatible part of our ROMs, INT 10h AH=00h-1Ch, the BIOS
data area and the tables a VGA BIOS publishes; no VBE and no S3 registers (those are in
[`docs/chip-rules.md`](chip-rules.md)). Like [chip-rules.md](chip-rules.md) it is meant as part of a clean-room specification
([`docs/clean-room.md`](clean-room.md)): someone who has never seen a BIOS image or BIOS source should be able to
write a compatible BIOS from it.

## Conventions

- **Sources.** Every rule rests on a public source: Ferraro (R. Ferraro, Programmer's Guide to the
  EGA, VGA and Super VGA Cards, 3rd edition, 1994; cited by section), RBIL (Ralf Brown's Interrupt
  List, release 61, 2000; cited by entry and table number), VGADOC (Finn Thoegersen's VGADOC 4b,
  [`standards/thoegersen/`](../standards/thoegersen/)), or IBM (the IBM VGA BIOS behaviour as VGATEST, PC Tech Journal, November
  1988, "The VGA Compatibility Test" by Ed McNierney and Kent Quirk, page 48, gives it, encoded in
  [`s3compat/vgaref.inc`](../s3compat/vgaref.inc) and the S3COMPAT checks; VGATEST is a public source per the
  owner decision of 8 November 2026 — a mass-market magazine publication, its issue text in hand from
  [pcjs.org](https://www.pcjs.org/documents/magazines/pctj/) — and vgaref.inc is the project's encoding of its
  test results; the distribution itself — the SimTel mirror VGATEST2.ZIP — is allowlisted material in hand
  (owner decision, 8 November 2026), and its shipped tables (CRTC.COL, GENERAL.COL, DSTATE.COL, DAC.COL)
  verified the citations that name them). Nothing here comes from a
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
- **Checked by.** The S3COMPAT line, S3TEST line or emulator test ([`emu/tests.py`](../emu/tests.py)) that checks the
  rule, or "not checked". `make 775-ref-compare` compares every call in the CGA, EGA and MDA modes with
  the unpatched reference BIOS: it finds regressions, it does not prove IBM behaviour.
- **General rule.** A register not named in a rule's outputs is returned as the caller gave it.
- **Sources disagree** lists, per section, where Ferraro, RBIL and VGADOC differ and which the rule
  follows.

Written 31 October 2026 from the sources above. Open questions remain open until answered with a
cited public source or a leak-reviewed observation; they are not requirements. Independent-review
returns of 2 November 2026 for B00-5, B09-11, B10-1, B11-1, B12-1, B1A-1, B1C-8, TAB-9 and selected
open questions were applied 5 November 2026.

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
S3COMPAT lines "Mode nnh" of the VGA mode pass (modes 00h-07h, 0Dh-0Fh, 10h-13h at 400/480 lines and
00h-03h at 350 lines, each run twice: from a clean state and right after a VESA mode); their fail bits
are 1 registers vs IBM, 2 BIOS data/AH=0Fh/AH=1Bh, 8 refresh, 10 memory, 20 default DAC (wrong on a
second read and after the mode set again; wrong once only is warn 2 or 4). Modes 07h and 0Fh are in vgaref.inc too, from VGATEST's .MON tables (allowlisted
VGATEST2.ZIP) with Ferraro Table 11.2 as the named parameter-table source; emu t_mono also covers them. `make 775-ref-compare` compares the ROM with
the unpatched reference BIOS in modes 00h-07h and 0Dh-10h at 200, 350 and 400 lines, with and without
the clear; it finds regressions, it does not prove IBM behaviour.

### Mode definitions (00h-13h)

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| MODE-1 | A VGA BIOS supports modes 00h-07h and 0Dh-13h. 08h-0Ch are no VGA modes (08h-0Ah PCjr/Tandy, 0Bh and 0Ch reserved for the EGA BIOS); the static functionality table marks them unsupported (TAB-2) | RBIL INT 10/AH=00h (#00010); Ferraro 11.2 Table 11.2, Table 9.18; VGADOC VGABIOS.TXT (AH=00h) | must | S3COMPAT 'Mode nnh' (00h-06h, 0Dh, 0Eh, 10h-13h); emu t_mono (07h, 0Fh); S3COMPAT 'AH=1B static functionality table' |
| MODE-2 | Video buffer: B800h for 00h-06h, B000h for 07h, A000h for 0Dh-13h | RBIL #00010; VGADOC VGABIOS.TXT; Ferraro 11.2 | must | S3COMPAT 'Mode nnh' fail 10 (memory test in the mode's window); emu t_mono (B000h in 07h) |
| MODE-3 | Text modes: 00h and 01h are 40x25, 02h, 03h and 07h 80x25 characters. Character cell and screen: at 400 lines (the VGA default) 9x16, 360x400 (40 columns) or 720x400 (80 columns); at 350 lines 8x14 in 00h-03h (320x350, 640x350) and 9x14 in 07h (720x350); at 200 lines 8x8 (320x200, 640x200), shown double-scanned on 400 lines. 07h has no 200-line form | Ferraro 11.2 Table 11.2; RBIL #00010; RBIL MEM 0040:0088h note (#M0025: "200-line CGA in 400-line double scan"); Ferraro 11.13.3 | must | S3COMPAT 'Mode nnh' and 'Mode nnh 350' fail 1 (00h-03h); emu t_mono (07h at 400 and 350 lines); make 775-ref-compare (200, 350, 400 lines) |
| MODE-4 | Graphics modes: 04h and 05h 320x200 in 4 colours, 06h 640x200 in 2, 0Dh 320x200 in 16, 0Eh 640x200 in 16, 0Fh 640x350 monochrome (planes 0 and 2: black, video, blink, intensified), 10h 640x350 in 16, 11h 640x480 in 2, 12h 640x480 in 16, 13h 320x200 in 256 colours | Ferraro 11.2 Table 11.2; RBIL #00010; VGADOC VGABIOS.TXT | must | S3COMPAT 'Mode nnh'; emu t_mono (0Fh pixel values 0, 1, 4, 5) |
| MODE-5 | Text grid of the graphics modes (for AH=02h, 09h, 0Eh): 40x25 in 04h, 05h, 0Dh and 13h; 80x25 in 06h, 0Eh, 0Fh and 10h; 80x30 in 11h and 12h. Cell 8 pixels wide; 8 lines high in 04h-06h, 0Dh, 0Eh, 13h, 14 in 0Fh and 10h, 16 in 11h and 12h | Ferraro 11.2 Table 11.2; Ferraro 11.9.4 Table 11.6 (columns); IBM (VGATEST state block 22h, 23h) | must | S3COMPAT 'Mode nnh' fail 2 (state block columns, rows, height) |
| MODE-6 | 00h, 02h and 05h are the "black and white" forms of 01h, 03h and 04h. On a VGA they program the same registers and the same default palette as their colour forms; they differ only in the CGA mode select copy 0040:0065h (bit 2) and in the mode number | Ferraro 11.2 ("these modes are identical"); IBM (VGATEST: the same register and DAC tables for 00h/01h, 02h/03h, 04h/05h; 0065h = 2Ch/28h, 2Dh/29h, 2Ah/2Eh) | must | S3COMPAT 'Mode nnh' fail 1, 2, 20 |
| MODE-7 | Display pages: 8 in 00h-03h and 07h (at every scan line count), 1 in 04h-06h, 8 in 0Dh, 4 in 0Eh, 2 in 0Fh and 10h, 1 in 11h-13h | Ferraro 11.2 Table 11.2; IBM (VGATEST state block 29h) | must | S3COMPAT 'Mode nnh' fail 2 (state block 29h; 07h and 0Fh included) |
| MODE-8 | Page length (0040:004Ch, from the parameter table): 0800h in 00h/01h, 1000h in 02h/03h and 07h, 4000h in 04h-06h, 2000h in 0Dh, 4000h in 0Eh, 8000h in 0Fh and 10h, A000h in 11h and 12h, 2000h in 13h; page p starts at p times this length (AH=05h, B05-1). The same values at 200, 350 and 400 lines | IBM (VGATEST state block 07h); Ferraro Table 9.3 (07h, 0Fh); RBIL INT 1D (#01263: 0800h, 1000h, 4000h) | must | S3COMPAT 'Mode nnh' fail 2 (07h and 0Fh included) |
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
| B00-2 | BX, CX, DX, SI, DI, BP, DS and ES come back as the caller gave them | Ferraro 11.2.1 (no output); RBIL INT 10/AH=00h | should | make 775-ref-compare (registers against the reference BIOS) |
| B00-3 | AL on return differs between BIOSes: some return 30h (modes 00h-05h, 07h), 3Fh (06h) or 20h (above 07h), one returns the CRT mode byte, others AL unchanged. A program must not depend on AL | RBIL INT 10/AH=00h ("Return: AL = video mode flag (Phoenix, AMI BIOS)"); VGADOC VGABIOS.TXT | note | make 775-ref-compare (AL against the reference BIOS) |
| B00-4 | AL bit 7 = 1: the mode is set as usual (registers, BIOS data, palette, font, cursor), but video memory is not erased. 0040:0049h receives the mode without bit 7, and 0040:0087h bit 7 is set; a mode set with AL bit 7 = 0 clears 0040:0087h bit 7 again | Ferraro 11.2.1 ("Erasure During Mode Change"); RBIL INT 10/AH=00h note ("IBM standard modes do not clear the screen if the high bit of AL is set"); RBIL MEM 0040:0087h bit 7 (#M0024); Ferraro Table 9.26 bit 7 | must | emu t_windows (AL=83h: text kept, 0049h = 03h, 0087h bit 7 set; then AL=03h clears and resets the bit); make 775-ref-compare (AL bit 7 in 00h-07h, 0Dh-10h) |
| B00-5 | AL bit 7 = 0: video memory is erased (Ferraro 11.2.1, legible: "If the most significant bit of AL is set to 1, the display memory is not erased after a mode change. If the most significant bit of AL is reset to 0, the display memory is erased after a mode change."). The exact fill values and extents are published in VGATEST ("The VGA Compatibility Test", PC Tech Journal, November 1988, page 48; a public source per the owner decision of 8 November 2026, the issue text in hand from [pcjs.org](https://www.pcjs.org/documents/magazines/pctj/)). The printed article describes the test suite but not the numeric values; they are test logic inside VGATEST.EXE, which is allowlisted and in hand (the SimTel distribution, 8 November 2026) — the values below are the project's encoding of the test results, to be checked by running the shipped EXE. The project fills: text modes blanks (character 20h, attribute 07h) through B800:0000h-7FFFh (B000:0000h-7FFFh in 07h); graphics modes pixel value 0 through B800:0000h-7FFFh in 04h-06h and all four planes of A000h in 0Dh-13h. The S3TEST lines check those fills; they are not themselves the source | Ferraro 11.2.1 (erased/not erased by AL bit 7); VGATEST (public per the owner decision of 8 November 2026; the printed article in hand, the numeric values pending its source code) | must (erased), should (fill values and extents) | S3TEST 'VGA mode set clear 13h 12h 03h' (fail 1 A000h 00h in 13h, 2 all planes 00h in 12h, 4 B800:0000h-7FFFh 0720h in 03h) |
| B00-6 | Text modes keep the font in plane 2 whatever bit 7 says: the clear writes planes 0 and 1 only (B00-14 loads the font). With bit 7 = 1 the character codes and attributes stay in planes 0 and 1, so a change from a text to a graphics mode without the clear shows them, and the font, as pixels | Ferraro 11.2.1 ("the character ASCII codes, attributes, and the current character fonts are loaded into the four planes") | should | S3TEST 'Font load 8x16 and 8x8 in plane 2' (after a mode set); make 775-ref-compare (the four planes) |
| B00-7 | Registers: MISC, SR01-04, CRTC 00h-18h, AR00-13h and GR00-08h get the values of the mode's parameter table entry (TAB-13, TAB-15); for the standard modes these are the publicly documented initial values. AR14h (colour select) = 00h and the feature control register = 00h | RBIL MEM 0040:00A8h (#M0041, #M0042); Ferraro 9.2.2, Table 9.31; Ferraro Table 9.6 "Control Register Initial Values: VGA" (modes 00h-13h, legible in the owner-supplied full text, 8 November 2026) — where the project's 400-line choices differ from a table entry, the project choice is labelled as such | must | S3COMPAT 'Mode nnh' fail 1 (62 registers); emu t_vga_registers; make 775-ref-compare |
| B00-8 | The registers are written with the screen blanked and the sequencer reset; when the call returns, the screen is on (SR01 bit 5 = 0), the sequencer runs (SR00 = 03h) and the attribute controller shows the palette (PAS = 1). The CRTC protect bit CR11 bit 7 is set as in IBM's tables, so a program clears it before it writes CR00-07 | IBM (VGATEST: SR00 = 03h, SR01 bit 5 = 0, CR11 bit 7 = 1); Ferraro 10.6.1 (PAS) | must | S3COMPAT 'Mode nnh' fail 1; S3TEST 'VGA ATC flip-flop reset by mode set' |
| B00-9 | Before its first access to 3C0h, a BIOS establishes a known attribute flip-flop state by reading Input Status 1. A caller must likewise read 3BAh/3DAh before its next access; this rule specifies no final flip-flop state | Ferraro 10.6.1; VGADOC VGAREGS.TXT (3C0h) | should | S3TEST ATC flip-flop lines (pre-access sync only; no final-state claim) |
| B00-10 | Default palette (0040:0089h bit 3 = 0): AR00-0Fh and the overscan AR11 come from the parameter table and the DAC is loaded: in 13h the 256-colour defaults; in 04h-06h, 0Dh, 0Eh the CGA palette; in 00h-03h at 350 and 400 lines and in 10h-12h the EGA palette. The 256-colour defaults of 13h are publicly documented in full and doubly verified: Ferraro 8.3.5 Table 8.14 (extracted with verification at [`cleanroom/primary-extracts/ferraro-table-8-14-color-register-defaults.md`](cleanroom/primary-extracts/ferraro-table-8-14-color-register-defaults.md)) and VGATEST's shipped DAC.COL are byte-for-byte identical, all 256 entries (checked 8 November 2026 against the allowlisted SimTel distribution); the per-mode selection is the project's, consistent with the preload function of Ferraro 11.13.4 | Ferraro 8.3.5 Table 8.14 (the full 256-entry extract) and VGATEST DAC.COL (allowlisted distribution; identical, verified 8 November 2026); Ferraro 11.13.4 (the preload function); project choice (the per-mode selection) | must | S3COMPAT 'Mode nnh' fail 20 (first 64 entries; 13h the whole table); emu t_vga_palettes |
| B00-11 | EGA palette, DAC entry i (0-3Fh), 6-bit values: red = 2Ah if bit 2 + 15h if bit 5, green = 2Ah if bit 1 + 15h if bit 4, blue = 2Ah if bit 0 + 15h if bit 3 — the public derivation: two bits per primary at 0/33/66/100 % saturation (Ferraro 8.2.11 Table 8.10), so 15h = 21/63 (33 %), 2Ah = 42/63 (66 %), 3Fh = 63. CGA palette, entry i: n = 15h if bit 4 else 0; red = 2Ah if bit 2 + n, green = 2Ah if bit 1 + n, blue = 2Ah if bit 0 + n, except that i with bits 4, 2-0 = 0, 110b (brown) has green 15h — the brown exception is publicly documented: Ferraro 8.3.5 Table 8.14's entry 6 is (42, 21, 0) decimal = 2Ah, 15h, 00h, the halved green. The EGA formula reproduces Table 8.14's entries 0-15 exactly at the default palette values 00h-05h, 14h, 07h, 38h-3Fh (verified 8 November 2026 against the full extract at [`cleanroom/primary-extracts/ferraro-table-8-14-color-register-defaults.md`](cleanroom/primary-extracts/ferraro-table-8-14-color-register-defaults.md)): attribute 6's default value 14h routes around the brown DAC entry, which is the exception the value exists for; VGATEST's shipped DAC.COL is byte-for-byte the same table, all 256 entries (the allowlisted SimTel distribution, verified 8 November 2026) | Ferraro 8.2.11 Table 8.10 and 8.3.5 Table 8.14 (the full extract, 8 November 2026); VGATEST DAC.COL (allowlisted distribution; identical to Table 8.14, verified 8 November 2026) | must (EGA), project choice (the encoding) | S3COMPAT 'Mode nnh' fail 20; emu t_vga_palettes |
| B00-12 | With grey summing on (0040:0089h bit 1 = 1) the DAC is loaded with grey values (B12.33-2); with default palette loading disabled the palette registers, the overscan and the DAC are left unchanged (B12.31-2). The dynamic save area receives the mode's AR00-0Fh and AR11 (B10-7) | Ferraro 11.13.4, 11.13.6; RBIL MEM 0040:0089h (#M0027) | must | S3COMPAT 'AH=12 BL=31 default palette loading', 'AH=12 BL=33 grey summing on mode set', 'Video save pointer table 0040:00A8' fail 1 |
| B00-13 | After the defaults, a user palette profile (TAB-24) whose mode list holds the mode overrides the attribute and DAC registers it names | RBIL MEM 0040:00A8h (#M0038 offset 0Ah, #M0049) | should | not checked |
| B00-14 | Text modes: the ROM font of the cell height is loaded into block 0 of plane 2 (8x8 at 200 lines, 8x14 at 350, 8x16 at 400), each glyph in a 32-byte slot; in the 9-dot modes (07h at 350 lines, every text mode at 400) the 9x14 or 9x16 alternate glyphs replace their 8-dot ones. SR03 (character map select) = 00h | Ferraro 11.2 Table 11.2 (cell sizes), 11.12.1 (32-byte slots); RBIL INT 10/AX=1130h (#00021, the alternate tables); IBM (VGATEST SR03 = 00h) | must | S3TEST 'Font load 8x16 and 8x8 in plane 2' (checked after AX=1114h); S3COMPAT 'Mode nnh' fail 1 (SR03); make 775-ref-compare (plane 2) |
| B00-15 | After the ROM font, an alphanumeric character set override (TAB-18, TAB-19) and a second alphanumeric override (TAB-23) whose mode lists hold the mode are loaded | RBIL MEM 0040:00A8h (#M0037, #M0046, #M0047) | should | S3COMPAT 'Video save pointer table 0040:00A8' fail 2, 4 (mode 03h at 400 lines) |
| B00-16 | Graphics modes: INT 43h (0000:010Ch) points to the ROM font of the cell height: 8x8 in 04h-06h, 0Dh, 0Eh and 13h, 8x14 in 0Fh and 10h, 8x16 in 11h and 12h; unless a graphics character set override (TAB-20) lists the mode, then to its font | RBIL INT 43 ("graphics data for characters 00h-7Fh of the current font in 8x8 dot modes, graphics data for all characters in 8x14 and 8x16 modes"); Ferraro 11.12.15; IBM (VGATEST state block 23h: 8, 14, 16) | must | S3COMPAT 'AX=1130 BH=1 INT43 in mode 13'; S3COMPAT 'Video save pointer table 0040:00A8' fail 8, 10h (mode 12h override) |
| B00-17 | Cursor: all eight cursor positions (0040:0050h-005Fh) = 0000h, active page 0040:0062h = 0, page start 0040:004Eh = 0000h and the CRTC start address CR0Ch/CR0Dh = 0 | Ferraro 11.2.1 ("Host Memory Affected": 44Eh, 450h, 462h); IBM (VGATEST state block 09h-1Ah, 1Dh; CR0C/CR0D = 00h) | must | S3COMPAT 'Mode nnh' fail 1, 2 |
| B00-18 | Cursor shape: 0040:0060h and CR0Ah/CR0Bh get the mode's cursor start and end lines from the parameter table (0040:0061h = start, 0040:0060h = end); 0000h in the graphics modes, which show no cursor. The 400-line pair 0Dh/0Eh is **verified from the shipped VGATEST table** (CRTC.COL, modes 00h-03h, CR0A/CR0B = 0Dh/0Eh; the allowlisted SimTel distribution, 8 November 2026); the 350-line pair 0Bh/0Ch is not in the shipped tables — it comes from the IBM VGA parameter table (0040:00A8h, entries 13h-16h), per vgaref.inc's header. Ferraro Table 9.6's CRTC rows 0A/0B show 06h/07h for the text modes (its 350-line examples); the disagreement between the two public sources is recorded, and the rule follows VGATEST's table | Ferraro 11.2.1 ("460 = Cursor mode"); Ferraro Table 9.6 CRTC rows 0A/0B (legible, 8 November 2026); VGATEST CRTC.COL (allowlisted distribution, verified 8 November 2026) | must | S3COMPAT 'Mode nnh', 'Mode nnh 350' fail 1, 2; emu t_vga_registers |
| B00-19 | BIOS data set by every mode set: 0040:0049h, 004Ah, 004Ch, 004Eh, 0050h-005Fh, 0060h, 0062h, 0063h, 0065h, 0066h, 0084h, 0085h, 0087h bit 7, and the equipment word bits 5-4 (0040:0010h); the values are those of BDA-1 to BDA-13 | Ferraro 11.2.1 ("Host Memory Affected"); RBIL MEM 0040:0049h-0066h, 0084h, 0085h | must | S3COMPAT 'Mode nnh' fail 2; emu t_mono |
| B00-20 | BIOS data a mode set keeps: the cursor emulation flag (0040:0087h bit 0), the scan line choice, palette loading, grey summing and display switching bits of 0040:0089h, 0040:008Ah and 0040:00A8h. They are choices for later mode sets (AH=12h BL=30h-35h, AX=1A01h) | RBIL INT 10/AH=12h BL=30h-35h ("at next mode set"); RBIL MEM 0040:0087h-008Ah; Ferraro 11.13.3-11.13.7 | should | S3COMPAT 'AH=12 BL=31 default palette loading', 'AH=12 BL=33 grey summing on mode set' (kept across mode 03h); emu t_mono (0040:008Ah) |
| B00-21 | The mode set reads the parameter table and the overrides through the pointer at 0040:00A8h at each call, so a program can change a mode by pointing 0040:00A8h at a RAM copy of the tables | RBIL MEM 0040:00A8h (#M0037 note "copy to RAM to alter, then update 40h:A8h") | should | S3COMPAT 'Video save pointer table 0040:00A8' (overrides through a RAM copy; the parameter table pointer is copied unchanged) |
| B00-22 | For the same standard-mode input and documented control flags, the fields that B00-7 and B00-17 through B00-19 specify as initialized by AH=00h take their documented mode values after a preceding standard VGA mode or mode 101h. Preserve or override video memory, palettes, fonts and control state as B00-4 and B00-10 through B00-16 and B00-20 through B00-21 specify. This requirement does not erase state that those rules explicitly retain | AGENTS.md Hard rules (standard VGA compatibility) as a project postcondition; public sources cited by B00-4, B00-7 and B00-10 through B00-21 | must (project postcondition) | S3COMPAT pass 2 mode-after-mode lines |
| B00-23 | Mode numbers the BIOS does not support (08h-0Ch, and 14h-7Fh where no extended mode exists): no public source says what happens. A program sets the mode and checks it with AH=0Fh | RBIL #00010 (08h-0Ch not VGA modes); RBIL INT 10/AH=05h note (verify with AH=0Fh) | note | emu t_errors (AL = 14h-18h, 1Bh, 1Fh, 20h, 60h, 7Fh: the video state does not change) |

### INT 10h AH=0Fh: get current video mode

Reports the mode, the number of columns and the active page from the BIOS data area.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B0F-1 | No input. Output AL = current mode (0040:0049h), AH = number of character columns (low byte of 0040:004Ah), BH = active page (0040:0062h) | RBIL INT 10/AH=0Fh; Ferraro 11.9.4 (Table 11.5); VGADOC VGABIOS.TXT | must | S3COMPAT 'Mode nnh' fail 2 (AL = mode, AH = columns, BH = 0); make 775-ref-compare |
| B0F-2 | AL bit 7 is 1 when the last mode set was made with AL bit 7 = 1 (no clear), as 0040:0087h bit 7 records it | RBIL INT 10/AH=0Fh note; Ferraro 11.9.4; RBIL MEM 0040:0087h bit 7 | must | not checked (emu t_windows checks 0040:0087h bit 7, not AH=0Fh) |
| B0F-3 | Columns: 40 in 00h, 01h, 04h, 05h, 0Dh, 13h; 80 in 02h, 03h, 06h, 07h, 0Eh-12h | Ferraro Table 11.6; RBIL #00010 | must | S3COMPAT 'Mode nnh' fail 2 |
| B0F-4 | In 43- and 50-line text AL is 03h (07h on monochrome): the font functions change the rows, not the mode number | RBIL INT 10/AH=0Fh note | should | not checked |
| B0F-5 | BL, CX, DX, SI, DI, BP, DS, ES come back as given | RBIL INT 10/AH=0Fh (returns AX and BH only) | should | make 775-ref-compare (AX=0F00h in modes 00h-07h, 0Dh-10h) |
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
| BDA-14 | 0040:0087h (byte), video control: bit 7 last mode set without clear (B00-4); bits 6-5 video memory (n + 1) x 64 KB, 11b on a VGA; bit 4 reserved; bit 3 = 1 video system inactive; bit 2 wait for display enable; bit 1 monochrome display; bit 0 = 1 cursor emulation disabled (AH=12h BL=34h). Set up at POST; bit 7 is written by every mode set, bit 0 only by AH=12h BL=34h | RBIL MEM 0040:0087h (#M0024); VGADOC VGABIOS.TXT; Ferraro Table 9.26 | must (bits 7, 6-5, 0), should (others) | emu t_windows (bit 7); make 775-ref-compare (whole data area) |
| BDA-15 | 0040:0088h (byte), switches: bits 3-0 the EGA configuration switches (#M0026), bits 7-4 the feature connector bits read at POST. With 0040:0089h bit 4 = 0 the next text mode set gives 350 lines if bits 3-0 are 3h or 9h and 200 lines otherwise; RBIL and VGADOC say the VGA sets the low nibble to 9h after a mode set | RBIL MEM 0040:0088h (#M0025, #M0026); VGADOC VGABIOS.TXT; Ferraro Table 9.27 | should | make 775-ref-compare (whole data area) |
| BDA-16 | 0040:0089h (byte), mode set options: bits 7 and 4 the scan line choice (00b 350, 01b 400, 10b 200); bit 6 display switching enabled; bit 5 reserved; bit 3 = 1 default palette loading disabled; bit 2 monochrome display; bit 1 grey summing on; bit 0 = 1 VGA active (all modes on all displays). Written at POST and by AH=12h BL=30h, 31h, 33h, 35h | RBIL MEM 0040:0089h (#M0027); VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=12 BL=30 ...', 'AH=12 BL=31 ...', 'AH=12 BL=33 ...'; emu t_vga_registers (state block 2Dh, which repeats bits 0-3) |
| BDA-17 | RBIL and VGADOC add that a VGA mode set resets bit 7 and sets bit 4 of 0040:0089h; that would make a 200- or 350-line choice last one mode set only. Programs repeat AH=12h BL=30h before each mode set when they need a scan line count | RBIL MEM 0040:0089h (#M0027 notes); VGADOC VGABIOS.TXT | note | not checked |
| BDA-18 | 0040:008Ah (byte): index of the active display combination in the DCC table (TAB-22). Set at POST and by AX=1A01h (B1A01-1); AX=1A00h reads the pair through it | RBIL MEM 0040:008Ah; VGADOC VGABIOS.TXT | should | emu t_mono (AX=1A01h, every pair) |
| BDA-19 | 0040:00A8h (dword): far pointer to the save pointer table (TAB-16). Set at POST to the table in the ROM; a program may point it to a copy in RAM, and the BIOS then uses the copy at the next call (B00-21) | RBIL MEM 0040:00A8h (#M0037 note); VGADOC VGABIOS.TXT; Ferraro 9.2.2 | must | S3COMPAT 'Video save pointer table 0040:00A8' (points it to a RAM copy and back) |
| BDA-20 | The VGA BIOS owns only 0040:0049h-0066h, 0084h-008Ah and 00A8h, and the video bits of 0040:0010h; it does not write 0040:0067h-0083h or 008Bh-00A7h (cassette/restart, keyboard, disk and timer data of the system BIOS) | RBIL MEM 0040:0067h ff.; Ferraro 9.3.2, Table 9.8 | must | make 775-ref-compare (the whole 0040:0000h-00FFh page against the reference BIOS) |

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

Open questions about externally observable behaviour. These are not requirements. Any answer proposed
for the clean specification must state its source and pass leak review.

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
7. Which documented scan-line selection bits and switch fields are retained or changed after a mode
   set, and for how long does an AH=12h BL=30h choice persist? Identify differences by mode and by the
   public sources BDA-15 through BDA-17.
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
18. Does the published video parameter table follow the public entry order and field layout in
    TAB-13 through TAB-15, including unused entries?
19. Which public save-pointer and secondary-table fields are valid after POST, and which optional
    interfaces are absent?
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
| B01-4 | With cursor emulation on (0040:0087h bit 0 = 0) in a text mode, CX is taken as a shape in an 8-line CGA cell and scaled to the character height (0040:0085h) before it goes to CR0Ah/CR0Bh. The scaling behaviour is publicly documented by both Ferraro 11.13.7 (see B01-5) and VGATEST's article (quoted: "If an application sets an underline cursor on the CGA by setting the cursor to start on line 6 and end on line 7 ... For a 14-line font, the BIOS translates a start-at-line-6 request for the cursor into a start-at-line-12 request"), and by RBIL ("remap cursor start/end according to the current character height in text modes"); the exact result for CX = 0607h in mode 03h at 400 lines — the 0Dh/0Eh pair — is the project's encoding of VGATEST's results (the printed article carries the mechanism, not the numeric result; the milestone contract's EDIT row still promises no exact pair, MC-2b) | Ferraro 11.13.7 (legible, 8 November 2026; the mechanism); VGATEST, PC Tech Journal, November 1988, p. 48 (public; the translation rule quoted); RBIL INT 10/AH=12h BL=34h | must | S3COMPAT 'AH=01/02/03 cursor + emulation' fail 1; 775-ref-compare (AX=0100h CX=0607h in modes 00h-07h, 0Dh-10h) |
| B01-5 | Cursor emulation scaling, from Ferraro 11.13.7 (legible copy supplied by the owner, 8 November 2026, replacing the garbled scan; quoted): "The cursor shape is initialized to be a horizontal line two scan lines wide at the bottom of the character box. If the emulation mode is active, the cursor will be drawn according to the current character height." Cursor types (Table 11.23 "Cursor Type During Cursor Emulation"): no cursor (CH bit 5 = 1) — no adjustment; overbar ("Start End <= 3") — no adjustment; underline ("Start+2 >= End") — adjustable; full block — adjustable; half block — adjustable. Adjustments (Table 11.24 "Start and End Cursor Adjustments"): full block — "Modify End to the last line in the character box"; half block — "Modify Start to be equal to the scan line half way in the character height. Modify End to the bottom scan line of the box"; height > 16 — "An underline cursor is positioned on the last line in the character box." Adjustments continue "until neither the Start Cursor nor End Cursor occur out of bounds." The owner-supplied text's Table 11.23 parameter cells for the underline and full-block rows were partly garbled ("Start <= 2 or End <", "Start > 2 Half"); the readable PDF of the book at the Internet Archive (readings.md row 10) carries the tables ungarbled, so a reader of the cited public copy can inspect the exact boundary inequalities — no reconstruction from implementation or test expectations is used | Ferraro 11.13.7 (AH=12h BL=34h Cursor Emulation), Tables 11.23 and 11.24 (owner-supplied text plus the readable Internet Archive PDF, readings.md row 10); RBIL AH=12h/BL=34h | should | only CX = 0607h (S3COMPAT); 775-ref-compare for 0607h |
| B01-6 | On a VGA a start line greater than the end line shows no cursor (on an EGA the cursor wraps into two parts); the BIOS writes such a value without correcting it | Ferraro 11.3.1, 6.6.3 | note | not checked |
| B01-7 | CH bits 6-5 = 01b (for example CX = 2000h) hides the cursor: CR0Ah bit 5 = 1 | RBIL (#00013); Ferraro 11.3.1 (Cursor On/Off field) | should | not checked |
| B01-8 | In graphics modes no cursor is shown; the shape is still stored in 0040:0060h | Ferraro 11.3.1 | should | not checked |

### AH=02h: set cursor position

Sets the cursor of one page; the hardware cursor follows when that page is displayed.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B02-1 | Input BH = page, DH = row, DL = column. DL goes to 0040:0050h + 2*BH, DH to 0040:0051h + 2*BH. Nothing is returned | Ferraro 11.3.2; RBIL INT 10/AH=02h; RBIL MEM 0040:0050h; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=01/02/03 cursor + emulation' fail 4; 775-ref-compare |
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
| B05-1 | Input AL = page. The BIOS sets 0040:0062h = AL and 0040:004Eh = AL * 0040:004Ch, and the CRTC start address CR0Ch (high) / CR0Dh (low) to 0040:004Eh in byte mode (CR17h bit 6 = 1, the planar modes) or 0040:004Eh / 2 in word mode (CR17h bit 6 = 0, the text modes). Nothing is returned | Ferraro 11.5.1; RBIL INT 10/AH=05h; RBIL MEM 0040:004Eh, 0040:0062h | must | S3COMPAT 'AH=05 pages (mode 03 p3, mode 0D p7)' fail 1, 2; 775-ref-compare |
| B05-2 | Page starts are multiples of the page length: mode 03h page 3 at 3000h (length 1000h), mode 0Dh page 7 at E000h (length 2000h) | IBM (VGATEST); Ferraro 7.3.2 tables 7.7 and 7.9 | must | S3COMPAT 'AH=05 pages (mode 03 p3, mode 0D p7)' fail 2 |
| B05-3 | The hardware cursor moves to the saved position of the new page (0040:0050h + 2*AL), computed as in B02-2 | Ferraro 11.3.3 ("the Cursor Location Registers store the location of the cursor associated with the current display page") | must | 775-ref-compare (AX=0501h, 0500h: CR00-18h against 2.04.07) |
| B05-4 | Video memory is not changed: the new page shows what was written to it before | Ferraro 11.5.1 | must | 775-ref-compare (video memory after AX=0501h) |
| B05-5 | Pages per mode: 8 in 00h/01h, 8 in 02h/03h and 07h on EGA/VGA (4 on a CGA), 8 in 0Dh, 4 in 0Eh, 2 in 0Fh and 10h, 1 in 04h-06h and 11h-13h | Ferraro tables 7.7, 7.8, 7.9; RBIL (#00010) | should | S3COMPAT 'AH=05 pages' (mode 03h page 3, mode 0Dh page 7) |
| B05-6 | A page number the mode does not have: what the BIOS does is not defined; RBIL tells programs to read the page back with AH=0Fh | RBIL INT 10/AH=05h note | note | not checked |

### AH=06h and AH=07h: scroll a window up or down

AH=06h scrolls up, AH=07h down, on the active page; AL=0 clears the window.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| B06-1 | Input AL = number of lines, BH = fill attribute (text) or colour (graphics), CH, CL = row, column of the upper-left corner, DH, DL = row, column of the lower-right corner, both inclusive, in character cells. AH=06h moves the contents of the window up by AL rows and blanks the AL rows at its bottom; AH=07h moves them down and blanks the AL rows at its top. Nothing is returned | Ferraro 11.6.1, 11.6.2; RBIL INT 10/AH=06h, 07h; VGADOC VGABIOS.TXT | must | S3COMPAT 'AH=06/07 scroll full and window'; S3TEST 'Text scroll AH=06h/07h cells'; 775-ref-compare (AL = 0, 1, 2, 5, random windows) |
| B06-2 | AL = 0 blanks the whole window | Ferraro 11.6.1, 11.6.2; RBIL INT 10/AH=06h, 07h | must | S3TEST 'Text scroll AH=06h/07h cells', 'Planar scroll 12h/0Dh AH=06h/07h' (fail 10h, 20h), 'Mode 13h scroll AH=06h/07h/0Eh' (fail 8); S3COMPAT 'AH=06/07 CGA graphics scroll 04h/06h' (fail 8) |
| B06-3 | Text modes: a blank cell is the character 20h with attribute BH, at B800h (B000h in mode 07h) | Ferraro 11.6.1 ("blank lines with a new attribute"); RBIL INT 10/AH=06h | must | S3COMPAT 'AH=06/07 scroll full and window'; emu t_mono (mode 07h, every cell) |
| B06-4 | Only the window changes: every cell (text) or byte of every plane (graphics) outside it keeps its value | Ferraro 11.6.1 ("without disturbing the rest of the screen") | must | S3TEST 'Text scroll AH=06h/07h cells', 'Planar scroll 12h/0Dh AH=06h/07h', 'Mode 13h scroll AH=06h/07h/0Eh' (every cell, byte or pixel); emu t_mono |
| B06-5 | The page scrolled is the active page (from 0040:004Eh); there is no page input | RBIL INT 10/AH=06h, 07h note; VGADOC VGABIOS.TXT | must | not checked on pages other than 0 |
| B06-6 | Graphics modes: the window is in cells (8 pixels wide, 0040:0085h scan lines high); every scan line and every plane of a cell moves with it. In mode 13h a cell is 8 bytes by 8 lines; in modes 04h/05h 2 bytes by 8 lines, in 06h 1 byte by 8 lines, 4 lines in each interleaved half of B800h | Ferraro 11.6.1, 6.7.12 table 6.17, 7.4.3 | must | S3COMPAT 'AH=06/07 CGA graphics scroll 04h/06h'; S3TEST 'Planar scroll 12h/0Dh AH=06h/07h', 'Mode 13h scroll AH=06h/07h/0Eh'; emu t_mono (mode 0Fh); 775-ref-compare |
| B06-7 | Graphics fill: BH is the colour of the blank pixels. Planar modes: each byte of the blank area is FFh in the planes whose bit in BH is 1 and 00h in the others; mode 13h: each byte is BH | Ferraro 11.6.1 (BH fills the new lines); RBIL INT 10/AH=06h | must | S3TEST 'Planar scroll 12h/0Dh AH=06h/07h' (every byte of the four planes), 'Mode 13h scroll AH=06h/07h/0Eh' |
