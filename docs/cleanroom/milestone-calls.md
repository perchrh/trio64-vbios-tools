# The INT 10h calls of the milestone programs (card record of 2 November 2026)

What the programs of milestones 3 and 4 ask of the video BIOS
([`docs/clean-room.md`](../clean-room.md) "Decisions of 2 November 2026", [#145](https://github.com/perchrh/trio64-vbios-tools/issues/145)), recorded on a card with VGALOG
in memory mode. The first part, "The contract", lists the calls as the programs make them: inputs only, and
what the standards say they must return. It crosses to the clean side after the leak review. The second part,
"The run", holds the provenance and what our ROM answered. It stays on the dirty side.

Milestone 2 is recorded for MS-DOS EDIT (below). Owner policy M2-BOOT
([`decisions-milestones-1-4.md`](decisions-milestones-1-4.md)): acceptance boots without `CONFIG.SYS` /
`AUTOEXEC.BAT` and with an empty PATH, so shell surround (CLS, DOSKEY, ...) is out of the contract.

## The contract (crosses after the leak review)

Partial black-box call observations for milestones 2-4, with required outputs from the cited public
interfaces. Counts and caller ordering describe those observations; they do not prescribe the BIOS's
internal implementation order. OBS-EDIT, OBS-M3, OBS-M4-320 and OBS-M4-640 mean the recorded card
runs of 2 November 2026 (inputs and counts only). The logger omitted AH=02h, 03h, 08h, 09h, 0Ah,
0Ch, 0Dh, 0Eh and 13h; it does not see direct port writes unless `/P` or `/W` is used as noted.

Owner policy for 100h and AH=0Fh after 101h:
[`decisions-milestones-1-4.md`](decisions-milestones-1-4.md).

### Milestone 2: MS-DOS 6.22 EDIT

EDIT started, used and left (no mode set). Text itself may go to B800h or through omitted text APIs.

| Call | Input | Count | What the program needs | Source |
| --- | --- | --- | --- | --- |
| AX=1A00h | | 1 | AL=1Ah when supported; BL=08h for analogue-colour VGA | OBS-EDIT; VGADOC/RBIL AX=1A00h |
| AH=0Fh | | 1 | current mode (03h, 80 columns) | OBS-EDIT; VGADOC/RBIL AH=0Fh |
| AX=1130h | BH=00h | 1 | font info: CX bytes/char, DL=rows-1; ES:BP INT 1Fh | OBS-EDIT; VGADOC/RBIL AX=1130h |
| AX=1003h | BL=00h | 1 | blink off | OBS-EDIT; VGADOC/RBIL AX=1003h |
| AH=01h | CX=2000h | 9 | cursor off (CH bit 5) | OBS-EDIT; VGADOC/RBIL AH=01h |
| AH=01h | CX=0607h | 6 | cursor shape lines 6-7 (with cursor emulation, B01-4) | OBS-EDIT; B01-4 |
| AX=1003h | BL=01h | 1 | blink on at exit | OBS-EDIT; VGADOC/RBIL AX=1003h |
| AH=01h | CX=0D0Eh | 1 | cursor shape lines 13-14 at exit | OBS-EDIT; VGADOC/RBIL AH=01h |

Some BIOSes are called with AL=current mode on AH=01h; the clean ROM ignores AL in AH=01h.

### Milestone 3: Superscape 3D Bench 1.0c

| Call | Input | Count | What the program needs | Source |
| --- | --- | --- | --- | --- |
| AH=00h | AL=13h | 1 | mode 13h, 320x200x256, screen cleared | OBS-M3; VGADOC/RBIL AH=00h |
| AX=1012h | BX=0, CX=0100h, ES:DX=table | 5 | DAC block load of 256 entries | OBS-M3; B1012 |
| AH=00h | AL=03h | 1 | back to 80x25 text | OBS-M3; VGADOC/RBIL AH=00h |

No VBE INT 10h call was recorded. Logger limits prevent treating this as exhaustive.

### Milestone 4: Chris's 3D Benchmark

320x200 run:

| Call | Input | Count | What the program needs | Source |
| --- | --- | --- | --- | --- |
| AX=1A00h | | 1 | display combination; BL=08h for analogue-colour VGA | OBS-M4-320; VGADOC/RBIL AX=1A00h |
| AH=00h | AL=03h | 2 | 80x25 text | OBS-M4-320; VGADOC/RBIL AH=00h |
| AH=12h BL=34h | AL=00h | 1 | cursor emulation on; AL=12h back | OBS-M4-320; VGADOC/RBIL AH=12h BL=34h |
| AH=00h | AL=13h | 1 | mode 13h | OBS-M4-320; VGADOC/RBIL AH=00h |
| AH=00h | AL=03h | 2 | back to text | OBS-M4-320 |
| AH=12h BL=34h | AL=00h | 1 | cursor emulation on | OBS-M4-320 |

640x480 VESA run:

| Call | Input | Count | What the program needs | Source |
| --- | --- | --- | --- | --- |
| AX=1A00h; AH=00h AL=03h; AH=12h BL=34h | as above | 1 each | as above | OBS-M4-640 |
| AH=0Fh | | 1 | current text mode | OBS-M4-640; VGADOC/RBIL AH=0Fh |
| AX=4F00h | ES:DI=256-byte buffer | 3 | VBE information block; AX=004Fh | OBS-M4-640; VBE 1.2 6.1/6.2 |
| AX=4F01h | CX=0100h then 0101h | 2 each | mode info; AX=004Fh; see Q100 for 100h support bit | OBS-M4-640; VBE 1.2; decisions Q100 |
| AX=4F02h | BX=0101h | 1 | set 101h banked, memory cleared (bit 15 clear); AX=004Fh | OBS-M4-640; VBE 1.2 |
| AH=0Fh | | 1 | after 101h; AL policy is Q0F (no private 69h) | OBS-M4-640; decisions Q0F |
| AH=00h | AL=03h | 2 | back to text | OBS-M4-640 |
| AH=12h BL=34h | AL=00h | 1 | cursor emulation on | OBS-M4-640 |

What follows for the clean ROM:
- **VESA mode 101h** is settable. **100h** is queryable with truthful geometry; ModeAttributes D0
  clear so it is not settable in milestones 1-4 ([`decisions-milestones-1-4.md`](decisions-milestones-1-4.md)).
- **Banking:** no INT 10h 4F05h and no WinFuncPtr far call were observed during drawing (`VGALOG /W`).
  The program banks through CR35 from protected mode (program observation; details in The run). After
  4F02h 101h the clean ROM must leave CR6A=00h, CR51 bits 3-2=0, and a CR31 mapping where bits 0 and 3
  select 64 KB pages (spec C). 4F01h window fields and WinFuncPtr must still be truthful.
- **AH=0Fh after 101h:** project restorable extended-mode number; not S3 `69h` (Q0F).
- No BIOS palette call was logged; absence of a port trace does not prove direct DAC writes.

### Milestone 2 boot policy (no shell surround)

Acceptance for milestone 2 boots MS-DOS 6.22 with **no** `CONFIG.SYS`, **no** `AUTOEXEC.BAT`, and an
**empty PATH** (M2-BOOT). The clean contract is the EDIT table above only. Observed CLS / DOSKEY-like
calls from richer shells are dirty-side notes only and do not cross. Cut S3REGS AX=4F03h
instrumentation from the clean contract.

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
