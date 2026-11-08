Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Trio64V+
Integrated
Graphics/Video
Accelerator
July 1995
S3 Incorporated
2770 San Tomas Expressway
Santa Clara, CA 95051-0968

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
NOTATIONAL CONVENTIONS
The following notational conventions are used in this data book:
Signal names are shown in all uppercase letters. For example, XD.
A bar over a signal name indicates an active low signal. For example, DE.
n·m indicates a bit field from bit n to bit m. For example, 7-0 specifies bits 7 through 0, inclusive.
nom indicates a signal (pin) range from n to m. For example D[7:0[ specifies data lines 7 through 0, inclusive
Use of a trailing letter H indicates a hexadecimal number. For example, 7AH is a hexadecimal number.
Use of a trailing letter b indicates a binary number. For example, 010b is a binary number.
When numerical modifiers such as K or M are used, they refer to binary rather than decimal form. Thus, for example, 1 KByte would be
equivalentto 1024, not 1,000 bytes.
NOTICES
© Copyright 1995 S3 Incorporated. All rights reserved. No part of this publication may be reproduced, stored in a retrieval system, or
transmitted in any form or by any means, electronic, mechanical, photocopying, or otherwise, without the prior written consent of S3
Incorporated, 2770 San Tomas Expwy., Santa Clara CA 95051-0968. The S3 Corporate Logo, S3 on Board, S3 on Board design, Vision64,
Vision864, Vision868, Vision964, Vision968, Trio, Tri032, Tri064, Tri064V+, Streams Processor, MIC, Galileo, SDAC, Scenic/MX1,
Scenic/MX2, Sonic/AD, Native-MPEG, No Compromise Integration, No Compromise Acceleration and Innovations in Acceleration are
trademarks of S31ncorporated and S3 and True Acceleration are registered trademarks of S3 Incorporated. Other trademarks referenced
in this document are owned by their respective companies. The material in this document is for information only and is subject to change
without notice. 53 Incorporated reserves the right to make changes in the product design without resentation and 'vvithout notice to its
users.
Additional information may be obtained from:
S3lncorporated, Literature Department, 2770 San Tomas Expressway, Santa Clara, CA 95051-0968.
Telephone: 408-980-5400, Fax: 408-980-5444

II·
Tri064V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table of Contents
| List of Figures  |     | vi  Section 7: Display Memory  |                 | .... 7-1  |     |
| ---------------- | --- | ------------------------------ | --------------- | --------- | --- |
|                  |     | 7.1                            | DISPLAY MEMORY  |           |     |
CONFIGURATIONS ......... 7-1
| List of Tables.  |     | . viii  |                            |     |          |
| ---------------- | --- | ------- | -------------------------- | --- | -------- |
|                  |     | 7.2     | DISPLAY MEMORY REFRESH     |     | ... 7-4  |
|                  |     | 7.3     | DISPLAY MEMORY FUNCTIONAL  |     |          |
Section 1: Introduction  . 1-1  TIMING  ...... . . . . . . ..  7-4
1.1  OVERViEW.............  1-2  7.4  1-CYCLE EDO DRAM SUPPORT.  7-9
1.2  S3 STREAMS PROCESSOR  . . ..  1-2  7.5  DISPLAY MEMORY ACCESS
1.3  S3 SCENIC HIGHWAY  . . . . . ..  1-3  CONTROL. . . . . . . . . . . ..  7-11
1.4  Trio64V+ CHANGES FROM THE
| Trio64 . . . . . . . . . . . . . . ..  |     | 1-3                              |                  |               |      |
| -------------------------------------- | --- | -------------------------------- | ---------------- | ------------- | ---- |
|                                        |     | Section 8: RAMDAC Functionality  |                  |               | 8-1  |
|                                        |     | 8.1                              | OPERATING MODES  | ........ 8-1  |      |
Section 2: Mechanical Data  . . .. 2-1  8.2  COLOR MODES . . . . . . . . . . .  8-2
2.1  THERMAL SPECIFICATIONS.  2-1  8.2.1  8 Bits/Pixel -Mode 0  . . . . . .  8-2
2.2  MECHANICAL DIMENSIONS  .,. 2-1  8.2.2  Output-doubled 8 Bits/Pixel -
Mode 8  ............. 8-2
8.2.3  15/16-Bits/Pixel -Modes 9
| Section 3: Pins  . . . . . . . . . .. 3-1  |     |     |     |     |     |
| ------------------------------------------ | --- | --- | --- | --- | --- |
and 10 .............. 8-3
| 3.1  PINOUT DIAGRAMS   | ........ 3-1  |        |                                   |     |      |
| ---------------------- | ------------- | ------ | --------------------------------- | --- | ---- |
|                        |               | 8.2.4  | Packed 24 Bits/Pixel -Mode 12.    |     | 8-3  |
| 3.2  PIN DESCRIPTIONS  | ........ 3-4  |        |                                   |     |      |
|                        |               | 8.2.5  | 24 Bits/Pixel -Mode 13 . . . . .  |     | 8-3  |
3.3  PIN LISTS .............. 3-12
|     |     | 8.3  | RAMDAC REGISTER ACCESS          |     | . . .  8-3  |
| --- | --- | ---- | ------------------------------- | --- | ----------- |
|     |     | 8.4  | RAMDAC SNOOPING. . . . . . . .  |     | 8-3         |
Section 4: Electrical Data  ..... 4-1  8.5  SENSE GENERATION  ....... 8-3
4.1  MAXIMUM RATINGS  ....... 4-1  8.6  POWER CONTROL  . . . . . . ..  8-3
| 4.2  DC SPECIFICATIONS. . . . . . . .   |     | 4-1  |     |     |     |
| --------------------------------------- | --- | ---- | --- | --- | --- |
| 4.3  AC SPECIFICATIONS . . . . . . . .  |     | 4-3  |     |     |     |
Section 9: Clock Synthesis and
| 4.3.1  RAMDAC AC Specifications      |                     | . .  4-3                       |                                |                 |          |
| ------------------------------------ | ------------------- | ------------------------------ | ------------------------------ | --------------- | -------- |
|                                      |                     | Control                        | ............... 9-1            |                 |          |
| 4.3.2  Clock Timing                  | . . . . . . . . ..  | 4-4                            |                                |                 |          |
|                                      |                     | 9.1                            | CLOCK SYNTHESIS ......... 9-1  |                 |          |
| 4.3.3  Input/Output Timing           | . . . . . .         | 4-5                            |                                |                 |          |
|                                      |                     | 9.2                            | CLOCK REPROGRAMMING            | .... 9-2        |          |
|                                      |                     | 9.3                            | DCLK CONTROL                   | .......... 9-3  |          |
| Section 5: Reset and Initialization  |                     | 5-1                            |                                |                 |          |
|                                      |                     | Section 10: Streams Processor  |                                |                 | .  10-1  |
Section 6: System Bus Interfaces. 6-1  10.1  INPUT STREAMS. . . . . . . ..  10-1
6.1  PCI BUS INTERFACE  . . .  6-1  10.1.1  Primary Stream Input .... ,  10-2
6.1.1  PCICONFIGURATION  ..... 6-1  10.1.2  Secondary Stream Input .. ,  10-2
6.1.2  PCI Bus Cycles  . . . . . . . ..  6-1  10.1.3  Hardware Cursor Generation  10-2
| 6.2  VL-BUS INTERFACE  | . . . . . . . .  | 6-6  |     |     |     |
| ---------------------- | ---------------- | ---- | --- | --- | --- |
10.1.4  Frame Buffer Organization/
| 6.2.1  VL-Bus Cycles. . . . . . . . . .  |     | 6-6  |                   |           |       |
| ---------------------------------------- | --- | ---- | ----------------- | --------- | ----- |
|                                          |     |      | Double Buffering  | ...... ,  | 10-2  |
| 6.2.2  SRDY Generation. . . . . . ..     |     | 6-6  |                   |           |       |
iii

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
10.2  INPUT PROCESSING ........ 10-4  13.3  TESTING FOR THE PRESENCE
10.2.1  Primary Stream Processing  .. 10-4  OF A Trio64V+ CHIP  ...  13-4
10.2.2  Secondary Stream Processing. 10-5  13.4  GRAPHICS MODE SETUP  ...  13-4
10.3  COMPOSITION/OUTPUT ...... 10-5
10.3.1  Opaque Rectangular Overlaying 10-6  Section 14: VGA Compatibility
| 10.3.2  | Blending  | ........  | . 10-7  |     |     |     |
| ------- | --------- | --------- | ------- | --- | --- | --- |
10.3.3  Color/Chroma Keying.  . 10-8  Support  ............  14-1
10.3.4  Window Location. . . .  . 10-8  14.1  VGACOMPATIBILITY. . . . .  14-1
10.4  STREAMS FIFO CONTROL.  . 10-8  14.2  VESA SUPER VGA SUPPORT  14-2
Section 15: Enhanced Mode
| Section 11: Local Peripheral Bus  |     |     | 11-1  |                               |     |     |
| --------------------------------- | --- | --- | ----- | ----------------------------- | --- | --- |
|                                   |     |     |       | Programming  .......... 15-1  |     |     |
11.1  Scenic/MX2 INTERFACE ...... 11-2
15.1  LINEAR ADDRESSING FOR DIRECT
| 11.1.1  | Scenic/MX2 Register/Memory  |     |     |                            |     |       |
| ------- | --------------------------- | --- | --- | -------------------------- | --- | ----- |
|         | Access .............. 11-2  |     |     | VIDEO MEMORY CPU ACCESSES  |     | 15-1  |
11.1.2  Scenic/MX2 Compressed Data  15.2  VIDEO MEMORY ACCESS THROUGH
Transfer . . . . . . . . . ..  . 11-4  THE GRAPHICS ENGINE  . . . ..  15-2
11.1.3  Scenic/MX2 Video Capture  .. 11-5  15.3  MEMORY MAPPING OF
11.2  DIGITIZER INTERFACE ..  .11-7  REGISTERS  ........... .  15-4
11.2.1  12C Register Interface.  .11-7  15.3.1  Backward-Compatible MMIO  15-4
11.2.2  SAA7110Videolnput.  .11-8  15.3.2  New MMIO  ....... .  15-6
11.3  CL-480INTERFACE...  .11-9  15.4  PROGRAMMING  ..... .  15-7
11.4  HOST PASS-THROUGH  11-10  15.4.1  Notational Conventions  15-7
| 11.5  LPB-ENABLED PIN  |     |     |     | 15.4.2  Initial Setup ...... .  |     | 15-8  |
| ---------------------- | --- | --- | --- | ------------------------------- | --- | ----- |
ASSIGNMENTS. . . . .  11-10  15.4.3  Programming Examples  15-8
|     |     |     |     | 15.4.3.1 Solid Line  | ..... .  | 15-9  |
| --- | --- | --- | --- | -------------------- | -------- | ----- |
Section 12: Miscellaneous  15.4.3.2 Textured Line  ... .  15-10
|     |     |     |     | 15.4.3.3 Rectangle Fill Solid  | .   | 15-12  |
| --- | --- | --- | --- | ------------------------------ | --- | ------ |
Functions ............. 12-1  15.4.3.4 Image Transfer-Through
12.1  VIDEO BIOS ROM INTERFACE ... 12-1  the Plane .......... 15-13
12.1.1  Disabling BIOS ROM Accesses  12-1  15.4.3.5 mage Transfer-Across
12.1.2  BIOS ROM Hardware Interface  12-1  the Plane .......... 15-15
12.1.3  BIOS ROM Read Functional  15.4.3.6 BitBLT-Through the Plane 15-17
Timing .............. 12-2
15.4.3.7 BitBLT - Across the Plane . 15-18
| 12.1.4  | BIOS ROM Address Mapping  |     | . 12-2  |     |     |     |
| ------- | ------------------------- | --- | ------- | --- | --- | --- |
15.4.3.8 PatBLT-Pattern Fiii
| 12.2  GREEN PC SUPPORT. . .  |     |     | . 12-4  |     |     |     |
| ---------------------------- | --- | --- | ------- | --- | --- | --- |
Through the Plane ..... 15-20
12.3  GENERAL INPUT PORT  .  . 12-4  15.4.3.9 PatBLT-Pattern Fill Across
12.4  GENERAL OUTPUT PORT  . 12-5  the Plane . . . . . . . ..  15-21
12.5  FEATURE CONNECTOR  15.4.3.10 Short Stroke Vectors  ..  15-22
INTERFACE  . . . . . . . .  . 12-7  15.4.3.11 Programmable Hardware
12.6  SERIAL COMMUNICATIONS
|                                |                            |     |        | Cursor                     | . . . . . . . .  | 15-23  |
| ------------------------------ | -------------------------- | --- | ------ | -------------------------- | ---------------- | ------ |
| PORT                           | . . . . . . . . . . . . .  |     | 12-11  |                            |                  |        |
|                                |                            |     |        | 15.5  RECOMMENDED READING  | ..               | 15-24  |
| 12.7  INTERRUPT GENERATION. .  |                            |     | 12-11  |                            |                  |        |
Section 16: VGA Standard Register
Section 13: Basic Software
|            |           |                 |       | Descriptions  ........... 16-1.   |         |       |
| ---------- | --------- | --------------- | ----- | --------------------------------- | ------- | ----- |
| Functions  | .  . . .  | .  .  . .  . .  | 13-1  |                                   |         | ",    |
|            |           |                 |       | 16.1  GENERAL REGISTERS           | .... .  | IU-I  |
13.1  CHIP WAKEUP  ........... 13-1  16.2  SEQUENCER REGISTERS  .. .  16-5
13.2  REGISTER ACCESS ......... 13-2  16.3  CRT CONTROLLER REGISTERS  16-21
13.2.1  Unlocking the S3 Registers  . 13-2  16.4  GRAPHICS CONTROLLER
13.2.2  Locking the S3 Registers.  . 13-3  REGISTERS  .......... .  16-36
| 13.2.3  | Unlocking/Locking Other  |     |     |     |     |     |
| ------- | ------------------------ | --- | --- | --- | --- | --- |
16.5  ATTRIBUTE CONTROLLER
Registers  ............ 13-3
|     |     |     |     | REGISTERS  | ........... . 16-43  |     |
| --- | --- | --- | --- | ---------- | -------------------- | --- |
iv

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
16.6  RAMDAC REGISTERS  ...... 16-49  A.1  VGA REGISTERS ........... A-2
A.2  S3 VGA REGISTERS ........ A-11
A.3  SYSTEM CONTROL REGISTERS  . A-13
Section 17: S3 VGA Register
A.4  SYSTEM EXTENSION REGISTERS  A-15
| Descriptions  | .  . .  .  . . ..  | ., 17-1  |     |     |
| ------------- | ------------------ | -------- | --- | --- |
A.5  ENHANCED COMMANDS
|     |     |     | REGISTERS  | ............ A-19  |
| --- | --- | --- | ---------- | ------------------ |
A.6  STREAMS PROCESSOR
Section 18: System Control
|                        |     |                | REGISTERS      | ............ A-23  |
| ---------------------- | --- | -------------- | -------------- | ------------------ |
| Register Descriptions  |     | . ..  .  18-1  |                |                    |
|                        |     | A.7            | LPB REGISTERS  | .......... A-27    |
A.8  PCI CONFIGURATION SPACE
| Section 19: System Extension  |     |                      | REGISTERS  | ............ A-30  |
| ----------------------------- | --- | -------------------- | ---------- | ------------------ |
| Register Descriptions         |     | .  . . . .  .  19-1  |            |                    |
Index  ................ 1-1
Section 20: Enhanced Commands
| Register Descriptions  |     | ...... 20-1  |     |     |
| ---------------------- | --- | ------------ | --- | --- |
Section 21: Streams Processor
| Register Descriptions  |     | .  .  .  21-1  |     |     |
| ---------------------- | --- | -------------- | --- | --- |
Section 22: LPB Register
| Descriptions  | .  .  .  . ..  | . ... 22-1  |     |     |
| ------------- | -------------- | ----------- | --- | --- |
Section 23: PCI Register
| Descriptions                    | .  . .  . .  | .  23-1  |     |     |
| ------------------------------- | ------------ | -------- | --- | --- |
| Appendix A: Register Reference  |              | A-l      |     |     |
v

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
List of Figures
|                               | #     | Title               | Page  |
| ----------------------------- | ----- | ------------------- | ----- |
| #  Title                      | Page  |                     |       |
| 2-1  208-pin PQFP Mechanical  | 11-3  | Scenic/MX2 Write    |       |
| Dimensions . . . . . . . .    | 2-2   | (Scenic/MX2 Ready)  | 11-3  |
| 3-1  Trio64V+ PCI Bus Pinout- | 11-4  | Scenic/MX2 Write    |       |
LPB Mode . . . . . . . . .  3-2  (Scenic/MX2 Not Ready)  11-3
| 3-2  Trio64V+ VL-Bus Pinout - | 11-5       | Scenic/MX2 Read     |           |
| ----------------------------- | ---------- | ------------------- | --------- |
| LPB Mode . . . . . . . .      | 3-3        | (Scenic/MX2 Ready)  | ..  11-3  |
| 4-1  Clock Waveform Timing    | 4-4  11-6  | Scenic/MX2 Read     |           |
4-2  Input Timing  .. . .  4-5  (Scenic/MX2 Not Ready)  11-3
4-3  Output Timing  . . . .  4-7  11-7  Scenic/MX2 Compressed
4-4  ResetTiming  . . . . .  .4-10  Transfer (Ready)  ....  11-4
6-1  Basic PCI Read Cycle .  6-2  11-8  Scenic/MX2 Stopping a
6-2  Basic PCI Write Cycle.  6-2  Compressed Xfer . . . .  11-5
6-3  PCI Disconnect Example A .  6-3  11-9  Scenic/MX2 VSYNC and
6-4  PCI Disconnect Example B .  6-3  HSYNC Protocols  . . . .  11-5
6-5  PCI Configuration Write Cycle  6-4  11-10  Scenic/MX2 Video Input
6-6  PCI Configuration Read Cycle  6-4  (Trio64V+ Ready)  . . . .  11-6
6-7  Read Parity Operation  . . . .  6-5  11-11  Scenic/MX2 Video Input
6-8  VL-Bus Read Cycle  . . . . . .  6-7  (Trio64V+ Not Ready) . .  11-6
6-9  1 Wait-state VL-Bus Write Cycle.  6-8  11-12  Tri064V+ to SAA7110 Digitizer
| 7-1  1-or 2-MByte DRAM  |     | Interface . . . . . . . .  | 11-7  |
| ----------------------- | --- | -------------------------- | ----- |
Configuration . . . . . . . . ..  7-2  11-13  16-to 8-bit Video Data
7-2  4-MByte DRAM Configuration.  7-3  Conversion  ......  11-8
7-3  Fast Page Mode Read Cycle  ..  7-4  11-14  Video 81n or 16 Mode Input  11-8
7-4  Fast Page Mode Write Cycle ..  7-5  11-15  Video 8 In or 16 Mode Input  11-9
7-5  Fast Page Mode Read/Modify/  12-1  BIOS ROM PCI Configuration
Write Cycle  . . . . . . . . . ..  7-6  Interface. . . . . . . . . . ..  12-1
7-6  EDO Mode Read Cycle . . . ..  7-7  12-2  BIOS ROM VL-Bus Configuration
7-7  EDO Mode Read/Modify/Write  Interface . . . . . . . . . . .  12-2
| Cycle ............. "  | 7-8  12-3  | BIOS ROM Read Functional  |     |
| ---------------------- | ---------- | ------------------------- | --- |
7-8  1-Cycle EDO Mode Read/Write  7-9  Timing -PCI  . . . . . . . . .  12-3
7-9  1-cycle EDO Read/Modify/Write  12-4  General Input Port Interface
Cycle ................ 7-10  (VL-Bus)  . . . . . . . . . . .  12-4
8-1  Internal RAMDAC Block Diagram  8-1  12-5  General Input Port Timing
PLL Block Diagram
9-1  . . . . . .  9-2  (VL-Bus)  . . . . . . . . . . .  12-5
10-1  Streams Processor  . . . . ..  . 10-1  12-6  General I/O Port Timing (PCI)  12-5
10-2  Screen Definition Parameters  . 10-5  12-7  General Output Port Interface
11-1  LPB Internal Block Diagram  . 11-1  (VL-Bus)  . . . . . . . . . . .  12-6
11-2  Trio64V+ to Scenic/MX2  12-8  General Output Port Timing
Hardware Interface .... ,  . 11-2  (VL-Bus)  . . . . . . . . . . .  12-6
vi

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| #  Title  |     | Page  |
| --------- | --- | ----- |
12-9  VAFC Implementation
| (32-bit PO Bus)  | ....  | · 12-8  |
| ---------------- | ----- | ------- |
12-10  VAFC Implementation
....
| (64-bit PO Bus)  |     | · 12-8  |
| ---------------- | --- | ------- |
12-11  Pass-Thru Feature Connector
| (32-bit PO) . . . . . . . . . . .  |     | · 12-9  |
| ---------------------------------- | --- | ------- |
12-12  Pass-Thru Feature Connector
(64-bit PO) ........
· 12-9
| 15-1  Pixel Update Flowchart  | ...  | · 15-3  |
| ----------------------------- | ---- | ------- |
vii

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
List of Tables
# Title Page # Title Page
3-1 Pin Descriptions -LPB Mode. 3-4 10-1 Register Fields Used For Specifying
3-2 Alphabetical Pin Listing .. . . 3-12 Frame Buffer Organization and
3-3 Numerical Pin Listing .... . . 3-15 Double Buffering . . . . . . .. 10-3
4-1 Absolute Maximum Ratings. 4-1 10-2 Register Fields Used For Scaling
4-2 RAMDAC/Clock Synthesizer DC Up the Secondary Stream . .. 10-6
Specifications . . . . . . . . 4-1 11-1 LPB-Enabled Pin Assignments. 11-11
4-3 RAMDAC Characteristics. . 4-1 12-1 Tri064-compatible Feature
4-4 Digital DC Specifications . . 4-2 Connector Configuration 12-7
4-5 RAMDAC AC Specifications 4-3 12-2 LPB Feature Connector
4-6 Clock Waveform Timing . . 4-4 Configuration (VL-Bus) . 12-10
4-7 SCLK-Referenced Input Timing 4-5 12-3 LPB Feature Connector
4-8 LCLK-Referenced Input Timing 4-6 Configuration (PCI) . . . 12-10
4-9 MCLK-Referenced Input Timing 4-6 13-1 VGA Register Access Control
4-10 SCLK-Referenced Output Timing 4-7 Extensions. . . . . . . . . .. 13-3
4-11 LCLK-Referenced Output Timing 4-8 14-1 Standard VGA Registers Modified
4-12 MCLK-Referenced Output Timing 4-8 or Extended in the Tri064V+ 14-1
4-13 CL-480 Timings -Tri064V+ Driving 15-1 Enhanced Registers Memory
Host Interface. . . . . . . . . . . 4-8 Mapping. . . . . . . . 15-5
4-14 Feature Connector Timing -Output 15-2 New MMIO Addresses 15-6
from Tri064V+ to Feature A-1 VGA Registers .... . A-2
Connector . . . . . . . . . . . .. 4-8 A-2 S3 VGA Registers A-11
4-15 Feature Connector Timing - A-3 System Control Registers A-13
Output from Feature Connector to A-4 System Extension Registers A-15
Tri064V+. . . . . . . . . . . . . . 4-9 A-5 Enhanced Commands Registers A-19
4-16 Reset Timing ........... 4-10 A-6 Streams Processor Registers. A-23
5-1 Definition of PD[28:0) at the Rising A-7 LPB Registers . . . . . . A-27
Edge of the Reset Signal . . . .. 5-2 A-8 PCI Configuration Space
6-1 VL-Bus Upper Address Decoding 6-6 Registers. . . . . . . . . A-30
7-1 Memory Size/Chip Count
Configurations ...... . 7-1
8-1 Tri064V+ Color Modes .. . 8-2
9-1 PLL R Parameter Decoding. 9-1
viii

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 1: Introduction
High-Performance Integrated Graphics/Video • Arithmetic blending of two pixel
Accelerator streams for fade-in/fade-out transition
High-performance DRAM-based 64-bit effects
graphics engine
S3 Scenic Highway Interface
• Integrated 24-bit RAMDAC with 135 MHz
output pixel rate and programmable • Philips SAA7110/SAA7111 video
dual-clock synthesizer digitizers
S3 Scenic/MX2 MPEG-1 audio/video
• Unique S3 Streams Processor for hard
ware-assisted video playback decoder, C-Cube CL-480 MPEG-1 de
coder
S3 Scenic Highway for direct interface to
live video and MPEG-1 peripherals
High Non-Interlaced Screen Resolution Support
• 1280x1 024x256 colors at 75 Hz refresh
S3 Trio64-compatible Mode Option
• 1024x768x64K colors at 75 Hz refresh
S3 Streams Processor Features
• 800x600x16.7M colors at 75 Hz refresh
• Supports on-the-fly stretching and blend
ing of primary RGB stream and RGB or High-Performance Memory Interface
YUV (video) secondary stream
• 54-bit DRAM memory interface
• Each stream can have different color Supports 1-. 2-, or 4-MByte frame buffer
depths
• Supports standard fast page mode and
YUV data is color space converted EDO DRAMs (50 MHz) and 1-cycle EDO
DRAMs (50 MHz)
Advanced Playback Capabilities
• High-quality hardware-assisted video Supports CPUs with Big or Little Endian Byte
playback (up to 1024x758x16 bits/pixel) Ordering
Support for India, Cinepak, and software
accelerated MPEG-1 video playback Industry-Standard Local Bus Support
Glueless PCI bus support (fully compli
Game and Presentation Effects. ant with Revision 2.0)
Hardware double-buffering support for • Glueless VESA® VL-Bus support
high-quality tear-free playback
• 2-D scrolling and sprite plane support
• Color and chroma keying for overlaying
of graphics onto video and video onto
graphics
INTRODUCTION 1-1

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Multimedia Support Hooks devices and live video digitizers to attain full-mo
tion video.
• Glueless 16-bit VESA Advanced Feature
Connector (VAFC)
• 8-bit bidirectional feature connector 1.2 S3 STREAMS PROCESSOR
• S3 Scenic Highway
The S3 Streams Processor™ allows the mixing
• 12C bus
of three separate display streams. The primary
stream can be RGB data of any color depth. The
Full Software Support
secondary stream can be RGB or YUV (video)
• Drivers for Windows® 3.11, Windows® data of any color depth. YUV data is color space
NT, Windows® 95, OS/2® 2.1 and 3.0 converted to RGB. The third stream, the hard
(WarpTM), SCO®UNIX®
ware cursor, overlays the other two streams.
Green PC/Monitor Plug and Play Support Arithmetic blending of a primary graphics stream
• Full hardware and BIOS support for and secondary graphics/video enables dramatic
VESA Display Power Management Sig transition effects for game applications. Color
naling (DPMS) monitor power savings and chroma keying allow opaque or transparent
modes overlays of one stream on the other. Hardware
assisted double buffering of both primary and
• DDC monitor communications support
secondary data streams is also provided to en
able high-quality "tear-free" playback.
Extensive Static/Dynamic Power Management
The Tri064V+ also enhances game acceleration,
Industry-Standard 20S-pin PQFP package
with support for a sprite plane where sprites are
actually rendered into a sprite plane memory.
1.1 OVERVIEW Sprites can be overlaid onto the background
without saving and restoring the background.
The S3® Tri064V+TM integrated graphics/video
accelerator (hereinafter referred to as the The Streams Processor is located in the pixel
Tri064V+) combines high-performance graphics datapath between the display memory and the
and high-quality video acceleration features with RAMDAC that drives the RGB signals to the moni
the capability to directly interface to live video tor. One of the key advantages of this architec
and MPEG-1 peripherais. it incorporates an en ture is that it permits processing of pixel streams
hanced version of the 64-bit graphics accelerator on the fly at display refresh rates. This eliminates
core and high-performance 135 MHz true-color the need to first write back processed (scaled or
RAMDAC that are found in S3's Tri064™ accel color-space-converted) data into the frame buffer
erator. All display applications that require high before sending it to the RAMDAC. This saves
quality video playback (from a CD-ROM or hard memory storage and memory bandwidth.
drive), or live video input capability, can take
advantage of the Tri064V+'s new features. The The Streams Processor also enables simultane
Tri064V+ accelerates and enhances software ous display of graphics and video of different
MPEG-1/lndeo™ /Cinepak™ video playback by color depths. For example, it is possible to dis
providing arbitrary scaling with high-quality lin play 24 bits/pixel-equivalent video on top of an
ear interpolation and color space conversion 8-bit graphics background. This also saves mem
(RGB to YUV). By performing these tasks in hard ory bandwidth and storage capacity while per
ware and relieving the CPU of a substantial over mitting higher frame rates because of reduced
head, the Tri064V+ offers high-quality video bandwidth requirements.
playback with window sizes of up to 1024x768x16
bits/pixel at high frame rates. The Tri064V+ has In addition, if an opaque rectangular window of
an S3 Scenic HighwayTM interface that provides one stream is overlaid onto another background
a direct interface to MPEG-1 audio/video decoder window of a second stream, it is not necessary
1-2 INTRODUCTION

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
to fetch and refresh the hidden pixels. This pro Processor, the following new features are pro
vides additional memory bandwidth savings. vided in either compatible or LPB mode:
• All registers addresses relocatable for
1.3 S3 SCENIC HIGHWAY
plug and play support
• Big and little endian addressing support
The S3 Scenic Highway interface directly con
(PowerPCTM /Intel®)
nects to MPEG-1 audio/video decoders. such as
the S3 Scenic/MX2™ MPEG-1 audio/Video de • 50 MHz single-cycle EDO memory sup
coder and the C-Cube® CL-4S0 as well as video port
digitizers such as the Philips® 7110n111. This • Power down input signal to power down
provides easy implementation of MPEG-1 or digi the DAC RGB output
tal video daughtercards that directly plug into the
• Packed 24 bits/pixel (unaccelerated)
Scenic Highway connector or, alternately, ISA
mode
cards, where a ribbon cable is also necessary.
Pass-through mode allowing decimation
The Streams Processor and Scenic Highway are of 32-bit CPU writes to the frame buffer
tightly coupled to provide optimal live video
playback. The hardware automatically switches The following new features are provided only in
capture and display buffers without software in LPB mode:
tervention.
Bi-directional Scenic/MX2 Scenic High
way interface in either VL-BuS™ or PCI
1.4 Trio64V+ CHANGES FROM THE bus configuration
Trio64 • In PCI configurations, input only or bi-di
rectional CL-4S0 Scenic Highway inter
The Tri064V+ comes in two configurations, se face
lectable by power-on strapping. • In PCI configurations, 16-bit digitizer
data Scenic Highway interface
• Compatible Mode (compatibility with
• Serial Communications Port (i2C and
Tri064)
DDC2 monitor communications)
• Local Peripheral Bus (LPB) Mode
• Serial port can optionally be accessed
via I/O ports E2 or ES to allow use when
In compatible mode, the Tri064V+ can be in
the Tri064V+ is disabled
stalled in a Tri064 socket. Some software modi
fications are required to operate the chip. The • S-bit bi-directional (VL-Bus or PCI) or 16-
pinout changes significantly for LPB mode. This bit VAFC (PCI bus) feature connector sup
means that compatible mode and LPB mode are port that is not restricted to 1-MByte
not compatible. That is, a given design must be video modes as with the Tri064 and
based one or the other. Once the chip is enabled which requires no external glue logic
in one mode, it must not be switched to the other. • Support for 4 MBytes of EDO memory in
PCI configurations
This data book describes only how the Tri064V+
• General Input/Output Port support via
operates in LPB mode. In compatible mode, the
the LPB data bus
physical and functional characteristics of the
Tri064V+ are the same as described for the Tri064
in the Trio32/Trio64 Graphics Accelerators Data
Book (DB014-A).
A major functional difference available in either
mode is the S3 Streams Processor described
earlier in this section. In addition to the Streams
INTRODUCTION 1-3

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
The following Trio64 features are not available in
LPB mode:
• Genlocking
• Shared frame buffer support
Direct decoding of the VL-Bus SA[31 :23]
lines. Two SAUP inputs provide indirect
decoding via external logic
4 MBytes of fast page memory in VL
Bus configurations
1-4 INTRODUCTION

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Section 2: Mechanical Data
2.1  THERMAL SPECIFICATIONS
| Parameter                           | Min  | Typ  | Max  | Unit  |
| ----------------------------------- | ---- | ---- | ---- | ----- |
| Thermal Resistance 0JC              |      | 5    |      | °C/W  |
| Thermal Resistance 0JA (Still Air)  |      | 24   |      | °C/W  |
| Junction Temperature                |      |      | 125  | °C    |
2.2  MECHANICAL DIMENSIONS
The Trio64V+ comes in a 208-pin PQFP package. The mechanical dimensions are given in Figure 2-1.
MECHANICAL DATA 2-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
30.60,.0.30
29.60,.0.20
28.80
o
'"
~
.,;
'"
0.50,.0.10 0.20,.0.08.11.
LINEAR DIMENSIONS
ARE IN MILLIMETERS
0.50,.0.20 mechdim
Figure 2-1. 20S-pin PQFP Mechanical Dimensions
2-2 MECHANICAL DATA

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Section 3: Pins
3.1 PINOUT DIAGRAMS
The Tri064V+ comes in a 208-pin PQFP package. It has two primary operating modes with significantly
different pin definitions. These modes are selected according to the strapping of the PD24 pin at
power-on reset.
If PD24 is strapped low at reset, the Trio64V+ powers up in Local Peripheral Bus (LPB) mode. This mode
is not pin compatible with the Tri064 but offers additional functions. The pinout for this mode for a PCI
configuration is shown in Figure 3-1. The pinout for this mode for a VL-Bus configuration is shown in
Figure 3-2.
PINS 3-1

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
| XOUT              |                 | POOIGAO'     |
| ----------------- | --------------- | ------------ |
| CLKAVDD1          |                 | PD141GA14'   |
| AVSS              |                 | PD1fGA,'     |
| CLKAVDD2          |                 | PDl3/GA13'   |
| AVSS              |                 | PD2fGA2'     |
| VREF              |                 | VSS          |
| AVSS              |                 | PDl2fGA12'   |
| AVOC              |                 | POOIGA3'     |
| PDOWN'            |                 | VOO          |
| RSET              |                 | PD11IGA 11'  |
| AVSS              |                 | P04lGA4'     |
| AR                |                 | PD10IGA10'   |
| AVDD              |                 | PDSlGAS'     |
| AVOD              |                 | PD9/GA9'     |
| AG                |                 | PD6/GAS'     |
| AB                |                 | P08!GAs'     |
| AVSS              |                 | P07/GA7'     |
| LD4IPA4'          |                 | vss          |
| LOS/PAS'          |                 | CASO         |
| HSELO'            |                 | CAS1         |
| HSEl,'            |                 | RASO         |
| HSEL2'            |                 | CAS2         |
| ~ .               | Trio64V+ (PCI)  | C A S 3      |
| 'DffiK.  1 W i'   |                 | vo o         |
MAS
| CF~;~~~:  | LPB MODE  | ~::  |
| --------- | --------- | ---- |
::!
| lD81~=~:                  | TOP VIEW  |                 |
| ------------------------- | --------- | --------------- |
| LD9JPA9IH01'              |           | MA2             |
| LD101PA101HD2'            |           | MAS             |
| LD111PA111HD3'            |           | MA3             |
| LOl21PA121HD4'            |           | MA4             |
| ~GOP1'                    |           | vss             |
| iCANK*                    |           | POOt            |
| von                       |           | PDl6lGOO'       |
| FiEill                    |           | PD30            |
| SClK                      |           | PD17/GD,'       |
| VSS                       |           | PD29            |
| velKI'                    |           | PDt8/GOZ'       |
| RESERVE[) FOR PCI GN,...  |           | PD28            |
| RESERVED FOR PCI REa<     |           | PD19JGD3'       |
| LDt3lPA131HOS'            |           | von             |
| LDl41PA141H06'            |           | POO7            |
| LDl5/PA1SJHD7'  LD7IPA7'  |           | PD20IG04'  VSS  |
| ~RDY/HSlEVlDEO'           |           | PD26            |
| CREQlCRDYNS/EVCLK'        |           | PD21IGOS'       |
| SPCLK'                    |           | POlS            |
| gPO'                      |           | PD22IG06'       |
| AOOl                      |           | POl4            |
AD30 -"'M'TIM'TIM'TIM'TIM'TIM'TIM'TIM'TIrTI'rTI'rTI'rTI'rTI'rTI'rTI'rTI'rTI'mmmmmmmmmmmmmmmmm-f"-P023/G07'
KVPCIPIN
• = Pin functions changed from Compatible Mode
Figure 3-1, Trio64V+ PCI Bus Pinout -LPB Mode
3-2  PINS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| XOUT                    |                    | POO     |
| ----------------------- | ------------------ | ------- |
| CLKAVOD1                |                    | PD14    |
| AYSS                    |                    | PD1     |
| CLKAVDD2                |                    | P013    |
| AVSS                    |                    | PD2     |
| VREF                    |                    | YSS     |
| AVSS                    |                    | P012    |
| AVOO                    |                    | PD3     |
| ~                       |                    | VOO     |
| RSET                    |                    | PDtt    |
| AVSS                    |                    | PD4     |
| AA                      |                    | ~       |
| AVOD                    |                    | POS     |
| AVDD                    |                    | POG     |
| ~                       |                    | ~       |
| ~                       |                    | ~       |
| AVSS                    |                    | P07     |
| LD4IPM*                 |                    | vss     |
| LD5JP AS·               |                    | CAsii   |
| SA2                     |                    | CA Si   |
| SAl                     |                    | n m     |
| SA4                     |                    | ~       |
| =~                      | Trio64V+ (VL-BUS)  | ~~~'    |
| SA7                     |                    | MA8     |
|                         | LPB MODE           | ::~     |
| L~~;                    | TOP VIEW           | :~:     |
| SA11                    |                    | MA2     |
| SA12                    |                    | MAS     |
| SA13                    |                    | MA3     |
| SA14                    |                    | MA4     |
| SAlS                    |                    | VSS     |
| SAt6                    |                    | P031    |
| VOO                     |                    | PDt6    |
| SRrSH'                  |                    | P030    |
| SClK                    |                    | PDt7    |
| VSS                     |                    | P029    |
| SAt7                    |                    | POtS    |
| SAtS                    |                    | P02S    |
| SA11                    |                    | POtl    |
| SA20                    |                    | VDD     |
| SA2t                    |                    | P027    |
| SA22                    |                    | VSS     |
| lD71PA7'                |                    | PD20    |
| V"'REOivRDYIHSJEVIOEO'  |                    | P026    |
| C""REciicRDYNSJEVCLK'   |                    | PD21    |
| SPCLKlESYNC*            |                    | P02S    |
| SPDnlrANR'              |                    | PD22    |
| SOOt                    |                    | PD24    |
so,. -"lnTTTTTTTTTT'I'TT'I'TI'TTI'TTI'TT~~I'm~m-,m-,TTTTTTTTTTTTT'I'Tl'TTl'TTl'TTl'TTl'mlTl'rml'mm-,m-,'TTI'TTITTTTTT"'--- PD2'
KVVLP1NS
Figure 3-2. Trio64V+ VL-Bus Pinout -LPB Mode
PINS  3-3

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
3.2 PIN DESCRIPTIONS
The following table provides a brief description of each pin on the Trio64V+ for its PCI bus and VL-Bus
configurations in LPB mode. The following abbreviations are used for pin types.
I -Input signal
o -Output signal
B -Bidirectional signal
Some pins have mUltiple names. This either reflects the different functions performed by those pins
depending on the bus configuration selected by power-on-strapping or multiplexed pins whose
functions are selected via a register bit setting. The pin definitions and functions are given for each
possible case.
Table 3-1.  Pin Descriptions -LPB Mode
| Symbol  | Type  Pin Numberls)  | Description  |
| ------- | -------------------- | ------------ |
BUS INTERFACES
Address and Data
AD[31 :0]  B  207-208, 1-6,  (PCI) Multiplexed Address/Data Bus. A bus transaction
10-11. 13-18,  (cycle) consists of an address phase followed by one
|     | 28-31,33-36,  | or more data phases.  |
| --- | ------------- | --------------------- |
39-46
| SD[31 :0]  | B   | (VL) System Data Bus.  |
| ---------- | --- | ---------------------- |
SA[22:2]  I  201-196,191- (VL) System Address Bus Lines 22:2.
185, 183-176
SAUP1 (VL)  I  25  (VL) Upper Address Decode 1. In conjunction with
SAUP2 this input tells the Trio64V+ when to respond
when its memory/register address space has been
relocated above 4 MBytes. Specifically,
SAUPI = 0, SAUP2 = 1 -register/port address access
SAUPl = 1, SAUP2 = 0 -video memory access
The other two combinations are ignored.
| SAUP2 (VL)  |     | (VL) Upper Address Decode 2. See definition for  |
| ----------- | --- | ------------------------------------------------ |
I  50
SAUP1.
C/BE[3:0]  I  7,19,27,38  (PCI) Bus Command/Data Byte Enables. These signals
carry the bus command during the address phase and
the byte enables during the data phase.
| SBE[3:0]  |     | (VL) Data Byte Enables.  |
| --------- | --- | ------------------------ |
Bus Control
| SCLK   | I  194  | (PCI) PCI System Clock.   |
| ------ | ------- | ------------------------- |
| SCLK   | I       | (VL) CPU System Clock     |
| INTA   | 0  152  | (PCI) Interrupt Request.  |
| SINTR  |         | (VL) Interrupt Request.   |
3-4  PINS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 3-1. Pin Descriptions -LPB Mode (Continued)
Symbol Type Pin Number(s) Description
IRDY I 21 (PCI) Initiator Ready. A bus data phase is completed
when both IRDY and TRDY are asserted on the same
cycle.
RDYIN (VL) Local Bus Cycle End Acknowledge. The Tri064V+
holds read data valid on the system data bus until this
input is asserted.
TRDY 0 23 (PCI) Target Ready. A bus data phase is completed
when both IRDY and TRDY are asserted on the same
cycle.
SRDY (VL) Local Bus Cycle End.
DEVSEL 0 24 (PCI) Device Select. The Tri064V+ drives this signal
active when it decodes its address as the target of the
current access.
LOCA (VL) Local Bus Access Cycle Indicator. This signal is
output during local bus cycles to allow system logic
chip sets to prevent concurrent EISA/ISA cycle
generation.
IDSEL I 8 (PCI) Initialization Device Select. This input is the chip
select for PCI configuration register reads/writes.
SM/IO I (VL) Memory/I/O Cycle Indicator. This signal is high for
a memory cycle and low for an I/O cycle.
RESET I 193 (PCI) System Reset. Asserting this signal forces the
registers and state machines to a known state.
SRESET (VL) ~stem Reset.
FRAME I 20 (PCI) Cycle Frame. This signal is asserted by the bus
master to indicate the beginning of a bus transaction.
It is deasserted during the final data phase of a bus
transaction.
SADS (VL) System Address Strobe.
PAR 0 26 (PCI) Parity. The Tri064V+ asserts this signal to verify
even parity during reads.
SW/R I (VL) Write/Read Cycle Indicator. This signal is high for
a write and low for a read.
PINS 3-5

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 3-1. Pin Descriptions -LPB Mode (Continued)
Symbol Type Pin Number(s) Description
STOP 0 25 (PCI) Stop. The Tri064V+ asserts this signal to indicate
a target disconnect.
SAUP1 (VL) Upper Address Decode 1. In conjunction with
SAUP2 this input tells the Tri064V+ when to respond
when its memory/register address space has been
relocated above 4 MBytes. Specifically,
SAUP1 = 0, SAUP2 = 1 -register/port address access
SAUP1 = 1, SAUP2 = 0 -video memory access
The other two combinations are iqnored.
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
MA[8:0[ 0 80, 78, 76, 74, Memory Address Bus. The video memory row and
72. 73, 75, 77, column addresses are multiplexed on these lines.
79
PD[63:32] B 122, 120, 118, Display Memory Pixel Data Bus Lines 63:32. Certain of
I 116, 113, 111, these pins are enabled for feature connector operation
109,107,106, when bit 0 of SRD is set to 1 and bit 1 of SRD is
108,110,112, cleared to O.
115,117,119,
121,144,142,
140,138,134,
132,130,128,
127,129,131,
133,136,139,
141, 143
PD[31:0] B 70, 68, 66, 64, Display Memory Pixel Data Bus Lines 31 :0. PD[28:0]
61, 58, 56, 54, are also used as the system configuration strapping
53,55,57, 59, bits, providing system configuration and setup
63,65,67,69, information upon power-on or reset. After reset, the
105,103,101, General Data Bus signals are multiplexed on 24 of
98, 95, 93, 91, these pins.
89, 88, 90, 92,
94,97,100,
102,104
3-6 PINS

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 3-1. Pin Descriptions -LPB Mode IContinued)
Symbol Type Pin Numberls) Description
Memory Control
RAS[1:0] 0 50. 84 Row Address Strobes. RASl is output on pin 50 when
bit 6 of SRA is set to 1 for a PCI configuration. RASl is
used to select the upper 2 MBytes of a 4-MByte
memory configuration. It is not available for LPB VL-
Bus configurations, limiting memory to 2 MBytes.
CAS[7:4] 0 52,51,49,48 Column Address Strobe Lines 7:4]. These signals are
not driven when the Tri064-compatible feature
connector is enabled by setting bit 0 of SRD to 1 and
bit 1 of SRD to O. This prevents contention on the
multiplexed PD lines.
CAS[3:0] 0 82, 83, 85, 86 Column Address Strobe Lines 3:0.
WE 0 125 Write Enable.
OE[1:0] 0 50, 124 Output Enable. OEl is output on pin 50 when bit 2 of
CR36 is cleared to 0 (EDO memory). If the feature
connector is disabled (bit 0 of SRD cleared to 0). this
output is the same as OEO (for 64-bit PD bus
operation). If the Tri064-compatible VAFC feature
connector is enabled (bit 0 of SRD set to 1 and bit 1 of
SRD cleared to 0). OEl is held high (not asserted). This
ensures that EDO memory data is not driven on the
multiplexed PD lines when the Tri064-compatible
feature connector is enabled. OE 1 is never generated
in fast page mode operation. Instead, if bit 6 of SRA is
cleared to 0 (default). a second OEO signal is output on
pin 50. This allows the same board to use either fast
page or EDO memory in 2-MByte designs with no
additional hardware. OEl is not available for LPB VL-
Bus configurations. Memory designs requiring use of
jJin 50 as a memory control signal cannot be used.
VIDEO INTERFACE
PDOWN I 165 Power Down. Asserting this signal tums off the RGB
analog output from the DACs.
VREF 162 Voltage Reference. This pin is tied to Vss through a 0.1
~F capacitor.
RSET 166 Reference Resistor. This pin is tied to Vss through an
external resistor to control the full-scale current value.
AR 0 168 AnalogHed. Analog red output to the monitor.
AG 0 171 Analog Green. Analog green output to the monitor.
AB 0 172 Analog Blue. Analog blue signal to the monitor.
PINS 3-7

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 3-1. Pin Descriptions -LPB Mode (Continued)
Symbol Type Pin Number(s) Description
ENFEAT 0 151 Enable Feature Connector. Setting SRD_O to 1 drives
this signal low when SRl C_l-0 are OOb. This also
enables all feature connector operations.
BLANK B 191,206 Video Blank. The BLANK function is on pin 191 when
LPB feature connector operation is enabled in PCI
VFCBLANK B 115 configurations. It is on pin 206 for LPB VL-Bus
configurations. It is on pin 115 when Tri064-compatible
VAFC operation is enabled and is called VFCBLANK.
When ESYNC is high, BLANK is a feature connector
output. When ESYNC is low, BLANK is a feature
connector input that, when driven low, turns off the
video output.
ESYNC I 183,205 External SYNC. The ESYNC function is on pin 183
when LPB feature connector operation is enabled in
VFCESYNC I 109 PCI configurations. It is on pin 205 for LPB VL-Bus
configurations. It is on pin 109 when Tri064-compatible
VAFC operation is enabled and is called VFCESYNC.
When ESYNC is driven low, HSYNC, VSYNC and
BLANK become inputs. When ESYNC is high, HSYNC,
VSYNC and BLANK become outputs.
EVIDEO I 203 External Video. The EVIDEO function is on pin 203
when LPB feature connector operation is enabled. It is
VFCEVIDEO I 111 on pin 111 when Tri064-compatible VAFC operation is
enabled and is called VFCEVIDEO. When this input is
asserted low, PA[15:0] (or VFCPA[15:0]) are inputs and
are sampled by VCLKI. When this input is high,
PA[15:0] (or VFCPA[15:0]) are outputs to the feature
connector.
EVCLK I 204 External VCLK. The EVCLK function is on pin 204
when LPB feature connector operation is enabled. It is
VFCEVCLK 113 on pin 113 when Tri064-compatible VAFC operation is
enabled and is called VFCEVCLK. When this input is
asserted low, VCLK is an input to the internal
RAMDAC. When this input is high, VCLK is output to
the feature connector.
VCLK B 148 Video/Pixel Clock. The VCLK function is enabled on pin
148 when feature connector operation is enabled.
When EVCLK (or VFCEVCLK) is high, this signal is an
output to the feature connector. When EVCLK is low,
this becomes an input used only for testJ)urposes.
VCLKI I 106 VCLK Input. The VCLKI function is enabled when LPB
VAFC (16-bit) feature connector operation is enabled.
Setting bit 1 of SRB to 1 causes VCLKI to be used to
clock in feature connector pixel data to the internal
RAMDAC.
3-8 PINS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 3-1. Pin Descriptions -LPB Mode (Continued)
Symbol Type Pin Number(s) Description
HSYNC B 149 Horizontal Sync. When ESYNC (or VFCESYNC) is high,
this is the horizontal sync output. When ESYNC is low,
this is an input from the feature connector.
VSYNC B 150 Vertical Sync. When ESYNC (or VFCESYNC) is high,
this is the vertical sync output. When ESYNC is low,
this is an input from the feature connector.
PA[15:0] B 201-199,189- Pixel Address Lines [15:0]. The PA[15:0] function is
185, 202, 184, enabled on the pins indicated for PCI configurations
175, 174, 155, when LPB feature connector operation is enabled.
154,147,146 Only PA[7:0] are enabled for VL-Bus configurations.
The PA function is on the pins indicated for
VFCPA[15:0] B 144,142,140, VFCPA[15:0] when Tri064-compatible VAFC operation
138,134,132, is enabled. When EVIDEO (or VFCEVIDEO) is high, PA
130,128,127, signals are outputs to the feature connector. When
129, 131, 133, EVIDEO is low, PA signals are inputs and are sampled
136, 139, 141, by VCLKI if bit 1 of SRB is set to 1.
143
MISCELLANEOUS FUNCTIONS
General Data, I/O and Serial Ports
GA[15:0] 0 105, 103, 101, (PCI) General Address Bus. These signals provide the
98, 95, 93, 91, address for BIOS ROM reads. They are multiplexed
89, 88, 90, 92, with PD signals. Programmers must ensure that the
94,97,100, memory bus is inactive when reading the ROM.
102, 104
GD[7:0] I 53, 55, 57, 59, (PCI) General Data Bus. These signals carry data for
63, 65, 67, 69 BIOS ROM reads. They are multiplexed with PD
signals. Programmers must ensure that the memory
bus is inactive when reading the ROM.
ROMEN 0 153 (PCI) ROM Enable. This signal provides the chip output
enable input for BIOS ROM reads.
ROMCS 0 153 (VL) ROM Chip Select. This signal provides the chip
output enable for BIOS ROM reads. It is output when
bits 1-0 of SRl C are any value except 11 b.
GPIOSTR 0 151 (VU General Input/Output Port Write Strobe. If
SRl C_l-0 are 01 b, this is asserted whenever a
General Input Port access (CR55_2 is set to 1 and the
3C8H port is read) or a General Output Port access
(write to CR5C) is made.
GOP[l :0] 0 190,151 (PCI) General Output Port Bits 1-0. If SR1Cl is setto
1, the value of CR5CO is output on pin 151 (GOPO)
and the value of CR5C_l is output on pin 190 (GOP1).
GOP[l :0] 0 153,151 (VU General Output Port Bits 1-0. If bit 1 of SRl Cis
set to 1, the value of CR5C_0 is output on pin 1 51
(GOPO). If SRl C_l-0 are 11 b, the value of CR5C_l is
output on pin 153 (GOP1)
PINS 3-9

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Table 3-1. Pin Descriptions -LPB Mode (Continued)
Symbol Type Pin Number(s) Description
STWR 0 190 (PCI) Strobe Write. If SR1 C_1 is cleared to 0, this
signal is asserted whenever a write is made to CR5C.
It is used to enable a General Output Port latch.
SPCLK I/O 205 Serial Port Clock. This is the clock for serial data
transfer, either for 12C or DDC2 monitor data
communications. As an output, it is programmed via
MMFF20_0. As an input, its status is read via
MMFF20_2. In either case the serial port must be
enabled by setting MMFF20_4 to 1. PD[26:25] can be
strapped to allow I/O (E2H or E8H) access to the Serial
Port reqister while the Trio64V+ is disabled.
SPD I/O 206 Serial Port Data. This is the data signal for serial data
transfer, either for 12C or DDC2 monitor data
communications. As an output, it is programmed via
MMFF20_1. As an input, its status is read via
MMFF20_3. In either case the serial port must be
enabled by setting MMFF203 to 1. PD[26:25] can be
strapped to allow I/O (E2H or E8H) access to the Serial
Port register while the Trio64V+ is disabled.
LOCAL PERIPHERAL BUS
Scenic/MX2 Mode
LD[7:0] I/O 202, 184, 175, LPB Data. This is the Scenic Highway data bus and
174,155,154, carries compressed data to the Scenic/MX2 and video
147.146 data from the Scenic/MX2.
LCLK I 148 LPB Clock. This clock controls transactions between
the Trio64V+ and Scenic Hiqhwav peripherals
VREO/VRDY 0 203 Video Request/Ready. This signal is part of the the
Scenic Highway data transfer protocol between the
Trio64V+ and the Scenic/MX2.
CREQJCRDY I 204 Scenic/MX2 Request/Ready. This signal is part of the
the Scenic Highway data transfer protocol between
the Trio64V+ and the Scenic/MX2.
ENFEAT 0 151 Enable Feature Connector. This signal is connected to
the Scenic/MX2 chip enable input such that the
Scenic/MX2 is disabled when feature connector
operation is enabled.
3-10 PINS

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Table 3-1. Pin Descriptions -LPB Mode (Continued)
Symbol Type Pin Number(s) Description
Video 8 in and Video 16 (PCI only) Modes
LD[7:0J I 202, 184, 175, LPB Data Bus [7:0]. This is the Scenic Highway data
174, 1 55, 154, bus and carries video data input.
147. 146
LD[15:8J I 201-199,189- (PCI) LPB Data Bus [15:8J. Scenic Highway video data
185 input for the upper data byte in Video 16 mode.
HS I 203 HSYNC. HSYNC input signaling the transition from one
line to the next.
VS I 204 VSYNC. VSYNC input signaling the transition from one
frame to the next.
HD[7:0J 0 201-199,189- Host Data. CL-480 compressed data.
185
HSEL[2:0J 0 178-176 Host Select. These signals select one of five CL-480
host interface registers.
Video 8 InlOut Mode (CL-480) (PCI only)
LD[7:0J I 202, 184, 175, LPB Data Bus [7:0]. This is the Scenic Highway data
174, 1 55, 154, bus and carries video data input.
147.146
OS 179 Data Strobe. The Trio64V+ asserts this signal to select
the CL-480 for a read or write operation.
RNJ 0 180 ReadNJrite. The Trio64V+ drives this signal high to
specify a CL-480 read cycle and low to specify a write
cvcle.
DTACK I 181 Data Acknowledge. The CL-480 asserts this signal
when it latches compressed data from the Trio64V+ or
when it has placed video data on LD[7:0J. This is an
open drain signal.
CFLEVEL I 182 Compressed Data FIFO Level. When this signal is low,
the CL-480 FIFO has room for at least 44 bytes of
compressed data. This is an open drain siqnal.
POWER AND GROUND
VDD I 12,37,62,81, Digital power supply
96,137,192
AVDD I 164,169,170 Analoq power supplv (RAMDAC)
CLKAVDD[l :2J I 158, 160 Analog power supply (clock synthesizer)
VSS I 9, 22, 32, 47, Digital ground
60,71,87,99,
114, 123, 126,
135,145, 195
AVSS I 159, 161, 163, Analog ground
167,173
PINS 3-"

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
3.3  PIN LISTS
Table 3-2 lists all Trio64V+ pins alphabetically. The pin number(s) corresponding to each pin name are
given in the appropriate bus interface type column. Table 3-3 lists all pins in numerical order. The
corresponding pin name/pin number is given in the appropriate bus interface column.
Table 3-2.  Alphabetical Pin Listing
PIN(S)
| Name       | PCI                                   | VL   |
| ---------- | ------------------------------------- | ---- |
| AB         | 172                                   | 172  |
| AD[31 :OJ  | 207-208,1-6,10-11,13-18,28-31,33-36,  |      |
39-46
| AG         | 171                  | 171                    |
| ---------- | -------------------- | ---------------------- |
| AR         | 168                  | 168                    |
| AVDD       | 164,169,170          | 164,169,170            |
| AVSS       | 159,161,163,167,173  | 15~ 161, 16a 167, 173  |
| BLANK      | 191                  | 206                    |
| CAS[3:0J   | 82,83,85,86          | 82,83,85,86            |
| CAS[7:4J   | 52,51,49,48          | 52,51,49,48            |
| C/BE[3:0J  | 7,19,27,38           |                        |
158,160
| CLKAVDD[l :2J  | 158,160                      |      |
| -------------- | ---------------------------- | ---- |
| CREO/CRDY      | 204                          | 204  |
| DEVSEL         | 24                           |      |
| ENFEAT         | 151                          | 151  |
| ESYNC          | 183                          | 205  |
| EVCLK          | 204                          | 204  |
| EVIDEO         | 203                          | 203  |
| FRAME          | 20                           |      |
| GA[15:0J       | 105,103,101,98,90,92,94,97,  |      |
100,102,104
GD[7:0J
53,55,57,59,63,65,67,69
| GOP[l :OJ  | 190,151           | 153,151  |
| ---------- | ----------------- | -------- |
| GPIOSTR    |                   | 151      |
| HD[7:0J    | 201-199, 189-185  |          |
| HS         | 203               | 203      |
| HSYNC      | 149               | 149      |
| IDSEL      | 8                 |          |
| INTA       | 152               |          |
| IRDY       | 21                |          |
| LCLK       | 148               | 148      |
LD[7:0J  202,184,175,174,155,154,147,146  202,184,175,174,155,154,147,146
| LD[15:8J  | 201-199, 189-185  |     |
| --------- | ----------------- | --- |
| LOCA      |                   | 24  |
MA[8:0J  80,78,76,74,72,73,75,77.79  80, 78, 76, 74, 72, 73, 75, 77, 79
3-12  PINS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 3-2. Alphabetical Pin Listing (Continued)
PIN(S)
| Name  | PCI  | VL   |
| ----- | ---- | ---- |
| OEO   | 124  | 124  |
| OE1   | 50   |      |
PA[7:0]  202,184,175,174,155,154,147,146  202, 184, 175, 174, 155, 154, 147, 146
| PA[15:8]  | 201-199,189-185,134,132,130,128,  |     |
| --------- | --------------------------------- | --- |
| PAR       | 26                                |     |
PD[63:0]
122, 120, 118, 116, 113, 111, 109, 107,  122,120,118,116,113,111,109,107,
106,108,110,112,115,117,119,121,  106,108,110,112,115,117,119,121,
144,142,140,138,134,132,130,128,  144,142, 140, 13~ 134, 132, 13~ 12a
127,129,131,133,136,139,141,143,  127,129,131,133,136,139,141,143,
70,68,66,64,61,58,56,54,53,55,  70,68,66,64,61,58,56,54,53,55,
57,59,63,65,67,69,105,103,101,  57, 59, 63, 65, 67, 69, 105, 103, 101,
98,95,93,91,89,88,90,92,94,97  98,95,93,91,89,88,90,92,94,97
|         | 100,102,104  | 100,102,104  |
| ------- | ------------ | ------------ |
| PDOWN   | 165          | 165          |
| RASO    | 50           | 50           |
| RAS1    | 84           |              |
| RESET   | 193          |              |
| RDYIN   |              | 21           |
| ROM EN  | 153          |              |
| ROMCS   |              | 153          |
| RSET    | 166          | 166          |
SA[22:2]
201-196,191-185,183-176
SA[31 :23]
| SADS       |      | 20                                         |
| ---------- | ---- | ------------------------------------------ |
| SAUP1      |      | 25                                         |
| SAUP2      |      | 50                                         |
| SBE[3:0]   |      | 7,19,27,38                                 |
| SCLK       | 194  | 194                                        |
| SD[31 :0]  |      | 207-208, 1-6, 10-11, 13-18, 28-31, 33-36,  |
39-46
| SINTR   |      | 152  |
| ------- | ---- | ---- |
| SM/IO   |      | 8    |
| SPCLK   | 205  | 205  |
| SPD     | 206  | 206  |
| SRDY    |      | 23   |
| SRESET  |      | 193  |
| STOP    | 25   |      |
STRD
STWR
PINS  3-13

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 3-2. Alphabetical Pin Listing (Continued)
PIN(S)
| Name       | PCI  | VL   |
| ---------- | ---- | ---- |
| STWR       | 190  |      |
| SW/R       |      | 26   |
| TRDY       | 23   |      |
| VFCBLANK   | 115  | 115  |
| VFCESYNC   | 109  | 109  |
| VFCEVCLK   | 113  | 113  |
| VFCEVIDEO  | 111  | 111  |
VFCPA[15:0]  144, 142, 140, 138, 134, 132, 130, 128,  144, 142, 140, 138, 134, 132, 130, 128,
127,129,131,133,136,139,141,143  127,129,131,133,136,139,141,143
| VFCVCLK  | 117  | 117  |
| -------- | ---- | ---- |
VFCVCLKI
|           | 106                  | 106              |
| --------- | -------------------- | ---------------- |
| VCLK      | 148                  | 148              |
| VCLKI     | 106                  | 106              |
| VDD       | 12, 37, 62, 81, 96,  | 12,37,62,81,96,  |
|           | 137,192              | 137,192          |
| VREQNRDY  | 203                  | 203              |
| VREF      | 162                  | 162              |
| VS        | 204                  | 204              |
VSS  9,22,32,47,60,71,87,99,114,123,  9,22,32,47,60,71,87,99,114,123,
|        | 126, 135, 145  | 126,135,145  |
| ------ | -------------- | ------------ |
|        | 195            | 195          |
| VSYNC  | 150            | 150          |
| WE     | 125            | 125          |
| XIN    | 156            | 156          |
| XOUT   | 157            | 157          |
3-14  PINS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Table 3-3.  Numerical Pin Listing  |     |     |
| ---------------------------------- | --- | --- |
PINS
| Number  | PCI     | VL     |
| ------- | ------- | ------ |
| 1       | A029    | S029   |
| 2       | A028    | S028   |
| 3       | A027    | S027   |
| 4       | A026    | S026   |
| 5       | A025    | S025   |
| 6       | A024    | S024   |
| 7       | C/BE3   | SBE3   |
| 8       | 10SEL   | SM/IO  |
| 9       | VSS     | VSS    |
| 10      | A023    | S023   |
| 11      | A022    | S022   |
| 12      | VDD     | VDD    |
| 13      | A021    | S021   |
| 14      | A020    | S020   |
| 15      | A019    | S019   |
| 16      | A018    | S018   |
| 17      | A017    | S017   |
| 18      | A016    | S016   |
| 19      | C/BE2   | SBE2   |
| 20      | FRAME   | SAOS   |
| 21      | IROY    | ROYIN  |
| 22      | VSS     | VSS    |
| 23      | TROY    | SROY   |
| 24      | OEVSEL  | LOCA   |
| 25      | STOP    | SAUPl  |
| 26      | PAR     | SW/R   |
| 27      | C/BEl   | SBEl   |
| 28      | A015    | S015   |
| 29      | A014    | S014   |
| -30     | A013    | S013   |
| 31      | A012    | S012   |
| 32      | VSS     | VSS    |
| 33      | AOll    | S011   |
| 34      | A010    | SOlO   |
| 35      | A09     | S09    |
| 36      | A08     | S08    |
| 37      | VDD     | VDD    |
| 38      | C/BEO   | SBEO   |
| 39      | A07     | S07    |
| 40      | A06     | S06    |
| 41      | A05     | S05    |
| 42      | A04     | S04    |
PINS  3-15

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 3-3. Numerical Pin Listing (Continued)
PINS
| Number  | PCI       | Vl     |
| ------- | --------- | ------ |
| 43      | AD3       | SD3    |
| 44      | AD2       | SD2    |
| 45      | ADl       | SDl    |
| 46      | ADO       | SDO    |
| 47      | VSS       | VSS    |
| 48      | CAS4      | CAS4   |
| 49      | CAS5      | CAS5   |
| 50      | RAS1/0El  | SAUP2  |
| 51      | CAS6      | CAS6   |
| 52      | CAS7      | CAS7   |
| 53      | PD23/GD7  | PD23   |
| 54      | PD24      | PD24   |
| 55      | PD22/GD6  | PD22   |
| 56      | PD25      | PD25   |
| 57      | PD21/GD5  | PD21   |
| 58      | PD26      | PD26   |
| 59      | PD20/GD4  | PD20   |
| 60      | VSS       | VSS    |
| 61      | PD27      | PD27   |
| 62      | VDD       | VDD    |
| 63      | PD19/GD3  | PD19   |
| 64      | PD28      | PD28   |
| 65      | PD18/GD2  | PD18   |
| 66      | PD29      | PD29   |
| 67      | PD17/GDl  | PD17   |
| 68      | PD30      | PD30   |
| 69      | PD16/GDO  | PD16   |
| 70      | PD31      | PD31   |
| 71      | VSS       | VSS    |
| 72      | MA4       | MA4    |
| 73      | MA3       | MA3    |
74
|     | MA5   | MA5   |
| --- | ----- | ----- |
| 75  | MA2   | MA2   |
| 76  | MA6   | MA6   |
| 77  | MAl   | MAl   |
| 78  | MA7   | MA7   |
| 79  | MAO   | MAO   |
| 80  | MA8   | MA8   |
| 81  | VDD   | VDD   |
| 82  | CAS3  | CAS3  |
| 83  | CAS2  | CAS2  |
| 84  | RASO  | RASO  |
3-16  PINS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 3-3. Numerical Pin Listing (Continued)
PINS
| Number  | PCI      | VL    |
| ------- | -------- | ----- |
| 85      | CASl     | CASl  |
| 86      | CASO     | CASO  |
| 87      | VSS      | VSS   |
| 88      | PD7/GA7  | PD7   |
| 89      | PD8/GA8  | PD8   |
| 90      | PD6/GA6  | PD6   |
91
|      | PD9/GA9       | PD9           |
| ---- | ------------- | ------------- |
| 92   | PD5/GA5       | PD5           |
| 93   | PDlO/GAl0     | PD10          |
| 94   | PD4/GA4       | PD4           |
| 95   | PDll/GA1 1    | PDll          |
| 96   | VDD           | VDD           |
| 97   | PD3/GA3       | PD3           |
| 98   | PD12/GA12     | PD12          |
| 99   | VSS           | VSS           |
| 100  | PD2/GA2       | PD2           |
| 101  | PD13/GA13     | PD13          |
| 102  | PD1/GAl       | PDl           |
| 103  | PD14/GA15     | PD14          |
| 104  | PDO/GAO       | PDO           |
| 105  | PD15/GA15     | PD15          |
| 106  | PD55NFCVCLKI  | PD55NFCVCLKI  |
107
|      | PD56           | PD56           |
| ---- | -------------- | -------------- |
| 108  | PD54           | PD54           |
| 109  | PD57NFCESYNC   | PD57NFCESYNC   |
| 110  | PD53           | PD53           |
| 111  | PD58NFCEVIDEO  | PD58NFCEVIDEO  |
| 112  | PD52           |                |
PD52
| 113  | PD59NFCEVCLK  | PD59NFCEVCLK  |
| ---- | ------------- | ------------- |
| 114  | VSS           | VSS           |
| 115  | PD51NFCBLANK  | PD51NFCBLANK  |
| 116  | PD60          | PD60          |
| 117  | PD50NFCVCLK   | PD50NFCVCLK   |
| 118  | PD61          | PD61          |
| 119  | PD49          | PD49          |
| 120  | PD62          | PD62          |
| 121  | PD48          | PD48          |
| 122  | PD63          | PD63          |
123
|      | VSS  | VSS  |
| ---- | ---- | ---- |
| 124  | OEO  | OEO  |
| 125  | WE   | WE   |
| 126  | VSS  | VSS  |
PINS  3-17

II·
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Table 3-3. Numerical Pin Listing (Continued)
PINS
| Number  | PCI           | VL            |
| ------- | ------------- | ------------- |
| 127     | PD39NFCPA7    | PD39NFCPA7    |
| 128     | PD40NFCPA8    | PD40NFCPA8    |
| 129     | PD38NFCPA6    | PD38NFCPA6    |
| 130     | PD41NFCPA9    | PD41NFCPA9    |
| 131     | PD37NFCPA5    | PD37NFCPA5    |
| 132     | PD42NFCPA 10  | PD42NFCPA 10  |
| 133     | PD36NFCPA4    | PD36NFCPA4    |
| 134     | PD43NFCPA 11  | PD43NFCPA 11  |
| 135     | VSS           | VSS           |
| 136     | PD35NFCPA3    | PD35NFCPA3    |
| 137     | VDD           | VDD           |
| 138     | PD44NFCPA 12  |               |
PD44NFCPA 12
| 139  | PD34NFCPA2    | PD34NFCPA2           |
| ---- | ------------- | -------------------- |
| 140  | PD45NFCPA 13  | PD45NFCPA 13         |
| 141  | PD33NFCPA1    | PD33NFCPA1           |
| 142  | PD46NFCPA 14  | PD46NFCPA 14         |
| 143  | PD32NFCPAO    | PD32NFCPAO           |
| 144  | PD47NFCPA15   | PD47NFCPA15          |
| 145  | VSS           | VSS                  |
| 146  | LDO/PAO       | LDO/PAO              |
| 147  | LD1/PA1       | LD1/PA1              |
| 148  | LCLKNCLK      | LCLKNCLK             |
| 149  | HSYNC         | HSYNC                |
| 150  | VSYNC         | VSYNC                |
| 151  | ENFEAT/GOPO   | ENFEAT/GPIOSTR/GOPO  |
| 152  | !NTA          | SINTR                |
| 153  | ROM EN        | ROMCS/GOP1           |
154
|      | LD2/PA2   | LD2/PA2   |
| ---- | --------- | --------- |
| 155  | LD3/PA3   | LD3/PA3   |
| 156  | XIN       | XIN       |
| 157  | XOUT      | XOUT      |
| 158  | CLKAVDD1  | CLKAVDD1  |
159
|      | AVSS      | AVSS      |
| ---- | --------- | --------- |
| 160  | CLKAVDD2  | CLKAVDD2  |
| 161  | AVSS      | AVSS      |
| 162  | VREF      | VREF      |
| 163  | AVSS      | AVSS      |
164
|      | AVDD   | AVDD   |
| ---- | ------ | ------ |
| 165  | PDOWN  | PDOWN  |
| 166  | RSET   | RSET   |
| 167  | AVSS   | AVSS   |
| 168  | AR     | AR     |
3-18  PINS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 3-3. Numerical Pin Listing (Continued)
PINS
| Number  | PCI          | VL       |
| ------- | ------------ | -------- |
| 169     | AVDD         | AVDD     |
| 170     | AVDD         | AVDD     |
| 171     | AG           | AG       |
| 172     | AB           | AB       |
| 173     | AVSS         | AVSS     |
| 174     | LD4/PA4      | LD4/PA4  |
| 175     | LD5/PA5      | LD5/PA5  |
| 176     | N/C          | SA2      |
| 177     | N/C          | SA3      |
| 178     | N/C          | SA4      |
| 179     | N/C          | SA5      |
| 180     | N/C          | SA6      |
| 181     | N/C          | SA7      |
| 182     | N/C          | SA8      |
| 183     | ESYNC        | SA9      |
| 184     | LD6/PA6      | LD6/PD6  |
| 185     | LD8/PA8/HDO  | SA10     |
| 186     | LD9/PA9/HDl  | SAll     |
187
|      | LDl O/PA 10 /HD2  | SA12  |
| ---- | ----------------- | ----- |
| 188  | LDll/PA 11/HD3    | SA13  |
| 189  | LD12/PA 12/HD4    | SA14  |
| 190  | STWR/GOPl         | SA15  |
| 191  | BLANK             | SA16  |
192
|      | VDD             | VDD      |
| ---- | --------------- | -------- |
| 193  | RESET           | SRESET   |
| 194  | SCLK            | SCLK     |
| 195  | VSS             | VSS      |
| 196  | VCLKI           | SA17     |
| 197  | RESERVED (GNT)  | SA18     |
| 198  | RESERVED (REO)  | SA19     |
| 199  | LD13/PA 13/HD5  | SA20     |
| 200  | LD14/PA 14/HD6  | SA21     |
| 201  | LD15/PA 15/HD7  | SA22     |
| 202  | LD7/PA7         | LD7/PA7  |
203
|      | VREQ/VRDY/HS/EVIDEO  | VREQ/VRDY/HS/EVIDEO  |
| ---- | -------------------- | -------------------- |
| 204  | CREQfCRDYNS/EVCLK    | CREQfCRDYNS/EVCLK    |
| 205  | SPCLK                | SPCLK/ESYNC          |
| 206  | SPD                  | SPD/BLANK            |
| 207  | AD31                 | SD31                 |
208
|     | AD30  | SD30  |
| --- | ----- | ----- |
PINS  3-19

••
r
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Section 4: Electrical Data
4.1  MAXIMUM RATINGS
Table 4-1.  Absolute Maximum Ratings
| Ambient temperature  | 0° C to 70° C  |     |     |     |     |
| -------------------- | -------------- | --- | --- | --- | --- |
Storage temperature
-40° C to 125° C
| DC Supply Voltage                    | -0.5V to 7.0V      |     |     |     |     |
| ------------------------------------ | ------------------ | --- | --- | --- | --- |
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
|                               |     | Min  | Typical  | Max                  | Unit       |
| ----------------------------- | --- | ---- | -------- | -------------------- | ---------- |
| Resolution Each DAC           |     |      | 8        |                      | bits       |
| LSB Size                      |     |      | 66       |                      | J,.tA      |
| Integral Linearity Error      |     |      |          | ± 1                  | LSB        |
| Differential Linearity Error  |     |      |          | + 1                  | LSB        |
| Output Full-Scale Current     |     |      | 17       |                      | mA         |
| DAC to DAC Mismatch           |     |      |          | 5%                   |            |
| Power Supply Rejection Ratio  |     |      |          | 0.5                  | %/ % AVDD  |
| Output Compliance             |     | 0.0  |          | 1.5                  | V          |
| Output Capacitance            |     |      |          | 30                   | pF         |
| Glitch Impulse                |     |      | 75       |                      | pV-Sec     |
| PRELIMINARY                   |     |      |          | ELECTRICAL DATA 4-1  |            |

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 4-4.  Digital DC Specifications (VDD = 5V ± 5%, Operating Temperature 0° C to 70° C)
| Symbol  | Parameter            | Min           | Max        | Unit  |
| ------- | -------------------- | ------------- | ---------- | ----- |
| VIL     | Input Low Voltaoe    | -0.5          | 0.8        | V     |
| VIH     | Input High Voltage   | 2.4 (Note 1)  | VDD +0.5   | V     |
| VOL     | Output Low Voltage   |               | Vss + 0.4  | V     |
|         | Output High Voltage  | 2.4           |            | V     |
VOH
| IOL1  | Output Low Current   | 8 (Note 2)   |     | mA  |
| ----- | -------------------- | ------------ | --- | --- |
| IOHl  | Output Hioh Current  | -4           |     | mA  |
|       | Output Low Current   | 16 (Note 3)  |     | mA  |
IOL2
| IOH2  | Output HiQh Current       | -8           |     | mA   |
| ----- | ------------------------- | ------------ | --- | ---- |
| IOL3  | Output Low Current        | 24 (Note 4)  |     | mA   |
| IOH3  | Output Hioh Current       | -12          |     | mA   |
| loz   | Output Tri-state Current  |              | 1   | IlA  |
| CIN   | Input Capacitance         |              | 5   | pF   |
|       | Output Capacitance        |              | 5   | pF   |
COUT
| Icc  | Power Supply Current  |     | 500 (Note 5)  | mA  |
| ---- | --------------------- | --- | ------------- | --- |
Notes for Table 4-4
1.  The value for pins 25 (STOP) and 26 (PAR) is 2.6V.
2.  IOL1, IOHl for pins ROMEN,INTA, STRD, STWR, HSYNC, VSYNC, VCLK,  BLANK, ENFEAT,
MA[8:0], CAS[7:0], PD[63:0], AD[31:0], LD[7:0], HSEL, DS, R/W, DTACK, VREQNRDY, SPCLK,
SPD
3.  IOL2, IOH2 for pins OE[1:0]' WE, RAS[1:0]
4.  IOL3, IOH3 for pins PAR, STOP, DEVSEL, TRDY
5.  Icc measured for a resolution of 1024x768x8 with a 75 MHz DCLK and a 60 MHz MCLK at 25°C
and 5V.
6.  The pin names used in these notes are the primary ones for PCI configurations. An output
signal multiplexed on one of these pins has the same drive level, as does a VL-Bus output for
the same pin.
| 4-2 ELECTRICAL DATA  |     |     |     | PRELIMINARY  |
| -------------------- | --- | --- | --- | ------------ |

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
4.3  AC SPECIFICATIONS
Note: All AC timings are based on an 80 pF test load.
4.3.1  RAMDAC AC Specifications
Table 4-5.  RAMDAC AC Specifications
| Parameter                  | Typical  | Max  | Unit  Notes  |
| -------------------------- | -------- | ---- | ------------ |
| DAC Output Delay           | 5        |      | ns  1        |
| DAC Output Rise/Fall Time  | 3        |      | ns  2        |
| DAC Output Settlinq Time   | 15       |      | ns           |
| DAC-to-DAC Output Skew     | 2        | 5    | ns  3        |
Notes for Table 4-5
1.  Measured from the 50% point of VCLK to the 50% point of full scale transition
2.  Measured from 10% to 90% full scale
3  With DAC outputs equally loaded
| PRELIMINARY  |     |     | ELECTRICAL DATA 4-3  |
| ------------ | --- | --- | -------------------- |

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
4.3.2  Clock Timing
Figure 4·1. Clock Waveform Timing
Table 4·6.  Clock Waveform Timing
| Symbol  | Parameter                        | Min     | Max  | Units  Notes  |
| ------- | -------------------------------- | ------- | ---- | ------------- |
| Tcyc    | SCLK Cycle Time (VL-Bus)         | 20      | 125  | ns  1         |
|         | SCLK Cycle Time (PCI)            | 30      | 125  | ns  1         |
|         | LCLK Cycle Time                  | 30      | 200  | ns            |
|         | MCLK Cycle Time                  | 16.667  | 100  | ns            |
|         | DCLK Cycle Time (VGA Mode)       | 25      | 100  | ns  1         |
|         | DCLK Cycle Time (Enhanced Mode)  | 12.5    | 100  | ns  1, 2      |
| THIGH   | SCLK High Time (VL-Bus)          | 8       | 80   | ns            |
|         | SCLK High Time (PCI)             | 12      | 80   | ns            |
|         | LCLK High Time                   | 12      | 160  | ns            |
| TLOW    | SCLK Low Time (VL-Bus)           | 8       | 80   | ns            |
|         | SCLK Low Time (PCI)              | 12      | 80   | ns            |
|         | LCLK Low Time                    | 12      | 160  | ns            |
|         | SCLK Slew Rate                   | 1       | 4    | V/ns  3       |
|         | LCLK Slew Rate                   | 1       | 4    | v/nS  3       |
Notes to Table 4·6
1.  fOCLK ~ 1/2 fSCLK to ensure valid writes to the PLLs.
2.  For DCLK rates above 80 MHz, clock doubling is used. The maximum DCLK rate with clock
doubling is 67.5 MHz .
. 3.  Rise and fall times are specified in terms ofthe edge rate measured in V/ns. This slew rate
must be met across the minimum peak-to peak portion of the clock waveform.
| 4-4 ELECTRICAL DATA  |     |     |     | PRELIMINARY  |
| -------------------- | --- | --- | --- | ------------ |

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
4.3.3  Input/Output Timing
\
CLOCK  1.5 V-~
+-Tsu-+-T H-
INPUT  -r1.5 V  --: -1.5 V
TCLKIN
Figure 4-2. Input Timing
Table 4-7.  SCLK-Referenced Input Timing
PCIBus
| Symbol  | Parameter                                       | Min  | Units  |
| ------- | ----------------------------------------------- | ---- | ------ |
| Tsu     | AO[31 :0]' C/BE[3:0]' FRAME. IROY, 10SEL setup  | 7    | ns     |
| TH      | AO[31 :0] hold                                  | 1    | ns     |
| TH      | C/BE[3:0]' FRAME, IROY, 10SEL hold              | 1    | ns     |
VL-Bus
| Symbol  | Parameter                                      | Min  | Units  |
| ------- | ---------------------------------------------- | ---- | ------ |
| Tsu     | AO[31:2], BE[3:0], SM/IO, SW/R, SAOS (address  | 12   | ns     |
phase) setup
AO[31:2], BE[3:0], SM/IO, SW/R, SAOS (address
| TH  |     | 1   | ns  |
| --- | --- | --- | --- |
phase) hold
| Tsu  | AO[31:2], BE[3:0], 01, 00, SAOS (data phase)  | 4   | ns  |
| ---- | --------------------------------------------- | --- | --- |
setup
| TH  | AO[31:2], BE[3:0], 01, 00, SADS (data phase)  | 1   | ns  |
| --- | --------------------------------------------- | --- | --- |
hold
| Tsu  | ROYIN setup  | 6   | ns  |
| ---- | ------------ | --- | --- |
| TH   | ROYIN hold   | 1   | ns  |
Miscellaneous
| Symbol  | Parameter                     | Min  | Units  |
| ------- | ----------------------------- | ---- | ------ |
|         | ROM data GD[7:0] setup (PCI)  | 5    | ns     |
Tsu
| TH           | ROM data GO[7:0] hold (PCI)       | 7                    | ns  |
| ------------ | --------------------------------- | -------------------- | --- |
| Tsu          | General Input Port GD[7:0] setup  | 5                    | ns  |
| TH           | General Input Port GD[7:0] hold   | 7                    | ns  |
| PRELIMINARY  |                                   | ELECTRICAL DATA 4-5  |     |

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 4-8.  LCLK-Referenced Input Timing
Scenic/MX2 Interface
| Symbol  | Parameter      | Min  | Units  |
| ------- | -------------- | ---- | ------ |
| Tsu     | LD[7:0] setup  | 10   | ns     |
| TH      | LD[7.:0] hold  | 9    | ns     |
| Tsu     | CREO/CRDY      | 6    | ns     |
|         |                | 8    | ns     |
| TH      | CREO/CRDY      |      |        |
CL-480/SAA7110 Interface
| Symbol  | Parameter                                           | Min  | Units  |
| ------- | --------------------------------------------------- | ---- | ------ |
|         | LD[7:0] setup (also LD[15:8] for 16-bit interface)  | 6    | ns     |
Tsu
TH  LD[7:0] hold (also LD[15:8] for 16-bit interface)  8  ns
| Tsu  | HS setup  | 6   | ns  |
| ---- | --------- | --- | --- |
ns
| TH   | HS hold   | 7   |     |
| ---- | --------- | --- | --- |
| Tsu  | VS setup  | 6   | ns  |
| TH   | VS hold   | 7   | ns  |
Table 4-9.  MCLK-Referenced Input Timing
| Symbol  | Parameter         | Min  | Units  |
| ------- | ----------------- | ---- | ------ |
| Tsu     | PD[63:0] setup    | 0    | ns     |
|         | 12.5/16 (Note 1)  |      | ns     |
| TH      | PD[63:0] hold     |      |        |
Note
1.  The hold time is 12.5 ns for 1-cycle operation and 16 ns for 2-cycle operation.
| 4-6 ELECTRICAL DATA  |     |     | PRELIMINARY  |
| -------------------- | --- | --- | ------------ |

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
CLOCK
1.5 V
-MAX-
-MIN-
|     | 1.5 V  | 1.5 V  |
| --- | ------ | ------ |
OUTPUT
TQKOUT
Figure 4-3. Output Timing
The minimum delay is the minimum time after the clock edge that the valid signal state from the previous
cycle will begin transition to the next state (become invalid).
The maximum delay is the maximum time after the clock edge that the signal state is valid for the next
cycle.
Table 4-10.  SCLK-Referenced Output Timing
PCIBus
| Parameter  | Min  Max  | Units  Notes  |
| ---------- | --------- | ------------- |
1
| AD[31 :OJ valid delay  | 2  16  | ns                 |
| ---------------------- | ------ | ------------------ |
| DEVSEL, PAR            | 2  11  | ns  Medium DEVSEL  |
| delay                  |        | timing used        |
| STOP delay             | 2  11  | ns                 |
| TRDY delay             | 2  11  | ns                 |
| INTAdeiay              | 2  11  | ns                 |
VL-Bus
| Parameter                      | Min  Max  | Units  Notes  |
| ------------------------------ | --------- | ------------- |
| AD[31 :21. D1, DO valid delay  | 7  16     | ns            |
| SINTR delay                    | 5  30     | ns            |
| SRDY delay                     | 5  11     | ns            |
| LOCA active delay              | 5  15     | ns            |
| LOCA inactive delay            | 5  20     | ns            |
Miscellaneous
| Parameter                           | Min  Max  | Units  Notes  |
| ----------------------------------- | --------- | ------------- |
| STRD delay                          | 3  15     | ns            |
| RaMEN (PCI) delay                   | 4  10     |               |
| ROM address valid delay (PCI)       | 5  30     | ns            |
| AD[7:0J ROM data valid delay (PCI)  | 5  30     | ns            |
Note
1.  Due to the timing for TRDY for read cycles. data is not sampled on the clock edge immediately
following its becoming valid. This guarantees the PCI 2.0 specification time of 11 ns.
| PRELIMINARY  |     | ELECTRICAL DATA 4-7  |
| ------------ | --- | -------------------- |

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 4-11.  LCLK-Referenced Output Timing
Scenic/MX2 Interface
| Parameter  |     | Min  | Max  | Units  Notes  |     |
| ---------- | --- | ---- | ---- | ------------- | --- |
7 ns typ
| VREO/VRDY active delay       |     | 2   | 11  | ns            |     |
| ---------------------------- | --- | --- | --- | ------------- | --- |
| LD[7:0[ valid delay          |     | 2   | 15  | ns  8 ns typ  |     |
| LD[7:0] tri-state from LCLK  |     | 7   | 15  | ns            |     |
Table 4-12.  MCLK-Referenced Output Timing
| Parameter                 |     | Min  | Max   | Units  Notes  |     |
| ------------------------- | --- | ---- | ----- | ------------- | --- |
| PD[63:0J valid delay      |     | 2    | 7/11  | ns  1         |     |
| MA[8:0J valid delay       |     | 1.5  | 8     | ns            |     |
| CAS[7:0J active delay     |     | 1    | 5.5   | ns            |     |
| CAS[7:0J inactive delay   |     | 1    | 5.5   | ns            |     |
| RAS[l :OJ active delay    |     | 1    | 5     | ns            |     |
| RAS[l :OJ inactive delay  |     | 1    | 6.5   | ns            |     |
| OE[l :OJ active delay     |     | 1.5  | 4.5   | ns            |     |
ns
| WE active delay  |     | 1.5  | 4.5  |     |     |
| ---------------- | --- | ---- | ---- | --- | --- |
Note
1.  The maximum delay time is 7 ns for l-cycle operation and 11 ns for 2-cycle operation.
Table 4-13.  CL-480 Timings -Trio64V+ Driving Host Interface
CL-480 Interface
| Symbol  | Parameter  |     |     | Min  | Units  |
| ------- | ---------- | --- | --- | ---- | ------ |
HD[7:0J (write), HSEl[2:0], R/W valid to DS low  LCLK Tcyc  ns
TH  HD[7:0J (write). HSEL[2:0], R/W hold from DS low  LCLK Tcyc  ns
| Tsu  | HD[7:0] (read) setup to DTACK hiqh   |     |     | 5   | ns  |
| ---- | ------------------------------------ | --- | --- | --- | --- |
| TH   | HD[7:0J (read) hold from DTACK high  |     |     | 0   | ns  |
Table 4-14.  Feature Connector Timing -Output from Trio64V+ to Feature Connector
| Symbol               | Parameter                              |     | Min  | Units  | Notes        |
| -------------------- | -------------------------------------- | --- | ---- | ------ | ------------ |
| Tsu                  | PA[15:0], BLANK setup to VCLK risinq   |     | 5    | ns     |              |
| TH                   | PA[15:0], BLANK hold from VCLK rising  |     | 5    | ns     |              |
| 4-8 ELECTRICAL DATA  |                                        |     |      |        | PRELIMINARY  |

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 4-15.  Feature Connector Timing -Output from Feature Connector to Trio64V+
| Symbol  Parameter                      | Min  Max  | Units  Notes  |
| -------------------------------------- | --------- | ------------- |
| Tsu  PA[15:01. BLANK setup to VCLK or  | 6         | ns  1         |
VCLKI rising
| TH  PA[15:0]' BLANK hold from VCLK or  | 6   | ns  1  |
| -------------------------------------- | --- | ------ |
VCLKI rising
| VCLK                    | 25  40  | ns  1     |
| ----------------------- | ------- | --------- |
| VCLKI                   | 27  40  | ns  1, 2  |
| VCLK, VCLKI duty cycle  | 40  60  | %         |
| VCLK, VCLKI high time   | 10  25  | ns        |
| VCLK, VCLKI low time    | 10  25  | ns        |
| VCLK, VCLKI slew rate   | 1  4    | V/ns      |
Notes for Table 4-15
1.  Pixel data is clocked into the internal RAMDAC using VCLK for a pass-through feature
connector and VCLKI for a VAFC configuration.
2.  This corresponds to the VESA VAFC specification of a maximum clock of 37.5 MHz.
| PRELIMINARY  |     | ELECTRICAL DATA 4-9  |
| ------------ | --- | -------------------- |

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
SRESET,RESET
SYSTEM
CONFIGURATION
DATA
Figure 4-4. Reset Timing
Table 4-16.  Reset Timing
| Symbol  | Parameter  | Min  | Units  |
| ------- | ---------- | ---- | ------ |
TLQW  SRESET (VL) or RESET (PCI) active pulse width  400  ns
| Tsu  | PD[28:0] setup to SRESET (Vl) or RESET (PCI)  | 20  | ns  |
| ---- | --------------------------------------------- | --- | --- |
inactive
| TH  | PD[28:0] hold from SRESET (Vl) or RESET (PCI)  | 10  | ns  |
| --- | ---------------------------------------------- | --- | --- |
inactive
| 4-10 ELECTRICAL DATA  |     |     | PRELIMINARY  |
| --------------------- | --- | --- | ------------ |

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 5: Reset and Initialization
The reset signal (RESET for PCI, SRESET for VL
Bus) resets the internal state machines in the
Tri064V+ and places all registers in their power
on default states. It also initiates several configu
ration actions, as described in this section.
The PD[28:0] pins are pulled high internally and
can be individually pulled low through 10 KO
resistors. These pull-ups and pull-downs do not
affect normal operation of the pins as part of the
pixel data bus, but they do force the pins to a
definite state during reset. At the rising edge of
the reset signal, this state is sampled and the data
loaded into the CR36, CR37, CR68 and CR6F reg
isters. The data is used for system configuration,
such as system bus and memory parameter se
lection. The definitions of the PD[28:0] strapping
bits at the rising edge of the reset signal are
shown in Table 5-1.
Strapping bits 7-5 define the display memory
size. However, the S3 BIOS determines this value
directly and writes it to CR36_7-5 after reset.
Therefore, systems using the S3 BIOS do not
need to strap the PD[7:5] pins. Other pins may
also not require strapping, depending on the
design and bus type.
OE[1:0] are driven high during reset. This pre
vents them from floating low and enabling incor
rect data on the configuration strapping pins.
RESET AND INITIALIZATION 5-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 5-1.  Definition of PD[28:0] at the Rising Edge of the Reset Signal
| CR Bits  | PO Bits  Value  | Function  |
| -------- | --------------- | --------- |
System Bus Select
| CR36  1-0  | 1-0  00  | Reserved       |
| ---------- | -------- | -------------- |
|            | 01       | VL-Bus         |
|            | 10       | PCI local bus  |
|            | 11       | Reserved       |
Memory Page Mode Select
| CR36 3-2  | 3-2  00  | 1-cycle extended data out (EDO) mode  |
| --------- | -------- | ------------------------------------- |
|           | 01       | Reserved                              |
|           | 10       | 2-cycle Extended data out (EDO) mode  |
|           | 11       | Fast page mode                        |
Enable Video BIOS IVL-Bus only)
| CR364  | 4  0  | Disable video BIOS accesses  |
| ------ | ----- | ---------------------------- |
|        | 1     | Enable video BIOS accesses   |
Display Memory Size
| CR36 7-5  | 7-5  000  | 4 MBytes  |
| --------- | --------- | --------- |
|           | 001       | Reserved  |
|           | 010       | Reserved  |
|           | 011       | Reserved  |
|           | 100       | 2 MBytes  |
|           | 101       | Reserved  |
|           | 110       | 1 MByte   |
|           | 111       | Reserved  |
Enable Tri064V+ IVL-Bus Only)
CR37 0  8  0  Disable Tri064V+ except for video BIOS accesses
|          | 1   | Enable Tri064V+  |
| -------- | --- | ---------------- |
| CR37  1  | 9   | Reserved         |
Video BIOS Size IVL-Bus Only)
| CR372  | 10  0  | 64 KByte video BIOS  |
| ------ | ------ | -------------------- |
|        | 1      | 32 KByte video BIOS  |
Clock Select
CR37_3  11  0  Use external DCLK on pin 156 and external MCLK on pin 151
(test purposes only)
|     | 1   | Use internal DCLK, MCLK  |
| --- | --- | ------------------------ |
RAMDAC Write Snooping
| CR374  | 12  0  | Disable LOCA/SRDY for RAMDAC writes  |
| ------ | ------ | ------------------------------------ |
|        | 1      | Enable LOCA/SRDY for RAMDAC writes   |
5-2  RESET AND INITIALIZATION

fl·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 5-1. Definition of PD[28:0) at the Rising Edge of the Reset Signal (Continued)
| CR Bits   | PD Bits  Value  | Function  |
| --------- | --------------- | --------- |
| CR37 7-5  | 15-13           | Reserved  |
CAS/OE Low Stretch
CR68  1-0  17-16  00  approximately 6.5 ns stretch (nominal)
|     | 01  | approximately 5 ns stretch (nominal)    |
| --- | --- | --------------------------------------- |
|     | 10  | approximately 3.5 ns stretch (nominal)  |
|     | 11  | No stretch                              |
RAS Low Timing Select
| CR682  | 18  0  | 4.5 MCLKs  |
| ------ | ------ | ---------- |
|        | 1      | 3.5 MCLKs  |
RAS Pre-Charge Timing Select
| CR683  | 19  0  | 3.5 MCLKs  |
| ------ | ------ | ---------- |
|        | 1      | 2.5 MCLKs  |
BIOS Area
| CR68 6-4  | 22-20  | Reserved for use by the video BIOS  |
| --------- | ------ | ----------------------------------- |
Memory Data Bus Size
| CR687  | 23  0  | Memory data bus is 32 bits                                  |
| ------ | ------ | ----------------------------------------------------------- |
|        | 1      | Memory data bus is 32 bits (1 MByte) or 64 bits (2 or more  |
MBytes)
Operating Mode Select
| CR6F 0  | 24  0  | LPB mode                |
| ------- | ------ | ----------------------- |
|         | 1      | Trio64-compatible mode  |
Serial Port I/O Address Select
CR6F  1  25  0  The Serial Port register is mapped to I/O port 000E8H
|     | 1   | The Serial Port register is mapped to I/O port 000E2H  |
| --- | --- | ------------------------------------------------------ |
Serial Port Address Type Select
CR6F_2  26  0  The Serial Port register is mapped to the I/O port defined by
PD25 or can be accessed at its MMIO address at offset FF20H.
1  The Serial Port register is accessed at its MMIO address only
(no I/O)
WE Delay
| CR6F 4-3  | 28-27  00  | 3 units delay  |
| --------- | ---------- | -------------- |
|           | 01         | 2 units delay  |
|           | 10         | 1 unit delay   |
|           | 11         | no delay       |
RESET AND INITIALIZATION  5-3

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 6: System Bus Interfaces
The Tri064V+ interfaces to either a PCI bus or a address of 7000 OOOOH. This allows the PCI sys
VESA local bus (VL-Bus). This section describes tem to reconfigure as required for plug and play.
the connections and functional characteristics of
these interfaces.
6.1.2 PCI Bus Cycles
6.1 PCI BUS INTERFACE
Figures 6-1 and 6-2 show the basic PCI read and
write cycles respectively. Bit 1 of the PCI Com
The Tri064V+ provides a complete PCI interface. mand register (Index 04H) must be set to 1 to
Power-on strapping bits 1-0 must be setto 10b to allow memory space access. Bit 0 of the PCI
enable this interface. The pinout and other speci Command register must be set to 1 to allow I/O
fications are in complete conformance with Revi space access.
sion 2 of the the PCI specification. No glue logic
is required. Figures 6-3 and 6-4 show two examples of PCI
bus disconnection. These examples show cases
where data is transferred after STOP is asserted.
6.1.1 PCI CONFIGURATION
In example A data is transferred after FRAME is
deasserted because the master was not ready
The Vendor ID register (Index OOH) in the PCI (IRDY deasserted on clock 2). In example B, data
Configuration space is hardwired to 5333H to is transferred before FRAME is deasserted. See
specify S3 Incorporated as the vendor. The revision 2.0 or later of the PCI Local Bus Specifi
Device ID register is hardwired to 8811. The BIOS cation for a complete explanation of disconnects.
must use CR2F (= 4xH) to differentiate this chip Bit 7 of the CR66 register must be set to 1 to
from other Trio® family products. enable PCI disconnects. If bit 3 of CR66 is set to
1, an attempt to write data with the Command
Bits 10-9 of the Status register (Index 06H) are FIFO full or to read data with the CO.mmand FIFO
hardwired to 01 b to specify medium DEVSEL not empty generates a PCI bus disconnect cycle.
timing. The Class Code register (Index 08H) is
hardwired to 30000H to specify that the Tri064V+
is a VGA compatible device. Bits 3-0 of the Base The PCI configuration register space occupies
Address 0 register (Index 10H) are hardwired to 256 bytes. When a, configuration read or write
OOH. This indicates that the "prefetchable" bit is command is issued, the AD[7:0) lines contain the
cleared to 0, the base register can be located address of the register in this space to be ac
anywhere in a 32-bit address space and the base cessed. Figures 6-5 and 6-6 show the configura
register is located in memory space. tion read and write cycles respectively. The
Tri064V+ supports or returns 0 for the first 64
When the Tri064V+ powers up in a PCI configu bytes of configuration space.
ration, it defaults to linear addressing and mem
ory mapped I/O enabled at a relocatable base
SYSTEM BUS INTERFACES 6-1

r=~  .
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
|     | T1  |     | T2  | T3  |     | T4  | T5  |     | T6  |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
I
|        | \   |     |     |     |     |     |     |     | ,~  |     |
| ------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FRAME  |     |     |     | I   |     |     |     |     |     |     |
I
| AD[31:0)  |     |          | }-~-{  |     |         | ~      | ~   |        | }-~  |     |
| --------- | --- | -------- | ------ | --- | ------- | ------ | --- | ------ | ---- | --- |
|           |     | AOO5ESS  |        |     | OA1A 1  | OAlA2  |     | OAlA3  |      |     |
|           |     | I        |        | I   | I       |        | I   | I      | ,    |     |
(
| C/BE[3:0)  |     | BUS~MO  | X   | :   | BE'S  |     |     |     | )-~  |     |
| ---------- | --- | ------- | --- | --- | ----- | --- | --- | --- | ---- | --- |
|            |     |         |     |     | :     |     | :   | :   |      |     |
,
|     |     |     |     |     | I   |     | I   | I   |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
-~~
|     |     | I   |     | I   | I   |     | I   | I   |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
IROY
|       |      | I   |     | I   | I   |     | I   | I   |     |     |
| ----- | ---- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|       | -~I  |     |     | \   | I   |     | I   | I   |     |     |
| TROY  |      | I   |     |     | I   |     | I   | I   |     |     |
|       |      |     |     |     | I   |     | I   | I   |     |     |
_~I
|         |     |     |     | \   |     |     |     | I   | I   |     |
| ------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| OEVSEL  |     | I   |     |     | I   |     | I   |     |     |     |
|         |     | I   |     |     | I   |     | I   | I   |     |     |
BASEREAD
|     |     |     | Figure 6-1,  | Basic PCI Read Cycle  |     |     |     |     |     |     |
| --- | --- | --- | ------------ | --------------------- | --- | --- | --- | --- | --- | --- |
|     |     |     | T2           |                       | T3  | T4  |     | T5  |     | T6  |
T1
SCLK
1
\
| FRAME  |     |     |     | I   |     |     |     |     |     |     |
| ------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
1
|            |     | AOO~ESS  |     |     |         |     |        |     |        | }-o  |
| ---------- | --- | -------- | --- | --- | ------- | --- | ------ | --- | ------ | ---- |
| AD[31:0)   |     |          | ~   | I   | DATA 1  | ~   | OAlA2  | X   | DAlA3  |      |
|            |     | 1        |     | 1   |         |     | 1      |     | 1      |      |
|            |     | BUS~MD   |     |     |         |     |        |     | ~S3    | }-o  |
| C/BE[3:0)  |     |          | ~   | I   | BE'S 1  | ~   | ~S2    | X   |        |      |
|            |     |          |     |     |         |     | 1      |     | 1-,    |      |
-o~
|     |     | 1   |     | 1   |     |     | 1   |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
IROY
|     |     | 1   |     | 1   |     |     | 1   |     | 1   |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
-01
|     |     |     |     | 1   | \   |     | 1   |     | 1   | I   |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
TRDY
|     |      |     | 1   | 1   |     |     | 1   |     | 1   |     |
| --- | ---- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|     | -01  |     |     | 1   |     |     | 1   |     | 1   |     |
I
|     |     |     | I   | 1   | \   |     | 1   |     | 1   |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
DEVSEL
|     |     |     | I            | I                      |     |     |     |     |     | BASEWRT  |
| --- | --- | --- | ------------ | ---------------------- | --- | --- | --- | --- | --- | -------- |
|     |     |     | Figure 6-2.  | Basic PCI Write Cycle  |     |     |     |     |     |          |
6-2  SYSTEM BUS INTERFACES

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
|     | T1  | T2  | T3  | T4  |
| --- | --- | --- | --- | --- |
SCLK
~
| FRAME  |     |     |     | I   |
| ------ | --- | --- | --- | --- |
I
I
IRDY
--+-,
TROY
|       | I   | I   |     |     |
| ----- | --- | --- | --- | --- |
|       |     | I   | I   |     |
| STOP  | I   |     |     |     |
cds
I
|     | I   | I   |     |     |
| --- | --- | --- | --- | --- |
|     | I   | I   | /   |     |
DEVSEL
|     | I   | I   |     |     |
| --- | --- | --- | --- | --- |
I
|     |     | I   |     | DISCONA  |
| --- | --- | --- | --- | -------- |
Figure 6-3. PCI Disconnect Example A
|     | T1  | T2  | T3  | T4  |
| --- | --- | --- | --- | --- |
SCLK
~:i7---~­
I
I
I
I
| -        | -r-              |     |     |             |
| -------- | ---------------- | --- | --- | ----------- |
| STOP     | I                |     |     | I           |
|          | I                |     |     | I           |
|          | I                |     | I   | I           |
| DEVSEL~  |                  |     | i~  |             |
|          | ,-----:------:,  |     |     | ,  DISCONB  |
Figure 6-4. PCI Disconnect Example B
SYSTEM BUS INTERFACES  6-3

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
|     |     | T1  |     | T2  | T3  | T4  |     | T5  T6  |
| --- | --- | --- | --- | --- | --- | --- | --- | ------- |
SCLK
b-
_-L __I ~
| FRAME  |     | I   | I   | \   | ,    |     |     | +I  |
| ------ | --- | --- | --- | --- | ---- | --- | --- | --- |
|        |     |     |     |     | +-1  |     |     | -   |
|        |     | I   | I   |     |      |     |     | I   |
r---
| AD[31:0]  |     | !   | •   |           |     |     |      |     |
| --------- | --- | --- | --- | --------- | --- | --- | ---- | --- |
|           |     |     |     | ADD tESS  | }-  |     | D+A  |     |
ID+SE- L~
+-
-1-{
r-
|            |     |     |              |     | X   | i     | i   |     |
| ---------- | --- | --- | ------------ | --- | --- | ----- | --- | --- |
| C/BE[3:0]  | -   |     | r -CFG RtAD  |     |     | BE'S  |     |     |
r -
|     |     |     |     | i   | \'-----'-__  |     | --'---11  |     |
| --- | --- | --- | --- | --- | ------------ | --- | --------- | --- |
I
0
|     |     |     | t-  | -   |     |     |     |            |
| --- | --- | --- | --- | --- | --- | --- | --- | ---------- |
|     |     |     |     | -i  |     | \   |     | ,r----+-l- |
~
|     |     | -   | 0            |                               |     |               |     |             |
| --- | --- | --- | ------------ | ----------------------------- | --- | ------------- | --- | ----------- |
|     |     | I   | I            |                               | I   | '----+----'.  |     | I  C'GREAD  |
|     |     |     | Figure 6-6.  | PCI Configuration Read Cycle  |     |               |     |             |
|     |     |     | T1           | T2                            | T3  |               | T4  |             |
SCLK
|     |     | I   |     | I   | I   | I   |     | I   |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
--x
|           | -   | -t- - | -I  |       | I        | I   |      |     |
| --------- | --- | ----- | --- | ----- | -------- | --- | ---- | --- |
|           |     |       |     |       | I        |     |      | ~-  |
| FRAME     |     | I     |     | I  \  | I        | I   |      | I   |
|           |     | I     |     | I     | I        | I   |      | I   |
|           |     |       | ~   |       |          |     | }-~- |     |
| AD[31:0)  |     | !     |     |       | ADDRrSS  | X   |      |     |
D+A
|     |     | I   |     | I   | I   | I   |     | I   |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
IDSEL_~
|             |     | I   |     | I   | I          | I   |        | I   |
| ----------- | --- | --- | --- | --- | ---------- | --- | ------ | --- |
|             |     | -+- | -   | -(  |            |     |        |     |
|             |     |     |     |     | X          | B1  |        |     |
|             |     |     | ~   |     |            |     |        | ~   |
| C/BE[3:0) - |     |     |     |     | CFG wrITE  |     | S  }-- | -   |
|             |     | I   |     | I   |            |     |        | I   |
--x
|     |     | f-  | -Of- | -   | ---I  |     |     | I   |
| --- | --- | --- | ---- | --- | ----- | --- | --- | --- |
|     |     | I   |      | I   | I     | \   | /   | I   |
|     |     | I   |      | I   | I     |     |     | I   |
1
--x
|     |     | f-I - | 0   | f-I - | ---II  |     |     | I   |
| --- | --- | ----- | --- | ----- | ------ | --- | --- | --- |
|     |     |       |     |       |        | \   | .   | I   |
C'GWRITE
|     |     | I   |              | I                              | I   |     |     | I   |
| --- | --- | --- | ------------ | ------------------------------ | --- | --- | --- | --- |
|     |     |     | Figure 6-5.  | PCI Configuration Write Cycle  |     |     |     |     |
6-4  SYSTEM BUS INTERFACES

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| T1  | T2  | T3  | T4  | T5  |
| --- | --- | --- | --- | --- |
Tl
SCLK
| I   |     | I   |     |     |
| --- | --- | --- | --- | --- |
|     | I   |     |     | ~   |
I
FRAME--l'
|     |     | I   |     | I   |
| --- | --- | --- | --- | --- |
| I   |     | I   |     | I   |
AD[31:0)  I
| ADDRfSS  | }-~  |     |     | ~   |
| -------- | ---- | --- | --- | --- |
I
| I   | I   | I   | I   | I   |
| --- | --- | --- | --- | --- |
}-9
I
PAR  :
| I   | l----{  |     |     |     |
| --- | ------- | --- | --- | --- |
Figure 6-7. Read Parity Operation
The Trio64V+ drives even parity information onto
the PAR line during read transactions. This op
eration is depicted in Figure 6-7.
SYSTEM BUS INTERFACES  6-5

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
6.2 VL-BUS INTERFACE holds read data active until RDYIN is asserted. If
the SRDY signal is not intercepted, it should be
fed to both the processor ROY input and the
Power-on strapping bits 1-0 must be set to 01 b to
Tri064V+ RDYIN input.
enable VL-Bus operation. Only SA[22:2) are di
rectly decoded by the Tri064V+. Two inputs
(SAUP1, SAUP2) are provided to allow decoding
of the upper address lines for Tri064V+ address
space accesses. The meanings of SAUP1 and
SAUP2 are defined by the following truth table.
Table 6-1. VL-Bus Upper Address Decoding
SAUP2 SAUP1 EFFECT
0 0 Ignored
0 1 Decode Access to
register/port address
space
1 0 Decode Access to linear
addressing address
space (video memory)
1 1 Ignored
There are many ways to generate these inputs,
depending on the system design.
6.2.1 VL-Bus Cycles
The basic VL-Bus read cycle is shown in Figure
6-8. The address is latched by the Tri064V+ on
one of two rising SCLK edges as shown in Figure
6-8 and explained in Note 1.
The basic VL-Bus write cycle is shown in Figure
6-9. The single wait-state is the default configu
ration. This can be changed to 0 wait-states
(SRDY asserted one cycle earlier) by clearing bit
4 of CR40 to o. The address is latched at the end
of T1. By default, write data is latched on the first
rising SCLK edge after the assertion of RDYIN.
6.2.2 SRDV Generation
For a VL-Bus configuration, the Tri064V+ raises
its SRDY output early in the Tl cycle and then
tri-states it. It then asserts SRDY to signal the end
of the cycle. Some systems synchronize or oth
erwise delay this signal and then assert RDY to
the processor. If this is done, this RDY signal
should also be fed to the RDYIN input of the
Tri064V+ (see Note 3 of Figure 6-9). The Tri064V+
6-6 SYSTEM BUS INTERFACES

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
|     |     | T1  |     | T2  | T3  | T4  |     | T5  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
SCLK
|          | _--!-I- ---.         |          | 1                |     | 1                  |     |     | 1   |
| -------- | -------------------- | -------- | ---------------- | --- | ------------------ | --- | --- | --- |
|          |                      | I        |                  |     | I                  |     |     |     |
|          |                      | \~-+l~/  |                  |     |                    |     |     | ~   |
|          |                      |          | ..               |     | ·1                 |     |     |     |
|          |                      |          |                  |     | NOTE 1             |     |     | -   |
| 5A[~~ •  |                      |          | I                |     | -----;-----T----~  |     |     |     |
|          | """"""'9'=:.>1 '-__  |          | -;-i ____- -;-·  |     |                    |     |     |     |
\!
|     |     | 1  /  | 1   |     | 1   |     |     |     |
| --- | --- | ----- | --- | --- | --- | --- | --- | --- |
SAUP
|     | _I~  |     | 1   |     | 1   |     |     | 'L- |
| --- | ---- | --- | --- | --- | --- | --- | --- | --- |
|     |      | 1   | 1   |     | 1   |     |     | 1   |
n--
|     |     | 1   | 1   | \            | 1   |           |     |              |
| --- | --- | --- | --- | ------------ | --- | --------- | --- | ------------ |
|     |     | 1   | 1   | '----I.I ___ |     |   1--__~  |     |  _  ___J/ 1  |
.
|     |     | 1   | 1   |     | 1   | 1   |     | 1   |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
I '#j
| 50[31:0]  |            |            |       |     |     |                 |         | VALID      |
| --------- | ---------- | ---------- | ----- | --- | --- | --------------- | ------- | ---------- |
|           |            | 1          | 1     |     | 1   | 1               |         | 1          |
|           |            | 1  r--\ 1  |       |     | 1   | 1               |         | /r---T-I - |
|           | --+-1- ,I  |            | .  1  |     | 1   | 1  \'--+---'    |         | 1          |
|           | --V1       |            | 1     |     | 1   | 1               | 1       | 1          |
|           |            |            |       |     |     |                 | ''-I  _ | _  -''Cl-- |
| ROVIN     |            |            | I     |     | I   | INOTE2 .......  |         |            |
I KVLREAt
|     |     |     | I   |     | I   |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
Figure 6-8. VL-Bus Read Cycle
Notes
1. For one decode wait state (bit 4 of CR40 set to 1). the address is latched on the first clock edge in
dicated here if bit 3 of CR58 is set to 1. If this bit is cleared to 0, the address is latched on the
second clock edge indicated. The address is always latched on the first clock edge if bit 4 of
CR40 is cleared to O.
2. The system chip set can delay the RDYIN input by 1 or more cycles. This example assumes a 1
cycle delay, as indicated by the solid line. Note that read data is held valid an extra cycle.
SYSTEM BUS INTERFACES  6-7

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
|     | ,  T1  | ,  T2  | T2  | T1  |
| --- | ------ | ------ | --- | --- |
|     | (      | (      |     |     |
|     | \      | \      | \   | L   |
5CLK
| 50[31:0]  |     |     | VALID  |     |
| --------- | --- | --- | ------ | --- |
,
|     | \   | /   | I   | L   |
| --- | --- | --- | --- | --- |
,
SADS
~,  NOTE 1
5A[31:2]
M/IO
i
W/R
|     |     | ,   |     | ,   |
| --- | --- | --- | --- | --- |
|     |     | ,   |     | ,   |
L
/
| SAUP  |     | ,   |     | ,   |
| ----- | --- | --- | --- | --- |
|       |     | ,   |     | ,   |
,
,
|       |     | ,  \  |     | ,  I  |
| ----- | --- | ----- | --- | ----- |
| LOCA  |     | ,     |     |       |
I
|     |     | ,   |     | ,   |
| --- | --- | --- | --- | --- |
r
|       | /   | \,  |         |        |
| ----- | --- | --- | ------- | ------ |
|       |     | ,   | ~~OTE2  |        |
| SRDY  |     | ,   |         | ,      |
|       |     | ,   |         | +---X  |
|       | /   | ,   |         |        |
I
NOTE3A
| RDYIN  |     | -,,   |     | ,   |
| ------ | --- | ----- | --- | --- |
KVLWRITE
Figure 6-9. 1 Wait-state VL-Bus Write Cycle
Notes
1.  For one decode wait state (bit 4 of CR40 set to 1), the address is latched on the first clock edge in
dicated here if bit 3 of CR58 is set to 1. If this bit is cleared to 0, the address is latched on the
second clock edge indicated. The address is always latched on the first clock edge if bit 4 of
CR40 is cleared to O.
2. The wait-state is inserted by setting bit 4 of CR40 to 1 to delay SRDY assertion by 1 cycle from
the assertion of SADS. This is the default value.
3.  Data is latched on the rising SCLK edge following assertion of RDYIN.
6-8  SYSTEM BUS INTERFACES

fl·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 7: Display Memory
The Tri064V+ supports a DRAM-based video Figure 7-1 shows 1-and 2-MByte configurations.
frame buffer. This section describes the various The 1-MByte memory configuration is available
configurations supported, the functional timing for either a VL-Bus or PCI bus configuration.
for memory accesses and the operation of vari Either fast page or EDO (1-cycle or standard)
ous register bits that affect memory timing and memory can be used. The PO bus is 32 bits. This
operation. It also describes how access to display reduces performance and the number of video
memory is controlled to maximize graphics per modes available as compared with 64-bit PO bus
formance. operation. Tri064-compatible VAFC feature con
nector operation can be enabled (SRD_1 = O).
7 .1 DISPLAY MEMORY
The configuration options for 2 MBytes of mem
CONFIGURATIONS ory are complex, depending on memory type
(fast page or EDO)' system bus type (VL-Bus or
The Tri064V+ uses fast page mode or extended PCI) and feature connector operation type
data out (EDO) DRAMs for its frame buffer. with (Tri064-compatible VAFC or LPB feature connec
support for single-cycle EDO operation. The type tor). With 2 MBytes of memory, 64-bit PO bus
of DRAM used is specified via power-on strap operation is available unless the Tri064-compat
ping of PD[3:2). All DRAMs can be configured as ible VAFC feature connector is enabled (SRD_1 =
256Kx4, 256Kx8 or 256Kx16. A Tech Note lists O). The signals for this feature connector are
recommended DRAMs. multiplexed on the upper PO lines. Therefore,
32-bit PO bus operation must be forced (CR68_7
For loading reasons, a maximum of 8 DRAM = O) before feature connector operation is en
chips can be used forthe frame buffer. Table 7-1 abled. (Note that this entire discussion applies
shows the supported memory size/chip count only to Tri064-compatible VAFC feature connec
configurations. tor operation and not LPB connector operation,
which is selected by SRD_1 = 1.)
Table 7-1 Memory Size/Chip Count
Configurations If only fast page memory is to be used, OEO can
be connected to both the 1st and 2nd MByte. Pin
124 always outputs OEO. Pin 50 also outputs OEO
256Kx4 256Kx8 256Kx16
with fast page memory when SRA_6 = 0 for a PCI
1 MB 8 4 2 configuration. Figure 7-1 shows pin 50 connected
2MB 8 4 to the 2nd MByte DRAMs' OE inputs. However,
4MB 8 pin 124 could be connected to the OEs (and must
be for a VL-Bus configuration). In e.ither case,
forcing the PO bus to 32 bits turns off all control
signal activity for the 2nd MByte so feature con
nector activation is allowed.
DISPLAY MEMORY 7-1

Trio64V+ Integrated Graphics/Video Accelerator
$3 Incorporated
If EDO memory is to be used with a 2-MByte  If feature connector operation is never required,
OEO (pin 124) can be used to drive both the 1st
configuration, the 2nd MByte DRAM OE  pins
must be connected to pin 50 of the Tri064V+ if  and  2nd  MBytes of both fast page and EDO
feature connector activation is required. In this  DRAM configurations. This configuration can be
case, pin 50 outputs DE1 when SRA_6 = 0 for a  upgraded to 4 MBytes for PCI bus systems.
PCI configuration. With EDO memory, 2 MBytes
of memory and the feature connector enabled,  A 4-MByte configuration requires RAS1 to select
OE1 is held high throughout the memory cycle.  the 3rd and 4th MByte. The Tri064V+ outputs
RAS1 on pin 50 for PCI configurations when bit 6
This is required to turn off output from the EDO
DRAMs in the 2nd MByte. The 1st MByte is still  ofSRA is setto 1. RAS1 is not available forVL-Bus
active because it is connected to the stili-func  configurations, limiting memory size to 2
| tioning OEO.  | MBytes. Figure 7-2 shows a 4-MByte configura  |     |     |
| ------------- | --------------------------------------------- | --- | --- |
tion using RAS1. The Tri064-compatible VAFC
Connecting pin 50 to the 2nd MByte DRAM OEs  feature connector cannot be used with 4 MBytes
works for both fast page and EDO DRAM in PCI  of memory and must never be enabled for 4-
configurations whether or not feature connector  MByte configurations.
operation is to be enabled. It cannot be used for
VL-bus configurations. In addition, this configu
ration cannot be upgraded to 4 MBytes.
FAST PAGE (FP) MODE OR EDO MEMORY AND SRA_6 = 0 (PIN 50 = OEO FOR FP AND OE1 FOR EDO)
PD[63:0]
-
PD[15:0]  PD[47:32]
|     | 256Kx16  | 256Kx16  |     |
| --- | -------- | -------- | --- |
|     | II- ~    | =        |     |
|     | OEO      | PIN 50   |     |
|     | RASO     | ~        |     |
|     | CAS1     | CAS4     |     |
|     | CASO     | CAS5     |     |
|     | WE       | WE       |     |
MA[8:0]
...
-
| Trio64V-t  | 25=m 6Kx-  16  PD[31:16]  |     | PD[63:48]  |
| ---------- | ------------------------- | --- | ---------- |
25 6K x16
r =
PIN 50
|     | RASO  | RASO  |     |
| --- | ----- | ----- | --- |
CAS6
CAS2
|     | CAS3  | CAS7  |     |
| --- | ----- | ----- | --- |
|     | WE    | WE    |     |
2MBFPEOO
RAM CONTROL
|     | \   | )  \  | )   |
| --- | --- | ----- | --- |
y  y
|     | 1ST MBYTE  | 2NDMBYTE  |     |
| --- | ---------- | --------- | --- |
Figure 7-1. 1-or 2-MByte DRAM Configuration
7-2  DISPLAY MEMORY

1/1
w
;;
n
o
1
i
."
| eli'  | PO[63,O]  |     |     |     |
| ----- | --------- | --- | --- | --- |
e
;
PO['5,O]  PO[47:321
-..J
| ~   |     |     |     | -...i   |
| --- | --- | --- | --- | ------- |
| ~   |     |     |     | ci"     |
3:
| i   | MAla,o]  |     |     | ~   |
| --- | -------- | --- | --- | --- |
I  I   I  I
c  I  256Kx16  P D[63:48]  256""'6  PO[31,'6]  256Kx16 I PD[63:48}  +
Tri064V+
|         |     | ~         |       | :i      |
| ------- | --- | --------- | ----- | ------- |
| ~       |     | RASO      | RAS1  | r+      |
|         |     | CAS6      | CAS6  | .C.D.   |
|         |     |           | CAS7  | CQ      |
| n       |     | CAS7  WE  | 'WE   |         |
| o       |     |           |       | AI      |
| =~..    |     |           |       | r +     |
C D
| ae::I   |              |     |         | Q.       |
| ------- | ------------ | --- | ------- | -------- |
| ;,      |              |     |         | .G..' )  |
|         | RAM CONTROL  |     | 4M'1FP  |          |
| o       |              |     |         | AI       |
PCI CONRGURATtoNSONLY ANDSRA_6 =1  (PIN 50 =R AS1)
| ~   |     |     |     | "-: C ::r     |
| --- | --- | --- | --- | ------------- |
c;'
en
| CJ  |     |     |     | <   |
| --- | --- | --- | --- | --- |
| Ui  |     |     |     | c:  |
""tJ
r
oCD
~
| s:  |     |     |     | »     |
| --- | --- | --- | --- | ----- |
| m   |     |     |     | n     |
| s:  |     |     |     | "     |
| o   |     |     |     | C D   |
.C . .i  '
::JJ
| -<  |     |     |     | AI  |
| --- | --- | --- | --- | --- |
r.o.+.
-..J
W

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
7 .2 DISPLAY MEMORY REFRESH bits 1-0 of CR3A. Refreshes are performed during
the horizontal blanking period.
The Tri064V+ uses the standard CAS before RAS
DRAM refresh method. The functional timing for 7 .3 DISPLAY MEMORY
this can be found in any standard DRAM data FUNCTIONAL TIMING
book.
Figure 7-3 shows the functional timing for a fast
The number of refresh cycles performed per hori
page mode read cycle. This also shows how
zontalline is determined by bit 6 of CR11. If bit 2
certain parameters for various control signals
of CR3A is set to 1, the number of refresh cycles
can be adjusted to meet the access time require-
per horizontal line is determined by the setting of
T1 T2 T3 T4 T5 T6 T7 T8 T9 T10
--------r---
MCLK
r--·----------·-------}
SEE NOTE 2
1-- -I
\ YLDATCH ING
(r-r--j-
'---~I ~ NOT~3 ~
SEE
MA[8:0j ~'-___R _O_W_ __ _'X,...-C-O-LU-M-N---.~ COLUMN ~...."....., ..".".,.. ......'... .,.,..,..,.
\ h
y'
L-----+j J"" S~E NOT~~~
PD[63:0j
~1~'--1~
Figure 7-3. Fast Page Mode Read Cycle
Notes
1. The minimum RAS precharge time can be adjusted from 2.5 to 3.5 MCLKs via CR68_3, to 1.5
MCLKs via MM81EC_16, and reduced by 0.5 MCLK via CR583.
2. This figure shows a RAS low time for a single column access of 3.5 MCLKs. (The dashed line
shows the RAS signal if the second page mode cycle were to be eliminated.) This RAS active
time can be changed to 4.5 MCLKs via CR68_2 or to 2.5 MCLKs via MM81EC_15 and increased
by 0.5 MCLK via CR58_7.
3. The CAS and OE active (low) times can be stretched via bits 1-0 of CR68.
7-4 DISPLAY MEMORY

Trio64V+ Integrated Graphics/Video Accelerator
53 I nco.po.sted
ments of a variety of DRAMs. Bits 1-0 of CR68 Figure 7-4 shows the functional timing for a fast
allow the pulse widths of the CAS and OE signals page mode write cycle. The RAS and CAS signals
to be adjusted. Bit 2 of CR68, bit 15 of MM81EC can be adjusted as explained for the read cycle
and bit 7 of CR58 allow adjustment of the RAS above. The WE can be delayed via bits 4-3 of
low time. Bit 3 of CR68, bit 16 of MM81 EC and bit CR6F.
7 of CR58 allow adjustment of the RAS precharge
(high) time. The settings in CR68 can be made by Figure 7-5 shows the functional timing for a fast
power-on strapping of PD[23:16] at reset. All set page mode read/modify/write cycle. This is a
tings can be changed by programming after re 1-wait state cycle.
set.
T1 T2 T3 T4 T5 T6 T7 T8 T9 T10
"'r---
MCLK
SEE NOTE 1 SEE NOTE 2 1----------... -----,
\\-_--'~/~
MA[8:0] ~ . ... ___R_ O_W_ __ . .JX COLUMN X COLUMN 'IIIl!i!I!IIIIx""""""""""""'"""'""""""
Ii Ii
~\
--' VsEE
NOTE ~'
DATA DATA
MMEMWR
Figure 7-4. Fast Page Mode Write Cycle
Notes
1. The minimum RAS precharge time can be adjusted from 2.5 to 3.5 MCLKs via CR68_3, to 1.5
MCLKs via MM81EC_16, and reduced by 0.5 MCLK via CR58_7.
2. This figure shows a RAS low time for a single column access of 3.5 MCLKs. (The dashed line
shows the RAS signal if the second page mode cycle were to be eliminated.) This RAS active
time can be changed to 4.5 MCLKs via CR68_2 or to 2.5 MCLKs via MM81EC_15 and increased
by 0.5 MCLK via CR58_7.
3. The CAS active (low) time can be stretched via bits 1-0 of CR68 and the WE active time delayed
via bits 4-3 of CR6F.
DISPLAY MEMORY 7-5

fl·
Trio64V+ Integrated Graphics/Video Accelerator
$3 Incorporated
| T1  T2  | T3  T4  | T5  T6  | T7  T8  | T9  T10  |
| ------- | ------- | ------- | ------- | -------- |
MCLK
____________
|     | \~  |     |     | ~r- |
| --- | --- | --- | --- | --- |
L J
|     |     |     | '!l!i!I  | '!Ii.  |
| --- | --- | --- | -------- | ------ |
___
| ~:[:~gJ  ~,- |            | . ..JX    |         |     |
| ------------ | ---------- | --------- | ------- | --- |
|              | R_O_W_  __ |   COLUMN  | COLUMN  |     |
LJ
f
| WE  |     |     |     | \   |
| --- | --- | --- | --- | --- |
•  VTx  N1:..
| PD[63:0]  •  |     |     |     | WRITEDATA  |
| ------------ | --- | --- | --- | ---------- |
FPRMW
Figure 7-5. Fast Page Mode Read/Modify/Write Cycle
7-6  DISPLAY MEMORY

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Figure 7-6 shows the functional timing for an MCLK later. Note that RAS, the last CAS and OE
Extended Data Out (EDO) mode read cycle. One are all stretched one MCLK and OE is held low
difference between an EDO read cycle and a fast for the entire cycle instead of being pulsed as in
page mode read cycle is that EDO memory holds a fast page mode cycle.
the data valid longer, allowing the data to be
latched one cycle later (rising edges of T8 and The timing adjustments for RAS and for
T10). This allows the use of slower access time CAS/OENIE as described above for a fast page
memory or a faster MCLK. Therefore, the last mode read cycle als~ly to EDO cycles. Note
page access (or first for a single access) is one that if the minimum RAS active time is specified
T1 T2 T3 T4 T5 T6 T7 T8 T9 T10
MCLK
-{~'
SEE NOTE 1 ________________________- 4_ _________- 4
X
~,- ...IX ~
MA[8:0] ___R_ O_W_ __ COLUMN COLUMN
OEO \ SEE NOTE3ti
IX
PD[63:0]~ I~
DATA DATA
_I
1 __ LATCHING MEDOMR
Figure 7-6. EDO Mode Read Cycle
Notes
1. The minimum RAS precharge time can be adjusted from 2.5 to 3.5 MCLKs via CR68_3, to 1.5
MCLKs via MM81EC_16, and reduced by 0.5 MCLK via CR58_7.
2. This figure shows a RAS low time for a single column access of 3.5 MCLKs. (The dashed line
shows the RAS signal ifthe second page mode cycle were to be eliminated.) This RAS active
time can be changed to 4.5 MCLKs via CR68_2 or to 2.5 MCLKs via MM81EC_15 and increased
by 0.5 MCLK via CR58_7.
3. The CAS and OE active (low) times can be stretched via bits 1-0 of CR68.
DISPLAY MEMORY 7-7

II·
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
T1 T2 T3 T4 TS T6 T7 TS T9 T10
MCLK
,~------------------------
LJ LJ
CAS
'lX/X/X/XNL ______ )88K ______
MA[S:O] R_O_W_ _____ . ...JX COLUMN C_O_L_U_M__N ________~
MB[S:O] ~_ ..
''--_-----.If
LJ
'f!lI, 'f/!i;.
PD[63:0] _ READ DATA WRITE DATA
EOORMW
Figure 7-7. EDO Mode Read/Modify/Write Cycle
as 3.5 MCLKs, the actual minimum for a single cycle, there is less time available between the
EDO read cycle will be 4.5 MCLKs. read and write.
The cycle depicted in Figure 7-6 is for 64-bit PD
bus operation (2 MBytes of memory and feature
connector operation disabled). If the feature con
nector is enabled, OEO only enables data output
on PD[31 :0) and OE1 (not shown) stays high the
entire cycle to disable output on PD[63:32).
An EDO write cycle is functionally the same as a
fast page mode write cycle.
Figure 7-7 shows the functional timing for an
EDO mode read/modify/write cycle. Since read
data is latched later than for a fast page mode
7-8 DISPLAY MEMORY

Trio64V+ Integrated Graphics/Video Accelerator
$3 Incorporated
7.4  1-CYCLE EDO DRAM SUPPORT  Figure 7-9 shows a read/modify/write cycle with
1-cycle EDO operation. A dummy cycle is added
between the read and write.
Bits 3-2 of CR36 are cleared to OOb to indicate that
1-cycle EDO DRAM operation is being used.
CPU (I.e., linear addressing) access to memory is
The functional timing for 1-cycle EDO reads and  not supported with 1-cycle EDO. 2-cycle EDO
operation will automatically be used for this func
| writes is provided by Figure 7-8. The  |     |     | DRAM  |     |     |     |
| -------------------------------------- | --- | --- | ----- | --- | --- | --- |
tion.
drives valid read data after the CAS falling edge
at T5. The chip latches the data on the next falling
CAS edge. Note that a dummy cycle is required
at the end to latch the last read. Write data is
latched by the DRAM on the falling edge of CAS.
No dummy cycle is required and the last CAS
shown in the diagram does not occur.
|     | T2  | T3  | T4  T5  | T6  | T7  | T8  T9  |
| --- | --- | --- | ------- | --- | --- | ------- |
T1
MCLK
,'--_____- '1
. .. ___
| ~~(:~g~  ~ |     |         | ..JX       | X     | X      | ~   |
| ---------- | --- | ------- | ---------- | ----- | ------ | --- |
|            |     | R_O_W_  | __  COL 1  | COL2  | COL 3  |     |
\'-------'/
|     |     |     |     |     | X   | X  'f!IIIll)!;  |
| --- | --- | --- | --- | --- | --- | --------------- |
~
| PD[63:0]  |     |     |         | RD 1  | RD 2·     | RD 3  |
| --------- | --- | --- | ------- | ----- | --------- | ----- |
|           |     |     | \'----_ |       | _- ---'1  |       |
| ~WR1      |     |     |         |       |           | ~     |
| PD[63:0]  |     |     |         | XWR2  | XWR3      |       |
SCEDORW
|     | Figure 7-8.  |     | '·Cycle EDO Mode Read/Write  |     |     |     |
| --- | ------------ | --- | ---------------------------- | --- | --- | --- |
DISPLAY MEMORY  7-9

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
T1 T2 T3 T4 T5 T6 T7 T8 T9
MCLK
,'---______- -'1
u
CAS
\'----11
PD[63:0]
SCEDORMW
Figure 7-9. 1-cycle EDO Read/Modify/Write Cycle
7-10 DISPLAY MEMORY

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
7 .5 DISPLAY MEMORY ACCESS When N is effective and when N MCLKs have
been used or the FIFO is filled, whichever comes
CONTROL
first, the Tri064V+ then allows the other display
memory processes access to memory. Filling of
A number of processes compete for access to the FIFO also stops at the end of active display.
display memory. These competing processes are FIFO filling cannot begin again until the scan line
(in decreasing order of access priority): position defined by the Start Display FIFO regis
ter (CR3BI. which is normally programmed with
• Primary Stream high (N parameter) a value 51ess than the value programmed in CRO
• Secondary Stream high (N parameter) (horizontal total). This provides time during the
• RAM refresh horizontal blanking period for RAM refresh and
hardware cursor fetch.
• Hardware cursor fetch
• LPB (M parameter) The M parameter specifies the number of MCLKs
• CPU accesses (M parameter) available for shown in the bullet list above. When
this number of MCLKs has occurred, memory
• Graphics Engine accesses (M parameter) control is returned for FIFO filling. If during the
• Primary Stream low (N parameter) processing period controlled by the M parameter
• Secondary Stream low (N parameter) there is time when there are no memory access
requests and the M value has not been reached,
control is immediately returned to FIFO filling as
The two processes with high and low priorities
specified by the N parameter.
have associated threshold register fields
(MM81EC, bits 14-10 and 9-5}.lfthe current count
Note that the M and N parameters should only
is equal to or above the threshold level for a
be changed with the screen turned off. This is
process, that process is given its low priority.
done by setting bit 5 of SR1 to 1.
Once the threshold is passed, the process is given
its high priority.
The primary and secondary stream processes are
responsible for screen refreshing and are associ
ated with the N parameter (CR60_7-0). RAM re
fresh and hardware cursor fetch occur during
blanking when FIFO fetches are not occurring.
The other processes are associated with the M
parameter (CR54_2, 7-3). Note that these are not
the same as the PLL M and PLL N parameters
used to specify the clock synthesizer frequencies.
When the Tri064V+ transfers data from display
memory to the primary or secondary stream
FIFO, the N parameter specifies the number of
MCLKs available for FIFO filling before memory
control is given up for M parameter processes.
Note that this parameter is only effective when
both FIFO threshold values are equal to or above
the threshold level and therefore have low prior
ity. Because of this, the FIFO threshold values
have by far the greatest effect on performance.
The Nand M parameter settings will normally
have little effect and can be left at their initial
BIOS settings.
DISPLAY MEMORY 7-11

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 8: RAMDAC Functionality
For 8 bits/pixel modes, the Tri064V+ internal 24- Streams Processor Off
bit RAMDAC provides three 256 6-bit word color Streams Processor On
look-up table (LUT) RAMs feeding three 8-bit
Streams Processor On -secondary
DACs. A clock doubled mode is also provided for
stream overlaid on VGA Mode 13 back
8 bits/pixel modes. A 24-bit LUT bypass is pro
ground
vided for 15/16-and 24-bit color modes. A special
640x480x24 mode is provided to allow true color
With the Streams Processor off (CR67-3-1 = OOb),
operation with 1 MByte of memory. The block
data from the video FIFO (memory) is processed
diagram for the internal RAMDAC is shown in
by another Tri064V+ module and then passed
Figure 8-1.
directly to the RAMDAC. (Figure 8-1 shows the
data going through the Streams Processor, but
8.1 OPERATING MODES all Streams Processor functions are bypassed.)
This mode is used for those video modes not
Depending on the setting of CR67 _3-2, the follow supported by the Streams Processor. This in
ing operating modes are available: cludes all VGA modes except modes D, E, 10, 12
VREF RSET
HIGH· AND TRUE-COLOR BYPASS
1---.4.AR
24
MUX 1-...,...j4.AG
18 h--H4.AB
24
INTERNAL RAMDAC BLOCK
Trio64V+
Figure 8-1. Internal RAMDAC Block Diagram
RAMDAC FUNCTIONALITY 8-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 8-1 Trio64V+ Color Modes
Color CR67 MAX MAX
Mode Bits 7-4 PA Bits DCLK Pixel Rate Description
a 0000 7:0 80 MHz 80 MHz 8-bit pseudo-color (LUT) -Default
8 0001 15:0 67.5 MHz 135MHz Two 8-bit pseudo-color (LUT)
9 0011 15:0 80 MHz 80 MHz 15-bit high-color ( LUT Bypass)
10 0101 15:0 80 MHz 80 MHz 16-bit high-color (LUT Bypass)
12 0000 23:0 75 MHz 25 MHz 640x480x24-bit packed (LUT Bypass)
13 1101 23:0 50 MHz 50 MHz 24-bit true-color (LUT Bypass)
and 13, all interlaced modes and the clock-dou 8.2.1 8 Bits/Pixel -Mode 0
bled 8 bits/pixel mode.
Mode 0 is selected by setting bits 7-4 of CR67 to
With the Streams Processor on (CR67 _3-2 = 11 b),
OOOOb. In this mode, the low 8 internal pixel
memory data is passed directly to the Streams
address bus bits are ANDed with the contents of
Processor. 8 bits/pixel (palettized) data is passed
the Pixel Read Mask register (3C6H). The result
directly to the RAMDAC, where it is interpreted
of the AND operation selects one of 256 LUT
by the color look-up table and returned to the
locations. This results in the output of 6 bits of
Streams Processor as RGB666. This and other
color information to each of the DACs.
input data types are converted to RGB888 (if
required) and then sent to the RAMDAC via the
high and true color bypass. 8.2.2 Output-doubled 8 Bits/Pixel -
Mode 8
8.2 COLOR MODES
This mode is selected by setting bits 7-4 of CR67
The Tri064V+ internal RAMDAC provides 6 color to 0001 b.ln this mode, latching of pixel data from
modes of the following 3 primary types: the lower two bytes ofthe internal pixel data bus
is based on the pixel clock (VCLK) and output of
1. 8 bits (low byte of the internal pixel address pixel data from the latches to the DACs is based
bus) are latched each pixel clock and are on an internal clock running at twice the VCLK
used to select a LUT location. rate. Either bit 4 or bit 6 of SR15 must be set to 1
when this mode is selected and bit 7 of SR18
2. 16 bits (low two bytes of the internal pixel
must also be set to 1.
address bus) are latched each pixel clock.
These select two consecutive LUT loca
This mode processes two pixels per VCLK with a
tions, the data from which is clocked out
maximum VCLK rate of 67.5 MHz. This results in
to the DACs at twice the pixel clock rate.
an effective pixel output clock rate of 135 MHz.
3. 15 or 16 bits (lower two bytes of the inter
nal pixel address bus) or 24 bits (all three The internal pixel bus bits are ANDed with the
bytes of the internal address bus) are contents of the Pixel Read Mask register. The
transferred directly to the DACs each pixel result of the AND operation selects one of 256
clock. LUT locations. This results in the output of 6 bits
of color information to each of the DACs.
Each of the 6 color modes is listed in Table 8-1.
The desired mode is selected by programming
bits 7-4 of CR67.
8-2 RAMDAC FUNCTIONALITY

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
8.2.3 15/16-Bits/Pixel -Modes 9 and If bit 5 of the PCI Command register is cleared to
0, the Tri064V+ claims all RAMDAC read and
10
write cycles.
These modes are selected by setting bits [7:41 of Bits 2-0 of CR34 allow handling of PCI master
CR67 to 0011b (15 bits/pixel) or 0101b (16 aborts and retries to be individually enabled or
bits/pixel). In either case, one pixel is transferred disabled during RAMDAC cycles.
on the lower two bytes of the internal pixel bus
each VCLK cycle. This data is sent directly to the If power-on strapping bit 12 (CR37, bit 4) is pulled
DACs via the LUT bypass. low at resetfor a VL-Bus configuration, LOCA and
SRDY are not generated by the Tri064V+ for
RAMDAC write accesses. The Tri064V+ gener
8.2.4 Packed 24 Bits/Pixel -Mode 12
ates write cycles to the local RAMDAC and the
ISA controller also generates cycles to an off
This mode is selected by setting bit 3 of SRB to board RAMDAC (mirroring). RAMDAC reads are
1, bits 7-4 of SRB to 0111b and bits 7-4 of CR67 always from the local RAMDAC.
to OOOOb.lt is used for a resolution of 640x480x24.
Each pixel is stored in 24 bits of memory, allow If bit 7 of CR37 is set to 1, the Tri064V+ claims all
ing operation with 1 MByte of memory. One byte RAMDAC read and write cycles (LOCA and SRDY
of color data is retrieved each DCLK. DCLK is are generated).
internally divided by 3 to provide the VCLK to the
internal RAMDAC. Thus, one pixel is latched into
the RAMDAC every three DCLKs. Bits 4-3 of CR65 8.5 SENSE GENERATION
must be set to 1O b for this mode to delay BLANK
to the RAMDAC by 2 DCLKs. The internal hard The internal RAMDAC contains analog voltage
ware cursor cannot be used in this mode and no comparators. These drive the internal SENSE
acceleration is provided. signal active low whenever the output on any of
the AR, AG or AB pins exceeds 330 mV ± 20%.
8.2.5 24 Bits/Pixel -Mode 13 The state of this internal signal can be read via
bit 4 of 3C2H. This information can be used to
detect the existence and type of monitor
This mode is selected by setting bits 7-4 of CR67 (color/mono) connected to the system.
to 1101b. One pixel is transferred to the DACs
each VCLK cycle via the LUT bypass.
8.6 POWER CONTROL
8.3 RAMDAC REGISTER ACCESS
The Tri064V+ provides a PDOWN input pin.
When a logic 0 signal is driven to this pin, the RGB
The standard VGA RAMDAC register set (3C6H - analog outputs are turned off.
3C9H) is used to access the internal RAMDAC
registers.
8.4 RAMDAC SNOOPING
For PCI bus configurations, setting bit 5 of the
Command configuration space register (Index
04H) to 1 causes the. Tri064V+ to snoop for RAM
DAC writes. This means that the Tri064V+ will
write the data to its local RAMDAC but will not
claim the cycle by asserting DEVSEL. This allows
the ISA controller to also generate a write cycle
to a secondary RAMDAC. The Tri064V+ always
provides the data for RAMDAC reads.
RAMDAC FUNCTIONALITY 8-3

,I.
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorpora~ed

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 9: Clock Synthesis and Control
The Trio64V+ contains two phase-locked loop The PLL M value can be programmed with any
(PLL) frequency synthesizers. These generate the integer value from 1 to 127. The binary equivalent
DCLK (video clock) and MCLK (memory clock) of this value is programmed in bits 6-0 of SR11
signals for the graphics controller block. forthe MCLK and in bits 6-0 ofSR13 forthe DCLK.
The PLL feedback loop frequency from the volt
age controlled oscillator stage is scaled by divid
9.1 CLOCK SYNTHESIS
ing that frequency by (M+2).
Each PLL scales a single reference frequency The PLL N value can be programmed with any
input on the XIN pin. By placing a parallel-reso integer value from 1 to 31. The binary equivalent
nant crystal between the XOUT output pin and of this value is programmed in bits 4-0 of SR10
the XIN pin, the reference frequency is generated forthe MCLK and in bits 4-0 of SR12 forthe DCLK.
by the Trio64V+'s internal oscillator. Alternately, The reference frequency is divided by (N+2) be
a CMOS-compatible clock input can be con fore being fed to the phase detector stage of the
nected to XIN to provide the reference frequency. PLL.
The frequency synthesized by each PLL is deter The PLL R value is a 2-bit range value that can be
mined by the following equation: programmed with any integer value from 0 to 3.
The R value is programmed in bits 6-5 of SR 10
(M+2) for MCLK and bits 6-5 of SR12 for DCLK. This
four = R x fREF value codes the selection of a frequency divider
(N+2)x2
for the PLL output. This is shown Table 9-1.
where R = 0,1,2 or 3
Table 9-1. PLL R Parameter Decoding
Programmed PLL M and PLL N values should be
consistent with the following constraints: R-Range Code Frequency Divider
00 1
1. 135MHz< (M+2)fREF < 270MHz 01 2
- (N+2) -
10 4
11 8
2. min N;::: 1
The entire PLL block diagram is shown in Figure
Note that values used for the parameters are the
9-1.
integer equivalents of the programmed value. In
particular, the R value is the code, not the actual
frequency divisor.
CLOCK SYNTHESIS AND CONTROL 9-1

II·
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
KPLlBLK
Figure 9-1. PLL Block Diagram
The following sequence may be followed to ar ways. If bit 5 ofSR15 is cleared to 0, the new DCLK
rive at M and N values for any mode. frequency is loaded by setting bit 1 of SR15 to 1
and then setting bits 3-2 of 3C2H to 11 (if they are
1. Calculate an R which does not violate the not already programmed to this value). Bit 1 of
following constrains: SR15 should be left at a value of 1. Actual loading
will be delayed for a short but variable period of
135MHz< 2RxfoUT~ 270MHz time.
2. Start with N1 = 1 and calculate:
The alternate approach to loading the new DCLK
frequency is to program bits 3-2 of 3C2 to 11 (if
R
M= [fOUTX (N+2) x2 J-2 they are not already programmed to this value).
fREF Next, program SR12 and SR13 and then toggle
bit 5 of SR15 by programming it to a 1 and then
3. Determine if the following constraint is met:
a o. This immediately loads the DCLK and MCLK
frequencies (no variable delay). For example,
(Mt2) fREF
0.995 fOUT< m. < 1.005 fOUT pseudocode to change DCLK to the frequency
(N1+2) 2 specified by PLL parameter values of 34H and
4. If the constraint in step 3 is met, the M and 56H is:
N values used will generate the desired
frequency (within the specified tolerance). 3C2 <= 6FH DCLK specified by
If the constrain is not met, repeat steps 2 SR12 and SR13
and 3 with N increased by 1 each time un 3C4 <= i2H SR12 index
til the constraint in step 3 is met. Note that
3C5 <= 34H SR12 PLL value
multiple combinations of M and N are pos
3C4 <= 13H SR13 index
sible for a given output frequency.
3C5 <= 56H SR13 PLL value
3C4 <= i5H SR15 index
9.2 CLOCK REPROGRAMMING
3C5 <= RMW Use read/modify/write to
set bit 5 to 1 and leave
The Tri064V+ powers up with a DCLK frequency other bits unchanged
of 25.125 MHz (standard VGA) and an MCLK 3C5 <= RMW Use read/modify/write to
frequency of 45 MHz. The DCLK frequency can be
clear bit 5 to 0 and
changed to 28.322 MHz by setting bits 3-2 of3C2H leave other bits
to 01 b and can be changed back to 25.125 MHz unchanged
by setting bits 3-2 of 3C2H to OOb. The loading of
the DCLK frequency values requires that bit 1 of
Either loading approach should work. The sec
SR15 be set to 1.
ond (immediate loading) approach helps with
system testing since the timing of the load is
All other DCLK frequencies must be generated by
predictable. The first approach (via bit 1 of SR 15)
re-programming SR12 and SR13. The new PLL
has the advantage of separating the loading of
parameter values can be loaded in one of two
DCLK from that of MCLK.
9-2 CLOCK SYNTHESIS AND CONTROL

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
After power-up, all MCLK frequency changes
must be made by re-programming SR10 and
SR11. If bit 5 of SR15 is cleared to 0, the new
frequency doe°s n ot take effect until a 1 has been
written to °bit of SR15. This bit must then be
cleared to to prevent repeated loading. Actual
loading will be delayed for a short but variable
period oftime.
As explained above for DCLK, toggling bit 5 of
SR15 (0,1,0) immediately loads both the DCLK
values in SR12 and SR13 and the MCLK values in
SR10 and SR11.
9.3 DCLK CONTROL
DCLK is generated by the internal clock synthe
sizer. VCLK is the signal used to clock pixel data
into the internal RAMDAC. For most modes of
operation, VCLK is generated directly from DCLK
and has the same frequency a°nd phase (neglect
ing internal gate delays). Bit of CR67 provides
the option to invert DCLK before it becomes
VCLK.
In mode 8, the internal RAMDAC requires two
clocks. The normal internal DCLK frequency is
divided by two via bit 4 of SR15 to provide the
standard VCLK input. Undivided DCLK provides
the other input. This clock can be inverted via bit
6 of SR15.
Certain 4 bits/pixel modes require that DCLK be
halved. This is the case for b°it 6 of AR10 set to 1
and bit 4 of CR3A cleared to and is enabled by
setting bit4 or SR15to 1 and clearing bit3 ofCR33
to 0.
CLOCK SYNTHESIS AND CONTROL 9-3

Ii·
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 10: Streams Processor
The S3 Streams Processor processes data from 2. Secondary Stream -RGB or YUV/YCbCr
the.graphics frame buffer, composes it and out (video) data from another region within
puts the result to the internal DACs for generation the frame buffer
of the analog RGB outputs to the monitor. The 3. Hardware Cursor -64x64x2 cursor, either
general data flow is shown in Figure 10-1. Note Microsoft or X-11 definition
that the DAC shown in this figure is inside the
Tri064V+. Regardless of the input formats, the Streams
Processor creates a composite RGB-24 (8.8.8)
10.1 INPUT STREAMS output to the DACs. This means that, for exam
ple, RGB-8 pseudo-color graphics data can be
overlaid with true-color-equivalent (24 bits/pixel)
The processor can compose data from up to 3
video data. The result is improved video quality
independent streams as shown in Figure 10-1:
and/or reduced memory bandwidth require
ments as compared with systems that require
both graphics and video to be stored in the same
1. Primary Stream -RGB graphics data
frame buffer format. In certain modes, the
GRAPHICS
r-----------------.
FRAME BUFFER
GRAPHICS BUFFER 0
S B K B
C L E
GRAPHICS BUFFER 1 A E Y
L N I
I D N
NIG
SPRITENIDEO 0
G N
G
SPRITENIDEO 1
__ST_R_E_A_M_S_ _P_R_O_C_E_S_S_O_R_ J
OFF SCREENI
HARDWARE CURSOR
STREAMS
Figure 10·1. Streams Processor
STREAMS PROCESSOR 10-1

fl·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Streams Processor also saves memory band frame buffer by some video source (CPU, de
width by eliminating the need to save and restore coder, digitizer). The format for this data can be
the overlay background since the background any of the following as selected via bits 26-24 of
(primary stream) is never overwritten in the MMB190.
frame buffer.
YCbCr-16 (4.2.2), 16 -240 input range
Streams Processor support is not available for • YUV-16 (4.2.2), 0 -255 input range
clock-doubled B bits/pixel modes, 24 bits/pixel
KRGB-16 (1.5.5.5) -The K bit is the color
modes, interlaced graphics modes and standard
key.
VGA modes except for modes D, E, 10, 12 and 13.
• YUV (2.1.1)
Bits 3-2 of CR67 specify the Streams Processor
• RGB-16 (5.6.5)
mode of operation. If they are cleared to OOb,
• XRGB-32 (X.B.B.B) -X is the ignored up
Streams Processor operation is disabled. They
per byte.
are programmed to 01b when the primary stream
is VGA mode D, E, 10, 12 or 13 (the only sup
The data can be passed through unscaled or
ported modes). A secondary stream can be over
scaled up horizontally and vertically by an arbi
laid on the primary stream. CR67 _3-2 are set to
trary amount. YCbCr/YUV data is color space
11 b to support an Enhanced mode primary
converted and all data is converted to RGB-24
stream and a secondary stream.
(B.B.B) format.
10.1.1 Primary Stream Input
10.1.3 Hardware Cursor Generation
The primary stream is generated by reading the
Hardware cursor generation is explained in Sec
RGB pixel data written to the frame buffer by the
tion 15. The cursor is overlaid on the Streams
graphics controller. The format for this data can
Processor image.
be any of the following as selected via bits 26-24
of MMB1BO.
10.1.4 Frame Buffer Organization/
• RGB-B (Although not shown in Figure 1,
Double Buffering
the frame buffer data is first passed
through the internal RAMDACs color
lookup table (CLUT), where it is palet For each stream to be used, the starting location
tized before being passed to the (offset) in the frame buffer and the stride (byte
Streams Processor. offset between vertically adjacent pixels on the
screen) must be specified. Both the primary and
• KRGB-16 (1.5.5.5) -The K bit is the color
the secondary streams can be double buffered as
key.
depicted in Figure 10-1. This means that dupli
• RGB-16 (5.6.5) cate frame buffer storage can be provided for
• XRGB-32 (X.B.B.B) -X is the ignored up both the primary and secondary image (or for
per byte. either one of them). With double buffering, the
programmer can rapidly switch from one pri
mary or secondary image to the other. In addi
10.1.2 Secondary Stream Input tion, having two images allows more time for
updating one image while the other is being
The secondary stream is generated by reading displayed. Defining the frame buffer organization
pixel data from a separate section of the frame and implementing double buffering are done via
buffer than that used to generate the primary the register fields described in Table 4-1. LPB
screen. This might be RGB data written by the stands for Local Peripheral Bus.
graphics controller, such as a sprite used by
game programmers for moving objects. It could The secondary stream can be generated from
also be RGB, YUV or YCbCr data written to the data written to the frame buffer via the LPB when
10-2 STREAMS PROCESSOR

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 10-1. Register Fields Used For Specifying Frame Buffer Organization and Double Buffering
Register Field Description
MM81CO_21-0 Primary Display Buffer Address O. This is the starting address (offset) in the
frame buffer for 1 primary graphics image.
MM81C4_21-0 Primary Display Buffer Address 1. This is the starting address (offset) in the
frame buffer for a second primary graphics image.
MM81CS_11-0 Primary Stream Stride. This is the byte offset in the frame buffer from a pixel in
a given primary image display line to the pixel directly below it on the next
dispJay line. The stride must be the same for both primarv buffers.
MM81CC_0 Primary Stream Buffer Select
0= Primary frame buffer starting address 0 (MMS1CO_21-0) used for primary
stream
1 = Primary frame buffer starting address 1 (MMS1C4_21-0) used for primary
stream
MMS1CC_2-1 Secondary Stream Buffer Select
00 = Secondary frame buffer starting address 0 (MMS1D0_21-0) used for the
secondary stream
01 = Secondary frame buffer starting address 1 (MMS1D4_21-0) used for the
secondary stream
10 = Secondary frame buffer starting address 0 (MMS1DO_21-0) used for the
secondary stream and LPB frame buffer starting address 0 (MMFFOC_21-0)
used for the LPB input stream OR secondary frame buffer starting address
1 (MMS1D4_21-0) used for the secondary stream and LPB frame buffer
starting address 1 (MMFF10_21-0) used for the LPB input stream. Which
alternative applies is determined by LPB starting address register selected
by bit 4 of this register.
11 = Secondary frame buffer starting address 0 (MM81D0_21-0) used for the
secondary stream and LPB frame buffer starting address 1 (MMFFOC_21-0)
used for the LPB input stream OR secondary frame buffer starting address
1 (MMS1D4_21-0) used for the secondary stream and LPB frame buffer
starting address 0 (MMFF10_21-0) used for the LPB input stream. Which
alternative applies is determined by the LPB starting address register
selected by bit 4 of this register.
MM81CC3 LPB Input Buffer Select
0= LPB frame buffer starting address 0 (MMFFOC_21-0) used for LPB input
1 = LPB frame buffer starting address 1 (MMFF10 21-0) used for LPB input
MM81CC_5 LPB Input Buffer Select Loading
o = The value programmed in bit 4 of this register takes effect immediately
1 = The value programmed in bit 4 of this register takes effect at the end of the
next frame (completion of writing all the data for a frame into the frame
buffer)
MM81CC_6 LPB Input Buffer Select Toggle
0= End of frame (completion of writing all the data fro a from into the frame
buffer) has no effect on the setting of bit 4 of this register
1 = End of frame causes the setting of bit 4 of this register to toggle
STREAMS PROCESSOR 10-3

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 10-1. Register Fields Used For Specifying Frame Buffer Organization and Double Buffering
(continued)
Register Field Description
MM81CC3 Dropped Frame Writing
0= The dropped frames specified in bits 10-8 of this register are written to the
frame buffer
1 = The dropped frames specified in bits 10-8 of this register are not written to
the frame buffer
MM81CC_10-B Frame Dropping
Value = 1 less than the number of frames to drop between captured frames
Bit 7 of this register determines whether or not the dropped frames are written
to the frame buffer.
MM81DO_21-0 Secondary Display Buffer Address O. This is the starting address (offset) in the
frame buffer for 1 secondary graphics or video image.
MM81 04_21-0 Secondary Display Buffer Address O. This is the starting address (offset) in the
frame buffer for a second secondary graphics or video image.
MM81D8_11-0 Secondary Stream Stride. This is the byte offset in the frame buffer from a
pixel in a given secondary image display line to the pixel directly below it on
the next display line. The stride must be the same for both secondary buffers.
MMFFOC_21-0 LPB Frame Buffer Address O. This is the starting address (offset) in the frame
buffer for one image buffer into which is written data from the LPB. The
secondary stream can be generated from this buffer.
MMFF10_21-0 LPB Frame Buffer Address 1. This is the starting address (offset) in the frame
buffer for a second image buffer into which is written data from the LPB. The
secondary stream can be generated from this buffer.
MM81CC_6 LPB Input Buffer Select Toggle
o = End of frame (completion of writing all the data fro a from into the frame
buffer) has no effect on the setting of bit 4 of this register
1 = End of frame causes the setting of bit 4 of this register to toggle
LPB mode is enabled. In this case, the Secondary 10.2.1 Primary Stream Processing
Display Buffer Address 0 and the LPB Frame
Buffer Address 0 will normally be the same, as
The primary stream input RGB format is con
will the Address 1's for both the secondary
verted (if required) to RGB-24 (8.B.8) format. Each
stream and the LPB input if double buffering is
color byte is padded as required with low order
used. The various LPB control bits described in
zeros. After this conversion, the data can be
Table 10-1 allow complete hardware control of
passed through unscaled or scaled up horizon
the capture and display of video data using either
tally and vertically by a factor of 2 via bits 30-28
single or double buffering.
of MM8180. For MM8180_30-28 = 001, horizontal
scaling is done via replication. If these bits are
10.2 INPUT PROCESSING programmed to 010, horizontal scaling is done
using interpolation. Vertical scaling is automatic
and uses line replication. The 2x scaling allows a
Different processing options are available for the
320x240 image (as used by many games) to be
primary and secondary input streams. These are
displayed at a full-screen 640x480 resolution.
explained next.
10-4 STREAMS PROCESSOR

...
r
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
10.2.2 Secondary Stream Processing 10.3 COMPOSITION/OUTPUT
The secondary stream input format is converted A variety of output types can be composed from
(if required) to RGB-24 (8.8.8) format. For the streams described above. The compose
YUV/YCbCr inputs, the required color space con modes are:
version is automatically performed. Before con
version, the data can be passed through unscaled 1. MM81AO_26-24 = OOOb -Secondary stream
or scaled up horizontally and/or vertically by ar overlaid on the primary stream in an
bitrary factors. Horizontal scaling uses filtering opaque rectangular window. This is the
for interpolation. Vertical scaling uses line repli default mode and can be used, for exam
cation. The register fields involved in scaling up ple, for a video window overlaying the
the secondary stream are described in Table 10- graphics screen. Note that this mode will
2. Figure 10-2 graphically describes the various not work for the case where the user
fields. needs to pull down a graphics window
over the video since the graphics window
For example, assume a 10x10 window that is to is defined as being under the video win
be scaled up horizontally by a factor of 2.5. The dow. Color keying (number 5 in this list)
filter characteristics are set for bi-linear (2x to 4x must be used for this purpose.
stretch). The starting line width is 10 pixels and
2. MM81AO_26-24= 001b -Primary stream
the ending line width is 25 pixels. The DDA hori overlaid on the secondary stream in an
zontal accumulator initial value is 2 (10-1) -(25-1) opaque rectangular window. This could
= -6. The K1 horizontal factor is 10-1 = 9. The K2 be used, for example, to provide graphics
horizontal factor is 10-25 = -15. Programming captions for a video window. The video is
these parameters with these values results in a not visible behind the rectangular graph
2.5x horizontal stretch for the secondary stream ics window.
window.
SCREEN START XO
(MM81 FO_26-161'-____________________- --.
WINDOW START X1
(MM81F8 26-16)
... X1-XO ..
"""'-- WINDOW WIDTH WO ----.
..... - BEFORE SCALING
SPWINDEF
Figure 10-2. Screen Definition Parameters
STREAMS PROCESSOR 10-5

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 10-2. Register Fields Used For Scaling Up the Secondary Stream
Register Field Description
MM8190_30-28 Filter Characteristics
000 = Secondary stream (pass-through)
001 = Secondary stream, linear, 0-2-4-2-0, for X stretch
010 = Secondary stream, bi-linear, for 2X to 4X stretch
011 = Secondary stream, linear, 1-2-2-2-1, for 4X stretch
This selection applies only to horizontal scalinQ.
MM8190_11-0 DDA Horizontal Accumulator Initial Value. Value = 2 (WO-1) -(W1-1), where
WO is the line width in pixels before scaling and W1 is the line width after
scaling. This is a signed value.
MM8198_10-0, K1 Horizontal Factor. Value = WO-1, where WO is the line width in pixels before
scalinQ. This is a siQned value.
MM8198_26-16 K2 Horizontal Factor. Value = WO-W1, where WO is the line width in pixels
before scaling and W1 is the line width after scaling. This is a signed value.
MM81EO_10-0, K1 Vertical Factor. Value = [height (in lines) of the initial output window
(before scaling)] -1. The initial output window height is the vertical resolution
of the data written to the frame buffer and is shown as HO in Figure 10-2.
MM81E4_10-0, K2 Vertical Factor. Value = 2's complement of [height (in lines) of the initial
output window (before scaling)] -[height (in lines) of the final output window
(after scaling)]
The initial output window height is the vertical resolution of the data written
to the frame buffer and is shown as HO in Figure 10-2. The final value is the
same height value that is programmed in MM81 FC_10-0 and is shown as H1 in
Figure 10-2. This value is then the 2's complement of (H1 -HO).
MM81E8_11-0, DDA Vertical Accumulator Initial Value. Value = 2's complement of [height (in
lines) of the output window after scaling]-1. This is the same height value that
is ~ogrammed in MM81FC 10-0 and is shown as H1 in Figure 10-2.
3. MM81AO_26-24 = 010b -Secondary stream 6. MM81AO_26-24 = 110b -Primary stream
blended with the primary stream on a overlaid on the secondary stream in an ir
pixel by pixel basis within the secondary regular window. This requires a
stream window. This is used to provide a color/chroma key. This case allows, for ex
dissolve between two scenes. ample, graphics text to overlay video with
the video appearing around and even in
4. MM81 AO_26-24 = 011 b -Secondary stream
side of the text characters.
blended with the primary stream on a
pixel by pixel basis within the secondary
stream window. This is used to provide a 10.3.1 Opaque Rectangular
fade between two scenes.
Overlaying
5. MM81AO_26-24 = 101 b -Secondary stream
overlaid on the primary stream in an ir
These modes are items 1 and 2 in the compose
regular window. This requires a color key.
modes list. When one ofthese modes is used, the
This would be used, for example, for
programmer can invoke a feature called opaque
game sprites. Only the graphics area be
overlay control. This is enabled by setting
hind the sprite shape would be covered
MM81DC_31 to 1.lf MM81AO_26-24 = OOOb (sec
up.
ondary stream on top), then MM81 DC_30 must
10-6 STREAMS PROCESSOR

....
r
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
be cleared to 0 to also specify secondary stream space converter. Note that blending makes sense
on top. Similarly, If MMB1AO_26-24 = 001 b (pri only when both streams are defined. In addition,
mary stream on top), then MMB1DC_30 must be when blending is selected, the concept of back
set to 1 to also specify primary stream on top. The ground/foreground or top and bottom window
next step is to define when to stop fetching pixels has no meaning.
for a line from memory and when to restart
fetching them. The goal is to not fetch those Two types of blending are provided: dissolve and
pixels in the background window that are cov fade.
ered up by the opaque rectangular overlay win
dow, thus saving memory bandwidth. When dissolve is chosen, the output pixels are
generated using the following equation:
The first pixel that does not need to be fetched is
at horizontal position X1 shown in Figure 10-2. !Pp x Kp + Ps x (B -Kp)]/B
This is programmed in MMB15B_26-16. The start
ing pixel position for the background (XO) is Pp and Ps are the primary and secondary stream
programmed in MMB1FO_26-16. The difference pixel colors respectively, both RGB 8.B.B. Kp is
(X1 -XO) must be converted into quadwords and the primary stream weighting factor. It is a 3-bit
then programmed in MMB1 DC_12-3. The value is value programmed in MMB1AO_12-10. This
(X1 - XO) x bytes per pixel/4. If the result is a weight value is applied to each of the three color
fraction, it is rounded up to the next highest values for the pixel. If Kp = 0, only the secondary
integer to ensure that the first pixel not fetched stream is displayed. As Kp is increased, more of
in inside the opaque overlay window. Note that the pixel color from the primary stream is
if the secondary stream is in the background, blended into output. At the maximum (Kp = 7 or
then the value is (XO - X1) x bytes per pixel!4, 111 b), 7/Bths of the color will be due to the pri
again rounded up. mary stream and 1/Bth will be due to the secon
dary stream. Therefore, by starting with the
Pixel fetching must start again before or at the primary stream only, then overlaying the secon
last pixel position ofthe opaque overlay window. dary stream with Kp values decreasing from 7 to
Using the terms in Figure 10-2, this position is (X1 0, the overlay window can be dissolved gradually
-XO) + W1, with W1 programmed in MMB1FC_26- from primary stream to secondary stream. Note
16 (secondary stream is on top). Converting to that when the Kp value is reprogrammed, its new
quadwords, the value is [(X1 -XO) + W1] x bytes value does not take effect until the next VSYNC,
per pixel!4. If the result is a fraction, the result is so it can be reprogrammed during frame display
truncated to the next lowest integer (minus 1) without disruptive effects.
and programmed in MMB1DC_2B-19. Note that if
the secondary stream is in the background, then When fade is chosen, the output pixels are gen
(XO - X1) is used and W1 is the value in erated using the following equation:
MMB1F4_26-16 (primary stream is on top).
!Pp x Kp + Ps x Ks]/B, where Kp + Ks must be ::; B.
Opaque overlay control cannot be used with key
ing or blending and should never be enabled Ks is the secondary stream weighting factor. It is
when one of these modes is being used. a 3-bit value programmed in MM81 A03-2. This
weight value is applied to each of the three color
values for the pixel. Note that when fading is
10.3.2 Blending
selected, the default values for Kp and Ks (both
0) result in a color value of O. As with Kp, when
These modes are items 3 and 4 in the compose the Ks value is reprogrammed, its new value
modes list. The blender accepts the primary and does not take effect until the next VSYNC.
secondary pixel streams and blends them with
an arithmetic weighting. The result isthen over
laid with the cursor stream. Both blender inputs
are RGB B.B.8 from the outputs of the primary
stream interpolator and secondary stream color
STREAMS PROCESSOR 10-7

Ii·
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
10.3.3 Color/Chroma Keying 10.3.4 Window Location
These modes are items 5 and 6 in the compose The starting X,Y coordinates and window size for
modes list. Keying is a way of selecting on a pixel the primary stream are specified in MM81FO and
by pixel basis which stream will be displayed. MM81 F4 respectively. The starting X,Y coordi
Color keying is used when the stream source is nates and window size for the secondary stream
in RGB format (graphics). This is always the case are specified in MM81F8 and MM81FC respec
for the primary stream. Chroma keying is used tively.
when the stream source is YUV or YCbCr (video).
The secondary stream source can be either
10.4 STREAMS FIFO CONTROL
graphics or video, so either color or chroma key
ing might be used. If 81AO_26-24 (compose
mode) = 101b and MM8184_28 = 1, the color key The streams FIFO can be reconfigured to opti
is compared with the primary stream pixel. If mize performance for various operating modes.
there is a match, the corresponding secondary The FIFO is 24 8-byte slots deep. By program
stream pixel is displayed. If 81AO_26-24 = 110b ming MM81EC_4 -0, the FIFO can be reconfigured
and MM8184_28 = 1, the color or chroma key is to assign all 24 slots to either the primary or
compared with the secondary stream pixel. If secondary stream. Allocations of 16-8 and 12-12
there is a match, the corresponding primary slots between the two streams are also possible.
stream pixel is displayed. As an example, if only a primary stream is being
displayed, optimal performance is generated by
If the input format is KRGB-16 (1.5.5.5), selected assigning all 24 FIFO slots to the primary stream.
when MM8180_26-24 or MM8190_26_24 = 011b,
the most significant bit of each pixel value is used No matter what the allocation, FIFO thresholds
as a color key as long as MM8184_28 is cleared must be specified for the primary and secondary
to O. When the most significant pixel bit is a 0, the streams. This is done via MM81EC_16-12 for the
other stream pixel is displayed. primary stream and MM81EC_10-6 forthe secon
dary stream. When the FIFO empties to the
For other RGB input types (as specified by threshold level, an internal signal is generated
MM8180_26-24), a color key must be defined. requesting the memory controller to begin refill
This is done by programming MM8184_23-0 with ing the FIFO. The programmed threshold levels
a specific RGB 8.8.8 color value. MM8184_28 must never exceed the corresponding FIFO
must be set to 1 to enable use of this value. The depths. The optimal settings for the threshold
number of bits to compare for each color is levels will be system and operating mode de
specified in MM8184_26-24. If there is a color pendent and will have to be determined by trial
match with the keyed stream pixel, the corre and error.
sponding other stream pixel is displayed.
If the secondary stream input format is YUV or
YCbCr, the chroma key is specified as a range of
color values. The lower bound value is defined in
MM8184_23-16. The upper bound value is de
fined in MM8194_23-0. If the secondary stream
pixel color value falls within this range (inclusive
of the lower and upper bounds), the Streams
Processor displays the corresponding pixel from
the primary stream.lfthe secondary stream pixel
color is outside this range, the secondary stream
pixel is displayed.
10-8 STREAMS PROCESSOR

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 11: Local Peripheral Bus
When PD24 is strapped low at reset, the Trio64V+ the 16-to 8-bit conversion). A 16-bit data
is placed in its Local Peripheral Bus (LPB) mode. interface is available on the Trio64V+ for
The LPB mode pinout described in Section 3 PCI configurations.
takes effect when bit 0 of MMFFOO is setto 1. LPB
Host Video Data Pass-through. This al
clocking with LCLK must also be enabled by lows decimation of 32-bit CPU data be
setting bit 24 of MMFFOO to 1. The LPB function ing written to the frame buffer.)
provides the following:
• LPB Feature Connector (glueless 8-bit bi
directional or 16-bit VAFC)
• S3 Scenic Highway interface to the
Scenic/MX2 MPEG AudioNideo Decoder • 4-bit General Input Port and 4-bit Gen
(glue less, bi-directional) eral Output Port
• Scenic Highway interface to the C-Cube
The LPB mode also provides the support required
CL-480 AudioNideo Decoder (glueless
for DDC2 monitor communications. This, the fea
video input and compressed data output)
ture connector interfaces and the General In
• Scenic Highway interface to the Philips put/Output Port are described in Section 12.
video digitizers (glue logic is required to
convert 16-bit output to 8-bit Trio64V+ in The internal block diagram for the LPB is shown
put for VL-Bus configurations. However, in Figure 11-1.
the Scenic/MX2 has a glueless SAA7100
interface which can be used to provide
LPB
LPB 14--.... DATA/ADDRESS 14-78L ___~
HOST 32 REGISTERS PORT
32
TO MEMORY
INTERFACE
TO MEMORY MEMORY ADDRESS
INTERFACE GENERATION
Figure 11-1. LPB Internal Block Diagram
LOCAL PERIPHERAL BUS 11-1

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
11.1 Scenic/MX2 INTERFACE this as a write. Bit 4 is 1 for a register access and
o for a memory access. Bits 3-0 are bits 19-16 of
the address. The second byte is bits 15-8 of
The hardware interface to the Scenic/MX2 is
MMFF14 and the third byte is bits 7-0. The data
shown in Figure 11-2.
immediately follows in four byte writes. Data is
written in the opposite byte order to that for the
When the Tri064V+ is in its LPB configuration, the
address, i.e., least significant byte (bits 7-0) first
Scenic/MX2 interface is selected by setting
and most significant byte (bits 31-24) last. The
MMFFOO_3-1 to OOOb. This interface is fully bi-di
Tri064V+ then deasserts VREO/VRDY. The Host
rectional. Scenic/MX2 registers can be accessed,
repeats the above sequence for another write if
compressed data sent and decompressed video
required.
data received.
If the Scenic/MX2 is not ready to receive data, it
11.1.1 Scenic/MX2 Register/Memory drives its CREO/CRDY signal low during the AO-O
byte (LSB) of the address phase. The Tri064V+
Access
then delays sending the data until the
Scenic/MX2 raises CREO/CRDY. This is depicted
To read/write a Scenic/MX2 register or private in Figure 11-4.
memory location (other than to transfer com
pressed data), the LPB Direct Read/Write Address Figure 11-5 shows a Scenic/MX2 register/mem
register (MMFF14) is written. The new regis ory read when the Scenic/MX2 is ready to pro
ter/memory data is then written to MMFF18. For vide data. This is indicated by the Scenic/MX2
a write access, this write triggers the sequence holding the CREO/CRDY high throughout the cy
shown in Figure 11-3 if the Scenic/MX2 is ready cle. The three upper bits of the first address byte
to receive the data (CREO/CRDY remains high). are 001 to define a read.
One cycle after Tri064V+ asserts its VREO/VRDY
signal, it sends the address in three byte writes. If the Scenic/MX2 is not ready to provide data, it
The first byte is composed of bits 23-16 of drives its CREO/CRDY signal low during the ad-
MMFF14. The three upper bits are OOOb to define
Scenic/MX2 Trio64V+
...
LCLK .... LCLK
......
LD[7:0] .. ~ ..... ..... LD[7:0]
.....
VREQNRDY VREQNRDY
"""
..
CREQ/CRDY ... CREQ/CRDY
ENABLE
.........-
ENFEAT
KVCTOK
Figure 11-2. Trio64V+ to Scenic/MX2 Hardware Interface
11-2 LOCAL PERIPHERAL BUS

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
LCLK
CREQ/CROY
VREQ/VROY \~--------------------------~I
LO[7:0] --------{ 03
Figure 11-3. Scenic/MX2 Write (Scenic/MX2 Ready)
LCLK
\'--__- '1
CREQICRDY
VREQNRDY \~---------------~/
LOl7:.] _____- {
Figure 11-4. Scenic/MX2 Write (Scenic/MX2 Not Ready)
LCLK
CREQ/CROY
\'--____________________________
~r_
VREQNROY
L0[7:0] -------{
Figure 11-5. Scenic/MX2 Read (Scenic/MX2 Ready)
LCLK
\. ... ___- --'1
CREQ/CRDY
~NR~ ~L _____________________________~ r__
LD[7:01 -----........~ ~J,.~~
Figure 11-6. Scenic/MX2 Read (Scenic/MX2 Not Ready)
LOCAL PERIPHERAL BUS 11-3

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
dress phase. The Tri064V+ then waits until the (FF40H -FF5CH) is provided for this FIFO. Writes
Scenic/MX2 raises CREQJCRDYand provides reg to any ofthese addresses are directed to the FIFO.
ister data. This is depicted in Figure 11-6.
MMFFOO_17-16 are programmed to specify the
To prevent data starvation and deal with request number of doublewords of data to burst to the
contention, the following protocol is followed. Scenic/MX2. A write to the output FIFO then
initiates a compressed data write to the
• No transaction can be initiated if the bus Scenic/MX2. This is depicted in Figure 11-7 for a
is active burst count of 2 (MMFFOO_17-16 = 01b) for the
case where the Scenic/MX2 is ready to receive
• There is one dead cycle on the bus fol
the data. The address and first doubleword are
lowing all transactions
transferred exactly as for a register/memory
• One device may not initiate a transac write. Following doublewords in the burst are
tion until the second cycle following the
each separated by one dead cycle. The address
completion of a transaction initiated by
has no meaning except for the upper three bits,
the other device which are forced to 11 Ob by hardware to specify
• Neither device may initiate a transaction a compressed data transfer. Note that burst
until the third cycle following the com writes that end because the FIFO is empty (as
pletion of a transaction initiated by itself opposed to the maximum burst count being
reached) hold VREQJVRDY low for one more cy
• If CREQJCRDY and VREQJVRDY are both
cle than is shown in Figure 11-7.
driven low on the same cycle (request
contention), CREQJCRDY (the
The Scenic/MX2 cannot accept a burst larger than
Scenic/MX2) wins.
eight doublewords. If MMFFOO_17-16 are pro
grammed to 11b (burst all) and eight double
11.1.2 Scenic/MX2 Compressed Data words are loaded into the FIFO, software must
Transfer ensure that the FIFO is empty before loading
more data into the FIFO.
The Tri064V+ has an output FIFO for handling the
A compressed data transfer when the
transfer of compressed video data from the Host
Scenic/MX2 is not ready to receive data is almost
to the Scenic/MX2 (see Figure 11-1). The Host
the same as a register write for the same circum
must first check the number of empty slots
stances (see Figure 11-4). The only difference is
(MMFF04_3-0), then send no more than this
that after the Scenic/MX2 returns its CRDY signal,
many doublewords (32 bits) of compressed data
to the FIFO. An eight doubleword address range
~R~ ~L _____________________________~ r
LD[7:0) ----~~.. ~... x:::~J
Figure 11-7. Scenic/MX2 Compressed Transfer (Ready)
11-4 LOCAL PERIPHERAL BUS

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
LCLK
r
\
CREQ/CRDY
r
\
VREQ/VRDY
LD[7;O] AG-2
Figure 11-8. Scenic/MX2 Stopping a Compressed Xfer
additional doubleword packets may be burst to • The LPB is placed in Scenic/MX2 mode
the Scenic/MX2 as shown in Figure 11-7. (MMFFOO_3-1 = OOOb).
One or two frame buffer starting ad
The Scenic/MX2 can stop a compressed data dresses are defined (MMFFOC,
transfer by pulling CREO/CRDY low for one (and MMFF10). One is required. The second
only one) cycle during byte three of any double
is required for double buffering.
word. This is shown in Figure 11-8.
• The horizontal and vertical decimation
registers are programmed (MMFF2C,
An output FIFO empty interrupt can be enabled
MMFF30). This is optional.
by setting MMFF08_17 to 1. The status is read via
bit 1 of this same register. • The line stride is programmed
(MMFF34_10-0). This is not required if
HSYNCs are not being sent.
11.1.3 Scenic/MX2 Video Capture
The Tri064V+ signals its readiness to accept data
The following setup is done for Scenic/MX2 by driving VREO/VRDY high. This is done auto
video capture: matically when the Tri064V+ does not need to
LCLK
CREQ/CRDY
VSYNC HSYNC
CPVSHS
Figure 11-9. Scenic/MX2 VSVNC and HSVNC Protocols
LOCAL PERIPHERAL BUS 11-5

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
drive this signal low such as to initiate a register shown in Figure 11-10. The Tri064V+ assumes
access or to indicate an LPB video FIFO full state. data has begun any time CREO/CRDY is held low
The Scenic/MX2 responds by sending a VSYNC for more than two cycles. When the Scenic/MX2
(CREO/CRDY low for one cycle) followed by an is sending the last byte, it drives CREO/CRDY
HSYNC (CREO/CRDY low for two cycles). This is high. The Scenic/MX2 must always send data in
shown in Figure 11-9. As indicated in the figure, 4-byte packets. If it has fewer to send for the last
the time between VSYNC and HSYNC is variable. packet, it must pad the transmission with dummy
The HSYNC sequence occurs after each line, but writes to create a 4-byte packet.
may not occur before the first line, depending on
how the Scenic/MX2 is programmed. Figure 11-10 shows what happens when the
Tri064V+ is ready to receive all the data. If the
After the VSYNC/HSYNC sequence, the Tri064V+ cannot accept more data, such as when
Scenic/MX2 can pull CREO/CRDY low at anytime its LPB video FIFO is full, it drives its VREO/VRDY
and begin sending data three clocks later. This is signal low during the first byte phase of a 4-byte
LCLK
CREQ/CRDY \~--------------------~~r-----~I
SS
VREQNRDY
LD[7:01 ------------{
Figure 11-10. Scenic/MX2 Video Input (Trio64V+ Ready)
LD[7:01~
Figure 11-11. Scenic/MX2 Video Input (Trio64V+ Not Ready)
11-6 LOCAL PERIPHERAL BUS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
packet. All bytes starting with this one are re in Figure 11-12. This section describes the inter
jected by the Tri064V+ and must be resent by the face to the Philips SAA7110 digitizer.
Scenic/MX2 after the Tri064V+ drives its
VREQNRDY signal high again. This is depicted in The functional timing for converting the
Figure 11-11, where the DnO byte, which is the SAA7110 16-bit video output to the 8-bit input
first byte of the nth 4-byte packet, is rejected. required by the LPB in a VL-Bus configuration is
When the Tri064V+ can accept more data, it shown in Figure 11-13.
drives VREQNRDY high. The Scenic/MX2 drives
CREO/CRDY high (two cycles later) and then In Video 16 mode (MMFFOO_3-1 = 001b), which is
drives it low when it is ready to resend the data. available only for PCI configurations, no data
The resend of DnO and subsequent bytes starts conversion is required.
two cycles later.
As an alternative, the Scenic/MX2 provides a
When the Tri064V+ receives an HSYNC from the glueless interface to the SAA7110. In this case,
Scenic/MX2, it adds the line offset (MMFF34_10- the Scenic/MX2 handles the 16-bit to 8-bit con
0) to the previous line starting address and starts version and also provides the 12C interface to the
writing the next data at that location. In this way, SAA7110. The Tri064V+ then receives the video
for example, it can transfer 640-byte lines into a data, clock and controls from the Scenic/MX2.
frame buffer configured for 1024-byte lines. If The Scenic/MX2 documentation describes this
HSYNCs are not sent, memory will be written in interface.
a contiguous manner.
11.2.1 12C Register Interface
11.2 DIGITIZER INTERFACE
SAA7110 registers are programmed via a serial
The hardware interface to the Philips digitizer in 12C interface. This interface is described in Sec
Video 8 In mode (MMFFOO_3-1 = 010b) is shown tion 12.6.
~ Trio64V+
SAA7110 Y[7:0] .......
LD[7:0]
UV[7:0] JIIII""'"
~
LLC2
....
LLC ... LCLK
..
HS HS
..
~
VS VS
~
...
....
SDA .... ... SPD
.... ....
SCK .... ... SPCLK
KVDTOK
Figure 11-12. Trio64V+ to SAA7110 Digitizer Interface
LOCAL PERIPHERAL BUS 11-7

fl·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
LLC (27 MHZ)
| I   | \   | \  I  | \   |
| --- | --- | ----- | --- |
I  I
LLC2 (13.5 MHZ)
x=
|            | X   | X   |     |
| ---------- | --- | --- | --- |
| V[7:0) )(  | Vo  | V,  | V,  |
x=
|     | X   | X   |     |
| --- | --- | --- | --- |
UV[7:0] )(
|     | U"  | V"  | U"  |
| --- | --- | --- | --- |
=x  x=
|          | X  X    | X  X    | X       |
| -------- | ------- | ------- | ------- |
| LD[7:0]  | Vo  U"  | V,  V"  | V,  U"  |
Figure 11-13. 16-to 8-bit Video Data Conversion
11.2.2 SAA7110 Video Input  •  The correct vertical and horizontal sync
polarities are specified (MMFFOO_9, 10).
The following setup is done for SAA7110 video  •  One or two frame buffer starting ad
dresses are defined (MMFFOC,
input:
MMFF10). One is required. The second
•  The Trio64V+ is placed in Video 8 In  is required for double buffering.
mode (MMFFOO_3-1 = 010) or Video 16
•  The horizontal and vertical decimation
mode (MMFFOO_3-1 = 001b) for PCI con  registers are programmed (MMFF2C,
| figurations.  |     | MMFF30). This is optional.  |     |
| ------------- | --- | --------------------------- | --- |
•  Byte swapping is disabled by setting  •  The video input window size (height in
MMFFOO_6 to 1.
lines and width in pixels) is pro
grammed in MMFF24.
| I   | L..ss  |     |     |
| --- | ------ | --- | --- |
VS
SS
1- IL
HS
~~m
.~
...
LD[7:OI
Figure 11·14. Video 81n or 16 Mode Input
11-8  LOCAL PERIPHERAL BUS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
• The video data horizontal and vertical the same as for the SAA7110 and is shown in
offsets are programmed in MMFF28. Figure 11-12.
• The line offset (stride) is programmed
(MMFF34_10-0). In Video 8 In/Out mode (MMFFOO_3-1 = 011b),
compressed data is sent to the CL-480 from the
Tri064V+ and video data is returned to the
The SAA7110 then sends video data as shown in
Figure 11-14. In this figure, both VSYNC (VS) and Tri064V+. This interface is shown in Figure 11-15.
Functional timing for the compressed data trans
HSYNC (HS) have active high polarity. The verti
fer is given in the CL-480 data book.
cal offset (MMFF28_24-16) is 1, meaning the first
line is skipped. The horizontal offset HO
The following pseudocode shows how to write
(MMFF28_11-0) is 1, meaning that the first data
the CL-480 program counter register (3AH) with
starts one clock after the second HS goes low. HS
5A5AH. The CL-480 requires that register writes
goes high again some time after the last byte of
be done as a sequence of 3 address writes fol
the line, whose position is specified by the line
width (LW) programmed in MMFF24 11-0. The lowed by two data writes. The upper byte of the
widths ofthe VS and HS pulses shown-may vary. address must have 10b in bits 7-6 for register
writes and the register address (3AH in this case)
in bits 5-0. The complete address is then
Alternate frames of the video input can be dis
carded (not written to memory) by setting bit 5 BAOOOOH, sent as OOH, OOH, BAH.
of MMFFOO to 1.
wr FF14 OlH; address byte 0
wr FF18 OOH: byte 0 data
11.3 CL-480 INTERFACE wr FFl4 02H; address byte 1
wr FFl8 OOH; byte 1 data
wr FF14 03H; address byte 2
The CL-480 can be interfaced in two ways. In
wr FF18 BAH; byte 2 data
Video 8 In mode (MMFFOO_3-1 = 010b) the inter
wr FF14 04H; data byte 0
face is similar to the SAA7110 interface except
wr FF18 5AH; byte 0 data
that the CL-480 outputs 8 bits of data and pro
wr FF14 05H; data byte 1
gra~ming ofthe CL-480 is done via the host bus,
wr FF18 5AH; byte 1 data
not I C. Therefore, only LD[7:0), HS, VS and LCLK
<;Ire connected. This is shown by the top set of
signals in Figure 11-15. The functional timing is
Trio64V+ CL-480
LO[6:2] L"'L VO[3:7]
....
LO[1:0] VO[14:1S]
....
L07 V016
HS .~ HSYNC
....
VS VSYNC
....
LCLK VCLK
HO[7:0] ...oL HO[7:0]
HSEL[2:0] HSEL[2:0]
OS OS
RIW RIW
1..0"-
OTACK OTACK
i...L
CFLEVEL CFLEVEL
Cl480IF
Figure 11-15. Video 81n or 16 Mode Input
LOCAL PERIPHERAL BUS 11-9

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
To read the value programmed above, use the Pass-through is not supported if big-endian ad
same sequence except read the data bytes in- dressing is being used.
stead of writing them.
11.5 LPB-ENABLED PIN
wr FF14 OlH; address byte 0
wr FF18 OOH: byte 0 data ASSIGNMENTS
wr FF14 02H; address byte 1
wr FF18 OOH; byte 1 data The pin assignments when the various LPB
wr FF14 03H; address byte 2 modes are enabled are shown in Table 11-1. Note
wr FF18 BAH; byte 2 data that some functions are available only in PCI
wr FF14 04H; data byte 0 configurations. These have (PCI) next to the pin
rd FF18 returns S number.
wr FF14 OSH; data byte 1
rd FF18 returns 2H
Note that the last read returns 2 instead of the A
originally written. The reason is that the 3AH
register is physically 10 bits wide. Therefore, only
the lower 2 bits of the upper nibble are actually
written. For a value of AH, these are 10b, or 2
decimal. Functional timing for register accesses
is given in the CL-480 data book.
11.4 HOST PASS-THROUGH
When pass-through mode is enabled
(MMFFOO_3-1 = 100b), the CPU can write 32-bit
data to the output FIFO and have this data passed
directly to the decimation block (bypassing the
LPB bus). The data are sent exactly as for com
pressed video data to an MPEG decoder. The
data will then be decimated according to the
programming of MMFF2C (horizontal) and
MMFF30 (vertical) and then passed to the video
FIFO to be written to display memory. This path
is shown in Figure 11-1.
When the Host sends an HSYNC (MMFFOO_12 =
1) or VSYNC (MMFFOO_11), the decimation reg
isters are re-Ioaded. Therefore, the Host must
ensure that at least 5 clocks pass between the
sync and the start of data to allow time for this
reloading.
When pass-through is used in LPB mode, bit 24
of MMFFOO provides the option of using SCLK to
clock the LPB function.
Host pass-through can be used in Tri064-compat
ible mode (PD24 strapped high at reset). The LPB
must be enabled (bit 0 of MMFFOO set to 1) and
clocked by SCLK (bit 24 of MMFFOO set to 1).
11-10 LOCAL PERIPHERAL BUS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table 11-1.  LPB-Enabled Pin Assignments
Video 16 or 81n
|           | Scenic/MX2        | MMFFOO_3-1 = 001  | Video 8 In/Out    |
| --------- | ----------------- | ----------------- | ----------------- |
| Pin #     | MMFFOO 3-1 = 000  | MMFFOO 3-1 = 010  | MMFFOO 3-1 = 011  |
| 146       | LDO               | LDO               | LDO               |
| 147       | LD1               | LD1               | LD1               |
| 148       | LCLK              | LCLK              | LCLK              |
| 154       | LD2               | LD2               | LD2               |
| 155       | LD3               | LD3               | LD3               |
| 174       | LD4               | LD4               | LD4               |
| 175       | LD5               | LD5               | LD5               |
| 176(PCI)  | NO FUNCTION       | NO FUNCTION       | HSEL2             |
| 177(PCI)  | NO FUNCTION       | NO FUNCTION       | HSEL1             |
| 178(PCI)  | NO FUNCTION       | NO FUNCTION       | HSELO             |
179(PCI)
|           | NO FUNCTION  | NO FUNCTION  | DS     |
| --------- | ------------ | ------------ | ------ |
| 180(PCI)  | NO FUNCTION  | NO FUNCTION  | RMJ    |
| 181(PCI)  | NO FUNCTION  | NO FUNCTION  | DTACK  |
182(PCI)
|            | NO FUNCTION  | NO FUNCTION    | CFLEVEL  |
| ---------- | ------------ | -------------- | -------- |
| 184        | LD6          | LD6            | LD6      |
| 185 (PCI)  | NO FUNCTION  | LD8 (Video 8)  | HDO      |
| 186 (PCI)  |              | LD9 (Video 8)  | HD1      |
NO FUNCTION
| 187 (PCI)  | NO FUNCTION  | LD10 (Video 8)  | HD2  |
| ---------- | ------------ | --------------- | ---- |
| 188 (PCI)  | NO FUNCTION  | LD11 (Video 8)  | HD3  |
189 (PCI)
|            | NO FUNCTION  | LD 12 (Video 8)  | HD4  |
| ---------- | ------------ | ---------------- | ---- |
| 199 (PCI)  | NO FUNCTION  | LD13 (Video 8)   | HD5  |
| 200 (PCI)  | NO FUNCTION  | LD14 (Video 8)   | HD6  |
201 (pCI)
|      | NO FUNCTION  | LD15 (Video 8)  | HD7          |
| ---- | ------------ | --------------- | ------------ |
| 202  | LD7          | LD7             | LD7          |
| 203  | VREQNRDY     | HS              | NO FUNCTION  |
204
|     | CREO/CRDY  | VS  | NO FUNCTION  |
| --- | ---------- | --- | ------------ |
LOCAL PERIPHERAL BUS 11-11

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 12: Miscellaneous Functions
This section explains how the Tri064V+ inter strapping bit 4 (CR36, bit 4) must be pulled low
faces to the video BIOS ROM and feature connec to disable BIOS accesses. For this configuration,
tor. Green PC support, the General I/O Ports, the ROMCS is not required. Bits 1-0 of SR1C can be
serial communications port and interrupt genera set to 11, making pin 153 function as a second
tion are also described. General Output Port bit instead of as ROMCS. For
PCI configurations, bit 0 of the BIOS ROM Base
Address register (Index 30H) is cleared to 0 to
12.1 VIDEO BIOS ROM INTERFACE
disable BIOS accesses.
The video BIOS ROM contains power-on initiali
12.1.2 BIOS ROM Hardware Interface
zation, mode setup, and video data read/write
routines. The video BIOS can be part of the sys
tem ROM or it can be implemented separately. A separate implementation of the video BIOS for
a PCI configuration is shown in Figure 12-1. The
GD[7:0] and GA[15:0] signals are mUltiplexed on
12.1.1 Disabling BIOS ROM Accesses
PD pins. Therefore, the BIOS ROM must be shad
owed immediately after reset and BIOS access
If the video BIOS is integrated with the system disabled to prevent interference with graphics
BIOS in a VL-Bus configuration, then power-on operation.
Trio64V+ BIOS ROM
GO[7:0] 0[7:0]
GA[15:0] A[15:0]
ROMEN OE
I
CE
TVPCIROM
Figure 12-1. BIOS ROM PCI Configuration Interface
MISCELLANEOUS FUNCTIONS 12-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
VESA
LOCAL BUS
'" :..
SA[31:2]
Trio64V+
ADDRESS
BIOS ROMCS
ROM
0[7:0]
, IECE
r OE~
,.. 74ALS244 OE1
'"i
<A SA115:01 SMEMR ....
ISABUS TVlROMIF
~ '"
Figure 12-2. BIOS ROM VL-Bus Configuration Interface
The implementation for a VL-Bus configuration 32-bit read, the Tri064V+ automatically incre
is shown in Figure 12-2. The ROM is accessed via ments the lower address three times and gener
the ISA bus. This allows a shadowed BIOS to be ates the remaining three bytes of read data. In
accessed by a CPU memory read without also both cases, TRDY is delayed until all the required
generating data directly from the physical ROM. data is available on the AD bus. For 16-,24-or 32-
Only 8-bit ROMs are supported. bit accesses, the ROM access time must be 10
SCLKs or less, as opposed tothe 14 SCLKs shown
in Figure 12.3 for an 8-bit access.
12.1.3 BIOS ROM Read Functional
Timing For a VL-Bus configuration, a BIOS ROM read is
a standard ISA bus read cycle with the Tri064V+
Figure 12-3 depicts the PCI configuration func providing its ROMCS output as the ROM chip and
tional timing for reading one byte from the ROM. buffer enable (see Figure 12-2). ROMCS is as
ROMEN is asserted to drive the byte of read data serted during the time the ROM address is valid
at the address on GA[15:0] to the General Data and therefore will be active when the chipset
Bus. The Tri064V+ latches the data one clock asserts the ISA SMEMR signal.
before deassertion of ROMEN and then drives
this data onto the AD bus. 12.1.4 BIOS ROM Address Mapping
The Tri064V+ also supports 16-and 32-bit ROM
reads, as defi ned by the states of the byte en The Tri064V+ maps the CPU memory address
ables. For a 16-bit read, the Tri064V+ automat spaces for the video BIOS ROM into physical
ically increments the lower address once and ROM addresses. If implemented separately for a
generates the second byte of read data. For a VL-Bus system, the video BIOS normally uses the
12-2 MISCELLANEOUS FUNCTIONS

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
~
c
::;;
o
II:
z
:!i
~
..J
e(n)
.......
0
w
II  Ii  s   s
| ~                   | .?. .   I~  I~  | . ;;    |
| ------------------- | --------------- | ------- |
| . (e . J )      I~  |                 | I S     |
| n                   | ! '2            | c       |
|                     | C               | ~   Cl  |
|                     | <C              | Cl      |
Figure 12-3. BIOS ROM Read Functional Timing -PCI
MISCELLANEOUS FUNCTIONS  12-3

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
standard address range COOOOH-C7FFFH (32 function. The following steps are required to
KBytes). If power-on strapping bit 10 (CR37, bit 2) implement it.
is strapped low or if bit 2 of CR37 is cleared to 0
in a VL-Bus system, the video BIOS address range 1. Disable all other LPB uses.
becomes COOOOH-CFFFFH (64 KBytes). PCI sys
2. Enable driving of the desired input data
tems support a relocatable 64-KByte video BIOS onto LD[7:4).
address range via the BIOS ROM Base Address
3. If the LPB General Output Port function is
configuration register (Index 30H).
also in use, ensure that the correct output
data is programmed in MMFF1C_3-0.
12.2 GREEN PC SUPPORT
4. Program SR1C_1-0 to 01b.
5. Write (anything) to CR5C. The data on
The Tri064V+ provides support for the VESA Dis
LD[7:4) are latched 2 DCLKs later into
play Power Management Signaling (DPMS) pro
MMFF1C_7-4. (This also drives the con
tocol by allowing independent control of the
tents of MMFF1C_3-0 onto LD[3:0) and
HSYNC and VSYNC signals. To use this capabil
generates the STWR pulse on pin 190. The
ity, the bit pattern xxxx0110b must be written to
input data is latched on the rising edge of
the SR8 register to unlock access to the SRD
STWR. See Figure 12-6)
register. Bits 5-4 of SRD then control the state of
6. Disable driving of input data onto LD[7:4).
HSYNC and bits 7-6 of SRD control the state of
VSYNC.
The Tri064V+ provides an 8-bit GIP for VL-Bus
configurations. The block diagram this configu
Driving pin 165 (PDOWN) low turns off the RGB
ration is shown in Figure 12-4. The following
analog outputs of the internal DACs.
steps implement the GIP function.
12.3 GENERAL INPUT PORT 1. Set bit 2 of CR55 to 1 to enable the GIP
read function.
The Tri064V+ provides a 4-bit General Input Port 2. Program SR1 C_1-0 to 01 b to enable output
(GIP) for PCI configurations as part of its LPB of GPIOSTR on pin 151.
VE5A
LOCAL BU5
./"'~
50[31:0]
50[7:0]
Trio64V+
Q[7:0]
GENERAL
INPUT OE 1--
PORT
BUFFER GPI05TR
I
0[7:0]
OEM
DEFINABLE
.... 7- DATA TVVLGIP
Figure 12·4. General Input Port Interface (VL·Bus)
12-4 MISCELLANEOUS FUNCTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
T1 T2 T3 T4 T5 T6 T7
5CLK
GPI05TR \ /
'--._ _____- J
---,'fItI&
~~
50[7:0] _____________
VGIPVL
Figure 12-5. General Input Port Timing (VL-Bus)
3. The data is read from an external buffer by 12.4 GENERAL OUTPUT PORT
a read of port 3C8H (the same as the DAC
Write Index off-chip register).
The Tri064V+ provides a 4-bit General Output
Port (GOP) for PCI configurations as part of its
When GPIOSTR is asserted, the data is immedi
LPB function. To implement this:
ately placed on SD[7:0]. The functional timing for
this operation is shown in Figure 12-5. The entire
1. Disable all other LPB uses.
cycle from assertion of SADS to data being avail
able on SD[7:0] takes approximately 18-20 2. Programmed the desired output in
SCLKs. MMFF1C_ 4-0.
4. Program SR1C_1-0 to 01 b to enable output
of STWR on pin 190.
5. Write (anything) to CR5C. The data in
MMFF1C_3-0 are immediately driven onto
T1 T2 T3
DCLK
..,F
STWR ,'--______ LATCH
-m
'fllt.
LD[3:0]
.....- --------.... VLPBGOP
Figure 12-6. General 1/0 Port Timing (PCI)
MISCELLANEOUS FUNCTIONS 12-5

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
LD[3:0] and the STWR pulse is generated. pin 190. These pin will continue to reflect
The rising edge of STWR (2 DCLKs after it the register bit states as long as SR1C_1
is asserted) can be used to latch the data =1. The values in CR5C_1-0 can be repro
into an external device. The data is held grammed at any time.
valid for 1/2 DCLK after this edge. See Fig
ure 12-6. The Tri064V+ provides an 8-bit GOP for VL-Bus
configurations. The block diagram this configu
The Tri064V+ also provides a 2-bit GOP on dedi ration is shown in Figure 12-7. Whatever is pro
cated pins for PCI configurations. To implement grammed to CR5C_7-0 is immediately provided
this: to the latch via SD[15:8]. The functional timing for
this is shown in Figure 12-8. Note that the data
1. SetSR1C_1 to 1. can be latched on eitherthe rising or falling edge
of GPIOSTR. The entire cycle from assertion of
2. Program the desired output in CR5C_1-0.
SADS to latching of data in the GOP buffer takes
This statically drives the state of CR5C_0
approximately 6-8 SCLKs.
onto pin 151 and the state of CR5C_1 onto
VESA
LOCALBU5
Po.
1-___. .._ ____
~ 5 0 [ 3 1 : 0 )
50[15:8)
Trio64V+
0[7:0)
GENERAL
OUTPUT
PORT
LATCH Gl GPI05TR
I
Q[7:0)
I
Vii'" "'''''''
Figure 12-7. General Output Port Interface (VL-Bus)
T1 T2 T3 T4 T5
DCLK
\ I
STWR
'f1li&
SD[7:0]~
VGOP'Il
Figure 12-8. General Output Port Timing (VL-Bus)
12-6 MISCELLANEOUS FUNCTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
If both an 8-bit GIP and an 8-bit GOP are required, Table 12-1 Trio64-compatible Feature
the GPIOSTR enable input must be qualified with Connector Configuration
the SR/W signal. Additional discrete logic is re
quired to ensure that only the GOP latch is en
abled for writes and only the GIP buffer is Pin(s) Sianals
enabled for reads.
144,142,140,138,134,132, VFCPA[15:0)
130, 128, 127, 129, 131, 133,
The Tri064V+ also provides a 2-bit GOP on dedi
136,139,141,143
cated pins for VL-Bus configurations. To imple
ment this: 151 VFCENFEAT
115 VFCBLANK
1. Set SR 1C _ 1-0 to 11 b. 117 VFCVCLK
2. Program the desired output in CR5C_1-0. 106 VFCVCLKI
This statically drives the state of CR5C_0 109 VFCESYNC
onto pin 151 and the state of CR5C_1 onto
111 VFCEVIOEO
pin 153. These pin will continue to reflect
the register bit states as long as SR1C_1-0 113 VFCEVCLK
=11 b. The values in CR5C_1-0 can be re 149 HSYNC
programmed at any time. 150 VSYNC
The 2-bit GOP is only useful for cases where the This configuration provides an interface to either
video BIOS is part of the system BIOS (mother a baseline VESA Advanced Feature Connector
board implementations) and the ROMCS signal (VAFC) or pass-through bidirectional feature con
is not needed. If ROMCS is required, a 1-bit GOP nector. In all cases, SRO_O must be set to 1 to
is available by programming SR1C_1-0 to 10b. enable feature connector operation and SR1C_1-
Whatever is programmed to CR5C_0 is reflected o must be OOb to enable ENFEAT on pin 151.
on pin 151.
For a VAFC implementation, VFCESYNC and
When a VL-Bus configuration powers up with a EVFCVCLK are pulled up. This means that
default value ofOObfor bits 1-0, both pin 151 and HSYNC, VSYNC, VFCBLANK and VFCVCLK are
pin 153 will be driven high (logic 1). Pins 151 and always outputs to the feature connector. Pixel
190 are driven high on power-up for PCI configu address data (PA[15:0) is an output from the
rations. Thus, external devices with active low Tri064V+ if VFCEVIOEO is high and is an input to
enables will not be enabled when connected to the Tri064V+ if VFCEVIOEO is low. If bit 1 of SRB
these pins. is set to 1, pixel data input is strobed into the
internal RAMOAC by VFCVCLKI.
12.5 FEATURE CONNECTOR
Figure 12-9 shows a VAFC implementation for a
INTERFACE
32-bit PO bus implementation (this is used for 1
MByte of video memory). No glue logic is re
The Tri064V+ provides two approaches to inter quired because the multiplexed pins are not re
facing with a feature connector. If SRO_1 is quired for PO operation.
cleared to 0, this selects Tri064-compatible fea
ture connector operation. This means that some Figure 12-10 shows the VAFC implementation for
of the feature connector signals are multiplexed 64-bit PO bus designs. The additional buffers are
on upper PO lines. The pins used to provide this required to isolate the PO bus from the feature
type of operation are listed in Table 12-1. connector during 64-bit operation. This means
that memory size will be at least 2 MBytes. Set
ting bit 0 of SRO to 1 drives the ENFEAT pin low,
enabling the isolation buffers. Note that the
Tri064V+ always uses a 32-bit PO bus when fea
ture connector operation is enabled and that the
speed of the interface (VFCVCLK/OCLK) is limited
MISCELLANEOUS FUNCTIONS 12-7

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Trio64V+ VAFC
(32-BIT PO BUS)
• •
PA[15:0] PA[15:0]
ENFEAT N/C
VCLKI VCLK
VCLK OCLK
HSYNC HSYNC
VSYNC VSYNC
BLANK BLANK
EVIOEO EVIOEO
ESYNC GROY
EVCLK
+5V
+5V +5V
+5V
TVVAFCl
Figure 12-9, VAFC Implementation (32-bit PO Bus)
'245
Trio64V+ VAFC
(64-BIT PO BUS)
•
PA[15:0] PA[15:0]
ENFEAT
VCLKI VCLK
VCLK OCLK
HSYNC HSYNC
VSYNC VSYNC
BLANK BLANK
EVIDEO EVIOEO
ESYNC GROY
EVCLK
+5V
TVVAFC2
Figure 12-10, VAFC Implementation (64-bit PO Bus)
12-8 MISCELLANEOUS FUNCTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Trio64V+
PASS-
(32-BIT PO BUS)
THROUGH
|          |     |     |          | •   | •   |
| -------- | --- | --- | -------- | --- | --- |
| PA[7:0]  |     |     | PA[7:0]  |     |     |
|          | ~   |     | ~        |     |     |
..
| ENFEAT  | . .  N/C  |     |       |     |     |
| ------- | --------- | --- | ----- | --- | --- |
|         | f - ---   |     | ..    |     |     |
| VCLK    | ..        |     | VCLK  | ~   |     |
..
..
| HSYNC  |     |     | ..  HSYNC  | ~   | ~   |
| ------ | --- | --- | ---------- | --- | --- |
..
| VSYNC  | ..  |     |            |     |     |
| ------ | --- | --- | ---------- | --- | --- |
|        |     |     | ..  VSYNC  | ~   |     |
..
..
| BLANK  |     |     | BLANK  | ~   | ~   |
| ------ | --- | --- | ------ | --- | --- |
......
| EVIOEO  |     |     | EVIOEO  | ....  |     |
| ------- | --- | --- | ------- | ----- | --- |
| ESYNC   |     |     | ESYNC   | ....  |     |
....
| EVCLK  |     |     | EVCLK  |     |     |
| ------ | --- | --- | ------ | --- | --- |
TPASCON1
Figure 12-11. Pass-Thru Feature Connector (32-bit PO)
| Trio64V+         |     |     | PASS-    |     |     |
| ---------------- | --- | --- | -------- | --- | --- |
| (64-BIT PO BUS)  |     |     | THROUGH  |     |     |
|                  |     |     |          | •   | •   |
~
| PA[7:0]  |     | '245  | PA[7:0]  |     |     |
| -------- | --- | ----- | -------- | --- | --- |
-
ENFEAT
G
..
|     |     | DIR  | ..  |     |     |
| --- | --- | ---- | --- | --- | --- |
'--
| VCLK   | ...  |     | ..  VCLK   | ~   | ~   |
| ------ | ---- | --- | ---------- | --- | --- |
| HSYNC  | ...  |     | ..  HSYNC  | ~   | ~   |
....
VSYNC
|     | ...  |     | VSYNC  |     | ~   |
| --- | ---- | --- | ------ | --- | --- |
...
......
| BLANK  | ..  |     | BLANK  |     | ~   |
| ------ | --- | --- | ------ | --- | --- |
§1
| EVIDEO  | ..  |     | EVIDEO  | ......   |     |
| ------- | --- | --- | ------- | -------- | --- |
~
| ESYNC  | ..  |     | ESYNC  |     |     |
| ------ | --- | --- | ------ | --- | --- |
...
~
| EVCLK  |     |     | EVCLK  |     |     |
| ------ | --- | --- | ------ | --- | --- |
"'
|     | ,   | ,   |     | TPASCON2  |     |
| --- | --- | --- | --- | --------- | --- |
125 s
Figure 12-12. Pass-Thru Feature Connector (64-bit PO)
|     |     |     | MISCELLANEOUS FUNCTIONS  |     | 12-9  |
| --- | --- | --- | ------------------------ | --- | ----- |

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
to 37.5 MHz. See the VESA VAFC specification for  tion) and can use the full 64-bit PO bus for 2-or
further description and timing specifications.  4-MByte memory configurations.
Figure 12-11  shows a bidirectional 8-bit pass  Table 12-2  LPB Feature Connector
through feature connector implementation for  Configuration (VL-Bus)
the Tri064V+ configured for 32-bit PO bus opera
tion (1 MByte of video memory). When the fea
ture connector function is enabled by setting bit
| o   |     | Pin(s)  | Signals  |
| --- | --- | ------- | -------- |
of SRO to 1, the direction of the pixel data is
|     |     | 202,184,175,174,155,154,  | PA[7:0]  |
| --- | --- | ------------------------- | -------- |
controlled by the polarity of the VFCEVIOEO sig
147, 146
nal. If VFCEVIOEO is low, pixel data is an input to
|     |     | 151  | ENFEAT  |
| --- | --- | ---- | ------- |
the Tri064V+. If VFCEVIOEO is high, the Tri064V+
| outputs pixel data to the feature connector.  |                          | 206  | BLANK   |
| --------------------------------------------- | ------------------------ | ---- | ------- |
|                                               |                          | 148  | VCLK    |
| If VFCESYNC is low, HSYNC, VSYNC              |                          | and  |         |
|                                               |                          | 183  | ESYNC   |
| VFCBLANK are                                  | inputs to the Tri064V+.  | If   |         |
|                                               |                          | 203  | EVIOEO  |
VFCESYNC is high, these three signals are out
|     |     | 204  | EVCLK  |
| --- | --- | ---- | ------ |
puts. If VFCEVCLK is low, VFCVCLK is an input to
the Tri064V+ and is used to clock the pixel data  149  HSYNC
| to the internal RAMOAC. If VFCEVCLK is high,  |     | 150  | VSYNC  |
| --------------------------------------------- | --- | ---- | ------ |
VFCVCLK is an output.
LPB feature connector operation provides a 16-
The Tri064V+ memory configurations of 2 MBy
bit bi-directional feature connector for PCI con
tes and larger will use the entire 64-bit PO bus. In
figurations. The pins used to provide this type of
these cases, VFCEVIOEO, VFCESYNC, VFCEVCLK  operation are listed in Table 12-3. The interface
and PA[7:0] are multiplexed with some of the  is the same as shown in Figure 12-9. However,
upper 32 PO lines. The buffers shown in Figure  the Tri064V+ is not restricted to 32-bit PO bus
12-12 prevent the PO lines from being driven by
operation (as with the Tri064-compatible opera
the feature connector during 64-bit PO bus opera
tion) and can use the full 64-bit PO bus for 2-or
tion. As with the VAFC connector, the Tri064V+
4-MByte memory configurations.
uses a 32-bit PO bus during feature connector
| operations.  |     | Table 12-3  LPB Feature Connector  |     |
| ------------ | --- | ---------------------------------- | --- |
Configuration (PCI)
Setting SRO_1 to 1 selects LPB feature connector
operation. This configuration provides an inter
face to either a baseline VESA Advanced Feature
|     |     | Pin(s)  | Signals  |
| --- | --- | ------- | -------- |
Connector (VAFC) or pass-through bidirectional
feature connector. In all cases, SRO_O must be set  201-199,189-185,202,184,  PA[15:0]
to 1 to enable feature connector operation and  175,174,155,154,147,146
| SR1C_1-0 must be OOb to enable ENFEAT on pin  |     | 151  | ENFEAT  |
| --------------------------------------------- | --- | ---- | ------- |
151.ln addition, LPB operation must be disabled,  206  BLANK
(MMFFOO_O = 0) and Streams Processor opera
| tion must be disabled (CR67 _3-2 = OOb) before  |     | 148  | VCLK    |
| ----------------------------------------------- | --- | ---- | ------- |
| feature connector operation is enabled.         |     | 196  | VCLKI   |
|                                                 |     | 183  | ESYNC   |
| LPB feature connector operation provides an 8-  |     | 203  | EVIOEO  |
bit bi-directional feature connector for VL-Bus
|     |     | 204  | EVCLK  |
| --- | --- | ---- | ------ |
configurations. The pins used to provide this type
|     |     | 149  | HSYNC  |
| --- | --- | ---- | ------ |
of operation are listed in Table 12-2. The interface
|     |     | 150  | VSYNC  |
| --- | --- | ---- | ------ |
is the same as shown in Figure 12-11. However,
the Tri064V+ is not restricted to 32-bit PO bus
operation (as with the Tri064-compatible opera- 8-bitfeature connector operation is also available
for PCI configurations.
12-10  MISCELLANEOUS FUNCTIONS

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
12.6 SERIAL COMMUNICATIONS For PCI LPB configurations, SPCLK and SPD are
not multiplexed. This reduces the isolation re
PORT
quirements.
A serial communications port is implemented in If PD26 is strapped low at reset, strapping of PD25
the MMFF20 register. Bit 4 is set to 1 to enable selects either E2H (PD25 pulled high) or E8H
the interface. The clock is written to bit 0 (= 0) and (PD25 pulled low) as the I/O port address for the
data to bit 1 (= 0), driving the SPCLK and SPD pins serial port register MMFF20. This allows the ports
low respectively. The state of the SPCLK pin can to be used for serial communications, typically
be read via bit 2 and the state of the SPD pin can 12C, when the Tri064V+ in not enabled. If analog
be read via bit 3. The SPCLK and SPD pins are switches are used for isolation as explained in the
tri-stated when their corresponding control bits previous paragraph, designers must ensure that
are reset to 0, allowing other devices to drive the the 12C function is enabled by default on reset. If
serial bus. I/O access is desired after the Tri064V+ has been
enabled and then disabled, programmers must
Typical uses for the serial port are for DDC moni ensure that the 12C function is selected before the
tor communications and 12C interfacing. When Tri064V+ is disabled because the General Output
SPCLK and SPD are tri-stated, the Tri064V+ can Port may not be available to change the selection.
detect an 12C start condition (SPD driven low
while SPCLK is not driven low). This condition is
generated by another 12C master that wants con 12.7 INTERRUPT GENERATION
trol of the 12C bus. If bit 19 of MMFF08 is set to 1,
detection of a start condition generates an inter For a PCI configuration, pin 152 is pulled low to
rupt and sets bit 3 of MMFF08 to 1. If bit 24 of signal an interrupt (lNTA). For a VL-Bus configu
MMFF08 is set to 1, the Tri064V+ drives SPCLK ration, pin 152 is pulled high to signal an interrupt
low to generate 12C wait states until the Host can (SINTR).
clear the interrupt and service the 12C bus.
Whatever the mode of operation (VGA or En
The SPCLK and SPD signals are mUltiplexed with hanced), bit 4 of CR32 must be set to 1 to enable
the ESYNC and BLANK feature connector signals interrupt generation.
on pins 205 and 206 for VL-Bus configurations. If
DDC, 12C and/or feature connector operation are When the Tri064V+ is being operated in VGA
required, the lines from pins 205 and 206 must mode (CR67 _0 = 0), only a vertical retrace can
be multiplexed to separate pairs of lines for each generate an interrupt. This is enabled when bit 5
operation to provide the necessary signal isola of CR11 is cleared to 0 and a 1 has been pro
tion. The ENFEAT signal should be used to en grammed into bit 4 of CR11. When an interrupt
able ESYNC and BLANK onto one pair of lines to occurs, it is cleared by writing a 0 to bit 4 of CR11.
the feature connector. When ENFEAT is high, one The interrupt must then be re-enabled by writing
bit of the General Output Port can be used to a 1 to the same bit. Note that the BIOS clears both
select between 12C and DDC operation, with a 1 bit 4 and bit 5 of CR11 to 0 during power-on, a
enabling output on one pair of lines and a 0 mode set or a reset. Thus, interrupt generation is
enabling output on another. disabled until bit 4 is set to 1.
The National Semiconductor CD4052B Dual 4- When the Tri064V+ is being operated in En
Channel Analog Multiplexer/Demultiplexer pro hanced mode (CR67 _0 = 1), interrupts can be
vides the capability to channel two lines to one generated by a vertical retrace, Graphics Engine
of four pairs of lines based on two select signals. busy, command FIFO overflow and command
Each side can act as either an input or output. A FIFO empty. These interrupts are enabled and
set of schematics showing the use of this part is cleared and their status reported via 42E8H.
available.
Multiple interrupts can be enabled at the same
time in Enhanced mode. The interrupt pin will
MISCELLANEOUS FUNCTIONS 12-11

....
r Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
remain asserted until all interrupt status bits are
cleared.
12-12 MISCELLANEOUS FUNCTIONS

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Section 13: Basic Software Functions
This section describes the basic operations required to program the Trio64V+.
13.1  CHIP WAKEUP
The following program wakes up the Trio64V+. This is required for systems that do not use the S3 style
of video BIOS, e.g., UNIX.
| mov dX,3c3h   | Video Subsystem Enable register address  |                         |          |         |
| ------------- | ---------------------------------------- | ----------------------- | -------- | ------- |
| mov aI, 01h   | bit a =                                  | 1,  enable VGA          | display  |         |
| out dX,al     | write new bit values                     |                         | to 3c3h  |         |
| [load CRTCs]  | program CRTC                             | registers               |          |         |
| mov dX,3C6h   | DAC  Mask register address               |                         |          |         |
| mov al,FFh    | DAC  Mask register initialization value  |                         |          |         |
| out dX,al     | Initialize DAC                           | mask and release BLANK  |          | signal  |
BASIC SOFTWARE FUNCTIONS  13·1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
13.2 REGISTER ACCESS
13.2.1  Unlocking the S3 Registers
The S3 registers (CR30 and higher plus the Enhanced Commands registers) must be unlocked before
they can be accessed by the CPU. The code to do this is:
Note: Byte operations are used in the following examples for clarity. Word operations, e.g .. ,
mov ax, 4838h
out dX,ax
should be used for efficiency instead of the operations used in the first example below.
Write code to CR38  to provide access to the S3  VGA  registers  (CR30-CR3F)
| mov dx,3d4h  | copy index register address    | into dx                  |     |
| ------------ | ------------------------------ | ------------------------ | --- |
| moval,38h    | copy index for CR38            | register into al         |     |
| out dX,al    | write index to index register  |                          |     |
| inc dx       | increment dx to 3D5h           | (data register address)  |     |
moval,48h  copy unlocking code  (OlxxlOxxb,  x=don't care)  to al
| out dX,al  | write the unlocking code            | to the data register  |        |
| ---------- | ----------------------------------- | --------------------- | ------ |
| dec dx     | restore the index register address  |                       | to dx  |
Write code to CR39  to provide access to the System Control and System Extension
registers  (CR40-CRFF)
dx  is already loaded with 3D4h because of the previous  instruction
| mov al,39h  | copy index for CR39            | register into al         |     |
| ----------- | ------------------------------ | ------------------------ | --- |
| out dx,al   | write index to index register  |                          |     |
| inc dx      | increment dx to 3D5h           | (data register address)  |     |
mov al,Oa5h  copy unlocking code  to al  (the code a5H also unlocks
|            | access  to configuration registers CR36,  |                       | CR37  and CR68  |
| ---------- | ----------------------------------------- | --------------------- | --------------- |
| out dX,al  | write the unlocking code                  | to the data register  |                 |
| dec dx     | restore the index register address to dx  |                       |                 |
Set bit 0  in CR40  to enable access to the Enhanced Commands  registers.
dx is already loaded with 3D4h because of previous  instruction
| moval,40h  | copy index for CR40            | register into al         |     |
| ---------- | ------------------------------ | ------------------------ | --- |
| out dx,al  | write index to index register  |                          |     |
| inc dx     | increment dx to 3D5h           | (data register address)  |     |
in al,dx  read register data for read/modify/write operation
| or al,l    | set bit 0  to 1                           |                       |     |
| ---------- | ----------------------------------------- | --------------------- | --- |
| out dx,al  | write the unlocking code                  | to the data register  |     |
| dec dx     | restore the index register address to dx  |                       |     |
13-2  BASIC SOFTWARE FUNCTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
13.2.2  Locking the S3 Registers
Relocking the S3 registers is done by repeating the code used to unlock the registers except:
1.  The values written to the CR38 and CR39 registers must change at least one of the significant
bits in the valid code pattern. For example, OOh will always accomplish this.
2.  After first verifying that the Graphics Engine is not busy (bit 9 of 9AE8H is 0), bit 0 of CR40
must be cleared to O. A read-modify-write cycle must be used instead of the code used above
to prevent overwriting of any changes made to bits 7-1 in CR40 since reset.
| mov dx,3d4h  | copy index register address    |       |                          | into dx  |
| ------------ | ------------------------------ | ----- | ------------------------ | -------- |
| moval,40h    | copy index for CR40            |       | register into al         |          |
| out dX,al    | write index to index register  |       |                          |          |
| inc dx       | increment dx to 3D5h           |       | (data register address)  |          |
| in al,dx     | read content of CR40           |       | into al                  |          |
| and al,Ofeh  | clear bit 0                    | to 0  |                          |          |
out dX,al  write to CR40  to lock the Enhanced Commands  registers
| dec dx  | restore the index register address to dx  |     |     |     |
| ------- | ----------------------------------------- | --- | --- | --- |
13.2.3 Unlocking/Locking Other Registers
The Extended Sequencer registers (SR9-SR1C) have been added to the standard VGA sequencer
register set to provide a variety of new capabilities. To gain access to these registers, write xxxx0110b
(x = don't care) to SR8. Writing a bit pattern that changes one of the significant bits re-Iocks access to
the SRD register.
In addition to the standard VGA register access controls, the Trio64V+provides a number of bits
extending the control of access to these registers. These are listed in Table 13-1.
| Table 13-1.  VGA Register Access Control Extensions  |                      |     |     |     |
| ---------------------------------------------------- | -------------------- | --- | --- | --- |
| Register Bit                                         | Controls Access To:  |     |     |     |
= disable write protect setting of CRll, bit 7)
| CR33, bit 1  | CR7, bits 1 and 6 (1                  |     |     |     |
| ------------ | ------------------------------------- | --- | --- | --- |
| CR33, bit 4  | RAMDAC register (1 = disable writes)  |     |     |     |
= lock)
| CR33, bit 6  | Palette/Overscan registers (1   |     |          |     |
| ------------ | ------------------------------- | --- | -------- | --- |
| CR35, bit 4  | Vertical Timinq reqisters (1    |     | = lock)  |     |
| CR35, bit 5  | Horizontal Timing registers (1  |     | = lock)  |     |
BASIC SOFTWARE FUNCTIONS  13-3

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
13.3  TESTING FOR THE PRESENCE OF A Trio64V+ CHIP
After unlocking, a Trio64V+ chip can be identified via CR2E and CR2F. The following code aborts the
driver program if a Trio64V+ chip is not found.
| mov dX,3d4h  | copy index register address    |     |                          | into dx  |        |
| ------------ | ------------------------------ | --- | ------------------------ | -------- | ------ |
| mov al,2eh   | copy index for CR2E            |     | register into al         |          |        |
| out dX,al    | write index to index register  |     |                          |          |        |
| inc dx       | increment dx to 3D5h           |     | (data register address)  |          |        |
| in al,dx     | read content of CR2E           |     | into al                  |          |        |
| cmp  al,llh  | compare chip ID                |     | to the desired chip ID   |          | (llh)  |
jne not_TV+  jump  to a  label  if chip ID does not match desired ID
| mov dX,3d4h  | copy index register address    |     |                          | into dx  |     |
| ------------ | ------------------------------ | --- | ------------------------ | -------- | --- |
| mov al,2fh   | copy index for CR2F            |     | register into al         |          |     |
| out dX,al    | write index to index register  |     |                          |          |     |
| inc dx       | increment dx to 3D5h           |     | (data register address)  |          |     |
| in al,dx     | read content of CR2F           |     | into al                  |          |     |
| and al,40h   | mask out all but bit 6         |     |                          |          |     |
cmp  al,40h  compare chip revision to the desired chip revision  (4xh)
jne not TV+  jump  to a  label if revision ID  is not correct
|     | Trio64V+  | found  - | continue with setup  |     |     |
| --- | --------- | -------- | -------------------- | --- | --- |
not_TV+:
| movax,4cOOh  | ;  terminate with a  |     | return code of  | zero  |     |
| ------------ | -------------------- | --- | --------------- | ----- | --- |
Note that the value in CR2F may be different than the 4xH shown in this example. The correct value
can be determined from the stepping information for the chip. The PCI configuration space device and
revision ID fields can also be used to identify the chip for PCI configurations.
13.4 GRAPHICS MODE SETUP
Some programs may require a graphics mode other than that provided by standard operation. For
example, a DOS game may require a resolution of 640x400x8 (VESA mode 100) instead of the standard
DOS mode, e.g., mode 03. The following code fragment shows how this is done.
| mov aX,4f02h  | VESA  super VGA  | mode  | function call  |     |     |
| ------------- | ---------------- | ----- | -------------- | --- | --- |
| mov bs,lOOh   | mode  100        |       |                |     |     |
| int 10h       | call video BIOS  |       |                |     |     |
13-4 BASIC SOFTWARE FUNCTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 14: VGA Compatibility Support
This section describes Tri064V+ support for standard VGA and VESA Super VGA graphics standards.
14.1 VGA COMPATIBILITY
The Tria64V+ is compatible with the VGA standard. These modes are not accelerated using the Graphics
Engine. However, other design features provide excellent VGA performance.
Several of the standard VGA registers have been modified or extended in the Tri064V+. Table 14-1
describes these changes.
Table 14-1. Standard VGA Registers Modified or Extended in the Trio64V+
Register Change to Standard VGA Definition
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
CR47). bit lOis bit 0 of CR5E. Bit 4 of CR35 controls access to this register.
CR7 Bit 4 of CR35 controls access to bits 0, 2, 3, 5 and 7 of this reqister.
CR9 Bit 4 of CR35 controls access to bit 5 of this register.
CRC The display start address is a 20-bit value for the Tri064V+. The extension bits (20-
16) are bits 4-0 of CR69.
CRE The cursor location address is a 20-bit value for the Tri064V+. The extension bits
(20-16) are bits 4-0 of CR69.
VGA COMPATIBILITY SUPPORT 14-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
CR10 In addition to the standard VGA extensions (bit 8 is bit 2 of CR7, bit 9 is bit 7 of
CR7), bit 10 is bit 4 of CR5E. Bit 4 of CR35 controls access to this register.
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
3C6H-3C9H Bit 4 of CR33 controls writes to these registers.
For a detailed discussion of VGA programming, see Programmer's Guide to the EGA, VGA and Super
VGA Cards, 3rd Edition by Richard F. Ferraro (Addison-Wesley Publishing Company, Inc).
14.2 VESA SUPER VGA SUPPORT
The Tri064V+ supports the extended (Super) VGA modes defined by VESA. All modes are accelerated
by the Graphics Engine except for the planar (4 bits/pixel) ones.
14-2 VGA COMPATIBILITY SUPPORT

,I.
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 15: Enhanced Mode Programming
Enhanced mode provides a level of performance far beyond what is possible with the VGAarchitecture.
Hardware line drawing, BitBLT , rectangle fill and other drawing functions are implemented. Also
implemented are data manipulation functions, such as data extension, data source selection, and
read/write bitplane control. Hardware clipping is supported by 4 registers that define a rectangular
clipping area. While in Enhanced mode, the display memory bit map can be updated in two ways. One
is to have the CPU write directly to memory. (This is also possible in non-Enhanced modes via paging.)
The other is to have the CPU issue commands to the Graphics Engine, which then controls pixel
updating. This section explains these two methods and provides a comprehensive set of Enhanced
mode programming examples.
15.1 LINEAR ADDRESSING FOR DIRECT VIDEO MEMORY CPU ACCESSES
Linear addressing is useful when software requires direct access to display memory. Enhanced mode
operation must be enabled before linear addressing is enabled. This means that bit 0 of 4AE8H is set
to 1 to enable Enhanced mode functions and bit 3 of CR31 is setto 1 to specify Enhanced mode memory
mapping.
The Tri064V+ provides linear addressing of up to 4 MBytes of display memory. The Graphics Engine
busy flag, bit 9 of 9AE8H, should be verified to be 0 (not busy) before linear addressing is enabled by
setting bit 4 of CR58 to 1. The size of the linear address window is set via bits 1-0 of CR58. The base
address for the linear addressing window is set via CR59 and CR5A (or via the Base Address 0 (Index
10H) PCI configuration register for PCI systems).
For operation in real mode, the linear addressing window size can be setto 64 KBytes. The base address
for the window is set to AOOOOH by programming bits 31-16 of the window position in CR59-CR5A to
OOOAH. If bit 0 of CR31 is set to 1, the memory page offset (64K bank) specified in bits 5-0 of CR6A is
added to the linear addressing window position base address, allowing access to up to 4 MBytes of
display memory through a 64-KByte window.
The above discussion applies when the Tri064V+ is programmed for backwards-compatible MMIO
operation. See Section 15.3.2 for instructions on how to perform linear addressing when new MMIO
is enabled.
ENHANCED MODE PROGRAMMING 15-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
15.2 VIDEO MEMORY ACCESS THROUGH THE GRAPHICS ENGINE
When updating the display bitmap through the Graphics Engine, all CPU data moves through the Pixel
Data Transfer registers (E2E8H and E2EAH). These can be memory mapped as explained in Memory
Mapping of Enhanced Mode Registers later in this section.
The Graphics Engine manipulates the bits for each pixel to assign a color index or true color value,
which is then translated via a programmable RAMDAC before being displayed on a CRT. Selected bits
in a pixel can be masked off from being displayed by programming the DAC Mask register (3C6H). The
Tri064 can manipulate 64 bits each clock cycle, from two 32-bit pixels to eight 8-bit pixels. The Tri032
can manipulate 32 bits each clock cycle.
Figure 15-1 is a flowchart for the process of updating the color of each pixel. Start at the block labeled
'New Color' in the middle of Figure 15-1. At this stage, a color has been determined that mayor may
not be used to update a pixel in the bitmap. How this color is determined will be covered later.
The first hurdle for the new coior is the color compare process. If this is turned off (bit 8 of BEE8H,
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
settings of bits [7:6) of the Pixel Control register (BEE8H, Index OAH).
To set up the pixel color updating scheme, the programmer specifies one of four color sources by
writing bits 6-5 of the Background Mix and Foreground Mix registers. The color sources are:
• Background Color register (A2E8H)
Foreground Color register (A6E8H)
• CPU {via the Pixel Data Transfer registers (E2E8H, E2EAH))
Current display bitmap color index
One of 16 logical operations is chosen by writing bits 3-0 of the Background Mix and Foreground Mix
registers. Examples of logical operations are making the new pixel color index equal to the NOT ofthe
current bitmap color index or making the new index equal to the XOR of the source and current bitmap
indices.
15-2 ENHANCED MODE PROGRAMMING

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
MASK BIT SOURCE
COLOR SOURCE A  COLOR SOURCE B
NO
| =           |       | =,          |       |
| ----------- | ----- | ----------- | ----- |
| SRC NE  0   |       | SRC NE      |       |
|             | =     |             | =     |
| COLOR COMP  | TRUE  | COLOR COMP  | TRUE  |
=,
=
| SRC NE      | =      | SRC NE  0   | =      |
| ----------- | ------ | ----------- | ------ |
| COLOR COMP  | FALSE  | COLOR COMP  | FALSE  |
COLOR
COMPARE
NEW PIXEL COLOR
PIXUPDT
Figure 15-1. Pixel Update Flowchart
ENHANCED MODE PROGRAMMING  15-3

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
When the logical operation and color source have been specified in the Background and Foreground
Mix registers, bits 7-6 of the Pixel Control register are written to specify the source of the mask bit
value. If the resulting mask bit is a 'ONE', the Foreground Mix register is used to determine the color
source and mix. If the mask bit is a 'ZERO', the Background Mix register is used to determine the color
source and mix. There are three sources for the mask bit value:
• Always ONE (Foreground Mix register used)
• CPU (via the Pixel Data Transfer registers (E2E8H, E2EAH))
Bitmap
Setting bits 7-6 to OOb sets the mask bit to 'ONE'. All drawing updates to the video bitmap use the
Foreground Mix register settings. This setup is used to draw solid lines, through-the-plane image
transfers to display memory and BitBLT s.
If bits 7-6 are set to 10b, the mask bit source is the CPU. After the draw operation command is issued
to the Drawing Command register (9AE8), a mask bit corresponding to every pixel drawn on the display
must be provided via the Pixel Data Transfer register(s). If the mask bit is 'ONE', the Foreground Mix
register is used. If the mask bit is 'ZERO', the Background Mix register is used. Note that if the color
source is the CPU, the mask bit source cannot also be the CPU, and vice versa. This setup is used to
transfer monochrome images such as fonts and icons to the screen.
If bits 7-6 are set to 11b, the current display bit map is selected as the mask bit source. The Read Mask
register (AAE8H) is set up to indicate the active planes. When all bits of the read-enabled planes for a
pixel are a 1, the mask bit 'ONE' is generated. If anyone of the read-enabled planes is a 0, then a mask
bit 'ZERO' is generated. If the mask bit is 'ONE', the Foreground Mix register is used. If the mask bit is
'ZERO', the Background Mix register is used. Note that if the color source is the bitmap, the mask bit
source cannot also be the bitmap, and vice versa. This setting is used to BitBLT patterns and character
images.
15.3 MEMORY MAPPING OF REGISTERS
The Tri064V+ provides two memory-mapped I/O (MMIO) schemes. One method is identical to that
provided by the Tri064 and provides compatibility with older software. This provides memory mapping
of a limited number of Enhanced mode registers plus the new LPB and Streams Processor registers.
Packed register access is also provided. The second method incorporates linear addressing and
provides memory mapping of all registers, including the packed registers. The second method also
allows big or little endian addressing. Each of these MMIO methods is described below.
15.3.1 Backward-Compatible MMIO
Most of the Enhanced registers can be memory-mapped (MMIO). This function is enabled by setting
bits 4-3 of CR53.
Image writes normally made via I/O addresses E2E8H and E2EAH (the Pixel Data Transfer registers)
are made instead by accessing any memory location in the 32-KByte address space from AOOOOH to
A7FFFH. This allows efficient use of the MOVSW and MOVSD assembly language commands. Accesses
must be to even word or doubleword addresses, depending on the specification of the bus width via
bits 10-9 of 98E8H. Software must not make E2E8H, E2EAH writes beyond the A7FFFH range.
15-4 ENHANCED MODE PROGRAMMING

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Accesses to the Enhanced command registers are made to particular locations in the A8000H to AFFFFH
address range as shown in Table 15-1. Both 16-bit reads and writes are supported. Only 32-bit writes
(bit 9 of BEE8H_E set to 1) are supported.
If MMIO is enabled, bit 7 of SR9 allows register access to be either I/O or MMIO or MMIO only.
Table 15-1  Enhanced Registers Memory Mapping
| Register Mnemonic         |      | 1/0 Address (Hex)  | Register   | PackedMMIO     |
| ------------------------- | ---- | ------------------ | ---------- | -------------- |
|                           |      | MMIO = Axxxx       | Mnemonic   | Address (Hex)  |
|                           |      |                    | (Packed)   | (Axxxx)        |
| CUR Y, CUR X              |      | 82E8, 86E8         | ALT CURXY  | 8100,8102      |
| DESTY AXSTP,DESTX DIASTP  |      | 8AE8,8EE8          | ALT STEP   | 8108,810A      |
| ERR TERM                  |      | 92E8               |            | 8110           |
| CMD                       |      | 9AE8               |            | 8118           |
| SHORT STROKE              |      | 9EE8               |            | 811C           |
| BKGD COLOR                |      | A2E8               |            | 8120           |
| FRGD COLOR                |      | A6E8               |            | 8124           |
| WRT MASK                  |      | AAE8               |            | 8128           |
| RD  MASK                  |      | AEE8               |            | 812C           |
| COLOR CMP                 |      | B2E8               |            | 8130           |
| BKGD MIX, FRGD MIX        |      | B6E8, BAE8         | ALT MIX    | 8134,8136      |
| SCISSORS T, SCISSORS R    |      | BEE8 1, BEE8 2     |            | 8138, 813A     |
| SCISSORS B, SCISSORS      | R    | BEE8 3, BEE8 4     |            | 813C, 813E     |
| PIX CNTL, MULT MISC2      |      | BEE8 A, BEE8 D     |            | 8140,8142      |
| MULT  MISC, READ          | SEL  | BEE8 E, BEE8 F     |            | 8144           |
MIN AXIS PCNT, MAJ AXIS PCNT  BEE8 0, 96E8  ALT PC NT  8148,814A
| PIX TRANS  |     | E2E8, E2EA  | PIX-TRANS  |     |
| ---------- | --- | ----------- | ---------- | --- |
For improved performance, most of the Enhanced mode registers can also be written (but not read)
via a packed configuration. The 16-bit registers are paired so that two registers can be accessed via a
single 32-bit write. The addresses for this packed configuration are given in Table 15-1. The packed
register access function is enabled when MMIO is enabled.
The Tri064V+ supports the Tri064 MMIO scheme when bits 4-3 of CR53 are programmed to lOb and
bit 5 of CR53 is cleared to o. In addition, the new LPB and Streams Processor registers are also accessible
in the A8000H -AFFFFH window. If bit 5 of CR53 is set to 1, the registers are accessible in the B8000H
- BFFFFH window.  However, image writes cannot be made to BOOOOH -B7FFFH. This region and the
entire AOOOOH -AFFFFH region are left free for VGA memory and other uses.
The Tri064 scheme is also available as explained in the previous paragraph when bit 4-3 of CR53 are
set to llb. In this case, the registers can be accessed either by this scheme or by the new MMIO
explained in the next section.
ENHANCED MODE PROGRAMMING  15-5

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
15.3.2 New MMIO
The new MMIO method for the Tri064V+ is available for PCI configurations and provides a 64-MByte
addressing window starting at the base address specified in CR59-5A. This space is divided into a
32-MByte space for little endian (Intel-style) addressing and a 32-MByte space for big endian (Power
PC-style) addressing. All registers and data transfer locations are mapped into this area as shown in
Table 15-2.
Table 15-2 New MMIO Addresses
Lower 32 MBytes -Little Endian Addressing
Description Offset From Base (Hex)
Linear Addressinq (16M) 000 0000 -OFF FFFF
Imaqe Data Transfer (32K) 1000000 -100 7FFF
PCI Configuration Space Registers 10 0 8000 -10 0 8043
Packed Enhanced Registers 1008100 -100 814A
Streams Processor Registers 1008180 -100 81 FF
Current Y Position Register 100 82E8
CRT VGA 3B? Registers 100 83BO -100 83Bx
CRT VGA 3C? Registers 100 83CO -100 83Cx
CRT VGA 3D? Registers 100 83DO -100 83Dx
Subsystem Status Enhanced Register (42E8H) 1008504
Advanced Function Control Reqister (4AE8H) 100 850C
Enhanced Registers 100 86E8 -100 EEEA
Local Peripheral Bus Registers 100 FFOO -100 FF5C
The new MMIO (only) is enabled by setting bits 4-3 of CR53 to 01 b. It is also enabled in conjunction
with the old MMIO scheme when bits 4-3 of CR53 are set to 11 b. This is the default for a PCI bus
configuration, allowing PCI software immediate access to all registers and the ability to relocate the
address space. VL-Bus configurations power up with bits 4-3 of CR53 cleared to OOb, disabling both
old and new MMIO operation. If either the old or new MMIO is enabled, bit 7 of SR9 allows register
access to be either programmed I/O (IN, OUT) or MMIO (MOV) or MMIO only.
With the new MMIO enabled, the first 16 MBytes of each 32M address space (big and little endian) are
dedicated to linear addressing. A maximum of 4 MBytes of each address space (starting at the lowest
address of the space) is usable with the Tri064V+. The base address is taken from bits 31-26 of the
linear address window position (bits 7-2 of CR59 or the high order 6 bits of the the PCI Base Address
0). This is concatenated with the display memory address specified by the programmer.
In addition to enabling the new MMIO, the programmer must also enable linear addressing and specify
the window size exactly as required for the old linear addressing. Note that since only bits 31-26 are
used to specify the base address, AOOOOH cannot be specified and the 64K banking scheme possible
with the old linear addressing cannot be used with the new linear addressing.
When big endian addressing is used, the required byte swapping for linear addressing is specified by
bits 2-1 of CR53. This applies to both reads and writes.
15-6 ENHANCED MODE PROGRAMMING

II·
Trio64V+ Integrated Graphics/Video Accelerator
$3 Incorporated
15.4 PROGRAMMING
Three different programming schemes are available, I/O, standard MMIO and packed register MMIO.
Examples of how each is used to assign vertical and horizontal coordinates to Current X and Y Position
registers (82E8H and 86E8H) are:
I/O Format:
MOV DX,CUR_X
MOV AX,X
OUT DX,AX
MOV DX,CUR_ Y
MOV AX,Y
OUT DX,AX
Standard MMIO Format:
Enable MMIO
Point ES to AOOOH
Load x and y values into AX and BX
MOV ES:[CUR_ V], BX
MOV ES:[CUR_Xl, AX
Packed Register MMIO:
Enable MMIO
Point ES to AOOOH
Load the x and y values into EAX (y value in the low word and x value in the high word), I.e.,
31 15 0
EAX<=I X Y I
MOV ES:[AL T _CURXY1, EAX
The packed register MMIO scheme is the most efficient and is used where appropriate in the
programming examples provided later in this section. All assume that the ES register points to AOOOH.
15.4.1 Notational Conventions
The REG MNEMONIC on the left hand side of the arrow is the register mnemonic of the I/O port being
written into. Text following a ';' is a comment.
REGMNEMONIC <= XXXXH ; Load a hexadecimal value into the register.
REGMNEMONIC <= XXXXD ; Load a decimal value into the register.
REGMNEMONIC <= XXXX ; Load a decimal value into the register
REGMNEMONIC <= XXXXXXXXXXXXXXXXB ; Load a binary value into the register.
Image transfers (CPU pixel data writes to the frame buffer) are notated as follows:
COUNT
PIX_TRANS <= IMAGEDATA
ENHANCED MODE PROGRAMMING 15-7

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
The COUNT is the number of CPU writes. PIX_TRANS means either the E2E8H, E2EAH pixel transfer
registers or the 32K memory space from AOOOOH to A7FFFH as explained in Section 15.3.1 above.
15.4.2 Initial Setup
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
15.4.3 Programming Examples
This section provides programming examples for the following Enhanced mode drawing operations:
• Solid Line
Textured Line
Rectangle Fill Solid
• Image Transfer-Through the Plane
Image Transfer-Across the Plane
• BitBLT - Through the Plane
BitBLT - Across the Plane
• PatBLT - Through the Plane
• PatBL T -Across the Plane
• Short Stroke Vectors
• Programmable Hardware Cursor
Some programming steps are repeated in multiple examples. They are explained in detail at their first
occurrence. Therefore, readers are encouraged to work through the examples from first to last. The
register mnemonics used in the examples are listed in Table 15-1. Other mnemonics used are:
Mnemonic Description
NEW Mix = 00111 b in bits 4-0 of BAE8H or B6E8H. This overwrites the present
bitmap color value with a new value.
XOR Mix = 00101 b in bits 4-0 of BAE8H or B6E8H. The current bitmap color is
XORed with the new color.
15-8 ENHANCED MODE PROGRAMMING

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
15.4.3.1 Solid Line
This command draws a one pixel wide solid line from screen coordinates x1,y1 to x2,y2. Bresenham
parameters are used to define the line. The Pixel Control register (BEE8H, Index AH) must be set to
AOOOH to select the Foreground Mix register to specify the color source and mix type.
Setup:
Drawing a line using axial coordinates requires programming the axial step constant into the Destina
tion V-Position/Axial Step Constant (8AE8H) register (DESTV _AXSTP), the diagonal step constant into
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
(x1 > x2). These values replace the DDD sequence in the write to the CMD register shown in the
pseudocode below.
The mix NEW represents a setting of 0111 b in bits 3-0 of the Foreground Mix (BAE8H) register
(FRGD_MIX). This overwrites the present bitmap color value with a new value.
The remainder of the setup is:
ES:[FRGD_MIXI <= 0027H ; color source is FRGD_COLOR, mix type is NEW
ES:FRGD_COLOR] <= 00000002H ; color index
ES:[PIXEL_CNTLJ <= AOOOH ; FRGD_MIX provides color source and mix type
Drawing Operation:
31 15 0
I I ;
ES:[ALT _CURXV] <= x1 y1 set starting coordinate
~------~------~
; length in pixels of the major axis -1
31 15 .-:-::-:c-:C":"C'"--O1 ;
ES:[ALT _STEP] <= 12*(MIN-MAXL 2*MIN diagonal and axial step constants
If the X drawing direction is positive then
ES:[ERR_T ERM] <= 2 * MIN - MAX ; error term
else if the X drawing direction is negative
ES[ERR_TERM] <= 2 * MIN - MAX - 1 ; error term
ES:[CMD] <= 00100000DDD10001b ; Draw line command (bits 15-13, 11), draw (as opposed to
; just move current position)(bit 4), bit 0 is always 1
ENHANCED MODE PROGRAMMING 15-9

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
15.4.3.2 Textured Line
The line draw command can be used to draw a one pixel wide textured line from screen coordinates
x1,y1 to x2,y2. The texture is created by (1) setting bits 7-6 of the Pixel Control register (BEE8H, Index
AH) to A080H to specify the CPU as the source ofthe mask bit selecting the mix register, (2) specifying
a background and foreground color, (3) setting bit 8 of the Command register (9AE8H) to 1 (wait for
CPU data) and (4) setting bit 1 of the Command register to 1 (multi-pixel). When the pattern bit sent by
the CPU is a 1, the Foreground Mix register specifies the the color source and mix. When the bit is a
0, the Background Mix register specifies the color source and mix. This example uses the mix NEW for
the foreground mix, XOR for the background mix, foreground color index 2 and background color index
4. The 32-bit line texture/pattern (PATTERN) is 00110000111100110011000011110011b. This requires
that bits 10-9 of the Command register be set to 10b to specify a 32-bit bus.
Setup:
The XOR mix corresponds to a setting of 0101 b in bits 3-0 of the Background Mix (B6E8H) register
(BKGD_MIX). See the Solid Line example for an explanation of other parameters and registers used in
this example.
3,1_ ______1 ,5 _______0
ES:[ALT _MIX) ¢=IL _0_0_27_H_,---0_0_05_H--l1 ; FRGD_COLOR is color source and NEW is mix,
; BKGD_COLOR is color source and XOR is mix
ES:[FRGD_COLOR) ¢= 00000002H ; color index
ES:[BKGD_COLOR) ¢= 00000004H ; color index
ES:[PIXEL_CNTL) ¢= A080H ; mask data selecting mix register is provided by the CPU
Drawing Operation:
°
31 15
ES:[ALT _CURXYI ¢= 1r---X-1----.---y-1---] ; set starting coordinates
ES:[MAJ_AXIS_PCNT ¢= MAX -1 ; length in pixels of the major axis -1
31 15 ____ 1 0 ;
ES:[ALT_STEP) ¢=12*(MIN-MAXL 2*MIN diagonal and axial step constants
If the X drawing direction is positive then
ES:[ERR_T ERM) ¢= 2 * MIN - MAX ; error term
else if the X drawing direction is negative
ES[ERR_TERM) ¢= 2 * MIN - MAX - 1 ; error term
ES:[CMD) ¢= 00100101DDD10011b ; Draw line (bits 15-13, 11), 32-bit bus (bits 10-9), wait for data
; from the CPU (bit 8)' draw (bit 4), mUlti-pixel (bit 1)
COUNT (of PATTERN dwords) = (MAX + 31)/32 (See Note)
PIX_TRANS ¢= 00110000111100110011000011110011b ; Output PATTERN to Pixel Data Transfer
; registers COUNT times
Note
The COUNT of the number of writes required by the CPU is a function of the number of bits to be
transferred and the width of the transfer (8, 16 or 32 bits as specified by bits 10-9 of the Drawing
Command register (9AE8H)). The number of bits transferred per line must be an even multiple of the
transfer width. If this is not the case, the last write per line must be padded with one or more dummy
15-10 ENHANCED MODE PROGRAMMING

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
bits to meet this requirement. For example, if the transfer width is 8 bits and nine bits are to be
transferred for the line, two bytes must be written per line, with the upper 7 bits of the second byte
padded. In general, the number of padding bits per line will vary from 0 to (n-1), where n is the transfer
width in bits.
With a transfer width of 8 bits, the number of byte writes required per line can be determined from
the formula n = (MAX+7)/8, with n being truncated to an integer ifthe result contains a fraction.
Thus a MAX = 11 transfer requires (11+7)/8 = 21/4 = 2 bytes. The formulas for all transfer widths are
given below.
8-bit transfers: COUNT = (MAX+7)/8 bytes
16-bit transfers: COUNT = (MAX+ 15)/16 words
32-bit transfers: COUNT = (MAX+31 )/32 dwords
ENHANCED MODE PROGRAMMING 15-11

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
15.4.3.3 Rectangle Fill Solid
This command draws a solid rectangle with its top left corner at x1,y1, height = HEIGHT and width =
WIDTH. The Pixel Control register (BEE8H, Index AH) must be set to AOOOH to select the Foreground
Mix register to specify the color source and mix type. This example uses the mix NEW and color index
2. The drawing direction (bits 7-5 in the write to the CMD register below) is set to X positive, X major
and Y positive (101b).
Setup:
ES:[FRGD_MIX] <= 0027H  ; color source is FRGD_COLOR, NEW mix type
| ES:[FRGD_COLOR] <= 00000002H  |     | ; color index  |     |
| ----------------------------- | --- | -------------- | --- |
ES:[PIXEL_CNTL] <= AOOOH  ; FRGD_MIX specifies the color source and mix type
Drawing Operation:
|     | 31  15  | 0   |     |
| --- | ------- | --- | --- |
ES:[ALT _ CURXY] <=  x_1_--L_--,-y_1_  -l[  ; set starting coordinates
L[_  _
|                   | 31  15                | 0                  |     |
| ----------------- | --------------------- | ------------------ | --- |
| ES:[ALT]CNT] <=[  | WIDTH-1  [ HEIGHT-1l  | ; rectangle width  |     |
ES:[CMD] <= 0100000010110001 b  ; Draw rectangle (bits 15-13, 11), draw (bit4)
Note
The rectangle can be defined by specifying anyone ofthe four corners and setting bits 7-5 accordingly.
Always select X as the major axis (bit 6 =0). No matter how the rectangle is defined, it always fills from
left to right and top to bottom.
|     | Corner       | X direction (bit 5)  | Y direction (bit 7)  |
| --- | ------------ | -------------------- | -------------------- |
|     | top left     | positive (1 )        | positive (1 )        |
|     | top right    | negative (0)         | positive (1)         |
|     | bottom left  | positive (1)         | negative (0)         |
|     |              | negative (0)         | negative (0)         |
bottom right
15-12 ENHANCED MODE PROGRAMMING

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
15.4.3.4 Image Transfer-Through the Plane
This command transfers a rectangular image from the CPU to the display memory through the plane.
"through the plane" means the complete color index is transferred for each pixel, e.g., in 8 bits/pixel
mode, one byte is required to transfer one pixel to memory. The image is stored as an array of pixels
arranged in row major fashion (consecutively increasing memory addresses). The Pixel Control register
must be set to AOOOH to select the Foreground Mix register to specify the color source and mix type.
The color source must be specified as the CPU. Bit 12 of the Command register must be set to 1 (swap
ON) for Intel-type architectures. Bit 8 of the Command register must be set to 1 (wait for CPU data) and
bits 6 and 5 must also be set to 1 to specify X as the major axis and a left-to-right drawing direction.
This example uses a mix type of NEW and x1,y1 is the top left corner of the rectangle on the screen.
The height and width of the rectangle (in pixels) are HEIGHT and WIDTH. Doublword CPU writes are
supported by setting bits 10-9 of the Command register to 10b.
Setup:
ES:[FRGD_MIX) <= 0047H ; color source is the CPU, mix type is NEW
ES:[PIXEL_CNTL) <= AOOOH ; FRGD_MIX is the source for color source and mix type
Drawing Operation:
31 15 0
ES:[ALT _CURXY) <= 1L-__X _1_--"'-----'y_1_--"1 ; set destination starting coordinates
31 15 0
I I l
ES:[ALT_PCNT) <= WIDTH-1 HEIGHT-1 ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
ES:[CMD) <= 01010101D0110001b ; Draw rectangle (bits 15-13, 11), swap ON (bit 12),
; 32-bit transfers (bits 10-9), wait for CPU data (bit 8)'
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4)
COUNT (of image pixel data to transfer) = (See Note)
PIX_TRANS <= IMAGEDATA; Output image data to the Pixel Data Transfer registers for COUNT dwords.
Note
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred, the width of the transfer (8,16 or 32 bits as specified by bits 10-9 ofthe Drawing Command
register (9AE8H)) and the color depth (bits/pixel). The number of pixels transferred per line must be an
even multiple of the transfer width. If this is not the case, the last write per line must be padded with
one or more dummy pixels to meet this requirement. For example, at 4 bits/pixel, each byte holds two
pixels. If the transfer width is one byte and three pixels are to be transferred per line, two bytes must
be written per line, with the upper nibble of the second byte a dummy pixel. If the transfer width is 16
bits, from one to three dummy pixels may be required to make the number of pixels per line an even
multiple of 16. The number of word writes required per line can be determined from the formula n =
(W+3)/4, with n being truncated to an integer if the result contains a fraction. Thus a six pixel transfer
requires (6+3)/4 = 2.25 = 2 words. This is then multiplied by the height of the image (in pixels) to
determine the COUNT of words to be transferred. Similar procedures apply to every other combination
of the variables affecting the COUNT. The formulas for all cases are given below, where W is the width
of the image and H is the height of the image, both in pixels.
ENHANCED MODE PROGRAMMING 15-13

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
COUNT for 4 bits/pixel modes
8-bit transfers: COUNT = (W+ 1) /2 * H bytes
16-bit transfers: COUNT = (W+3)/4 * H words
32-bit transfers: COUNT = (W+7)/8 * H dwords
COUNT for 8 bits/pixel modes
8-bit transfers: COUNT = W * H bytes
16-bittransfers: COUNT = (W+1)/2 * H words
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
15-14 ENHANCED MODE PROGRAMMING

~.
Trio64V+ Integrated Graphics/Video Accelerator
r~
S3 Incorporated
15.4.3.5 Image Transfer-Across the Plane
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
31r -I ---.1-5 ---10
ES:[ALT _MIX] ¢= L-_ 0 _ 02 _ 7 _ H _ _~ __ 0 _ 0 _ 0 _ 5 _~ H .
;
; F
B
R
K
G
G
D
D
_
_
C
C
O
O
L
L
O
O
R
R
c
is
o l
c
o
o
r
l o
so
r
u
s
r
o
c
u
e
r c
a
e
n d
a n
m
d
i
m
x i
i
s
x
N
is
E
X
W
O R
ES:[FRGD_COLOR] ¢= 00000004H ; foreground color index 4
ES:[BKGD_COLOR] ¢= OOOOOOOOH ; background color index 0
ES:[PIXEL_CNTL] ¢= A080H ; selection of mix register is based on data from the CPU
Drawing Operation:
31 15 0
ES:[ALT_ CURXY] ¢= '-.1 ___x _1_ ___ L -__ y '-1_ _- -'1 ; set destination starting coordinates
31 15 0
ES:[ALT_PCNT] ¢= 1 WIDTH-1 1 HEIGHT-1 1 ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AE8H register is 0
CMD ¢= 0101001100110011 b ; Draw rectangle (bits 15-13, 11), swap ON (bit 12),
; 16-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5)' draw (bit 4),
; mUlti-pixel (bit 1)
COUNT (of image pixel data to transfer) = ((WIDTH +15)/16)*HEIGHT words
PIX_TRANS ¢= IMAGEDATA; Output image data to Pixel Transfer register for COUNT words
Notes
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred and the width of the transfer (8, 16 or 32 bits as specified by bits 10-9 of 9AE8H). Except for
the case where bits 10-9 of 9AE8H are 11b, the number of pixels transferred per line must be an even
multiple of the transfer width. If this is not the case, the last write per line must be padded with one or
more dummy pixels to meet this requirement. For example, if the transfer width is 8 bits and nine
pixels are to be transferred per line, two bytes must be written per line, with the upper 7 bits of the
second byte padded. In general, the number of padding bits per line will vary from 0 to (n-1), where n
is the transfer width in bits.
ENHANCED MODE PROGRAMMING 15-15

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
With a transfer width of B bits, the number of byte writes required per line can be determined from the
formula n = (W+7)/B, with n being truncated to an integer ifthe result contains a fraction. Thus a 13-bit
pixel transfer requires (13+7)/B = 2.5 = 2 bytes. This is then multiplied by the height of the image (in
pixels) to determine the COUNT of bytes to be transferred. Similar procedures apply to every other
combination of the variables affecting the COUNT. The formulas for all cases are given below, where
W is the width of the image and H is the height of the image, both in pixels.
B-bit transfers: COUNT = (W+7)/B * H bytes (9AEBH_10-9 = OOb)
16-bittransfers: COUNT = (W+15)/16 * H words (9AEBH_10-9 = 01b)
32-bit transfers: COUNT = (W+31 )/32 * H dwords (9AEBH_10-9 = 10b)
New 32-bit transfers: COUNT = (((W+7)/B*H)+3)/4 dwords (9AEBH_10-9 = 11b) (Tri032 only)
The differences between the two 32-bit transfer options are:
1. For 9AEBH_10-9 set to 10b, every line of the transfer must start with a fresh doubleword. In other
words, all unneeded bits in a doubleword transfer for a given line are discarded. After a rectan
gular image is transferred, the current drawing position is a the bottom left, meaning the next
rectangle, if drawn, will be below the previous rectangle.
2. For 9AEBH_1 0-9 set to 11 b, only bits from the end of the line width to the next byte boundary are
discarded. Data for the next line begins with the next byte. After a rectangular image is trans
ferred, the current drawing position is a the top right, meaning the next rectangle, if drawn,
will be to the right of the previous rectangle.
To write to a single plane, setthe foreground mixto 'logical one' (0002H), the background mixto 'logical
zero' (0001 H)' and the Write Mask register (AAEBH) to select the desired (single) plane for updates.
15-16 ENHANCED MODE PROGRAMMING

,I.
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
15.4.3.6  BitBLT-Through the Plane
This command copies a source rectangular area in display memory to another location in display
memory. The Pixel Control register must be set to AOOOH to select the Foreground Mix register to
specify the color source and mix type. The color source must be specified as the bitmap (display
memory). Bit 6 of the Command register must be set to 1 to specify X as the major axis.  For this
example, assume x1,y1 is the top left corner of the source rectangle in display memory and x2,y2 is
the top left corner of the destination rectangle. The rectangles can be overlapping or disjoint. The height
and width (in pixels) of the rectangle being copied are HEIGHT and WIDTH.
Setup:
First, the values of the Srcx, Srcy, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, Y Positive: Srcx = x1, Srcy = y1, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
If x1 > x2
then if X Positive, Srcx = x1, Destx = x2
else
| Srcx = x1 + WIDTH -1, Destx = x2 + WIDTH-1  |     | ; X Negative  |
| ------------------------------------------- | --- | ------------- |
Ify1 >y2
then if Y Positive, Srcy = y1, Desty = y2
else
| Srcy = y1 + HEIGHT -1, Desty = y2 + HEIGHT-1  |     | ; Y Negative  |
| --------------------------------------------- | --- | ------------- |
ES:[PIXEL_CNTL] ¢= AOOOH  ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIXl ¢= 0067H  ; color source is display memory and mix type is NEW
Draw Operation:
|                      | 31  15  0   |                           |
| -------------------- | ----------- | ------------------------- |
|                      | I  l        | ;                         |
| ES:[ALT  _CURXY] ¢=  | Srcx  Srcy  | set starting coordinates  |
| 31                   | 15  0       |                           |
| I                    | I           | ;                         |
ES:[ALT  _STEP] ¢=  Destx  Desty  set destination coordinates
| 31  | 15  0  |     |
| --- | ------ | --- |
| I   | I  l   |     |
ES:[ALT_PCNT] ¢=  WIDTH-1  HEIGHT-1 ; rectangle width and height
ES:[CMD] ¢= 11000000DOD10001b  ; BitBLT (bits 15-13, 11), always X Major (bit 6) ,draw (bit4)
ENHANCED MODE PROGRAMMING  15-17

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
15.4.3.7 BitBLT- Across the Plane
This uses the same command as a BitBLT through the plane. However, instead of copying complete
pixels (with color affected only by the mix), this 'across the plane" transfer uses only the bits in the
color planes specified by setting the Read Mask register (AEE8H), e.g., bit 3 of every pixel, to determine
the destihation rectangle. With more than one plane.enabled for read, if all the bits in the planes enabled
for read are '1's then a '1' is read. If a bit in anyone of the planes enabled for read is a '0', then '0' is
read. An "across the plane" transfer is created by (1) setting bits 7-6 ofthe Pixel Control register (BEE8H,
Index AH) to AOCOH to specify the bitmap as the source of the mask bit selecting the mix register, (2)
programming the Read and Write Mask registers to specify the plane to read from and write to and (3)
setting bit 1 ofthe Command registerto 1 (multi-pixel). In this example, when the bit read is a 1, a 1 is
copied as specified by the foreground mix. When the bit read is a 0, a 0 is copied as specified by the
background mix. Assume x1 ,y1 is the top left corner of the source rectangle on the display, and x2,y2
is the top left corner of the destination rectangle. The image is read from plane 0 and written to plane
2. The rectangles could be overlapping or disjoint. The height and width (in pixels) of the rectangle are
HEIGHT and WIDTH.
Setup:
First, the values of the Srcx, Srcy, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, Y Positive: Srcx = x1, Srcy = y1, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
If x1 > x2
then if X Positive, Srcx = x1, Destx = x2
else
Srcx = x1 + WIDTH -1, Destx = x2 + WIDTH-1 ; X Negative
Ify1 > y2
then if Y Positive, Srcy = y1, Desty = y2
else
Srcy = y1 + HEIGHT -1, Desty = y2 + HEIGHT-1 ; Y Negative
ES:[PIXEL_CNTL] <= AOCOH ; data from display memory selects mix register
31 15 0
ES:[ALT _MIX] <= 1,-_0_0_02_H_--,-_0_00_1_H_....J1 ; result of foreground mix is always logical 1,
; result of background mix is always logical 0
ES:[RD_MASK] <= 00000001H ; read from plane 0
ES:[WRT_ MASK] <= 00000004H ; plane 2 enabled for write
15-18 ENHANCED MODE PROGRAMMING

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Draw Operation:
|                      | 31  15  0     |                              |
| -------------------- | ------------- | ---------------------------- |
|                      | I             | I  ;                         |
| ES:[ALT  _CURXY] ~   | Srcx  Srcy    | set starting coordinates     |
| 31                   | 15  0         |                              |
| ES:[ALT  _STEP] ~ I  | I             | ;                            |
|                      | Destx  Desty  | set destination coordinates  |
| 31                   | 15I   0       |                              |
I
ES:[ALT_PCNT] ~I WIDTH-1  HEIGHT-1  ; rectangle width and height
ES:[CMD] ~ 11000000DOD10001b  ; BitBLT (bits 15-13,11), always X Major (bit 6), draw (bit 4),
; multi-pixel (bit 1)
Note
It is possible to translate a monochrome image, e.g., text fonts, stored in a single plane in display
memory into a 2-color image. This is accomplished by setting the mix registers differently and setting
the desired background and foreground colors. If the source bit is a '1', then the corresponding pixel
at the destination is colored with the foreground color index. The destination pixel is colored with the
background color index if the corresponding source bit is a '0'. The setup for this is as follows:
| ES:[WRT_ MASK] ~ FFFFFFFFH  | ; enable all planes for writing  |     |
| --------------------------- | -------------------------------- | --- |
ES:[FRGD_MIX] ~ 0027H  ; color source foreground, mix type NEW
ES:[BKGD_MIX] ~ 0007H  ; color source background, mix type NEW
| ES:[FRGD_COLOR] ~ 00000004H  | ; foreground color  |     |
| ---------------------------- | ------------------- | --- |
| ES:[BKGD_COLOR] ~ 00000001H  | ; background color  |     |
ENHANCED MODE PROGRAMMING  15-19

....
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
15.4.3.8 PatBlT - Pattern Fill Through the Plane
An 8x8 pixel pattern is initially copied into an off-screen area of display memory using an image transfer
operation or a direct write (linear addressing). This command then repeatedly tiles this source pattern
into a destination rectangle of arbitrary size. The colors of the destination pixels are affected only by
the mix selected. The destination rectangle must not overlap the source pattern. Each copy is aligned
to an a-pixel boundary (x coordinate = 0, a, etc.), with pixels outside the destination rectangle boundary
not being drawn. The Pixel Control register must be set to AOOOH to select the Foreground Mix register
to specify the color source and mix type. The color source must be specified as the bitmap (display
memory). Bit 6 ofthe Command register must be setto 1 to specify X as the major axis. In this example,
assume x1,y1 is the top left corner ofthe pixel pattern and x2,y2 is the top left corner ofthe destination
rectangle. The height and width (in pixels) of the rectangle are HEIGHT and WIDTH.
Setup:
¢::
ES:[PIXEL_CNTL] AOOOH ; FRGD_MIX is the source of color source and mix type
¢::
ES:[FRGD_MIX] 0067H ; color source is display memory, mix type is NEW
Draw Operation
31 15 0
ES:[AL T_ CURXY] ¢:: L...I _x_1_-'---_y'-1_.....J1 ; set starting coordinates
31 15 0
ES:[ALT _STEP] ¢::I' - _x_2_---'-_y'-2_.....J1 ; set destination coordinates
31 15 0
¢::I
ES:[ALT_PCNT] WIDTH-1 1 HEIGHT-1] ; rectangle width and height
¢::
ES:[CMD] 11100000DOD10001 b ; PatBLT (bits 15-13,11), always X Major (bit 6) , draw (bit 4)
15-20 ENHANCED MODE PROGRAMMING

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
15.4.3.9 PatBlT - Pattern Fill Across the Plane
This uses the same command as a PatBLT through the plane. However, instead of copying complete
pixels (with color affected only by the mix), this 'across the plane" transfer uses only the bits in the
color planes specified by setting the Read Mask register (AEE8H), e.g., bit 3 of every pixel, to determine
the destination rectangle. With more than one plane enabled for read, if all the bits in the planes enabled
for read are '1's then a '1' is read. If a bit in anyone of the planes enabled for read is a '0', then '0' is
read. An "across the plane" transfer is created by (1) setting bits 7-6 ofthe Pixel Control register (BEE8H,
Index AH) to AOCOH to specify the bitmap as the source of the mask bit selecting the mix register, (2)
programming the Read and Write Mask registers to specify the plane to read from and write to and (3)
setting bit 1 ofthe Command register to 1 (multi-pixel). In this example, when the bit read is a 1, a 1 is
copied as specified by the foreground mix. When the bit read is a 0, a 0 is copied as specified by the
background mix. In this example, assume x1,y1 is the top left corner of the pixel pattern and x2,y2 is
the top left corner of the destination rectangle. The image is read from plane 0 and written to plane 2.
The height and width of the destination rectangle are HEIGHT and WIDTH.
Setup:
ES:[PIXEL_CNTL] ¢= AOCOH ; data from display memory selects mix register
3,1_ _______1 5,-______0
ES:[ALT _MIX] ¢=IL _0_0_02_H_'----0_0_01 _H---------.Jl ; result of foreground mix is always logical 1,
; result of background mix is always logical 0
ES:[RD_MASK] ¢= 00000001 H ; read from plane 0
ES:[WRT _MASK] ¢= 00000004H ; plane 2 enabled for write
Draw Operation:
3,1_ _____- ,15_ _______0
ES:[ALT _CURXY] ¢= 1'----_X_1_-----"---_-'-y1_--'1 ; set starting coordinates
3,'_ _______1 5,-______0
ES:[ALT _STEP] ¢= 1'----_x_2_-'--_y~2_-'1 ; set destination coordinates
°
31 15
ES:[ALT_PCNT] ¢= I WIDTH-1 I HEIGHT-1 I ; rectangle width and height
ES:[CMD] ¢= 11100000DOD10011 b ; PatBL T (bits 15-13, 11), always X Major (bit 6) , draw (bit 4),
; mUlti-pixel (bit 1)
Note
To expand the source mono pattern into a 2-color pattern, set the foreground mix to 27H, the
background mix to 7H and the foreground and background colors as desired. Also set the write mask
(AAE8H) to FFFFFFFFH. This needs to be set only once. It is altered only by another write.
ENHANCED MODE PROGRAMMING 15-21

r~ .
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
15.4.3.10 Short Stroke Vectors
This command rapidly draws short lines (up to 15 pixels in length). Such lines are constrained to one
of the 8 directions at 45 degree increments starting at 0 degrees. The current point x1.v1 is set and a
NOP command is issued to set all the desired drawing parameters without actually writing a pixel. For
example, bit 2 (Last Pixel Off) would be set to 1 (OFF) for drawing connected lines until the last line is
drawn. The short stroke vector parameters are then loaded in the Short Stroke Vector Transfer (9EE8H)
register (SHORT_STROKE). Two vectors can be defined at a time, one in the low byte and one in the
high byte. For the low byte, bits [7:5] define the direction, with bit 4 set to '1' for a draw operation or
to '0' for a move current position operation. Bits 3-0 define the length of the short line. Let SSVDO,
SSVD1, ... SSVDN-1 bytes be the short stroke vector data for N lines.
Setup:
ES:[PIXEL_CNTL] {= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX] {= 0027H ; use the foreground color, mix type NEW
ES:[FRGD_COLOR]{= 00000004H ; foreground color index 4
Draw Operation:
31 15 0
ES:[ALT _CURXYI {= x_1_--'-_--'-y_1_---'1 ; set starting coordinates
LI_ _
ES:[CMD] {= 00010010XXX11111 b ; NOP (bits 15-13, 11), byte swap (bit 12), 16-bit transfers
; (bits 10-9) , draw (bit 4), radial drawing direction (bit 3),
; last pixel off (bit 2), mUlti-pixel (bit 1)
While space available in the FIFO
ES:[SHORT_ STROKE] {= SSVD1 SHL 8 + SSVDO; SSVD1 shifted to high byte, SSVDO in low byte
ES:[SHORT_ STROKE] {= SSVD3 SHL 8 + SSVD2; byte swap turned on to read vectors out in
; correct order
ES:[SHORT_STROKE] {= SSVDN-1 SHL 8 + SSVDN-2
15-22 ENHANCED MODE PROGRAMMING

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
15.4.3.11 Programmable Hardware Cursor
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
the Hardware Graphics Cursor Background Stack (CR4B) registers. Each of these is a stack of three 8-bit
registers. The stack pointers are reset to 0 by reading the Hardware Graphics Cursor Mode register
(CR45). The color value is then programmed by consecutive writes (low byte, second byte, third byte)
to the appropriate (foreground or background) register.
Enabling/Disabling the Cursor
The hardware cursor is disabled when a VGA-compatible mode is in use. It can be enabled or disabled
when in Enhanced mode (bit 0 of 4AE8H = 1), as follows.
CR39 ¢= AOH ; Unlock System Control registers
CR45_0 ¢= 1 ; Enable hardware cursor
CR45_0 ¢= 0 ; Disable hardware cursor
CR39 ¢= OOH ; Lock System Control registers
Positioning the Cursor
The cursor can be positioned at any point on the display, with the X,V coordinates ranging from 0 to
2047. This enables the full cursor images to be displayed on the screen and partial cursor images to
be displayed at the right edge and the bottom edge of the screen. The cursor offset OX,OV has to be
set to 0,0 for a 1024x768 resolution. If X is > (1024 - 64) or V is > (768 - 64), then a partial cursor is
visible at the right edge or top edge of the screen respectively. Note that if V ~ 768 then the cursor is
not visible; it is residing in the off-screen area.
A partial cursor image can be displayed at the left edge or the top edge ofthe screen. To enable partial
cursor display at the top edge of the screen, V is set to 0 and the V offset register is set to OV (range
from 0 to 63). This displays the bottom 64-0V rows of the cursor image at the currently set X position
and the top edge of the screen. Similarly, a partial cursor can be displayed at the left edge of the screen
by setting X to 0 and the X offset register to OX (range from 0 to 63). This displays the right 64-0X
columns of the cursor image at the currently set X and the left edge of the screen. The following
pseudocode illustrates cursor positioning.
CR39 ¢=AOH ; Unlock System Control registers
CR46_10-8 ¢= MS 3 bits of X cursor position
CR47 _7-0 ¢= LS 8 bits of X cursor position
ENHANCED MODE PROGRAMMING 15-23

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
CR49_7-0 ~ LS S bits of Y cursor position
CR4E_5-0 ~ Cursor Offset X position
CR4F _5-0 ~ Cursor Offset Y position
CR4S_10-S ~ MS 3 bits of Y cursor position
CR39 ~ OOH ; Lock System Control registers
The cursor position is updated by the hardware once each frame. Therefore, the programmer should
ensure that the position is re-programmed no more than once for each vertical sync period.
Programming the Cursor Shape
The AND and the XOR cursor image bitmaps are 512 bytes each. These bitmaps are word interleaved
in a contiguous area of display memory, i.e., AND word 0, XOR word 0, AND word 1, XOR word 1 ...
AND word 255, XOR word 255. The starting location must be on a 1024-byte boundary. This location
is programmed into the Hardware Graphics Cursor Start Address registers (CR4C and CR4D) as follows:
CR39 ~ AOH ; Unlock System Control registers
CR4C_11-S ~ MS 4 bits of the cursor storage start 1024-byte segment.
CR4D ~ LS S bits of the cursor storage start 1024-byte segment
CR39 ~ 0 ; Lock System Control registers
The value programmed is the 1024-byte segment of display memory at which the beginning of the
hardware cursor bit pattern is located. For example, for an SOOx600xS mode on a 1 MByte system,
there are 10241 K segments. Programming CR4C_11-S with 3H and CR4D with FEH specifies the starting
location as the 1022nd (O-based) 1 K segment. The cursor pattern is programmed (using linear
addressing) at FFSOOH offset from the base address of the frame buffer.
Note
If the cursor is not 64 bits by 64 bits, the given images should be padded to make the cursor image 64
bits by 64 bits. The padded area should be made transparent by padding the extra AND mask bits with
'1's and the extra XOR bits by 'O's.
15.5 RECOMMENDED READING
Graphics Programming for the 8514/A by Jake Richter and Bud Smith (M&T Publishing, Inc) provides
extensive explanations and examples for programming most of the bits in the S3 Enhanced Registers.
This book may be out of print.
Programmer's Guide to the EGA, VGA and Super VGA Cards, 3rd Edition by Richard F. Ferraro
(Addison-Wesley Publishing Company, Inc) includes a section on programming for S3 accelerator
chips.
15-24 ENHANCED MODE PROGRAMMING

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Section 16: VGA Standard Register Descriptions
In the following register descriptions, 'U' stands for undefined or unused and 'R' stands for reserved
(write = 0, read = U). A question mark in an address stands for a hexadecimal value of either 'B' or 'D'.
If bit 0 of the Miscellaneous Output Register (3C2H, Write) is set to 1, the address is based at 3DxH for
color emu lation. If this bit is reset to 0, the address is based at 3BxH for monochrome emulation.
See Appendix A for a table listing each register in this section and its page number.
16.1  GENERAL REGISTERS
This section describes general input status and output control registers.
Miscellaneous Output Register (MiSe)
| Write Only  |     | Address: 3C2H  |     |
| ----------- | --- | -------------- | --- |
Read Only
Address: 3CCH
Power-On Default: OOH
This register controls miscellaneous output signals. A hardware reset sets all bits to zero.
I
| 7  6      | 5  4                         | 3  2      | 1  0      |
| --------- | ---------------------------- | --------- | --------- |
|           |                              | elK  SEl  | ENB  lOA  |
| VSP  HSP  | PGSl  =0                     | 1  0      | RAM  SEl  |
| Bit 0     | lOA SEl -I/O Address Select  |           |           |
o  = Monochrome emulation. Address based at 3Bx
1 = Color emulation. Address based at 3Dx
| Bit 1  | ENB RAM -Enable CPU Display Memory Access  |     |     |
| ------ | ------------------------------------------ | --- | --- |
o = Disable access of the display memory from the CPU
1 = Enable access of the display memory from the CPU
VGA REGISTER DESCRIPTIONS  16-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bits 3-2 Clock Select -Select the Video Clock Frequency
00 = Selects 25.175 MHz DCLK for 640 horizontal pixels
01 = Selects 28.322 MHz DCLK for 720 horizontal pixels
10 = Reserved
11 = Enables loading of DCLK PLL parameters in SR12 and SR13.
A setting of either OOb or 01 b causes the appropriate values to be programmed into
the DCLK PLL registers if bit 1 of SR15 is setto 1.
Bit 4 Reserved = 0
Bit 5 PGSL -Select High 64K Page
o = Select the low 64K page of memory
1 = Select the high 64K page of memory
Bit 6 HSP -Select Negative Horizontal Sync Pulse
o
= Select a positive horizontal retrace sync pulse
1 = Select a negative horizontal retrace sync pulse
Bit 7 VSP -Select Negative Vertical Sync Pulse
o = Select a positive vertical retrace sync pulse
1 = Select a negative vertical retrace sync pulse
Feature Control Register (FCR_WT, FCR_AD)
Write Only Address: 3?AH
Read Only Address: 3CAH
Power-On Default: OOH
6 5 1 o
=0 =0 =0 =0
Bits 2-0 Reserved = 0
Bit 3 VSSL -Vertical Sync Type Select
o
= Enable normal vertical sync output to the monitor
1 = The 'vertical sync' output is the logical OR of 'vertical sync' and 'vertical active
display enable' (an internal signal)
Bits 7-4 Reserved = 0
16-2 VGA REGISTER DESCRIPTIONS

fl·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
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
0= The internal SENSE signal is a logical 0
1 = The internal SENSE signal is a logical 1
| Bits 6-5  | Reserved = 0                     |     |     |
| --------- | -------------------------------- | --- | --- |
| Bit 7     | CRT INTPE -CRT Interrupt Status  |     |     |
0= Vertical retrace interrupt cleared
1 = Vertical retrace interrupt pending
See Section 12.7 for an explanation of interrupt generation.
Input Status 1 Register (STATUS_1)
| Read Only  |     | Address: 3?AH  |     |
| ---------- | --- | -------------- | --- |
Power-On Default: Undefined
This register indicates video sync timing and video wraparound.
| Bit 0  | DTM -Display Mode Inactive  |     |     |
| ------ | --------------------------- | --- | --- |
o = The display is in the display mode.
1 = The display is not in the display mode. Either the horizontal or vertical retrace
period is active
| Bit 1  | Reserved = 0               |     |     |
| ------ | -------------------------- | --- | --- |
| Bit 2  | Reserved = 1               |     |     |
| Bit 3  | VSY -Vertical Sync Active  |     |     |
o = Display is in the display mode
1 = Display is in the vertical retrace mode
VGA REGISTER DESCRIPTIONS  16-3

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bits 5-4  | TST-VDT -Video Signal Test  |     |     |     |
| --------- | --------------------------- | --- | --- | --- |
Video Data Feedback 1,0. These bits are feedback video signals to do read back tests.
These bits are selectively connected to two of the eight color outputs of the attribute
controller. Bits 5 and 4 of the color plane enable register (AR12) control the multi
plexer for this video output observation.
°
| Bits 7-6  | Reserved =  |     |     |     |
| --------- | ----------- | --- | --- | --- |
Video Subsystem Enable Register
| Read!Write  |     | Address: 3C3H  |     |     |
| ----------- | --- | -------------- | --- | --- |
Power-On Default: OOH
¥~~
|          | I :  I :  | I :  I :  | I   |     |
| -------- | --------- | --------- | --- | --- |
| I  :  I  | :         |           | I   | I   |
R
| Bit 0  | °VG A ENB -VGA Enable  |     |     |     |
| ------ | ---------------------- | --- | --- | --- |
= VGA display disabled
1 = VGA display enabled
| Bits 7-1  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
16-4 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
16.2 SEQUENCER REGISTERS
The sequencer registers are located at two-byte address spaces. These registers are accessed by first
writing the data to the index register ofthe sequencer at I/O address 3C4H and then writing to or reading
from the data register at 3C5H. A word write of both address and data at 3C4H can also be performed.
Sequencer Index Register (SEOX)
| Read/Write  |     | Address: 3C4H  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is loaded with a binary value that indexes the sequencer register for read/write data. This
value is referred to as the "Index Number" of the SR register in this document.
| 7  6      | 5  4                                   | 3  2         | 1  o  |
| --------- | -------------------------------------- | ------------ | ----- |
| R         | R                                      |              |       |
| R         |                                        | SEQ ADDRESS  |       |
| Bits 4-0  | SEQ ADDRESS -Sequencer Register Index  |              |       |
A binary value indexing the register where data is to be accessed.
| Bits 7-5  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Sequencer Data Register (SEQ_DATA)
| Read/Write  |     | Address: 3C5H  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is the data port for the sequencer register indexed by the Sequencer Index register (3C4H).
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
SEQ DATA
| Bits 7-0  | SEQ DATA -Sequencer Register Data  |     |     |
| --------- | ---------------------------------- | --- | --- |
Data to the sequencer register indexed by the sequencer address index.
VGA REGISTER DESCRIPTIONS  16-5

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Reset Register (RST _SYNC) (SRO)
| Read/Write  |     | Address: 3C5H, Index DOH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| Bit 0  | ASY RST -Asynchronous Reset  |     |     |
| ------ | ---------------------------- | --- | --- |
This bit is for VGA software compatibility only. It has no function for the Tri064V+.
| Bit 1  | SYN RST -Synchronous Reset  |     |     |
| ------ | --------------------------- | --- | --- |
This bit is for VGA software compatibility only. It has no function for the Tri064V+.
| Bits 7-2  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Clocking Mode Register (ClK_MODE) (SR1)
| Read/Write  |     | Address: 3C5H, Index 01 H  |     |
| ----------- | --- | -------------------------- | --- |
Power-On Default: OOH
This register controls the operation mode of dot clock and character clock.
| 7  6    | 5  4                     | 3  2      | 1  0     |
| ------- | ------------------------ | --------- | -------- |
|         | SCRN  SHF                | DCK  SHF  |          |
| =0  =0  | OFF  4                   | 1/2  LD   | =0  80C  |
| Bit 0   | 80C -8 Dot Clock Select  |           |          |
o = Character clocks 9 dots wide are generated
1 = Character clocks 8 dots wide are generated
| Bit 1  | Reserved = 0                                           |     |     |
| ------ | ------------------------------------------------------ | --- | --- |
| Bit 2  | SHF lD -Load Serializers Every Second Character Clock  |     |     |
o = Load the video serializer every character clock
1 = Load the video serializers every other character clock
| Bit 3  | DCK 1/2 -Internal character clock = 1/2 DCLK  |     |     |
| ------ | --------------------------------------------- | --- | --- |
0= Set the internal character clock to the same frequency as DCLK
1 = Set the internal character clock to 1/2 the frequency of DCLK
| Bit 4  | SHF 4 -Load Serializers Every Fourth Character Clock  |     |     |
| ------ | ----------------------------------------------------- | --- | --- |
o = Load the serializers every character clock cycle
1 = Load the serializers every fourth character clock cycle
16-6 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bit 5 SCRN OFF -Screen Off
o = Screen is turned on.
1 = Screen is turned off
Bits 7-6 Reserved = 0
Enable Write Plane Register (EN_WT _PL) (SR2)
Read/Write Address: 3C5H, Index 02H
Power-On Default: OOH
This register selects write protection or write permission for CPU write access into video memory.
3 2 1 o
EN'wT.PL.
Bits 3-0 EN.WT.PL -Enable Write to a Plane
0= Disables writing into the corresponding plane
1 = Enables the CPU to write to the corresponding color plane
Bits 7-4 Reserved = 0
VGA REGISTER DESCRIPTIONS 16-7

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Character Font Select Register (CH_FONT _SL) (SR3)
Read/Write
Address: 3C5H, Index 03H
Power-On Default: OOH
|         |           | J     | I     |
| ------- | --------- | ----- | ----- |
| 7  6    | 5  4      | 3  2  | 1  0  |
|         | SLA  SLB  | SLA   | SLB   |
|         |           | a     | a     |
| =0  =0  | 2  2      | 1     | 1     |
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
|              | all  Seventh 8K of plane 2  |     | 111  Eighth 8K of plane 2  |
| Bits 5, 3-2  | SLA -Select Font A          |     |                            |
This value selects the portion of plane 2 used to generate text character fonts when
bit 3 of attribute byte is a logical 0, according to the same table as the character font
select A.
| Bits 7-6  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
16-8 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Memory Mode Control Register (MEM_MODE) (SR4)
| Read/Write  |     | Address: 3C5H, Index 04H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register controls CPU memory addressing mode.
| 7  6    | 5  4    | 3  2      | 1  0  |
| ------- | ------- | --------- | ----- |
|         |         | CHN  SEQ  | EXT   |
|         |         | 4M  MODE  | MEM   |
| =0  =0  | =0  =0  |           | =0    |
Reserved = 0
Bit 0
| Bit 1  | EXT MEM -Extended Memory Access  |     |     |
| ------ | -------------------------------- | --- | --- |
0= Memory access restricted to 16/32 KBytes
1 = Allows complete memory access to 256 KBytes. Required for VGA
| Bit 2  | SEQ MODE -Sequential Addressing Mode  |     |     |
| ------ | ------------------------------------- | --- | --- |
This bit affects only CPU write data accesses into video memory. Bit 3 of this register
must be 0 for this bit to be effective.
o = Enables the odd/even addressing mode. Even addresses access planes 0 and 2.
Odd addresses access planes 1 and 3
1 = Directs the system to use a sequential addressing mode
| Bit 3  | CHN 4M -Select Chain 4 Mode  |     |     |
| ------ | ---------------------------- | --- | --- |
0= Enables odd/even mode.
1 = Chain 4 Mode. This bit selects modulo 4 addressing for CPU access to display
memory. A logical 1 directs the two lower order bits of the CPU address used to
select the plane in video memory to be accessed as follows:
A1  AO
Plane Selected
|     | 0  0  | 0   |     |
| --- | ----- | --- | --- |
|     | 0  1  | 1   |     |
0
|           | 1             | 2   |     |
| --------- | ------------- | --- | --- |
|           | 1  1          | 3   |     |
| Bits 7-4  | Reserved = 0  |     |     |
VGA REGISTER DESCRIPTIONS  16-9

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Unlock Extended Sequencer Register (SR8)
| Read/Write  |     | Address: 3C5H, Index 08H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
Loading xxxx0110b (e.g., 06H) unlocks accessing of all the S3 extensions (SR9 -SR1C) to the standard
VGA Sequencer register set. (x = don't care).
| 7   | 6  5  | 4  3  | 2       | o   |
| --- | ----- | ----- | ------- | --- |
| R   | R  R  | R     |         |     |
|     |       | =0    | =1  =1  | =0  |
Extended Sequencer 9 Register (SR9)
| Read/Write  |     | Address: 3C5H, Index 09H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
6
|           | I :  I :                                           | I :  I :  | I  I :  | I   |
| --------- | -------------------------------------------------- | --------- | ------- | --- |
|           | R                                                  |           | R       |     |
| Bits 6-0  | Reserved                                           |           |         |     |
| Bit 7     | MMIO-ONLY -Memory-mapped I/O register access only  |           |         |     |
0= When MMIO is enabled, both programmed I/O and memory-mapped I/O register
accesses are allowed
1 = When MMIO is enabled, only memory-mapped I/O register accesses are allowed
Extended Sequencer A Register (SRA)
| Read/Write  |     | Address: 3C5H, Index OAH  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
| 7         | 6  5       | 4  3  | 2  1  | 0   |
| --------- | ---------- | ----- | ----- | --- |
| 2         | P50  PD-   |       |       |     |
| MCLK      | SEL  NTRI  | R  R  | R  R  | R   |
| Bits 4-0  | Reserved   |       |       |     |
16-10 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
| Bit 5  | PD-NTRI -PD[63:0] Not Tri-stated  |     |     |
| ------ | --------------------------------- | --- | --- |
o
= PD[63:0] tri-stated
1 = PD[63:0] not tri-stated
The default value of 0 reduces power consumption. The pins are enabled for output
only as needed. Note that output pads for PD[63:29] also latch the most recent output
state.
| Bit 6  | P50 SEL -Pin 50 Function Select  |     |     |
| ------ | -------------------------------- | --- | --- |
o = If bit 2 of CR36 is set to 1 to indicate fast page memory, pin 50 outputs a signal
equivalent to OEO (fast page) or OE1 (EDO). This setting should always be used
with 1-or 2-MByte memory configurations. With this setting and EDO memory,
the OE1 output is held high whenever Tri064-compatible VAFC feature connector
operation is enabled (SRD_1 = 0). This disables output to the multiplexed PO
lines.
1 = Pin 50 outputs RAS1 for either fast page or EDO memory. This setting should
always (and only) be used for 4-MByte configurations. Tri064-compatible VAFC
feature connector operation cannot be used with this setting and should never be
enabled.
| Bit 7  | 2MCLK -2 MCLK CPU writes to memory  |     |     |
| ------ | ----------------------------------- | --- | --- |
o = 3 MCLK memory writes
1 = 2 MCLK memory writes
Setting this bit to 1 improves performance for systems using an MCLK less than 57
MHz. For MCLK frequencies between 55 and 57 MHz, bit 7 of SR15 should also be set
to 1 if linear addressing is being used.
Extended Sequencer B Register (SRB)
| Read/Write  |     | Address: 3C5H, Index OBH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  I  6          | I  5  I  4                      | 3  2    | 1  0        |
| ---------------- | ------------------------------- | ------- | ----------- |
|                  |                                 | 24      | VAFC  DOT=  |
| AL T COLOR MODE  |                                 |         | VCLKI       |
|                  |                                 | BPP  R  | VCLKI       |
| Bit 0            | DOT = VCLKI -Dot clock = VCLKI  |         |             |
o = Use internal dot clock
1 = Use VCLKI input for all internal dot clock functions
This bit is used for S3 test purposes only.
| Bit 1  | VAFC VCLKI -Use VCLKI input with VAFC  |     |     |
| ------ | -------------------------------------- | --- | --- |
o = Pixel data from pass-through feature connector latched by incoming VCLK
1 = Pixel data from VAFC latched by VCLKI input
| Bit 2  | Reserved  |     |     |
| ------ | --------- | --- | --- |
VGA REGISTER DESCRIPTIONS  16-11

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bit 3 24 BPP -24 Bits/Pixel (packed Mode 12)
o
= 24 bits/pixel operation disabled
1 = 24 bits/pixel operation enabled if both SRB_7-4 = 0111 band CR67 _7-4 = OOOOb
Bits 7-4 ALT COLOR MODE -Color Mode for feature connector input
0000 = Mode 0: 8-bit color, 1 pixelNCLK
0001 = Mode 8: 8-bit color, 2 pixelsNCLK
0011 = Mode 9: 15-bit color, 1 pixelNCLK
0101 = Mode 10: 16-bit color, 1 pixelNCLK
0111 = Mode 12: Packed 24-bit color, 1 pixel/3 VCLKs
1101 = Mode 13: 24-bit color, 1 pixelNCLK
All other mode values are reserved. Setting mode 0001 (clock doubled mode) also re
quires that either bit 4 or bit 6 of SR15 be set to 1 and that bit 7 of SR18 be set to 1.
Clock doubling cannot be used with the Streams Processor active.
Extended Sequencer D Register (SRD)
Read/Write Address: 3C5H, Index ODH
Power-On Default: OOH
This register provides feature connector control and also provides independent control of the
HSYNC and VSYNC signals, therefore supporting the VESA DPMS (Display Power Management Con
trol) standard.
I I
7 6 5 4 3 2 1 0
VSY-CTL HSY-CTL R R LPB EN-
1 0 1 0 FEAT FEAT
Bit 0 EN-FEAT -Enable Feature Connector
0= ENFEAT (pin 151) is high. VCLK, HSYNC and VSYNC are outputs.
1 = ENFEAT (pin 151) is low. The direction ofVCLK is controlled by EVCLK and the
direction of BLANK, HSYNC and VSYNC is controlled by ESYNC. In both cases,
assertion (low) specifies an input and a logic high specifies an output.
o.
This bit is set to 1 to drive pin 151 with a logic This enables the feature connector
buffers required when the Tri064-compatible VAFC feature connector is enabled for
memory configuration of 2 MBytes or larger.
Bit 1 LPB FEAT -Select LPB Feature Connector
0= Tri064-type VAFC feature connector (using multiplexed PD pins)
1 = LPB VAFC feature connector
The LPB must be disabled and feature connector operation enabled for this bit to
have an effect.
Bits 3-2 Reserved
16-12 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bits 5-4 HSY-CTL -HSYNC Control
00 = Normal operation
01 = HSYNC = 0
10 = HSYNC = 1
11 = Reserved
Bits 7-6 VSY-CTL -VSYNC Control
00 = Normal operation
01 = VSYNC = 0
10 = VSYNC = 1
11 = Reserved
MCLK Value Low Register (SR10)
Read/Write Address: 3C5H, Index 10H
Power-On Default: See description below.
The power-on default value for this register in conjunction with the power-on default value for SR11
generate an MCLK value of 45 MHz. All other MCLK values must be specified by programming of
SR10 and SR11. Loading of a new value is enabled by either bit 0 or bit 5 of SR15.
Bits 4-0 PLL N-DIVIDER VALUE
These bits contain the binary equivalent ofthe integer (1-31) divider used to scale the
input to the MCLK PLL. See Section 9 for a detailed explanation.
Bits 6-5 PLL R VALUE
These bits contain the binary equivalent of the integer (1,2, 4,8) range value used to
scale the output of the MCLK PLL. See Section 9 for a detailed explanation.
Bit 7 Reserved
VGA REGISTER DESCRIPTIONS 16-13

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
MCLK Value High Register ISR11)
| Read/Write  | Address: 3C5H, Index 11 H  |     |
| ----------- | -------------------------- | --- |
Power-On Default: See description below.
The power-on default value for this register in conjunction with the power-on default value for SR10
generate an MCLK value of 45 MHz. All other MCLK values must be specified by programming of
SR10 and SR11. Loading of a new value is enabled by either bit 0 or bit 5 of SR15.
o
| 7  6      | 543                  | 2   |
| --------- | -------------------- | --- |
| R         | PLL M-DIVIDER VALUE  |     |
| Bits 6-0  | PLL M-DIVIDER VALUE  |     |
These bits contain the binary equivalent of the integer (1-127) divider used in the feed
back loop of the MCLK PLL. See Section 9 for a detailed explanation.
| Bit 7  | Reserved  |     |
| ------ | --------- | --- |
DCLK Value Low Register (SR12)
| Read/Write  | Address: 3C5H, Index 12H  |     |
| ----------- | ------------------------- | --- |
Power-On Default: See description below.
The power-on default value for this register in conjunction with the power-on default value for SR13
generate a DCLK value of 25.175 MHz. The default value is automatically placed in this register when
bits 3-2 of 3C2H are programmed to OOb. If bits 3-2 of CR2H are programmed to 01b, the appropriate
PLL Rand PLL N values for a 28.322 MHz DCLK will automatically be placed in this register. All other
DCLK values must be specified by programming of SR12 and SR13. Loading of a new value is enabled
by either bit 1 or bit 5 of SR15 and by setting bits 3-2 of 3C2H to 11b.
| Bits 4-0  | N-DIVIDER VALUE  |     |
| --------- | ---------------- | --- |
These bits contain the binary equivalent of the integer (1-31) divider used to scale the
input to the DCLK PLL. See Section 9 for a detailed explanation.
| Bits 6-5  | PLL R VALUE  |     |
| --------- | ------------ | --- |
These bits contain the binary equivalent ofthe integer (1, 2, 4, 8) range value used to
scale the output of the DCLK PLL. See Section 9 for a detailed explanation.
16-14 VGA REGISTER DESCRIPTIONS

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bit 7  | CLKx2 -Enable clock doubled mode  |     |     |     |
| ------ | --------------------------------- | --- | --- | --- |
a = RAMDAC clock doubled mode (0001) disabled
1 = RAMDAC clock doubled mode (0001) enabled
This bit must be set to 1 when mode 0001 is specified in bits 7-4 of CR67 or SRC.
Either bit 4 or bit 6 of SR15 must also be set to 1. This bit has the same function as
SR18_7. It allows enabling of clock doubling at the same time as the PLL parameters
are programmed, resulting in more controlled VCO operation.
DCLK Value High Register (SR13)
| Read/Write  |     | Address: 3C5H, Index 13H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: See description below.
The power-on default value for this register in conjunction with the power-on default value for SR12
generate a DCLK value of 25.175 MHz. The default value is automatically placed in this register
when bits 3-2 of 3C2H are programmed to OOb. If bits 3-2 of CR2H are programmed to alb, the ap
propriate PLL M value for a 28.322 MHz DCLK will automatically be placed in this register. All other
DCLK values must be specified by programming of SR12 and SR13. Loading of a new value is en
abled by either bit 1 or bit 5 of SR15 and by setting bits 3-2 of 3C2H to llb.
| 7  6      | 543                  |     | 2   | o   |
| --------- | -------------------- | --- | --- | --- |
| R         | PLL M-DIVIDER VALUE  |     |     |     |
| Bits 6-0  | PLL M-DIVIDER VALUE  |     |     |     |
These bits contain the binary equivalent of the integer (1-127) divider used in the feed
back loop of the DCLK PLL. See Section 9 for a detailed explanation.
| Bit 7  | Reserved  |     |     |     |
| ------ | --------- | --- | --- | --- |
CLKSVN Control 1 Register (SR14)
| Read/Write  |     | Address: 3C5H, Index 14H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
| 7  6        | 5  4                          | 3     | 2    | 1  0        |
| ----------- | ----------------------------- | ----- | ---- | ----------- |
| EXT  EXT    | P151  CLR                     | M     | EN   | MPLL  DPLL  |
| DCLK  MCLK  | SEL  CNT                      | TEST  | CNT  | PD  PD      |
| Bit 0       | DPLL PD -Power down DCLK PLL  |       |      |             |
a = DCLK PLL powered
1 = DCLK PLL powered down
This bit is used for S3 test purposes only.
VGA REGISTER DESCRIPTIONS  16-15

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Bit 1 MPLL PO -Power down MCLK PLL
o = MCLK PLL powered
1 = MCLK PLL powered down
This bit is used for S3 test purposes only.
Bit 2 EN CNT -Enable clock synthesizer counters
o
= Clock synthesizer counters disabled
1 = Clock synthesizer counters enabled
This bit is used for S3 test purposes only.
Bit 3 M TEST -MCLK Test
0= Test DCLK
1 = Test MCLK
This bit is used for S3 test purposes only.
Bit 4 CLR CNT -Clear clock synthesizer counters
0= No effect
1 = Clear the clock synthesizer counters
This bit is used for S3 test purposes only.
Bit5 P151 SEL-Pin 151 function select
0= Pin 151 functions normally
1 = Pin 151 is tri-stated
Setting this bit to 1 allows pin 151 to act as an MCLK input. This is enabled by setting
bit 6 of this register to 1.
Bit 6 EXT MCLK -External MCLK Select
o
= MCLK provided by internal PLL
1 = MCLK is input on pin 151
This bit can also be set to 1 at reset via power-on strapping of PD11. An external
MCLK is only used for S3 test purposes.
Bit 7 EXT DCLK -External DCLK Select
o = DCLK provided by internal PLL
1 = DCLK is input on pin 156.
This bit can also be set to 1 at reset via power-on strapping of PD11. An external
DCLK is only used for S3 test purposes.
16-16 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
CLKSVN Control 2 Register (SR15)
| Read/Write  |     | Address: 3C5H, Index 15H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6          | 5  4                                     | 3  2        | 1  0        |
| ------------- | ---------------------------------------- | ----------- | ----------- |
| 2 CYC  DCLK\  | CLK  DCLK/                               | VCLK  MCLK  | DRFQ  MFRQ  |
| MWR  INV      | LOAD  2                                  | OUT  OUT    | EN  EN      |
| Bit 0         | MFRQ EN -Enable new MCLK frequency load  |             |             |
o = Register bit clear
1 = Load new MCLK frequency
When new MCLK PLL values are programmed, this bit can be set to 1 to load these
values in the PLL. The loading may be delayed a small but variable amount of time.
This bit should be cleared to 0 after loading to prevent repeated loading. Alternately,
use bit 5 of this register to produce an immediate load.
| Bit 1  | DFRQ EN -Enable new DCLK frequency load  |     |     |
| ------ | ---------------------------------------- | --- | --- |
o  = Register bit clear
1 = Load new DCLK frequency
When new DCLK PLL values are programmed, this bit can be set to 1 to load these
values in the PLL. Bits 3-2 of 3C2H must also be set to 11b ifthey are not already at
this value. The loading may be delayed a small but variable amount of time. This bit
should be programmed to 1 at power-up to allow loading of the VGA DCLK value and
then left at this setting. Use bit 5 of this register to produce an immediate load.
| Bit 2  | MCLK OUT -Output internally generated MCLK  |     |     |
| ------ | ------------------------------------------- | --- | --- |
0= Pin 147 functions normally
1 = Pin 147 outputs the internally generated MCLK
This is used only for testing.
| Bit 3  | VCLK OUT -VCLK direction determined by EVCLK  |     |     |
| ------ | --------------------------------------------- | --- | --- |
0= Pin 148 outputs the internally generated VCLK regardless of the state of EVCLK
1 = VCLK direction is determined by the EVCLK signal
This bit is effective only when the LPB feature connector is enabled.
| Bit 4  | DCLK/2 -Divide DCLK by 2  |     |     |
| ------ | ------------------------- | --- | --- |
o = DCLK unchanged
1 = Divide DCLK by 2
Either this bit or bit 6 of this register must be set to 1 for clock doubled RAMDAC op
eration (mode 0001).
VGA REGISTER DESCRIPTIONS  16-17

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bit 5  | CLK LOAD -MCLK, DCLK load  |     |     |
| ------ | -------------------------- | --- | --- |
o
= Clock loading is controlled by bits 0 and 1 of this register
1 = Load MCLK and DCLK PLL values immediately
To produce an immediate MCLK and DCLK load, program this bit to 1 and then to o.
Bits 3-2 of 3C2H must also then be programmed to 11 b to load the DCLK values if
they are not already programmed to this value. This register must never be left set to
1.
| Bit 6  | DCLK INV -Invert DCLK  |     |     |
| ------ | ---------------------- | --- | --- |
o = DCLK unchanged
1 = Invert DCLK
Either this bit or bit 4 of this register must be set to 1 for clock doubled RAMDAC op
eration (mode 0001).
| Bit 7  | 2 CYC MWR -Enable 2 cycle memory write  |     |     |
| ------ | --------------------------------------- | --- | --- |
o
= 3 MCLK memory write
1 = 2 MCLK memory write
Setting th is bit to 1 bypasses the VGA logic for linear addressing when bit 7 of SRA is
set to 1. This can allow 2 MCLK operation for MCLK frequencies between 55 and 57
MHz.
CLKSYN Test High Register (SR16)
| Read/Write  |     | Address: 3C5H, Index 16H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register is reserved for S3 testing of the internal clock synthesizer.
o
| 7  6  | 5  4  | 3  2  | 1     |
| ----- | ----- | ----- | ----- |
| R  R  | R  R  | R  R  | R  R  |
CLKSYN Test Low Register (SR17)
| Read Only  |     | Address: 3C5H, Index 17H  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register is reserved for S3 testing of the internal clock synthesizer.
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
| R  R  | R  R  | R  R  | R  R  |
16-18 VGA REGISTER DESCRIPTIONS

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
RAMDAC/CLKSVN Control Register (SR18)
| Read/Write  |     | Address: 3C5H, Index 18H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6       | 5  4                         | 3  2      | 1  0      |
| ---------- | ---------------------------- | --------- | --------- |
| CLKx  LUT  | DAC  TST                     | TST  TST  | TST  TST  |
| 2  WR      | PD  BLUE                     | GRN  RED  | RST  EN   |
| Bit 0      | TST EN -Enable test counter  |           |           |
o = RAMDAC test counter disabled
1 = RAMDAC test counter enabled
This bit is used for S3 test purposes only.
| Bit 1  | TST RST -Reset test counter  |     |     |
| ------ | ---------------------------- | --- | --- |
0= No effect
1 = Reset the RAMDAC test counter
This bit is used for S3 test purposes only.
| Bit 2  | TST RED -Test red data  |     |     |
| ------ | ----------------------- | --- | --- |
0= No effect
1 = Place red data on internal data bus
This bit is used for S3 test purposes only.
| Bit 3  | TST GRN -Test green data  |     |     |
| ------ | ------------------------- | --- | --- |
0= No effect
1 = Place green data on internal data bus
This bit is used for S3 test purposes only.
| Bit 4  | TST BLUE -Test blue data  |     |     |
| ------ | ------------------------- | --- | --- |
0= No effect
1 = Place blue data on internal data bus
This bit is used for S3 test purposes only.
| Bit 5  | DAC PD -RAMDAC power-down  |     |     |
| ------ | -------------------------- | --- | --- |
o = RAMDAC powered
1 = RAMDAC powered-down
When the RAMDAC is powered down, the RAMDAC memory retains its data.
| Bit 6  | LUT WR -LUT write cycle control  |     |     |
| ------ | -------------------------------- | --- | --- |
0=2 DCLK LUT write cycle (default)
1 = 1 DCLK LUT write cycle
VGA REGISTER DESCRIPTIONS  16-19

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
| Bit 7  | CLKx2 -Enable clock doubled mode  |     |     |
| ------ | --------------------------------- | --- | --- |
0= RAMDAC clock doubled mode (O001) disabled
1 = RAMDAC clock doubled mode (0001) enabled
This bit must be set to 1 when mode 0001 is specified in bits 7-4 of CR67 or SRC.
Either bit 4 or bit 6 of SR15 must also be set to 1.
Extended Sequencer 1C Register (SR1C)
| Read/Write  |     | Address: 3C5H, Index 1CH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
The bits in this register are effective only in LPB mode.
| 7  6      | 5  4                   | 3  2  | 1  0    |
| --------- | ---------------------- | ----- | ------- |
| R  R      | R  R                   | R  R  | SIGSEL  |
| Bits 1-0  | SIGSEL -Signal Select  |       |         |
(For VL)
00 = Pin 151 is ENFEAT; pin 153 is ROMCS
01 = Pin 151 is GPIOSTR; pin 153 is ROMCS
10 = Pin 151 is GOPO; pin 153 is ROMCS
11 = Pin 151 is GOPO; pin 153 is GOP1
(For PCI)
00 = Pin 151 is ENFEAT; pin 153 is ROMEN, pin 190 is STWR
01 = Pin 151 is reserved; pin 153 is ROMEN, pin 190 is STWR
10 = Pin 151 is GOPO; pin 153 is ROMEN, pin 190 is GOP1
11 = Pin 151 is GOPO; pin 153 is ROMEN, pin 190 is GOP1
GOPO and GOP1 are bits 0-1 of the General Output Port register (CR5C).
When the system powers up with a default value of OOb for bits 1-0, both pin 151 and
pin 153 will be driven high (logic 1).
| Bits 7-2  | Reserved  |     |     |
| --------- | --------- | --- | --- |
16-20 VGA REGISTER DESCRIPTIONS

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
16.3 CRT CONTROLLER REGISTERS
The CRT controller registers are located at two locations in I/O address space. These registers are
accessed by first writing to the index register of the CRT controller and then accessing the data register.
The index register is located at I/O address 3?4H and the CRT Controller Data register is at 3?5H. Which
address is used (3BX or 3DX) depends on bit 0 of the Miscellaneous Output register at 3C2H. A word
write of both address and data at 3?4H can also be performed.
CRT Controller Index Register (CRTC_ADR) (CRX)
Read/VVrite Address: 3?4H
Power-On Default: OOH
This register is loaded with a binary value that indexes the CRT controller register where data is to be
accessed. This value is referred to as the "Index Number" of the CR register (CROO-18). This register
is also used as an index to the S3 VGA registers, the System Control Registers and the System Extension
registers.
7 6 543 2 o
CRTC ADDRESS
Bits 7-0 CRTC ADDRESS -CRTC Register Index
A binary value indexing the register where data is to be accessed.
CRT Controller Data Register (CRTC_DATA) (CRT)
Read/VVrite Address: 3?5H
Power-On Default: Undefined
This register is the data port for the CRT controller register indexed by the CRT Controller Address
register.
7 6 5 4 3 2 o
CRTC DATA
Bits 7-0 CRTC DATA -CRTC Register Data
Data to the CRT controller register indexed by the CRT controller address index.
VGA REGISTER DESCRIPTIONS 16-21

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Horizontal Total Register (H_TOTAL) (CRO)
| Read/Write  | Address: 3?5H, Index OOH  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: Undefined
This register defines the number of character clocks from HSYNC going active to the next HSYNC going
active. In other words, it is the total time required for both the displayed and non-displayed portions
of a single scan line. Bit 8 of this value is bit 0 of CR5D.
| 7  6  | 543  | 2   | o   |
| ----- | ---- | --- | --- |
HORIZONTAL TOTAL
| Bits 7-0  | HORIZONTAL TOTAL.  |     |     |
| --------- | ------------------ | --- | --- |
9-bit Value = (number of character clocks in one scan line) -5. This register contains
the least significant 8 bits of this value.
Horizontal Display End Register (H_D_END) (CR1)
| Read/Write  |     | Address: 3?5H, Index 01 H  |     |
| ----------- | --- | -------------------------- | --- |
Power-On Default: Undefined
This register defines the number of character clocks for one line ofthe active display. Bit 8 of this value
is bit 1 of CR5D.
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
HORIZONTAL DISPLAY END
| Bits 7-0  | HORIZONTAL DISPLAY END  |     |     |
| --------- | ----------------------- | --- | --- |
9-bit Value = (number of character clocks of active display) -1. This register contains
the least significant 8 bits of this value.
16-22 VGA REGISTER DESCRIPTIONS

••
r
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Start Horizontal Blank Register (S_H_BLNKI (CR21
| Read/Write  |     | Address: 3?5H, Index 02H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: Undefined
This register specifies the value of the character clock counter at which the BLANK signal is asserted.
Bit 8 of this value is bit 2 of CR5D.
o
| 7   | 6  543  |     | 2   |     |
| --- | ------- | --- | --- | --- |
START HORIZONTAL BLANK
| Bits 7-0  | START HORIZONTAL BLANK  |     |     |     |
| --------- | ----------------------- | --- | --- | --- |
9-bit Value = character clock value at which horizontal blanking begins. This register
contains the least significant 8 bits of this value.
End Horizontal Blank Register (E_H_BLNKI (CR31
| Read/Write  |     | Address: 3?5H, Index 03H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: Undefined
This register determines the pulse width of the BLANK signal and the display enable skew.
|     | I     | I     | I   | I  I  |
| --- | ----- | ----- | --- | ----- |
| 7   | 6  5  | 4  3  | 2   | 1  0  |
DSP-SKW
| R         | 1  0                  | END HORIZONTAL BLANK  |     |     |
| --------- | --------------------- | --------------------- | --- | --- |
| Bits 4-0  | END HORIZONTAL BLANK  |                       |     |     |
7-bit Value = least significant 7 bits of the character clock counter value at which time
horizontal blanking ends. To obtain this value, add the desired BLANK pulse width in
character clocks to the Start Horizontal Blank value, which is also in character clocks.
The 5 least significant bits of this sum are programmed into this field. The sixth bit is
programmed into bit 7 of CR5. The seventh bit is programmed into bit 3 of CR5D.
| Bits 6-5  | DSP-SKW -Display Skew  |     |     |     |
| --------- | ---------------------- | --- | --- | --- |
These two bits determine the amount of display enable skew. Display enable skew
control provides sufficient time for the CRT Controller to access the display buffer to
obtain a character and attribute code, access the character generator font, and then
go through the Horizontal Pixel Panning register in the Attribute Controller. Each ac
cess requires the display enable signal to be skewed one character clock unit so the
video output is synchronous with the HSYNC and VSYNC signals. The bit values and
amount of skew are shown in the following table:
00 = Zero character clock skew
01 = One character clock skew
10 = Two character clock skew
11 = Three character clock skew
| Bit 7  | Reserved  |     |     |     |
| ------ | --------- | --- | --- | --- |
VGA REGISTER DESCRIPTIONS  16-23

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Start Horizontal Sync Position Register (S_H_SV _PI (CR4)
Read/Write Address: 3?5H, Index 04H
Power-On Default: Undefined
This register is used to adjust the screen center horizontally and to specify the character position at
which HSYNC becomes active. Bit 8 of this value is bit 4 of CR5D.
Bits 7-0 START HORIZONTAL SYNC POSITION.
9-bit Value = character clock counter value at which HSYNC becomes active. This reg
ister contains the least significant 8 bits of this value.
End Horizontal Sync Position Register (E_H_SY _PI (CR51
Read/Write Address: 3?5H, Index 05H
Power-On Default: Undefined
This register specifies when the HSYNC signal becomes inactive and the horizontal skew. The HSYNC
pulse defined by this register can be extended by 32 DCLKs via bit 5 of CR5D.
7 6 I 5 4 I 3 I 2 I 1 I 0
EHB HOR-SKW
b5 1 0 END HORIZONTAL SYNC POS
Bits 4-0 END HORIZONTAL SYNC POS
6-bit Value = 6 least significant bits of the character clock counter value at which time
HSYNC becomes inactive. To obtain this value, add the desired HSYNC pulse width in
character clocks to the Start Horizontal Sync Position value, also in character clocks.
The 5 least significant bits ofthis sum are programmed into this field. The sixth bit is
programmed into bit 5 of CR5D.
Bits 6-5 HOR-SKW -Horizontal Skew
These bits control the skew of the HSYNC signal. A binary 00 equals no HSYNC delay.
For some modes, it is necessary to provide an HSYNC signal that takes up the entire
blanking interval. Some internal timings are generated by the falling edge of the
HSYNC signal. To guarantee the signals are latched properly, HSYNC is asserted be
fore the end of the display enable signal, and then skewed several character clock
times to provide the proper screen centering.
00 = Zero character clock skew
01 = One character clock skew
10 = Two character clock skew
11 = Three character clock skew
Bit 7 EHB b5
End Horizontal Blanking bit 5.
16-24 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Vertical Total Register (V_TOTAL) (CRG)
| Read/Write  |     | Address: 3?5H, Index 06H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the number of scan lines from one VSYNC active to the next VSYNC active.
The scan line counter resets to 0 at this point. Bit 8 is bit 0 of CR7. Bit 9 is bit5 of CR7. Bit 10 is bit 0
of CR5E.
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
VERTICAL TOTAL
| Bits 7-0  | VERTICAL TOTAL  |     |     |
| --------- | --------------- | --- | --- |
11-bit Value = (number of scan lines from VSYNC active to the next VSYNC active) -2.
This register contains the least significant 8 bits of this value.
CRTC Overflow Register (OVFL_REG) (CR7)
| Read/Write  |     | Address: 3?5H, Index 07H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6      | 5  4     | 3  2      | 1  0     |
| --------- | -------- | --------- | -------- |
| VRS  VDE  | VT  LCM  | SVB  VRS  | VDE  VT  |
| 9  9      | 9  8     | 8  8      | 8  8     |
This register provides extension bits for fields in other registers.
| Bit 0  | Bit 8 of the Vertical Total register (CR6)           |     |     |
| ------ | ---------------------------------------------------- | --- | --- |
| Bit 1  | Bit 8 of the Vertical Display End register (CR12)    |     |     |
| Bit 2  | Bit 8 of the Vertical Retrace Start register (CR10)  |     |     |
| Bit 3  | Bit 8 of the Start Vertical Blank register (CR15)    |     |     |
Bit 8 of the Line Compare register (CR18)
Bit 4
| Bit 5  | Bit 9 of the Vertical Total register (CR6)           |     |     |
| ------ | ---------------------------------------------------- | --- | --- |
| Bit G  | Bit 9 of the Vertical Display End register (CR12)    |     |     |
| Bit 7  | Bit 9 of the Vertical Retrace Start register (CR10)  |     |     |
VGA REGISTER DESCRIPTIONS  16-25

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Preset Row Scan Register (P _R_SCAN) (CR8)
| Read/Write  |     | Address: 3?5H, Index 08H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register is used for the pixel scrolling and panning, and text formatting and vertical scrolling.
|       | I   | I  I  |                |
| ----- | --- | ----- | -------------- |
| 7  6  | 5   | 4  3  | 2  I  1  I  0  |
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
Maximum Scan Line Register (MA}CS_LN) (CR9)
| Read/Write  |     | Address: 3?5H, Index 09H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the number of scan lines per character row and provides one scanning control
bit and two overflow bits.
|           |                 | I  I            | I  I  |
| --------- | --------------- | --------------- | ----- |
| 7  6      | 5  4            | 3  2            | 1  0  |
| DBL  LCM  | SVB             |                 |       |
| SCN  9    | 9               | MAX SCAN LI NE  |       |
| Bits 4-0  | MAX SCAN LI NE  |                 |       |
Value = (number of scan lines per character row) -1
| Bit5  | SVB 9  |     |     |
| ----- | ------ | --- | --- |
Bit 9 of the Start Vertical Blank Register (CR 15)
| Bit 6  | LCM 9  |     |     |
| ------ | ------ | --- | --- |
Bit 9 of the Line Compare Register (CR18)
| Bit7  | DBL SCN  |     |     |
| ----- | -------- | --- | --- |
o = Normal operation
1 = Enables double scanning operation. Each line is displayed twice by repeating the
row scan counter and video memory address. Vertical parameters in the CRT
controller are not affected.
16-26 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Cursor Start Scan Line Register (CSSL) (CRA)
| Read/Write  |     | Address: 375H, Index OAH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
The cursor start register defines the row scan of a character line where the cursor begins.
|     |       | I  I  | I  I     |
| --- | ----- | ----- | -------- |
| 7   | 6  5  | 4  3  | 2  1  0  |
CSR
| =0        | =0  OFF                     | CSR CURSOR START SCAN LINE  |     |
| --------- | --------------------------- | --------------------------- | --- |
| Bits 4-0  | CSR CURSOR START SCAN LINE  |                             |     |
Value = (starting cursor row within the character cell) -1. When the cursor start regis
ter is programmed with a value greater than the cursor end register, no cursor is gen
erated.
| Bit5  | CSR OFF  |     |     |
| ----- | -------- | --- | --- |
0= Turns on the text cursor
1 = Turns off the text cursor
| Bits 7-6  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Cursor End Scan Line Register (CESL) (CRB)
| Read/Write  |     | Address: 375H, Index OBH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register defines the row scan of a character line where the cursor ends.
|     | I     | I  I  | I  I     |
| --- | ----- | ----- | -------- |
| 7   | 6  5  | 4  3  | 2  1  0  |
CSR-SKW
| =0        | 1  0                  | CURSOR END SCAN LINE  |     |
| --------- | --------------------- | --------------------- | --- |
| Bits 4-0  | CURSOR END SCAN LINE  |                       |     |
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
VGA REGISTER DESCRIPTIONS  16-27

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Start Address High Register (STA(H)) (CRC)
Read/Write Address: 3?5H, Index OCH
Power-On Default: Undefined
20-bit Value = the first address after a vertical retrace atwhich the display on the screen begins on each
screen refresh. These along with bits 5-0 of CR69 are the high order start address bits.
Start Address Low Register (STA(L)) (CRD)
Read/Write Address: 3?5H, Index ODH
Power-On Default: Undefined
7 65432 o
DISPLAY START ADDRESS (LOW)
Start address (low) contains the 8 low order bits of the address.
Cursor Location Address High Register (CLA(H)) (CRE)
Read/Write Address: 3?5H, Index OEH
Power-On Default: Undefined
20-bit Value = the cursor location address of the video memory where the text cursor is active. This
register along with bits 5-0 of CR69 are the high order bits of the address.
Cursor Location Address Low Register (CLA(L)) (CRF)
Read/Write Address: 3?5H, Index OFH
Power-On Default: Undefined
CURSOR LOCATION ADDRESS (LOW)
Cursor location address. (low) contains the 8 low order bits of the address.
16-28 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Vertical Retrace Start Register (VRS) (CR10)
| Read/Write  |     | Address: 3?5H, Index 10H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
VERTICAL RETRACE START
| Bits 7-0  | VERTICAL RETRACE START.  |     |     |
| --------- | ------------------------ | --- | --- |
11-bit Value = number of scan lines at which VSYNC becomes active. These are the
low-order 8 bits. Bit 8 is bit 2 of CR7. Bit 9 is bit 7 of CR7. Bit 10 is bit 4 of CR5E.
Vertical Retrace End Register (VRE) (CR11)
| Read/Write  |     | Address: 3?5H, Index 11H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OxH
This register controls the vertical interrupt and CRO-7
| 7  6       | 5  4                  | 3  I  2               | I  1  I  0  |
| ---------- | --------------------- | --------------------- | ----------- |
| LOCK  REF  | DIS  CLR              |                       |             |
| RO-7  3/5  | VINT  VINT            | VERTICAL RETRACE END  |             |
| Bits 3-0   | VERTICAL RETRACE END  |                       |             |
Value = least significant 4 bits of the scan line counter value at which VSYNC goes in
active. To obtain this value, add the desired VSYNC pulse width in scan line units to
the CR10 value, also in scan line units. The 41east significant bits of this sum are pro
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
0= Vertical retrace interrupt enabled if CR32_ 4 = 1
1 = Vertical interrupt disabled. This bit is cleared to 0 by the BIOS during a mode set,
a reset, or power-on
VGA REGISTER DESCRIPTIONS  16-29

, .
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bit 6  | REF 3/5-Refresh Cycle Select  |     |     |
| ------ | ----------------------------- | --- | --- |
o  = Three DRAM refresh cycles generated per horizontal line
1 = Five DRAM refresh cycles generated per horizontal line. Selecting five refresh
cycles allows use of the VGA chip with slow sweep rate displays (15.75 KHz).
This bit is cleared to 0 by the BIOS during a mode set, a reset, or power-on. This
setting can be overridden via bits 1-0 of CR3A
| Bit 7  | LOCK RO-7 -Lock Writes to CRT Controller Registers  |     |     |
| ------ | --------------------------------------------------- | --- | --- |
0= Writing to all CRT Controller registers enabled
1 = Writing to all bits of the CRT Controller registers CRO-CR7 except bit 4 of CR7
(LCM8) disabled. This bit is set to 1 by the BIOS during a mode set, a reset or
power-on
Vertical Display End Register (VDE) (CR12)
| Read/Write  |     | Address: 375H, Index 12H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
The vertical display enable end register defines 8 bits of the 10-bit address of the scan line where the
display on the screen ends. Bit 8 and Bit 9 are bits 1 and 6 of CR7. Bit 10 is bit 1 of CR5E.
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
VERTICAL DISPLAY END
| Bit 7-0  | VERTICAL DISPLAY END  |     |     |
| -------- | --------------------- | --- | --- |
11-bit Value = (number of scan lines of active display) -1. This register contains the
least significant 8 bits of this value.
Offset Register (SCREEN-OFFSET) (CR13)
| Read/Write  |     | Address: 375H, Index 13H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the logical line width of the screen and is sometimes called the screen pitch. The
starting memory address for the next display row is larger than the current row by two, four or eight
times this amount. Bits 5-4 of CR51 are extension bits 9-8 of this register. If these bits are OOb, bit 2 of
CR43 is extension bit 8 of this register.
o
| 7  6  | 5  4  | 3  2  |     |
| ----- | ----- | ----- | --- |
LOGICAL SCREEN WIDTH
| Bits 7-0  | LOGICAL SCREEN WIDTH  |     |     |
| --------- | --------------------- | --- | --- |
10-bit Value = quantity that is multiplied by 2 (word mode), 4 (doubleword mode) or 8
(quadword mode) to specify the difference between the starting byte addresses of
two consecutive scan lines. This register contains the least significant 8 bits of this
16-30 VGA REGISTER DESCRIPTIONS

fl·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
value. The addressing mode is specified by bit 6 of CR14 and bit 3 of CR17. Setting bit
3 of CR31 to 1 forces doubleword mode.
Underline Location Register (ULL) (CR14)
| Read/Write  | Address: 3?5H, Index 14H  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: Undefined
This register specifies the horizontal row scan position of underline and display buffer addressing
modes.
|           |                      | L 3  1  J            | I   |
| --------- | -------------------- | -------------------- | --- |
| 7  6      | 5  4                 | 2  1                 | 0   |
| DBWD      | CNT                  |                      |     |
| =0  MODE  | BY4                  | UNDER LINE LOCATION  |     |
| Bits 4-0  | UNDER LINE LOCATION  |                      |     |
5-bit Value = (scan line count of a character row on which an underline occurs) -1
| Bit 5  | CNT BY4 -Select Count by 4 Mode  |     |     |
| ------ | -------------------------------- | --- | --- |
0= The memory address counter depends on bit 3 of CR17 (count by 2)
1 = The memory address counter is incremented every four character clocks
The CNT BY4 bit is used when double word addresses are used.
| Bit 6  | DBLWD MODE -Select Doubleword Mode  |     |     |
| ------ | ----------------------------------- | --- | --- |
0= The memory addresses are byte or word addresses
1 = The memory addresses are doubleword addresses
| Bit 7  | Reserved = 0  |     |     |
| ------ | ------------- | --- | --- |
Start Vertical Blank Register (SVB) (CR15)
| Read/Write  |     | Address: 3?5H, Index 15H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register specifies the scan line at which the vertical blanking period begins. Bit 8 is bit 3 of CR7.
Bit 9 is bit 5 of CR9. Bit 10 is bit 2 of CR5E.
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
START VERTICAL BLANK
| Bits 7--0  | START VERTICAL BLANK.  |     |     |
| ---------- | ---------------------- | --- | --- |
11-bit value = (scan line count at which BLANK becomes active) -1. This register con
tains the least significant 8 bits of this value.
VGA REGISTER DESCRIPTIONS  16-31

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
End Vertical Blank Register (EVB) (CR16)
| Read/Write  |     | Address: 3?5H, Index 16H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: Undefined
This register specifies the scan line count value when the vertical blank period ends.
o
| 7  6  | 543  |     | 2   | 1   |
| ----- | ---- | --- | --- | --- |
END VERTICAL BLANK
| Bits 7-0  | END VERTICAL BLANK  |     |     |     |
| --------- | ------------------- | --- | --- | --- |
Value = least significant 8 bits of the scan line counter value at which vertical blank
ing ends. To obtain this value, add the desired width of the vertical blanking pulse in
scan lines to [(value in the Start Vertical Blank register)-1], also in scan lines. The 8
least significant bits ofthis sum are programmed into this field. This allows a maxi
mum vertical blanking pulse of 255 scan line units.
CRTC Mode Control Register (CRT _MO) (CR17)
| Read/Write  |     | Address: 3?5H, Index 17H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
This register is a multifunction control register, with each bit defining a different specification.
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
0= Row scan counter bit 1 is substituted for memory address bit 14 during active
display time
1 = Memory address bit 14 appears on the memory address output bit 14 signal of
the CRT controller
The combination of this bit and bit 0 of this register allows compatibility with Hercu
les HGC graphics memory mapping.
| Bit 2  | VT X2 -Select Vertical Total Double Mode  |     |     |     |
| ------ | ----------------------------------------- | --- | --- | --- |
o  = Horizontal retrace clock selected
1 = Horizontal retrace clock divided by two selected
16-32 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
This bit selects horizontal retrace clock or horizontal retrace clock divided by two as
the clock that controls the vertical timing counter. If the vertical retrace counter is
clocked with the horizontal retrace clock divided by 2, then the vertical resolution is
double.
Bit 3 CNT BY2 -Select Word Mode
0= Memory address counter is clocked with the character clock input, and byte mode
addressing for the video memory is selected
1 = Memory address counter is clocked by the character clock input divided by 2, and
word mode addressing for the video memory is selected
Bit 4 Reserved = 0
Bit 5 ADW 16K -Address Wrap
0= When word mode is selected by bit 6 of this register, memory address counter bit
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
o = Vertical and horizontal retrace pulses always inactive
1 = Vertical and horizontal retrace pulses enabled
This bit does not reset any other registers or outputs.
VGA REGISTER DESCRIPTIONS 16-33

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Line Compare Register (LCM) (CR18)
| ReadIWrite  |     | Address: 3?5H, Index 18H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register is used to implement a split screen function. When the scan line counter value is equal
to the content of this register, the memory address counter is cleared to o. The linear address counter
then sequentially addresses the display buffer starting at address o. Each subsequent row address is
determined by the addition of the Offset (CR13) register content. Bit 8 is bit 4 of CR7. Bit 9 is bit 6 of
CR9. Bit 10 is bit 6 of CR5E.
| 7  6  | 5  4  | 3  2  | o   |
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
16-34 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
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
VGA REGISTER DESCRIPTIONS 16-35

fl·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
16.4 GRAPHICS CONTROLLER REGISTERS
The graphics controller registers are located at a two byte I/O address space. These registers are
accessed by first writing an index to the Graphics Address register (at 3CEH) and then accessing the
Data register (at 3CFH).
Graphics Controller Index Register (GRC_ADR)
| Read/Write  |     | Address: 3CEH  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is loaded with a binary index value that determines which graphics controller register will
be accessed. This value is referred to as the "Index Number" of the GR register (GRO-6).
| 6   |     | 321  | 0   |
| --- | --- | ---- | --- |
GR CO NT ADDRESS
=0
Bits 3-0  GR CONT ADDRESS -Graphics Controller Register Index
A binary value indexing the register where data is to be accessed.
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Graphics Controller Data Register (GRC_DATA)
| Read/Write  |     | Address: 3CFH  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is the data port for the graphics controller register indexed by the Graphics Controller
Index register.
| 7  6  | 5  432  |     | o   |
| ----- | ------- | --- | --- |
GRAPHICS CONTROLLER DATA
| Bit 7-0  | GRAPHICS CONTROLLER DATA  |     |     |
| -------- | ------------------------- | --- | --- |
Data to the Graphics Controller register indexed by the graphics controller address.
16-36 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Set/Reset Data Register (SET/RST_DT) (GRO)
Read/Write Address: 3CFH, Index OOH
Power-On Default: Undefined
This register represents the value written to all 8 bits of the respective memory plane when the CPU
executes a memory write in write modes 0 and 3.
6 5 3 2 1 o
=0 =0 SET/RESET DATA
Bits 3-0 SET/RESET DATA
These bits become the color value for CPU memory write operations. In write mode
0, the set/reset data can be enabled on the corresponding bit of the Enable Set/Reset
Data register. In write mode 3, there is no effect on the Enable Set/Reset Data register.
Bits 7-4 Reserved = 0
Enable Set/Reset Data Register (EN_S/R_DTI (GR11
Read/Write Address: 3CFH, Index 01H
Power-On Default: Undefined
These bits enable the set/reset data, and affect write mode O.
6 5 4 321 0
=0 =0 =0 ENB SET/RST DATA
Bits 3-0 ENB SET/RST DATA
When each bit is a logical 1, the respective memory plane is written with the value of
the Set/Reset Data register. A logical 0 disables the set/reset data in a plane, and that
plane is written with the value of CPU write data.
Bits 7-4 Reserved = 0
VGA REGISTER DESCRIPTIONS 16-37

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Color Compare Register (COLOR-CMP) (GR2)
| Read/Write  |     | Address: 3CFH, Index 02H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
These bits represent a 4-bit color value to be compared. In read mode 1, the CPU executes a memory
read, the read  data is compared with this value and returns the results. This register works in
conjunction with the Color Don't Care register.
| 7  6      | 5  4                | 321                 | 0   |
| --------- | ------------------- | ------------------- | --- |
| =0  =0    | =0  =0              | COLOR COMPARE DATA  |     |
| Bits 3-0  | COLOR COMPARE DATA  |                     |     |
This value becomes the reference color used to compare each pixel. Each of the 8-bit
positions of the read data are compared across four planes and a logical 1 is returned
in each bit position for which the colors match.
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Raster Operation/Rotate Count Register (WT_ROP/RTC) (GR3)
| Read/Write  |     | Address: 3CFH, Index 03H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register selects a raster operation function and indicates the number of bits the CPU data will be
rotated (right) on the video memory write operation.
|       |       | I     | I  I  |
| ----- | ----- | ----- | ----- |
| 7  6  | 5  4  | 3  2  | 1  0  |
RST-OP
| =0  =0    | =0  1         | 0  ROTATE-COUNT  |     |
| --------- | ------------- | ---------------- | --- |
| Bits 2-0  | ROTATE-COUNT  |                  |     |
These bits define a binary encoded value ofthe number of positions to right-rotate
data during a CPU memory write. To write non-rotated data, the CPU must preset a
count of O.
16-38 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bits 4-3  | RST-OP -Select Raster Operation  |     |     |
| --------- | -------------------------------- | --- | --- |
The data written to memory can operate logically with the data already in the proces
sor latches. This function is not available in write mode 1. The logical functions are
defined as follows:
00 = No operation
01 = Logical AND with latched data
10 = Logical OR with latched data
11 = Logical XOR with latched data
The logical function specified by this register is applied to data being written to mem
ory while in modes 0, 2 and 3.
| Bits 7-5  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Read Plane Select Register (RD_PL_SL) (GR4)
| Read/Write  |     | Address: 3CFH, Index 04H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
1  0
| ~     | ~  ~  | ~         |           |
| ----- | ----- | --------- | --------- |
| I  I  | I  I  | I :  I :  | RD-PL-SL  |
I  1  0
The contents of this register represent the memory plane from which the CPU reads data in read mode
O. This register has no effect on the color compare read mode (read mode 1). In odd/even mode, bit 0
is ignored. Four memory planes are selected as follows:
| Bits 1-0  | RD-PL-SL -Read Plane Select  |     |     |
| --------- | ---------------------------- | --- | --- |
The memory plane is selected as follows:
00 = Plane 0
01 = Plane 1
10 = Plane 2
11 = Plane 3
| Bits 7-2  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
VGA REGISTER DESCRIPTIONS  16-39

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Graphics Controller Mode Register (GRP _MODE) (GR5)
ReadIWrite Address: 3CFH, Index 05H
Power-On Default: Undefined
7 6 I 5 4 3 2 1 J 0
SHF-MODE OlE RD WRT-MD
=0 256 OlE MAP CMP =0 1 0
This register controls the mode of the Graphics Controller as follows:
Bit 1-0 WRT-MD -Select Write Mode
These bits select the CPU write mode into video memory. The function of each mode
is defined as follows:
00 = Write Mode o. Each of four video memory planes is written with the CPU data
rotated by the number of counts in the rotate register. If the Set/Reset register is
enabled for any of four planes, the corresponding plane is written with the data
stored in the set/reset register. Raster operations and bit mask registers are
effective
01 = Write Mode 1. Each of four video memory planes is written with the data in the
processor latches. These latches are loaded during previous CPU read opera
tions. Raster operation, rotate count, set/reset data, enable set/reset data and bit
mask registers are not effective
10 = Write Mode 2. Memory planes 0-3 are filled with 8 bits of the value of CPU
write data bits 0-3, respectively. For example, if write data bit 0 is a 1, eight 1's
o.
are written to memory plane The data on the CPU data bus is treated as the
color value. The Bit Mask register is effective as the Mask register. A logical 1 in
the Bit Mask register sets the corresponding pixel in the addressed byte to the
color specified on the data bus. A logical 0 in the Bit Mask register sets the
corresponding pixel in the addressed byte to the corresponding pixel in the
processor latches. The Set/Reset, Enable Set/Reset and Rotate Count registers
are ignored
11 = Write Mode 3. Each of four video memory planes is written with 8 bits of the
color value contained in the set/reset register for that plane. The Enable Set/
Reset register is not effective. Rotated CPU write data is ANDed with the bit mask
register to form an 8-bit value that performs the same function as the Bit Mask
register in write modes 0 and 2. This write mode can be used to fill an area with
a single color and pattern
Bit 2 Reserved = 0
Bit 3 RD CMP -Enable Read Compare
0= The CPU reads data from the video memory planes. The plane is selected by the
Read Plane Select register. This is called read mode 0
1 = The CPU reads the results of the logical comparison between the data in four
video memory planes selected by the contents of the Color Don't Care register
and the contents of the Color Compare register. The result is a 1 for a match and
o for a mismatch on each pixel. This is called read mode 1
16-40 VGA REGISTER DESCRIPTIONS

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bit 4  | OlE MAP -Select Odd/Even Addressing  |     |     |
| ------ | ------------------------------------ | --- | --- |
0= Standard addressing.
1 = Odd/even addressing mode selected. Even CPU addresses access plane 0 and 2,
while odd CPU addresses access plane 1 and 3. This option is useful for
emulating the CGA compatible mode. The value of this bit should be the inverted
value programmed in bit 2 of the Sequencer Memory Mode register (SR4). This
bit affects reading of display memory by the CPU
| Bit 5  | SHF-MODE -Select Odd/Even Shift Mode  |     |     |
| ------ | ------------------------------------- | --- | --- |
o = Normal shift mode
1 = The video shift registers in the graphics section are directed to format the serial
data stream with even-numbered bits from both planes on the even-numbered
planes and odd-numbered bits from both planes on the odd planes
| Bit 6  | SHF-MODE -Select 256 Color Shift Mode  |     |     |
| ------ | -------------------------------------- | --- | --- |
0= Bit 5 in this register controls operation of the video shift registers
1 = The shift registers are loaded in a manner that supports the 256 color mode
| Bit 7  | Reserved = 0  |     |     |
| ------ | ------------- | --- | --- |
Memory Map Mode Control Register (MISC_GM) (GR6)
| Read/Write  |     | Address: 3CFH, Index 06H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register controls the video memory addressing.
I
| 7  6    | 5  4                               | 3  2     | 1  0      |
| ------- | ---------------------------------- | -------- | --------- |
|         |                                    | MEM-MAP  | CHN  TXT  |
| =0  =0  | ='0  =0                            | 1  0     | OlE  /GR  |
| Bit 0   | TXT/GR -Select Text/Graphics Mode  |          |           |
0= Text mode display addressing selected
1 = Graphics mode display addressing selected. When set to graphics mode, the
character generator address latches are disabled
| Bit 1  | CHN OlE -Chain Odd/Even Planes  |     |     |
| ------ | ------------------------------- | --- | --- |
o  = AO address bit unchanged
1 = CPU address bit AO is replaced by a higher order address bit. The content of AO
determines which memory plane is to be addressed. AO  = 0 selects planes 0
and 2, and AO  =  1 selects planes 1 and 3. This mode can be used to double the
address space into video memory
VGA REGISTER DESCRIPTIONS  16-41

II·
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Bits 3-2
MEM-MAP -Memory Map Mode
These bits control the address mapping of video memory into the CPU address
space. The bit functions are defined below.
00 = AOOOOH to BFFFFH (128 KBytes)
01 = AOOOOH to AFFFFH (64 KBytes)
10 = BOOOOH to B7FFFH (32 KBytes)
11 = B8000H to BFFFFH (32 KBytes)
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Color Don't Care Register (CMP _DNTC) (GR71
| Read/Write  | Address: 3CFH, Index 07H  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: Undefined
This register is effective in read mode 1, and controls whether the corresponding bit of the Color
Compare Register is to be ignored or used for color comparison.
| 7         | 4                                        | 321                | 0   |
| --------- | ---------------------------------------- | ------------------ | --- |
| =0        | =0                                       | COMPARE PLANE SEL  |     |
| Bits 3-Q  | COMPARE PLANE SEL -Compare Plane Select  |                    |     |
o = The corresponding color plane becomes a don't care plane when the CPU read
from the video memory is performed in read mode 1
1 = The corresponding color plane is used for color comparison with the data in the
Color Compare register
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Bit Mask Register (BIT_MASK) (GR8)
| Read/Write  | Address: 3CFH, Index 08H  |     |     |
| ----------- | ------------------------- | --- | --- |
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
16-42 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
16.5 ATTRIBUTE CONTROLLER REGISTERS
The attribute controller registers are located at the same byte I/O address for writing address and data.
An internal address flip-flop (AFF) controls the selection of either the attribute index or data registers.
To initialize the address flip-flop (AFF)' an I/O read is issued at address 3BAH or 3DAH. This presets the
address flip-flop to select the index register. After the index register has been loaded by an I/O write
to address 3COH, AFF toggles and the next I/O write loads the data register. Every I/O write to address
3COH toggles this address flip-flop. However, it does not toggle for I/O reads at address 3COH or 3C1 H.
The Attribute Controller Index register is read at 3COH, and the Attribute Controller Data register is read
at address 3C1 H.
Attribute Controller Index Register (ATR_AD)
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
This bit is effective only in 8-bit PA mode (CR67 _4= 0).
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
VGA REGISTER DESCRIPTIONS  16-43

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Attribute Controller Data Register (ATR_DATA)
| Read/Write  |     | Address: R: 3C1H/W: 3COH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register is the data port for the attribute controller register indexed by the Attribute Controller
Index register.
| 7   |      |     | o   |
| --- | ---- | --- | --- |
| 6   | 543  | 2   |     |
ATIRIBUTE DATA
| Bits 7-0  | ATTRIBUTE DATA  |     |     |
| --------- | --------------- | --- | --- |
Data to the attribute controller register indexed by the attribute controller address.
Palette Registers (PL T _REG) (AROO-OF)
| Read/Write  |     | Address: 3C1 H/3COH, Index OOH-OFH  |     |
| ----------- | --- | ----------------------------------- | --- |
Power-On Default: Undefined
These are 16, 6-bit registers pointed to by the index and color code. They allow a dynamic mapping
between the text attribute or graphics color input and the display color on the CRT screen.
| 7  6      | 5  I  4        | I  3  2  | I  1  I  0  |
| --------- | -------------- | -------- | ----------- |
|           | SECONDARY      |          | PRIMARY     |
| =0  =0    | SR  SG         | SB  R    | G  B        |
| Bits 5-0  | PALETTE COLOR  |          |             |
The six bit display color, bits 5-0 are output as SR, SG/I, SBN, R, G and B,
respectively.
| Bits 7-6  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
16-44 VGA REGISTER DESCRIPTIONS

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Attribute Mode Control Register (ATR_MODE) (AR10)
| ReadIWrite  |     | Address: 3C1H/3COH, Index 10H  |     |
| ----------- | --- | ------------------------------ | --- |
Power-On Default: OOH
The contents of this register controls the attribute mode of the display function.
| 7  6      | 5  4                         | 3          | 2  1  0     |
| --------- | ---------------------------- | ---------- | ----------- |
| SEL  256  | TOP                          | ENB  ENB   | MONO TX/GR  |
| V54  CLR  | PAN  =0                      | BLNK  LGC  | ATRB        |
| Bit 0     | TX/GR -Select Graphics Mode  |            |             |
o = Selects text attribute control mode
1 = Selects graphics control mode
| Bit 1  | MONO ATRB -Select Monochrome Attributes  |     |     |
| ------ | ---------------------------------------- | --- | --- |
0= Selects color display text attributes
1 = Selects monochrome display text attributes
| Bit 2  | ENB LGC -Enable Line Graphics  |     |     |
| ------ | ------------------------------ | --- | --- |
0= The ninth dot of a text character (bit 0 of SR1 = 0) is the same as the background
1 = Special line graphics character codes enabled
When this bit is set to 1, it forces the ninth dot of a line graphics character to be identi
cal to the eighth dot of the character. The line graphics character codes are COH
through DFH. For other characters, the ninth dot is the same as the background.
| Bit 3  | ENB BLNK -Enable Blinking  |     |     |
| ------ | -------------------------- | --- | --- |
o = Selects the background intensity for the text attribute intJut
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
| Bit 4  | Reserved = 0                 |     |     |
| ------ | ---------------------------- | --- | --- |
| Bit 5  | TOP PAN -Top Panning Enable  |     |     |
o = Line compare has no effect on the output of the pixel panning register
1 = Forces the output of the pixel panning register to 0 after matching line compare
until VSYNC occurs in the CRT controller. At the top of screen the output of the
Pixel Panning register returns to its programmed value. This bit allows a top
portion of a split screen to be panned.
VGA REGISTER DESCRIPTIONS 16-45

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bit 6  | 256 CLR -Select 256 Color Mode  |     |     |
| ------ | ------------------------------- | --- | --- |
0=4 bits of video (translated to 6 bits by the palette) are output every internal
dot-clock cycle
1 = Two 4-bit sets of video data are assembled to generate 8-bit video data at half the
frequency of the internal dot-clock
| Bit 7  | SEL V54 -Select V[5:4)  |     |     |
| ------ | ----------------------- | --- | --- |
o = In VGA, mode, bits 5-4 of video output are generated by the attribute palette
registers. Bits 7-6 of video output are always generated by bits 3-2 of AR14
1 = Bits 5-4 of video output are generated by bits 1-0 of AR14
Border Color Register (BOR_CLR) (AR11)
| Read/Write  |     | Address: 3C1H/3COH, Index 11H  |     |
| ----------- | --- | ------------------------------ | --- |
Power-On Default: OOH
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
BORDER COLOR
Bits 7-0  Border Color. This 8-bit register determines the border color displayed on the CRT
screen. The border is an area around the screen display area.
This register is only effective in 8-bit PA modes (CR67 _4 = 0). See also CR33_5.
Color Plane Enable Register (OISP _PLN) (AR12)
| Read/Write  |     | Address: 3C1 H/3COH, Index 12H  |     |
| ----------- | --- | ------------------------------- | --- |
Power-On Default: OOH
This register enables the respective video memory color plane 3-0 and selects video color outputs to
be read back in the display status.
|       | I     | I     | I  I  |
| ----- | ----- | ----- | ----- |
| 7  6  | 5  4  | 3  2  | 1  0  |
VDT-SEL
| =0  =0    | 1  0                | DISPLAY PLANE ENBL  |     |
| --------- | ------------------- | ------------------- | --- |
| Bits 3-0  | DISPLAY PLANE ENBL  |                     |     |
A 0 in any of these bits forces the corresponding color plane bit to 0 before accessing
the internal palette. A 1 in any of these bits enables the data on the corresponding
color plane.
16-46 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bits 5-4  VDT-SEL -Video Test Select
These bits select two of the eight bit color outputs to be available in the Input Status
1 register. The output color combinations available on the status bits are as follows:
|     | DSTSMUX  |             | STS 1         |     |
| --- | -------- | ----------- | ------------- | --- |
|     | Bit 5    | Bit 4       | Bit 5  Bit 4  |     |
|     | 0        | 0  Video 2  | Video 0       |     |
|     | 0        | 1  Video 5  | Video 4       |     |
|     | 1        | 0  Video 3  | Video 1       |     |
|     | 1        | 1  Video 7  | Video 6       |     |
Bits 7-6  Reserved = 0
Horizontal Pixel Panning Register (H_PX_PAN) (AR13)
Read/Write  Address: 3C1H/3COH, Index 13H
Power-On Default: OOH
This register specifies the number of pixels to shiftthe display data horizontally to the left. Pixel panning
is available in both text and graphics modes. It is not available with Enhanced mode memory mappings
(CR3L3 = 1).
| 6   | 5  4  | 321  | 0   |     |
| --- | ----- | ---- | --- | --- |
NUMBER OF PAN SHIFT
| =0  | =0  =0  |     |     |     |
| --- | ------- | --- | --- | --- |
Bits 3-0  NUMBER OF PAN SHIFT
This register selects the number of pixels to shift the display data horizontally to the
left. In the 9 pixels/character text mode, the output can be shifted a maximum shift of
8 pixels. In the 8 pixels/character text mode and all graphics modes, except 256 color
mode, a maximum shift of 7 pixels is possible. In the 256 color mode, bit 0 of this reg
ister must be 0 resulting in only 4 panning positions per display byte. The panning is
controlled as follows:
Number of Dixels shifted in
|     | Bits 3-0  | 9 pixel/char.  | S pixel/char.  | 256 color mode  |
| --- | --------- | -------------- | -------------- | --------------- |
|     | 0000      | 1              | 0              | 0               |
|     | 0001      | 2              | 1              | -               |
|     | 0010      | 3              | 2              | 1               |
|     | 0011      | 4              | 3              | -               |
|     | 0100      | 5              | 4              | 2               |
|     | 0101      | 6              | 5              | -               |
|     | 0110      | 7              | 6              | 3               |
|     | 0111      | 8              | 7              | -               |
|     | 1000      | 0              | -              | -               |
Bits 7-4  Reserved = 0
VGA REGISTER DESCRIPTIONS  16-47

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Pixel Padding Register (PX_PADD) (AR14)
| ReadIWrite  |     | Address: 3C1H/3COH, Index 14H  |     |
| ----------- | --- | ------------------------------ | --- |
Power-On Default: OOH
This register specifies the high-order bits of video output when pixel padding is enabled and disabled
in the 256 color mode.
| 7  6  | 5  4  | 3  I  2  | I  1  I  0  |
| ----- | ----- | -------- | ----------- |
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
16-48 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
16.6 RAMDAC REGISTERS
All of the RAMDAC registers described in this section are physically located inside the Tri064V+.
DAC Mask Register (DAC_AD_MKl
ReadIWrite Address: 3C6H
Power-On Default: Undefined
This register is the pixel read mask register to select pixel video output. The CPU can access this register
at any time.
7 6 543 2 o
DAC ADDRESS MASK
Bits 7-0 DAC ADDRESS MASK
The contents of this register are bit-wise logically ANDed with the pixel select video
output (PA[7:0)l. This register is initialized to FFH by the BIOS during a video mode
set.
DAC Read Index Register (DAC_RD_ADl
Write Only Address: 3C7H
Power-On Default: Undefined
This register contains the pointer to one of 256 palette data registers and is used when reading the
color palette.
7 6 5 4 3 2 o
DAC READ ADDRESS
Bits 7-0 DAC READ ADDRESS
Each time the color code is written to this register, it identifies that a read sequence
will occur. A read sequence consists of three successive byte reads from the RAM
DAC data register at I/O address 3C9H. The least significant 6 bits of each byte taken
from the RAMDAC data register contain the corresponding color value, and the most
significant 2 bits contain zeros. The order is red byte first, then green, and finally
blue. The sequence of events for a read cycle is:
1. Write the color code to this register (RAMDAC Read Indexl at address 3C7H.
2. The contents of the location in the color look-up table pointed to by the color code
are transferred to the RAMDAC data register at address 3C9H.
3. Three bytes are read back from the RAMDAC data register.
4. The contents of this register auto-increment by one.
VGA REGISTER DESCRIPTIONS 16-49

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
5. Go to step 2.
The effects of writing to the RAMDAC data register during a three-byte read cycle or
reading from the RAMDAC data register during a 3-byte write cycle (Le., interrupting
the sequence) are undefined and may change the look-up table contents.
DAC Status Register (DAC_STS)
Read Only Address: 3C7H
Power-On Default: Undefined
6 3 2 1 0
=0 =0 =0 DAC-STS
Bits 1-0 DAC-STS -RAMDAC Cycle Status
The last executing cycle was:
00 = Write Palette cycle
11 = Read Palette cycle
Reads from the RAMDAC Write Index at address 3CSH or the DAC status register at
address 3C7H do not interfere with read or write cycles and may take place at any
time.
Bits 7-2 Reserved = 0
DAC Write Index Register (DAC_WR_ADI
Read/Write Address: 3CSH
Power-On Default: Undefined
Bits 7-0 DAC WRITE ADDRESS/GIP READ DATA
This register contains the pointer to one of 256 palette data registers and is used dur
ing a palette load. Each time the color code is written to this register, it identifies that
a write sequence will occur. A write sequence consists of three successive byte writes
to the DAC data register at I/O address 3C9H. The least significant 6 bits of each byte
are concatenated to form the value placed in the 1S-bit data register. The order is red
byte first, then green, and finally blue. Once the third byte has been written, the value
in the data register is written to the location pointed to by the color code. The se
quence of events for a write cycle is:
1. Write the color code to this register (DAC Write Index) at address 3CSH.
2. Three bytes are written to the DAC Data register at address 3C9H.
16-50 VGA REGISTER DESCRIPTIONS

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
3. The contents of the DAC data register are transferred to the location in the color
look-up table pointed to by the color code.
4. The DAC Write Index register auto-increments by 1.
5. Go to step 2.
If bit 2 of the Extended RAMDAC Control register (CR55) is set to 1 to enable the Gen
eral I/O Port read function, a read of 3C8H retrieves data from an external input buff
er. The data is transmitted via GD[7:0) to AD[7:0) for a PCI bus configuration and
directly to SD[7:0) for a VL-Bus configuration.
RAMDAC Data Register (DAC_DATAI
Read/Write Address: 3C9H
Power-On Default: Undefined
This register is a data port to read or write the contents of the location in the color look-up table pointed
to by the DAC Read Index or the DAC Write Index registers.
7 6 543 2 o
DAC READ/WRITE DATA
Bits 7-0 DAC READ/WRITE DATA
To prevent "snow flicker" on the screen, an application reading data from or writing
data to the DAC Data register should ensure that the BLANK input to the RAMDAC is
asserted. This can be accomplished either by restricting data transfers to retrace inter
vals, checking bit 3 of the Input Status 1 register (3?AH) to determine when retrace is
occurring, or by using the screen-off bit in the Clocking Mode register of the se
quencer (bit 5 of SR11.
VGA REGISTER DESCRIPTIONS 16-51

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 17: S3 VGA Register Descriptions
The Trio64V+ has additional registers to extend the functions beyond VGA. These registers are located
in CRT Controller address space at locations not used by the IBM® VGA. All of these registers are
read/write protected at power-up by hardware reset. In orderto read/write these registers, the Register
Lock 1 register (CR3B) must be loaded with a changed key pattern (see the register description). The
registers will remain unlocked until the key pattern is reset by altering a significant bit.
In the following register descriptions, 'R' stands for reserved (write =0, read = undefined). See Appendix
A for a table listing each register in this section and its page number.
Device ID High Register (CR2D)
Read Only Address: 3?5H, Index 2DH
Power-On Default: BBH
This register should contain the same value as the upper byte ofthe PCI Device ID (Index 02H) register.
7 6 5 4 3 2 o
CHIP ID HIGH
Bits 7-0 CHIP ID HIGH
value = BBH (hardwired)
S3 VGA REGISTER DESCRIPTIONS 17-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Device ID Low Register (CR2E)
| Read Only  |     | Address: 3?5H, Index 2EH  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: 11 H
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
CHIP ID LOW
| Bits 7-0  | CHIP ID LOW  |     |     |
| --------- | ------------ | --- | --- |
value = 11H (hardwired)
Revision Register (CR2F)
| Read Only  |     | Address: 3?5H, Index 2FH  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: 4xH
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
REVISION LEVEL
| Bits 7-0  | REVISION LEVEL  |     |     |
| --------- | --------------- | --- | --- |
The Trio64V+ is differentiated from the Trio64 by a 4 in the upper nibble of this regis
ter. The "x" in the lower nibble will change with each revision of the chip.
Chip ID/REV Register (CHIP-ID/REV) (CR30)
| Read Only               |     | Address: 3?5H, Index 30H  |     |
| ----------------------- | --- | ------------------------- | --- |
| Power-On Default: E 1H  |     |                           |     |
Should use CR2D, CR2E and CR2F for chip ID information.
| 7  6      | 5  4                         | 321              | 0   |
| --------- | ---------------------------- | ---------------- | --- |
| CHIPID    |                              | REVISION STATUS  |     |
| Bits 7-0  | CHIP 10 AND REVISION STATUS  |                  |     |
value = E1H (hardwired)
17-2  S3 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Memory Configuration Register (MEM_CNFG) (eR31)
| ReadIWrite  |     | Address: 3?5H, Index 31H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6    | 5  I  4                                | 3  2      | 1  0        |
| ------- | -------------------------------------- | --------- | ----------- |
| HST     | OLD-DSAD                               |           |             |
|         |                                        | ENH  VGA  | SCRN  CPUA  |
| R  DFF  | 17  16                                 | MAP  16B  | 2.PG  BASE  |
| Bit 0   | CPUA BASE -Enable Base Address Offset  |           |             |
0= Address offset bits 3-0 of CR35 and bits 3-2 of CR51 or the new address offset bits
(5-0 of CR6A) are disabled
1 = Address offset bits 3-0 CR35 and bits 3-2 of CR51 or the new address offset bits (5-
o
of CR6A) are enabled for specifying the 64K page of display memory. Bits 5-0 of
CR6A are used if this field contains a non-zero value. This allows access to up to
4 MBytes of display memory through a 64K window. (2 MBytes for the Tri032)
| Bit 1  | SCRN 2.PG -Enable Two-Page Screen Image  |     |     |
| ------ | ---------------------------------------- | --- | --- |
o = Normal Mode
1 = Enable 2K x 1 K x 4 map image screen for 1024 x 768 or 800 x 600 screen
resolution, or 2K x 512 x 8 map image screen for 640 x 480 screen resolution
| Bit 2  | VGA 16B -Enable VGA 16-bit Memory Bus Width  |     |     |
| ------ | -------------------------------------------- | --- | --- |
o  = 8-bit memory bus operation
1 = Enable 16-bit bus VGA memory read/writes
This is useful in VGA text modes when VGA graphics controller functions are typi
cally not used.
| Bit 3  | ENH MAP -Use Enhanced Mode Memory Mapping  |     |     |
| ------ | ------------------------------------------ | --- | --- |
0= Force IBM VGA mapping for memory accesses
1 = Force Enhanced Mode mappings
Setting this bit to 1 overrides the settings of bit 6 of CR14 and bit 3 of CR17 and
causes the use of doubleword memory addressing mode. Also, the function of bits 3-
2 of GR6 is overridden with a fixed 64K map at AOOOOH.
| Bits 5-4  | OLD-DSAD 17, 16 -Old Display Start Address Bits 17-16  |     |     |
| --------- | ------------------------------------------------------ | --- | --- |
Bits 17-16 of start address (CRC, CRD) and cursor location (CRE, CRF)
Bits 1-0 ofthe Extended System Control 2 register (CR51) are bits 19-18 of the ad
dress and enable access to up to 4 MBytes of display memory. If a value is pro
grammed into bits 3-0 of the Extended System Control 3 register (CR69), this value
becomes the upper 4 bits of the display start base address and bits 5-4 of CR31 and
bits 1-0 of CR51 are ignored. The Tri032 only supports 2 MBytes, so the upper bit is
not used.
S3 VGA REGISTER DESCRIPTIONS  17-3

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bit 6  HST DFF -Enable High Speed Text Display Font Fetch Mode
o = Normal font access mode
1 = Enable high speed text display
Setting this bit to 1 is only required for DCLK rates greater than 40 MHz. See bit 5 of
CR3A.
| Bit 7  | Reserved  |     |     |     |
| ------ | --------- | --- | --- | --- |
Backward Compatibility 1 Register (BKWD_1) (CR32)
| Read/Write  |     | Address: 3?5H, Index 32H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
| 7   | 5   | 4  3  | 2  1  | 0   |
| --- | --- | ----- | ----- | --- |
l:x~1
INT
|           | I                         | I      | I     |     |
| --------- | ------------------------- | ------ | ----- | --- |
| R         | R                         | EN  R  | R  R  | R   |
|           |                           | I      | I     | I   |
| Bits 3-0  | Reserved                  |        |       |     |
| Bit 4     | INT EN -Interrupt Enable  |        |       |     |
0= All interrupt generation disabled
1 = Interrupt generation enabled
| Bit 5  | Reserved                                    |     |     |     |
| ------ | ------------------------------------------- | --- | --- | --- |
| Bit 6  | VGA FXPG -Use Standard VGA Memory Wrapping  |     |     |     |
o
= Memory accesses extending past a 256K boundary do not wrap
1 = Memory accesses extending past a 256K boundary wrap at the boundary
The standard 256K VGA memory page always ends on a natural 256K boundary and
accesses beyond this boundary will wrap. If the starting address is moved via bits 4-0
of CR69 (or bits 5-4 of CR31 and bits 1-0 of CR51), the 256K page may not end on a
256K boundary and accesses past the boundary will not wrap. This is the case when
this bit is cleared to o. For standard VGA compatibility when the page base address is
moved, this bit is set to 1 to cause wrapping at a 256K boundary.
| Bit 7  | Reserved  |     |     |     |
| ------ | --------- | --- | --- | --- |
17-4 S3 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Backward Compatibility 2 Register (BKWD_2) (CR33)
| ReadIWrite  |     | Address: 375H, Index 33H  |     |
| ----------- | --- | ------------------------- | --- |
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
| Bit 3  | VCLK = -DCK -VCLK is Inverted DCLK  |     |     |
0= VCLK is the external VCLK (pass-through feature connector clock input enabled)
or is divided by 2 for 4 bits/pixel modes (see bit 6 of AR10 or bit 4 of CR3A) or is
the internal DCLK (if neither of the first two cases apply)
1 = VCLK is forced to inverted DCLK
| Bit 4  | LOCK DACW -Lock RAMDAC Writes  |     |     |
| ------ | ------------------------------ | --- | --- |
o
= Enable writes to RAMDAC registers
1 = Disable writes to RAMDAC registers
| Bit 5  | BDR SEL -Blank/Border Select  |     |     |
| ------ | ----------------------------- | --- | --- |
o = BLANK active time is defined by CR2 and CR3
1 = BLANK is active during entire display inactive period (no border)
| Bit 6  | LOCK PL TW -Lock Palette/Border Color Registers  |     |     |
| ------ | ------------------------------------------------ | --- | --- |
0= Unlock Palette/Border Color registers
1 = Lock Palette/Border Color registers
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
S3 VGA REGISTER DESCRIPTIONS  17-5

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Backward Compatibility 3 Register (BKWD_3) (CR34)
| ReadIWrite  |     | Address: 3?5H, Index 34H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
| 7  6   | 5  4                           | 3  2    | 1    | 0    |
| ------ | ------------------------------ | ------- | ---- | ---- |
|        | ENB                            | PCI     | PCI  | PCI  |
| R  R   | R  SFF                         | R  RET  | ABT  | SNP  |
| Bit 0  | PCI SNP -PCI DAC snoop method  |         |      |      |
0= Handling of PCI master aborts and retries during DAC cycles controlled by bits 1
and 2 of this register
1 = PCI master aborts and retries are not handled during DAC cycles
| Bit 1  | PCI ABT -PCI master aborts during DAC cycles  |     |     |     |
| ------ | --------------------------------------------- | --- | --- | --- |
0= PCI master aborts handled during DAC cycles
1 = PCI master aborts not handled during DAC cycles
Bit 0 of this register must be cleared to 0 for this bit to be effective.
| Bit 2  | PCI RET -PCI retries during DAC cycles  |     |     |     |
| ------ | --------------------------------------- | --- | --- | --- |
o = PCI retries handled during DAC cycles
1 = PCI retries not handled during DAC cycles
Sit 0 of this register must be cleared to 0 for this bit to be effective.
| Bit 3  | Reserved                                           |     |     |     |
| ------ | -------------------------------------------------- | --- | --- | --- |
| Bit 4  | ENB SFF -Enable Start Display FIFO Fetch Register  |     |     |     |
o  = Start Display FIFO Fetch register (CR3B) disabled
1 = Start Display FIFO Fetch register (CR3S) enabled
| Bits 7-5  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
17-6 S3 VGA REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
CRT Register Lock Register (CRTR_LOCK) (CR35)
ReadIWrite Address: 3?5H, Index 35H
Power-On Default: OOH
7 6 5 4 3 I 2 I 1 I 0
LOCK LOCK OLD-CPU-BASE-ADDRESS
R R HTMG VTMG 17 16 15 14
Bits 3-0 OLD-CPU-BASE-ADDRESS
CPU Base Address bits 17-14. These four bits define the CPU address base in 64
KByte units of display memory. These bits are added with CPU address bit 17 (MSB
of video memory addressing) to bit 14 for display buffer accesses.
Bits 3-2 of the Extended System Control 2 register (CR51) are bits 19-18 of the ad
dress and enable access to up to 4 MBytes of display memory. If a value is pro
grammed into bits 5-0 of the Extended System Control 4 register (CR6A)' this value
becomes the upper 6 bits of the CPU base address and bits 3-0 of CR35 and bits 3-2 of
CR51 are ignored. The Tri032 only supports 2 MBytes, so the upper bit is not used.
Bit 4 LOCK VTMG -Lock Vertical Timing Registers
o
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
Bit 5 LOCK HTMG -Lock Horizontal Timing Registers
o
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
Bit 7-6 Reserved
S3 VGA REGISTER DESCRIPTIONS 17-7

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Configuration 1 Register (CONFG_REG11 (CR361
| ReadIWrite*  | Address: 3?5H, Index 36H  |     |
| ------------ | ------------------------- | --- |
Power-On Default: Depends on Strapping
* Bits 1-0 are read only. The other bits can be written only after OA5H is written to CR39.
This register samples the reset state from PD bus pins [7:0). Other configuration strapping bits are
found in CR37, CR68 and CR6F.
| 7  6      | 5                           | 1  0     |
| --------- | --------------------------- | -------- |
| MEM SIZE  |                             | SYS BUS  |
| Bits 1-0  | SYS BUS -System Bus Select  |          |
00 = Reserved
01 = VESA local bus
10 = PCI local bus
11 = Reserved
| Bits 3-2  | MEM MODE -Memory Mode Select  |     |
| --------- | ----------------------------- | --- |
00 = 1-cycle Extended Data Out (EDO) mode
01 = Reserved
10 = 2-cycle Extended Data Out (EDO) mode
11 = fast page mode
| Bit 4  | EVB -Enable Video BIOS (VL-Bus only)  |     |
| ------ | ------------------------------------- | --- |
o = Disable video BIOS accesses
1 = Enable video BIOS accesses
| Bit 7-5  | MEM SIZE -Memory Size  |     |
| -------- | ---------------------- | --- |
000 = 4 MBytes
100 = 2 MBytes
110 = 1 MByte
All other values are reserved.
17-8 S3 VGA REGISTER DESCRIPTIONS

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Configuration 2 Register (CONFG_REG2)  | (CR37)                    |     |
| -------------------------------------- | ------------------------- | --- |
| ReadIWrite*                            | Address: 3?5H, Index 37H  |     |
Power-On Default: Depends on Strapping
* These bits can be written only after OA5H is written to CR39.
This register samples the reset state from PD bus pins [15:7]. Other configuration strapping bits are
found in CR36 and CR6S and CR6F.
| 7  6  | 5   | o   |
| ----- | --- | --- |
ETV
| R  R    | R                                   | R   |
| ------- | ----------------------------------- | --- |
| Bits 0  | ETV -Enable Tri064V+ (VL-Bus only)  |     |
o = Tri064V+ disabled except for video BIOS accesses
1 = Tri064V+ enabled
| Bit 1  | Reserved                            |     |
| ------ | ----------------------------------- | --- |
| Bit 2  | VBS -Video BIOS Size (VL-Bus only)  |     |
o = 64 KByte BIOS ROM
1 = 32 KByte BIOS ROM
| Bit 3  | CS -Clock Select  |     |
| ------ | ----------------- | --- |
o
= Use external DCLK and MCLK (test purposes only)
1 = Use internal DCLK and MCLK
| Bit 4  | DACS -RAMDAC Write Snooping (VL-Bus only)  |     |
| ------ | ------------------------------------------ | --- |
o = Disable LOCA/SRDY for RAMDAC writes
1 = Enable LOCA/SRDY for RAMDAC writes
| Bits 7-5  | Reserved  |     |
| --------- | --------- | --- |
S3 VGA REGISTER DESCRIPTIONS  17-9

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Register Lock 1 Register (REG_LOCK1) (CR3S)
| Read/Write  |     | Address: 3?5H, Index 38H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
Loading 01xx10xx (e.g., 48H) into this register unlocks the S3 VGA register set for read/writes. (x =
don't care)
|     | 5   | 4  3  | 2   | o   |
| --- | --- | ----- | --- | --- |
|     |     | = 1   | =0  |     |
Register Lock 2 Register (REG_LOCK2) (CR39)
| Read/Write  |     | Address: 3?5H, Index 39H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
Loading 101xxxxx (e.g., AOH) unlocks the system control and system extension registers for
reading/writing (x = don't care). Loading A5H allows bits 7-2 of CR36, bits 7-0 of CR37, bits 7-0 of CR68
and bits 7-0 of 6F to be written.
| 7    | 6  5  | 4  3  | 2   | o   |
| ---- | ----- | ----- | --- | --- |
| = 1  | = 1   |       |     |     |
=0
Miscellaneous 1 Register (MISC_1) (CR3A)
| Read/Write  |     | Address: 3?5H, Index 3AH  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
|           | 6  5                                      | 4  3      | 2    | I  0     |
| --------- | ----------------------------------------- | --------- | ---- | -------- |
| 7         |                                           |           |      | 1        |
| PCIRB     | HST                                       | ENH  TOP  | ENB  | REF-CNT  |
| DISA      | R  DFW                                    | 256  MEM  | RFC  | 1  0     |
| Bits 1-0  | REF-CNT -Alternate Refresh Count Control  |           |      |          |
00 = Refresh Count 0
01 = Refresh Count 1
10 = Refresh Count 2
11 = Refresh Count 3
If enabled by setting bit 2 of this register to 1, these bits override the refresh count in
bit 6 of CR11 and specify the number of refresh cycles per horizontal line.
|     | Bit 2  ENB RFC -Enable Alternate Refresh Count Control  |     |     |     |
| --- | ------------------------------------------------------- | --- | --- | --- |
0= Alternate refresh count control (bits 1-0) is disabled
1 = Alternate refresh count control (bits 1-0) is enabled
17-10 S3 VGA REGISTER DESCRIPTIONS

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bit 3 TOP MEM -Enable Top of Memory Access
0= Top of memory access disabled
1 = Simultaneous VGA text and Enhanced modes are enabled. CPU and CRTC
accesses are then directed to the top 32-or 64-KByte area of display memory
depending on whether address bit 13 is 0 or 1 respectively.
Bit 4 ENH 256 -Enable 8 Bits/Pixel or Greater Color Enhanced Mode
o = Attribute controller shift registers configured for 4-bit modes
1 = Attribute controller shift register configured for 8-, 16-and 24/32-bit color
Enhanced modes
Bit 5 HST DFW -Enable High Speed Text Font Writing
o = Disable high speed text font writing
1 = Enable high speed text font writing
Setting this bit to 1 is only required for DCLK rates greater than 40 MHz. See bit 6 of
CR31.
Bit 6 Reserved
Bit 7 PCIRB DISA -PCI Read Bursts Disabled
o = PCI read burst cycles enabled
1 = PCI read burst cycles disabled
Note: Bit 7 of CR66 must be set to 1 before this bit is set to 1.
Start Display FIFO Register (DT _EX_POS) (CR3B)
ReadIWrite Address: 3?5H, Index 3BH
Power-On Default: OOH
This value must lie in the horizontal blanking period and is typically 5 less than the value pro
grammed in CRO. This parameter helps to ensure that adequate time is available during horizontal
blanking for activities such as RAM refresh that require control of the display memory. Bit 9 of this
value is bit 6 of CR5D. This register must be enabled by setting bit 4 of CR34 to 1.
7 6 543 2 o
START DISPLAY FIFO FETCH
Bits 7-0 START DISPLAY FIFO FETCH
9-bit value = the time in character clocks from the active display start until the restart
of fetching of FIFO data after the start of horizontal blanking. This register contains
the low-order 8 bits of this value.
S3 VGA REGISTER DESCRIPTIONS 17-11

••
r
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Interlace Retrace Start Register (lL_RTSTART) (CR3C)
Read/Write Address: 375H, Index 3CH
Power-On Default: OOH
This value allows determination of the even/odd row active display starting positions when operat
ing in an interlaced mode. This register is enabled by bit 5 of CR42.
Bits 7-0 INTERLACE RETRACE START POSITION
value = offset in terms of character clocks for Interlaced mode start/end in even/odd
frames.
17-12 S3 VGA REGISTER DESCRIPTIONS

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporatad
Section 18: System Control Register Descriptions
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
| 7  6  | 5  4      | 3  2  | 1  0  |
| ----- | --------- | ----- | ----- |
|       | WOL  ROY  |       | EN    |
o
| =0  =0  | LAY  CTL                                 | R  R  | R  ENH  |
| ------- | ---------------------------------------- | ----- | ------- |
| Bit 0   | EN ENH -Enable Enhanced Register Access  |       |         |
o = Enhanced register access disabled
1 = Enhanced register (x2E8H) access enabled
| Bits 3-1  | Reserved                             |     |     |
| --------- | ------------------------------------ | --- | --- |
| Bits 4    | RDY CTL-Ready Control (VL-Bus only)  |     |     |
0= Minimum 0 wait state delay from SADS asserted to assertion of SRDY. Address
latching occurs during the T1 cycle.
1 = Minimum 1 wait state delay from SADS asserted to assertion of SRDY (Default)
With this setting, bit 3 of CR58 determines when the address is latched.
| Bit 5     | Reserved = 1 (Default)  |     |     |
| --------- | ----------------------- | --- | --- |
| Bits 7-6  | Reserved = OOb          |     |     |
SYSTEM CONTROL REGISTER DESCRIPTIONS  18-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
BIOS Flag Register (BIOS_FLAG) (CR41)
| Read/Write  |     | Address: 3?5H, Index 41H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
BIOS-FLAG-REGISTER-l
| Bits 7-0  | BIOS-FLAG-REGISTER-1  |     |     |
| --------- | --------------------- | --- | --- |
Used by the video BIOS.
Mode Control Register (MODE_CTL) (CR42)
| Read/Write  |     | Address: 3?5H, Index 42H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 6   | 4   |              |         |
| --- | --- | ------------ | ------- |
|     |     | I :  I :  I  | I :  '  |
R
| R         | R                           |     |     |
| --------- | --------------------------- | --- | --- |
| Bits 4-0  | Reserved                    |     |     |
| Bit 5     | INTL MODE -Interlaced Mode  |     |     |
o  = Noninterlaced
1 = Interlaced
This bit enables the function of CR3C.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Extended Mode Register (EXT_MODE) (CR43)
| Read/Write  |     | Address: 3?5H, Index 43H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
|     |     | 3  1  |     |
| --- | --- | ----- | --- |
I :  I
|           |                                       | R  R  |     |
| --------- | ------------------------------------- | ----- | --- |
| Bits 1-0  | Reserved                              |       |     |
| Bit 2     | OLD LSW8 -Logical Screen Width Bit 8  |       |     |
This is an extension of the Offset (Screen Width) register (CR13). This is disabled if
bits 5-4 of the Extended System Control 2 register (CR51) are not OOb.
18-2 SYSTEM CONTROL REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bits 6-3  | Reserved                                 |     |     |
| --------- | ---------------------------------------- | --- | --- |
| Bit 7     | HCTR X2 -Horizontal Counter Double Mode  |     |     |
o = Disable horizontal counter double mode
1 = Enable horizontal counter double mode (horizontal CRT parameters are doubled)
Hardware Graphics Cursor Mode Register (HGC_MODE) (CR45)
| Read/Write  |     | Address: 3?5H, Index 45H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6   | 5  4                                       | 3  2  | 1  0    |
| ------ | ------------------------------------------ | ----- | ------- |
|        | HWGC                                       |       | HWGC    |
| R  R   | R  1280                                    | R  R  | R  ENS  |
| Bit 0  | HWGC ENB -Hardware Graphics Cursor Enable  |       |         |
0= Hardware graphics cursor disabled in any mode
1 = Hardware graphics cursor enabled in Enhanced mode
| Bits 3-1  | Reserved                                  |     |     |
| --------- | ----------------------------------------- | --- | --- |
| Bit4      | HWGC 1280 -Hardware Cursor Right Storage  |     |     |
o = Function disabled
1 = For 4 bits/pixel, the last 256 bytes in each 1-KByte line of the hardware cursor start
address become the hardware graphics cursor storage area. For 8 bits/pixel, the
last 512 bytes in each 2-KByte line of the hardware cursor start address become
the hardware graphics cursor storage area. In either case, bits 1-0 of CR4D must
be 11 b.
| Bits 7-5  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Hardware Graphics Cursor Origin-X Registers (HWGC_ ORGX(H)(L)) (CR46, CR47)
| Read/Write  |     | Address: 3?5H, Index 46H, 47H  |     |
| ----------- | --- | ------------------------------ | --- |
Power-On Default: OOOOH
The high order three bits are written into CR46 and the low order byte is written into CR47.
| Bits 10-0   | HWGC ORG X(H) (L) -X-Coordinate of Cursor Left Side  |     |     |
| ----------- | ---------------------------------------------------- | --- | --- |
| Bits 15-11  | Reserved                                             |     |     |
SYSTEM CONTROL REGISTER DESCRIPTIONS 18-3

, .
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Hardware Graphics Cursor Origin-V Registers (HWGC_ORGV(HIIL)) (CR48, CR49)
Read/Write Address: 3?5H, Index 48H, 49H
Povyer-On Default: Undefined
The high order three bits are written into CR48 and the low order byte is written into CR49.
Bits 10-0 HWGC ORG V (H)(L) -V-Coordinate of Cursor Upper Line
The cursor X, Y position is registered upon writing HWGC ORG Y (H).
Bits 15-11 Reserved
Hardware Graphics Cursor Foreground Color Stack Register ( HWGC_FGSTK) (CR4A)
Read/Write Address: 375H, Index 4AH
Power-On Default: Undefined
Bits 7-0 TRUE COLOR FOREGROUND STACK (0-2)
Three foreground color registers are stacked at this address. The stack pointer (com
mon with CR4B) is reset to 0 by reading the Hardware Graphics Cursor Mode register
(CR45). Each write to this register (CR4A) increments the stack pointer by 1, so three
writes provide 24 bits of true color information.
Hardware Graphics Cursor Background Color Stack Register ( HWGC_BGSTK) (CR4B)
Read/Write Address: 3?5H, Index 4BH
Power-On Default: Undefined
Bits 7-0 TRUE COLOR BACKGROUND STACK (0-2)
Three background color registers are stacked at this address. The stack pointer (com
mon with CR4A) is reset to 0 by reading the Hardware Graphics Cursor Mode register
(CR45). Each write to this register (CR4B) increments the stack pointer by 1, so three
writes provide 24 bits of true color information.
18-4 SYSTEM CONTROL REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Hardware Graphics Cursor Storage Start Address Registers (HWGC_STA(HHLI (CR4C, CR4DI
| Read/Write  | Address: 3?5H, Index 4CH, 4DH  |     |
| ----------- | ------------------------------ | --- |
Power-On Default: Undefined
The high order four bits are written into CR4C and the low order byte is written into CR4D.
Bits 11-0  HWGC STA(H)(LI-Hardware Graphics Cursor Storage Start Address
| Bits 15-12  | Reserved  |     |
| ----------- | --------- | --- |
Hardware Graphics Cursor Pattern Display Start X-PXL-Position Register (HWGC_DXI (CR4EI
| Read/Write  | Address: 3?5H, Index 4EH  |     |
| ----------- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 5  432                     | 1  0  |
| ----- | -------------------------- | ----- |
| R     | HWGC PAT DISP START x-pas  |       |
R
Bits 5-0  HWGC PAT DISP START x-pas -HWGC Pattern Display Start-X Pixel Position
This value is the offset (in pixels) from the left side of the 64x64 cursor pixel pattern
from which the cursor is displayed. This allows a partial cursor to be displayed at the
left border of the display.
| Bits 7-6  | Reserved  |     |
| --------- | --------- | --- |
Hardware Graphics Cursor Pattern Disp Start V-PXL-Position Register (HGC_DV) (CR4F)
| Read/Write  | Address: 3?5H, Index 4FH  |     |
| ----------- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 54320                      |     |
| ----- | -------------------------- | --- |
| R  R  | HWGC PAT DISP START Y-POS  |     |
Bits 5-0  HWGC PAT DISP START Y-POS -HWGC Pattern Display Start-Y Pixel Position
This value is the offset (in pixels) from the top of the 64x64 cursor pixel pattern from
which the cursor is displayed. This allows a partial cursor to be displayed at the top
of the display.
SYSTEM CONTROL REGISTER DESCRIPTIONS  18-5

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bits 7-6 Reserved
18-6 SYSTEM CONTROL REGISTER DESCRIPTIONS

fl·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 19: System Extension Register Descriptions
These registers provide extended system and memory control, external sync control and addressing
window control. They are enabled in the same way as the System Control registers via the Register
Lock 2 register (CR39).
In the following register descriptions, 'R' stands for reserved (write = 0, read = undefined). See Appendix
A for a table listing each of the registers in this section and its page number.
Extended System Cont 1 Register (EX_SCTL_11 (CR501
| Read/Write  |     | Address: 3?5H, Index 50H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| I         | I         |       |       |
| --------- | --------- | ----- | ----- |
| 7  6      | 5  4      | 3  2  | 1  0  |
| GE-SCR-W  | PXL-LNGH  |       | GESW  |
| 1  0      | 1  0      | R  R  | R  2  |
Bit 0  Extension bit 2 of the screen width definition. See bits 7-6 below.
| Bits 3-1  | Reserved                       |     |     |
| --------- | ------------------------------ | --- | --- |
| Bits 5-4  | PXL-LNGH -Pixel Length Select  |     |     |
00 = 1 byte (Default). This corresponds to a pixel length of 4 or 8 bits/pixel in bit 7 of
the Subsystem Status register (42E8H)
01 = 2 bytes. 16 bits/pixel
10 = Reserved
11 = 4 bytes. 32 bits/pixel
These bits select the pixel length for Enhanced mode command execution through
the Graphics Engine.
SYSTEM EXTENSION REGISTER DESCRIPTIONS  19-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bits 7-6  GE-SCR-W -Graphics Engine Command Screen Pixel Width
Bit 0 of this register is the most significant bit of this definition.
000 = 1024 (or 2048 if bit 1 of CR31 =1) (Default)
001 = 640
010 = 800 (or 1600x1200x4 if bit 2 of 4AE8H = O)
011=1280
100 = 1152
101 = Reserved
110 = 1600
111 = Reserved
Extended System Control 2 Register (EX_SCTL_2) (CR51)
| ReadIWrite  |     | Address: 3?5H, Index 51H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
|           | I                                               | I         | I         |
| --------- | ----------------------------------------------- | --------- | --------- |
| 7  6      | 5  4                                            | 3  2      | 1  0      |
|           | LOG-SCR-W                                       | OLD-CBAD  | OLD-DSAD  |
| R  R      | 9  8                                            | 19  18    | 19  18    |
| Bits 1-0  | OLD-DSAD -Old Display Start Address Bits 19-18  |           |           |
These are extension bits of Memory Configuration register (CR31) bits 5-4 (Display
Start Base Address). If the upper 4 display start address bits are programmed into
bits 3-0 of CR69, these bits and bits 5-4 of CR31 are ignored.
| Bits 3-2  | OLD-CBAD -Old CPU Base Address Bits 19-18  |     |     |
| --------- | ------------------------------------------ | --- | --- |
These are extension bits of CRT Register Lock register (CR35) bits 3-0 (CPU Base Ad
dress). They becomes bits 19-18 ofthe CPU base address, enabling access to up to 4
MBytes of display memory. If the upper 6 CPU base address bits are programmed
into bits 5-0 of CR6A, these bits and bits 3-0 of CR35 are ignored.
| Bits 5-4  | LOG-SCR-W -Logical Screen Width Bits 9-8  |     |     |
| --------- | ----------------------------------------- | --- | --- |
These are two extension bits ofthe Offset register (CR13}.lfthe value ofthese bits is
not OOb, bit 2 of the Extended Mode register (CR43) is disabled.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
19-2 SYSTEM EXTENSION REGISTER DESCRIPTIONS

...
Trio64V+ Integrated Graphics/Video Accelerator
r~
S3 Incorporated
Extended BIOS Flag 1 Register (EXT _BBFLG1) (CR52)
| Read/Write  |     | Address: 3?5H, Index 52H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6  | 543  | 2   | o   |
| ----- | ---- | --- | --- |
EXT-BIOS-FLAG-REGISTER-l
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-l  |     |     |
| --------- | ------------------------- | --- | --- |
See the S3 video BIOS documentation for the coding of this register. Note that this
coding is different from that used with previous S3 accelerators.
Extended Memory Control 1 Register (EX_MCTL_1) (CR53)
| Read/Write  |     | Address: 3?5H, Index 53H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: See Bit Descriptions
| 7  6    | 5  4         | I  3  2     | I  1  0  |
| ------- | ------------ | ----------- | -------- |
| SWP     | MMIO  MMIO   | BIG ENDIAN  |          |
| R  NBL  | WIN  SELECT  | LIN ADDR    | R        |
| Bit 0   | Reserved     |             |          |
Bits 2-1  BIG ENDIAN LIN ADDR -Big Endian Data Byte swap (linear addressing only)
00 = No swap (Default)
01 = Swap bytes within each word
10 = Swap all bytes in doublewords (bytes reversed)
11 = Reserved
| Bits 4-3  | MMIO SELECT  |     |     |
| --------- | ------------ | --- | --- |
00 = Disable MMIO (Default for VL-Bus)
01 = New MMIO (relocatable) enabled (Default for PCI)
10 = Tri064-type MMIO enabled at window selected by bit 5 of this register
11 = Tri064-type MMIO and new MMIO enabled
Refer to the MMIO explanation in Section 15 for more information.
| Bit 5  | MMIO WIN -Tri064-type MMIO Window  |     |     |
| ------ | ---------------------------------- | --- | --- |
0= Tri064-type MMIO window enabled at A8000H -AFFFFH. AOOOOH -A7FFF
available for image transfers (Default)
1 = Tri064-type MMIO window enabled at B8000H -BFFFFH. AOOOOH -B7FFFH are not
used (no image transfer area)
Bits 4-3 of this register must be programmed to lOb for this bit to be effective.
SYSTEM EXTENSION REGISTER DESCRIPTIONS  19-3

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bit 6  | SWP NBL -Swap Nibbles  |     |     |
| ------ | ---------------------- | --- | --- |
0= No nibble swap (Default)
1 = Swap nibbles in each byte of a linear memory address read or write operation
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
Extended Memory Control 2 Register (EX_MCTL_2) (CR54)
| Read/Write  |     | Address: 3?5H, Index 54H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  654       |     | 3  2  | o           |
| ------------ | --- | ----- | ----------- |
| M PARAMETER  |     | R     | BIG ENDIAN  |
Bits 1-0  BIG ENDIAN -Big Endian Data Byte Swap (not linear addressing or image writes)
00 = No swap (Default)
01 = Swap bytes within each word
10 = Swap all bytes in doublewords (bytes reversed)
11 = Swap according to BE[3:0] (VL-Bus) or C/BE[3:0] (PCI)
Byte enable settings for a bit setting of 11 b:
0000 = Swap all bytes in doublewords (bytes reversed)
0011 = Swap bytes within selected word
1100 = Swap bytes within selected word
All other values = no swap
| Bits 2, 7-3  | M PARAMETER  |     |     |
| ------------ | ------------ | --- | --- |
6-bit Value = maximum number of MCLKs that the LPB, CPU and Graphics Engine can
use to access memory before giving up control of the memory bus. See Section 7.5
for more information. Bit 2 is the high order bit of this value.
Extended RAMDAC Control Register (EX_DAC_CTJ (CR55)
| Read/Write  |     | Address: 3?5H, Index 55H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6      | 5  4      | 3  2    | 1  0  |
| --------- | --------- | ------- | ----- |
| TOFF      | MS        | ENB     |       |
| VCLK  R   | R  /Xl 1  | R  GIR  | R  R  |
| Bits 1-0  | Reserved  |         |       |
19-4 SYSTEM EXTENSION REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bit 2  | ENB GIR -Enable General Input Port Read  |     |     |
| ------ | ---------------------------------------- | --- | --- |
0= RAMDAC reads enabled
1 = General Input Port read enabled
When this bit is set to 1, the STRD strobe for reading General Input Port data is gener
ated when 3C8H is read. The data is transmitted via GD[7:0] to AD[7:0] for PCI configu
rations and directly to SD[7:0] for VL-Bus configurations.
| Bit 3  | Reserved                             |     |     |
| ------ | ------------------------------------ | --- | --- |
| Bit 4  | MS/X11 -Hardware Cursor MS/X11 Mode  |     |     |
o = MS-Windows mode (Default)
1 = X11-Windows mode
This bit select the type of decoding used for the 64x64x2 storage array of the hard
ware graphics cursor. See the Programming the Hardware Cursor section for a de
scription of the decoding.
| Bits 6-5  | Reserved                              |     |     |
| --------- | ------------------------------------- | --- | --- |
| Bit 7     | TOFF VCLK -Tri-State Off VCLK Output  |     |     |
o = Normal operation
1 = VCLK output is tri-stated off
External Sync Control 1 Register (EX_SVNC_1) (CR56)
| Read/Write  |     | Address: 3?5H, Index 56H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6   | 5  4                           | 3  2     | 1  0     |
| ------ | ------------------------------ | -------- | -------- |
|        |                                | DIS      | DIS      |
| R  R   | R  R                           | R  VSYN  | HSYN  R  |
| Bit 0  | Reserved                       |          |          |
| Bit 1  | DIS HSYN -Tri-state off HSYNC  |          |          |
o  = HSYNC output buffer tri-stated on
1 = HSYNC output buffer tri-stated off
| Bit 2  | DIS VSYN -Tri-state off VSYNC  |     |     |
| ------ | ------------------------------ | --- | --- |
o = VSYNC output buffer tri-stated on
1 = VSYNC output buffer tri-stated off
| Bits 7-3  | Reserved  |     |     |
| --------- | --------- | --- | --- |
SYSTEM EXTENSION REGISTER DESCRIPTIONS  19-5

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Linear Address Window Control Register (LAW_CTL) (CR58)
| Read/Write  |     | Address: 3?SH, Index 58H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: See the bit descriptions.
1
| 7  6      | 5  4                                  | 3  2    | 1  0      |
| --------- | ------------------------------------- | ------- | --------- |
| RAS       | ENB                                   | LAT     | LAW-SIZE  |
| PRE  R    | R  LA                                 | DEL  R  | 1  0      |
| Bits 1-0  | LAW-SIZE -Linear Address Window Size  |         |           |
00 = 64 KBytes (Default)
01 = 1 MByte
10 = 2 MBytes
11 = 4 MBytes
The 64K window is not available if new MMIO is enabled (CRS3_3 = 1).
| Bit 2  | Reserved                                            |     |     |
| ------ | --------------------------------------------------- | --- | --- |
| Bit 3  | LAT DEL -Address Latch Delay Control (VL-Bus only)  |     |     |
o = Address latching is delayed one clock (T2 cycle) (Default)
1 = Address latching occurs in the T1 cycle
This bit is effective only when one decode wait state is selected by setting bit 4 of
CR40 to 1.
| Bit 4  | ENB LA -Enable Linear Addressing  |     |     |
| ------ | --------------------------------- | --- | --- |
o = Disable linear addressing (Default for VL-Bus)
1 = Enable linear addressing (Default for PCI Bus)
Enabling linear addressing disables access to the AOOOH-AFFFH region unless bank
ing is enabled via bit 0 of CR31, the window size is set to 64K via bits 1-0 of this regis
ter and AOOOH is specified as the base in CRS9-SA.
| Bits 6-5  | Reserved                             |     |     |
| --------- | ------------------------------------ | --- | --- |
| Bit 7     | RAS PRE -RAS Pre-charge Time Adjust  |     |     |
o = RAS pre-charge (high) time is defined by CR68_3 or MM81 EC_16 (Default)
1 = RAS pre-charge (high) time is decreased by O.S MCLKs over that specified by
CR68_3 and the corresponding RAS low time (CR68_2) is increased by O.S
MCLKs. This leaves the total cycle time unchanged.
19-6 SYSTEM EXTENSION REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Linear Address Window Position Registers (LAW_POS(X) (CR59-5A)
Read/Write  Address: 3?5H, Index 59H-5AH
Power-On Default: OOOOH
LlNEAR-ADDRESS-WINDOW-POSITION
CR59 contains the upper byte (15-8) and CR5A contains the lower byte (7-0). These registers specify
the Linear Address Window Position in 32-bit CPU address space. The Linear Address Window resides
on a 64KB, 1M  B, 2MB or 4MB memory boundary (size-aligned boundary). Some LSBs of this register
(illustrated by "xx. . xx" in the following table) are ignored because ofthe size-aligned boundary scheme.
| LAW          | Linear Address Window     |             |             |
| ------------ | ------------------------- | ----------- | ----------- |
| Size         | Position Register Bit(s)  |             |             |
| 64KB  31-25  | 24  23  22                | 21  20  19  | 18  17  16  |
| 1MB  31-25   | 24  23  22                | 21  20  xx  | xx  xx  xx  |
| 2MB  31-25   | 24  23  22                | 21  xx  xx  | xx  xx  xx  |
| 4MB  31-25   | 24  23  22                | xx  xx  xx  | xx  xx  xx  |
Bits 15-0  LlNEAR-ADDRESS-WINDOW-POSITION -LA Window Position Bits 31-16
16-bit Value = the linear address window position in 32-bit CPU address space.
Bits 31-23 are common with bits 31-23 of the base address programmed into the PCI
Base Address 0 register at address 10H-12H. Writes to these bits in either register will
also be written to the other. In general, the bits should be programmed via the PCI
configuration register. Writes to CR59 and CR5A should be read-modify-writes that
do not change bits 31-23.
If a 64K window is specified and bit 0 of CR31 is set to 1, bits 5-0 of CR6A specify the
64K page of display memory to be accessed through a 64K window located at the ad
dress specified in these registers.
If new MMIO is enabled (CR53_3 = 1), the address is taken from bits 31-26 (CR59_7-2)
or the high order 6 bits of the PCI Base Address 0 register. This is concatenated with
the display memory address specified by the programmer.
SYSTEM EXTENSION REGISTER DESCRIPTIONS  19-7

Ii·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
General Output Port Register (GOUT_PORT) (CR5C)
| Read/Write  |     | Address: 3?5H, Index 5CH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6  | 543  | 2   |     |
| ----- | ---- | --- | --- |
GENERAL-aUT-PORT
| Bits 7-0  | GENERAL-aUT-PORT  |     |     |
| --------- | ----------------- | --- | --- |
This register can be used in a variety of ways. See Section 12-4 for a complete de
scription.
Extended Horizontal Overflow Register (EXT _H_OVF) (CR5D)
| Read/Write  |     | Address: 3?5H, Index 5DH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6   | 5  4                                               | 3  2      | 1  0     |
| ------ | -------------------------------------------------- | --------- | -------- |
| SFF    | EHS  SHS                                           | EHB  SHB  | HDE  HT  |
| R  8   | 6  8                                               | 7  8      | 8  8     |
| Bit 0  | HT 8 -Horizontal Total (CRO) Bit 8                 |           |          |
| Bit 1  | HOE 8 -Horizontal Display End (CR1) Bit 8          |           |          |
| Bit 2  | SHB 8 -Start Horizontal Blank (CR2) Bit 8          |           |          |
| Bit 3  | EHB 7 -End Horizontal Blank (CR3) Bit 7            |           |          |
| Bit 4  | SHS 8 -Start Horizontal Sync Position (CR4) Bit 8  |           |          |
| Bit 5  | EHS 6 -End Horizontal Sync (CR5) Bit 6             |           |          |
| Bit 6  | SFF 8 -Start FIFO Fetch (CR3B) Bit 8               |           |          |
| Bit 7  | Reserved                                           |           |          |
19-8 SYSTEM EXTENSION REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Extended Vertical Overflow Register (EXT_V_OVF) (CR5E)
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
Extended Memory Control 3 Register (EXT-MCTL-3) (CRGO
| Read/Write)  |     | Address: 3?5H, Index 60H  |     |     |     |
| ------------ | --- | ------------------------- | --- | --- | --- |
Power-On Default: OOH
| 7  6  | 543  |     | 2   |     | o   |
| ----- | ---- | --- | --- | --- | --- |
N(DISP-FETCH-PAGE)
| Bits 7-0  | N(DISP-FETCH-PAGE) -N Parameter  |     |     |     |     |
| --------- | -------------------------------- | --- | --- | --- | --- |
Value = Number of MCLKs allocated to Streams Processor FIFO filling before control
of the memory bus is relinquished. See Section 7.5 for more information.
SYSTEM EXTENSION REGISTER DESCRIPTIONS  19-9

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Extended Memory Control 4 Register (EXT-MCTL-4) (CR61)
| Read/Write  |     | Address: 3?5H, Index 61H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
o
| 7              | 6  5      | 4   | 3  2  | 1     |
| -------------- | --------- | --- | ----- | ----- |
| R  BIG ENDIAN  |           | R   | R  R  | R  R  |
| Bits 4-0       | Reserved  |     |       |       |
Bits 6-5  BIG ENDIAN -Big Endian Data Bye Swap (image writes only)
00 = No swap (Default)
01 = Swap bytes within each word
10 = Swap all bytes in doublewords (bytes reversed)
11 = Reserved
| Bit 7  | Reserved  |     |     |     |
| ------ | --------- | --- | --- | --- |
Extended Miscellaneous Control Register (EXT-MISC-CTL) (CR65)
| Read/Write  |     | Address: 3?5H, Index 65H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
D~Y BL4~K
| I :  I :  | I :  | I   | I :  | I  I :  I  |
| --------- | ---- | --- | ---- | ---------- |
R
| Bits 2-0  | Reserved                        |     |     |     |
| --------- | ------------------------------- | --- | --- | --- |
| Bits 4-3  | DLK BLANK -Delay BLANK by DCLK  |     |     |     |
00 = No delay of BLANK
01 = Delay BLANK for 1 DCLK
10 = Delay BLANK for 2 DCLKs (required for color mode 12)
11 = Delay BLANK for 3 DCLKs
| Bits 7-5  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
19-10 SYSTEM EXTENSION REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Extended Miscellaneous Control 1 Register (EXT-MISC-1) (CR66)
| Read/Write  |     | Address: 3?5H, Index 66H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6       | 5  4                                 | 3  2    | 1  0      |
| ---------- | ------------------------------------ | ------- | --------- |
| PCI  TOFF  |                                      | PCI     | SW  EN    |
| DE  PADT   | R  R                                 | DIS  R  | RST  ENH  |
| Bit 0      | °EN  ENH -Enable Enhanced Functions  |         |           |
= Disable enhanced functions
1 = Enable enhanced functions
This bit is a duplicate of 4AE8_0. Writing to this location also update the bit value at
the other location.
| Bit 1  | °SW  RST -Software Reset  |     |     |
| ------ | ------------------------- | --- | --- |
= No function
1 = Software reset of the Graphics Engine
Setting this bit has the same function as setting 42E8H (writeL1 5-14 to 10b.
| Bit 2  | Reserved                 |     |     |
| ------ | ------------------------ | --- | --- |
| Bit 3  | PCI DIS -PCI Disconnect  |     |     |
0= No effect
1 = An attempt to write data with the Command FIFO or LPB output FIFO full or to
read data with the Command FIFO not empty generates a PCI bus disconnect
cycle
Bit 7 of this register must also be set to 1 to enable this feature.
| Bits 5-4  | Reserved                                      |     |     |
| --------- | --------------------------------------------- | --- | --- |
| Bit 6     | °TO FF PADT -Tri-State Off Pixel Address Bus  |     |     |
= Normal operation
1 = PA[15:0) are set to tri-state off
| Bit 7  | °PC I DE -PCI bus disconnect enable  |     |     |
| ------ | ------------------------------------ | --- | --- |
= PCI bus disconnect disabled
1 = PCI bus disconnect enabled
Setting this bit to 1 allows PCI burst cycles to be interrupted if AD[1 :0) ;c OOb or if the
address during the burst goes outside the address ranges supported by the Tri064V+.
See also bit 3 of this register.
SYSTEM EXTENSION REGISTER DESCRIPTIONS  19-11

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Extended Miscellaneous Control 2 Register (EXT-MISC-2)(CR67)
| ReadNVrite  |     | Address: 3?5H, Index 67H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| I           | I  I                                       |                                    |         |
| ----------- | ------------------------------------------ | ---------------------------------- | ------- |
| 7  6        | 5  4                                       | 3  2                               | 1  0    |
| COLOR MODE  |                                            |                                    | VCLK    |
| 3  2        | 1  0                                       | R  R                               | R  PHS  |
| Bit 0       | VCLK PHS -VCLK Phase With Respect to DCLK  |                                    |         |
|             | 0= VCLK is 1800                            | out of phase with DCLK (inverted)  |         |
1 = VCLK is in phase with DCLK
| Bit 1     | Reserved      |     |     |
| --------- | ------------- | --- | --- |
| Bits 3-2  | STREAMS MODE  |     |     |
00 = Streams Processor disabled
01 = Secondary stream overlaid on VGA mode background
10 = Reserved
11 = Full Streams Processor operation (primary and secondary streams from all
supported sources)
| Bits 7-4  | COLOR MODE -RAMDAC Color Mode  |     |     |
| --------- | ------------------------------ | --- | --- |
0000 = Mode 0: 8-bit color, 1 pixelNCLK
0001 = Mode 8: 8-bit color, 2 pixelsNCLK
0011 = Mode 9: 15-bit color, 1 pixelNCLK
0101 = Mode 10: 16-bit color, 1 pixelNCLK
0111 = Mode 12: 640x480x24-bit color (packed), 1 pixel/3 DCLKs
1101 = Mode 13: 24-bit color, 1 pixelNCLK
All other mode values are reserved.
19-12 SYSTEM EXTENSION REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Configuration 3 Register (CNFG-REG-3) (CRGS)
| Read/Write  |     | Address: 375H, Index 68H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Depends on Strapping
This is one of the power-on strapping bits (along with CR36, CR37 and CR6F). PD[23:16] are sampled
on power-on reset and their states are written to bits 7-0 of this register. A5H must be written to CR39
to provide read/write access to this register.
| 7  6      | I  5  I  4           | 3  2       | 1  I  a     |
| --------- | -------------------- | ---------- | ----------- |
|           | BIOS                 | RAS - RAS- |             |
| MDB  3    | 2  1                 | PCG  LOW   | CAS/OE STR  |
| Bits 1-0  | CAS,OE Stretch Time  |            |             |
00 = approximately 6.5 ns stretch (nominal)
01 = approximately 5 ns stretch (nominal)
10 = approximately 3.5 ns stretch (nominal)
11 = no stretch
This parameter adjusts the timing for the rising edges of the CAS and OE signals.
This allows stretching of the signal active time for CAS and OE to allow more time for
valid pixel data to be available. The delay time shown above is an approximation. It is
affected by both process and signal loading and must be measured for each design.
| Bit 2  | RAS-LOW -RAS Low Timing Select  |     |     |
| ------ | ------------------------------- | --- | --- |
0= 4.5 MCLKs
1 = 3.5 MCLKs
This parameter specifies the length of the RAS active time for a single row/column ac
cess. RAS may be held low longer to accommodate additional page mode accesses
to the same row.
| Bit 3  | RAS-PCG -RAS Precharge Timing Select  |     |     |
| ------ | ------------------------------------- | --- | --- |
0= 3.5 MCLKs
1 = 2.5 MCLKs
When RAS goes high to end a memory cycle, this parameter specifies the minimum
period it must be held high before beginning another memory access cycle.
| Bits 6-4  | BIOS -Reserved for use by the video BIOS.  |     |     |
| --------- | ------------------------------------------ | --- | --- |
| Bit 7     | MOB -Memory Data Bus Size                  |     |     |
a
= Memory data bus is 32 bits
1 = Memory data bus is 32 bits (1 MByte of memory) or 64 bits (2 or 4 MBytes of
memory)
SYSTEM EXTENSION REGISTER DESCRIPTIONS  19-13

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Extended System Control 3 Register (EXT-SCTL-3)(CR69)
| ReadIWrite  |     | Address: 3?5H, Index 69H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6      | 5  4                   | 3  2                    | 1   |
| --------- | ---------------------- | ----------------------- | --- |
| R  R      | R  R                   | DISPLA Y-START-ADDRESS  |     |
| Bits 3-0  | DISPLAY-START-ADDRESS  |                         |     |
This field contains the upper 4 bits (19-16) of the display start address, allowing ad
dressing of up to 4 MBytes of display memory. When a non-zero value is
programmed in this field, bits 5-4 of CR31 and 1-0 of CR51 (the old display start ad
dress bits) are ignored.
| Bits 7-4  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Extended System Control 4 Register (EXT-SCTL-4)(CR6A)
| ReadIWrite  |     | Address: 3?5H, Index 6AH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6      | 5  432            |                   | 1   |
| --------- | ----------------- | ----------------- | --- |
| R  R      |                   | CPU-BASE-ADDRESS  |     |
| Bits 5-Q  | CPU-BASE-ADDRESS  |                   |     |
This field contains the upper 6 bits (19-14) of the CPU base address, allowing access
ing of up to 4 MBytes of display memory via 64K pages. When a non-zero value is
programmed in this field, bits 3-0 of CR35 and 3-2 of CR51 (the old CPU base address
bits) are ignored. Bit 0 of CR31 must be set to 1 to enable this field. If linear address
ing is enabled and a 64 KByte window is specified, these bits specify the 64K page to
be accessed at the base address specified in CR59 and CR5A. Otherwise, the base ad
dress is normally at AOOOH.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
19-14 SYSTEM EXTENSION REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Extended BIOS Flag 3 Register (EBIOS·FLG3)(CR6B)
| Read/Write  |     | Address: 3?5H, Index 6BH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
EXT-BIOS-FLAG-REGISTER-3
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-3  |     |     |
| --------- | ------------------------- | --- | --- |
This register is reserved for use by the S3 BIOS.
Extended BIOS Flag 4 Register (EBIOS-FLG4)(CR6C)
| Read/Write  |     | Address: 3?5H, Index 6CH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6  | 543  | 2   |     |
| ----- | ---- | --- | --- |
EXT-BIOS-FLAG-REGISTER-4
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-4  |     |     |
| --------- | ------------------------- | --- | --- |
This register is reserved for use by the S3 BIOS.
Extended BIOS Flag 5 Register (CR60)
| Read/Write  |     | Address: 3?5H, Index 6DH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register is reserved for use by the BIOS.
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
RESERVED
| Bits 7-0  | Reserved  |     |     |
| --------- | --------- | --- | --- |
SYSTEM EXTENSION REGISTER DESCRIPTIONS  19-15

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Extended BIOS Flag 6 Register (CR6E)
ReadIWrite Address: 3?5H, Index 6EH
Power-On Default: OOH
This register is reserved for use by the BIOS.
7 6 5 4 3 2 o
RESERVED
Bits 7-0 Reserved
Configuration 4 Register (CR6F)
See description Address: 3?5H, Index 6FH
Power-On Default: Depends on Strapping
This is the fourth byte of power-on strapping bits. PD[28:24] are sampled at reset and the values are
written to bits 4-0 of this register. A5H must be written to CR39 to provide read/write access to this
register. This register will power up with a value of 1FH if any of PD[28:24] are not pulled low.
7 6 5
R R R
Bit 0 MODE -Tri064 Compatible Mode Select
o = The Tri064V+ is configured for LPB mode
1 = The Tri064V+ is configured for Tri064-compatible mode
Bit 1 10SEL -Serial Port I/O Address Select (read/write)
o
= MMFF20 is accessed at I/O address 000E8H
1 = MMFF20 is accessed at I/O address 000E2H
Bit 2 of this register must be cleared to 0 for this bit to have effect.
Bit 2 10EN -Serial Port Address Type Select (read/write)
0= MMFF20 is accessed at the I/O port defined in bit 1 of this register or at its MMIO
address
1 = MMFF20 is accessed at its MMIO address only (no I/O)
Enabling I/O access allows the serial port to be used for 12C communications when
the Tri064V+ is disabled.
19-16 SYSTEM EXTENSION REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bits 4-3 WE Delay (read/write)
00 = 3 units delay
01 = 2 units delay
10 = 1 unit delay
11 = 0 units delay
Both the rising and falling edges of WE are delayed by the amount specified in these
bits.
Bits 7-5 Reserved
SYSTEM EXTENSION REGISTER DESCRIPTIONS 19-17

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated

~.
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 20: Enhanced Commands Register Descriptions
These registers support the Enhanced mode drawing commands. Access to these registers is enabled
via bit 0 of the System Configuration register (CR40).
In the following register descriptions, 'R' stands for reserved (write = 0, read = undefined). See Appendix
A for a table listing each of the registers in this section and its page number.
Subsystem Status Register (SUBSVS_STAT)
| Read Only  | Address: 42E8H  |     |     |     |     |
| ---------- | --------------- | --- | --- | --- | --- |
Power-On Default: OOOOH
This read-only register provides information on interrupt status, monitor I.D. and the number of bits
per pixel. See the Subsystem Control (42E8H, Write Only) register for details on enabling and clearing
interrupts.
| 15  14  13                                      | 12  11  10  | 9  8  7    | 6  5  | 4  3  2           | 1  0  |
| ----------------------------------------------- | ----------- | ---------- | ----- | ----------------- | ----- |
|                                                 |             | PXL        |       | FIFO  FIFO  GE    | VSY   |
| R  R  R                                         | R  R  R     | R  R  LNG  | R  R  | R  EMP  OVF  BSY  | INT   |
| Bit 0  VSY INT -Vertical Sync Interrupt Status  |             |            |       |                   |       |
o
= No interrupt
1 = Interrupt generated if enabled
| Bit 1  GE BSY -Graphics Engine Busy Interrupt Status  |     |     |     |     |     |
| ----------------------------------------------------- | --- | --- | --- | --- | --- |
0= No interrupt
1 = Interrupt generated if enabled
| Bit 2  FIFO OVF -Command FIFO Overflow Interrupt Status  |     |     |     |     |     |
| -------------------------------------------------------- | --- | --- | --- | --- | --- |
0= No interrupt
1 = Interrupt generated if enabled
| Bit 3  FIFO EMP -Command FIFO Empty Interrupt Status  |     |     |     |     |     |
| ----------------------------------------------------- | --- | --- | --- | --- | --- |
o  = No interrupt
1 = Interrupt generated if enabled
| Bits 4-6  Reserved  |     |     |     |     |     |
| ------------------- | --- | --- | --- | --- | --- |
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bit 7  PXL LNG -Pixel Length (# of bit planes)  |     |     |     |     |     |
| ----------------------------------------------- | --- | --- | --- | --- | --- |
0= 4-bit
1 = 8-bit
This reflects the number of bit planes when CRSO_S-4 = OOb.
| Bits 15-8  Reserved  |     |     |     |     |     |
| -------------------- | --- | --- | --- | --- | --- |
Subsystem Control Register (SUBSYS_CNTL)
| Write Only  | Address: 42E8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: OOOOH
This register allows each of several interrupt sources to be enabled or disabled. Interrupt status (Subsystem
Status (42E8H, Read Only) can be cleared. This register also controls the software reset of the graphics engine.
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
, = Clear
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
, = Enable if CR323 = 1
| Bit 9  GE BSY-Graphics Engine Busy Interrupt Enable  |     |     |     |     |     |
| ---------------------------------------------------- | --- | --- | --- | --- | --- |
0= Disable
1 = Enable if CR323 = 1
Bit 10  FIFO-ENB OVF -Command FIFO Overflow Interrupt Enable
0= Disable
1 = Enable if CR32_ 4 = 1
20-2  ENHANCED COMMANDS REGISTER DESCRIPTIONS

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bit 11  FIFO-ENB EMP -Command FIFO Empty Interrupt Enable  |     |     |     |     |     |
| ---------------------------------------------------------- | --- | --- | --- | --- | --- |
0= Disable
1 = Enable if CR32_ 4 = 1
| Bits 13-12  Reserved                                |     |     |     |     |     |
| --------------------------------------------------- | --- | --- | --- | --- | --- |
| Bits 15-14  GE-RST -Graphics Engine Software Reset  |     |     |     |     |     |
00 = No change
01 = Graphics Engine enabled
10 = Reset
11 = Reserved
Advanced Function Control Register (ADVFUNC_CNTL)
| Read/Write  | Address: 4AE8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: OOOOH
This register enables or disables the Enhanced display functions.
| 15  14  13                                  | 12  11  10  | 9  8  7  | 6  5  4   | 3  2   | 1  0     |
| ------------------------------------------- | ----------- | -------- | --------- | ------ | -------- |
|                                             |             |          |           | ENH    | ENS      |
| R  R  R                                     | R  R  R     | R  R  R  | R  R  LA  | R  PL  | R  EHFC  |
| Bit 0  ENB EHFC -Enable Enhanced Functions  |             |          |           |        |          |
0= Enable VGA and VESA planar (4 bits/pixel) modes
1 = Enable all other modes (Enhanced and VESA non-planar)
| Bit 1  Reserved                            |     |     |     |     |     |
| ------------------------------------------ | --- | --- | --- | --- | --- |
| Bit 2  ENH PL -Enhanced mode pixel length  |     |     |     |     |     |
o = 4 bits/pixel enhanced mode
1 = 8 or more bits/pixel enhanced mode
CR50_5-4 are used to differentiate between 8-,16-and 32-bit pixel lengths.
| Bit 3  Reserved                      |     |     |     |     |     |
| ------------------------------------ | --- | --- | --- | --- | --- |
| Bit 4  LA -Enable Linear Addressing  |     |     |     |     |     |
o
= Disable linear addressing
1 = Enable linear addressing
This bit is ORed with bit 4 of CR58 and is equivalent to it.
| Bits 15-5  Reserved  |     |     |     |     |     |
| -------------------- | --- | --- | --- | --- | --- |
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-3

fl·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Current V-Position Register (CUR_V)
Read/Write Address: 82E8H
Power-On Default: Undefined
For line draws (solid, textured, short stroke or polyline), rectangle draws and image transfers, writing
to this register defines the vertical screen coordinate at which the first pixel will be drawn. For BitBlT s,
this is the vertical coordinate for the upper left hand corner of the destination. For PatBlT s, this is the
vertical coordinate ofthe upper left hand corner of the off-screen pattern. Reading this register produces
the current vertical drawing coordinate.
Bits 11-0 CURRENT V-POSITION
Bits 15-12 Reserved
Current X-Position Register (CUR_X)
Read/Write Address: 86E8H
Power-On Default: Undefined
For line draws (solid, textured, short stroke or polyline), rectangle draws and image transfers, writing
to this register defines the horizontal screen coordinate at which the first pixel will be drawn. For
BitBlT s, this is the horizontal coordinate for the upper left hand corner of the destination. For PatBlT s,
this is the horizontal coordinate of the upper left hand corner of the off-screen pattern. Reading this
register produces the current horizontal drawing coordinate.
Bits 11-0 CURRENT X-POSITION
Bits 15-12 Reserved
20-4 ENHANCED COMMANDS REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Destination V -Position/ Axial Step Constant Register (DESTV _AXSTP)
Read/Write Address: 8AE8H
Power-On Default: Undefined
For BitBLTs and PatBL Ts, this register defines the vertical position for the top of the destination
rectangle. For solid and textured line draws, this is axial step constant used in the definition of the line.
Bits 11-0 DESTINATION V-POSITION
Bits 15-12 Reserved
Axial Step Constant = 2 * (minqdxl,ldyP) In other words, when drawing a line from point A to point B,
determine the change in the X coordinate from A to B and the change in the V coordinate from A to B.
Take the smaller of the two changes and multiply its absolute value by 2.
Bits 13-0 LINE PARAMETER AXIAL STEP CONSTANT
Bits 15-14 Reserved
Destination X-Position/Diagonal Step Constant Register (DESTX_DIASTP)
Read/Write Address: 8EE8H
Power-On Default: Undefined
For BitBLT s and PatBL Ts, this register defines the horizontal position for the left side of the destination
rectangle. For solid and textured line draws, this is diagonal step constant used in the definition of the
line.
Bits 11-0 DESTINATION X-POSITION
Bits 15-12 Reserved
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-5

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Diagonal Step Constant = 2 * [min(ldxl,ldyi)-max(ldxl,ldYi)I. See the Destination Y-Position/Axial Step
Constant (8AE8H) register for an explanation of the terms used in this equation.
Bits 13-0 LINE PARAMETER DIAGONAL STEP CONSTANT
Bits 15-14 Reserved
Line Error Term Register (ERR_TERM)
Read/Write Address: 92E8H
Power-On Default: Undefined
This register specifies the initial error term for solid and textured line draws.
Error Term = 2 * min(ldxl,ldyi)-max(ldxl,ldyl-1 if the starting X < the ending X
Error Term = 2 * min(ldxl,ldyi)-max(ldxl,ldYI if the starting X ~ the ending X
See the Destination Y-Position/Axial Step Constant (8AE8H) register for an explanation of the terms
used in these equations.
Bits 13-0 LINE PARAMETER/ERROR TERM
Bits 15-14 Reserved
Major Axis Pixel Count Register (MAJ_AXIS_PCNT)
Read/Write Address: 96E8H
Power-On Default: Undefined
This register specifies the length (in pixels) of the major (longest) axis for solid and textured lines and
the width for rectangles, image transfers, BitBLT s and PatBL Ts.
Bits 11-0 RECTANGLE WIDTH/LINE PARAMETER MAX
The value is the number of pixels along the major axis -1.
Bits 15-12 Reserved
20-6 ENHANCED COMMANDS REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Graphics Processor Status Register (GP _STAT)
| Read Only  | Address: 9AE8H  |     |     |     |     |
| ---------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
| I  I                   | l  L    |             | I  I  | I  I  I      | I  I  |
| ---------------------- | ------- | ----------- | ----- | ------------ | ----- |
| 15  14  13             | 12  11  | 10  9  8    | 7  6  | 5  4  3  2   | 1  0  |
| FIFO-STATUS            |         | HDW         |       | FIFO-STATUS  |       |
| 9  10  11              | 12  13  | AE  BSY  R  | 1  2  | 3  4  5  6   | 7  8  |
| Bits 7-0  FIFO-STATUS  |         |             |       |              |       |
In the following table, the leftmost column represents the value of FIFO status bit 1
(register bit 7). Each column to the right represents the value of the next higher FIFO
status bit. A value of 0 read from any particular status bit position guarantees at least
as many open FIFO slots as the number of that status bit. For example, if a 0 is read
from status bit 6 (register bit 2), there are at least 6 open FIFO slots. Bits 15-11 pro
vide the upper 5 FIFO status bits.
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
1111111111111 =0 FIFO slots available
| Bit 8  Reserved                                  |     |     |     |     |     |
| ------------------------------------------------ | --- | --- | --- | --- | --- |
| Bit 9  HDW BSY -Hardware (Graphics Engine) Busy  |     |     |     |     |     |
0= not busy
1 = busy -graphics command is executing
| Bit 10  AE -All FIFO Slots Empty  |     |     |     |     |     |
| --------------------------------- | --- | --- | --- | --- | --- |
o = At least one FIFO slot is occupied
1 = All FIFO slots empty
| Bits 15-11  FIFO-STATUS  |     |     |     |     |     |
| ------------------------ | --- | --- | --- | --- | --- |
These are the upper 5 bits of the FIFO status. See bits 7-0 for the interpretation.
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-7

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Drawing Command Register (CMD)
| Write Only  |     | Address: 9AE8H  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the drawing command and a number of associated control parameters.
| I  I    |             | J      | I  J     |             |       |
| ------- | ----------- | ------ | -------- | ----------- | ----- |
| 15  14  | 13  12  11  | 10  9  | 8  7  6  | 5  4  3  2  | 1  0  |
CMD-TYPE  BYTE  BUS SIZE  WAIT  DRWG-DIR.  DRA\/\  DIR  LAST  PX
| 2  1   | a  SWP  R                                  | 1  a  YES  | 2  1  | a  YES  TYP  POF  | MD  = 1  |
| ------ | ------------------------------------------ | ---------- | ----- | ----------------- | -------- |
| Bit 0  | This bit must always be programmed to 1.   |            |       |                   |          |
| Bit 1  | PX MD -Select Across the Plane Pixel Mode  |            |       |                   |          |
o
= Single pixel transferred at a time
1 = Multiple pixels transferred at a time (across the plane mode)
| Bit 2  | LAST POF -Last Pixel Off  |     |     |     |     |
| ------ | ------------------------- | --- | --- | --- | --- |
0= Last pixel of line or vector draw will be drawn
1 = Last pixel of line or vector draw will not be drawn
| Bit 3  | DIR TYP -Select Radial Direction Type  |     |     |     |     |
| ------ | -------------------------------------- | --- | --- | --- | --- |
o = x-y (axial)
1 = Radial
| Bit 4  | DRAW YES -Draw Pixel  |     |     |     |     |
| ------ | --------------------- | --- | --- | --- | --- |
0= Move the current position only -don't draw
1 = Draw pixel(s)
| Bits 7-5  | DRWG-DIR -Select Drawing Direction  |     |     |     |     |
| --------- | ----------------------------------- | --- | --- | --- | --- |
In the following table, radial drawing angle is measured counterclockwise from the X
axis. For axial line draws, the line is drawn from left to right or a +X and from right to
left for a -X, down for a +Y and up for a -Yo X or Y maj specifies the longest axis.
|     |                     | =   | =                  |     |     |
| --- | ------------------- | --- | ------------------ | --- | --- |
|     | 7-5  Radial (bit 3  | 1)  | x-v (Axial -bit 3  |     |     |
0)
|     | 000  | 00    | -Y,X maj,-X  |     |     |
| --- | ---- | ----- | ------------ | --- | --- |
|     | 001  | 450   | -Y,X maj,+X  |     |     |
|     | 010  | 900   | -Y,Y maj,-X  |     |     |
|     | all  | 1350  | -Y,Y maj,+X  |     |     |
|     | 100  | 1800  | +Y,Xmaj,-X   |     |     |
|     | 101  | 2250  | +Y,Xmaj,+X   |     |     |
|     | 110  |       | +Y,Y maj,-X  |     |     |
2700
|        | 111                          | 3150  | +Y,Ymaj,+X  |     |     |
| ------ | ---------------------------- | ----- | ----------- | --- | --- |
| Bit 8  | WAIT YES -Wait for CPU Data  |       |             |     |     |
0= Use Graphics Engine-based data
1 = Wait for data to be transferred to or from the CPU through the E2E8H port
20-8 ENHANCED COMMANDS REGISTER DESCRIPTIONS

II·
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporatad
Bits 10-9 BUS SIZE -Select image write {E2E8H, E2EAH} bus transfer width
00 = 8 bits
01 = 16 bits
10 = 32 bits. All doubleword bits beyond the image rectangle width are discarded.
Each line starts with a fresh doubleword. The current drawing position ends up
one pixel below the lower left hand corner of the image rectangle.
11 = 32 bits. This setting applies only to image transfers across the plane {each bit
transferred is converted to a pixel}. Only bits from the end ofthe line width to the
next byte boundary are discarded. Data for the next line begins with the next
byte. The current drawing position ends up one pixel to the right of the top right
corner of the image rectangle.
This parameter applies only to writing data through the Pixel Data Transfer {E2E8H,
E2EAH} registers (programmed I/O or memory-mapped I/O).
Bit 11 Reserved
Bit 12 BYTE SWP -Enable Byte Swap
0= High byte first, low byte second
1 = low byte first, high byte second
Bits 15-13 CMD-TYPE -Select Command Type
000 = NOP. This is used to set up short stroke vector drawing without writing a pixel.
001 = Draw Line. If bit 3 of this register is cleared to 0, the axial step constant,
diagonal step constant and error term are used to draw the line. If bit 3 is set to
1, the line will be drawn at the angle specified by bits 7-5 and with a length in
pixels as specified by the Major Axis Pixel Count (96EBH) register.
010 = Rectangle Fill. The position, width and height of a rectangle are defined. The
rectangle is filled with a solid color if it not used for an image transfer.
110 = BitBlT . A rectangle of defined location, width and height is moved to another
defined location in display memory.
111 = PatBlT . An 8x8 pixel patterned rectangle of defined location is transferred
repeatedly to a destination rectangle of defined location, width and height. The
pattern copy is always aligned to an 8 pixel boundary and transfers continue
until the pattern is tiled into the entire destination rectangle. The starting X
coordinate of the source pattern rectangle should always be on an 8 pixel
boundary.
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-9

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Short Stroke Vector Transfer Register (SHORT_STROKE)
Write Only Address: 9EE8H
Power-On Default: Undefined
This register defines two short stroke vectors. These are drawn one at a time based on the setting of
the BYTE SWAP bit (bit 12) in the Command (9AE8H) register.
15 I 14 I 13 12 11 I 10 I 9 I 8 7 I 6 I 5 4 3 I 2 I 1 I 0
DRWG-DIR DRW PIXEL-LENGTH DRWG-DIR. DRW PIXEL-LENGTH
2 1 0 -MV 3 2 1 0 2 1 0 -MV 3 2 1 0
Bits 3-0 PIXEL-LENGTH
Value = # pixels -1
Bit 4 DRW -MV -Draw Pixel
o = Move current position only -don't draw
1 = Draw pixel
Bits 7-5 DRWG-DIR.-Select Drawing Direction (measured counterclockwise from the X axis)
000 = 00
001 = 450
010 = 900
011=1350
100 = 1800
101 =2250
110 =2700
110=3150
Bits 15-8 These bits duplicate bits 7-0 to define the second short stroke vector.
20-10 ENHANCED COMMANDS REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Background Color Register (BKGD_COLORI
| Read/Write  |     | Address: A2E8H  |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- |
Power-On Default: Undefined
See the Enhanced Mode Bitmap Accessing Through the Graphics Engine section in the Functional
Description for a detailed explanation of how and when this color value is used when writing a pixel
to display memory.
| I  I    | I  I        | I  I  | I     | I  I  | I  I     | I  I  I  | I  0  |
| ------- | ----------- | ----- | ----- | ----- | -------- | -------- | ----- |
| 15  14  | 13  12  11  | 10    | 9  8  | 7     | 6  5  4  | 3  2  1  |       |
BACKGROUND COLOR
I  J
31  I  30  I  29  I 28l 27  I 26  I  25  I 24  l 23  22  21  I 20  I  19  I 181  17  I 16
BACKGROUND COLOR
| Bits 31-0  | BACKGROUND COLOR  |     |     |     |     |     |     |
| ---------- | ----------------- | --- | --- | --- | --- | --- | --- |
If bit 9 of BEE8_EH is set to 1 for programmed I/O (not MMIO), this becomes a 32-bit
register. If bit 9 of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode
with 16-bit registers, the upper and lower doublewords are read or written sequen
tially, depending on the state of the RSF flag (bit 4 of BEE8H, Index EHI. If RSF = 0, the
lower 16 bits are accessed. If RSF = 1, the upper 16 bits are accessed. The RSF flag
toggles automatically when a doubleword is read or written.
Foreground Color Register (FRGD_COLORI
| Read/Write  |     | Address: A6E8H  |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- |
Power-On Default: Undefined
See the Enhanced Mode Bitmap Accessing Through the Graphics Engine section in the Functional
Description for a detailed explanation of how and when this color value is used when writing a pixel
to display memory.
|             | 1 11       | I  I  | I     | I   | I  5  141  | I  I     | I  0  |
| ----------- | ---------- | ----- | ----- | --- | ---------- | -------- | ----- |
| 151  14  1  | 13  1  12  | 10    | 9  8  | 71  | 6          | 3  2  1  |       |
FOREGROUND COLOR
| 31  1~1~1~lnl~I~I~I~lnl 21  |     |     |     |     | I 20  | I  19  I  18  I 17  | I 16  |
| --------------------------- | --- | --- | --- | --- | ----- | ------------------- | ----- |
FOREGROUND COLOR
| Bits 31-0  | FOREGROUND COLOR  |     |     |     |     |     |     |
| ---------- | ----------------- | --- | --- | --- | --- | --- | --- |
If bit 9 of BEE8_EH is set to 1 for programmed I/O (not MMIO)' this becomes a 32-bit
register. If bit 9 of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode
with 16-bit registers, the upper and lower doublewords are read or written sequen
tially, depending on the state of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the
lower 16 bits are accessed. If RSF = 1, the upper 16 bits are accessed. The RSF flag
toggles automatically when a doubleword is read or written.
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-11

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bitplane Write Mask Register (WRT _MASK)
| Read/Write  |     | Address: AAE8H  |     |     |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-On Default: Undefined
| I  I        | I  I  | I       | I  I  | I     | I  I  | I     | I  I  | I     | I   |
| ----------- | ----- | ------- | ----- | ----- | ----- | ----- | ----- | ----- | --- |
| 15  14  13  | 12    | 11  10  | 9     | 8  7  | 6     | 5  4  | 3     | 2  1  | 0   |
BIT-PLANE WRITE MASK
| I  I  | I   | I   | I  I  | I   | I  I  | I   | I  I  | I   | I   |
| ----- | --- | --- | ----- | --- | ----- | --- | ----- | --- | --- |
31  30  29  28  I 27  26  25  24  23  22  21  20  19  18  17  16
BIT-PLANE WRITE MASK
| Bits 31-0  BIT-PLANE WRITE MASK  |     |     |     |     |     |     |     |     |     |
| -------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
If bit i = 0, bitplane i is not updated
If bit i = 1, bitplane i is updated
Bits 31-0 control planes 31-0 respectively. If bit 9 of BEEB_EH is set to 1 for pro
grammed I/O (not MMIO), this becomes a 32-bit register. If bit 9 of BEE8_EH is cleared
to 0, this is two 16-bit registers. In 32 bpp mode with 16-bit registers, the upper and
lower doublewords are read or written sequentially, depending on the state of the
RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the lower 16 bits are accessed. If RSF =
1, the upper 16 bits are accessed. The RSF flag toggles automatically when a double
word is read or written.
Bitplane Read Mask Register (RD_MASK)
| Read/Write  |     | Address: AEE8H  |     |     |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-On Default: Undefined
| I  I        | I  I  | I       | I  I  | I     | I  I  | I     | I  I  | I     | I   |
| ----------- | ----- | ------- | ----- | ----- | ----- | ----- | ----- | ----- | --- |
| 15  14  13  | 12    | 11  10  | 9     | 8  7  | 6     | 5  4  | 3     | 2  1  | 0   |
BIT-PLANE READ MASK
| I  I        | I  I  | I       | I  I  | I       | I  I  | I       | I  I  | 1       | 1  16  |
| ----------- | ----- | ------- | ----- | ------- | ----- | ------- | ----- | ------- | ------ |
| 31  30  29  | 28    | 27  26  | 25    | 24  23  | 22    | 21  20  | 19    | 18  17  |        |
BIT-PLANE READ MASK
| Bits 31-0  BIT-PLANE READ MASK  |     |     |     |     |     |     |     |     |     |
| ------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
If bit i = 0, bitplane i is not used as a data source
If bit i = 1, bitplane i is used as a data source
Bit-plane read mask for BitBLT and image transfer functions. Bits 31-0 control planes
31-0 respectively. If bit 9 of BEE8_EH is set to 1 for programmed I/O (not MMIO), this
becomes a 32-bit register. If bit 9 of BEE8_EH is cleared to 0, this is two 16-bit regis
ters. In 32 bpp mode with 16-bit registers, the upper and lower doublewords are read
or written sequentially, depending on the state of the RSF flag (bit 4 of BEE8H, Index
EH). If RSF = 0, the lower 16 bits are accessed. If RSF = 1, the upper 16 bits are ac
cessed. The RSF flag toggles automatically when a doubleword is read or written.
20-12  ENHANCED COMMANDS REGISTER DESCRIPTIONS

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Color Compare Register (COLOR_CMP)
| Read/Write  | Address: B2E8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
This register contains the color value that is compared against the current bitmap color if the color
compare option is turned on by setting bit 8 of the Pixel Control (BEE8H, Index OEH) to 1. Bit 7 of the
Pixel Control register determines whether a match or a non-match results in a pixel update.
15  1 14  1 13  1 12  1 11  1 10  1  9  1  8  1  7  1  6  1  5  1  4  1  3  1  2  1  1  1  0
COMPARISON COLOR WITH SOURCE
| I   | J   |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
311  30  29  28  1 27  1 26  1 25  1 24  1 23  1 22  1 21  1 20  1 19  1 18  1 17  1 16
COMPARISON COLOR WITH SOURCE
| Bits 31-0  COMPARISON COLOR WITH SOURCE  |     |     |     |     |     |
| ---------------------------------------- | --- | --- | --- | --- | --- |
If bit 9 of BEE8_EH is set to 1 for programmed I/O (not MMIO), this becomes a 32-bit
register. If bit 9 of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode
with 16-bit registers, the upper and lower doublewords are read or written sequen
tially, depending on the state of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the
lower 16 bits are accessed. If RSF = 1, the upper 16 bits are accessed. The RSF flag
toggles automatically when a doubleword is read or written.
Background and Foreground Mix Registers (BKGD_MIX, FRGD_MIX)
| Read/Write  | Address: B6E8H (Background), BAE8H (Foreground)  |     |     |     |     |
| ----------- | ------------------------------------------------ | --- | --- | --- | --- |
Power-On Default: Undefined
See the Enhanced Mode Bitmap Accessing Through the Graphics Engine section in the Functional
Description for a detailed explanation of how and when these registers are used when writing a pixel
to display memory.
| 15  14  13                           | 12  11  10  | 9  8  7  | 615  4   | 3  1  2  1  11  | 0   |
| ------------------------------------ | ----------- | -------- | -------- | --------------- | --- |
|                                      |             |          | CLR-SRC  | MIX-TYPE        |     |
| R  R  R                              | R  R  R     | R  R  R  | 1  0  R  | 3  2  1         | 0   |
| Bits 3-0  MIX-TYPE -Select Mix Type  |             |          |          |                 |     |
In the general case, a new color is defined. A logical operation such as AND or OR is
then performed between it and the current bitmap color. If the bitplane to be written
is enabled, the result of this logical "mix" is written to the bitmap as the new pixel
color. The following table shows the mix types available (I = logical NOT).
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-13

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
|           | 0000                          | !current             | 1000  | !current OR !new   |     |
| --------- | ----------------------------- | -------------------- | ----- | ------------------ | --- |
|           | 0001                          | logical zero         | 1001  | current OR !new    |     |
|           | 0010                          |                      | 1010  |                    |     |
|           |                               | logical one          |       | !current OR new    |     |
|           | 0011                          | leave current as is  | 1011  | current OR new     |     |
|           | 0100                          | !new                 | 1100  | current AND new    |     |
|           | 0101                          |                      | 1101  |                    |     |
|           |                               | current XOR new      |       | !current AND new   |     |
|           | 0110                          | !(current XOR new)   | 1110  | current AND !new   |     |
|           | 0111                          | new                  | 1111  | !current AND !new  |     |
| Bit 4     | Reserved                      |                      |       |                    |     |
| Bits 6-5  | CLR-SRC -Select Color Source  |                      |       |                    |     |
00 = Background Color register is the color source
01 = Foreground Color register is the color source
10 = CPU data (the CPU is the color source)
11 = Display memory (the display memory is the color source)
| Bits 15-7  | Reserved  |     |     |     |     |
| ---------- | --------- | --- | --- | --- | --- |
Read Register Data Register (RD_REG_DTl
| Read Only  |     | Address: BEE8H  |     |     |     |
| ---------- | --- | --------------- | --- | --- | --- |
Power-On Default: Undefined
A read of this register produces a read of the register specified by bits 2-0 of the Read Register Select
(BEE8H, Index OFH) register. Each read of BEE8H causes the read index (bits 2-0 of BEE8H, Index OFH)
to increment by one. Registers BEE8H, Indices OH to OEH, 9AE8H, 42E8H and 46E8H can thus be rapidly
read by successive reads from BEE8H.
Note: Writes to the BEE8H registers (except the read index register, Index OFH) are pipelined. Therefore,
to correctly read back a write to one of these registers, issue a NOP drawing command (a write to
9AE8H with bits 15-13 programmed to OOOb) immediately after the BEE8H register write. Next, write
the desired register index to BEE8H, Index OFH and read the data from BEE8H.
The BEE8H registers are written directly by writing to BEE8H with the appropriate register index in bits
15-12.
| I        | I  I  | I  I  I     | I  I  I  | I  I  I  | I  I  I     |
| -------- | ----- | ----------- | -------- | -------- | ----------- |
| 115  14  | 13    | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  0  |
20-14 ENHANCED COMMANDS REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
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
Left Scissors (SCISSORS_L)
Write Only Address: BEE8H, Index 2H
Power-On Default: Undefined
This register specifies the left side of the clipping rectangle. It is the lowest X value that will be drawn.
Bits 11-0 CLIPPING LEFT LIMIT
Bits 15-12 INDEX = 2H
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-15

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bottom Scissors (SCISSORS_B)
| Write Only  | Address: BEE8H, Index 3H  |     |     |     |     |
| ----------- | ------------------------- | --- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the bottom of the clipping rectangle. It is the highest Y value that will be drawn.
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
Pixel Control Register (PIX_CNTL)
| Write Only  | Address: BEE8H, Index OAH  |     |     |     |     |
| ----------- | -------------------------- | --- | --- | --- | --- |
Power-On Default: Undefined
See Bitmap Access Through the Graphics Engine in the Enhanced Mode Programming section for an
explanation of how and when bits 7-6 ofthis register are used when writing a pixel to display memory.
I
| 15  14  13  | 12  11  10  | 9  8  | 7  6  5  | 4  3  2  | 1  0  |
| ----------- | ----------- | ----- | -------- | -------- | ----- |
DT-EX-SRC
| 1  0  1             | 0  R  R  | R  R  | 1  0  R  | R  R  R  | R  R  |
| ------------------- | -------- | ----- | -------- | -------- | ----- |
| Bits 5-0  Reserved  |          |       |          |          |       |
20-16 ENHANCED COMMANDS REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Bits 7-6 DT-EX-SRC -Select Mix Register
00 = Foreground Mix register is always selected
01 = Reserved
10 = CPU data determines Mix register selected
11 = Display memory current value determines Mix register selected
Bits 11-8 Reserved
Bits 15-12 INDEX = OAH
Multifunction Control Miscellaneous 2 Register (MULLMISC2)
Write Only Address: BEE8H, Index ODH
Power-On Default: DOOOH
Bits 2-0 DST-BASE -Destination Base Address
000 = First destination memory address is in the 1st MByte of display memory
001 = First destination memory address is in the 2nd MByte of display memory
010 = First destination memory address is in the 3rd MByte of display memory
011 = First destination memory address is in the 4th MByte of display memory
This field supersedes bits 1-0 of BEE8H, Index E if any of these 3 bits are set to 1.
Bit 3 Reserved
Bits 6-4 SRC-BASE -Source Base Address
000 = First source memory address is in the 1st MByte of display memory
001 = First source memory address is in the 2nd MByte of display memory
010 = First source memory address is in the 3rd MByte of display memory
011 = First source memory address is in the 4th MByte of display memory
This field supersedes bits 3-2 of BEE8H, Index E if any of these three bits are set to 1.
Bits 11-7 Reserved
Bits 15-12 INDEX = ODH
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-17

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Multifunction Control Miscellaneous Register (MULT _ MISC)
| Write Only  |     | Address: BEE8H, Index OEH  |     |     |     |
| ----------- | --- | -------------------------- | --- | --- | --- |
Power-On Default: EOOOH
| 15  14  13                                                    | 12  11  | 10  9          | 8  7  6      | 5  4  312    | 11  0    |
| ------------------------------------------------------------- | ------- | -------------- | ------------ | ------------ | -------- |
|                                                               |         | 1C  CMR  ENB   | SRC  EXT     | RSF  SRC-BA  | DEST-BA  |
| 1  1  1                                                       | 0  R    | EDO  32B  CMP  | NE  R  CLIP  | 21  20       | 21  20   |
| Bits 1-0  DEST-BA 21 20 -Destination Base Address Bits 21-20  |         |                |              |              |          |
00 = First destination memory address is in the 1st MByte of display memory
01 = First destination memory address is in the 2nd MByte of display memory
10 = First destination memory address is in the 3rd MByte of display memory
11 = First destination memory address is in the 4th MByte of display memory
This field is superseded by bits 2-0 of BEE8H, Index D if any of the BEE8H Index D bits
is set to 1.
| Bits 3-2  SRC-BA 2120 -Source Base Address Bits 21-20  |     |     |     |     |     |
| ------------------------------------------------------ | --- | --- | --- | --- | --- |
00 = First source memory address is in the 1st MByte of display memory
01 = First source memory address is in the 2nd MByte of display memory
10 = First source memory address is in the 3rd MByte of display memory
11 = First source memory address is in the 4th MByte of display memory
This field is superseded by bits 6-4 of BEE8H Index D if any of the BEE8H Index D bits
is set to 1.
| Bit 4  RSF -Select Upper Word in 32 Bits/Pixel Mode  |     |     |     |     |     |
| ---------------------------------------------------- | --- | --- | --- | --- | --- |
0= Selects lower 16 bits for accesses to 32-bit registers in 32 bpp mode
1 = Selects upper 16 bits for accesses to 32-bit registers in 32 bpp mode
| Bit 5  EXT CLIP -Enable External Clipping  |     |     |     |     |     |
| ------------------------------------------ | --- | --- | --- | --- | --- |
o
= Only pixels inside the clipping rectangle are drawn
1 = Only pixels outside the clipping rectangle are drawn
| Bit 6  Reserved  |     |     |     |     |     |
| ---------------- | --- | --- | --- | --- | --- |
Bit 7  SRC NE -Don't Update Bitmap if Source Not Equal to Color Compare Color
0= Don't update current bitmap if the Color Compare (B2E8) register value is equal to
the color value of the source bitmap
1 = Don't update current bitmap if the Color Compare (B2E8) register value is not
equal to the color value of the source bitmap
This bit is only active if bit 8 of this register is set to 1.
| Bit 8  ENB CMP -Enable Color Compare  |     |     |     |     |     |
| ------------------------------------- | --- | --- | --- | --- | --- |
o = Disable color comparison
1 = Enable color comparison
20-18 ENHANCED COMMANDS REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bit 9 CMR 32B -Select 32-Bit Command Registers
0= Command registers (A2E8H, A6E8H, AAE8H, AEE8H, B2E8H) are 16-bit
1 = Command registers (A2E8H, A6E8H, AAE8H, AEE8H, B2E8H) are 32-bit. Byte and
word accesses cannot be made.
This bit applies to programmed I/O accesses only and is a don't care for MMIO ac
cesses.
Bit 10 1C EDO -Disable 1-cycle EDO Operation
0= Allow 1-cycle EDO operation
1 = Disable 1-cycle EDO operation
Bit 11 Reserved = 0
Bits 15-12 INDEX = OEH
Read Register Select Register (READ_SELl
Write Only Address: BEE8H, Index OFH
Power-On Default: Undefined
Bits 3-0 READ-REG-SEL -Read Register Select
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
1001 = 46E8H
1010 = BEE8H, Index ODH
The read register index increments by one with each reading of BEE8H.
Bits 11-4 Reserved
Bits 15-12 INDEX = OFH
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-19

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Pixel Data Transfer Register (PIX_TRANS)
Write Only Address: E2E8H
Power-On Default: Undefined
All data from the CPU to the Graphics Engine must pass through this register.
Bits 15-0 IMAGE WRITE DATA
Pixel Data Transfer -Extension Register (PIX_ TRANS_EXT)
Write Only Address: E2EAH
Power-On Default: Undefined
This register is an extension of E2E8H for 32-bit operations.
Bits 15-0 IMAGE WRITE DATA
20-20 ENHANCED COMMANDS REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Section 21: Streams Processor Register Descriptions
Streams Processor registers can only be accessed via memory-mapped I/O. The register identifier
MMxxxx means that the register is memory mapped at offset xxxx from the base address.
Primary Stream Control (MM8180)
| Read/Write  | Address: 8180H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
| 15  14  13  | 12  11  10  | 9  8  | 7  6  5  | 4  3  2  | 1  0  |
| ----------- | ----------- | ----- | -------- | -------- | ----- |
| R  R  R     | R  R  R     | R  R  | R  R  R  | R  R  R  | R  R  |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| R  PSFC                                              | R   | PSIDF  | R  R  R  | R  R  R  | R  R  |
| ---------------------------------------------------- | --- | ------ | -------- | -------- | ----- |
| Bits 23-0  Reserved                                  |     |        |          |          |       |
| Bits 26-24  PSIDF -Primary Stream Input Data Format  |     |        |          |          |       |
000 = RGB-8 (CLUT)
001 = Reserved
010 = Reserved
011 = KRGB-16 (1.5.5.5)
100 = Reserved
101 = RGB-16 (5.6.5)
110 = Reserved
000 = XRGB-32 (X.8.8.8)
| Bit 27  Reserved                                         |     |     |     |     |     |
| -------------------------------------------------------- | --- | --- | --- | --- | --- |
| Bits 30-28  PSFC -Primary Stream Filter Characteristics  |     |     |     |     |     |
000 = Primary stream
001 = Primary stream for 2X stretch (replication)
010 = Primary stream, bi-linear for 2X stretch (interpolation)
Other values reserved
| Bit 31  Reserved  |     |     |     |     |     |
| ----------------- | --- | --- | --- | --- | --- |
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Color/Chroma Key Control (MM8184)
| Read/Write  | Adds: 8184H  |     |     |     |     |
| ----------- | ------------ | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
| I  I        | I  I  I           | I  I         | I  I  I          | I        | I     |
| ----------- | ----------------- | ------------ | ---------------- | -------- | ----- |
| 15  14  13  | 12  11            | 10  9  8  7  | 6  5  4          | 3  121   | 1  0  |
|             | G/U/Cb KEY (LOW)  |              | BN/Cr KEY (LOW)  |          |       |
| I  I        | I  1              | J  I         | I  I  I          | J  I  I  | I     |
31  30  29  28  271  26  25  24  23  22  21  20  19  18  17  16
| I  I                                                  | I  I  I  |         |                |     |     |
| ----------------------------------------------------- | -------- | ------- | -------------- | --- | --- |
| R  R  R                                               | KC  R    | RGB CC  | R/Y KEY (LOW)  |     |     |
| Bits 7-0  BN/Cr key value (lower bound for chroma)    |          |         |                |     |     |
| Bits 15-8  G/U/Cb key value (lower bound for chroma)  |          |         |                |     |     |
| Bits 23-16  R/Y key value (lower bound for chroma)    |          |         |                |     |     |
| Bits 26-24  RGB CC -RGB Color Comparison Precision    |          |         |                |     |     |
000 = Compare bit 7 of RGB (compare red bit 7's, green bit 7's and blue bit 7's)
001 = Compare bits 7-6 of RGB
010 = Compare bits 7-5 of RGB
011 = Compare bits 7-4 of RGB
100 = Compare bits 7-3 of RGB
101 = Compare bits 7-2 of RGB
110 = Compare bits 7-1 of RGB
111 = Compare bits 7-0 of RGB
| Bit 27  Reserved          |     |     |     |     |     |
| ------------------------- | --- | --- | --- | --- | --- |
| Bit 28  KC -Key Controll  |     |     |     |     |     |
0= Extract key data from input stream key bit (if present). (KRGB-16, 1.5.5.5 only)
If the K bit is 0, the pixel from the other stream is used (transparent). If the K bit is
1, the key bit streams pixel is used (opaque)
1 = Enable color or chroma keying for all modes other than KRGB-16
| Bits 31-29  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
21-2  STREAMS PROCESSOR REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Secondary Stream Control (MM8190)
| Read/Write  |     | Address: S190H  |     |     |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
|             |     | I       | I  I  | I                           | I  I  | I     | I  I  | I     | I   |
| ----------- | --- | ------- | ----- | --------------------------- | ----- | ----- | ----- | ----- | --- |
| 15  14  13  | 12  | 11  10  | 9     | 8  7                        | 6     | 5  4  | 3     | 2  1  | 0   |
| R  R  R     | R   |         |       | DDA HORIZONTAL ACCUMULATOR  |       |       |       |       |     |
|             |     | I       | I  I  | I                           | I  I  | I     | I  I  | I     | I   |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
|                                                      |     | I   |       | I   | I  I  | I     | I  I  | I     | I   |
| ---------------------------------------------------- | --- | --- | ----- | --- | ----- | ----- | ----- | ----- | --- |
| R  SFC                                               |     |     | SDIF  | R   | R     | R  R  | R     | R  R  | R   |
| Bits 11-0  DDA Horizontal Accumulator Initial Value  |     |     |       |     |       |       |       |       |     |
Value = 2 (WO-1) -(W1-1), where WO is the line width in pixels before scaling and W1
is the line width in pixels after scaling. This is a signed value.
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 23-12  Reserved                                  |     |     |     |     |     |     |     |     |     |
| ----------------------------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Bits 26-24  SDIF -Secondary Stream Input Data Format  |     |     |     |     |     |     |     |     |     |
000 = Reserved
001 = YCbCr-16 (4.2.2). 16-240 input range
010 = YUV-16 (4.2.2), 0-255 input range
011 = KRGB-16 (1.5.5.5)
100 = YUV (2.1.1)
101 = RGB-16 (5.6.5)
110 = Reserved
111 = XRGB-32 (X.S.S.S
When this field is programmed, the value does not take effect until the next VSYNC.
| Bit 27  Reserved                                          |     |     |     |     |     |     |     |     |     |
| --------------------------------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Bits 30-28  SFC -Secondary Stream Filter Characteristics  |     |     |     |     |     |     |     |     |     |
000 = Secondary stream
001 = Secondary stream, linear, 0-2-4-2-0, for X stretch
010 = Secondary stream, bi-linear, for 2X to 4X stretch
011 = Secondary stream, linear, 1-2-2-2-1, for 4X stretch
Other values reserved
When this field is programmed, the value does not take effect until the next VSYNC.
| Bit 31  Reserved  |     |     |     |     |     |     |     |     |     |
| ----------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-3

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Chroma Key Upper Bound (MM8194)
| Read/Write  | Address: 8194H  |     |     |     |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
| I  I        | I  I  I           | I  I   |       |       | I                 | I  I  | I     | I  0  |
| ----------- | ----------------- | ------ | ----- | ----- | ----------------- | ----- | ----- | ----- |
| 15  14  13  | 12  11            | 10  9  | 8  7  | 161   | 5                 | 4  3  | 2  1  |       |
|             | U/Cb KEY (UPPER)  |        |       |       | V/Cr KEY (UPPER)  |       |       |       |
| I  I        | I  I  I           | I  I   |       | I  I  | I                 | I  I  | I     | I     |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| I  I                                     | I  I  I  | I  I  |     |     | Y KEY (UPPER)  |     |     |     |
| ---------------------------------------- | -------- | ----- | --- | --- | -------------- | --- | --- | --- |
| R  R  R                                  | R  R     | R  R  | R   |     |                |     |     |     |
| Bits 7-0  V/Cr key value (upper bound)   |          |       |     |     |                |     |     |     |
| Bits 15-8  U/Cb key value (upper bound)  |          |       |     |     |                |     |     |     |
| Bits 23-16  Y key value (upper bound)    |          |       |     |     |                |     |     |     |
| Bits 31-24  Reserved                     |          |       |     |     |                |     |     |     |
Secondary Stream Stretch/Filter Constants (MM8198)
| Read/Write  | Address: 8198H  |     |     |     |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
|             |         | I  I   | I                           | I  I  | I   | I  I  | I     | I   |
| ----------- | ------- | ------ | --------------------------- | ----- | --- | ----- | ----- | --- |
| 15  14  13  | 12  11  | 10  9  | 8  7                        | 6     | 5   | 4  3  | 2  1  | 0   |
| R  R        |         |        | K2 HORIZONTAL SCALE FACTOR  |       |     |       |       |     |
| R           | R  R    |        |                             |       |     |       |       |     |
|             |         | I  I   | I                           | I  I  | I   | I  I  | I     | I   |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| R  R  R                                | R  R  |     | K1 HORIZONTAL SCALE FACTOR  |     |     |     |     |     |
| -------------------------------------- | ----- | --- | --------------------------- | --- | --- | --- | --- | --- |
| Bits 10-0  K1 Horizontal Scale Factor  |       |     |                             |     |     |     |     |     |
Value = WO-1, where WO is the width in pixels of the initial output window (before
scaling)
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 15-11  Reserved                    |     |     |     |     |     |     |     |     |
| --------------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- |
| Bits 26-16  K2 Horizontal Scale Factor  |     |     |     |     |     |     |     |     |
Value = WO-W1, where WO is the initial (unsealed) window width in pixels and W1 is
the final output window width in pixels. This is a signed value and will always be
negative.
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 31-27  Reserved  |     |     |     |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- | --- | --- | --- |
21-4 STREAMS PROCESSOR REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Blend Control (MM81AOI
| Read/Write  | Address: 81AOH  |     |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
|             | I  I        |       |       |       | I  I  |       |
| ----------- | ----------- | ----- | ----- | ----- | ----- | ----- |
| 15  14  13  | 12  11  10  | 9  8  | 7  6  | 5  4  | 3  2  | 1  0  |
| R  R  R     | KP          | R  R  | R  R  | R     | KS    | R  R  |
|             | I  I        |       |       |       | I  I  |       |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
|                     | I  I             |     |       |       | I  I  |       |
| ------------------- | ---------------- | --- | ----- | ----- | ----- | ----- |
| R  R  R             | R  R  COMP MODE  |     | R  R  | R  R  | R  R  | R  R  |
| Bits 1-0  Reserved  |                  |     |       |       |       |       |
| Bits 4-2  Ks        |                  |     |       |       |       |       |
Value = secondary stream blend coefficient
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 9-5  Reserved  |     |     |     |     |     |     |
| ------------------- | --- | --- | --- | --- | --- | --- |
| Bits 12-10  Kp      |     |     |     |     |     |     |
Value = primary stream blend coefficient
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 23-13  Reserved      |     |     |     |     |     |     |
| ------------------------- | --- | --- | --- | --- | --- | --- |
| Bits 26-24  Compose Mode  |     |     |     |     |     |     |
000 = Secondary stream opaque overlay on primary stream
001 = Primary stream opaque overlay on secondary stream
010 = Dissolve, [Pp x Kp + Ps x (8 -Kpl]/8, ignore Ks
011 = Fade, [Pp x Kp + Ps x Ks]/8, where Kp + Ks must be ::; 8
100 = Reserved
101 = Color key on primary stream (secondary stream overlay on primary stream)
110 = Color or chroma key on secondary stream (primary stream overlay on
secondary stream)
111 = Reserved
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 31-27  Reserved  |     |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- | --- |
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-5

,I.
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Primary Stream Frame Buffer Address 0 (MM81CO)
Read/Write Address: 81COH
Power-on Default: Undefined
If a primary stream is enabled, this register specifies the starting address in the frame buffer.
15 I 14 I 13 I 12 I 11 I 10 I 9 I 8 I 7 I 6 I 5 I 4 I 3 I 2 I 1 I 0
PRIMARY BUFFER ADDRESS 0
31 I 30 I 29 I 28 I 27 I 26 I 25 I 24 I 23 I 22 I 21 I 20 I 19 I 18 I 17 I 16
RIRIRIRIRIRIRIRIRIRI PRIMARY BUFFER ADDRESS 0
Bits 21-0 Value = Primary stream frame buffer starting address 0
This value must be quadword aligned.
Bits 31-22 Reserved
Primary Stream Frame Buffer Address 1 (MM81C4)
Read/Write Address: 81C4H
Power-on Default: Undefined
If the primary stream is double buffered, this register specifies the starting address in the frame buffer
for the second buffer.
15 I 14 I 13 L 12 1 11 I 10 I 9 I 8 I 7 I 6 l 5 I 4 I 3 I 2 I 1 I 0
PRIMARY BUFFER ADDRESS 1
31 I 30 I 29 I 28 I 27 I 26 I 25 I 24 I 23 I 22 I 21 I 20 I 19 I 18 I 17 I 16
RIRIRIRIRIRIRIRIRIRI PRIMARY BUFFER ADDRESS 1
Bits 21-0 Value = Primary stream frame buffer starting address 1
This value must be quadword aligned.
Bits 31-22 Reserved
21-6 STREAMS PROCESSOR REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Primary Stream Stride (MM81CB)
| Read/Write  |     | Address: 81C8H  |     |     |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-on Default: Undefined
|                                   |     |           | I  I        | I                      | I     | I  I        | I     | I  I        | I     |
| --------------------------------- | --- | --------- | ----------- | ---------------------- | ----- | ----------- | ----- | ----------- | ----- |
| 15  14  13                        | 12  | 11  I 10  | 9           | 8                      | 7  6  | 5           | 4  3  | 2           | 1  0  |
| R  R  R                           | R   |           |             | PRIMARY STREAM STRIDE  |       |             |       |             |       |
|                                   |     | I 26      | I 25  I 24  | I 23                   | I 22  | I 21  I 20  | I 19  | I 18  I 17  | I     |
| 31  30  29                        | 28  | 27        |             |                        |       |             |       |             | 16    |
|                                   |     | I         | I  I        | I                      | I     | I  I        | I     | I  I        | I     |
| R  R  R                           | R   | R  R      | R           | R                      | R  R  | R           | R  R  | R           | R  R  |
| Bits 11-0  Primary stream stride  |     |           |             |                        |       |             |       |             |       |
Value = byte offset of vertically adjacent pixels in the primary stream buffer(s)
If double buffering is used, the stride must be the same for both buffers.
| Bits 31-12  Reserved  |     |     |     |     |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Double Buffer/LPB Support (MM81CC)
| Read/Write  |     | Address: 81CCH  |     |     |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-on Default: xxxxxxOOH
| 15  14  13  | 12  |         |     |     |         |      | 4  3    | I    |       |
| ----------- | --- | ------- | --- | --- | ------- | ---- | ------- | ---- | ----- |
|             |     | 11  10  | 9   | 8   | 7  6    | 5    |         | 2    | 1  0  |
| R  R  R     | R   | R  R    | R   | R   | R  LST  | LSL  | LIS  R  | SBS  | PBS   |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  I  17  16
I
| R  R  R                                   | R   | R  R  | R   | R   | R  R  | R   | R  R  | R   | R  R  |
| ----------------------------------------- | --- | ----- | --- | --- | ----- | --- | ----- | --- | ----- |
| Bit 0  PBS -Primary Stream Buffer Select  |     |       |     |     |       |     |       |     |       |
0= Primary frame buffer starting address 0 (MM81CO_21-0) used for the primary
stream
1 = Primary frame buffer starting address 1 (MM81C4_21-0) used for the primary
stream
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-7

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Bits 2-1 SBS -Secondary Stream Buffer Select
00 = Secondary frame buffer starting address 0 (MM81 DO_21-0) used for the
secondary stream
01 = Secondary frame buffer starting address 1 (MM81 D4_21-0) used for the
secondary stream
10 = Secondary frame buffer starting address 0 (MM81 DO_21-0) used for the
secondary stream and LPB frame buffer starting address 0 (MMFFOC_21-0) used
for the LPB input stream OR secondary frame buffer starting address 1
(MM81 D4_21-0) used for the secondary stream and LPB frame buffer starting
address 1 (MMFF10_21-0) used for the LPB input stream. Which alternative
applies is determined by LPB starting address register selected by bit 4 of this
register
11 = Secondary frame buffer starting address 0 (MM81 DO_21-0) used for the
secondary stream and LPB frame buffer starting address 1 (MMFF10_21-0) used
for the LPB input stream OR secondary frame buffer starting address 1
(MM81 D4_21-0) used for the secondary stream and LPB frame buffer starting
address 0 (MMFFOC_21-0) used for the LPB input stream. Which alternative
applies is determined by the LPB starting address register selected by bit 4 of this
register
Bit 3 Reserved
Bit 4 LIS -LPB Input Buffer Select
0= LPB frame buffer starting address 0 (MMFFOC_21-0) used for the LPB input
1 = LPB frame buffer starting address 1 (MMFF10_21-0) used for the LPB input
This bit selects the starting address for writing LPB data into the frame buffer. When
the value programmed to this bit takes effect is determined by the setting of bit 5 of
this register. This bit can be toggled at the completion of writing all the data for a
frame to the frame buffer via bit 6 of this register
Bit 5 LSL -LPB Input Buffer Select Loading
0= The value programmed into bit 4 of this register takes effect immediately
1 = The value programmed into bit 4 of this register takes effect at the next end of
frame (completion of writing all the data for a frame into the frame buffer)
Bit 6 LST -LPB Input Buffer Select Toggle
o = End of frame (completion of writing all the data for a frame into the frame buffer)
has no effect on the setting of bit 4 of this register
1 = End offrame causes the setting of bit 4 of this register to toggle
Bits 31-7 Reserved
21-8 STREAMS PROCESSOR REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Secondary Stream Frame Buffer Address 0 (MM81 DO)
| Read/Write  | Address: 81DOH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
If a secondary stream is enabled, this register specifies the starting address in the frame buffer
| I  I        | I  I  I     | I  I  I  | I  I  I  | I  I  I  | I   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
SECONDARY BUFFER ADDRESS 0
| I  I  | I  I  I  | I  I  I  | I  I  I  | I  I  I  | I   |
| ----- | -------- | -------- | -------- | -------- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| I  I     | I  I  I  | I  I  I  | I  I                           |     |     |
| -------- | -------- | -------- | ------------------------------ | --- | --- |
| R  R  R  | R  R  R  | R  R  R  | R  SECONDARY BUFFER ADDRESS 0  |     |     |
Bits 21-0  Value = Secondary stream frame buffer starting address 0
This value must be quadword aligned.
| Bits 31-22  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
Secondary Stream Frame Buffer Address 1 (MM81 04)
| Read/Write  | Address: 81 D4H  |     |     |     |     |
| ----------- | ---------------- | --- | --- | --- | --- |
Power-on Default: Undefined
If the secondary stream is double buffered, this register specifies the starting address in the frame
buffer for the second buffer.
| I  I        | I  1  1     | l  I  l  | I  I  I  | I  I  I  | I   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
SECONDARY BUFFER ADDRESS 1
| I  I  | I  I  I  | I  I  I  | I  I  I  | I  I  I  | I   |
| ----- | -------- | -------- | -------- | -------- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| I  I     | I  I  I  | I  I  I  | I  I                           |     |     |
| -------- | -------- | -------- | ------------------------------ | --- | --- |
| R  R  R  | R  R  R  | R  R  R  | R  SECONDARY BUFFER ADDRESS 1  |     |     |
Bits 21-0  Value = Secondary stream frame buffer starting address 1
This value must be quadword aligned.
| Bits 31-22  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-9

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Secondary Stream Stride (MM81D8)
| Read/Write  |     | Address: 81D8H  |     |     |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-on Default: Undefined
|         |     | L           | I   | I                        | I  I  | L     | 1  I  | I     | I   |
| ------- | --- | ----------- | --- | ------------------------ | ----- | ----- | ----- | ----- | --- |
| 15  14  | 13  | 12  11  10  | 9   | -'  8  7                 | 6     | 5  4  | 3     | 2  1  | 0   |
| R  R    | R   | R           |     | SECONDARY STREAM STRIDE  |       |       |       |       |     |
31  30  29  28  27  I  26  I  25  I  24  I  23  I  22  I  21  I  20  I  19  I  18  I  17  I  16
|            |                          | I        | I   | I  I   | I     |          | 1    |         | I   |
| ---------- | ------------------------ | -------- | --- | ------ | ----- | -------- | ---- | ------- | --- |
| R  R       | R                        | R  R  R  | R   | ·R  R  | R  1  | R  1  R  | R I  | R.I  R  | R   |
| Bits 11-0  | Secondary stream stride  |          |     |        |       |          |      |         |     |
Value = byte offset of vertically adjacent pixels in the secondary stream buffer(s)
If double buffering is used, the stride must be the same for both buffers.
| Bits 31-12  | Reserved  |     |     |     |     |     |     |     |     |
| ----------- | --------- | --- | --- | --- | --- | --- | --- | --- | --- |
Opaque Overlay Control (MM81 DC)
| Read/Write  |     | Address: 81DCH  |     |     |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-on Default: Undefined except bits 31-30 are OOb.
When an opaque overlay mode is being used (bits 26-24 of MM81AO = OOOb or 001b), the fields in this
register can be programmed to eliminate the fetching of the pixels for the rectangular area under the
top (opaque) window. This reduces the memory bandwidth requirements. The bottom window should
be full-screen when this feature is enabled. None of the fields in this register have an effect unless bit
31 is set to 1. Note that only horizontal coordinates must be specified. The vertical coordinates are
handled automatically by the hardware.
15  14  13  12  I  11  I  10  I  9  I  8  I  7  I  6  I  5  I  4  I  3  2  1  0
| R  R  | R   |       | PIXEL STOP FETCH  |       |       |     |     | R  R  | R   |
| ----- | --- | ----- | ----------------- | ----- | ----- | --- | --- | ----- | --- |
|       |     | I  I  | I                 | I  I  | I  I  | I   |     |       |     |
31  30  29  28  27  26  25  24  23  22  21  20 -'  19  18  17  16
| OOC  TSS  | R         |     | PIXEL RESUME FETCH  |     |     |     |     | R  R  | R   |
| --------- | --------- | --- | ------------------- | --- | --- | --- | --- | ----- | --- |
| Bits 2-0  | Reserved  |     |                     |     |     |     |     |       |     |
21-10 STREAMS PROCESSOR REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bits 12-3 Pixel Stop Fetch
Value = [Offset in quadwords from the background starting pixel horizontal position
to the first pixel of the line not to be fetched from memory (hidden background)) + 1
quadword
If the primary stream is the background, MM81 FO_26-16 define the starting position
for each line in the background window (XO) and MM81F8_26-16 define the first pixel
position for each line in the top window (X1). The latter is the first background pixel
that does not need to be fetched. The value programmed in this field is then [(X1 -
XO) x bytes per pixel/8) +1. Ifthe result is a fraction, it is rounded up the next highest
integer. This gives the required quadword offset (0) for this field. This value is also
used in the calculation for the field value of bits 28-19 of this register.
If the secondary stream is the background, the value is [(XO -X1) x bytes per pixel/8)
+ 1.
Bits 18·13 Reserved
Bits 28-19 Pixel Resume Fetch
Value = {Offset in quadwords from the background starting pixel horizontal position
to the line position of the resumption of pixel fetching from memory (Le., visible back
ground)} -1 quadword
The value is determined by adding the Pixel Stop Fetch field value (0) above (bits 12-
3) to the width in quadwords of the top window (W). The width of the top window in
pixels (P) is found in MM81 F4_26-16 if the primary stream is on top and in
MM81 FC_26-16 if the secondary stream is on top. W in quadwords = P x bytes per
pixel/8. If this is a fraction, the result is truncated to the next lowest integer. The value
in this field is then [W + 0)-1.
Bit 29 Reserved
Bit 30 TSS -Top Stream Select
o = Secondary stream on top
1 = Primary stream on top
Bit 31 OOC -Opaque Overlay Control Enable
o
= Opaque overlay control disabled
1 = Opaque overlay control enabled
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-11

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
K1 Vertical Scale Factor (MM81 EO)
| ReadIWrite  | Address: 81EOH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
|             |         | I  I   | I  I  I  I                | I  I  I  | I     |
| ----------- | ------- | ------ | ------------------------- | -------- | ----- |
| 15  14  13  | 12  11  | 10  9  | 8  7  6  5                | 4  3  2  | 1  0  |
| R  R  R     | R  R    |        | K1 VERTICAL SCALE FACTOR  |          |       |
|             |         | I  I   | I  I  I  I                | I  I  I  | I     |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
|                                      |       | I  I  | I  I  I  I  | I  I  I  | I     |
| ------------------------------------ | ----- | ----- | ----------- | -------- | ----- |
| R  R  R                              | R  R  | R  R  | R  R  R  R  | R  R  R  | R  R  |
| Bits 10-0  K1 Vertical Scale Factor  |       |       |             |          |       |
Value = [height (in lines) of the initial output window (before scaling))- 1
When this field is progiammed, the value does not take effect until the next VSYNC.
| Bits 31-11  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
K2 Vertical Scale Factor (MM81E4)
| ReadIWrite  | Address: 81E4H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
1  I
15  14  13  12  11  10  9  8  j  7  I  6  I  5  I  4  I  3  I  2  I  1  I  0
K2 VERTICAL SCALE FACTOR
| R  R  R  | R  R  |       |             |          |     |
| -------- | ----- | ----- | ----------- | -------- | --- |
|          |       | I  I  | I  I  I  I  | I  I  I  | I   |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
|     |     |     | I   | I   | l   |
| --- | --- | --- | --- | --- | --- |
R  R  R  R  R  R  I  R  I  R  I  R  I  R  I  R  R  RJ  RJ  R  R
| Bits 10-0  K2 Vertical Scale Factor  |     |     |     |     |     |
| ------------------------------------ | --- | --- | --- | --- | --- |
Value = 2's complement of [height (in lines) of the initial output window (before scal
ing))-[height (in lines) of the final output window (after scaling))
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 31-11  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
21-12 STREAMS PROCESSOR REGISTER DESCRIPTIONS

II·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
DDA Vertical Accumulator Initial Value (MM81E8)
| Read/Write  |     |     | Address: 81E8H  |     |     |     |     |     |     |     |
| ----------- | --- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
|     |         |     | I       | I  I  | I                         | I  I  | I     | I  I  | I     | I   |
| --- | ------- | --- | ------- | ----- | ------------------------- | ----- | ----- | ----- | ----- | --- |
| 15  | 14  13  | 12  | 11  10  | 9     | 8  7                      | 6     | 5  4  | 3     | 2  1  | 0   |
| R   | R  R    | R   |         |       | DDA VERTICAL ACCUMULATOR  |       |       |       |       |     |
|     |         |     | I       | I  I  | I                         | I  I  | I     | I  I  | I     | I   |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
|            |                                         |     | I     | I  I  | I     | I  I  | I     | I  I  | I     | I   |
| ---------- | --------------------------------------- | --- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | --- |
| R          | R  R                                    | R   | R  R  | R     | R  R  | R     | R  R  | R     | R  R  | R   |
| Bits 11-0  | DDA Vertical Accumulator Initial Value  |     |       |       |       |       |       |       |       |     |
Value = 2's complement of [height (in lines) of the output window after scaling] -1
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 31-12  | Reserved  |     |     |     |     |     |     |     |     |     |
| ----------- | --------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Streams FIFO and RAS Controls (MM81EC)
| Read/Write  |     |     | Address: 81ECH  |     |     |     |     |     |     |     |
| ----------- | --- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-on Default: 00003000H
|     | I                | I  I  | I       | I                | I     | I  I  |       | I                |     | I   |
| --- | ---------------- | ----- | ------- | ---------------- | ----- | ----- | ----- | ---------------- | --- | --- |
| 15  | 14  13           | 12    | 11  10  | 9                | 8  7  | 6     | 5  4  | 3  121           | 1   | 0   |
| RL  | PFIFO THRESHOLD  |       |         | SFIFO THRESHOLD  |       |       |       | FIFO ALLOCATION  |     |     |
31  30  I  29  I  28  I  27  I  26  25  I  24  I  23  I  22  I  21  20  I  19  I  18  I  17  I  16
|           | I                        | I  I  | I     | I   | I     | I  I  |       | I  I  | I       | I   |
| --------- | ------------------------ | ----- | ----- | --- | ----- | ----- | ----- | ----- | ------- | --- |
| R         | R  R                     | R     | R  R  | R   | R  R  | R     | R  R  | R     | EWS  R  | RP  |
| Bits 4-0  | Streams FIFO Allocation  |       |       |     |       |       |       |       |         |     |
00000 = Primary Stream = 24 slots, Secondary Stream = 0 slots
01000 = Primary Stream = 16 slots, Secondary Stream = 8 slots
01100 = Primary Stream = 12 slots, Secondary Stream =12 slots
10000 = Primary Stream = 8 slots, Secondary Stream = 16 slots
11000 = Primary Stream = 0 slots, Secondary Stream = 24 slots
All other values are reserved and must not be programmed. Each slot holds one
quadword.
| Bits 9-5  | Secondary FIFO Threshold  |     |     |     |     |     |     |     |     |     |
| --------- | ------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Value = Number of secondary FIFO slots
When the secondary FIFO empties down to this value, an internal signal is generated
requesting re-filling of the secondary FIFO. This value must be less than or equal to
|     | the secondary stream FIFO size specified in bits 4-0.  |     |     |     |     |     |     |     |     | .   |
| --- | ------------------------------------------------------ | --- | --- | --- | --- | --- | --- | --- | --- | --- |
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-13

| , .   |     |     |     |     |     |
| ----- | --- | --- | --- | --- | --- |
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bits 14-10  Primary FIFO Threshold  |     |     |     |     |     |
| ----------------------------------- | --- | --- | --- | --- | --- |
Value = Number of primary FIFO slots
When the primary FIFO empties down to this value, an internal signal is generated re
questing re-filling of the primary FIFO. This value must be less than or equal to the
primary stream FIFO size specified in bits 4-0.
| Bit 15  RL -RAS Low Time Control  |     |     |     |     |     |
| --------------------------------- | --- | --- | --- | --- | --- |
o = RAS low time specified by CR68_2 (3.5 or 4.5 MCLKs)
1 = RAS low time = 2.5 MCLKs
| Bit 16  RP -RAS Pre-Charge Control  |     |     |     |     |     |
| ----------------------------------- | --- | --- | --- | --- | --- |
o  = RAS pre-charge specified by CR68_3 (2.5 or 3.5 MCLKs)
1 = RAS pre-charge = 1.5 MCLKs
| Bit 17  Reserved  |     |     |     |     |     |
| ----------------- | --- | --- | --- | --- | --- |
Bit 18  EWS -EDO Memory Wait State Control (LPB Memory Cycles Only)
o
= Standard 2-cycle memory operation
1 = 1-cycle EDO memory operation (requires EDO memory capable of this)
This bit is only valid for 64-bit PD bus operation (2 or 4 MBytes of memory). It should
not be set for 32-bit (1 MByte) configurations.
| Bits 31-19  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
Primary Stream Window Start Coordinates (MM81FO)
| Read/Write  | Address: 81FOH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
|             |         | I  I      | I  I  I  I              | I  I  I  | I     |
| ----------- | ------- | --------- | ----------------------- | -------- | ----- |
| 15  14  13  | 12  11  | 10  9  8  | 7  6  5                 | 4  3  2  | 1  0  |
| R  R  R     | R  R    |           | PRIMARY STREAM Y-START  |          |       |
31  30  29  28  27  26  I  25  1  24  I  23  I  22  I  21  I  20  I  19  I  18  I  17  I  16
| R  R  R                            | R  R  |     | PRIMARY STREAM X-START  |     |     |
| ---------------------------------- | ----- | --- | ----------------------- | --- | --- |
| Bits 10-0  Primary Stream Y-Start  |       |     |                         |     |     |
Value = Screen line number +1 of the first line of the primary stream window
| Bits 15-11  Reserved                |     |     |     |     |     |
| ----------------------------------- | --- | --- | --- | --- | --- |
| Bits 26-16  Primary Stream X-Start  |     |     |     |     |     |
Value = Screen pixel number + 1 of the first pixel of the primary stream window
| Bits 31-27  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
21-14 STREAMS PROCESSOR REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Primary Stream Window Size (MM81 F4)
| Read/Write  | Address: 81F4H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
|             |         | I  I      | I  I  I  I             | I  I  I  | I     |
| ----------- | ------- | --------- | ---------------------- | -------- | ----- |
| 15  14  13  | 12  11  | 10  9  8  | 7  6  5                | 4  3  2  | 1  0  |
| R  R  R     | R  R    |           | PRIMARY STREAM HEIGHT  |          |       |
I
31  30  29  28  27  26  I  25  I  24  I  23  I  22  I  21  I  20  I  19  I  18  I  17  16
| R  R  R                           | R  R  |     | PRIMARY STREAM WIDTH  |     |     |
| --------------------------------- | ----- | --- | --------------------- | --- | --- |
| Bits 10-0  Primary Stream Height  |       |     |                       |     |     |
Value = Number of lines displayed in the primary stream window
| Bits 15-11  Reserved              |     |     |     |     |     |
| --------------------------------- | --- | --- | --- | --- | --- |
| Bits 26-16  Primary Stream Width  |     |     |     |     |     |
Value = Number of pixels -1 displayed in each line in the primary stream window
| Bits 31-27  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
Secondary Window Start Coordinates (MM81F8)
| Read/Write  | Address: 81 F8H  |     |     |     |     |
| ----------- | ---------------- | --- | --- | --- | --- |
Power-on Default: Undefined
15  14  13  12  11  I  9  I  8  I  7  I  6  I  5  I  4  I  3  I  2  I  1  I  0
10
| R  R  R  | R  R  |     | SECONDARY STREAM Y-START  |     |     |
| -------- | ----- | --- | ------------------------- | --- | --- |
I  I
31  30  29  28  27  26  I  25  I  24  I  23  I  22  I  21  I  20  I  19  I  18  17  16
| R  R  R                              | R  R  |     | SECONDARY STREAM X-START  |     |     |
| ------------------------------------ | ----- | --- | ------------------------- | --- | --- |
| Bits 10-0  Secondary Stream V-Start  |       |     |                           |     |     |
Value = Screen line number + 1 of the first line of the secondary stream window
| Bits 15-11  Reserved                  |     |     |     |     |     |
| ------------------------------------- | --- | --- | --- | --- | --- |
| Bits 26-16  Secondary Stream X-Start  |     |     |     |     |     |
Value = Screen pixel number +1 ofthe first pixel of the secondary stream window
| Bits 31-27  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-15

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Secondary Window Size (MM81FC)
| Read/Write  | Address: 81FCH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
|             |         | I  I   | I  I  I  I               | I  I  I  | I     |
| ----------- | ------- | ------ | ------------------------ | -------- | ----- |
| 15  14  13  | 12  11  | 10  9  | 8  7  6  5               | 4  3  2  | 1  0  |
| R  R  R     | R  R    |        | SECONDARY STREAM HEIGHT  |          |       |
|             |         | I  I   | I  I  I  I               | I  I  I  | I     |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| R  R  R                             | R  R  |     | SECONDARY STREAM WIDTH  |     |     |
| ----------------------------------- | ----- | --- | ----------------------- | --- | --- |
| Bits 10-0  Secondary Stream Height  |       |     |                         |     |     |
Value = Number of lines displayed in the secondary stream window
| Bits 15-11  Reserved                |     |     |     |     |     |
| ----------------------------------- | --- | --- | --- | --- | --- |
| Bits 26-16  Secondary Stream Width  |     |     |     |     |     |
Value = Number of pixels -1 displayed in each line in the primary stream window
| Bits 31-27  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
21-16 STREAMS PROCESSOR REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 22: LPB Register Descriptions
LPB registers can only be accessed via memory-mapped I/O. The register identifier MMxxxx means
that the register is memory mapped at offset xxxx from the base address.
LPB Mode (MMFFOO)
| ReadlWrite  |     | Address: FFOOH  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-on Default: OOOOOOOOH
|         |             |           |          | I        | I     |
| ------- | ----------- | --------- | -------- | -------- | ----- |
| 15  14  | 13  12  11  | 10  9  8  | 7  6  5  | 4  3  2  | 1  0  |
R  R  LBA  CHS  CVS  LHS  LVS  R  R  CBS  SF  LR  LPB MODE  LE
|     |     |     |     | J   | I   |
| --- | --- | --- | --- | --- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
|         |                 |               |         | I        | I    |
| ------- | --------------- | ------------- | ------- | -------- | ---- |
| CFL  R  | R  R  R         | ILC  SNO  CS  | R  VFT  | R  R  R  | MBS  |
| Bit 0   | LE -LPB Enable  |               |         |          |      |
o
= LPB Disabled
1 = LPB Enabled
Enabling the LPB causes the LPB mode pin configurations described in Section 2 to
take effect. The exact pin configuration depends on which LPB mode is enabled via
bits 3-1 of this register or which feature connector option is selected. Once enabled,
the LPB is reset either by a system reset or via bit 4 of this register.
| Bits 3-1  | LPB MODE  |     |     |     |     |
| --------- | --------- | --- | --- | --- | --- |
000 = Scenic/MX2 Mode. Pins 203 and 204 act as VREQ/VRDY and CREO/CRDY
respectively.
001 = Video 16 Mode (PCI only). Pins 203 and 204 act as HS and VS respectively and
pins 201-199,189-185 act as LD[15:8]. The Tri064V+ expects 16-bit Philips digitizer
input.
010 = Video 8 In Mode. Pins 203 and 204 to act as HS and VS respectively and the
Tri064V+ expects video data in 8-bit units (LD[7:01l.
011 = Video 8 In/Out Mode. This setting enables the bi-directional CL-480 interface.
100 = Pass-through Mode. 32-bit data from the output FIFO is passed directly to the
decimation input to the video FIFO. This allows decimation of CPU-provided
data.
All other values are reserved.
LPB REGISTER DESCRIPTIONS 22-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bit 4 LR- LPB Reset
0= No effect
1 = Reset LPB
This bit should be set and then reset before switching between LPB modes.
Bit 5 SF -Skip Frames
o = Write all received frames to memory
1 = Write every other received frame to memory (1, 3, etc.)
Bit 6 CBS -Color Byte Swap
0= Incoming video is in U01, Yo, U01, Y1 format (e.g., CL-480), byte swap enabled
1 = Incoming video is in Yo, U01, Y1, V01 format (e.g., SAA7110), no byte swap
Bits 8-7 Reserved
Bit 9 LVS -LPB Vertical Sync Input Polarity
0= LPB vertical sync input is active low
1 = LPB vertical sync input is active high
Bit 10 LHS -LPB Horizontal Sync Input Polarity
0= LPB horizontal sync input is active low
1 = LPB horizontal sync input is active high
Bit 11 CVS -CPU VSYNC (Write Only)
Writing a 1 to this bit causes the Trio64V+ to do whatever functions it is programmed
to do upon receipt of a VSYNC. For example, values programmed in certain registers
only take effect at the next VSYNC.
Bit 12 CHS -CPU HSYNC (Write Only)
Writing a 1 to this bit causes the Trio64V+ to do whatever functions it is programmed
to do upon receipt of an HSYNC.
Bit 13 LBA -Load Base Address (Write Only)
Writing a 1 to this bit immediately loads the base address currently being pointed to.
Bits 15-14 Reserved
Bits 17-16 MBS -Maximum LPB to Scenic/MX2 Compressed Data Burst Size (Scenic/MX2 mode
only)
00 = Burst 1 32-bit word
01 = Burst 2 32-bit words
10 = Burst 3 32-bit words
11 = Burst all 32-bit words (until empty)
With a setting of 11 b, software must ensure that no more than eight 32-bit words are
burst to the Scenic/MX2 in a single burst. For example, if the FIFO is full (8 entries),
no more entries should be written until the burst is complete.
Bits 20-18 Reserved
22-2 LPB REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bits 22-21 VFT -Video FIFO Threshold
00 = 1 FIFO slot
01 = 2 FIFO slots
10 = 4 FIFO slots
11 = 6 FIFO slots
When this many slots are filled in the video FIFO, a request is generated to the mem
ory manager to begin emptying the FIFO. This is used to maximize the efficiency of
the memory interface.
Bit 23 Reserved
Bit 24 CS -LPB Clock Source
0= LPB clock driven by SCLK (pin 194)
1 = LPB clock driven by LCLK (pin 148)
This bit allows for the LPB to be used in pass-through mode (MMFFOO_3-1 = 100b)
when the Tri064V+ is configured for compatible mode. The LPB is normally driven by
LCLK, but this is not available in compatible mode.
Bit 25 SNO -Sync Non-Overlap
0= No effect
1 = Don't add stride after first HSYNC
This bit must be set when the first HSYNC does not occur within the VSYNC active pe
riod.
Bit 26 ILC -Invert LCLK
o = Use LCLK as received
1 = Invert the LCLK input
Bit 24 of this register must be set to 1 for this bit to be effective.
Bits 30-27 Reserved
Bit 31 CFL -CFLEVEL Status (Read Only)
This bit reflects the state of the CFLEVEL input (pin 182) in Video In/Out (CL-480)
mode.
LPB REGISTER DESCRIPTIONS 22-3

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
LPB FIFO Status (MMFF04)
| Read Only  | Address: FF04H  |     |     |     |     |
| ---------- | --------------- | --- | --- | --- | --- |
Power-on Default: 00000008H
| 15  14  | 13  12  11      | 10  9  8  | 7  6  5  | 4  3  2          | 1  0  |
| ------- | --------------- | --------- | -------- | ---------------- | ----- |
| R  R    | OFAE  OFE  OFF  | R  R  R   | R  R  R  | R  OFIFO STATUS  |       |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
VF1AE VF1E  VF1F  R  R  R  R  R  R  ~FOAE VFOE  VFOF  R  R  R  R
| Bits 3-0  | LPB Output FIFO Status  |     |     |     |     |
| --------- | ----------------------- | --- | --- | --- | --- |
0000 = 0 FIFO slots free
0001 = 1 FIFO slot free
0010 = 2 FIFO slots free
0011 = 3 FIFO slots free
0100 = 4 FIFO slots free
0101 = 5 FIFO slots free
0110 = 6 FIFO slots free
0111 = 7 FIFO slots free
1000 = 8 FIFO slots free
Each slot contains 4 bytes
| Bits 10-4  | Reserved                   |     |     |     |     |
| ---------- | -------------------------- | --- | --- | --- | --- |
| Bit 11     | OFF -LPB Output FIFO Full  |     |     |     |     |
o  = Output FIFO not full
1 = Output FIFO full
| Bit 12  | OFE -LPB Output FIFO Empty  |     |     |     |     |
| ------- | --------------------------- | --- | --- | --- | --- |
o
= Output FIFO not empty
1 = Output FIFO empty
| Bit 13  | OFAE -LPB Output FIFO Almost Empty  |     |     |     |     |
| ------- | ----------------------------------- | --- | --- | --- | --- |
o = Output FIFO has something other than 1 slot filled
1 = Output FIFO has one slot filled
| Bits 19-14  | Reserved                     |     |     |     |     |
| ----------- | ---------------------------- | --- | --- | --- | --- |
| Bit 20      | VFOF -LPB Video FIFO 0 Full  |     |     |     |     |
0= Video FIFO 0 not full
1 = Video FIFO 0 full
| Bit 21  | VFOE -LPB Video FIFO 0 Empty  |     |     |     |     |
| ------- | ----------------------------- | --- | --- | --- | --- |
o = Video FIFO 0 not empty
1 = Video FIFO 0 empty
| Bit 22  | VFOAE -LPB Video FIFO 0 Almost Empty  |     |     |     |     |
| ------- | ------------------------------------- | --- | --- | --- | --- |
0= Video FIFO 0 has something other than 1 slot filled
1 = Video FIFO 0 has one slot filled
22-4 LPB REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
| Bits 28-23  Reserved                 |     |     |     |     |     |
| ------------------------------------ | --- | --- | --- | --- | --- |
| Bit 29  VF1F -LPB Video FIFO 1 Full  |     |     |     |     |     |
o  = Video FIFO 1 not full
1 = Video FIFO 1 full
| Bit 30  VF1E - | LPB Video FIFO 1 Empty  |     |     |     |     |
| -------------- | ----------------------- | --- | --- | --- | --- |
o = Video FIFO 1 not empty
1 = Video FIFO 1 empty
| Bit 31  VF1AE -LPB Video FIFO 1 Almost Empty  |     |     |     |     |     |
| --------------------------------------------- | --- | --- | --- | --- | --- |
0= Video FIFO 1 has something other than 1 slot filled
1 = Video FIFO 1 has one slot filled
LPB Interrupt Flags (MMFF08)
| ReadNVrite  | Address: FF08H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
| 15  14  13                                          | 12  11  10  | 9  8  7     | 6  5  | 4  3  2           | 1  0  |
| --------------------------------------------------- | ----------- | ----------- | ----- | ----------------- | ----- |
| R  R  R                                             | R  R  R     | R  R  R     | R  R  | R  SPS  EFI  ELI  | FEI   |
|                                                     |             |             | 21    | 20  19  18  17    | 16    |
| 31  30  29                                          | 28  27  26  | 25  24  23  | 22    |                   |       |
| R  R  R                                             | R  R  R     | R  SPW  R   | R  R  | R  SPM  EFM  ELM  | FEM   |
| Bit 0  FEI -LPB Output FIFO Empty Interrupt Status  |             |             |       |                   |       |
o = No interrupt
1 = LPB output FIFO empty
Writing a 1 to this bit clears the interrupt.
| Bit 1  ELI -End of Line Interrupt Status  |     |     |     |     |     |
| ----------------------------------------- | --- | --- | --- | --- | --- |
o = No interrupt
1 = The Tri064V+ has received an HSYNC input on pin 202
Writing a 1 to this bit clears the interrupt.
| Bit 2  EFI -End of Frame Interrupt Status  |     |     |     |     |     |
| ------------------------------------------ | --- | --- | --- | --- | --- |
o = No interrupt
1 = The Tri064V+ has received a VSYNC input on pin 203
Writing a 1 to this bit clears the interrupt.
| Bit 3  SPS -Serial Port Start Detect Interrupt Status  |     |     |     |     |     |
| ------------------------------------------------------ | --- | --- | --- | --- | --- |
o -No interrupt
1 = The Tri064V+ has detected a serial port start condition
A serial port start condition occurs when SPD (pin 206) is driven low by another de
vice while SPCLK (pin 205) is not being driven low. Writing a 1 to this bit clears the in
terrupt.
LPB REGISTER DESCRIPTIONS 22-5

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bits 15-4 Reserved
Bit 16 FEM -LPB Output FIFO Empty Interrupt Enable Mask
o
= LPB output FIFO empty interrupt disabled
1 = LPB output FIFO empty interrupt enabled
Bit 17 ELM -End of Line Interrupt Enable Mask
o = End of Line interrupt disabled
1 = End of Line interrupt enabled
Bit 18 EFM -End of Frame Interrupt Enable Mask
o = End of frame interrupt disabled
1 = End of frame interrupt enabled
Bit 19 SPM -Serial Port Start Detect Interrupt Mask
o = Serial port start detect interrupt disabled
1 = Serial port start detect interrupt enabled
Bits 23-20 Reserved
Bit 24 SPW -Serial Port Wait
0= Release SPCLK (pin 205) to float high
1 = Drive SPCLK (pin 205) low upon receipt of a serial port start condition
Setting this bit to 1 enables serial port wait states until the Host is ready to process
the data.
Bit 31-25 Reserved
22-6 LPB REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
LPB Frame Buffer Address 0 (MMFFOC)
Read/Write Address: FFOCH
Power-on Default: OOOOOOOOH
I I
15 14 131 12 1 11 1 10 1 9 1 8 1 7 1 6 1 5 1 4 1 3 1 2 1 1 1 0
LPB BUFFER ADDRESS 0
J I I
31 1 30 1 29 1 28 1 27 1 26 25 24 23 1 22 1 21 1 20 1 19.1 18 1 17 1 16
RIRIRIRIRIRIRIRIRIRI LPB BUFFER ADDRESS 0
Bits 21-0 LPB Frame Buffer Address 0
Value = starting address 0 (offset in bytes from the start of the frame buffer) for writ
ing LPB data to the frame buffer
This value will normally be the same as the secondary stream frame buffer address o.
The value must start on an 8-byte boundary.
Bits 31-22 Reserved
LPB Frame Buffer Address 1 (MMFF10)
Read/Write Address: FF10H
Power-on Default: Undefined
15 1 14 1 13 1 12 1 11 1 10 1 9 1 8 1 7 1 6 1 5 1 4 1 3 1 2 1 1 1 0
LPB BUFFER ADDRESS 1
I I
31 30 29 1 28 1 27 1 26 1 25 1 24 1 23 1 22 1 21 1 20 1 19 1 18 1 17 1 16
R 1 R 1 R 1 R 1 R 1 R 1 R 1 R 1 R 1 R 1 LPB BUFFER ADDRESS 1
Bits 21-0 LPB Frame Buffer Address 1
Value = starting address 1 (offset in bytes from the start of the frame buffer) for writ
ing LPB data to the frame buffer
This value will normally be the same as the secondary stream frame buffer address 1.
Both address 0 and address 1 are defined when double buffering is used. The value
must start on an 8-byte boundary.
Bits 31-22 Reserved
LPB REGISTER DESCRIPTIONS 22-7

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
LPB Direct Read/Write Address (MMFF14)
| Read/Write  | Address: FF14H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
| I  I        | I  I  I     | I  I  I  | I  I  I  | I  I  I  | I   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
LPB DIRECT READ/WRITE ADDRESS
31  I  30  I  29  I  28  I  27  I  26  I  25  I  24  I  23  I  22  I  21  I  20  I  19  I  18  I  17  I  16
| I  I                                      | I  I  I  | I  I  I  | n  I                    |     |     |
| ----------------------------------------- | -------- | -------- | ----------------------- | --- | --- |
| R  R  R                                   | R  R  R  | R  R     | LPB READ/WRITE ADDRESS  |     |     |
| Bits 20-0  LPB Direct Read/Write Address  |          |          |                         |     |     |
Value = address of Scenic/MX2/CL-480 register to read/write
n  -Transaction Type (Scenic/MX2)
Bits 23·21
000 = Register write
001 = Register read
110 = Compressed video data write from the output FIFO. This value is automatically
generated by hardware when data is written to the output FIFO.
| Bits 31-24  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
LPB Direct Read/Write Data (MMFF18)
| Read/Write  | Address: FF18H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
| I  I        | I  I  I     | I  I  I  | I  I  I  | I  I  I  | I   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
LPB DIRECT READ/WRITE DATA
| I  I  | I  I  I  | I  I  I  | I  I  I  | I  I  I  | I   |
| ----- | -------- | -------- | -------- | -------- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
LPB DIRECT READ/WRITE DATA
| Bits 31-0  LPB Direct Read/Write Data  |     |     |     |     |     |
| -------------------------------------- | --- | --- | --- | --- | --- |
A write to this register triggers a read/write sequence based on the address informa
tion in MMFF14_23-0.
22-8  LPB REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
LPB General Purpose Input/Output Port (MMFF1C)
| Read/Write -see bit definitions  |     | Address: FF1CH  |     |     |     |     |
| -------------------------------- | --- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
This register is available only for PCI bus configurations.
|             |             |       | I  I     | I     | I  I     | I   |
| ----------- | ----------- | ----- | -------- | ----- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  | 7  6  5  | 4  3  | 2  1     | 0   |
| R  R  R     | R  R  R     | R  R  | LPB GIP  |       | LPB GOP  |     |
31  30  29  28  27  26  25  24  I 22  I 21  I  20  I  I  I  16
|          |          |       | 23              | 19    | 18  17  |     |
| -------- | -------- | ----- | --------------- | ----- | ------- | --- |
|          |          |       |                 |       | I  I    | J   |
| R  R  R  | R  R  R  | R  R  | R  I  R  I  RI  | R  R  | R  R    | R   |
LPB General Purpose Output Data Port
Bits 3-0
These bits are driven onto the LPB LD[3:0] lines whenever a write is performed to
CR5C. STWR is asserted (low) at this time for use as an enable strobe for latching the
data into an external buffer.
| Bits 7-4  LPB General Purpose Input Data Port (Read only)  |     |     |     |     |     |     |
| ---------------------------------------------------------- | --- | --- | --- | --- | --- | --- |
Whenever a write is performed to CR5C, STWR is asserted (low). This strobe can be
used to enable a register to drive data onto any or all of the LD[7:4] lines. This data is
then latched into these bits.
| Bits 31-8  Reserved  |     |     |     |     |     |     |
| -------------------- | --- | --- | --- | --- | --- | --- |
Serial Port (MMFF20)
| Read/Write  | Address: FF20H  |     |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
This register can also be accessed at I/O ports E2H or E8H. See the Serial Communications Port de
scription in Section 4.
| 15      |             | 9   | 7  6  5  | 4  3  | 2  1  | 0   |
| ------- | ----------- | --- | -------- | ----- | ----- | --- |
| 14  13  | 12  11  10  | 8   |          |       |       |     |
R  R  R  B4M  B3M  B2M  B1M  BOM  R  R  R  SPE  SDR  SCR  SDW  SCW
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
R
| R  R  R                         | R  R  R  | R  R  | R  R  R  | R  R  | R  R  |     |
| ------------------------------- | -------- | ----- | -------- | ----- | ----- | --- |
| Bit 0  SCW -Serial Clock Write  |          |       |          |       |       |     |
0= Pin 205 is driven low
1 = Pin 205 is tri-stated
Pin 205 carries the DDC/12C clock, depending on the operational mode. When pin 205
is tri-stated, other devices may drive this line. The actual state of the pin is read via
bit 2 of this register.
LPB REGISTER DESCRIPTIONS 22-9

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Bit 1 SOW -Serial Data Write
o = Pin 206 is driven low
1 = Pin 206 is tri-stated
Pin 206 carries the DDC/12C data, depending on the operational mode. When pin 206
is tri-stated, other devices may drive this line. The actual state of the pin is read via
bit 3 of this register.
Bit 2 SCR -Serial Clock Read (Read Only)
o = Pin 205 is low
1 = Pin 205 is tri-stated (no device is driving this line)
Bit 3 SDR -Serial Data Read (Read Only)
o = Pin 206 is low
1 = Pin 206 is tri-stated (no device is driving this line)
Bit 4 SPE -Serial Port Enable
0= Use of bits 1-0 of this register disabled
1 = Use of bits 1-0 of this register enabled
Bits 5-7 Reserved
Bit 8 BOM -Bit 0 Mirror (Read Only)
0= Pin 205 is driven low
1 = Pin 205 is tri-stated
Bit 9 B 1M -Bit 1 Mirror (Read Only)
0= Pin 206 is driven low
1 = Pin 206 is tri-stated
Bit 10 B2M -Bit 2 Mirror (Read Only)
o
= Pin 205 is low
1 = Pin 205 is tri-stated (no device is driving this line)
Bit 11 B3M -Bit 3 Mirror (Read Only)
0= Pin 206 is low
1 = Pin 206 is tri-stated (no device is driving this line)
22-10 LPB REGISTER DESCRIPTIONS

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Bit 12  B4M -Bit 4 Mirror (Read Only)  |     |     |     |     |     |
| -------------------------------------- | --- | --- | --- | --- | --- |
o = Use of bits 1-0 of this register disabled
1 = Use of bits 1-0 of this register enabled
This bit mirrors bit 4 and allows reading of this data on byte lane 2 at I/O address E2H.
| Bits 31-13  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
LPB Video Input Window Size (MMFF24)
| ReadIWrite  |     | Address: FF24H  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-on Default: Undefined
This register applies only to Video 8 In or Video 16 mode
|             |     | I  I  I    | I  I  I                 | I  I  I  | I  I     |
| ----------- | --- | ---------- | ----------------------- | -------- | -------- |
| 15  14  13  | 12  | 11  10  9  | 8  7  6                 | 5  4  3  | 2  1  0  |
| R  R  R     | R   |            | VIDEO INPUT LINE WIDTH  |          |          |
|             |     | I  I  I    | I  I  I                 | I        | I  1     |
31  30  29  28  27  26  25  24  23  22  21  201  19  1 18  17  16
|                                    |     | I  I  I  |                            |     |     |
| ---------------------------------- | --- | -------- | -------------------------- | --- | --- |
| R  R  R                            | R   | R  R  R  | VIDEO INPUT WINDOW HEIGHT  |     |     |
| Bits 11-0  Video Input Line Width  |     |          |                            |     |     |
Value = [# pixels x 2) -2 for Video 8 mode
Value = # pixels -2 for Video 16 mode
This is the width of the displayed line after the offset specified in MMFF28_11-0. Be
fore the 2 is subtracted, the number of pixels must be a multiple of 4. For example, in
Video 16 mode, if the line width is 637 pixels, this must be rounded up to 640. The
programmed value is then 640 -2 = 638.
| Bits 15-12  Reserved                   |     |     |     |     |     |
| -------------------------------------- | --- | --- | --- | --- | --- |
| Bits 24-16  Video Input Window Height  |     |     |     |     |     |
Value = [height in lines of each video input frame) -1
This is the number of displayed lines -1 after the offset specified in MMFF28_24_16.
| Bits 31-25  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
LPB REGISTER DESCRIPTIONS 22-11

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
LPB Video Data Offsets (MMFF28)
| Read/Write  |     | Address: FF28H  |     |     |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-on Default: Undefined
This register applies only to Video 8 In or Video 16 mode
|             |     | I       | I  I  | I                             | I  I  | I     | I  I  | I     | I   |
| ----------- | --- | ------- | ----- | ----------------------------- | ----- | ----- | ----- | ----- | --- |
| 15  14  13  | 12  | 11  10  | 9     | 8  7                          | 6     | 5  4  | 3     | 2  1  | 0   |
| R  R  R     | R   |         |       | HORIZONTAL VIDEO DATA OFFSET  |       |       |       |       |     |
|             |     | I       | I  I  | I                             | I  I  | I     | I  I  | I     | I   |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
|                                          |     | 1     | I  I  |     |                             |     |     |     |     |
| ---------------------------------------- | --- | ----- | ----- | --- | --------------------------- | --- | --- | --- | --- |
| R  R  R                                  | R   | R  R  | R     |     | VERTICAL VIDEO DATA OFFSET  |     |     |     |     |
| Bits 11-0  Horizontal Video Data Offset  |     |       |       |     |                             |     |     |     |     |
Value = [number of LCLKs between HSYNC and the start of valid pixel datal -2
| Bits 15·12  Reserved                    |     |     |     |     |     |     |     |     |     |
| --------------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Bits 24·16  Vertical Video Data Offset  |     |     |     |     |     |     |     |     |     |
Value = number of HSYNCs between VSYNC and the first valid data line
| Bits 31·25  Reserved  |     |     |     |     |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
LPB Horizontal Decimation Control (MMFF2C)
| Read/Write  |     | Address: FF2CH  |     |     |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-on Default: Undefined
| I  I  | I   |     |     |     | I  I  | I   | I  I  | I   | I   |
| ----- | --- | --- | --- | --- | ----- | --- | ----- | --- | --- |
15  14  13  12  I 11  I 10  I  9  I  8  I  7  6  5  4  3  2  1  0
VIDEO DATA BYTE MASK
| I  I  | I  I  | I   | I  I  | I   | I  I  | I   | I  I  | I   | I   |
| ----- | ----- | --- | ----- | --- | ----- | --- | ----- | --- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
VIDEO DATA BYTE MASK
| Bits 31·0  Video Data Byte Mask  |     |     |     |     |     |     |     |     |     |
| -------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Each 32 bytes of video data input is compared with this mask. If a bit in this mask is 1,
the corresponding byte is discarded. If a bit is a 0, the corresponding byte is passed
to the video memory. In Video 16 mode, each bit masks 2 bytes. In pass-through
mode, each bit masks 4 bytes. Normally, decimation starts with bit 0 after an HSYNC.
If a horizontal video data offset is specified in MMFF28_11-0 (video 8 or 16 modes
only), decimation aligns with the start of data after the offset.
22-12  LPB REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
LPB Vertical Decimation Control (MMFF30)
| Read/Write  | Address: FF30H  |     |     |     |
| ----------- | --------------- | --- | --- | --- |
Power-on Default: OOOOOOOOH
|     | I  I  I  | I  I  1  | 1   | I   |
| --- | -------- | -------- | --- | --- |
15  ,  14  ,  13  ,  12  11  10  9  8  7  6  5  -'  4  ,  3  ,  2  ,  1  0
VIDEO DATA LINE MASK
,  30  ,  29  ,  28  ,  27  ,  26  ,  25  ,  24  ,  23  ,  22  ,  21  ,  20  ,  19  ,  18  ,  17  ,
| 31  |     |     |     | 16  |
| --- | --- | --- | --- | --- |
VIDEO DATA LINE MASK
| Bits 31-0  Video Data Line Mask  |     |     |     |     |
| -------------------------------- | --- | --- | --- | --- |
Each 32 lines of video data input is compared with this mask. If a bit in the mask is 0,
the corresponding line is discarded. If a bit is a 1, the corresponding line is passed to
the video memory. If a vertical video data offset is specified in MMFF28_24-16 (video
8 or 16 modes only), decimation does not align with the starting line after the offset
and instead starts from VSYNC.
LPB Line Stride (MMFF34)
| Read/Write  | Address: FF34H  |     |     |     |
| ----------- | --------------- | --- | --- | --- |
Power-on Default: OOOOOOOOH
11  ,  10  ,  9  ,  8  ,  7  ,  6  ,  5  ,  4  ,  3  ,  2  ,  1  ,
| 15  14  13  | 12  |     |              | 0   |
| ----------- | --- | --- | ------------ | --- |
| R  R  R     | R   |     | LINE STRIDE  |     |
I  J
31  30  29  28  27  ,  26'  25  I  24  I  23  ,  22  21  20  I  19  I  18  I  17  1  16
R  ,  ,  R  ,  R  ,  R  ,  R  ,  R  ,  R  ,  R  ,  R  ,  R  ,
| R  R  R                 | R   |     |     | R   |
| ----------------------- | --- | --- | --- | --- |
| Bits 11-0  Line Stride  |     |     |     |     |
Value = byte offset of vertically adjacent pixels
This offset is added to the line starting address each HSYNC to get the new line start
ing address. Each line must begin on an 8-byte boundary.
| Bits 31-12  Reserved  |     |     |     |     |
| --------------------- | --- | --- | --- | --- |
LPB REGISTER DESCRIPTIONS 22-13

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
LPB Output FIFO (MMFF40)
Read/Write Address: FF40H, FF44H ... ,FF5CH
Power-on Default: OOOOOOOOH
Writes to any of the addresses in this 8 doubleword address range will be transferred to the LPB input
FIFO. This allows efficient use of the MOVSD assembly language instruction. Accesses must be to
doubleword addresses.
15 I 14 I 13 I 12 I 11 I 10 L 9 J 8 I 7 I 6 I 5 j 4 I 3 I 2 1 1 I 0
OUTPUT FIFO DATA
I I I I I I I I I I I I I I I
31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16
OUTPUT FIFO DATA
Bits 31-0 Output FIFO Data
Note: Software must never transfer more compressed data than there is room for in
the output FIFO. This information is read from MMFF04_3-0.
22-14 LPB REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Section 23: PCI Register Descriptions
The PCI specification defines a configuration register space. These registers allow device relocation,
device independent system address map construction and automatic configurations. The Tri064V+
provides a subset of these registers, which are described below.
The configuration register space occupies 256 bytes. When a configuration read or write command is
issued, the AD[7:0] lines contain the address of the register in this space to be accessed. The Tri064V+
supports or returns 0 for the first 64 bytes of this space.
In the following register descriptions, 'R' stands for reserved (write = 0, read = undefined). See Appendix
A for a table listing each of the registers in this section and its page number.
Vendor 10
Read Only Address: OOH
Power-On Default: 5333H
This read-only register identifies the device manufacturer.
115 I 14 I 13 12 11 10 5 4 3 2 o
Vendor ID
Bits 15-0 Vendor ID
This is hardwired to 5333H to identify S3 Incorporated.
PCI REGISTER DESCRIPTIONS 23-1

| , .   |     |     |     |     |     |
| ----- | --- | --- | --- | --- | --- |
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Device ID
| Read Only  | Address: 02H  |     |     |     |     |
| ---------- | ------------- | --- | --- | --- | --- |
Power-On Default: 8811 H
This read-only register contains the same value for all Trio family products. The Trio64V+ is identified by a
value of 4xH in CR2F and the PCI revision 10 field, where "x" will vary by revision.
| 15  14  13  | 12  11  10  |     | 5  4  | 3  2  | o   |
| ----------- | ----------- | --- | ----- | ----- | --- |
Device ID
| Bits 15-0  Device ID  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
value = 8811 H (hardwired)
Command
| ReadIWrite  | Address: 04H  |     |     |     |     |
| ----------- | ------------- | --- | --- | --- | --- |
Power-On Default: OOOOH
This register controls which types of PCI cycles the Trio64V+ can generate and respond to.
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0    |
| ----------- | ----------- | -------- | -------- | -------- | ---- |
|             |             |          | DAC      | MEM      | I/O  |
SNP
| R  R  R                                      | R  R  R  | R  R  R  | R  R  | R  R  |     |
| -------------------------------------------- | -------- | -------- | ----- | ----- | --- |
| Bit 0  I/O -Enable Response to I/O Accesses  |          |          |       |       |     |
o = Response to I/O space accesses is disabled
1 = Response to I/O space accesses enabled
| Bit 1  MEM -Enable Response to Memory Accesses  |     |     |     |     |     |
| ----------------------------------------------- | --- | --- | --- | --- | --- |
o = Response to memory space accesses is disabled
1 = Response to memory space accesses enabled
| Bits 4-2  Reserved                               |     |     |     |     |     |
| ------------------------------------------------ | --- | --- | --- | --- | --- |
| Bit 5  DAC SNP -RAMDAC Register Access Snooping  |     |     |     |     |     |
o = Trio64V+ claims and responds to all RAMDAC register access cycles
1 = Trio64V+ performs RAMDAC register writes but does not claim the PCI cycle.
RAMDAC register read accesses are performed by the Trio64V+.
Bits 15-6
Reserved
23-2 PCI REGISTER DESCRIPTIONS

fl·
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Status
| Read/Write  | Address: 06H  |     |     |     |     |
| ----------- | ------------- | --- | --- | --- | --- |
Power-On Default: 0200H
Bits 8-0  Reserved
Bits 10-9  DEVSEL -Device Select Timing
value = 01 (medium DEVSEL timing) (hardwired)
Bits 15-11  Reserved
Class Code
| Read Only  | Address: 08H  |     |     |     |     |
| ---------- | ------------- | --- | --- | --- | --- |
Power-On Default: 30000H
This register is hardwired to 300004xH. The 3 specifies that the Tri064V+ is a VGA-compatible display
controller. The "x" in the revision ID will change with each revision.
| J  J  | J   | 8   | I  I  |     | 0   |
| ----- | --- | --- | ----- | --- | --- |
15  1  14  13  12  1  11  1  10  9  .1  7l 6  l  5  4  3  1  2  1  1  1
| PROGRAMMING INTERFACE  |     |     | REVISION ID  |     |     |
| ---------------------- | --- | --- | ------------ | --- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| 1  1  1          | 1  1  1  | 1  1  | 1  1  1    | 1  1  | 1   |
| ---------------- | -------- | ----- | ---------- | ----- | --- |
| BASE CLASS CODE  |          |       | SUB-CLASS  |       |     |
PCI REGISTER DESCRIPTIONS 23-3

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Base Address 0
| Read/Write  | Address: 12H (high)  | 10H (low)  |     |     |     |
| ----------- | -------------------- | ---------- | --- | --- | --- |
Power-On Default: 0000 OOOOH
This is a 32-bit register in PCI configuration space that provides for address relocation. The Tri064V+
maps the upper 6 bits of the register to the Linear Address Window Position register CR59_7-2.
Consequently, these bits map to system address bits [31:26].
| 15  14  13                          | 12  11  10  | 9  8  7  | 6  5  | 4  3  2  j    | 1  0  |
| ----------------------------------- | ----------- | -------- | ----- | ------------- | ----- |
| R  R  R                             | R  R  R     | R  R  R  | R  R  | R  PREF       | MSI   |
|                                     |             |          |       | =0  TYPE =00  | =0    |
| Bit 0  MSI -Memory Space Indicator  |             |          |       |               |       |
value = 0 (base registers map into memory space) (hardwired)
| Bits 2-1  TYPE -Type of Address Relocation  |     |     |     |     |     |
| ------------------------------------------- | --- | --- | --- | --- | --- |
value = 00 (locate anywhere in 32-bit address space) (hardwired)
| Bit 3  PREF -Prefetchable  |     |     |     |     |     |
| -------------------------- | --- | --- | --- | --- | --- |
value = 0 (does not meet the prefetchable requirements) (hardwired)
| Bits 22-4  Reserved         |     |     |     |     |     |
| --------------------------- | --- | --- | --- | --- | --- |
| Bits 31-23  BASE ADDRESS 0  |     |     |     |     |     |
See the description for the Linear Address Window Position registers (CR59, CR5A).
Writes to CR59 will also update this field.
23-4 PCI REGISTER DESCRIPTIONS

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
BIOS ROM Base Address
| Read/Write  | Address: 32H (high) 30H (low)  |     |     |
| ----------- | ------------------------------ | --- | --- |
Power-On Default: OOOC OOOOH
This is a 32-bit register in PCI configuration space that provides for video BIOS ROM address relocation.
| Bit 0  | ADE -Address Decode Enable  |     |     |
| ------ | --------------------------- | --- | --- |
o
= Accesses to the BIOS ROM address space defined in this register are disabled
1 = Accesses to the BIOS ROM address space defined in this register are enabled
| Bits 15-1   | Reserved               |     |     |
| ----------- | ---------------------- | --- | --- |
| Bits 31-16  | BIOS ROM BASE ADDRESS  |     |     |
These are the upper 16 bits of the BIOS ROM address.
Interrupt Line
| Read/Write  | Address: 3CH  |     |     |
| ----------- | ------------- | --- | --- |
Power-On Default: OOH
This register contains interrupt line routing information written by the POST program during power-on
initialization.
| 7  6  | 543  | 2   | o   |
| ----- | ---- | --- | --- |
INTERRUPT LINE
| Bits 7-0  | INTERRUPT LINE  |     |     |
| --------- | --------------- | --- | --- |
PCI REGISTER DESCRIPTIONS 23-5

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Interrupt Pin
| Read Only  | Address: 3DH  |     |
| ---------- | ------------- | --- |
Power-On Default: 01H
This register specifies that INTA is the interrupt pin used.
o
| 7  6  | 543  | 2  1  |
| ----- | ---- | ----- |
INTERRUPT PIN
| Bits 7-0  | INTERRUPT PIN  |     |
| --------- | -------------- | --- |
value = 01H (hardwired)
23-6 PCI REGISTER DESCRIPTIONS

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporalad
Appendix A: Register Reference
This Appendix contains tables listing all the registers in each of categories corresponding to Sections
16-23 of this data book.
• VGA
• S3VGA
• System Control
• System Extension
• Enhanced Commands
• Streams Processor
• LPB
• PCI Configuration Space
Within each table, registers are listed in order of increasing addresses/indices. Name, address, register
bit descriptions with read/write status and the page number of the detailed register description are
provided for each register. All addresses and indices are hexadecimal values.
REGISTER REFERENCE A-1

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
A.1  VGA REGISTERS
? = B for monochrome, D for color.
Table A-1.  VGA Registers
| Add  Index              |                                        | Register Name    | Description  |
| ----------------------- | -------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)            |                                        | Bit Description  | Page         |
| General or External Re  | isters                                 |                  |              |
| 3C2                     | Miscellaneous Output                   |                  | 16-1         |
| 0  W                    | Color emulation. Address based at 3Dx  |                  |              |
| 1  W                    | Enable CPU access of video memory      |                  |              |
W
| 3-2   | Video DCLK select. Enable DCLK PLL loading  |     |     |
| ----- | ------------------------------------------- | --- | --- |
| 4  W  | Reserved                                    |     |     |
| 5  W  | Select the hiqh 64K paqe of memory          |     |     |
W
| 6       | Make HSYNC an active low signal             |     |       |
| ------- | ------------------------------------------- | --- | ----- |
| 7  W    | Make VSYNC an active low signal             |     |       |
| 3CC     | Miscellaneous Output                        |     | 16-1  |
| 0  R    | Color emulation. Address based at 3Dx       |     |       |
| 1  R    | Enable CPU access of video memory           |     |       |
| 3-2  R  | Video DCLK select. Enable DCLK PLL loading  |     |       |
| 4  R    | Reserved                                    |     |       |
| 5  R    | Select the high 64K page of memory          |     |       |
| 6  R    | Make HSYNC an active low signal             |     |       |
| 7  R    | Make VSYNC an active low signal             |     |       |
| 37A     | Feature Control                             |     | 16-2  |
| 2-0  W  | Reserved                                    |     |       |
W  VSYNC is ORed with the internal display enable signal
3
| 7-4  W  | Reserved                                              |     |       |
| ------- | ----------------------------------------------------- | --- | ----- |
| 3CA     | Feature Control                                       |     | 16-2  |
| 2-0  R  | Reserved                                              |     |       |
| 3  R    | VSYNC is ORed with the internal displayenable Signal  |     |       |
| 7-4  R  | Reserved                                              |     |       |
| 3C2     |                                                       |     | 16-3  |
Input Status 0
| 3-0  R  | Reserved  |     |     |
| ------- | --------- | --- | --- |
4  R  The internal SENSE signal is a logical 1
6-5
R  Reserved
7  R  Vertical retrace interrupt to the CPU is pending
A-2  REGISTER REFERENCE

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-1. VGA Registers (continued)
| Add  Index    |                                                     | Register Name    | Description  |
| ------------- | --------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                 | Bit Description  | PaJle        |
| 37A           | Input Status 1                                      |                  | 16-3         |
| 0             | R  The display in not in active display mode        |                  |              |
| 1             | R  Reserved                                         |                  |              |
| 2             | R  Reserved =1                                      |                  |              |
| 3             | R  Vertical retrace period is active                |                  |              |
| 5-4           | R  Feedback of two color outQuts for test purposes  |                  |              |
| 7-6           | R  Reserved                                         |                  |              |
| 3C3           | Video Subsystem Enable                              |                  | 16-4         |
0  Enable VGA display
| 7-1  | RNV  Reserved  |     |     |
| ---- | -------------- | --- | --- |
Sequencer Registers
| 3C4      | Sequencer Index                                       |     | 16-5  |
| -------- | ----------------------------------------------------- | --- | ----- |
| 4-0      | RNV  Index to the sequencer reqister to be accessed   |     |       |
| 7-5      | RNV  Reserved                                         |     |       |
| 3C5      | Sequencer Data                                        |     | 16-5  |
| 7-0      | RNV  Data to or from the sequencer register accessed  |     |       |
| 3C5  00  | Reset (SRO)                                           |     | 16-6  |
0  RNV  Asynchronous reset (not functional for the Tri064V+)
| 1        | RNV  Synchronous reset (not functional for the Tri064V+)  |     |       |
| -------- | --------------------------------------------------------- | --- | ----- |
| 7-2      | RNV  Reserved                                             |     |       |
| 3C5  01  | Clocking Mode (SR1)                                       |     | 16-6  |
| 0        | RNV  Character clocks are 8 dots wide                     |     |       |
| 1        | RNV  Reserved                                             |     |       |
2  RNV  Load the video serializers eveJY second character clock
3  RNV  The internal character clock is 1/2 the DCLK frequency_
4  RNV  Load the video serializers every fourth character clock
| 5        | RNV  Screen is turned off  |     |       |
| -------- | -------------------------- | --- | ----- |
| 3C5  02  | Enable Write Plane (SR2)   |     | 16-7  |
3-0  RNV  Enables a CPU write to the correspondinq color plane
| 7-4      | RNV  Reserved                                             |     |       |
| -------- | --------------------------------------------------------- | --- | ----- |
| 3C5  03  | Character Font Select (SR3)                               |     | 16-8  |
| 4, 1-0   | RNV  Select Font B                                        |     |       |
| 5,3-2    | RNV  Select Font A                                        |     |       |
| 7-6      | RNV  Reserved                                             |     |       |
| 3C5  04  | Memory Mode Control (SR4)                                 |     | 16-9  |
| 0        | RNV  Reserved                                             |     |       |
| 1        | RNV  Memory access to 256K allowed (required for VGA)     |     |       |
| 2        | RNV  Sequential addressing for CPU video memory accesses  |     |       |
REGISTER REFERENCE  A-3

•
...
~
| ...  | Trio64V+ Integrated Graphics/Video Accelerator  |     |     |
| ---- | ----------------------------------------------- | --- | --- |
S3 Incorporated
Table A-1. VGA Registers (continued)
| Add  Index    |                                                         | Register Name    | Description  |
| ------------- | ------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                     | Bit Description  | Page         |
| 3             | R/W  Modulo 4 addressing for CPU video memory accesses  |                  |              |
| 7-4           | R/W  Reserved                                           |                  |              |
| 3C5  08       | Unlock Extended Sequencer (SR8)                         |                  | 16-10        |
| 7-0           | R/W  Load xxxxOll Ob to unlock SR9-SRl C                |                  |              |
| 3C5  09       | R/W  Extended Sequencer 9                               |                  | 16-10        |
| 6-0           | R/W  Reserved                                           |                  |              |
| 7             | R/W  Memory-mapped I/O only (no PIO)                    |                  |              |
| 3C5  OA       | Extended Sequencer A (SRA)                              |                  | 16-10        |
| 4-0           | R/W  Reserved                                           |                  |              |
| 5             | R/W  PD[63:0] not tri-stated                            |                  |              |
| 6             | R/W  Pin 50 is RASl                                     |                  |              |
| 7             | R/W  2 MCLK memory writes                               |                  |              |
| 3C5  OB       | Extended Sequencer B (SRB)                              |                  | 16-11        |
0  R/W  Use VCLKI for internal dot clock functions (test only)
| 1        | R/W  Pixel data from VAFC latched by VCLKI           |     |        |
| -------- | ---------------------------------------------------- | --- | ------ |
| 2        | R/W  Reserved                                        |     |        |
| 3        | R/W  Enable 24 bits/pixel                            |     |        |
| 7-4      | R/W  Specify color mode for feature connector input  |     |        |
| 3C5  00  | Extended Sequencer 0 (SRD)                           |     | 16-12  |
| 0        | R/W  Enable feature connector operation              |     |        |
| 1        | R/W  Select LPB feature connector                    |     |        |
| 3-2      | R/W  Reserved                                        |     |        |
| 5-4      | R/W  HSYNC control for Green PC requirements         |     |        |
| 7-6      | R/W  VSYNC control for Green PC requirements         |     |        |
| 3C5  10  | MCLK Value Low (SR10)                                |     | 16-13  |
| 4-0      | R/W  MCLK N-divider value                            |     |        |
| 6-5      | R/W  MCLK R value                                    |     |        |
| 7        | R/W  Reserved                                        |     |        |
| 3C5  11  | MCLK Value High (SR11)                               |     | 16-14  |
| 6-0      | R/W  MCLK M-divider value                            |     |        |
| 7        | R/W  Reserved                                        |     |        |
| 3C5  12  | DCLK Value Low (SR12)                                |     | 16-14  |
| 4-0      | R/W  DCLK N-divider value                            |     |        |
6-5
R/W  DCLK R value
| 7        | R/W  Reserved              |     |        |
| -------- | -------------------------- | --- | ------ |
| 3C5  13  | DCLK Value High (SR13)     |     | 16-15  |
| 6-0      | R/W  DCLK M-divider value  |     |        |
| 7        | R/W  Reserved              |     |        |
A-4 REGISTER REFERENCE

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-1. VGA Registers (continued)
| Add  Index  |     | Register Name  | Description  |
| ----------- | --- | -------------- | ------------ |
ress  Bit(s)
|          | R/W                                                | Bit Description  | Page   |
| -------- | -------------------------------------------------- | ---------------- | ------ |
| 3C5  14  | CLKSVN Control 1 (SR14)                            |                  | 16-15  |
| 0        | RNV  DCLK PLL powered down (test only)             |                  |        |
| 1        | RNV  MCLK PLL powered down (test only)             |                  |        |
| 3        | RNV  Test MCLK (test only)                         |                  |        |
| 4        | RNV  Clear clock synthesizer counters (test only)  |                  |        |
5  Pi n 146 tri-stated
RNV
| 6        | RNV  MCLK is input on pin 146 (test only)  |     |        |
| -------- | ------------------------------------------ | --- | ------ |
| 7        | RNV  DCLK is input on pin 156 (test only)  |     |        |
| 3C5  15  | CLKSVN Control 2 (SR15)                    |     | 16-17  |
| 0        | RNV  Load new MCLK frequency               |     |        |
| 1        | RNV  Load new DCLK frequency               |     |        |
2  MCLK output on pin 147 (test only)
RNV
| 3        | RNV  VCLK direction determined by EVCLK                 |     |        |
| -------- | ------------------------------------------------------- | --- | ------ |
| 4        | RNV  Divide DCLK by 2                                   |     |        |
| 5        | RNV  Load MCLK and DCLK PLL values immediately          |     |        |
| 6        | RNV  Invert DCLK                                        |     |        |
| 7        | RNV  Enable 2 MCLK memory writes                        |     |        |
| 3C5  16  | CLKSVN Test High (SR16)                                 |     | 16-18  |
| 7-0      | RNV  Reserved                                           |     |        |
| 3C5  17  | CLKSVN Test High (SR17)                                 |     | 16-18  |
| 7-0      | RNV  Reserved                                           |     |        |
| 3C5  18  | RAMDAC/CLKSVN Control (SR18)                            |     | 16-19  |
| 0        | RNV  RAMDAC test counter enabled (test only)            |     |        |
| 1        | RNV  Reset RAMDAC test counter                          |     |        |
| 2        | RNV  Place red data on intemal data bus (test only)     |     |        |
| 3        | RNV  Place green data on internal data bus (test only)  |     |        |
| 4        | RNV  Place blue data on internal data bus (test only)   |     |        |
| 5        | RNV  Power-down RAMDAC                                  |     |        |
| 6        | RNV  Select 1 cycle LUT write                           |     |        |
| 7        | RNV  RAMDAC clock doubled mode enabled                  |     |        |
| 3C5  1C  | Extended Sequencer 1C (SR1C)                            |     | 16-20  |
| 1-0      | RNV  Select functions for pins 151 and 190              |     |        |
| 1        | RNV  Reserved                                           |     |        |
REGISTER REFERENCE  A-5

••
r
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Table A-1. VGA Registers (continued)
| Add  Index    |      | Register Name    | Description  |
| ------------- | ---- | ---------------- | ------------ |
| reS5  Bit(s)  | R/W  | Bit Description  | Page         |
CRT Controller Registers
| 374      | CRT Controller Index                             |     | 16-21  |
| -------- | ------------------------------------------------ | --- | ------ |
| 7-0      | RM/  Index to the CRTC register to be accessed   |     |        |
| 375      | CRT Controller Data                              |     | 16-21  |
| 7-0      | RM/  Data to or from the CRTC reqister accessed  |     |        |
| 375  00  | Horizontal Total (CRO)                           |     | 16-22  |
7-0  Number of characters in a line -5
RM/
| 375  01  | Horizontal Display End (CR1)  |     | 16-22  |
| -------- | ----------------------------- | --- | ------ |
7-0  RM/  One less than the total number of displayed characters
| 375  02  | Start Horizontal Blank (CR2)                           |     | 16-23  |
| -------- | ------------------------------------------------------ | --- | ------ |
| 7-0      | RM/  Character count where horizontal blanking starts  |     |        |
| 375  03  | End Horizontal Blank (CR3)                             |     | 16-23  |
| 4-0      | RM/  End position of horizontal blanking               |     |        |
| 6-5      | RM/  Display enable skew in character clocks           |     |        |
| 7        | RM/  Reserved                                          |     |        |
| 375  04  | Start Horizontal Sync Position (CR4)                   |     | 16-24  |
| 7-0      | RM/  Character count where HSYNC qoes active           |     |        |
| 375  05  | End Horizontal Sync Position (CR5)                     |     | 16-24  |
| 4-0      | RM/  Position where HSYNC goes inactive                |     |        |
| 6-5      | RM/  Horizontal retrace end delay in character clocks  |     |        |
| 7        | RM/  End horizontal blankinq bit 5                     |     |        |
| 375  06  | Vertical Total (CR6)                                   |     | 16-25  |
| 7-0      | RM/  Number of lines -2                                |     |        |
| 375  07  | CRTC Overflow (CR7)                                    |     | 16-25  |
| 0        | RM/  Vertical total bit 8                              |     |        |
| 1        | RM/  Vertical display end bit 8                        |     |        |
| 2        | RM/  Vertical retrace start bit 8                      |     |        |
| 3        | RM/  Start vertical blank bit 8                        |     |        |
| 4        | RM/  Line compare bit 8                                |     |        |
| 5        | RM/  Vertical total bit 9                              |     |        |
| 6        | RM/  Vertical display end bit 9                        |     |        |
| 7        | RM/  Vertical retrace start bit 9                      |     |        |
| 375  08  | Preset Row Scan (CR8)                                  |     | 16-26  |
| 4-0      | RM/  Line where first character row begins             |     |        |
| 6-5      | RM/  Number of bytes to pan horizontally               |     |        |
| 7        | RM/  Reserved                                          |     |        |
A-S  REGISTER REFERENCE

fl·
Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Table A-1. VGA Registers (continued)
| Add  Index    |     | Register Name    | Description  |
| ------------- | --- | ---------------- | ------------ |
| ress  Bit(s)  |     | Bit Description  | Page         |
R/W
| 375  09   | Maximum Scan Line (CR9)            |     | 16-26  |
| --------- | ---------------------------------- | --- | ------ |
| 4-0  RNV  | Character height in scan lines -1  |     |        |
| 5         | Start vertical blank bit 9         |     |        |
RNV
| 6  RNV  | Line compare bit 9                          |     |        |
| ------- | ------------------------------------------- | --- | ------ |
| 7  RNV  | Double scanning (repeat each line) enabled  |     |        |
|         | Cursor Start Scan Line (CRA)                |     | 16-27  |
375  OA
| 4-0  RNV  | Cursor startina line within the character cell  |     |     |
| --------- | ----------------------------------------------- | --- | --- |
| 5  RNV    | Turns off the cursor                            |     |     |
| 7-6       | Reserved                                        |     |     |
RNV
| 375  OB   | Cursor End Scan Line (CRB)                    |     | 16-27  |
| --------- | --------------------------------------------- | --- | ------ |
| 4-0  RNV  | Cursor ending line within the character cell  |     |        |
| 6-5       | Cursor skew to right in characters            |     |        |
RNV
| 7  RNV    | Reserved                                |     |        |
| --------- | --------------------------------------- | --- | ------ |
| 375  OC   | Start Address High (CRC)                |     | 16-28  |
| 7-0  RNV  | Bits 15-8 of the display start address  |     |        |
| 375  00   | Start Address Low (CRD)                 |     | 16-28  |
| 7-0  RNV  | Bits 7-0 of the display start address   |     |        |
375  OE  Cursor Location Address High (& Hardware Cursor  16-28
Foreground Color in Enhanced Mode) (CRE)
| 7-0  RNV  | Bits 1 5-8 of the cursor location start address  |     |     |
| --------- | ------------------------------------------------ | --- | --- |
375  OF  Cursor Location Address Low (& Hardware Cursor  16-28
Background Color in Enhanced Mode) (CRF)
| 7-0  RNV  | Bits 7-0 of the cursor location start address  |     |        |
| --------- | ---------------------------------------------- | --- | ------ |
| 375  10   | Vertical Retrace Start (CR10                   |     | 16-29  |
| 7-0  RNV  | Vertical retrace start in scan lines           |     |        |
| 375  11   | Vertical Retrace End (CR11)                    |     | 16-29  |
| 3-0       | Vertical retrace end in scan lines             |     |        |
RNV
| 4  RNV  | Clear the vertical retrace interrupt flip-flop  |     |     |
| ------- | ----------------------------------------------- | --- | --- |
| 5  RNV  | Disable vertical interrupts                     |     |     |
| 6       | Five RAM refresh cycles per horizontal line     |     |     |
RNV
| 7  RNV   | Lock writes to CRO-CR7                |     |        |
| -------- | ------------------------------------- | --- | ------ |
| 375  12  | Vertical Display End (CR12)           |     | 16-30  |
| 7-0      | Number of scan lines of active video  |     |        |
RNV
| 375  13  | Offset (CR13)  |     | 16-30  |
| -------- | -------------- | --- | ------ |
7-0  RNV  Memory start address jump from one scan line to the next
REGISTER REFERENCE
A-7

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A·1. VGA Registers (continued)
| Add  Index    |                                                    | Register Name    | Description  |
| ------------- | -------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                | Bit Description  | Page         |
| 375  14       | Underline Location (CR14)                          |                  | 16·31        |
| 4-0           | RNI/  Horizontal scan line where underline occurs  |                  |              |
5  RNI/  Memory address counter increment is 4 character clocks
| 6        | RNI/  Memory accessed as doublewords                       |     |        |
| -------- | ---------------------------------------------------------- | --- | ------ |
| 7        | RNI/  Reserved                                             |     |        |
| 375  15  | Start Vertical Blank (CR15)                                |     | 16·31  |
| 7-0      | RNI/  Horizontal scan line where vertical blanking starts  |     |        |
| 375  16  | End Vertical Blank (CR16)                                  |     | 16·32  |
| 7-0      | RNI/  Horizontal scan line where vertical blankinq ends    |     |        |
| 375  17  | CRTC Mode Control (CR17)                                   |     | 16·32  |
| 0        | RNI/  Enable bank 2 mode for CGA emulation                 |     |        |
| 1        | RNI/  Enable bank 4 mode for CGA emulation                 |     |        |
| 2        | RNI/  Use horizontal retrace ciock divided by 2            |     |        |
| 3        | RNI/  Enable count by 2 mode                               |     |        |
| 4        | RNI/  Reserved                                             |     |        |
| 5        | RNI/  Enable CGA mode address wrap                         |     |        |
| 6        | RNI/  Use byte address mode                                |     |        |
| 7        | RNI/  Horizontal and vertical retrace signals enabled      |     |        |
| 375  18  | Line Compare (CR18)                                        |     | 16·34  |
7-0  RNI/  Line at which memory address counter cleared to 0
| 375  22     | CPU Latch Data (CR22)                                    |     | 16·34  |
| ----------- | -------------------------------------------------------- | --- | ------ |
| 7-0         | R  Value in the CPU latch in the graphics controller     |     |        |
| 375  24,26  | Attribute Controller Flag/Index                          |     | 16·35  |
| 5-0         | R  Value of the attribute controller index data at 3COH  |     |        |
| 6           | R  Reserved                                              |     |        |
| 7           | R  State of inverted internal address flip-flop          |     |        |
Graphics Controller Registers
16-36
| 3CE  | Graphics Controller Index  |     |     |
| ---- | -------------------------- | --- | --- |
3-0  RNI/  Index to the qraphics controller reqister to be accessed
| 7-4  | RNI/  Reserved  |     |     |
| ---- | --------------- | --- | --- |
16-36
| 3CF  | Graphics Controller Data  |     |     |
| ---- | ------------------------- | --- | --- |
7-0  RNI/  Data to or from the _graphics controller reqister accessed
| 3CF  00  | Set/Reset (GRO)  |     | 16·37  |
| -------- | ---------------- | --- | ------ |
3-0  Color value for CPU memory writes
RNI/
| 7-4      | RNI/  Reserved                            |     |        |
| -------- | ----------------------------------------- | --- | ------ |
| 3CF  01  | Enable Set/Reset (GR1)                    |     | 16-37  |
| 3-0      | RNI/  Enable planes for writinq GRO data  |     |        |
| 7-4      | RNI/  Reserved                            |     |        |
A-8  REGISTER REFERENCE

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Table A-1. VGA Registers (continued)
| Add  Index    |                                                     | Register Name    | Description  |
| ------------- | --------------------------------------------------- | ---------------- | ------------ |
| re5S  Bit(s)  | R/W                                                 | Bit Description  | Page         |
| 3CF  02       | Color Compare (GR2)                                 |                  | 16-38        |
| 3-0           | R/VV  Reference color for color compare operations  |                  |              |
| 7-4           | R/VV  Reserved                                      |                  |              |
| 3CF  03       | Raster Operation/Rotate Counter (GR3)               |                  | 16-38        |
2-0  R/VV  Number of right rotate positions for a CPU memory write
| 4-3      | R/VV  Select raster operation (logical function)  |     |        |
| -------- | ------------------------------------------------- | --- | ------ |
| 7-5      | R/VV  Reserved                                    |     |        |
| 3CF  04  | Read Plane Select (GR4)                           |     | 16-39  |
| 1-0      | R/VV  Select planes for reading                   |     |        |
| 7-2      | R/VV  Reserved                                    |     |        |
| 3CF  05  | Graphics Controller Mode (GR5)                    |     | 16-40  |
| 1-0      | R/VV  Select write mode                           |     |        |
2  R/VV  Reserved
3  R/VV  Enable read compare operation
4  R/VV  Select odd/even addressing
5  R/VV  Select odd/even shift mode
6  R/VV  Select 256 color shift mode
7  R/VV  Reserved
| 3CF  06  | Memory Map Mode Control (GR6)  |     | 16-41  |
| -------- | ------------------------------ | --- | ------ |
0  R/VV  Select graphics mode memory addressing
1  R/VV  Chain odd/even planes
| 3-2      | R/VV  Select memory mapping                         |     |        |
| -------- | --------------------------------------------------- | --- | ------ |
| 7-4      | R/VV  Reserved                                      |     |        |
| 3CF  07  | Color Don't Care (GR7)                              |     | 16-42  |
| 3-0      | R/VV  Select color plane used for color comparison  |     |        |
| 7-4      | R/VV  Reserved                                      |     |        |
Bit Mask (GR8)
| 3CF  08  |     |     | 16-42  |
| -------- | --- | --- | ------ |
7-0  R/VV  Each bit is a mask for the corresponding memory plane bit
Attribute Registers
| 3CO  | Attribute Controller Index  |     | 16-43  |
| ---- | --------------------------- | --- | ------ |
4-0  R/VV  Index to the attribute controller register to be accessed
5  R/VV  Enable video display
| 7-6    | R/VV  Reserved             |     |        |
| ------ | -------------------------- | --- | ------ |
| 3C1/0  | Attribute Controller Data  |     | 16-44  |
7-0  R/VV  Data to or from the attribute controller register accessed
| 3C1/0  OO-OF  | Palette Register (ARO-ARF)  |     | 16-44  |
| ------------- | --------------------------- | --- | ------ |
| 5-0           | R/VV  Color value           |     |        |
| 7-6           | R/VV  Reserved              |     |        |
REGISTER REFERENCE  A-9

| , .   |     |     |     |     |
| ----- | --- | --- | --- | --- |
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-1. VGA Registers (continued)
| Add  Index    |                               | Register Name    |     | Description  |
| ------------- | ----------------------------- | ---------------- | --- | ------------ |
| ress  Bit(s)  | R/W                           | Bit Description  |     | Page         |
| 3C1/0  10     | Attribute Mode Control (AR10  |                  |     | 16-45        |
0  RNV  Select graphics mode
1  RNV  Select monochrome display
2  RNV  Enable line graphics characters
3  RNV  Enable blinking
4  RNV  Reserved
5  RNV  Enable top panning
6  RNV  Select 256 color mode
7  RNV  Bits 5-4 of video output come from AR 14 1-0
| 3C1/0  11  | Border Color (AR11)                                     |     |     | 16-46  |
| ---------- | ------------------------------------------------------- | --- | --- | ------ |
| 7-0        | RNV  Border color value                                 |     |     |        |
| 3C1/0  12  | Color Plane Enable (AR12)                               |     |     | 16-46  |
| 3-0        | RNV  Display plane enable                               |     |     |        |
| 5-4        | RNV  Select inputs to bits 5-4 of 3?AH                  |     |     |        |
| 7-6        | RNV  Reserved                                           |     |     |        |
| 3C1/0  13  | Horizontal Pixel Panning (AR13)                         |     |     | 16-47  |
| 3-0        | RNV  Number of pixels to shift the display to the left  |     |     |        |
| 7-4        | RNV  Reserved                                           |     |     |        |
| 3C1/0  14  | Pixel Padding (AR14)                                    |     |     | 16-48  |
=
| 1-0  | RNV  Bits 5-4 of the video output if AR 10 7  |     | 1   |     |
| ---- | --------------------------------------------- | --- | --- | --- |
| 3-2  | RNV  Bits 7-6 of the video output             |     |     |     |
| 7-4  | RNV  Reserved                                 |     |     |     |
RAMDAC Registers
| 3C6  | DAC Mask                                  |     |     | 16-49  |
| ---- | ----------------------------------------- | --- | --- | ------ |
| 7-0  | RNV  Pixel read mask                      |     |     |        |
| 3C7  | DAC Read Index                            |     |     | 16-49  |
| 7-0  | W  Index to j)alette register to be read  |     |     |        |
| 3C7  | DACStatus                                 |     |     | 16-50  |
1-0  R  Shows whether previous DAC cycle was a read or write
| 7-2  | R  Reserved  |     |     |     |
| ---- | ------------ | --- | --- | --- |
-
| 3C8  | DAC Write Index  |     |     | 16-50  |
| ---- | ---------------- | --- | --- | ------ |
7-0  RNV  Index to palette register to be written or General Input Port
read data
| 3C9  | DAC Data  |     |     | 16-51  |
| ---- | --------- | --- | --- | ------ |
7-0  Data from register pointed to by DAC Read or Write Index
RNV
A-l0 REGISTER REFERENCE

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
A.2  S3 VGA REGISTERS
The Tri064V+ has additional registers described in Table A-2 that are located in CRT Controller address
space at locations not used by IBM. All of these registers are read/write protected at power-up by
hardware reset. In order to read/write these registers, the Register Lock 1 register (CR3S) must be loaded
with a binary unlock key pattern (see the register description). The registers will remain unlocked until
the key pattern is reset. ? = B for monochrome, D for color.
Table A-2.  53 VGA Registers
| Add  Index    |                                               | Register Name    | Description  |
| ------------- | --------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                           | Bit Description  | Page         |
| 375  2D       | Device ID High (CR2D)                         |                  | 17-1         |
| 7-0           | R  HiQh byte of device ID (88H)               |                  |              |
| 375  2E       | Device ID Low (CR2E)                          |                  | 17-2         |
| 7-0           | R  Low byte of device ID (11 H)               |                  |              |
| 375  2F       | Revision (CR2F)                               |                  | 17-2         |
| 7-0           | R  4x                                         |                  |              |
| 375  30       | Chip ID/Rev (CR30)                            |                  | 17-2         |
| 3-0           | R  Chip Identification -EH                    |                  |              |
| 7-4           | R  Chip revision status (stepping) -See CR2F  |                  |              |
| 375  31       | Memory Configuration (CR31)                   |                  | 17-3         |
| 0             | RNV  Enable base address offset (CR6A 6-0)    |                  |              |
| 1             | RNV  Enable two-paQe screen imaQe             |                  |              |
| 2             | RNV  Enable VGA 16-Bit Memory Bus Width       |                  |              |
| 3             | RNV  Use Enhanced mode memory mapping         |                  |              |
5-4  RNV  Old display start address bits 17-16 (see CR69 3-0)
| 6        | RNV  Enable high speed text display font fetch mode     |     |       |
| -------- | ------------------------------------------------------- | --- | ----- |
| 7        | RNV  Reserved                                           |     |       |
| 375  32  | Backward Compatibility 1 (CR32)                         |     | 17-4  |
| 3-0      | RNV  Reserved                                           |     |       |
| 4        | RNV  Enable interrufJt generation                       |     |       |
| 5        | RNV  Reserved                                           |     |       |
| 6        | RNV  Use standard VGA memory wrapping at 256K boundary  |     |       |
| 7        | RNV  Reserved                                           |     |       |
| 375  33  | Backward Compatibility 2 (CR33)                         |     | 17-5  |
| 0        | RNV  Reserved                                           |     |       |
1  RNV  Disable write protection provided by CR11  7 on CR7  1,6
2  RNV  Reserved
| 3   | RNV  VCLK is inverted DCLK                           |     |     |
| --- | ---------------------------------------------------- | --- | --- |
| 4   | RNV  Disable writes to RAMDAC registers (3C6H-3C9H)  |     |     |
5  RNV  BLANK signal active during entire non-active video period
6  RNV  Disable writes to Palette/Overscan registers (ARO-ARF)
| 7   | RNV  Reserved  |     |     |
| --- | -------------- | --- | --- |
REGISTER REFERENCE  A-11

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Table A-2. 83 VGA Registers (continued)
| Add  Index    |                                                          | Register Name    | Description  |
| ------------- | -------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                      | Bit Description  | Page         |
| 375  34       | Backward Compatibility 3 (CR34)                          |                  | 17-6         |
| 0             | RNJ  PCI DAC snoop method select                         |                  |              |
| 1             | RNJ  Disable PCI master abort handlinQ durinQ DAC snoop  |                  |              |
| 2             | RNJ  Disable PCI retry handlinq durinq DAC snoop         |                  |              |
| 3             | RNJ  Reserved                                            |                  |              |
| 4             | RNJ  Enable Display Start FIFO Fetch register (CR3B)     |                  |              |
| 7-5           | RNJ  Reserved                                            |                  |              |
| 375  35       | CRT Register Lock (CR35)                                 |                  | 17-7         |
| 3-0           | RNJ  Old CPU base address (see CR6A 6-0)                 |                  |              |
| 4             | RNJ  Lock Vertical TiminQ reQisters                      |                  |              |
| 5             | RNJ  Lock Horizontal TiminQ reQisters                    |                  |              |
| 7-6           | RNJ  Reserved                                            |                  |              |
| 375  36       | Configuration 1 (CR36)                                   |                  | 17-8         |
| 1-0           | R  Select System bus (PCI or VL-Bus)                     |                  |              |
3-2  RNJ  Select Memory page mode (fast page, EDO or 1-cycle EDO)
| 4    | RNJ  Enable BIOS ROM accesses (VL-Bus)  |     |       |
| ---- | --------------------------------------- | --- | ----- |
| 7-5  | RNJ  Define display memory size         |     |       |
| 37   | Configuration 2 (CR37)                  |     | 17-8  |
375
| 0   | RNJ  Enable Trio32/64 operation (VL-Bus)       |     |     |
| --- | ---------------------------------------------- | --- | --- |
| 1   | RNJ  Reserved                                  |     |     |
| 2   | RNJ  Select 32K or 64K BIOS ROM size (VL-Bus)  |     |     |
| 3   | RNJ  Use intemal MCLK, DCLK                    |     |     |
| 4   | RNJ  Define RAMDAC write snooping (VL-Bus)     |     |     |
7-5
RNJ  Reserved
| 375  38  | Register Lock 1 (CR38)                    |     | 17-10  |
| -------- | ----------------------------------------- | --- | ------ |
| 7-0      | RNJ  Unlock S3 VGA reQisters (CR30-CR3C)  |     |        |
|          | Register Lock 2 (CR39)                    |     | 17-10  |
375  39
7-0  RNJ  Unlock System Control, System Extension and Strapping
reqisters (CR40-CR4F, CR50-CR6D)
| 375  3A  | Miscellaneous 1 (CR3A)                                   |     | 17-10  |
| -------- | -------------------------------------------------------- | --- | ------ |
| 1-0      | RNJ  Select alternate refresh count per horizontal line  |     |        |
| 2        | RNJ  Enable alternate refresh count (CR3A 1-0)           |     |        |
| 3        | RNJ  Enable simultaneous VGA text and Enhanced modes     |     |        |
| 4        | RNJ  Enable 8-, 16-or 24/32-bit color Enhanced modes     |     |        |
| 5        | RNJ  Enable hiQh speed text font writing                 |     |        |
| 6        | RNJ  Reserved                                            |     |        |
| 7        | RNJ  Disable PCI bus read burst cycles                   |     |        |
A-12 REGISTER REFERENCE

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-2. S3 VGA Registers (continued)
| Add  Index    |                                  | Register Name    | Description  |
| ------------- | -------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                              | Bit Description  | Page         |
| 375  3B       | Start Display FIFO Fetch (CR3B)  |                  | 17-11        |
7-0  RMJ  Specify_start of display FIFO fetches for screen refreshing
| 375  3C  | Interlace Retrace Start (CR3C)                       |     | 17-12  |
| -------- | ---------------------------------------------------- | --- | ------ |
| 7-0      | RMJ  Specify interlaced mode retrace start position  |     |        |
A.3  SYSTEM CONTROL REGISTERS
System Control registers are configuration registers, mode control registers, and hardware graphics
cursor control registers. They are positioned in the same indexed register space as VGA S3 registers.
All of these registers are read/write protected at power-up by hardware reset. In order to read/write
these registers, the Register Lock 2 register (CR39) must be loaded with a binary unlock key pattern
(see the register description). The registers will remain unlocked until the key pattern is reset. 7 = B for
monochrome, D for color.
The following table summarizes the System Control registers.
Table A-3.  System Control Registers
| Add  Index    |                              | Register Name    | Description  |
| ------------- | ---------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                          | Bit Description  | Page         |
| 375  40       | System Configuration (CR40)  |                  | 18-1         |
0  Enable Enhanced mode register access
RMJ
| 3-1  | RMJ  Reserved  |     |     |
| ---- | -------------- | --- | --- |
4  RMJ  Ready (Wait State) Control (VL-Bus)
5  RMJ  Reserved = 1
| 7-6      | RMJ  Reserved                |     |       |
| -------- | ---------------------------- | --- | ----- |
| 375  41  | BIOS Flag (CR41)             |     | 18-2  |
| 7-0      | RMJ  Used by the video BIOS  |     |       |
| 375  42  | Mode Control (CR42)          |     | 18-2  |
| 4-0      | RMJ  Reserved                |     |       |
5  RMJ  Select Interlaced mode
6  RMJ  Reserved
REGISTER REFERENCE A-13

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-3. System Control Registers (continued)
| Add  Index    |                                                             | Register Name    | Description  |
| ------------- | ----------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                         | Bit Description  | Page         |
| 375  43       | Extended Mode (CR43)                                        |                  | 18-2         |
| 1-0           | RNI/  Reserved                                              |                  |              |
| 2             | RNI/  Old logical screen width bit 8                        |                  |              |
| 6-3           | RNI/  Reserved                                              |                  |              |
| 7             | RNI/  Enable horizontal counter double mode                 |                  |              |
| 375  45       | Hardware Graphics Cursor Mode (CR45)                        |                  | 18-3         |
| 0             | RNI/  Enable hardware graphics cursor                       |                  |              |
| 3-1           | RNI/  Reserved                                              |                  |              |
| 4             | RNI/  Set up space at right of bit map for hardware cursor  |                  |              |
| 7-5           | RNI/  Reserved                                              |                  |              |
375  46-47  Hardware Graphics Cursor Origin-X (CR46-CR47)  18-3
| 10-0   | RNI/  X-coordinate of the hardware cursor left side  |     |     |
| ------ | ---------------------------------------------------- | --- | --- |
| 15-11  | RNI/  Reserved                                       |     |     |
375  48-49  Hardware Graphics Cursor Origin-V (CR48-CR49)  18-4
| 10-0   | RNI/  V-coordinate of the hardware cursor upper line  |     |     |
| ------ | ----------------------------------------------------- | --- | --- |
| 15-11  | RNI/  Reserved                                        |     |     |
375  4A  Hardware Graphics Cursor Foreground Stack (CR4A)  18-4
| 7-0  | RNI/  Hardware cursor foreqround color (3 reqisters)  |     |     |
| ---- | ----------------------------------------------------- | --- | --- |
375  4B  Hardware Graphics Cursor Background Stack (CR4B)  18-4
| 7-0  | RNI/  Hardware cursor background color (3 registers)  |     |     |
| ---- | ----------------------------------------------------- | --- | --- |
375  4C-4D  Hardware Graphics Cursor Start Address (CR4C-CR4D)  18-5
| 12-0   | RNI/  Hardware cursor start address  |     |     |
| ------ | ------------------------------------ | --- | --- |
| 15-13  | RNI/  Reserved                       |     |     |
375  4E  Hardware Graphics Cursor Pattern Display Start X-Pixel  18-5
Position (CR4E)
| 5-0  | RNI/  Hardware cursor display start x-coordinate  |     |     |
| ---- | ------------------------------------------------- | --- | --- |
| 7-6  | RNI/  Reserved                                    |     |     |
375  4F  Hardware Graphics Cursor Pattern Display Start V-Pixel  18-5
Position (CR4F)
| 5-0  | RNI/  Hardware cursor display start y-coordinate  |     |     |
| ---- | ------------------------------------------------- | --- | --- |
| 7-6  | RNI/  Reserved                                    |     |     |
A-14 REGISTER REFERENCE

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
A.4 SYSTEM EXTENSION REGISTERS
These registers provide extended system and memory control, external sync control and addressing
window control. They are enabled in the same way as the System Control registers via the Register
Lock 2 register (CR39). ? = B for monochrome, D for color.
Table A-4.  System Extension Registers
| Add  Index     |                                | Register Name    | Description  |
| -------------- | ------------------------------ | ---------------- | ------------ |
| dress  Bit(s)  | R/W                            | Bit Description  | Page         |
| 375  50        | Extended System Cont 1 (CR50)  |                  | 19-1         |
R[W
0  Most significant bit of screen width definition (see bits 7-6)
| 3-1  | R[W  Reserved             |     |     |
| ---- | ------------------------- | --- | --- |
| 5-4  | R[W  Pixel length select  |     |     |
| 7-6  | R[W                       |     |     |
With bit 0, screen width definition
| 375  51  | Extended System Cont 2 (CR51)              |     | 19-2  |
| -------- | ------------------------------------------ | --- | ----- |
| 1-0      | R[W  Old display start address bits 19-18  |     |       |
| 3-2      | R[W  Old CPU base address bits 19-18       |     |       |
| 5-4      | R[W  Logical screen width bits 9-8         |     |       |
| 7-6      | R[W  Reserved                              |     |       |
|          | Extended BIOS Flag 1 (CR52)                |     | 19-3  |
375  52
| 7-0      | R[W  Used by the video BIOS     |     |       |
| -------- | ------------------------------- | --- | ----- |
| 375  53  | Extended Memol}' Cont 1 (CR53)  |     | 19-3  |
0  R[W  Reserved
| 2-1  | R[W  Big endian byte swap select for linear addressing  |     |     |
| ---- | ------------------------------------------------------- | --- | --- |
| 4-3  | R[W  Memory-mapped I/O type select                      |     |     |
R[W
5  MMIO window select (A8000H or B8000H)
6  R[W  Enable nibble swa~
7  R[W  Reserved
| 375  54  | Extended Memory Cont 2 (CR54)  |     | 19-4  |
| -------- | ------------------------------ | --- | ----- |
1-0  R[W  Big endian byte swap select (not linear addressing or image
transfers)
| 2,7-3    | R[W  Specify M parameter for display FIFO control  |     |       |
| -------- | -------------------------------------------------- | --- | ----- |
| 375  55  | Extended DAC Control (CR55)                        |     | 19-4  |
| 1-0      | R[W  Reserved                                      |     |       |
2  R[W  Enable General Input Port read
3  R[W  Reserved
4  R[W  Enable X-11 windows hardware cursor mode
| 6-5  | R[W  Reserved  |     |     |
| ---- | -------------- | --- | --- |
7  R[W  VCLK output pin is tri-stated
| 375  56  | External Sync Cont 1 (CR56)  |     | 19-5  |
| -------- | ---------------------------- | --- | ----- |
0  R[W  Reserved
1  R[W  HSYNC output buffer tri-stated
REGISTER REFERENCE  A-15

, .
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-4. System Extension Registers (continued)
| Add  Index    |     | Register Name    | Description  |
| ------------- | --- | ---------------- | ------------ |
| ress  Bit(s)  |     | Bit Description  | Page         |
R/W
| 375  56  | External Sync Cont 1 (CR56)     |     | 19-5  |
| -------- | ------------------------------- | --- | ----- |
| 2  RNI/  | VSYNC output buffer tri-stated  |     |       |
7-3
RNI/  Reserved
| 375  58    | Linear Address Window Control (CR58)   |     | 19-6  |
| ---------- | -------------------------------------- | --- | ----- |
| 1-0  RNI/  | Linear addressing window size          |     |       |
| 2  RNI/    | Reserved                               |     |       |
| 3  RNI/    | Address latch timinq control (VL-Bus)  |     |       |
| 4  RNI/    | Enable linear addressinq               |     |       |
| 6-5        | Reserved                               |     |       |
RNI/
| 7  RNI/     | RAS timing adjustment                         |     |       |
| ----------- | --------------------------------------------- | --- | ----- |
| 375  59-5A  | Linear Address Window Position (CR59-5A)      |     | 19-7  |
| 15-0        | Linear addressing window position bits 31-16  |     |       |
RNI/
| 375  5C    | General Out Port (CR5C)                     |     | 19-8  |
| ---------- | ------------------------------------------- | --- | ----- |
| 7-0  RNI/  | General Output Port                         |     |       |
| 375  5D    | Extended Horizontal Overflow (CR5D)         |     | 19-8  |
| 0  RNI/    | Horizontal total bit 8 (CRO)                |     |       |
| 1  RNI/    | Horizontal display end bit 8 (CR 1)         |     |       |
| 2  RNI/    | Start horizontal blank bit 8 (CR2)          |     |       |
| 3  RNI/    | End horizontal blank bit 7 (CR3, CR5)       |     |       |
| 4  RNI/    | Start horizontal sync position bit 8 (CR4)  |     |       |
| 5          | End horizontal sync position bit 6 (CR5)    |     |       |
RNI/
| 6  RNI/  | Start FIFO Fetch bit 8 (CR3B)          |     |       |
| -------- | -------------------------------------- | --- | ----- |
| 7  RNI/  | Reserved                               |     |       |
| 375  5E  | Extended Vertical Overflow (CR5E)      |     | 19-9  |
| 0  RNI/  | Vertical total bit 10 (CR6)            |     |       |
| 1  RNI/  | Vertical display end bit 10 (CR12)     |     |       |
| 2  RNI/  | Start vertical blank bit 10 (CR 1 5)   |     |       |
| 3  RNI/  | Reserved                               |     |       |
| 4  RNI/  | Vertical retrace start bit 10 (CR1 0)  |     |       |
| 5  RNI/  | Reserved                               |     |       |
| 6  RNI/  | Line compare position bit 10 (CR 18)   |     |       |
| 7  RNI/  | Reserved                               |     |       |
A-16 REGISTER REFERENCE

••
r
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporatad
Table A-4. System Extension Registers (continued)
| Add  Index    |                                               | Register Name    | Description  |
| ------------- | --------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                           | Bit Description  | Page         |
| 375  60       | Extended Memory Control 3 (CR60)              |                  | 19-9         |
| 7-0           | Specify N parameter for display FIFO control  |                  |              |
RNI/
| 375  61  | Extended Memory Control 4 (CR61)              |     | 19-10  |
| -------- | --------------------------------------------- | --- | ------ |
| 4-0      | RNI/  Reserved                                |     |        |
| 6-5      | Big endian byte swap select for image writes  |     |        |
RNI/
| 7        | RNI/  Reserved                         |     |        |
| -------- | -------------------------------------- | --- | ------ |
| 375  65  | Extended Miscellaneous Control (CR65)  |     | 19-10  |
| 2-0      | Reserved                               |     |        |
RNI/
| 4-3  | RNI/  Delay BLANK by DCLK                |     |        |
| ---- | ---------------------------------------- | --- | ------ |
| 7-5  | RNI/  Reserved                           |     |        |
| 66   | Extended Miscellaneous Control 1 (CR66)  |     | 19-11  |
375
| 0   | RNI/  Enable enhanced functions              |     |     |
| --- | -------------------------------------------- | --- | --- |
| 1   | RNI/  Software reset of the Graphics Engine  |     |     |
| 2   | Reserved                                     |     |     |
RNI/
3  RNI/  PCI disconnect on write with FIFO full or read with FIFO empty
| 5-4      | RNI/  Reserved                           |     |        |
| -------- | ---------------------------------------- | --- | ------ |
| 6        | RNI/  PAl 15:0J are tri-stated off       |     |        |
| 7        | RNI/  Enable PCI bus disconnect          |     |        |
| 375  67  | Extended Miscellaneous Control 2 (CR67)  |     | 19-12  |
| 0        | RNI/  VCLK is in phase with DCLK         |     |        |
| 1        | RNI/  Reserved                           |     |        |
| 3-2      | RNI/  Streams Processor mode select      |     |        |
| 7-4      | RNI/  Select RAMDAC color mode           |     |        |
| 375  68  | Configuration 3 (CR68)                   |     | 19-13  |
| 0        | RNI/  CAS, OE stretch time selection     |     |        |
| 1        | RNI/  Reserved                           |     |        |
| 2        | RNI/  RAS low timinq select              |     |        |
| 3        | RNI/  RAS precharqe timinq select        |     |        |
| 6-4      | RNI/  Video BIOS area                    |     |        |
| 7        | RNI/  Memory data bus size select        |     |        |
| 375  69  | Extended System Control 3 (CR69)         |     | 19-14  |
| 4-0      | RNI/  Display start address bits 19-16   |     |        |
| 7-5      | RNI/  Reserved                           |     |        |
| 375  6A  | Extended System Control 4 (CR6A)         |     | 19-14  |
| 5-0      | RNI/  CPU base address bits 19-14        |     |        |
| 7-6      | RNI/  Reserved                           |     |        |
REGISTER REFERENCE  A-17

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A·4. System Extension Registers (continued)
| Add  Index    |     | Register Name    | Description  |
| ------------- | --- | ---------------- | ------------ |
| ress  Bit(s)  |     | Bit Description  | Page         |
R/W
| 375  6B   | Extended BIOS Flag 3 (CR6B)  |     | 19·15  |
| --------- | ---------------------------- | --- | ------ |
| 7-0  RMJ  | Used by the video BIOS       |     |        |
| 375  6C   | Extended BIOS Flag 4 (CR6C)  |     | 19·15  |
| 7-0  RMJ  | Used by the video BIOS       |     |        |
| 375  60   | Extended BIOS Flag 5 (CR6D)  |     | 19·15  |
| 7-0       | Used by the video BIOS       |     |        |
RMJ
| 375  6E   | Extended BIOS Flag 6 (CR6E)           |     | 19·16  |
| --------- | ------------------------------------- | --- | ------ |
| 7-0  RMJ  | Used by the video BIOS                |     |        |
| 375  6F   | Configuration 4 (CRF)                 |     | 19·16  |
| 0  RMJ    | Select LPB vs Trio64-compatible mode  |     |        |
| 1  RMJ    | Select I/O address for MMFF20         |     |        |
Disable effect of bit 1 of this register
| 2  RMJ    |           |     |     |
| --------- | --------- | --- | --- |
| 4-3  RMJ  | WE delay  |     |     |
| 7-5  RMJ  | Reserved  |     |     |
A-1S REGISTER REFERENCE

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
A.5  ENHANCED COMMANDS REGISTERS
This section lists the registers which support the Tri064V+ enhanced drawing functions. All of these
registers are enabled only if bit 0 of the System Configuration register (CR40) is set to 1.
Table A-S.  Enhanced Commands Registers
| Add  Index    |                                                  | Register Name    | Description  |
| ------------- | ------------------------------------------------ | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                              | Bit Description  | Page         |
| 42E8          | Subsystem Status                                 |                  | 20-1         |
| 0             | R  Vertical sync interrupt status                |                  |              |
| 1             | R  Graphics Engine busy interrupt status         |                  |              |
| 2             | R  Command FIFO overflow interrupt status        |                  |              |
| 3             | R  Command FIFO empty interrupt status           |                  |              |
| 6-4           | R  Reserved                                      |                  |              |
| 7             | R  4 or 8 bit planes                             |                  |              |
| 15-8          | R  Reserved                                      |                  |              |
| 42E8          | Subsystem Control                                |                  | 20-2         |
| 0             | W  Clear vertical sync interrupt status          |                  |              |
| 1             | W  Clear Graphics Engine busy interrupt status   |                  |              |
| 2             | W  Clear Command FIFO overflow interrupt status  |                  |              |
| 3             | W  Clear Command FIFO empty interrupt status     |                  |              |
| 7-4           | W  Reserved                                      |                  |              |
| 8             | W  Vertical sync interrupt enabled               |                  |              |
| 9             | W  Graphics Engine busy interrupt enabled        |                  |              |
| 10            | W                                                |                  |              |
Command FIFO overflow interrupt enabled
| 11     | W  Command FIFO empty interrupt enabled      |     |       |
| ------ | -------------------------------------------- | --- | ----- |
| 13-12  | W  Reserved                                  |     |       |
| 15-14  | W  Graphics EnQine software reset selection  |     |       |
| 4AE8   | Advanced Function Control                    |     | 20-3  |
| 0      | R/W  Enable Enhanced mode functions          |     |       |
| 1      | R/W  Reserved                                |     |       |
| 2      | R/W  Specify 4 bits/pixel Enhanced mode      |     |       |
| 3      | R/W  Reserved                                |     |       |
| 4      | R/W  Enable linear addressing                |     |       |
| 15-5   | R/W  Reserved                                |     |       |
| 82Es   | Current V-Position                           |     | 20-4  |
| 11-0   | R/W  Pixel vertical screen coordinate        |     |       |
| 15-12  | R/W  Reserved                                |     |       |
| sGE8   | Current X-Position                           |     | 20-4  |
| 11-0   | R/W  Pixel horizontal screen coordinate      |     |       |
| 15-12  | R/W  Reserved                                |     |       |
REGISTER REFERENCE  A-19

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-5. Enhanced Commands Registers (continued)
| Add  Index    |                                             | Register Name    | Description  |
| ------------- | ------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                         | Bit Description  | Page         |
| 8AE8          | Destination V Position/Axial Step Constant  |                  | 20-5         |
11-0/  RNJ  Specifies ending vertical coordinate or axial step constant for a
| 13-0   | number of drawinq commands                     |     |       |
| ------ | ---------------------------------------------- | --- | ----- |
| 15-12  | RNJ  Reserved (Bits 15-14 for step constant)   |     |       |
| 8EE8   | Destination X Position/Diagonal Step Constant  |     | 20-5  |
11-0/  RNJ  Specifies ending horizontal coordinate or diagonal step
| 13-0   | constant for a number of drawing commands     |     |       |
| ------ | --------------------------------------------- | --- | ----- |
| 15-12  | RNJ  Reserved (Bits 15-14 for step constant)  |     |       |
| 92E8   | Line Error Term                               |     | 20-6  |
| 13-0   | RNJ  Error term for line draws                |     |       |
| 15-14  | RNJ  Reserved                                 |     |       |
| 96E8   | Major Axis Pixel Count                        |     | 20-6  |
| 11-0   | RNJ  Lenqth of the lonqest axis (pixels -1)   |     |       |
| 15-12  | RNJ  Reserved                                 |     |       |
| 9AE8   | Graphics Processor Status                     |     | 20-7  |
7-0  R  Low 8 bits of field showing FIFO slots available (see bits 15-11)
| 8      | R  Reserved                                   |     |       |
| ------ | --------------------------------------------- | --- | ----- |
| 9      | R  Graphics Engine busy                       |     |       |
| 10     | R  All FIFO slots empty                       |     |       |
| 15-11  | R  Hiqh 5 bits of FIFO status (see bits 7-0)  |     |       |
| 9AE8   | Drawing Command                               |     | 20-8  |
| 0      | W  Must be programmed to 1                    |     |       |
1  W  Select across the plane pixel mode
2  W  Last pixel will not be drawn
3  W  Select radial drawing direction
| 4    | W  Draw pixels               |     |     |
| ---- | ---------------------------- | --- | --- |
| 7-5  | W  Select drawing direction  |     |     |
8  W  Wait for CPU data
| 10-9   | W  Select system bus size  |     |     |
| ------ | -------------------------- | --- | --- |
| 11     | W  Reserved                |     |     |
| 12     | W  Enable byte swap        |     |     |
| 15-13  | W  Select command type     |     |     |
A-20 REGISTER REFERENCE

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-5. Enhanced Commands Registers (continued)
| Add  Index    |                                    | Register Name    | Description  |
| ------------- | ---------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                | Bit Description  | Page         |
| gEES          | Short Stroke Vector Transfer       |                  | 20-10        |
| 3-0           | W  Lenath of vector 1 (pixels -1)  |                  |              |
4  W  Draw oixels
| 7-5  | W  Select drawinq direction  |     |     |
| ---- | ---------------------------- | --- | --- |
15-8  W  Duolicate of bits 7-0 to define second short stroke vector
| A2ES  | Background Color                                           |     | 20-11  |
| ----- | ---------------------------------------------------------- | --- | ------ |
| 31-0  | R/W  Backaround color value                                |     |        |
| A6ES  | Foreground Color                                           |     | 20-11  |
| 31-0  | R/W  Forearound Color value                                |     |        |
| AAES  | Bitplane Write Mask                                        |     | 20-12  |
| 31-0  | R/W  Each bit enables uodatina of corresoondina bit olane  |     |        |
AEES
|       | BitDlane Read Mask                                        |     | 20-12  |
| ----- | --------------------------------------------------------- | --- | ------ |
| 31-0  | R/W  Each bit enables readinq of correspondinq bit plane  |     |        |
| B2ES  | Color Compare                                             |     | 20-13  |
31-0
R/W  Color value to be comoared with current bitmap color
| B6ES  | Background Mix      |     | 20-13  |
| ----- | ------------------- | --- | ------ |
| 3-0   | W  Select mix tvoe  |     |        |
4  W
Reserved
| 6-5   | W  Select color source  |     |        |
| ----- | ----------------------- | --- | ------ |
| 15-7  | W  Reserved             |     |        |
| BAES  | Foreground Mix          |     | 20-13  |
| 3-0   | W  Select mix type      |     |        |
4  W  Reserved
| 6-5  | W   |     |     |
| ---- | --- | --- | --- |
Select color source
| 15-7     | W  Reserved                                            |     |        |
| -------- | ------------------------------------------------------ | --- | ------ |
| BEES     | Read Register Data                                     |     | 20-14  |
| 15-0     | R  Data from reqister selected by bits 2-0 of BEE8H E  |     |        |
| BEES  0  | Minor Axis Pixel Count                                 |     | 20-15  |
| 11-0     | W  Rectanqle heiqht (oixels -1)                        |     |        |
| 15-12    | W  Reserved                                            |     |        |
| BEES  1  | Top Scissors                                           |     | 20-15  |
| 11-0     | W  Too side of the cliooina rectanale                  |     |        |
| 15-12    | W  Reserved                                            |     |        |
| BEES  2  | Left Scissors                                          |     | 20-15  |
| 11-0     | W  Left side of the cliooina rectanale                 |     |        |
| 15-12    | W  Reserved                                            |     |        |
REGISTER REFERENCE  A-21

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-5. Enhanced Commands Registers (continued)
| Add  Index    |      | Register Name    | Description  |
| ------------- | ---- | ---------------- | ------------ |
| ress  Bit(s)  | R/W  | Bit Description  | Page         |
3
| BEES     | Bottom Scissors                           |     | 20-16  |
| -------- | ----------------------------------------- | --- | ------ |
| 11-0     | W  Bottom side of the clipping rectangle  |     |        |
| 15-12    | W  Reserved                               |     |        |
| BEES  4  | Right Scissors                            |     |        |
20-16
| 11-0     | W  Right side of the clippinq rectanqle                  |     |        |
| -------- | -------------------------------------------------------- | --- | ------ |
| 15-12    | W  Reserved                                              |     |        |
| BEES  A  | Pixel Control                                            |     | 20-16  |
| 5-0      | W  Reserved                                              |     |        |
| 7-6      | W  Select mix register                                   |     |        |
| 11-8     | W  Reserved                                              |     |        |
| 15-12    | W  OAH (index)                                           |     |        |
| BEES  D  | Multifunction Control Miscellaneous 2                    |     | 20-17  |
| 2-0      | W  Destination base address location in memorv           |     |        |
| 3        | W  Reserved                                              |     |        |
| 6-4      | W  Source base address location in memory                |     |        |
| 11-7     | W  Reserved                                              |     |        |
| 15-12    | W  ODH (index)                                           |     |        |
| BEES  E  | Multifunction Control Miscellaneous                      |     | 20-1S  |
| 1-0      | W  Destination base address bits 21-20                   |     |        |
| 3-2      | W  Source base address bits 21-20                        |     |        |
| 4        | W  Select upper word for 32-bit register accesses        |     |        |
| 5        | W  Only pixels outside the clipping rectangle are drawn  |     |        |
| 6        | W  Reserved                                              |     |        |
7  W  Don't update bitmap if source is not equal to color compare
color
| 8      | W  Enable color comparison          |     |     |
| ------ | ----------------------------------- | --- | --- |
| 9      | W  Select 32-bit command registers  |     |     |
| 11-10  | W  Reserved                         |     |     |
| 15-12  | W  OEH (index)                      |     |     |
F
| BEES  | Read Register Select           |     | 20-19  |
| ----- | ------------------------------ | --- | ------ |
| 2-0   | W  Select register to be read  |     |        |
| 11-4  | W  Reserved                    |     |        |
W
| 15-12  | OFH (index)          |     |        |
| ------ | -------------------- | --- | ------ |
| E2ES   | Pixel Data Transfer  |     | 20-20  |
15-0  W  Data transfer register (CPU to Graphics Engine) -low word
| E2EA  | Pixel Data Transfer-Extension  |     | 20-20  |
| ----- | ------------------------------ | --- | ------ |
15-0  W  Data transfer register (CPU to Graphics Engine) -high word
A-22 REGISTER REFERENCE

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
A.6  STREAMS PROCESSOR REGISTERS
| Table A-S.  Streams Processor Registers  |                                             |                  |              |
| ---------------------------------------- | ------------------------------------------- | ---------------- | ------------ |
| Add  Index                               |                                             | Register Name    | Description  |
| dress  Bit(s)                            | R/W                                         | Bit Description  | Page         |
| 8180                                     | Primary Stream Control                      |                  | 21-1         |
| 23-0                                     | RNJ  Reserved                               |                  |              |
| 26-24                                    | RNJ  Primary stream input data format       |                  |              |
| 27                                       | RNJ  Reserved                               |                  |              |
| 30-28                                    | RNJ  Primary stream filter characteristics  |                  |              |
| 31                                       | RNJ  Reserved                               |                  |              |
21-2
| 8184   | Color/Chroma Key Control                        |     |     |
| ------ | ----------------------------------------------- | --- | --- |
| 7-0    | RNJ  BN/Cr key value (lower bound for chroma)   |     |     |
| 15-8   | RNJ  G/U/Cb ke~ value (lower bound for chroma)  |     |     |
| 23-16  | RNJ  R/Y kE3~ value (lower bound for chroma)    |     |     |
| 26-24  | RNJ  RGB color com~arisOnfJrecision             |     |     |
| 27     | RNJ  Reserved                                   |     |     |
Color key control (full compare or bit 16 of 1.5.5.5)
| 28     | RNJ                                       |     |       |
| ------ | ----------------------------------------- | --- | ----- |
| 31-29  | RNJ  Reserved                             |     |       |
| 8190   | Secondary Stream Control                  |     | 21·3  |
| 11-0   | DDA horizontal accumulator initial value  |     |       |
RNJ
| 23-12  | RNJ  Reserved                                 |     |       |
| ------ | --------------------------------------------- | --- | ----- |
| 26-24  | RNJ  Secondary stream input data format       |     |       |
| 27     | RNJ  Reserved                                 |     |       |
| 30-28  | RNJ  Secondary stream filter characteristics  |     |       |
| 31     | RNJ  Reserved                                 |     |       |
| 8194   | Chroma Key Upper Bound                        |     | 21-4  |
| 7-0    | RNJ  V/Cr key value (upper bound)             |     |       |
| 15-8   | RNJ  U/Cb keyvalue (upper bound)              |     |       |
| 23-16  | Y key value (upper bound)                     |     |       |
RNJ
| 31-24  | RNJ  Reserved                              |     |       |
| ------ | ------------------------------------------ | --- | ----- |
| 8198   | Secondary Stream Stretch/Filter Constants  |     | 21-4  |
| 10-0   | K1 horizontal scale factor                 |     |       |
RNJ
| 15-11  | RNJ  Reserved                    |     |     |
| ------ | -------------------------------- | --- | --- |
| 26-16  | RNJ  K2 horizontal scale factor  |     |     |
| 31-27  | Reserved                         |     |     |
RNJ
REGISTER REFERENCE
A-23

,I.
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-S.  Streams Processor Registers (continued)
| Add  Index     |                                          | Register Name    | Description  |
| -------------- | ---------------------------------------- | ---------------- | ------------ |
| dress  Bit(s)  | R/W                                      | Bit Description  | Page         |
| 81AO           | Blend Control                            |                  | 21-5         |
| 1-0            | RMJ  Reserved                            |                  |              |
| 4-2            | RMJ  Secondary stream blend coefficient  |                  |              |
9-5
RMJ  Reserved
| 12-10  | RMJ  Primary stream blend coefficient           |     |       |
| ------ | ----------------------------------------------- | --- | ----- |
| 23-13  | RMJ  Reserved                                   |     |       |
| 26-24  | RMJ  Compose mode                               |     |       |
| 31-27  | RMJ  Reserved                                   |     |       |
| 81CO   | Primary Stream Frame Buffer Address 0           |     | 21-S  |
| 21-0   | Primary stream frame buffer starting address 0  |     |       |
RMJ
| 31-22  | RMJ  Reserved                                   |     |       |
| ------ | ----------------------------------------------- | --- | ----- |
| 81C4   | Primary Stream Frame Buffer Address 1           |     | 21-S  |
| 21-0   | Primary stream frame buffer startinq address 1  |     |       |
RMJ
| 31-22  | RMJ  Reserved                                            |     |        |
| ------ | -------------------------------------------------------- | --- | ------ |
| 81C8   | Primary Stream Stride                                    |     | 21-7   |
| 11-0   | RMJ  Primary stream stride                               |     |        |
| 31-12  | RMJ  Reserved                                            |     |        |
| 81CC   | Double Buffer/LPB Support                                |     | 21-7   |
| 0      | RMJ  Select primary frame buffer address 1               |     |        |
| 2-1    | RMJ  Select secondary frame buffer address               |     |        |
| 3      | RMJ  Reserved                                            |     |        |
| 4      | RMJ  Select LPB frame buffer start address 1             |     |        |
| 5      | RMJ  LPB input buffer select loading at end of frame     |     |        |
| 6      | R//w  Selected LPB input buffer toggles at end of frame  |     |        |
| 31-7   | RMJ  Reserved                                            |     |        |
| 8100   | Secondary Stream Frame Buffer Address 0                  |     | 21-9   |
| 21-0   | RMJ  Secondary stream frame buffer starting address 0    |     |        |
| 31-22  | RMJ  Reserved                                            |     |        |
| 8104   | SecondaryStream Frame Buffer Address 1                   |     | 21-9   |
| 21-0   | RMJ  Secondary stream frame buffer starting address 1    |     |        |
| 31-22  | RMJ  Reserved                                            |     |        |
| 8108   | Secondary Stream Stride                                  |     | 21-10  |
| 11-0   | RMJ  Secondary stream stride                             |     |        |
| 31-12  | RMJ  Reserved                                            |     |        |
A-24 REGISTER REFERENCE

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-s. Streams Processor Registers (continued)
| Add  Index     |                                     | Register Name    | Description  |
| -------------- | ----------------------------------- | ---------------- | ------------ |
| dress  Bit(s)  | R/W                                 | Bit Description  | Page         |
| 81DC           | Blend Control                       |                  | 21-10        |
| 2-0            | RNJ  Reserved                       |                  |              |
| 12-3           | RNJ  Pixel stop fetch position      |                  |              |
| 18-13          | RNJ  Reserved                       |                  |              |
| 28-19          | RNJ  Pixel start fetch position     |                  |              |
| 29             | RNJ  Reserved                       |                  |              |
| 30             | RNJ  Primary stream on top          |                  |              |
| 31             | RNJ  Enable opaque overlay control  |                  |              |
| 81EO           | K1 Vertical Scale Factor            |                  | 21-12        |
| 10-0           | RNJ  K1  vertical scale factor      |                  |              |
| 31-11          | RNJ  Reserved                       |                  |              |
| 81E4           | K2 Vertical Scale Factor            |                  | 21-12        |
| 10-0           | RNJ  K2 vertical scale factor       |                  |              |
| 31-11          | RNJ  Reserved                       |                  |              |
21-13
| 81E8   | DDA Vertical Accumulator Initial Value                   |     |        |
| ------ | -------------------------------------------------------- | --- | ------ |
| 11-0   | RNJ  DDA vertical accumulator initial value              |     |        |
| 31-12  | RNJ  Reserved                                            |     |        |
| 81EC   | Streams FIFO and RAS Controls                            |     | 21-13  |
| 4-0    | RNJ  Streams FIFO allocation                             |     |        |
| 9-5    | RNJ  Secondary FIFO threshold                            |     |        |
| 14-10  | RNJ  Primary FIFO threshold                              |     |        |
| 15     | RNJ  RAS low time control                                |     |        |
| 16     | RNJ  RAS precharqe control                               |     |        |
| 17     | RNJ  Reserved                                            |     |        |
| 18     | RNJ  Enable 1-cycle EDO o~eration for LPB memory cycles  |     |        |
| 31-19  | RNJ  Reserved                                            |     |        |
| 81FO   | Primary Stream Window Start Coordinates                  |     | 21-14  |
| 10-0   | RNJ  Primary stream Y start                              |     |        |
| 15-11  | RNJ  Reserved                                            |     |        |
| 26-16  | RNJ  Primary stream X start                              |     |        |
| 31-27  | RNJ  Reserved                                            |     |        |
| 81F4   | Primary Stream Window Size                               |     | 21-15  |
| 10-0   | RNJ  Primary stream heiqht                               |     |        |
RNJ
| 15-11  | Reserved                   |     |     |
| ------ | -------------------------- | --- | --- |
| 26-16  | RNJ  Primary stream width  |     |     |
| 31-27  | RNJ  Reserved              |     |     |
REGISTER REFERENCE  A-25

| , . |     |     |     |
| --- | --- | --- | --- |
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-6. Streams Processor Registers (continued)
| Add  Index  |     | Register Name  |     |
| ----------- | --- | -------------- | --- |
Description
| dress  Bit(s)  | R/W                                        | Bit Description  | Page   |
| -------------- | ------------------------------------------ | ---------------- | ------ |
| 81F8           | Secondary Stream Window Start Coordinates  |                  | 21-15  |
| 10-0           | RM/  Secondary stream Y start              |                  |        |
| 15-11          | RM/  Reserved                              |                  |        |
| 26-16          | RM/  Secondary stream X start              |                  |        |
| 31-27          | RM/  Reserved                              |                  |        |
| 81FC           | Secondary Stream Window Size               |                  | 21-16  |
| 10-0           | RM/  Secondary stream height               |                  |        |
| 15-11          | RM/  Reserved                              |                  |        |
| 26-16          | RM/  Secondary stream width                |                  |        |
| 31-27          | RM/  Reserved                              |                  |        |
A-26 REGISTER REFERENCE

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
A.7  LPB REGISTERS
Table A-7.  LPB Registers
| Add  Index     |             | Register Name     |     | Description  |
| -------------- | ----------- | ----------------- | --- | ------------ |
| dress  Bit(s)  |             |                   | -"  | Page         |
| R/W            |             | Bit Descr_ipJion  |     |              |
| FFOO           | LPB Mode    |                   |     | 22-'         |
| 0  RNV         | Enable LPB  |                   |     |              |
3-1
RNV  LPB mode
| 4  RNV  | Reset LPB                                   |     |     |     |
| ------- | ------------------------------------------- | --- | --- | --- |
| 5  RNV  | Write every other received frame to memory  |     |     |     |
| 6       | No byte swap for incoming video             |     |     |     |
RNV
| 8-7  RNV  | Reserved                             |     |     |     |
| --------- | ------------------------------------ | --- | --- | --- |
| 9  RNV    | LPB vertical sync is active high     |     |     |     |
| 10        | LPB horizontal sy_nc is active high  |     |     |     |
RNV
| 11  W       | CPU VSYNC                               |     |                     |       |
| ----------- | --------------------------------------- | --- | ------------------- | ----- |
| 12  W       | CPU HSYNC                               |     |                     |       |
| 13  W       | Load base address currently pointed to  |     |                     |       |
| 15-14  RNV  | Reserved                                |     |                     |       |
| 17-16  RNV  | Maximum compressed data bust size       |     |                     |       |
| 20-18  RNV  | Reserved                                |     |                     |       |
| 22-21  RNV  | Video FIFO threshold                    |     |                     |       |
| 23  RNV     | Reserved                                |     |                     |       |
| 24  RNV     | LPB clock driven by LCLK                |     |                     |       |
| 25  RNV     | Don't add stride after first HSYNC      |     |                     |       |
| 26  RNV     | Invert the LCLK input                   |     |                     |       |
| 30-27  RNV  | Reserved                                |     |                     |       |
| 31  R       | CFLEVEL status                          |     |                     |       |
| FFOO4       | LPB FIFO Status                         |     |                     | 22-4  |
| 3-0  R      | LPB output FIFO status                  |     |                     |       |
| 10-4  R     | Reserved                                |     |                     |       |
| 11  R       | LPB output FIFO full                    |     |                     |       |
| 12  R       | LPB output FIFO empty                   |     |                     |       |
| 13  R       | LPB output FIFO almost empty            |     |                     |       |
| 19-14  R    | Reserved                                |     |                     |       |
| 20  R       | LPB video FIFO 0 full                   |     |                     |       |
| 21  R       | LPB video FIFO 0 empty                  |     |                     |       |
| 22  R       | LPB video FIFO 0 almost empty           |     |                     |       |
| 28-23  R    | Reserved                                |     |                     |       |
| 29  R       | LPB video FIFO 1 full                   |     |                     |       |
| 30  R       | LPB video FIFO 1 empty                  |     |                     |       |
| 31  R       | LPB video FIFO 1 almost empty           |     |                     |       |
|             |                                         |     | REGISTER REFERENCE  | A-27  |

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-7. LPB Registers (continued)
| Add  Index     |                                                           | Register Name    | Description  |
| -------------- | --------------------------------------------------------- | ---------------- | ------------ |
| dress  Bit(sl  | R/W                                                       | Bit Description  | Page         |
| FF08           | LPB Interrupt Flaas                                       |                  | 22-5         |
| 0              | RNJ  LPB Output FIFO empty                                |                  |              |
| 1              | RNJ  HSYNC (end of line) input on pin 202                 |                  |              |
| 2              | RNJ  VSYNC (end of frame) input on pin 203                |                  |              |
| 3              | RNJ  Serial port start condition detected                 |                  |              |
| 15-4           | RNJ  Reserved                                             |                  |              |
| 16             | RNJ  Enable LPB output FIFO empty interrupt               |                  |              |
| 17             | RNJ  Enable HSYNC (end of line) input interrupt           |                  |              |
| 18             | RNJ  Enable VSYNC (end of frame) input interrupt          |                  |              |
| 19             | RNJ  Enable serial port start condition detect interrupt  |                  |              |
| 23-20          | RNJ  Reserved                                             |                  |              |
24
RNJ  Drive SPCLK Iowan receipt of a serial port start condition
| 31-25  | RNJ  Reserved                                       |     |       |
| ------ | --------------------------------------------------- | --- | ----- |
| FFOC   | LPB Frame Buffer Address 0                          |     | 22-7  |
| 21-0   | RNJ  LPB frame buffer address 0                     |     |       |
| 31-22  | RNJ  Reserved                                       |     |       |
| FF10   | LPB Frame Buffer Address 1                          |     | 22-7  |
| 21-0   | RNJ  LPB frame buffer address 1                     |     |       |
| 31-22  | RNJ  Reserved                                       |     |       |
| FF14   | LPB Direct Read/Write Address                       |     | 22-8  |
| 20-0   | RNJ  Address of MPEG decoder address to read/write  |     |       |
| 23-21  | RNJ  MPEG decoder transaction tvpe                  |     |       |
| 31-24  | RNJ  Reserved                                       |     |       |
| FF18   | LPB Direct Read/Write Data                          |     | 22-8  |
| 31-0   | RNJ  LPB direct read/write data                     |     |       |
| FF1C   | LPB General Purpose Input/Output Port               |     | 22-9  |
| 3-0    | RNJ  General purpose output data port               |     |       |
| 7-4    | R  General purpose input data port                  |     |       |
| 31-8   | RNJ  Reserved                                       |     |       |
A-28 REGISTER REFERENCE

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
Table A-7. LPB Registers (continued)
| Add  Index  |     | Register Name  | Description  |
| ----------- | --- | -------------- | ------------ |
Bit(s)
| dress  | R/W                                                             | Bit Description  | Page  |
| ------ | --------------------------------------------------------------- | ---------------- | ----- |
| FF20   | Serial Port                                                     |                  | 22-9  |
| 0      | RMJ  o  = Serial clock write on pin 205, 1 = pin 205 tri-state  |                  |       |
o
| 1   | RMJ  = Serial data write on pin 206, 1 = pin 206 tri-state  |     |     |
| --- | ----------------------------------------------------------- | --- | --- |
o
| 2    | R  = Serial clock Iowan pin 205, 1 = pin 205 tri-state    |     |     |
| ---- | --------------------------------------------------------- | --- | --- |
| 3    | R  o  = Serial data Iowan pin 206, 1 = pin 206 tri-state  |     |     |
| 4    | RMJ  Enable serial port function                          |     |     |
| 5-7  | RMJ  Reserved                                             |     |     |
| 8    | R  Bit 0 mirror (data on byte lane 2 at E2H)              |     |     |
| 9    | R  Bit 1 mirror (data on byte lane 2 at E2H)              |     |     |
| 10   | R  Bit 2 mirror (data on byte lane 2 at E2H)              |     |     |
| 11   | R  Bit 3 mirror (data on byte lane 2 at E2H)              |     |     |
| 12   | Bit 4 mirror (data on byte lane 2 at E2H)                 |     |     |
R
| 31-13  | RMJ  Reserved                      |     |        |
| ------ | ---------------------------------- | --- | ------ |
| FF24   | LPB Video Input Window Size        |     | 22-11  |
| 11-0   | RMJ  Video input line width        |     |        |
| 15-12  | RMJ  Reserved                      |     |        |
| 24-16  | RMJ  Video input window heiqht     |     |        |
| 31-25  | RMJ  Reserved                      |     |        |
| FF28   | LPB Video Data Offsets             |     | 22-12  |
| 11-0   | RMJ  Horizontal video data offset  |     |        |
| 15-12  | RMJ  Reserved                      |     |        |
| 24-16  | RMJ  Vertical video data offset    |     |        |
| 31-25  | RMJ  Reserved                      |     |        |
| FF2C   | LPB Horizontal Decimation Control  |     | 22-12  |
| 31-0   | RMJ  Video data byte mask          |     |        |
| FF30   | LPB Vertical Decimation Control    |     | 22-13  |
| 7-0    | R  Video data line mask            |     |        |
| FF34   | LPB Line Stride                    |     | 22-13  |
| 11-0   | RMJ  Line stride                   |     |        |
| 31-12  | RMJ  Reserved                      |     |        |
| FF40   | LPB Output FIFO                    |     | 22-14  |
| 31-0   | RMJ  Output FIFO data              |     |        |
REGISTER REFERENCE  A-29

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
A.8  PCI CONFIGURATION SPACE REGISTERS
When a PCI configuration read or write command is issued, AD[7:0) contain the address of the register
in the configuration space to be accessed.
| Table A·8.  PCI Configuration Space Registers  |     |                |              |
| ---------------------------------------------- | --- | -------------- | ------------ |
| Add  Index                                     |     | Register Name  | Description  |
Bit(s)
| dress  | R/W                                              | Bit Description  | Page  |
| ------ | ------------------------------------------------ | ---------------- | ----- |
| 00     | Vendor ID                                        |                  | 23·'  |
| 15-0   | R  Hardwired to 5333H                            |                  |       |
| 02     | Device ID                                        |                  | 23·2  |
| 15-0   | R  Hardwired to 8811 H                           |                  |       |
| 04     | Command                                          |                  | 23·2  |
| 0      | RNI/  Response to I/O space accesses enabled     |                  |       |
| 1      | RNI/  Response to memory space accesses enabled  |                  |       |
| 4-2    | RNI/  Reserved                                   |                  |       |
Enable DAC snooping
| 5     | RNI/            |     |       |
| ----- | --------------- | --- | ----- |
| 15-6  | RNI/  Reserved  |     |       |
| 06    | Status          |     | 23·3  |
| 8-0   | Reserved        |     |       |
RNI/
| 10-9   | RNI/  Hardwired to select medium device select timing  |     |       |
| ------ | ------------------------------------------------------ | --- | ----- |
| 15-11  | RNI/  Reserved                                         |     |       |
| 08     | Class Code                                             |     | 23·3  |
31-0  R  Hardwired to indicate VGA-compatible display controller and
revision level
| 10  | Base Address 0  |     | 23·4  |
| --- | --------------- | --- | ----- |
0  RNI/  Hardwired to indicate base registers map into memory space
2-1  RNI/  Hardwired to allow mapping anywhere in 32-bit address s[:lace
3  RNI/  Hardwired to indicate does not meet prefetchable requirements
| 22-4   | RNI/  Reserved                                 |     |       |
| ------ | ---------------------------------------------- | --- | ----- |
| 31-23  | RNI/  Base address 0                           |     |       |
| 30     | BIOS Base Address                              |     | 23·5  |
| 0      | RNI/  Enable access to BIOS ROM address space  |     |       |
| 15-1   | RNI/  Reserved                                 |     |       |
| 31-16  | RNI/  Upper 16 bits of BIOS ROM address        |     |       |
| 3C     | Interrupt Line                                 |     | 23·3  |
| 7-0    | RNI/  Interrupt line routing information       |     |       |
| 3D     | Interrupt Pin                                  |     | 23·6  |
| 7-0    | R  Hardwired to specify use of INTA            |     |       |
A-30 REGISTER REFERENCE

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
Index
| 1-cycle EDO              | 7-9  |        | clock generator      |     |        |
| ------------------------ | ---- | ------ | -------------------- | --- | ------ |
| 32 bits/pixel operation  |      | 20-18  | DC specifications    |     | 4-1    |
|                          |      |        | frequency synthesis  |     | 9-1    |
| A                        |      |        | new DCLK PLL load    |     | 16-17  |
new MCLK and DCLK PLL load  16-18
| address latch delay  |     | 19-6  | new MCLK PLL load  |     | 16-17  |
| -------------------- | --- | ----- | ------------------ | --- | ------ |
axial step constant  15-9  color compare  15-2,15-8,20-13,20-18
| axial step constant  |     | 20-5   | VGA                | 16-38, 16-42  |       |
| -------------------- | --- | ------ | ------------------ | ------------- | ----- |
|                      |     |        | color depth (bpp)  |               | 19-1  |
| B                    |     |        | color keying       | 10-8,21-2     |       |
|                      |     |        | enable             | 21-2          |       |
| background color     |     | 20-11  | in KRGB mode       |               | 21-2  |
background/foreground mix  15-2,15-4,15-9- color mode select  16-12
15-14,15-16 -15-22,20-13  color space conversion  10-4 -10-5
|                        |     |       | configuration space      |           | 6-1   |
| ---------------------- | --- | ----- | ------------------------ | --------- | ----- |
| big endian addressing  |     | 15-6  |                          |           |       |
| BIOS                   |     |       | configuration strapping  |           | 17-8  |
| See video BIOS         |     |       | at reset                 | 5-1, 5-3  |       |
BitBLT across the plane  15-18  unlocking access to registers  17-10
| BitBLTthrough the plane  |            | 15-17  | CPU base address    |        |        |
| ------------------------ | ---------- | ------ | ------------------- | ------ | ------ |
| bits/pixel               |            |        | enable              | 17-3   |        |
| See color depth          |            |        | specify             | 19-14  |        |
| blank/border select      |            | 17-5   | current X position  |        | 20-4   |
| blending                 | 10-7,21-5  |        | current Y position  |        | 20-4   |
| byte mode addressing     |            | 16-33  | cursor              |        |        |
| byte swap                | 20-9       |        | end  16-27          |        |        |
|                          |            |        | location address    |        | 16-28  |
c
start  16-27
|     |     |     | cursor location address  |     | 16-28  |
| --- | --- | --- | ------------------------ | --- | ------ |
CAS
o
| stretch ti me    |             | 7-5, 19-13      |                        |             |                   |
| ---------------- | ----------- | --------------- | ---------------------- | ----------- | ----------------- |
| CFLEVEL status   |             | 22-3            |                        |             |                   |
| character clock  |             |                 | DCLK                   |             |                   |
| dot clocks per   |             | 16-6            | control                | 9-3         |                   |
| chip ID          | 17-1 -17-2  |                 | halving                | 16-6,16-17  |                   |
| chip wakeup      | 13-1        |                 | invert                 | 16-18       |                   |
| chroma keying    |             | 10-8,21-2,21-4  | inverted               | 17-5        |                   |
| enable           | 21-2        |                 | loading new frequency  |             | 9-2,16-17 -16-18  |
clipping  15-8,20-15 -20-16, 20-18  programming  9-2,16-14 -16-15
|     |     |     | decimation                | 11-10,22-12  |        |
| --- | --- | --- | ------------------------- | ------------ | ------ |
|     |     |     | destination base address  |              | 20-17  |
INDEX  1-1

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
destination X position  20-5  destination base address  20-17
| destination Y position  |     | 20-5  |     | destination X position  |     | 20-5  |     |
| ----------------------- | --- | ----- | --- | ----------------------- | --- | ----- | --- |
| DEVSEL timing           |     | 6-1   |     | destination Y position  |     | 20-5  |     |
diagonal step constant  15-9,20-5  Oiagonal step constant  20-5
| digitizer interface     |       | 11-7          |        | drawing commands         |            | 20-8   |     |
| ----------------------- | ----- | ------------- | ------ | ------------------------ | ---------- | ------ | --- |
| display active status   |       | 16-3          |        | enable                   | 15-1,20-3  |        |     |
| display FIFO fetch      |       |               |        | enable 8 bpp or greater  |            | 17-11  |     |
| enable                  | 17-6  |               |        | foreground color         |            | 20-11  |     |
| specify start position  |       |               | 17-11  | line error term          |            | 20-6   |     |
| display memory          |       |               |        | major axis pixel count   |            | 20-6   |     |
| 2 MCLK writes           |       | 16-11,16-18   |        | memory mapping           |            | 17-3   |     |
| access control          |       | 7-11          |        | minor axis pixel count   |            | 20-15  |     |
| bus width select        |       | 19-13         |        | programming              |            | 15-7   |     |
| chip count limitation   |       | 7-1           |        | read mask                | 20-12      |        |     |
| configurations          |       | 7-1           |        | screen width             | 19-2       |        |     |
| functional timing       |       | 7-4,7-6 -7-7  |        | select mix register      |            | 20-17  |     |
| refresh                 | 7-4   |               |        | short stroke vector      |            | 20-10  |     |
refresh cycle control  7-4, 16-30  source base address  20-17
| size specification          |        | 5-1               |                | write mask                      | 20-12  |            |      |
| --------------------------- | ------ | ----------------- | -------------- | ------------------------------- | ------ | ---------- | ---- |
| display pitch               | 16-30  |                   |                | ESYNC  12-10,16-12              |        |            |      |
| display start address       |        | 19-14             |                | EVCLK  12-10,16-12,16-17        |        |            |      |
| doubleword mode addressing  |        |                   | 16-30 -16-31,  | EVIDEO  12-10                   |        |            |      |
| 17-3                        |        |                   |                | extended data out (EDO) memory  |        |            | 7-1  |
| drawing commands            |        | 15-9 -15-22,20-8  |                |                                 |        |            |      |
| drawing direction           |        | 20-8              |                | F                               |        |            |      |
| E                           |        |                   |                | fast page mode memory           |        | 7-1,16-11  |      |
feature connector
| EDO memory                    | 7-1  |            |        | AC timing               | 4-8                |        |     |
| ----------------------------- | ---- | ---------- | ------ | ----------------------- | ------------------ | ------ | --- |
| 1-cycle mode                  |      | 7-9        |        | enable                  | 3-8, 12-10, 16-12  |        |     |
| enable                        |      |            |        | interfaces              | 12-7               |        |     |
| chroma keying                 |      | 21-2       |        | LPB  12-10              |                    |        |     |
| color keying                  |      | 2h2        |        | pass-through            |                    | 12-10  |     |
| Enhanced mode                 |      | 20-3       |        | Trio64-type versus LPB  |                    | 16-12  |     |
| feature connector             |      | 16-12      |        | VAFC                    | 12-7               |        |     |
| hardware graphics cursor      |      |            | 18-3   | FIFO status             | 20-7               |        |     |
| linear addressing             |      | 19-6,20-3  |        | font selection          | 16-8               |        |     |
| LPB  22-1                     |      |            |        | foreground color        |                    | 20-11  |     |
| memory mapped I/O             |      |            | 19-3   | frame buffer            |                    |        |     |
| end horizontal blank          |      | 16-23      |        | See display memory      |                    |        |     |
| end horizontal sync position  |      |            | 16-24  |                         |                    |        |     |
| end vertical blank            |      | 16-32      |        | G                       |                    |        |     |
ENFEAT  16-12
| Enhanced mode              |                      |              |        | General Data bus     |            |        |     |
| -------------------------- | -------------------- | ------------ | ------ | -------------------- | ---------- | ------ | --- |
| axial step constant        |                      | 20-5         |        | BIOS ROM interface   |            | 12-2   |     |
| background color           |                      | 20-11        |        | general input port   |            | 16-50  |     |
| background/foreground mix  |                      |              | 20-13  | description          | 12-4       |        |     |
| clipping                   | 20-15 -20-16, 20-18  |              |        | enable               | 12-4,19-5  |        |     |
| color compare              |                      | 20-13,20-18  |        | general output port  |            |        |     |
| color depth                | 19-1                 |              |        | description          | 12-5       |        |     |
LPB  22-9
| command types       |     | 20-9  |     |     |     |     |     |
| ------------------- | --- | ----- | --- | --- | --- | --- | --- |
| current X position  |     | 20-4  |     |     |     |     |     |
| current Y position  |     | 20-4  |     |     |     |     |     |
1-2  INDEX

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| Graphics Engine           |     |     |             |     | FIFO overflow interrupt status  |        |     | 20-1  |
| ------------------------- | --- | --- | ----------- | --- | ------------------------------- | ------ | --- | ----- |
| accessing bitmap through  |     |     | 15-2, 15-4  |     | generation                      | 12-11  |     |       |
busy status  20-7  Graphics Engine busy interrupt status  20-1
| enable          | 20-3  |       |     |     | Graphics Engine interrupt enable  |     |     | 20-2   |
| --------------- | ----- | ----- | --- | --- | --------------------------------- | --- | --- | ------ |
| software reset  |       | 20-3  |     |     | LPB  22-5                         |     |     |        |
| green PC        |       |       |     |     | vertical retrace interrupt clear  |     |     | 16-29  |
HSYNCNSYNC control  12-4,16-13  vertical retrace interrupt enable  16-29, 20-1 -
20-2
| H                         |       |               |       |             | vertical retrace interrupt status  |                 |            | 16-3  |
| ------------------------- | ----- | ------------- | ----- | ----------- | ---------------------------------- | --------------- | ---------- | ----- |
| hardware graphics cursor  |       |               |       |             | L                                  |                 |            |       |
| background color          |       | 18-4          |       |             |                                    |                 |            |       |
| enable                    | 18-3  |               |       |             | LCLK                               |                 |            |       |
| foreground color          |       | 18-4          |       |             | invert                             | 22-3            |            |       |
| pattern display x origin  |       |               | 18-5  |             | line compare                       | 16-34           |            |       |
| pattern display y origin  |       |               | 18-5  |             | line error term                    | 15-9,20-6       |            |       |
| programming               |       | 15-23 -15-24  |       |             | linear addressing                  |                 |            |       |
| storage start address     |       |               | 18-5  |             | enable                             | 15-1,19-6,20-3  |            |       |
| Windows/X-Windows modes   |       |               |       | 15-23,19-5  | explained                          | 15-1            |            |       |
| x origin                  | 18-3  |               |       |             | window position                    |                 | 19-7,23-4  |       |
| yorigin                   | 18-4  |               |       |             | window size                        |                 | 19-6       |       |
high speed text display  17-4  little endian addressing  15-6
| high speed text font writing     |             |        | 17-11  |        | Local Peripheral Bus     |              |             |     |
| -------------------------------- | ----------- | ------ | ------ | ------ | ------------------------ | ------------ | ----------- | --- |
| horizontal blank                 |             |        |        |        | See LBP                  |              |             |     |
| end  16-23                       |             |        |        |        | locking register access  |              |             |     |
| start                            | 16-23       |        |        |        | See unlocking            |              |             |     |
| horizontal display end           |             |        | 16-22  |        | LPB                      |              |             |     |
| horizontal sync                  |             |        |        |        | burst size               | 22-2         |             |     |
| control for power management     |             |        |        | 16-13  | clock source             |              | 22-3        |     |
| polarity                         | 16-2        |        |        |        | color byte swap          |              | 22-2        |     |
| horizontal sync position         |             |        |        |        | decimation               | 11-10,22-12  |             |     |
| end  16-24                       |             |        |        |        | digitizer interface      |              | 11-7        |     |
| start                            | 16-24       |        |        |        | enable                   | 22-1         |             |     |
| horizontal total                 |             | 16-22  |        |        | frame buffer address     |              | 22-7        |     |
| HSYNC                            |             |        |        |        | general output port      |              | 22-9        |     |
| direction                        | 12-10       |        |        |        | input window size        |              | 22-11       |     |
| direction control                |             | 3-8    |        |        | interrupts               | 22-5         |             |     |
| skew by character clocks         |             |        | 16-24  |        | introduction             |              | 11-1        |     |
|                                  |             |        |        |        | line stride              | 22-13        |             |     |
|                                  |             |        |        |        | mode select              |              | 19-16,22-1  |     |
|                                  |             |        |        |        | output FIFO              | 22-4,22-14   |             |     |
| I square C                       |             |        |        |        | read/write registers     |              | 22-8        |     |
| See serial port                  |             |        |        |        | reset                    | 22-2         |             |     |
| 10, chip                         | 17-1 -17-2  |        |        |        | Scenic/MX2 interface     |              | 11-2        |     |
| image transfer across the plane  |             |        |        | 15-15  | skip frames              | 22-2         |             |     |
image transfer through the plane  15-13  sync polarity  22-2
| initialization  | 5-1  |     |     |     | video FIFO  | 22-3 -22-4  |     |     |
| --------------- | ---- | --- | --- | --- | ----------- | ----------- | --- | --- |
interlaced operation  17-12, 18-2  LUT write cycle control  16-19
interrupt
| enable                          | 12-11,17-4  |     |     |       |     |     |     |     |
| ------------------------------- | ----------- | --- | --- | ----- | --- | --- | --- | --- |
| FIFO empty interrupt enable     |             |     |     | 20-3  |     |     |     |     |
| FIFO empty interrupt status     |             |     |     | 20-1  |     |     |     |     |
| FIFO overflow interrupt enable  |             |     |     | 20-2  |     |     |     |     |
INDEX  1-3

| , . |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporated
| M                         |            |        |     | PCIBus                  |      |      |       |     |
| ------------------------- | ---------- | ------ | --- | ----------------------- | ---- | ---- | ----- | --- |
|                           |            |        |     | BIOS ROM access enable  |      |      | 23-5  |     |
| M parameter               | 7-11,19-4  |        |     | BIOS ROM base address   |      |      | 23-5  |     |
| See also PLL m parameter  |            |        |     | configuration           |      | 6-1  |       |     |
| major axis pixel count    |            | 20-6   |     | configuration space     |      | 6-1  |       |     |
| maximum scan line         |            | 16-26  |     | cycles                  | 6-1  |      |       |     |
| MCLK                      |            |        |     | device I.D.             | 6-1  |      |       |     |
| external output           |            | 16-17  |     | DEVSEL timing           |      | 6-1  |       |     |
loading new frequency  9-3,16-17 -16-18  disable read bursts  17-11
| programming            |     | 9-3,16-13 -16-14  |     | disconnection           |      | 6-1    |       |     |
| ---------------------- | --- | ----------------- | --- | ----------------------- | ---- | ------ | ----- | --- |
| mechanical dimensions  |     | 2-1               |     | enable disconnect       |      | 19-11  |       |     |
| memory                 |     |                   |     | enable I/O accesses     |      | 23-2   |       |     |
| See display memory     |     |                   |     | enable memory accesses  |      |        | 23-2  |     |
| memory mapped I/O      |     |                   |     | interface               | 6-1  |        |       |     |
at B7000H window  15-5  linear addressing base address  23-4
described  15-4  master abort handling during DAC cycles  8-3,
| enable                  | 19-3  |        |     | 17-6                              |             |            |     |            |
| ----------------------- | ----- | ------ | --- | --------------------------------- | ----------- | ---------- | --- | ---------- |
| MMIO only select        |       | 16-10  |     | parity  6-5                       |             |            |     |            |
| new                     | 15-6  |        |     | retry handling during DAC cycles  |             |            |     | 8-3, 17-6  |
| packed registers        |       | 15-5   |     | vendor I.D.                       | 6-1         |            |     |            |
| memory mapping          |       |        |     | pin 50 function select            |             | 16-11      |     |            |
| EnhancedNGA modes       |       | 17-3   |     | pin descriptions                  |             | 3-4 -3-10  |     |            |
| minor axis pixel count  |       | 20-15  |     | pin list                          |             |            |     |            |
| MMIO                    |       |        |     | alphabetical                      | 3-12 -3-14  |            |     |            |
| See memory mapped I/O   |       |        |     | numerical                         | 3-15 -3-17  |            |     |            |
pinout
| N                         |       |     |     | PCI  3-2         |      |                   |     |     |
| ------------------------- | ----- | --- | --- | ---------------- | ---- | ----------------- | --- | --- |
|                           |       |     |     | VL-Bus           | 3-3  |                   |     |     |
| n parameter               | 19-9  |     |     | pitch  16-30     |      |                   |     |     |
| See also PLL n parameter  |       |     |     | PLL M parameter  |      | 9-1,16-14 -16-15  |     |     |
| nibble swap               | 19-4  |     |     | PLL N parameter  |      | 9-1,16-13 -16-14  |     |     |
|                           |       |     |     | PLL R parameter  |      | 9-1,16-13 -16-14  |     |     |
o
power management
|                |      |            |     | HSYNC control                    |       | 12-4,16-13  |        |        |
| -------------- | ---- | ---------- | --- | -------------------------------- | ----- | ----------- | ------ | ------ |
| OE             |      |            |     | VSYNC control                    |       | 12-4,16-13  |        |        |
| control        | 3-7  |            |     | programming                      | 15-7  |             |        |        |
| stretch time   |      | 7-5,19-13  |     | programming examples             |       |             |        |        |
| offset  16-30  |      |            |     | BitBLT across the plane          |       |             | 15-18  |        |
|                |      |            |     | BitBLTthroughtheplane            |       |             | 15-17  |        |
| p              |      |            |     | hardware cursor                  |       | 15-23       |        |        |
|                |      |            |     | image transfer across the plane  |       |             |        | 15-15  |
packed registers for MMIO  15-5  image transfer through the plane  15-13
palette registers  16-44  pattern fill across the plane  15-21
| lock access                     |                      | 17-5  |        | pattern fill through the plane  |       |        |        | 15-20  |
| ------------------------------- | -------------------- | ----- | ------ | ------------------------------- | ----- | ------ | ------ | ------ |
| panning                         | 16-26, 16-45, 16-47  |       |        | rectangle fill solid            |       | 15-12  |        |        |
| parity  6-5                     |                      |       |        | short stroke vectors            |       |        | 15-22  |        |
| pass-through                    | 11-10                |       |        | solid line                      | 15-9  |        |        |        |
| pass-through feature connector  |                      |       | 12-10  | textured line                   |       | 15-10  |        |        |
PatBLT
See pattern fill
fi"
| pattern                         | 20-9  |     |        |     |     |     |     |     |
| ------------------------------- | ----- | --- | ------ | --- | --- | --- | --- | --- |
| pattern fill across the plane   |       |     | 15-21  |     |     |     |     |     |
| pattern fill through the plane  |       |     | 15-20  |     |     |     |     |     |
1-4  INDEX

Trio64V+ Integrated Graphics/Video Accelerator
53 Incorporated
| Q   |     |     |     | source base address  |     | 20-17  |     |
| --- | --- | --- | --- | -------------------- | --- | ------ | --- |
SRDY
| quadword mode addressing  |               |           | 16-30            | delay assertion                 |            | 18-1             |             |
| ------------------------- | ------------- | --------- | ---------------- | ------------------------------- | ---------- | ---------------- | ----------- |
|                           |               |           |                  | generation                      | 6-6        |                  |             |
| R                         |               |           |                  | start address                   | 16-28      |                  |             |
|                           |               |           |                  | start horizontal blank          |            | 16-23            |             |
| R parameter               |               |           |                  | start horizontal sync position  |            |                  | 16-24       |
| See PLL R parameter       |               |           |                  | start vertical blank            |            | 16-31            |             |
| RAMDAC                    |               |           |                  | stepping information            |            | 17-1 -17-2       |             |
| AC specifications         |               | 4-3       |                  | strapping, configuration        |            |                  | 5-1         |
| access                    | 16-49 -16-51  |           |                  | streams processor               |            |                  |             |
| accessing                 | 8-3           |           |                  | blending                        | 10-7,21-5  |                  |             |
| bus snooping              |               | 8-3       |                  | chroma keying                   |            | 21-4             |             |
|                           |               |           |                  | color space conversion          |            |                  | 10-4 -10-5  |
| clock doubled operation   |               |           | 8-2,16-15,16-20  |                                 |            |                  |             |
| color mode select         |               | 19-12     |                  | color/chroma keying             |            |                  | 10-8,21-2   |
| color modes               |               | 8-1 -8-2  |                  | compose modes                   |            | 10-5,21-5        |             |
| DC characteristics        |               | 4-1       |                  | double buffering                |            | 10-2,21-6 -21-7  |             |
| DC specifications         |               | 4-1       |                  | FIFO control                    |            | 10-8,21-13       |             |
| lock writes               | 17-5          |           |                  | filter characteristics          |            |                  | 21-1,21-3   |
| LUT write cycle control   |               |           | 16-19            | filter constants                |            | 21-4             |             |
| PCI bus snooping          |               | 17-6      |                  | input data formats              |            |                  | 21-1,21-3   |
| power down                |               | 16-19     |                  | introduction                    |            | 10-1             |             |
| sense generation          |               | 8-3       |                  | mode select                     |            | 19-12            |             |
| RAS                       |               |           |                  | opaque overlay                  |            | 10-6,21-10       |             |
low time select  7-5,19-13,21-14  primary stream input  10-2
precharge time select  7-5,21-14  primary stream stride  21-7
| RAS1 function    | 3-7,7-2     |     |     | primary stream window    |             |     | 21-14  |
| ---------------- | ----------- | --- | --- | ------------------------ | ----------- | --- | ------ |
| RDYIN  6-6 -6-8  |             |     |     | scaling                  | 10-4,21-12  |     |        |
| read mask        | 15-4,20-12  |     |     | secondary stream input   |             |     | 10-2   |
| real mode        | 15-1        |     |     | secondary stream stride  |             |     | 21-10  |
rectangle fill solid drawing  15-12  secondary stream window  21-15
| refresh, DRAM    | 7-4,7-11,16-30,17-10  |       |     | STWR               |     |        |     |
| ---------------- | --------------------- | ----- | --- | ------------------ | --- | ------ | --- |
| reset            |                       |       |     | function select    |     | 16-17  |     |
| Graphics Engine  |                       | 20-3  |     | super VGA support  |     | 14-2   |     |
LPB  22-2
| system           | 5-1  |             |     | T                      |      |     |        |
| ---------------- | ---- | ----------- | --- | ---------------------- | ---- | --- | ------ |
| revision status  |      | 17-1 -17-2  |     |                        |      |     |        |
| row scan count   |      | 16-26       |     | test load, AC          | 4-3  |     |        |
|                  |      |             |     | textured line drawing  |      |     | 15-10  |
s
tri-state off
|                 |     |       |     | HSYNC     | 19-5   |     |     |
| --------------- | --- | ----- | --- | --------- | ------ | --- | --- |
| scaling  10-4   |     |       |     | PA[15:0)  | 19-11  |     |     |
| Scenic Highway  |     | 11-1  |     | PO lines  | 16-11  |     |     |
VCLK  19-5
| screen off    | 16-7  |     |     |         |       |     |     |
| ------------- | ----- | --- | --- | ------- | ----- | --- | --- |
| screen width  | 19-2  |     |     | VSYNC   | 19-5  |     |     |
| SENSE         |       |     |     | Trio64  |       |     |     |
status of internal signal  16-3  compatible mode select  19-16
| serial port          | 11-7         |              |     | two page screen  |     | 17-3  |     |
| -------------------- | ------------ | ------------ | --- | ---------------- | --- | ----- | --- |
| add wait states      |              | 22-6         |     |                  |     |       |     |
| I/O address select   |              | 19-16        |     |                  |     |       |     |
| register             | 22-9 -22-10  |              |     |                  |     |       |     |
| short stroke vector  |              | 15-22,20-10  |     |                  |     |       |     |
| solid line drawing   |              | 15-9         |     |                  |     |       |     |
INDEX  1-5

Trio64V+ Integrated Graphics/Video Accelerator
S3 Incorporatad
u
write latching delay  6-6
VLKLI  16-11
| underline location  | 16-31  |     | VSYNC      |        |
| ------------------- | ------ | --- | ---------- | ------ |
| unlocking           |        |     | direction  | 12-10  |
configuration strapping registers  17-10  direction control  3-8
| Enhanced registers                  | 18-1   |        |                     |       |
| ----------------------------------- | ------ | ------ | ------------------- | ----- |
| extended sequencer registers        |        | 16-10  | w                   |       |
| pseudocode for                      | 13-2   |        |                     |       |
| S3 VGA registers                    | 17-10  |        | wait state control  | 18-1  |
| system control/extension registers  |        | 17-10  | wakeup              | 13-1  |
WE
| v   |     |     | delay       | 19-17  |
| --- | --- | --- | ----------- | ------ |
|     |     |     | delay time  | 7-5    |
VAFC feature connector  12-7,16-12  word mode addressing  16-30,16-33
| Trio64-compatible  | 7-1 -7-2  |     | write mask  | 15-2,15-8,20-12  |
| ------------------ | --------- | --- | ----------- | ---------------- |
VCLK
x
| direction  12-10, 16-17     |       |        |            |              |
| --------------------------- | ----- | ------ | ---------- | ------------ |
| inversion of DCLK           | 17-5  |        |            |              |
| phase with respect to DCLK  |       | 19-12  | X-Windows  | 15-23, 19-5  |
VCLKI  3-8, 16-11
vertical blank
end  16-32
start  16-31
| vertical display end  | 16-30  |     |     |     |
| --------------------- | ------ | --- | --- | --- |
vertical retrace
| enable interrupt  | 16-29  |     |     |     |
| ----------------- | ------ | --- | --- | --- |
end  16-29
start  16-29
vertical sync
| active status                 | 16-3        |        |     |     |
| ----------------------------- | ----------- | ------ | --- | --- |
| control for power management  |             | 16-13  |     |     |
| polarity  16-2                |             |        |     |     |
| vertical total  16-25         |             |        |     |     |
| VGAcompatibility              | 14-1,16-1   |        |     |     |
| VGA graphics mode select      | 16-45       |        |     |     |
| VGA memory bus width          | 17-3        |        |     |     |
| VGA memory mapping            | 17-3 -17-4  |        |     |     |
video BIOS
| access enable (PCI)     | 12-1,23-5   |     |     |     |
| ----------------------- | ----------- | --- | --- | --- |
| base address (PCI)      | 12-4, 23-5  |     |     |     |
| enable access           | 12-1        |     |     |     |
| read functional timing  | 12-2        |     |     |     |
| ROM interface           | 12-1        |     |     |     |
| size selection          | 12-4        |     |     |     |
| video display enable    | 16-43       |     |     |     |
VL-Bus
| address latch delay      | 6-7 -6-8, 19-6  |               |     |     |
| ------------------------ | --------------- | ------------- | --- | --- |
| cycles  6-6              |                 |               |     |     |
| delay assertion of SRDY  |                 | 6-6,6-8,18-1  |     |     |
| interface  6-6           |                 |               |     |     |
| RDYIN  6-7 -6-8          |                 |               |     |     |
| RDYIN input              | 6-6             |               |     |     |
| SRDY generation          | 6-6             |               |     |     |
1-6  INDEX

53 Incorporated
2770 San Tomas Expwy.
Santa Clara, CA 95051-0968
Tel: (408) 980-5400
Fax: (408) 980-5444
Printed in U.S.A. on recycled paper
DB018·A
