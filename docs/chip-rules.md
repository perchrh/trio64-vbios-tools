# Trio64 family: chip rules for video BIOS code

This file lists the rules the S3 datasheets set for software that programs a Trio64-family chip: clock
limits, register values and sequences, and the interface between the PC (PCI, option ROM) and the
card. Every rule has an ID, the chips it applies to, its source and the test that checks it. The test
tools cite these IDs in their comments, so a result line can be traced back to the datasheet sentence
it judges.

The file is also meant as the base of a clean-room description of the chip: what a new BIOS or driver
must do, written from the datasheets alone.

## Conventions

- **Sources.** A rule comes from a datasheet, quoted or paraphrased with its section or table. A rule
  from another public source (XFree86, VESA) is marked *derived* and is never a FAIL on its own.
  Nothing here may come from reading a BIOS image (its code, tables or strings): those findings belong
  in README.md ("Features and changes", "Byte-level changes") and are implementation knowledge, not chip
  rules. Keep the two apart, so the rules can be handed to someone who has never seen a BIOS image.
- **Inheritance.** The Trio64V2/DX & GX and the Trio64UV+ books describe only what differs from the
  Trio64V+. A V+ rule that those books do not change applies to them too. Such rules carry no chip
  prefix and say which chips they cover.
- **IDs.** `PLL-`, `CLK-`, `MEM-`, `REG-`, `PCI-`, `ENG-`: rules of more than one chip. `V2-`: Trio64V2/DX/GX
  only. Further prefixes for the other chips are added with their rules. An ID is never reused for
  another rule.
- **Strength.** *must*: the datasheet says must, never or illegal, or gives a hard limit; a violation is
  a FAIL. *limit*: an electrical maximum that a working card may still exceed; a violation is a WARN
  where the tool says so. *derived*: WARN or INFO.
- **Checked by.** Tool and result bit (S3COMPAT POST, VESA mode lines, `tvco`), or an emulator test
  (`emu/tests.py`), or "not checked".
- **Datasheet errors** found while reading are listed at the end, with what the tools assume.

## Documents

| Short name | Document |
| --- | --- |
| T32/64 | S3 Trio32/Trio64 Integrated Graphics Accelerators, March 1995 |
| V+ | S3 Trio64V+ Integrated Graphics/Video Accelerator, DB018-A, July 1995 |
| V2 | S3 Trio64V2/DX & GX Graphics/Video Accelerators (preliminary, changes from the Trio64V+) |
| UV+ | S3 Trio64UV+ UMA Graphics/Video Accelerator, DB024-A, March 1996, with the update ER010-B (May 1996) |
| XFree86 | XFree86 / X.Org xf86-video-s3, `s3_Trio64DAC.c` |

All four datasheets are in `datasheets/`.

## Interface between the PC and the card (Trio64V2)

These are the parts of the system interface the V2 book defines beyond plain VGA. The rules for the
other chips follow in their own sections.

| ID | Chips | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- | --- |
| V2-ID-1 | V2 | PCI vendor 5333h, device 8901h; CR2D = 89h, CR2E = 01h, CR2F = revision ID (varies with stepping, equals PCI 08h). CR6F bit 0 tells the DX (0) from the GX (1) | V2 4.1 | must | `common/chip.inc` (identification), S3COMPAT "Chip ID" (INFO) |
| V2-PCI-1 | V2 | Subsystem vendor ID and subsystem ID at PCI 2Ch-2Fh mirror CR81-CR84. CR37 bit 2 is 1 at power-up: then a PCI read of 2Ch makes the chip read ROM C000:0040-0043 itself. The video BIOS copies C0040-C0043 to CR81-CR84 and clears CR37 bit 2; from then on, until the next hard reset, the registers answer (a soft reset does not change CR37 bit 2). On a motherboard, PD10 is strapped low (CR37 bit 2 = 0) and the system BIOS loads CR81-CR84 before any ID scan | V2 3.8 | must | S3COMPAT POST "PCI subsystem ID" (fail 1 CR37 bit 2, 2 CR81-84, 4 PCI 2Ch); the model mirrors it (`vgaemu._pci_cfg`) |

## Clock synthesis

| ID | Chips | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- | --- |
| PLL-1 | all | f = fREF x (M+2) / ((N+2) x 2^R), fREF = 14.31818 MHz. The VCO, fREF x (M+2) / (N+2), must lie in 135-270 MHz (DCLK maximum raised on the V2, see V2-PLL-1) | V+ 9.1 constraint 1; T32/64 9.1 | must | S3COMPAT POST (MCLK, fail 1), VESA lines (DCLK, fail 200), `tvco` (fail 1) |
| PLL-2 | all | M 1-127 (SR11 / SR13 bits 6-0), N 1-31 (SR10 / SR12 bits 4-0), R 0-3 (bits 6-5): "min N >= 1" | V+ 9.1 | must | N: S3COMPAT POST fail 1, VESA lines fail 200 ('PLL N=0'); `test_s3patch.py` pllcodes (M, N, R of every refresh entry) |
| V2-PLL-1 | V2 | DCLK PLL VCO maximum 340 MHz. Only the maximum is raised: the minimum stays 135 MHz, and the MCLK PLL keeps 135-270 MHz | V2 3.6 | must | VESA lines fail 200, `tvco` fail 1, POST fail 1 (MCLK) |
| V2-PLL-2 | V2 | XFree86 programs the V2 DCLK VCO in 170-340 MHz | XFree86 | derived | VESA lines WARN 08, `tvco` WARN 08; `s3patch.py` keeps every refresh entry in 170-340 MHz |
| V2-PLL-3 | V2 | SR12 bit 7 is the third bit of the DCLK R divider; SR12 bits 7-5 = 100b divides by 16. No other code with bit 7 set is defined. SR10 (MCLK) has no third R bit: bit 7 stays reserved | V2 3.6, 4.1 (SR12); V+ 16 (SR10 bit 7 reserved) | must | VESA lines fail 200 ('PLL R code'), `tvco` fail 4, POST WARN 1 (SR10 bit 7); `test_s3patch.py` pllcodes |
| V2-CLK-1 | V2 | DCLK maximum 95 MHz single-clocked with the Streams Processor off; 170 MHz with clock doubling (two 8-bit pixels per 85 MHz clock) | V2 table 5-7 note 2 | limit | VESA lines WARN 02 |
| V2-CLK-2 | V2 | DCLK maximum 80 MHz single-clocked with the Streams Processor on (CR67 bits 3-2 = 11b) | V2 table 5-7 note 2 | limit | VESA lines WARN 02 |

## Memory

| ID | Chips | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- | --- |
| V2-MEM-1 | V2 | MCLK maximum 66 MHz (15 ns) for fast page, 60 MHz (16.67 ns) for 1-cycle EDO; SGRAM (GX) at 66 MHz. The book gives no separate value for 2-cycle EDO: the tools use the fast page cycle time | V2 3.1, 3.1.2, table 5-7 | must | S3COMPAT POST fail 2 |
| V2-MEM-2 | V2 | CR36 bits 3-2 (strapped): 00 1-cycle EDO, 01 SGRAM, 10 2-cycle EDO, 11 fast page | V2 4.1 | must | S3COMPAT POST (selects the V2-MEM-1 limit) |
| V2-MEM-3 | V2/GX | SGRAM: at each power-on the BIOS sets CR88 bit 6 (refresh off), programs the CAS latency (CR88 bits 4-3), sets CR88 bit 5 (mode register cycle, clears itself), then clears CR88 bit 6; CR6F bit 3 = 0 at power-up | V2 3.1.1, 4.1 | must | not checked (DX card only) |
| V2-MEM-4 | V2 | CR87 bit 1 enables 1-cycle linear addressing; "the memory must be capable of supporting this mode" | V2 3.5, CR87 | must | not checked (README: hangs this card) |

## Registers

| ID | Chips | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- | --- |
| V2-REG-1 | V2 | SR1A bit 4 (FCTD) "must be set to 1 by the BIOS upon reset" | V2 4.2 | must | S3COMPAT POST "SR1A bit 4" fail 1; S3TEST (pedestal line) |
| V2-REG-2 | V2 | CR32 bit 3: "Reserved = 0. This bit should never be set to 1" | V2 4.1 | must | VESA lines fail 1000 |
| V2-REG-3 | V2 | With DAC power saving on (CR86 bit 7 = 0), CR86 bits 6-0 "must be at least 1 less than the End Horizontal Blank value programmed in CR5D_3, CR5_7 and CR3_4-0" | V2 4.2 (CR86) | must | VESA lines WARN 80 (not yet confirmed on a card) |
| V2-REG-4 | V2 | With CR90 bit 7 = 1 (primary stream L1 on), the 11-bit L1 (CR90 bits 2-0, CR91) = (bytes of displayed pixels per scan line / 8) - 1 | V2 4.2 (CR90, CR91) | must | VESA lines WARN 80 (not yet confirmed on a card) |
| V2-REG-5 | V2 | "The BIOS must write 00H to this register [CR26] upon each mode set"; CR39 = A5h first, and CR23 must be 00h before CR26 is written | V2 4.2 (CR23, CR26) | must | emulator `v2_writes` |
| V2-REG-6 | V2 | CR40 bit 0 and CR66 bit 0 are changed only during screen off (SR01 bit 5 = 1, which may take up to 3 HSYNCs to take effect) or vertical retrace | V2 4.1 | must | emulator `v2_writes` |
| V2-REG-7 | V2 | BEE8h index D and E have undefined power-on values; software initialises them before the graphics engine is used (two steps: the write takes effect with the next engine command) | V2 4.1; UV+ ER010-B item 4 | must | not checked |

## Datasheet errors and gaps

- V2 3.8 says the video BIOS copies C0040-C0043 to "CR81-CR83"; four bytes and the table above it
  show CR81-CR84.
- V2 table 5-7 gives a 12.5 ns minimum DCLK cycle (80 MHz) in enhanced mode, while note 2 of the
  same table allows 95 MHz single-clocked with the Streams Processor off. The tools use the note.
- V2 3.6 raises the DCLK PLL maximum to 340 MHz and says nothing about the minimum; the 170 MHz that
  XFree86 uses is not in the book (V2-PLL-2).
