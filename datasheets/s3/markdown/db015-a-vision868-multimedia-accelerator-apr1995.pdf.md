S3 Vision868 Multimedia Accelerator
53 Incorporated
Vision868
Multimedia
Accelerator
April 1995
S3 Incorporated
2770 San Tomas Expressway
Santa Clara, CA 95051-0968

II·
53 Vision868 Multimedia Accelerator
S3 Incorporated
NOTATIONAL CONVENTIONS
The following notational conventions are used in this data book:
Signal names are shown in all uppercase letters. For example, XD.
A bar over a signal name indicates an active low signal. For example, OE.
n-m indicates a bit field from bit n to bit m. For example, 7-0 specifies bits 7 through 0, inclusive.
nom indicates a signal (pin) range from n to m. For example D(7:0] specifies data lines 7 through 0, inclusive
Use of a trailing letter H indicates a hexadecimal number. For example, 7AH is a hexadecimal number.
Use of a trailing letter b indicates a binary number. For example, 010b is a binary number.
When numerical modifiers such as K or M are used, they refer to binary rather than decimal form. Thus, for example, 1 KByte would be
equivalent to 1024, not 1,000 bytes.
NOTICES
© Copyright 1995 S3 Incorporated. All rights reserved. No part of this publication may be reproduced, stored in a retrieval system, or
transmitted in any form or by any means, electronic, mechanical, photocopying, or otherwise, without the prior written consent 01 S3
Incorporated, 2770 San Tomas Expwy., Santa Clara CA 95051-0968. The S3 Corporate Logo, S3 on Board, S3 on Board design, Vision64,
Vision864, Vision868, Vision964, Vision968, Trio, Tri032, Tri064, MIC, Galileo, SDAC, Native-MPEG, No Compromise Integration, No
Compromise Acceleration and Innovations in Acceleration are trademarks of S31ncorporated and S3 and True Acceleration are registered
trademarks of S3lncorporated. Other trademarks referenced in this document are owned by their respective companies. The material in
this document is for information only and is subjectto change without notice. S31ncorporated reserves the right to make changes in the
product design without reservation and without notice to its users.
Additional information may be obtained from:
S31ncorporated, Literature Department, 2770 San Tomas Expressway, Santa Clara, CA 95051-0968.
Telephone: 408-980-5400, Fax: 408-980-5444

S3 Vision868 Multimedia Accelerator
S3 Incorporated
Table of Contents
.v  3.3.3  Disconnect Related to FIFO
List of Figures
Status  .............. 3-2
3.3.4  Plug and Play Support  . . . . .  3-2
| List of Tables .  |     | vi  |
| ----------------- | --- | --- |
3.4  PACKED 24-BITS/PIXEL SUPPORT.  3-2
3.5  RAMDAC ACCESS CYCLES  .... 3-2
Section 1: Introduction  . 1-1  3.6  50 MHz VL-BUS SUPPORT . . . . .  3-2
3.7  WRITE PER BIT SUPPORT  . . . . .  3-6
1.1  OVERVIEW OF THIS DATA
3.8  READ/MODIFY/WRITE TIMING ... 3-6
| BOOKLET  . . . . . . . . . . . . ..  |     | 1-1  |
| ------------------------------------ | --- | ---- |
3.9  1 CYCLE EDO DRAM SUPPORT  . .  3-7
| 1.2  PRODUCT OVERVIEW  | . . . . . ..  | 1-1  |
| ---------------------- | ------------- | ---- |
3.10  BURST MODE DRAM SUPPORT. .  3-7
| 1.3  ENHANCED DRAM SUPPORT. ..    |     | 1-1  |
| --------------------------------- | --- | ---- |
| 1.4  PACKED PIXEL ACCELERATION..  |     | 1-1  |
1.5  ENHANCED MEMORY-MAPPED  Section 4: Electrical Data  ..... 4-1
| I/O IMPLEMENTATION. . . . . ..  |     | 1-1  |
| ------------------------------- | --- | ---- |
4.1  MAXIMUM RATINGS. . . . . . . .  4-1
1.6  NEW DRAWING COMMANDS. ..  1-2  4.2  DC SPECIFICATIONS  ........ 4-1
1.7  IMPROVED COPROCESSOR  4.3  AC SPECIFICATIONS  . . . . . . . .  4-2
SUPPORT . . . . . . . . . . . . ..  1-2  4.3.1  Clock Timing  .......... 4-3
1.8  PCI SUPPORT ENHANCEMENTS  .  1-2  4.3.2  Input/Output Timing  . .  4-4
| 1.9  VIDEO ENGINE  | . . . . . . . . . ..  | 1-2  |
| ------------------ | --------------------- | ---- |
4.4  OUTPUT BUFFER MODEL  4-7
| 1.10  RESOLUTIONS SUPPORTED  |     | 1-2  |
| ---------------------------- | --- | ---- |
Section 5: Enhanced Mode
| Section 2: Register Changes  | ... 2-1  |     |
| ---------------------------- | -------- | --- |
Programming  ........... 5-1
| 2.1  Vision868 REGISTER CHANGES. .  |     | 2-1  |
| ----------------------------------- | --- | ---- |
5.1  MEMORY-MAPPED I/O . . . . . . .  5-1
| 2.2  NEW Vision868 SR REGISTERS  |     | . .  2-5  |
| -------------------------------- | --- | --------- |
5.1.1  Backward-Compatible MMIO  .  5-1
2.3  NEW Vision868 CR REGISTERS  ..  2-6  5.1.2  New MMIO  ........... 5-2
2.4  NEW Vision868 ENHANCED
5.1.2.1  Big/Little Endian Support . .  5-4
| COMMANDS REGISTERS  | . . . ..  | 2-7  |
| ------------------- | --------- | ---- |
5.1.2.2  Packed MMIO Register
2.5  NEW Vision868 PCI CONFIGURATION
Mapping  . . . . . . . . . . .  5-4
SPACE REGISTERS ......... 2-14
5.2  DIRECT BITMAP ACCESSING-
2.6  NEW Vision868 VIDEO ENGINE
LINEAR ADDRESSING  . . . . . . .  5-4
REGISTERS ............. 2-15
5.2.1  Backward-Compatible Linear
2.7  Vision864 REGISTERS REMOVED  Addressing  .. . . . . . . . . .  5-4
| FROM THE Vision868  | ....... 2-20  |     |
| ------------------- | ------------- | --- |
5.2.2  New Linear Addressing  .... 5-5
5.3  BITMAP ACCESS THROUGH THE
Section 3: Functional Changes  .. 3-1  GRAPHICS ENGINE. . . . . . . . .  5-5
3.1  CHIP IDENTIFICATION  . . . . . ..  3-1  5.4  PROGRAMMING..........  5-8
3.2  SHARED FRAME BUFFER MEMORY  5.4.1  Notational Conventions  .... 5-9
BANDWIDTH ALLOCATION  .... 3-1  5.4.2  Initial Setup  . . . . . . . . . . .  5-9
3.3  PCI ENHANCEMENTS  . . . . . ..  3-1  5.4.3  Programming Examples  . ..  5-10
3.3.1  Interrupt Support. . . . . . ..  3-1  5.4.3.1  Solid Line  ......... 5-11
3.3.2  RAMDAC Snooping  ...... 3-2  5.4.3.2  Textured Line  . . . . . ..  5-12
iii

S3 Vision868 Multimedia Accelerator
S3 Incorporated
| 5.4.3.3  | Rectangle Fill Solid    | ..... 5-14  |     |
| -------- | ----------------------- | ----------- | --- |
| 5.4.3.4  | Image Transfer-Through  |             |     |
the Plane ........... 5-15
| 5.4.3.5  | Image Transfer-Across the  |     |     |
| -------- | -------------------------- | --- | --- |
Plane ............. 5-17
| 5.4.3.6                         | BitBlT-Through the Plane. 5-19   |                   |         |
| ------------------------------- | -------------------------------- | ----------------- | ------- |
| 5.4.3.7                         | BitBlT-Across the Plane .. 5-20  |                   |         |
| 5.4.3.8                         | PatBlT - Pattern Fill            |                   |         |
|                                 | Through the Plane                | ..                | . 5-22  |
| 5.4.3.9                         | PatBLT-Pattern Fill              |                   |         |
|                                 | Across the Plane                 | ...               | . 5-23  |
| 5.4.3.10 Short Stroke Vectors.  |                                  |                   | . 5-24  |
| 5.4.3.11 Polyline/2-Point Line  |                                  | .... 5-25         |         |
| 5.4.3.12 Polygon Fill Solid     |                                  | . . . . . . 5-26  |         |
5.4.3.13 Polygon Fill Pattern . . . . . 5-28
5.4.3.14 4-Point Trapezoid Fill Solid. 5-29
5.4.3.15 4-pointTrapezoid Fill
Pattern . . . . . . . . . . . . 5-30
5.4.3.16 Bresenham Parameter
|     | Trapezoid Fill Solid  | . .  | . 5-31  |
| --- | --------------------- | ---- | ------- |
5.4.3.17 Bresenham Parameter
|     | Trapezoid Fill Pattern.  |     | . 5-32  |
| --- | ------------------------ | --- | ------- |
5.4.3.18 ROPBlTs ........... 5-33
5.4.3.19 Programmable Hardware
|                           | Cursor  . . . . . . . . .  |            | . 5-45  |
| ------------------------- | -------------------------- | ---------- | ------- |
| 5.5  RECOMMENDED READING  |                            | .... 5-46  |         |
Section 6: Video Engine ...... 6-1
| 6.1  VIDEO ENGINE OVERVIEW   |     | .               | 6-1  |
| ---------------------------- | --- | --------------- | ---- |
| 6.2  SCALING...........      |     |                 | 6-2  |
| 6.3  COLOR SPACE CONVERSION  |     | . ..            | 6-2  |
| 6.4  DITHERING               |     | . . . . . . ..  | 6-2  |
| 6.5  STATUS...............   |     |                 | 6-3  |
Appendix A: Listing of Raster
| Operations  | .  . .  . .  | . . .  . . ..  | A-1  |
| ----------- | ------------ | -------------- | ---- |
iv

S3 Vision868 Multimedia Accelerator
S3 Incorporated
List of Figures
| #  Title                      |     | Page  |
| ----------------------------- | --- | ----- |
| 3-1  RAMDAC PCI Read Timing.  |     | 3-3   |
..
| 3-2  RAMDAC PCI Write Timing  |     | 3-4  |
| ----------------------------- | --- | ---- |
3-3  Fast Page Mode Read/Modify
· .........
| Write Timing  |     | 3-5  |
| ------------- | --- | ---- |
3-4  EDO Mode Read/Modify Write
| Timing ..............          |      | 3-5  |
| ------------------------------ | ---- | ---- |
| 3-5  1 Cycle EDO Read Timing   | ...  | 3-6  |
| 3-6  1 Cycle EDO Write Timing  | ...  | 3-6  |
3-7  1 Cycle EDO Read/Modify/Write
| Timing ............             |            | 3-7  |
| ------------------------------- | ---------- | ---- |
| 3-8  Burst Mode Read Timing ..  |            | 3-8  |
| 3-9  Burst Mode Write Timing    |            | 3-8  |
| 4-1  Clock Waveform Timing      |            | 4-3  |
| 4-2  Input Timing               | · .......  | 4-4  |
.......
| 4-3  Output Timing  |     | 4-5  |
| ------------------- | --- | ---- |
· .......
| 4-4  Reset Timing                      |     | 4-7  |
| -------------------------------------- | --- | ---- |
| 4-5  First Order Output Buffer Model.  |     | 4-8  |
..... 5-6
5-1  Pixel Update Flowchart
5-2  Polygon Example Drawing Steps 5-26
v

fl·
53 Vision868 Multimedia Accelerator
53 Incorporated
List of Tables
| #  Title                          |     | Page  |
| --------------------------------- | --- | ----- |
| 1-1  Video Resolutions Supported  |     | 1-2   |
2-1  Register Differences Between the
| Vision868 and Vision864 . .            |         | 2-1  |
| -------------------------------------- | ------- | ---- |
| 4-1  Absolute Maximum Ratings ..       |         | 4-1  |
| 4-2  DC Specifications . . . . . . ..  |         | 4-1  |
| 4-3  Clock Waveform Timing             | . . ..  | 4-3  |
| 4-4  SCLK-Referenced Input Timing      |         | 4-4  |
| 4-5  SCLK-Referenced Output Timing     |         | 4-5  |
| 4-6  MCLK-Referenced Input Timing .    |         | 4-6  |
| 4-7  MCLK-Referenced Output Timing     |         | 4-6  |
| 4-8  DCLK-Referenced Output Timing     |         | 4-6  |
4-9  Fast Page, 1 Cycle EDO, Burst
| Mode Memory Input Timing.  |                    | 4-6  |
| -------------------------- | ------------------ | ---- |
| 4-10  Reset Timing         | . . . . . . . . .  | 4-7  |
5-1  Enhanced Registers Memory
| Mapping. . . . . . . . . . . .    |     | 5-2    |
| --------------------------------- | --- | ------ |
| 5-2  New MMIO Addresses . . . .   |     | 5-3    |
| 5-3  Big Endian Byte Swap Select  |     | . 5-4  |
5-4  Polygon Fill Example Summary . 5-27
6-1  Video Engine Input/Output
| Combinations. . . . . . . . . ..  |     | 6-1  |
| --------------------------------- | --- | ---- |
vi

S3 Vision868 Multimedia Accelerator
53 Incorporated
Section 1: Introduction
1.1 OVERVIEW OF THIS DATA 1.3 ENHANCED DRAM SUPPORT
BOOKLET
The Vision868 supports burst mode DRAMs and
This data booklet largely describes the areas in single cycle EDO operation at speeds up to 50
which the S3® Vision868™ accelerator (hereinaf MHz. These are capable of sequential read or
write data transfers at rates approaching twice
ter referred to as the Vision868) is different from
that of convention fast page mode DRAMs.
the S3 Vision864™ (hereinafter referred to as the
Vision864).
1.4 PACKED PIXEL ACCELERATION
Although enhanced mode programming largely
remains unchanged from the Vision864 data
The Vision868 provides packed 24 bits/pixel (true
book description, the entire section is included in
color) acceleration. This means that each pixel in
this data booklet because it has been extensively
24 bits/pixel modes now occupies 3 bytes of
revised. Similarly, the entire electrical data sec
memory instead of 4 for the Vision864. In addi
tion is included. For information on other com
tion, the graphics engine can process more pixels
mon features between the Vision868 and
in a given number of clock cycles than for the
Vision864, including most of the registers and the
Vision864.
graphics acceleration functionality, see the
Vision864 Graphics Accelerator Data Book. In
particular, note that the pinout and pin descrip 1.5 ENHANCED MEMORY-MAPPED
tions are the same for both chips. 1/0 IMPLEMENTATION
1.2 PRODUCT OVERVIEW The Vision864 provides memory-mapped I/O
(MMIO) access to certain enhanced command
In general, the Vision868 provides all the features registers at fixed memory addresses. The
found in the Vision864. The exception is that Vision868 provides the following enhancements
backward compatibility support for eGA, MDA to this scheme:
and HGC is no longer provided in hardware.
• The base address for MMIO is now the
The Vision868 provides a number of enhanced same as for linear addressing and is relo
capabilities notfound in the Vision864. These are catable for plug and play support
summarized below and are described in detail in • The new MMIO is enabled at power-on
subsequent sections. reset for PCI systems, allowing the PCI
subsystem to configure the Vision868
without accessing the VGA registers
through the I/O space
All registers are now memory mapped
INTRODUCTION 1-1

S3 Vision868 Multimedia Accelerator
S3 Incorporatad
| •  Related 16-bit Enhanced command regis  | 1.9  VIDEO ENGINE  |     |     |
| ----------------------------------------- | ------------------ | --- | --- |
ters are packed into 32-bit registers to re
duce the number of CPU cycles required
The Video Engine integrated into the Vision868
to access them
can convert a YUV data stream to an RGB data
•  There are two apertures into the MMIO  stream. The output of the color space converter
address sRace. One provides little en  is then sentthrough the scaling engine for scaling
dian (lntel©-style) access and the other  up or down. Additionally, a dithering engine con
provides big endian (Motorola©/  verts 24 bits/pixel images to a 16-or 8-bit format
PowerPCTM-style) access  (and 16-bit images to an 8-bit format) with little
quality impact. To support image compression,
1.6  NEW DRAWING COMMANDS  the Video Engine can scale images down to the
size required to meet disk drive bandwidth re
quirements.
The following drawing commands have been
added to those available with the Vision864:
1.10  RESOLUTIONS SUPPORTED
•  polyline/2-point line
Supported resolutions are shown in the follow
•  polygon with solid or patterned fills
ing table. Extended VGA text modes up to 132
•  trapezoid with solid or patterned fills
columns by 43 rows are possible as well.
(Bresenham parameters in hardware)
•  trapezoid with solid or patterned fills  Table 1-1.  Video Resolutions Supported
(Bresenham parameters specified by pro
grammer)
|     |     | 1 MB  2MBs  | 4MBs  |
| --- | --- | ----------- | ----- |
•  ROPBL T -Support is provided for the  Resolution  DRAM  DRAM  DRAM
full set of 256 triadic raster operations  640x480x4  t/  t/  t/
for BitBLT s (as defined by Microsoft©)
|     | 640x480x8   | t/  t/  | t/  |
| --- | ----------- | ------- | --- |
|     | 640x480x16  | t/  t/  | t/  |
1.7  IMPROVED COPROCESSOR
|          | 640x480x24  | t/  t/  | t/  |
| -------- | ----------- | ------- | --- |
| SUPPORT  | 640x480x32  |         |     |
|          |             | t/      | t/  |
|          | 800x600x4   | t/  t/  | t/  |
During shared frame buffer operation, the co
|     | 800x600x8  | t/  t/  | t/  |
| --- | ---------- | ------- | --- |
processor can now be guaranteed a specified
800x600x16
| amount ofthe memory bandwidth without being  |     | t/  t/  | t/  |
| -------------------------------------------- | --- | ------- | --- |
forced to return control of the memory bus.  800x600x24/32  t/  t/
|                                | 1024x768x4   | t/  t/  | t/  |
| ------------------------------ | ------------ | ------- | --- |
| 1.8  PCI SUPPORT ENHANCEMENTS  | 1024x768x8   | t/  t/  | t/  |
|                                | 1024x768x16  | t/      | t/  |
The following have been added to improve op  1024x768x24  t/
| eration in PCI systems:  | 1152x864x8  | t/  | t/  |
| ------------------------ | ----------- | --- | --- |
t/
|     | 1280x1024x4  | t/  t/  | t/  |
| --- | ------------ | ------- | --- |
•  New registers for interrupt handling
|     | 1280x1024x8  | t/  | t/  |
| --- | ------------ | --- | --- |
•  Complete RAMDAC snooping capability
|     | 1600x1200x4  | t/  t/  | t/  |
| --- | ------------ | ------- | --- |
•  PCI disconnect based on the command
| FIFO status  | 1600x1200x8  | t/  | t/  |
| ------------ | ------------ | --- | --- |
1-2  INTRODUCTION

S3 Vision868 Multimedia Accelerator
S3 Incorporated
Section 2: Register Changes
2.1 Vision868 REGISTER CHANGES
Most Vision868 registers operate exactly as their Vision864 counterparts. The exceptions are shown
in Table 2-1. New Vision868 registers are described in Sections 3.2 through 3.6.
Table 2-1. Register Differences Between the Vision868 and Vision864
Vision864 Register Bit(s) Vision868 Description
CR30 7-0 This is hardwired to E1 H.
CR32 3-2 Reserved
CR36 3-2 00 = One cycle EDO DRAM (new)
01 = Burst mode DRAM (new)
10 = EDO DRAM
11 = Fast page mode DRAM
o
CR40 3 = Normal SRDY operation
1 = SRDY delayed by one cycle (VL-Bus only)
o
CR50 1 = DACRD, DACWR active pulse = 2 SCLKs
1 = DACRD, DACWR active pulse = 4 SCLKs
CR50 5-4 00 = 4/8 bits/pixel
01 = 16 bits/pixel
10 = 24 bits/pixel (new)
11 = 32 bits/pixel
CR53 0 Reserved (write per bit no longer supported)
CR53 The power-on default depends on the system bus type. See the
description for bits 4-3 below
CR53 2-1 Big endian data byte swap (linear addressing and Video Engine
transfers only)
00 = No swap
01 = Swap bytes within each word
10 = Swap all bytes in doubleword (bytes reversed)
11 = Reserved
REGISTER CHANGES 2-1

II·
S3 Vision868 Multimedia Accelerator
S3 Incorporatad
Table 2-1. Register Differences Between the Vision864 and Vision868 (Continued)
Vision864 Register Bit(s) Vision868 Description
CR53 4-3 MMIO select
00 = MMIO disabled
01 = MMIO disabled
10 = Vision864-type MMIO (AOOOOH window)
11 = New MMIO (relocatable/packed) and Vision864-type MMIO
VL-Bus power-on default = 00
PCI bus power-on default = 11
CR53 7 Enable upper byte write protection in 32 bits/pixel mode
o
= CAS3 and CAS7 enabled during 32 bits/pixel memory writes
1 = CAS3 and CAS7 disabled during 32/bits/pixel memory writes
CR54 1-0 Big endian data byte swap (not linear addressing, not image writes
and not Video Engine access)
00 = No swap
01 = Swap bytes within each word
10 = Swap all bytes in doubleword (bytes reversed)
11 = Swap according to BE[3:0] (VL-Bus ) or C/BE(3:0] (PCI bus)
BE[3:0VC/BE]3:0]
0000 = Swap all bytes in doubleword (bytes reversed)
0011 = Swap bytes within selected word
1100 = Swap bytes within selected word
All other values = No swap
CR54 2 This is the high order extension bit (bit 5) for the M parameter (bits 7-
3 of this register). This doubles the amount of memory bandwidth
that can be allocated for Graphics Enqine/CPU access.
CR58 The power-on default depends on the system bus type. See the
description for bit 4 below.
CR58 4 VL-Bus power-on default = 0
PCI bus power-on default = 1
CR59, CR5A 15-0 VL-Bus power-on default = OOOAH
PCI bus power-on default = 7000H
CR61 6-5 Big endian data byte swap (image writes)
00 = No swap
01 = Swap bytes within each word
10 = Swap all bytes in doubleword (bytes reversed)
11 = Reserved
CR66 3 PCI disconnect enable (PCI bus only)
0= No effect
1 = An attempt to write data with the Command FIFO full or to read
data with the Command FIFO not empty generates a PCI bus
disconnect cycle
Bit 7 of this register must also be set to 1 to enable this feature.
CR67 7-4 0111 = Mode 11: 32-bit color, 2 VCLKs/pixel
1001 = Mode 12: 24-bit packed color, 3 VCLKs/2 pixels
2-2 REGISTER CHANGES

S3 Vision868 Multimedia Accelerator
S3 Incorporated
Table 2-1. Register Differences Between the Vision864 and Vision868 (Continued)
Vision864 Register Bit(s) Vision868 Description
Enhanced Registers
82E8H 11-0 For polygons or trapezoids, this is the starting pixel vertical position
for the first of two edges to be drawn.
86E8H 11-0 For polygons or trapezoids, this is the starting pixel horizontal
position for the first of two edQes to be drawn.
8AE8H 11-0 For polylines, this is the ending vertical position for each line
segment. For polygons and 4-point trapezoids, this is the ending
vertical position for the first of two edges to be drawn. For
Bresenham parameter trapezoids, this is the axial step constant for
the first of two edges to be drawn.
8EE8H 11-0 For polylines, this is the ending horizontal position for each line
segment. For polygons and 4-point trapezoids, this is the ending
horizontal position for the first of two edges to be drawn. For
Bresenham parameter trapezoids, this is the diagonal step constant
for the first of two edges to be drawn.
92E8H 11-0 For Bresenham parameter trapezoids, this is the error term for the
first of two edges to be drawn.
96E8H 11-0 For Bresenham parameter trapezoids, this is the major axis length
for the first of two edQes to be drawn.
9AE8H 10-9 Select image write (E2E8H, E2EAH) bus transfer width
00 = 8 bits
01 =16bits
10 = 32 bits. All doubleword bits beyond the image rectangle width
are discarded. Each line starts with a fresh doubleword. The
current drawing position ends up one pixel below the lower
left hand corner of the image rectangle .
11 = 32 bits. This setting applies only to image transfers across the
plane. Only padding bits up to the start of the next byte are
discarded. The current drawing position ends up one pixel to the
right of the top right corner of the rightmost image rectangle.
9AE8H 11, Drawing Command
15-13 0000 = NOP
0001 = Draw line
0010 = Rectangle fill
0011 = Polygon fill solid (new)
0100 = 4-point trapezoid fill solid (new)
0101 = Bresenham parameter trapezoid fill solid (new)
all a
= BitBLT
0111 = Pattern BL T
1001 = Polyline/2-point line (new)
1011 = Polygon fill pattern (new)
1100 = 4-point trapezoid fill pattern (new)
1101 = Bresenham parameter trapezoid fill pattern (new)
1110 = ROPBL T (new)
See the Enhanced Mode Programming section for a description of
each of these commands.
REGISTER CHANGES 2-3

53 Vision868 Multimedia Accelerator
S3 Incorporated
Table 2·1. Register Differences Between the Vision864 and Vision868 (Continued)
Vision864 Register Bit(s) Vision868 Description
AEE8H 31-0 Read mask for the ROPBLT pattern (same as previous Read Mask)
BEE8H, Index E 6 Reserved
BEE8H, Index E 10 o = Allow burst model1 cycle EDO write operation
1 = Disable burst model1 cycle EDO write operation
PCI Registers
PCI Index 02H 15-0 The device ID is hardwired to 8880H.
PCI Index 04H 7 Hardwired to 1 to indicate that the device always does addressldata
stepping.
PCI Index OAH 7-0 Now included in new Class Code register.
2-4 REGISTER CHANGES

r-~ .
S3 Vision868 Multimedia Accelerator
S3 Incorporated
2.2 NEW Vision868 SR REGISTERS
The SR registers described in this section have been added for the Vision868 and are not found in the
Vision864.
Extended Sequencer Register 9 (SR9)
ReadIWrite Address: 3C5H, Index 09H
Power-On Default: OOH
6
I : I : I : I : I I : I
R R
Bits 6-0 Reserved
Bit 7 MMIO-ONLY -Memory-mapped I/O register access only
o = If MMIO is enabled, both programmed 110 and memory-mapped 110 register
accesses are allowed
1 = If MMIO is enabled, only memory-mapped I/O register accesses are allowed
External Bus Request Control Register (SRA)
ReadIWrite Address: 3C5H, Index OAH
Power-On Default: OOH
5 4 3 2 1 o
PVALUE
5 4 3 2 o
Bits 5-0 P VALUE
The integer equivalent of the binary value in this field is the number of MCLK units
less one a secondary memory controller is allowed to retain control of the memory
bus before the Vision864 drops its bus grant. See Section 3.2 for a detailed explana
tion.
Bit 6 Reserved
Bit 7 2MCLK -2 MCLK CPU writes to memory (linear addressing)
o
= 3 MCLK memory writes
1 = 2 MCLK memory writes
REGISTER CHANGES 2-5

II·
S3 Vision868 Multimedia Accelerator
S3 Incorporated
2.3  NEW Vision868 CR REGISTERS
The CR registers described in this section have been added for the Vision868 and are not found in the
Vision864.
Device 10 High Register (CR2D)
| Read Only  |     | Address: 3?5H, Index 2DH  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: 88H
This register contains the same value as the upper byte of the PCI Vendor ID (Index DOH) register.
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
CHIP ID HIGH
| Bits 7-0  | CHIP ID HIGH  |     |     |
| --------- | ------------- | --- | --- |
Device 10 Low Register (CR2E)
| Read Only  |     | Address: 3?5H, Index 2EH  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: 90H
| 7  6  | 5  432  |     | o   |
| ----- | ------- | --- | --- |
CHIP 10 LOW
| Bits 7-0  | CHIP ID LOW  |     |     |
| --------- | ------------ | --- | --- |
Revision Register (CR2F)
| Read Only  |     | Address: 3?5H, Index 2FH  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: DOH
| 7  6  | 543  | 2   | o   |
| ----- | ---- | --- | --- |
REVISION LEVEL
| Bits 7-0  | REVISION LEVEL  |     |     |
| --------- | --------------- | --- | --- |
2-6  REGISTER CHANGES

S3 Vision868 Multimedia Accelerator
S3 Incorporated
2.4 NEW Vision868 ENHANCED COMMANDS REGISTERS
The Enhanced Commands registers described in this section have been added for the Vision868 and
are not found in the Vision864.
Current V·Position 2 Register (CUR_V21
Read/Write Address: 82EAH
Power-On Default: Undefined
For polygons or trapezoids, this is the starting pixel vertical position for the second of two edges to be
drawn. Reading this register produces the current vertical drawing coordinate for the second edge
being drawn.
Bits 11-0 CURRENT V-POSITION 2
Bits 15-12 Reserved
Current X-Position 2 Register (CUR_X21
Read/Write Address: 86EAH
Power-On Default: Undefined
For polygons or trapezoids, this is the starting pixel horizontal position for the second of two edges to
be drawn. Reading this register produces the current horizontal drawing coordinate for the second
edge being drawn.
Bits 11-0 CURRENT X-POSITION 2
Bits 15-12 Reserved
REGISTER CHANGES 2-7

53 Vision868 Multimedia Accelerator
S3 Incorporatad
V-Coordinate 2/Axial Step Constant 2 Register (V2_AXSTP21
Read/Write Address: 8AEAH
Power-On Default: Undefined
For polygons and 4-point trapezoids, this is the ending vertical position for the second of two .edges
to be drawn. For Bresenham parameter trapezoids, this is the axial step constant for the second of two
edges to be drawn.
Bits 11-0 V-COORDINATE 2
Bits 15-12 Reserved
LINE PARAMETER AXIAL STEP CONSTANT 2
Axial Step Constant = 2 * (min(ldxl,ldyPI In other words, when drawing a line from point A to point B,
determine the change in the X coordinate from A to B and the change in the V coordinate from A to B.
Take the smaller of the two changes and multiply its absolute value by 2.
Bits 13-0 LINE PARAMETER AXIAL STEP CONSTANT 2
Bits 15-14 Reserved
X-Coordinate 2 Register (X2)
Read/Write Address: 8EEAH
Power-On Default: Undefined
For polygons and 4-point trapezoids, this is the ending horizontal position for the second of two edges
to be drawn. For Bresenham parameter trapezoids, this is the diagonal step constant for the second of
two edges to be drawn.
Bits 11-0 X-COORDINATE 2
Bits 15-12 Reserved
2-8 REGISTER CHANGES

II·
53 Vision868 Multimedia Accelerator
S3 Incorporated
Line Error Term 2 Register (ERR_TERM2J
Read/Write Address: 92EAH
Power-On Default: Undefined
For Bresenham parameter trapezoids, this is the error term for the second of two edges to be drawn.
Error Term = 2 * minlldxl,ldyll-maxlldxl,ldyl-1 if the starting X < the ending X
Error Term = 2 * minlldxl,ldyll-max!ldxl,ldyl if the starting X ~ the ending X
See the Destination V-Position/Axial Step Constant (8AE8H) register for an explanation of the terms
used in these equations.
Bits 13-0 ERROR TERM 2
Bits 15-14 Reserved
Major Axis Pixel Count 2 Register (MAJ_AXIS_PCNT2J
Read/Write Address: 96EAH
Power-On Default: Undefined
This register specifies the length (in pixels) of the major (longest) axis for solid and textured lines and
the width for rectangles, image transfers, BitBlT s and PatBlT s. For Bresenham parameter trapezoids,
this is the major axis length for the first of two edges to be drawn.
Bits 11-0 RECTANGLE WIDTH 2/L1NE PARAMETER MAX 2
The value is the number of pixels along the major axis -1.
Bits 15-12 Reserved
REGISTER CHANGES 2-9

,.-
.6Ja
•
S3 Vision868 Multimedia Accelerator
S3 Incorporated
Drawing Command 2 Register (CMD2)
| Write Only  | Address: 9AEAH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
For Bresenham parameter trapezoid fills, this register defines the drawing direction for the second
edge to be drawn. The drawing direction for the first edge is specified in bits 7-5 of 9AEBH
| 15  14  13  | 12  11  10  | 9  8  | 7  I  6  I  | 4  3  2  | 1  0  |
| ----------- | ----------- | ----- | ----------- | -------- | ----- |
5
DRWG-DIR 2.
a
| R  R  R                                           | R  R  R  | R  R  | 2  1  | R  R  R  | R  R  |
| ------------------------------------------------- | -------- | ----- | ----- | -------- | ----- |
| Bits 4-0  Reserved                                |          |       |       |          |       |
| Bits 7-5  DRWG-DIR 2 -Select Drawing Direction 2  |          |       |       |          |       |
In the following table, the line is drawn from left to right or a +X and from right to left
for a -X, down for a +Y and up for a -Yo X or Y maj specifies the longest axis. Axial
drawing is specified in bit 3 of 9AEBH.
x-v
|     | 7-5  | (Axial -bit 3 = O)  |     |     |     |
| --- | ---- | ------------------- | --- | --- | --- |
|     | 000  | -Y,Xmaj,-X          |     |     |     |
001
-Y,Xmaj,+X
|     | 010  | -Y,Ymaj,-X   |     |     |     |
| --- | ---- | ------------ | --- | --- | --- |
|     | all  | -Y,Y maj,+X  |     |     |     |
100
+y,X maj,-X
|     | 101  | +Y,Xmaj,+X  |     |     |     |
| --- | ---- | ----------- | --- | --- | --- |
|     | 110  | +Y,Ymai.-X  |     |     |     |
111
+Y,Ymaj,+X
| Bits 15-8  Reserved  |     |     |     |     |     |
| -------------------- | --- | --- | --- | --- | --- |
2-10  REGISTER CHANGES

S3 Vision868 Multimedia Accelerator
S3 Incorporated
ROP Mix Selection Register (ROPMIX)
ReadNVrite Address: D2EBH
Power-On Default: Undefined
7-0
Bits ROP MIX SELECTION
See Appendix A for a listing of the 256 mix selections available.
Bit 8 MP -Mono pattern select
o = ROPBlT pattern is color
1 = ROPBlT pattern is monochrome
If a monochrome pattern is selected, the background and foreground colors are speci
fied in E6EBH and EEEBH respectively.
Bits 15-9 Reserved
ROPBL T Pattern Background Color Register (PAT _BG_COLOR)
ReadNVrite Address: E6E8H
Power-On Default: Undefined
This register defines the background color for the ROPBlT pattern when bit B of D2E8H is set to 1 to
specify a monochrome pattern.
15 I 14 I 13 I 12 I 11 I 10 I I I 7 I I 5 141312111 0
9 8 6
BACKGROUND COLOR
31 21 I 20 I I I 17 I
1~1~1~lnl~I~I~lnl~1 19 18 16
BACKGROUND COLOR
31-0
Bits BACKGROUND COLOR
If bit 9 of BEE8_EH is set to 1 or if MMIO is enabled, this becomes a 32-bit register. If
bit 9 of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode with 16-
bit registers, the upper and lower doublewords are read or written sequentially, de
pending on the state of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the lower
16 bits are accessed. If RSF = 1, the upper 16 bits are accessed. The RSF flag toggles
automatically when a doubleword is read or written.
REGISTER CHANGES 2-11

II·
S3 Vision868 Multimedia Accelerator
S3 Incorporated
Read/Write Address: EAE8H
Power-On Default: Undefined
This register defines the vertical coordinate top edge of an 8x8 pixel pattern programmed into
off-screen memory. This is used with the Bresenham parameter trapezoidal fill pattern, trapezoidal
4-po'int trapezoid fill pattern, polygon fill pattern and ROPBlT command types.
Bits 11-0 PATIERN Y
Bits 15-12 Reserved
Read/Write Address: EAEAH
Power-On Default: Undefined
This register defines the horizontal coordinate of the left side of an 8x8 pixel pattern programmed into
off-screen memory. This is used with the Bresenham parameter trapezoidal fill pattern, trapezoidal
4-point trapezoid fill pattern, polygon fill pattern and ROPBlT command types.
Bits 11-0 PATIERN X
Bits 15-12 Reserved
2-12 REGISTER CHANGES

r~ .
S3 Vision868 Multimedia Accelerator
S3 Incorporated
ROPBLT Pattern Foreground Color Register IPAT_FG_COLOR)
ReadIWrite Address: EEE8H
Power-On Default: Undefined
This register defines the foreground color for the ROPBL T pattern when bit 8 of D2E8H is set to 1 to
specify a monochrome pattern.
I I I I I I I I I I
15 I 14 I 13 I 12 I 11 I 10 9 8 7 6 5 4 3 2 1 0
FOREGROUND COLOR
I
31 I 30 I 29 I 28 I 27 I 26 I 25 I 24 I 23 I 22 I 21 I 20 I 19 I 18 I 17 16
FOREGROUND COLOR
Bits 31-0 FOREGROUND COLOR
If bit 9 of BEE8_EH is set to 1 or if MMIO is enabled, this becomes a 32-bit register. If
bit 9 of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode with 16-
bit registers, the upper and lower doublewords are read or written sequentially, de
pending on the state of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the lower
16 bits are accessed. If RSF = 1, the upper 16 bits are accessed. The RSF flag toggles
automatically when a doubleword is read or written.
REGISTER CHANGES 2-13

S3 Vision868 Multimedia Accelerator
S3 Incorporated
2.5  NEW Vision868 PCI CONFIGURATION SPACE REGISTERS
The PCI Configuration Space registers described in this section have been added for the Vision868 and
are not found in the Vision864.
Class Code
| Read Only  | Address: 08H  |     |     |
| ---------- | ------------- | --- | --- |
Power-On Default: 30000H
The class code is contained in bits 31-8. These 3 bytes are hardwired to 30000H to specify that the
Vision868 is a VGA-compatible display controller. Bits 7-0 contain the Revision 10, and are present in
the Vision864.
15  \  14  \  13  \  12  \  11  \  10  \  9  \  8  7  \  6  \  5\  4  \  3  \  2  \  1  \  0
PROGRAMMING INTERFACE
31  \  30  \  29  \  28  \  27  \  26  \  25  \  24  23  \  22  \  21  \  20  j  19.\  18  \  17  \  16
BASE CLASS CODE  SUB-CLASS
Interrupt Line
| Read/Write  | Address: 3CH  |     |     |
| ----------- | ------------- | --- | --- |
Power-On Default: OOH
This register contains interrupt line routing information written by the POST program during power-on
initialization.
| 7  6  |      |     | o   |
| ----- | ---- | --- | --- |
|       | 543  | 2   |     |
INTERRUPT LINE
| Bits 7-0  | INTERRUPT LINE  |     |     |
| --------- | --------------- | --- | --- |
Interrupt Pin
| Read Only  |     | Address: 3DH  |     |
| ---------- | --- | ------------- | --- |
Power-On Default: 01H
This register is hardwired to a value of 1 to specify that INTA is the interrupt pin used.
o
| 7  6  | 5  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
INTERRUPT PIN
| Bits 7-0  | INTERRUPT PIN  |     |     |
| --------- | -------------- | --- | --- |
2-14  REGISTER CHANGES

S3 Vision868 Multimedia Accelerator
S3 Incorporated
2.6  NEW Vision868 VIDEO ENGINE REGISTERS
The Video Engine registers described in this section have been added for the VisionB6B. They are not
found in the VisionB64.
Video Engine NOP Register
| ReadIWrite  | Address: BOBOH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: 0000 OOOOH
Software must make a dummy write to this register when it is finished sending Video Engine
commands. Graphics Engine commands can then follow. This Nap prevents simultaneous Video
Engine and Graphics Engine operation.
|               |                         | I  J  1  | L  I  5 I  | 4 1  1 2 1  | 1     |
| ------------- | ----------------------- | -------- | ---------- | ----------- | ----- |
| 15  1  14  1  | 13  1  12  I  11  I 10  | 9  8     | 7  6       | 3           | 1  0  |
NOP
| 1   |     |     |     |     | 1  16  |
| --- | --- | --- | --- | --- | ------ |
31  30  1  29  1  28  1  27  1  26  1  25  1  24  1  23  1  22  1  21  1  20  1  19  1  18  1  17
NOP
| Bits 31-0  | Nap -No operation  |     |     |     |     |
| ---------- | ------------------ | --- | --- | --- | --- |
Video Engine Control Register
| ReadIWrite  | Address: BOBBH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: 0000 OOOOH
|            |                                | 25124123      | I           | I              |            |
| ---------- | ------------------------------ | ------------- | ----------- | -------------- | ---------- |
| 31  30     | 29  28  27                     | 26            | 22  21      | 20  19  18  I  | 17  I  16  |
|            |                                |               | INPUT DATA  | OUTPUT DATA    |            |
| FILT  esc  | DITH  on  R                    | KM  DM INDEX  | FORMAT      | cs  FORMAT     |            |
| Bits 11-0  | DDA ACCUMULATOR INITIAL VALUE  |               |             |                |            |
Digital Differential Analyzer accumulator initial value = -MAX(Ws, Wd), where Ws is
the width in pixels of the source and Wd is the width in pixels of the destination.
| Bits 15-12  | Reserved  |     |     |                   |       |
| ----------- | --------- | --- | --- | ----------------- | ----- |
|             |           |     |     | REGISTER CHANGES  | 2-15  |

53 Vision868 Multimedia Accelerator
S3 Incorporated
Bits 18-16 OUTPUT DATA FORMAT
000 = B bits/pixel, RGB, 3.3.2 -can be translated with output table
001 = Reserved
010 = Reserved
011 = 32 bits/pixel, RGB, x.B.B.B
100 = 16 bits/pixel, YCbCr, 4:2:2
101 = 16 bits/pixel, raw
110 = 15 bits/pixel RGB, 5.5.5
111 = 16 bits/pixel RGB, 5.6.5
Bit 19 CS -Color Space
0= YCbCr, 16-240 range
1 =YUV
Bits 22-20 INPUT DATA FORMAT
000 = B bits/pixel, RGB, 3.3.2 -can be translated with output table
001 = Reserved
010 = Reserved
011 = 32 bits/pixel, RGB, x.B.B.B
100 = 16 bits/pixel, YCbCr, 4:2:2
101 = 16 bits/pixel, raw (scaling only)
110 = 15 bits/pixel RGB, 5.5.5
111 = 16 bits/pixel RGB, 5.6.5
Bits 25-23 DM INDEX -Dithering Matrix Index
This is auto-incremented at the end of each line. It should be initialized to 0 at the be
ginning of each new frame or block of lines.
Bit 26 KM -Key Mask Enable
o = Disable -bypass function
1 = Enable
Bit 27 Reserved
Bit 28 OTT -Output Table Translation Enable
o
= Disable -bypass function
1 = Enable
Bit 29 DITH -Dithering
o = Disable -bypass function
1 = Enable
Bit 30 CSC -Color Space Converter
o = Disable -bypass function
1 = Enable
Bit 31 FI LT -Filter
o = Disable -bypass function
1 = Enable
2-16 REGISTER CHANGES

••
r
S3 Vision868 Multimedia Accelerator
53 Incorporated
Video Engine Stretch/Filter Constants Register
Read/Write Address: BOSCH
Power-On Default: 0000 OOOOH
Bits 10-0 K2
IfWs:?Wd, then K2 = Wd-Ws; IfWs<Wd, then K2 = Ws-Wd
Ws is the width in pixels of the source and Wd is the width in pixels of the destination.
Bits 13-11 Reserved
Bits 15-14 FILTER -Filter characteristics
00 = Bi-linear (default)
01 = Linear, 0-2-4-2-0
10 = Linear, 1-2-2-2-1
11 = Reserved
Bits 26-16 K1
If Ws<!Wd, then K1 = Wd; If WsWd, then K1 = Ws
Ws is the width in pixels of the source and Wd is the width in pixels of the destination.
Bits 28-27 Reserved
Bit 29 SEN -Sense
o = Normal. Logic 1 in key mask enables video, logic 0 in key mask enables graphics
1 = Reverse. Logic 0 in key mask enables video, logic 1 in key mask enables graphics
Bit 30 HD -Host data
o
= Data from screen
1 = Data from host
Bit 31 SS -Shrink/Stretch, Scale Down/Up
0= Stretch/Scale Up
1 = Shrink/Scale Down
REGISTER CHANGES 2-17

S3 Vision868 Multimedia Accelerator
S3 Incorporated
Video Engine Source/Destination Step Register
Read/Write Address: 8090H
Power-On Default: 0000 OOOOH
Bits 12-0 DESTINATION STEP
This is the pitch that is added to the write address following a memory write cycle.
For a horizontal stretch, this register should be programmed with an 8 for 2-MByte
memory configurations or larger (8 bytes/write) or a 4 for 1-MByte memory configura
tions (4 bytes/write). For a vertical stretch, the step is the number of bytes/pixel times
the number of pixels/line (bytes/line.
Bits 15-13 Reserved
Bits 28-16 SOURCE STEP
This is the pitch that is added to the read address following a memory read cycle.
For a horizontal stretch, this register should be programmed with an 8 for 2-MByte
memory configurations or larger (8 bytes/write) or a 4 for 1-MByte memory configura
tions (4 bytes/write). For a vertical stretch, the step is the number of bytes/pixel times
the number of pixels/line (bytes/line).
Bits 31-29 Reserved
2-18 REGISTER CHANGES

S3 Vision868 Multimedia Accelerator
S3 Incorporated
Video Engine Crop Register
| Read/Write  | Address: 8094H  |     |     |     |
| ----------- | --------------- | --- | --- | --- |
Power-On Default: 0000 OOOOH
o
| 15  14  13         | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  |
| ------------------ | ----------- | -------- | -------- | -------- |
| R  R  R            | R           |          | LENGTH   |          |
| Bits 11-0  LENGTH  |             |          |          |          |
Value = Actual number of pixels to process
| Bits 15-13  Reserved  |     |     |     |     |
| --------------------- | --- | --- | --- | --- |
| Bits 27-16  START     |     |     |     |     |
Value = Number of pixels to not be written after starting
| Bits 15-13  Reserved  |     |     |     |     |
| --------------------- | --- | --- | --- | --- |
Video Engine Source Base Address Register
| Read/Write  | Address: 8098H  |     |     |     |
| ----------- | --------------- | --- | --- | --- |
Power-On Default: 0000 OOOOH
| Bits 23-0  SOURCE BASE ADDRESS  |     |     |     |     |
| ------------------------------- | --- | --- | --- | --- |
Source base address (in bytes) in display memory for the image to be processed by
the Video Engine. The source address is in display memory only for the second pass
of a 2-pass operation. Otherwise, the source is system memory with the data pro
vided by the Host. In this case, only bits 1-0 of this register are relevant. The decimal
value of bits 1-0 is the number of bytes to discard from the start of each pixel line
stream from the Host. This allows adjustment for non-doubleword-aligned pixel data
in system memory.
REGISTER CHANGES  2-19

..
-
,..
~
S3 Vision868 Multimedia Accelerator
S3 Incorporated
Bits 31-24 Reserved
Video Engine Destination Base Address Register
ReadIWrite Address: 809CH
Power-On Default: 0000 OOOOH
Bits 23-0 DESTINATION BASE ADDRESS [23:0)
Destination base address (in bytes) in display memory for the image to be processed
by the Video Engine.
Bits 30-24 Reserved
Bit 31 VEB -Video Engine busy (Read Only)
0= Video Engine not busy
1 = Video Engine busy
2.7 Vision864 REGISTERS REMOVED FROM THE Vision868
All backward compatibility registers found in the Vision864 are removed from the Vision868. These
include all registers described in Sections 12 and 13 ofthe Vision864 Graphics Accelerator Data Book.
2-20 REGISTER CHANGES

S3 Vision868 Multimedia Accelerator
53 Incorporated
Section 3: Functional Changes
This section describes a number of enhance 6 MCLKs. At maximum, the bus can be granted
ments provided by the Vision868 as compared for 64 MCLKs.
with the Vision864. The new features related to
Enhanced mode programming support are de How long the secondary controller can retain
scribed in Section 4. The new Video Engine capa control without causing problems is a function of
bility for the Vision868 is described in Section 5. many variables, including the M and N parameter
setti ngs, the pixel data bandwidth of the
RAMDAC, the needs of the CPU and Graphics
3.1 CHIP IDENTIFICATION
Engine to access display memory and the timing
of the bus request (during screen active or inac
Three new chip identification registers are pro tive). In general, the secondary controller should
vided. CR2D is hardwired with 88H. This is the retain control for a period less than the time that
upper word of the device I.D .. CR2E is hardwired would normally be allocated to the M parameter,
with 90H. This is the low byte of the device I.D. and the time allocated to the P parameter should
CR2F contains the revision level. CR30, the old be subtracted from the time allocated to the M
I.D. register, contains E1H. parameter. For pure live video display without
graphics updating, the M parameter can be set to
o (allowing 1 memory cycle) and the rest of the
3.2 SHARED FRAME BUFFER
non-FIFO fill bandwidth given to the P parameter.
MEMORY BANDWIDTH
See Section 7.4, Display Memory Access Control,
ALLOCATION of the Vision864 data book for more information
on the M and N parameters.
The Vision868 provides the same bus re
For the Vision868, the M parameter field is 6 bits
quest/bus grant shared frame buffer capability as
instead of 5 bits for the Vision864. This doubles
the Vision864. However, several related new ca
the amount of memory bandwidth that can be
pabilities are added to enhance usability.
allocated to Graphics Engine/CPU accesses.
Since the Vision868 is responsible for screen and
DRAM refreshing, it must ensure that the secon 3.3 PCI ENHANCEMENTS
dary controller does not retain control of the
memory bus for too long. It uses the P parameter
The Vision868 contains several enhancements
to provide this control. The 6-bit P parameter field
for PCI bus operation.
(bits 5-0 of SRA) is programmed in units of
MCLKs. The value programmed specifies one
less than the number of MCLKs that the secon 3.3.1 Interrupt Support
dary controller can retain control of the memory
bus before the Vision868 removes the bus grant.
PCI configuration space registers Index 3CH (In
For example, a programmed value of 5 specifies
terrupt Line) and Index 3DH (Interrupt Pin) are
that the Vision868 will remove the bus grant after
added to support handling of interrupts.
FUNCTIONAL CHANGES 3-1

.lJa
p• .
S3 Vision868 Multimedia Accelerator
53 Incorporated
When in PCI mode, the INTA pin floats. Interrupt Vision868 also provides accelerated packed 24
generation drives it active low. When the inter bits/pixel operation. This means that 2 2/3 pixels
rupt is removed, the INTA pin again floats. can be processed simultaneously, resulting in an
approximately 25% performance improvement.
When in VL-Bus mode, the SINTR pin is driven Packed 24 bits/pixel operation is selected by set
high. Interrupt generation drives it low and then ting bits 5-4 of CR50 to 10b.
releases it to be driven high again (edge trig
gered). Most ofthe hardware acceleration features avail
able for 32 bits/pixel operation are also available
for packed 24 bits/pixel operation. Those func
3.3.2 RAMDAC Snooping
tions for which hardware acceleration is not pro
vided for packed 24 bits/pixel operation are:
For PCI bus configurations, setting bit 5 ofthe PCI
Command register (Index 04H) to 1 causes the • Textured line draw
Vision868 to snoop for RAMDAC writes. This
• BitBLT across the plane
means that the Vision868 will write the data to
the local RAMDAC but will not assert DEVSEL. • Color comparison
The ISA controller can then also generate a write • Video Engine operation (Vision868)
cycle to a secondary RAMDAC. The Vision868
always provides the data for RAMDAC reads. Image transfers (CPU as data source) can be
performed in packed 24 bits/pixel mode.
If snooping is enabled, the 3C8 and 3C9 DAC
registers must be written separately with byte When using packed 24 bits/pixel operation, all
writes (no word writes). drawing coordinates (e.g., current X,V or destina
tion X,V) must be positive numbers.
If bit 5 of the PCI Command register is cleared to
0, the Vision868 claims all RAMDAC read and
3.5 RAMDAC ACCESS CYCLES
write cycles.
The RAMDAC strobes DACRD and DACWR are
3.3.3 Disconnect Related to FIFO
based on MCLK forthe Vision864. They are based
Status on SCLK for the Vision868. The PCI bus RAMDAC
access functional timing for the Vision868 is
shown in Figures 3-1 and 3-2. VL-Bus cycles have
If bits 3 and 6 ofCR66 are setto 1, pixel data writes
the same timing characteristics.
made with the command FIFO full or memory
reads made with the Command FIFO not empty
The active pulse of DACRD or DACWR is 2 SCLKs
will generate a PCI disconnect.
if bit 1 of CR50 is cleared to 0 and 4 SCLKs if this
bit is set to 1. The latter setting is required for 50
3.3.4 Plug and Play Support MHz VL-Bus operation to ensure a pulse width
greater than 50 ns. Selecting a 4 SCLK active
pulse width extends the total cycle by 10 SCLKs.
When the Vision868 powers up in PCI mode, it
defaults to linear addressing and memory
mapped I/O enabled at a relocatable base ad 3.6 50 MHz VL-BUS SUPPORT
dress of 7000 OOOOH. This allows the PCI system
to reconfigure as required for plug and play.
Setting bit 3 of CR40 to 1 adds a wait state to
VL-Bus cycles by delaying SRDV by one clock.
3.4 PACKED 24-BITS/PIXEL This is required for 50 MHz VL-Bus operation. In
SUPPORT addition, bit 1 of CR50 must be set to 1 to extend
the RAMDAC read and write strobe pulses.
In 32 bits/pixel modes, the Graphics Engine can
process two pixels simultaneously (64 bits). The
3-2 FUNCTIONAL CHANGES

53 Vision868 Multimedia Accelerator
S3 Incorporated
0
N
f-
'"
;::::
00
;::::
....
;::::
ID
;::::
It)
;::::
.,
;::::
M
;::::
N
;::::
~
;::::
0
;::::
'"
f-
~
....
f-
ID
f-
Ift-)
;!
I:!
N
f-
;::::
I! i
( . e ~ .. n ) .I I~ 9 M . I~ I~ I~
Q
«
Figure 3-1. RAMDAC PCI Read Timing
FUNCTIONAL CHANGES 3-3

I'lL
w
.J:,.
""Tl
C
Z
| a ~    |     |     |     | ...   |
| ------ | --- | --- | --- | ----- |
i   --
z
:t>
o
( ")
I   T2  T4  T5  T6  T7  T8  T9  T10  T11  T12  T13  T14  T15
:t>  z
SCLK
Gl
m
(f)
on  FRAME ~
cE'
I:
AD[31:0] ~ -
| :   | DAC DATA FROM CPU  |     |     |     |
| --- | ------------------ | --- | --- | --- |
~
|     | \   |     | /   |     |
| --- | --- | --- | --- | --- |
;"  IRDY
::ts>:
o
| :t>  TRDY  |     |     | ~   |     |
| ---------- | --- | --- | --- | --- |
(')
| ~            |     |     |     | e n   |
| ------------ | --- | --- | --- | ----- |
| :Q E   - -   | \   |     | /   |       |
| DE VS EL     |     |     |     | w     |
<
____________________________________________________~   2~~~KS ~
| ~   |     |     |     | iii'  |
| --- | --- | --- | --- | ----- |
CD
| ::!  DACWR  |     |     |     | 0'    |
| ----------- | --- | --- | --- | ----- |
| 3           |     |     |     | :::J  |
:i"
00
0)
| RS[2:0] ~  |     |     | ~   | 00   |
| ---------- | --- | --- | --- | ---- |
| (Q         |     |     |     | s :  |
c
;:;
| GD[7:0] ~  |     | DACDATA  | a,~  | 3'  |
| ---------- | --- | -------- | ---- | --- |
CD
V8DACWR  c . .
iii'
»
C")
C")
CD
.C..D
III
.or.+.

••
r
S3 Vision868 Multimedia Accelerator
S3 Incorporated
3.7  WRITE PER BIT SUPPORT  For fast page  mode operation, read  data is
latched by the rising edge of CAS. For 2 cycle EDO
operation, the read data is latched by the rising
The Vision868 does not support write per bit and
edge of MCLK following a CAS rising edge.
bit 0 of CR53 is now reserved.
Note that both Figure 3-3 and 3-4 are based on a
| 3.8  READ/MODIFY/WRITE TIMING  |     |     | RAS precharge of 2.5 MCLKs.  |     |     |     |
| ------------------------------ | --- | --- | ---------------------------- | --- | --- | --- |
The read/modify/write cycles for fast page and
| EDO  memories have been  | modified from the  |     |     |     |     |     |
| ------------------------ | ------------------ | --- | --- | --- | --- | --- |
Vision864. These are shown in Figures 3-3 and
3-4.
|     | n  T2  | T3  T4  | T5  T6  | T7  | T8  T9  | no  |
| --- | ------ | ------- | ------- | --- | ------- | --- |
MCLK
______________
|     |     | \~  |     |     | ~r-- |     |
| --- | --- | --- | --- | --- | ---- | --- |
LJ
~
|       |          |     |         | 'fII.._  | ___            | :I  |
| ----- | -------- | --- | ------- | -------- | -------------- | --- |
| M A [ | 8 : 0]   |     | COLUMN  |          | C_OL_U_M_N __  |     |
M B[ 8 : 0 ]   _,--_R_O_W_--1X
LJ
PO[63:0]
Figure 3·3. Fast Page Mode Read/Modify Write Timing
no
|     | n  T2  T3  | T4  | T5  T6  | T7  | T8  T9  |     |
| --- | ---------- | --- | ------- | --- | ------- | --- |
MCLK
,~---------------------
LJ
)I(
| M A [ 8 : 0]   | ~~ ____RO_ W __~  | X COLUMN  |     |     |         | ~   |
| -------------- | ----------------- | --------- | --- | --- | ------- | --- |
| M B[ 8 : 0 ]   |                   |           |     |     | COLUMN  |     |
,'--_----1/
| PD[63:0]  | _   |     |     | READDATA  | •  WRITEDATA)I  |     |
| --------- | --- | --- | --- | --------- | --------------- | --- |
Figure 3·4. EDO Mode Read/Modify Write Timing
FUNCTIONAL CHANGES 3-5

S3 Vision868 Multimedia Accelerator
S3 Incorporated
3.9 1 CYCLE EDO DRAM SUPPORT This means that a dummy cycle is required at the
end to latch the last read. At the end of the cycle,
the memory controller remains in page mode
Bits 3-2 of CR36 are cleared to OOb to indicate that
and checks for another memory request. If one is
1 cycle EDO DRAM operation is being used. Note
that CAS/OE/WE stretch capability provided by pending, it performs the 1.5 MCLK RAS pr~­
charge as shown in Figure 3-5. If no request IS
bits 1-0 of CR68 cannot be used with 1 cycle EDO
operation. This mode of operation uses standard pending, the RAS prech~rge may be. delayed
from that shown in the fIgure and wIll be 2.5
EDO DRAMs with more aggressive timing.
MCLKs when it occurs.
The functional timing for 1 cycle EDO reads is
The functional timing for 1 cycle EDO writes is
provided by Figure 3-5. The DRAM drives val~d provided by Figure 3-6. Write data is latched by
read data after the first CAS falling edge. The chip
the DRAM on the falling edge of CAS. No dummy
latches the data on the second falling CAS edge.
cycle is required. At the end of the cycle, the
T1 T2 T3 T4 T5 T6 17 T8 T9 T10 111 110
MCLK
\L_ _______________
~I
CAS
MA[8:0] ~,..----R-O-W-----~
MB[8:0] "'~""""."."..'. "L ._ _________
\L.. ________- -JI
PD[63:0]
seEDOR
Figure 3-5. 1 Cycle EDO Read Timing
MCLK
\L ______________
~I
M MB A [8: [ 0] 8 ~ : L 0] . ~ ____R_OW_ ____. ~
\'--___1
PD[63:0]
""mow
Figure 3-6. 1 Cycle EDO Write Timing
3-6 FUNCTIONAL CHANGES

r-~ .
S3 Vision868 Multimedia Accelerator
53 Incorporated
memory controller remains in page mode and DRAM then generates subsequent sequential
checks for another memory request. If one is column addresses within the same page. Valid
pending, it performs the 1.5 MCLK RAS pre read data is driven by the DRAM after the falling
charge as shown in Figure 3-6. If no request is edge of each CAS and is latched by the next
pending, the RAS precharge may be delayed falling edge of CAS. Write data is driven to the
from that shown in the figure and will be 2.5 DRAM on each CAS rising edge.
MCLKs when it occurs.
When bursting is not feasible, such as across a
Figure 3-7 shows a read/modify/write cycle with page, for non-sequential addressing and for
1 cycle EDO operation. A dummy cycle is added read/modify/writes, the memory controller auto
between the read and write. matically use standard EDO operation instead.
All line draws, image transfers, linear addressing All line draws, image transfers, linear addressing
and pixel formatter operation are not supported and pixel formatter operation are not supported
with 1 cycle EDO. 2 cycle EDO operation will with burst mode DRAM. Standard EDO operation
automatically be used with these functions. will automatically be used with these functions.
3.10 BURST MODE DRAM SUPPORT
Bits 3-2 of CR36 are set to 01b to indicate that
burst mode DRAM operation is being used. Note
that CAS/OE/WE stretch capability provided by
bits 1-0 of CR68 cannot be used with burst mode
operation.
With burst mode DRAM, only the initial column
address is required. An internal counter in the
T1 T2 T3 T4 T5 T6 T7 T8 T9 T10
MCLK
______________
\~ ~r-
MA[8:0) ~~ ______RO __W_ ___________~
MB[8:0)
\~--~I
PD[63:0)
Figure 3-7. 1 Cycle EDO Read/Modify/Write Timing
FUNCTIONAL CHANGES 3-7

••
r
S3 Vision868 Multimedia Accelerator
S3 Incorporated
T1 T2 T3 T4 T5 T6 T7 T8 T9 T10
MCLK
---JI
\L--______
~
RAS
CAS
___
M M A B[ [ 8 8 : : 0 0 ] ] ~~ _____R_O __W_ ____~ X~ IN_IT_I_A_L_C_O_LU__M _N_ __ J~
____________________________
OE~ ~===~ ~r_
~
PD[63:0]_I..._ ___R_ D_1 __
BMREAD
Figure 3-8. Burst Mode Read Timing
T1 T2 T3 T4 T5 T6 T7 T8 T9 T10
MCLK
____________________________________
\~ ~r__
MA[8:0) ~\.. ...JX\.. __I N_IT_IA_L_C_O_L_U_M_N_~_
MB[8:0) ______R _O_W_ _____
\\.....-___- -...JI
PD[63:0)_~ ~
__W _R_1 __
BMWRITE
Figure 3-9. Burst Mode Write Timing
3-8 FUNCTIONAL CHANGES

fl·
r
S3 Vision868 Multimedia Accelerator
rf
S3 Incorporated  I
i!
Ij
I:
Section 4: Electrical Data  Ii
,I:'
l'
4.1  MAXIMUM RATINGS
Table 4-1.  Absolute Maximum Ratings
Ambient temperature  0° C to 70° C
Storage temperature  -40° C to 1250 C
DC Supply Voltage  -O.5V to 7.0V
I/O Pin Voltage with respect to Vss  -0.5V to VDD+0.5V
4.2  DC SPECIFICATIONS
Table 4-2.  DC Specifications (VDD = 5V ± 5%, Operating Temperature 00 C to 70° C)
| Svmbol  | Parameter            | Min           | Max        | Unit  |
| ------- | -------------------- | ------------- | ---------- | ----- |
| V,L     | Input Low Voltage    |               | 0.8        | V     |
| V,H     | Input High Voltage   | 2.0 (Note 1)  |            | V     |
| VOL     | Output Low Voltage   |               | Vss + 0.4  | V     |
|         | Output High Voltage  | 2.4           |            | V     |
VOH
| 10L1  | Output Low Current         | 4 (Note 2)   |     | mA  |
| ----- | -------------------------- | ------------ | --- | --- |
| IOH1  | Outgut High Current        | -2           |     | mA  |
| IOL2  | Output Low Current         | 8 (Note 3)   |     | mA  |
| IOH2  | Output High Current        | -4           |     | mA  |
| IOL3  | Output Low Current         | 16 (Note 4)  |     | mA  |
| IOH3  | Output High Current        | -8           |     | mA  |
| IOL4  | Output Low Current         | 24 (Note 5)  |     | mA  |
| IOH4  | Output High Current        | -10          |     | mA  |
| IOL5  | Output Low Current (TIL)   | 9 (Note 6)   |     | mA  |
| IOH5  | Output High Current (TIL)  | -9           |     | mA  |
| loz   | Output Tri-state Current   |              | 1   | uA  |
|       | Input Capacitance          |              | 5   | pF  |
C'N
| COUT  | Output Capacitance    |     | 5    | pF  |
| ----- | --------------------- | --- | ---- | --- |
| Icc   | Power Supply Current  |     | 425  | mA  |
ELECTRICAL DATA 4-'

S3 Vision868 Multimedia Accelerator
S3 Incorporated
Notes for Table 4·2
1. 2.4 V Max for SCLK
2. lOLl, IOHl for pins BLANK, CAS[7:0), DACRD, DACWR, GD[7:0), HSYNC, INTA (SINTR)
MA[8:0), MB[8:0), PA[15:0), PD[63:0), RS[2:0), RMSTRD, STWR, VSYNC, BGNT
3. IOL2, IOH2 for pin VCLK
4. lOla, IOH3 for pins OE[1:0), RAS[1:0)
5. IOL4, IOH4 for pins PAR (ABEN), STOP (DBEN), DEVSEL (LOCA), TRDY (SRDY), WE[1:0)
6. IOL5,loH5 for pins AD[31:0), DBDIR
Note
Pin names for VL-Bus configurations are shown in parentheses.
4.3 AC SPECIFICATIONS
Notes:
1. A" AC timings are based on an 80 pF test load.
2. Functional timing diagrams are found in the appropriate functional descriptions section, i.e.,
System Bus Interfaces, Display Memory or Misce"aneous Functions in the Vision864 data
book or Functional Changes in this data booklet.
4-2 ELECTRICAL DATA

S3 Vision868 Multimedia Accelerator
S3 Incorporated
4.3.1  Clock Timing
|     | 2.0\1 --- | ---------------        | ---                 |     |     |
| --- | --------- | ---------------------- | ------------------- | --- | --- |
|     | 1.5\1 --- | ------------------     | ------------------- |     |     |
|     | 0.8\1 --- | - -------------------- | ---------------     |     |     |
|     |           | 14-----T               | cyC ------., elK    |     |     |
Figure 4-1. Clock Waveform Timing
Table 4-3.  Clock Waveform Timing
| Symbol  | Parameter                        |     | Min   | Max  | Units  Notes  |
| ------- | -------------------------------- | --- | ----- | ---- | ------------- |
| Tcyc    | SCLK Cycle Time (VL-Bus)         |     | 20    | 125  | ns  1         |
|         | SCLK Cycle Time (PCI)            |     | 30    | 125  | ns  1         |
|         | MCLK Cycle Time                  |     | 16.7  | 25   | ns  3         |
|         | MCLK Cycle Time                  |     | 20    | 25   | ns  4         |
|         | DCLK Cycle Time WGA Mode)        |     | 25    | 100  | ns  1         |
|         | DCLK Cycle Time (Enhanced Mode)  |     | 10    | 100  | ns  1         |
| THIGH   | SCLK High Time (VL-Bus)          |     | 8     | 80   | ns            |
|         | SCLK High Time (PCI)             |     | 12    | 80   | ns            |
|         | MCLK High Time                   |     | 6     | 10   | ns  3         |
|         | MCLK High Time                   |     | 8     | 12   | ns  4         |
|         | DCLK High Time WGA Mode)         |     | 10    | 65   | ns            |
|         | DCLK High Time (Enhanced Mode)   |     | 4     | 65   | ns            |
| TLQW    | SCLK Low Time (VL-Bus)           |     | 8     | 80   | ns            |
|         | SCLK Low Time (PCI)              |     | 12    | 80   | ns            |
|         | MCLK Low Time                    |     | 6     | 10   | ns  3         |
|         | MCLK Low Time                    |     | 8     | 12   | ns  4         |
|         | DCLK Low Time (VGA Mode)         |     | 10    | 65   | ns            |
65
|     | DCLK Low Time (Enhanced Mode)  |     | 4   |     | ns       |
| --- | ------------------------------ | --- | --- | --- | -------- |
|     | SCLK. MCLK. DCLK Slew Rate     |     | 1   | 4   | V/ns  2  |
Notes:
1.  fOCLK ~ 1/2 fSCLK to ensure valid writes to the clock chip.
2.  Rise and fall times are specified in terms of the edge rate measured in V/ns. This slew rate
must be met across the minimum peak-to peak portion of the clock waveform.
3.  For fast page and standard EDO DRAM
4.  For single cycle EDO and burst mode DRAM
ELECTRICAL DATA 4-3

53 Vision868 Multimedia Accelerator
S3 Incorporated
4.3.2  Input/Output Timing
SCLK
1.5V
MCLK
DCLK
|     | INPUT  | 1.5V  | 1.5V  |     |
| --- | ------ | ----- | ----- | --- |
elKIN
Figure 4-2. Input Timing
Table 4-4.  SCLK-Referenced Input Timing
PCIBus
| Symbol  | Parameter                                       |     | Min  | Units  |
| ------- | ----------------------------------------------- | --- | ---- | ------ |
| Tsu     | AD[31 :0], C/BE[3:0], FRAME, IRDY, IDSEL setup  |     | 7    | ns     |
| TH      | AD[31 :0] hold                                  |     | 1    | ns     |
| TH      | C/BE[3:0], FRAME, IRDY, IDSEL hold              |     | 0    | ns     |
VL-Bus
| Symbol  | Parameter                                      |     | Min  | Units  |
| ------- | ---------------------------------------------- | --- | ---- | ------ |
| Tsu     | AD[31:21. BE[3:0]' SM/IO, SW/R, SADS (address  |     | 12   | ns     |
phase) setup
| TH  | AD[31 :2], BE[3:0]' SM/IO, SW/R, SADS (address  |     | 0   | ns  |
| --- | ----------------------------------------------- | --- | --- | --- |
phase) hold
| Tsu  | AD[31:21. BE[3:0]' D1, DO, SADS (data phase)  |     | 4   | ns  |
| ---- | --------------------------------------------- | --- | --- | --- |
setup
TH  AD[31 :21. BE[3:0]' D1, DO, SADS (data phase) hold  0  ns
| Tsu  | RDYIN setup  |     | 6   | ns  |
| ---- | ------------ | --- | --- | --- |
| TH   | RDYIN hold   |     | 1   | ns  |
Miscellaneous
| Symbol  | Parameter                         |     | Min  | Units  |
| ------- | --------------------------------- | --- | ---- | ------ |
| Tsu     | ROM Data GD[7:0] Setup (PCI)      |     | 5    | ns     |
| TH      | ROM Data GD[7:0] Hold (PCI)       |     | 7    | ns     |
| Tsu     | General Input Port GD[7:0] setup  |     | 5    | ns     |
| TH      | General Input Port GD[7:0] hold   |     | 7    | ns     |
4-4 ELECTRICAL DATA

53 Vision868 Multimedia Accelerator
53 Incorporated
SCLK
MCLK  1.5 V
DCLK
DELAY
OUTPUT  1.5V
Figure 4-3. Output Timing
Table 4-5.  SCLK-Referenced Output Timing
PCIBu5
| Parameter              | TMIN  TMAx  | Units  Notes       |
| ---------------------- | ----------- | ------------------ |
| AD[31 :0] valid delay  | 2  16       | ns  1              |
| DEVSEL, PAR            | 2  11       | ns  Medium DEVSEL  |
| delay                  |             | timin9_ used       |
| STOP delay             | 2  11       | ns                 |
| TRDYdeiay              | 2  11       | ns                 |
| INTA delay             | 2  11       | ns                 |
VL-Bus
| Parameter                                  | TMIN  TMAX  | Units  Notes  |
| ------------------------------------------ | ----------- | ------------- |
| AD[31 :21. D1, DO valid delay              | 7  16       | ns            |
| SINTR delay                                | 5  30       | ns            |
| SRDYdeiay                                  | 5  11       | ns            |
| LOCA active delay                          | 5  15       | ns            |
| LOCA inactive delay                        | 5  20       | ns            |
| DBDIR delay                                | 5  16       | ns            |
| ABEN, DBEN active delay (min non-overlap)  | 5  12       | ns            |
| ABEN, DBEN active delay (max non-overlap)  | 5  15       | ns            |
| ABEN, DBEN inactive delay                  | 5  13       | ns            |
Miscellaneous
| Parameter  | TMIN  TMAX  | Units  Notes  |
| ---------- | ----------- | ------------- |
RS[2:0] delay
|                                     | 5  25  | ns  |
| ----------------------------------- | ------ | --- |
| RMSTRD delay                        | 3  15  | ns  |
| ROM Address valid delay (PCI)       | 5  30  | ns  |
| AD[7:0] ROM Data valid delay (PCI)  | 5  30  | ns  |
;
| DACRD, DACWR delay  | 3  20  | ns  |
| ------------------- | ------ | --- |
Note
1.  Due to the timing for TROY for read cycles, data is not sampled on the clock edge immediately
following its becoming valid. This guarantees the PCI 2.0 specification time of 11 ns.
ELECTRICAL DATA 4-5

53 Vision868 Multimedia Accelerator
S3 Incorporated
Table 4-6.  MCLK-Referenced Input Timing
| Symbol  | Parameter  |     | Min  | Units  |
| ------- | ---------- | --- | ---- | ------ |
PD[63:0J setup (EDO memory)
| Tsu  |                                   |     | 0   | ns  |
| ---- | --------------------------------- | --- | --- | --- |
| TH   | PD[63:0J hold (EDO memory)        |     | 10  | ns  |
| Tsu  | General Input Port GD[7:0J setup  |     | 5   | ns  |
| TH   | General Input Port GD[7:0J hold   |     | 7   |     |
ns
Table 4-7.  MCLK-Referenced Output Timing
| Parameter                                 |     | TMIN  | TMAX  | Units  |
| ----------------------------------------- | --- | ----- | ----- | ------ |
| RAS[l :OJ  active delay                   |     | 5     | 15    | ns     |
| RAS[l :OJ  inactive delay                 |     | 5     | 14    | ns     |
| CAS[7:0J OE[l :0]. WE[l :OJ active delay  |     | 7     | 15    | ns     |
CAS[7:0]. OE[l :0]. WE[l :OJ inactive delay (min stretch)  6  8  ns
for fast page and standard EDO DRAM
CAS[7:01. OE[l :0]. WE[l :OJ inactive delay (max stretch)  6  17  ns
for fast page and standard EDO DRAM
CAS[7:0J active delay with respect to falling edge of  6  15  ns
MCLK for 1 cycle EDO and burst mode
operation
| MA[8:0J, MB[8:0] valid delay  |     | 5   | 24  | ns  |
| ----------------------------- | --- | --- | --- | --- |
| PD[63:0J valid delay          |     | 5   | 27  | ns  |
Table 4-8.  DCLK-Referenced Output Timing
| Parameter                               |     | TMIN  | TMAX  | Units  |
| --------------------------------------- | --- | ----- | ----- | ------ |
| BLANK,HSYNC,VSYNC                       |     | 3     | 17    | ns     |
| VCLK delay                              |     | 7     | 14    | ns     |
| PA[15:0] valid delay                    |     | 5     | 14    | ns     |
| STWR delay                              |     | 3     | 20    | ns     |
| General Output Port Data GD[7:0J delay  |     | 5     | 25    | ns     |
Table 4-9.  Fast Page, 1 Cycle EDO, Burst Mode Memory Input Timing
| Symbol  | Parameter                            |     | Min  | Units  |
| ------- | ------------------------------------ | --- | ---- | ------ |
|         | PD[63:0J setup to CAS[7:0J inactive  |     | 0    | ns     |
Tsu
| TH  | PD[63:0J hold from CAS[7:0J inactive  |     | 5   | ns  |
| --- | ------------------------------------- | --- | --- | --- |
4-6 ELECTRICAL DATA

S3 Vision868 Multimedia Accelerator
S3 Incorporated
SRESET,RESET
SYSTEM
CONFIGURATION
DATA
Figure 4-4. Reset Timing
Table 4-10.  Reset Timing
| Symbol  | Parameter  | Min  | Units  |
| ------- | ---------- | ---- | ------ |
SRESET (VL) or RESET (PCI) active pulse width
| TLOW  |                                               | 400  | ns  |
| ----- | --------------------------------------------- | ---- | --- |
| Tsu   | PD[23:0] setup to SRESET (VL) or RESET (PCI)  | 20   | ns  |
inactive
| TH  | PD[23:0] hold from SRESET (VL) or RESET (PCI)  | 10  | ns  |
| --- | ---------------------------------------------- | --- | --- |
inactive
4.4 OUTPUT BUFFER MODEL
Figure 4-5 shows a first order output buffer model for the Vision868. The parameters are:
| Parameter  | Description  |     |     |
| ---------- | ------------ | --- | --- |
dV/dt  Mininum and maximum rate of change of the open circuit voltage source used in the
buffer model
Ro  Minimum and maximum output impedance of the buffer model
Co  Minimum and maximum capacitance used in the buffer model
| Lp  | Minimum and maximum package inductance   |     |     |
| --- | ---------------------------------------- | --- | --- |
| Cp  | Minimum and maximum package capacitance  |     |     |
The parameter values appropriate for the Vision868 depend on the manufacturing process and can be
obtained directly from 53.
ELECTRICAL DATA 4-7

S3 Vision868 Multimedia Accelerator
S3 Incorporatad
Ro
Figure 4-5. First Order Output Buffer Model
4-8 ELECTRICAL DATA

....
r
S3 Vision868 Multimedia Accelerator
S3 Incorporated
Section 5: Enhanced Mode Programming
Enhanced mode provides a level of performance far beyond what is possible with the VGA architecture.
Hardware line drawing, BitBL T, rectangle fill and other drawing functions are implemented. Also
implemented are data manipulation functions, such as data extension, data source selection, and
read/write bitplane control. Hardware clipping is supported by 4 registers that define a rectangular
clipping area. While in Enhanced mode, the display memory bit map can be updated in two ways. One
is to have the CPU write directly to memory. (This is also possible in non-Enhanced modes via paging.)
The other is to have the CPU issue commands to the Graphics Engine, which then controls pixel
updating. This section explains these two methods and provides a comprehensive set of Enhanced
mode programming examples.
5.1 MEMORY-MAPPED 1/0
The Vision868 provides two memory-mapped I/O (MMIO) schemes. One method is identical to that
provided by the Vision864 and provides compatibility with older software. This provides memory
mapping of a limited number of Enhanced mode registers. The second method is new to the Vision868.
It incorporates linear addressing and provides memory mapping of all registers. In addition, the
Enhanced mode registers can be accessed by a packed method that improves performance by allowing
two 16-bit registers to be accessed by a single 32-bit write cycle. More registers can be accessed via
the packed method than by the standard method. Each of these MMIO methods is described below.
5.1.1 Backward-Compatible MMIO
Most of the Enhanced registers can be memory-mapped. This function is enabled by setting bits 4-3
of CR53 to 10b. When bit 3 of CR53 is cleared to 0, the old MMIO can also be enabled by setting bit 5
of 4AE8H to 1.
Image writes normally made via I/O addresses E2E8H and E2EAH (the Pixel Data Transfer registers)
are made instead by accessing any memory location in the 32-KByte address space from AOOOOH to
A7FFFH. This allows efficient use ofthe MOVSW and MOVSD assembly language commands. Accesses
must be to even word or doubleword addresses, depending on the specification of the bus width via
bits 10-9 of 98E8H. Software must not make E2E8H, E2EAH writes beyond the A7FFFH range.
Accesses to the Enhanced command registers are made to particular locations in the A8000H to AFFFFH
address range as shown in Table 5-1. Both 16-bit reads and writes are supported. Only 32-bit writes
(bit 9 of BEE8H_E set to 1) are supported.
ENHANCED MODE PROGRAMMING 5-1

S3 Vision868 Multimedia Accelerator
S3 Incorporated
Table 5-1.  Enhanced Registers Memory Mapping
| Register Mnemonic         | 1/0 Address (Hex)  | Register    | PackedMMIO    |
| ------------------------- | ------------------ | ----------- | ------------- |
|                           | Old MMIO = Axxxx   | Mnemonic    | Offset (Hex)  |
|                           |                    | (Packed)    | (100xxxx)     |
| CUR Y, CUR X              | 82E8,86E8          | ALT CURXY   | 8100,8102     |
| CUR Y2, CUR X2            | 82EA,86EA          | ALT CURXY2  | 8104,8106     |
| DESTY AXSTP,DESTX DIASTP  | 8AE8,8EE8          | ALT STEP    | 8108,810A     |
| Y2 AXSTP2, X2 DIASTP2     | 8AEA,8EEA          | ALT STEP2   | 810C,810E     |
| ERR TERM, ERR TERM2       | 92E8,92EA          | ALT ERR     | 8110,8112     |
| CMD, CMD2                 | 9AE8,9AEA          | ALT CMD     | 8118,811A     |
| SHORT STROKE              | 9EE8               |             | 811C          |
BKGD_COLOR
|                         | A2E8            |          | 8120        |
| ----------------------- | --------------- | -------- | ----------- |
| FRGD COLOR              | A6E8            |          | 8124        |
| WRT MASK                | AAE8            |          | 8128        |
| RD  MASK                | AEE8            |          | 812C        |
| COLOR CMP               | B2E8            |          | 8130        |
| BKGD MIX, FRGD MIX      | B6E8, BAE8      | ALT MIX  | 8134,8136   |
| SCISSORS T, SCISSORS R  | BEE8 1, BEE8 2  |          | 8138, 813A  |
| SCISSORS B, SCISSORS_R  | BEE8 3, BEE8 4  |          | 813C, 813E  |
| PIX CNTL, MULT MISC2    | BEE8 A, BEE8 D  |          | 8140,8142   |
| MULT  MISC, READ SEL    | BEE8 E, BEE8 F  |          | 8144,8146   |
MIN AXIS PC NT, MAJ AXIS PC NT  BEE8 0,96E8  ALT PCNT  8148, 814A
| MAJ AXIS PCNT2               | 96EA        |            | 814C        |
| ---------------------------- | ----------- | ---------- | ----------- |
| ROPMIX                       | D2E8        |            | 8150        |
| DESTX DIASTP, MAJ AXIS peNT  | 8EE8,96E8   | MAXX       | 8154,8156   |
| PIX TRANS                    | E2E8, E2EA  | PIX-TRANS  | 0000        |
| PAT BG  COLOR                | E6E8        |            | 8164        |
| PAT Y, PAT X                 | EAE8,EAEA   | ALT PAT    | 8168, 816A  |
| PAT FG COLOR                 | EEE8        |            | 816C        |
5.1.2  New MMIO
The new MMIO method for the Vision868 provides a 64-MByte addressing window starting at the base
address specified in CR59-5A. This space is divided into a 32-MByte space for little endian lintel-style)
addressing and a 32-MByte space for big endian (Power PC-style) addressing. All registers and data
transfer locations are mapped into this area as shown in Table 5-2.
The new MMIO is enabled by setting bits 4-3 of CR53 to 11 b. This is the default for a PCI  bus
configuration, allowing PCI software immediate access to all registers and the ability to relocate the
address space. VL-Bus configurations power up with bits 4-3 of CR53 cleared to OOb, disabling both
old and new MMIO operation.
If either the old or new MMIO is enabled, bit 7 of SR9 allows register access to be either programmed
I/O liN, OUT) or MMIO (MOV) or MMIO only.
5-2 ENHANCED MODE PROGRAMMING

....
r
S3 Vision868 Multimedia Accelerator
S3 Incorporated
Table 5-2. New MMIO Addresses
Descr~ion Memory Map Offset
Low 32 MBytes: little Endian A[25:0] Hex
Linear Addressing (16M) 000 OOOO:OFF FFFF
Imaqe Transfer Data (via E2E8. E2EA) (32K) 100 0000:100 7FFF
PCI Configuration Space 100 8000:100 803F
Packed Enhanced Registers 1008100:100 816F
Current V-Position Register 100 82E8
Current V-Position 2 Register 100 82EA
VGA 3B? Registers 100 83BO:l00 83BX
VGA 3C? Registers 100 83CO:l00 83CX
VGA 3D? Reqisters 100 83DO:l00 83DX
Setup Option Select Reqister (1 02H) 1008502
Subsystem Status Enhanced Register (42E8H) 1008504
Video Subs},stem Enable Register (46E8H) 1008508
Advanced Function Control Register (4AE8H) 100 850C
Enhanced Mode Registers 100 86E8:100 EEEA
Pixel Formatter Data Transfer 1010000:1013FFF
Pixel Formatter Mask Data 1014000:1017FFF
Pixel Formatter Registers 1018080:101809F
High 32 MBytes: Big Endian A[25:0] Hex
Linear Addressinq (16M) 200 0000:2FF FFFF
Image Transfer Data (via E2E8. E2EA) (32K) 3000000:3007FFF
PCI Configuration Space 300 8000:300 803F
Packed Enhanced Registers 3008100:300 816F
Current V-Position Register 300 82E8
Current V-Position 2 Register 300 82EA
VGA 3B? Registers 300 83BO:300 83BX
VGA 3C? Registers 300 83CO:300 83CX
VGA 3D? Registers 300 83DO:300 83DX
Setup Option Select Register (1 02H) 3008502
Subsystem Status Enhanced Register (42E8H) 3008504
Video Subsystem Enable Register (46E8H) 3008508
Advanced Function Control Register (4AE8H) 300 850C
Enhanced Mode Registers 300 86E8:300 EEEA
Pixel Formatter Data Transfer 301 0000:301 3FFF
Pixel Formatter Mask Data 301 4000:301 7FFF
Pixel Formatter Registers 301 8080:301 809F
The base address is taken from bits 31-26 of the linear address window position (bits 7-2 of CR59 or
the high order 6 bits of the the PCI Base Address 0). This is concatenated with the address offset
specified by the programmer per Table 5-2. The base address bits must not be all O·s. as this may cause
operating system address spaces to be overwritten.
ENHANCED MODE PROGRAMMING 5-3

S3 Vision868 Multimedia Accelerator
S3 Incorporated
When the new MMIO is enabled, both 16-bit MMIO reads and writes are supported. Only 32-bit writes
are supported.
5.1.2.1 Big/Little Endian Support
The Vision868 provides support for both big and little endian addressing. In addition to using the new
MMIO addressing as shown in Table 5-2, the required byte swapping must be specified as shown in
Table 5-3.
Table 5-3. Big Endian Byte Swap Select
Byte Swapping Affects: SwappingSpecified by:
Linear Addressing, Video Engine (read/write) CR53, bits 2-1
Image Data (writes to Graphics Engine) CR61, bits 6-5
All other registers/data areas (read/write) CR54, bits 1-0
5.1.2.2 Packed MMIO Register Mapping
For improved performance, most of the Enhanced mode registers can also be accessed via a packed
configuration. The 16-bit registers are paired so that two registers can be accessed via a single 32-bit
write. Reads must be 16-bit. The address offsets from the base address for this packed configuration
are given in Table 5-1. The packed register access function is enabled when the new MMIO is enabled
(bit 3 of CR53 setto 1).
5.2 DIRECT BITMAP ACCESSING-LINEAR ADDRESSING
Linear addressing is useful when software requires direct access to display memory. The Vision868
provides two linear addressing schemes. One is the same as provided for the Vision864 and thus
provides compatibility with older software. The second is integrated into the new memory-mapped
I/O method and thus requires updated drivers for use.
5.2.1 Backward-Compatible Linear Addressing
Enhanced mode operation must be enabled before linear addressing is enabled. This means that bit
o
of 4AE8H is set to 1 to enable Enhanced mode functions and bit 3 of CR31 is set to 1 to specify
Enhanced mode memory mapping.
The Vision868 provides linear addressing of up to 4 MBytes of display memory. Linear addressing of
more than 64 KBytes requires that Intel-style CPUs be operated in 386 protected mode.
The Graphics Engine busy flag, bit 9 of 9AE8H, should be verified to be 0 (not busy) before linear
addressing is enabled. This is done by setting bit 4 of CR58 or bit 4 of 4AE8H to 1. The size of the linear
address window is set via bits 1-0 of CR58. The base address for the linear addressing window is set
via CR59 and CR5A (or via the Base Address 0 (Index 10H) PCI configuration register for PCI systems).
The linear addressing window size can be set to 64 KBytes. The base address for the window is set by
programming bits 31-16 of the window position in CR59-CR5A. This allows the CPU to be operated in
real mode. If bit 0 of CR31 is set to 1, the memory page offset (64K bank) specified in bits 5-0 of CR6A
5-4 ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
S3 Incorporated
is added to the linear addressing window position base address, allowing access to up to 4 MBytes of
display memory through a 64-KByte window.
5.2.2 New Linear Addressing
The first 16 MBytes of each 32M address space (big and little endian) are dedicated to linear addressing.
A maximum of 4 MBytes of each address space (starting at the lowest address of the space) is usable
with the Vision868. When the new MMIO is enabled (bits 4-3 of CR53 set to 11 b), the base address is
taken from bits 31-26 of the linear address window position (bits 7-2 of CR59 or the high order 6 bits
of the the PCI Base Address 0). This is concatenated with the display memory address specified by the
programmer.
In addition to enabling the new MMIO, the programmer must also enable linear addressing and specify
the window size exactly as required for the old linear addressing. Note that since only bits 31-26 are
used to specify the base address, AOOOOH cannot be specified and the 64K banking scheme possible
with the old linear addressing cannot be used with the new linear addressing.
When big endian addressing is used, the required byte swapping for linear addressing is specified by
bits 2-1 of CR53. This applies to both reads and writes.
5.3 BITMAP ACCESS THROUGH THE GRAPHICS ENGINE
When updating the display bitmap through the Graphics Engine, all CPU data moves through the Pixel
Data Transfer registers (E2E8H and E2EAH). These can be memory mapped as explained in Memory
Mapping of Enhanced Mode Registers later in this section.
The Graphics Engine manipulates the bits for each pixel to assign a color value, which is then translated
by the RAMDAC into the color displayed on the CRT. Selected bits in a pixel can be masked off from
being displayed by programming the DAC Mask register (3C6H). The Vision868 can manipulate 64 bits
each clock cycle, from two 32-bit pixels to eight 8-bit pixels.
Figure 5-1 is a flowchart for the process of updating the color of each pixel in the display bitmap. Start
at the block labeled 'New Color' in the middle of Figure 5-1. At this stage, a color has been determined
that mayor may not be used to update a pixel in the bitmap. How this color is determined will be
covered later.
The first hurdle for the new color is the color compare process. If this is turned off (bit 8 of BEE8H,
Index OEH = 0), the new color is passed to the Write Mask register (AAE8H). If the plane to which the
pixel update is directed has been masked off in this register, no update occurs. Otherwise, the new
color value is written to the bitmap.
If color compare is enabled (bit 8 of BEE8H, Index OEH = 1), the new color value (source) is compared
to a color value programmed into the Color Compare (B2E8H) register. The sense of the color
comparison is determined by the SRC NE (source not equal) bit (bit 7) of BEE8H, Index OEH. If this bit
is 0, the new pixel color value is passed to the write mask only when the source color does not match
the color in the Color Compare register. If this bit is 1, the new pixel color value is passed to the write
mask only when the source color matches the color in the Color Compare register. If the new pixel
color value is not passed to the write mask, no update occurs. Notice that the source color is used for
the comparison, as opposed to the destination (bitmap) color used by the standard VGA color compare
operation.
ENHANCED MODE PROGRAMMING 5-5

••
r
S3 Vision868 Multimedia Accelerator
S3 Incorporated
MASK BIT SOURCE
COLOR SOURCE A  COLOR SOURCE B
NO
| SRC NE = 0  |     | =   |     |
| ----------- | --- | --- | --- |
SRC NE  1
| COLOR COMP = TRUE  |        | COLOR COMP = TRUE  |        |
| ------------------ | ------ | ------------------ | ------ |
| =                  |        | =                  |        |
| SRC NE  1          |        | SRC NE  0          |        |
|                    | =      |                    | =      |
| COLOR COMP         | FALSE  | COLOR COMP         | FALSE  |
COLOR
COMPARE
NEW PIXEL COLOR  PIXUPDT
Figure 5-1. Pixel Update Flowchart
5-6 ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
53 Incorporated
There are two approaches to determining the new color. One approach is depicted in Figure 5-1 and
is described next. The second approach is used with the ROPBL T command and is described at the
end of this section.
For all commands except a ROPBL T, the new color is the result of a logical mix performed on a color
source and the current color in the bitmap. For example, the color source could be XORed with the
bitmap color. The new color can also be selected by operating on only the color source or the bitmap
color, e.g., NOT color source. Both the color source and the logical mix operation are specified in either
the Background Mix register (B6E8H) or the Foreground Mix register (BAE8H). Which of these two
registers is used is determined by the settings of bits [7:6) of the Pixel Control register (BEE8H, Index
OAH).
To set up the pixel color updating scheme, the programmer specifies one of four color sources by
writing bits 6-5 of the Background Mix and Foreground Mix registers. The color sources are:
• Background Color register (A2E8H)
• Foreground Color register (A6E8H)
• CPU (via the Pixel Data Transfer registers (E2E8H, E2EAH))
• Current display bitmap color
One of 16 logical operations is chosen by writing bits 3-0 of the Background Mix and Foreground Mix
registers. Examples of logical operations are making the new pixel color index equal to the NOT of the
current bitmap color or making the new color value equal to the XOR of the source and current bitmap
color values.
When the logical operation and color source have been specified in the Background and Foreground
Mix registers, bits 7-6 of the Pixel Control register are written to specify the source of the mask bit
value. If the resulting mask bit is a 'ONE', the Foreground Mix register is used to determine the color
source and mix. If the mask bit is a 'ZERO', the Background Mix register is used to determine the color
source and mix. There are three sources for the mask bit value:
• Always ONE (Foreground Mix register used)
• CPU (via the Pixel Data Transfer registers (E2E8H, E2EAH))
• Bitmap (display)
Setting bits 7-6 to OOb sets the mask bit to 'ONE'. All drawing updates to the display bitmap use the
Foreground Mix register settings. This setup is used to draw solid lines, through-the-plane image
transfers to display memory and BitBL Ts.
If bits 7-6 are set to 10b, the mask bit source is the CPU. After the draw operation command is issued
to the Drawing Command register (9AE8), a mask bit corresponding to every pixel drawn on the display
must be provided via the Pixel Data Transfer register(s). If the mask bit is 'ONE', the Foreground Mix
register is used. If the mask bit is 'ZERO', the Background Mix register is used. Note that if the color
source is the CPU, the mask bit source cannot also be the CPU, and vice versa. This setup is used to
transfer monochrome images such as fonts and icons to the screen.
If bits 7-6 are set to 11 b, the current display bit map is selected as the mask bit source. The Read Mask
register (AAE8H) is set up to indicate the active planes. When all bits of the read-enabled planes for a
pixel are a 1, the mask bit 'ONE' is generated. If anyone of the read-enabled planes is a 0, then a mask
bit 'ZERO' is generated. If the mask bit is 'ONE', the Foreground Mix register is used. If the mask bit is
'ZERO', the Background Mix register is used. Note that if the color source is the bitmap, the mask bit
ENHANCED MODE PROGRAMMING 5-7

53 Vision868 Multimedia Accelerator
53 Incorporated
source cannot also be the bitmap, and vice versa. This setting is used to BitBlT patterns and character
images.
The ROPBlT command provides 256 raster operations that define the new color. Each operation
involves one or more of a color source, an off-screen pattern and a destination color. These colors can
be combined via various logical operations as specified in Appendix A. The source can be the CPU or
current bitmap and can be color or monochrome. The pattern can also be either color or monochrome.
The destination is always the current bitmap (screen) and is always color. Certain ROPBlT raster
operations are equivalent to other commands. For example, if the source is the current bitmap and no
pattern is used, this is the same operation as a BitBlT . ROPBlT s should not be used for image transfers
(source is the CPU) when the raster operation does not include a source, e.g., Dn (NOT destination, or
invert the destination bits). Instead, use the appropriate image transfer command.
5.4 PROGRAMMING
Three different programming schemes are available, I/O, standard MMIO and packed register MMIO.
Examples of how each is used to assign vertical and horizontal coordinates to Current X and Y Position
registers (82E8H and 86E8H) are:
I/O Format:
MOV DX,CUR_X
MOV AX,X
OUT DX,AX
MOV DX,CUR_Y
MOV AX,Y
OUT DX,AX
Standard MMIO Format:
EnableMMIO
Point ES to AOOOH (old MMIO) or base address (new MMIO)
load x and y values into AX and BX
MOV ES:[CUR_Y J, BX
MOV ES:[CUR_X], AX
Packed Register MMIO:
EnableMMIO
Point ES to AOOOH (old MMIO) or base address (new MMIO)
load the x and y values into EAX (y value in the low word and x value in the high word), I.e.,
31 15 0
I
EAX<== X Y
MOV ES:[AlT _CURXY], EAX
The packed register MMIO scheme is the most efficient and is used where appropriate in the
programming examples provided later in this section. All assume that the ES register points to AOOOH
is the old MMIO is being used or the base address if the new MMIO is being used.
5-8 ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.1 Notational Conventions
The REGMNEMONIC on the left hand side of the arrow is the register mnemonic of the I/O port being
written into. Text following a ';' is a comment.
REGMNEMONIC <= XXXXH ; Load a hexadecimal value into the register.
REGMNEMONIC <= XXXXD ; Load a decimal value into the register.
REGMNEMONIC <= XXXX ; Load a decimal value into the register
REGMNEMONIC <= XXXXXXXXXXXXXXXXB ; Load a binary value into the register.
Image transfers (CPU pixel data writes to the frame buffer) are notated as follows:
COUNT
PIX_TRANS <= IMAGEDATA
The COUNT is the number of CPU writes. PIX_TRANS means either the E2E8H, E2EAH pixel transfer
registers or the 32K memory space from AOOOOH to A7FFFH as explained in Section 5.1.1 above or
to the alternate 32K area when using the new MMIO as shown in Table 5-2.
5.4.2 Initial Setup
All examples assume the desired mode is selected.
The Bitmap Access Through the Graphics Engine section earlier in this section explains in detail how
the colors, mixes and the data extensions are set for each example. These registers need not be set
repeatedly before a series of draw commands if they use the same colors, mixes and data extension.
All bitmap updates are affected by the settings in the clipping registers (BEE8H, Indices 1-4) and the
choice of internal or external clipping (BEE8H, Index E, bit 5). These must be set up so they include the
area being drawn into.
If color compare is to be used, it must be enabled by setting bit 8 of BEE8H, Index OEH to 1. Bit 7 of this
register determines whether a TRUE or FALSE comparison allows the pixel update to continue. The
comparison color is programmed into the Color Compare register (B2E8).
All planes are enabled for writing unless explicitly set otherwise in an example. This is done via the
Write Mask register (AAE8H).
ENHANCED MODE PROGRAMMING 5-9

S3 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3 Programming Examples
This section provides programming examples for the following Enhanced mode drawing operations:
• Solid Line
• Textured Line
• Rectangle Fill Solid
• Image Transfer-Through the Plane
• Image Transfer-Across the Plane
• BitBLT-Through the Plane
• BitBLT - Across the Plane
• PatBL T- Through the Plane
• PatBLT - Across the Plane
• Short Stroke Vectors
• Polyline
• Polygon Fill Solid
• Polygon Fill Pattern -
• 4-Point Method Trapezoid Fill Solid
• 4-Point Method Trapezoid Fill Pattern
• Bresenham Parameter Trapezoid Fill Solid
• Bresenham Parameter Trapezoid Fill Pattern
• ROPBLT
• Programmable Hardware Cursor
Some programming steps are repeated in multiple examples. They are explained in detail at their first
occurrence. Therefore, readers are encouraged to work through the examples from first to last. The
register mnemonics used in the examples are listed in Table 5-1. Other mnemonics used are:
Mnemonic Description
NEW Mix = 00111 b in bits 4-0 of BAE8H or B6E8H. This overwrites the present
bitmap color value with a new value.
XOR Mix = 00101 b in bits 4-0 of BAE8H or B6E8H. The current bitmap color is
XORed with the new color.
5-10 ENHANCED MODE PROGRAMMING

...
r
S3 Vision868 Multimedia Accelerator
53 Incorporated
5.4.3.1 Solid Line
This command draws a one pixel wide solid line from screen coordinates x1.y1 to x2,y2. Bresenham
parameters are used to define the line. The Pixel Control register (BEE8H, Index AH) must be set to
AOOOH to select the Foreground Mix register to specify the color source and mix type.
Setup:
Drawing a line using axial coordinates requires programming the axial step constant into the Destina
tion Y-Position/Axial Step Constant (8AE8H) register (DESTY _AXSTPI. the diagonal step constant into
the Destination X-Position/Diagonal Step Constant (8EE8H) register (DESTX_DIASTP) and the error
term into the Error Term (92E8H) register (ERR_TERM). Calculation of these Bresenham parameters is
based on the MAX and MIN parameters as calculated below.
MAX = maximum(ABS(x2-x1), ABS(y2-y1))
MIN = minimum(ABS(x2-x1), ABS(y2-y1))
where maximum means choose the largest of the two terms in parentheses and minimum means
choose the smallest. ABS means take the absolute value of the expression.
Bits 7-5 of the Drawing Command (9AE8H) register (CMD) specify the drawing direction. Setting bit 7
to 1 means that the Y drawing direction is positive (y1 < y2). Clearing bit 7 to 0 means the Y drawing
direction is negative (y1 > y2). Setting bit 6 to 1 means that Y is the major (longer) axis (ABS(x2-x1) >
ABS(y2-y1)). Clearing bit 6 to 0 means that X is the major axis. Setting bit 5 to 1 means that the X
drawing direction is positive (x1 < x2). Clearing bit 5 to 0 means thatthe X drawing direction is negative
(x1 > x2). These values replace the DDD sequence in the write to the CMD register shown in the
pseudocode below.
The mix NEW represents a setting of 0111 b in bits 3-0 of the Foreground Mix (BAE8H) register
(FRGD_MIX). This overwrites the present bitmap color value with a new value.
The remainder of the setup is:
ES:[FRGD_MIXl <= 0027H ; color source is FRGD_COLOR, mix type is NEW
ES:FRGD_COLORl <= 00000002H ; color index
ES:[PIXEL_CNTLl <= AOOOH ; FRGD_MIX provides color source and mix type
Drawing Operation:
31 15 0
ES:[ALT _CURXYl <= 1.... __x _1_-,-_-,y_1_-,1 ; set starting coordinate
ES:[MAJ_AXIS_PCNTl <= MAX -1 ; length in pixels of the major axis -1
31 .--:---:-__, -:-:-1:r5---:-:-:-:----OJ ;
ES:[ALT_STEPl <=12*(MIN-MAX)1 2*MIN diagonal and axial step constants
If the X drawing direction is positive then
ES:[ERR_TERMl <= 2 * MIN - MAX ; error term
else if the X drawing direction is negative
ES[ERR_TERMl <= 2 * MIN - MAX - 1 ; error term
ES:[CMDl <= 00100000DDD10001 b ; Draw line command (bits 15-13, 11), draw (as opposed to
; just move current position)(bit 4), bit 0 is always 1
ENHANCED MODE PROGRAMMING 5-11

fl·
53 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3.2 Textured Line
The line draw command can be used to draw a one pixel wide textured line from screen coordinates
x1,y1 to x2,y2. The texture is created by (1) setting bits 7-6 of the Pixel Control register (BEE8H, Index
AH) to A080H to specify the CPU as the source of the mask bit selecting the mix register, (2) specifying
a background and foreground color, (3) setting bit 8 of the Command register (9AE8H) to 1 (wait for
CPU data) and (4) setting bit 1 of the Command register to 1 (multi-pixel). When the pattern bit sent by
the CPU is a 1, the Foreground Mix register specifies the the color source and mix. When the bit is a
0, the Background Mix register specifies the color source and mix. This example uses the mix NEW for
the foreground mix, XOR for the background mix, foreground color index 2 and background color index
4. The 32-bit line texture/pattern (PATIERN) is 00110000111100110011000011110011b. This requires
that bits 10-9 of the Command register be set to 10b to specify a 32-bit bus.
Setup:
The XOR mix corresponds to a setting of 0101b in bits 3-0 of the Background Mix (B6E8H) register
(BKGD_MIX). See the Solid Line example for an explanation of other parameters and registers used in
this example.
3r1 _______1 ~5------_0
ES:[ALT _MIX] ¢:: LI _ 0_0_27_H_,---0_0_05_H---,l ; FRGD_COLOR is color source and NEW is mix,
; BKGD_COLOR is color source and XOR is mix
ES:[FRGD_COLOR] ¢:: 00000002H ; color index
ES:[BKGD_COLOR] ¢:: 00000004H ; color index
ES:[PIXEL_CNTLI ¢:: A080H ; mask data selecting mix register is provided by the CPU
Drawing Operation:
31 15 0
-'l ;
ES:[ALT _CURXYI ¢:: LI_ __ X _1_ _- -'-__- -'-y_1 __ set starting coordinates
ES:[MAJ_AXIS_PCNT ¢:: MAX -1 ; length in pixels of the major axis -1
31 15 o I ;
ES:[ALT _ STEP] ¢:: f(MIN-MAX)1 2*MIN diagonal and axial step constants
If the X drawing direction is positive then
ES:[ERR_T ERM] ¢:: 2 * MI N - MAX ; error term
else if the X drawing direction is negative
ES[ERR_T ERM] ¢:: 2 * MIN - MAX - 1 ; error term
ES:[CMD] ¢:: 00100101DDD10011b ; Draw line (bits 15-13, 11), 32-bit bus (bits 10-9), wait for data
; from the CPU (bit 8), draw (bit 4), multi-pixel (bit 1)
COUNT (of PATTERN dwords) = (MAX + 31)/32 (See Note)
PIX_TRANS ¢:: 00110000111100110011000011110011b ; Output PATIERN to Pixel Data Transfer
; registers COUNT times
Note
The COUNT of the number of writes required by the CPU is a function of the number of bits to be
transferred and the width of the transfer (8, 16 or 32 bits as specified by bits 10-9 of the Drawing
Command register (9AE8H)). The number of bits transferred per line must be an even multiple of the
transfer width. If this is not the case, the last write per line must be padded with one or more dummy
5-12 ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
S3 Incorporated
bits to meet this requirement. For example, if the transfer width is 8 bits and nine bits are to be
transferred for the line, two bytes must be written per line, with the upper 7 bits of the second byte
padded. In general, the number of padding bits per line will vary from 0 to (n-1), where n is the transfer
width in bits.
With a transfer width of 8 bits, the number of byte writes required per line can be determined from
the formula n = (MAX+7)/8, with n being truncated to an integer ifthe result contains a fraction.
Thus a MAX = 11 transfer requires (11+7)/8 = 2 1/4 = 2 bytes. The formulas for all transfer widths are
given below.
8-bit transfers: COUNT = (MAX+7)/8 bytes
16-bit transfers: COU NT = (MAX+ 15)/16 words
32-bit transfers: COUNT = (MAX+31)/32 dwords
ENHANCED MODE PROGRAMMING 5-13

S3 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3.3  Rectangle Fill Solid
This command draws a solid rectangle with its top left corner at x1,y1, height = HEIGHT and width =
WIDTH. The Pixel Control register (BEE8H, Index AHI must be set to AOOOH to select the Foreground
Mix register to specify the color source and mix type. This example uses the mix NEW and color index
2. The drawing direction (bits 7-5 in the write to the CMD register belowl is set to X positive, X major
and V positive (101bl.
Setup:
ES:[FRGD_MIXI <= 0027H  ; color source is FRGD_COLOR, NEW mix type
ES:[FRGD_COLORI <= 00000002H  ; color index
ES:[PIXEL_CNTLI <= AOOOH  ; FRGD_MIX specifies the color source and mix type
Drawing Operation:
| 31  15  | 0   |     |
| ------- | --- | --- |
IL __
ES:[ALT  _CURXYI <=  X_1_---'-__y .:....1_---'l  ; set starting coordinates
| 31  15  | 0   |     |
| ------- | --- | --- |
ES:[ALT_PCNTI <=1  1H EIGHT-1 I
| WIDTH-1  | ; rectangle width  |     |
| -------- | ------------------ | --- |
ES:[CMDI <= 0100000010110001 b  ; Draw rectangle (bits 15-13, 111, draw (bit 41
Note
The rectangle can be defined by specifying anyone ofthe four corners and setting bits 7-5 accordingly.
Always select X as the major axis (bit 6 =01. No matter how the rectangle is defined, it always fills from
left to right and top to bottom.
| Corner        | X direction (bit 51  | V direction (bit 71  |
| ------------- | -------------------- | -------------------- |
| top left      | positive (11         | positive (1)         |
| top right     | negative (01         | positive (11         |
| bottom left   | positive (11         | negative (01         |
| bottom right  | negative (01         | negative (01         |
5-14 ENHANCED MODE PROGRAMMING

••
r
S3 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3.4 Image Transfer-Through the Plane
This command transfers a rectangular image from the CPU to the display memory through the plane.
"through the plane" means the complete color index is transferred for each pixel, e.g., in 8 bits/pixel
mode, one byte is required to transfer one pixel to memory. The image is stored as an array of pixels
arranged in row major fashion (consecutively increasing memory addresses). The Pixel Control register
must be set to AOOOH to select the Foreground Mix register to specify the color source and mix type.
The color source must be specified as the CPU. Bit 12 ofthe Command register must be setto 1 (swap
ON) for Intel-type architectures. Bit 8 of the Command register must be set to 1 (wait for CPU data) and
bits 6 and 5 must also be set to 1 to specify X as the major axis and a left-to-right drawing direction.
This example uses a mix type of NEW and x1,y1 is the top left corner of the rectangle on the screen.
The height and width of the rectangle (in pixels) are HEIGHT and WIDTH. Doublword CPU writes are
supported by setting bits 10-9 of the Command register to 10b.
Setup:
ES:[FRGD_MIXI <= 0047H ; color source is the CPU, mix type is NEW
ES:[PIXEL_CNTLI <= AOOOH ; FRGD_MIX is the source for color source and mix type
Drawing Operation:
31 15 0
ES:[AL T_ CURXYI <= 1I...-_x_1_--'-_-'-y1_---l1 ; set destination starting coordinates
31 15 0
I I I
ES:[ALT_PCNTI <= WIDTH-1 HEIGHT-1 ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AEBH register is 0
ES:[CMDI <= 01010101D0110001b ; Draw rectangle (bits 15-13, 11), swap ON (bit 12),
; 32-bit transfers (bits 10-9), wait for CPU data (bit B),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4)
COUNT (of image pixel data to transfer) = (See Note)
PIX_TRANS <= IMAGEDATA; Output image data to the Pixel Data Transfer registers for COUNT dwords.
Note
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred, the width ofthe transfer (B, 16 or 32 bits as specified by bits 10-9 ofthe Drawing Command
register (9AE8H)) and the color depth (bits/pixel). The number of pixels transferred per line must be an
even multiple of the transfer width. If this is not the case, the last write per line must be padded with
one or more dummy pixels to meet this requirement. For example, at 4 bits/pixel, each byte holds two
pixels. If the transfer width is one byte and three pixels are to be transferred per line, two bytes must
be written per line, with the upper nibble of the second byte a dummy pixel. If the transfer width is 16
bits, from one to three dummy pixels may be required to make the number of pixels per line an even
multiple of 16. The number of word writes required per line can be determined from the formula n =
(W+3)/4, with n being truncated to an integer if the result contains a fraction. Thus a six pixel transfer
requires (6+3)/4 = 2.25 = 2 words. This is then multiplied by the height of the the image (in pixels) to
determine the COUNT of words to be transferred. Similar procedures apply to every other combination
ofthe variables affecting the COUNT. The formulas for all cases are given below, where W is the width
of the image and H is the height of the image, both in pixels.
ENHANCED MODE PROGRAMMING 5-15

••
r
S3 Vision868 Multimedia Accelerator
53 Incorporated
COUNT for 4 bits/pixel modes
8-bit transfers: COUNT = (W+ 1) /2 * H bytes
16-bit transfers: COUNT = (W+3)/4 * H words
32-bit transfers: COUNT = (W+7)/8 * H dwords
COUNT for 8 bits/pixel modes
8-bit transfers: COUNT = W * H bytes
16-bit transfers: COUNT = (W+1)/2 * H words
32-bit transfers: COUNT = (W+3)/4 * H dwords
COUNT for 16 bits/pixel modes
8-bit transfers: Do not use this combination
16-bit transfers: COUNT = W * H words
32-bit transfers: COUNT = (W+ 1) /2 * H dwords
COUNT for 32 bits/pixel modes
8-bit transfers: COUNT = Do not use this combination
16-bit transfers: COUNT = 2W * H words
32-bit transfers: COUNT = W * H dwords
Note that in 32 bits/pixel modes, the upper byte is a dummy byte providing padding for a 24-bit
pixel.
5-16 ENHANCED MODE PROGRAMMING

fl·
S3 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3.5 Image Transfer-Across the Plane
The image transfer command can also be used to transfer a rectangular image from the CPU to the
display memory across the plane. "across the plane" means that each bit sent by the CPU is stored in
display memory as a single pixel. These pixels are arranged in row major fashion (consecutively
increasing memory addresses). An "across the plane" transfer is created by (1) setting bits 7-6 of the
Pixel Control register (BEE8H, Index AH) to A080H to specify the CPU as the source of the mask bit
selecting the mix register, (2) specifying a background and foreground color, (3) setting bit 8 of the
Command register (9AE8H) to 1 (wait for CPU data) and (4) setting bit 1 of the Command register to 1
(multi-pixel). When the pattern bit sent by the CPU is a 1, the Foreground Mix register specifies the the
color source and mix. When the bit is a 0, the Background Mix register specifies the color source and
mix. This example uses a mix type of NEW, and x1,y1 is the top left corner of the rectangle on the
screen. The height and width of the rectangle (in pixels) are HEIGHT and WIDTH. The monochrome
image is translated so that pixels corresponding to a 1 in the bit image are given color index 4 and
pixels corresponding to a 0 in the bit image are given color index o. This example uses word transfers
from the CPU as specified by setting bits 10-9 of the Command register to 01 b for a 16-bit bus width.
Setup:
31 15 0
ES:[ALT _ MIX] <= =1= 0=0=2--:7_H~~-=-~-0_0-=-0-5_H-=--~J ; FRGD_COLOR color source and mix is NEW
; BKGD_COLOR is color source and mix is XOR
ES:[FRGD_COLOR] <= 00000004H ; foreground color index 4
ES:[BKGD_COLOR] <= OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTL] <= A080H ; selection of mix register is based on data from the CPU
Drawing Operation:
31 15 0
IL __
ES:[ALT _CURXY] <= X_1_----"'----'y_1_---'1 ; set destination starting coordinates
31 15 0
ES:[ALT_PCNT] <= 1 WIDTH-1 1 HEIGHT-1 1 ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
CMD <= 01010011D0110011b ; Draw rectangle (bits 15-13, 11), swap ON (bit 12),
; 16-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4)'
; multi-pixel (bit 1)
COUNT (of image pixel data to transfer) = ((WIDTH +15)/16)*HEIGHTwords
PIX_TRANS <= IMAGEDATA; Output image data to Pixel Transfer register for COUNT words
Notes
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred and the width ofthe transfer (8,16 or 32 bits as specified by bits 10-9 of 9AE8H). Except for
the case where bits 10-9 of 9AE8H are 11b, the number of pixels transferred per line must be an even
multiple of the transfer width. If this is not the case, the last write per line must be padded with one or
more dummy pixels to meet this requirement. For example, if the transfer width is 8 bits and nine
pixels are to be transferred per line, two bytes must be written per line, with the upper 7 bits of the
second byte padded. In general, the number of padding bits per line will vary from 0 to (n-1), where n
is the transfer width in bits.
ENHANCED MODE PROGRAMMING 5-17

53 Vision868 Multimedia Accelerator
53 Incorporated
With a transfer width of B bits, the number of byte writes required per line can be determined from the
formula n = (W+7)/B, with n being truncated to an integer ifthe result contains a fraction. Thus a 13-bit
pixel transfer requires (13+7)/B = 2.5 = 2 bytes. This is then multiplied by the height of the image (in
pixels) to determine the COUNT of bytes to be transferred. Similar procedures apply to every other
combination of the variables affecting the COUNT. The formulas for all cases are given below, where
W is the width of the image and H is the height of the image, both in pixels.
B-bit transfers: COUNT = (W+7)/B * H bytes (9AEBH_10-9 = OOb)
16-bit transfers: COUNT = (W+ 15)/16 * H words (9AEBH_10-9 = 01b)
32-bit transfers: COUNT = (W+31)/32 * H dwords (9AEBH_10-9 = 10b)
New 32-bit transfers: COUNT = «(W+7)/B*Hl+3)/4 dwords (9AEBH_10-9 = 11b)
The differences between the two 32-bit transfer options are:
1. For 9AEBH_10-9 set to 10b, every line of the transfer must start with a fresh doubleword. In other
words, all unneeded bits in a doubleword transfer for a given line are discarded. After a rectan
gular image is transferred, the current drawing position is a the bottom left, meaning the next
rectangle, if drawn, will be below the previous rectangle.
2. For 9AEBH_10-9 set to 11 b, only bits from the end of the line width to the next byte boundary are
discarded. Data for the next line begins with the next byte. After a rectangular image is trans
ferred, the current drawing position is a the top right, meaning the next rectangle, if drawn,
will be to the right ofthe previous rectangle.
To write to a single plane, setthe foreground mixto 'logical one' (0002H), the background mix to 'logical
zero' (0001H), and the Write Mask register (AAEBH) to select the desired (single) plane for updates.
5-1B ENHANCED MODE PROGRAMMING

53 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3.6 BitBLT - Through the Plane
This command copies a source rectangular area in display memory to another location in display
memory. The Pixel Control register must be set to AOOOH to select the Foreground Mix register to
specify the color source and mix type. The color source must be specified as the bitmap (display
memory). Bit6 of the Command register must be setto 1 to specify X as the major axis. Forthis example,
assume xl,yl is the top left corner of the source rectangle in display memory and x2,y2 is the top left
corner of the destination rectangle. The rectangles can be overlapping or disjoint. The height and width
(in pixels) of the rectangle being copied are HEIGHT and WIDTH.
Setup:
First, the values of the Srcx, Srcy, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, Y Positive: Srcx = xl, Srcy = yl, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
Ifxl >x2
then if X Positive, Srcx = xl, Destx = x2
else
Srcx = xl + WIDTH -1, Desty = x2 + WIDTH-l ; X Negative
Ifyl >y2
then if Y Positive, Srcy = yl, Desty = y2
else
Srcy = yl + HEIGHT -1, Desty = y2 + HEIGHT-l ; Y Negative
ES:[PIXEL_CNTLl <= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX] ¢= 0067H ; color source is display memory and mix type is NEW
Draw Operation:
3rl __~ ___1 ,5_ _~ ___O
ES:[ALL CURXY] <= 1,--_S_rc_x_-,--_S_r_cY~--,J ; set starting coordinates
31 15 0
ES:[AL T_ STEP] <= ,-I _D_es_tx_-,--_D_e_st--,-y---,I ; set destination coordinates
31 15 0
ES:[ALT_PCNTl <= 1 WIDTH-l 1 HEIGHT-l J ; rectangle width and height
ES:[CMD] <= 11000000DOD10001b ; BitBLT (bits 15-13, 11), always X Major (bit 6) , draw (bit 4)
ENHANCED MODE PROGRAMMING 5-19

••
r
S3 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3.7 BitBLT-Across the Plane
This uses the same command as a BitBlT through the plane. However, instead of copying complete
pixels (with color affected only by the mix), this 'across the plane" transfer uses only the bits in the
color planes specified by setting the Read Mask register (AEE8H), e.g., bit 3 of every pixel, to determine
the destination rectangle. With more than one plane enabled for read, if all the bits in the planes enabled
for read are '1's then a '1' is read. If a bit in anyone of the planes enabled for read is a '0', then '0' is
read. An "across the plane" transfer is created by (1) setting bits 7-6 ofthe Pixel Control register (BEE8H,
Index AH) to AOCOH to specify the bitmap as the source of the mask bit selecting the mix register, (2)
programming the Read and Write Mask registers to specify the plane to read from and write to and (3)
setting bit 1 ofthe Command register to 1 (multi-pixel). In this example, when the bit read is a 1, a 1 is
copied as specified by the foreground mix. When the bit read is a 0, a 0 is copied as specified by the
background mix. Assume x1,y1 is the top left corner ofthe source rectangle on the display, and x2,y2
is the top left corner of the destination rectangle. The image is read from plane 0 and written to plane
2. The rectangles could be overlapping or disjoint. The height and width (in pixels) ofthe rectangle are
HEIGHT and WIDTH.
Setup:
First, the values of the Srcx, Srcy, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, Y Positive: Srcx = x1, Srcy = y1, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
If x1 > x2
then if X Positive, Srcx = x1, Destx = x2
else
Srcx = x1 + WIDTH -1, Desty = x2 + WIDTH-1 ; X Negative
Ify1 > y2
then if Y Positive, Srcy = y1, Desty = y2
else
Srcy = y1 + HEIGHT -1, Desty = y2 + HEIGHT-1 ; Y Negative
ES:[PIXEl_CNTl) <= AOCOH ; data from display memory selects mix register
3rl_ ______l ~5------_0
I J ;
ES:[AlT _ MIX) <= 0002H 0001 H result of foreground mix is always logical 1,
; result of background mix is always logical 0
ES:[RD_MASK) <= 00000001H ; read from plane 0
ES:[WRT_ MASK) <= 00000004H ; plane 2 enabled for write
5-20 ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
S3 Incorporated
Draw Operation:
31 15 0
ES:[ALT_ CURXY) <= _S_rc_x_-'--_S_r_cy-'-----'I ; set starting coordinates
1-1
3,1 _______1 ,5 _______0
ES:[ALT _STEP) <= IL_D_es_tx_...l....-_D_e_sty-=------'l ; set destination coordinates
31 15 0
ES:[ALT_PCNT) <=1 WIDTH-1 1 H EIGHT-1l ; rectangle width and height
ES:[CMD) <= 11000000DOD10001b ; BitBLT (bits 15-13, 11), always X Major (bit 6) , draw (bit 4),
; multi-pixel (bit 1)
Note
It is possible to translate a monochrome image, e.g., text fonts, stored in a single plane in display
memory into a 2-color image. This is accomplished by setting the mix registers differently and setting
the desired background and foreground colors. If the source bit is a '1', then the corresponding pixel
at the destination is colored with the foreground color index. The destination pixel is colored with the
background color index if the corresponding source bit is a '0'. The setup for this is as follows:
<=
ES:[WRT_MASK) FFFFFFFFH ; enable all planes for writing
ES:[FRGD_MIX) <= 0027H ; color source foreground, mix type NEW
<=
ES:[BKGD_MIX) 0007H ; color source background, mix type NEW
ES:[FRGD_COLOR) <= 00000004H ; foreground color
<=
ES:[BKGD_COLOR) 00000001H ; background color
ENHANCED MODE PROGRAMMING 5-21

S3 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3.8 PatBlT - Pattern Fill Through the Plane
An axa pixel pattern is initially copied into an off-screen area of display memory using an image transfer
operation or a direct write (linear addressing). This command then repeatedly tiles this source pattern
into a destination rectangle of arbitrary size. The colors of the destination pixels are affected only by
the mix selected. The destination rectangle must not overlap the source pattern. Each copy is aligned
to an a-pixel boundary (x coordinate = 0, a, etc.), with pixels outside the destination rectangle boundary
not being drawn. The Pixel Control register must be set to AOOOH to select the Foreground Mix register
to specify the color source and mix type. The color source must be specified as the bitmap (display
memory). Bit 6 ofthe Command register must be set to 1 to specify X as the major axis. In this example,
assume x1,y1 is the top left corner of the pixel pattern and x2,y2 is the top left corner of the destination
rectangle. The height and width (in pixels) of the rectangle are HEIGHT and WIDTH.
Setup:
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX] <= 0067H ; color source is display memory, mix type is NEW
Draw Operation
3
r
1 _______1 ,5 _______0
ES:[AL T_ CURXY] <=1,--_X_1_--,-_y,-1_--ll ; set starting coordinates
31 15 0
ES:[ALT _STEP] <= _X_2_--,--_y,-2_--,i ; set destination coordinates
,--I
31 15 0
ES:[ALT_PCNT] <=1 WIDTH-1 1H EIGHT-1l ; rectangle width and height
ES:[CMD] <= 11100000DOD10001b ; PatBLT (bits 15-13,11), always X Major (bit 6) ,draw(bit4)
5-22 ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3.9 PatBlT - Pattern Fill Across the Plane
This uses the same command as a PatBL T through the plane. However, instead of copying complete
pixels (with color affected only by the mix), this 'across the plane" transfer uses only the bits in the
color planes specified by setting the Read Mask register (AEE8H), e.g., bit 3 of every pixel, to determine
the destination rectangle. With more than one plane enabled for read, if all the bits in the planes enabled
for read are '1's then a '" is read. If a bit in anyone of the planes enabled for read is a '0', then '0' is
read. An "across the plane" transfer is created by (,) setting bits 7-6 of the Pixel Control register (BEE8H,
Index AH) to AOCOH to specify the bitmap as the source of the mask bit selecting the mix register, (2)
programming the Read and Write Mask registers to specify the plane to read from and write to and (3)
setting bit 1 of the Command register to 1 (multi-pixel). In this example, when the bit read is a 1, a 1 is
copied as specified by the foreground mix. When the bit read is a 0, a 0 is copied as specified by the
background mix. In this example, assume x1.y1 is the top left corner of the pixel pattern and x2,y2 is
the top left corner of the destination rectangle. The image is read from plane 0 and written to plane 2.
The height and width of the destination rectangle are HEIGHT and WIDTH.
Setup:
ES:[PIXEL_CNTL] <= AOCOH ; data from display memory selects mix register
31 15 0
ES:[AL T _MIX] <= _0_0_02_H----"'----0_0_01_H---11 ; result of foreground mix is always logical 1,
,--I ; result of background mix is always logical 0
ES:[RD_MASK] <= 00000001 H ; read from plane 0
ES:[WRLMASK] <= 00000004H ; plane 2 enabled for write
Draw Operation:
31 15 0
ES:[ALT _CURXY] <= _X_1_--,-_y,--1_--,1 ; set starting coordinates
LI
3,1 _______1 ,5 _______0
ES:[AL T_ STEP] <= _X_2_--,-_y,---2_--,l ; set destination coordinates
,--I
31 15 0
ES:[ALT_PCNT] <= 1 WIDTH-1 1 HEIGHT-1 1 ; rectangle width and height
ES:[CMD] <= 11100000DOD10011b ; PatBLT (bits 15-13, 11). always X Major (bit 6) ,draw (bit 4),
; multi-pixel (bit 1)
Note
To expand the source mono pattern into a 2-color pattern, set the foreground mix to 27H, the
background mix to 7H and the foreground and background colors as desired. Also set the write mask
(AAE8H) to FFFFFFFFH. This needs to be set only once. It is altered only by another write.
ENHANCED MODE PROGRAMMING 5-23

S3 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3.10 Short Stroke Vectors
This command rapidly draws short lines (up to 15 pixels in length). Such lines are constrained to one
of the 8 directions at 45 degree increments starting at 0 degrees. The current point x1,y1 is set and a
NOP command is issued to set all the desired drawing parameters without actually writing a pixel. For
example, bit 2 (Last Pixel Off) would be set to 1 (OFF) for drawing connected lines until the last line is
drawn. The short stroke vector parameters are then loaded in the Short Stroke Vector Transfer (9EE8H)
register (SHORT_STROKE). Two vectors can be defined at a time, one in the low byte and one in the
high byte. For the low byte, bits [7:5] define the direction, with bit 4 set to '1' for a draw operation or
to '0' for a move current position operation. Bits 3-0 define the length of the short line. Let SSVDO,
SSVD1, ... SSVDN-1 bytes be the short stroke vector data for N lines.
Setup:
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX] <= 0027H ; use the foreground color, mix type NEW
ES:[FRGD_COLOR]<= 00000004H ; foreground color index 4
Draw Operation:
31 15 0
ES:[ALT _CURXY] <= x_1_-'-_--'y_1_-'1 ; set starting coordinates
LI_ _
ES:[CMD] <= 00010010XXX11111 b ; NOP (bits 15-13, 11), byte swap (bit 12), 16-bit transfers
; (bits 10-9) , draw (bit 4), radial drawing direction (bit 3),
; last pixel off (bit 2), mUlti-pixel (bit 1)
While space available in the FIFO
ES:[SHORT_ STROKE] <= SSVD1 SHL 8 + SSVDO; SSVD1 shifted to high byte, SSVDO in low byte
ES:[SHORT_ STROKE] <= SSVD3 SHL 8 + SSVD2 ; byte swap turned on to read vectors out in
; correct order
ES:[SHORT_STROKE] <= SSVDN-1 SHL 8 + SSVDN-2
5-24 ENHANCED MODE PROGRAMMING

, .
.,,~
-
S3 Vision868 Multimedia Accelerator
53 Incorporated
5.4.3.11 Polyline/2-Point Line
This command draws a line from point P1 (x1,y1) to point P2 (x2,y2).lt can be used to draw an additional
line from the end point ofthe last line drawn by specifying only the next end point. This can be repeated
for as many polyline segments as desired. The Pixel Control register must be set to AOOOH to select
the Foreground Mix register to specify the color source and mix type. The color source must be specified
as the foreground color.
Setup:
ES:[FRGD_MIX] <= 0027H ; color source is FRGD_COLOR, NEW mix type
ES:[FRGD_COLOR]<= 00000002H ; color index
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX specifies the color source and mix type
Draw Operation:
31_ ______1 ,5_ ______0
r
ES:[AL T _CURXY] <= _X_1_-,-_y,-1_-,l ; set starting coordinates
,-I
3,1 _______1 ,5_ ______0
ES:[ALT _STEP] <= _X_2_-,-_Y,-2_....J1 ; set destination coordinates
LI
ES:[CMD]<= 0010100000010001b ; draw 2-point line (bits 15-13, 11), draw (bit 4)
Repeat the last two instructions to draw additional polyline segments.
Note
This command is faster for drawing a 2-point line than the Solid Line drawing command. However,
the Bresenham parameters are fixed in hardware and cannot be manipulated by the programmer as
with the Solid Line command. A textured line cannot be drawn with this command.
ENHANCED MODE PROGRAMMING 5-25

S3 Vision868 Multimedia Accelerator
S3 Incorporatad
5.4.3.12  Polygon Fill Solid
This command draws a polygon and fills it with a solid color. Any number of edges can be drawn, but
the shape must be such that any horizontal line must intersect the polygon edges in no more than two
places. To accomplish this, all edge segments must be drawn downward. The exception is that any
edge can be horizontal. The Pixel Control register must be set to AOOOH to select the Foreground Mix
register to specify the color source and mix type. This example uses the mix NEW and color index 2.
This example shows how to draw the polygon shown in Figure 5-2.
x1,y1
x3,y3
x2,y2
x7,
| STEP 1  | STEP 2  | STEP 3  | STEP 4  | STEP 5  |
| ------- | ------- | ------- | ------- | ------- |
POLY
Figure 5-2. Polygon Example Drawing Steps
Setup:
ES:[FRGD_MIX] $= 0027H  ; color source is FRGD_COLOR, NEW mix type
| ES:[FRGD_COLOR] $= 00000002H  | ; color index  |     |     |     |
| ----------------------------- | -------------- | --- | --- | --- |
ES:[PIXEL_CNTL] $= AOOOH  ; FRGD_MIX specifies the color source and mix type
Draw Operation:
3 1 ___, 15_  ___0
r
ES:[ALT  _CURXY] $=  _X_1_-,-_y;...1_....Jl  ; set starting coordinates for segment 1 of left side
,-I
| 3,..1 ___- ,15_  | ___0   |     |     |     |
| ---------------- | ------ | --- | --- | --- |
; set destination coordinates for segment 1 of left side
| ES:[AL T _STEP] $=  ,-I  _X_2_-,-_y,-2_-,l  |     |     |     |     |
| ------------------------------------------- | --- | --- | --- | --- |
| 31                                          | 15  | 0   |     |     |
ES:[ALT_ CURXY2] $= 1'--_x_1_-'-_.....:;y_1_-'1  ; set starting coordinates for segment 1 of right side
| 31  | 15  0  |     |     |     |
| --- | ------ | --- | --- | --- |
ES:[ALT  _STEP2] $= 1,--_x_3_-,-_.....:;y_3_-,1  ; set destination coordinates for segment 1 of right side
ES:[CMD]$= 0110000000010001b  ; draw polygon (bits 15-13, 11), draw (bit 4) -Step 1
| 31  | 15  0  |     |     |     |
| --- | ------ | --- | --- | --- |
ES:[ALT_ STEP2] $= 1...1_  _x_ 4_...l...._..:.y4_--l1  ; set destination coordinates for segment 2 of right side
ES:[CMD]$= 0110000000010001 b  ; draw polygon (bits 15-13, 11) -Step 2
| 31  | 15  0  |     |     |     |
| --- | ------ | --- | --- | --- |
ES:[ALT  _STEP] $= 1....1_  X_5_-,-_y;...5_....J1  ; set destination coordinates for segment 2 of left side
5-26 ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
S3 Incorporated"
ES:[CMD]<= 01 10000000010001 b ; draw polygon (bits 15-13, 11) -Step 3
3' '5 0
ES:[AL T _STEP] <=1 _x_6_-L-_y:......6_--,1 ; set destination coordinates for segment 3 of left side
L
ES:[CMD]<= 01 10000000010001b ; draw polygon (bits 15-13, 11) -Step 4
3' '5 0
ES:[ALT _STEP] <= _x_7_-L-_y:......7_--,1 ; set destination coordinates for segment 4 of left side
,-I
3,'_ ______', 5 _______0
ES:[ALT _STEP2] <= _X_8_-L-_Y:......8_--.Jl ; set destination coordinates for segment 3 of right side
,-I
ES:[CMD]<= 01 10000000010001b ; draw polygon (bits 15-13, 11) -Step 4
The generation ofthis polygon is summarized in the following table.
Table 5-4. Polygon Fill Example Summary
First Line Second Line
ALT CURXY ALT STEP ALT CURXY2 ALT STEP2
Step 1 xl vl x2 v2 xl vl x3 V3
CMD
Step 2 x4 v4
CMD
Step 3 x5 y5
CMD
Step 4 x6 y6
CMD
StepS x7 V7 x8 y8
CMD
Notes
1. The current y for the first two line segments must be the same (y1 in the example). The current x
for these two line segments can be the same (point) or different (horizontal top edge).
2. The fill proceeds downward until it reaches an end point for one of the edges. The next line seg
ment is then drawn as an extension of this edge, with the fill again stopping at the first end
point it reaches. For example, note how after segment 2 of the right side is drawn to x4,y4, the
fill stops at x2,y2 of the first segment of the left side.
3. Segment 3 of the left side ends at the same vertical position as segment 2 of the right side (Step
4). When this occurs, both edges of the polygon must be extended by the next command. This
is shown in Step 5.
4. For the step that closes the polygon (Step 5 in the example), the destination y positions must be
be the same (y7 = y8 in the example) for the two line segments making the closure. As with
the top edge, the x positions may be different (forming a horizontal bottom edge) or the same
(a point).
5. When two lines join or cross at an angle other than 90 degrees, the common pixel will not be
drawn.
ENHANCED MODE PROGRAMMING 5-27

S3 Vision868 Multimedia Accelerator
53 Incorporated
5.4.3.13 Polygon Fill Pattern
This command operates exactly as the polygon fill solid except that an 8x8 pixel pattern is tiled into
the polygon instead of a solid color. The 8x8 pattern can either be color or mono and must first be
programmed into off-screen memory using an image transfer or linear addressing. The colors of the
destination pixels are affected only by the mix selected. The destination polygon must not overlap the
source pattern. Each copy is aligned to an 8-pixel boundary (x coordinate = 0,8, etc.), with pixels outside
the destination polygon boundary not being drawn. For a color pattern. the Pixel Control register must
be set to AOOOH to select the Foreground Mix register to specify the color source and mix type. The
color source must be specified as the bitmap (display memory). For a mono pattern, the Pixel Control
register must be set to AOCOH to select the bitmap as the source of the mask bit selecting the mix
register. If the pattern bit is a 1, the Foreground Mix register is chosen, which must be programmed
to select the foreground color. If the pattern bit is a 0, the Background Mix register is chosen, which
must be programmed to select the background color.
Setup: (Color Pattern)
ES:[PIXEL_CNTLI <= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX] <= 0067H ; color source is display memory, mix type is NEW
31 15 o
PAT _Y 1 ; coordinates of upper left hand corner of 8xB pattern
Draw Operation: (Color Pattern)
Same as for polygon fill solid except
ES:[CMD]<= 01101000000010001b ; draw polygon with pattern fill (bits 15-13, 11)
is substituted for each of the command lines.
Setup: (Mono Pattern)
3r1 ____~ -IT5----~_O
ES:[ALT _ MIX] <= _0_0_27_H----''---0_0_05_H-----'l ; FRGD_COLOR color source and mix is NEW
,--I ; BKGD_COLOR is color source and mix is XOR
ES:[FRGD_COLOR] <= 00000004H ; foreground color index 4
ES:[BKGD_COLOR] <= OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTLI <= AOCOH ; selection of mix register is based on data from the screen
31 15 0
I
ES:[ALT_PAT] <=1 PAT_X PAT_Y ; coordinates of upper left hand corner of BxB pattern
Draw Operation: (Mono Pattern)
Same as for polygon fill solid except
ES:[CMD]<= 0110100000010011b ; draw polygon with pattern fill (bits 15-13, 11),
; multi-pixel (bit 1)
is substituted for each of the command lines.
5-2B ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3.14  4-Point Trapezoid Fill Solid
This command draws a solid trapezoid specified by edge 1 [points P1 (x1,y1) and P2 (x2,y2)] and edge
2 [points P3 (x3,y3) and P4 (x4,y4)]. P1 and P3 must be on the same horizontal line and P2 and P4 must
be on a different lower horizontal line. The Pixel Control register must be set to AOOOH to select the
Foreground Mix register to specify the color source and mix type. This example uses the mix NEW and
color index 2.
Setup:
ES:[FRGD_MIX] <= 0027H  ; color source is FRGD_COLOR, NEW mix type
| ES:[FRGD_COLOR] <= 00000002H  | ; color index  |     |
| ----------------------------- | -------------- | --- |
ES:[PIXEL_CNTL] <= AOOOH  ; FRGD_MIX specifies the color source and mix type
Draw Operation:
| 31  | 15  | 0   |
| --- | --- | --- |
; set starting coordinates for edge 1
| ES:[ALT  _CURXY] <= 1  | x1  y1  | 1   |
| ---------------------- | ------- | --- |
L-___~  _~_~
| 31  | 15  | 0   |
| --- | --- | --- |
ES:[ALT  _STEP] <= 1L-_X_2_--'--__y '-2_-'i  ; set destination coordinates for edge 1
|     | 31  15  | 0   |
| --- | ------- | --- |
ES:[ALT  _CURXY2] <= <-I __X _3_--'--_-'y_3_. ...l. ..  ; set starting coordinates for edge 2
| 31  | 15  | 0   |
| --- | --- | --- |
; set destination coordinates for edge 2
ES:[ALT  _STEP2] <= 1L-_X_4_--'--_-'-y4_-.Ji
ES:[CMD]<= 1000000000010001b  ; draw 4-point trapezoid (bits 15-13, 11), draw (bit 4)
Note
The y coordinates for line 2 (y3 and y4) are not required. If they are programmed, they must be the
same as y1 and y2 respectively.
ENHANCED MODE PROGRAMMING 5-29

83 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3.15 4-point Trapezoid Fill Pattern
This command operates exactly as the 4-point trapezoid fill solid except that an 8x8 pixel pattern is
tiled into the trapezoid instead of a solid color. The 8xa pattern can either be color or mono and must
first be programmed into off-screen memory using an image transfer or linear addressing. The
destination trapezoid must not overlap the source pattern. Each copy is aligned to an 8-pixel boundary
(x coordinate = 0, 8, etc.), with pixels outside the destination trapezoid boundary not being drawn. For
a color pattern. the Pixel Control register must be set to AOOOH to select the Foreground Mix register
to specify the color source and mix type. The color source must be specified as the bitmap (display
memory). For a mono pattern, the Pixel Control register must be set to AOCOH to select the bitmap as
the source ofthe mask bit selecting the mix register. Ifthe pattern bit is a 1, the Foreground Mix register
is chosen, which must be programmed to select the foreground color. If the pattern bit is a 0, the
Background Mix register is chosen, which must be programmed to select the background color.
Setup: (Color Pattern)
ES:[PIXEL_CNTLI <= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIXI <= 0067H ; color source is display memory, mix type is NEW
31 15 0
I I I
ES:[ALT_PATI <= PAT_X PAT_Y ; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Color Pattern)
Same as for 4-point trapezoid fill solid except the command is as follows:
ES:[CMD)<= 0110100000010001b ; draw trapezoid with pattern fill (bits 15-13, 11)
Setup: (Mono Pattern)
~ 15 0
ES:[AL T_ MIX) <= 1"--0-0-27-H-'--0-0-0-5H--';1 ; FRGD_COLOR color source and mix is NEW
; BKGD_COLOR is color source and mix is XOR
ES:[FRGD_COLORI <= 00000004H ; foreground color index 4
ES:[BKGD_COLOR) <= OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTLI <= AOCOH ; selection of mix register is based on data from the screen
31 15 o
; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Mono Pattern)
Same as for 4-point trapezoid fill solid except the command is as follows:
ES:[CMD)<= 1000100000010011 b ; draw trapezoid with pattern fill (bits 15-13, 11), multi-pixel (bit 1)
5-30 ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
53 Incorporated
5.4.3.16  Bresenham Parameter Trapezoid Fill Solid
This command operates exactly as the 4-point trapezoid fill solid except the two edges are drawn with
Bresenham parameters specified by the programmer. Calculation of these Bresenham parameters is
based on the MAX and MIN parameters as calculated below.
MAX = maximum(ABS(x2-x1), ABS(y2-y1))
MIN = minimum(ABS(x2-x1), ABS(y2-y1))
where maximum means choose the largest of the two terms in parentheses and minimum means
choose the smallest. ABS means take the absolute value of the expression. The fill must proceed
downward (V positive).
Setup:
ES:[FRGD_MIX] <= 0027H  ; color source is FRGD_COLOR, NEW mix type
| ES:[FRGD_COLOR] <= 00000002H  |     | ; color index  |     |
| ----------------------------- | --- | -------------- | --- |
ES:[PIXEL_CNTL] <= AOOOH  ; FRGD_MIX specifies the color source and mix type
Draw Operation
|     | 31  | 15  | 0   |
| --- | --- | --- | --- |
ES:[AL T _CURXV] <=LI __x _1_---'-_--'-y_1 _-,I  ; set starting coordinate for edge 1
; length in pixels of the major axis -1 for edge 1
|     | 31  | 15  | o   |
| --- | --- | --- | --- |
ES:[ALT_STEP] <=[2*(MIN-MAX)1  2*MIN  1 ; diagonal and axial step constants for edge 1
If the X drawing direction is positive then
| ES:[ERR_TERM] <= 2 * MIN - |     | MAX  | ; error term for edge 1  |
| -------------------------- | --- | ---- | ------------------------ |
else if the X drawing direction is negative
| ES[ERR_T ERM] <= 2 * MIN - |                  | MAX - 1   | ; error term for edge 1  |
| -------------------------- | ---------------- | --------- | ------------------------ |
|                            | 3Ir 1_~ __1 ,5_  | _~ _OJ ;  |                          |
ES:[ALT_ CURXV2] <=  x2  y2  set starting coordinate for edge 2
ES:[MAJ_AXIS_PCNT2] <= MAX -1  ; length in pixels of the major axis -1 for edge 2
|     | 31  | 15  | o   |
| --- | --- | --- | --- |
I;
ES:[ALT  _STEP2] 92*(MIN-MAX)1  2*MIN  diagonal and axial step constants for edge 2
If the X drawing direction is positive then
| ES:[ERR_TERM] <= 2 * MIN - |     | MAX  | ; error term for edge 2  |
| -------------------------- | --- | ---- | ------------------------ |
else if the X drawing direction is negative
| ES[ERR_ TERM] <= 2 * MIN - |     | MAX - 1  | ; error term for edge 2  |
| -------------------------- | --- | -------- | ------------------------ |
ES:[CMD2]<= 000000001 DDOOOOOb  ; edge 2 drawing direction (bits 7-5)
ES:[CMD]<= 101000001DD10001b  ; draw Bresenham parameter trapezoid (bits 15-13, 11)
; edge 1 drawing direction (bits 7-5), draw (bit 4)
Note that the last two instructions can be packed, i.e, ES:[ALT _ CMDI. with CMD in the lower word
(15-0) and CMD2 in the upper word (31-16). If they are not packed, CMD2 must precede CMD as
shown.
ENHANCED MODE PROGRAMMING 5-31

r-~ .
S3 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3.17 Bresenham Parameter Trapezoid Fill Pattern
This command operates exactly as the Bresenham parameter trapezoid fill solid except that an 8x8
pixel pattern is tiled into the trapezoid instead of a solid color. The 8x8 pattern can either be color or
mono and must first be programmed into off-screen memory using an image transfer or linear
addressing. The destination trapezoid must not overlap the source pattern. Each copy is aligned to an
8-pixel boundary (x coordinate = 0, 8, etc.), with pixels outside the destination trapezoid boundary not
being drawn. For a color pattern. the Pixel Control register must be set to AOOOH to select the
Foreground Mix register to specify the color source and mix type. The color source must be specified
as the bitmap (display memory). For a mono pattern, the Pixel Control register must be set to AOCOH
to select the bitmap as the source ofthe mask bit selecting the mix register.lfthe pattern bit is a 1, the
Foreground Mix register is chosen, which must be programmed to select the foreground color. If the
pattern bit is a 0, the Background Mix register is chosen, which must be programmed to select the
background color.
Setup: (Color Pattern)
ES:[PIXEL_CNTL) <= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX) <= 0067H ; color source is display memory, mix type is NEW
3,' ____', .5 ____0
l
ES:[ALT_PAT) <= 1 PAT_X 1 PAT_Y ; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Color Pattern)
Same as for Bresenham parameter trapezoid fill solid except the command is as follows:
ES:[CMD)<= 101010001DD10011b ; draw Bresenham parameter trapezoid with pattern fill
; (bits 15-13,11)
Setup: (Mono Pattern)
3r'_ _~ _',.5 ____: 0
ES:[ALT _MIX) <=1,-_0_0_27_H----''--0_0_05_H---ll ; FRGD_COLOR color source and mix is NEW
; BKGD_COLOR is color source and mix is XOR
ES:[FRGD_COLOR) <= 00000004H ; foreground color index 4
ES:[BKGD_COLOR) <= OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTL) <= AOCOH ; selection of mix register is based on data from the screen
3"~~~_'T5~~~~.0l
ES:[ALT_PAT) <=1 PAT_X 1 PAT_Y ; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Mono Pattern)
Same as for Bresenham parameter trapezoid fill solid except the command is as follows:
ES:[CMD)<= 101010001 DD10011b ; draw Bresenham parameter trapezoid with pattern fill
; (bits 15-13, 11), multi-pixel (bit 1)
5-32 ENHANCED MODE PROGRAMMING

••
r
S3 Vision868 Multimedia Accelerator
53 Incorporated
5.4.3.18 ROPBLTs
The ROPBlT function provides a full implementation of the 256 raster operations as defined by
Microsoft for Windows. A listing and explanation of these is provided in Appendix A.
Each raster op has three operands: Source, Pattern and Destination. The Source pixel can be from the
screen (current bitmap) or from the CPU (image transfer). When the source is the screen, the pixel
depth is always the same for both the source and destination (4, 8, 16, 24/32 bits/pixel). When the
source is the CPU, the pixel can be either color (same source and destination pixel depth) or mono (1
bit/pixel).
The Pattern is an 8x8 array of pixels located in off-screen memory. The pixels are either color or mono.
If mono, pattern foreground and background registers define the pixel colors.
The Destination pixel is always the screen (current bitmap) and is always color (multi bits/pixel). This
is the pixel that will be overwritten or left unchanged by the result of the operation.
Based on the above definitions, there are 6 valid ROPBl Teases:
Color Pattern
• Source = Screen, Color Pixels
• Source = CPU, Color Pixels
• Source = CPU, Mono Pixels
Mono Pattern
• Source = Screen, Color Pixels
• Source = CPU, Color Pixels
• Source = CPU, Mono Pixels
Programming examples for each of these cases are provided on the following pages.
ENHANCED MODE PROGRAMMING 5-33

53 Vision868 Multimedia Accelerator
S3 Incorporated
Color Pattern Case 1 (Source = Screen, Color Pixels)
This command copies a source rectangular area in display memory to another location in display
memory. The Pixel Control register must be set to AOOOH to select the Foreground Mix register to
specify the color source. The color source must be specified as the bitmap (screen). The 8x8 pixel
pattern must be copied to off-screen memory on an 8-pixel horizontal boundary and its location
specified. Bit 6 ofthe Command register must be setto 1 to specify X as the major axis. Forthis example,
assume x1,y1 is the top left corner of the source rectangle in display memory and x2,y2 is the top left
corner ofthe destination rectangle. The rectangles can be overlapping or disjoint. The height and width
(in pixels) of the rectangle being copied are HEIGHT and WIDTH.
Setup:
First, the values ofthe Srcx, Srcy, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, Y Positive: Srcx = x1, Srcy = y1, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
Ifx1 >x2
then if X Positive, Srcx = x1, Destx = x2
else
Srcx = x1 + WIDTH -1, Destx = x2 + WIDTH-1 ; X Negative
Ify1 > y2
then if Y Positive, Srcy = y1, Desty = y2
else
Srcy = y1 + HEIGHT -1, Desty = y2 + HEIGHT-1 ; Y Negative
ES:[PIXEL_CNTL] ¢= AOOOH ; FRGD_MIX is the source of color source
ES:[FRGD_MIX] ¢= 006XH ; color source is screen, mix type is ignored
ES:[ROPMIX] ¢= OOXXH ; color pattern flag, XX = ROP code
Draw Operation:
31 15 0
ES:[ALT _PAT] ¢= LI _P_a_tx_..L-P_a-t-y'- ---'I ; set starting coordinates for pattern
31 15 0
ES:[ALT _CURXY] ¢= I'--_S_rc_x_-'--S_r-c-y'- ---'I ; set starting coordinates
31 15 0
ES:[AL T _STEP] ¢= IL_D_es_tx_..LD-_es--ty-' ---l ' ; set destination coordinates
31 15 0
ES:[ALT_PCNT] ¢= I WIDTH-1 I HEIGHT-1l ; rectangle width and height
ES:[CMD] ¢= 11001000DOD10001b ; ROPBLT (bits 15-13, 11), always X Major (bit 6) , draw (bit 4)
5-34 ENHANCED MODE PROGRAMMING

••
r
53 Vision868 Multimedia Accelerator
S3 Incorporated
Color Pattern Case 2 (Source = CPU, Color Pixels)
This command transfers a rectangular image from the CPU to the display memory through the plane.
"through the plane" means the complete color index is transferred for each pixel, e.g., in 8 bits/pixel
mode, one byte is required to transfer one pixel to memory. The image is stored as an array of pixels
arranged in row major fashion (consecutively increasing memory addresses). The Pixel Control register
must be setto AOOOH to select the Foreground Mix register to specify the color source. The color source
must be specified as the CPU. ROP codes without a source operand must not be used. The 8x8 pixel
pattern must be copied to off-screen memory on an 8-pixel horizontal boundary and its location
specified. Bit 12 of the Command register must be set to 1 (swap ON) for Intel-type architectures. Bit
8 of the Command register must be set to 1 (wait for CPU data) and bits 6 and 5 must also be set to 1
to specify X as the major axis and a left-to-right drawing direction. For this example, x1,y1 is the top
left corner of the rectangle on the screen. The height and width of the rectangle (in pixels) are HEIGHT
and WIDTH. Doublword CPU writes are supported by setting bits 10-9 of the Command register to 10b.
Setup:
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX is the source for color source
ES:[FRGD_MIX] <= 004XH ; color source is the CPU, mix type is ignored
ES:[ROPMIX] <= OOXXH ; color pattern flag, XX = ROP code
Drawing Operation:
31 15 0
ES:[ALT_PAT] <=1 Patx Paty 1 ; set starting coordinates for pattern
31 15 0
ES:[ALT _STEP] <= 1 x1 y1 1 ; set destination starting coordinates
31 15 0
ES:[ALT_PCNT] <=1 WIDTH-1 I HEIGHT-1 1 ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
ES:[CMD] <= 11001101D0110001b ; ROPBLT (bits 15-13, 11), swap ON (bit 12),
; 32-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4)
COUNT (of image pixel data to transfer) = (See Note)
PIX_TRANS <= I MAGEDATA ; Output image data to the Pixel Data Transfer registers for COU NT dwords.
Note
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred, the width ofthe transfer (8,16 or 32 bits as specified by bits 10-9 ofthe Drawing Command
register (9AE8H)) and the color depth (bits/pixel). The number of pixels transferred per line must be an
even multiple of the transfer width. If this is not the case, the last write per line must be padded with
one or more dummy pixels to meet this requirement. For example, at 4 bits/pixel, each byte holds two
pixels. If the transfer width is one byte and three pixels are to be transferred per line, two bytes must
be written per line, with the upper nibble of the second byte a dummy pixel. If the transfer width is 16
bits, from one to three dummy pixels may be required to make the number of pixels per line an even
multiple of 16. The number of word writes required per line can be determined from the formula n =
(W+3)/4, with n being truncated to an integer if the result contains a fraction. Thus a six pixel transfer
requires (6+3)/4 = 2.25 = 2 words. This is then multiplied by the height of the the image (in pixels) to
determine the COUNT of words to be transferred. Similar procedures apply to every other combination
ENHANCED MODE PROGRAMMING 5-35

r-~ .
S3 Vision868 Multimedia Accelerator
53 Incorporated
ofthe variables affecting the COUNT. The formulas for all cases are given below, where W is the width
of the image and H is the height of the image, both in pixels.
COUNT for 4 bits/pixel modes
8-bit transfers: COUNT = (W+ 1) /2 * H bytes
16-bit transfers: COUNT = (W+3)/4 * H words
32-bit transfers: COUNT = (W+7)/8 * H dwords
COUNT for 8 bits/pixel modes
8-bit transfers: COUNT = W * H bytes
16-bit transfers: COUNT = (W+1)/2 * H words
32-bit transfers: COUNT = (W+3)/4 * H dwords
COUNT for 16 bits/pixel modes
8-bit transfers: Do not use this combination
16-bit transfers: COUNT = W * H words
32-bit transfers: COUNT = (W+1)/2 * H dwords
COUNT for 32 bits/pixel modes
8-bit transfers: COUNT = Do not use this combination
16-bit transfers: COUNT = 2W * H words
32-bit transfers: COUNT =W * H dwords
5-36 ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
S3 Incorporated
Color Pattern Case 3 (Source = CPU, Mono Pixels)
This command transfers a rectangular image from the CPU to the display memory across the plane.
"across the plane" means that each bit sent by the CPU is stored in display memory as a single pixel.
These pixels are arranged in row major fashion (consecutively increasing memory addresses). An
"across the plane" transfer is created by (1) setting bits 7-6 of the Pixel Control register to A080H to
specify the CPU as the source of the mask bit selecting the mix register, (2) specifying a background
and foreground color, (3) setting bit 8 of the Command register (9AE8H) to 1 (wait for CPU data) and
(4) setting bit 1 of the Command register to 1 (multi-pixel). ROP codes without a source operand must
not be used. The 8x8 pixel pattern must be copied to off-screen memory on an 8-pixel horizontal
boundary and its location specified. When the pattern bit sent by the CPU is a 1, the Foreground Mix
register specifies the the color source and mix. When the bit is a 0, the Background Mix register specifies
the color source and mix. For this example, x1.y1 is the top left corner of the rectangle on the screen.
The height and width of the rectangle (in pixels) are HEIGHT and WIDTH. The monochrome image is
translated so that pixels corresponding to a 1 in the bit image are given color index 4 and pixels
corresponding to a 0 in the bit image are given color index O. This example uses word transfers from
the CPU as specified by setting bits 10-9 of the Command register to 01b for a 16-bit bus width.
Setup:
31r -I --....1.5 .----10
ES:[AL T_ MIX) ~ '-_0_0_2_X_H---'-_0_00_X_H-----'_ ; FRGD_COLOR is color source
; BKGD_COLOR is color source
ES:[FRGD_COLOR) ~ 00000004H ; foreground color index 4
ES:[BKGD_COLOR) ~ OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTLI <= A080H ; selection of mix register is based on data from the CPU
ES:[ROPMIX) ~ OOXXH ; color pattern flag, XX = ROP code
Drawing Operation:
31 15 0
I l
ES:[ALT_PAT) ~ Patx Paty ; set starting coordinates for pattern
31 15 0
I I
ES:[ALT _STEP) ~ x1 y1 ; set destination starting coordinates
31 15 0
I I
ES:[ALT_PCNT) ~ WIDTH-1 HEIGHT-1 1 ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
CMD~ 11001011D0110011b ; ROPBLT (bits 15-13, 11), swap ON (bit 12),
; 16-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4),
; multi-pixel (bit 1)
COUNT (of image pixel data to transfer) = ((WIDTH +15)/16)*HEIGHT words
PIX_TRANS ~ IMAGEDATA; Output image data to Pixel Transfer register for COUNT words
Notes
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred and the width ofthe transfer (8, 16 or 32 bits as specified by bits 10-9 of 9AE8H). Except for
the case where bits 10-9 of 9AE8H are 11 b, the number of pixels transferred per line must be an even
multiple of the transfer width. If this is not the case, the last write per line must be padded with one or
more dummy pixels to meet this requirement. For example, if the transfer width is 8 bits and nine
ENHANCED MODE PROGRAMMING 5-37

S3 Vision868 Multimedia Accelerator
S3 Incorporated
pixels are to be transferred per line, two bytes must be written per line, with the upper 7 bits of the
second byte padded. In general, the number of padding bits per line will vary from 0 to (n-1), where n
is the transfer width in bits.
With a transfer width of B bits, the number of byte writes required per line can be determined from the
formula n = (W+7)/B, with n being truncated to an integer if the result contains a fraction. Thus a 13-bit
pixel transfer requires (13+7)/B = 2.5 = 2 bytes. This is then multiplied by the height of the image (in
pixels) to determine the COUNT of bytes to be transferred. Similar procedures apply to every other
combination of the variables affecting the COUNT. The formulas for all cases are given below, where
W is the width of the image and H is the height of the image, both in pixels.
B-bit transfers: COUNT = (W+7)/B * H bytes (9AEBH_10-9 = OOb)
16-bit transfers: COUNT = (W+15)/16 * H words (9AEBH_10-9 = 01b)
32-bit transfers: COUNT = (W+31)/32 * H dwords (9AEBH_10-9 = 10b)
New 32-bit transfers: COUNT = (((W+7)/B*H)+3)/4 dwords (9AEBH_10-9 = 11b)
The differences between the two 32-bit transfer options are:
1. For 9AEBH_10-9 set to 10b, every line of the transfer must start with a fresh doubleword. In other
words, all unneeded bits in a doubleword transfer for a given line are discarded. After a rectan
gular image is transferred, the current drawing position is a the bottom left, meaning the next
rectangle, if drawn, will be below the previous rectangle.
2. For 9AEBH_10-9 set to 11 b, only bits from the end of the line width to the next byte boundary are
discarded. Data for the next line begins with the next byte. After a rectangular image is trans
ferred, the current drawing position is a the top right, meaning the next rectangle, if drawn,
will be to the right of the previous rectangle.
To write to a single plane, setthe foreground mix to 'logical one' (0002H), the background mixto 'logical
zero' (0001 H), and the Write Mask register (AAEBH) to select the desired (single) plane for updates.
5-3B ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
S3 Incorporated
Mono Pattern Case 1 (Source = Screen. Color Pixels)
This command copies a source rectangular area in display memory to another location in display
memory. It is identical to the Color Pattern Case 1 except that the Pattern Foreground and Background
Colors registers are programmed, the Bitplane Read Mask register is programmed to select the same
bitplane enabled by the Bitplane Write Mask register when the pattern is written to memory and the
mono pattern flag is set in the ROPMIX register. The Pixel Control register must be set to AOOOH to
select the Foreground Mix register to specify the color source. The color source must be specified as
the bitmap (screen). The 8x8 mono pattern must be copied to off-screen memory on an 8-bit horizontal
boundary and its location specified. Bit 6 of the Command register must be set to 1 to specify X as the
major axis. For this example, assume x1.y1 is the top left corner of the source rectangle in display
memory and x2.y2 is the top left corner ofthe destination rectangle. The rectangles can be overlapping
or disjoint. The height and width (in pixels) of the rectangle being copied are HEIGHT and WIDTH.
Setup:
First, the values of the Srcx, Srcy, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, Y Positive: Srcx = x1, Srcy = y1, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
If x1 > x2
then if X Positive, Srcx = x1. Destx = x2
else
Srcx = x1 + WIDTH -1, Destx = x2 + WIDTH-1 ; X Negative
Ify1 > y2
then if Y Positive, Srcy = y1, Desty =y 2
else
Srcy = y1 + HEIGHT -1, Desty = y2 + HEIGHT-1 ; Y Negative
ES:[PIXEL_CNTL) <= AOOOH ; FRGD_MIX is the source of color source
ES:[FRGD_MIX) <= 006XH ; color source is screen, mix type is ignored
ES:[ROPMIX) <= 01XXH ; mono pattern flag, XX = ROP code
ES:[PAT_FG_COLOR) <= 00000004H ; foreground color index 4
ES:[PAT_BG_COLOR) <= OOOOOOOOH ; background color index 0
ES:[RD_MASK) <= 00000001H ; bitplane 0 enabled for reading
Draw Operation:
31 15 a
J
Paty ; set starting coordinates for pattern
31 15 a
ES:[ALT_CURXY) <= _S_rc_x_--'--_S--rc-'y- ----' ; set starting coordinates
,-I 1
31 15 a
J
ES:[ALT _STEP) <= '--_D_e_st_x_-'D--e_s-t-y-' ---' ; set destination coordinates
ENHANCED MODE PROGRAMMING 5-39

S3 Vision868 Multimedia Accelerator
S3 Incorporated
31 15 0
I I J
ES:[ALT_ PC NT) <= WIDTH-1 HEIGHT-1 ; rectangle width and height
ES:[CMD) <= 11001000DOD10001b ; ROPBLT (bits 15-13, 11), always X Major (bit 6) , draw (bit 4)
5-40 ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
53 Incorporated
Mono Pattern Case 2 (Source = CPU, Color Pixels)
This command transfers a rectangular image from the CPU to the display memory through the plane.
It is identical to the Color Pattern Case 2 described earlier except that the Pattern Foreground and
Background Colors registers are programmed, the Bitplane Read Mask register is programmed to select
the same bitplane enabled by the Bitplane Write Mask register when the pattern is written to memory
and the mono pattern flag is set in the ROPMIX register. "through the plane" means the complete color
index is transferred for each pixel, e.g., in 8 bits/pixel mode, one byte is required to transfer one pixel
to memory. The image is stored as an array of pixels arranged in row major fashion (consecutively
increasing memory addresses). The Pixel Control register must be set to AOOOH to select the Fore
ground Mix register to specify the color source. The color source must be specified as the CPU. ROP
codes without a source operand must not be used. The 8x8 mono pattern must be copied to off-screen
memory on an 8-bit horizontal boundary and its location specified. Bit 12 of the Command register
must be set to 1 (swap ON) for Intel-type architectures. Bit 8 of the Command register must be set to
1 (wait for CPU data) and bits 6 and 5 must also be setto 1 to specify X asthe major axis and a left-to-right
drawing direction. For this example, x1,y1 is the top left corner of the rectangle on the screen. The
height and width of the rectangle (in pixels) are HEIGHT and WIDTH. Doublword CPU writes are
supported by setting bits 10-9 of the Command register to 10b.
Setup:
ES:[PIXEL_CNTL) <= AOOOH ; FRGD_MIX is the source for color source
ES:[FRGD_MIX) <= 004XH ; color source is the CPU, mix type is ignored
ES:[ROPMIX] <= 01XXH ; mono pattern flag, XX = ROP code
ES:[PAT_ FG_COLOR) <= 00000004H ; foreground color index 4
ES:[PAT_BG_COLOR) <= OOOOOOOOH ; background color index 0
ES:[RD_MASK) <= 00000001H ; bitplane 0 enabled for reading
Drawing Operation:
31 15 0
<=1 l
ES:[ALT_PAT] Patx Paty ; set starting coordinates for pattern
31 15 0
ES:[ALT _STEP) <= 1 x1 y1 l ; set destination starting coordinates
31 15 0
<=1 1
ES:[AL T_ PC NT) WIDTH-1 HEIGHT-1l ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
<=
ES:[CMD) 11001101D0110001b ; ROPBLT (bits 15-13, 11), swap ON (bit 12),
; 32-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4)
COUNT (of image pixel data to transfer) = (See Note)
PIX_TRANS <= IMAGEDATA; Output image data to the Pixel Data Transfer registers for COUNT dwords.
Note
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred, the width ofthe transfer (8,16 or 32 bits as specified by bits 10-9 ofthe Drawing Command
register (9AE8H)) and the color depth (bits/pixel). The number of pixels transferred per line must be an
even multiple of the transfer width. If this is not the case, the last write per line must be padded with
one or more dummy pixels to meet this requirement. For example, at 4 bits/pixel, each byte holds two
ENHANCED MODE PROGRAMMING 5-41

S3 Vision868 Multimedia Accelerator
53 Incorporated
pixels. If the transfer width is one byte and three pixels are to be transferred per line, two bytes must
be written per line, with the upper nibble of the second byte a dummy pixel. Ifthe transfer width is 16
bits, from one to three dummy pixels may be required to make the number of pixels per line an even
multiple of 16. The number of word writes required per line can be determined from the formula n =
{W+3)/4, with n being truncated to an integer if the result contains a fraction. Thus a six pixel transfer
requires (6+3)/4 = 2.25 = 2 words. This is then multiplied by the height of the the image (in pixels) to
determine the COUNT of words to be transferred. Similar procedures apply to every other combination
of the variables affecting the COUNT. The formulas for all cases are given below, where W is the width
of the image and H is the height of the image, both in pixels.
COUNT for 4 bits/pixel modes
8-bit transfers: COUNT = {W+1)/2 * H bytes
16-bit transfers: COUNT = {W+3)/4 * H words
32-bit transfers: COUNT = {W+7)/8 * H dwords
COUNT for 8 bits/pixel modes
8-bit transfers: COUNT = W * H bytes
16-bit transfers: COUNT = {W+1)/2 * H words
32-bit transfers: COUNT = {W+3)/4 * H dwords
COUNT for 16 bits/pixel modes
8-bit transfers: Do not use this combination
16-bit transfers: COUNT = W * H words
32-bit transfers: COUNT = {W+ 1) /2 * H dwords
COUNT for 32 bits/pixel modes
8-bit transfers: COUNT = Do not use this combination
16-bit transfers: COUNT = 2W * H words
32-bit transfers: COUNT = W * H dwords
5-42 ENHANCED MODE PROGRAMMING

83 Vision868 Multimedia Accelerator
S3 Incorporated
Mono Pattern Case 3 (Source = CPU, Mono Pixels)
This command transfers a rectangular image from the CPU to the display memory across the plane. It
is identical to the Color Pattern Case 3 described earlier except that the Pattern Foreground and
Background Colors registers are programmed, the Bitplane Read Mask register is programmed to select
the same bitplane enabled by the Bitplane Write Mask register when the pattern is written to memory
and the mono pattern flag is set in the ROPMIX register.  "across the plane" means that each bit sent
by the CPU is stored in display memory as a single pixel. These pixels are arranged in rowmajorfashion
(consecutively increasing memory addresses). An "across the plane" transfer is created by (1) setting
bits 7-6 of the Pixel Control register to A080H to specify the CPU as the source of the mask bit selecting
the mix register, (2) specifying a background and foreground color, (3) setting bit 8 of the Command
register (9AE8H) to 1 (wait for CPU data) and (4) setting bit 1 ofthe Command register to 1 (multi-pixel).
ROP codes without a source operand must not be used. The 8x8 mono pattern must be copied to
off-screen memory on an 8-bit horizontal boundary and its location specified. When the pattern bit sent
by the CPU is a 1, the Foreground Mix register specifies the the color source and mix. When the bit is
a 0, the Background Mix register specifies the color source and mix. For this example, x1.y1 is the top
left corner of the rectangle on the screen. The height and width of the rectangle (in pixels) are HEIGHT
and WIDTH. The monochrome image is translated so that pixels corresponding to a 1 in the bit image
are given color index 4 and pixels corresponding to a 0 in the bit image are given color index O. This
example uses word transfers from the CPU as specified by setting bits 10-9 of the Command register
to 01 b for a 16-bit bus width.
Setup:
|     | 31  15  0  |     |
| --- | ---------- | --- |
ES:[AL T_ MIX] ¢=  1'---0-0-2X-H---''---0-00-X-H-]  ; FRGD_COLOR is color source
; BKGD_COLOR is color source
| ES:[FRGD_COLOR] ¢= 00000004H  | ; foreground color index 4  |     |
| ----------------------------- | --------------------------- | --- |
| ES:[BKGD_COLOR] ¢= OOOOOOOOH  | ; background color index 0  |     |
ES:[PIXEL_CNTL] ¢= A080H  ; selection of mix register is based on data from the CPU
| ES:[ROPMIX) ¢= 01XXH            | ; mono pattern flag, XX = ROP code  |     |
| ------------------------------- | ----------------------------------- | --- |
| ES:[PAT_FG_COLOR) ¢= 00000004H  | ; foreground color index 4          |     |
| ES:[PAT_BG_COLOR) ¢= OOOOOOOOH  | ; background color index 0          |     |
| ES:[RD_MASK) ¢= 00000001H       | ; bitplane 0 enabled for reading    |     |
Drawing Operation:
|      | 31  15  0  |     |
| ---- | ---------- | --- |
| ¢=I  | I          |     |
ES:[ALT_PAT)  Patx  Paty  ; set starting coordinates for pattern
|     | 31  15  0  |     |
| --- | ---------- | --- |
|     | I  I       |     |
ES:[ALL STEP) ¢=  x1  y1  ; set destination starting coordinates
|                | 31  15  0          |                    |
| -------------- | ------------------ | ------------------ |
|                | ¢=I  I  I          |                    |
| ES:[ALT_PCNT)  | WIDTH-1  HEIGHT-1  | ; rectangle width  |
Wait for Graphics Engine not busy  ; loop till bit 9 of 9AE8H register is 0
¢=
CMD  11001011D0110011b  ; ROPBLT (bits 15-13, 11), swap ON (bit 12),
; 16-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4),
; mUlti-pixel (bit 1)
COUNT (of image pixel data to transfer) = ((WIDTH +15)/16)*HEIGHTwords
PIX_TRANS ¢= IMAGEDATA; Output image data to Pixel Transfer register for COUNT words
ENHANCED MODE PROGRAMMING 5-43

,I.
S3 Vision868 Multimedia Accelerator
S3 Incorporated
Notes
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred and the width of the transfer (B, 16 or 32 bits as specified by bits 10-9 of 9AEBH). Except for
the case where bits 10-9 of 9AEBH are 11b, the number of pixels transferred per line must be an even
multiple of the transfe·r width. If this is not the case, the last write per line must be padded with one or
more dummy pixels to meet this requirement. For example, if the transfer width is B bits and nine
pixels are to be transferred per line, two bytes must be written per line, with the upper 7 bits of the
second byte padded. In general, the number of padding bits per line will vary from 0 to (n-1), where n
is the transfer width in bits.
With a transfer width of B bits, the number of byte writes required per line can be determined from the
formula n = (W+7)/B, with n being truncated to an integer if the result contains a fraction. Thus a 13-bit
pixel transfer requires (13+7)/B = 2.5 = 2 bytes. This is then multiplied by the height of the image (in
pixels) to determine the COUNT of bytes to be transferred. Similar procedures apply to every other
combination of the variables affecting the COUNT. The formulas for all cases are given below, where
W is the width of the image and H is the height of the image, both in pixels.
B-bit transfers: COUNT = (W+7)/B * H bytes (9AEBH_10-9 = OOb)
16-bit transfers: COUNT = (W+ 15)/16 * H words (9AEBH_10-9 = 01b)
32-bit transfers: COUNT = (W+31)/32 * H dwords (9AEBH_10-9 = 10b)
New 32-bit transfers: COUNT = (((W+7)/B*Hl+3)/4 dwords (9AEBH_10-9 = 11b)
The differences between the two 32-bit transfer options are:
1. For 9AEBH_10-9 set to 10b, every line of the transfer must start with a fresh doubleword. In other
words, all unneeded bits in a doubleword transfer for a given line are discarded. After a rectan
gular image is transferred, the current drawing position is a the bottom left, meaning the next
rectangle, if drawn, will be below the previous rectangle.
2. For 9AEBH_10-9 set to 11 b, only bits from the end of the line width to the next byte boundary are
discarded. Data for the next line begins with the next byte. After a rectangular image is trans
ferred, the current drawing position is a the top right, meaning the next rectangle, if drawn,
will be to the right of the previous rectangle.
To write to a single plane, setthe foreground mix to 'logical one' (0002H), the background mixto 'logical
zero' (0001H), and the Write Mask register (AAEBH) to select the desired (single) plane for updates.
5-44 ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
S3 Incorporated
5.4.3.19 Programmable Hardware Cursor
A programmable cursor is supported which is compatible with the Microsoft Windows (bit 4 of CR55
~ 0) and Xll (bit 4 of CR55 ~ 1) cursor definitions. The cursor size is 64 pixels wide by 64 pixels high,
with the cursor pattern stored in an off-screen area of display memory. Two monochrome images 64
bits wide by 64 bits high (512 bytes per image) define the cursor shape. The first bit image is an AND
mask and the second bit image is an XOR mask. The following is the truth table for the cursor display
logic.
AND Bit XOR Bit Displayed (Microsoft Windows) Displayed (X11)
0 0 Cursor Background Color Current Screen Pixel
0 1 Cursor Foreground Color Current Screen Pixel
1 0 Current Screen Pixel Cursor Background Color
1 1 NOT Current Screen Pixel Cursor Foreground Color
The hardware cursor color is taken from the Hardware Graphics Cursor Foreground Stack (CR4A) and
the Hardware Graphics Cursor Background Stack (CR4B) registers. Each ofthese is a stack ofthree 8-bit
registers. The stack pointers are reset to 0 by reading the Hardware Graphics Cursor Mode register
(CR45). The color value is then programmed by consecutive writes (low byte, second byte, third byte)
to the appropriate (foreground or background) register.
Enabling/Disabling the Cursor
The hardware cursor is disabled when a VGA-compatible mode is in use. It can be enabled or disabled
when in Enhanced mode (bit 0 of 4AE8H ~ 1), as follows.
CR39 <=AOH ; Unlock System Control registers
CR45_0 <= 1 ; Enable hardware cursor
CR45_0 <= 0 ; Disable hardware cursor
CR39 <= OOH ; Lock System Control registers
Positioning the Cursor
The cursor can be positioned at any point on the display, with the X,Y coordinates ranging from 0 to
2047. This enables the full cursor images to be displayed on the screen and partial cursor images to
be displayed at the right edge and the bottom edge of the screen. The cursor offset OX,OY has to be
set to 0,0 for a 1024x768 resolution. If X is > (1024 - 64) or Y is > (768 - 64), then a partial cursor is
visible at the right edge or top edge of the screen respectively. Note that if Y ~ 768 then the cursor is
not visible; it is residing in the off-screen area.
A partial cursor image can be displayed at the left edge or the top edge of the screen. To enable partial
cursor display at the top edge of the screen, Y is set to 0 and the Y offset register is set to OY (range
from 0 to 63). This displays the bottom 64-0Y rows of the cursor image at the currently set X position
and the top edge ofthe screen. Similarly, a partial cursor can be displayed at the left edge of the screen
by setting X to 0 and the X offset register to OX (range from 0 to 63). This displays the right 64-0X
columns of the cursor image at the currently set X and the left edge of the screen. The following
pseudocode illustrates cursor positioning.
CR39 <= AOH ; Unlock System Control registers
CR46_10-8 <= MS 3 bits of X cursor position
CR47 _7-0 <= LS 8 bits of X cursor position
ENHANCED MODE PROGRAMMING 5-45

S3 Vision868 Multimedia Accelerator
S3 Incorporated
CR49_7-0 <= LS 8 bits of Y cursor position
CR4E_5-0 <= Cursor Offset X position
CR4F _5-0 <= Cursor Offset Y position
CR48_10-8 <= MS 3 bits of Y cursor position
CR39 <= OOH ; Lock System Control registers
The cursor position is updated by the hardware once each frame. Therefore, the programmer should
ensure that the position is re-programmed no more than once for each vertical sync period.
Programming the Cursor Shape
The AND and the XOR cursor image bitmaps are 512 bytes each. These are stored in consecutive bytes
of off-screen display memory, 512 AND bytes followed by 512 XOR bytes. The starting location must
be on a 1024-byte boundary. This location is programmed into the Hardware Graphics Cursor Start
Address registers (CR4C and CR4D) as follows:
CR39 <= AOH ; Unlock System Control registers
CR4C_5-8 <= MS 4 bits of the cursor storage start 1024-byte segment.
CR4D <= LS 8 bits ofthe cursor storage start 1024-byte segment
CR39 <= 0 ; Lock System Control,registers
The value programmed is the 1024-byte segment of display memory at which the beginning of the
hardware cursor bit pattern is located. For example, for an 800x600x8 mode on a 1 MByte system,
there are 10241 K segments. Programming CR4C_11-8with 3H and CR4D with FEH specifies the starting
location as the 1022nd (O-based) 1K segment. The cursor pattern is programmed (using linear
addressing) at FF800H offset from the base address of the frame buffer.
Note
If the cursor is not 64 bits by 64 bits, the given images should be padded to make the cursor image 64
bits by 64 bits. The padded area should be made transparent by padding the extra AND mask bits with
'1's and the extra XOR bits by'O's.
5.5 RECOMMENDED READING
Graphics Programming for the 8514/A by Jake Richter and Bud Smith (M&T Publishing, Inc) provides
extensive explanations and examples for programming most of the bits in the S3 Enhanced Registers.
Although not released at the time this data book was printed, the 3rd edition of Programming Guide
to the EGA and VGA Cards by Richard F. Ferraro (Addison-Wesley Publishing Company, Inc) is
scheduled to include a section on programming for S3 accelerator chips.
5-46 ENHANCED MODE PROGRAMMING

S3 Vision868 Multimedia Accelerator
53 Incorporated
Section 6: Video Engine
This section describes the Video Engine provided  input and output bit settings are for SOSSH_22-20
by the VisionS6S. The Video Engine registers are  and SOSSH_1S-16 respectively.
described in Section 2.
The Video Engine processes one pixel per MCLK
regardless of the pixel depth. Input and output
6.1  VIDEO ENGINE OVERVIEW
FIFOs allow burst/block transfers from and to
memory to improve throughput.
The Video Engine obtains pixel data either from
video memory or the CPU, operates on it and  New MMIO operation (bits 4-3 of CR53 set to 11 b)
then writes to display memory. Particular pixels  is required for Video Engine access. If big endian
in memory can be masked off from being up  addressing is required, bits 2-1 of CR53 control
| dated by the video data. The operations the Video  |     |     |     | byte swapping.  |     |     |     |     |
| -------------------------------------------------- | --- | --- | --- | --------------- | --- | --- | --- | --- |
Engine can perform are scaling (both horizontal
and vertical), color space conversion (YUV to  The Video Engine cannot be used when the Vi
RGB) and dithering (reduce color depth from 24
sionS6S is being operated in packed 24 bits/pixel
bits/pixel to 16, 15 or S bits/pixel). The legal input
mode (bits 5-4 ofCR50 set to 10b).ltdoes not take
output combinations are listed in Table 6-1. The  advantage of 1-cycle EDO or burst mode memory
operation if one of these is specified (bits 3-2 of
Table 6-1  Video Engine Input/Output Combinations
|        |        | Output  | 000     | 011     | 100  | 101  | 110     | 111     |
| ------ | ------ | ------- | ------- | ------- | ---- | ---- | ------- | ------- |
|        | Width  |         | 8       | 32      | 16   | 16   | 16      | 16      |
| Input  |        | Format  | RGB332  | RGB888  | VC/  | raw  | RGB555  | RGB565  |
VUV442
| 000  | 8   | RGB332  | S      | No   | No  | No  | No     | No     |
| ---- | --- | ------- | ------ | ---- | --- | --- | ------ | ------ |
| 011  | 32  | RGB888  | SID    | S    | No  | No  | SID    | SID    |
| 100  | 16  | VC/VUV  | S/C/D  | SIC  | S   | No  | S/C/D  | S/C/D  |
422
| 101  | 16  | raw     | No   | No  | No  | S   | No  | No  |
| ---- | --- | ------- | ---- | --- | --- | --- | --- | --- |
| 110  | 16  | RGB555  | SID  | S   | No  | No  | S   | S   |
| 111  | 16  | RGB565  | SID  | S   | No  | No  | S   | 5   |
S = Scaling
C = Color Space Conversion
D = Dithering
VIDEO ENGINE 6-1

S3 Vision868 Multimedia Accelerator
53 Incorporated
CR36 set to 10b or 11 b. Instead, it will use stand stretching. The reverse is true for shrinking the
ard fast page or EDO cycles. image.
The Video Engine and the Graphics Engine must If filtering is required, it is enabled via bit 31 of
not be in use at the same time. To ensure this, SOSSH. The type of filtering is specified via bits
the Video Engine NOP register (SOSOH) must be 15-14 of SOSCH.
written to after all Video Engine data/commands
have been written. Similarly, a Graphics Engine The output data format is specified via bits 1S-16
NOP must be executed after a Graphics Engine ofSOSSH.lfthe output is S bits/pixel RGB, setting
access before the Video Engine can be written to bit 2S of SOSSH to 1 palettizes the data, i.e., each
again. byte is a color look up table (lUT) address. This
output protects the upper and lower 10 lUTslots,
which are used for system colors. Therefore, it
6.2 SCALING
maps certain adjacent pairs of data values to the
same lUT address so that all 256 values generate
Bit 31 of SOSCH is cleared to 0 to specify a stretch a non-protected color.
and set to 1 to specify a shrink. Bit 30 of SOSCH is
cleared to 0 to specify display memory as the The output can be cropped by specifying a start
data source and set to 1 to specify the CPU as the value and length in S094H. Alternately, the output
data source. If display memory is the data source, can be masked against a mask pattern stored in
the starting address for the data is specified in main (system) memory. This is enabled by set
S09SH. The amount of stretch or shrink is speci ting bit 26 of SOSSH to 1. The mask contains one
fied by programming source and destination bitforeach pixel in on-screen memory. The mask
steps in S090H and also programming the follow data must be sent by the CPU just prior to proc
ing DDA parameters. essing ofthe relevant screen pixels.
The internal digital differential analyzer (DDA) is If bit 29 of SOSCH is cleared to 0, a bit value of 1
programmed by specifying the DDA accumulator in the mask allows the video to overwrite the
initial value in bits 11-0 of SOSSH and the K1 and graphics pixel and a value of 0 protects the graph
K2 constants via bits 10-0 and 26-16 of SOSCH. ics pixel from being overwritten. If this bit is set
to 1, the effect is reversed.
The input data format is specified via bits 22-20
of SOSSH. If 100b is specified, bit 19 of SOSSH is
6.3 COLOR SPACE CONVERSION
cleared to 0 to specify YCbCr and set to 1 to
specify YUV.
Either YUV or YCbCr 4-4-2 input can be converted
A single pass through the Video Engine produces to RGB format. YUV/YCbCr input is selected by
a one-dimensional stretch or shrink (horizontal or setting bits 22-20 ofSOSSH to 100b. YUVorYCbCr
vertical). This can be written directly to on-screen is selected via bit 19 of SOSSH (YUV = 1; YCbCr =
memory. A two-dimensional scaling requires 0). The output data format is selected via bits
two passes. The first pass writes the one-dimen 1S-16 of SOSSH. This can be RGB-S (=OOOb), RGB-
sionally scaled data to off-screen memory. The 15 (=110b), RGB-16 (=111 b) or RGB-32 (=011 b).
second pass BitBlT s the off-screen image to on
screen memory while performing the scaling in YUV/YCbCr data can be scaled before it is con
the other dimension. Both the amount of scaling verted. If two pass scaling is being performed,
and the dimension (horizontal or vertical) are color space conversion should be done during
controlled by the step constants programmed the horizontal pass.
into S090H.
6.4 DITHERING
Vertical scaling requires much more bandwidth
than horizontal scaling. Therefore, vertical scal
ing should be done during the first pass and Ifthe bits/pixel (color depth) ofthe data in display
horizontal scaling during the second pass for memory is less than the input data (or the gener-
6-2 VIDEO ENGINE

S3 Vision868 Multimedia Accelerator
S3 Incorporated
ated output of a color space conversion), the data
must have its color depth reduced to match that
used in display memory. This is called dithering.
24 bits/pixel can be dithered to 16, 15 or 8
bits/pixel. 16 or 15 bits/pixel can be dithered to 8
bits/pixel.
When the final output is 8 bits/pixel, the pixel
value is an index into a 256 position color look up
table (LUT). Windows uses the top and bottom
10 colors for its system colors. To avoid overwrit
ing these colors, the Video Engine maps its 256
color values into the 236 LUT positions not used
by Windows. The lost color values are spread
evenly over the range to minimize the effect.
Dithering is enabled by setting bit 29 of 8088H to
1. The dithering matrix index must be pro
grammed via bits 25-23 of 8088H.
Dithering is done after scaling and color space
conversion. As with color space conversion, it
should be done in the horizontal pass of a two
pass scaling operation.
6.5 STATUS
Bit 31 of B09CH is read-only. When set to 1, it
indicates the Video Engine is in use.
VIDEO ENGINE 6-3

II·
S3 Vision868 Multimedia Accelerator
S3 Incorporated

S3 Vision868 Multimedia Accelerator
53 Incorporated
Appendix A: Listing of Raster Operations
The Vision868 supports all 256 triadic raster op The boolean operators used as as follows:
erations (ROPs) for BitBlT s as defined by
Microsoft for Windows. The coding for these is o = bitwise OR
found on the following pages.
x = bitwise EXCLUSIVE OR
The HEX value in the first column is the ROP
code. This value must be programmed into bits a = bitwise AND
7-0 of D2E8H atthe time that a ROPBlT command
is executed. n = bitwise NOT (inverse)
The effect of the ROP is shown in reverse Polish For example, ROP 16H is PSDPSanaxx. The pat
notation in the second column. This is interpreted tern is first ANDed with the source
as follows: [PSO(PaS}naxx). The result is inverted and then
AN Oed with the destination [PS((Oa(notPaS}}xx.
S = Source bitmap This result is EXCLUSIVE ORed with the source.
Finally, the result ofthis is EXCLUSIVE ORed with
P = Pattern the pattern.
D = Destination bitmap Programming using ROPBlT s is explained in En
hanced Mode Programming section.
The source bitmap can be either the CPU or the
current screen, as selected via bits 6-5 of either
A2E8H or A6E8H. A CPU source can be either
monochrome or color. A screen source is always
color.
The pattern, if present, is found at the off-screen
memory location specified by EAE8H and
EAEAH. The pattern may be either monochrome
or color, as specified by bit 8 of 02E8H. If the
pattern is monochrome, its background color is
specified by E6E8H and its foreground color by
EEE8H.
The destination bitmap is always the screen. It is
always color (as opposed to monochrome).
LISTING OF RASTER OPERATIONS A-1

••
r
53 Vision868 Multimedia Accelerator
S3 Incorporated
| ,  HEX  |     | HEX  | In Reverse Polish  |
| ------- | --- | ---- | ------------------ |
In Reverse Polish
|        |          | 2C  | SPDSoax   |
| ------ | -------- | --- | --------- |
| 00     | 0        |     |           |
| 01     | DPSoon   | 2D  | PSDnox    |
| 02     | DPSona   | 2E  | PSDPxox   |
| 03     | PSon     | 2F  | PSDnoan   |
|        |          | 30  | PSna      |
| 04     | SDPona   |     |           |
|        |          | 31  | SDPnaon   |
| 05     | DPon     |     |           |
| 06     | PDSxnon  | 32  | SDPSoox   |
| 07     | PDSaon   | 33  | Sn        |
| 08     | SDPnaa   | 34  | SPDSaox   |
| 09     | PDSxon   | 35  | SPDSxnox  |
|        |          | 36  | SDPox     |
| OA     | DPna     |     |           |
|        |          | 37  | SDPoan    |
| 08     | PSDnaon  |     |           |
| OC     | SPna     | 38  | PSDPoax   |
| OD     | PDSnaon  | 39  | SPDnox    |
| OE     | PDSonon  | 3A  | SPDSxox   |
|        |          | 38  | SPDnoan   |
| OF     | Pn       |     |           |
|        |          | 3C  | PSx       |
| 10     | PDSona   |     |           |
| ,  11  | DSon     | 3D  | SPDSonox  |
| 12     | SDPxnon  | 3E  | SPDSnaox  |
| 13     | SDPaon   | 3F  | PSan      |
| 14     | DPSxnon  | 40  | PSDnaa    |
|        |          | 41  | DPSxon    |
| 15     | DPSaon   |     |           |
SDxPDxa
| 16     | PSDPSanaxx  | 42  |             |
| ------ | ----------- | --- | ----------- |
| 17     | SSPxDSxaxn  | 43  | SPDSanaxn   |
| 18     | SPxPDxa     | 44  | SDna        |
| 19     | SDPSanaxn   | 45  | DPSnaon     |
|        |             | 46  | DSPDaox     |
| 1A     | PDSPaox     |     |             |
|        |             | 47  | PSDPxaxn    |
| ,  18  | SDPSxaxn    |     |             |
| 1C     | PSDPaox     | 48  | SDPxa       |
| 10     | DSPDxaxn    | 49  | PDSPDaoxxn  |
| 1E     | PDSox       | 4A  | DPSDoax     |
| 1F     | PDSoan      | 48  | PDSnox      |
|        |             | 4C  | SDPana      |
| 20     | DPSnaa      |     |             |
|        |             | 4D  | SSPxDSxoxn  |
| 21     | SDPxon      |     |             |
| 22     | DSna        | 4E  | PDSPxox     |
| 23     | SPDnaon     | 4F  | PDSnoan     |
| 24     | SPxDSxa     | 50  | PDna        |
|        |             | 51  | DSPnaon     |
| 25     | PDSPanaxn   |     |             |
|        |             | 52  | DPSDaox     |
| 26     | SDPSaox     |     |             |
| i  27  | SDPSxnox    | 53  | SPDSxaxn    |
| 28     | DPSxa       | 54  | DPSonon     |
| 29     | PSDPSaoxxn  | 55  | Dn          |
| 2A     | DPSana      | 56  | DPSox       |
|        |             | 57  | DPSoan      |
| 28     | SSPxPDxaxn  |     |             |
,,,N. MN. .. """~W.=,,,""'~  N'N'_ _ N" __ '·'_"""'''''''''M''',........,.=-M·
A-2  LISTING OF RASTER OPERATIONS

••
r
S3 Vision868 Multimedia Accelerator
53 Incorporated
| HEX   | In Reverse Polish  | HEX  | In Reverse Polish  |
| ----- | ------------------ | ---- | ------------------ |
| 58    | PDSPoax            | 84   | SDPxna             |
| 59    | DPSnox             | 85   | PDSPnoaxn          |
| 5A    | DPx                | 86   | DSPDSoaxx          |
| 58    | DPSDonox           | 87   | PDSaxn             |
| 5C    | DPSDxox            | 88   | DSa                |
| 5D    | DPSnoan            | 89   | SDPSnaoxn          |
| 5E    | DPSDnaox           | 8A   | DSPnoa             |
| 5F    | DPan               | 88   | DSPDxoxn           |
| 60    | PDSxa              | 8C   | SDPnoa             |
| 61    | DSPDSaoxxn         | 8D   | SDPSxoxn           |
| 62    | DSPDoax            | 8E   | SSDxPDxax          |
| 63    | SDPnox             | 8F   | PDSanan            |
| 64    | SDPSoax            | 90   | PDSxna             |
| 65    | DSPnox             | 91   | SDPSnoaxn          |
| 66    | DSx                | 92   | DPSDPoaxx          |
| 67    | SDPSonox           | 93   | SPDaxn             |
| 68    | DSPDSonoxxn        | 94   | PSDPSoaxx          |
| 69    | PDSxxn             | 95   | DPSaxn             |
| 6A    | DPSax              | 96   | DPSxx              |
| 68    | PSDPSoaxxn         | 97   | PSDPSonoxx         |
| 6C    | SDPax              | 98   | SDPSonoxn          |
| 6D    | PDSPDoaxxn         | 99   | DSxn               |
| 6E    | SDPSnoax           | 9A   | DPSnax             |
| 6F    | PDSxnan            | 98   | SDPSoaxn           |
| 70    | PDSana             | 9C   | SPDnax             |
| 71    | SSDxPDxaxn         | 9D   | DSPDoaxn           |
| 72    | SDPSxox            | 9E   | DSPDSaoxx          |
| 73    | SDPnoan            | 9F   | PDSxan             |
| 74    | DSPDxox            | AO   | DPa                |
| 75    | DSPnoan            | A1   | PDSPnaoxn          |
| 1 76  | SDPSnaox           | lA2  |                    |
DPSnoa
| 77  | DSan        | A3     | DPSDxoxn   |
| --- | ----------- | ------ | ---------- |
| 78  | PDSax       | A4     | PDSPonoxn  |
| 79  | DSPDSoaxxn  | A5     | PDxn       |
| 7A  | DPSDnoax    | A6     | DSPnax     |
| 78  | SDPxnan     | i  A7  | PDSPoaxn   |
| 7C  | SPDSnoax    | A8     | DPSoa      |
| 7D  | DPSxnan     | A9     | DPSoxn     |
| 7E  | SPxDSxo     | AA     | D          |
| 7F  | DPSaan      | A8     | DPSono     |
| 80  | DPSaa       | AC     | SPDSxax    |
| 81  | SPxDSxon    | AD     | DPSDaoxn   |
| 82  | DPSxna      | AE     | DSPnao     |
LISTING OF RASTER OPERATIONS  A-3

S3 Vision868 Multimedia Accelerator
S3 Incorporated
HEX
|     | In Reverse Polish  | HEX  | In Reverse Polish  |     |
| --- | ------------------ | ---- | ------------------ | --- |
| BO  | PDSnoa             | DC   | SPDnao             |     |
| B1  | PDSPxoxn           | DD   | SDno               |     |
| B2  | SSPxDSxox          | DE   | SDPxo              |     |
l
| B3  | SDPanan  | DF  |     |     |
| --- | -------- | --- | --- | --- |
SDPano
| B4  | PSDnax    | EO     | PDSoa   |     |
| --- | --------- | ------ | ------- | --- |
| B5  | DPSDoaxn  | ,  E1  | PDSoxn  |     |
I
| B6  | DPSDPaoxx  | E2     | DSPDxax    |     |
| --- | ---------- | ------ | ---------- | --- |
| B7  | SDPxan     | E3     | PSDPaoxn   |     |
| B8  | PSDPxax    | E4     | SDPS xa x  |     |
| B9  | DSPDaoxn   | E5     | PDSPaoxn   |     |
| BA  | DPSnao     | \  E6  | SDPSanax   |     |
I
| BB  | DSno  | E7  | SPxPDxan  |     |
| --- | ----- | --- | --------- | --- |
!
| BC  | SPDSanax  | E8    | SSPxDSxax    |     |
| --- | --------- | ----- | ------------ | --- |
| BD  | SDxPDxan  | , E9  | DSPDSanaxxn  |     |
| BE  | DPSxo     | EA    | DPSao        |     |
l
| BF  | DPSano     | EB  | DPSxno  | l   |
| --- | ---------- | --- | ------- | --- |
| CO  | PSa        | EC  | SDPao   |     |
| C1  | SPDSnaoxn  | ED  | SDPxno  |     |
| C2  | SPDSonoxn  | EE  | DSo     |     |
| C3  | PSxn       | EF  | SDPnoo  |     |
| C4  | SPDnoa     | FO  | P       |     |
| C5  | SPDSxoxn   | F1  | PDSono  |     |
| C6  | SDPnax     | F2  | PDSnao  |     |
| C7  | PSDPoaxn   | F3  | PSno    |     |
| C8  | SDPoa      | F4  | PSDnao  |     |
C9
|     | SPDoxn    | F5    | PDno    |     |
| --- | --------- | ----- | ------- | --- |
| CA  | DPSDxax   | F6    | PDSxo   |     |
| CB  | SPDSaoxn  | F7    | PDSano  |     |
| CC  | S         | F8    | PDSao   |     |
| CD  | SDPono    | I F9  | PDSxno  |     |
| CE  | SDPnao    | FA    | DPo     |     |
I
| CF  | SPno      | FB    | DPSnoo  |     |
| --- | --------- | ----- | ------- | --- |
| DO  | PSDnoa    | IFC   | PSo     |     |
| D1  | PSDPxoxn  | FD    | PSDnoo  |     |
| D2  | PDSnax    | j FE  | DPSoo   |     |
| D3  | SPDSoaxn  | I     | 1       |     |
FF
| D4  | SSPxPDxax  |     |     |     |
| --- | ---------- | --- | --- | --- |
| D5  | DPSanan    |     |     |     |
| D6  | PSDPSaoxx  |     |     |     |
| D7  | DPSxan     |     |     |     |
| D8  | PDSPxax    |     |     |     |
| D9  | SDPSaoxn   |     |     |     |
I
| DA                    | DPSDanax          |     |     |     |
| --------------------- | ----------------- | --- | --- | --- |
| :  DB                 | SPxDSxan          | I   |     |     |
| '",  '~_""~'  ______  | "'~_~"m~,~~_,--1  |     |     |     |
A-4  LISTING OF RASTER OPERATIONS

S3 Vision868 Multimedia Accelerator
S3 Incorporated

