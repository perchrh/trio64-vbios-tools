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
- **IDs.** `PLL-`, `CLK-`, `MEM-`, `REG-`, `ENG-`: rules of more than one chip. Rules of one book:
  `T64-` Trio32/Trio64, `VP-` Trio64V+, `UV-` Trio64UV+, `V2-` Trio64V2/DX/GX. An ID is never reused
  for another rule.
- **Strength.** *must*: the datasheet says must, never or illegal, or gives a hard limit; a violation is
  a FAIL. *limit*: an electrical maximum that a working card may still exceed; a violation is a WARN
  where the tool says so. *derived*: WARN or INFO.
- **Checked by.** Tool and result bit (S3COMPAT POST, VESA mode lines, `tvco`), or an emulator test
  (`emu/tests.py`), or "not checked".
- **Datasheet errors** found while reading are listed at the end, with what the tools assume.

## Documents

| Short name | Document |
| --- | --- |
| T32/64 | S3 Trio32/Trio64 Integrated Graphics Accelerators, March 1995 (two scans: `trio32-trio64-graphics-accelerators-mar1995-...pdf` and `357_86c732-86c764_trio32_64.pdf`, see below) |
| V+ | S3 Trio64V+ Integrated Graphics/Video Accelerator, DB018-A, July 1995 |
| V2 | S3 Trio64V2/DX & GX Graphics/Video Accelerators (preliminary, changes from the Trio64V+) |
| UV+ | S3 Trio64UV+ UMA Graphics/Video Accelerator, DB024-A, March 1996, with the update ER010-B (May 1996) |
| XFree86 | XFree86 / X.Org xf86-video-s3, `s3_Trio64DAC.c` |

The datasheets are in `datasheets/`. `357_86c732-86c764_trio32_64.pdf` was compared with the
March 1995 book on 28 October 2026: it is another scan of the same book (images only, no text; the
cover, notices and contents pages are missing, 253 instead of 278 pages), with the same sections 1-19,
appendix A and register text. It adds nothing of its own; the T64 rules below marked "added 28 October
2026" were read from it and are in both copies. Rules of the Trio32 alone are left out.

## Interface between the PC and the card

The parts of the system interface the books define beyond plain VGA: identification, PCI
configuration and, on the Trio64UV+, the shared memory (see "Trio64UV+ unified memory" below).

| ID | Chips | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- | --- |
| T64-ID-1 | T32, T64 | PCI device 8811h for both, hardwired; CR2E = 10h Trio32, 11h Trio64; CR30 upper nibble Eh (then CR2D-CR2F hold the ID). PCI revision 00h (class register hardwired to 03000000h). No register at PCI 2Ch | T32/64 11.3, PCI register descriptions | must | `common/chip.inc` |
| VP-ID-1 | V+ | PCI device 8811h, CR2E = 11h, CR2F (= PCI revision) with bit 6 set (4xh); CR30 = E1h | V+ 13.3, CR2F, CR30 | must | `common/chip.inc` |
| UV-ID-1 | UV+ | PCI device 8814h, CR2E = 14h, CR2F = revision ID | UV+ 4.1 | must | `common/chip.inc`, S3REGS32 |
| V2-ID-1 | V2 | PCI vendor 5333h, device 8901h; CR2D = 89h, CR2E = 01h, CR2F = revision ID (varies with stepping, equals PCI 08h). CR6F bit 0 tells the DX (0) from the GX (1) | V2 4.1 | must | `common/chip.inc` (identification), S3COMPAT "Chip ID" (INFO) |
| T64-PCI-1 | T32, T64 | PCI Command register (04h): bit 0 must be 1 for I/O access and bit 1 for memory access; CR66 bit 7 = 1 enables PCI disconnects and must be 1 before CR3A bit 7 (PCI read bursts disabled) is set. A 16-, 24- or 32-bit PCI ROM read needs a ROM access time of 10 SCLKs or less (14 for 8 bits). Added 28 October 2026 | T32/64 6.1.2, 10.1.3, CR3A, CR66 | must | not checked |
| V2-PCI-1 | V2 | Subsystem vendor ID and subsystem ID at PCI 2Ch-2Fh mirror CR81-CR84. CR37 bit 2 is 1 at power-up: then a PCI read of 2Ch makes the chip read ROM C000:0040-0043 itself. The video BIOS copies C0040-C0043 to CR81-CR84 and clears CR37 bit 2; from then on, until the next hard reset, the registers answer (a soft reset does not change CR37 bit 2). On a motherboard, PD10 is strapped low (CR37 bit 2 = 0) and the system BIOS loads CR81-CR84 before any ID scan | V2 3.8 | must | S3COMPAT POST "PCI subsystem ID" (fail 1 CR37 bit 2, 2 CR81-84, 4 PCI 2Ch); the model mirrors it (`vgaemu._pci_cfg`) |

## Clock synthesis and colour modes

| ID | Chips | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- | --- |
| PLL-1 | all | f = fREF x (M+2) / ((N+2) x 2^R), fREF = 14.31818 MHz. The VCO, fREF x (M+2) / (N+2), must lie in 135-270 MHz (DCLK maximum raised on the V2, see V2-PLL-1) | V+ 9.1 constraint 1; T32/64 9.1 | must | S3COMPAT POST (MCLK, fail 1), VESA lines (DCLK, fail 200), `tvco` (fail 1) |
| PLL-2 | all | M 1-127 (SR11 / SR13 bits 6-0), N 1-31 (SR10 / SR12 bits 4-0), R 0-3 (bits 6-5): "min N >= 1" | V+ 9.1 | must | N: S3COMPAT POST fail 1, VESA lines fail 200 ('PLL N=0'); `test_s3patch.py` pllcodes (M, N, R of every refresh entry) |
| V2-PLL-1 | V2 | DCLK PLL VCO maximum 340 MHz. Only the maximum is raised: the minimum stays 135 MHz, and the MCLK PLL keeps 135-270 MHz | V2 3.6 | must | VESA lines fail 200, `tvco` fail 1, POST fail 1 (MCLK) |
| V2-PLL-2 | V2 | XFree86 programs the V2 DCLK VCO in 170-340 MHz | XFree86 | derived | VESA lines WARN 08, `tvco` WARN 08; `s3patch.py` keeps every refresh entry in 170-340 MHz |
| V2-PLL-3 | V2 | SR12 bit 7 is the third bit of the DCLK R divider; SR12 bits 7-5 = 100b divides by 16. No other code with bit 7 set is defined. SR10 (MCLK) has no third R bit: bit 7 stays reserved | V2 3.6, 4.1 (SR12); V+ 16 (SR10 bit 7 reserved) | must | VESA lines fail 200 ('PLL R code'), `tvco` fail 4, POST WARN 1 (SR10 bit 7); `test_s3patch.py` pllcodes |
| V2-CLK-1 | V2 | DCLK maximum 95 MHz single-clocked with the Streams Processor off; 170 MHz with clock doubling (two 8-bit pixels per 85 MHz clock) | V2 table 5-7 note 2 | limit | VESA lines WARN 02 |
| V2-CLK-2 | V2 | DCLK maximum 80 MHz single-clocked with the Streams Processor on (CR67 bits 3-2 = 11b) | V2 table 5-7 note 2 | limit | VESA lines WARN 02 |
| CLK-1 | T32, T64, V+, UV+ | Maximum DCLK per colour mode (CR67 bits 7-4): mode 0 (8 bpp) 80 MHz; mode 8 (two 8-bit pixels per VCLK) 67.5 MHz VCLK, 135 MHz pixel rate; modes 9 and 10 (15/16 bpp) 80 MHz; mode 12 (packed 24) 75 MHz DCLK, 25 MHz pixel rate; mode 13 (24-bit true colour) 50 MHz. The V2 raises modes 0, 9, 10 and 8 (V2-CLK-1) | T32/64 table 8-1, V+ table 8-1 | limit | VESA lines WARN 02 |
| CLK-2 | T32, V+, UV+, V2 | Packed 24 bpp (mode 12, 640x480x24, one pixel per 3 DCLKs): SRB bit 3 = 1, SRB bits 7-4 = 0111b and CR67 bits 7-4 = 0000b; CR65 bits 4-3 = 10b (BLANK delayed 2 DCLKs); no hardware cursor. The CR67 description also lists 0111b as mode 12. On the Trio64 the mode does not exist ("Trio32 only") | T32/64 8.1.4, SRB, CR67; V+ 8.2.4, SRB, CR67 | must | VESA lines fail 200 (SRB 78h, 'packed 24 on a Trio64'); the CR65 bits are not checked |
| CLK-3 | T32, T64, V+, UV+, V2 | Clock-doubled mode 8 (CR67 bits 7-4 = 0001b) needs SR15 bit 4 or bit 6 and SR18 bit 7 | V+ SRB, CR67, SR15 | must | VESA lines fail 200 |
| CLK-4 | V+, UV+, V2 | "Clock doubling cannot be used with the Streams Processor active" (CR67 bits 3-2 not 00b) | V+ SRB | must | VESA lines fail 200 |
| T64-PLL-1 | T32, T64 | Loading: with SR15 bit 5 = 0, a new MCLK takes effect after a 1 is written to SR15 bit 0, which "must then be cleared to 0 to prevent repeated loading"; a new DCLK needs SR15 bit 1 = 1 and 3C2h bits 3-2 = 11b. Toggling SR15 bit 5 (0, 1, 0) loads both at once (REG-1). After power-up every MCLK change goes through SR10/SR11, every DCLK other than the two VGA clocks through SR12/SR13. Added 28 October 2026 | T32/64 9.2, SR10-SR13, SR15 | must | not checked (REG-1 is) |
| T64-CLK-1 | T32, T64 | Power-on clocks: MCLK 45 MHz; DCLK 25.175 MHz with 3C2h bits 3-2 = 00b and 28.322 MHz with 01b, loaded into SR12/SR13 automatically. Added 28 October 2026 | T32/64 9.2, SR10-SR13 | information | not checked |
| T64-CLK-2 | T32, T64 | CR31 bit 6 (high speed text font fetch) and CR3A bit 5 (high speed text font writing) are "only required for DCLK rates greater than 40 MHz". Added 28 October 2026 | T32/64 CR31, CR3A | information | not checked |
| CLK-5 | all | DCLK cycle at least 25 ns (40 MHz) in VGA modes, at most 100 ns (10 MHz) | clock tables (T32/64 and V+ table 4-6, V2 table 5-7, UV+ table 6-7) | limit | not checked |
| CLK-6 | all | fDCLK >= 1/2 fSCLK (the PCI clock) "to ensure valid writes to the PLLs" | clock table note 1 | limit | not checked |

## Memory

| ID | Chips | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- | --- |
| MEM-1 | T32, T64, V+, UV+ | MCLK cycle at least 16.67 ns (60 MHz) on the Trio32/64 and Trio64V+, 15 ns (66.67 MHz) on the Trio64UV+. The V+ feature list gives 50 MHz for EDO and 1-cycle EDO memory | T32/64 and V+ table 4-6, UV+ table 6-7, V+ section 1 | must (cycle time) | S3COMPAT POST fail 2 |
| VP-MEM-1 | V+ | 1-cycle EDO (CR36 bits 3-2 = 00b): CPU (linear addressing) accesses use 2-cycle EDO automatically | V+ 7.4 | information | not checked |
| VP-MEM-2 | V+ | SR15 bit 7 (2-MCLK memory writes, with SRA bit 7) "can allow 2 MCLK operation for MCLK frequencies between 55 and 57 MHz" | V+ SR15 | limit | not checked (README: data errors at 59.96 MHz on the V2 card) |
| T64-MEM-1 | T32, T64 | The display FIFO "must never underrun" (the display is corrupted). CR54 bits 7-3 (M) = number of 8-byte memory cycles for other uses than FIFO filling - 1, to be maximised without an underrun; the fill bandwidth is 120 MB/s with 1 MB, 240 MB/s with 2 or 4 MB (Trio64: 32 or 64 bits by 16 positions). "The M and N parameters [CR54, CR60] should only be changed with the screen turned off" (SR01 bit 5 = 1). Added 28 October 2026 | T32/64 7.4, CR54, CR60 | must (underrun), should (screen off) | not checked |
| T64-MEM-2 | T32, T64 | CR3B (start display FIFO fetch, bit 9 in CR5D bit 6) "must lie in the horizontal blanking period and is typically 5 less than the value programmed in CR0"; it takes effect only with CR34 bit 4 = 1. Added 28 October 2026 | T32/64 7.4, CR3B, table in 11.4.2 | must | not checked |
| T64-MEM-3 | T64 | EDO memory only for 1 or 2 MB; "fast page mode memory is required for 4-MByte configurations", and SRA bit 6 (pin 50 is RAS1) must be 1 for 4 MB of fast page memory. The Trio64 should not be strapped for a 32-bit PD bus with more than 1 MB, "as this will prevent correct memory size detection by the BIOS". Added 28 October 2026 | T32/64 7.1, SRA | must | not checked (a Trio64 rule; the V2 book sets its own memory rules) |
| T64-MEM-4 | T32, T64 | SRA bit 7 (2-MCLK CPU writes) improves performance with an MCLK below 57 MHz; between 55 and 57 MHz SR15 bit 7 should also be 1 if linear addressing is used (the same rule as VP-MEM-2). Added 28 October 2026 | T32/64 SRA | limit | not checked |
| V2-MEM-1 | V2 | MCLK maximum 66 MHz (15 ns) for fast page, 60 MHz (16.67 ns) for 1-cycle EDO; SGRAM (GX) at 66 MHz. The book gives no separate value for 2-cycle EDO: the tools use the fast page cycle time | V2 3.1, 3.1.2, table 5-7 | must | S3COMPAT POST fail 2 |
| V2-MEM-2 | V2 | CR36 bits 3-2 (strapped): 00 1-cycle EDO, 01 SGRAM, 10 2-cycle EDO, 11 fast page | V2 4.1 | must | S3COMPAT POST (selects the V2-MEM-1 limit) |
| V2-MEM-3 | V2/GX | SGRAM: at each power-on the BIOS sets CR88 bit 6 (refresh off), programs the CAS latency (CR88 bits 4-3), sets CR88 bit 5 (mode register cycle, clears itself), then clears CR88 bit 6; CR6F bit 3 = 0 at power-up | V2 3.1.1, 4.1 | must | not checked (DX card only) |
| V2-MEM-4 | V2 | CR87 bit 1 enables 1-cycle linear addressing; "the memory must be capable of supporting this mode" | V2 3.5, CR87 | must | not checked (README: hangs this card) |

## Registers

| ID | Chips | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- | --- |
| REG-1 | all | SR15 bit 5 (immediate MCLK/DCLK load) is written 1 then 0: "This register must never be left set to 1" | T32/64 and V+ SR15 | must | VESA lines fail 1000 |
| REG-2 | V+, UV+, V2 | CR66 bit 3 = 1 with CR66 bit 7 = 0 "is illegal and causes a system hang" | UV+ update ER010-B item 1 (about the V+ data book) | must | VESA lines fail 1000 |
| REG-3 | all | SR15 bit 1 (DCLK load enable) "should be programmed to 1 at power-up ... and then left at this setting" | V+ SR15 | should | not checked |
| T64-REG-1 | T32, T64 | Unlock: CR38 = 01xx10xxb (48h) opens CR30-CR3F, CR39 = A5h opens CR40-CRFF and CR36, CR37, CR68; CR40 bit 0 = 1 (read-modify-write) enables the enhanced command registers; SR08 = xxxx0110b opens SRD and the other extended SR. Relock: write a code that changes a significant bit (00h) and clear CR40 bit 0 by read-modify-write, only when the graphics engine is idle (9AE8h bit 9 = 0). Added 28 October 2026 | T32/64 11.2, SR8, CR38, CR39 | must | not checked |
| T64-REG-2 | T32, T64 | Enhanced mode must be on before linear addressing is enabled (CR58 bit 4 or 4AE8h bit 4), and the graphics engine should be idle (9AE8h bit 9 = 0). CR59/CR5A bits 31-23 are shared with PCI base address 0: program them through PCI, and write CR59/CR5A by read-modify-write without changing them. Added 28 October 2026 | T32/64 13.1, CR59-CR5A | must, should | not checked |
| T64-REG-3 | T32, T64 | Hardware cursor: the image starts on a 1024-byte boundary; its position should be reprogrammed at most once per vertical sync; CR45 bit 4 (cursor storage at the right of each line) needs CR4D bits 1-0 = 11b. Added 28 October 2026 | T32/64 13.4, CR45 | must | not checked |
| T64-ENG-1 | T32, T64 | Drawing command 9AE8h bit 0 "must always be programmed to 1". Added 28 October 2026 | T32/64 9AE8h | must | not checked |
| ENG-1 | V+, UV+, V2 | BEE8h index D and E have undefined power-on values: software writes both before the graphics engine is used (the write takes effect with the next engine command) | UV+ ER010-B item 4 (about the V+ data book); V2 4.1 | must | emulator `engine_init` |
| V2-REG-1 | V2 | SR1A bit 4 (FCTD) "must be set to 1 by the BIOS upon reset" | V2 4.2 | must | S3COMPAT POST "SR1A bit 4" fail 1; S3TEST (pedestal line) |
| V2-REG-2 | V2 | CR32 bit 3: "Reserved = 0. This bit should never be set to 1" | V2 4.1 | must | VESA lines fail 1000 |
| V2-REG-3 | V2 | With DAC power saving on (CR86 bit 7 = 0), CR86 bits 6-0 "must be at least 1 less than the End Horizontal Blank value programmed in CR5D_3, CR5_7 and CR3_4-0" | V2 4.2 (CR86) | must | VESA lines WARN 80 (not yet confirmed on a card) |
| V2-REG-4 | V2 | With CR90 bit 7 = 1 (primary stream L1 on), the 11-bit L1 (CR90 bits 2-0, CR91) = (bytes of displayed pixels per scan line / 8) - 1 | V2 4.2 (CR90, CR91) | must | VESA lines WARN 80 (not yet confirmed on a card) |
| V2-REG-5 | V2 | "The BIOS must write 00H to this register [CR26] upon each mode set"; CR39 = A5h first, and CR23 must be 00h before CR26 is written | V2 4.2 (CR23, CR26) | must | emulator `v2_writes` |
| V2-REG-6 | V2 | CR40 bit 0 and CR66 bit 0 are changed only during screen off (SR01 bit 5 = 1, which may take up to 3 HSYNCs to take effect) or vertical retrace | V2 4.1 | must | emulator `v2_writes` |
| V2-REG-7 | V2 | BEE8h index D and E have undefined power-on values; software initialises them before the graphics engine is used (two steps: the write takes effect with the next engine command); the family rule ENG-1 | V2 4.1; UV+ ER010-B item 4 | must | emulator `engine_init` |

## Trio64UV+ unified memory

The Trio64UV+ has no frame buffer of its own: it takes a part of the system memory and shares the
memory bus with the core logic. These rules are the interface between the chipset, the system BIOS
and the video BIOS; none is checked yet (no UV+ hardware or BIOS at hand).

| ID | Rule | Source | Strength |
| --- | --- | --- | --- |
| UV-SYS-1 | The frame buffer (0.5, 1, 1.5 or 2 MB) is at the very top of physical memory, above the top of memory reported to the operating system; it is not system memory for the OS, must be non-cacheable (no snooping), and PCI masters reach it only through the Trio64UV+, which implements a standard PCI base address for it; the memory controller ignores PCI master accesses to it | UV+ 3.2.1, figure 3-2 notes | must |
| UV-SYS-2 | Memory arbitration: MREQ (request), MGNT (grant), MPR (priority; not used with 2-pin schemes), sampled on the rising edge of ACLK (the host clock). The core logic owns the memory. CR81 bits 1-0 select VUMA 2-pin, Intel 2-pin or S3 3-pin arbitration; CR81 bits 6-4 the MA address translation of the chipset | UV+ 3.3, figure 3-3, CR81 | must |
| UV-SYS-3 | High priority: MPR asserted (3-pin) or an MREQ pulse (2-pin) when the display FIFO reaches its near-empty mark; the VUMA worst-case grant latency for a high priority request is 35 ACLKs. When the core logic withdraws MGNT, the Trio64UV+ releases the bus (worst case about 80 ACLKs, resolution dependent, not guaranteed) and keeps MREQ deasserted at least two clocks | UV+ 3.3.2, figures 3-5 to 3-7 | must |
| UV-SYS-4 | Operating mode CR82 bits 1-0: 00 UMA (normal), 11 test (private memory, no arbitration, a standalone Trio64V+); CR82 bit 2 uses ACLK as MCLK | UV+ 3.5, CR82 | must |
| UV-SYS-5 | Mixed voltage: VDDMEM and VDDMTOL 5 V or 3.3 V by the memory and core logic used (5 V memory with 3.3 V core logic: VDDMEM 3.3 V, VDDMTOL 5 V); core, LPB and PCI stay 5 V | UV+ 3.4 | must (board) |
| UV-SYS-6 | Boot: the system BIOS takes the frame buffer size from CMOS (or a default), disables the UMA video when other video is present, reports VUMA capabilities, sizes memory without the frame buffer, sets the PCI base register of the frame buffer and claims its address space before the OS boots; a mode set that needs a larger frame buffer needs a reboot (a smaller one should give the memory back) | UV+ 5.1, 5.2, figures 5-1, 5-2 | must |
| UV-MEM-1 | CR36 bits 7-5: 100b 2 MB, 101b 1.5 MB, 110b 1 MB, 111b 0.5 MB, 000b reserved (no 4 MB). With 0.5 or 1.5 MB, the linear window (CR58 bits 1-0) is 1 or 2 MB and software must not write beyond the frame buffer | UV+ 4.1 (CR36, CR58) | must |
| UV-REG-1 | CR83 bits 1-0 = 11b "is illegal and causes on-screen noise" (also: not with VUMA arbitration) | UV+ ER010-B item 3, CR83 | must |
| UV-REG-2 | With DAC power saving on (CR85 bit 3 = 0), CR86 bits 6-0 must be at least 1 less than the End Horizontal Blank value (the V2-REG-3 rule) | UV+ CR86 | must (WARN 80 until confirmed) |

UV-REG-1 and UV-REG-2 are checked by the VESA lines (fail 1000, WARN 80) when S3COMPAT finds a Trio64UV+.

## Datasheet errors and gaps

- T32/64 9.1 puts the PLL N value in "bits 15-11 of SR10" and "of SR12"; the register descriptions
  have bits 4-0, which the tools use (PLL-2).
- T32/64 9.2 gives a power-on DCLK of 25.125 MHz, the SR12 description 25.175 MHz (the VGA clock);
  the 9.2 example labels SR12/SR13 as "CR12" and "CR13".
- T32/64 table in 11.4.2 describes CR3B as the time "from the start of display active until the start
  of fetching", the CR3B description as a position in the horizontal blanking period (T64-MEM-2).

- V2 3.8 says the video BIOS copies C0040-C0043 to "CR81-CR83"; four bytes and the table above it
  show CR81-CR84.
- V2 table 5-7 gives a 12.5 ns minimum DCLK cycle (80 MHz) in enhanced mode, while note 2 of the
  same table allows 95 MHz single-clocked with the Streams Processor off. The tools use the note.
- V2 3.6 raises the DCLK PLL maximum to 340 MHz and says nothing about the minimum; the 170 MHz that
  XFree86 uses is not in the book (V2-PLL-2).
- Packed 24 bpp: sections 8.1.4 (T32/64) and 8.2.4 (V+) select it with SRB bits 7-4 = 0111b and CR67
  bits 7-4 = 0000b, while the CR67 descriptions list 0111b as mode 12. The tools accept both (CLK-2).
- UV+ errata ER010-B items 1 and 4 correct the Trio64V+ data book; they are taken as Trio64V+ rules
  and so for the chips that inherit from it (REG-2, ENG-1).
