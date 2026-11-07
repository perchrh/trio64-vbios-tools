#!/usr/bin/env python3
"""Build the open PCI option ROM from src/roms/open/hello.asm.

Assembles hello.asm with NASM, pads the code with 0FFh to a 32 KB image,
patches the expansion ROM checksum (offset 06h) so the sum of all image
bytes is 0 mod 256, optionally writes the vendor/device IDs into the
legacy header and the PCIR structure, and writes the 32 KB image twice
into one 64 KB output file: a board may map either half of the EEPROM.

Usage: build.py --nasm PATH [-o OUT] [--vendor 0x8086] [--device 0x1229]
Out: a 64 KB file, two identical 32 KB images, each with a valid checksum.
"""

import argparse
import os
import subprocess
import sys
import tempfile

SRC = os.path.join(os.path.dirname(os.path.abspath(__file__)), "hello.asm")
IMAGE_SIZE = 32 * 1024
REPEATS = 2


def die(msg):
    sys.exit("build.py: " + msg)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--nasm", default="nasm", help="NASM 3.02 binary")
    ap.add_argument("-o", "--out", required=True, help="output file (64 KB)")
    ap.add_argument("--vendor", help="vendor ID to write (hex, e.g. 0x8086)")
    ap.add_argument("--device", help="device ID to write (hex, e.g. 0x1229)")
    args = ap.parse_args()

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
    rom += b"\xff" * (IMAGE_SIZE - len(rom))        # pad to 32 KB, erased EEPROM
    rom[2] = IMAGE_SIZE // 512                      # length in 512-byte units
    pcir_off = pcir(rom)                            # the pointer must resolve

    if args.vendor:
        vid = int(args.vendor, 16)
        rom[0x0A:0x0C] = vid.to_bytes(2, "little")  # legacy header
        rom[pcir_off + 4:pcir_off + 6] = vid.to_bytes(2, "little")
    if args.device:
        did = int(args.device, 16)
        rom[0x0C:0x0E] = did.to_bytes(2, "little")
        rom[pcir_off + 6:pcir_off + 8] = did.to_bytes(2, "little")

    rom[6] = (-(sum(rom) - rom[6])) & 0xFF     # checksum over the image
    if (sum(rom) & 0xFF) != 0:
        die("checksum patch failed")

    out = bytes(rom) * REPEATS
    os.makedirs(os.path.dirname(os.path.abspath(args.out)), exist_ok=True)
    with open(args.out, "wb") as f:
        f.write(out)

    print("build.py: %s, %d KB, %d x %d KB images, checksum %02Xh in each half"
          % (args.out, len(out) // 1024, REPEATS, IMAGE_SIZE // 1024, rom[6]))


def pcir(rom):
    """Offset of the PCIR structure, from the pointer at 10h."""
    off = int.from_bytes(rom[0x10:0x12], "little")
    if rom[off:off + 4] != b"PCIR":
        die("PCIR signature not found at offset %04Xh" % off)
    return off


if __name__ == "__main__":
    main()
