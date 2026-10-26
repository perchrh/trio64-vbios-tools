# Trio64V2/DX VBIOS test tools

DOS tools written while modifying the video BIOS of a Gainward S3 Trio64V2/DX card
(86C775, 2 MB EDO 40 ns, board ICUVGA-GW503A, PCI 5333:8901). The current ROM is 2.04.11-p9.
The ROM image itself is not in this repository; the changes it carries are described below.

All tools share one version number, currently 0.8, and print it on their first line of output.
All tools need a 386 or later and run in plain DOS (no EMM386 needed).

| Tool | Purpose | Run |
| --- | --- | --- |
| VSHOW.COM | VESA mode viewer: test picture, measured refresh and line frequency, LCD line pattern, interactive menu, run through all modes | `VSHOW /H` for the parameter list |
| S3TEST.COM | Regression test for the ROM patches (signature, clocks, EDO, pedestal, refresh, booster, LFB, 4F05/4F06, CR50, flip-flop) | `S3TEST > S3TEST.LOG` |
| S3ALIAS.COM | TSR for Pinball Illusions' S3 driver: INT 10h AH=00 mode 49h becomes 59h (640x480x8), 4Bh becomes 5Ah (800x600x8) | `S3ALIAS` before starting the game; not with S3TEST or S3COMPAT |
| S3COMPAT.COM | VGA/SVGA/VESA compatibility test: IBM reference registers and palettes, 350-line text modes, VGA BIOS functions, every VESA mode, datasheet rules, VRAM | `S3COMPAT > S3COMPAT.LOG` (`/Q` skips the VRAM test, `/I` pauses per mode) |

Each source file starts with a header that says what is tested and which outcome is expected, and
each test routine has a comment block with its fail and warn bits.

S3TEST checks for the ROM signature `2.04.11-p9`; change the two strings and the
`cmp word [si+8],'p9'` line in `s3test/s3test.asm` for another version.

## Building

NASM 2.x (tested with 2.16.01):

    make            # Linux, macOS, WSL
    build.bat       # DOS or Windows with nasm.exe on the PATH

The .COM files land in `build/`. `common/` holds the /V debug log code the test tools share.

## Debug log (/V)

VSHOW, S3TEST and S3COMPAT take `/V`. It writes a second file, `VSHOW.DBG`, `S3TEST.DBG` or
`S3COMPAT.DBG`, in the current directory. Its only purpose is to show how the code ran on the real
card, so problems can be found and fixed from a log instead of guessed at. The normal output is the
same with or without /V. The debug file contains:

- the environment: CPU, DOS version, memory, interrupt vectors, system BIOS date, the video ROM header
  and checksum, the BIOS data area and the PCI configuration of the display controller
- every INT 10h call the tool makes (and nested calls the BIOS makes itself) with all registers in and
  out and the duration in PIT counts
- a register dump (SR, GR, CR00-18, CR30-6F, CR80-9F, AR, DAC 0-15, video BIOS data) after every test or
  shown mode, with the normal result line copied next to it
- the 4F00, 4F01 and AH=1Bh blocks as hex, per-frame timer counts of every refresh measurement and the
  first memory mismatches with address, expected and read value

The file is committed before every mode set and VBE call (except 4F05), so after a freeze its last
lines show the call that hung. Expect a debug file of 1-2 MB for S3COMPAT and a longer run.
The line format is described at the top of `common/vdebug.inc`.

## S3COMPAT reference data

`s3compat/vgaref.inc` holds everything S3COMPAT compares against, so a build needs nothing else:

- the standard VGA register values and the INT 10h AH=1Bh state block per mode, and IBM's default
  256-colour DAC table. These were generated once from the IBM reference tables shipped with
  VGATEST (Kent Quirk and Ed McNierney, PC Tech Journal, November 1988: CRTC.COL, GENERAL.COL,
  DSTATE.COL, DAC.COL), cross-checked against the VGA parameter table in the BIOS, which matches
  VGATEST for every mode VGATEST covers. We do not consider these VGA tables copyrighted.
- the 350-line text modes 0*, 1*, 2* and 3*, from the IBM VGA parameter table (entries 13h-16h).
- the VESA to S3 internal mode mapping, from the BIOS tables at 0xE37 and 0xEA5.

The EGA and CGA default palettes are not tables: S3COMPAT computes them from the IBM rules
(EGA: 2Ah per primary bit, 15h per secondary bit; CGA: bit 4 adds 15h to all three, colour 6 is brown).

## VBIOS changes in 2.04.11-p9

p9 differs from the stock 2.04.11 dump in the lower 32 KB only. The upper 32 KB (Trio64V+ BIOS
1.03-08, for an older card) is byte-identical to stock, both halves checksum to 0, and every change
keeps the standard VGA and VESA modes compatible. The RAM stays in 1-cycle EDO mode.

| Area | Change | Effect |
| --- | --- | --- |
| Memory clock | MCLK 50.11 MHz to 59.96 MHz (SR11=41h, SR10=42h, VCO 239.8 MHz) | About 20% more memory bandwidth; 59.96 MHz is the 1-cycle EDO maximum (16.67 ns). CR36 bits 3-2 stay 00 |
| Black level | Blank pedestal off at POST (header flag 0xD1 bit 1 cleared, SR1A bit 5 never set) | Deepest black, no grey lift |
| Attribute controller | Input status read after every mode set resets the index/data flip-flop | Fixes programs that write port 3C0h right after a mode set |
| FIFO fetch | CR90 bit 7 cleared after setting any VGA mode 00h-13h | Fixes stripes and garbage in Mode X and 360-wide modes after a VESA mode (Quake 360x200) |
| 320x240x8 (131h) | New 60 Hz timing: 640x480 @ 60 Hz halved horizontally, double scanned | LCDs see standard 640x480 @ 60 Hz, no scaling waves |
| 320x240x15/16 (132h, 133h) | Same 60 Hz timing at 2 clocks per pixel | Same as 131h |
| 640x480 class | Line total 792/796 to 800 pixels in the 640x480 and 320x240 tables | Exact VESA 640x480 @ 60 Hz line of 800 pixels (31.3-31.5 kHz); one LCD preset covers every mode of that class |
| 1280x1024, 1600x1200 | Default refresh 60 Hz (CR41 and CR52 refresh fields) | Works on 60 Hz LCDs; stock defaulted to rates LCDs reject |
| 1280x1024x16 colours (106h) | Stock VESA DMT timing kept (108 MHz, 64 kHz, 60 Hz) | 14% above the 95 MHz single-clock datasheet limit but clean on this card; the CVT reduced-blanking timing tried in p8 made a 1280x1024-incapable LCD report out of range |
| Banked VESA speed | Booster: banked 8/15/16/24/32 bpp modes use the linear path through a 64 KB window at A0000h; real LFB base kept in CR6D and restored on the next mode set; 4F01 and 4F05/4F03 read it correctly | Banked writes at 83.7 MB/s, as fast as the LFB; VESA 1.2 games much faster |
| 512x384x8 (151h) | CR50 table byte 60h to 40h | Correct graphics engine pixel length (was the reserved 10b) |
| VBE 4F06 BL=3 | Rewritten: BX = min(8184, memory / lines) rounded down to 8, CX = BX in pixels | Real maximum line length (4368 for 101h instead of 546) |

### Byte-level changes

Offsets are in the 64 KB image (C000:offset when shadowed); everything from 0x8000 up is untouched.

| Offset | Stock | p9 | Purpose |
| --- | --- | --- | --- |
| 0x0079 | 2.04.11 | 2.04.11-p9 | Sign-on string (copyright line moved into the padding before 0x00AB) |
| 0x00C7-00C8 | 28 41 | 41 42 | MCLK PLL at POST: SR11 (M) = 41h, SR10 (N/R) = 42h |
| 0x00D1 | 07 | 05 | POST flags: bit 1 (blank pedestal) cleared |
| 0x00DE | 08 | 88 | CR41 refresh fields: 1280 field = 4 (60 Hz) |
| 0x00DF | 80 | 81 | CR52 refresh fields: 1600 field = 1 (60 Hz) |
| 0x04C1-04C4 | 5E 4F 50 81 | 5F 4F 50 82 | 640x480x8/x32 @ 60 Hz: line total 800, blank end moved |
| 0x089F-08A3 | C1 03 82 48 33 | 40 7E 82 3C 28 | 320x240x8 refresh entry: CRTC table 0x7E40, 60 Hz, PLL 25.06 MHz |
| 0x08AD-08B1 | F5 0C 82 48 33 | 60 7E 82 3C 28 | 320x240x15/16 refresh entry: CRTC table 0x7E60, 60 Hz |
| 0x095C | 60 | 40 | CR50 for 512x384x8 / x32 |
| 0x0B1A-0B1D | C2 9F A0 85 | C3 9F A0 86 | 640x480x15/16 @ 60 Hz: line total 800 |
| 0x20DE-20DF | 86 26 | 80 7E | INT 10h AH=00 jump table entry: mode set via the hook at 0x7E80 |
| 0x56FE-5700 | call 2686 | call 7E80 | VBE 4F02: mode set via the hook |
| 0x5718-571D | mov word [4FE],0 | call 7EF0, nop x3 | VBE 4F02 end: booster |
| 0x59DC-59E0 | mov ax,3FF / xor dx,dx | call 7F71 / jmp 59D9 | VBE 4F06 BL=3: corrected routine |
| 0x5CF4-5CF7 | mov ax,bx / or ax,ax | call 7F3E / nop | LFB base read: real base from CR6D while the booster is on |
| 0x5D12-5D14 | and ax,1000h | call 7F4F | 4F05/4F03 linear-mode test ignores the booster's 64 KB window |
| 0x7E40-7E58 | 00 | CRTC table | 320x240x8 @ 60 Hz |
| 0x7E60-7E78 | 00 | CRTC table | 320x240x15/16 @ 60 Hz |
| 0x7E80-7F57 | 00 | code | Mode set hook, LFB base restore, booster, base fix, linear test |
| 0x7F71-7FAE | 00 | code | 4F06 BL=3 routine |
| 0x7FFF | 77 | FC | Checksum of the lower 32 KB |

### Borrowed ideas

No code was copied from another project; all ROM code was written for this BIOS.

| Item in the ROM | Origin | What was taken |
| --- | --- | --- |
| FIFO fetch fix | [S3VBEFIX](https://github.com/wbcbz7/S3VBEFIX) 0.6.1 by Artem Vasilev (wbcbz7), WTFPL | The diagnosis and the fix: clear CR90 bit 7 when a VGA mode is set |
| Attribute flip-flop reset | S3VBEFIX | The idea: a dummy read of the input status register (3DAh) after the mode set |
| Booster | S3VBEFIX, which credits SVGATRIX.TXT; the 64 KB linear window at A0000h is documented in the Trio64V+ datasheet | The register sequence CR58 AND ECh, CR59=00, CR5A=0Ah, CR58 OR 10h. Saving the real base in CR6D and restoring it in the ROM's own mode set is our design |
| LFB mode set handling | S3VBEFIX | Only the observation that the booster's base must be restored before an LFB mode; implemented differently |
| Refresh and LCD timings | Not from S3REFRSH | The ROM carries the timings itself: VESA DMT 640x480 @ 60 Hz (800x525) and the BIOS's own 640x480 tables halved for 320x240 |
| Memory clock 59.96 MHz | Trio64V2 datasheet | PLL values chosen to meet the 16.67 ns 1-cycle EDO limit |

### Kept outside the ROM

| TSR | Fixes | Why not in the ROM |
| --- | --- | --- |
| 8x14 font TSR | AX=1130h BH=2 returns the 8x16 font; mode 10h uses 21 rows of 16 lines | A 3.5 KB font does not fit in the free ROM space (accepted for now) |
| S3ALIAS.COM (`s3alias/`) | Pinball Illusions' S3 driver: AH=00 mode 49h becomes 59h, 4Bh becomes 5Ah | Remapping S3 mode numbers in the ROM would break programs that use this BIOS's own numbering |

### Omitted: 1-cycle linear addressing (CR87 bit 1, SR15 bit 7)

The Trio64V2 datasheet (section 3.5) describes a faster linear addressing path: CR87 bit 1 = 1
enables 1-cycle linear addressing of video memory, "the memory must be capable of supporting this
mode", and the default with SR0A bit 7 and SR15 bit 7 set is 2-cycle operation. It was tried on top
of the p7 booster in 640x480x8 (101h) with a write benchmark and a 320 KB pattern check (VLIN2):

| SR15 bit 7 | CR87 bit 1 | Write speed | Data errors |
| --- | --- | --- | --- |
| 0 | 0 | 83683 KB/s | 0 |
| 1 | 0 | 83683 KB/s | 65536 |
| any | 1 | hang | - |

There is no speed gain with this card's memory, SR15 bit 7 corrupts data and CR87 bit 1 hangs the
machine, so neither bit is set by the ROM.

### Known remaining items

- The 8x14 font is missing in the stock BIOS (S3COMPAT WARN 01 for AX=1130h BH=2 and mode 10h).
- An LFB is offered on the planar mode 104h (S3COMPAT WARN 20), as in stock.
- 106h runs at 108 MHz, above the datasheet single-clock limit (S3COMPAT WARN 02).
- The BIOS writes SR04 = 03h in text modes where IBM writes 02h; bit 0 is reserved on the VGA and
  reads back as 0 on the card, so programs see the IBM value.

## Sources

- S3 Trio64V2/DX and GX datasheet (preliminary): MCLK and DCLK limits, the 3-bit DCLK R divider
  (SR12 bit 7), CR36 EDO modes, CR87 1-cycle linear addressing, CR90/CR91 FIFO.
- S3 Trio64V+ (86C765) datasheet, from the S3VBEFIX repository: PLL formula and VCO range, CR67 colour
  modes, SR15/SR18 clock doubling, CR31/CR58/CR59-5A linear addressing, CR50, CR51, CR43, CR5D/CR5E.
- [S3VBEFIX](https://github.com/wbcbz7/S3VBEFIX) source and README, plus SVGATRIX.TXT and vbe20.txt.
- VESA BIOS Extension (VBE) 2.0 specification; VESA DMT; VESA CVT 1.1.
- VGATEST by Kent Quirk and Ed McNierney, PC Tech Journal, November 1988 (IBM reference tables).
- VBETest/Lite (SciTech) and X-VESA 1.0.3: test ideas for S3COMPAT and VSHOW.
- [DOS compatibility tests by gona.mactar.hu](https://gona.mactar.hu/DOS_TESTS/): known S3 issues.
- The stock 2.04.11 dump, disassembled to locate the mode set, refresh tables and VBE handlers.
