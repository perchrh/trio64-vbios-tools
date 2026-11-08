Vision864 Graphics Accelerator
S3 Incorporated
Vision864
Graphics
Accelerator
October 1994
S3 Incorporated
St
2770 San Tomas Expressway
~anta Clara, 95051-0968
-'6
~~o
.. 9005049 0000731 640 .. a
\

••
r Vision864 Graphics Accelerator
53 Incorporated
NOTATIONAL CONVENTIONS
The following notational conventions are used in this data book:
Signal names are shown in all uppercase letters. For example, XO.
A bar over a signal name indicates an active low signal. For example, OE.
n-m indicates a bit field from bit n to bit m. For example, 7-0 specifies bits 7 through 0, inclusive.
n:m indicates a signal (pin) range from n tom. For example 0[7:01 specifies data Imes 7 through 0, inclusive
Use of a trailing letter H indicates a hexadecimal number. For example, 7AH is a hexadecimal number.
Use of a trailing letter b indicates a binary number. For example, 010b is a binary number.
When numerical modifiers such as Kor Mare used, they refer to binary rather than decimal form. Thus, for example, 1 KByte would be
equivalent to 1024, not 1,000 bytes.
NOTICES
©Copyright 1994 S3 Incorporated. All rights reserved. No part of this publication may be reproduced, stored in a retrieval system, or
transmitted on any form or by any means, electronic, mechanical, photocopying, or otherwise, without the pnor written consent of S3
Incorporated, 2770 San Tomas Expwy., Santa Clara CA 95051-0968. The S3 Corporate Logo, S3 801, S3 805, S3 PS805, S3 805i, S3 928,
S3 928PCI, Vision64, Vision864, Vision866, Vision868, Vision964, Vision968, VisionNA. Trio32, Trio64, Galileo and SDAC are trademarks
of S3 Incorporated and S3 and True Acceleration are registered trademarks of S3 Incorporated. Other trademarks referenced in this
document are owned by their respective companies. The material in this document is for information only and is subject to change
without notice. S3 Incorporated reserves the right to make changes in the product design without reservation and without notice to its
users.
Additional information may be obtained from:
S3 Incorporated, Literature Department, 2770 San Tomas Expressway, Santa Clara, CA 95051-0968.
.
Telephone: 408-980-5400, Fax: 408-980-5444
..,
.. 9005049 0000732 587 .. r i

••
r
Vision864 Graphics Accelerator
53 Incorporated
Table of Contents
Section 1: Introduction ...... 1-1 6.2 VL-BUS INTERFACE . . . . . . . . 6-5
1.1 BUS INTERFACES ......... 1-1 6.2.1 VL-Bus Cycles . . . . . . . . . . 6-5
1.2 DRAM/RAMDAC SUPPORT . . . . 1-1 6.2.2 SRDY Generation . . . . . . . . 6-6
1.3 RESOLUTIONS SUPPORTED ... 1-1 6.3 LOCAL BUS CLOCKING . 6-6
1.4 ADVANCED ARCHITECTURE . . . 1-2
1.5 MULTIMEDIA SUPPORT ...... 1-2 Section 7: Display Memory . 7-1
1.6 GREEN PC SUPPORT. . . . . . . . 1-2 7.1 DISPLAY MEMORY
1.7 SOFTWARE SUPPORT . . . . . . . 1-2 CONFIGURATIONS ......... 7-1
7.2 DISPLAY MEMORY REFRESH ... 7-4
Section 2: Mechanical Data . . .. 2-1 7.3 DISPLAY MEMORY FUNCTIONAL
2.1 THERMAL SPECIFICATIONS . . . . 2-1 TIMING ............... 7-5
2.2 MECHANICAL DIMENSIONS . 2-1 7.4 DISPLAY MEMORY ACCESS
CONTROL . . . . . . . . . . . . . . 7-8
7.5 SHARED FRAME BUFFER 7-9
Section 3: Pins . . . . . . . . . 3-1
3.1 PINOUT DIAGRAMS ........ 3-1
Section 8: Miscellaneous
3.2 PIN DESCRIPTIONS . . . . . . . . 3-4
3.3 PIN LISTS . . . . . . . . . . . . . . 3-9 Functions . . . . . . . . . . . . . . 8-1
8.1 VIDEO BIOS ROM INTERFACE ... 8-1
8.1.1 Disabling BIOS ROM Accesses 8-1
Section 4: Electrical Data ..... 4-1
8.1.2 BIOS ROM Hardware Interface . 8-2
4.1 MAXIMUM RATINGS . . . . . . . 4-1
8.1.3 BIOS ROM Read Functional
4.2 DC SPECIFICATIONS . . . . . . . 4-1
Timing .............. 8-2
4.3 AC SPECIFICATIONS . . . . . . . 4-2
8.1.4 BIOS ROM Address Mapping 8-4
4.3.1 Clock Timing . . . . . . . . . . 4-3
8.2 RAMDAC/DISPLAY INTERFACE .. 8-4
4.3.2 Input/Output Timing . . . . . . 4-4
8.2.1 RAMDAC Hardware Interface . 8-4
4.4 OUTPUT BUFFER MODEL . . . . . 4-7
8.2.2 RAMDAC Functional Timing . . 8-4
4.5 POWER ISOLATION
8.2.3 RAMDAC Color Mode . . . . . 8-4
CONSIDERATIONS . . . . . . . . . 4-8
8.2.4 VCLK Control . . . . . . . . . . 8-5
8.2.5 Generating Register Select
Section 5: Reset and Initialization 5-1 Signals . . . . . . . . . . . . . 8-5
5.1 CONFIGURATION STRAPPING .. 5-1 8.2.6 Green PC Support . . . . . . . 8-6
5.2 GENERAL DATA BUS AT RESET . 5-1 8.2.7 SENSE Input Utilization .... 8-6
5.3 PREVENTING BUS LOADS 8.2.8 RAMDAC Write Snooping
DURING RESET . . . . . . . . . . . 5-1 (VL-Bus) . . . . . . . . . . . . . 8-6
5.4 TEST MODE . . . . . . . . . . . . . 5-3 8.2.9 Disabling RAMDAC Register
Access (PCI) . . . . . . . . . . . 8-6
8.3 CLOCK GENERATOR INTERFACE . 8-7
Section 6: System Bus Interfaces . 6-1
8.3.1 Clock Generator Hardware
6.1 PCI BUS INTERFACE . . . . . . . . 6-1
Interface ............. 8-7
6.1.1 PCI CONFIGURATION . . 6-1
6.1.2 PCI Bus Cycles . . . . . . . . . 6-1
.. 9005049 0000733 413 ..
iii

Vision864 Graphics Accelerator
53 Incorporated
8.3.2  Clock Generator Access  11.3.3.5 Image Transfer Across the
Functional Timing  . . . . . . .  8-7  Plane  ............ 11-13
8.3.3  DCLK Selection . . . . . . . . .  8-7  11.3.3.6 BitBLTThrough the Plane. 11-15
8.4  GENERAL INPUT PORT  . . . . . .  8-8  11.3.3.7 BitBLTAcrossthePlane .. 11-16
8.5  GENERAL OUTPUT PORT  . . . . .  8-8  11.3.3.8 PatBL T-Pattern Fill
8.6  GENLOCKING. . . . . . . . . . . .  8-9  Through the Plane ..... 11-18
11.3.3.9 PatBLT-Pattern Fill Across
Section 9: Software Setup  .... 9-1  the Plane .......... 11-19
|     |     |     | 11.3.3.10 Short Stroke Vectors  |     | ... 11-20  |
| --- | --- | --- | ------------------------------- | --- | ---------- |
9.1  CHIP WAKEUP  . . . . . . . . . . .  9-1  11.3.3.11 Programmable Hardware
| 9.2  REGISTER ACCESS . . . . . . . . .  |                                   | 9-2       |                            |                              |            |
| --------------------------------------- | --------------------------------- | --------- | -------------------------- | ---------------------------- | ---------- |
|                                         |                                   |           |                            | Cursor  . . . . . . . . . .  | 11-21      |
| 9.2.1                                   | Unlocking the S3 Registers        | . .  9-2  |                            |                              |            |
|                                         |                                   |           | 11.4  RECOMMENDED READING  |                              | ... 11-22  |
| 9.2.2                                   | Locking the S3 Registers . . . .  | 9-3       |                            |                              |            |
9.2.3  Unlocking/Locking Other
Registers  . . . . . . . . . . . .  9-3  Section 12: CGA-Compatible
9.3  TESTING FOR THE PRESENCE OF  Register Descriptions  ...... 12-1
| A Vision864 CHIP . . . . . . . . . .  |     | 9-4        |     |     |     |
| ------------------------------------- | --- | ---------- | --- | --- | --- |
| 9.4  GRAPHICS MODE SETUP              |     | ..... 9-4  |     |     |     |
9.4.1  Backward Compatibility Modes  Section 13: MDA- and HGC
Setup  . . . . . . . . . . . . . .  9-4  Compatible Register Descriptions 13-1
| 9.4.2  | VGA Mode Setup . . . . . . . .  | 9-5  |     |     |     |
| ------ | ------------------------------- | ---- | --- | --- | --- |
| 9.4.3  | S3 Enhanced Mode Setup . . .    | 9-6  |     |     |     |
Section 14: VGA Standard
9.4.4  Memory Mapping of Enhanced
|     |                                   |      | Register Descriptions    |     | .  . .  14-1       |
| --- | --------------------------------- | ---- | ------------------------ | --- | ------------------ |
|     | Mode Registers . . . . . . . . .  | 9-8  |                          |     |                    |
|     |                                   |      | 14.1  GENERAL REGISTERS  |     | . . . . . .  14-1  |
9.4.5  Hardware Graphics Cursor
Setup  . . . . . . . . . . . . .  9-8  14.2  SEQUENCER REGISTERS  . . . .  14-4
|     |     |     | 14.3  CRT CONTROLLER REGISTERS  |     | . 14-10  |
| --- | --- | --- | ------------------------------- | --- | -------- |
14.4  GRAPHICS CONTROLLER
Section 1O : VGA/Backward
|                        |     |           | REGISTERS                   | . . . . . . . . . .  | 14-25  |
| ---------------------- | --- | --------- | --------------------------- | -------------------- | ------ |
| Compatibility Support  |     | ... 10-1  | 14.5  ATTRIBUTE CONTROLLER  |                      |        |
10.1  VGA COMPATIBILITY  ....... 10-1  REGISTERS  . . . . . . . . . .  14-32
10.2  VESA SUPER VGA SUPPORT  ... 10-3  14.6  SETUP REGISTERS . . . . . .  14-38
10.3  BACKWARD COMPATIBILITY  14.7  RAMDAC REGISTERS  ...... 14-40
SUPPORT .............. 10-3
Section 15: S3 VGA Register
Section 11: Enhanced Mode
|                                |      |                           | Descriptions  | .  . .  . .  | . .  .  .  .  15-1  |
| ------------------------------ | ---- | ------------------------- | ------------- | ------------ | ------------------- |
| Programming                    | . .  | . .  . .  . .  . .  11-1  |               |              |                     |
| 11.1  DIRECT BITMAP ACCESSING- |      |                           |               |              |                     |
Section 16: System Control
| LINEAR ADDRESSING                |     | ....... 11-1     |                        |     |                   |
| -------------------------------- | --- | ---------------- | ---------------------- | --- | ----------------- |
|                                  |     |                  | Register Descriptions  |     | .  .  .  .  16-1  |
| 11.2  BITMAP ACCESS THROUGH THE  |     |                  |                        |     |                   |
| GRAPHICS ENGINE                  |     | ........ 11-2    |                        |     |                   |
| 11.3  PROGRAMMING                |     | .......... 11-4  |                        |     |                   |
Section 17: System Extension
| 11.3.1  | Notational Conventions  | .... 11-4  |                        |     |              |
| ------- | ----------------------- | ---------- | ---------------------- | --- | ------------ |
|         |                         |            | Register Descriptions  |     | ...... 17-1  |
11.3.2  Initial Setup ........... 11-5
11.3.3  Programming Examples .... 11-5
11.3.3.1 Solid Line  .......... 11-7  Section 18: Enhanced Commands
11.3.3.2 Textured Line  ........ 11-8  Register Descriptions  ...... 18-1
| 11.3.3.3 Rectangle  |     | ......... 11-10  |     |     |     |
| ------------------- | --- | ---------------- | --- | --- | --- |
11.3.3.4 Image Transfer Through the
Plane ............ 11-11
| .. 9005049  | 0000734  | 35T  ..  |     |     |     |
| ----------- | -------- | -------- | --- | --- | --- |
iv

Vision864 Graphics Accelerator
53 Incorporated
Section 19: PCI Register
| Descriptions                     | . . . . . .  |                            | 19-1      |
| -------------------------------- | ------------ | -------------------------- | --------- |
| Appendix A: Register Reference   |              |                            | A-1       |
| A.1  CGA-COMPATIBLE REGISTERS    |              |                            | . .  A-2  |
| A.2  MD-AND HGC-COMPATIBLE       |              |                            |           |
| REGISTERS                        |              | . . . . . . . . . . . . .  | A-3       |
| A.3  VGA REGISTERS               |              | . . . . . . . . . .        | A-4       |
| A.4  S3 VGA REGISTERS            |              | . . . . . . .              | A-12      |
| A.5  SYSTEM CONTROL REGISTERS    |              |                            | A-14      |
| A.6  SYSTEM EXTENSION REGISTERS  |              |                            | A-16      |
| A.7  ENHANCED COMMANDS           |              |                            |           |
| REGISTERS                        |              | . . . . . . . . . . . .    | A-20      |
| A.8  PCI CONFIGURATION SPACE     |              |                            |           |
| REGISTERS                        |              | . . . . . . . . . . . .    | A-24      |
| Index  ................ 1-1      |              |                            |           |
| .. 9005049                       | 0000735      | 296                        | ..        |
v

Vision864 Graphics Accelerator
53 Incorporated
List of Figures
me
| #   | Title  |     | Page  #  |     | ~~  |
| --- | ------ | --- | -------- | --- | --- |
1-1  PCI Bus System Block Diagram  1-2  8-2  BIOS ROM VL-Bus Configuration
2-1  208-pin PQFP Mechanical  Interface . . . . . .  . . . .  8-2
|     | Dimensions ......... .  |     | 2-2  8-3  | BIOS ROM Read Functional  |     |
| --- | ----------------------- | --- | --------- | ------------------------- | --- |
3-1  PCI Bus Configuration Pinout  3-2  Timing -PCI  . . . . . . .  8-3
3-2  VESA Local Bus Configuration  8-4  RAMDAC Interface  . . . .  8-4
|     | Pinout ......... .  |     | 3-3  8-5  | RAMDAC Access Functional  |     |
| --- | ------------------- | --- | --------- | ------------------------- | --- |
4-1  Clock Waveform Timing  4-3  Timing . . . . . . . . . .  8-5
4-2  Input Timing  .... .  4-4  8-6  VCLK Selection  . . . . . . .  8-6
4-3  Output Timing  .... .  4-5  8-7  General Data Bus Interfaces  8-7
4-4  Reset Timing  .... .  4-7  General Input Port Functional
8-8
4-5  First Order Output Buffer Model .  4-8  Timing . . . . . . . . . . . .  8-8
4-6  Power Pin Isolation Detail  4-8  8-9  General Output Port Functional
4-7  Power Pin Connection  Timing . . . . . . . . .  . . . .  8-9
Requirements ..... .  4-9  8-10  Genlocking Master Sync Timing .  8-9
6-1  Basic PCI Read Cycle ..  6-2  8-11  Genlocking Timing Adjustments  8-10
6-2  Basic PCI Write Cycle ...  6-2  11-1  Pixel Update Flowchart . . . .  11-3
| 6-3         | PCI Disconnect Example A .         |          | 6-3     |     |     |
| ----------- | ---------------------------------- | -------- | ------- | --- | --- |
| 6-4         | PCI Disconnect Example B .         |          | 6-3     |     |     |
| 6-5         | PCI Configuration Write Cycle      |          | 6-4     |     |     |
| 6-6         | PCI Configuration Write Cycle      |          | 6-4     |     |     |
| 6-7         | Read Parity Operation              |          | 6-5     |     |     |
| 6-8         | VL-Bus Interface                   | ..       | 6-6     |     |     |
| 6-9         | 1X Clock Generation                |          | 6-6     |     |     |
| 6-10        | VL-Bus Read Cycle                  |          | 6-7     |     |     |
| 6-11        | 1 Wait-state VL-Bus Write Cycle .  |          | 6-8     |     |     |
| 7-1         | 2-MByte DRAM Configuration         |          | 7-2     |     |     |
| 7-2         | 4-MByte DRAM Configuration         |          | 7-3     |     |     |
| 7-3         | 1-MByte Dual-WE DRAM               |          |         |     |     |
|             | Configuration ........ .           |          | 7-4     |     |     |
| 7-4         | Fast Page Mode Read Cycle          |          | 7-5     |     |     |
| 7-5         | Fast Page Mode Write Cycle .       |          | 7-6     |     |     |
| 7-6         | EDO Mode Read Cycle                | ....     | 7-7     |     |     |
| 7-7         | Display Memory Access Sources      |          | 7-8     |     |     |
| 7-8         | Shared Frame Buffer Protocol       |          |         |     |     |
|             | Timing ........... .               |          | . 7-10  |     |     |
| 8-1         | BIOS ROM PCI Configuration         |          |         |     |     |
|             | Interface .......... .             |          | 8-1     |     |     |
| .. 9005049  | 0000736                            | 122  ..  |         |     |     |
vi

••
r
Vision864 Graphics Accelerator
53 Incorporated
List of Tables
| #   | Title  |     | Page  #  | Title  | Page  |
| --- | ------ | --- | -------- | ------ | ----- |
1-1  Video Resolutions Supported  1-1  A-4  S3 VGA Registers  A-12
3-1  Vision864 Pin Descriptions .  3-4  A-5  System Control Registers  .  A-14
3-2  Alphabetical Pin Listing  ..  3-9  A-6  System Extension Registers  A-16
3-3  Numerical Pin Listing ....  . 3-11  A-7  Enhanced Commands Registers  A-20
4-1  Absolute Maximum Ratings  4-1  A-8  PCI Configuration Space
4-2  DC Specifications ......  4-1  Registers ............. A-24
..
| 4-3  | Clock Waveform Timing  |     | 4-3  |     |     |
| ---- | ---------------------- | --- | ---- | --- | --- |
4-4
| 4-4  | SCLK-Referenced Input Timing   |     |         |     |     |
| ---- | ------------------------------ | --- | ------- | --- | --- |
| 4-5  | SCLK-Referenced Output Timing  |     | 4-5     |     |     |
| 4-6  | MCLK-Referenced Input Timing   |     | .  4-6  |     |     |
| 4-7  | MCLK-Referenced Output Timing  |     | 4-6     |     |     |
| 4-8  | DCLK-Referenced Output Timing  |     | 4-6     |     |     |
| 4-9  | Fast Page Mode Memory Input    |     |         |     |     |
Timing ............... 4-6
........... 4-7
| 4-10  | Reset Timing                          |     |     |     |     |
| ----- | ------------------------------------- | --- | --- | --- | --- |
| 5-1   | Definition of PD[23:0) at the Rising  |     |     |     |     |
Edge of the Reset Signal ..... 5-2
| 5-2  | Signals Tri-Stated by Test Mode  |     | 5-3  |     |     |
| ---- | -------------------------------- | --- | ---- | --- | --- |
| 8-1  | RS[ 1: OJ Generation .......     |     | 8-5  |     |     |
| 8-2  | DCLK Select Values ......        |     | 8-8  |     |     |
| 9-1  | VGA Register Access Control      |     |      |     |     |
.........
|      | Extensions                 |     | 9-3  |     |     |
| ---- | -------------------------- | --- | ---- | --- | --- |
| 9-2  | CRTC Timing Specification  |     |      |     |     |
..........
|      | Summary                             |     | 9-5  |     |     |
| ---- | ----------------------------------- | --- | ---- | --- | --- |
| 9-3  | Register Bits Affecting the Bitmap  |     |      |     |     |
Definition  ............. 9-6
| 9-4  | Enhanced Mode Setup for  |     |     |     |     |
| ---- | ------------------------ | --- | --- | --- | --- |
1024x768x8 Resolution at 75 Hz
|      | Refresh                          |                      | 9-7      |     |     |
| ---- | -------------------------------- | -------------------- | -------- | --- | --- |
|      | o  o  o                          | I  0  o  o  'o o  o  | o  o  '  |     |     |
| 9-5  | Memory-Mapped 1/0 Addresses for  |                      |          |     |     |
|      | Enhanced Command Registers       |                      | 9-8      |     |     |
Standard VGA Registers Modified or
10-1
|       | Extended in the Vision864  |     | . 10-1  |     |     |
| ----- | -------------------------- | --- | ------- | --- | --- |
| 11-1  | Mnemonics Used in the      |     |         |     |     |
|       | Programming Examples .     |     | . 11-6  |     |     |
| A-1   | CGA-Compatible Registers.  |     | A-2     |     |     |
| A-2   | MDA-and HGC-Compatible     |     |         |     |     |
...
|          | Registers      |      | A-3  |     |     |
| -------- | -------------- | ---- | ---- | --- | --- |
| A-3      | VGA Registers  |      | A-4  |     |     |
| •        |                | •    |      |     |     |
| 9005049  | 0000737        | 069  |      |     |     |
vii

••
r
Vision864 Graphics Accelerator
53 Incorporated
Section 1: Introduction
The S3® Vision864™ 64-bit DRAM-based graph  1.2  DRAM/RAMDAC SUPPORT
ics accelerator (hereinafter referred to as the
Vision864) provides high resolutions, true color
Vision864-based systems can be designed with 1
and multimedia capabilities to multiple PC hard
MByte of DRAM. The memory interface can be
ware and software platforms. It supports Intel®,
|     |     |     | configured as  32  | bits to support this design.  |     |
| --- | --- | --- | ------------------ | ----------------------------- | --- |
PowerPC™, Alpha™ and MIPS™ hardware plat
forms and a range of operating environments  Systems can also be configured with up to 4
MBytes of DRAM with a 64-bit memory interface.
| such as  | Windows™, Windows NT™, OS/2®,  |     |     |     |     |
| -------- | ------------------------------ | --- | --- | --- | --- |
DRAM sizes supported are 256Kx4 and 256Kx16.
Solaris™ and sco® OpenDesktop®.
16-bit RAMDACs or S3 SDAC™ s are supported.
The pixel data bus to the frame buffer is 64 bits
wide. When combined with support for the fast  1.3  RESOLUTIONS SUPPORTED
page and extended data out (EDO) modes of the
latest DRAMs, this provides a pixel data band  Table 1-1.  Video Resolutions Supported
width of up to 240 MBytes/second.
The Vision864 is register-level compatible with  1 MB  2MBs  4MBs
standard VGA and  provides fast operation in  Resolution  DRAM  DRAM  DRAM
these text and graphics modes. It supports the  640x480x4  II'  II'  II'
VESA® extended VGA modes. It also provides a  640x480x8  II'  II'  II'
set of enhanced modes for accelerated operation
|                               |     |                | 640x480x16  | II'  II'  | II'  |
| ----------------------------- | --- | -------------- | ----------- | --------- | ---- |
| with  higher resolutions and  |     | pixel  depths  |             |           |      |
| (bits/pixel).                 |     |                | 640x480x24  | II'  II'  | II'  |
|                               |     |                | 640x480x32  | II'       | II'  |
| 1.1  BUS INTERFACES           |     |                | 800x600x4   | II'  II'  | II'  |
|                               |     |                | 800x600x8   | II'  II'  | II'  |
|                               |     |                | 800x600x16  | II'  II'  | II'  |
The Vision864 provides interfaces to both the PCI
and VESA local busses. The PCI  bus interface  800x600x32  II'  II'
requires no external glue logic. This interface is
|     |     |     | 1024x768x4  | II'  II'  | II'  |
| --- | --- | --- | ----------- | --------- | ---- |
shown Figure 1-1. The VESA local bus interface
|     |     |     | 1024x768x8  | II'  II'  | II'  |
| --- | --- | --- | ----------- | --------- | ---- |
requires external buffers to allow multiplexing of
1024x768x16
| the system address and data lines. The Vision864  |     |     |     | II'  | II'  |
| ------------------------------------------------- | --- | --- | --- | ---- | ---- |
provides all required control signals for these  1280x1024x4  II'  II'  II'
| buffers.  |     |     | 1280x1024x8  | II'  | II'  |
| --------- | --- | --- | ------------ | ---- | ---- |
1600x1200x4
|             |          |          |              | II'  II'      | II'  |
| ----------- | -------- | -------- | ------------ | ------------- | ---- |
|             |          |          | 1600x1200x8  | II'           | II'  |
| .. 9005049  | 0000738  | TT5  ..  |              | INTRODUCTION  | 1-1  |

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Extended VGA text modes up to 132 columns by provides support for multimedia-type applica
43 rows are possible as well. tions such as video superposition and chroma
key control.
1.4 ADVANCED ARCHITECTURE
1.6 GREEN PC SUPPORT
The 64-bit Graphics Engine accelerates common
graphics operations such as bit block transfers For low power consumption designs (Green PC),
(BitBLT s) and rectangle fills. The Vision864 proc the Vision864 allows software manipulation of its
esses two 32 bits/pixel (bpp) (true color) opera horizontal and vertical sync signals to control the
tions, four 16 bpp operations (high color) or eight power state of monitors.
8 bpp operations (pseudo-color) per clock cycle.
Other architectural features enhancing perform
1.7 SOFTWARE SUPPORT
ance include a hardware cursor, linear address
ing of video memory, memory-mapped 1/0 and
write posting of CPU writes to video memory. 53 provides drivers for operating systems such
as Microsoft Windows and IBM® 05/2 Presenta
tion Manager™ and graphics-intensive applica
1.5 MULTIMEDIA SUPPORT
tions such as AutoCAD®. 53 also provides video
BIOS support for RAMDACs covering a large
The Vision864 supports several types of multi performance range. In addition, third party devel
media operations. It provides a request/grant opers provide drivers for numerous applications.
protocol and associated signals to allow a video
coprocessor to share the video frame buffer. In
addition, the Vision864 contains built-in genlock
circuitry to synchronize the RAMDAC output with
an external NTSC/PAL video signal. This feature
1-4 MBVTES
DRAM 8 ANALOG
32 RGB
MCLK, DCLK RAMDAC/
53 Vision864
CLOCK
DRAM PIXEL DATA
32
16
Figure 1-1. PCI Bus System Block Diagram
.. 9005049 0000739 931 ..
1-2 INTRODUCTION

Vision864 Graphics Accelerator
S3 Incorporated
|     |     | Section 2:  | Mechanical Data  |     |     |
| --- | --- | ----------- | ---------------- | --- | --- |
2.1  THERMAL SPECIFICATIONS
| Parameter  |     |     | Min  | Max  | Unit  |
| ---------- | --- | --- | ---- | ---- | ----- |
~
| Thermal Resistance 0JC              |     |     |     | 8   | °CNV  |
| ----------------------------------- | --- | --- | --- | --- | ----- |
| Thermal Resistance 0JA (Still Air)  |     |     |     | 37  | °CNV  |
w
| Power D1ssil:i_ation  |     |     |     | 1.5  1.75  |     |
| --------------------- | --- | --- | --- | ---------- | --- |
oc
Junction Temperature  125
2.2  MECHANICAL DIMENSIONS
The Vision864 comes in a 208-pin PQFP package. The mechanical dimensions are given in Figure 2-1 .
| .. 9005049  | 0000740  | 653  ..  |     |     |     |
| ----------- | -------- | -------- | --- | --- | --- |
MECHANICAL DATA 2-1

••
r
Vision864 Graphics Accelerator
S3 Incorporated
30.60z0.30
29.60z0.20
ru,
28.80
28.0±0.10 ~ ·1
...
:!? 0 ~
.II.
0.50±0.10 020z0.08
13·
LINEAR DIMENSIONS
ARE IN MILLIMETERS
0.50±0.20 mechd1m
Figure 2-1. 208-pin PQFP Mechanical Dimensions
.. 9005049 0000741 59T ..
2-2 MECHANICAL DATA

Vision864 Graphics Accelerator
53 Incorporated
Section 3: Pins
3.1 PINOUT DIAGRAMS
The Vision864 comes in a 208-pin PQFP package. The PCI bus pinout is shown in Figure 3-1. The pinout
for the VESA local bus configuration is shown in Figure 3-2. Active low pins are indicated by an overbar.
11 9005049 0000742 426 II
PINS 3-1

••
r
Vision864 Graphics Accelerator
53 lncorporatad
|     | P v D s 5 s 8     |     |     | P D 1 1   |
| --- | ----------------- | --- | --- | --------- |
P D 1 0
|     | PDS9   |     |     | PD9  |
| --- | ------ | --- | --- | ---- |
|     | PD60   |     |     | P08  |
|     | PD61   |     |     | POO  |
|     | POO:Z  |     |     | PD1  |
PD63
|     | PAO  |     |     | PDZ  |
| --- | ---- | --- | --- | ---- |
PD>
|     | PA1   |     |     | PD4  |
| --- | ----- | --- | --- | ---- |
|     | PA2   |     |     | PD5  |
|     | PA>   |     |     | vss  |
|     | PA4   |     |     | VDD  |
|     | vcuc  |     |     | PD6  |
vss
PD7
|     | PAS    |     |     | MBI  |
| --- | ------ | --- | --- | ---- |
|     | PAO    |     |     | MB7  |
|     | PA7    |     |     | MBO  |
|     | VDD    |     |     | MB5  |
|     | BLAM<  |     |     | MB4  |
|     | PAI    |     |     | MBO  |
PA9
MB1  vss
PA10
|     | PA11     |     |                | MBZ    |
| --- | -------- | --- | -------------- | ------ |
|     | Dru<     |     |                | MB3    |
|     | v s s    |     | Vision864-PCI  | M A 8  |
|     | P A 1 2  |     |                | MA 7   |
|     | PA13     |     |                | MAS    |
|     | PA14     |     | TOP VIEW       |        |
MAS
|     | PA15         |     |     | MA4  |
| --- | ------------ | --- | --- | ---- |
|     | V9VNC        |     |     | MAO  |
|     | HSYNC        |     |     | MA1  |
|     | BGNT         |     |     | MA2  |
|     | S'ENSE1BREO  |     |     | MA3  |
|     | RSO          |     |     | vss  |
RS1
WE1
|     | RS2    |     |     | WEO   |
| --- | ------ | --- | --- | ----- |
|     | DACRD  |     |     | VDD   |
|     | DACWR  |     |     | vss   |
|     | SlWR   |     |     | VDD   |
|     | VDD    |     |     | RAS1  |
|     | MClK   |     |     | RASO  |
vss
OE1
|     | GOO  |     |     | OEO   |
| --- | ---- | --- | --- | ----- |
|     | GD1  |     |     | VSS   |
|     | GDZ  |     |     | CAS7  |
|     | GD3  |     |     | CASS  |
|     | 004  |     |     | CASS  |
|     | GOS  |     |     | CAS4  |
GOO
CAS3
|     | RMST G R D i5 7     |     |     | C AS 2   |
| --- | ------------------- | --- | --- | -------- |
CA S1
INTA ~"'°r-l'T'l';.;.,;;;;.;;;.;;.;;.,;;.;,,.;,,;.,..;.,.;.,.;.,.;.,.;.,.;..;.,.;:,.;;.;:,.;~,;.;.;:,.;;r;;.;:,.;;;..;;;..;;;.;:,.;;.;;;.;~,;;;.;;.,;:,.,;:,.;;.;:,.;:,.;;.;;.;;.,;.,;;.;::. ..., ..l~ CASO
DPCIPINS
Figure 3-1. PCI Bus Configuration Pinout
| .. 9005049  | 0000743  | 362  ..  |     |     |
| ----------- | -------- | -------- | --- | --- |
| 3-2         | PINS     |          |     |     |

Vision864 Graphics Accelerator
53 Incorporated
;
m;   a
~=  ~  ~ ! ! ~ ! ~ ~ g g : § ~ ~ E!  ! ~  ~  E~  ~ ~ E~  ~ ~ E~  E~  ~ ~ E!  ~ ~ E~  E~  ~ ~ ~  ~~~
|     | PD59        |               |           | PD9         |
| --- | ----------- | ------------- | --------- | ----------- |
|     | PDOO        |               |           | P08         |
|     | P061        |               |           | PDO         |
|     | P062        |               |           | PD1         |
|     | PD63        |               |           | PDZ         |
|     | PAO         |               |           | PD3         |
|     | PA1         |               |           | P04         |
|     | PA2.        |               |           | POS         |
|     | PA3         |               |           | VSS         |
|     | PA4         |               |           | VOD         |
|     | VCLK        |               |           | PD6         |
|     | VSS         |               |           | PD7         |
|     | PAS         |               |           | MBB         |
|     | PA6         |               |           | MB7         |
|     | PA7         |               |           | MB8         |
|     | VDD         |               |           | MBS         |
|     | iiUiNK      |               |           | WB4         |
|     | PA8         |               |           | M80         |
|     | PA9         |               |           | WIU         |
|     | PA10        |               |           | VSS         |
|     | PA11        |               |           | MB2         |
|     | OCL.K       |               |           | MB3         |
|     | VSS         | Vision864-VL  |           | MAB         |
|     | •A••        |               |           | MAJ         |
|     | PA13        |               |           | MAG         |
|     | PA14        |               | TOP VIEW  | MAS         |
|     | PA15        |               |           | MA4         |
|     | VSVNC       |               |           | MAO         |
|     | HSYNC       |               |           | MA1         |
|     | BGNT        |               |           | MA2         |
|     | SENSEtBREQ  |               |           | MA3         |
|     | RSO         |               |           | V~          |
|     | RS1         |               |           | Wfi         |
|     | RS2         |               |           | WED         |
|     | OAciiii     |               |           | VDD         |
|     | DACVVR      |               |           | VSS         |
|     | STWR        |               |           | VOD         |
|     | VDD         |               |           | RASl        |
|     | MCLK        |               |           | RASO        |
|     | VSS         |               |           | OE1         |
|     | GOO         |               |           | OEO         |
|     | GDl         |               |           | VSS         |
|     | GDZ         |               |           | CiS6  CAS7  |
003
|     | G04     |     |     | CAS5  |
| --- | ------- | --- | --- | ----- |
|     | GOS     |     |     | CAS4  |
|     | GD6     |     |     | CASi  |
|     | G07     |     |     | CASZ  |
|     | RMSTRD  |     |     | CAS1  |
SINTR ~-...,...,.;.;.,;,-r;.;:;.;.;..;;.;:;;..;.,.;.,.;.,.;.,.;.,.m;.,.;.,,;,.;,;.;;;;;.;.;;.;;;.;..;;.;;;.;.;.;.;.:,.;;,;.;.,;.;;.;,;.;.;;.;;.;m.;;.,;,Tr-fTTrTTTTTrnTriTl'TT"r0- CASO
DVLPINS
Figure 3-2. VESA Local Bus Configuration Pinout
| ~   | 9005049  0000744  | 2T9  ~  |     | PINS  3-3  |
| --- | ----------------- | ------- | --- | ---------- |

••
r
Vision864 Graphics Accelerator
S3 Incorporated
| 3.2  PIN DESCRIPTIONS  |     |     |     |
| ---------------------- | --- | --- | --- |
The following table provides a brief description of each pin on the Vision864 for its VESA local bus and
PCI bus configurations. The following definitions are used in these descriptions:
I -Input signal
0 -Output signal
B -Bidirectional signal
Some pins have multiple names. This reflects the different functions performed by those pins
depending on the bus configuration selected by power-on-strapping. The pin definitions and functions
are given for each possible case.
| Table 3-1.  | Vision864 Pin Descriptions  |                |                |
| ----------- | --------------------------- | -------------- | -------------- |
| S__y_mbol   | TY.l!_e                     | Pin Number(s)  | Descr!t!_tion  |
BUS INTERFACES
Address and Data
| ADl31:21  | B   | 4-9, 1 1-1 2, 16- |     |
| --------- | --- | ----------------- | --- |
Multiplexed Address/Data Bus. A bus transaction
|      |     | 23, 33-36, 38- | (cycle) consists of an address phase followed by one  |
| ---- | --- | -------------- | ----------------------------------------------------- |
|      |     | 41, 44-49      | or more data _()hases.                                |
| AD1  | B   | 50             | (PCI) Multiplexed Address/Data Bit 1.                 |
SM/10/01  B  (VU Memory/1/0 Cycle Indicator/Data 1. The M/10
status is latched during the address phase and D 1 1s
latched dun~ the data_E_hase.
| ADO      | B   | 51  | (PCI) Multiplexed Address/Data Bit 0.           |
| -------- | --- | --- | ----------------------------------------------- |
| SW/R/DO  | B   |     | (VU Write/Read Cycle Indicator/Data 0. The W/R  |
status is latched during the address phase and DO is
latched duri~ the data J'.'.0ase.
C/BE[3:0]  I  13, 24,32,43  (PCI) Bus Command/Data Byte Enables. These signals
carry the bus command during the address phase and
the byte enables during the data phase.
| BE[3:0]  |     |     | (VL) Data ~e Enables.  |
| -------- | --- | --- | ---------------------- |
Bus Control
| SCLK   | I   |      |                           |
| ------ | --- | ---- | ------------------------- |
|        |     | 3    | ~stem Clock.              |
| INTA   | 0   | 208  | (PCI) Interrupt Request.  |
| SINTR  |     |      | (VL) lnterr~ R~uest       |
IRDY  I  26  (PCI) Initiator Ready. A bus data phase 1s completed
when both IRDY and TROY are asserted on the same
cycle.
| RDYIN  |     |     | (VL) Local Bus Cycle End Acknowledge. The V1sion864  |
| ------ | --- | --- | ---------------------------------------------------- |
holds read data valid on the bus until this input 1s
asserted.
| .. 9005049  | 0000745  | 135  ..  |     |
| ----------- | -------- | -------- | --- |
3-4  PINS

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Table 3-1. Vision864 Pin Descriptions (Continued)
~mbol T~e Pin Number(s) Descr~tion
TROY 0 28 (PCI) Target Ready. A bus data phase is completed
when both IRDY and TROY are asserted on the same
cycle.
SRDY (VL) Local Bus ~cle End.
DEVSEL 0 29 (PCI) Device Select. The Vision864 drives this signal
active when it decodes its address as the target of the
current access.
LOCA (VL) Local Bus Access Cycle Indicator. This signal is
output during local bus cycles to allow system logic
chip sets to prevent concurrent EISNISA cycle
_g_enerat1on.
IDSEL I 14 (PCI) Initialization Device Select. This input 1s the chip
select for Vis1on864 PCI configuration register
reads/writes.
DBDIR 0
(VL) Data Buffer Direction Control. This output is high
for a data write and low for a data read.
RESET I 2 (PCI) System Reset. Asserting this signal forces the
Vis1on864 registers and state machines to a known
state.
SRESET
(VL) ~stem Reset
FRAME I 25 (PCI) Cycle Frame. This signal is asserted by the bus
master to indicate the beg1nn1ng of a bus transaction.
It 1s deasserted during the final data phase of a bus
transaction.
SADS (VU S_y_stem Address Strobe.
PAR 0 31 (PCI) Parity. The Vision864 asserts this signal to verify
even parity during reads.
ABEN (VL) Address Buffer Enable. This signal enables the
address buffers to drive the address, SM/10 and SW/R
onto the AD[31 :OJ lines.
STOP 0 30 (PCI) Stop. The Vision864 asserts this signal to indicate
a target disconnect.
DBEN (VU Data Buffer Enable. This output enables the data
buffers to transfer data between the CPU data bus and
the AD[31 :OJ lines
.. 9005049 0000746 071 ..
PINS 3-5

Vision864 Graphics Accelerator
53 Incorporated
Table 3-1. Vision864 Pin Descriptions (Continued)
| S_y_mbol  | T'lfl_e  | Pin Number(s)  | Descrij)tion  |
| --------- | -------- | -------------- | ------------- |
CLOCK CONTROL
MCLK  I  197  Master (Memory) Clock. This input 1s provided by the
clock chip. It controls the pixel data transfer rate
between the V1sion864 and dis[Jlay_ memory_
DCLK  I  180  Dot Clock. This input 1s provided by the clock chip  It
controls the pixel rate to the RAMDAC as well as the
sync and blank t1m1ri_g_s.
DISPLAY MEMORY INTERFACE
Address and Data
PD[63:0J  B  163-159, 157- Display Memory Pixel Data Bus. PD[23-0J are also
|     |     | 155, 147-154,  | used as the system conf1gurat1on strapping bits,  |
| --- | --- | -------------- | ------------------------------------------------- |
144-137, 128- prov1d1ng system configuration and setup 1nformat1on
|     |     | 133, 135-136,  | upon power-on or reset.  |
| --- | --- | -------------- | ------------------------ |
127-123, 121,
119-118, 110-
117, 109-108,
106-101, 91-
92,95-100
| MA[8:0]  | 0   | 80-76, 72-75   | Mem<2.!:Y_ Address Bus A.  |
| -------- | --- | -------------- | -------------------------- |
| MB[8:0]  | 0   | 90-86, 81-82,  | Memory Address Bus B.      |
84-85
Memo!}'_ Control
RAS[l:OJ  0  65-64  Row Address Strobes. Only RASO 1s required for the
V1s1on864 limit of 4 MBytes of display memory. RAS1
provides a decode of accesses to the memory space
between 4 and 8 M~es
| CAS[7 OJ  | 0   | 60-53  | Column Address Strobes  |
| --------- | --- | ------ | ----------------------- |
| WEil:OJ   | 0   | 70-69  | Write Enables.          |
| OE[l:O]   | 0   |        |                         |
|           |     | 63-62  | Ou!Q_ut Enables.        |
RAMDAC INTERFACE
Address and Data
0
| PA[15:0]  |     | 185-182, 179- | RAMDAC Pixel Address Bus.  |
| --------- | --- | ------------- | -------------------------- |
176, 173-171,
168-164
GD[7.0J  B  206-199  General Data Bus. These signals carry RAMDAC
register read/write data They also carry ROM BIOS
reads, clock select outputs, General Output Port
ou!Q_ut and General ln_IJ_ut Port 1n_1J_ut
RS[2:0J  B  192-190  RAMDAC Register Select These signals select the
RAMDAC register to be read/written. For General
Input Port (GOP) reads, RS2 low and RMSTRD
asserted combine to provide the buffer output enable .
| .. 9005049  | 0000747  | T08  ..  |     |
| ----------- | -------- | -------- | --- |
| 3-6  PINS   |          |          |     |

Vision864 Graphics Accelerator
S3 Incorporated
Table 3-1. Vision864 Pin Descriptions (Continued)
RAMDAC Control
VCLK 0 169 V1deo/P1xel Clock. This signal latches pixel data into the
RAMDAC.
DACRD 0 193 RAMDAC Read. This signal 1s asserted to indicate a
data read from the RAMDAC.
DACWR 0 194 RAMDAC Write This signal is asserted to 1nd1cate a
data write to the RAMDAC.
BLANK 0 175 Video Blank Asserting this signal turns off the video
ou!Q_ut.
SENSE/BRED I 189 Video Level Sense/Bus Request. When bit 2 of CR50
1s cleared to 0, this 1s the SENSE input. The RAMDAC
drives this signal low when 1t detects a video voltage
level exceeding 335 mV on any of the analog outputs
This 1s used by the video BIOS to detect the existence
and type of the monitor connected to the system. The
sense status 1s read from bit 4 of 1/0 port 3C2H When
bit 2 of CR50 is set to 1, this 1s the Bus Request input
from another display memory master This supports
shared frame buffer operation. The appropriate input
s.!.9._nal must be selected i2Y._ external hardware
HSY NC 0 187 Horizontal Sync. This s.!.9._nal is an ou~t to the monitor
VSYNC B 186 Vertical Sync. When bit O of CR56 1s cleared to O
(default), this 1s an output to the monitor When bit O
of CR56 is set to 1, this is an input from a master
video source. This provides the basis for genlock1ng
the video output of the V1s1on864 with the master
video source.
MISCELLANEOUS FUNCTIONS
General Data Port
GD[7 OJ B 206-199 General Data Bus. These signals carry data for
RAMDAC reads/writes, clock select outputs, General
Ou!Q_ut Port ou!Q_ut and General ln_Q_ut Port in_Q_ut.
RMSTRD 0 207 ROM/General Input Port Read Strobe. This signal
provides the chip output enable input for ROM BIOS
reads and 1s combined with RSO for the enable to the
General ln_Q_ut Port r~ster.
STWR 0 195 General Output Port Write Strobe. Write strobe for the
General Output Port (CR5C) latch and the clock select
strobe input to the clock chip .
.. 9005049 0000748 944 .. PINS 3-7

••
r Vision864 Graphics Accelerator
S3 Incorporated
Table 3-1. Vision864 Pin Descriptions (Continued}
S_y_mbol 'I'm_e Pin Number(s} Descrij>_tion
Bus Master Control
SENSE/BREO I 189 Video Level Sense/Bus Request. When bit 2 of CR50
is cleared to 0, this 1s the SENSE input. The RAMDAC
drives this signal low when it detects a video voltage
level exceeding 335 mV on any of the analog outputs.
This is used by the video BIOS to detect the existence
and type of the monitor connected to the system. The
sense status is read from bit 4 of 1/0 port 3C2H. When
bit 2 of CR50 is set to 1, this 1s the Bus Request input
from another display memory master. This supports
shared frame buffer operation. The appropriate input
s.!.9_nal must be selected ~external hardware.
BGNT 0 188 Bus Grant. The Vision864 asserts this signal in
response to a BREQ input to notify another display
memory master that it can take control of the display
memory bus. The bus will not be not be granted if the
term1nat1on pos1t1on programmed into the Bus Grant
Termination position register (CR5F) and its extension
(bit 7 of CR5D) has been exceeded. The Vision864
raises this sig_nal to reclaim bus control.
POWER AND GROUND
Voo I 10, 42, 66, 68, Power supply
93, 120, 145,
174, 196
Vss I 1, 15, 27, 37, Ground
52, 61, 67, 71,
83, 94, 107,
122, 134, 146,
158, 170, 181,
198
.. 9005049 0000749 880 ..
3-8 PINS

Vision864 Graphics Accelerator
53 Incorporated
| 3.3  PIN LISTS  |     |     |     |
| --------------- | --- | --- | --- |
Table 3-2 lists all Vision864 pins alphabetically. The pin number{s) corresponding to each pin name
are given in the appropriate bus interface type column. Table 3-3 lists all Vision864 pins in numerical
order. The pin name corresponding to each pin number is given in the appropriate bus interface
column.
| Table 3-2.  | Alphabetical Pin Listing  |     |     |
| ----------- | ------------------------- | --- | --- |
PIN{S)
| Name  | PCI  |     |     |
| ----- | ---- | --- | --- |
VL
| ABEN  |     |     | 31  |
| ----- | --- | --- | --- |
AD[31:2J  4-9, 11-12, 16-23, 33-36, 38-41,  4-9, 11-12, 16-23, 33-36, 38-41,
|            | 44-49                |     | 44-49                |
| ---------- | -------------------- | --- | -------------------- |
| AD[1:0J    | 50-51                |     |                      |
| BE[3:0]    |                      |     | 13, 24,32,43         |
| BGNT       | 188                  |     | 188                  |
| BLANK      | 175                  |     | 175                  |
| BREQ       | 189                  |     | 189                  |
| CAS[7:0J   | 60-53                |     | 60-53                |
| C/BE[3:0J  | 13, 24, 32,43        |     |                      |
| DACRD      | 193                  |     | 193                  |
| DACWR      | 194                  |     | 194                  |
| DBDIR      |                      |     | 14                   |
| DBEN       |                      |     | 30                   |
| DCLK       | 180                  |     | 180                  |
| DEVSEL     | 29                   |     |                      |
| FRAME      | 25                   |     |                      |
| GD[7:0J    | 206-199              |     | 206-199              |
| HSYNC      | 187                  |     | 187                  |
| IDSEL      | 14                   |     |                      |
| INTA       | 208                  |     |                      |
| IRDY       | 26                   |     |                      |
| LOCA       |                      |     | 29                   |
| MA[8:0]    | 80-76, 72-75         |     | 80-76, 72-75         |
| MB[8:0]    | 90-86, 81-82, 84-85  |     | 90-86, 81-82, 84-85  |
| MCLK       | 197                  |     | 197                  |
| 0E[1:0]    | 63-62                |     | 63-62                |
PA[15:0J  185-182, 179-176, 173-171, 168-164  185-182, 179-176, 173-171, 168-164
| PAR  | 31  |     |     |
| ---- | --- | --- | --- |
PD[63:0]  163-159, 157-155, 147-154, 144-137,  163-159, 157-155, 147-154, 144-137,
128-133, 135-136, 127-123, 121,  128-133, 135-136, 127-123, 121,
119-118, 110-117, 109-108, 106-101,  119-118, 110-117, 109-108, 106-101
|             | 91-92, 95-100  |          | 91-92, 95-100  |
| ----------- | -------------- | -------- | -------------- |
| RAS[1:0J    | 65-64          |          | 65-64          |
| RESET       | 2              |          |                |
| .. 9005049  | 0000750        | 5T2  ..  |                |
PINS  3-9

Vision864 Graphics Accelerator
53 Incorporated
Table 3-2. Alphabetical Pin Listing (Continued)
PIN(S)
| Name      | PCI      |     | VL       |
| --------- | -------- | --- | -------- |
| RDYIN     |          |     | 26       |
| RS[2:0]   | 192-190  |     | 192-190  |
| RMSTRD    | 207      |     | 207      |
| SADS      |          |     | 25       |
| SCLK      | 3        |     | 3        |
| SENSE     | 189      |     | 189      |
| SINTR     |          |     | 208      |
| SM/10/Dl  |          |     | 50       |
| SRDY      |          |     | 28       |
| SR ES ET  |          |     | 2        |
| STOP      | 30       |     |          |
| STWR      | 195      |     | 195      |
| SW/R/DO   |          |     | 51       |
| TRDY      | 28       |     |          |
| VCLK      | 169      |     | 169      |
VDD  10,42, 66, 68, 93, 120, 145, 174, 196  10, 42, 66, 68, 93, 120, 145, 174, 196
vss
1, 15, 27,3~ 5Z61, 6~ 71,83, 9~  1, 15, 27, 37, 52, 61, 67, 71, 83, 94,
107, 122, 134, 146, 158, 170, 181,  107, 122, 134, 146, 158, 170, 181,
|             | 198      |                         | 198    |
| ----------- | -------- | ----------------------- | ------ |
| VSYNC       | 186      |                         | 186    |
| WE[1:0]     | 70-69    |                         | 70-69  |
| .. 9005049  | 0000751  | 439  .. ~~~~~~~~~~~~~~- |        |
| 3-10  PINS  |          |                         |        |

Vision864 Graphics Accelerator
53 Incorporated
| Table 3-3.  | Numerical Pin Listing  |     |     |
| ----------- | ---------------------- | --- | --- |
Name
| Number  | PCI  |     | VL  |
| ------- | ---- | --- | --- |
vss
| 1   | VSS    |     |         |
| --- | ------ | --- | ------- |
| 2   | RESET  |     | SRESET  |
| 3   | SCLK   |     | SCLK    |
| 4   | AD31   |     | AD31    |
| 5   | AD30   |     | AD30    |
| 6   | AD29   |     | AD29    |
| 7   | AD28   |     | AD28    |
| 8   | AD27   |     | AD27    |
| 9   | AD26   |     | AD26    |
| 10  | VDD    |     | VDD     |
| 11  | AD25   |     | AD25    |
| 12  | AD24   |     | AD24    |
13
|     | C/BE3  |     | BE3    |
| --- | ------ | --- | ------ |
| 14  | IDSEL  |     | DBDIR  |
vss
| 15  | VSS   |     |       |
| --- | ----- | --- | ----- |
| 16  | AD23  |     | AD23  |
| 17  | AD22  |     | AD22  |
|     | AD21  |     | AD21  |
18
| 19  | AD20   |     | AD20   |
| --- | ------ | --- | ------ |
| 20  | AD19   |     | AD19   |
| 21  | AD18   |     | AD18   |
| 22  | AD17   |     | AD17   |
| 23  | AD16   |     | AD16   |
| 24  | C/BE2  |     | BE2    |
| 25  | FRAME  |     | SADS   |
| 26  | IRDY   |     | RDYIN  |
| 27  | VSS    |     | vss    |
|     | TROY   |     | SRDY   |
28
| 29  | DEVSEL  |     | LOCA  |
| --- | ------- | --- | ----- |
| 30  | STOP    |     | DBEN  |
| 31  | PAR     |     | ABEN  |
| 32  | C/BE1   |     | BE1   |
| 33  | AD15    |     | AD15  |
| 34  | AD14    |     | AD14  |
| 35  | AD13    |     | AD13  |
| 36  | AD12    |     | AD12  |
vss
| 37          | VSS      |          |       |
| ----------- | -------- | -------- | ----- |
| 38          | AD11     |          | AD11  |
| 39          | AD10     |          | AD10  |
| 40          | AD9      |          | AD9   |
| 41          | ADS      |          | ADS   |
| 42          | VDD      |          | VDD   |
| .. 9005049  | 0000752  | 375  ..  |       |
PINS  3-11

••
r
Vision864 Graphics Accelerator
$3 Incorporated
Table 3-3. Numerical Pin Listing (Continued)
Name
| Number  | PCI    |     | VL        |
| ------- | ------ | --- | --------- |
| 43      | C/BEO  |     | BEO       |
| 44      | AD7    |     | AD7       |
| 45      | AD6    |     | AD6       |
| 46      | AD5    |     | AD5       |
| 47      | AD4    |     | AD4       |
| 4S      | AD3    |     | AD3       |
| 49      | AD2    |     | AD2       |
| 50      | AD1    |     | SM/10/D1  |
| 51      | ADO    |     | SW/R/DO   |
|         | vss    |     | vss       |
52
| 53  | CASO  |     | CASO  |
| --- | ----- | --- | ----- |
| 54  | CAS1  |     | CAS1  |
| 55  | CAS2  |     | CAS2  |
| 56  | CAS3  |     | CAS3  |
| 57  | CAS4  |     | CAS4  |
| 5S  | CAS5  |     | CAS5  |
| 59  | CAS6  |     | CAS6  |
| 60  | CAS7  |     | CAS7  |
|     | vss   |     | vss   |
61
| 62  | OEO   |     | OEO   |
| --- | ----- | --- | ----- |
| 63  | OE1   |     | OE1   |
| 64  | RASO  |     | RASO  |
|     | RAS1  |     | RAS1  |
65
|     | VDD  |     | VDD  |
| --- | ---- | --- | ---- |
66
|     | vss  |     | vss  |
| --- | ---- | --- | ---- |
67
| 6S  | VDD  |     | VDD  |
| --- | ---- | --- | ---- |
| 69  | WEO  |     | WEO  |
| 70  | WE1  |     | WE1  |
|     | vss  |     | vss  |
71
| 72  | MA3  |     | MA3  |
| --- | ---- | --- | ---- |
| 73  | MA2  |     | MA2  |
| 74  | MA1  |     | MA1  |
| 75  | MAO  |     | MAO  |
| 76  | MA4  |     | MA4  |
| 77  | MA5  |     | MA5  |
| 7S  | MA6  |     | MA6  |
| 79  | MA7  |     | MA7  |
| so  | MAS  |     | MAS  |
| Sl  | MB3  |     | MB3  |
| S2  | MB2  |     | MB2  |
|     | vss  |     | vss  |
S3
| S4          | MB1      |          | MB1  |
| ----------- | -------- | -------- | ---- |
| .. 9005049  | 0000753  | 201  ..  |      |
| 3-12  PINS  |          |          |      |

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Table 3-3. Numerical Pin Listing (Continued)
Name
| Number  | PCI  |     | VL   |     |
| ------- | ---- | --- | ---- | --- |
| 85      | MBO  |     | MBO  |     |
| 86      | MB4  |     | MB4  |     |
| 87      | MB5  |     | MB5  |     |
| 88      | MB6  |     | MB6  |     |
| 89      | MB7  |     | MB7  |     |
| 90      | MB8  |     | MB8  |     |
| 91      | PD7  |     | PD7  |     |
| 92      | PD6  |     | PD6  |     |
|         | VDD  |     | VDD  |     |
93
|     | vss  |     | vss  |     |
| --- | ---- | --- | ---- | --- |
94
| 95   | PD5   |     | PD5   |     |
| ---- | ----- | --- | ----- | --- |
| 96   | PD4   |     | PD4   |     |
| 97   | PD3   |     | PD3   |     |
| 98   | PD2   |     | PD2   |     |
| 99   | PD1   |     | PD1   |     |
| 100  | PDO   |     | PDO   |     |
| 101  | PD8   |     | PD8   |     |
| 102  | PD9   |     | PD9   |     |
| 103  | PD10  |     | PD10  |     |
| 104  | PD11  |     | PD11  |     |
| 105  | PD12  |     | PD12  |     |
| 106  | PD13  |     | PD13  |     |
|      | vss   |     | vss   |     |
107
| 108  | PD14  |     | PD14  |     |
| ---- | ----- | --- | ----- | --- |
| 109  | PD15  |     | PD15  |     |
| 110  | PD23  |     | PD23  |     |
| 111  | PD22  |     | PD22  |     |
| 112  | PD21  |     | PD21  |     |
| 113  | PD20  |     | PD20  |     |
| 114  | PD19  |     | PD19  |     |
| 115  | PD18  |     | PD18  |     |
| 116  | PD17  |     | PD17  |     |
| 117  | PD16  |     | PD16  |     |
| 118  | PD24  |     | PD24  |     |
| 119  | PD25  |     | PD25  |     |
| 120  | VDD   |     | VDD   |     |
| 121  | PD26  |     | PD26  |     |
|      | vss   |     | vss   |     |
122
| 123         | PD27     |          | PD27  |             |
| ----------- | -------- | -------- | ----- | ----------- |
| 124         | PD28     |          | PD28  |             |
| 125         | PD29     |          | PD29  |             |
| 126         | PD30     |          | PD30  |             |
| .. 9005049  | 0000754  | 148  ..  |       | PINS  3-13  |

Vision864 Graphics Accelerator
53 Incorporated
Table 3-3. Numerical Pin Listing (Continued)
Name
| Number  | PCI   |     | VL    |
| ------- | ----- | --- | ----- |
| 127     | PD31  |     | PD31  |
| 128     | PD39  |     | PD39  |
| 129     | PD38  |     | PD38  |
| 130     | PD37  |     | PD37  |
| 131     | PD36  |     | PD36  |
| 132     | PD35  |     | PD35  |
| 133     | PD34  |     | PD34  |
|         | vss   |     | vss   |
134
| 135  | PD33  |     | PD33  |
| ---- | ----- | --- | ----- |
| 136  | PD32  |     | PD32  |
| 137  | PD40  |     | PD40  |
| 138  | PD41  |     | PD41  |
| 139  | PD42  |     | PD42  |
| 140  | PD43  |     | PD43  |
| 141  | PD44  |     | PD44  |
| 142  | PD45  |     | PD45  |
| 143  | PD46  |     | PD46  |
| 144  | PD47  |     | PD47  |
| 145  | VDD   |     | VDD   |
| 146  | vss   |     | vss   |
| 147  | PD55  |     | PD55  |
| 148  | PD54  |     | PD54  |
| 149  | PD53  |     | PD53  |
| 150  | PD52  |     | PD52  |
| 151  | PD51  |     | PD51  |
| 152  | PD50  |     | PD50  |
| 153  | PD49  |     | PD49  |
| 154  | PD48  |     | PD48  |
| 155  | PD56  |     | PD56  |
| 156  | PD57  |     | PD57  |
| 157  | PD58  |     | PD58  |
|      | vss   |     | vss   |
158
| 159           | PD59     |           | PD59  |
| ------------- | -------- | --------- | ----- |
| 160           | PD60     |           | PD60  |
| 161           | PD61     |           | PD61  |
| 162           | PD62     |           | PD62  |
| 163           | PD63     |           | PD63  |
| 164           | PAO      |           | PAO   |
| 165           | PA1      |           | PA1   |
| 166           | PA2      |           | PA2   |
| 167           | PA3      |           | PA3   |
| 168           | PA4      |           | PA4   |
| Ill  9005049  | 0000755  | 084  Ill  |       |
| 3-14  PINS    |          |           |       |

Vision864 Graphics Accelerator
S3 Incorporated
Table 3-3. Numerical Pin Listing (Continued)
Name
| Number  | PCI    |     | VL     |     |
| ------- | ------ | --- | ------ | --- |
| 169     | VCLK   |     | VCLK   |     |
| 170     | vss    |     | vss    |     |
| 171     | PA5    |     | PA5    |     |
| 172     | PA6    |     | PA6    |     |
| 173     | PA7    |     | PA7    |     |
| 174     | VDD    |     | VDD    |     |
| 175     | BLANK  |     | BLANK  |     |
| 176     | PAS    |     | PAS    |     |
| 177     | PA9    |     | PA9    |     |
| 17S     | PA10   |     | PA10   |     |
| 179     | PA11   |     | PA11   |     |
| 1SO     | DCLK   |     | DCLK   |     |
|         | vss    |     | vss    |     |
1S1
| 1S2  | PA12        |     | PA12        |     |
| ---- | ----------- | --- | ----------- | --- |
| 1S3  | PA13        |     | PA13        |     |
| 184  | PA14        |     | PA14        |     |
| 1S5  | PA15        |     | PA15        |     |
| 1S6  | VSYNC       |     | VSYNC       |     |
| 1S7  | HSYNC       |     | HSYNC       |     |
| 1SS  | BGNT        |     | BGNT        |     |
| 1S9  | SENSE/BREO  |     | SENSE/BREO  |     |
| 190  | RSO         |     | RSO         |     |
| 191  | RS1         |     | RS1         |     |
| 192  | RS2         |     | RS2         |     |
| 193  | DACRD       |     | DACRD       |     |
| 194  | DACWR       |     | DACWR       |     |
| 195  | STWR        |     | STWR        |     |
|      | VDD         |     | VDD         |     |
196
| 197  | MCLK  |     | MCLK  |     |
| ---- | ----- | --- | ----- | --- |
|      | vss   |     | vss   |     |
198
| 199        | GDO      |         | GDO     |             |
| ---------- | -------- | ------- | ------- | ----------- |
| 200        | GD1      |         | GD1     |             |
| 201        | GD2      |         | GD2     |             |
| 202        | GD3      |         | GD3     |             |
| 203        | GD4      |         | GD4     |             |
| 204        | GD5      |         | GD5     |             |
| 205        | GD6      |         | GD6     |             |
| 206        | GD7      |         | GD7     |             |
| 207        | RMSTRD   |         | RMSTRD  |             |
| 208        | INTA     |         | SINTR   |             |
| ~ 9005049  | 0000756  | T10  ~  |         | PINS  3-15  |

Vision864 Graphics Accelerator
S3 lncorporatad
Section 4: Electrical Data
4.1  MAXIMUM RATINGS
| Table 4-1.  Absolute Maximum Ratings  |     |                |     |     |     |
| ------------------------------------- | --- | -------------- | --- | --- | --- |
| Ambient temperature                   |     | 0° C to 70° C  |     |     |     |
Storage temperature
-40° C to 125° C
| DC SLJQE!)y_ Volt~e                    |     | -0.5V to 7.0V      |     |     |     |
| -------------------------------------- | --- | ------------------ | --- | --- | --- |
| 1/0 Pin Volt'llie with respect to Vss  |     | -0.5V to VDD+0.5V  |     |     |     |
4.2  DC SPECIFICATIONS
| Table 4-2.  | DC Specifications (VDD = 5V ± 5%)  |     |      |      |       |
| ----------- | ---------------------------------- | --- | ---- | ---- | ----- |
| ~mbol       | Parameter                          |     | Min  | Max  | Unit  |
| V1L         | 112.e_ut Low Volt~e                |     |      | 0.8  | v     |
v
| V1H  | IQQut H_jgh Volt~e  |     | 2.4  |     |     |
| ---- | ------------------- | --- | ---- | --- | --- |
v
| VoL        | 0u.!2_ut Low Volt~e       |      |              | Vss + 0.4  |       |
| ---------- | ------------------------- | ---- | ------------ | ---------- | ----- |
| VoH        | Ou.!2_ut Hi9_h Volt~e     |      | 2.4          |            | v     |
| IOL1       | 0u.!2_ut Low Current      |      | 4 (Note 1)   |            | mA    |
| IOH1       | 0u.!2_ut Hl.9_h Current   |      | -2           |            | mA    |
| IOL2       | Ou.!2_ut Low Current      |      | 8 (Note 2)   |            | mA    |
| IOH2       | Ou.!2_ut Hl.9_h Current   |      | -4           |            | mA    |
| IOL3       | Ou!Q_ut Low Current       |      | 16 (Note 3)  |            | mA    |
| IQH3       | Ou!Q_ut Hl.9_h Current    |      | -8           |            | mA    |
| IOL4       | Ou!Q_ut Low Current       |      | 24 (Note 4)  |            | mA    |
| IOH4       | 0u.!2_ut H!g_h Current    |      | -10          |            | mA    |
| loz        | Output Tri-state Current  |      |              | 1          | l!6_  |
| C1N        | lnjlut C~citance          |      |              | 5          | 2F    |
| CouT       | 0u!2_ut C~citance         |      |              | 5          | 2F    |
| Ice        | Power Supply Current      |      |              | 350        | mA    |
| ~ 9005049  | 0000757                   | 957  |              |            |       |
~
ELECTRICAL DATA 4-1

Vision864 Graphics Accelerator
53 Incorporated
Notes for Table 4-2
lou, loH1 for pins BLANK, CAS[7:0], DACRD, J'.5ACWR, GD[7:0], HSYNC, INTA
1.
MA[8:0], MB[8:0), PA[15:0), PD[63:0], RS[2:0], RMSTRD, SINTR, STWR, VSYNC
| 2.  loL2, loH2 for pins VCLK, AD[31 :OJ    |     |     |
| ------------------------------------------ | --- | --- |
| 3.  loL3, loH3 for pins OE[1:0), RAS[1:0)  |     |     |
4.  loL4, loH4 for pins PAR (ABEN), STOP (DBEN), DEVSEL (LOCA), TRDY (SRDY), WE[1:0)
Note
Pin names for VL-Bus configurations are shown in parentheses.
| 4.3  AC SPECIFICATIONS  |     |     |
| ----------------------- | --- | --- |
Notes
| 1.  All AC timings are based on an 80 pF test load.  |     |     |
| ---------------------------------------------------- | --- | --- |
2.  Functional timing diagrams are found in the appropriate functional description section, i.e,
System Bus Interfaces, Display Memory or Miscellaneous Functions .
| .. 9005049  | 0000758  | 893  ..  |
| ----------- | -------- | -------- |
4-2 ELECTRICAL DATA

Vision864 Graphics Accelerator
S3 Incorporated
4.3.1  Clock Timing
|     | 2.4V --- | ---------------        | ---                 |     |     |
| --- | -------- | ---------------------- | ------------------- | --- | --- |
|     | 1.SV --- | ------------------     | ------------------- |     |     |
|     | 0.SV --- | - -------------------- | ---------------     |     |     |
------Tcvc _______
Figure 4-1. Clock Waveform Timing
| Table 4-3.  | Clock Waveform Timing              |     |       |      |               |
| ----------- | ---------------------------------- | --- | ----- | ---- | ------------- |
| ~mbol       | Parameter                          |     | Min   | Max  | Units  Notes  |
| Tcyc        | SCLK Ql_cle Time (VL-Bus)          |     | 20    | 125  | ns  1         |
|             |                                    |     | 30    | 125  | 1             |
|             | SCLK Q{_cle Time (PCI)             |     |       |      | ns            |
|             | MCLK QL_cle Time                   |     | 16 7  | 25   | ns            |
|             | DCLK Q[_cle Time (VGA Mode)        |     | 25    | 100  | ns  1         |
|             |                                    |     | 10 5  | 100  | 1             |
|             | DCLK Q[_cle Time (Enhanced Mode)   |     |       |      | ns            |
| THIGH       | SCLK HJ.g_h Time (VL-Bus)          |     | 8     | 80   | ns            |
|             | SCLK HJ.g_h Time (PCI)             |     | 12    | 80   | ns            |
|             | MCLK H_ig_h Time                   |     | 6     | 10   | ns            |
|             | DCLK H_!_g_h Time (VGA Mode)       |     | 10    | 65   | ns            |
|             | DCLK H_!_g_h Time (Enhanced Mode)  |     | 4     | 65   | ns            |
| TLOw        | SCLK Low Time (VL-Bus)             |     | 8     | 80   | ns            |
|             | SCLK Low Time (PCI)                |     | 12    | 80   | ns            |
|             | MCLK Low Time                      |     | 6     | 10   | ns            |
|             | DCLK Low Time (VGA Mode)           |     | 10    | 65   | ns            |
|             | DCLK Low Time (Enhanced Mode)      |     | 4     | 65   | ns            |
|             | SCLK Slew Rate                     |     | 1     | 4    | V/ns  2       |
|             | MCLK Slew Rate                     |     | 1     | 4    | V/ns  2       |
|             | DCLK Slew Rate                     |     | 1     | 4    | V/ns  2       |
Notes:
1.  focLK ~ 1/2 fscLK to ensure valid writes to the clock chip.
2.  Rise and fall times are specified in terms of the edge rate measured in V/ns. This slew rate
must be met across the minimum peak-to peak portion of the clock waveform .
| .. 9005049  | 0000759  | 72T  ..  |     |     |     |
| ----------- | -------- | -------- | --- | --- | --- |
ELECTRICAL DATA 4-3

••
r
Vision864 Graphics Accelerator
53 Incorporated
| 4.3.2  Input/Output Timing  |     |     |     |     |
| --------------------------- | --- | --- | --- | --- |
SCLK
v
1.5
MCLK
DCLK
v  v
|     | INPUT  | 1.5  | 1.5  |     |
| --- | ------ | ---- | ---- | --- |
CLKIN
Figure 4·2. Input Timing
| Table 4-4.  SCLK-Referenced Input Timing  |     |     |     |     |
| ----------------------------------------- | --- | --- | --- | --- |
PCIBus
| S__y_mbol  | Parameter  |     | Min  | Units  |
| ---------- | ---------- | --- | ---- | ------ |
Tsu  AD[31 :OJ, C/BE[3:0]. FRAME, IRDY, IDSEL setu_l'.l._  7  ns
| TH  | AD[31 :OJ hold                      |     | 1   | ns  |
| --- | ----------------------------------- | --- | --- | --- |
| TH  | C/BE[3:0J, FRAME, IRDY, IDSEL hold  |     | 0   | ns  |
VL-Bus
| S__y_mbol  | Parameter                                       |     | Min  | Units  |
| ---------- | ----------------------------------------------- | --- | ---- | ------ |
|            | AD[31 :2], BE[3:0J, SM/10, SW/R, SADS (address  |     | 12   | ns     |
Tsu
_Q_hase) setu_Q_
| TH  | AD[31 :2], BE[3:0], SM/10, SW/R, SADS (address  |     | 0   | ns  |
| --- | ----------------------------------------------- | --- | --- | --- |
_Q_hase) hold
| Tsu  | AD[31 :2], BE[3:0J, D1, DO, SADS (data phase)  |     | 4   | ns  |
| ---- | ---------------------------------------------- | --- | --- | --- |
setu_Q_
TH  AD[31:2J, BE[3:0J, D1, DO, SADS (data_fl._hase) hold  0  ns
| Tsu  | RDYI N setl!Q__  |     | 6   | ns  |
| ---- | ---------------- | --- | --- | --- |
| TH   | RDYIN hold       |     | 1   | ns  |
Miscellaneous
| S__y_mbol   | Parameter                            |          | Min  | Units  |
| ----------- | ------------------------------------ | -------- | ---- | ------ |
| Tsu         | ROM Data GD[7:0J Setu_Q_(PCI)        |          | 5    | ns     |
| TH          | ROM Data GD[7:0] Hold (PCI)          |          | 7    | ns     |
| Tsu         | General ln_Q_ut Port GD[7:0] settp_  |          | 5    | ns     |
| TH          | General Input Port GD[7:0] hold      |          | 7    | ns     |
| .. 9005049  | OOOO?bO                              | 441  ..  |      |        |
4-4 ELECTRICAL DATA

Vision864 Graphics Accelerator
S3 Incorporated
SCLK
MCLK  1.5 V
DCLK
DELAY
OUTPUT
Figure 4-3. Output Timing
| Table 4-5.  SCLK-Referenced Output Timing  |     |     |     |     |
| ------------------------------------------ | --- | --- | --- | --- |
PCIBus
| Parameter               |     |     | TMIN  TMAX  | Units  Notes       |
| ----------------------- | --- | --- | ----------- | ------------------ |
| AD[31 :OJ valid delay_  |     |     | 2  16       | ns  1              |
| DEVSEL, PAR delay       |     |     | 2  11       | ns  Medium DEVSEL  |
t1m1r:!.9_used
| STOP delay_   |     |     | 2  11  | ns  |
| ------------- | --- | --- | ------ | --- |
| TROY delay__  |     |     | 2  11  | ns  |
| INTA delay_   |     |     | 2  11  | ns  |
VL-Bus
| Parameter                                 |     |     | TMIN  TMAX  | Units  Notes  |
| ----------------------------------------- | --- | --- | ----------- | ------------- |
| AD[31 :2], 01, DO valid del'!Y_           |     |     | 7  16       | ns            |
| SINTR del'!Y_                             |     |     | 5  30       | ns            |
| SRDY del'!Y_                              |     |     | 5  11       | ns            |
| LOCA active del§'L                        |     |     | 5  15       | ns            |
| LOCA inactive del'!Y_                     |     |     | 5  20       | ns            |
| DBDIR del'!Y_                             |     |     | 5  16       | ns            |
| ABEN, DBEN active del'!Y_(min non-overl~  |     |     | 5  12       | ns            |
| ABEN, DBEN active del§Y_(max non-overl~   |     |     | 5  15       | ns            |
| ABEN, DBEN inactive del'!Y_               |     |     | 5  13       | ns            |
Miscellaneous
| Parameter                           |     |     | TMIN  TMAX  | Units  Notes  |
| ----------------------------------- | --- | --- | ----------- | ------------- |
| RS[2 .OJ delay__                    |     |     | 5  20       | ns            |
| RMSTRD delay_                       |     |     | 3  15       | ns            |
| ROM Address valid del'!Y_(PCI)      |     |     | 5  30       | ns            |
| AD[7·0J ROM Data valid delay (PCI)  |     |     | 5  30       | ns            |
Note
1.  Due to the timing for TRDY for read cycles, data is not sampled on the clock edge immediately
following its becoming valid. This guarantees the PCI 2.0 specification time of 11 ns.
| II  9005049  | 0000761  | 388  II  |     | ELECTRICAL DATA 4-5  |
| ------------ | -------- | -------- | --- | -------------------- |

••
| r   |     |     | Vision864 Graphics Accelerator  |     |     |
| --- | --- | --- | ------------------------------- | --- | --- |
S3 Incorporated
| Table 4·6.                                | MCLK·Referenced Input Timing        |     |       |       |        |
| ----------------------------------------- | ----------------------------------- | --- | ----- | ----- | ------ |
| S_y_mbol                                  | Parameter                           |     |       | Min   | Units  |
| Tsu                                       | PD[63:0J setu_Q (EDO memo_!}'.)     |     |       | 0     | ns     |
| TH                                        | PD[63:0J hold (EDO memQ!}')         |     |       | 10    | ns     |
| Tsu                                       | General llJ.Q_ut Port GD[7:0J set~  |     |       | 5     | ns     |
| TH                                        | General Input Port GD[7:0J hold     |     |       | 7     | ns     |
| Table 4·7.                                | MCLK·Referenced Output Timing       |     |       |       |        |
| Parameter                                 |                                     |     | TMIN  | TMAX  | Units  |
| RAS[1 :OJ active del§Y_                   |                                     |     | 4     | 12    | ns     |
| RAS[1 :OJ inactive del§Y_                 |                                     |     | 4     | 10    | ns     |
| CAS[7:0]. OE[1 :OJ. WE[1.0J active del§Y  |                                     |     | 5     | 12    | ns     |
CAS[7:0J. OE[1.0J. WE[1 :OJ inactive del§Y_ (min stretch)  4  8  ns
CAS[7:0J. 0E[1 :OJ. WE[1 :OJ 1nact1ve del§Y_ (max stretch)  6  17  ns
| MA[8:0], MB[8:0] valid del§Y_            |                                          |          | 5     | 24    | ns     |
| ---------------------------------------- | ---------------------------------------- | -------- | ----- | ----- | ------ |
| PD[63:0] valid del§Y                     |                                          |          | 5     | 27    | ns     |
| DACRD, DACWR delay                       |                                          |          | 3     | 20    | ns     |
| Table 4·8.                               | DCLK·Referenced Output Timing            |          |       |       |        |
| Parameter                                |                                          |          | TMIN  | TMAX  | Units  |
| BLANK, HSYNC, VSYNC                      |                                          |          | 3     | 17    | ns     |
| PA[15:0J valid del§Y                     |                                          |          | 5     | 14    | ns     |
| STWR del§Y                               |                                          |          | 3     | 15    | ns     |
| General Ou!Q.ut Port Data GD[7.0J del§Y  |                                          |          | 5     | 20    | ns     |
| VCLK delay                               |                                          |          | 5     | 16    | ns     |
| Table 4-9.                               | Fast Page Mode Memory Input Timing       |          |       |       |        |
| Symbol                                   | Parameter                                |          |       | Min   | Units  |
| Tsu                                      | PD[63·0] set'::!£_ to CAS[7·0] 1nact1ve  |          |       | 0     | ns     |
| TH                                       | PD[63·0] hold from CAS[7:0] 1nact1ve     |          |       | 5     | ns     |
| .. 9005049                               | 0000762                                  | 214  ..  |       |       |        |
4-6 ELECTRICAL DATA

Vision864 Graphics Accelerator
S3 Incorporated
SRESET,RESET
SYSTEM
CONFIGURATION
DATA
Figure 4-4. Reset Timing
| Table 4-10.  Reset Timing  |            |     |      |        |
| -------------------------- | ---------- | --- | ---- | ------ |
| ~mbol                      | Parameter  |     | Min  | Units  |
TLOw  SRESET (VL) or RESET (PCI) active_Q_ulse width  400  ns
| Tsu  | PD[23 OJ setup to SRESET (VL) or RESET (PCI)  |     | 20  | ns  |
| ---- | --------------------------------------------- | --- | --- | --- |
inactive
| TH  | PD[23 OJ hold from SRESET (VL) or RESET (PCI)  |     | 10  | ns  |
| --- | ---------------------------------------------- | --- | --- | --- |
inactive
4.4  OUTPUT BUFFER MODEL
Figure 4-5 shows a first order output buffer model for the Vision864. The parameters are:
| Parameter  | Descr~ion  |     |     |     |
| ---------- | ---------- | --- | --- | --- |
dV/dt  Mininum and maximum rate of change of the open circuit voltage source used 1n the
buffer model
Ro  Minimum and maximum ou!Q_ut 1m_Q_edance of the buffer model
| Co  | Minimum and maximum c~ac1tance used 1n the buffer model  |     |     |     |
| --- | -------------------------------------------------------- | --- | --- | --- |
| Lp  | M1n1mum and max1mum_p_ackag_e inductance                 |     |     |     |
| Cp  | Minimum and maximum package capacitance                  |     |     |     |
The parameter values appropriate for the Vision864 depend on the manufacturing process and can be
obtained directly from S3.
| 11  9005049  | 0000763  | 150  II  |     |     |
| ------------ | -------- | -------- | --- | --- |
ELECTRICAL DATA 4-7

••
r Vision864 Graphics Accelerator
53 Incorporated
Ro
Figure 4-5. First Order Output Buffer Model
4.5 POWER ISOLATION CONSIDERATIONS
Because of electrical noise considerations, each power (VDDl pin must be isolated as shown in Figure
4-6. The layout with each power pin properly isolated is shown in Figure 4-7.
1.- 0.1 µF SMT CAPACITOR
-.j
< 0.2"
..__TO GROUND
VDD PIN
PLANE
TO POWER
PLANE
0.01 µF SMT CAPACITO
Figure 4-6. Power Pin Isolation Detail
.. 9005049 0000764 097 ..
4-8 ELECTRICAL DATA

Vision864 Graphics Accelerator
53 Incorporated
VisionX64
TOP VIEW
Figure 4-7. Power Pin Connection Requirements
.. 9005049 0000765 T23 ..
ELECTRICAL DATA 4-9

Vision864 Graphics Accelerator
SJ Incorporated
Section 5: Reset and Initialization
The reset signal (RESET for PCI, SRESET for VL cussion in the Miscellaneous Interfaces section
Bus} is clocked into the Vision864 by the DCLK of this data book for more details.
input. This resets the internal state machines in
the Vision864 and places all registers in their The GD[7:5] lines are input at reset and the values
power-on default states. It also initiates several on these lines are latched into bits 6-4 of 42E8H.
configuration actions, as described in this sec These are user-definable bits. An external source
tion. (such as monitor ID lines) can be connected to
the General Input Port bits 7-5 and these will be
captured on reset. Alternately, GD[7:5) can be
5.1 CONFIGURATION STRAPPING
strapped high or low through 47 Kn resistors to
set bits 6-4 of 42E8H to a fixed value on reset.
The PD[23:0) pins can be individually pulled
either high or low through 47 KQ resistors. These The GD4 pin is tri-stated on reset.
pull-ups and pull-downs do not affect normal
operation of the pins as part of the pixel data bus,
5.3 PREVENTING BUS LOADS
but they do force the pins to a definite state on
reset. At the rising edge of the reset signal, this DURING RESET
state is sampled and data loaded into the CR36,
CR37 and CR68 registers. The data is used for The VL-Bus specification requires that the ad
system configuration, such as system bus and dress and data busses not be driven during reset.
memory parameter selection. The definitions of To ensure this, the ABEN and DBEN pins should
the PD[23:0] strapping bits at the rising edge of be pulled high through 10 KQ resistors. This
the reset signal are shown in Table 5-1. prevents them from floating low during reset and
allowing the busses to be driven.
Strapping bits 7-5 define the display memory
size. However, the S3 BIOS directly determines
this value and writes itto CR36 bits 7-5 after reset.
Therefore, systems using the S3 BIOS do not
need to strap the PD[7-5) pins.
Strapping bits 15-13 provide monitor informa
tion. The interpretation of the bit values is de
pendent on the video BIOS.
5.2 GENERAL DATA BUS AT RESET
At power-on reset, the GD[3:0) lines are all zeros
and the S1WR signal is asserted to latch them
into the clock chip. See the Clock Generator dis-
.. 9005049 0000766 96T ..
RESET AND INITIALIZATION 5-1

-·
r
Vision864 Graphics Accelerator
S3 Incorporated
Table 5·1. Definition of PD[23:0) at the Rising Edge of the Reset Signal
CR Bits PD Bits Value Function
S..}'!'tem Bus Select
CR36_1-0 1-0 00 Reserved
01 VESA local bus
10 PCI local bus
11 Reserved
Memory P'!_g_e Mode Select
CR36 3-2 3-2 00 Reserved
01 Reserved
10 Extended data out (EDO) mode
11 Fast_JJ_ag_e mode
Enable Video BIOS (VL-Busl
CR36 4 4 0 Disable video BIOS access (system BIOS contains video BIOS)
1 Enable video BIOS access
Di~ay Memory Size
CR36 7-5 7-5 000 4 M~tes
001 Reserved
010 3 MBytes
011 Reserved
100 2 M~tes
101 Reserved
110 1 MByte
111 Reserved
Setl!P_ Select (VL-Bus)
CR37 0 8 0 Disable Vision864 exce_0 for Video BIOS accesses
1 Enable Vision 864
Test Mode
CR37_ 1 9 0 All outputs except OE tri-stated and all bi-directional pins
become inputs
1 Normal operation. Certain outputs required for the reset
_Qrocess are not tri-stated during_ reset
Video BIOS ROM Size (VL-Bus)
CR37 2 10 0 64-K~e video BIOS
1 32-K~e video BIOS
Dual CAS Select
CR37 3 11 0 Dual WE byte select
1 Dual CAS trite select
Disable LOCNSRDY for RAMDAC Writes (VL-Bus)
CR37 4 12 0 Disable LOCA/SRDY for RAMDAC writes
1 Enable LOCA/SRDY for RAMDAC writes
.. 9005049 0000767 8Tb ..
5-2 RESET AND INITIALIZATION

Vision864 Graphics Accelerator
SJ Incorporated
Table 5-1.  Definition of PD[23:0] at the Rising Edge of the Reset Signal (Continued)
| CR Bits  | PD Bits  Value  | Function  |     |     |
| -------- | --------------- | --------- | --- | --- |
Monitor Identification
CR37_7-5  15-13  The S3 video BIOS uses these bits for monitor information
CAS/OE Low Stretch
| CR68  1-0  |        |                              |     |     |
| ---------- | ------ | ---------------------------- | --- | --- |
|            | 17-16  | 00  6.5 ns del'!}'Jnominal)  |     |     |
|            |        | 01  5 ns delay (nominal)     |     |     |
|            |        | 10  3.5 ns delay (nominal)   |     |     |
11
No del~
Memory_ Address D~h Select
| CR68 3-2  | 19-18  | 00  Reserved                       |     |     |
| --------- | ------ | ---------------------------------- | --- | --- |
|           |        | 01  Reserved                       |     |     |
|           |        | 10  Reserved                       |     |     |
|           |        | 11  256K (512 rows x 512 columns)  |     |     |
RAS Low Timin_g_ Select
| CR68 5-4  | 21-20  | 00  6.5 MCLKs  |     |     |
| --------- | ------ | -------------- | --- | --- |
|           |        | 01  5.5 MCLKs  |     |     |
|           |        | 10  4.5 MCLKs  |     |     |
3.5 MCLKs
11
RAS Pre-Cha~e Timin_g_ Select
| CR68 7-6        |     | 00  Reserved   |                                  |     |
| --------------- | --- | -------------- | -------------------------------- | --- |
|                 |     | 01  4.5 MCLKs  |                                  |     |
|                 |     | 10  3.5 MCLKs  |                                  |     |
|                 |     | 11  2.5 MCLKs  |                                  |     |
| 5.4  TEST MODE  |     | Table 5-2.     | Signals Tri-Stated by Test Mode  |     |
S!.9._nal Name
| Upon power-on reset,  | most Vision864 output  |     |     |     |
| --------------------- | ---------------------- | --- | --- | --- |
pins are tri-stated. However, some must be kept  VCLK
active to support the reset process. To facilitate  HSY NC
| bed-of-nails testing  | at the PCB  | level, the  |     |     |
| --------------------- | ----------- | ----------- | --- | --- |
VSYNC
Vision864 incorporates a test mode thattri-states
all output pins except OE[1:0] (which are driven  BLANK
high) and GD[3:0] (which are driven as outputs}  STWR
and makes all bi-directional pins inputs. To enter  RASO
this mode, power-on strapping bit9 (CR37, bit 1)  CAS[7:0]
must be pulled low prior to and at reset. The
WE[1:0]
outputs that are normally not tri-stated on reset
but which are tri-stated in test mode are shown
in Table 5-2. The Vision864 remains in test mode
as long as the reset signal is held low.
| .. 9005049  | 0000768  | 732  ..  | RESET AND INITIALIZATION  | 5-3  |
| ----------- | -------- | -------- | ------------------------- | ---- |

Vision864 Graphics Accelerator
53 Incorporated
Section 6: System Bus Interfaces
The Vision864 interfaces to either a PCI bus or a allow memory space access. Bit O of the PCI
VESA local bus (VL-Bus). This section describes Command register must be set to 1 to allow 1/0
the connections and functional characteristics of space access.
these interfaces.
Figures 6-3 and 6-4 show two examples of PCI
bus disconnection. These examples show cases
6.1 PCI BUS INTERFACE
where data is transferred after STOP is asserted.
In example A, data is transferred after FRAME is
The Vision864 provides a complete PCI interface. deasserted because the master was not ready
Power-on strapping bits 1-0 must be set to 10b to (IRDY deasserted on clock 2). In example B, data
enable this interface. The pinout and other speci is transferred before FRAME is deasserted. See
fications are in complete conformance with Revi the PC/ Local Bus Specification for a complete
sion 2.0 of the the PCI specification. No glue logic explanation of disconnects. Bit 7 of the CR66
is required. register must be set to 1 to enable PCI discon
nects.
6.1.1 PCI CONFIGURATION
The PCI configuration register space occupies
256 bytes. When a configuration read or write
The Vendor ID register (Index OOH) in the PCI command is issued, the AD[7:0] lines contain the
Configuration space is hardwired to 5333H to address of the register in this space to be ac
specify S3 Incorporated as the vendor. The De cessed. Figures 6-5 and 6-6 show the configura
vice ID register is hardwired to 88COH or 88C1H tion read and write cycles respectively. The
to specify the Vision864. Bits 10-9 of the Status Vision864 supports or returns O for the first 64
register (Index 06H) are hardwired to 01 b to spec bytes of configuration space.
ify medium DEVSEL timing. Bit O of the Program
ming Interface register (Index OAH) is hardwired The Vision864 drives even parity information
to 1 to specify that the Vision864 supports the onto the PAR line during read transactions. This
standard VGA programming interface. Bits 3-0 of operation is depicted in Figure 6-7.
the Base Address O register (Index 10H) are hard
wired to OOH. This indicates that the "prefetch
able" bit is cleared to 0, the base register can be
located anywhere in a 32-bit address space and
the base register is located in memory space.
6.1.2 PCI Bus Cycles
Figures 6-1 and 6-2 show the basic PCI read and
write cycles respectively. Bit 1 of the PCI Com
mand register (Index 04H) must be set to 1 to
.. 9005049 0000769 679 .. SYSTEM BUS INTERFACES 6-1

=·
r
Vision864 Graphics Accelerator
53 Incorporated
T1 T2 T3 T4 TS T6
SCLK
I
\
FRAME I
I
AD[31:0) ADD5ESS )- ~--{ DAJA 1 x DAlA2 x DAlA3 }-0
I I I I I
C/BE[3:0) BUS~MD x : : BE'S : I }-0
I l__j
-0:---y_I
IRDY I I I I
I I I I
-01 I \ I I I I
TROY I I I I I
-01 I I I I
I I \ I I I I
DEVSEL
I I I I I
BASE READ
Figure 6-1. Basic PCI Read Cycle
T1 T2 T3 T4 TS T6
SCLK
I
\ I
I
FRAME
I
AD[31:0) ADD~ESS x : DATA 1 x DA~A2 x DA[A3 }-o
I I I I
C/BE[3:0] BUS~MD x : BE'S 1 x ~$2 x ~$ : 3 _ _ }- J o
I
-o~
IRDY I I I
I I I I
-01 \ I I I
TROY
I I I
-ol I I
\ I
I I I
DEVSEL
I
BASEWRT
Figure 6-2. Basic PCI Write Cycle
• •
9005049 0000770 390
6-2 SYSTEM BUS INTERFACES

••
r
Vision864 Graphics Accelerator
S3 Incorporated
|     |     |     | T1  |     | T2  |     | T3  |     | T4  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
SCLK
~
|     | FRAME  |     |     |     |     |     |     | I   |     |
| --- | ------ | --- | --- | --- | --- | --- | --- | --- | --- |
I
I
IRDY
TROY
|     | --I-  |     | ;,  | I   |     |     |     |     |     |
| --- | ----- | --- | --- | --- | --- | --- | --- | --- | --- |
|     |       |     |     | I   |     |     | I   |     |     |
|     | STOP  |     |     | cb  |     |     |     |     |     |
I
|     |     | I   |     | I   |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|     |     | I   |     | I   |     |     | I   |     |     |
DEVSEL
|     |     | I   |              | I                         |     |     |     |          |     |
| --- | --- | --- | ------------ | ------------------------- | --- | --- | --- | -------- | --- |
|     |     | I   |              | I                         |     |     |     | DISCONA  |     |
|     |     |     | Figure 6-3.  | PCI Disconnect Example A  |     |     |     |          |     |
|     |     |     | T1           |                           | T2  |     | T3  |          | T4  |
SCLK
|     |     | !   |     | !___r---t-?- |     |     |     |     |     |
| --- | --- | --- | --- | ------------ | --- | --- | --- | --- | --- |
FRAME
|     | --:1-----,I  |     |     |     |                   | I   |     | I   |     |
| --- | ------------ | --- | --- | --- | ----------------- | --- | --- | --- | --- |
|     |              | I   |     | I   |                   | I   |     | I   |     |
|     |              | I   |     | I   |                   | I   |     |     |     |
|     |              | I   |     |     |                   | I   |     |     |     |
|     | --1          |     |     |     |                   | I   |     |     |     |
|     |              | I   |     |     | ..+-++---__,,___  |     |     |     |     |
I
I
- --t-
|     |     | 1                    |     |     |     |     |     | I   |     |
| --- | --- | -------------------- | --- | --- | --- | --- | --- | --- | --- |
|     |     | I                    |     |     |     |     |     | I   |     |
|     |     | I                    |     |     |     | I   |     | I   |     |
|     |     | I                    |     |     |     | I~  |     |     |     |
|     |     | ![------:--------'!  |     |     |     |     |     | I   |     |
DISCONB
|             |          |     | Figure 6-4.  | PCI Disconnect Example B  |     |     |     |     |     |
| ----------- | -------- | --- | ------------ | ------------------------- | --- | --- | --- | --- | --- |
| .. 9005049  | 0000771  |     | 227          | ..                        |     |     |     |     |     |
SYSTEM BUS INTERFACES  6-3

Vision864 Graphics Accelerator
S3 Incorporated
T1 T2 T3 T4 T5 T6
SCLK
b-
_ _L __I ~
I
I I \
FRAIVIE t---+--c$=J--I+ -
I I I
i •
AD[31:0) ADDfESS
~
+-
IDSEL
}---+-
---1-{
x i
C/BE[3:0) - CFG RtAD i BE'S
r-
i- i \ /
0
IRDY I
I I I I
TROY -I - 0 I - I \ /~---1-
1 I I . . I
CFGREAD
Figure 6-6. PCI Configuration Write Cycle
T1 T2 TJ T4
SCLK
I I I I I
- -+ - I
-1 ~ II I ~-
I I \ . I I
FRAME
I I I I I
AD[31:0] ! • ADDRrss x D+A ~~-
I I I I I
IDSEL-~
I I I I I
~ I I I
C/BE[3:0] - T - --j CFG W~ITE ~S ~ -
I I I
f-- -Of- - ---t ~ I I
I I I \ I
I I I I
f-- -Of- - ---t ~ I
J
I I I \
lcFGWRITE
I I I I
Figure 6-5. PCI Configuration Write Cycle
• 9005049 0000772 163 • ------------
6-4 SYSTEM BUS INTERFACES

Vision864 Graphics Accelerator
S3 Incorporated
|     | T1  | T2  | T3  | T4  | T5  |
| --- | --- | --- | --- | --- | --- |
SCLK
|     | I   |     | I   |     |     |
| --- | --- | --- | --- | --- | --- |
--1\
|     |     | I   | I   |     |     |
| --- | --- | --- | --- | --- | --- |
I
| FRAME     |     |          | I   |     |     |
| --------- | --- | -------- | --- | --- | --- |
|           | I   |          | I   |     |     |
|           | I   | r----9   |     |     |     |
| AD[31:0]  |     | ADDRrss  |     |     |     |
I
|     | I   | I   | I   | I   |     |
| --- | --- | --- | --- | --- | --- |
|     | I   | I   |     |     | c   |
----cp-~
PAR
|     | I   | I   |     |     | PARITY  |
| --- | --- | --- | --- | --- | ------- |
I
Figure 6-7. Read Parity Operation
6.2  VL-BUS INTERFACE  latched by the Vision864 on one of two rising
SCLK edges as shown in Figure 6-10 and ex
plained in No~he programmability of the
Power-on strapping bits 1-0 must be setto 01 b to
gap between ABEN deasser~ed. and ~BE~ as
enable VL-Bus operation. Because the address
serted and vice versa is also indicated 1n Figure
and data busses are multiplexed on the same
6-10 and explained by Note 2. During this gap,
pins, a VL-Bus interface requires glue logic to
the address/data bus is tri-stated and switches
provide the correct bus information and direc
from address input to data output. The progress
tion. Figure 6-8 shows how eight F245-type de
of the data back through the interface buffers to
vices are configured to provide the necessary
the VL-Bus is not shown on the diagram.
control. One or more specialized ASICs are avail
able to reduce the number of chips required to
The basic VL-Bus write cycle is shown in Figure
provide this interface. The buffer enables (ABEN
6-11. The cycle is similar to a read cycle except
and DBEN) and the data buffer direction signal
there is no bus turnaround when the direction of
(DBDIR) are provided by the Vision864.
the interface buffers is reversed. The single wait
state is the default configuration. This can  be
o
6.2.1  VL-Bus Cycles  changed to  wait-states (SRDY asserted  one
cycle earlier) by clearing bit 4 of CR40 to 0. The
address is latched at the end of T1. By default,
The basic VL-Bus read cycle ~shown i!! Figure
write data is latched on the first rising SCLK edge
6-9. Note that the A[31 :2], M/10 and W/R inputs
after the assertion of RDYI N. This can be changed
from the VL-Bus must first pass through the in
to the first rising SCLK edge after the assertion of
| terface buffers, which in  |     | turn feed AD[31:2],  |     |     |     |
| -------------------------- | --- | -------------------- | --- | --- | --- |
SRDY by setting bit 5 of CR40 to 1.
SM/10 and SW/R to the Vision864. The address is
| II  9005049  | 0000773  | OTT  II  |     |                        |      |
| ------------ | -------- | -------- | --- | ---------------------- | ---- |
|              |          |          |     | SYSTEM BUS INTERFACES  | 6-5  |

Vision864 Graphics Accelerator
53 Incorporated
VESA
LO CAL BUS
/)... Vision864
A(31:~ FOUR
SW/R 74F245s
SM/ID
(ll.- ABEN
DIR ·vvv-VCC
ADl31:0]
FOUR
74F245s
D[31:0)
G DBEN
DIR DBDIR
LOCAL BUS CONTROL
v
VLBUSlF
Figure 6-8. VL-Bus Interface
6.2.2 SRDY Generation
For a VL-Bus configuration, the Vision864 raises
its SRDY output early in the Ti cycle and then
tri-states it. It then asserts SRDY to signal the end
of the cycle. Some systems synchronize or oth
erwise delay this signal and then assert RDY to
the processor. If this is done, this RDY signal
should also be fed to the RDYIN input of the
Vision864 {see Note 3 of Figure 6-9). The Vi
sion864 holds read data active until RDYIN is
asserted. If the SRDY signal is not intercepted, it
should be fed to both the processor RDY input
and the Vision864 RDYIN input.
386 RESET
6.3 LOCAL BUS CLOCKING
CLK2
The Vision864 expects a 1X SCLK like that used
in a 486 system. Figure 6-9 shows one possible
circuit for building such a 1X clock from the 386
2X clock. Since the Vision864 requires a clock
during reset, any circuit used to generate a syn SETS AND RESETS SHOWN
AS UNCONNECTED SHOULD
chronized 1X clock must be free-running during BE PULLED UP
reset.
Figure 6-9. 1X Clock Generation
.. 9005049 0000774 T3b ..
6-6 SYSTEM BUS INTERFACES

••
r
Vision864 Graphics Accelerator
53 Incorporated
|     |     |     | T1  |     | T2  | T3  |     | T4  | TS  |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
SCLK
|     |     | -~I  | ----.  | I   |     |     | I   |     | I   | I     |
| --- | --- | ---- | ------ | --- | --- | --- | --- | --- | --- | ----- |
|     |     |      | I      |     |     |     | I   |     | I   | I\__  |
'~--i~/
|     | Al31 :2)  |     | I  (  | I   |     | I   | )11  |     | I   | I   |
| --- | --------- | --- | ----- | --- | --- | --- | ---- | --- | --- | --- |
M/io --+1- --i
|     |     |      |                                   | ~o INTERFACE BPFFERs  |     |     | .·  |     | 1          | 1   |
| --- | --- | ---- | --------------------------------- | --------------------- | --- | --- | --- | --- | ---------- | --- |
|     |     |      | I  '----'1-----'--1-NO_T_E_1__,I  |                       |     |     |     |     | I          | I   |
|     |     | W/R  |                                   |                       |     |     |     |     | !----!...  |     |
--+-!
|     | ss~~~g~  |     |     | i   |     | it -o  | -1.__: ___o _A_T~  |     |     | r--- |
| --- | -------- | --- | --- | --- | --- | ------ | ------------------ | --- | --- | ---- |
ADDRESS
|     |      |            | ---1  |     |     |     |     |     | .....  |      |
| --- | ---- | ---------- | ----- | --- | --- | --- | --- | --- | ------ | ---- |
|     |      |            | 1     | I   | \   | I   | I   |     | I      | I/   |
|     |      |            | I     | I   |     | I   | I   |     | I      | I    |
|     | :::  | ~~~~I~ ~\  | __    |     |     |     |     |     |        | I~)  |
1
|     |        |     |                                     | __._i ___.. ....  |     | _C_t_No-T-+-it2----i-! ___. ....  |     |     |                              |     |
| --- | ------ | --- | ----------------------------------- | ----------------- | --- | --------------------------------- | --- | --- | ---------------------------- | --- |
|     |        |     | I                                   | I                 |     |                                   |     |     | I                            | I   |
|     |        |     | I                                   | I                 |     |                                   |     |     | I                            | I   |
|     |        |     | I                                   | I                 |     | \.___.,.... __                    |     |     |                              |     |
|     |        |     |                                     |                   |     |                                   |     |     | _, _ !_  _.. .,.........{!   |     |
|     | DBDIR  |     | I                                   | I                 |     |                                   |     |     | I                            |     |
|     |        |     | I r........,1..----+----+--.....,,  |                   |     |                                   |     |     | I                            |     |
I
|     |     |          |     | I   |     |     | I   |     |          | I   |
| --- | --- | -------- | --- | --- | --- | --- | --- | --- | -------- | --- |
|     |     | ---.-1~  |     |     |     |     |     |     | .__~I~~  |     |
v---+--
~
|     |        | _jI)  |     | 1   |     |     | I                 |     | I      |          |
| --- | ------ | ----- | --- | --- | --- | --- | ----------------- | --- | ------ | -------- |
|     |        |       |     |     |     |     | 1NOTE3.-A' \_I_ - |     | J\\-_  | _._I __  |
|     | RDYIN  |       |     | 1   |     |     |                   |     |        |          |
|     |        |       | I   | I   |     |     | I                 |     | I      | I        |
VLREAI
Figure 6-10. VL-Bus Read Cycle
Notes
1. The address is latched on the first clock edge indicated here if bit 3 of CR58 is set to 1. If this bit
is cleared to 0, the address is latched on the second clock edge indicated.
2. The non-overlap time between ABEN deasserted and DBEN asserted (and vice versa) is program
mable via bits 7-6 of CR40.
3.  The system chip set can delay the RDYIN input by 1 or more cycles. This example assumes a 1
cycle delay, as indicated by the solid line. Note that read data is held valid an extra cycle .
| .. 9005049  |     |     | 0000775  |     | 972  | ..  |     |                        |     |      |
| ----------- | --- | --- | -------- | --- | ---- | --- | --- | ---------------------- | --- | ---- |
|             |     |     |          |     |      |     |     | SYSTEM BUS INTERFACES  |     | 6-7  |

Vision864 Graphics Accelerator
S3 Incorporated
|     |     | T1  | T2  | T2  | T1  |
| --- | --- | --- | --- | --- | --- |
SCLK
|     |     | \   | I   | I   | L   |
| --- | --- | --- | --- | --- | --- |
I
|     | SADS     |     |     | I   |     |
| --- | -------- | --- | --- | --- | --- |
|     |          |     | ro  | I   |     |
|     | Al31:21  | (   |     | }i  |     |
INTERFACE ~UFFERS
M/iO
W/R
|     |     |     | ,I. .   ·'  | I   |     |
| --- | --- | --- | ----------- | --- | --- |
NOTE 1
I  I
ADl31:21
|     |           |     | i}        |       | }-- |
| --- | --------- | --- | --------- | ----- | --- |
|     | SM/f0/01  |     | :ADDRESS  | rATA  |     |
SW/R/DO
|     |     |     | I   | I   |     |
| --- | --- | --- | --- | --- | --- |
|     |     |     | \   | I   | I   |
LOCA
I
I
I
ABEN
NOT~
2
I
|     | DBEN  |     |     | I   |     |
| --- | ----- | --- | --- | --- | --- |
VLWRITE
Figure 6-11. 1 Wait-state VL-Bus Write Cycle
Notes
1.  For one decode wait state (bit 4 of CR40 set to 1) , the address is latched on the first clock edge in
dicated here if bit 3 of CR58 is set to 1. If this bit is cleared to 0, the address is latched on the
second clock edge indicated.
2. The non-overlap time between ABEN deasserted and DBEN asserted (and vice versa) is program
mable via bits 7-6 of CR40
3.  The wait-state is inserted by setting bit 4 of CR40 to 1 to delay SRDY assertion by 1 cycle from
the assertion of SADS. This is the default value.
4.  Data is normally latched on the rising SCLK edge following assertion of RDYIN. This can be
changed to the rising clock edge following the assertion of SRDY by setting bit 5 of CR40 to 1.
| .. 9005049                  | 0000776  | 809  ..  |     |     |     |
| --------------------------- | -------- | -------- | --- | --- | --- |
| 6-8  SYSTEM BUS INTERFACES  |          |          |     |     |     |

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Section 7: Display Memory
The Vision864 supports a DRAM-based video In dual-WE mode, the CAS and WE lines are
frame buffer. This section describes the various swapped. That is, the eight CAS lines are con
configurations supported, the functional timing nected to the WE inputs on the DRAMs and the
for memory accesses and the operation of vari two WE lines are connected to the CAS inputs on
ous register bits that affect memory timing and the DRAMs. This is illustrated in Figure 7-3 for a
operation. It also describes how access to display 1-MByte configuration. Note that only PD[31:0)
memory is controlled to maximize graphics per are used for 1-MByte configurations. The swap
formance and how the Vision864 can share the ping of CAS and WE is required for x4 DRAMs if
frame buffer with a secondary memory controller the Vision864 is placed in dual-WE mode on
for multimedia applications. reset.
Two memory address busses {MA[8:0) and
7 .1 DISPLAY MEMORY
M8[8:0)) are provided. MA[8:0) control PD[15:0)
CONFIGURATIONS and PD[47:32). MB[8:0) control PD[31:161 and
PD[63:45).
The Vision864 provides direct support for 1-, 2-,
and 4-MByte DRAM configurations. Either fast
page mode or extended data out {EDO) DRAMs
can be used. These can be configured as 256Kx4
or 256Kx16. 53 Tech Note TN024, DRAMs Sup
ported by the S3 Vision864, lists recommended
DRAMs.
The Vision864 has a dual-CAS mode for x16
DRAMs with two CASes and one WE. It also has
a dual-WE mode for x16 DRAMs with two WEs
and one CAS. Power-on strapping bit 11 is pulled
high on reset to select dual-CAS mode and low
to select dual-WE mode.
In dual-CAS mode, the Vision864's CAS lines
connect to the CAS lines on the DRAMs and select
which bytes are accessed. The Vision864's two
WE lines select which 2-MByte bank is accessed.
Figure 7-1 shows a 2-MByte configuration using
256Kx4 DRAMs. Figure 7-2 shows a 4-MByte con
figuration using 256Kx16 DRAMs. These configu
rations assume that dual-CAS mode is being
used .
.. 9005049 0000777 745 ..
DISPLAY MEMORY 7-1

I
..JJ
-.J
iZl  Cl
Cl
| U1  |     |     |     |     |     |     |     |     | f\   |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | ---- |
0
(ii  Cl
- 0  ..i=
r
| )>  ..JJ  | PDl63:01  |     |     |     |     |     |     |     | ...  |
| --------- | --------- | --- | --- | --- | --- | --- | --- | --- | ---- |
-<
| ~  Cl  |     |     |     | PD[11:81  |     | PDl35:32J  |     |     |     |
| ------ | --- | --- | --- | --------- | --- | ---------- | --- | --- | --- |
m  Cl
~  Cl
0  Cl
:-:<0
~
~
| ():I  |     |     |     | n   |     |     |     |     |     |
| ----- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
n
.,,
| e r         |     |     |     |     |      |             | ti  |                      |     |
| ----------- | --- | --- | --- | --- | ---- | ----------- | --- | -------------------- | --- |
| c. a.  ·    |     |     |     |     | 256K | x4          |     | 256Kx4  [J.Q[47'44L  |     |
| ( ): I  c   |     |     |     |     | M    |   lro'~'"l  |     |                      |     |
1::-'
CD
I  ';'I
~
N
| 3 :  | MA]8:0]  |     |     |     |     |     |     |     |     |
| ---- | -------- | --- | --- | --- | --- | --- | --- | --- | --- |
n
ca
| "S  Vision864  |     |           |     |         |     |          |     | 256Kx4  I PD[59:56]  |     |
| -------------- | --- | --------- | --- | ------- | --- | -------- | --- | -------------------- | --- |
|                |     | lro"'"'l  |     | 1'~"'1  |     | 1~"'"'1  |     |                      |     |
CD
c
:ti
)>
:ii:
-0
0
: : I
| c. a .  ·   |     |            |     |            |     |     |     |            | <           |
| ----------- | --- | ---------- | --- | ---------- | --- | --- | --- | ---------- | ----------- |
|             |     | PD[23'20)  |     | PD[31:28]  |     |     |     | PDl63:60)  |             |
| c           |     |            |     |            |     |     |     |            | a iii" ·    |
IO
| ::t.  |     |     |     |     |     |     |     |     | ::I    |
| ----- | --- | --- | --- | --- | --- | --- | --- | --- | ------ |
| 0     |     |     |     |     |     |     |     |     | e0n0   |
: : I
.j:>.
C...>
|     | I  I  |     | I  I  |     | I  I  |     | I   | I   | I  I  Ill  |
| --- | ----- | --- | ----- | --- | ----- | --- | --- | --- | ---------- |
MB[8:01
"C  ::r
c:;·
D2MBX4
|     | RAM  |     |     |     |     |     |     |     | en  |
| --- | ---- | --- | --- | --- | --- | --- | --- | --- | --- |
CONTROL
l>
(')
| ___J  |     |     |             |     |     |     |             |     | (')  CD  |
| ----- | --- | --- | ----------- | --- | --- | --- | ----------- | --- | -------- |
|       |     |     | ,sr MByte.  |     |     |     | 2ND MByte.  |     | .iD..    |
Ill
....+.
0

I
l \
.J]
CJ
CJ
tn
| C J    |     |     |     |     |     | ..   |
| ------ | --- | --- | --- | --- | --- | ---- |
| ..r :  |     |     |     |     |     | ...  |
.J]
CJ
CJ
CJ
CJ
~
~  PDl64 0]
.J]  "Tl
cE"
.c..
tn
1 : -'   I.D... .
° "
"'
I
""
~
MAIS 01
m
~
Vision864
ID  c
1RASO  OEO
| ::0  | RASO   |     |       |     |       |     |
| ---- | ------ | --- | ----- | --- | ----- | --- |
| )>   | CAS2   |     | CAS6  |     | CAS6  |     |
| s::  | ICAS3  |     | CAS7  |     | CAS7  |     |
(")
| 0  MBIBOJ  |     |     |     |     | D4MBX16  |     |
| ---------- | --- | --- | --- | --- | -------- | --- |
| :I         |     |     |     |     |          | <   |
::!l
C .cC I
| ..   RAM CONTROL  |     |     |     |     |     | 11?:  |
| ----------------- | --- | --- | --- | --- | --- | ----- |
0
| II>  c:!:  |     |               |        |               |     | :I      |
| ---------- | --- | ------------- | ------ | ------------- | --- | ------- |
| 0          |     | y             |        | \_  ----y     | J   |         |
|            | \_  |               | ·--_J  |               |     | 00      |
| : I        |     |               |        |               |     | ~       |
| I          |     | 1ST z MBytes  |        | zND 2 MBytas  |     | G...)   |
0
Ill
| Ui    |     |     |     |     |     | "'C     |
| ----- | --- | --- | --- | --- | --- | ------- |
| " lJ  |     |     |     |     |     | :: r    |
| r     |     |     |     |     |     | c :; ·  |
| '.!<  |     |     |     |     |     | (II     |
l>
~
| m   |     |     |     |     |     | ci    |
| --- | --- | --- | --- | --- | --- | ----- |
| ~   |     |     |     |     |     | c i   |
CD
| 0   |     |     |     |     |     | .C.D. '  |
| --- | --- | --- | --- | --- | --- | -------- |
:-:<0
Ill
| .....  |     |     |     |     |     | .....+   |
| ------ | --- | --- | --- | --- | --- | -------- |
0
w

••
r
Vision864 Graphics Accelerator
S3 Incorporated
PD[31:01
MA[S:OJ 256Kx16 P~15:Ql
OEO
RASO
~~o WEO
~4[1 WE1
WEO CASO
Vision864
MBIB:Ol 256Kx16 PD[31:1fil.
OEO _.®
RASO R~
CAS2 WE2
CAS3 w~
CAS[3:0) _m_
CASO
WEO
DDUALWE
Figure 7-3. 1-MByte Dual-WE DRAM Configuration
7.2 DISPLAY MEMORY REFRESH
The Vision864 uses the standard CAS before RAS
RAM refresh method. The functional timing for
this can be found in any standard DRAM data
book.
The number of refresh cycles performed per hori
zontal line is determined by bit 6 of CR11. If bit 2
of CR3A is set to 1, the number of refresh cycles
per horizontal line is determined by the setting of
bits 1-0 of CR3A.
.. 9005049 0000780 23T ..
7-4 DISPLAY MEMORY

Vision864 Graphics Accelerator
S3 Incorporated
7 .3 DISPLAY MEMORY allow the pulse widths of the CAS and OE signals
FUNCTIONAL TIMING to be adjusted. Bits 5-4 of CR68 allow adjustment
of the RAS low time. Bits 7-6 of CR68 allow
adjustment of the RAS precharge {high) time. All
Figure 7-4 shows the functional timing for a fast of these settings in CR68 can be made by power
page mode read cycle. This also shows how on strapping of PD[23:16) at reset or by program
certain parameters for various control signals ming after reset.
can be adjusted to meet the access time require
ments of a variety of DRAMs. Bits 1-0 of CR68
T1 T2 T3 T4 TS T6 T7 TS T9 T10
_;~
CAS ....
.....___
WA._ ___
}Bm
MA[8:0] __,X._ __
R_o__w __ c_o_w_M_N__,X COLUMN
MB[8:0]
\.___.!J;\__j_;~
"-.... SEE NOTE 3 ~
P0[63:0]
MEMRD
Figure 7-4. Fast Page Mode Read Cycle
Notes
1. The minimum RAS precharge time can be adjusted from 2.5 to 4.5 MCLKs via bits 7-6 of CR68.
2. The minimum RAS low time for a single column access is 3.5 MCLKs as shown in this figure.
(The dashed line shows the RAS signal if the second page mode cycle were to be eliminated.)
This minimum RAS active time can be lengthened to 4.5, 5.5 or 6.5 MCLKs via bits 5-4 of CR68.
3. The CAS and OE active (low) times can be stretched via bits 1-0 of CR68 .
.. 9005049 0000781 176 ..
DISPLAY MEMORY 7-5

Vision864 Graphics Accelerator
S3 Incorporated
Figure 7-5 shows the functional timing for a fast The write-per-bit feature provided by some
page mode write cycle. The RAS and CAS signals DRAMs is supported by the Vision864 if bit 0 of
can be adjusted as explained for the read cycle CR53 is set to 1. This is indicated by the WPB
above. The WE and CAS signals are equally Mask in Figure 7-5.
stretched via bits 1-0 of CR68.
T1 T2 T3 T4 T5 T6 T7 T8 T9 T10
1+---
MCLK
}---
---,
SEE NOTE 2
-------
\
CAS rr:>-----1-·~
SEE NOTE 3
x x
MA[8:0) .-A( ROW COLUMN COLUMN ~
MB[8:0)
\
WE rr:>-----1-·~
SEE NOTE 3
FA x
PD[63:0] WPB ~ DATA DATA ~
Figure 7-5. Fast Page Mode Write Cycle
Notes
1. The minimum RAS precharge time can be adjusted from 2.5 to 4.5 MCLKs via bits 7-6 of CR68.
2. The minimum RAS low time for a single column access is 3.5 MCLKs as shown in this figure.
(The dashed line shows the RAS signal if the second page mode cycle were to be eliminated.)
This minimum RAS active time can be lengthened to 4.5, 5.5 or 6.5 MCLKs via bits 5-4 of CR68.
3. The CAS and OE active (low) times can be stretched via bits 1-0 of CR68.
.. 9005049 0000782 002 ..
7-6 DISPLAY MEMORY

Vision864 Graphics Accelerator
53 Incorporated
Figure 7-6 shows the functional timing for an that RAS, the last CAS and OE are all stretched
Extended Data Out (EDO) mode read cycle. One one MCLK. With EDO, OE is held low for the entire
difference between an EDO read cycle and a fast cycle instead of being pulsed as in a fast page
page mode read cycle is that since EDO memory mode cycle.
holds the data valid longer, it allows the data to
be latched one cycle later (rising edges of TS and The timing adjustments for RAS and for
T10). This allows the use of slower access time CAS/OE/WE as described above for a fast page
memory or a faster MCLK. However, the last page mode read cycle also apply to EDO cycles. Note
access (or first for a single access) must be that if the minimum RAS active time is specified
stretched one MCLK to allow the data to be as 3.5 MCLKs, the actual minimum for a single
latched because EDO memory does not keep EDO read cycle will be 4.5 MCLKs.
data valid after OE goes inactive. Despite this,
EDO memory will generally provide better per An EDO write cycle is functionally the same as a
formance than fast page mode memory. Note fast page mode write cycle.
T1 T2 T3 T4 T5 T6 T7 TB T9 T10
+r---
MCLK
l-------------,
SEE NOTE 1
\.__----'~-~
SEE NOTE 3
WM.... . ____
MA[8:0) __,X.. ... __ _,X )mR
MB[8:0) R_o_w_ __ c_o_L_u_M_N_ COLUMN
\ G
NOTE~·~
SEE
__,;mj
~...._ ___,X,_ __
PDIGJ:oJ __o_ A_T_A_ o_A_T_A_
EDOMEMR
Figure 7-6. EDO Mode Read Cycle
Notes
1. The minimum RAS precharge time can be adjusted from 2.5 to 4.5 MCLKs via bits 7-6 of CR68.
2. The minimum RAS low time for a single column access is 4.5 MCLKs as shown in this figure.
This is achieved by specifying 3.5 MCLKs in bits 5-4 of CR68. (The dashed line shows the RAS
signal if the second page mode cycle were to be eliminated.) This minimum RAS active time
can be lengthened by 1, 2 or 3 MCLKs via bits 5-4 of CR68.
3. The CAS and OE active (low) times can be stretched via bits 1-0 ofCR68.
.. 9005049 0000783 T49 ..
DISPLAY MEMORY 7-7

••
r
Vision864 Graphics Accelerator
S3 Incorporated
7 .4 DISPLAY MEMORY ACCESS When the Vision864 transfers data from display
memory to the FIFO, the N parameter specifies
CONTROL
one less than the number of 4-byte (1 MByte of
memory) or 8-byte (2 or 4 MBytes of memory)
Figure 7-7 shows that a number of processes units to write. When N units have been written or
compete for access to display memory. These are the FIFO is filled, whichever comes first, the
(in decreasing order of access priority): Vision864 then allows the other display memory
processes access to memory. Filling of the FIFO
• RAM refresh (not explicitly shown) also stops at the end of active display as defined
• Display FIFO writes by the L parameter. FIFO filling cannot begin
again until the scan line position defined by the
• CPU accesses
Start Display FIFO register (CR3B), which is nor
• Graphics Engine accesses mally programmed with a value 5 less than the
value programmed in CRO (horizontal total). This
The display FIFO is 32 bits wide by 16 positions provides time during the horizontal blanking pe
deep with 1 MByte of display memory or 64 bits riod for RAM refresh and hardware cursor fetch.
wide by 16 positions deep for 2 or 4 MBytes of
display memory. This FIFO provides the display The M parameter specifies the number of 8-byte
refresh data to the RAMDAC and must never memory access cycles (less one) that can be
underrun, i.e., output more data than has been performed for reasons other than display FIFO
input to it from display memory. If an underrun filling. (One entry cycle requires 6-9 MCLKs; one
occurs, the display may be corrupted. page mode cycle requires 2 MCLKs.) When this
number of access cycles has been performed,
The Vision864 provides a patented technique for memory control is returned for FIFO filling. For
maximizing video performance while preventing example, a value of01010b (10 decimal) specifies
display FIFO underrun. This involves program that 11 8-byte memory cycles are available to the
ming of three parameters. These are the L pa CPU, Graphics Engine, etc., before FIFO filling
rameter (bits 2-0 of CR61 and bits 7-0 of CR62), M restarts. For one entry cycle and 10 page mode
parameter (bits 7-3 of CR54) and N parameter cycles, this would be a maximum of 9 + (10x2) =
(bits 7-0 of CR60). 29 MCLKs allowed before memory access is re-
i__...., I
__. .%.__ ___
I
I
I
_...___,......,I
,__.___...., I
32 GRAPHICS DISPLAY 8/16
RAMDAC
ENGINE FIFO I
...__ ____ _, '-----' I
I
I
I
CPU
I I
~ _________V ~i~n~~:
M&N
Figure 7-7. Display Memory Access Sources
.. 9005049 0000784 985 ..
7-8 DISPLAY MEMORY

Vision864 Graphics Accelerator
S3 Incorporated
turned for FIFO filling. If during the processing total). Only between the start of a horizontal scan
period controlled by the M parameter there is and this value can the Vision864 give up control
time when there are no memory access requests of the pixel bus. The value of the bus grant
and the M value has not been reached, control is termination position must be enough less than
immediately returned to FIFO filling as specified the horizontal total to allowforthe required RAM
by the N parameter. refresh and hardware cursor fetch, both of which
occur during the horizontal blanking period.
M should be maximized for maximum graphics
performance. The maximum value of M possible The Vision864 pre-empts the secondary control
without causing a FIFO underrun is dependent on ler (removes BGNT} at the bus grant terminal
the pixel data bandwidth required for the partict.. position. Otherwise, it will not pre-empt the sec
lar mode in question. The calculation is based on ondary controller when filling the display FIFO is
a FIFO filling bandwidth of 120 (1 MByte) or 240 required for screen refresh. Therefore, the secon
(2 or 4 MBytes) MBytes/second. The maximum dary controller must retain control of the bus for
value is also possibly dependent on the N pa a very limited time each time it gains control or
rameter value if the FIFO is not filled each cycle. it will cause screen corruption. How long the
secondary controller can retain control without
The above discussion assumes that the causing problems is a function of many vari
Vision864 has control of the memory bus. The ables, including the L, M and N parameter set
next section describes the implications of allow tings, the pixel data bandwidth of the RAMDAC
ing a secondary memory controller to take con and the needs of the CPU and Graphics Engine
trol of the display memory bus. to access display memory. In general, the secon
dary controller should retain control for a period
less than the time that would normally be speci
7 .5 SHARED FRAME BUFFER
fied by the M parameter if there is no secondary
controller. The M parameter value then needs to
For multimedia applications, the Vision864 can be reduced by the amount of time allocated to
share the video frame buffer (display memory} the secondary controller to ensure adequate time
with a secondary controller. At all times, the for display FIFO filling. At the extreme, M could
Vision864 serves as the primary display memory be set to O (allowing 1 memory cycle) and the
controller. As the primary controller, the remaining non-display FIFO filling bandwidth al
Vision864 takes responsibility for screen man located to the secondary controller. See Section
agement functions such as RAM refresh cycles 7.4, Display Memory Access Control for more
and the arbitration of frame buffer requests from information on the Mand N parameters.
a secondary controller.
The timing diagram shown in Figure 7-8 illus
The Vision864 has two pins that are used for the trates the arbitration handshake between the
frame buffer arbitration. These pins implement a Vision864 and the secondary controller. This fig
Bus REOuest (BREQ) and Bus GraNT (BGNT) ure is explained in the following paragraphs.
protocol. BREQ is an input to the Vision864 and
BGNT is an output. When the Vision864 grants The secondary controller asserts the BREQ signal
the bus to the secondary controller, it also floats to the Vision864 to request the bus. This asyn
its memory control output signals so that the chronous input is internally synchronized by the
secondary controller has full access to the mem Vision864. If the bus grant termination position
ory. With full access to memory, the secondary value has not been reached, the Vision864 grants
controller can operate at its optimum speed for control of the pixel bus and memory control
memory accessing. signals to the secondary controller by asserting
BGNT immediately after completion of memory
The shared frame buffer function is enabled via accesses controlled by the N parameter (FIFO
bit 2 of CR50. The Bus Grant Termination Position filling} and tri-stating the memory bus signals
register (CR5F} and its extension bit (bit 7 of within 15 ns of this assertion. As indicated by "A"
CR5D) must be programmed with a value less in Figure 7-8, assertion of BGNT after assertion
than the value programmed in CRO (horizontal of BREQ occurs within the larger of 1.2 µs or the
.. 9005049 0000785 811 ..
DISPLAY MEMORY 7-9

••
r
Vision864 Graphics Accelerator
$3 Incorporated
value of the formula shown in the figure. This then able to perform read and write cycles to the
formula subtracts the bus grant termination po display memory. Return of control to the
sition (CR5F) from the horizontal total (CRO), re Vision864 can be initiated by eitherthe Vision864
sulting in some number of character clocks. This or the secondary controller.
is multiplied by 8 to convert to dot clocks and then
by the dot clock period to generate a time. At the bus grant terminate position or when the
Vision864 needs the bus, the Vision864 raises
If the bus grant termination position value has BGNT high. The secondary controller must then
been reached, the Vision864 will wait until the raise BREQ high within 500 ns, tri-state its mem
start of the next scan line (and display FIFO filling, ory bus signals within 15 ns of raising BREQ and
if required) before granting control of the bus. If give up the bus for at least 60 ns. The secondary
during the active screen {non-blanking) period controller can then reassert BREQ at any time.
the Vision864 is performing a memory cycle con Note that the Vision864 can remove its bus grant
trolled by the M parameter (CPU or Graphics in as little as one MCLK period.
Engine access) when the secondary controller
requests the bus, it completes both the M cycle The secondary controller can give up the bus by
processing and the next N (FIFO fill) cycle proc raising BREQ and tri-stating its memory bus sig
essing before asserting BGNT. If the Vision864 is nals. The Vision864 then raises its BGNT signal
filling the display FIFO when BREQ occurs during within 140 ns and begins to drive the memory
the active screen period, it continues to do so bus signals. This sequence is shown in the sec
until the FIFO is full or the amount of data speci ond bus grant cycle depicted in Figure 7-8.
fied by the N parameter is transferred to the FIFO.
In other words, the Vision864 only grants control The pixel data bus (PD) and memory address bus
of the bus at the end of display FIFO filling. (MA, MB) lines for both the Vision864 and the
Subsequent M parameter-controlled processing secondary controller connect directly to the
is then delayed until bus control is returned to the DRAM. The other memory control lines (CAS,
Vision864. lfthe bus request occurs during blank RAS, WE, OE) are typically buffered with 74F245
ing but before the bus grant termination position devices between the secondary controller and
and the processing at that time is controlled by the DRAM. This isolates the Vision864 from any
the M parameter (e.g., CPU memory updates), reflections and increases the drive. The direction
the M parameter processing will complete before (DIR) control for the '245's must be provided by
the bus grant is issued. the secondary controller. The enable inputs are
tied to ground.
When control has been granted to the secondary
controller, it keeps the BREQ signal active and is
s500 ns ,,;140 ns
Vision864
DRIVING
MEMORY BUS
SECONDARY
CONTROLLER
DRIVING
MEMORY BUS
As LARGER OF 1.2 µs OR (CRO·CR5F)•8• TDCLK
Figure 7-8. Shared Frame Buffer Protocol Timing
.. 9005049 0000786 758 ..
7-10 DISPLAY MEMORY

••
r
Vision864 Graphics Accelerator
53 Incorporated
Section 8: Miscellaneous Functions
This section explains how the Vision864 inter 8.1.1 Disabling BIOS ROM Accesses
faces to the video BIOS ROM, RAMDAC and clock
generator. The General 1/0 Ports and genlocking
If the video BIOS is integrated with the system
are also described.
BIOS in a VL-Bus configuration, then power-on
strapping bit 4 (CR36, bit 4) must be pulled low
8.1 VIDEO BIOS ROM INTERFACE to disable BIOS accesses. For PCI configurations,
bit O of the BIOS ROM Base Address register
(Index 30H) is cleared to 0 to disable BIOS ac
The video BIOS ROM contains power-on initiali
cesses.
zation, mode setup, and video data read/write
routines. The video BIOS can be part of the sys
tem ROM or it can be implemented separately.
....._
~
Vision864 BIOS ROM
374
GD[7:0] D Q A[15:8J 0[7:0] Ii-I
~
A[7:0]
RS1 CK
374
D Q
RSO ...... CK
......
CE
..... 6E
RMSTRD
810SIF
Figure 8-1. BIOS ROM PCI Configuration Interface
~ 9005049 0000787 694 ~ MISCELLANEOUS FUNCTIONS 8-1

Vision864 Graphics Accelerator
53 Incorporated
VESA
LOCAL BUS
r-
/').. A[31:2J
S S M W / / f R 5 F 2 ....
4 AD[31:0)
5
(4}
:=,
Vision864
F
2
Dl31:0) 4
5
--
(4} RMSTRD
....__
ADDRESS
BIOS
ROM
D[7:0)
5E cr
1
'I 7
l '"
74ALS465 ~I.,;
<r SA[15:0] MEMR ,_1,'
ISABUS
VLROMIF
Figure 8-2. BIOS ROM VL-Bus Configuration Interface
8.1.2 BIOS ROM Hardware Interface is asserted to drive the byte of read data to the
General Data Bus. The Vision864 latches the data
one clock before deassertion of RMSTRD. The
A separate implementation of the video BIOS for
transparent latch in the Vision864 then drives this
a PCI configuration is shown in Figure 8-1. The
data onto the AD bus.
implementation for a VL-Bus configuration is
shown in Figure 8-2. The ROM is accessed via the
The Vision864 also supports 16-and 32-bit ROM
!SA bus. This allows a shadowed BIOS to be
reads, as defined by the states of the byte en
accessed by a CPU memory read without also
ables. For a 16-bit read, the Vision864 automat
generating data directly from the physical ROM.
ically increments the lower address once and
Only 8-bit ROMs are supported.
generates the second byte of read data. For a
32-bit read, the Vision864 automatically incre
8.1.3 BIOS ROM Read Functional ments the lower address three times and gener
Timing ates the remaining three bytes of read data. In
both cases, TRDY is delayed until all the required
data is available on the AD bus.
Figure 8-3 depicts the PCI configuration func
tional timing for reading one byte from the ROM. For a VL-Bus configuration, a BIOS ROM read is
The upper 8 bits of the address are placed on the a standard !SA bus read cycle with the Vision864
General Data Bus and are latched into an external providing its RMSTRD output as a second buffer
register by the rising edge of RS1. The lower 8 enable (see Figure 8-2). RMSTRD is asserted dur
bits of the ROM address are then placed on the ing the time the ROM address is valid and there
General Data Bus and latched into a second ex fore will be active when the chipset asserts the
ternal register by the rising edge of RSO. RSO ISA MEMR signal.
goes low to enable the ROM chip and RMSTRD
.. 9005049 0000788 520 ..
8-2 MISCELLANEOUS FUNCTIONS

I
..D
| CJ  |     |     |     |     |     | f \  |
| --- | --- | --- | --- | --- | --- | ---- |
CJ
ln
| CJ  |     |     |     |     |     | cCD.   |
| --- | --- | --- | --- | --- | --- | ------ |
.s::
..D
CJ  T4  T5  T6  TI  TB  T9  no  T11  T12  T13  T14  T15  T16  T17
CJ  .,,
SCLK
CJ
| CJ  IC'  | ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  |     |     |     |     |     |
| -------- | ------------------------------------ | --- | --- | --- | --- | --- |
-...]  c
| Q::I  Cil  | FRAME  |     |     | i'  |     |     |
| ---------- | ------ | --- | --- | --- | --- | --- |
..D
00
~
| -C '        | ~C        |     |     |                |     |     |
| ----------- | --------- | --- | --- | -------------- | --- | --- |
| e r   1:11  | AD[31:0)  |     |     | :--{  ROMDATA  | )   |     |
0
-..I
CJ)
| :a  | IRDY  |     |     | :   |     |     |
| --- | ----- | --- | --- | --- | --- | --- |
I  s0:
L_J
| :a  | TROY  |     |     |     |     |     |
| --- | ----- | --- | --- | --- | --- | --- |
ID
Icl.l.
| ~   | DEVSEL  |     |     |     |     |     |
| --- | ------- | --- | --- | --- | --- | --- |
::I
| ~   | ROMSTRD  |     | BSCLKs~~~;-~---+l,--~~~~~~- |     |     |     |
| --- | -------- | --- | --------------------------- | --- | --- | --- |
i5'
| !!!.  ::I  |     |     |     |     |     | <   |
| ---------- | --- | --- | --- | --- | --- | --- |
....
|     | RS1  | \_j  |     |     |     | (ii'  cs·  |
| --- | ---- | ---- | --- | --- | --- | ---------- |
~  3·
en  s·
::I
| ( m )     cg  |      |     |     |     |     | ()0     |
| ------------- | ---- | --- | --- | --- | --- | ------- |
| r             | RSO  |     |     |     |     | 0 )     |
| );            |      |     |     |     |     | .j:li.  |
Q
| z   |           |     | x    |             | }c  | C...>   |
| --- | --------- | --- | ---- | ----------- | --- | ------- |
| m   | GD[7:0)~  |     | )c~  | j  ROMDATA  |     |         |
I ll
| 0 c     |     | UPPER    | LOWER    | :.-ROM DATA LATCHED  |     | " C   |
| ------- | --- | -------- | -------- | -------------------- | --- | ----- |
|         |     | ADDRESS  | ADDRESS  |                      |     | ::r   |
.e,n,
(;'
| c   |     |     |     |     |     | en  |
| --- | --- | --- | --- | --- | --- | --- |
z
)>
n
| ~   |     |     |     |     |     | £   |
| --- | --- | --- | --- | --- | --- | --- |
0
| z   |     |     |     |     |     | ;...-  |
| --- | --- | --- | --- | --- | --- | ------ |
en
Ill
| 0w0   |     |     |     |     |     | .r 0.+.    |
| ----- | --- | --- | --- | --- | --- | ---------- |

••
r
Vision864 Graphics Accelerator
53 Incorporated
8.1.4 BIOS ROM Address Mapping 8.2.1 RAMDAC Hardware Interface
The Vision864 maps the CPU memory address The Vision864 provides all required control sig
spaces for the video BIOS ROM into physical nals. The hardware interface to a 16-bit RAMDAC
ROM addresses. If implemented separately for a is shown in Figure 8-4. The upper eight pixel
VL-Bus system, the video BIOS normally uses the address lines are no connects for 8-bit RAMDACs.
standard address range COOOOH-C7FFFH (32
KBytes}. If power-on strapping bit 10 (CR37, bit 2)
8.2.2 RAMDAC Functional Timing
is strapped low or if bit 2 of CR37 is cleared to O
in a VL-Bus system, the video BIOS address range
becomes COOOOH-CFFFFH (64 KBytes}. PCI sys Figure 8-5 depicts the functional timing for
tems support a relocatable 64-KByte video BIOS RAMDAC internal register accesses. Read data is
address range via the BIOS ROM Base Address latched by the Vision864 on the rising edge of
configuration register (Index 30H}. DACRD and appears immediately after that on
the proper byte lane of AD[31:0].
8.2 RAMDAC/DISPLA Y INTERFACE
8.2.3 RAMDAC Color Mode
The Vision864 decodes all CPU accesses to the
RAMDAC registers. It has a 16-bit pixel address The 16-bit RAMDAC color mode is set via bits 7-4
bus and supports both 8- and 16-bit RAMDACs of CR67.
and SDACs (combined 16-bit RAMDACs and
clock synthesizers}.
Vision864 RAMDAC
....
......
GD[7:0] --,. 0[7:0]
.
......
RS[2:0] --,. RS[2:0]
......
PA[15:0l P[15:0]
....
SENSE SENSE
....
VCLK PCLK
...
DACRD RD
DACWR -,.. WR
DACIF
Figure 8-4. RAMDAC Interface
.. 9005049 0000790 189 ..
8-4 MISCELLANEOUS FUNCTIONS

••
r
Vision864 Graphics Accelerator
S3 Incorporated
|     |     |     |         |     | TS  | TS  |     |     |
| --- | --- | --- | ------- | --- | --- | --- | --- | --- |
|     |     | T1  | T2  T3  | T4  |     | T7  | TS  |     |
MCLK
|     | RS[2:0)  | - - | - - | -   | -   | - ' | -   |     |
| --- | -------- | --- | --- | --- | --- | --- | --- | --- |
DACRD
DACWR
|     | GD[7:0JIREADI  | - ' | - - | -   | -   | - '     | -   |     |
| --- | -------------- | --- | --- | --- | --- | ------- | --- | --- |
|     |                |     |     |     | _   | _, .._  |     |     |
\JJB
|     | GD[7:0J(WRITEI  | --  |     |     |     |     |     |     |
| --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
|     |                 | '   | - - | -   | ·   |     |     |     |
Figure 8-5. RAMDAC Access Functional Timing
therefore unlikely to be used with the
|     | 8.2.4  VCLK Control  |     |     |     |     |     |     |     |
| --- | -------------------- | --- | --- | --- | --- | --- | --- | --- |
Vision864.
Figure 8.6 shows how various register bits and
internal logic elements affect the DCLK input in  8.2.5  Generating Register Select
the process of generating the VCLK output. In
Signals
general:
The Vision864 has three RAMDAC register select
1.  CR67, bit 0, either leaves DCLK unchanged
or inverts it. Since it is always inverted  outputs. The RS[ 1: OJ  signals are generated by
later (after CR33), this means that invert  accesses to standard VGA RAMDAC register ad
ing it here results in a VCLK with the same  dresses according to the following table.
phase as DCLK.
|     |     |     |     |     | Table 8-1  | RS[1:0J Generation  |     |     |
| --- | --- | --- | --- | --- | ---------- | ------------------- | --- | --- |
2.  SR1, bit 3, is used for VGA modes. It selects
between DCLK and DCLK/2. Its output is
|     | called the internal dot clock.  |     |     |     | Address  |     | RS[1:0]  |     |
| --- | ------------------------------- | --- | --- | --- | -------- | --- | -------- | --- |
|     |                                 |     |     |     | 3C8H     |     | 00       |     |
3.  CR33, bit 0, selects the internal dot clock or
|     |     |     |     |     | 3C9H  |     | 01  |     |
| --- | --- | --- | --- | --- | ----- | --- | --- | --- |
bypasses it.
4.  CR66, bits 2-0, divide the clock by 1, 2, 4, 8,  3C6H  10
|     | 16 or 32. This is normally useful only for  |     |     |     | 3C7H  |     | 11  |     |
| --- | ------------------------------------------- | --- | --- | --- | ----- | --- | --- | --- |
SID RAMDACs used with VRAMs, and is
| .. 9005049  |     | 0000791  | 015  | ..  |     | MISCELLANEOUS FUNCTIONS  |     | 8-5  |
| ----------- | --- | -------- | ---- | --- | --- | ------------------------ | --- | ---- |

••
r Vision864 Graphics Accelerator
53 Incorporated
CR67_0 SR1_3
------10
CR33_3
DCLK~-11~
VCLK
D = 1/X
WHERE X = 1, 2, 4, 8, 16 OR 32 VCLKDCLK
Figure 8-6. VCLK Selection
The RS2 output is controlled by the state of bit O monitor is present, SENSE will go active only
of CR55. This should be programmed to the de when the green output is driven. If a color moni
sired value before the RAMDAC register is ac tor is present, SENSE will go active when each of
cessed to generate RS[1:0J. In older software, bit the outputs is driven. DOS uses special palette
2 of CR43 is used to generate RS2. This function colors when in monochrome mode. No S3 en
is retained for backward compatibility. hanced mode drivers use monochrome palettes.
8.2.6 Green PC Support 8.2.8 RAMDAC Write Snooping
(VL-Bus)
The Vision864 provides support for the VESA
Display Power Management Signaling (DPMS) If power-on strapping bit 12 (CR37, bit 4) is pulled
protocol by allowing independent control of the low at reset for a VL-Bus configuration, LOCA and
HSVNC and VSYNC signals. To use this capabil SRDY are not generated by the Vision864 for
ity, the bit pattern xxxx0110b must be written to RAMDAC write accesses. The Vision864 gener
the SRB register to unlock access to the SRD ates write cycles to the local RAMDAC and the
register. Bits 5-4 of SRD then control the state of ISA controller also generates cycles to an off
HSYNC and bits 7-6 of SRD control the state of board RAMDAC (mirroring). RAMDAC reads are
VSYNC. always from the local RAMDAC.
8.2.7 SENSE Input Utilization 8.2.9 Disabling RAMDAC Register
Access (PCI)
The SENSE output of the RAMDAC is used by the
S3 BIOS to detect the existence and type of moni
For PCI bus configurations, setting bit 5 of the
tor connected to the system. The BIOS sequen
Command configuration space register (Index
tially drives the three analog outputs (red, green,
04H) to 1 disables Vision864 response to
blue) and determines whether or not the SENSE
RAMDAC register accesses. This is used when a
signal is driven active. If no monitor is present,
SENSE will never go active. If a monochrome
~ 9005049 0000792 T51 ~
8-6 MISCELLANEOUS FUNCTIONS

Vision864 Graphics Accelerator
53 Incorporated
second video card is present and its RAMDAC 8.3.2 Clock Generator Access
registers require updating. Functional Timing
8.3 CLOCK GENERATOR The Vision864 drives the DCLK select signals
INTERFACE onto the GD[3:0J lines, which in turn connect to
the clock select pins on the clock chip. The clock
chip then latches these signals on the falling edge
The Vision864 receives its memory clock (MCLK)
of STWR. The functional timing for this is the
and dot clock (DCLK) inputs from an external
same as for the General Output Port as shown in
clock generator. The allowable values of SCLK
Figure 8-9.
and DCLK are interdependent, as defined in the
clock waveform timing table of the AC Specifica
Some clock chips use a serial programming tech
tions. System designers must consider these in
nique to select a DCLK or MCLK frequency or
te rdepend e nci es when choosing a clock
program a register. In this case, the clock and
generator, especially if the SCLK frequency is to
serial data bits are transferred by repeated writes
be varied.
to bits 1-0 of CR42.
8.3.1 Clock Generator Hardware STWR is asserted and then deasserted when the
Interface Mode Control register (CR42) bits 3-0, the Miscel
laneous Output register (3C2H) bits 3-2 or the
General Output Port register (CR5C) bits 7-4 are
Figure 8-7 shows one type of hardware interface written to.
to the clock generator. Four clock select signals
are provided, which allow selection of up to 16
DCLK frequencies. If the clock generator allows 8.3.3 DCLK Selection
selection of more than one MCLK frequency, this
can be implemented by using the General Output The values of the bits written to CR42 or 3C2H
port capability described in Section 8.4. determine the value automatically written to the
General Output Port register (CR5C) bits 3-0 and
Vision864 STWR 1-------~------~
ST LE
MCLK
CLOCK GENERAL
DCLK GENERATOR OUTPUT PORT 013:01
LATCH
CSl3:0J D[3:0)
GD!3:01 GD[7:4]
GD[7:0J
GDl7:01
DOUTl7:01
RS2 >------__, ENO GENERAL OEM DEFINABLE
INPUT PORT DIN[7:0) DATA
RMSTRD >------__, EN1 BUFFER
GENDATIF
Figure 8-7. General Data Bus Interfaces
.. 9005049 0000793 998 ..
MISCELLANEOUS FUNCTIONS 8-7

••
| r   |     |     | Vision864 Graphics Accelerator  |     |
| --- | --- | --- | ------------------------------- | --- |
53 Incorporated
then driven onto the GD[3:0] lines to be latched  RMSTRD. The data then appear almost immedi
by STWR. This is shown in Table 8-2.  ately on AD[7:0]. The functional timing for this
operation is shown in Figure 8-8.
| Table 8-2.  | DCLK Select Values  |     |     |     |
| ----------- | ------------------- | --- | --- | --- |
Bits 7-5 of the GIP are input to the Vision864 via
GD[7:5] during power-on reset and latched into
| 3C2H, Bits 3-2  | GD[3:01  |     |     |     |
| --------------- | -------- | --- | --- | --- |
bits 6-4 of 42E8H. One potential use of this capa
| 00  | 0000  |     |     |     |
| --- | ----- | --- | --- | --- |
bility is to input monitor ID information as pro
| 01  | 0001  |     |     |     |
| --- | ----- | --- | --- | --- |
vided by certain monitors.
| 10  | 0010            |     |                           |     |
| --- | --------------- | --- | ------------------------- | --- |
| 11  | CR42, Bits 3-0  |     | 8.5  GENERAL OUTPUT PORT  |     |
The coding for these signals is dependent upon
the clock generator capabilities.  The Vision864 provides a 4-bit General Output
Port (GOP). The block diagram showing how this
is implemented is shown in Figure 8-7.
| 8.4  GENERAL INPUT PORT  |     |     |     |     |
| ------------------------ | --- | --- | --- | --- |
The General Output Port register (CR5C) bits 7-4
can be set to any value by a CPU write. The
The Vision864 provides an 8-bit General Input
programmed values appear on GD[7:4] and are
Port (GIP). The block diagram showing how this
latched into the GOP external latch when STWR
is implemented is shown in Figure 8-7.
goes low. STWR is asserted and then deasserted
Bit 2 of the Extended DAC Control register (CR55)  when the Mode Control register (CR42) bits 3-0,
is set to 1 to enable the GIP read function. The  the Miscellaneous Output register (3C2H) bits 3-2
data is read from an external buffer by an 1/0 read  or the General Output Port register (CR5C) bits
|     |     |     | 7-4 are written to.  | One use of the GOP is to  |
| --- | --- | --- | -------------------- | ------------------------- |
of port 3C8H (the same as the DAC Write Index
provide programmable control of external logic.
off-chip register). When RS2 is low and RMSTRD
is asserted, this data is driven to the Vision864
The functional timing for the GOP is shown in
via GD[7:0] and transparently latched by the ris
| ing edge of MCLK preceding deassertion of  |     |     | Figure 8-9.  |     |
| ------------------------------------------ | --- | --- | ------------ | --- |
MCLK
.....___ __: __r--
| GD[7:0] _ |     | . __ _____o _A_T_A_  |     | _. ...__  ____   |
| --------- | --- | -------------------- | --- | ---------------- |
-:.--DATA LATCHED
DGINPORT
Figure 8-8. General Input Port Functional Timing
| .. 9005049                    | 0000794  | 824  ..  |     |     |
| ----------------------------- | -------- | -------- | --- | --- |
| 8-8  MISCELLANEOUS FUNCTIONS  |          |          |     |     |

Vision864 Graphics Accelerator
S3 Incorporated
T1 T2 T3 T4 T5 TS
DCLK
STWR
GD[7:0] •-----------------DG-OPOR•T
Figure 8-9. General Output Port Functional Timing
8.6 GENLOCKING clocks before the horizontal counter resets to O.
This is indicated by the t..1 gap in Figure 8-10.
Similarly, VSYNC is typically deasserted (ending
Genlocking allows two different video sources
the vertical retrace) some number of scan lines
(one or both being an S3 accelerator) to contrib
before the vertical counter resets to 0. This is the
ute to the construction of a single frame of pixel
t..2 depicted in Figure 8-10. Both the horizontal
data. The VSYNC output of a master video source
and vertical counters reset to O {times A and C in
is input to the slave video source to provide the
Figure 8-10) after VSYNC is deasserted {time Bin
basis for genlocking. This process ensures that
Figure 8-1 O).
each screen refresh cycle (frame) begins at ex
actly the same physical location on the screen.
The total adjustment is indicated by the vector in
Figure 8-11. The horizontal component of this
The total time for each horizontal scan {screen
vector {t..11 is programmed into bits 7-4 of CR63
active, blanking, retrace and front and back
{high nibble) and bits 7-4 of CR57 {low nibble).
porches) is called the Horizontal Total. It is pro
The programmed value is the number of charac
grammed in character clocks {minus 51 in the CRO
register. The internal horizontal character ter clocks from deassertion of HSYNC to the
counter counts up from 0 (the first pixel on the horizontal counter reset (both for the master}.
line) until it reaches the Horizontal Total. It then This programmed value should never exceed the
resets to 0, signaling the start of a new line. horizontal total programmed in CRO.
HSYNC is typically deasserted several character
A1
I
HSYNCIMASTER)~
(MASTER)r~'-------------1 0
VSYNC
GLOCK1 A A2 c
B
Figure 8-10. Genlocking Master Sync Timing
.. 9005049 0000795 760 ..
MISCELLANEOUS FUNCTIONS 8-9

••
r
Vision864 Graphics Accelerator
53 Incorporated
Bits 6-4 of CR64 allow fine turning of the horizon have the same CRT control parameters (Hand V
tal adjustment in VCLK units instead of character Total, etc.), pixels contributed by either source
clock (8 or 9 VCLK) units. This is required for should appear in the proper places on the screen.
signals such as those used for television. Bit 7 of One additional problem is that the character
CR64 must be set to 1 to enable this function. clocks of the master and slave will probably not
be exactly in phase after the horizontal and ver
The vertical component of this vector (il2) is tical counter reset adjustment. To rectify this, bits
programmed into bits 3-0 of CR63 (high nibble) 6-4 of the CR64 register are programmed with a
and bits 3-0 of CR57 (low nibble). The pro value equal to the number of VCLKs (dot clocks)
grammed value is the number of scan lines from the character clock of the slave must be delayed
the deassertion of VSYNC to the vertical counter from the rising edge of the master's VSYNC rising
reset. edge to bring the character clocks in phase. Bit 7
of this register must be set to 1 to enable this
Note that this adjustment does not affect any of function.
the CRT control timings other than to shift them
in time. In other words, the lengths of the blank In general, genlocking programming should be
ing period, HSYNC and VSYNC pulses, etc., do performed during the vertical sync period to
not change; their occurrences are all delayed by avoid screen jitter.
a fixed amount.
See the Genlocking Tech Note (TN016) for sev
The result of these adjustments is that both video eral implementation examples, including one de
sources use the same starting point as a refer scribing how to genlock to a television-style
ence for pixel data written to the frame buffer. As (NTSC, PAL) external source.
long as both use the same VCLK frequency and
~
~
c
w
ti:
w
I/)
~
w
c
!z..)
>
I/)
::c
ACTIVE SCREEN
VSYNC DEASSERTED (CR11J
V TOTAL (CR6)
Figure 8-11. Genlocking Timing Adjustments
.. 9005049 0000796 bT? ..
8-10 MISCELLANEOUS FUNCTIONS

Vision864 Graphics Accelerator
53 Incorporated
Section 9: Software Setup
This section describes the basic operations required to set up the Vision864.
9.1  CHIP WAKEUP
The following program wakes up the Vision864.
| ;Program runs as COM  | file       |     |     |     |
| --------------------- | ---------- | --- | --- | --- |
| ;Program enables      | S3  chips  |     |     |     |
segment
code
|     | assume  CS:code,  | DS:code  |     |     |
| --- | ----------------- | -------- | --- | --- |
ORG  lOOh
start:
|     | mov dx,46E8h  | Video Subsystem Enable register address  |                                         |               |
| --- | ------------- | ---------------------------------------- | --------------------------------------- | ------------- |
|     | mov al,16h    | bit 3  =                                 | 0,  disable  I/O and memory decoders    |               |
|     |               | bit 4  =                                 | l; place video subsystem in setup mode  |               |
|     | out dx,al     | write new bit values to 46EBH            |                                         |               |
|     | mov dx,102h   | Setup Option Select register address     |                                         |               |
|     | mov al,Olh    | Video subsystem responds                 |                                         | to commands,  |
addresses& data
|     | out dx,al     | Write new bit value to 102H              |                                     |           |
| --- | ------------- | ---------------------------------------- | ----------------------------------- | --------- |
|     | mov dx,46E8h  | Video Subsystem Enable register address  |                                     |           |
|     | mov al,OEh    | Bit 3  =                                 | 1,  enable I/O and memory decoders  |           |
|     |               | Bit 4  =                                 | 0,  return to operational mode      |           |
|     |               | Write new bit values                     |                                     | to 46E8H  |
out dx,al
mov dx,4AE8h
|     | xor al,al  | Enable                         | standard VGA  functions  | and screen size  |
| --- | ---------- | ------------------------------ | ------------------------ | ---------------- |
|     | out dx,al  | Write new bit values to 4AE8h  |                          |                  |
mov dx,  3C2h
|     | mov al,  23h  | Enable memory,                | color base,  | page  0,  |
| --- | ------------- | ----------------------------- | ------------ | --------- |
|     |               | clock@ 28.322                 | MHz          |           |
|     | out dx,  al   | Write new bit values to 3CCh  |              |           |
mov ah,4Ch
|       | int 2lh  | return to DOS  |     |     |
| ----- | -------- | -------------- | --- | --- |
| code  | ENDS     |                |     |     |
END  start
| Ill  9005049  | 0000797  | 533  Ill  |     | SOFTWARE SETUP 9-1  |
| ------------- | -------- | --------- | --- | ------------------- |

••
r
Vision864 Graphics Accelerator
S3 Incorporated
| 9.2  REGISTER ACCESS               |     |     |     |     |
| ---------------------------------- | --- | --- | --- | --- |
| 9.2.1  Unlocking the 53 Registers  |     |     |     |     |
The S3 registers (CR30 and higher plus the Enhanced Commands registers) must be unlocked before
they can be accessed by the CPU. The code to do this is:
Write code to CR38  to provide access to the S3  VGA  registers  (CR30-CR3F)
| mov dx,3d4h  |     | copy index register address    | into dx                  |     |
| ------------ | --- | ------------------------------ | ------------------------ | --- |
| mov al, 38h  |     | copy index for CR38            | register into al         |     |
| out dx,al    |     | write index to index register  |                          |     |
| inc dx       |     | increment dx to 3D5h           | (data register address)  |     |
mov al,48h  copy unlocking code  (OlxxlOxxb,  x=don't care)  to al
| out dx,al  |     | write the unlocking code to the data register  |     |     |
| ---------- | --- | ---------------------------------------------- | --- | --- |
| dee dx     |     | restore the index register address to dx       |     |     |
Write code to CR39  to provide access to the System Control and System Extension
| registers  | (CR40-CRFF)  |     |     |     |
| ---------- | ------------ | --- | --- | --- |
dx is already loaded with 3D4h because of the previous  instruction
| mov al,39h  |     | copy index for CR39            | register into al         |     |
| ----------- | --- | ------------------------------ | ------------------------ | --- |
| out dx,al   |     | write index to index register  |                          |     |
| inc dx      |     | increment dx to 3D5h           | (data register address)  |     |
mov al,Oa5h  copy unlocking code to al  (the code aSH  also unlocks
|            |     | access to configuration registers CR36,  |                       | CR37  and CR68  |
| ---------- | --- | ---------------------------------------- | --------------------- | --------------- |
| out dx,al  |     | write the unlocking code                 | to the data register  |                 |
| dee dx     |     | restore the index register address       |                       | to dx           |
Set bit 0  in CR40  to enable access  to the Enhanced Commands  registers.
dx is already loaded with 3D4h because of previous  instruction
| mov al,40h  |     | copy index for CR40            | register into al         |     |
| ----------- | --- | ------------------------------ | ------------------------ | --- |
| out dx,al   |     | write index to index register  |                          |     |
| inc dx      |     | increment dx to 3D5h           | (data register address)  |     |
in al,dx  read register data for  read/modify/write operation
| or al,l     |          | set bit 0  to 1                     |                       |        |
| ----------- | -------- | ----------------------------------- | --------------------- | ------ |
| out dx,al   |          | write the unlocking code            | to the data register  |        |
| dee dx      |          | restore the index register address  |                       | to dx  |
| •  9005049  | 0000798  | 47T  •  --------------              |                       |        |
9-2 SOFTWARE SETUP

••
r
Vision864 Graphics Accelerator
53 Incorporated
|     | 9.2.2  Locking the S3 Registers  |     |     |     |     |     |
| --- | -------------------------------- | --- | --- | --- | --- | --- |
Relocking the S3 registers is done by repeating the code used to unlock the registers except:
1.  The values written to the CR38 and CR39 registers must change at least one of the significant
bits in the valid code pattern. For example, OOh will always accomplish this.
2.  After first verifying that the Graphics Engine is not busy (bit 9 of 9AE8H is 0), bit 0 of CR40
must be cleared to 0. A read-modify-write cycle must be used instead of the code used above
to prevent overwriting of any changes made to bits 7-1 in CR40 since reset.
|     | mov dx,3d4h  |     | copy index register address into dx  |     |                          |     |
| --- | ------------ | --- | ------------------------------------ | --- | ------------------------ | --- |
|     | mov al,40h   |     | copy index for CR40                  |     | register into al         |     |
|     | out dx,al    |     | write index to index register        |     |                          |     |
|     | inc dx       |     | increment dx to 3D5h                 |     | (data register address)  |     |
in al,dx
|     |              |     | read content of CR40  |       | into al  |     |
| --- | ------------ | --- | --------------------- | ----- | -------- | --- |
|     | and al,Ofeh  |     | clear bit 0           | to 0  |          |     |
out dx,al  write to CR40  to  lock the Enhanced Commands  registers
|     | dee dx                                    |     | restore the index register address  |     |     | to dx  |
| --- | ----------------------------------------- | --- | ----------------------------------- | --- | --- | ------ |
|     | 9.2.3  Unlocking/Locking Other Registers  |     |                                     |     |     |        |
The Extended Sequencer register (SRD) has been added to the standard VGA sequencer register set
to provide display power management (Green PC) control. To gain access to this register, write
xxxx0110b (x =don't care) to SR8. Writing a bit pattern that changes one of the significant bits re-locks
access to the SRD register.
In addition to the standard VGA register access controls, the Vision864 provides a number of bits
extending the control of access to these registers. These are listed in Table 9-1.
|     | Table 9-1.     | VGA Register Access Control Extensions  |     |     |     |     |
| --- | -------------- | --------------------------------------- | --- | --- | --- | --- |
|     | Re_g!ster Bit  | Controls Access To:                     |     |     |     |     |
CR33, bit 1  CR7, bits 1 and 6 (1  =disable write_Q_rotect sett1Qg_ of CR11, bit 7)
|     | CR33, bit 4  | RAMDAC re_gister (1            |     | = disable writes)  |          |     |
| --- | ------------ | ------------------------------ | --- | ------------------ | -------- | --- |
|     | CR33, bit 6  | Palette/Overscan registers (1  |     |                    | = lock)  |     |
|     | CR34, bit 5  | SR1, bit 5 (1 = lock)          |     |                    |          |     |
3C2H, bits 3-2 (1 = lock)
CR34, bit 7
|             | CR35, bit 4  | Vertical TimiQg_registers (1    |      |     | =lock)   |                     |
| ----------- | ------------ | ------------------------------- | ---- | --- | -------- | ------------------- |
|             | CR35, bit 5  | Horizontal Timing registers (1  |      |     | = lock)  |                     |
| .. 9005049  |              | 0000799                         | 306  | ..  |          | SOFTWARE SETUP 9-3  |

••
r
Vision864 Graphics Accelerator
53 Incorporated
|     | 9.3  TESTING FOR THE PRESENCE OF A Vision864 CHIP  |     |     |     |
| --- | -------------------------------------------------- | --- | --- | --- |
After unlocking, a code identifying the Vision864 and its revision level can be read via CR30. The
following code aborts the driver program and returns to DOS if a Vision864 chip is not found.
|     | mov dx,3d4h  | copy index register address    |                          | into dx         |
| --- | ------------ | ------------------------------ | ------------------------ | --------------- |
|     | mov al,30h   | copy index for CR30            | register into al         |                 |
|     | out dx,al    | write index to index register  |                          |                 |
|     | inc dx       | increment dx to 3D5h           | (data register address)  |                 |
|     | in al,dx     | read content of CR30           | into al                  |                 |
|     | and al,OfOh  | mask out revision status       |                          | (lower nibble)  |
crop al, OcOh  ;  compare chip ID to the desired chip ID  (COh for Vision864)
jne not_COx  ;  jump  to a  label if chip ID does  not match desired ID
not_COx:
|     | mov ax,4c00h  | terminate with a  | return code of zero  |     |
| --- | ------------- | ----------------- | -------------------- | --- |
|     | int 21h       | return to DOS     |                      |     |
9.4 GRAPHICS MODE SETUP
The Vision864 provides a number of standard VGA, VESA Super VGA and S3 Enhanced graphics
modes. The particular modes supported depend on the RAMDAC used and can vary. See the 53 Video
BIOS and Utilities OEM Guide for a complete listing of the RAMDACs and modes supported by the S3
BIOS for the Vision864.
|     | 9.4.1  Backward Compatibility Modes Setup  |     |     |     |
| --- | ------------------------------------------ | --- | --- | --- |
The Vision864 is hardware compatible with CGA, MDA, and Hercules Graphics Card {HGC) standards
which are based on the Motorola 6845 CRT controller. These standards are designed to run on TTL
(digital) monitors, however, the Vision864 uses analog displays for all modes. To emulate the 6845,
the following additional setup is required before relinquishing control to 6845-based applications.
1.  Character Generator Locking. The VGA BIOS reloads the character generator each time an al
phanumeric mode is set whereas non-VGA modes {CGA, MDA, and Hercules) do not. Therefore
the character table must be loaded onto plane 2 when the controller is still in the VGA mode.
2.  Video DAC color compatibility. Non-VGA modes use 6-bit video output. Therefore, only the first
64 video DAC addresses need to be programmed and locked. Locking is done using bit 4 of the
Backward Compatibility 2 register {CR33).
3.  Program default parameters. The Vision864 should be programmed for a 640 x 200 or 320 x
200 programming table for CGA, whereas MDA uses a 350-line programming table (Mode 7).
4.  Set the S3 Registers for 6845 emulation by setting bit 3 of the Backward Compatibility 1 regis
ter {CR32) to 1 to select non-VGA operation. Force high rate horizontal timing, then lock hori
zontal and vertical timing. These and other backward compatibility setup capabilities are
provided by the Backward Compatibility 1 (CR32), Backward Compatibility 2 {CR33) and Back
ward Compatibility 3 {CR34) registers.
| .. 9005049  | 0000800  | 958  ..  |     |     |
| ----------- | -------- | -------- | --- | --- |
9-4 SOFTWARE SETUP

Vision864 Graphics Accelerator
S3 Incorporated
At this point the Vision864 is hardware compatible with and can be programmed as a 6845. The
program values will be inappropriate for VGA, but internal translation converts them to an equivalent
value for analog monitors.
9.4.2 VGA Mode Setup
The Vision864 powers up into a standard VGA mode determined by the BIOS. The mode can then be
altered by programming the standard VGA registers. All standard VGA and VESA modes are supported.
For each mode, the CRTC timing must be appropriately specified. Table 9-2 shows the required
parameters, the relevant register bits for each and the value to be programmed for each. These
parameters must also be programmed for the Enhanced modes discussed in the next section.
Table 9-2. CRTC Timing Specification Summary
Parameter R~ster Bits Value to be Pr1!9_1"ammed
Horizontal Total CR5D_O, CR0_7-0 Character clocks per horizontal period (HSYNC
active to next HSYNC active) -5
Horizontal Di~§Y. End CR5D 1, CR1 7-0 Character clocks of active d1SQl§Y_-1
Start Horizontal Blank CR5D_2. CR2_7-0 Character clock counter value at which horizontal
blank1~ b~ns
End Horizontal Blank CR5_7, CR3_ 4-0 Least significant six bits of the character clock
counter value at which horizontal blanking ends.
The BLANK pulse width can be extended by 64
DCLKs via bit 3 CR5D
Start Horizontal Sync CR5D_4, CR4_7-0 Character clock counter value at which HSYNC
becomes active
End Horizontal Sync CR5_4-0 Least significant five bits of the character clock
counter value at which HSYNC goes inactive The
HSYNC pulse width can be extended by 32
DCLKs via bit 5 of CR5D
Vertical Total CR5E_O, CR7 _5, Number of scan lines from VSYNC active to next
CR7 0, CR6 7-0 VSYNC active -2
Vertical Retrace Start CR5E_4, CR7_7, Number of scan lines at which VSYNC becomes
CR7 2, CR10 7-0 active
Vertical Retrace End CR12_3-0 Least significant 4 bits of the scan line counter
value at which VSYNC _g_oes 1nact1ve
Vertical Display End CR5E_ 1, CR7 _6, Scan 11 nes of active display -1
CR7 1, CR12 7-0
Offset CR51_5-4, CR13_7-0 This value multiplied by 2 (byte mode), 4 (word
mode) or 8 (doubleword mode) specifies the
difference between the starting byte addresses
of two consecutive scan lines
Start Vertical Blank CR5E_2, CR9_5, Number of scan lines at which vertical blanking
CR7 3, CR15 7-0 b~ns-1
End Vertical Blank CR16_7-0 Least significant eight bits of the scan line
counter at which vertical blank1~ ends
Line Compare CR5E_6, CR9_6, Number of scan lines at which the screen is split
CR7 4, CR18 7-0 into screen A and screen B
.. 9005049 0000801 894 ..
SOFTWARE SETUP 9-5

••
r
Vision864 Graphics Accelerator
53 Incorporated
See standard VGA and VESA-compliant documentation for the other setup steps.
| 9.4.3  $3 Enhanced Mode Setup  |     |     |
| ------------------------------ | --- | --- |
The Enhanced Graphics Command register group is unlocked by setting bit 0 of the System Configu
ration register (CR40) to 1. After that, bitO of 4AE8H must be set to 1 to enable Enhanced mode functions.
Bit 2 of 4AE8H is also programmed at this time forthe desired mode as explained in Table 9-3. A screen
refresh rate is selected. The CRTC timing registers are programmed as explained in the previous
section. The Enhanced mode setup bits are then programmed. Table 9-4 shows register bit values for
a particular mode for the bitmap specification bits described in Table 9-3 as well as for other bits
typically used when defining a mode. Some modes may require programming of bits not mentioned
in this example.
| Table 9-3.   | Register Bits Affecting the Bitmap Definition  |     |
| ------------ | ---------------------------------------------- | --- |
| R~ster Bits  | Descr.!e_tion                                  |     |
CR13  Spec1f1es the logical screen width (pitch). Bits 5-4 of CR51 are extension bits 9-8
for this value.
CR31_1  This is set to 1 to enable a 2Kx1 Kx4 map for 1024x768 or 800x600 resolutions, or
a 2Kx512x8 m~ for 640x480 resolution.
CR31_3  This bit must be set to 1 to enable Enhanced mode memory mapping. This forces
o_Q_eration in doubleword mode.
| CR3A_4  | O = 4-bit modes  |     |
| ------- | ---------------- | --- |
1 = 8/16/24/32-bit modes
| CR42_5  | 0 = Non-interlaced operation  |     |
| ------- | ----------------------------- | --- |
1 = Interlaced 0_£erat1on
| CR50_0,7,6  | Screen Width Definition  |     |
| ----------- | ------------------------ | --- |
000 = 1024 (or 2048 if bit 1 of CR31 =1) (Default)
001 = 640
010 = 800 (or 1600x1 200x4 1f bit 2 of 4AE8H = 1)
011 =1280
100 = 1152
101 = Reserved
110=1600
111 = Reserved
| CR50_5-4  | Pixel Color Depth Definition  |     |
| --------- | ----------------------------- | --- |
00 = 1 byte. Bit 2 of 4AE8H selects between 4 (=0) and 8 (=1) bits/pixel
01 = 2 bytes (16 bits/pixel)
|     | 1O  |  = Reserved  |
| --- | --- | ------------ |
11 = 4 bytes (32 bits/pixel). True color (24 bits/pixel) is handled by this setting,
with the L!QQ_er ~e unused.
4AE8H_2  If bits 0, 7,6 of CR50 are 01 Ob, this bit 1s set to 1 for 1600x1200x4 mode.
If bits 5,4 of CR50 are OOb, this bit is set to 1 for 4 bits/pixel modes .
| .. 9005049  | 0000802  | 720  ..  |
| ----------- | -------- | -------- |
9-6 SOFTWARE SETUP

Vision864 Graphics Accelerator
S3 Incorporated
Table 9-4. Enhanced Mode Setup for 1024x768x8 Resolution at 75 Hz Refresh
Rl!_gister Value (Hex) Descr!ll_tion
CR31 09 Enables use of a CPU base address offset. Enables use of
Enhanced mode memo..!}'_ m~ng_s.
CR34 10 Enables CR3B (di~~FIFO fetch start29s1t1on).
CR3A 15 Enables RAM refresh count specification and specifies 1
RAM refresh cycle per horizontal line. Configures attribute
controller shift r~sters for 8 bitslf!Jxel.
CR3B 9C Specifies the time from the start of display active until the
start of fetching data into the display Fl FO for the next line.
This is typically 5 less than the value programmed in CRO
but m~ v~_!y_for some modes.
CR3C 00 Not used for this non-interlaced mode.
CR40 See Description Brt O must be set to 1 early 1n the setup process to enable
Enhanced mode register access. Bits 7-4 select O or 1 wait
state and latching of write data on SRDY or RDYIN. These
bits default to 1 wait state and latching on RDYIN, which will
almost always be required for proper operation of the
Vision864. Consequently, the S3 BIOS protects these bits
from being_ overwritten during_ the normal setUj)J2!ocess.
CR42 See Description Bits 3-0 specifies the DCLK rate selection output to the
clock generator. 80 MHz 1s required for this mode, but the
actual value..Q!'~ammed will d~end on the clock_g_enerator.
CR50 00 Bits 0,7,6 specify the screen width of 1024 pixels. Bits 5,4
~ecify_ aJ 2!Xel len_g_th of 8 bitsill.!xel.
CR51 00 Bits 5,4 are extension bits for CR 13. These are not required
for this mode.
CR54 70 M parameter value. Th rs (plus 1) spec1f1es how many 8-byte
memory accesses are available before display FIFO filling
starts ~a1n.
CR5C See Description The General Output Port 1s not used during the setup of this
mode unless the clock generator requires serial input for
DCLK selection or fr~uen~Qgiammin_9:
CR5D 00 No horizontal overflow bits are r~wed for this mode.
CR5E 00 No vertical overflow bits are r~u1red for this mode.
CR60 FF N parameter value Th rs (plus 1) specifies the number of 4-
byte (1 MByte of memory) or 8-byte (2 or 4 MBytes of
memory) units to transfer to the display FIFO before
allowing memory access for another purpose. This value
(255 decimal) ensures that the FIFO will always be filled
before the memory_ rs released.
CR61 80 Bit 7 enables use of the LQ_arameter described for CR62.
CR62 80 L parameter value. For a 2-MByte memory configuration,
this is 1/8 of the number of bytes of displayed pixels (1028/8
rn this case). The upper three bits of the L parameter in
CR61 are not r~uired for this mode.
CR67 00 Bits 7-4 specify the RAMDAC color mode. This value selects
8 b1ts/p1xel for an 8-bit pixel address bus .
.. 9005049 0000803 667 ..
SOFTWARE SETUP 9-7

••
r
Vision864 Graphics Accelerator
S3 Incorporated
| 9.4.4  Memory Mapping of Enhanced Mode Registers  |     |     |
| ------------------------------------------------- | --- | --- |
For improved performance, the Enhanced registers can be memory-mapped (MMIO). This function is
enabled by setting bit 4 of CR53 or bit 5 of 4AE8H to 1. Image writes normally made by accessing 1/0
addresses E2E8H and E2EAH (the Pixel Data Transfer registers) are made instead by accessing any
memory location in the 32-KByte address space from AOOOOH to A7FFFH. Accesses to the Enhanced
command registers (write only) are made to particular locations in the A8000H to AFFFFH address
range as shown in Table 9-5. The only exception is the Read Register Select register (BEE8H, Index
OFH), which cannot be accessed as a memory-mapped register.
Table 9-5.  Memory-Mapped 1/0 Addresses for Enhanced Command Registers
| 1/0 Address                            |         | Memo!:'{_ Address  |
| -------------------------------------- | ------- | ------------------ |
|                                        | Bx ESH  | ABxEBH             |
|                                        | 9xEBH   | A9xE8H             |
|                                        | AxEBH   | AAxEBH             |
|                                        | Bx ESH  | ABxEBH             |
| 9.4.5  Hardware Graphics Cursor Setup  |         |                    |
Use of the 64x64 bits hardware graphics cursor is enabled by setting bit O of the Hardware Graphics
Cursor Mode register (CR45) to 1. The hardware cursor only works in Enhanced mode (bit 1 of 4AE8H
= 1). See the Programmable Hardware Cursor section of the Enhanced Mode Programming section for
more information.
| .. 9005049           | 0000804  | 5T3  ..  |
| -------------------- | -------- | -------- |
| 9-8  SOFTWARE SETUP  |          |          |

••
r
Vision864 Graphics Accelerator
53 Incorporated
Section 10: VGA/Backward Compatibility Support
This section describes the Vision864's support for standard VGA, VESA Super VGA and older graphics
standards.
10.1 VGA COMPATIBILITY
The Vision864 is compatible with the VGA standard. These modes are not accelerated using the
Graphics Engine. However, other design features including a multi-modal FIFO provide excellent VGA
performance.
Several of the standard VGA registers have been modified or extended in the Vision864. Table 10-1
describes these changes.
Table 10-1. Standard VGA Registers Modified or Extended in the Vision864
Re_gjster Chan_g_e to Standard VGA Definition
3C2H (Write) VCLK selection via bits 3-2 has been mod1f1ed as follows:
00 = 25.175 MHz (standard)
01 = 28.322 MHz {standard)
1O = Reserved
11 = VCLK frequency 1s selected by bits 3-0 of CR42
Access to these bits can be controlled via bit 7 of CR34.
3C2H (Read) Readiri_g_ this bit r~orts the state of the SENSE/BREQ lf1J:l_Ut to the V1s1on864.
3C4H The sequencer address has been extended from 3 to 4 bits to support the new
SR8 and SRD registers
SR1 Access to bit 0 of this register is controlled by bit 5 of CR34 Bits 1-0 of CR32
allow selection of 7 and 9 dot characters 1n addition to the 8/9 dot section
_Q!"ovided ~bit O of this register.
SR8 This new register unlocks/locks access to the new SRD r~ster
SRD This new register provides the HSYNC and VSYNC controls required for VESA
DPMS (Dis_Q)~ Power Man~ement) su_Qfl_ort.
CRO Extension bit 8 1s bit 0 of CR5D. Bit 5 of CR35 controls access to this register Bit
7 of CR43 doubles the _Q_arameter size.
CR1 Extension bit 8 is bit 1 of CR5D. Bit 5 of CR35 controls access to this register. Bit
7 of CR43 doubles the_ Q_arameter size .
.. 9005049 0000805 43T ..
VGA/BACKWARD COMPATIBILITY SUPPORT 10-1

••
r
Vision864 Graphics Accelerator
53 Incorporated
CR2 Extension bit 8 is bit 2 of CR5D. Bit 5 of CR35 controls access to this register. Bit
7 of CR43 doubles the _Q_arameter size.
CR3 The length of the blanking pulse defined in this register can be extended by 64
DCLKs via bit 3 of CR5D. Bit 5 of CR35 controls access to this register. Bit 7 of
CR43 doubles the2 9rameter size.
CR4 Extension bit 8 is bit 4 of CR5D. Bit 5 of CR35 controls access to this register. Bit
7 of CR43 doubles the _0lrameter size.
CR5 The length of the HSYNC pulse defined in this register can be extended by 32
DCLKs via bit 5 of CR5D. Bit 5 of CR35 controls access to this register. Bit 7 of
CR43 doubles the_Q_arameter size.
CR6 In addition to the standard VGA extensions (bit 8 is bit O of CR7, bit 9 is bit 5 of
CR47), bit 1O is bit O of CR5E. Bit 4 of CR35 controls access to this rElglster.
CR7 Bit 4 of CR35 controls access to bits 0, 2, 3, 5 and 7 of this register.
CR9 Bit 4 of CR35 controls access to bit 5 of this re_Bister.
CRC The display start address is a 20-bit value for the V1sion864. The extension bits
(20-16) are bits 4-0 of CR69.
CRE The cursor location address 1s a 20-bit value for the Vision864. The extension bits
(20-16) are bits 4-0 of CR69. When using a 4/8 bits/pixel color depth in Enhanced
mode and an 8-bit RAMDAC, this register contains the hardware cursor
forE!fl!ound color.
CRF When using a 4/8 bits/pixel color depth in Enhanced mode and an 8-bit RAMDAC,
this r~ster contains the hardware cursor bac~ound color.
CR10 In addition to the standard VGA extensions (bit 8 1s bit 2 of CR7, bit 9 is bit 7 of
CR7), bit 10 is bit 4 of CR5E. Bit 4 of CR35 controls access to this re_gister.
CR11 Bit 4 of CR35 controls access to bits 3-0 of this register. Bit 6 (3/5 refresh cycles
per line) can be overridden by CR3A_2-0. The actions of bits 4 and 5 on vertical
interrupts are controlled by the setting of bit 4 of CR32 or the setting of bit 8 of
42E8H. Setting bit 1 of CR33 to 1 disables the write protect effect of bit 7 of this
re_91ster on bits 1 and 6 of CR7.
CR12 In addition to the standard VGA extensions (bit 8 1s bit 1 of CR7, bit 9 1s bit 6 of
CR7). bit 10 is bit 1 of CR5E.
CR13 Bit 2 of CR43 is the old extension bit (bit 8) of this register. Bits 5-4 of CR51 are
the new extension bits (bits 9-8) of this r~ster.
CR15 In addition to the standard VGA extensions (bit 8 is bit 3 of CR7, bit 9 is bit 5 of
CR9). bit 10 1s bit 2 of CR5E. Bit 4 of CR35 controls access to this re_91ster.
CR16 Bit 4 of CR35 controls access to this rElglster.
CR17 Bit 5 of CR35 controls access to bit 2 of this register.
CR18 In addition to the standard VGA extensions (bit 8 1s bit 4 of CR7, bit 9 is bit 6 of
CR9), bit 10 is bit 6 of CR5E.
AROO-AROF Bit 6 of CR33 controls access to these registers.
46E8H If bit 2 of CR65 is set to 1, the setuQ address 1s 3C3H instead of this address.
3C6H-3C9H Bit 4 of CR33 controls writes to these r~sters.
For a detailed discussion of VGA programming, see Programming Guide to the EGA and VGA Cards,
Second Edition by Richard F. Ferraro (Addison-Wesley Publishing Company, Inc.).
.. 9005049 0000806 376 ..
10-2 VGNBACKWARD COMPATIBILITY SUPPORT

••
r
Vision864 Graphics Accelerator
S3 Incorporated
10.2 VESA SUPER VGA SUPPORT
The Vision864 supports the extended (Super) VGA modes defined by VESA. All modes are accelerated
by the Vision864's Graphics Engine except for the planar (4 bits/pixel) ones.
10.3 BACKWARD COMPATIBILITY SUPPORT
The Vision864 supports CGA, MDA and HGC-compatible modes. None of these modes is accelerated.
.. 9005049 0000807 202 ..
VGNBACKWARD COMPATIBILITY SUPPORT 10-3

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Section 11: Enhanced Mode Programming
Enhanced mode provides a level of performance far beyond what is possible with the VGA architecture.
Hardware line drawing, BitBlt, rectangle fill, and image transfers between CPU memory and display
memory are implemented. Also implemented are data manipulation functions, such as data extension,
data source selection, and read/write bitplane control. Hardware clipping is supported by 4 registers
that define a rectangular clipping area. While in enhanced mode, the display memory bit map can be
updated in two ways. One is to have the CPU write directly to memory. {This is also possible in
non-Enhanced modes via paging.) The other is to have the CPU issue commands to the Graphics
Engine, which then controls pixel updating. This section explains these two methods and provides a
comprehensive set of Enhanced mode programming examples.
11.1 DIRECT BITMAP ACCESSING-LINEAR ADDRESSING
Linear addressing is useful when software requires direct access to display memory. In general, large
image transfers to display memory can be performed faster using the Graphics Engine and memory
mapped 1/0 transfers. Linear addressing should not be enabled concurrently with memory-mapped
1/0, which is described in the Software Setup section.
Enhanced mode operation must be enabled before linear addressing is enabled. This means that bit
O of 4AESH is set to 1 to enable Enhanced mode functions and bit 3 of CR31 is set to 1 to specify
Enhanced mode memory mapping.
The Vision864 provides linear addressing of up to 4 MBytes of display memory. Linear addressing of
more than 64 KBytes requires that the CPU be operated in 386 protected mode.
The Graphics Engine busy flag, bit 9 of 9AESH, should be verified to be 0 {not busy) before linear
addressing is enabled by setting bit 4 of CR58 or bit 4 of 4AESH to 1. The size of the linear address
window is set via bits 1-0 of CR58. The base address for the linear addressing window is set via CR59
and CR5A {or via the Base Address O {Index 10H) PCI configuration register for PCI systems).
The linear addressing window size can be set to 64 KBytes. The base address for the window is set by
programming bits 31-16 of the window position in CR59-CR5A. This allows the CPU to be operated in
real mode. If bit O of CR31 is set to 1, the memory page offset {64K bank) specified in bits 5-0 of CR6A
is added to the linear addressing window position base address, allowing access to up to 4 MBytes of
display memory through a 64-KByte window .
.. 9005049 0000808 149 ..
ENHANCED MODE PROGRAMMING 11-1

••
r
Vision864 Graphics Accelerator
S3 Incorporated
11.2 BITMAP ACCESS THROUGH THE GRAPHICS ENGINE
When updating the display bitmap through the Graphics Engine, all CPU data moves through the Pixel
Data Transfer registers {E2E8H and E2EAH}. These registers can be memory mapped as explained in
Memory Mapping of Enhanced Mode Registers in the Software Setup section.
The Graphics Engine manipulates the bits for each pixel to assign a color index or true color value,
which is then translated via a programmable RAMDAC before being displayed on a CRT. Selected bits
in a pixel can be masked off from being displayed by programming the DAC Mask register {3C6H). The
Vision864 can manipulate 64 bits each clock cycle, from two 32-bit pixels to eight 8-bit pixels.
Figure 11-1 is a flowchart for the process of updating the color of each pixel. Start at the block labeled
'New Color' in the middle of Figure 11-1. At this stage, a color has been determined that may or may
not be used to update a pixel in the bitmap. How this color is determined will be covered later.
The first hurdle for the new color is the color compare process. If this is turned off {bit 8 of BEE8H,
Index OEH = 0), the new color is passed to the Write Mask register {AAE8H}. If the plane to which the
pixel update is directed has been masked off in this register, no update occurs. Otherwise, the new
color value is written to the bitmap.
If color compare is enabled {bit 8 of BEE8H, Index OEH = 1} , the new color value {source} is compared
to a color value programmed into the Color Compare {B2E8H) register. The sense of the color
comparison is determined by the SRC NE {source not equal) bit (bit 7) of BEE8H, Index OEH. If this bit
is 0, the new pixel color value is passed to the write mask only when the source color does not match
the color in the Color Compare register. If this bit is 1, the new pixel color value is passed to the write
mask only when the source color matches the color in the Color Compare register. If the new pixel
color value is not passed to the write mask, no update occurs. Notice that the source color is used for
the comparison, as opposed to the destination {bitmap} color used by the standard VGA color compare
operation.
The new color is the result of a logical mix performed on a color source and the current color in the
bitmap. For example, the color source could be XORed with the bitmap color. The new color can also
be selected by operating on only the color source or the bitmap color, e.g., NOT color source. Both the
color source and the logical mix operation are specified in either the Background Mix register (B6E8H)
or the Foreground Mix register (BAE8Hl. Which of these two registers is used is determined by the
settings of bits [7:6) of the Pixel Control register (BEE8H, Index OAH}.
To set up the pixel color updating scheme, the programmer specifies one of four color sources by
writing bits 6-5 of the Background Mix and Foreground Mix registers. The color sources are:
• Background Color register (A2E8H}
• Foreground Color register (A6E8H)
• CPU (via the Pixel Data Transfer registers {E2E8H, E2EAH)}
• Current display bitmap color index
One of 16 logical operations is chosen by writing bits 3-0 of the Background Mix and Foreground Mix
registers. Examples of logical operations are making the new pixel color index equal to the NOT of the
current bitmap color index or making the new index equal to the XOR of the source and current bitmap
indices.
When the logical operation and color source have been specified in the Background and Foreground
Mix registers, bits 7-6 of the Pixel Control register are written to specify the source of the mask bit
.. 9005049 0000809 085 ..
11-2 ENHANCED MODE PROGRAMMING

Vision864 Graphics Accelerator
53 Incorporated
PIXEL CONTROL REGISTER
BITS (7:6)
..  ..  ..  ..
0,0  0,1  1,0  1, 1
NOT  BIT  MASK BIT SOURCE
ONE  USED  CPU  MAP
|            | FOREGROUND MIX REGISTER  |           |             | BACKGROUND MIX REGISTER  |            |                 |       |
| ---------- | ------------------------ | --------- | ----------- | ------------------------ | ---------- | --------------- | ----- |
|            | BITS (6:51               |           | BITS (4:0)  | BITS [4:01               |            | BITS 16:5)      |       |
| ..         |                          | ..        |             |                          |            |                 | ..    |
| 0,0        |                          | 1, 1      |             |                          |            |                 | 1, 1  |
| BGND FGND  |                          | CPU  BIT  |             |                          | BGND FGND  | CPU             | BIT   |
| CLR        | CLR                      | MAP       |             |                          | CLR        | CLR             | MAP   |
|            | COLOR SOURCE A           |           |             |                          |            | COLOR SOURCE B  |       |
COLOR COMPARE ON 7
|     |     | SRC NE= 0           | SRC NE= 1           |     |     |     |     |
| --- | --- | ------------------- | ------------------- | --- | --- | --- | --- |
|     |     | COLOR COMP =TRUE    | COLOR COMP =TRUE    |     |     |     |     |
|     |     | SRC NE= 1           | SRC NE= 0           |     |     |     |     |
|     |     | COLOR COMP = FALSE  | COLOR COMP = FALSE  |     |     |     |     |
COLOR
COMPARE
NO
OPERATION
NEW PIXEL COLOR
PIXUPDT
Figure 11-1. Pixel Update Flowchart
| .. 9005049  |     | 0000810  | 8T7  ..  |                            |     |     |       |
| ----------- | --- | -------- | -------- | -------------------------- | --- | --- | ----- |
|             |     |          |          | ENHANCED MODE PROGRAMMING  |     |     | 11-3  |

••
r
Vision864 Graphics Accelerator
53 Incorporated
value. If the resulting mask bit is a 'ONE', the Foreground Mix register is used to determine the color
source and mix. If the mask bit is a 'ZERO', the Background Mix register is used to determine the color
source and mix. There are three sources for the mask bit value:
• Always ONE (Foreground Mix register used}
• CPU (via the Pixel Data Transfer registers (E2E8H, E2EAH})
• Bitmap
Setting bits 7-6 to OOb sets the mask bit to 'ONE'. All drawing updates to the video bitmap use the
Foreground Mix register settings. This setup is used to draw solid lines, through-the-plane image
transfers to display memory and BitBLT s.
If bits 7-6 are set to 10b, the mask bit source is the CPU. After the draw operation command is issued
to the Drawing Command register (9AE8}, a mask bit corresponding to every pixel drawn on the display
must be provided via the Pixel Data Transfer register(s). If the mask bit is 'ONE', the Foreground Mix
register is used. If the mask bit is 'ZERO', the Background Mix register is used. Note that if the color
source" the CPU, the mask bit source cannot also be the CPU, and vice versa. This setup is used to
transfer monochrome images such as fonts and icons to the screen.
If bits 7-6 are set to 11 b, the current display bit map is selected as the mask bit source. The Read Mask
register (AAE8H} is set up to indicate the active planes. When all bits of the read-enabled planes for a
pixel are a 1, the mask bit 'ONE' is generated. If any one of the read-enabled planes is a 0, then a mask
bit 'ZERO' is generated. If the mask bit is 'ONE', the Foreground Mix register is used. If the mask bit is
'ZERO', the Background Mix register is used. Note that if the color source is the bitmap, the mask bit
source cannot also be the bitmap, and vice versa. This setting is used to BitBLT patterns and character
images.
11.3 PROGRAMMING
This section provides programming examples of Enhanced mode features provided by the Vision864.
11.3.1 Notational Conventions
The REG MNEMONIC on the left hand side of the arrow is the register mnemonic of the 1/0 port being
written into. Text following a';' is a comment.
REGMNEMONIC <= XXXXH ; Load a hexadecimal value into the register.
REGMNEMONIC <= XXXXD ; Load a decimal value into the register.
REG MNEMONIC<= XXXX ; Load a decimal value into the register
REG MNEMONIC<= XXXXXXXXXXXXXXXXB ; Load a binary value into the register.
The programming examples often contain the following step:
wait for FIFO X empty
where Xis some number between 1 and 13. This number equals the number of commands to follow
that may need to be stored in the command FIFO before execution. The number of empty command
FIFO entries is determined by reading the FIFO-STATUS bits of the Graphics Processor Status register
(9AE8H, Read}. See the register description for the interpretation of these bits.
11 9005049 0000811 733 II
11-4 ENHANCED MODE PROGRAMMING

Vision864 Graphics Accelerator
53 Incorporated
11.3.2 Initial Setup
All examples assume the desired mode is selected. The RAMDAC must also be set up appropriately.
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
11.3.3 Programming Examples
This section provides programming examples for the following Enhanced mode drawing operations:
Solid Line
• Textured Line
• Rectangle
• Image Transfer-Through the Plane
• Image Transfer-Across the Plane
• BitBLT -Through the Plane
• BitBLT -Across the Plane
• Pattern Fill-Through the Plane
• Pattern Fill-Across the Plane
• Short Stroke Vectors
• Programmable Hardware Cursor
In addition, an example of the programming of the hardware cursor is provided.
A number of programming steps are repeated in multiple examples. They are explained in detail at
their first occurrence. Therefore, readers are encouraged to work through the examples from first to
last.
The register mnemonics used in the examples are listed in Table 11-1 .
.. 9005049 0000812 b7T ..
ENHANCED MODE PROGRAMMING 11-5

••
r
Vision864 Graphics Accelerator
53 Incorporated
| Table 11-1  | Mnemonics Used in the Programming Examples  |                             |
| ----------- | ------------------------------------------- | --------------------------- |
| Mnemonic    |                                             | Register                    |
| BKGD_COLOR  |                                             | Background Color (A2E8)     |
| BKGD_MIX    |                                             | Background Mix (B6E8H)      |
| CMD         |                                             | Drawing Command (9AE8H)     |
| CUR_X       |                                             | Current X Position (86E8H)  |
| CUR_Y       |                                             | Current Y Position (82E8H)  |
DESTY _AXSTP  Destination Y-Position/Ax1al Step Constant (BAEBH)
DESTY _DIASTP  Destination X-Position/Diagonal Step Constant (BEEBH)
| ERR_ TERM      |     | Error Term (92E8H)              |
| -------------- | --- | ------------------------------- |
| FRGD_COLOR     |     | Foreground Color (A6E8H)        |
| FRGD_MIX       |     | Foreground Mix (BAEBH)          |
| MAJ_AXIS_PCNT  |     | Major Axis Pixel Count (96E8H)  |
| M/N_AXIS_PCNT  |     | Minor Axis Pixel Count (BEEBH)  |
| PIXEL_CNTL     |     | Pixel Control (BEEBH)           |
PIX_ TRANS  Pixel Data Transfer (E2E8H) -Also E2EAH for 32-bit transfers.
| RD_MASK       |     | Bitplane Read Mask (AEEBH)            |
| ------------- | --- | ------------------------------------- |
| SHORT_STROKE  |     | Short Stroke Vector Transfer (9EE8H)  |
| WRT_MASK      |     | Bitplane Write Mask (AAEBH)           |
| Mnemonic      |     | Description                           |
NEW  Mix= 00111 bin bits 4-0 of BAEBH or B6EBH. This overwrites the present
bitmap color value with a new value.
XOR  Mix = 00101 b 1n bits 4-0 of BAEBH or B6E8H. The current bitmap color 1s
XORed with the new color .
| .. 9005049  | 0000813  | 506  ..  |
| ----------- | -------- | -------- |
11-6 ENHANCED MODE PROGRAMMING

••
r
Vision864 Graphics Accelerator
S3 Incorporated
| 11.3.3.1  Solid Line  |     |     |
| --------------------- | --- | --- |
Draw a solid line using axial coordinates from x1,y1 to x2,y2 using the mix NEW and color index 2.
Setup:
Drawing a line using axial coordinates requires programming the axial step constant into the Destina
tion Y-Position/Axial Step Constant (8AE8Hl register (DESTY _AXSTP), the diagonal step constant into
the Destination X-Position/Diagonal Step Constant (8EE8Hl register (DESTX_DIASTP) and the error
term into the Error Term (92E8H) register (ERR_ TERM). Calculation of these three constants is based
on the MAX and MIN parameters as calculated below.
MAX= maximum(ABS(x2-x1), ABS(y2-y1))
MIN= minimum(ABS(x2-x1), ABS(y2-y1))
where maximum means choose the largest of the two terms in parentheses and minimum means
choose the smallest. ABS means take the absolute value of the expression.
Bits 7-5 of the Drawing Command (9AE8H) register (CMD) specify the drawing direction. Setting bit 7
to 1 means that the Y drawing direction is positive (y1 < y2). Clearing bit 7 to O means the Y drawing
direction is negative (y1 > y2). Setting bit 6 to 1 means that Y is the major (longer) axis (ABS(x2-x1) >
ABS(y2-y1)). Clearing bit 6 to O means that Xis the major axis. Setting bit 5 to 1 means that the X
drawing direction is positive (x1 < x2). Clearing bit 5 to O means thatthe X drawing direction is negative
(x1 > x2). These values replace the DDD sequence in the write to the CMD register shown in the
pseudocode below.
The mix NEW represents a setting of 0111 b in bits 3-0 of the Foreground Mix (BAE8H) register
(FRGD_MIX). This overwrites the present bitmap color value with a new value.
The remainder of the setup is:
| Wait For FIFO 3 empty  |     | ; Three commands to follow  |
| ---------------------- | --- | --------------------------- |
FRGD_MIX ~ 0027H  ; color source is FRGD_COLOR, mix type is NEW
| FRGD_COLOR ~ 00000002H  |     | ; color index  |
| ----------------------- | --- | -------------- |
PIXEL_CNTL ~ AOOOH  ; FRGD_MIX provides color source and mix type
Drawing Operation:
| Wait For FIFO 7 empty  |     | ; 7 commands to follow              |
| ---------------------- | --- | ----------------------------------- |
| CUR_X ~ x1             |     | ; set starting horizontal position  |
| CUR_ Y ~ y1            |     | ; set starting vertical position    |
MAJ_AXIS_PCNT ~MAX -1  ; length in pixels of the major axis -1
| DESTX_DIASTP ~ 2 * (MIX-MAX)  |     | ; diagonal step constant  |
| ----------------------------- | --- | ------------------------- |
| DESTY_AXSTP ~ 2 *MIN          |     | ; axial step constant     |
If the X drawing direction is positive then
| ERR_T  ERM~ 2 * MIN - | MAX  | ; error term  |
| --------------------- | ---- | ------------- |
else if the X drawing direction is negative
| ERR_ TERM~ 2 * MIN - | MAX - | 1 ; error term  |
| -------------------- | ----- | --------------- |
CMD ~ 00100000DDD10011b  ; Draw line command (bits 15-13), Draw (as opposed to
; just move current position)(bit 4), draw multiple pixels (bit 1 ),
; write (bit 0) .
| .. 9005049  | 0000814  | 442  ..  |
| ----------- | -------- | -------- |
ENHANCED MODE PROGRAMMING  11-7

=·
r
Vision864 Graphics Accelerator
53 Incorporated
11.3.3.2 Textured Line
Draw a textured line from x1,y1 to x2,y2 using the mix NEW for the foreground mix, XOR for the
background mix, foreground color index 2 and background color index4. The 32-bit line texture/pattern
{PATTERN) is 00110000111100110011000011110011b. When the pattern bit is a 1, the pixel is written
with the foreground color and mix. When the bit is a 0, the pixel is written with the background color
and mix.
Setup:
The XOR mix corresponds to a setting of 0101b in bits 3-0 of the Background Mix (B6E8H) register
(BKGD_MIX). See the Solid Line example for an explanation of other parameters and registers used in
this example.
Wait For FIFO 5 empty ; 5 commands to follow
FRGD_MIX <= 0027H ; color source is FRGD_COLOR, NEW mix type
FRGD_COLOR <= 00000002H ; color index
BKGD_MIX <= 0005H ; color source BKGD_COLOR, XOR mix type
BKGD_COLOR <= 00000004H ; color index
PIXEL_CNTL <= A080H ; mask data selecting mix register is provided by the CPU
Drawing Operation:
Wait For FIFO 7 empty ; 7 commands to follow
CUR_X <= x1 ; set starting horizontal position
CUR_ Y <= y1 ; set starting vertical position
MAJ_AXIS_PCNT <= MAX -1 ; length in pixels of major axis -1
DESTX_DIASTP <= 2 * (MIX-MAX) ; diagonal step constant
DESTY _AXSTP <= 2 * MIN ; axial step constant
If the X drawing direction is positive then
ERR_ TERM<= 2 * MIN - MAX ; error term
else if the X drawing direction is negative
ERR_ TERM<= 2 * MIN - MAX-1 ; error term
CMD <= 00100101DDD10011b ; Draw line (bits 15-13), 32-bit bus (bits 10-9), wait for data from
; the Pixel Data Transfer register (bit 8), Draw (bit 4),
; Multi-pixel (bit 1) , Write (bit 0),
COUNT (of PATTERN dwords) =(MAX+ 31)/32 (See Note)
PIX_T RANS<= 00110000111100110011000011110011b ; Output PATTERN to Pixel Data Transfer
; registers COUNT times
Note
The COUNT of the number of writes required by the CPU is a function of the number of bits to be
transferred and the width of the transfer (8, 16 or 32 bits as specified by bits 10-9 of the Drawing
Command register (9AE8H)). The number of bits transferred per line must be an even multiple of the
transfer width. If this is not the case, the last write per line must be padded with one or more dummy
bits to meet this requirement. For example, if the transfer width is 8 bits and nine bits are to be
transferred for the line, two bytes must be written per line, with the upper 7 bits of the second byte
padded. In general, the number of padding bits per line will vary from 0 to (n-1 ), where n is the transfer
width in bits .
.. 9005049 0000815 389 ..
11-8 ENHANCED MODE PROGRAMMING

=·
r
Vision864 Graphics Accelerator
53 Incorporated
With a transfer width of 8 bits, the number of byte writes required per line can be determined from
the formula n = (MAX+7)/8, with n being truncated to an integer if the result contains a fraction.
Thus a MAX= 11 transfer requires (11+7)/8 = 2 1/4 = 2 bytes. The formulas for all transfer widths are
given below.
8-bit transfers: COUNT= (MAX+7)/8 bytes
16-bit transfers: COUNT= {MAX+ 15)/16 words
32-bit transfers: COUNT= {MAX+31 )/32 dwords
.. 9005049 0000816 215 ..
ENHANCED MODE PROGRAMMING 11-9

••
r
Vision864 Graphics Accelerator
S3 Incorporated
11.3.3.3 Rectangle
Draw a rectangle with its top left corner at x1,y1, height= HEIGHT and width =WIDTH. Use the mix
NEW and color index 2. The drawing direction (bits 7-5 in the write to the CMD register below) is set
to X positive, X major and Y positive (101b).
Setup:
| Wait For FIFO 3 empty  |     |     | ; 3 commands to follow  |     |
| ---------------------- | --- | --- | ----------------------- | --- |
FRGD_MIX <= 0027H  ; color source is FRGD_COLOR, NEW mix type
| FRGD_COLOR <= 00000002H  |     |     | ; color index  |     |
| ------------------------ | --- | --- | -------------- | --- |
PIXEL_CNTL <= AOOOH  ; FRGD_MIX specifies the color source and mix type
Draw Operation:
| Wait For FIFO 5 empty      |     |     | ; 5 commands to follow              |     |
| -------------------------- | --- | --- | ----------------------------------- | --- |
| CUR_X <=x1                 |     |     | ; set starting horizontal position  |     |
| CUR_v <=y1                 |     |     | ; set starting vertical position    |     |
| MAJ_AXIS_PCNT <= WIDTH-1   |     |     | ; rectangle width                   |     |
| MIN_AXIS_PCNT <= HEIGHT-1  |     |     | ; rectangle height                  |     |
CMD <= 0100000010110011b  ; Draw rectangle (bits 15-13), Draw (bit 4), Multi-pixel (bit 1),
; Write (bit O)
Note
The rectangle can be defined by specifying any one of the four corners and setting bits 7-5 accordingly.
Always select X as the major axis (bit 6 =0). No matter how the rectangle is defined, it always fills from
left to right and top to bottom.
|             |          | Corner        | X direction (bit 5)  | V direction (bit 7)  |
| ----------- | -------- | ------------- | -------------------- | -------------------- |
|             |          | tCJQ_left     | _Q_ositive (1)       | _£ositive (1 )       |
|             |          | tCJQ_ ng_ht   | neg_at1ve (0)        | jl_OSitive (1)       |
|             |          | bottom left   | _Q_ositive (1)       | neg_at1ve (O)        |
|             |          | bottom right  | negative (0)         | negative (0)         |
| .. 9005049  | 0000817  | 151           | ..                   |                      |
11-10 ENHANCED MODE PROGRAMMING

Vision864 Graphics Accelerator
53 Incorporated
11.3.3.4 Image Transfer-Through the Plane
A rectangular image is transferred from the CPU to the display memory through the plane. The image
is stored as an array of pixels arranged in row major fashion. This example uses a mix type of NEW
and x1,y1 is the top left corner of the rectangle on the display. The height and width of the rectangle
(in pixels) are HEIGHT and WIDTH.
Setup:
Wait For FIFO 6 empty ; 6 commands to follow
FRGD_MIX {'= 0047H ; color source is the CPU, mix type is NEW
PIXEL_CNTL {'= AOOOH ; FRGD_MIX is the source for color source and mix type
Drawing Operation:
CUR_X {'= x1 ; set starting horizontal position
CUR_Y {'= y1 ; set starting vertical position
MAJ_AXIS_PCNT {'= WIDTH-1 ; rectangle width
MIN_AXIS_PCNT {'= HEIGHT-1 ; rectangle height
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is O
CMD {'= 0101010100110001 b ; Draw rectangle (bits 15-13), Swap ON (bit 12),
; 32-bit transfers (bits 10-9), Wait for CPU data (bit 8),
; Always X Major (bit 6) & X Positive (bit 5), Draw (bit 4),
; Write (bit O)
COUNT (of image pixel data to transfer) =(See Note)
PIX_T RANS{'= IMAGE DATA; Output image data to the Pixel Data Transfer registers for COUNT dwords.
Note
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred, the width of the transfer (8, 16 or 32 bits as specified by bits 10-9 of the Drawing Command
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
of the variables affecting the COUNT. The formulas for all cases are given below, where Wis the width
of the image and His the height of the image, both in pixels.
COUNT for 4 bits/pixel modes
8-bittransfers: COUNT= (W+1}/2 * H bytes
16-bittransfers: COUNT= (W+3)/4 * H words
32-bittransfers: COUNT= (W+7)/8 * H dwords
.. 9005049 0000818 098 ..
ENHANCED MODE PROGRAMMING 11-11

••
r Vision864 Graphics Accelerator
S3 Incorporated
COUNT for 8 bits/pixel modes
8-bit transfers: COUNT= W * H bytes
16-bit transfers: COUNT= (W+1)/2 * H words
32-bit transfers: COUNT= (W+3)/4 * H dwords
COUNT for 16 bits/pixel modes
8-bit transfers: Do not use this combination
16-bit transfers: COUNT= W * H words
32-bit transfers: COUNT= (W+ 1) /2 * H dwords
COUNT for 32 bits/pixel modes
8-bit transfers: COUNT= Do not use this combination
16-bit transfers: COUNT= 2W * H words
32-bit transfers: COUNT= W * H dwords
Note that in 32 bits/pixel modes, the upper byte is a dummy byte providing padding for a 24-bit
pixel.
.. 9005049 0000819 T24 ..
11-12 ENHANCED MODE PROGRAMMING

••
r
Vision864 Graphics Accelerator
53 Incorporated
11.3.3.5 Image Transfer-Across the Plane
A rectangular image is transferred from the CPU to the display memory across the plane. The
monochrome bit image is stored as an array of pixels arranged in row major fashion. A byte represents
data for 8 pixels in a row. This example uses a mix type of NEW, and x1 ,y1 is the top left corner of the
rectangle on the display. The height and width of the rectangle (in pixels) are HEIGHT and WIDTH. The
monochrome image is translated so that pixels corresponding to a 1 in the bit image are given color
index 4 and pixels corresponding to a O in the bit image are given color index O.
Setup:
Wait For FIFO 5 empty ; 5 commands to follow
FRGD_MIX <= 0027H ; foreground color source, mix type NEW
FRGD_COLOR <= 00000004H ; foreground color index 4
BKGD_MIX <= 0007H ; background color source, mix type NEW
BKGD_COLOR <= OOOOOOOOH ; background color index O
PIXEL_CNTL <= A080H ; selection of mix register is based on data from the CPU
Drawing Operation:
Wait For FIFO 4 empty ; 4 commands to follow
CUR_X <= x1 ; set starting horizontal position
CUR_Y <= y1 ; set starting vertical position
MAJ_AXIS_PCNT <= WIDTH-1 ; rectangle width
MIN_AXIS_PCNT <= HEIGHT-1 ; rectangle height
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
CMD <= 01010011 D0110011 b ; Draw rectangle (bits 15-13), Swap ON (bit 12),
; 16-bit transfers (bits 10-9), Wait for CPU data (bit 8),
; Always X Major (bit 6) & X Positive (bit 5), Draw (bit 4),
; Multiple pixel (bit 1 ), Write (bit 0)
COUNT (of image pixel data to transfer)= ((WIDTH +15)/16)*HEIGHTwords
PIX_ TRANS<= IMAGEDATA; Output image data to Pixel Transfer register for COUNT words
Notes
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred and the width ofthe transfer (8, 16 or 32 bits as specified by bits 10-9 of9AE8H). The number
of pixels transferred per line must be an even multiple of the transfer width. If this is not the case, the
last write per line must be padded with one or more dummy pixels to meet this requirement. For
example, if the transfer width is 8 bits and nine pixels are to be transferred per line, two bytes must be
written per line, with the upper 7 bits of the second byte padded. In general, the number of padding
bits per line will vary from Oto (n-1 ), where n is the transfer width in bits.
With a transfer width of 8 bits, the number of byte writes required per line can be determined from the
formula n = (W+7)/8, with n being truncated to an integer if the result contains a fraction. Thus a 13-bit
pixel transfer requires (13+7)/8 = 2.5 = 2 bytes. This is then multiplied by the height of the image (in
pixels) to determine the COUNT of bytes to be transferred. Similar procedures apply to every other
combination of the variables affecting the COUNT. The formulas for all cases are given below, where
Wis the width of the image and H is the height of the image, both in pixels .
.. 9005049 0000820 746 .. ENHANCED MODE PROGRAMMING 11-13

Vision864 Graphics Accelerator
53 Incorporated
8-bit transfers: COUNT= (W+7)/8 * H bytes
16-bit transfers: COUNT= (W+ 15)/16 * H words
32-bit transfers: COUNT= (W+31 )/32 * H dwords
To write to a single plane, setthe foreground mix to 'logical one' (0002H), the background mix to 'logical
zero' (0001 H), and the Write Mask register (AAE8H) to select the desired (single) plane for updates.
.. 9005049 0000821 682 ..
11-14 ENHANCED MODE PROGRAMMING

Vision864 Graphics Accelerator
53 Incorporated
| 11.3.3.6  BitBLT  -Through the Plane  |     |     |
| ------------------------------------- | --- | --- |
A source rectangular area in display memory is transferred to a specified destination in display
memory. The pixels are written into the destination rectangle using the current foreground mix.
Assume x1,y1 is the top left corner of the source rectangle in display memory and x2,y2 is the top left
corner of the destination rectangle. The rectangles could be overlapping or disjoint. The height and
width (in pixels) of the rectangle are HEIGHT and WIDTH.
Setup:
First, the values of the Srcx, Srey, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, Y Positive: Srcx = x1, Srey= y1, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
If x1 > x2
then if X Positive, Srcx = x1, Destx = x2
else
Srcx = x1 + WIDTH-1, Desty = x2 +WIDTH -1  ; X Negative
lfy1 > y2
then if Y Positive, Srey= y1, Desty = y2
else
; Y Negative
Srey= y1 + HEIGHT-1, Desty = y2 +HEIGHT -1
| Wait For FIFO 2 empty  |     | ; 2 commands to follow  |
| ---------------------- | --- | ----------------------- |
PIXEL_CNTL ¢= AOOOH  ; FRGD_MIX is the source of color source and mix type
FRGD_MIX ¢= 0067H  ; color source is display memory and mix type is NEW
Draw Operation:
| Wait For FIFO 7 empty  |     | ; 7 commands to follow              |
| ---------------------- | --- | ----------------------------------- |
| CUR_X ¢= Srcx          |     | ; set starting horizontal position  |
| CUR_ Y ¢=Srey          |     | ; set starting vertical position    |
DESTX_DIASTP ¢= Destx  ; set destination horizontal position
| DE STY _AXSTP ¢= Desty     |     | ; set destination vertical position  |
| -------------------------- | --- | ------------------------------------ |
| MAJ_AXIS_PCNT ¢= WIDTH-1   |     | ; rectangle width                    |
| MIN_AXIS_PCNT ¢= HEIGHT-1  |     | ; rectangle height                   |
CMD ¢= 11000000DOD10011 b  ; BitBLT (bits 15-13), Always X Major (bit 6), Draw (bit 4),
; Multi-pixel (bit 1}, Write (bit 0)
| .. 9005049  | 0000822  | 519  ..  |
| ----------- | -------- | -------- |
ENHANCED MODE PROGRAMMING  11-15

••
r  Vision864 Graphics Accelerator
53 Incorporated
11.3.3.7 BitBLT-Across the Plane
A source rectangular area in display memory is transferred to a specified destination in display
memory. The bits corresponding to a single plane specified by setting the Read Mask register (AEEBH)
can be transferred. With more than 1 plane enabled for read, if all the bits in the planes enabled for
read are '1's then a '1' is read. If a bit in any one of the planes enabled for read is a 'O', then 'O' is read.
Assume x1,y1 is the top left corner of the source rectangle on the display, and x2,y2 is the top left
corner of the destination rectangle. The image is read from plane O and written to plane 2. The
rectangles could be overlapping or disjoint. The height and width (in pixels) of the rectangle are HEIGHT
and WIDTH.
Setup:
First, the values of the Srcx, Srey, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, Y Positive: Srcx = x1, Srey= y1, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
If x1 > x2
then if X Positive, Srcx = x1, Destx = x2
else
Srcx = x1 +WIDTH -1, Desty = x2 +WIDTH -1  ; X Negative
lfy1 > y2
then if Y Positive, Srey= y1, Desty = y2
else
Srey= y1 +HEIGHT -1, Desty = y2 +HEIGHT -1  ; Y Negative
| Wait For FIFO 5 empty  |     | ; 5 commands to follow  |
| ---------------------- | --- | ----------------------- |
PIXEL_CNTL ¢= AOCOH  ; data from display memory selects mix register
| FRGD_MIX ¢= 0002H      |     | ; always 'logical 1'         |
| ---------------------- | --- | ---------------------------- |
| BKGD_MIX ¢= 0001 H     |     | ; always 'logical O'         |
| RD_MASK ¢= 00000001H   |     | ; Read from plane O          |
| WRT_ MASK¢= 00000004H  |     | ; plane 2 enabled for write  |
Draw Operation:
| Wait For FIFO 7 empty  |     | ; 7 commands to follow              |
| ---------------------- | --- | ----------------------------------- |
| CUR_X ¢= Srcx          |     | ; set starting horizontal position  |
| CUR_ Y ¢=Srey          |     | ; set starting vertical position    |
DESTX_DIASTP ¢= Destx  ; set destination horizontal position
DE STY_ AXSTP ¢= De sty  ; set destination vertical position
| MAJ_AXIS_PCNT ¢= WIDTH-1   |     | ; rectangle width   |
| -------------------------- | --- | ------------------- |
| MIN_AXIS_PCNT ¢= HEIGHT-1  |     | ; rectangle height  |
CMD ¢= 11000000DOD10011b  ; BitBLT (bits 15-13), Always X Major (bit 6), Draw (bit 4),
; Multi-pixel (bit 1), Write (bit 0)
| .. 9005049  | 0000823  | 455  ..  |
| ----------- | -------- | -------- |
11-16 ENHANCED MODE PROGRAMMING

Vision864 Graphics Accelerator
S3 Incorporated
Note
It is possible to translate a monochrome image, e.g., text fonts, stored in a single plane in display
memory into a 2-color image. This is accomplished by setting the mix registers differently and setting
the desired background and foreground colors. If the source bit is a '1', then the corresponding pixel
at the destination is colored with the foreground color index. The destination pixel is colored with the
background color index if the corresponding source bit is a 'O'. The setup for this is as follows:
| WRT_ MASK¢= FFFFFFFFH    |          | ; enable all planes for writing          |
| ------------------------ | -------- | ---------------------------------------- |
| FRGD_MIX ¢= 0027H        |          | ; color source foreground, mix type NEW  |
| BKGD_MIX ¢= 0007H        |          | ; color source background, mix type NEW  |
| FRGD_COLOR ¢= 00000004H  |          | ; foreground color                       |
| BKGD_COLOR ¢= 00000001H  |          | ; background color                       |
| .. 9005049               | 0000824  | 391  ..                                  |
ENHANCED MODE PROGRAMMING  11-17

••
r
Vision864 Graphics Accelerator
53 Incorporated
| 11.3.3.8 PatBLT  | -Pattern Fill Through the Plane  |     |
| ---------------- | -------------------------------- | --- |
An 8x8 pixel pattern is initially copied into an off-screen area of display memory using an image transfer
operation or a direct write. This source pattern is then repeatedly copied to a destination rectangle of
arbitrary size. The destination rectangle must not overlap the source pattern. Each copy is aligned to
an 8-pixel boundary (x coordinate = 0, 8, etc.). The pixels are written into the destination rectangle
using the current foreground mix. Assume x1,y1 is the top left corner of the source rectangle on the
display and x2,y2 is the top left corner of the destination rectangle. The height and width (in pixels) of
the rectangle are HEIGHT and WIDTH.
Setup:
| Wait For FIFO 2 empty  |     | ; 2 commands to follow  |
| ---------------------- | --- | ----------------------- |
PIXEL_CNTL <= AOOOH  ; FRGD_MIX is the source of color source and mix type
FRGD_MIX <= 0067H  ; color source is display memory, mix type is NEW
Draw Operation
| Wait For FIFO 7 empty      |     | ; 7 commands to follow                 |
| -------------------------- | --- | -------------------------------------- |
| CUR_X <= x1                |     | ; set starting horizontal position     |
| CUR_Y <= y1                |     | ; set starting vertical position       |
| DESTX_DIASTP <= x2         |     | ; set destination horizontal position  |
| DESTY _AXSTP <= y2         |     | ; set destination vertical position    |
| MAJ_AXIS_PCNT <= WIDTH-1   |     | ; rectangle width                      |
| MIN_AXIS_PCNT <= HEIGHT-1  |     | ; rectangle height                     |
CMD <= 11100000DOD10011b  ; Pattern Fill (bits 15-13), Always X Major (bit 6), Draw (bit 4),
; Multi-pixel (bit 1) , Write (bit O)
| .. 9005049  | 0000825  | 228  ..  |
| ----------- | -------- | -------- |
11-18 ENHANCED MODE PROGRAMMING

••
r
Vision864 Graphics Accelerator
53 Incorporated
| 11.3.3.9 PatBLT  | -Pattern Fill Across the Plane  |     |
| ---------------- | ------------------------------- | --- |
An 8x8 pixel pattern is initially copied into an off-screen area of display memory using an image transfer
operation or by a direct write. This source pattern is then transferred to a specified destination in display
memory. The destination rectangle must not overlap the source rectangle. The bits corresponding to
a single plane specified by setting the Read Mask register {AEE8H) can be transferred. With more than
1 plane enabled for read, if all the bits in the planes enabled for read are '1's, then a '1' is read. If a bit
in any one of the planes enabled for read is a 'O', then 'O' is read. Assume x1,y1 is the top left corner
of the source rectangle on the display, and x2,y2 is the top left corner of the destination rectangle. The
image is read from plane O and written to plane 2. The height and width of the rectangle are HEIGHT
and WIDTH.
Setup:
| Wait For FIFO 5 empty  |     | ; 5 commands to follow  |
| ---------------------- | --- | ----------------------- |
PIXEL_CNTL $= AOCOH  ; data from display memory selects mix register
| FRGD_MIX {'= 0002H     |     | ; always 'logical 1'         |
| ---------------------- | --- | ---------------------------- |
| BKGD_MIX {'= 0001 H    |     | ; always 'logical O'         |
| RD_MASK $= 00000001H   |     | ; read from plane 0          |
| WRT_MASK $= 00000004H  |     | ; plane 2 enabled for write  |
Draw Operation:
| Wait For FIFO 7 empty       |     | ; 7 commands to follow                 |
| --------------------------- | --- | -------------------------------------- |
| CUR_X {'= x1                |     | ; set starting horizontal position     |
| CUR_Y {'= y1                |     | ; set starting vertical position       |
| DESTX_DIASTP {'= x2         |     | ; set destination horizontal position  |
| DESTY _AXSTP $= y2          |     | ; set destination vertical position    |
| MAJ_AXIS_PCNT {'= WIDTH-1   |     | ; rectangle width                      |
| MIN_AXIS_PCNT {'= HEIGHT-1  |     | ; rectangle height                     |
CMD $= 11100000DOD10011 b  ; Pattern Fill {bits 15-13), Always X Major {bit 6), Draw {bit 4),
; Multi-pixel {bit 1), Write {bit O)
Note
To expand the source mono pattern into a 2-color pattern, set the foreground mix to 27H, the
background mix to 7H and the foreground and background colors as desired. Also set the write mask
{AAE8Hl to FFFFFFFFH .
| .. 9005049  | 0000826  | 164  ..  |
| ----------- | -------- | -------- |
ENHANCED MODE PROGRAMMING  11-19

••
r Vision864 Graphics Accelerator
S3 Incorporated
11.3.3.10 Short Stroke Vectors
Using short stroke vectors, short lines up to 15 pixels in length can be drawn rapidly because it is not
necessary to calculate and set the line constants. Such lines are constrained to one of the 8 directions
at 45 degree increments starting at O degrees. The current point x1,y1 is set and a NOP command is
issued to set all the desired drawing parameters without actually writing a pixel. For example, bit 2
(Last Pixel Off) would be set to 1 (OFF) for drawing connected lines until the last line is drawn. The
short stroke vector parameters are then loaded in the Short Stroke Vector Transfer (9EE8H) register
(SHORT_STROKE). Two vectors can be defined at a time, one in the low byte and one in the high byte.
For the low byte, bits [7:5) define the direction, with bit 4 set to '1' for a draw operation or to 'O' for a
move current position operation. Bits 3-0 define the length of the short line. Let SSVDO, SSVD1,
... SSVDN-1 bytes be the short stroke vector data for N lines.
Setup:
Wait For FIFO 3 empty ; 3 commands to follow
PIXEL_CNTL ¢= AOOOH ; FRGD_MIX is the source of color source and mix type
FRGD_MIX ¢= 0027H ; use the foreground color, mix type NEW
FRGD_COLOR ¢= 00000004H ; foreground color index 4
Draw Operation:
CUR_X¢=x1 ; set starting horizontal position
CUR_Y ¢= y1 ; set starting vertical position
CMD ¢= 00010010XXX11111b ; NOP (bits 15-13), Byte Swap (bit 12), 16-bit transfers (bits 10-9),
; Draw (bit 4), RadialDir (bit 3), LPixelOff (bit 2), Multi-pixel (bit 1),
; Write (bit O)
While space available in the FIFO
SHORT _STROKE¢= SSVD1 SHL 8 + SSVDO ; SSVD1 shifted to high byte, SSVDO in low byte
SHORT _STROKE¢= SSVD3 SHL 8 + SSVD2 ; Byte swap turned on to read vectors out in
; correct order
SHORT_STROKE ¢= SSVDN-1SHL8 + SSVDN-2
.. 9005049 0000827 OTO ..
11-20 ENHANCED MODE PROGRAMMING

••
r
Vision864 Graphics Accelerator
S3 lncorporatad
11.3.3.11 Programmable Hardware Cursor
A programmable cursor is supported which is compatible with the Microsoft Windows (bit 4 of CR55
= 0) and X11 (bit 4 of CR55 = 1) cursor definitions. The cursor size is 64 pixels wide by 64 pixels high,
with the cursor pattern stored in an off-screen area of display memory. Two monochrome images 64
bits wide by 64 bits high (512 bytes per image) define the cursor shape. The first bit image is an AND
mask and the second bit image is an XOR mask. The following is the truth table for the cursor display
logic.
AND Bit XOR Bit Di~ayed (Microsoft Windows) Di~ayed (X11 I
0 0 Cursor Bac~ound Color Current Screen Pixel
0 1 Cursor For~ound Color Current Screen Pixel
1 0 Current Screen Pixel Cursor Bac~ound Color
1 1 NOT Current Screen Pixel Cursor Foreground Color
The Cursor Location High register (CRE) holds the hardware cursor foreground color and the Cursor
Location Low register (CRF) holds the hardware cursor background color when hardware cursor color
depth is 4/8 bits/pixel (CR45, bits 3-2 = OObl and an 8-bit RAMDAC is being used. For all other values
of bits 3-2 of CR45 when using an 8-bit RAMDAC, the hardware cursor color is taken from the Hardware
Graphics Cursor Foreground Stack (CR4Al and the Hardware Graphics Cursor Background Stack (CR4B)
registers. Each of these is a stack of four 8-bit registers. The stack pointers are reset to Oby reading the
Hardware Graphics Cursor Mode register (CR45). The color value is then programmed by consecutive
writes (low byte, second byte, third byte, fourth byte) to the appropriate (foreground or background)
register. When using a 16-bit RAMDAC, the cursor colors are always taken from CR4A and CR4B.
Enabling/Disabling the Cursor
The hardware cursor is disabled when a VGA-compatible mode is in use. It can be enabled or disabled
when in Enhanced mode (bit 0 of 4AE8H = 1), as follows.
CR39 <= AOH ; Unlock System Control registers
CR45_0 <= 1 ; Enable hardware cursor
CR45_0 <= 0 ; Disable hardware cursor
CR39 ¢=OOH ; Lock System Control registers
Positioning the Cursor
The cursor can be positioned at any point on the display, with the X,Y coordinates ranging from Oto
2047. This enables the full cursor images to be displayed on the screen and partial cursor images to
be displayed at the right edge and the bottom edge of the screen. The cursor offset OX,OY has to be
set to 0,0 for a 1024x768 resolution. If Xis> (1024 - 64) or Y is> (768 - 64), then a partial cursor is
visible at the right edge or top edge of the screen respectively. Note that if Y <'. 768 then the cursor is
not visible; it is residing in the off-screen area.
A partial cursor image can be displayed at the left edge or the top edge of the screen. To enable partial
cursor display at the top edge of the screen, Y is set to O and the Y offset register is set to OY (range
from Oto 63). This displays the bottom 64-0Y rows of the cursor image at the currently set X position
and the top edge of the screen. Similarly, a partial cursor can be displayed at the left edge of the screen
by setting X to O and the X offset register to OX (range from Oto 63). This displays the right 64-0X
columns of the cursor image at the currently set X and the left edge of the screen. The following
pseudocode illustrates cursor positioning.
.. 9005049 0000828 T37 .. ENHANCED MODE PROGRAMMING 11-21

Vision864 Graphics Accelerator
53 Incorporated
CR39 (': AOH ; Unlock System Control registers
CR46_ 10-8 (':MS 3 bits of X cursor position
CR47 _7-0 (':LS 8 bits of X cursor position
CR49_7-0 (': LS 8 bits of Y cursor position
CR4E_5-0 (': Cursor Offset X position
CR4F _5-0 (':Cursor Offset Y position
CR48_ 10-8 (': MS 3 bits of Y cursor position
CR39 (':OOH ; Lock System Control registers
The cursor position is updated by the hardware once each frame. Therefore, the programmer should
ensure that the position is re-programmed no more than once for each vertical sync period.
Programming the Cursor Shape
The AND and the XOR cursor image bitmaps are 512 bytes each. These are stored in consecutive bytes
of off-screen display memory, 512 AND bytes followed by 512 XOR bytes. The starting location must
be on a 1024-byte boundary. This location is programmed into the Hardware Graphics Cursor Start
Address registers {CR4C and CR4D) as follows:
CR39 (': AOH ; Unlock System Control registers
CR4C_ 11-8 (':MS 4 bits of the cursor storage start 1024-byte segment
CR4D (':LS 8 bits of the cursor storage start 1024-byte segment
CR39 (': O ; Lock System Control registers
The value programmed is the 1024-byte segment of display memory at which the beginning of the
hardware cursor bit pattern is located.
The 1024 bytes of cursor definition are then written directly to display memory by the CPU using linear
addressing.
Note
If the cursor is not 64 bits by 64 bits, the given images should be padded to make the cursor image 64
bits by 64 bits. The padded area should be made transparent by padding the extra AND mask bits with
'l's and the extra XOR bits by 'O's.
11.4 RECOMMENDED READING
Graphics Programming for the 8514/A by Jake Richter and Bud Smith (M&T Publishing, Inc) provides
extensive explanations and examples for programming most of the bits in the S3 Enhanced Registers.
Although not released at the time this data book was printed, the 3rd edition of Programming Guide
to the EGA and VGA Cards by Richard F. Ferraro (Addison-Wesley Publishing Company, Inc) is
scheduled to include a section on programming for S3 accelerator chips.
.. 9005049 0000829 973 ..
11-22 ENHANCED MODE PROGRAMMING

Vision864 Graphics Accelerator
53 Incorporated
Section 12: CGA-Compatible Register Descriptions
In the following register descriptions, "U" stands for undefined or unused and "R" stands for reserved
{write = 0, read = U).
See Appendix A for a table listing each register in this section and its page number.
Light Pen High Register {LPENH)
| Read Only  |     | Address: 3D5H, Index 10H  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 15  14  | 13  12  | 11  10  | 9  8  |
| ------- | ------- | ------- | ----- |
u
| u   | LI  ht Pen Strobe Address High  |     |     |
| --- | ------------------------------- | --- | --- |
Light Pen Low Register (LPENLI
| Read Only  |     | Address: 3D5H, Index 11H  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 5  4  | 3  2  | 0   |
| ----- | ----- | ----- | --- |
Light Pen Strobe Address Low
These registers contain the 14 memory address bits at the time the light pen strobe signal was detected
in CGA and HGC modes.
These registers are not available in VGA mode.
The light pen is not actually connected to most systems, but the LP set/reset flag can be used to read
the video memory addresses at the vertical retrace interval. The CPU can read the video memory
address through this register. The screen mode and the video memory address have a known ratio at
the vertical retrace interval. Therefore, the CPU can guess the screen mode {ex: low or high resolution,
and text or graphics) from the light pen detect address at the vertical retrace.
The mode register is a write-only register, except in VGA mode. The CPU cannot read any screen mode
information directly. Therefore the light pen detect address at the vertical retrace interval is used as a
mode indicator indirectly in CGA and HGC modes .
| .. 9005049  | 0000830  | 695  ..  |     |
| ----------- | -------- | -------- | --- |
CGA-COMPATIBLE REGISTER DESCRIPTIONS  12-1

••
r
Vision864 Graphics Accelerator
53 Incorporated
CGA Mode Control Register (CGA_MODE)
Read/Write Address: 3D8H
Power-On Default: OOH
7 6 5 4 3 2 1 0
TEXT HRES DISP BNV GRPH HRES
R R BLNK GRPH ENB MODE MODE TEXT
Bit 0 HRES TEXT -High Resolution Text
0 = 40 x 25 alpha mode
1 = 80 x 25 alpha mode
Bit 1 GRPH MODE -Graphics Mode
0 =Alpha Mode
1 = Graphics Mode
Bit 2 B/W MODE -Black/White Mode
O = Color enabled
1 = Color disabled. In 320 x 200 x 4 color mode, pixel bits represent:
00 =background
01 =cyan
10 =red
11 =white
Bit 3 DISP ENB -Display Enable
0 = Screen Blank
1 =Video Enabled
Bit 4 HRES GRPH -High Resolution Graphics
0 =all other modes
1 =Enable 640 x 200 graphics mode
Bit 5 TEXT BLNK -Text Blinking
0 =Blinking disabled
1 = Blinking enabled
Bits 7-6 Reserved
.. 9005049 0000831 521 ..
12-2 CGA-COMPATIBLE REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
CGA Color Select Register (CGA_COLOR)
Read/Write Address: 3D9H
Power-On Default: OOH
1 1 1
7 6 5 4 3 2 1 0
SEL SEL BORDER/BKGR COLOR
R R CSET I-EN I R G B
In 640 x 200 (2 color) mode, pixel bit= 0 corresponds to black and pixel bit= 1 corresponds to the
foreground color specified by bits 3-0 of this register.
Bit 0 BORDER/BKGR COLOR -Blue Border Select
0 = Blue not selected
1 =Select blue border in alpha mode, select blue background and border color in 320
x 200 graphics mode, select blue foreground color in 640 x 200 graphics mode.
Bit 1 BORDER/BKGR COLOR -Green Border Select
0 = Green not selected
1 =Select green border in alpha mode, select green background and border color in
320 x 200 graphics mode, select green foreground color in 640 x 200 graphics
mode.
Bit 2 BORDER/BKGR COLOR -Red Border Select
0 = Red not selected
1 =Select red border in alpha mode, select red background and border color in 320 x
200 graphics mode, select red foreground color in 640 x 200 graphics mode.
Bit 3 BORDER/BKGR COLOR -Intensified Border
O = No intensification
1 =Select intensified border in alpha mode, select intensified background and border
color in 320 x 200 graphics mode, select intensified foreground color in 640 x 200
graphics mode.
Bit 4 SEL I-EN -Alternate Color Set
O = Alternate color set not enabled
1 = Background color in alpha mode. Enable alternate (high intensity) color set in
graphics mode.
Bit 5 SEL CSET -Select color set in 320x200 mode
0 =Pixel Bits
00 =Background determined by bits 3-0
01 =Green
10 =Red
11 =Yellow
1 = Pixel Bits
00 =Background determined by bits 3-0
01 =Cyan
10 =Violet
11 =White
Bits 7-6 Reserved
.. 9005049 0000832 468 ..
CGA-COMPATIBLE REGISTER DESCRIPTIONS 12-3

••
r
Vision864 Graphics Accelerator
S3 Incorporated
CGA Status Register (CGA_STATI
Read Only Address: 3DAH
Power-On Default: Undefined
7 3 2 0
= 1 VSY = 1 LPF DTM
Bit O DTM -Border/Blanking Active
O = Active display
1 = Border/Blanking Active
Bit 1 LPF -Light Pen Flag
0 = Light Pen Latch cleared
1 = Light Pen Latch triggered
Bit 2 = 1
O = Light Pen switch closed (not available)
1 = Light Pen switch open
Bit 3 VSY -Vertical Sync Active
O = Inactive Vertical Sync
1 =Active Vertical Sync
Bits 7-4 Reserved = 1
.. 9005049 0000833 3T4 ..
12-4 CGA-COMPATIBLE REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Clear Light Pen Flag Register (CLPEN)
Write Only Address: 3DBH
Power-On Default: Undefined
7 6 5 4 3 2 0
Reset Light Pen Flag
The CPU can control the light pen flag with 1/0 writes with any data to 389H or 3DCH to set, and 3BBH
or 3DBH to reset. The CPU can guess the screen mode indirectly by reading the video memory address
at the vertical retrace interval. When the light pen flag is set to 1, the video memory address at that
time is stored in the Light Pen High and Low registers. The sequence to read the light pen detect address
is:
1. Clear the light pen flag with an 1/0 write to 3BBH or 3DBH.
2. Wait for the vertical sync signal (VSY) to set.
3. Set light pen flag with an 1/0 write to 3B9H or 3DCH.
4. Read the light pen detect address.
5. Return to 1.
Set Light Pen Flag Register(SLPEN)
Write Only Address: 3DCH
Power-On Default: Undefined
7 6 5 4 3 2 0
Set Light Pen Flag
A write of anything to this register sets the light pen flag. See the description for the Reset Lightpen
Flag register above.
.. 9005049 0000834 230 ..
CGA-COMPATIBLE REGISTER DESCRIPTIONS 12-5

=·
r
Vision864 Graphics Accelerator
S3 Incorporated
|     | Section 13: MDA- | and HGC-Compatible  |     |
| --- | ---------------- | ------------------- | --- |
Register Descriptions
In the following register descriptions, "U" stands for undefined or unused and "R" stands for reserved
(write= 0, read= U). See Appendix A for a table listing each register in this section and its page number.
Light Pen High Register (LPENH)
| Read Only  |     | Address: 3B5H, Index 10H  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: Undefined
Refer to the description in Section 12.
Light Pen Low Register (LPENL)
| Read Only  |     | Address: 3B5H, Index 11 H  |     |
| ---------- | --- | -------------------------- | --- |
Power-On Default: Undefined
Refer to the description in Section 12.
MDA-Mode Control Register {MDA_MODE)
| ReadNVrite  |     | Address: 3B8H  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: OOH
0
|            | ~;     | ~~~    |     |
| ---------- | ------ | ------ | --- |
| I : I : I  | I : I  | I : I  | I   |
R  R
| Bits 2-0  | Reserved  |                      |     |
| --------- | --------- | -------------------- | --- |
| Im        |           | Im                   |     |
| 9005049   | 0000835   | 177  ~~~~~~~~~~~~~~  |     |
MDA-AND HGC-COMPATIBLE REGISTER DESCRIPTIONS  13-1

••
|     | r   |     |     |     | Vision864 Graphics Accelerator  |
| --- | --- | --- | --- | --- | ------------------------------- |
53 Incorporated
|     | Bit 3  | DSP ENB -Enable Display  |     |     |     |
| --- | ------ | ------------------------ | --- | --- | --- |
0 = (screen blank)
1 =Video enabled
|     | Bit 4  | Reserved                |     |     |     |
| --- | ------ | ----------------------- | --- | --- | --- |
|     | Bit 5  | TXT BLK -Text Blinking  |     |     |     |
O = Blinking disabled
1 =Blinking enabled
|     | Bits 7-6  | Reserved  |     |     |     |
| --- | --------- | --------- | --- | --- | --- |
HGC-Mode Control Register IHGC_MODEI
|     | Read/Write  |     | Address: 3B8H  |     |     |
| --- | ----------- | --- | -------------- | --- | --- |
Power-On Default: OOH
|     | 7   | 6  5  | 4  3  | 2  1  | 0   |
| --- | --- | ----- | ----- | ----- | --- |
TXT
|     | HGC    |                           | DSP     | GRPPH  |     |
| --- | ------ | ------------------------- | ------- | ------ | --- |
|     |        | R  BLK                    |         | MODE   |     |
|     | PAGE   |                           | R  ENB  | R      | R   |
|     | Bit O  | Reserved                  |         |        |     |
|     | Bit 1  | GRPH MODE -Graphics Mode  |         |        |     |
0 = 80 x 25 alpha mode enabled
1 = 720 x 348 graphics mode enabled
|     | Bit 2  | Reserved                 |     |     |     |
| --- | ------ | ------------------------ | --- | --- | --- |
|     | Bit 3  | DSP ENB -Enable Display  |     |     |     |
0 = (screen blank)
1 =Video enabled
|     | Bit 4  | Reserved                |     |     |     |
| --- | ------ | ----------------------- | --- | --- | --- |
|     | Bit 5  | TXT BLK -Text Blinking  |     |     |     |
0 =Blinking disabled
1 =Blinking enabled
|     | Bit 6  | Reserved                          |     |     |     |
| --- | ------ | --------------------------------- | --- | --- | --- |
|     | Bit 7  | HGC PAGE -Hercules Graphics Page  |     |     |     |
0 =graphics mode buffer displayed from BOOOOH (video page Ol
1 =graphics mode buffer displayed from B8000H (video page 1)
| .. 9005049  |     | 0000836  | 003  | ..  |     |
| ----------- | --- | -------- | ---- | --- | --- |
13-2 MDA-AND HGC-COMPATIBLE REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Set Light Pen Flag Register (HGC_SLPEN)
| Write Only  |     | Address: 3B9H  |     |     |
| ----------- | --- | -------------- | --- | --- |
Power-On Default: Undefined
Refer to the description in Section 12.
HGC Status Register (HGC_STSJ
| Read Only  |     | Address: 3BAH  |     |     |
| ---------- | --- | -------------- | --- | --- |
Power-On Default: Undefined
|     | 6  5  | 4  3       | 2  1  | 0    |
| --- | ----- | ---------- | ----- | ---- |
|     | = 1   |            | = 1   |      |
|     | = 1   | = 1  V-DT  | LPF   | HSY  |
Bit O  HSY -Horizontal Sync
O =Active display
1 = Border/Blanking Active
Bit 1  LPF -Light Pen Flag
O =Light Pen Flag off
1 = Light Pen Flag on
Bit 2  Reserved = 1
Bit 3  V-DT -Black/White Video
O = B/W Video disabled
1 = B/W Video enabled
|     | Bits 6-4  Reserved = 1  |     |     |     |
| --- | ----------------------- | --- | --- | --- |
Bit 7  VSY -Vertical Sync Inactive
O =Active Vertical Sync
1 = Inactive Vertical Sync
| .. 9005049  | 0000837  | T4T  | ..  |     |
| ----------- | -------- | ---- | --- | --- |
MLJA-AND HGC-COMPATIBLE REGISTER DESCRIPTIONS 13-3

Vision864 Graphics Accelerator
53 Incorporated
MDA Status Register (MDA_STS)
| Read Only  |     | Address: 3BAH  |     |
| ---------- | --- | -------------- | --- |
Power-On Default: Undefined
0
HSY
= 1
Bit 0  HSY -Horizontal Sync
O = Active display
1 = Border/Blanking Active
| Bits 2-1  | Reserved = 1  |     |     |
| --------- | ------------- | --- | --- |
Bit3  TEST
0 = B/W Video disabled
1 = B/W Video enabled
| Bits 7-4  | Reserved = 1  |     |     |
| --------- | ------------- | --- | --- |
Clear Light Pen Flag Register IHGC_CLPENJ
| Write Only  |     | Address: 3BBH  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
Refer to the description in Section 12.
HGC Configuration Register (CONFIG)
| Write Only  |     | Address: 3BFH  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: OOH
| 7   | 6·  5  | 4  3  2  | 1  0  |
| --- | ------ | -------- | ----- |
ENB  ENB
| u   | u  u  | u  u  u  |     |
| --- | ----- | -------- | --- |
PAGE  GRPH
Bit 0  ENB PAGE -Enable Page
0 =Alpha mode is forced.
1 =Allows graphics mode.
Bit 1  ENB GRPH -Enable Graphics
O = Bit 7 of Hercules Mode register can't be set, thus video memory occupies BOOOOH
B7FFFH, which allows the CGA to coexist.
1 =Bit 7 of Hercules Mode register can be set, allowing upper memory page access.
| .. 9005049  | 0000838  | 986  ..  |     |
| ----------- | -------- | -------- | --- |
13-4 MDA-AND HGC-COMPATIBLE REGISTER DESCRIPTIONS

=·
r
Vision864 Graphics Accelerator
S3 Incorporated
Section 14: VGA Standard Register Descriptions
In the following register descriptions, 'U' stands for undefined or unused and 'R' stands for reserved
(write= 0, read= U). A question mark in an address stands for a hexadecimal value of either 'B' or 'D'.
If bit O of the Miscellaneous Output Register (3C2H, Write) is set to 1, the address is based at 3DxH for
color emulation. If this bit is reset to 0, the address is based at 3BxH for monochrome emulation.
See Appendix A for a table listing each register in this section and its page number.
| 14.1  GENERAL REGISTERS  |     |     |     |
| ------------------------ | --- | --- | --- |
This section describes general input status and output control registers.
Miscellaneous Output Register (MISC)
| Write Only  |     | Address: 3C2H  |     |
| ----------- | --- | -------------- | --- |
| Read Only   |     | Address: 3CCH  |     |
Power-On Default: OOH
This register controls miscellaneous output signals. A hardware reset sets all bits to zero.
I
| 7  6      | 5  4      | 3  2      | 1  0      |
| --------- | --------- | --------- | --------- |
|           |           | CLK  SEL  | ENS  IOA  |
| VSP  HSP  | PGSL  =0  | 1  0      | RAM  SEL  |
Bit 0  IOA SEL -1/0 Address Select
0 = Monochrome emulation. Address based at 3Bx
1 =Color emulation. Address based at 3Dx
Bit 1  ENB RAM -Enable CPU Display Memory Access
O = Disable access of the display memory from the CPU
1 = Enable access of the display memory from the CPU
| .. 9005049  | 0000839  | 812  ..  |     |
| ----------- | -------- | -------- | --- |
VGA STANDARD REGISTER DESCRIPTIONS  14-1

••
r Vision864 Graphics Accelerator
53 Incorporated
Bit 3-2 Clock Select -Select the Video Clock Source
00 = Selects 25.175 MHz clock for 640 horizontal pixels
01 =Selects 28.322 MHz clock for 720 horizontal pixels
10 =Reserved
11 =Enable dot clock select bits in the Mode Control register (CR42), bits 3-0. This is
an enhanced function
Bit 4 Reserved = 0
Bit 5 PGSL -Select High 64K Page
0 = Select the low 64K page of memory
1 =Select the high 64K page of memory
Bit 6 HSP -Select Negative Horizontal Sync Pulse
O = Select a positive horizontal retrace sync pulse
1 = Select a negative horizontal retrace sync pulse
Bit 7 VSP -Select Negative Vertical Sync Pulse
O =Select a positive vertical retrace sync pulse
1 = Select a negative vertical retrace sync pulse
Feature Control Register (FCR_WT, FCR_ADJ
Write Only Address: 3?AH
Read Only Address: 3CAH
Power-On Default: OOH
0
=0 =0
Bits 2-0 Reserved = 0
Bit 3 VSSL -Vertical Sync Type Select
O = Enable normal vertical sync output to the monitor
1 =The 'vertical sync' output is the logical OR of 'vertical sync' and 'vertical active
display enable' (an internal signal).
Bits 7-4 Reserved = O
.. 9005049 0000840 534 ..
14-2 VGA STANDARD REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
53 Incorporated
Input Status 0 Register ISTATUS_Ol
| Read Only  |     | Address: 3C2H  |     |     |     |
| ---------- | --- | -------------- | --- | --- | --- |
Power-On Default: Undefined
This register indicates the status of the VGA adapter.
| 7  6       | 5  4                                  | 3   | 2   | 1   | 0   |
| ---------- | ------------------------------------- | --- | --- | --- | --- |
| CRT        | MON                                   |     |     |     |     |
| INTPE  =0  | =0  SENS                              | =0  | =0  | =0  | =0  |
| Bits 3-0   | Reserved = O                          |     |     |     |     |
| Bit 4      | MON SENS -Monitor Sense Input Status  |     |     |     |     |
0 =The SENSE/BREQ input is a logical 0
1 =The SENSE/BREQ input is a logical 1
The SENSE/BREQ input functions as BREQ (memory bus request from another mem
ory master) when bit 2 of CR50 is set to 1.
| Bits 6-5  | Reserved = O                     |     |     |     |     |
| --------- | -------------------------------- | --- | --- | --- | --- |
| Bit 7     | CRT INTPE -CRT Interrupt Status  |     |     |     |     |
O =Vertical retrace interrupt cleared
1 =Vertical retrace interrupt pending. Interrupt generation is enabled via bit 5 of CR11
for VGA modes and bit 8 of 42E8H for Enhanced modes.
Input Status 1 Register (STATUS_ 1)
| Read Only  |     | Address: 3?AH  |     |     |     |
| ---------- | --- | -------------- | --- | --- | --- |
Power-On Default: Undefined
This register indicates video sync timing and video wraparound.
,
I
| 7  6  | 5  4  | 3   | 2   |     | 0   |
| ----- | ----- | --- | --- | --- | --- |
TST-VDT
| =0  =0  | 1  0  | VSY  | = 1  | LPF  | DTM  |
| ------- | ----- | ---- | ---- | ---- | ---- |
Bit O DTM -Display Mode Inactive
0 =The display is in the display mode.
1 =The display is not in the display mode. Either the horizontal or vertical retrace
period is active
| Bit 1  | LPF -Light Pen Flag Triggered  |     |     |     |     |
| ------ | ------------------------------ | --- | --- | --- | --- |
0 =Light pen has not been triggered
1 = Light pen has been triggered
| Bit 2  | Reserved = 1  |     |     |     |     |
| ------ | ------------- | --- | --- | --- | --- |
.. 9005049  0000841  470  ..  VGA STANDARD REGISTER DESCRIPTIONS  14-3

••
r
Vision864 Graphics Accelerator
S3 Incorporated
|     |     | Bit 3  VSY -Vertical Sync Active  |     |     |     |
| --- | --- | --------------------------------- | --- | --- | --- |
O = Display is in the display mode
1 = Display is in the vertical retrace mode
|     | Bits 5-4  | TST-VDT -Video Signal Test  |     |     |     |
| --- | --------- | --------------------------- | --- | --- | --- |
Video Data Feedback 1,0. These bits are feedback video signals to do read back tests.
These bits are selectively connected to two of the eight color outputs of the attribute
controller. Bits 5 and 4 of the color plane enable register (AR12) control the multi
plexer for this video output observation.
|     | Bits 7-6  | Reserved = O  |     |     |     |
| --- | --------- | ------------- | --- | --- | --- |
14.2 SEQUENCER REGISTERS
The sequencer registers are located at two-byte address spaces. These registers are accessed by first
writing the data to the index register of the sequencer at 1/0 address 3C4H and then writing to or reading
from the data register at 3C5H.
Sequencer Index Register (SEQX)
|     | Read/Write  |     | Address: 3C4H  |     |     |
| --- | ----------- | --- | -------------- | --- | --- |
Power-On Default: Undefined
This register is loaded with a binary value that indexes the sequencer register for read/write data. This
value is referred to as the "Index Number" of the SR register in this document.
|     | 7         | 6  5                                   | 4   | 3  2         | 1  0  |
| --- | --------- | -------------------------------------- | --- | ------------ | ----- |
|     | R         | R  R                                   | R   | SEO ADDRESS  |       |
|     | Bits 3-0  | SEQ ADDRESS -Sequencer Register Index  |     |              |       |
A binary value indexing the register where data is to be accessed.
|             | Bits 7-4  | Reserved = O  |      |     |     |
| ----------- | --------- | ------------- | ---- | --- | --- |
| .. 9005049  |           | 0000842       | 307  | ..  |     |
14-4 VGA STANDARD REGISTER DESCRIPTIONS

=·
r
Vision864 Graphics Accelerator
53 Incorporated
Sequencer Data Register (SEO_DATAJ
| Read/Write  |     | Address: 3C5H  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is the data port for the sequencer register indexed by the Sequencer Index register (3C4H).
| 7  6  | 5  4  | 3  2  | 0   |
| ----- | ----- | ----- | --- |
SEO DATA
| Bit 7-0  | SEQ DATA -Sequencer Register Data  |     |     |
| -------- | ---------------------------------- | --- | --- |
Data to the sequencer register indexed by the sequencer address index.
Reset Register (RST_ SVNC) (SRO)
| Read/Write  |     | Address: 3C5H, Index OOH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
Bit O  ASY RST -Asynchronous Reset
This bit is for VGA software compatibility only. It has no function for the Vision864.
Bit 1  SYN RST -Synchronous Reset
This bit is for VGA software compatibility only. It has no function for the Vision864.
| Bits 7-2    | Reserved = 0  |          |     |
| ----------- | ------------- | -------- | --- |
| .. 9005049  | 0000843       | 243  ..  |     |
VGA STANDARD REGISTER DESCRIPTIONS  14-5

••
r  Vision864 Graphics Accelerator
SJ Incorporated
Clocking Mode Register (CLK_MODE) ISR1)
|     | Read/Write  |     | Address: 3C5H, Index 01 H  |     |
| --- | ----------- | --- | -------------------------- | --- |
Power-On Default: OOH
This register controls the operation mode of dot clock and character clock.
|     | 7   | 6  5                            | 4  3  2        | 1  0     |
| --- | --- | ------------------------------- | -------------- | -------- |
|     |     | SCRN                            | SHF  DCK  SHF  |          |
|     | =0  | =0  OFF                         | 4  1/2  LD     | =0  BDC  |
|     |     | Bit 0  8DC -8 Dot Clock Select  |                |          |
O =Character clocks 9 dots wide are generated
1 =Character clocks 8 dots wide are generated
|     |     | Bit 1  Reserved = 0                                           |     |     |
| --- | --- | ------------------------------------------------------------- | --- | --- |
|     |     | Bit 2  SHF LD -Load Serializers Every Second Character Clock  |     |     |
O =Load the video serializer every character clock
1 =Load the video serializers every other character clock
|     |     | Bit 3  DCK 1/2 -Internal dot clock= 1/2 DCLK  |     |     |
| --- | --- | --------------------------------------------- | --- | --- |
0 =Set the internal dot clock to the same frequency as the DCLK input
1 = Set the internal dot clock to 1/2 the frequency of the DCLK input
|     |     | Bit 4  SHF 4 -Load Serialize rs Every Fourth Character Clock  |     |     |
| --- | --- | ------------------------------------------------------------- | --- | --- |
O =Load the serialize rs every.character clock cycle
1 =Load the serialize rs every fourth character clock cycle
|     |     | Bit 5  SCRN OFF -Screen Off  |     |     |
| --- | --- | ---------------------------- | --- | --- |
O = Screen is turned on
1 = Screen is turned off
|     | Bit 7-6  | Reserved = O  |     |     |
| --- | -------- | ------------- | --- | --- |
Enable Write Plane Register IEN_WT_PLJ (SR2J
|     | Read/Write  |     | Address: 3C5H, Index 02H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register selects write protection or write permission for CPU write access into video memory.
|     |           | 6                                  | 3  2      | 1  0  |
| --- | --------- | ---------------------------------- | --------- | ----- |
|     |           | =0                                 | EN.WT PL  |       |
|     | Bits 3-0  | EN.WT.PL -Enable Write to a Plane  |           |       |
O = Disables writing into the corresponding plane
1 =Enables the CPU to write to the corresponding color plane
| II  | 9005049  | 0000844  | 18T  II  |     |
| --- | -------- | -------- | -------- | --- |
14-6 VGA STANDARD REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
S3 Incorporated
| Bits 7-4  | Reserved = O  |     |     |
| --------- | ------------- | --- | --- |
Character Font Select Register (CH_FONT_ SL) (SR3)
| Read/Write  |     | Address: 3C5H, Index 03H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
|         |           | I     | I     |
| ------- | --------- | ----- | ----- |
| 7  6    | 5  4      | 3  2  | 1  0  |
|         | SLA  SLB  | SLA   | SLB   |
|         |           | 1     | 1     |
| =0  =0  | 2  2      | 0     | 0     |
In text modes, bit 3 of the attribute byte normally turns the foreground intensity on or off. This bit can
be redefined to be a switch between two character sets. The switch is enabled when there is a difference
between the value of character font select A and character font select B bits. Memory Mode (SR4)
register bit 1 = 1 (extended memory) enables all bits of this function; otherwise character fonts O and
4 are available. 256 KBytes of video memory support 8 character sets. This register is reset to O
asynchronously during a system reset.
SLB -Select Font B
Bits 4, 1-0
This value selects the portion of plane 2 used to generate text character fonts when
bit 3 of the attribute byte is a logical 1, according to the following table:
Bits  Font Table Location
|              | Bits  Font Table Location   |     |                            |
| ------------ | --------------------------- | --- | -------------------------- |
|              | 4,1,0                       |     | 4, 1,0                     |
|              | 000  First 8K of_12.lane 2  |     | 100  Second 8K of_pJane 2  |
|              | 001  Third 8K of_pJane 2    |     | 101  Fourth 8K of_Q!ane 2  |
|              | 010  Fifth 8K of_pJane 2    |     | 110  Sixth 8K of _pJane 2  |
|              | 011  Seventh 8K of plane 2  |     | 111  Eighth 8K of plane 2  |
| Bits 5, 3-2  | SLA -Select Font A          |     |                            |
This value selects the portion of plane 2 used to generate text character fonts when
bit 3 of attribute byte is a logical 0, according to the same table as the character font
select A.
| Bits 7-6  | Reserved = O  |     |     |
| --------- | ------------- | --- | --- |
.. 9005049  0000845  016  ..  VGA STANDARD REGISTER DESCRIPTIONS  14-7

Vision864 Graphics Accelerator
53 Incorporated
Memory Mode Control Register (MEM_MODEl (SR4)
|     | Read/Write  |     | Address: 3C5H, Index 04H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register controls CPU memory addressing mode.
|     | 7   | 6  5    | 4  3  2       | 1  0     |
| --- | --- | ------- | ------------- | -------- |
|     |     |         | CHN  SEO      | EXT      |
|     | =0  | =0  =0  | =0  4M  MODE  | MEM  =0  |
Bit O Reserved = 0
|     |     | Bit 1  EXT MEM -Extended Memory Access  |     |     |
| --- | --- | --------------------------------------- | --- | --- |
O = Memory access restricted to 16/32 KBytes
1 =Allows complete memory access to 256 KBytes. Required for VGA
|     |     | Bit 2  SEQ MODE -Sequential Addressing Mode  |     |     |
| --- | --- | -------------------------------------------- | --- | --- |
This bit affects only CPU write data accesses into video memory. Bit 3 of this register
must be O for this bit to be effective.
O =Enables the odd/even addressing mode. Even addresses access planes O and 2.
Odd addresses access planes 1 and 3
1 = Directs the system to use a sequential addressing mode
|     |     | Bit 3  CHN 4M -Select Chain 4 Mode  |     |     |
| --- | --- | ----------------------------------- | --- | --- |
0 =Enables odd/even mode.  _
1 =Chain 4 Mode. This bit selects modulo 4 addressing for CPU access to display
memory. A logical 1 directs the two lower order bits of the CPU address used to
select the plane in video memory to be accessed as follows:
|             |           | A1            | AO  Plane Selected  |     |
| ----------- | --------- | ------------- | ------------------- | --- |
|             |           | 0             | 0  0                |     |
|             |           | 0             | 1  1                |     |
|             |           | 1             | 0  2                |     |
|             |           | 1             | 1  3                |     |
|             | Bits 7-4  | Reserved = 0  |                     |     |
| .. 9005049  |           | 0000846       | T52  ..             |     |
14-8 VGA STANDARD REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Unlock Extended Sequencer Register (UNLK_EXSRI (SR81
|     | Read/Write  |     | Address: 3C5H, Index 08H  |     |     |
| --- | ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
Loading xxxx0110b (e.g., 06HI unlocks the Extended Sequencer register (SRO} for reading/writing.
(x =don't care).
|     | 7  6  | 5  4  |     |     |     |
| --- | ----- | ----- | --- | --- | --- |
|     | R  R  | R  R  |     | =1  |     |
Extended Sequencer Register (EX_SR_D) (SRO)
|     | Read/Write  |     | Address: 3C5H, Index OOH  |     |     |
| --- | ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
|     | l  6  | 5  l  4  | 3   | 2  1  | 0   |
| --- | ----- | -------- | --- | ----- | --- |
7
|     | VSY-CTL  | HSY-CTL  | R   | R  R  | R   |
| --- | -------- | -------- | --- | ----- | --- |
|     | 1  0     | 1  0     |     |       |     |
This register provides independent control of the HSYNC and VSYNC signals, therefore supporting
the VESA DPMS (Display Power Management Control) standard.
|     | Bits 3-0  | Reserved                |     |     |     |
| --- | --------- | ----------------------- | --- | --- | --- |
|     | Bits 5-4  | HSY-CTL -HSYNC Control  |     |     |     |
00 = Normal operation
01=HSYNC=0
10 = HSYNC = 1
11 = Reserved
VSY-CTL -VSYNC Control
Bits 7-6
00 = Normal operation
01=VSYNC=0
10 = VSYNC = 1
11 = Reserved
| .. 9005049  |     | 0000847  | 999  | ..  |     |
| ----------- | --- | -------- | ---- | --- | --- |
VGA STANDARD REGISTER DESCRIPTIONS  14-9

=·
r
Vision864 Graphics Accelerator
53 Incorporated
14.3 CRT CONTROLLER REGISTERS
The CRT controller registers are located at two locations in 1/0 address space. These registers are
accessed by first writing to the index register of the CRT controller and then accessing the data register.
The index register is located at 1/0 address 3?4H and the CRT Controller Data register is at 3?5H. Which
address is used (3BX or 3DX) depends on bit 0 of the Miscellaneous Output register at 3C2H.
CRT Controller Index Register (CRTC_ADR) (CRX)
|     | Read/Write  |     | Address: 3?4H  |     |     |
| --- | ----------- | --- | -------------- | --- | --- |
Power-On Default: OOH
This register is loaded with a binary value that indexes the CRT controller register where data is to be
accessed. This value is referred to as the "Index Number" of the CR register {CR00-18). This register
is also used as an index to the S3 VGA registers, the System Control Registers and the System Extension
registers.
|     | 7   | 6  5  | 4  3  | 2  1  | 0   |
| --- | --- | ----- | ----- | ----- | --- |
CRTC ADDRESS
|     | Bits 7-0  | CRTC ADDRESS -CRTC Register Index  |     |     |     |
| --- | --------- | ---------------------------------- | --- | --- | --- |
A binary value indexing the register where data is to be accessed.
CRT Controller Data Register (CRTC_DATAI (CRT)
|     | Read/Write  |     | Address: 375H  |     |     |
| --- | ----------- | --- | -------------- | --- | --- |
Power-On Default: Undefined
This register is the data port for the CRT controller register indexed by the CRT Controller Address
register.
|     |     | 6  5  | 4  3  | 2   | 0   |
| --- | --- | ----- | ----- | --- | --- |
7
CRTC DATA
|     | Bits 7-0  | CRTC DATA -CRTC Register Data  |     |     |     |
| --- | --------- | ------------------------------ | --- | --- | --- |
Data to the CRT controller register indexed by the CRT controller address index.
| .. 9005049  |     | 0000848  | 825  ..  |     |     |
| ----------- | --- | -------- | -------- | --- | --- |
14-10 VGA STANDARD REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Horizontal Total Register (H_TOTAL) (CRO)
| Read/Write  |     | Address: 3?5H, Index OOH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register defines the number of character clocks from HSYNC going active to the next HSYNC going
active. In other words, it is the total time required for both the displayed and non-displayed portions
of a singe scan line. Bit 8 of this value is bit 0 of CR5D.
| 7  6  | 5  4  | 3  2  | 0   |
| ----- | ----- | ----- | --- |
HORIZONTAL TOTAL
| Bits 7-0  | HORIZONTAL TOTAL.  |     |     |
| --------- | ------------------ | --- | --- |
9-bit Value= (number of character clocks in one scan line) -5. This register contains
the least significant 8 bits of this value.
Horizontal Display End Register (H_D_ENDJ (CR1)
| Read/Write  |     | Address: 3?5H, Index 01H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register defines the number of character clocks for one line of the active display. Bit 8 of this value
is bit 1 of CR5D.
| 7  6  | 5  4  | 3  2  | 0   |
| ----- | ----- | ----- | --- |
HORIZONTAL DISPLAY END
| Bits 7-0  | HORIZONTAL DISPLAY END  |     |     |
| --------- | ----------------------- | --- | --- |
9-bit Value= (number of character clocks of active display) -1. This register contains
the least significant 8 bits of this value .
| .. 9005049  | 0000849  | 761  ..  |     |
| ----------- | -------- | -------- | --- |
VGA STANDARD REGISTER DESCRIPTIONS  14-11

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Start Horizontal Blank Register (S_H_BLNKI (CR21
|     | Read/Write  |     | Address: 3?5H, Index 02H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the value of the character clock counter at which the BLANK signal is asserted.
Bit 8 of this value is bit 2 of CR5D.
|     | 7   | 6  5  | 4  3  | 2  1  0  |
| --- | --- | ----- | ----- | -------- |
START HORIZONTAL BLANK
|     | Bits 7-0  | START HORIZONTAL BLANK  |     |     |
| --- | --------- | ----------------------- | --- | --- |
9-bit Value= character clock value at which horizontal blanking begins. This register
contains the least significant 8 bits of this value.
End Horizontal Blank Register (E_H_BLNKI (CR3)
|     | Read/Write  |     | Address: 3?5H, Index 03H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register determines the pulse width of the BLANK signal and the display enable skew.
|     |     | I     | I  l  | I        |
| --- | --- | ----- | ----- | -------- |
|     | 7   | s  5  | 4     | 1  l  0  |
|     |     |       | 3     | 2        |
DSP-SKW
|     | R        | 1  0                  | END HORIZONTAL BLANK  |     |
| --- | -------- | --------------------- | --------------------- | --- |
|     | Bits4-0  | END HORIZONTAL BLANK  |                       |     |
6-bit Value= least significant 6 bits of the character clock counter value at which time
horizontal blanking ends. To obtain this value, add the desired BLANK pulse width in
character clocks to the Start Horizontal Blank value, which is also in character clocks.
The 5 least significant bits of this sum are programmed into this field. The sixth bit is
programmed into bit 7 of CR5. This allows a maximum pulse width of 63 character
clocks. This pulse width can be extended by 64 DCLKs via bit 3 of CR5D.
DSP-SKW -Display Skew
Bits 6-5
These two bits determine the amount of display enable skew. Display enable skew
control provides sufficient time for the CRT Controller to access the display buffer to
obtain a character and attribute code, access the character generator font, and then
go through the Horizontal Pixel Panning register in the Attribute Controller. Each ac
cess requires the display enable signal to be skewed one character clock unit so the
video output is synchronous with the HSYNC and VSYNC signals. The bit values and
amount of skew are shown in the following table:
00 =Zero character clock skew
01 =One character clock skew
10 =Two character clock skew
11 =Three character clock skew
|             |     | Bit 7  Reserved  |          |     |
| ----------- | --- | ---------------- | -------- | --- |
| .. 9005049  |     | 0000850          | 483  ..  |     |
14-12 VGA STANDARD REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
53 Incorporated
Start Horizontal Sync Position Register (S_H_SV_ P) !CR4)
| Read/Write  |     | Address: 3?5H, Index 04H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register is used to adjust the screen center horizontally and to specify the character position at
which HSYNC becomes active. Bit 8 of this value is bit 4 of CR5D.
| 7   | 6  5  | 4  3  | 2  1  0  |
| --- | ----- | ----- | -------- |
START HORIZONTAL SYNC POSITION
| Bits 7-0  | START HORIZONTAL SYNC POSITION.  |     |     |
| --------- | -------------------------------- | --- | --- |
9-bit Value= character clock counter value at which HSYNC becomes active. This reg
ister contains the least significant 8 bits of this value.
End Horizontal Sync Position Register (E_H_SY _P) (CR5)
| Read/Write  |     | Address: 3?5H, Index 05H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies when the HSYNC signal becomes inactive and the horizontal skew. The HSYNC
pulse defined by this register can be extended by 32 DCLKs via bit 5 of CR5D.
|     | l   | l        | I  I     |
| --- | --- | -------- | -------- |
| 7   | 5   | 4  3  l  | 2  1  0  |
6
| EHB       | HOR-SKW                  |                          |     |
| --------- | ------------------------ | ------------------------ | --- |
| b5        | 1  0                     | END HORIZONTAL SYNC POS  |     |
| Bits 4-0  | END HORIZONTAL SYNC POS  |                          |     |
5-bit Value= 5 least significant bits of the character clock counter value at which time
HSYNC becomes inactive. To obtain this value, add the desired HSYNC pulse width in
character clocks to the Start Horizontal Sync Position value, also in character clocks.
The 5 least significant bits of this sum are programmed into this field. This allows a
maximum HSYNC pulse width of 31 character clocks. This pulse width can be ex
tended by 32 DCLKs via bit 5 of CR5D.
| Bits 6-5  | HOR-SKW -Horizontal Skew  |     |     |
| --------- | ------------------------- | --- | --- |
These bits control the skew of the HSYNC signal. A binary 00 equals no HSYNC delay.
For some modes, it is necessary to provide an HSYNC signal that takes up the entire
blanking interval. Some internal timings are generated by the falling edge of the
HSYNC signal. To guarantee the signals are latched properly, HSYNC is asserted be
fore the end of the display enable signal, and then skewed several character clock
times to provide the proper screen centering.
00 =Zero character clock skew
01 =One character clock skew
10 =Two character clock skew
11 =Three character clock skew
| .. 9005049  | 0000851  | 31T  ..  |     |
| ----------- | -------- | -------- | --- |
VGA STANDARD REGISTER DESCRIPTIONS  14-13

Vision864 Graphics Accelerator
S3 Incorporated
|     | Bit 7  | EHB b5  |     |     |
| --- | ------ | ------- | --- | --- |
End Horizontal Blanking bit 5.
Vertical Total Register (V_TOTALJ (CR6)
|     | Read/Write  |     | Address: 3?5H, Index 06H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the number of scan lines from one VSYNC active to the next VSYNC active.
The scan line counter resets to Oat this point. Bit 8 is bit O of CR7. Bit 9 is bit 5 of CR7. Bit 10 is bit O
of CR5E.
|     | 7   | 6  5  | 4  3  2  | 0   |
| --- | --- | ----- | -------- | --- |
VERTICAL TOTAL
|     | Bits 7--0  | VERTICAL TOTAL  |     |     |
| --- | ---------- | --------------- | --- | --- |
11-bit Value= {number of scan lines from VSYNC active to the next VSYNC active) -2.
This register contains the least significant 8 bits of this value.
CRTC Overflow Register (OVFL_REGJ (CR7J
|     | Read/Write  |     | Address: 3?5H, Index 07H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
|     | 7    | 6  5     | 4  3  2        | 1  0     |
| --- | ---- | -------- | -------------- | -------- |
|     | VRS  | VOE  VT  | LCM  SVB  VRS  | VOE  VT  |
|     | 9    | 9  9     | 8  8  8        | 8  8     |
This register provides extension bits for fields in other registers.
|             | Bit O  | Bit 8 of the Vertical Total register (CR6)           |          |     |
| ----------- | ------ | ---------------------------------------------------- | -------- | --- |
|             | Bit 1  | Bit 8 of the Vertical Display End register {CR12)    |          |     |
|             | Bit 2  | Bit 8 of the Vertical Retrace Start register (CR10)  |          |     |
|             | Bit 3  | Bit 8 of the Start Vertical Blank register (CR15)    |          |     |
|             | Bit 4  | Bit 8 of the Line Compare register (CR18)            |          |     |
|             | Bit 5  | Bit 9 of the Vertical Total register (CR6)           |          |     |
|             | Bit 6  | Bit 9 of the Vertical Display End register (CR12)    |          |     |
|             | Bit 7  | Bit 9 of the Vertical Retrace Start register (CR10)  |          |     |
| .. 9005049  |        | 0000852                                              | 25b  ..  |     |
14-14 VGA STANDARD REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Preset Row Scan Register IP_ R_SCAN) (CRB)
| Read/Write  |     | Address: 3?5H, Index 08H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register is used for the pixel scrolling and panning, and text formatting and vertical scrolling.
|     | l     | l  l  | l  l     |
| --- | ----- | ----- | -------- |
| 7   | 6  5  | 4  3  | 2  1  0  |
BYTE-PAN
| =0        | 1  0                    | PRE-SET ROW SCAN COUNT  |     |
| --------- | ----------------------- | ----------------------- | --- |
| Bits 4-0  | PRE-SET ROW SCAN COUNT  |                         |     |
Value= starting row within a character cell for the first character row displayed after
vertical retrace. This allows a partial character row to be displayed at the top of the
display and is used for scrolling.
BYTE-PAN
Bits 6-5
Value =number of bytes to pan. The number of pixels to pan is specified in AR13.
| Bit 7  | Reserved = 0  |     |     |
| ------ | ------------- | --- | --- |
Maximum Scan Line Register (MAX_S_LNI (CR9l
| Read/Write  |     | Address: 3?5H, Index 09H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the number of scan lines per character row and provides one scanning control
bit and two overflow bits.
|     |          | I  I  | I        |
| --- | -------- | ----- | -------- |
| 7   | 6  5  4  |       | 1  l  0  |
3  2
| DBL  LCM  | SVB            |                |     |
| --------- | -------------- | -------------- | --- |
| SCN       | 9  9           | MAX SCAN LINE  |     |
| Bits 4-0  | MAX SCAN LINE  |                |     |
Value= (number of scan lines per character row) -1
| Bit 5  | SVB 9  |     |     |
| ------ | ------ | --- | --- |
Bit 9 of the Start Vertical Blank Register (CR15)
| Bit 6  | LCM 9  |     |     |
| ------ | ------ | --- | --- |
Bit 9 of the Line Compare Register (CR18)
| Bit7  | DBL SCN  |     |     |
| ----- | -------- | --- | --- |
O = Normal operation
1 =Enables double scanning operation. Each line is displayed twice by repeating the
row scan counter and video memory address. Vertical parameters in the CRT
controller are not affected .
.. 9005049  0000853  192  ..  VGA STANDARD REGISTER DESCRIPTIONS  14-15

Vision864 Graphics Accelerator
S3 Incorporated
Cursor Start Scan Line Register (CSSL) (CRA)
|     | Read/Write  |     | Address: 3?5H, Index OAH  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
The cursor start register defines the row scan of a character line where the cursor begins.
|     |     |       | I  I  | I  I     |
| --- | --- | ----- | ----- | -------- |
|     | 7   | 6  5  | 4  3  | 2  1  0  |
CSR
|     | =0        | =0  OFF                     | CSR CURSOR START SCAN LINE  |     |
| --- | --------- | --------------------------- | --------------------------- | --- |
|     | Bits 4-0  | CSR CURSOR START SCAN LINE  |                             |     |
Value= (starting cursor row within the character cell) -1. When the cursor start regis
ter is programmed with a value greater than the cursor end register, no cursor is gen
erated.
|     |     | Bit5  CSR OFF  |     |     |
| --- | --- | -------------- | --- | --- |
O =Turns on the text cursor
1 =Turns off the text cursor
|     | Bits 7-6  | Reserved = 0  |     |     |
| --- | --------- | ------------- | --- | --- |
Cursor End Scan Line Register (CESL) (CRBI
|     | Read/Write  |     | Address: 3?5H, Index OBH  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register defines the row scan of a character line where the cursor ends.
|     |     | l     | l  l  | l  l     |
| --- | --- | ----- | ----- | -------- |
|     | 7   | 6  5  | 4  3  | 2  1  0  |
CSR-SKW
|     | =0        | 1  0                  | CURSOR END SCAN LINE  |     |
| --- | --------- | --------------------- | --------------------- | --- |
|     | Bits 4-0  | CURSOR END SCAN LINE  |                       |     |
Value= ending scan line number within the character cell for the text cursor. If the
value of the cursor start scan line is greater than the value of cursor end line, then no
cursor is generated.
|     | Bits 6-5  | CSR-SKW -Cursor Skew  |     |     |
| --- | --------- | --------------------- | --- | --- |
These bits control the delay skew of the cursor signal. Cursor skew delays the text cur
sor by the selected number of clocks. For example, a skew of 1 moves the cursor
right one character position on the screen.
00 =Zero character clock skew
01 =One character clock skew
10 =Two character clock skew
11 =Three character clock skew
|             |     | Bit 7  Reserved = O  |          |     |
| ----------- | --- | -------------------- | -------- | --- |
| .. 9005049  |     | 0000854              | 029  ..  |     |
14-16 VGA STANDARD REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Start Address High Register (STA(H)) (CRC)
| Read/Write  |     | Address: 3?5H, Index OCH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 15  14  | 13  12  | 11  10  | 9  8  |
| ------- | ------- | ------- | ----- |
DISPLAY START ADDRESS (HIGH)
20-bit Value= the first address after a vertical retrace at which the display on the screen begins on each
screen refresh. These along with bits 3-0 of CR69 are the high order start address bits.
Start Address Low Register (STA(L)) (CRD)
| Read/Write  |     | Address: 3?5H, Index ODH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 5  4  | 3  2  | 0   |
| ----- | ----- | ----- | --- |
DISPLAY START ADDRESS (LOW)
Start address (low) contains the 8 low order bits of the address.
Cursor Location Address High Register (CLA(H)) (CREI
| Read/Write  |     | Address: 3?5H, Index OEH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 15  14  | 13  12  | 11  10  | 9  8  |
| ------- | ------- | ------- | ----- |
CURSOR LOCATION ADDRESS (HIGH)
20-bit Value =the cursor location address of the video memory where the text cursor is active. This
register along with bits 3-0 of CR69 are the high order bits of the address. When using a 4/8 bits/pixel
color depth and an 8-bit RAMDAC in Enhanced mode, this register contains the hardware cursor
foreground color .
.. 9005049  0000855  T65  ..  VGA STANDARD REGISTER DESCRIPTIONS  14-17

Vision864 Graphics Accelerator
53 Incorporated
Cursor Location Address Low Register (CLA(L)) (CRF)
|     | Read/Write  |     | Address: 3?5H, Index OFH  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
|     | 7   | 6  5  | 4  3  2  | 1  0  |
| --- | --- | ----- | -------- | ----- |
CURSOR LOCATION ADDRESS (LOW)
Cursor location address (low) contains the 8 low order bits of the address. When using a 4/8 bits/pixel
color depth and an 8-bit RAMDAC in Enhanced mode, this register contains the hardware cursor
background color.
Vertical Retrace Start Register (VRS) (CR10)
|     | Read/Write  |     | Address: 375H, Index 10H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
|     | 7   | 6  5  | 4  3  2  | 0   |
| --- | --- | ----- | -------- | --- |
VERTICAL RETRACE START
|     | Bits 7-0  | VERTICAL RETRACE START.  |     |     |
| --- | --------- | ------------------------ | --- | --- |
11-bit Value= number of scan lines at which VSYNC becomes active. These are the
low-order 8 bits. Bit 8 is bit 2 of CR7. Bit 9 is bit 7 of CR7. Bit 10 is bit 4 of CR5E.
Vertical Retrace End Register (VRE) (CR11)
|     | Read/Write  |     | Address: 3?5H, Index 11H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: OxH
This register controls the vertical interrupt and CR0-7
|     |           |                       | l                           | l  l  |
| --- | --------- | --------------------- | --------------------------- | ----- |
|     | 7         | 6  5                  | 4  3  2                     | 1  0  |
|     | LOCK      | REF  DIS              | CLR                         |       |
|     | R0-7      | 3/5  VINT             | VINT  VERTICAL RETRACE END  |       |
|     | Bits 3-0  | VERTICAL RETRACE END  |                             |       |
Value= least significant 4 bits of the scan line counter value at which VSYNC goes in
active. To obtain this value, add the desired VSYNC pulse width in scan line units to
the CR10 value, also in scan line units. The 4 least significant bits of this sum are pro
grammed into this field. This allows a maximum VSYNC pulse width of 15 scan line
units.
| .. 9005049  |     | 000085b  | 9T1  ..  |     |
| ----------- | --- | -------- | -------- | --- |
14-18 VGA STANDARD REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
53 Incorporated
Bit 4 CLR VINT -Clear Vertical Retrace Interrupt
0 =Vertical retrace interrupt cleared
1 =The flip-flop is able to catch the next interrupt request
At the end of active vertical display time, a flip-flop is set for a vertical interrupt. The
output of this flip-flop goes to the system interrupt controller. The CPU has to reset
this flip-flop by writing a logical 0 to this bit while in the interrupt process, then set
the bit to 1 to allow the flip-flop to catch the next interrupt request. Do not change the
other bits in this register. This bit is cleared to Oby the BIOS during a mode set, a re
set, or power-on.
Bit 5 DIS VINT -Disable Vertical Interrupt
0 =Vertical retrace interrupt enabled
1 =Vertical interrupt disabled. This bit is cleared to Oby the BIOS during a mode set,
a reset, or power-on
Bit 6 REF 3/5 -Refresh Cycle Select
O =Three DRAM refresh cycles generated per horizontal line
1 = Five DRAM refresh cycles generated per horizontal line. Selecting five refresh
cycles allows use of the VGA chip with slow sweep rate displays { 15.75 KHz).
This bit is cleared to Oby the BIOS during a mode set, a reset, or power-on. This
setting can be overridden via bits 1-0 of CR3A
Bit 7 LOCK R0-7 -Lock Writes to CRT Controller Registers
O =Writing to all CRT Controller registers enabled
1 =Writing to all bits of the CRT Controller registers CRO-CR7 except bit 4 of CR7
{LCM8) disabled. This bit is set to 1 by the BIOS during a mode set, a reset or
power-on
Vertical Display End Register (VDEJ (CR12J
Read/Write Address: 3?5H, Index 12H
Power-On Default: Undefined
The vertical display enable end register defines 8 bits of the 10-bit address of the scan line where the
display on the screen ends. The ninth and the tenth bits are bits 1 and 6 of CR7. Bit 11 is bit 1 of CR5E.
7 6 5 4 3 2 1 0
VERTICAL DISPLAY END
Bit 7-0 VERTICAL DISPLAY END
11-bit Value= {number of scan lines of active display) -1. This register contains the
least significant 8 bits of this value .
.. 9005049 0000857 838 ..
VGA STANDARD REGISTER DESCRIPTIONS 14-19

Vision864 Graphics Accelerator
53 Incorporated
Offset Register (SCREEN-OFFSET) (CR13l
|     | Read/Write  |     | Address: 3?5H, Index 13H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the logical line width of the screen and is sometimes called the screen pitch. The
starting memory address for the next display row is larger than the current row by two, four or eight
times this amount. Bits 5-4 of CR51 are extension bits 9-8 of this register. If these bits are OOb, bit 2 of
CR43 is extension bit 8 of this register.
|     |     | 6  5  | 4  3  | 2   |
| --- | --- | ----- | ----- | --- |
7  0
LOGICAL SCREEN WIDTH
|     | Bits 7-0  | LOGICAL SCREEN WIDTH  |     |     |
| --- | --------- | --------------------- | --- | --- |
10-bit Value= quantity that is multiplied by 2 (byte mode), 4 (word) mode or 8 (dou
bleword mode) to specify the difference between the starting byte addresses of two
consecutive scan lines. This register contains the least significant 8 bits of this value.
The addressing mode is specified by bit 6 of CR14 and bit 3 of CR17. Setting bit 3 of
CR31 to 1 forces doubleword mode.
Underline Location Register (ULL) (CR14)
|     | Read/Write  |     | Address: 3?5H, Index 14H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the horizontal row scan position of underline and display buffer addressing
modes.
|     | 7          | 6  5                 | 4  l  3              | l  2  l  1  l  0  |
| --- | ---------- | -------------------- | -------------------- | ----------------- |
|     |            | DBWD  CNT            |                      |                   |
|     | =0         | MODE  BY4            | UNDER LINE LOCATION  |                   |
|     | Bits 4--0  | UNDER LINE LOCATION  |                      |                   |
5-bit Value= (scan line count of a character row on which an underline occurs) -1
|     |     | Bit 5  CNT BY4 -Select Count by 4 Mode  |     |     |
| --- | --- | --------------------------------------- | --- | --- |
0 =The memory address counter depends on bit 3 of CR17 (count by 2)
1 =The memory address counter is incremented every four character clocks
The CNT BY4 bit is used when double word addresses are used.
|     |     | Bit 6  DBLWD MODE -Select Doubleword Mode  |     |     |
| --- | --- | ------------------------------------------ | --- | --- |
0 =The memory addresses are byte or word addresses
1 =The memory addresses are doubleword addresses
|             |     | Bit 7  Reserved = O  |                          |     |
| ----------- | --- | -------------------- | ------------------------ | --- |
| .. 9005049  |     | 0000858              | 774_.~ . ~~~~~~~~~~~~~~  |     |
14-20 VGA STANDARD REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
53 Incorporated
Start Vertical Blank Register (SVBI !CR15)
| Read/Write  |     | Address: 3?5H, Index 15H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the scan line at which the vertical blanking period begins. Bit 8 is bit 3 of CR7.
Bit 9 is bit 5 of CR9. Bit 10 is bit 2 of CR5E.
| 7  6  | 5  4  | 3  2  | 0   |
| ----- | ----- | ----- | --- |
START VERTICAL BLANK
| Bits 7--0  | START VERTICAL BLANK.  |     |     |
| ---------- | ---------------------- | --- | --- |
11-bit value= (scan line count at which BLANK becomes active) -1. This register con
tains the least significant 8 bits of this value.
End Vertical Blank Register IEVBI ICR16)
| Read/Write  |     | Address: 3?5H, Index 16H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the scan line count value when the vertical blank period ends.
| 7  6  | 5  4  | 3  2  | 0   |
| ----- | ----- | ----- | --- |
END VERTICAL BLANK
| Bits 7--0  | END VERTICAL BLANK  |     |     |
| ---------- | ------------------- | --- | --- |
Value= least significant 8 bits of the scan line counter value at which vertical blank
ing ends. To obtain this value, add the desired width of the vertical blanking pulse in
scan lines to [(value in the Start Vertical Blank register)-1], also in scan lines. The 8
least significant bits of this sum are programmed into this field. This allows a maxi
mum vertical blanking pulse of 63 scan line units .
| .. 9005049  | 0000859  | 600  ..  |     |
| ----------- | -------- | -------- | --- |
VGA STANDARD REGISTER DESCRIPTIONS  14-21

=·
r
Vision864 Graphics Accelerator
53 Incorporated
CRTC Mode Control Register (CRT _MDI (CR17J
|     | Read/Write  |     | Address: 3?5H, Index 17H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register is a multifunction control register, with each bit defining a different specification.
|     | 7          | 6  5                                           | 4  3  2       | 1  0      |
| --- | ---------- | ---------------------------------------------- | ------------- | --------- |
|     |            | BYTE  ADW                                      | WRD  VT       | 4BK  2BK  |
|     | RST  MODE  | 16K                                            | =0  MODE  X2  | HGC  CGA  |
|     | Bit 0      | 2BK CGA -Select Bank 2 Mode for CGA Emulation  |               |           |
0 =Row scan counter bit 0 is substituted for memory address bit 13 during active
display time
1 =Memory address bit 13 appears on the memory address output bit 13 signal of
the CRT controller
This bit allows memory mapping compatibility with the IBM CGA graphics mode.
|     | Bit 1  | 4BK HGC -Select Bank 4 Mode for HGA Emulation  |     |     |
| --- | ------ | ---------------------------------------------- | --- | --- |
0 = Row scan counter bit 1 is substituted for memory address bit 14 during active
display time
1 = Memory address bit 14 appears on the memory address output bit 14 signal of
the CRT controller
The combination of this bit and bit 0 of this register allows compatibility with Hercu
les HGC graphics memory mapping.
|     | Bit 2  | VT X2 -Select Vertical Total Double Mode  |     |     |
| --- | ------ | ----------------------------------------- | --- | --- |
0 = Horizontal retrace clock selected
1 = Horizontal retrace clock divided by two selected
This bit selects horizontal retrace clock or horizontal retrace clock divided by two as
the clock that controls the vertical timing counter. If the vertical retrace counter is
clocked with the horizontal retrace clock divided by 2, then the vertical resolution is
double.
|     | Bit 3  | CNT BY2 -Select Word Mode  |     |     |
| --- | ------ | -------------------------- | --- | --- |
O =Memory address counter is clocked with the character clock input, and byte mode
addressing for the video memory is selected
1 =Memory address counter is clocked by the character clock input divided by 2, and
word mode addressing for the video memory is selected
|             | Bit 4  | Reserved = O  |          |     |
| ----------- | ------ | ------------- | -------- | --- |
| .. 9005049  |        | 0000860       | 322  ..  |     |
14-22 VGA STANDARD REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
53 Incorporated
Bit 5 ADW 16K -Address Wrap
0 =When word mode is selected by bit 6 of this register, memory address counter bit
13 appears on the memory address output bit O signal of the CRT controller and
the video memory address wraps around at 16 KBytes
1 =When word mode is selected by bit 6 of this register, memory address counter bit
15 appears on the memory address output bit O signal of the CRT controller
This bit is useful in implementing IBM CGA mode.
Bit 6 BYTE MODE -Select Byte Addressing Mode
O =Word mode shifts all memory address counter bits down one bit, and the most
significant bit of the counter appears on the least significant bit of the memory
address output
1 = Byte address mode
Bit 7 RST -Hardware Reset
O =Vertical and horizontal retrace pulses cleared (always O)
1 =Vertical and horizontal retrace pulses enabled
This bit does not reset any other registers or outputs.
Line Compare Register (LCM) (CR18l
Read/Write Address: 3?5H, Index 18H
Power-On Default: Undefined
This register is used to implement a split screen function. When the scan line counter value is equal
to the content of this register, the memory address counter is cleared to 0. The linear address counter
then sequentially addresses the display buffer starting at address 0. Each subsequent row address is
determined by the addition of the Offset (CR13) register content. Bit 8 is bit 4 of CR7. Bit 9 is bit 6 of
CR9. Bit 10 is bit 6 of CR5E.
7 6 5 4 3 2 0
LINE COMPARE POSITION
Bit 7-0 LINE COMPARE POSITION
11-bit Value= number of scan lines at which the screen is split into screen A and
screen B. This register contains the least significant 8 bits of this value .
.. 9005049 0000861 269 ..
VGA STANDARD REGISTER DESCRIPTIONS 14-23

••
r
Vision864 Graphics Accelerator
53 Incorporated
CPU Latch Data Register (GCCL) (CR22)
|     | Read Only  |     | Address: 3?5H, Index 22H  |     |
| --- | ---------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register is used to read the CPU latch in the Graphics Controller.
|     | 7  6  | 5  4  | 3  2  | 1  0  |
| --- | ----- | ----- | ----- | ----- |
GRAPHICS CONTROLLER CPU LATCH -N
|     | Bits 7-0  | GRAPHICS CONTROLLER CPU LATCH -N  |     |     |
| --- | --------- | --------------------------------- | --- | --- |
Bits 1-0 of GR4 select the latch number N (3-0) of the CPU Latch.
Attribute Index Register (ATC_F/ll (CR24l
|     | Read Only  |     | Address: 3?5H, Index 24H, 26H  |     |
| --- | ---------- | --- | ------------------------------ | --- |
Power-On Default: Undefined
This register is used to read the value of the Attribute Controller Index register and its associated
internal address flip-flop (AFF).
|     | 7  6      | 5  4                             | 3  2  | 1  0  |
| --- | --------- | -------------------------------- | ----- | ----- |
|     | AFF  = 0  | ENV  ATIRIBUTE CONTROLLER INDEX  |       |       |
|     | Bits4-o   | ATTRIBUTE CONTROLLER INDEX       |       |       |
This value is the Attribute Controller Index Data at 1/0 port 3COH.
|     | Bit 5  | ENV-Enable Video Display  |     |     |
| --- | ------ | ------------------------- | --- | --- |
This is the setting of bit 5 of 3COH, indicating video display enabled status (1 =en
abled).
|     | Bit 6  | Reserved = 0  |     |     |
| --- | ------ | ------------- | --- | --- |
|     | Bit 7  | AFF           |     |     |
Inverted Internal Address flip-flop
| .. 9005049  | 0000862  | 1T5  | ..  |     |
| ----------- | -------- | ---- | --- | --- |
14-24 VGA STANDARD REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
53 Incorporated
14.4 GRAPHICS CONTROLLER REGISTERS
The graphics controller registers are located at a two byte 1/0 address space. These registers are
accessed by first writing an index to the Graphics Address register (at 3CEH) and then accessing the
Data register (at 3CFH).
Graphics Controller Index Register (GRC_ADR)
| Read/Write  |     | Address: 3CEH  |     |     |
| ----------- | --- | -------------- | --- | --- |
Power-On Default: Undefined
This register is loaded with a binary index value that determines which graphics controller register will
be accessed. This value is referred to as the "Index Number" of the GR register (GR0-6).
|     | 6   | 3   | 2  1  | 0   |
| --- | --- | --- | ----- | --- |
7
| =0        | =0                                                   | GR CONT ADDRESS  |     |     |
| --------- | ---------------------------------------------------- | ---------------- | --- | --- |
| Bits 3-0  | GR CONT ADDRESS -Graphics Controller Register Index  |                  |     |     |
A binary value indexing the register where data is to be accessed.
| Bits 7-4  | Reserved = O  |     |     |     |
| --------- | ------------- | --- | --- | --- |
Graphics Controller Data Register (GRC_DATAI
| Read/Write  |     | Address: 3CFH  |     |     |
| ----------- | --- | -------------- | --- | --- |
Power-On Default: Undefined
This register is the data port for the graphics controller register indexed by the Graphics Controller
Index register.
|     | 6  5  | 4  3  | 2  1  | 0   |
| --- | ----- | ----- | ----- | --- |
7
GRAPHICS CONTROLLER DATA
Bit 7-0  GRAPHICS CONTROLLER DATA
Data to the Graphics Controller register indexed by the graphics controller address .
| .. 9005049  | 0000863  | 031  | ..  |     |
| ----------- | -------- | ---- | --- | --- |
VGA STANDARD REGISTER DESCRIPTIONS 14-25

Vision864 Graphics Accelerator
53 Incorporated
Set/Reset Data Register (SET/RST_DT) (GRO)
| Read/Write  |     | Address: 3CFH, Index OOH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register represents the value written to all 8 bits of the respective memory plane when the CPU
executes a memory write in write modes O and 3.
|     |     | 3  2  1  | 0   |
| --- | --- | -------- | --- |
SET/RESET DATA
Bits 3-0  SET/RESET DATA
These bits become the color value for CPU memory write operations. In write mode
0, the set/reset data can be enabled on the corresponding bit of the Enable Set/Reset
Data register. In write mode 3, there is no effect on the Enable Set/Reset Data register.
Bits 7-4  Reserved = 0
Enable Set/Reset Data Register (EN_S/R_DT) (GR1)
| Read/Write  |     | Address: 3CFH, Index 01 H  |     |
| ----------- | --- | -------------------------- | --- |
Power-On Default: Undefined
These bits enable the set/reset data, and affect write mode O.
| 7   | 6   | 3  2              | 0   |
| --- | --- | ----------------- | --- |
| =0  | =0  | ENB SET/RST DATA  |     |
Bits 3-0  ENB SET/RST DATA
When each bit is a logical 1, the respective memory plane is written with the value of
the Set/Reset Data register. A logical 0 disables the set/reset data in a plane, and that
plane is written with the value of CPU write data.
Bits 7-4  Reserved = 0
| .. 9005049  | 0000864  | T78  ..  |     |
| ----------- | -------- | -------- | --- |
14-26 VGA STANDARD REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Color Compare Register (COLOR-CMP) (GR2)
Read/Write Address: 3CFH, Index 02H
Power-On Default: Undefined
These bits represent a 4-bit color value to be compared. In read mode 1, the CPU executes a memory
read, the read data is compared with this value and returns the results. This register works in
conjunction with the Color Don't Care register.
6 5 4 3 2 1 0
=0 =0 =0 COLOR COMPARE DATA
Bits 3-0 COLOR COMPARE DATA
This value becomes the reference color used to compare each pixel. Each of the 8-bit
positions of the read data are compared across four planes and a logical 1 is returned
in each bit position for which the colors match.
Bits 7-4 Reserved = O
Raster Operation/Rotate Count Register (WT_ROP/RTC) (GR3)
Read/Write Address: 3CFH, Index 03H
Power-On Default: Undefined
This register selects a raster operation function and indicates the number of bits the CPU data will be
rotated (right) on the video memory write operation.
l l l
7 6 5 4 3 2 1 0
RST-OP
=0 =0 =0 1 0 ROTATE-COUNT
Bits 2-0 ROTATE-COUNT
These bits define a binary encoded value of the number of positions to right-rotate
data during a CPU memory write. To write non-rotated data, the CPU must preset a
count of 0 .
.. 9005049 0000865 904 .. VGA STANDARD REGISTER DESCRIPTIONS 14-27

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Bits 4-3 RST-OP -Select Raster Operation
The data written to memory can operate logically with the data already in the proces
sor latches. This function is not available in write mode 1. The logical functions are
defined as follows:
00 = No operation
01 =Logical AND with latched data
10 =Logical OR with latched data
11 = Logical XOR with latched data
The logical function specified by this register is applied to data being written to mem
ory while in modes 0, 2 and 3.
Bits 7-5 Reserved = 0
Read Plane Select Register !RD_PL_SL) (GR4)
Read/Write Address: 3CFH, Index 04H
Power-On Default: Undefined
1 0
RD-PL-SL
1 0
The contents of this register represent the memory plane from which the CPU reads data in read mode
0. This register has no effect on the color compare read mode (read mode 1) . In odd/even mode, bit O
is ignored. Four memory planes are selected as follows:
Bits 1-0 RD-PL-SL -Read Plane Select
The memory plane is selected as follows:
00 =Plane 0
01 =Plane 1
10 =Plane 2
11=Plane3
Bits 7-2 Reserved = O
.. 9005049 0000866 840 ..
14-28 VGA STANDARD REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Graphics Controller Mode Register (GRP _MODE) (GR5J
Read/Write Address: 3CFH, Index 05H
Power-On Default: Undefined
I I
7 6 5 4 3 2 1 0
SHF-MODE 0/E RD WRT-MD
=0 256 0/E MAP CMP =0 1 0
This register controls the mode of the Graphics Controller as follows:
Bit 1-0 WRT-MD -Select Write Mode
These bits select the CPU write mode into video memory. The function of each mode
is defined as follows:
00 =Write Mode 0. Each of four video memory planes is written with the CPU data
rotated by the number of counts in the rotate register. If the Set/Reset register is
enabled for any of four planes, the corresponding plane is written with the data
stored in the set/reset register. Raster operations and bit mask registers are
effective
01 =Write Mode 1. Each of four video memory planes is written with the data in the
processor latches. These latches are loaded during previous CPU read opera
tions. Raster operation, rotate count, set/reset data, enable set/reset data and bit
mask registers are not effective
10 =Write Mode 2. Memory planes 0-3 are filled with 8 bits of the value of CPU
write data bits 0-3, respectively. For example, if write data bit O is a 1, eight 1's
are written to memory plane 0. The data on the CPU data bus is treated as the
color value. The Bit Mask register is effective as the Mask register. A logical 1 in
the Bit Mask register sets the corresponding pixel in the addressed byte to the
color specified on the data bus. A logical O in the Bit Mask register sets the
corresponding pixel in the addressed byte to the corresponding pixel in the
processor latches. The Set/Reset, Enable Set/Reset and Rotate Count registers
are ignored
11 =Write Mode 3. Each of four video memory planes is written with 8 bits of the
color value contained in the set/reset register for that plane. The Enable Set/
Reset register is not effective. Rotated CPU write data is ANDed with the bit mask
register to form an 8-bit value that performs the same function as the Bit Mask
register in write modes O and 2. This write mode can be used to fill an area with
a single color and pattern
Bit 2 Reserved = 0
Bit 3 RD CMP -Enable Read Compare
O =The CPU reads data from the video memory planes. The plane is selected by the
Read Plane Select register. This is called read mode 0
1 =The CPU reads the results of the logical comparison between the data in four
video memory planes selected by the contents of the Color Don't Care register
and the contents of the Color Compare register. The result is a 1 for a match and
0 for a mismatch on each pixel. This is called read mode 1
.. 90u5049 0000867 787 ..
VGA STANDARD REGISTER DESCRIPTIONS 14-29

Vision864 Graphics Accelerator
53 Incorporated
|     |     | Bit 4  0/E MAP -Select Odd/Even Addressing  |     |     |     |
| --- | --- | ------------------------------------------- | --- | --- | --- |
0 =Standard addressing.
1 =Odd/even addressing mode selected. Even CPU addresses access plane O and 2,
while odd CPU addresses access plane 1 and 3. This option is useful for
emulating the CGA compatible mode. The value of this bit should be the inverted
value programmed in bit 2 of the Sequencer Memory Mode register (SR4). This
bit affects reading of display memory by the CPU
|     |     | Bit 5  SHF-MODE -Select Odd/Even Shift Mode  |     |     |     |
| --- | --- | -------------------------------------------- | --- | --- | --- |
0 = Normal shift mode
1 =The video shift registers in the graphics section are directed to format the serial
data stream with even-numbered bits from both planes on the even-numbered
planes and odd-numbered bits from both planes on the odd planes
|     |     | Bit 6  SHF-MODE -Select 256 Color Shift Mode  |     |     |     |
| --- | --- | --------------------------------------------- | --- | --- | --- |
O = Bit 5 in this register controls operation of the video shift registers
1 =The shift registers are loaded in a manner that supports the 256 color mode
|     |     | Bit 7  Reserved = 0  |     |     |     |
| --- | --- | -------------------- | --- | --- | --- |
Memory Map Mode Control Register (MISC_GM) (GR6)
|     | Read/Write  |     | Address: 3CFH, Index 06H  |     |     |
| --- | ----------- | --- | ------------------------- | --- | --- |
Power-On Default: Undefined
This register controls the video memory addressing.
I
|     | 7   | 6  5  | 4  3  | 2  1  | 0   |
| --- | --- | ----- | ----- | ----- | --- |
TXT
|     |     |                                          | MEM-MAP  | CHN  |      |
| --- | --- | ---------------------------------------- | -------- | ---- | ---- |
|     |     |                                          | 1        | 0/E  |      |
|     | =0  | =0  =0                                   | =0       | 0    | /GR  |
|     |     | Bit 0  TXT/GR -Select TexVGraphics Mode  |          |      |      |
0 =Text mode display addressing selected
1 =Graphics mode display addressing selected. When set to graphics mode, the
character generator address latches are disabled
|     |     | Bit 1  CHN 0/E -Chain Odd/Even Planes  |     |     |     |
| --- | --- | -------------------------------------- | --- | --- | --- |
O =AO address bit unchanged
1 =CPU address bit AO is replaced by a higher order address bit. The content of AO
determines which memory plane is to be addressed. AO  = O selects planes O
and 2, and AO  =  1 selects planes 1 and 3. This mode can be used to double the
address space into video memory
| 11  | 9005049  | 0000868  | 613  | II  |     |
| --- | -------- | -------- | ---- | --- | --- |
14-30 VGA STANDARD REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
S3 Incorporated
| Bits 3-2  | MEM-MAP -Memory Map Mode  |     |     |
| --------- | ------------------------- | --- | --- |
These bits control the address mapping of video memory into the CPU address
space. The bit functions are defined below.
00 = AOOOOH to BFFFFH (128 KBytes)
01 = AOOOOH to AFFFFH (64 KBytes)
10 = BOOOOH to B7FFFH (32 KBytes)
11 = BSOOOH to BFFFFH (32 KBytes)
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Color Don't Care Register (CMP _DNTC) (GR7)
| Read/Write  |     | Address: 3CFH, Index 07H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register is effective in read mode 1, and controls whether the corresponding bit of the Color
Compare Register is to be ignored or used for color comparison.
| 7  6  |     | 3  2  | 1  0  |
| ----- | --- | ----- | ----- |
COMPARE PLANE SEL
| =0  =0    |                                          |     |     |
| --------- | ---------------------------------------- | --- | --- |
| Bits 3-0  | COMPARE PLANE SEL -Compare Plane Select  |     |     |
O =The corresponding color plane becomes a don't care plane when the CPU read
from the video memory is performed in read mode 1
1 =The corresponding color plane is used for color comparison with the data in the
Color Compare register
| Bits 7-4  | Reserved = O  |     |     |
| --------- | ------------- | --- | --- |
Bit Mask Register (BIT_MASKI (GRBI
| Read/Write  |     | Address: 3CFH, Index OSH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
Any bit programmed to O in this register will cause the corresponding bit in each of four memory planes
to be immune to change. The data written into memory in this case is the data which was read in the
previous cycle, and was stored in the processor latches. Any bit programmed to 1 allows unimpeded
writes to the corresponding bits in the plane.
| 7   | 6  5  | 4  3  2  | 0   |
| --- | ----- | -------- | --- |
BIT MASK
| Bits 7-0  | BIT MASK  |     |     |
| --------- | --------- | --- | --- |
A logical O means the corresponding bit of each plane in memory is set to the corre
sponding bit in the processor latches. A logical 1 means the corresponding bit of
each plane in memory is set as specified by other conditions.
| .. 9005049  | 0000869  | 55T  ..  |     |
| ----------- | -------- | -------- | --- |
VGA STANDARD REGISTER DESCRIPTIONS  14-31

••
r  Vision864 Graphics Accelerator
53 Incorporated
14.5 ATTRIBUTE CONTROLLER REGISTERS
The attribute controller registers are located at the same byte 1/0 address for writing address and data.
An internal address flip-flop (AFF) controls the selection of either the attribute index or data registers.
To initialize the address flip-flop (AFF), an 1/0 read is issued at address 3BAH or 3DAH. This presets the
address flip-flop to select the index register. After the index register has been loaded by an 1/0 write
to address 3COH, AFF toggles and the next 1/0 write loads the data register. Every 1/0 write to address
3COH toggles this address flip-flop. However, it does not toggle for 1/0 reads at address 3COH or 3C1 H.
The Attribute Controller Index register is read at 3COH, and the Attribute Controller Data register is read
at address 3C1 H.
Attribute Controller Index Register (ATR_ADl
|     | Read/Write  |     | Address: 3COH  |     |
| --- | ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is loaded with a binary index value that determines which attribute controller register will
be accessed. This value is referred to as the "Index Number" of the AR register (AR0-14).
|     |     |       | I  I     | I  I  |
| --- | --- | ----- | -------- | ----- |
|     | 7   | 6  5  | 4  3  2  | 1  0  |
ENB
|     | R         | R  PLT             | ATIRIBUTE ADDRESS  |     |
| --- | --------- | ------------------ | ------------------ | --- |
|     | Bits 4-0  | ATTRIBUTE ADDRESS  |                    |     |
A binary value that points to the attribute controller register where data is to be
written.
|     | Bit 5  | ENB PLT-Enable Video Display  |     |     |
| --- | ------ | ----------------------------- | --- | --- |
O =Video display access to the palette registers disabled. The Attribute Controller
register can be accessed by the CPU
1 =Display video using the palette registers enabled (normal display operation). The
palette registers (ARO-ARF) cannot be accessed by the CPU
|             | Bits 7-6  | Reserved  |          |     |
| ----------- | --------- | --------- | -------- | --- |
| .. 9005049  |           | 0000870   | 271  ..  |     |
14-32 VGA STANDARD REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Attribute Controller Data Register IATR_DATA)
| Read;Write  |     | Address: R: 3C1H;W: 3COH  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: Undefined
This register is the data port for the attribute controller register indexed by the Attribute Controller
Index register.
| 7  6  | 5  4  | 3   | 2   | 0   |
| ----- | ----- | --- | --- | --- |
ATIRIBUTE DATA
| Bits 7-0  | ATTRIBUTE DATA   |     |     |     |
| --------- | ---------------- | --- | --- | --- |
Data to the attribute controller register indexed by the attribute controller address.
Palette Registers IPLT_REGI IAROO-OFI
| Read;Write  |     | Address: 3C1 H/3COH, Index OOH-OFH  |     |     |
| ----------- | --- | ----------------------------------- | --- | --- |
Power-On Default: Undefined
These are 16, 6-bit registers pointed to by the index and color code. They allow a dynamic mapping
between the text attribute or graphics color input and the display color on the CRT screen.
|           | l              | l   | I        | I   |
| --------- | -------------- | --- | -------- | --- |
| 7  6      | 5  4           | 3   | 2  1     | 0   |
|           | SECONDARY      |     | PRIMARY  |     |
| =0  =0    | SR  SG         | SB  | R  G     | B   |
| Bits 5-0  | PALETTE COLOR  |     |          |     |
The six bit display color, bits 5-0 are output as SR, SG/I, SBN, R, G and B,
respectively.
| Bits 7-6    | Reserved = 0  |      |     |     |
| ----------- | ------------- | ---- | --- | --- |
| .. 9005049  | 0000871       | 108  | ..  |     |
VGA STANDARD REGISTER DESCRIPTIONS 14-33

Vision864 Graphics Accelerator
53 Incorporated
Attribute Mode Control Register (ATR_MODE) IAR10)
|     | Read/Write  |     | Address: 3C1H/3COH, Index 10H  |     |
| --- | ----------- | --- | ------------------------------ | --- |
Power-On Default: OOH
The contents of this register controls the attribute mode of the display function.
|     | 7      | 6  5                         | 4  3           | 2  1  0     |
| --- | ------ | ---------------------------- | -------------- | ----------- |
|     | SEL    | 256  TOP                     | ENB  ENB       | MONO TX/GR  |
|     | V54    | CLR  PAN                     | =0  BLNK  LGC  | ATRB        |
|     | Bit 0  | TX/GR -Select Graphics Mode  |                |             |
0 = Selects text attribute control mode
1 = Selects graphics control mode
|     | Bit 1  | MONO ATRB -Select Monochrome Attributes  |     |     |
| --- | ------ | ---------------------------------------- | --- | --- |
O =Selects color display text attributes
1 = Selects monochrome display text attributes
|     | Bit 2  | ENB LGC -Enable Line Graphics  |     |     |
| --- | ------ | ------------------------------ | --- | --- |
0 =The ninth dot of a text character (bit O of SR1 = 0) is the same as the background
1 =Special line graphics character codes enabled
When this bit is set to 1, it forces the ninth dot of a line graphics character to be identi
cal to the eighth dot of the character. The line graphics character codes are COH
through DFH. For other characters, the ninth dot is the same as the background.
|     | Bit 3  | ENB BLNK -Enable Blinking  |     |     |
| --- | ------ | -------------------------- | --- | --- |
0 =Selects the background intensity for the text attribute input
1 =Selects blink attribute in text modes
This bit must also be set to 1 for blinking graphics modes. The blinking counter is op
erated by the vertical retrace counter {VRTC) input. It divides the VRTC input by 32.
The blinking rates are ON for 16 VRTC clocks and OFF for 16 VRTC clocks. In the
graphics mode, when blink is activated, the most significant color bit (bit 3) for each
dot is inverted alternately, thus allowing two different colors to be displayed for 16
VRTC clocks each.
When the cursor is displayed in the text mode, it is blinked at a rate of ON for 8 VRTC
clocks and OFF for 8 VRTC clocks (period by 16 frames). The displayed characters are
independently blinked at the rate of 32 frames as above.
|     | Bit 4  | Reserved = 0                 |     |     |
| --- | ------ | ---------------------------- | --- | --- |
|     | Bit 5  | TOP PAN -Top Panning Enable  |     |     |
O =Line compare has no effect on the output of the pixel panning register
1 =Forces the output of the pixel panning register to O after matching line compare
until VSYNC occurs in the CRT controller. At the top of screen the output of the
Pixel Panning register returns to its programmed value. This bit allows a top
portion of a split screen to be panned .
| .. 9005049  |     | 0000872  | 044  ..  |     |
| ----------- | --- | -------- | -------- | --- |
14-34 VGA STANDARD REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
|     | Bit 6  | 256 CLR -Select 256 Color Mode  |     |     |
| --- | ------ | ------------------------------- | --- | --- |
0 = 4 bits of video (translated to 6 bits by the palette) are output every internal
dot-clock cycle
1 =Two 4-bit sets of video data are assembled to generate 8-bit video data at half the
frequency of the internal dot-clock
|     | Bit 7  | SEL V54 -Select V[5:4]  |     |     |
| --- | ------ | ----------------------- | --- | --- |
0 = In VGA, mode, bits 5-4 of video output are generated by the attribute palette
registers. Bits 7-6 of video output are always generated by bits 3-2 of AR14
1 =Bits 5-4 of video output are generated by bits 1-0 of AR14
Border Color Register (BDR_CLR) (AR11)
| Read;Write  |     |     | Address: 3C1 H/3COH, Index 11 H  |     |
| ----------- | --- | --- | -------------------------------- | --- |
Power-On Default: OOH
|     | 6   | 5  4  | 3  2  | 0   |
| --- | --- | ----- | ----- | --- |
7
BORDER COLOR
Bits 7-0  Border Color. This 8-bit register determines the border color displayed on the CRT
screen. The border is an area around the screen display area.
Color Plane Enable Register (DISP_ PLN) (AR121
| Read;Write  |     |     | Address: 3C1H/3COH, Index 12H  |     |
| ----------- | --- | --- | ------------------------------ | --- |
Power-On Default: OOH
This register enables the respective video memory color plane 3-0 and selects video color outputs to
be read back in the display status.
|     |     | I     | I     | I  I  |
| --- | --- | ----- | ----- | ----- |
| 7   | 6   | 5  4  | 3  2  | 1  0  |
VDT-SEL
| =0        | =0  | 1  0                | DISPLAY PLANE ENBL  |     |
| --------- | --- | ------------------- | ------------------- | --- |
| Bits 3-0  |     | DISPLAY PLANE ENBL  |                     |     |
A 0 in any of these bits forces the corresponding color plane bit to 0 before accessing
the internal palette. A 1 in any of these bits enables the data on the corresponding
color plane .
.. 9005049  0000873  T80  ..  VGA STANDARD REGISTER DESCRIPTIONS  14-35

Vision864 Graphics Accelerator
53 Incorporated
| Bits 5-4  | VDT-SEL -Video Test Select  |     |     |     |     |
| --------- | --------------------------- | --- | --- | --- | --- |
These bits select two of the eight bit color outputs to be available in the Input Status
1 register. The output color combinations available on the status bits are as follows:
|           | DSTSMUX       |       |             | STS 1       |     |
| --------- | ------------- | ----- | ----------- | ----------- | --- |
|           | Bit5          | Bit4  |             | Bit5  Bit4  |     |
|           | 0             | 0     | Video 2     | Video 0     |     |
|           | 0             |       | 1  Video 5  | Video 4     |     |
|           | 1             | 0     | Video 3     | Video 1     |     |
|           | 1             |       | 1  Video 7  | Video 6     |     |
| Bits 7-6  | Reserved = O  |       |             |             |     |
Horizontal Pixel Panning Register (H_PX_PAN) (AR13)
| Read/Write  |     | Address: 3C1 H/3COH, Index 13H  |     |     |     |
| ----------- | --- | ------------------------------- | --- | --- | --- |
Power-On Default: OOH
This register specifies the number of pixels to shift the display data horizontally to the left. Pixel panning
is available in both text and graphics modes.
|     |     |     | 3  2  | 1  0  |     |
| --- | --- | --- | ----- | ----- | --- |
NUMBER OF PAN SHIFT
| Bits 3--0  | NUMBER OF PAN SHIFT  |     |     |     |     |
| ---------- | -------------------- | --- | --- | --- | --- |
This register selects the number of pixels to shift the display data horizontally to the
left. In the 9 pixels/character text mode, the output can be shifted a maximum shift of
8 pixels. In the 8 pixels/character text mode and all graphics modes, except 256 color
mode, a maximum shift of 7 pixels is possible. In the 256 color mode, bit O of this reg
ister must be O resulting in only 4 panning positions per display byte. The panning is
controlled as follows:
Number of pixels shifted in
|           | Bits 3--0     | 9 pixel/char.  |     | 8 pixel/char.  | 256 color mode  |
| --------- | ------------- | -------------- | --- | -------------- | --------------- |
|           | 0000          |                | 1   | 0              | 0               |
|           | 0001          |                | 2   | 1              | -               |
|           | 0010          |                | 3   | 2              | 1               |
|           | 0011          |                | 4   | 3              | -               |
|           | 0100          |                | 5   | 4              | 2               |
|           | 0101          |                | 6   | 5              | -               |
|           | 0110          |                | 7   | 6              | 3               |
|           | 0111          |                | 8   | 7              | -               |
|           | 1000          |                | 0   | -              | -               |
| Bits 7-4  | Reserved = O  |                |     |                |                 |
| 9005049   | 0000874       | 917            |     |                |                 |
| ~         |               |                | ~   |                |                 |
14-36 VGA STANDARD REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
SJ Incorporated
Pixel Padding Register (PX_PADD) (AR14)
| Read/Write  |     | Address: 3C1 H/3COH, Index 14H  |     |
| ----------- | --- | ------------------------------- | --- |
Power-On Default: OOH
This register specifies the high-order bits of video output when pixel padding is enabled and disabled
in the 256 color mode.
|       |       | l     | l  l  |
| ----- | ----- | ----- | ----- |
| 7  6  | 5  4  | 3  2  | 1  0  |
PIXEL PADDING
| =0  =0    | =0  =0                | V7  V6  | V5  V4  |
| --------- | --------------------- | ------- | ------- |
| Bits 1-0  | PIXEL PADDING V5, V4  |         |         |
These bits are enabled with a logical 1 of bit 7 of AR10, and can be used in place of
the V5 and V4 bits from the Palette registers to form the 8-bit digital color value out
put.
| Bits 3-2  | PIXEL PADDING V7, V6  |     |     |
| --------- | --------------------- | --- | --- |
In all modes except 256 color mode, these bits are the two high-order bits of the 8-bit
digital color value output.
| Bits 7-4  | Reserved = O  |     |     |
| --------- | ------------- | --- | --- |
.. 9005049  0000875  853  ..  VGA STANDARD REGISTER DESCRIPTIONS 14-37

Vision864 Graphics Accelerator
53 Incorporated
14.6 SETUP REGISTERS
This section describes the Video Subsystem Setup registers on the system board.
The 1/0 functions of the system board use POS information during the setup procedure. The 1/0
controllers on the system board are treated as a single device. Although the VGA is a part of the system
board, POS treats it as a separate device. The Setup Enable register is used to place the system board
or the Video Subsystem into setup. The Setup Enable register is read/write at 1/0 address 46E8H. The
bit definitions are provided below.
Setup Option Select Register (SETUP_ MDI
Read/Write Address: 102H
Power-On Default: OOH
Bit 0 SLP MODE-Disable Sleep Mode
When in setup mode {1/0 address 46E8H, bit 4 =1, the Vision864 responds to a single
option select byte at 1/0 address 102H and treats this bit as the Video Subsystem
sleep bit.
0 = Vision864 does not respond to commands, addresses, or data on the data bus. If
the Vision864 was set up and is generating video output when this bit is cleared
to 0, the output is still generated
1 = Vision864 responds to commands, addresses, or data on the data bus
The Vision864 responds only to address 102H when in the setup mode. No other ad
dresses are valid at that time. The Vision864 ignores address 102H when in the en
abled mode 11/0 address 46E8H, bit 4 = 0, and decodes normal 1/0 and memory
addresses.
If bit 2 of CR65 is set to 1, 3C3H is the address used for setup instead of 46E8H.
Bit 7-1 Reserved
.. 9005049 0000876 79T ..
14-38 VGA STANDARD REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Video Subsystem Enable Register (SETUP_ MDI
| Write Only  |     | Address: 46E8H  |     |     |
| ----------- | --- | --------------- | --- | --- |
Power-On Default: OOH
|          | s~P         | ~~c     |       |       |
| -------- | ----------- | ------- | ----- | ----- |
| I  :  I  | :  I  :  I  | I  I :  | I  I  | :  I  |
R
| Bits 2-0  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
Bit 3  AD DEC -Vision864 Address Decoding
0 =Video 1/0 and memory address decoding are disabled
1 =Video 1/0 and memory address decoders are enabled
Bit 4  EN SUP -Enable Vision864 Setup
O =The Vision864 is in operational mode
1 =The Vision864 is placed in setup mode
If bit 2 of CR65 is set to 1, 3C3H is the address used for setup instead of 46E8H.
| Bits 7-5    | Reserved  |          |     |     |
| ----------- | --------- | -------- | --- | --- |
| .. 9005049  | 0000877   | 626  ..  |     |     |
VGA STANDARD REGISTER DESCRIPTIONS  14-39

=·
r
Vision864 Graphics Accelerator
S3 Incorporated
14.7 RAMDAC REGISTERS
Of all the RAMDAC registers described in this section, only the DAC Status Register (3C7H, Read Only}
is physically located inside the Vision864. The others are located in the RAMDAC. The Vision864
decodes these addresses for RAMDAC data byte steering.
DAC Mask Register (DAC_AD_MKI
Read/Write Address: 3C6H
Power-On Default: Undefined
This register is the pixel read mask register to select pixel video output. The CPU can access this register
at any time. An access to this register causes 10b to be driven to the RS[1:0J outputs to the RAMDAC.
7 6 5 4 3 2 0
DAC ADDRESS MASK
Bits 7-0 DAC ADDRESS MASK
The contents of this register are bit-wise logically ANDed with the pixel select video
output (PA[7:0)). This register is initialized to FFH by the BIOS during a video mode
set.
DAC Read Index Register (DAC_RD_ADI
Write Only Address: 3C7H
Power-On Default: Undefined
This register contains the pointer to one of 256 palette data registers and is used when reading the
color palette. A write to this register causes 11 b to be driven to the RS[ 1: OJ outputs to the RAMDAC.
7 6 5 4 3 2 0
DAC READ ADDRESS
Bits 7-0 DAC READ ADDRESS
Each time the color code is written to this register, it identifies that a read sequence
will occur. A read sequence consists of three successive byte reads from the RAM
DAC data register at 1/0 address 3C9H. The order is red byte first, then green, and fi
nally blue. The sequence of events for a read cycle is:
1. Write the color code to this register (RAMDAC Read Index) at address 3C7H.
2. The contents of the location in the color look-up table pointed to by the color code
are transferred to the RAMDAC data register at address 3C9H.
3. Three bytes are read back from the RAMDAC data register.
4. The contents of this register auto-increment by one.
5. Go to step 2 .
• 9005049 0000878 562 • ---------------
14-40 VGA STANDARD REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
53 Incorporated
The effects of writing to the RAMDAC data register during a three-byte read cycle or
reading from the RAMDAC data register during a 3-byte write cycle {i.e., interrupting
the sequence} are undefined and may change the look-up table contents.
DAC Status Register !DAC_STS)
| Read Only  |     | Address: 3C7H  |     |
| ---------- | --- | -------------- | --- |
Power-On Default: Undefined
A read of this register causes 11 b to be driven to the RS[1 :OJ outputs to the RAMDAC.
| 7         |                               |     | 0        |
| --------- | ----------------------------- | --- | -------- |
| =0        |                               |     | DAC-STS  |
| Bits 1-0  | DAC-STS -RAMDAC Cycle Status  |     |          |
The last executing cycle was:
00 =Write Palette cycle
11 =Read Palette cycle
Reads from the RAMDAC Write Index at address 3C8H or the DAC status register at
address 3C7H do not interfere with read or write cycles and may take place at any
time.
| Bits 7-2  | Reserved = O  |     |     |
| --------- | ------------- | --- | --- |
DAC Write Index Register (DAC_WR_ADI
| Read/Write  |     | Address: 3C8H  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
An access to this register causes OOb to be driven to the RS[ 1: OJ outputs to the RAMDAC.
| 7  6  | 5  4  | 3  2  | 1  0  |
| ----- | ----- | ----- | ----- |
DAC WRITE ADDRESS/GIP READ DATA
| Bits 7-0  | DAC WRITE ADDRESS/GIP READ DATA  |     |     |
| --------- | -------------------------------- | --- | --- |
This register contains the pointer to one of 256 palette data registers and is used dur
ing a palette load. Each time the color code is written to this register, it identifies that
a write sequence will occur. A write sequence consists of three successive byte writes
to the DAC data register at 1/0 address 3C9H. For 18-bit DACs, the least significant 6
bits of each byte are concatenated to form the value placed in the 18-bit data register.
The order is red byte first, then green, and finally blue. Once the third byte has been
written, the value in the data register is written to the location pointed to by the color
code. The sequence of events for a write cycle is:
| Ill  9005049  | 0000879  | 4T9  Ill  |     |
| ------------- | -------- | --------- | --- |
VGA STANDARD REGISTER DESCRIPTIONS  14-41

Vision864 Graphics Accelerator
S3 Incorporated
1. Write the color code to this register (DAC Write Index) at address 3C8H.
2. Three bytes are written to the DAC Data register at address 3C9H.
3. The contents of the DAC data register are transferred to the location in the color
look-up table pointed to by the color code.
4. The DAC Write Index register auto-increments by 1.
5. Go to step 2.
If bit 2 of the Extended RAMDAC Control register (CR55) is set to 1 to
enable the General 1/0 Port read function, a read of 3C8H retrieves data from an exter
nal input buffer.
RAMDAC Data Register (DAC_DATAI
Read/Write Address: 3C9H
Power-On Default: Undefined
This register is a data port to read or write the contents of the location in the color look-up table pointed
to by the DAC Read Index or the DAC Write Index registers. An access to this register causes 01 b to be
driven to the RS[1:0) outputs to the RAMDAC.
7 6 5 4 3 2 0
DAC READ/WRITE DATA
Bits 7-0 DAC READ/WRITE DATA
To prevent "snow flicker" on the screen, an application reading data from or writing
data to the DAC Data register should ensure that the BLANK input to the RAMDAC is
asserted. This can be accomplished either by restricting data transfers to retrace inter
vals, checking the Input Status 1 register to determine when retrace is occurring, or
by using the screen-off bit in the Clocking Mode register of the sequencer.
• 9005049 0000880 110 • --------------
14-42 VGA STANDARD REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Section 15: S3 VGA Register Descriptions
The Vision864 has additional registers to extend the functions of basic VGA. These registers are located
in CRT Controller address space at locations not used by IBM. All of these registers are read/write
protected at power-up by hardware reset. In order to read/write these registers, the Register Lock 1
register {CR38} must be loaded with a changed key pattern {see the register description). The registers
will remain unlocked until the key pattern is reset by altering a significant bit.
In the following register descriptions, 'R' stands for reserved (write =0, read= undefined). See Appendix
A for a table listing each register in this section and its page number.
Chip ID/REV Register (CHIP-ID/REV) (CR30}
| Read Only  |     |     | Address: 3?5H, Index 30H  |     |     |     |
| ---------- | --- | --- | ------------------------- | --- | --- | --- |
Power-On Default: CxH (x will change with the stepping)
| 7   | 6         | 5  4                         | 3   | 2                |     | 0   |
| --- | --------- | ---------------------------- | --- | ---------------- | --- | --- |
|     | CHIP ID   |                              |     | REVISION STATUS  |     |     |
|     | Bits 7-0  | CHIP ID AND REVISION STATUS  |     |                  |     |     |
Memory Configuration Register (MEM_CNFG) (CR31)
| Read/Write  |     |     | Address: 3?5H, Index 31H  |     |     |     |
| ----------- | --- | --- | ------------------------- | --- | --- | --- |
Power-On Default: OOH
l
| 7   | 6      | 5  4                                   | 3    | 2    | 1     | 0     |
| --- | ------ | -------------------------------------- | ---- | ---- | ----- | ----- |
|     | HST    | OLD-DSAD                               | ENH  | VGA  | SCRN  | CPUA  |
| R   | DFF    | 17  16                                 | MAP  | 16B  | 2.PG  | BASE  |
|     | Bit 0  | CPUA BASE -Enable Base Address Offset  |      |      |       |       |
O =Address offset bits 3-0 of CR35 and bits 3-2 of CR51 or the new address offset bits
{5-0 of CR6A) are disabled
1 =Address offset bits 3-0 CR35 and bits 3-2 of CR51 or the new address offset bits (5-
0 of CR6A) are enabled for specifying the 64K page of display memory. This
allows access to up to 4 MBytes of display memory through a 64K window .
| .. 9005049  |     | 0000881  |     | 057  ..  |     |     |
| ----------- | --- | -------- | --- | -------- | --- | --- |
S3 VGA REGISTER DESCRIPTIONS  15-1

Vision864 Graphics Accelerator
53 Incorporated
Bit 1 SCRN 2.PG -Enable Two-Page Screen Image
0 = Normal Mode
1 =Enable 2K x 1K x 4 map image screen for 1024 x 768 or 800 x 600 screen
resolution, or 2K x 512 x 8 map image screen for 640 x 480 screen resolution
Bit 2 VGA 16B -Enable VGA 16-bit Memory Bus Width
O = 8-bit memory bus operation
1 =Enable 16-bit bus VGA memory read/writes
Bit 3 ENH MAP -Use Enhanced Mode Memory Mapping
O =Force IBM VGA mapping for memory accesses
1 =Force Enhanced Mode mappings
Setting this bit to 1 overrides the settings of bit 6 of CR14 and bit 3 of CR17 and
causes the use of doubleword memory addressing mode.
Bits 5-4 OLD-DSAD 17, 16 -Old Display Start Address Bits 17-16
Bits 17-16 of start address (CRC, CRD} and cursor location (CRE, CRF)
Bits 1-0 of the Extended System Control 2 register (CR51} are bits 19-18 of the ad
dress and enable access to up to 4 MBytes of display memory. If a value is pro
grammed into bits 3-0 of the Extended System Control 3 register {CR69}, this value
becomes the upper 4 bits of the display start base address and bits 5-4 of CR31 and
bits 1-0 of CR51 are ignored.
Bit 6 HST OFF -Enable High Speed Text Display Font Fetch Mode
0 = Normal font access mode
1 =Enable high speed text display
Setting this bit to 1 is only required for DCLK rates greater than 40 MHz.
Bit 7 Reserved
Backward Compatibility 1 Register (BKWD_1} (CR32)
Read/Write Address: 3?5H, Index 32H
Power-On Default: OOH
l
7 6 5 4 3 2 1 0
VGA ENB BKWD FCHI CH-CLK
R FXPG (R) VIRO MODE CHCK 1 0
Bits 1-0 CH-CLK -Set Character Clock Period
00 =Same as IBM VGA (8 or 9 dot clocks, as set via bit O of SR1)
01 = 7 dots (overrides setting of 00)
10 = 9 dots (overrides setting of 00)
11 = Reserved
This is used only for non-standard modes (not VGA or backwards compatible).
• 9005049 0000882 T93 • ______________
15-2 S3 VGA REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
| Bit 2  | FCHI CHCK -Force Character Clock High  |     |     |
| ------ | -------------------------------------- | --- | --- |
O =Normal character clock
1 =Force character clock of horizontal timing to high rate (not 1/2 dot clock rate) for
CGA and HGC emulations
| Bit 3  | BKWD MODE -Enable Backward Compatibility Modes  |     |     |
| ------ | ----------------------------------------------- | --- | --- |
O=VGA
1 =All other backward compatibility modes
| Bits 5-4  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Bit 6
VGA FXPG -Use Standard VGA Memory Wrapping
0 = Memory accesses extending past a 256K boundary do not wrap
1 = Memory accesses extending past a 256K boundary wrap at the boundary
The standard 256K VGA memory page always ends on a natural 256K boundary and
accesses beyond this boundary will wrap. If the starting address is moved via bits 4-0
of CR69 (or bits 5-4 of CR31 and bits 1-0 of CR51), the 256K page may not end on a
256K boundary and accesses past the boundary will not wrap. This is the case when
this bit is cleared to 0. For standard VGA compatibility when the page base address is
moved, this bit is set to 1 to cause wrapping at a 256K boundary.
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
Backward Compatibility 2 Register {BKWD_2) (CR33)
| Read/Write  |     | Address: 3?5H, Index 33H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6        | 5          | 4  3  2  | 1  0    |
| ----------- | ---------- | -------- | ------- |
| DISA  LOCK  | BDR  LOCK  | VCLK=    | DIS     |
| FLKR  PLTW  | SEL  DACW  | -DCK  R  | VDE  R  |
| Bit 0       | Reserved   |          |         |
Bit 1  DIS VOE -Disable Vertical Display End Extension Bits Write Protection
O =VOE protection enabled
1 =Disables the write protect setting of the bit 7 of CR11 on bits 1 and 6 of CR7
| Bit 2  | Reserved                            |     |     |
| ------ | ----------------------------------- | --- | --- |
| Bit 3  | VCLK = -DCK -VCLK is Inverted DCLK  |     |     |
O = VCLK is the inverted internal dot clock (see bit 3 of SR1)
1 = VCLK is the inverted DCLK
| Bit 4  | LOCK DACW -Lock RAMDAC Writes  |     |     |
| ------ | ------------------------------ | --- | --- |
O =Enable writes to RAMDAC registers
1 =Disable writes to RAMDAC registers
| .. 9005049  | 0000883  | 92T  | ..  |
| ----------- | -------- | ---- | --- |
S3 VGA REGISTER DESCRIPTIONS  15-3

Vision864 Graphics Accelerator
S3 Incorporated
| Bit 5  | BDR SEL -Blank/Border Select  |     |     |
| ------ | ----------------------------- | --- | --- |
O = BLANK active time is defined by CR2 and CR3
1 =BLANK is active during entire display inactive period {no border)
LOCK PL TW -Lock Palette/Border Color Registers
Bit 6
0 = Unlock Palette/Border Color registers
1 = Lock Palette/Border Color registers
| Bit 7  | DISA FLKR -Remove Flicker  |     |     |
| ------ | -------------------------- | --- | --- |
0 =No effect
1 =Overrides the 3D8H video enable {bit 3). This eliminates flicker {CGA snow)
Backward Compatibility 3 Register {BKWD_3) {CR34)
| Read/Write  |     | Address: 3?5H, Index 34H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6      | 5  4                                               | 3  2  | 1  0  |
| --------- | -------------------------------------------------- | ----- | ----- |
| LOCK      | LOCK  ENB                                          |       |       |
| CKSL  R   | 8/90  SFF                                          | R  R  | R  R  |
| Bits 3-0  | Reserved                                           |       |       |
| Bit 4     | ENB SFF -Enable Start Display FIFO Fetch Register  |       |       |
0 =Start Display FIFO Fetch register {CR3B) disabled
1 =Start Display FIFO Fetch register (CR3B) enabled
| Bit 5  | LOCK 8/90 -Lock 8/9 Dots  |     |     |
| ------ | ------------------------- | --- | --- |
0 =Bit O of the Clocking Mode register (SR1) is unlocked
1 =Bit 0 of the Clocking Mode register {SR1) is locked
When emulating EGA hardware, horizontal timing registers are programmed for an 8
dot character clock period (via bit O of SR1) and these registers are locked. This pre
vents EGA software from modifying this bit. Writes to bits 1-0 of CR32 override this
register setting.
| Bit 6  | Reserved                      |     |     |
| ------ | ----------------------------- | --- | --- |
| Bit 7  | LOCK CKSL -Lock Clock Select  |     |     |
O = Bits 3-2 of the Miscellaneous Output register {3C2H) are unlocked
1 = Bits 3-2 of the Miscellaneous Output register (3C2H) are locked. This locks the
DCLK frequency to a fixed value in VGA and backwards compatibility modes. If
11 bis programmed in bits 3-2 of 3C2H, the DCLK frequency can still be changed
via bits 3-0 of CR42.
15-4 S3 VGA REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
SJ Incorporated
CRT Register Lock Register (CRTR_LOCK) (CR35)
| Read;Write  |     | Address: 3?5H, Index 35H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
|           |                       | l                     | l  l    |
| --------- | --------------------- | --------------------- | ------- |
| 7  6      | 5  4                  | 3  2                  | 1  0    |
|           | LOCK  LOCK            | OLD-CPU-BASE-ADDRESS  |         |
| R  R      | HTMG  VTMG            | 17  16                | 15  14  |
| Bits 3-0  | OLD-CPU-BASE-ADDRESS  |                       |         |
CPU Base Address bits 17-14. These four bits define the CPU address base in 64
KByte units of display memory. These bits are added with CPU address bit 17 {MSB
of video memory addressing) to bit 14 for display buffer accesses.
Bits 3-2 of the Extended System Control 2 register {CR51) are bits 19-18 of the ad
dress and enable access to up to 4 MBytes of display memory. If a value is pro
grammed into bits 5-0 of the Extended System Control 4 register {CR6A), this value
becomes the upper 6 bits of the CPU base address and bits 3-0 of CR35 and bits 3-2 of
CR51 are ignored.
| Bit 4  | LOCK VTMG -Lock Vertical Timing Registers  |     |     |
| ------ | ------------------------------------------ | --- | --- |
0 =Vertical timing registers are unlocked
1 =The following vertical timing registers are locked:
CR6
CR7 {bits 7,5,3,2,0)
CR9 {bit 5)
CR10
CR11 {bits 3-0)
CR15
CR16
CR6, CR7 registers are also locked by bit7 of the Vertical Retrace End register (CR11) .
| .. 9005049  | 0000885  | 7T2  ..  |     |
| ----------- | -------- | -------- | --- |
S3 VGA REGISTER DESCRIPTIONS  15-5

••
r Vision864 Graphics Accelerator
53 Incorporated
Bit 5 LOCK HTMG -Lock Horizontal Timing Registers
O =Horizontal timing registers are unlocked
1 =The following horizontal timing registers are locked:
CROO
CR1
CR2
CR3
CR4
CR5
CR17 (bit 2)
All these registers (except bit 2 of CR17) are also locked by bit 7 of the Vertical Re
trace End register (CR11 ).
Bit 7-6 Reserved
15-6 S3 VGA REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Configuration 1 Register (CONFG_REG1) (CR36)
| Read/Write*  | Address: 3?5H, Indices 36H  |     |     |
| ------------ | --------------------------- | --- | --- |
Power-On Default: Depends on Strapping
*Bits 1-0 are read only. The other bits can be written only after OA5H is written to CR39.
This register samples the reset state from PD bus pins [7:0]. Other configuration strapping bits are
found in CR37 and CR68.
| PD Bits  | CR 36 Bits  | Value  | Function  |
| -------- | ----------- | ------ | --------- |
~tern Bus Select
| 1-0  | 1-0  |     |                 |
| ---- | ---- | --- | --------------- |
|      |      | 00  | Reserved        |
|      |      | 01  | VESA local bus  |
|      |      | 10  | PCI local bus   |
|      |      | 11  | Reserved        |
Memory P'!.9_e Mode Select
| 3-2  | 3-2  | 00  | Reserved                      |
| ---- | ---- | --- | ----------------------------- |
|      |      | 01  | Reserved                      |
|      |      | 10  | Extended Data Out (EDO) Mode  |
|      |      | 11  | Fast P~e Mode                 |
Enable Video BIOS Accesses (VL-Bus)
| 4   | 4   | 0   | Disable video BIOS accesses  |
| --- | --- | --- | ---------------------------- |
|     |     | 1   | Enable video BIOS accesses   |
Di~ay Mem<!!'l. Size
| 7-5         | 7-5      | 000      | 4 M~tes   |
| ----------- | -------- | -------- | --------- |
|             |          | 001      | Reserved  |
|             |          | 010      | 3 M~tes   |
|             |          | 011      | Reserved  |
|             |          | 100      | 2 M~tes   |
|             |          | 101      | Reserved  |
|             |          | 110      | 1 MEM_e   |
|             |          | 111      | Reserved  |
| .. 9005049  | 0000887  | 575  ..  |           |
S3 VGA REGISTER DESCRIPTIONS 15-7

Vision864 Graphics Accelerator
53 Incorporated
|     | Configuration 2 Register (CONFG_REG2)  |     |                             | (CR37)  |     |
| --- | -------------------------------------- | --- | --------------------------- | ------- | --- |
|     | Read/Write*                            |     | Address: 3?5H, Indices 37H  |         |     |
Power-On Default: Depends on Strapping
* These bits can be written only after OA5H is written to CR39.
This register samples the reset state from PD bus pins (15:7). Other configuration strapping bits are
found in CR36 and CR68.
|     |          |            | I   |        | I         |
| --- | -------- | ---------- | --- | ------ | --------- |
|     | PD Bits  | CR37 Bits  |     | Value  | Function  |
Setl!E_ Select (VL-Bus)
I
8  a  a  I  Disable V1s1on864 exce_fl_t for video BIOS accesses
|     |     |     | l   |     | l                 |
| --- | --- | --- | --- | --- | ----------------- |
|     |     |     |     | 1   | Enable V1s1on864  |
Test Mode
|     | 9   |     | 1 0  |     | f Test mode enabled (most ou!Q_uts tri-stated)  |
| --- | --- | --- | ---- | --- | ----------------------------------------------- |
1
|     |     |     |     | 1   | Test mode disabled (normal C'.Q_erat1on)  |
| --- | --- | --- | --- | --- | ----------------------------------------- |
Video BIOS ROM Size (VL-Bus)
|     |     |     | l   |     | f                      |
| --- | --- | --- | --- | --- | ---------------------- |
|     | 10  | 2   |     | 0   | 64-K~e video BIOS ROM  |
l
|     |     |     |     | 1   | 32-KEMe video BIOS ROM  |
| --- | --- | --- | --- | --- | ----------------------- |
Dual CAS Select
|     |     |     | I   |     | 1   |
| --- | --- | --- | --- | --- | --- |
o
|     | 11  | 3   |     |     | Dual WE ~e select      |
| --- | --- | --- | --- | --- | ---------------------- |
|     |     |     | ]   | 1   | Dual CAS byt_e select  |
RAMDAC Write Sno~'!.9. (VL-Bus)
|     |     |     | j   |     | j                                    |
| --- | --- | --- | --- | --- | ------------------------------------ |
|     | 12  | 4   |     | 0   | Disable LOCA/SRDY for RAMDAC writes  |
|     |     |     | J   |     | J                                    |
|     |     |     |     | 1   | Enable LOCA/SRDY for RAMDAC writes   |
Monitor ~e Identification
|             |        |          | l    |                   | l                             |
| ----------- | ------ | -------- | ---- | ----------------- | ----------------------------- |
|             | 15-13  | 7-5      |      |                   | Optional monitor information  |
| •  9005049  |        | 0000888  | 401  | •  -------------- |                               |
15-8 S3 VGA REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Register Lock 1 Register !REG_LOCK1 I {CR38)
| Read/Write  | Address: 3?5H, Index 38  |     |     |
| ----------- | ------------------------ | --- | --- |
Power-On Default: OOH
Loading 01xx10xx (e.g., 48Hl into this register unlocks the S3 VGA register set for read/writes. (x =
don't care)
| 7  6  | 5  4  |     | 0   |
| ----- | ----- | --- | --- |
=0  = 1
Register Lock 2 Register !REG_LOCK21 !CR391
| Read/Write  | Address: 3?5H, Index 39  |     |     |
| ----------- | ------------------------ | --- | --- |
Power-On Default: OOH
Loading 101xxxxx {e.g., AOH) unlocks the system control and system extension registers for
reading/writing (x = don't care). Loading A5H allows bits 7-2 of CR36, bits 7-0 of CR37 and bits 7-0 of
CR68 to be written.
|             | 4        | 3  2     | 0   |
| ----------- | -------- | -------- | --- |
| .. 9005049  | 0000889  | 348  ..  |     |
S3 VGA REGISTER DESCRIPTIONS  15-9

Vision864 Graphics Accelerator
53 Incorporated
Miscellaneous 1 Register (MISC_1) !CR3A)
| Read/Write  |     | Address: 3?5H, Index 3AH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
I
| 7  6      | 5  4                                      | 3  2      | 1  0     |
| --------- | ----------------------------------------- | --------- | -------- |
| PCIRB     | HST  ENH                                  | TOP  ENB  | REF-CNT  |
| DISA  R   | DFW  256                                  | MEM  RFC  | 1  0     |
| Bits 1-0  | REF-CNT -Alternate Refresh Count Control  |           |          |
00 = Refresh Count O
01 =Refresh Count 1
10 =Refresh Count 2
11 = Refresh Count 3
If enabled by setting bit 2 of this register to 1, these bits override the refresh count in
bit 6 of CR11 and specify the number of refresh cycles per horizontal line.
| Bit 2  | ENB RFC -Enable Alternate Refresh Count Control  |     |     |
| ------ | ------------------------------------------------ | --- | --- |
O =Alternate refresh count control (bits 1-0} is disabled
1 =Alternate refresh count control (bits 1-0) is enabled
| Bit 3  | TOP MEM -Enable Top of Memory Access  |     |     |
| ------ | ------------------------------------- | --- | --- |
O =Top of memory access disabled
1 =Simultaneous VGA text and Enhanced modes are enabled. CPU and CRTC
accesses are then directed to the top 32-or 64-KByte area of display memory
depending on whether address bit 13 is O or 1 respectively.
Bit 4  ENH 256 -Enable 8 Bits/Pixel or Greater Color Enhanced Mode
0 =Attribute controller shift registers configured for 4-bit modes
1 =Attribute controller shift register configured for 8-, 16-and 24/32-bit color
Enhanced modes
| Bit 5  | HST DFW -Enable High Speed Text Font Writing  |     |     |
| ------ | --------------------------------------------- | --- | --- |
O =Disable high speed text font writing
1 =Enable high speed text font writing
Setting this bit to 1 is only required for DCLK rates greater than 40 MHz.
| Bit 6  | Reserved                              |     |     |
| ------ | ------------------------------------- | --- | --- |
| Bit 7  | PCIRB DISA -PCI Read Bursts Disabled  |     |     |
0 = PCI read burst cycles enabled
1 = PCI read burst cycles disabled
Note: Bit 7 of CR66 must be set to 1 before this bit is set to 1.
15-10 S3 VGA REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
53 Incorporated
Start Display FIFO Register !DT_ EX_POS) (CR3B)
| Read/Write  |     | Address: 3?5H, Index 3BH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
Filling of the display FIFO is stopped at the end of active display for each scan line as defined by the
L parameter (bits 2-0 of CR61 and bits 7-0 of CR62). The Start Display FIFO Fetch value specifies the
time in character clocks from the start of a scan line until the restart of fetching of display FIFO data
for screen refresh. This value must lie in the horizontal blanking period and is typically 5 less than
the value programmed in CRO. This parameter helps to ensure that adequate time is available dur
ing horizontal blanking for activities such as RAM refresh that require control of the display mem
ory. Bit 9 of this value is bit 6 of CR5D. This register must be enabled by setting bit 4 of CR34 to 1.
| 7  6  | 5  4  | 3  2  | 0   |
| ----- | ----- | ----- | --- |
START DISPLAY FIFO FETCH
| Bits 7-0  | START DISPLAY FIFO FETCH  |     |     |
| --------- | ------------------------- | --- | --- |
9-bit Value= the time in character clocks from the active display start until the restart
of fetching of FIFO data after the start of horizontal blanking. This register contains
the low-order 8 bits of this value.
Interlace Retrace Start Register (IL_RTST ART) (CR3C)
| Read/Write  |     | Address: 3?5H, Index 3CH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This value allows determination of the even/odd row active display starting positions when operat
ing in an interlaced mode. This register is enabled by bit 5 of CR42.
| 7  6  | 5  4  | 3  2  | ,  0  |
| ----- | ----- | ----- | ----- |
INTERLACE RETRACE START POSITION
| Bits 7-0  | INTERLACE RETRACE START POSITION  |     |     |
| --------- | --------------------------------- | --- | --- |
Value= offset in terms of character clocks for Interlaced mode start/end in even/odd
frames .
| .. 9005049  | 0000891  | TTb  ..  |     |
| ----------- | -------- | -------- | --- |
S3 VGA REGISTER DESCRIPTIONS  15-11

Vision864 Graphics Accelerator
S3 Incorporated
Section 16: System Control Register Descriptions
System Control registers are configuration registers, mode control registers, and hardware graphics
cursor control registers. They are positioned in the same indexed register space as VGA S3 registers.
All of these registers are read/write protected at power-up by hardware reset. In order to read/write
these registers, the Register Lock 2 register (CR39) must be loaded with a key pattern (see the register
description). The registers will remain unlocked until the key pattern is reset by changing a significant
bit.
In the following register descriptions, 'R' stands for reserved (write= 0, read= undefined). See Appendix
A for a table listing each of the registers in this section and its page number.
System Configuration Register (SYS_CNFG) (CR40)
| Read/Write  |     |     | Address: 3?5H, Index 40H  |     |
| ----------- | --- | --- | ------------------------- | --- |
Power-On Default: 10H
| 7  l  6  | 5                                        | 4    | 3  2  | 1  0    |
| -------- | ---------------------------------------- | ---- | ----- | ------- |
| BUS TNO  | WOL                                      | ROY  |       | EN      |
| 1  0     | OLAY                                     | CTL  | R  R  | R  ENH  |
| Bit O    | EN ENH -Enable Enhanced Register Access  |      |       |         |
O =Enhanced register access disabled
1 = Enhanced register (x2E8H) access enabled
| Bits 3-1  | Reserved                             |     |     |     |
| --------- | ------------------------------------ | --- | --- | --- |
| Bits 4    | RDY CTL-Ready Control (VL-Bus only)  |     |     |     |
O =Minimum O wait state delay from SADS asserted to assertion of SRDY (for writes
to the FIFO). Bit 3 of CR58 must be set to 1 for this mode.
1 = Minimum 1 wait state delay from SADS asserted to assertion of SRDY (for writes
to the FIFO)(Default)
| Bit 5  | WDL DLAY -Write Latching Delay (VL-Bus only)  |     |     |     |
| ------ | --------------------------------------------- | --- | --- | --- |
0 =Latch write data on the first rising SCLK edge after the assertion of RDYIN (Default)
1 =Latch write data on the first rising SCLK edge after the assertion of SRDY
| .. 9005049  |     | 0000892  | 932  ..  |     |
| ----------- | --- | -------- | -------- | --- |
SYSTEM CONTROL REGISTER DESCRIPTIONS  16-1

••
r  Vision864 Graphics Accelerator
S3 Incorporated
Bits 7-6  BUS TNO-Bus Turnaround Non-Overlap (VL-Bus only)
00 =ABEN -DBEN non-overlap delay= 1 unit
01 =ABEN -DBEN non-overlap delay= 2 units
10 =ABEN -DBEN non-overlap delay= 3 units
11 =ABEN -DBEN non-overlap delay= 4 units
These bits control the gap between the deassertion of ABEN and the assertion of
DBEN and vice versa. This action switches the multiplexed AD[31 :OJ bus function
from address to data.
BIOS Flag Register (BIOS_FLAGI (CR41)
| Read/Write  |     | Address: 3?5H, lndex41H  |     |
| ----------- | --- | ------------------------ | --- |
Power-On Default: OOH
| 7   | 6  5  | 4  3  2  | 0   |
| --- | ----- | -------- | --- |
BIOS-FLAG-REGISTER-1
Bits 7-0  BIOS-FLAG-REGISTER-1
Used by the video BIOS. Users should not write to this register.
Mode Control Register (MODE_CTLI (CR421
| Read/Write  |     | Address: 3?5H, Index 42H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
|     |       | I        | I  I  |
| --- | ----- | -------- | ----- |
| 7   | 6  5  | 4  3  2  | 1  0  |
INTL
| R   | R  MODE  | R  DOT-CLOCK-SELECT  |     |
| --- | -------- | -------------------- | --- |
Bits 3-0  DOT-CLOCK-SELECT
These bits are effective when 11 bis programmed in bits 3-2 of the Miscellaneous Out
put register (3C2H) and are strobed on GD[3:0J by the STWR signal. The bit coding is
dependent on the clock generator capabilities.
Bit 4  Reserved
Bit 5  INTL MODE -Interlaced Mode
0 = Noninterlaced
1 = Interlaced
This bit enables the function of CR3C.
| Bits 7-6    | Reserved  |          |     |
| ----------- | --------- | -------- | --- |
| .. 9005049  | 0000893   | 879  ..  |     |
16-2 SYSTEM CONTROL REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
53 Incorporated
Extended Mode Register !EXT_ MODEi ICR43)
| Read/Write  |     | Address: 3?5H, Index 43H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6   | 5  4                                    | 3  2  | 1  0       |
| ------ | --------------------------------------- | ----- | ---------- |
| HCTR   |                                         | OLD   | OLD  VCLK  |
| X2  R  | R                                       | R     | EDG        |
|        | R                                       | LSW8  | RS2        |
| Bit 0  | VCLK EDG -Video Clock Edge Mode Select  |       |            |
O = PA[15:0) values change every VCLK rising edge
1 = PA[15:0) values change every VCLK rising and falling edge (15/16 bits/pixel only)
| Bit 1  | OLD RS2 -Old DAC Register Select Bit 2  |     |     |
| ------ | --------------------------------------- | --- | --- |
This is an extension bit of RS[1 :OJ for RAMDAC addressing. This is disabled if bit O of
the Extended Video DAC Control register (CR55) is set to 1.
| Bit 2  | OLD LSW8 -Logical Screen Width Bit 8  |     |     |
| ------ | ------------------------------------- | --- | --- |
This is an extension of the Offset (Screen Width) register (CR13). This is disabled if
bits 5-4 of the Extended System Control 2 register (CR51) are not OOb.
| Bits 6-3  | Reserved                                 |     |     |
| --------- | ---------------------------------------- | --- | --- |
| Bit 7     | HCTR X2 -Horizontal Counter Double Mode  |     |     |
O = Disable horizontal counter double mode
1 =Enable horizontal counter double mode (horizontal CRT parameters are doubled)
Hardware Graphics Cursor Mode Register (HGC_MODEJ (CR45)
| Read/Write  |     | Address: 3?5H, Index 45H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
l
| 7  6  | 5  4  | 3  2      | 1  0  |
| ----- | ----- | --------- | ----- |
|       |       | HWC-CSEL  | HWGC  |
HWGC
| R  R   | R  1280                                    | 1  0  | R  ENB  |
| ------ | ------------------------------------------ | ----- | ------- |
| Bit O  | HWGC ENB -Hardware Graphics Cursor Enable  |       |         |
O =Hardware graphics cursor disabled in any mode
1 =Hardware graphics cursor enabled in Enhanced mode
| Bit 1  | Reserved  |     |     |
| ------ | --------- | --- | --- |
.. 9005049  0000894  705  ..  SYSTEM CONTROL REGISTER DESCRIPTIONS  16-3

••
| r   |     |     | Vision864 Graphics Accelerator  |     |     |
| --- | --- | --- | ------------------------------- | --- | --- |
53 Incorporated
| Bits 3-2  | HWC-CSEL -Hardware Cursor Color Select  |     |     |     |     |
| --------- | --------------------------------------- | --- | --- | --- | --- |
8-bit RAMDAC
00 = Cursor colors are 4/8 bits/pixel (colors from CRE and CRF)
01 =Cursor colors are 16 bits/pixel (colors from CR4A and CR4Bl
10 =Cursor colors are 24 bits/pixel (colors from CR4A and CR4B)
11 =Cursor colors are 32 bits/pixel (colors from CR4A and CR4B)
These bits settings must match the pixel length settings in bits 5-4 of CR50.
16-bit RAMDAC
00 =Cursor colors are 4/8/16 bits/pixel (colors from CR4A and CR4B)
01 =Cursor colors are 24/32 bits/pixel (colors from CR4A and CR4B)
10 =Reserved
11 = Reserved
These bits are used to select the color depth of the hardware cursor. The Hardware
Graphics Cursor Foreground and Background Color Stack registers (CR4A, CR4B),
stack pointers 0-3 define the color except when using 4/8 bits/pixel with an 8-bit RAM
DAC.
Bit 4  HWGC 1280 -Hardware Cursor Right Storage
0 = Function disabled
1 =For 4 bits/pixel, the last 256 bytes in each 1-KByte line of the hardware cursor start
address become the hardware graphics cursor storage area. For 8 bits/pixel, the
last 512 bytes in each 2-KByte line of the hardware cursor start address become
the hardware graphics cursor storage area. In either case, bits 1-0 of CR4D must
be 11 b.
Reserved
Bits 7-5
Hardware Graphics Cursor Origin-X Registers (HWGC_ ORGX(H)(L)) (CR46, CR47)
| Read/Write  |     | Address: 3?5H, Index 46H, 47H  |     |     |     |
| ----------- | --- | ------------------------------ | --- | --- | --- |
Power-On Default: OOOOH
The high order three bits are written into CR46 and the low order byte is written into CR47.
| 15  14      | 13  12                                               | 11  10  9  8  7    | 6  5  4         | 3  2  | 0   |
| ----------- | ---------------------------------------------------- | ------------------ | --------------- | ----- | --- |
| R  R        | R  R                                                 | R  HWGC ORG X (H)  | HWGC ORG X (L)  |       |     |
| Bits 10-0   | HWGC ORG X(H) (L) -X-Coordinate of Cursor Left Side  |                    |                 |       |     |
| Bits 15-11  | Reserved                                             |                    |                 |       |     |
| .. 9005049  | 0000895                                              | 641  ..            |                 |       |     |
16-4 SYSTEM CONTROL REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
53 Incorporated
Hardware Graphics Cursor Origin-Y Registers !HWGC_ORGV(H)(L}) (CR48, CR49)
| Read/Write  |     | Address: 3?5H, Index 48H, 49H  |     |     |     |
| ----------- | --- | ------------------------------ | --- | --- | --- |
Power-On Default: Undefined
The high order three bits are written into CR48 and the low order byte is written into CR49.
| 15  14  | 13  12  11  | 10  9           | 8  7  6  | 5  4  3  2      | 0   |
| ------- | ----------- | --------------- | -------- | --------------- | --- |
| R  R    | R  R  R     | HWGC ORG Y (H)  |          | HWGC ORG Y (L)  |     |
Bits 10-0  HWGC ORGY (H)(L) -Y-Coordinate of Cursor Upper Line
The cursor X, Y position is registered upon writing HWGC ORGY (H).
| Bits 15-11  | Reserved  |     |     |     |     |
| ----------- | --------- | --- | --- | --- | --- |
Hardware Graphics Cursor Foreground Color Stack Register ( HWGC_FGSTK) (CR4A)
| Read/Write  |     | Address: 3?5H, Index 4AH  |     |     |     |
| ----------- | --- | ------------------------- | --- | --- | --- |
Power-On Default: Undefined
| 7  6  | 5  4  | 3  2  | 1  0  |     |     |
| ----- | ----- | ----- | ----- | --- | --- |
TRUE COLOR FOREGROUND STACK (0-3)
| Bits 7-0  | TRUE COLOR FOREGROUND STACK (0-3)  |     |     |     |     |
| --------- | ---------------------------------- | --- | --- | --- | --- |
Four foreground color registers are stacked at this address. The stack pointer (com
mon with CR4B) is reset to Oby reading the Hardware Graphics Cursor Mode register
(CR45). Each write to this register (CR4A) increments the stack pointer by 1, so four
writes provide 32 bits of true color information. These registers are selectively en
abled by bits 3-2 of CR45 .
.. 9005049  0000896  588  ..  SYSTEM CONTROL REGISTER DESCRIPTIONS  16-5

Vision864 Graphics Accelerator
S3 Incorporated
Hardware Graphics Cursor Background Color Stack Register ( HWGC_BGSTK) (CR4B)
|     | Read/Write  |     | Address: 3?5H, Index 4BH  |     |     |     |     |
| --- | ----------- | --- | ------------------------- | --- | --- | --- | --- |
Power-On Default: Undefined
|     | 7   | 6  5  | 4  3  | 2  1  | 0   |     |     |
| --- | --- | ----- | ----- | ----- | --- | --- | --- |
TRUE COLOR BACKGROUND STACK (0-3)
|     | Bits 7--0  | TRUE COLOR BACKGROUND STACK (0-3)  |     |     |     |     |     |
| --- | ---------- | ---------------------------------- | --- | --- | --- | --- | --- |
Four background color registers are stacked at this address. The stack pointer (com
mon with CR4A) is reset to Oby reading the Hardware Graphics Cursor Mode register
(CR45). Each write to this register {CR4B) increments the stack pointer by 1, so four
writes provide 32 bits of true color information. These registers are selectively en
abled by bits 3-2 of CR45.
Hardware Graphics Cursor Storage Start Address Registers {HWGC_STA{H)(L) {CR4C, CR4D)
|     | Read/Write  |     | Address: 3?5H, Index 4CH, 4DH  |     |     |     |     |
| --- | ----------- | --- | ------------------------------ | --- | --- | --- | --- |
Power-On Default: Undefined
The high order four bits are written into CR4C and the low order byte is written into CR4D.
|     | 15  14  | 13  12  | 11  10       | 9  8  7  | 6  5  4      | 3  2  1  | 0   |
| --- | ------- | ------- | ------------ | -------- | ------------ | -------- | --- |
|     | R  R    | R  R    | HWGC STA{H)  |          | HWGC STA(L)  |          |     |
Bits 11--0  HWGC STA(H){L) -Hardware Graphics Cursor Storage Start Address
|             | Bits 15-12  | Reserved  |      |     |     |     |     |
| ----------- | ----------- | --------- | ---- | --- | --- | --- | --- |
| .. 9005049  |             | 0000897   | 414  | ..  |     |     |     |
16-6 SYSTEM CONTROL REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
$3 Incorporated
Hardware Graphics Cursor Pattern Display Start X-PXL-Position Register (HWGC_DX) (CR4El
| Read/Write  |     | Address: 3?5H, Index 4EH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 5  4                       | 3  2  | 1  0  |
| ----- | -------------------------- | ----- | ----- |
| R  R  | HWGC PAT DISP START X-POS  |       |       |
Bits 5-0  HWGC PAT DISP START X-POS -HWGC Pattern Display Start-X Pixel Position
This value is the offset (in pixels) from the left side of the 64x64 cursor pixel pattern
from which the cursor is displayed. This allows a partial cursor to be displayed at the
left border of the display.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Hardware Graphics Cursor Pattern Disp Start V-PXL-Position Register (HGC_DV) (CR4F)
| Read/Write  |     | Address: 3?5H, Index 4FH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 5  4                       | 3  2  | 1  0  |
| ----- | -------------------------- | ----- | ----- |
| R  R  | HWGC PAT DISP START Y-POS  |       |       |
Bits 5-0  HWGC PAT DISP START Y-POS -HWGC Pattern Display Start-Y Pixel Position
This value is the offset (in pixels) from the top of the 64x64 cursor pixel pattern from
which the cursor is displayed. This allows a partial cursor to be displayed at the top
of the display.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
.. 9005049  0000898  350  ..  SYSTEM CONTROL REGISTER DESCRIPTIONS  16-7

••
r
Vision864 Graphics Accelerator
53 Incorporated
Section 17: System Extension Register Descriptions
These registers provide extended system and memory control, external sync control and addressing
window control. They are enabled in the same way as the System Control registers via the Register
Lock 2 register (CR39).
In the following register descriptions, 'R' stands for reserved (write= 0, read= undefined). See Appendix
A for a table listing each of the registers in this section and its page number.
Extended System Cont 1 Register (EX_SCTL_ 1I (CR501
Read/Write Address: 3?5H, Index 50H
Power-On Default: OOH
I I
7 6 5 4 3 2 1 0
GE-SCR-W PXL-LNGH ENB GESW
1 0 1 0 R BREO R 2
Bit O Extension bit 2 of the screen width definition. See bits 7-6 below.
Bit 1 Reserved
Bit 2 ENB BREQ -Enable BREQ Function
O = BREQ, BGNT functions disabled
1 = BREQ, BGNT functions enabled
Bit 3 Reserved
Bits 5-4 PXL-LNGH -Pixel Length Select
00 = 1 byte (Default). This corresponds to a pixel length of 4 or 8 bits/pixel in bit 7 of
the Subsystem Status register (42E8H)
01 = 2 bytes. 16 bits/pixel
10 =Reserved
11 = 4 bytes. 32 bits/pixel
These bits select the pixel length for Enhanced mode command execution through
the Graphics Engine.
.. 9005049 0000899 297 ..
SYSTEM EXTENSION REGISTER DESCRIPTIONS 17-1

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Bits 7-6  GE-SCR-W -Graphics Engine Command Screen Pixel Width
Bit O of this register is the most significant bit of this definition.
000 = 1024 (or 2048 if bit 1 of CR31 =1) (Default)
001=640
010 = 800 (or 1600x1200x4 if bit 2 of 4AE8H = 1)
011 = 1280
100=1152
101 =Reserved
110 = 1600
111 = Reserved
Extended System Control 2 Register (EX_SCTL_2) {CR51)
|     | Read/Write  |     | Address: 3?5H, Index 51H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
|     |           | l                                               | l         | l         |
| --- | --------- | ----------------------------------------------- | --------- | --------- |
|     | 7         | 6  5                                            | 4  3  2   | 1  0      |
|     |           | LOG-SCR-W                                       | OLD-CBAD  | OLD-DSAD  |
|     | R         | R  9  8                                         | 19  18    | 19  18    |
|     | Bits 1-0  | OLD-DSAD -Old Display Start Address Bits 19-18  |           |           |
These are extension bits of Memory Configuration register (CR31) bits 5-4 (Display
Start Base Address). If the upper 4 display start address bits are programmed into
bits 3-0 of CR69, these bits and bits 5-4 of CR31 are ignored.
|     | Bits 3-2  | OLD-CBAD -Old CPU Base Address Bits 19-18  |     |     |
| --- | --------- | ------------------------------------------ | --- | --- |
These are extension bits of CRT Register Lock register (CR35) bits 3-0 (CPU Base Ad
dress). They becomes bits 19-18 of the CPU base address, enabling access to up to 4
MBytes of display memory. If the upper 6 CPU base address bits are programmed
into bits 5-0 of CR6A, these bits and bits 3-0 of CR35 are ignored.
|     | Bits 5-4  | LOG-SCR-W -Logical Screen Width Bits 9-8  |     |     |
| --- | --------- | ----------------------------------------- | --- | --- |
These are two extension bits of the Offset register (CR13). If the value of these bits is
not OOb, bit 2 of the Extended Mode register (CR43) is disabled.
|     | Bits 7-6                                      | Reserved  |         |                |
| --- | --------------------------------------------- | --------- | ------- | -------------- |
| •   | 9005049                                       | 0000900   | 839  •  | -------------- |
|     | 17-2  SYSTEM EXTENSION REGISTER DESCRIPTIONS  |           |         |                |

Vision864 Graphics Accelerator
S3 Incorporated
Extended BIOS Flag 1 Register (EXT_BBFLG1) (CR52)
Read/Write Address: 3?5H, Index 52H
Power-On Default: OOH
7 6 5 4 3 2 0
EXT-BIOS-FLAG-REGISTER-1
Bits 7-0 EXT-BIOS-FLAG-REGISTER-1
See the S3 video BIOS documentation for the coding of this register. Note that this
coding is different from that used with previous S3 accelerators.
Extended Memory Control 1 Register (EX_MCTL_1J (CR53J
Read/Write Address: 3?5H, Index 53H
Power-On Default: OOH
7 6 5 4 3 2 1 0
SWP ENB ENB
R NBL R MMIO R R R WPB
Bit 0 ENB WPB -Enable Write Per Bit
0 =Disable write per bit for all memory banks
1 =Enable write per bit for all memory banks
Bits 3-1 Reserved
Bit 4 ENB MMIO -Enable MMIO Access
O =Disable (Default)
1 =Enable Memory-Mapped 1/0
The first 32-KByte MMIO area (AOOOOH-A7FFFH) is used for image transfers via E2E8H
and E2EAH. The second 32-KByte MMIO area (A8000H-AFFFFH) is used for the En
hanced command registers (from 82E8H to BEE8H).
Bit 5 Reserved
Bit 6 SWP NBL -Swap Nibbles
0 = No nibble swap
1 =Swap nibbles in each byte of a linear memory address read or write operation
Bit 7 Reserved
II 9005049 0000901 775 11
SYSTEM EXTENSION REGISTER DESCRIPTIONS 17-3

Vision864 Graphics Accelerator
53 Incorporated
Extended Memory Control 2 Register (EX_MCTL_2J (CR54)
Read/Write Address: 3?5H, Index 54H
Power-On Default: OOH
7 6 5 4 3 2 0
M PARAMETER R R R
Bits 2-0 Reserved
Bits 7-3 M PARAMETER
5-bit Value= (number of 8-byte memory access cycles available for purposes other
than filling the display FIFO) -1. This parameter should be maximized within the con
straint that a display FIFO underrun is not allowed. See Section 7.4, Display Memory
Access Control, for more information.
Extended RAMDAC Control Register (EX_DAC_CT) (CR55)
Read/Write Address: 3?5H, Index 55H
Power-On Default: OOH
7 6 5 4 3 2 1 0
TOFF MS R ENB DAC
VCLK R R /X11 GIR R RS2
Bit 0 DAC RS2 -DAC Register Select Bit 2
This is the extension bit of the RS[1:0] signals for RAMDAC addressing. If the value of
this bit is one, bit 1 of the Extended Mode register (CR43) is disabled and the RS2 out
put pin is driven high. If the value of this bit is 0, the state of RS2 is determined by bit
1 of CR43.
Bit 1 Reserved
Bit 2 ENB GIR -Enable General Input Port Read
O = RAMDAC reads enabled
1 = RAMDAC reads disabled. The RMSTRD and RS2 strobes for reading the General
Input Port data are enabled.
Bit 3 Reserved
Bit 4 MS/X11 -Hardware Cursor MS/X11 Mode
O = MS-Windows mode (Default)
1 = X11-Windows mode
This bit select the type of decoding used for the 64x64x2 storage array of the hard
ware graphics cursor. See the Programming the Hardware Cursor section for a de
scription of the decoding .
.. 9005049 0000902 601 .. ~~~~~~~~~~~~~~
17-4 SYSTEM EXTENSION REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
S3 Incorporated
| Bits 6-5  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
Bit 7  TOFF VCLK -Tri-State Off VCLK Output
0 =Normal operation
1 = VCLK output is tri-stated off
External Sync Control 1 Register (EX_SYNC_ 1 I (CR561
| Read/Write  |     | Address: 3?5H, Index 56H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
| 7  6  | 5  4        | 3     | 2  1  | 0    |
| ----- | ----------- | ----- | ----- | ---- |
|       | TOFF  PRST  | ESYN  |       | RMT  |
| R  R  | SYNC  ODDF  | RN    | R  R  | ON   |
Bit O  RMT ON -Remote Mode Operation
O = Remote Mode operation off
1 = Remote Mode operation on. The VSYNC pin becomes the input for genlocking.
| Bits 2-1  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
ESYN RN -External Sync Vertical Counter Reset Select
Bit 3
O = HorizontalNertical counter reset sync (Default)
1 =Vertical counter-only reset sync with genlocking
If bit O (Remote Mode) is set to 1, the falling edge of the VSYNC input signal resets
the vertical counter (every other frame in the interlaced mode) or both the horizontal
and vertical counters.
Bit 4  PRST ODDF -Preset Frame Select (-EVEN/ODD)
O =Start with the Even Frame after a V-counter reset (Default)
1 = Start with the Odd Frame after a V-counter reset
This bit is effective only when bit 3 = 1 with remote mode on (bit O = 1 ).
Bit 5  TOFF SYNC -Tri-State Off Sync Outputs
0 = Normal operation
1 = HSYNC, VSYNC, and BLANK become tri-state off outputs
| Bits 7-6   | Reserved  |       |     |     |
| ---------- | --------- | ----- | --- | --- |
| - 9005049  | 0000903   | 5 48  | -   |     |
SYSTEM EXTENSION REGISTER DESCRIPTIONS  17-5

••
r
Vision864 Graphics Accelerator
53 Incorporated
External Sync Control 2 Register (EX_SYNC_2) (CR57)
| Read,Write  |     |     | Address: 3?5H, Index 57H  |     |
| ----------- | --- | --- | ------------------------- | --- |
Power-On Default: OOH
|     | l                  | l  l               |                    | l  l     |
| --- | ------------------ | ------------------ | ------------------ | -------- |
|     | 7  6               | 5  4               | 3  L 2             | 1  0     |
|     | HSYN-RESET-ADJUST  |                    | VSYN-RESET-ADJUST  |          |
|     | 3                  | 2  1  0            | 3                  | 2  1  0  |
|     | Bits 3-0           | VSYN-RESET-ADJUST  |                    |          |
This specifies the vertical delay line number of the V-counter reset from the falling
edge of VSYNC. The set value must be not equal zero in Remote mode (bit O of CR56
= 1).
|     | Bits 7-4  | HSYN-RESET-ADJUST  |     |     |
| --- | --------- | ------------------ | --- | --- |
This specifies the horizontal delay character number of the H-counter reset from the
falling edge of VSYNC after VSYNC Reset Adjust.
Linear Address Window Control Register (LAW_CTL) (CR58)
| Read,Write  |     |     | Address: 3?5H, Index 58H  |     |
| ----------- | --- | --- | ------------------------- | --- |
Power-On Default: OOH
l
|     | 7  6      | 5  4                                  | 3    | 2  1  0   |
| --- | --------- | ------------------------------------- | ---- | --------- |
|     |           | ENB                                   | LAT  | LAW-SIZE  |
|     | R  R      | R  LA                                 | DEL  | R  1  0   |
|     | Bits 1-0  | LAW-SIZE -Linear Address Window Size  |      |           |
00 = 64 KBytes (Default)
01 = 1 MByte
10 = 2 MBytes
11=8 MBytes
Programmers should set these bits to 11 b for a 4-MByte memory configuration and
be aware that the second 4-MByte region of enabled address space is not backed
with real memory.
Bit 2  Reserved
Bit 3  LAT DEL -Address Latch Delay Control (VL-Bus only)
O =Address latching is delayed one clock (T2 cycle)
1 =Address latching occurs in the T1 cycle
This bit is effective only when one decode wait state is selected by setting bit 4 of
CR40 to 1.
| •  9005049  |     | 0000904  | 484  •  | -------------- |
| ----------- | --- | -------- | ------- | -------------- |
17-6 SYSTEM EXTENSION REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
| Bit 4  | ENB LA -Enable Linear Addressing  |     |     |     |     |     |     |
| ------ | --------------------------------- | --- | --- | --- | --- | --- | --- |
O =Disable linear addressing (Default)
1 =Enable linear addressing
Enabling linear addressing disables access to the AOOOH-AFFFH region unless bank
ing is enabled via bit O of CR31, the window size is set to 64K via bits 1-0 of this regis
ter and AOOOH is specified as the base in CR59-5A.
| Bits 7-5  | Reserved  |     |     |     |     |     |     |
| --------- | --------- | --- | --- | --- | --- | --- | --- |
Linear Address Window Position Registers (LAW_POS{X) (CR59-5A)
| Read/Write  |     | Address: 3?5H, Index 59H-5AH  |     |     |     |     |     |
| ----------- | --- | ----------------------------- | --- | --- | --- | --- | --- |
Power-On Default: OOOAH
2
| 15  14  | 13  12  | 11  10  | 9  8  7  | 6   | 5  4  | 3   | 0   |
| ------- | ------- | ------- | -------- | --- | ----- | --- | --- |
LINEAR-ADDRESS-WINDOW-POSITION
CR59 contains the upper byte (15-8) and CR5A contains the lower byte (7-0). These registers specify
the Linear Address Window Position in 32-bit CPU address space. The Linear Address Window resides
on a 64KB, 1 MB, 2MB or SMB memory boundary (size-aligned boundary). Some LSBs of this register
(illustrated by "xx. . xx" in the following table) are ignored because of the size-aligned boundary scheme.
|     | LAW          |     | Linear Address Window     |         |         |     |     |
| --- | ------------ | --- | ------------------------- | ------- | ------- | --- | --- |
|     | Size         |     | Position Regjster Bit(s)  |         |         |     |     |
|     | 64KB  31-25  | 24  | 23  22  21                | 20  19  | 18  17  | 16  |     |
|     | 1MB  31-25   | 24  | 23  22  21                | 20  xx  | xx  xx  | xx  |     |
|     | 2MB  31-25   | 24  | 23  22  21                | xx  xx  | xx  xx  | xx  |     |
|     |              |     | xx  xx                    | xx  xx  | xx  xx  | xx  |     |
|     | SMB  31-25   | 24  | 23                        |         |         |     |     |
Bits 15-0  LINEAR-ADDRESS-WINDOW-POSITION -LA Window Position Bits 31-16
16-bit Value= the linear address window position in 32-bit CPU address space.
Bits 31-23 are common with bits 31-23 of the base address programmed into the PCI
Base Address O register at address 10H-12H. Writes to these bits in either register will
also be written to the other. In general, the bits should be programmed via the PCI
configuration register. Writes to CR59 and CR5A should be read-modify-writes that
do not change bits 31-23.
If a 64K window is specified and bit 0 of CR31 is set to 1, bits 5-0 of CR6A specify the
64K page of display memory to be accessed through a 64K window located at the ad
dress specified in these registers .
•  9005049  0000905  310  •  SYSTEM EXTENSION REGISTER DESCRIPTIONS  17-7

••
r  Vision864 Graphics Accelerator
53 Incorporated
Extended BIOS Flag 2 Register {EXT_ BFLG2 } {CR5BI
| Read/Write  |     | Address: 3?5H, Index 5BH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 15  14  | 13  12  | 11  10  | 9  8  |
| ------- | ------- | ------- | ----- |
EXT-BIOS-FLAG-REGISTER-2
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-2  |     |     |
| --------- | ------------------------- | --- | --- |
Used by the BIOS.
General Output Port Register {GOUT_ PORT) {CR5CI
| Read/Write: See Bit Descriptions  |     | Address: 3?5H, Index 5CH  |     |
| --------------------------------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7                 | 6  5                                       | 4  3  2           | 1  0  |
| ----------------- | ------------------------------------------ | ----------------- | ----- |
| GENERAL-OUT-PORT  |                                            | CLOCK-SELECT-OUT  |       |
| Bits 3-0          | CLOCK-SELECT-OUT (Read Only) -DCLK Select  |                   |       |
The value stored in these bits is determined as shown in the following table. The bit
values are driven on GD[3:0] when CR42 bits 3-0, 3C2H bits 3-2 or this register (bits 7-
4) are written to and are strobed into the clock generator by STWR.
| 3C2H, Bits 3-2  |                                | CLOCK-SELECT-OUT       |     |
| --------------- | ------------------------------ | ---------------------- | --- |
|                 | 00                             | 0000                   |     |
|                 | 01                             | 0001                   |     |
|                 | 10                             | 0010                   |     |
|                 | 11                             | Content of CR42 [3:0]  |     |
| Bits 7-4        | GENERAL-OUT-PORT {Read/Write)  |                        |     |
These bits are user definable. They are driven on GD[7:4] when written and also
when CR42 bits 3-0 or 3C2H bits 3-2 are written and are strobed into an external buff
er by STWR .
| •  9005049  | 0000906  | 257  •  -------------- |     |
| ----------- | -------- | ---------------------- | --- |
17-8 SYSTEM EXTENSION REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Extended Horizontal Overflow Register (EXT_H_OVFI (CRSD)
Read/Write Address: 3?5H, Index 5DH
Power-On Default: OOH
7 6 5 4 3 2 1 0
BGT SFF EHS SHS EHB SHB HDE HT
8 8 +32 8 +64 8 8 8
Bit 0 HT 8 -Horizontal Total (CRO) Bit 8
Bit 1 HDE 8 -Horizontal Display End (CR11Bit8
Bit 2 SHB 8 -Start Horizontal Blank (CR2) Bit 8
Bit 3 EHB+64 -End Horizontal Blank (CR3) + 64
0 = BLANK pulse unaffected
1 = BLANK pulse extended by 64 DCLKs
Bit 4 SHS 8 -Start Horizontal Sync Position (CR4) Bit 8
Bit 5 EHS+32 -End Horizontal Sync (CR5) + 32
O = HSYNC pulse unaffected
1 = HSYNC pulse extended by 32 DCLKs
Bit 6 SFF 8 -Start FIFO Fetch (CR3B) Bit 8
Bit 7 BGT 8 -Bus-Grant Terminate Position (CR5F) Bit 8
Extended Vertical Overflow Register (EXT_ V _OVF) (CR5El
Read/Write Address: 3?5H, Index 5EH
Power-On Default: OOH
7 6 5 4 3 2 1 0
LCM VRS SVB VDE VT
R 10 R 10 R 10 10 10
Bit 0 VT 10 -Vertical Total (CR6) Bit 10
Bit 1 VDE 10 -Vertical Display End (CR12) Bit 10
Bit 2 SVB 10 -Start Vertical Blank (CR15) Bit 10
Bit 3 Reserved
Bit 4 VRS 10 -Vertical Retrace Start (CR10) Bit 10
• 9005049 0000907 193 • SYSTEM EXTENSION REGISTER DESCRIPTIONS 17-9

••
r
Vision864 Graphics Accelerator
S3 Incorporated
|     | Bit 5  | Reserved                                     |     |     |
| --- | ------ | -------------------------------------------- | --- | --- |
|     | Bit 6  | LCM 10 -Line Compare Position (CR18) Bit 10  |     |     |
|     | Bit 7  | Reserved                                     |     |     |
Bus Grant Termination Position Register (BGNT _T POS) (CRSF)
|     | Read/Write  |     | Address: 3?5H, Index 5FH  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
The Bus Grant Termination Position is a 9-bit value specifying the horizontal line position (in charac
ter clocks) at which an active BGNT signal is deasserted, requiring a secondary controller to give up
control of the memory bus. A subsequent BREQ from the secondary memory controller will not be
granted until after the start of the next scan line. This must be set to a value that ensures that
enough time is available for RAM refresh and hardware cursor fetch. The ninth bit is bit 7 of CR5D.
This value is effective only if bit 2 of CR50 is set to 1.
|     | 7  6  | 5  4  | 3  2  | 0   |
| --- | ----- | ----- | ----- | --- |
BGNT-TPOS
|     | Bits 7-0  | BGNT _T POS -Bus Grant Termination Position  |     |     |
| --- | --------- | -------------------------------------------- | --- | --- |
9-bit Value= the horizontal line position (in character clocks) at and beyond which a
bus grant (BGNT) to an alternate memory controller is deasserted. This register con
tains the least significant 8 bits of this value.
Extended Memory Control 3 Register (EXT-MCTL-31 (CR60)
|     | Read/Write  |     | Address: 3?5H, Index 60H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
|     | 7  6  | 5  4  | 3  2  | 0   |
| --- | ----- | ----- | ----- | --- |
N(DISP-FETCH-PAGE)
|     | Bits 7-0  | N(DISP-FETCH-PAGE) -N Parameter  |     |     |
| --- | --------- | -------------------------------- | --- | --- |
Value= (number of 4-byte (1 MByte of memory) or 8-byte (2 or 4 MBytes of memory)
units written to the display FIFO before memory access is allowed to other reques
tors) -1. See Section 7 .4, Display Memory Access Control, for more information.
| •   | 9005049  | 0000908  | 02T  •  --------------- |     |
| --- | -------- | -------- | ----------------------- | --- |
11-10 SYSTEM EXTENSION REGISTER DESCRIPTIONS

=·
r
Vision864 Graphics Accelerator
S3 Incorporated
Extended Memory Control 4 Register (EXT-MCTL-41 (CR611
| Read/Write  |     | Address: 3?5H, Index 61H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
|           |                                                     |       | I             | I   |
| --------- | --------------------------------------------------- | ----- | ------------- | --- |
| 7         | 6  5                                                | 4  3  | 2  1          | 0   |
| ENB       |                                                     |       | L(DISP-FETCH- |     |
| DFLC      | R  R                                                | R  R  | LENGTH) 10-8  |     |
| Bits 2-0  | L(DISP-FETCH-LENGTH) 10-8 -L Parameter (Bits 10-8)  |       |               |     |
These are bits 10-8 of the L parameter. See the description of the L parameter in the
description for CR62.
| Bits 6-3  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
Bit 7  ENB DFLC -Enable Display Fetch Length Control
0 = Display fetch length control (L parameter) disabled
1 =Display fetch length control (l parameter) enabled
Extended Memory Control 5 Register (EXT-MCTL-51 (CR621
| Read/Write  |     | Address: 3?5H, Index 62H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: 07H
These are the lower 8 bits of an 11-bit value used in conjunction with the Mand N parameters to op
timize performance. If the display FIFO is being filled when this value is reached, FIFO filling will be
stopped and memory control will be switched to the M parameter. The upper three bits are bits 2-0
of CR61.
|     | 6  5  | 4  3  | 2   | 0   |
| --- | ----- | ----- | --- | --- |
7
L(DISP-FETCH-LENGTH) 7-0
| Bits 7-0  | L(DISP-FETCH-LENGTH) 7-0 -L Parameter (Bits 7-0)  |     |     |     |
| --------- | ------------------------------------------------- | --- | --- | --- |
11-bit Value= (number of bytes of displayed pixels per scan line) divided by 4 for 1-
Byte memory configurations or divided by 8 for 2-or 4-MByte memory
configurations. This register contains the least significant 8 bits of this value .
| •  9005049  | 0000909  | Tbb  | •   |     |
| ----------- | -------- | ---- | --- | --- |
SYSTEM EXTENSION REGISTER DESCRIPTIONS  17-11

Vision864 Graphics Accelerator
S3 Incorporated
External Sync Delay Adjust High Register (EX-DL-ADJST-HI) (CR63)
| Read/Write  |     | Address: 3?5H, Index 63H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register provides the high order bits of values that specify delays for the vertical and horizontal
sync resets. These delays are required for genlocking a second video source to a primary video
source (both feeding the same RAMDAC). The purpose of the adjustment is to have the origin (0,0
coordinate) at the same screen position for both video sources.
| 7                     | 6  5  | 4  3               | 2  1  0  |
| --------------------- | ----- | ------------------ | -------- |
| HS YNC-RES ET-ADJ ST  |       | VSYNC-RESET-ADJST  |          |
Bits 3-0  VSYNC-RESET-ADJST -VSYNC Reset Adjust (Bits 7-4)
This specifies the upper 4 bits of the VSYNC Reset Adjust. The lower 4 bits are bits 3-
0 of CR57. This value specifies the number of scan lines the VSYNC reset in the slave
is delayed from the falling edge of the VSYNC input from the master.
Bits 7-4  HSYNC-RESET-ADJST -HSYNC Reset Adjust (Bits 7-4)
This specifies the upper 4 bits of the HSYNC Reset Adjust. The lower 4 bits are bits 7-
4 of CR57. This value specifies the number of character clocks the HSYNC reset in the
slave is delayed from the falling edge of the VSYNC input from the master.
Genlocking Adjustment Register (CH-CRT-DOT-ADJSTl (CR64l
/
| Read/Write  |     | Address: 3?5H, Index 64H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register allows finer-grain genlocking adjustments that those provided by CR57 and CR63.
|     | l  l  |       | I  I     |
| --- | ----- | ----- | -------- |
| 7   | 6  5  | 4  3  | 2  1  0  |
CH
|      |                  | H-CTR  | H-CTR-DOT-ADD- |
| ---- | ---------------- | ------ | -------------- |
| ENB  | CH-CLK-PH-ADJST  | ENB    | ADJ ST         |
Bits 2-0  H-CTR-DOT-ADD-ADJST -H-Counter Dot Addition Adjust
This value adjusts the timing of the H-Counter reset delay in terms of dot clocks. Bit 3
is the enable for this function.
Bit 3  H-CTR ENB -Enable for H-Counter Dot Addition Adjust
O =Disable H-Counter Dot Addition Adjustment
1 =Enable H-Counter Dot Addition Adjustment
Bits 6-4  CH-CLK-PH-ADJST -Character Clock Phase Adjust
This specifies the delay (in dot clock units) of the character clock from the rising edge
of VSYNC. Bit 7 is the enable for this function .
| •  9005049  | 0000910  | 788  ·-------------- |     |
| ----------- | -------- | -------------------- | --- |
17-12 SYSTEM EXTENSION REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
| Bit 7  | CH ENB -Enable for Character Clock Phase Adjust  |     |     |
| ------ | ------------------------------------------------ | --- | --- |
0 = Disable character clock phase adjustment
1 =Enable character clock phase adjustment
Extended Miscellaneous Control Register (EXT-MISC-CTL) (CR65)
| Read/Write  |     | Address: 3?5H, Index 65H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
~~~
| I  :  I  | :  I  :  I  | :  I :  I  | I  I :  |
| -------- | ----------- | ---------- | ------- |
R  I
| Bits 1-0  | Reserved                                        |     |     |
| --------- | ----------------------------------------------- | --- | --- |
| Bit 2     | ENB 3C3 -Enable 3C3H for Video Subsystem Setup  |     |     |
O = 46E8H is the address for video subsystem setup
1 = 3C3H is the address for video subsystem setup
This bit allows the CPU to initialize a second video card.
| Bits 7-3  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Extended Miscellaneous Control 1 Register (EXT-MISC-1) ICR66)
| Read/Write  |     | Address: 3?5H, Index 66H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
l  I
| 7          | 6  5      | 4  3  | 2  1  0   |
| ---------- | --------- | ----- | --------- |
| PCI  TOFF  |           |       | DIV-VCLK  |
| DE  PADT   | R         | R  R  | 2  1  0   |
| Bits 2-0   | DIV-VCLK  |       |           |
000 = VCLK = DCLK
001 = VCLK = DCLK/2
010 = VCLK = DCLK/4
011 = VCLK = DCLK/8
100 = VCLK = DCLK/16
101 = VCLK = DCLK/32
111 = Reserved
| Bits 5-3  | Reserved                                    |     |     |
| --------- | ------------------------------------------- | --- | --- |
| Bit 6     | TOFF PADT -Tri-State Off Pixel Address Bus  |     |     |
O = Normal operation
1 = PA[15:0] are set to tri-state off
•  9005049  0000911  614  •  SYSTEM EXTENSION REGISTER DESCRIPTIONS  17-13

••
r
Vision864 Graphics Accelerator
S3 Incorporated
|     | Bit 7  | PCI DE -PCI Bus Disconnect Enable  |     |     |
| --- | ------ | ---------------------------------- | --- | --- |
0 = PCI bus disconnect disabled
1 = PCI bus disconnect enabled
Setting this bit to 1 allows PCI burst cycles to be interrupted if AD[1 :O] 'i' OOb or if the
address during the burst goes outside the address ranges supported by the Vision864.
Extended Miscellaneous Control 2 Register (EXT-MISC-2)(CR67J
|     | Read/Write  |     | Address: 3?5H, Index 67H  |     |
| --- | ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
|     | l                  | l  l  |       |         |
| --- | ------------------ | ----- | ----- | ------- |
|     | 7  6               | 5  4  | 3  2  | 1  0    |
|     | PA 168-COLOR-MODE  |       |       | VCLK    |
|     | 3                  | 1  0  | R  R  | R  PHS  |
2
|     | Bit 0  | VCLK PHS -VCLK Phase With Respect to DCLK  |     |     |
| --- | ------ | ------------------------------------------ | --- | --- |
O = VCLK is 180° out of phase with DCLK (inverted)
1 = VCLK is in phase with DCLK
|     | Bits 3-1  | Reserved                                    |     |     |
| --- | --------- | ------------------------------------------- | --- | --- |
|     | Bits 7-4  | PA16B-COLOR-MODE -16-bit RAMDAC Color Mode  |     |     |
0000 = Mode O: 8-bit color, 1 VCLK/pixel
0010 = Mode 1: 15-bit color, 2 VCLKs/pixel
0100 = Mode 2: 24-bit color, 3 VCLKs/pixel
0110 = Mode 3: 16-bit color, 2 VCLKs/pixel
0001 = Mode 8: Two 8-bit color, 1 VCLK/2 pixels
0011 =Mode 9: 15-bit color, 1 VCLK/pixel
0101 = Mode 10: 16-bit color, 1 VCLK/pixel
0111 = Mode 11: 24/32-bit color, 2 VCLKs/pixel
| •  9005049  | 0000912  | 550  | ·-------------- |     |
| ----------- | -------- | ---- | --------------- | --- |
17-14 SYSTEM EXTENSION REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Configuration 3 Register (CNFG-REG-31 (CR68l
| Read/Write  |     | Address: 3?5H, Index 68H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Depends on Strapping
This is the third byte (along with CR36 and CR37} of the power-on strapping bits. PD[23:16] are sampled
on power-on reset and their states are written to bits 7-0 of this register. A5H must be written to CR39
to provide read/write access to this register.
| l         | l                         | l         | l        |
| --------- | ------------------------- | --------- | -------- |
| 7  6      | 5  4                      | 3  2      | 1  0     |
| RAS-PCG   | RAS-LOW                   | MA·D·SEL  | CAS-STR  |
| 1  0      | 1  0                      | 1  0      | 1  0     |
| Bits 1-0  | CAS, WE, OE Stretch Time  |           |          |
00 = 6.5 ns delay (nominal}
01 = 5 ns delay (nominal}
10 = 3.5 ns delay (nominal}
11 =no delay
This parameter adjusts the timing for the rising edges of the CAS, WE and OE signals.
This allows stretching of the signal active time. The falling edges of these signals are
not affected. The delay times shown above are approximations. They are affected by
both process and signal loading and must be measured for each design.
| Bits 3-2  | MA-D-SEL -Memory Address Depth Select  |     |     |
| --------- | -------------------------------------- | --- | --- |
00 = Reserved
01 =Reserved
10 =Reserved
11 = 256K (512 rows x 512 columns}
| Bits 5-4  | RAS-LOW -RAS Low Timing Select  |     |     |
| --------- | ------------------------------- | --- | --- |
00 = 6.5 MCLKs
01 = 5.5 MCLKs
10 = 4.5 MCLKs
11 = 3.5 MCLKs
This parameter specifies the length of the RAS active time for a single row/column ac
cess. RAS may be held low longer to accommodate additional page mode accesses
to the same row.
| Bits 7-6  | RAS-PCG -RAS Precharge Timing Select  |     |     |
| --------- | ------------------------------------- | --- | --- |
00 = Reserved
01 = 4.5 MCLKs
10 = 3.5 MCLKs
11 = 2.5 MCLKs
When RAS goes high to end a memory cycle, this parameter specifies the minimum
period it must be held high before beginning another memory access cycle .
| .. 9005049  | 0000913  | 497  ..  |     |
| ----------- | -------- | -------- | --- |
SYSTEM EXTENSION REGISTER DESCRIPTIONS  17-15

Vision864 Graphics Accelerator
53 Incorporated
Extended System Control 3 Register (EXT-SCTL-3HCR69)
| Read/Write  |     | Address: 3?5H, Index 69H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7   | 6  5  | 4  3  2                   | 1  0  |
| --- | ----- | ------------------------- | ----- |
| R   | R  R  | R  DISPLAY-START-ADDRESS  |       |
Bits 3-0  DISPLAY-START-ADDRESS
This field contains the upper 4 bits (19-16) of the display start address, allowing ad
dressing of up to 4 MBytes of display memory. When a non-zero value is
programmed in this field, bits 5-4 of CR31 and 1-0 of CR51 {the old display start ad
dress bits) are ignored.
Bits 7-4  Reserved
Extended System Control 4 Register {EXT-SCTL-4)(CR6AI
| Read/Write  |     | Address: 3?5H, Index 6AH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7   | 6  5  | 4  3  2           | 1  0  |
| --- | ----- | ----------------- | ----- |
| R   | R     | CPU-BASE-ADDRESS  |       |
Bits S-0
CPU-BASE-ADDRESS
This field contains the upper 6 bits {19-14) of the CPU base address, allowing access
ing of up to 4 MBytes of display memory via 64K pages. When a non-zero value is
programmed in this field, bits 3-0 of CR35 and 3-2 of CR51 {the old CPU base address
bits) are ignored. Bit 0 of CR31 must be set to 1 to enable this field. If linear address
ing is enabled and a 64 KByte window is specified, these bits specify the 64K page to
be accessed at the base address specified in CR59 and CR5A. Otherwise, the base ad
dress is normally at AOOOH.
Bits 7-6  Reserved
| .. 9005049  | 0000914  | 323  ..  |     |
| ----------- | -------- | -------- | --- |
17-16 SYSTEM EXTENSION REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Extended BIOS Flag 3 Register (EBIOS-FLG3)(CR6Bl
| Read/Write  |     | Address: 3?5H, Index 6BH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6  | 5  4  | 3  2  | 0   |
| ----- | ----- | ----- | --- |
EXT-BIOS-FLAG-REGISTER-3
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-3  |     |     |
| --------- | ------------------------- | --- | --- |
This register is reserved for use by the S3 BIOS.
Extended BIOS Flag 4 Register (EBIOS-FLG4)(CR6Cl
| Read/Write  |     | Address: 3?5H, Index 6CH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6  | 5  4  | 3  2  | 0   |
| ----- | ----- | ----- | --- |
EXT-BIOS-FLAG-REGISTER-4
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-4  |     |     |
| --------- | ------------------------- | --- | --- |
This register is reserved for use by the S3 BIOS.
Extended Miscellaneous Control 3 Register (EXT-MISC-3HCR6Dl
| Read/Write  |     | Address: 3?5H, Index 6DH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6      | 5  4                                   | 3  I                 |       |
| --------- | -------------------------------------- | -------------------- | ----- |
|           |                                        | 2  I  1              | I  0  |
| R  R      | R  R                                   | R  DELAY-BL-BY-DCLK  |       |
| Bits 2-0  | DELAY-BL-BY-DCLK -Delay BLANK by DCLK  |                      |       |
The BLANK active pulse is delayed by the number of DCLK units programmed into
this field. The pulse width is not affected.
| Bits 7-3  | Reserved  |     |     |
| --------- | --------- | --- | --- |
•  90050 49  0000915  26 T •  SYSTEM EXTENSION REGISTER DESCRIPTIONS 17-17

••
r
Vision864 Graphics Accelerator
53 Incorporated
Section 18: Enhanced Commands Register Descriptions
These registers support the Vision864 Enhanced drawing commands. Access to these registers is
enabled via bit O of the System Configuration register (CR40).
In the following register descriptions, 'R' stands for reserved (write= 0, read= undefined). See Appendix
A for a table listing each of the registers in this section and its page number.
Subsystem Status Register (SUBSYS_STATJ
| Read Only  | Address: 42E8H  |     |     |     |     |
| ---------- | --------------- | --- | --- | --- | --- |
Power-On Default: OOOOH
This read-only register provides information on interrupt status, monitor l.D. and the number of bits
per pixel. See the Subsystem Control (42E8H, Write Only) register for details on enabling and clearing
i nte rru pts.
l  l
| 15  14  13  | 12  11  | 10  9  8  7   | 6  5      | 4  3  2      | 1  0      |
| ----------- | ------- | ------------- | --------- | ------------ | --------- |
|             |         | PXL           | GIP DATA  | FIFO  FIFO   | GE  VSY   |
| R  R  R     | R  R    | R  R  R  LNG  | 2  1      | 0  EMP  OVF  | BSY  INT  |
Bit O VSY INT -Vertical Sync Interrupt Status
0 =No interrupt
1 =Interrupt generated if enabled
| Bit 1  GE BSY -Graphics Engine Busy Interrupt Status  |     |     |     |     |     |
| ----------------------------------------------------- | --- | --- | --- | --- | --- |
O = No interrupt
1 = Interrupt generated if enabled
| Bit 2  FIFO OVF -FIFO Overflow Interrupt Status  |     |     |     |     |     |
| ------------------------------------------------ | --- | --- | --- | --- | --- |
O =No interrupt
1 =Interrupt generated if enabled
| Bit 3  FIFO EMP -FIFO Empty Interrupt Status  |     |     |     |     |     |
| --------------------------------------------- | --- | --- | --- | --- | --- |
0 = No interrupt
1 = Interrupt generated if enabled
| .. 9005049  | 0000916  | 1Tb  ..  |     |     |     |
| ----------- | -------- | -------- | --- | --- | --- |
ENHANCED COMMANDS REGISTER DESCRIPTIONS 18-1

Vision864 Graphics Accelerator
53 Incorporated
Bits 6-4 GIP DATA -General Input Port Data
These bits reflect the states of GD[7:5] during power-on reset. These lines are
strapped to provide design-specific information.
Bit 7 PXL LNG -Pixel Length {#of bit planes)
0 = 4-bit
1 = 8-bit
This reflects the number of bit planes when bits 5-4 of the Extended System Control 1
register (CR50) are OOb.
Bits 15-8 Reserved
Subsystem Control Register {SUBSVS_CNTL)
Write Only Address: 42E8H
Power-On Default: OOOOH
This register allows each of several interrupt sources to be enabled or disabled. Interrupt status {Subsystem
Status (42E8H, Read Only) can be cleared. This register also controls the software reset of the graphics engine.
l I
1s 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
GE-RST FIFO-ENS GE VSY FIFO FIFO GEB VSY
1 0 R R EMP OVF BSY ENS R R R R CLE CLO CLR CLR
Bit O VSY CLR -Clear Vertical Sync Interrupt Status
O =No change
1 =Clear
Bit 1 GEB CLR -Clear Graphics Engine Busy Interrupt Status
0 =No change
1 =Clear
Bit 2 FIFO CLO -Clear FIFO Overflow Interrupt Status
0 =No change
1 =Clear
Bit 3 FIFO CLE -Clear FIFO Empty Interrupt Status
0 =No change
1 =Clear
Bits 7-4 Reserved
Bit 8 VSY ENB -Vertical Sync Interrupt Enable
0 =Disable
1 =Enable
.. 9005049 0000917 032 ..
18-2 ENHANCED COMMANDS REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
| Bit 9  | GE BSY-Graphics Engine Busy Interrupt Enable  |     |     |     |     |
| ------ | --------------------------------------------- | --- | --- | --- | --- |
0 =Disable
1 =Enable
| Bit 10  | FIFO-ENB OVF -FIFO Overflow Interrupt Enable  |     |     |     |     |
| ------- | --------------------------------------------- | --- | --- | --- | --- |
O =Disable
1 =Enable
| Bit 11  | FIFO-ENB EMP -FIFO Empty Interrupt Enable  |     |     |     |     |
| ------- | ------------------------------------------ | --- | --- | --- | --- |
O =Disable
1 =Enable
| Bits 13-12  | Reserved                                |     |     |     |     |
| ----------- | --------------------------------------- | --- | --- | --- | --- |
| Bits 15-14  | GE-RST -Graphics Engine Software Reset  |     |     |     |     |
00 = No change
01 =Graphics Engine enabled
10 =Reset
11 = Reserved
Advanced Function Control Register IADVFUNC_CNTL)
| Read/Write  | Address: 4AE8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: OOOOH
This register enables or disables the enhanced display functions.
| 15  14  | 13  12  11                           | 10  9  8  7  | 6  5  4     | 3  2   | 1  0     |
| ------- | ------------------------------------ | ------------ | ----------- | ------ | -------- |
|         |                                      |              |             | ENH    | ENB      |
| R  R    | R  R  R                              | R  R  R  R   | R  MIO  LA  | R  PL  | R  EHFC  |
| Bit O   | ENB EHFC -Enable Enhanced Functions  |              |             |        |          |
O =Enable VGA and VESA planar (4 bits/pixel) modes
1 =Enable all other modes (Enhanced and VESA non-planar)
| Bit 1  | Reserved                             |     |     |     |     |
| ------ | ------------------------------------ | --- | --- | --- | --- |
| Bit 2  | ENH PL -Enhanced modes pixel length  |     |     |     |     |
O = 8 or more bits/pixel enhanced modes
1 = 4 bits/pixel enhanced modes
Bits 5-4 of CR50 are used to differentiate between 8-, 16-and 32-bit pixel lengths.
| Bit 3       | Reserved  |                                          |     |     |       |
| ----------- | --------- | ---------------------------------------- | --- | --- | ----- |
| .. 9005049  | 0000918   | T79  ..                                  |     |     |       |
|             |           | ENHANCED COMMANDS REGISTER DESCRIPTIONS  |     |     | 18-3  |

••
r
Vision864 Graphics Accelerator
53 Incorporated
Bit 4  LA -Enable Linear Addressing
0 =Disable linear addressing
1 =Enable linear addressing
This bit is ORed with bit 4 of CR58 and is equivalent to it.
MIO -Enable Memory Mapped 1/0 (MMIO)
Bit 5
0 = Disable MMIO
1 = Enable MMIO
This bit is ORed with bit 4 of CR53 and is equivalent to it.
Bits 15-6  Reserved
Current Y-Position Register(CUR_Y I
| Read/Write  |     | Address: 82E8H  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-On Default: Undefined
Writing to this register defines the vertical screen coordinate at which the next pixel will be drawn.
Reading it produces the current vertical coordinate.
| 15  | 14  13  12  | 11  10  9  | 8  7  6  5          | 4  3  2  | 0   |
| --- | ----------- | ---------- | ------------------- | -------- | --- |
| R   | R  R  R     |            | CURRENT Y-POSITION  |          |     |
Bits 11-0  CURRENT Y-POSITION
Bits 15-12  Reserved
Current X-Position Register (CUR_XI
| Read/Write  |     | Address: 86E8H  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-On Default: Undefined
Writing to this register defines the horizontal screen coordinate at which the next pixel will be drawn.
Reading it produces the current horizontal coordinate.
| 15  | 14  13  12  | 11  10  9  8  | 6  5                | 3  2  |     |
| --- | ----------- | ------------- | ------------------- | ----- | --- |
|     |             |               | 7                   | 4     | 0   |
| R   | R  R  R     |               | CURRENT X-POSITION  |       |     |
Bits 11-0  CURRENT X-POSITION
Bits 15-12  Reserved
| .. 9005049  | 0000919  | 905  ..  |     |     |     |
| ----------- | -------- | -------- | --- | --- | --- |
18-4 ENHANCED COMMANDS REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Destination Y-Position/Axial Step Constant Register (DESTY_AXSTPJ
| Read/Write  | Address: 8AE8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
This register defines the destination Y position for BitBL Ts and pattern fills or the axial step constant
for line draws.
| 15  14  13                         | 12  11  10  | 9  8  7                 | 6  5  4  | 3  2  1  | 0   |
| ---------------------------------- | ----------- | ----------------------- | -------- | -------- | --- |
| R  R  R                            | R           | DESTINATION Y-POSITION  |          |          |     |
| Bits 11-0  DESTINATION Y-POSITION  |             |                         |          |          |     |
This setting applies only to 8it8LTs and pattern fills.
| Bits 15-12  Reserved  |             |                                     |          |       |     |
| --------------------- | ----------- | ----------------------------------- | -------- | ----- | --- |
| 15  14  13            | 12  11  10  | 9  8  7                             | 6  5  4  | 3  2  | 0   |
| R  R                  |             | LINE PARAMETER AXIAL STEP CONSTANT  |          |       |     |
Axial Step Constant= 2 * (min(idx!.!dylll In other words, when drawing a line from point A to point 8,
determine the change in the X coordinate from A to 8 and the change in the Y coordinate from A to 8.
Take the smaller of the two changes and multiply its absolute value by 2.
| Bits 13-0  LINE PARAMETER AXIAL STEP CONSTANT  |     |     |     |     |     |
| ---------------------------------------------- | --- | --- | --- | --- | --- |
This setting applies only to line draws.
| Bits 15-14  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
Destination X-Position/Diagonal Step Constant Register (DESTX_DIASTPJ
| Read/Write  | Address: 8EE8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
This register defines the destination X position for 8it8LTs and pattern fills or the diagonal step constant
for line draws.
| 15  14  13                         | 12  11  10  | 9  8  7                 | 6  5  4  | 3  2  | 0   |
| ---------------------------------- | ----------- | ----------------------- | -------- | ----- | --- |
| R  R  R                            | R           | DESTINATION X-POSITION  |          |       |     |
| Bits 11-0  DESTINATION X-POSITION  |             |                         |          |       |     |
This setting applies only to 8it8LTs and pattern fills.
| Bits 15-12  Reserved  |          |                                          |     |     |       |
| --------------------- | -------- | ---------------------------------------- | --- | --- | ----- |
| - •  9005049          | 0000920  | 627  •                                   |     |     |       |
|                       |          | ENHANCED COMMANDS REGISTER DESCRIPTIONS  |     |     | 18-5  |

••
r
Vision864 Graphics Accelerator
53 Incorporated
| 15  14  | 13  12  | 11  10  9  8  7                        | 6  5  4  | 3  2  | 0   |
| ------- | ------- | -------------------------------------- | -------- | ----- | --- |
| R  R    |         | LINE PARAMETER DIAGONAL STEP CONSTANT  |          |       |     |
Diagonal Step Constant= 2 * [min(jdxl.ldyi) -max(idxl.ldyi)J See the Destination Y-Position/Axial Step
Constant {8AE8H} register for an explanation oflhe terms used in this equation.
| Bits 13-0  | LINE PARAMETER DIAGONAL STEP CONSTANT  |     |     |     |     |
| ---------- | -------------------------------------- | --- | --- | --- | --- |
This setting applies only to line draws.
| Bits 15-14  | Reserved  |     |     |     |     |
| ----------- | --------- | --- | --- | --- | --- |
Line Error Term Read/Write Register (ERR_T ERM}
| Read/Write  |     | Address: 92E8H  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the initial error term for the line draw operation.
| 15  14  | 13  12  | 11  10  9  8  7            | 6  5  4  | 3  2  | 0   |
| ------- | ------- | -------------------------- | -------- | ----- | --- |
| R  R    |         | LINE PARAMETER/ERROR TERM  |          |       |     |
Error Term= 2 * min(jdxl,ldyp -maxqdxl.ldYI -1 if the starting X <the ending X
Error Term= 2 * minqdxl.ldyp -maxqdxl.ldYI if the starting X ~the ending X
See the Destination Y-Position/Axial Step Constant {8AE8H) register for an explanation of the terms
used in these equations.
| Bits 13-0   | LINE PARAMETER/ERROR TERM  |     |     |     |     |
| ----------- | -------------------------- | --- | --- | --- | --- |
| Bits 15-14  | Reserved                   |     |     |     |     |
Major Axis Pixel Count Register (MAJ_AXIS_PCNTJ
| Read/Write  |     | Address: 96E8H  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the length (in pixels) of the major (longest) axis.
| 15  14  | 13  12  | 11  10  9  8  7  | 6  5  4  | 3  2  | 0   |
| ------- | ------- | ---------------- | -------- | ----- | --- |
| R  R    | R  R    |                  |          |       |     |
RECTANGLE WIDTH/LINE PARAMETER MAX
| Bits 11-0  | RECTANGLE WIDTH/LINE PARAMETER MAX  |     |     |     |     |
| ---------- | ----------------------------------- | --- | --- | --- | --- |
This parameter applies to BitBLT s, line draws and rectangle fills and pattern fills. Its
value is the number of pixels along the major axis -1.
| Bits 15-12  | Reserved  |          |     |     |     |
| ----------- | --------- | -------- | --- | --- | --- |
| .. 9005049  | 0000921   | 5b3  ..  |     |     |     |
18-6 ENHANCED COMMANDS REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
53 Incorporated
Graphics Processor Status Register (GP _STAT)
|     | Read Only  |     |     | Address: 9AE8H  |     |     |     |     |     |
| --- | ---------- | --- | --- | --------------- | --- | --- | --- | --- | --- |
Power-On Default: Undefined
|     | l  l         | J            | l       |     |         | l  l  | l            | J  l  | J  j  |
| --- | ------------ | ------------ | ------- | --- | ------- | ----- | ------------ | ----- | ----- |
|     | 15  14       | 13           | 12  11  | 10  | 9  8    | 7  6  | 5  4         | 3  2  | 1  0  |
|     | FIFO-STATUS  |              |         |     | HDW     |       | FIFO-STATUS  |       |       |
|     | 9  10        | 11           | 12  13  | AE  | BSY  R  | 1  2  | 3  4         | 5  6  | 7  8  |
|     | Bits 7-0     | FIFO-STATUS  |         |     |         |       |              |       |       |
In the following table, the leftmost column represents the value of FIFO status bit 1
(register bit 7). Each column to the right represents the value of the next higher FIFO
status bit. A value of O read from any particular status bit position guarantees at least
as many open FIFO slots as the number of that status bit. For example, if a O is read
from status bit 9 (register bit 15), there are at least 9 open FIFO slots.
0000000000000 = 13 FIFO slots available
0000000000001 = 12 FIFO slots available
0000000000011 = 11 FIFO slots available
|     |     | 0000000000111 = 1O  |     |     |  FIFO slots available  |     |     |     |     |
| --- | --- | ------------------- | --- | --- | ---------------------- | --- | --- | --- | --- |
0000000001111 = 9 FIFO slots available
0000000011111 = 8 FIFO slots available
0000000111111 = 7 FIFO slots available
0000001111111 = 6 FIFO slots available
0000011111111 = 5 FIFO slots available
0000111111111 = 4 FIFO slots available
0001111111111 = 3 FIFO slots available
0011111111111 = 2 FIFO slots available
0111111111111=1 FIFO slots available
1111111111111 = O FIFO slots available
Bit 8  Reserved
Bit 9  HDW BSY -Hardware (Graphics Engine) Busy
0 =not busy
1 =busy -graphics command is executing
Bit 10  AE -All FIFO Slots Empty
0 =At least one FIFO slot is occupied
1 =All FIFO slots empty
|     | Bits 15-11  | FIFO-STATUS  |     |     |     |     |     |     |     |
| --- | ----------- | ------------ | --- | --- | --- | --- | --- | --- | --- |
These are the upper 5 bit of the FIFO status. See bits 7-0 for the interpretation .
| .. 9005049  |     | 0000922  |     | 4TT  | ..                                       |     |     |     |       |
| ----------- | --- | -------- | --- | ---- | ---------------------------------------- | --- | --- | --- | ----- |
|             |     |          |     |      | ENHANCED COMMANDS REGISTER DESCRIPTIONS  |     |     |     | 18-7  |

••
r
Vision864 Graphics Accelerator
$3 Incorporated
Drawing Command Register (CMD)
| Write Only  |     | Address: 9AE8H  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the drawing command and a number of associated control parameters.
| I       | I       | I          | I  I     |          |          |
| ------- | ------- | ---------- | -------- | -------- | -------- |
| 15  14  | 1a  12  | 11  10  s  | 8  1  s  | 5  4  3  | 2  1  0  |
CMD-TYPE  BYTE  BUS SIZE  WAIT  DRWG-DIR.  pRA\f\j DIR  LAST  PX
| 2  1  | 0  SWP  | R  1  0  | YES  2  1  | 0  YES  TYP  POF  | MD  R  |
| ----- | ------- | -------- | ---------- | ----------------- | ------ |
Bit O  Reserved
Bit 1  PX MD -Select Across the Plane Pixel Mode
0 =Single pixel transferred at a time (through the plane mode)
1 =Multiple pixels transferred at a time (across the plane mode)
Bit 2  LAST POF -Last Pixel Off
0 = Last pixel of line or vector draw will be drawn
1 = Last pixel of line or vector draw will not be drawn
Bit 3  DIR TYP -Select Radial Direction Type
0 = x-y (axial)
1 = Radial
Bit 4  DRAW YES -Draw Pixel
0 = Move the current position only -don't draw
1 = Draw pixel(s)
| Bits 7-5  | DRWG-DIR -Select Drawing Direction  |     |     |     |     |
| --------- | ----------------------------------- | --- | --- | --- | --- |
In the following table, radial drawing angle is measured counterclockwise from the X
axis. For axial line draws, the line is drawn from left to right or a +X and from right to
left for a -X, down for a +Y and up for a -Y. X or Y maj specifies the longest axis.
Radial (bit 3 = 1)
|     | 7-5  |     | x-y (Axial -bit 3 =  |     |     |
| --- | ---- | --- | -------------------- | --- | --- |
0)
oo
|     | 000  |     | -Y,X maj,-X  |     |     |
| --- | ---- | --- | ------------ | --- | --- |
001
|             |          | 45°      | -Y,X maj,+X  |     |     |
| ----------- | -------- | -------- | ------------ | --- | --- |
|             | 010      | 90°      | -Y,Y maj,-X  |     |     |
|             | 011      | 135°     | -Y,Y maJ,+X  |     |     |
|             | 100      | 180°     | +Y,Xma1,-X   |     |     |
|             | 101      | 225°     | +Y,Xmaj,+X   |     |     |
|             | 110      | 270°     | +Y,Yma1,-X   |     |     |
|             | 111      | 315°     | +Y,Ymaj,+X   |     |     |
| .. 9005049  | 0000923  | 336  ..  |              |     |     |
18-8 ENHANCED COMMANDS REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
53 Incorporated
Bit 8 WAIT YES -Wait for CPU Data
O =Use Graphics Engine-based data
1 =Wait for data to be transferred to or from the CPU through the E2E8H port
Bits 10-9 BUS SIZE -Select System Bus Size
00 = 8-bit
01 = 16-bit
10 = 32-bit
11 = Reserved
This parameter applies only to the Pixel Data Transfer (E2E8H, E2EAH) registers or
when using memory-mapped 1/0.
Bit 11 Reserved
Bit 12 BYTE SWP -Enable Byte Swap
O =High byte first, low byte second
1 =Low byte first, high byte second
Bits 15-13 CMD-TVPE -Select Command Type
000 =NOP. This is used to set up short stroke vector drawing without writing a pixel.
001 =Draw Line. If bit 3 of this register is cleared to 0, the axial step constant,
diagonal step constant and error term are used to draw the line. If bit 3 is set to
1, the line will be drawn at the angle specified by bits 7-5 and with a length in
pixels as specified by the Major Axis Pixel Count (96E8H) register.
010 =Rectangle Fill. The Major Axis Pixel Count register specifies the number of
pixels in each horizontal line and the Minor Axis Pixel Count (BEE8H, Index OOH)
register specifies the number of horizontal lines.
011 = Reserved
100 =Reserved
101 =Reserved
110 = BitBLT. This operation copies a rectangle from one part of display memory to
another. It uses the Destination X and V, the Current X and Y and the Major and
Minor Pixel Count registers.
111 =Pattern Fill. Same as a BitBlt except that an Bx8 patterned rectangle is
transferred repeatedly to the destination rectangle. The starting X coordinate of
the source rectangle should always be on an 8 pixel boundary .
.. 9005049 0000924 272 ..
ENHANCED COMMANDS REGISTER DESCRIPTIONS 18-9

Vision864 Graphics Accelerator
S3 Incorporated
Short Stroke Vector Transfer Register (SHORT_STROKEJ
|     | Write Only  |     | Address: 9EE8H  |     |     |     |     |     |
| --- | ----------- | --- | --------------- | --- | --- | --- | --- | --- |
Power-On Default: Undefined
This register defines two short stroke vectors. These are drawn one at a time based on the setting of
the BYTE SWAP bit (bit 12) in the Command (9AE8H) register.
|     | I         | I             | I             | l  l  | l  l       |         | I  l          | l   |
| --- | --------- | ------------- | ------------- | ----- | ---------- | ------- | ------------- | --- |
|     | 15        | 14  13  12    | 11  10        | 9  8  | 7  6       | 5  4    | 3  2  1       | 0   |
|     | DRWG-DIR  | DRW           | PIXEL-LENGTH  |       | DRWG-DIR.  | DRW     | PIXEL-LENGTH  |     |
|     | 2         | 1  0  -MV     | 3  2          | 1  0  | 2  1       | 0  -MV  | 3  2  1       | 0   |
|     | Bits 3-0  | PIXEL-LENGTH  |               |       |            |         |               |     |
Value =#pixels -1
|     | Bit 4  | DRW -MV -Draw Pixel  |     |     |     |     |     |     |
| --- | ------ | -------------------- | --- | --- | --- | --- | --- | --- |
O = Move current position only -don't draw
1 = Draw pixel
Bits 7-5  DRWG-DIR.-Select Drawing Direction (measured counterclockwise from the X axis)
000 = 0°
001 = 45°
010 = 90°
011=135°
100 = 180°
101 = 225°
110 = 270°
110=315°
Bits 15-8  These bits duplicate bits 7-0 to define the second short stroke vector .
| .. 9005049  |     | 0000925  | 109  | ..  |     |     |     |     |
| ----------- | --- | -------- | ---- | --- | --- | --- | --- | --- |
18-10 ENHANCED COMMANDS REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
$3 Incorporated
Background Color Register !BKGD_COLORJ
Read/Write Address: A2E8H
Power-On Default: Undefined
See the Enhanced Mode Bitmap Accessing Through the Graphics Engine section in the Functional
Description for a detailed explanation of how and when this color value is used when writing a pixel
to display memory.
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
BACKGROUND COLOR
31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16
BACKGROUND COLOR
Bits 31-0 BACKGROUND COLOR
If bit 9 of BEEB_EH is set to 1, this becomes a 32-bit register. If bit 9 of BEEB_EH is
cleared to 0, this is two 16-bit registers. In 32 bpp mode with 16-bit registers, the up
per and lower doublewords are read or written sequentially, depending on the state
of the RSF flag {bit 4 of BEEBH, Index EH). If RSF = 0, the lower 16 bits are accessed. If
RSF = 1, the upper 16 bits are accessed. The RSF flag toggles automatically when a
doubleword is read or written.
Foreground Color Register {FRGD_COLOR)
Read/Write Address: A6E8H
Power-On Default: Undefined
See the Enhanced Mode Bitmap Accessing Through the Graphics Engine section in the Functional
Description for a detailed explanation of how and when this color value is used when writing a pixel
to display memory.
15 14 13 12 11 10 9 8 7 6 5 4 3 2 0
FOREGROUND COLOR
31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16
FOREGROUND COLOR
Bits 31-0 FOREGROUND COLOR
If bit 9 of BEEB_EH is set to 1, this becomes a 32-bit register. If bit 9 of BEEB_EH is
cleared too, this is two 16-bit registers. In 32 bpp mode with 16-bit registers, the up
per and lower doublewords are read or written sequentially, depending on the state
of the RSF flag {bit 4 of BEEBH, Index EH). If RSF = 0, the lower 16 bits are accessed. If
RSF = 1, the upper 16 bits are accessed. The RSF flag toggles automatically when a
doubleword is read or written.
.. 9005049 000092b 045 ..
ENHANCED COMMANDS REGISTER DESCRIPTIONS 18-11

••
r Vision864 Graphics Accelerator
S3 Incorporated
Bitplane Write Mask Register (WRT _MASK)
Read/Write Address: AAEBH
Power-On Default: Undefined
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
BIT-PLANE WRITE MASK
31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16
BIT-PLANE WRITE MASK
Bits 31-0 BIT-PLANE WRITE MASK
If bit i = 0, bitplane i is not updated
If bit i = 1, bitplane i is updated
Bits 31-0 control planes 31-0 respectively. If bit 9 of BEEB_EH is set to 1, this becomes
a 32-bit register. If bit 9 of BEEB_EH is cleared to 0, this is two 16-bit registers. In 32
bpp mode with 16-bit registers, the upper and lower doublewords are read or written
sequentially, depending on the state of the RSF flag (bit 4 of BEEBH, Index EH). If RSF
= 0, the lower 16 bits are accessed. If RSF = 1, the upper 16 bits are accessed. The RSF
flag toggles automatically when a doubleword is read or written.
Bitplane Read Mask Register (RD_MASK)
Read/Write Address: AEEBH
Power-On Default: Undefined
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
BIT-PLANE READ MASK
31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16
BIT-PLANE READ MASK
Bits 31-0 BIT-PLANE READ MASK
If bit i = 0, bitplane i is not used as a data source
If bit i = 1, bitplane i is used as a data source
Bit-plane read mask for BitBLT and image transfer functions. Bits 31-0 control planes
31-0 respectively. If bit 9 of BEE8_EH is set to 1, this becomes a 32-bit register. If bit 9
of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode with 16-bit reg
isters, the upper and lower doublewords are read or written sequentially, depending
on the state of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the lower 16 bits are
accessed. If RSF = 1, the upper 16 bits are accessed. The RSF flag toggles automat
ically when a doubleword is read or written .
.. 9005049 0000927 T81 ..
18-12 ENHANCED COMMANDS REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Color Compare Register (COLOR_CMPI
| Read/Write  |     | Address: B2E8H  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-On Default: Undefined
This register contains the color value that is compared against the current bitmap color if the color
compare option is turned on by setting bit 8 of the Pixel Control (BEE8H, Index OEH) to 1. Bit 7 of the
Pixel Control register determines whether a match or a non-match results in a pixel update.
| 15  14  | 13  12  11  | 10  9  8  7  | 6  5  4  | 3  2  | 0   |
| ------- | ----------- | ------------ | -------- | ----- | --- |
COMPARISON COLOR WITH SOURCE
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
COMPARISON COLOR WITH SOURCE
COMPARISON COLOR WITH SOURCE
Bits 31-0
If bit 9 of BEE8_EH is set to 1, this becomes a 32-bit register. If bit 9 of BEE8_EH is
cleared to 0, this is two 16-bit registers. In 32 bpp mode with 16-bit registers, the up
per and lower doublewords are read or written sequentially, depending on the state
of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the lower 16 bits are accessed. If
RSF = 1, the upper 16 bits are accessed. The RSF flag toggles automatically when a
doubleword is read or written.
Background and Foreground Mix Registers {BKGD_MIX, FRGD_MIXI
| Read/Write  |     | Address: B6E8H (Background), BAE8H (Foreground)  |     |     |     |
| ----------- | --- | ------------------------------------------------ | --- | --- | --- |
Power-On Default: Undefined
See the Enhanced Mode Bitmap Accessing Through the Graphics Engine section in the Functional
Description for a detailed explanation of how and when these registers are used when writing a pixel
to display memory.
|           |                            |              | l        | l  l      | l   |
| --------- | -------------------------- | ------------ | -------- | --------- | --- |
| 15  14    | 13  12  11                 | 10  9  8  7  | 6  5  4  | 3  2  1   | 0   |
|           |                            |              | CLR-SRC  | MIX-TYPE  |     |
| R  R      | R  R  R                    | R  R  R  R   | 1  0  R  | 3  2  1   | 0   |
| Bits 3-0  | MIX-TYPE -Select Mix Type  |              |          |           |     |
In the general case, a new color is defined. A logical operation such as AND or OR is
then performed between it and the current bitmap color. If the bitplane to be written
is enabled, the result of this logical "mix" is written to the bitmap as the new pixel
color. The following table shows the mix types available ( ! =logical NOT).
| .. 9005049  | 0000928  | 918  ..                                  |     |     |        |
| ----------- | -------- | ---------------------------------------- | --- | --- | ------ |
|             |          | ENHANCED COMMANDS REGISTER DESCRIPTIONS  |     |     | 18-13  |

Vision864 Graphics Accelerator
53 Incorporated
0000 !current 1000 !current OR !new
0001 l<2f!!cal zero 1001 current OR I new
0010 l<2£!!cal one 1010 I current OR new
0011 leave current as 1s 1011 current OR new
0100 !new 1100 current AND new
0101 current XOR new 1101 !current AND new
0110 !current XOR new 1110 current AND !new
0111 new 1111 !current AND !new
Bit 4 Reserved
Bits 6-5 CLR-SRC -Select Color Source
00 = Background color (the register is the color source)
01 =Foreground color (the register is the color source)
10 =CPU data (the CPU is the color source)
11 = Display memory (the display memory is the color source)
Bits 15-7 Reserved
Read Register Data Register (RD_REG_DT)
Read Only Address: BEESH
Power-On Default: Undefined
A read of this register produces a read of the register specified by bits 2-0 of the Read Register Select
(BEEBH, Index OFH) register. Each read of BEEBH causes the read index (bits 2-0 of BEESH, Index OFH)
to increment by one. Registers BEEBH, Indices OH to OEH, 9AE8H, 42E8H and 46EBH can thus be rapidly
read by successive reads from BEEBH.
Note: Writes to the BEEBH registers (except the read index register, Index OFH) are pipelined. Therefore,
to correctly read back a write to one of these registers, issue a NOP drawing command (a write to
9AEBH with bits 15-13 programmed to OOOb) immediately after the BEEBH register write. Next, write
the desired register index to BEEBH, Index OFH and read the data from BEESH.
The BEESH registers are written directly by writing to BEESH with the appropriate register index in bits
15-12.
I I I
15 I 14 I 13 I 12 I 11 I 10 I 9 I 8 I 7 I 6 I 5 I 4 I 3 2 1 I 0
.. 9005049 0000929 854 ..
18-14 ENHANCED COMMANDS REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
SJ Incorporated
Minor Axis Pixel Count Register (MIN_AXIS_PCNTI
| Write Only  |     | Address: BEE8H, Index OH  |     |     |     |
| ----------- | --- | ------------------------- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the length of the minor (smallest) axis in pixels.
| 15  14     | 13  12  11        | 10  9  8  | 7  6  5  4        | 3  2  1  | 0   |
| ---------- | ----------------- | --------- | ----------------- | -------- | --- |
| 0  0       | 0  0              |           | RECTANGLE HEIGHT  |          |     |
| Bits 11-0  | RECTANGLE HEIGHT  |           |                   |          |     |
Value =(number of pixels in minor axis) -1
| Bits 15-12  | INDEX= OH  |     |     |     |     |
| ----------- | ---------- | --- | --- | --- | --- |
Top Scissors (SCISSORS_T l
| Write Only  |     | Address: BEE8H, Index 1H  |     |     |     |
| ----------- | --- | ------------------------- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the top of the clipping rectangle. It is the lowest Y value that will be drawn.
| 15  14      | 13  12  11          | 10  9  8  | 7  6  5  4          | 3  2  1  | 0   |
| ----------- | ------------------- | --------- | ------------------- | -------- | --- |
| 0  0        | 0                   |           | CLIPPING TOP LIMIT  |          |     |
| Bits 11-0   | CLIPPING TOP LIMIT  |           |                     |          |     |
| Bits 15-12  | INDEX= 1H           |           |                     |          |     |
Left Scissors (SCISSORS_Ll
| Write Only  |     | Address: BEESH, Index 2H  |     |     |     |
| ----------- | --- | ------------------------- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the left side of the clipping rectangle. It is the lowest X value that will be drawn.
| 15  14      | 13  12  11           | 10  9  8                                 | 7  6  5  4           | 3  2  | 0      |
| ----------- | -------------------- | ---------------------------------------- | -------------------- | ----- | ------ |
| 0  0        | 0                    |                                          | CLIPPING LEFT LIMIT  |       |        |
| Bits 11-0   | CLIPPING LEFT LIMIT  |                                          |                      |       |        |
| Bits 15-12  | INDEX= 2H            |                                          |                      |       |        |
| .. 9005049  | 0000930              | 576  ..                                  |                      |       |        |
|             |                      | ENHANCED COMMANDS REGISTER DESCRIPTIONS  |                      |       | 18-15  |

Vision864 Graphics Accelerator
S3 Incorporated
Bottom Scissors (SCISSORS_B)
| Write Only  |     | Address: BEEBH, Index 3H  |     |     |     |
| ----------- | --- | ------------------------- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the bottom of the clipping rectangle. It is the highest Yvalue that will be drawn.
| 15  14      | 13  12                 | 11  10  9  | 8  7  6  5             | 4  3  2  | 0   |
| ----------- | ---------------------- | ---------- | ---------------------- | -------- | --- |
| 0  0        |                        |            | CLIPPING BOTIOM LIMIT  |          |     |
| Bits 11-0   | CLIPPING BOTTOM LIMIT  |            |                        |          |     |
| Bits 15-12  | INDEX= 3H              |            |                        |          |     |
Right Scissors (SCISSORS_R)
| Write Only  |     | Address: BEE8H, Index 4H  |     |     |     |
| ----------- | --- | ------------------------- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the right side of the clipping rectangle. It is the highest Yvalue that will be drawn.
| 15  14      | 13  12                | 11  10  9  | 8  7  6  5            | 4  3  2  | 0   |
| ----------- | --------------------- | ---------- | --------------------- | -------- | --- |
| 0           | 0  0                  |            | CLIPPING RIGHT LIMIT  |          |     |
| Bits 11-0   | CLIPPING RIGHT LIMIT  |            |                       |          |     |
| Bits 15-12  | INDEX= 4H             |            |                       |          |     |
Pixel Control Register (PIX_CNTL)
| Write Only  |     | Address: BEEBH, Index OAH  |     |     |     |
| ----------- | --- | -------------------------- | --- | --- | --- |
Power-On Default: Undefined
See Bitmap Access Through the Graphics Engine in the Enhanced Mode Programming section for an
explanation of how and when bits 7-6 of this register are used when writing a pixel to display memory.
I
| 15  14  | 13  12  | 11  10  9  | 8  1  s  5  | 4  3  2  | 1  0  |
| ------- | ------- | ---------- | ----------- | -------- | ----- |
DT-EX-SRC
| 1  0        | 1  0      | R  R  R  | R  1  0  R  | R  R  R  | R  R  |
| ----------- | --------- | -------- | ----------- | -------- | ----- |
| Bits S-0    | Reserved  |          |             |          |       |
| .. 9005049  | 0000931   | 402  ..  |             |          |       |
18-16 ENHANCED COMMANDS REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
$3 Incorporated
| Bits 7-6  DT-EX-SRC -Select Mix Register  |     |     |     |     |     |
| ----------------------------------------- | --- | --- | --- | --- | --- |
00 =Foreground Mix register is always selected
01 = Reserved
10 =CPU data determines Mix register selected
11 =Display memory current value determines Mix register selected
| Bits 11-8  Reserved     |     |     |     |     |     |
| ----------------------- | --- | --- | --- | --- | --- |
| Bits 15-12  INDEX= OAH  |     |     |     |     |     |
Multifunction Co1~trul Miscellaneous 2 Register (MULT _MISC2)
| Write Only  | Address: BEE8H, Index OOH  |     |     |     |     |
| ----------- | -------------------------- | --- | --- | --- | --- |
Power-On Default: DOOOH
| 15  14  13                                    | 12  11  | 10  9  8  7     | 6  5  4   | 3  2  1   | 0   |
| --------------------------------------------- | ------- | --------------- | --------- | --------- | --- |
| =1  =1  =0                                    | =1  =0  | =0  =0  =0  =0  | SRC-BASE  | DST=BASE  |     |
| Bits 2-0  DST-BASE -Destination Base Address  |         |                 |           |           |     |
000 =First destination memory address is in the 1st MByte of display memory
001 =First destination memory address is in the 2nd MByte of display memory
010 =First destination memory address is in the 3rd MByte of display memory
011 =First destination memory address is in the 4th MByte of display memory
This field supersedes bits 1-0 of BEE8H, Index E if any of these 3 bits are set to 1.
| Bit 3  Reserved                          |     |     |     |     |     |
| ---------------------------------------- | --- | --- | --- | --- | --- |
| Bits 6-4  SRC-BASE -Source Base Address  |     |     |     |     |     |
000 =First source memory address is in the 1st MByte of display memory
001 = First source memory address is in the 2nd MByte of display memory
010 =First source memory address is in the 3rd MByte of display memory
011 =First source memory address is in the 4th MByte of display memory
This field supersedes bits 3-2 of BEE8H, Index E if any of these three bits are set to 1.
Reserved
Bits 11-7
| Bits 15-12  INDEX= OOH  |          |                                          |     |     |        |
| ----------------------- | -------- | ---------------------------------------- | --- | --- | ------ |
| .. 9005049              | 0000932  | 349  ..                                  |     |     |        |
|                         |          | ENHANCED COMMANDS REGISTER DESCRIPTIONS  |     |     | 18-17  |

••
r Vision864 Graphics Accelerator
S3 Incorporated
Multifunction Control Miscellaneous Register (MULT _MISCJ
Write Only Address: BEE8H, Index OEH
Power-On Default: EOOOH
I I
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 o
CMR ENB SRC SLW EXT RSF SRC-BA DEST-BA
1 1 1 0 R R 328 CMP NE RM CLIP 21 20 21 20
Bits 1-0 DEST-BA 21 20 -Destination Base Address Bits 21-20
00 =First destination memory address is in the 1st MByte of display memory
01 =First destination memory address is in the 2nd MByte of display memory
10 =First destination memory address is in the 3rd MByte of display memory
11 =First destination memory address is in the 4th MByte of display memory
This field is superseded by bits 2-0 of BEE8H if any of the BEE8H bits is set to 1.
Bits 3-2 SRC-BA 21 20 -Source Base Address Bits 21-20
00 =First source memory address is in the 1st MByte of display memory
01 =First source memory address is in the 2nd MByte of display memory
10 =First source memory address is in the 3rd MByte of display memory
11 =First source memory address is in the 4th MByte of display memory
This field is superseded by bits 6-4 of BEE8H if any of the BEE8H bits is set to 1.
Bit 4 RSF -Select Upper Word in 32 Bits/Pixel Mode
O =Selects lower 16 bits for accesses to 32-bit registers in 32 bpp mode
1 =Selects upper 16 bits for accesses to 32-bit registers in 32 bpp mode
Bit 5 EXT CLIP -Enable External Clipping
O =Only pixels inside the clipping rectangle are drawn
1 =Only pixels outside the clipping rectangle are drawn
Bit 6 SLW RMW -Select Slow Read/Modify/Write Cycle
0 = Fast Read/Modify/Write Cycle
1 =Slow Read/Modify/Write Cycle
When the Graphics Engines does a raster operation involving current screen data, it
must do a read/modify/write cycle. For a fast cycle, the read, modify and write each
take one MCLK. For a slow cycle, a wait state is inserted so that the entire process re
quires 4 MCLKs.
Bit 7 SRC NE -Don't Update Bitmap if Source Not Equal to Color Compare Color
O =Don't update current bitmap if the Color Compare (B2E8) register value is equal to
the color value of the source bitmap
1 =Don't update current bitmap if the Color Compare (B2E8) register value is not
equal to the color value of the source bitmap
This bit is only active if bit 8 of this register is set to 1.
.. 9005049 0000933 285 ..
18-18 ENHANCED COMMANDS REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
Bit 8  ENB CMP -Enable Color Compare
O =Disable color comparison
1 = Enable color comparison
Bit 9  CMR 328 -Select 32-Bit Command Registers
0 =Command registers (A2E8H, A6E8H, AAEBH, AEEBH, B2E8H) are 16-bit
1 = Command registers (A2EBH, A6E8H, AAEBH, AEEBH, B2EBH) are 32-bit. Byte and
word accesses cannot be made.
| Bits 11-10  | Reserved= O  |     |     |     |     |     |
| ----------- | ------------ | --- | --- | --- | --- | --- |
| Bits 15-12  | INDEX= OEH   |     |     |     |     |     |
Read Register Select Register IREAD_SEL)
| Write Only  |     | Address: BEEBH, Index OFH  |     |     |     |     |
| ----------- | --- | -------------------------- | --- | --- | --- | --- |
Power-On Default: Undefined
| 15  14    | 13  12  11                          | 10  9    | 8  7  6  | 5  4  | 3  2  1       | 0   |
| --------- | ----------------------------------- | -------- | -------- | ----- | ------------- | --- |
|           |                                     | R  R  R  | R  R  R  | R  R  | READ-REG-SEL  |     |
| Bits 2-0  | READ-REG-SEL -Read Register Select  |          |          |       |               |     |
When BEEBH is read, the value returned is determined by this read register index
according to the following:
0000 = BEEBH, Index OH
|     | 0001 = BEEBH, Index 1H  |     |     |     |     |     |
| --- | ----------------------- | --- | --- | --- | --- | --- |
0010 = BEEBH, Index 2H
0011 = BEEBH, Index 3H
0100 = BEEBH, Index 4H
0101 = BEEBH, Index OAH
0110 = BEEBH, Index OEH
0111=9AEBH (Bits 15-13 of the read data are forced to 0)
1000 =42EBH (Bits 15-12 of the read data are forced to 0)
1001 = 46EBH
1010 = BEEBH, Index ODH
The read register index increments by one with each reading of BEEBH.
| Bits 11-4   | Reserved    |          |     |     |     |     |
| ----------- | ----------- | -------- | --- | --- | --- | --- |
| Bits 15-12  | INDEX= OFH  |          |     |     |     |     |
| .. 9005049  | 0000934     | 111  ..  |     |     |     |     |
ENHANCED COMMANDS REGISTER DESCRIPTIONS 18-19

Vision864 Graphics Accelerator
53 Incorporated
Pixel Data Transfer Register (PIX_T RANS)
| Write Only  |     | Address: E2E8H  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-On Default: Undefined
All data to the Graphics Engine must pass through this register.
| 15  14  | 13  12  | 11  10  9  8  7  | 6  5  4  | 3  2  | 0   |
| ------- | ------- | ---------------- | -------- | ----- | --- |
IMAGE WRITE DATA
| Bits 15-0  | IMAGE WRITE DATA  |     |     |     |     |
| ---------- | ----------------- | --- | --- | --- | --- |
Pixel Data Transfer -Extension Register (PIX_TRANS_EXTI
| Write Only  |     | Address: E2EAH  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-On Default: Undefined
This register is an extension of E2E8H for 32-bit operations.
| 15  14  | 13  12  | 11  10  9  8  7  | 6  5  4  | 3  2  | 0   |
| ------- | ------- | ---------------- | -------- | ----- | --- |
IMAGE WRITE DATA
| Bits 15-0   | IMAGE WRITE DATA  |          |     |     |     |
| ----------- | ----------------- | -------- | --- | --- | --- |
| .. 9005049  | 0000935           | 058  ..  |     |     |     |
18-20 ENHANCED COMMANDS REGISTER DESCRIPTIONS

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Section 19: PCI Register Descriptions
The PCI specification defines a configuration register space. These registers allow device relocation,
device independent system address map construction and automatic configurations. The Vision864
provides a subset of these registers, which are described below.
The configuration register space occupies 256 bytes. When a configuration read or write command is
issued, the AD[7:0J lines contain the address of the register in this space to be accessed. The Vision864
supports or returns 0 for the first 64 bytes of this space.
In the following register descriptions, 'R' stands for reserved (write= 0, read= undefined). See Appendix
A for a table listing each of the registers in this section and its page number.
Vendor ID
| Read Only  | Address: OOH  |     |     |     |
| ---------- | ------------- | --- | --- | --- |
Power-On Default: 5333H
This read-only register identifies the device manufacturer.
| 1s  I  14  | 1a  12  11  | 10  9  s  | 1  s  s  | 4  a  2  |
| ---------- | ----------- | --------- | -------- | -------- |
|            |             | I  I  I   | I  I     | I        |
Vendor ID
| Bits 15-0  | Vendor ID  |     |     |     |
| ---------- | ---------- | --- | --- | --- |
This is hardwired to 5333H to identify S3 Incorporated .
| .. 9005049  | 0000936  | T94  ..  |     |     |
| ----------- | -------- | -------- | --- | --- |
PCI REGISTER DESCRIPTIONS  19-1

=·
| r   |     |     |     | Vision864 Graphics Accelerator  |     |     |
| --- | --- | --- | --- | ------------------------------- | --- | --- |
53 Incorporated
Device ID
| Read Only  |     | Address: 02H  |     |     |     |     |
| ---------- | --- | ------------- | --- | --- | --- | --- |
Power-On Default: 88COH or 88C1H
This read-only register identifies the device.
|     | I  I        | I  I  I     | I  e  I  |          |          |     |
| --- | ----------- | ----------- | -------- | -------- | -------- | --- |
|     | 15  14  13  | 12  11  10  | 9  1     | 6  5  4  | 3  2  1  | 0   |
Device ID
|     | Bits 15-0  Device ID  |     |     |     |     |     |
| --- | --------------------- | --- | --- | --- | --- | --- |
88COH or 88C1 H
Command
| Read/Write  |     | Address: 04H  |     |     |     |     |
| ----------- | --- | ------------- | --- | --- | --- | --- |
Power-On Default: OOOOH
This register controls which types of PCI cycles the Vision864 can generate and respond to.
|     | 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4    | 3  2  1  | 0    |
| --- | ----------- | ----------- | -------- | ---------- | -------- | ---- |
|     |             |             |          | DAC        | MEM      | 1/0  |
|     | R  R  R     | R  R  R     | R  R  R  | R  RSP  R  | R  R     |      |
Bit O  1/0 -Enable Response to 1/0 Accesses
0 = Response to 1/0 space accesses is disabled
1 = Response to 1/0 space accesses enabled
Bit 1  MEM -Enable Response to Memory Accesses
O = Response to memory space accesses is disabled
1 = Response to memory space accesses enabled
Bits 4-2  Reserved
Bit 5  DAC RSP -No Response to RAMDAC Register Accesses
O = Vision864 responds to RAMDAC register accesses
1 = Vision864 does not respond to RAMDAC register accesses
|             | Bits 15-6  Reserved  |      |     |     |     |     |
| ----------- | -------------------- | ---- | --- | --- | --- | --- |
| .. 9005049  | 0000937              | 920  | ..  |     |     |     |
19-2 PCI REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
53 Incorporated
Status
| Read/Write  |     | Address: 06H  |     |     |     |     |
| ----------- | --- | ------------- | --- | --- | --- | --- |
Power-On Default: 0200H
| 15  14     | 13  12  11                    | 10  9   | 8  7  | 6  5  4   | 3  2  | 0   |
| ---------- | ----------------------------- | ------- | ----- | --------- | ----- | --- |
| R          | R  R  R                       |         |       | Reserved  |       |     |
| R          |                               | DEVSEL  |       |           |       |     |
| Bits 8-0   | Reserved                      |         |       |           |       |     |
| Bits 10-9  | DEVSEL -Device Select Timing  |         |       |           |       |     |
01 = Medium DEVSEL timing. (hardwired)
| Bits 15-11  | Reserved  |     |     |     |     |     |
| ----------- | --------- | --- | --- | --- | --- | --- |
Revision ID
| Read/Write  |     | Address: 08H  |     |     |     |     |
| ----------- | --- | ------------- | --- | --- | --- | --- |
Power-On Default: Stepping Dependent
This register contains the revision level of the Vision864.
| 7  6  | 5  4  | 3  2  |     | 0   |     |     |
| ----- | ----- | ----- | --- | --- | --- | --- |
REVISION ID
| Bits 7-0  | REVISION ID  |     |     |     |     |     |
| --------- | ------------ | --- | --- | --- | --- | --- |
Programming Interface
| Read/Write  |     | Address: OAH  |     |     |     |     |
| ----------- | --- | ------------- | --- | --- | --- | --- |
Power-On Default: 01 H
| 7  6  | 5  4  | 3  2  |     | 0    |     |     |
| ----- | ----- | ----- | --- | ---- | --- | --- |
| R  R  | R  R  | R  R  | R   | VGA  |     |     |
| BitO  | VGA   |       |     |      |     |     |
1 =The Vision864 supports the standard VGA programming interface. (hardwired)
| Bits 7-1  | Reserved  |     |     |     |     |     |
| --------- | --------- | --- | --- | --- | --- | --- |
.. 9005049  0000938  867  ..  PCI REGISTER DESCRIPTIONS  19-3

••
r  Vision864 Graphics Accelerator
S3 Incorporated
Base Address O
| Read/Write  |     | Address: 12H (high)  |     | 10H (low)  |     |     |
| ----------- | --- | -------------------- | --- | ---------- | --- | --- |
Power-On Default: 0000 OOOOH
This is a 32-bit register in PCI configuration space that provides for address relocation. The Vision864
maps the upper 9 bits of the register to the Linear Address Window Position registers CR59-CR5A. Bit
23 maps to bit 7 of CR5A and bits [31:24] map to bits 7-0 of CR59. Consequently, these bits map to
system address bits [31:23].
l
| 15  14  | 13  12  | 11  10  | 9   | 8  7  6  5  | 4  3  2       | 1  0  |
| ------- | ------- | ------- | --- | ----------- | ------------- | ----- |
| R  R    | R  R    | R  R    | R   | R  R  R  R  | R  PREF       | MSI   |
|         |         |         |     |             | =0  TYPE =00  | =0    |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
|     | BASE ADDRESS 0  |     |     | R  R  | R  R  R  | R  R  |
| --- | --------------- | --- | --- | ----- | -------- | ----- |
Bit 0  MSI -Memory Space Indicator
O =Base registers map into memory space (hardwired)
| Bits 2-1  | TYPE -Type of Address Relocation  |     |     |     |     |     |
| --------- | --------------------------------- | --- | --- | --- | --- | --- |
00 =Locate anywhere in 32-bit address space (hardwired)
Bit 3  PREF -Prefetchable
0 =Does not meet the prefetchable requirements (hardwired)
| Bits 22-4   | Reserved        |     |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- | --- |
| Bits 31-23  | BASE ADDRESS 0  |     |     |     |     |     |
See the description for the Linear Address Window Position registers (CR59, CR5A).
Writes to CR59 and CR5A will also update this field .
| .. 9005049  | 0000939  | 7T3  | ..  |     |     |     |
| ----------- | -------- | ---- | --- | --- | --- | --- |
19-4 PCI REGISTER DESCRIPTIONS

Vision864 Graphics Accelerator
S3 Incorporated
BIOS ROM Base Address
| Read/Write  | Address: 32H {high) 30H {low)  |     |     |     |     |
| ----------- | ------------------------------ | --- | --- | --- | --- |
Power-On Default: OOOC OOOOH
This is a 32-bit register in PCI configuration space that provides for video BIOS ROM address relocation.
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  | 1  0    |
| ----------- | ----------- | -------- | -------- | ----- | ------- |
| R  R  R     | R  R  R     | R  R  R  | R  R  R  | R  R  | R  ADE  |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
BIOS ROM BASE ADDRESS
Bit O ADE -Address Decode Enable
O =Accesses to the BIOS ROM address space defined in this register are disabled
1 =Accesses to the BIOS ROM address space defined in this register are enabled
| Bits 15-1  Reserved               |     |     |     |     |     |
| --------------------------------- | --- | --- | --- | --- | --- |
| Bits31-16  BIOS ROM BASE ADDRESS  |     |     |     |     |     |
These are the upper 16 bits of the BIOS ROM address.
.. 9005049  0000940  415  ..  PCI REGISTER DESCRIPTIONS 19-5

Vision864 Graphics Accelerator
53 Incorporated
Appendix A: Register Reference
This Appendix contains tables listing all the registers in each of categories corresponding to Sections
12-19 of this data book.
• CGA-Compatible
• MDA-and HGC-Compatible
VGA
S3VGA
• System Control
• System Extension
• Enhanced Commands
PCI Configuration Space
Within each table, registers are listed in order of increasing addresses/indices. Name, address, register
bit descriptions with read/write status and the page number of the detailed register description are
provided for each register. All addresses and indices are hexadecimal values .
.. 9005049 0000941 351 .. REGISTER REFERENCE A-1

Vision864 Graphics Accelerator
S3 Incorporated
| A.1  CGA-COMPATIBLE REGISTERS  |                           |                                                               |                    |              |
| ------------------------------ | ------------------------- | ------------------------------------------------------------- | ------------------ | ------------ |
| Table A-1.                     | CGA-Compatible Registers  |                                                               |                    |              |
| Add                            | Index                     |                                                               | Register Name      | Description  |
| ress                           | Bit(s)  R/W               |                                                               | Bit DescrJj:ltion  | Pl!_g_e      |
| 305                            | 10                        | L!.g_ht Pen H!_g_h                                            |                    | 12-1         |
|                                | 5-0  R                    | H.!.9._h 6 bits of l!.9.)lt_12_en strobe address              |                    |              |
|                                | 7-6                       | Undefined                                                     |                    |              |
| 305                            | 11                        | Light Pen Low                                                 |                    | 12-1         |
|                                | R                         | Low ~e of lig_ht_12_en strobe address                         |                    |              |
| 308                            |                           | CGA Mode Control                                              |                    | I  12-2      |
|                                | 0  RMI                    | Select hl.9.h resolution (80x25) text                         |                    |              |
|                                | 1  RMI                    | Select_grai:i_hics mode                                       |                    |              |
|                                | 2  RMI                    | Select black/white mode                                       |                    |              |
|                                | 3  RMI                    | Enable video ou!Q_ut                                          |                    |              |
|                                | 4  RMI                    | Enable hig_h resolution (640x200)_mai:i_hics mode             |                    |              |
|                                | 5  RMI                    | Enable text blin kiri_g_                                      |                    |              |
|                                | 7-6  RMI                  | Reserved                                                      |                    |              |
| 309                            |                           | CGA Color Select                                              |                    | 12-3         |
|                                | 0  RMI                    | Select blue border                                            |                    |              |
|                                | 1  RMI                    | Select_meen border                                            |                    |              |
|                                | 2  RMI                    | Select red border                                             |                    |              |
|                                | 3  RMI                    | Select intensified border                                     |                    |              |
|                                | 4  RMI                    | Select bac~ound in a!Q_ha, hj_g_h 1ntens1!Y._in_g_rai:i_h1cs  |                    |              |
|                                | 5  RM/                    | Select color set 1n 320x200 mode                              |                    |              |
|                                | 7-6  RMI                  | Reserved                                                      |                    |              |
| 3DA                            |                           | CGAStatus                                                     |                    | 12-4         |
|                                | 0  R                      | Border/blankin_g_ active (horizontal ~c)                      |                    |              |
|                                | 1  R                      | Light_12_en latch trj_gg_ered                                 |                    |              |
Reserved = 1 (lig_ht_J:J_en switch ~en)
2  R
|      | 3  R    | Vertical ~nc active          |     |       |
| ---- | ------- | ---------------------------- | --- | ----- |
|      | 7-4  R  | Reserved                     |     |       |
| 308  |         | Reset L!.g_ht Pen Fll!.9_    |     | 12-5  |
|      | 7-0  w  | Reset lig_ht_12_en fl'!.9._  |     |       |
| 3DC  |         | Set L_i_g_ht Pen Fll!.9_     |     | 12-5  |
w
|             | 7-0      | Set lig_ht_12_en fl'!.9._  |     |     |
| ----------- | -------- | -------------------------- | --- | --- |
| •  9005049  | 0000942  | 298  •  --------------     |     |     |
A-2 REGISTER REFERENCE

••
r
Vision864 Graphics Accelerator
53 Incorporated
A.2  MD-AND HGC-COMPATIBLE REGISTERS
| Table A-2.  MDA-and HGC-Compatible Registers  |     |     |     |     |
| --------------------------------------------- | --- | --- | --- | --- |
Add
| Index         |                                                     |     | Register Name       | Description  |
| ------------- | --------------------------------------------------- | --- | ------------------- | ------------ |
| ress  B1t(s)  | R/W                                                 |     | Bit Descr!J2:1:1on  | P'!_g_e      |
| 385  10       | L!_g_ht Pen H!9_h                                   |     |                     | 12-1         |
| 5-0           | R  H_!g_h 6 bits of the !!£1.ht_Qen strobe address  |     |                     |              |
| 7-6           | R  Undefined                                        |     |                     |              |
| 385  11       | L!g_ht Pen Low                                      |     |                     | 12-1         |
| 7-0           | R  Low ~te of the l!.9_ht_Qen strobe address        |     |                     |              |
| 388           | MDA-Mode Control                                    |     |                     | 13-1         |
| 2-0           | RNV  Reserved                                       |     |                     |              |
| 3             | RNV  Enable video ou!Q_ut                           |     |                     |              |
| 4             | RNV  Reserved                                       |     |                     |              |
| 5             | RNV  Enable text blinkir:!.9_                       |     |                     |              |
| 7-6           | RNV  Reserved                                       |     |                     |              |
| 388           |                                                     |     |                     | 13-2         |
HGC-Mode Control
| 0    | RNV  Reserved                                         |     |     |       |
| ---- | ----------------------------------------------------- | --- | --- | ----- |
| 1    | RMI  Enable_£r~hics mode (720x348)                    |     |     |       |
| 2    | RMI  Reserved                                         |     |     |       |
| 3    | RMI  Enable video ou!Q_ut                             |     |     |       |
| 4    | RNV  Reserved                                         |     |     |       |
| 5    | RNV  Enable text bl1nki129._                          |     |     |       |
| 6    | RMI  Reserved                                         |     |     |       |
| 7    | RNV  Select Hercules_£r1!.12_h1cs v1deo~e 1( BBOOOH)  |     |     |       |
| 389  | HGC-Set L!9_ht Pen FIC!.9_                            |     |     | 13-3  |
w
| 7-0         | Set l!_g_ht_Q_en fl~                         |      |     |       |
| ----------- | -------------------------------------------- | ---- | --- | ----- |
| 38A         | HGC Status                                   |      |     | 13-3  |
| 0           | R  Border/blankil]l active (horizontal ~nc)  |      |     |       |
| 1           | R  L.!Qht_Qen fl~ on                         |      |     |       |
| 2           | R  Reserved= 1                               |      |     |       |
| 3           | R  Black/white video enabled                 |      |     |       |
| 6-4         | R  Reserved= 1                               |      |     |       |
| 7           | R  Vertical ~nc active                       |      |     |       |
| 38A         | MDA Status                                   |      |     | 13-4  |
| 0           | R  Border/blank active (horizontal ~nc)      |      |     |       |
| 2-1         | R  Reserved= 1                               |      |     |       |
| 3           | R  Black/white video enabled                 |      |     |       |
| 7-4         | R  Reserved= 1                               |      |     |       |
| .. 9005049  | 0000943                                      | 124  | ..  |       |
REGISTER REFERENCE  A-3

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Table A-2. MDA-and HGC-Compatible Registers (continued)
| Add  Index    |                           | Register Name      | Description  |
| ------------- | ------------------------- | ------------------ | ------------ |
| ress  B1t(s)  | R/W                       | Bit Descr_!Q!:ion  | Pl!.9._e     |
| 3BB           | Reset L!g_ht Pen Fll!.9_  |                    | 13-4         |
| 7-0           | w                         |                    |              |
Reset l_!g_ht_Q_en fl'!9_
| 3BF  | R/W  HGC Configuration      |     | 13-4  |
| ---- | --------------------------- | --- | ----- |
| 0    | w  Gra_Q_h1cs mode allowed  |     |       |
w
1  Unlock bit 7 of Hercules Mode r~ster (1.12Q_er mem~e)
w
7-2  Undefined
A.3  VGA REGISTERS
? = B for monochrome, D for color.
Table A-3.  VGA Registers
| Add  Index    |     | Register Name      | Description  |
| ------------- | --- | ------------------ | ------------ |
| ress  Bit(s)  |     | Bit Descr_!Q!:1on  | Pa__g_e      |
General or External Registers
| 3C2  | Miscellaneous Out~ut                      |     | 14-1  |
| ---- | ----------------------------------------- | --- | ----- |
| 0    | w  Color emulation. Address based at 3Dx  |     |       |
w
1  Enable CPU access of video memo__!Y_
w
3-2  Video (DCLK) select. See also bits 3-0 of CR42
| 4   | w  Reserved  |     |     |
| --- | ------------ | --- | --- |
w
5  Select the high 64K ~e of memo__!Y_
| 6    | w  Make HSYNC an active low sj_g_nal               |     |       |
| ---- | -------------------------------------------------- | --- | ----- |
| 7    | w  Make VSYNC an active low S.!.9_nal              |     |       |
| 3CC  | Miscellaneous Ou~ut                                |     | 14-1  |
| 0    | R  Color emulation. Address based at 3Dx           |     |       |
| 1    | R  Enable CPU access of video memo__!Y_            |     |       |
| 3-2  | R  Video (DCLK) select. See also bits 3-0 of CR42  |     |       |
| 4    | R  Reserved                                        |     |       |
| 5    | R  Select the hj_g_h 64K~e of memo__!Y_            |     |       |
| 6    | R  Make HSYNC an active low signal                 |     |       |
| 7    | R  Make VSYNC an active low sj_g_nal               |     |       |
| 37A  | Feature Control                                    |     | 14-2  |
w
2-0  Reserved
w
3  VSYNC is ORed with the internal disQlay_ enable s.!9._nal
| 7-4  | w  Reserved      |     |       |
| ---- | ---------------- | --- | ----- |
| 3CA  | Feature Control  |     | 14-2  |
| 2-0  | R  Reserved      |     |       |
3  R  VSYNC 1s ORed with the internal d1sQlay_ enable sjg_nal
| 7-4  | R  Reserved  |     |     |
| ---- | ------------ | --- | --- |
A-4 REGISTER REFERENCE

Vision864 Graphics Accelerator
53 Incorporated
Table A-3. VGA Registers (continued)
| Add  Index    |                   | Register Name     |     | Description  |
| ------------- | ----------------- | ----------------- | --- | ------------ |
| ress  Bit(s)  | R/W               | Bit DescriQ_tion  |     | Pl!.9._e     |
| 3C2           | ln_Q_ut Status O  |                   |     | 14-3         |
| 3-0           | R  Reserved       |                   |     |              |
4  R  The SENSE/BREO il")_Q_ut 1s a l~cal 1
| 6-5  | R  Reserved                                                 |     |     |       |
| ---- | ----------------------------------------------------------- | --- | --- | ----- |
| 7    | R  Vertical retrace 1nterrlJ{Jt to the CPU 1s .12_endin_g_  |     |     |       |
| 37A  | Input Status 1                                              |     |     | 14-3  |
0  R  The di~'!'{_ In not in active d1s_QI~ mode
| 1    | R  L_!g_ht_Q_en has been tn_g_g_ered                   |     |     |     |
| ---- | ------------------------------------------------------ | --- | --- | --- |
| 2    | R  Reserved                                            |     |     |     |
| 3    | R  Vertical retrace l2_eriod 1s active                 |     |     |     |
| 5-4  | R  Feedback of two color ou!2_uts for test_Q_urp_oses  |     |     |     |
| 7-6  | R  Reserved                                            |     |     |     |
Sl!_g__uencer Re_gisters
| 3C4  | Sl!_g__uencer Index                                |     |     | 14-4  |
| ---- | -------------------------------------------------- | --- | --- | ----- |
| 7-0  | RNlf  Index to the s~uencer r~ster to be accessed  |     |     |       |
| 3C5  | S~uencer Data                                      |     |     | 14-5  |
7-0  RNlf  Data to or from the accessed s~uencer r~ster accessed
| 3C5  00  | Reset (SRO)                                                |     |     | 14-5  |
| -------- | ---------------------------------------------------------- | --- | --- | ----- |
| 0        | RNlf  A~chronous reset (not functional for the Vision864)  |     |     |       |
| 1        | RNlf  ~nchronous reset (not functional for the Vision864)  |     |     |       |
| 7-2      | RNlf  Reserved                                             |     |     |       |
| 3C5  01  | Clocking_ Mode (SR1 l                                      |     |     | 14-6  |
| 0        | RNlf  Character clocks are 8 dots wide                     |     |     |       |
| 1        | RNlf  Reserved                                             |     |     |       |
2  RNlf  Load the video ser1al1zers ev~ second character clock
| 3   | RNlf  The internal dot clock 1s 1/2 the DCLK fr~uenc:y_  |     |     |     |
| --- | -------------------------------------------------------- | --- | --- | --- |
4  RNlf  Load the video senalizers ev~fourth character clock
| 5        | RNlf  Screen 1s turned off  |     |     |       |
| -------- | --------------------------- | --- | --- | ----- |
| 3C5  02  | Enable Write Plane (SR2l    |     |     | 14-6  |
3-0  RNlf  Enables a CPU write to the corre~ond1ng color _Qlane
| 7-4         | RNlf  Reserved                              |          |                     |       |
| ----------- | ------------------------------------------- | -------- | ------------------- | ----- |
| 3C5  03     | Character Font Select (SR3)                 |          |                     | 14-7  |
| 4, 1-0      | RNlf  Pnm~text mode character select        |          |                     |       |
| 5,3-2       | RNlf  Secondary text mode character select  |          |                     |       |
| 7-6         | RNlf  Reserved                              |          |                     |       |
| .. 9005049  | 0000945                                     | TT7  ..  | REGISTER REFERENCE  | A-5   |

Vision864 Graphics Accelerator
SJ Incorporated
Table A-3. VGA Registers (continued)
| Add   | Index   |                                                   | Register Name    | Description  |
| ----- | ------- | ------------------------------------------------- | ---------------- | ------------ |
|       | B1t(s)  |                                                   | Bit Descng_t1on  | Pa_g_e       |
| ress  | R/W     |                                                   |                  |              |
| 3C5   | 04      | Memo~ Mode Control (SR4}                          |                  | 14-8         |
|       | 0  RMI  | Reserved                                          |                  |              |
|       | 1  RMI  | Memo_iy_access to 256K allowed (r~u1red for VGA)  |                  |              |
2  RMI  S~uent1al addressiri_g_ for CPU video memC'.£'l accesses
3  RMI  Module 4 addressiri_g_for CUP video memo_iy_accesses
|      | 7-4  RMI  | Reserved                        |     |       |
| ---- | --------- | ------------------------------- | --- | ----- |
| 3C5  | 08        | Unlock Extended S~uencer (SR8l  |     | 14-9  |
|      | 7-0  RMI  | Load xxxx011 Ob to unlock SRD   |     |       |
14-9
| 3C5  | OD        | Extended S~uencer (SRO)                 |     |     |
| ---- | --------- | --------------------------------------- | --- | --- |
|      | 3-0  RMI  | Reserved                                |     |     |
|      | 5-4  RMI  | HSYNC control for Green PC r~uirements  |     |     |
|      | 7-6  RMI  | VSYNC control for Green PC r~u1rements  |     |     |
CRT Controller R~sters
| 374  |           | CRT Controller Index                       |     | 14-10  |
| ---- | --------- | ------------------------------------------ | --- | ------ |
|      | 7-0  RMI  | Index to the CRTC register to be accessed  |     |        |
| 375  |           | CRT Controller Data                        |     | 14-10  |
|      | 7-0  RMI  | Data to or from the CRTC r~ster accessed   |     |        |
| 375  | 00        | Horizontal Total {CRO)                     |     | 14-11  |
|      | 7-0  RMI  | Number of characters 1n a line -5          |     |        |
| 375  | 01        | Horizontal Di~qEnd (CR1l                   |     | 14-11  |
7-0  RMI  One less than the total number of d1~~ed characters
| 375  | 02   | Start Horizontal Blank (CR2)                       |     | 14-12  |
| ---- | ---- | -------------------------------------------------- | --- | ------ |
|      | 7-0  | Character count where horizontal blanking_ starts  |     |        |
RMI
| 375  | 03        | End Horizontal Blank (CR3)               |     | 14-12  |
| ---- | --------- | ---------------------------------------- | --- | ------ |
|      | 4-0  RMI  | End _Q_osition of horizontal blankin_g_  |     |        |
|      | 6-5       | D1~~ enable skew in character clocks     |     |        |
RMI
|      | 7  RMI  | Reserved                                  |     |        |
| ---- | ------- | ----------------------------------------- | --- | ------ |
| 375  | 04      | Start Horizontal S_ync Position (CR4}     |     | 14-13  |
|      | 7-0     | Character count where HSYNC_g_oes active  |     |        |
RMI
| 375  | 05        | End Horizontal ~nc Position (CR5)    |     | 14-13  |
| ---- | --------- | ------------------------------------ | --- | ------ |
|      | 4-0  RMI  | Pos1t1on where HSYNC_g_oes inactive  |     |        |
6-5
|             | RMI       | Horizontal retrace end del~1n character clocks  |     |        |
| ----------- | --------- | ----------------------------------------------- | --- | ------ |
|             | 7  RMI    | End horizontal blanking_ bit 5                  |     |        |
| 375         | 06        | Vertical Total (CR61                            |     | 14-14  |
|             | 7-0  RMI  | Number of lines -2                              |     |        |
| •  9005049  | 0000946   | 933  •  -------------                           |     |        |
A-6 REGISTER REFERENCE

••
r
Vision864 Graphics Accelerator
53 Incorporated
Table A-3. VGA Registers (continued)
| Add  Index    |                                    |     | Register Name    | Description  |
| ------------- | ---------------------------------- | --- | ---------------- | ------------ |
| ress  B1t(s)  | R/W                                |     | Bit Descr_i0ion  | Pl!.9_e      |
| 375  07       | CRTC Overflow (CR7l                |     |                  | 14-14        |
| 0             | RMI  Vertical total bit 8          |     |                  |              |
| 1             | RMI  Vertical d1~~ end bit 8       |     |                  |              |
| 2             | RMI  Vertical retrace start bit 8  |     |                  |              |
3
|          | RMI  Start vertical blank bit 8            |     |     |        |
| -------- | ------------------------------------------ | --- | --- | ------ |
| 4        | RMI  Line com__Q_are bit 8                 |     |     |        |
| 5        | RMI  Vertical total bit 9                  |     |     |        |
| 6        | RMI  Vertical d1~~ end bit 9               |     |     |        |
| 7        | RMI  Vertical retrace start bit 9          |     |     |        |
| 375  08  | Preset Row Scan (CR8l                      |     |     | 14-15  |
| 4-0      | RMI  Line where first character row b~ns   |     |     |        |
| 6-5      | RMI  Number of Qy!es to_Qan horizontal!Y_  |     |     |        |
7
|          | RMI  Reserved                                           |     |     |        |
| -------- | ------------------------------------------------------- | --- | --- | ------ |
| 375  09  | Maximum Scan Line (CR9l                                 |     |     | 14-15  |
| 4-0      | RMI  Character heJ.g_ht in scan lines -1                |     |     |        |
| 5        | RMI  Start vertical blank bit 9                         |     |     |        |
| 6        | RMI  Line com__Q_are bit 9                              |     |     |        |
| 7        | RMI  Double scanniri_g_ (r~eat each line) enabled       |     |     |        |
| 375  OA  | Cursor Start Scan Line (CRA)                            |     |     | 14-16  |
| 4-0      | RMI  Cursor start1ri_g_ line w1th1n the character cell  |     |     |        |
| 5        | RMI  Turns off the cursor                               |     |     |        |
7-6
|          | RMI  Reserved                                       |     |     |        |
| -------- | --------------------------------------------------- | --- | --- | ------ |
| 375  OB  | Cursor End Scan Line (CRB                           |     |     | 14-16  |
| 4-0      | RMI  Cursor end1Q9_ line w1th1n the character cell  |     |     |        |
| 6-5      | RMI  Cursor skew to i:!.9_ht 1n characters          |     |     |        |
| 7        | RMI  Reserved                                       |     |     |        |
| 375  QC  | Start Address H_!g_h (CRCJ                          |     |     | 14-17  |
| 7-0      | RMI  Bits 15-8 of the d1~§Y_ start address          |     |     |        |
| 375  OD  | Start Address Low (CRD)                             |     |     | 14-17  |
| 7-0      | RMI  Bits 7-0 of the d1~l§Y_ start address          |     |     |        |
375  OE  Cursor Location Address High (&Hardware Cursor  14-17
For~round Color in Enhanced Mode) (CREJ
7-0  RMI  Bits 15-8 of the cursor location start address  For 4/8 bit
Enhanced modes with an 8-b1t DAC. this spec1f1es the
hardware cursor for~ound color
3?5  OF  Cursor Location Address Low !& Hardware Cursor  14-18
Bac~ound Color in Enhanced Mode) (CRFJ
7-0  RMI  Bits 7-0 of the cursor location start address. For 4/8 bit
Enhanced modes with an 8-b1t DAC, this spec1f1es the
hardware cursor background color
| .. 9005049  | 0000947  | 87T  | ..  |     |
| ----------- | -------- | ---- | --- | --- |
REGISTER REFERENCE  A-7

=·
r
Vision864 Graphics Accelerator
S3 Incorporated
Table A-3. VGA Registers (continued)
| Add  Index    |         |                                                      | Register Name     | Description  |
| ------------- | ------- | ---------------------------------------------------- | ----------------- | ------------ |
| ress  B1t{s)  | R/W     |                                                      | Bit Descr12_t1on  | P1!.9.e      |
| 375  10       |         | Vertical Retrace Start (CR10                         |                   | 14-18        |
| 7-0           | RMI     | Vertical retrace start 1n scan lines                 |                   |              |
| 375  11       |         | Vertical Retrace End ICR11)                          |                   | 14-18        |
| 3-0           | RMI     | Vertical retrace end in scan lines                   |                   |              |
|               | 4  RMI  | Clear the vertical retrace interru_Q_t fl!Q:-flo_Q_  |                   |              |
|               | 5  RMI  | Disable vertical interrUB_ts                         |                   |              |
|               | 6  RMI  | Five RAM refresh 9'.'._cles_fl__er horizontal line   |                   |              |
|               | 7  RMI  | Lock writes to CRO-CR7                               |                   |              |
| 375  12       |         | Vertical DiSf'.>lq End ICR12)                        |                   | 14-19        |
| 7-0           | RMI     | Number of scan lines of active video                 |                   |              |
| 375  13       |         | Offset (CR13l                                        |                   | 14-20        |
7-0  RMI  Memq_ry_start addressJ_Um_fl__from one scan line to the next
| 375  14  |      | Underline Location (CR14)                    |     | 14-20  |
| -------- | ---- | -------------------------------------------- | --- | ------ |
| 4-0      | RMI  | Horizontal scan line where underline occurs  |     |        |
5  RMI  Memq_ry_ address counter increment 1s 4 character clocks
6
|          | RMI     | Memq_ry_ accessed as doublewords                         |     |        |
| -------- | ------- | -------------------------------------------------------- | --- | ------ |
|          | 7  RMI  | Reserved                                                 |     |        |
| 375  15  |         | Start Vertical Blank !CR15)                              |     | 14-21  |
| 7-0      | RMI     | Horizontal scan line where vertical blank1f!_f!_ starts  |     |        |
| 375  16  |         | End Vertical Blank ICR16                                 |     | 14-21  |
| 7-0      | RMI     | Horizontal scan line where vertical blanking_ ends       |     |        |
| 375  17  |         | CRTC Mode Control ICR17)                                 |     | 14-22  |
|          | 0  RMI  | Enable bank 2 mode for CGA emulation                     |     |        |
|          | 1  RMI  | Enable bank 4 mode for CGA emulation                     |     |        |
2
|             | RMI      | Use horizontal retrace clock divided by_ 2            |     |        |
| ----------- | -------- | ----------------------------------------------------- | --- | ------ |
|             | 3  RMI   | Enable count by_ 2 mode                               |     |        |
|             | 4  RMI   | Reserved                                              |     |        |
|             | 5  RMI   | Enable CGA mode address wra_Q_                        |     |        |
|             | 6  RMI   | Use ~e address mode                                   |     |        |
|             | 7  RMI   | Horizontal and vertical retrace sjg__nals enabled     |     |        |
| 375  18     |          | Line Com~are ICR18)                                   |     | 14-23  |
| 7-0         | RMI      | Line at which memory_ address counter cleared to 0    |     |        |
| 375  22     |          | CPU Latch Data ICR22)                                 |     | 14-24  |
| 7-0         | R        | Value in the CPU latch 1n the_g_r~h1cs controller     |     |        |
| 375  24,26  |          | Attribute Controller Fla__gjlndex                     |     | 14-24  |
| 5-0         | R        | Value of the attribute controller index data at 3COH  |     |        |
|             | 6  R     | Reserved                                              |     |        |
|             | 7  R     | State of inverted internal address flip-flop          |     |        |
| .. 9005049  | 0000948  | 706  ..                                               |     |        |
A-8 REGISTER REFERENCE

Vision864 Graphics Accelerator
53 Incorporated
Table A-3. VGA Registers (continued)
| Add  Index    |      | Register Name      | Description  |
| ------------- | ---- | ------------------ | ------------ |
| ress  B1t(s)  | R/W  | Bit Descrlj)_tion  | Pl!.9._e     |
Graphics Controller Registers
| 3CE  | Gr'!J>_hics Controller Index  |     | 14-25  |
| ---- | ----------------------------- | --- | ------ |
3-0  RNV  Index to theJ [CJQ_h1cs controller r~ster to be accessed
| 7-4  | RNV  Reserved                |     |        |
| ---- | ---------------------------- | --- | ------ |
| 3CF  | Gr'!J>_hics Controller Data  |     | 14-25  |
7-0  RNV  Data to or from theJ [CJQ_hics controller r~ster accessed
| 3CF  00  | Set/Reset (GRO)                               |     | 14-26  |
| -------- | --------------------------------------------- | --- | ------ |
| 3-0      | RNV  Color value for CPU memo...!Y_ writes    |     |        |
| 7-4      | RNV  Reserved                                 |     |        |
| 3CF  01  | Enable Set/Reset (GR1)                        |     | 14-26  |
| 3-0      | RNV  Enable _Qian es for wnt11"!.9_ GRO data  |     |        |
| 7-4      | RNV  Reserved                                 |     |        |
| 3CF  02  | Color Com_!!_are (GR2)                        |     | 14-27  |
Reference color for color com_Qare o_Qerations
| 3-0      | RNV                                       |     |        |
| -------- | ----------------------------------------- | --- | ------ |
| 7-4      | RNV  Reserved                             |     |        |
| 3CF  03  | Raster O_!!_eration/Rotate Counter (GR3)  |     | 14-27  |
2-0  RNV  Number of r!f!_ht rotate _Q_osit1ons for a CPU memq_ry_ write
| 4-3  | RNV  Select raster C!Q_eration (l~cal function)  |     |     |
| ---- | ------------------------------------------------ | --- | --- |
| 7-5  | RNV  Reserved                                    |     |     |
14-28
| 3CF  04     | Read Plane Select (GR4)                            |          |        |
| ----------- | -------------------------------------------------- | -------- | ------ |
| 1-0         | RNV  Select_Qlanes for read1f!.9_                  |          |        |
| 7-2         | RNV  Reserved                                      |          |        |
| 3CF  05     | Gra_Jl_hics Controller Mode IGR5)                  |          | 14-29  |
| 1-0         | RNV  Select write mode                             |          |        |
| 2           | RNV  Reserved                                      |          |        |
| 3           | RNV  Enable read com29re o_Qerat1on                |          |        |
| 4           | RNV  Select odd/even address1ri_g_                 |          |        |
| 5           | RNV  Select odd/even shift mode                    |          |        |
| 6           | RNV  Select 256 color shift mode                   |          |        |
| 7           | RNV  Reserved                                      |          |        |
| 3CF  06     | Memo".'l_M'!l>_Mode Control (GR6)                  |          | 14-30  |
| 0           | RNV  Select_f[a_g_h1cs mode memq_ry_ address1n_g_  |          |        |
| 1           | RM!  Chain odd/even _Qian es                       |          |        |
| 3-2         | RNV  Select memq_ry_ maQQi!"!.9_                   |          |        |
| 7-4         | RNV  Reserved                                      |          |        |
| 3CF  07     | Color Don't Care (GR7)                             |          | 14-31  |
| 3-0         | RNV  Select color_Qlane used for color com29rison  |          |        |
| 7-4         | RNV  Reserved                                      |          |        |
| .. 9005049  | 0000949                                            | 642  ..  |        |
REGISTER REFERENCE  A-9

Vision864 Graphics Accelerator
S3 Incorporated
Table A-3. VGA Registers (continued)
| Add   | Index        |                 | Register Name     | Description  |
| ----- | ------------ | --------------- | ----------------- | ------------ |
| ress  | B1t(s)  R/W  |                 | Bit Descr!Q1:1on  | P'!..!l_e    |
| 3CF   | 08           | Bit Mask (GR8J  |                   | 14-31        |
7-0  RNI/  Each bit 1s a mask for the corresfJond1Qg_ memory_~ane bit
Attribute R~sters
| 3CO  |     | Attribute Controller Index  |     | 14-32  |
| ---- | --- | --------------------------- | --- | ------ |
4-0  RNI/  Index to the attribute controller r~ster to be accessed
|        | 5  RNI/    | Enable video d1s_QI~       |     |        |
| ------ | ---------- | -------------------------- | --- | ------ |
|        | 7-6  RNI/  | Reserved                   |     |        |
| 3C1/0  |            | Attribute Controller Data  |     | 14-33  |
7-0  RNI/  Data to or from the attribute controller r~ster accessed
| 3C1/0  | 00-0F  | Palette R~ster (ARO-ARFJ  |     | 14-33  |
| ------ | ------ | ------------------------- | --- | ------ |
|        | 5-0    | Color value               |     |        |
RNI/
|        | 7-6  RNI/  | Reserved                               |     |        |
| ------ | ---------- | -------------------------------------- | --- | ------ |
| 3C1/0  | 10         | Attribute Mode Control (AR10           |     | 14-34  |
|        | 0  RNI/    | Select_g_ra_.12._hics mode             |     |        |
|        | 1  RNI/    | Select monochrome d1~~                 |     |        |
|        | 2  RNI/    | Enable line_ g_rll_fl_h1cs characters  |     |        |
|        | 3          | Enable bl1nk11l9_                      |     |        |
RNI/
|     | 4  RNI/  | Reserved                   |     |     |
| --- | -------- | -------------------------- | --- | --- |
|     | 5  RNI/  | Enable t<2.12.._2_ann1Qg_  |     |     |
Select 256 color mode
6  RNI/
|        | 7  RNI/    | Bits 5-4 of video ou!Q_ut come from AR14 1-0       |     |        |
| ------ | ---------- | -------------------------------------------------- | --- | ------ |
| 3C1/0  | 11         | Border Color (AR11)                                |     | 14-35  |
|        | 7-0  RNI/  | Border color value                                 |     |        |
| 3C1/0  | 12         | Color Plane Enable (AR12J                          |     | 14-35  |
|        | 3-0  RNI/  | Di~~ane enable                                     |     |        |
|        | 5-4  RNI/  | Select in_12uts to bits 5-4 of 3?AH                |     |        |
|        | 7-6  RNI/  | Reserved                                           |     |        |
| 3C1/0  | 13         | Horizontal Pixel Panni'!9_ (AR13)                  |     | 14-36  |
|        | 3-0  RNI/  | Number of__12_1xels to shift the d1~~ to the left  |     |        |
|        | 7-4  RNI/  | Reserved                                           |     |        |
| 3C1/0  | 14         | Pixel Paddi'!9_ (AR14J                             |     | 14-37  |
|        | 1-0  RNI/  | Bits 5-4 of the video oum_ut if AR10 7 = 1         |     |        |
|        | 3-2  RNI/  | Bits 7-6 of the video outQ_ut                      |     |        |
|        | 7-4  RNI/  | Reserved                                           |     |        |
Setl!e__ R~sters
| 102  |          | Set!!e__ O__p_tion Select                        |     | 14-38  |
| ---- | -------- | ------------------------------------------------ | --- | ------ |
|      | 0  RNI/  | Ch!..12_re~onds to commands, addresses and data  |     |        |
7-1
|             | RNI/     | Reserved  |     |     |
| ----------- | -------- | --------- | --- | --- |
| .. 9005049  | 0000950  | 364  ..   |     |     |
A-10 REGISTER REFERENCE

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Table A-3. VGA Registers (continued)
| Add  Index    |                       |           | Register Name    |     | Description  |
| ------------- | --------------------- | --------- | ---------------- | --- | ------------ |
| ress  Bit(s)  | R/W                   |           | Bit Descn[Jt1on  |     | Pag_e        |
| 46E8          | Video Submtem Enable  |           |                  |     | 14-39        |
| 2-0           | w                     | Reserved  |                  |     |              |
w
| 3   |     | Enable video 1/0 and memo...!Y_ address decodin_g_  |     |     |     |
| --- | --- | --------------------------------------------------- | --- | --- | --- |
w
| 4   |     | Put ch1_2._ in setl!Q_ mode  |     |     |     |
| --- | --- | ---------------------------- | --- | --- | --- |
7-5  w
Reserved
RAMDAC R~sters
| 3C6  | DACMask  |     |     |     | 14-40  |
| ---- | -------- | --- | --- | --- | ------ |
7-0
|      | R/W             | Pixel read mask  |     |     |        |
| ---- | --------------- | ---------------- | --- | --- | ------ |
| 3C7  | DAC Read Index  |                  |     |     | 14-40  |
w
| 7-0  |             | Index to _Q_alette r~ster to be read  |     |     |        |
| ---- | ----------- | ------------------------------------- | --- | --- | ------ |
| 3C7  | DAC Status  |                                       |     |     | 14-41  |
1-0  R  Shows whether_Qrev1ous DAC 9'._Cle was a read or write
| 7-2  | R                | Reserved  |     |     |        |
| ---- | ---------------- | --------- | --- | --- | ------ |
| 3C8  | DAC Write Index  |           |     |     | 14-41  |
7-0  R/W  Index to palette register to be written or General Input Port
read data
| 3C9  | DAC Data  |     |     |     | 14-42  |
| ---- | --------- | --- | --- | --- | ------ |
7-0  Data from register pointed to by DAC Read or Write Index
R/W
| .. 9005049  | 0000951  | 2TO  ..  |     | REGISTER REFERENCE  | A-11  |
| ----------- | -------- | -------- | --- | ------------------- | ----- |

Vision864 Graphics Accelerator
53 Incorporated
A.4 S3 VGA REGISTERS
The Vision864 has additional registers to extend the functions of basic VGA. These registers are located
in CRT Controller address space at locations not used by IBM. All of these registers are read/write
protected at power-up by hardware reset. In order to read/write these registers, the Register Lock 1
register (CR38) must be loaded with a binary unlock key pattern (see the register description). The
registers will remain unlocked until the key pattern is reset. ? = B for monochrome, D for color.
The additional VGA registers are described in the following table:
| Table A-4.  | S3 VGA Registers  |                                                             |                  |              |
| ----------- | ----------------- | ----------------------------------------------------------- | ---------------- | ------------ |
| Add         | Index             |                                                             | Register Name    | Description  |
|             | B1t(s)            |                                                             |                  | Page         |
| ress        | R/W               |                                                             | Bit Description  |              |
| 375         | 30                | Ch!.!?._ ID/Rev ICR30)                                      |                  | 15-1         |
|             | 3-0  R            | Ch.!Q_rev1sion status (st~~                                 |                  |              |
|             | 7-4  R            | Ch.!Q_ Identification                                       |                  |              |
| 375         | 31                | Mem~ Configuration (CR311                                   |                  | 15-1         |
|             | 0  RNV            | Enable base address offset (CR6A 6-0)                       |                  |              |
|             | 1  RNV            | Enable two~e screen 1m~e                                    |                  |              |
|             | 2  RNV            | Enable VGA 16-Bit Mem~Bus Width                             |                  |              |
|             | 3  RNV            | Use Enhanced mode mem~m~r:!.9._                             |                  |              |
|             | 5-4  RNV          | Old di~~ start address bits 17-16 (see CR69_3-0)            |                  |              |
|             | 6  RNV            | Enable h_ig_h ~eed text d1~~font fetch mode                 |                  |              |
|             | 7  RNV            | Reserved                                                    |                  |              |
| 375         | 32                | Backward Com_£.atibility 1 (CR32)                           |                  | 15-2         |
|             | 1-0  RNV          | Force 7 or 9 dot clocks/character clock                     |                  |              |
|             | 2  RNV            | Force character clock to h.!.9_h rate (not 1/ 2 dot clock)  |                  |              |
3  RNV  Enable backward com_Q_at1b1l1!1'._ modes (CGA, MDA, HGC)
|     | 5-4  RNV  | Reserved  |     |     |
| --- | --------- | --------- | --- | --- |
6  RNV  Use standard VGA memo...!}'._ wr8_2211!9_ at 256K bound'!!}'._
|      | 7  RNV  | Reserved                           |     |       |
| ---- | ------- | ---------------------------------- | --- | ----- |
| 375  | 33      | Backward Co"!E_atibility 2 (CR33)  |     | 15-3  |
|      | 0  RNV  | Reserved                           |     |       |
1  RNV  Disable wnte_Qrotect1on_Qrov1ded i2Y_ CR11_7 on CR7_1,6
|     | 2  RNV  | Reserved                                      |     |     |
| --- | ------- | --------------------------------------------- | --- | --- |
|     | 3  RNV  | VCLK is inverted DCLK                         |     |     |
|     | 4  RNV  | Disable writes to RAMDAC r~sters (3C6H-3C9H)  |     |     |
5  RNV  BLANK S.!.9_nal active duri1!9_ entire non-active video _Q_eriod
|             | 6  RNV   | Disable wntes to Palette/Overscan r~sters (ARO-ARF)  |     |     |
| ----------- | -------- | ---------------------------------------------------- | --- | --- |
|             | 7  RNV   | Override 3D8H_3 video enable to el1m1nate flicker    |     |     |
| •  9005049  | 0000952  | 137  •  --------------                               |     |     |
A-12 REGISTER REFERENCE

Vision864 Graphics Accelerator
SJ Incorporated
Table A-4. 53 VGA Registers (continued)
| Add  Index    |                                                          |     | Register Name  |     | Description  |
| ------------- | -------------------------------------------------------- | --- | -------------- | --- | ------------ |
| ress  B1t(s)  | R/W                                                      |     | Bit Descr~1on  |     | Pa_g_e       |
| 375  34       | Backward Com_E_atibili!Y_ 3 (CR34)                       |     |                |     | 15-4         |
| 3-0           | RNV  Reserved                                            |     |                |     |              |
| 4             | RNV  Enable Dl~§Y_ Start FIFO Fetch r~ster (CR3B)        |     |                |     |              |
| 5             | RNV  Lock SR 1 0 to fix selection of 8/9 dots/character  |     |                |     |              |
| 6             | RNV  Reserved                                            |     |                |     |              |
| 7             | RNV  Lock 3C2H_3-2 to fix DCLK fr~uen9'._                |     |                |     |              |
| 375  35       | CRT R~ster Lock (CR35)                                   |     |                |     | 15-5         |
| 3-0           | RNV  Old CPU base address (see CR6A_6-0)                 |     |                |     |              |
| 4             | RNV  Lock Vertical T1m1ng_ r~sters                       |     |                |     |              |
| 5             | RNV  Lock Horizontal T1m1ri_g_r~sters                    |     |                |     |              |
| 7-6           | RNV  Reserved                                            |     |                |     |              |
| 375  36       | Conf.!9._uration 1 (CR36)                                |     |                |     | 15-7         |
| 1-0           | R  Select ~stem bus (PCI or VL-Bus)                      |     |                |     |              |
| 3-2           | RNV  Select Mem~e mode (fas~e or EDO)                    |     |                |     |              |
| 4             | RNV  Enable BIOS ROM accesses (VL-Bus)                   |     |                |     |              |
7-5
|          | RNV  Define d1~l§Y_ memory size            |     |     |     |       |
| -------- | ------------------------------------------ | --- | --- | --- | ----- |
| 375  37  | Conf.!9._uration 2 (CR37)                  |     |     |     | 15-7  |
| 0        | RNV  Enable V1s1on864 QQ_erat1on (VL-Bus)  |     |     |     |       |
| 1        | Enable test mode (ou!Q_uts tri-stated)     |     |     |     |       |
RNV
| 2        | RNV  Select 32K or 64K BIOS ROM size           |     |     |     |       |
| -------- | ---------------------------------------------- | --- | --- | --- | ----- |
| 3        | RNV  Select dual CAS or dual WE DRAMs          |     |     |     |       |
| 4        | RNV  Define RAMDAC write snOQP_IQ.9_ (VL-Bus)  |     |     |     |       |
| 7-5      | RNV  ~ecify_ monitor information               |     |     |     |       |
| 375  38  | R~ster Lock 1 (CR38)                           |     |     |     | 15-9  |
| 7-0      | RNV  Unlock S3 VGA r~sters (CR30-CR3C)         |     |     |     |       |
| 375  39  | R~ster Lock 2 (CR39)                           |     |     |     | 15-9  |
7-0  RNV  Unlock System Control, System Extension and Strapping
r~sters (CR40-CR4F, CR50-CR6D)
| 375  3A     | Miscellaneous 1 !CR3A)                                     |          |     |                     | 15-10  |
| ----------- | ---------------------------------------------------------- | -------- | --- | ------------------- | ------ |
| 1-0         | RNV  Select alternate refresh count_Jl_er horizontal line  |          |     |                     |        |
| 2           | RNV  Enable alternate refresh count (CR3A_ 1-0)            |          |     |                     |        |
| 3           | RNV  Enable simultaneous VGA text and Enhanced modes       |          |     |                     |        |
| 4           | RNV  Enable 8-, 16-or 24/32-bit color Enhanced modes       |          |     |                     |        |
| 5           | RNV  Enable h_ig_h ~eed text font writing_                 |          |     |                     |        |
| 6           | RNV  Reserved                                              |          |     |                     |        |
| 7           | RNV  Disable PCI bus read burst cycles                     |          |     |                     |        |
| .. 9005049  | 0000953                                                    | 073  ..  |     | REGISTER REFERENCE  | A-13   |

••
r
Vision864 Graphics Accelerator
S3 Incorporated
Table A-4. S3 VGA Registers (continued)
| Add  Index    |                                    |     | Register Name     | Description  |
| ------------- | ---------------------------------- | --- | ----------------- | ------------ |
| ress  Bit(s)  | R/W                                |     | Bit DescnfJ_t1on  | Pag_e        |
| 375  38       | Start Dis}!lay_ FIFO Fetch !CR3BJ  |     |                   | 15-11        |
7-0  R/IN  ~ec1fy_ start of d1~~FIFO fetches for screen refresh11")_9_
| 375  3C  | Interlace Retrace Start (CR3CJ  |                                                 |     | 15-11  |
| -------- | ------------------------------- | ----------------------------------------------- | --- | ------ |
| 7-0      | R/IN                            | Specify interlaced mode retrace start position  |     |        |
A.5 SYSTEM CONTROL REGISTERS
System Control registers are configuration registers, mode control registers, and hardware graphics
cursor control registers. They are positioned in the same indexed register space as VGA S3 registers.
All of these registers are read/write protected at power-up by hardware reset. In order to read/write
these registers, the Register Lock 2 register (CR39) must be loaded with a binary unlock key pattern
(see the register description}. The registers will remain unlocked until the key pattern is reset. ? = B for
monochrome, D for color.
The following table summarizes the System Control registers.
| Table A-5.  System Control Registers  |          |                                             |                  |              |
| ------------------------------------- | -------- | ------------------------------------------- | ---------------- | ------------ |
| Add  Index                            |          |                                             | Register Name    | Description  |
| ress  Bit(s)                          | R/W      |                                             | Bit Descr_!01on  | Pag_e        |
| 375  40                               |          | System Conf!g_uration (CR40)                |                  | 16-1         |
|                                       | 0  R/IN  | Enable Enhanced mode re_gister access       |                  |              |
| 3-1                                   | R/IN     | Reserved                                    |                  |              |
|                                       | 4  R/IN  | Reac:!l'._ Control (VL-Bus)                 |                  |              |
|                                       | 5  R/IN  | Select write data latch t1m11")_g_(VL-Bus}  |                  |              |
7-6  R/IN  Select AID bus turnaround non-over!~ t1m11")_9_ (VL-Bus)
| 375  41       |          | BIOS Flag_(CR41J                    |     | 16-2  |
| ------------- | -------- | ----------------------------------- | --- | ----- |
| 7-0           | R/IN     | Used l2Y_ the video BIOS            |     |       |
| 375  42       |          | Mode Control (CR42)                 |     | 16-2  |
| 3-0           | R/IN     | DCLK select when 3C2H 3-2 are 11 b  |     |       |
|               | 4  R/IN  | Reserved                            |     |       |
|               | 5  R/IN  | Select Interlaced mode              |     |       |
|               | 6  R/IN  | Reserved                            |     |       |
| Ill  9005049  | 0000954  | TOT  Ill~~~~~~~~~~~~~~              |     |       |
A-14 REGISTER REFERENCE

••
r
Vision864 Graphics Accelerator
53 Incorporated
Table A-5. System Control Registers (continued)
Add Index Register Name Description
ress B1t{s) R/W Bit Descr1]2tion P1!9._e
375 43 Extended Mode (CR43l 16-3
0 R/VV Select 16 bitslQ!xel double-eclg_e clock1n_g_
1 R/VV Old DAC r~ster select bit 2
2 R/VV Old 1'29._lcal screen width bit 8
3 R/VV Reserved
4 R/VV Enable 1/0 _g__ort accesses at x148H
6-5 R/VV Reserved
7 R/VV Enable horizontal counter double mode
375 45 Hardware Gra_i>_hics Cursor Mode (CR45) 16-3
0 R/VV Enable hardware__9!~hics cursor
1 R/VV Reserved
3-2 R/VV Select hardware cursor color d~th
4 R/VV Set LJQ_ ~ace at r_!Rht of bit m~ for hardware cursor
7-5 R/VV Reserved
375 46-47 Hardware Gra_i>_hics Cursor Origin-X (CR46-CR47) 16-4
10-0 R/VV X-coord1nate of the hardware cursor left side
15-11 R/VV Reserved
375 48-49 Hardware Gra~hics Cursor Origin-Y (CR48-CR49) 16-5
10-0 R/VV Y-coord1nate of the hardware cursor ll_flQ_er line
15-11 R/VV Reserved
375 4A Hardware Gra_i>_hics Cursor Fore_g_round Stack (CR4Al 16-5
7-0 R/VV Hardware cursor for~ound color (4 r~sters)
375 48 Hardware Gra_i>_hics Cursor Bac~ound Stack (CR4B) 16-6
7-0 R/VV Hardware cursor baclsg_round color (4 r~sters)
375 4C-4D Hardware Gra_i>_hics Cursor Start Address (CR4C-CR4Dl 16-6
12-0 R/VV Hardware cursor start address
15-13 R/VV Reserved
3?5 4E Hardware Graphics Cursor Pattern Display Start X-Pixel 16-7
Position (CR4El
5-0 R/VV Hardware cursor d1~~start x-coordinate
7-6 R/VV Reserved
3?5 4F Hardware Graphics Cursor Pattern Display Start Y-Pixel 16-7
Position (CR4Fl
5-0 R/VV Hardware cursor d1~~ start..Y:coord1nate
7-6 R/VV Reserved
.. 9005049 0000955 946 ..
REGISTER REFERENCE A-15

=·
r  Vision864 Graphics Accelerator
S3 Incorporated
A.6  SYSTEM EXTENSION REGISTERS
These registers provide extended system and memory control, external sync control and addressing
window control. They are enabled in the same way as the System Control registers via the Register
Lock 2 register {CR39). ? = B for monochrome, D for color.
| Table A-6.  | System Extension Registers  |                               |                    |              |
| ----------- | --------------------------- | ----------------------------- | ------------------ | ------------ |
| Add         | Index                       |                               | Register Name      | Description  |
| dress       | Bit{s)  R/W                 |                               | Bit Descr!J2!:1on  | Pa_g_e       |
| 375         | 50                          | Extended S~tem Cont 1 {CR50)  |                    | 17-1         |
0  RMI  Most s_!g_n1f1cant bit of screen width def1nit1on {see bits 7-6)
|      | 1  RMI    | Reserved                                            |     |       |
| ---- | --------- | --------------------------------------------------- | --- | ----- |
|      | 2  RMI    | Enable shared frame buffer memory_ bus arbitration  |     |       |
|      | 3  RMI    | Reserved                                            |     |       |
|      | 5-4  RMI  | Pixel len_g_th select                               |     |       |
|      | 7-6  RMI  | With bit 0, screen width definition                 |     |       |
| 375  | 51        | Extended System Cont 2 {CR51)                       |     | 17-2  |
|      | 1-0  RMI  | Old d1sjllay_ start address bits 19-18              |     |       |
|      | 3-2       | Old CPU base address bits 1 9-18                    |     |       |
RMI
|      | 5-4  RMI  | LC291cal screen width bits 9-8  |     |       |
| ---- | --------- | ------------------------------- | --- | ----- |
|      | 7-6  RMI  | Reserved                        |     |       |
| 375  | 52        | Extended BIOS Fl!!.9_ 1 {CR52)  |     | 17-3  |
|      | 7-0  RMI  | Used ~the video BIOS            |     |       |
| 375  | 53        | Extended Mem~C ont 1 (CR53)     |     | 17-3  |
Enable write_ Qer bit
0  RMI
|     | 3-1  RMI  | Reserved                         |     |     |
| --- | --------- | -------------------------------- | --- | --- |
|     | 4  RMI    | Enable memo_!Y::m~ed 1/0 access  |     |     |
Reserved
5  RMI
|     | 6  RMI  | Enable nibble swa_i:i_         |     |       |
| --- | ------- | ------------------------------ | --- | ----- |
|     | 7  RMI  | Reserved                       |     |       |
|     | 54      | Extended Memory Cont 2 (CR54)  |     | 17-4  |
375
|      | 2-0  RMI  | Reserved                     |     |       |
| ---- | --------- | ---------------------------- | --- | ----- |
|      | 7-3  RMI  | S_Q_ec1fy_ M__29rameter      |     |       |
|      |           | Extended DAC Control (CR55J  |     | 17-4  |
| 375  | 55        |                              |     |       |
1-0  RMI  DAC r~ster select bit 2 if set to 1. otherwise use CR43 1
|             | 2  RMI    | Enable General Input Port read            |                |     |
| ----------- | --------- | ----------------------------------------- | -------------- | --- |
|             | 3  RMI    | Reserved                                  |                |     |
|             | 4  RMI    | Enable X-11 windows hardware cursor mode  |                |     |
|             | 6-5  RMI  | Reserved                                  |                |     |
|             | 7  RMI    | VCLK output pin is tri-stated             |                |     |
| •  9005049  | 0000956   | 882  •                                    | -------------- |     |
A-16 REGISTER REFERENCE

=·
r
Vision864 Graphics Accelerator
53 Incorporated
Table A-6. System Extension Registers (continued)
| Add  Index    |                               |     | Register Name      | Description  |
| ------------- | ----------------------------- | --- | ------------------ | ------------ |
| ress  B1t(s)  | R/W                           |     | Bit Descr!)2!:1on  | Pl!S_e       |
| 375  56       | External S_ync Cont 1 (CR56J  |     |                    | 17-5         |
0  RNV  Enable remote mode qQ_erat1on _(g_enlock1Qgj
2-1  RNV  Reserved
3  RNV  Select vertical counter-onjy_reset ~nc with_ g_enlock1ri_g_
4  RNV  Select odd frame after a vertical counter reset
5  RNV  HSYNC, VSYNC and BLANK become tri-state off
7-6  RNV  Reserved
| 375  57  | External ~nc Cont 2 (CR57)  |     |     |     |
| -------- | --------------------------- | --- | --- | --- |
17-6
3-0  RNV  Vertical reset a<]_ustment from falliri_g_ eci_g_e of VSYNC
7-4  RNV  Horizontal reset ad1ustment from fallif!..9. ecl_g_e of VSYNC
| 375  58  | Linear Address Window Control (CR58J  |     |     | 17-6  |
| -------- | ------------------------------------- | --- | --- | ----- |
1-0  RNV  Linear address1Qg_ window size
2  RNV  Reserved
Address latch t1m1ri_g_ control (VL-Bus)
3  RNV
4  RNV  Enable linear addressiri_g_
7-5  RNV  Reserved
| 375  59-5A  | Linear Address Window Position (CR59-5AJ  |     |     | 17-7  |
| ----------- | ----------------------------------------- | --- | --- | ----- |
15-0  RNV  Linear addressiri_g_ window_ Q_os1t1on bits 31-16
| 375  5B  | Extended BIOS Fli!.9_ 2 !CR5BJ  |     |     | 17-8  |
| -------- | ------------------------------- | --- | --- | ----- |
7-0  RNV  Used i2Y_ the video BIOS
| 375  5C  | General Out Port ICR5CJ  |     |     | 17-8  |
| -------- | ------------------------ | --- | --- | ----- |
3-0  R  Reflection of content of CR42 3-0 (DCLK select bits)
7-4  RNV  General Ou12_ut Port
| 375  50  | Extended Horizontal Overflow !CR50)  |     |     | 17-9  |
| -------- | ------------------------------------ | --- | --- | ----- |
0  RNV  Horizontal total bit 8 (CRO)
1  RNV  Horizontal di~~ end bit 8 (CR1)
2  RNV  Start horizontal blank bit 8 (CR2)
3  RNV  BLANK_Q_ulse extended~ 64 DCLKs
4  RNV  Start horizontal ~nc_Q_os1tion bit 8 (CR4)
5  RNV  HSYNC_Q_ulse extended i2Y_ 32 DCLKs
6  RNV  Start FIFO Fetch bit 8 (CR3B)
7  RNV  Bus grant terminate pos1t1on bit 8 (CR5F)
| .. 9005049  | 0000957  | 719  ..  |     |     |
| ----------- | -------- | -------- | --- | --- |
REGISTER REFERENCE  A-17

••
r  Vision864 Graphics Accelerator
53 Incorporated
Table A-6. System Extension Registers (continued)
|     | Add   | Index        |                                    | Register Name    | Description  |
| --- | ----- | ------------ | ---------------------------------- | ---------------- | ------------ |
|     | ress  | B1t(s)  R/W  |                                    | Bit Descr_i01on  | P1!9_e       |
|     | 37S   | SE           | Extended Vertical Overflow (CRSEI  |                  | 17-9         |
Vertical total bit 10 (CR6)
|     |      | 0  RNJ  |                                        |           |        |
| --- | ---- | ------- | -------------------------------------- | --------- | ------ |
|     |      | 1  RNJ  | Vertical dis_Qlciy_ end bit 1O         |  (CR 12)  |        |
|     |      | 2  RNJ  | Start vertical blank bit 1O(CR15)      |           |        |
|     |      | 3  RNJ  | Reserved                               |           |        |
|     |      | 4  RNJ  | Vertical retrace start bit 1O          |  (CR1 OJ  |        |
|     |      | 5  RNJ  | Reserved                               |           |        |
|     |      | 6  RNJ  | Line com_£are _Q_os1t1on bit 1O(CR18)  |           |        |
|     |      | 7  RNJ  | Reserved                               |           |        |
|     | 37S  | SF      | Bus Grant Termination Position (CRSFI  |           | 17-10  |
7-0  RNJ  Term1nat1on. .£.Os1t1on 1n character clocks for BGNT s_i_g_nal
|     | 37S  | 60        | Extended Memory_ Control 3 (CR60)                    |     | 17-10  |
| --- | ---- | --------- | ---------------------------------------------------- | --- | ------ |
|     |      | 7-0  RNJ  | ~ec1f'i N _Q_arameter                                |     |        |
|     | 37S  | 61        | Extended Memory Control 4 (CR611                     |     | 17-11  |
|     |      | 2-0  RNJ  | ~ec1f'i bits 10-8 of the L_JJarameter (CR62)         |     |        |
|     |      | 6-3  RNJ  | Reserved                                             |     |        |
|     |      | 7  RNJ    | Enable d1~ciy_fetch len_g_th (L_ £arameter) control  |     |        |
|     | 37S  | 62        | Extended Memory_ Control S (CR62)                    |     | 17-11  |
|     |      | 7-0  RNJ  | ~ec1f'i bits 7-0 of the L _Q_arameter                |     |        |
|     | 37S  | 63        | External ~nc DelqA <[ust Hj_g_h (CR63J               |     | 17-12  |
|     |      | 3-0  RNJ  | VSYNC reset aqiustment -UQQ_er 4 bits                |     |        |
|     |      | RNJ       | HSYNC reset adjustment -UQQ_er 4 bits                |     |        |
|     | 37S  | 64        | Genlocki'!9_ Adlustment (CR64)                       |     | 17-12  |
|     |      | 2-0  RNJ  | Horizontal counter dot add1t1on aqiustment           |     |        |
|     |      | 3  RNJ    | Enable for bits 2-0                                  |     |        |
|     |      | 6-4  RNJ  | Character clock _Q_hase ac!l_ustment                 |     |        |
|     |      | 7  RNJ    | Enable for bits 6-4                                  |     |        |
|     | 37S  | 6S        | Extended Miscellaneous Control (CR6SJ                |     | 17-13  |
|     |      | 1-0  RNJ  | Reserved                                             |     |        |
|     |      | 2  RNJ    | Enable 3C3H _£Ort for video sub~stem setll_l2_       |     |        |
|     |      | 7-3       | Reserved                                             |     |        |
RNJ
|     | 37S  | 66        | Extended Miscellaneous Control 1 (CR661  |     | 17-13  |
| --- | ---- | --------- | ---------------------------------------- | --- | ------ |
|     |      | 2-0  RNJ  | VCLK = fractions of DCLK                 |     |        |
|     |      | 5-3       | Reserved                                 |     |        |
RNJ
|     |          | 6  RNJ   | PA[15·0J are tn-stated off  |     |     |
| --- | -------- | -------- | --------------------------- | --- | --- |
|     |          | 7  RNJ   | Enable PCI bus disconnect   |     |     |
| •   | 9005049  | 0000958  | 655  •  ---------------     |     |     |
A-18 REGISTER REFERENCE

=·
r
Vision864 Graphics Accelerator
53 Incorporated
Table A-6. System Extension Registers (continued)
| Add  Index    |                                          | Register Name    |     | Description  |
| ------------- | ---------------------------------------- | ---------------- | --- | ------------ |
| ress  B1t(s)  | R/W                                      | Bit Descr_!01on  |     | Pl!.9.e      |
| 375  67       | Extended Miscellaneous Control 2 (CR67)  |                  |     | 17-14        |
0
RMI  VCLK 1s in _!J_hase with DCLK
| 3-1      | RMI  Reserved                         |     |     |        |
| -------- | ------------------------------------- | --- | --- | ------ |
| 7-4      | RMI  Select 16-bit RAMDAC color mode  |     |     |        |
| 375  68  | Conf!g_uration 3 (CR68)               |     |     | 17-15  |
1-0  RMI  CAS, WE and OE stretch time selection
| 3-2  | RMI  Memory_ address deQ1:h select  |     |     |     |
| ---- | ----------------------------------- | --- | --- | --- |
5-4  RMI  RAS low t1min_g_ select
| 7-6      | RMI  RAS _Qrecha_i:g_e t1m1r:!.9_ select  |     |     |        |
| -------- | ----------------------------------------- | --- | --- | ------ |
| 375  69  | Extended System Control 3 (CR69)          |     |     | 17-16  |
| 4-0      | RMI  D1s_Qi~ start address bits 19-16     |     |     |        |
| 7-5      | RMI  Reserved                             |     |     |        |
| 375  6A  | Extended ~stem Control 4 (CR6A)           |     |     | 17-16  |
5-0  RMI  CPU base address bits 19-14
| 7-6      | RMI  Reserved                  |     |     |        |
| -------- | ------------------------------ | --- | --- | ------ |
| 375  68  | Extended BIOS Fla_g_ 3 (CR6Bl  |     |     | 17-17  |
Used l2Y_ the video BIOS
| 7-0      | RMI                             |     |     |        |
| -------- | ------------------------------- | --- | --- | ------ |
| 375  6C  | Extended BIOS Fll!.9. 4 (CR6Cl  |     |     | 17-17  |
7-0  RMI  Used l2Y_ the video BIOS
| 375  60  | Extended Miscellaneous Control (CR6D  |     |     | 17-17  |
| -------- | ------------------------------------- | --- | --- | ------ |
2-0  RMI  Number of DCLK_l)_enods to del§Y_BLANK
7-3  RMI  Reserved
| .. 9005049  | 0000959  | 591  ..  | REGISTER REFERENCE  | A-19  |
| ----------- | -------- | -------- | ------------------- | ----- |

••
r Vision864 Graphics Accelerator
53 Incorporated
A. 7 ENHANCED COMMANDS REGISTERS
This section lists the registers which support the Vision864 enhanced drawing functions. All of these
registers are byte or word-addressed and are enabled only if bit O of the System Configuration register
(CR40) is set to 1.
Table A-7. Enhanced Commands Registers
Add Index Register Name Description
ress B1t(s) R/W Bit Descr_!2!1on P'!.9._e
42E8 Subsystem Status 18-1
0 R Vertical s~nc 1nterrujl_t status
1 R Gr~h1cs Er1_9!ne busy_1nterru_0 status
2 R FIFO overflow 1nterru_0 status
3 R FIFO emJ2!i1nterrl!J2!: status
6-4 R General lr:!Q_ut Port data from_ Q_ower-on str~r:!.9_
7 R 4 or 8 b1t_Qlanes
15-8 R Reserved
42E8 Subsystem Control 18-2
w
0 Clear vertical ~nc 1nterrL1£.t status
w
1 Clear Gr~h1cs E~ne bu~interru_0 status
w
2 Clear FIFO overflow 1nterru_0 status
w
3 Clear FIFO emJ2!i1nterrUQt status
w
7-4 Reserved
w
8 Vertical ~nc interrujl_t enabled
w
9 Gr~hics E~ne bu~interrL1£.t enabled
w
10 FIFO overflow interrl!J2!: enabled
w
11 FIFO emJ2.!'l.1nterrL1£.t enabled
w
13-12 Reserved
w
15-14 Gr~hics Erl_.9!ne software reset selection
4AE8 Advanced Function Control 18-3
0 RNJ Enable Enhanced mode functions
1 RNJ Reserved
2 RNJ ~eci!Y_ 4 bits{Qlxel Enhanced mode
3 RNJ Reserved
4 RNJ Enable linear addressinJ:L
5 RNJ Enable memo_IY:m~ed 1/0
15-6 RNJ Reserved
82E8 Current V Position 18-4
11-0 RNJ Pixel vertical screen coordinate
15-12 RNJ Reserved
86E8 Current X Position 18-4
11-0 RNJ Pixel horizontal screen coordinate
15-12 RNJ Reserved
• 9005049 0000960 203 • -------------
A-20 REGISTER REFERENCE

Vision864 Graphics Accelerator
53 Incorporated
Table A-7. Enhanced Commands Registers (continued)
| Add  Index    |                                             |     | Register Name     | Description  |
| ------------- | ------------------------------------------- | --- | ----------------- | ------------ |
| ress  Bit(s)  | R/W                                         |     | Bit Descr!Q:tion  | Pl!!l_e      |
| SAES          | Destination Y Position/ Axial St~ Constant  |     |                   | 1S-5         |
11-0/  R/VV  Dest1nat1on Y position tor B1tBlts and pattern fills/Axial step
| 13-0   | constant tor line draws                           |     |     |     |
| ------ | ------------------------------------------------- | --- | --- | --- |
| 15-12  | R/VV  Reserved {Bits 1 5-14 tor stEj!_ constant)  |     |     |     |
SEES  Destination X Position/ Dil!!l_onal St~ Constant  1S-5
11-0/  R/VV  Destination X position tor B1tBlts and pattern fills/Axial step
| 13-0   | constant tor line draws                           |     |     |       |
| ------ | ------------------------------------------------- | --- | --- | ----- |
| 15-12  | R/VV  Reserved (Bits 15-14 for stEj!_ constant)   |     |     |       |
| 92ES   | Error Term                                        |     |     | 1S-6  |
| 13-0   | R/VV  Error term for line draws                   |     |     |       |
| 15-14  | R/VV  Reserved                                    |     |     |       |
| 96ES   | Maj_or Axis Pixel Count                           |     |     | 1S-6  |
| 11-0   | R/VV  LeQ.9_th of the loQ.9_est axis JQixels -1)  |     |     |       |
| 15-12  | R/VV  Reserved                                    |     |     |       |
| 9AES   |                                                   |     |     | 1S-7  |
Gr~hics Processor Status
7-0  R  Low 8 bits of field show1Q.9_ Fl FO slots available (see bits 15-11)
| 8   | R  Reserved  |     |     |     |
| --- | ------------ | --- | --- | --- |
R
| 9     | Gr8£_hics Erigine bu~                             |     |     |       |
| ----- | ------------------------------------------------- | --- | --- | ----- |
| 10    | R  All FIFO slots em_Qty_                         |     |     |       |
| 5-11  | R  H_!_g_h 5 bits of Fl FO status (see bits 7-0)  |     |     |       |
| 9AES  |                                                   |     |     | 1S-S  |
Drawi'!9_ Command
w
| 0   | Reserved  |     |     |     |
| --- | --------- | --- | --- | --- |
w
| 1   | Select across the_Qlane_Qixel mode  |     |     |     |
| --- | ----------------------------------- | --- | --- | --- |
w
| 2   | Last_12_1xel will not be drawn  |     |     |     |
| --- | ------------------------------- | --- | --- | --- |
w
| 3   | Select radial draw1Q.9_ direction  |     |     |     |
| --- | ---------------------------------- | --- | --- | --- |
w
| 4   | Draw_ 12_1xels  |     |     |     |
| --- | --------------- | --- | --- | --- |
w
| 7-5  | Select drawn~g_ d1rect1on  |     |     |     |
| ---- | -------------------------- | --- | --- | --- |
w
| 8   | Wait for CPU data  |     |     |     |
| --- | ------------------ | --- | --- | --- |
w
| 10-9  | Select ~stem bus size  |     |     |     |
| ----- | ---------------------- | --- | --- | --- |
w
| 11  | Reserved  |     |     |     |
| --- | --------- | --- | --- | --- |
w
| 12     | Enable 12.Y_te SW8£_          |     |     |        |
| ------ | ----------------------------- | --- | --- | ------ |
| 15-13  | w  Select command !'iQ_e      |     |     |        |
| 9EES   | Short Stroke Vector Transfer  |     |     | 1S-10  |
w
| 3-0  | Le~h of vector 1 iQixels -1)  |     |     |     |
| ---- | ----------------------------- | --- | --- | --- |
w
| 4   | Draw_ 12_1xels  |     |     |     |
| --- | --------------- | --- | --- | --- |
w
| 7-5  | Select draw1~ d1rect1on  |     |     |     |
| ---- | ------------------------ | --- | --- | --- |
w
15-8  DLJQ!1cate of bits 7-0 to define second short stroke vector
| A2ES        | Bac~ound Color                |      |     | 1S-11  |
| ----------- | ----------------------------- | ---- | --- | ------ |
| 31-0        | R/VV  Background color value  |      |     |        |
| .. 9005049  | 0000961                       | 14T  | ..  |        |
REGISTER REFERENCE  A-21

Vision864 Graphics Accelerator
53 Incorporated
Table A-7. Enhanced Commands Registers (continued)
| Add   | Index      |                          | Register Name     | Description  |
| ----- | ---------- | ------------------------ | ----------------- | ------------ |
|       | Bit(s)     |                          | Bit Descr_l2!1on  | Pl!.9._e     |
| ress  | R/W        |                          |                   |              |
| A6EB  |            | Foreground Color         |                   | 1B-11        |
|       | 31-0  RM/  | Fore_ground Color value  |                   |              |
1B-12
| AAEB  |            | Bi!f!!ane Write Mask                                         |     |        |
| ----- | ---------- | ------------------------------------------------------------ | --- | ------ |
|       | 31-0  RM/  | Each bit enables L!Q.datir:l.Q_ of corre~ondin_g_ bitjllane  |     |        |
| AEEB  |            | Bi!f!!ane Read Mask                                          |     | 1B-12  |
|       | 31-0  RM/  | Each bit enables reading of corre~ond1r:l9_ bitRlane         |     |        |
| B2EB  |            | Color Com~re                                                 |     | 1B-13  |
|       | 31-0  RMI  | Color value to be com_l)_ared with current bitma_Q_ color    |     |        |
1B-13
| B6EB  |     | Bac~ound Mix  |     |     |
| ----- | --- | ------------- | --- | --- |
w
|     | 3-0     | Select mix~          |     |     |
| --- | ------- | -------------------- | --- | --- |
|     | 4  w    | Reserved             |     |     |
|     | 6-5  w  | Select color source  |     |     |
w
|       | 15-7  | Reserved           |     |        |
| ----- | ----- | ------------------ | --- | ------ |
| BAEB  |       | Fore_9.l'ound Mix  |     | 1B-13  |
w
|     | 3-0  | Select mix !YQ_e  |     |     |
| --- | ---- | ----------------- | --- | --- |
w
|     | 4       | Reserved             |     |     |
| --- | ------- | -------------------- | --- | --- |
|     | 6-5  w  | Select color source  |     |     |
w
|             | 15-7      | Reserved                                        |               |        |
| ----------- | --------- | ----------------------------------------------- | ------------- | ------ |
| BEEB        |           | Read R~ster Data                                |               | 1B-14  |
|             | 15-0  R   | Data from r~ster selected ~bits 2-0 of BEESH_E  |               |        |
| BEEB        | 0         | Minor Axis Pixel Count                          |               | 1B-15  |
|             | 11-0  w   | Rectangle helfl_ht \Qixels -1)                  |               |        |
|             | 15-12  w  | Reserved                                        |               |        |
| BEEB        | 1         | To__p_ Scissors                                 |               | 1B-15  |
|             | 11-0  w   | T~ side of the cll2Q!n_g_ rectalJ.9.!e          |               |        |
|             | 15-12  w  | Reserved                                        |               |        |
| BEEB        | 2         | Left Scissors                                   |               | 1B-15  |
|             | 11-0  w   | Left side of the cliQ[lir:l.9._rectangle        |               |        |
|             | 15-12  w  | Reserved                                        |               |        |
| BEEB        | 3         | Bottom Scissors                                 |               | 1B-16  |
|             | 11-0  w   | Bottom side of the cl.!22)r:l9._recta1J.9.!e    |               |        |
|             | 15-12  w  | Reserved                                        |               |        |
| BEEB        | 4         | Right Scissors                                  |               | 1B-16  |
|             | 11-0  w   | Rlfl_ht side of the cllfll'.llng rectangle      |               |        |
|             | 15-12  w  | Reserved                                        |               |        |
| •  9005049  | 0000962   | 086  •                                          | ------------- |        |
A-22 REGISTER REFERENCE

Vision864 Graphics Accelerator
53 Incorporated
Table A-7. Enhanced Commands Registers (continued)
Add Index Register Name Description
ress B1t(s) R/W Bit Description Pi!9_e
BEES A Pixel Control 1S-16
w
5-0 Reserved
w
7-6 Select mix register
w
11-8 Reserved
w
15-12 OAH (index)
BEES D Multifunction Control Miscellaneous 2 1S-17
w
2-0 Destination base address location in memory
w
3 Reserved
w
6-4 Source base address location in memory
w
11-7 Reserved
w
15-12 OOH (index)
BEES E Multifunction Control Miscellaneous 1S-1S
w
1-0 Dest1nat1on base address bits 21-20
w
3-2 Source base address bits 21-20
w
4 Select Uflfl_er word for 32-bit nigister accesses
w
5 Only_gixels outside the cliQQlrig_ rectaQg_le are drawn
w
6 Select slow read/mod_1_fy/write ~cle
w
7 Don't update bitmap 1f source 1s not equal to color compare
color
w
8 Enable color comparison
w
9 Select 32-bit command registers
w
11-10 Reserved
w
15-12 OEH (index)
BEES F Read R~gister Select 1S-19
w
2-0 Select register to be read
w
11-4 Reserved
w
15-12 OFH (index)
E2ES Pixel Data Transfer 1S-14
w
15-0 Data transfer register (CPU to GraQh1c EQ9_1ne) -low word
E2EA Pixel Data Transfer-Extension 1S-20
w
15-0 Data transfer register (CPU to Graphic Engine) -high word
~ 9005049 0000963 T12 ~ REGISTER REFERENCE A-23

Vision864 Graphics Accelerator
S3 Incorporated
A.8  PCI CONFIGURATION SPACE REGISTERS
When a PCI configuration read or write command is issued, AD!7:0] contain the address of the register
in the configuration space to be accessed.
| Table A-8.  PCI Configuration Space Registers  |            |     |                   |              |
| ---------------------------------------------- | ---------- | --- | ----------------- | ------------ |
| Add  Index                                     |            |     | Register Name     | Description  |
| dress  Bit(s)                                  | R/W        |     | Bit Descn_Q_tion  | P1!9_e       |
|                                                | Vendor ID  |     |                   | 19-1         |
00
| 15-0  | R  Hardwired to 5333H  |     |     |       |
| ----- | ---------------------- | --- | --- | ----- |
| 02    | Device ID              |     |     | 19-2  |
| 15-0  | R  Hardwired to 88COH  |     |     |       |
| 04    | Command                |     |     | 19-2  |
0  R/W  Re~onse to 1/0 ~ce accesses enabled
1  R/W  Re~onse to memo_i:y_ ~ce accesses enabled
| 4-2  | R/W  Reserved  |     |     |     |
| ---- | -------------- | --- | --- | --- |
5  R/W  No re~onse to RAMDAC r~ster accesses
| 15-6   | R/W  Reserved                                            |     |     |       |
| ------ | -------------------------------------------------------- | --- | --- | ----- |
| 06     | Status                                                   |     |     | 19-3  |
| 8-0    | R/W  Reserved                                            |     |     |       |
| 10-9   | R/W  Hardwired to select medium device select timiri_g_  |     |     |       |
| 15-11  | R/W  Reserved                                            |     |     |       |
| 08     | Revision ID                                              |     |     |       |
| 7-0    | R/W  Revision level of the ch_12_(ste_QQ_1_~             |     |     |       |
| OA     | Pr~amming_ Interface                                     |     |     | 19-3  |
0  R/W  Hardwired to 1nd1cate SU[Jport for standard VGA_Qrog_ramm1n_g
| 7-1  | R/W  Reserved   |     |     |       |
| ---- | --------------- | --- | --- | ----- |
| 10   | Base Address 0  |     |     | 19-4  |
0  R/W  Hardwired to indicate base r~sters m~1nto memq_ry_ ~ce
2-1  R/W  Hardwired to allow m8Ql)lri_g_ ariy_where in 32-bit address ~ce
3  R/W  Hardwired to indicate does not meet_Qrefetchable r~uirements
| 22-4   | R/W  Reserved        |     |     |       |
| ------ | -------------------- | --- | --- | ----- |
| 31-23  | R/W  Base address 0  |     |     |       |
| 30     | BIOS Base Address    |     |     | 19-5  |
0  R/W  Enable access to BIOS ROM address s_Q_ace
| 15-1        | R/W  Reserved                           |      |                  |     |
| ----------- | --------------------------------------- | ---- | ---------------- | --- |
| 31-16       | R/W  Upper 16 bits of BIOS ROM address  |      |                  |     |
| •  9005049  | 0000964                                 | 959  | •  ------------- |     |
A-24 REGISTER REFERENCE

Vision864 Graphics Accelerator
S3 Incorporated
|     |     | Section 2:  | Mechanical Data  |     |     |
| --- | --- | ----------- | ---------------- | --- | --- |
2.1  THERMAL SPECIFICATIONS
| Parameter  |     |     | Min  | Max  | Unit  |
| ---------- | --- | --- | ---- | ---- | ----- |
~
| Thermal Resistance 0JC              |     |     |     | 8   | °CNV  |
| ----------------------------------- | --- | --- | --- | --- | ----- |
| Thermal Resistance 0JA (Still Air)  |     |     |     | 37  | °CNV  |
w
| Power D1ssil:i_ation  |     |     |     | 1.5  1.75  |     |
| --------------------- | --- | --- | --- | ---------- | --- |
oc
Junction Temperature  125
2.2  MECHANICAL DIMENSIONS
The Vision864 comes in a 208-pin PQFP package. The mechanical dimensions are given in Figure 2-1 .
| .. 9005049  | 0000740  | 653  ..  |     |     |     |
| ----------- | -------- | -------- | --- | --- | --- |
MECHANICAL DATA 2-1

Vision864 Graphics Accelerator
S3 Incorporated
30.60z0.30
29.60z0.20
ru,
28.80
28.0±0.10 ~ ·1
...
:!? 0 ~
.II.
0.50±0.10 020z0.08
13·
LINEAR DIMENSIONS
ARE IN MILLIMETERS
0.50±0.20 mechd1m
Figure 2-1. 208-pin PQFP Mechanical Dimensions
.. 9005049 0000741 59T ..
2-2 MECHANICAL DATA
