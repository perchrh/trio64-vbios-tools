# PCI Local Bus 2.3 section 6.3: Expansion ROMs (extract)

Source: PCI Local Bus Specification, Revision 2.3,
[`standards/pci/pci23.pdf`](../../../standards/pci/pci23.pdf), section 6.3
(document pages 209-216; PDF pages 223-230 of that file). Used for part A
ROM-1 to ROM-6 and POST-1.

ASCII paraphrase of the expansion-ROM rules the clean ROM must satisfy.
Prefer the PDF on any conflict. Subsection numbers match revision 2.1 for
6.3.1.1, 6.3.1.2 and 6.3.3.1.

## 6.3 layout (pages 209-210)

- A PCI device may publish expansion ROM code for device-specific
  initialisation and, possibly, a system boot function.
- The ROM may hold several images for different machine and processor
  architectures. Each image starts on a 512-byte boundary and carries a
  PCI expansion ROM header. The last image is marked in its header.
- Devices that support an expansion ROM must allow the ROM to be accessed
  with any combination of byte enables (DWORD accesses included).
- PCI expansion ROM code is never executed in place: it is always copied
  from the ROM device to RAM and run from RAM.

## 6.3.1.1 ROM header (page 211)

Offset is from the start of the image. Lengths are in bytes.

| Offset | Length | Value / field |
| --- | --- | --- |
| 0h | 1 | 55h (ROM Signature, byte 1) |
| 1h | 1 | AAh (ROM Signature, byte 2) |
| 2h-17h | 16h | Reserved (processor architecture unique) |
| 18h-19h | 2 | Pointer to PCI Data Structure (little-endian; from image start) |

The signature `55h AAh` must be the first two bytes of each image.

## 6.3.1.2 PCI Data Structure (pages 212-213)

Must sit in the first 64 KB of the image and be DWORD aligned.

| Offset | Length | Field |
| --- | --- | --- |
| 0 | 4 | Signature `"PCIR"` (`P` at 0, `C` at 1, ...) |
| 4 | 2 | Vendor Identification (same meaning as Configuration Space) |
| 6 | 2 | Device Identification (same meaning as Configuration Space) |
| 8 | 2 | Reserved (was Vital Product Data pointer in earlier revisions) |
| A | 2 | PCI Data Structure Length (bytes, little-endian, from Signature) |
| C | 1 | PCI Data Structure Revision (this revision level is 0) |
| D | 3 | Class Code (same as Configuration Space) |
| 10 | 2 | Image Length (little-endian, units of 512 bytes) |
| 12 | 2 | Revision Level of code/data |
| 14 | 1 | Code Type |
| 15 | 1 | Indicator |
| 16 | 2 | Reserved |

Code Type values of interest: `0` = Intel x86, PC-AT compatible;
`1` = Open Firmware; `2` = HP PA-RISC; `3` = EFI; `4`-`FFh` reserved.

Indicator bit 7 = 1 means this is the last image; bit 7 = 0 means another
image follows. Bits 0-6 are reserved.

## 6.3.2 POST search (page 213)

1. See whether the device implements an Expansion ROM Base Address register.
2. If so, map and enable the ROM and check the first two bytes for `AA55h`
   (55h then AAh).
3. Search images for the proper Code Type whose Vendor ID and Device ID
   match the device.
4. Copy the appropriate amount into RAM and run the device's initialisation
   code (how much, and how, depends on Code Type).

## 6.3.3.1 PC-compatible header extensions (page 214)

For Code Type 0 (Intel x86, PC-AT compatible) the header adds:

| Offset | Length | Field |
| --- | --- | --- |
| 2h | 1 | Initialization Size (code size in units of 512 bytes) |
| 3h | 3 | Entry point for the INIT function (POST does a FAR CALL here) |
| 6h-17h | 12h | Reserved (application unique) |
| 18h-19h | 2 | Pointer to PCI Data Structure |

POST steps for each such image: map and enable the ROM; find the proper
image and copy Initialization Size bytes into the compatibility area
(typically 0C0000h-0DFFFFh); disable the Expansion ROM Base Address
register; leave that RAM writable and call INIT; then use the (possibly
modified) byte at offset 02h as the runtime size. Before system boot,
make that RAM read-only. A VGA device's expansion BIOS must be copied to
0C0000h (Class Code identifies VGA).

## 6.3.3.1.2 INIT function extensions (page 215)

- While INIT runs, the RAM copy stays writable. INIT may store static
  parameters there for later runtime use (that area is not writable at
  runtime).
- INIT may shrink the runtime footprint by writing a smaller size into
  offset 02h. Example in the spec: 24 KB image copied for init, then size
  byte set to 8 KB for runtime.
- If INIT changes the RAM image, it must leave a correct checksum over the
  size at offset 02h. To remove itself entirely, write zero to offset 02h
  (no checksum needed then).
- INIT must not modify other system memory unless it uses an appropriate
  allocation protocol or BIOS service.
- On entry, INIT receives the device's PCI address: AH = bus number; AL
  bits 7-3 = device number; AL bits 2-0 = function number. POST has already
  allocated resources through the Base Address and Interrupt Line registers.

## 6.3.3.1.3 Image lengths (pages 215-216)

Three lengths: image length >= initialization length >= runtime length.
POST copies the initialization length into RAM before INIT; that copy must
checksum to 0. The runtime length is what remains after INIT; it must also
checksum to 0. The PCI Data Structure must lie in the runtime portion if
any runtime remains, otherwise in the initialization portion.
