•

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Trio32/Trio64
Graphics
Accelerators
March 1995
S31ncorporated
2770 San Tomas Expressway
Santa Clara, CA 95051-0968

..
-
..-
~
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 IncorporBtBd
NOTATIONAL CONVENTIONS
The following notational conventions are used in this data book:
Signal names are shown in all uppercase letters. For example, XD.
A bar over a signal name indicates an active low signal. For example, CE.
n-m indicates a bit field from bit n to bit m. For example, 7-0 specifies bits 7 through 0, inclusive.
n:m indicates a signal (pin) range from n to m. For example DI7:0] specifies data lines 7 through 0, inclusive
Use of a trailing letter H indicates a hexadecimal number. For example, 7A H is a hexadecimal number.
Use of a trailing letter b indicates a binary number. For example, 010b is a binary number.
When numerical modifiers such as K or M are used, they refer to binary rather than decimal form. Thus, for example, 1 KByte would be
equivalentto 1024, not 1,000 bytes.
NOTICES
© Copyright 1994, 1995 S3lncorporated. All rights reserved. No part ofthis publication may be reproduced, stored in a retrieval system,
or transmitted in any form or by any means, electronic, mechanical. photocopying, or otherwise, without the prior written consent of S3
Incorporated, 2770 San Tomas Expwy., Santa Clara CA 95051-0968. The S3 Corporate Logo, S3 on Board, S3 on Board design, S3 801,
S3 805, S3 PS805, S3 805i, S3 928, S3 928PCI, Vision64, Vision864, Vision866, Vision868, Vision964, Vision968, VisionNA. Trio, Tri032,
Trio64, MIC, Galileo, SDAC No Compromise Integration, No Compromise Acceleration and Innovations in Acceleration are trademarks
of S3 Incorporated and S3 and True Acceleration are registered trademarks of S3 Incorporated. Other trademarks referenced in this
document are owned by their respective companies. The material in this document is for information only and is subject to change
without notice. S3 Incorporated reserves the right to make changes in the product design without reservation and without notice to its
users.
Additional information may be obtained from:
S31ncorporated, Literature Department, 2770 San Tomas Expressway, Santa Clara, CA 95051-0968.
Telephone: 408-980-5400, Fax: 408-980-5444

ij
J
S3 Tri032/Tri064 Integrated Graphics Accelerators
,<
S3 Incorporated
Table of Contents
| List of Figures  |     | vi  Section 6: System Bus Interfaces. 6-1  |                  |      |
| ---------------- | --- | ------------------------------------------ | ---------------- | ---- |
|                  |     | 6.1  PCI BUS INTERFACE                     | . . . . . . . .  | 6-1  |
6.1.1  PCICONFIGURATION  ..... 6-1
| List of Tables.  |     | vii  |     |     |
| ---------------- | --- | ---- | --- | --- |
6.1.2  PCI Bus Cycles  ......... 6-1
|     |     | 6.2  VL-BUS INTERFACE  | ........ 6-5  |     |
| --- | --- | ---------------------- | ------------- | --- |
Section 1: Introduction  ..  . 1-1  6.2.1  VL-Bus Cycles. . . . . . . . . .  6-6
1.1  OVERVIEW  ............. 1-2  6.2.2  SRDY Generation . . . . . . . .  6-6
1.2  ADVANCED ARCHITECTURE/
| FEATURE SET  | ........... 1-2  |                            |           |     |
| ------------ | ---------------- | -------------------------- | --------- | --- |
|              |                  | Section 7: Display Memory  | .... 7-1  |     |
1.3  MULTIMEDIA SUPPORT FEATURES 1-2
7.1  DISPLAY MEMORY
| 1.4  FULL SOFTWARE SUPPORT. . ..  |     | 1-2  |     |     |
| --------------------------------- | --- | ---- | --- | --- |
CONFIGURATIONS. . . . . . . . .  7-1
1.5  GREEN PC/MONITOR PLUG AND
|               |                 | 7.2  DISPLAY MEMORY REFRESH  | . . .  | 7-3  |
| ------------- | --------------- | ---------------------------- | ------ | ---- |
| PLAY SUPPORT  | .......... 1-2  |                              |        |      |
7.3  DISPLAY MEMORY FUNCTIONAL
| 1.6  RESOLUTIONS SUPPORTED  | ... 1-3  |     |     |     |
| --------------------------- | -------- | --- | --- | --- |
TIMING  ............... 7-5
7.4  DISPLAY MEMORY ACCESS
Section 2: Mechanical Data  . . . . 2-1  CONTROL . . . . . . . . . . . . . .  7-8
2.1  THERMAL SPECIFICATIONS. . ..  2-1  7.5  SHARED FRAME BUFFER  ..... 7-9
| 2.2  MECHANICAL DIMENSIONS        | ... 2-1  |                                        |     |      |
| --------------------------------- | -------- | -------------------------------------- | --- | ---- |
|                                   |          | Section 8: RAMDAC Functionality        |     | 8-1  |
| Section 3: Pins  ........... 3-1  |          |                                        |     |      |
|                                   |          | 8.1  COLOR MODES. . . . . . . . . . .  |     | 8-1  |
3.1  PINOUT DIAGRAMS  . . . . . . ..  3-1  8.1.1  8 Bits/Pixel -Mode 0  . . . . . .  8-2
3.2  PIN DESCRIPTIONS  ........ 3-6  8.1.2  Output-doubled 8 Bits/Pixel -
3.3  PIN LISTS .............. 3-13  Mode 8  ............. 8-2
8.1.3  15/16-Bits/Pixel-Modes 9
and 10 . . . . . . . . . . . . . .  8-2
| Section 4: Electrical Data  | ..... 4-1  |     |     |     |
| --------------------------- | ---------- | --- | --- | --- |
8.1.4  Packed 24 Bits/Pixel-Mode 12
| 4.1  MAXIMUM RATINGS  | ....... 4-1  |     |     |     |
| --------------------- | ------------ | --- | --- | --- |
(Trio32 Only)  .......... 8-3
4.2  DC SPECIFICATIONS ........ 4-1
8.1.5  24 Bits/Pixel -Mode 13 . . . . .  8-3
4.3  AC SPECIFICATIONS ........ 4-2  8.2  RAMDAC REGISTER ACCESS  . . .  8-4
| 4.3.1  Clock Timing                  | . . . . . . . . . .  | 4-3                                  |              |      |
| ------------------------------------ | -------------------- | ------------------------------------ | ------------ | ---- |
|                                      |                      | 8.3  RAMDAC SNOOPING. . . . . . . .  |              | 8-4  |
| 4.3.2  Input/Output Timing           | . . . . ..           | 4-4                                  |              |      |
|                                      |                      | 8.4  SENSE GENERATION                | ....... 8-4  |      |
| Section 5: Reset and Initialization  |                      | 5-1                                  |              |      |
Section 9: Clock Synthesis and
| 5.1  CONFIGURATION STRAPPING  |     | ..  5-1  |     |     |
| ----------------------------- | --- | -------- | --- | --- |
Control  ....•.......... 9-1
| 5.2  TEST MODE. . . . . . . . . . . ..  |     | 5-1                                    |                 |      |
| --------------------------------------- | --- | -------------------------------------- | --------------- | ---- |
|                                         |     | 9.1  CLOCK SYNTHESIS. . . . . . . . .  |                 | 9-1  |
|                                         |     | 9.2  CLOCK REPROGRAMMING               | .... 9-2        |      |
|                                         |     | 9.3  DCLK CONTROL                      | .......... 9-3  |      |
iii

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Section 10: Miscellaneous  13.4  PROGRAMMING  ........ ,  13-6
|                                      |       | 13.4.1  Notational Conventions            | ...  | 13-6  |
| ------------------------------------ | ----- | ----------------------------------------- | ---- | ----- |
| Functions . . . . . . . . . . . . .  | 10-1  |                                           |      |       |
|                                      |       | 13.4.2  Initial Setup . . . . . . . . ..  |      | 13-7  |
10.1  VIDEO BIOS ROM INTERFACE ... 10-1
|                                      |       | 13.4.3  Programming Examples  | . ..       | 13-7  |
| ------------------------------------ | ----- | ----------------------------- | ---------- | ----- |
| 10.1.1  Disabling BIOS ROM Accesses  | 10-1  |                               |            |       |
|                                      |       | 13.3.3.1 Solid Line           | .........  | 13-9  |
10.1.2  BIOS ROM Hardware Interface  10-1  13.3.3.2 Textured Line  ......• 13-10
10.1.3  BIOS ROM Read Functional
|     |     | 13.3.3.3 Rectangle Fill Solid  | .... 13-12  |     |
| --- | --- | ------------------------------ | ----------- | --- |
Timing .............. 10-2
13.3.3.4 Image Transfer-Through
'10.1.4  BIOS ROM Address Mapping  . 10-2
the Plane .......... 13-13
10.2  GREEN PC SUPPORT ........ 10-4
13.3.3.5 Image Transfer-Across
| 10.3  GENERAL INPUT PORT  | ...... 10-4  |     |     |     |
| ------------------------- | ------------ | --- | --- | --- |
the Plane .......... 13-15
| 10.4  GENERAL OUTPUT PORT  | ..... 10-4  |     |     |     |
| -------------------------- | ----------- | --- | --- | --- |
13.3.3.6 BitBLT-Through the Plane 13-17
10.5  FEATURE CONNECTOR  13.3.3.7 BitBLT-Across the Plane. 13-18
| INTERFACE  ............. 10-7  |     |     |     |     |
| ------------------------------ | --- | --- | --- | --- |
13.3.3.8 PatBLT-Pattern Fill
10.6  GENLOCKING ........... 10-10
Through the Plane ..... 13-20
10.7  INTERRUPT GENERATION .... 10-11
13.3.3.9 PatBLT-Pattern Fill Across
the Plane .......... 13-21
| Section 11: Software Setup  | 11-1  |                                 |            |     |
| --------------------------- | ----- | ------------------------------- | ---------- | --- |
|                             |       | 13.3.3.10 Short Stroke Vectors  | ... 13-22  |     |
11.1  CHIP WAKEUP  ........... 11-1  13.3.3.11 Polyline/2-Point Line
(Trio64 Only). . . . . . . . 13-23
11.2  REGISTER ACCESS ......... 11-2
11.2.1  Unlocking the S3 Registers  .. 11-2  13.3.3.12 Polygon Fill Solid
11.2.2  Locking the S3 Registers .... 11-3  (Trio64 Only). . . . . . . . 13-24
11.2.3  Unlocking/Locking Other  13.3.3.13 Polygon Fill Pattem
Registers  ............ 11-3  (Trio64 Only). . . . . . . . 13-26
11.3  TESTING FOR THE PRESENCE  13.3.3.14 4-Point Trapezoid Fill Solid
OF A Tri032/Trio64 CHIP ...... 11-4  (Trio64 Only). . . . . . . . 13-27
13.3.3.15 4-point Trapezoid Fill Pattern
| 11.4  GRAPHICS MODE SETUP  | ..... 11-4  |     |     |     |
| -------------------------- | ----------- | --- | --- | --- |
11.4.1  VGA Mode Setup ........ 11-4  (Trio64 Only). . . . . . . . 13-28
11.4.2  S3 Enhanced Mode Setup ... 11-6  13.3.3.16 Bresenham Parameter Trapezoid
11.4.3  Hardware Graphics Cursor  Fill Solid (Trio64 Only) . . . 13-29
Setup  .............. 11-8  13.3.3.17 Bresenham Parameter Trapezoid
Fill Pattern (Trio64 Only). . 13-30
Section 12: VGA Compatibility  13.3.3.18 Programmable Hardware
Cursor ........... 13-31
Support  ............. 12-1  13.4  RECOMMENDED READING  ... 13-32
| 12.1  VGA COMPATIBILITY       | ....... 12-1  |     |     |     |
| ----------------------------- | ------------- | --- | --- | --- |
| 12.2  VESA SUPER VGA SUPPORT  | ... 12-2      |     |     |     |
Section 14: VGA Standard Register
|     |     | Descriptions  | .. . . . . . . . . .  | 14-1  |
| --- | --- | ------------- | --------------------- | ----- |
Section 13: Enhanced Mode
|                               |     | 14.1  GENERAL REGISTERS    | . . • . ..  | 14-1  |
| ----------------------------- | --- | -------------------------- | ----------- | ----- |
| Programming  .......... 13-1  |     |                            |             |       |
|                               |     | 14.2  SEQUENCER REGISTERS  | ....        | 14-4  |
13.1  DIRECT BITMAP ACCESSING- 14.3  CRT CONTROLLER REGISTERS  . 14-19
| LINEAR ADDRESSING  | ....... 13-1  |     |     |     |
| ------------------ | ------------- | --- | --- | --- |
14.4  GRAPHICS CONTROLLER
13.2  BITMAP ACCESS THROUGH THE
|                  |                | REGISTERS                   | ............ 14-34  |     |
| ---------------- | -------------- | --------------------------- | ------------------- | --- |
| GRAPHICS ENGINE  | ........ 13-2  | 14.5  ATTRIBUTE CONTROLLER  |                     |     |
13.3  MEMORY MAPPING OF ENHANCED  REGISTERS  ............ 14-41
MODE REGISTERS ......... 13-4  14.6  SETUP REGISTERS ........ 14-47
13.3.1  Standard Memory Mapping of  14.7  RAMDAC REGISTERS  ...... 14-49
Enhanced Mode Registers ... 13-4
13.3.2  Packed MMIO Register
| Mapping  ............ 13-5  |     |     |     |     |
| --------------------------- | --- | --- | --- | --- |
iv

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Section 15: S3 VGA Register
| Descriptions  | ........  |     | .. 15-1  |
| ------------- | --------- | --- | -------- |
Section 16: System Control
| Register Descriptions  |     | . . .  | .  16-1  |
| ---------------------- | --- | ------ | -------- |
Section 17: System Extension
| Register Descriptions  |     | ...... 17-1  |     |
| ---------------------- | --- | ------------ | --- |
Section 18: Enhanced Commands
| Register Descriptions  |     | ...... 18-1  |     |
| ---------------------- | --- | ------------ | --- |
Section 19: PCI Register
| Descriptions                    | ..... .  |                      | 19-1  |
| ------------------------------- | -------- | -------------------- | ----- |
| Appendix A: Register Reference  |          |                      | A-1   |
| A.1  VGA REGISTERS              |          | . . . . . . . . . .  | A-2   |
| A.2  S3 VGA REGISTERS           |          | . . . . . ..         | A-11  |
| A.3  SYSTEM CONTROL REGISTERS   |          |                      | A-13  |
A.4  SYSTEM EXTENSION REGISTERS A-15
A.S  ENHANCED COMMANDS
| REGISTERS  |     | . . . . . . . . . . ..  | A-18  |
| ---------- | --- | ----------------------- | ----- |
A.6  PCI CONFIGURATION SPACE
| REGISTERS  |     | . . . . . . . . . . ..  | A-23  |
| ---------- | --- | ----------------------- | ----- |
Index  ................ 1-1
v

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
List of Figures
# Title Page # Title Page
1-1 PCI Bus System Block Diagram 1-3 8-3 15 Bits/Pixel Internal PA Bus
2-1 208-pin PQFP Mechanical Coding. . . . . . . . . . . . .. 8-3
Dimensions . . . . . . . . . .. 2-2 8-4 16 Bits/Pixel Internal PA Bus
3-1 Trio32 PCI Bus Configuration Coding. . . . . . . . . . . . . 8-3
Pinout. . . . . . . . . . . . .. 3-2 8-5 24 Bits/Pixel Internal PA Bus
3-2 Trio32 VL-Bus Configuration Coding. . . . . . . . . . . . . 8-3
Pinout ............... 3-3 9-1 PLL Block Diagram . . . . . . 9-2
3-3 Trio64 PCI Bus Configuration 10-1 BIOS ROM PCI Configuration
Pinout. . . . . . . . . . . . .. 3-4 Interface . . . . . . . . . . . .. 10-1
3-4 Trio64 VL-Bus Configuration 10-2 BIOS ROM VL-Bus Configuration
Pinout. . . . . . . . . . . . 3-5 Interface. . . . . . . . . . . .. 10-2
4-1 Clock Waveform Timing . . 4-3 10-3 BIOS ROM Read Functional
4-2 Input Timing .......... 4-4 Timing -PCI . . . . . . . . . .. 10-3
4-3 Output Timing ..... 4-5 10-4 General I/O Port Interfaces (PCI) 10-4
4-4 Reset Timing . . . . . . . . .. 4-7 10-5 General I/O Port Interfaces
6-1 Basic PCI Read Cycle . . . . .. 6-2 (VL-Bus) . . . . . . . . . . . .. 10-5
6-2 Basic PCI Write Cycle . . . . .. 6-2 10-6 General Input Port Timing (PCI) 10-5
6-3 PCI Disconnect Example A . .. 6-3 10-7 General Input Port Timing
6-4 PCI Disconnect Example B . .. 6-3 (VL-Bus) . . . . . . . . . . . .. 10-6
6-5 PCI Configuration Write Cycle .. 6-4 10-8 General Output Port Timing (PCI) 10-6
6-6 PCI Configuration Read Cycle . . 6-4 10-9 General Output Port Timing
6-7 Read Parity Operation . . . . .. 6-5 (VL-Bus) . . . . . . . . . . . .. 10-7
6-8 VL-Bus Read Cycle . . . . . . .. 6-7 10-10 VAFC Implementation
6-9 1 Wait-state VL-Bus Write Cycle. 6-8 (32-bit PO Bus) ......... 10-8
7-1 1-MByte Trio32/64 -2 MByte 10-11 VAFC Implementation
Trio32 Memory . . . . . . . . . . 7-2 (64-bit PO Bus) ......... 10-8
7-2 2-MByte Trio64 DRAM 10-12 Pass-Thru Feature Connector
Configuration . . . . . . . . . .. 7-3 (32-bit PO) . . . . . . . . . . .. 10-9
7-3 4-MByte Trio64 FP DRAM 10-13 Pass-Thru Feature Connector
Configuration . . . . . . . . . .. 7-4 (64-bit PO) . . . . . . . . . . .. 10-9
7-4 Fast Page Mode Read Cycle . . . 7-5 10-14 Genlocking Master Sync Timing 10-10
7-5 Fast Page Mode Write Cycle . .. 7-6 10-15 Genlocking Timing Adjustments 10-11
7-6 EDO Mode Read Cycle . . . . .. 7-7 13-1 Pixel Update Flowchart. . . .. 13-3
7-7 Display Memory Access Sources 7-8 13-2 Polygon Example Drawing Steps13-24
7-8 Shared Frame Buffer Protocol
Timing ............... 7-10
8-1 Internal RAMDAC Block Diagram 8-'
8-2 8 Bits/Pixel Internal PA Bus Coding 8-2
vi

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
List of Tables
| #  Title  |     | Page  #  | Title  | Page  |
| --------- | --- | -------- | ------ | ----- |
1-1  Tri032 Video Resolutions  1-3  11-3  Register Bits Affecting the Bitmap
|                                |     |      | Definition  ... . . . . . . . ..  | 11-6  |
| ------------------------------ | --- | ---- | --------------------------------- | ----- |
| 1-2  Tri064 Video Resolutions  |     | 1-3  |                                   |       |
3-1  Pin Descriptions  .....  3-6  11-4  Enhanced Mode Setup for
3-2  Alphabetical Pin Listing  ..  · 3-13  1024x768x8 Resolution at 75 Hz
3-3  Numerical Pin Listing ....  · 3-16  Refresh  ............. 11-7
4-1  Absolute Maximum Ratings  4-1  12-1  Standard VGA Registers Modified or
4-2  RAMDAC/Clock Synthesizer  Extended in the Trio32/Trio64  12-1
DC Specifications . . . . . .  4-1  13-1  Enhanced Registers Memory
4-3  RAMDAC Characteristics ..  4-1  Mapping ............ ,  13-5
4-4  Digital DC Specifications . .  4-2  13-2  Polygon Fill Example Summary  13-25
4-5  RAMDAC AC Specifications  4-2  A-1  VGA Registers  .......  . A-2
4-6  Clock Waveform Timing  ..  4-3  A-2  S3 VGA Registers  A-11
4-7  SCLK-Referenced Input Timing  4-4  A-3  System Control Registers  A-13
4-8  SCLK-Referenced Output Timing  4-5  A-4  System Extension Registers  A-15
4-9  Display Memory Read/Write  A-5  Enhanced Commands Registers  A-18
| Timing ............... 4-6  |     | A-6  | PCI Configuration Space  |     |
| --------------------------- | --- | ---- | ------------------------ | --- |
4-10  Feature Connector Timing -Output  Registers. . . . . . . . . . . .. A-23
from Tri032/Tri064 to Feature
| Connector . . . . . . . . . . . . .  |     | 4-6  |     |     |
| ------------------------------------ | --- | ---- | --- | --- |
4-11  Feature Connector Timing -Output
from Feature Connector to
| Tri032/Tri064                         | . . . . . . . . . ..  | 4-7  |     |     |
| ------------------------------------- | --------------------- | ---- | --- | --- |
| 4-12  Reset Timing                    | . . . . . . . . . ..  | 4-7  |     |     |
| 5-1  Signals Tri-Stated by Test Mode  |                       | 5-1  |     |     |
5-2  Definition of PD[23:0] at the Rising
| Edge of the Reset Signal . .  |     | 5-2  |     |     |
| ----------------------------- | --- | ---- | --- | --- |
7-1  Memory Size/Chip Count
| Configurations                   | . . . . . . .  | 7-1  |     |     |
| -------------------------------- | -------------- | ---- | --- | --- |
| 8-1  Trio32/Tri064 Color Modes.  |                | 8-2  |     |     |
| 9-1  PLL R Parameter Decoding.   |                | 9-1  |     |     |
11-1
VGA Register Access Control
| Extensions  | ........ .  | · 11-3  |     |     |
| ----------- | ----------- | ------- | --- | --- |
11-2  CRTC Timing Specification
| Summary ......... .  |     | · 11-5  |     |     |
| -------------------- | --- | ------- | --- | --- |
vii

S3 Trio32/Trio64 Integrated Graphics Accelerators
S31ncorporatad

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Section 1: Introduction
High-Performance Integrated DRAM-based GUI Industry-standard Local Bus Support
Accelerator Product Family
• Glueless PCI bus support (fully
• Pin-compatible 53 Trio64 (64-bit compliant with Revision 2.0)
Graphics Engine) and 53 Trio32 (32-bit
• Glueless VESA VL-Bus support
Graphics Engine)
Multimedia Features
Integrated 24-bit RAMDAC and Programmable
Dual-clock Synthesizer
• VESA advanced feature connector
(VAFC)
• 135 MHz output pixel data rate
• 16-bit bidirectional support
High Non-Interlaced Screen Resolution Support • 8-bit bidirectional feature connector
support
• 1280 x 1024 x 256 colors • 53 Shared Frame Buffer Interface
• 1024 x 768 x 64K colors (Trio64) support
800 x 600 x 16.7M colors • Genlock capability
64-bit DRAM Memory Interface -Trio64 Green PC Power Savings Features
32-bit DRAM Memory Interface -Trio32
• Full hardware and BIOS support for
• 1-,2-, and 4-MByte DRAM video VESA Display Power Management
memory support (Trio64) Signaling (DPMS) monitor power
savings modes
• 0.5-, 1-and 2-MByte DRAM video
memory support (Trio32)
Full Software Support
• 256Kx4/8/16 fast-page mode and EDO
DRAMs supported
• Drivers for all major operating systems
DDC Monitor Communications Support • Video BIOS support
• VGA Register Level Compatibility and
Extensive Static/Dynamic Power Savings Super VGA graphics modes support
Industry-Standard 20B-pin PQFP package
INTRODUCTION 1-1

..fa
p• -
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
1.1 OVERVIEW mapping the display memory into the CPU's up
per memory address space and permitting direct
CPU access to the display memory.
The Tri064 and Tri032 products are the first in a
series of highly-integrated products to be offered
by 53. Both products combine a 24-bit RAMDAC, 1.3 MULTIMEDIA SUPPORT
dual programmable clock generators, and high FEATURES
performance accelerator core in a single device.
This provides an optimal, cost-effective DRAM
based graphics solution targeted for mother Both the Tri064 and Tri032 incorporate genlock
circuitry to synchronize graphics output with an
board designs as well as add-in card
external NTSC or PAL signal. Both support an
applications. By incorporating an enhanced ver
8-bit bidirectional feature connector or a 16-bit
sion of the 64-bit graphics engine used in the 53
baseline configuration of the VESA Advanced
Vision family products with an on-chip RAM
Feature Connector (VAFC) specification to permit
DAC/clock synthesizer capable of 135 MHz output
video overlay with external video data.
pixel data rates, the Trio product family provides
extremely high graphics performance and sup
The Tri032/Tri064 also supports 53's Shared
port of non-interlaced screen resolutions of up to
Frame Buffer Interface. This uses a bus re
1280x1024x256 colors at 72 Hz. The high-per
quest/bus grant protocol to arbitrate access to a
formance Tri064 and cost-effective Tri032 are
shared frame buffer.
pin-compatible with each other, enabling easy
implementation of graphics subsystems at differ
ent price/performance points. System designs 1.4 FULL SOFTWARE SUPPORT
that implement the Tri032 with 1 MByte of video
memory can be quickly upgraded to the higher
53 provides comprehensive software driver sup
performance Tri064 with 2 MBytes of video
port for Microsoft Windows, Windows NT, IBM
memory.
OS/2 and SCO OpenDesktop, DOS applications
drivers available include AutoCAD and Microsta
1.2 ADVANCED tion PC. Tri064 and Tri032 are based upon the
ARCHITECTURE/FEATURE SET same architecture as other 53 accelerators, en
suring driver compatibility and reliability. Full
video BIOS support is also provided.
The Tri064 provides a 64-bit high performance
graphics engine and a 32/64 bit interface to
DRAM memory (up to 4 MBytes) for maximum 1.5 GREEN PC/MONITOR PLUG
memory bandwidth. The Tri032 incorporates a AND PLAY SUPPORT
high-performance 32-bit graphics engine and
supports a 32-bit interface to DRAM memory (up
The Tri064 and Tri032 provide full hardware and
to 2 MBytes). Fast page mode DRAMs as well as
BIOS support for VESA's Display Power Manage
the latest advanced Extended Data Out (EDO)
ment (DPMS) protocol. This allows the video
DRAMs are supported by the Tri032 and Tri064.
subsystem to put a DPMS-compliant monitor·
into power savings modes in order to meet the
An on-chip 24-bit RAMDAC/clock supports out
EPA's "Energy Star" requirements. The Tri032/
put pixel data rates of up to 135 MHz. This allows
Tri064 also supports the VESA Display Data
non-interlaced screen resolutions of up to
Channel (DDC) standard that permits transfer of
1280x1024x256 colors for the Tri032 and Tri064.
monitor identification and resolution support
The Tri064 implements in hardware full accelera
data.
tion of graphics functions such as BitBLTs with
ROPs, 2-point line draws, trapezoidal and poly
gon fills, clipping, and cursor support for maxi
mum performance. Memory-mapped I/O reads
and writes of all command setup and execute
registers are also supported. A fast linear ad
dressing scheme reduces software overhead by
1-2 INTRODUCTION

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
1.6  RESOLUTIONS SUPPORTED  Table 1-2.  Trio64 Video Resolutions
| Table 1-1.  Trio32 Video Resolutions  |           |             |             | 1 MB      | 2MBs  4MBs      |
| ------------------------------------- | --------- | ----------- | ----------- | --------- | --------------- |
|                                       |           |             | Resolution  | DR.,A. M  | DR.,A. M  DRAM  |
|                                       |           |             | 640x400x32  | .,.       | .,.  II"        |
|                                       | O.SMB     | 1 MB  2MBs  |             |           |                 |
| Resolution                            | D.,R. AM  | DR.,A. M    | 640x480x4   | .,.       | .,.  II"        |
DR.,A. M
.,.
| 640x480x4   |     | .,.           | 640x480x8   | .,.  | .,.  II"  |
| ----------- | --- | ------------- | ----------- | ---- | --------- |
| 640x480x8   |     | I.I,".   .,.  | 640x480x16  |      | .,.  II"  |
| 640x480x16  |     | .,.           | 640x480x32  | .,.  | .,.  II"  |
.,.
| 640x480x24  |      | II"         | 800x600x4   | .,.  | .,.  II"      |
| ----------- | ---- | ----------- | ----------- | ---- | ------------- |
| 640x480x32  | .,.  | .,.  .,.    | 800x600x8   | .,.  | .,.  I.I,".   |
| 800x600x4   | .,.  | .,.  .,.    | 800x600x16  |      | .,.  .,.      |
|             |      | .,.         |             | .,.  | .,.  .,.      |
| 800x600x8   |      | .,.         | 800x600x32  |      |               |
| 800x600x16  |      | .,.         | 1024x768x4  | .,.  | .,.           |
| 1024x768x4  | II"  | .4,.   .,.  | 1024x768x8  |      | .,.  II"      |
| 1024x768x8  |      | .,.         |             |      | .II,".        |
1024x768x16
| 1024x768x16 (lL)  |     | .,.  .,.  | 1024x768x32 (ILl  | .,.  | .,.           |
| ----------------- | --- | --------- | ----------------- | ---- | ------------- |
| 1152x864x8        |     | .,.  .,.  | 1152x864x8        | .,.  | .,.  .II,".   |
.,.
| 1280x1024x4       |     |      | 1280x1024x4       |      | .,.           |
| ----------------- | --- | ---- | ----------------- | ---- | ------------- |
| 1280x1024x8       |     | .,.  | 1280x1024x8       |      | .II,".        |
| 1600x1200x4 (ILl  |     | II"  | 1280x1024x16(1Ll  | .,.  | .,.           |
| 1600x1200x8 (ILl  |     |      | 1600x1200x4 (lL)  |      | .,.  I.I,".   |
II"
1600x1200x8 (IL)
Extended VGA text modes up to 132 columns by
43 rows are possible as well.
| 1 -4 MBVTES  |     |     | SDATA  |     |     |
| ------------ | --- | --- | ------ | --- | --- |
r-----'-l-J.~ GENERAL
|     | 14--f---1"  |     | 8   | DATA BUS  |     |
| --- | ----------- | --- | --- | --------- | --- |
32
I-_---'~ ANALOG
S3 Trio64
RGB
|     |     |     | ..  I  | •  FEATURE  |     |
| --- | --- | --- | ------ | ----------- | --- |
|     |     | 32  | 8/16   | CONNECTOR   |     |
TSYSBLK
Figure 1-1. PCI Bus System Block Diagram
INTRODUCTION  1-3

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated

....
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Section 2: Mechanical Data
2.1  THERMAL SPECIFICATIONS
| Parameter  | Min  | Typ  | Max  | Unit     |
| ---------- | ---- | ---- | ---- | -------- |
|            |      | 8    |      | °efI/IJ  |
Thermal Resistance 9JC
| Thermal Resistance 9JA (Still Air)  |     | 37   |       | °CfI/IJ  |
| ----------------------------------- | --- | ---- | ----- | -------- |
| Power Dissipation                   |     | 1.5  | 2.00  | W        |
| Junction Temperature                |     |      | 125   | °C       |
2.2  MECHANICAL DIMENSIONS
The Trio32 and Trio64 both come in a 208-pin PQFP package. The mechanical dimensions are given in
Figure 2-1.
MECHANICAL DATA 2-1

r-~ .
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
30.60:&0.30
29.60",0.20
LINEAR DIMENSIONS
ARE IN MILLIMETERS
0.50",0.20 mechdlm
Figure 2-1. 208-pin PQFP Mechanical Dimensions
2-2 MECHANICAL DATA

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Section 3: Pins
3.1 PINOUT DIAGRAMS
The Trio32 and Trio64 both come in a 208-pin PQFP package. The PCI bus pinout forthe Trio32 is shown
in Figure 3-1. The Trio32 pinout for the VESA local bus configuration is shown in Figure 3-2. The PCI
bus pinout for the Trio64 is shown in Figure 3-3. The Trio64 pinout for the VESA local bus configuration
is shown in Figure 3-4. Active low pins are indicated by an overbar. N/C indicates a no connect.
PINS 3-1

..ta
p• .
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
=
CLKA:~~  m ~   ; ; ! ! ; ; ~ ! i ~ i ; ~ ~  a;  I ; aa ;  ;  ~  aa a ;  ; agE; ! ! e ~     e!  e ~     E!  ! !  ::014
;
| AVIS      |     | PD1   |
| --------- | --- | ----- |
| CLKAVDD2  |     | PD13  |
| AVIS      |     | PD2   |
| VREF      |     | VSS   |
| VSS       |     | P012  |
| AVDD      |     | P03   |
| COMP      |     | VDD   |
| RSET      |     | PDn   |
PO,
A~
| AR    |     | P010  |
| ----- | --- | ----- |
| AWD   |     | POS   |
| AVDD  |     | POI   |
M
| AI  |     | ~   |
| --- | --- | --- |
~
| AVSS  |     | P07    |
| ----- | --- | ------ |
| AWD   |     | VIS    |
| VSS   |     | CAsi   |
| GOO   |     | Ciii   |
| GDl   |     | iiiSo  |
| GD2   |     | CAi2   |
Ciii
GO!
| G04  |             | VDD  |
| ---- | ----------- | ---- |
| GDS  |             | MAl  |
| :~~  | Trio32-PCI  | :;   |
|      | TOP VIEW    | :!   |
:~
| GA1      |     | MA2   |
| -------- | --- | ----- |
| G~       |     | MU    |
| GA3      |     | MA3   |
| GA4      |     | MA4   |
| GAS      |     | VIS   |
| GAS      |     | POI'  |
| VDD      |     | PO,.  |
| iiE'iET  |     | PD30  |
| SClK     |     | PO'7  |
| VBS      |     | PD2I  |
| GA7      |     | PO,S  |
| GAB      |     | PD28  |
| GAg      |     | PO,.  |
| GA10     |     | VDD   |
| CAn      |     | PD27  |
| GA12     |     | vas   |
| GA13     |     | PD20  |
| GA1'     |     | POI.  |
| GA1S     |     | P02l  |
| ~c       |     | PDH   |
| VDD      |     | PDD   |
| AD3'     |     | PD24  |
AOOO --'nTn~~~~~TnTnTnnTnT~~TnTnnTnT~~~Tn~nT~~~TnTnnTnT~~~--~D
Figure 3-1. Trio32 PCI Bus Configuration Pinout
3-2  PINS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
| XOUT      |     | PlIO      |
| --------- | --- | --------- |
| ClKAVDDl  |     | PD14      |
| AVSS      |     | PPDO., .  |
ct.KAVDD2
| AVSS  |     | Po.   |
| ----- | --- | ----- |
| VA"F  |     | vss   |
| VSS   |     | PD12  |
pm
AWD
| COMP  |     | VOD     |
| ----- | --- | ------- |
| RSET  |     | P011    |
| AVSS  |     | PD4     |
| AR    |     | POlO    |
| AVDD  |     | PD6     |
| AVDD  |     | Pm      |
| ~     |     | PlIO    |
| M     |     | PlIO    |
| AVSS  |     | PD7     |
| AVDD  |     | VSS     |
| vss   |     | CAii    |
| SAZ   |     | CAii    |
| SAl   |     | iiAsii  |
CAii
8M
| 8AS  |                | Cii3  |
| ---- | -------------- | ----- |
| SA6  |                | VDD   |
| SA7  |                | MAl   |
| ~:   | Trio32-VL-BUS  | ::    |
::!
| .'.:.~:                                               | TOP VIEW  |       |
| ----------------------------------------------------- | --------- | ----- |
| ~11                                                   |           | MU    |
| SA12                                                  |           | MAS   |
| &All                                                  |           | MA3   |
| SA14                                                  |           | MA4   |
| SA1S                                                  |           | vas   |
| SAl6                                                  |           | POll  |
| VDD                                                   |           | PDl1  |
| SiiEffi                                               |           | POlO  |
| SCLK                                                  |           | PD17  |
| VSS                                                   |           | PD28  |
| SA17                                                  |           | PD18  |
| SA1S                                                  |           | POll  |
| SA19                                                  |           | PD,S  |
| ~~                                                    |           | ~     |
| ~,                                                    |           | PD~   |
| SA22                                                  |           | VSS   |
| SA23                                                  |           | POlO  |
| SA24                                                  |           | PD26  |
| SA25                                                  |           | PD2,  |
| SAZ6                                                  |           | PD2S  |
| VDO                                                   |           | PD22  |
| SD31                                                  |           | PDZ'  |
| SD~ --~~nT~~Tn~~nT~mn~~nT~mn~~nT~~~~nT~mn~~nT~~Tn~r-- |           | P02.  |
KWLPINS
Figure 3·2. Trio32 VL·Bus Configuration Pinout
PINS  3·3

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
| XOl!T     |     | PDO         |
| --------- | --- | ----------- |
| CLKAVDD1  |     | PD"         |
| AVSS      |     | PD.         |
| CLKAVDD2  |     | PD ••  POl  |
AVSS
| VREF  |     | vss   |
| ----- | --- | ----- |
| vss   |     | P012  |
| AVDD  |     | Po.   |
| COMP  |     | VDD   |
| RSET  |     | PDn   |
| AVSS  |     | PD4   |
| AR    |     | PD'O  |
| AVDD  |     | POS   |
| AVDD  |     | P09   |
| AG    |     | PDS   |
PDS
AB
| AVSS  |     | PD7     |
| ----- | --- | ------- |
| AVDD  |     | VS.     |
| vss   |     | CAsO    |
| GDO   |     | Cii 1   |
| GD.   |     | m o     |
em
| GDZ  |     | Cii3  |
| ---- | --- | ----- |
GD.  Go.
VDD
| GDS  |             | MAS  |
| ---- | ----------- | ---- |
| GDS  | Trio64-PCI  | MAO  |
| GD7  |             | MA7  |
| vss  |             | MA.  |
TOP VIEW
| GAO  |     | MAS  |
| ---- | --- | ---- |
| GA.  |     | MAl  |
| GAZ  |     | MAS  |
| GAS  |     | MAS  |
| GA.  |     | MAO  |
| GAS  |     | VBS  |
P031
GAS
| VDD    |     | PD16      |
| ------ | --- | --------- |
| RESET  |     | POlO      |
| SCLK   |     | PD17      |
| VSS    |     | PDZ9      |
| GA7    |     | PD18      |
| GAS    |     | PD28      |
| GA.    |     | VOD  PO"  |
GA10
| GA11     |     | PDZ7   |
| -------- | --- | ------ |
| GA.z     |     | VSS    |
| GA.3  •  |     | POlO   |
| GA• •    |     | PDZ6   |
| GA15     |     | P021   |
| N/e      |     | PDZS   |
| VDD      |     | PD ••  |
| AD31     |     | POl.   |
AD30 --~MTMT~~TM~MTMT~TnTM~MTMT~TnTM~~MTMT~TnTM~MTMTnTTn~~MTMT~TnTM~-POl'
KPCIPINS
Figure 3·3. Trio64 PCI Bus Configuration Pinout
3-4  PINS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
| XOUT      |     | PDO    |
| --------- | --- | ------ |
| CLKAVDD1  |     | P014   |
| AVSS      |     | PD,    |
| CLKAVDD2  |     | P013   |
| AVSS      |     | POl    |
| VREF      |     | vss    |
| VSS       |     | PD'2   |
| AWD       |     | PD3    |
| COMP      |     | VDD    |
| RSET      |     | PD"    |
| AVOS      |     | PO<    |
| AR        |     | PD,.   |
| AWD       |     | PDB    |
| AWD       |     | PD9    |
| AG        |     | PDB    |
| AS        |     | PDB    |
| AVSS      |     | PD7    |
| AWD       |     | vss    |
| VSS       |     | CAsij  |
| SA2       |     | CAs'i  |
iiAsii
SA3
| SA4  |                | CAS2  |
| ---- | -------------- | ----- |
| SA'  |                | CAsi  |
| SA.  |                | WD    |
| SA7  |                | MAO   |
| SAS  | Trio64-VL-BUS  | MAO   |
SA.
MA7
| VSS   | TOP VIEW  | MA'  |
| ----- | --------- | ---- |
| SA'.  |           | MAS  |
| SA"   |           | MA>  |
| SA'2  |           | MAS  |
| SA13  |           | MAl  |
MAO
| SA"  |     | vss  |
| ---- | --- | ---- |
SA15
| SA16       |     | POl'     |
| ---------- | --- | -------- |
| WD         |     | P016     |
| SRESET     |     | PD30     |
| seLK       |     | PD17     |
| VSS        |     | PD2S     |
| SA17       |     | PD18     |
| SA'.       |     | PD28     |
| SSAAl'..   |     | P D ,.   |
V O D
| SA21     |     | PD27  |
| -------- | --- | ----- |
| SA22     |     | VSS   |
| SA23  •  |     | P020  |
| SA24     |     | P026  |
| SA2'     |     | P021  |
| SA2.     |     | P026  |
| WO       |     | PD22  |
| S031     |     | P024  |
| SD30     |     | P023  |
KVlPINS
Figure 3-4. Trio64 VL-Bus Configuration Pinout
PINS  3-5

S3 Trio32ITrio64 Integrated Graphics Accelerators
53 Incorporatad
3.2  PIN DESCRIPTIONS
The following table provides a brief description of each pin on the Tri032/TrioS4 for their PCI bus and
VL-Bus configurations. The pin functions the same for both Tri032 and TrioS4 unless otherwise noted.
The following definitions are used in these descriptions:
I -Input signal
o - Output signal
B -Bidirectional signal
Some pins have multiple names. This either reflects the different functions performed by those pins
depending on the bus configuration selected by power-on-strapping or multiplexed pins whose
functions are selected via a register bit setting. The pin definitions and functions are given for each
possible case.
Table 3-1.  Pin Descriptions
| Symbol  | Type  Pin Number!s)  | Description  |
| ------- | -------------------- | ------------ |
BUS INTERFACES
Address and Data
AD[31:0)  B  207-208, 1-6,  (PCI) Multiplexed Address/Data Bus. A bus transaction
|     | 10-11, 13-18,  | (cycle) consists of an address phase followed by one  |
| --- | -------------- | ----------------------------------------------------- |
|     | 28-31, 33-36,  | or more data phases.                                  |
39-46
| SD[31:0)  | B   | (VL) System Data Bus.  |
| --------- | --- | ---------------------- |
SA[31:28)  I  122,120,118,  (VL) System Address Bus Lines 31 :28. If bit 7 of CR68
|     | 116  | is set to 1, these pins function as SA[31 :28).  |
| --- | ---- | ------------------------------------------------ |
Otherwise, they function as PD lines for a 64-bit
memory bus for the Tri064 or are no connects for the
Tri032.
SAUP/SA27  I  25  (VL) Upper Address Decode/System Address Bus Line
27. If bit 7 of CR68 is cleared to 0, this pin functions as
SA27. Otherwise, this pin is the input for an upper
address line decode indicating an access to the
Tri032/Tri064 memory space. The SAUP functionality
will normally not be used with the Tri032.
| SA26      | I  205          | (VL) System Address Bus Line 26.  |
| --------- | --------------- | --------------------------------- |
| GA[15:0)  | B  204-196,191- | (PCI) BIOS ROM Address Bus.       |
185
| SA[25:10)  | B           | (VL) System Address Bus Lines 25:10.  |
| ---------- | ----------- | ------------------------------------- |
| GD[7:0)    | B  183-176  | (PCI) General Data Bus.               |
| SA[9:2)    | B           | (VL) System Address Bus Lines 9:2.    |
3-S  PINS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table 3-1. Pin Descriptions (Continued)
| Symbol  | Type  Pin Number(s)  | Description  |
| ------- | -------------------- | ------------ |
C/BE[3:0]  I  7,19,27,38  (PCI) Bus Command/Data Byte Enables. These signals
carry the bus command during the address phase and
the byte enables during the data phase.
| SBE[3:0]  |     | (VL) Data Byte Enables.  |
| --------- | --- | ------------------------ |
Bus Control
| SCLK   | I  194  | (PCI) PCI System Clock.   |
| ------ | ------- | ------------------------- |
| SCLK   | I       | (VU CPU System Clock      |
| INTA   | 0  152  | (PCI) Interrupt Request.  |
| SINTR  |         | (VU Interrupt Request.    |
IRDY  I  21  (PCI) Initiator Ready. A bus data phase is completed
when both IRDY and TRDY are asserted on the same
cycle.
| RDYIN  |     | (VU Local Bus Cycle End Acknowledge. The  |
| ------ | --- | ----------------------------------------- |
Trio32/Trio64 holds read data valid on the system data
bus until this input is asserted.
TRDY  0  23  (PCI) Target Ready. A bus data phase is completed
when both IRDY and TRDY are asserted on the same
cycle.
| SRDY  |     | (VU Local Bus Cycle End.  |
| ----- | --- | ------------------------- |
DEVSEL  0  24  (PCI) Device Select. The Tri032/Tri064 drives this
signal active when it decodes its address as the target
of the current access.
| LOCA  |     | (VL) Local Bus Access Cycle Indicator. This signal is  |
| ----- | --- | ------------------------------------------------------ |
output during local bus cycles to allow system logic
chip sets to prevent concurrent EISNISA cycle
aeneration.
IDSEL  I  8  (PCI) Initialization Device Select. This input is the chip
select for PCI configuration register readslwrites.
SM/IO  I  (VL) Memory/I/O Cycle Indicator. This signal is high for
a memory cycle and low for an I/O cycle.
RESET  I  193  (PCI) System Reset. Asserting this signal forces the
registers and state machines to a known state.
| SRESET  |     | (VU System Reset.  |
| ------- | --- | ------------------ |
FRAME  I  20  (PCI) Cycle Frame. This signal is asserted by the bus
master to indicate the beginning of a bus transaction.
It is deasserted during the final data phase of a bus
transaction.
| SADS  |     | (VU System Address Strobe.  |
| ----- | --- | --------------------------- |
PINS  3-7

....
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Table 3-1. Pin Descriptions (Continued)
Symbol Type Pin Number(s) Description
PAR 0 26 (PCI) Parity. The Tri032[Tri064 asserts this signal to
verify even parity during reads.
SW/R I (VL) Write/Read Cycle Indicator. This signal is high for
a write and low for a read.
STOP 0 25 (PCI) Stop. The Tri032[Tri064 asserts this signal to
indicate a target disconnect.
SAUP/SA27 (VL) Upper Address Decode/System Address Bus Line
27. If bit 7 of CR68 is cleared to 0, this pin functions as
SA27. Otherwise, this pin is the input for an upper
address line decode indicating an access to the
Tri032[Tri064 memory space. The SAUP functionality
will normally not be used with the Tri032.
CLOCK CONTROL
XIN I 156 Reference Frequency Input. If an external crystal is
used, it is connected between XOUT and this pin. A
stable external frequency source can also be input via
this pin. If PD11 is strapped low at power-on, this
becomes the DCLK (dot clock) input, bypassing the
internal oscillator. This is normally only used for test
purposes.
XOUT 0 157 Crystal Output. If an external 14.318 MHz crystal is
used, it is connected between XIN and this pin. This
pin drives the crystal via an internal oscillator.
DISPLAY MEMORY INTERFACE
Address and Data
PD[63:32] B 122, 120, 118, Display Memory Pixel Data Bus Lines 63:32. These
116, 113, 111, signals are available only on the Tri064. Certain of
109,107,106, these pins° a re enabled for feature connector operation
108, 110, 112, when bit of SRD is set to 1 or as system address
115,117,119, lines if bit 7 of CR68 is set to 1 .
121,144,142,
140,138,134,
132,130,128,
127,129,131,
133,136,139,
141,143
PD[31:0] B 70, 68, 66, 64, Display Memory Pixel Data Bus Lines 31 :0. PD[23-0]
61, 58, 56, 54, are also used as the system configuration strapping
53, 55, 57, 59, bits, providing system configuration and setup
63, 65, 67, 69, information upon power-on or reset.
105,103,101,
98, 95, 93, 91,
89, 88, 90, 92,
94,97,100,
102,104
3-8 PINS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table 3-1. Pin Descriptions (Continued)
Symbol Type Pin Number(s) Description
MA[8:0) 0 80, 78, 76, 74, Memory Address Bus. The video memory row and
72, 73, 75, 77, column addresses are multiplexed on these lines.
79
Memory Control
RAS[1:0) 0 50,84 Row Address Strobes. For the Tri064, RASl is output
on pin 50 when bit 2 of CR36 is set to 1 (fast page
mode memory) and bit 6 of SRA is set to 1. RASl is
used to select the upper 2 MBytes of a 4-MByte fast
page mode memory configuration. It is not available
for EOO memory operation, limiting EOO
configurations to 2 MBytes. For the Tri032, pin 50
always acts as RASl and selects the second MByte of
memory (either fast page or EOO).
CAS[7:4] 0 52, 51,49,48 Column Address Strobe Lines 7:4. These are available
only on the Tri064. They are not driven when the
feature connector is enabled by setting bit 0 of SRO to
1 . This prevents contention on the multiplexed PO
lines when using fast page mode memory.
CAS[3:0] 0 82,83,85,86 Column Address Strobe Lines 3:0.
WE 0 125 Write Enable.
OE[1:0) 0 50,124 Output Enables. For the Tri064, OEl is output on pin
50 when bit 2 of CR36 is cleared to 0 (EDO memory).
If the feature connector is disabled (bit 0 of SRO
cleared to 0), this output is the same as OEO (for 64-bit
PO bus operation). If the feature connector is enabled
(bit 0 of SRO set to 1), OEl is held high (not asserted).
This ensures that EOO memory data is not driven on
the multiplexed PO lines when the feature connector
is enabled. OEl is never generated for the Trio64 in
fast page mode operation. Instead, if bit 6 of SRA is
cleared to 0 (default). a second OEO signal is output on
pin 50. This allows the same board to use either fast
page or EOO memory in 2-MByte designs with no
additional hardware. OEl is not generated on the
Trio32 because the feature connector signals are not
multiplexed on PO lines.
VIDEO INTERFACE
COMP 165 Compensation Pin. This pin is tied to VDD through a 0.1
I1F capacitor.
VREF 162 Voltage Reference. This pin is tied to Vss through a 0.1
I1F capacitor.
RSET 166 Reference Resistor. This pin is tied to Vss through an
external resistor to control the full-scale current value.
AR 0 168 Analog Red. Analog red output to the monitor.
PINS 3-9

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table 3·1. Pin Descriptions (Continued)
~_mbol Type Pin Number(s) Description
AG 0 171 Analog Green. Analog green output to the monitor.
AB 0 172 Analog Blue. Analog blue signal to the monitor.
ENFEAT 0 151 Enable Feature Connector. Setting bit 0 of SRD to 1
drives this signal low. It is used to enable the feature
connector buffers required in Trio64 memory
configurations of 2 MBytes or larger.
BLANK B 155 Video Blank. This signal is multiplexed with the BGNT
signal. This pin functions as BLANK when bit 0 of SRD
is set to 1 and as BGNT when bit 0 of SRD is cleared
to O. When ESYNC is high, BLANK is a feature
connector output. When ESYNC is low, BLANK is a
feature connector input that, when driven low, turns
off the video output.
ESYNC I 109 External SYNC. This signal is multiplexed with PD57
on the Trio64. Setting bit 0 of SRD to 1 selects the
ESYNC input function. When ESYNC is driven low,
HSYNC, VSYNC and BLANK become inputs. When
ESYNC is high, HSYNC and VSYNC are tri-stated and
BLANK becomes an output to the feature connector.
EVIDEO I 111 External Video. This signal is multiplexed with PD58 on
the Trio64. Setting bit 0 of SRD to 1 for the Trio64
selects the EVIDEO function. When this input is
asserted low, PA[15:0] are inputs and are sampled by
VCLKI. When this input is high, PA[15:0] are outputs to
the feature connector.
EVCLK I 113 External VCLK. This signal is multiplexed with PD59 on
the Trio64. Setting bit 0 of SRD to 1 selects the EVCLK
function. When this input is asserted low, VCLK is an
input to the internal RAMDAC. When this input is high,
VCLK is output to the feature connector.
VCLK B 148 Video/pixel Clock. When EVCLK is high, this signal is
an output to the feature connector. When EVCLK is
low, this becomes an input used only for test
purposes.
VCLKI I 106 VCLK Input. This signal is multiplexed with PD55 on
the Trio64. Enabling the feature connector selects the
VCLKI function. Setting bit 1 of SRB to 1 causes VCLKI
to be used to clock in feature connector pixel data to
the internal RAMDAC.
HSYNC 0 149 Horizontal Sync. When ESYNC is high, this signal is an
output to the feature connector. It is tri-stated when
ESYNC is low.
3-10 PINS

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad
Table 3·1. Pin Descriptions (Continued)
Symbol Type Pin Number(s) Description
VSYNC B 150 Vertical Sync. When ESYNC is high, this signal is an
output to the feature connector. It is tri-stated when
ESYNC is low unless bit 0 of CR56 is set to 1. In this
case, this signal becomes an input for genlocking.
PA[15:0J B 144,142,140, Pixel Address Lines [15:0J. These signals are
138,134,132, multiplexed with PD signals on the Trio64. Setting bit
o
130,128,127, of SRD to 1 selects the PA[15:0J function. When
129,131,133, EVIDEO is high, PA[15:0J are outputs to the feature
136,139,141, connector. When EVIDEO is low, PA[15:0J are inputs
143 and are sampled by VCLKI.
MISCELLANEOUS FUNCTIONS
General Data Port
GA[15:0J 0 204-196,191- (PCI) General Address Bus. These signals provide the
185 address for BIOS ROM reads.
GD[7:0J B 206-199 (PCI) General Data Bus. These signals carry data for
BIOS ROM reads, General Output Port output and
General Input Port input.
ROMEN 0 153 (PCI) ROM Enable. This signal provides the chip output
enable input for BIOS ROM reads.
(VL) ROM Chip Select. This signal provides the chip
ROMCS output enable for BIOS ROM reads.
SD[15:8J 0 28-31,33-36 (VU System Data Bus 15:8. When data is written to
the General Output Port register (CR5C), STWR is
asserted to strobe the contents of this register into the
extemal GOP reaister. The data is driven via SD[15:8}.
STWR 0 147 General Output Port Write Strobe. Write strobe for the
General Output Port (CR5C) buffer.
SD[7:0J I 39-46 (VL) System Data Bus 7:0. When bit 2 of CR55 is set
to 1 to enable the General Input Port function, a read
of 3C8H asserts STRD. This strobes the GIP buffer
and drives the contents of this buffer onto SD[7:0J.
STRD 0 146 General Input Port Read Strobe. This signal is asserted
to strobe the General Input Port buffer when bit 2 of
CR55 is set to 1 and the 3C8H port is read.
Bus Master Control
BREQ I 154 Bus Request. When bit 2 of CR50 is set to 1, this is
the Bus Request input from another display memory
master. This supports shared frame buffer operation.
The appropriate input signal must be selected by
external hardware.
PINS 3-11

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table 3·1. Pin Descriptions (Continued)
Symbol Type Pin Number(s) Description
BGNT 0 155 Bus Grant. This signal is multiplexed with the BLANK
signal. This pin functions as BLANK when bit 0 of SRD
is set to 1 and as BGNT when bit 0 of SRD is cleared
to O. Bit 2 of CR50 must be set to 1 to enable bus
request/bus grant operation. The Trio32rrrio64 asserts
this signal in response to a BREQ input to notify
another display memory master that it can take control
of the display memory bus. The Trio32rrrio64 raises
this signal to reclaim bus control.
POWER AND GROUND
VDD I 12,37,62,81, Digital power supply
96, 137, 192,
206
AVDD I 164,169,170, Analog power supply (RAMDAC)
174
CLKAVDD[l :2J I 158,160 Analog power supply (clock synthesizer)
VSS I 9,22,32,47, Digital ground
60,71,87,
114, 123, 126,
135,145,163,
175,184,195
AVSS I 159,161,167, Analog ground
173
3-12 PINS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
3.3  PIN LISTS
Table 3-2 lists all Trio32rrrio64 pins alphabetically. The pin number(s) corresponding to each pin name
are given in the appropriate chip/bus interface type column. Table 3-3 lists all Trio32rrrio64 pins in
numerical order. The pin name corresponding to each pin number is given in the appropriate chip/bus
interface column.
Table 3-2.  Alphabetical Pin Listing
PIN(S)
| Name      | Trio32 PCI            | Trio32 VL  | Trio64 PCI            | Trio64 VL  |
| --------- | --------------------- | ---------- | --------------------- | ---------- |
| AB        | 172                   | 172        | 172                   | 172        |
| AD[31:0)  | 207-208, 1-6, 10-11,  |            | 207-208, 1-6, 10-11,  |            |
|           | 13-18, 28-31, 33-36,  |            | 13-18, 28-31, 33-36,  |            |
|           | 39-46                 |            | 39-46                 |            |
| AG        | 171                   | 171        | 171                   | 171        |
| AR        | 168                   | 168        | 168                   | 168        |
AVDD  164,169,170,174  164,169,170,174  164,169,170,174  164,169,170,174
AVSS  159,161,167,173  159,161,167,173  159,161,167,173  159,161,167,173
| BGNT   | 155  | 155  | 155  | 155  |
| ------ | ---- | ---- | ---- | ---- |
| BLANK  | 155  | 155  | 155  | 155  |
| BREQ   | 154  | 154  | 154  | 154  |
CAS[3:0)  82,83,85,86  82,83,85,86  82,83,85,86  82,83,85,86
| CAS[7:4)       |             |          | 52,51,49,48  | 52,51,49,48  |
| -------------- | ----------- | -------- | ------------ | ------------ |
| C/BE[3:0)      | 7,19,27,38  |          | 7,19,27,38   |              |
| CLKAVDD[l :2)  | 158,160     | 158,160  | 158,160      | 158,160      |
| COMP           | 165         | 165      | 165          | 165          |
| DEVSEL         | 24          |          | 24           |              |
| ENFEAT         | 151         | 151      | 151          | 151          |
| ESYNC          | 109         | 109      | 109          | 109          |
| EVCLK          | 113         | 113      | 113          | 113          |
| EVIDEO         | 111         | 111      | 111          | 111          |
| FRAME          | 20          |          | 20           |              |
GA[15:0)
|          | 204-196,191-185  |      | 204-196, 191-185  |      |
| -------- | ---------------- | ---- | ----------------- | ---- |
| GD[7:0)  | 183-176          |      | 183-176           |      |
| HSYNC    | 149              | 149  | 149               | 149  |
| IDSEL    | 8                |      | 8                 |      |
| INTA     | 152              |      | 152               |      |
| IRDY     | 21               |      | 21                |      |
| LOCA     |                  | 24   |                   | 24   |
MA[8:0)  80, 78, 76, 74, 72,  80,78,76,74,72,  80,78,76,74,72,  80,78,76,74,72,
73, 75, 77, 79  73, 75, 77, 79  73, 75, 77, 79  73, 75, 77, 79
| OEO  | 124  | 124  | 124  | 124  |
| ---- | ---- | ---- | ---- | ---- |
| OEl  |      |      | 50   | 50   |
PINS  3-13

S3 Trio32/Trio64 Integrated Graphics Accelerators
531ncorporatad
Table 3-2. Alphabetical Pin Listing (Continued)
PIN(S)
| Name  | Tri032 PCI  | Tri032VL  | Trio64 PCI  | Trio64 VL  |
| ----- | ----------- | --------- | ----------- | ---------- |
PA[15:0]  144,142,140,138,  144,142,140,138,  144, 142, 140, 138,  144, 142, 140, 138,
134,132,130,128,  134,132,130,128,  134,132,130,128,  134,132,130,128,
127,129,131,133,  127,129,131,133,  127,129,131,133,  127,129,131,133,
136,139,141,143  136,139,141,143  136,139,141,143  136,139,141,143
PAR
|           | 26  |     | 26                    |                       |
| --------- | --- | --- | --------------------- | --------------------- |
| PD[63:0]  |     |     | 122, 120, 118, 116,   | 122, 120, 118, 116,   |
|           |     |     | 113, 111, 109, 107,   | 113,111,109,107,      |
|           |     |     | 106, 108, 11 0, 112,  | 106, 108, 11 0, 112,  |
|           |     |     | 115,117,119,121,      | 115,117,119,121,      |
|           |     |     | 144,142,140, 138,     | 144,142,140,138,      |
|           |     |     | 134,132,130,128,      | 134,132,130,128,      |
|           |     |     | 127,129,131,133       | 127,129,131,133       |
|           |     |     | 136,139,141,143,      | 136,139,141,143,      |
70, 68, 66, 64, 61,  70, 68, 66, 64, 61,  70, 68, 66, 64, 61,  70, 68, 66, 64, 61,
58, 56, 54, 53, 55,  58, 56, 54, 53, 55,  ..  58, 56, 54, 53, 55,  58, 56, 54, 53, 55,
57, 59, 63, 65, 67,  57, 59, 63, 65, 67,  57, 59, 63, 65, 67,  57, 59, 63, 65, 67,
69,105,103,101,  69,105,103,101,  69,105,103,101,  69,105,103,101,
98, 95, 93, 91, 89,  98, 95, 93, 91, 89,  98,95,93,91,89,  98, 95, 93, 91, 89,
88, 90, 92, 94, 97,  88, 90, 92, 94, 97,  88, 90, 92, 94, 97,  88, 90, 92, 94, 97,
|           | 100,102,104  | 100, 102, 104         | 100,102,104  | 100,102, 104          |
| --------- | ------------ | --------------------- | ------------ | --------------------- |
| RAS[1:0]  | 50,84        | 50, 84                | 50,84        | 50,84                 |
| RESET     | 193          |                       | 193          |                       |
| RDYIN     |              | 21                    |              | 21                    |
| ROMEN     | 153          |                       | 153          |                       |
| ROMCS     |              | 153                   |              | 153                   |
| RSET      | 166          | 166                   | 166          | 166                   |
| SA[31:2]  |              | 122, 120, 118, 116,   |              | 122, 120, 118, 116,   |
|           |              | 25, 205-196, 191-     |              | 25, 205-196, 191-     |
|           |              | 185,183-176           |              | 185,183-176           |
| SADS      |              | 20                    |              | 20                    |
| SAUP      |              | 25                    |              | 25                    |
| SBE[3:0]  |              | 7,19,27,38            |              | 7,19,27,38            |
| SCLK      | 194          | 194                   | 194          | 194                   |
| SD[31:0]  |              | 207-208, 1-6, 10-11,  |              | 207-208, 1-6, 10-11,  |
|           |              | 13-18, 28-31, 33-36,  |              | 13-18, 28-31, 33-36,  |
|           |              | 39-46                 |              | 39-46                 |
| SINTR     |              | 152                   |              | 152                   |
| SM/IO     |              | 8                     |              | 8                     |
| SRDY      |              | 23                    |              | 23                    |
| SRESET    |              | 193                   |              | 193                   |
STOP
|       | 25   |      | 25   |      |
| ----- | ---- | ---- | ---- | ---- |
| S1WR  | 147  | 147  | 147  | 147  |
| SW/R  |      | 26   |      | 26   |
| TRDY  | 23   |      | 23   |      |
3-14  PINS

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table 3-2. Alphabetical Pin Listing (Continued)
PIN(S)
| Name  | Trio32 PCI  | Trio32VL  | Trio64 PCI  | Trio64 VL  |
| ----- | ----------- | --------- | ----------- | ---------- |
| VCLK  | 148         | 148       | 148         | 148        |
VCLKI
|     | 106  | 106  | 106  | 106  |
| --- | ---- | ---- | ---- | ---- |
VDD
12, 37, 62, 81, 96,  12, 37, 62, 81, 96,  12,37,62,81,96,  12,37,62,81,96,
|       | 137,192,206  | 137,192,206  | 137,192,206  | 137,192,206  |
| ----- | ------------ | ------------ | ------------ | ------------ |
| VREF  | 162          | 162          | 162          | 162          |
VSS  9,22,32,47,60,  9,22,32,47,60,  9,22,32,47,60,  9, 22, 32, 47, 60,
71,87,114,123,  71,87,114,123,  71,87, 114, 123,  71,87,114,123,
126,135,145,163  126,135,145,163  126,135,145,163  126,135,145,163
|        | 175,184,195  | 175,184,195  | 175,184,195  | 175,184,195  |
| ------ | ------------ | ------------ | ------------ | ------------ |
| VSYNC  | 150          | 150          | 150          | 150          |
| WE     | 125          | 125          | 125          | 125          |
| XIN    | 156          | 156          | 156          | 156          |
| XOUT   | 157          | 157          | 157          | 157          |
PINS  3-15

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table 3-3.  Numerical Pin Listing
Name
| Number  | Trio32 PCI  | Trio32 VL  | Trio64 PCI  | Trio64 VL  |
| ------- | ----------- | ---------- | ----------- | ---------- |
| 1       | A029        | S029       | A029        | S029       |
| 2       | A028        | S028       | A028        | S028       |
| 3       | A027        | S027       | A027        | S027       |
| 4       | A026        | S026       | A026        | S026       |
A025
| 5   |        | S025   | A025   | S025   |
| --- | ------ | ------ | ------ | ------ |
| 6   | A024   | S024   | A024   | S024   |
| 7   | C/SE3  | SSE3   | C/SE3  | SSE3   |
| 8   | 10SEL  | SM/IO  | 10SEL  | SM/IO  |
| 9   | VSS    | VSS    | VSS    | VSS    |
| 10  | A023   | S023   | A023   | S023   |
| 11  | A022   | S022   | A022   | S022   |
| 12  | VDD    | VDD    | VDD    | VDD    |
| 13  | A021   | S021   | A021   | S021   |
| 14  | A020   | S020   | A020   | S020   |
| 15  | A019   | S019   | A019   | S019   |
| 16  | A018   | S018   | A018   | S018   |
| 17  | A017   | S017   | A017   | S017   |
| 18  | A016   | S016   | A016   | S016   |
| 19  | C/SE2  | SSE2   | C/SE2  | SSE2   |
| 20  | FRAME  | SAOS   | FRAME  | SAOS   |
ROYIN
| 21  | IROY    | ROYIN      | IROY    |            |
| --- | ------- | ---------- | ------- | ---------- |
| 22  | VSS     | VSS        | VSS     | VSS        |
| 23  | TROY    | SROY       | TROY    | SROY       |
| 24  | OEVSEL  | LOCA       | OEVSEL  | LOCA       |
| 25  | STOP    | SAUP/SA27  | STOP    | SAUP/SA27  |
| 26  | PAR     | SW/R       | PAR     | SW/R       |
| 27  | C/SEl   | SSEl       | C/SEl   | SSEl       |
| 28  | A015    | S015       | A015    | S015       |
| 29  | A014    | S014       | A014    | S014       |
| 30  | A013    | S013       | A013    | S013       |
| 31  | A012    | S012       | A012    | S012       |
| 32  | VSS     | VSS        | VSS     | VSS        |
| 33  | AOll    | S011       | A011    | SOll       |
| 34  | A010    | SOlO       | A010    | SOlO       |
| 35  | A09     | S09        | A09     | S09        |
| 36  | A08     | S08        | A08     | S08        |
| 37  | VDD     | VDD        | VDD     | VDD        |
| 38  | C/SEO   | SSEO       | C/SEO   | SSEO       |
| 39  | A07     | S07        | A07     | S07        |
| 40  | A06     | S06        | A06     | S06        |
| 41  | A05     | S05        | A05     | S05        |
| 42  | A04     | S04        | A04     | S04        |
3-16  PINS

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table 3-3. Numerical Pin Listing (Continued)
Name
| Number  | Trio32 PCI  | Trio32 VL  | Trio64 PCI  | Trio64VL   |
| ------- | ----------- | ---------- | ----------- | ---------- |
| 43      | AD3         | SD3        | AD3         | SD3        |
| 44      | AD2         | SD2        | AD2         | SD2        |
| 45      | ADl         | SOl        | AOl         | SOl        |
| 46      | ADO         | SOO        | AOO         | SOO        |
| 47      | VSS         | VSS        | VSS         | VSS        |
| 48      | N/C         | N/C        | CAS4        | CAS4       |
| 49      | N/C         | N/C        | CAS 5       | CAS5       |
| 50      | RASl        | RASl       | RAS1/OEl    | RAS1//OEl  |
| 51      | N/C         | N/C        | CAS6        | CAS6       |
| 52      | N/C         | N/C        | CAS7        | CAS7       |
| 53      | PD23        | P023       | P023        | P023       |
| 54      | PD24        | P024       | P024        | P024       |
| 55      | PD22        | P022       | P022        | P022       |
| 56      | P025        | P025       | P025        | P025       |
| 57      | PD21        | P021       | P021        | PD21       |
| 58      | P026        | P026       | P026        | P026       |
| 59      | P020        | P020       | P020        | P020       |
| 60      | VSS         | VSS        | VSS         | VSS        |
| 61      | PD27        | P027       | P027        | P027       |
| 62      | VDD         | VDD        | VDD         | VDD        |
| 63      | P019        | P019       | P019        | P019       |
| 64      | PD28        | P028       | PD28        | PD28       |
| 65      | PD18        | P018       | P018        | P018       |
| 66      | PD29        | P029       | P029        | P029       |
| 67      | PD17        | P017       | P017        | P017       |
| 68      | P030        | P030       | P030        | P030       |
| 69      | PD16        | P016       | P016        | P016       |
| 70      | P031        | PD31       | P031        | P031       |
| 71      | VSS         | VSS        | VSS         | VSS        |
| 72      | MA4         | MA4        | MA4         | MA4        |
| 73      | MA3         | MA3        | MA3         | MA3        |
| 74      | MA5         | MA5        | MA5         | MA5        |
| 75      | MA2         | MA2        | MA2         | MA2        |
| 76      | MA6         | MA6        | MA6         | MA6        |
| 77      | MAl         | MAl        | MAl         | MAl        |
| 78      | MA7         | MA7        | MA7         | MA7        |
| 79      | MAO         | MAO        | MAO         | MAO        |
| 80      | MA8         | MA8        | MA8         | MA8        |
| 81      | VDD         | VDD        | VDD         | VDD        |
| 82      | CAS3        | CAS3       | CAS3        | CAS3       |
| 83      | CAS2        | CAS2       | CAS2        | CAS2       |
| 84      | RASO        | RASO       | RASO        | RASO       |
PINS  3-17

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Inco.po.atad
Table 3·3. Numerical Pin Listing (Continued)
Name
| Number  | Trio32 PCI  | Trio32VL  | Trio64 PCI  | Trio64 VL  |
| ------- | ----------- | --------- | ----------- | ---------- |
| 85      | CAS1        | CAS1      | CAS1        | CAS 1      |
| 86      | CASO        | CASO      | CASO        | CASO       |
| 87      | VSS         | VSS       | VSS         | VSS        |
| 88      | PD7         | PD7       | PD7         | PD7        |
| 89      | PD8         | PD8       | PD8         | PD8        |
| 90      | PD6         | PD6       | PD6         | PD6        |
| 91      | PD9         | PD9       | PD9         | PD9        |
| 92      | PD5         | PD5       | PD5         | PD5        |
| 93      | PD10        | PD10      | PD10        | PD10       |
| 94      | PD4         | PD4       | PD4         | PD4        |
| 95      | PD11        | PD11      | PD11        | PD11       |
| 96      | VDD         | VDD       | VDD         | VDD        |
| 97      | PD3         | PD3       | PD3         | PD3        |
| 98      | PD12        | PD12      | PD12        | PD12       |
| 99      | VSS         | VSS       | VSS         | VSS        |
| 100     | PD2         | PD2       | PD2         | PD2        |
| 101     | PD13        | PD13      | PD13        | PD13       |
| 102     | PD1         | PD1       | PD1         | PD1        |
| 103     | PD14        | PD14      | PD14        | PD14       |
| 104     | PDO         | PDO       | PDO         | PDO        |
| 105     | PD15        | PD15      | PD15        | PD15       |
| 106     | VCLKI       | VCLKI     | PD55NCLKI   | PD55NCLKI  |
| 107     | N/C         | N/C       | PD56        | PD56       |
| 108     | N/C         |           | PD54        | PD54       |
N/C
| 109  | ESYNC   | ESYNC   | PD57/ESYNC   | PD57/ESYNC   |
| ---- | ------- | ------- | ------------ | ------------ |
| 110  | N/C     | N/C     | PD53         | PD53         |
| 111  | EVIDEO  | EVIDEO  | PD58/EVIDEO  | PD58/EVIDEO  |
| 112  | N/C     | N/C     | PD52         | PD52         |
| 113  | EVCLK   | EVCLK   | PD59/EVCLK   | PD59/EVCLK   |
| 114  | VSS     | VSS     | VSS          | VSS          |
| 115  | N/C     | N/C     | PD51         | PD51         |
| 116  | N/C     | SA28    | PD60         | PD60/SA28    |
| 117  | N/C     | N/C     | PD50         | PD50         |
| 118  | N/C     | SA29    | PD61         | PD61/SA29    |
| 119  |         |         | PD49         | PD49         |
|      | N/C     | N/C     |              |              |
| 120  | N/C     | SA30    | PD62         | PD62/SA30    |
| 121  | N/C     | N/C     | PD48         | PD48         |
| 122  | N/C     | SA31    | PD63         | PD63/SA31    |
| 123  | VSS     | VSS     | VSS          | VSS          |
| 124  | OEO     | OEO     | OEO          | OEO          |
| 125  | WE      | WE      | WE           | WE           |
| 126  | VSS     | VSS     | VSS          | VSS          |
3-18  PINS

....
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table 3-3. Numerical Pin Listing (Continued)
Name
| Number  | Trio32 PCI  | Trio32 VL   | Trio64 PCI  | Trio64 VL   |
| ------- | ----------- | ----------- | ----------- | ----------- |
| 127     | PA7         | PA7         | PD39/PA7    | PD39/PA7    |
| 128     | PA8         | PA8         | PD40/PA8    | PD40/PA8    |
| 129     | PA6         | PA6         | PD38/PA6    | PD38/PA6    |
| 130     | PA9         | PA9         | PD41/PA9    | PD41/PA9    |
| 131     | PA5         | PA5         | PD37/PA5    | PD37PA5     |
| 132     | PAlO        | PAlO        | PD42/PA10   | PD42/PA10   |
| 133     | PA4         | PA4         | PD36/PA4    | PD36/PA4    |
| 134     | PAll        | PAll        | PD43/PAll   | PD43/PAll   |
| 135     | VSS         |             |             |             |
|         |             | VSS         | VSS         | VSS         |
| 136     | PA3         | PA3         | PD35/PA3    | PD35/PA3    |
| 137     | VDD         | VDD         | VDD         | VDD         |
| 138     | PA12        | PA12        | PD44/PA12   | PD44/PA12   |
| 139     | PA2         | PA2         | PD34/PA2    | PD34/PA2    |
| 140     | PA13        | PA13        | PD45/PA13   | PD45/PA13   |
| 141     | PAl         | PAl         | PD33/PAl    | PD33/PAl    |
| 142     | PA14        | PA14        | PD46/PA14   | PD46/PA14   |
| 143     | PAO         | PAO         | PD32/PAO    | PD32/PAO    |
| 144     | PA15        | PA15        | PD47/PA15   | PD47/PA15   |
| 145     | VSS         | VSS         | VSS         | VSS         |
| 146     | STRD        | STRD        | STRD        | STRD        |
| 147     | STWR        | STWR        | STWR        | STWR        |
| 148     | VCLK        | VCLK        | VCLK        | VCLK        |
| 149     | HSYNC       | HSYNC       | HSYNC       | HSYNC       |
| 150     | VSYNC       | VSYNC       | VSYNC       | VSYNC       |
| 151     | ENFEAT      | ENFEAT      | ENFEAT      | ENFEAT      |
| 152     | INTA        | SINTR       | INTA        | SINTR       |
| 153     | ROMEN       | ROMCS       | ROM EN      | ROMCS       |
| 154     | BREO        | BREQ        | BREQ        | BREO        |
| 155     | BGNT/BLANK  | BGNT/BLANK  | BGNT/BLANK  | BGNT/BLANK  |
| 156     | XIN         | XIN         | XIN         | XIN         |
| 157     | XOUT        |             | XOUT        | XOUT        |
XOUT
| 158  | CLKAVDD1  | CLKAVDD1  | CLKAVDD1  | CLKAVDD1  |
| ---- | --------- | --------- | --------- | --------- |
| 159  | AVSS      | AVSS      | AVSS      | AVSS      |
| 160  | CLKAVDD2  | CLKAVDD2  | CLKAVDD2  | CLKAVDD2  |
| 161  | AVSS      | AVSS      | AVSS      | AVSS      |
| 162  | VREF      | VREF      | VREF      | VREF      |
| 163  | VSS       | VSS       | VSS       | VSS       |
| 164  | AVDD      | AVDD      | AVDD      | AVDD      |
| 165  | COMP      | COMP      | COMP      | COMP      |
| 166  | RSET      | RSET      | RSET      | RSET      |
| 167  | AVSS      | AVSS      | AVSS      | AVSS      |
| 168  | AR        | AR        | AR        | AR        |
PINS  3-19

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table 3-3. Numerical Pin Listing (Continued)
Name
| Number  | Trio32 PCI  | Trio32VL  | Trio64 PCI  | Trio64 VL  |
| ------- | ----------- | --------- | ----------- | ---------- |
|         | AVDD        | AVDD      | AVDD        | AVDD       |
169
| 170  | AVDD  | AVDD  | AVDD  | AVDD  |
| ---- | ----- | ----- | ----- | ----- |
| 171  | AG    | AG    | AG    | AG    |
| 172  | AB    | AB    | AB    | AB    |
| 173  | AVSS  | AVSS  | AVSS  | AVSS  |
|      | AVDD  | AVDD  | AVDD  | AVDD  |
174
|     | VSS  | VSS  | VSS  | VSS  |
| --- | ---- | ---- | ---- | ---- |
175
| 176  | GOO    | SA2     | GOO    | SA2     |
| ---- | ------ | ------- | ------ | ------- |
| 177  | GOl    | SA3     | GOl    | SA3     |
| 178  | G02    | SA4     | G02    | SA4     |
| 179  | G03    | SA5     | G03    | SA5     |
| 180  | G04    | SA6     | G04    | SA6     |
| 181  | G05    | SA7     | G05    | SA7     |
| 182  | G06    | SA8     | G06    | SA8     |
| 183  | G07    | SA9     | G07    | SA9     |
| 184  | VSS    | VSS     | VSS    | VSS     |
| 185  | GAO    | SAlO    | GAO    | SAlO    |
| 186  | GAl    | SAll    | GAl    | SAll    |
| 187  | GA2    | SA12    | GA2    | SA12    |
| 188  | GA3    | SA13    | GA3    | SA13    |
| 189  | GA4    | SA14    | GA4    | SA14    |
| 190  | GA5    | SA15    | GA5    | SA15    |
| 191  | GA6    | SA16    | GA6    | SA16    |
| 192  | VDD    | VDD     | VDD    | VDD     |
| 193  | RESET  | SRESET  | RESET  | SRESET  |
| 194  | SCLK   | SCLK    | SCLK   | SCLK    |
|      | VSS    | VSS     | VSS    | VSS     |
195
| 196  | GA7   | SA17  | GA7   | SA17  |
| ---- | ----- | ----- | ----- | ----- |
| 197  | GA8   | SA18  | GA8   | SA18  |
| 198  | GA9   | SA19  | GA9   | SA19  |
| 199  | GA10  | SA20  | GA10  | SA20  |
| 200  | GAll  | SA21  | GA11  | SA21  |
| 201  | GA12  | SA22  | GA12  | SA22  |
| 202  | GA13  | SA23  | GA13  | SA23  |
| 203  | GA14  | SA24  | GA14  | SA24  |
| 204  | GA15  | SA25  | GA15  | SA25  |
| 205  | N/C   | SA26  | N/C   | SA26  |
|      | VDD   | VDD   | VDD   | VDD   |
206
| 207  | A031  | S031  | A031  | S031  |
| ---- | ----- | ----- | ----- | ----- |
| 208  | A030  | S030  | A030  | S030  |
3-20  PINS

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Section 4: Electrical Data
4.1  MAXIMUM RATINGS
Table 4-1.  Absolute Maximum Ratings
| Ambient temperature                  | 0° C to 70° C      |     |     |     |     |
| ------------------------------------ | ------------------ | --- | --- | --- | --- |
| Storage temperature                  | -40° C to 125° C   |     |     |     |     |
| DC Supply Voltage                    | -O.5Vto 7.0V       |     |     |     |     |
| I/O Pin Voltage with respect to Vss  | -0.5V to VDD+0.5V  |     |     |     |     |
4.2  DC SPECIFICATIONS
Note: In all cases below, digital VDD = 5V ± 5% and the operating temperature is 0° C to 70° C.
Table 4-2.  RAMDAC/Clock Synthesizer DC Specifications
| Symbol        | Parameter                   | Min   | Typical  | Max   | Unit  |
| ------------- | --------------------------- | ----- | -------- | ----- | ----- |
| AVDD          | DAC supply voltage          | 4.75  | 5        | 5.25  | V     |
| AVDD (CLOCK)  | PLL supply voltage          | 4.75  | 5        | 5.25  | V     |
| VREF          | Internal voltage reference  | 1.10  | 1.235    | 1.35  | V     |
Table 4-3.  RAMDAC Characteristics
|                               |     | Min  | Tvpical  | Max  | Unit     |
| ----------------------------- | --- | ---- | -------- | ---- | -------- |
| Resolution Each DAC           |     |      | 8        |      | bits     |
| LSB Size                      |     |      | 66       |      | J,iA     |
| Integral Linearity Error      |     |      |          | + 1  | LSB      |
| Differential Linearity Error  |     |      |          | +1   | LSB      |
| Output Full-Scale Current     |     |      | 17       |      | mA       |
| DAC to DAC Mismatch           |     |      |          | 5%   |          |
| Power Supply Rejection Ratio  |     |      |          | 0.5  | %/%AVDD  |
| Output Compliance             |     | 0.0  |          | 1.5  | V        |
| Output Capacitance            |     |      |          | 30   | pF       |
| Glitch Impulse                |     |      | 75       |      | pV-Sec   |
ELECTRICAL DATA 4-1

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table 4·4.  Digital DC Specifications (VDD =5 V ± 5%)
| Symbol  | Parameter  | Min  | Max  |     |     |
| ------- | ---------- | ---- | ---- | --- | --- |
Unit
| VIL   | Input Low Voltage          | -0.5          | O.S           |     | V   |
| ----- | -------------------------- | ------------- | ------------- | --- | --- |
| VIH   | Input High Voltage         | 2.4 (Note 1)  | VDD +0.5      |     | V   |
|       | Output Low Voltage         |               |               |     | V   |
| VOL   |                            |               | Vss + 0.4     |     |     |
| VOH   | Output High Voltage        | 2.4           |               |     | V   |
| IOL1  | Output Low Current         | 4 (Note 2)    |               |     | mA  |
| IOH1  | Output High Current        | -2            |               |     | mA  |
| IOL2  | Output Low Current         | 8 (Note 3)    |               |     | mA  |
| IOH2  | Output Hioh Current        | -4            |               |     | mA  |
| IOL3  | Output Low Current         | 16 (Note 4)   |               |     | mA  |
| IOH3  | OutJJut High Current       | -S            |               |     | mA  |
| IOL4  | Output Low Current         | 24 (Note 5)   |               |     | mA  |
| IOH4  | Output High Current        | -10           |               |     | mA  |
| loz   | Output Tr i-state Current  |               | 1             |     | uA  |
| ON    | Input Capacitance          |               | 5             |     | pF  |
| COUT  | Output Capacitance         |               | 5             |     | pF  |
| Icc   | Power Supply Current       |               | 3S0 (Note 6)  |     | mA  |
Notes for Table 4·4
1.  The value for pins 25 (STOP) and 26 (PAR) is 2.6V.
IOL1, IOH1 for pins GA[15:0) (SA[25:10)), GD[7:0) (SA{9:2), ~ (ROMCS), iN'fA (SINTR),
2.
BGNT/BLANK, STRD, STWR, HSYNC, VSYNC, VCLK, ENFEAT, MA[S:O), CAS[7:0), PD[31:0),
PD[39:32l/PA[7:0), PD[47:40l/PA[15:8), PD[54:48), PD55NCLKI, PD56, PD57/ESYNC,
PD58/EVIDEO, PD59/EVCLK, PD[63:60)f(SA[31:28)). PD[63:32) are not available on the Tri032.
3.  IOL2, IOH2 for pins AD[31:0) (SD31:0), RAS1/0E1, RASO (OE1 is not available on the Tri032)
4.  10L3, IOH3 for pins OEO, WE
5.  IOL4, IOH4 for pins PAR (SWiR), STOP (SAUP), DEVSEL (LOCA), TRDY (SRDY)
6.  Based on a package limit of 2 W.
7.  Pin names for VL-Bus configurations are shown in parentheses.
4.3  AC SPECIFICATIONS
Note: All AC timings are based on an 80 pF test load.
Table 4·5.  RAMDAC AC Specifications
| Parameter                  |     | Typical  | Max  | Unit  | Notes  |
| -------------------------- | --- | -------- | ---- | ----- | ------ |
| DAC Output Delav           |     | 5        |      | ns    | 1      |
| DAC Output Rise/Fall Time  |     | 3        |      | ns    | 2      |
| DAC Output Settlino Time   |     | 15       |      | ns    |        |
| DAC-to-DAC Output Skew     |     | 2        | 5    | ns    | 3      |
4-2 ELECTRICAL DATA

••
r  S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Notes for Table 4-5
1.  Measured from the 50% point of VCLK to the 50% point of full scale transition
2.  Measured from 10% to 90% full scale
3  With DAC outputs equally loaded
4.3.1  Clock Timing
|     |     | --- --------------- | --- |     |     |
| --- | --- | ------------------- | --- | --- | --- |
2.~\I
|     | 1.5\1 --- | ------------------     | ------------------- |     |     |
| --- | --------- | ---------------------- | ------------------- | --- | --- |
|     | 0.8\1 --- | - -------------------- | ---------------     |     |     |
~--------Tcvc----------~ DCLKTIME
Figure 4-1. Clock Waveform Timing
Table 4-6.  Clock Waveform Timing
| Symbol  | Parameter                        |     | Min    | Max  | Units  Notes  |
| ------- | -------------------------------- | --- | ------ | ---- | ------------- |
| Tcyc    | SCLK Cycle Time (VL-Bus)         |     | 20     | 125  | ns  1         |
|         | SCLK QLcle Time (PCI)            |     | 30     | 125  | ns  1         |
|         | MCLK Cycle Time                  |     | 16.67  | 100  | ns            |
|         | DCLK Cycle Time (VGA Mode)       |     | 25     | 100  | ns  1         |
|         | DCLK Cycle Time (Enhanced Mode)  |     | 12.5   | 100  | ns  1,2       |
| THIGH   | SCLK High Time (VL-Bus)          |     | 8      | 80   | ns            |
|         | SCLK High Time (PCI)             |     | 12     | 80   | ns            |
| TLOW    | SCLK Low Time (VL-Bus)           |     | 8      | 80   | ns            |
|         | SCLK Low Time (PCI)              |     | 12     | 80   | ns            |
|         | SCLK Slew Rate                   |     | 1      |      | V/ns  3       |
4
Notes:
1.  fDCLK <: 1/2 fSCLK to ensure valid writes to the PLLs.
2.  For DCLK rates above 80 MHz, clock doubling is used. The maximum DCLK rate with clock
doubling is 67.5 MHz.
3.  Rise and fall times are specified in terms of the edge rate measured in V/ns. This slew rate
must be met across the minimum peak-to peak portion of the clock waveform.
ELECTRICAL DATA 4-3

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
4.3.2  Input/Output Timing
SCLK  1.5 V
INPUT
TCLKlN
Figure 4·2. Input Timing
Table 4-7.  SCLK-Referenced Input Timing
PCIBus
| Symbol  | Parameter                                       | Min  | Units  |
| ------- | ----------------------------------------------- | ---- | ------ |
| Tsu     | AD[31 :01. C/BE[3:0], FRAME, IRDY, IDSEL setup  | 7    | ns     |
| TH      | AD[31 :0] hold                                  | 1    | ns     |
| TH      | C/BE[3:01. FRAME, IRDY, IDSEL hold              | 1    | ns     |
VL-Bus
| Symbol  | Parameter                                      | Min  | Units  |
| ------- | ---------------------------------------------- | ---- | ------ |
| Tsu     | AD[31:21. BE[3:01. SM/IO, SW/R, SADS (address  | 12   | ns     |
phase) setup
| TH  | AD[31:21. BE[3:01. SM/IO, SW/R, SADS (address  | 1   | ns  |
| --- | ---------------------------------------------- | --- | --- |
phase) hold
| Tsu  | AD[31:21. BE[3:01. D1, DO, SADS (data phase)  | 4   | ns  |
| ---- | --------------------------------------------- | --- | --- |
setup
| TH  | AD[31 :21. BE[3:0], D1, DO, SADS (data phase)  | 1   | ns  |
| --- | ---------------------------------------------- | --- | --- |
hold
6
| Tsu  | RDYIN setup  |     | ns  |
| ---- | ------------ | --- | --- |
| TH   | RDYIN hold   | 1   | ns  |
Miscellaneous
| Symbol  | Parameter                     | Min  | Units  |
| ------- | ----------------------------- | ---- | ------ |
| Tsu     | ROM Data GD[7:0] Setup (PCI)  | 5    | ns     |
| TH      | ROM Data GD[7:0] Hold (PCI)   | 7    | ns     |
5
| Tsu  | General Input Port GD[7:0] setup  |     | ns  |
| ---- | --------------------------------- | --- | --- |
| TH   | General Input Port GD[7:0] hold   | 7   | ns  |
4-4 ELECTRICAL DATA

....
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
SCLK  1.5 V
DELAY
OUTPUT  1.5V
TCLKOUT
Figure 4-3. Output Timing
Table 4-8.  SClK-Referenced Output Timing
PCIBu5
| Parameter              | TMIN  TMAx  | Units  Notes       |
| ---------------------- | ----------- | ------------------ |
| AD[31 :OJ valid delay  | 2  16       | ns  1              |
| DEVSEL. PAR            | 2  11       | ns  Medium DEVSEL  |
| delay                  |             | timing used        |
| STOP delay             | 2  11       | ns                 |
| TRDYdeiay              | 2  11       | ns                 |
| INTAdeiay              | 2  11       | ns                 |
Vl-Bus
| Parameter                     | TMIN  TMAx  | Units  Notes  |
| ----------------------------- | ----------- | ------------- |
| AD[31:21. D1, DO valid delay  | 7  16       | ns            |
| SINTR delay                   | 5  30       | ns            |
| SRDYdeiay                     | 5  11       | ns            |
| LOCA active delay             | 5  15       | ns            |
| LOCA inactive delay           | 5  20       | ns            |
Miscellaneous
| Parameter   | TMIN  TMAx  | Units  Notes  |
| ----------- | ----------- | ------------- |
| STRD delay  | 3  15       | ns            |
RaMEN (PC I) delay
|                                     | 4  10  |     |
| ----------------------------------- | ------ | --- |
| ROM Address valid delay (PCI)       | 5  30  | ns  |
| AD[7:0J ROM Data valid delay (PCI)  | 5  30  | ns  |
Note
1.  Due to the timing for TROY for read cycles, data is not sampled on the clock edge immediately
following its becoming valid. This guarantees the PCI 2.0 specification time of 11 ns.
ELECTRICAL DATA 4-5

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Table 4-9.  Display Memory Read/Write Timing
Note: In this table, t = 1/MCLK
| Parameter                                   |     | Min  | Units  Notes  |
| ------------------------------------------- | --- | ---- | ------------- |
| MA[8:0] setup with respect to CAS, RAS low  |     | 3    | ns            |
| MA[8:0] hold with respect to CAS, RAS low   |     | t    | ns            |
PD[63:0] setup to CAS high (PD[31 :0] for Tri032) (EDO)  -t/2  ns  1
PD[63:0] hold from CAS high (PD[31 :0] for Tri032) (EDO)  t  ns  1
| PD[63:0] setup to CAS high (PD[31 :0] for Tri032)  |     | 1   | ns  2  |
| -------------------------------------------------- | --- | --- | ------ |
PD[63:0] hold from CAS high (PD[31 :0] for Tri032)  0  ns  2
| PD[63:0] setup to WE low (PD[31 :0] for Tri032)   |     | 0   | ns  |
| ------------------------------------------------- | --- | --- | --- |
| PD[63:0] hold from WE low (PD[31 :0] for Tri032)  |     | t   | ns  |
CAS[7:01. OE[l :0] additional active time (CAS[3:01. OEO  3.5  ns  3
for Tri032)
| CAS setup (CAS before RAS refresh)  |     | t + 12  | ns  |
| ----------------------------------- | --- | ------- | --- |
| Page cycle time                     |     | 2t      | ns  |
Notes for Table 4-9
1.  EDO mode read cycle. Refer to the EDO read timing in Section 7.
2.  Fast page mode read cycle
3.  The active time for these signals can be stretched via bits 1-0 of CR6B. This value is approximate.
Table 4-10.  Feature Connector Timing -Output from Trio32/Trio64 to Feature Connector
| Symbol  | Parameter                              | Min  | Units  Notes  |
| ------- | -------------------------------------- | ---- | ------------- |
| Tsu     | PA[15:01. BLANK setup to VCLK rising   | 5    | ns            |
| TH      | PA[15:01. BLANK hold from VCLK rising  | 5    | ns            |
4-6 ELECTRICAL DATA

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table 4-11.  Feature Connector Timing -Output from Feature Connector to Trio32/Trio64
| Symbol  | Parameter                         | Min  Max  | Units  | Notes  |
| ------- | --------------------------------- | --------- | ------ | ------ |
| Tsu     | PA[15:01. BLANK setup to VCLK or  | 6         | ns     | 1      |
VCLKI rising
| TH  | PA[15:01. BLANK hold from VCLK or  | 6   | ns  | 1   |
| --- | ---------------------------------- | --- | --- | --- |
VCLKI risinq
|     | VCLK                    | 25  40  | ns       | 1    |
| --- | ----------------------- | ------- | -------- | ---- |
|     | VCLKI                   | 27  40  | ns       | 1,2  |
|     | VCLK, VCLKI duty cycle  | 40  60  | %        |      |
|     | VCLK, VCLKI high time   | 10  25  | ns       |      |
|     | VCLK, VCLKI low time    | 10  25  | ns       |      |
|     | VCLK, VCLKI slew rate   | 1       | 4  V/ns  |      |
Notes for Table 4-11
1.  Pixel data is clocked into the internal RAMDAC using VCLK for a pass-through feature
connector and VCLKI for a VAFC configuration.
2.  This corresponds to the VESA VAFC specification of a maximum clock of 37.5 MHz.
SRESET,RESET
SYSTEM
CONFIGURATION
DATA
RESETTM
Figure 4-4. Reset Timing
Table 4-12.  Reset Timing
| Symbol  | Parameter  |     | Min  | Units  |
| ------- | ---------- | --- | ---- | ------ |
TLQW  SRESET (VL) or RESET (PCI) active pulse width  400  ns
|      | PD[23:0] setup to SRESET (VU or RESET (PCI)  |     |     | ns  |
| ---- | -------------------------------------------- | --- | --- | --- |
| Tsu  |                                              |     | 20  |     |
inactive
| TH  | PD[23:0] hold from SRESET (VL) or RESET (PCI)  |     | 10  | ns  |
| --- | ---------------------------------------------- | --- | --- | --- |
inactive
ELECTRICAL DATA 4-7

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Section 5: Reset and Initialization
The reset signal (RESET for PCI, SRESET for VL 5.2 TEST MODE
Bus) resets the internal state machines in the
Tri032rrri064 and places all registers in their
Upon power-on reset. most output pins are tri
power-on default states. It also initiates several
stated. However, some must be kept active to
configuration actions, as described in this sec
support the reset process. To facilitate bed-of
tion.
nails testing at the PCB level, the Tri032rrri064
incorporate a test mode that tri-states all output
5.1 CONFIGURATION STRAPPING pins and makes all bi-directional pins inputs. To
enterthis mode, power-on strapping bit 9 (CR37,
bit 1) must be pulled low at reset. The outputs
The PD[23:0] pins can be individually pulled
that are normally nottri-stated on reset but which
either high or low through 47 KQ resistors. These
are tri-stated in test mode are shown in Table 5-1.
pull-ups and pull-downs do not affect normal
operation ofthe pins as part ofthe pixel data bus,
Table 5-1. Signals Tri-Stated by Test Mode
but they do force the pins to a definite state
during reset. Atthe rising edge ofthe reset signal,
this state is sampled and the data loaded into the Signal Name
CR36, CR37 and CR68 registers. The data is used RAS[1:0]
for system configuration, such as system bus and CAS[3:0]
memory parameter selection. The definitions of
CAS[7:4] (Tri064 only)
the PD[23:0] strapping bits at the rising edge of
the reset signal are shown in Table 5-2. WE
OEO
Strapping bits 7-5 define the display memory OE1 (Tri064 only)
size. However, the 53 BIOS determines this value
MA[8:0]
directly and writes it to CR36 bits 7-5 after reset.
Therefore, systems using the 53 BIOS do not
need to strap the PD[7-5] pins. Other pins may
also not require strapping, depending on the
design and bus type.
Strapping bits 15-13 and 22-20 provide monitor
information. The interpretation of the bit values
is dependent on the video BIOS.
RESET AND INITIALIZATION 5-1

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table 5-2.  Definition of PD(23:0] at the Rising Edge of the Reset Signal
| CR Bits  | PD Bits  Value  | Function  |
| -------- | --------------- | --------- |
System Bus Select
| CR36 1-0  | 1-0  |                 |
| --------- | ---- | --------------- |
|           | 00   | Reserved        |
|           | 01   | VESA local bus  |
|           | 10   | PCI local bus   |
|           | 11   | Reserved        |
Memory Page Mode Select
| CR363-2  | 3-2  00  | Reserved                      |
| -------- | -------- | ----------------------------- |
|          | 01       | Reserved                      |
|          | 10       | Extended data out (EDO) mode  |
|          | 11       | Fast page mode                |
Enable Video BIOS IVL-Bus)
CR364  4  0  Disable video BIOS access (system BIOS contains video BIOS)
|     | 1   | Enable video BIOS access  |
| --- | --- | ------------------------- |
Display Memory Size
CR36 7-5  7-5  000  4 MBytes (Tri064 only -reserved for Tri032)
|     | 001  | Reserved                 |
| --- | ---- | ------------------------ |
|     | 010  | Reserved                 |
|     | 011  | Reserved                 |
|     | 100  | 2 MBytes                 |
|     | 101  | Reserved                 |
|     | 110  | 1 MByte                  |
|     | 111  | 0.5 MByte (Tri032 only)  |
Enable Tri032/Trio64 IVL-Bus)
CR37 0  8  0  Disable Tri032/Tri064 except for Video BIOS accesses
|     | 1   | Enable Tri032/Tri064  |
| --- | --- | --------------------- |
Test Mode
CR37  1  9  0  All outputs tri-stated and all bi-directional pins become inputs
|     | 1   | Normal operation. Certain outputs required for the reset  |
| --- | --- | --------------------------------------------------------- |
process are not tri-stated during reset
Video BIOS ROM Size IVL-Bus)
| CR372  | 10  0  | 64-KByte video BIOS  |
| ------ | ------ | -------------------- |
|        | 1      | 32-KByte video BIOS  |
Clock Select
CR37_3
11  0  Use external DCLK on XIN pin and external MCLK on STRD pin
(test purposes only)
|     | 1   | Use internal DCLK, MCLK  |
| --- | --- | ------------------------ |
RAMDAC Write Snooping IVL-Bus)
| CR374  | 12  0  | Disable LOCA/SRDY for RAMDAC writes  |
| ------ | ------ | ------------------------------------ |
|        | 1      | Enable LOCA/SRDY for RAMDAC writes   |
5-2  RESET AND INITIALIZATION

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Table 5-2. Definition of PD[23:0] at the Rising Edge of the Reset Signal (Continued)
| CR Bits  | PO Bits  Value  | Function  |
| -------- | --------------- | --------- |
Monitor Identification
CR37 7-5  15-13  The S3 video BIOS uses these bits for monitor information
CAS/OE Low Stretch, WE Low Delay
CR68 1-0  17-16  00  approximately 6.5 ns stretch (nominal), 2 units WE delay
|     | 01  | approximately 5 ns stretch (nominal), 1 unit WE delay  |
| --- | --- | ------------------------------------------------------ |
|     | 10  | approximately 3.5 ns stretch (nominal), no WE delay    |
|     | 11  | No stretch or delay                                    |
RAS Low Timing Select
| CR682  | 18  0  |     |
| ------ | ------ | --- |
4.5 MCLKs
|     | 1   | 3.5 MCLKs  |
| --- | --- | ---------- |
RAS Pre-Charge Timing Select
| CR683  | 19  0  | 3.5 MCLKs  |
| ------ | ------ | ---------- |
|        | 1      | 2.5 MCLKs  |
Monitor Identification
CR68 6-4  22-20  The S3 video BIOS may use these bits for monitor information
Upper System Address Bus Decode/Memory_Data Bus Size
CR68_7  23  0  Tri032/Tri064 decodes all 32 system address lines (VL-Bus);
Tri064 memory data bus is 32 bits NL-Bus and PCI)
1  Tri032/Tri064 uses SAUP input as upper address decode (VL-
Bus); Tri064 memory data bus is 32 bits (1 MByte of memory)
or 64-bits (2 or more MBytes of memory) (VL-Bus and PCI)
RESET AND INITIALIZATION  5-3

fl·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Section 6: System Bus Interfaces
The Tri032fTri064 interfaces to either a PCI bus 6.1.2 PCI Bus Cycles
or a VESA local bus (VL-Bus). This section de
scribes the connections and functional charac
Figures 6-1 and 6-2 show the basic PCI read and
teristics of these interfaces.
write cycles respectively. Bit 1 of the PCI Com
mand register (Index 04H) must be set to 1 to
6.1 PCI BUS INTERFACE allow memory space access. Bit 0 of the PCI
Command register must be set to 1 to allow I/O
space access.
The Tri032fTri064 provides a complete PCI inter
face. Power-on strapping bits 1-0 must be set to
Figures 6-3 and 6-4 show two examples of PCI
10b to enable this interface. The pinout and other
bus disconnection. These examples show cases
specifications are in complete conformance with
where data is transferred after STOP is asserted.
Revision 2 of the the PCI specification. No glue
In example A, data is transferred after FRAME is
logic is required.
deasserted because the master was not ready
(lRDY deasserted on clock 2) .. In example B, data
6.1.1 PCI CONFIGURATION is transferred before FRAME is deasserted. See
revision 2.0 or later of the pel Local Bus Specifi
cation for a complete explanation of disconnects.
The Vendor ID register (Index OOH) in the PCI
Bit 7 of the CR66 register must be set to 1 to
Configuration space is hardwired to 5333H to
enable PCI disconnects.
specify S3 Incorporated as the vendor. The
Device ID register is hardwired to 8811 for both
The PCI configuration register space occupies
the Tri032 and Tri064). This allows the same
256 bytes. When a configuration read or write
BIOS to be used with both chips. The BIOS must
command is issued, the AD[7:0] lines contain the
use CR2E to differentiate between the Tri032 and
address of the register in this space to be ac
Tri064.
cessed. Figures 6-5 and 6-6 show the configura
tion read and write cycles respectively. The
Bits 10-9 of the Status register (Index 06H) are
Tri032fTri064 supports or returns 0 for the first 64
hardwired to 01b to specify medium DEVSEL
bytes of configuration space.
timing. The Class Code register (Index 08H) is
hardwired to 30000H to specify that the
The Tri032fTri064 drives even parity information
Tri032fTri064 is a VGA compatible device. Bits
onto the PAR line during read transactions. This
3-0 ofthe Base Address 0 register (Index 10H) are
operation is depicted in Figure 6-7.
hardwired to OOH. This indicates that the "pre
fetchable" bit is cleared to 0, the base register can
be located anywhere in a 32-bit address space
and the base register is located in memory space.
SYSTEM BUS INTERFACES 6-1

,,-
.lJa
•
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Inco.po.atad
|     | T1  |     | T2  | T3  |     | T4  | T5  |     | T6  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
SCLK
I
\
I
FRAME
I
}-~-{
| AD[31:0)   |      | ADD5ESS  |     |       | DAjA1    | X  DAtA 2  | X   | DAtA 3  | }-~  |
| ---------- | ---- | -------- | --- | ----- | -------- | ---------- | --- | ------- | ---- |
|            |      | I        |     | I     | I        |            | I   | I       |      |
|            | (    | BUS~MD   |     |       |          |            |     |         | )-~  |
| C/BE[3:O)  |      |          | X   | :     | :  BE'S  |            | :   | :       |      |
|            |      |          |     | I     | I        |            | I   | I       |      |
|            | -~h  |          |     |       |          |            |     |         | I    |
| IRDY       |      |          |     | I     | I        |            | I   | I       |      |
|            |      | I        |     | I     | I        |            | I   | I       |      |
|            | -~I  |          |     | I  \  | I        |            | I   | I       | I    |
TRDY
|     |      | I   |     | I   | I   |     | I   | I   |     |
| --- | ---- | --- | --- | --- | --- | --- | --- | --- | --- |
|     |      |     |     | I   | I   |     | I   | I   |     |
|     | _~I  |     |     | \   |     |     |     |     | I   |
|     |      | I   |     | I   | I   |     | I   | I   |     |
DEVSEL
|     |     | I   |     | I   | I   |     | I   | I   |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
BASEREAD
Figure 6-1. Basic PCI Read Cycle
|     | T1  |     | T2  |     | T3  | T4  |     | T5  | T6  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
SCLK
|     |     |     |     | I   | I   |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
\
|     |     |     |     | I   | I   |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
FRAME
|     |     |     |     | I   | I   |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
ADD~ESS
| AD[31:0)  |     |     | ~   | :   | DATA 1  :  | ~   |        |     | }-~    |
| --------- | --- | --- | --- | --- | ---------- | --- | ------ | --- | ------ |
|           |     |     |     |     |            |     | DAlA2  | X   | DArA3  |
|           |     | I   |     | I   | I          |     | I      |     | I      |
(
| C/BE[3:0)  |      | BUS~MD  |     | I   | I       | ~   | ~S2  |     | ~S3  }-~  |
| ---------- | ---- | ------- | --- | --- | ------- | --- | ---- | --- | --------- |
|            |      |         | X   |     | BE'S 1  |     |      | X   |           |
|            | -~~  |         |     |     | I       |     | I    |     | I         |
I
| IRDY  |      |     | I   | I   | I   |     | I   |     | I     |
| ----- | ---- | --- | --- | --- | --- | --- | --- | --- | ----- |
|       |      |     | I   | I   | I   |     | I   |     | I     |
|       | -~I  |     |     | I   | \   | I   | I   |     | I  I  |
| TRDY  |      |     | I   | I   |     | I   | I   |     | I     |
|       | -~I  |     |     | I   |     | I   | I   |     | I     |
|       |      |     |     |     | \   |     |     |     | I     |
|       |      |     | I   | I   |     | I   | I   |     | I     |
DEVSEL
|     |     |     | I   | I   |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
BASEWRT
Figure 6-2. Basic PCI Write Cycle
6-2  SYSTEM BUS INTERFACES

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
T1 T2 T3 T4
SCLK
~
FRAME I
I
I
IRDY
TRDY
I I
--+-\
I
STOP I cis
I
I I
I I /
DEVSEL I I
I I DISCDNA
Figure 6-3. PCI Disconnect Example A
T1 T2 T3 T4
SCLK
I
~-
I
FRAME __I I
I 1
I 1 ..'}
I
IRDY
TRDY
I
--t-
STOP I
1
1
I I
DEVSEL
I
I DISCONB
Figure 6-4. PCI Disconnect Example B
SYSTEM BUS INTERFACES 6-3

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
T1 T2 T3 T4 T5 T6
SCLK
_--L __
I~ ~_
I ,.,.
I I \
FRAME
I I I
r-b--{ r-b-
I •
AD[31:0) ADDtESS D+A
I I · I
ID+SE- L~
+-
-1-(
i i }--
C/BE[3:0) - CFG RrAD X BE'S
r- r-
i \ /
0 I
IRDY
--i \ /
-0~ I
I_I -
TRDY
I I I . . I
CFGREAD
Figure 6·6. PCI Configuration Read Cycle
T1 T2 T3 T4
SCLK
I I I I I
--+--I~ I / I ~-
FRAME I I \ I
I I I I I
! • x >-~-
AD[31:0] ADDRrSS D+A
I I I I I
IDSEL_~~
I I I I I
-+- -
~ --i x B~S ~
C/BE[3:0] - CFG WriTE )-- -
I I I
j-Oj-i\ / I
I I I I
I--Ol-----l~ I
I I I \ / ICFGWRITE
I I I I
Figure 6·5. PCI Configuration Write Cycle
6-4 SYSTEM BUS INTERFACES

...
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
T1 T2 T3 T4 T5
T1
SCLK
I I
~
I I
FRAME--il
I I
I I I
I ( 9
AD[31:0] ADDR~SS )-~
I
I I I I I
I
PAR ~~
I i---< i
I
Figure 6·7. Read Parity Operation
6.2 VL-BUS INTERFACE any of 32 address windows with respect to 128-
MByte boundaries.
Power-on strapping bits 1-0 must be setto 01b to
S3 recommends that the design limit the Tri064
enable VL-Bus operation. The Tri032 provides a
to responding to accesses below 512 MBytes.
totally glueless interface to the VL-Bus. The
This is easily and inexpensively accomplished by
Tri064 interface is also glueless if it is configured
using a 74x27 to logically NOR SA[31:29) as the
to operate with a 32-bit PO bus (bit 7 of CR6B
SAUP input. This means the Tri064 will respond
cleared to 0). With more than 1 MByte of memory
to any of four different address windows.
(64-bit PO bus), the Tri064 decodes address lines
SA[26:2) and pin 25 becomes the SAUP upper
If response to' a single linear addressing widow
address decode for linear addressing. If SAUP is
above 12B MBytes is required, a PLO can be used
a logical zero, the Trio64 will not respond to bus
to decode the appropriate address space.
cycles. If SAUP is a logical one, the Tri064 may
respond.
The SAUP input can also be used by the Trio32.
This is provided for compatibility with Trio64
When the PO bus is 64 bits, bits 26-XX of the
designs, but is never required because the Trio32
linear addressing window base address are de
always operates with a 32-bit PO bus and can
fined in CR59-CR5A. XX is 16 for a 64K window,
therefore can always decode SA[31:2).
2~ for a 1- MByte window, 21 for a 2-MByte
Window and 22 for a 4 MByte window. If SAUP is
pulled high, the Trio64 will respond to any access
where SA[26:XX) matches bits 26-XX in CR59-
CR5A. This means that the Tri064 will respond to
SYSTEM BUS INTERFACES 6-5

....
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
6.2.1 VL-Bus Cycles
The basic VL-Bus read cycle is shown in Figure
6-9. The address is latched by the Tri032/Tri064
on one of two rising SCLK edges as shown in
Figure 6-9 and explained in Note 1.
The basic VL-Bus write cycle is shown in Figure
6-11. The single wait-state is the default configu
ration. This can be changed to 0 wait-states
(SROY asserted one cycle earlier) by clearing bit
4 of CR40 to O. The address is latched at the end
of T1. By default, write data is latched on the first
rising SCLK edge after the assertion of ROYIN. T
6.2.2 SRDY Generation
For a VL-Bus configuration, the Tri032/Tri064
raises its SROY output early in the Tl cycle and
then tri-states it. It then asserts SROY to signal
the end of the cycle. Some systems synchronize
or otherwise delay this signal and then assert
ROY to the processor. If this is done, this ROY
signal should also be fed to the RDYIN input of
the Tri032/Tri064 (see Note 3 of Figure 6-9). The
Tri032/Tri064 holds read data active until ROYIN
is asserted. If the SROY signal is not intercepted,
it should be fed to both the processor ROY input
and the Tri032/Tri064 ROYIN input.
6-6 SYSTEM BUS INTERFACES

II·
53 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
|     |     | T1  |     | T2  | T3  | T4  | 1'5  |     |
| --- | --- | --- | --- | --- | --- | --- | ---- | --- |
SCLK
|        | _-!-I----,  |                           | 1   |     | I   |     |     | \IJ  - |
| ------ | ----------- | ------------------------- | --- | --- | --- | --- | --- | ------ |
| SADS   | 1           | \                         | 1   | /   | I   |     |     |        |
|        |             | ~--~'i.~~----~~il,-NOTE1  |     |     |     |     |     | ~      |
|        | 1           |                           | I   | :   |     |     |     |        |
| SA[~~  |             |                           |     |     |     |     |     | ~      |
•
|     | _l'----J/  |     | I   |     | I   |     | 1-  | \L  |
| --- | ---------- | --- | --- | --- | --- | --- | --- | --- |
SAUP
|           | 1   |     | 1   |                                    | 1   |     | 1   | 1     |
| --------- | --- | --- | --- | ---------------------------------- | --- | --- | --- | ----- |
|           | 1   |     | 1   | \                                  | 1   |     | 1   | It--- |
|           | I   |     | 1   | I----J,I ___" ---__- I-I __- -I'I  |     |     |     |       |
|           | I   |     | I   |                                    | I   | 1   | I   | I     |
|           |     |     |     |                                    |     |     | I   | I     |
| SD[31:0J  |     |     |     |                                    |     |     |     | ~     |
VALID
|     | 1              |        | 1     |     | 1   | 1   | 1        | 1          |
| --- | -------------- | ------ | ----- | --- | --- | --- | -------- | ---------- |
|     | 1              | r---\  | I     |     | I   | I   | 1        | /r---'-I-  |
|     | _--+-1 ....II  |        | .  1  |     | 1   | 1   | \1---+1  | 1          |
_--I
|     | 1   |     | I   |     | I   | I   | 1   | 1   |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
\Ii--
|     | 1     | /    | I   |     | 1   | 1 : E 2; \ 1  |                  |            |
| --- | ----- | ---- | --- | --- | --- | ------------- | ---------------- | ---------- |
|     | ----+ | '    |     |     |     | NOT           |                  |            |
|     |       |      | 1   |     | 1   | I             | '-i--J\\---+-I-- |            |
|     |       |      | I   |     | I   |               |                  | I KVLREAI  |
Figure 6-8. VL-Bus Read Cycle
Notes
1. For one decode wait state (bit 4 of CR40 set to 1l , the address is latched on the first clock edge in
dicated here if bit 3 of CR58 is set to 1. If this bit is cleared to 0, the address is latched on the
second clock edge indicated. The address is always latched on the first clock edge if bit 4 of
CR40 is cleared to O.
2. The system chip set can delay the RDYIN input by 1 or more cycles. This example assumes a 1
cycle delay, as indicated by the solid line. Note that read data is held valid an extra cycle.
|     |     |     |     |     |     | SYSTEM BUS INTERFACES  |     | 6-7  |
| --- | --- | --- | --- | --- | --- | ---------------------- | --- | ---- |

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad
|     | T1    | T2    | T2  | T1  |
| --- | ----- | ----- | --- | --- |
|     | I     | I     |     |     |
|     | ~  \  | ~  \  | \   | L   |
SCLK
| SO[31:0]  |     |     | VALID  |     |
| --------- | --- | --- | ------ | --- |
I
|       | \   | /   | I   | L   |
| ----- | --- | --- | --- | --- |
| SADS  |     |     | I   |     |
~I  NOTE 1
SA[31:2]
MIlO
i
W/R
|     |     | I   |     | I   |
| --- | --- | --- | --- | --- |
|     | /   |     |     | L   |
|     |     | I   |     | I   |
SAUP
|       |     | I     |     | I     |
| ----- | --- | ----- | --- | ----- |
|       |     | I     |     | I     |
|       |     | I  \  |     | I  I  |
| LOCA  |     | I     |     | I     |
|       |     | I     |     | I     |
|       |     | I     |     | I  r  |
|       | /   |       |     | 7     |
~
't::::  0TE
|     |     | I   |     | 2   |
| --- | --- | --- | --- | --- |
SRDV
|     |     | I   |     | I   |
| --- | --- | --- | --- | --- |
+---X
|     | /   | I   |     |     |
| --- | --- | --- | --- | --- |
I
| RDVIN  |     |     | NOTE3A  | :   |
| ------ | --- | --- | ------- | --- |
I
|     |     | I   |     | I   |
| --- | --- | --- | --- | --- |
KVLWRITE
Figure 6-9. 1 Wait-state VL-Bus Write Cycle
Notes
1. For one decode wait state (bit 4 of CR40 set to 1), the address is latched on the first clock edge in
dicated here if bit 3 of CR58 is set to 1. If this bit is cleared to 0, the address is latched on the
second clock edge indicated. The address is always latched on the first clock edge if bit 4 of
CR40 is cleared to o.
2. The wait-state is inserted by setting bit 4 of CR40 to 1 to delay SRDY assertion by 1 cycle from
the assertion of SADS. This is the default value.
3.  Data is latched on the rising SCLK edge following assertion of RDYIN.
6-8  SYSTEM BUS INTERFACES

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Section 7: Display Memory
The Tri032rrri064 supports a DRAM-based video memory regardless of whether or not feature
frame buffer. This section describes the various connector operation is enabled.
configurations supported, the functional timing
for memory accesses and the operation of vari The Tri064 can operate with either a 32-or 64-bit
ous register bits that affect memory timing and PD bus. If bit 7 of CR6B is cleared to 0 (either via
operation. It also describes how access to display power-on strapping of PD23 or by program
memory is controlled to maximize graphics per ming), the PD bus size for the Tri064 is fixed at 32
formance and how the Tri032rrri064 can share bits. In this mode, the Tri064 can only support 1
the frame buffer with a secondary memory con MByte of memory. Note that the Tri064 should
troller for multimedia applications. not be strapped for a 32-bit PD bus if its memory
configuration is larger than 1 MByte as this will
prevent correct memory size detection by the
7 .1 DISPLAY MEMORY
BIOS. Strapping the Tri064 for 32-bits should
CONFIGURATIONS only be done for a 1-MByte maximum memory
design using a glueless feature connector inter
The Tri032rrri064 uses either fast page mode or face.
extended data out (EDO) DRAMs for its frame
buffer. All DRAMs can be configured as 256Kx4, If bit 7 of CR6B is set to 1, the PD bus size for the
256KxB or 256Kx16. A Tech Note lists recom Tri064 is determined by the memory size speci
mended DRAMs. fied in bits 7-5 of CR36. For a 1-MByte configura
tion, the bus size is 32 bits. For 2-MByte or larger
For loading reasons, a maximum of B DRAM configurations, the bus size is 64 bits. EDO mem
chips can be used for the frame buffer. Table 7-1 ory can be used for 1-or 2-MByte configurations.
shows the supported memory size/chip count Fast page mode memory is required for 4-MByte
configurations. For a 0.5 MByte Tri032 configura configurations.
tion, the chip count is half that for 1 MByte.
If the Tri064 is enabled for feature connector
Table 7-1 Memory Size/Chip Count operation (bit 0 of SRD set to 1), the Tri064 must
Configurations first be configured for a 32-bit PD bus. This dis
ables all data and control signals (PD[63:32],
CAS[7:4], RAS1/0E1l, for memory above 1
256Kx4 256Kx8 256Kx16
MByte, allowing certain multiplexed pins to func
1 MB 8 4 2 tion as feature connector signal pins. Because of
2MB 8 4 the 32-bit PD bus operation, the resolutions sup
4MB 8 ported and performance of the Tri064 during
feature connector operation are the same as for
The Tri032 operates with a 32-bit memory data the Tri032 with 1 MByte of memory.
(PD) bus (16 bits for 0.5 MByte). It can be config
ured with 0.5, 1 or 2 MBytes of fast page or EDO Figure 7-1 shows a 2-MByte configuration using
256Kx16 DRAMs. The same connections are used
DISPLAY MEMORY 7-1

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
for both Tri032 and Tri064 1-MByte configura  For fast page mode memory (bit 2 of CR36 set to
tions since both use a 32-bit memory data bus  1), preventing memory data from being driven on
with 1 MByte of memory. The second MByte  the multiplexed PO lines for feature connector
shown in this figure applies only to the Tri032.  operation means not driving CAS[7:4]. Since the
Eitherfast page or EDO DRAMs can be used.lfx4  CAS lines control the memory output buffers, this
DRAMs are used, the maximum configuration is  means no data is driven on PD[63:32].
1 MByte. Each x16 chip is replaced by four x4
chips, with two chips per CAS line. The 2-MByte  The fast page mode solution does not work for
configuration can be supported with x8 DRAMs.  EDO  memory (bit 2 of CR36 is cleared to 0)
Each x16 chip is replaced by two x8 chips, with 1  because OE turns off the output buffers instead
chip per CAS line. A 0.5 MByte Tri032 configura  of CAS and the same OE signal (OEO) normally
tion requires only the chip or chips driven by  drives all memory banks. The Tri064 handles this
RASO, CASO and CAS1 and only uses PD[15:0].  by providing a second OE output (OE1) on pin 50.
For 64-bit PO bus operation, this output is identi
Figure 7-2 shows a Tri064 2-MByte configuration  cal to OEO so all memory banks are enabled for
where either fast page or EDO memory is sup  output. When the feature connector is enabled,
ported with the same hardware design. The ra  OE1  stays high throughout the entire memory
tionale behind this design, including why it  cycle. Therefore, by connecting pin 50 to the OE
cannot be upgraded to 4 MBytes, is explained  inputs of the 2nd MByte of memory, the desired
memory data output is achieved for EDO mem
next.
ory for all operational modes.
PD[31:0)
|     | 256Kx16  PD[15:0)  |            | 256Kx16  PD[15:0)  |     |
| --- | ------------------ | ---------- | ------------------ | --- |
|     | ~ ~                | ~ 7ffif""  |                    |     |
OEO
|     | RASO  |     | RAS1  |     |
| --- | ----- | --- | ----- | --- |
|     | CAS1  |     | CASO  |     |
CAST
CASO
|     | WE  |     | WE  |     |
| --- | --- | --- | --- | --- |
MA[8:0)
...
| Trio32/  |                     | --  |                     |     |
| -------- | ------------------- | --- | ------------------- | --- |
| Trio64   | 256Kx16  PD[31:16)  |     | 256Kx16  PD[31:16)  |     |
|          | ~                   |     | ~                   |     |
|          | RASO                |     | RAS1                |     |
|          | CAS2                |     | CAS2                |     |
|          | CAS3                |     | CAS3                |     |
WE
WE
'·2MBT32
RAM CONTROL
|     | \   | )  \  |     | }   |
| --- | --- | ----- | --- | --- |
y  y
1ST MBYTE -Trio32 OR Trio64
2ND MBYTE -Trio32 ONLY
Figure 7-1. 1-MByte Trio32/64 -2 MByte Trio32 Memory
7-2  DISPLAY MEMORY

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Fast page memory does not require OE1. All OE  7.2  DISPLAY MEMORY REFRESH
inputs are driven by the OEO signal. If fast page
mode operation is selected, both pin 124 and pin
The Tri032rrri064 uses the standard CAS before
50 (by default) will output OEO.
RAS DRAM refresh method. The functional tim
ing for this can be found in any standard DRAM
A 4-MByte Tri064 configuration requires RAS1 to
data book.
select the 3rd and 4th MBytes. The Tri064 outputs
RAS1 on pin 50 when bit 6 of SRA is set to 1 for
The number of refresh cycles performed per hori
fast page mode operation. (This bit is a don't care
zontalline is determined by bit 6 of CR11. If bit 2
for EDO operation, where pin 50 always outputs
of CR3A is set to 1, the number of refresh cycles
OE1. The power-on default for this bit is 0, which
causes pin 50 to output OEO for fast page mode  per horizontal line is determined by the setting of
bits 1-0 of CR3A. Refreshes are performed during
operation as explained above.) Figure 7-3 shows
the horizontal blanking period.
a 4-MByte Tri064 fast page mode configuration
using RAS1. Since RAS1 is not available for EDO
mode, the maximum EDO memory configuration
is 2 MBytes.
FAST PAGE (FP) MODE OR EDO MEMORY AND SRA_6 = o (PIN 50 = OEO FOR FP AND OE1 FOR EDO)
PD[63:0)
-
,...
|     | 256Kx16  PD[15:0)  |     | 256Kx16  PD[47:32)  |     |
| --- | ------------------ | --- | ------------------- | --- |
|     | Wo""               |     | rpijffo             |     |
|     | RASO               |     | RASO                |     |
W4
CAS1
fAS5
CASO
|     | WE  |     | WE  |     |
| --- | --- | --- | --- | --- |
MA[8:0)
|         | -                   | ...  |                     |     |
| ------- | ------------------- | ---- | ------------------- | --- |
| Trio64  | 256Kx16  PD[31:16)  |      | 256Kx16  PD[63:48)  |     |
FoFo"'
~
~O
|     | RASO  |     | RASO  |     |
| --- | ----- | --- | ----- | --- |
'CAsG
CAS2
|     | CAS3  |     | CAS7  |     |
| --- | ----- | --- | ----- | --- |
|     | WE    |     | WE    |     |
2MBFPEDO
RAM CONTROL
|     | \.  | )  \.  |     | )   |
| --- | --- | ------ | --- | --- |
Y  Y
|     | 1STMBYTE  |     | 2NDMBVTE  |     |
| --- | --------- | --- | --------- | --- |
Figure 7-2. 2-MByte Trio64 DRAM Configuration
|     |     |     | DISPLAY MEMORY  | 7-3  |
| --- | --- | --- | --------------- | ---- |

I'lL
-...I
~
eCnl
"'Il
| ~   |     | !  -- |
| --- | --- | ----- |
II.
s:
s:  m
0
~
..  :n
ca
c
CD
-...I  PO[63:.[
~
| £   |     | en  |
| --- | --- | --- |
C o )
| -m;   |     | : ; t   |
| ----- | --- | ------- |
O·
-I  MA[a:.[
| ::::!.     |     | Co)       |
| ---------- | --- | --------- |
| 0          |     | N         |
| ~  Tri064  |     | '.:.:. i  |
| ."         |     | O·        |
'V
C
| jJ  |     | ~   |
| --- | --- | --- |
| ~   |     | 5'  |
| 0   |     | r+  |
CD
| 0  : : I   |        | (,Q    |
| ---------- | ------ | ------ |
| = =        | 4MBFP  | i i l  |
| c. a .     |        | r +    |
| c          |        | C D    |
FAST PAGE MODE MEMORY AND SRA..& = , [P1N 50 = RAS,)
C .
| ~   |     | .G..)   |
| --- | --- | ------- |
0
::I
I»
"0
::r
~.
l>
n
~
aCD
.o..
UI

fl·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
7.3 DISPLAY MEMORY ment of the RAS precharge (high) time. All of
these settings in CR6S can be made by power-on
FUNCTIONAL TIMING
strapping of PD[23:16) at reset or by program
ming after reset.
Figure 7-4 shows the functional timing for a fast
page mode read cycle. This also shows how Figure 7-5 shows the functional timing for a fast
certain parameters for various control signals page mode write cycle. The RAS and CAS signals
can be adjusted to meet the access time require can be adjusted as explained for the read cycle
ments of a variety of DRAMs. Bits 1-0 of CR6S above. The WE is delayed and the CAS signals
allow the pulse widths ofthe CAS and OE signals are stretched via bits 1-0 of CR6S.
to be adjusted. Bit 2 of CR6S allows adjustment
of the RAS low time. Bit 3 of CR68 allows adjust-
T1 T2 T3 T4 T5 T6 T7 T8 T9 T10
\~~[J::LJl,
......... SEENOTE3 ~
IJE(... . ___ -'X X
~'"===='"
MA[8:0) R_O_W_ __ COLUMN COLUMN
\~~[l:-~_J],
......... SEE NOTE 3 ~
PD[63:0)
KMEMRD
Figure 7·4. Fast Page Mode Read Cycle
Notes
1. The minimum RAS precharge time can be adjusted from 2.5 to 3.5 MCLKs via bit 3 of CR6S.
2. The minimum RAS low time for a single column access is 3.5 MCLKs as shown in this figure.
(The dashed line shows the RAS signal if the second page mode cycle were to be eliminated.)
This minimum RAS active time can be lengthened to 4.5 MCLKs via bit 2 of CR68.
3. The CAS and OE active (low) times can be stretched via bits 1-0 of CR68.
DISPLAY MEMORY 7-5

,I.
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Figure 7-6 shows the functional timing for an  latched because EDO memory does not keep
Extended Data Out (EDO) mode read cycle. One  data valid after OE goes inactive. Despite this,
difference between an EDO read cycle and a fast  EDO memory will generally provide better per
page mode read cycle is that since EDO memory  formance than fas~ge mode memory. Note
holds the data valid longer, it allows the data to  that RAS, the last CAS and OE are all stretched
be latched one cycle later (rising edges ofT8 and  one MCLK. With EDO, OE is held lowforthe entire
T10). This allows the use of slower access time  cycle instead of being pulsed as in a fast page
| memory or a faster MCLK. However, the last page  |     |     |     | mode cycle.  |     |     |     |
| ------------------------------------------------ | --- | --- | --- | ------------ | --- | --- | --- |
| access (or first for a single access)            |     |     |     | must be      |     |     |     |
stretched one MCLK to allow the data to be
|     |     |     | T3  | T4  T5  | T6  | T7  T8  | T9  T10  |
| --- | --- | --- | --- | ------- | --- | ------- | -------- |
|     | T1  | T2  |     |         |     |         |          |
MCLK
:l--~-----------Ir-------------
,'-----iC!::L-J-!,
SEE NOTE 3 ---=:::".
"
|          | ~\- |             |     | ....IX      | X   |                | ~"'===="177  |
| -------- | --- | ----------- | --- | ----------- | --- | -------------- | ------------ |
| MA[8:0)  |     | ___R_ O_W_  |     | __  COLUMN  |     | COLUMN         |              |
|          |     |             |     |             |     | .   ... ..     |  .J.., .     |
|          |     |             |     |             |     | r -. r .     u | .            |
~
"'-SEE NOTE 3
|           | ~I- |             |     | ~           | ..../Xl-__  |                   |     |
| --------- | --- | ----------- | --- | ----------- | ----------- | ----------------- | --- |
| PD[63:0)  |     | ___W _P_B_  | __  | __D_ A_T_A  | _           | D_A_T_A_..../rla  |     |
KMEMWR
Figure 7-5. Fast Page Mode Write Cycle
Notes
1. The minimum RAS precharge time can be adjusted from 2.5 to 3.5 MCLKs via bit 3 of CR68.
2. The minimum RAS low time for a single column access is 3.5 MCLKs as shown in this figure.
(The dashed line shows the RAS signal if the second page mode cycle were to be eliminated.)
This minimum RAS active time can be lengthened to 4.5 MCLKs via bit 2 of CR68.
3. The CAS active (low) time can be stretched and the WE active (low) time delayed via bits 1-0 of
CR68.
7-6  DISPLAY MEMORY

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
The timing adjustments for RAS and for connector operation disabled). Ifthe feature con
CAS/OENVE as described above for a fast page nector is enabled, OEO only enables data output
mode read cycle also apply to EDO cycles. Note on PD[31:0] and OE1 (not shown) stays high the
that if the minimum RAS active time is specified entire cycle to disable output on PD[64:32].
as 3.5 MCLKs, the actual minimum for a single
EDO read cycle will be 4.5 MCLKs. An EDO write cycle is functionally the same as a
fast page mode write cycle.
The cycle depicted in Figure 7-6 is for 64-bit PD
bus operation (2 MBytes of memory and feature
T1 12 T3 T4 T5 T6 17 T8 T9 T10
MCLK
+f'--____________
SEE NOTE 1 .of-____- I
\ u;:'L-J_.l
SEENOTE3~
~\.. ~"'=='""'='"
MA[8:0) ___R_ O_W_ __. ..JX COLUMN X COLUMN
rr--
OEO \
SEENOTE;'~
D_A_TA_~X
PD[63:0) _ \ . ._ _ DATA.
KEDOMEMR
Figure 7-6. EDO Mode Read Cycle
Notes
1. The minimum RAS precharge time can be adjusted from 2.5 to 3.5 MCLKs via bit 3 of CR68.
2. The minimum RAS low time for a single column access is 4.5 MCLKs as shown in this figure.
This is achieved by specifying 3.5 MCLKs in bit 2 of CR68. (The dashed line shows the RAS sig
nal if the second page mode cycle were to be eliminated.) This minimum RAS active time can
be lengthened by 1 MCLK via bit 2 of CR68.
3. The CAS and OE active (low) times can be stretched via bits 1-0 of CR68.
DISPLAY MEMORY 7-7

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
7 .4 DISPLAY MEMORY ACCESS The Tri032/Tri064 provides a patented technique
CONTROL for maximizing video performance while pre
venting display FIFO underrun. This involves pro
gramming of two parameters. These are the M
Figure 7-7 shows that a number of processes parameter (bits 7-3 of CR54) and N parameter
compete for access to display memory for a (bits 7-0 of CR60). Note that these are not the
Tri064. The Tri032 is similar except that the same as the PLL M and PLL N parameters used
Graphics Engine and Display FIFO data paths are to specify the clock synthesizer frequencies.
each 32 bits. These competing processes are (in
decreasing order of access priority): When the Tri032fTri064 transfers data from dis
play memory to the FIFO, the N parameter speci
• RAM refresh (not explicitly shown) fies one less than the number of4-byte (1 MByte
• Hardware cursor fetch (not shown) of memory) or 8-byte (2 or 4 MBytes of memory
for a Tri064) units to write. When N units have
• Display FIFO reads
been written or the FIFO is filled, whichever
• Secondary controller request/grant (S3 comes first, the Tri032/Tri064 then allows the
Shared Frame Buffer Interface) other display memory processes access to mem
• CPU accesses ory. Filling of the FIFO also stops at the end of
active display. FIFO filling cannot begin again
• Graphics Engine accesses
until the scan line position defined by the Start
Display FIFO register (CR3B), which is normally
For the Tri064, the display FIFO is 32 bits wide by
programmed with a value 5 less than the value
16 positions deep with 1 MByte of display mem
programmed in CRO (horizontal total). This pro
ory or 64 bits wide by 16 positions deep for 2 or
vides time during the horizontal blanking period
4 MBytes of display memory. This FIFO provides
for RAM refresh and hardware cursor fetch.
the display refresh data to the RAMDAC and must
never underrun, i.e., output more data than has
The M parameter specifies the number of 8-byte
been input to it from display memory. If an un
(4-byte for Tri032) memory access cycles (less
derrun occurs, the display may be corrupted.
one) that can be performed for reasons other
than display FIFO filling. (One entry cycle re-
32 32
r--- ----- ------------
Trio64
KM&N
Figure 7-7. Display Memory Access Sources
7-8 DISPLAY MEMORY

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad
quires 6-9 MCLKs; one page mode cycle requires Bit 0 of SRD must be cleared to 0 to select the
2 MCLKs.) When this number of access cycles has BGNT function for pin 155.
been performed, memory control is returned for
FIFO filling. For example, a value of 01010b (10 The Tri032/Tri064 has two pins that are used for
decimal) specifies that eleven memory cycles are the frame buffer arbitration. These pins imple
available to the CPU, Graphics Engine, etc., be ment a Bus REQuest (BREQ) and Bus GraNT
fore FIFO filling restarts. For one entry cycle and (BGNT) protocol. BREQ is an input to the
10 page mode cycles, this would be a maximum Tri032/Tri064 and BGNT is an output. When the
of 9 + (10x2) = 29 MCLKs allowed before memory Tri032/Tri064 grants the bus to the secondary
access is returned for FIFO filling. If during the controller, it also floats its memory control output
processing period controlled by the M parameter signals so that the secondary controller has full
there is time when there are no memory access access to the memory. With full access to mem
requests and the M value has not been reached, ory, the secondary controller can operate at its
control is immediately returned to FIFO filling as optimum speed for memory accessing.
specified by the N parameter.
Since the Tri032/Tri064 is responsible for screen
M should be maximized for maximum graphics and DRAM refreshing, it must ensure that the
performance. The maximum value of M possible secondary controller does not retain control of
without causing a FIFO underrun is dependent on the memory bus for too long a time. It uses the P
the pixel data bandwidth required for the particu parameter to provide this control. The 5-bit P
lar mode in question. The calculation is based on parameter field (bits 4-0 of SRA) is programmed
a FIFO filling bandwidth of 120 (1 MByte) or 240 in units of 2 MCLKs. The value programmed
(2 or 4 MBytes) MBytes/second. The maximum specifies one less than the number of MCLKs
value is also possibly dependent on the N pa times 2 that the secondary controller can retain
rameter value if the FIFO is not filled each cycle. control of the memory bus before the
Tri032/Tri064 removes its bus grant. For exam
Note that the M and N parameters should only ple, a programmed value of 5 (decimal) specifies
be changed with the screen turned off. This is that the Tri032/Tri064 will remove its bus grant
done by setting bit 5 of SR1 to 1. after (5+1)x2 = 12 MCLKs. At maximum, the bus
can be granted for 64 MCLKs.
The above discussion assumes that the
Tri032/Tri064 has control ofthe memory bus. The How long the secondary controller can retain
next section describes the implications of allow control without causing problems is a function of
ing a secondary memory controller to take con many variables, including the M and N parameter
trol of the display memory bus. settings, the pixel data bandwidth of the
RAMDAC, the needs of the CPU and Graphics
Engine to access display memory and the timing
7.5 SHARED FRAME BUFFER
of the bus request (during screen active or inac
tive). In general, the secondary controller should
For multimedia applications, the Tri032/Tri064 retain control for a period less than the time that
provides the S3 Shared Frame Buffer Interface. would normally be allocated to the M parameter,
(Note that bandwidth limitations severely restrict and the time allocated to the P parameter should
the usability of this function for the Tri032.) This be subtracted from the time allocated to the M
allows it to share the video frame buffer (display parameter. For pure live video display without
memory) with a secondary controller. At all graphics updating, the M parameter can be setto
times, the Tri032/Tri064 serves as the primary o (allowing 1 memory cycle) and the rest of the
display memory controller. As the primary con non-FIFO fill bandwidth given to the P parameter.
troller, the Tri032/Tri064 takes responsibility for See Section 7.4, Display Memory Access Control
screen management functions such as DRAM for more information on the M and N parameters.
refresh cycles and the arbitration of frame buffer
requests from a secondary controller. The shared The timing diagram shown in Figure 7-8 illus
frame buffer function is enabled via bit 2 of CR50. trates the arbitration handshake between the
DISPLAY MEMORY 7-9

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Tri032[Tri064 and the secondary controller. This ing BGNT. In other words, during the active dis
figure is explained in the following paragraphs. play period, the Tri032[Tri064 only grants control
of the bus at the end of display FIFO filling.
Display FIFO filling ends at the end of the active Subsequent M parameter-controlled processing
display time for each scan line and does not is then delayed until bus control is returned to the
begin again until the Start FIFO Fetch time, which Tri032[Tri064.
is typically programmed to be just before the end
of blanking. Therefore, the Tri032/Tri064 re Second, assume that the request occurs during
sponse to a BREQ depends on whether the re the inactive display period (blanking). The
quest occurs during the active display period or Tri032/Tri064 will complete any ongoing cursor
during blanking. fetch or DRAM refresh and then grant control of
the memory bus with the timing described
First, assume that the secondary controller as above. If it is doing M parameter processing, it
serts the BREQ signal to the Tri032[Tri064 during will complete that processing and then grant the
the active display time to request the bus. This bus provided a hardware cursor fetch or DRAM
asynchronous input is internally synchronized by refresh is not pending.
the Tri032/Tri064. the Tri032[Tri064 then grants
control ofthe pixel data bus and memory control When control has been granted to the secondary
signals to the secondary controller by asserting controller, it keeps the BREQ signal active and is
BGNT immediately after completion of memory then able to perform read and write cycles to the
accesses controlled by the N parameter (FIFO display memory. Return of control to the
filling) and tri-stating the memory bus signals Tri032/Tri064 can be initiated by either the
within 15 ns ofthis assertion. Ifthe Tri032/Tri064 Tri032[Tri064 or the secondary controller.
is performing a memory cycle controlled by the
M parameter (CPU or Graphics Engine access) During the active display period, the
when the secondary controller requests the bus, Tri032/Tri064 removes its bus grant (raises BGNT
it completes both the M cycle processing and the high) when the number of MCLK cycles specified
next N (FIFO fill) cycle processing before assert- by the P parameter has occurred. The secondary
Trio64
DRIVING
MEMORY BUS
SECONDARY
CONTROLLER -----{('--__J ------I(I------I}---
DRIVING
MEMORY BUS
=
A = 5 MCLKs (MIN) B 5 MCLKs (MAX) KSHBUFTM
Figure 7-8. Shared Frame Buffer Protocol Timing
7-10 DISPLAY MEMORY

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
controller must then raise BREQ high within 500
ns, tri-state its memory bus signals within 15 ns
of raising BREQ and give up the bus for at least
60 ns. The secondary controller can then reassert
BREQ at any time. Note that the Tri 032/Tri 064 can
remove its bus grant in as little as three MCLK
periods.
During the blanking period, the Tri032/Tri064
removes its bus grant whenever it needs to do a
hardware cursor fetch or DRAM refresh. It also
raises BGNT atthe start of FIFO filling as specified
by the Start Display FIFO register (CR3B). The
secondary controller must then give up the bus
with the timing described above.
The secondary controller can give up the bus by
raising BREQ and tri-stating its memory bus sig
nals. The Tri032/Tri064 then raises its BGNT sig
nal within 5 MCLKs and begins to drive the
memory bus signals. This sequence is shown in
the second bus grant cycle depicted in Figure 7-8.
DISPLAY MEMORY 7-11

".
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Section 8: RAMDAC Functionality
For 8 bits/pixel modes, the Tri032fTri064 internal 1. 8 bits (low byte of the internal pixel address
24-bit RAMDAC provides three 256 6-bit word bus) are latched each pixel clock and are
color look-up table (LUT) RAMs feeding three used to select a LUT location.
8-bit DACs. A clock doubled mode is also pro
2. 16 bits (low two bytes ofthe internal pixel
vided for 8 bits/pixel modes. A 24-bit LUT bypass address bus) are latched each pixel clock.
is provided for 15/16-and 24-bit color modes. A These select two consecutive LUT loca
special 640x480x24 mode is provided for the tions, the data from which is clocked out
Tri032 to allow true color operation with 1 MByte to the DACs at twice the pixel clock rate.
of memory. The block diagram for the internal
3. 15 or 16 bits (lower two bytes ofthe inter
RAMDAC is shown in Figure 8-1.
nal pixel address bus) or 24 bits (all three
bytes of the internal address bus) are
8.1 COLOR MODES transferred directly to the DACs each pixel
clock.
The Tri032fTri064 internal RAMDAC provides 6
color modes of the following 3 primary types:
VREF RSET COMP
HIGH· AND TRUE-COLOR BYPASS
8/6
t---r+t+-AR
24
8/6
6 MUX
6 18 8/6 t-r-t-Ht+-AB
PAI23:0] 1-.....
24
6
INTERNAL RAMDAC BLOCK ......_ ....,..---'
Trio32/Trio64
Figure 8·1. Internal RAMDAC Block Diagram
RAMDAC FUNCTIONALITY 8-1

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table 8·1 Trio32/Trio64 Color Modes
Color CR67 MAX MAX
Mode Bits 7-4 PABits DCLK Pixel Rate Description
0 0000 7:0 80 MHz 80 MHz 8-bit pseudo-color (LUT) -Default
8 0001 15:0 67.5 MHz 135 MHz Two 8-bit pseudo-color (LUT)
9, 0011 15:0 80 MHz 80 MHz 15-bit high-color ( LUT Bypass)
10 0101 15:0 80 MHz 80 MHz 16-bit high-color (LUT Bypass)
12 0111 23:0 75 MHz 25 MHz 640x480x24-bit packed (LUT Bypass-Tri032)
13 1101 23:0 50 MHz 50 MHz 24-bit true-color (LUT Bypass)
Each of the 6 color modes is listed in Table 3-1. on an internal clock running at twice the VCLK
The desired mode is selected by programming rate. Either bit 4 or bit 6 of SR15 must be set to 1
bits 7-4 of CR67. when this mode is selected and bit 7 of SR18
must also be set to 1. The byte coding for the
internal pixel data bus is shown in Figure 8-2.
8.1.1 8 Bits/Pixel -Mode 0
This mode processes two pixels per VCLK with a
Mode 0 is selected by setting bits 7-4 of CR67 to maximum VCLK rate of 67.5 MHz. This results in
OOOOb. In this mode, the low 8 internal pixel an effective pixel output clock rate of 135 MHz.
address bus bits are ANDed with the contents of
the Pixel Read Mask register (3C6H). The result The internal pixel bus bits are ANDed with the
of the AND operation selects one of 256 LUT contents of the Pixel Read Mask register. The
locations. This results in the output of 6 bits of result of the AND operation selects one of 256
color information to each of the DACs. The byte LUT locations. This results in the output of 6 bits
coding for the internal pixel data bus is shown in of color information to each of the DACs.
Figure 8-2.
8.1.3 15/16-Bits/Pixel-Modes 9 and
8.1.2 Output-doubled 8 Bits/Pixel - 10
Mode 8
These modes are selected by setting bits [7:41 of
This mode is selected by setting bits 7-4 of CR67 CR67 to 0011b (15 bits/pixel) or 0101b (16
to 0001 b. In this mode, latching of pixel data from bits/pixel). In either case, one pixel is transferred
the lower two bytes ofthe internal pixel data bus on the lower two bytes of the internal pixel bus
is based on the pixel clock (VCLK) and output of each VCLK cycle. This data is sent directly to the
pixel data from the latches to the DACs is based
Middle B e (PA[15:8])
Ignored for Mode 0, used for Mode 8
Upper B:e (PA[23:16])
I nored
Figure 8·2. 8 Bits/Pixel Internal PA Bus Coding
8-2 RAMDAC FUNCTIONALITY

53 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Upper B~e (PA[23:16])
I nored
Figure 8-3. 15 Bits/Pixellnternal PA Bus Coding
Upper Byte (PA[23:16])
Figure 8-4. 16 Bits/Pixellnternal PA Bus Coding
DACs via the LUT bypass. The byte coding is internally divided by 3 to provide the VCLK to the
shown in Figures 8-3 and 8-4. internal RAMDAC. Thus, one pixel (with the cod
ing shown in Figure 8-5) is latched into the RAM
DAC every three DCLKs. Bits 4-3 of CR65 must be
8.1.4 Packed 24 Bits/Pixel- Mode 12
set to lOb for this mode to delay BLANK to the
(Trio32 Only) RAMDAC by 2 DCLKs. The internal hardware
cursor cannot be used in this mode.
This mode is selected by setting bit 3 of SRB to
1, bits 7-4 of CR67 to 0111 b and bits 7-4 of CR67
8.1.5 24 Bits/Pixel-Mode 13
to OOOOb.lt is used for a resolution of 640x480x24.
Each pixel is stored in 24 bits of memory, allow
ing operation with 1 MByte of memory. One byte This mode is selected by setting bits [7:41 of CR67
of color data is retrieved each DCLK. DCLK is to 1101b. One pixel is transferred to the DACs
Upper Byte (PA[23:1611
I I I I I
R7 R6 R5 R4 R3 R2 Rl RO
Figure 8-5. 24 Bits/Pixellnternal PA Bus Coding
RAMDAC FUNCTIONALITY 8-3

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
each VCLK cycle via the LUT bypass. The byte The state of this internal signal can be read via
coding forthe internal pixel address bus is shown bit 4 of 3C2H. This information can be used to
in Figure 8-5. detect the existence and type of monitor
(color/mono) connected to the system.
8.2 RAMDAC REGISTER ACCESS
The standard VGA RAMDAC register set (3C6H -
3C9H) is used to access the internal RAMDAC
registers.
8.3 RAMDAC SNOOPING
For PCI bus configurations, setting bit 5 of the
Command configuration space register (Index
04H) to 1 causes the Tri032/Tri064 to snoop for
RAMDAC writes. This means that the
Tri032/Tri064 will write the data to its local
RAMDAC but will not claim the cycle by asserting
DEVSEL. This allows the ISA controller to also
generate a write cycle to a secondary RAMDAC.
The Tri032/Tri064 always provides the data for
RAMDAC reads.
If bit 5 of the PCI Command register is cleared to
0, the Tri032/Tri064 claims all RAMDAC read and
write cycles.
Bits 2-0 of CR34 allow handling of PCI master
aborts and retries to be individually enabled or
disabled during RAMDAC cycles.
If power-on strapping bit 12 (CR37, bit 4) is pulled
low at resetfor a VL-Bus configuration, LOCA and
SRDY are not generated by the Tri032/Tri064 for
RAMDAC write accesses. The Tri032/Tri064 gen
erates write cycles to the local RAMDAC and the
ISA controller also generates cycles to an off
board RAMDAC (mirroring). RAMDAC reads are
always from the local RAMDAC.
Ifbit7 ofCR37 is setto 1, the Tri032/Tri064 claims
all RAMDAC read and write cycles (LOCA and
SRDY are generated).
8.4 SENSE GENERATION
The internal RAMDAC contains analog voltage
comparators. These drive the internal SENSE
signal active low whenever the output on any of
the AR, AG or AB pins exceeds 330 mV ± 20%.
8-4 RAMDAC FUNCTIONALITY

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Section 9: Clock Synthesis and Control
The Tri032/Tri064 contains two phase-locked particular, the R value is the code, not the actual
loop (PLL) frequency synthesizers. These gener frequency divisor.
ate the DCLK (video clock) and MCLK (memory
clock signals for the graphics controller block. On power-up, the CLK1 frequency is 44.606 MHz.
The DCLK signal is converted to the VCLK signal This can be reprogrammed in exactly the same
by the graphics controller block. This signal manner as explained above forthe CLKOfrequen
latches pixel data to the RAMDAC. cies.
The PLL M value can be programmed with any
9.1 CLOCK SYNTHESIS
integer value from 1 to 127. The binary equivalent
of this value is programmed in bits 6-0 of SR11
Each PLL scales a single reference frequency forthe MCLKand in bits 6-0 of SR13forthe DCLK.
input on the XIN pin. By placing a parallel-reso The PLL feedback loop frequency from the volt
nant crystal between the XOUT output pin and age controlled oscillator stage is scaled by divid
the XIN pin, the reference frequency is generated ing that frequency by (M+2).
by the Tri032/Tri064's internal oscillator. Alter
nately, a CMOS-compatible clock input can be The PLL N value can be programmed with any
connected to XIN to provide the reference fre integer value from 1 to 31. The binary equivalent
quency. ofthis value is programmed in bits 15-11 ofSR10
for the MCLK and in bits 15-11 of SR12 for the
The frequency synthesized by each PLL is deter DCLK. The reference frequency is divided by
mined by the following equation: (N+2) before being fed to the phase detector
stage of the PLL.
fOUT (Mt2) X fREF
(N+2)x2R The PLL R value is a 2-bit range value that can be
programmed with any integer value from 0 to 3.
The R value is programmed in bits 6-5 of SR 10
where R = 0,1,2 or 3
for MCLK and bits 6-5 of SR12 for DCLK. This
value codes the selection of a frequency divider
Programmed PLL M and PLL N values should be
for the PLL output. This is shown Table 9-1.
consistent with the following constraints:
Table 9-1. PLL R Parameter Decoding
1. 135MHz~ (Mt~fREF ~ 270MHz
( 2)
R-Range Code Frequency Divider
2. min N ~ 1 00 1
01 2
Note that values used for the parameters are the 10 4
integer equivalents ofthe programmed value. In
11 8
CLOCK SYNTHESIS AND CONTROL 9-1

..-
..fa
•
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
KPlLBLK
Figure 9·1. PLL Block Diagram
The entire PLL block diagram is shown in Figure All other DCLK frequencies must be generated by
9-1. re-programming SR12 and SR13. The new PLL
parameter values can be loaded in one of two
The following sequence may be followed to ar ways. If bit 5 of SR 15 is cleared to 0, the new DCLK
rive at M and N values for any mode. frequency is loaded by setting bit 1 of SR15 to 1
and then setting bits 3-2 of 3C2H to 11 (iftheyare
1. Calculate an R which does not violate the not already programmed to this value). Bit 1 of
following constrains: SR15 should be left at a value of 1. Actual loading
will be delayed for a short but variable period of
135MHz< 2RXfoUT'5. 270MHz time.
2. Start with N1 = 1 and calculate: The alternate approach to loading the new DCLK
frequency is to program bits 3-2 of 3C2 to 11 (if
R
M= [fOUTX (N+2) x2 J-2 they are not already programmed to this value).
fREF Next, program SR12 and SR13 and then toggle
bit 5 of SR15 by programming it to a 1 and then
3. Determine if the following constraint is met:
a O. This immediately loads the DCLK and MCLK
frequencies (no variable delay). For example,
(Mt-2) fREF
0.995 fOUT< N2 < 1.005 fOUT pseudocode to change DCLK to the frequency
(N1+2) 2 specified by PLL parameter values of 34H and
4. If the constraint in step 3 is met, the M and 56H is:
N values used will generate the desired
frequency (within the specified tolerance). 3C2 <= 6FH DCLK specified by
If the constrain is not met, repeat steps 2 CRl2 and CR13
and 3 with N increased by 1 each time un 3C4 <= l2H CRl2 index
til the constraint in step 3 is met. Note that 3C5 <= 34H CRl2 PLL value
multiple combinations of M and N are pos
3C4 <= l3H CR13 index
sible for a given output frequency.
3C5 <= 56H CRl3 PLL value
3C4 <= l5H CRl5 index
9.2 CLOCK REPROGRAMMING
3C5 <= RMW Use read/modify/write to
set bit 5 to 1 and leave
The Tri032/Tri064 powers up with a DCLK fre other bits unchanged
quency of 25.125 MHz (standard VGA) and an 3C5 <= RMW Use read/modify/write to
MCLK frequency of 45 MHz. The DCLK frequency clear bit 5 to 0 and
can be changed to 28.322 MHz by setting bits 3-2 leave other bits
of3C2H to 01b and can be changed backto 25.125 unchanged
MHz by setting bits 3-2 of 3C2H to OOb. The
loading of the DCLK frequency values requires
Either loading approach should work. The sec
that bit 1 of SR15 be setto 1.
ond (immediate loading) approach helps with
system testing since the timing of the load is
9-2 CLOCK SYNTHESIS AND CONTROL

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
predictable. The first approach (via bit 1 of SR15)
has the advantage of separating the loading of
DCLK from that of MCLK.
After power-up, all MCLK frequency changes
must be made by re-programming SR10 and
SR11. If bit 5 of SR15 is cleared to 0, the new
frequency does not take effect until a 1 has been
written to bit 0 of SR15. This bit must then be
cleared to 0 to prevent repeated loading. Actual
loading will be delayed for a short but variable
period of time.
As explained above for DCLK, toggling bit 5 of
SR15 (0,1,0) immediately loads both the DCLK
values in SR12 and SR13 and the MCLK values in
SR10 and SR11.
9.3 DCLK CONTROL
DCLK is generated by the internal clock synthe
sizer. VCLK is the signal used to clock pixel data
into the internal RAMDAC. For most modes of
operation, VCLK is generated directly from VCLK
and has the same frequency and phase (neglect
ing internal gate delays). Bit 0 of CR67 provides
the option to invert DCLK before it becomes
VCLK.
In mode 8, the internal RAMDAC requires two
clocks. The normal internal DCLK frequency is
divided by two via bit 4 of SR15 to provide the
standard VCLK input. Undivided DCLK provides
the other input. This clock can be inverted via bit
6 of SR15.
The internal RAMDAC can also have pixel data
clocked in by an externally provided feature con
nector clock. For the VESA Advanced Feature
Connector (VAFC), this clock is VCLKI, which is
selected via bit 1 of SRB. For a pass-through
connector, this clock is input on the VCLK pin and
is enabled by asserting the EVCLK signal and by
clearing bit 3 of CR33 to O.
Certain 4 bits/pixel modes require that DCLK be
halved. This is the case for bit 6 of AR10 set to 1
and bit 4 of CR3A cleared to 0 and is enabled by
setting bit4 or SR15to 1 and clearing bit3 ofCR33
to O.
CLOCK SYNTHESIS AND CONTROL 9-3

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Section 10: Miscellaneous Functions
This section explains how the Trio32fTrio64 inter strapping bit 4 (CR36, bit 4) must be pulled low
faces to the video BIOS ROM and feature connec to disable BIOS accesses. For PCI configurations,
tor. The General I/O Ports, Green PC support, bit 0 of the BIOS ROM Base Address register
genlocking and interrupt generation are also de (Index 30H) is cleared to 0 to disable BIOS ac
scribed. cesses.
10.1 VIDEO BIOS ROM INTERFACE 10.1.2 BIOS ROM Hardware Interface
The video BIOS ROM contains power-on initiali A separate implementation of the video BIOS for
zation, mode setup, and video data read/write a PCI configuration is shown in Figure 10-1. The
routines. The video BIOS can be part of the sys implementation for a VL-Bus configuration is
tem ROM or it can be implemented separately. shown in Figure 10-2. The ROM is accessed via
the ISA bus. This allows a shadowed BIOS to be
accessed by a CPU memory read without also
10.1.1 Disabling BIOS ROM Accesses
generating data directly from the physical ROM.
Only 8-bit ROMs are supported.
If the video BIOS is integrated with the system
BIOS in a VL-Bus configuration, then power-on
Trio32/64 BIOS ROM
GO[7:0] 0[7:0]
GA[15:0] A[15:0]
ROMEN OE
I
CE
KPCIROM
Figure 10-1. BIOS ROM PCI Configuration Interface
MISCELLANEOUS FUNCTIONS 10-1

••
r
53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
VESA
LO.C. AL BUS
r-
SA[31:2)
Trio32/64
ADDRESS
BIOS ROMCS
ROM
0[7:0)
- -
, OE CE
I
OE?~
74ALS244
OE1
~ 7'
<.A SA[15:0) SMEMR j,.
ISABUS ,. KVLROMIF
...
Figure 10-2. BIOS ROM VL-Bus Configuration Interface
10.1.3 BIOS ROM Read Functional For a VL-Bus configuration, a BIOS ROM read is
a standard ISA bus read cycle with the
Timing
Tri032rrri064 providing its ROMCS output as the
ROM chip and buffer enable (see Figure 10-2).
Figure 10-3 depicts the PCI configuration func ROMCS is asserted during the time the ROM
tional timing for reading one byte from the ROM. address is valid and therefore will be active when
RaMEN is asserted to drive the byte of read data the chipset asserts the ISA SMEMR signal.
at the address on GA[15:0) to the General Data
Bus. The Tri032rrri064 latches the data one clock
before deassertion of RaMEN and then drives 10.1.4 BIOS ROM Address Mapping
this data onto the AD bus.
The Tri032rrri064 maps the CPU memory ad
The Tri032rrri064 also supports 16- and 32-bit dress spaces for the video BIOS ROM into physi
ROM reads, as defined by the states of the byte cal ROM addresses. If implemented separately
enables. For a 16-bit read, the Tri032rrri064 auto for a VL-Bus system, the video BIOS normally
matically increments the lower address once and uses the standard address range COOOOH
generates the second byte of read data. For a C7FFFH (32 KBytes}.lf power-on strapping bit 10
32-bit read, the Tri032rrri064 automatically in (CR37, bit 2) is strapped low or if bit 2 of CR37 is
crements the lower address three times and gen cleared to 0 in a VL-Bus system, the video BIOS
erates the remaining three bytes of read data. In address range becomes COOOOH-CFFFFH (64
both cases, TRDY is delayed until all the required KBytes). PCI systems support a relocatable 64-
data is available on the AD bus. For 16-,24-or 32- KByte video BIOS address range via the BIOS
bit accesses, the ROM access time must be 10 ROM Base Address configuration register (Index
SCLKs or less, as opposed tothe 14 SCLKs shown 30H).
in Figure 10.3 for an 8-bit access.
10-2 MISCELLANEOUS FUNCTIONS

II·
53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
;
0
II
| . : ..0 . .:    |             |       | 9 -   |
| --------------- | ----------- | ----- | ----- |
| I~              | ~   I~  I~  | I ~   |       |
| ( e n )         | M           | g !   | II I  |
|                 | 0'          | w     | ~     |
Q
|     | <I:  |     | Cl  |
| --- | ---- | --- | --- |
Figure 10-3. BIOS ROM Read Functional Timing -PCI
MISCELLANEOUS FUNCTIONS  10-3

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
10.2 GREEN PC SUPPORT from assertion of FRAME until data appears on
AD[7:0) is approximately 22-24 SCLKs.
The Tri032/Tri064 provides support for the VESA
When STRD is asserted for a VL-Bus configura
Display Power Management Signaling (DPMS)
tion, the data is immediately placed on SD[7:0).
protocol by allowing independent con.trol of t~e The functional timing for this operation is shown
HSYNC and VSYNC signals. To use this capabil
in Figure 10-7. The entire cycle from assertion of
ity, the bit pattern xxxx0110b must be written to
SADS to data being available on SD[7:0] takes
the SR8 register to unlock access to the SRD
approximately 18-20 SCLKs.
register. Bits 5-4 of SRD then control the state of
HSYNC and bits 7-6 of SRD control the state of
VSYNC. 10.4 GENERAL OUTPUT PORT
10.3 GENERAL INPUT PORT The Tri032/Tri064 provides an 8-bit General Out
put Port (GOP). The block diagram showing how
this is implemented for a PCI configuration is
The Tri032/Tri064 provides an 8-bit General Input
shown in Figure 10-4. The block diagram for a
Port (GIP). The block diagram showing how this
VL-Bus configuration is shown in Figure 10-S.
is implemented for a PCI configuration is shown
in Figure 10-4. The block diagram for a VL-Bus
The General Output Port register (CR5C) can be
configuration is shown in Figure 10-5.
set to any value by a CPU write. This causes the
STWR signal to be asserted and then deasserted.
Bit 2 of the Extended DAC Control register (CRS5)
Deassertion latches data into the GOP latch. For
is set to 1 to enable the GIP read function. The
a PCI configuration, the programmed values are
data is read from an external buffer by an I/O read
provided to the latch via GD[7:0). :he.functional
of port 3C8H (the same as the DAC Write Index
timing for this operation is s~own In Figure 10-~.
off-chip register). When STRD is asserted for a
The entire cycle from assertion of FRAME until
PCI configuration, this data is driven to the
latching of data in the GIP buffer is approximately
Tri032/Tri064 via GD[7:0) and latched by the ris
8-10 SCLKs.
ing edge ofthe internal MCLK preceding deasser
tion of STRD. The data then appear almost
For a VL-Bus configuration, the programmed val
immediately on AD[7:0). The functional timing
ues are provided to the latch via SD[1S:8]. The
for this is shown in Figure 10-6. The entire cycle
functional timing for this is shown in Figure 10-9.
Tri032/64 STWR 1------,
G
GENERAL
OUTPUT PORT 0[7:01
LATCH
D[7:0)
I----.......- -T----
GD[7:0)
GD[7:0)
STRD I----~ OE IN G P E U N T E P R O A R L T DIN[7:0) OEM D D E A F T I A N ABLE
BUFFER
KGDATF
Figure 10·4. General 1/0 Port Interfaces (PCI)
10-4 MISCELLANEOUS FUNCTIONS

fl·
53 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
VESA
LOCAL BUS
..t.  ~
50[31:0]
50[15:8]
5D[7:0]
Trio32/64
| D[7:0]  | 0[7:0]  |     |     |
| ------- | ------- | --- | --- |
GENERAL  GENERAL
| OUTPUT  | G +-- INPUT  | +-  |     |
| ------- | ------------ | --- | --- |
OE
| PORT   | PORT    |     |             |
| ------ | ------- | --- | ----------- |
| LATCH  | BUFFER  |     | 5TRD  5TWR  |
I
| 0[7:0]  | D[7:0]  |     |     |
| ------- | ------- | --- | --- |
OEM
DEFINABLE
DATA
....
>'"
KVLGDIF
Figure 10-5. General 1/0 Port Interfaces (VL-Busl
|     | T2  T3  | T4  T5  | T6  |
| --- | ------- | ------- | --- |
T1
MCLK
|     | ,'--_ _ | _- ----1/  |     |
| --- | ------- | ---------- | --- |
STRO
GO[7:0]
AO[7:0]
KGIPPCI
Figure 10-6. General Input Port Timing (PCI)
MISCELLANEOUS FUNCTIONS  10-5

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
T1 T2 T3 T4 T5 T6
8CLK
,'-----------'/
8TRO
80[7:0]
KGIPVL
Figure 10-7. General Input Port Timing (VL-Bus)
T1 T2 T3 T4 T5 T6
DCLK
\'------
SnNR /
----'
GD[7:0]
KGOPPCI
Figure 10-8. General Output Port Timing (pel)
10-6 MISCELLANEOUS FUNCTIONS

II· I~
53 Trio32/Trio64 Integrated Graphics Accelerators II
i
S3 Incorporated
I
T3 T4 T5
T1 T2
DCLK
\'"--
5TWR /
_----J
KGOPVL
Figure 10-9. General Output Port Timing (VL-Bus)
The entire cycle from assertion of SADS to latch bus operation regardless of its memory size. The
ing of data in the GOP buffer takes approximately Trio32 always operates with a 32-bit PO bus and
6-8 SCLKs. One use of the GOP is to provide can have 1 or 2 MBytes of memory.
programmable control of external logic.
Figure 10-11 shows the VAFC implementation for
Trio64 64-bit PO bus designs. The additional buff
10.5 FEATURE CONNECTOR
ers are required to isolate the PD bus from the
INTERFACE feature connector during 64-bit operation. This
means that memory size will be at least 2 M Bytes.
The Trio32fTrio64 provides an interface to either Setting bit 0 of SRO to 1 drives the ENFEAT pin
a baseline VESA Advanced Feature Connector low, enabling the isolation buffers. Note that the
(VAFC) or pass-through bidirectional feature con Trio64 always uses a 32-bit PD bus when feature
nector. In all cases (Trio32 and Trio64), bit 0 of connector operation is enabled and that the
SRD must be set to 1 to enable feature connector speed of the interface (VCLK/DCLK) is limited to
operation. For the Trio64, where feature connec 37.5 MHz. See the VESA VAFC specification for
tor signals are multiplexed with PD signals, set further description and timing specifications.
ting this bit selects the feature connector signals.
Figure 10-12 shows a bidirectional 8-bit pass
For a VAFC implementation, ESYNC and EVCLK through feature connector implementation for
are pulled up. This means that HSYNC, VSYNC, the Trio32 or the Trio64 configured for 32-bit PD
BLANK and VCLK are always outputs to the fea bus operation. When the feature connector func
ture connector. Pixel address data (PA[15:0] is an tion is enabled by setting bit 0 of SRO to 1, the
output from the Trio32fTrio64 if EVIDEO is high direction of the pixel data is controlled by the
and is an input to the Trio32fTrio64 if EVIDEO is polarity of the EVIOEO signal. If EVIDEO is low,
low. If bit 1 of SRB is set to 1, pixel data input is pixel data is an input to the Trio32fTrio64. If
strobed into the internal RAMOAC by VCLKI. EVIDEO is high, the Trio32fTrio64 outputs pixel
data to the feature connector.
Figure 10-10 shows a VAFC implementation for a
32-bit PO bus Trio32fTrio64 implementation. This If ESYNC is low, HSYNC, VSYNC and BLANK are
means that the Trio64 is restricted to 32-bit PO inputs to the Trio32fTrio64. If ESYNC is high,
MISCELLANEOUS FUNCTIONS 10-7

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
| Trio32/64  | VAFC  |     |
| ---------- | ----- | --- |
(32-BIT PO BUS)
•
•
| PA[15:0]  | PA[15:0]  |     |
| --------- | --------- | --- |
---
EN FEAT  -N/C
| VCLKI     | VCLK  ~  |     |
| --------- | -------- | --- |
| VCLK      | OCLK     |     |
| HSVNC     | HSVNC    |     |
| V-S-VN-C  | VS VN C  | ..  |
- - -
| -BL-AN-K   | -BL-AN-K  |     |
| ---------- | --------- | --- |
| E-VI-OE-O  | EVIOEO    |     |
l1 .s
-ES-VN-C
GROV
EVCLK  < • i
+5V
+5V
+5V
KVAFCI
Figure 10-10. VAFC Implementation (32-bit PO Bus)
'245
Trio64
VAFC
(54-BIT PD BUS)
|           | •  •      |     |
| --------- | --------- | --- |
| PA[15:0]  | PA[15:0]  |     |
ENFEAT
| VCLKI  | VCLK   |     |
| ------ | ------ | --- |
| VCLK   | DCLK   |     |
| HSYNC  | HSYNC  |     |
VSYNC
VSYNC
| BLANK   | BLANK   |     |
| ------- | ------- | --- |
| EVIDEO  | EVIDEO  |     |
| ESYNC   | GRDY    |     |
EVCLK
+5V
KVAFC2
Figure 10-11. VAFC Implementation (64-bit PO Bus)
10-8  MISCELLANEOUS FUNCTIONS

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Trio32/64
PASS-
(32-BIT PO BUS)
..  THROUGH
|     |     |     |     | •   | •   |
| --- | --- | --- | --- | --- | --- |
....
|     | PA[7:0]       |     | PA[7:0]  |     |     |
| --- | ------------- | --- | -------- | --- | --- |
|     | ENFEAT  -N/C  |     |          |     | ..  |
....
|     | VCLK   |     | VCLK       |             | ..   |
| --- | ------ | --- | ---------- | ----------- | ---- |
|     | ~      |     | ~          | ~           |      |
|     | ....   |     |            | .........   | ...  |
|     | HSVNC  |     | ..  HSVNC  |             |      |
|     | .~..   |     |            | ...         |      |
|     | VSVNC  |     |            |             | ...  |
|     |        |     | ..  VSVNC  |             | ..   |
|     | .~..   |     |            | ...         |      |
_  ...
|     | BLANK   |     | BLANK   |        |     |
| --- | ------- | --- | ------- | ------ | --- |
|     | .~..    |     |         | ...    |     |
|     | EVIDEO  |     | EVIOEO  |        |     |
|     | ...     |     |         | ...    |     |
|     | ESVNC   |     | ESVNC   |        |     |
|     | ...     |     |         | . . .  |     |
. . .
|     | EVCLK  |     | EVCLK  |     |     |
| --- | ------ | --- | ------ | --- | --- |
KPASCON1
Figure 10-12. Pass-Thru Feature Connector (32-bit PO)
| Trio64           |          |       | PASS-    |     |     |
| ---------------- | -------- | ----- | -------- | --- | --- |
| (64-BIT PO BUS)  |          | -     | THROUGH  |     |     |
|                  |          |       |          | •   | •   |
|                  | PA[7:0]  | '245  | PA[7:0]  |     |     |
~
ENFEAT
G
|     |     | -OIR  | ..  | ...  |     |
| --- | --- | ----- | --- | ---- | --- |
...
|     | VCLK  |     | .~.   VCLK  |     | ~   |
| --- | ----- | --- | ----------- | --- | --- |
...  ....
|     | HSVNC  |     | HSVNC  |       | ~   |
| --- | ------ | --- | ------ | ----- | --- |
|     | ....   |     | ...    | ....  |     |
VSVNC
|     |     |     | VSVNC  |     | ~   |
| --- | --- | --- | ------ | --- | --- |
...  ...
|     | BLANK    |     | BLANK   |      | ~   |
| --- | -------- | --- | ------- | ---- | --- |
|     | ...  §1  |     | ~       | ...  |     |
|     | EVIOEO   |     | EVIOEO  |      |     |
§;t
|     | ...    |     |        | ....  |     |
| --- | ------ | --- | ------ | ----- | --- |
|     | ESVNC  |     | ESVNC  |       |     |
|     | ...    |     |        | ~     |     |
|     | EVCLK  |     | EVCLK  |       |     |
....
|     | ,   | ,   |     | KPASCON2  |     |
| --- | --- | --- | --- | --------- | --- |
1255
Figure 10-13. Pass-Thru Feature Connector (64-bit PO)
|     |     |     | MISCELLANEOUS FUNCTIONS  |     | 10-9  |
| --- | --- | --- | ------------------------ | --- | ----- |

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
these three signals are outputs. If EVCLK is low, Similarly, VSYNC is typically deasserted (ending
VCLK is an input to the Tri032rrri064 and is used the vertical retrace) some number of scan lines
to clock the pixel data to the internal RAMOAC. If before the vertical counter resets to O. This is the
EVCLK is high, VCLK is an output. t.2 depicted in Figure 10-14. Both the horizontal
and vertical counters reset to 0 (times A and C in
Tri064 memory configurations of 2 MBytes and Figure 10-14) after VSYNC is deasserted (time B
larger will generally use the entire 64-bit PO bus. in Figure 10-14).
In these cases, EVIOEO, ESYNC, EVCLK and
PA[7:0) are multiplexed with some of the upper The total adjustment is indicated by the vector in
32 PO lines. The buffers shown in Figure 10-13 Figure 10-15. The horizontal component of this
prevent the PO lines from being driven by the vector (t.1) is programmed into bits 3-0 of CR63.
feature connector during 64-bit PO bus operation. The programmed value is the number of charac
As with the VAFC connector, the Tri064 uses a ter clocks from deassertion of HSYNC to the
32-bit PO bus during feature connector opera horizontal counter reset (both for the master).
tions. This programmed value should never exceed the
horizontal total programmed in CRO.
10.6 GENLOCKING
The vertical component of this vector (t.2) is
programmed into bits 7-0 of CR57. The pro
Genlocking allows two different video sources grammed value is the number of scan lines from
(one or both being an S3 accelerator) to contrib the deassertion of VSYNC to the vertical counter
ute to the construction of a single frame of pixel reset.
data. The VSYNC output of a master video source
is input to the slave video source to provide the Note that this adjustment does not affect any of
basis for genlocking. This process ensures that the CRT control timings other than to shift them
each screen refresh cycle (frame) begins at ex in time. In other words, the lengths of the blank
actly the same physical location on the screen. ing period, HSYNC and VSYNC pulses, etc., do
not change; their occurrences are all delayed by
The total time for each horizontal scan (screen a fixed amount.
active, blanking, retrace and front and back
porches) is called the Horizontal Total. It is pro The result ofthese adjustments is that both video
grammed in character clocks (minus 5) in the CRO sources use the same starting point as a refer
register. The internal horizontal character ence for pixel data written to the frame buffer. As
counter counts up from 0 (the first pixel on the long as both use the same VCLK frequency and
line) until it reaches the Horizontal Total. It then have the same CRT control parameters (H and V
resets to 0, signaling the start of a new line. Total, etc.), pixels contributed by either source
HSYNC is typically deasserted several character should appear in the proper places on the screen.
clocks before the horizontal counter resets to O. One additional problem is that the character
This is indicated by the t.1 gap in Figure 10-14. clocks of the master and slave will probably not
HSYNC(MASTERI~
VSYNC(MASTER)f---------r~-----------f
VGLOCK1 A c
B
Figure 10-14. Genlocking Master Sync Timing
10-10 MISCELLANEOUS FUNCTIONS

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
be exactly in phase after the horizontal and ver See the Genlocking Tech Note for several imple
tical counter reset adjustment. To rectify this, bits mentation examples, including one describing
6-4 of the CR63 register are programmed with a how to genlock to a television-style (NTSC, PAL)
value equal to the number of DCLKs (dot clocks) external source.
the character clock of the slave must be delayed
from the rising edge ofthe master's VSYNC rising
10.7 INTERRUPT GENERATION
edge to bring the character clocks in phase.
In general, genlocking programming should be For a PCI configuration, pin 152 is pulled low to
performed during the vertical sync period to signal an interrupt (lNTA). For a VL-Bus configu
avoid screen jitter. ration, pin 152 is pulled high to signal an interrupt
(SINTR).
ACTIVE SCREEN
---.
..:\1 ~
~.
VSYNC DEASSERTED (CR11)
,,:\2 ~
V TOTAL (CR6)
i
VGLOCK2
Figure 10-15. Genlocking Timing Adjustments
MISCELLANEOUS FUNCTIONS 10-11

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad
Whatever the mode of operation (VGA or En
hanced), bit 4 of CR32 must be set to 1 to enable
interrupt generation.
When the Tri032/Tri064 is being operated in VGA
mode (bit 0 of 4AE8H cleared to 0), only a vertical
retrace can generate an interrupt. This is enabled
when bit 5 of CR11 is cleared to 0 and a 1 has
been programmed into bit 4 of CR11. When an
interrupt occurs, it is cleared by writing a 0 to bit
4 of CR11. The interrupt must then be re-enabled
by writing a 1 to the same bit. Note that the BIOS
clears both bit 4 and bit 5 of CR11 to 0 during
power-on, a mode set or a reset. Thus, interrupt
generation is disabled until bit 4 is set to 1.
When the Tri032/Tri064 is being operated in En
hanced mode (bit 0 of 4AE8H set to 1), interrupts
can be generated by a vertical retrace, Graphics
Engine (GE) busy, command FIFO overflow and
FIFO empty. These are enabled via bits 8-11 re
spectively of 42E8H. The status of these inter
rupts can be read via bits 0-3 respectively of
42E8H. Writing a 1 to any of bits 0-3 of 42E8H
clears the corresponding interrupt.
Multiple interrupts can be enabled at the same
time in Enhanced mode. The interrupt pin will
remain asserted until all interrupt status bits are
cleared.
10-12 MISCELLANEOUS FUNCTIONS

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Section 11: Software Setup
This section describes the basic operations required to set up the Trio32/Trio64.
11.1  CHIPWAKEUP
The following program wakes up the Trio32/Trio64.
; Program runs as COM  file
; Program enables S3  chips
code  segment
| assume  CS:code,  | DS:code  |     |     |     |
| ----------------- | -------- | --- | --- | --- |
ORG  100h
start:
| mov dx,46E8h  | Video Subsystem Enable register address  |     |     |     |
| ------------- | ---------------------------------------- | --- | --- | --- |
= 0,
| mov al,IOh  | bit 3  | disable I/O and memory decoders          |     |     |
| ----------- | ------ | ---------------------------------------- | --- | --- |
|             | bit 4  | 1;  place video subsystem in setup mode  |     |     |
=
| out dx,al     | write new bit values to 46E8H         |     |               |     |
| ------------- | ------------------------------------- | --- | ------------- | --- |
| mov dx, 102h  | Setup Option Select register address  |     |               |     |
| mov al,Olh    | Video subsystem responds              |     | to commands,  |     |
addresses & data
| out dx,al     | Write new bit value to 102H              |                                     |     |     |
| ------------- | ---------------------------------------- | ----------------------------------- | --- | --- |
| mov dx,46E8h  | Video Subsystem Enable register address  |                                     |     |     |
| mov al,08h    | Bit 3  =                                 | 1,  enable I/O and memory decoders  |     |     |
|               | Bit 4  =                                 | 0,  return to operational mode      |     |     |
| out dx,al     | Write neW bit values to 46E8H            |                                     |     |     |
mov dx,4AE8h
| xor al,al      | Enable standard VGA                      | functions and screen size  |     |         |
| -------------- | ---------------------------------------- | -------------------------- | --- | ------- |
| out dx,al      | Write new bit values to 4AE8h            |                            |     |         |
| [load CRTCs 1  | See Section 11.4.1                       |                            |     |         |
| mov dX,3C6h    | DAC  Mask register address               |                            |     |         |
| mov al,FFh     | DAC  Mask register initialization value  |                            |     |         |
| out dx,al      | Initialize DAC                           | mask and release BLANK     |     | signal  |
mov dx,3C2h
| mov al,23h  | Enable memory,  | color base,  | page  0,  |     |
| ----------- | --------------- | ------------ | --------- | --- |
clock @ 28.322 MHz
| out dX,al  | Write new bit values to 3C2h  |     |     |     |
| ---------- | ----------------------------- | --- | --- | --- |
mov ah,4Ch
| int 21h  | return to DOS  |     |     |     |
| -------- | -------------- | --- | --- | --- |
code  ENDS
SOFTWARE SETUP 11-1

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
| END  start  |     |     |
| ----------- | --- | --- |
11.2 REGISTER ACCESS
11.2.1  Unlocking the S3 Registers
The S3 registers (CR30 and higher plus the Enhanced Commands registers) must be unlocked before
they can be accessed by the CPU. The code to do this is:
Write code to CR38  to provide access to the S3  VGA  registers  (CR30-CR3F)
| mov dX,3d4h  | copy index register address  | into dx           |
| ------------ | ---------------------------- | ----------------- |
| mov al,38h   | copy index for CR38          | register into al  |
out dx,al
write index to index register
| inc dx  | increment dx to 3D5h  | (data register address)  |
| ------- | --------------------- | ------------------------ |
mov al,48h  copy unlocking code  (OlxxlOxxb,  x=don' t  care)  to al
| out dx,al  | write the unlocking code to the data register  |     |
| ---------- | ---------------------------------------------- | --- |
| dec dx     | restore the index register address to dx       |     |
Write code to CR39  to provide access to the System Control and System Extension
registers  (CR40-CRFF)
dx  is already loaded with 3D4h because of the previous instruction
| mov al,39h  | copy index for CR39            | register into al         |
| ----------- | ------------------------------ | ------------------------ |
| out dx,al   | write index to index register  |                          |
| inc dx      | increment dx to 3D5h           | (data register address)  |
mov al,Oa5h  copy unlocking code to al  (the code a5H also unlocks
access to configuration registers CR36,  CR37  and CR68
| out dx,al  | write the unlocking code to the data register  |     |
| ---------- | ---------------------------------------------- | --- |
| dec dx     | restore the index register address to dx       |     |
Set bit 0  in CR40  to enable access to the Enhanced Commands  registers.
dx is already loaded with 3D4h because of previous  instruction
| moval,40h  | copy index for CR40            | register into al         |
| ---------- | ------------------------------ | ------------------------ |
| out dx,al  | write index to index register  |                          |
| inc dx     | increment dx to 3D5h           | (data register address)  |
in al,dx  read register data for read/modify/write operation
| or al,l    | set bit 0  to 1                                |     |
| ---------- | ---------------------------------------------- | --- |
| out dx,al  | write the unlocking code to the data register  |     |
| dec dx     | restore the index register address to dx       |     |
11-2 SOFTWARE SETUP

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
11.2.2  Locking the S3 Registers
Relocking the S3 registers is done by repeating the code used to unlock the registers except:
1.  The values written to the CR38 and CR39 registers must change at least one of the significant
bits in the valid code pattern. For example, OOh will always accomplish this.
2.  After first verifying that the Graphics Engine is not busy (bit 9 of 9AE8H is 0), bit 0 of CR40
must be cleared to O. A read-modify-write cycle must be used instead of the code used above
to prevent overwriting of any changes made to bits 7-1 in CR40 since reset.
| mov dX,3d4h  | copy index register address into dx  |                          |     |
| ------------ | ------------------------------------ | ------------------------ | --- |
| mov al,40h   | copy index for CR40                  | register into al         |     |
| out dx,al    | write index to index register        |                          |     |
| inc dx       | increment dx to 3D5h                 | (data register address)  |     |
| in al,dx     | read content of CR40                 | into al                  |     |
| and al,Ofeh  | clear bit 0                          | to 0                     |     |
out dx,al  write to CR40  to lock the Enhanced Commands  registers
| dec dx  | restore the index register address  |     | to dx  |
| ------- | ----------------------------------- | --- | ------ |
11.2.3 Unlocking/Locking Other Registers
The Extended Sequencer registers (SR9-SR18) have been added to the standard VGA sequencer
register set to provide a variety of new capabilities. To gain access to these registers, write xxxx0110b
(x = don't care) to SR8. Writing a bit pattern that changes one ofthe significant bits re-Iocks access to
the SRD register.
In addition to the standard VGA register access controls, the Tri032fTri064 provides a number of bits
extending the control of access to these registers. These are listed in Table 9-1.
Table 11-1.  VGA Register Access Control Extensions
| Register Bit  Controls Access To:  |     |     |     |
| ---------------------------------- | --- | --- | --- |
= disable write protect setting of CR11, bit 7)
| CR33, bit 1  CR7, bits 1 and 6 (1                   |     |     |     |
| --------------------------------------------------- | --- | --- | --- |
| CR33, bit4  RAMDAC register (1 = disable writes)    |     |     |     |
| CR33, bit 6  Palette/Overscan registers (1 = lock)  |     |     |     |
= lock)
| CR35, bit 4  Vertical Timing registers (1            |     |     |     |
| ---------------------------------------------------- | --- | --- | --- |
| CR35, bit 5  Horizontal Timing registers (1 = lock)  |     |     |     |
SOFTWARE SETUP  11-3

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
11.3  TESTING FOR THE PRESENCE OF A Trio32/Trio64 CHIP
After unlocking, a Trio32 or Trio64 can be identified via CR30 and CR2E. The following code aborts the
driver program and returns to DOS if a Trio32/Trio64 chip is not found.
| mov dx,3d4h  | copy index register address    |                          | into dx         |
| ------------ | ------------------------------ | ------------------------ | --------------- |
| moval,30h    | copy index for CR30            | register into al         |                 |
| out dx,al    | write index to index register  |                          |                 |
| inc dx       | increment dx to 3D5h           | (data register address)  |                 |
| in al,dx     | read content of CR30           | into al                  |                 |
| and al,OfOh  | mask out revision status       |                          | (lower nibble)  |
cmp  al,OeOh  compare chip ID  to the desired chip ID  (EOh  for
Trio32/Trio64)
jne not_EOx  jump to a  label if chip ID does not match desired ID
| mov  dx,3d4h  | copy index register address    |                          | into dx  |
| ------------- | ------------------------------ | ------------------------ | -------- |
| mov al,2eh    | copy index for CR2E            | register into al         |          |
| out dX,al     | write index to index register  |                          |          |
| inc dx        | increment dx to 3D5h           | (data register address)  |          |
| in al,dx      | read content of CR2E           | into al                  |          |
cmp  al,lOh  compare chip ID  to the desired chip ID  (lOh for
Trio32)
| je Trio32_10h  | jump  to Trio32_l0h if device ID  |     | is lOh  |
| -------------- | --------------------------------- | --- | ------- |
cmp  al,ll  compare chip ID  to the desired chip ID  (llh for
Trio64)
| je Trio64_11h  | jump to Trio64_llh if device ID  |     | is llh  |
| -------------- | -------------------------------- | --- | ------- |
jmp not_EOx  jump to not_EOx if device ID is not for Trio32 or Trio64
Trio32_l0h:
not_EOx:
| mov aX,4cOOh  | terminate with a  | return code of zero  |     |
| ------------- | ----------------- | -------------------- | --- |
| int 2lh       | return to DOS     |                      |     |
11.4 GRAPHICS MODE SETUP
The Trio32/Trio64 provides a number of standard VGA, VESA Super VGA and S3 Enhanced graphics
modes. See the S3 Video BIOS and Utilities OEM Guide for a complete listing of modes supported by
the S3 BIOS.
11.4.1  VGA Mode Setup
The Trio32/Trio64 powers up into a standard VGA mode determined by the BIOS. The mode can then
be altered by programming the standard VGA registers. All standard VGA and VESA modes are
supported.
11-4 SOFTWARE SETUP

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad
For each mode, the CRTC timing must be appropriately specified. Table 9-2 shows the required
parameters, the relevant register bits for each and the value to be programmed for each. These
parameters must also be programmed for the Enhanced modes discussed in the next section.
Table 11-2. CRTC Timing Specification Summary
Parameter Register Bits Value to be Programmed
Horizontal Total CR5D_O, CROJO Character clocks per horizontal period (HSYNC
active to next HSYNC active) -5
Horizontal Display End CR5D 1, CR1 7-0 Character clocks of active display -1
Start Horizontal Blank CR5D_2, CR2_7-O Character clock counter value at which horizontal
blanking begins
End Horizontal Blank CR5_7, CR3_4-0 Least significant six bits of the character clock
counter value at which horizontal blanking ends.
The BLANK pulse width can be extended by 64
DCLKs via bit 3 CR5D
Start Horizontal Sync CR5D_4, CR4_7-0 Character clock counter value at which HSYNC
becomes active
End Horizontal Sync CR5_4-0 Least significant five bits of the character clock
counter value at which HSYNC goes inactive. The
HSYNC pulse width can be extended by 32
DCLKs via bit 5 of CR5D
Vertical Total CR5E_0, CR7 _5, Number of scan lines from VSYNC active to next
CR7 0, CR6 7-0 VSYNC active -2
Vertical Retrace Start CR5E_4, CR7_7, Number of scan lines at which VSYNC becomes
CR7 2, CR10 7-0 active
Vertical Retrace End CR12_3-O Least significant 4 bits of the scan line counter
value at which VSYNC goes inactive
Vertical Display End CR5E_1, CR7 _6, Scan lines of active display -1
CR7 1, CR12 7-0
Offset CR51_5-4, CR13_7-0 This value multiplied by 2 (byte mode), 4 (word
model or 8 (doubleword mode) specifies the
difference between the starting byte addresses
of two consecutive scan lines
Start Vertical Blank CR5E_2, CR9_5, Number of scan lines at which vertical blanking
CR7 3,CR15 7-0 begins -1
End Vertical Blank CR16JO Least significant eight bits of the scan line
counter at which vertical blanking_ends
Line Compare CR5E_6, CR9_6, Number of scan lines at which the screen is split
CR7 4, CR18 7-0 into screen A and screen B
See standard VGA and VESA-compliant documentation for the other setup steps.
SOFTWARE SETUP 11-5

p•""f-a
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
11.4.2 S3 Enhanced Mode Setup
The Enhanced Graphics Command register group is unlocked by setting bit 0 of the System Configu
ration register (CR40) to 1. After that, bitO of4AE8H must be setto 1 to enable Enhanced mode functions.
Bit2 of4AE8H is also programmed atthis timeforthe desired mode as explained in Table 9-3. A screen
refresh rate is selected. The CRTC timing registers are programmed as explained in the previous
section. The Enhanced mode setup bits are then programmed. Table 11-4 shows register bit values for
a particular mode for the bitmap specification bits described in Table 11-3 as well as for other bits
typically used when defining a mode. Some modes may require programming of bits not mentioned
in this example.
Table 11-3. Register Bits Affecting the Bitmap Definition
Register Bits Description
CR13 Specifies the logical screen width (pitch). Bits 5-4 of CR51 are extension bits 9-8
for this value.
CR31_1 This is set to 1 to enable a 2Kx1 Kx4 map for 10 24x768 or 800x600 resolutions, or
a 2Kx512x8 map for 640x480 resolution.
CR31_3 This bit must be set to 1 to enable Enhanced mode memory mapping. This forces
o~eration in doubleword mode.
o
CR3A_4 = 4-bit modes
1 = 8/16/24/32-bit modes
o
CR42_5 = Non-interlaced operation
1 = In terlaced operation
CR50_0,7,6 Screen Width Definition
000 = 1024 (or 2048 if bit 1 of CR31 =1) (Default)
001 = 640
010 = 800 (or 1600x1200x4 if bit 2 of 4AE8H = 1)
011 = 1280
100 = 1152
101 = Reserved
110 = 1600
111 = Reserved
CR50_5-4 Pixel Color Depth Definition
00 = 1 byte. Bit 2 of 4AE8H selects between 4 (=0) and 8 (=1) bits/pixel.
01 = 2 bytes (16 bits/pixel)
10 = Reserved
11 = 4 bytes (32 bits/pixel). True color (24 bits/pixel) is handled by this setting,
with the upper byte unused.
4AE8H_2 If bits 0,7,6 of CR50 are 01 Ob, this bit is set to 1 for 1600x1200x4 mode.
If bits 5,4 of CR50 are OOb, this bit is set to 1 for 4 bits/pixel modes.
11-6 SOFTWARE SETUP

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Table 11·4. Enhanced Mode Setup for 1024x768x8 Resolution at 75 Hz Refresh
Register Value (Hex) Description
CR31 09 Enables use of a CPU base address offset. Enables use of
Enhanced mode memory mappings.
CR34 10 Enables CR3B (display FIFO fetch start position).
CR3A 15 Enables RAM refresh count specification and specifies 1
RAM refresh cycle per horizontal line. Configures attribute
controller shift reqisters for 8 bits/pixel.
CR3B 9C Specifies the time from the start of display active until the
start of fetching data into the display FIFO for the next line.
This is typically 5 less than the value programmed in CRO
but may vary for some modes.
CR3C 00 Not used for this non·interlaced mode.
CR40 See Description Bit 0 must be set to 1 early in the setup process to enable
Enhanced mode register access. Bit 5 selects 0 or 1 wait
state. This bit defaults to 1 wait state, which will almost
always be required for proper operation of the Trio32/Trio64
in a VL·Bus configuration. Consequently, the S3 BIOS
protects this bit from being overwritten during the normal
setup process.
CR50 00 Bits 0,7,6 specify the screen width of 1024 pixels. Bits 5,4
specify a pixel length of 8 bits/pixel.
CR51 00 Bits 5,4 are extension bits for CR13. These are not required
for this mode.
CR54 70 M parameter value. This (plus 1) specifies how many 8·byte
memory accesses are available before display FIFO filling
starts again.
CR5C See Description The General Output Port is not used during the setup of this
mode unless the clock generator requires serial input for
DCLK selection or frequency programming.
CR5D 00 No horizontal overflow bits are required for this mode.
CR5E 00 No vertical overflow bits are required for this mode.
CR60 FF N parameter value. This (plus 1) specifies the number of 4·
byte (1 MByte of memory) or 8·byte (2 or 4 MBytes of
memory) units to transfer to the display FIFO before
allowing memory access for another purpose. This value
(255 decimal) ensures that the FIFO will always be filled
before the memory is released.
CR67 00 Bits 7-4 specify the RAMDAC color mode. This value
selects 8 bits/pixel.
SOFTWARE SETUP 11·7

. •=.,
•
~ .
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
11.4.3 Hardware Graphics Cursor Setup
Use of the 64x64 bits hardware graphics cursor is enabled by setting bit 0 of the Hardware Graphics
Cursor Mode register (CR45) to 1. The hardware cursor only works in Enhanced mode (bit 1 of 4AE8H
= 1). See the Programmable Hardware Cursor section of the Enhanced Mode Programming section for
more information.
11-8 SOFTWARE SETUP

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Section 12: VGA Compatibility Support
This section describes the Tri032rrri064's support for standard VGA and VESA Super VGA graphics
standards.
12.1 VGA COMPATIBILITY
The Tri032rrri064 is compatible with the VGA standard. These modes are not accelerated using the
Graphics Engine. However, other design features including a multi-modal FIFO provide excellent VGA
performance.
Several ofthe standard VGA registers have been modified or extended in the Tri032rrri064. Table 10-1
describes these changes.
Table 12-1. Standard VGA Registers Modified or Extended in the Tri032/Tri064
Register Change to Standard VGA Definition
3C4H The sequencer address has been extended from 3 to 4 bits to support the new
SR8 -SR18 registers.
SR8 This new register unlocks/locks access to the new SR9 -SR 18 registers.
SR9 -SR18 These new registers provide a variety of capabilities.
CRO Extension bit 8 is bit 0 of CR5D. Bit 5 of CR35 controls access to this register. Bit
7 of CR43 doubles the parameter size.
CR1 Extension bit 8 is bit 1 of CR5D. Bit 5 of CR35 controls access to this register. Bit
7 of CR43 doubles the parameter size.
CR2 Extension bit 8 is bit 2 of CR5D. Bit 5 of CR35 controls access to this register. Bit
7 of CR43 doubles the parameter size.
CR3 The length of the blanking pulse defined in this register can be extended by 64
DCLKs via bit 3 of CR5D. Bit 5 of CR35 controls access to this register. Bit 7 of
CR43 doubles the parameter size.
CR4 Extension bit 8 is bit 4 of CR5D. Bit 5 of CR35 controls access to this register. Bit
7 of CR43 doubles the parameter size.
CR5 The length of the HSYNC pulse defined in this register can be extended by 32
DCLKs via bit 5 of CR5D. Bit 5 of CR35 controls access to this register. Bit 7 of
CR43 doubles the parameter size.
CR6 In addition to the standard VGA extensions (bit 8 is bit 0 of CR7, bit 9 is bit 5 of
CR47), bit 10 is bit 0 of CR5E. Bit 4 of CR35 controls access to this register.
CR7 Bit 4 of CR35 controls access to bits 0, 2, 3, 5 and 7 of this register.
VGA COMPATIBILITY SUPPORT 12-1

fl·
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
CR9 Bit 4 of CR35 controls access to bit 5 of this register.
CRC The display start address is a 20-bit value for the Trio32ffrio64. The extension bits
(20-16) are bits 4-0 of CR69.
CRE The cursor location address is a 20-bit value for the Trio32ffrio64. The extension
bits (20-16) are bits 4-0 of CR69.
CR10 In addition to the standard VGA extensions (bit 8 is bit 2 of CR7, bit 9 is bit 7 of
CR7), bit 10 is bit 4 of CR5E. Bit 4 of CR35 controls access to this r~ister.
CR11 Bit 4 of CR35 controls access to bits 3-0 of this register. Bit 6 (3/5 refresh cycles
per line) can be overridden by CR3A_2-0. Setting bit 1 of CR33 to 1 disables the
write protect effect of bit 7 of this register on bits 1 and 6 of CR7.
CR12 In addition to the standard VGA extensions (bit 8 is bit 1 of CR7, bit 9 is bit 6 of
CR7), bit 10 is bit 1 of CR5E.
CR13 Bit 2 of CR43 is the old extension bit (bit 8) of this register. Bits 5-4 of CR51 are
the new extension bits (bits 9-8) of this register.
CR15 In addition to the standard VGA extensions (bit 8 is bit 3 of CR7, bit 9 is bit 5 of
CR9), bit 10 is bit 2 of CR5E. Bit 4 of CR35 controls access to this register.
CR16 Bit 4 of CR35 controls access to this register.
CR17 Bit 5 of CR35 controls access to bit 2 of this register.
CR18 In addition to the standard VGA extensions (bit 8 is bit 4 of CR7, bit 9 is bit 6 of
CR9), bit 10 is bit 6 of CR5E.
AROO-AROF Bit 6 of CR33 controls access to these registers.
46E8H If bit 2 of CR65 is set to 1, the setup address is 3C3H instead of this address.
3C6H-3C9H Bit 4 of CR33 controls writes to these registers.
For a detailed discussion ofVGA programming, see Programmer's Guide to the EGA. VGA and Super
VGA Cards, 3rd Edition by Richard F. Ferraro (Addison-Wesley Publishing Company, Inc).
12.2 VESA SUPER VGA SUPPORT
The Trio32ffrio64 supports the extended (Super) VGA modes defined by VESA. All modes are
accelerated by the Trio32/Trio64's Graphics Engine except for the planar (4 bits/pixel) ones.
12-2 VGA COMPATIBILITY SUPPORT

I~
II
S3 Trio32/Trio64 Integrated Graphics Accelerators
I'
I
,~
53 Incorporated i
Section 13: Enhanced Mode Programming
Enhanced mode provides a level of performance far beyond what is possible with the VGA architecture.
Hardware line drawing, BitBL T, rectangle fill and other drawing functions are implemented. Also
implemented are data manipulation functions, such as data extension, data source selection, and
read/write bitplane control. Hardware clipping is supported by 4 registers that define a rectangular
clipping area. While in Enhanced mode, the display memory bit map can be updated in two ways. One
is to have the CPU write directly to memory. (This is also possible in non-Enhanced modes via paging.)
The other is to have the CPU issue commands to the Graphics Engine, which then controls pixel
updating. This section explains these two methods and provides a comprehensive set of Enhanced
mode programming examples.
13.1 DIRECT BITMAP ACCESSING-LINEAR ADDRESSING
Linear addressing is useful when software requires direct access to display memory. In general, large
image transfers to display memory can be performed faster using the Graphics Engine and memory
mapped I/O transfers.
Enhanced mode operation must be enabled before linear addressing is enabled. This means that bit
o of 4AE8H is set to 1 to enable Enhanced mode functions and bit 3 of CR31 is set to 1 to specify
Enhanced mode memory mapping.
The Tri032 provides linear addressing of up to 2 MBytes of display memory. The Tri064 provides linear
addressing of up to 4 MBytes of display memory. Linear addressing of more than 64 KBytes requires
that the CPU be operated in 386 protected mode.
The Graphics Engine busy flag, bit 9 of 9AE8H, should be verified to be 0 (not busy) before linear
addressing is enabled by setting bit 4 of CR58 or bit 4 of 4AE8H to 1. The size of the linear address
window is set via bits 1-0 of CR58. The base address for the linear addressing window is set via CR59
and CR5A (or via the Base Address 0 (Index 10H) PCI configuration register for PCI systems}.
The linear addressing window size can be set to 64 KBytes. The base address for the window is set by
programming bits 31-16 of the window position in CR59-CR5A. This allows the CPU to be operated in
real mode. If bit 0 of CR31 is set to 1, the memory page offset (64K bank) specified in bits 5-0 of CR6A
is added to the linear addressing window position base address, allowing access to up to 2 (Tri032) or
4 (Tri064) MBytes of display memory through a 64-KByte window.
ENHANCED MODE PROGRAMMING 13-1

,.-
,IJIj
•
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
13.2 BITMAP ACCESS THROUGH THE GRAPHICS ENGINE
When updating the display bitmap through the Graphics Engine, all CPU data moves through the Pixel
Data Transfer registers (E2E8H and E2EAH). These can be memory mapped as explained in Memory
Mapping of Enhanced Mode Registers later in this section.
The Graphics Engine manipulates the bits for each pixel to assign a color index or true color value,
which is then translated via a programmable RAMDAC before being displayed on a CRT. Selected bits
in a pixel can be masked off from being displayed by programming the DAC Mask register (3C6H). The
Tri064 can manipulate 64 bits each clock cycle, from two 32-bit pixels to eight 8-bit pixels. The Tri032
can manipulate 32 bits each clock cycle.
Figure 13-1 is a flowchart for the process of updating the color of each pixel. Start at the block labeled
'New Color' in the middle of Figure 13-1. At this stage, a color has been determined that mayor may
not be used to update a pixel in the bitmap. How this color is determined will be covered later.
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
The new color is the result of a logical mix performed on a color source and the current color in the
bitmap. For example, the color source could be XORed with the bitmap color. The new color can also
be selected by operating on only the color source or the bitmap color, e.g., NOT color source. Both the
color source and the logical mix operation are specified in either the Background Mix register (B6E8H)
or the Foreground Mix register (BAE8H). Which of these two registers is used is determined by the
settings of bits [7:61 of the Pixel Control register (BEE8H, Index OAH).
To set up the pixel color updating scheme, the programmer specifies one of four color sources by
writing bits 6-5 of the Background Mix and Foreground Mix registers. The color sources are:
• Background Color register (A2E8H)
• Foreground Color register (A6E8H)
• CPU (via the Pixel Data Transfer registers (E2E8H, E2EAH))
• Current display bitmap color index
One of 16 logical operations is chosen by writing bits 3-0 of the Background Mix and Foreground Mix
registers. Examples of logical operations are making the new pixel color index equal to the NOT of the
current bitmap color index or making the new index equal to the XOR ofthe source and current bitmap
indices.
13-2 ENHANCED MODE PROGRAMMING

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
COLOR SOURCE A  COLOR SOURCE B
NO
=
| SRC NE  | 0   | SRC NE = 1  |
| ------- | --- | ----------- |
=
| COLOR COMP  | TRUE  | COLOR COMP = TRUE  |
| ----------- | ----- | ------------------ |
| SRCNE = 1   |       | SRCNE  = 0         |
=
| COLOR COMP  | F ALSE  | COLOR COMP = FALSE  |
| ----------- | ------- | ------------------- |
COLOR
COMPARE
NEW PIXEL COLOR  PlXUPDT
Figure 13·1. Pixel Update Flowchart
ENHANCED MODE PROGRAMMING  13-3

,..
..fa
•
S3 Tri032/Tri064 Integrated Graphics Accelerators
53 Incorporated
When the logical operation and color source have been specified in the Background and Foreground
Mix registers, bits 7-6 of the Pixel Control register are written to specify the source of the mask bit
value. If the resulting mask bit is a :ONE', the Foreground Mix register is used to determine the color
source and mix. If the mask bit is a 'ZERO', the Background Mix register is used to determine the color
source and mix. There are three sources for the mask bit value:
• Always ONE (Foreground Mix register used)
• CPU (via the Pixel Data Transfer registers (E2E8H, E2EAH))
• Bitmap
Setting bits 7-6 to OOb sets the mask bit to 'ONE'. All drawing updates to the video bitmap use the
Foreground Mix register settings. This setup is used to draw solid lines, through-the-plane image
transfers to display memory and BitBL Ts.
If bits 7-6 are set to 10b, the mask bit source is the CPU. After the draw operation command is issued
to the Drawing Command register (9AE8), a mask bit corresponding to every pixel drawn on the display
must be provided via the Pixel Data Transfer register(s}. If the mask bit is 'ONE', the Foreground Mix
register is used. If the mask bit is 'ZERO', the Background Mix register is used. Note that if the color
source is the CPU, the mask bit source cannot also be the CPU, and vice versa. This setup is used to
transfer monochrome images such as fonts and icons to the screen.
If bits 7-6 are set to 11 b, the current display bit map is selected as the mask bit source. The Read Mask
register (AAE8H) is set up to indicate the active planes. When all bits of the read-enabled planes for a
pixel are a 1, the mask bit 'ONE' is generated. If anyone of the read-enabled planes is a 0, then a mask
bit 'ZERO' is generated. If the mask bit is 'ONE', the Foreground Mix register is used. If the mask bit is
'ZERO', the Background Mix register is used. Note that if the color source is the bitmap, the mask bit
source cannot also be the bitmap, and vice versa. This setting is used to BitBLT patterns and character
images.
13.3 MEMORY MAPPING OF ENHANCED MODE REGISTERS
The Tri032fTri064 provides two memory-mapped I/O schemes. The standard method provides each
memory-mapped register with a single memory address. Most of the Enhanced registers are provided
such an address. The packed register method allows two 16-bit registers to be accessed by a single
32-bit write cycle. In addition, more registers can be accessed via the packed method than by the
standard method. The packed register method provides improved performance. The standard method
provides backwards compatibility with older software.
13.3.1 Standard Memory Mapping of Enhanced Mode Registers
Most of the Enhanced registers can be memory-mapped (MMIO). This function is enabled by setting
bit 4 of CR53 or bit 5 of 4AE8H to 1.
Image writes normally made via I/O addresses E2E8H and E2EAH (the Pixel Data Transfer registers)
are made instead by accessing any memory location in the 32-KByte address space from AOOOOH to
A7FFFH. This allows efficient use ofthe MOVSW and MOVSD assembly language commands. Accesses
must be to even word or doubleword addresses, depending on the specification of the bus width via
bits 10-9 of 98E8H. Software must not make E2E8H, E2EAH writes beyond the A7FFFH range.
13-4 ENHANCED MODE PROGRAMMING

53 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Accesses to the Enhanced command registers are made to particular locations in the A8000H to AFFFFH
address range as shown in Table 13-1. Both 16-bit reads and writes are supported. Only 32-bit writes
(bit 9 of BEE8H_E set to 1) are supported.
If MMIO is enabled, bit 7 of SR9 allows register access to be either I/O or MMIO or MMIO only.
Table 13-1  Enhanced Registers Memory Mapping
| Register Mnemonic         | I/O Address (Hex)  | Register    | PackedMMIO     |
| ------------------------- | ------------------ | ----------- | -------------- |
|                           | MMIO=Axxxx         | Mnemonic    | Address (Hex)  |
|                           |                    | (Packed)    | (Axxxx)        |
| CUR Y, CUR X              |                    |             | 8100,8102      |
|                           | 82E8,86E8          | ALT CURXY   |                |
| CUR Y2*. CUR X2*          | 82EA. 86EA         | ALT CURXY2  | 8104,8106      |
| DESTY AXSTP,DESTX DIASTP  | 8AE8,8EE8          | ALT STEP    | 8108. 810A     |
| Y2 AXSTP2*,X2 DIASTP2*    | 8AEA. 8EEA         | ALT STEP2   | 810C, 810E     |
| ERR TERM, ERR TERM2*      | 92E8,92EA          | ALT ERR     | 8110.8112      |
| CMD, CMD2*                | 9AE8,9AEA          | ALT CMD     | 8118.811A      |
| SHORT STROKE              | 9EE8               |             | 811C           |
| BKGD COLOR                | A2E8               |             | 8120           |
| FRGD COLOR                | A6E8               |             | 8124           |
| WRT MASK                  | ME8                |             | 8128           |
| RD  MASK                  | AEE8               |             | 812C           |
| COLOR CMP                 | B2E8               |             | 8130           |
| BKGD MIX. FRGD MIX        | B6E8. BAE8         | ALT MIX     | 8134.8136      |
| SCISSORS T. SCISSORS R    | BEE8 1. BEE8 2     |             | 8138,813A      |
| SCISSORS B, SCISSORS R    | BEE8 3. BEE8 4     |             | 813C, 813E     |
| PIX CNTL. MULT MISC2*     | BEE8 A. BEE8 D     |             | 8140,8142      |
| MULT  MISC, READ SEL      | BEE8 E. BEE8 F     |             | 8144           |
MIN AXIS PCNT. MAJ AXIS PC NT  BEE8 0.96E8  ALT peNT  8148, 814A
| MAJ AXIS PCNT2*  | 96EA        |            | 814C        |
| ---------------- | ----------- | ---------- | ----------- |
| PIX TRANS        | E2E8. E2EA  | PIX-TRANS  |             |
| PAT Y*, PAT X*   | EAE8.EAEA   | ALT PAT    | 8168. 816A  |
* These registers are available only for the Tri064.
13.3.2 Packed MMIO Register Mapping
For improved performance, most of the Enhanced mode registers can also be written (but not read)
via a packed configuration. The 16-bit registers are paired so that two registers can be accessed via a
single 32-bit write. The addresses for this packed configuration are given in Table 13-1. The packed
register access function is enabled when MMIO is enabled.
ENHANCED MODE PROGRAMMING  13-5

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
13.4 PROGRAMMING
Three different programming schemes are available, I/O, standard MMIO and packed register MMIO.
Examples of how each is used to assign vertical and horizontal coordinates to Current X and Y Position
registers (B2EBH and B6EBH) are:
I/O Format:
MOV DX,CUR_X
MOV AX,X
OUT DX,AX
MOV DX,CUR_V
MOV AX,V
OUT DX,AX
Standard MMIO Format:
Enable MMIO
Point ES to AOOOH
Load x and y values into AX and ax
MOV ES:[CUR_V ]. ax
MOV ES:[CUR_XJ, AX
Packed Register MMIO:
Enable MMIO
Point ES to AOOOH
Load the x and y values into EAX (y value in the low word and x value in the high word), I.e.,
31 15 0
J
EAX<=I X V
MOV ES:[ALT _CURXVJ, EAX
The packed register MMIO scheme is the most efficient and is used where appropriate in the
programming examples provided later in this section. All assume that the ES register points to AOOOH.
13.4.1 Notational Conventions
The REGMNEMONIC on the left hand side of the arrow is the register mnemonic of the I/O port being
written into. Text following a ';' is a comment.
REGMNEMONIC <= XXXXH ; Load a hexadecimal value into the register.
REGMNEMONIC <= XXXXD ; Load a decimal value into the register.
REGMNEMONIC <= XXXX ; Load a decimal value into the register
REGMNEMONIC <= XXXXXXXXXXXXXXXXB ; Load a binary value into the register.
Image transfers (CPU pixel data writes to the frame buffer) are notated as follows:
COUNT
PIX_TRANS <= IMAGEDATA
13-6 ENHANCED MODE PROGRAMMING

fl·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
The COUNT is the number of CPU writes. PIX_TRANS means either the E2E8H, E2EAH pixel transfer
registers or the 32K memory space from AOOOOH to A7FFFH as explained in Section 13.3.1 above.
13.4.2 Initial Setup
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
13.4.3 Programming Examples
This section provides programming examples for the following Enhanced mode drawing operations:
• Solid Line
• Textured Line
• Rectangle Fill Solid
• Image Transfer-Through the Plane
• Image Transfer-Across the Plane
• BitBLT - Through the Plane
• BitBLT-Across the Plane
• PatBLT-Through the Plane
• PatBLT - Across the Plane
• Short Stroke Vectors
• Polyline (Tri064 only)
• Polygon Fill Solid -(Tri064 only)
• Polygon Fill Pattern -(Tri064 only)
• 4-Point Method Trapezoid Fill Solid -(Tri064 only)
• 4-Point Method Trapezoid Fill Pattern -(Tri064 only)
• Bresenham Parameter Trapezoid Fill Solid-(Tri064 only)
• Bresenham Parameter Trapezoid Fill Pattern-(Tri064 only)
• Programmable Hardware Cursor
ENHANCED MODE PROGRAMMING 13-7

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Some programming steps are repeated in multiple examples. They are explained in detail at their first
occurrence. Therefore, readers are encouraged to work through the examples from first to last. The
register mnemonics used in the examples are listed in Table 13-1. Other mnemonics used are:
Mnemonic Description
NEW Mix = 00111 b in bits 4-0 of BAE8H or B6E8H. This overwrites the present
bitmap color value with a new value.
XOR Mix = 00101 b in bits 4-0 of BAE8H or B6E8H. The current bitmap color is
XORed with the new color.
13-8 ENHANCED MODE PROGRAMMING

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
13.3.3.1 Solid Line
This command draws a one pixel wide solid line from screen coordinates xl.yl to x2.y2. Bresenham
parameters are used to define the line. The Pixel Control register (BEE8H, Index AH) must be set to
AOOOH to select the Foreground Mix register to specify the color source and mix type.
Setup:
Drawing a line using axial coordinates requires programming the axial step constant into the Destina
tion Y-Position/Axial Step Constant (8AE8H) register (DESTY _AXSTP), the diagonal step constant into
the Destination X-Position/Diagonal Step Constant (8EE8H) register (DESTX_DIASTP) and the error
term into the Error Term (92E8H) register (ERR_TERM). Calculation of these Bresenham parameters is
based on the MAX and MIN parameters as calculated below.
MAX = maximum(ABS(x2-xll. ABS(y2-yl))
MIN = minimum(ABS(x2-xl), ABS(y2-yl))
where maximum means choose the largest of the two terms in parentheses and minimum means
choose the smallest. ABS means take the absolute value of the expression.
Bits 7-5 of the Drawing Command (9AE8H) register (CMD) specify the drawing direction. Setting bit 7
to 1 means that the Y drawing direction is positive (yl < y2). Clearing bit 7 to 0 means the Y drawing
direction is negative (yl > y2). Setting bit 6 to 1 means that Y is the major (longer) axis (ABS(x2-xl) >
ABS(y2-yl)). Clearing bit 6 to 0 means that X is the major axis. Setting bit 5 to 1 means that the X
drawing direction is positive (xl < x2). Clearing bit 5 to 0 means thatthe X drawing direction is negative
(xl > x2). These values replace the DDD sequence in the write to the CMD register shown in the
pseudocode below.
The mix NEW represents a setting of 0111b in bits 3-0 of the Foreground Mix (BAE8H) register
(FRGD_MIX). This overwrites the present bitmap color value with a new value.
The remainder of the setup is:
ES:[FRGD_MIX] <= 0027H ; color source is FRGD_COLOR, mix type is NEW
ES:FRGD_COLOR] <= 00000002H ; color index
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX provides color source and mix type
Drawing Operation:
31 15 0
ES:[ALT _CURXY] <= LI __X _l_-'--_--'y_l_---'I ; set starting coordinate
ES:[MAJ_AXIS_PCNT] <= MAX -1 ; length in pixels of the major axis -1
31 15 o
I ;
ES:[ALT _STEP] <= 12*(MIN-MAX)1 2*MIN diagonal and axial step constants
If the X drawing direction is positive then
ES:[ERR_T ERM] <= 2 * MIN - MAX ; error term
else if the X drawing direction is negative
ES[ERR_T ERM] <= 2 * MIN - MAX - 1 ; error term
ES:[CMD] <= 00100000DDD10001b ; Draw line command (bits 15-13, 11), draw (as opposed to
; just move current position)(bit 4), bit 0 is always 1
ENHANCED MODE PROGRAMMING 13-9

S3 Trio32/Trio64 Integra~ed Graphics Accelerators
53 Incorporated
13.3.3.2 Textured Line
The line draw command can be used to draw a one pixel wide textured line from screen coordinates
x1,y1 to x2,y2. The texture is created by (1) setting bits 7-6 ofthe Pixel Control register (BEE8H, Index
AH) to A080H to specify the CPU as the source ofthe mask bit selecting the mix register, (2) specifying
a background and foreground color, (3) setting bit 8 of the Command register (9AE8H) to 1 (wait for
CPU data) and (4) setting bit 1 of the Command register to 1 (multi-pixel). When the pattern bit sent by
the CPU is a 1, the Foreground Mix register specifies the the color source and mix. When the bit is a
0, the Background Mix register specifies the color source and mix. This example uses the mix NEW for
the foreground mix, XOR for the background mix, foreground color index 2 and background color index
4. The 32-bit line texture/pattern (PATTERN) is 00110000111100110011000011110011b. This requires
that bits 10-9 of the Command register be set to 10b to specify a 32-bit bus.
Setup:
The XOR mix corresponds to a setting of 0101b in bits 3-0 of the Background Mix (B6EBH) register
(BKGD_MIX). See the Solid Line example for an explanation of other parameters and registers used in
this example.
31 15 0
ES:[AL T_ MIX] <= _0_0_27_H_'-----0_0_05_H---l1 ; FRGD_COLOR is color source and NEW is mix,
LI
; BKGD_COLOR is color source and XOR is mix
ES:[FRGD_COLOR] <= 00000002H ; color index
ES:[BKGD_COLOR] <= 00000004H ; color index
ES:[PIXEL_CNTL] <= A080H ; mask data selecting mix register is provided by the CPU
Drawing Operation:
31 15 0
ES:[AL T_ CURXY] <=1 X_1_-,-_-,y_1_-,1 ; set starting coordinates
L __
ES:[MAJ_AXIS_PCNT <= MAX -1 ; length in pixels of the major axis -1
31 15 o I ;
ES:[ALT_STEP] <=12*(MIN-MAXL 2*MIN diagonal and axial step constants
If the X drawing direction is positive then
ES:[ERR_T ERM] <= 2 * MIN - MAX ; error term
else if the X drawing direction is negative
ES[ERR_T ERM] <= 2 * MIN - MAX - 1 ; error term
ES:[CMD] <= 00100101DDD10011b ; Draw line (bits 15-13, 11), 32-bit bus (bits 10-9), waitfor data
; from the CPU (bit B), draw (bit 4), mUlti-pixel (bit 1)
COUNT (of PATTERN dwords) = (MAX + 31)/32 (See Note)
PIX_TRANS <= 00110000111100110011000011110011b ; Output PATTERN to Pixel Data Transfer
; registers COUNT times
Note
The COUNT of the number of writes required by the CPU is a function of the number of bits to be
transferred and the width of the transfer (B, 16 or 32 bits as specified by bits 10-9 of the Drawing
Command register (9AEBH». The number of bits transferred per line must be an even multiple of the
transfer width. If this is not the case, the last write per line must be padded with one or more dummy
13-10 ENHANCED MODE PROGRAMMING

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
bits to meet this requirement. For example, if the transfer width is 8 bits and nine bits are to be
transferred for the line, two bytes must be written per line, with the upper 7 bits of the second byte
padded. In general, the number of padding bits per line will vary from 0 to (n-1), where n is the transfer
width in bits.
With a transfer width of 8 bits, the number of byte writes required per line can be determined from
the formula n = (MAX+7)/8, with n being truncated to an integer if the result contains a fraction.
Thus a MAX = 11 transfer requires (11+7)/8 = 2 1/4 = 2 bytes. The formulas for all transfer widths are
given below.
8-bit transfers: COUNT = (MAX+7)/8 bytes
16-bit transfers: COUNT = (MAX+15)/16 words
32-bit transfers: COUNT = (MAX+31)/32 dwords
ENHANCED MODE PROGRAMMING 13-11

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
13.3.3.3 Rectangle Fill Solid
This command draws a solid rectangle with its top left corner at x1.y1, height = HEIGHT and width =
WIDTH. The Pixel Control register (BEE8H, Index AH) must be set to AOOOH to select the Foreground
Mix register to specify the color source and mix type. This example uses the mix NEW and color index
2. The drawing direction (bits 7-5 in the write to the CMD register below) is set to X positive, X major
and Y positive (101b).
Setup:
ES:[FRGD_MIXI ¢= 0027H  ; color source is FRGD_COLOR, NEW mix type
| ES:[FRGD_COLORI ¢= 00000002H  |     | ; color index  |     |
| ----------------------------- | --- | -------------- | --- |
ES:[PIXEL_CNTL] ¢= AOOOH  ; FRGD_MIX specifies the color source and mix type
Drawing Operation:
|     | 31  15  | 0   |     |
| --- | ------- | --- | --- |
_-,J  ;
ES:[ALT  _CURXYI ¢= LI_  x _1_---'-_-'-y_1  set starting coordinates
_
|                    | 31  15                | 0                  |     |
| ------------------ | --------------------- | ------------------ | --- |
| ES:[ALT_PCNT] ¢=I  | WIDTH-1  1 HEIGHT-11  | ; rectangle width  |     |
ES:[CMD] ¢= 0100000010110001b  ; Draw rectangle (bits 15-13, 11), draw (bit 4)
Note
The rectangle can be defined by specifying anyone ofthe four corners and setting bits 7-5 accordingly.
Always select X as the major axis (bit 6 =0). No matter how the rectangle is defined, it always fills from
left to right and top to bottom.
|     | Corner        | X direction (bit 5)  | V direction (bit 7)  |
| --- | ------------- | -------------------- | -------------------- |
|     | top left      | positive (1)         | positive (1)         |
|     | top right     | negative (0)         | positive (1)         |
|     | bottom left   | positive (1)         | ne~ative (0)         |
|     | bottom right  | negative (0)         | negative (0)         |
13-12 ENHANCED MODE PROGRAMMING

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad
13.3.3.4 Image Transfer-Through the Plane
This command transfers a rectangular image from the CPU to the display memory through the plane.
"through the plane" means the complete color index is transferred for each pixel, e.g., in 8 bits/pixel
mode, one byte is required to transfer one pixel to memory. The image is stored as an array of pixels
arranged in row major fashion (consecutively increasing memory addresses). The Pixel Control register
must be set to AOOOH to select the Foreground Mix register to specify the color source and mix type.
The color source must be specified as the CPU. Bit 12 of the Command register must be setto 1 (swap
ON) for Intel-type architectures. Bit 8 of the Command register must be set to 1 (wait for CPU data) and
bits 6 and 5 must also be set to 1 to specify X as the major axis and a left-to-right drawing direction.
This example uses a mix type of NEW and x1.y1 is the top left corner of the rectangle on the screen.
The height and width of the rectangle (in pixels) are HEIGHT and WIDTH. Doublword CPU writes are
supported by setting bits 10-9 of the Command register to 10b.
Setup:
ES:[FRGD_MIX] <= 0047H ; color source is the CPU, mix type is NEW
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX is the source for color source and mix type
Drawing Operation:
31 15 0
ES:[ALT _CURXY] <= 1L-_x_1_--'-__y .:....1_---'l ; set destination starting coordinates
31 15 0
I I
ES:[ALT_PCNT] <= WIDTH-1 HEIGHT-1 l ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
ES:[CMD] <= 01010101D0110001b ; Draw rectangle (bits 15-13, 11), swap ON (bit 12),
; 32-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4)
COUNT (of image pixel data to transfer) = (See Note)
PIX_TRANS <= I MAGE DATA; Output image data to the Pixel Data Transfer registers for COUNT dwords.
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
of the variables affecting the COUNT. The formulas for all cases are given below, where W is the width
of the image and H is the height of the image, both in pixels.
ENHANCED MODE PROGRAMMING 13-13

S3 Trio32/Trio64 Integrated Graphics Accelerators
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
13-14 ENHANCED MODE PROGRAMMING

S3 Trio32ITrio64 Integrated Graphics Accelerators
53 Incorporatad
13.3.3.5 Image Transfer-Across the Plane
The image transfer command can also be used to transfer a rectangular image from the CPU to the
display memory across the plane. "across the plane" means that each bit sent by the CPU is stored in
display memory as a single pixel. These pixels are arranged in row major fashion (consecutively
increasing memory addresses). An "across the plane" transfer is created by (1) setting bits 7-6 of the
Pixel Control register (BEE8H, Index AH) to A080H to specify the CPU as the source of the mask bit
selecting the mix register, (2) specifying a background and foreground color, (3) setting bit 8 of the
Command register (9AE8H) to 1 (wait for CPU data) and (4) setting bit 1 of the Command register to 1
(multi-pixel). When the pattern bit sent by the CPU is a 1, the Foreground Mix register specifies the the
color source and mix. When the bit is a 0, the Background Mix register specifies the color source and
mix. This example uses a mix type of NEW, and x1.y1 is the top left corner of the rectangle on the
screen. The height and width of the rectangle (in pixels) are HEIGHT and WIDTH. The monochrome
image is translated so that pixels corresponding to a 1 in the bit image are given color index 4 and
pixels corresponding to a 0 in the bit image are given color index O. This example uses word transfers
from the CPU as specified by setting bits 10-9 of the Command register to 01b for a 16-bit bus width.
Setup:
31 15 0
ES:[ALT _MIX] <= _0_0_27_H_l......-o_0_05_H----'1 ; FRGD_COLOR color source and mix is NEW
,--I
; BKGD_COLOR is color source and mix is XOR
ES:[FRGD_COLOR] <= 00000004H ; foreground color index 4
ES:[BKGD_COLOR] <= OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTL] <= A080H ; selection of mix register is based on data from the CPU
Drawing Operation:
31 15 0
ES:[ALT _ CURXY] <= x_1_--,_-,-y_1_-,1 ; set destination starting coordinates
,-I_ _
31 15 0
I J
ES:[ALT_PCNT] <= 1 WIDTH-1 HEIGHT-1 ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
CMD <= 01010011D0110011b ; Draw rectangle (bits 15-13, 11), swap ON (bit 12).
; 16-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4),
; multi-pixel (bit 1)
COUNT (of image pixel data to transfer) = ((WIDTH +15)/16)*HEIGHTwords
PIX_TRANS <= IMAGEDATA; Output image data to Pixel Transfer register for COUNT words
Notes
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred and the width ofthe transfer (8, 16 or 32 bits as specified by bits 10-9 of 9AE8H). Except for
the case where bits 10-9 of 9AE8H are 11b, the number of pixels transferred per line must be an even
multiple of the transfer width. If this is not the case, the last write per line must be padded with one or
more dummy pixels to meet this requirement. For example, if the transfer width is 8 bits and nine
pixels are to be transferred per line, two bytes must be written per line, with the upper 7 bits of the
second byte padded. In general, the number of padding bits per line will vary from 0 to (n-1), where n
is the transfer width in bits.
ENHANCED MODE PROGRAMMING 13-15

..fa
•
..a S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
With a transfer width of B bits, the number of byte writes required per line can be determined from the
formula n = (W+7)/B, with n being truncated to an integer ifthe result contains a fraction. Thus a 13-bit
pixel transfer requires (13+7)/B = 2.5 = 2 bytes. This is then multiplied by the height of the image (in
pixels) to determine the COUNT of bytes to be transferred. Similar procedures apply to every other
combination of the variables affecting the COUNT. The formulas for all cases are given below, where
W is the width of the image and H is the height of the image, both in pixels.
B-bit transfers: COUNT = (W+7)/B * H bytes (9AEBH_10-9 = OOb)
16-bit transfers: COUNT = (W+15)/16 * H words (9AEBH_10-9 = 01 b)
32-bittransfers: COUNT = (W+31)/32 * H dwords (9AEBH_10-9 = 10b)
New 32-bit transfers: COUNT = (((W+7)/B*Hl+3)/4 dwords (9AEBH_10-9 = 11 b) (Tri032 only)
The differences between the two 32-bit transfer options are:
1. For 9AEBH_10-9 set to 10b, every line of the transfer must start with a fresh doubleword. In other
words, all unneeded bits in a doubleword transfer for a given line are discarded. After a rectan
gular image is transferred, the current drawing position is a the bottom left, meaning the next
rectangle, if drawn, will be below the previous rectangle.
2. (Trio32 B, 16 and 24 bits/pixel modes only) For 9AEBH_10-9 set to 11b, only bits from the end of
the line width to the next byte boundary are discarded. Data for the next line begins with the
next byte. After a rectangular image is transferred, the current drawing position is a the top
right, meaning the next rectangle, if dravyn, will be to the right of the previous rectangle.
To write to a single plane, setthe foreground mixto 'logical one' (0002H), the background mixto 'logical
zero' (0001H), and the Write Mask register (AAEBH) to select the desired (single) plane for updates.
13-16 ENHANCED MODE PROGRAMMING

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
13.3.3.6 BitBLT-Through the Plane
This command copies a source rectangular area in display memory to another location in display
memory. The Pixel Control register must be set to AOOOH to select the Foreground Mix register to
specify the color source and mix type. The color source must be specified as the bitmap (display
memory). Bit 6 of the Command register must be set to 1 to specify X as the major axis.  For this
example, assume x1,y1 is the top left corner of the source rectangle in display memory and x2,y2 is
the top left corner ofthe destination rectangle. The rectangles can be overlapping or disjoint. The height
and width (in pixels) of the rectangle being copied are HEIGHT and WIDTH.
Setup:
First, the values of the Srcx, Srcy, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, Y Positive: Srcx = x1, Srcy = y1, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
Ifx1 > x2
then if X Positive, Srcx = x1, Destx = x2
else
| Srcx = x1 + WIDTH -1, Destx = x2 + WIDTH -1  |     | ; X Negative  |
| -------------------------------------------- | --- | ------------- |
Ify1 > y2
then if Y Positive, Srcy = y1, Desty = y2
else
| Srcy = y1 + HEIGHT -1, Desty = y2 + HEIGHT-1  |     | ; Y Negative  |
| --------------------------------------------- | --- | ------------- |
ES:[PIXEL_CNTL] <== AOOOH  ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX] <== 0067H  ; color source is display memory and mix type is NEW
Draw Operation:
|                       | 31  15  0   |                           |
| --------------------- | ----------- | ------------------------- |
|                       | I  l        | ;                         |
| ES:[ALT  _CURXY] <==  | Srcx  Srcy  | set starting coordinates  |
| 31                    | 15  0       |                           |
| I                     | I           | ;                         |
ES:[ALT  _STEP] <==  Destx  Desty  set destination coordinates
| 31                   | 15  0              |     |
| -------------------- | ------------------ | --- |
| I                    | I  I               |     |
| ES:[ALT _PC NT] <==  | WIDTH-1  HEIGHT-1  |     |
; rectangle width and height
ES:[CMD] <== 11000000DOD10001b  ; BitBLT  (bits 15-13, 11), always X Major (bit 6) , draw (bit 4)
ENHANCED MODE PROGRAMMING  13-17

S3 Trio32/Trio64 Integrated Graphics Accelerators
S31ncorporatad
13.3.3.7 BitBLT-Across the Plane
This uses the same command as a BitBLT through the plane. However, instead of copying complete
pixels (with color affected only by the mix), this 'across the plane" transfer uses only the bits in the
color planes specified by setting the Read Mask register (AEE8H), e.g., bit 3 of every pixel, to determine
the destination rectangle. With more than one plane enabled for read, if all the bits in the planes enabled
for read are '1's then a '1' is read. If a bit in anyone of the planes enabled for read is a '0', then '0' is
read. An "across the plane" transfer is created by (1) setting bits 7-6 of the Pixel Control register (BEE8H,
Index AH) to AOCOH to specify the bitmap as the source of the mask bit selecting the mix register, (2)
programming the Read and Write Mask registers to specify the plane to read from and write to and (3)
setting bit 1 of the Command register to 1 (multi-pixel). In this example, when the bit read is a 1, a 1 is
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
Srcx = x1 + WIDTH -1, Destx = x2 + WIDTH -1 ; X Negative
Ify1 > y2
then if Y Positive, Srcy = y1, Desty = y2
else
Srcy = y1 + HEIGHT -1, Desty = y2 + HEIGHT-1 ; Y Negative
ES:[PIXEL_CNTL) <= AOCOH ; data from display memory selects mix register
31 15 0
ES:[AL T_ MIX) <= _00_0_2_H_L--_0_00_1_H---,1 ; result of foreground mix is always logical 1,
LI
; result of background mix is always logical 0
ES:[RD_MASK) <= 00000001H ; read from plane 0
ES:[WRT_ MASK) <= 00000004H ; plane 2 enabled for write
13-18 ENHANCED MODE PROGRAMMING

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Draw Operation:
|                      | 3r1 __~   ___1 ,5_  | _~   ___O                   |
| -------------------- | ------------------- | --------------------------- |
| ES:[ALT  _CURXY] <=  |                     | ; set starting coordinates  |
_S_rc_x_-,--_Sr_c-,--y---,l
1-1
|     | 3r1~~ ___1 ,5_  _ | =   -___ O  |
| --- | ----------------- | ----------- |
ES:[ALT  _STEP] <=  _D_es_tx_-,--_D_e_s....;.tY---,1  ; set destination coordinates
1-1
|     | 31  15   | 0   |
| --- | -------- | --- |
|     | <=1  1   |     |
ES:[ALT_PCNT]  WIDTH-1  H EIGHT-1l  ; rectangle width and height
ES:[CMD] <= 11000000DOD10001 b  ; BitBLT (bits 15-13, 11), always X Major (bit 6), draw (bit 4),
; multi-pixel (bit 1)
Note
It is possible to translate a monochrome image, e.g., text fonts, stored in a single plane in display
memory into a 2-color image. This is accomplished by setting the mix registers differently and setting
the desired background and foreground colors. If the source bit is a '1', then the corresponding pixel
at the destination is colored with the foreground color index. The destination pixel is colored with the
background color index if the corresponding source bit is a '0'. The setup for this is as follows:
<=
| ES:[WRT_ MASK]  | FFFFFFFFH  | ; enable all planes for writing  |
| --------------- | ---------- | -------------------------------- |
ES:[FRGD_MIX] <= 0027H  ; color source foreground, mix type NEW
<=
ES:[BKGD_MIX]  0007H  ; color source background, mix type NEW
| ES:[FRGD_COLOR] <= 00000004H  |     | ; foreground color  |
| ----------------------------- | --- | ------------------- |
<=
| ES:[BKGD_COLOR]  | 00000001H  | ; background color  |
| ---------------- | ---------- | ------------------- |
ENHANCED MODE PROGRAMMING  13-19

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
13.3.3.8 PatBlT - Pattern Fill Through the Plane
An 8x8 pixel pattern is initially copied into an off-screen area of display memory using an image transfer
operation or a direct write (linear addressing). This command then repeatedly tiles this source pattern
into a destination rectangle of arbitrary size. The colors of the destination pixels are affected only by
the mix selected. The destination rectangle must not overlap the source pattern. Each copy is aligned
to an 8-pixel boundary (x coordinate = 0, 8, etc.), with pixels outside the destination rectangle boundary
not being drawn. The Pixel Control register must be set to AOOOH to select the Foreground Mix register
to specify the color source and mix type. The color source must be specified as the bitmap (display
memory). Bit 6 of the Command register must be setto 1 to specify X as the major axis. In this example,
assume x1.y1 is the top left corner of the pixel pattern and x2.y2 is the top left corner of the destination
rectangle. The height and width (in pixels) of the rectangle are HEIGHT and WIDTH.
Setup:
ES:[PIXEL_CNTL) <= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX) <= 0067H ; color source is display memory, mix type is NEW
Draw Operation
31 15 0
ES:[AL T _CURXY) <= _x_1_-L-_y:.....1_-,1 ; set starting coordinates
,--I
31 15 0
---Ji
ES:[ALT _STEP) <= 1'----_x_2_--'----'-y_2 ; set destination coordinates
31 15 0
J
ES:[ALT_ PC NT) <=1 WIDTH-1 1 HEIGHT-1 ; rectangle width and height
ES:[CMD) <= 11100000DOD10001b ; PatBLT (bits 15-13,11), always X Major (bit 6) , draw (bit 4)
13-20 ENHANCED MODE PROGRAMMING

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
13.3.3.9 PatBlT - Pattern Fill Across the Plane
This uses the same command as a PatBlT through the plane. However, instead of copying complete
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
The height and width ofthe destination rectangle are HEIGHT and WIDTH.
Setup:
ES:[PIXEl_CNTl] <= AOCOH ; data from display memory selects mix register
31 15 0
ES:[AlT _MIX] <= 1 0002H 0001 H 1 ; result of foreground mix is always logical 1,
~------~------~ ; result of background mix is always logical 0
ES:[RD_MASK] <= 00000001H ; read from plane 0
ES:[WRT_ MASK] <= 00000004H ; plane 2 enabled for write
Draw Operation:
3r1 _______1 ~5------_0
ES:[AlT_CURXY] <= _X_1_-,--_y-,--1_-,l ; set starting coordinates
1....1
31 15 0
ES:[AlT _ STEP] <= IL_X_2_-,--_y:....2_--,i ; set destination coordinates
31 15 0
ES:[AlT _ PC NT] <= WIDTH-1 HEIGHT-1 ; rectangle width and height
1 1 1
ES:[CMD] <= 11100000DOD10011b ; PatBlT (bits 15-13, 11), always X Major (bit 6) , draw (bit 4),
; mUlti-pixel (bit 1)
Note
To expand the source mono pattern into a 2-color pattern, set the foreground mix to 27H, the
background mix to 7H and the foreground and background colors as desired. Also set the write mask
(AAE8H) to FFFFFFFFH. This needs to be set only once. It is altered only by another write.
ENHANCED MODE PROGRAMMING 13-21

,I.
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
13.3.3.10 Short Stroke Vectors
This command rapidly draws short lines (up to 15 pixels in length). Such lines are constrained to one
of the 8 directions at 45 degree increments starting at 0 degrees. The current point x1,y1 is set and a
NOP command is issued to set all the desired drawing parameters without actually writing a pixel. For
example, bit 2 (Last Pixel Off) would be set to 1 (OFF) for drawing connected lines until the last line is
drawn. The short stroke vector parameters are then loaded in the Short Stroke Vector Transfer (9EE8H)
register (SHORT_STROKE). Two vectors can be defined at a time, one in the low byte and one in the
high byte. For the low byte, bits [7:5) define the direction, with bit 4 set to '1' for a draw operation or
to '0' for a move current position operation. Bits 3-0 define the length of the short line. Let SSVDO,
SSVD1, ... SSVDN-1 bytes be the short stroke vector data for N lines.
Setup:
ES:[PIXEL_CNTL) ¢:: AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX) ¢:: 0027H ; use the foreground color, mix type NEW
ES:[FRGD_COLOR)¢:: 00000004H ; foreground color index 4
Draw Operation:
31 15 0
ES:[AL T _CURXY) ¢:: 1'--_X_1_---'-_--'-y_1_---'1 ; set starting coordinates
ES:[CMD) ¢:: 00010010XXX11111b ; NOP (bits 15-13, 11), byte swap (bit 12), 16-bit transfers
; (bits 10-9) , draw (bit 4), radial drawing direction (bit 3),
; last pixel off (bit 2), mUlti-pixel (bit 1)
While space available in the FIFO
ES:[SHORT_ STROKE) ¢:: SSVD1 SHL 8 + SSVDO; SSVD1 shifted to high byte, SSVDO in low byte
ES:[SHORT_ STROKE) ¢:: SSVD3 SHL 8 + SSVD2; byte swap turned on to read vectors out in
; correct order
ES:[SHORT_STROKE) ¢:: SSVDN-1 SHL 8 + SSVDN-2
13-22 ENHANCED MODE PROGRAMMING

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
13.3.3.11 Polyline/2-Point Line (Trio64 Only)
This command draws a line from point P1 (x1,y1) to point P2 (x2,y2).ltcan be usedto draw an additional
line from the end point ofthe last line drawn by specifying only the next end point. This can be repeated
for as many polyline segments as desired. The Pixel Control register must be set to AOOOH to select
the Foreground Mix register to specify the color source and mix type. The color source must be specified
as the foreground color.
Setup:
ES:[FRGD_MIX) <== 0027H ; color source is FRGD_COLOR, NEW mix type
ES:[FRGD_COLOR)<== 00000002H ; color index
ES:[PIXEL_CNTL) <== AOOOH ; FRGD_MIX specifies the color source and mix type
Draw Operation:
3' '5 0
ES:[ALT _CURXY) <== 1L--_X_1_-'-_-'-y1_--...J1 ; set starting coordinates
3,' _______' ,5_ ______0
ES:[ALT _STEP) <== _X_2_--,-_y:....2_--,1 ; set destination coordinates
LI
ES:[CMD)<== 0010100000010001b ; draw 2-point line (bits 15-13, 11), draw (bit 4)
Repeat the last two instructions to draw additional polyline segments.
Note
This command is faster for drawing a 2-point line than the Solid Line drawing command. However,
the Bresenham parameters are fixed in hardware and cannot be manipulated by the programmer as
with the Solid Line command. A textured line cannot be drawn with this command.
ENHANCED MODE PROGRAMMING 13-23

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
13.3.3.12 Polygon Fill Solid {Trio64 Only}
This command draws a polygon and fills it with a solid color. Any number of sides can be drawn, but
the shape must be such that any horizontal line must intersect the polygon edges in no more than two
places. To accomplish this, all edge segments must be drawn downward. The exception is that any
edge can be horizontal. The Pixel Control register must be set to AOOOH to select the Foreground Mix
register to specify the color source and mix type. This example uses the mix NEW and color index 2.
This example shows how to draw the polygon shown in Figure 13-2.
x1,y1
x3,y3
x2,y2
y4
x7
STEP 1 STEP 2 STEP 3 STEP 4 STEP 5 POLY
Figure 13-2. Polygon Example Drawing Steps
Setup:
ES:[FRGD_MIX] <= 0027H ; color source is FRGD_COLOR, NEW mix type
ES:[FRGD_COLOR] <= 00000002H ; color index
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX specifies the color source and mix type
Draw Operation:
3,'_ ______', 5 _______0
ES:[ALT _CURXY] <= 1'--_x_1_-'----'y'--1_.....Jl ; set starting coordinates for segment 1 of left side
3' '5 0
ES:[ALT _STEP] <= _X_2_-,--_y.:....2_-,i ; set destination coordinates for segment 1 of left side
L...I
3' '5 0
ES:[ALT _CURXY2] <= 1.... ___X _1 __- -'-__" """"""'-y_1 __- >l ; set starting coordinates for segment 1 of right side
3,'_ ______', 5 _______0
ES:[ALT _STEP2] <=1 _X_3_--,--_Y,--3_--,l ; set destination coordinates for segment 1 of right side
L...
ES:[CMD]<= 0110000000010001b ; draw polygon (bits 15-13, 11), draw (bit 4) -Step 1
3,'_ ______', 5 _______0
ES:[ALT _STEP2] <= 1L..._x_4_--,-_y,--4_->l ; set destination coordinates for segment 2 of right side
ES:[CMD]<= 0110000000010001b ; draw polygon (bits 15-13, 11) -Step 2
3' '5 0
ES:[ALT _STEP] <= 1.... ___x _5_ _- -'-__" """"""'-y_5 __- >1 ; set destination coordinates for segment 2 of right side
13-24 ENHANCED MODE PROGRAMMING

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
ES:[CMD]<= 01100000000010001b  ; draw polygon (bits 15-13, 11) -Step 3
|     | 31  15  | 0   |     |     |
| --- | ------- | --- | --- | --- |
; set destination coordinates for segment 3 of left side
ES:[ALT_STEP] <=1,-_x_6_-'--_y'-6_---'1
ES:[CMD]<= 0110000000010001b  ; draw polygon (bits 15-13, 11) -Step 4
|     | 31  15  | 0   |     |     |
| --- | ------- | --- | --- | --- |
ES:[ALT _ STEP] <= 1,--_X_7_-,---,y,-7_-,1  ; set destination coordinates for segment 4 of left side
3r1 __~   ___lT 5 _______0
ES:[AL T_ STEP2] <= 1'--_x_8_---'--_-'-y8_-.-Jl  ; set destination coordinates for segment 3 of right side
ES:[CMD]<= 0110000000010001b  ; draw polygon (bits 15-13, 11) -Step 4
The generation of this polygon is summarized in the following table.
Table 13-2  Polygon Fill Example Summary
|         | First Line  |           | Second Line  |            |
| ------- | ----------- | --------- | ------------ | ---------- |
|         | ALT CURXY   | ALT STEP  | ALT CURXY2   | ALT STEP2  |
| Step 1  | xl  yl      | x2  y2    | xl  yl       | x3  y3     |
CMD
| Step 2  |     |     |     | x4  y4  |
| ------- | --- | --- | --- | ------- |
CMD
| Step 3  |     | x5  V5  |     |     |
| ------- | --- | ------- | --- | --- |
CMD
| Step 4  |     | x6  V6  |     |     |
| ------- | --- | ------- | --- | --- |
CMD
| Step 5  |     | x7  y7  |     | x8  V8  |
| ------- | --- | ------- | --- | ------- |
CMD
Notes
1.  The current V for the first two line segments must be the same (y1 in the example). The current x
for these two line segments can be the same (point) or different (horizontal top edge).
2.  The fill proceeds down until it reaches an end point for one of the edges. The next line segment is
then drawn as an extension of this edge, with the fill again stopping at the first end point it
reaches. For example, note how after segment 2 of the right side is drawn to x4,y4, the fill
stops at x2,y2 of the first segment of the left side.
3.  Segment 3 of the left side ends at the same vertical position as segment 2 of the right side (Step
4). When this occurs, both edges of the polygon must be extended by the next command. This
is shown in Step 5.
4.  For the step that closes the polygon (Step 5 in the example), the destination y positions must be
be the same (y7 =y 8 in the example) for the two edge segments making the closure. As with
the top edge, the x positions mav be different (forming a horizontal bottom edge) or the same
(a point).
5.  When two lines join or cross at an angle other than 90 degrees, the common pixel will not be
drawn.
ENHANCED MODE PROGRAMMING  13-25

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
13.3.3.13 Polygon Fill Pattern (Trio64 Only)
This command operates exactly as the polygon fill solid except that an 8x8 pixel pattern is tiled into
the polygon instead of a solid color. The 8x8 pattern can either be color or mono and must first be
programmed into off-screen memory using an image transfer or linear addressing. The colors of the
destination pixels are affected only by the mix selected. The destination polygon must not overlap the
source pattern. Each copy is aligned to an 8-pixel boundary (x coordinate = 0, 8, etc.), with pixels outside
the destination polygon boundary not being drawn. For a color pattern. the Pixel Control register must
be set to AOOOH to select the Foreground Mix register to specify the color source and mix type. The
color source must be specified as the bitmap (display memory). For a mono pattern, the Pixel Control
register must be set to AOCOH to select the bitmap as the source of the mask bit selecting the mix
register. If the pattern bit is a 1, the Foreground Mix register is chosen, which must be programmed
to select the foreground color. If the pattern bit is a 0, the Background Mix register is chosen, which
must be programmed to select the background color.
Setup: (Color Pattern)
ES:[PIXEL_CNTL] ~ AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX] ~ 0067H ; color source is display memory, mix type is NEW
31 15 o
PAT _Y 1 ; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Color Pattern)
Same as for polygon fill solid except
ES:[CMD]~ 01101000000010001b ; draw polygon with pattern fill (bits 15-13, 11)
is substituted for each of the command lines.
Setup: (Mono Pattern)
~ 15 0
ES:[AL T_ MIX] ~ -0-0-27-H--'--0-0-05-H-":;1 ; FRGD_COLOR color source and mix is NEW
r-I
; BKGD_COLOR is color source and mix is XOR
ES:[FRGD_COLOR] ~ 00000004H ; foreground color index 4
ES:[BKGD_COLOR] ~ OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTL] ~ AOCOH ; selection of mix register is based on data from the screen
31 15 0
I
ES:[ALT_PAT] ~I PAT_X PAT_Y 1 ; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Mono Pattern)
Same as for polygon fill solid except
ES:[CMD]~ 0110100000010011b ; draw polygon with pattern fill (bits 15-13, 11),
; mUlti-pixel (bit 1)
is substituted for each of the command lines.
13-26 ENHANCED MODE PROGRAMMING

I:
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
13.3.3.14 4-Point Trapezoid Fill Solid (Trio64 Only)
This command draws a solid trapezoid specified by edge 1 [points P1 (x1,y1) and P2 (x2,y2)] and edge
2 [points P3 (x3,y3) and P4 (x4,y4)]. P1 and P3 must be on the same horizontal line and P2 and P4 must
be on a different lower horizontal line. The Pixel Control register must be set to AOOOH to select the
Foreground Mix register to specify the color source and mix type. This example uses the mix NEW and
color index 2.
~P4
Setup:
ES:[FRGD_MIX) <= 0027H ; color source is FRGD_COLOR, NEW mix type
ES:[FRGD_COLOR) <= 00000002H ; color index
ES:[PIXEL_CNTL) <= AOOOH ; FRGD_MIX specifies the color source and mix type
Draw Operation:
31 15 0
ES:[ALT _CURXY) <= _X_1_--,-_y:.--1_-,1 ; set starting coordinates for edge 1
L.I
~ 15 0
ES:[ALT _STEP) <= _X_2_--,-_y,-2_-,1 ; set destination coordinates for edge 1
L.I
31 15 0
ES:[ALT _CURXY2) <= 1....1 __x _3_----'-_---'-y3_----'1 ; set starting coordinates for edge 2
3r1_ ___1 ,5_ ___0
J
ES:[ALT _STEP2) <= 1 x4 y4 ; set destination coordinates for edge 2
ES:[CMD)<= 1000000000010001b ; draw 4-point trapezoid (bits 15-13, 11), draw (bit 4)
Note
The y coordinates for line 2 (y3 and y4) are not required. If they are programmed, they must be the
same as y1 and y2 respectively.
ENHANCED MODE PROGRAMMING 13-27

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
13.3.3.15 4-point Trapezoid Fill Pattern (Trio64 Only)
This command operates exactly as the 4-point trapezoid fill solid except that an 8x8 pixel pattern is
tiled into the trapezoid instead of a solid color. The 8x8 pattern can either be color or mono and must
first be programmed into off-screen memory using an image transfer or linear addressing. The
destination trapezoid must not overlap the source pattern. Each copy is aligned to an 8-pixel boundary
(x coordinate = 0, 8, etc.), with pixels outside the destination trapezoid boundary not being drawn. For
a color pattern. the Pixel Control register must be set to AOOOH to select the Foreground Mix register
to specify the color source and mix type. The color source must be specified as the bitmap (display
memory). For a mono pattern, the Pixel Control register must be set to AOCOH to select the bitmap as
the source of the mask bit selecting the mix register. Ifthe pattern bit is a 1, the Foreground Mix register
is chosen, which must be programmed to select the foreground color. If the pattern bit is a 0, the
Background Mix register is chosen, which must be programmed to select the background color.
Setup: (Color Pattern)
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX] <= 0067H ; color source is display memory, mix type is NEW
31 15
; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Color Pattern)
Same as for 4-point trapezoid fill solid except the command is as follows:
ES:[CMD]<= 0110100000010001b ; draw trapezoid with pattern fill (bits 15-13, 11)
Setup: (Mono Pattern)
3r1 _______1 ~5------_0
ES:[ALT _ MIX] <= _0_0_27_H_,--0_0_05_H---ll ; FRGD_COLOR color source and mix is NEW
,-I ; BKGD_COLOR is color source and mix is XOR
ES:[FRGD_COLOR] <= 00000004H ; foreground color index 4
ES:[BKGD_COLOR] <= OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTL] <= AOCOH ; selection of mix register is based on data from the screen
31 15 o
; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Mono Pattern)
Same as for 4-point trapezoid fill solid except the command is as follows:
ES:[CMD]<= 1000100000010011b ; draw trapezoid with pattern fill (bits 15-13, 11), multi-pixel (bit 1)
13-28 ENHANCED MODE PROGRAMMING

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
13.3.3.16 Bresenham Parameter Trapezoid Fill Solid (Trio64 Only)
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
ES:[PIXEL_CNTLl <= AOOOH  ; FRGD_MIX specifies the color source and mix type
Draw Operation
|     | 31  | 15  | 0   |
| --- | --- | --- | --- |
ES:[ALT_ CURXV] <=!L __X _1_--L._..:.y_1_--,!  ; set starting coordinate for edge 1
ES:[MAJ_AXIS_PCNT] <= MAX -1  ; length in pixels of the major axis -1 for edge 1
|     | 31  | 15  | 1 o  ;  |
| --- | --- | --- | ------- |
ES:[ALT_STEP] <=f(MIN-MAX)1  2*MIN  diagonal and axial step constants for edge 1
If the X drawing direction is positive then
| ES:[ERR_TERM] <= 2 * MIN - |     | MAX  | ; error term for edge 1  |
| -------------------------- | --- | ---- | ------------------------ |
else if the X drawing direction is negative
| ES[ERR_ TERM] <= 2 * MIN - |     | MAX - 1  | ; error term for edge 1  |
| -------------------------- | --- | -------- | ------------------------ |
|                            | 31  | 15       | o                        |
|                            | I   |          | I ;                      |
ES:[AL T_ CURXV2] <=  x2  y2  set starting coordinate for edge 2
ES:[MAJ_AXIS_PCNT2] <= MAX -1  ; length in pixels of the major axis -1 for edge 2
3r1 ____~ 1T5 _____0
J;
ES:[ALT_ STEP2] <=12*(MIN-MAX)1  2*MIN  diagonal and axial step constants for edge 2
If the X drawing direction is positive then
| ES:[ERR_TERM] <= 2 * MIN - |     | MAX  | ; error term for edge 2  |
| -------------------------- | --- | ---- | ------------------------ |
else if the X drawing direction is negative
| ES[ERR_T ERM] <= 2 * MIN - |     | MAX - | 1  ; error term for edge 2  |
| -------------------------- | --- | ----- | --------------------------- |
ES:[CMD2]<= 000000001 DDOOOOOb  ; edge 2 drawing direction (bits 7-5)
ES:[CMD]<= 101000001DD10001b  ; draw Bresenham parameter trapezoid (bits 15-13, 11)
; edge 1 drawing direction (bits 7-5). draw (bit 4)
Note that the last two instructions can be packed, i.e, ES:[ALT  _CMD], with CMD in the lower word
(15-0) and CMD2 in the upper word (31-16). Ifthey are not packed, CMD2 must precede CMD as
shown.
ENHANCED MODE PROGRAMMING  13-29

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
13.3.3.17 Bresenham Parameter Trapezoid Fill Pattern (Trio64 Only)
This command operates exactly as the Bresenham parameter trapezoid fill solid except that an 8x8
pixel pattern is tiled into the trapezoid instead of a solid color. The 8x8 pattern can either be color or
mono and must first be programmed into off-screen memory using an image transfer or linear
addressing. The destination trapezoid must not overlap the source pattern. Each copy is aligned to an
a-pixel boundary (x coordinate = 0, 8, etc.), with pixels outside the destination trapezoid boundary not
being drawn. For a color pattern. the Pixel Control register must be set to AOOOH to select the
Foreground Mix register to specify the color source and mix type. The color source must be specified
as the bitmap (display memory). For a mono pattern, the Pixel Control register must be set to AOCOH
to select the bitmap as the source ofthe mask bit selecting the mix register. Ifthe pattern bit is a 1, the
Foreground Mix register is chosen, which must be programmed to select the foreground color. If the
pattern bit is a 0, the Background Mix register is chosen, which must be programmed to select the
background color.
Setup: (Color Pattern)
ES:[PIXEL_CNTL] <= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX] <= 0067H ; color source is display memory, mix type is NEW
3r1~-= ___1 ,5_ _~ ~~O
ES:[AL T_ PAT] <= I PAT_X I PAT_Y I ; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Color Pattern)
Same as for Bresenham parameter trapezoid fill solid except the command is as follows:
ES:[CMD]<= 101010001 DD10011 b ; draw Bresenham parameter trapezoid with pattern fill
; (bits 15-13, 11)
Setup: (Mono Pattern)
31 15 0
I
ES:[AL T_ MIX] <= I 0027H 0005H ; FRGD_COLOR color source and mix is NEW
~~----~~~--~ ; BKGD_COLOR is color source and mix is XOR
ES:[FRGD_COLOR] <= 00000004H ; foreground color index 4
ES:[BKGD_COLOR] <= OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTL] <= AOCOH ; selection of mix register is based on data from the screen
31 15 0
ES:[AL T_ PAT] <= I'--::PC"-:A=T_ -::-X~I---:::CP-::-AT=-_"'-:Y-l ; coordinates of upper left hand corner of 8x8 pattern
Draw Operation: (Mono Pattern)
Same as for Bresenham parameter trapezoid fill solid except the command is as follows:
ES:[CMD]<= 101010001DD10011b ; draw Bresenham parameter trapezoid with pattern fill
; (bits 15-13,11), multi-pixel (bit 1)
13-30 ENHANCED MODE PROGRAMMING

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
13.3.3.18 Programmable Hardware Cursor
A programmable cursor is supported which is compatible with the Microsoft Windows (bit 4 of CR55
= 0) and Xll (bit 4 of CR55 = 1) cursor definitions. The cursor size is 64 pixels wide by 64 pixels high,
with the cursor pattern stored in an off-screen area of display memory. Two monochrome images 64
bits wide by 64 bits high (512 bytes per image) define the cursor shape. The first bit image is an AND
mask and the second bit image is an XOR mask. The following is the truth table for the cursor display
logic.
AND Bit XOR Bit Displayed (Microsoft Windows) Displayed (X11)
0 0 Cursor Backoround Color Current Screen Pixel
0 1 Cursor Foreoround Color Current Screen Pixel
1 0 Current Screen Pixel Cursor Backoround Color
1 1 NOT Current Screen Pixel Cursor Foreground Color
The hardware cursor color is taken from the Hardware Graphics Cursor Foreground Stack (CR4A) and
the Hardware Graphics Cursor Background Stack (CR4B) registers. Each of these is a stack ofthree 8-bit
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
visible at the right edge or top edge of the screen respectively. Note that if Y 2: 768 then the cursor is
not visible; it is residing in the off-screen area.
A partial cursor image can be displayed at the left edge or the top edge ofthe screen. To enable partial
cursor display at the top edge of the screen, Y is set to 0 and the Y offset register is set to OY (range
from 0 to 63). This displays the bottom 64-0Y rows of the cursor image at the currently set X position
and the top edge of the screen. Similarly, a partial cursor can be displayed at the left edge of the screen
by setting X to 0 and the X offset register to OX (range from 0 to 63). This displays the right 64-0X
columns of the cursor image at the currently set X and the left edge of the screen. The following
pseudocode illustrates cursor positioning.
CR39 <=AOH ; Unlock System Control registers
CR46_10-8 <= MS 3 bits of X cursor position
CR47 _7 -0 <= LS 8 bits of X cursor position
ENHANCED MODE PROGRAMMING 13-31

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
CR49_7-0 <= LS 8 bits of Y cursor position
CR4E_5-0 <= Cursor Offset X position
CR4F _5-0 <= Cursor Offset Y position
CR48_ 10-8 <= MS 3 bits of Y cursor position
CR39 <=OOH ; Lock System Control registers
The cursor position is updated by the hardware once each frame. Therefore, the programmer should
ensure that the position is re-programmed no more than once for each vertical sync period.
Programming the Cursor Shape
The AND and the XOR cursor image bitmaps are 512 bytes each. These bitmaps are word interleaved
in a contiguous area of display memory, i.e., AND word 0, XOR word 0, AND word 1, XOR word 1 ...
AND word 255, XOR word 255. The starting location must be on a 1024-byte boundary. This location
is programmed into the Hardware Graphics Cursor Start Address registers (CR4C and CR4D) as follows:
CR39 <= AOH ; Unlock System Control registers
CR4C_11-8 <= MS 4 bits of the cursor storage start 1024-byte segment.
CR4D <= LS 8 bits of the cursor storage start 1024-byte segment
CR39 <= 0 ; Lock System Control registers
The value programmed is the 1024-byte segment of display memory at which the beginning of the
hardware cursor bit pattern is located. For example, for an 800x600x8 mode on a 1 MByte system,
there are 10241 K segments. Programming CR4C_ 11-8 with 3H and CR4D with FEH specifies the starting
location as the 1022nd (O-based) 1K segment. The cursor pattern is programmed (using linear
addressing) at FF800H offset from the base address of the frame buffer.
Note
If the cursor is not 64 bits by 64 bits, the given images should be padded to make the cursor image 64
bits by 64 bits. The padded area should be made transparent by padding the extra AND mask bits with
'1's and the extra XOR bits by 'O's.
13.4 RECOMMENDED READING
Graphics Programming for the 8514/A by Jake Richter and Bud Smith (M&T Publishing, Inc) provides
extensive explanations and examples for programming most of the bits in the S3 Enhanced Registers.
This book may be out of print.
Programmer's Guide to the EGA, VGA and Super VGA Cards, 3rd Edition by Richard F. Ferraro
(Addison-Wesley Publishing Company, Inc) includes a section on programming for S3 accelerator
chips.
13-32 ENHANCED MODE PROGRAMMING

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Section 14: VGA Standard Register Descriptions
In the following register descriptions, 'U' stands for undefined or unused and 'R' stands for reserved
(write = 0, read = U). A question mark in an address stands for a hexadecimal value of either 'B' or 'D'.
If bit 0 of the Miscellaneous Output Register (3C2H, Write) is set to 1, the address is based at 3DxH for
color emulation. If this bit is reset to 0, the address is based at 3BxH for monochrome emulation.
See Appendix A for a table listing each register in this section and its page number.
14.1  GENERAL REGISTERS
This section describes general input status and output control registers.
Miscellaneous Output Register (MISe)
| Write Only  |     | Address: 3C2H  |     |
| ----------- | --- | -------------- | --- |
| Read Only   |     | Address: 3CCH  |     |
Power-On Default: OOH
This register controls miscellaneous output signals. A hardware reset sets all bits to zero.
I
| 7  6      | 5  4                         | 3  2      | 1  0      |
| --------- | ---------------------------- | --------- | --------- |
|           |                              | elK  SEl  | ENB  lOA  |
| VSP  HSP  | PGSl  =0                     | 1  0      | RAM  SEl  |
| Bit 0     | lOA SEl -I/O Address Select  |           |           |
o = Monochrome emulation. Address based at 3Bx
1 = Color emulation. Address based at 3Dx
| Bit 1  | ENB RAM -Enable CpU Display Memory Access  |     |     |
| ------ | ------------------------------------------ | --- | --- |
o = Disable access of the display memory from the CPU
1 = Enable access of the display memory from the CPU
VGA STANDARD REGISTER DESCRIPTIONS  14-1

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Bits 3-2 Clock Select -Select the Video Clock Frequency
00 = Selects 25.175 MHz DCLK for 640 horizontal pixels
01 = Selects 28.322 MHz DCLK for 720 horizontal pixels
10 = Reserved
11 = Enables loading of DCLK PLL parameters in SR12 and SR13.
A setting of either OOb or 01 b causes the appropriate values to be programmed into
the DCLK PLL registers if bit 1 of SR15 is set to 1.
Bit 4 Reserved = 0
Bit 5 PGSL -Select High 64K Page
o
= Select the low 64K page of memory
1 = Select the high 64K page of memory
Bit 6 HSP -Select Negative Horizontal Sync Pulse
o
= Select a positive horizontal retrace sync pulse
1 = Select a negative horizontal retrace sync pulse
Bit 7 VSP -Select Negative Vertical Sync Pulse
o = Select a positive vertical retrace sync pulse
1 = Select a negative vertical retrace sync pulse
Feature Control Register IFCR_WT, FCR_AD)
Write Only Address: 31AH
Read Only Address: 3CAH
Power-On Default: OOH
1 o
=0
Bits 2-0 Reserved = 0
Bit 3 VSSL -Vertical Sync Type Select
o = Enable normal vertical sync output to the monitor
1 = The 'vertical sync' output is the logical OR of 'vertical sync' and 'vertical active
display enable' (an internal signal)
Bits 7-4 Reserved = 0
14-2 VGA STANDARD REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
°
| Input Status  | Register (STATUS_O)  |                |     |
| ------------- | -------------------- | -------------- | --- |
| Read Only     |                      | Address: 3C2H  |     |
Power-On Default: Undefined
This register indicates the status of the VGA adapter.
| 7  6       | 5  4                            | 3  2    | 1  °    |
| ---------- | ------------------------------- | ------- | ------- |
| CRT        | MaN                             |         |         |
| INTPE  =0  | =0  SENS                        | =0  =0  | =0  =0  |
| Bits 3-0   | Reserved = 0                    |         |         |
| Bit 4      | MaN SENS -Monitor Sense Status  |         |         |
o
= The internal SENSE signal is a logical 0
1 = The internal SENSE signal is a logical 1
| Bits 6-5  | Reserved = 0                     |     |     |
| --------- | -------------------------------- | --- | --- |
| Bit 7     | CRT INTPE -CRT Interrupt Status  |     |     |
0= Vertical retrace interrupt cleared
1 = Vertical retrace interrupt pending
See Section 10.7 for an explanation of interrupt generation.
Input Status 1 Register (STATUS_1)
| Read Only  |     | Address: 37AH  |     |
| ---------- | --- | -------------- | --- |
Power-On Default: Undefined
This register indicates video sync timing and video wraparound.
I
| 7  6  | 5  4  | 3  2  | 1  0  |
| ----- | ----- | ----- | ----- |
TST-VDT
| =0  =0  | 1  0  | VSY  = 1  | LPF  DTM  |
| ------- | ----- | --------- | --------- |
°
| Bit  | DTM -Display Mode Inactive  |     |     |
| ---- | --------------------------- | --- | --- |
o = The display is in the display mode.
1 = The display is not in the display mode. Either the horizontal or vertical retrace
period is active
| Bit 1  | Reserved = 0               |     |     |
| ------ | -------------------------- | --- | --- |
| Bit 2  | Reserved = 1               |     |     |
| Bit 3  | VSY -Vertical Sync Active  |     |     |
o
= Display is in the display mode
1 = Display is in the vertical retrace mode
VGA STANDARD REGISTER DESCRIPTIONS 14-3

S3 Trio32/Trio64 Integrated Graphics Accelerators
S31ncorporatad
| Bits 5-4  | TST-VDT -Video Signal Test  |     |     |
| --------- | --------------------------- | --- | --- |
Video Data Feedback 1,0. These bits are feedback video signals to do read back tests.
These bits are selectively connected to two of the eight color outputs of the attribute
controller. Bits 5 and 4 of the color plane enable register (AR12) control the multi
plexer for this video output observation.
Reserved = 0
Bits 7-6
14.2 SEQUENCER REGISTERS
The sequencer registers are located at two-byte address spaces. These registers are accessed by first
writing the data to the index register ofthe sequencer at I/O address 3C4H and then writing to or reading
from the data register at 3C5H.
Sequencer Index Register (SEQX)
| ReadNVrite  |     | Address: 3C4H  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is loaded with a binary value that indexes the sequencer register for read/write data. This
value is referred to as the "Index Number" of the SR register in this document.
| 7  6      | 5  4                                   | 3  2        | 1  o  |
| --------- | -------------------------------------- | ----------- | ----- |
| R  R      | R                                      | SEOADDRESS  |       |
| Bits 4-0  | SEQ ADDRESS -Sequencer Register Index  |             |       |
A binary value indexing the register where data is to be accessed.
| Bits 7-5  | Reserved  |     |     |
| --------- | --------- | --- | --- |
14-4 VGA STANDARD REGISTER DESCRIPTIONS

Ij
S3 Trio32/Trio64 Integrated Graphics Accelerators
$
S3 Incorporated
Sequencer Data Register (SEQ_DATAl
| Read/Write  |     | Address: 3C5H  |
| ----------- | --- | -------------- |
Power-On Default: Undefined
This register is the data port for the sequencer register indexed by the Sequencer Index register (3C4H).
o
| 7  6  | 5  4  | 3  2  |
| ----- | ----- | ----- |
SEQ DATA
| Bit 7-0  | SEQ DATA -Sequencer Register Data  |     |
| -------- | ---------------------------------- | --- |
Data to the sequencer register indexed by the sequencer address index.
Reset Register (RST_SYNCI (SROI
| Read/Write  | . Address: 3C5H, Index OOH  |     |
| ----------- | --------------------------- | --- |
J
Power-On Default: OOH
| Bit 0  | ASY RST -Asynchronous Reset  |     |
| ------ | ---------------------------- | --- |
This bit is for VGA software compatibility only. It has no function for the Tri032/Tri064.
| Bit 1  | SYN RST -Synchronous Reset  |     |
| ------ | --------------------------- | --- |
This bit is for VGA software compatibility only. It has no function for the Tri032/Tri064.
| Bits 7-2  | Reserved = 0  |     |
| --------- | ------------- | --- |
VGA STANDARD REGISTER DESCRIPTIONS  14-5

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Clocking Mode Register (ClK_MODE) (SR1)
| Read/Write  |     | Address: 3C5H, Index 01H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register controls the operation mode of dot clock and character clock.
| 7  6    | 5  4                     | 3  2      | 1  0     |
| ------- | ------------------------ | --------- | -------- |
|         | SCRN  SHF                | DCK  SHF  |          |
| =0  =0  | OFF  4                   | 1/2  LD   | =0  8DC  |
| Bit 0   | BDC -B Dot Clock Select  |           |          |
o  = Character clocks 9 dots wide are generated
1 = Character clocks B dots wide are generated
| Bit 1  | Reserved = 0                                           |     |     |
| ------ | ------------------------------------------------------ | --- | --- |
| Bit 2  | SHF LD -Load Serializers Every Second Character Clock  |     |     |
o
= Load the video serializer every character clock
1 = Load the video serializers every other character clock
| Bit 3  | DCK 1/2 -Internal character clock = 1/2 DCLK  |     |     |
| ------ | --------------------------------------------- | --- | --- |
o  = Set the internal character clock to the same frequency as DCLK
1 = Set the internal character clock to 1/2 the frequency of DCLK
| Bit 4  | SHF 4 -Load Serializers Every Fourth Character Clock  |     |     |
| ------ | ----------------------------------------------------- | --- | --- |
o = Load the serializers every character clock cycle
1 = Load the serializers every fourth character clock cycle
| Bit 5  | SCRN OFF -Screen Off  |     |     |
| ------ | --------------------- | --- | --- |
o = Screen is turned on.
1 = Screen is turned off
Reserved = 0
Bit 7-6
Enable Write Plane Register (EN_WT _Pl) (SR2)
| Read/Write  |     | Address: 3C5H, Index 02H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register selects write protection or write permission for CPU write access into video memory.
o
|     |     | 3  2  | 1   |
| --- | --- | ----- | --- |
EN.WT.PL.
| Bits 3-0  | EN.WT.PL -Enable Write to a Plane  |     |     |
| --------- | ---------------------------------- | --- | --- |
o = Disables writing into the corresponding plane
1 = Enables the CPU to write to the corresponding color plane
14-6 VGA STANDARD REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Character Font Select Register (CH_FONT_SL) (SR3)
| ReadIWrite  |     | Address: 3C5H, Index 03H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
|         |           | I     | I     |
| ------- | --------- | ----- | ----- |
| 7  6    | 5  4      | 3  2  | 1  0  |
|         | SLA  SLB  | SLA   | SLB   |
| =0  =0  | 2  2      | 1  0  | 1  0  |
In text modes, bit 3 of the attribute byte normally turns the foreground intensity on or off. This bit can
be redefined to be a switch between two character sets. The switch is enabled when there is a difference
between the value of character font select A and character font select B bits. Memory Mode (SR4)
register bit 1 = 1 (extended memory) enables all bits of this function; otherwise character fonts 0 and
4 are available. 256 KBytes of video memory support 8 character sets. This register is reset to 0
asynchronously during a system reset.
| Bits 4, 1-0  | SLB -Select Font B  |     |     |
| ------------ | ------------------- | --- | --- |
This value selects the portion of plane 2 used to generate text character fonts when
bit 3 of the attribute byte is a logical 1, according to the following table:
|              | Bits  Font Table Location   |     | Bits  Font Table Location  |
| ------------ | --------------------------- | --- | -------------------------- |
|              | 4,1,0                       |     | 4,1,0                      |
|              | 000  First 8K of plane 2    |     | 100  Second 8K of plane 2  |
|              | 001  Third 8K of plane 2    |     | 101  Fourth 8K of plane 2  |
|              | 010  Fifth 8K of plane 2    |     | 110  Sixth 8K of plane 2   |
|              | 011  Seventh 8K of plane 2  |     | 111  Eighth 8K of plane 2  |
| Bits 5, 3-2  | SLA -Select Font A          |     |                            |
This value selects the portion of plane 2 used to generate text character fonts when
bit 3 of attribute byte is a logical 0, according to the same table as the character font
select A.
| Bits 7-6  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
VGA STANDARD REGISTER DESCRIPTIONS  14-7

r-~   .
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Memory Mode Control Register (MEM_MODE) (SR4)
| Read/Write  |     | Address: 3C5H, Index 04H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register controls CPU memory addressing mode.
| 7  6  | 5  4  | 3  2  | 1  0  |
| ----- | ----- | ----- | ----- |
|       |       | CHN   | EXT   |
SEQ
| =0  =0  | =0  =0                           | 4M  MODE  | MEM  =0  |
| ------- | -------------------------------- | --------- | -------- |
| Bit 0   | Reserved = 0                     |           |          |
| Bit 1   | EXT MEM -Extended Memory Access  |           |          |
0= Memory access restricted to 16/32 KBytes
1 = Allows complete memory access to 256 KBytes. Required for VGA
| Bit 2  | SEQ MODE -Sequential Addressing Mode  |     |     |
| ------ | ------------------------------------- | --- | --- |
This bit affects only CPU write data accesses into video memory. Bit 3 of this register
must be 0 for this bit to be effective.
0= Enables the odd/even addressing mode. Even addresses access planes 0 and 2.
Odd addresses access planes 1 and 3
1 = Directs the system to use a sequential addressing mode
| Bit 3  | CHN 4M -Select Chain 4 Mode  |     |     |
| ------ | ---------------------------- | --- | --- |
o  = Enables odd/even mode.
1 '" Chain 4 Mode. This bit selects modulo 4 addressing for CPU access to display
memory. A logical 1 directs the two lower order bits of the CPU address used to
select the plane in video memory to be accessed as follows:
|     | A1  AO  | Plane Selected  |     |
| --- | ------- | --------------- | --- |
|     | 0  0    | 0               |     |
|     | 0  1    | 1               |     |
|     | 1  0    | 2               |     |
|     | 1       | 3               |     |
1
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
14-8 VGA STANDARD REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Unlock Extended Sequencer Register (UNLK_EXSR) (SR8)
| Read/Write  |     | Address: 3CSH, Index 08H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
Loading xxxxOll0b (e.g., 06H) unlocks accessing of all the S3 extensions (SR9 -SR18) to the standard
VGA Sequencer register set. (x = don't care).
o
| 7   | 6  5  | 4  3   | 2  1    |     |
| --- | ----- | ------ | ------- | --- |
| R   | R  R  | R  =0  | =1  =1  | =0  |
Extended Sequencer Register 9 (SR9)
| Read/Write  |     | Address: 3CSH, Index 09H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
6
|     | I :  I :  | I :  I :  | I :  I :  | I   |
| --- | --------- | --------- | --------- | --- |
R
| Bits 6-0  | Reserved                                           |     |     |     |
| --------- | -------------------------------------------------- | --- | --- | --- |
| Bit 7     | MMIO-ONLY -Memory-mapped I/O register access only  |     |     |     |
o
= When MMIO is enabled, both programmed I/O and memory-mapped I/O register
accesses are allowed
1 =W
hen MMIO is enabled, only memory-mapped I/O register accesses are allowed
External Bus Request Control Register (SRA)
| Read/Write  |     | Address: 3CSH, Index OAH  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
| 7        | 6  5       | 4  I  3  I  | 2  I  1  I  | 0   |
| -------- | ---------- | ----------- | ----------- | --- |
| 2        | P50  PD-   | PVALUE      |             |     |
| MCLK     | SEL  NTRI  | 4  3        | 2  1        | 0   |
| Bits4-0  | PVALUE     |             |             |     |
The integer equivalent of the binary value in this field is the number of 2-MCLK units
a secondary memory controller is allowed to retain control of the memory bus before
the Tri032/Tri064 drops its bus grant. See Section 7.S for a detailed explanation.
| Bit S  | PD-NTRI -PD[63:0] not tri-stated (PD31 :0] for Tri032)  |     |     |     |
| ------ | ------------------------------------------------------- | --- | --- | --- |
o = PD[63:0] tri-stated
1 = PD[63:0] not tri-stated
VGA STANDARD REGISTER DESCRIPTIONS 14-9

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
The default value of 0 reduces power consumption. The pins are enabled for output
only as needed. Note that output pads for PD[63:24] also latch the most recent output
state.
| Bit 6  | P50 SEL -Pin 50 Function Select (Tri064 only)  |     |     |
| ------ | ---------------------------------------------- | --- | --- |
0= If bit 2 of CR36 is set to 1 to indicate fast page memory, pin 50 outputs a signal
equivalent to OEO
1 = If bit 2 of CR36 is set to 1 to indicate fast page memory, pin 50 outputs RAS1
This bit must be set to 1 for 4-MByte fast page mode memory configurations. This bit
has no function if bit 2 of CR36 is cleared to 0 to indicate EDO memory.
| Bit 7  | 2MCLK -2 MCLK CPU writes to memory  |     |     |
| ------ | ----------------------------------- | --- | --- |
o = 3 MCLK memory writes
1 = 2 MCLK memory writes
Setting this bit to 1 improves performance for systems using an MCLK less than 57
MHz. For MCLK frequencies between 55 and 57 MHz, bit 7 of SR15 should also be set
to 1 if linear addressing is being used.
Miscellaneous Extended Sequencer Register (SRB)
| Read/Write  |     | Address: 3C5H, Index OBH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| I                | I  I                            |         |               |
| ---------------- | ------------------------------- | ------- | ------------- |
| 7  6             | 5  4                            | 3       | 2  1  0       |
|                  |                                 | 24      | VAFC  DOT=    |
| AL T COLOR MODE  |                                 | BPP  R  | VCLKI  VCLKI  |
| Bit 0            | DOT = VCLKI -Dot clock = VCLKI  |         |               |
o
= Use internal dot clock
1 = Use VCLKI input for all internal dot clock functions
This bit is used for S3 test purposes only.
| Bit 1  | VAFC VCLKI-Use VCLKI input with VAFC  |     |     |
| ------ | ------------------------------------- | --- | --- |
o
= Pixel data from pass-through feature connector latched by incoming VCLK
1 = Pixel data from VAFC latched by VCLKI input
| Bit 2  | Reserved              |     |     |
| ------ | --------------------- | --- | --- |
| Bit 3  | 24 BPP (Tri032 only)  |     |     |
o  = 24 bits/pixel (Mode 12) disabled
1 = 24 bits/pixel (Mode 12) enabled
In addition, bits 7-4 of this register must be programmed to 0111 b and bits 7-4 of
CR67 must be programmed to OOOOb to enable 24 bits/pixel operation for the Tri032.
14-10 VGA STANDARD REGISTER DESCRIPTIONS

....
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Bits 7-4 ALT COLOR MODE -Color Mode for feature connector input
0000 = Mode 0: 8-bit color, 1 pixe!NCLK
0001 = Mode 8: 8-bit color, 2 pixelsNCLK
0011 = Mode 9: 15-bit color, 1 pixelNCLK
0101 = Mode 10: 16-bit color, 1 pixelNCLK
0111 = Mode 12: 640x480x24-bit color (packed), 1 pixel/3 DCLKs (Tri032 only)
1101 = Mode 13: 24-bit color, 1 pixelNCLK
All other mode values are reserved. Setting mode 0001 (clock doubled mode) also re
quires that either bit 4 or bit 6 of SR15 be set to 1 and that bit 7 of SR18 be set to 1.
Extended Sequencer Register (EX_SR_DI (SRDI
Read/Write Address: 3C5H, Index ODH
Power-On Default: OOH
This register provides feature connector control and also provides independent control of the
HSYNC and VSYNC signals, therefore supporting the VESA DPMS (Display Power Management Con
trol) standard.
I I
7 6 5 4 3 2 1 0
VSY-CTL HSY-CTL R R R EN-
1 0 1 0 FEAT
Bit 0 EN-FEAT -Enable Feature Connector
0= ENFEAT (pin 151) is high. VCLK, HSYNC and VSYNC are outputs. Pin 155
(BGi\if/BLANK) functions as BGNT.
1 = ENFEAT (pin 151) is low. Pin 155 (BGNT/BLANK) functions as BLANK. The
direction of VCLK is controlled by EVCLK and the direction of BLANK, HSYNC and
VSYNC is controlled by ESYNC. In both cases, assertion (low) specifies an input
and a logic high specifies an output.
This bit is set to 1 to drive pin 151 with a logic O. This enables the feature connector
buffers required when the Tri064 memory configuration is 2 MBytes or larger. It also
controls the ESYNC and EVCLK functions as explained above for both the Tri032 and
Tri064.
Bits 3-1 Reserved
Bits 5-4 HSY-CTL -HSYNC Control
00 = Normal operation
01 = HSYNC = 0
10 = HSYNC = 1
11 = Reserved
VGA STANDARD REGISTER DESCRIPTIONS 14-11

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
| Bits 7-6  | VSY-CTL -VSYNC Control  |     |     |
| --------- | ----------------------- | --- | --- |
00 = Normal operation
01 =VSYNC = 0
10 = VSYNC = 1
11 = Reserved
ClK Value low Register (UNlK_EXSR) (SR10)
| Read/Write  | Address: 3C5H, Index 10H  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: See description below.
The power-on default value for this register in conjunction with the power-on default value for SR1 1
generate an MCLK value of 45 MHz. All other MCLK values must be specified by programming of
SR10 and SR1 1. Loading of a new value is enabled by either bit 0 or bit 5 of SR15.
| Bits 4-0  | PLL N-DIVIDER VALUE  |     |     |
| --------- | -------------------- | --- | --- |
These bits contain the binary equivalent ofthe integer (1-31) divider used to scale the
input to the MCLK PLL. See Section 9 for a detailed explanation.
| Bits 6-5  | PLL R VALUE  |     |     |
| --------- | ------------ | --- | --- |
These bits contain the binary equivalent of the integer (1, 2, 4, 8) range value used to
scale the output of the MCLK PLL. See Section 9 for a detailed explanation.
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
MClK Value High Register (SR11)
| Read/Write  |     | Address: 3C5H, Index 11H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: See description below.
The power-on default value for this register in conjunction with the power-on default value for SR10
generate an MCLK value of 45 MHz. All other MCLK values must be specified by programming of
SR10 and SR11. Loading of a new value is enabled by either bit 0 or bit 5 of SR15.
| 7  6      | 5  4                 | 3  2  | 1  o  |
| --------- | -------------------- | ----- | ----- |
| R         | PLL M-DIVIDER VALUE  |       |       |
| Bits 6-0  | PLL M-DIVIDER VALUE  |       |       |
These bits contain the binary equivalent of the integer (1-127) divider used in the feed
back loop of the MCLK PLL. See Section 9 for a detailed explanation.
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
14-12 VGA STANDARD REGISTER DESCRIPTIONS

83 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
DCLK Value Low Register (SR12)
Read/Write Address: 3C5H, Index 12H
Power-On Default: See description below.
The power-on default value for this register in conjunction with the power-on default value for SR13
generate a DCLK value of 25.175 MHz. The default value is automatically placed in this register when
bits 3-2 of 3C2H are programmed to OOb. If bits 3-2 of CR2H are programmed to 01b, the appropriate
PLL Rand PLL N values for a 28.322 MHz DCLK will automatically be placed in this register. All other
DCLK values must be specified by programming of SR12 and SR13. Loading of a new value is enabled
by either bit 1 or bit 5 of SR 15 and by setting bits 3-2 of 3C2H to 11 b.
Bits 4-0 N-DIVIDER VALUE
These bits contain the binary equivalent of the integer (1-31) divider used to scale the
input to the DCLK PLL. See Section 9 for a detailed explanation.
Bits 6-5 PLL R VALUE
These bits contain the binary equivalent of the integer (1, 2, 4, 8) range value used to
scale the output of the DCLK PLL. See Section 9 for a detailed explanation.
Bit 7 Reserved
DCLK Value High Register (SR13)
Read/Write Address: 3C5H, Index 13H
Power-On Default: See description below.
The power-on default value for this register in conjunction with the power-on default value for SR12
generate a DCLK value of 25.175 MHz. The default value is automatically placed in this register
when bits 3-2 of 3C2H are programmed to OOb. If bits 3-2 of CR2H are programmed to 01b, the ap
propriate PLL M value for a 28.322 MHz DCLK will automatically be placed in this register. All other
DCLK values must be specified by programming of SR12 and SR13. Loading of a new value is en
abled by either bit 1 or bit 5 of SR15 and by setting bits 3-2 of 3C2H to 11b.
7 6 5 432 o
R PLL M-DIVIDER VALUE
Bits 6-0 PLL M-DIVIDER VALUE
These bits contain the binary equivalent of the integer (1-127) divider used in the feed
back loop of the DCLK PLL. See Section 9 for a detailed explanation.
Bit 7 Reserved
VGA STANDARD REGISTER DESCRIPTIONS 14-13

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
CLKSVN Control 1 Register (SR14)
| Read/Write  |     | Address: 3C5H, Index 14H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6        | 5  4                          | 3  2       | 1  0        |
| ----------- | ----------------------------- | ---------- | ----------- |
| EXT  EXT    | P146  CLR                     | M  EN      | MPLL  DPLL  |
| DCLK  MCLK  | SEL  CNT                      | TEST  CNT  | PD  PD      |
| Bit 0       | DPLL PD -Power down DCLK PLL  |            |             |
o
= DCLK PLL powered
1 = DCLK PLL powered down
This bit is used for S3 test purposes only.
| Bit 1  | MPLL PD -Power down MCLK PLL  |     |     |
| ------ | ----------------------------- | --- | --- |
o = MCLK PLL powered
1 = MCLK PLL powered down
This bit is used for S3 test purposes only.
| Bit 2  | EN CNT -Enable clock synthesizer counters  |     |     |
| ------ | ------------------------------------------ | --- | --- |
o  = Clock synthesizer counters disabled
1 = Clock synthesizer counters enabled
This bit is used for S3 test purposes only.
| Bit 3  | M TEST -MCLK Test  |     |     |
| ------ | ------------------ | --- | --- |
0= Test DCLK
1 = Test MCLK
This bit is used for S3 test purposes only.
| Bit 4  | CLR CNT -Clear clock synthesizer counters  |     |     |
| ------ | ------------------------------------------ | --- | --- |
0= No effect
1 = Clear the clock synthesizer counters
This bit is used for S3 test purposes only.
| Bit 5  | P146 SEL -Pin 146 function select  |     |     |
| ------ | ---------------------------------- | --- | --- |
o
= Pin 146 functions as STRD
1 = Pin 146 is tri-stated
Setting this bit to 1 allows pin 146 to act as an input. This is enabled by setting bit 6
of this register to 1.
| Bit 6  | EXT MCLK -External MCLK Select  |     |     |
| ------ | ------------------------------- | --- | --- |
o = MCLK provided by internal PLL
1 = MCLK is input on pin 146
An external MCLK is only used for S3 test purposes.
14-14 VGA STANDARD REGISTER DESCRIPTIONS

53 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad
| Bit 7  | EXT DCLK -External DCLK Select  |     |     |
| ------ | ------------------------------- | --- | --- |
o  = DCLK provided by internal PLL
1 = DCLK is input on pin 156. PD11 must also be strapped low on power-on reset.
An external DCLK is only used for S3 test purposes.
CLKSYN Control 2 Register (SR15)
| Read/Write  |     | Address: 3C5H, Index 15H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6         | 5  4                                     | 3  2        | 1  0        |
| ------------ | ---------------------------------------- | ----------- | ----------- |
| 2CYC  DCLK\  | CLK  DCLK/                               | VCLK  MCLK  | DRFO  MFRO  |
| MWR  INV     | LOAD  2                                  | OUT  OUT    | EN  EN      |
| Bit 0        | MFRO EN -Enable new MCLK frequency load  |             |             |
o  = Register bit clear
1 = Load new MCLK frequency
When new MCLK PLL values are programmed, this bit can be set to 1 to load these
values in the PLL. The loading may be delayed a small but variable amount of time.
This bit should be cleared to 0 after loading to prevent repeated loading. Alternately,
use bit 5 of this register to produce an immediate load.
| Bit 1  | DFRQ EN -Enable new DCLK frequency load  |     |     |
| ------ | ---------------------------------------- | --- | --- |
o
= Register bit clear
1 = Load new DCLK frequency
When new DCLK PLL values are programmed, this bit can be set to 1 to load these
values in the PLL. Bits 3-2 of 3C2H must also be set to 11 b if they are not already at
this value. The loading may be delayed a small but variable amount of time. This bit
should be programmed to 1 at power-up to allow loading of the VGA DCLK value and
then left at this setting. Use bit 5 of this register to produce an immediate load.
| Bit 2  | MCLK OUT -Output internally generated MCLK  |     |     |
| ------ | ------------------------------------------- | --- | --- |
0= Pin 147 acts as the STWR strobe
1 = Pin 147 outputs the internally generated MCLK
This is used only for testing.
| Bit 3  | VCLK OUT -VCLK direction determined by EVCLK  |     |     |
| ------ | --------------------------------------------- | --- | --- |
0= Pin 148 outputs the internally generated VCLK regardless of the state of EVCLK
1 = VCLK direction is determined by the EVCLK signal
VGA STANDARD REGISTER DESCRIPTIONS 14-15

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Bit 4 DCLK/2 -Divide DCLK by 2
o
= DCLK unchanged
1 = Divide DCLK by 2
Either this bit or bit 6 of this register must be set to 1 for clock doubled RAMDAC op
eration (mode 0001).
Bit 5 CLK LOAD -MCLK, DCLK load
o
= Clock loading is controlled by bits 0 and 1 of this register
1 = Load MCLK and DCLK PLL values immediately
To produce an immediate MCLK and DCLK load, program this bit to 1 and then to O.
Bits 3-2 of 3C2H must also then be programmed to 11 b to load the DCLK values if
they are not already programmed to this value. This register must never be left set to
1.
Bit 6 DCLK INV -Invert DCLK
0= DCLK unchanged
1 = Invert DCLK
Either this bit or bit 4 of this register must be set to 1 for clock doubled RAMDAC op
eration (mode 0001).
Bit 7 2 CYC MWR -Enable 2 cycle memory write
o
= 3 MCLK memory write
1 = 2 MCLK memory write
Setting this bit to 1 bypasses the VGA logic for linear addressing when bit 7 of SRA is
set to 1. This can allow 2 MCLK operation for MCLK frequencies between 55 and 57
MHz.
CLKSVN Test High Register (SR16)
ReadIWrite Address: 3C5H, Index 16H
Power-On Default: OOH
This register is reserved for S3 testing of the internal clock synthesizer.
7 6 5 4 3 2 1 o
R R R R R R R R
14-16 VGA STANDARD REGISTER DESCRIPTIONS

II·
53 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
CLKSVN Test Low Register (SR17)
Read Only Address: 3C5H, Index 17H
Power-On Default: OOH
This register is reserved for S3 testing of the internal clock synthesizer.
7 6 5 4 3 2 o
R R R R R R R R
RAMDAC/CLKSVN Control Register (SR18)
Read/Write Address: 3C5H, Index 18H
Power-On Default: OOH
7 6 5 4 3 2 1 0
CLKx LUT DAC TST TST TST TST TST
2 WR PD BLUE GRN RED RST EN
Bit 0 TST EN -Enable test counter
o = RAMDAC test counter disabled
1 = RAMDAC test counter enabled
This bit is used for S3 test purposes only.
Bit 1 TST RST -Reset test counter
0= No effect
1 = Reset the RAMDAC test counter
This bit is used for S3 test purposes only.
Bit 2 TST RED -Test red data
0= No effect
1 = Place red data on internal data bus
This bit is used for S3 test purposes only.
Bit 3 TST GRN -Test green data
0= No effect
1 = Place green data on internal data bus
This bit is used for S3 test purposes only.
Bit 4 TST BLUE -Test blue data
0= No effect
1 = Place blue data on internal data bus
This bit is used for S3 test purposes only.
VGA STANDARD REGISTER DESCRIPTIONS 14-17

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Bit 5 DAC PO -RAMDAC power-down
o = RAMDAC powered
1 = RAMDAC powered-down
When the RAMDAC is powered down, the RAMDAC memory retains its data.
Bit 6 LUT WR -LUT write cycle control
o = 2 DCLK LUT write cycle (default)
1 = 1 DCLK LUT write cycle
Bit 7 CLKx2 -Enable clock doubled mode
0= RAMDAC clock doubled mode (0001) disabled
1 = RAMDAC clock doubled mode (0001) enabled
This bit must be set to 1 when mode 0001 is specified in bits 7-4 of CR67 or SRC.
Either bit 4 or bit 6 of SR 15 must also be set to 1.
14-18 VGA STANDARD REGISTER DESCRIPTIONS

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
14.3 CRT CONTROLLER REGISTERS
The CRT controller registers are located at two locations in I/O address space. These registers are
accessed by first writing to the index register of the CRT controller and then accessing the data register.
The index register is located at I/O address 3?4H and the CRT Controller Data register is at 3?5H. Which
address is used (3BX or 3DX) depends on bit 0 of the Miscellaneous Output register at 3C2H.
CRT Controller Index Register (CRTC_ADR) (CRX)
| Read/Write  |     | Address: 3?4H  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: OOH
This register is loaded with a binary value that indexes the CRT controller register where data is to be
accessed. This value is referred to as the "Index Number" of the CR register (CROO-18). This register
is also used as an indexto the S3 VGA registers, the System Control Registers and the System Extension
registers.
| 7  6  | 543  | 2  1  | o   |
| ----- | ---- | ----- | --- |
CRTC ADDRESS
| Bits 7-0  | CRTC ADDRESS -CRTC Register Index  |     |     |
| --------- | ---------------------------------- | --- | --- |
A binary value indexing the register where data is to be accessed.
CRT Controller Data Register (CRTC_DATA) (CRT)
| Read/Write  |     | Address: 3?5H  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is the data port for the CRT controller register indexed by the CRT Controller Address
register.
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
CRTC DATA
| Bits 7-0  | CRTC DATA -CRTC Register Data  |     |     |
| --------- | ------------------------------ | --- | --- |
Data to the CRT controller register indexed by the CRT controller address index.
VGA STANDARD REGISTER DESCRIPTIONS 14-19

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Horizontal Total Register (H_TOTAL) (CRO)
| Read/Write  |     | Address: 3?5H, Index OOH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register defines the number of character clocks from HSYNC going active to the next HSYNC going
active. In other words, it is the total time required for both the displayed and non-displayed portions
of a singe scan line. Bit 8 of this value is bit 0 of CR5D.
| 7  6  | 543  | 2   | 1  o  |
| ----- | ---- | --- | ----- |
HORIZONTAL TOTAL
HORIZONTAL TOTAL.
Bits 7-0
9-bit Value = (number of character clocks in one scan line) -5. This register contains
the least significant 8 bits of this value.
Horizontal Display End Register (H_D_END) (CR1)
| Read/Write  |     | Address: 3?5H, Index 01H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register defines the number of character clocks for one line ofthe active display. Bit 8 ofthis value
is bit 1 of CR5D.
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
HORIZONTAL DISPLAY END
| Bits 7-0  | HORIZONTAL DISPLAY END  |     |     |
| --------- | ----------------------- | --- | --- |
9-bit Value = (number of character clocks of active display) -1. This register contains
the least significant 8 bits of this value.
14-20 VGA STANDARD REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Start Horizontal Blank Register (S_H_BLNK) (CR2)
| Read/Write  |     | Address: 3?5H. Index 02H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the value of the character clock counter at which the BLANK signal is asserted.
Bit 8 of this value is bit 2 of CR5D.
o
| 7   | 6  5  | 4  3  | 2  1  |
| --- | ----- | ----- | ----- |
START HORIZONTAL BLANK
| Bits 7-0  | START HORIZONTAL BLANK  |     |     |
| --------- | ----------------------- | --- | --- |
9-bit Value = character clock value at which horizontal blanking begins. This register
contains the least significant 8 bits ofthis value.
End Horizontal Blank Register (E_H_BLNK) (CR3)
| Read/Write  |     | Address: 3?5H. Index 03H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register determines the pulse width of the BLANK signal and the display enable skew.
|     | I     | I  I  | I  I     |
| --- | ----- | ----- | -------- |
| 7   | 6  5  | 4  3  | 2  1  0  |
DSP-SKW
| R        | 1  0                  | END HORIZONTAL BLANK  |     |
| -------- | --------------------- | --------------------- | --- |
| Bits4-0  | END HORIZONTAL BLANK  |                       |     |
6-bit Value =  least significant 6 bits of the character clock counter value at which time
horizontal blanking ends. To obtain this value. add the desired BLANK pulse width in
character clocks to the Start Horizontal Blank value. which is also in character clocks.
The 5 least significant bits of this sum are programmed into this field. The sixth bit is
programmed into bit 7 of CR5. This allows a maximum pulse width of 63 character
clocks. This pulse width can be extended by 64 DCLKs via bit 3 of CR5D.
Bits 6-5
DSP-SKW -Display Skew
These two bits determine the amount of display enable skew. Display enable skew
control provides sufficient time for the CRT Controller to access the display buffer to
obtain a character and attribute code. access the character generator font. and then
go through the Horizontal Pixel Panning register in the Attribute Controller. Each ac
cess requires the display enable signal to be skewed one character clock unit so the
video output is synchronous with the HSYNC and VSYNC Signals. The bit values and
amount of skew are shown in the following table:
00 = Zero character clock skew
01 = One character clock skew
10 = Two character clock skew
11 = Three character clock skew
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
VGA STANDARD REGISTER DESCRIPTIONS 14-21

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Start Horizontal Sync Position Register (S_H_SY _PI (CR4)
Read/Write Address: 3?5H, Index 04H
Power-On Default: Undefined
This register is used to adjust the screen center horizontally and to specify the character position at
which HSYNC becomes active. Bit 8 of this val ue is bit 4 of CR5D.
Bits 7-0 START HORIZONTAL SYNC POSITION.
9-bit Value = character clock counter value at which HSYNC becomes active. This reg
ister contains the least significant 8 bits of this value.
End Horizontal Sync Position Register (E_H_SY _PI (CR5)
Read/Write Address: 3?5H, Index 05H
Power-On Default: Undefined
This register specifies when the HSYNC signal becomes inactive and the horizontal skew. The HSYNC
pulse defined by this register can be extended by 32 DCLKs via bit 5 of CR5D.
7 6 I 5 4 I 3 I 2 I 1 I 0
EHB HOR-SKW
b5 1 0 END HORIZONTAL SYNC POS
Bits 4-0 END HORIZONTAL SYNC POS
5-bit Value = 5 least significant bits of the character clock counter value at which time
HSYNC becomes inactive. To obtain this value, add the desired HSYNC pulse width in
character clocks to the Start Horizontal Sync Position value, also in character clocks.
The 5 least significant bits of this sum are programmed into this field. This allows a
maximum HSYNC pulse width of 31 character clocks. This pulse width can be ex
tended by 32 DCLKs via bit 5 of CR5D.
Bits 6-5 HOR-SKW -Horizontal Skew
These bits control the skew ofthe HSYNC signal. A binary 00 equals no HSYNC delay.
For some modes, it is necessary to provide an HSYNC signal that takes up the entire
blanking interval. Some internal timings are generated by the falling edge of the
HSYNC signal. To guarantee the signals are latched properly, HSYNC is asserted be
fore the end of the display enable signal, and then skewed several character clock
times to provide the proper screen centering.
00 = Zero character clock skew
01 = One character clock skew
10 = Two character clock skew
11 =T hree character clock skew
14-22 VGA STANDARD REGISTER DESCRIPTIONS

53 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
| Bit 7  | EHB bS  |     |     |
| ------ | ------- | --- | --- |
End Horizontal Blanking bit S.
Vertical Total Register (V_TOTAL) (CR6)
| Read/Write  |     | Address: 3?SH, Index 06H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the number of scan lines from one VSYNC active to the next VSYNC active.
The scan line counter resets to 0 at this point. Bit 8 is bit 0 of CR7. Bit 9 is bit S of CR7. Bit 10 is bit 0
of CRSE.
o
| 7  6  | S  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
VERTICAL TOTAL
| Bits 7-0  | VERTICAL TOTAL  |     |     |
| --------- | --------------- | --- | --- |
11-bit Value = (number of scan lines from VSYNC active to the next VSYNC active) -2.
This register contains the least significant 8 bits of this value.
CRTC Overflow Register (OVFL_REG) (CR7)
| Read/Write  |     | Address: 3?SH, Index 07H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6      | 5  4     | 3  2      | 1  0     |
| --------- | -------- | --------- | -------- |
| VRS  VDE  | VT  LCM  | SVB  VRS  | VDE  VT  |
| 9  9      | 9  8     | 8  8      | 8  8     |
This register provides extension bits for fields in other registers.
| Bit 0  | Bit 8 of the Vertical Total register (CRB)           |     |     |
| ------ | ---------------------------------------------------- | --- | --- |
| Bit 1  | Bit 8 of the Vertical Display End register (CR12)    |     |     |
| Bit 2  | Bit 8 of the Vertical Retrace Start register (CR10)  |     |     |
| Bit 3  | Bit 8 of the Start Vertical Blank register (CR15)    |     |     |
| Bit 4  | Bit 8 of the Line Compare register (CR18)            |     |     |
| Bit 5  | Bit 9 of the Vertical Total register (CRB)           |     |     |
| Bit 6  | Bit 9 of the Vertical Display End register (CR12)    |     |     |
| Bit 7  | Bit 9 of the Vertical Retrace Start register (CR10)  |     |     |
VGA STANDARD REGISTER DESCRIPTIONS  14-23

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Preset Row Scan Register (P_ R_SCAN) (CR8)
| ReadNVrite  |     | Address: 3?5H, Index 08H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register is used for the pixel scrolling and panning, and text formatting and vertical scrolling.
|     | I     | I  I  | I  I     |
| --- | ----- | ----- | -------- |
| 7   | 6  5  | 4  3  | 2  1  0  |
BYTE-PAN
| =0        | 1  0                    | PRE-SET ROW SCAN COUNT  |     |
| --------- | ----------------------- | ----------------------- | --- |
| Bits 4-0  | PRE-SET ROW SCAN COUNT  |                         |     |
Value = starting row within a character cell for the first character row displayed after
vertical retrace. This allows a partial character row to be displayed at the top of the
display and is used for scrolling.
| Bits 6-5  | BYTE-PAN  |     |     |
| --------- | --------- | --- | --- |
Value = number of bytes to pan. The number of pixels to pan is specified in AR13.
| Bit 7  | Reserved = 0  |     |     |
| ------ | ------------- | --- | --- |
Maximum Scan Line Register (MAX_S_LN) (eR9)
| ReadNVrite  |     | Address: 3?5H, Index 09H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the number of scan lines per character row and provides one scanning control
bit and two overflow bits.
|           |                | I  I           | I  I  |
| --------- | -------------- | -------------- | ----- |
| 7  6      | 5  4           | 3  2           | 1  0  |
| DBl  lCM  | SVB            |                |       |
| SCN  9    | 9              | MAX SCAN LINE  |       |
| Bits 4-0  | MAX SCAN LINE  |                |       |
Value = (number of scan lines per character row) -1
| Bit5  | SVB 9  |     |     |
| ----- | ------ | --- | --- |
Bit 9 of the Start Vertical Blank Register (CR15)
| Bit6  | lCM 9  |     |     |
| ----- | ------ | --- | --- |
Bit 9 of the Line Compare Register (CR18)
| Bit7  | DBl SCN  |     |     |
| ----- | -------- | --- | --- |
o
= Normal operation
1 = Enables double scanning operation. Each line is displayed twice by repeating the
row scan counter and video memory address. Vertical parameters in the CRT
controller are not affected.
14-24 VGA STANDARD REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Cursor Start Scan Line Register (CSSl) (CRA)
| Read/Write  |     | Address: 3?5H, Index OAH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
The cursor start register defines the row scan of a character line where the cursor begins.
| 7  6  | 5  4  | I  3  I  2  | I  1  I  0  |
| ----- | ----- | ----------- | ----------- |
CSR
| =0  =0     | OFF  CSR CURSOR START SCAN LINE  |     |     |
| ---------- | -------------------------------- | --- | --- |
| Bits 4-{)  | CSR CURSOR START SCAN LINE       |     |     |
Value = (starting cursor row within the character celll-1. When the cursor start regis
ter is programmed with a value greater than the cursor end register, no cursor is gen
erated.
| Bit5  | CSR OFF  |     |     |
| ----- | -------- | --- | --- |
o = Turns on the text cursor
1 = Turns off the text cursor
| Bits 7-6  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Cursor End Scan Line Register (CESL) (CRB)
| Read/Write  |     | Address: 3?5H, Index OBH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register defines the row scan of a character line where the cursor ends.
| 7  6  | I  5  4  | I  3  I  2  | I  1  I  0  |
| ----- | -------- | ----------- | ----------- |
CSR-SKW
| =0  1      | 0                     | CURSOR END SCAN LINE  |     |
| ---------- | --------------------- | --------------------- | --- |
| Bits 4-{)  | CURSOR END SCAN LINE  |                       |     |
Value = ending scan line number within the character cell for the text cursor. If the
value of the cursor start scan line is greater than the value of cursor end line, then no
cursor is generated.
| Bits 6-5  | CSR-SKW -Cursor Skew  |     |     |
| --------- | --------------------- | --- | --- |
These bits control the delay skew of the cursor signal. Cursor skew delays the text cur
sor by the selected number of clocks. For example, a skew of 1 moves the cursor
right one character position on the screen.
00 = Zero character clock skew
01 = One character clock skew
10 = Two character clock skew
11 = Three character clock skew
| Bit 7  | Reserved = 0  |     |     |
| ------ | ------------- | --- | --- |
VGA STANDARD REGISTER DESCRIPTIONS  14-25

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Start Address High Register (STA(H)) (CRC)
| Read/Write  |     | Address: 375H, Index OCH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
20-bit Value = the first address after a vertical retrace at which the display on the screen begins on each
screen refresh. These along with bits 3-0 of CR69 are the high order start address bits.
Start Address Low Register (STA(L)) (CRD)
| Read/Write  |     | Address: 375H, Index ODH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
o
| 7  6  | 5  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
DISPLAY START ADDRESS (LOW)
Start address (low) contains the 8 low order bits of the address.
Cursor Location Address High Register (CLA(H)) (CRE)
| Read/Write  |     | Address: 375H, Index OEH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
20-bit Value = the cursor location address of the video memory where the text cursor is active. This
register along with bits 3-0 of CR69 are the high order bits of the address.
| Cursor Location Address Low Register (CLA(l)  |     |                           | (CRF)  |
| --------------------------------------------- | --- | ------------------------- | ------ |
| Read/Write                                    |     | Address: 3?5H, Index OFH  |        |
Power-On Default: Undefined
Cursor location address (low) contains the 8 low order bits of the address.
14-26 VGA STANDARD REGISTER DESCRIPTIONS

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Vertical Retrace Start Register (VRS) (CR10)
| Read/Write  |     | Address: 3?5H, Index 10H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
o
| 7  6  | 543  | 2   | 1   |
| ----- | ---- | --- | --- |
VERTICAL RETRACE START
| Bits 7-0  | VERTICAL RETRACE START.  |     |     |
| --------- | ------------------------ | --- | --- |
ll-bit Value = number of scan lines at which VSYNC becomes active. These are the
low-order 8 bits. Bit 8 is bit 2 of CR7. Bit 9 is bit 7 of CR7. Bit 10 is bit 4 of CR5E.
Vertical Retrace End Register (VRE) (CR11)
| Read/Write  |     | Address: 3?5H, Index 11 H  |     |
| ----------- | --- | -------------------------- | --- |
Power-On Default: OxH
This register controls the vertical interrupt and CRO-7
|            |                       | I                     | I  I  |
| ---------- | --------------------- | --------------------- | ----- |
| 7  6       | 5  4                  | 3  2                  | 1  0  |
| LOCK  REF  | DIS  CLR              |                       |       |
| RO-7  3/5  | VINT  VINT            | VERTICAL RETRACE END  |       |
| Bits 3-0   | VERTICAL RETRACE END  |                       |       |
Value = least significant 4 bits of the scan line counter value at which VSYNC goes in
active. To obtain this value, add the desired VSYNC pulse width in scan line units to
the CR10 value, also in scan line units. The 4 least significant bits of this sum are pro
grammed into this field. This allows a maximum VSYNC pulse width of 15 scan line
units.
| Bit 4  | CLR VINT -Clear Vertical Retrace Interrupt  |     |     |
| ------ | ------------------------------------------- | --- | --- |
o = Vertical retrace interrupt cleared
1 = The flip-flop is able to catch the next interrupt request
At the end of active vertical display time, a flip-flop is set for a vertical interrupt. The
output of this flip-flop goes to the system interrupt controller. The CPU has to reset
this flip-flop by writing a logical 0 to this bit while in the interrupt process, then set
the bit to 1 to allow the flip-flop to catch the next interrupt request. Do not change the
other bits in this register. This bit is cleared to 0 by the BIOS during a mode set, a re
set, or power-on.
| Bit 5  | DIS VINT -Disable Vertical Interrupt  |     |     |
| ------ | ------------------------------------- | --- | --- |
0= Vertical retrace interrupt enabled
1 = Vertical interrupt disabled. This bit is cleared to 0 by the BIOS during a mode set,
a reset, or power-on
VGA STANDARD REGISTER DESCRIPTIONS  14-27

JJa
p• -
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
| Bit 6  | REF 3/5 -Refresh Cycle Select  |     |     |
| ------ | ------------------------------ | --- | --- |
o =T hree DRAM refresh cycles generated per horizontal line
1 = Five DRAM refresh cycles generated per horizontal line. Selecting five refresh
cycles allows use of the VGA chip with slow sweep rate displays (15.75 KHz).
This bit is cleared to 0 by the BIOS during a mode set, a reset, or power-on. This
setting can be overridden via bits 1-0 of CR3A
| Bit 7  | LOCK RO-7 -Lock Writes to CRT Controller Registers  |     |     |
| ------ | --------------------------------------------------- | --- | --- |
o = Writing to all CRT Controller registers enabled
1 = Writing to all bits of the CRT Controller registers CRO-CR7 except bit 4 of CR7
(LCM8) disabled. This bit is set to 1 by the BIOS during a mode set, a reset or
power-on
Vertical Display End Register (VDE) (CR12)
| Read/Write  |     | Address: 375H, Index 12H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
The vertical display enable end register "defines 8 bits of the 10-bit address of the scan line where the
display on the screen ends. Bit 8 and Bit 9 are bits 1 and 6 of CR7. Bit 10 is bit 1 of CR5E.
o
| 7  6  | 5  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
VERTICAL DISPLAY END
| Bit 7-0  | VERTICAL DISPLAY END  |     |     |
| -------- | --------------------- | --- | --- |
1 1-bit Value = (number of scan lines of active display) -1. This register contains the
least significant 8 bits of this value.
Offset Register (SCREEN-OFFSET) (CR13)
| Read/Write  |     | Address: 3?5H, Index 13H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the logical line width ofthe screen and is sometimes called the screen pitch. The
starting memory address for the next display row is larger than the current row by two, four or eight
times this amount. Bits 5-4 of CR51 are extension bits 9~8 of this register. If these bits are OOb, bit 2 of
CR43 is extension bit 8 of this register.
| 7  6  | 543  | 2   | 1  o  |
| ----- | ---- | --- | ----- |
LOGICAL SCREEN WIDTH
| Bits 7-0  | LOGICAL SCREEN WIDTH  |     |     |
| --------- | --------------------- | --- | --- |
10-bit Value = quantity that is multiplied by 2 (word mode), 4 (doubleword mode) or 8
(quadword mode) to specify the difference between the starting byte addresses of
two consecutive scan lines. This register contains the least significant 8 bits of this
14-28 VGA STANDARD REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 'ncorporatad
value. The addressing mode is specified by bit 6 of CR14 and bit 3 of CR17. Setting bit
3 of CR31 to 1 forces doubleword mode.
Underline Location Register (ULL) (CR14)
| ReadtWrite  |     | Address: 3?5H, Index 14H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the horizontal row scan position of underline and display buffer addressing
modes.
|           |                      | I  I                 | I  I  |
| --------- | -------------------- | -------------------- | ----- |
| 7  6      | 5  4                 | 3  2                 | 1  0  |
| DBWD      | CNT                  |                      |       |
| =0  MODE  | BY4                  | UNDER LINE LOCATION  |       |
| Bits 4-0  | UNDER LINE LOCATION  |                      |       |
5-bit Value = (scan line count of a character rowan which an underline occurs) -1
| Bit 5  | CNT BY4 -Select Count by 4 Mode  |     |     |
| ------ | -------------------------------- | --- | --- |
0= The memory address counter depends on bit 3 of CR17 (count by 2)
1 = The memory address counter is incremented every four character clocks
The CNT BY4 bit is used when double word addresses are used.
| Bit 6  | DBLWD MODE -Select Doubleword Mode  |     |     |
| ------ | ----------------------------------- | --- | --- |
o
= The memory addresses are byte or word addresses
1 = The memory addresses are doubleword addresses
| Bit 7  | Reserved = 0  |     |     |
| ------ | ------------- | --- | --- |
Start Vertical Blank Register (SVB) (CR15)
| ReadtWrite  |     | Address: 375H, Index 15H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the scan line at which the vertical blanking period begins. Bit 8 is bit 3 of CR7.
Bit 9 is bit 5 of CR9. Bit 10 is bit 2 of CR5E.
o
| 7  6  | 543  | 2   |     |
| ----- | ---- | --- | --- |
START VERTICAL BLANK
| Bits 7-0  | START VERTICAL BLANK.  |     |     |
| --------- | ---------------------- | --- | --- |
11-bit value = (scan line count at which BLANK becomes active) -1. This register con
tains the least significant 8 bits of this value.
VGA STANDARD REGISTER DESCRIPTIONS 14-29

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
End Vertical Blank Register (EVB) (CR16)
| Read/Write  |     | Address: 375H. Index 16H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: Undefined
This register specifies the scan line count value when the vertical blank period ends.
| 7  6  | 543  |     | 2   | 1  o  |
| ----- | ---- | --- | --- | ----- |
END VERTICAL BLANK
| Bits 7-0  | END VERTICAL BLANK  |     |     |     |
| --------- | ------------------- | --- | --- | --- |
Value = least significant 8 bits of the scan line counter value at which vertical blank
ing ends. To obtain this value. add the desired width of the vertical blanking pulse in
scan lines to [(value in the Start Vertical Blank registerl-11. also in scan lines. The 8
least significant bits of this sum are programmed into this field. This allows a maxi
mum vertical blanking pulse of 63 scan line units.
CRTC Mode Control Register (CRT _MO) (CR17)
| Read/Write  |     | Address: 3?5H. Index 17H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
This register is a multifunction control register. with each bit defining a different specification.
| 7  6       | 5                                              | 4  3  | 2   | 1  0      |
| ---------- | ---------------------------------------------- | ----- | --- | --------- |
| BYTE       | ADW                                            | WRD   | VT  | 4BK  2BK  |
| RST  MODE  | 16K  =0                                        | MODE  | X2  | HGC  CGA  |
| Bit 0      | 2BK CGA -Select Bank 2 Mode for CGA Emulation  |       |     |           |
0= Row scan counter bit 0 is substituted for memory address bit 13 during active
display time
1 = Memory address bit 13 appears on the memory address output bit 13 signal of
the CRT controller
This bit allows memory mapping compatibility with the IBM CGA graphics mode.
| Bit 1  | 4BK HGC -Select Bank 4 Mode for HGA Emulation  |     |     |     |
| ------ | ---------------------------------------------- | --- | --- | --- |
o
= Row scan counter bit 1 is substituted for memory address bit 14 during active
display time
1 = Memory address bit 14 appears on the memory address output bit 14 signal of
the CRT controller
The combination of this bit and bit 0 of this register allows compatibility with Hercu
les HGC graphics memory mapping.
| Bit 2  | VT X2 -Select Vertical Total Double Mode  |     |     |     |
| ------ | ----------------------------------------- | --- | --- | --- |
o = Horizontal retrace clock selected
1 = Horizontal retrace clock divided by two selected
14-30 VGA STANDARD REGISTER DESCRIPTIONS

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
83 Incorporatad
This bit selects horizontal retrace clock or horizontal retrace clock divided by two as
the clock that controls the vertical timing counter. If the vertical retrace counter is
clocked with the horizontal retrace clock divided by 2, then the vertical resolution is
double.
Bit3 CNT BY2 -Select Word Mode
o
= Memory address counter is clocked with the character clock input, and byte mode
addressing for the video memory is selected
1 = Memory address counter is clocked by the character clock input divided by 2, and
word mode addressing for the video memory is selected
Bit 4 Reserved = 0
Bit 5 ADW 16K -Address Wrap
o
= When word mode is selected by bit 6 of this register, memory address counter bit
13 appears on the memory address output bit 0 signal of the CRT controller and
the video memory address wraps around at 16 KBytes
1 = When word mode is selected by bit 6 of this register, memory address counter bit
15 appears on the memory address output bit 0 signal of the CRT controller
This bit is useful in implementing IBM CGA mode.
Bit 6 BYTE MODE -Select Byte Addressing Mode
o = Word mode shifts all memory address counter bits down one bit, and the most
significant bit of the counter appears on the least significant bit of the memory
address output
1 = Byte address mode
Bit 7 RST -Hardware Reset
0= Vertical and horizontal retrace pulses always inactive
1 = Vertical and horizontal retrace pulses enabled
This bit does not reset any other registers or outputs.
VGA STANDARD REGISTER DESCRIPTIONS 14-31

,I.
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Line Compare Register (LCM) (CR18)
| Read/Write  |     | Address: 375H, Index 18H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register is used to implement a split screen function. When the scan line counter value is equal
to the content of this register, the memory address counter is cleared to O. The linear address counter
then sequentially addresses the display buffer starting at address O. Each subsequent row address is
determined by the addition of the Offset (CR13) register content. Bit 8 is bit 4 of CR7. Bit 9 is bit 6 of
CR9. Bit 10 is bit 6 of CR5E.
o
| 7  6  | 5  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
LINE COMPARE POSITION
| Bit 7-0  | LINE COMPARE POSITION  |     |     |
| -------- | ---------------------- | --- | --- |
11-bit Value = number of scan lines at which the screen is split into screen A and
screen B. This register contains the least significant 8 bits of this value.
CPU Latch Data Register (GCCL) (CR22)
| Read Only  |     | Address: 3?5H, Index 22H  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register is used to read the CPU latch in the Graphics Controller.
| Bits 7-0  | GRAPHICS CONTROLLER CPU LATCH -N  |     |     |
| --------- | --------------------------------- | --- | --- |
Bits 1-0 of GR4 select the latch number N (3-0) of the CPU Latch.
14-32 VGA STANDARD REGISTER DESCRIPTIONS

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Attribute Index Register IATC_FIII ICR24)
Read Only Address: 3?5H, Index 24H, 26H
Power-On Default: Undefined
This register is used to read the value of the Attribute Controller Index register and its associated
internal address flip-flop (AFF). It can be read at either index 24H or 26H.
Bits 4-0 ATTRIBUTE CONTROLLER INDEX
This value is the Attribute Controller Index Data at I/O port 3COH.
Bit 5 ENV-Enable Video Display
This is the setting of bit 5 of 3COH, indicating video display enabled status
11 = enabled).
Bit 6 Reserved = 0
Bit 7 AFF
Inverted Internal Address flip-flop
VGA STANDARD REGISTER DESCRIPTIONS 14-33

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
14.4 GRAPHICS CONTROLLER REGISTERS
The graphics controller registers are located at a two byte I/O address space. These registers are
accessed by first writing an index to the Graphics Address register (at 3CEH) and then accessing the
Data register (at 3CFH).
Graphics Controller Index Register (GRC_ADR)
| Read/Write  |     | Address: 3CEH  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is loaded with a binary index value that determines which graphics controller register will
be accessed. This value is referred to as the "Index Number" of the GR register (GR0-6).
|     |     | 321  | 0   |
| --- | --- | ---- | --- |
GR CONT ADDRESS
| Bits 3-0  | GR CONT ADDRESS -Graphics Controller Register Index  |     |     |
| --------- | ---------------------------------------------------- | --- | --- |
A binary value indexing the register where data is to be accessed.
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Graphics Controller Data Register (GRC_DATA)
| Read/Write  |     | Address: 3CFH  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is the data port for the graphics controller register indexed by the Graphics Controller
Index register.
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
GRAPHICS CONTROLLER DATA
| Bit 7-0  | GRAPHICS CONTROLLER DATA  |     |     |
| -------- | ------------------------- | --- | --- |
Data to the Graphics Controller register indexed by the graphics controller address.
14-34 VGA STANDARD REGISTER DESCRIPTIONS

••
I':
r If
53 Trio32/Trio64 Integrated Graphics Accelerators
1
53 Incorporated
Set/Reset Data Register (SET /RST _DTI (GROI
ReadlWrite Address: 3CFH, Index OOH
Power-On Default: Undefined
This register represents the value written to all 8 bits of the respective memory plane when the CPU
executes a memory write in write modes 0 and 3.
3 2 1 o
SET/RESET DATA
Bits 3-0 SET/RESET DATA
These bits become the color value for CPU memory write operations. In write mode
0, the set/reset data can be enabled on the corresponding bit of the Enable Set/Reset
Data register. In write mode 3, there is no effect on the Enable Set/Reset Data register.
Bits 7-4 Reserved = 0
Enable Set/Reset Data Register (EN_S/R_DTI (GR11
ReadlWrite Address: 3CFH, Index 01H
Power-On Default: Undefined
These bits enable the set/reset data, and affect write mode O.
321 0
ENB SET/RST DATA
Bits 3-0 ENB SET/RST DATA
When each bit is a logical 1, the respective memory plane is written with the value of
the Set/Reset Data register. A logical 0 disables the set/reset data in a plane, and that
plane is written with the value of CPU write data.
Bits 7-4 Reserved = 0
VGA STANDARD REGISTER DESCRIPTIONS 14-35

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Color Compare Register (COLOR-CMPI (GR21
| Read/Write  |     | Address: 3CFH, Index 02H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: Undefined
These bits represent a 4-bit color value to be compared. In read mode 1, the CPU executes a memory
read, the read data is compared with this value and returns the results. This register works in
conjUnction with the Color Don't Care register.
| 7   |     | 321  |     | 0   |
| --- | --- | ---- | --- | --- |
COLOR COMPARE DATA
=0
| Bits 3-0  | COLOR COMPARE DATA  |     |     |     |
| --------- | ------------------- | --- | --- | --- |
This value becomes the reference color used to compare each pixel. Each of the 8-bit
positions of the read data are compared across four planes and a logical 1 is returned
in each bit position for which the colors match.
Reserved = 0
Bits 7-4
Raster Operation/Rotate Count Register IWT_ROP/RTCIIGR31
| Read/Write  |     | Address: 3CFH, Index 03H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: Undefined
This register selects a raster operation function and indicates the number of bits the CPU data will be
rotated (right) on the video memory write operation.
|     | 6   | I     | 2  I  | I  0  |
| --- | --- | ----- | ----- | ----- |
| 7   | 5   | 4  3  | 1     |       |
RST-OP
| =0        | =0  =0        | 1  0  | ROTATE-COUNT  |     |
| --------- | ------------- | ----- | ------------- | --- |
| Bits 2-0  | ROTATE-COUNT  |       |               |     |
These bits define a binary encoded value of the number of positions to right-rotate
data during a CPU memory write. To write non-rotated data, the CPU must preset a
count ofO.
14-36 VGA STANDARD REGISTER DESCRIPTIONS

••
r 53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Bits 4-3 RST-OP -Select Raster Operation
The data written to memory can operate logically with the data already in the proces
sor latches. This function is not available in write mode 1. The logical functions are
defined as follows:
00 = No operation
01 = Logical AND with latched data
10 = Logical OR with latched data
11 = Logical XOR with latched data
The logical function specified by this register is applied to data being written to mem
ory while in modes 0, 2 and 3.
Bits 7-5 Reserved = 0
Read Plane Select Register (RD_PL_SL) (GR4)
ReadIWrite Address: 3CFH, Index 04H
Power-On Default: Undefined
1 0
RD-PL-SL
o
The contents of this register represent the memory plane from which the CPU reads data in read mode
O. This register has no effect on the color compare read mode (read mode 1). In odd/even mode, bit 0
is ignored. Four memory planes are selected as follows:
Bits 1-0 RD-PL-SL -Read Plane Select
The memory plane is selected as follows:
00 = Plane 0
01 = Plane 1
10 = Plane 2
11 = Plane 3
Bits 7-2 Reserved =0
VGA STANDARD REGISTER DESCRIPTIONS 14-37

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Graphics Controller Mode Register (GRP _MODE) (GR5)
Read/Write Address: 3CFH, Index 05H
Power-On Default: Undefined
7 6 I 5 4 3 2 1 I 0
SHF-MODE OlE RD WRT-MD
=0 256 OlE MAP CMP =0 1 0
This register controls the mode of the Graphics Controller as follows:
Bit 1-0 WRT-MD -Select Write Mode
These bits select the CPU write mode into video memory. The function of each mode
is defined as follows:
o.
00 = Write Mode Each of four video memory planes is written with the CPU data
rotated by the number of counts in the rotate register. If the Set/Reset register is
enabled for any of four planes, the corresponding plane is written with the data
stored in the set/reset register. Raster operations and bit mask registers are
effective
01 = Write Mode 1. Each of four video memory planes is written with the data in the
processor latches. These latches are loaded during previous CPU read opera
tions. Raster operation, rotate count, set/reset data, enable set/reset data and bit
mask registers are not effective
10 = Write Mode 2. Memory planes 0-3 are filled with B bits of the value of CPU
write data bits 0-3, respectively. For example, if write data bit 0 is a 1, eight 1's
are written to memory plane O. The data on the CPU data bus is treated as the
color value. The Bit Mask register is effective as the Mask register. A logical 1 in
the Bit Mask register sets the corresponding pixel in the addressed byte to the
color specified on the data bus. A logical 0 in the Bit Mask register sets the
corresponding pixel in the addressed byte to the corresponding pixel in the
processor latches. The Set/Reset, Enable Set/Reset and Rotate Count registers
are ignored
11 = Write Mode 3. Each of four video memory planes is written with B bits of the
color value contained in the set/reset register for that plane. The Enable Set/
Reset register is not effective. Rotated CPU write data is ANDed with the bit mask
register to form an 8-bit value that performs the same function as the Bit Mask
register in write modes 0 and 2. This write mode can be used to fill an area with
a single color and pattern
Bit 2 Reserved = 0
Bit 3 RD CMP -Enable Read Compare
o = The CPU reads data from the video memory planes. The plane is selected by the
Read Plane Select register. This is called read mode 0
1 = The CPU reads the results of the logical comparison between the data in four
video memory planes selected by the contents of the Color Don't Care register
and the contents of the Color Compare register. The result is a 1 for a match and
o for a mismatch on each pixel. This is called read mode 1
14-38 VGA STANDARD REGISTER DESCRIPTIONS

..-
_J~
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
| Bit 4  | OlE MAP -Select Odd/Even Addressing  |     |     |
| ------ | ------------------------------------ | --- | --- |
o
= Standard addressing.
1 = Odd/even addressing mode selected. Even CPU addresses access plane 0 and 2,
while odd CPU addresses access plane 1 and 3. This option is useful for
emulating the CGA compatible mode. The value of this bit should be the inverted
value programmed in bit 2 of the Sequencer Memory Mode register (SR4). This
bit affects reading of display memory by the CPU
| Bit 5  | SHF-MODE -Select Odd/Even Shift Mode  |     |     |
| ------ | ------------------------------------- | --- | --- |
o
= Normal shift mode
1 =T he video shift registers in the graphics section are directed to format the serial
data stream with even-numbered bits from both planes on the even-numbered
planes and odd-numbered bits from both planes on the odd planes
| Bit 6  | SHF-MODE -Select 256 Color Shift Mode  |     |     |
| ------ | -------------------------------------- | --- | --- |
o
= Bit 5 in this register controls operation ofthe video shift registers
1 = The shift registers are loaded in a manner that supports the 256 color mode
| Bit 7  | Reserved = 0  |     |     |
| ------ | ------------- | --- | --- |
Memory Map Mode Control Register (MISC_GM) (GR6)
| Read/Write  |     | Address: 3CFH, Index 06H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register controls the video memory addressing.
I
| 7  6    | 5  4    | 3  2     | 1  0      |
| ------- | ------- | -------- | --------- |
|         |         | MEM-MAP  | CHN  TXT  |
| =0  =0  | =0  =0  | 1  0     | OlE  /GR  |
TXT/GR -Select TexVGraphics Mode
Bit 0
o  = Text mode display addressing selected
1 = Graphics mode display addressing selected. When set to graphics mode, the
character generator address latches are disabled
| Bit 1  | CHN OlE -Chain Odd/Even Planes  |     |     |
| ------ | ------------------------------- | --- | --- |
o
= AO address bit unchanged
1 = CPU address bit AO is replaced by a higher order address bit. The content of AO
determines which memory plane is to be addressed. AO  0 selects planes 0
=
and 2, and AO  = 1 selects planes 1 and 3. This mode can be used to double the
address space into video memory
VGA STANDARD REGISTER DESCRIPTIONS  14-39

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
| Bits 3-2  | MEM-MAP -Memory Map Mode  |     |     |
| --------- | ------------------------- | --- | --- |
These bits control the address mapping of video memory into the CPU address
space. The bit functions are defined below.
00 = AOOOOH to BFFFFH (128 KBytes)
01 = AOOOOH to AFFFFH (64 KBytes)
10 = BOOOOH to B7FFFH (32 KBytes)
11 = B8000H to BFFFFH (32 KBytes)
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Color Don't Care Register (CMP _DNTC) (GR7)
| ReadNVrite  | Address: 3CFH, Index 07H  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: Undefined
This register is effective in read mode 1, and controls whether the corresponding bit of the Color
Compare Register is to be ignored or used for color comparison.
|     |     | 3  1- 1  | o   |
| --- | --- | -------- | --- |
2
COMPARE PLANE SEL
| Bits 3-0  | COMPARE PLANE SEL -Compare Plane Select  |     |     |
| --------- | ---------------------------------------- | --- | --- |
o = The corresponding color plane becomes a don't care plane when the CPU read
from the video memory is performed in read mode 1
1 = The corresponding color plane is used for color comparison with the data in the
Color Compare register
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Bit Mask Register (BIT_MASK) (GRB)
| ReadNVrite  |     | Address: 3CFH, Index OSH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
Any bit programmed to 0 in this register will cause the corresponding bit in each offour memory planes
to be immune to change. The data written into memory in this case is the data which was read in the
previous cycle, and was stored in the processor latches. Any bit programmed to 1 allows unimpeded
writes to the corresponding bits in the plane.
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
BIT MASK
| Bits 7-0  | BIT MASK  |     |     |
| --------- | --------- | --- | --- |
A logical 0 means the corresponding bit of each plane in memory is set to the corre
sponding bit in the processor latches. A logical 1 means the corresponding bit of
each plane in memory is set as specified by other conditions.
14-40 VGA STANDARD REGISTER DESCRIPTIONS

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
14.5 ATTRIBUTE CONTROLLER REGISTERS
The attribute controller registers are located atthe same byte I/O address for writing address and data.
An internal address flip-flop (AFF) controls the selection of either the attribute index or data registers.
To initialize the address flip-flop (AFF), an I/O read is issued at address 3BAH or 3DAH. This presets the
address flip-flop to select the index register. After the index register has been loaded by an I/O write
to address 3COH, AFF toggles and the next 1/0 write loads the data register. Every I/O write to address
3COH toggles this address flip-flop. However, it does not toggle for I/O reads at address 3COH or 3C1 H.
The Attribute Controller Index register is read at 3COH, and the Attribute Controller Data register is read
at address 3C1 H.
Attribute Controller Index Register (ATR_ADI
| Read/Write  |     | Address: 3COH  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is loaded with a binary index value that determines which attribute controller register will
be accessed. This value is referred to as the "Index Number" of the AR register (ARO-14).
|       |     | I  I     | I  I  |
| ----- | --- | -------- | ----- |
| 7  6  | 5   | 4  3  2  | 1  0  |
ENB
| R  R      | PLT                | ATIRIBUTE ADDRESS  |     |
| --------- | ------------------ | ------------------ | --- |
| Bits 4-0  | ATTRIBUTE ADDRESS  |                    |     |
A binary value that points to the attribute controller register where data is to be
written.
| Bit 5  | ENB PL T -Enable Video Display  |     |     |
| ------ | ------------------------------- | --- | --- |
o = Video display access to the palette registers disabled. The Attribute Controller
register can be accessed by the CPU
1 = Display video using the palette registers enabled (normal display operation). The
palette registers (ARO-ARF) cannot be accessed by the CPU
This bit is effective only in a-bit PA mode (CR67 _4= a).
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
VGA STANDARD REGISTER DESCRIPTIONS  14-41

83 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Attribute Controller Data Register (ATR_DATA)
| Read/Write  |     | Address: R: 3C1 H/W: 3COH  |     |
| ----------- | --- | -------------------------- | --- |
Power-On Default: Undefined
This register is the data port for the attribute controller register indexed by the Attribute Controller
Index register.
I
| 7  6  | 5  4  | .  3  2  | 1  o  |
| ----- | ----- | -------- | ----- |
ATIRIBUTE DATA
| Bits 7-0  | ATTRIBUTE DATA  |     |     |
| --------- | --------------- | --- | --- |
Data to the attribute controller register indexed by the attribute controller address.
Palette Registers (PLT_REG) (AROO-OF)
| Read/Write  |     | Address: 3C1 H/3COH, Index OOH-OFH  |     |
| ----------- | --- | ----------------------------------- | --- |
Power-On Default: Undefined
These are 16, 6-bit registers pointed to by the index and color code. They allow a dynamic mapping
between the text attribute or graphics color input and the display color on the CRT screen.
I
| 7  6      | 5  I  4        | 3  2   | I  1  I  0  |
| --------- | -------------- | ------ | ----------- |
|           | SECONDARY      |        | PRIMARY     |
| =0  =0    | SR  SG         | SB  R  | G  B        |
| Bits 5-0  | PALETTE COLOR  |        |             |
The six bit display color, bits 5-0 are output as SR, SG/I, SBN, R, G and B,
respectively.
Bits 7~ Reserved = 0
14-42 VGA STANDARD REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Attribute Mode Control Register (ATR_MODE) (AR10)
| ReadJWrite  |     | Address: 3C1 H/3COH, Index 10H  |     |     |
| ----------- | --- | ------------------------------- | --- | --- |
Power-On Default: OOH
The contents of this register controls the attribute mode of the display function.
|      | 6  5                                | 3              | 2  1        |     |
| ---- | ----------------------------------- | -------------- | ----------- | --- |
| 7    |                                     | 4              |             | 0   |
| SEL  | 256  TOP                            | ENB  ENB       | MONO TX/GR  |     |
| V54  | CLR  PAN                            | =0  BLNK  LGC  | ATRB        |     |
|      | Bit 0  TX/GR -Select Graphics Mode  |                |             |     |
o = Selects text attribute control mode
1 = Selects graphics control mode
|     | Bit 1  MONO ATRB -Select Monochrome Attributes  |     |     |     |
| --- | ----------------------------------------------- | --- | --- | --- |
o = Selects color display text attributes
1 = Selects monochrome display text attributes
|     | Bit 2  ENB LGC -Enable Line Graphics  |     |     |     |
| --- | ------------------------------------- | --- | --- | --- |
0= The ninth dot of a text character (bit 0 of SR1 = 0) is the same as the background
1 = Special line graphics character codes enabled
When this bit is set to 1, it forces the ninth dot of a line graphics character to be identi
cal to the eighth dot of the character. The line graphics character codes are COH
through DFH. For other characters, the ninth dot is the same as the background.
|     | Bit 3  ENB BLNK -Enable Blinking  |     |     |     |
| --- | --------------------------------- | --- | --- | --- |
o  = Selects the background intensity for the text attribute input
1 = Selects blink attribute in text modes
This bit must also be set to 1 for blinking graphics modes. The blinking counter is op
erated by the vertical retrace counter (VRTC) input. It divides the VRTC input by 32.
The blinking rates are ON for 16 VRTC clocks and OFF for 16 VRTC clocks. In the
graphics mode, when blink is activated, the most significant color bit (bit 3) for each
dot is inverted alternately, thus allowing two different colors to be displayed for 16
VRTC clocks each.
When the cursor is displayed in the text mode, it is blinked at a rate of ON for 8 VRTC
clocks and OFF for 8 VRTC clocks (period by 16 frames). The displayed characters are
independently blinked at the rate of 32 frames as above.
|     | Bit 4  Reserved = 0                 |     |     |     |
| --- | ----------------------------------- | --- | --- | --- |
|     | Bit 5  TOP PAN -Top Panning Enable  |     |     |     |
o
= Line compare has no effect on the output of the pixel panning register
1 = Forces the output of the pixel panning register to 0 after matching line compare
until VSYNC occurs in the CRT controller. At the top of screen the output of the
Pixel Panning register returns to its programmed value. This bit allows a top
portion of a split screen to be panned.
VGA STANDARD REGISTER DESCRIPTIONS  14-43

| , . |     |     |     |
| --- | --- | --- | --- |
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad
| Bit 6  | 256 CLR -Select 256 Color Mode  |     |     |
| ------ | ------------------------------- | --- | --- |
o  = 4 bits of video (translated to 6 bits by the palette) are output every internal
dot-clock cycle
1 = Two 4-bit sets of video data are assembled to generate a-bit video data at half the
frequency of the internal dot-clock
| Bit 7  | SEL V54 -Select V[5:4]  |     |     |
| ------ | ----------------------- | --- | --- |
o = In VGA, mode, bits 5-4 of video output are generated by the attribute palette
registers. Bits 7-6 of video output are always generated by bits 3-2 of AR14
1 = Bits 5-4 of video output are generated by bits 1-0 of AR14
Border Color Register (BDR_CLR) (AR11)
| Read/Write  | Address: 3C1 H/3COH, Index 11 H  |     |     |
| ----------- | -------------------------------- | --- | --- |
Power-On Default: OOH
o
| 7  6  | 5  432  |     | 1   |
| ----- | ------- | --- | --- |
BORDER COLOR
Bits 7-0  Border Color. This a-bit register determines the border color displayed on the CRT
screen. The border is an area around the screen display area.
This register is only effective in a-bit PA modes (CR67 _4= 0). See also CR33_5.
Color Plane Enable Register (DISP _PLN) (AR12)
| Read/Write  | Address: 3C1H/3COH, Index 12H  |     |     |
| ----------- | ------------------------------ | --- | --- |
Power-On Default: OOH
This register enables the respective video memory color plane 3-0 and selects video color outputs to
be read back in the display status.
| 7  6  | 5  I  4  | I     | I  1  I  |
| ----- | -------- | ----- | -------- |
|       |          | 3  2  | 0        |
VDT-SEL
| =0  =0    | 1  0                | DISPLAY PLANE ENBL  |     |
| --------- | ------------------- | ------------------- | --- |
| Bits 3-0  | DISPLAY PLANE ENBL  |                     |     |
A 0 in any of these bits forces the corresponding color plane bit to 0 before accessing
the internal palette. A 1 in any of these bits enables the data on the corresponding
color plane.
14-44 VGA STANDARD REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Bits 5-4  VDT-SEL -Video Test Select
These bits select two of the eight bit color outputs to be available in the Input Status
1 register. The output color combinations available on the status bits are as follows:
o
| STSMUX  |          | STS1          |     |
| ------- | -------- | ------------- | --- |
| Bit 5   | Bit 4    | Bit 5  Bit 4  |     |
| a       | a        |               | a   |
|         | Video 2  | Video         |     |
a
|     | 1  Video 5  | Video 4  |     |
| --- | ----------- | -------- | --- |
| 1   | a  Video 3  | Video 1  |     |
| 1   | 1  Video 7  | Video 6  |     |
Reserved = 0
Bits 7-6
Horizontal Pixel Panning Register (H_PX_PAN) (AR13)
Read/Write  Address: 3C1H/3COH, Index 13H
Power-On Default: OOH
This register specifies the number of pixels to shift the display data horizontally to the left. Pixel panning
is available in both text and graphics modes. It is not available with Enhanced mode memroy mappings
(CR31_3 = 1).
|     | 321  | 0   |     |
| --- | ---- | --- | --- |
NUMBER OF PAN SHIFT
NUMBER OF PAN SHIFT
Bits 3-0
This register selects the number of pixels to shift the display data horizontally to the
left. In the 9 pixels/character text mode, the output can be shifted a maximum shift of
8 pixels. In the 8 pixels/character text mode and all graphics modes, except 256 color
mode, a maximum shift of 7 pixels is possible. In the 256 color mode, bit 0 of this reg
ister must be 0 resulting in only 4 panning positions per display byte. The panning is
controlled as follows:
Number of Dixels shifted in
| Bits 3-0  | 9 pixel/char.  | S pixel/char.  | 256 color mode  |
| --------- | -------------- | -------------- | --------------- |
|           |                | a              | a               |
| 0000      | 1              |                |                 |
-
| 0001  | 2   | 1   |     |
| ----- | --- | --- | --- |
3
| 0010  |     | 2   | 1   |
| ----- | --- | --- | --- |
| 0011  | 4   | 3   | -   |
| 0100  | 5   | 4   | 2   |
| 0101  | 6   | 5   | -   |
| 0110  | 7   | 6   | 3   |
| 0111  | 8   | 7   | -   |
a
| 1000  |     | -   | -   |
| ----- | --- | --- | --- |
Bits 7-4  Reserved = 0
VGA STANDARD REGISTER DESCRIPTIONS 14-45

••
r
53 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Pixel Padding Register (PX_PADDI (AR141
| Read/Write  |     | Address: 3C1H/3COH, Index 14H  |     |
| ----------- | --- | ------------------------------ | --- |
Power-On Default: OOH
This register specifies the high-order bits of video output when pixel padding is enabled and disabled
in the 256 color mode.
|       |       | I     | I  I  |
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
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
14-46 VGA STANDARD REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
14.6 SETUP REGISTERS
This section describes the Video Subsystem Setup registers on the system board.
The I/O functions of the system board use POS information during the setup procedure. The I/O
controllers on the system board are treated as a single device. Although the VGA is a part of the system
board, POS treats it as a separate device. The Setup Enable register is used to place the system board
or the Video Subsystem into setup. The Setup Enable register is read/write at I/O address 46E8H. The
bit definitions are provided below.
Setup Option Select Register (SETUP_MOl
Read/Write Address: 102H
Power-On Default: OOH
I : I : I : I : I : I : I
R
Bit 0 SLP MODE-Disable Sleep Mode
When in setup mode (I/O address 46E8H, bit 4 =1), the Tri032/Tri064 responds to a sin
gle option select byte at I/O address 102H and treats this bit as the Video Subsystem
sleep bit.
o = Tri032/Trio64 does not respond to commands, addresses, or data on the data bus.
If the Tri032/Tri064 was set up and is generating video output when this bit is
cleared to 0, the output is still generated
1 = Tri032/Tri064 responds to commands, addresses, or data on the data bus
The Tri032/Tri064 responds only to address 102H when in the setup mode. No other
addresses are valid at that time. The Tri032/Tri064 ignores address 102H when in the
enabled mode (l{0 address 46E8H, bit 4 = 0), and decodes normal I/O and memory ad
dresses.
If bit 2 of CR65 is set to 1, 3C3H is the address used for setup instead of 46E8H.
Bit 7-1 Reserved
VGA STANDARD REGISTER DESCRIPTIONS 14-47

....
| r   |     | S3 Trio32/Trio64 Integrated Graphics Accelerators  |     |     |
| --- | --- | -------------------------------------------------- | --- | --- |
S3 Incorporatad
Video Subsystem Enable Register (SETUP_MOl
| Write Only  |     | Address: 46E8H  |     |     |
| ----------- | --- | --------------- | --- | --- |
Power-On Default: OOH
|           | SE~p                                    | ~c    |             |       |
| --------- | --------------------------------------- | ----- | ----------- | ----- |
| I  :  I   | :  I  :  I                              | I  I  | :  I  R  I  | :  I  |
| Bits 2-0  | Reserved                                |       |             |       |
| Bit 3     | AD DEC -Tri032/Tri064 Address Decoding  |       |             |       |
o  = Video I/O and memory address decoding are disabled
1 = Video I/O and memory address decoders are enabled
| Bit 4  | EN SUP -Enable Tri032/Tri064 Setup  |     |     |     |
| ------ | ----------------------------------- | --- | --- | --- |
o
= The Tri032/Tri064 is in operational mode
1 = The Tri032/Tri064 is placed in setup mode
If bit 2 of CR65 is set to 1, 3C3H is the address used for setup instead of 46E8H.
| Bits 7-5  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
14-48 VGA STANDARD REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
14.7 RAMDAC REGISTERS
All of the RAMDAC registers described in this section are physically located inside the Trio32rrrio64.
DAC Mask Register IDAC_AD_MKI
ReadJWrite Address: 3C6H
Power-On Default: Undefined
This register is the pixel read mask register to select pixel video output. The CPU can access this register
at any time.
7 6 5 4 3 2 o
DAC ADDRESS MASK
Bits 7-0 DAC ADDRESS MASK
The contents of this register are bit-wise logically ANDed with the pixel select video
output (PA[7:0]). This register is initialized to FFH by the BIOS during a video mode
set.
DAC Read Index Register IDAC_RD_ADI
Write Only Address: 3C7H
Power-On Default: Undefined
This register contains the pointer to one of 256 palette data registers and is used when reading the
color palette.
7 6 543 2 o
DAC READ ADDRESS
Bits 7-0 DAC READ ADDRESS
Each time the color code is written to this register, it identifies that a read sequence
will occur. A read sequence consists of three successive byte reads from the RAM
DAC data register at I/O address 3C9H. The least significant 6 bits of each byte taken
from the RAMDAC data register contain the corresponding color value, and the most
significant 2 bits contain zeros. The order is red byte first, then green, and finally
blue. The sequence of events for a read cycle is:
1. Write the color code to this register (RAMDAC Read Index) at address 3C7H.
2. The contents of the location in the color look-up table pointed to by the color code
are transferred to the RAMDAC data register at address 3C9H.
3. Three bytes are read back from the RAMDAC data register.
4. The contents of this register auto-increment by one.
VGA STANDARD REGISTER DESCRIPTIONS 14-49

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
5. Go to step 2.
The effects of writing to the RAMDAC data register during a three-byte read cycle or
reading from the RAMDAC data register during a 3-byte write cycle (Le., interrupting
the sequence) are undefined and may change the look-up table contents.
DAC Status Register (DAC_STSI
Read Only Address: 3C7H
Power-On Default: Undefined
7 6 3 2 1 0
=0 =0 =0 =0 DAC-STS
Bits 1-0 DAC-STS -RAMDAC Cycle Status
The last executing cycle was:
00 = Write Palette cycle
11 = Read Palette cycle
Reads from the RAMDAC Write Index at address 3C8H or the DAC status register at
address 3C7H do not interfere with read or write cycles and may take place at any
time.
Bits 7-2 Reserved = 0
DAC Write Index Register (DAC_WR_ADI
ReadIWrite Address: 3C8H
Power-On Default: Undefined
Bits 7-0 DAC WRITE ADDRESS/GIP READ DATA
This register contains the pointer to one of 256 palette data registers and is used dur
ing a palette load. Each time the color code is written to this register, it identifies that
a write sequence will occur. A write sequence consists of three successive byte writes
to the DAC data register at I/O address 3C9H. The least significant 6 bits of each byte
are concatenated to form the value placed in the 18-bit data register. The order is red
byte first, then green, and finally blue. Once the third byte has been written, the value
in the data register is written to the location pointed to by the color code. The se
quence of events for a write cycle is:
1. Write the color code to this register (DAC Write Index) at address 3C8H.
2. Three bytes are written to the DAC Data register at address 3C9H.
14-50 VGA STANDARD REGISTER DESCRIPTIONS

fl·
53 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
3. The contents of the DAC data register are transferred to the location in the color
look-up table pointed to by the color code.
4. The DAC Write Index register auto-increments by 1.
5. Go to step 2.
If bit 2 of the Extended RAMDAC Control register (CR55) is set to 1 to enable the Gen
eral I/O Port read function, a read of 3C8H retrieves data from an external input buff
er. The data is transmitted via GD[7:0] to AD[7:0] for a PCI bus configuration and
directly to SD[7:0] for a VL-Bus configuration.
RAMDAC Data Register (DAC_DATA)
Read/Write Address: 3C9H
Power-On Default: Undefined
This register is a data port to read or write the contents of the location in the color look-up table pointed
to by the DAC Read Index or the DAC Write Index registers.
7 6 543 2 1 o
DAC READ/WRITE DATA
Bits 7-0 DAC READ/WRITE DATA
To prevent "snow flicker" on the screen, an application reading data from or writing
data to the DAC Data register should ensure that the BLANK input to the RAMDAC is
asserted. This can be accomplished either by restricting data transfers to retrace inter
vals, checking bit 3 of the Input Status 1 register (3?AH) to determine when retrace is
occurring, or by using the screen-off bit in the Clocking Mode register of the se
quencer (bit 5 of SR1).
VGA STANDARD REGISTER DESCRIPTIONS 14-51

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Section 15: S3 VGA Register Descriptions
The Trio32!Tri064 has additional registers to extend the functions beyond VGA. These registers are
located in CRT Controller address space at locations not used by the IBM® VGA. All of these registers
are read/write protected at power-up by hardware reset. In order to read/write these registers, the
Register Lock 1 register (CR3S) must be loaded with a changed key pattern (see the register description).
The registers will remain unlocked until the key pattern is reset by altering a significant bit.
In the following register descriptions, 'R' stands for reserved (write =0, read = undefined). See Appendix
A for a table listing each register in this section and its page number.
Device ID High Register (CR2D)
| Read Only  |     | Address: 3?5H, Index 2DH  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: SSH
This register should contain the same value as the upper byte ofthe PCI Device 10 (Index OOH) register.
o
| 7  6  | 5  4  | 3  2  |     |
| ----- | ----- | ----- | --- |
CHIP ID HIGH
| Bits 7-0  | CHIP 10 HIGH  |     |     |
| --------- | ------------- | --- | --- |
Device ID Low Register (CR2E)
| Read Only  |     | Address: 3?5H, Index 2EH  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: 10H (Trio32), 11H (Tri064)
This register allows software to identify whether a Trio32 or Trio64 is present.
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
CHIP ID LOW
| Bits 7-0  | CHIP 10 LOW  |     |     |
| --------- | ------------ | --- | --- |
10H for Trio32 or 11H for Trio64
S3 VGA REGISTER DESCRIPTIONS 15-1

II·
83 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Revision Register (CR2F)
Read Only Address: 375H, Index 2FH
Power-On Default: See description.
7 6 543 2 1 o
REVISION LEVEL
Bits 7-0 REVISION LEVEL
Chip IO/REV Register (CHiP-tO/REV) (CR30)
Read Only Address: 375H, Index 30H
Power-On Default: E1 H
When the software detects EH in the upper nibble of this register, it should then use CR2D, CR2E and
CR2F for chip ID information.
7 6 5 4 321 0
CHIPID REVISION STATUS
Bits 7-0 CHIP ID AND REVISION STATUS
Memory Configuration Register (MEM_CNFG) (CR31)
ReadIWrite Address: 375H, Index 31H
Power-On Default: OOH
I
7 6 5 4 3 2 1 0
HST OLD-DSAD ENH VGA SCRN CPUA
R DFF 17 16 MAP 16B 2.PG BASE
Bit 0 CPUA BASE -Enable Base Address Offset
0= Address offset bits 3-0 of CR35 and bits 3-2 of CR51 or the new address offset bits
(5-0 of CR6A) are disabled
1 = Address offset bits 3-0 CR35 and bits 3-2 of CR51 or the new address offset bits (5-
o
of CR6A) are enabled for specifying the 64K page of display memory. Bits 5-0 of
CR6A are used if this field contains a non-zero value. This allows access to up to
4 MBytes of display memory through a 64K window. (2 MBytes for the Tri032)
Bit 1 SCRN 2.PG -Enable Two-Page Screen Image
o
= Normal Mode
1 = Enable 2K x 1 K x 4 map image screen for 1024 x 768 or 800 x 600 screen
resolution, or 2K x 512 x 8 map image screen for 640 x 480 screen resolution
15-2 S3 VGA REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Bit 2 VGA 16B -Enable VGA 16-bit Memory Bus Width
o = 8-bit memory bus operation
1 = Enable 16-bit bus VGA memory read/writes
This is useful in VGA text modes when VGA graphics controller functions are typi
cally not used.
Bit 3 ENH MAP -Use Enhanced Mode Memory Mapping
o = Force IBM VGA mapping for memory accesses
1 = Force Enhanced Mode mappings
Setting this bit to 1 overrides the settings of bit 6 of CR14 and bit 3 of CR17 and
causes the use of doubleword memory addressing mode. Also, the function of bits 3-
2 of GR6 is overridden with a fixed 64K map at AOOOOH.
Bits 5-4 OLD-DSAD 17, 16 -Old Display Start Address Bits 17-16
Bits 17-16 of start address (CRC, CRD) and cursor location (CRE, CRF)
Bits 1-0 of the Extended System Control 2 register (CR51) are bits 19-18 of the ad
dress and enable access to up to 4 MBytes of display memory. If a value is pro
grammed into bits 3-0 of the Extended System Control 3 register (CR69), this value
becomes the upper 4 bits of the display start base address and bits 5-4 of CR31 and
bits 1-0 of CR51 are ignored. The Tri032 only supports 2 MBytes, so the upper bit is
not used.
Bit 6 HST OFF -Enable High Speed Text Display Font Fetch Mode
o
= Normal font access mode
1 = Enable high speed text display
Setting this bit to 1 is only required for DCLK rates greater than 40 MHz. See bit 5 of
CR3A.
Bit 7 Reserved
Backward Compatibility 1 Register (BKWD_11 (CR32)
Read/Write Address: 3?5H, Index 32H
Power-On Default: OOH
7 5
R R
Bits 3-0 Reserved
S3 VGA REGISTER DESCRIPTIONS 15-3

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
| Bit 4  | INT EN -Interrupt Enable  |     |     |
| ------ | ------------------------- | --- | --- |
o = All interrupt generation disabled
1 = Interrupt generation enabled
| Bit 5  | Reserved                                    |     |     |
| ------ | ------------------------------------------- | --- | --- |
| Bit 6  | VGA FXPG -Use Standard VGA Memory Wrapping  |     |     |
o  = Memory accesses extending past a 256K boundary do not wrap
1 = Memory accesses extending past a 256K boundary wrap at the boundary
The standard 256K VGA memory page always ends on a natural 256K boundary and
accesses beyond this boundary will wrap. If the starting address is moved via bits 4-0
of CR69 (or bits 5-4 of CR31 and bits 1-0 of CR51). the 256K page may not end on a
256K boundary and accesses past the boundary will not wrap. This is the case when
this bit is cleared to O. For standard VGA compatibility when the page base address is
moved. this bit is set to 1 to cause wrapping at a 256K boundary.
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
BackWard Compatibility 2 Register (BKWD_2) (CR33)
| Read/VVrite  |     | Address: 3?5H. Index 33H  |     |
| ------------ | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6     | 5  4       | 3  2     | 1  0    |
| -------- | ---------- | -------- | ------- |
| LOCK     | BDR  LOCK  | VCLK=    | DIS     |
| R  PLTW  | SEL  DACW  | -DCK  R  | VDE  R  |
| Bit 0    | Reserved   |          |         |
Bit 1  DIS VDE -Disable Vertical Display End Extension Bits Write Protection
o
= VDE protection enabled
1 = Disables the write protect setting of the bit 7 of CR11 on bits 1 and 6 of CR7
| Bit 2  | Reserved                            |     |     |
| ------ | ----------------------------------- | --- | --- |
| Bit 3  | VCLK = -DCK -VCLK is Internal DCLK  |     |     |
o = VCLK is the external VCLK (pass-through feature connector clock input enabled)
,or is divided by 2 for 4 bits/pixel modes (see bit 6 of AR10 or bit 4 of CR3A) or is
the internal DCLK (if neither of the first two cases apply)
1 = VCLK is the internal DCLK
| Bit 4  | LOCK DACW -Lock RAMDAC Writes  |     |     |
| ------ | ------------------------------ | --- | --- |
o = Enable writes to RAMDAC registers
1 = Disable writes to RAMDAC registers
| Bit 5  | BDR SEL -Blank/Border Select  |     |     |
| ------ | ----------------------------- | --- | --- |
o = BLANK active time is defined by CR2 and CR3
1 = BLANK is active during entire display inactive period (no border)
15-4 S3 VGA REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
| Bit 6  | LOCK PL1  W -Lock Palette/Border Color Registers  |     |     |
| ------ | ------------------------------------------------- | --- | --- |
o = Unlock Palette/Border Color registers
1 = Lock Palette/Border Color registers
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
Backward Compatibility 3 Register (BKWD_3) (CR34)
| Read/Write  |     | Address: 3?5H, Index 34H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6  | 5  4  | 3  2  | 0   |
| ----- | ----- | ----- | --- |
1
|        | ENB                            | PCI     | PCI  PCI  |
| ------ | ------------------------------ | ------- | --------- |
| R  R   | R  SFF                         | R  RET  | ABT  SNP  |
| Bit 0  | PCI SNP -PCI DAC snoop method  |         |           |
o  = Handling of PCI master aborts and retries during DAC cycles controlled by bits 1
and 2 of this register
1 = PCI master aborts and retries are not handled during DAC cycles
| Bit 1  | PCI ABT -PCI master aborts during DAC cycles  |     |     |
| ------ | --------------------------------------------- | --- | --- |
o = PCI master aborts handled during DAC cycles
1 = PCI master aborts not handled during DAC cycles
Bit 0 of this register must be cleared to 0 for this bit to be effective.
| Bit 2  | PCI RET -PCI retries during DAC cycles  |     |     |
| ------ | --------------------------------------- | --- | --- |
o
= PCI retries handled during DAC cycles
1 = PCI retries not handled during DAC cycles
Bit 0 of this register must be cleared to 0 for this bit to be effective.
| Bit 3  | Reserved                                           |     |     |
| ------ | -------------------------------------------------- | --- | --- |
| Bit 4  | ENB SFF -Enable Start Display FIFO Fetch Register  |     |     |
o
= Start Display FIFO Fetch register (CR3B) disabled
1 = Start Display FIFO Fetch register (CR3B) enabled
| Bits 7-5  | Reserved  |     |     |
| --------- | --------- | --- | --- |
S3 VGA REGISTER DESCRIPTIONS  15-5

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
CRT Register Lock Register (CRTR_LOCK) (CR35)
Read/Write Address: 3?5H, Index 35H
Power-On Default: OOH
7 6 5 4 3 L 2 I 1 I °
LOCK LOCK OLD-CPU-BASE-ADDRESS
R R HTMG VTMG 17 16 15 14
Bits 3-0 OLD-CPU-BASE-ADDRESS
CPU Base Address bits 17-14. These four bits define the CPU address base in 64
KByte units of display memory. These bits are added with CPU address bit 17 (MSB
of video memory addressing) to bit 14 for display buffer accesses.
Bits 3-2 of the Extended System Control 2 register (CR51) are bits 19-18 of the ad
dress and enable access to up to 4 MBytes of display memory. If a value is pro
grammed into bits 5-0 of the Extended System Control 4 register (CR6A), this value
becomes the upper 6 bits of the CPU base address and bits 3-0 of CR35 and bits 3-2 of
CR51 are ignored. The Tri032 only supports 2 MBytes, so the upper bit is not used.
Bit 4 °LO CK VTMG -Lock Vertical Timing Registers
= Vertical timing registers are unlocked
1 = The following vertical timing registers are locked:
CR6
CR7 (bits 7,5,3,2,0)
CR9 (bit 5)
CR10
CR11 (bits 3-0)
CR15
CR16
CR6, CR7 registers are also locked by bit 7 of the Vertical Retrace End register (CR11).
Bit 5 °LO CK HTMG -Lock Horizontal Timing Registers
= Horizontal timing registers are unlocked
1 = The following horizontal timing registers are locked:
CROO
CR1
CR2
CR3
CR4
CR5
CR17 (bit 2)
All these registers (except bit 2 of CR17) are also locked by bit 7 of the Vertical Re
trace End register (CR11).
Bit 7·6 Reserved
15-6 S3 VGA REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Configuration 1 Register (CONFG_REG1) (CR3S)
| ReadJWrite*  | Address: 3?5H, Indices 36H  |     |     |
| ------------ | --------------------------- | --- | --- |
Power-On Default: Depends on Strapping
* Bits 1-0 are read only. The other bits can be written only after OA5H is written to CR39.
This register samples the reset state from PD bus pins [7:0]. Other configuration strapping bits are
found in CR37 and CR68.
| PO Bits  | CR 36 Bits  | Value  | Function  |
| -------- | ----------- | ------ | --------- |
System Bus Select
| 1-0  | 1-0  | 00  | Reserved        |
| ---- | ---- | --- | --------------- |
|      |      | 01  | VESA local bus  |
|      |      | 10  | PCI local bus   |
|      |      | 11  | Reserved        |
Memory Page Mode Select
| 3-2  | 3-2  | 00  | Reserved                      |
| ---- | ---- | --- | ----------------------------- |
|      |      | 01  | Reserved                      |
|      |      | 10  | Extended Data Out (EDO) Mode  |
|      |      | 11  | Fast Page Mode                |
Enable Video BIOS Accesses (VL-Bus)
a
| 4   | 4   |     | Disable video BIOS accesses  |
| --- | --- | --- | ---------------------------- |
|     |     | 1   | Enable video BIOS accesses   |
Display Memory Size
| 7-5  | 7-5  | 000  | 4 MBytes (Trio64 only)  |
| ---- | ---- | ---- | ----------------------- |
|      |      | 001  | Reserved                |
|      |      | 010  | Reserved                |
all
Reserved
|     |     | 100  | 2 MBytes                 |
| --- | --- | ---- | ------------------------ |
|     |     | 101  | Reserved                 |
|     |     | 110  | 1 MByte                  |
|     |     | 111  | 0.5 MByte (Trio32 only)  |
S3 VGA REGISTER DESCRIPTIONS  15-7

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
| Configuration 2 Register (CONFG_REG21  |                             | (CR371  |     |
| -------------------------------------- | --------------------------- | ------- | --- |
| Read/Write*                            | Address: 375H. Indices 37H  |         |     |
Power-On Default: Depends on Strapping
* These bits can be written only after OA5H is written to CR39.
This register samples the reset state from PO bus pins [15:7]. Other configuration strapping bits are
found in CR36 and CR68.
| PD Bits  | CR37 Bits  | Value  | Function  |
| -------- | ---------- | ------ | --------- |
Enable Trio32/Trio64 (VL-Bus)
| 8   | 0   | 0   | Disable Tri032fTri064 except for video BIOS  |
| --- | --- | --- | -------------------------------------------- |
accesses
|     |     | 1   | Enable Tri032fTri064  |
| --- | --- | --- | --------------------- |
Test Mode
| 9   | 1   | 0   | Test mode enabled (all outputs tri-stated)  |
| --- | --- | --- | ------------------------------------------- |
|     |     | 1   | Test mode disabled (normal operation)       |
Video BIOS ROM Size (VL-Bus)
| 10  | 2   | 0   | 64-KByte video BIOS ROM  |
| --- | --- | --- | ------------------------ |
|     |     | 1   | 32-KByte video BIOS ROM  |
Clock Select
| 11  | 3   | 0   | Use external DCLK on XIN pin and external  |
| --- | --- | --- | ------------------------------------------ |
MCLK on STRD pin (test purposes only)
|     |     | 1   | Use internal DCLK. MCLK  |
| --- | --- | --- | ------------------------ |
RAMDAC Write Snooping (VL-Bus)
| 12  | 4   | 0   | Disable LOC.A/SRDY for RAMDAC writes  |
| --- | --- | --- | ------------------------------------- |
|     |     | 1   | Enable LOC.A/SRDY for RAMDAC writes   |
Monitor Tvpe Identification
| 15-13  | 7-5  |     | The S3 BIOS uses these three bits to determine  |
| ------ | ---- | --- | ----------------------------------------------- |
monitor information.
15-8 S3 VGA REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Register Lock 1 Register (REG_LOCK1) (CR3B)
| Read/Write  |     | Address: 3?5H, Index 38  |     |
| ----------- | --- | ------------------------ | --- |
Power-On Default: OOH
Loading 01xx10xx (e.g., 48H) into this register unlocks the S3 VGA register set for read/writes. (x =
don't care)
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
| = 1   |       | = 1   |     |
| =0    |       | =0    |     |
Register Lock 2 Register (REG_LOCK2) (CR39)
| Read/Write  |     | Address: 3?5H, Index 39  |     |
| ----------- | --- | ------------------------ | --- |
Power-On Default: OOH
Loading 101xxxxx (e.g., AOH) unlocks the system control and system extension registers for
reading/writing (x = don't care). Loading A5H allows bits 7-2 of CR36, bits 7-0 of CR37 and bits 7-0 of
CR68 to be written.
|     | 4   | 3  2  1  | o   |
| --- | --- | -------- | --- |
S3 VGA REGISTER DESCRIPTIONS  15-9

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Miscellaneous 1 Register (MISC_1) (CR3A)
| Read/Write  |     | Address: 3?5H, Index 3AH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
I
| 7  6      | 5  4                                      | 3  2      | 1  0     |
| --------- | ----------------------------------------- | --------- | -------- |
| PCIRS     | HST  ENH                                  | TOP  ENB  | REF-CNT  |
| DISA  R   | DFW  256                                  | MEM  RFC  | 1  0     |
| Bits 1-0  | REF-CNT -Alternate Refresh Count Control  |           |          |
00 = Refresh Count 0
01 = Refresh Count 1
10 = Refresh Count 2
11 = Refresh Count 3
If enabled by setting bit 2 of this register to 1, these bits override the refresh count in
bit 6 of CR11 and specify the number of refresh cycles per horizontal line.
| Bit 2  | ENS RFC -Enable Alternate Refresh Count Control  |     |     |
| ------ | ------------------------------------------------ | --- | --- |
0= Alternate refresh count control (bits 1-0) is disabled
1 = Alternate refresh count control (bits 1-0) is enabled
| Bit 3  | TOP MEM -Enable Top of Memory Access  |     |     |
| ------ | ------------------------------------- | --- | --- |
o = Top of memory access disabled
1 = Simultaneous VGA text and Enhanced modes are enabled. CPU and CRTC
accesses are then directed to the top 32-or 64-KByte area of display memory
depending on whether address bit 13 is 0 or 1 respectively.
ENH 256 -Enable 8 Bits/Pixel or Greater Color Enhanced Mode
Bit 4
o  = Attribute controller shift registers configured for 4-bit modes
1 = Attribute controller shift register configured for 8-, 16-and 24/32-bit color
Enhanced modes
| Bit 5  | HST DFW -Enable High Speed Text Font Writing  |     |     |
| ------ | --------------------------------------------- | --- | --- |
o
= Disable high speed text font writing
1 = Enable high speed text font writing
Setting this bit to 1 is only required for DCLK rates greater than 40 MHz. See bit 6 of
CR31.
| Bit 6  | Reserved                              |     |     |
| ------ | ------------------------------------- | --- | --- |
| Bit 7  | PCIRB DISA -PCI Read Bursts Disabled  |     |     |
o = PCI read burst cycles enabled
1 = PCI read burst cycles disabled
Note: Bit 7 of CR66 must be set to 1 before this bit is set to 1.
15-10 S3 VGA REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Start Display FIFO Register (DT_EX-POS) (CR3B)
| Read/Write  |     | Address: 3?5H, Index 3BH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This value must lie in the horizontal blanking period and is typically 5 less than the value pro
grammed in CRO. This parameter helps to ensure that adequate time is available during horizontal
blanking for activities such as RAM refresh that require control of the display memory. Bit 9 of this
value is bit 6 of CR5D. This register must be enabled by setting bit 4 of CR34 to 1.
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
START DISPLAY FIFO FETCH
| Bits 7-0  | START DISPLAY FIFO FETCH  |     |     |
| --------- | ------------------------- | --- | --- |
9-bit Value = the time in character clocks from the active display start until the restart
of fetching of FIFO data after the start of horizontal blanking. This register contains
the low-order 8 bits of this value.
Interlace Retrace Start Register (IL_RTSTART) (CR3C)
| Read/Write  |     | Address: 3?5H, Index 3CH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This value allows determination of the even/odd row active display starting positions when operat
ing in an interlaced mode. This register is enabled by bit 5 of CR42.
| Bits 7-0  | INTERLACE RETRACE START POSITION  |     |     |
| --------- | --------------------------------- | --- | --- |
Value = offset in terms of character clocks for Interlaced mode start/end in even/odd
frames.
S3 VGA REGISTER DESCRIPTIONS  15-11

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Section 16: System Control Register Descriptions
System Control registers are configuration registers, mode control registers, and hardware graphics
cursor control registers. They are positioned in the same indexed register space as VGA S3 registers.
All of these registers are read/write protected at power-up by hardware reset. In order to read/write
these registers, the Register Lock 2 register (CR39) must be loaded with a key pattern (see the register
description). The registers will remain unlocked until the key pattern is reset by changing a significant
bit.
In the following register descriptions, 'R' stands for reserved (write = 0, read = undefined). See Appendix
A for a table listing each of the registers in this section and its page number.
System Configuration Register (SYS_CNFG) (CR40)
| Read/Write  |     | Address: 3?5H, Index 40H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: 30H
| 7  6    | 5  4                                     | 3  2  | 1  0    |
| ------- | ---------------------------------------- | ----- | ------- |
|         | WDL  RDY                                 |       | EN      |
| =0  =0  | DLAY  CTL                                | R  R  | R  ENH  |
| Bit 0   | EN ENH -Enable Enhanced Register Access  |       |         |
o = Enhanced register access disabled
1 = Enhanced register (x2E8H) access enabled
| Bits 3-1  | Reserved                             |     |     |
| --------- | ------------------------------------ | --- | --- |
| Bits 4    | RDY CTL-Ready Control (VL-8us only)  |     |     |
o = Minimum 0 wait state delay from SADS asserted to assertion of SRDY. Address
latching occurs during the T1 cycle.
1 = Minimum 1 wait state delay from SADS asserted to assertion of SRDY (Default)
With this setting, bit 3 of CR58 determines when the address is latched.
| Bit 5     | Reserved = 1 (Default)  |     |     |
| --------- | ----------------------- | --- | --- |
| Bits 7-6  | Reserved = OOb          |     |     |
SYSTEM CONTROL REGISTER DESCRIPTIONS  16-1

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad
BIOS Flag Register (BIOS_FLAG) (CR41)
| Read/Write  |     | Address: 3?5H, Index 41H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
o
| 7   | 6  543  |     | 2   |     |
| --- | ------- | --- | --- | --- |
BIOS-FLAG-REGISTER-l
| Bits 7-0  | BIOS-FLAG-REGISTER-1  |     |     |     |
| --------- | --------------------- | --- | --- | --- |
Used by the video BIOS.
Mode Control Register (MODE_CTl) (CR42)
| Read/Write  |     | Address: 3?5H, Index 42H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
|     | 6   | 4   |     |     |
| --- | --- | --- | --- | --- |
I : I
|     |     | I :  | I :  I  I :  | I   |
| --- | --- | ---- | ------------ | --- |
R
|           | R                                  | R   |     |     |
| --------- | ---------------------------------- | --- | --- | --- |
| Bits 4-0  | Reserved                           |     |     |     |
|           | Bit 5  INTL MODE -Interlaced Mode  |     |     |     |
o
= Noninterlaced
1 = Interlaced
This bit enables the function of CR3C.
| Bits 7-6  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
Extended Mode Register (EXT_MODE) (CR43)
| Read/Write  |     | Address: 3?5H, Index 43H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
|     | 6  5  | 4  3  | IL*,I  1  | 0   |
| --- | ----- | ----- | --------- | --- |
IH gRI
I
I
|           | R  R                                         | R  R  | R   | R   |
| --------- | -------------------------------------------- | ----- | --- | --- |
|           |                                              | 1     | 1   | 1   |
| Bits 1-0  | Reserved                                     |       |     |     |
|           | Bit 2  OLD LSW8 -Logical Screen Width Bit 8  |       |     |     |
This is an extension of the Offset (Screen Width) register (CR13). This is disabled if
bits 5-4 ofthe Extended System Control 2 register (CR51) are not OOb.
16-2 SYSTEM CONTROL REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
| Bits 6-3  | Reserved                                 |     |     |
| --------- | ---------------------------------------- | --- | --- |
| Bit 7     | HCTR X2 -Horizontal Counter Double Mode  |     |     |
0= Disable horizontal counter double mode
1 = Enable horizontal counter double mode (horizontal CRT parameters are doubled)
Hardware Graphics Cursor Mode Register (HGC_MODE) (CR45)
| ReadlWrite  |     | Address: 3?5H, Index 45H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6   | 5  4                                       | 3  2  | 1  0  |
| ------ | ------------------------------------------ | ----- | ----- |
|        | HWGC                                       |       | HWGC  |
| R  R   | R                                          | R     | R     |
|        | 1280                                       | R     | ENS   |
| Bit 0  | HWGC ENB -Hardware Graphics Cursor Enable  |       |       |
0= Hardware graphics cursor disabled in any mode
1 = Hardware graphics cursor enabled in Enhanced mode
| Bits 3-1  | Reserved                                  |     |     |
| --------- | ----------------------------------------- | --- | --- |
| Bit 4     | HWGC 1280 -Hardware Cursor Right Storage  |     |     |
o  = Function disabled
1 = For 4 bits/pixel, the last 256 bytes in each 1-KByte line of the hardware cursor start
address become the hardware graphics cursor storage area. For 8 bits/pixel, the
last 512 bytes in each 2-KByte line of the hardware cursor start address become
the hardware graphics cursor storage area. In either case, bits 1-0 of CR4D must
be 11b.
| Bits 7-5  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Hardware Graphics Cursor Origin-X Registers (HWGC_ ORGX(HIILll (CR46, CR47)
| ReadlWrite  |     | Address: 3?5H, Index 46H, 47H  |     |
| ----------- | --- | ------------------------------ | --- |
Power-On Default: OOOOH
The high order three bits are written into CR46 and the low order byte is written into CR47.
| Bits 10-0   | HWGC ORG X(H) (L) -X-Coordinate of Cursor Left Side  |     |     |
| ----------- | ---------------------------------------------------- | --- | --- |
| Bits 15-11  | Reserved                                             |     |     |
SYSTEM CONTROL REGISTER DESCRIPTIONS 16-3

r-~ .
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Hardware Graphics Cursor Origin·V Registers (HWGC_ORGV(HIILII (CR48, CR49)
ReadNVrite Address: 315H, Index 48H, 49H
Power-On Default: Undefined
The high order three bits are written into CR48 and the low order byte is written into CR49.
Bits 10-0 HWGC ORG V (H)(L) -V-Coordinate of Cursor Upper Line
The cursor X, Y position is registered upon writing HWGC ORG Y (H).
Bits 15-11 Reserved
Hardware Graphics Cursor Foreground Color Stack Register ( HWGC_FGSTKI (CR4AI
ReadNVrite Address: 3?5H, Index 4AH
Power-On Default: Undefined
TRUE COLOR FOREGROUND STACK (O-2)
Bits 7-0 TRUE COLOR FOREGROUND STACK (O-2)
Three foreground color registers are stacked at this address. The stack pointer (com
mon with CR4B) is reset to 0 by reading the Hardware Graphics Cursor Mode register
(CR45). Each write to this register (CR4A) increments the stack pointer by 1, so three
writes provide 24 bits of true color information.
Hardware Graphics Cursor Background Color Stack Register ( HWGC_BGSTKI (CR4BI
ReadNVrite Address: 3?5H, Index 4BH
Power-On Default: Undefined
Bits 7-0 TRUE COLOR BACKGROUND STACK (O-2)
Three background color registers are stacked at this address. The stack pointer (com
mon with CR4A) is reset to 0 by reading the Hardware Graphics Cursor Mode register
(CR45). Each write to this register (CR4BI increments the stack pointer by 1, so three
writes provide 24 bits of true color information.
16-4 SYSTEM CONTROL REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Hardware Graphics Cursor Storage Start Address Registers (HWGC_STA(HIIL) (CR4C, CR4D)
| Read/Write  | Address: 3?5H, Index 4CH, 4DH  |     |     |
| ----------- | ------------------------------ | --- | --- |
Power-On Default: Undefined
The high order four bits are written into CR4C and the low order byte is written into CR4D.
Bits 11-0  HWGC STA(H)(L)-Hardware Graphics Cursor Storage Start Address
| Bits 15-12  | Reserved  |     |     |
| ----------- | --------- | --- | --- |
Hardware Graphics Cursor Pattern Display Start X-PXL-Position Register (HWGC_DX) (CR4E)
| Read/Write  |     | Address: 3?5H. Index 4EH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 54321                      |     | 0   |
| ----- | -------------------------- | --- | --- |
| R  R  | HWGC PAT DISP START x-pas  |     |     |
HWGC PAT DISP START x-pas -HWGC Pattern Display Start-X Pixel Position
Bits 5-0
This value is the offset (in pixels) from the left side of the 64x64 cursor pixel pattern
from which the cursor is displayed. This allows a partial cursor to be displayed at the
left border of the display.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Hardware Graphics Cursor Pattern Disp Start V-PXL-Position Register (HGC_DV) (CR4F)
| Read/Write  |     | Address: 375H, Index 4FH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 5  4                       | 3  2  | 0   |
| ----- | -------------------------- | ----- | --- |
| R  R  | HWGC PAT DISP START Y-POS  |       |     |
HWGC PAT DISP START v-pas -HWGC Pattern Display Start-V Pixel Position
Bits 5-0
This value is the offset (in pixels) from the top of the 64x64 cursor pixel pattern from
which the cursor is displayed. This allows a partial cursor to be displayed at the top
of the display.
SYSTEM CONTROL REGISTER DESCRIPTIONS  16-5

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Bits 7-6 Reserved
16-6 SYSTEM CONTROL REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Section 17: System Extension Register Descriptions
These registers provide extended system and memory control, external sync control and addressing
window control. They are enabled in the same way as the System Control registers via the Register
Lock 2 register (CR39).
In the following register descriptions, 'R' stands for reserved (write = 0, read = undefined). See Appendix
A for a table listing each of the registers in this section and its page number.
Extended System Cont 1 Register (EX_SCTL_1) (CR50)
| ReadIWrite  |     | Address: 3?5H, Index 50H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| I         | I         |          |       |
| --------- | --------- | -------- | ----- |
| 7  6      | 5  4      | 3  2     | 1  0  |
| GE-SCR-W  | PXL-LNGH  | ENB      | GESW  |
| 1  0      | 1  0      | R  BREQ  | R  2  |
Bit 0  Extension bit 2 of the screen width definition. See bits 7-6 below.
| Bit 1  | Reserved                        |     |     |
| ------ | ------------------------------- | --- | --- |
| Bit 2  | ENB BREa -Enable BREa Function  |     |     |
o
= BREa, BGNT functions disabled
1 = BREa, BGNT functions enabled
| Bit 3     | Reserved                       |     |     |
| --------- | ------------------------------ | --- | --- |
| Bits 5-4  | PXL-LNGH -Pixel Length Select  |     |     |
00 = 1 byte (Default). This corresponds to a pixel length of 4 or B bits/pixel in bit 7 of
the Subsystem Status register (42EBH)
01 = 2 bytes. 16 bits/pixel
10 = Reserved
11 = 4 bytes. 32 bits/pixel
These bits select the pixel length for Enhanced mode command execution through
the Graphics Engine.
SYSTEM EXTENSION REGISTER DESCRIPTIONS 17-1

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Bits 7-6  GE-SCR-W -Graphics Engine Command Screen Pixel Width
Bit 0 of this register is the most significant bit of this definition.
000 = 1024 (or 2048 if bit 1 of CR31 =1) (Default)
001 = 640
010 = 800 (or 1600x1200x4 if bit 2 of 4AE8H = 1)
011 = 1280
100 = 1152
101 = Reserved
110 = 1600
111 = Reserved
Extended System Control 2 Register (EX_SCTL_2) (CR51)
| ReadNVrite  |     | Address: 3?5H, Index 51H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6      | 5  I  4                                         | 3  I  2   | 1  I  0   |
| --------- | ----------------------------------------------- | --------- | --------- |
|           | LOG-SCR-W                                       | OLD-CBAD  | OLD-DSAD  |
| R  R      | 9  8                                            | 19  18    | 19  18    |
| Bits 1-0  | OLD-DSAD -Old Display Start Address Bits 19-18  |           |           |
These are extension bits of Memory Configuration register (CR31) bits 5-4 (Display
Start Base Address). If the upper 4 display start address bits are programmed into
bits 3-0 of CR69, these bits and bits 5-4 of CR31 are ignored. The Tri032 only supports
2 MBytes of memory, so the upper bit is not used.
| Bits 3-2  | OLD-CBAD -Old CPU Base Address Bits 19-18  |     |     |
| --------- | ------------------------------------------ | --- | --- |
These are extension bits of CRT Register Lock register (CR35) bits 3-0 (CPU Base Ad
dress). They becomes bits 19-18 of the CPU base address, enabling access to up to 4
MBytes of display memory. If the upper 6 CPU base address bits are programmed
into bits 5-0 of CR6A, these bits and bits 3-0 of CR35 are ignored. The Tri032 only sup
ports 2 MBytes of memory, so the upper bit is not used.
| Bits 5-4  | LOG-SCR-W -Logical Screen Width Bits 9-8  |     |     |
| --------- | ----------------------------------------- | --- | --- |
These are two extension bits of the Offset register (CR13). If the value of these bits is
not OOb, bit 2 of the Extended Mode register (CR43) is disabled.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
17-2 SYSTEM EXTENSION REGISTER DESCRIPTIONS

,.-
= .,,~
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Extended BIOS Flag 1 Register (EXT_BBFLG1) (CR52)
| Read/Write  |     | Address: 3?5H, Index 52H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6  | 543  | 2   | 1   |
| ----- | ---- | --- | --- |
EXT-BIOS-FLAG-REGISTER-l
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-1  |     |     |
| --------- | ------------------------- | --- | --- |
See the S3 video BIOS documentation for the coding of this register. Note that this
coding is different from that used with previous S3 accelerators.
Extended Memory Control 1 Register (EX_MCTL_1) (CR53)
| Read/Write  |     | Address: 375H, Index 53H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6    | 5  4                           | 3  2  | 1  0    |
| ------- | ------------------------------ | ----- | ------- |
| SWP     | ENB                            |       | ENB     |
| R  NBL  | R  MMIO                        | R  R  | R  WPB  |
| Bit 0   | ENB WPB -Enable Write Per Bit  |       |         |
o = Disable write per bit for all memory banks
1 = Enable write per bit for all memory banks
| Bits 3-1  | Reserved                      |     |     |
| --------- | ----------------------------- | --- | --- |
| Bit 4     | ENB MMIO -Enable MMIO Access  |     |     |
o = Disable (Default)
1 = Enable Memory-Mapped I/O
Refer to the MMIO explanation in Section 13 for more information.
| Bit 5  | Reserved               |     |     |
| ------ | ---------------------- | --- | --- |
| Bit 6  | SWP NBL -Swap Nibbles  |     |     |
o = No nibble swap
1 = Swap nibbles in each byte of a linear memory address read or write operation
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
SYSTEM EXTENSION REGISTER DESCRIPTIONS 17-3

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Extended Memory Control 2 Register (EX_MCTL_2) (CR54)
| Read/Write  |     |     | Address: 375H, Index 54H  |     |
| ----------- | --- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7         | 6  5         | 4   | 3  2  | o     |
| --------- | ------------ | --- | ----- | ----- |
|           | M PARAMETER  |     | R     | R  R  |
| Bits 2-0  | Reserved     |     |       |       |
| Bits 7-3  | M PARAMETER  |     |       |       |
5-bit Value = (number of a-byte memory access cycles available for purposes other
than filling the display FIFO) -1. This parameter should be maximized within the con
straint that a display FIFO underrun is not allowed. See Section 7.4, Display Memory
Access Control, for more information.
Extended RAMDAC Control Register (EX_DAC_CT) (CR55)
| Read/Write  |     |     | Address: 375H, Index 55H  |     |
| ----------- | --- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7         | 6  5                                            | 4     | 3  2    | 1  0  |
| --------- | ----------------------------------------------- | ----- | ------- | ----- |
| TOFF      |                                                 | MS    | R  ENS  |       |
| VCLK      | R  R                                            | /Xll  | GIR     | R  R  |
| Bits 1-0  | Reserved                                        |       |         |       |
|           | Bit 2  ENB GIR -Enable General Input Port Read  |       |         |       |
o = RAMDAC reads enabled
1 = General Input Port read enabled
When this bit is set to 1, the STRD strobe for reading General Input Port data is gener
ated when 3CaH is read. The data is transmitted via GD[7:0) to AD[7:0) for PCI configu
rations and directly to SD[7:0) for VL-Bus configurations.
|     | Bit 3  Reserved                             |     |     |     |
| --- | ------------------------------------------- | --- | --- | --- |
|     | Bit 4  MS/X11 -Hardware Cursor MS/X11 Mode  |     |     |     |
o  = MS-Windows mode (Default)
1 =X 11-Windows mode
This bit select the type of decoding used for the 64x64x2 storage array of the hard
ware graphics cursor. See the Programming the Hardware Cursor section for a de
scription of the decoding.
| Bits 6-5  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
17-4 SYSTEM EXTENSION REGISTER DESCRIPTIONS

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
| Bit 7  | TOFF VCLK -Tri-State Off VCLK Output  |     |     |     |
| ------ | ------------------------------------- | --- | --- | --- |
o = Normal operation
1 = VCLK output is tri-stated off
External Sync Control 1 Register (EX_SYNC_11 (CR561
| Read/Write  |     | Address: 3?5H, Index 56H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
| 7  6   | 5  4                           | 3     | 2     | 1  0      |
| ------ | ------------------------------ | ----- | ----- | --------- |
|        | PRST                           | ESYN  | DIS   | DIS  RMT  |
| R  R   | R  ODDF                        | RN    | VSYN  | HSYN  ON  |
| Bit 0  | RMT ON -Remote Mode Operation  |       |       |           |
o  = Remote Mode operation off
1 = Remote Mode operation on. The VSYNC pin becomes the input for genlocking.
| Bit 1  | DIS HSYN -Tri-state off HSYNC  |     |     |     |
| ------ | ------------------------------ | --- | --- | --- |
o
= HSYNC output buffer tri-stated on
1 = HSYNC output buffer tri-stated off
| Bit 2  | DIS VSYN -Tri-state off VSYNC  |     |     |     |
| ------ | ------------------------------ | --- | --- | --- |
o = VSYNC output buffer tri-stated on
1 = VSYNC output buffer tri-stated off
| Bit 3  | ESYN RN -External Sync Vertical Counter Reset Select  |     |     |     |
| ------ | ----------------------------------------------------- | --- | --- | --- |
0= HorizontalNertical counter reset sync (Default)
1 = Vertical counter-only reset sync with genlocking
If bit 0 (Remote Mode) is set to 1, the falling edge of the VSYNC input signal resets
the vertical counter (every other frame in the interlaced mode) or both the horizontal
and vertical counters.
| Bit 4  | PRST ODDF -Preset Frame Select (-EVEN/ODD)  |     |     |     |
| ------ | ------------------------------------------- | --- | --- | --- |
o = Start with the Even Frame after a V-counter reset (Default)
1 = Start with the Odd Frame after a V-counter reset
This bit is effective only when bit 3 = 1 with remote mode on (bit 0 = 1).
| Bits 7-5  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
SYSTEM EXTENSION REGISTER DESCRIPTIONS  17-5

r-~  .
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
External Sync Control 2 Register (EX_SVNC_2) (CR57)
| Read/Write  |     | Address: 3?5H, Index 57H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6  | 5  4  | 3  2  |     |
| ----- | ----- | ----- | --- |
VSYN-RESET-ADJUST
| Bits 7-0  | VSYN-RESET-ADJUST  |     |     |
| --------- | ------------------ | --- | --- |
This specifies the vertical delay line number of the V-counter reset from the falling
edge of VSYNC. The set value must be not equal zero in Remote mode (bit 0 of CR56
set to 1).
Linear Address Window Control Register (LAW_CTL) (CR58)
| Read/Write  |     | Address: 375H, Index 58H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
I
| 7  6      | 5  4                                  | 3  2    | 1  0      |
| --------- | ------------------------------------- | ------- | --------- |
| RAS       | ENS                                   | LAT     | LAW-SIZE  |
| PRE  R    | R  LA                                 | DEL  R  | 1  0      |
| Bits 1-0  | LAW-SIZE -Linear Address Window Size  |         |           |
00 = 64 KBytes (Default)
01 = 1 MByte
10 = 2 MBytes
11 = 4 MBytes (Tri064 only -not a valid setting for the Tri032)
| Bit 2  | Reserved                                            |     |     |
| ------ | --------------------------------------------------- | --- | --- |
| Bit 3  | LAT DEL -Address Latch Delay Control (VL-Bus only)  |     |     |
o = Address latching is delayed one clock (T2 cycle)
1 = Address latching occurs in the T1 cycle
This bit is effective only when one decode wait state is selected by setting bit 4 of
CR40 to 1.
| Bit 4  | ENB LA -Enable Linear Addressing  |     |     |
| ------ | --------------------------------- | --- | --- |
o  = Disable linear addressing (Default)
1 = Enable linear addressing
Enabling linear addressing disables access to the AOOOH-AFFFH region unless bank
ing is enabled via bit 0 of CR31, the window size is set to 64K via bits 1-0 of this regis
ter and AOOOH is specified as the base in CR59-5A.
| Bits 6-5  | Reserved  |     |     |
| --------- | --------- | --- | --- |
17-6 SYSTEM EXTENSION REGISTER DESCRIPTIONS

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Bit 7  RAS PRE -RAS Pre-charge Time Adjust
o  = RAS pre-charge (high) time is defined by bit 3 of CR68
1 = RAS pre-charge (high) time is decreased by 0.5 MCLKs over that specified by bit 3
of CR68 and the corresponding RAS low time (bit 2 of CR68) is increased by 0.5
MCLKs. This leaves the total cycle time unchanged.
Linear Address Window Position Registers ILAW_POSIXI (CR59-5AI
Read/Write  Address: 3?5H, Index 59H-5AH
Power-On Default: OOOOH
CR59 contains the upper byte (15-8) and CR5A contains the lower byte (7-01. These registers specify
the Linear Address Window Position in 32-bit CPU address space. The Linear Address Window resides
on a 64KB, 1M  B, 2MB or 4MB (Trio64 only) memory boundary (size-aligned boundary). Some LSBs of
this register (illustrated by "xx. . xx" in the following table) are ignored because of the size-aligned
boundary scheme.
| LAW          | Linear Address Window     |             |             |
| ------------ | ------------------------- | ----------- | ----------- |
| Size         | Position Register Bitlsl  |             |             |
| 64KB  31-25  | 24  23  22                | 21  20  19  | 18  17  16  |
| 1MB  31-25   | 24  23  22                | 21  20  xx  | xx  xx  xx  |
|              |                           | xx  xx      | xx  xx      |
| 2MB  31-25   | 24  23  22                | 21          | xx          |
| 4MB  31-25   | 24  23  22                | xx  xx  xx  | xx  xx  xx  |
Bits 15--0  LlNEAR-ADDRESS-WINDOW-POSITION -LA Window Position Bits 31-16
16-bit Value = the linear address window position in 32-bit CPU address space.
Bits 31-23 are common with bits 31-23 of the base address programmed into the PCI
Base Address 0 register at address 10H-12H. Writes to these bits in either register will
also be written to the other. In general, the bits should be programmed via the PCI
configuration register. Writes to CR59 and CR5A should be read-modify-writes that
do not change bits 31-23.
If a 64K window is specified and bit 0 of CR31 is set to 1, bits 5-0 of CR6A specify the
64K page of display memory to be accessed through a 64K window located at the ad
dress specified in these registers.
SYSTEM EXTENSION REGISTER DESCRIPTIONS  17-7

••
| r   |     | S3 Trio32/Trio64 Integrated Graphics Accelerators  |     |
| --- | --- | -------------------------------------------------- | --- |
S3 Incorporated
General Output Port Register IGOUT_PORT)ICRSC)
| Read/Write  |     | Address: 375H, Index 5CH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6  | S  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
GENERAL-OUT-PORT
| Bits 7--0  | GENERAL-OUT-PORT  |     |     |
| ---------- | ----------------- | --- | --- |
These bits are user definable. For a PCI configuration, they are driven onto GD[7:0]
when written. For a VL-Bus configuration, they are driven onto SD[15:8] when writ
ten. Writing to this register automatically generates the external buffer strobe STWR.
Extended Horizontal Overflow Register IEXT_H_OVF)ICRSD)
| Read/Write  |     | Address: 3?5H, Index 5DH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6      | S  4                                       | 3  2      | 1  0     |
| --------- | ------------------------------------------ | --------- | -------- |
| BGT  SFF  | EHS  SHS                                   | EHB  SHB  | HDE  HT  |
| 8  8      | +32  8                                     | +64  8    | 8  8     |
| Bit 0     | HT 8 -Horizontal TotaIICRO) Bit 8          |           |          |
| Bit 1     | HDE 8 -Horizontal Display End (CR1) Bit 8  |           |          |
| Bit 2     | SHB 8 -Start Horizontal Blank (CR2) Bit 8  |           |          |
| Bit 3     | EHB+64 -End Horizontal Blank ICR3) + 64    |           |          |
o
= BLANK pulse unaffected
1 = BLANK pulse extended by 64 DCLKs
| Bit 4  | SHS 8 -Start Horizontal Sync Position ICR4) Bit 8  |     |     |
| ------ | -------------------------------------------------- | --- | --- |
| Bit S  | EHS+32 -End Horizontal Sync (CR5) + 32             |     |     |
o  = HSYNC pulse unaffected
1 = H~YNC pulse extended by 32 DCLKs
| Bit 6  | SFF 8 -Start FIFO Fetch (CR3B) Bit 8              |     |     |
| ------ | ------------------------------------------------- | --- | --- |
| Bit 7  | BGT 8 -Bus-Grant Terminate Position (CR5F) Bit 8  |     |     |
17-8 SYSTEM EXTENSION REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Extended Vertical Overflow Register (EXLV_ OVFI (CR5EI
| Read/Write  |     | Address: 3?5H, Index 5EH  |     |     |     |
| ----------- | --- | ------------------------- | --- | --- | --- |
Power-On Default: OOH
| 7  6   | 5  4                                          | 3   | 2    | 1    | 0   |
| ------ | --------------------------------------------- | --- | ---- | ---- | --- |
| LCM    | VRS                                           |     | SVB  | VDE  | VT  |
| R  10  | R  10                                         | R   | 10   | 10   | 10  |
| Bit 0  | VT 10 -Vertical Total (CR6) Bit 10            |     |      |      |     |
| Bit 1  | VDE 10 -Vertical Display End (CR12) Bit 10    |     |      |      |     |
| Bit 2  | SVB 10 -Start Vertical Blank (CR15) Bit 10    |     |      |      |     |
| Bit 3  | Reserved                                      |     |      |      |     |
| Bit 4  | VRS 10 -Vertical Retrace Start (CR10) Bit 10  |     |      |      |     |
| Bit 5  | Reserved                                      |     |      |      |     |
| Bit 6  | LCM 10 -Line Compare Position (CR18) Bit 10   |     |      |      |     |
| Bit 7  | Reserved                                      |     |      |      |     |
Extended Memory Control 3 Register (EXT-MCTL-31 (CR60)
| Read/Write  |     | Address: 3?5H, Index 60H  |     |     |     |
| ----------- | --- | ------------------------- | --- | --- | --- |
Power-On Default: OOH
| 7  6  | 543  |     | 2   |     | o   |
| ----- | ---- | --- | --- | --- | --- |
N(DISP-FETCH-PAGE)
| Bits 7-0  | N(DISP-FETCH-PAGE) -N Parameter  |     |     |     |     |
| --------- | -------------------------------- | --- | --- | --- | --- |
Value = (number of 4-byte (Tri032 or 1 MByte Tri064 configuration) or 8-byte (2 or 4
MBytes of memory for the Tri064) units written to the display FIFO before memory ac
cess is allowed to other requestors) -1. See Section 7.4, Display Memory Access Con
trol, for more information.
SYSTEM EXTENSION REGISTER DESCRIPTIONS 17-9

fl·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
External Sync Control 3 Register (EX-SYNC-3) (CR63)
| Read/Write  |     | Address: 3?5H, Index 63H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| Bits 3-0  | HSYNC-RESET-ADJST -HSYNC Reset Adjust  |     |     |
| --------- | -------------------------------------- | --- | --- |
This value specifies the number of character clocks the HSYNC reset in the slave is de
layed from the falling edge of the VSYNC input from the master during genlocking.
Remote mode (bit 0 of CRS6 set to 1) must be enabled for this field to take effect.
| Bits 7-4  | CHAR-CLK-RST-DELAY -Character clock reset delay  |     |     |
| --------- | ------------------------------------------------ | --- | --- |
This specifies the number of DCLKs to delay the resetting of the character clock at the
end of the scan line. This is used to sync the master and slave character clocks during
genlocking. Remote mode (bit 0 of CR56 set to 1) must be enabled for this field to
take effect.
Extended Miscellaneous Control Register (EXT-MISC-CTL) (CR6S)
| Read/Write  |     | Address: 3?5H, Index 6SH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
I
| 7  6      | 5  4                                            | 3  2    | 1  0  |
| --------- | ----------------------------------------------- | ------- | ----- |
|           | DLY BLANK                                       | ENB     |       |
| R  R      | R  1                                            | 0  3C3  | R  R  |
| Bits 1-0  | Reserved                                        |         |       |
| Bit 2     | ENB 3C3 -Enable 3C3H for Video Subsystem Setup  |         |       |
o  = 46EBH is the address for video subsystem setup
1 = 3C3H is the address for video subsystem setup
This bit allows the CPU to initialize a second video card.
| Bits 4-3  | DLK BLANK -Delay BLANK by DCLK (Tri032 only)  |     |     |
| --------- | --------------------------------------------- | --- | --- |
00 = No delay of BLANK
01 = Delay BLANK for 1 DCLK
10 = Delay BLANK for 2 DCLKs (required for color mode 12)
11 = Delay BLANK for 3 DCLKs
| Bits 7-5  | Reserved  |     |     |
| --------- | --------- | --- | --- |
17-10 SYSTEM EXTENSION REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Extended Miscellaneous Control 1 Register (EXT-MISC-1) (CR66)
| Read/Write  |     | Address: 3?5H, Index 66H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
5
|     | I :  | I :  I :  | I :  I :  I  |
| --- | ---- | --------- | ------------ |
R
| Bits 5-0  | Reserved                                    |     |     |
| --------- | ------------------------------------------- | --- | --- |
| Bit 6     | TOFF PADT -Tri-State Off Pixel Address Bus  |     |     |
o = Normal operation
1 = PA[15:0] are set to tri-state off
| Bit 7  | PCI DE -PCI bus disconnect enable  |     |     |
| ------ | ---------------------------------- | --- | --- |
o  = PCI bus disconnect disabled
1 = PCI bus disconnect enabled
Setting this bit to 1 allows PCI burst cycles to be interrupted if AD[1:0] *-OOb or if the
address during the burst goes outside the address ranges supported by the
Tri032ffri064.
Extended Miscellaneous Control 2 Register (EXT-MISC-2)(CR67)
| Read/Write  |     | Address: 375H, Index 67H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  I  6     | I  5  I  4                                 | 3  2                               | 1  0    |
| ----------- | ------------------------------------------ | ---------------------------------- | ------- |
| COLOR MODE  |                                            |                                    | VCLK    |
| 3  2        | 1  0                                       | R  R                               | R  PHS  |
| Bit 0       | VCLK PHS -VCLK Phase With Respect to DCLK  |                                    |         |
|             | 0= VCLK is 1800                            | out of phase with DCLK (inverted)  |         |
1 = VCLK is in phase with DCLK
| Bits 3-1  | Reserved  |     |     |
| --------- | --------- | --- | --- |
SYSTEM EXTENSION REGISTER DESCRIPTIONS  17-11

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Bits 7-4 COLOR MODE -RAMDAC Color Mode
0000 = Mode 0: 8-bit color, 1 pixelNCLK
0001 = Mode 8: 8-bit color, 2 pixelsNCLK
0011 = Mode 9: 1S-bit color, 1 pixelNCLK
0101 = Mode 10: 16-bit color, 1 pixelNCLK
0111 = Mode 12: 640x480x24-bit color (packed), 1 pixel/3 DCLKs (Tri032 only)
1101 = Mode 13: 24-bit color, 1 pixelNCLK
All other mode values are reserved.
Configuration 3 Register (CNFG-REG-3) (CR6S)
ReadIWrite Address: 3?SH, Index 68H
Power-On Default: Depends on Strapping
This is the third byte (along with CR36 and CR37) ofthe power-on strapping bits. PD[23:16] are sampled
on power-on reset and their states are written to bits 7-0 of this register. ASH must be written to CR39
to provide read/write access to this register.
I I I
7 6 5 4 3 2 1 0
UP MON-INF RAS- RAS- CAS/OE STR
ADD 3 2 1 PCG LOW WE DELAY
Bits 1-0 CAS,OE Stretch Time, WE delay
00 = approximately 6.S ns stretch (nominal), 2 units WE delay
01 = approximately S ns stretch (nominal), 1 unit WE delay
10 = approximately 3.S ns stretch (nominal), no WE delay
11 = no stretch or delay
This parameter adjusts the timing for the rising edges of the CAS and OE signals and
both falling and rising edges of WE. This allows stretching of the signal active time
for CAS and OE and delaying the entire WE signal to allow more time for valid pixel
data to be available. The delay time shown above is an approximation. It is affected
by both process and signal loading and must be measured for each design.
Bit 2 RAS-LOW -RAS Low Timing Select
o
=4.S MCLKs
1 = 3.S MCLKs
This parameter specifies the length of the RAS active time for a single row/column ac
cess. RAS may be held low longer to accommodate additional page mode accesses
to the same row.
Bit 3 RAS-PCG -RAS Precharge Timing Select
0= 3.S MCLKs
1 =2.S MCLKs
When RAS goes high to end a memory cycle, this parameter specifies the minimum
period it must be held high before beginning another memory access cycle.
17-12 SYSTEM EXTENSION REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
| Bits 6-4  | MON-INF -Monitor Information  |     |     |
| --------- | ----------------------------- | --- | --- |
The S3 BIOS uses these bits for monitor information.
| Bit 7  | UP ADD -Upper Address Decode/Memory Data Bus Size  |     |     |
| ------ | -------------------------------------------------- | --- | --- |
0= A" 32 bits of the system address bus are decoded (VL-Bus); Tri064 memory data
bus is 32 bits.
1 = SAUP input is decode of upper address lines (VL-Bus); Tri064 memory data bus is
32 bits (1 MByte of memory) or 64 bits (2 of more MBytes of memory).
Extended System Control 3 Register (EXT-SCTL-3)(CR69)
| Read/Write  |     | Address: 3?5H, Index 69H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6  | 5  4  | 321  | 0   |
| ----- | ----- | ---- | --- |
R
| R         | R  R                   | DISPLA Y-START-ADDRESS  |     |
| --------- | ---------------------- | ----------------------- | --- |
| Bits 3-0  | DISPLAY-START-ADDRESS  |                         |     |
This field contains the upper 4 bits (19-16) of the display start address, allowing ad
dressing of up to 4 MBytes of display memory. When a non-zero value is
programmed in this field, bits 5-4 of CR31 and 1-0 of CR51 (the old display start ad
dress bits) are ignored. The Tri032 only supports 2 MBytes of memory, so the upper
bit is not used.
| Bits 7-4  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Extended System Control 4 Register (EXT-SCTL-4)(CR6A)
| Read/Write  |     | Address: 3?5H, Index 6AH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6      | 5  4              | 3  2  | 1   |
| --------- | ----------------- | ----- | --- |
| R  R      | CPU-SASE-ADDRESS  |       |     |
| Bits 5-0  | CPU-SASE-ADDRESS  |       |     |
This field contains the upper 6 bits (19-14) of the CPU base address, allowing access
ing of up to 4 MBytes of display memory via 64K pages. When a non-zero value is
programmed in this field, bits 3-0 of CR35 and 3-2 of CR51 (the old CPU base address
bits) are ignored. Sit 0 of CR31 must be set to 1 to enable this field. If linear address
ing is enabled and a 64 KByte window is specified, these bits specify the 64K page to
be accessed at the base address specified in CR59 and CR5A. Otherwise, the base ad
dress is normally at AOOOH. The Tri032 only supports 2 MBytes of memory, so the up
per bit must always be O.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
SYSTEM EXTENSION REGISTER DESCRIPTIONS  17-13

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Extended BIOS Flag 3 Register (EBIOS-FLG3)(CR6B)
| ReadIWrite  | Address: 3?5H, Index 6BH  |     |
| ----------- | ------------------------- | --- |
Power-On Default: OOH
o
| 6   | 5  4  3  | 2  1  |
| --- | -------- | ----- |
EXT-BIOS-FLAG-REGISTER-3
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-3  |     |
| --------- | ------------------------- | --- |
This register is reserved for use by the S3 BIOS.
Extended BIOS Flag 4 Register (EBIOS-FLG4)(CR6C)
| ReadIWrite  | Address: 3?5H, Index 6CH  |     |
| ----------- | ------------------------- | --- |
Power-On Default: OOH
| 7  6  | 5  432  | 1  o  |
| ----- | ------- | ----- |
EXT-BIOS-FLAG-REGISTER-4
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-4  |     |
| --------- | ------------------------- | --- |
This register is reserved for use by the S3 BIOS.
17-14 SYSTEM EXTENSION REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Section 18: Enhanced Commands Register Descriptions
These registers support the Vision864 Enhanced drawing commands. Access to these registers is
enabled via bit 0 of the System Configuration register (CR40).
In the following register descriptions, 'R' stands for reserved (write = 0, read = undefined). See Appendix
A for a table listing each of the registers in this section and its page number.
Subsystem Status Register (SUBSYS_STAT)
| Read Only  | Address: 42E8H  |     |     |     |     |
| ---------- | --------------- | --- | --- | --- | --- |
Power-On Default: OOOOH
This read-only register provides information on interrupt status, monitor I.D. and the number of bits
per pixel. See the Subsystem Control (42E8H, Write Only) register for details on enabling and clearing
interrupts.
| 15  14  13                                      | 12  11  10  | 9  8  7    | 6  5  | 4  3  2      | 1  0      |
| ----------------------------------------------- | ----------- | ---------- | ----- | ------------ | --------- |
|                                                 |             | PXL        |       | FIFO  FIFO   | GE  VSY   |
| R  R  R                                         | R  R  R     | R  R  LNG  | R  R  | R  EMP  OVF  | BSY  INT  |
| Bit 0  VSY INT -Vertical Sync Interrupt Status  |             |            |       |              |           |
o = No interrupt
1 = Interrupt generated if enabled
| Bit 1  GE BSY -Graphics Engine Busy Interrupt Status  |     |     |     |     |     |
| ----------------------------------------------------- | --- | --- | --- | --- | --- |
o = No interrupt
1 = Interrupt generated if enabled
| Bit 2  FIFO OVF -Command FIFO Overflow Interrupt Status  |     |     |     |     |     |
| -------------------------------------------------------- | --- | --- | --- | --- | --- |
o
= No interrupt
1 = Interrupt generated if enabled
| Bit 3  FIFO EMP -Command FIFO Empty Interrupt Status  |     |     |     |     |     |
| ----------------------------------------------------- | --- | --- | --- | --- | --- |
o  = No interrupt
1 = Interrupt generated if enabled
| Bits 6-4  Reserved  |     |                                          |     |     |       |
| ------------------- | --- | ---------------------------------------- | --- | --- | ----- |
|                     |     | ENHANCED COMMANDS REGISTER DESCRIPTIONS  |     |     | 18-1  |

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
| Bit 7  PXL LNG -Pixel Length (# of bit planes)  |     |     |     |     |     |
| ----------------------------------------------- | --- | --- | --- | --- | --- |
o =4-bit
1 = 8-bit
This reflects the number of bit planes when bits 5-4 ofthe Extended System Control 1
register (CR50) are OOb.
| Bits 15-8  Reserved  |     |     |     |     |     |
| -------------------- | --- | --- | --- | --- | --- |
Subsystem Control Register (SUBSYS_CNTL)
| Write Only  | Address: 42E8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: OOOOH
This register allows each of several interrupt sources to be enabled or disabled. Interrupt status (Subsystem
Status (42EBH, Read Only) can be cleared. This register also controls the software reset of the graphics engine.
| I           | I           |          |       |                  |       |
| ----------- | ----------- | -------- | ----- | ---------------- | ----- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  | 4  3  2          | 1  0  |
| GE-RST      | FIFO-ENB    | GE  VSY  |       | FIFO  FIFO  GEB  | VSY   |
1  0  R  R  EMP  OVF  BSY  ENB  R  R  R  R  CLE  CLO  CLR  CLR
| Bit 0  VSY CLR -Clear Vertical Sync Interrupt Status  |     |     |     |     |     |
| ----------------------------------------------------- | --- | --- | --- | --- | --- |
0= No change
1 = Clear
| Bit 1  GEB CLR -Clear Graphics Engine Busy Interrupt Status  |     |     |     |     |     |
| ------------------------------------------------------------ | --- | --- | --- | --- | --- |
0= No change
1 = Clear
| Bit 2  FIFO CLO -Clear Command FIFO Overflow Interrupt Status  |     |     |     |     |     |
| -------------------------------------------------------------- | --- | --- | --- | --- | --- |
0= No change
1 = Clear
| Bit 3  FIFO CLE -Clear Command FIFO Empty Interrupt Status  |     |     |     |     |     |
| ----------------------------------------------------------- | --- | --- | --- | --- | --- |
0= No change
1 = Clear
| Bits 7-4  Reserved                              |     |     |     |     |     |
| ----------------------------------------------- | --- | --- | --- | --- | --- |
| Bit 8  VSY ENB -Vertical Sync Interrupt Enable  |     |     |     |     |     |
0= Disable
1 = Enable
| Bit 9  GE BSY-Graphics Engine Busy Interrupt Enable  |     |     |     |     |     |
| ---------------------------------------------------- | --- | --- | --- | --- | --- |
0= Disable
1 = Enable
1B-2 ENHANCED COMMANDS REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
| Bit 10  FIFO-ENS OVF -Command FIFO Overflow Interrupt Enable  |     |     |     |     |     |
| ------------------------------------------------------------- | --- | --- | --- | --- | --- |
0= Disable
1 = Enable
| Bit 11  FIFO-ENS EMP -Command FIFO Empty Interrupt Enable  |     |     |     |     |     |
| ---------------------------------------------------------- | --- | --- | --- | --- | --- |
0= Disable
1 = Enable
| Bits 13-12  Reserved                                |     |     |     |     |     |
| --------------------------------------------------- | --- | --- | --- | --- | --- |
| Bits 15-14  GE-RST -Graphics Engine Software Reset  |     |     |     |     |     |
00 = No change
01 = Graphics Engine enabled
10 = Reset
11 = Reserved
Advanced Function Control Register (ADVFUNC_CNTL)
| ReadM'rite  | Address: 4AE8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: OOOOH
This register enables or disables the enhanced display functions.
| 15  14  13                                  | 12  11  10  | 9  8  7  | 6  5  4     | 3  2   | 1  0     |
| ------------------------------------------- | ----------- | -------- | ----------- | ------ | -------- |
|                                             |             |          |             | ENH    | ENS      |
| R  R  R                                     | R  R  R     | R  R  R  | R  MIO  LA  | R  PL  | R  EHFC  |
| Bit 0  ENS EHFC -Enable Enhanced Functions  |             |          |             |        |          |
o
= Enable VGA and VESA planar (4 bits/pixel) modes
1 = Enable all other modes (Enhanced and VESA non-planar)
| Bit 1  Reserved                             |     |     |     |     |     |
| ------------------------------------------- | --- | --- | --- | --- | --- |
| Bit 2  ENH PL -Enhanced modes pixel length  |     |     |     |     |     |
o = 8 or more bits/pixel enhanced modes
1 = 4 bits/pixel enhanced modes
Sits 5-4 of CR50 are used to differentiate between 8-, 16-and 32-bit pixel lengths.
| Bit 3  Reserved                      |     |     |     |     |     |
| ------------------------------------ | --- | --- | --- | --- | --- |
| Bit 4  LA -Enable Linear Addressing  |     |     |     |     |     |
0= Disable linear addressing
1 = Enable linear addressing
This bit is ORed with bit 4 of CR58 and is equivalent to it.
ENHANCED COMMANDS REGISTER DESCRIPTIONS 18-3

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Bit 5 MIO -Enable Memory Mapped I/O (MMIO)
o = Disable MMIO
1 = Enable MMIO
This bit is ORed with bit 4 of CR53 and is equivalent to it.
Bits 15-6 Reserved
Current V-Position Register (CUR_V)
Read/Write Address: 82E8H
Power-On Default: Undefined
For line draws (solid, textured, short stroke or polyline), rectangle draws and image transfers, writing
to this register defines the vertical screen coordinate at which the first pixel will be drawn. For polygons
or trapezoids, this is the starting pixel vertical position forthe first of two edges to be drawn. For BitBLTs,
this is the vertical coordinate for the upper left hand corner of the destination. For PatBLT s, this is the
vertical coordinate of the upper left hand corner ofthe off-screen pattern. Reading this register produces
the current vertical drawing coordinate.
Bits 11-0 CURRENT V-POSITION
Bits 15-12 Reserved
Current V-Position 2 Register (CUR_ V2) (Trio64 Only)
Read/Write Address: 82EAH
Power-On Default: Undefined
For polygons or trapezoids, this is the starting pixel vertical position for the second of two edges to be
drawn. Reading this register produces the current vertical drawing coordinate for the second edge
being drawn.
Bits 11-0 CURRENT V-POSITION 2
Bits 15-12 Reserved
18-4 ENHANCED COMMANDS REGISTER DESCRIPTIONS

•..e .
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Current X-Position Register (CUR_X)
ReadNVrite Address: 86E8H
Power-On Default: Undefined
For line draws (solid, textured, short stroke or polyline), rectangle draws and image transfers, writing
to this register defines the horizontal screen coordinate at which the first pixel will be drawn. For
polygons or trapezoids, this is the starting pixel horizontal position for the first of two edges to be
drawn. For BitBL Ts, this is the horizontal coordinate for the upper left hand corner of the destination.
For PatBLT s, this is the horizontal coordinate of the upper left hand corner of the off-screen pattern.
Reading this register produces the current horizontal drawing coordinate.
Bits 11-0 CURRENT X-POSITION
Bits 15-12 Reserved
Current X-Position 2 Register (CUR_X2) (Trio64 Only)
ReadNVrite Address: 86EAH
Power-On Default: Undefined
For polygons or trapezoids, this is the starting pixel horizontal position for the second of two edges to
be drawn. Reading this register produces the current horizontal drawing coordinate for the second
edge being drawn.
Bits 11-0 CURRENT X-POSITION 2
Bits 15-12 Reserved
ENHANCED COMMANDS REGISTER DESCRIPTIONS 18-5

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Destination V-Position/Axial Step Constant Register IDESTV_AXSTPI
Read/Write Address: 8AE8H
Power-On Default: Undefined
For BitBLT s and PatBLTs, this register defines the vertical position for the top of the destination
rectangle. For solid and textured line draws, this is axial step constant used in the definition of the line.
For polylines, this is the ending vertical position for each line segment. For polygons and 4-point
trapezoids, this is the ending vertical position for the first of two edges to be drawn. For Bresenham
parameter trapezoids, this is the axial step constant for the first of two edges to be drawn.
Bits 11-0 DESTINATION V-POSITION
Bits 15-12 Reserved
LINE PARAMETER AXIAL STEP CONSTANT
Axial Step Constant = 2 * (minqdxl,ldyjllln other words, when drawing a line from point A to point B,
determine the change in the X coordinate from A to B and the change in the V coordinate from A to B.
Take the smaller of the two changes and multiply its absolute value by 2.
Bits 13-0 LINE PARAMETER AXIAL STEP CONSTANT
Bits 15-14 Reserved
V-Coordinate 2/Axial Step Constant 2 Register IV2_AXSTP21 (Trio64 OnlylV coordinate 2
Read/Write Address: 8AEAH
Power-On Default: Undefined
For polygons and 4-point trapezoids, this is the ending vertical position for the second of two edges
to be drawn. For Bresenham parameter trapezoids, this is the axial step constant for the second of two
edges to be drawn.
Bits 11-0 V-COORDINATE 2
Bits 15-12 Reserved
18-6 ENHANCED COMMANDS REGISTER DESCRIPTIONS

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Axial Step Constant = 2 * (min(jdxl,ldyll) In other words, when drawing a line from point A to point B,
determine the change in the X coordinate from A to B and the change in the V coordinate from A to B.
Take the smaller of the two changes and multiply its absolute value by 2.
Bits 13-0 LINE PARAMETER AXIAL STEP CONSTANT 2
Bits 15-14 Reserved
Destination X-Position/Diagonal Step Constant Register (DESTX_DIASTPI
Read/Write Address: 8EE8H
Power-On Default: Undefined
For BitBlT s and PatBlT s, this register defines the horizontal position for the left side ofthe destination
rectangle. For solid and textured line draws, this is diagonal step constant used in the definition ofthe
line. For polylines, this is the ending horizontal position for each line segment. For polygons and 4-point
trapezoids, this is the ending horizontal position for the first of two edges to be drawn. For Bresenham
parameter trapezoids, this is the diagonal step constant for the first of two edges to be drawn.
Bits 11-0 DESTINATION X-POSITION
Bits 15-12 Reserved
Diagonal Step Constant = 2 * [min(idxl,ldyll-max(jdxl,ldYlll. See the Destination V-Position/Axial Step
Constant (8AE8H) register for an explanation of the terms used in this equation.
Bits 13-0 LINE PARAMETER DIAGONAL STEP CONSTANT
Bits 15-14 Reserved
ENHANCED COMMANDS REGISTER DESCRIPTIONS 18-7

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
X-Coordinate 2 Register (X2) (Trio64 Only)X coordinate 2
ReadNVrite Address: 8EEAH
Power-On Default: Undefined
For polygons and 4-point trapezoids, this is the ending horizontal position for the second of two edges
to be drawn. For Bresenham parameter trapezoids, this is the diagonal step constant for the second of
two edges to be drawn.
Bits 11-0 X-COORDINATE 2
Bits 15-12 Reserved
Line Error Term Register (ERR3ERM)
ReadNVrite Address: 92E8H
Power-On Default: Undefined
This register specifies the initial error term for solid and textured line draws. For Bresenham parameter
trapezoids, this is the error term for the first of two edges to be drawn.
Error Term = 2 * min(jdxl,ldyl) -max(jdxl,ldyl-1 if the starting X < the ending X
Error Term = 2 * min(jdxl,ldyl) -max(jdxl,ldYI if the starting X ~ the ending X
See the Destination V-Position/Axial Step Constant (8AE8H) register for an explanation of the terms
used in these equations.
Bits 13-0 LINE PARAMETER/ERROR TERM
Bits 15-14 Reserved
18-8 ENHANCED COMMANDS REGISTER DESCRIPTIONS

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Line Error Term 2 Register IERR_TERM2)ITrio64 Only)
Read/Write Address: 92EAH
Power-On Default: Undefined
For Bresenham parameter trapezoids, this is the error term for the second of two edges to be drawn.
Error Term = 2 * minlldxl,ldyll-maxlldxl,ldyl-1 if the starting X < the ending X
Error Term = 2 * min(ldxl,ldyl) -maxlldxl,ldYI if the starting X ~ the ending X
See the Destination V-Position/Axial Step Constant (8AE8H) register for an explanation of the terms
used in these equations.
Bits 13-0 ERROR TERM 2
Bits 15-14 Reserved
Major Axis Pixel Count Register IMAJ_AXIS_PCNT)
Read/Write Address: 96E8H
Power-On Default: Undefined
This register specifies the length (in pixels) of the major (longest) axis for solid and textured lines and
the width for rectangles, image transfers, BitBLT s and PatBL Ts. For Bresenham parameter trapezoids,
this is the major axis length for the first of two edges to be drawn.
Bits 11-0 RECTANGLE WIDTH/LINE PARAMETER MAX
The value is the number of pixels along the major axis -1.
Bits 15-12 Reserved
ENHANCED COMMANDS REGISTER DESCRIPTIONS 18-9

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Major Axis Pixel Count 2 Register (MAJ_AXIS_PCNT2) (Trio64 Only)
Read/Write Address: 96EAH
Power-On Default: Undefined
For Bresenham parameter trapezoids, this is the major axis length for the second of two edges to be
drawn.
Bits 11-0 LINE PARAMETER MAX 2
The value is the number of pixels along the major axis -1.
Bits 15-12 Reserved
Graphics Processor Status Register (GP _STAT)
Read Only Address: 9AE8H
Power-On Default: Undefined
15 I 14 J 13 1 12 L 11 10 9 8 7 I 6 I 5 I 4 I 3 I 2 I 1 I 0
FIFO-STATUS (Trio64) HDW FIFO-STATUS
9 10 11 12 13 AE BSY R 1 2 3 4 5 6 7 8
Bits 7-0 FIFO-STATUS
In the following table for the Tri032, the leftmost column represents the value of FIFO
status bit 1 (register bit 7). Each column to the right represents the value of the next
higher FIFO status bit. A value of 0 read from any particular status bit position guaran
tees at least as many open FIFO slots as the number of that status bit. For example, if
a 0 is read from status bit 6 (register bit 2), there are at least 6 open FIFO slots. See
Bits 15-11 for a table for the Tri064.
00000000 = 8 FIFO slots available
00000001 =7 FIFO slots available
00000011 = 6 FIFO slots available
00000111 = 5 FIFO slots available
00001111 = 4 FIFO slots available
00011111 = 3 FIFO slots available
00111111 = 2 FIFO slots available
01111111 = 1 FIFO slots available
11111111 = 0 FIFO slots available
Bit 8 Reserved
18-10 ENHANCED COMMANDS REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
| Bit 9  HOW BSY -Hardware (Graphics Engine) Busy  |     |     |     |     |     |
| ------------------------------------------------ | --- | --- | --- | --- | --- |
0= not busy
1 = busy -graphics command is executing
| Bit 10  AE -All FIFO Slots Empty  |     |     |     |     |     |
| --------------------------------- | --- | --- | --- | --- | --- |
o
= At least one FIFO slot is occupied
1 = All FIFO slots empty
| Bits 15-11  FIFO-STATUS  |     |     |     |     |     |
| ------------------------ | --- | --- | --- | --- | --- |
These are the upper 5 bits of the FIFO status for the Trio64. See bits 7-0 for the inter
pretation. The following table applies only to the Trio64.
0000000000000 = 13 FIFO slots available
0000000000001 = 12 FIFO slots available
0000000000011 = 11 FIFO slots available
0000000000111 = 10 FIFO slots available
0000000001111 = 9 FIFO slots available
0000000011111 = 8 FIFO slots available
0000000111111 = 7 FIFO slots available
0000001111111 = 6 FIFO slots available
0000011111111 = 5 FIFO slots available
0000111111111 = 4 FIFO slots available
0001111111111 = 3 FIFO slots available
0011111111111 = 2 FIFO slots available
0111111111111 = 1 FIFO slots available
1111111111111 = 0 FIFO slots available
Drawing Command Register (CMD)
| Write Only  | Address: 9AE8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the drawing command and a number of associated control parameters.
| I  I    |             | I         | I  I  |          |          |
| ------- | ----------- | --------- | ----- | -------- | -------- |
| 15  14  | 13  12  11  | 10  9  8  | 7  6  | 5  4  3  | 2  1  0  |
CMD-TYPE  BYTE  CMD  BUS SIZE  WAIT  DRWG-DIR.  DIR  LAST  PX
PRA\i\
| 2  1                                             | 0  SWP  3                                  | 1  0  YES  | 2  1  | 0  YES  TYP  POF  | MD  = 1  |
| ------------------------------------------------ | ------------------------------------------ | ---------- | ----- | ----------------- | -------- |
| Bit 0  This bit must always be programmed to 1.  |                                            |            |       |                   |          |
| Bit 1                                            | PX MD -Select Across the Plane Pixel Mode  |            |       |                   |          |
o
= Single pixel transferred at a time
1 = Multiple pixels transferred at a time (across the plane mode)
| Bit 2  | LAST POF -Last Pixel Off  |     |     |     |     |
| ------ | ------------------------- | --- | --- | --- | --- |
0= Last pixel of line or vector draw will be drawn
1 = Last pixel of line or vector draw will not be drawn
|     |     | ENHANCED COMMANDS REGISTER DESCRIPTIONS  |     |     | 18-11  |
| --- | --- | ---------------------------------------- | --- | --- | ------ |

,,-
..fa
•
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Bit 3 DIR TYP -Select Radial Direction Type
o '7 x-y (axial)
1 = Radial
Bit 4 DRAW YES -Draw Pixel
o = Move the current position only -don't draw
1 = Draw pixel(s)
Bits 7-5 DRWG-DIR -Select Drawing Direction
In the following table, radial drawing angle is measured counterclockwise from the X
axis. For axial line draws, the line is drawn from left to right or a +X and from right to
left for a -X, down for a +Y and up for a -Yo X or Y maj specifies the longest axis.
7-5 Radial (bit 3 = 1) x-y (Axial -bit 3 =
0)
000 00 -Y,X maj,-X
001 450 -Y,Xmaj,+X
010 900 -Y,Ymaj,-X
all 1350 -Y,Ymaj,+X
100 1800 +Y,Xmaj,-X
101 2250 +Y,Xmaj,+X
110 2700 +Y,Ymaj,-X
111 3150 +Y,Ymaj.+X
Bit 8 WAIT YES -Wait for CPU Data
o
= Use Graphics Engine-based data
1 = Wait for data to be transferred to or from the CPU through the E2E8H port
Bits 10-9 BUS SIZE -Select image write (E2E8H, E2EAH) bus transfer width
00 = 8 bits
01 = 16 bits
10 = 32 bits. All doubleword bits beyond the image rectangle width are discarded.
Each line starts with a fresh doubleword. The current drawing position ends up
one pixel below the lower left hand corner of the image rectangle.
11 = 32 bits. (Tri032 8, 16 and 32 bits/pixel modes only) This setting applies only to
image transfers across the plane (each bit transferred is converted to a pixel).
Only bits from the end of the line width to the next byte boundary are discarded.
Data for the next line begins with the next byte. The current drawing position
ends up one pixel to the right of the top right corner of the image rectangle.
This parameter applies only to writing data through the Pixel Data Transfer (E2E8H,
E2EAH) registers (programmed I/O or memory-mapped I/O).
Bit 11 CMD 3 -Bit 3 of the command type. See Bits 15-13.
Bit 12 BYTE SWP -Enable Byte Swap
o
= High byte first, low byte second
1 = Low byte first, high byte second
18-12 ENHANCED COMMANDS REGISTER DESCRIPTIONS

II
S3 Trio32/Trio64 Integrated Graphics Accelerators I)
S3 Incorporated
Bits 15-13 CMD-TYPE -Select Command Type
Note: Bit 3 of the command type (the left or most significant) is bit 11 of this register.
0000 = NOP. This is used to set up short stroke vector drawing without writing a pixel.
0001 = Draw Line. If bit 3 of this register is cleared to 0, the axial step constant,
diagonal step constant and error term are used to draw the line. If bit 3 is set to
1, the line will be drawn at the angle specified by bits 7-5 and with a length in
pixels as specified by the Major Axis Pixel Count (96E8H) register.
0010 = Rectangle Fill. The position, width and height of a rectangle are defined. The
rectangle is filled with a solid color.
0011 = Polygon Fill Solid. (Tri064 only) The starting and ending coordinates for 2
lines of an n-sided polygon (n = 3 or more) are defined. Only the ending
coordinates are required for subsequent commands required to complete the
polygon. The polygon is filled with a single color.
0100 = 4-point Trapezoid Fill Solid. (Tri064 only) This is a special case of the polygon
fill solid command, with the top and bottom edges required to be horizontal.
0101 = Bresenham Parameter Trapezoidal Fill Solid. (Tri064 only) The starting
positions and Bresenham parameters (axial and diagonal step constants and
error terms) are defined for two lines that form the sides of a trapezoid. The top
and bottom lines must be horizontal. The trapezoid is filled with a single color.
0110 = BitBLT. A rectangle of defined location, width and height is moved to another
defined location in display memory.
0111 = PatBLT . An 8x8 pixel patterned rectangle of defined location is transferred
repeatedly to a destination rectangle of defined location, width and height. The
pattern copy is always aligned to an 8 pixel boundary and transfers continue
until the pattern is tiled into the entire destination rectangle. The starting X
coordinate of the source pattern rectangle should always be on an 8 pixel
boundary.
1001 = Polyline/2-Point Line. (Tri064 only) The starting and ending coordinates for a
line segment are defined. For subsequent polyline (connected) segments, only
the ending point need be programmed. If only a single segment is drawn, this is
called a 2-point line operation.
1101 = Bresenham Parameter Trapezoidal Fill Pattern. (Tri064 only) Same as the
Bresenham Parameter Trapezoidal Fill Solid except that the trapezoid is filled
with an 8x8 pixel pattern whose location is specified in the the Pattern Y (EAE8H)
and Pattern X (EAEAH) registers.
1100 = 4-point Trapezoidal Fill Pattern. (Tri064 only) Same as the 4-point Trapezoidal
Fill Solid except that the trapezoid is filled with an 8x8 pixel pattern whose
location is specified in the the Pattern Y (EAE8H) and Pattern X (EAEAH) registers.
1011 = Polygon Fill Pattern. (Tri064 only) Same as the Polygon Fill Solid except that
the polygon is filled with an 8x8 pixel pattern whose location is specified in the
the Pattern Y (EAE8H) and Pattern X (EAEAH) registers.
ENHANCED COMMANDS REGISTER DESCRIPTIONS 18-13

r-~  .
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Drawing Command 2 Register (CMD2) (Trio64 Only)
| Write Only  | Address: 9AEAH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
For Bresenham parameter trapezoid fills, this register defines the drawing direction for the second
edge to be drawn. The drawing direction for the first edge is specified in bits 7-5 of 9AE8H t
161
| 15  14  13  | 12  11  10  | 9  8  7  | 5  4  | 3  2  1  | 0   |
| ----------- | ----------- | -------- | ----- | -------- | --- |
DRWG-DIR 2.
| R  R  R                                           | R  R  R  | R  R  2  | 1  a  R  | R  R  R  | R   |
| ------------------------------------------------- | -------- | -------- | -------- | -------- | --- |
| Bits 4-0  Reserved                                |          |          |          |          |     |
| Bits 7-5  DRWG-DIR 2 -Select Drawing Direction 2  |          |          |          |          |     |
In the following table, the line is drawn from left to right or a +X and from right to left
for a -X, down for a +Y and up for a -Yo X or Y maj specifies the longest axis. Axial
drawing is specified in bit 3 of 9AE8H.
x-y (Axial -bit 3 = 0)
7-5
|     | 000  | -Y,Xmaj,-X  |     |     |     |
| --- | ---- | ----------- | --- | --- | --- |
|     | 001  | -Y,Xmaj.+X  |     |     |     |
|     | 010  | -Y,Ymaj,-X  |     |     |     |
|     | all  | -Y,Ymaj.+X  |     |     |     |
|     | 100  | +Y,Xmaj.-X  |     |     |     |
101
+Y,Xmai,+X
|                      | 110  | +Y,Ymai,-X  |     |     |     |
| -------------------- | ---- | ----------- | --- | --- | --- |
|                      | 111  | +Y,Ymaj,+X  |     |     |     |
| Bits 15-8  Reserved  |      |             |     |     |     |
18-14 ENHANCED COMMANDS REGISTER DESCRIPTIONS

r-~ .
|     |     | S3 Trio32/Trio64 Integrated Graphics Accelerators  |     |     |     |     |
| --- | --- | -------------------------------------------------- | --- | --- | --- | --- |
S3 Incorporated
Short Stroke Vector Transfer Register (SHORT_STROKE)
| Write Only  |     | Address: 9EE8H  |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
This register defines two short stroke vectors. These are drawn one at a time based on the setting of
the BYTE SWAP bit (bit 12) in the Command (9AE8H) register.
| I  I      |               | I  I  I       | I  I       |         | I  I          | I   |
| --------- | ------------- | ------------- | ---------- | ------- | ------------- | --- |
| 15  14    | 13  12        | 11  10  9  8  | 7  6       | 5  4    | 3  2  1       | 0   |
| DRWG-DIR  | DRW           | PIXEL-LENGTH  | DRWG-DIR.  | DRW     | PIXEL-LENGTH  |     |
| 2  1      | 0  -MV        | 3  2  1  0    | 2  1       | 0  -MV  | 3  2  1       | 0   |
| Bits 3-0  | PIXEL-LENGTH  |               |            |         |               |     |
Value = # pixels -1
| Bit 4  | DRW -MV -Draw Pixel  |     |     |     |     |     |
| ------ | -------------------- | --- | --- | --- | --- | --- |
o = Move current position only -don't draw
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
Bits 15-8  These bits duplicate bits 7-0 to define the second short stroke vector.
|     |     | ENHANCED COMMANDS REGISTER DESCRIPTIONS  |     |     |     | 18-15  |
| --- | --- | ---------------------------------------- | --- | --- | --- | ------ |

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Background Color Register (BKGD_COLOR)
| Read/Write  | Address: A2E8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
See the Enhanced Mode Bitmap Accessing Through the Graphics Engine section in the Functional
Description for a detailed explanation of how and when this color value is used when writing a pixel
to display memory.
| I  I        | I  I          | I  1  L  | J  l  I  | 1  1  I  | J   |
| ----------- | ------------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11 j  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
BACKGROUND COLOR
| I  I  | I  I  I  | I  I  I  | I  I  I  | I  I  I  | I   |
| ----- | -------- | -------- | -------- | -------- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
BACKGROUND COLOR
| Bits 31-0  BACKGROUND COLOR  |     |     |     |     |     |
| ---------------------------- | --- | --- | --- | --- | --- |
If bit 9 of BEE8_EH is set to 1 for programmed I/O (not MMIO), this becomes a 32-bit
register. If bit 9 of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode
with 16-bit registers, the upper and lower doublewords are read or written sequen
tially, depending on the state of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the
lower 16 bits are accessed. If RSF = 1, the upper 16 bits are accessed. The RSF flag
toggles automatically when a doubleword is read or written.
Foreground Color Register (FRGD_COLOR)
| Read/Write  | Address: A6E8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
See the Enhanced Mode Bitmap Accessing Through the Graphics Engine section in the Functional
Description for a detailed explanation of how and when this color value is used when writing a pixel
to display memory.
| I  I        | I  I  I     | I  I  I  | I  I  I  | I  I  I  | I   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | °   |
FOREGROUND COLOR
|     | L   | I  I  |     |     |     |
| --- | --- | ----- | --- | --- | --- |
31  I  30  I  29  I  28  I  27  26 -'  25  24  23  J  22  L 21  I  20  I  19  I  18  I  17  I  16
FOREGROUND COLOR
| Bits 31-0  FOREGROUND COLOR  |     |     |     |     |     |
| ---------------------------- | --- | --- | --- | --- | --- |
If bit 9 of BEEB_EH is set to 1 for programmed I/O (not MMIO), this becomes a 32-bit
register. If bit 9 of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode
with 16-bit registers, the upper and lower doublewords are read or written sequen
tially, depending on the state of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the
lower 16 bits are accessed. If RSF = 1, the upper 16 bits are accessed. The RSF flag
toggles automatically when a doubleword is read or written.
18-16 ENHANCED COMMANDS REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Bitplane Write Mask Register (WRT _MASK)
| ReadlWrite  | Address: AAE8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
0
15  1  14  1  13  1  12  1  11  1  10  1  9  1  8  1  7  1  6  1  5  1  4  1  3  1  2  1  1  .1
BIT-PLANE WRITE MASK
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| 1  1  | 1  1  1  | 1  1  1  | 1  1  1  | 1  1  1  | 1   |
| ----- | -------- | -------- | -------- | -------- | --- |
BIT-PLANE WRITE MASK
| Bits 31-0  BIT-PLANE WRITE MASK  |     |     |     |     |     |
| -------------------------------- | --- | --- | --- | --- | --- |
If bit i = 0, bitplane i is not updated
If bit i = 1, bitplane i is updated
Bits 31-0 control planes 31-0 respectively. If bit 9 of BEE8_EH is set to 1 for pro
grammed I/O (not MMIO), this becomes a 32-bit register. If bit 9 of BEE8_EH is cleared
to 0, this is two 16-bit registers. In 32 bpp mode with 16-bit registers, the upper and
lower doublewords are read or written sequentially, depending on the state of the
RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the lower 16 bits are accessed. If RSF =
1, the upper 16 bits are accessed. The RSF flag toggles automatically when a double
word is read or written.
Bitplane Read Mask Register (RD_MASK)
| ReadlWrite  | Address: AEE8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 1  1        | 1  1  1     | 1  1  1  | 1  1  1  | 1  1  1  | 1   |
BIT-PLANE READ MASK
31  30  29  28  27  26  23  24  23  22  21  20  19  18  17  16
| 1  1  | 1  1  1  | 1  1  1  | 1  1  1  | 1  1  1  | 1   |
| ----- | -------- | -------- | -------- | -------- | --- |
BIT-PLANE READ MASK
| Bits 31-0  BIT-PLANE READ MASK  |     |     |     |     |     |
| ------------------------------- | --- | --- | --- | --- | --- |
If bit i = 0, bitplane i is not used as a data source
If bit i = 1, bitplane i is used as a data source
Bit-plane read mask for BitBlT  and image transfer functions. Bits 31-0 control planes
31-0 respectively. If bit 9 of BEE8_EH is set to 1 for programmed I/O (not MMIO), this
becomes a 32-bit register. If bit 9 of BEE8_EH is cleared to 0, this is two 16-bit regis
ters. In 32 bpp mode with 16-bit registers, the upper and lower doublewords are read
or written sequentially, depending on the state of the RSF flag (bit 4 of BEE8H, Index
EH). If RSF = 0, the lower 16 bits are accessed. If RSF = 1, the upper 16 bits are ac
cessed. The RSF flag toggles automatically when a doubleword is read or written.
|     |     | ENHANCED COMMANDS REGISTER DESCRIPTIONS  |     |     | 18-17  |
| --- | --- | ---------------------------------------- | --- | --- | ------ |

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Color Compare Register ICOLOR_CMP)
| Read/Write  | Address: B2E8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
This register contains the color value that is compared against the current bitmap color if the color
compare option is turned on by setting bit 8 of the Pixel Control (BEE8H, Index OEH) to 1. Bit 7 of the
Pixel Control register determines whether a match or a non-match results in a pixel update.
| I  I        | I  I  I     | I  I  I  | I  I  I  | I  I  I  | I   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
COMPARISON COLOR WITH SOURCE
| I  I  | I  I  I  | I  I  I  | I  I  I  | I  I  I  | I   |
| ----- | -------- | -------- | -------- | -------- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
COMPARISON COLOR WITH SOURCE
| Bits 31-0  COMPARISON COLOR WITH SOURCE  |     |     |     |     |     |
| ---------------------------------------- | --- | --- | --- | --- | --- |
If bit 9 of BEE8_EH is set to 1 for programmed 1/0 (not MMIO), this becomes a 32-bit
register. If bit 9 of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode
with 16-bit registers, the upper and lower doublewords are read or written sequen
tially, depending on the state of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the
lower 16 bits are accessed. If RSF = 1, the upper 16 bits are accessed. The RSF flag
toggles automatically when a doubleword is read or written.
Background and Foreground Mix Registers IBKGD_MIX, FRGD_MIX)
| Read/Write  | Address: B6E8H (Background), BAE8H (Foreground)  |     |     |     |     |
| ----------- | ------------------------------------------------ | --- | --- | --- | --- |
Power-On Default: Undefined
See the Enhanced Mode Bitmap Accessing Through the Graphics Engine section in the Functional
Description for a detailed explanation of how and when these registers are used when writing a pixel
to display memory.
|                                      |             |          | I        | I  I      | I   |
| ------------------------------------ | ----------- | -------- | -------- | --------- | --- |
| 15  14  13                           | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1   | 0   |
|                                      |             |          | CLR-SRC  | MIX-TYPE  |     |
| R  R  R                              | R  R  R     | R  R  R  | 1  0  R  | 3  2  1   | 0   |
| Bits 3-0  MIX-TYPE -Select Mix Type  |             |          |          |           |     |
In the general case, a new color is defined. A logical operation such as AND or OR is
then performed between it and the current bitmap color. If the bitplane to be written
is enabled, the result of this logical "mix" is written to the bitmap as the new pixel
color. The following table shows the mix types available (! = logical NOT).
18-18 ENHANCED COMMANDS REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
|                                         | 0000  !current             |     | 1000  !current OR !new   |     |     |
| --------------------------------------- | -------------------------- | --- | ------------------------ | --- | --- |
|                                         | 0001  logical zero         |     | 1001  current OR !new    |     |     |
|                                         | 0010  logical one          |     | 1010  !current OR new    |     |     |
|                                         | 0011  leave current as is  |     | 1011  current OR new     |     |     |
|                                         | 0100  !new                 |     | 1100  current AND new    |     |     |
|                                         | 0101  current XOR new      |     | 1101  !current AND new   |     |     |
|                                         | 0110  !(current XOR new)   |     | 1110  current AND !new   |     |     |
|                                         | 0111  new                  |     | 1111  !current AND !new  |     |     |
| Bit 4  Reserved                         |                            |     |                          |     |     |
| Bits 6-5  CLR-SRC -Select Color Source  |                            |     |                          |     |     |
00 = Background color (the register is the color source)
01 = Foreground color (the register is the color source)
10 = CPU data (the CPU is the color source)
11 = Display memory (the display memory is the color source)
| Bits 15-7  Reserved  |     |     |     |     |     |
| -------------------- | --- | --- | --- | --- | --- |
Read Register Data Register IRD_REG_DTI
| Read Only  | Address: BEE8H  |     |     |     |     |
| ---------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
A read of this register produces a read of the register specified by bits 2-0 of the Read Register Select
(BEEBH, Index OFH) register. Each read of BEE8H causes the read index (bits 2-0 of BEE8H, Index OFH)
to increment by one. Registers BEE8H, Indices OH to OEH, 9AE8H, 42E8H and 46E8H can thus be rapidly
read by successive reads from BEEBH.
Note: Writes to the BEE8H registers (exceptthe read index register, Index OFH) are pipelined. Therefore,
to correctly read back a write to one of these registers, issue a NOP drawing command (a write to
9AE8H with bits 15-13 programmed to OOOb) immediately after the BEE8H register write. Next, write
the desired register index to BEE8H, Index OFH and read the data from BEE8H.
The BEE8H registers are written directly by writing to BEE8H with the appropriate register index in bits
15-12.
| 15  14  13  | 12  11  10  | 9  8  7                                  | 6  5  4  | 3  2  1  | o      |
| ----------- | ----------- | ---------------------------------------- | -------- | -------- | ------ |
|             |             | ENHANCED COMMANDS REGISTER DESCRIPTIONS  |          |          | 18-19  |

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Minor Axis Pixel Count Register (MIN_AXIS_PCNT)
Write Only Address: BEE8H, Index OH
Power-On Default: Undefined
This register specifies the height for rectangles, image transfers, BitBL Ts and PatBL Ts.
Bits 11-0 RECTANGLE HEIGHT
Value = (number of pixels in the height of the rectangle) -1
Bits 15-12 INDEX = OH
Top Scissors (SCISSORS_T)
Write Only Address: BEE8H, Index 1H
Power-On Default: Undefined
This register specifies the top of the clipping rectangle. It is the lowest Y value that will be drawn.
Bits 11-0 CLIPPING TOP LIMIT
Bits 15-12 INDEX = 1H
Left Scissors (SCISSORS_L1
Write Only Address: BEE8H, Index 2H
Power-On Default: Undefined
This register specifies the left side of the clipping rectangle. It is the lowest X value that will be drawn.
Bits 11-0 CLIPPING LEFT LIMIT
Bits 15-12 INDEX = 2H
18-20 ENHANCED COMMANDS REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Bottom Scissors (SCISSORS_B)
| Write Only  | Address: BEE8H, Index 3H  |     |     |     |     |
| ----------- | ------------------------- | --- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the bottom of the clipping rectangle. It is the highest Yvalue that will be drawn.
| Bits 11-0  CLIPPING BOTTOM LIMIT  |     |     |     |     |     |
| --------------------------------- | --- | --- | --- | --- | --- |
| Bits 15-12  INDEX = 3H            |     |     |     |     |     |
Right Scissors (SCISSORS_R)
| Write Only  | Address: BEE8H, Index 4H  |     |     |     |     |
| ----------- | ------------------------- | --- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the right side of the clipping rectangle. It is the highest X value that will be drawn.
| Bits 11-0  CLIPPING RIGHT LIMIT  |     |     |     |     |     |
| -------------------------------- | --- | --- | --- | --- | --- |
| Bits 15-12  INDEX = 4H           |     |     |     |     |     |
Pixel Control Register (PIX_CNTl)
| Write Only  | Address: BEE8H, Index OAH  |     |     |     |     |
| ----------- | -------------------------- | --- | --- | --- | --- |
Power-On Default: Undefined
See Bitmap Access Through the Graphics Engine in the Enhanced Mode Programming section for an
explanation of how and when bits 7-6 of this register are used when writing a pixel to display memory.
| 15  14  13  | 12  11  10  | 9  8  | 7  I  6  5  | 4  3  2  | 1  0  |
| ----------- | ----------- | ----- | ----------- | -------- | ----- |
DT-EX-SRC
| 1  0  1             | 0  R  R  | R  R                                     | 1  0  R  | R  R  R  | R  R   |
| ------------------- | -------- | ---------------------------------------- | -------- | -------- | ------ |
| Bits 5-0  Reserved  |          |                                          |          |          |        |
|                     |          | ENHANCED COMMANDS REGISTER DESCRIPTIONS  |          |          | 18-21  |

••
r S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad
Bits 7-6 DT-EX-SRC -Select Mix Register
00 = Foreground Mix register is always selected
01 = Reserved
10 = CPU data determines Mix register selected
11 = Display memory current value determines Mix register selected
Bits 11-8 Reserved
Bits 15-12 INDEX = OAH
Multifunction Control Miscellaneous 2 Register (MULT_MISC2)
Write Only Address: BEE8H. Index ODH
Power-On Default: DOOOH
Bits 2-0 DST-BASE -Destination Base Address
000 = First destination memory address is in the 1st MByte of display memory
001 = First destination memory address is in the 2nd MByte of display memory
010 = First destination memory address is in the 3rd MByte of display memory
011 = First destination memory address is in the 4th MByte of display memory
This field supersedes bits 1-0 of BEE8H. Index E if any of these 3 bits are set to 1. The
3-and 4-MByte settings apply only to the Tri064.
Bit 3 Reserved
Bits 6-4 SRC-BASE -Source Base Address
000 = First source memory address is in the 1st MByte of display memory
001 = First source memory address is in the 2nd MByte of display memory
010 = First source memory address is in the 3rd MByte of display memory
011 = First source memory address is in the 4th MByte of display memory
This field supersedes bits 3-2 of BEE8H. Index E if any of these three bits are set to 1.
The 3-and 4-MByte settings apply only to the Tri064.
Bits 11-7 Reserved
Bits 15-12 INDEX = ODH
18-22 ENHANCED COMMANDS REGISTER DESCRIPTIONS

83 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad
Multifunction Control Miscellaneous Register (MULT _ MISC)
| Write Only  | Address: BEE8H, Index OEH  |     |     |     |     |
| ----------- | -------------------------- | --- | --- | --- | --- |
Power-On Default: EOOOH
|                                                               |         |                  |                | I       | I        |
| ------------------------------------------------------------- | ------- | ---------------- | -------------- | ------- | -------- |
| 15  14  13                                                    | 12  11  | 10  9  8         | 7  6  5  4     | 3  2    | 1  0     |
|                                                               |         | CMR  ENB  SRC    | SLW  EXT  RSF  | SRC-BA  | DEST-BA  |
| 1  1  1                                                       | 0  R    | R  32B  CMP  NE  | RM  CLIP       | 21  20  | 21  20   |
| Bits 1-0  DEST-BA 21 20 -Destination Base Address Bits 21-20  |         |                  |                |         |          |
00 = First destination memory address is in the 1st MByte of display memory
01 = First destination memory address is in the 2nd MByte of display memory
10 = First destination memory address is in the 3rd MByte of display memory
11 = First destination memory address is in the 4th MByte of display memory
This field is superseded by bits 2-0 of BEE8H, Index D if any of the BEE8H Index D bits
is set to 1. The 3-and 4-MByte settings apply only to the Tri064.
Bits 3-2
SRC-BA 2120 -Source Base Address Bits 21-20
00 = First source memory address is in the 1st MByte of display memory
01 = First source memory address is in the 2nd MByte of display memory
10 = First source memory address is in the 3rd MByte of display memory
11 = First source memory address is in the 4th MByte of display memory
This field is superseded by bits 6-4 of BEE8H Index D if any of the BEE8H Index D bits
is set to 1. The 3-and 4-MByte settings apply only to the Tri064.
| Bit 4  RSF -Select Upper Word in 32 Bits/Pixel Mode  |     |     |     |     |     |
| ---------------------------------------------------- | --- | --- | --- | --- | --- |
0= Selects lower 16 bits for accesses to 32-bit registers in 32 bpp mode
1 = Selects upper 16 bits for accesses to 32-bit registers in 32 bpp mode
| Bit 5  EXT CLIP -Enable External Clipping  |     |     |     |     |     |
| ------------------------------------------ | --- | --- | --- | --- | --- |
o
= Only pixels inside the clipping rectangle are drawn
1 = Only pixels outside the clipping rectangle are drawn
| Bit 6  SLW RMW -Select Slow Read/Modify/Write Cycle  |     |     |     |     |     |
| ---------------------------------------------------- | --- | --- | --- | --- | --- |
o  = Fast Read/Modify/Write Cycle
1 = Slow Read/Modify/Write Cycle
When the Graphics Engines does a raster operation involving current screen data, it
must do a read/modify/write cycle. For a fast cycle, the read, modify and write each
take one MCLK. For a slow cycle, a wait state is inserted so that the entire process re
quires 4 MCLKs.
Bit 7  SRC NE -Don't Update Bitmap if Source Not Equal to Color Compare Color
0= Don't update current bitmap if the Color Compare (B2E8) register value is equal to
the color value of the source bitmap
1 = Don't update current bitmap if the Color Compare (B2E8) register value is not
equal to the color value of the source bitmap
This bit is only active if bit 8 of this register is set to 1.
ENHANCED COMMANDS REGISTER DESCRIPTIONS 18-23

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Bit 8 ENB CMP -Enable Color Compare
o
= Disable color comparison
1 = Enable color comparison
Bit 9 CMR 32B -Select 32-Bit Command Registers
0= Command registers (A2E8H, A6E8H, AAE8H, AEE8H, B2E8H) are 16-bit
1 = Command registers (A2E8H, A6E8H, AAE8H, AEE8H, B2E8H) are 32-bit. Byte and
word accesses cannot be made.
This bit applies to programmed I/O accesses only and is a don't care for MMIO ac
cesses.
Bits 11-10 Reserved = 0
Bits 15-12 INDEX = OEH
Read Register Select Register (READ_SEL)
Write Only Address: BEE8H, Index OFH
Power-On Default: Undefined
Bits 2-0 READ-REG-SEL -Read Register Select
When BEE8H is read, the value returned is determined by this read register index
according to the following:
0000 = BEE8H, Index OH
0001 = BEE8H, Index 1H
0010 = BEE8H, Index 2H
0011 = BEE8H, Index 3H
0100 = BEE8H, Index 4H
0101 = BEE8H, Index OAH
0110 = BEE8H, Index OEH
0111 = 9AE8H (Bits 15-13 of the read data are forced to 0)
1000 = 42E8H (Bits 15-12 of the read data are forced to 0)
1001 =4 6E8H
1010 = BEE8H, Index ODH
The read register index increments by one with each reading of BEE8H.
Bits 11-4 Reserved
Bits 15-12 INDEX = OFH
18-24 ENHANCED COMMANDS REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Pixel Data Transfer Register (PIX_TRANS)
Write Only Address: E2E8H
Power-On Default: Undefined
All data from the CPU to the Graphics Engine must pass through this register.
Bits 15-0 IMAGE WRITE DATA
Pixel Data Transfer· Extension Register (PIX_T RANS_EXT)
Write Only Address: E2EAH
Power-On Default: Undefined
This register is an extension of E2E8H for 32-bit operations.
Bits 15-0 IMAGE WRITE DATA
Pattern V (PAT_V) (Trio64 Only)
Read/Write Address: EAE8H
Power-On Default: Undefined
This register defines the vertical coordinate top edge of an 8x8 pixel pattern programmed into
off-screen memory. This is used with the Bresenham parameter trapezoidal fill pattern, trapezoidal
4-point trapezoid fill pattern and the polygon fill pattern command types.
Bits 11-0 PATIERN Y
Bits 15-12 Reserved
ENHANCED COMMANDS REGISTER DESCRIPTIONS 18-25

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Pattern X (PAT_X) (Trio64 Only)
ReadIWrite Address: EAEAH
Power-On Default: Undefined
This register defines the horizontal coordinate of the left side of an 8x8 pixel pattern programmed into
off-screen memory. This is used with the Bresenham parameter trapezoidal fill pattern, trapezoidal
4-point trapezoid fill pattern and the polygon fill pattern command types.
Bits 11-0 PATTERN X
Bits 15-12 Reserved
18-26 ENHANCED COMMANDS REGISTER DESCRIPTIONS

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Section 19: PCI Register Descriptions
The PCI specification defines a configuration register space. These registers allow device relocation,
device independent system address map construction and automatic configurations. The Trio32JT"rio64
provides a subset of these registers, which are described below.
The configuration register space occupies 256 bytes. When a configuration read or write command is
issued, the AD[7:0) lines contain the address of the register in this space to be accessed. The
Trio32rrrio64 supports or returns 0 for the first 64 bytes of this space.
In the following register descriptions, 'R' stands for reserved (write = 0, read = undefined). See Appendix
A for a table listing each of the registers in this section and its page number.
Vendor 10
Read Only Address: OOH
Power-On Default: 5333H
This read-only register identifies the device manufacturer.
15 14 13 12 11 10 5 4 3 2 1 o
Vendor ID
Bits 15-0 Vendor ID
This is hardwired to 5333H to identify S3 Incorporated.
PCI REGISTER DESCRIPTIONS 19-1

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Device ID
| Read Only  | Address: 02H  |     |     |     |     |
| ---------- | ------------- | --- | --- | --- | --- |
Power-On Default: 8811H
This read-only register contains the same value for either a Tri032 or Trio64. This allows the same BIOS to be
used with either chip. The type of chip used is determined from the CR2E register.
| 15  14  13  | 12  11  10  |     | 5  4  | 3  2  1  | o   |
| ----------- | ----------- | --- | ----- | -------- | --- |
Device ID
| Bits 15-0  Device ID  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
Command
| Read/Write  | Address: 04H  |     |     |     |     |
| ----------- | ------------- | --- | --- | --- | --- |
Power-On Default: OOOOH
This register controls which types of PCI cycles the Tri032/Tri064 can generate and respond to.
| 15  14  13                                   | 12  11  10  | 9  8  7  | 6  5  4    | 3  2  1  | 0    |
| -------------------------------------------- | ----------- | -------- | ---------- | -------- | ---- |
|                                              |             |          | DAC        | MEM      | I/O  |
| R  R  R                                      | R  R  R     | R  R  R  | R  SNP  R  | R  R     |      |
| Bit 0  I/O -Enable Response to I/O Accesses  |             |          |            |          |      |
o = Response to I/O space accesses is disabled
1 = Response to I/O space accesses enabled
| Bit 1  MEM -Enable Response to Memory Accesses  |     |     |     |     |     |
| ----------------------------------------------- | --- | --- | --- | --- | --- |
o  = Response to memory space accesses is disabled
1 = Response to memory space accesses enabled
| Bits 4-2  Reserved                               |     |     |     |     |     |
| ------------------------------------------------ | --- | --- | --- | --- | --- |
| Bit 5  DAC SNP -RAMDAC Register Access Snooping  |     |     |     |     |     |
o = Tri032ITrio64 claims and responds to all RAMDAC register access cycles
1 = Trio32/Trio64 performs RAMDAC register writes but does not claim the PCI cycle.
RAMDAC register read accesses are performed by the Trio32/Trio64.
| Bits 15-6  Reserved  |     |     |     |     |     |
| -------------------- | --- | --- | --- | --- | --- |
19-2 PCI REGISTER DESCRIPTIONS

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Status
ReadNVrite Address: 06H
Power-On Default: 0200H
Bits 8-0 Reserved
Bits 10-9 DEVSEL -Device Select Timing
01 = Medium DEVSEL timing. (hardwired)
Bits 15-11 Reserved
Class Code
Read Only Address: 08H
Power-On Default: 30000H
This register is hardwired to 3000000H to specify that the Trio32fTrio64 are VGA-compatible display
controllers.
15 I 14 I 13 I 12 I 11 I 10 I 9 I 8 7 I 6 I 5 I 4 I 3 121 1 I 0
PROGRAMMING INTERFACE REVISION ID
I I
31 I 30 I 29 I 28 I 27 I 26 I 25 24 23 I 22 I 21 I 20 I 19 I 18 I 17 16
BASE CLASS CODE SUB-CLASS
PCI REGISTER DESCRIPTIONS 19-3

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Base Address 0
| ReadNVrite  | Address: 12H (high)  | 10H (low)  |     |     |     |
| ----------- | -------------------- | ---------- | --- | --- | --- |
Power-On Default: 0000 OOOOH
This is a 32-bit register in PCI  configuration space that provides for address relocation. The
Tri032fTri064 maps the upper 9 bits of the register to the Linear Address Window Position registers
CR59-CR5A. Bit 23 maps to bit 7 of CR5A and bits [31 :241 map to bits 7-0 of CR59. Consequently, these
bits map to system address bits [31:231.
|                                     |             | 8        | 6     | 3  I          |       |
| ----------------------------------- | ----------- | -------- | ----- | ------------- | ----- |
| 15  14  13                          | 12  11  10  | 9  7     | 5     | 4  2          | 1  0  |
| R  R  R                             | R  R  R     | R  R  R  | R  R  | R  PREF       | MSI   |
|                                     |             |          |       | =0  TYPE =00  | =0    |
| Bit 0  MSI -Memory Space Indicator  |             |          |       |               |       |
o = Base registers map into memory space (hardwired)
| Bits 2-1  TYPE -Type of Address Relocation  |     |     |     |     |     |
| ------------------------------------------- | --- | --- | --- | --- | --- |
00 = Locate anywhere in 32-bit address space (hardwired)
| Bit 3  PREF -Prefetchable  |     |     |     |     |     |
| -------------------------- | --- | --- | --- | --- | --- |
o = Does not meet the prefetchable requirements (hardwired)
| Bits 22-4  Reserved         |     |     |     |     |     |
| --------------------------- | --- | --- | --- | --- | --- |
| Bits 31-23  BASE ADDRESS 0  |     |     |     |     |     |
See the description for the Linear Address Window Position registers (CR59, CR5A).
Writes to CR59 and CR5A will also update this field.
19-4 PCI REGISTER DESCRIPTIONS

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
BIOS ROM Base Address
ReadIWrite Address: 32H (high) 30H (low)
Power-On Default: OOOC OOOOH
This is a 32-bit register in PCI configuration space that provides for video BIOS ROM address relocation.
Bit 0 ADE -Address Decode Enable
o = Accesses to the BIOS ROM address space defined in this register are disabled
1 = Accesses to the BIOS ROM address space defined in this register are enabled
Bits 15-1 Reserved
Bits 31-16 BIOS ROM BASE ADDRESS
These are the upper 16 bits of the BIOS ROM address.
Interrupt Line
ReadIWrite Address: 3CH
Power-On Default: OOH
This register contains interrupt line routing information written by the POST program during power-on
initialization.
7 6 5 432 o
INTERRUPT LINE
Bits 7-0 INTERRUPT LINE
PCI REGISTER DESCRIPTIONS 19-5

II·
53 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Interrupt Pin
Read Only Address: 3DH
Power-On Default: 01 H
This register is hardwired to a value of 1 to specify that INTA is the interrupt pin used.
i 6 543 2 1 o
INTERRUPT PIN
Bits 7-0 INTERRUPT PIN
19-6 PCI REGISTER DESCRIPTIONS

fl·
53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Appendix A: Register Reference
This Appendix contains tables listing all the registers in each of categories corresponding to Sections
14-19 of this data book.
• VGA
• S3VGA
• System Control
• System Extension
• Enhanced Commands
• PCI Configuration Space
Within each table, registers are listed in order of increasing addresses/indices. Name, address, register
bit descriptions with read/write status and the page number of the detailed register description are
provided for each register. All addresses and indices are hexadecimal values.
REGISTER REFERENCE A-1

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
A.1  VGA REGISTERS
? = B for monochrome, D for color.
Table A·1.  VGA Registers
| Add  Index              |                                        | Register Name     | Description  |
| ----------------------- | -------------------------------------- | ----------------- | ------------ |
| ress  Bit!s)            |                                        | Bit DescriJ)tion  | Paae         |
| General or External Re  | isters                                 |                   |              |
| 3C2                     | Miscellaneous Output                   |                   | 14·1         |
| 0  W                    | Color emulation. Address based at 3Dx  |                   |              |
| 1  W                    | Enable CPU access of video memory      |                   |              |
| 3-2  W                  | Video DCLK select                      |                   |              |
| 4  W                    | Reserved                               |                   |              |
| 5  W                    | Select the high 64K page of memory     |                   |              |
| 6  W                    | Make HSYNC an active low signal        |                   |              |
| 7  W                    |                                        |                   |              |
Make VSYNC an active low signal
| 3CC   | Miscellaneous Output                   |     | 14·1  |
| ----- | -------------------------------------- | --- | ----- |
| 0  R  | Color emulation. Address based at 3Dx  |     |       |
1
R  Enable CPU access of video memory
| 3-2  R  | Video DCLK select.  |     |     |
| ------- | ------------------- | --- | --- |
| 4  R    | Reserved            |     |     |
Select the high 64K page of memory
| 5  R    |                                                        |     |       |
| ------- | ------------------------------------------------------ | --- | ----- |
| 6  R    | Make HSYNC an active low signal                        |     |       |
| 7  R    | Make VSYNC an active low signal                        |     |       |
| 37A     | Feature Control                                        |     | 14-2  |
| 2-0  W  | Reserved                                               |     |       |
| 3  W    | VSYNC is ORed with the internal display enable signal  |     |       |
| 7-4  W  | Reserved                                               |     |       |
| 3CA     | Feature Control                                        |     | 14·2  |
| 2-0  R  | Reserved                                               |     |       |
| 3  R    | VSYNC is ORed with the internal display enable signal  |     |       |
| 7-4  R  | Reserved                                               |     |       |
| 3C2     | Input Status 0                                         |     | 14-3  |
| 3-0  R  | Reserved                                               |     |       |
| 4  R    | The internal SENSE signal is a logical 1               |     |       |
| 6-5  R  | Reserved                                               |     |       |
| 7  R    | Vertical retrace interrupt to the CPU is pending       |     |       |
A-2 REGISTER REFERENCE

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table A·1. VGA Registers (continued)
| Add  Index    |                                                     | Register Name    | Description  |
| ------------- | --------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                 | Bit Description  | Page         |
| 37A           | Input Status 1                                      |                  | 14·3         |
| 0             | R  The display in not in active display mode        |                  |              |
| 1             | R  Reserved                                         |                  |              |
| 2             | R  Reserved =1                                      |                  |              |
| 3             | R  Vertical retrace period is active                |                  |              |
| 5-4           | R  Feedback of two color outputs for test purposes  |                  |              |
| 7-6           | R  Reserved                                         |                  |              |
Sequencer Registers
| 3C4  | Sequencer Index  |     | 14·4  |
| ---- | ---------------- | --- | ----- |
4-0  Index to the sequencer register to be accessed
RNV
| 7-5  | RNV  Reserved   |     |       |
| ---- | --------------- | --- | ----- |
| 3C5  | Sequencer Data  |     | 14-5  |
.-
7-0  Data to or from the sequencer register accessed
RNV
| 3C5  00  | Reset (SRO)  |     | 14·5  |
| -------- | ------------ | --- | ----- |
0  RNV  Asynchronous reset (not functional for the Trio32/Trio64)
1  Synchronous reset (not functional for the Trio32/Trio64)
RNV
| 7-2      | RNV  Reserved                          |     |       |
| -------- | -------------------------------------- | --- | ----- |
| 3C5  01  | Clocking Mode (SR1)                    |     | 14·6  |
| 0        | RNV  Character clocks are 8 dots wide  |     |       |
| 1        | RNV  Reserved                          |     |       |
2  RNV  Load the video serializers every second character clock
3  RNV  The internal character clock is 1/2 the DCLK frequency
| 4        | RNV  Load the video serializers every fourth character clock  |     |       |
| -------- | ------------------------------------------------------------- | --- | ----- |
| 5        | RNV  Screen is turned off                                     |     |       |
| 3C5  02  | Enable Write Plane (SR2)                                      |     | 14·6  |
3-0  RNV  Enables a CPU write to the corresponding color plane
| 7-4      | RNV  Reserved                |     |       |
| -------- | ---------------------------- | --- | ----- |
| 3C5  03  | Character Font Select (SR3)  |     | 14-7  |
Select Font B
| 4,1-0    | RNV                                                    |     |       |
| -------- | ------------------------------------------------------ | --- | ----- |
| 5,3-2    | RNV  Select Font A                                     |     |       |
| 7-6      | RNV  Reserved                                          |     |       |
| 3C5  04  | Memory Mode Control (SR4)                              |     | 14·8  |
| 0        | RNV  Reserved                                          |     |       |
| 1        | RNV  Memory access to 256K allowed (required for VGA)  |     |       |
2  Sequential addressing for CPU video memory accesses
RNV
| 3    | RNV  Module 4 addressing for CUP video memory accesses  |     |     |
| ---- | ------------------------------------------------------- | --- | --- |
| 7-4  | RNV  Reserved                                           |     |     |
REGISTER REFERENCE  A-3

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Table A-1. VGA Registers (continued)
| Add  Index    |                                                      | Register Name    | Description  |
| ------------- | ---------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                  | Bit Description  | Page         |
| 3C5  08       | Unlock Extended Sequencer (SR8)                      |                  | 14-9         |
| 7-0           | R/W  Load xxxx011 Ob to unlock SR9-SR18              |                  |              |
| 3C5  09       | R/W  Extended Sequencer Register 9                   |                  | 14-9         |
| 6-0           | R/W  Reserved                                        |                  |              |
| 7             | R/W  Memory~mapped I/O only_ (no PI 0)               |                  |              |
| 3C5  OA       | External Bus Request Control (SRA)                   |                  | 14-9         |
| 4-0           | R/W  P value                                         |                  |              |
| 5             | RJW  PD[63:0] not tri-stated (PD[31 :0] for Tri032)  |                  |              |
6  R/W  Pin 50 is RAS1 if CR36 2 is 1 (EDO memory) (Tri064 only)
| 7        | RJW  2 MCLK memory writes                                   |     |        |
| -------- | ----------------------------------------------------------- | --- | ------ |
| 3C5  OB  | Miscellaneous Extended Sequencer (SRB)                      |     | 14-10  |
| 0        | R/W  Use VCLKI for intemal dot clock functions (test only)  |     |        |
| 1        | R/W  Pixel data from VAFC latched by VCLKI                  |     |        |
| 3-2      | R/W  Reserved                                               |     |        |
| 7-4      | R/W  Specify color mode for feature connector input         |     |        |
| 3C5  00  | Extended Sequencer (SRD)                                    |     | 14-11  |
| 0        | R/W  Enable feature connector operation                     |     |        |
| 3-1      | R/W  Reserved                                               |     |        |
| 5-4      | R/W  HSYNC control for Green PC requirements                |     |        |
| 7-6      | R/W  VSYNC control for Green PC requirements                |     |        |
| 3C5  10  | MCLK Value Low (SR10)                                       |     | 14-12  |
| 4-0      | R/W  MCLK N-divider value                                   |     |        |
| 6-5      | R/W  MCLK R value                                           |     |        |
| 7        | R/W  Reserved                                               |     |        |
| 3C5  11  | MCLK Value High (SR11)                                      |     | 14-12  |
| 6-0      | R/W  MCLK M-divider value                                   |     |        |
| 7        | R/W  Reserved                                               |     |        |
| 3C5  12  | DCLK Value Low (SR12)                                       |     | 14-13  |
| 4-0      | R/W  DCLK N-divider value                                   |     |        |
6-5
R/W  DCLK R value
| 7        | R/W  Reserved           |     |        |
| -------- | ----------------------- | --- | ------ |
| 3C5  13  | DCLK Value High (SR13)  |     | 14-13  |
6-0  DCLK M-divider value
R/W
| 7   | R/W  Reserved  |     |     |
| --- | -------------- | --- | --- |
A-4 REGISTER REFERENCE

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table A-1. VGA Registers (continued)
| Add  Index    |                                                    | Register Name    | Description  |
| ------------- | -------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                | Bit Description  | Page         |
| 3C5  14       | CLKSYN Control 1 (SR14)                            |                  | 14-14        |
| 0             | RNJ  DCLK PLL powered down (test only)             |                  |              |
| 1             | RNJ  MCLK PLL powered down (test only)             |                  |              |
| 3             | RNJ  Test MCLK (test only)                         |                  |              |
| 4             | RNJ  Clear clock synthesizer counters (test only)  |                  |              |
| 5             | RNJ  Pin 146 tri-stated                            |                  |              |
| 6             | RNJ  MCLK is input on pin 146 (test only)          |                  |              |
RNJ  DCLK is input on pin 156 (test only)
| 3C5  15  | CLKSYN Control 2 (SR15)                         |     | 14-15  |
| -------- | ----------------------------------------------- | --- | ------ |
| 0        | RNJ  Load new MCLK frequenc}'                   |     |        |
| 1        | RNJ  Load new DCLK frequency                    |     |        |
| 2        | RNJ  MCLK output on pin 147 (test only)         |     |        |
| 3        | RNJ  VCLK direction determined by EVCLK         |     |        |
| 4        | RNJ  Divide DCLK by 2                           |     |        |
| 5        | RNJ  Load MCLK and DCLK PLL values immediately  |     |        |
| 6        | RNJ  Invert DCLK                                |     |        |
| 7        | RNJ  Enable 2 MCLK memory writes                |     |        |
| 3C5  16  | CLKSYN Test High (SR16)                         |     | 14-16  |
| 7-0      | RNJ  Reserved                                   |     |        |
14-17
| 3C5  17  | CLKSYN Test High (SR17)  |         |        |
| -------- | ------------------------ | ------- | ------ |
| 7-0      | RNJ  Reserved            |         |        |
| 3C5  18  | RAMDAC/CLKSYN Control    | (SR18)  | 14-17  |
0  RAMDAC test counter enabled (test only]
RNJ
| 1   | RNJ  Reset RAMDAC test counter                          |     |     |
| --- | ------------------------------------------------------- | --- | --- |
| 2   | RNJ  Place red data on internal data bus (test only)    |     |     |
| 3   | RNJ  Place green data on internal data bus (test only)  |     |     |
| 4   | RNJ  Place blue data on internal data bus (test only)   |     |     |
| 5   | RNJ  Power-down RAMDAC                                  |     |     |
| 6   | RNJ  Select 1 cycle LUT write                           |     |     |
| 7   | RNJ  RAMDAC clock doubled mode enabled                  |     |     |
CRT Controller Registers
| 374      | CRT Controller Index                             |     | 14-19  |
| -------- | ------------------------------------------------ | --- | ------ |
| 7-0      | RNJ  Index to the CRTC register to be accessed   |     |        |
| 375      | CRT Controller Data                              |     | 14-19  |
| 7-0      | RNJ  Data to or from the CRTC register accessed  |     |        |
| 375  00  | Horizontal Total (CRO)                           |     | 14-20  |
| 7-0      | RNJ  Number of characters in a line -5           |     |        |
| 375  01  | Horizontal Display End (CR1)                     |     | 14-20  |
7-0  RNJ  One less than the total number of displayed characters
REGISTER REFERENCE  A-5

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table A-1. VGA Registers (continued)
| Add  Index    |      | Register Name    | Description  |
| ------------- | ---- | ---------------- | ------------ |
| ress  Bit(s}  | R/W  | Bit Description  | Page         |
Start Horizontal Blank (CR2)
| 375  02  |                                                        |     | 14-21  |
| -------- | ------------------------------------------------------ | --- | ------ |
| 7-0      | RNV  Character count where horizontal blanking starts  |     |        |
| 375  03  | End Horizontal Blank (CR3)                             |     | 14-21  |
4-0  End position of horizontal blanking
RMJ
| 6-5      | RMJ  Display enable skew in character clocks           |     |        |
| -------- | ------------------------------------------------------ | --- | ------ |
| 7        | RMJ  Reserved                                          |     |        |
| 375  04  | Start Horizontal Sync Position (CR4)                   |     | 14-22  |
| 7-0      | RNV  Character count where HSYNC goes active           |     |        |
| 375  05  | End Horizontal Sync Position (CR5)                     |     | 14-22  |
| 4-0      | RMJ  Position where HSYNC Qoes inactive                |     |        |
| 6-5      | RMJ  Horizontal retrace end delay in character clocks  |     |        |
| 7        | RMJ  End horizontal blankina bit 5                     |     |        |
| 375  06  | Vertical Total (CR6)                                   |     | 14-23  |
| 7-0      | RMJ  Number of lines -2                                |     |        |
| 375  07  | CRTC Overflow (CR7)                                    |     | 14-23  |
| 0  ,     | RMJ  Vertical total bit 8                              |     |        |
RMJ  Vertical display end bit 8
| 2   | RMJ  Vertical retrace start bit 8  |     |     |
| --- | ---------------------------------- | --- | --- |
| 3   | RMJ  Start vertical blank bit 8    |     |     |
RNV
4  Line compare bit 8
| 5        | RMJ  Vertical total bit 9                   |     |        |
| -------- | ------------------------------------------- | --- | ------ |
| 6        | RMJ  Vertical display end bit 9             |     |        |
| 7        | RMJ  Vertical retrace start bit 9           |     |        |
| 375  08  | Preset Row Scan (CR8)                       |     | 14-24  |
| 4-0      | RMJ  Line where first character row begins  |     |        |
RNV
6-5  Number of bytes to pan horizontally
| 7        | RNV  Reserved                           |     |        |
| -------- | --------------------------------------- | --- | ------ |
| 375  09  | Maximum Scan Line (CR9)                 |     | 14-24  |
| 4-0      | RMJ  Character heiQht in scan lines -,  |     |        |
| 5        | RMJ  Start vertical blank bit 9         |     |        |
| 6        | RMJ  Line compare bit 9                 |     |        |
7  Double scanninQ (repeat each line) enabled
RMJ
| 375  OA  | Cursor Start Scan Line (CRA)                         |     | 14-25  |
| -------- | ---------------------------------------------------- | --- | ------ |
| 4-0      | RMJ  Cursor starting line within the character cell  |     |        |
5  Turns off the cursor
RMJ
| 7-6  | RMJ  Reserved  |     |     |
| ---- | -------------- | --- | --- |
A-6 REGISTER REFERENCE

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table A-1. VGA Registers (continued)
| Add  Index    |                                                     | Register Name    | Description  |
| ------------- | --------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                 | Bit Description  | Page         |
| 375  OB       | Cursor End Scan Line (CRB                           |                  | 14-25        |
| 4-0           | RNIJ  Cursor endinq line within the character cell  |                  |              |
| 6-5           | RNIJ  Cursor skew to riqht in characters            |                  |              |
| 7             | RNIJ  Reserved                                      |                  |              |
| 375  OC       | Start Address High (CRC)                            |                  | 14-26        |
| 7-0           | RNIJ  Bits 15-8 of the display start address        |                  |              |
| 375           | Start Address Low (CRD)                             |                  | 14-26        |
OD
| 7-0  | RNIJ  Bits 7-0 of the display start address  |     |     |
| ---- | -------------------------------------------- | --- | --- |
375  OE  Cursor Location Address High (& Hardware Cursor  14-26
Foreground Color in Enhanced Mode) (CRE)
| 7-0  | RNIJ  Bits 1 5-8 of the cursor location start address  |     |     |
| ---- | ------------------------------------------------------ | --- | --- |
375  OF  Cursor Location Address Low (& Hardware Cursor  14-26
Background Color in Enhanced Mode) (CRF)
| 7-0      | RNIJ  Bits 7-0 of the cursor location start address  |     |        |
| -------- | ---------------------------------------------------- | --- | ------ |
| 375  10  | Vertical Retrace Start (CR10                         |     | 14-27  |
7-0  Vertical retrace start in scan lines
RNIJ
| 375  11  | Vertical Retrace End (CR11)               |     | 14-27  |
| -------- | ----------------------------------------- | --- | ------ |
| 3-0      | RNIJ  Vertical retrace end in scan lines  |     |        |
Clear the vertical retrace interrupt flip-flop
| 4   | RNIJ                                               |     |     |
| --- | -------------------------------------------------- | --- | --- |
| 5   | RNIJ  Disable vertical interrupts                  |     |     |
| 6   | RNIJ  Five RAM refresh cycles per horizontal line  |     |     |
7  Lock writes to CRO-CR7
RNIJ
| 375  12  | Vertical Display End (CR12)                 |     | 14-28  |
| -------- | ------------------------------------------- | --- | ------ |
| 7-0      | RNIJ  Number of scan lines of active video  |     |        |
| 375  13  | Offset (CR13)                               |     | 14-28  |
7-0  RNIJ  Memory start address jump from one scan line to the next
| 375  14  | Underline Location (CR14)                          |     | 14-29  |
| -------- | -------------------------------------------------- | --- | ------ |
| 4-0      | RNIJ  Horizontal scan line where underline occurs  |     |        |
5  RNIJ  Memory address counter increment is 4 character clocks
| 6        | RNIJ  Memory accessed as doublewords                       |     |        |
| -------- | ---------------------------------------------------------- | --- | ------ |
| 7        | RNIJ  Reserved                                             |     |        |
| 375  15  | Start Vertical Blank (CR15)                                |     | 14-29  |
| 7-0      | RNIJ  Horizontal scan line where vertical blanking starts  |     |        |
| 375  16  | End Vertical Blank (CR16                                   |     | 14-30  |
| 7-0      | RNIJ  Horizontal scan line where vertical blanking ends    |     |        |
REGISTER REFERENCE  A-7

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Table A-1. VGA Registers (continued)
| Add  Index    |                           | Register Name    | Description  |
| ------------- | ------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                       | Bit Description  | Page         |
| 375  17       | CRTC Mode Control (CR17)  |                  | 14-30        |
,
| 0   | RMJ  Enable bank 2 mode for CGA emulation  |     |     |
| --- | ------------------------------------------ | --- | --- |
RMJ  Enable bank 4 mode for CGA emulation
| 2   | RMJ  Use horizontal retrace clock divided by 2  |     |     |
| --- | ----------------------------------------------- | --- | --- |
| 3   | RMJ  Enable count by 2 mode                     |     |     |
| 4   | RMJ  Reserved                                   |     |     |
5  Enable CGA mode address wrap
RMJ
| 6           | RMJ  Use byte address mode                               |     |        |
| ----------- | -------------------------------------------------------- | --- | ------ |
| 7           | RMJ  Horizontal and vertical retrace siQnals enabled     |     |        |
| 375  18     | Line Compare (CR18)                                      |     | 14-32  |
| 7-0         | RMJ  Line at which memory address counter cleared to 0   |     |        |
| 375  22     | CPU latch Data (CR22)                                    |     | 14-32  |
| 7-0         | R  Value in the CPU latch in the graphics controller     |     |        |
| 375  24,26  | Attribute Controller Flag/Index                          |     | 14-33  |
| 5-0         | R  Value of the attribute controller index data at 3COH  |     |        |
| 6           | R  Reserved                                              |     |        |
| 7           | R  State of inverted internal address flip-flop          |     |        |
Graphics Controller Registers
| 3CE  | Graphics Controller Index  |     | 14-34  |
| ---- | -------------------------- | --- | ------ |
3-0  RMJ  Index to the Qraphics controller register to be accessed
| 7-4  | RMJ  Reserved             |     |        |
| ---- | ------------------------- | --- | ------ |
| 3CF  | Graphics Controller Data  |     | 14-34  |
7-0  RMJ  Data to or from the graphics controller reQister accessed
| 3CF  00  | Set/Reset (GRO)                                    |     | 14-35  |
| -------- | -------------------------------------------------- | --- | ------ |
| 3-0      | RMJ  Color value for CPU memory writes             |     |        |
| 7-4      | RMJ  Reserved                                      |     |        |
| 3CF  01  | Enable Set/Reset (GR1)                             |     | 14-35  |
| 3-0      | RMJ  Enable planes for writing GRO data            |     |        |
| 7-4      | RMJ  Reserved                                      |     |        |
| 3CF  02  | Color Compare (GR2)                                |     | 14-36  |
| 3-0      | RMJ  Reference color for color compare operations  |     |        |
7-4  Reserved
RMJ
| 3CF  03  | Raster Operation/Rotate Counter (GR3)  |     | 14-36  |
| -------- | -------------------------------------- | --- | ------ |
2-0  RMJ  Number of right rotate positions for a CPU memory write
4-3  Select raster operation (logical function)
RMJ
| 7-5      | RMJ  Reserved            |     |        |
| -------- | ------------------------ | --- | ------ |
| 3CF  04  | Read Plane Select (GR4)  |     | 14-37  |
RMJ  Select planes for reading
'-0
| 7-2  | RMJ  Reserved  |     |     |
| ---- | -------------- | --- | --- |
A-8 REGISTER REFERENCE

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad
Table A-1. VGA Registers (continued)
| Add  Index  |     | Register Name  |     |
| ----------- | --- | -------------- | --- |
Description
| ress  Bit(s)  | R/W                             | Bit Description  | Page   |
| ------------- | ------------------------------- | ---------------- | ------ |
| 3CF  05       | Graphics Controller Mode (GR5)  |                  | 14-38  |
| 1-0           | RfIN  Select write mode         |                  |        |
2  RfIN  Reserved
3  RfIN  Enable read compare operation
4  RfIN  Select odd/even addressinQ
5  RfIN  Select odd/even shift mode
6  R{IN  Select 256 color shift mode
7  RfIN  Reserved
| 3CF  06  | MemorvMallMode Control (GR6)  |     | 14-39  |
| -------- | ----------------------------- | --- | ------ |
0  RfIN  Select graphics mode memory addressing
1  RfIN  Chain odd/even planes
| 3-2      | RfIN  Select memory mapping                         |     |        |
| -------- | --------------------------------------------------- | --- | ------ |
| 7-4      | RfIN  Reserved                                      |     |        |
| 3CF  07  | Color Don't Care (GR7)                              |     | 14-40  |
| 3-0      | RfIN  Select color plane used for color comparison  |     |        |
| 7-4      | RfIN  Reserved                                      |     |        |
| 3CF  08  | Bit Mask (GR8)                                      |     | 14-40  |
7-0  RfIN  Each bit is a mask for the correspondinQ memory plane bit
Attribute Registers
| 3CO  | Attribute Controller Index  |     | 14-41  |
| ---- | --------------------------- | --- | ------ |
4-0  RfIN  Index to the attribute controller register to be accessed
5  RfIN  Enable video display
| 7-6    | RfIN  Reserved             |     |        |
| ------ | -------------------------- | --- | ------ |
| 3C1/0  | Attribute Controller Data  |     | 14-42  |
7-0  RfIN  Data to or from the attribute controller register accessed
| 3C1/0  OO-OF  | Palette Register (ARG-ARF)    |     | 14-42  |
| ------------- | ----------------------------- | --- | ------ |
| 5-0           | RfIN  Color value             |     |        |
| 7-6           | RfIN  Reserved                |     |        |
| 3C1/0  10     | Attribute Mode Control (AR10  |     | 14-43  |
0  RfIN  SelectJjraphics mode
1  RfIN  Select monochrome display
2  RfIN  Enable line graphics characters
3  RfIN  Enable blinking
4  RfIN  Reserved
5  RfIN  Enable top panning
6  RfIN  Select 256 color mode
7  R{IN  Bits 5-4 of video output come from AR 14 1-0
| 3C1/0  | Border Color (AR11)  |     | 14-44  |
| ------ | -------------------- | --- | ------ |
11
| 7-0  | RfIN  Border color value  |     |     |
| ---- | ------------------------- | --- | --- |
REGISTER REFERENCE A-9

,,-
..ta
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Table A·1. VGA Registers (continued)
| Add  Index    |                                                         | Register Name    | Description  |
| ------------- | ------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | RIW                                                     | Bit Description  | Page         |
| 3C1/0  12     | Color Plane Enable (AR12)                               |                  | 14·44        |
| 3-0           | R/W  Display plane enable                               |                  |              |
| 5-4           | R/W  Select inputs to bits 5-4 of 3?AH                  |                  |              |
| 7-6           | R/W  Reserved                                           |                  |              |
| 3C1/0  13     | Horizontal Pixel Panning (AR13)                         |                  | 14-45        |
| 3-0           | R/W  Number of pixels to shift the display to the left  |                  |              |
| 7-4           | R/W  Reserved                                           |                  |              |
| 3C1/0  14     | Pixel Padding (AR14)                                    |                  | 14-46        |
| 1-0           | RfW  Bits 5-4 of the video output if ARlO 7 = 1         |                  |              |
| 3-2           | R/W  Bits 7-6 of the video output                       |                  |              |
| 7-4           | R/W  Reserved                                           |                  |              |
Setu I) Registers
| 102  | Setup Option Select  |     | 14-47  |
| ---- | -------------------- | --- | ------ |
0  R/W  Chip responds to commands, addresses and data
| 7-1   | R/W  Reserved           |     |        |
| ----- | ----------------------- | --- | ------ |
| 46E8  | Video Subsystem Enable  |     | 14·48  |
| 2-0   | W  Reserved             |     |        |
3  W  Enable video I/O and memory address decoding
Put chip in setup mode
4  W
| 7-5  | W  Reserved  |     |     |
| ---- | ------------ | --- | --- |
RAMDAC Registers
|     | DACMask  |     | 14-49  |
| --- | -------- | --- | ------ |
3C6
| 7-0  | R/W  Pixel read mask                     |     |        |
| ---- | ---------------------------------------- | --- | ------ |
| 3C7  | DAC Read Index                           |     | 14-49  |
| 7-0  | W  Index to palette register to be read  |     |        |
| 3C7  | DACStatus                                |     | 14-50  |
1-0  R  Shows whether previous DAC cycle was a read or write
| 7-2  | R  Reserved  |     |     |
| ---- | ------------ | --- | --- |
-
| 3C8  | DAC Write Index  |     | 14-50  |
| ---- | ---------------- | --- | ------ |
7-0  R/W  Index to palette register to be written or General Input Port
read data
| 3C9  | DAC Data  |     | 14-51  |
| ---- | --------- | --- | ------ |
7-0  R/W  Data from register pointed to by DAC Read or Write Index
A-10 REGISTER REFERENCE

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
A.2  S3 VGA REGISTERS
The Tri032ITri064 has additional registers described in Table A-2 that are located in CRT Controller
address space at locations not used by IBM. All ofthese registers are read/write protected at power-up
by hardware reset. In order to read/write these registers, the Register Lock 1 register (CR3B) must be
loaded with a binary unlock key pattern (see the register description). The registers will remain unlocked
until the key pattern is reset. ? = B for monochrome, D for color.
Table A-2.  53 VGA Registers
| Add  Index    |                                                      | Register Name    | Description  |
| ------------- | ---------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                  | Bit Description  | Page         |
| 375  2D       | Device ID High (CR2D)                                |                  | 15-1         |
| 7-0           | R  High byte of device ID (B8H)                      |                  |              |
| 315  2E       | Device ID Low (CR2E)                                 |                  | 15-1         |
| 7-0           | R  Low byte of device ID (10H-Tri032. 11 H-Tri064))  |                  |              |
| 315  2F       | Revision (CR2F)                                      |                  | 15-2         |
| 7-0           | R  Revision level                                    |                  |              |
| 315  30       | Chip ID/Rev (CR30)                                   |                  | 15-2         |
| 3-0           | R  Chip Identification -EH identifies Tri032ITri064  |                  |              |
| 7-4           | R  Chip revision status (stepping) -See CR2F         |                  |              |
| 315  31       | Memory Configuration (CR31)                          |                  | 15·2         |
| 0             | R/W  Enable base address offset (CR6A 6-0)           |                  |              |
| 1             | R/W  Enable two-page screen image                    |                  |              |
| 2             | R/W  Enable VGA 16-Bit Memory Bus Width              |                  |              |
| 3             | R/W  Use Enhanced mode memory mapping                |                  |              |
5-4
R/W  Old displaystart address bits 17-16 (see CR69 3-0)
| 6    | R/W  Enable high speed text display font fetch mode  |     |       |
| ---- | ---------------------------------------------------- | --- | ----- |
| 7    | R/W  Reserved                                        |     |       |
| 315  | Backward Compatibility 1 (CR32)                      |     |       |
| 32   |                                                      |     | 15·3  |
| 3-0  | R/W  Reserved                                        |     |       |
| 4    | R/W  Enable interrupt generation                     |     |       |
R/W
5  Reserved
| 6        | R/W  Use standard VGA memory wrapping at 256K boundary  |     |       |
| -------- | ------------------------------------------------------- | --- | ----- |
| 7        | R/W  Reserved                                           |     |       |
| 315  33  | Backward Compatibility 2 (CR33)                         |     | 15·4  |
| 0        | R/W  Reserved                                           |     |       |
1  R/W  Disable write protection provided by CR11  7 on CR7 1,6
| 2   | R/W  Reserved                                        |     |     |
| --- | ---------------------------------------------------- | --- | --- |
| 3   | R/W  VCLK is internal DCLK                           |     |     |
| 4   | R/W  Disable writes to RAMDAC registers (3C6H-3C9H)  |     |     |
5  R/W  BLANK signal active during entire non-active video period
6  R/W  Disable writes to Palette/Overscan registers (ARO-ARF)
| 7   | R/W  Reserved  |     |     |
| --- | -------------- | --- | --- |
REGISTER REFERENCE  A-11

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table A-2. S3 VGA Registers (continued)
| Add  Index    |                                                           | Register Name    | Description  |
| ------------- | --------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                       | Bit Description  | Page         |
| 375  34       | Backward Compatibility 3 (CR34)                           |                  | 15-5         |
| 0             | R/IN  PCI DAC snoop method select                         |                  |              |
| 1             | R/IN  Disable PCI master abort handling during DAC snoop  |                  |              |
| 2             | R/IN  Disable PCI retry handling during DAC snoop         |                  |              |
| 3             | R/IN  Reserved                                            |                  |              |
| 4             | R/IN  Enable Display Start FIFO Fetch register (CR3B)     |                  |              |
| 7-5           | R/IN  Reserved                                            |                  |              |
| 375  35       | CRT Register Lock (CR35)                                  |                  | 15-6         |
| 3-0           | R/IN  Old CPU base address (see CR6A 6-0)                 |                  |              |
| 4             | R/IN  Lock Vertical Timing registers                      |                  |              |
| 5             | R/IN  Lock Horizontal Timing registers                    |                  |              |
| 7-6           | R/IN  Reserved                                            |                  |              |
| 375  36       | Configuration 1 (CR36)                                    |                  | 15-7         |
| 1-0           | R  Select System bus (PCI or VL-Bus)                      |                  |              |
| 3-2           | R/IN  Select Memory page mode (fast page or EDO)          |                  |              |
| 4             | R/IN  Enable BIOS ROM accesses (VL-Bus)                   |                  |              |
| 7-5           | R/IN  Define display memory size                          |                  |              |
| 375  37       | Configuration 2 (CR37)                                    |                  | 15-7         |
0  Enable Trio32/64 operation (VL-Bus)
R/IN
| 1   | R/IN  Disable test mode (outputs tri-stated)    |     |     |
| --- | ----------------------------------------------- | --- | --- |
| 2   | R/IN  Select 32K or 64K BIOS ROM size (VL-Bus)  |     |     |
3  Use internal MCLK, DCLK
R/IN
| 4        | R/IN  Define RAMDAC write snooping (VL-Bus)  |     |       |
| -------- | -------------------------------------------- | --- | ----- |
| 7-5      | R/IN  Specify monitor information            |     |       |
| 375  3S  | Register Lock 1 (CR3S)                       |     | 15-9  |
| 7-0      | R/IN  Unlock S3 VGA registers (CR30-CR3C)    |     |       |
| 375  39  | Register Lock 2 (CR39)                       |     | 15-9  |
7-0  R/IN  Unlock System Control, System Extension and Strapping
registers (CR40-CR4F, CR50-CR6D)
| 375  3A  | Miscellaneous 1 (CR3A)                                    |     | 15-10  |
| -------- | --------------------------------------------------------- | --- | ------ |
| 1-0      | R/IN  Select alternate refresh count per horizontal line  |     |        |
| 2        | R/IN  Enable alternate refresh count (CR3A l-O)           |     |        |
| 3        | R/IN  Enable simultaneous VGA text and Enhanced modes     |     |        |
| 4        | R/IN  Enable 8-, 16-or 24/32-bit color Enhanced modes     |     |        |
| 5        | R/IN  Enable high speed text font writing                 |     |        |
| 6        | R/IN  Reserved                                            |     |        |
| 7        | R/IN  Disable PCI bus read burst cycles                   |     |        |
A-12 REGISTER REFERENCE

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Table A-2. S3 VGA Registers (continued)
| Add  Index    |                                  | Register Name    | Description  |
| ------------- | -------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                              | Bit Description  | Page         |
| 375  3B       | Start Display FIFO Fetch (CR3B)  |                  | 15-11        |
7..(J  RfI/I/  Specify start of display FIFO fetches for screen refreshing
| 375  3C  | Interlace Retrace Start (CR3C)                          |     | 15-11  |
| -------- | ------------------------------------------------------- | --- | ------ |
| 7-0      | RfI/I/  Specify interlaced mode retrace start position  |     |        |
A.3  SYSTEM CONTROL REGISTERS
System Control registers are configuration registers, mode control registers, and hardware graphics
cursor control registers. They are positioned in the same indexed register space as VGA S3 registers.
All of these registers are read/write protected at power-up by hardware reset. In order to read/write
these registers, the Register Lock 2 register (CR39) must be loaded with a binary unlock key pattern
(see the register description). The registers will remain unlocked until the key pattern is reset. ? = B for
monochrome, 0 for color.
The following table summarizes the System Control registers.
Table A-3.  System Control Registers
| Add  Index    |      | Register Name    | Description  |
| ------------- | ---- | ---------------- | ------------ |
| ress  Bit(s)  | R/W  | Bit Description  | Page         |
16-1
| 375  40  | System Configuration (CR40)  |     |     |
| -------- | ---------------------------- | --- | --- |
a
RfI/I/  Enable Enhanced mode register access
| 3-1  | RfI/I/  Reserved  |     |     |
| ---- | ----------------- | --- | --- |
Ready (Wait State) Control (VL-Bus)
4  RfI/I/
Reserved = 1
5  RfI/I/
| 7-6  | RfI/I/  Reserved  |     |       |
| ---- | ----------------- | --- | ----- |
|      | BIOS Flag (CR41)  |     | 16-2  |
375  41
| 7-0      | RfI/I/  Used by the video BIOS  |     |       |
| -------- | ------------------------------- | --- | ----- |
| 375  42  | Mode Control (CR42)             |     | 16-2  |
| 4-0      | RfI/I/  Reserved                |     |       |
5  RfI/I/  Select Interlaced mode
6  RfI/I/  Reserved
REGISTER REFERENCE  A-13

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table A-3. System Control Registers (continued)
| Add  Index    |                                              | Register Name    | Description  |
| ------------- | -------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                          | Bit Description  | Page         |
| 375  43       | Extended Mode (CR43)                         |                  | 16-2         |
| 1-0           | R/IN  Reserved                               |                  |              |
| 2             | R/IN  Old logical screen width bit 8         |                  |              |
| 6-3           | R/IN  Reserved                               |                  |              |
| 7             | R/IN  Enable horizontal counter double mode  |                  |              |
| 375  45       | Hardware Graphics Cursor Mode (CR45)         |                  | 16-3         |
R/IN
| 0    | Enable hardware graphics cursor                             |     |     |
| ---- | ----------------------------------------------------------- | --- | --- |
| 3-1  | R/IN  Reserved                                              |     |     |
| 4    | R/IN  Set up space at right of bit map for hardware cursor  |     |     |
7-5
R/IN  Reserved
375  46-47  Hardware Graphics Cursor Origin-X (CR46-CR47)  16-3
| 10-0  | R/IN  X-coordinate of the hardware cursor left side  |     |     |
| ----- | ---------------------------------------------------- | --- | --- |
15-11
R/IN  Reserved
375  48-49  Hardware Grallhics Cursor Origin-V (CR4Q-CR49)  16-4
| 10-0   | R/IN  Y-coordinate of the hardware cursor upper line  |     |     |
| ------ | ----------------------------------------------------- | --- | --- |
| 15-11  | Reserved                                              |     |     |
R/IN
375  4A  Hardware Graphics Cursor Foreground Stack (CR4A)  16-4
| 7-0  | R/IN  Hardware cursor foreground color (3 registers)  |     |     |
| ---- | ----------------------------------------------------- | --- | --- |
375  4B  Hardware Graphics Cursor Background Stack (CR4BI  16-4
| 7-0  | R/IN  Hardware cursor background color (3 registers)  |     |     |
| ---- | ----------------------------------------------------- | --- | --- |
375  4C-4D  Hardware Graphics Cursor Start Address (CR4C-CR4DI  16-5
| 12-0   | R/IN  Hardware cursor start address  |     |     |
| ------ | ------------------------------------ | --- | --- |
| 15-13  | R/IN  Reserved                       |     |     |
375  4E  Hardware Graphics Cursor Pattern Display Start X-Pixel  16-5
Position (CR4E)
| 5-0  | R/IN  Hardware cursor display start x-coordinate  |     |     |
| ---- | ------------------------------------------------- | --- | --- |
7-6
R/IN  Reserved
375  4F  Hardware Graphics Cursor Pattern Display Start V-Pixel  16-5
Position (CR4FI
| 5-0  | R/IN  Hardware cursor display start y-coordinate  |     |     |
| ---- | ------------------------------------------------- | --- | --- |
| 7-6  | R/IN  Reserved                                    |     |     |
A-14 REGISTER REFERENCE

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
A.4 SYSTEM EXTENSION REGISTERS
These registers provide extended system and memory control, external sync control and addressing
window control. They are enabled in the same way as the System Control registers via the Register
Lock 2 register (CR39). ? = B for monochrome, 0 for color.
Table A·4.  System Extension Registers
| Add  Index     |                                | Register Name    | Description  |
| -------------- | ------------------------------ | ---------------- | ------------ |
| dress  Bit(s)  | R/W                            | Bit Description  | Page         |
| 375  50        | Extended System Cont 1 (CR50)  |                  | 17·1         |
0  RM/  Most significant bit of screen width definition (see bits 7-6)
1  RM/  Reserved
2  RM/  Enable shared frame buffer memory bus arbitration
3  RM/  Reserved
| 5-4      | RM/  Pixellenqth select                   |     |       |
| -------- | ----------------------------------------- | --- | ----- |
| 7-6      | RMI  With bit 0, screen width definition  |     |       |
| 375  51  | Extended System Cont 2 (CR51)             |     | 17·2  |
| 1-0      | RM/  Old displaystart address bits 19-18  |     |       |
| 3-2      | RM/  Old CPU base address bits 19-18      |     |       |
| 5-4      | RM/  Logical screen width bits 9-8        |     |       |
| 7-6      | RM/  Reserved                             |     |       |
| 375  52  | Extended BIOS Flag 1 (CR52)               |     | 17·3  |
| 7-0      | RM/  Used by the video BIOS               |     |       |
| 375  53  | Extended Memory Cont 1 (CR53)             |     | 17·3  |
0  RM/  Enable write per bit
| 3-1  | RM/  Reserved  |     |     |
| ---- | -------------- | --- | --- |
4  RM/  Enable memory-mapped I/O access
5  RM/  Reserved
6  RM/  Enable nibble swap
7  RM/  Reserved
| 375      | Extended Memory Cont 2 (CR54)                      |     |       |
| -------- | -------------------------------------------------- | --- | ----- |
| 54       |                                                    |     | 17·4  |
| 2-0      | RM/  Reserved                                      |     |       |
| 7-3      | RM/  Specify M parameter for display FIFO control  |     |       |
| 375  55  | Extended DAC Control (CR55)                        |     |       |
17·4
| 1-0  | RM/  Reserved  |     |     |
| ---- | -------------- | --- | --- |
2  RM/  Enable General Input Port read
3  RM/  Reserved
4  RM/  Enable X-11 windows hardware cursor mode
| 6-5  | RM/  Reserved  |     |     |
| ---- | -------------- | --- | --- |
7  RM/  VCLK output pin is tri-stated
| 375  56  | External Sj'nc Cont 1 (CR56)  |     | 17·5  |
| -------- | ----------------------------- | --- | ----- |
0  RM/  Enable remote mode operation (genlocking)
1  RM/  HSYNC output buffer tri-stated
REGISTER REFERENCE  A-15

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Table A-4. System Extension Registers (continued)
| Add  Index    |                                                               | Register Name    | Description  |
| ------------- | ------------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                           | Bit Description  | Page         |
| 375  56       | External Sync Cont 1 (CR56)                                   |                  | 17-5         |
| 2             | RNI/  VSYNC output buffer tri-stated                          |                  |              |
| 3             | RNV  Select vertical counter-onlY reset sync with qenlockinq  |                  |              |
| 4             | RNI/  Select odd frame after a vertical counter reset         |                  |              |
| 7-5           | RNI/  Reserved                                                |                  |              |
| 375  57       | External Sync Cont 2 (CR57)                                   |                  | 17-6         |
7-0  RNI/  Vertical reset adjustment from VSYNC falling (genlocking)
| 375  58     | Linear Address Window Control (CR58)                |     | 17-6  |
| ----------- | --------------------------------------------------- | --- | ----- |
| 1-0         | RNI/  Linear addressing window size                 |     |       |
| 2           | RNI/  Reserved                                      |     |       |
| 3           | RNI/  Address latch timinq control (VL-Bus)         |     |       |
| 4           | RNI/  Enable linear addressinq                      |     |       |
| 6-5         | RNV  Reserved                                       |     |       |
| 7           | RNI/  RAS precharge time increased                  |     |       |
| 375  59-5A  | Linear Address Window Position (CR59-5A)            |     | 17-7  |
| 15-0        | RNI/  Linear addressing window position bits 31-16  |     |       |
| 375  5C     | General Out Port (CR5C)                             |     | 17-8  |
| 7-0         | RNI/  General Output Port                           |     |       |
| 375  5D     | Extended Horizontal Overflow (CR5D)                 |     | 17-8  |
| 0           | RNI/  Horizontal total bit 8 (CRO)                  |     |       |
| 1           | RNI/  Horizontal display end bit 8 (CR 1)           |     |       |
| 2           | RNI/  Start horizontal blank bit 8 (CR2)            |     |       |
RNV
| 3   | BLANK pulse extended by 64 DCLKs                  |     |     |
| --- | ------------------------------------------------- | --- | --- |
| 4   | RNI/  Start horizontal sync position bit 8 (CR4)  |     |     |
| 5   | RNI/  HSYNC pulse extended by 32 DCLKs            |     |     |
Start FIFO Fetch bit 8 (CR3B)
| 6        | RNI/                                             |     |       |
| -------- | ------------------------------------------------ | --- | ----- |
| 7        | RNI/  Bus grant terminate position bit 8 (CR5F)  |     |       |
| 375  5E  | Extended Vertical Overflow (CR5E)                |     | 17-9  |
Vertical total bit 10 (CR6)
| 0   | RNI/                                       |     |     |
| --- | ------------------------------------------ | --- | --- |
| 1   | RNI/  Vertical display end bit 10 (CR 12)  |     |     |
| 2   | RNI/  Start vertical blank bit 10 (CR15)   |     |     |
| 3   | Reserved                                   |     |     |
RNI/
| 4   | RNI/  Vertical retrace start bit 10 (CRl 0)  |     |     |
| --- | -------------------------------------------- | --- | --- |
| 5   | RNI/  Reserved                               |     |     |
| 6   | RNI/  Line comRarep_osition bit 10 (CR18)    |     |     |
| 7   | RNI/  Reserved                               |     |     |
A-16 REGISTER REFERENCE

53 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table A-4. System Extension Registers (continued)
| Add  Index    |                                                    | Register Name    | Description  |
| ------------- | -------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                | Bit Description  | Page         |
| 375  60       | Extended Memory Control 3 (CR60)                   |                  | 17-9         |
| 7-0           | RMJ  Specify N parameter for display FIFO control  |                  |              |
| 375  63       | External Sync Delay Adjust High (CR63)             |                  | 17-10        |
| 3-0           | RMJ  HSYNC reset adjustment (genlocking)           |                  |              |
| 7-4           | RMJ  Character clock reset delay (genlocking)      |                  |              |
| 375  65       | Extended Miscellaneous Control (CR65)              |                  | 17-10        |
1-0
RMJ  Reserved
| 2        | RMJ  Enable 3C3H port for video subsystem setup           |     |        |
| -------- | --------------------------------------------------------- | --- | ------ |
| 7-5      | RMJ  Delay BLANK by DCLK (Trio32 only)                    |     |        |
| 7-3      | RMJ  Reserved                                             |     |        |
| 375  66  | Extended Miscellaneous Control 1 (CR66)                   |     | 17-11  |
| 5-0      | RMJ  Reserved                                             |     |        |
| 6        | RMJ  PA[15:0] are tri-stated off                          |     |        |
| 7        | RMJ  Enable PCI bus disconnect                            |     |        |
| 375  67  | Extended Miscellaneous Control 2 (CR67)                   |     | 17-11  |
| 0        | RMJ  VCLK is in phase with DCLK                           |     |        |
| 3-1      | RMJ  Reserved                                             |     |        |
| 7-4      | RMJ  Select RAMDAC color mode                             |     |        |
| 375  68  | Configuration 3 (CR68)                                    |     | 17-12  |
| 0        | RMJ  CAS, WE and OE stretch time selection                |     |        |
| 1        | RMJ  Reserved                                             |     |        |
| 2        | R/W  RAS low timing select                                |     |        |
| 3        | R/W  RAS precharge timing select                          |     |        |
| 6-4      | R/W  Monitor information                                  |     |        |
| 7        | R/W  SAUP decode used. Trio64 memory data bus is 32 bits  |     |        |
| 375  69  | Extended System Control 3 (CR69)                          |     | 17-13  |
| 4-0      | R/W  Display start address bits 19-16                     |     |        |
| 7-5      | R/W  Reserved                                             |     |        |
| 375  6A  | Extended System Control 4 (CR6A)                          |     | 17-13  |
| 5-0      | R/W  CPU base address bits 19-14                          |     |        |
| 7-6      | RMJ  Reserved                                             |     |        |
| 375      | Extended BIOS Flag 3 (CR6B)                               |     | 17-14  |
6B
| 7-0      | R/W  Used by the video BIOS  |     |        |
| -------- | ---------------------------- | --- | ------ |
| 375  6C  | Extended BIOS Flag 4 (CR6C)  |     | 17-14  |
| 7-0      | Used by the video BIOS       |     |        |
R/W
REGISTER REFERENCE  A-17

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
A.5  ENHANCED COMMANDS REGISTERS
This section lists the registers which supportthe Tri032{Tri064 enhanced drawing functions. All ofthese
registers are byte or word-addressed and are enabled only if bit 0 ofthe System Configuration register
(CR40) is set to 1.
Table A-S.  Enhanced Commands Registers
| Add  Index    |                                                  | Register Name     | Description  |
| ------------- | ------------------------------------------------ | ----------------- | ------------ |
| ress  Bit(s)  | R/W                                              | Bit Descri{)tion  | Paae         |
| 42E8          | Subsystem Status                                 |                   | 18-1         |
| 0             | R  Vertical sync interrupt status                |                   |              |
| 1             | R  Graphics Engine busy interrupt status         |                   |              |
| 2             | R  Command FIFO overflow interrupt status        |                   |              |
| 3             | R  Command FIFO empty interrupt status           |                   |              |
| 6-4           | R  Reserved                                      |                   |              |
| 7             | R  4 or 8 bit planes                             |                   |              |
| 15-8          | R  Reserved                                      |                   |              |
| 42E8          | Subsystem Control                                |                   | 18·2         |
| 0             | W  Clear vertical sync interrupt status          |                   |              |
| 1             | W  Clear Graphics Engine busy interrupt status   |                   |              |
| 2             | W  Clear Command FIFO overflow interrupt status  |                   |              |
| 3             | W  Clear Command FIFO empty interrupt status     |                   |              |
| 7-4           | W  Reserved                                      |                   |              |
| 8             | W  Vertical sync interrupt enabled               |                   |              |
| 9             | W  Graphics Engine busy interrupt enabled        |                   |              |
| 10            | W  Command FIFO overflow interrupt enabled       |                   |              |
| 11            | W  Command FIFO empty interrupt enabled          |                   |              |
| 13-12         | W  Reserved                                      |                   |              |
| 15-14         | W  Graphics Engine software reset selection      |                   |              |
| 4AE8          | Advanced Function Control                        |                   | 18-3         |
| 0             | RNJ  Enable Enhanced mode functions              |                   |              |
| 1             | RNJ  Reserved                                    |                   |              |
| 2             | RNJ  Specify 4 bits/pixel Enhanced mode          |                   |              |
| 3             | RNJ  Reserved                                    |                   |              |
| 4             | RNJ  Enable linear addressing                    |                   |              |
| 5             | RNJ  Enable memory-mapped I/O                    |                   |              |
| 15-6          | RNV  Reserved                                    |                   |              |
| 82E8          | Current Y·Position                               |                   | 18-4         |
| 11-0          | RNV  Pixel vertical screen coordinate            |                   |              |
| 15-12         | RNJ  Reserved                                    |                   |              |
| 82EA          | Current Y·Position 2 (Trio64 onl}')              |                   | 18·4         |
| 11-0          | RNJ  Second lJixel vertical screen coordinate    |                   |              |
| 15-12         | RNJ  Reserved                                    |                   |              |
A-18 REGISTER REFERENCE

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
Table A·5. Enhanced Commands Registers (continued)
| Add  Index  |     | Register Name  | Description  |
| ----------- | --- | -------------- | ------------ |
Bit(s)
| ress   | R/W                                             | Bit Description  | Page  |
| ------ | ----------------------------------------------- | ---------------- | ----- |
| S6ES   | Current X·Position                              |                  | 1S·5  |
| 11-0   | R/W  Pixel horizontal screen coordinate         |                  |       |
| 15-12  | R/W  Reserved                                   |                  |       |
| S6EA   | Current X·Position 2 (Tri064 only)              |                  | 1S-5  |
| 11-0   | R/W  Second pixel horizontal screen coordinate  |                  |       |
| 15-12  | Reserved                                        |                  |       |
R/W
| SAES  | Destination V Position/Axial Stl!J) Constant  |     | 1S·6  |
| ----- | --------------------------------------------- | --- | ----- |
11-0/  R/W  Specifies ending vertical coordinate or axial step constant for a
| 13-0   | number of drawing commands                     |     |     |
| ------ | ---------------------------------------------- | --- | --- |
| 15-12  | R/W  Reserved (Bits 1 5-14 for step constant)  |     |     |
SAEA  V Coordinate 2/Axial Step Constant 2 (Tri064 only)  1S·6
11-0/  R/W  Second specification of ending vertical coordinate or axial step
| 13-0   | constant for a number of drawing commands      |     |       |
| ------ | ---------------------------------------------- | --- | ----- |
| 15-12  | R/W  Reserved (Bits 15-14 for step constant)   |     |       |
| SEES   | Destination X Position/Diagonal Step Constant  |     | 1S·7  |
11-0/  R/W  Specifies ending horizontal coordinate or diagonal step
| 13-0   | constant for a number of drawing commands     |     |       |
| ------ | --------------------------------------------- | --- | ----- |
| 15-12  | R/W  Reserved (Bits 15-14 for step constant)  |     |       |
| SEEA   | X Coordinate 2 (Trio64 Only)                  |     | 1S·S  |
11-0  R/W  Additional X coordinate for multipoint drawing commands·
| 15-12  | R/W  Reserved (Bits 1 5-14 for step constant)            |     |       |
| ------ | -------------------------------------------------------- | --- | ----- |
| 92ES   | Line Error Term                                          |     | 1S·S  |
| 13-0   | R/W  Error term for line draws                           |     |       |
| 15-14  | R/W  Reserved                                            |     |       |
| 92EA   | Line Error Term 2 (Trio64 only)                          |     | 1S·9  |
| 13-0   | R/W  Error term for Bresenham parameter trapezoid fills  |     |       |
| 15-14  | R/W  Reserved                                            |     |       |
| 96ES   | Major Axis Pixel Count                                   |     | 1S·9  |
| 11-0   | Length of the longest axis (pixels -1)                   |     |       |
R/W
| 15-12  | R/W  Reserved                           |     |        |
| ------ | --------------------------------------- | --- | ------ |
| 96EA   | Major Axis Pixel Count 2 (Tri064 on!YI  |     | 1S·10  |
11-0  Additional lonQ axis specification for some drawinQ commands
R/W
| 15-12  | R/W  Reserved              |     |        |
| ------ | -------------------------- | --- | ------ |
| 9AES   | Graphics Processor Status  |     | 1S·10  |
7-0  R  Low 8 bits of field showing FIFO slots available (see bits 15-11)
8  R  Reserved
9  R  Graphics Engine busy
| 10     | R  All FIFO slots empty                       |     |     |
| ------ | --------------------------------------------- | --- | --- |
| 15-11  | R  High 5 bits of FIFO status (see bits 7-0)  |     |     |
REGISTER REFERENCE  A-19

r-~  .
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table A-5. Enhanced Commands Registers (continued)
| Add  Index    |                             | Register Name    | Description  |
| ------------- | --------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                         | Bit Description  | Page         |
| 9AES          | Drawing Command             |                  | 1S-11        |
| 0             | W  Must be programmed to 1  |                  |              |
1  W  Select across the plane pixel mode
| 2    | W  Last pixel will not be drawn     |     |     |
| ---- | ----------------------------------- | --- | --- |
| 3    | W  Select radial drawing direction  |     |     |
| 4    | W  Draw pixels                      |     |     |
| 7-5  | W  Select drawing direction         |     |     |
W
| 8     | Wait for CPU data          |     |     |
| ----- | -------------------------- | --- | --- |
| 10-9  | W  Select system bus size  |     |     |
| 11    | W  Reserved                |     |     |
Enable byte swap
| 12     | W                               |     |        |
| ------ | ------------------------------- | --- | ------ |
| 15-13  | W  Select command type          |     |        |
| 9AEA   | DrawingCommand 2 (Trio64 only)  |     | 1S-14  |
| 4-0    | W  Reserved                     |     |        |
7-5  W  Drawing direction for Bresenham parameter trap_ezoid fills
| 15-8  | W  Reserved                        |     |        |
| ----- | ---------------------------------- | --- | ------ |
| 9EES  | Short Stroke Vector Transfer       |     | 1S-15  |
| 3-0   | W  Length of vector 1 (pixels -1)  |     |        |
| 4     | W  Draw pixels                     |     |        |
| 7-5   | W  Select drawing direction        |     |        |
15-8  W  Duplicate of bits 7-0 to define second short stroke vector
| A2ES  | Background Color                                             |     | 1S-16  |
| ----- | ------------------------------------------------------------ | --- | ------ |
| 31-0  | RMJ  Backqround color value                                  |     |        |
| A6ES  | Foreground Color                                             |     | 1S-16  |
| 31-0  | RMJ  For~ground Color value                                  |     |        |
| AAES  | Bitplane Write Mask                                          |     | 1S-17  |
| 31-0  | RMJ  Each bit enables up_datirl~ of corresponding bit plane  |     |        |
| AEES  | Bitiliane Read Mask                                          |     | 1S-17  |
| 31-0  | RMJ  Each bit enables reading of corresponding bit plane     |     |        |
| B2ES  | Color Compare                                                |     | 1S-1S  |
| 31-0  | RMJ  Color value to be compared with current bitmap color    |     |        |
| B6ES  | Background Mix                                               |     | 18-18  |
| 3-0   | W  Select mix type                                           |     |        |
4  W  Reserved
| 6-5   | W  Select color source  |     |     |
| ----- | ----------------------- | --- | --- |
| 15-7  | W  Reserved             |     |     |
A-20  REGISTER REFERENCE

fl·
83 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table A-S. Enhanced Commands Registers (continued)
| Add  Index  |     | Register Name  | Description  |
| ----------- | --- | -------------- | ------------ |
Bit(s)
| ress     | R/W                                                    | Bit Descrg,tion  | Pa~e   |
| -------- | ------------------------------------------------------ | ---------------- | ------ |
| BAES     | Foreground Mix                                         |                  | 1S-1S  |
| 3-0      | W  Select mix type                                     |                  |        |
| 4        | W  Reserved                                            |                  |        |
| 6-5      | W  Select color source                                 |                  |        |
| 15-7     | W  Reserved                                            |                  |        |
| BEES     | Read Register Data                                     |                  | 1S-19  |
| 15-0     | R  Data from reQister selected by bits 2-0 of BEE8H E  |                  |        |
| BEES  0  | Minor Axis Pixel Count                                 |                  | 1S-20  |
| 11-0     | W  RectanQle heiQht (pixels -1)                        |                  |        |
| 15-12    | W  Reserved                                            |                  |        |
| BEES  1  | Top Scissors                                           |                  | 1S-20  |
| 11-0     | W  Top side of the clippinQ rectangle                  |                  |        |
| 15-12    | W  Reserved                                            |                  |        |
| BEES  2  | Left Scissors                                          |                  | 1S-20  |
| 11-0     | W  Left side of the clipping rectangle                 |                  |        |
| 15-12    | W  Reserved                                            |                  |        |
| BEES  3  | Bottom Scissors                                        |                  | 1S-21  |
| 11-0     | W  Bottom side of the clipping rectangle               |                  |        |
| 15-12    | W  Reserved                                            |                  |        |
| BEES  4  | Right Scissors                                         |                  | 1S-21  |
| 11-0     | W  RiQht side of the ciippinQ rectanQle                |                  |        |
| 15-12    | W                                                      |                  |        |
Reserved
| BEES  A  | Pixel Control  |     | 1S-21  |
| -------- | -------------- | --- | ------ |
| 5-0      | W  Reserved    |     |        |
W  Select mix register
7-6
| 11-8     | W  Reserved                                     |     |        |
| -------- | ----------------------------------------------- | --- | ------ |
| 15-12    | W  OAH (index)                                  |     |        |
| BEES  D  | Multifunction Control Miscellaneous 2           |     | 1S-22  |
| 2-0      | W  Destination base address location in memory  |     |        |
| 3        | W  Reserved                                     |     |        |
| 6-4      | W  Source base address location in memory       |     |        |
| 11-7     | W  Reserved                                     |     |        |
| 15-12    | W  ODH (index)                                  |     |        |
REGISTER REFERENCE  A-21

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Table A·5. Enhanced Commands Registers (continued)
| Add  Index    |      | Register Name    | Description  |
| ------------- | ---- | ---------------- | ------------ |
| ress  Bit(s)  | R/W  | Bit Description  | Page         |
E
| BEE8  | Multifunction Control Miscellaneous     |     | 18·23  |
| ----- | --------------------------------------- | --- | ------ |
| 1-0   | W  Destination base address bits 21-20  |     |        |
| 3-2   | W  Source base address bits 21-20       |     |        |
W
| 4   | Select upper word for 32-bit register accesses           |     |     |
| --- | -------------------------------------------------------- | --- | --- |
| 5   | W  Only pixels outside the clipping rectangle are drawn  |     |     |
| 6   | W  Select slow read/modify/Write cycle                   |     |     |
| 7   | W                                                        |     |     |
Don't update bitmap if source is not equal to color compare
color
| 8        | W  Enable color comparison          |     |        |
| -------- | ----------------------------------- | --- | ------ |
| 9        | W  Select 32-bit command registers  |     |        |
| 11-10    | W  Reserved                         |     |        |
| 15-12    | W  OEH (index)                      |     |        |
| BEE8  F  | Read Register Select                |     | 18·24  |
| 2-0      | W  Select register to be read       |     |        |
| 11-4     | W  Reserved                         |     |        |
| 15-12    | W  OFH (index)                      |     |        |
| E2E8     | Pixel Data Transfer                 |     | 18·11  |
W
15-0  Data transfer register (CPU to Graphic Engine) -low word
| E2EA  | Pixel Data Transfer·Extension  |     | 18·25  |
| ----- | ------------------------------ | --- | ------ |
15-0  W  Data transfer register (CPU to Graphic Engine) -high word
| EAE8   | Pattern V (Trio64 onlv)                    |     | 18·25  |
| ------ | ------------------------------------------ | --- | ------ |
| 11-0   | RNJ  Vertical pattern for pattern fills    |     |        |
| 15-12  | RNJ  Reserved                              |     |        |
| EAEA   | Pattern X (Trio64 only)                    |     | 18·26  |
| 11-0   | RNJ  Horizontal pattern for pattern fills  |     |        |
| 15-2   | RNJ  Reserved                              |     |        |
A-22  REGISTER REFERENCE

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
A.6 PCI CONFIGURATION SPACE REGISTERS
When a PCI configuration read or write command is issued, AD[7:0) contain the address of the register
in the configuration space to be accessed.
| Table A-6.  PCI Configuration Space Registers  |                                                       |                  |              |
| ---------------------------------------------- | ----------------------------------------------------- | ---------------- | ------------ |
| Add  Index                                     |                                                       | Register Name    | Description  |
| dress  Bit(s)                                  | R/W                                                   | Bit Description  | Page         |
| 00                                             | Vendor ID                                             |                  | 19-1         |
| 15-0                                           | R  Hardwired to 5333H                                 |                  |              |
| 02                                             | Device ID                                             |                  | 19-2         |
| 15-0                                           | R  Hardwired to 8811 H                                |                  |              |
| 04                                             | Command                                               |                  | 19-2         |
| 0                                              | RMJ  Response to I/O space accesses enabled           |                  |              |
| 1                                              | RMJ  Response to memory space accesses enabled        |                  |              |
| 4-2                                            | RMJ  Reserved                                         |                  |              |
| 5                                              | RMJ  Enable DAC snooping                              |                  |              |
| 15-6                                           | RMJ  Reserved                                         |                  |              |
| 06                                             | Status                                                |                  | 19-3         |
| 8-0                                            | RMJ  Reserved                                         |                  |              |
| 10-9                                           | RMJ  Hardwired to select medium device select timing  |                  |              |
| 15-11                                          | RMJ  Reserved                                         |                  |              |
| 08                                             | Class Code                                            |                  | 19-3         |
31-0  R  Hardwired to indicate VGA-compatible display controller
| 10  | Base Address 0  |     | 19-4  |
| --- | --------------- | --- | ----- |
0  Hardwired to indicate base reiJisters map into memory space
RMJ
2-1  RM1  Hardwired to allow mapping anywhere in 32-bit address sRace
3  RMJ  Hardwired to indicate does not meet prefetchable requirements
22-4
RMJ  Reserved
| 31-23  | RMJ  Base address 0                           |     |        |
| ------ | --------------------------------------------- | --- | ------ |
| 30     | BIOS Base Address                             |     | 19-5   |
| 0      | RMJ  Enable access to BIOS ROM address space  |     |        |
| 15-1   | RMJ  Reserved                                 |     |        |
| 31-16  | RM1  Upper 16 bits of BIOS ROM address        |     |        |
| 3C     | Interrupt LIne                                |     | 19-55  |
| 7-0    | RMJ  Interrupt line routing information       |     |        |
| 3D     | Interrupt Pin                                 |     | 19-6   |
| 7-0    | R  Hardwired to specify use of INTA           |     |        |
REGISTER REFERENCE  A-23

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
Index
| 2 point line drawing     |     | 13-23  |          | clock generator             |     |        |        |
| ------------------------ | --- | ------ | -------- | --------------------------- | --- | ------ | ------ |
| 32 bits/pixel operation  |     | 18-23  |          | DC specifications           |     | 4-1    |        |
| 32-bit PO bus operation  |     |        | 5-3,7-1  | frequency synthesis         |     | 9-1    |        |
|                          |     |        |          | new DCLK PLL load           |     | 14-15  |        |
| A                        |     |        |          | new MCLK and DCLK PLL load  |     |        | 14-16  |
|                          |     |        |          | new MCLK PLL load           |     | 14-15  |        |
address latch delay  17-6  color compare  13-2,13-7,18-18,18-23
| axial step constant  |     | 13-9  |     | VGA  14-36, 14-40  |     |     |     |
| -------------------- | --- | ----- | --- | ------------------ | --- | --- | --- |
axial step constant  18-6  color depth (bpp)  17-1,18-2 -18-3
| axial step constant 2  |     | 18-6  |     | color mode select        |     | 14-11  |     |
| ---------------------- | --- | ----- | --- | ------------------------ | --- | ------ | --- |
|                        |     |       |     | configuration space      |     | 6-1    |     |
|                        |     |       |     | configuration strapping  |     | 15-7   |     |
B
|     |     |     |     | at reset  | 5-1, 5-3  |     |     |
| --- | --- | --- | --- | --------- | --------- | --- | --- |
background color  18-16  unlocking access to registers  15-9
| background/foreground mix         |      |     | 13-2, 13-4,  | CPU base address    |     |             |     |
| --------------------------------- | ---- | --- | ------------ | ------------------- | --- | ----------- | --- |
| 13-9 -13-14, 13-16 -13-22, 18-18  |      |     |              | enable  15-2        |     |             |     |
| BGNT                              | 7-9  |     |              | specify  17-13      |     |             |     |
| BIOS                              |      |     |              | current X position  |     | 18-4 -18-5  |     |
18-5
| See video BIOS            |     |       |        | current X position 2     |     |        |     |
| ------------------------- | --- | ----- | ------ | ------------------------ | --- | ------ | --- |
| BitBLT  across the plane  |     |       | 13-18  | current Y position       |     | 18-4   |     |
| BitBLT through the plane  |     |       | 13-17  | cursor                   |     |        |     |
| bits/pixel                |     |       |        | end  14-25               |     |        |     |
| See color depth           |     |       |        | location address         |     | 14-26  |     |
| BLANK                     |     |       |        | start  14-25             |     |        |     |
| direction control         |     | 3-10  |        | cursor location address  |     | 14-26  |     |
| blank/border select       |     | 15-4  |        |                          |     |        |     |
BREQ  7-9,17-1
D
| byte mode addressing  |        | 14-31  |     |               |     |     |     |
| --------------------- | ------ | ------ | --- | ------------- | --- | --- | --- |
| byte swap             | 18-12  |        |     | DCLK          |     |     |     |
|                       |        |        |     | control  9-3  |     |     |     |
c
|      |     |     |     | halving        | 14-6, 14-16  |     |     |
| ---- | --- | --- | --- | -------------- | ------------ | --- | --- |
|      |     |     |     | invert  14-16  |              |     |     |
| CAS  |     |     |     | inverted       | 15-4         |     |     |
stretch time  7-5,17-12  loading new frequency  9-2,14-15 -14-16
| character clock  |                           |       |     | programming               | 9-2,14-13  |             |     |
| ---------------- | ------------------------- | ----- | --- | ------------------------- | ---------- | ----------- | --- |
| dot clocks per   |                           | 14-6  |     | destination base address  |            | 18-22       |     |
| chip 10          | 11-4,15-1-15-2            |       |     | destination X position    |            | 18-7        |     |
| chip wakeup      | 11-1                      |       |     | destination Y position    |            | 18-6        |     |
| clipping         | 13-7,18-20 -18-21, 18-23  |       |     | DEVSEL timing             | 6-1        |             |     |
|                  |                           |       |     | diagonal step constant    |            | 13-9, 18-7  |     |
INDEX  1-1

,I.
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
diagonal step constant 2  18-8  destination base address  18-22
| display active status  |       | 14-3  |     | destination X position  |     |     | 18-7  |
| ---------------------- | ----- | ----- | --- | ----------------------- | --- | --- | ----- |
| display FIFO fetch     |       |       |     | destination Y position  |     |     | 18-6  |
| enable                 | 15-5  |       |     | diagonal step constant  |     |     | 18-7  |
specify start position  15-11  diagonal step constant 2  18-8
| display memory         |      |               |      | drawing command 2        |            |        | 18-14  |
| ---------------------- | ---- | ------------- | ---- | ------------------------ | ---------- | ------ | ------ |
| 2 MCLK writes          |      | 14-10, 14-16  |      | drawing commands         |            |        | 18-11  |
| access control         |      | 7-8           |      | enable                   | 13-1,18-3  |        |        |
| bus width select       |      | 17-13         |      | enable 8 bpp or greater  |            |        | 15-10  |
|                        |      |               |      | foreground color         |            | 18-16  |        |
| chip count limitation  |      |               | 7-1  |                          |            |        |        |
| configurations         |      | 7-1           |      | line error term          |            | 18-8   |        |
| functional timing      |      | 7-5 -7-6      |      | line error term 2        |            | 18-9   |        |
| refresh                | 7-3  |               |      | major axis pixel count   |            |        | 18-9   |
refresh cycle control  7-3, 14-28  major axis pixel count 2  18-10
| size specification          |                 | 5-1, 15-7          |                | memory mapping          |                    | 15-3   |        |
| --------------------------- | --------------- | ------------------ | -------------- | ----------------------- | ------------------ | ------ | ------ |
| display pitch               | 14-28           |                    |                | minor axis pixel count  |                    |        | 18-20  |
| display start address       |                 | 17-13              |                | pattern X               | 18-26              |        |        |
|                             |                 |                    |                | pattern Y               | 18-25              |        |        |
| doubleword mode addressing  |                 |                    | 14-28 -14-29,  |                         |                    |        |        |
| 15-3                        |                 |                    |                | programming             |                    | 13-6   |        |
| drawing command 2           |                 | 18-14              |                | read mask               | 18-17              |        |        |
| drawing commands            |                 | 13-9 -13-22,18-11  |                | screen width            |                    | 17-2   |        |
| drawing direction           |                 | 18-12              |                | select mix register     |                    |        | 18-22  |
|                             |                 |                    |                | setup                   | 11-6               |        |        |
| E                           |                 |                    |                | short stroke vector     |                    |        | 18-15  |
|                             |                 |                    |                | source base address     |                    |        | 18-22  |
| EDO memory                  | 7-1 -7-2, 15-7  |                    |                | write mask              |                    | 18-17  |        |
| 2 MByte limit               |                 | 7-3                |                | X coordinate 2          |                    | 18-8   |        |
| enable                      |                 |                    |                | Y coordinate 2          |                    | 18-6   |        |
| Enhanced mode               |                 | 18-3               |                | ESYNC                   | 10-7,14-11         |        |        |
| feature connector           |                 | 14-11              |                | EVCLK                   | 10-10,14-11,14-15  |        |        |
| genlocking                  | 17-5            |                    |                | EVIDEO                  | 10-7               |        |        |
hardware graphics cursor  16-3  extended data out (EDO) memory  7-1,15-7
| linear addressing             |     | 17-6,18-3  |             |     |     |     |     |
| ----------------------------- | --- | ---------- | ----------- | --- | --- | --- | --- |
| memory mapped I/O             |     |            | 17-3, 18-4  | F   |     |     |     |
| shared frame buffer function  |     |            | 17-1        |     |     |     |     |
Tri032rrri064  14-47 -14-48, 15-8  fast page mode memory  7-1 -7-2, 14-10, 15-
| write per bit                 |     | 17-3   |        | 7                  |      |     |     |
| ----------------------------- | --- | ------ | ------ | ------------------ | ---- | --- | --- |
| end horizontal blank          |     | 14-21  |        | feature connector  |      |     |     |
| end horizontal sync position  |     |        | 14-22  | AC timing          | 4-6  |     |     |
end vertical blank  14-30  display memory considerations  7-1
| ENFEAT                     | 14-11                |                  |        | enable                   | 3-10,10-7,14-11  |        |     |
| -------------------------- | -------------------- | ---------------- | ------ | ------------------------ | ---------------- | ------ | --- |
| Enhanced mode              |                      |                  |        | interfaces               | 10-7             |        |     |
| axial step constant        |                      | 18-6             |        | pass-through             |                  | 10-7   |     |
| axial step constant 2      |                      |                  | 18-6   | VAFC                     | 10-7             |        |     |
| background color           |                      | 18-16            |        | FIFO status              | 18-10 -18-11     |        |     |
| background/foreground mix  |                      |                  | 18-18  | font selection           |                  | 14-7   |     |
| clipping                   | 18-20 -18-21, 18-23  |                  |        | foreground color         |                  | 18-16  |     |
| color compare              |                      | 18-18,18-23      |        | frame buffer             |                  |        |     |
| color depth                |                      | 17-1,18-2 -18-3  |        | See also display memory  |                  |        |     |
| command types              |                      | 18-13            |        | shared                   | 7-9              |        |     |
| current X position         |                      | 18-5             |        |                          |                  |        |     |
| current X position 2       |                      |                  | 18-5   |                          |                  |        |     |
| current Y position         |                      | 18-4             |        |                          |                  |        |     |
1-2  INDEX

II·
S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporated
G
| General Data bus  |     |     |     | 10, chip  | 15-1 -15-2  |     |     |
| ----------------- | --- | --- | --- | --------- | ----------- | --- | --- |
BIOS ROM interface  10-2  image transfer across the plane  13-15
general input port  14-50  image transfer through the plane  13-13
| description          | 10-4        |       |     | initialization               | 5-1          |             |       |
| -------------------- | ----------- | ----- | --- | ---------------------------- | ------------ | ----------- | ----- |
|                      | 10-4, 17-4  |       |     |                              |              | 15-11,16-2  |       |
| enable               |             |       |     | interlaced operation         |              |             |       |
| functional timing    |             | 10-4  |     | interrupt                    |              |             |       |
| general output port  |             | 17-8  |     | enable                       | 10-12, 15-4  |             |       |
| description          | 10-4        |       |     | FIFO empty interrupt enable  |              |             | 18-3  |
| genlocking           |             |       |     | FIFO empty interrupt status  |              |             | 18-1  |
character clock reset delay  17-10  FIFO overflow interrupt enable  18-3
| enable  | 17-5  |     |     | FIFO overflow interrupt status  |     |     | 18-1  |
| ------- | ----- | --- | --- | ------------------------------- | --- | --- | ----- |
10-11
| functional description  |     | 10-10        |     | generation            |     |        |     |
| ----------------------- | --- | ------------ | --- | --------------------- | --- | ------ | --- |
| HN counter resets       |     | 17-6, 17-10  |     | generation explained  |     | 10-12  |     |
Graphics Engine  Graphics Engine busy interrupt status  18-1
accessing bitmap through  13-2, 13-4  Graphics Engine interrupt enable  18-2
| busy status         | 18-11  |             |     | vertical retrace interrupt clear   |     |     | 14-27   |
| ------------------- | ------ | ----------- | --- | ---------------------------------- | --- | --- | ------- |
| enable              | 18-3   |             |     | vertical retrace interrupt enable  |     |     | 14-27,  |
| software reset      |        | 18-3        |     | 18-1 -18-2                         |     |     |         |
| green PC            |        |             |     | vertical retrace interrupt status  |     |     | 14-3    |
| HSYNCNSYNC control  |        | 10-4,14-11  |     |                                    |     |     |         |
L
H
|                           |       |       |     | line compare       | 14-32           |       |     |
| ------------------------- | ----- | ----- | --- | ------------------ | --------------- | ----- | --- |
| hardware graphics cursor  |       |       |     | line error term    | 13-9, 18-8      |       |     |
| background color          |       | 16-4  |     | line error term 2  |                 | 18-9  |     |
| enable                    | 16-3  |       |     | linear addressing  |                 |       |     |
| foreground color          |       | 16-4  |     | enable             | 13-1,17-6,18-3  |       |     |
| pattern display x origin  |       | 16-5  |     | explained          | 13-1            |       |     |
pattern display y origin  16-5  window position  6-5, 17-7, 19-4
| programming            |     | 13-31 -13-32  |     | window size              |     | 17-6  |     |
| ---------------------- | --- | ------------- | --- | ------------------------ | --- | ----- | --- |
| setup  11-8            |     |               |     | locking register access  |     |       |     |
| storage start address  |     | 16-5          |     | See unlocking            |     |       |     |
Windows/X-Windows modes  13-31,17-4  LUT write cycle control  14-18
| x origin                 | 16-3  |       |     |     |     |     |     |
| ------------------------ | ----- | ----- | --- | --- | --- | --- | --- |
| y ongln                  | 16-4  |       |     | M   |     |     |     |
| high speed text display  |       | 15-3  |     |     |     |     |     |
high speed text font writing  15-10  M parameter  7-8 -7-9, 17-4
| horizontal blank              |        |        |        | See also PLL m parameter  |     |             |                   |
| ----------------------------- | ------ | ------ | ------ | ------------------------- | --- | ----------- | ----------------- |
| end  14-21                    |        |        |        | major axis pixel count    |     | 18-9        |                   |
| start  14-21                  |        |        |        | major axis pixel count 2  |     | 18-10       |                   |
| horizontal display end        |        | 14-20  |        | maximum scan line         |     | 14-24       |                   |
| horizontal sync               |        |        |        | MCLK                      |     |             |                   |
| control for power management  |        |        | 14-11  | external output           |     | 14-15       |                   |
| polarity                      | 14-2   |        |        | loading new frequency     |     |             | 9-3,14-15 -14-16  |
| horizontal sync position      |        |        |        | programming               |     | 9-3, 14-12  |                   |
| end  14-22                    |        |        |        | mechanical dimensions     |     | 2-1         |                   |
| start  14-22                  |        |        |        | memory                    |     |             |                   |
| horizontal total              | 14-20  |        |        | See also display memory   |     |             |                   |
HSYNC
| direction          | 10-7  |       |     |     |     |     |     |
| ------------------ | ----- | ----- | --- | --- | --- | --- | --- |
| direction control  |       | 3-10  |     |     |     |     |     |
INDEX  1-3

p•""J a
| .   |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
| memory mapped I/O  |             |     |     | enable I/O accesses     |      | 19-2  |       |
| ------------------ | ----------- | --- | --- | ----------------------- | ---- | ----- | ----- |
| described          | 13-4        |     |     | enable memory accesses  |      |       | 19-2  |
| enable             | 17-3, 18-4  |     |     | interface               | 6-1  |       |       |
MMIO only select  14-9  linear addressing base address  19-4
packed registers  13-5  master abort handling during DAC cycles
| memory mapping     |     |     |       | 8-4, 15-5  |      |     |     |
| ------------------ | --- | --- | ----- | ---------- | ---- | --- | --- |
| EnhancedNGA modes  |     |     | 15-3  | parity     | 6-1  |     |     |
minor axis pixel count  18-20  retry handling during DAC cycles  8-4,15-5
| MMIO                    |     |       |     | vendor 1.0.             | 6-1         |        |     |
| ----------------------- | --- | ----- | --- | ----------------------- | ----------- | ------ | --- |
| See memory mapped I/O   |     |       |     | pin 50 function select  |             | 14-10  |     |
| monitor identification  |     | 15-8  |     | pin descriptions        | 3-6 -3-12   |        |     |
| monitor information     |     | 5-1   |     | pin list                |             |        |     |
|                         |     |       |     | alphabetical            | 3-13 -3-15  |        |     |
| N                       |     |       |     | numerical               | 3-16 -3-20  |        |     |
pinout
| N parameter               | 7-8 -7-9, 17-9  |     |     | PCI Bus         | 3-4  |      |     |
| ------------------------- | --------------- | --- | --- | --------------- | ---- | ---- | --- |
| See also PLL n parameter  |                 |     |     | Tri032 PCI bus  |      | 3-2  |     |
| nibble swap               | 17-3            |     |     | Tri032 VL-Bus   |      | 3-3  |     |
|                           |                 |     |     | Tri064 PCI bus  |      | 3-4  |     |
o
|     |     |     |     | Tri064 VL-Bus  |     | 3-5  |     |
| --- | --- | --- | --- | -------------- | --- | ---- | --- |
pitch  14-28
| OE             |             |     |     | PLL M parameter       |     | 9-1,14-12 -14-13  |     |
| -------------- | ----------- | --- | --- | --------------------- | --- | ----------------- | --- |
| control        | 3-9,7-2     |     |     | PLL N parameter       |     | 9-1,14-12 -14-13  |     |
| stretch time   | 7-5, 17-12  |     |     | PLL R parameter       |     | 9-1,14-12 -14-13  |     |
| offset  14-28  |             |     |     | polygon fill pattern  |     | 13-26             |     |
|                |             |     |     | polygon fill solid    |     | 13-24             |     |
p
|     |     |     |     | polyline  13-23  |     |     |     |
| --- | --- | --- | --- | ---------------- | --- | --- | --- |
power management
| P parameter                | 7-9 -7-10, 14-9      |        |       | HSYNC control                   |        | 10-4,14-11   |        |
| -------------------------- | -------------------- | ------ | ----- | ------------------------------- | ------ | ------------ | ------ |
| packed registers for MMIO  |                      |        | 13-5  | VSYNC control                   |        | 10-4, 14-12  |        |
| palette registers          |                      | 14-42  |       | programming                     | 13-6   |              |        |
| lock access                | 15-5                 |        |       | programming examples            |        |              |        |
| panning                    | 14-24, 14-43, 14-45  |        |       | 2-point line                    | 13-23  |              |        |
| parity  6-1                |                      |        |       | 4-point trapezoid fill pattern  |        |              | 13-28  |
pass-through feature connector  10-7  4-point trapezoid fill solid  13-27
| PatBLT            |     |     |     | BitBLT across the plane   |     |     | 13-18  |
| ----------------- | --- | --- | --- | ------------------------- | --- | --- | ------ |
| See pattern fill  |     |     |     | BitBLT through the plane  |     |     | 13-17  |
pattern fill  18-13  Bresenham parameter trapezoid fill pattern
| pattern fill across the plane  |     |     | 13-21  | 13-30  |     |     |     |
| ------------------------------ | --- | --- | ------ | ------ | --- | --- | --- |
pattern fill through the plane  13-20  Bresenham parameter trapezoid fill solid
| pattern X  | 18-26  |     |     | 13-29                            |     |        |        |
| ---------- | ------ | --- | --- | -------------------------------- | --- | ------ | ------ |
| pattern Y  | 18-25  |     |     | hardware cursor                  |     | 13-31  |        |
| PCIBus     |        |     |     | image transfer across the plane  |     |        | 13-15  |
BIOS ROM access enable  19-5  image transfer through the plane  13-13
BIOS ROM base address  19-5  pattern fill across the plane  13-21
| configuration        |      | 6-1    |        | pattern fill through the plane  |        |        | 13-20  |
| -------------------- | ---- | ------ | ------ | ------------------------------- | ------ | ------ | ------ |
| configuration space  |      |        | 6-1    | polygon fill pattern            |        | 13-26  |        |
| cycles               | 6-1  |        |        | polygon fill solid              |        | 13-24  |        |
| device 1.0.          | 6-1  |        |        | polyline                        | 13-23  |        |        |
| DEVSEL timing        |      | 6-1    |        | rectangle fill solid            |        | 13-12  |        |
| disable read bursts  |      |        | 15-10  | short stroke vectors            |        |        | 13-22  |
| disconnection        |      | 6-1    |        | solid line                      | 13-9   |        |        |
| enable disconnect    |      | 17-11  |        |                                 |        |        |        |
1-4  INDEX

S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 'ncorporated
| textured line             |               | 13-10  |        | setup                     |       |               |        |
| ------------------------- | ------------- | ------ | ------ | ------------------------- | ----- | ------------- | ------ |
| protected mode            |               | 13-1   |        | enable 3C3H               |       | 17-10         |        |
|                           |               |        |        | Enhanced mode             |       |               | 11-6   |
| Q                         |               |        |        | hardware graphics cursor  |       |               | 11-8   |
|                           |               |        |        | Tri032fTri064             |       | 14-48         |        |
| quadword mode addressing  |               |        | 14-28  | VGA modes                 |       | 11-4          |        |
|                           |               |        |        | shared frame buffer       |       |               | 7-9    |
| R                         |               |        |        | enable                    | 17-1  |               |        |
|                           |               |        |        | short stroke vector       |       | 13-22, 18-15  |        |
| R parameter               |               |        |        | solid line drawing        |       | 13-9          |        |
| See PLL R parameter       |               |        |        | source base address       |       |               | 18-22  |
| RAMDAC                    |               |        |        | SRDY                      |       |               |        |
| AC specifications         |               | 4-2    |        | delay assertion           |       | 16-1          |        |
| access                    | 14-49 -14-51  |        |        | generation                |       | 6-6           |        |
| accessing                 |               | 8-4    |        | start address             |       | 14-26         |        |
| bus snooping              |               | 8-4    |        | start horizontal blank    |       |               | 14-21  |
clock doubled operation  8-2,14-18  start horizontal sync position  14-22
| color mode select        |     | 17-12      |        | start vertical blank      |           | 14-29  |             |
| ------------------------ | --- | ---------- | ------ | ------------------------- | --------- | ------ | ----------- |
| color modes              |     | 8-1 -8-2   |        | stepping information      |           |        | 15-1 -15-2  |
| DC characteristics       |     | 4-1        |        | strapping, configuration  |           |        | 5-1         |
| DC specifications        |     | 4-1        |        | STWR                      |           |        |             |
| disable LOCNSRDY         |     |            | 15-8   | function select           |           | 14-15  |             |
| lock writes              |     | 15-4       |        | operation                 |           | 10-4   |             |
| LUT write cycle control  |     |            | 14-18  | super VGA support         |           |        | 12-2        |
| PCI bus snooping         |     | 15-5       |        |                           |           |        |             |
| power down               |     | 14-18      |        | T                         |           |        |             |
| sense generation         |     | 8-4        |        |                           |           |        |             |
| RAS                      |     |            |        | test load, AC             |           | 4-2    |             |
| low time select          |     | 7-5,17-12  |        | test mode                 | 5-1,15-8  |        |             |
| precharge time select    |     |            | 7-5    | textured line drawing     |           |        | 13-10       |
RAS1 function  3-9,7-3  trapezoid 4-point fill pattern  13-28
| RDYIN  | 6-6 -6-8  |     |     | trapezoid 4-point fill solid  |     |     | 13-27  |
| ------ | --------- | --- | --- | ----------------------------- | --- | --- | ------ |
read mask  13-4,18-17  trapezoid Bresenham parameter fill pattern
| read/modify/write             |       | 18-23                |        | 13-30                                     |        |      |     |
| ----------------------------- | ----- | -------------------- | ------ | ----------------------------------------- | ------ | ---- | --- |
| real mode                     | 13-1  |                      |        | trapezoid Bresenham parameter fill solid  |        |      |     |
| rectangle fill solid drawing  |       |                      | 13-12  | 13-29                                     |        |      |     |
| refresh, DRAM                 |       | 7-3,7-8,14-28,15-10  |        | tri-state off                             |        |      |     |
| remote mode                   |       |                      |        | HSYNC                                     | 17-5   |      |     |
| See genlocking                |       |                      |        | PA[15:0]                                  | 17-11  |      |     |
| reset                         |       |                      |        | PO lines                                  | 14-9   |      |     |
| Graphics Engine               |       | 18-3                 |        | VCLK                                      | 17-5   |      |     |
| system                        | 5-1   |                      |        | VSYNC                                     | 17-5   |      |     |
| resolutions supported         |       |                      | 1-3    | Tri032                                    |        |      |     |
| revision status               |       | 15-1 -15-2           |        | PCI bus pinout                            |        | 3-2  |     |
| row scan count                |       | 14-24                |        | VL-Bus pinout                             |        | 3-3  |     |
Trio64
| 5   |     |     |     | PCI bus pinout  |     | 3-4  |     |
| --- | --- | --- | --- | --------------- | --- | ---- | --- |
|     |     |     |     | VL-Bus pinout   |     | 3-5  |     |
SAUP  3-6,5-3,6-5, 17-13
|               |       |       |     | two page screen  |     | 15-2  |     |
| ------------- | ----- | ----- | --- | ---------------- | --- | ----- | --- |
| screen off    | 14-6  |       |     |                  |     |       |     |
| screen width  |       | 17-2  |     |                  |     |       |     |
SENSE
| status of internal signal  |     |     | 14-3  |     |     |     |     |
| -------------------------- | --- | --- | ----- | --- | --- | --- | --- |
INDEX  1-5

S3 Trio32/Trio64 Integrated Graphics Accelerators
53 Incorporatad
u
|                                    |        |       | RDYIN input           | 6-6    |       |
| ---------------------------------- | ------ | ----- | --------------------- | ------ | ----- |
|                                    |        |       | SRDY generation       |        | 6-6   |
| underline location                 | 14-29  |       | write latching delay  |        | 6-6   |
| unlocking                          |        |       | VLKLI                 | 14-10  |       |
| configuration strapping registers  |        | 15-9  | VSYNC                 |        |       |
| Enhanced registers                 | 16-1   |       | direction             | 10-7   |       |
| extended sequencer registers       |        | 14-9  | direction control     |        | 3-10  |
| pseudocode for                     | 11-2   |       |                       |        |       |
w
| S3 VGA registers                    | 15-9  |       |                     |       |       |
| ----------------------------------- | ----- | ----- | ------------------- | ----- | ----- |
| system control/extension registers  |       | 15-9  |                     |       |       |
|                                     |       |       | wait state control  |       | 16-1  |
| v                                   |       |       | wakeup              | 11-1  |       |
WE
| VAFC feature connector      | 10-7  |        | delay time            | 7-5, 17-12         |               |
| --------------------------- | ----- | ------ | --------------------- | ------------------ | ------------- |
| VCLK                        |       |        | word mode addressing  |                    | 14-28, 14-31  |
| direction  10-10, 14-15     |       |        | write mask            | 13-2, 13-7, 18-17  |               |
| inversion of DCLK           | 15-4  |        | write per bit         | 17-3               |               |
| phase with respect to DCLK  |       | 17-11  |                       |                    |               |
| VCLKI  3-10,14-10           |       |        | x                     |                    |               |
vertical blank
| end  14-30            |        |     | X-Windows  | 13-31, 17-4  |     |
| --------------------- | ------ | --- | ---------- | ------------ | --- |
| start  14-29          |        |     |            |              |     |
| vertical display end  | 14-28  |     |            |              |     |
vertical retrace
| enable interrupt  | 14-27  |     |     |     |     |
| ----------------- | ------ | --- | --- | --- | --- |
end  14-27
| start  14-27  |     |     |     |     |     |
| ------------- | --- | --- | --- | --- | --- |
vertical sync
| active status                 | 14-3        |        |     |     |     |
| ----------------------------- | ----------- | ------ | --- | --- | --- |
| control for power management  |             | 14-12  |     |     |     |
| polarity  14-2                |             |        |     |     |     |
| vertical total  14-23         |             |        |     |     |     |
| VGA compatibility             | 12-1,14-1   |        |     |     |     |
| VGA graphics mode select      | 14-43       |        |     |     |     |
| VGA memory bus width          | 15-3        |        |     |     |     |
| VGA memory mapping            | 15-3 -15-4  |        |     |     |     |
| VGA setup  11-4               |             |        |     |     |     |
video BIOS
| access enable (PCI)     | 10-1, 19-5  |     |     |     |     |
| ----------------------- | ----------- | --- | --- | --- | --- |
| base address (PCI)      | 10-2, 19-5  |     |     |     |     |
| enable access           | 10-1, 15-7  |     |     |     |     |
| read functional timing  | 10-2        |     |     |     |     |
| ROM interface           | 10-1        |     |     |     |     |
| size selection          | 10-2, 15-8  |     |     |     |     |
| video display enable    | 14-41       |     |     |     |     |
VL-Bus
| address latch delay       | 6-7 -6-8, 17-6  |                |     |     |     |
| ------------------------- | --------------- | -------------- | --- | --- | --- |
| cycles  6-6               |                 |                |     |     |     |
| delay assertion of SRDY   |                 | 6-6,6-8, 16-1  |     |     |     |
| disable LOCA/SRDY         | 15-8            |                |     |     |     |
| enable video BIOS access  |                 | 15-7           |     |     |     |
| interface  6-5            |                 |                |     |     |     |
| RDYIN  6-7 -6-8           |                 |                |     |     |     |
1-6  INDEX

,,-
.,.~
-
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporatad

••
r
S3 Trio32/Trio64 Integrated Graphics Accelerators
S3 Incorporated
S3 Incorporated, 2770 San Tomas Expressway, Santa Clara, CA 95051-0968 Tel: 408-980-5400, Fax: 408-980-5444
Printed in USA 08014-8

S3 Incorporated
2770 San Tomas Expwy.
Santa Clara, CA 95051-0968
Tel: (408) 980-5400
Fax: (408) 980-5444
Printed in U.S.A. on recycled paper
06014-6
