# Trio32/Trio64 data book: updating display memory, the Graphics Engine, rectangle fill (extract)

Source: S3 Trio32/Trio64 Integrated Graphics Accelerators, March 1995,
[`datasheets/s3/pdf/358_357_86c732-86c764_trio32_64.pdf`](../../../datasheets/s3/pdf/358_357_86c732-86c764_trio32_64.pdf)
(sections 6.1, 7.4, 13, 13.1, 13.3.3, register 9AE8h; the second scan
`trio32-trio64-graphics-accelerators-mar1995.pdf` has the same text). Used for
[`docs/chip-rules.md`](../chip-rules.md) ENG-2, ENG-3, ENG-4 and
[`docs/cleanroom/spec-b-modeset.md`](spec-b-modeset.md) MODE-151: clearing video memory
with the graphics engine at a mode set.

ASCII transcription (the scan's OCR errors lightly corrected). Prefer the PDF on any
conflict.

## Section 13, introduction: two ways to update the bitmap

While in Enhanced mode, the display memory bit map can be updated in two ways. One is to
have the CPU write directly to memory. (This is also possible in non-Enhanced modes via
paging.) The other is to have the CPU issue commands to the Graphics Engine, which then
controls pixel updating.

## 13.1: engine transfers are expected to be faster; busy flag

Linear addressing is useful when software requires direct access to display memory. In
general, large image transfers to display memory can be performed faster using the Graphics
Engine and memory-mapped I/O transfers.

The Graphics Engine busy flag, bit 9 of 9AE8H, should be verified to be 0 (not busy) before
linear addressing is enabled by setting bit 4 of CR58 or bit 4 of 4AE8H to 1.

## 13.3.3, register 9AE8h: the rectangle fill command

Bits 15-13, CMD-TYPE, select the command type:

0010 = Rectangle Fill. The position, width and height of a rectangle are defined. The
rectangle is filled with a solid color.

## Who crosses the PCI bus: Fig 1-1, section 6.1, section 7.4

Figure 1-1 (PCI Bus System Block Diagram) shows the CPU on the PCI bus and the display
memory behind the chip; section 6.1 (PCI bus cycles) describes the CPU-initiated accesses
over that bus. Section 7.4 lists the two sources into the display FIFO: "CPU accesses" and
"Graphics Engine accesses", both inside the chip on the way to memory. So a CPU write is a
PCI memory cycle (one per store); a graphics-engine write is not: the engine is inside the
chip and reaches display memory through the same FIFO the display uses.
