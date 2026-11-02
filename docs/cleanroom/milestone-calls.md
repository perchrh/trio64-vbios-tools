# The INT 10h calls of the milestone programs (card record of 2 November 2026)

What the programs of milestones 3 and 4 ask of the video BIOS
([`docs/clean-room.md`](../clean-room.md) "Decisions of 2 November 2026", [#145](https://github.com/perchrh/trio64-vbios-tools/issues/145)), recorded on a card with VGALOG
in memory mode. The first part, "The contract", lists the calls as the programs make them: inputs only, and
what the standards say they must return. It crosses to the clean side after the leak review. The second part,
"The run", holds the provenance and what our ROM answered. It stays on the dirty side.

Milestone 2 is recorded for MS-DOS EDIT (below); the DOS calls around the programs are listed apart.

## The contract (crosses after the leak review)

The calls each program made through INT 10h, in order. VGALOG's memory mode does not log AH=02h, 03h,
08h, 09h, 0Ah, 0Ch, 0Dh, 0Eh and 13h, so the programs may also use those (text output, cursor, pixels).
It does not see anything a program writes to the ports itself (the DAC, the CRTC, the bank
registers); far calls to the VBE window function it sees with `/W`.

### Milestone 2: MS-DOS 6.22 EDIT

EDIT started, used and left (VGALOG /P, 2 November 2026; no mode set, so nothing was traced). The text
itself goes to video memory at B800h or through the calls VGALOG does not log (above).

| Call | Input | Count | What the program needs |
| --- | --- | --- | --- |
| AX=1A00h | | 1 | the display combination code: AL = 1Ah back, BL = 08h |
| AH=0Fh | | 1 | the current mode (03h, 80 columns) |
| AX=1130h | BH = 00h | 1 | the font information: CX = 16 (bytes per character), DL = 24 (rows - 1); ES:BP the INT 1Fh pointer |
| AX=1003h | BL = 00h | 1 | blink off: attribute bit 7 selects the bright background |
| AH=01h | AL = 03h, CX = 2000h | 9 | cursor off (CH bit 5) |
| AH=01h | AL = 03h, CX = 0607h | 6 | cursor shape lines 6-7 (with cursor emulation on, B01-4) |
| AX=1003h | BL = 01h | 1 | blink on again, at the exit |
| AH=01h | AL = 00h, CX = 0D0Eh | 1 | cursor shape lines 13-14, at the exit |

AH=01h is called with AL = the current mode (03h): some BIOSes need it, the standard does not; the
clean ROM ignores AL in AH=01h.

### Milestone 3: Superscape 3D Bench 1.0c

| Call | Input | Count | What the program needs |
| --- | --- | --- | --- |
| AH=00h | AL = 13h | 1 | mode 13h, 320x200 in 256 colours, with the screen cleared |
| AX=1012h | BX = 0000h, CX = 0100h (all 256 DAC entries), ES:DX = the table | 5 | the DAC block load (B1012 rules of [`docs/bios-rules.md`](../bios-rules.md)) |
| AH=00h | AL = 03h | 1 | back to 80x25 text |

No VBE call and no S3 mode: milestone 3 needs only the standard VGA mode 13h and the DAC function.

### Milestone 4: Chris's 3D Benchmark

The 320x200 run:

| Call | Input | Count | What the program needs |
| --- | --- | --- | --- |
| AX=1A00h | | 1 | the display combination code: AL = 1Ah back, BL = 08h (VGA with an analogue colour display) |
| AH=00h | AL = 03h | 2 | 80x25 text |
| AH=12h BL=34h | AL = 00h | 1 | cursor emulation on; AL = 12h back |
| AH=00h | AL = 13h | 1 | mode 13h |
| AH=00h | AL = 03h | 2 | back to text |
| AH=12h BL=34h | AL = 00h | 1 | cursor emulation on |

The 640x480 VESA run:

| Call | Input | Count | What the program needs |
| --- | --- | --- | --- |
| AX=1A00h, AH=00h AL=03h, AH=12h BL=34h AL=00h | as above | 1 each | as above |
| AH=0Fh | | 1 | the current mode (80x25 text, mode 03h) |
| AX=4F00h | ES:DI = a 256-byte buffer | 3 | the VBE information block, AX = 004Fh |
| AX=4F01h | CX = 0100h, then 0101h | 2 each | the mode information of 100h (640x400) and 101h (640x480), both in 256 colours; AX = 004Fh |
| AX=4F02h | BX = 0101h | 1 | mode 101h, 640x480 in 256 colours, banked (bit 14 clear), cleared (bit 15 clear); AX = 004Fh |
| AH=0Fh | | 1 | read once in mode 101h, at the end of the run |
| AH=00h | AL = 03h | 2 | back to text |
| AH=12h BL=34h | AL = 00h | 1 | cursor emulation on |

What follows for the clean ROM:
- **The VESA mode is 101h**, 640x480 in 256 colours (VBE 1.2), banked. Mode 100h must at least be
  reported correctly by 4F01h, because the program asks for it. Whether it is used when offered is not
  known.
- **No bank change through the BIOS:** no INT 10h 4F05h and no far call through the window function
  (WinFuncPtr of 4F01h, VBE 1.2) between the mode set and the return to text, in about 21 s of drawing
  in mode 101h (`VGALOG /W`, below). The program draws 640x480 x 1 byte = 300 KB through a 64 KB window,
  64 KB at a time, and changes the bank itself, from protected mode, with its S3 driver (the program,
  below). For each bank it writes, through 3D4h/3D5h:
  - CR38 = 48h (unlock);
  - CR31 = CR31 OR 09h (bit 0, CPU base address on; bit 3, enhanced 256-colour mapping);
  - CR35 = the bank number (64 KB units, bits 3-0; CR35 bits 7-4 overwritten with 0);
  - CR38 = 00h (lock again).

  It finds the S3 by the lock: CR35 bits 3-0 must not change while CR38 = 00h, and must change while
  CR38 = 48h.

  So the clean ROM must, after 4F02h 101h, leave CR6A = 00h (a non-zero CR6A makes the chip ignore
  CR35 bits 3-0, spec C VBE-53), CR51 bits 3-2 = 0, and a mapping in which CR31 bits 0 and 3 select
  64 KB pages of the 640x480 frame (spec C VBE-44). It must still report the window fields of 4F01h
  correctly (WinAAttributes, WinGranularity, WinSize, WinASegment, WinFuncPtr): the program reads 100h
  and 101h.
- **AH=0Fh in a VESA mode:** no standard defines what AL holds after 4F02h; the program reads it only
  before it returns to text.
- No AX=1012h or other palette call: the program loads the DAC through the ports itself.

### Calls of DOS seen around the runs (not milestone programs)

| Call | Input | From |
| --- | --- | --- |
| AH=0Fh, AH=0Bh BH=00h BL=00h, AH=06h AL=00h BH=07h CX=0000h DX=184Fh, AH=0Fh | | presumably `CLS` before and after each program (from the top of conventional memory, where COMMAND.COM's transient part lies) |
| AH=0Fh, AH=01h CX=0D0Eh | | before each prompt, from a program loaded high (presumably DOSKEY) |
| AX=4F03h, AH=0Fh | | S3REGS, the snapshots before and after each run |

These belong to milestone 2's contract once it is recorded: CLS needs AH=06h's whole-screen clear and
AH=0Bh's border colour, and the prompt AH=01h's cursor shape (with cursor emulation, B01-4).

## The run (dirty side only)

- **The card:** VGALOG's chip block reads CR2D-CR30 = 88h 11h 54h E1h. CR2F bit 6 is set, so the card
  is a Trio64V+ (86C765), not the DSP-3364P the milestones are judged on. Other details from the block:
  - CR36 = 92h;
  - a 64-block (32 KB) ROM;
  - SR10/SR11 = 41h/28h;
  - the ROM version is our 1.03-08N-p5.

  The calls a program makes do not depend on the chip, as long as the BIOS answers the same. The two
  benchmarks make the same calls on the Trio64 and the Trio64V+, so this record is not repeated on the
  DSP-3364P (the owner's decision, 2 November 2026).
- **The files:** `M3.BIN` (39 calls) and `M4.BIN` (89 calls), both `VGALOGM2`. M4 was dumped without
  unloading VGALOG, so its first 39 calls are those of M3. A third file, `S3REGS.TXT`, holds the
  snapshots before and after each benchmark. Their TICK values (17FB8Ch, 17FDAEh, 47h, 4FEh) match the
  low words of the 4F03h calls in the logs (FB8Ch, FDAEh, 0047h, 04FEh), which marks where each run
  starts and ends:

  | Calls | Ticks | Program |
  | --- | --- | --- |
  | M3 23-29 | FC5Ah-FCB7h | Superscape 3D Bench, about 5 s |
  | M4 52-59 | 00A5h-017Ch | Chris's 3D Benchmark, 320x200, about 12 s |
  | M4 64-79 | 023Dh-0411h | Chris's 3D Benchmark, 640x480 VESA, about 26 s |
- **What our ROM answered:**
  - every call returned without CF;
  - 4F00h/4F01h/4F02h returned AX = 004Fh;
  - 4F02h BX=0101h left CR58 = 90h (linear addressing on with a 64 KB window at A0000h: the booster of
    our ROMs); after the return to mode 03h it is 83h again;
  - AH=0Fh in mode 101h returned AL = 69h (S3's internal mode number).

  None of this is a requirement for the clean ROM.
- **The ES the logged 4F00h/4F01h calls carry is 0000h** (ES:DI = 0000:D670h), and the calls returned
  004Fh. In the `/W` run below it was 2000:7F40h, so the buffer moves between runs. The clean ROM writes
  where ES:DI points, as VBE says, whatever the segment.
- **The program:** `SVGABNCH.EXE` is a DJGPP program (protected mode under CWSDPMI) with Allegro's
  graphics drivers; its symbol table names them. It tries them in this order: VGA, VESA 2.0 linear,
  VESA 2.0 banked, Cirrus 54xx, S3, ET4000, VESA 1.x. The two VBE 2.0 drivers fail on a VBE 1.2 BIOS
  after 4F00h and the 4F01h search; the S3 driver finds the chip by the CR35 lock test, sets mode 101h
  through VBE (4F00h, 4F01h 100h and 101h, 4F02h: the third round of calls in the log) and then
  switches banks with the routine `__s3_bank` (the four writes above, from protected mode). Its VESA
  1.x driver would switch banks through DPMI 0300h (a simulated INT 10h 4F05h), which VGALOG would log;
  the log has none, which agrees. Read from the disassembly of the program (objdump), not from any
  BIOS.
- **The port trace run (`VGALOG /P`, DSP-3364P, 1.5-07-p5, 2 November 2026):** 2926 events, the 4F02h
  101h of the BIOS among them, but none of the program: the trace ends where CWSDPMI switches back to
  protected mode after the 4F02h, as VGALOG /P is built to do, and the program's own port writes run
  in protected mode, where VGALOG does not see them. The bank routine above comes from the program's
  code instead.
- **The window function run (`VGALOG /W`, DSP-3364P, 2 November 2026):** the chip block reads
  CR2D-CR30 = 88h 11h 20h E1h (Trio64), CR36 = 8Eh, SR10/SR11 = 41h/2Ch, the ROM version 1.5-07-p5.
  The header flags are 0002h (/W). VGALOG hooked the window function at C000:4CC5h (block +28), and the
  count of far calls through it (block +24) is 0. The calls of the 640x480 run are those of the table
  above (4F00h three times, 4F01h 100h and 101h twice each, 4F02h 101h, ticks 824Fh-83C8h, about 21 s),
  with no 4F05h.
- **S3REGS before and after:**
  - After both benchmarks, CR0E/CR0F (the cursor location) differ, as expected after CLS.
  - After Chris's benchmark, CR3B (the data transfer position) is 59h instead of 00h, left from mode
    101h. It has no effect in mode 03h, where CR34 bit 4 (its enable) is 0 (CR34 = 08h).
  - Nothing else changed.
