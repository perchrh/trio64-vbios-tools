# VGALOG.BIN - the log files of VGALOG.COM

[VGALOG.COM](../src/tools/vgalog/vgalog.asm) logs the INT 10h calls of any program to
VGALOG.BIN in the current directory, either straight to the file (default install) or
into a memory ring dumped with `/D` (memory mode `/M`, `/T`, `/P`, `/W`, for Windows 9x
and for runs that may hang). This document describes the file formats. The header
comment of [src/tools/vgalog/vgalog.asm](../src/tools/vgalog/vgalog.asm) is the
authoritative format description; this file mirrors it. The emulator tests
(`vgalog*` in [emu/tests.py](../emu/tests.py)) parse the files and are the executable
check of this document.

What is logged: in file mode the mode sets INT 10h AH=00h and the VBE calls 4F01h,
4F02h and 4F06h. In memory mode every INT 10h call except the nine text and pixel
functions AH=02h, 03h, 08h, 09h, 0Ah, 0Ch, 0Dh, 0Eh and 13h, which would fill the
ring; those are counted instead (see the counter part below). With `/W`, far calls
through the 4F01h window function are records of their own and all of them are counted
in the chip and ROM block.

All integers are little-endian. `dd`/`dw`/`db` are 4/2/1 bytes.

## The chip and ROM block (32 bytes)

Read once when VGALOG is installed (before Windows, so not virtualised) and carried in
both kinds of file, so logs of different cards and ROMs can be told apart:

| Offset | Size | Contents |
| --- | --- | --- |
| +0 | 4 db | CR2D, CR2E, CR2F, CR30: the chip (88 11 = 86C732/764 Trio32/Trio64 or, CR2F bit 6 set, the 86C765 Trio64V+; 89 01 = 86C775/785 Trio64V2), read with the S3 registers unlocked |
| +4 | db | CR36 (memory size and type, as strapped) |
| +5 | db | ROM size in 512-byte blocks (C000:0002) |
| +6 | 2 db | SR10, SR11: the memory clock PLL the POST set |
| +8 | 16 db | the ROM version: the word after "Version" or "Vers." in C000:0000-00FFh, up to 15 characters, zero-padded |
| +24 | dd | far calls through the hooked window function in total (`/W`; 0 otherwise), written at `/D` |
| +28 | dd | the BIOS's window function (offset, segment) that `/W` hooked, at `/D` (0 when none was hooked) |

## File mode: the default install

`VGALOG.BIN` = a 16-byte header, the chip and ROM block, then the records:

- +0: `VGALOGF1` (8 bytes) + 8 zero bytes; +16: the 32-byte chip and ROM block;
  records start at offset 48.
- One record per call direction, 16 bytes, two records per call:

| Offset | Contents |
| --- | --- |
| +0 | `B` before the call, `A` after it |
| +1 | 0 |
| +2 | AX in (+4 BX, +6 CX, +8 DX in; the same in both records) |
| +10 | AX returned (`A` record only, 0 in `B`) |
| +12 | CR67, CR13, CR51, CR31 after the call (`A` only), read without unlocking the S3 registers |

A `B` record without its `A` record is the call that hung. Size = 48 + 16 bytes per
logged call.

## Memory mode: `/M` dumped with `/D`

`VGALOG.BIN` = a 48-byte header, the records, then the trace part with `/T`, then the
counter part:

- Header, 48 bytes: +0 `VGALOGM2` (8 bytes); +8 dd calls logged in total; +12 dw
  records in the file (at most the ring size, 1024, or 4096 with `/XL`); +14 dw flags
  (bit 0 = the trace part follows, bit 1 = `/W`: window function calls are logged,
  bit 2 = `/P`: the program was traced after 4F02h too); +16 the 32-byte chip and ROM
  block. The records start at offset 48, 32 bytes each, oldest first.
- (`VGALOGM1`, before 1 November 2026: no flags, no block, the records at offset 16.)
- Record:

| Offset | Contents |
| --- | --- |
| +0 | dw call number (low 16 bits of the total) |
| +2 | AX, +4 BX, +6 CX, +8 DX, +10 ES, +12 DI as the caller gave them |
| +14 | AX, +16 BX, +18 CX, +20 DX returned |
| +22 | low byte of the returned flags (bit 0 = CF) |
| +23 | nesting depth: 0 = called by a program, 1 or more = the BIOS or another handler called INT 10h from inside a call; bit 7 set = a far call through the window function, not INT 10h |
| +24 | BIOS tick (0040:006C) low word at the call |
| +26 | SR10, +27 SR11, +28 CR58, +29 CR59, +30 CR5A, +31 CR6D after the call (read with the S3 registers unlocked; SR08, CR38, CR39 and the indexes are put back) |

- A far call through the window function (`/W`) is a record of its own: +2 AX = 4F05h,
  +4 BX, +6 CX, +8 DX as the program gave them, +10 and +12 the caller's return address
  (CS, IP), +14 to +22 zero, +23 0x80 + the depth, +24 the tick, +26 to +31 zero
  (VGALOG does not see the return). Only the first 64 far calls become records; all are
  counted in the block at +24.

### The trace part (`/T`)

After the records: +0 `VGALOGT1` (8 bytes); +8 dd events in total; +12 dd events in the
file (at most 16384); then 4 bytes per event, oldest first:

| Offset | Contents |
| --- | --- |
| +0 | dw port (a marker: the call number of the record it belongs to) |
| +2 | db value (written or read) |
| +3 | db kind: bits 1-0 = 0 written (OUT, OUTS), 1 read (IN), 2 written as the high byte of a word OUT, 3 marker (a logged call starts here, +0 its call number, +2 its depth); bits 7-2 = that many more identical accesses follow (63 = 63 or more), so a polling loop takes one event |

Traced ports: 3B0h-3DFh (VGA, DAC), CF8h-CFFh (PCI configuration) and those whose bits
9-0 are 2E8h or 2EAh (the S3 graphics engine). Not traced: INS, the code of other
interrupts the BIOS calls, the high word of a 32-bit OUT.

### The counter part (always, memory mode)

At the very end of the file, after the records and the trace part: `VGALOGC1` (8 bytes),
then 9 dd: the counts of the text and pixel calls that were passed on unlogged, in the
order AH=02h, 03h, 08h, 09h, 0Ah, 0Ch, 0Dh, 0Eh, 13h (44 bytes in total). With no call
logged at all, `/D` writes no file and says "No events registered, not writing output
file" instead.

Size in memory mode = 48 + 32 bytes per logged call (+ 16 + 4 per trace event with
`/T`) + 44 for the counter part.
