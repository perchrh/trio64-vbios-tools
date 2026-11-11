# Trio64V+ data book DB018-A, section 15.2: video memory access through the Graphics Engine (extract)

Source: S3 Trio64V+ Integrated Graphics/Video Accelerator, DB018-A, July 1995,
[`datasheets/s3/pdf/db018-a-trio64v-integrated-graphics-video-accelerator-jul95.pdf`](../../../datasheets/s3/pdf/db018-a-trio64v-integrated-graphics-video-accelerator-jul95.pdf)
(section 15.2). The Trio64V2 and Trio64UV+ books describe only their differences from the
Trio64V+, so this section applies to them too. Used for
[`docs/chip-rules.md`](../chip-rules.md) ENG-2, ENG-4 and
[`docs/cleanroom/spec-b-modeset.md`](spec-b-modeset.md) MODE-151.

ASCII transcription (the scan's OCR errors lightly corrected). Prefer the PDF on any
conflict.

## 15.2 Video memory access through the Graphics Engine

When updating the display bitmap through the Graphics Engine, all CPU data moves through
the Pixel Data Transfer registers (E2E8H and E2EAH). These can be memory mapped as
explained in Memory Mapping of Enhanced Mode Registers later in this section.

The Graphics Engine manipulates the bits for each pixel to assign a color index or true
color value, which is then translated via a programmable RAMDAC before being displayed on
a CRT. ... The Trio64V+ can manipulate 64 bits each clock cycle, from two 32-bit pixels to
eight 8-bit pixels.

So for a fill the CPU sends the drawing command and one colour value; the engine writes
every pixel of the rectangle to display memory itself (section 13 of the Trio32/Trio64
book describes the same two paths and the rectangle fill command 0010b in 9AE8h; extract
[`trio32-64-enhanced-mode-graphics-engine.md`](trio32-64-enhanced-mode-graphics-engine.md)).
The engine is inside the chip, so these writes do not cross the PCI bus; only CPU writes do
(Trio32/Trio64 book, Fig 1-1 and section 6.1).
