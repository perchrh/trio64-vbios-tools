# Part A: chip start-up at POST, conventions, and the option ROM (Trio64, 86C764X)

Behaviour specification for a clean-room Trio64 video BIOS built on SeaVGABIOS (plan
`docs/seavgabios-trio64.md`, items 1, 4 and 6). It says what the POST must leave in the chip, the PCI
configuration and the BIOS data area, which conventions drivers and programs rely on after POST and
after every INT 10h call, and what the option ROM image must look like. It describes behaviour only:
registers, values, formulas, order constraints, inputs and outputs. How the code gets there is the
clean side's choice.

The target card is the ExpertColor DSP-3364P: S3 86C764X (Trio64, PCI 5333:8811), 2 MB fast page
memory, 64 KB EEPROM of which the board maps the upper half. The ROM must also work with 1 MB and
4 MB Trio64 boards and with EDO memory (1 or 2 MB).

Written 1 November 2026. Part B (the S3 mode set and the return to the VGA modes) and part C (VBE 1.2)
are separate parts of this specification; where a rule here depends on them it says so.

## Conventions

- **IDs.** `POST-n` the start-up, `CONV-n` the conventions other software relies on, `ROM-n` the option
  ROM image. An ID is never reused for another rule.
- **Sources.** T32/64: S3 Trio32/Trio64 Integrated Graphics Accelerators, March 1995, cited by section
  or register (for example "T32/64 11.2.1", "T32/64 CR36"). Rule IDs of `docs/chip-rules.md`
  (`PLL-1`, `T64-MEM-3`, ...) and `docs/bios-rules.md` (`BDA-14`, `B00-9`, ...) stand for the source
  those files give. PCI 2.1: PCI Local Bus Specification revision 2.1, section 6.3 (expansion ROMs);
  not in the repository (see "Missing documents"). VGADOC: Finn Thoegersen's VGADOC 4b,
  `standards/thoegersen/` (PCI.TXT, S3.TXT). VBE 1.2: the VESA BIOS Extension 1.2. "README Windows 9x":
  the black-box record of S3's Windows 9x driver in README.md, section "Windows 9x driver test".
  "Project rule": a decision of this project recorded in AGENTS.md ("Hard rules for the ROM"); it is
  binding for our ROMs but is not a data book requirement.
- **Strength.** *must*: the data book says must, never or illegal, or a program or driver fails
  without it, or a project rule; a violation is a FAIL. *should*: documented good practice, or the
  data book's power-on value where it states no requirement; a WARN at most. *note*: information the
  implementer needs; never a FAIL.
- **Checked by.** An existing test (S3TEST or S3COMPAT result line, emulator test in `emu/tests.py`),
  or "not checked" with the test that would check it. S3TEST and S3COMPAT run on the card and in the
  emulator; the emulator's Trio64 model (`--chip 764`) has limits listed under "Emulator limits".
- **Terms.** *S3 registers*: CR2D-CR6C, SR08-SR18 and the enhanced command registers (x2E8h ports).
  *Locked*: SR08 holds no unlock key (00h), CR38 and CR39 hold no key (00h), CR40 bit 0 = 0, the
  power-on state (T32/64 section 15, 16: "read/write protected at power-up"). *Found*: the value a
  register or index held when the INT 10h call was entered. *The card*: the DSP-3364P. *Mode set*:
  INT 10h AH=00h or AX=4F02h.
- A register this part does not name is left to parts B and C; where both name one, the mode set
  rule of part B decides the value it has after a mode set, and this part decides only what POST must
  have done before.

## Identification, wake-up and register access

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| POST-1 | The system BIOS calls the ROM's initialisation entry (offset 0003h) with a far call and AX = the card's PCI address (AH = bus, AL = device number in bits 7-3 and function in bits 2-0). POST takes the card's configuration space from AX and reads vendor 5333h and device 8811h at configuration offsets 00h and 02h there; it does not scan the bus for other devices. If AX does not address a 5333h:8811h device, POST still initialises the VGA part but treats the PCI base as unknown (CR59/CR5A left as found) | PCI 2.1 6.3.3.1; T32/64 19 (Vendor ID, Device ID); VGADOC PCI.TXT (INT 1Ah B109h, B10Ah) | must | not checked: the emulator's POST stub (`Machine.post`) passes no AX; a test that calls the entry with AX = 0048h (bus 0, device 9, the model's PCI BIOS address) and logs the configuration reads would check it |
| POST-2 | Wake-up before any other access to the chip: write 10h to 46E8h (setup mode), 01h to 102h (the chip responds: power-on value of 102h is 00h, "does not respond"), 08h to 46E8h (address decoders on, operational mode). With CR65 bit 2 = 1 the setup port is 3C3h instead of 46E8h (see open question 3) | T32/64 11.1 (wake-up program), 14.6 (102h, 46E8h), CR65 bit 2 | must | not checked: an emulator test that logs the port writes of POST before the first 3C4h/3D4h access |
| POST-3 | Unlock before the first access to an S3 register: CR38 = 48h (pattern 01xx10xxb) opens CR30-CR3F; CR39 = A5h (pattern 101xxxxxb; A5h also opens writes to CR36 bits 7-2, CR37 and CR68) opens CR40-CR6C; SR08 = 06h (xxxx0110b) opens SR09-SR18; CR40 bit 0 = 1, by read-modify-write, opens the enhanced command registers (x2E8h ports) | T64-REG-1; T32/64 11.2.1, 11.2.3, CR38, CR39, SR8, CR40 | must | not checked (reads of an S3 register before the unlock would show in an emulator write log) |
| POST-4 | CR40 is only ever changed by read-modify-write, and only its bit 0 is changed: bits 7-6 are reserved and written 0, bit 5 is reserved and written 1, bit 4 (ready control, VL-Bus) keeps the value found. The data book's power-on value is 30h | T32/64 11.2.2 ("a read-modify-write cycle must be used ... to prevent overwriting of any changes made to bits 7-1"), CR40 | must | not checked |
| POST-5 | Identification after CR38 is unlocked: CR30 bits 7-4 = Eh, then CR2D = 88h, CR2E = 11h for a Trio64 (10h for a Trio32), CR2F = the revision (= PCI revision, configuration 08h). CR2D-CR30 are read-only; POST never writes them | T64-ID-1; T32/64 11.3, CR2D, CR2E, CR2F, CR30, 19 (Device ID: "the type of chip used is determined from the CR2E register") | must | S3TEST 'S3 Chip ID CR2D 2E 2F 30, PCI rev' (INFO, prints the values) |
| POST-6 | Three chips answer 5333:8811: the Trio64 (CR2E = 11h, CR2F bit 6 = 0), the Trio64V+ (CR2E = 11h, CR2F = 4xh, VP-ID-1) and the Trio32 (CR2E = 10h). The two Trio64 parts, 86C764 and 86C764X, give the same IDs and cannot be told apart (T64-MEM-7). The ROM is for the Trio64; what it does on the other two is open question 1 | T64-ID-1, VP-ID-1, T64-MEM-7 | note | S3TEST 'S3 Chip ID ...' (INFO) |
| POST-7 | Bus: CR36 bits 1-0 (read-only strapping) = 10b on a PCI card. The ROM supports PCI only; on a VL-Bus strapping (01b) there is no PCI base (see open question 2) | T32/64 5.1 table 5-2, CR36 | note | not checked |
| POST-8 | After POST the chip is locked: SR08 = 00h, CR38 = 00h, CR39 = 00h, CR40 bit 0 = 0. CR40 bit 0 is cleared only when the graphics engine is idle (9AE8h bit 9 = 0); a relock value must change at least one significant bit of the key (00h does) | T64-REG-1; T32/64 11.2.2, section 15 and 16 introductions (power-on: protected) | should | not checked: an emulator test reading SR08, CR38, CR39 and CR40 after `m.post()` |

## PCI configuration and the linear base

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| POST-9 | PCI Command register (configuration 04h): the chip answers I/O only with bit 0 = 1 and memory only with bit 1 = 1. The system BIOS sets both before it runs a VGA ROM; POST reads them and, if either is 0, sets both, keeping every other bit (bit 5, DAC snooping, stays as the system BIOS set it) | T64-PCI-1; T32/64 19 (Command); VGADOC PCI.TXT (offset 04h) | should | not checked |
| POST-10 | Base Address 0 (configuration 10h): a memory BAR, 8 MB aligned, bits 31-23 writable, bits 3-0 hardwired 0 (memory, anywhere in 32 bits, not prefetchable). The system BIOS assigns it; POST never writes it | T32/64 19 (Base Address 0) | must | not checked |
| POST-11 | CR59 bits 7-0 and CR5A bit 7 are the same storage as BAR0 bits 31-23: a write to either changes both. After POST: CR59 = BAR0 bits 31-24, CR5A bit 7 = BAR0 bit 23, and CR5A bits 6-0 = 0, so that CR59/CR5A, read as bits 31-16 of an address, equal the BAR0 base for every window size of CR58 bits 1-0. POST writes CR5A by read-modify-write that keeps bit 7; it writes CR59 only with the value it already holds (or not at all) | T64-REG-2; T32/64 CR59-CR5A ("writes to CR59 and CR5A should be read-modify-writes that do not change bits 31-23"), 19 (Base Address 0), 13.1 | must | emu t_windows (CR59/CR5A after the driver's banked 4F02 equal their value after POST); not checked against BAR0 directly: a test comparing CR59/CR5A after POST with the model's E0000000h |
| POST-12 | When BAR0 reads 00000000h (no base assigned), CR59/CR5A stay 0000h and no linear window is used; nothing else in POST changes | T32/64 19 (power-on default 0000 0000h) | note | not checked |
| POST-13 | CR58 after POST: bit 4 = 0 (linear addressing off, so A0000h-BFFFFh is the VGA memory), bit 7 = 0 (RAS precharge and low time as the CR68 strapping sets them), bit 3 = 0 (VL-Bus only), bits 1-0 free (the window size has no effect while bit 4 = 0). 4AE8h bit 4, which is ORed with CR58 bit 4, is 0 (POST-27) | T32/64 CR58, 13.1, 4AE8h bit 4 | must (bits 4, 7), note (bits 1-0) | not checked |

## Memory: size, type and the strapped timings

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| POST-14 | Memory type: CR36 bits 3-2 come from the board strapping: 10b EDO, 11b fast page; 00b and 01b are reserved on the Trio64. POST reads them and never writes them; every CR36 write is a read-modify-write that keeps bits 4-0 | T64-MEM-5; T32/64 5.1 table 5-2, CR36; project rule (AGENTS.md: the ROM never writes CR36 bits 3-2) | must | S3TEST 'S3 CR36 memory type (strapping)' (INFO) |
| POST-15 | Memory size: POST finds the size by test at every POST and writes its code to CR36 bits 7-5: 110b 1 MB, 100b 2 MB, 000b 4 MB. The strapped value of bits 7-5 is not trusted: the data book says boards for an S3 BIOS need not strap PD7-5 because "the S3 BIOS determines this value directly and writes it to CR36 bits 7-5 after reset". Candidates, largest first: 4 MB only when CR36 bit 2 = 1 (fast page) and CR2E = 11h (Trio64); then 2 MB; then 1 MB. If no candidate holds, 1 MB is written | T32/64 5.1 ("the S3 BIOS determines this value directly"), CR36, 7.1; T64-MEM-3, T64-MEM-5 | must | not checked: the model returns the strapped size whatever is written to CR36 and does not model missing memory; a model whose video memory ends at the fitted size (reads beyond it float, the bus width follows CR36) would check it. Indirectly: VBE 4F00 TotalMemory (part C) under `make emu-test` with `--vram 1, 2, 4` |
| POST-16 | A candidate holds when, with its code in CR36 bits 7-5 (which also sets the memory bus width: 32 bits for 1 MB, 64 bits for 2 and 4 MB, T32/64 7.1), distinct test patterns written to the last 64 KB page of the candidate size and to the first page read back unchanged, and the write to the last page did not change the first (no wrap). Each pattern covers at least 8 consecutive bytes, so both 32-bit halves of the 64-bit memory word are tested. The pages can be reached through the 64 KB window at A0000h with Enhanced mode memory mapping (CR31 bit 3 = 1) and the 64 KB page number in CR6A bits 5-0 (CR31 bit 0 = 1); after the test CR31 and CR6A are back to their POST values (POST-36) and the video memory content is undefined until the mode set of POST-34 clears it | T32/64 7.1, 13.1, CR31 bits 0 and 3, CR6A | should | not checked (as POST-15) |
| POST-17 | 4 MB test: SRA bit 6 = 1 (pin 50 = RAS1, selecting the upper 2 MB) before the 4 MB candidate is tested, and back to 0 before the 2 MB candidate if 4 MB does not hold: on a 2 MB board pin 50 drives the output enable of the second megabyte (OE1 with EDO; with fast page and SRA bit 6 = 0 a copy of OE0). With EDO (CR36 bit 2 = 0) SRA bit 6 is never set (no function there, and 4 MB is fast page only). After POST: SRA bit 6 = 1 exactly when 4 MB was found | T64-MEM-3; T32/64 7.1, SRA bit 6, figures 7-2 and 7-3 | must | not checked (as POST-15) |
| POST-18 | CR68 (strapped: CAS/OE stretch bits 1-0, RAS low time bit 2, RAS precharge bit 3, monitor information bits 6-4, memory data bus size bit 7) and CR37 (strapped) are never written. The memory timing of the board is the strapping's | T32/64 5.1 table 5-2, CR37, CR68; project rule (plan item 1: "CR68 (strapped timings) left alone") | must | not checked: an emulator write log over POST and every call (no write to CR37 or CR68) |
| POST-19 | The size found is reported to software only through VBE 4F00 TotalMemory (number of 64 KB blocks; part C) and CR36 bits 7-5. The BIOS data area keeps the VGA value: 0040:0087h bits 6-5 = 11b (256 KB, BDA-14), and AH=12h BL=10h returns BL = 03h (B12.10-2). No public source defines an S3 field in the BIOS data area for the size | BDA-14, B12.10-2; VBE 1.2 (4F00 TotalMemory); T32/64 CR36 | must | S3COMPAT 'AH=12 BL=10 EGA info'; part C's 4F00 check |
| POST-20 | SRA bits 5-0 after POST: bit 5 = 0 (PD bus tri-stated when idle, the power-on value, "reduces power consumption"), bits 4-0 = 0 (no secondary memory controller). SRA bit 7 (2-MCLK CPU writes) is open question 5; SR15 bit 7 = 0 (POST-25) | T32/64 SRA, 7.5 | should | not checked |

## Memory clock

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| POST-21 | MCLK = 14.31818 MHz x (M + 2) / ((N + 2) x 2^R), with M = SR11 bits 6-0 (1-127), N = SR10 bits 4-0 (1-31), R = SR10 bits 6-5 (0-3); SR10 bit 7 and SR11 bit 7 are reserved and written 0. The VCO, 14.31818 MHz x (M + 2) / (N + 2), lies in 135-270 MHz | PLL-1, PLL-2; T32/64 9.1, SR10, SR11 | must | S3COMPAT 'MCLK PLL (SR10/SR11) vs datasheet' (fail 1 VCO or N = 0 or M = 0, WARN 1 SR10 bit 7); S3TEST 'S3 MCLK SR10 SR11 kHz/chip max' |
| POST-22 | MCLK at most 70 MHz on the Trio64 (the 86C764X's rating, which the card runs; T64-MEM-7), above the data book's 60 MHz (MEM-1). On an 86C764 (not distinguishable) the build is made for 60 MHz at most, and on a Trio32 (CR2E = 10h) 60 MHz is the limit. Above 70 MHz only as an explicit overclock build, never by default | T64-MEM-7, MEM-1; project rule (AGENTS.md: MCLK option up to 70 MHz, above only with OVERCLOCK) | must | S3COMPAT 'MCLK PLL (SR10/SR11) vs datasheet' fail 2; S3TEST 'S3 MCLK SR10 SR11 kHz/chip max' |
| POST-23 | The MCLK is a build input in MHz (default 59.96 MHz, the data book's 60 MHz: open question 4, answered). POST loads the PLL setting whose frequency is nearest to the input among those within POST-21 and not above the limit of POST-22; among settings with the same frequency, the smallest N, then the smallest R. By this rule 60 MHz gives 59.96 MHz (SR10 = 42h, SR11 = 41h, VCO 239.8 MHz), 69.8 MHz gives 69.80 MHz (SR10 = 22h, SR11 = 25h, VCO 139.6 MHz: the card's rated clock), 70 MHz gives 70.00 MHz (SR10 = 27h, SR11 = 56h, VCO 140.0 MHz), 55 MHz gives 54.89 MHz (SR10 = 41h, SR11 = 2Ch). The build may compute the setting and store it; POST need not compute | PLL-1, PLL-2, T64-MEM-7 (formula; the values are its results) | should | S3TEST 'S3 MCLK SR10 SR11 kHz/chip max' (prints the kHz); a build test comparing the stored setting with this rule |
| POST-24 | Loading: SR10 and SR11 are written, then the new MCLK is loaded either by SR15 bit 0 (write 1, then 0; the load follows after a short, variable delay, and only the MCLK is loaded) or by SR15 bit 5 (write 1, then 0; MCLK and DCLK load at once). Neither bit is ever left at 1. Bit 5 also loads the DCLK from SR12/SR13 when MISC (3C2h) bits 3-2 = 11b, so POST uses it only while MISC bits 3-2 select a fixed VGA clock (00b or 01b), or uses bit 0. Every SR15 write is a read-modify-write that changes only the bit named | T64-PLL-1, REG-1; T32/64 9.2, SR15 bits 0 and 5 ("This register must never be left set to 1"; bit 0 "should be cleared to 0 after loading to prevent repeated loading") | must | not checked: an emulator test reading SR15 after POST (bits 0 and 5 = 0) |
| POST-25 | SR15 after POST: bit 1 = 1 (DCLK load enable: without it the VGA clocks of MISC bits 3-2 = 00b and 01b are not loaded after power-up), bits 0 and 5 = 0, bits 4 and 6 = 0 (no DCLK halving or inversion in the VGA modes; part B sets them for clock doubling), bit 7 = 0 (no 2-MCLK linear writes; rejected on the Trio64V2 card, AGENTS.md), bits 3-2 = 0 (pin 147 is STWR, pin 148 outputs VCLK): SR15 = 02h | REG-3; T32/64 9.2, SR15 bit 1 ("should be programmed to 1 at power-up to allow loading of the VGA DCLK value and then left at this setting"); project rule (SR15 bit 7) | must (bits 0, 1, 5), should (others) | not checked (as POST-24) |
| POST-26 | The PLL registers are written while the DCLK is at least half the PCI clock: POST writes SR10/SR11 with a VGA clock selected (25.175 or 28.322 MHz, above 16.7 MHz for a 33 MHz PCI clock) | CLK-6 | should | not checked |
| POST-27 | The MCLK is loaded at every POST, cold or warm: after power-up the chip runs 45 MHz (T64-CLK-1), and after a warm boot the clock a driver or program left (S3's Windows driver can set its own MCLK, README Windows 9x) | T64-CLK-1, T64-PLL-1 ("after power-up, all MCLK frequency changes must be made by re-programming SR10 and SR11") | must | S3TEST and S3COMPAT MCLK lines (read after POST) |
| POST-28 | SR14 (PLL power-down, external clock select, clock synthesizer counters), SR16 and SR17 are S3 test registers. After POST SR14 = 00h (both PLLs powered, internal MCLK and DCLK); POST does not use SR14 bits 0-4, SR16 or SR17 to time or reset the PLLs | T32/64 SR14 ("used for S3 test purposes only"), SR16, SR17 ("reserved for S3 testing") | should | not checked |
| POST-29 | No settling time after an MCLK load is given in the data book. Video memory is not accessed (memory test, mode set clear) until the new MCLK has had time to settle; the time is open question 6, and the wait must not depend on the BIOS timer tick (CONV-6) | T32/64 9.2 ("delayed for a short but variable period of time") | should | not checked |

## Enhanced registers and the graphics engine at POST

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| POST-30 | Graphics engine reset, with CR40 bit 0 = 1: write 42E8h with bits 15-14 = 10b (reset), then with bits 15-14 = 01b (engine enabled). In both writes bits 11-8 = 0 (vertical sync, engine busy and FIFO interrupts disabled) and bits 3-0 = 1 (clear their status). The MCLK of POST-24 is loaded first: the engine runs on the MCLK | T32/64 18 (Subsystem Control 42E8h: GE-RST 00 no change, 01 enabled, 10 reset), 9.2 | should | not checked: an emulator test that logs the 42E8h writes |
| POST-31 | 4AE8h = 0000h after POST: enhanced functions off (bit 0 = 0, VGA and planar modes), linear addressing (bit 4) and MMIO (bit 5) through this register off | T32/64 11.1 (wake-up writes 0 to 4AE8h), 18 (Advanced Function Control) | must | not checked |
| POST-32 | BEE8h index D and index E are written before the first graphics engine command, by POST or by whichever call first issues one: index D = D000h (source and destination in the first MB unless E says otherwise), index E = E000h (base address bits 0, RSF 0, clipping inside, fast read/modify/write, colour compare off, 16-bit command registers). These are the T32/64 power-on values, but a warm boot leaves what the last program wrote, and the Trio64V+ family erratum calls them undefined | ENG-1; T32/64 18 (BEE8h index D power-on D000h, index E power-on E000h) | should | emu t_engine_init (runs on the Trio64V+, Trio64UV+ and Trio64V2 models only; with `--chip 764` not run: to extend) |
| POST-33 | If the ROM issues graphics engine commands (at POST or in a mode set clear), every command written to 9AE8h has bit 0 = 1, and before the ROM relocks CR40 bit 0, enables linear addressing or returns from the call, it waits until 9AE8h bit 9 = 0 (engine idle). The waits must end on a chip that never reports idle within a bounded time (error return, no hang) | T64-ENG-1, T64-REG-1, T64-REG-2; T32/64 9AE8h | must | not checked: the model counts engine commands (`ge_cmds`) but reads 9AE8h as FFFFh (busy), so a ROM that waits without a bound hangs there |
| POST-34 | POST ends in mode 03h, set as by INT 10h AH=00h AL=03h with the clear (B00 rules of `docs/bios-rules.md`), after the S3 registers hold the values of POST-36 | bios-rules B00-1 to B00-22, BDA-2 | must | emu t_post (POST returns, INT 10h vector at C000h); S3COMPAT 'Mode 03h' (run after POST) |
| POST-35 | Before POST (or any later call) writes a standard VGA register it clears the S3 write locks a warm boot may leave set: CR33 bit 4 = 0 (RAMDAC writes allowed), CR33 bit 6 = 0 (palette and border registers writable), CR35 bits 5-4 = 0 (horizontal and vertical timing registers writable), CR33 bit 1 = 0 (CR07 bits 1 and 6 protected by CR11 bit 7 as on a VGA) | T32/64 11.2.3 table 11-1, CR33, CR35 | must | not checked: an emulator test that sets these bits, calls AH=00h 03h and compares the registers with IBM's (as t_vga_registers does) |

### State of the S3 registers after POST (mode 03h)

POST-36 collects what POST leaves in each S3 register. "Part B" means the VGA mode set of part B
writes the register in every VGA mode and decides its value; the value given is what that mode set
must produce for mode 03h from the data book, and POST must at least not leave a value that breaks it.

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| POST-36 | After POST the S3 registers hold the values of the rows POST-36a to POST-36z below | T32/64 sections 14-18 (register descriptions and power-on values) | as each row | not checked as a whole: an emulator test reading every row after `m.post()` |
| POST-36a | SR08 = 00h, CR38 = 00h, CR39 = 00h, CR40 bit 0 = 0 (POST-8) | T64-REG-1 | should | as POST-8 |
| POST-36b | SR09 = 00h (bit 7: MMIO-only off) | T32/64 SR9 | should | not checked |
| POST-36c | SRA: bit 6 per POST-17, bit 5 and bits 4-0 = 0 (POST-20), bit 7 open question 5 | T32/64 SRA | as POST-17, POST-20 | not checked |
| POST-36d | SRB = 00h (internal dot clock, no VAFC clock, no feature connector colour mode) | T32/64 SRB | should | not checked |
| POST-36e | SRD = 00h: bits 7-4 = 0 (HSYNC and VSYNC normal; a warm boot after a DPMS off state would otherwise leave the monitor dark), bit 0 = 0 (feature connector off; enabling it forces the 32-bit PD bus of a 1 MB configuration) | T32/64 10.2, SRD, 7.1 | must | not checked: an emulator test that sets SRD = F0h, reruns POST, reads SRD |
| POST-36f | SR10/SR11 the MCLK of POST-23; SR12/SR13 not needed in mode 03h (MISC bits 3-2 select the fixed 28.322 MHz clock) | POST-21 to POST-24; T32/64 9.2, SR12, SR13 | as POST-21 to POST-24 | S3COMPAT and S3TEST MCLK lines |
| POST-36g | SR14 = 00h (POST-28); SR15 = 02h (POST-25) | T32/64 SR14, SR15 | as POST-25, POST-28 | not checked |
| POST-36h | SR18 = 00h: bit 7 = 0 (clock doubling off, needed only with CR67 colour mode 0001b), bit 5 = 0 (RAMDAC powered), bits 4-0 = 0 (test functions off); bit 6 (LUT write cycle, power-on 0 = 2 DCLKs) see open question 7 | T32/64 SR18, CLK-3 | should (bit 5: must) | not checked |
| POST-36i | CR31 (part B): bit 3 = 0 (IBM VGA memory mapping), bits 5-4 = 0 (display start bits 17-16), bit 1 = 0, bit 6 = 0 (high speed text font fetch is "only required for DCLK rates greater than 40 MHz"; mode 03h runs 28.322 MHz); bits 0 and 2 are part B's | T32/64 CR31; T64-CLK-2 | must (bit 3), should (others) | S3COMPAT 'Mode 03h' (the VGA picture and memory test depend on bit 3) |
| POST-36j | CR32 (part B): bit 4 = 0 (interrupt generation off); bit 6 (wrap at 256 KB) is part B's; reserved bits 0 | T32/64 CR32 | must (bit 4) | not checked |
| POST-36k | CR33 = 00h and CR35 = 00h (POST-35; bit 3 of CR33 = 0 lets the VGA halve VCLK in its 4-bit modes; CR35 bits 3-0, the old bank bits, 0) | T32/64 CR33, CR35, 9.3 | must (POST-35 bits), should (others) | as POST-35 |
| POST-36l | CR34 (part B): bit 4 = 0 in the VGA modes (CR3B not used), bits 2-0 = 0 (PCI master aborts and retries handled during RAMDAC cycles, the power-on behaviour) | T32/64 CR34 | should | not checked |
| POST-36m | CR3A (part B): bit 7 = 0 (PCI read bursts on; setting it needs CR66 bit 7 = 1 first, T64-PCI-1), bit 5 = 0 (DCLK below 40 MHz, T64-CLK-2), bit 4 = 0 (attribute controller in the 4-bit path of the VGA modes), bit 3 = 0 (top of memory access off); bits 2-0 (alternate refresh count) open question 8 | T32/64 CR3A, 7.2; T64-PCI-1, T64-CLK-2 | must (bit 7 order), should (others) | not checked |
| POST-36n | CR40 = 30h if found as the power-on value: bits 7-6 = 0, bit 5 = 1, bit 4 kept, bit 0 = 0 (POST-4, POST-8) | T32/64 CR40 | must (bit 0, bits 7-6 not set), should (others) | not checked |
| POST-36o | CR42 bit 5 = 0 (non-interlaced; CR3C unused); CR43 = 00h (bit 7: no horizontal counter doubling, bit 2: no old CR13 extension) (part B) | T32/64 CR42, CR43 | should | not checked |
| POST-36p | CR45 = 00h: hardware cursor off (bit 0 = 0), bit 4 = 0. CR46-CR4F (cursor position, colours, pattern address) are not written: undefined at power-on and unused while bit 0 = 0 | T32/64 CR45, 11.4.3 | must (bit 0) | not checked |
| POST-36q | CR50 = 00h, CR51 = 00h (engine screen width and pixel length at the power-on values; no CR13 or start address extension bits in the VGA modes, part B) | T32/64 CR50, CR51 | should | not checked |
| POST-36r | CR53 = 00h: bit 4 = 0 (MMIO off; with MMIO on, A8000h-AFFFFh would address the enhanced registers instead of VGA memory), bit 0 = 0 (write per bit off), bit 6 = 0 (no nibble swap) | T32/64 CR53, 13.3 | must (bit 4), should (others) | not checked |
| POST-36s | CR54, CR60 (display FIFO M and N) and CR3B, CR5D, CR5E, CR67: part B. CR67 bits 7-4 = 0000b (colour mode 0) in mode 03h | T32/64 CR54, CR60, CR67; T64-MEM-1 | as part B | part B |
| POST-36t | CR55 = 00h: bit 2 = 0 (a read of 3C8h returns the RAMDAC, not the General Input Port), bit 7 = 0 (VCLK output driven), bit 4 = 0 (MS-Windows cursor format) | T32/64 CR55, 10.3 | must (bit 2), should (others) | not checked |
| POST-36u | CR56 = 00h, CR57 = 00h, CR63 = 00h (no remote or genlock operation; sync outputs as at power-on) | T32/64 CR56, CR57, CR63, 10.6 | should | not checked |
| POST-36v | CR58 per POST-13; CR59/CR5A per POST-11 | T32/64 CR58-CR5A | as POST-11, POST-13 | as POST-11 |
| POST-36w | CR5C (General Output Port): the board's value, a build input (open question 9). The register is user definable and drives the external latch of GD7-0 when written | T32/64 CR5C, 10.4 | note | not checked |
| POST-36x | CR65 = 00h (bit 2 = 0: the setup port is 46E8h); CR66: bit 6 = 0 (pixel address bus driven), bit 7 = 0 (PCI disconnects off; if the ROM ever sets CR3A bit 7, CR66 bit 7 = 1 first), bits 5-0 reserved 0 | T32/64 CR65, CR66; T64-PCI-1 | must (CR66 bit 6), should (others) | not checked |
| POST-36y | CR69 = 00h and CR6A = 00h after the memory test: a non-zero CR69 replaces the display start bits 19-16 of CR31/CR51, a non-zero CR6A the CPU bank bits (part B and C use them in the S3 modes) | T32/64 CR69, CR6A | must | not checked |
| POST-36z | CR36 bits 7-5 per POST-15; CR36 bits 4-0, CR37, CR68: not written (POST-14, POST-18); CR41, CR52, CR6B, CR6C: see CONV-8; CR6D and above: never written (CONV-9) | as named | as named | not checked |

### BIOS data area, vectors and the sign-on at POST

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| POST-37 | POST sets up the VGA fields of the BIOS data area and the video vectors as `docs/bios-rules.md` describes: 0040:0087h-008Ah (BDA-14, BDA-15, BDA-16, BDA-18), 0040:00A8h (BDA-19), INT 10h, INT 1Fh, INT 43h (TAB-28) and INT 42h/INT 6Dh (TAB-30), then the mode 03h of POST-34 sets the per-mode fields (B00-19) | BDA-14 to BDA-19, TAB-28, TAB-30, B00-19 | must | emu t_post (INT 10h vector at C000h); not checked: the whole 0040:0049h-00ABh after POST against the IBM state block of mode 03h |
| POST-38 | POST writes no S3-specific field into the BIOS data area or into memory outside the VGA fields of BDA-20: no public source defines one for an S3 BIOS, and the memory size is reported as POST-19 says | BDA-20; VGADOC S3.TXT (no BIOS data area field) | must | not checked: an emulator comparison of 0040:0000h-00FFh before and after POST, outside the BDA-20 fields |
| POST-39 | The sign-on is an ASCII string in the ROM (ROM-8). Whether POST shows it on the screen, and for how long, is open question 10; if shown, the screen is left as POST-34 sets it (mode 03h, cleared, cursor at row 0 column 0) or the text stays where the system BIOS continues to write | ROM-8 | note | not checked |

### Order constraints at POST

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| POST-40 | POST keeps this order where steps depend on each other: (1) wake-up (POST-2) before any other chip access; (2) unlock (POST-3) before identification and any S3 register; (3) identification (POST-5) before anything that depends on the chip (the 4 MB candidate, the MCLK limit); (4) the PCI base (POST-9 to POST-11) before anything uses CR59/CR5A; (5) the MCLK load (POST-24) before the memory test and the engine reset (both need the final clock, POST-29); (6) the memory size (POST-15) before the mode set and before anything that reports the size; (7) the engine reset and BEE8h D/E (POST-30, POST-32) with CR40 bit 0 = 1; (8) the register state of POST-36 before the mode 03h set (POST-34); (9) the relock (POST-8) last, after the engine is idle | T32/64 11.1, 11.2, 9.2, 13.1, 5.1 (as cited in the rules named) | must | not checked: an emulator write log over POST |

## Conventions other software relies on

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| CONV-1 | CR59/CR5A hold the PCI base (POST-11: BAR0 bits 31-16, CR5A bits 6-0 = 0) after POST and after every INT 10h call, mode sets included, whatever CX and DX hold and whether bit 15 (no clear) is set. S3's Windows 9x driver sets each desktop mode with 4F02 BX = 8000h + mode, then writes CR58 = 92h itself (linear on, 2 MB window) and takes the linear address from CR59/CR5A; any other value there puts its window elsewhere (garbage on the desktop) | README Windows 9x (findings: "it ... takes the linear address from CR59/CR5A, which it expects at the PCI base"); T32/64 CR59-CR5A | must | emu t_windows (the driver's banked 4F02 calls with INT 2Fh AX=1600h answering Windows: CR59/CR5A unchanged from POST) |
| CONV-2 | The ROM never writes CR59/CR5A bits 31-23 with another value and never enables linear addressing by itself in a banked mode: 4F02 of a banked mode leaves CR58 bit 4 = 0; the driver turns its window on itself (CONV-1). (A "booster" that moves the window to A0000h is not in the scope of this ROM) | T64-REG-2; README Windows 9x (the p15 booster left CR59/CR5A = 000Ah and broke the desktop) | must | emu t_windows |
| CONV-3 | The Windows 9x driver's calls, which must all succeed as VBE 1.2 and the VGA standard define them: at start 4F15 BL=00h, 4F10 BL=00h, then AH=00h AL=10h; for each desktop mode 4F00, 4F01 per mode, 4F02 BX = 8000h + mode with CX = scan lines and DX = 03D4h (CX and DX are no inputs of 4F02 and must not change the result), then 4F08; for a full-screen DOS box 4F02 8101h, 8103h or C101h with CX = 0000h, DX = 03E0h, and back to the desktop 4F02 8115h; at exit AH=00h AL=03h twice and 4F03. 4F10 and 4F15 are outside this ROM's scope: they answer "not supported" (VBE: AL = 4Fh with AH = 01h, or AL other than 4Fh) and change nothing; whether the driver accepts that is open question 11 | README Windows 9x (findings); VBE 1.2 (function return status) | must (supported calls), note (4F10/4F15) | emu t_windows (the call list, the 32-bit runs and the driver sequence) |
| CONV-4 | 32-bit callers: every INT 10h function returns the bits 31-16 of EAX, EBX, ECX, EDX, ESI, EDI, EBP and ESP as the caller gave them, and DS and ES unchanged, unless the function defines a 32-bit or segment result. A function that calls the PCI BIOS restores what that call may change ("EAX, EBX, ECX and EDX may be modified") | emu t_windows docstring (VideoPortInt10 and the INT 10h interface of Windows pass 32-bit registers); VGADOC PCI.TXT (INT 1Ah B109h notes) | must | emu t_windows (the dirty-upper-halves run) |
| CONV-5 | Every INT 10h function returns when called with interrupts disabled and with no timer tick arriving: no wait (PLL settling, retrace, engine idle) depends on IRQ 0 or the BIOS tick count at 0040:006Ch alone; waits end on a bounded count of I/O reads or on a hardware status | emu t_windows ("interrupts off and no timer tick": VDM and the x86 BIOS emulator of 64-bit Windows) | must | emu t_windows (IF = 0, no tick, every call returns) |
| CONV-6 | POST obeys the same: no wait in POST depends on the BIOS tick (the system BIOS may run option ROMs with interrupts off) | as CONV-5; PCI 2.1 6.3.3.1 (no interrupt state is promised to the initialisation code) | should | not checked: run `m.post()` with the model's tick frozen (`m._ticks = lambda: 0`) |
| CONV-7 | Mode 03h after the driver: AH=00h AL=03h after any sequence of S3 modes, 4F08 and palette calls gives IBM's mode 03h: a 6-bit DAC (4F08 BL=01h returns BH = 6), the EGA palette in DAC 0-63, the registers of IBM's table; and AH=00h AL=83h keeps the text while 0040:0087h bit 7 is set | B00-4, B00-11, B00-22; README Windows 9x (mode 03h at exit) | must | emu t_windows (the checks after the driver sequence) |
| CONV-8 | S3 lock state: every INT 10h call returns with SR08, CR38, CR39 and CR40 bit 0 as it found them (a call that needs S3 registers unlocks them itself and restores the found values before it returns). POST leaves them locked (POST-8). A program cannot rely on any call leaving the S3 registers unlocked (open question 12: programs written for BIOSes that leave them unlocked) | project rule (AGENTS.md: "new code unlocks itself and leaves the lock as found"); T64-REG-1 | must | S3TEST 'VBE 4F05 regs, SR index, CR6A, planar, LFB' (fail 2: SR08 after 4F05); not checked for CR38, CR39, CR40 and other calls: an emulator test entering every function with the chip locked and unlocked and comparing the four values on return |
| CONV-9 | Index registers: every INT 10h call returns with the sequencer index (3C4h), the graphics controller index (3CEh) and the CRTC index (3D4h, or 3B4h when MISC bit 0 = 0) as it found them. For a mode set that switches between the colour and monochrome CRTC addresses, the CRTC index at the new address gets the value found at the old one. The attribute controller index and flip-flop follow B00-9 and B10-4 instead, and the DAC read and write indexes are not covered | project rule (AGENTS.md: "leaves the index registers it touches as it found them, at least the sequencer index 3C4h"; programs that set an index before an INT 10h call rely on it) | must (3C4h), should (3CEh, 3D4h) | S3TEST 'VBE 4F05 regs, SR index, CR6A, planar, LFB' (fail 2: 3C4h after 4F05); not checked for the other calls and indexes: an emulator test setting 3C4h, 3CEh, 3D4h to unusual indexes before every function |
| CONV-10 | CR41 and CR52 ("BIOS Flag", "Extended BIOS Flag 1": "used by the video BIOS", coding "see the S3 video BIOS documentation") and CR6B, CR6C ("reserved for use by the S3 BIOS") carry no state any driver or utility at hand depends on for the Trio64: S3's Windows 9x driver takes the base from CR59/CR5A, chooses no refresh rate and never reads them (README Windows 9x); the S3 OEM refresh functions that use CR41/CR52 exist only in BIOSes of the Trio64V2 (chip-rules "S3 OEM functions", OEM-2), and VGADOC shows different vendor codings of CR41/CR52. The clean ROM is free there: it need not write these registers; state it keeps there is documented with the ROM. It does not write CR6B, whose bit 7 and bits 1-0 sections 6.2, 7.1 and table 4-9 give hardware meanings (T64-MEM-6; see "Sources disagree") | T32/64 CR41, CR52, CR6B, CR6C; T64-MEM-6; VGADOC S3.TXT (CR41, CR52, CR6B, CR6C); README Windows 9x; chip-rules OEM-1 to OEM-6 | note (free), should (CR6B not written) | not checked: the emulator write log (no write to CR6B) |
| CONV-11 | CR6D and every CRTC index from 6Dh up are not Trio64 registers: no state is kept there. The Trio64 decodes CRTC index bits 6-0 only (on the card CR80-CRFF read back as CR00-CR7F), so the ROM never writes a CRTC index of 80h or above (it would change CR00-CR7F) | T32/64 register list (ends at CR6C); chip-rules "Datasheet errors and gaps" (CRTC index aliasing, read on the card) | must | not checked: the emulator models the aliasing (`Machine._ci`); a write log check for indexes 6Dh-FFh |
| CONV-12 | The MCLK POST loads is the clock the system runs under Windows: S3's driver keeps the BIOS's MCLK on the desktop, in DOS boxes and during video playback, and uses the BIOS's pixel clocks (README Windows 9x). So the POST MCLK (POST-23) and part B's display FIFO values decide the picture under Windows too | README Windows 9x (findings); card observation (S3REGS: the driver keeps the ROM's MCLK) | note | S3REGS before and after Windows (card) |
| CONV-13 | VBE 4F14h (S3 OEM functions) is absent from every Trio64 BIOS examined, so no Trio64 program can depend on it; the clean ROM answers 4F14h as an unsupported VBE function (part C) | chip-rules "S3 OEM functions (4F14h)" (T64 row: none) | note | emu t_windows ('4F14 query' returns and keeps the registers) |

## The option ROM image

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| ROM-1 | Expansion ROM header: offset 00h-01h = 55h AAh; 02h = the image length in 512-byte units, 40h for 32 KB; 03h = the initialisation entry (a jump, called far by the system BIOS, returns far); 18h-19h = the offset of the PCI data structure. The 8-bit sum of all bytes of the length given at 02h is 00h | PCI 2.1 6.3.1.1 | must | S3TEST 'ROM ROM checksum (C000:0000-7FFF) = ' (sum over the 32 KB at C000h, read after POST); not checked in the image: a build test |
| ROM-2 | PCI data structure, DWORD aligned, inside the image: signature "PCIR"; vendor ID 5333h; device ID 8811h (the chip's: the system BIOS matches the ROM to the device by these, T32/64 19); pointer to vital product data 0000h (the Trio64 has none); structure length 0018h; structure revision 00h (PCI 2.1); class code bytes 00h (programming interface), 00h (sub-class), 03h (base class), the chip's hardwired class 030000h; image length 0040h (32 KB, equal to header byte 02h); revision level of the code: the ROM's own, free; code type 00h (x86, PC-AT compatible); indicator 80h (last image); reserved 0000h | PCI 2.1 6.3.1.2; T32/64 19 (Vendor ID 5333h, Device ID 8811h, Class Code 030000h) | must | not checked: a build or emulator test reading the structure through offset 18h (SeaVGABIOS fills it from `rom_pci_data` with CONFIG_VGA_VID/DID; QEMU's IDs are the slim build's default) |
| ROM-3 | The 32 KB image is padded to its full 32768 bytes (unused bytes 00h) and the checksum of ROM-1 covers them all | PCI 2.1 6.3.1.1; project rule (AGENTS.md: correct checksum in the lower 32 KB) | must | S3TEST 'ROM ROM checksum (C000:0000-7FFF) = ' |
| ROM-4 | The EEPROM image is 64 KB: the 32 KB image twice, at 0000h-7FFFh and 8000h-FFFFh, byte for byte the same. The chip decodes a 64 KB ROM range (PCI ROM base register at 30h), and a board may map either half of a 64 KB part to it: the DSP-3364P maps the upper half (with zeros there the card stayed dark at POST, #78), the Trio64V2 card the lower one | T32/64 10.1.4 ("relocatable 64-KByte video BIOS address range"), 19 (BIOS ROM Base Address); project rule (AGENTS.md: "the 64 KB images ... carry the 32 KB twice"); issue #78 (card observation) | must | not checked: a build test comparing the two halves |
| ROM-5 | Because the PCI data structure declares one 32 KB image with the last-image bit, firmware that reads the ROM through the ROM base register uses the first 32 KB of the window and ignores the copy | PCI 2.1 6.3.1 (image chaining by length and indicator) | note | not checked |
| ROM-6 | If POST writes into its own image while the system BIOS has it shadowed and writable (SeaVGABIOS keeps variables in its image), it leaves the image with a byte sum of 00h over the length at offset 02h before it returns, and it does not change the length byte or the PCI data structure | PCI 2.1 6.3.3.1 (the initialisation code may modify the image in shadow memory; the header must stay valid) | must | S3TEST 'ROM ROM checksum (C000:0000-7FFF) = ' (reads the shadowed copy after POST) |
| ROM-7 | The ROM's code and data fit the 32 KB image with real-mode code for a 386 or later; the image runs from C000h after the system BIOS has copied it there | plan (`docs/seavgabios-trio64.md` "Scope"); `docs/clean-room.md` item 8 | must | the build (size check) |
| ROM-8 | Sign-on string: plain ASCII inside C000:0000h-00FFh, containing "Version " followed by the ROM's version with a level suffix that changes with every released build (as our other ROMs' "-pN"). It names the BIOS as our own and the chip by its public name (S3 Trio64); it carries no Phoenix or S3 copyright text and no text copied from another BIOS | project rule (AGENTS.md: "Every ROM version carries a -pN suffix in the sign-on string"); S3TEST 'ROM ROM signature' (searches C000:0000h-00FFh for "Version ") | should | S3TEST 'ROM ROM signature ...' (needs the clean ROM's version constant in common/version.inc) |
| ROM-9 | The three bytes "IBM" at offset 1Eh: SeaVGABIOS writes them there, as many VGA ROMs do; keep them (open question 13 asks for a public source) | SeaVGABIOS `vgasrc/vgaentry.S` (LGPLv3 base) | note | not checked |

## Open questions

1. **Other chips with 5333:8811.** On a Trio32 (CR2E = 10h) or a Trio64V+ (CR2F bit 6 = 1), should
   POST refuse the S3 functions (VGA only), run with that chip's limits (Trio32: 2 MB, 60 MHz MCLK, no
   4 MB candidate; Trio64V+: its own register set), or run as on a Trio64? The data books allow one
   BIOS for the Trio32 and Trio64 ("This allows the same BIOS to be used with either chip"), but this
   ROM is tested on a Trio64 only.
2. **VL-Bus strapping.** CR36 bits 1-0 = 01b: no PCI BAR; T32/64 6.2 puts the linear base in CR59-5A
   alone. Out of scope for a PCI card ROM; should POST then leave CR59/CR5A untouched and offer no
   linear base?
3. **Setup port after a warm boot.** If a program left CR65 bit 2 = 1, the wake-up port is 3C3h, not
   46E8h, but CR65 can only be read after the unlock, which needs the chip awake. Does a warm boot
   reset CR65 (the data book defines only the power-on reset), and should POST also write the
   wake-up sequence to 3C3h? On a PCI system with another VGA card, 46E8h and 3C3h writes may reach
   that card too.
4. **Default MCLK of the build.** Answered by the owner on 1 November 2026: 59.96 MHz (the data
   book's 60 MHz, MEM-1; every timing of the card's -50 fast page parts holds). 69.80 MHz (the card's
   stock clock, T64-MEM-7) stays available through the build input. The display FIFO M of part B
   follows the MCLK POST loads (#75, #82; MQ-12: the 6-MCLK cost is not yet confirmed at 60 MHz).
5. **SRA bit 7 (2-MCLK CPU writes).** The data book says it "improves performance for systems using
   an MCLK less than 57 MHz" and asks for SR15 bit 7 between 55 and 57 MHz with linear addressing. Is
   it allowed above 57 MHz (59.96 or 69.8 MHz), or must it be 0 there? Needs a VRAM test on the card
   at each clock.
6. **PLL settling time.** How long after an MCLK load (SR15 bit 0 or bit 5) may video memory be
   accessed? The data book gives none. A card test: load, then run S3COMPAT's VRAM test at once.
7. **SR18 bit 6 (LUT write cycle).** Power-on 0 (2 DCLKs per palette write). Does a 1-DCLK cycle
   matter for any program (fast palette loads), and is it safe at the VGA clocks? No data book
   guidance.
8. **Refresh in the VGA modes (CR3A bits 2-0).** With CR3A bit 2 = 0 the VGA's CR11 bit 6 sets 3 or
   5 refresh cycles per line; with bit 2 = 1, CR3A bits 1-0 set the count (the data book's 1024x768
   example uses 1 per line). The data book gives no requirement; the DRAMs need their refresh period
   (cycles per line x line rate >= rows / refresh period of the parts fitted). Which setting at POST
   and in the VGA modes?
9. **CR5C (General Output Port).** Its bits are "user definable" and drive an external latch whose
   wiring is the board maker's (on S3's design the DDC lines; the card's GOP wiring is still open). Which value must POST write on the DSP-3364P, or should it not
   write CR5C at all? A card configuration input (`docs/clean-room.md` item 7); the value must come
   from the board, measured or documented.
10. **Sign-on on the screen.** Should POST print the sign-on string (many VGA BIOSes do; no standard
    requires it), and wait for the monitor? SeaVGABIOS's slim build prints nothing.
11. **4F10 and 4F15 not supported.** S3's Windows 9x driver calls both at start. Does it accept "not
    supported" answers (and then work without DPMS and DDC), or does it fail? A card test with the
    clean ROM under Windows 98.
12. **Programs that rely on the S3 registers staying unlocked.** A ROM that leaves the lock as found
    (CONV-8) breaks a program that sets an S3 or VESA mode and then writes S3 registers without the
    unlock of T32/64 11.2.1. Is any such program known (games with their own S3 code, S3's own
    utilities)? A survey with VGALOG and S3REGS before and after such programs.
13. **"IBM" at offset 1Eh.** Which programs check it, and which public source documents it?
14. **Memory test patterns.** Is there a data book or DRAM reason to prefer particular patterns (for
    example 55h/AAh and their complements) or to test more than one location per page, given the
    page-mode and bus-width behaviour of 1 MB boards strapped for a 64-bit bus?

## Sources disagree, gaps

- **CR6B bit 7 versus CR68 bit 7.** T32/64 sections 6.2 and 7.1 give "bit 7 of CR6B" the memory data
  bus width ("cleared to 0 (either via power-on strapping of PD23 or by programming)") and table 4-9
  note 3 gives "bits 1-0 of CR6B" the CAS/OE stretch; the strapping table 5-2 and the register
  descriptions put PD23 (bus size) in CR68 bit 7 and the stretch in CR68 bits 1-0, and call CR6B
  "reserved for use by the S3 BIOS". The CR68 reading is the more consistent one (the strapping table,
  the register description and the card's CR68 = 8Dh, bit 7 = 1 with 2 MB, agree), so "CR6B" in 6.2,
  7.1 and table 4-9 is probably a misprint for CR68. This part avoids the question: POST never writes
  CR68 (POST-18) and never writes CR6B (CONV-10). `docs/chip-rules.md` T64-MEM-6 follows sections 6.2
  and 7.1 and should be revisited with this reading.
- **CR36 bits 7-5: strapped or written.** T32/64 5.1 says the S3 BIOS determines it and writes it,
  and that boards for an S3 BIOS need not strap PD7-5. POST-15 follows the data book. Bits 3-2 (type)
  are never written, as the plan and AGENTS.md say.
- **Power-on DCLK.** T32/64 9.2 says 25.125 MHz, the SR12 description 25.175 MHz (chip-rules
  "Datasheet errors"); POST does not depend on the difference.
- **BEE8h index D and E.** T32/64 gives power-on values (D000h, E000h); the Trio64V+ family erratum
  (ENG-1) calls them undefined. POST-32 writes them, which satisfies both.
- **SR15 bit 1.** REG-3 is cited from the Trio64V+ book; the Trio32/Trio64 book's SR15 description
  has the same sentence, so the rule is a Trio64 rule too.

## Emulator limits for these rules

The Trio64 model (`emu/vgaemu.py`, `--chip 764`) starts every register at 00h (not the data
book's power-on values: CR40 is 00h there, not 30h), answers CR2D-CR30 and CR36 with fixed values
whatever is written (CR36: the strapped type and the `--vram` size), keeps BAR0 in CR59/CR5A, does not
model missing video memory, bus width, refresh or the PLLs (an MCLK load has no effect), reads 9AE8h
as busy, and starts POST without AX = bus/device/function. Rules about memory sizing, PLL loading and
the engine can be checked there only as register writes, not as effects.

## Tests to add (traceability)

- An emulator POST state test for `--chip 764`: after `m.post()`, every row of POST-36, SR15 bits
  0, 1, 5 (POST-24, POST-25), the lock (POST-8), CR59/CR5A against BAR0 (POST-11), CR58 bit 4 = 0
  (POST-13), 4AE8h = 0 (POST-31), no write to CR37, CR68, CR6B, CR6D-CRFF or to CR36 bits 4-0 (POST-14,
  POST-18, CONV-10, CONV-11), and the order of POST-40 from a write log.
- The POST stub passing AX = 0048h (POST-1) and a frozen tick during POST (CONV-6).
- An extension of `t_engine_init` to `--chip 764` (POST-32).
- A lock and index test over every INT 10h function, entered locked and unlocked with unusual
  3C4h/3CEh/3D4h indexes (CONV-8, CONV-9).
- A build test: header, PCI data structure, checksum, padding and the two identical halves (ROM-1 to
  ROM-4).
- A model with real memory sizes (POST-15 to POST-17).

## Missing documents

- PCI Local Bus Specification 2.1 (or 2.2), section 6.3 (expansion ROM header, PCI data structure,
  initialisation entry): the source of ROM-1, ROM-2, ROM-5, ROM-6 and POST-1. Not in the repository;
  VGADOC PCI.TXT covers the PCI BIOS calls and the configuration header, not the ROM format.
- The S3 Video BIOS and Utilities OEM Guide that T32/64 11.4 refers to (the coding of CR41/CR52 and
  the monitor information bits of CR37/CR68 in S3's BIOS).
- The DRAM data sheets' refresh periods for the parts the card fits (open question 8).
