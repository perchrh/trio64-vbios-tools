# Trio64V+ data book DB018-A, section 16.2: the SR8 lock on the extended sequencer registers (extract)

Source: S3 Trio64V+ Integrated Graphics/Video Accelerator, DB018-A, July 1995,
[`datasheets/s3/pdf/db018-a-trio64v-integrated-graphics-video-accelerator-jul95.pdf`](../../../datasheets/s3/pdf/db018-a-trio64v-integrated-graphics-video-accelerator-jul95.pdf)
(section 16.2, "Unlock Extended Sequencer Register (SR8)", page 16-9). The Trio64V2 book
describes only its differences from the Trio64V+, and the Trio64UV+ (Aurora64V+) book states
the wider range SR9 - SR6F for the same register, so the rule applies to all three. Used for
[`docs/chip-rules.md`](../chip-rules.md) REG-4 and the lock rows of
[`docs/cleanroom/spec-a-post.md`](spec-a-post.md) (POST-3, POST-8, CONV-8) and
[`docs/cleanroom/spec-b-modeset.md`](spec-b-modeset.md) (MODE-139, the VCLK term).

ASCII transcription (the scan's OCR errors lightly corrected). Prefer the PDF on any
conflict.

## 16.2 Sequencer registers

The sequencer registers are located at two-byte address spaces. These registers are accessed
by first writing the data to the index register of the sequencer at I/O address 3C4H and then
writing to or reading from the data register at 3C5H. A word write of both address and data at
3C4H can also be performed.

## Unlock Extended Sequencer Register (SR8)

Read/Write
Power-On Default: 00H
Address: 3C5H, Index 08H

Loading xxxx0110b (e.g., 06H) unlocks accessing of all the S3 extensions (SR9 - SR1C) to the
standard VGA Sequencer register set. (x = don't care).
