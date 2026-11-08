# The PoC PCI option ROM (`src/roms/poc`)

A generic PCI option ROM for a conventional PCI card, built to the PCI 2.1
expansion ROM rules (the project's rules [ROM-1 to ROM-4 and ROM-6 in
spec-a-post.md](cleanroom/spec-a-post.md), from PCI Local Bus Specification
2.1/2.3 section 6.3, extract
[pci-2.3-section-6.3.md](cleanroom/primary-extracts/pci-2.3-section-6.3.md)).

The PoC intentionally contains no VGA code: no mode set, no INT 10h hook,
no register of any card. Its only purpose is to prove that we can build a
generic PCI option ROM - a valid image that the system BIOS maps, copies,
calls and keeps - before any real device support goes into one.

At POST the BIOS maps the ROM, copies the image to RAM and far-calls the
entry point at offset 3, and the code

- prints `Hello world` on the INT 10h teletype output, then
- beeps high-low high-low on the PC speaker (1200 Hz, 600 Hz, 1200 Hz,
  600 Hz, each about 275 ms with a 110 ms gap),

and returns with CF=0. The entry does not test CF: not every system BIOS
sets CF=1 for the init call (the emulator starts a ROM with CF=0, and so do
BIOSes without the old PCI BIOS double call), so the work runs on the first
call whatever CF says.

The beep sounds exactly once per machine. Two guards: the part carries the
32 KB image once and FFh after it, so a BIOS that scans the ROM window for
55h AAh finds one image only; and the done flag lives at 0040:00FFh in the
BIOS data area (the inter-application communication area), which all
shadow copies share, so a second call of the entry (CF=1 init, CF=0
run-time, the old PCI BIOS convention) also returns at once. The image
itself is never written - the port 61h value is kept on the stack - so the
image sum stays 00h (ROM-6). The card is not touched: the ROM works on any
conventional PCI card, a network card included, and needs no IRQ, I/O or
memory resource of its own.

## Build

```
make poc-rom                      -> build/roms/poc/HELLO64K.ROM (POC_PAD=64, the default)
make poc-rom POC_PAD=128           -> build/roms/poc/HELLO128K.ROM (128 KB)
make poc-rom POC_PAD=128 POC_OFFSET=96 -> build/roms/poc/HELLO128K.ROM (image in the last 32 KB)
make poc-rom VENDOR=0x10B7 DEVICE=0x9055                  (3C905B-TX, 64 KB)
make poc-rom OUT=HELLO.ROM POC_PAD=128 VENDOR=0x10EC DEVICE=0x8139   (RTL8139D, 128 KB)
```

The 3C905B-TX line above is the verified example: the card reports vendor
10B7h, device 9055h (subsystem 9055h:10B7h, revision 24h, none of which the
image uses), its 32-pin DIP socket decodes up to 128 KB, and the build writes
the 32 KB image once and pads the 64 KB part with FFh. The subsystem ID and the chip
revision do not go into the image: a PCI 2.1 POST matches only the
vendor/device IDs.

NASM 3.02 assembles [hello.asm](../src/roms/poc/hello.asm) and
[build.py](../src/roms/poc/build.py) pads the code with 00h to a 32 KB
image (ROM-3), patches the expansion ROM checksum (offset 06h, the sum of
all image bytes is 0 mod 256) and writes the image once at offset 0,
padding the rest of the part with FFh (ROM-4). A system BIOS that scans the
whole ROM window for 55h AAh then finds exactly one image and calls its
init once; repeating the image instead made such a BIOS run both copies
and beep twice (measured before the change). PAD is the file size in
KB: 64 for a 64 KB part (the default), 128 for a 128 KB part, 32 for a
32 KB part; the usual 32-pin DIP sockets on network cards (3C905B,
RTL8139D) decode up to 128 KB. OFFSET (KB, a multiple of 32) places the
image at that offset instead of 0, with FFh before it.

**Build with the card's IDs.** A PCI 2.1 POST skips an image whose vendor
and device IDs do not match the card's configuration space (section 6.3.2),
so pass the card's real IDs with `VENDOR` and `DEVICE` (hex); build.py warns
when they stay 0000h. The IDs come from the card itself: `lspci -nn` on
Linux, the Device Manager's hardware IDs on Windows, a PCI list utility in
DOS, or the BIOS' own PCI device listing at POST.

## The image

- Expansion ROM header (ROM-1): signature 55h AAh, Initialization Size 40h
  (32 KB) at offset 02h, the init entry jump at 03h, checksum at 06h, and
  the pointer to the PCI data structure at 18h-19h (PCI 2.1 moved it from
  the old 10h).
- PCI data structure (ROM-2), DWORD aligned: signature `PCIR`, the
  vendor/device IDs, structure length 0018h, structure revision 00h (PCI
  2.1), class code 000000h, image length 0040h, code type 00h (Intel x86,
  PC-AT compatible), indicator 80h (last image).
- The image is never modified by the init code (ROM-6); the once-per-machine
  done flag is at 0040:00FFh, outside the image.

## Flashing

The output file goes into the EEPROM as is (64 KB, or 128 KB with
POC_PAD=128): the 32 KB image at offset 0, FFh after it. A board that maps
the upper half of the part sees no ROM there - the image is meant to sit
at the base of the mapped window.

**The image goes in the first 32 KB** of the file, and the file should not
be larger than the part: a file larger than the part wraps around when
flashed and its last blocks overwrite the image. A board that maps the
upper block of its decode window instead of the base is the exception
(the ExpertColor DSP-3364P Trio64 does this, [#78](https://github.com/perchrh/trio64-vbios-tools/issues/78));
for such a board build `POC_OFFSET` so the image lands in the block the
board maps. Do not repeat the image instead: a BIOS that scans the whole
ROM window runs every copy.

The 3C905B-TX (W27C010, 128 KB) first looked like a mapping problem: a
128 KB file with the image at offset 0 printed and beeped nothing, while
an older ROM with the image four times worked. The real cause was the
done flag, read at 0000:00FFh (INT 3Fh's vector byte, nonzero on a real
machine) instead of 0040:00FFh, so the init returned at once - the image
at offset 0 works on that card (measured, November 2026).

## In the emulator

`python3 emu/poc_test.py` runs the image in the project's emulator
([emu/vgaemu.py](../emu/vgaemu.py)), the way the other ROMs run: the Machine
loads the image at C0000 and `post()` far-calls C000:0003 like a system BIOS
(with CF clear). The PoC has no VGA code, so INT 10h stays the emulator's
IRET stub and nothing appears on a screen; the run shows the ROM returning
to the far call, 13 INT 10h teletype calls (`Hello world` plus CR/LF), a hold
of about 1 s (18 PIT wraps) after the about 1.5 s of beeps, so the text
stays up for about 2.5 s in all, the
divisors 03E2h/07C5h/03E2h/07C5h (1200/600/1200/600 Hz) programmed into PIT
channel 2, four speaker-gate on/off pairs at port 61h, the image sum still
00h after POST, and a second init call returning at once with no new tones
(the done flag at 0040:00FFh; the same holds when a second copy of the
image is shadowed and called, which `poc_test.py` also checks via a manual
far call). The control word 0xB6 is written to port 43h before
each count, the order the 8254 requires. The experiment is what found the
subtleties above: the emulator calls with CF=0 (the CF test had to go), and
its constant clock advance makes the latched count return to exactly the
same value each wrap, which the wrap test must treat as "not below" (`jb`,
not `jbe`) so a wait can never hang on a PIT that stopped counting.

## What the code relies on

- The BIOS calls the ROM's init entry in real mode with AX = bus number in
  AH and device/function in AL (section 6.3.3.1.2), CF=1, and expects a far
  return with CF=0 on success. All registers are preserved.
- INT 10h AH=0Eh (teletype output) is available: PCI option ROMs run after
  the video BIOS has initialized the card.
- The beep timing latch-reads PIT channel 0 (the counter latch command only;
  the channel is never reprogrammed) and needs no interrupt and no BIOS
  tick, because the system BIOS may call the ROM with interrupts off
  (CONV-6 in [spec-a-post.md](cleanroom/spec-a-post.md)). The tones come
  from PIT channel 2: the control word 0xB6 goes to port 43h first, then the
  divisor's two bytes to port 42h; port 61h is restored as found.
