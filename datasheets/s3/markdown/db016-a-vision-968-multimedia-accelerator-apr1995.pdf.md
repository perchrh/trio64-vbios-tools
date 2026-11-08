••
r
S3 Vision968 Multimedia Accelerator
S3 Incorporated
Vision968
Multimedia
Accelerator
April 1995
S3 Incorporated
2770 San Tomas Expressway
Santa Clara, CA 95051-0968

S3 Vision968 Multimedia Accelerator
53 Incorporated
NOTATIONAL CONVENTIONS
The following notational conventions are used in this data book:
Signal names are shown in all uppercase letters. For example, XD.
A bar over a signal name indicates an active low signal. For example, OE.
nom indicates a bit field from bit n to bit m. For example, 7-0 specifies bits 7 through 0, inclusive.
n:m indicates a signal (pin) range from n to m. For example D[7:01 specifies data lines 7 through 0, inclusive
Use of a trailing letter H indicates a hexadecimal number. For example, 7AH is a hexadecimal number.
Use of a trailing letter b indicates a binary number. For example, 010b is a binary number.
When numerical modifiers such as K or M are used, they refer to binary rather than decimal form. Thus, for example, 1 KByte would be
equivalent to 1024, not 1,000 bytes.
NOTICES
© Copyright 1995 S3 Incorporated. All rights reserved. No part of this publication may be reproduced, stored in a retrieval system, or
transmitted in any form or by any means, electronic, mechanical, photocopying, or otherwise, without the prior written consent of S3
Incorporated, 2770 San Tomas Expwy., Santa Clara CA 95051-096S. The S3 Corporate Logo, S3 on Board, S3 on Board design, Vision64,
VisionS64, VisionS6S, Vision964, Vision96S, Trio, Tri032, Trio64, MIC, Galileo, SDAC, Native-MPEG, No Compromise Integration, No
Compromise Acceleration and Innovations in Acceleration are trademarks of S31ncorporated and S3 and True Acceleration are registered
trademarks of S3lncorporated. Other trademarks referenced in this document are owned by their respective companies. The material in
this document is for information only and is subject to change without notice. S31ncorporated reserves the rightto make changes in the
product design without reservation and without notice to its users.
Additional information may be obtained from:
S3lncorporated, Literature Department, 2770 San Tomas Expressway, Santa Clara, CA 95051-096S.
Telephone: 408-9S0-5400, Fax: 4OS-9S0-5444

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Table of Contents
| List of Figures  |     | .v  3.3.2  | RAMDAC Snooping ....... 3-1  |     |     |
| ---------------- | --- | ---------- | ---------------------------- | --- | --- |
3.3.3  Disconnect Related to FIFO
Status  .............. 3-2
| List of Tables  | .   | vi     |                                      |            |      |
| --------------- | --- | ------ | ------------------------------------ | ---------- | ---- |
|                 |     | 3.3.4  | Plug and Play Support                | . . . . .  | 3-2  |
|                 |     | 3.4    | PACKED 24-BITS/PIXEL SUPPORT .. 3-2  |            |      |
Section 1: Introduction  . 1-1  3.5  RAMDAC ACCESS CYCLES  .... 3-2
1.1  OVERVIEW OF THIS DATA  3.6  50 MHz VL-BUS SUPPORT. . . . .  3-2
BOOKLET  . . . . . . . . . . . . ..  1-1  3.7  WRITE PER BIT SUPPORT  . . . . .  3-2
1.2  PRODUCT OVERVIEW. . . . . ..  1-1  3.8  READ/MODIFY/WRITE TIMING. . .  3-5
|                                   |     | 3.9  | 1 CYCLE EDO VRAM SUPPORT  |     | . .  3-6  |
| --------------------------------- | --- | ---- | ------------------------- | --- | --------- |
| 1.3  ENHANCED VRAM SUPPORT. ..    |     | 1-1  |                           |     |           |
| 1.4  PACKED PIXEL ACCELERATION..  |     | 1-1  |                           |     |           |
1.5  ENHANCED MEMORY-MAPPED  Section 4: Electrical Data  ..... 4-1
| I/O IMPLEMENTATION. . . . . ..  |     | 1-1     |                               |                  |      |
| ------------------------------- | --- | ------- | ----------------------------- | ---------------- | ---- |
|                                 |     | 4.1     | MAXIMUM RATINGS ........ 4-1  |                  |      |
| 1.6  NEW DRAWING COMMANDS ...   |     | 1-2     |                               |                  |      |
|                                 |     | 4.2     | DC SPECIFICATIONS             | ........ 4-1     |      |
| 1.7  PCI SUPPORT ENHANCEMENTS   |     | .  1-2  |                               |                  |      |
|                                 |     | 4.3     | AC SPECIFICATIONS             | . . . . . . . .  | 4-2  |
1.8  VIDEO ENGINE  . . . . . . . . . ..  1-2  4.3.1  Clock Timing  .......... 4-3
1.9  RESOLUTIONS SUPPORTED  1-2  4.3.2  Input/Output Timing  . . . . . .  4-4
|                                    |          | 4.4  | OUTPUT BUFFER MODEL  |     | 4-7  |
| ---------------------------------- | -------- | ---- | -------------------- | --- | ---- |
| Section 2: Register Changes        | ... 2-1  |      |                      |     |      |
| 2.1  Vision968 REGISTER CHANGES..  |          | 2-1  |                      |     |      |
Section 5: Enhanced Mode
2.2  NEW Vision968 SR
|            |                           | Programming  |                                | ........ ... 5-1  |     |
| ---------- | ------------------------- | ------------ | ------------------------------ | ----------------- | --- |
| REGISTERS  | . . . . . . . . . . . ..  | 2-5          |                                |                   |     |
|            |                           | 5.1          | MEMORY-MAPPED I/O ....... 5-1  |                   |     |
2.3  NEW Vision968 CR
|            |                           | 5.1.1  | Backward-Compatible MMIO  |                  | .  5-1  |
| ---------- | ------------------------- | ------ | ------------------------- | ---------------- | ------- |
| REGISTERS  | . . . . . . . . . . . ..  | 2-6    |                           |                  |         |
|            |                           | 5.1.2  | New MMIO                  | ........... 5-2  |         |
2.4  NEW Vision968
ENHANCED COMMANDS  5.1.2.1  Big/Little Endian Support .. 5-4
5.1.2.2  Packed MMIO Register
| REGISTERS  | . . . . . . . . . . . ..  | 2-7  |          |                        |      |
| ---------- | ------------------------- | ---- | -------- | ---------------------- | ---- |
|            |                           |      | Mapping  | . . . . . . . . . . .  | 5-4  |
2.5  NEW Vision968 PCI CONFIGURATION
|     |     | 5.2  | DIRECT BITMAP ACCESSING- |     |     |
| --- | --- | ---- | ------------------------ | --- | --- |
SPACE REGISTERS ......... 2-14
|     |     |     | LINEAR ADDRESSING  | . . . . . . .  | 5-4  |
| --- | --- | --- | ------------------ | -------------- | ---- |
2.6  NEW Vision968 VIDEO ENGINE
5.2.1  Backward-Compatible Linear
REGISTERS ............. 2-15
|     |     |     | Addressing  | .. . . . . . . . . .  | 5-4  |
| --- | --- | --- | ----------- | --------------------- | ---- |
2.7  Vision964 REGISTERS REMOVED
|     |     | 5.2.2  | New Linear Addressing  | .... 5-5  |     |
| --- | --- | ------ | ---------------------- | --------- | --- |
FROM THE Vision968  ....... 2-20  5.3  BITMAP ACCESS THROUGH THE
|     |     |     | GRAPHICS ENGINE. . . . . . . . .  |     | 5-5  |
| --- | --- | --- | --------------------------------- | --- | ---- |
Section 3: Functional Changes  .. 3-1  5.4  PROGRAMMING..........  5-8
3.1  CHIP IDENTIFICATION  . . . . . . .  3-1  5.4.1  Notational Conventions  ... .  5-9
3.2  SHARED FRAME BUFFER MEMORY  5.4.2  Initial Setup  . . . . . . . . . . .  5-9
BANDWIDTH ALLOCATION  .... 3-1  5.4.3  Programming Examples  . ..  5-10
3.3  PCI ENHANCEMENTS  . . . . . ..  3-1  5.4.3.1  Solid Line  ......... 5-11
3.3.1  I nterru pt Support . . . . . . ..  3-1  5.4.3.2  Textured Line  . . . . . ..  5-12
iii

53 Vision968 Multimedia Accelerator
S3 Incorporated
| 5.4.3.3  | Rectangle Fill Solid    | ..... 5-14  |
| -------- | ----------------------- | ----------- |
| 5.4.3.4  | Image Transfer-Through  |             |
the Plane ........... 5-15
| 5.4.3.5  | Image Transfer-Across  |     |
| -------- | ---------------------- | --- |
the Plane ........... 5-17
| 5.4.3.6  | BitBlT-Throughthe Plane. 5-19      |     |
| -------- | ---------------------------------- | --- |
| 5.4.3.7  | BitBlT - Across the Plane .. 5-20  |     |
| 5.4.3.8  | PatBlT - Pattern Fill Through      |     |
the Plane ........... 5-22
| 5.4.3.9  | PatBlT-Pattern Fill Across  |     |
| -------- | --------------------------- | --- |
the Plane ........... 5-23
| 5.4.3.10 Short Stroke Vectors   |     | .... 5-24    |
| ------------------------------- | --- | ------------ |
| 5.4.3.11 Polyline/2-Point Line  |     | .... 5-25    |
| 5.4.3.12 Polygon Fill Solid     |     | ...... 5-26  |
5.4.3.13 Polygon Fill Pattern ..... 5-28
5.4.3.14 4-Point Trapezoid Fill Solid. 5-29
5.4.3.15 4-pointTrapezoid Fill
Pattern ............ 5-30
5.4.3.16 Bresenham Parameter
|     | Trapezoid Fill Solid  | ..  "  5-31  |
| --- | --------------------- | ------------ |
5.4.3.17 Bresenham Parameter
|                             | Trapezoid Fill Pattern.  | .. 5-32  |
| --------------------------- | ------------------------ | -------- |
| 5.4.3.18 ROPBlTs ....... ,  |                          | .. 5-33  |
5.4.3.19 Programmable Hardware
Cursor  ............ 5-45
| 5.5  RECOMMENDED READING  |     | .... 5-46  |
| ------------------------- | --- | ---------- |
Section 6: Video Engine ...... 6-1
| 6.1  VIDEO ENGINE OVERVIEW   |              | .. ..  6-1  |
| ---------------------------- | ------------ | ----------- |
| 6.2  SCALING..............   |              | 6-2         |
| 6.3  COLOR SPACE CONVERSION  |              | 6-2         |
| 6.4  DITHERING               | . . . . . .  | 6-2         |
| 6.5  STATUS............      |              | 6-3         |
Appendix A: Listing of Raster
| Operations  | . .  . .  . .  . . .  | . ..  A-1  |
| ----------- | --------------------- | ---------- |
iv

r-~  .
83 Vision968 Multimedia Accelerator
S3 Incorporated
List of Figures
| #  Title                      |     | Page  |
| ----------------------------- | --- | ----- |
| 3-1  RAMDAC PCI Read Timing.  |     | 3-3   |
| 3-2  RAMDAC PCI Write Timing  |     | 3-4   |
3-3  Fast Page Mode Read/Modify
| Write Timing  | .. . . . . . . . . .  | 3-5  |
| ------------- | --------------------- | ---- |
3-4  EDO Mode Read/Modify Write
Timing ............... 3-5
| 3-5  1 Cycle EDO Read/Write Timing.  |     | 3-6  |
| ------------------------------------ | --- | ---- |
3-6  1 Cycle EDO Read/Modify/Write
| Timing. . . . . . . . . . . . ..       |                       | 3-6  |
| -------------------------------------- | --------------------- | ---- |
| 4-1  Clock Waveform Timing             | . . ..                | 4-3  |
| 4-2  InputTiming. . . . . . . . . . .  |                       | 4-4  |
| 4-3  Output Timing                     | .......... 4-5        |      |
| 4-4  Reset Timing                      | . . . . . . . . . ..  | 4-7  |
| 4-5  First Order Output Buffer Model.  |                       | 4-8  |
| 5-1  Pixel Update Flowchart            | ..... 5-6             |      |
5-2  Polygon Example Drawing Steps 5-26
v

II·
S3 Vision968 Multimedia Accelerator
53 Incorporated
List of Tables
| #  Title                          |     | Page  |
| --------------------------------- | --- | ----- |
| 1-1  Video Resolutions Supported  |     | 1-2   |
2-1  Register Differences Between the
| Vision968 and Vision964 . .          |          | 2-1  |
| ------------------------------------ | -------- | ---- |
| 4-1  Absolute Maximum Ratings ..     |          | 4-1  |
| 4-2  DC Specifications               | .......  | 4-1  |
| 4-3  Clock Waveform Timing           | . . ..   | 4-3  |
| 4-4  SCLK-Referenced Input Timing    |          | 4-4  |
| 4-5  SCLK-Referenced Output Timing   |          | 4-5  |
| 4-6  MCLK-Referenced Input Timing .  |          | 4-6  |
| 4-7  MCLK-Referenced Output Timing   |          | 4-6  |
| 4-8  DCLK-Referenced Output Timing   |          | 4-6  |
4-9  Fast Page Mode Memory Input
Timing ............... 4-6
4-10  1 Cycle EDO Mode Memory Input
| Timing. . . . . . . . . . . . .     |     | 4-7  |
| ----------------------------------- | --- | ---- |
| 4-11  ResetTiming. . . . . . . . .  |     | 4-7  |
5-1  Enhanced Registers Memory
| Mapping. . . . . . . . . . . .    |          | 5-2  |
| --------------------------------- | -------- | ---- |
| 5-2  New MMIO Addresses           | . . . .  | 5-3  |
| 5-3  Big Endian Byte Swap Select  |          | 5-4  |
5-4  Polygon Fill Example Summary . 5-27
6-1  Video Engine InpuVOutput
Combinations. . . . . . . . . .. 6-1
vi

Vision968 Multimedia Accelerator
S3 Incorporated
Section 1: Introduction
1.1 OVERVIEW OF THIS DATA capability for sequential read or write data trans
fers at rates approaching twice that of convention
BOOKLET
fast page mode VRAMs.
This data booklet largely describes the areas in
which the S3® Vision968n, multimedia accelera 1.4 PACKED PIXEL ACCELERATION
tor (hereinafter referred to as the Vision968) is
different from the S3 Vision964™ (hereinafter re The Vision968 provides packed 24 bits/pixel (true
ferred to as the Vision964). color) acceleration. This means that each pixel in
24 bits/pixel modes now occupies 3 bytes of
The entire enhanced mode programming section memory instead of 4 for the Vision964. In addi
is included in this data booklet because it has tion, the graphics engine can process more pixels
been extensively revised from that in the in a given number of clock cycles than for the
Vision964 data book. Similarly, the entire electri Vision964.
cal data section is included. For information on
other common features between the Vision968
1.5 ENHANCED MEMORY-MAPPED
and Vision964, including most of the registers
and the graphics acceleration functionality, see I/O IMPLEMENTATION
the Vision964 Graphics Accelerator Data Book. In
particular, note that the pinout and pin descrip The Vision964 provides memory-mapped I/O
tions are the same for both chips. (MMIO) access to certain enhanced command
registers at fixed memory addresses. The
1.2 PRODUCT OVERVIEW Vision968 provides the following enhancements
to this scheme:
In general, the Vision968 provides all the features • The base address for MMIO is now the
found in the Vision964. The exception is that same as for linear addressing and is relo
backward compatibility support for CGA, MDA catable for plug and play support
and HGC is no longer provided in hardware.
• The new MMIO is enabled at power-on
reset for PCI systems, allowing the PCI
The Vision968 provides a number of enhanced
subsystem to configure the Vision968
capabilities notfound in the Vision964. These are
without accessing the VGA registers
summarized below and are described in detail in
through the I/O space
subsequent sections.
• All registers are now memory mapped
1.3 ENHANCED VRAM SUPPORT • Related 16-bit Enhanced command regis
ters are packed into 32-bit registers to re
duce the number of CPU cycles required
The Vision968 supports single cycle EDO opera
to access them
tion at speeds up to 50 MHz. This provide the
INTRODUCTION 1-1

••
r
Vision968 Multimedia Accelerator
S3 Incorporated
•  There are two apertures into the MMIO  1.9  RESOLUTIONS SUPPORTED
address sRace. One provides little en
dian (lntel©-style) access and the other
Supported resolutions are shown in the follow
provides big endian (Motorola©/
ing table. Extended VGA text modes up to 132
PowerPCTM-style) access
columns by 43 rows are possible as well.
1.6  NEW DRAWING COMMANDS  Table 1-1.  Video Resolutions Supported
VRAM (MBytes)
The following drawing commands have been
| added to those available with the Vision964:  |             | 1  2      | 8         |
| --------------------------------------------- | ----------- | --------- | --------- |
|                                               | Resolution  |           | 4         |
|                                               | 640x480x4   | II'  II'  | II'  II'  |
•  polyline/2-point line
|     | 640x480x8  | II'  II'  | II'  II'  |
| --- | ---------- | --------- | --------- |
•  polygon with solid or patterned fills  640x480x16  II'  II'  II'  II'
•  trapezoid with solid or patterned fills
|     | 640x4BOx24  | II'  II'  | II'  II'  |
| --- | ----------- | --------- | --------- |
(Bresenham parameters in hardware)
|     | 640x4BOx32  | II'  | II'  II'  |
| --- | ----------- | ---- | --------- |
•  trapezoid with solid or patterned fills
|     | 800x600x4  | II'  II'  | II'  II'  |
| --- | ---------- | --------- | --------- |
(Bresenham parameters specified by pro
| grammer)  | 800x600x8   | II'  II'  | II'  II'  |
| --------- | ----------- | --------- | --------- |
|           | 800x600x16  | II'  II'  | II'  II'  |
•  ROPBlT  -Support is provided for the
full set of 256 triadic raster operations  800x600x24/32  II'  II'  II'
for BitBlT s (as defined by Microsott©)
|                                | 1024x76Bx4      | II'  II'  | II'  II'  |
| ------------------------------ | --------------- | --------- | --------- |
|                                | 1024x768xB      | II'  II'  | II'  II'  |
| 1.7  PCI SUPPORT ENHANCEMENTS  | 1024x768x16     | II'       | II'  II'  |
|                                | 1024x768x24/32  |           | II'  II'  |
The following have been added to improve op  1152xB64x8  II'  4  II'  II'
eration in PCI systems:
|     | 12BOx1024x4  | II'  II'  | II'  II'  |
| --- | ------------ | --------- | --------- |
•  New registers for interrupt handling  12BOx1024xB  II'  II'  II'
|     | 12BOx1024x16  |     | II'  II'  |
| --- | ------------- | --- | --------- |
•  Complete RAMDAC snooping capability
|     | 1280x1024x24  |     | II'  II'  |
| --- | ------------- | --- | --------- |
•  PCI disconnect based on the command
| FIFO status  | 1280x1024x32  |           | II'       |
| ------------ | ------------- | --------- | --------- |
|              | 1600x1200x4   | II'  II'  | II'  II'  |
|              | 1600x1200xB   | II'       | II'  II'  |
1.8  VIDEO ENGINE
|     | 1600x1200x16  |     | II'  II'  |
| --- | ------------- | --- | --------- |
The Video Engine integrated into the Vision968  1600x 1200x24/32  II'
can convert a YUV data stream to an RGB data
stream. The output of the color space converter
is then sentthrough the scaling engine for scaling
up or down. Additionally, a dithering engine con
verts 24 bits/pixel images to a 16-or 8-bit format
(and 16-bit images to an 8-bit format) with little
quality impact. To support image compression,
the Video Engine can scale images down to the
size required to meet disk drive bandwidth re
quirements.
1-2  INTRODUCTION

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Section 2: Register Changes
2.1  Vision968 REGISTER CHANGES
Most Vision968 registers operate exactly as their Vision964 counterparts. The exceptions are shown
in Table 2-1. New Vision968 registers are described in Sections 3.2 through 3.6.
Table 2-1.  Register Differences Between the Vision968 and Vision964
| Vision964 Register  | Bit(s)  | Vision968 Description  |     |
| ------------------- | ------- | ---------------------- | --- |
CR30  7-0  This is hardwired to E1 H. Programmers must use CR2E to identify
the chip.
| CR32  | 3-2  | Reserved  |     |
| ----- | ---- | --------- | --- |
=
| CR36  | 3-2  | 00  One cycle EDO VRAM (new)  |     |
| ----- | ---- | ----------------------------- | --- |
=
|     |     | 01  Reserved  |     |
| --- | --- | ------------- | --- |
=
|     |     | 10  EDO VRAM  |     |
| --- | --- | ------------- | --- |
=
|     |     | 11  Fast page mode VRAM  |     |
| --- | --- | ------------------------ | --- |
o =
| CR40  | 3   | Normal SRDY operation  |     |
| ----- | --- | ---------------------- | --- |
=
|       |      | 1  SRDY delayed by one cycle (VL-Bus only)  |             |
| ----- | ---- | ------------------------------------------- | ----------- |
| CR50  | 1    | o =  DACRD, DACWR active pulse              | =  2 SCLKs  |
|       |      | =                                           | =           |
|       |      | 1  DACRD, DACWR active pulse                | 4 SCLKs     |
| CR50  | 5-4  | 00  =  4/8 bits/pixel                       |             |
|       |      | 01  =  16 bits/pixel                        |             |
|       |      | 10  =  24 bits/pixel (new)                  |             |
=
|       |     | 11  32 bits/pixel                             |     |
| ----- | --- | --------------------------------------------- | --- |
| CR53  | 0   | Reserved (write per bit no longer supported)  |     |
CR53  The power-on default depends on the system bus type. See the
descri[Jtion for bits 4-3 below
CR53  2-1  Big endian data byte swap (linear addressing and Video Engine
transfers only)
=
|     |     | 00  No swap                                           |     |
| --- | --- | ----------------------------------------------------- | --- |
|     |     | 01  =  Swap bytes within each word                    |     |
|     |     | 10  =  Swap all bytes in doubleword (bytes reversed)  |     |
|     |     | 11  =  Reserved                                       |     |
REGISTER CHANGES  2-1

53 Vision968 Multimedia Accelerator
S3 Incorporated
Table 2·1. Register Differences Between the Vision964 and Vision968 (Continued)
Vision964 Register Bit(s) Vision968 Description
CR53 4-3 MMIO select
=
00 MMIO disabled
=
01 MMIO disabled
=
10 Vision964-type MMIO (AOOOOH window)
=
11 New MMIO (relocatable/packed) and Vision964-type MMIO
=
VL-Bus power-on default 00
=
PCI bus power-on default 11
CR53 7 Enable upper byte write protection in 32 bits/pixel mode
o = CAS3 and CAS7 enabled during 32 bits/pixel memory writes
=
1 CAS3 and CAS7 disabled during 32/bits/pixel memory writes
CR54 1-0 Big endian data byte swap (not linear addressing off, not image
writes and not Video Engine Access)
=
00 No swap
=
01 Swap bytes within each word
=
10 Swap all bytes in doubleword (bytes reversed)
=
11 Swap according to BE[3:0] (VL-Bus ) or C/BE(3:0] (PCI bus)
BE[3:0VC/BE[3:0]
=
0000 Swap all bytes in doubleword (bytes reversed)
=
0011 Swap bytes within selected word
=
1100 Swap bytes within selected word
=
All other values No swap
CR54 2 This is the high order extension bit (bit 5) for the M parameter (bits 7-
3 of this register). This doubles the amount of memory bandwidth
that can be allocated for Graphics Enqine/CPU access.
CR58 The power-on default depends on the system bus type. See the
description for bit 4 below. -
=
CR58 4 VL-Bus power-on default 0
=
PCI bus power-on default 1
CR59, CR5A 15-0 VL-Bus power-on default = OOOAH
=
PCI bus power-on default 7000H
CR61 6-5 Big endian data byte swap (image writes)
=
00 No swap
=
01 Swap bytes within each word
=
10 Swap all bytes in doubleword (bytes reversed)
=
11 Reserved
CR66 3 PCI disconnect enable (PCI bus only)
0= No effect
=
1 An attempt to write data with the Command FIFO full or to read
data with the Command FIFO not empty generates a PCI bus
disconnect cycle
Bit 7 of CR66 must also be set to 1 for this feature to operate
properly. Note that the previous function of this bit (set SCO to
VCLK) is no lonqer available.
Enhanced Registers
82E8H 11-0 For polygons or trapezoids, this is the starting pixel vertical position
for the first of two edges to be drawn.
2-2 REGISTER CHANGES

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Table 2-1. Register Differences Between the Vision964 and Vision968 (Continued)
Vision964 Register Bit(s) Vision968 Description
86E8H 11-0 For polygons or trapezoids, this is the starting pixel horizontal
position for the first of two edges to be drawn.
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
for the first of two edges to be drawn.
9AE8H 10-9 Select image write (E2E8H, E2EAH) bus transfer width
=
00 8 bits
=
01 16 bits
=
10 32 bits. All doubleword bits beyond the image rectangle width
are discarded. Each line starts with a fresh doubleword. The
current drawing position ends up one pixel below the lower
left hand corner of the image rectangle
=
11 32 bits. This setting applies only to image transfers across the
plane. Only padding bits up to the start of the next byte are
discarded. The current drawing position ends up one pixel to the
right of the top right corner of the rightmost image rectangle.
9AE8H 11, Drawing Command
15-13 0000 = NOP
=
0001 Draw line
=
0010 Rectangle fill
=
0011 Polygon fill solid (new)
=
0100 4-point trapezoid fill solid (new)
=
0101 Bresenham parameter trapezoid fill solid (new)
=
0110 BitBLT
=
0111 Pattern BLT
=
1001 Polyline/2-point line (new)
=
1011 Polygon fill pattern (new)
=
1100 4-point trapezoid fill pattern (new)
=
1101 Bresenham parameter trapezoid fill pattern (new)
=
1110 ROPBLT (new)
See the Enhanced Mode Programming section for a description of
each of these commands.
AEE8H 31-0 Read mask for the ROPBLT pattern (same as previous Read Mask)
BEE8H, Index E 6 Reserved
REGISTER CHANGES 2-3

••
r
53 Vision968 Multimedia Accelerator
S3 Incorporated
Table 2-1. Register Differences Between the Vision964 and Vision968 (Continued)
Vision964 Register Bit(s) Vision968 Description
BEE8H, Index E 10 o = Allow 1 cycle EDO write operation
1 = Disable 1 cycle EDO write operation
PCI Registers
PCI Index 02H 15-0 The device ID is hardwired to 88FOH.
PCI Index 04H 7 Hardwired to 1 to indicate that the device always does address/data
stepping.
PCI Index OAH 7-0 Now included in new Class Code register.
2-4 REGISTER CHANGES

••
r
S3 Vision968 Multimedia Accelerator
S3 Incorporated
2.2 NEW Vision968 SR REGISTERS
The SR registers described in this section have been added for the Vision968 and are not found in the
Vision964.
Extended Sequencer Register 9 (SR9)
Read/Write Address: 3C5H, Index 09H
Power-On Default: OOH
6
1 : 1 : 1 : 1 : 1 1 : 1
R R
Bits 6-0 Reserved
Bit 7 MMIO-ONLY -Memory-mapped I/O register access only
o
= If MMIO is enabled, both programmed I/O and memory-mapped I/O register
accesses are allowed
1 = If MMIO is enabled, only memory-mapped I/O register accesses are allowed
External Bus Request Control Register (SRA)
Read/Write Address: 3C5H, Index OAH
Power-On Default: OOH
UL.I
:1:1:1:1:1 :1: 1
Bits 6-0 Reserved
Bit 7 2MCLK -2 MCLK CPU writes to memory (linear addressing)
o
= 3 MCLK memory writes
1 = 2 MCLK memory writes
REGISTER CHANGES 2-5

S3 Vision968 Multimedia Accelerator
S3 Incorporated
2.3  NEW Vision968 CR REGISTERS
The CR registers described in this section have been added for the Vision968 and are not found in the
Vision964.
Device ID High Register (CR2D)
| Read Only  |     | Address: 375H, Index 20H  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: 88H
This register should contain the same value as the upper byte of the PCI Vendor 10 (Index OOH) register.
o
| 7  6  | 5  4  | 3  2  |     |
| ----- | ----- | ----- | --- |
CHIP 10 HIGH
| Bits 7-0  | CHIP 10 HIGH  |     |     |
| --------- | ------------- | --- | --- |
Device ID Low Register (CR2E)
| Read Only  |     | Address: 3?5H, Index 2EH  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: FOH
This register allows software to identify whether a Vision968 is present.
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
CHIPID LOW
| Bits 7-0  | CHIP ID LOW  |     |     |
| --------- | ------------ | --- | --- |
FOH for Vision968
Revision Register (CR2F)
| Read Only  |     | Address: 3?5H, Index 2FH  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6  | 543  | 2   |     |
| ----- | ---- | --- | --- |
REVISION LEVEL
| Bits 7-0  | REVISION LEVEL  |     |     |
| --------- | --------------- | --- | --- |
2-6  REGISTER CHANGES

••
r
S3 Vision968 Multimedia Accelerator
S3 Incorporated
2.4 NEW Vision968 ENHANCED COMMANDS REGISTERS
The Enhanced Commands registers described in this section have been added for the Vision968 and
are not found in the Vision964.
Current V -Position 2 Register (CUR_ V2)
ReadNVrite Address: 82EAH
Power-On Default: Undefined
For polygons or trapezoids, this is the starting pixel vertical position for the second of two edges to be
drawn. Reading this register produces the current vertical drawing coordinate for the second edge
being drawn.
Bits 11-0 CURRENT V-POSITION 2
Bits 15-12 Reserved
Current X-Position 2 Register (CUR_X2)
ReadNVrite Address: 86EAH
Power-On Default: Undefined
For polygons or trapezoids, this is the starting pixel horizontal position for the second of two edges to
be drawn. Reading this register produces the current horizontal drawing coordinate for the second
edge being drawn.
Bits 11-0 CURRENT X-POSITION 2
Bits 15-12 Reserved
REGISTER CHANGES 2-7

53 Vision968 Multimedia Accelerator
S3 Incorporated
V-Coordinate 2/Axial Step Constant 2 Register (V2_AXSTP2)
Read/Write Address: 8AEAH
Power-On Default: Undefined
For polygons and 4-point trapezoids, this is the ending vertical position for the second of two edges
to be drawn. For Bresenham parameter trapezoids, this is the axial step constant forthe second oftwo
edges to be drawn.
Bits 11-0 V-COORDINATE 2
Bits 15-12 Reserved
Axial Step Constant = 2 * (minqdxl,ldyll) In other words, when drawing a line from point A to point B,
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

S3 Vision968 Multimedia Accelerator
S3 Incorporated
line Error Term 2 Register (ERR_TERM2)
Read/Write Address: 92EAH
Power-On Default: Undefined
For Bresenham parameter trapezoids, this is the error term for the second of two edges to be drawn.
Error Term = 2 * min{jdxl,ldYIl -max{jdxl,ldyl- 1 if the starting X < the ending X
Error Term = 2 * min{jdxl,ldYIl -max{jdxl,ldYI if the starting X;:: the ending X
See the Destination V-Position/Axial Step Constant (8AE8H) register for an explanation of the terms
used in these equations.
Bits 13-0 ERROR TERM 2
Bits 15-14 Reserved
Major Axis Pixel Count 2 Register (MAJ_AXIS_PCNT2)
Read/Write Address: 96EAH
Power-On Default: Undefined
This register specifies the length (in pixels) of the major (longest) axis for solid and textured lines and
the width for rectangles, image transfers, BitBlT s and PatBlT s. For Bresenham parameter trapezoids,
this is the major axis length for the first of two edges to be drawn.
Bits 11-0 RECTANGLE WIDTH 2/LiNE PARAMETER MAX 2
The value is the number of pixels along the major axis -1.
Bits 15-12 Reserved
REGISTER CHANGES 2-9

53 Vision968 Multimedia Accelerator
53 Incorporated
Drawing Command 2 Register (CMD2)
| Write Only  | Address: 9AEAH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
For Bresenham parameter trapezoid fills, this register defines the drawing direction for the second
edg~ to be drawn. The drawing direction for the first edge is specified in bits 7-5 of 9AE8H
I  I
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
DRWG-DIR 2.
| R  R  R                                           | R  R  R  | R  R  2  | 1  0  R  | R  R  R  | R   |
| ------------------------------------------------- | -------- | -------- | -------- | -------- | --- |
| Bits 4-0  Reserved                                |          |          |          |          |     |
| Bits 7-5  DRWG-DIR 2 -Select Drawing Direction 2  |          |          |          |          |     |
In the following table, the line is drawn from left to right or a +X and from right to left
for a -X, down for a +Y and up for a -Yo X or Y maj specifies the longest axis. Axial
drawing is specified in bit 3 of 9AE8H.
|     | 7-5  | x-y (Axial -bit 3 = 0)  |     |     |     |
| --- | ---- | ----------------------- | --- | --- | --- |
000
-Y,Xmaj,-X
|     | 001  | -Y,Xmaj,+X   |     |     |     |
| --- | ---- | ------------ | --- | --- | --- |
|     | 010  | -Y,Y maj,-X  |     |     |     |
011
-Y,Ymaj,+X
|     | 100  | +Y,Xmaj,-X  |     |     |     |
| --- | ---- | ----------- | --- | --- | --- |
|     | 101  | +Y,Xmaj,+X  |     |     |     |
|     | 110  | +Y,Ymaj,-X  |     |     |     |
|     | 111  | +Y,Ymaj,+X  |     |     |     |
Reserved
Bits 15-8
2-10  REGISTER CHANGES

53 Vision968 Multimedia Accelerator
S3 Incorporated
ROP Mix Selection Register (ROPMIXI
Read/Write Address: D2E8H
Power-On Default: Undefined
Bits 7-0 ROP MIX SELECTION
See Appendix A for a listing of the 256 mix selections available.
Bit 8 °MP -Mono pattern select
= ROPBL T pattern is color
1 = ROPBL T pattern is monochrome
If a monochrome pattern is selected, the background and foreground colors are speci
fied in E6E8H and EEE8H respectively.
Bits 15-9 Reserved
ROPBLT Pattern Background Color Register (PAT_BG_COLORI
Read/Write Address: E6E8H
Power-On Default: Undefined
This register defines the background color for the ROPBL T pattern when bit 8 of D2E8H is set to 1 to
specify a monochrome pattern.
151 14 j 13 1 12 1 11 1 10 1 9 1 8 1 7 1 6 l 5 1 4 I 3 I 2 I 1 I 0
BACKGROUND COLOR
I J J l 'I
31 1 30 1 29 1 28 1 27 26 25 24 23 1 22 21 1 20 1 19 1 18 1 17 1 16
BACKGROUND COLOR
Bits 31-0 BACKGROUND COLOR
If bit 9 of BEE8_EH is set to 1 or if MMIO is enabled, this becomes a 32-bit register. If
bit 9 of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode with 16-
bit registers, the upper and lower doublewords are read or written sequentially, de
pending on the state of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the lower
16 bits are accessed. If RSF = 1. the upper 16 bits are accessed. The RSF flag toggles
automatically when a doubleword is read or written.
REGISTER CHANGES 2-11

r-~ .
S3 Vision968 Multimedia Accelerator
53 Incorporatad
Read/Write Address: EAE8H
Power-On Default: Undefined
This register defines the vertical coordinate top edge of an 8x8 pixel pattern programmed into
off-screen memory. This is used with the Bresenham parameter trapezoidal fill pattern, trapezoidal
4-point trapezoid fill pattern, polygon fill pattern and ROPBL T command types.
Bits 11-0 PATTERN Y
Bits 15-12 Reserved
Read/Write Address: EAEAH
Power-On Default: Undefined
This register defines the horizontal coordinate of the left side of an 8x8 pixel pattern programmed into
off-screen memory. This is used with the Bresenham parameter trapezoidal fill pattern, trapezoidal
4-point trapezoid fill pattern, polygon fill pattern and ROPBL T command types.
Bits 11-0 PATTERN X
Bits 15-12 Reserved
2-12 REGISTER CHANGES

fl·
S3 Vision968 Multimedia Accelerator
S3 Incorporated
ROPBL T Pattern Foreground Color Register (PAT _FG_COLORI
| Read/Write  | Address: EEE8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
This register defines the foreground color for the ROPBLT pattern when bit 8 of D2E8H is set to 1 to
specify a monochrome pattern.
| I  I        | I  I  I     | I  I  I  | I  I  I  | I  I  I  | I   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
FOREGROUND COLOR
| I  I  | I  I  I  | I  I  I  | I  I  I  | I  I  I  | I   |
| ----- | -------- | -------- | -------- | -------- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
FOREGROUND COLOR
| Bits 31-0  FOREGROUND COLOR  |     |     |     |     |     |
| ---------------------------- | --- | --- | --- | --- | --- |
If bit 9 of BEE8_EH is set to 1 or if MMIO is enabled, this becomes a 32-bit register. If
bit 9 of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode with 16-
bit registers, the upper and lower doublewords are read or written sequentially, de
pending on the state of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the lower
16 bits are accessed. If RSF = 1, the upper 16 bits are accessed. The RSF flag toggles
automatically when a doubleword is read or written.
|     |     |     |     | REGISTER CHANGES  | 2-13  |
| --- | --- | --- | --- | ----------------- | ----- |

...
r
S3 Vision968 Multimedia Accelerator
S3 Incorporated
2.5  NEW Vision968 PCI CONFIGURATION SPACE REGISTERS
The PCI Configuration Space registers described in this section have been added for the Vision968 and
are not found in the Vision964.
Class Code
| Read Only  |     | Address: 08H  |     |     |     |
| ---------- | --- | ------------- | --- | --- | --- |
Power-On Default: 30000H
The class code is contained in bits 31-8. These 3 bytes are hardwired to 30000H to specify that the
Vision968 is a VGA-compatible display controller. Bits 7-0 contain the Revision ID, and are present in
the Vision964.
|     |     | I  I  | I  I  I  | I  I  I  | I   |
| --- | --- | ----- | -------- | -------- | --- |
15  I  14  I  13  I  12  I  11  I  10  9  8  7  6  5  4  3  2  1  0
PROGRAMMING INTERFACE
I
31  I 30  I 29  I 28  I 27  I 26  I 25  I 24  23  I 22  I 21  I 20  I  19  I  18  I  17  16
|     | BASE CLASS CODE  |     | SUB-CLASS  |     |     |
| --- | ---------------- | --- | ---------- | --- | --- |
Interrupt Line
| Read/Write  |     | Address: 3CH  |     |     |     |
| ----------- | --- | ------------- | --- | --- | --- |
Power-On Default: OOH
This register contains interrupt line routing information written by the POST program during power-on
initialization.
o
| 7  6  | 5  4  | 3  2  | 1   |     |     |
| ----- | ----- | ----- | --- | --- | --- |
INTERRUPT LINE
| Bits 7-{)  | INTERRUPT LINE  |     |     |     |     |
| ---------- | --------------- | --- | --- | --- | --- |
Interrupt Pin
| Read Only  |     | Address: 3DH  |     |     |     |
| ---------- | --- | ------------- | --- | --- | --- |
Power-On Default: 01H
This register is hardwired to a value of 1 to specify that INTA is the interrupt pin used.
o
| 7  6  | 5  4  | 3  2  | 1   |     |     |
| ----- | ----- | ----- | --- | --- | --- |
INTERRUPT PIN
| Bits 7-0  | INTERRUPT PIN  |     |     |     |     |
| --------- | -------------- | --- | --- | --- | --- |
2-14  REGISTER CHANGES

S3 Vision968 Multimedia Accelerator
S3 Incorporated'
2.6  NEW Vision968 VIDEO ENGINE REGISTERS
The Video Engine registers described in this section have been added for the Vision968. They are not
found in the Vision964.
Video Engine NOP Register
| Read/Write  | Address: 8080H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: 0000 OOOOH
Software must make a dummy write to this register when it is finished sending Video Engine
commands. Graphics Engine commands can then follow. This NOP prevents simultaneous Video
Engine and Graphics Engine operation.
| I  I        | I  I  I     | I  I  I  | I  I  I  | I  I  I  | I     |
| ----------- | ----------- | -------- | -------- | -------- | ----- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2     | 1  0  |
NOP
| I  I  | I  I  I  | I  I  I  | I  I  I  | I   | 1   |
| ----- | -------- | -------- | -------- | --- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  191181  17  16
NOP
| Bits 31-0  NOP -No operation  |     |     |     |     |     |
| ----------------------------- | --- | --- | --- | --- | --- |
Video Engine Control Register
| Read/Write  | Address: 8088H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: 0000 OOOOH
31  30  29  28  27  26  25124123  22  I  21  I  20  19  18  I  17  I  16
|     |     |     | INPUT DATA  | OUTPUT DATA  |     |
| --- | --- | --- | ----------- | ------------ | --- |
on
| FILT  CSC  DITH                           | R  KM  | DM INDEX  | FORMAT  | CS  FORMAT  |     |
| ----------------------------------------- | ------ | --------- | ------- | ----------- | --- |
| Bits 11-0  DDA ACCUMULATOR INITIAL VALUE  |        |           |         |             |     |
Digital Differential Analyzer accumulator initial value = -MAX(Ws, Wd), where Ws is
the width in pixels ofthe source and Wd is the width in pixels of the destination.
| Bits 15-12  Reserved  |     |     |     |                   |       |
| --------------------- | --- | --- | --- | ----------------- | ----- |
|                       |     |     |     | REGISTER CHANGES  | 2-15  |

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Bits 18-16 OUTPUT DATA FORMAT
000 = 8 bits/pixel, RGB, 3.3.2 -can be translated with output table
001 = Reserved
010 = Reserved
011 = 32 bits/pixel, RGB, x.8.8.8
100 = 16 bits/pixel, YCbCr, 4:2:2
101 = 16 bits/pixel, raw
110 = 15 bits/pixel RGB, 5.5.5
111 = 16 bits/pixel RGB, 5.6.5
Bit 19 CS -Color Space
0= YCbCr, 16-240 range
1 =YUV
Bits 22-20 INPUT DATA FORMAT
000 = 8 bits/pixel, RGB, 3.3.2 -can be translated with output table
001 = Reserved
010 = Reserved
011 = 32 bits/pixel, RGB, x.B.8.8
100 = 16 bits/pixel, YCbCr, 4:2:2
101 = 16 bits/pixel, raw (scaling only)
110 = 15 bits/pixel RGB, 5.5.5
111 = 16 bits/pixel RGB, 5.6.5
Bits 25-23 DM INDEX -Dithering Matrix Index
a
This is auto-incremented at the end of each line. It should be initialized to at the be
ginning of each new frame or block of lines.
Bit 26 KM -Key Mask Enable
a
= Disable -bypass function
1 = Enable
Bit 27 Reserved
Bit 28 OTT -Output Table Translation Enable
a
= Disable -bypass function
1 = Enable
Bit 29 DITH -Dithering
a = Disable -bypass function
1 = Enable
Bit 30 CSC -Color Space Converter
a = Disable -bypass function
1 = Enable
Bit 31 FILT -Filter
a
= Disable -bypass function
1 = Enable
2-16 REGISTER CHANGES

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Video Engine Stretch/Filter Constants Register
Read/Write Address: 808CH
Power-On Default: 0000 OOOOH
Bits 10-0 K2
If Ws?Wd, then K2 = Wd-Ws; If Ws<Wd, then K2 = Ws-Wd
Ws is the width in pixels of the source and Wd is the width in pixels of the destination.
Bits 13-11 Reserved
Bits 15-14 FILTER -Filter characteristics
00 = Bi-linear (default)
01 = Linear, 0-2-4-2-0
10 = Linear, 1-2-2-2-1
11 = Reserved
Bits 26-16 K1
If Ws"cWd, then K1 = Wd; If WsWd, then K1 = Ws
Ws is the width in pixels of the source and Wd is the width in pixels of the destination.
Bits 28-27 Reserved
Bit 29 SEN -Sense
0= Normal. Logic 1 in key mask enables video, logic 0 in key mask enables graphics
1 = Reverse. Logic 0 in key mask enables video, logic 1 in key mask enables graphics
Bit 30 HD -Host data
o
= Data from screen
1 = Data from host
Bit 31 SS -Shrink/Stretch, Scale Down/Up
o
= Stretch/Scale Up
1 = Shrink/Scale Down
REGISTER CHANGES 2-17

S3 Vision968 Multimedia Accelerator
53 Incorporated
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

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Video Engine Crop Register
ReadlWrite Address: B094H
Power-On Default: 0000 OOOOH
13 12 11 10 9 8 7 6 5 4 3 2 1
R R LENGTH
Bits 11-0 LENGTH
Value = Actual number of pixels to process
Bits 15-13 Reserved
Bits 27-16 START
Value = Number of pixels to not be written after starting
Bits 15-13 Reserved
Video Engine Source Base Address Register
ReadlWrite Address: 809BH
Power-On Default: 0000 OOOOH
Bits 23-0 SOURCE BASE ADDRESS
Source base address (in bytes) in display memory for the image to be processed by
the Video Engine. The source address is in display memory only for the second pass
of a 2-pass operation. Otherwise, the source is system memory with the data pro
vided by the Host. In this case, only bits 1-0 of this register are relevant. The decimal
value of bits 1-0 is the number of bytes to discard from the start of each pixel line
stream from the Host. This allows adjustment for non-doubleword-aligned pixel data
in system memory.
REGISTER CHANGES 2-19

S3 Vision968 Multimedia Accelerator
S3 Incorporatad
Bits 31-24 Reserved
Video Engine Destination Base Address Register
Read/Write Address: 809CH
Power-On Default: 0000 OOOOH
Bits 23-0 DESTINATION BASE ADDRESS [23:0]
Destination base address (in bytes) in display memory for the image to be processed
by the Video Engine.
Bits 30-24 Reserved
Bit 31 VEB -Video Engine busy (Read Only)
o = Video Engine not busy
1 = Video Engine busy
2.7 Vision964 REGISTERS REMOVED FROM THE Vision968
All backward compatibility registers found in the Vision964 are removed from the Vision968. These
include all registers described in Sections 12 and 13 ofthe Vision964 Graphics Accelerator Data Book.
2-20 REGISTER CHANGES

S3 Vision968 Multimedia Accelerator
53 Incorporated
Section 3: Functional Changes
This section describes a number of enhance 3.3.1 Interrupt Support
ments provided by the Vision968 as compared
with the Vision964. The new features related to
PCI configuration space registers Index 3CH (In
Enhanced mode programming support are de
terrupt Line) and Index 3DH (Interrupt Pin) are
scribed in Section 4. The new Video Engine capa
added to support handling of interrupts.
bility for the Vision968 is described in Section 5.
When in PCI mode, the INTA pin floats. Interrupt
3.1 CHIP IDENTIFICATION generation drives it active low. When the inter
rupt is removed, the INTA pin again floats.
Three new chip identification registers are pro
When in VL-Bus mode, the SINTR pin is driven
vided. CR2D is hardwired with 88H. This is the
high. Interrupt generation drives it low and then
upper word of the device I.D .. CR2E is hardwired
releases it to be driven high again (edge trig
with BOH for the Vision968. This is the low byte
gered).
of the device I.D .. CR2F contains the revision
level. CR30, the old I.D. register, contains E1H.
3.3.2 RAMDAC Snooping
3.2 SHARED FRAME BUFFER
MEMORY BANDWIDTH For PCI bus configurations, setting bit 5 of the
Command configuration space register (Index
ALLOCATION
04H) to 1 causes the Vision968 to snoop for
RAMDAC writes. This means that the Vision968
The Vision968 provide the same bus request/bus will write the data to the local RAMDAC but will
grant shared frame buffer capability as the not claim the cycle by asserting DEVSEL. This
Vision964. allows the ISA controller to also generate a write
cycle to a secondary RAMDAC. The Vision968
For the Vision968, the M parameter field is 6 bits always provide the data for RAMDAC reads.
instead of 5 bitsforthe Vision964. The M parame
ter is used only for VGA modes. If snooping is enabled, the 3C8 and 3C9 DAC
registers cannot be written with a single word
write. They must be written separately with byte
3.3 PCI ENHANCEMENTS
writes.
The Vision968 contain several enhancements for If bit 5 of the PCI Command register is cleared to
PCI bus operation. 0, the Vision968 claims all RAMDAC read and
write cycles.
FUNCTIONAL CHANGES 3-1

r-~ .
S3 Vision968 Multimedia Accelerator
53 Incorporated
3.3.3 Disconnect Related to FIFO 3.5 RAMDAC ACCESS CYCLES
Status
The RAMDAC strobes DACRD and DACWR are
If bits 3 and 7 of CR66 are setto 1, pixel data writes based on MCLK for the Vision964. They are based
made with the command FIFO full or memory on SCLK for the Vision968. The PCI bus RAMDAC
reads made with the Command FIFO not empty access functional timing for the Vision968 is
will generate a PCI disconnect. shown in Figures 3-1 and 3-2. VL-Bus cycles have
the same timing characteristics.
3.3.4 Plug and Play Support The active pulse of DACRD or DACWR is 2 SCLKs
if bit 1 of CR50 is cleared to 0 and 4 SCLKs if this
When the Vision968 powers up in PCI mode, it bit is set to 1. The latter setting is required for 50
defaults to linear addressing and memory MHz VL-Bus operation to ensure a pulse width
mapped I/O enabled at a relocatable base ad greater than 50 ns. Selecting a 4 SCLK active
dress of 7000 OOOOH. This allows the PCI system pulse width extends the total cycle by 10 SCLKs.
to reconfigure as required for plug and play.
3.6 50 MHz VL-BUS SUPPORT
3.4 PACKED 24-BITS/PIXEL
SUPPORT Setting bit 3 of CR40 to 1 adds a wait state to
VL-Bus cycles by delaying SRDV by one clock.
This is required for 50 MHz VL-Bus operation. In
In 32 bits/pixel modes, the Graphics Engine can
addition, bit 1 of CR50 must be set to 1 to extend
process two pixels simultaneously (64 bits). The
the RAMDAC read and write strobe pulses.
Vision968 also provides accelerated packed 24
bits/pixel operation. This means that 22/3 pixels
can be processed simultaneously, resulting in an 3.7 WRITE PER BIT SUPPORT
approximately 25% performance improvement.
Packed 24 bits/pixel operation is selected by set
The Vision968 does not support write per bit and
ting bits 5-4 of CR50 to 10b.
bit 0 of CR53 is now reserved.
Most ofthe hardware acceleration features avail
able for 32 bits/pixel operation are also available
for packed 24 bits/pixel operation. Those func
tions for which hardware acceleration is not pro
vided for packed 24 bits/pixel operation are:
• Textured line draw
• BitBLT across the plane
• Color comparison
• Video Engine operation
Image transfers (CPU as data source) can be
performed in packed 24 bits/pixel mode.
When using packed 24 bits/pixel operation, all
drawing coordinates (e.g., current X,V or destina
tion X,V) must be positive numbers.
3-2 FUNCTIONAL CHANGES

, \
..
~
T2 T3 T4 T5 T6 T7 T8 T9 T10 T11 T12 T13 T14 T15
SClK
!! FRAME-U
cc
r::::
;. .. AD[31:0] ~C (DAC DATA )1-------
»::Il IROY \ I
s:
c
L-J
~ TRDY
~ en
\ I w
::Il DEVSEl 9 F <
CII
D> iii'
D. 2~~KS
-I 0'
3' DACRD ::s
:j' CD
cc 0)
RS[2:0] ~~---- ---- ~ OQ
S
"T1
C c
Z ;:;
~ GD[7:0].DACDATA ~ 3'
o
z C c D . .
»
iii'
r
»
()
: » r: n
z n
CD
G) i...f
m
(f) CI)
w .or.+.
W

I'll
tAl
.J,.
-n
C
Z
~
o &
z
»
r
»I ( ) T2 T3 T4 T5 T6 T7 T8 T9 T10 T11 T12 T13 T14 T15
Z SCLK
G)
m
(J)
c"eTI' FRAME-U
c
~AD[31:01 ~. DACDATA FROM CPU
~
\ I
~ 'RDY
~
o
»C
TRDY ~
-g
Q.:E. - \ 9 F I Cw/)
DEVSEL
<
~ 2~~~KS i o ii · '
=! DACWR
3 ::::I
5' e C n D
CQ RS[2:01 ~ ~ co
S
I:
GD[7:01~ DACDATA ~ 3 ~
VBOACWR cCD..
S;"
»
n
n
..
CD
CD
.II.I
or+

53 Vision968 Multimedia Accelerator
S3 Incorporated
3.8  READ/MODIFY /WRITE TIMING  For fast page mode operation, read data is
latched by the rising edge of CAS. For2 cycle EDO
The read/modify/write cycles for fast page and  operation, the read data is latched by the rising
edge of MCLK following a CAS rising edge.
EDO memories have been modified from the
Vision964. These are shown in Figures 3-3 and
Note that both Figure 3-3 and 3-4 are based on a
3-4.
RAS precharge of 2.5 MCLKs.
|     | T1  T2  | T3  | T4  | T5  | T6  T7  | T8  T9  | T10  |     |
| --- | ------- | --- | --- | --- | ------- | ------- | ---- | --- |
MCLK
______________
|     |     | \~  |     |     |     | ~r-- |     |     |
| --- | --- | --- | --- | --- | --- | ---- | --- | --- |
|     |     |     |     |     | LJ  | L    | l   |     |
CAS
|                 | rAA'--__ |         |     |         |         |         |     |     |
| --------------- | -------- | ------- | --- | ------- | ------- | ------- | --- | --- |
|                 |          |         | -   | -'X     | YIJ...  |         |     |     |
| M A [ 8 : 0 ]   |          |         |     |         |         | COLUMN  |     | ~   |
| M B [ 8 : 0 ]   |          | RO _W_  | _   | COLUMN  |         |         |     |     |
LJ
| PD[63:0]  | ~ ~  |     |     |     |     | WRITEDATA  |     |     |
| --------- | ---- | --- | --- | --- | --- | ---------- | --- | --- |
Figure 3-3. Fast Page Mode Read/Modify Write Timing
|     | T1  T2  | T3  | T4  | T5  | T6  T7  | T8  T9  | Tl0  |     |
| --- | ------- | --- | --- | --- | ------- | ------- | ---- | --- |
MCLK
\~-----------------------
U
| M A [ 8 : 0] |   ~~  |             | ~   | X COLUMN  | ~   | COLUMN  | ~   |     |
| ------------ | ----- | ----------- | --- | --------- | --- | ------- | --- | --- |
| M B [8 : O   | I     | __R _O_W __ |     |           |     |         |     |     |
\l--__- -J!
|           |     |     |     |     |           | )I(        | )I  |     |
| --------- | --- | --- | --- | --- | --------- | ---------- | --- | --- |
| PD[63:0]  | _   |     |     |     | READDATA  | WRITEDATA  |     |     |
Figure 3-4. EDO Mode Read/Modify Write Timing
FUNCTIONAL CHANGES 3-5

S3 Vision968 Multimedia Accelerator
53 Incorporated
3.9 1 CYCLE EDO VRAM SUPPORT falling CAS edge. This means that a dummy cycle
is required at the end to latch the last read. Write
data is latched by the VRAM on the falling edge
Bits 3-2 of CR36 are cleared to OOb to indicate that
of CAS. No dummy cycle is required.
1 cycle EDO VRAM operation is being used. Note
t~at CAS/OE/WE stretch capability provided by Figure 3-6 shows a read/modify/write cycle with
bits 1-0 of CR6S is unavailable with 1 cycle EDO
1 cycle EDO operation. A dummy cycle is added
operation. This mode of operation uses standard
between the read and write.
EDO VRAMs with more aggressive timing.
All line draws, image transfers, linear addressing
The functional timing for 1 cycle EDO reads and
writes is provided by Figure 3-5. The VRAM a~d pixel formatter operation are not supported
with 1 cycle EDO. 2 cycle EDO operation will
drives valid read data after the first CAS falling
automatically be used with these functions.
edge. The chip latches the data on the second
T1 T2 T3 T4 T5 T6 T7 T8 T9
MCLK
__________
J
\~ ~r-
RAS
MA18:01
MBI8:0J
PDl63:01
\\-___- J/
PDI63:01
Figure 3-5. 1 Cycle EDO Read/Write Timing
T1 T2 T3 T4 T5 T6 T7 T8 T9 T1D
MCLK
\\-______________
~r_
V-
MAI8:DI
MBI8:01
\\-----',
PDI63:DI
Figure 3.6. 1 Cycle EDO Read/Modify/Write Timing ~o~
3-6 FUNCTIONAL CHANGES

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Section 4: Electrical Data
4.1  MAXIMUM RATINGS
Table 4-1.  Absolute Maximum Ratings
Ambient temperature  00 C to 700 C
Storage temperature
-400 C to 1250 C
DC Supply Voltage  -0.5V to 7.0V
I/O Pin Voltage with respect to Vss  -0.5V to VDD+0.5V
4.2  DC SPECIFICATIONS
Table 4-2.  DC Specifications (VDD = 5V ± 5%, Operating Temperature 00 C to 700 C)
| Symbol  | Parameter            | Min           | Max        | Unit  |
| ------- | -------------------- | ------------- | ---------- | ----- |
| VIL     | Input Low Voltage    |               | 0.8        | V     |
| VIH     | Input High Voltage   | 2.0 (Note 1)  |            | V     |
| VOL     | Output Low Voltage   |               | Vss + 0.4  | V     |
| VOH     | Output High Voltage  | 2.4           |            | V     |
| 10L1    | Output Low Current   | 4 (Note 2)    |            | mA    |
|         | Output High Current  | -2            |            | mA    |
IOH1
| IOL2  | Output Low Current   | 8 (Note 3)   |     | mA  |
| ----- | -------------------- | ------------ | --- | --- |
| IOH2  | Output High Current  | -4           |     | mA  |
|       | Output Low Current   | 16 (Note 4)  |     | mA  |
IOL3
| IOH3  | Output High Current  | -8           |     | mA  |
| ----- | -------------------- | ------------ | --- | --- |
| IOL4  | Output Low Current   | 24 (Note 5)  |     | mA  |
|       | Output High Current  | -10          |     | mA  |
IOH4
| IOL5  | Output Low Current (TTL)   | 9 (Note 6)  |     | mA    |
| ----- | -------------------------- | ----------- | --- | ----- |
| IOH5  | Output High Current (TTL)  | -9          |     | mA    |
|       | Output Tri-state Current   |             | 1   | J.Ih  |
loz
| CiN   | Input Capacitance     |     | 5    | pF  |
| ----- | --------------------- | --- | ---- | --- |
| COUT  | Output Capacitance    |     | 5    | pF  |
|       | Power Supply Current  |     | 425  | mA  |
Icc
ELECTRICAL DATA 4-'

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Notes for Table 4-2
1. 2.4 V max for SCLKI
2. 10L1, IOH1 for pins BLANK, CAS[7:0], DACRD, DACWR, GD[7:0], HSYNC, INTA (SINTR)
MA[8:0], MB[8:0], PA[7:0], PD[63:0], RS[3:0], RMSTRD, STWR, VSYNC, BGNT
3. IOL2, IOH2 for pin VCLK
4. IOL3, IOH3 for pins OE[1:0], RAS[1:0]
c
5. IOL4, IOH4 for pins PAR (ABEN), STOP (DBEN), DEVSEL (LOCA), TRDY (SRDY), WE[1:0]
6. IOL5, IOH5 for pins AD[31:0], DBDIR
Note
Pin names for VL-Bus configurations are shown in parentheses.
4.3 AC SPECIFICATIONS
Notes:
1. All AC timings are based on an 80 pF test load.
2. Functional timing diagrams are found in the appropriate functional descriptions section, i.e.,
System Bus Interfaces, Display Memory or Miscellaneous Functions in the Vision964 data
book or Functional Changes in this data booklet.
4-2 ELECTRICAL DATA

••
r
S3 Vision968 Multimedia Accelerator
S3 Incorporated
4.3.1  Clock Timing
|     | 2.0" --- | ---------------        | ---                 |     |     |
| --- | -------- | ---------------------- | ------------------- | --- | --- |
|     | 1.5" --- | ------------------     | ------------------- |     |     |
|     | 0.8" --- | - -------------------- | ---------------     | -.  |     |
~--------Tcyc----------~ elK
Figure 4-1. Clock Waveform Timing
Table 4-3.  Clock Waveform Timing
| Symbol  | Parameter                        |     | Min  Max  | Units  | Notes  |
| ------- | -------------------------------- | --- | --------- | ------ | ------ |
|         | SCLK Cycle Time (VL-Bus)         |     | 20  125   |        | 1      |
| Tcyc    |                                  |     |           | ns     |        |
|         | SCLK Cycle Time (PCI)            |     | 30  125   | ns     | 1      |
|         | MCLK Cycle Time                  |     | 16.7  25  | ns     | 3      |
|         | MCLK Cycle Time                  |     | 20  25    | ns     | 4      |
|         | DCLK Cycle Time (VGA Mode)       |     | 25  100   | ns     | 1      |
|         | DCLK Cycle Time (Enhanced Mode)  |     | 10  100   | ns     | 1      |
|         | SCLK High Time (VL-Bus)          |     | 8  80     | ns     |        |
THIGH
|       | SCLK High Time (PCI)            |     | 12  80  | ns    |     |
| ----- | ------------------------------- | --- | ------- | ----- | --- |
|       | MCLK High Time                  |     | 6  10   | ns    | 3   |
|       | MCLK High Time                  |     | 8  12   | ns    | 4   |
|       | DCLK High Time (VGA Mode)       |     | 10  65  | ns    |     |
|       | DCLK High Time (Enhanced Mode)  |     | 4  65   | ns    |     |
| TLOW  | SCLK Low Time (VL-Bus)          |     | 8  80   | ns    |     |
|       | SCLK Low Time (PCI)             |     | 12  80  | ns    |     |
|       | MCLK Low Time                   |     | 6  10   | ns    | 3   |
|       | MCLK Low Time                   |     | 8  12   | ns    | 4   |
|       |                                 |     | 10  65  |       |     |
|       | DCLK Low Time NGA Mode)         |     |         | ns    |     |
|       | DCLK Low Time (Enhanced Mode)   |     | 4  65   | ns    |     |
|       | SCLK. MCLK, DCLK Slew Rate      |     | 1  4    | V/ns  | 2   |
Notes:
1.  fDCLK ~ 1/2 fSCLK to ensure valid writes to the clock chip.
2.  Rise and fall times are specified in terms of the edge rate measured in V/ns. This slew rate
must be met across the minimum peak-to peak portion of the clock waveform.
3.  For fast page and standard EDO VRAM
4.  For single cycle EDO VRAM
ELECTRICAL DATA 4-3

S3 Vision968 Multimedia Accelerator
S3 Incorporated
4.3.2  Input/Output Timing
SCLK
1.SV
MCLK
DCLK
|     | INPUT  1.SV  |     |     |
| --- | ------------ | --- | --- |
elKIN
Figure 4·2. Input Timing
Table 4-4.  SCLK-Referenced Input Timing
PCIBus
| Symbol  | Parameter                                       | Min  | Units  |
| ------- | ----------------------------------------------- | ---- | ------ |
|         | AD[31 :0], C/BE[3:01. FRAME, IRDY, IDSEL setup  | 7    | ns     |
Tsu
| TH  | AD[31 :0] hold                      | 1   | ns  |
| --- | ----------------------------------- | --- | --- |
| TH  | C/BE[3:01. FRAME, IRDY, IDSEL hold  | 0   | ns  |
VL-Bus
| Symbol  | Parameter                                       | Min  | . Units  |
| ------- | ----------------------------------------------- | ---- | -------- |
| Tsu     | AD[31 :2], BE[3:0], SM/IO, SW/R, SADS (address  | 12   | ns       |
phase) setup
| TH  | AD[31:21. BE[3:0]' SM/IO, SW/R, SADS (address  | 0   | ns  |
| --- | ---------------------------------------------- | --- | --- |
-'phase) hold
|      | AD[31:21. BE[3:01. D1, DO, SADS (data phase)  |     | ns  |
| ---- | --------------------------------------------- | --- | --- |
| Tsu  |                                               | 4   |     |
setup
| TH   | AD[31:21. BE[3:0], D1, DO, SADS (dataphase) hold  | 0   | ns  |
| ---- | ------------------------------------------------- | --- | --- |
| Tsu  | RDYIN setup                                       | 6   | ns  |
| TH   | RDYIN hold                                        | 1   | ns  |
Miscellaneous
| Symbol  | Parameter                         | Min  | Units  |
| ------- | --------------------------------- | ---- | ------ |
| Tsu     | ROM Data GD[7:0] Setup (PCI)      | 5    | ns     |
| TH      | ROM Data GD[7:0] Hold (PCI)       | 7    | ns     |
| Tsu     | General Input Port GD[7:0] setup  | 5    | ns     |
| TH      | General Input Port GD[7:0] hold   | 7    | ns     |
4-4 ELECTRICAL DATA

••
r
S3 Vision968 Multimedia Accelerator
S3 Incorporated
SCLK
MCLK  1.5 V
DCLK
DELAY
OUTPUT  1.5V
Figure 4-3. Output Timing
Table 4-5.  SCLK-Referenced Output Timing
PCIBus
| Parameter  |     | Units  Notes  |
| ---------- | --- | ------------- |
TMIN  TMAX
| AD[31 :0] valid delay  | 2  16  | ns  1              |
| ---------------------- | ------ | ------------------ |
| DEVSEL, PAR delay      | 2  11  | ns  Medium DEVSEL  |
timinQ used
| STOP delay  | 2  11  | ns  |
| ----------- | ------ | --- |
| TRDYdeiay   | 2  11  | ns  |
| INTAdeiay   | 2  11  | ns  |
VL-Bus
| Parameter                                  | TMIN  TMAX  | Units  Notes  |
| ------------------------------------------ | ----------- | ------------- |
| AD[31:21. D1, DO valid delay               | 7  16       | ns            |
| SINTR delay                                | 5  30       | ns            |
| SRDY delay                                 | 5  11       | ns            |
| LOCA active delay                          | 5  15       | ns            |
| LOCA inactive delay                        | 5  20       | ns            |
| DBDIR delay                                | 5  16       | ns            |
| ABEN, DBEN active delay (min non-overlap)  | 5  12       | ns            |
| ABEN, DBEN active delay (max non-overlap)  | 5  15       | ns            |
| ABEN, DBEN inactive delay                  |             | ns            |
|                                            | 5  13       |               |
Miscellaneous
| Parameter                           | TMIN  TMAX  | Units  Notes  |
| ----------------------------------- | ----------- | ------------- |
| RS[3:0] delay                       | 5  25       | ns            |
| RMSTRD delay                        | 3  15       | ns            |
| ROM Address valid delay (PCI)       | 5  30       | ns            |
| AD[7:0] ROM Data valid delay (PCI)  | 5  30       | ns            |
| DACRD, DACWR delay                  | 3  20       | ns            |
Note
1.  Due to the timing for TROY for read cycles, data is not sampled on the clock edge immediately
following its becoming valid. This guarantees the PCI 2.0 specification time of 11 ns.
ELECTRICAL DATA 4-5

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Table 4-6.  MCLK-Referenced Input Timing
| Symbol  | Parameter                         |     | Min  | Units  |
| ------- | --------------------------------- | --- | ---- | ------ |
| Tsu     | PD[63:0J setup (EDO memory)       |     | 0    | ns     |
| TH      | PD[63:0J hold (EDO memory)        |     | 10   | ns     |
| Tsu     | General Input Port GD[7:0J setup  |     | 5    | ns     |
| TH      | General Input Port GD[7:0J hold   |     | 7    | ns     |
Table 4-7.  MCLK-Referenced Output Timing
| Parameter                                 |     | TMIN  | TMAx  | Units  |
| ----------------------------------------- | --- | ----- | ----- | ------ |
| RAS[l :OJ active delay                    |     | 5     | 15    | ns     |
| RAS[l :OJ inactive delay                  |     | 5     | 14    | ns     |
| CAS[7:0J OE[l :01. WE[l :OJ active delay  |     | 7     | 15    | ns     |
CAS[7:0J, OE[l :01. WE[l :OJ inactive delay (min stretch) for  6  8  ns
fast page and standard EDO VRAM
CAS[7:0J, OE[l :01. WE[l :OJ inactive delay (max stretch) for  6  17  ns
fast page and standard EDO VRAM
CAS[7:0J active delay with respect to falling edge of  6  15  ns
MCLK for 1 cycle EDO operation
| MA[8:01, MB[8:0J valid delay  |     | 5   | 24  | ns  |
| ----------------------------- | --- | --- | --- | --- |
| PD[63:0J valid delay          |     |     | 27  | ns  |
5
Table 4-8.  DCLK-Referenced Output Timing
| Parameter  |     | TMIN  | TMAX  | Units  |
| ---------- | --- | ----- | ----- | ------ |
BLANK, HSYNC, VSYNC delay
|                                         |     | 3   | 17  | ns  |
| --------------------------------------- | --- | --- | --- | --- |
| VCLKdeiay                               |     | 7   | 14  | ns  |
| PA[7:0J valid delay                     |     | 5   | 14  | ns  |
| STWR delay                              |     | 3   | 20  | ns  |
| General Output Port Data GD[7:0J delay  |     | 5   | 25  | ns  |
| SC[l :OJ delay                          |     | 8   | 17  | ns  |
| SE[3:0J delay                           |     | 7   | 14  | ns  |
| DSF delay                               |     | 8   | 17  | ns  |
Table 4-9.  Fast Page Mode Memory Input Timing
| Symbol  | Parameter                             |     |      |        |
| ------- | ------------------------------------- | --- | ---- | ------ |
|         |                                       |     | Min  | Units  |
| Tsu     | PD[63:0J setup to CAS[7:0J inactive   |     | 0    | ns     |
| TH      | PD[63:0J hold from CAS[7:0J inactive  |     | 5    | ns     |
4-6 ELECTRICALDATA

53 Vision968 Multimedia Accelerator
53 Incorporated
Table 4-10.  1 Cycle EDO Mode Memory Input Timing
| Symbol  | Parameter                           | Min  | Units  |
| ------- | ----------------------------------- | ---- | ------ |
| Tsu     | PD[63:0] setup to CAS[7:0] active   | 0    | ns     |
| TH      | PD[63:0] hold from CAS[7:0] active  | 5    | ns     |
SRESET,RESET
SYSTEM
CONFIGURATION
DATA
RESETTM
Figure 4-4. Reset Timing
Table 4-11.  Reset Timing
| Symbol  | Parameter  | Min  | Units  |
| ------- | ---------- | ---- | ------ |
TLOW  SRESET (VL) or RESET (PCI) active pulse width  400  ns
| Tsu  | PD[23:0] setup to SRESET (VL) or RESET (PCI)  | 20  | ns  |
| ---- | --------------------------------------------- | --- | --- |
inactive
| TH  | PD[23:0] hold from SRESET (VL) or RESET (PCI)  | 10  | ns  |
| --- | ---------------------------------------------- | --- | --- |
inactive
4.4 OUTPUT BUFFER MODEL
Figure 4-5 shows a first order output buffer model for the Vision968. The parameters are:
| Parameter  | Description  |     |     |
| ---------- | ------------ | --- | --- |
dV/dt  Mininum and maximum rate of change of the open circuit voltage source used in the
buffer model
Ro  Minimum and maximum output impedance of the buffer model
Co  Minimum and maximum capacitance used in the buffer model
| Lp  | Minimum and maximum package inductance    |     |     |
| --- | ----------------------------------------- | --- | --- |
| Cp  | Minimum and maximum jJackage capacitance  |     |     |
The parameter values appropriate for the Vision968 depend on the manufacturing process and can be
obtained directly from S3.
ELECTRICAL DATA 4-7

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Ro
dV/dt
Figure 4-5. First Order Output Buffer Model
4-8 ELECTRICAL DATA

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Section 5: Enhanced Mode Programming
Enhanced mode provides a level of performance far beyond what is possible with the VGA architecture:
Hardware line drawing, BitBLT , rectangle fill and other drawing functions are implemented. Also
implemented are data manipulation functions, such as data extension, data source selection, and
read/write bitplane control. Hardware clipping is supported by 4 registers that define a rectangular
clipping area. While in Enhanced mode, the display memory bit map can be updated in two ways. One
is to have the CPU write directly to memory. (This is also possible in non-Enhanced modes via paging.)
The other is to have the CPU issue commands to the Graphics Engine, which then controls pixel
updating. This section explains these two methods and provides a comprehensive set of Enhanced
mode programming examples.
5.1 MEMORY-MAPPED I/O
The Vision968 provide two memory-mapped I/O (MMIO) schemes. One method is identical to that
provided by the Vision864 and provides compatibility with older software. This provides memory
mapping of a limited number of Enhanced mode registers. The second method is new to the Vision968.
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

S3 Vision968 Multimedia Accelerator
53 Incorporated
Table 5-1.  Enhanced Registers Memory Mapping
| Register Mnemonic         | I/O Address (Hex)  | Register    | PackedMMIO    |
| ------------------------- | ------------------ | ----------- | ------------- |
|                           | Old MMIO = Axxxx   | Mnemonic    | Offset (Hex)  |
|                           |                    | (Packed)    | (100xxxx)     |
| CUR Y, CUR X              | 82E8,86E8          | ALT CURXY   | 8100,8102     |
| CUR Y2, CUR X2            | 82EA, 86EA         | ALT CURXY2  | 8104,8106     |
| DESTY AXSTP,DESTX DIASTP  | 8AE8,8EE8          | ALT STEP    | 8108, 810A    |
| Y2 AXSTP2, X2 DIASTP2     | 8AEA,8EEA          | ALT STEP2   | 810C,810E     |
| ERR TERM, ERR TERM2       | 92E8,92EA          | ALT ERR     | 8110,8112     |
| CMD, CMD2                 | 9AE8,9AEA          | ALT CMD     | 8118,811A     |
| SHORT STROKE              | 9EE8               |             | 811C          |
| BKGD COLOR                | A2E8               |             | 8120          |
| FRGD COLOR                | A6E8               |             | 8124          |
| WRT MASK                  | AAE8               |             | 8128          |
812C
| RD  MASK  | AEE8  |     |     |
| --------- | ----- | --- | --- |
.
| COLOR CMP               | B2E8            |          | 8130        |
| ----------------------- | --------------- | -------- | ----------- |
| BKGD MIX, FRGD MIX      | B6E8, BAE8      | ALT MIX  | 8134,8136   |
| SCISSORS T, SCISSORS R  | BEE8 1, BEE8 2  |          | 8138,813A   |
| SCISSORS B, SCISSORS R  | BEE8 3, BEE8 4  |          | 813C, 813E  |
| PIX CNTL, MULT MISC2    | BEE8 A, BEE8 D  |          | 8140,8142   |
| MULT  MISC, READ SEL    | BEE8 E, BEE8 F  |          | 8144,8146   |
MIN AXIS PCNT, MAJ AXIS PCNT  BEE8 0,96E8  ALT PCNT  8148,814A
| MAJ AXIS PCNT2          | 96EA             |            | 814C        |
| ----------------------- | ---------------- | ---------- | ----------- |
| ROPMIX                  | D2E8             |            | 8150        |
| DESTX DIASTP, MAJ AXIS  | PCNT  8EE8,96E8  | MAXX       | 8154,8156   |
| PIX TRANS               | E2E8, E2EA       | PIX-TRANS  | 0000        |
| PAT BG  COLOR           | E6E8             |            | 8164        |
| PAT y, PAT X            | EAE8, EAEA       | ALT PAT    | 8168, 816A  |
| PAT FG COLOR            | EEE8             |            | 816C        |
5.1.2  New MMIO
The new MMIO method forthe Vision968 provides a 64-MByte addressing window starting atthe base
address specified in CR59-5A. This space is divided into a 32-MByte space for little endian (Intel-style)
addressing and a 32-MByte space for big endian (Power PC-style) addressing. All registers and data
transfer locations are mapped into this area as shown in Table 5-2.
The new MMIO is enabled by setting bits 4-3 of CR53 to 11 b. This is the default for a PCI bus
configuration, allowing PCI software immediate access to all registers and the ability to relocate the
address space. VL-Bus configurations power up with bits 4-3 of CR53 cleared to OOb, disabling both
old and new MMIO operation.
If either the old or new MMIO is enabled, bit 7 of SR9 allows register access to be either programmed
I/O (IN, OUT) or MMIO (MOV) or MMIO only.
5-2  ENHANCED MODE PROGRAMMING

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Table 5-2. New MMIO Addresses
Description Memory Map Offset
Low 32 MBytes: Little Endian A[25:0] Hex
Linear Addressinq (16M) 000 OOOO:OFF FFFF
Image Transfer Data (via E2E8, E2EA) (32K) 100 0000:100 7FFF
PCI Confiquration Space 1008000:100803F
Packed Enhanced Reqisters 100 8100:100 816F
Current V-Position Register 100 82E8
Current V-Position 2 Register 100 82EA
VGA 3B? Registers 100 83BO:l00 83BX
VGA 3C? Registers 100 83CO: 100 83CX
VGA 3D? Registers 100 83DO:l00 83DX
Setup Option Select Reqister (1 02H) 1008502
Subsystem Status Enhanced Reqister (42E8H) 1008504
Video Subsystem Enable Reqister (46E8H) 1008508
Advanced Function Control Register (4AE8H) 100 850C
Enhanced Mode Registers 100 86E8:100 EEEA
Pixel Formatter Data Transfer 1010000:1013FFF
Pixel Formatter Mask Data 1014000:1017FFF
Pixel Formatter Registers 101 8080: 101 809F
High 32 MBytes: Big Endian A[25:0] Hex
Linear Addressinq (16M) 200 0000:2FF FFFF
Image Transfer Data (via E2E8, E2EA) (32K) 300 0000:300 7FFF
PCI Configuration Space 300 8000:300 803F
Packed Enhanced Reqisters 3008100:300 816F
Current V-Position Reqister 300 82E8
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
specified by the programmer per Table 5-2. The base address bits must not be all O's, as this may cause
operating system address spaces to be overwritten.
ENHANCED MODE PROGRAMMING 5-3

..
-
"a
~
S3 Vision968 Multimedia Accelerator
53 Incorporated
When the new MMIO is enabled, both 16-bit MMIO reads and writes are supported. Only 32-bit writes
are supported.
5.1.2.1 Big/Little Endian Support
The Vision968 provide support for both big and little endian addressing. In addition to using the new
MMIO addressing as shown in Table 5-2, the required byte swapping must be specified as shown in
Table 5-3.
Table 5-3. Big Endian Byte Swap Select
Byte Swapping Affects: Swapping Specified by:
Linear Addressing, Video Engine (read/write) CR53, bits 2-1
Image Data (writes to Graphics Engine) CR61, bits 6-5
All other registers/data areas (read/write) CR54, bits 1-0
5.1.2.2 Packed MMIO Register Mapping
For improved performance, most of the Enhanced mode registers can also be accessed via a packed
configuration. The 16-bit registers are paired so that two registers can be accessed via a single 32-bit
write. Reads must be 16-bit. The address offsets from the base address for this packed configuration
are given in Table 5-1. The packed register access function is enabled when the new MMIO is enabled
(bit 3 of CR53 set to 1).
5.2 DIRECT BITMAP ACCESSING-LINEAR ADDRESSING
Linear addressing is useful when software requires direct access to display memory. The Vision968
provides two linear addressing schemes. One is the same as provided for the Vision964 and thus
provides compatibility with older software. The second is integrated into the new memory-mapped
I/O method and thus requires updated drivers for use.
5.2.1 Backward-Compatible Linear Addressing
Enhanced mode operation must be enabled before linear addressing is enabled. This means that bit
o of 4AE8H is set to 1 to enable Enhanced mode functions and bit 3 of CR31 is set to 1 to specify
Enhanced mode memory mapping.
The Vision968 provides linear addressing of up to 8 MBytes of display memory. Linear addressing of
more than 64 KBytes requires that Intel-style CPUs be operated in 386 protected mode.
The Graphics Engine busy flag, bit 9 of 9AE8H, should be verified to be 0 (not busy) before linear
addressing is enabled. This is done by setting bit 4 of CR58 or bit 4 of 4AE8H to 1. The size of the linear
address window is set via bits 1-0 of CR58. The base address for the linear addressing window is set
via CR59 and CR5A (or via the Base Address 0 (Index 10H) PCI configuration register for PCI systems).
The linear addressing window size can be set to 64 KBytes. The base address for the window is set by
programming bits 31-16 of the window position in CR59-CR5A. This allows the CPU to be operated in
real mode. If bit 0 of CR31 is set to 1, the memory page offset (64K bank) specified in bits 5-0 of CR6A
5-4 ENHANCED MODE PROGRAMMING

S3 Vision968 Multimedia Accelerator
S3 Incorporated
is added to the linear addressing window position base address, allowing access to up to 8 MBytes of
display memory through a 64-KByte window.
5.2.2 New Linear Addressing
The first 16 MBytes of each 32M address space (big and little endian) are dedicated to linear addressing.
A maximum of 8 MBytes of each address space (starting at the lowest address of the space) is usable
with the Vision968. When the new MMIO is enabled (bits 4-3 of CR53 set to 11 b), the base address is
taken from bits 31-26 of the linear address window position (bits 7-2 of CR59 or the high order 6 bits
ofthe the PCI Base Address 0). This is concatenated with the display memory address specified by the
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
being displayed by programming the DAC Mask register (3C6H). The Vision968 can manipulate 64 bits
each clock cycle, from two 32-bit pixels to eight 8-bit pixels.
Figure 5-1 is a flowchart for the process of updating the color of each pixel in the display bitmap. Start
at the block labeled 'New Color' in the middle of Figure 5-1. Atthis stage, a color has been determined
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
the comparison, as opposed to the destination (bitmap) color used by the standard VGAcolor compare
operation.
ENHANCED MODE PROGRAMMING 5-5

, .
53 Vision968 Multimedia Accelerator
S3 Incorporated
MASK BIT SOURCE
COLOR SOURCE A  COLOR SOURCE B
NO
| =          |     | =          |
| ---------- | --- | ---------- |
| SRC NE  0  |     | SRC NE  1  |
COLOR COMP = TRUE  =
COLOR COMP  TRUE
=
| SRC NE  1  |     | SRC NE = 0  |
| ---------- | --- | ----------- |
=
| COLOR COMP  | FALSE  | COLOR COMP = FALSE  |
| ----------- | ------ | ------------------- |
COLOR
COMPARE
NEW PIXEL COLOR  PIXUPDT
Figure 5-1.  Pixel Update Flowchart
5-6 ENHANCED MODE PROGRAMMING

r-~ .
S3 Vision968 Multimedia Accelerator
53 Incorporated
There are two approaches to determining the new color. One approach is depicted in Figure 5-1 and
is described next. The second approach is used with the ROPBL T command and is described at the
end of this section.
For all commands except a ROPBL T, the new color is the result of a logical mix performed on a color
source and the current color in the bitmap. For example, the color source could be XORed with the
bitmap color. The new color can also be selected by operating on only the color source or the bitmap
color, e.g., NOT color source. Both the color source and the logical mix operation are specified in either
the Background Mix register (B6EBH) or the Foreground Mix register (BAEBH). Which of these two
registers is used is determined by the settings of bits [7:6] of the Pixel Control register (BEEBH, Index
OAH).
To set up the pixel color updating scheme, the programmer specifies one of four color sources by
writing bits 6-5 of the Background Mix and Foreground Mix registers. The color sources are:
• Background Color register (A2EBH)
• Foreground Color register (A6EBH)
• CPU (via the Pixel Data Transfer registers (E2EBH, E2EAH))
• Current display bitmap color
One of 16 logical operations is chosen by writing bits 3-0 of the Background Mix and Foreground Mix
registers. Examples of logical operations are making the new pixel color index equal to the NOT of the
current bitmap color or making the new color value equal to the XOR ofthe source and current bitmap
color values.
When the logical operation and color source have been specified in the Background and Foreground
Mix registers, bits 7-6 of the Pixel Control register are written to specify the source of the mask bit
value. Ifthe resulting mask bit is a 'ONE', the Foreground Mix register is used to determine the color
source and mix. If the mask bit is a 'ZERO', the Background Mix register is used to determine the color
source and mix. There are three sources for the mask bit value:
• Always ONE (Foreground Mix register used)
• CPU (via the Pixel Data Transfer registers (E2EBH, E2EAH))
• Bitmap (display)
Setting bits 7-6 to OOb sets the mask bit to 'ONE'. All drawing updates to the display bitmap use the
Foreground Mix register settings. This setup is used to draw solid lines, through-the-plane image
transfers to display memory and BitBL Ts.
If bits 7-6 are set to 10b, the mask bit source is the CPU. After the draw operation command is issued
to the Drawing Command register (9AEB), a mask bit corresponding to every pixel drawn on the display
must be provided via the Pixel Data Transfer register(s). If the mask bit is 'ONE', the Foreground Mix
register is used. If the mask bit is 'ZERO', the Background Mix register is used. Note that if the color
source is the CPU, the mask bit source cannot also be the CPU, and vice versa. This setup is used to
transfer monochrome images such as fonts and icons to the screen.
If bits 7-6 are set to 11 b, the current display bit map is selected as the mask bit source. The Read Mask
register (AAEBH) is set up to indicate the active planes. When all bits of the read-enabled planes for a
pixel are a 1, the mask bit 'ONE' is generated. If anyone of the read-enabled planes is a 0, then a mask
bit 'ZERO' is generated. Ifthe mask bit is 'ONE', the Foreground Mix register is used. Ifthe mask bit is
'ZERO', the Background Mix register is used. Note that if the color source is the bitmap, the mask bit
ENHANCED MODE PROGRAMMING 5-7

53 Vision968 Multimedia Accelerator
S3 Incorporated
source cannot also be the bitmap, and vice versa. This setting is used to BitBlT patterns and character
images.
The ROPBlT command provides 256 raster operations that define the new color. Each operation
involves one or more of a color source, an off-screen pattern and a destination color. These colors can
be combined via various logical operations as specified in Appendix A. The source can be the CPU or
current bitmap and can be color or monochrome. The pattern can also be either color or monochrome.
Thee destination is always the current bitmap (screen) and is always color. Certain ROPBlT raster
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
Enable MMIO
Point ES to AOOOH (old MMIO) or base address (new MMIO)
load x and y values into AX and BX
MOV ES:[CUR_Y ], BX
MOV ES:[CUR_X], AX
Packed Register MMIO:
Enable MMIO
Point ES to AOOOH (old MMIO) or base address (new MMIO)
Load the x and y values into EAX (y value in the low word and x value in the high word), I.e.,
31 15 0
I
EAX<= X Y
MOV ES:[AlT _CURXY], EAX
The packed register MMIO scheme is the most efficient and is used where appropriate in the
programming examples provided later in this section. All assume that the ES register points to AOOOH
is the old MMIO is being used or the base address if the new MMIO is being used.
5-8 ENHANCED MODE PROGRAMMING

••
r
S3 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.1 Notational Conventions
The REG MNEMONIC on the left hand side of the arrow is the register mnemonic of the I/O port being
written into. Text following a ';' is a comment.
REGMNEMONIC ¢= XXXXH ; Load a hexadecimal value into the register.
REGMNEMONIC ¢= XXXXD ; Load a decimal value into the register.
REGMNEMONIC ¢= XXXX ; Load a decimal value into the register
REGMNEMONIC ¢= XXXXXXXXXXXXXXXXB ; Load a binary value into the register.
Image transfers (CPU pixel data writes to the frame buffer) are notated as follows:
COUNT
PIX_TRANS ¢= IMAGEDATA
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

53 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3 Programming Examples
This section provides programming examples for the following Enhanced mode drawing operations:
• Solid Line
• Textured Line
• Rectangle Fill Solid
• Image Transfer-Through the Plane
• Image Transfer-Across the Plane
• BitBLT-Throughthe Plane
• BitBLT - Across the Plane
• PatBLT-Through the Plane
• PatBL T- Across the Plane
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

••
r
S3 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3.1 Solid Line
This command draws a one pixel wide solid line from screen coordinates x1,y1 to x2,y2. Bresenham
parameters are used to define the line. The Pixel Control register (BEE8H, Index AH) must be set to
AOOOH to select the Foreground Mix register to specify the color source and mix type.
Setup:
Drawing a line using axial coordinates requires programming the axial step constant into the Destina
tion V-Position/Axial Step Constant (8AE8H) register (DESTY _AXSTP), the diagonal step constant into
the Destination X-Position/Diagonal Step Constant (8EE8H) register (DESTX_DIASTP) and the error
term into the Error Term (92E8H) register (ERR_TERM). Calculation of these Bresenham parameters is
based on the MAX and MIN parameters as calculated below.
MAX = maximum(ABS(x2-x1), ABS(y2-y1))
MIN = minimum(ABS(x2-x1), ABS(y2-y1))
where maximum means choose the largest of the two terms in parentheses and minimum means
choose the smallest. ABS means take the absolute value of the expression.
Bits 7-5 of the Drawing Command (9AE8H) register (CMD) specify the drawing direction. Setting bit 7
to 1 means that the V drawing direction is positive (y1 < y2). Clearing bit 7 to 0 means the V drawing
direction is negative (y1 > y2). Setting bit 6 to 1 means that V is the major (longer) axis (ABS(x2-x1) >
ABS(y2-y1)). Clearing bit 6 to 0 means that X is the major axis. Setting bit 5 to 1 means that the X
drawing direction is positive (x1 < x2). Clearing bit 5 to 0 means that the X drawing direction is negative
(x1 > x2). These values replace the DOD sequence in the write to the CMD register shown in the
pseudocode below.
The mix NEW represents a setting of 0111b in bits 3-0 of the Foreground Mix (BAE8H) register
(FRGD_MIX). This overwrites the present bitmap color value with a new value.
The remainder of the setup is:
ES:[FRGD_MIX] <== 0027H ; color source is FRGD_COLOR, mix type is NEW
ES:FRGD_COLOR] <== 00000002H ; color index
ES:[PIXEL_CNTLI <== AOOOH ; FRGD_MIX provides color source and mix type
Drawing Operation:
31 15 0
ES:[ALT _CURXV] <==1 X_1_--'-_--'y_1_---1! ; set starting coordinate
L __
ES:[MAJ_AXIS_PCNT] <== MAX -1 ; length in pixels of the major axis -1
31 15 ._ _- ,---_01 ;
ES:[ALT_STEP] <==!2*(MIN-MAXL 2*MIN diagonal and axial step constants
If the X drawing direction is positive then
ES:[ERR_T ERM] <== 2 * MIN - MAX ; error term
else if the X drawing direction is negative
ES[ERR_T ERM] <== 2 * MIN - MAX - 1 ; error term
ES:[CMD] <== 00100000DDD10001 b ; Draw line command (bits 15-13, 11), draw (as opposed to
; just move current position)(bit 4), bit 0 is always 1
ENHANCED MODE PROGRAMMING 5-11

S3 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3.2 Textured Line
The line draw command can be used to draw a one pixel wide textured line from screen coordinates
x1,y1 to x2,y2. The texture is created by (1) setting bits 7-6 ofthe Pixel Control register (BEE8H, Index
AH) to A080H to specify the CPU as the source of the mask bit selecting the mix register, (2) specifying
a background and foreground color, (3) setting bit 8 of the Command register (9AE8H) to 1 (wait for
CPU data) and (4) setting bit 1 of the Command r.egister to 1 (multi-pixel). When the pattern bit sent by
the CPU is a 1, the Foreground Mix register specifies the the color source and mix. When the bit is a
0, the Background Mix register specifies the color source and mix. This example uses the mix NEW for
the foreground mix, XOR forthe background mix, foreground color index 2 and background color index
4. The 32-bit line texture/pattern (PATTERN) is 00110000111100110011000011110011b. This requires
that bits 10-9 of the Command register be set to 10b to specify a 32-bit bus.
Setup:
The XOR mix corresponds to a setting of 0101b in bits 3-0 of the Background Mix (B6E8H) register
(BKGD_MIX). See the Solid Line example for an explanation of other parameters and registers used in
this example.
31 15 0
ES:[ALT _MIX] $= =0=0=2-=-:7_H~~-=--=--0_0-=-0-5_H~--"l ; FRGD_COLOR is color source and NEW is mix,
=1 ; BKGD_COLOR is color source and XOR is mix
ES:[FRGD_COLOR] $= 00000002H ; color index
ES:[8KGD_COLOR] $= 00000004H ; color index
ES:[PIXEL_CNTL] $= A080H ; mask data selecting mix register is provided by the CPU
Drawing Operation:
31 15 0
ES:[AL T_ CURXY] $= X_1_---'--_--'y_1_---'1 ; set starting coordinates
LI_ _
ES:[MAJ_AXIS_PCNT $= MAX -1 ; length in pixels of the major axis -1
3r1 _________1 ~5-_-------oJ ;
ES:[ALT_STEP] $=12*{MIN-MAX)1 2*MIN diagonal and axial step constants
If the X drawing direction is positive then
ES:[ERR_ TERM] $= 2 * MI N - MAX ; error term
else ifthe X drawing direction is negative
ES[ERR_T ERM] $= 2 * MIN - MAX - 1 ; error term
ES:[CMD] <= 00100101DDD10011b ; Draw line (bits 15-13, 11), 32-bit bus (bits 10-9), wait for data
; from the CPU (bit 8), draw (bit 4), multi-pixel (bit 1)
COUNT (of PATTERN dwords) = {MAX + 31)/32 (See Note)
PIX_TRANS <= 00110000111100110011000011110011b ; Output PATTERN to Pixel Data Transfer
; registers COUNT times
Note
The COUNT of the number of writes required by the CPU is a function of the number of bits to be
transferred and the width of the transfer {8, 16 or 32 bits as specified by bits 10-9 of the Drawing
Command register (9AE8H)). The number of bits transferred per line must be an even multiple of the
transfer width. If this is not the case, the last write per line must be padded with one or more dummy
5-12 ENHANCED MODE PROGRAMMING

S3 Vision968 Multimedia Accelerator
S3 Incorporated
bits to meet this requirement. For example, if the transfer width is 8 bits and nine bits are to be
transferred for the line, two bytes must be written per line, with the upper 7 bits of the second byte
padded. In general, the number of padding bits per line will vary from 0 to (n-l), where n is the transfer
width in bits.
With a transfer width of 8 bits, the number of byte writes required per line can be determined from
the formula n = (MAX+7)/8, with n being truncated to an integer if the result contains a fraction.
Thus a MAX = 11 transfer requires (11+7)/8 = 2 1/4 = 2 bytes. The formulas for all transfer widths are
given below.
8-bit transfers: COUNT = (MAX+7)/8 bytes
16-bit transfers: COUNT = (MAX+15)/16 words
32-bit transfers: COUNT = (MAX+31)/32 dwords
ENHANCED MODE PROGRAMMING 5-13

fl·
S3 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3.3  Rectangle Fill Solid
This command draws a solid rectangle with its top left corner at x1,y1, height = HEIGHT and width =
WIDTH. The Pixel Control register (BEE8H, Index AH) must be set to AOOOH to select the Foreground
Mix register to specify the color source and mix type. This example uses the mix NEW and color index
2. The drawing direction (bits 7-5 in the write to the CMD register below) is set to X positive, X major
and Y positive (101b).
Setup:
ES:[FRGD_MIX] ~ 0027H  ; color source is FRGD_COLOR, NEW mix type
| ES:[FRGD_COLOR] ~ 00000002H  |     | ; color index  |     |
| ---------------------------- | --- | -------------- | --- |
ES:[PIXEL_CNTLI ~ AOOOH  ; FRGD_MIX specifies the color source and mix type
Drawing Operation:
| 31  | 15  | 0   |     |
| --- | --- | --- | --- |
ES:[ALT  _CURXY] ~ <-I __x _1_--,-_-,-y_1_  -,I  ; set starting coordinates
| 31                       | 15           | 0                  |     |
| ------------------------ | ------------ | ------------------ | --- |
| ES:[ALT_PCNT]~I WIDTH-1  | I HEIGHT-1l  | ; rectangle width  |     |
ES:[CMD] ~ 0100000010110001b  ; Draw rectangle (bits 15-13, 11), draw (bit 4)
Note
The rectangle can be defined by specifying anyone of the four corners and setting bits 7-5 accordingly.
Always select X as the major axis (bit 6 =0). No matter how the rectangle is defined, it always fills from
left to right and top to bottom.
|     | Corner        | X direction (bit 5)  | V direction (bit 7)  |
| --- | ------------- | -------------------- | -------------------- |
|     | top left      | positive (1)         | positive (1)         |
|     | top riqht     | neqative (0)         | positive (1)         |
|     | bottom left   | positive (1)         | neqative (0)         |
|     | bottom right  | negative (0)         | negative (0)         |
5-14 ENHANCED MODE PROGRAMMING

".
S3 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3.4 Image Transfer-Through the Plane
This command transfers a rectangular image from the CPU to the display memory through the plane.
"through the plane" means the complete color index is transferred for each pixel, e.g., in 8 bits/pixel
mode, one byte is required to transfer one pixel to memory. The image is stored as an array of pixels
arranged in row major fashion (consecutively increasing memory addresses). The Pixel Control register
must be set to AOOOH to select the Foreground Mix register to specify the color source and mix type.
The color source must be specified as the CPU. Bit 12 ofthe Command register must be set to 1 (swap
ON) for Intel-type architectures. Bit 8 of the Command register must be set to 1 (wait for CPU data) and
bits 6 and 5 must also be set to 1 to specify X as the major axis and a left-to-right drawing direction.
This example uses a mix type of NEW and x1,y1 is the top left corner of the rectangle on the screen.
The height and width of the rectangle (in pixels) are HEIGHT and WIDTH. Doublword CPU writes are
supported by setting bits 10-9 of the Command register to 10b.
Setup:
ES:[FRGD_MIX) <= 0047H ; color source is the CPU, mix type is NEW
ES:[PIXEL_CNTLI <= AOOOH ; FRGD_MIX is the source for color source and mix type
Drawing Operation:
31 15 0
ES:[AL T_ CURXYI <= !.... __ X _1_ _, --_Ye-1_--,1 ; set destination starting coordinates
31 15 0
<=! ! !
ES:[AL T_ PC NT) WIDTH-1 HEIGHT-1 ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
ES:[CMD) <= 01010101D0110001b ; Draw rectangle (bits 15-13, 11), swap ON (bit 12),
; 32-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4)
COUNT (of image pixel data to transfer) = (See Note)
<=
PIX_TRANS I MAGEDATA ; Output image data to the Pixel Data Transfer registers for COU NT dwords.
Note
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred, the width ofthe transfer (8,16 or 32 bits as specified by bits 10-9 ofthe Drawing Command
register (9AE8H}) and the color depth (bits/pixel). The number of pixels transferred per line must be an
even multiple of the transfer width. If this is not the case, the last write per line must be padded with
one or more dummy pixels to meet this requirement. For example, at 4 bits/pixel, each byte holds two
pixels. If the transfer width is one byte and three pixels are to be transferred per line, two bytes must
be written per line, with the upper nibble of the second byte a dummy pixel. If the transfer width is 16
bits, from one to three dummy pixels may be required to make the number of pixels per line an even
multiple of 16. The number of word writes required per line can be determined from the formula n =
(W+3}/4, with n being truncated to an integer if the result contains a fraction. Thus a six pixel transfer
requires (6+3}/4 = 2.25 = 2 words. This is then multiplied by the height of the the image (in pixels) to
determine the COUNT of words to be transferred. Similar procedures apply to every other combination
of the variables affecting the COUNT. The formulas for all cases are given below, where W is the width
of the image and H is the height of the image, both in pixels.
ENHANCED MODE PROGRAMMING 5-15

S3 Vision968 Multimedia Accelerator
S3 Incorporated
COUNT for 4 bits/pixel modes
8-bittransfers: COUNT = (W+1)/2 * H bytes
16-bit transfers: COUNT = (W+3)/4 * H words
32-bit transfers: COUNT = (W+7)/8 * H dwords
COUNT for 8 bits/pixel modes
8-bit transfers: COUNT = W * H bytes
16-bit transfers: COUNT = (W+1)/2 * H words
32-bit transfers: COUNT = (W+3)/4 * H dwords
COUNT for 16 bits/pixel modes
8-bit transfers: Do not use this combination
16-bit transfers: COU NT = W * H words
32-bit transfers: COUNT = (W+ 1) /2 * H dwords
COUNT for 32 bits/pixel modes
8-bit transfers: COUNT = Do not use this combination
16-bit transfers: COUNT =2 W * H words
32-bit transfers: COUNT = W * H dwords
Note that in 32 bits/pixel modes, the upper byte is a dummy byte providing padding for a 24-bit
pixel.
5-16 ENHANCED MODE PROGRAMMING

••
r
S3 Vision968 Multimedia Accelerator
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
pixels corresponding to a 0 in the bit image are given color index O. This example uses word transfers
from the CPU as specified by setting bits 10-9 of the Command register to 01b for a 16-bit bus width.
Setup:
3,1 _______1 ,5 _______.0
ES:[ALT _MIX) <=1 L _0_0_27_H_L-0_0_05_H----'l ; FRGD_COLOR color source and mix is NEW
; BKGD_COLOR is color source and mix is XOR
<=
ES:[FRGD_COLOR) 00000004H ; foreground color index 4
<=
ES:[BKGD_COLOR) OOOOOOOOH ; background color index 0
<=
ES:[PIXEL_CNTL) A080H ; selection of mix register is based on data from the CPU
Drawing Operation:
31 15 0
<= 1'--__
ES:[ALT _CURXY) X_1 __- -1._ __y .:..._1 _- ---'l ; set destination starting coordinates
31 15 0
<= 1 1 1
ES:[ALT_PCNT) WIDTH-1 HEIGHT-1 ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
<=
CMD 01010011D0110011b ; Draw rectangle (bits 15-13, 11), swap ON (bit 12),
; 16-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4),
; multi-pixel (bit 1)
COUNT (of image pixel data to transfer) = ((WIDTH +15)/16)*HEIGHT words
<=
PIX_TRANS IMAGEDATA; Output image data to Pixel Transfer regist~r for COUNT words
Notes
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred and the width ofthe transfer (8, 16 or 32 bits as specified by bits 10-9 of 9AE8H). Except for
the case where bits 10-9 of 9AE8H are 11 b, the number of pixels transferred per line must be an even
multiple of the transfer width. If this is not the case, the last write per line must be padded with one or
more dummy pixels to meet this requirement. For example, if the transfer width is 8 bits and nine
pixels are to be transferred per line, two bytes must be written per line, with the upper 7 bits of the
second byte padded. In general, the number of padding bits per line will vary from 0 to (n-1), where n
is the transfer width in bits.
ENHANCED MODE PROGRAMMING 5-17

S3 Vision968 Multimedia Accelerator
S3 Incorporated
With a transfer width of B bits, the number of byte writes required per line can be determined from the
formula n = (W+7)/B, with n being truncated to an integer ifthe result contains a fraction. Thus a 13-bit
pixel transfer requires (13+7)/B = 2.5 = 2 bytes. This is then multiplied by the height of the image (in
pixels) to determine the COUNT of bytes to be transferred. Similar procedures apply to every other
combination of the variables affecting the COUNT. The formulas for all cases are given below, where
W is the width of the image and H is the height of the image, both in pixels.
B-bit transfers: COUNT = (W+7)/B * H bytes (9AEBH_10-9 = OOb)
16-bit transfers: COUNT = (W+15)/16 * H words (9AEBH_10-9 = 01b)
32-bit transfers: COUNT = (W+31)/32 * H dwords (9AEBH_10-9 = 10b)
New 32-bit transfers: COUNT = (((W+7)/B*H)+3)/4 dwords (9AEBH_10-9 = 11 b)
The differences between the two 32-bit transfer options are:
1. For 9AEBH_10-9 set to 10b, every line of the transfer must start with a fresh doubleword. In other
words, all unneeded bits in a doubleword transfer for a given line are discarded. After a rectan
gular image is transferred, the current drawing position is a the bottom left, meaning the next
rectangle, if drawn, will be below the previous rectangle.
2. For 9AEBH_10-9 set to 11 b, only bits from the end of the line width to the next byte boundary are
discarded. Data for the next line begins with the next byte. After a rectangular image is trans
ferred, the current drawing position is a the top right, meaning the next rectangle, if drawn,
will be to the right of the previous rectangle.
To write to a single plane, set the foreground mixto 'logical one' (0002H), the background mixto 'logical
zero' (0001H), and the Write Mask register (AAEBH) to select the desired (single) plane for updates.
5-1B ENHANCED MODE PROGRAMMING

S3 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3.6 BitBLT - Through the Plane
This command copies a source rectangular area in display memory to another location in display
memory. The Pixel Control register must be set to AOOOH to select the Foreground Mix register to
specify the color source and mix type. The color source must be specified as the bitmap (display
memory). Bit6 ofthe Command register must be setto 1 to specify X asthe major axis. Forthis example,
assume x1,y1 is the top left corner of the source rectangle in display memory and x2,y2 is the top left
corner ofthe destination rectangle. The rectangles can be overlapping or disjoint. The height and width
(in pixels) of the rectangle being copied are HEIGHT and WIDTH.
Setup:
First, the values of the Srcx, Srcy, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, Y Positive: Srcx = x1, Srcy = y1, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
Ifx1 >x2
then if X Positive, Srcx = x1, Destx = x2
else
Srcx = x1 + WIDTH -1, Desty = x2 + WIDTH-1 ; X Negative
Ify1 >y2
then if Y Positive, Srcy = y1, Desty = y2
else
Srcy = y1 + HEIGHT -1, Desty = y2 + HEIGHT-1 ; Y Negative
ES:[PIXEL_CNTLI <= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIXI <= 0067H ; color source is display memory and mix type is NEW
Draw Operation:
31 15 0
I l ;
ES:[ALT _CURXYI <= Srcx Srcy set starting coordinates
3I1 15 0I ;
ES:[ALT _ STEP] <= Destx Desty set destination coordinates
31 15 0
I I I
ES:[ALT_PCNTI <= WIDTH-1 HEIGHT-1 ; rectangle width and height
ES:[CMD] <= 11000000DOD10001b ; BitBLT (bits 15-13, 11), always X Major (bit 6), draw (bit 4)
ENHANCED MODE PROGRAMMING 5-19

S3 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3.7 BitBLT- Across the Plane
This uses the same command as a BitBlT through the plane. However, instead of copying complete
pixels (with color affected only by the mix), this 'across the plane" transfer uses only the bits in the
color planes specified by setting the Read Mask register (AEE8H), e.g., bit 3 of every pixel, to determine
the destination rectangle. With more than one plane enabled for read, if all the bits in the planes enabled
for read are '1's then a '1' is read. If a bit in anyone of the planes enabled for read is a '0', then '0' is
read. An "across the plane" transfer is created by (1) setting bits 7-6 ofthe Pixel Control register (BEE8H,
Index AH) to AOCOH to specify the bitmap as the source of the mask bit selecting the mix register, (2)
programming the Read and Write Mask registers to specify the plane to read from and write to and (3)
setting bit 1 of the Command register to 1 (mUlti-pixel). In this example, when the bit read is a 1, a 1 is
copied as specified by the foreground mix. When the bit read is a 0, a 0 is copied as specified by the
background mix. Assume x1,y1 is the top left corner of the source rectangle on the display, and x2,y2
is the top left corner of the destination rectangle. The image is read from plane 0 and written to plane
2. The rectangles could be overlapping or disjoint. The height and width (in pixels) ofthe rectangle are
HEIGHT and WIDTH.
Setup:
First, the values of the Srcx, Srcy, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, Y Positive: Srcx = x1, Srcy = y1, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
Ifx1 > x2
then if X Positive, Srcx = x1, Destx = x2
else
Srcx = x1 + WIDTH -1, Desty = x2 + WIDTH-1 ; X Negative
Ify1 >y2
then if Y Positive, Srcy = y1, Desty = y2
else
Srcy = y1 + HEIGHT -1, Desty = y2 + HEIGHT-1 ; Y Negative
ES:[PIXEl_CNTl] $= AOCOH ; data from display memory selects mix register
3 I r l~~~_lT5~~~_OJ ;
ES:[AlT_MIX] $= 0002H 0001H result of foreground mix is always logical 1,
; result of background mix is always logical 0
ES:[RD_MASK] $= 00000001H ; read from plane 0
ES:[WRT_ MASK] $= 00000004H ; plane 2 enabled for write
5-20 ENHANCED MODE PROGRAMMING

II·
S3 Vision968 Multimedia Accelerator
53 Incorporated
Draw Operation:
|                      | 31  15  | 0                               |
| -------------------- | ------- | ------------------------------- |
|                      | I       | I  ;                            |
| ES:[ALT _ CURXY) ¢=  | Srcx    | Srcy  set starting coordinates  |
|                      | 31  15  | 0                               |
|                      | I       | I  ;                            |
ES:[AL T_ STEP) ¢=  Destx  Desty  set destination coordinates
|     | 31  15  | 0   |
| --- | ------- | --- |
¢=I  I
ES:[ALT_PCNT)  WIDTH-1  HEIGHT-1]  ; rectangle width and height
ES:[CMD) ¢= 11000000DOD10001b  ; BitBLT (bits 15-13, 11), always X Major (bit 6) , draw (bit 4),
; multi-pixel (bit 1)
Note
It is possible to translate a monochrome image, e.g., text fonts, stored in a single plane in display
memory into a 2-color image. This is accomplished by setting the mix registers differently and setting
the desired background and foreground colors. Ifthe source bit is a '1', then the corresponding pixel
at the destination is colored with the foreground color index. The destination pixel is colored with the
background color index if the corresponding source bit is a '0'. The setup for this is as follows:
¢=
| ES:[WRT_ MASK)  | FFFFFFFFH  | ; enable all planes for writing  |
| --------------- | ---------- | -------------------------------- |
ES:[FRGD_MIX) ¢¢==   0027H  ; color source foreground, mix type NEW
ES:[BKGD_MIX)  0007H  ; color source background, mix type NEW
| ES:[FRGD_COLOR) ¢¢==   | 00000004H  | ; foreground color  |
| ---------------------- | ---------- | ------------------- |
| ES:[BKGD_COLOR)        | 00000001H  | ; background color  |
ENHANCED MODE PROGRAMMING 5-21

II·
53 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3.8 PatBlT - Pattern Fill Through the Plane
An 8x8 pixel pattern is initially copied into an off-screen area of display memory using an image transfer
operation or a direct write (linear addressing). This command then repeatedly tiles this source pattern
into a destination rectangle of arbitrary size. The colors of the destination pixels are affected only by
the mix selected. The destination rectangle must not overlap the source pattern. Each copy is aligned
to an 8-pixel boundary (x coordinate = 0,8, etc.), with pixels outside the destination rectangle boundary
not being drawn. The Pixel Control register must be set to AOOOH to select the Foreground Mix register
to specify the color source and mix type. The color source must be specified as the bitmap (display
memory). Bit 6 of the Command register must be set to 1 to specify X as the major axis. In this example,
assume x1,y1 is the top left corner of the pixel pattern and x2.y2 is the top left corner of the destination
rectangle. The height and width (in pixels) of the rectangle are HEIGHT and WIDTH.
Setup:
ES:[PIXEL_CNTL] ¢= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX] ¢= 0067H ; color source is display memory, mix type is NEW
Draw Operation
3,'_ ______', 5 _______0
¢=I
ES:[ALT _ CURXY] L _X_1_--,--_y:-1_--,1 ; set starting coordinates
3' '5 0
ES:[ALT _STEP] ¢= _X_2_--L-_y,--2_--,1 ; set destination coordinates
L-I
3' '5 0
¢=I I I
ES:[ALT_PCNT] WIDTH-1 HEIGHT-1 ; rectangle width and height
¢=
ES:[CMD] 111 00000DOD1 0001 b ; PatBLT (bits 15-13,11), always X Major (bit 6) , draw (bit 4)
5-22 ENHANCED MODE PROGRAMMING

r-~ .
S3 Vision968 Multimedia Accelerator
53 Incorporated
5.4.3.9 PatBlT - Pattern Fill Across the Plane
This uses the same command as a PatBLT through the plane. However, instead of copying complete
pixels (with color affected only by the mix), this 'across the plane" transfer uses only the bits in the
color planes specified by setting the Read Mask register (AEE8H), e.g., bit 3 of every pixel, to determine
the destination rectangle. With more than one plane enabled for read, if all the bits in the planes enabled
for read are '1's then a '1' is read. If a bit in anyone of the planes enabled for read is a '0', then '0' is
read. An "across the plane" transfer is created by (1) setting bits 7-6 ofthe Pixel Control register (BEE8H,
Index AH) to AOCOH to specify the bitmap as the source of the mask bit selecting the mix register, (2)
programming the Read and Write Mask registers to specify the plane to read from and write to and (3)
setting bit 1 of the Command register to 1 (multi-pixel). In this example, when the bit read is a 1, a 1 is
copied as specified by the foreground mix. When the bit read is a 0, a 0 is copied as specified by the
background mix. In this example, assume x1,y1 is the top left corner of the pixel pattern and x2,y2 is
the top left corner of the destination rectangle. The image is read from plane 0 and written to plane 2.
The height and width of the destination rectangle are HEIGHT and WIDTH.
Setup:
ES:[PIXEL_CNTL] ¢= AOCOH ; data from display memory selects mix register
31 15 0
ES:[AL T_ MIX] ¢= =0=0=0-:-:2_H-=-=-=-=-0_0~0-1_H~---,J ; result of foreground mix is always logical 1,
=1 ; result of background mix is always logical 0
ES:[RD_MASK] ¢= 00000001H ; read from plane 0
ES:[WRT_ MASK] ¢= 00000004H ; plane 2 enabled for write
Draw Operation:
31 15 0
ES:[ALT _ CURXY] ¢= 1 x1 y1 1 ; set starting coordinates
~------~------~
3,1 _______1 ,5 _______0
ES:[ALT _STEP] ¢= LI _ X_2_-"--_y,-2_-,l ; set destination coordinates
31 15 0
ES:[AL T_ PC NT] ¢= 1 WIDTH-1 1 HEIGHT-1 1 ; rectangle width and height
ES:[CMD] ¢= 11100000DOD10011b ; PatBL T (bits 15-13, 11), always X Major (bit 6) , draw (bit 4),
; multi-pixel (bit 1)
Note
To expand the source mono pattern into a 2-color pattern, set the foreground mix to 27H, the
background mix to 7H and the foreground and background colors as desired. Also set the write mask
(AAE8H) to FFFFFFFFH. This needs to be set only once. It is altered only by another write.
ENHANCED MODE PROGRAMMING 5-23

S3 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3.10 Short Stroke Vectors
This command rapidly draws short lines (up to 15 pixels in length). Such lines are constrained to one
of the 8 directions at 45 degree increments starting at 0 degrees. The current point x1,y1 is set and a
NOP command is issued to set all the desired drawing parameters without actually writing a pixel. For
example, bit 2 (Last Pixel Off) would be set to 1 (OFF) for drawing connected lines until the last line is
drallVn. The short stroke vector parameters are then loaded in the Short Stroke Vector Transfer (9EE8H)
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
ES:[ALT _ CURXV] <= 1,-__X _1_-,-_....:.y_1_--,1 ; set starting coordinates
ES:[CMD] <= 00010010XXX11111b ; NOP (bits 15-13, 11), byte swap (bit 12), 16-bit transfers
; (bits 10-9) , draw (bit 4), radial drawing direction (bit 3),
; last pixel off (bit 2), mUlti-pixel (bit 1)
While space available in the FIFO
ES:[SHORT_ STROKE] <= SSVD1 SHL 8 + SSVDO; SSVD1 shifted to high byte, SSVDO in low byte
ES:[SHORT_STROKE] <= SSVD3 SHL 8 + SSVD2; byte swap turned on to read vectors out in
; correct order
ES:[SHORT_STROKE] <= SSVDN-1 SHL 8 + SSVDN-2
5-24 ENHANCED MODE PROGRAMMING

••
r S3 Vision968 Multimedia Accelerator
53 Incorporated
5.4.3.11 Polyline/2-Point Line
This command draws a line from point P1 (x1,y1) to point P2 (x2,y2).lt can be used to draw an additional
line from the end point ofthe last line drawn by specifying only the next end point. This can be repeated
for as many polyline segments as desired. The Pixel Control register must be set to AOOOH to select
the Foreground Mix register to specify the color source and mix type. The color source must be specified
as the foreground color.
Setup:
ES:[FRGD_MIX] ¢= 0027H ; color source is FRGD_COLOR, NEW mix type
ES:[FRGD_COLOR]¢= 00000002H ; color index
ES:[PIXEL_CNTL] ¢= AOOOH ; FRGD_MIX specifies the color source and mix type
Draw Operation:
3,'_ ______', 5 _______0
I l
ES:[ALT _CURXY] ¢= x1 y1 ; set starting coordinates
~------~--~--~
3,'_ ______', 5 _______0
ES:[ALT _STEP] ¢= 1'--_x_2_--'--_-'-y2_--'1 ; set destination coordinates
ES:[CMD]¢= 0010100000010001b ; draw 2-point line (bits 15-13, 11), draw (bit 4)
Repeat the last two instructions to draw additional polyline segments.
Note
This command is faster for drawing a 2-point line than the Solid Line drawing command. However,
the Bresenham parameters are fixed in hardware and cannot be manipulated by the programmer as
with the Solid Line command. A textured line cannot be drawn with this command.
ENHANCED MODE PROGRAMMING 5-25

S3 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3.12 Polygon Fill Solid
This command draws a polygon and fills it with a solid color. Any number of edges can be drawn, but
the shape must be such that any horizontal line must intersect the polygon edges in no more than two
places. To accomplish this, all edge segments must be drawn downward. The exception is that any
edge can be horizontal. The Pixel Control register must be set to AOOOH to select the Foreground Mix
regi~ter to specify the color source and mix type. This example uses the mix NEW and color index 2.
This example shows how to draw the polygon shown in Figure 5-2.
x1,y1
x3,y3
x2,y2
y4
x7
STEP 1 STEP 2 STEP 3 STEP 4 STEP 5 POLY
Figure 5-2. Polygon Example Drawing Steps
Setup:
ES:[FRGD_MIX] ¢= 0027H ; color source is FRGD_COLOR, NEW mix type
ES:[FRGD_COLOR] ¢= 00000002H ; color index
ES:[PIXEL_CNTL] ¢= AOOOH ; FRGD_MIX specifies the color source and mix type
Draw Operation:
3r1 _______1 ~5------_0
ES:[ALT _CURXY] ¢= LI _X_1_-L-_y:.....1_--,l ; set starting coordinates for segment 1 of left side
3r1 _______1 ~5-------0
ES:[ALT _STEP] ¢= LI _X_2_--,--_y:.....2_--,1 ; set destination coordinates for segment 1 of left side
31 15 0
ES:[ALT _CURXY2] ¢= 1'---__x_ 1 __- --'-___y .:......-1 __- ,I ; set starting coordinates for segment 1 of right side
31 15 0
ES:[ALT _STEP2] ¢= IL_x_3_-L-_y:.....3_--,1 ; set destination coordinates for segment 1 of right side
ES:[CMD]¢= 0110000000010001b ; draw polygon (bits 15-13, 11), draw (bit 4) -Step 1
3r1 __~ ~_1,5_ ___~ _O
ES:[ALT _STEP2] ¢= 1-1_ X_4_--,--_y:.....4_--,' ; set destination coordinates for segment 2 of right side
ES:[CMD]¢= 0110000000010001b ; draw polygon (bits 15-13, 11) -Step 2
31 15 --l0' ;
ES:[ALT _STEP] ¢= LI ___x_ 5_ _- --'-__- --'-y_5 _ set destination coordinates for segment 2 of left side
5-26 ENHANCED MODE PROGRAMMING

II·
S3 Vision968 Multimedia Accelerator
S3 Incorporated
ES:[CMD]<= 0110000000010001b ; draw polygon (bits 15-13, 11) -Step 3
°
3' '5
ES:[ALT _STEP] <= LI _X_6_-L_y,-6_-,1 ; set destination coordinates for segment 3 of left side
ES:[CMD]<= 0110000000010001b ; draw polygon (bits 15-13, 11) -Step 4
3 r' _______' ,5_ ______0
ES:[ALT _STEP] <= LI _x_7_-L_y,-7_-,l ; set destination coordinates for segment 4 of left side
3 r' _______', 5 _______0
ES:[ALT_STEP2] <=IL_ x_8_-L_Y,-8_-,l ; set destination coordinates for segment 3 of right side
ES:[CMD]<= 0110000000010001 b ; draw polygon (bits 15-13, 11) -Step 4
The generation of this polygon is summarized in the following table.
Table 5-4. Polygon Fill Example Summary
First Line Second Line
ALT CURXV ALT STEP ALT CURXV2 ALT STEP2
Step_1 xl yl x2 y2 xl '{1 x3 _y3
CMD
Step 2 x4 y4
CMD
Step 3 x5 v5
CMD
Step 4 x6 v6
CMD
StepS x7 y] x8 v8
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

53 Vision968 Multimedia Accelerator
S3 Incorporated
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
ES:[PIXEL_CNTL) <= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX) <= 0067H ; color source is display memory, mix type is NEW
3r1 _______1 ~5-------0
ES:[ALT_PAT) <=1 PAT_X 1 PAT_Y 1 ; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Color Pattern)
Same as for polygon fill solid except
ES:[CMD)<= 01101000000010001b ; draw polygon with pattern fill (bits 15-13, 11)
is substituted for each of the command lines.
Setup: (Mono Pattern)
31 15 0
ES:[ALT _ MIX) <= '--1 -0-0-27-H-'---0-0-05-H-';1 ; FRGD_COLOR color source and mix is NEW
; BKGD_COLOR is color source and mix is XOR
ES:[FRGD_COLOR) <= 00000004H ; foreground color index 4
ES:[BKGD_COLOR) <= OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTL) <= AOCOH ; selection of mix register is based on data from the screen
31 15 o
; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Mono Pattern)
Same as for polygon fill solid except
ES:[CMD)<= 0110100000010011b ; draw polygon with pattern fill (bits 15-13, 11),
; mUlti-pixel (bit 1)
is substituted for each of the command lines.
5-28 ENHANCED MODE PROGRAMMING

S3 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3.14 4-Point Trapezoid Fill Solid
This command draws a solid trapezoid specified by edge 1 [points P1 (x1.y1) and P2 (x2.y2)] and edge
2 [points P3 (x3.y3) and P4 (x4.y4)]. P1 and P3 must be on the same horizontal line and P2 and P4 must
be on a different lower horizontal line. The Pixel Control register must be set to AOOOH to select the
Foreground Mix register to specify the color source and mix type. This example uses the mix NEW and
color index 2.
Setup:
ES:[FRGD_MIX] <= 0027H ; color source is FRGD_COLOR, NEW mix type
ES:[FRGD_COLOR] <= 00000002H ; color index
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX specifies the color source and mix type
Draw Operation:
3,'_ ______', 5 _______0
ES:[ALT _CURXY] <= 1,--_x_1_....l..---,-y_1 - ----Jl ; set starting coordinates for edge 1
3 r' _______' ,5_ ______0
ES:[ALT _STEP] <= _X_2_--,-_y,-2_--,1 ; set destination coordinates for edge 1
,-I
°
3' '5
ES:[ALT _CURXY2] <= 1-1_ _x_ 3_--"-_--'y_3_......J1 ; set starting coordinates for edge 2
3 r' _______', 5 _______0
ES:[ALT _STEP2] <= _x_4_--,-_y,-4_--,1 ; set destination coordinates for edge 2
,-I
ES:[CMD]<= 1000000000010001b ; draw 4-point trapezoid (bits 15-13, 11), draw (bit 4)
Note
The y coordinates for line 2 (y3 and y4) are not required. If they are programmed, they must be the
same as y1 and y2 respectively.
ENHANCED MODE PROGRAMMING 5-29

53 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3.15 4-point Trapezoid Fill Pattern
This command operates exactly as the 4-point trapezoid fill solid except that an 8x8 pixel pattern is
tiled into the trapezoid instead of a solid color. The 8x8 pattern can either be color or mono and must
first be programmed into off-screen memory using an image transfer or linear addressing. The
destination trapezoid must not overlap the source pattern. Each copy is aligned to an 8-pixel boundary
(x coordinate = 0, 8, etc.), with pixels outside the destination trapezoid boundary not being drawn. For
a color pattern. the Pixel Control register must be set to AOOOH to select the Foreground Mix register
to specify the color source and mix type. The color source must be specified as the bitmap (display
memory). For a mono pattern, the Pixel Control register must be set to AOCOH to select the bitmap as
the source ofthe mask bit selecting the mix register.lfthe pattern bit is a 1, the Foreground Mix register
is chosen, which must be programmed to select the foreground color. If the pattern bit is a 0, the
Background Mix register is chosen, which must be programmed to select the background color.
Setup: (Color Pattern)
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX] <= 0067H ; color source is display memory, mix type is NEW
3 Ir 1 ____1. ., I .5 _ ___ J0
ES:[ALT_PAT] <= PAT_X PAT_Y ; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Color Pattern)
Same as for 4-point trapezoid fill solid except the command is as follows:
ES:[CMD]<= 0110100000010001b ; draw trapezoid with pattern fill (bits 15-13, 11)
Setup: (Mono Pattern)
31 15 0
ES:[ALT _ MIX] <= 1'---0-0-27-:-H""'--'-0-0-05-:-H'---] ; FRGD_COLOR color source and mix is NEW
; BKGD_COLOR is color source and mix is XOR
ES:[FRGD_COLOR] <= 00000004H ; foreground color index 4
ES:[BKGD_COLOR] <= OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTL] <= AOCOH ; selection of mix register is based on data from the screen
31 15 °
; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Mono Pattern)
Same as for 4-point trapezoid fill solid except the command is as follows:
ES:[CMD]<= 1000100000010011b ; draw trapezoid with pattern fill (bits 15-13, 11), multi-pixel (bit 1)
5-30 ENHANCED MODE PROGRAMMING

S3 Vision968 Multimedia Accelerator
53 Incorporated
5.4.3.16 Bresenham Parameter Trapezoid Fill Solid
This command operates exactly as the 4-point trapezoid fill solid except the two edges are drawn with
Bresenham parameters specified by the programmer. Calculation of these Bresenham parameters is
based on the MAX and MIN parameters as calculated below.
MAX = maximum(ABS(x2-x1), ABS(y2-y1))
MIN = minimum(ABS(x2-x1), ABS(y2-y1))
where maximum means choose the largest of the two terms in parentheses and minimum means
choose the smallest. ABS means take the absolute value of the expression. The fill must proceed
downward (V positive).
Setup:
ES:[FRGD_MIX] <= 0027H ; color source is FRGD_COLOR, NEW mix type
ES:[FRGD_COLOR] <= 00000002H ; color index
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX specifies the color source and mix type
Draw Operation
3' '5 0
ES:[ALT _ CURXY] <=LI __x _1_----L_---'-y_1_-'1 ; set starting coordinate for edge 1
ES:[MAJ_AXIS_PCNTl <= MAX -1 ; length in pixels of the major axis -1 for edge 1
3r' _____'T 5_ ____1O ;
ES:[AL T_ STEP] <=12*(MIN-MAX)! 2*MIN diagonal and axial step constants for edge 1
If the X drawing direction is positive then
ES:[ERR_TERM] <= 2 * MIN - MAX ; error term for edge 1
else if the X drawing direction is negative
ES[ERR_TERM] <= 2 * MIN - MAX-1 ; error term for edge 1
3' '5 0
ES:[ALT_ CURXY2] <= LI __x _2_----L_---'-y_2_-'l ; set starting coordinate for edge 2
ES:[MAJ_AXIS_PCNT2] <= MAX -1 ; length in pixels of the major axis -1 for edge 2
3r' ____ _____0
~'T5 1;
ES:[AL T_ STEP2] <=12*(MIN-MAX)! 2*MIN diagonal and axial step constants for edge 2
If the X drawing direction is positive then
ES:[ERR_TERM] <= 2 * MIN - MAX ; error term for edge 2
else if the X drawing direction is negative
ES[ERR_T ERM] <= 2 * MIN - MAX - 1 ; error term for edge 2
ES:[CMD2]<= 000000001 DDOOOOOb ; edge 2 drawing direction (bits 7-5)
ES:[CMD]<= 101000001DD10001b ; draw Bresenham parameter trapezoid (bits 15-13, 11)
; edge 1 drawing direction (bits 7-5), draw (bit 4)
Note that the last two instructions can be packed, i.e, ES:[ALL CMD], with CMD in the lower word
(15-0) and CMD2 in the upper word (31-16). If they are not packed, CMD2 must precede CMD as
shown.
ENHANCED MODE PROGRAMMING 5-31

II·
53 Vision968 Multimedia Accelerator
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
to select the bitmap as the source of the mask bit selecting the mix register. If the pattern bit is a 1, the
Foreground Mix register is chosen, which must be programmed to select the foreground color. If the
pattern bit is a 0, the Background Mix register is chosen, which must be programmed to select the
background color.
Setup: (Color Pattern)
ES:[PIXEL_CNTL) ¢= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX) ¢= 0067H ; color source is display memory, mix type is NEW
3,1_ _______1 5,-______l0
ES:[ALT_PAT) ¢= I PAT_X PAT_Y ; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Color Pattern)
Same as for Bresenham parameter trapezoid fill solid except the command is as follows:
ES:[CMD)¢= 101010001 DD10011 b ; draw Bresenham parameter trapezoid with pattern fill
; (bits 15-13, 11)
Setup: (Mono Pattern)
°
31 15
ES:[ALT _MIX) ¢= 1,--0-0-27-H----,,--0-0-05-H-l ; FRGD_COLOR color source and mix is NEW
; BKGD_COLOR is color source and mix is XOR
ES:[FRGD_COLOR) ¢= 00000004H ; foreground color index 4
ES:[BKGD_COLOR) ¢= OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTL) ¢= AOCOH ; selection of mix register is based on data from the screen
3,1_ _______1 5,-______0
ES:[ALT_PAT) ¢=I PAT_X I PAT_Y I ; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Mono Pattern)
Same as for Bresenham parameter trapezoid fill solid except the command is as follows:
ES:[CMD)¢= 101010001DD10011b ; draw Bresenham parameter trapezoid with pattern fill
; (bits 15-13, 11), mUlti-pixel (bit 1)
5-32 ENHANCED MODE PROGRAMMING

53 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3.18 ROPBlT s
The ROPBL T function provides a full implementation of the 256 raster operations as defined by
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
Based on the above definitions, there are 6 valid ROPBL T cases:
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

S3 Vision968 Multimedia Accelerator
S3 Incorporated
=
Color Pattern Case 1 (Source Screen, Color Pixels)
This command copies a source rectangular area in display memory to another location in display
memory. The Pixel Control register must be set to AOOOH to select the Foreground Mix register to
specify the color source. The color source must be specified as the bitmap (screen). The 8x8 pixel
pattern must be copied to off-screen memory on an 8-pixel horizontal boundary and its location
specified. Bit 6 ofthe Command register must be setto 1 to specify X as the major axis. Forthis example,
assume x1.y1 is the top left corner of the source rectangle in display memory and x2.y2 is the top left
corner ofthe destination rectangle. The rectangles can be overlapping or disjoint. The height and width
(in pixels) of the rectangle being copied are HEIGHT and WIDTH.
Setup:
First, the values of the Srcx, Srcy, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, V Positive: Srcx = x1, Srcy = y1, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
Ifx1 > x2
then if X Positive, Srcx = x1, Destx = x2
else
Srcx = x1 + WIDTH -1, Destx = x2 + WIDTH-1 ; X Negative
Ify1 >y2
then if V Positive, Srcy = y1, Desty = y2
else
Srcy = y1 + HEIGHT -1, Desty = y2 + HEIGHT-1 ; V Negative
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX is the source of color source
ES:[FRGD_MIX] <= 006XH ; color source is screen, mix type is ignored
ES:[ROPMIX] <= OOXXH ; color pattern flag, XX = ROP code
Draw Operation:
31 15 0
Paty I ; set starting coordinates for pattern
31 15 0
ES:[ALT _CURXY] <= _S_rc_x_--'-S_r-c-y'- --- ] ' ; set starting coordinates
1--1
31 15 0
ES:[ALT _ STEP] <= IL-_D_es_tx_...l..-D_-e--s=ty-- ----' ; set destination coordinates
1
31 15 0
ES:[ALT_PCNT] <= 1 WIDTH-1 I HEIGHT-1] ; rectangle width and height
ES:[CMD] <= 11001000DOD10001b ; ROPBLT (bits 15-13,11), always X Major (bit 6), draw (bit 4)
5-34 ENHANCED MODE PROGRAMMING

S3 Vision968 Multimedia Accelerator
53 Incorporated
Color Pattern Case 2 (Source = CPU, Color Pixels)
This command transfers a rectangular image from the CPU to the display memory through the plane.
"through the plane" means the complete color index is transferred for each pixel, e.g., in 8 bits/pixel
mode, one byte is required to transfer one pixel to memory. The image is stored as an array of pixels
arranged in row major fashion (consecutively increasing memory addresses). The Pixel Control register
must be setto AOOOH to selectthe Foreground Mix register to specify the color source. The color source
must be specified as the CPU. ROP codes without a source operand must not be used. The 8x8 pixel
pattern must be copied to off-screen memory on an 8-pixel horizontal boundary and its location
specified. Bit 12 of the Command register must be set to 1 (swap ON) for Intel-type architectures. Bit
8 of the Command register must be set to 1 (wait for CPU data) and bits 6 and 5 must also be set to 1
to specify X as the major axis and a left-to-right drawing direction. For this example, x1.y1 is the top
left corner of the rectangle on the screen. The height and width of the rectangle (in pixels) are HEIGHT
and WIDTH. Doublword CPU writes are supported by setting bits 10-9 of the Command register to 10b.
Setup:
ES:[PIXEL_CNTL) <== AOOOH ; FRGD_MIX is the source for color source
ES:[FRGD_MIX) <== 004XH ; color source is the CPU, mix type is ignored
ES:[ROPMIX) <== OOXXH ; color pattern flag, XX = ROP code
Drawing Operation:
31 15 0
ES:[ALT_PAT) <==1 Patx Paty 1 ; set starting coordinates for pattern
31 15 0
J
ES:[ALT _ STEP) <== 1 x1 y1 ; set destination starting coordinates
31 15 0
J
ES:[ALT_PCNT) <==1 WIDTH-1 1 HEIGHT-1 ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
ES:[CMD) <== 11001101D0110001b ; ROPBLT (bits 15-13, 11), swap ON (bit 12),
; 32-bit transfers (bits 10-9). wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5). draw (bit 4)
COUNT (of image pixel data to transfer) = (See Note)
PIX_TRANS <== I MAGEDATA ; Output image data to the Pixel Data Transfer registers for COU NT dwords.
Note
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred, the width ofthe transfer (8, 16 or 32 bits as specified by bits 10-9 ofthe Drawing Command
register (9AE8H)) and the color depth (bits/pixel). The number of pixels transferred per line must be an
even multiple of the transfer width. If this is not the case, the last write per line must be padded with
one or more dummy pixels to meet this requirement. For example, at 4 bits/pixel, each byte holds two
pixels. If the transfer width is one byte and three pixels are to be transferred per line, two bytes must
be written per line, with the upper nibble of the second byte a dummy pixel. If the transfer width is 16
bits, from one to three dummy pixels may be required to make the number of pixels per line an even
multiple of 16. The number of word writes required per line can be determined from the formula n =
(W+3)14, with n being truncated to an integer if the result contains a fraction. Thus a six pixel transfer
requires (6+3)14 = 2.25 = 2 words. This is then multiplied by the height of the the image (in pixels) to
determine the COUNT of words to be transferred. Similar procedures apply to every other combination
ENHANCED MODE PROGRAMMING 5-35

r-~ .
S3 Vision968 Multimedia Accelerator
S3 Incorporated
ofthe variables affecting the COUNT. The formulas for all cases are given below, where W is the width
of the image and H is the height of the image, both in pixels.
COUNT for 4 bits/pixel modes
8-bit transfers: COUNT = (W+1)/2 * H bytes
16-bit transfers: COUNT = (W+3)/4 * H words
32-bit transfers: COUNT = (W+7)/8 * H dwords
COUNT for 8 bits/pixel modes
8-bit transfers: COUNT = W * H bytes
16-bittransfers: COUNT = (W+1)/2 * H words
32-bit transfers: COUNT = (W+3)/4 * H dwords
COUNT for 16 bits/pixel modes
8-bit transfers: Do not use this combination
16-bit transfers: COUNT =W * H words
32-bit transfers: COUNT = (W+1)/2 * H dwords
COUNT for 32 bits/pixel modes
8-bit transfers: COUNT = Do not use this combination
16-bit transfers: COUNT = 2W * H words
32-bit transfers: COUNT = W * H dwords
5-36 ENHANCED MODE PROGRAMMING

..fa
p• -
53 Vision968 Multimedia Accelerator
S3 Incorporatad
Color Pattern Case 3 (Source = CPU, Mono Pixels)
This command transfers a rectangul!lr image from the CPU to the display memory across the plane.
"across the plane" means that each bit sent by the CPU is stored in display memory as a single pixel.
These pixels are arranged in row major fashion (consecutively increasing memory addresses). An
"across the plane" transfer is created by (1) setting bits 7-6 of the Pixel Control register to A080H to
specify the CPU as the source of the mask bit selecting the mix register, (2) specifying a background
and foreground color, (3) setting bit 8 of the Command register (9AE8H) to 1 (wait for CPU data) and
(4) setting bit 1 of the Command register to 1 (multi-pixel). ROP codes without a source operand must
not be used. The 8x8 pixel pattern must be copied to off-screen memory on an 8-pixel horizontal
boundary and its location specified. When the pattern bit sent by the CPU is a 1, the Foreground Mix
register specifies the the color source and mix. When the bit is a 0, the Background Mix register specifies
the color source and mix. For this example, x1.y1 is the top left corner ofthe rectangle on the screen.
The height and width of the rectangle (in pixels) are HEIGHT and WIDTH. The monochrome image is
translated so that pixels corresponding to a 1 in the bit image are given color index 4 and pixels
corresponding to a 0 in the bit image are given color index O. This example uses word transfers from
the CPU as specified by setting bits 10-9 ofthe Command register to 01b for a 16-bit bus width.
Setup:
|     | 31  15  0  |     |
| --- | ---------- | --- |
ES:[AlT _ MIX) <=  1,--0-O--:2X...."H-,---.--0-0-OX:-:-H~1  ; FRGD_COlOR is color source
; BKGD_COlOR is color source
| ES:[FRGD_COlOR) <= 00000004H  | ; foreground color index 4  |     |
| ----------------------------- | --------------------------- | --- |
| ES:[BKGD_COlOR) <= OOOOOOOOH  | ; background color index 0  |     |
ES:[PIXEl_CNTL) <= A080H  ; selection of mix register is based on data from the CPU
| ES:[ROPMIX) <= OOXXH  | ; color pattern flag, XX = ROP code  |     |
| --------------------- | ------------------------------------ | --- |
Drawing Operation:
|     | 31  15  0  |     |
| --- | ---------- | --- |
|     | I  I       |     |
ES:[AlT_ PAT) <=  Patx  Paty  ; set starting coordinates for pattern
|     | 31  15  0  |     |
| --- | ---------- | --- |
|     | I  I       |     |
ES:[AlT _ STEP) <=  x1  y1  ; set destination starting coordinates
|                     | 31  15  0          |                    |
| ------------------- | ------------------ | ------------------ |
|                     | I  I  J            |                    |
| ES:[AlT_ PC NT) <=  | WIDTH-1  HEIGHT-1  | ; rectangle width  |
Wait for Graphics Engine not busy  ; loop till bit 9 of 9AE8H register is 0
CMD <= 11001011D0110011b  ; ROPBl T (bits 15-13, 11), swap ON (bit 12),
; 16-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4),
; mUlti-pixel (bit 1)
COUNT (of image pixel data to transfer) = ((WIDTH +15)/16)*HEIGHTwords
PIX_TRANS <= IMAGEDATA; Output image data to Pixel Transfer register for COUNT words
Notes
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred and the width of the transfer (8,16 or 32 bits as specified by bits 10-9 of9AE8H). Except for
the case where bits 10-9 of 9AE8H are 11 b, the number of pixels transferred per line must be an even
multiple of the transfer width. If this is not the case, the last write per line must be padded with one or
more dummy pixels to meet this requirement. For example, if the transfer width is 8 bits and nine
ENHANCED MODE PROGRAMMING 5-37

fl·
53 Vision968 Multimedia Accelerator
53 Incorporated
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
zero' (0001H), and the Write Mask register (AAEBH) to select the desired (single) plane for updates.
5-3B ENHANCED MODE PROGRAMMING

II·
S3 Vision968 Multimedia Accelerator
S3 Incorporated
Mono Pattern Case 1 (Source = Screen, Color Pixels)
This command copies a source rectangular area in display memory to another location in display
memory. It is identical to the Color Pattern Case 1 except that the Pattern Foreground and Background
Colors registers are programmed, the Bitplane Read Mask register is programmed to select the same
bitplane enabled by the Bitplane Write Mask register when the pattern is written to memory and the
mono pattern flag is set in the ROPMIX register. The Pixel Control register must be set to AOOOH to
select the Foreground Mix register to specify the color source. The color source must be specified as
the bitmap (screen). The 8x8 mono pattern must be copied to off-screen memory on an 8-bit horizontal
boundary and its location specified. Bit 6 of the Command register must be set to 1 to specify X as the
major axis. For this example, assume x1.y1 is the top left corner of the source rectangle in display
memory and x2.y2 is the top left corner of the destination rectangle. The rectangles can be overlapping
or disjoint. The height and width (in pixels) of the rectangle being copied are HEIGHT and WIDTH.
Setup:
First, the values of the Srcx, Srcy, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, Y Positive: Srcx = x1, Srcy = y1, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
Ifx1 > x2
then if X Positive, Srcx = x1, Destx = x2
else
Srcx = x1 + WIDTH -1, Destx = x2 + WIDTH-1 ; X Negative
Ify1 > y2
then if Y Positive, Srcy = y1, Desty = y2
else
Srcy = y1 + HEIGHT -1, Desty = y2 + HEIGHT-1 ; Y Negative
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX is the source of color source
ES:[FRGD_MIX] <= 006XH ; color source is screen, mix type is ignored
ES:[ROPMIX] <= 01XXH ; mono pattern flag, XX = ROP code
ES:[PAT_FG_COLOR] <= 00000004H ; foreground color index 4
ES:[PAT_BG_COLOR] <= OOOOOOOOH ; background color index 0
ES:[RD_MASK] <= 00000001H ; bitplane 0 enabled for reading
Draw Operation:
31 15 0
ES:[ALT _PAT] <= I'--_P_at_x_-'--_ Pa __ ty = __--- I ' ; set starting coordinates for pattern
31 15 0
ES:[ALT _CURXY] <=1' -_S_rc_x_-'--_ Sr _ c _ y =_ _---'1 ; set starting coordinates
31 15 0
ES:[ALT _STEP] <= 1 Destx Desty
L-______ 1 ~ ____ ~ ~
; set destination coordinates
ENHANCED MODE PROGRAMMING 5-39

,.-
-,ja
•
S3 Vision968 Multimedia Accelerator
S3 Incorporated
31 15 0
I I I
ES:[ALT _PC NT] <= WIDTH-1 HEIGHT-1 ; rectangle width and height
ES:[CMD] <= 11001000DOD1 0001 b ; ROPBLT(bits 15-13, 11), always X Major (bit 6) ,draw (bit 4)
5-40 ENHANCED MODE PROGRAMMING

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Mono Pattern Case 2 (Source = CPU, Color Pixels)
This command transfers a rectangular image from the CPU to the display memory through the plane.
It is identical to the Color Pattern Case 2 described earlier except that the Pattern Foreground and r
Background Colors registers are programmed, the Bitplane Read Mask register is programmed to select I~
the same bitplane enabled by the Bitplane Write Mask register when the pattern is written to memory
I'
and the mono pattern flag is set in the ROPMIX register. "through the plane" means the complete color I~;'.,
index is transferred for each pixel, e.g., in 8 bits/pixel mode, one byte is required to transfer one pixel
to memory. The image is stored as an array of pixels arranged in row major fashion (consecutively
increasing memory addresses). The Pixel Control register must be set to AOOOH to select the Fore-
ground Mix register to specify the color source. The color source must be specified as the CPU. ROP
codes without a source operand must not be used. The 8x8 mono pattern must be copied to off-screen
memory on an 8-bit horizontal boundary and its location specified. Bit 12 of the Command register
must be set to 1 (swap ON) for Intel-type architectures. Bit 8 of the Command register must be set to
1 (waitfor CPU data) and bits 6 and 5 must also be set to 1 to specify X asthe major axis and a left-to-right
drawing direction. For this example, x1,y1 is the top left corner of the rectangle on the screen. The
height and width of the rectangle (in pixels) are HEIGHT and WIDTH. Doublword CPU writes are
supported by setting bits 10-9 of the Command register to 10b.
Setup:
ES:[PIXEL_CNTL] ¢: AOOOH ; FRGD_MIX is the source for color source
ES:[FRGD_MIX] ¢: 004XH ; color source is the CPU, mix type is ignored
ES:[ROPMIX] ¢: 01XXH ; mono pattern flag, XX = ROP code
ES:[PAT_FG_COLOR] ¢: 00000004H ; foreground color index 4
ES:[PAT_BG_COLOR] ¢: OOOOOOOOH ; background color index 0
ES:[RD_MASK] ¢: 00000001H ; bitplane 0 enabled for reading
Drawing Operation:
31 15 0
J
ES:[ALT _PAT] ¢: 1 Patx Paty ; set starting coordinates for pattern
31 15 0
ES:[ALT _STEP) ¢: 1 x1 y1 1 ; set destination starting coordinates
31 15 0
ES:[ALT_PCNT) ¢:I WIDTH-1 1 HEIGHT-1 1 ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
ES:[CMD) ¢: 11001101D0110001b ; ROPBLT (bits 15-13, 11), swap ON (bit 12),
; 32-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4)
COUNT (of image pixel data to transfer) = (See Note)
PIX_TRANS ¢: I MAGEDATA ; Output image data to the Pixel Data Transfer registers for COU NT dwords.
Note
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred, the width ofthe transfer (8,16 or 32 bits as specified by bits 10-9 ofthe Drawing Command
register (9AE8H)) and the color depth (bits/pixel). The number of pixels transferred per line must be an
even mUltiple of the transfer width. If this is not the case, the last write per line must be padded with
one or more dummy pixels to meet this requirement. For example, at 4 bits/pixel, each byte holds two
ENHANCED MODE PROGRAMMING 5-41

S3 Vision968 Multimedia Accelerator
53 Incorporated
pixels. If the transfer width is one byte and three pixels are to be transferred per line, two bytes must
be written per line, with the upper nibble of the second byte a dummy pixel. If the transfer width is 16
bits, from one to three dummy pixels may be required to make the number of pixels per line an even
multiple of 16. The number of word writes required per line can be determined from the formula n =
(W+3)/4, with n being truncated to an integer if the result contains a fraction. Thus a six pixel transfer
requires (6+3)/4 = 2.25 = 2 words. This is then multiplied by the height of the the image (in pixels) to
determine the COUNT of words to be transferred. Similar procedures apply to every other combination
ofthe variables affecting the COUNT. The formulas for all cases are given below, where W is the width
of the image and H is the height of the image, both in pixels.
COUNT for 4 bits/pixel modes
a-bit transfers: COUNT = (W+ 1) /2 * H bytes
16-bit transfers: COUNT = (W+3)/4 * H words
32-bit transfers: COUNT = (W+7)/a * H dwords
COUNT for a bits/pixel modes
a-bit transfers: COUNT =W * H bytes
16-bit transfers: COUNT = (W+1)/2 * H words
32-bit transfers: COUNT = (W+3)/4 * H dwords
COUNT for 16 bits/pixel modes
a-bit transfers: Do not use this combination
16-bit transfers: COUNT = W * H words
32-bit transfers: COUNT = (W+ 1) /2 * H dwords
COUNT for 32 bits/pixel modes
a-bit transfers: COUNT = Do not use this combination
16-bit transfers: COUNT = 2W * H words
32-bit transfers: COUNT = W * H dwords
5-42 ENHANCED MODE PROGRAMMING

S3 Vision968 Multimedia Accelerator
S3 Incorporated
Mono Pattern Case 3 (Source = CPU, Mono Pixelsl
This command transfers a rectangular image from the CPU to the display memory across the plane. It
is identical to the Color Pattern Case 3 described earlier except that the Pattern Foreground and
Background Colors registers are programmed, the Bitplane Read Mask register is programmed to select
the same bitplane enabled by the Bitplane Write Mask register when the pattern is written to memory
and the mono pattern flag is set in the ROPMIX register. "across the plane" means that each bit sent
by the CPU is stored in display memory as a single pixel. These pixels are arranged in row majorfashion
(consecutively increasing memory addresses). An "across the plane" transfer is created by (1) setting
bits 7-6 of the Pixel Control register to A080H to specify the CPU as the source of the mask bit selecting
the mix register, (2) specifying a background and foreground color, (31 setting bit 8 of the Command
register (9AE8H) to 1 (wait for CPU data) and (4) setting bit 1 of the Command register to 1 (multi-pixel).
ROP codes without a source operand must not be used. The 8x8 mono pattern must be copied to
off-screen memory on an 8-bit horizontal boundary and its location specified. When the pattern bit sent
by the CPU is a 1, the Foreground Mix register specifies the the color source and mix. When the bit is
a 0, the Background Mix register specifies the color source and mix. For this example, x1.y1 is the top
left corner of the rectangle on the screen. The height and width ofthe rectangle (in pixels) are HEIGHT
and WIDTH. The monochrome image is translated so that pixels corresponding to a 1 in the bit image
are given color index 4 and pixels corresponding to a 0 in the bit image are given color index o. This
example uses word transfers from the CPU as specified by setting bits 10-9 of the Command register
to 01b for a 16-bit bus width.
Setup:
31 Ir ---: 15 :-- a J
ES:[ALT _MIX] <= O'-::-02"C"":X-:"HC""""'--::O-=-OO:C-X:CH:- ; FRGD_COLOR is color source
; BKGD_COLOR is color source
ES:[FRGD_COLOR] <= 00000004H ; foreground color index 4
ES:[BKGD_COLOR] <= OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTL] <= A080H ; selection of mix register is based on data from the CPU
ES:[ROPMIX] <= 01XXH ; mono pattern flag, XX = ROP code
ES:[PAT_FG_COLOR] <= 00000004H ; foreground color index 4
ES:[PAT_BG_COLOR] <= OOOOOOOOH ; background color index 0
ES:[RD_MASK] <= 00000001H ; bitplane 0 enabled for reading
Drawing Operation:
31 15 a
ES:[ALT_PAT]<=1 Patx Paty 1 ; set starting coordinates for pattern
31 15 a
ES:[ALT _STEP] <= 1 x1 y1 1 ; set destination starting coordinates
31 15 a
J
ES:[ALT_PCNT] <=1 WIDTH-1 1 HEIGHT-1 ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
CMD <= 11001011D0110011b ; ROPBLT (bits 15-13, 11), swap ON (bit 12).
; 16-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4),
; mUlti-pixel (bit 1)
COUNT (of image pixel data to transfer) = ((WIDTH + 15)/16)*HEIGHT words
PIX_TRANS <= IMAGEDATA; Output image data to Pixel Transfer register for COUNT words
ENHANCED MODE PROGRAMMING 5-43

S3 Vision968 Multimedia Accelerator
53 Incorporated
Notes
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred and the width of the transfer (B, 16 or 32 bits as specified by bits 10-9 of 9AEBH). Except for
the case where bits 10-S of SAEBH are 11 b, the number of pixels transferred per line must be an even
multiple of the transfer width. If this is not the case, the last write per line must be padded with one or
more dummy pixels to meet this requirement. For example, if the transfer width is B bits and nine
pixels are to be transferred per line, two bytes must be written per line, with the upper 7 bits of the
second byte padded. In general, the number of padding bits per line will vary from 0 to (n-1), where n
is the transfer width in bits.
With a transfer width of B bits, the number of byte writes required per line can be determined from the
formula n = (W+7)/B, with n being truncated to an integer if the result contains a fraction. Thus a 13-bit
pixel transfer requires (13+7)/B = 2.5 = 2 bytes. This is then multiplied by the height of the image (in
pixels) to determine the COUNT of bytes to be transferred. Similar procedures apply to every other_
combination of the variables affecting the COUNT. The formulas for all cases are given below, where
W is the width of the image and H is the height of the image, both in pixels.
B-bit transfers: COUNT = (W+7)/B * H bytes (SAEBH_10-S = OOb)
16-bit transfers: COUNT = (W+15)/16 * H words (SAEBH_10-S = 01b)
32-bit transfers: COUNT = (W+31 )/32 * H dwords (SAEBH_10-S = 10b)
New 32-bit transfers: COUNT = (((W+7)/B*H)+3)/4 dwords (SAEBH_10-S = 11b)
The differences between the two 32-bit transfer options are:
1. For SAEBH_10-S set to 10b, every line of the transfer must start with a fresh doubleword. In other
words, all unneeded bits in a doubleword transfer for a given line are discarded. After a rectan
gular image is transferred, the current drawing position is a the bottom left, meaning the next
rectangle, if drawn, will be below the previous rectangle.
2. For SAEBH_10-S set to 11 b, only bits from the end of the line width to the next byte boundary are
discarded. Data for the next line begins with the next byte. After a rectangular image is trans
ferred, the current drawing position is a the top right, meaning the next rectangle, if drawn,
will be to the right of the previous rectangle.
To write to a single plane, setthe foreground mixto 'logical one' (0002H), the background mixto 'logical
zero' (0001 H), and the Write Mask register (AAEBH) to select the desired (single) plane for updates.
5-44 ENHANCED MODE PROGRAMMING

fl·
S3 Vision968 Multimedia Accelerator
S3 Incorporated
5.4.3.19 Programmable Hardware Cursor
A programmable cursor is supported which is compatible with the Microsoft Windows (bit 4 of CR55
= 0) and X11 (bit 4 of CR55 = 1) cursor definitions. The cursor size is 64 pixels wide by 64 pixels high,
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
the Hardware Graphics Cursor Background Stack (CR4B) registers. Each ofthese is a stack of three 8-bit
registers. The stack pointers are reset to 0 by reading the Hardware Graphics Cursor Mode register
(CR45). The color value is then programmed by consecutive writes (low byte, second byte, third byte)
to the appropriate (foreground or background) register.
Enabling/Disabling the Cursor
The hardware cursor is disabled when a VGA-compatible mode is in use. It can be enabled or disabled
when in Enhanced mode (bit 0 of 4AE8H = 1), as follows.
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
and the top edge of the screen. Similarly, a partial cursor can be displayed atthe left edge of the screen
by setting X to 0 and the X offset register to OX (range from 0 to 63). This displays the right 64-0X
columns of the cursor image at the currently set X and the left edge of the screen. The following
pseudocode illustrates cursor positioning.
CR39 <=AOH ; Unlock System Control registers
CR46_10-8 <= MS 3 bits of X cursor position
CR47 _7-0 <= LS 8 bits of X cursor position
ENHANCED MODE PROGRAMMING 5-45

S3 Vision968 Multimedia Accelerator
S3 Incorporatad
CR49_7-0 <= LS S bits of Y cursor position
CR4E_5-0 <= Cursor Offset X position
CR4F _5-0 <= Cursor Offset Y position
CR4S_10-S <= MS 3 bits of Y cursor position
CR39 <= OOH ; Lock System Control registers
The cursor position is updated by the hardware once each frame. Therefore, the programmer should
ensure that the position is re-programmed no more than once for each vertical sync period.
Programming the Cursor Shape
The AND and the XOR cursor image bitmaps are 512 bytes each. These are stored in consecutive bytes
of off-screen display memory, 512 AND bytes followed by 512 XOR bytes. The starting location must
be on a 1024-byte boundary. This location is programmed into the Hardware Graphics Cursor Start
Address registers (CR4C and CR4D) as follows:
CR39 <= AOH ; Unlock System Control registers
CR4C_5-S <= MS 4 bits of the cursor storage start 1024-byte segment.
CR4D <= LS S bits of the cursor storage start 1024-byte segment
CR39 <= 0 ; Lock System Control registers
The value programmed is the 1024-byte segment of display memory at which the beginning of the
hardware cursor bit pattern is located. For example, for an SOOx600xS mode on a 1 MByte system,
there are 10241 K segments. Programming CR4C_11-Swith 3H and CR4D with FEH specifies the starting
location as the 1022nd (O-based) 1K segment. The cursor pattern is programmed (using linear
addressing) at FFSOOH offset from the base address of the frame buffer.
Note
If the cursor is not 64 bits by 64 bits, the given images should be padded to make the cursor image 64
bits by 64 bits. The padded area should be made transparent by padding the extra AND mask bits with
'1's and the extra XOR bits by 'O's.
5.5 RECOMMENDED READING
Graphics Programming for the 8514/A by Jake Richter and Bud Smith (M&T Publishing, Inc) provides
extensive explanations and examples for programming most of the bits in the S3 Enhanced Registers.
Although not released at the time this data book was printed, the 3rd edition of Programming Guide
to the EGA and VGA Cards by Richard F. Ferraro (Addison-Wesley Publishing Company, Inc) is
scheduled to include a section on programming for S3 accelerator chips.
5-46 ENHANCED MODE PROGRAMMING

S3 Vision968 Multimedia Accelerator
53 Incorporated
Section 6: Video Engine
This section describes the Video Engine provided  6-1. The input and output bit settings are for
by the Vision96B. The Video Engine registers are  BOBBH_22-20 and BOBBH_1B-16 respectively.
described in Section 2.
The Video Engine processes one pixel per MCLK
regardless of the pixel depth. Input and output
6.1  VIDEO ENGINE OVERVIEW  FIFOs allow burst/block transfers from and to
memory to improve throughput.
The Video Engine obtains pixel data either from
video memory or the CPU, operates on it and  New MMIO operation (bits 4-3 of CR53 set to 11 b)
then writes to display memory. Particular pixels  is required for Video Engine access. If big endian
in memory can be masked off from being up  addressing is required, bits 2-1 of CR53 control
| dated by the video data. The operations the Video  |     |     |     | byte swapping.  |     |     |     |     |
| -------------------------------------------------- | --- | --- | --- | --------------- | --- | --- | --- | --- |
Engine can perform are scaling (both horizontal
and vertical), color space conversion (YUV to  The Video Engine cannot be  used when the
RGB) and dithering (reduce color depth from 24  Vision96B is being operated in packed 24
bits/pixel to 16,  15 or B bits/pixel). The legal  bits/pixel mode (bits 5-4 of CR50 set to 10b). It
input/output combinations are shown in Table  does not take advantage of 1-cycle EDO memory
operation if this is specified (bits 3-2 of CR36 set
Table 6-1  Video Engine Input/Output Combinations
|        |        | Output  | 000     | 011     | 100  | 101  | 110     | 111     |
| ------ | ------ | ------- | ------- | ------- | ---- | ---- | ------- | ------- |
|        | Width  |         | 8       | 32      | 16   | 16   | 16      | 16      |
| Input  |        | Format  | RGB332  | RGB888  | VCI  | raw  | RGB555  | RGB565  |
VUV442
| 000  | 8   | RGB332  | S      | No   | No  | No  | No     | No     |
| ---- | --- | ------- | ------ | ---- | --- | --- | ------ | ------ |
|      |     |         |        |      | No  | No  |        |        |
| 011  | 32  | RGB888  | SID    | S    |     |     | SID    | SID    |
| 100  | 16  | VC/VUV  | S/C/D  | SIC  | S   | No  | S/C/D  | S/C/D  |
422
| 101  | 16  | raw     | No   | No  | No  | S   | No  | No  |
| ---- | --- | ------- | ---- | --- | --- | --- | --- | --- |
| 110  | 16  | RGB555  | SID  | S   | No  | No  | S   | S   |
| 111  | 16  | RGB565  | SID  | S   | No  | No  | S   | S   |
S = Scaling
C = Color Space Conversion
D = Dithering
VIDEO ENGINE 6-1

S3 Vision968 Multimedia Accelerator
53 Incorporated
to 11 b. Instead, it will use standard fast page or stretching. The reverse is true for shrinking the
EDO cycles. image.
The Video Engine and the Graphics Engine must If filtering is required, it is enabled via bit 31 of
not be in use at the same time. To ensure this, BOBBH. The type of filtering is specified via bits
the Video Engine NOP register (BOBOH) must be 15-14 of BOBCH.
written to after all Video Engine data/commands
have been written. Similarly, a Graphics Engine The output data format is specified via bits 1B-16
NOP must be executed after a Graphics Engine of BOBBH. Ifthe output is B bits/pixel RGB, setting
access before the Video Engine can be written to bit 2B of BOBBH to 1 palettizes the data, i.e., each
again. byte is a color look up table (LUT) address. This
output protects the upper and lower 10 LUT slots,
which are used for system colors. Therefore, it
6.2 SCALING
maps certain adjacent pairs of data values to the
same LUT address so that all 256 values generate
Bit 31 of BOBCH is cleared to 0 to specify a stretch a non-protected color.
and set to 1 to specify a shrink. Bit 30 of BOBCH is
cleared to 0 to specify display memory as the The output can be cropped by specifying a start
data source and set to 1 to specify the CPU as the value and length in B094H. Alternately, the output
data source. If display memory is the data source, can be masked against a mask pattern stored in
the starting address for the data is specified in main (system) memory. This is enabled by set
B09BH. The amount of stretch or shrink is speci ting bit 26 of BOBBH to 1. The mask contains one
fied by programming source and destination bitfor each pixel in on-screen memory. The mask
steps in B090H and also programming the follow data must be sent by the CPU just prior to proc
ing DDA parameters. essing of the relevant screen pixels.
The internal digital differential analyzer (DDA) is If bit 29 of BOBCH is cleared to 0, a bit value of 1
programmed by specifying the DDA accumulator in the mask allows the video to overwrite the
initial value in bits 11-0 of BOBBH and the K1 and graphics pixel and a value of 0 protects the graph
K2 constants via bits 10-0 and 26-16 of BOBCH. ics pixel from being overwritten. If this bit is set
to 1, the effect is reversed.
The input data format is specified via bits 22-20
of BOBBH. If 100b is specified, bit 19 of BOBBH is
6.3 COLOR SPACE CONVERSION
cleared to 0 to specify YCbCr and set to 1 to
specify YUV.
Either YUV or YCbCr 4-4-2 input can be converted
A single pass through the Video Engine produces to RGB format. YUVNCbCr input is selected by
a one-dimensional stretch or shrink (horizontal or setting bits 22-20 of BOBBH to 100b. YUV orYCbCr
vertical). This can be written directly to on-screen is selected via bit 19 of BOBBH (YUV = 1; YCbCr =
memory. A two-dimensional scaling requires 0). The output data format is selected via bits
two passes. The first pass writes the one-dimen 1B-16 of BOBBH. This can be RGB-B (=OOOb), RGB-
sionally scaled data to off-screen memory. The 15 (=110b), RGB-16 (=111b) or RGB-32 (=011b).
second pass BitBLT s the off-screen image to on
screen memory while performing the scaling in YUV/YCbCr data can be scaled before it is con
the other dimension. Both the amount of scaling verted. If two pass scaling is being performed,
and the dimension (horizontal or vertical) are color space conversion should be done during
controlled by the step constants programmed the horizontal pass.
into B090H.
6.4 DITHERING
Vertical scaling requires much more bandwidth
than horizontal scaling. Therefore, vertical scal
ing should be done during the first pass and Ifthe bits/pixel (color depth) ofthe data in display
horizontal scaling during the second pass for memory is less than the input data (or the gener-
6-2 VIDEO ENGINE

S3 Vision968 Multimedia Accelerator
53 Incorporated
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
Bit 31 of 809CH is read-only. When set to 1, it
indicates the Video Engine is in use.
VIDEO ENGINE 6-3

II·
S3 Vision968 Multimedia Accelerator
S3 Incorporatad

I
S3 Vision968 Multimedia Accelerator
S3 Incorporated I
Appendix A: Listing of Raster Operations
The Vision968 supports all 256 triadic raster op The boolean operators used as as follows:
erations (ROPs) for BitBlT s as defined by
Microsoft for Windows. The coding for these is o = bitwise OR
found on the following pages.
x = bitwise EXCLUSIVE OR
The HEX value in the first column is the ROP
code. This value must be programmed into bits a = bitwise AND
7-0 of D2E8H atthe time that a ROPBlT command
is executed. n = bitwise NOT (inverse)
The effect of the ROP is shown in reverse Polish For example. ROP 16H is PSDPSanaxx. The pat
notation in the second column. This is interpreted tern is first ANDed with the source
as follows: [PSD(PaS)naxx]. The result is inverted and then
ANDed with the destination [PS((Da(notPaS))xx.
S = Source bitmap This result is EXCLUSIVE ORed with the source.
Finally. the result of this is EXCLUSIVE ORed with
P = Pattern the pattern.
D = Destination bitmap Programming using ROPBlT s is explained in En
hanced Mode Programming section.
The source bitmap can be either the CPU or the
current screen. as selected via bits 6-5 of either
A2E8H or A6E8H. A CPU source can be either
monochrome or color. A screen source is always
color.
The pattern. if present. is found at the off-screen
memory location specified by EAE8H and
EAEAH. The pattern may be either monochrome
or color. as specified by bit 8 of D2E8H. If the
pattern is monochrome. its background color is
specified by E6E8H and its foreground color by
EEE8H.
The destination bitmap is always the screen. It is
always color (as opposed to monochrome).
LISTING OF RASTER OPERATIONS A-1

53 Vision968 Multimedia Accelerator
S3 Incorporated
I HEX
| HEX  | In Reverse Polish  |     |     | In Reverse Polish  |     |     |
| ---- | ------------------ | --- | --- | ------------------ | --- | --- |
| 00   | 0                  |     | 2C  | SPDSoax            |     |     |
| 01   | DPSoon             |     | 20  | PSDnox             |     |     |
|      |                    |     | 2E  | PSDPxox            |     |     |
| 02   | DPSona             |     | i   |                    |     |     |
|      |                    |     | 2F  | PSDnoan            |     |     |
| 03   | PSon               |     |     |                    |     |     |
| 04   | SDPona             |     | 30  | PSna               |     |     |
i
| 05  | DPon     |     | 31  | SDPnaon  |     |     |
| --- | -------- | --- | --- | -------- | --- | --- |
| 06  | PDSxnon  |     | 32  | SDPSoox  |     |     |
|     |          |     | 33  | Sn       |     |     |
| 07  | PDSaon   |     |     |          |     |     |
|     |          |     | 34  | SPDSaox  |     |     |
| 08  | SDPnaa   |     |     |          |     |     |
I
| 09    | PDSxon   |     | 35  | SPDSxnox  |     |     |
| ----- | -------- | --- | --- | --------- | --- | --- |
| I OA  | DPna     |     | 36  | SDPox     |     |     |
| 08    | PSDnaon  |     | 37  | SDPoan    |     |     |
| OC    | SPna     |     | 38  | PSDPoax   |     |     |
|       |          |     | 39  | SPDnox    |     |     |
| 00    | PDSnaon  |     |     |           |     |     |
|       |          |     | 3A  | SPDSxox   |     |     |
| OE    | PDSonon  |     |     |           |     | I   |
| OF    | Pn       |     | 38  | SPDnoan   |     |     |
| 10    | PDSona   |     | 3C  | PSx       |     |     |
| 11    | DSon     |     | 3D  | SPDSonox  |     |     |
|       |          |     | 3E  | SPDSnaox  |     |     |
| 12    | SDPxnon  |     |     |           |     |     |
|       |          |     | 3F  | PSan      |     |     |
| 13    | SDPaon   |     |     |           |     |     |
I 14
|     | DPSxnon  |     | 40    | PSDnaa  |     |     |
| --- | -------- | --- | ----- | ------- | --- | --- |
| r   |          |     | I 41  |         |     |     |
| 15  | DPSaon   |     |       | DPSxon  |     |     |
!
| I  16  | PSDPSanaxx  |     | 42     | SDxPDxa    |     |     |
| ------ | ----------- | --- | ------ | ---------- | --- | --- |
| 1 17   |             |     | I  43  | SPDSanaxn  |     | I   |
SSPxDSxaxn
I
| 18    | SPxPDxa    |     | 44  | SDna     |     |     |
| ----- | ---------- | --- | --- | -------- | --- | --- |
| 1 19  | SDPSanaxn  |     | 45  | DPSnaon  |     |     |
j
| 1A     | PDSPaox   |     | 46    | DSPDaox   |     | .   |
| ------ | --------- | --- | ----- | --------- | --- | --- |
| ~  18  | SDPSxaxn  |     | I 47  | PSDPxaxn  |     |     |
I
| 1C  | PSDPaox  |     | 48  | SDPxa  |     |     |
| --- | -------- | --- | --- | ------ | --- | --- |
I
I
| 11 DE  | DSPDxaxn  |     | II  449A  | PDSPDaoxxn  |     |     |
| ------ | --------- | --- | --------- | ----------- | --- | --- |
|        | PDSox.    |     | .         | DPSDoax     |     | 11  |
| ~~     | ~~~~::    |     | I~  ~     | ~~~:        |     |     |
I
| ~223'  | ~~:a"  |     | .   | !~~S;O'"  |     | I   |
| ------ | ------ | --- | --- | --------- | --- | --- |
| II'    |        |     | 4E  |           |     | I   |
1 4F
| :   | SPDnaon  |     |     | PDSnoan  |     |     |
| --- | -------- | --- | --- | -------- | --- | --- |
~~~:----------~~~~~~D~pS~a~~:X~n----------~I!  ;1,~~~~----------p~DD~sn~p~~a-o-n------------~1111
Jr.
i
| 26  | SDPSaox  |     | .  52  | DPSDaox  |     | .   |
| --- | -------- | --- | ------ | -------- | --- | --- |
rl~2=7~--------~S~D~p~s~xn~o~x----------~1  ~i~5~3----------~S~P~D~s~xax~n----------~
J
| !E        |                                |      | IE            |         |       |     |
| --------- | ------------------------------ | ---- | ------------- | ------- | ----- | --- |
|           | ~;aao,,"                       |      |               |   g~~   |       |     |
| L  .~.~.  | ~~~ SSPxPr:>~x.a ,xn_.~._~.~~  |      | ~             | ~_      | .~_~  |     |
| 28_ _     | __                             | ...  | ___  1 57 __  | DPSoan  |       |     |
A-2  LISTING OF RASTER OPERATIONS

r-~  .
S3 Vision968 Multimedia Accelerator
S3 Incorporated
| HEX  |                    | HEX  |                    |
| ---- | ------------------ | ---- | ------------------ |
|      | In Reverse Polish  |      | In Reverse Polish  |
| 58   | PDSPoax            | 84   | SDPxna             |
| 59   | DPSnox             | 85   | PDSPnoaxn          |
| 5A   | DPx                | 86   | DSPDSoaxx          |
| 58   | DPSDonox           | 87   | PDSaxn             |
88
| 5C    | DPSDxox     |     | DSa        |
| ----- | ----------- | --- | ---------- |
| 5D    | DPSnoan     | 89  | SDPSnaoxn  |
| 5E    | DPSDnaox    | 8A  | DSPnoa     |
| 5F    | DPan        | 88  | DSPDxoxn   |
| 60    | PDSxa       | 8C  | SDPnoa     |
| i 61  | DSPDSaoxxn  | 8D  | SDPSxoxn   |
62
|     | DSPDoax  | 8E  | SSDxPDxax  |
| --- | -------- | --- | ---------- |
| 63  | SDPnox   | 8F  | PDSanan    |
| 64  | SDPSoax  | 90  | PDSxna     |
| 65  | DSPnox   | 91  | SDPSnoaxn  |
| 66  | DSx      | 92  | DPSDPoaxx  |
| 67  |          | 93  | SPDaxn     |
SDPSonox
| 68  | DSPDSonoxxn  | I 94  | PSDPSoaxx   |
| --- | ------------ | ----- | ----------- |
| 69  | PDSxxn       | 95    | DPSaxn      |
| 6A  | DPSax        | 96    | DPSxx       |
| 68  | PSDPSoaxxn   | 97    | PSDPSonoxx  |
| 6C  | SDPax        | 98    | SDPSonoxn   |
99
| 6D  | PDSPDoaxxn  |     | DSxn      |
| --- | ----------- | --- | --------- |
| 6E  | SDPSnoax    | 9A  | DPSnax    |
| 6F  | PDSxnan     | 98  | SDPSoaxn  |
| 70  | PDSana      | 9C  | SPDnax    |
| 71  | SSDxPDxaxn  | 9D  | DSPDoaxn  |
72
|     | SDPSxox     | 9E    | DSPDSaoxx  |
| --- | ----------- | ----- | ---------- |
| 73  |             | ! 9F  |            |
| i   | SDPnoan     |       | PDSxan     |
| 74  | DSPDxox     | AO    | DPa        |
| 75  | DSPnoan     | A1    | PDSPnaoxn  |
| 76  | SDPSnaox    | A2    | DPSnoa     |
| 77  | DSan        | A3    | DPSDxoxn   |
| 78  | PDSax       | A4    | PDSPonoxn  |
| 79  | DSPDSoaxxn  |       | PDxn       |
| 7A  | DPSDnoax    |       | DSPnax     |
| 78  | SDPxnan     |       | PDSPoaxn   |
| 7C  | SPDSnoax    |       | DPSoa      |
| 7D  | DPSxnan     |       | DPSoxn     |
| 7E  | SPxDSxo     |       | D          |
I
| 7F  | DPSaan  | A8  | DPSono   |
| --- | ------- | --- | -------- |
| 80  | DPSaa   | AC  | SPDSxax  |
!
| 81  | SPxDSxon  | AD  | DPSDaoxn  |
| --- | --------- | --- | --------- |
| 82  |           |     | DSPnao    |
DPSxna
| 83  | SPDSnoaxn  |     | DPno  |
| --- | ---------- | --- | ----- |
LISTING OF RASTER OPERATIONS  A-3

II·
S3 Vision968 Multimedia Accelerator
53 Incorporated
HEX
| HEX  | In Reverse Polish  |     | In Reverse Polish  |
| ---- | ------------------ | --- | ------------------ |
| BO   | PDSnoa             | DC  | SPDnao             |
| B1   | PDSPxoxn           | DD  | SDno               |
| B2   | SSPxDSxox          | DE  | SDPxo              |
| B3   | SDPanan            | DF  | SDPano             |
| B4   | PSDnax             | EO  | PDSoa              |
| B5   | DPSDoaxn           | E1  | PDSoxn             |
| B6   | DPSDPaoxx          | E2  | DSPDxax            |
| B7   | SDPxan             | E3  | PSDPaoxn           |
| I    |                    | E4  | SDPSxax            |
| B8   | PSDPxax            |     |                    |
| B9   | DSPDaoxn           | E5  | PDSPaoxn           |
| BA   | DPSnao             | E6  | SDPSanax           |
| BB   | DSno               | E7  | SPxPDxan           |
| BC   | SPDSanax           | E8  | SSPxDSxax          |
| BD   | SDxPDxan           | E9  | DSPDSanaxxn        |
| BE   | DPSxo              | EA  | DPSao              |
| BF   | DPSano             | EB  | DPSxno             |
| CO   | PSa                | EC  | SDPao              |
!
| C1  | SPDSnaoxn  | ED  | SDPxno  |
| --- | ---------- | --- | ------- |
| C2  | SPDSonoxn  | EE  | DSo     |
|     |            | EF  | SDPnoo  |
| C3  | PSxn       |     |         |
| C4  | SPDnoa     | FO  | P       |
| C5  | SPDSxoxn   | F1  | PDSono  |
| C6  | SDPnax     | F2  | PDSnao  |
| C7  | PSDPoaxn   | F3  | PSno    |
|     | SDPoa      | F4  | PSDnao  |
C8
| C9  | SPDoxn    | F5  | PDno    |
| --- | --------- | --- | ------- |
| CA  | DPSDxax   | F6  | PDSxo   |
| CB  | SPDSaoxn  | F7  | PDSano  |
| CC  | S         | F8  | PDSao   |
| CD  | SDPono    | F9  | PDSxno  |
|     |           | FA  | DPo     |
| CE  | SDPnao    |     |         |
| CF  | SPno      | FB  | DPSnoo  |
| DO  | PSDnoa    | FC  | PSo     |
| D1  | PSDPxoxn  | FD  | PSDnoo  |
| D2  | PDSnax    | FE  | DPSoo   |
| D3  | SPDSoaxn  | FF  | 1       |
_.c"cJ
'c_,_ _ "-u,-u~~'''''"''''''':'""<'~','w'<_,,,,~
| D4  | SSPxPDxax  |     |     |
| --- | ---------- | --- | --- |
| D5  | DPSanan    |     |     |
| D6  | PSDPSaoxx  |     |     |
| D7  | DPSxan     |     |     |
| D8  | PDSPxax    |     |     |
| D9  | SDPSaoxn   |     |     |
| DA  | DPSDanax   |     |     |
| DB  | SPxDSxan   |     |     |
A-4  LISTING OF RASTER OPERATIONS

••
r S3 Vision968 Multimedia Accelerator
S3 Incorporated

S3 Vision968 Multimedia Accelerator
S3 Incorporated
S3lncorporated, 2770 San Tomas Expressway, Santa Clara, CA 95051-0968 Tel: 408-980-5400, Fax: 408-980-5444
Printed in USA DB016-A

S3 Incorporated
2770 San Tomas Expwy.
Santa Clara, CA 95051-0968
Tel: (408) 980-5400
Fax: (408) 980-5444
Printed in U.S.A. on recycled paper
DB016-A
