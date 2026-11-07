# The open PCI option ROM (`src/roms/open`)

A generic PCI option ROM for a conventional PCI card: at POST the BIOS maps
the ROM, calls the entry point at offset 3 of the image (CF=1) and the code

- prints `Hello world` on the INT 10h teletype output, then
- beeps high-low high-low on the PC speaker (1200 Hz, 600 Hz, 1200 Hz,
  600 Hz, each about 270 ms with a 110 ms gap),

and returns with CF=0 so the BIOS keeps the image. The old PCI BIOS
convention of a second call with CF=0 (run-time) is answered at once with
CF=0; nothing else hooks in. The card is not touched: the ROM works on any
conventional PCI card, a network card included, and needs no IRQ, I/O or
memory resource of its own.

## Build

```
make open-rom                      -> build/roms/open/HELLO64K.ROM
make open-rom OUT=HELLO.ROM VENDOR=0x8086 DEVICE=0x1229
```

NASM 3.02 assembles [hello.asm](../src/roms/open/hello.asm) and
[build.py](../src/roms/open/build.py) pads the code with 0FFh to a 32 KB
image, patches the expansion ROM checksum (offset 06h, the sum of all image
bytes is 0 mod 256) and writes the 32 KB image twice into one 64 KB file:
a board may map either half of its 64 KB EEPROM, so both halves must carry
a complete image. `VENDOR`/`DEVICE` (hex, optional) are written into the
legacy header and the PCIR structure; without them both stay 0000h, which
every BIOS tested accepts for an add-in ROM.

## Flashing

The 64 KB output file goes into the EEPROM as is. The 32 KB image is
self-contained in either half: signature 55h AAh, length byte 40h (32 KB),
checksum at 06h, init entry at 03h, PCIR structure with code type 0 (Intel
x86, PC-AT compatible) and the last-image indicator set.

## What the code relies on

- The BIOS calls the ROM's init entry in real mode with AX = bus number in
  AH and device/function in AL (PCI Firmware Specification), CF=1, and
  expects a far return with CF=0 on success. All registers are preserved.
- INT 10h AH=0Eh (teletype output) is available: PCI option ROMs run after
  the video BIOS has initialized the card.
- INT 1Ah AH=00h (time-of-day tick read) for the beep timing, and PIT
  channel 2 with the speaker gate in port 61h for the tones; port 61h is
  restored as found.
