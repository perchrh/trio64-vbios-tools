#!/usr/bin/env python3
"""Build the PoC PCI option ROM from src/roms/poc/hello.asm.

Assembles hello.asm with NASM, pads the code with 00h to a 32 KB image
(ROM-3), patches the expansion ROM checksum (offset 06h) so the sum of all
image bytes is 0 mod 256, optionally writes the vendor/device IDs into the
PCI data structure, and writes the 32 KB image once at offset 0, padding the
rest of the part with FFh (ROM-4). A system BIOS that scans the whole ROM
window for 55h AAh then finds exactly one image and calls its init once -
repeating the image would make such a BIOS run both copies and beep twice.
64 KB (--pad 64, the default) or 128 KB (--pad 128) parts are the usual
sockets; --pad 32 is a 32 KB part with no padding.

A PCI 2.1 POST skips an image whose vendor/device IDs do not match the
card (PCI 2.3 section 6.3.2), so pass the card's real IDs.

Usage: build.py --nasm PATH -o OUT [--vendor 0x8086] [--device 0x1229]
                [--pad 64]
Out: a --pad KB file: the image, then FFh padding, one valid checksum.
"""
from __future__ import annotations
from typing import NoReturn

import argparse
import os
import subprocess
import sys
import tempfile

SRC = os.path.join(os.path.dirname(os.path.abspath(__file__)), "hello.asm")
IMAGE_SIZE = 32 * 1024
PAD_KB = 64


def die(msg: str) -> NoReturn:
    sys.exit("build.py: " + msg)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--nasm", default="nasm", help="NASM 3.02 binary")
    ap.add_argument("-o", "--out", required=True, help="output file (64 KB)")
    ap.add_argument("--vendor", help="vendor ID to write (hex, e.g. 0x8086)")
    ap.add_argument("--device", help="device ID to write (hex, e.g. 0x1229)")
    ap.add_argument("--pad", type=int, default=PAD_KB,
                    help="pad the image with FFh to this file size in KB: 64 for a"
                         " 64 KB EEPROM (the default), 128 for a 128 KB EEPROM,"
                         " 32 for a 32 KB part with no padding")
    args = ap.parse_args()
    if args.pad < IMAGE_SIZE // 1024 or args.pad % (IMAGE_SIZE // 1024):
        die("--pad must be a multiple of %d KB (32, 64, 128, ...)"
            % (IMAGE_SIZE // 1024))

    with tempfile.TemporaryDirectory() as td:
        binfile = os.path.join(td, "hello.bin")
        r = subprocess.run([args.nasm, "-f", "bin", "-o", binfile, SRC])
        if r.returncode:
            die("NASM failed with exit code %d" % r.returncode)
        with open(binfile, "rb") as f:
            rom = bytearray(f.read())

    if len(rom) > IMAGE_SIZE:
        die("assembled code is %d bytes, larger than the %d byte image"
            % (len(rom), IMAGE_SIZE))
    if rom[0] != 0x55 or rom[1] != 0xAA:
        die("assembled code does not start with the 55h AAh signature")
    rom += b"\x00" * (IMAGE_SIZE - len(rom))    # pad to 32 KB with 00h (ROM-3)
    rom[2] = IMAGE_SIZE // 512                  # Initialization Size, 512-byte units
    pcir_off = pcir(rom)                         # the pointer at 18h must resolve

    if args.vendor:
        rom[pcir_off + 4:pcir_off + 6] = int(args.vendor, 16).to_bytes(2, "little")
    if args.device:
        rom[pcir_off + 6:pcir_off + 8] = int(args.device, 16).to_bytes(2, "little")

    rom[6] = (-(sum(rom) - rom[6])) & 0xFF     # checksum over the image
    if (sum(rom) & 0xFF) != 0:
        die("checksum patch failed")

    out = bytes(rom) + b"\xFF" * (args.pad * 1024 - IMAGE_SIZE)
    os.makedirs(os.path.dirname(os.path.abspath(args.out)), exist_ok=True)
    with open(args.out, "wb") as f:
        n = f.write(out)
    if n != len(out):
        die("%s: wrote %d of %d bytes" % (args.out, n, len(out)))

    if not (args.vendor and args.device):
        print("build.py: warning: vendor/device IDs are 0000h/0000h; a PCI 2.1\n"
              "POST skips an image whose IDs do not match the card (section\n"
              "6.3.2): build with --vendor and --device", file=sys.stderr)
    print("build.py: %s, %d KB, one %d KB image plus FFh padding, checksum %02Xh"
          % (args.out, len(out) // 1024, IMAGE_SIZE // 1024, rom[6]))


def pcir(rom: bytearray) -> int:
    """Offset of the PCIR structure, from the pointer at 18h-19h (PCI 2.1)."""
    off = int.from_bytes(rom[0x18:0x1A], "little")
    if rom[off:off + 4] != b"PCIR":
        die("PCIR signature not found at offset %04Xh" % off)
    if off & 3:
        die("PCIR at offset %04Xh is not DWORD aligned" % off)
    return off


if __name__ == "__main__":
    main()
