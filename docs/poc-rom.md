# The PoC PCI option ROM (`src/roms/poc`)

A generic PCI option ROM for a conventional PCI card, built to the PCI 2.1
expansion ROM rules (the project's rules [ROM-1 to ROM-4 and ROM-6 in
spec-a-post.md](cleanroom/spec-a-post.md), from PCI Local Bus Specification
2.1/2.3 section 6.3, extract
[pci-2.3-section-6.3.md](cleanroom/primary-extracts/pci-2.3-section-6.3.md)):
at POST the BIOS maps the ROM, copies the image to RAM and far-calls the
entry point at offset 3, and the code

- prints `Hello world` on the INT 10h teletype output, then
- beeps high-low high-low on the PC speaker (1200 Hz, 600 Hz, 1200 Hz,
  600 Hz, each about 275 ms with a 110 ms gap),

and returns with CF=0. The old PCI BIOS convention of a second call with
CF=0 (run-time) is answered at once with CF=0; nothing else hooks in. The
card is not touched: the ROM works on any conventional PCI card, a network
card included, and needs no IRQ, I/O or memory resource of its own.

## Build

```
make poc-rom                      -> build/roms/poc/HELLO64K.ROM (64 KB)
make poc-rom OUT=HELLO.ROM VENDOR=0x8086 DEVICE=0x1229
make poc-rom OUT=HELLO.ROM REPEATS=4 VENDOR=0x10EC DEVICE=0x8139   (128 KB)
```

NASM 3.02 assembles [hello.asm](../src/roms/poc/hello.asm) and
[build.py](../src/roms/poc/build.py) pads the code with 00h to a 32 KB
image (ROM-3), patches the expansion ROM checksum (offset 06h, the sum of
all image bytes is 0 mod 256) and writes the 32 KB image REPEATS times
into one output file (ROM-4): a board may map any 32 KB-aligned half or
quarter of its EEPROM, so every 32 KB block must carry a complete image.
REPEATS is 2 for a 64 KB part (the default) or 4 for a 128 KB part; the
usual 32-pin DIP sockets on network cards (3C905B, RTL8139D) decode up to
128 KB.

**Build with the card's IDs.** A PCI 2.1 POST skips an image whose vendor
and device IDs do not match the card's configuration space (section 6.3.2),
so pass the card's real IDs with `VENDOR` and `DEVICE` (hex); build.py warns
when they stay 0000h.

## The image

- Expansion ROM header (ROM-1): signature 55h AAh, Initialization Size 40h
  (32 KB) at offset 02h, the init entry jump at 03h, checksum at 06h, and
  the pointer to the PCI data structure at 18h-19h (PCI 2.1 moved it from
  the old 10h).
- PCI data structure (ROM-2), DWORD aligned: signature `PCIR`, the
  vendor/device IDs, structure length 0018h, structure revision 00h (PCI
  2.1), class code 000000h, image length 0040h, code type 00h (Intel x86,
  PC-AT compatible), indicator 80h (last image).
- The image is never modified by the init code (ROM-6).

## Flashing

The output file goes into the EEPROM as is (64 KB, or 128 KB with
REPEATS=4). The 32 KB image is self-contained in every 32 KB block of the
part.

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
  from PIT channel 2; port 61h is restored as found.
