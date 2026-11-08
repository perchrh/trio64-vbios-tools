86CM65 Dual Display Accelerator
83 Incorporated
86CM65
Aurora64V+
Dual Display
Accelerator
February 1996
S3 Incorporated
P.O. Box 58058
Santa Clara, CA 95052-8058

86CM65 Dual Display Accelerator
S3 Incorponted
NOTATIONAL CONVENTIONS
The following notational conventions are used in this data book:
Signal names are shown in all uppercase letters. For exall)ple, XD.
A bar over a signal name indicatas an active low signal. For example, OE.
n-lll indicates a bit field from bit n to bit m. For example, 7-0 specifies bits 7 through 0, inclusive.
n:m indicates a signal (pin) range from n to m. For example 0[7:0] specifies data lines 7 through 0, inclusive
Use of a treiling letter H indicates a hexadecimal number. For example, 7AH is a hexadecimal number.
Use of a trailing lettar b indicates a binary number. For example, 010b is a binary number.
When numerical modifiers such as K or M are used, they refer to binary rather than decimal form. Thus, for example, 1 KByte would be
equivalent to 1024, not 1.000 bytes.
NOTICES
IC Copyright 1995, 199653 Incorporated. All rights reserved. If you have received this document from S3 Incorporated in electric form,
you are permitted to make the following copies for business use related to products of S3 Incorporated: one copy onto your computer
for the purpose of on-line viewing, and one printed copy. With respect to ell documents, whether received in hard copy or electronic
form, other use, copying or storage, in whole or in part, by any means electronic, mechanical, photocopying or otherwise, is permitted
withoutthe prior written consentofS31ncorporated, P.O. Box 58058., Santa Clara CA95052-8058. 53 and True Acceleration are registered
trademarks of 53 Incorporated. The 53 Corporate Logo, S3 on Board, S3 on Board design, S3d design, Vision96B, Trio, Trio64, Trio64V+,
Trio64UV+, ViRGE, ViRGEN><, S3d, Scenic, Scenic/MX1, Scenic/MX2, Scenic Highway, Sonic, Sonic/AD, Aurora64V+, DuoView, Coopera
tive Accelerator Architecture, Streams Processor, MIC, Galileo, Native-MPEG, No Compromise Integration, No Compromise Acceleration
and Innovations in Acceleration are trademarks of S3 Incorporated. Other trademarks referenced in this document are owned by their
respective companies. The material in this document Is for information only and is subject to change without notice. S3 Incorporated
reserves the right to make changes in the product design without reservation and without notice to its users.
Additional information may be obtained from:
S31ncorporated, Uterature Department P.O. Box 58058, Santa Clara, CA 95052-8058.
Telephone: 408-980'5400, Fax: 408·980-5444

86CM65 Dual Display Accelerator
Table of Contents
| List of Figures             |           | vi  Section 6: PCI Bus Interface ..•. 6-1  |                                  |              |      |
| --------------------------- | --------- | ------------------------------------------ | -------------------------------- | ------------ | ---- |
|                             |           | 6.1                                        | PCI CONFIGURATION                | ....... 6-1  |      |
|                             |           | 6.2                                        | PCI CONTROLS ........... 6-1     |              |      |
| List of Tables .            |           | vii                                        |                                  |              |      |
|                             |           | Section 7: Display Memory                  |                                  | . . • . 7-1  |      |
| Section 1: Introduction     |           | . 1-1                                      |                                  |              |      |
|                             |           | 7.1                                        | DISPLAY MEMORY                   |              |      |
|                             |           |                                            | CONFIGURATIONS. . . . . . . . .  |              | 7-1  |
| Section 2: Mechanical Data  | .... 2-1  |                                            |                                  |              |      |
|                             |           | 7.2                                        | DISPLAY MEMORY REFRESH           | . . .        | 7-2  |
2.1  THERMAL SPECIFICATIONS. . .. 2-1  7.3  DISPLAY MEMORY FUNCTIONAL
2.2  MECHANICAL DIMENSIONS  .•. 2-1  TIMING  ............... 7-2
|                                             |                 | 7.4  | DISPLAY MEMORY ACCESS            |     |       |
| ------------------------------------------- | --------------- | ---- | -------------------------------- | --- | ----- |
|                                             |                 |      | CONTROL. . . . . . . . . . . ..  |     | 7-10  |
| Section 3: Pins  • . . . . . . . . . . 3-1  |                 |      |                                  |     |       |
| 3.1  PINOUT DIAGRAMS                        | . . . . . . .•  | 3-1  |                                  |     |       |
Section 8: Clock Synthesis and
| 3.2  PIN DESCRIPTIONS  | .......• 3-3  |     |     |     |     |
| ---------------------- | ------------- | --- | --- | --- | --- |
3.3  PIN LISTS. . . . . . . . . . . . .. 3-8
|     |     | Control  | ............... 8-1            |     |     |
| --- | --- | -------- | ------------------------------ | --- | --- |
|     |     | 8.1      | CLOCK SYNTHESIS ......... 8-1  |     |     |
Section 4: Electrical Data  ..... 4-1  8.2  CLOCK REPROGRAMMING  .... 8-2
4.1  MAXIMUM RATINGS  ......• 4-1  8.3  CLOCK SELECTION AND CONTROL  8-3
| 4.2  DC SPECIFICATIONS. . . . . . .•  |     | 4-1  |     |     |     |
| ------------------------------------- | --- | ---- | --- | --- | --- |
4.3  AC SPECIFICATIONS . . . . . . .. 4-3  Section 9: Streams Processor .•. 9-1
4.3.1  RAMDAC AC Specifications  .. 4-3  9.1  INPUT STREAMS .•........ 9-1
| 4.3.2  Clock Timing         | • • . . . . . . . .  | 4-4    |                                  |     |      |
| --------------------------- | -------------------- | ------ | -------------------------------- | --- | ---- |
|                             |                      | 9.1.1  | Primary Stream Input. . . . . .  |     | 9-2  |
| 4.3.3  Input/Output Timing  | . . . . .. 4-5       |        |                                  |     |      |
|                             |                      | 9.1.2  | Secondary Stream Input . . . .   |     | 9-2  |
9.1.3  Hardware Icon and Cursor
|     |     |     | Generation  ........... 9-2  |     |     |
| --- | --- | --- | ---------------------------- | --- | --- |
Section 5: Reset and Power
9.1.4  Frame Buffer Organization/
Control  .••...•........ 5-1
|                               |     |          | Double Buffering  | . . . . . . . .  | 9-2  |
| ----------------------------- | --- | -------- | ----------------- | ---------------- | ---- |
| 5.1  CONFIGURATION STRAPPING  |     | ..  5-1  |                   |                  |      |
|                               |     | 9.2      | INPUT PROCESSING  | ........ 9-4     |      |
5.2  BOUNDARY SCAN. . . . . . . .. 5-1
|     |     | 9.2.1  | Primary Stream Processing  |     | .. 9-4  |
| --- | --- | ------ | -------------------------- | --- | ------- |
5.3  FLAT PANEL POWER SEQUENCING 5-4
|     |     | 9.2.2  | Secondary Stream Processing.  |     | 9-5  |
| --- | --- | ------ | ----------------------------- | --- | ---- |
5.4  POWER MANAGEMENT . . . . .•  5-4  9.3  COMPOSiTION/OUTPUT......  9-5
5.4.1  Normal Mode • . . . . . . . .. 5-4
9.3.1  Opaque Rectangular Overlaying 9-6
| 5.4.2  Standby Mode  | .. . . . . . ..  | 5-4  |     |     |     |
| -------------------- | ---------------- | ---- | --- | --- | --- |
9.3.2  Blending............. 9-7
5.4.3  Suspend Mode . . . . . . . .. 5-6
|     |     | 9.3.3  | Color/Chroma Keying. . . . . .  |     | 9-8  |
| --- | --- | ------ | ------------------------------- | --- | ---- |
5.5  MIXED 3.3 VOLT AND 5 VOLT
|     |     | 9.3.4  | Window Location . • . . . . . .  |     | 9-8  |
| --- | --- | ------ | -------------------------------- | --- | ---- |
OPERATION ............. 5-6
|                                      |     | 9.4  | STREAMS FIFO CONTROL . . . . .  |     | 9-8  |
| ------------------------------------ | --- | ---- | ------------------------------- | --- | ---- |
| 5.6  GREEN PC SUPPORT. . . . . . ..  |     | 5-7  |                                 |     |      |
iii

86CM65 Dual Display Accelerator
S3 Incorpomed
Section 10: CRT/TV Interface  .• 10-1  12.2.2  SAA7110 Video Input. . • ..  12-7
10.1  CRT OUTPUT •....••..... 10-1  12.3  HOST PASS-THROUGH  .....  12-8
|     |                                        |                  |            | 12.4                       | ZV PORT INTERFACE. • . . . ..  |     | 12-9  |
| --- | -------------------------------------- | ---------------- | ---------- | -------------------------- | ------------------------------ | --- | ----- |
|     | 10.1.1  Operating Modes ........ 10-1  |                  |            |                            |                                |     |       |
|     | 10.1.2  Color Modes                    | •......... 10-2  |            |                            |                                |     |       |
|     | 10.1.2.1 8 Bits/Pixel -Mode 0          |                  | ..•. 10-2  | Section 13: Miscellaneous  |                                |     |       |
10.1.2.2 Output-doubled 8 Bits/Pixel -
|     |     |     |     | Functions • • . . . . . . • .  |     |     | 13-1  |
| --- | --- | --- | --- | ------------------------------ | --- | --- | ----- |
Mode 8 ..•.•...•... 10-2
|     |     |     |     | 13.1  | VIDEO BIOS ROM INTERFACE..  |     | 13-1  |
| --- | --- | --- | --- | ----- | --------------------------- | --- | ----- |
10.1.2.3 15/16-Bits/Pixel -Modes 9
|     |         |                    |     | 13.2  | GENERAL INPUT PORT. . . . .•  |         | 13-1  |
| --- | ------- | ------------------ | --- | ----- | ----------------------------- | ------- | ----- |
|     | and 10  | •........... 10-3  |     |       |                               |         |       |
|     |         |                    |     | 13.3  | GENERAL OUTPUT PORT           | . . .•  | 13-2  |
10.1.2.4 Packed 24 Bits/Pixel-Mode 121Q-3
13.4  SERIAL COMMUNICATIONS PORT 13-2
|       | 10.1.2.5 24 Bits/Pixel -Mode 13  |               | .•. 10-3  |                             |                             |     |       |
| ----- | -------------------------------- | ------------- | --------- | --------------------------- | --------------------------- | --- | ----- |
|       |                                  |               |           | 13.5                        | INTERRUPT GENERATION. • •.  |     | 13-2  |
| 10.2  | RAMDAC REGISTER ACCESS           |               | .•. 10-3  |                             |                             |     |       |
| 10.3  | RAMDAC SNOOPING                  | .....•. 10-3  |           |                             |                             |     |       |
| 10.4  | SENSE GENERATION                 | ....... 10-3  |           | Section 14: Basic Software  |                             |     |       |
10.5  TV OUTPUT ...•.•....... 10-3  Functions  •...•...•  14-1
|                                     |     |     |       | 14.1  | CHIP WAKEUP                         | ..•.•.....  | 14-1     |
| ----------------------------------- | --- | --- | ----- | ----- | ----------------------------------- | ----------- | -------- |
| Section 11: Flat Panel Interface .  |     |     | 11-1  | 14.2  | REGISTER ACCESS                     |             |          |
|                                     |     |     |       |       | 14.2.1  Unlocking the S3 Registers  |             | .  14-1  |
11.1  STN PANEL SUPPORT ...••.• 11-1
|     |                              |     |              |     | 14.2.2  Locking the S3 Registers . ..  |     | 14-3  |
| --- | ---------------------------- | --- | ------------ | --- | -------------------------------------- | --- | ----- |
|     | 11.1.1  STN Panel Selection  |     | ..•... 11-1  |     |                                        |     |       |
11.1.2  STN Panel Timing  ....... 11-1  14.3  TESTING FOR THE PRESENCE OF
11.1.3  STN Panel Control  .....•. 11-1  AN 86CM65 CHIP . . . . . . . .•  14-3
11.1.4  STN Frame Rate Control .•.. 11-3  14.4  GRAPHICS MODE SETUP  ..•.  14-3
|     | 11.1.5  STN Panel Dithering         |     | . . . . . . 11-3  |                                |     |     |     |
| --- | ----------------------------------- | --- | ----------------- | ------------------------------ | --- | --- | --- |
|     | 11.1.6  Dual-Scan STN Frame Buffer  |     | .11-6             | Section 15: VGA Compatibility  |     |     |     |
11.2  TFT PANEL SUPPORT  ....... 11-9  Support  ............  15-1
|       | 11.2.1  TFT Panel Selection             |                 | ••.... 11-9  |                            |                                |                  |       |
| ----- | --------------------------------------- | --------------- | ------------ | -------------------------- | ------------------------------ | ---------------- | ----- |
|       |                                         |                 |              | 15.1                       | VGA COMPATIBILITY. . . . . ..  |                  | 15-1  |
|       | 11.2.2  TFT Panel Timing .....•.. 11~9  |                 |              |                            |                                |                  |       |
|       |                                         |                 |              | 15.2                       | VESA SUPER VGA SUPPORT         |                  | 15-2  |
|       | 11.2.3  TFT Panel Control               | ....... 11-9    |              |                            |                                |                  |       |
|       | 11.2.4  TFT Panel Dithering             |                 | ...•. 11-11  |                            |                                |                  |       |
| 11.3  | FLAT PANEL DISPLAY                      |                 |              | Section 16: Enhanced Mode  |                                |                  |       |
|       | ENHANCEMENTS                            | ........ 11-11  |              | Programming                |                                | .......... 16-1  |       |
11.3.1  Automatic Centering . . . . .  11-11  16.1  LINEAR ADDRESSING FOR DIRECT
11.3.2  Horizontal Compensation  .. 11-11  VIDEO MEMORY CPU ACCESSES  16-1
|     | 11.3.3  Vertical Compensation .... 11-11  |     |     |     |     |     |     |
| --- | ----------------------------------------- | --- | --- | --- | --- | --- | --- |
16.2  VIDEO MEMORY ACCESS
|     | 11.3.4  Pulse Width Modulation •.. 11-11  |     |     |     |     |     |     |
| --- | ----------------------------------------- | --- | --- | --- | --- | --- | --- |
THROUGH THE GRAPHICS ENGINE 16-2
|     | 11.3.5  Blinking ............ 11-12  |     |     |     |     |     |     |
| --- | ------------------------------------ | --- | --- | --- | --- | --- | --- |
16.3  MEMORY MAPPING OF
11.4  DuoView DISPLAY •......• 11-12  REGISTERS  • . . . . . . . • . ..  16-4
11.4.1  DuoView Display Setup  ... 11-12  16.3.1  Backward-Compatible MMIO  16-4
11.4.2  DuoView Programming  ... 11-14  16.3.2  New MMIO  . . • . . . . . ..  16-6
|     | 11.4.3  DuoView Programming  |     |     |       |              |                   |       |
| --- | ---------------------------- | --- | --- | ----- | ------------ | ----------------- | ----- |
|     |                              |     |     | 16.4  | PROGRAMMING  | . . . . . . . ..  | 16-7  |
Example ...........• 11-14
|     |     |     |     |     | 16.4.1  Notational Conventions            | ...  | 16-7  |
| --- | --- | --- | --- | --- | ----------------------------------------- | ---- | ----- |
|     |     |     |     |     | 16.4.2  Initial Setup . . . . . . . . ..  |      | 16-8  |
Section 12: Local Peripheral Bus  12-1  16.4.3  Programming Examples  . ..  16-8
|     |     |     |     |     | 16.4.3.1 Solid Line  | ......... 16-9  |     |
| --- | --- | --- | --- | --- | -------------------- | --------------- | --- |
12.1  SceniC/MX2INTERFACE .....• 12-1
|     |                                     |     |     |     | 16.4.3.2 Textured Line         | ....... 16-10  |     |
| --- | ----------------------------------- | --- | --- | --- | ------------------------------ | -------------- | --- |
|     | 12.1.1  SceniC/MX2 Register/Memory  |     |     |     |                                |                |     |
|     |                                     |     |     |     | 16.4.3.3 Rectangle Fill Solid  | .... 16-12     |     |
Access .............. 12-2
12.1.2  SceniC/MX2 Compressed Data  16.4.3.4 Image Transfer-Through
|     | Transfer ......•...... 12-4       |     |          |     | the Plane .......... 16-13      |     |     |
| --- | --------------------------------- | --- | -------- | --- | ------------------------------- | --- | --- |
|     | 12.1.3  SceniC/MX2 Video Capture  |     | .. 12-5  |     | 16.4.3.5 Image Transfer-Across  |     |     |
the Plane .......... 16-15
12.2  DIGITIZER INTERFACE ••..... 12-7
16.4.3.6 BitBLT-Throughthe Plane 16-17
|     | 12.2.1  12C Interface for SAA7110  |     | ., . 12-7  |     |     |     |     |
| --- | ---------------------------------- | --- | ---------- | --- | --- | --- | --- |
iv

86CM65 Dual Display Accelerator
53 Incorporated
|     | 16.4.3.7 BitBLT-Across the Plane.  |     | 16-18  | Section 22: Local Peripheral Bus  |     |     |     |
| --- | ---------------------------------- | --- | ------ | --------------------------------- | --- | --- | --- |
16.4.3.8 PatBLT-Pattern Fill
|     |                    |             |     | Register Descriptions  |     | ..•..• 22-1  |     |
| --- | ------------------ | ----------- | --- | ---------------------- | --- | ------------ | --- |
|     | Through the Plane  | .... 16-20  |     |                        |     |              |     |
16.4.3.9 PatBLT-Pattern Fill Across
|     | the Plane. . . . . . . . . .  |     | 16-21  | Section 23: PCI Register  |     |     |     |
| --- | ----------------------------- | --- | ------ | ------------------------- | --- | --- | --- |
16.4.3.10 Short Stroke Vectors ... 16-22  Descriptions  ..........• 23-1
16.4.3.11 Programmable Hardware
Cursor ..•......•. 16-23
16.4.3.12 Programmable Hardware  Appendix A: Register Reference  A-1
|       | Icon  ...•....•.•. 16-25  |     |        | A.1  | VGA REGISTERS. . . . . . . • . . . A-2  |                    |          |
| ----- | ------------------------- | --- | ------ | ---- | --------------------------------------- | ------------------ | -------- |
| 16.5  | RECOMMENDED READING       |     | 16-26  | A,2  | EXTENDED SEQUENCER                      |                    |          |
|       |                           |     |        |      | REGISTERS                               | ............ A-10  |          |
|       |                           |     |        | A.3  | EXTENDED CRTC REGISTERS                 |                    | .. A-21  |
Section 17: Standard VGA
A.4  ENHANCED COMMANDS
Register Descriptions  .•.... 17-1  REGISTERS  ............ A-30
| 17.1  | GENERAL REGISTERS  | ....•.. 17-1  |     | A,5  | STREAMS PROCESSOR  |     |     |
| ----- | ------------------ | ------------- | --- | ---- | ------------------ | --- | --- |
17.2  SEQUENCER REGISTERS  ..... 17-5  REGISTERS  ....•....... A-34
| 17.3  | CRT CONTROLLER REGISTERS      |     | .  17-10  | A,6  | LOCAL PERIPHERAL BUS     |                    |     |
| ----- | ----------------------------- | --- | --------- | ---- | ------------------------ | ------------------ | --- |
| 17.4  | GRAPHICS CONTROLLER           |     |           |      | REGISTERS                | ............ A-38  |     |
|       | REGISTERS •........... 17-25  |     |           | A.7  | PCI CONFIGURATION SPACE  |                    |     |
| 17.5  | ATIRIBUTE CONTROLLER          |     |           |      | REGISTERS                | .......•.... A-41  |     |
REGISTERS •..•..•..... 17-32
17.6  RAMDAC REGISTERS  •....•  Appendix B: Panel Programming
17-38
|     |     |     |     | Examples  | . • . • . . . . . . . ..  |     | B-1  |
| --- | --- | --- | --- | --------- | ------------------------- | --- | ---- |
Section 18: Extended Sequencer
Register Descriptions  ..••.• 18-1  Appendex C: Panel Attachment
18.1  MISCELLANEOUS EXTENDED
|       | SEQUENCER REGISTERS   | ..... 18-1  |     | Examples:.  |      |     | C-1    |
| ----- | --------------------- | ----------- | --- | ----------- | ---- | --- | ------ |
| 18.2  | FLAT PANEL REGISTERS  | .... 18-24  |     |             |      |     |        |
|       |                       |             |     | Index       | .•.  |     | • 1-1  |
Section 19: Extended CRTC
| Register Descriptions  |     | . . . • . .  | 19-1  |     |     |     |     |
| ---------------------- | --- | ------------ | ----- | --- | --- | --- | --- |
Section 20: Enhanced Commands
| Register Descriptions  |     | ...... 20-1  |     |     |     |     |     |
| ---------------------- | --- | ------------ | --- | --- | --- | --- | --- |
Section 21: Streams Processor
| Register Descriptions  |     | ..•... 21-1  |     |     |     |     |     |
| ---------------------- | --- | ------------ | --- | --- | --- | --- | --- |
v

••
r 86CM65 Dual Display Accelerator
S3 Incorporated
List of Figures
# Title Page # Title Page
1-1 System Block Diagram . . . . •. 1-2 11-9 Internal Data Paths ......• 11-13
2-1 256-pin BGA Mechanical 12-1 LPB Internal Block Diagram .. 12-1
Dimensions ••••......•. 2-2 12-2 86CM65 to Scenic/MX2 Interface 12-2
3-1 Aurora64V+ Pin Locations 12-3 Scenic/MX2 Write (SceniC/MX2
(Top View) ..••..•..... 3-2 Ready) . . . . . . . . . . . • .. 12-3
4-1 Clock Waveform Timing . • . .. 4-4 12-4 Scenic/MX2 Write (SceniC/MX2
4-2 Input Timing .•..••..... 4-5 Not Ready) ........... 12-3
4-3 Output Timing ....•..... 4-7 12-5 Scenic/MX2 Read (SceniC/MX2
4-4 Reset Timing . . . . . • . . • .. 4-9 Ready) . . . . . . . . . . . . .. 12-3
5-1 Flat Panel Power Sequencing .. 5-4 12-6 Scenic/MX2 Read (SceniC/MX2
7-1 256Kx16 DRAM Configurations 7-1 Not Ready) ......•.... 12-3
7-2 512Kx32 DRAM Configurations 7-2 12-7 Scenic/MX2 Compressed Transfer
7-3 Fast Page Mode Read Cycle . .. 7-3 (Ready) •.•....•.••.. 12-4
7-4 Fast Page Mode Write Cycle • .. 7-4 12-8 SceniC/MX2 Stopping a
7-5 Fast Page Write Following a Compressed Xfer . . . . • • .• 12-5
Read Cycle •.......... . 7-5 12-9 SceniC/MX2 VSYNC and
7-6 2-cycle EDO Mode Read Cycle .• 7-6 HSYNC Protocols . . . . . . •. 12-5
7-7 2-cycle EDO Write Following a 12-10 SceniC/MX2 Video Input (86CM65
Read Cycle ••.......... 7-7 Ready) . . . . • . . . . . . . .. 12-6
7-8 1-Cycle EDO Mode Read/Write 7-8 12-11 SceniC/MX2 Video Input (86CM65
7-9 1-cycle EDO Write Following a Not Ready . . • . . . . . . . •. 12-6
Read Cycle ............ 7-9 12-12 86CM65 to SAA7110 Digitizer
8-1 PLL Block Diagram . . . . . . .• 8-2 Interface . . . • . . . . . . . .. 12-7
8-2 Clock Selection . . . . . . . . .. 8-3 12-13 Video 81n or 16 Mode Input •• 12-8
9-1 Streams Processor . • • • . . •• 9-1 12-14 'Z)J Port Interface ........ 12-9
9-2 Screen Definition Parameters •. 9-5 13-1 General I/O Port Timing 13-1
10-1 Internal RAMDAC Block Diagram 10-1 16-1 Pixel Update Flowchart. . . •. 16-3
11-1 8-bit Color DD-STN Panel Timing 11-3
11-2 16-bit Color DD-STN Panel
Timing •..•..•••.•.... 11-4
11-3 24-bit Color DD-STN Panel
Timing .......•.....•. 11-5
11-4 8-bit Color SS-STN Panel Timing 11-6
11-5 16-bit Color SS-STN Panel
Timing •.•.•.••••.••.• 11-7
11-6 24-bit Color SS-STN Panel
Timing .......•••..... 11-8
11-7 TFT Panel Timing ...•.••.. 11-9
11-8 PWM Timing ..•..•.••. 11-12
vi

86CM65 Dual Display Accelerator
List of Tables
#
| Title  |     | Page  |     |
| ------ | --- | ----- | --- |
3-1  Pin Descriptions  3-3  10-2  TV Output Options  . . . . . ..  10-4
3-2  Alphabetical Pin Listing  3-8  11-1  STN Flat Panel Data Outputs ..  11-2
3-3  Numerical Pin Listing..  . ... 3-10  11-2  TFT Flat Panel Data Outputs  .. 11-10
4-1  Absolute Maximum Ratings ..  4-1  15-1  Standard VGA Registers Modified
4-2  RAMDAC/Clock Synthesizer DC  or Extended in the 86CM65  15-1
| Specifications. . . . . . . .  |     | 4-1  16-1  | Enhanced Registers Memory  |
| ------------------------------ | --- | ---------- | -------------------------- |
4-3  RAMDAC Characteristics. .  4-1  Mapping. . . . . . . . . . ..  16-5
4-4  Digital DC Specifications . .  4-2  16-2  New MMIO Addresses  . . ..  16-6
4-5  RAMDAC AC Specifications  4-3  A-1  VGA Registers  ........  . A-2
4-6  RAMDAC Output Specifications.  4-3  A-2  Extended Sequencer Registers  A-10
4-7  Clock Waveform Timing  . . . .. 4-4  A-3  Extended CRTC Registers  ... A-21
4-8  SCLK-Referenced Input Timing  4-5  A-4  Enhanced Commands Registers  A-30
4-9  CLK32-Referenced Input Timing.  4-5  A-5  Streams Processor Registers..  A-34
MCLK-Referenced Input Timing .  4-6  Local Peripheral Bus Registers.  A-38
| 4-10                                |     | A-6       |                          |
| ----------------------------------- | --- | --------- | ------------------------ |
| 4-11  LCLK-Referenced Input Timing  |     | 4-6  A-7  | PCI Configuration Space  |
4-12  SCLK-Referenced Output Timing  4-7  Registers. . . . . . . . . . . .. A-41
| 4-13  CLK32-Referenced Output Timing  |     | 4-7  |     |
| ------------------------------------- | --- | ---- | --- |
| 4-14  MCLK-Referenced Output Timing   |     | 4-8  |     |
| 4-15  LCLK-Referenced Output Timing   |     | 4-8  |     |
4-16  FPSCLK-Referenced Output
Timing •.........•••.. 4-8
| 4-17  Reset Timing  | .. . . . . • . • .. 4-9  |     |     |
| ------------------- | ------------------------ | --- | --- |
5-1  Definition of Strapping Bits at the
| Rising Edge of the Reset Signal  |     | 5-2  |     |
| -------------------------------- | --- | ---- | --- |
7-1  Memory Size/PD Bus Width
| Specification                      | ..........  | 7-2  |     |
| ---------------------------------- | ----------- | ---- | --- |
| 8-1  PLL R Parameter Decoding. ..  |             | 8-1  |     |
9=1  Register Fields Used For Specifying
Frame Buffer Organization and
| Double Buffering  | • . . . • . . .. 9-3  |     |     |
| ----------------- | --------------------- | --- | --- |
9=2  Register Fields Used For Scaling
| Up the Secondary Stream   | •            | 9-6  |     |
| ------------------------- | ------------ | ---- | --- |
| 10-1  86CM65 Color Modes  | •....• 10-2  |      |     |
vii

86CM65 Dual Display Accelerator
53 InoorporatH

86CM65 Dual Display Accelerator
Section 1: Introduction
High-Performance Graphics Accelerator Core Multimedia Acceleration
• Integrated 54-bit graphics accelerator • Integrated S3 Streams Processor en
JRAMDAClclock-synthesizer core en ables 30 frames-per-second. full-screen.
ables desktop-level performance 24-bit playback of full motion video
• Supports VGA. SVGA, and XGA flat • Mixed-format (simultaneous YUV and
panel displays RGB) data in video memory
• Provides 1280x1024x8-bit. 75 Hz refresh. • Blending of graphics and video streams
non-interlaced CRT mode of different color depths
• 3.3V/5Voperation • High-quality hardware scaling using fil
tered interpolation
Direct Interface to Broad Range of LCDs
• Color key/chroma key control of
graphic/video overlay placement
• Support for VGA, SVGA and XGA dual
scan/single-scan color panels with 8-bit.
Comprehensive Power Management
16-bit. and 24-bit interfaces
• Support for VGA, SVGA and XGA TFT • Self-refresh and slow-refresh DRAM sup-
color panels with 9-bit. 12-bit and18-bit port
(1 pixel/clock and 2 pixels/clock) inter
• Standby and low power suspend modes
faces
• Hardware and software suspend support
• Advanced frame rate control and dither
ing algorithms provide up to 16.7 mil • DPMS
lion colors • S3 Dynamic Power Management
• Panel data polarity switching for EMI re
64x64x2 Pixel Hardware Pop-up Icon
duction
• Auto-expansion and centering for VGA
• Available in all modes
text and graphics modes on SVGA and
XGApanels • 8 separate bitmaps can be stored
Integrated Programmable Frequency
Industry-Leading Simultaneous Display
Synthesizers
Capability
• Dual. independent frequency synthesiz
• CRT and flat panel refresh rates are inde
ers for DAC and memory control
pendently programmable to allow opti
mum image quality via DuoView • DCLK up to 110 MHz @ 3.3V. 135 MHz
architecture @5V
• Simultaneous TVlflat panel display • MCLK up to 50 MHz @ 3.3V
INTRODUCTION 1-1

86CM65 Dual Display Accelerator
S3 Incorporated
S3 Scenic Highway Video Bus For Low-Cost Monitor Plug and Play Support: VESAe DDC
Multimedia Solutions
256-pln PBGA Package
• ZV Port compliant
• 27.0 mm x 27.0 mm footprint
• Glueless 8-or 16-bit interface to video
digitizers • 1.27 mm ball pitch
• Glueless, bi-directional interface to S3
Scenic/MX2 MPEG decoder
The S3® 86CM65 Aurora64V+TM dual display ac
Integrated TV Encoder
celerator is the first in a series of highly-inte
grated flat-panel controller products to be offered
• Direct output to NTSC/PAL monitors
by S3 with the goal of providing better-than
• Composite or SVideo format desktop features and performance to the note
book computer market. It combines a 64-bit
Flexible Memory Support memory interface and graphics engine with a
24-bit high-performance 135 MHz RAMDAC, a
• Fast page or EDO DRAMs flat panel interface capable of controlling the
• 1-MByte with 2 256Kx16 DRAMs latest STN and TFT panels, S3's Scenic High
wayTM multimedia interface and Streams Proces
• 2-MBytes with 4 256Kx16 DRAMs
sorTM video acceleration technology, and direct
• 2-MBytes with 1 512Kx32 DRAM NTSC/PAL output. These elements, designed
• 4-MBytes with 2 512Kx32 DRAMs around S3's DuoView™ architecture, provide the
performance, flexibility, and display quality nec
24-b1t True-Color RAMDAC essary for premium multimedia notebook com
puter systems. Comprehensive, flexible hooks
Glueless PCI Local Bus Interface are provided to simplify graphics subsystem
power management.
Powerpen.! Support: Bi-endian Byte Ordering
VIDEO
SOURCE
16 Scenic Highway/ZV Port
I'
~'::'VTES~ ---.~t....2
OR It- -+1 CRT/TV
S3 Aurora64V+
FLAT PANEL
MSVSBLK
Figure 1-1. System Block Diagram
1-2 INTRODUCTION

86CM65 Dual Display Accelerator
S3 Incorporllted
Section 2: Mechanical Data
2.1  THERMAL SPECIFICATIONS
| Parameter                           | Min  | Typ  | Max  | Unit  |
| ----------------------------------- | ---- | ---- | ---- | ----- |
| Thermal Resistance 9JC              |      | 5    |      | °CM!  |
| Thermal Resistance 9JA (Still Air)  |      | 27   |      | °CM!  |
| Junction Temperature                |      |      | 125  | °C    |
| Case Temperature                    |      |      | 105  | °C    |
2.2 MECHANICAL DIMENSIONS
The 86CM65 comes in a 256-pin BGA package. The mechanical dimensions are given in Figure 2-1.
MECHANICAL DATA 2-1

86CM65 Dual Display Accelerator
sa InoorponltlMi
I
27mSOUAREREF:=j
-jj;0.36 TYP
,  PIN 1 CORNER
|     | r-0.60 ± 0.10  |                         | (IDENTIFICATION MAY VARY)  |     |     |
| --- | -------------- | ----------------------- | -------------------------- | --- | --- |
| n   |                | 00000000000 000000 000  |                            |     |     |
00000000000 0000 00 000
00000000000 00 00 00 000
rc
00000000000 0000 00 000
| ~   |     | Co)  0000  |     |     | 0  000  |
| --- | --- | ---------- | --- | --- | ------- |
in
|             |               | cc  0000       |              |     | 000         |
| ----------- | ------------- | -------------- | ------------ | --- | ----------- |
| ~           |               |                |              |     | 0           |
| :iii        |               | m              |              |     |             |
| 11.         | ~             | 0000           |              |     | 0  000      |
| 1 1.        |               | ~              |              |     |             |
| (1   ~      | . :I . E .    | 0000           |              |     | 0  000      |
| w           | I I)          |                |              |     | 0   0 0 0   |
| a ::        |               | 0 0            | 0 0          |     |             |
| Q   c c     | 0             |                |              |     | 0 00        |
| - '         |               | 0 0            | 0 0          |     | 0           |
| 0   :::I    | II            |                | BOTTOM VIEW  |     |             |
| : ii i  "   | i             | 0000           |              |     | 0  000      |
| r n         |               |                |              |     | o           |
| : w c       |               | 0000           |              |     | 000         |
| 0           | cc            |                |              |     |             |
| t - ~       |               | 0 0            | 0 0          |     | 0   0 0 0   |
| II .        | Z             |                |              |     |             |
| 0           | S             | 0 0            | 0 0          |     | 0   0 00    |
| e!!J        | 11 .          | 0 0            | 0 0          |     | 0   0 0 0   |
|             | 0             |                |              |     |             |
|             | C o )         | I w I.     0 0 | 0 0          |     | 0   0 0 0   |
a::  00000000000 o 000 0
0  000
" '"
| Q   |     | "" ':   0000 0000000 0  |     | 000 00 000  |     |
| --- | --- | ----------------------- | --- | ----------- | --- |
|     |     | 0000 0000000 0          |     | 000 00 000  |     |
-q 0000 00 00000 o 000
~
1.17TYP  . . . .
| . . . .   |     | '-1.44 REF  |     | 1.27 BASIC  |     |
| --------- | --- | ----------- | --- | ----------- | --- |
!.-3.50MAX
0.75± 0.15 DIA
ALL DIMENSIONS IN MILLIMETERS
Figure 2-1. 256-pin BGA Mechanical Dimensions
2-2 MECHANICAL DATA

86CM65 Dual Display Accelerator
53 Incorporated
Section 3: Pins
3.1 PINOUT DIAGRAMS
The 86CM65 comes in a 256-pin BGA package. The pin locations for this package are shown in Figure
3-1. Refer to the pin lists later in this section for pin names associated with each pin.
PINS 3-1

86CM65 Dual Display Accelerator
S3lncorpo. ....d
Al  A2  A3  A4  A5  A6  A7  A8  A9  Al0  All  A12  A13  A14  A15  A16  A17  A18  A19  A20
81  82  83  84  85  86  87  88  89  810  811  812  813  814  815  816  817  818  819  820
|         |             | C8          | Cl0  Cll  C12  | C13  C14  C15  | C16  C18  |           |
| ------- | ----------- | ----------- | -------------- | -------------- | --------- | --------- |
| Cl  C2  | C3  C4  C5  | C6  C7  C9  |                |                | C17       | C19  C20  |
01  02  03  04  05  06  07  08  09  010  011  012  013  014  015  016  017  018  019  020
| El  E2  | E3  E4  |         |     |     | E17  E18  | E19  E20  |
| ------- | ------- | ------- | --- | --- | --------- | --------- |
| Fl  F2  | F3  F4  |         |     |     | F17  F18  | F19  F20  |
| Gl  G2  | G3  G4  |         |     |     | G17  G18  | G19  G20  |
| Hl  H2  | H3  H4  |         |     |     | H17  H18  | H19  H2O  |
| Jl  J2  | J3  J4  | 86CM65  |     |     | J17  J18  | J19  J20  |
| Kl  K2  | K3  K4  |         |     |     | K17  K18  | K19  K20  |
Top View
| Ll  L2  | L3  L4  |     |     |     | L17  L18  | L19  L20  |
| ------- | ------- | --- | --- | --- | --------- | --------- |
| Ml  M2  | M3  M4  |     |     |     | M17  M18  | M19  M20  |
| Nl  N2  | N3  N4  |     |     |     | N17  N18  | N19  N20  |
| Pl  P2  | P3  P4  |     |     |     | P17  P18  | P19  P20  |
| Rl  R2  | R3  R4  |     |     |     | R17  R18  | R19  R20  |
| T1  12  | T3  T4  |     |     |     | T17  T18  | T19  120  |
Ul  U2  U3  U4  U5  U6  U7  U8  U9  Ul0  Ull  U12  U13  U14  U15  U16  U17  U18  U19  U20
Vl  V2  V3  V4  V5  V6  V7  V8  V9  Vl0  Vl1  V12  V13  V14  V15  V16  V17  V18  V19  V20
Wl  W2  W3  W4  W5  W6  W7  W8  W9  Wl0 Wll W12 W13 W14 W15 W16 W17 W18 W19 W20
Vl  V2  V3  V4  V5  V6  V8  V9  Vl0  Vl1  V12  V13  V14  V15  V16  V17  V18  V19  V20
Y7
Figure 3-1. Aurora64V+ Pin Locations (Top View)
3-2  PINS

86CM65 Dual Display Accelerator
83 Incorpor.teel
3.2 PIN DESCRIPTIONS
The following table provides a brief description of each pin on 86CM65. The following abbreviations
are used for pin types.
I -Input signal
o -
Output signal
B -Bidirectional signal
Some pins have multiple names. This either reflects the different functions performed by those pins
depending on the bus configuration selected by power-on-strapping or multiplexed pins whose
functions are selected via a register bit setting. The pin definitions and functions are given for each
possible case.
Table 3·1. Pin Descriptions
Symbol Type Description
PCI BUS INTERFACE +
Address and Data
AD[31:0] B Multiplexed AddresS/Data Bus. A bus transaction (cycle) consists of an
address phase followed bv one or more data phases.
C/BE[3:0] I Bus Command/Data Byte Enables. These signals carry the bus command
durinQ the address phase and the byte enables durinQ the data phase.
Bus Control
SCLK I PCI System Clock.
INTA 0 Interrupt Request.
lADY I Initiator Ready. A bus data phase is completed when both IRDY and
TROY are asserted on the same cycle.
TROY 0 Target Ready. A bus data phase is completed when both IRDY and TROY
are asserted on the same cycle.
DEVSEL 0 Device Select. 86CM65 drives this signal active when it decodes its
address as the target of the current access.
IDSEL I Initialization Device Select. This input is the chip select for PCI
configuration register reads/writes.
RESET I System Reset. Asserting this signal forces the registers and state
machines to a known state.
FRAME I Cycle Frame. This signal is asserted by the bus master to indicate the
beginning of a bus transaction. It is deasserted during the final data phase
of a bus transaction.
PAR 0 Parity. 86CM65 asserts this sianal to verify even parity during reads.
STOP 0 Stop. 86CM65 asserts this signal to indicate a target disconnect.
PINS 3-3

86CM65 Dual Display Accelerator
83 Incorporated
Table 3-1. Pin Descriptions (Continued)
~mbol Type Description
CLOCK CONTROL
XIN I Reference Frequency Input. If an external 14.318 MHz crystal is used, it
is connected between XOUT and this pin. A stable external frequency
source can also be input via this pin. If this is done, the input must be the
same voltage as AVDD. If PD11 is strapped low at power-on, this
becomes the DCLK (dot clock) input. bypassing the internal oscillator.
This is normally only used for test purposes.
XOUT 0 Crystal Output. This pin drives the crystal via an internal oscillator.
DISPLAY MEMORY INTERFACE
Address and Data
MA[9:0] 0 Memory Address Bus. The video memory row and column addresses are
multiplexed on these lines. MA9 is output on pin M17 when the memory
type is 512Kx32.
PD[63:0] B Display Memory Pixel Data Bus Lines 63:0. PD[28:0] are also used as the
system configuration strapping bits, providing system configuration and
setup information upon power-on reset. See Section 5 for a description of
this function.
Memory Control
RASO 0 Row Address Strobe.
CAS[7:0] 0 Column Address Strobe Lines 7:0.
WE 0 Write Enable.
OE 0 Output Enable.
CRT VIDEO INTERFACE
COMP Compensation. Thispin is tied to VDD throLJgh a 0.1 J1F capacitor.
VREF Voltage Reference. This pin is tied to VSS through a 0.1 I1F capacitor.
RSET Reference Resistor. This pin is tied to VSS through an external resistor to
control the full-scale current value.
AR 0 Analog Red. Analog red output to the CRT monitor. In TV output mode
(CR3D 0 = 1J , the output is determined by the settino of CR3D 3-1.
AB 0 Analoo Blue. Analoo blue output to the CRT monitor.
AG 0 Analog Green. Analog green output to the CRT monitor. In TV output
mode (CR3D 0 = 1J , the output is determined by the setting of CR3D 3-1.
HSYNC B Horizontal Sync.
VSYNC B Vertical Sync.
3-4 PINS

86CM65 Dual Display Accelerator
83 Incorponted
Table 3-1. Pin Descriptions (Continued)
Symbol Type Description
FLAT PANEL INTERFACE
FPD[35:0] 0 Flat Panel Data. The meanings of these outputs vary depending on the
type of panel. See Section 11 for tables listing all output combinations.
FPDE/ 0 Flat Panel Display Enable/AC Modulation Signal. When a TFT panel is
MOD being driven, this is the display enable signal. When an STN panel is
being driven, this is by default the display enable signal, which is not
normally used but may be required for external panel control. If SR343 =
1 this is the AC modulation signal for those ~anels that require it.
FPSCLK 0 Flat Panel Shift Clock. This is the shift (dot) clock for LCD panels.
FPHSYNC/LP 0 Flat Panel HSYNC. This is the HSYNC signal for TFT panels and the LP
(line pulse or new line start) signal for STNpanels.
FPVSYNC/FLM 0 Flat Panel VSYNC. This is the VSYNC signal for TFT panels and the FLM
(first line marker or new frame start) signal for STN panels.
FPPOL 0 Flat Panel Polarity. If SR1A_5 = 1, this signal tells the panel that the
polarity of the data is reversed, thereby minimizing the number of data
lines switching in each cycle. This is used in a few highly advanced
panels. If SR1A 5= 0, this is the ROMEN output.
PWM 0 Pulse Width Modulation. This signal is output on pin M17 when the
memory type is not 512Kx32 (CR68 6 = 1) and SR52 0 = 1.
FLAT PANEL POWER CONTROL
ENAVDD 0 Enable VDD. This signal is driven high to external logic to initiate a flat
panel power up sequence. It is driven Iowa programmable time (SR41_2)
after the panel control signals and ENAVEE are driven low when 86CM65
is placed in Standby or Suspend Mode or if the flat panel is shut off via
SR31 4.
ENAVEE 0 Enable VEE. This signal is driven high a programmable time (SR41_3)
after ENAVDD is driven high during a flat panel power up sequence. This
signals external logic to turn on the bias voltage to the flat panel. It is
driven low when 86CM65 is placed in Standby or Suspend Mode or if the
flat panel is shut off via SR40_4 . This signals external logic to turn off the
bias voltage to the flat panel.
STANDBY I Standby. If SR44_4 = 0, driving the STANDBY pin high initiates Standby
mode and driving it low initiates exiting of Standby. If SR44_4 = 1, the
system is always trying to go Into Standby mode and 4 SCLK high pulses
on the STANDBY pin either prevent this or take the system out of
Standby, resetting the timer in either case.
SUSPEND I Suspend. This pin is active when SR42_0 = 1. A low to high transition
initiates a Suspend mode sequence and a high to low sequence initiates
exiting from Suspend mode.
CLK32 I 32 kHz Clock. An external TIL 32 kHz source is connected to this pin. It is
used for panel power sequencing and video memory refresh when in
Suspend mode.
PINS 3-5

86CM65 Dual Display Accelerator
S3 Inoorporated
Table 3-1. Pin Descriptions (Continued)
Symbol Type Description
MISCELLANEOUS FUNCTIONS
ROMEN 0 ROM Enable. This signal provides the chip output enable input for BIOS
ROM reads. It is multiplexed with the FPPOL signal and is selected when
SR1A 5=0.
RA[15:0} 0 ROM Address Bus. These signals are multiplexed on PO lines. If a video
BIOS is used, it must be immediately shadowed after boot up.
RD[7:0] I ROM Data Bus. These signals are multiplexed on PO lines. If a video
BIOS is used, it must be immediately shadowed after boot up.
STWR 0 Strobe Write. If SR1A3 is set to 1, pin C3 acts as STWR. This signal is
asserted whenever a write is made to CR5C. It is used to enable a
General Output Port latch. MCLK is output instead of this signal if SR15_2
= 1. MCLK output is used only for test purposes.
GOPO 0 General Output Port. When SR1A_4 is cleared to 0, pin C3 acts as GOPO.
The content of CR5C_O is reflected on this pin when this bit is
programmed.
SPCLK 1/0 Serial Port Clock. This is the clock for serial data transfer, either for 12C or
DDC2 monitor data communications. As an output, it is programmed via
MMFF20_0. As an input, its status is read via MMFF20_2. In either case
the serial port must be enabled by setting MMFF20_4 to 1. PD[26:25] can
be strapped to allow I/O (E2H or E8H) port access to the Serial Port
reQister while 86CM65 is disabled.
SPDAT 1/0 Serial Port Data. This is the data signal for serial data transfer, either for
12C or DDC2 monitor data communications. As an output, it is
programmed via MMFF20_1. As an input, its status is read via
MMFF20_3. In either case the serial port must be enabled by setting
MMFF20_4 to 1. PD[26:25] can be strapped to allow I/O (E2H or E8H)
port access to the Serial Port register while 86CM65 is disabled.
3-6 PINS

86CM65 Dual Display Accelerator
S3 Incorponl.d
Table 3-1. Pin Descriptions (Continued)
Symbol Type Description
ZVPORT
LD[15:0) I Data. YUV input from PC Card
LCLK I Clock. PCLK input from PC Card
HS I HSYNC. HREF input from PC Card
VS I VSYNC. VSYNC input from PC Card
SCENIC HIGHWAY
Scenic/MX2 Mode
LD[7:0) I/O LPB Data. These lines carry compressed data to the Scenic/MX2 and
video data from the Scenic/MX2.
LCLK I LPB Clock. This clock controls transactions between 86CM65 and the all
Scenic Hiohway peripherals.
a
VREQNRDY Video Request/Ready. This signal is part of the the data transfer protocol
between 86CM65 and the Scenic/MX2.
CREO/CRDY I ScenicIMX2 Request/Ready. This signal is part of the the data transfer
protocol between 86CM65 and the Scenic/MX2.
a
LPBEN LPB Device Enable. This signal is connected to the SceniC/MX2 chip
enable input. The output level is controlled via SRD_O. This bit must be
programmed to 1 to enable the Scenic/MX2.
Video 8 and 16 Modes
LD[15:0] I LPB Data Bus [15:0]. Video data input. LD[7:0] are used for 8-bit
interfaces.
HS I HSYNC. HSYNC input signaling the transition from one line to the next.
VS I VSYNC. VSYNC input signaling the transition from one frame to the next.
ODD I Odd/Even Field. High = odd field input from digitizer. Low = even field
input. This input is active on pin M17 when the memory type is not
512Kx32 and SR52 0=0.
POWER AND GROUND
VDDCORE I Analog power supply to the core logic
VDDCRT I Digital power supply to the CRT block pads
VDDFPI I Digital power supply to the flat panel block pads
VDDLPB I Digital power supply to the LPB block pads
VDDMEM I Digital power supply to the memory subsystem pads
VDDSYS I Digital power supply to the system bus interface pads
AVDD I Analog power supply (RAMDAC). This must be the same voltage as
VDDCORE.
CLKAVDD[l :2] I Analog power supply (1 = MCLK synthesizer, 2 = DCLK synthesizer). This
must be the same voltaoe as VDDCORE
VSSPAD I Digital ground (dirtyl
VSSCORE I Dioital oround (core)
VSSSUB I Dioital oround (substrate)
AVSS I Analog ground
PINS 3-7

86CM65 Dual Display Accelerator
S3 Incorporated
3.3  PIN LISTS
Table 3-2 lists all 86CM65 pins alphabetically. Table 3-3 lists all pins in numerical order.
Table 3·2.  Alphabetical Pin Listing
| Name       | PIN IS)               |              |                               |
| ---------- | --------------------- | ------------ | ----------------------------- |
| A8         | G2                    |              |                               |
| AD[31:1S)  | Vl, VVl, V2, VV2, Yl  | Y2, U3, VV3  | U4 VV4, V4 Y4 VVS, VS, Y5,VS  |
AD[1S:0)  VVB  US, VVS,VS YS, VVl0, Vl0 Yl0 Vl 1, Yll VV12, V12, Y12, VV13, V13 Y13
| AG             | Gl                                         |     |                     |
| -------------- | ------------------------------------------ | --- | ------------------- |
| AR             | F2                                         |     |                     |
| AVDD           | Dl, F3, F4,                                |     |                     |
| AVSS           | Cl  D3 E3, Fl                              | G3  |                     |
| CAS[7:0)       | Y14, VV14, K1B,J1B, V14, U14,J1S H2O       |     |                     |
| C/8E[3:0)      | V3 YS YB, VVl 1                            |     |                     |
| CLK32          | Tl                                         |     |                     |
| CLKAVDD[l :2)  | C2, E4                                     |     |                     |
| CaMP           | E2                                         |     |                     |
| CREO/CRDY      | L1                                         |     |                     |
| DEVSEL         | VV7                                        |     |                     |
| EMCLK          | Nl                                         |     |                     |
| EDCLK          | A1                                         |     |                     |
| ENAVDD         | A2                                         |     |                     |
| ENAVEE         | 82                                         |     |                     |
| FLM            | A3                                         |     |                     |
| FPD[3S:27)     | A14, 814, C14, D14, A13, 813 C13 A12 812,  |     |                     |
| FPD[26:1B)     | C12, D12, All, 811, Cl1, Al0 810 Cl0 AS,   |     |                     |
| FPD[17:S)      | 8S, CS, AB, 8B CB, DB A7 87 C7,            |     |                     |
| FPD[B:O)       | AS  86 CS,DS,AS, 85 C5 A4 84               |     |                     |
| FPSCLK         | 83                                         |     |                     |
| FPDE           | 815                                        |     |                     |
| FPHSYNC        | C4                                         |     |                     |
| FPPOL          | C1S                                        |     |                     |
| FPVSYNC        | A3                                         |     |                     |
| FRAME          | VVS                                        |     |                     |
| GOPO           | C3                                         |     |                     |
| HS             | Kl                                         |     |                     |
| HSYNC          | H1                                         |     |                     |
| IDSEL          | Y3                                         |     |                     |
| INTA           | U2                                         |     |                     |
| IRDY           | V7                                         |     |                     |
| LCLK           | Ml                                         |     |                     |
| LD[lS:0)       | R2  Rl,P4,P3,P2 Pl,N3 N2 L3 L2             |     | K3  K2,J3,J2,Jl,H3  |
| LP             | C4                                         |     |                     |
3-8  PINS

86CM65 Dual Display Accelerator
53 Incorponted
Table 3·2. Alphabetical Pin Listing (Continued)
| Name     | PIN(S)                                          |     |                                     |
| -------- | ----------------------------------------------- | --- | ----------------------------------- |
| LPBEN    | Nl                                              |     |                                     |
| MA[9:0]  | M17, U8, U9, M19, N18, N19, N20, M18, M20, L20  |     |                                     |
| MOD      | B15                                             |     |                                     |
| ODD      | M17                                             |     |                                     |
| OE       | K19                                             |     |                                     |
| PAR      | V8                                              |     |                                     |
|          | V16, VV16, T17, U17, V17, VV17, Y17, V15, VV15  |     | Y18,VV18, V18, U18, T18, R18, P18,  |
PD[63:48]
PD[47:32]  C16,A17  B17,C17,D17, E17,G18,H18 H19,F18, E18  D18 C18, B18,A18  B16,
PD[31 :16]  P19, R19, T19,U19, V19, VV19, Y19, Y15, Y16, Y20, VV20, V20, U20, T20, R20, P20,
PD[15:0)  A16,A19, B19,C19, D19, E19, F19,G19,G20 F20, E20, D20,C20,B20 A20 A15
| PVVM  | M17  |     |     |
| ----- | ---- | --- | --- |
RA[15:0)  A16,A19, B19,C19,D19, E19, F19,G19,G20. F20, E20  D20,C20,B20,A20.A15
| RASO     | K20                                     |          |     |
| -------- | --------------------------------------- | -------- | --- |
| RD[7:0]  | Y16, Y20,VV20, V20, U20, T20, R20, P20  |          |     |
| RESET    | R3                                      |          |     |
| ROMEN    | C15                                     |          |     |
| RSET     | El                                      |          |     |
| SCLK     | Ul                                      |          |     |
| SPCLK    | M2                                      |          |     |
| SPDAT    | M3                                      |          |     |
| STANDBY  | T2                                      |          |     |
| STOP     | US                                      |          |     |
| STVVR    | C3                                      |          |     |
| SUSPEND  | T3                                      |          |     |
| TRDY     | Y7                                      |          |     |
| VDDFPI   | D5, Dl0, D13                            |          |     |
| VDDCORE  | D16, K17                                | L4, Ul0  |     |
| VDDCRT   | G4                                      |          |     |
| VDDLPB   | J4                                      |          |     |
G17,N17,U15
VDDMEM
| VDDSYS     | T4, U7  U12    |                          |               |
| ---------- | -------------- | ------------------------ | ------------- |
| VREO/VRDY  | Kl             |                          |               |
| VREF       | D2             |                          |               |
| VS         | Ll             |                          |               |
| VSSCORE    | D9  Dll, J17   | K4, L17  M4  Ull         |               |
|            | D4,D7,D15 F17  | H4  H17.N4, P17, R4, U5  | U6  U13  U16  |
VSSPAD
| VSSSUB  | R17  |     |     |
| ------- | ---- | --- | --- |
| VSYNC   | H2   |     |     |
| VVE     | J20  |     |     |
| XIN     | Al   |     |     |
| XOUT    | Bl   |     |     |
PINS 3-9

86CM65 Dual Display Accelerator
83 Incorporated
Table 3·3.  Numerical Pin Listing
|     | Name  | Number  | Name  |
| --- | ----- | ------- | ----- |
Number
| A1   | XIN/EDCLK    | C1   | AVSS         |
| ---- | ------------ | ---- | ------------ |
| A2   | ENAVDD       | C2   | CLKAVDD1     |
| A3   | FPVSYNC/FLM  | C3   | STWRIGOPO    |
| A4   | FPD1         | C4   | FPHSYNC/LP   |
| A5   | FPD4         | C5   | FPD2         |
| A6   | FPD8         | C6   | FPD6         |
| A7   | FPD11        | C7   | FPD9         |
| A8   | FPD15        | C8   | FPD13        |
| A9   | FPD18        | C9   | FPD16        |
| A10  | FPD21        | C10  | FPD19        |
| A11  | FPD24        | C11  | FPD22        |
|      | FPD28        |      | FPD26        |
| A12  |              | C12  |              |
| A13  | FPD31        | C13  | FPD29        |
| A14  | FPD35        | C14  | FPD33        |
| A15  | PDO/RAO      | C15  | FPPOL/ROMEN  |
| A16  | PD15/RA15    | C16  | PD47         |
| A17  | PD46         | C17  | PD44         |
| A18  | PD33         | C18  | PD35         |
| A19  | PD14/RA14    | C19  | PD12/RA12    |
| A20  | PD1/RA1      | C20  | PD3/RA3      |
| 81   | XOUT         | D1   | AVDD         |
| 82   | ENAVEE       | D2   | VREF         |
| 83   | FPSCLK       | D3   | AVSS         |
| 84   | FPDO         | D4   | VSSPAD       |
| 85   | FPD3         | D5   | VDDFPI       |
| 86   | FPD7         | D6   | FPD5         |
| 87   | FPD10        | D7   | VSSPAD       |
| 88   | FPD14        | D8   | FPD12        |
VSSCORE
| 89   | FPD17  | D9   |          |
| ---- | ------ | ---- | -------- |
| 810  | FPD20  | D10  | FPFPI    |
| 811  | FPD23  | D11  | VSSCORE  |
| 812  | FPD27  | D12  | FPD25    |
| 813  | FPD30  | D13  | VDDFPI   |
| 814  | FPD34  | D14  | FPD32    |
VSSPAD
| 815  | FPDE/MOD   | D15  |            |
| ---- | ---------- | ---- | ---------- |
| 816  | PD32       | D16  | VDDCORE    |
| 817  | PD45       | D17  | PD43       |
| 818  | PD34       | D18  | PD36       |
| 819  | PD13/RA13  | D19  | PD11/RA11  |
| 820  | PD2/RA2    | D20  | PD4/RA4    |
3-10  PINS

86CM65 Dual Display Accelerator
S3 InCDrpDmDd
Table 3-3. Numerical Pin Listing (Continued)
| Number  | Name       | Number  | Name         |
| ------- | ---------- | ------- | ------------ |
| E1      | RSET       | K1      | VREQNRDY/HS  |
| E2      | COMP       | K2      | LD4          |
| E3      | AVSS       | K3      | LD5          |
| E4      | CLKAVDD2   | K4      | VSSCORE      |
| E17     | PD42       | K17     | VDDCORE      |
| E18     | PD37       | K18     | CAS5         |
| E19     | PD1O/RA10  | K19     | OE           |
| E20     | PD5/RA5    | K20     | RASO         |
| F1      | AVSS       | L1      | CREO/CRDYNS  |
| F2      | AR         | L2      | LD6          |
| F3      | AVDD       | L3      | LD7          |
| F4      | AVDD       | L4      | VDDCORE      |
| F17     | VSSPAD     | L17     | VSSCORE      |
| F18     | PD38       | L18     | MA8          |
| F19     | PD9/RA9    | L19     | MA7          |
| F20     | PD6/RA6    | L20     | MAO          |
| G1      | AG         | M1      | LCLK         |
| G2      | AB         | M2      | SPCLK        |
| G3      | AVSS       | M3      | SPDAT        |
| G4      | VDDCRT     | M4      | VSSCORE      |
| G17     | VDDMEM     | M17     | ODD/MA9/PWM  |
| G18     | PD41       | M18     | MA2          |
| G19     | PD8/RA8    | M19     | MA6          |
| G20     | PD7/RA7    | M20     | MA1          |
| H1      | HSYNC      | N1      | LPBEN/EMCLK  |
| H2      | VSYNC      | N2      | LD8          |
| H3      | LDO        | N3      | LD9          |
| H4      | VSSPAD     | N4      | VSSPAD       |
| H17     | VSSPAD     | N17     | VDDMEM       |
| H18     | PD40       | N18     | MA5          |
| H19     | PD39       | N19     | MA4          |
| H2O     | CASO       | N20     | MA3          |
| J1      | LD1        | P1      | LD10         |
| J2      | LD2        | P2      | LD11         |
| J3      | LD3        | P3      | LD12         |
| J4      | VDDLPB     | P4      | LD13         |
| J17     | VSSCORE    | P17     | VSSPAD       |
|         | CAS4       | P18     | PD48         |
J18
| J19  | CAS1  | P19  | PD31      |
| ---- | ----- | ---- | --------- |
| J20  | WE    | P20  | PD16/RDO  |
PINS 3-11

86CM65 Dual Display Accelerator
Table 3-3. Numerical Pin Listing (Continued)
| Number  | Name      | Number  | Name      |
| ------- | --------- | ------- | --------- |
| R1      | LD14      | V3      | C/BE3     |
| R2      | LD15      | V4      | AD21      |
| R3      | RESET     | V5      | AD18      |
| R4      | VSSPAD    | V6      | AD16      |
| R17     | VSSSUB    | V7      | IRDY      |
| R18     | PD49      | V8      | PAR       |
| R19     | PD30      | V9      | AD12      |
| R20     | PD17/RD1  | V10     | AD9       |
| T1      | CLK32     | V11     | AD7       |
| T2      | STANDBY   | V12     | AD4       |
| T3      | SUSPEND   | V13     | AD1       |
| T4      | VDDSYS    | V14     | CAS3      |
| T17     | PD61      | V15     | PD56      |
| T18     | PD50      | V16     | PD63      |
| T19     | PD29      | V17     | PD59      |
| T20     | PD18/RD2  | V18     | PD52      |
|         |           | V19     | PD27      |
| U1      | SCLK      |         |           |
| U2      | INTA      | V20     | PD20/RD4  |
| U3      | AD25      | W1      | AD30      |
| U4      | AD23      | W2      | AD28      |
| U5      | VSSPAD    | W3      | AD24      |
| U6      | VSSPAD    | W4      | AD22      |
| U7      | VDDSYS    | W5      | AD19      |
| U8      | STOP      | W6      | FRAME     |
| U9      | AD14      | W7      | DEVSEL    |
| U10     | VDDCORE   | W8      | AD15      |
| U11     | VSSCORE   | W9      | AD13      |
| U12     | VDDSYS    | W10     | AD10      |
| U13     | VSSPAD    | Wll     | C/BEO     |
| U14     | CAS2      | W12     | AD5       |
| U15     | VDDMEM    | W13     | AD2       |
| U16     | VSSPAD    | W14     | CAS6      |
| U17     | PD60      | W15     | PD55      |
| U18     | PD51      | W16     | PD62      |
| U19     | PD28      | W17     | PD58      |
| U20     | PD19/RD3  | W18     | PD53      |
| V1      | AD31      | W19     | PD26      |
| V2      | AD29      | W20     | PD21/RD5  |
3-12  PINS

86CM65 Dual Display Accelerator
83 Incorporated
Table 3-3. Numerical Pin Listing (Continued)
Number Name
Yl AD27
Y2 AD26
Y3 IDSEL
Y4 AD20
Y5 AD17
Y6 C/BE2
Y7 TRDY
Y8 C!BEl
Y9 ADll
Yl0 AD8
Yll AD6
Y12 AD3
Y13 ADO
Y14 CAS7
Y15 PD24
Y16 PD23/RD7
Y17 PD57
Y18 PD54
Y19 PD25
Y20 PD22/RD6
PINS 3-13

86CM65 Dual Display Accelerator
S3 In ..o rpontod

86CM65 Dual Display Accelerator
83 Incorporat.d
Section 4: Electrical Data
4.1  MAXIMUM RATINGS
Table 4-1.  Absolute Maximum Ratings
| Ambient temperature  0° Cto 70° C  |     |     |     |     |
| ---------------------------------- | --- | --- | --- | --- |
Storage temperature
-40° C to 125° C
| DC Supply Voltage  -O.5Vt07.0V                          |     |     |     |     |
| ------------------------------------------------------- | --- | --- | --- | --- |
| I/O Pin Voltage with respect to Vss  -O.5V to Voo+0.5V  |     |     |     |     |
4.2  DC SPECIFICATIONS
Note: In all cases below, analog and digital VDD = 3.3V or 5V ± 5% and the operating temperature is
0° Cto 70° C.
Table 4-2.  RAMDAC/Clock Synthesizer DC Specifications
Parameter
Table 4-3.  RAMDAC Characteristics
|                               | Min          | Typical  | Max                  | Unit       |
| ----------------------------- | ------------ | -------- | -------------------- | ---------- |
| Resolution Each DAC           |              | 8        |                      | bits       |
| LSB Size                      |              | 66       |                      | .1lA.      |
| Integral Linearity Error      |              |          | ±1                   | LSB        |
| Differential Linearity Error  |              |          | ±1                   | LSB        |
| Output Full-Scale Current     | 15.4         | 17.6     | 19.8                 | rnA        |
| DAC to DAC Mismatch           |              |          | 5%                   |            |
| Power Supply Rejection Ratio  |              |          | 0.5                  | %/ % AVDD  |
| Output Compliance             | 0.0          |          | 1.5                  | V          |
| Output Capacitance            |              |          | 30                   | pF         |
| Glitch Impulse                |              | 75       |                      | pV-Sec     |
|                               | PRELIMINARY  |          | ELECTRICAL DATA 4-1  |            |

lIE.
r
86CM65 Dual Display Accelerator
83 Incorporilted
=
Table 4-4.  Digital DC Specifications (VDD  3.3/5V ± 5%, Operating Temperature 0° C to 70° C)
| Symbol  | Parameter          | Min   | Max  | Unit  |
| ------- | ------------------ | ----- | ---- | ----- |
|         | Input Low VoltaQe  | -0.5  | 0.8  | V     |
VIL
| VIH  | Input High VoltaQe   | 2.4  | VDD +0.5   | V   |
| ---- | -------------------- | ---- | ---------- | --- |
| VOL  | Output Low Voltage   |      | Vss + 0.4  | V   |
|      | Output High Voltage  | 2.4  |            | V   |
VOH
| IOL1  | Output Low Current  | 4 (Note 1)  |     |     |
| ----- | ------------------- | ----------- | --- | --- |
| IOH1  | Output Low Current  | -2          |     |     |
|       | Output Low Current  | 6 (Note 2)  |     |     |
IOL2
| IOH2  | Output Low Current   | -3           |     |      |
| ----- | -------------------- | ------------ | --- | ---- |
| IOL3  | Output Low Current   | 8 (Note 3)   |     | rnA  |
| IOH3  | Output High Current  | -4           |     | mA   |
| IOL4  | Output Low Current   | 12 (Note 4)  |     |      |
| IOH4  | Output Low Current   | -6           |     |      |
| IOL5  | Output Low Current   | 16 (Note 5)  |     | mA   |
-8
| IOH5  | Output HiQh Current       |              |     | mA   |
| ----- | ------------------------- | ------------ | --- | ---- |
| IOL6  | OutPut Low Current        | 24 (Note 6)  |     | rnA  |
| IOH6  | Output HiQh Current       | -12          |     | rnA  |
| loz   | Output Tri-state Current  |              | 1   | IlA  |
| CIN   | Input Capacitance         |              | 5   | pF   |
| COUT  | Output Capacitance        |              | 5   | pF   |
rnA
| Icc  | Power Supply Current  |     | TBD (Note 7)  |     |
| ---- | --------------------- | --- | ------------- | --- |
Notes for Table 4-4
1.  10L1, IOH1 for ENAVDD, ENAVEE
2.  IOL2, IOH2 for FPD(36:0], FPDE, FPPOL at 3.3V with SR40_0 = 0
3.  10L3, IOH3 for pins ROMEN, INTA, STWR, HSYNC, VSYNC, BLANK, MA(8:0]. CAS(7:0], PD(63:0],
AD(31:0], LD(7:0], VREQNRDY, SPClK, SPD, FPD(36:0] (5V if SR40_0 = 0), FPVSYNC, FPHSYNC
4.  IOL4, IOH4 for FPD(36:0] FPDE, FPPOl at 3.3V with SR40_0 = 1
5.  10L5, IOH5 for pins OE, WE, RAS(1:0], FPD(36:0] (5V if SR40_0 = 1)
6.  IOL6, IOH6 for pins PAR, STOP, DEVSEl, TRDY
7.  Icc measured for a resolution of 1024x768x8 with a 75 MHz DCLK and a 50 MHz MCLK at 25°C
and 5V.
8.  The pin names used in these notes are the primary ones. An output signal multiplexed on one
of these pins has the same drive level.
| 4-2 ELECTRICAL DATA  | PRELIMINARY  |     |     |     |
| -------------------- | ------------ | --- | --- | --- |

86CM65 Dual Display Accelerator
S3 Inoorporated
4.3  AC SPECIFICATIONS
Note: All AC timings are based on an 80 pF test load.
4.3.1  RAMDAC AC Specifications
Table 4-5.  RAMDAC AC Specifications
| Parameter                  |     |     | Typical  | Max  | Unit  | Notes  |
| -------------------------- | --- | --- | -------- | ---- | ----- | ------ |
| DAC Output Delay           |     |     | 5        |      | ns    | 1      |
| DAC Output Rise/Fall Time  |     |     | 3        |      | ns    | 2      |
| DAC Output Settling Time   |     |     | 15       |      | ns    |        |
| DAC-to-DAC Output Skew     |     |     | 2        | 5    | ns    | 3      |
Notes for Table 4-5
1.  Measured from the 50% point ofVCLK to the 50% point of full scale transition
2.  Measured from 10% to 90% full scale
3  With DAC outputs equally loaded
Table 4-6.  RAMDAC Output Specifications
| Description  | lOUT (mA)     | VOUT(V)       |       | BLANK  |     | Input Data  |
| ------------ | ------------- | ------------- | ----- | ------ | --- | ----------- |
| White        | 17.6 typical  | 0.66 typical  |       | 1      |     | FFH         |
| Data         | Data          |               | Data  | 1      |     | Data        |
| Data (sync)  | Data          |               | Data  | 1      |     | Data        |
| Black        | 0             |               | 0     | 1      |     | OOH         |
OOH
| Black (sync)  | 0   |     | 0   | 1   |     |             |
| ------------- | --- | --- | --- | --- | --- | ----------- |
| BLANK         | 0   |     | 0   | 0   |     | Don't Care  |
Note
1.  Condition for VOUT is a 75 Ohm doubly terminated load, RSET = 147 Ohms and use of internal
VREF.
|     |     | PRELIMINARY  |     |     | ELECTRICAL DATA 4-3  |     |
| --- | --- | ------------ | --- | --- | -------------------- | --- |

86CM65 Dual Display Accelerator
sa lnoorporllted
4.3.2 Clock Timing
| -TH1GH-            | 5VCLOCK  | -TH1GH-            | 3.3V CLOCK  |
| ------------------ | -------- | ------------------ | ----------- |
|                    | -T       |                    | -T          |
|                    | LOW-     |                    | LOW-        |
| -----Tcyc-----·I  |          | 1-----TCYc-----~1  |             |
Figure 4-1. Clock Waveform Timing
Table 4-7.  Clock Waveform TIming
| Parameter  |     | Min  Max  | Units  Notes  |
| ---------- | --- | --------- | ------------- |
~mbol
| Tcyc  SCLK_~cle Time             |     | 30  125    | ns  1    |
| -------------------------------- | --- | ---------- | -------- |
| LCLK Cycle Time                  |     | 30  200    | ns       |
| MCLK Cycle Time                  |     | 20  100    | ns       |
| OCLK Cycle Time NGA Mode)        |     | 25  100    | ns  1    |
| OCLK Cvcle Time (Enhanced Mode)  |     | 12.5  100  | ns  1,2  |
| FPOCLKC'Lcle Time                |     | TBO  TBO   | ns       |
| CLK32 Cycle Time                 |     | TBO  TBO   | ns       |
| THIGH  SCLK High Time            |     | 12  80     | ns       |
| LCLK High Time                   |     | 12  160    | ns       |
| FPOCLK High Time                 |     | TBO  TBO   | ns       |
| CLK32 High Time                  |     | TBO  TBO   | ns       |
| TLOW  SCLK Low Time              |     | 12  80     | ns       |
| FPOCLK Low Time                  |     | TBO  TBO   | ns       |
| CLK32 Low Time                   |     | TBO  TBO   | ns       |
| LCLK Low Time                    |     | 12  160    | ns       |
| SCLK Slew Rate                   |     | 1  4       | V/ns  3  |
| LCLK Slew Rate                   |     | 1  4       | v/nS  3  |
| FPOCLK Slew Rate                 |     | TBO  TBO   | v/nS     |
| CLK32 Slew Rate                  |     | TBO  TBO   | v/nS     |
Notes
1~  focu< ~ 1/2 fSCLKto ensure valid ",!rites to the PLLs.
2.  For OCLK rates above 80 MHz, clock doubling is used. The maximum OCLK rate with clock
doubling is 67.5 MHz.
3.  Rise and fall times are specified in terms of the edge rate measured in V/ns. This slew rate
must be met across the minimum peak-to peak portion of the clock waveform.
4-4 ELECTRICAL OATA  PRELIMINARY

86CM65 Dual Display Accelerator
83 Incorporllted
4.3.3  Input/Output Timing
CLOCK
INPUT  1.5 V
TCLKlN
Figure 4-2. Input Timing
Table 4-8.  SCLK-Referenced Input Timing
PCIBus
| SYI11bol  | Parameter                                       | Min  | Units  |
| --------- | ----------------------------------------------- | ---- | ------ |
| Tsu       | AD[31 :01. C/BE[3:0J. FRAME. IRDY. IDSEL setup  | 7    | ns     |
| TH        | AD[31 :0) hold                                  | 1    | ns     |
| TH        | C/BE[3:01. FRAME. IRDY. IDSEL hold              | 1    | ns     |
| Tsu       | STANDBY setup                                   | TBD  | ns     |
| TH        | STANDBY hold                                    | TBD  | ns     |
Table 4-9.  CLK32-Referenced Input Timing
| Symbol  | Parameter      | Min  | Units  |
| ------- | -------------- | ---- | ------ |
| Tsu     | SUSPEND setup  | TBD  | ns     |
| TH      | SUSPEND hold   | TBD  | ns     |
PRELIMINARY  ELECTRICAL DATA 4-5

86CM65 Dual Display Accelerator
sa Incorporetod
| Table 4-10.  MCLK-Referenced Input Timing  |                                               |       |        |
| ------------------------------------------ | --------------------------------------------- | ----- | ------ |
| Svmbol                                     | Parameter                                     | Min   | Units  |
| Tsu                                        | MD[63:0) setup to MCLK high (2-cvcle EDO)     | 0     | ns     |
| TH                                         | MD[63:0) hold from MCLK hioh (2-cvcle EDO)    | 12.5  | ns     |
| Tsu                                        | MD[63:0) setup to following CAS low (1-cycle  | 0     | ns     |
EDO)
| TH  | MD[63:0) hold from following CAS low (1-cycle  | 15  | ns  |
| --- | ---------------------------------------------- | --- | --- |
EDO)
| Tsu  | MD[63:0) setup to CAS hioh (fast paoe)   | 0   | ns  |
| ---- | ---------------------------------------- | --- | --- |
| TH   | MD[63:0) hold from CAS high (fast page)  | 15  | ns  |
Note
1.  The timing reference in each of the three cases above is to the event that causes the latching
of the read data. The MCLK used to latch 2-cycle EDO data is an internal signal that cannot be
directly observed. The CAS signals used to latch read data in the other operational modes are
derived from the internal MCLK.
| Table 4-11.  LCLK-Referenced Input Timing  |     |     |     |
| ------------------------------------------ | --- | --- | --- |
Scenic/MX2 Interface
| Svmbol  | Parameter       | Min  | Units  |
| ------- | --------------- | ---- | ------ |
|         | LD[7:0) setup_  | 10   | ns     |
Tsu
| TH   | LD[7:0) hold  | 9   | ns  |
| ---- | ------------- | --- | --- |
| Tsu  | CREO/CRDY     | 6   | ns  |
| TH   | CREO/CRDY     | 8   | ns  |
SAA7110 Interface
| Symbol  | Parameter  | Min  | Units  |
| ------- | ---------- | ---- | ------ |
Tsu  LD[7:0) setup (also LD[15:8) for 16-bit interface)  6  ns
TH  LD[7:0) hold (also LD[15:8) for 16-bit interface)  8  ns
| Tsu  | HS setup  | 6   | ns  |
| ---- | --------- | --- | --- |
| TH   | HShold    | 7   | ns  |
|      | VS setup  | 6   | ns  |
Tsu
| TH   | VS hold    | 7    | ns  |
| ---- | ---------- | ---- | --- |
| Tsu  | ODD setup  | TBD  | ns  |
| TH   | ODD hold   | TBD  | ns  |
4-6 ELECTRICAL DATA  PRELIMINARY

86CM65 Dual Display Accelerator
S3 IncorpDnted
CLOCK  1.5V
-MAX
MIN-
OUTPUT  1.5 V ....,.r"v\/-..-1.5 V
TCU<OIII"
Figure 4-3. Output Timing
The minimum delay is the minimum time after the clock edge that the valid signal state from the previous
cycle will begin transition to the next state (become invalid).
The maximum delay is the maximum time after the clock edge that the signal state is valid for the next
cycle.
Table 4-12.  SCLK·Referenced Output Timing
PCIBus
| Parameter              | Min  Max  | Units  Notes       |
| ---------------------- | --------- | ------------------ |
| AD[31 :0) valid delay  | 2  16     | ns  1              |
| DEVSEL,PAR             | 2  11     | ns  Medium DEVSEL  |
| delay                  |           | timing used        |
| STOP delay             | 2  11     | ns                 |
| TRDYdeiay              | 2  11     | ns                 |
| INTAdeiay              | 2  11     | ns                 |
Note
1.  Due to the timing for TRDY for read cycles, data is not sampled on the clock edge immediately
following its becoming valid. This guarantees the PCI 2.0 specification time of 11 ns.
Table 4-13.  CLK32-Referenced Output Timing
| Parameter  |     | Notes  |
| ---------- | --- | ------ |
ENAVDD, ENAVEE active del a
|     | PRELIMINARY  | ELECTRICAL DATA 4-7  |
| --- | ------------ | -------------------- |

86CM65 Dual Display Accelerator
sa InDOrpom.d
Table 4-14.  MCLK-Referenced Output Timing
| Parameter                | Min  Max  | Units  Notes  |
| ------------------------ | --------- | ------------- |
| PD[63:0) valid delay     | 2  7/11   | ns  1         |
| MA[8:0) valid delay      | 1.5  8    | ns            |
| CAS[7:0) active delllY   | 1  5.5    | ns            |
| CAS[7:0) inactive delay  | 1  5.5    |               |
ns
| RASO active delay    | 1  5      | ns  |
| -------------------- | --------- | --- |
| RASO inactive delay  | 1  6.5    | ns  |
| OE active delay      | 1.5  4.5  | ns  |
| WE active delay      | 1.5  4.5  | ns  |
Note
1.  The max delay is 7 ns for 1-cycle operation and 11 ns for 2-cycle operation.
Table 4-15.  LCLK-Referenced Output Timing
Scenic/MX2 Interface
| Parameter                    | Min  Max  | Units  Notes  |
| ---------------------------- | --------- | ------------- |
| VREQNRDY active delay        | 2  11     | ns  7 ns typ  |
| LD[7:0) valid delay          | 2  15     | ns  8 ns typ  |
| LD[7:0) tri-state from LCLK  | 7  15     | ns            |
Table 4-16.  FPSCLK-Referenced Output Timing
| Parameter                             | Min  Max  | Units  Notes  |
| ------------------------------------- | --------- | ------------- |
| FPD[36:0) valid delay.                | 0  10     | ns            |
| FPDE, FPPOL, FPVSYNC, FPHSYNC active  | 0  10     | ns            |
delay
| 4-8 ELECTRICAL DATA  | PRELIMINARY  |     |
| -------------------- | ------------ | --- |

86CM65 Dual Display Accelerator
RESET
SYSTEM
CONFIGURATION
DATA
Figure 4-4. Reset Timing
Table 4-17.  Reset Timing
| Symbol  | Parameter                         | Min  | Units  |
| ------- | --------------------------------- | ---- | ------ |
| TLQW    | RESET active pulse width          | 400  | ns     |
|         | PD[28:0) setup to RESET inactive  | 20   | ns     |
Tsu
| TH  | PD[28:0) hold from RESET inactive  | 10  | ns  |
| --- | ---------------------------------- | --- | --- |
PRELIMINARY  ELECTRICAL DATA 4-9

86CM65 Dual Display Accelerator
sa InOOl'POreted

86CM65 Dual Display Accelerator
sa Incorpor.ted
Section 5: Reset and Power Control
The RESET signal resets the internal state ma  PD[7:5] pins. Other pins may also not require
| chines in the 86CM65 and places all registers in  | strapping, depending on the design.  |     |
| ------------------------------------------------- | ------------------------------------ | --- |
their power-on default states. All output pins are
tri-stated except OE, which must be driven high
5.2  BOUNDARY SCAN
to prevent the memory from driving data onto
the power-on strapping pins described in the
| next section.  | Boundary scanning is enabled when PD9  | is  |
| -------------- | -------------------------------------- | --- |
pulled high at reset. All digital pins become in
puts except the SPCLK pin (M2) and the RESET
5.1  CONFIGURATION STRAPPING  pin (R3). SPCLK is the output pin forthe boundary
scan and RESET cannot be tested and must not
| The PD[28:0] pins are pulled low internally and  | be connected.  |     |
| ------------------------------------------------ | -------------- | --- |
can be individually pulled high through 10 Kn
resistors. These pull-ups and pull-downs do not  The tester drives high logic to all digital inputs. It
affect normal operation of the pins as part of the  then sequentially drives and holds each input low
and records the state of the SPCLK pin. If all pin
pixel data bus, but they do force the pins to a
definite state during reset. At the rising edge of  connections are good, the output will be perfect
the reset signal, this state is sampled, the result  square wave. Ifthis pattern is broken, the location
is inverted and the data loaded into the CR36,  ofthe incorrect signal level in the sequence ident
| CR37, CR68 and CR6F registers. The data is used  | fies the bad connection.  |     |
| ------------------------------------------------ | ------------------------- | --- |
for system configuration. The definitions of the
PD[28:0] strapping bits at the rising edge of the  Any sequence of the digital inputs can be used.
The digital inputs to be tested are all pins except
reset signal are shown in Table 5-1.
the following:
Important Note: As described above, the signal
| levels on PD[28:0] are inverted before being         | SPCLK  |     |
| ---------------------------------------------------- | ------ | --- |
| latched in the various strapping bit registers.      | RESET  |     |
| Since PD[28:0] all have Internal pull-downs, the     | XIN    |     |
| default values for each of the strapping bits is 1.  | XOUT   |     |
| The value latched at reset can be changed to 0       | VREF   |     |
| by adding an external pull-up to the appropriate     | COMP   |     |
| pin. After reset, the strapping bits are written     | RSET   |     |
| and read normally, i.e., there is no inversion of    | AR     |     |
| the register values.                                 | AB     |     |
AG
Strapping bits 7-5 define the display memory  All analog and digital powers and grounds
size. However, the BIOS determines this value
directly and writes it to CR36_7-5 after reset.
Therefore, systems do not need to strap the
RESET AND POWER CONTROL  5-1

86CM65 Dual Display Accelerator
Table 5-1.  Definition of Strapping Bits at the Rising Edge of the Reset Signal
Note: The CR Bit Values in this table are the latched values as software would read or write them. To
latch a 0 at reset, an external pull-up resistor must be connected to the appropriate PO pin as explained
by the note on the previous page.
| CR Bits  | PD  CRBit  | Function  |
| -------- | ---------- | --------- |
Pins  Value
| CR36 1-0  | Reserved  |     |
| --------- | --------- | --- |
Memory Page Mode Select
| CR36 3-2  | 3-2  | 1-cycle extended data out (EDO) mode  |
| --------- | ---- | ------------------------------------- |
00
|        | 01        | Reserved                      |
| ------ | --------- | ----------------------------- |
|        | 10        | Extended data out (EDO) mode  |
|        | 11        | Fast page mode                |
| CR364  | Reserved  |                               |
Display Memory Size
| CR367-5  | 7-5  000  | 4 MBytes (valid only with 512Kx32 DRAMs)  |
| -------- | --------- | ----------------------------------------- |
|          | 001       | Reserved                                  |
|          | 010       | Reserved                                  |
|          | 011       | Reserved                                  |
|          | 100       | 2 MBytes                                  |
|          | 101       | Reserved                                  |
|          | 110       | 1 MByte (valid only with 256Kx16 DRAMs)   |
|          | 111       | Reserved                                  |
| CR37 0   | Reserved  |                                           |
Boundary Scan
| CR37 1  | 9  0      | Allows testing for bad solder connections  |
| ------- | --------- | ------------------------------------------ |
|         | 1         | Normal operation                           |
| CR372   | Reserved  |                                            |
Clock Select
CR37_3  11  0  Use external DCLK on the XIN and external MCLK on the
LPBEN pin (test purposes only)
|        | 1         | Use internal DCLK, MCLK  |
| ------ | --------- | ------------------------ |
| CR374  | Reserved  |                          |
Panel Type
| CR37 7-5  | 15-13  | OEM-specific coding for identifying up to 8 panel types  |
| --------- | ------ | -------------------------------------------------------- |
CAS/OE Low Stretch
| CR68 1-0  | 17-16  00  | approximately 6.5 ns stretch (nominal)  |
| --------- | ---------- | --------------------------------------- |
|           | 01         | approximately 5 ns stretch (nominal)    |
|           | 10         | approximately 3.5 ns stretch (nominal)  |
|           | 11         | No stretch                              |
5-2  RESET AND POWER CONTROL

86CM65 Dual Display Accelerator
sa Incorpo. .t ed
Table 5-1. Definition of Strapping Bits at the Rising Edge of the Reset Signal (Continued)
| CRBits  | PD  CRBit  | Function  |
| ------- | ---------- | --------- |
Pins  Value
RAS Low Timing Select
| CR682  | 18  0  | 4.5 MCLKs  |
| ------ | ------ | ---------- |
|        | 1      | 3.5 MCLKs  |
RAS Pre-Char e Timing Select
| CR683  | 19  0  | 3.5 MCLKs  |
| ------ | ------ | ---------- |
|        | 1      | 2.5 MCLKs  |
Memory Type Select
| CR686    | 22  0     | 512Kx32 DRAMs  |
| -------- | --------- | -------------- |
|          | 1         | 256Kx16 DRAMs  |
| CR687-5  | Reserved  |                |
| CR6F 0   | Reserved  |                |
Serial Port 110 Address Select
CR6F 1  25  0  Serial Port register mapped as I/O port at address 000E8H
|     | 1   | Serial Port reoister maDDed as I/O Dart at address 000E2H  |
| --- | --- | ---------------------------------------------------------- |
Serial Port Address Type Select
CR6F_2  26  0  Serial Port register mapped at the I/O port defined by PD25 or
at its MMIO address (offset FF20)
,
|     | 1   | Serial Port register is accessed at its MMIO address (offset  |
| --- | --- | ------------------------------------------------------------- |
FF20) only (no I/O)
WE Delay
| CR6F 4-3  | 28-27  00  | 3 units delay  |
| --------- | ---------- | -------------- |
|           | 01         | 2 units delay  |
|           | 10         | 1 unit delay   |
|           | 11         | no delay       |
RESET AND POWER CONTROL  5-3

86CM65 Dual Display Accelerator
S3 Incorpol'llted
5.3 FLAT PANEL POWER The PWM signal, whcih can control panel con
SEQUENCING trast, is also sequenced. See Figure 11-8.
The flat panel may be damaged if the bias voltage 5.4 POWER MANAGEMENT
VEE is applied to the liquid crystal material with
out enabling the control and data signals to the The operational modes can be classified by the
panel, which require VDD. the 86CM65 supplies following three categories:
the ENAVDD and ENAVEE signals to control
power up/down sequencing of LCD panels. • Normal mode
These signals drive external power management
• Standby mode
components which eventually drive panel VDD
and panel VEE. • Suspend mode
At the end of a power down sequence, the
5.4.1 Normal Mode
86CM65 is in its idle power down state. This
status is indicated by SR46_6. After power up or
a system reset, 86CM65 stays in idle power down During the Normal mode of operation, the flat
state. The BIOS must program SR42_5 = 1 to panel is active. The CPU can access video mem
initiate software Standby, program all mode set ory and I/O registers and normal refresh to the
tings, then program SR42_5 = 0 to exit Standby. video memory is provided. In this mode, the
This initiates a power up sequence. 86CM65 provides a number of automatic power
management functions. These turn off power to
Sequencing timing is shown in Figure 5-1. The tl certain internal blocks when these blocks are
and t2 values can each be programmed to 32 or inactive.
128 ms via bits 2 and 3 of SR41. The default is 32
ms for both tl and t2.
5.4.2 Standby Mode
At the end of a power up sequence, the 86CM65
is in its idle power up state. This status is indi In Standby, the 86CM65 suspends all display-re
cated by SR463. lated memory activities. The CPU can still access
video memory and I/O registers. In summary, the
Enabling flat panel display (SR31_4 = 1) automat following occur in Standby mode:
ically generates a panel power up sequence. Dis
abling flat panel display (clearing SR31_4 to 0) • Most of the dot clocks (DCLKs) are gated
automatically generates a panel power down off
sequence. J
I SS lI
ENAVDD
i I tIl-
l
!
t1
I
~
1I
; SS
J
CONTROL
SIGNALS
-I i
II
i
I-- ~
t1 ss \ tI~
I 1
ENAVEE
PWRSEQ
Figure 5-1. Flat Panel Power Sequencing
5-4 RESET AND POWER CONTROL

86CM65 Dual Display Accelerator
S3 Incorporat.d
• No clock is provided to the CRT control Once in Standby state, a high to low transition of
lers the STANDBY pin initiates exiting of this state.
This transition causes a panel power on se
• The RAMDAC is in low-power mode
quence. When this is complete, normal operation
• The CPU can access and modify the is restored and the timer is reset.
video display memory and CLUTs
If SR44_4 = 1, the Standby timeout counter be
Standby mode is controlled by three different
gins counting when hardware Standby is en
methods. These are:
abled (SR42_4 = 1). If the STANDBY pin is not
taken from low to high before the timer expires
• STANDBY input pin, a bit defining the
and the power down sequence is complete, the
operation of this pin and a hardware
system enters Standby. Every rising edge of the
Standby enable bit
Standby pin will either reset the timer (if not in
• Activity bit Standby) or take the system out of Standby.
Thus, in this mode, the STANDBY pin becomes
• Software Standby bit
an activity pin. As soon as Standby is exited and
The function of the STANDBY pin is enabled the power up sequence is complete, the Standby
when SR42 _4 is set to 1. The activity function is timer resets and starts counting again. The activ
enabled by setting SR43_6 to 1. This means that ity pulses on the STANDBY pin must be exactly
internal chip activity (register access, Graphic 4 SCLKs wide.
Engine busy, etc.) is used as a criterion for enter
ing or leaving Standby. Software Standby is con Summarizing, if SR44_4 = 0, driving the
trolled by SR42_5. Only one of these functions STANDBY pin high initiates Standby mode and
should be enabled/used at a time. Typically, the driving it low initiates exiting of Standby. If
BIOS will use the software bit during mode SR44_4= 1, the system is always trying to go into
changes, with both the hardware and activity Standby mode and 4 SCLK high pulses on the
enable .b its disabled. After the mode is set, the STANDBY pin either prevent this or take the
BIOS will then disable software Standby and system out of Standby, resetting the timer in
enable hardware Standby. The activity function either case.
provides additional flexibility and may not be
required. If the activity function is enabled, this starts the
timeout counter. If no internal chip activity is
The second Standby setup function is to specify detected before the timer expires, a panel power
a timeout value controlling the time between down sequence is initiated. At the end of the
power down sequence, the Standby state is en
initiation of Standby and the actual entering of
that state. The Standby timer is programmed tered. If activity is detected before the timer ex
with a timeout value in SR43_5-0, with SR433 pires, the timer is reset and counting restarts.
specifying whether the timeout value units are This sequence continues as long as the activity
seconds or minutes. function is enabled. Once in Standby state, any
chip activity causes a panel power on sequence.
The STANDBY pin has two operational modes. If When this is complete, normal operation is re
SR44_4 = 0 and hardware Standby is enabled, stored except that the Standby timeout counter
the Standby sequence is initiated by a lowto high is again active.
transition on the STANDBY pin. This starts the
timeout counter. If the STANDBY pin remains in If the software Standby bit (SR42_5) is set, this
a high logic state until the timer expires and a starts the timeout counter. If the bit is not cleared
before the timer expires, the Standby state entry
panel power down sequence is completed (see
sequence is executed. If the software Standby bit
Section 5.3), the system enters Standby. If the
STANDBY pin transitions from high to low before is cleared before the timer expires, the timer is
reset and normal operation continues. Once in
the idle power down state is reached, a power up
Standby state, clearing the software Standby bit
sequence is generated (if required), the timer is
to 0 causes a panel power on sequence. When
reset and normal operation continues.
this is complete, normal operation is restored.
RESET AND POWER CONTROL 5-5

86CM65 Dual Display Accelerator
53 Incorporated
If Standby is initiated while any chip activity is in Software-initiated Suspend is entered by setting
progress, any current transaction is completed SR42_1 to 1. Since CPU access is not allowed in
first. If Standby is initiated after a Suspend re Suspend mode, exiting requires that the
quest is initiated but before Suspend is entered, SUSPEND pin be driven from high to low. Exiting
the Standby request will be delayed until after of Suspend clears SR42_1 to O.
Suspend is exited.
If supported by the DRAMs, slow DRAM refresh
If a power up sequence is requested while a can be selected (SR29_7-6 = 01b or 10b). This
power down sequence is being executed, it will uses the 32 KHz clock. If supported, the DRAM
be delayed and executed immediately after the will be placed in self refresh mode (SR29_7-6 =
power down sequence completes. Power up se 11 b). The system BIOS must program the correct
quences do not use the timer. If the system is choice of refresh type supported by the DRAM.
already in its idle power down state (CR46_6
reads 1) when a Suspend request is made, the The delay before the clock synthesizer PLLs are
power down sequence will not be done. turned off is programmable via SR45_1-0.
Standby mode status can be read via SR46_5 If Suspend mode is initiated while any chip activ
(0 = off; 1 = on). ity is in progress, any current transaction is com
pleted first. If Suspend mode is initiated while the
chip is in Standby mode, Standby is interrupted
5.4.3 Suspend Mode
and resumed (assuming the request is still active)
after leaving Suspend.
The following occur in Suspend mode:
Hibernate mode is executed by the system. It is
• Register data bits are retained entered when the system reads the contents of
the registers and DRAM and stores it to disk
• DCLK and MCLK oscillators are shut off
before activating Suspend. Once the data is
• No CPU accesses are allowed saved, power to the 86CM65 can be turned off.
• DRAM refresh clock rate set to 32 KHz The stored data is used after power-on reset to
return the 86CM65 to its operating state before
• All pins are deactivated except for the
SUSPEND and DRAM control pins entering Hibernate mode.
• DAC and TV encoder are powered down
5.5 MIXED 3.3 VOLT AND 5 VOLT
Suspend mode is controlled by two different OPERATION
methods. These are:
The 86CM65 provides mixed 3.3V and 5V opera
• SUSPEND input pin and a hardware Sus
tion. The choice of voltage levels for the various
pend enable bit
subsystems is left to the system designer. Care
• Software Suspend bit must be taken thatthe choices are consistent with
the choice of external components, e.g., 3.3V
When hardware Suspend is used, the Suspend memory must be used if the memory power
debounce timer is programmed with a value of plane is supplied with 3.3V.
62.5 ~ (SR42_7-6 = OOb) or 2 seconds (SR42_7-6
= 01 b. Hardware Suspend is enabled by setting Only the RAMDAC power is directly programma
SR42_0 to 1. The Suspend sequence is initiated ble. The automatic setting is read from SR1B_0
by a low to high transition of the SUSPEND pin. (0 = 5V; 1 =3 .3V). The internal setting can be over
If after the debounce period, the SUSPEND pin is ridden via SR1.l\_7 (0 ~ 3.3V; 1 = 5V).
still high, a power down sequence is initiated (if
the system is not already in its idle power down The drive strength of the flat panel data output
state) followed by entry to the Suspend state. drivers can be set at 6 or 12 mA for 3.3V operation
or at 8 or 16 mA for 5V operation. SR40_0 pro-
5-6 RESET AND POWER CONTROL

86CM65 Dual Display Accelerator
S3 IneOl'porated
vides this option. The lower drive levels (6/8 mAl
must be used with XGA panels.
5.6 GREEN PC SUPPORT
The 86CM65 provides support for the VESA Dis
play Power Management Signaling (DPMS) pro
tocol by allowing independent control of the
HSVNC and VSVNC signals. To use this capabil
ity, the bit pattern xxxx0110b must be written to
the SRB register to unlock access to the SRD
register. Bits 5-4 of SRD then control the state of
HSVNC and bits 7-6 of SRD control the state of
VSVNC.
RESET AND POWER CONTROL 5-7

••
r 86CM65 Dual Display Accelerator
53 Inoorporated

86CM65 Dual Display Accelerator
Ulncorponted
Section 6: PCI Bus Interface
The pinout and other specifications for the RAMDAC snooping can be disabled via CR34_2.
86CM65 are in complete conformance with Revi PCI read burst cycles can be disabled via CR3A_7.
sion 2.1 ofthe the PCI specification. No glue logic
is required.
6.1 PCI CONFIGURATION
The Vendor ID register (Index OOH) in the PCI
Configuration space is hardwired to 5333H to
specify 53 Incorporated as the vendor. The
Device ID register is hardwired to 8811.
Bits 10-9 of the Status register (Index 06H) are
hardwired to 01b to specify medium DEVSEL
timing. The Class Code register (Index 08H) is
hardwired to 30000xxH to specify that the
86CM65 is a VGA compatible device. Bits 3-0 of
the Base Address 0 register (Index 10H) are hard
wired to OOH. This indicates that the ·prefetch
able" bit is cleared to 0, the base register can be
located anywhere in a 32-bit address space and
the base register is located in memory space.
When the 86CM65 powers up in a PCI configura
tion, it defaults to linear addressing and memory
mapped I/O enabled at a relocatable base ad
dress of 7000 OOOOH. This allows the PCI system
to reconfigure as required for plug and play.
6.2 PCI CONTROLS
The 86CM65 provides several methods of con
trolling PCI Bus operation. PCI disconnects are
enabled via CR66_3 and CR66_7. The RAMDAC
snoop method is selected via CR34_0. PCI master
abort handling during RAMDAC snooping can be
disabled via CR34_1. PCI retry handling during
PCI BUS INTERFACE 6-1

86CM65 Dual Display Accelerator
S3lnoorpontecl

86CM65 Dual Display Accelerator
83 Incorporated
Section 7: Display Memory
The 86CM65 supports a DRAM-based video with the MCLK frequency used in the design. The
frame buffer. This section describes the configu type of DRAM operation used is specified via
rations supported, the functional timing for CR36_3-2, which can be programmed at reset via
memory accesses and the operation of various power-on strapping of PD[3:2]. The default is fast
register bits that affect memory timing and op page.
eration. It also describes how access to display
memory is controlled to maximize graphics per Either 256Kx16 dual-CAS or 512Kx32 quad-CAS
formance. DRAMs are supported. These two types cannot
be mixed. A Tech Note lists recommended
DRAMs.
7 .1 DISPLAY MEMORY
CONFIGURATIONS Figure 7-1 shows 1-and 2-MByte configurations
using 256Kx16 DRAMS. Either fast page or EDO
The 86CM65 uses fast page mode or extended memory can be used. The PD bus with 1 MByte
data out (EDO) DRAMs for its frame buffer. EDO of memory is 32 bits. This reduces performance
DRAMs must be capable of 1-cycle operation
PO[63:O)
-
I- 25~ PO[15:0) 2~ PD[47:32]
OE ~
FiiS RAS
CAS1 ~
CASii em
WE WE
MA[B:O)
B6CMB5
... -
25=6Kx-16 PO[31:16) 25r6 Kx16 PO[63:46)
~
RAS RAS
IcAs&
CAS2
CAS3 CAifi
WE WE
RAM CONTROL
\ )
y y
M12MB
1STMBYTE 2NOMBYTE
Figure 7-1. 256Kx16 DRAM Configurations
DISPLAY MEMORY 7-1

86CM65 Dual Display Accelerator
83 Incorporated
and the number of video modes available as The number of refresh cycles performed per hori
compared with 64-bit PO bus operation. zontalline is determined by bit 6 of CR11. If bit 2
of CR3A is set to 1, the number of refresh cycles
Figure 7-2 shows 2-and 4-MByte configurations per horizontal line is determined by the setting of
using 512Kx32 DRAMs. The PO bus with 2 MBy bits 1-0 ofCR3A. Refreshes are performed during
tes of memory is 32 bits. This reduces perform the horizontal blanking period.
ance and the number of video modes available
as compared with 64-bit PO bus operation. Note During power saving modes, 86CM65 supports
that pin M17 is automatically configured as MAe slow refresh based on the 32 MHz clock or self
when 512Kx32 DRAMs are specified. refresh, assuming the DRAMs can support these.
The desired selection is made via SR29_7-6 as
Table 7-1 Memory Size/PO Bus Width follows:
S j ~ec if·IC atio n
CR367-5 Mem. Type Size/Width 00 = Normal (8 ms)
01 = 16 ms slow refresh
001 256Kx16 1 MB/32-biti
10 = 64 ms slow refresh
010 512Kx32 2 MB/32-bit 11 = self-refresh
011 256Kx16 2 MB/64-bit
111 512Kx32 4 MB/64-bit The system BIOS needs to be aware ofthe DRAM
capabilities and set these bits appropriately.
7 .2 DISPLAY MEMORY REFRESH
7.3 DISPLAY MEMORY
FUNCTIONAL TIMING
The 86CM65 supports several DRAM refresh
methods. For normal operation, it uses the stand
ard CAS before RAS method. The functional tim Figure 7-3 shows the functional timing for a fast
ing for this can be found in any standard DRAM page mode read cycle. This also shows how
data book. certain parameters for various control signals
can be adjusted to meet the access time require-
PD[63:0]
512Kx32
- ~
OE
iiAS PD[31:0]
C W A E S o 1ST2MBYTES
CASl
CAS2
CAS3
MA[9:0]
86CM65 ..
512Kx32
~ PD[63:32]
~
IF:;I
I
~RAM
CONTROL
M4MB
Figure 7-2. 512Kx32 DRAM Configurations
7-2 DISPLAY MEMORY

86CM65 Dual Display Accelerator
83 Incorpora'ad
ments of a variety of DRAMs. Bits 1-0 of CR68  Figure 7-4 shows the functional timing for a fast
allow the pulse widths of the CAS and OE signals  page mode write cycle. The RAS and CAS signals
to be adjusted. Bit 2 of CR68 and bit 15 of  can be adjusted as explained for the read cycle
MM81EC allow adjustment ofthe RAS low time.  above. The WE can be delayed via bits 4-3 of
| Bit 3 of CR68 and bit 16 of MM81EC allow adjust  |     |     | CR6F.  |     |     |
| ------------------------------------------------ | --- | --- | ------ | --- | --- |
ment of the RAS precharge (high) time. The set
tings in CR68 can be  made by power-on  Figure 7-5 shows the functional timing for a fast
strapping of PD[23:16) at reset. All settings can  page mode write follwing a read cycle. This is a
| be changed by programming after reset.  |         |     | 1-wait state cycle.  |     |      |
| --------------------------------------- | ------- | --- | -------------------- | --- | ---- |
|                                         |         | T4  |                      | T7  | T9   |
|                                         | T1  T2  | T3  | T5  T6               | T8  | T10  |
MCLK
|     | SEE NOTE 1  | -{- SEE NOTE 2  |     |     |     |
| --- | ----------- | --------------- | --- | --- | --- |
+- LATCHING -
\
J~SEENOTE /~
|          | V   |      |         |         | ~)()()( )(  |
| -------- | --- | ---- | ------- | ------- | ----------- |
| MA[8:0]  |     | ROW  | COLUMN  | COLUMN  | :x  :x      |
:xx  ~\
\
i
J""-..
-~
SEE NOTE 3
|     |     |     | :JSX  | - ~ - |     |
| --- | --- | --- | ----- | ----- | --- |
PD[63:0)  :xx  :xx  :x  :x:xx  :x:)(  DATA n   :xx  Ik  :x  :x
|     | )(X  |     |     | .:1 \ DATA  |     |
| --- | ---- | --- | --- | ----------- | --- |
MWMRD
Figure 7·3. Fast Page Mode Read Cycle
Notes
1. The minimum RAS precharge time can be adjusted from 2.5 to 3.5 MCLKs via CR68_3. to 1.5
MCLKs via MM81EC_16. and reduced by 0.5 MCLK via CR58_7.
2. This figure shows a RAS low time for a single column access of 3.5 MCLKs. (The dashed line
shows the RAS signal if the second page mode cycle were to be eliminated.) This RAS active
time can be changed to 4.5 MCLKs via CR68_2 orto 2.5 MCLKs via MM81EC_15 and increased
by 0.5 MCLK via CR58_7.
3. The CAS and OE active (low) times can be stretched via bits 1-0 of CR68.
DISPLAY MEMORY  7-3

86CM65 Dual Display Accelerator
S3 Incorporllted
no
|     | n  T2  | T3  T4  | T5  T6  | T7  T8  | T9  |
| --- | ------ | ------- | ------- | ------- | --- |
MCLK
|     | ______. ..,-\- | SEE NOTE 2  |     |            |     |
| --- | -------------- | ----------- | --- | ---------- | --- |
|     |                |             | \   | u::-Lj./,  |     |
......... SEE NOTE 3 ~
|          |                   | ---IX  |         | X       |           |
| -------- | ----------------- | ------ | ------- | ------- | --------- |
| MA[8:0]  | ~\.. ___R_ OW_'_  | _      | COLUMN  | COLUMN  | ~~~~~'m'  |
|          |                   |        |         | /1      | /1        |
""E~E\
n'  NOTE ;.
| ~,-       |     |     |                 | ..IX\.. __O _A_T_A_...J~  |     |
| --------- | --- | --- | --------------- | ------------------------- | --- |
| PO[63:0]  |     |     | __O _A_T_A_  _  |                           |     |
MMEMWII
Figure 7-4. Fast Page Mode Write Cycle
Notes
1. The minimum RAS precharge time can be adjusted from 2.5 to 3.5 MCLKs via CR68_3, to 1.5
MCLKs via MM81EC_16, and reduced by 0.5 MCLK via CR58-'.
2. This figure shows a RAS low time for a single column access of 3.5 MCLKs. (The dashed line
shows the RAS signal if the second page mode cycle were to be eliminated.) This RAS active
time can be changed to 4.5 MCLKs via CR68.-2 or to 2.5 MCLKs via MM81EC_15 and increased
by 0.5 MCLK via CR58_7.
3. The CAS active (low) time can be stretched via bits 1-0 of CR68 and the WE active time delayed
via bits 4-3 of CR6F.
7-4  DISPLAY MEMORY

86CM65 Dual Display Accelerator
53 Incorporated
|     |     |     | T3  T4  | T5  | T6  | T7  | T8  T9  | T10  |
| --- | --- | --- | ------- | --- | --- | --- | ------- | ---- |
|     | T1  | T2  |         |     |     |     |         |      |
MCLK
______________
|     |     |     | \~  |     |     |     | ~r-- |     |
| --- | --- | --- | --- | --- | --- | --- | ---- | --- |
|     |     |     |     |     | LJ  |     | L    | J   |
---JX
|         | Y YYYYY YYJ./'- | ___ |            |      |         | \ l l N    |         | ~   |
| ------- | --------------- | --- | ---------- | ---- | ------- | ---------- | ------- | --- |
| M A [ 8 | : 0 ]           |     | R_ OW_  _  |      | COLUMN  | f' < i 1\  | COLUMN  |     |
| M B [ 8 | : 0 ]   ~ _     |     |            | . .  |         |            |         |     |
LJ
\\-----1'
| PD[63:0]  |     |     |     |     |     |     | WRITE DATA  | ~   |
| --------- | --- | --- | --- | --- | --- | --- | ----------- | --- |
FPRION
Figure 7-5. Fast Page Write Following a Read Cycle
|     |     |     |     |     |     |     | DISPLAY MEMORY  | 7-5  |
| --- | --- | --- | --- | --- | --- | --- | --------------- | ---- |

86CM65 Dual Display Accelerator
53 InllOlJlOrated
If EDO memory is used, the 86CM65 must be  Figure 7-6 shows the functional timing for a 2-cy
configured for 1-cycle operation (CR36_3-2  =  cle EDO mode read cycle. One difference be
11 b). However, the 86CM65 will not always initi  tween an EDO read cycle and a fast page mode
ate 1-cycle operation. Some operations, such as  read cycle is that EDO memory holds the data
linear addressing (direct CPU  accesses to the  valid longer, allowing it to be latched one cycle
frame buffer) are always done using 2-cycle EDO  later (rising edges ofT8 and T10). This allows the
| accesses.  |     |     |     |     | use of slower access time memory or a faster  |     |     |     |
| ---------- | --- | --- | --- | --- | --------------------------------------------- | --- | --- | --- |
MCLK. Therefore, the last page access (or first for
a single access) is one MCLK longer. Note that
|     | T1  | T2  | T3  T4  | TS  | T6  | T7  | T8  | T9  T1D  |
| --- | --- | --- | ------- | --- | --- | --- | --- | -------- |
MCLK
_{~'
|     | SEE NOTE 1  |     | ________________________+  |     |     |     | -________ |     |
| --- | ----------- | --- | -------------------------- | --- | --- | --- | --------- | --- |
- J
\'-----'f]0-1j~
|          |      |           | --IX  |     |         | X   | SEE NOTE 3  |     |
| -------- | ---- | --------- | ----- | --- | ------- | --- | ----------- | --- |
|          | ~,-- |           |       |     |         |     |             | ~   |
| MA[8:D]  |      | __R_ OW_  | _     |     | COLUMN  |     | COLUMN      |     |
t i
| OED       |       |     |     |     | \                 |     | SEE NOTE 3  |         |
| --------- | ----- | --- | --- | --- | ----------------- | --- | ----------- | ------- |
|           | ~ I~  |     |     |     |                   |     | Ix          |         |
| PD[63:0]  |       |     |     |     | '----D-A+TA' .-o  |     |             | DATA    |
|           |       |     |     |     |                   |     | LATCHING _  | MEDOMR  |
Figure 7-6. 2-cycle EDO Mode Read Cycle
Notes
1. The minimum RAS precharge time can be adjusted from 2.5 to 3.5 MCLKs via CR68_3, to 1.5
MCLKs via MM81EC_16, and reduced by 0.5 MCLK via CR583.
2. This fiaure shows a RAS low time for a sinale column aCCeSS of 3,5 MClKs. !The dashed line
shows-the RAS signal if the second page mode cycle were to be eliminated.) This RAS active
time can be changed to 4.5 MCLKs via CR68_2 or to 2.5 MCLKs via MM81EC_15 and increased
by 0.5 MCLK via CR58]
3. The CAS and OE active (low) times can be stretched via bits 1-0 of CR68.
7-6  DISPLAY MEMORY

86CM65 Dual Display Accelerator
53 IncorpontMl
| n   |         |     |     |         |         | no  |
| --- | ------- | --- | --- | ------- | ------- | --- |
|     | T2  T3  | T4  | T5  | T6  17  | T8  T9  |     |
MCLK
,~-----------------------
|     |     |     | LJ  |     | LJ  |     |
| --- | --- | --- | --- | --- | --- | --- |
___
'f!1/..'--__
| ::l:~~J  ~,- |        | ....JX  |         |     |                        | ~   |
| ------------ | ------ | ------- | ------- | --- | ---------------------- | --- |
|              | R_O_W  | __      | COLUMN  |     | C_O_L_U_M_N ___. ....  |     |
''--_---II
LJ
'IlJj.
| PD[63:O]  _  |     |     |     | READDATA  | WRITEDATA  | ~   |
| ------------ | --- | --- | --- | --------- | ---------- | --- |
EDOAMW
Figure 7-7. 2-cycle EDO Write Following a Read Cycle
RAS, the last CAS and OE are all stretched the  read data is latched later than for a fast page
extra MCLKand OE is held low for the entire cycle  mode cycle, there is less time available between
| instead of being pulsed as in a fast page mode  |     |     | the read and write.  |     |     |     |
| ----------------------------------------------- | --- | --- | -------------------- | --- | --- | --- |
cycle.
| The timing adjustments for RAS  |     | and  for  |     |     |     |     |
| ------------------------------- | --- | --------- | --- | --- | --- | --- |
CAS/OEMIE as described above for a fast page
mode read cycle also apply to EDO cycles. Note
that if the minimum RAS active time is specified
as 3.5 MCLKs, the actual minimum for a single
EDO read cycle will be 4.5 MCLKs.
A 2-cycle EDO write cycle is functionally the same
as a fast page mode write cycle.
Figure 7-7 shows the functional timing for an
EDO mode write following a read cycle. Since
|     |     |     |     |     | DISPLAY MEMORY  | 7-7  |
| --- | --- | --- | --- | --- | --------------- | ---- |

••
r
86CM65 Dual Display Accelerator
83 Incorpor_d
The functional timing for 1-cycle EDO reads and
writes is provided by Figure 7-8. The DRAM
drives valid read data after the CAS falling edge
in T5. The chip latches the data on the next falling
CAS edge. Note that a dummy cycle is required
at the end to latch the last read. Write data is
latched by the DRAM on the falling edge of CAS ..
No dummy cycle is required. so RAS rises one
cycle earlier than shown in Figure 7-8 and the last
CAS shown in the figure does not occur.
Figure 7-9 shows a write following a read cycle
with 1-cycle EDO operation. A dummy cycle is
added between the read and write.
|     | T1  T2  | T3  T4  | T5  T6  | T7  T8  | T9  |
| --- | ------- | ------- | ------- | ------- | --- |
MCLK
\'----------'/
|     |     |     | ..JX  X  | X  XDUMMY&  |     |
| --- | --- | --- | -------- | ----------- | --- |
___
| :~(:~g~  | ~'_  |             |               |       |     |
| -------- | ---- | ----------- | ------------- | ----- | --- |
|          |      | R_O_W_  __  | COL 1  COL 2  | COL3  |     |
\'-----_-----1/
E2
X  X
~RD1
| PD[63:0]  |     |     |                 | RD2  RD3  |     |
| --------- | --- | --- | --------------- | --------- | --- |
|           |     |     | \'---_ _- --J/  |           |     |
X
| ~ ~       |     |     |           | X    |     |
| --------- | --- | --- | --------- | ---- | --- |
| PD[63:0]  |     |     | WR1  WR2  | WR3  |     |
SCEDORW
Figure 7-8. 1-cycle EDO Mode Read/Write
7-8  DISPLAY MEMORY

86CM65 Dual Display Accelerator
S3 Incorporated
T1 T2 T3 T4 T5 T6 T7 T8 T9
MCLK
_____- -II
\~
u
___
=~l:;g~ ~,- RD~COLWR~
R_O_W_ __- ,XCOL
'''--_--II
'''---II
PD[63:0]
SCEOORMW
Figure 7-9. 1-cycle EDO Write Following a Read Cycle
DISPLAY MEMORY 7-9

86CM65 Dual Display Accelerator
7 .4 DISPLAY MEMORY ACCESS ciated with the M parameter (CR54_2, 7-3 for the
CPU and Graphics Engine, CR76_5-0 for the LPB).
CONTROL
Note that these are not the same as the PLL M
and PLL N parameters used to specify the clock
A number of processes compete for access to synthesizer frequencies.
display memory. These competing processes are
(in decreasing order of access priority): When the 86CM65 transfers data from display
memory to the primary or secondary stream
• Font fetch (text mode) FIFO, the N parameter specifies the number of
• Primary Stream high (N parameter) MCLKs available for FIFO filling before memory
• Secondary Stream high (N parameter) control is given up for M parameter processes.
Note that this parameter is only effective when
• DRAM refresh both FIFO threshold values are equal to or above
• Controller 2 high the threshold level and therefore have low prior
• STN read high ity. Because of this, the FIFO threshold values
have by far the greatest effect on performance.
• STN write high The Nand M parameter settings will normally
• Hardware cursor fetch have little effect and can be left at their initial
• Hardware icon BIOS settings.
• LPB writes (M parameter)
When N is effective and when N MCLKs have
• CPU accesses (M parameter) been used or the FIFO is filled, whichever comes
• Graphics Engine accesses (M parameter) first, the 86CM65 then allows the other display
memory processes access to memory. Filling of
• Primary Stream low (N parameter)
the FIFO also stops at the end of active display.
• Secondary Stream low (N parameter) FIFO filling cannot begin again until the scan line
• Controller 2 low position defined by the Start Display FIFO regis
ter (CR3B), which is normally programmed with
• STN read low
a value 5 less than the value programmed in CRO
• STN write low (horizontal totall. This provides time during the
horizontal blanking period for RAM refresh and
The processes with high and low priorities have hardware cursor fetch.
associated threshold register fields (MM81EC,
bits 14-10 and 9-5, SR29).lfthe current FIFO slots The M parameter speCifies the number of MCLKs
empty count is equal to or above the threshold available for the processes shown in the bullet
level for a process, that process is given its low list above. When this number of MCLKs has oc
priority. Once the threshold is passed, the proc curred, memory control is returned for FIFO fill
ess is given its high priority. ing. If during the processing period controlled by
the M parameter there is time when there are no
The primary and secondary stream processes are memory access requests and the M value has not
responsible for screen refreshing and are associ been reached, control is immediately returned to
ated with the N parameter. N parameters are FIFO filling as specified by the N parameter.
provided for the following:
Note that the M and N parameters should only
Primary Stream -CR60_7-O be changed with the screen turned off. This is
Secondary Stream - CR72_7-0 done by setting bit 5 of SR1 to 1.
Controller 2 -CR73_6-0
STN -CR75_7_0
RAM refresh and hardware cursor fetch occur
during blanking when FIFO fetches are not occur
ring. (RAM refresh can also occur outside of the
blanking interval.) The other processes are asso-
7-10 DISPLAY MEMORY

86CM65 Dual Display Accelerator
53 Incorponted
Section 8: Clock Synthesis and Control
The 86CM65 contains two phase-locked loop The PLL M value can be programmed with any
(PLL) frequency synthesizers. These generate the integer value from 1 to 127 for MCLK and 1 to 255
DCLK (video clock) and MCLK (memory clock for DCLK. The binary equivalent of this value is
signals for the graphics controller block. programmed in bits 6-0 ofSR11 for the MCLKand
in bits 7-0 of SR13, SR22 or SR24 for the DCLK.
The PLL feedback loop frequency from the volt
8.1 CLOCK SYNTHESIS
age controlled oscillator stage is scaled by divid
ing that frequency by (M+2).
Each PLL scales a single reference frequency
input on the XIN pin. By placing a parallel-reso The PLL N value can be programmed with any
nant crystal between the XOUT output pin and integer value from 1 to 31 for MCLK or 1 to 63 for
the XIN pin, the reference frequency is generated DCLK. The binary equivalent of this value is pro
by the 86CM65's internal oscillator. Alternately, grammed in bits 4-0 of SR10 for the MCLK and in
a CMOS-compatible clock input can be con bits 5-0 ofSR12, SR21 or SR23 for the DCLK. The
nected to XIN to provide the reference frequency. reference frequency is divided by (N+2) before
being fed to the phase detector stage ofthe PLL.
The frequency synthesized by each PLL is deter
mined by the following equation: The PLL R value is a 2-bit range value that can be
programmed with any integer value from 0 to 3.
The R value is programmed in bits 6-5 of SR 10
four= (M+2) R x fREF
for MCLK and bits 7-6 of SR12, SR21 or SR23 for
(N+2)x2
DCLK. This value codes the selection of a fre
quency divider for the PLL output. This is shown
where R = 0, 1,2 or 3
Table 8-1.
Programmed PLL M and PLL N values should be
Table 8-1. PLL R Parameter Decoding
consistent with the following constraints:
R-Range Code Fr~ue~ Divider
1 135MHz:s; (M+2)fREF < 270MHz
. (Nt2) - 00 1
01 2
2. min N~ 1 10 4
11 8
Note that values used for the parameters are the
integer equivalents of the programmed value. In
The entire PLL block diagram is shown in Figure
particular, the R value is the code, not the actual
8-1.
frequency divisor.
CLOCK SYNTHESIS AND CONTROL 8-1

86CM65 Dual Display Accelerator
sa Incorporated
fREF  four
ICPUB'"
Figure 8-1. PLL Block Diagram
The following sequence may be followed to ar  taken from SR12 and SR13. No default values are
rive at M and N values for any mode.
defined for these registers.
1. Calculate an R which does not violate the  New DCLK PLL parameter values can be pro
following constrains:  grammed at any time. They can be loaded in one
of two ways. If bit 5 of SR15 is cleared to 0, the
135MHz< 2RxfoUTS, 270MHz  new DCLK frequency is loaded by setting bit 1 of
SR15 to 1. Bit 1 of SR15 should be left at a value
2. Start with N1 = 1 and calculate:
of 1. Actual loading will be delayed for a short but
variable period of time.
M= [fOUTX (N+2) x2R 1_ 2
fREF  The alternate approach to loading the new DCLK
3.  Determine if the following constraint is met:  frequency is to toggle bit 5 of SR15 by program
ming itto a 1 and then a O. This immediately loads
(Mi-2) fREF  the DCLK (and MCLK) frequencies (no variable
R < 1.005 fOUT  delay). For example, pseudocode to change
0.995 fOUT<
(N+2) 2  DCLK to the frequency specified by PLL parame
| 4. If the constraint in step 3 is met, the M and  | ter values of 34H and 56H is:  |     |
| ------------------------------------------------- | ------------------------------ | --- |
N values used will generate the desired
| frequency (within the specified tolerance).     | 3C2  <=  6FH  | DCLK  specified by  |
| ----------------------------------------------- | ------------- | ------------------- |
| If the constrain is not met, repeat steps 2     |               | SR12  and SR13      |
| and 3 with N increased by 1 each time un        | 3C4  <=  12H  | SR12  index         |
| til the constraint in step 3 is met. Note that  | 3CS  <=  34H  | SR12  PLL value     |
multiple combinations of M and N are pos
|                                      | 3C4  13H      | SR13  index      |
| ------------------------------------ | ------------- | ---------------- |
| sible for a given output frequency.  | <=            |                  |
|                                      | 3CS  <=  S6H  | SR13  PLL value  |
|                                      | 3C4  <=  lSH  | SR1S  index      |
8.2  CLOCK REPROGRAMMING
|     | 3CS  <= RMW  | Use read/modify/write to  |
| --- | ------------ | ------------------------- |
set bit 5 to 1 and leave
If 3C2_3-2 = OOb, the DCLK PLL parameters are
other bits unchanged
taken from SR22 and SR23. The default values
|     | 3CS  <= RMW  | Use read/modify/write to  |
| --- | ------------ | ------------------------- |
generate a frequency of 25.125 MHz. This is the
clear bit 5  to 0 and
DCLK frequency generated at power on to sup
leave other bits
| port standard VGA operation.  |     | unchanged  |
| ----------------------------- | --- | ---------- |
If 3C2_3-2 = 01b, the DCLK PLL parameters are  Either ioading approach shouid work. The sec
taken from SR24 and SR25. The default values
ond (immediate loading) approach helps with
generate a frequency of 28.322.
system testing since the timing of the load is
predictable. The first approach (via bit 1 of SR15)
For Enhanced mode operation, 3C2_3-2 are pro
has the advantage of separating the loading of
grammed to 11 b and the DCLK PLL values are
DCLK from that of MCLK.
8-2  CLOCK SYNTHESIS AND CONTROL

86CM65 Dual Display Accelerator
S3 Incorporated
After power-up, all MCLK frequency changes controller 1 path. This is the path that includes
must be made by re-programming SR10 and the Streams Processor. DCLK2 is the pixel rate
SR11. If bit 5 of SR15 is cleared to 0, the new associate with the controller 2 path. How these
frequency doe°s n ot take effect until a 1 has been are derived is shown in Figure 8-2. The first MUX
written to °bi t of SR15. This bit must then be selection is made via SR28_3-2 and the second
cleared to to prevent repeated loading. Actual via SR283-4.
loading will be delayed for a short but variable °
period of time. Bit of CR67 provides the option to invert DCLKA.
As explained above for DCLK, toggling bit 5 of In color mode 8, the internal RAMDAC requires
SR15 (0,1,0) immediately loads both the DCLK two clocks. The normal internal DCLK frequency
values in the register pair selected by 3C2_3-2 is divided by two via bit 4 of SR15 to provide the
and the MCLK values in SR10 and SR11. standard pixel clock input. Undivided DCLK1 pro
vides the other input. This clock can be inverted
via bit 6 of SR15.
8.3 CLOCK SELECTION AND
CONTROL Certain 4 bits/pixel modes require that DCLK1 be
halved. This is done with bit° 6 of AR10 set to 1
MCLK is used to drive the memory interface and and bit 4 of CR3A cleared to and is enabled by
Graphics Engines. It normally is the MCLK gen setting bit 4 or SR15 to 1.
erated by the internal clock synthesizer. How
ever, other clocks can be used as well as shown
in Figure 8-2. SR27 _3-0 are programmed to make
the selection.
DCLK is generated by the internal clock synthe
sizer. DCLK1 is the pixel rate associated with the
DCLK
MCLK
SCLK
MCLK
DCLK
MCLK
SCLK
DCLK1 (CONTROLLER 1 PATH)
DCLK
MCLK
SCLK
DCLK2 (CONTROLLER 2 PATH)
ClKSEL
Figure 8-2. Clock Selection
CLOCK SYNTHESIS AND CONTROL 8-3

86CM65 Dual Display Accelerator
S3 Incorporated

86CM65 Dual Display Accelerator
83 Incorpor-.d
Section 9: Streams Processor
The S3 Streams Processor processes data. from 2. Secondary Stream -RGB or YUV/YCbCr
the graphics frame buffer, composes it and out (video) data from another region within
puts the resultto the internal DACs for generation the frame buffer
of the analog RGB outputs to the monitor. The 3. Hardware Icon -64x64x4 (or 12Bx12Bx2).
general data flow is shown in Figure 9=1. Note
4. Hardware Cursor -64x64x2 cursor, either
that the DAC shown in this figure is inside the
Microsoft or X-ll definition.
86CM65.
Regardless of the input formats, the Streams
9.1 INPUT STREAMS Processor creates a composite RGB-24 (B.B.B)
output to the DACs. This means that, for exam
The processor can compose data from up to 4 ple, RGB-B pseudo-color graphics data can be
independent streams as shown in Figure 9=1. overlaid with true-color-equivalent (24 bits/pixel)
video data. The result is improved video quality
1. Primary Stream -RGB graphics data and/or reduced memory bandwidth require
ments as compared with systems that require
both graphics and video to be stored in the same
GRAPHICS
FRAME BUFFER
~-----------------,
GRAPHICS BUFFER 0
S B K
C L E
AEy
GRAPHICS BUFFER 1 [ MONITOR)
L N I
IDN
NIG
SPRITENIDEO 0
G N
G
SPRITENIDEO 1
STREAMS PROCESSOR
HARDWARE
------------------~
ICON AND CURSOR
Figure 9·1. Streams Processor
STREAMS PROCESSOR 9-1

86CM65 Dual Display Accelerator
83 lnaorponted
frame buffer format. In certain modes, the also be RGB, YUV or YCbCr data written to the
Streams Processor also saves memory band frame buffer by some video source (CPU, de
width by eliminating the need to save and restore coder, digitizer). The format for this data can be
the overlay background since the background any of the following as selected via bits 26-24 of
(primary stream) is never overwritten in the MMS190.
frame buffer.
• YCbCr-16 (4.2.2),16 -240 input range
Streams Processor support is not available for
• YUV-16 (4.2.2), 0 -255 input range
clock-doubled S bits/pixel modes, interlaced
graphics modes and standard VGA modes except • KRGB-16 (1.5.5.5) -The K bit is the color
key.
for modes D, E, 10, 12 and 13.
• YUV (2.1.1)
Bits 3-2 of CR67 specify the Streams Processor
• RGB-16 (5.6.5)
mode of operation. If they are cleared to OOb,
• XRGB-32 (X.S.S.S) -X is the ignored up
Streams Processor operation is disabled. They
per byte.
are programmed to 01 b when the primary stream
is VGA mode D, E, 10, 12 or 13 (the only sup
ported modes). A secondary stream can be over The data can be passed through unscaled or
scaled up horizontally and vertically by an arbi
laid on the primary stream. CR67 _3-2 are set to
11 b to support an Enhanced mode primary trary amount. YCbCr/YUV data is color space
stream and a secondary stream. converted and all data is converted to RGB-24
(S.S.S) format.
9.1.1 Primary Stream Input
9.1.3 Hardware Icon and Cursor
Generation
The primary stream is generated by reading the
RGB pixel data written to the frame buffer by the
graphics controller. The format for this data can Hardware icon and cursor generation is ex
be any of the following as selected via bits 26-24 plained in Section 16. The icon overlays every
ofMMS1S0. thing but the cursor. The cursor overlays all other
image sources.
• RGB-S (Although not shown in Figure 1,
the frame buffer data is first passed
9.1.4 Frame Buffer Organizationl
through the internal RAMDACs color
lookup table (CLUT), where it is palet Double Buffering
tized before being passed to the
Streams Processor. For each stream to be used, the starting location
• KRGB-16 (1.5.5.5) -The K bit is the color (offset) in the frame buffer and the stride (byte
key. offset between vertically adjacent pixels on the
screen) must be specified. Both the primary and
• RGB-16 (5.6.5)
the secondary streams can be double buffered as
• XRGB-32 (X.S.S.S) -X is the ignored up depicted in Figure 9=1. This means that duplicate
per byte. frame buffer storage can be provided for both the
primary and secondary image (or for either one
of them). With double buffering, the programmer
9.1.2 Secondary Stream Input
can rapidly switch from one primary or secon
dary image to the other. In addition, having two
The secondary stream is generated by reading images allows more time for updating one image
pixel data from a separate section of the frame while the other is being displayed. Defining the
buffer than that used to generate the primary frame buffer organization and implementing
screen. This might be RGB data written by the double buffering are done via the register fields
graphics controller, such as a sprite used by described in Table 4-1. LPB stands for Local Pe
game programmers for moving objects. It could ripheral Bus.
9~2 STREAMS PROCESSOR

••
r
86CM65 Dual Display Accelerator
83 Incorporated
Table 9=1. Register Fields Used For Specifying Frame Buffer Organization and Double Buffering
Register Field Description
o.
MMB1CO_21-0 Primary Display Buffer Address This is the starting address (offset) in the
frame buffer for 1 primary graphics image.
MMB1C4_21-O Primary Display Buffer Address 1. This is the starting address (offset) in the
frame buffer for a second primary graphics imaRe.
MMB1CB_11-O Primary Stream Stride. This is the byte offset in the frame buffer from a pixel in
a given primary image display line to the pixel directly below it on the next
display line. The stride must be the same for both primary buffers.
MMB1CC_0 Primary Stream Buffer Select
0= Primary frame buffer starting address 0 (MMB1CO_21-0) used for primary
stream
1 = Primary frame buffer starting address 1 (MMB1C4_21-0) used for primary
stream
MMB1CC_2-1 Secondary Stream Buffer Select
00 = Secondary frame buffer starting address 0 (MMB1 00_21-0) used for the
secondary stream
01 = Secondary frame buffer starting address 1 (MMB1D4_21-0) used for the
secondary stream
10 = Secondary frame buffer starting address 0 (MMB100_21-0) used for the
secondary stream and LPB frame buffer starting address 0 (MMFFOC_21-0)
used for the LPB input stream OR secondary frame buffer starting address
1 (MMB1D4_21-0) used for the secondary stream and LPB frame buffer
starting address 1 (MMFF10_21-O) used for the LPB input stream. Which
alternative applies is determined by LPB starting address register selected
by bit 4 of this register.
11 = Secondary frame buffer starting address 0 (MMB1DO_21-0) used for the
secondary stream and LPB frame buffer starting address 1 (MMFFOC_21-0)
used for the LPB input stream OR secondary frame buffer starting address
1 (MMB1D4_21-0) used for the secondary stream and LPB frame buffer
starting address 0 (MMFF10_21-0) used for the LPB input stream. Which
alternative applies is determined by the LPB starting address register
selected by bit 4 ofthis register.
MMB1CC_4 LPB Input Buffer Select
0= LPB frame buffer starting address 0 (MMFFOC_21-0) used for LPB input
1 = LPB frame buffer starting address 1 (MMFF10 21-0) used for LPB input
MMB1CC_5 LPB Input Buffer Select Loading
o
= The value programmed in bit 4 of this register takes effect immediately
1 = The value programmed in bit 4 of this register takes effect at the end of the
next frame (completion of writing all the data for a frame into the frame
buffer)
MMB1CC_6 LPB Input Buffer Select Toggle
0= End of frame (completion of writing all the data fro a from into the frame
buffer) has no effect on the setting of bit 4 ofthis register
1 = End of frame causes the setting of bit 4 of this register to toggle
STREAMS PROCESSOR 9-3

86CM65 Dual Display Accelerator
83 Inoorpor8teti
Table 9=1. Register Fields Used For Specifying Frame Buffer Organization and Double Buffering
(continued)
Register Field Description
MMB1CC_7 Dropped Frame Writing
0= The dropped frames specified in bits 10-B of this register are written to the
frame buffer
1 = The dropped frames specified in bits 10-B of this register are not written to
the frame buffer
MMB1CC_10-B Frame Dropping
Value = 1 less than the number of frames to drop between captured frames
Bit 7 of this register determines whether or not the dropped frames are written
to the frame buffer.
MMB1DO_21-Q Secondary Display Buffer Address O. This is the starting address (offset) in the
frame buffer for 1 secondary graphics or video image.
MMB1D4_21-Q Secondary Display Buffer Address O. This is the starting address (offset) in the
frame buffer for a second secondary graphics or video image.
MMB1DB_11-Q Secondary Stream Stride. This is the byte offset in the frame buffer from a
pixel in a given secondary image display line to the pixel directly below it on
the next disDlav line. The stride must be the same for both secondary buffers.
MMFFOC_21-Q LPB Frame Buffer Address O. This is the starting address (offset) in the frame
buffer for one image buffer into which is written data from the LPB. The
secondary stream can be generated from this buffer.
MMFF10_21-Q LPB Frame Buffer Address 1. This is the starting address (offset) in the frame
buffer for a second image buffer into which is written data from the LPB. The
secondary stream can be generated from this buffer.
MMB1CC_6 LPB Input Buffer Select Toggle
0= End of frame (completion of writing all the data fro a from into the frame
buffer) has no effect on the setting of bit 4 of this register
1 = End of frame causes the setting of bit 4 of this register to toggle
The secondary stream can be generated from 9.2.1 Primary Stream Processing
data written to the frame buffer via the LPB when
LPB mode is enabled. In this case, the Secondary
The primary stream input RGB format is con
Display Buffer Address 0 and the LPB Frame
verted (if required) to RGB-24 (B.B.B) format. Each
Buffer Address 0 will normally be the same, as
color byte is padded as required with low order
will the Address 1's for both the secondary
zeros. After this conversion, the data can be
stream and the LPB input if double buffering is
passed through unscaled or scaled up horizon
used. The various LPB control bits described in
tally and vertically by a factor of 2 via bits 30-2B
Table9=1 allow complete hardware control ofthe
of MMB1BO. For MMB1BO_30-2B = 001, horizontal
capture and display of video data using either
scaling is done via replication. If these bits are
single or double buffering.
programmed to 010, horizontal scaling is done
using interpolation. Vertical scaling is automatic
9.2 and uses line ieplicaiion. The 2x scaiing aiiows a
320x240 image (as used by many games) to be
displayed at a full-screen 640x480 resolution.
Different processing options are available for the
primary and secondary input streams. These are
explained next.
9-4 STREAMS PROCESSOR

86CM65 Dual Display Accelerator
83 Incorpo. .t od
9.2.2 Secondary Stream Processing 9.3 COMPOSITION/OUTPUT
The secondary stream input format is converted A variety of output types can be composed from
(if required) to RGB-24 (8.8.8) format. For the streams described above. The compose
YUV/YCbCr inputs, the required color space con modes are:
version is automatically performed. Before con
version, the data can be passed through unscaled 1. MM81AO_26-24 = OOOb -Secondary stream
or scaled up horizontally and/or vertically byar overlaid on the primary stream in an
bitrary factors. Horizontal scaling uses filtering opaque rectangular window. This is the
for interpolation. Vertical scaling uses line repli default mode and can be used, for exam
cation. The register fields involved in scaling up ple, for a video window overlaying the
the secondary stream are described in Table 9=2. graphics screen. Note that this mode will
Figure 9=2 graphically describes the various not work for the case where the user
fields. needs to pull down a graphics window
over the video since the graphics window
For example, assume a 10x10 window that is to is defined as being under the video win
be scaled up horizontally by a factor of 2.5. The dow. Color keying (number 5 in this list)
filter characteristics are set for bi-linear (2x to 4x must be used for this purpose.
stretch). The starting line width is 10 pixels and
2. MM81AO_26-24 = 001b -Primary stream
the ending line width is 25 pixels. The DDA hori
overlaid on the secondary stream in an
zontal accumulator initial value is 2 (10-1) -(25-1)
opaque rectangular window. This could
= -6. The K1 horizontal factor is 10-1 = 9. The K2
be used, for example, to provide graphics
horizontal factor is 10-25 = -15. Programming
captions for a video window. The video is
these parameters with these values results in a
not visible behind the rectangular graph
2.5x horizontal stretch for the secondary stream
icswindow.
window.
SCREEN START XO
(MM81 FO_26-16r-___________________- ,
WINDOW START X1
(MM81F8~6-16)
X1-XO ..
-+
_ WINDOW WIDTH WO
.....--- BEFORE SCALING
SPWINDEF
Figure 9-2. Screen Definition Parameters
STREAMS PROCESSOR 9-5

86CM65 Dual Display Accelerator
53 InGOl'JlOrated
Table 9=2. Register Fields Used For Scaling Up the Secondary Stream
Register Field Description
MM8190_30-28 Filter Characteristics
000 = Secondary stream (pass-through)
001 = Secondary stream, linear, 0-2-4-2-0, for X stretch
010 = Secondary stream, bi-linear, for 2X to 4X stretch
011 = Secondary stream, linear, 1-2-2-2-1, for 4X stretch
This selection aoolies onlv to horizontal scalina.
MM8190_11-O DDA Horizontal Accumulator Initial Value. Value = 2 (WO-1) -(W1-1), where
WO is the line width in pixels before scaling and W1 is the line width after
scaling. This is a signed value.
MM8198_10-O, K1 Horizontal Factor. Value = WO-1, where WO is the line width in pixels before
scaling. This is a signed value.
MM8198_26-16 K2 Horizontal Factor. Value = WO-W1, where WO is the line width in pixels
before scaling and W1 is the line width after scaling. This is a signed value.
MM81 EO_10-0, K1 Vertical Factor. Value = [height (in lines) of the initial output window
(before scaling)] -1. The initial output window height is the vertical resolution
of the data written to the frame buffer and is shown as HO in Figure 9=2.
MM81E4_10-0, K2 Vertical Factor. Value = 2's complement of {height (in lines) of the initial
output window (before scaling)] -[height (in lines) of the final output window
(after scaling)]
The initial output window height is the vertical resolution of the data written
to the frame buffer and is shown as HO in Figure 9=2. The final value is the
same height value that is programmed in MMB1FC_10-0 and is shown as H1 in
Figure 9=2. This value is then the 2's complement of (H1 -HO).
MM81E8_11-0, DDA Vertical Accumulator Initial Value. Value = 2's complement of [height (in
lines) of the output window after scaling) -1. This is the same height value that
is programmed in MM81FC 10-0 and is shown as H1 in Figure 9=2.
3. MM81AO_26-24 = 010b -Secondary stream 6. MM81AO_26-24 = 110b -Primary stream
blended with the primary stream on a overlaid on the secondary stream in an ir
pixel by pixel basis within the secondary regular window. This requires a
stream window. This is used to provide a color/chroma key. This case allows, for ex
dissolve between two scenes. ample, graphics text to overlay video with
4. MM81AO_26-24 = 011 b -Secondary stream the video appearing around and even in
side of the text characters.
blended with the primary stream on a
pixel by pixel basis within the secondary
stream window. This is used to provide a 9.3.1 Opaque Rectangular
fade between two scenes.
Overlaying
5. MM81AO_26-24 = 101b -Secondary stream
overlaid on the primary stream in an ir
These modes are items 1 and 2 in the compose
regular window. This requires a coior key.
modes list. When one ofthese modes is used, the
This would be used, for example, for
programmer can invoke a feature called opaque
game sprites. Only the graphics area be
overlay control. This is enabled by setting
hind the sprite shape would be covered
MM81DC_31 to 1. If MM81AO_26-24 = OOOb (sec
up.
ondary stream on top), then MM81DC_30 must
9-6 STREAMS PROCESSOR

86CM65 Dual Display Accelerator
S3lncorponted
be cleared to 0 to also specify secondary stream space converter. Note that blending makes sense
on top. Similarly, If MMB1AO_26-24 = 001b (pri only when both streams are defined. In addition,
mary stream on top), then MMB1DC_30 must be when blending is selected, the concept of back
setto 1 to also specify primary stream on top. The groundlforeground or top and bottom window
next step is to define when to stop fetching pixels has no meaning.
for a line from memory and when to restart
fetching them. The goal is to not fetch those Two types of blending are provided: dissolve and
pixels in the background window that are cov fade.
ered up by the opaque rectangular overlay win
dow, thus saving memory bandwidth. When dissolve is chosen, the output pixels are
generated using the following equation:
The first pixel that does not need to be fetched is
at horizontal position X1 shown in Figure 10-2. [Pp x Kp + Ps x (8 -Kp)1/8
This is programmed in MMB158_26-16. The start
ing pixel position for the background (XO) is Pp and Ps are the primary and secondary stream
programmed in MM81FO_26-16. The difference pixel colors respectively, both RGB 8.8.8. Kp is
(X1 -XO) must be converted into quadwords and the primary stream weighting factor. It is a 3-bit
then programmed in MM81 DC_12-3. The value is value programmed in MM81AO_12-10. This
(X1 - XO) x bytes per pixel/8. If the result is a weight value is applied to each of the three color
fraction, it is rounded up to the next highest values for the pixel. If Kp = 0, only the secondary
integer to ensure that the first pixel not fetched stream is displayed. As Kp is increased, more of
in inside the opaque overlay window. Note that the pixel color from the primary stream is
if the secondary stream is in the background, blended into output. At the maximum (Kp = 7 or
then the value is (XO - X1) x bytes per pixel/B, 111 b), 7/8ths of the color will be due to the pri
again rounded up. mary stream and 1/8th will be due to the secon
dary stream. Therefore, by starting with the
Pixel fetching must start again before or at the primary stream only, then overlaying the secon
last pixel position ofthe opaque overlay window. dary stream with Kp values decreasing from 7 to
Using the terms in Figure 10-2, this position is (X1 0, the overlay window can be dissolved gradually
-XO) + W1, with W1 programmed in MM81 FC_26- from primary stream to secondary stream. Note
16 (secondary stream is on top). Converting to that when the Kp value is reprogrammed, its new
quadwords, the value is [(X1 -XO) + W1) x bytes value does not take effect until the next VSYNC,
per pixel/8. If the result is a fraction, the result is so it can be reprogrammed during frame display
truncated to the next lowest integer (minus 1) without disruptive effects.
and programmed in MM81DC_28-19. Note that if
the secondary stream is in the background, then When fade is chosen, the output pixels are gen
(XO - X1) is used and W1 is the value in erated using the following equation:
MM81F4_26-16 (primary stream is on top).
[Pp x Kp + Ps x Ks1/8, where Kp + Ks must be s; 8.
Opaque overlay control cannot be used with key
ing or blending and should never be enabled Ks is the secondary stream weighting factor. It is
when one ofthese modes is being used. a 3-bit value programmed in MM81A03-2. This
weight value is applied to each of the three color
values for the pixel. Note that when fading is
9.3.2 Blending
selected, the default values for Kp and Ks (both
o.
0) result in a color value of As with Kp, when
These modes are items 3 and 4 in the compose the Ks value is reprogrammed, its new value
modes list. The blender accepts the primary and does not take effect until the next VSYNC.
secondary pixel streams and blends them with
an arithmetic weighting. The result is then over
laid with the cursor stream. Both blender inputs
are RGB 8.8.8 from the outputs of the primary
stream interpolator and secondary stream color
STREAMS PROCESSOR 9-7

86CM65 Dual Display Accelerator
sa In.orpol'll. ...
9.3.3 Color/Chroma Keying 9.3.4 Window Location
These modes are items 5 and 6 in the compose The starting X,Y coordinates and window size for
modes list. Keying is a way of selecting on a pixel the primary stream are specified in MM81FO and
by pixel basis which stream will be displayed. MM81F4 respectively. The starting X,Y coordi
Color keying is used when the stream source is nates and window size for the secondary stream
in RGB format (graphics). This is always the case are specified in MM81F8 and MM81FC respec-
for the primary stream. Chroma keying is used tively. .
when the stream source is YUV or YCbCr (video).
The secondary stream source can be either
9.4 STREAMS FIFO CONTROL
graphics or video, so either color or chroma key
ing might be used. If 81AO_26-24 (compose
mode) = 101b and MM8184_28 = 1, the color key The streams FIFO can be reconfigured to opti
is compared with the primary stream pixel. If mize performance for various operating modes.
there is a match, the corresponding secondary The FIFO is 24 8-byte slots deep. By program
stream pixel is displayed. If 81AO_26-24 = 110b ming MM81 EC_4-0, the FIFO can be reconfigured
and MM8184_28 = 1, the color or chroma key is to assign all 24 slots to either the primary or
compared with the secondary stream pixel. If secondary stream. Allocations of 16-8 and 12-12
there is a match, the corresponding primary slots between the two streams are also possible.
stream pixel is displayed. As an example, if only a primary stream is being
displayed, optimal performance is generated by
If the inputformat is KRGB-16 (1.5.5.5), selected assigning all 24 FIFO slots to the primary stream.
when MM8180_26-24 or MM8190_26_24 =0 11b,
the most significant bit of each pixel value is used No matter what the allocation, FIFO thresholds
as a color key as long as MM8184_28 is cleared must be specified for the primary and secondary
to o. When the most significant pixel bit is a 0, the streams. This is done via MM81EC_16-12 for the
other stream pixel is displayed. primary stream and MM81 EC_1 0-6 for the secon
dary stream. When the FIFO empties to the
For other RGB input types (as specified by threshold level, an internal signal is generated
MM8180_26-24), a color key must be defined. requesting the memory controller to begin refill
This is done by programming MM8184_23-O with ing the FIFO. The programmed threshold levels
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
COIOi is outside this range, the secondary stream
pixel is displayed.
9-8 STREAMS PROCESSOR

86CM65 Dual Display Accelerator
83 Incorporated
Section 10: CRT lTV Interface
The 86CM65 provides analog RGB output to a in the DuoViewsection of Section 11. Each CLUT
CRT or NTSC/PAL outputto a television. Only one provides 256 6-bit words for each color. A clock
ofthese modes can be active at a time. TV output doubled mode is also provided for a bits/pixel
is selected when CR3D_0 = 1. If CR3D_0 = 0 modes. A 24-bit CLUT bypass is provided for
(default), CRT output is generated. External logic 15/16- and 24-bit color modes. A special
must direct the output to the appropriate device. 64Ox480x24 mode is provided to allow true color
operation with 1 MByte of memory. Figure 10-1
shows the internal block diagram for the DACs
10.1 CRT OUTPUT
and one of the CLUTs.
CRT analog RGB output (AR, AG, AB) is gener
10.1.1 Operating Modes
ated by three internal a-bit DACs. For a bits/pixel
CRT modes, the DACs are fed by one of two
internal color look-up table (CLUT) RAMs. The Depending on the setting of CR67 _3-2, the follow
source CLUT for the DACs depends on the ing operating modes are available:
CRT/flat panel output configuration, as explained
VREF RSET COMP
I--.-+t-.. AR
I--rl-:+. . AG
h-+t-:+. . AB
Figure 10-1. Internal RAMDAC Block Diagram
CRT/TV INTERFACE 10-1

••
r
86CM65 Dual Display Accelerator
S3 Incorporated
Table 10-1 86CM65 Color Modes
Color CR67 MAX MAX
Mode Bits 7-4 PABits DCLK Pixel Rate Description
0 0000 7:0 80 MHz 80 MHz 8-bit pseudo-color (CLUT) -Default
8 0001 15:0 67.5 MHz 135 MHz Two 8-bit pseudo-color (CLUT)
9 0011 15:0 80 MHz 80 MHz 15-bit high-color ( CLUT Bypass)
10 0101 15:0 80 MHz 80 MHz 16-bit high-color (CLUT Bypass)
12 0111 23:0 75 MHz 25 MHz 640x480x24-bit packed (CLUT Bypass)
13 1101 23:0 50 MHz 50 MHz 24-bit true-color (CLUT Bypass)
• Streams Processor Off tions, the data from which is clocked out
to the DACs at twice the pixel clock rate.
• Streams Processor On
3. 15 or 16 bits (lower two bytes of the inter
• Streams Processor On -secondary
nal pixel address bus) or 24 bits (all three
stream overlaid on VGA Mode 13 back
ground bytes of the internal address bus) are
transferred directly to the DACs each pixel
With the Streams Processor off (CR67-3-1 = OOb), clock.
data from the video FIFO (memory) is processed
Each ofthe 6 color modes is listed in Table 10-1.
by another 86CM65 module and then passed
The desired mode is selected by programming
directly to the RAMDAC. This mode is used for
bits 7-4 of CR67.
those video modes not supported by the Streams
Processor. This includes all VGA modes except
modes D, E, 10, 12 and 13, all interlaced modes 10.1.2.1 8 Bits/Pixel-Mode 0
and the clock-doubled 8 bits/pixel mode.
With the Streams Processor on (CR67 _3-2 = 11 b), Mode 0 is selected by setting bits 7-4 of CR67 to
OOOOb. In this mode, the low 8 internal pixel
memory data is passed directly to the Streams
address bus bits are ANDed with the contents of
Processor. 8 bits/pixel (palettized) data is passed
the Pixel Read Mask register (3C6H). The result
directly to the RAMDAC, where it is interpreted
of the AND operation selects one of 256 CLUT
by the color look-up table and returned to the
locations. This results in the output of 6 bits of
Streams Processor as RGB666. This and other
input data types are converted to RGB888 (if color information to each of the DACs.
required) and then sent to the RAMDAC via the
high and true color bypass. 10.1.2.2 Output-doubled 8 Bits/Pixel -
Mode 8
10.1.2 Color Modes
This mode is selected by setting bits 7-4 of CR67
The 86CM65 internal RAMDAC provides 6 color to 0001 b.ln this mode, latching of pixel data from
modes of the following 3 primary types: the lower two bytes of the internal pixel data bus
is based on the pixel clock (VCLK) and output of
1. 8 bits (low byte ofthe internal pixel address pixel data from the latches to the DACs is based
bus) are latched each pixel clack and Si6 en an internal clcck iunning at twice the VCLK
used to select a CLUT location. rate. Either bit 4 or bit 6 of SR15 must be setto 1
when this mode is selected and bit 7 of SR18
2. 16 bits (low two bytes of the internal pixel
must also be set to 1.
address bus) are latched each pixel clock.
These select two consecutive CLUT loca-
10-2 CRTnv INTERFACE

86CM65 Dual Display Accelerator
53 Incorpor.ted
This mode processes two pixels per VCLK with a 10.3 RAMDAC SNOOPING
maximum VCLK rate of 67.5 MHz. This results in
an effective pixel output clock rate of 135 MHz.
Setting bit 5 of the Command PCI configuration
space register (Index 04H) to 1 causes the
The internal pixel bus bits are ANDed with the
86CM65 to snoop for RAMDAC writes. This
contents of the Pixel Read Mask register. The
means that the 86CM65 will write the data to its
result of the AND operation selects one of 256
local RAMDAC but will not claim the cycle by
CLUT locations. This results in the output of6 bits
asserting DEVSEL. This allows the ISA controller
of color information to each of the DACs.
to also generate a write cycle to a secondary
RAMDAC. The 86CM65 always provides the data
10.1.2.3 15/16-Bits/Pixel-Modes 9 for RAMDAC reads.
and 10
If bit 5 ofthe PCI Command register is cleared to
0, the 86CM65 claims all RAMDAC read and write
These modes are selected by setting bits [7:4) of cycles.
CR67 to 0011b (15 bits/pixel) or 0101b (16
bits/pixel). In either case, one pixel is transferred Bits 2-0 of CR34 allow handling of PCI master
on the lower two bytes of the internal pixel bus aborts and retries to be individually enabled or
each VCLK cycle. This data is sent directly to the disabled during RAMDAC cycles.
DACs via the CLUT bypass.
If DAC snooping is enabled, the programmer
must ensure that SR47 _1 -0 are set correctly so
10.1.2.4 Packed 24 Bits/Pixel-Mode
that the appropriate CLUT or CLUTs will be up
12
dated.
This mode is selected by setting bits 7-4 of CR67
10.4 SENSE GENERATION
to 0111b.ltis used for a resolution of 640x480x24.
Each pixel is stored in 24 bits of memory, allow
ing operation with 1 MByte of memory. The in The internal RAMDAC contains analog voltage
ternal hardware cursor can be used in this mode comparators. These drive the internal SENSE
but no acceleration is provided. signal active low whenever the output on any of
the AR, AG or AB pins exceeds 330 mV ± 20%.
The state of this internal signal can be read via
10.1.2.524 Bits/Pixel-Mode 13
bit 4 of 3C2H. This information can be used to
detect the existence and type of monitor
This mode is selected by setting bits [7:4) of CR67 (color/mono) connected to the system.
to 1101 b. One pixel is transferred to the DACs
each VCLK cycle via the CLUT bypass. The byte
10.5 TV OUTPUT
coding forthe internal pixel address bus is shown
in Figure 10-4.
The AR and AG (analog red and green) outputs
can be programmed to output signals capable of
10.2 RAMDAC REGISTER ACCESS
driving a TV monitor. This capability is enabled
by setting bit 0 of CR3D to 1. Controller 1 with
The standard VGA RAMDAC register set (3C6H - Streams Processor operation is automatically se
3C9H) is used to access the internal DAC registers lected as the source of data (via the TV encoder)
and the two CLUTs. SR47 _1-0 control the updat to the RAMDAC.
ing of the CLUTs. If SR47 _1-0 = OOb, CLUT1 and
CLUT2 are both enabled. A write will update both Any type of input data can be displayed on a TV.
CLUTs identically (mirroring). If SR47_1-Q = 01b, If full intelaced output is desired, double buffer
a write will update onlyCLUT1.lfSR47_1-0= 10b, ing must be used as explained in the digitizer
a write will update only CLUT2. section of the LPB section.
CRT/TV INTERFACE 10-3

86CM65 Dual Display Accelerator
53 Incorpo. .t ed
The output types are controlled by CR3D_3-1 as
shown in the following table:
Table 10-2 TV Output Options
CR3D AG AR Notes
bits 3-1
xOO Luma Chroma S-Video
011 Camp Camp
111 Comp BB
As shown in Table 10-2. a single S-Video output
is available. with the luminance output on the AG
pin and the chromanance output on the AR pin.
Alternately. the single composite signal can be
output on both AG and AR or a blackburst (BB)
signal can replace the composite signal on the
AR pin. The black burst signal contains syncs.
BLANK and color burst information without ac
tive video data and is useful for synchronization
when video editing.
Bit 5 of CR3D selects between NTSC (= 0) and PAL
(= 1) output. Bit 4 selects between color (= 0) and
black and white (= 1) output.
10-4 CRTnv INTERFACE

86CM65 Dual Display Accelerator
S3 Inaorporllted
Section 11: Flat Panel Interface
The 8SCMS5 supports a variety of color STN and bus size. This is shown in Table 11-1. Note that
TFT flat panels. Flat panel display is enabled by proper data output requires that SR3D_3 be pro
setting SR31_4 = 1. This section describes the grammed to 1.
control and data interfaces for each type. Opera
tion of a flat panel in conjunction with a CRT is
11.1.2 STN Panel Timing
also described.
Functional timings for the data outputs of all the
11.1 STN PANEL SUPPORT
STN panel configurations listed in Table 11-1 are
given in Figures 11-1 through 11-S.
STN panel support is selected when SR39_1-O =
10b.
11.1.3 STN Panel Control
11.1.1 STN Panel Selection
Selection of an STN panel configures several
pins specifically for STN control.
The 8SCMS5 supports either a single-scan (SS
STN) or a dual-scan (DD-STN) STN panel. The The polarity of the flat panel data can be changed
type is selected via SR30_0 as follows: to active low by programming SR32_4 to 1. The
drive strength of the panel data is specified via
o = DD-STN panel SR3D-S. The drive strength for the clock is speci
1 = SS-STN panel fied via SR3D3.
When DD-STN panel operation is selected, frame The modulation (MOD) signal is output on pin
acceleration is automatically used in all modes of B15forSTN panelswhenSR343 = 1. The modu
operation. This means the panel will be refreshed lation period is defined by SR34_S-0. SR35_4
at twice the CRT rate. For example, if the flat selects the MOD clock. If MOD is not enabled, B 15
panel timing registers are programmed for a outputs the FPDE display enable signal. The po
refresh rate of SO Hz, the actual refresh rate will larity of FPDE can be changed to active low by
be be 120 Hz. programming SR32_5 to 1.
SR3D_2-0 define the pixel data bus size as fol Pin C4 provides the LP signal. The polarity of LP
lows: can be changed to active low by programming
SR32_6to 1.
000 = 1S-bit STN
001 = 8-bit STN Several controls are provided for LP and FPSCLK
010 = 24-bit STN during vertical blanking. FPSCLK is normally
stopped during non-display time by setting
Pixel data is output on some combination of the SR40_5to 1. WhenSR3D3=0, LP will run during
the FPD[35:0) pins, depending on the pixel data vertical blanking. Setting SR3D_4to 1 disables LP
FLAT PANEL INTERFACE 11-1

86CM65 Dual Display Accelerator
S3 Incorporeteci
Table 11-1.  STN Flat Panel Data Outputs
|           |         |         |         |         | a       | a       |
| --------- | ------- | ------- | ------- | ------- | ------- | ------- |
| SR30 0    | 1       | 1       | 1       | 0       |         |         |
| SR39 1-0  | 10      | 10      | 10      | 10      | 10      | 10      |
| SR30 2-0  | 001     | 000     | 010     | 010     | 000     | 010     |
| Pin       | SS-STN  | SS-STN  | SS-STN  | DD-STN  | DD-STN  | DD-STN  |
|           | a       |         |         | a       |         |         |
| Name      |         | 16      | 24      |         | 16      | 24      |
| FPOO      | RO      | RO      | RO      | LOO     | LOO     | LOO     |
| FP01      | GO      | GO      | GO      |         |         | LD9     |
| FP02      | BO      | BO      | BO      | L01     | L01     | L01     |
| FP03      | R1      | R1      | R1      |         |         |         |
| FPD4      | G1      | G1      | G1      | L02     | L02     | L02     |
| FP05      | B1      | B1      | B1      |         |         |         |
| FP06      | R2      | R2      | R2      | L03     | L03     | L03     |
| FP07      | G2      | G2      | G2      |         |         | L010    |
| FPOB      |         | B2      | B2      |         | L04     | LD4     |
| FP09      |         | R3      | R3      |         |         |         |
| FP010     |         | G3      | G3      |         | L05     | L05     |
| FP011     |         | B3      | B3      |         |         |         |
| FP012     |         | R4      | R4      |         | L06     | L06     |
| FP013     |         | G4      | G4      |         |         | L01l    |
| FP014     |         | B4      | B4      |         | L07     | L07     |
| FP015     |         | R5      | R5      |         |         |         |
| FP016     |         |         | G5      |         |         | LOB     |
| FP017     |         |         | B5      |         |         |         |
| FP01B     |         |         | R6      | UOO     | UOO     | UOO     |
| FP019     |         |         | G6      |         |         | U09     |
| FP020     |         |         | B6      | U01     | U01     | U01     |
| FP021     |         |         | R7      |         |         |         |
| FP022     |         |         | G7      | U02     | U02     | U02     |
| FP023     |         |         | B7      |         |         |         |
| FP024     |         |         |         | U03     | U03     | U03     |
| FP025     |         |         |         |         |         | U010    |
| FP026     |         |         |         |         | U04     | U04     |
FP027
| FP02B  |     |     |     |     | U05  | U05  |
| ------ | --- | --- | --- | --- | ---- | ---- |
FP029
| FP030  |     |     |     |     | U06  | U06  |
| ------ | --- | --- | --- | --- | ---- | ---- |
.1_-
| FP031               |     |     |     |     |     | U011  |
| ------------------- | --- | --- | --- | --- | --- | ----- |
| •I:•D D  ' .2..2    |     |     |     |     |     | 11_-  |
FP033
FP034
FP035
11-2  FLAT PANEL INTERFACE

86CM65 Dual Display Accelerator
S3 Incorporated
during vertical blank. If SR3D_4 = 0 and SR3D_5 Frame rate control is enabled automatically for
= 1, FPSCLK is disabled during the first line of STN panels. The number of frames over which
vertical blanking. If SR40_5 = 0, FPSCLK runs bits are turned on or off to generate a single color
continuously. FPSCLK can be delayed via determines the number of grayscale levels and is
SR40_3-1. programmed in SR39_4-3 as follows:
Pin A3 provides the FLM (first line marker) signal. 00= 16 levels
The polarity of FLM can be changed to active low 01 = 8 levels
by programming SR32_7 to 1. 10 = Reserved
11 = Reserved
Setting SR40_4 to 1 forces all flat panel data and
control signals to logic O. FRC weighting values are programmed via SR37
and SR38. SR3A, SR3B and SR3C are used to tune
the frame rate control for optimum quality. The
11.1.4 STN Frame Rate Control
algorithms and techniques used are proprietary.
Frame rate control (FRC) for STN panels is used
11.1.5 STN Panel Dithering
to display more grayscale levels than would nor
mally be possible based on the 1 bit/color input.
Each color bit is turned on or off over a series of Dithering is used to increase the apparent num
frames to simulate intermediate colors. ber of colors displayed. This is enabled by setting
SR363-6 as follows:
T1 T2 T3 T4 T5 T6 T7 T8 T9
DCLK
FPSCLK
=:x
FPDO LRO ~ ~
=:x
FPD2 LGO ~ ~
=:x
FPD4 LBO ~ ~
=:x
FPD6 LR1 ~ ~
=:x
FPD18 URO ~ ~
=:x
FPD20 UGO ~ ~
=:x
FPD22 UBO ~ ~
=:x
FPD24 UR1 ~ ~
Figure 11·1. 8-bit Color DD-5TN Panel Timing
FLAT PANEL INTERFACE 11-3

. .
86CM65 Dual Displav Accelerator
sa Inoorporatn
| T1  | T2  T3  T4  | TS  T6  | T7  T8  | T9  |
| --- | ----------- | ------- | ------- | --- |
DCLK
| FPSCLK  J  | \   |     |     |     |
| ---------- | --- | --- | --- | --- |
x=
| FPDO ~  | LRO  X  | LB2  X  | LGS  |     |
| ------- | ------- | ------- | ---- | --- |
x=
| FPD2 ~  | LGO  X  | LR3  X  | LBS  |     |
| ------- | ------- | ------- | ---- | --- |
x=
| FPD4  ~  | LBO  X  | LG3  X  | LR6  |     |
| -------- | ------- | ------- | ---- | --- |
x=
| FPD6 ~  | LR1  X  | LB3  X  | LG6  |     |
| ------- | ------- | ------- | ---- | --- |
x=
| FPD8 ~  | LG1  X  | LR4  X  | LB6  |     |
| ------- | ------- | ------- | ---- | --- |
x=
| FPD10 ~  | LB1  X  | LG4  X  | LR7  |     |
| -------- | ------- | ------- | ---- | --- |
x=
| FPD12 ~  | LR2  X  | LB4  X  | LG7  |     |
| -------- | ------- | ------- | ---- | --- |
x=
| FPD14 ~  | LG2  X  | LRS  X  | LB7  |     |
| -------- | ------- | ------- | ---- | --- |
x=
| FPD18 ~  | URO  X  | UB2  X  | UGS  |     |
| -------- | ------- | ------- | ---- | --- |
x=
| FPD20 ~  | UGO  X  | UR3  X  | UBS  |     |
| -------- | ------- | ------- | ---- | --- |
x=
| FPD22 ~  | UBO  X  | UG3  X  | UR6  |     |
| -------- | ------- | ------- | ---- | --- |
x=
| FPD24 ~  | UR1  X  | UB3  X  | UG6  |     |
| -------- | ------- | ------- | ---- | --- |
x=
| FPD26 ~  | UG1  X  | UR4  X  | UB6  |     |
| -------- | ------- | ------- | ---- | --- |
x=
| FPD28 ~  | UB1  X  | UG4  X  | UR7  |     |
| -------- | ------- | ------- | ---- | --- |
x=
| FPD30  ~  | UR2  X  | UB4  X  | UG7  |     |
| --------- | ------- | ------- | ---- | --- |
b
| FPD32  ~  | 002  X  | URS  X  | UB7  |     |
| --------- | ------- | ------- | ---- | --- |
Figure 11-2. 16-bit Color DD-STN Panel Timing
11-4  FLAT PANEL INTERFACE

III.
r
86CM65 Dual Display Accelerator
83 Incorpor.ud
T1
|     | T2  T3  T4  | T5  TI  T7  | 11  11  |
| --- | ----------- | ----------- | ------- |
DCLI(
J
| FPSCLK  | \   | /  \  | f   |
| ------- | --- | ----- | --- |
'C..
|     | LAO  | X  LR4  |     |
| --- | ---- | ------- | --- |
FPDO J
'C..
| FPDl J  | LA3  | X  LR7  |       |
| ------- | ---- | ------- | ----- |
|         |      | X       | 'C..  |
| FPD2 J  | LGO  | LG4     |       |
'C..
| FPD4 J  | LBO  | X  L84  |     |
| ------- | ---- | ------- | --- |
'C..
| FPDIJ  | LAl  | X  LA5  |     |
| ------ | ---- | ------- | --- |
'C..
|     | LG3  | X  LG7  |     |
| --- | ---- | ------- | --- |
FPD7J
'C..
| FPD8 J   | LGl  | X  LG5  |       |
| -------- | ---- | ------- | ----- |
|          |      | X       | 'C..  |
| FPD10 J  | LBl  | LB5     |       |
'C..
| FPD12 J  | LA2  | X  LA'  |     |
| -------- | ---- | ------- | --- |
'C..
| FPD13 J  | LB3  | X  LB7  |       |
| -------- | ---- | ------- | ----- |
|          | LG2  | X  LGI  | 'C..  |
FPD14J
'C..
| FPD11 J  | LB2  | X  LBI  |       |
| -------- | ---- | ------- | ----- |
|          |      | X       | 'C..  |
| FPD18 J  | URO  | UR4     |       |
'C..
| FPD19 J  | UR3  | X  UR7  |     |
| -------- | ---- | ------- | --- |
'C..
| FPD20 J  | UGO  | X  UG4  |       |
| -------- | ---- | ------- | ----- |
|          |      | X       | 'C..  |
| FPD22 J  | UBO  | UB4     |       |
|          |      | X  URI  | 'C..  |
| FPD24J   | URl  |         |       |
'C..
| FPD25 J  | UG3  | X  UG7  |       |
| -------- | ---- | ------- | ----- |
|          |      | X       | 'C..  |
| FPD2I J  | UGl  | UGS     |       |
'C..
| FPD28 J  | UBl  | X  UBS  |     |
| -------- | ---- | ------- | --- |
'C..
| FPD30 J  | UR2  | X  URI  |     |
| -------- | ---- | ------- | --- |
'C..
X  UB7
| FPD31J  | UB3  |     |     |
| ------- | ---- | --- | --- |
'C..
| FPD32J  | UG2  | X  UG8  |      |
| ------- | ---- | ------- | ---- |
|         |      | X       | G::  |
| FPD34J  | UB2  | UBI     |      |
Figure 11-3. 24-bit Color DD-5TN Panel Timing
FLAT PANEL INTERFACE 11-5

86CM65 Dual Display Accelerator
S3 Incorpor• •e d
| 00 = Dithering disabled  |     | 11.1.6 Dual-Scan STN Frame Buffer  |     |     |
| ------------------------ | --- | ---------------------------------- | --- | --- |
01 = Dither in all modes
10 = Dither in graphics modes only (no text)
DD-STN panel operation requires off-screen
11 = Dither in graphics modes with 8 bpp or more
video memory. The amount of memory is pro
grammed in SR50 and SR51. The starting loca
The base color is selected by programming
tion of the DD-STN memory is specified in SR4F.
SR36_5-3 as follows:
These values are all programmed by the video
BIOS at reset.
000 = 8 bits (no dithering)
011 = 3 bits (8-level FRC)
100 = 4 bits (16-level FRC)
SR36 0 selects the number of bits of the 8-bit
cOlorvalue to use for dithering as follows:
o
= 2 bits (2x2 dither pattern)
1 = 4 bits (4x4 dither pattern)
Typically, a 2x2 dither pattern is used with 16-
level FRC and a 4x4 pattern with 8-level FRC.
DCLK
| J   | \   | /  LJ  | LJ  | '-  |
| --- | --- | ------ | --- | --- |
FPSCLK
| ~     |     | X   | X   |     |
| ----- | --- | --- | --- | --- |
| FPDO  | RO  | B2  | G5  | X   |
~
| FPD1  | GO  | X  R3  | X  B5  | X   |
| ----- | --- | ------ | ------ | --- |
~
| FPD2  | BO  | X  G3  | X  R6  | X   |
| ----- | --- | ------ | ------ | --- |
| ~     |     |        | X      | X   |
| FPD3  | R1  | X  B3  | G6     |     |
| ~     |     | X      | X      | X   |
| FPD4  | G1  | R4     | B6     |     |
| ~     |     | X      | X      | X   |
| FPD5  | B1  | G4     | R7     |     |
| ~     |     | X      | X  G7  | X   |
| FPD6  | R2  | B4     |        |     |
| ~     | G2  | X  R5  | X  B7  | X   |
FPD7
Figure 11-4. 8-bit Color SS-STN Panel TIming
11-6  FLAT PANEL INTERFACE

86CM65 Dual Display Accelerator
| Tt  12  | T3  ,T4   T5  | T5  T7  T5  | T5  ,Tt O  | Ttl  Tt2  Ttl  | Tt4 ,Tt 5  |     |
| ------- | ------------- | ----------- | ---------- | -------------- | ---------- | --- |
Ttl  Tt7
DCLK
| J   |     | I   |     | I   |     | f   |
| --- | --- | --- | --- | --- | --- | --- |
FPSCLJ(
=x
e
| FPDO  | RO  | X   | G5  | X   | 81D  |     |
| ----- | --- | --- | --- | --- | ---- | --- |
| =x    |     |     |     |     |      | e   |
| FPDl  | GO  | X   | as  | X   | R11  |     |
e
| FPD2=X    | so  | X   |     | X   |      |     |
| --------- | --- | --- | --- | --- | ---- | --- |
|           |     |     | RI  |     | 011  |     |
| =x        |     |     |     |     |      | e   |
| FPD3      | Rl  | X   | 01  | X   | 811  |     |
| =x        |     |     |     |     |      | e   |
|           |     | X   | sa  | X   | R12  |     |
| FPD4  =x  | 01  |     |     |     |      | e   |
|           |     | X   |     | X   |      |     |
| FPDS      | 81  |     | R7  |     | 012  |     |
e
FPDI=X
|           | AI    | X   | G7  | X   | 812  |     |
| --------- | ----- | --- | --- | --- | ---- | --- |
| =x        |       |     |     |     |      | e   |
|           |       | X   | 87  | X   | R13  |     |
| FPD7  =x  | 02    |     |     |     |      | e   |
| FPDI      | l1li  | X   | AI  | X   | 013  |     |
e
FPDI=X
|            | AI  | X   | oa  | X   | 813  |     |
| ---------- | --- | --- | --- | --- | ---- | --- |
| =x         |     |     |     |     |      | e   |
|            |     | X   | 88  | X   | R14  |     |
| FPD1D  =x  | G3  |     |     |     |      |     |
e
| FPDll      | B3  | X   | R.  | X   | 014  |     |
| ---------- | --- | --- | --- | --- | ---- | --- |
| =x         |     |     |     |     |      | e   |
| FPD12      | R4  | X   | O.  | X   | 814  |     |
| =x         |     |     |     |     |      | e   |
|            |     | X   | B.  | X   | Rl1  |     |
| FPD13  =x  | Q4  |     |     |     |      |     |
e
| FPD14  | B4  | X   | Rl0  | X   | 015  |      |
| ------ | --- | --- | ---- | --- | ---- | ---- |
| =x     |     |     |      |     |      | x::  |
| FPD15  | AS  | X   | OlD  | X   | 815  |      |
Figure 11-5. 16·bit Color SS-STN Panel Timing
|     |     |     |     | FLAT PANEL INTERFACE  |     | "·7  |
| --- | --- | --- | --- | --------------------- | --- | ---- |

86CM65 Dual Display Accelerator
UlncorpomllCl
11  1'2  T3  T4  111  111  17  1'8  n  110  111  112  113  114  11S  11.  117
DCLK
| FPSCLK.J  | \   | I   | \   | f   |
| --------- | --- | --- | --- | --- |
|           | RO  | X   | AI  | ~   |
A'OO:=X
:=x
| FPD1  | GO  | X   | QI  | ~   |
| ----- | --- | --- | --- | --- |
E
|     | ao  | X   | 88  |     |
| --- | --- | --- | --- | --- |
FPD2:=X
:=x
|       | R1  | X   |     | ~   |
| ----- | --- | --- | --- | --- |
| FPDO  |     |     | AS  |     |
:=x
| FPD4  | Q1  | X   | QI  | ~   |
| ----- | --- | --- | --- | --- |
:=x
| FPD5  | B1  | X   | 81  | ~   |
| ----- | --- | --- | --- | --- |
:=x
|       |     | X   |      | ~   |
| ----- | --- | --- | ---- | --- |
| FPDe  | R2  |     | R10  |     |
:=x
| FPD7  | G2  | X   | Q1.  | ~   |
| ----- | --- | --- | ---- | --- |
| :=x   |     |     |      | E   |
| FPDe  | B2  | X   | Bt.  |     |
:=x
|       |     | X   |      | ~   |
| ----- | --- | --- | ---- | --- |
| FPDe  | R3  |     | R11  |     |
:=x
E
| FPDt.  | Q3  | X   | 011  |     |
| ------ | --- | --- | ---- | --- |
| :=x    |     |     |      | E   |
| FPD11  | 83  | X   | 811  |     |
:=x
|        |     | X   |      | ~   |
| ------ | --- | --- | ---- | --- |
| FPDt2  | R4  |     | R12  |     |
:=x
| FPDt3  | G4  | X   | Qt2  | ~   |
| ------ | --- | --- | ---- | --- |
:=x
| FPDt4     | 84  | X   | 812  | ~   |
| --------- | --- | --- | ---- | --- |
|           |     | X   |      | ~   |
| FPD1S:=X  | AS  |     | R13  |     |
:=x
| FPD1.  | os  | X   | 013  | ~   |
| ------ | --- | --- | ---- | --- |
:=x
| FPD17  | 85  | X   | 813  | ~   |
| ------ | --- | --- | ---- | --- |
:=x
X
| FPDt.  | lie  |     | R14  | ~   |
| ------ | ---- | --- | ---- | --- |
:=x
| FPD1.  | GO  | X   | Qt4  | ~   |
| ------ | --- | --- | ---- | --- |
:=x
|     | 88  | X   | 8t4  | ~   |
| --- | --- | --- | ---- | --- |
I'PIIIO
X
| FPD21:=X  | R7  |     | RtS  | ~   |
| --------- | --- | --- | ---- | --- |
:=x
y;;;-
| FPD22  | Q7  | X   | QtS  |     |
| ------ | --- | --- | ---- | --- |
,'"--
:=x
|        |     | X   | 8tS  | -~  |
| ------ | --- | --- | ---- | --- |
| FPD23  | 87  |     |      |     |
Figure 11-6. 24-bit Color SS-STN Panel Timing
11-8  FLAT PANEL INTERFACE

86CM65 Dual Display Accelerator
53 IncOI'pOrllted
| 11.2  TFT PANEL SUPPORT  |     |     | 11.2.2 TFT Panel Timing  |     |     |
| ------------------------ | --- | --- | ------------------------ | --- | --- |
TFT panel support is selected when SR39_1-O =  TFT panel timing is very similar to CRT timing,
| OOb.  |     |     | with the FPDE signal functionally equivalent to  |     |     |
| ----- | --- | --- | ------------------------------------------------ | --- | --- |
the CRT BLANK signal (inverted). Functional tim
ing for an 24-bit TFT panel clocked at one pixel
11.2.1 TFT Panel Selection
per FPSCLK and a 36-bit (2x1S) panel clocked at
2 pixels/FPSCLK are shown in Figure 11-7. Tim
SR3D_2-0 define the pixel data bus size as fol  ings are the same for all types of TFT panels
| lows:  |     |     | clocked at 1 pixel/FPSCLK, as is the case for all  |     |     |
| ------ | --- | --- | -------------------------------------------------- | --- | --- |
types of TFT panels clocked at 2 pixels/FPSCLK.
000 = 1 pixel/clock TFT (9-, 12-, 15-, 1S-bit)
001 = 1 pixel/clock TFT (24-bit)
| 010 = 2 pixels/clock TFT (2x9-, 2x12-, 2x1S-bit)  |     |     | 11.2.3 TFT Panel Control  |     |     |
| ------------------------------------------------- | --- | --- | ------------------------- | --- | --- |
The 2 pixels per clock modes halve the clock rate  Selection of a TFT panel configures several pins
and clock two pixels on the falling edge of  specifically for TFT control. The drive strengths
FPSCLK, thereby lowering EMllevels. SR40_6 is  of the panel clock and data are specified via
| set to 1 to support this mode of operation.  |     |     | SR3D3-6.  |     |     |
| -------------------------------------------- | --- | --- | --------- | --- | --- |
Pixel data is output on some combination of the  The polarity of the flat panel data can be changed
to active low by programming SR32_4to 1.
FPD[35:0] pins. The data outputs are shown in
Table 11-2. Note that proper data output requires
that SR3D_3 be programmed to 1.
|     | 1 PIXEUFPSCLK  |     |         | 2 PIXELSlFPSCLK  |     |
| --- | -------------- | --- | ------- | ---------------- | --- |
|     | T1  T2         | T3  | T1  T2  | T3  T4           | T5  |
F\.J\..FL
| OCLK  |     | DCLK  |     |     |     |
| ----- | --- | ----- | --- | --- | --- |
F\.J\..FL
| FPSCLK  |     | FPSCLK  |      |     |     |
| ------- | --- | ------- | ---- | --- | --- |
| -.l     |     |         | -.l  |     |     |
| FPOE    |     | FPOE    |      |     |     |
C
| FPO[23:0]~ FPO[17:0]  |     |               | ~  01  | X   |     |
| --------------------- | --- | ------------- | ------ | --- | --- |
| FPPOL                 |     | FPPOL         |        | 03  |     |
|                       |     | FP0[35:18] ~  |        |     | b   |
D2  X  04
Figure 11-7. TFT Panel TIming
|     |     |     |     | FLAT PANEL INTERFACE  | 11-9  |
| --- | --- | --- | --- | --------------------- | ----- |

86CM65 Dual Display Accelerator
53 Inoorpo. ......
Table 11-2.  TFT Flat Panel Data Outputs
| SR300     | 1    | 1           | 1    | 1     | 1    | 1     | 1    | 1     | 1    |
| --------- | ---- | ----------- | ---- | ----- | ---- | ----- | ---- | ----- | ---- |
| SR365-3   | 011  | 011         | 100  | 100   | 101  | 101   | 110  | 110   | 000  |
| SR39 1-0  | 00   | 00          | 00   | 00    | 00   | 00    | 00   | 00    | 00   |
| SR3D 2-0  | 000  | 010         | 000  | 010   | 000  | 010   | 000  | 010   | 001  |
| Pin       | TFT  | TFT         | TFT  | TFT   | TFT  | TFT   | TFT  | TFT   | TFT  |
| Name      | 9    | 2x9         | 12   | 2x12  | 15   | 2x15  | 18   | 2x18  | 24   |
| FPDO      |      |             |      |       |      |       | RO   | ROO   | R2   |
| FPD1      |      |             |      |       |      |       |      | R10   | RO   |
| FPD2      |      |             |      |       | RO   | ROO   | R1   | R01   | R3   |
| FPD3      |      |             |      |       |      | R10   |      | R11   |      |
| FPD4      |      |             | RO   | ROO   | R1   | R01   | R2   | R02   | R4   |
| FPD5      |      |             |      | R10   |      | R11   |      | R12   |      |
| FPD6      | RO   | ROO         | R1   | R01   | R2   | R02   | R3   | R03   | R5   |
| FPD7      |      | R10         |      | R11   |      | R12   |      | R13   | R1   |
| FPD8      | R1   | R01         | R2   | R02   | R3   | R03   | R4   | R04   | R6   |
| FPD9      |      | R11         |      | R12   |      | R13   |      | R14   |      |
| FPD10     | R2   | R02         | R3   | R03   | R4   | R04   | R5   | R05   | R7   |
| FPD11     |      | R12         |      | R13   |      | R14   |      | R15   |      |
| FPD12     |      |             |      |       |      |       | GO   | GOO   | G2   |
| FPD13     |      |             |      |       |      |       |      | G10   | GO   |
| FPD14     |      |             |      |       | GO   | GOO   | G1   | G01   | G3   |
| FPD15     |      |             |      |       |      | G10.  |      | G11   |      |
| FPD16     |      |             | GO   |       |      |       | G2   |       | G4   |
|           |      |             |      | GOO   | G1   | G01   |      | G02   |      |
| FPD17     |      |             |      | G10   |      | G11   |      | G12   |      |
| FPD18     | GO   | GOO         | G1   | G01   | G2   | G02   | G3   | G03   | G5   |
| FPD19     |      | G10         |      | G11   |      | G12   |      | G13   | G1   |
| FPD20     | G1   | G01         | G2   | G02   | G3   | G03   | G4   | G04   | G6   |
| FPD21     |      | G11         |      | G12   |      | G13   |      | G14   |      |
| FPD22     | G2   | G02         | G3   | G03   | G4   | G04   | G5   | G05   | G7   |
| FPD23     |      | G12         |      | G13   |      | G14   |      | G15   |      |
| FPD24     |      |             |      |       |      |       | 60   | 600   | 62   |
| FPD25     |      |             |      |       |      |       |      | 610   | 60   |
| FPD26     |      |             |      |       | 60   | 600   | 61   | 601   | 63   |
| FPD27     |      |             |      |       |      | 610   |      | 611   |      |
| FPD28     |      |             | 60   | 600   | 61   | 601   | 62   | 602   | 64   |
| FPD29     |      |             |      | 610   |      | 611   |      | 612   |      |
| FPD30     | 60   | 600         | 61   | 601   | 62   | 602   | 63   | 603   | 65   |
| FPD31     |      | .D.. 1'vn   |      | 81'   |      | Bi2   |      | Bi3   | B1   |
| FPD32     | 61   | 601         | 62   | 602   | 63   | 603   | B4   | 604   | 66   |
| FPD33     |      | 611         |      | 612   |      | 613   |      | 614   |      |
| FPD34     | 62   | B02         | 63   | 603   | 64   | 604   | 65   | 605   | 67   |
| FPD35     |      | 612         |      | 613   |      | 614   |      | B15   |      |
11-10  FLAT PANEL INTERFACE

:I.
r
86CM65 Dual Display Accelerator
Pin B15 becomes the FPDE display enable signal. 11.3 FLAT PANEL DISPLAY
The polarity of this signal can be changed to
ENHANCEMENTS
active low by setting SR32_5 to 1.
Pin C4 becomes the FPHSYNC signal. The polar The 86CM65 features automatic centering for
ity of this signal can be changed to active low by display modes that are smaller than the panel
setting SR32_6 to 1. size. Additionally, horizontal and vertical expan
sion for both graphics and text modes enables
Pin A3 becomes the FPVSYNC signal. The polar low resolution modes to fill the entire available
ity of this signal can be changed to active low by display area.
setting SR323 to 1.
11.3.1 Automatic Centering
Pin C15 is the FPPOL polarity indicator signal for
those panels that support it. It is available when
SR403 = 1 and SR1A_5 = 1. FPPOL is supported Automatic horizontal centering is enabled via
for 18- and 24-bit 1 pixel/clock modes and for SR54_4. Automatic vertical centering is enabled
2x1S-bit 2 pixels/clock mode. Timing for this sig via SR56_4.
nal is shown in Figure 11-7.
11.3.2 Horizontal Compensation
SR40_5 allows FPSCLK to be turned on (=0) or off
(=1) during non-display time. FPSCLK can be
delayed via SR40_3-1. SR54_1-0 enable horizontal expansion for text
modes. SR55_1-0 specify which text modes get
expanded. SR54_3-2 enable horizontal expan
11.2.4 TFT Panel Dithering sion for graphics modes. SR55_4 -2 specify which
graphics modes get expanded. SR54_4 enables
As with STN panels, dithering is used to increase horizontal centering.
the apparent number of colors displayed. This is
enabled by setting SR36_7-6 appropriately as
11.3.3 Vertical Compensation
follows:
00 = dithering disabled SR56_1-0 enable vertical expansion for text
01 = dithering enabled in all modes modes. SR57_1-0 specify which text modes get
10 = dither in graphics (not text) modes expanded. SR56_3-2 enable vertical expansion
11 = dither in graphics modes with Sbpp or more for graphics modes. SR55_6-2 specify which
color graphics modes get expanded. SR56_4 enables
vertical centering.
SR36_0 selects the dither pattern as follows:
o 11.3.4 Pulse Width Modulation
= 2x2 pattern
1 = 4x4 pattern
A pulse width modulation (PWM) signal is avail
The base color is selected by programming able to control panel brightness or contrast. PWM
SR36_5-3 as follows: support is enabled for 256Kx16 DRAM configura
tions by setting SR52_0 to 1. This enables output
000 = 8 bits (no dithering -24-bit TFT of the PWM signal on pin M17. PWM cannot be
011 = 3 bits (9-bit TFT) used with 512Kx32 DRAM configurations or with
100 = 4 bits (12-bit TFT) the ODD input function. SR52_1 specifies the
110 = 6 bits (18-bit TFT) PWM clock source. SR52_6-4 specify the clock
divide used to determine the final PWM pulse
Note that all other values are illegal. width (period). The duty cycle of the PWM pulse
is controlled via SR53.
FLAT PANEL INTERFACE 11-11

86CM65 Dual Display Accelerator
sa Inaorponded
J
"""S S'r--------.L.i
I _____
ENAVDD
---, ' I I '1 i L. ' t1.t2 .. 32 or 128 m5 ~ i 12 ! I --
SS'r-----\'II~_
~~::~ I _
___o J
! .... -I!
tPWM-31.25115 MIN
lh~ 11.
-------L-I '--'
PWM I~+-____ _
I "
i
---t t1 --.I 12 !--
s
S'r-----.\'--___
1
ENAVEE _ ___- -' • /,
Figure 11-8. PWM Timing
PWM active timing is coordinated with panel The DCLK rate used by each controller path can
power sequencing. This is shown in Figure 11-8. be individually specified. This provides a tremen
dous degree of flexibility, including the ability to
display one image on the CRT and a completely
11.3.5 Blinking
different image on the flat panel, each using
different CRT timings. This section explains how
Character blinking can be set via CR43_3 to every to take advantage of this flexibility.
32 (= 0) or 64 (=1) frames. Cursor blinking can be
set via CR43_6-5 as follows:
11.4.1 DuoView Display Setup
00 = blink every 16 frames
01 = blink every 32 frames Flat panel controller usage is defined by SR31_1
10 = blink every 64 frames as follows:
o = Use controller 1 (via Streams Processor)
11.4 DuoView DISPLAY
1 = Use controller 2 (no Streams Processor, VGA)
The 86CM65 has two CRT controllers as shown The controller used by the CRT{TV is defined by
in Figure 11-9. Either can be used to drive a CRT SR31_2 as follows:
and either can be used to drive a flat panel. The
Streams Processor can be used only in conjunc o = Use controller 1 (via Streams Processor)
tion with controller i. In addition, controiier 2 can 1 =U se controller 2 (no Streams Processor, VGA)
only be used to display Enhanced modes (not
VGA) and does not provide flat panel expansion Each controller has an associated color look-up
and centering. table (CLUT). By default, CLUT1 and CLUT2 will
be enabled and mirrored for CPU writes. The
hardware cursor and hardware icon, if enabled,
11-12 FLAT PANEL INTERFACE

••
r
86CM65 Dual Display Accelerator
83 Incorporllted
are shared by both controllers. By default, they DuoView Display
are controlled by controller 1.
For this case, the CRT uses one controller and the
The controller choices are based on the following flat panel uses the other. The choice depends on
considerations. the potential display of video, which requires the
Streams Processor, the need to display standard
LCD or CRT /TV Only VGA modes or the need to have automatic ex
pansion/centering, all of which require controller
Use controller 1. 1. Therefore, if video is desired on the CRT, this
is assigned controller 1 and the flat panel is
Simultaneous Display assigned controller 2. Note that this means that
automatic centering/expansion is not available
Use controller 1 for both CRT/TV and flat panel. for the panel. The assignments are reversed if
video output is desired on the flat panel. Note
This is a variation of DuoView where the CRT and that only one screen can display video in this
flat panel images are displayed with almost iden mode.
tical timings. Normally, the flat panel timings are
compromised for CRT VESA timings. Video out The DCLK rate for the controller 1 path is selected
put using the Streams Processor is displayed on via SR28_3-0. The DCLK rate for the controller 2
both screens, as are the hardware cursor and/or path is selected via SR28_7-4.
hardware icon, if enabled.
I----------------------------------~
1 PATH 1
CONTROLLER 1 t----------.j LUT 1 t--"T~'
CRTITV
STREAMS
PROCESSOR
PIXEL
DATA ----------------------
~
1 PATH 2
1
1
1 FLAT
1 CONTRO~R2~--------~ PANEL
1
1 ., ...
1
11 -----------------------------______ 11
Figure 11-9. Intemal Data Paths
FLAT PANEL INTERFACE 11-13

86CM65 Dual Display Accelerator
53 Incorporated
In DuoView mode, the hardware cursor can be CRA; CRB; CRE; CRF; AR11; SR1_5; SR3_5-O;
displayed on either screen. SR31_7 = 0 selects SR4_3, 1; GR5_S-5; CR31_3; CR32_6; CR38; CR39
cursor control by controller 1 and SR313 = 1
selects cursor control by controller 2. The hard Paired and shared registers and bits are noted in
ware icon can also be displayed on either screen. the register descriptions.
SR31_S = 0 selects icon control by controller 1
and SR31_S = 1 selects icon control by controller A separate set of CRTtiming registers is provided
2. for flat panel operation. These are SR60 -SR6F,
except SRS7 is reserved. The values to be pro
In DuoView, if a text mode is used for one display, grammed in these registers are fixed for a given
a text mode must also be used for the other panel (not mode dependent as with a CRT).
display. The same is true for graphics modes. In Therefore, they should be programmed only at
other words, text and graphics modes cannot be reset. These registers are used by controller 1 if
mixed. If the same image is to be displayed on SR31_1 = 0 and by controller 2 if SR31_1 = 1.
both the CRTnv and the flat panel but with dif
ferent timings, both controllers must be used and
11.4.3 DuoView Programming
the Streams Processor and VGA modes are not
available. Example
The following steps show how to program the
11.4.2 DuoView Programming
86CM65 to operate the flat panel using Controller
2 at a resolution of 800xSOO at SO Hz and the CRT
8SCMS5 has a large number of paired registers using Controller 1 at a resolution of 640x480 at
for control oftimings and resolutions for CRTnv 60 Hz.
display. For example, there are two Horizontal
Total (CRO) registers, one associated with CRT 1. Boot for 800xSOO 60 Hz flat panel operation
controller 1 and the other with CRT controller 2.
2. Enable Controller 1 and Controller 2 (SR2S
Both have the same address, and control of
=04H)
read/write access to these registers is provided
by a number of bits in SR2S. SR2S_3 controls 3. Set VESA Mode 103 (800xSOO SO Hz)
write access to the CRT controller 1 registers. A 4. Disable Controller 2 (SR26 = OOH)
value of 0 (default) enables writes. SR2S_2 con
5. Set VESA Mode 101 (640x480 60 Hz)
trols write access to the CRT controller 2 regis
ters. A value of 0 (default) disables write access. S. Setflat panel to Controller 2 (SR31_1 = 1)
Using these controls, a single write can update 7. Set CRT to Controller 2 (SR31_2 = 0)
either of the paired registers or both.
8. Set DCLK PLL to 75 MHz (SR12 = 42, SR13 =
28)
Bit 0 and 1 of SR26 control read access of the
paired registers. 9. Set Controller 1 clock to PLL/3 = 25 MHz
and Controller 2 clock to PLLJ2 = 37 MHz
The following CRTC registers (or register bits) are (SR28 =48H)
paired: 10.Lock the timing registers (CR35 = FOH)
CRO-CR9; CRC; CRD; CR10-CR18; CR22; CTR223;
CR24; CR31_S; CR33_6-3; CR34_4; CR35_5-4;
CR3A_4-3; CR3B; CR3C; CR42_5; CR43; CR51;
CR63,CR65;CRSS_0;CR67;CRS9;CR71
In addition, there are a number of shared regis
ters. This means that both controller 1 and con
troller 2 obtain information from the same
register. The shared registers are:
11-14 FLAT PANEL INTERFACE

86CM65 Dual Display Accelerator
83 Incorporated
Section 12: Local Peripheral Bus
Local Peripheral Bus (LPB) operation is enabled The internal block diagram for the LPB is shown
by setting MMFFOO_O to 1. This provides the in Figure 12-1.
following interfaces:
12.1 Scenic/MX2 INTERFACE
• S3 Scenic/MX2TM MPEG AudioNideo De
coder (glueless, bi-directionall
The hardware interface to the Scenic/MX2 is
• Philips@ Video Digitizers (8-or 16-bit in
shown in Figure 12-2.
terface)
• Host Video Data (Pass-through. This al The Scenic/MX2 interface is selected by setting
lows decimation of 32-bit CPU data be MMFFOO_3-1 to OOOb. This interface is fully bi-di
ing written to the frame buffer. rectional. Scenic/MX2 registers can be accessed,
• ZV Port (compliant with Release 007) compressed data sent and decompressed video
data received.
The hardware interfaces are clocked by LCLK.
This requires that MMFFOO_24 be set to 1. Pass
through operation is clocked by SCLK by clearing
MMFFOO_24 to O.
LPB
HOST LPB ...._ .... DATA/ADDRESS ...." 'S'--__- .t
REGISTERS PORT
32
EXTERNAL
DEVICE
TO MEMORY
INTERFACE
TO MEMORY MEMORY ADDRESS
INTERFACE GENERATION
Figure 12-1. LPB Internal Block Diagram
LOCAL PERIPHERAL BUS 12-1

86CM65 Dual Display Accelerator
S3 'nCOI'JIor.ud
12.1.1 Scenic/MX2 Register/Memory If the Scenic/MX2 is not ready to receive data, it
drives its CREO/CRDY signal low during the AO-O
Access
byte (LSB) of the address phase. The 86CM65
then delays sending the data until the
To read/Write a Scenic/MX2 register or private Scenic/MX2 raises CREO/CRDY. This is depicted
memory location (other than to transfer com in Figure 12-4.
pressed data), the LPB Direct Read/Write Address
register (MMFF14) is written. The new regis Figure 12-5 shows a Scenic/MX2 register/mem
ter/memory data is then written to MMFF18. For ory read when the Scenic/MX2 is ready to pro
a write access, this write triggers the sequence vide data. This is indicated by the Scenic/MX2
shown in Figure 12-3 if the Scenic/MX2 is ready holding the CREO/CRDY high throughout the cy
to receive the data (CREO/CRDY remains high). cle. The three upper bits ofthe first address byte
One cycle after 86CM65 asserts its VREQNRDY are 001 to define a read.
signal, it sends the address in three byte writes.
The first byte is composed of bits 23-16 of If the Scenic/MX2 is not ready to provide data, it
MMFF14. The three upper bits are OOOb to define drives its CREO/CRDY signal low during the ad
this as a write. Bit 4 is 1 for a register access and dress phase. The 86CM65 then waits until the
o
for a memory access. Bits 3-0 are bits 19-16 of Scenic/MX2 raises CREO/CRDY and provides reg
the address. The second byte is bits 15-8 of ister data. This is depicted in Figure 12-6.
MMFF14 and the third byte is bits 7-0. The data
immediately follows in four byte writes. Data is To prevent data starvation and deal with request
written in the opposite byte order to that for the contention, the following protocol is followed.
address, i.e., least significant byte (bits 7-0) first
and most significant byte (bits 31-24) last. The • No transaction can be initiated if the bus
86CM65 then deasserts VREQNRDY. The Host is active
repeats the above sequence for another write if
• There is one dead cycle on the bus fol
required.
lowing all transactions
ScenicIMX2 .. 86CM65
...
LCLK LCLK
....... ......
LD[7:0] ......... ....... LD[7:0]
...
VREQNRDY ..... VREQNRDY
...
CREQ/CRDY ... CREQ/CRDY
....
ENABLE ..... ENFEAT
,
I I I
AVCTOK
Figure 12-2. 86CM65 to Scenic/MX2 Interface
12-2 LOCAL PERIPHERAL BUS

86CM65 Dual Display Accelerator
83 Incorporllted
LCLI(
________________________
\~ ~r
VREQ/VRDY
LD[7:0) -------( D3
Figure 12·3. Scenic/MX2 Write (Scenic/MX2 Ready)
LCLK
\ I
CiiEQlCRDY
,-
\
VREQIVRDY
LO[7:OJ
Figure 12-4. Scenic/MX2 Write (Scenic/MX2 Not Ready)
LCLK
CREOICRDY
YiiEQlVRDY \~--------------------------~,.
LD[7~------~~~
Figure 12·5. Scenic/MX2 Read (Scenic/MX2 Ready)
____________________________________________
m-~~~~ ~r-
Figure 12·6. Scenic/MX2 Read (Scenic/MX2 Not Ready)
LOCAL PERIPHERAL BUS 12-3

86CM65 Dual Display Accelerator
sa InoorpoNted
• One device may not initiate a transac transferred exactly as for a register/memory
tion until the second cycle following the write. Following doublewords in the burst are
completion of a transaction initiated by each separated by one dead cycle. The address
the other device has no meaning except for the upper three bits,
which are forced to 110b by hardware to specify
• Neither device may initiate a transaction
until the third cycle following the com a compressed data transfer. Note that burst
pletion of a transaction initiated by itself writes that end because the FIFO is empty (as
opposed to the maximum burst count being
• If CREO/CRDY and VREQNRDY are both
reached) hold VREQNRDY low for one more cy
driven low on the same cycle (request
cle than is shown in Figure 12-7.
contention), CREO/CRDY (the
Scenic/MX2) wins.
The Scenic/MX2 cannot accept a burst larger than
eight doublewords. If MMFFOO_17-16 are pro
12.1.2 Scenic/MX2 Compressed Data grammed to 11 b (burst all) and eight double
words are loaded into the FIFO, software must
Transfer
ensure that the FIFO is empty before loading
more data into the FIFO.
The 86CM65 has an output FIFO for handling the
transfer of compressed video data from the Host A compressed data transfer when the
to the Scenic/MX2 (see Figure 12-1). The Host Scenic/MX2 is not ready to receive data is almost
must first check the number of empty slots the same as a register write for the same circum
(MMFF04_3-0), then send no more than this stances (see Figure 12-4). The only difference is
many doublewords (32 bits) of compressed data that after the Scenic/MX2 returns its CRDY signal,
to the FIFO. An eight doubleword address range additional doubleword packets may be burst to
(FF40H -FF5CH) is provided for this FIFO. Writes the Scenic/MX2 as shown in Figure 12-7.
to any ofthese addresses are directed tothe FIFO.
The Scenic/MX2 can stop a compressed data
MMFFOO_17-16 are programmed to specify the transfer by pulling CREO/CRDY low for one (and
number of doublewords of data to burst to the only one) cycle during byte three of any double
Scenic/MX2. A write to the output FIFO then word. This is shown in Figure 12-8.
initiates a compressed data write to the
Scenic/MX2. This is depicted in Figure 12-7 for a An output FIFO empty interrupt can be enabled
burst count of 2 (MMFFOO_17-16 = 01b) for the by setting MMFF08_17 to 1. The status is read via
case where the Scenic/MX2 is ready to receive bit 1 ofthis same register.
the data. The address and first doubleword are
________________________________________________
WI~~L ~r
Figure 12·7. Scenic/MX2 Compressed Transfer (Ready)
12-4 LOCAL PERIPHERAL BUS

••
r
86CM65 Dual Display Accelerator
S3 Incorporated
,
LCLK
,
r
CREQ/CRDY
r
VRECWRDY
LD[7:0) Ao-2
Figure 12-8. Scenic/MX2 Stopping a Compressed Xfer
12.1.3 Scenic/MX2 Video Capture • The line stride is programmed
(MMFF34_10-0). This is not required if
HSYNCs are not being sent.
The following setup is done for Scenic/MX2
video capture:
The 86CM65 signals its readiness to accept data
• The 86CM65 is placed in Scenic/MX2 by driving VREO/VRDY high. This is done auto
matically when the 86CM65 does not need to
mode (MMFFOO_3-1 = OOOb).
drive this signal low such as to initiate a register
• One or two frame buffer starting ad access or to indicate an LPB video FIFO full state.
dresses are defined (MMFFOC, The Scenic/MX2 responds by sending a VSYNC
MMFF10). One is required. The second (CREQfCRDY low for one cycle) followed by an
is required for double buffering. HSYNC (CREQfCRDY low for two cycles). This is
• The horizontal and vertical decimation shown in Figure 12-9. As indicated in the figure,
registers are programmed (MMFF2C, the time between VSYNC and HSYNC is variable.
MMFF30). This is optional. The HSYNC sequence occurs after each line, but
may not occur before the first line, depending on
how the Scenic/MX2 is programmed.
LCLK
CREQlCRDY
HSYNC
CPVSHS
Figure 12-9. Scenic/MX2 VSYNC and HSYNC Protocols
LOCAL PERIPHERAL BUS 12-5

86CM65 Dual Display Accelerator
83 Incorpomed
After the VSYNC/HSYNC sequence, the Sce 86CM65 cannot accept more data, such as when
nic/MX2 can pull CREO/CRDY low at any time and its LPB video FIFO is full, it drives its VREQNRDY
begin sending data three clocks later. This is signal low during the first byte phase of a 4-byte
shown in Figure 12-10. The 86CM65 assumes packet. All bytes starting with this one are re
data has begun any time CREO/CRDY is held low jected by the 86CM65 and must be resent by the
for more than two cycles. When the Scenic/MX2 Scenic/MX2 after the 86CM65 drives its
is sending the last byte, it drives CREO/CRDY VREQNRDY signal high again. This is depicted in
high. The Scenic/MX2 must always send data in Figure 12-11, where the DnO byte, which is the
4-byte packets. If it has fewer to send for the last first byte of the nth 4-byte packet, is rejected.
packet, it must pad the transmission with dummy When the 86CM65 can accept more data, it drives
writes to create a 4-byte packet. VREO/VRDY high. The Scenic/MX2 drives
CREO/CRDY high (two cycles later) and then
Figure 12-10 shows what happens when the drives it low when it is ready to resend the data.
86CM65 is ready to receive all the data. If the
LCLK
CRECllCRDY \~--------------------~~~----~I
ss
VREOIVRDY
LD(7:0] -----------{
Figure 12-10. Scenic/MX2 Video Input (86CM65 Ready)
LD[7:0]~
Figure 12-11. Scenlc/MX2 Video Input (86CM65 Not Ready
12-6 LOCAL PERIPHERAL BUS

86CM65 Dual Display Accelerator
sa Inoorporated
The resend of DnO and subsequent bytes starts The SceniC/MX2 documentation describes this
two cycles later. interface.
When the 86CM65 receives an HSYNC from the
12.2.1 12C Interface for SAA711 0
SceniC/MX2, it adds the line offset (MMFF34_10-
0) to the previous line starting address and starts
writing the next data at that location. In this way, SAA7110 registers are programmed via a serial
for example, it can transfer 640-byte lines into a 12C interface. This interface is described in Sec
frame buffer configured for 1024-byte lines. If tion 13.
HSYNCs are not sent, memory will be written in
a contiguous manner.
12.2.2 SAA7110 Video Input
12.2 DIGITIZER INTERFACE
The following setup is done for SAA7110 video
input:
86CM65 provides a glueless interface to the
Philips digitizer in Video 16 mode (MMFFOO_3-1 • The 86CM65 is placed in Video 16 mode
= 001b) as shown in Figure 12-12. This section (MMFFOO_3-1 = 001b)
describes the interface to the Philips SAA7110
• Byte swapping is disabled by setting
digitizer.
MMFFOO_6 to 1.
As an alternative, the SceniC/MX2 provides a • The correct vertical and horizontal sync
glueless interface to the SAA7110. In this case, polarities are specified (MMFFOO_9, 10).
the SceniC/MX2 converts the 16-bit data to 8-bit • One or two frame buffer starting ad
data and also provides the 12C interface to the dresses are defined (MMFFOC,
SAA7110. The 86CM65 then receives the video MMFF10). One is required. The second
data, clock and controls from the SceniC/MX2. is required for double buffering.
86CM65
SAA7110
.....
V[7:0] LD[7:0]
~
UV[7:0] ........ LD[15:7]
LLC LCLK
~..
...
HS .. HS
VS ... VS
..
....
...
SDA ..... .. SPD
.......
SCK . . .. . SPCLK
ODD ... ODD
AVOTOK
Figure 12-12. 86CM65 to SAA7110 Digitizer Interface
LOCAL PERIPHERAL BUS 12-7

86CM65 Dual Display Accelerator
83 Incorporated
• The horizontal and vertical decimation pled by setting MMFFOO_29 to 1. Pin M17 in
registers are programmed (MMFF2C, configured as the ODD input when the memory
MMFF30). This is optional. type is 256Kx16 and PWM operation is disabled
• The video input window size (height in (SR52_0 = 0).
lines and width in pixels) is pro
The state of the ODD signal can be read via
grammed in MMFF24.
MMFF04_20. MMFF04_21 can be read to deter
• The video data horizontal and vertical mine which buffer is being used to store incom
offsets are programmed in MMFF28.
ming data.
• The line offset (stride) is programmed
(MMFF34_10-0). If digitizer outputto a CR or flat panel is required,
alternate frames of the video input must be dis
The SAA7110 then sends video data as shown in carded (not written to memory) by setting bit 5
Figure 12-13. In this figure, both VSYNC (VS) and of MMFFOO to 1.
HSYNC (HS) have active high polarity. The verti
cal offset (MMFF28_24-16) is 1, meaning the first If the digitizer has an 8-bit interface, Video 8 In
line is skipped. The horizontal offset HO mode is selected by programming MMFFOO_3-1
(MMFF28_11-0) is 1, meaning that the first data to 010b.
starts one clock after the second HS goes low. HS
goes high again some time after the last byte of
12.3 HOST PASS-THROUGH
the line, whose position is specified by the line
width (LW) programmed in MMFF24_11-0. The
widths of the VS and HS pulses shown may vary. When pass-through mode is enabled
(MMFFOO_3-1 = 100b), the CPU can write 32-bit
To provide a full interlaced video output to a TV data to the output FIFO and have this data passed
set, double buffering must be used. One buffer directly to the decimation block (bypassing the
(LPB address 0) specifies the start of the even LPB bus). The data are sent exactly as for com
field data. The other buffer (LPB address 1) speci pressed video data to an MPEG decoder. The
fies the start of the odd field data. The Streams data will then be decimated according to the
Processor buffer starting addresses must be cor programming of MMFF2C (horizontal) and
respondingly programmed. MMFFOO_30 is set to MMFF30 (vertical) and then passed to the video
1 to direct the incoming data to the proper buffer FIFO to be written to display memory. This path
based on the state of the ODD input. If required, is shown in Figure 12-1.
the ODD signal can be inverted before it is sam-
LCLK
...J!
VS __ ~s~------~s~s---------------
---1-.....
P-:-1-iJ-;;E---+"-=--itu-._~-.~-DO~'&~. ~-L~--Dn--1--Dn-.-1
LDP: -. -. __I L
f-. --&Kl-.
1
Figure 12-13. Video 8 In or 16 Mode Input
12-8 LOCAL PERIPHERAL BUS

••
r
86CM65 Dual Display Accelerator
S3 Incorporned
When the Host sends an HSYNC (MMFFOO_12 = MMFF10). One is required. The second
1) or VSYNC (MMFFOO_11), the decimation reg is required for double buffering.
isters are re-Ioaded. Therefore, the Host must
• The horizontal and vertical decimation
ensure that at least 5 clocks pass between the
registers are programmed (MMFF2C,
sync and the start of data to allow time for this MMFF30). This is optional.
reloading.
• The video input window size (height in
lines and width in pixels) is pro
Pass-through is not supported if big-endian ad
grammed in MMFF24.
dressing is being used.
• The video data horizontal and vertical
offsets are programmed in MMFF28.
12.4 ZV PORT INTERFACE
• The line offset (stride) is programmed
(MMFF34_10-0).
The'Z)J Port, or Zoomed Video Port, allows direct
transmission of video data from a PC Card to the
During 'Z)J Port operation, the 86CM65 automat
86CM65. The 86CM65 supports 'Z)J Port operation ically detects even and odd video fields based on
when its LPB function is enabled (MMFFOO_O = 1)
the state of HS on the falling edge of VS.
and LCLK is selected (MMFFOO_24 = 1). The fol
lowing setup is done for 'Z)J Port operation: The interface is shown in Figure 12-14.
• Video 16 mode is selected (MMFFOO_3-1
= 001b)
• The 'Z)J Port enable bit is set
(MMFFOO_31 = 1)
• MMFF090_9 and MMFFOO_10 must be
set to 1 to specify active high HSYNC
(HS) and VSYNC (VS).
• Byte swapping is disabled by setting
MMFFOO_6 to 1.
• One or two frame buffer starting ad
dresses are defined (MMFFOC,
86CM6S
PC CARD
......
Y[7:0] ...... LD[7:0]
......
UV[7:0] ...... LD[1S:7]
..
...
PCLK LCLK
.....
HREF HS
...
...
VSYNC VS
AZrOK
Figure 12-14. ZV Port Interface
LOCAL PERIPHERAL BUS 12-9

86CM65 Dual Display Accelerator
53 Incorponlted

86CM65 Dual Display Accelerator
sa Incorporaud
Section 13: Miscellaneous Functions
This section explains the video BIOS ROM inter 13.2 GENERAL INPUT PORT
face, the General 110 Ports and interrupt genera
tion.
The 86CM65 provides a 4-bit General Input Port
(GIP) as part of its LPB function. The following
13.1 VIDEO BIOS ROM INTERFACE steps are required to implement it.
1. Disable all other LPB uses.
For mobile systems, the video BIOS is usually
part of the system ROM. A separate ROM inter 2. Enable senSing of the desired input data on
face is supported for testing purposes. LD[7:4].
3. If the LPB General Output Port function is
The RD[7:0] (ROM data) and RA[15:0] (ROM ad also in use, ensure that the correct output
dress) signals are multiplexed on the PD[23:16] data is programmed in MMFF1C_3-0.
and PD[15:0] pins respectively. The ROMEN
4. Program SR1A_4 to 1 to select STWR.
(ROM chip enable) signal is multiplexed with the
FPPOL signal. ROMEN is selected when SR1A_5 5. Write (anything) to CR5C. The data on
= o. The BIOS ROM must be shadowed immedi LD(7:4] are latched 2 DCLKs later into
ately after reset(as the PCI standard requires) and MMFF1C3-4. (This also drives the con
BIOS access disabled to prevent interference tents of MMFF1C_3-0 onto LD(3:0] and
with graphics operation. generates the STWR pulse on pin C3. The
T3
T1 T2
DCLK
F
STWR ,'-______. ..... LATCH
-''f&.
~~
LD[3:0] ______
VLPBGOP
Figure 13-1. General I/O Port Timing
MISCELLANEOUS FUNCTIONS 13-1

86CM65 Dual Display Accelerator
S3 Incorporated
input data is latched on the rising edge of Typical uses for the serial port are for DDC moni
STWR. See Figure 13-1) tor communications and 12C interfacing. When
6. Disable sensing of input data on LD[7:4]. SPCLK and SPD are tri-stated, the 86CM65 can
detect an 12C start condition (SPD driven low
while SPCLK is not driven low). This condition is
13.3 GENERAL OUTPUT PORT generated by another 12C master that wants con
trol of the 12C bus. If bit 19 of MMFF08 is set to 1,
The 86CM65 provides a 4-bit General Output Port detection of a start condition generates an inter
(GOP) as part of its LPB function. To implement rupt and sets bit 3 of MMFF08 to 1. If bit 24 of
this: MMFF08 is setto 1, the 86CM65 drives SPCLK low
to generate 12C wait states until the Host can clear
1. Disable all other LPB uses. the interrupt and service the 12C bus.
2. Program the desired output in MMFF1C_4-0.
If PD26 is strapped low at reset, strapping of PD25
4. Program SR1A_4 to 1 to enable output of selects either E2H (PD25 pulled high) or E8H
STWR on pin C3. (PD25 pulled low) as the I/O port address for the
5. Write (anything) to CR5C. The data in Serial Port register. This allows the ports to be
MMFF1C_3-O are immediately driven onto used for serial communications, typically 12C,
LD[3:0] and the STWR pulse is generated. even when the 86CM65 is not enabled.
The rising edge of STWR (2 DCLKs after it
is asserted) can be used to latch the data
13.5 INTERRUPT GENERATION
into an external device. The data is held
valid for 1/2 DCLK after this edge. See Fig
ure 13-2. Whatever the mode of operation (VGA or En
hanced), bit 4 of CR32 must be set to 1 to enable
The 86CM65 also provides a 1-bit GOP on a interrupt generation. When an enabled interrupt
dedicated pin. To implement this: is generated, INTA is pulled low.
1. Clear SR1A_4 to Ob to make pin C3 act as When the 86CM65 is being operated in VGA
GOPO. mode (CR67 _0 = 0), only a vertical retrace can
generate an interrupt. This is enabled when bit 5
2. Program the desired output in CR5C_O. This
of CR11 is cleared to 0 and a 1 has been pro
statically drives the state of CR5C_O onto
grammed into bit 4 of CR11. When an interrupt
the GOPO pin. This pin will continue to re
occurs, it is cleared by writing a Oto bit4 ofCR11.
flect the register bit states as long as
The interrupt must then be re-enabled by writing
SR1A-4 = O. The value in CR5C_0 can be
a 1 to the same bit. Note tha°t t he BIOS clears both
reprogrammed at any time.
bit 4 and bit 5 of CR11 to during power-on, a
mode set or a reset. Thus, interrupt generation is
13.4 SERIAL COMMUNICATIONS disabled until bit 4 is set to 1.
PORT
When the 86CM65 is being operated in Enhanced
mode (CR67_0 = 1), interrupts can be generated
A serial communications port is implemented in by a vertical retrace, Graphics Engine busy, com
the MMFF20 register. Bit 4 is set to 1 to enable mand FIFO overflow and command FIFO empty.
the interface. The clock is written to bit 0 (= 0) and These interrupts are enabled and cleared and
data to bit 1 (= 0), driving the SPCLK and SPD pins their status reported via 42E8H.
low respectively. The state ofthe SPCLK pin can
be read via bit 2 and the state of the SPD pin can Multiple interrupts can be enabled at the same
be read via bit 3. The SPCLK and SPD pins are time in Enhanced mode. The interrupt pin will
tri-stated when their corresponding control bits remain asserted until all interrupt status bits are
are reset to 0, allowing other devices to drive the cleared.
serial bus.
13-2 MISCELLANEOUS FUNCTIONS

86CM65 Dual Display Accelerator
53 Incorponted
Section 14: Basic Software Functions
This section describes some of the basic operations required to program 86CM65.
14.1  CHIP WAKEUP
The following program wakes up the 86CM65. This is required for systems that do not use the S3 style
of video BIOS, e.g, UNIX.
| mov dx,3c3h  | Video Subsystem Enable register address  |     |     |
| ------------ | ---------------------------------------- | --- | --- |
bit 0 = 1,
| mov al,Olh    |                                          | enable graphics display  |         |
| ------------- | ---------------------------------------- | ------------------------ | ------- |
| out dx,al     | write new bit values to 3c3h             |                          |         |
| mov dx,3cch   | Miscellaneous OUtput Read register       |                          |         |
| in al,dx      | Read 3cch                                |                          |         |
| [load CRTCs]  | program CRTC                             | registers                |         |
| mov dx,3C6h   | DAC  Mask register address               |                          |         |
| mov  al,FFh   | DAC  Mask register initialization value  |                          |         |
| out dx,al     | Initialize DAC                           | mask and release BLANK   | signal  |
14.2 REGISTER ACCESS
S3 has added a number of graphics registers to the standard VGA set. These can be locked when not
in use to prevent accidental access and unlocked when access is requires. This section explains how
this is done.
14.2.1  Unlocking the S3 Registers
The S3 registers (CR30 and higher plus the Enhanced Commands registers) must be unlocked before
they can be accessed by the CPU. The code to do this is:
Note: Byte operations are used in the following examples for clarity. Word operations, e.g.,
mov ax, 4838h
out dX,ax
should be used for efficiency instead of the operations used in the first example below.
BASIC SOFTWARE FUNCTIONS 14-1

86CM65 Dual Display Accelerator
S3 Inoorpo. .t ecl
;  Write  code  to  SR8  to provide access  to  the  S3  extended  Sequencer registers
(SR9-SRFF)
| mov dx,3c4h  | copy index register address into dx  |                          |
| ------------ | ------------------------------------ | ------------------------ |
| mov al,08h   | copy index for SR8                   | register into al         |
| out dx,al    | write index to index register        |                          |
| inc dx       | increment dx to 3c5h                 | (data register address)  |
mov al,06h  copy unlocking code  (xxxxOllOb,  x=don't care)  to al
| out dx,al  | write the unlocking code to the data register  |     |
| ---------- | ---------------------------------------------- | --- |
| dec dx     | restore the index register address to dx       |     |
Write code to CR38  to provide access to extended CRTC  registers CR2D-CR3F
| mov dx,3d4h  | copy index register address into dx  |                          |
| ------------ | ------------------------------------ | ------------------------ |
| mov al,38h   | copy index for CR38                  | register into al         |
| out dx,al    | write index to index register        |                          |
| inc dx       | increment dx to 3DSh                 | (data register address)  |
mov al,48h  copy unlocking code  (OlxxlOxxb,  x=don't care)  to al
| out dx,al  | write the unlocking code to the data register  |     |
| ---------- | ---------------------------------------------- | --- |
| dec dx     | restore the index register address to dx       |     |
Write code to CR39  to provide access to extended CRTC  registers CR40-CRFF
dx is already loaded with 3D4h because of the previous instruction
| mov al,39h  | copy index for CR39            | register into al         |
| ----------- | ------------------------------ | ------------------------ |
| out dx,al   | write index to index register  |                          |
| inc dx      | increment dx to 3DSh           | (data register address)  |
mov al,OaSh  copy unlocking code to al  (the code a5H also unlocks
access to configuration registers CR36,  CR37  and CR68
| out dx,al  | write the unlocking code to the data register  |     |
| ---------- | ---------------------------------------------- | --- |
| dec dx     | restore the index register address to dx       |     |
°
Set bit  in CR40  to enable access to the Enhanced Programming registers.
dx is already loaded with 3D4h because of previous instruction
| mov al,40h  | copy index for CR40            | register into al         |
| ----------- | ------------------------------ | ------------------------ |
| out dx,al   | write index to index register  |                          |
| inc dx      | increment dx to 3DSh           | (data register address)  |
in al,dx  read reg°is ter data for read/modify/write operation
| or al,l    | set bit  to 1                                  |     |
| ---------- | ---------------------------------------------- | --- |
| out dx,al  | write the unlocking code to the data register  |     |
| dec dx     | restore the index register address to dx       |     |
14-2 BASIC SOFTWARE FUNCTIONS

86CM65 Dual Display Accelerator
S3 Ino .....o r.ted
14.2.2 Locking the S3 Registers
Relocking the S3 registers is done by repeating the code used to unlock the registers except:
1.  The values written to the SR8, CR38 and CR39 registers must change at least one of the signifi
cant bits in the valid code pattern. For example, OOh will always accomplish this.
2.  After first verifying that the Graphics Engine is not busy (bit 9 of 9AE8H is 0), bit 0 of CR40
must be cleared to o. A read-modify-write cycle must be used instead of the code used above
to prevent overwriting of any changes made to bits 7-1 in CR40 since reset.
| mov dx,3d4h  | copy index register address into dx  |     |     |
| ------------ | ------------------------------------ | --- | --- |
mov al,40h
|              | copy index for CR40            | register into al         |     |
| ------------ | ------------------------------ | ------------------------ | --- |
| out dx,al    | write index to index register  |                          |     |
| inc dx       | increment dx to 3D5h           | (data register address)  |     |
| in al,dx     | read content of CR40           | into al                  |     |
| and al,Ofeh  | clear bit 0 to 0               |                          |     |
out dx,al  write to CR40  to lock the Enhanced Commands  registers
| dec dx  | restore the index register address to dx  |     |     |
| ------- | ----------------------------------------- | --- | --- |
14.3 TESTING FOR THE PRESENCE OF AN 86CM65 CHIP
After unlocking, an 86CM65 chip can be identified via CR2E. The following code aborts the driver
program and returns to DOS if an 86CM65 chip is not found.
| mov dx,3d4h  | copy index register address into dx  |                          |        |
| ------------ | ------------------------------------ | ------------------------ | ------ |
| mov al,2eh   | copy index for CR2E                  | register into al         |        |
| out dx,al    | write index to index register        |                          |        |
| inc dx       | increment dx to 3D5h                 | (data register address)  |        |
| in al,dx     | read content of CR2E                 | into al                  |        |
| cmp  al,12h  | compare chip ID                      | to the desired chip ID   | (12h)  |
jne not_12  jump to a  label if chip ID does not match desired ID
|     | 86CM65  found - | continue with setup  |     |
| --- | --------------- | -------------------- | --- |
Specific revisions of the chip can be identified via CR2F. The PCI configuration space device and revision
10 fields can also be used to identify the chip.
14.4 GRAPHICS MODE SETUP
Some programs may require a graphics mode other than that provided by standard operation. For
example, a DOS game may require a resolution of 640x400x8 (VESA mode 100) instead of the standard
DOS mode, e.g., mode 03. The following code fragment shows how this is done.
| mov ax,4f02h  | VESA  super VGA mode  | function call  |     |
| ------------- | --------------------- | -------------- | --- |
| mov bX,100h   | mode  100             |                |     |
| int 10h       | call video BIOS       |                |     |
BASIC SOFTWARE FUNCTIONS  14-3

86CM65 Dual Display Accelerator
S3 Inoorporated

86CM65 Dual Display Accelerator
S3 Incorporated
Section 15: VGA Compatibility Support
This section describes 86CM65 support for standard VGA and VESA Super VGA graphics standards.
15.1 VGA COMPATIBILITY
The 86CM65 is compatible with the VGA standard. These modes are not accelerated using the Graphics
Engine. However, other design features provide excellent VGA performance.
Several of the standard VGA registers have been modified or extended in the 86CM65. Table 15-1
describes these changes.
Table 15-1. Standard VGA Registers Modified or Extended in the 86CM65
Register Change to Standard VGA Definition
CRO Extension bit 8 is bit 0 of CR5D. Bit 5 of CR35 controls access to this register. Bit
7 of CR43 doubles the parameter size. The flat panel equivalent is SR60.
CR1 Extension bit 8 is bit 1 of CR5D. Bit 5 of CR35 controls access to this register. Bit
7 of CR43 doubles the parameter size. The flat panel equivalent is SR61.
CR2 Extension bit 8 is bit 2 of CR5D. Bit 5 of CR35 controls access to this register. Bit
7 of CR43 doubles the parameter size. The flat panel equivalent is SR62.
CR3 The length of the blanking pulse defined in this register can be extended by 64
DCLKs via bit 3 of CR5D. Bit 5 of CR35 controls access to this register. Bit 7 of
CR43 doubles the parameter size. The flat panel equivalent is SR63.
CR4 Extension bit 8 is bit 4 of CR5D. Bit 5 of CR35 controls access to this register. Bit
7 of CR43 doubles the parameter size. The flat panel equivalent is SR64.
CR5 The length of the HSYNC pulse defined in this register can be extended by 32
DCLKs via bit 5 of CR5D. Bit 5 of CR35 controls access to this register. Bit 7 of
CR43 doubles the parameter size. The flat panel equivalent is SR65.
CR6 In addition to the standard VGA extensions (bit 8 is bit 0 of CR7, bit 9 is bit 5 of
CR47), bit 10 is bit 0 of CR5E. Bit 4 of CR35 controls access to this register. The
flat panel equivalent is SR68.
CR7 Bit 4 of CR35 controls access to bits 0, 2, 3, 5 and 7 of this register.
CR9 Bit 4 of CR35 controls access to bit 5 of this register.
CRC The display start address is a 20-bit value for the 86CM65. The extension bits (20-
16) are bits 4-0 of CR69.
CRE The cursor location address is a 20-bit value for the 86CM65. The extension bits
(20-16) are bits 4-0 of CR69.
VGA COMPATIBILITY SUPPORT 15-1

86CM65 Dual Display Accelerator
83 Incorporated
CR10 In addition to the standard VGA extensions (bit 8 is bit 2 of CR7, bit 9 is bit 7 of
CR7), bit 10 is bit 4 of CR5E. Bit 4 of CR35 controls access to this register. The
flat panel eauivalent is SR6C.
CR11 Bit 4 of CR35 controls access to bits 3-0 of this register. Bit 6 (3/5 refresh cycles
per line) can be overridden by CR3A_2-0. Setting bit 1 of CR33 to 1 disables the
write protect effect of bit 7 of this register on bits 1 and 6 of CR7. The flat panel
eauivalent is SR6D.
CR12 In addition to the standard VGA extensions (bit 8 is bit 1 of CR7, bit 9 is bit 6 of
CR7), bit 10 is bit 1 of CR5E. The flat panel equivalent is SR69.
CR13 Bit 2 of CR43 is the old extension bit (bit 8) of this register. Bits 5-4 of CR51 are
the new extension bits (bits 9-8) of this register.
CR15 In addition to the standard VGA extensions (bit 8 is bit 3 of CR7, bit 9 is bit 5 of
CR9), bit 10 is bit 2 of CR5E. Bit 4 of CR35 controls access to this register. The
flat panel equivalent is SR6A.
CR16 Bit 4 of CR35 controls access to this register. The flat panel equivalent is SR6B.
CR17 Bit 5 of CR35 controls access to bit 2 of this register.
CR18 In addition to the standard VGA extensions (bit 8 is bit 4 of CR7, bit 9 is bit 6 of
CR9), bit 10 is bit 6 of CR5E.
AROO-AROF Bit 6 of CR33 controls access to these registers.
3C6H-3C9H Bit 4 of CR33 controls writes to these registers.
For a detailed discussion of VGA programming, see Programmer's Guide to the EGA, VGA and Super
VGA Cards, 3rd Edition by Richard F. Ferraro (Addison-Wesley Publishing Company, Inc).
15.2 VESA SUPER VGA SUPPORT
The 86CM65 supports the extended (Super) VGA modes defined by VESA. All modes are accelerated
by the Graphics Engine except for the planar (4 bits/pixel) ones.
15-2 VGA COMPATIBILITY SUPPORT

86CM65 Dual Display Accelerator
S3 Incorporated
Section 16: Enhanced Mode Programming
Enhanced mode provides a level of performance far beyond what is possible with the VGA architecture.
Hardware line drawing, BitBLT , rectangle fill and other drawing functions are implemented. Also
implemented are data manipulation functions, such as data extension, data source selection, and
read/write bitplane control. Hardware clipping is supported by 4 registers that define a rectangular
clipping area. While in Enhanced mode, the display memory bit map can be updated in two ways. One
is to have the CPU write directly to memory. (This is also possible in non-Enhanced modes via paging.)
The other is to have the CPU issue commands to the Graphics Engine, which then controls pixel
updating. This section explains these two methods and provides a comprehensive set of Enhanced
mode programming examples.
16.1 UNEAR ADDRESSING FOR DIRECT VIDEO MEMORY CPU ACCESSES
Linear addressing is useful when software requires direct access to display memory. Enhanced mode
operation must be enabled before linear addressing is enabled. This means that bit 0 of 4AE8H is set
to 1 to enable Enhanced mode functions and bit 3 of CR31 is set to 1 to specify Enhanced mode memory
mapping.
The 86CM65 provides linear addressing of up to 2 MBytes of display memory. The Graphics Engine
busy flag, bit 9 of 9AE8H, should be verified to be 0 (not busy) before linear addressing is enabled by
setting bit 4 of CR58 to 1. The size of the linear address window is set via bits 1-0 of CR58. The base
address for the linear addressing window is set via CR59 and CR5A (or via the Base Address 0 (Index
10H) PCI configuration register).
For operation in real mode, the linear addressing window size can be set to 64 KBytes. The base address
for the window is set to AOOOOH by programming bits 31-16 of the window position in CR59-CR5A to
OOOAH. The memory page offset (64K bank) specified in bits 4-0 of CR6A is added to the linear
addressing window position base address, allowing access to up to 4 MBytes of display memory
through a 64-KByte window.
The above discussion applies when the 86CM65 is programmed for backwards-compatible MMIO
operation. See Section 16.3.2 for instructions on how to perform linear addressing when new MMIO
is enabled.
ENHANCED MODE PROGRAMMING 16-1

86CM65 Dual Display Accelerator
S3 Incorpor8ted
16.2 VIDEO MEMORY ACCESS THROUGH THE GRAPHICS ENGINE
When updating the display bitmap through the Graphics Engine, all CPU data moves through the Pixel
Data Transfer registers (E2E8H and E2EAH). These can be memory mapped as explained in Memory
Mapping of Enhanced Mode Registers later in this section.
The Graphics Engine manipulates the bits for each pixel to assign a color index or true color value,
which is then translated via a programmable RAMDAC before being displayed on a CRT. Selected bits
in a pixel can be masked off from being displayed by programming the DAC Mask register (3C6H). The
86CM65 can manipulate 64 bits each clock cycle, from two 32-bit pixels to eight 8-bit pixels.
Figure 16-1 is a flowchart for the process of updating the color of each pixel. Start at the block labeled
'New Color' in the middle of Figure 16-1. At this stage, a color has been determined that mayor may
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
• CPU (via the Pixel Data Transfer registers (E2E8H, E2EAH»
• Current display bitmap color index
. One of 16 logical operations is chosen by writing bits 3-0 of the Background Mix and Foreground Mix
registers. Examples of logica! operations are making the ntw. . pixel colo; index equal to the NOT of the
current bitmap color index or making the new index equal to the XOR ofthe source and current bitmap
indices.
When the logical operation and color source have been specified in the Background and Foreground
Mix registers, bits 7-6 of the Pixel Control register are written to specify the source of the mask bit
16-2 ENHANCED MODE PROGRAMMING

86CM65 Dual Display Accelerator
S31naorporded
MASK BIT SOURCE
~
T
NO
SRCNE=O
COLOR COMP = TRUE
SRCNE=1 SRCNE=O
COLOR COMP = FALSE COLOR COMP = FALSE
COLOR
COMPARE
NEW PIXEL COLOR PlXUPDT
Figure 16-1. Pixel Update Flowchart
ENHANCED MODE PROGRAMMING 16-3

,..
r 86CM65 Dual Display Accelerator
83 Incorporated
value. If the resulting mask bit is a 'ONE', the Foreground Mix register is used to determine the color
source and mix. If the mask bit is a 'ZERO', the Background Mix register is used to determine the color
source and mix. There are three sources for the mask bit value:
• Always ONE (Foreground Mix register used)
• CPU (via the Pixel Data Transfer registers (E2E8H, E2EAH»
• Bitmap
Setting bits 7-6 to OOb sets the mask bit to 'ONE'. All drawing updates to the video bitmap use the
Foreground Mix register settings. This setup is used to draw solid lines, through-the-plane image
transfers to display memory and BitBlT s.
If bits 7-6 are set to 10b, the mask bit source is the CPU. After the draw operation command is issued
to the Drawing Command register (9AE8), a mask bit corresponding to every pixel drawn on the display
must be provided via the Pixel Data Transfer register(s). If the mask bit is 'ONE', the Foreground Mix
register is used. If the mask bit is 'ZERO', the Background Mix register is used. Note that if the color
source is the CPU, the mask bit source cannot also be the CPU, and vice versa. This setup is used to
transfer monochrome images such as fonts and icons to the screen.
If bits 7-6 are set to 11 b, the current display bit map is selected as the mask bit source. The Read Mask
register (AAE8H) is set up to indicate the active planes. When all bits of the read-enabled planes for a
pixel are a 1, the mask bit 'ONE' is generated. If anyone ofthe read-enabled planes is a 0, then a mask
bit 'ZERO' is generated. If the mask bit is 'ONE', the Foreground Mix register is used.lfthe mask bit is
'ZERO', the Background Mix register is used. Note that if the color source is the bitmap, the mask bit
source cannot also be the bitmap, and vice versa. This setting is used to BitBlT patterns and character
images.
16.3 MEMORY MAPPING OF REGISTERS
The 86CM65 provides two memory-mapped I/O (MMIO) schemes. One method is identical to that
provided by the Tri064 and provides compatibility with older software. This provides memory mapping
of a limited number of Enhanced mode registers plus the lPB and Streams Processor registers. Packed
register access is also provided. The second method incorporates linear addressing and provides
memory mapping of all registers, including the packed registers. The second method also allows big
or little endian addressing. Each of these MMIO methods is described below.
16.3.1 Backward-Compatible MMIO
Most of the Enhanced registers can be memory-mapped (MMIO). This function is enabled by setting
bits 5-4 of CR53 to 10b.
Image writes normally made via I/O addresses E2E8H and E2EAH (the Pixel Data Transfer registers)
are made instead by accessing any memory location in the 32-KByte address space from AOOOOH to
A7FFFH. This allows efficient use ofthe MOVSWand MOVSD assembly language commands. Accesses
must be to even word or doubleword addresses, depending on the specification of the bus width via
bits 10-9 cf9BEBH. Scfr.·,;are must not make E2ESH, E2EAH writes beyond the A7FFFH range.
Accesses to the Enhanced command registers are made to particular locations in the A8000H to AFFFFH
address range as shown in Table 16-1. Both 16-bit reads and writes are supported. Only 32-bit writes
(bit 9 of BEE8H_E set to 1) are supported.
16-4 ENHANCED MODE PROGRAMMING

86CM65 Dual Display Accelerator
S3 Incorporated
If MMIO is enabled, bit 7 of SR9 allows register access to be either I/O or MMIO or MMIO only.
Table 16-1  Enhanced Registers Memory Mapping
| Register Mnemonic          | 1/0 Address (Hex)  | Register   | PackedMMIO     |
| -------------------------- | ------------------ | ---------- | -------------- |
|                            | MMIO=Axxxx         | Mnemonic   | Address (Hex)  |
|                            |                    | (Packed)   | (Axxxx)        |
| CUR Y. CUR X               | 82E8.86E8          | ALT CURXY  | 8100.8102      |
| DESTY AXSTP. DESTX DIASTP  | 8AE8.8EE8          | ALT STEP   | 8108. 810A     |
| ERR TERM                   | 92E8               |            | 8110           |
| CMD                        | 9AE8               |            | 8118           |
| SHORT STROKE               | 9EE8               |            | 811C           |
| BKGD COLOR                 | A2E8               |            | 8120           |
| FRGD COLOR                 | A6E8               |            | 8124           |
| WRT MASK                   | AAE8               |            | 8128           |
| RD MASK                    | AEE8               |            | 812C           |
| COLOR CMP                  | B2E8               |            | 8130           |
| BKGD MIX. FRGD MIX         | B6E8. BAE8         | ALT MIX    | 8134.8136      |
| SCISSORS T, SCISSORS R     | BEE8 1, BEE8 2     |            | 8138. 813A     |
| SCISSORS B. SCISSORS R     | BEE8 3. BEE8 4     |            | 813C, 813E     |
| PIX CNTL, MULT  MISC2      | BEE8 A. BEE8 D     |            | 8140,8142      |
| MULT  MISC. READ SEL       | BEE8 E. BEE8 F     |            | 8144           |
MIN AXIS PCNT, MAJ AXIS PCNT  BEE8 0,96E8  ALl_PCNT  8148,814A
| PIX TRANS  | E2E8. E2EA  | PIX-TRANS  |     |
| ---------- | ----------- | ---------- | --- |
For improved performance, most of the Enhanced mode registers can also be written (but not read)
via a packed configuration. The 16-bit registers are paired so that two registers can be accessed via a
single 32-bit write. The addresses for this packed configuration are given in Table 16-1. The packed
register access function is enabled when MMIO is enabled.
The 86CM65 supports the Tri064 MMIO scheme when bits 4-3 ofCR53 are programmed to 10b and bit
5 of CR53 is cleared to O. In addition, the LPB and Streams Processor registers are also accessible in
the ABOOOH -AFFFFH window. If bit 5 of CR53 is set to 1, the registers are accessible in the B8000H -
BFFFFH window.  However, image writes cannot be made to BOOOOH -B7FFFH. This region and the
entire AOOOOH -AFFFFH region are left free for VGA memory and other uses.
The Trio64 scheme is also available as explained in the previous paragraph when bit 4-3 of CR53 are
set to 11 b. In this case, the registers can be accessed either by this scheme or by the new MMIO
explained in the next section.
ENHANCED MODE PROGRAMMING  16-5

86CM65 Dual Display Accelerator
S3 Incorporated
16.3.2 New MMIO
The new MMIO method for the 86CM65 provides a 64-MByte addressing window starting at the base
address specified in CR59-5A. This space is divided into a 32-MByte space for little endian (Intel-style)
addressing and a 32-MByte space for big endian (Power PC-style) addressing. All registers and data
transfer locations are mapped into this area as shown in Table 16-2.
Table 16-2 New MMIO Addresses
Lower 32 MBytes • Uttle Endian Addressing
Description Offset From Base (Hex)
Linear Addressina (16M) 0000000 -OFF FFFF
Imaae Data Transfer (32K) 1000000 -100 7FFF
PCI Configuration SRace Reaisters 100 8000 -100 8043
Packed Enhanced Registers 1008100 -100 814A
Streams Processor Registers 1008180 -100 81 FF
Current Y Position Register 100 82E8
CRT VGA 3B? Registers 100 83BO -100 83Bx
CRT VGA 3C? Registers 100 83CO -10 0 83Cx
CRT VGA 3D? Registers 100 8300 -100 83Dx
Subsystem Status Enhanced Register (42E8H) 1008504
Advanced Function Control Register (4AE8H) 100 850C
Enhanced Registers 100 86E8 -100 EEEA
Local Peripheral Bus Registers 100 FFOO -10 0 FF5C
The new MMIO (only) is enabled by setting bits 4-3 of CR53 to 01b. It is also enabled in conjunction
with the old MMIO scheme when bits 4-3 of CR53 are set to 11 b. This is the default configuration,
allowing PCI software immediate access to all registers and the ability to relocate the address space.
To allow MMIO accesses only, bits 1-0 of the PCI Command register (offset 04H) can be programmed
to 10b.
With the new MMIO enabled, the first 16 MBytes of each 32M address space (big and little endian) are
dedicated to linear addressing. A maximum of 2 MBytes of each address space (starting at the lowest
address of the space) is usable with the 86CM65. The base address is taken from bits 31-26 of the linear
address window position (bits 7-2 of CR59 or the high order 6 bits of the PCI Base Address 0). This is
concatenated with the display memory address speCified by the programmer.
In addition to enabling the new MMIO, the programmer must also enable linear addressing and specify
the window size exactly as required for the old linear addressing. Note that since only bits 31-26 are
used to specify the base address, AOOOOH cannot be specified and the 64K banking scheme possible
with the old linear addressing cannot be used with the new linear addressing.
When big endian addressing is used, the required byte swapping for linear addressing is specified by
bits 2-1 of CR53. This applies to both reads and writes.
16-6 ENHANCED MODE PROGRAMMING

86CM65 Dual Display Accelerator
53 Inoorporated
16.4 PROGRAMMING
Three different programming schemes are available, I/O, standard MMIO and packed register MMIO.
Examples of how each is used to assign vertical and horizontal coordinates to Current X and V Position
registers (82E8H and 86E8H) are:
I/O Format:
MOV DX,CUR_X
MOV AX,X
OUT DX,AX
MOV DX,CUR_V
MOV AX,V
OUT DX,AX
Standard MMIO Format:
EnableMMIO
Point ES to AOOOH
Load x and y values into AX and BX
MOV ES:[CUR_y ], BX
MOV ES:[CUR_XJ, AX
Packed Register MMIO:
EnableMMIO
Point ES to AOOOH
Load the x and y values into EAX (y value in the low word and x value in the high word), I.e.,
31 15 0
EAX<=I X V~
MOV ES:[ALT _CURXYJ, EAX
The packed register MMIO scheme is the most efficient and is used where appropriate in the
programming examples provided later in this section. All assume that the ES register points to AOOOH.
16.4.1 Notational Conventions
The REG MNEMONIC on the left hand side of the arrow is the register mnemonic of the I/O port being
written into. Text following a ';' is a comment.
REGMNEMONIC <= XXXXH ; Load a hexadecimal value into the register.
REGMNEMONIC <= XXXXD ; Load a decimal value into the register.
REGMNEMONIC <= XXXX ; Load a decimal value into the register
REGMNEMONIC <= XXXXXXXXXXXXXXXXB ; Load a binary value into the register.
Image transfers (CPU pixel data writes to the frame buffer) are notated as follows:
COUNT
PIX_TRANS <= IMAGEDATA
ENHANCED MODE PROGRAMMING 16-7

86CM65 Dual Display Accelerator
S3 lnoorporllted
The COUNT is the number of CPU writes. PIX_TRANS means either the E2E8H, E2EAH pixel transfer
registers or the 32K memory space from AOOOOH to A7FFFH as explained in Section 16.3.1 above.
16.4.2 Initial Setup
All examples assume the desired mode is selected.
The Bitmap Access Through the Graphics Engine section earlier in this section explains in detail how
the colors, mixes and the data extensions are set for each example. These registers need not be set
repeatedly before a series of draw commands if they use the same colors, mixes and data extension.
All bitmap updates are affected by the settings in the clipping registers (BEE8H, Indices 1-4) and the
choice of internal or external clipping (BEE8H, Index E, bit 5). These must be set up so they include the
area being drawn into.
If color compare is to be used, it must be enabled by setting bit8 ofBEE8H, IndexOEH to 1. Bit7 of this
register determines whether a TRUE or FALSE comparison allows the pixel update to continue. The
comparison color is programmed into the Color Compare register (B2E8).
All planes are enabled for writing unless explicitly set otherwise in an example. This is done via the
Write Mask register (AAE8H).
16.4.3 Programming Examples
This section provides programming examples for the following Enhanced mode drawing operations:
• Solid Line
• Textured Line
• Rectangle Fill Solid
• Image Transfer-Through the Plane
• Image Transfer-Across the Plane
• BitBlT - Through the Plane
• BitBlT - Across the Plane
• PatBlT - Through the Plane
• PatBlT - Across the Plane
• Short Stroke Vectors
• Programmable Hardware Cursor
Some programming steps are repeated in mUltiple examples. They are explained in detail at their first
occurrence. Therefore, readers are encouraged to work through the examples from first to last. The
register mnemonics used in the examples are listed in Table 15-1. Other mnemonics used are:
Mnemonic Description
=
NEW Mix 00111 b in bits 4-0 of BAE8H or B6E8H. This overwrites the present
bitmap color value with a new value. .
XOR Mix = 00101 b in bits 4-0 of BAE8H or B6E8H. The current bitmap color is
XORed with the new color.
16-8 ENHANCED MODE PROGRAMMING

86CM65 Dual Display Accelerator
83 Incorporettld
| 16.4.3.1  Solid Line  |     |     |     |
| --------------------- | --- | --- | --- |
This command draws a one pixel wide solid line from screen coordinates x1,y1 to x2,y2. Bresenham
parameters are used to define the line. The Pixel Control register (BEE8H, Index AH) must be set to
AOOOH to select the Foreground Mix register to specify the color source and mix type.
Setup:
Drawing a line using axial coordinates requires programming the axial step constant into the Destina
tion Y-Position/AxiaIStep Constant (8AE8H) register (DESTY_AXSTP), the diagonal step constant into
the Destination X-Position/Diagonal Step Constant (8EE8H) register (DESTX_DIASTP) and the error
term into the Error Term (92E8H) register (ERR_TERM). Calculation of these Bresenham parameters is
based on the MAX and MIN parameters as calculated below.
MAX = maximum(ABS(x2-x1), ABS(y2-y1»
MIN = minimum(ABS(x2-x1), ABS(y2-y1»
where maximum means choose the largest of the two terms in parentheses and minimum means
choose the smallest. ABS means take the absolute value of the expression.
Bits 7-5 of the Drawing Command (9AE8H) register (CMD) specify the drawing direction. Setting bit 7
to 1 means that the Y drawing direction is positive (y1 < y2). Clearing bit 7 to 0 means the Y drawing
direction is negative (y1 > y2). Setting bit 6 to 1 means that Y is the major (longer) axis (ABS(x2-x1) >
ABS(y2-y1)). Clearing bit 6 to 0 means that X is the major axis. Setting bit 5 to 1 means that the X
drawing direction is positive (x1 < x2). Clearing bit 5 to 0 means that the X drawing direction is negative
(x1 > x2). These values replace the DOD sequence in the write to the CMD register shown in the
pseudocode below.
The mix NEW represents a setting of 0111b in bits 3-0 of the Foreground Mix (BAE8H) register
(FRGD_MIX). This overwrites the present bitmap color value with a new value.
The remainder of the setup is:
| ES:[FRGD_MIX] ~ 0027H       |     |     | ; color source is FRGD_COLOR, mix type is NEW  |
| --------------------------- | --- | --- | ---------------------------------------------- |
| ES:FRGD_COLOR] ~ 00000002H  |     |     | ; color index                                  |
ES:[PIXEL_CNTL] ~ AOOOH
; FRGD_MIX provides color source and mix type
Drawing Operation:
|                               | 31                     | ffi    | 0                                        |
| ----------------------------- | ---------------------- | ------ | ---------------------------------------- |
| ES:[ALT _ CURXY] ~            | x_1_......L-_-,-y_1 _  |        | .....  set starting coordinate           |
|                               | 1-1_  _                |        | 1  ;                                     |
| ES:[MAJ_AXIS_PCNT] ~ MAX -1   |                        |        | ; length in pixels of the major axis -1  |
|                               | 31                     | 15     | o I   ;                                  |
| ES:[ALT_STEP] ~12*(MIN-MAX)1  |                        | 2*MIN  | diagonal and axial step constants        |
If the X drawing direction is positive then
| ES:[ERR_T ERM] ~ 2 * MI N - |     | MAX  | ; error term  |
| --------------------------- | --- | ---- | ------------- |
else if the X drawing direction is negative
| ES[ERR_T ERM] ~ 2 * MIN - |     | MAX - | 1  ; error term  |
| ------------------------- | --- | ----- | ---------------- |
ES:[CMD] ~ 00100000DDD10001b  ; Draw line command (bits 15-13, 11), draw (as opposed to
; just move current position)(bit 4), bit 0 is always 1
ENHANCED MODE PROGRAMMING  16-9

86CM65 Dual Display Accelerator
S3 Inoorporated
16.4.3.2 Textured Line
The line draw command can be used to draw a one pixel wide textured line from screen coordinates
x1,y1 to x2,y2. The texture is created by (1) setting bits 7-6 of the Pixel Control register (BEE8H, Index
AH) to A080H to specify the CPU as the source of the mask bit selecting the mix register, (2) specifying
a background and foreground color, (3) setting bit 8 of the Command register (9AE8H) to 1 (wait for
CPU data) and (4) setting bit 1 of the Command register to 1 (multi-pixel). When the pattern bit sent by
the CPU is a 1, the Foreground Mix register specifies the color source and mix. When the bit is a 0, the
Background Mix register specifies the color source and mix. This example uses the mix NEW for the
foreground mix, XOR for the background mix, foreground color index 2 and background color index
4. The 32-bit line texture/pattern (PATTERN) is 00110000111100110011000011110011b. This requires
that bits 10-9 of the Command register be setto 10b to specify a 32-bit bus.
Setup:
The XOR mix corresponds to a setting of 0101b in bits 3-0 of the Background Mix (B6E8H) register
(BKGD_MIX). See the Solid Line example for an explanation of other parameters and registers used in
this example.
31 15 0
ES:[ALT_MIX) $= LI _0_0_27_H_IL--0_0_05_H--I1 ; FRGD_COLOR is color source and NEW is mix,
; BKGD_COLOR is color source and XOR is mix
ES:[FRGD_COLOR) $= 00000002H ; color index
ES:[BKGD_COLOR) $= 00000004H ; color index
ES:[PIXEL_CNTL) $= A080H ; mask data selecting mix register is provided by the CPU
Drawing Operation:
31 15 0
ES:[ALT _ CURXY) $= LI __x_ 1 _-l.-----'y'-1_-l1 ; set starting coordinates
ES:[MAJ.-A)(IS,,:PCNT $= MAX -1 ; length in pixels of the major axis -1
31 15 o I ;
diagonal and axial step constants
If the X drawing direction is positive then
ES:[ERR_T ERM) $= 2 * MIN - MAX ; error term
else if the X drawing direction is negative
ES[ERR_T ERM) $= 2 * MIN - MAX - 1 ; error term
ES:[CMD) $= 00100101DDD10011b ; Draw line (bits 15-13, 11), 32-bit bus (bits 10-9), wait for data
; from the CPU (bit 8), draw (bit 4), mUlti-pixel (bit 1)
COUNT (of PATTERN dwords) = (MAX + 31)/32 (See Note)
PIX_TRANS $= 00110000111100110011000011110011b ; Output PATTERN to Pixel Data Transfer
; registers COUNT times
Note
The COUNT of the number of writes required by the CPU is a function of the number of bits to be
transferred and the width of the transfer (8, 16 or 32 bits as specified by bits 10-9 of the Drawing
Command register (9AE8H». The number of bits transferred per line must be an even multiple of the
transfer width. If this is not the case, the last write per line must be padded with one or more dummy
16-10 ENHANCED MODE PROGRAMMING

86CM65 Dual Display Accelerator
83 Inoorpor. ..d
bits to meet this requirement. For example, if the transfer width is 8 bits and nine bits are to be
transferred for the line, two bytes must be written per line, with the upper 7 bits of the second byte
padded. In general, the number of padding bits per line will vary from Oto (n-1), where n is the transfer
width in bits.
With a transfer width of 8 bits, the number of byte writes required per line can be determined from
the formula n = (MAX+7)/8, with n being truncated to an integer if the result contains a fraction.
Thus a MAX = 11 transfer requires (11+7)/8 = 2 1/4 = 2 bytes. The formulas for all transfer widths are
given below.
8-bit transfers: COUNT = (MAX+7)/8 bytes
16-bit transfers: COUNT = (MAX+15)/16 words
32-bit transfers: COUNT = (MAX+31)/32 dwords
ENHANCED MODE PROGRAMMING 16-11

86CM65 Dual Display Accelerator
83 Incorporated
16.4.3.3 Rectangle Fill Solid
This command draws a solid rectangle with its top left corner at x1,y1, height = HEIGHT and width =
WIDTH. The Pixel Control register (BEE8H, Index AH) must be set to AOOOH to select the Foreground
Mix register to specify the color source and mix type. This example uses the mix NEW and color index
2. The drawing direction (bits 7-5 in the write to the CMD register below) is set to X positive, X major
and Y positive (101b).
Setup:
| ES:[FRGD_MIX] ~ 0027H        |     | ; color source is FRGD_COLOR, NEW mix type  |     |
| ---------------------------- | --- | ------------------------------------------- | --- |
| ES:[FRGD_COLOR] ~ 00000002H  |     | ; color index                               |     |
ES:[PIXEL_CNTL] ~ AOOOH  ; FRGD_MIX specifies the color source and mix type
Drawing Operation:
|     | 31  15  | 0   |     |
| --- | ------- | --- | --- |
ES:[ALT _ CURXY] ~ 1'---_X_1_-'-_...:.y_'_-'1
; set starting coordinates
| 31                            | 15        | 0                                               |     |
| ----------------------------- | --------- | ----------------------------------------------- | --- |
|                               | I         | I                                               |     |
| ES:[ALT_PCNT] ~I WlDTH-1      | HEIGHT-1  | ; rectangle width                               |     |
| ES:[CMD] ~ 0100000010110001b  |           | ; Draw rectangle (bits 15-13, "), draw (bit 4)  |     |
Note
The rectangle can be defined by specifying anyone of the four corners and setting bits 7-5 accordingly.
Always select X as the major axis (bit 6 =0). No matter how the rectangle is defined, it always fills from
left to right and top to bottom.
|     | Comer         | X direction (bit 5)  | Y direction (bit 7)  |
| --- | ------------- | -------------------- | -------------------- |
|     | top left      | positive (1)         | positive (1)         |
|     | top right     | negative (0)         | positive (1)         |
|     | bottom left   | positive (1 )        | negative (0)         |
|     | bottom right  | negative (0)         | negative (0)         |
16-12 ENHANCED MODE PROGRAMMING

. .
86CM65 Dual Display Accelerator
S3 InCDrpD.atad
16.4.3.4 Image Transfer-Through the Plane
This command transfers a rectangular image from the CPU to the display memory through the plane.
"through the plane" means the complete color index is transferred for each pixel, e.g., in B bits/pixel
mode, one byte is required to transfer one pixel to memory. The image is stored as an array of pixels
arranged in row majorfashion (consecutively increasing memory addresses). The Pixel Control register
must be set to AOOOH to select the Foreground Mix register to specify the color source and mix type.
The color source must be specified as the CPU. Bit 12 ofthe Command register must be setto 1 (swap
ON) for Intel-type architectures. Bit B of the Command register must be set to 1 (wait for CPU data) and
bits 6 and 5 must also be set to 1 to specify X as the major axis and a left-to-right drawing direction.
This example uses a mix type of NEW and x1,y1 is the top left corner of the rectangle on the screen.
The height and width of the rectangle (in pixels) are HEIGHT and WIDTH. Doublword CPU writes are
supported by setting bits 10-9 of the Command register to 10b.
Setup:
ES:[FRGD_MIX] ¢= 0047H ; color source is the CPU, mix type is NEW
ES:[PIXEL_CNTL] ¢= AOOOH ; FRGD_MIX is the source for color source and mix type
Drawing Operation:
ES:[ALT _ CURXY] ¢= 1'-__X _1_---'-_---..:...y_1_-" ; set destination starting coordinates
31 15 0
ES:[ALT_PCNTI ¢=, WIDTH-1 'HEIGHT-1 , ; rectangle width
Wait for Graphics Engine not busy ; loop till bit 9 of 9AEBH register is 0
ES:[CMD] ¢= 01010101D0110001b ; Draw rectangle (bits 15-13, 11), swap ON (bit 12),
; 32-bit transfers (bits 10-9), wait for CPU data (bit B),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4)
COUNT (of image pixel data to transfer) = (See Note)
PIX_TRANS ¢= IMAGEDATA; Output image data to the Pixel Data Transfer registers for COUNT dwords.
Note
The COUNT of the number of writes required by the CPU is a fimction of the number of pixels to be
transferred, the width of the transfer (B, 16 or 32 bits as specified by bits 10-9 ofthe Drawing Command
register (9AE8H» and the color depth (bits/pixel). The number of pixels transferred per line must be an
even multiple of the transfer width. If this is not the case, the last write per line must be padded with
one or more dummy pixels to meet this requirement. For example, at 4 bits/pixel, each byte holds two
pixels. If the transfer width is one byte and three pixels are to be transferred per line, two bytes must
be written per line, with the upper nibble of the second byte a dummy pixel. If the transfer width is 16
bits, from one to three dummy pixels may be required to make the number of pixels per line an even
multiple of 16. The number of word writes required per line can be determined from the formula n =
(W+3)/4, with n being truncated to an integer if the result contains a fraction. Thus a six pixel transfer
requires (6+3)/4 = 2.25 = 2 words. This is then multiplied by the height of the image (in pixels) to
determine the COUNT of words to be transferred. Similar procedures apply to every other combination
ofthe variables affecting the COUNT. The formulas for all cases are given below, where W is the width
of the image and H is the height of the image, both in pixels.
ENHANCED MODE PROGRAMMING 16-13

86CM65 Dual Display Accelerator
sa Inoorpol'llted
COUNT for 4 bits/pixel modes
8-bit transfers: COUNT = {W+1)/2 * H bytes
16-bit transfers: COUNT = {W+3)/4 * H words
32-bit transfers: COUNT = {W+ 7)/8 * H dwords
COUNT for 8 bits/pixel modes
8-bit transfers: COUNT =W * H bytes
16-bit transfers: COUNT = {W+ 1) /2 * H words
32-bit transfers: COUNT = {W+3)/4 * H dwords
COUNT for 16 bits/pixel modes
8-bit transfers: Do not use this combination
16-bit transfers: COUNT = W * H words
32-bit transfers: COUNT = {W+ 1) /2 * H dwords
COUNT for 32 bits/pixel modes
8-bit transfers: COUNT = Do not use this combination
16-bit transfers: COUNT = 2W * H words
32-bit transfers: COUNT = W * H dwords
Note that in 32 bits/pixel modes, the upper byte is a dummy byte providing padding for a 24-bit
pixel.
16-14 ENHANCED MODE PROGRAMMING

86CM65 Dual Display Accelerator
S3 Incorporatad
16.4.3.5 Image Transfer-Across the Plane
The image transfer command can also be used to transfer a rectangular image from the CPU to the
display memory across the plane. "across the plane" means that each bit sent by the CPU is stored in
display memory as a single pixel. These pixels are arranged in row major fashion (consecutively
increasing memory addresses). An "across the plane" transfer is created by (1) setting bits 7-6 of the
Pixel Control register (BEE8H, Index AH) to A080H to specify the CPU as the source of the mask bit
selecting the mix register, (2) specifying a background and foreground color, (3) setting bit 8 of the
Command register (9AE8H) to 1 (wait for CPU data) and (4) setting bit 1 of the Command register to 1
(multi-pixel). When the pattern bit sent by the CPU is a 1, the Foreground Mix register specifies the
color source and mix. When the bit is a 0, the Background Mix register specifies the color source and
mix. This example uses a mix type of NEW, and x1.y1 is the top left corner of the rectangle on the
screen. The height and width of the rectangle (in pixels) are HEIGHT and WIDTH. The monochrome
image is translated so that pixels corresponding to a 1 in the bit image are given color index 4 and
pixels corresponding to a 0 in the bit image are given color index O. This example uses word transfers
from the CPU as specified by setting bits 10-9 of the Command register to 01 b for a 16-bit bus width.
Setup:
| 31  | 15  0  |     |
| --- | ------ | --- |
ES:[ALT _ MIX] ~I   ._ 0_0_27_H_,--0_0_05_H--,1  ; FRGD_COLOR color source and mix is NEW
L
; BKGD_COLOR is color source and mix is XOR
| ES:[FRGD_COLOR] ~ 00000004H  | ; foreground color index 4  |     |
| ---------------------------- | --------------------------- | --- |
| ES:[BKGD_COLORI ~ OOOOOOOOH  | ; background color index 0  |     |
ES:[PIXEL_CNTL] ~ A080H  ; selection of mix register is based on data from the CPU
Drawing Operation:
| 31  | 15  | 0   |
| --- | --- | --- |
__
| ES:[ALT_CURXY] ~LI                 | X_1_-,-_..:..y_1_...J1                                | ; set destination starting coordinates  |
| ---------------------------------- | ----------------------------------------------------- | --------------------------------------- |
| 31                                 | 15  0                                                 |                                         |
| I                                  | I                                                     | I                                       |
| ES:[ALT_PCNTI ~ WIDTH-1            | HEIGHT-1                                              | ; rectangle width                       |
| Wait for Graphics Engine not busy  | ; loop till bit 9 of 9AE8H register is 0              |                                         |
| CMD ~ 0101001100110011 b           | ; Draw rectangle (bits 15-13, 11), swap ON (bit 12),  |                                         |
; 16-bit transfers (bits 10-9), wait for CPU data (bit 8),
; always X Major (bit 6) & X Positive (bit 5), draw (bit 4),
; multi-pixel (bit 1)
COUNT (of image pixel data to transfer) = «WIDTH +15)/16)*HEIGHTwords
PIX_TRANS ~ IMAGEDATA; Output image data to Pixel Transfer register for COUNT words
Notes
The COUNT of the number of writes required by the CPU is a function of the number of pixels to be
transferred and the width ofthe transfer (8, 16 or 32 bits as specified by bits 10-9 of 9AE8H). Exceptfor
the case where bits 10-9 of 9AE8H are 11b, the number of pixels transferred per line must be an even
multiple of the transfer width. If this is not the case, the last write per line must be padded with one or
more dummy pixels to meet this requirement. For example, if the transfer width is 8 bits and nine
pixels are to be transferred per line, two bytes must be written per line, with the upper 7 bits of the
second byte padded. In general, the number of padding bits per line will vary from 0 to (n-1), where n
is the transfer width in bits.
ENHANCED MODE PROGRAMMING  16-15

86CM65 Dual Display Accelerator
S3 Inoorpor.t.d
With a transfer width of S bits, the number of byte writes required per line can be determined from the
formula n = (W+7)/S, with n being truncated to an integer ifthe result contains a fraction. Thus a 13-bit
pixel transfer requires (13+7)/8 = 2.5 = 2 bytes. This is then multiplied by the height of the image (in
pixels) to determine the COUNT of bytes to be transferred. Similar procedures apply to every other
combination of the variables affecting the COUNT. The formulas for all cases are given below, where
W is the width of the image and H is the height of the image, both in pixels.
S-bit transfers: COUNT = (W+7)/8 * H bytes (9AESH_10-9 =O Ob)
16-bittransfers: COUNT = (W+15)/16 * H words (9AESH_10-9 = 01b)
32-bittransfers: COUNT = (W+31)/32 * H dwords (9AESH_10-9 = 10b)
New 32-bit transfers: COUNT = (((W+7)/8*H)+3)/4 dwords (9AESH_10-9 = 11b) (Tri032 only)
The differences between the two 32-bit transfer options are:
1. For 9AESH_10-9 set to 10b, every line ofthe transfer must start with a fresh doubleword. In other
words, all unneeded bits in a doubleword transfer for a given line are discarded. After a rectan
gular image is transferred, the current drawing position is a the bottom left, meaning the next
rectangle, if drawn, will be below the previous rectangle.
2. For 9AESH_10-9 set to 11 b, only bits from the end of the line width to the next byte boundary are
discarded. Data for the next line begins with the next byte. After a rectangular image is trans
ferred, the current drawing position is a the top right, meaning the next rectangle, if drawn,
will be to the right of the previous rectangle.
To write to a single plane, setthe foreground mix to 'logical one' (0002H), the background mix to 'logical
zero' (0001 H), and the Write Mask register (AAESH) to select the desired (single) plane for updates.
16-16 ENHANCED MODE PROGRAMMING

86CM65 Dual Display Accelerator
S3 Incorporated
16.4.3.6 BitBLT - Through the Plane
This command copies a source rectangular area in display memory to another location in display
memory. The Pixel Control register must be set to AOOOH to select the Foreground Mix register to
specify the color source and mix type. The color source must be specified as the bitmap (display
memory). Bit 6 of the Command register must be set to 1 to specify X as the major axis.  For this
example, assume x1,y1 is the top left corner of the source rectangle in display memory and x2,y2 is
the top left corner ofthe destination rectangle. The rectangles can be overlapping or disjoint. The height
and width (in pixels) of the rectangle being copied are HEIGHT and WIDTH.
Setup:
First. the values of the Srcx, Srcy, Destx and Desty must be determined.
Case 1: Source and destination rectangles do not overlap
For X Positive, Y Positive: Srcx = x1, Srcy =y 1, Destx = x2, Desty = y2
Case 2: Source and destination rectangles overlap
Ifx1 >x2
then if X Positive, Srcx = x1, Destx = x2
else
| Srcx = x1 + WIDTH -1, Destx = x2 + WIDTH -1  |     | ; X Negative  |
| -------------------------------------------- | --- | ------------- |
Ify1 >y2
then if Y Positive, Srcy = y1, Desty = y2
else
| Srcy = y1 + HEIGHT -1, Desty = y2 + HEIGHT-1  |     | ; Y Negative  |
| --------------------------------------------- | --- | ------------- |
ES:[PIXEL_CNTL) <= AOOOH  ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX) <= 0067H  ; color source is display memory and mix type is NEW
Draw Operation:
|                      | 31  15      | 0                         |
| -------------------- | ----------- | ------------------------- |
|                      | I           | I  ;                      |
| ES:[ALT _ CURXY) <=  | Srcx  Srcy  | set starting coordinates  |
|                      | ~I   ffi  0 |                           |
I   ;
| ES:[ALT _ STEP) <=  | Destx  Desty       | set destination coordinates   |
| ------------------- | ------------------ | ----------------------------- |
|                     | 31  I  15  I  0    | I                             |
| ES:(ALT_PCNT) <=    | WIDTH-1  HEIGHT-1  | ; rectangle width and height  |
ES:[CMD) <= 11000000DOD10001b
; BitBLT (bits 15-13, 11), always X Major (bit 6), draw (bit 4)
ENHANCED MODE PROGRAMMING  16-17

86CM65 Dual Display Accelerator
53 Incorporated
16.4.3.7 BitBLT-Across the Plane
This uses the same command as a BitBLT through the plane. However, instead of copying complete
pixels (with color affected only by the mix), this 'across the plane" transfer uses only the bits in the
color planes specified by setting the Read Mask register (AEE8H), e.g., bit 3 of every pixel, to determine
the destination rectangle. With more than one plane enabled for read, if all the bits in the planes enabled
for read are '1's then a '1' is read. If a bit in anyone of the planes enabled for read is a '0', then '0' is
read. An "across the plane" transfer is created by (1) setting bits 7-6 ofthe Pixel Control register (BEE8H,
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
For X Positive, Y Positive: Srcx = x1, Srcy = y1, Destx = x2, Desty =y 2
Case 2: Source and destination rectangles overlap
Ifx1 >x2
then if X Positive, Srcx = x1, Destx = x2
else
Srcx = x1 + WIDTH -1, Destx = x2 + WIDTH-1 ;X Negative
Ify1 >y2
then if Y Positive, Srcy = y1, Desty = y2
else
Srcy = y1 + HEIGHT -1, Desty = y2 + HEIGHT -1 ;Y Negative
ES:[PIXEL_CNTL) <= AOCOH ; data from display memory selects mix register
~ W 0
ES:[ALT _ MIX) <= 1,--_00_0_2_H_I.-_00_0_1H_---..J1 ; result of foreground mix is always logical 1,
; result of background mix is always logical 0
ES:[RD_MASK) <= 00000001 H ; read from plane 0
ES:[WRT_MASK) <= 00000004H ; plane 2 enabled for write
16-18 ENHANCED MODE PROGRAMMING

86CM65 Dual Display Accelerator
S3 Incorporated
Draw Operation:
|     | 31  15  | 0   |
| --- | ------- | --- |
; set starting coordinates
| ES:[ALT _ CURXY) {:::  | _S_rc_x_-,--_S_rCY-,---,1  |     |
| ---------------------- | -------------------------- | --- |
,--I
|                       | 31  15  0                       |                                |
| --------------------- | ------------------------------- | ------------------------------ |
| ES:[ALT _ STEP) {:::  | _De_s_tx_,--_De_s....:.ty---ll  | ; set destination coordinates  |
L.I
|                                | 31  15  0     |                               |
| ------------------------------ | ------------- | ----------------------------- |
| ES:[ALT _ PCNn {::: 1 W1DTH-1  | 1 HEIGHT-1 1  | ; rectangle width and height  |
ES:[CMD) {::: 11000000DOD10001 b  ; BitBLT (bits 15-13, 11), always X Major (bit 6) , draw (bit 4),
; multi-pixel (bit 1)
Note
It is possible to translate a monochrome image, e.g., text fonts, stored in a single plane in display
memory into a 2-color image. This is accomplished by setting the mix registers differently and setting
the desired background and foreground colors. If the source bit is a '1', then the corresponding pixel
at the destination is colored with the foreground color index. The destination pixel is colored with the
background color index if the corresponding source bit is a '0'. The setup for this is as follows:
| ES:[WRT_ MASK) {::: FFFFFFFFH   | ; enable all planes for writing          |     |
| ------------------------------- | ---------------------------------------- | --- |
| ES:[FRGD_MIX) {::: 0027H        | ; color source foreground, mix type NEW  |     |
| ES:[BKGD_MIX) {::: 0007H        | ; color source background, mix type NEW  |     |
| ES:[FRGD_COLOR) {::: 00000004H  | ; foreground color                       |     |
| ES:[BKGD_COLOR) {::: 00000001H  | ; background color                       |     |
ENHANCED MODE PROGRAMMING 16-19

••
r
86CM65 Dual Display Accelerator
83 InCOIpornH
16.4.3.8 PatBLT-Pattern Fill Through the Plane
An 8x8 pixel pattern is initially copied into an off-screen area of display memory using an image transfer
operation or a direct write (linear addressing). This command then repeatedly tiles this source pattern
into a destination rectangle of arbitrary size. The colors of the destination pixels are affected only by
the mix selected. The destination rectangle must not overlap the source pattern. Each copy is aligned
to an 8-pixel boundary (x coordinate = 0,8, etc.), with pixels outside the destination rectangle boundary
not being drawn. The Pixel Control register must be set to AOOOH to select the Foreground Mix register
to specify the color source and mix type. The color source must be specified as the bitmap (display
memory). Bit 6 ofthe Command register must be set to 1 to specify X as the major axis. In this example,
assume x1,y1 is the top left corner of the pixel pattern and x2,y2 is the top left corner of the destination
rectangle. The height and width (in pixels) of the rectangle are HEIGHT and WIDTH.
Setup:
ES:[PIXEL_CNTL] <= AOOOH  ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX] <= 0067H
; color source is display memory, mix type is NEW
Draw Operation
|                      | 31  15               | 0                           |
| -------------------- | -------------------- | --------------------------- |
| ES:[ALT  _CURXY] <=  | _X_1_-'----'y'-1_~1  | ; set starting coordinates  |
1-1
|                   | 31  15  0                 |                                |
| ----------------- | ------------------------- | ------------------------------ |
| ES:[ALT_STEP] <=  | _x2_---...J'----'y'-2_~1  | ; set destination coordinates  |
,-I
|                    | 31  15  0     |                               |
| ------------------ | ------------- | ----------------------------- |
| ES:[ALT_PCNTI <=1  | 1H EIGHT-1 1  |                               |
|                    | WIDTH-1       | ; rectangle width and height  |
ES:[CMD] <= 11100000DOD10001b  ; PatBLT (bits 15-13,11), always X Major (bit 6) , draw (bit 4)
16-20 ENHANCED MODE PROGRAMMING

86CM65 Dual Display Accelerator
16.4.3.9 PatBLT-Pattern Fill Across the Plane
This uses the same command as a PatBLT  through the plane. However, instead of copying complete
pixels (with color affected only by the mix), this 'across the plane" transfer uses only the bits in the
color planes specified by setting the Read Mask register (AEEBH), e.g., bit 3 of every pixel, to determine
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
| ES:[PIXEL_CNTL) <= AOCOH  | ; data from display memory selects mix register  |     |
| ------------------------- | ------------------------------------------------ | --- |
| 31                        | 15  0                                            |     |
ES:[ALT _ MIX) <= 1..-1_ 0_0_02_H_,--0_0_01_H-J1  ; result of foreground mix is always logical 1,
; result of background mix is always logical 0
| ES:[RD_MASK) <= 00000001 H   | ; read from plane 0          |     |
| ---------------------------- | ---------------------------- | --- |
| ES:[WRT_ MASK) <= 00000004H  | ; plane 2 enabled for write  |     |
Draw Operation:
| ES:[ALT _ CURXY) <=  | _X_1_-,-_y.:....1_-,1  | ; set starting coordinates  |
| -------------------- | ---------------------- | --------------------------- |
LI
|                                                    | 31  15  0     |                                |
| -------------------------------------------------- | ------------- | ------------------------------ |
| ES:[ALT _ STEP) <= 1... .. _x_2 _, --_y=-2_....J1  |               | ; set destination coordinates  |
|                                                    | 31  15  0     |                                |
| ES:[ALT_PCNT) <= 1 WIDTH-1                         | 1 HEIGHT-1 I  | ; rectangle width and height   |
ES:[CMD) <= 11100000DOD10011b  ; PatBLT (bits 15-13, 11), always X Major (bit 6) ,draw (bit 4),
; multi-pixel (bit 1)
Note
To expand the source mono pattern into a 2-color pattern, set the foreground mix to 27H, the
background mix to 7H and the foreground and background colors as desired. Also set the write mask
(AAEBH) to FFFFFFFFH. This needs to be set only once. It is altered only by another write.
ENHANCED MODE PROGRAMMING  16-21

••
r
86CM65 Dual Display Accelerator
53 Incorporated
16.4.3.10 Short Stroke Vectors
This command rapidly draws short lines (up to 15 pixels in length). Such lines are constrained to one
of the 8 directions at 45 degree increments starting at 0 degrees. The current point x1,y1 is set and a
NOP command is issued to set all the desired drawing parameters without actually writing a pixel. For
example, bit 2 (Last Pixel Off) would be set to 1 (OFF) for drawing connected lines until the last line is
drawn. The short stroke vector parameters are then loaded in the Short Stroke Vector Transfer (9EE8H)
register (SHORT_STROKE). Two vectors can be defined at a time, one in the low byte and one in the
high byte. For the low byte, bits [7:5) define the direction, with bit 4 set to T for a draw operation or
to '0' for a move current position operation. Bits 3-0 define the length of the short line. Let SSVDO,
SSVD1, .•• SSVDN-1 bytes be the short stroke vector data for N lines.
Setup:
ES:[PIXEL_CNTL) <= AOOOH ; FRGD_MIX is the source of color source and mix type
ES:[FRGD_MIX) <= 0027H ; use the foreground color, mix type NEW
ES:[FRGD_COLOR)<= 00000004H ; foreground color index 4
Draw Operation:
31 15 0
ES:[ALT _CURXY) <= 1...1 __x _1_-l.._-,y_1_-,1 ; set starting coordinates
ES:[CMD) <= 00010010XXX11111b ; NOP (bits 15-13, 11), byte swap (bit 12), 16-bit transfers
; (bits 10-9) , draw (bit 4), radial drawing direction (bit 3),
; last pixel off (bit 2), multi-pixel (bit 1)
While space available in the FIFO
ES:[SHORT_ STROKE) <= SSVD1 SHL 8 + SSVDO; SSVD1 shifted to high byte, SSVDO in low byte
ES:[SHORT_ STROKE) <= SSVD3 SHL 8 + SSVD2 ; byte swap turned on to read vectors out in
; correct order
ES:[SHORT_STROKE) <= SSVDN-1 SHL 8 + SSVDN-2
16-22 ENHANCED MODE PROGRAMMING

..
86CM65 Dual Display Accelerator
S3 Inoorporated
16.4.3.11  Programmable Hardware Cursor
A programmable cursor is supported which is compatible with the Microsoft Windows (bit 4 of CR55
= 0) and X11 (bit 4 of CR55 = 1) cursor definitions. The cursor size is 64 pixels wide by 64 pixels high,
with the cursor pattern stored in an off-screen area of display memory. Two monochrome images 64
bits wide by 64 bits high (512 bytes per image) define the cursor shape. The first bit image is an AND
mask and the second bit image is an XOR mask. The following is the truth table for the cursor display
logic.
| AND Bit  XORBit  | Displayed (Microsoft Windows)  | Di~layed (X11)           |
| ---------------- | ------------------------------ | ------------------------ |
| 0  0             | Cursor Backoround Color        | Current Screen Pixel     |
| 0  1             | Cursor Foreoround Color        | Current Screen Pixel     |
| 1  0             |                                |                          |
|                  | Current Screen Pixel           | Cursor Backoround Color  |
| 1  1             | NOT Current Screen Pixel       | Cursor Foreground Color  |
The hardware cursor color is taken from the Hardware Graphics Cursor Foreground Stack (CR4A) and
the Hardware Graphics Cursor Background Stack (CR4B) registers. Each ofthese is a stack of three 8-bit
registers. The stack pointers are reset to 0 by reading the Hardware Graphics Cursor Mode register
(CR45). The color value is then programmed by consecutive writes (low byte, second byte, third byte)
to the appropriate (foreground or background) register.
Enabling/Disabling the Cursor
The hardware cursor is disabled when a VGA-compatible mode is in use. It can be enabled or disabled
when in Enhanced mode (bit 0 of 4AE8H = 1), as follows.
| CR39~AOH    | ; Unlock System Control registers  |     |
| ----------- | ---------------------------------- | --- |
| CR45_0 ~ 1  | ; Enable hardware cursor           |     |
| CR45_0~0    | ; Disable hardware cursor          |     |
| CR39~00H    | ; Lock System Control registers    |     |
Positioning the Cursor
The cursor can be positioned at any point on the display, with the X,V coordinates ranging from 0 to
2047. This enables the full cursor images to be displayed on the screen and partial cursor images to
be displayed at the right edge and the bottom edge of the screen. The cursor offset OX,OV has to be
set to 0,0 for a 1024x768 resolution. If X is > (1024 - 64) or V is > (768 - 64), then a partial cursor is
visible at the right edge or top edge of the screen respectively. Note that if V ~ 768 then the cursor is
not visible; it is residing in the off-screen area.
A partial cursor image can be displayed atthe left edge orthe top edge of the screen. To enable partial
cursor display at the top edge of the screen, V is set to 0 and the V offset register is set to OV (range
from 0 to 63). This displays the bottom 64-0V rows of the cursor image at the currently set X position
and the top edge of the screen. Similarly, a partial cursor can be displayed at the left edge of the screen
by setting X to 0 and the X offset register to OX (range from 0 to 63). This displays the right 64-0X
columns of the cursor image at the currently set X and the left edge of the screen. The following
pseudocode illustrates cursor positioning.
; Unlock System Control registers
CR39~AOH
CR46_10-8 ~ MS 3 bits of X cursor position
CR473- 0 ~ LS 8 bits of X cursor position
ENHANCED MODE PROGRAMMING  16-23

86CM65 Dual Display Accelerator
S3 Incorporat.d
CR49_7-0 <= LS 8 bits ofY cursor position
CR4E_5-0 <= Cursor Offset X position
CR4F _5-0 <= Cursor Offset Y position
CR48_10-8 <= MS 3 bits ofY cursor position
CR39 <=OOH ; Lock System Control registers
The cursor position is updated by the hardware once each frame. Therefore, the programmer should
ensure that the position is re-programmed no more than once for each vertical sync period.
Programming the Cursor Shape
The AND and the XOR cursor image bitmaps are 512 bytes each. These bitmaps are word interleaved
in a contiguous area of display memory, i.e., AND word 0, XOR word 0, AND word 1, XOR word 1 •..
AND word 255, XOR word 255. The starting location must be on a 1024-byte boundary. This location
is programmed into the Hardware Graphics Cursor Start Address registers (CR4C and CR4D) as follows:
CR39 <= AOH ; Unlock System Control registers
CR4C_11-8 <= MS 4 bits ofthe cursor storage start 1024-byte segment.
CR4D <= LS 8 bits of the cursor storage start 1024-byte segment
CR39 <= 0 ; Lock System Control registers
The value programmed is the 1024-byte segment of display memory at which the beginning of the
hardware cursor bit pattern is located. For example, for an 800x600x8 mode on a 1 MBYte system,
there are 10241 K segments. Programming CR4C_11-8 with 3H and CR4D with FEH specifies the starting
location as the 1022nd (O-based) 1K segment. The cursor pattern is programmed (using linear
addressing) at FF800H offset from the base address of the frame buffer.
Cursor Destination
If in dual image mode, select the cursor controller source. SR313 = 0 selects controller 1; SR313 = 1
selects controller 2. This determines on which screen the cursor will appear.
Note
If the cursor is not 64 bits by 64 bits, the given images should be padded to make the cursor image 64
bits by 64 bits. The padded area should be made transparent by padding the extra AND mask bits with
'1's and the extra XOR bits by'O's.
16-24 ENHANCED MODE PROGRAMMING

86CM65 Dual Display Accelerator
16.4.3.12 Programmable Hardware Icon
86CM65 provides a programmable hardware icon that is displayable in all modes, including VGA text
and graphics modes. Only the hardware cursor (available only in Enhanced modes) has precedence
over the hardware icon for overlaying on the text/graphics/video.
The setup for using a hardware icon involves two steps.
1. Up to 8 icons are defined in contiguous memory at a frame buffer base address location defined
by SR4E. Each icon is defined in memory as 64 consecutive lines of pixels with 64 pixels per
line and 2 bits/pixel, thus requiring 1 KByte of memory per icon. The two bits per pixel are
stored in memory in the same manner as the AND and XOR masks for the hardware cursor.
That is, one word of bit 1 is stored, then one word of bit 2, a second word of bit 1, a second
word of bit 2, etc. Corresponding bit 1's and bit 2's are used to select the icon pixel colors.
2. Four icon colors are programmed in SR49. This address contains a stack of of twelve 8-bit
registers that can be written sequentially with automatic address indexing. This allows rapid
specification of four 24-bit colors (ColorO to Color3). For color depths less than 24 bits, the ap
propriate number of bits are taken from the Isb's of the registers, e.g., the low order 8 bits are
used for 8 bits/pixel modes.
To use an icon, do the following:
1. Enable the hardware icon by setting SR48_0 to 1.
2. Select one of eight icon maps via SR48_6-4.
3. Specify the color of each pixel. The programmer first selects a color mode via SR48_1 as follows:
o = 4 opaque colors
1 = 3 opaque colors and 1 transparent color
When this bit is cleared to 0, the two bits programmed for each pixel in the icon memory are
interpreted as follows:
00 = ColorO
01 = Color1
10 = Color2
11 = Color3
When this bit is set to 1, the two bits programmed for each pixel in the icon memory are inter
preted as follows:
00 = ColorO
01 = Color1
10 = Color2
11 = Transparent (the current frame buffer pixel is not overwritten)
4. Specify the final size of the icon. If SR48_2 = 0, the horizontal size is 64 pixels. If SR48_2 = 1, the
horizontal size is 128 pixels. If SR48_3 = 0, the vertical size is 64 pixels. If SR48_3 = 1, the verti
cal size is 128 pixels. In both case, the expansion is done by pixel doubling.
5. If in dual image mode, select the icon controller source. SR31_6 = 0 selects controller 1; SR31_6 =
1 selects controller 2. This determines on which screen the image will appear.
6. Program the icon location on the screen. The horizontal coordinate of the upper left hand edge
of the icon is programmed in SR4A and SR4B. the vertical coordinate of the upper left hand
edge of the icon is specified in SR4C and SR4D.
ENHANCED MODE PROGRAMMING 16-25

86CM65 Dual Display Accelerator
83. Incorporated
16.5 RECOMMENDED READING
Graphics Programming for the 8514/A by Jake Richter and Bud Smith (M&T Publishing, Inc) provides
extensive explanations and examples for programming most ofthe bits in the S3 Enhanced Registers.
This book may be out of print.
Programmer's Guide to the EGA, VGA and Super VGA Cards, 3rd Edition by Richard F. Ferraro
(Addison-Wesley Publishing Company, Inc) includes a section on programming for S3 accelerator
chips.
16-26 ENHANCED MODE PROGRAMMING

86CM65 Dual Display Accelerator
Section 17: Standard VGA Register Descriptions
In the following register descriptions, 'U' stands for undefined or unused and 'R' stands for reserved
(write = 0, read = U). A question mark in an address stands for a hexadecimal value of either 'B' or 'D'.
If bit 0 of the Miscellaneous Output Register (3C2H, Write) is set to 1, the address is based at 3DxH for
color emulation. If this bit is reset to 0, the address is based at 3BxH for monochrome emulation. If a
register or bit is noted as paired, there are two identical registers or bit at that address, with access
controlled via SR26. One register or bit is used by controller 1 and the other for controller 2. If a register
or bit is noted as shared, there is a single register or bit shared by controller 1 or controller 2.
See Appendix A for a table listing each register in this section and its page number.
17.1  GENERAL REGISTERS
This section describes general input status and output control registers.
Miscellaneous Output Register (MiSe)
| Write Only  |     | Address: 3C2H  |     |
| ----------- | --- | -------------- | --- |
| Read Only   |     | Address: 3CCH  |     |
Power-On Default: OOH
This register controls miscellaneous output signals. A hardware reset sets all bits to zero.
| 7  I  6  | 5  4  | I  2  | 1  0  |
| -------- | ----- | ----- | ----- |
3
| SYNPOLJ    |                              | elK  SEl  | ENB  lOA  |
| ---------- | ---------------------------- | --------- | --------- |
| VERT SIZE  | PGSl  =0                     | 1  0      | RAM  SEL  |
| Bit 0      | lOA SEl -I/O Address Select  |           |           |
o
= Monochrome emulation. Address based at 3Bx
1 = Color emulation. Address based at 30x
| Bit 1  | ENB RAM -Enable CPU Display Memory Access  |     |     |
| ------ | ------------------------------------------ | --- | --- |
o = Disable access ofthe display memory from the CPU
1 = Enable access of the display memory from the CPU
STANDARD VGA REGISTER DESCRIPTIONS  17-1

••
r
86CM65 Dual Display Accelerator
S3 Inoorporated
Bits 3-2  Clock Select -Select the Video Clock Frequency
00 = Selects the DCLK PLL parameters in SR22 and SR23. The default
generates a 25.175 MHz DCLK for 640 horizontal pixels
01 = Selects the DCLK PLL parameters in SR24 and SR25. The default
generates a 28.322 MHz DCLK for 720 horizontal pixels
10 = Reserved
11 = Selects the DCLK PLL parameters in SR12 and SR13. This setting is used for all
Enhanced modes.
The selected DCLK PLL parameter values are loaded into the PLL when bit 1 of
| SR15_' is set to 1 or when SR15_5 is programmed to 1 and then  |     |     | o.  |
| -------------------------------------------------------------- | --- | --- | --- |
Bit 4  Reserved = 0
Bit 5  PGSL -Select High 64K Page
o
= Select the low 64K page of memory
1 = Select the high 64K page of memory
Bits 7-6  SYNCPOLNERT SIZE -Sync PolarityNertical Size
| Bit7  Bit 6  | VSYNC Polarity  | HSYNC Polarity  | Vertical Size (lines)  |
| ------------ | --------------- | --------------- | ---------------------- |
| 0  0         | +               | +               | Reserved               |
| 0  1         | +               | -               | 200 (double scanned)   |
-
| 1  0  |     | +   | 350  |
| ----- | --- | --- | ---- |
|       | -   | -   |      |
| 1  1  |     |     | 480  |
+ = positive sync pulse
-= negative sync pulse
Vertical Size = vertical resolution of the graphics source
This vertical size is used when CR70_1 is set to 1 to enable graphics mode vertical ex
pansion. During simultaneous display, SR32_2-1 control the polarity of the the
VSYNC and HSYNC signals.
17-2 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Inoorpor.t.d
Feature Control Register (FCR_WT, FCR_AD)
| Write Only  |     | Address: 31AH  |     |
| ----------- | --- | -------------- | --- |
| Read Only   |     | Address: 3CAH  |     |
Power-On Default: OOH
1  °
=0  =0
Reserved =0
Bits 2-0
| Bit 3  | VSSL -Vertical Sync Type Select  |     |     |
| ------ | -------------------------------- | --- | --- |
o = Enable normal vertical sync output to the monitor
1 = The 'vertical sync' output is the logical OR of 'vertical sync' and 'vertical active
display enable' (an internal signal)
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
°
| Input Status  | Register (STATUS_O)  |                |     |
| ------------- | -------------------- | -------------- | --- |
| Read Only     |                      | Address: 3C2H  |     |
Power-On Default: Undefined
This register indicates the status of the VGA adapter.
| 7  6       | 5  4      | 3  2    | 1  °    |
| ---------- | --------- | ------- | ------- |
| CRT        | MON       |         |         |
| INTPE  =0  | =0  SENS  | =0  =0  | =0  =0  |
Reserved =0
Bits 3-D
| Bit 4  | MON SENS -Monitor Sense Status  |     |     |
| ------ | ------------------------------- | --- | --- |
0= The internal SENSE signal is a logical 0
1 = The internal SENSE signal is a logical 1
| Bits 6-6  | Reserved = 0                     |     |     |
| --------- | -------------------------------- | --- | --- |
| Bits 7    | CRT INTPE -CRT Interrupt Status  |     |     |
0= Vertical retrace interrupt cleared
1 = Vertical retrace interrupt pending
See Section 13.5 for an explanation of interrupt generation.
STANDARD VGA REGISTER DESCRIPTIONS  17-3

86CM65 Dual Display Accelerator
53 Inoorpo. ...d
Input Status 1 Register (STATUS_1)
Read Only Address: 37AH
Power-On Default: Undefined
This register indicates video sync timing and video wraparound.
5 4
TST-VDT
1 0
Bit 0 °DT M -Display Mode Inactive
= The display is in the display mode.
1 = The display is not in the display mode. Either the horizontal or vertical retrace
period is active
°
Bit 1 Reserved =
Bit 2 Reserved = 1
Bit 3 VSY -Vertical Sync Active
o
= Display is in the display mode
1 = Display is in the vertical retrace mode
Bits 5-4 TST-VDT -Video Signal Test
Video Data Feedback 1,0. These bits are feedback video signals to do read back tests.
These bits are selectively connected to two of the eight color outputs of the attribute
controller. Bits 5 and 4 of the color plane enable register (AR12) control the multi
plexer for this video output observation.
°
Bits 7~ Reserved =
Video Subsystem Enable Register
Write Only Address: 3C3H
Power-On Default: OOH
1
I : I : I : I : I : I : I
R
Bit 0 CHIP ENB -Chip Enable
o
= 86CM65 disabied
1 =8 6CM65 enabled
Bits 7-1 Reserved
17-4 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
sa IncDrpDrated
17.2 SEQUENCER REGISTERS
The sequencer registers are located at two-byte address spaces. These registers are accessed by first
writing the data to the index register ofthe sequencer at I/O address 3C4H and then writing to or reading
from the data register at 3C5H. A word write of both address and data at 3C4H can also be performed.
Sequencer Index Register (SEOXI
| Read/Write  |     | Address: 3C4H  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is loaded with a binary value that indexes the sequencer register for read/write data. This
| value is referred to as the Hlndex NumberH  |     | of the SR register in this document.  |     |
| ------------------------------------------- | --- | ------------------------------------- | --- |
o
| 7  6      | 5  4                                   | 321          |     |
| --------- | -------------------------------------- | ------------ | --- |
| R  R      | R                                      | SEQ ADDRESS  |     |
| Bits 4-0  | SEQ ADDRESS -Sequencer Register Index  |              |     |
A binary value indexing the register where data is to be accessed.
| Bits 7-5  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Sequencer Data Register (SEQ_DATAl
| Read/Write  |     | Address: 3C5H  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is the data port for the sequencer register indexed by the Sequencer Index register (3C4H).
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
1
SEQ DATA
| Bit 7-0  | SEQ DATA -Sequencer Register Data  |     |     |
| -------- | ---------------------------------- | --- | --- |
Data to the sequencer register indexed by the sequencer address index.
STANDARD VGA REGISTER DESCRIPTIONS 17-5

86CM65 Dual Display Accelerator
83 Incorponted
Reset Register (RST_SYNC) (SRO)
| Read/Write  |     | Address: 3CSH. Index OOH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| Bit 0  | ASY RST -Asynchronous Reset  |     |     |
| ------ | ---------------------------- | --- | --- |
This bit is for VGA software compatibility only. It has no function for 86CM6S.
| Bit 1  | SYN RST -Synchronous Reset  |     |     |
| ------ | --------------------------- | --- | --- |
This bit is for VGA software compatibility only. It has no function for 86CM6S.
| Bits 7-2  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Clocking Mode Register (ClK_MODE) (SR1)
| Read/Write  |     | Address: 3CSH.lndex 01H  |     |
| ----------- | --- | ------------------------ | --- |
Power-On Default: OOH
This register controls the operation mode of dot clock and character clock.
| 7  6    | 5  4                     | 3  2       | 1  0     |
| ------- | ------------------------ | ---------- | -------- |
|         | SCRN  SHF                | CCLK  SHF  |          |
| =0  =0  | OFF  4                   | 1/2  LD    | =0  SOC  |
| Bit 0   | 8DC -8 Dot Clock Select  |            |          |
o = Character clocks 9 dots wide are generated
1 = Character clocks 8 dots wide are generated
| Bit 1  | Reserved = 0                                           |     |     |
| ------ | ------------------------------------------------------ | --- | --- |
| Bit 2  | SHF lD -load Serializers Every Second Character Clock  |     |     |
o = load the video serializer every character clock
1 = Load the video serializers every other character clock
| Bit 3  | CCLK 1/2 -Internal Character Clock Divided by 2  |     |     |
| ------ | ------------------------------------------------ | --- | --- |
o  = Internal character clock unchanged
i = Halve the frequency of the character clock
This bit is used for horizontal pixel doubling.
17-6 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Inccwporated
Bit 4 SHF 4 -Load Serializers Every Fourth Character Clock
o = Load the serializers every character clock cycle
1 = Load the serializers every fourth character clock cycle
Bit 5 SCRN OFF -Screen Off
o
= Screen is turned on.
1 = Screen is turned off
This bit is effective only when CR71_1 = O.
Note: This bit is shared.
Bits 7-6 Reserved = 0
Enable Write Plane Register IEN_WT_PLI ISR21
Read/Write Address: 3C5H, Index 02H
Power-On Default: OOH
This register selects write protection or write permission for CPU write access into video memory.
3 2 1 o
EN.WT.PL.
Bits 3-0 EN.WT.PL -Enable Write to a Plane
o
= Disables writing into the corresponding plane
1 = Enables the CPU to write to the corresponding color plane
Bits 7~ . Reserved = 0
STANDARD VGA REGISTER DESCRIPTIONS 17-7

86CM65 Dual Display Accelerator
sa Inoorpontod
Character Font Select Register (CH_FONT_SL) (SR3)
ReadJWrite Address: 3C5H, Index 03H
Power-On Default: OOH Shared
3 2 1 0
SLA SLB
1 0 1 0
In text modes, bit 3 of the attribute byte normally turns the foreground intensity on or off. This bit can
be redefined to be a switch between two character sets. The switch is enabled when there is a difference
between the value of character font select A and character font select B bits. Memory Mode (SR4)
register bit 1 = 1 (extended memory) enables all bits of this function; otherwise character fonts 0 and
4 are available. 256 KBytes of video memory support 8 character sets. This register is reset to 0
asynchronously during a system reset.
Bits 4, 1-0 SLB -Select Font B
This value selects the portion of plane 2 used to generate text character fonts when
bit 3 of the attribute byte is a logical 1, according to the following table:
Bits Font Table Location Bits Font Table Location
4,1,0 4,1.0
000 First 8K of plane 2 100 Second 8K of plane 2
001 Third 8K of plane 2 101 Fourth 8K of plane 2
010 Fifth 8K of plane 2 110 Sixth 8K of plane 2
011 Seventh 8K of plane 2 111 Eighth 8K of plane 2
Bits 5, 3-2 SLA -Select Font A
This value selects the portion of plane 2 used to generate text character fonts when
bit 3 of attribute byte is a logical 0, according to the same table as the character font
select A.
Bits 7-6 Reserved =0
17-8 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
sa Incorporated
Memory Mode Control Register (MEM_MODE) (SR4)
| Read/Write  |     | Address: 3C5H, Index 04H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register controls CPU memory addressing mode.
| 7  6    | 5  4    | 3  2      | 1  0     |
| ------- | ------- | --------- | -------- |
|         |         | CHN  SEQ  | EXT      |
| =0  =0  | =0  =0  | 4M  MODE  | MEM  =0  |
Reserved = 0
Bit 0
| Bit 1  | EXT MEM -Extended Memory Access  |     |     |
| ------ | -------------------------------- | --- | --- |
0= Memory access restricted to 16/32 KBytes
1 = Allows complete memory access to 256 KBytes. Required for VGA
Note: This bit is shared.
| Bit 2  | SEQ MODE -Sequential Addressing Mode  |     |     |
| ------ | ------------------------------------- | --- | --- |
This bit affects only CPU write data accesses into video memory. Bit 3 of this register
must be 0 for this bit to be effective.
o
= Enables the odd/even addressing mode. Even addresses access planes 0 and 2.
Odd addresses access planes 1 and 3
1 = Directs the system to use a sequential addressing mode
| Bit 3  | CHN 4M -Select Chain 4 Mode  |     |     |
| ------ | ---------------------------- | --- | --- |
o  = Enables odd/even mode.
1 = Chain 4 Mode. This bit selects modulo 4 addressing for CPU access to display
memory. A logical 1 directs the two lower order bits of the CPU address used to
select the plane in video memory to be accessed as follows:
|     | A1  AO  | Plane Selected  |     |
| --- | ------- | --------------- | --- |
|     | 0  0    | 0               |     |
|     | 0  1    | 1               |     |
|     | 1  0    | 2               |     |
|     | 1  1    | 3               |     |
Note: This bit is shared.
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
STANDARD VGA REGISTER DESCRIPTIONS  17-9

86CM65 Dual Display Accelerator
S3 Incorporeted
17.3 CRT CONTROLLER REGISTERS
The CRT controller registers are located at two locations in 1/0 address space. These registers are
accessed by first writing to the index register ofthe CRT controller and then accessing the data register.
The index register is located at I/O address 314H and the CRT Controller Data register is at 315H. Which
address is used (3BX or 3DX) depends on bit 0 of the Miscellaneous Output register at 3C2H. A word
write of both address and data at 314H can also be performed.
CRT Controller Index Register (CRTC-ADR) (CRX)
Read/Write Address: 314H
Power-On Default: OOH
This register is loaded with a binary value that indexes the CRT controller register where data is to be
accessed. This value is referred to as the "Index Number" of the CR register (CR00-18). This register
is also used as an index to the S3 VGA registers, the System Control Registers and the System Extension
registers.
7 6 543 2 1 o
CRTC ADDRESS
Bits 7~ CRTC ADDRESS -CRTC Register Index
A binary value indexing the register where data is to be accessed.
CRT Controller Data Register (CRTC_DATA) (CRT)
Read/Write Address: 315H
Power-On Default: Undefined
This register is the data port for the CRT controller register indexed by the CRT Controller Address
register.
7 6 5 4 3 2 1 o
CRTCDATA
Bits 7~ CRTC DATA -CRTC Register Data
Data to the CRT controller register indexed by the CRT controller address index.
17-10 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorporated
Horizontal Total Register (H_TOTAL) (CRO)
| Read/Write                   |     | Address: 315H, Index OOH  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Paired                    |     |
This register defines the number of character clocks from HSYNC going active to the next HSYNC going
active. In other words, it is the total time required for both the displayed and non-displayed portions
of a single scan line. Bit 8 of this value is bit 0 of CR5D.
o
| 7  6  | 5  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
HORIZONTAL TOTAL
| Bits 7-0  | HORIZONTAL TOTAL.  |     |     |
| --------- | ------------------ | --- | --- |
9-bit Value = (number of character clocks in one scan line) -5. This register contains
the least significant 8 bits of this value.
Horizontal Display End Register (H_D_END) (CR1)
| Read/Write                   |     | Address: 315H, Index 01H  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Paired                    |     |
This register defines the number of character clocks for one line ofthe active display. Bit 8 of this value
is bit 1 of CR5D.
o
| 7  6  | 543  | 2   | 1   |
| ----- | ---- | --- | --- |
HORIZONTAL DISPLAY END
| Bits 7-0  | HORIZONTAL DISPLAY END  |     |     |
| --------- | ----------------------- | --- | --- |
9-bit Value = (number of character clocks of active display) -1. This register contains
the least significant 8 bits of this value.
STANDARD VGA REGISTER DESCRIPTIONS 17-11

86CM65 Dual Display Accelerator
53 Incorporated
Start Horizontal Blank Register (S_H_BLNKI (CR2I
| ReadJWrite                   |     | Address: 375H, Index 02H  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Paired                    |     |
This register specifies the value of the character clock counter at which the BLANK signal is asserted.
Bit 8 of this value is bit 2 of CR5D.
o
| 7   | 6  5  | 4  3  | 2  1  |
| --- | ----- | ----- | ----- |
START HORIZONTAL BLANK
| Bits 7-{)  | START HORIZONTAL BLANK  |     |     |
| ---------- | ----------------------- | --- | --- |
9-bit Value = character clock value at which horizontal blanking begins. This register
contains the least significant 8 bits of this value.
End Horizontal Blank Register (E_H_BLNKI (CR31
| ReadJWrite                   |     | Address: 375H, Index 03H  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Paired                    |     |
This register determines the pulse width of the BLANK signal and the display enable skew.
|     | I     | I  I  | I  I     |
| --- | ----- | ----- | -------- |
| 7   | 6  5  | 4  3  | 2  1  0  |
DSP-SKW
| R          | 1  0                  | END HORIZONTAL BLANK  |     |
| ---------- | --------------------- | --------------------- | --- |
| Bits 4-{)  | END HORIZONTAL BLANK  |                       |     |
7-bit Value = least significant 7 bits of the character clock counter value at which time
horizontal blanking ends. To obtain this value, add the desired BLANK pulse width in
character clocks to the Start Horizontal Blank value, which is also in character clocks.
The 5 least significant bits ofthis sum are programmed into this field. The sixth bit is
programmed into bit 7 of CR5. The seventh bit is programmed into bit 3 of CR5D.
| Bits 6-0  | DSP-SKW -Display Skew  |     |     |
| --------- | ---------------------- | --- | --- |
These two bits determine the amount of display enable skew. Display enable skew
control provides sufficient time for the CRT Controller to access the display buffer to
obtain a character and attribute code, access the character generator font, and then
go through the Horizontal Pixel Panning register in the Attribute Controller. Each ac
cess requires the display enable signal to be skewed one character clock unit so the
video output is synchronous with the HSYNC and VSYNC signals. The bit values and
amount of skew are shown in the following table:
00 = Zero character clock skew
Oi = One character ciock skew
10 = Two character clock skew
11 = Three character clock skew
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
17-12 STANDARD VGA REGISTER DESCRIPTIONS

••
r
86CM65 Dual Display Accelerator
83 Inllorporeted
Start Horizontal Sync Position Register (S_H_SY_ PI (CR41
| Read/Write                   |     | Address: 37SH, Index 04H  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Paired                    |     |
This register is used to adjust the screen center horizontally and to specify the character position at
which HSYNC becomes active. Bit 8 of this value is bit 4 of CRSD.
| Bits 7-0  | START HORIZONTAL SYNC POSITION.  |     |     |
| --------- | -------------------------------- | --- | --- |
9-bit Value = character clock counter value at which HSYNC becomes active. This reg
ister contains the least significant 8 bits of this value.
End Horizontal Sync Position Register (E_H_SY_ PI (CR51
| Read/Write                   |     | Address: 37SH, Index OSH  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Paired                    |     |
This register specifies when the HSYNC signal becomes inactive and the horizontal skew. The HSYNC
pulse defined by this register can be extended by 32 DCLKs via bit S of CRSD.
|     | I     | I  I  | I           |
| --- | ----- | ----- | ----------- |
| 7   | 6  5  | 4  3  | 2  1  I  0  |
EHB  HOR-SKW
| b5        | 1  0                     | END HORIZONTAL SYNC POS  |     |
| --------- | ------------------------ | ------------------------ | --- |
| Bits 4-0  | END HORIZONTAL SYNC P~S  |                          |     |
6-bit Value = 6 least significant bits of the character clock counter value at which time
HSYNC becomes inactive. To obtain this value, add the desired HSYNC pulse width in
character clocks to the Start Horizontal Sync Position value, also in character clocks.
The 5 least significant bits ofthis sum are programmed into this field. The sixth bit is
programmed into bit S of CRSD.
| Bits 6-5  | HOR-SKW -Horizontal Skew  |     |     |
| --------- | ------------------------- | --- | --- |
These bits control the skew ofthe HSYNC signal. A binary 00 equals no HSYNC delay.
For some modes, it is necessary to provide an HSYNC signal that takes up the entire
blanking interval. Some internal timings are generated by the falling edge of the
HSYNC signal. To guarantee the signals are latched properly, HSYNC is asserted be
fore the end of the display enable signal, and then skewed several character clock
times to provide the proper screen centering.
00 = Zero character clock skew
01 = One character clock skew
10 = Two character clock skew
11 = Three character clock skew
| Bit7  | EHB bS  |     |     |
| ----- | ------- | --- | --- |
End Horizontal Blanking bit S.
STANDARD VGA REGISTER DESCRIPTIONS  17-13

86CM65 Dual Display Accelerator
S3 Incorporated
Vertical Total Register (V_TOTAL) (CR6)
| Read/Write                   |     | Address: 375H, Index 06H  |         |     |
| ---------------------------- | --- | ------------------------- | ------- | --- |
| Power-On Default: Undefined  |     |                           | Paired  |     |
This register specifies the number of scan lines from one VSYNC active to the next VSYNC active.
The scan line counter resets to 0 at this point. Bit 8 is bit 0 of CR7. Bit 9 is bit 5 of CR7. Bit 10 is bit 0
ofCR5E.
| 7  6  | 543  |     | 2  1  | o   |
| ----- | ---- | --- | ----- | --- |
VERTICAL TOTAL
| Bits 7-0  | VERTICAL TOTAL  |     |     |     |
| --------- | --------------- | --- | --- | --- |
11-bit Value = (number of scan lines from VSYNC active to the next VSYNC active) -2.
This register contains the least significant 8 bits of this value.
CRTC Overflow Register (OVFL_REG) (CR7)
| Read/Write                   |       | Address: 375H, Index 07H  |           |     |
| ---------------------------- | ----- | ------------------------- | --------- | --- |
| Power-On Default: Undefined  |       |                           | Paired    |     |
| 7  6                         | 5  4  | 3                         | 2  1      | 0   |
|                              | VT    |                           |           | VT  |
| VRS  VDE                     | LCM   | SVB                       | VRS  VDE  |     |
| 9  9                         | 9  8  | 8                         | 8  8      | 8   |
This register provides extension bits for fields in other registers.
| Bit 0  | Bit 8 of the Vertical Total register (CR6)           |     |     |     |
| ------ | ---------------------------------------------------- | --- | --- | --- |
| Bit 1  | Bit 8 of the Vertical Display End register (CR12)    |     |     |     |
| Bit 2  | Bit 8 of the V~rtical Retrace Start register (CR10)  |     |     |     |
| Bit 3  | Bit 8 ofthe Start Vertical Blank register (CR15)     |     |     |     |
| Bit 4  | Bit 8 of the Line Compare register (CR18)            |     |     |     |
| Bit 5  | Bit 9 of the Vertical Total register (CR6)           |     |     |     |
| Bit 6  | Bit 9 of the Vertical Display End register (CR12)    |     |     |     |
| Bit 7  | Bit 9 of the Vertical Retrace Start register (CR10)  |     |     |     |
17-14 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorpontod
Preset Row Scan Register (P_ R_SCAN) (CRB)
| Read/Write                   |     | Address: 3?5H, Index 08H  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Paired                    |     |
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
Maximum Scan Line Register (MAX_S_LN) (CR9)
| Read/Write                   |     | Address: 375H, Index 09H  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Paired                    |     |
This register specifies the number of scan lines per character row and provides one scanning control
bit and two overflow bits.
| 7  6      | 5  4           | I  3  I  2     | J  1  I  0  |
| --------- | -------------- | -------------- | ----------- |
| DBl  lCM  | SVB            |                |             |
| SCN  9    | 9              | MAX SCAN LINE  |             |
| BIts4-0   | MAX SCAN LINE  |                |             |
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
STANDARD VGA REGISTER DESCRIPTIONS 17-15

II.
r
86CM65 Dual Display Accelerator
83 Incorporated
Cursor Start Scan Line Register (CSSL) (CRA)
| Read/Write                   |     | Address: 375H, Index OAH  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Shared                    |     |
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
o
= Turns on the text cursor
1 = Turns off the text cursor
| Bits 7-6  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
Cursor End Scan Line Register (CESL) (CRB)
| Read/Write                   |     | Address: 375H, Index OBH  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Shared                    |     |
This register defines the row scan of a character line where the cursor ends.
|     | I     | I  I  | I  I     |
| --- | ----- | ----- | -------- |
| 7   | 6  5  | 4  3  | 2  1  0  |
CSR-SKW
| =0       | 1  0                  | CURSOR END SCAN LINE  |     |
| -------- | --------------------- | --------------------- | --- |
| Bits4-0  | CURSOR END SCAN LINE  |                       |     |
Value = ending scan line number within the character cell for the text cursor. If the
value of the cursor start scan line is greater than the value of cursor end line, then no
cursor is generated.
| Bits 6-5  | CSR-SKW -Cursor Skew  |     |     |
| --------- | --------------------- | --- | --- |
These bits control the delay skew of the cursor signal. Cursor skew delays the text cur
sor by the selected number of clocks. For example, a skew of 1 moves the cursor
right one character position on the screen.
00 = Zero character ciock skew
01 = One character clock skew
10 - Two character clock skew
11 = Three character clock skew
| Bit 7  | Reserved = 0  |     |     |
| ------ | ------------- | --- | --- |
17-16 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
8S I.oorporated
Start Address High Register (STA(H)) (CRC)
| Read/Write                   |     | Address: 375H, Index OCH  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Paired                    |     |
20-bit Value = the first address after a vertical retrace at which the display on the screen begins on each
screen refresh. These along with bits 2-0 of CR69 are the high order start address bits.
Start Address Low Register (STA(L)) (CRD)
| Read/Write                   |       | Address: 375H, Index ODH  |       |
| ---------------------------- | ----- | ------------------------- | ----- |
| Power-On Default: Undefined  |       | Paired                    |       |
| 7  6                         | 5  4  | 3  2                      | 1  o  |
DISPLAY START ADDRESS (LOW)
Start address (low) contains the 8 low order bits of the address.
Cursor Location Address High Register (CLA(H)) (CRE)
| Read/Write                   |     | Address: 375H, Index OEH  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Shared                    |     |
20-bit Value = the cursor location address of the video memory where the text cursor is active. This
register along with bits 2-0 of CR69 are the high order bits of the address.
Cursor Location Address Low Register (CLA(L)J (CRA
| Read/Write                   |     | Address: 375H, Index OFH  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Shared                    |     |
o
| 7  6  | 5  432  |     | 1   |
| ----- | ------- | --- | --- |
CURSOR LOCATION ADDRESS (LOW)
Cursor location address (low) contains the 8 low order bits of the address.
STANDARD VGA REGISTER DESCRIPTIONS 17-17

-
86CM65 Dual Display Accelerator
S3 Incorporated
Vertical Retrace Start Register (VRS) (CR10)
| Read/Write                   |     | Address: 315H, Index 10H  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Paired                    |     |
o
| 7  6  | 543  | 2   | 1   |
| ----- | ---- | --- | --- |
VERTICAL RETRACE START
| Bits 7-G  | VERTICAL RETRACE START.  |     |     |
| --------- | ------------------------ | --- | --- |
11-bit Value =s can line counter value at which VSYNC becomes active. These are the
low-order 8 bits. Bit 8 is bit 2 of CR7. Bit 9 is bit 7 of CR7. Bit 10 is bit 4 of CR5E.
Vertical Retrace End Register (VRE) (CR11)
| Read/Write             |     | Address: 375H, Index 11H  |     |
| ---------------------- | --- | ------------------------- | --- |
| Power-On Default: OxH  |     | Paired                    |     |
This register controls the vertical interrupt and CRO-7
| 7  6       | 5                     | I  2  I               | I  0  |
| ---------- | --------------------- | --------------------- | ----- |
|            | 4                     | 3                     | 1     |
| LOCK  REF  | DIS  CLR              |                       |       |
| R0-7  3/5  | VINT  VINT            | VERTICAL RETRACE END  |       |
| Bits 3-G   | VERTICAL RETRACE END  |                       |       |
Value = least significant 4 bits of the scan line counter value at which VSYNC goes in
active. To obtain this value, add the desired VSYNC pulse width in scan line units to
the CR10 value, also in scan line units. The 4 least significant bits ofthis sum are pro
grammed into this field. This allows a maximum VSYNC pulse width of 15 scan line
units.
| Bit 4  | CLR VINT -Clear Vertical Retrace Interrupt  |     |     |
| ------ | ------------------------------------------- | --- | --- |
o  = Vertical retrace interrupt cleared
1 = The flip-flop is able to catch the next interrupt request
At the end of active vertical display time, a flip-flop is set for a vertical interrupt. The
output of this flip-flop goes to the system interrupt controller. The CPU has to reset
this flip-flop by writing a logical 0 to this bit while in the interrupt process, then set
the bit to 1 to allow the flip-flop to catch the next interrupt request. Do not change the
other bits in this register. This bit is cleared to 0 by the BIOS during a mode set, a re
set, or power-on.
| Bit 5  | DIS VINT -Disable Vertical Interrupt  |     |     |
| ------ | ------------------------------------- | --- | --- |
0= Vertical retrace interrupt enabled if CR32_4 = 1
1 = Vertical interrupt disabled. This bit is cleared to 0 by the BIOS during a mode set,
a reset, or power-on
17-18 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
| Bit 6  | REF 3/5 -Refresh Cycle Select  |     |     |
| ------ | ------------------------------ | --- | --- |
o = Three DRAM refresh cycles generated per horizontal line
1 = Five DRAM refresh cycles generated per horizontal line. Selecting five refresh
cycles allows use of the VGA chip with slow sweep rate displays (15.75 KHz).
This bit is cleared to 0 by the BIOS during a mode set. a reset. or power-on. This
setting can be overridden via bits 1-0 of CR3A
| Bit 7  | LOCK RO-7 -Lock Writes to CRT Controller Registers  |     |     |
| ------ | --------------------------------------------------- | --- | --- |
0= Writing to all CRT Controller registers enabled
1 = Writing to all bits of the CRT Controller registers CRO-CR7 except bit 4 of CR7
(LCMa) disabled. This bit is set to 1 by the BIOS during a mode set. a reset or
power-on
Vertical Display End Register IVDEI (CR121
| Read/Write                   | Address: 375H. Index 12H  |         |     |
| ---------------------------- | ------------------------- | ------- | --- |
| Power-On Default: Undefined  |                           | Paired  |     |
The vertical display enable end register defines 8 bits of the 10-bit address of the scan line where the
display on the screen ends. Bit 8 and Bit 9 are bits 1 and 6 of CR7. Bit 10 is bit 1 of CR5E.
o
| 7  6  | 543  | 2  1  |     |
| ----- | ---- | ----- | --- |
VERTICAL DISPLAY END
| Bit 7-0  | VERTICAL DISPLAY END  |     |     |
| -------- | --------------------- | --- | --- |
11-bit Value = (number of scan lines of active display) -1. This register contains the
least significant 8 bits of this value.
Offset Register (SCREEN-OFFSETIICR13)
| Read/Write                   | Address: 375H.lndex 13H  |         |     |
| ---------------------------- | ------------------------ | ------- | --- |
| Power-On Default: Undefined  |                          | Paired  |     |
This register specifies the logical line width of the screen and is sometimes called the screen pitch. The
starting memory address for the next display row is larger than the current row by two. four or eight
times this amount. Bits 5-4 of CR51 are extension bits 9-8 of this register.
| 7  6  | 543  | 2  1  | o   |
| ----- | ---- | ----- | --- |
LOGICAL SCREEN WIDTH
| Bits 7-0  | LOGICAL SCREEN WIDTH  |     |     |
| --------- | --------------------- | --- | --- |
10-bit Value = quantity that is multiplied by 2 (word mode). 4 (doubleword mode) or 8
(quadword mode) to specify the difference between the starting byte addresses of
two consecutive scan lines. This register contains the least significant a bits of this
value. The addressing mode is specified by bit 6 of CR14 and bit 3 of CR17. Setting bit
3 of CR31 to 1 forces doubleword mode.
STANDARD VGA REGISTER DESCRIPTIONS 17-19

,..
r
86CM65 Dual Display Accelerator
sa Inaorponlted
Underline Location Register lULL) ICR14)
| Read/Write                   |     | Address: 375H, Index 14H  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Paired                    |     |
This register specifies the horizontal row scan position of underline and display buffer addressing
modes.
|           |                      | I  I                 | I  I  |
| --------- | -------------------- | -------------------- | ----- |
| 7  6      | 5  4                 | 3  2                 | 1  0  |
| DBWD      | CNT                  |                      |       |
| =0  MODE  | BY4                  | UNDER LINE LOCATION  |       |
| Bits 4-0  | UNDER LINE LOCATION  |                      |       |
5-bit Value = (scan line count of a character row on which an underline occurs)-1
| Bit 5  | CNT BY4 -Select Count by 4 Mode  |     |     |
| ------ | -------------------------------- | --- | --- |
0= The memory address counter depends on bit 3 of CR17 (count by 2)
1 =T he memory address counter is incremented every four character clocks
The CNT BY4 bit is used when double word addresses are used.
| Bit 6  | DBLWD MODE -Select Doubleword Mode  |     |     |
| ------ | ----------------------------------- | --- | --- |
0= The memory addresses are byte or word addresses
1 = The memory addresses are doubleword addresses
| Bit 7  | Reserved = 0  |     |     |
| ------ | ------------- | --- | --- |
Start Vertical Blank Register ISVB) ICR15)
| Read/Write                   |     | Address: 375H, Index 15H  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Paired                    |     |
This register specifies the scan line at which the vertical blanking period begins. Bit 8 is bit 3 of CR7.
Bit 9 is bit 5 of CR9. Bit 10 is bit 2 of CR5E.
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
START VERTICAL BLANK
| Bits 7-0  | START VERTICAL BLANK.  |     |     |
| --------- | ---------------------- | --- | --- |
11-bit value = (scan line count at which BLANK becomes active) -1. This register con
tains the least significant 8 bits of this value.
17-20 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorporated
End Vertical Blank Register (EVB) (CR16)
| Read/Write                   |     | Address: 375H, Index 16H  |     |
| ---------------------------- | --- | ------------------------- | --- |
| Power-On Default: Undefined  |     | Paired                    |     |
This register specifies the scan line count value when the vertical blank period ends.
| 7  6  | 5   | 4  3  2  | 1  o  |
| ----- | --- | -------- | ----- |
END VERTICAL BLANK
| Btts 7-0  | END VERTICAL BLANK  |     |     |
| --------- | ------------------- | --- | --- |
Value = least significant 8 bits of the scan line counter value at which vertical blank
ing ends. To obtain this value, add the desired width of the vertical blanking pulse in
scan lines to the value in the Start Vertical Blank register, also in scan lines. The 8
least significant bits of this sum are programmed into this field. This allows a maxi
mum vertical blanking pulse of 255 scan line units.
CRTC Mode Control Register (CRT_ MO) (CR17)
| Read/Write             |     | Address: 3?5H, Index 17H  |     |
| ---------------------- | --- | ------------------------- | --- |
| Power-On Default: OOH  |     | Paired                    |     |
This register is a multifunction control register, with each bit defining a different specification.
| 7  6       | 5                                              | 4  3  2   | 1  0      |
| ---------- | ---------------------------------------------- | --------- | --------- |
| BYTE       | ADW                                            | WRD  VT   | 4BK  2BK  |
| RST  MODE  | 16K  =0                                        | MODE  X2  | HGC  CGA  |
| Btt 0      | 2BK CGA -Select Bank 2 Mode for CGA Emulation  |           |           |
o  = Row scan counter bit 0 is substituted for memory address bit 13 during active
display time
1 = Memory address bit 13 appears on the memory address output bit 13 signal of
the CRT controller
This bit allows memory mapping compatibility with the IBM CGA graphics mode.
| Bit 1  | 4BK HGC -Select Bank 4 Mode for HGA Emulation  |     |     |
| ------ | ---------------------------------------------- | --- | --- |
0= Row scan counter bit 1 is substituted for memory address bit 14 during active
display time
1 = Memory address bit 14 appears on the memory address output bit 14 signal of
the CRT controller
The combination of this bit and bit 0 of this register allows compatibility with Hercu
les HGC graphics memory mapping.
STANDARD VGA REGISTER DESCRIPTIONS  17-21

86CM65 Dual Display Accelerator
83 Inaorporeted
Bit 2 VT X2 -Select Vertical Total Double Mode
o
= Horizontal retrace clock selected
1 = Horizontal retrace clock divided by two selected
This bit selects horizontal retrace clock or horizontal retrace clock divided by two as
the clock that controls the vertical timing counter. If the vertical retrace counter is
clocked with the horizontal retrace clock divided by 2. then the vertical resolution is
double.
Bit 3 CNT BY2 -Select Word Mode
o
= Memory address counter is clocked with the character clock input. and byte mode
addressing for the video memory is selected
1 = Memory address counter is clocked by the character clock input divided by 2. and
word mode addressing for the video memory is selected
=
Bit 4 Reserved 0
Bit 5 ADW 16K -Address Wrap
0= When word mode is selected by bit 6 of this register. memory address counter bit
13 appears on the memory address output bit 0 signal of the CRT controller and
the video memory address wraps around at 16 KBytes
1 = When word mode is selected by bit 6 of this register. memory address counter bit
15 appears on the memory address output bit 0 signal of the CRT controller
This bit is useful in implementing IBM CGA mode.
Bit 6 BYTE MODE -Select Byte Addressing Mode
o =W ord mode shifts all memory address counter bits down one bit, and the most
significant bit of the counter appears on the least significant bit of the memory
address output
1 = Byte address mode
Bit 7 RST -Hardware Reset
o
= Vertical and horizontal retrace pulses always inactive
1 = Vertical and horizontal retrace pulses enabled
This bit does not reset any other registers or outputs.
17-22 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorporated
Une Compare Register (LCM) (CR18)
| Read/Write                   | Address: 315H, Index 18H  |         |     |
| ---------------------------- | ------------------------- | ------- | --- |
| Power-On Default: Undefined  |                           | Paired  |     |
This register is used to implement a split screen function. When the scan line counter value is equal
o.
to the content of this register, the memory address counter is cleared to  The linear address counter
then sequentially addresses the display buffer starting at address O. Each subsequent row address is
determined by the addition of the Offset (CR13) register content. Bit 8 is bit 4 of CR7. Bit 9 is bit 6 of
CR9. Bit 10 is bit 6 of CR5E.
| 7  6  | 543  | 2  1  | o   |
| ----- | ---- | ----- | --- |
LINE COMPARE POSITION
| Bit 7"'()  | LINE COMPARE POSITION  |     |     |
| ---------- | ---------------------- | --- | --- |
11-bit Value = number of scan lines at which the screen is split into screen A and
screen B. This register contains the least significant 8 bits of this value.
CPU Latch Data Register (GCCL) (CR22)
| Read Only                    | Address: 3?5H, Index 22H  |         |     |
| ---------------------------- | ------------------------- | ------- | --- |
| Power-On Default: Undefined  |                           | Paired  |     |
This register is used to read the CPU latch in the Graphics Controller.
| Bits 7"'()  | GRAPHICS CONTROLLER CPU LATCH -N  |     |     |
| ----------- | --------------------------------- | --- | --- |
Bits 1-0 of GR4 select the latch number N (3-0) of the CPU Latch.
STANDARD VGA REGISTER DESCRIPTIONS 17-23

86CM65 Dual Display Accelerator
Attribute Index Register IATC_FIIl ICR24)
Read Only Address: 375H, Index 24H, 26H
Power-On Default: Undefined Paired
This register is used to read the value of the Attribute Controller Index register and its associated
internal address flip-flop IAFF}. It can be read at either index 24H or 26H.
Bits4-0 ATIRIBUTE CONTROLLER INDEX
This value is the Attribute Controller Index Data at I/O port 3COH.
Bit 5 ENV-Enable Video Display
This is the setting of bit 5 of 3COH, indicating video display enabled status
11 = enabled}.
Bit 6 Reserved = 0
Bit' AFF
Inverted Internal Address flip-flop
17-24 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
sa lnoorpol'a'ed
17.4 GRAPHICS CONTROLLER REGISTERS
The graphics controller registers are located at a two byte I/O address space. These registers are
accessed by first writing an index to the Graphics Address register (at 3CEH) and then accessing the
Data register (at 3CFH).
Graphics Controller Index Register (GRC_ADR)
Read/Write Address: 3CEH
Power-On Default: Undefined
This register is loaded with a binary index value that determines which graphics controller register will
be accessed. This value is referred to as the "Index Number" of the GR register (GR0-6).
321 0
GR CONT ADDRESS
Bits 3-0 GR CONT ADDRESS -Graphics Controller Register Index
A binary value indexing the register where data is to be accessed.
Bits 7-4 Reserved = 0
Graphics Controller Data Register (GRC_DATAI
Read/Write Address: 3CFH
Power-On Default: Undefined
This register is the data port for the graphics controller register indexed by the Graphics Controller
Index register.
7 65432 1 o
GRAPHICS CONTROLLER DATA
Bit 7-0 GRAPHICS CONTROLLER DATA
Data to the Graphics Controller register indexed by the graphics controller address.
STANDARD VGA REGISTER DESCRIPTIONS 17-25

86CM65 Dual Display Accelerator
sa Incorponlted
Set/Reset Data Register (SET/RST_DTI (GROI
Read/Write Address: 3CFH, Index OOH
Power-On Default: Undefined
This register represents the value written to a" 8 bits of the respective memory plane when the CPU
executes a memory write in write modes 0 and 3.
321 0
SET/RESET DATA
Bits 3-0 SET/RESET DATA
These bits become the color value for CPU memory write operations. In write mode
0, the set/reset data can be enabled on the corresponding bit of the Enable Set/Reset
Data register. In write mode 3, there is no effect on the Enable Set/Reset Data register.
Bits 7-4 Reserved =0
Enable Set/Reset Data Register (EN_S/R_DTI (GR11
Read/Write Address: 3CFH, Index 01H
Power-On Default: Undefined
These bits enable the set/reset data, and affect write mode O.
7 6 321 0
=0 =0 ENB SET/RST DATA
Bits 3-0 ENB SET/RST DATA
When each bit is a logical 1, the respective memory plane is written with the value of
the Set/Reset Data register. A logical 0 disables the set/reset data in a plane, and that
plane is written with the value of CPU write data.
Bits 7-4 Reserved = 0
17-26 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorporated
Color Compare Register (COLOR-CMP) (GR2)
| Read/Write  |     | Address: 3CFH, Index 02H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
These bits represent a 4-bit color value to be compared. In read mode 1, the CPU executes a memory
read, the read data is compared with this value and returns the results. This register works in
conjunction with the Color Don't Care register.
|     |     | 321  | 0   |
| --- | --- | ---- | --- |
COLOR COMPARE DATA
| Bits 3-0  | COLOR COMPARE DATA  |     |     |
| --------- | ------------------- | --- | --- |
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
| 7  6  | 5  4  | I  3  2  | I  1  I  0  |
| ----- | ----- | -------- | ----------- |
RST-OP
| =0  =0    | =0  1         | 0  ROTATE-COUNT  |     |
| --------- | ------------- | ---------------- | --- |
| Bits 2-0  | ROTATE-COUNT  |                  |     |
These bits define a binary encoded value of the number of positions to right-rotate
data during a CPU memory write. To write non-rotated data, the CPU must preset a
count ofO.
STANDARD VGA REGISTER DESCRIPTIONS 17-27

86CM65 Dual Display Accelerator
831. ..............
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
Bits 7~ Reserved = 0
Read Plane Select Register (RD_PL_SLI (GR41
Read/Write Address: 3CFH, Index 04H
Power-On Default: Undefined
1 0
RD-PL-SL
1 0
The contents of this register represent the memory plane from which the CPU reads data in read mode
o.
This register has no effect on the color compare read mode (read mode 11. In odd/even mode, bit 0
is ignored. Four memory planes are selected as follows:
Bits 1-0 RD-PL-SL -Read Plane Select
The memory plane is selected as follows:
00 = Plane 0
01 = Plane 1
10 = Plane 2
11 = Plane 3
Bits 7-2 Reserved = 0
17-28 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Inoorpor.ud
Graphics Controller Mode Register (GRP_ MODE) (GR5)
ReadJWrite Address: 3CFH, Index 05H
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
10 = Write Mode 2. Memory planes 0-3 are filled with 8 bits of the value of CPU
write data bits 0-3, respectively. For example, if write data bit 0 is a 1, eight 1's
are written to memory plane O. The data on the CPU data bus is treated as the
color value. The Bit Mask register is effective as the Mask register. A logical 1 in
the Bit Mask register sets the corresponding pixel in the addressed byte to the
color specified on the data bus. A logical 0 in the Bit Mask register sets the
corresponding pixel in the addressed byte to the corresponding pixel in the
processor latches. The Set/Reset, Enable SetlReset and Rotate Count registers
are ignored
11 = Write Mode 3. Each of four video memory planes is written with 8 bits of the
color value contained in the set/reset register for that plane. The Enable Set/
Reset register is not effective. Rotated CPU write data is ANDed with the bit mask
register to form an 8-bit value that performs the same function as the Bit Mask
register in write modes 0 and 2. This write mode can be used to fill an area with
a single color and pattern
Bit 2 Reserved = 0
Bit 3 RD CMP -Enable Read Compare
o
= The CPU reads data from the video memory planes. The plane is selected by the
Read Plane Select register. This is called read mode 0
1 = The CPU reads the results of the logical comparison between the data in four
video memory planes selected by the contents of the Color Don't Care register
and the contents of the Color Compare register. The result is a 1 for a match and
o
for a mismatch on each pixel. This is called read mode 1
STANDARD VGA REGISTER DESCRIPTIONS 17-29

86CM65 Dual Display Accelerator
Ulnoorponted
| Bit 4  | OlE MAP -Select OddlEven Addressing  |     |     |
| ------ | ------------------------------------ | --- | --- |
o = Standard addressing.
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
o = Bit 5 in this register controls operation of the video shift registers
1 = The shift registers are loaded in a manner that supports the 256 color mode
| Bit 7  | Reserved =0   |     |     |
| ------ | ------------- | --- | --- |
Memory Map Mode Control Register (MISC_GM) (GR6)
| Read/Write  |     | Address: 3CFH, Index 06H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register controls the video memory addressing.
| 7  6  | 5  4  | 3  I  2  | 1  0      |
| ----- | ----- | -------- | --------- |
|       |       | MEM-MAP  | CHN  TXT  |
OlE
| =0  =0  | =0  =0                             | 1  0  | /GR  |
| ------- | ---------------------------------- | ----- | ---- |
| Bit 0   | TXT/GR -Select Text/Graphics Mode  |       |      |
o
= Text mode display addressing selected
1 = Graphics mode display addressing selected. When set to graphics mode, the
character generator address latches are disabled
Bit 1
CHN OlE -Chain Odd/Even Planes
o =A O address bit unchanged
1 = CPU address bit AO is replaced by a higher order address bit. The content of AO
determines which memory plane is to be addressed. AO  =  0 selects planes 0
|     | and 2, and AO  | =  1 selects planes 1 and 3. This mode can be used to double the  |     |
| --- | -------------- | ----------------------------------------------------------------- | --- |
address space into video memory
17-30 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Incorporatad
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
Color Don't Care Register (CMP_ DNTC) (GR7)
| Read/Write  |     | Address: 3CFH,Index 07H  |     |
| ----------- | --- | ------------------------ | --- |
Power-On Default: Undefined
This register is effective in read mode 1, and controls whether the corresponding bit of the Color
Compare Register is to be ignored or used for color comparison.
| 7         |                                          | 321                | 0   |
| --------- | ---------------------------------------- | ------------------ | --- |
| =0        |                                          | COMPARE PLANE SEL  |     |
| Bits 3-0  | COMPARE PLANE SEL -Compare Plane Select  |                    |     |
o
= The corresponding color plane becomes a don't care plane when the CPU read
from the video memory is performed in read mode 1
1 = The corresponding color plane is used for color comparison with the data in the
Color Compare register
Reserved =0
Bits 7-4
Bit Mask Register (BIT_MASK) (GR8)
| Read/Write  |     | Address: 3CFH, Index 08H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
Any bit programmed to 0 in this register will cause the corresponding bit in each offour memory planes
to be immune to change. The data written into memory in this case is the data which was read in the
previous cycle, and was stored in the processor latches. Any bit programmed to 1 allows unimpeded
writes to the corresponding bits in the plane.
o
| 7  6  | 5  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
BIT MASK
| Bits 7-0  | BIT MASK  |     |     |
| --------- | --------- | --- | --- |
A logical 0 means the corresponding bit of each plane in memory is set to the corre
sponding bit in the processor latches. A logical 1 means the corresponding bit of
each plane in memory is set as specified by other conditions.
STANDARD VGA REGISTER DESCRIPTIONS 17-31

86CM65 Dual Display Accelerator
83 Inoorporded
17.5 ATIRIBUTE CONTROLLER REGISTERS
The attribute controller registers are located at the same byte VO address for writing address and data.
An internal address flip-flop (AFF) controls the selection of either the attribute index or data registers.
To initialize the address flip-flop (AFF), an VO read is issued at address 3BAH or 3DAH. This presets the
address flip-flop to select the index register. After the index register has been loaded by an I/O write
to address 3COH, AFF toggles and the next VO write loads the data register. Every VO write to address
3COH toggles this address flip-flop. However, it does not toggle for 1/0 reads at address 3COH or 3C1 H.
The Attribute Controller Index register is read at 3COH, and the Attribute Controller Data register is read
at address 3C1 H.
Attribute Controller Index Register (ATR_AD)
| ReadJWrite  |     | Address: 3COH  |     |
| ----------- | --- | -------------- | --- |
Power-On Default: Undefined
This register is loaded with a binary index value that determines which attribute controller register will
be accessed. This value is referred to as the "Index Number" ofthe AR register (ARQ-141.
| 7  6  | 5   | 4  I  3  I  2  | I  1  L 0  |
| ----- | --- | -------------- | ---------- |
ENB
| R  R       | PLT                | ATTRIBUTE ADDRESS  |     |
| ---------- | ------------------ | ------------------ | --- |
| Bits 4-()  | ATTRIBUTE ADDRESS  |                    |     |
A binary value that points to the attribute controller register where data is to be
written.
| Bit 5  | ENB PL T -Enable Video Display  |     |     |
| ------ | ------------------------------- | --- | --- |
o  = Video display access to the palette registers disabled. The Attribute Controller
register can be accessed by the CPU
1 = Display video using the palette registers enabled (normal display operation). The
palette registers (ARQ-ARFI cannot be accessed by the CPU
This bit is effective only in 8-bit PA mode (CR67 _4 = 01.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
17-32 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
Attribute Controller Data Register IATR_DATAI
| Read/Write  |     | Address: R: 3C1H/W: 3COH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
This register is the data port for the attribute controller register indexed by the Attribute Controller
Index register.
o
| 7  6  | 5  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
ATIRIBUTE DATA
| Bits 7-0  | ATTRIBUTE DATA  |     |     |
| --------- | --------------- | --- | --- |
Data to the attribute controller register indexed by the attribute controller address.
Palette Registers IPLT_REGI IAROO-GF)
| Read/Write  |     | Address: 3C1H/3COH, Index OOH-OFH  |     |
| ----------- | --- | ---------------------------------- | --- |
Power-On Default: Undefined
These are 16, 6-bit registers pointed to by the index and color code. They allow a dynamic mapping
between the text attribute or graphics color input and the display color on the CRT screen.
|         | I          | I      | I  I     |
| ------- | ---------- | ------ | -------- |
| 7  6    | 5  4       | 3  2   | 1  0     |
|         | SECONDARY  |        | PRIMARY  |
| =0  =0  | SR  SG     | SB  R  | G  B     |
Bits s-o
PALETTE COLOR
The six bit display color, bits 5-0 are output as SR, SG/I, SBN, R, G and B,
respectively.
| Bits 7-6  | Reserved =0   |     |     |
| --------- | ------------- | --- | --- |
STANDARD VGA REGISTER DESCRIPTIONS  17-33

86CM65 Dual Display Accelerator
83 Inoorporded
Attribute Mode Control Register (AT't-MODEI (AR101
| Read/Write  |     | Address: 3C1H/3COH, Index 10H  |     |
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
o
= Selects color display text attributes
1 = Selects monochrome display text attributes
| Bit 2  | ENB LGC -Enable Line Graphics  |     |     |
| ------ | ------------------------------ | --- | --- |
o
= The ninth dot of a text character (bit 0 of SR1 = 01 is the same as the background
1 = Special line graphics character codes enabled
When this bit is set to 1, it forces the ninth dot of a line graphics character to be identi
cal to the eighth dot of the character. The line graphics character codes are COH
through DFH. For other characters, the ninth dot is the same as the background.
| Bit 3  | ENB BLNK -Enable Blinking  |     |     |
| ------ | -------------------------- | --- | --- |
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
| Bit 4  | Reserved = 0                 |     |     |
| ------ | ---------------------------- | --- | --- |
| Bit 5  | TOP PAN -Top Panning Enable  |     |     |
o
= Line compare has no effect on the output of the pixel panning register
1 = Forces the output of the pixel panning register to 0 after matching line compare
until VSYNC occurs in the CRT controller. At the top of screen the output of the
Pixel Panning register returns to its programmed value. This bit allows a top
portion of a split screen to be panned.
17-34 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
sa InoCNpO,.ted
| Bit 6  | 256 CLR -Select 256 Color Mode  |     |     |
| ------ | ------------------------------- | --- | --- |
o = 4 bits of video (translated to 6 bits by the palette) are output every internal
dot-clock cycle
1 = Two 4-bit sets of video data are assembled to generate 8-bit video data at half the
frequency of the internal dot-clock
| Bit 7  | SEL V54 -Select V[5:4)  |     |     |
| ------ | ----------------------- | --- | --- |
o = In VGA, mode, bits 5-4 of video output are generated by the attribute palette
registers. Bits 7-6 of video output are always generated by bits 3-2 of AR14
1 = Bits 5-4 of video output are generated by bits 1-0 of AR14
Border Color Register (BDR_CLR) (AR11)
| Read/Write             |     | Address: 3C1H/3COH, Index 11H  |     |
| ---------------------- | --- | ------------------------------ | --- |
| Power-On Default: OOH  |     | Shared                         |     |
o
| 7  6  | 5  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
BORDER COLOR
Bits 7-0  Border Color. This 8-bit register determines the border color displayed on the CRT
screen. The border is an area around the screen display area.
This register is only effective in 8-bit PA modes (CR67 _4 = 0). See also CR33_5.
Color Plane Enable Register (DISP_ PLN) (AR12)
| Read/Write  |     | Address: 3C1H/3COH, Index 12H  |     |
| ----------- | --- | ------------------------------ | --- |
Power-On Default: OOH
This register enables the respective video memory color plane 3-0 and selects video color outputs to
be read back in the display status.
| 6   | I     | I  2  | I  I  |
| --- | ----- | ----- | ----- |
| 7   | 5  4  | 3     | 1  0  |
VDT-SEL
| =0  =0    | 1  0                | DISPLAY PLANE ENBL  |     |
| --------- | ------------------- | ------------------- | --- |
| Bits 3-0  | DISPLAY PLANE ENBL  |                     |     |
A 0 in any of these bits forces the corresponding color plane bit to 0 before accessing
the internal palette. A 1 in any of these bits enables the data on the corresponding
color plane.
STANDARD VGA REGISTER DESCRIPTIONS 17-35

86CM65 Dual Display Accelerator
sa Incorporated
Bits 5-4  VDT-SEL -Video Test Select
These bits select two of the eight bit color outputs to be available in the Input Status
1 register. The output color combinations available on the status bits are as follows:
| DSTSMUX  |             | STS1          |     |
| -------- | ----------- | ------------- | --- |
| Bit 5    | Bit 4       | Bit 5  Bit 4  |     |
| 0        | 0  Video 2  | Video 0       |     |
| 0        | 1  Video 5  | Video 4       |     |
| 1        | 0  Video 3  | Video 1       |     |
| 1        | 1  Video 7  | Video 6       |     |
Bits 7-6  Reserved = 0
Horizontal Pixel Panning Register IH_PX_PAN) IAR13)
ReadJWrite  Address: 3C1H/3COH, Index 13H
Power-On Default: OOH
This register specifies the number of pixels to shift the display data horizontally to the left. Pixel panning
is available in both text and graphics modes. It is not available with Enhanced mode memory mappings
(CR31_3 = 1).
|     | 321  | 0   |     |
| --- | ---- | --- | --- |
NUMBER OF PAN SHIFT
Bits 3-0  NUMBER OF PAN SHIFT
This register selects the number of pixels to shift the display data horizontally to the
left. In the 9 pixels/character text mode, the output can be shifted a maximum shift of
8 pixels. In the 8 pixels/character text mode and all graphics modes, except 256 color
mode, a maximum shift of 7 pixels is possible. In the 256 color mode, bit 0 of this reg
ister must be 0 resulting in only 4 panning positions per display byte. The panning is
controlled as follows:
Number of Dixels shifted In
| Bits 3-0  | 9 pixel/char.  | S pixel/char.  | 256 color mode  |
| --------- | -------------- | -------------- | --------------- |
| 0000      | 1              | 0              | 0               |
-
| 0001  | 2   | 1   |     |
| ----- | --- | --- | --- |
| 0010  | 3   | 2   | 1   |
-
| 0011  | 4   | 3   |     |
| ----- | --- | --- | --- |
0100
|       | 5   | 4   | 2   |
| ----- | --- | --- | --- |
| 0101  |     | 5   | -   |
6
| 0110  | 7   | 6   | 3   |
| ----- | --- | --- | --- |
-
| 0111  | 8   | 7   |     |
| ----- | --- | --- | --- |
-
| 1000  | 0   |     | -   |
| ----- | --- | --- | --- |
Bits 7-4  Reserved = 0
17-36 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorpo. .t ed
Pixel Padding Register (PX_PADD) (AR14)
| Read/Write  |     | Address: 3C1H/3COH, Index 14H  |     |
| ----------- | --- | ------------------------------ | --- |
Power-On Default: OOH
This register specifies the high-order bits of video output when pixel padding is enabled and disabled
in the 256 color mode.
|       |       | I     | I  I  |
| ----- | ----- | ----- | ----- |
| 7  6  | 5  4  | 3  2  | 1  0  |
PIXEL PADDING
| =0  =0  | =0  =0  | V7  V6  | V5  V4  |
| ------- | ------- | ------- | ------- |
Bits 1~ PIXEL PADDING V5, V4
These bits are enabled with a logical 1 of bit 7 of AR10, and can be used in place of
the V5 and V4 bits from the Palette registers to form the 8-bit digital color value out
put.
| Bits 3-2  | PIXEL PADDING V7, V6  |     |     |
| --------- | --------------------- | --- | --- |
In all modes except 256 color mode, these bits are the two high-order bits of the 8-bit
digital color value output.
| Bits 7-4  | Reserved = 0  |     |     |
| --------- | ------------- | --- | --- |
STANDARD VGA REGISTER DESCRIPTIONS 17-37

86CM65 Dual Display Accelerator
sa Incorporated
17.6 RAMDAC REGISTERS
All of the RAMDAC registers described in this section are physically located inside Aurora.
DAC Mask Register (DAC_AD_MKI
ReadJWrite Address: 3C6H
Power-On Default: Undefined
This register is the pixel read mask register to select pixel video output. The CPU can access this register
at anytime.
7 6 5 4 3 2 1 o
DAC ADDRESS MASK
Bits 7-{) DAC ADDRESS MASK
The contents of this register are bit-wise logically ANDed with the pixel select video
output (PA[7:0). This register is initialized to FFH by the BIOS during a video mode
set.
DAC Read Index Register (DAC_RD_ADI
Write Only Address: 3C7H
Power-On Default: Undefined
This register contains the pointer to one of 256 palette data registers and is used when reading the
color palette.
7 6 543 2 1 o
DAC READ ADDRESS
Bits 7-{) DAC READ ADDRESS
Each time the color code is written to this register, it identifies that a read sequence
will occur. A read sequence consists ofthree successive byte reads from the RAM
DAC data register at I/O address 3C9H. The least significant 6 bits of each byte taken
from the RAMDAC data register contain the corresponding color value, and the most
significant 2 bits contain zeros. The order is red byte first, then green, and finally
blue. The sequence of events for a read cycle is:
1. Write the color code to this register (RAMDAC Read Index) at address 3C7H.
2. The contents of the location in the color look-up table pointed to by the color code
are transferred to the RAMDAC data register at address 3C9H.
3. Three bytes are read back from the RAMDAC data register.
4. The contents of this register auto-increment by one.
17-38 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorporded
5. Go to step 2.
The effects of writing to the RAMDAC data register during a three-byte read cycle or
reading from the RAMDAC data register during a 3-byte write cycle (i.e., interrupting
the sequence) are undefined and may change the look-up table contents.
DAC Status Register (DAC_STSI
Read Only Address: 3C7H
Power-On Default: Undefined
3 2 1 0
=0 =0 DAC-STS
Bits 1-0 DAC-STS -RAMDAC Cycle Status
The last executing cycle was:
=
00 Write Palette cycle
11 = Read Palette cycle
Reads from the RAMDAC Write Index at address 3C8H or the DAC status register at
address 3C7H do not interfere with read or write cycles and may take place at any
time.
Bits 7-2 Reserved = 0
DAC Write Index Register (DAC_WR_AD)
Read/Write Address: 3C8H
Power-On Default: Undefined
o
7 6 543 2 1
DAC WRITE ADDRESS
Bits 7-0 DAC WRITE ADDRESS
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
STANDARD VGA REGISTER DESCRIPTIONS 17-39

86CM65 Dual Display Accelerator
S3 Inoorponted
3. The contents of the DAC data register are transferred to the location in the color
look-up table pointed to by the color code.
4. The DAC Write Index register auto-increments by 1.
5. Go to step 2.
RAMDAC Data Register (DAC_DATA)
Read/Write Address: 3C9H
Power-On Default: Undefined
This register is a data port to read or write the contents ofthe location in the color look-up table pointed
to by the DAC Read Index or the DAC Write Index registers.
o
7 6 543 2 1
DAC READ/WRITE DATA
Bits 7-0 DAC READ/WRITE DATA
To prevent "snow flicker" on the screen, an application reading data from or writing
data to the DAC Data register should ensure that the BLANK input to the RAMDAC is
asserted. This can be accomplished either by restricting data transfers to retrace inter
vals, checking bit 3 of the Input Status 1 register (31 AH) to determine when retrace is
occurring, or by using the screen-off bit in the Clocking Mode register of the se
quencer (bit 5 of SR1).
17-40 STANDARD VGA REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Incorpor.ud
Section 18: Extended Sequencer Register Descriptions
The following registers are located in Sequencer Register address space not used by standard VGA.
An appropriate value must be programmed in SRS to unlock access to these registers.
In the following register descriptions, 'U' stands for undefined or unused and 'R' stands for reserved
(write =0 , read = U). See Appendix A for a table listing each register in this section and its page number.
18.1 MISCELLANEOUS EXTENDED SEQUENCER REGISTERS
Unlock Extended Sequencer Register (SR8)
Read/Write Address: 3C5H, Index OSH
Power-On Default: OOH
loading xxxx0110b (e.g., 06H) unlocks accessing of all the S3 extensions (SR9 -SR6F) to the standard
VGA Sequencer register set. (x = don't care).
o
7 6 5 4 3 2 1
R R R R =0 =1 =1 =0
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 1S-1

86CM65 Dual Display Accelerator
Extended Sequencer 9 Register (SR9)
ReadJWrite Address: 3C5H, Index 09H
Power-On Default: OOH
This register controls the powerdown for the Controller 1 dot clock (DCLK). There are two types of
DCLK used in Controller 1: the virtual DCLK is used on logic which is affected by flat panel horizon
tal expansion while the true DCLK is used on logic which is not affected by flat panel horizontal ex
pansion.
Bits 1-0 Reserved
Bit 2 C1 P1 -Controller 1 Powerdown Enable 1
0= Controller 1 virtual DCLK is not turned off when CR67 _3-2=11
1 = Controller 1 virtual DCLK is turned off when CR67 _3-2=11
This bit should be programmed to 1 by the BIOS during reset.
Bit 3 C1SB1 -Controller 1 Standby Enable 1
0= Controller 1 virtual DCLK is not turned off in Standby mode
1= Controller 1 virtual DCLK is turned off in Standby mode
This bit should be programmed to 1 by the BIOS during reset.
Bit 4 C1SU1 -Controller 1 Suspend Enable 1
o
= Controller 1 virtual DCLK is not turned off in Suspend mode
1 = Controller 1 virtual DCLK is turned off in Suspend mode
This bit should be programmed to 1 by the BIOS during reset.
Bit 5 Controller 1 Standby Enable 2
o
= Controller 1 true DCLK is not turned off in Standby mode
1 = Controller 1 true DCLK is turned off in Standby mode
This bit should be programmed to 1 by the BIOS during reset.
Bit 6 Controller 1 Suspend Enable 2
o
= Controller 1 true DCLK is not turned off in Suspend mode
1 = Controller 1 true DCLK is turned off in Suspend mode
This bit should be programmed to 1 by the BIOS during reset.
18-2 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Incarpar.ud
Bit 7 MMIO-ONLY -Memory-mapped I/O register access only
0= When MMIO is enabled, both programmed I/O and memory-mapped I/O register
accesses are allowed
1 = When MMIO is enabled, only memory-mapped I/O register accesses are allowed
to extended (non-standard VGA) registers. Both 1/0 and MMIO accesses can be
made to standard VGA registers.
Extended Sequencer A Register (SRA)
Read/Write Address: 3C5H, Index OAH
Power-On Default: OOH
Bits 4-0 Reserved
Bit 5 PD-NTRI -PD[63:0) Not Tri-stated
o
= PD[63:0) tri-stated
1 = PD[63:0) not tri-stated
The default value of 0 reduces power consumption. The pins are enabled for output
only as needed.
Bit 6 Reserved
Bit 7 2MCLK -2 MCLK CPU writes to memory
o
= 3 MCLK memory writes
1 = 2 MCLK memory writes
Setting this bit to 1 improves performance for systems using an MCLK less than 57
MHz. For MCLK frequencies between 55 and 57 MHz, bit 7 of SR15 should also be set
to 1 if linear addressing is being used.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-3

86CM65 Dual Display Accelerator
83 Incorporated
Extended Sequencer D Register (SRD)
| Read/Write  |     | Address: 3C5H, Index ODH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register provides feature connector control and also provides independent control of the
HSYNC and VSYNC signals, therefore supporting the VESA DPMS (Display Power Management Con
trol) standard.
| I        | I        |       |       |
| -------- | -------- | ----- | ----- |
| 7  6     | 5  4     | 3  2  | 1  0  |
| VSY-CTL  | HSY-CTL  |       | LPB   |
EN
| 1  0   | 1  0                      | R  R  | R   |
| ------ | ------------------------- | ----- | --- |
| Bit 0  | LPBEN -LPBEN Pin Control  |       |     |
o
= LPBEN pin is held at logic 0
1 = LPBEN pin is he.ld at logic 1
This pin is used to enable/disable Scenic Highway video decoders.
| Bits 3-1  | Reserved                |     |     |
| --------- | ----------------------- | --- | --- |
| Bits 5-4  | HSY-CTL -HSYNC Control  |     |     |
00 = Normal operation
01 =HSYNC=O
10 = HSYNC= 1
11 = Reserved
| Bits 7-6  | VSY-CTL -VSYNC Control  |     |     |
| --------- | ----------------------- | --- | --- |
00 = Normal operation
01 = VSYNC =0
10 = VSYNC = 1
11 = Reserved
18-4 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
MCLK Value Low Register (SR10)
| Read/Write  |     | Address: 3C5H,Index 10H  |     |
| ----------- | --- | ------------------------ | --- |
Power-On Default: See description below.
The power-on default value for this register in conjunction with the power-on default value for SR11
generate an MCLK value of 45 MHz. All other MCLK values must be specified by programming of
SR10 and SR11. Loading of a new value is enabled by either bit 0 or bit 5 of SR15.
| Bits 4"()  | PLL N-DIVIDER VALUE  |     |     |
| ---------- | -------------------- | --- | --- |
These bits contain the binary equivalent of the integer 11-31) divider used to scale the
input to the MCLK PLL. See Section 8 for a detailed explanation.
| Bits 6-5  | PLL R VALUE  |     |     |
| --------- | ------------ | --- | --- |
These bits contain the binary equivalent of the integer 11, 2,4,8) range value used to
scale the output of the MCLK PLL. See Section 8 for a detailed explanation.
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
MCLK Value High Register ISR11)
| Read/Write  |     | Address: 3C5H,Index 11H  |     |
| ----------- | --- | ------------------------ | --- |
Power-On Default: See description below.
The power-on default value for this register in conjunction with the power-on default value for SR10
generate an MCLK value of 45 MHz. All other MCLK values must be specified by programming of
SR10 and SR11. Loading of a new value is enabled by either bit 0 or bit 5 of SR15.
| 7  6        | 5  4                 | 3  2  | 1  o  |
| ----------- | -------------------- | ----- | ----- |
| R           | PLL M-DIVIDER VALUE  |       |       |
| Bits 6..()  | PLL M-DIVIDER VALUE  |       |       |
These bits contain the binary equivalent of the integer 11-127) divider used in the feed
back loop of the MCLK PLL. See Section 8 for a detailed explanation.
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-5

86CM65 Dual Display Accelerator
sa Incorporeted
Enhanced Mode DCLK Value Low Register (SR12)
| Read/Write  | Address: 3C5H, Index 12H  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: Undefined
SR12 and SR13 are selected as the source of the DCLK PLL parameter values when 3C2H_3-2 = 11 b.
This setting is used for all Enhanced modes. Loading of new values occurs when either SR15_1 is set
to 1 or SR15_5 is programmed to 1 and then O.
| Bits 5-0  | PLL N-DIVIDER VALUE  |     |     |
| --------- | -------------------- | --- | --- |
These bits contain the binary equivalent of the integer (1-63) divider used to scale the
input to the DCLK PLL. See Section 8 for a detailed explanation.
| Bits 7-6  | PLL R VALUE  |     |     |
| --------- | ------------ | --- | --- |
These bits contain the binary equivalent of the integer (1, 2, 4, 8) range value used to
scale the output of the DCLK PLL. See Section 8 for a detailed explanation.
Enhanced Mode DCLK Value High Register (SR13)
| Read/Write  | Address: 3C5H, Index 13H  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: Undefined
SR12 and SR13 are selected as the source ofthe DCLK PLL parameter values when 3C2H_3-2 = 11b.
This setting is used for all Enhanced modes. Loading of new values occurs when either SR15_1 is
o.
set to 1 or SR15_5 is programmed to 1 and then
| 7  6  | 543  | 2  1  | o   |
| ----- | ---- | ----- | --- |
PLL M-DIVIDER VALUE
| Bits 7-0  | PLL M-DIVIDER VALUE  |     |     |
| --------- | -------------------- | --- | --- |
These bits contain the binary equivalent of the integer (1-255) divider used in the feed
back loop of the DCLK PLL. See Section 8 for a detailed explanation.
18-6 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
CLKSYN Control 1 Register (SR14)
| Read/Write  |     |     | Address: 3C5H, Index 14H  |     |
| ----------- | --- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6        | 5                             | 4    | 3  2       | 1  0        |
| ----------- | ----------------------------- | ---- | ---------- | ----------- |
| EXT  EXT    |                               | CLR  | M  EN      | MPLL  DPLL  |
| OCLK  MCLK  | LTS                           | CNT  | TEST  CNT  | PO  PO      |
| Bit 0       | OPLL PO -Power down OCLK PLL  |      |            |             |
o
= OCLK PLL powered
1 = OCLK PLL powered down
This bit is used for S3 test purposes only.
| Bit 1  | MPLL PO -Power down MCLK PLL  |     |     |     |
| ------ | ----------------------------- | --- | --- | --- |
o  = MCLK PLL powered
1 = MCLK PLL powered down
This bit is used for S3 test purposes only.
| Bit 2  | EN CNT -Enable clock synthesizer counters  |     |     |     |
| ------ | ------------------------------------------ | --- | --- | --- |
o = Clock synthesizer counters disabled
1 = Clock synthesizer counters enabled
This bit is used for S3 test purposes only.
| Bit 3  | M TEST -MCLK Test  |     |     |     |
| ------ | ------------------ | --- | --- | --- |
o
= Test DCLK
1 = Test MCLK
This bit is used for S3 test purposes only.
| Bit 4  | CLR CNT -Clear clock synthesizer counters  |     |     |     |
| ------ | ------------------------------------------ | --- | --- | --- |
0= No effect
1 = Clear the clock synthesizer counters
This bit is used for S3 test purposes only.
| Bit 5  | LT S -LPBEN Pin Tri-state  |     |     |     |
| ------ | -------------------------- | --- | --- | --- |
0= LPBEN pin (N1) has normal function
1 = LPBEN pin (N1) is tri-stated
Setting this bit to 1 allows pin N1 to act as an input. This is enabled by setting bit 6 of
this register to 1.
| Bit 6  | EXT MCLK -External MCLK Select  |     |     |     |
| ------ | ------------------------------- | --- | --- | --- |
o
= MCLK provided by internal PLL
1 = MCLK is input on pin N1. PD11 must also be strapped low on power-on reset.
An external MCLK is only used for S3 test purposes.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-7

86CM65 Dual Display Accelerator
S3 Incorpor. ....
| Bit 7  | EXT OCLK -External OCLK Select  |     |     |
| ------ | ------------------------------- | --- | --- |
o  = DCLK provided by internal PLL
1 = DCLK is input on pin A 1. P011 must also be strapped low on power-on reset.
An external OCLK is only used for S3 test purposes.
CLKSYN Control 2 Register (SR15)
| Read/Write  |     | Address: 3C5H, Index 15H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6         | 5  4                                     | 3  2    | 1  0        |
| ------------ | ---------------------------------------- | ------- | ----------- |
| 2CYC  DCLK\  | CLK  DCLKJ                               | MCLK    | DRFQ  MFRQ  |
| MWR  INV     | LOAD  2                                  | R  OUT  | EN  EN      |
| Bit 0        | MFRQ EN -Enable new MCLK frequency load  |         |             |
o
= Register bit clear
1 = Load new MCLK frequency
When new MCLK PLL values are programmed, this bit is set to 1 to load these values
in the PLL. The loading may be delayed a small but variable amount of time. This bit
should be cleared to 0 after loading to prevent repeated loading. Alternately, use bit 5
of this register to produce an immediate load.
| Bit 1  | OFRQ EN -Enable new OCLK frequency load  |     |     |
| ------ | ---------------------------------------- | --- | --- |
o
= Register bit clear
1 = Load new DCLK frequency
When new DCLK PLL values are programmed, this bit is set to 1 to load these values
in the PLL. 3C2H_3-2 select the source of the OCLK PLL values. The loading may be
delayed a small but variable amount of time. Use bit 5 of this register to produce an
immediate load.
| Bit 2  | MCLK OUT -Output internally generated MCLK  |     |     |
| ------ | ------------------------------------------- | --- | --- |
o
= Pin C3 has its normal function
1 = Pin C3 outputs the internally generated MCLK if SR1~4  = 1
This is used only for testing.
| Bit 3  | OCLK OUT -Output internally generated OCLK  |     |     |
| ------ | ------------------------------------------- | --- | --- |
0= Pin M1 has its normal function (LCLK input)
1 = Pin M1 outputs the internally generated DCLK
This is used only for testing.
18-8 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorporated
| Bit 4  | DCLK/2 -Divide DCLK by 2  |     |     |
| ------ | ------------------------- | --- | --- |
o
= DCLK unchanged
1 = Divide DCLK by 2
Either this bit or bit 6 of this register must be set to 1 for clock doubled RAMDAC op
eration (mode 0001).
| Bit 5  | CLK LOAD -MCLK, DCLK load  |     |     |
| ------ | -------------------------- | --- | --- |
o = Clock loading is controlled by bits 0 and 1 of this register
1 = Load MCLK and DCLK PLL values immediately
To produce an immediate MCLK and DCLK load, program this bit to 1 and then to  o.
3C2H_3-2 select the source of the DCLK PLL values. This register must never be left
set to 1.
| Bit 6  | DCLK INV -Invert DCLK  |     |     |
| ------ | ---------------------- | --- | --- |
o
= DCLK unchanged
1 = Invert DCLK
Either this bit or bit 4 of this register must be set to 1 for clock doubled RAMDAC op
eration (mode 0001).
| Bit 7  | 2 CYC MWR -Enable 2 cycle memory write  |     |     |
| ------ | --------------------------------------- | --- | --- |
o
= 3 MCLK memory write
1 = 2 MCLK memory write
Setting this bit to 1 bypasses the VGA logic for linear addressing when bit 7 of SRA is
set to 1. This can allow 2 MCLK operation for MCLK frequencies between 55 and 57
MHz.
CLKSVN Test High Register (SR16)
| ReadJWrite  |     | Address: 3C5H, Index 16H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register is reserved for S3 testing of the internal clock synthesizer.
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
| R  R  | R  R  | R  R  | R  R  |
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-9

86CM65 Dual Display Accelerator
S3 In_rporated
CLKSYN Test Low Register (SR17)
Read Only Address: 3C5H, Index 17H
Power-On Default: OOH
This register is reserved for S3 testing of the internal clock synthesizer.
7 6 5 4 3 2 1 o
R R R R R R R R
RAMDAC/CLKSYN Control Register (SR18)
Read/Write Address: 3C5H, Index 18H
Power-On Default: OOH
7 6 5 4 3 2 1 0
CLKx CLUT DAC TST TST TST TST TST
2 WR PD BLUE GRN RED RST EN
Bit 0 TST EN -Enable test counter
o
= RAMDAC test counter disabled
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
18-10 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorporated
Bit 5 OAC PO -RAMOAC power-down
o
= RAMDAC powered up unless SR20_0 = 1 and SR31_5 = 0
1 = RAMDAC powered down
When the RAMDAC is powered down, the RAMDAC memory retains its data. Soft
ware should set this bit when only a flat panel (no CRT/TV) is being driven.
Bit 6 LUT WR -CLUT write cycle control
o
= 2 DCLK CLUT write cycle (default)
1 = 1 DCLK CLUT write cycle
Bit 7 CLKx2 -Enable clock doubled mode
0= RAMDAC clock doubled mode (0001) disabled
1 = RAMDAC clock doubled mode (0001) enabled
This bit must be set to 1 when mode 0001 is specified in bits 7-4 of CR67 or SRC.
Either bit 4 or bit 6 of SR15 must also be set to 1.
Extended Sequencer 1A Register (SR1A)
ReadlWrite Address: 3C5H, Index 1AH
Power-On Default: OOH
6 3 2 1 o
R R R R R
Bits 3-0 Reserved
Bit 4 PC3 -Pin C3 Select
o
= Pin C3 is GOPO
1 = Pin C3 is STWR
Bit 5 PC15 -Pin C15 Select
0= Pin C15 is ROMEN
1 = Pin C15 is FPPOL
Bit 6 Reserved
Bit 7 OACP -DAC Power
o
= RAMDAC and CLUTs powered with 3.3V
1 = RAMDAC and CLUTs powered with 5V
This bit overrides the automatic settings indicated by SR1B_0.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-11

86CM65 Dual Display Accelerator
sa Incorporated
Extended Sequencer 1B Register (SR1B)
See Bit Descriptions Address: 3C5H, Index 1B H
Power-On Default: OOH
6 5 4 3 2 1 o
R R R R R R DP
Bit 0 DP -DAC Power (Read Only)
o
= The RAMDAC and CLUTs are powered with 5V
1 =T he RAMDAC and CLUTs are powered with 3.3V
The internal RAMDAC autosenses its voltage input and generates a signal that is
latched in this register bit. This can be read by the BIOS, which can then force a spe
cific voltage by programming SR1~7.
Bits 6-1 Reserved (Read/Write)
Bit 7 FDCK -Force DCLK Source
o
= DCLK PLL parameter source is specified by 3C2_3-2
1 = DCLK PLL parameter source is forced to SR12 and SR13 regardless of the setting
of3C2_3-2
Extended Sequencer 1C Register (SR1C)
Read/Write Address: 3C5H, Index 1CH
Power-On Default: OOH
All non-reserved bits in this register should be programmed to 1 by the BIOS during reset.
1 o
R R
Bits 1'() Reserved
Bit 2 TVP -TV Encoder Powerdown Enable
o = TV Encoder clock is not turned off when TV Encoder is disabled
1 = TV Encoder clock is turned off when TV Encoder is disabled
Bit 3 TVSB -TV Encoder Standby Enable
o
= TV Encoder clock is not turned off in Standby mode
1 = TV Encoder clock is turned off in Standby mode
Bit 4 TVSU -TV Encoder Suspend Enable
o = TV Encoder clock is not turned off in Suspend mode
1 = TV Encoder clock is turned off in Suspend mode
18-12 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorponted
Bit 5 LP -LPB Powerdown Enable
o
= LPB LCLK is not turned off when LPB is disabled
1 = LPB LCLK is turned off when LPB is disabled
Bit 6 LSB -LPB Standby Enable
o
= LPB LCLK is not turned off in Standby mode
1 = LPB LCLK is turned off in Standby mode
Bit 7 LSU -LPB Suspend Enable
o
= LPB LCLK is not turned off in Suspend mode
1 = LPB LCLK is turned off in Suspend mode
Extended Sequencer 1D Register (SR1D)
Read/Write Address: 3C5H, Index 1DH
Power-On Default: OOH
This register controls the powerdown for the Stream Processor (SP) dot clock (DCLK). The SP DCLK
consists of two branches: branch 1 of the SP DCLK is used on stream processor logic which can be
turned off when the SP is disabled (CR67 _3-2 = 00), while branch 2 of the SP DCLK is used on SP
logic that cannot be turned off when the SP is disabled.
All non-reserved bits in this register should be programmed to 1 by the BIOS during reset.
2 1 o
R R R
Bits 2-0 Reserved
Bit 3 SP1 -Stream Processor Powerdown Enable 1
o
= SP DCLK branch 1 is not turned off when SP is disabled
1 = SP DCLK branch 1 is turned off when SP is disabled
Bit 4 SSB 1-Stream Processor Standby Enable 1
0= SP DCLK branch 1 is not turned off in Standby mode
1 = SP DCLK branch 1 is turned off in Standby mode
Bit 5 SSU1 -Stream Processor Suspend Enable 1
0= SP DCLK branch 1 is not turned off in Suspend mode
1 = SP DCLK branch 1 is turned off in Suspend mode
Bit 6 SSB2 -Stream Processor Standby Enable 2
o = SP DCLK branch 2 is not turned off in Standby mode
1 = SP DCLK branch 2 is turned off in Standby mode
Bit 7 SSU2 -Stream Processor Suspend Enable 2
o = SP DCLK branch 2 is not turned off in Suspend mode
=
1 SP DCLK branch 2 is turned off in Suspend mode
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-13

86CM65 Dual Display Accelerator
S3 Inoorporated
Power Management 5 Register (SR1E)
| ReadJWrite  | Address: 3C5H, Index 1EH  |     |
| ----------- | ------------------------- | --- |
Power-On Default: OOH
All non-reserved bits in this register should be programmed to 1 by the BIOS during reset.
| 7  6    | 5                                    | 1   |
| ------- | ------------------------------------ | --- |
| SSE  R  | R                                    | R   |
| Bit 0   | C1PD -Controller 1 Powerdown Enable  |     |
o
= Controller 1 DCLK is not turned off when Controller 1 is not enabled
1 = Controller 1 DCLK is turned off when Controller 1 is not enabled
Controller 1 is enabled when SR31_1 =0  or when SR31_2 = 0 and SR31_4 = 1)
| Bit 1  | Reserved                              |     |
| ------ | ------------------------------------- | --- |
| Bit 2  | C2PD -Controller 2 Power Down Enable  |     |
0= Controller 2 DCLK is not turned off when Controller 2 is not enabled
1 = Controller 2 DCLK is turned off when Controller 2 is not enabled
Controller 2 is enabled when SR31_1 = 1 or when SR31_2 = 1 and SR31_4  = 1)
| Bit 3  | C2SB -Controller 2 Power Down During Standby  |     |
| ------ | --------------------------------------------- | --- |
0= Controller 2 is not powered down during Standby
1 = Controller 2 is powered down during Standby
| Bit 4  | C2SU -Controller 2 Power Down During Suspend  |     |
| ------ | --------------------------------------------- | --- |
o
= Controller 2 is not powered down during Suspend
1 = Controller 2 is powered down during Suspend
| Bits 6-5  | Reserved                           |     |
| --------- | ---------------------------------- | --- |
| Bit 7     | BSE -Bus Interface Suspend Enable  |     |
o  = Bus interface SCLK is not turned off dursing Suspend
1 = Bus interface SCLK is turned off during Suspend
18-14 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorponted
Extended Sequencer 1F Register (SR1 F)
ReacJJWrite Address: 3C5H, Index 1F H
Power-On Default: OOH
All non-reserved bits in this register should be programmed to 1 by the BIOS during reset.
Bit 0 GESE -Graphics Engine Suspend Enable
o = GE MCLK is not turned off in Suspend mode
1 = GE MCLK is turned off in Suspend mode
Bit 1 DMSE -Data Manager Suspend Enable
o
= OM MCLK is not turned off in Suspend mode
1 = OM MCLK is turned off in Suspend mode
Bit 2 BSE -Bus Interface Unit MCLK Suspend Enable
o
= MCLK branch going to bus interface is not turned off in Suspend mode
1 = MCLK branch going to bus interface is turned off in Suspend mode
Bit 3 LPBE -LPB MCLK Suspend Enable
o = MCLK branch going to LPB is not turned off in Suspend mode
1 = MCLK branch going to LPB is turned off in Suspend mode
Bit 4 CSPE -Controller 1/Controller 2/Streams Processor MCLK Suspend Enable
0= MCLK going to Controller 1, Controller 2, and the Streams Processor is not turned
off in Suspend mode
1 = MCLK going to Controller 1, Controller 2, and the Stream Processor is turned off
in Suspend mode
Bit 5 MSE -MCLK Suspend Enable
o
= All branches of MCLK are not turned off in Suspend mode regardless of the
settings of the other non-reserved bits of this register
1 = All branches of MCLK can be turned off in Suspend mode depending on the
settings of the other non-reserved bits of this register
Bit 6 Reserved
Bit 7 FPIE -Flat Panel Interface MCLK Suspend Enable
o = MCLK branch going to the Flat Panel Interface is not turned off in Suspend mode
1 = MCLK branch going to the Flat Panel Interface is turned off in Suspend mode
*
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-15

86CM65 Dual Display Accelerator
S3 InaoqtOrded
Extended Sequencer 20 Register (SR20)
| Read/Write  | Address: 3C5H, Index 20H  |     |
| ----------- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6    | 5         |     |
| ------- | --------- | --- |
| PSE  R  | R         | R   |
| Bit 0   | Reserved  |     |
°DS BE -DAC Standby Enable
Bit 1
= DAC is not turned off in Standby mode
1 = DAC is turned off in Standby mode
| Bit 2  | DSUE -DAC Suspend Enable  |     |
| ------ | ------------------------- | --- |
0= DAC is not turned off in Suspend mode
1 = DAC is turned off in Suspend mode
| Bit 3  | °DP SE -DCLK PLL Suspend Enable  |     |
| ------ | -------------------------------- | --- |
= DCLK PLL is not turned off in Suspend mode
1 = DCLK PLL is turned off in Suspend mode
This bit is OR-ed with SR14_0.
| Bit 4  | °MP SE -MCLK PLL Suspend Enable  |     |
| ------ | -------------------------------- | --- |
= MCLK PLL is not turned off in Suspend mode
1 = MCLK PLL is turned off in Suspend mode
This bit is OR-ed with SR14_0.
| Bits 6-5  | Reserved  |     |
| --------- | --------- | --- |
°PS E -Pads Suspend Enable
Bit 7
= Suspend mode has no effect on pads
1 = Suspend mode puts the pads in Suspend configuration
18-16 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorporated
Extended Sequencer 21 Register (SR21)
Read/Write Address: 3C5H. Index 21H
Power-On Default: aaH
Bit a LUT1 -Disable CLUT1
a = CLUT1 enabled
1 = CLUT1 disabled (powered down)
Bit 1 MS -Disable Monitor Sense
a = Monitor sense circuit enabled
1 = Monitor sense circuit disabled (powered down)
Bit 2 C1LS -Controller 1 CLUT Standby Enable
a - Controller 1 CLUT is not powered down in Standby mode
1 = Controller 1 CLUT is powered down in Standby mode
The BIOS must program this bit to 1 after each reset.
Bit 3 C1 LE -Controller 1 CLUT Standby Enable
a = Controller 1 CLUT is not powered down in Suspend mode
1 = Controller 1 CLUT is powered down in Suspend mode
The BIOS must program this bit to 1 after each reset.
Bit 4 LUT2 -Disable CLUT2
a = CLUT2 enabled
1 = CLUT2 disabled (powered down)
Bit 5 C2LP -Controller 2 CLUT Powerdown Enable
a = Controller 2 CLUT is not powered down when Controller 2 is not enabled
1 = Controller 2 CLUT is powered down when Controller 2 is not enabled
The BIOS must program this bit to 1 after each reset.
Bit 6 C2LS -Controller 2 CLUT Standby Enable
a = Controller 2 CLUT is not powered down in Standby mode
1 = Controller 2 CLUT is powered down in Standby mode
The BIOS must program this bit to 1 after each reset.
Bit 7 C2LE -Controller 2 CLUT Standby Enable
a = Controller 2 CLUT is not powered down in Suspend mode
1 = Controller 2 CLUT is powered down in Suspend mode
The BIOS must program this bit to 1 after each reset.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-17

86CM65 Dual Display Accelerator
S3lnoorporated
VGA DCLKO Value Low Register (SR22)
| Read/Write  |     | Address: 3C5H, Index 22H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: See description below
SR22 and SR23 are selected as the source of the DCLK PLL parameter values when 3C2H_3-2 = OOb.
The power-on default value for this register in conjunction with the power-on default value for SR23
generate a DCLK value of 25.175 MHz. Loading of new values occurs when either SR15_1 is set to 1 or
SR15_5 is programmed to 1 and then O.
| Bits 5-0  | N-DIVIDER VALUE  |     |     |
| --------- | ---------------- | --- | --- |
These bits contain the binary equivalent of the integer (1-31) divider used to scale the
input to the DCLK PLL. See Section 8 for a detailed explanation.
| Bits 7-6  | PLL R VALUE  |     |     |
| --------- | ------------ | --- | --- |
These bits contain the binary equivalent ofthe integer (1, 2, 4, 8) range value used to
scale the output of the DCLK PLL. See Section 8 for a detailed explanation.
VGA DCLKO Value High Register (SR23)
| Read/Write  |     | Address: 3C5H, Index 23H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: See description below.
SR22 and SR23 are selected as the source of the DCLK PLL parameter values when 3C2H_3-2 = OOb.
The power-on default value for this register in conjunction with the power-on default value for SR22
generate a DCLK value of 25.175 MHz. Loading of new values occurs when either SR15_1 is set to 1
or SR15_5 is programmed to 1 and then O.
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
PLL M-DIVIDER VALUE
| Bits 7-0  | PLL M-DIVIDER VALUE  |     |     |
| --------- | -------------------- | --- | --- |
These bits contain the binary equivalent of the integer (1-127) divider used in the feed
back loop of the DCLK PLL. See Section 8 for a detailed explanation.
18-18 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorporated
VGA DCLKO Value Low Register (SR24)
| Read/Write  | Address: 3C5H,Index 24H  |     |
| ----------- | ------------------------ | --- |
Power-On Default: See description below
SR24 and SR25 are selected as the source of the DCLK PLL parameter values when 3C2H_3-2 = 01 b.
The power-on default value for this register in conjunction with the power-on default value for SR25
generate a DCLK value of 28.322 MHz. Loading of new values occurs when either SR15_1 is set to 1 or
SR15_5 is programmed to 1 and then O.
| Bits 5"()  | N-DIVIDER VALUE  |     |
| ---------- | ---------------- | --- |
These bits contain the binary equivalent of the integer (1-31) divider used to scale the
input to the DCLK PLL. See Section 8 for a detailed explanation.
| Bits 7-6  | PLL R VALUE  |     |
| --------- | ------------ | --- |
These bits contain the binary equivalent of the integer (1, 2, 4, 8) range value used to
scale the output of the DCLK PLL. See Section 8 for a detailed explanation.
VGA DCLKO Value High Register (SR25)
| Read/Write  | Address: 3C5H, Index 25H  |     |
| ----------- | ------------------------- | --- |
Power-On Default: See description below.
SR24 and SR25 are selected as the source of the DCLK PLL parameter values when 3C2H_3-2 = 01b.
The power-on default value for this register in conjunction with the power-on default value for SR24
generate a DCLK value of 28.322 MHz. Loading of new values occurs when either SR15_1 is set to 1
or SR15_5 is programmed to 1 and then O.
o
| 7  6  | 543  | 2  1  |
| ----- | ---- | ----- |
PLL M-DIVIDER VALUE
| Bits 7"()  | PLL M-DIVIDER VALUE  |     |
| ---------- | -------------------- | --- |
These bits contain the binary equivalent of the integer (1-127) divider used in the feed
back loop of the DCLK PLL. See Section 8 for a detailed explanation.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-19

86CM65 Dual Display Accelerator
Paired Register Read/Wrlte Select Register (SR26)
| Read/Write  | Address: 3C5H, Index 26H  |     |
| ----------- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6   | 5  4                                      |      |
| ------ | ----------------------------------------- | ---- |
| R  R   | R  R                                      | DSR  |
| Bit 0  | DSR -Disable Selected Controller 1 Reads  |      |
o
= Data for all paired register reads comes from the controller 1 registers
1 = Reads of CRO-CR7, CR10-12, CR15-16 from controller 1 are disabled. Read
data is provided from the corresponding paired registers in controller 2
This bit is only effective if bit 1 of this register is cleared to O.
| Bit 1  | DR -Disable Controller 1 Reads  |     |
| ------ | ------------------------------- | --- |
o = Data for all paired register reads comes from the controller 1 registers
1 = Reads of all paired controller 1 registers are disabled. Read data is
provided from the corresponding paired registers in controller 2
Setting this bit to 1 overrides the setting of bit 0 of this register.
| Bit 2  | EC2W -Enable Controller 2 Writes  |     |
| ------ | --------------------------------- | --- |
o = Writes to controller 2 registers are disabled
1 = Writes to controller 2 registers are enabled.
Note that by default, writes to controller 1 registers (controlled by bit 3 of this regis
ter) are enabled and writes to controller 2 registers are disabled. Software can selec
tively write to only controller 1 registers, only controller 2 registers or to both with
one write (mirroring) by enabling writes to both.
| Bit 3  | DC1W -Disable Controller 1 Writes  |     |
| ------ | ---------------------------------- | --- |
o =W  rites to controller 1 registers are enabled
1 =W  rites to controller 1 registers are disabled
See the note for bit 2 ofthis register.
Note: If this bit is set to 1, any subsequent writes to any SR register will be directed to
SR26 (the index is locked). Therefore, no writes to SR registers (except SR26) should
be made ifthis bit is set to 1.
| Bits 7-4  | Reserved  |     |
| --------- | --------- | --- |
18-20 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3lncorpoNted
MCLK Control Register (SR27)
| Read/Write  | Address: 3C5H. Index 27H  |     |
| ----------- | ------------------------- | --- |
Power-On Default: OOH
| 7  6      | 5  4              |             |
| --------- | ----------------- | ----------- |
| R  R      | R  R  IMCLK MUX2  | IMCLK MUX}  |
| Bits 1-0  | IMCLK MUX1        |             |
00 = IMCLK = MCLK
=
01 = IMCLK  DCLK
10 .. IMCLK = MCLK
11 = IMCLK = SCLK
If CR37 _3 = O. the XIN pin becomes the EDCLK (external DCLK) input and the LPBEN
pin becomes the EMCLK (external MCLK) input. SR14_6 selects whether the external
MCLK or PLL-generated MCLK is used. SR14_7 selects whether the external DCLK or
PLL-generated DCLK is used.
Note: These bits should not be changed at the same time as bits 3-2 of this register
(at least 10 SCLKs must intervene).
| Bits 3·2  | IMCLK MUX2  |     |
| --------- | ----------- | --- |
00 = MCLK = IMCLK
01 = MCLK = IMCLK/2
10 = MCLK = IMCLK/3
11 = MCLK = IMCLK/4
Note: These bits should not be changed at the same time as bits 1-0 of this register
(at least 10 SCLKs must intervene) ..
| Bits 7-4  | Reserved  |     |
| --------- | --------- | --- |
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-21

86CM65 Dual Display Accelerator
DCLK Control Register (SR28)
Read/Write Address: 3C5H, Index 28H
Power-On Default: OOH
Bits 1-0 IDCLKA MUX1
= =
00 IDCLKA DCLK
01 = IDCLKA = DCLK
10 = IDCLKA = MCLK
11 = IDCLKA = SCLK
If CR37 _3 = 0, the XIN pin becomes the EDCLK (external DCLK) input and the LPBEN
pin becomes the EMCLK (external MCLK) input. SR143 selects whether the external
DCLK or PLL-generated DCLK is used. SR14_6 selects whether the external MCLK or
PLL-generated MCLK is used.
Note: These bits should not be changed at the same time as bits 3-2 of this register
(at least 10 SCLKs must intervene).
Bits 3-2 IDCLKA MUX2
00 = DCLK1 = IDCLKA
01 = DCLK1 = IDCLKA/2
10 = DCLK1 = IDCLKA/3
11 = DCLK1 = IDCLKA/4
DCLK1 is the pixel clock for the controller 1 path (includes the Streams Processor).
Note: These bits should not be changed at the same time as bits 1-0 of this register
(at least 10 SCLKs must intervene).
Bits 5-4 IDCLKB MUX1
00 = IDCLKB = DCLK
01 = IDCLKB = DCLK
10 = IDCLKB = MCLK
11 = IDCLKB = SCLK
If CR37 _3 = 0, the XIN pin becomes the EDCLK (external DCLK) input and the LPBEN
pin becomes the EMCLK (external MCLK) input. SR143 selects whether the external
DCLK or PLL-generated DCLK is used. SR14_6 selects whetl\er the external MCLK or
PLL-generated MCLK is used.
Note: These bits should not be changed at the same time as bits 7-6 of this register
(at least 10 SCLKs must intervene).
18-22 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Inaorporated
Bits 7-6 IDCLKB MUX2
00 = DCLK2 = IDCLKB
01 = DCLK2 = IDCLKB/2
10 = DCLK2 = IDCLKB/3
11 = DCLK2 = IDCLKB/4
DCLK2 is the pixel clock for the controller 2 path (no Streams Processor).
Note: These bits should not be changed at the same time as bits 5-4 of this register
(at least 10 SCLKs must intervene).
FIFO Threshold Register (SR29)
Read/Write Address: 3C5H, Index 29H
Power-On Default: OOH
Bits 1-0 STN W FIFO -STN Write FIFO Threshold
00 = 2 slots filled
01 = 4 slots filled
10 = 8 slots filled
11 = 12 slots filled
When this many slots are filled in this 16-slot FIFO, a request is generated to the mem
ory manager to begin emptying the FIFO. This is used to maximize the efficiency of
the the memory interface.
Bits 5-2 STN READ FIFO -STN Read FIFO Threshold
Value = Number of STN read FIFO slots
When the FIFO empties down to this value, a high priority memory access request is
generated.
Bits 7-6 CONT2 FIFO -Controller 2 FIFO Threshold
00 = 2 slots filled
01 = 4 slots filled
10 = 8 slots filled
11 = 12 slots filled
When the FIFO empties down to this value, a high priority memory access request is
generated.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-23

86CM65 Dual Display Accelerator
sa Incorpomed
18.2 FLAT PANEL REGISTERS
Architecture Configuration Register (SR30)
| Read/Write  |     | Address: 3CSH. Index 30H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6   | 5  4                  | 3  2  | 1  0    |
| ------ | --------------------- | ----- | ------- |
| R  R   | R  R                  | R  R  | R  PST  |
| Bit 0  | PCT -Panel Scan Type  |       |         |
o
= Dual-scan STN panel
1 = TFT or single-scan STN panel
| Bits 7-1  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Flat Panel Display Mode Register (SR31)
| Read/Write  |     | Address: 3CSH.lndex 31H  |     |
| ----------- | --- | ------------------------ | --- |
Power-On Default: OOH
o
5
|        | R                   |     | CTM  |
| ------ | ------------------- | --- | ---- |
| Bit 0  | CTM -CRT Test Mode  |     |      |
o
= Standard flat panel operation
1 = CRT RGB data output on FP(23:0]
This bit is used for test purposes. It allows direct viewing of either CRT or TV encoder
data before it reaches the CLUT/RAMDAC.
| Bit 1  | FPS -Flat Panel Data Source  |     |     |
| ------ | ---------------------------- | --- | --- |
o
= Controller 1 is flat panel source (Streams Processor available)
1 = Controller 2 is flat panel source (Streams Processor not available)
This bit is valid only if SR31_0 = O.
| Bit 2  | DACS -DAC Source Select  |     |     |
| ------ | ------------------------ | --- | --- |
o
= Controller 1 is DAC source (Streams Processor available)
1 = Controller 2 is DAC source (Streams Processor not available)
If TV mode is selected (CR3D_O = 1). controller 1 is automatically selected as the DAC
source.
18-24 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Incorporated
Bit 3 BLUT -Bypass CLUT Test Mode
o
= Normal operation
1 = Force bypass of Controller 1 and Controller 2 CLUTs in all modes
This bit is for test purposes only.
Bit 4 FPE -Flat Panel Display Enable
o
= Disable flat panel display
1 = Enable flat panel display
Setting this bit to 1 triggers a panel power-on sequence and turns on the clocks to the
flat panel logic. Clearing this bit to 0 triggers a panel power-down sequence and dis
ables the clocks to the flat panel logic.
Bit 5 Reserved
Bit 6 ID -Icon Destination Select
o
= Hardware icon controlled by controller 1
1 = Hardware icon controlled by controller 2
The hardware icon is available in any video mode. This bit determines on which
screen the icon will appear in dual image mode (both controllers being used).
Bit 7 CD -Cursor Destination Select
o
= Hardware cursor controlled by controller 1
1 = Hardware cursor controlled by controller 2
The hardware cursor is only available in Enhanced mode (not VGA). This bit deter
mines on which screen the cursor will appear in dual display mode (both controllers
being used).
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-25

86CM65 Dual Display Accelerator
Flat Panel Polarity Control Register (SR32)
Read/Write Address: 3CSH, Index 32H
Power-On Default: OOH
Bit 0 MIT -Memory Interface Tri-state
0= No effect
1 = Tri-state all memory interface signals
Bit 1 CHSP -CRT HSYNC Polarity During Simultaneous Display
o
= HSYNC polarity is active high
1 = HSYNC polarity is active low
This bit controls HSYNC polarity (instead of 3C2H_6 Write Only) when simultaneous
display is used (SR31_4 = 1 AND SR31_1 = SR31_2).
Bit 2 CVSP -CRT VSYNC Polarity During Simultaneous Display
o
= VSYNC polarity is active high
1 = VSYNC polarity is active low
This bit controls VSYNC polarity (instead of 3C2H_7 Write Only) when simultaneous
display is used (SR31_4 = 1 AND SR31_1 = SR31_2).
Bit 3 Reserved
Bit 4 FPDP -Flat Panel Data Polarity
o
= Active high
1 =A ctive low
BitS DEP -FPDE Polarity
o
= Active high
1 = Active low
Bit 6 HSP -FPHSYNC Polarity
o
= Active high
1 = Active low
For STN panels, this is the LP signal.
Bit 7 VSP -FPVSYNC Polarity
o = Active high
1 = Active low
For STN panels, this is the FLM signal.
18-26 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Inoorporated
Flat Panel AC Modulation Register (SR34)
| Read/Write  |     | Address: 3C5H. Index 34H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
This register only applies to STN panels that require a MOD input.
o
|     | 6  5  | 4  3  | 2  1  |
| --- | ----- | ----- | ----- |
MODULATION PERIOD
| Bits 6-0  | MODULATION PERIOD  |     |     |
| --------- | ------------------ | --- | --- |
Value = (width of MOD pulse in clock period units) -1
The clock units (line or frame) are selected via SR35_4.
|     | Bit 7  ME -Modulation Enable  |     |     |
| --- | ----------------------------- | --- | --- |
0= Pin 815 is FPDE
1 = Enable output of MOD signal on pin 815
Flat Panel Modulation Clock Select Register (SR35)
| Read/Write  |     | Address: 3C5H. Index 35H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7   | 6  5  | 3   | 2  1  0  |
| --- | ----- | --- | -------- |
IM~DCI
| R        | R  R                          | R   | R  R  R  |
| -------- | ----------------------------- | --- | -------- |
| Blts3-G  | Reserved                      |     |          |
|          | Bit4  MODC -MOD Clock Select  |     |          |
o
= Line clock
1 = Frame clock
| Bits 7-5  | Reserved  |     |     |
| --------- | --------- | --- | --- |
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-27

86CM65 Dual Display Accelerator
sa Inoorporated
Flat Panel Dither Control Register (SR36)
| Read/Write  | Address: 3C5H, Index 36H  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: OOH
| Bit 0  | DBS -Dither Bit Select  |     |     |
| ------ | ----------------------- | --- | --- |
o
= 2 bits selected (2x2 dither pattern)
1 = 4 bits selected (4x4 dither pattern)
| Bits 2-1  | Reserved        |     |     |
| --------- | --------------- | --- | --- |
| Bits 5-3  | DTR BASE COLOR  |     |     |
000 = 8 bits selected (no dithering)
001 = Reserved
010 = Reserved
011 = 3 bits selected
100 = 4 bits selected
101 = 5 bits selected
110 = 6 bits selected
111 = Reserved
| Bits 7-6  | DTR CON -Dither Control  |     |     |
| --------- | ------------------------ | --- | --- |
00 = Dithering disabled
01 = Dithering in all modes
10 = Dither in graphics modes (not text)
11 = Dither in graphics modes with 8 bpp or more color
Flat Panel FRC Weight Select RAM Pointer Register (SR37)
| Read/Write  | Address: 3C5H, Index 37H  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: OOH
I
| 7  6      | 5  4                   | I  I  | I     |
| --------- | ---------------------- | ----- | ----- |
|           |                        | 3  2  | 1  0  |
| R  R      | R  R                   |       |       |
| Bits 3-0  | WEIGHT SELECT POINTER  |       |       |
Value = offset from the base address of the weight decoding RAM
| Bits 74  | Reserved  |     |     |
| -------- | --------- | --- | --- |
18-28 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Inoorpon.od
Flat Panel FRC Weight Select RAM Data Register ISR38)
| Read/Write  |     | Address: 3C5H, Index 38H  |
| ----------- | --- | ------------------------- |
Power-On Default: OOH
o
| 7  6  | 543  | 2  1  |
| ----- | ---- | ----- |
WEIGHT SELECT DATA
| Bits 7"()  | WEIGHT SELECT DATA  |     |
| ---------- | ------------------- | --- |
The actual value will be supplied by S3 for specific panels.
Flat Panel FRC Control Register ISR39)
| Read/Write  |     | Address: 3C5H, Index 39H  |
| ----------- | --- | ------------------------- |
Power-On Default: OOH
| 7  6      | 5  4        | 3  2           |
| --------- | ----------- | -------------- |
| R  R      | R  FRCGRAY  | R  PANEL TYPE  |
| Bit 1"()  | PANEL TYPE  |                |
00 = TFT panel
01 = Reserved
10 = STN panel. This setting enables FRC operation.
11 = Reserved
| Bit 2     | Reserved                                        |     |
| --------- | ----------------------------------------------- | --- |
| Bits 4-3  | FRC GRAY -Frame Rate Control Gray Level Select  |     |
00 = 16 levels
01 = 8 levels
10 = Reserved
11 = Reserved
| Bit 7-5  | Reserved  |     |
| -------- | --------- | --- |
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-29

86CM65 Dual Display Accelerator
83 Incorporated
Flat Panel FRC Tuning 1 Register (SR3AI
| Read/Write  |     | Address: 3C5H, Index 3AH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6  | 543  | 2   | 1   |
| ----- | ---- | --- | --- |
TUNING DATA 15-8
The actual value will be supplied by S3 for specific panels. This is the Most Signifi
cant Byte of the tuning data.
Flat Panel FRC Tuning 2 Register (SR3BI
| Read/Write  |     | Address: 3C5H, Index 3BH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6  | 543  | 2   | 1   |
| ----- | ---- | --- | --- |
TUNING DATA 7'{)
The actual value will be supplied by S3 for specific panels. This is the Least Signifi
cant Byte of the tuning value.
Flat Panel FRC Tuning 3 Register (SR3CI
| Read/Write  |     | Address: 3C5H, Index 3CH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6      | 5  4      | 3  2    | 1  0      |
| --------- | --------- | ------- | --------- |
| R  R      | R  R      | R  STN  | TUNING 3  |
| Bits 1-0  | TUNING 3  |         |           |
The actual value will be supplied by S3 for speCific panels.
| Bit 2  | STM -STN Test Mode  |     |     |
| ------ | ------------------- | --- | --- |
o
= Normal operation
1 = STN Test Mode
This test mode is reserved for factory testing.
| Bits 7-3  | Reserved  |     |     |
| --------- | --------- | --- | --- |
18-30 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorporated
Flat Panel Configuration Register (SR3D)
Read/Write Address: 3CSH, Index 3DH
Power-On Default: OOH
Bits 2-0 FP DATA FORMAT
000 = 16-bit STN; 1 pixel/clock TFT (9-,12-, 1S-or 18-bit)
001 = 8-bit STN; 1 pixel/clock TFT (24-bit)
010 = 24-bit STN; 2 pixels/clock TFT (2x9-bit, 2x12-bit, 2x1S, 2x18-bit)
All other values are reserved. The STN definition applies if SR39_1-0 = 10b and the
TFT definition applies if SR39_1-O = OOb.
Bit 3 CFGS -Pin Configuration Select for Flat Panel Data Signals
o
= Illegal value
1 = Pin configuration shown in Tables 11-1 and 11-2.
Note: This bit must be programmed to 1.
Bit 4 LPS -LP Stop (STN panels only)
o = LP and FPSCLK enabled during vertical blank
1 = LP and FPSCLK disabled during vertical blank
Bit 5 SCS -Shift Clock Stop (STN panels only)
0= FPSCLK enabled during the first line of vertical blanking
1 = FPSCLK disabled during the first line of vertical blanking
This bit is valid only if SR3D_4 = O.
Bit 6 FPDS -Flat Panel Data Drive Strength
o
= Drive strength is 6 mA at 3.3V or 8 mA at SV
1 = Drive strength is 12 mA at 3.3V or 16 mA at SV
This bit affects FPD[23:0), PFDE and FPPOL. FPSCLK drive strength is controlled by
SR3D3. This bit must be = 0 for 36-bit XGA panels.
Bit 7 SCDS-Shift Clock Drive Strength
o
= FPSCLK drive strength is 6 mA at 3.3V or 8 mA at SV
1 = FPSCLK drive strength is 12 mA at 3.3V or 16 mA at SV
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-31

86CM65 Dual Display Accelerator
S3 lnaorponted
Flat Panel Pin Configuration Register (SR40)
Read/Write Address: 3C5H, Index 40H
Power-On Default: OOH
Bit 0 Reserved
BIU-1 FPSCLK DELAY
Value = number of nanoseconds to delay FPSCLK
Bit 4 FPOFF -Flat Panel Data and Control Signals Low
o =
Normal operation for flat panel outputs
1 = Force all flat panel data and control signals to logic 0
Bit 5 SCM -Shift Clock Mask
o =
Allow the shift clock (FPSCLK) output to toggle during the non-display interval
1 = Force the shift clock (FPSCLK) output low during the non-display interval
The proper setting of this bit is panel-specific.
Bit 6 SCS -Shift Clock Select (TFT only)
o = Pixels are clocked on the falling edge of FPSCLK
1 = Pixels are clocked on both the rising and falling edge of FPSCLK
Not all TFT panels provide the double-edge clocking mode.
Bit 7 POL -Polarity Enable (TFT only)
o
= FPPOL pin output disabled
1 = FPPOL pin output enabled
Polarity is available for 18-and 24-bit 1 pixel/clock modes and 2x18-bit 2 pixels/clock
mode.
18-32 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

••
r
86CM65 Dual Display Accelerator
Flat Panel Power Sequence Control Register (SR41)
| Read/Write  | Address: 3C5H, Index 41 H  |     |
| ----------- | -------------------------- | --- |
Power-On Default: OOH
o
| 7  6      | 5  4                    | 1     |
| --------- | ----------------------- | ----- |
| STR       | R  R                    | R  R  |
| Bits 1-0  | Reserved                |       |
| Bit 2     | PDWN -Power Down Phase  |       |
o = FPVEE low to FP signals inactive and FP signals inactive to FPVDD low = 32 ms
1 = FPVEE low to FP signals inactive and FP signals inactive to FPVDD low = 128 ms
| Bit 3  | PUP -Power Up Phase  |     |
| ------ | -------------------- | --- |
o = FPVDD high to FP signals active and FP signals active to FPVEE high = 32 ms
1 = FPVDD high to FP signals active and FP signals active to FPVEE high = 128 ms
| Bits 5-4  | Reserved                       |     |
| --------- | ------------------------------ | --- |
| Bits 7-6  | STR -Standby Timer Resolution  |     |
00 = 1 second
01 = 1 minute
10 = 1 msec
11 = 64 msec
Flat Panel Power Management Control Register (SR42)
| Read/Write  | Address: 3C5H, Index 42H  |     |
| ----------- | ------------------------- | --- |
Power-On Default: OOH
3  2  o
R  R  R
| Bit 0  | Reserved                |     |
| ------ | ----------------------- | --- |
| Bit 1  | SSUS -Software Suspend  |     |
o
= Software suspend disabled
1 = Software suspend enabled
| Bits 3-2  | Reserved                |     |
| --------- | ----------------------- | --- |
| Bit 4     | HSTB -Hardware Standby  |     |
o
= Hardware standby disabled
1 = Hardware standby enabled
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-33

86CM65 Dual Display Accelerator
83lnaorponted
| Bit 5  | SSTB -Software Standby  |     |     |
| ------ | ----------------------- | --- | --- |
o = Software standby disabled
1 = Software standby enabled
The BIOS must set this bit to 1 after a power-on reset, program the desired mode and
then clear this bit to 0 to initiate a power-up sequence.
| Bits 7-6  | SOB TIMER -Suspend Debounce Timer  |     |     |
| --------- | ---------------------------------- | --- | --- |
00 =62.5 JlS
01 = 2 seconds
1x = Immediate (used for testing)
Flat Panel Standby Control Register (SR43)
| Read/Write  |     | Address: 3C5H, Index 43H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: 01H
o
| 7         | 5  4                   | 3  2  | 1   |
| --------- | ---------------------- | ----- | --- |
| R         | STANDBY TIMEOUT VALUE  |       |     |
| Bits 5-0  | STANDBY TIMEOUT VALUE  |       |     |
Value = number of units to count before Standby mode is entered
The type of unit (second or minute) is selected via bit 7 of this register. Note that the
default timeout value is 1 second.
| Bit 6  | ACT -Activity Enable  |     |     |
| ------ | --------------------- | --- | --- |
o = Normal standby mode
1 = Activity function enabled
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
Flat Panel Power Management Register (SR44)
Address: 3C5H, Index 44H
Read/Write
Power-On Default: OOH
o
| 7  6      | 5                 | 2    | 1   |
| --------- | ----------------- | ---- | --- |
| R  R      | R                 | R=O  |     |
| Bits 3-0  | Reserved = OOOOb  |      |     |
18-34 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorponted
| Bit 4  | STBP -Standby Pin  |     |     |
| ------ | ------------------ | --- | --- |
o = To cause entry to Standby, the STANDBY pin must go high (which starts the
Standby counter) and remain high until the idle power down state is reached
after the Standby counter expires. Standby is exited when the STANDBY pin
goes low. Hardware Standby must be enabled (SR42_4 = 1)
1 = The Standby counter begins counting when hardware Standby is enabled
(SR42_4  = 1). Each rising edge of the STANDBY pin resets the counter (if not in
Standby) or takes the system out of Standby. When the system reaches the idle
power up state after exiting Standby, the Standby counter begins recounting.
| Bits 7-5  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Flat Panel PLL Power Management Register (SR45)
| Read/Write  |     | Address: 3C5H, Index 45H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6       | 5  4     | 3  2     | 1  0     |
| ---------- | -------- | -------- | -------- |
| R  R       | R  R     | REFRESH  | PLLWAIT  |
| Bits 1"()  | PLLWAIT  |          |          |
00=2ms
01 =4 ms
10 =S ms
11 = 16 ms
This is the time from entering Suspend to powering-down of the PLLs and from leav
ing Suspend to powering-up of the PLLs.
| Bits 3-2  | REFRESH  |     |     |
| --------- | -------- | --- | --- |
00 = Normal (S ms)
01 = 16 ms slow refresh
10 = 64 ms slow refresh
11 = Self-refresh DRAM
Selections other than normal are used during Suspend. The DRAM must be able to
support the selected refresh type.
| Bits 7-4  | Reserved  |     |     |
| --------- | --------- | --- | --- |
EXTENDED SEQUENCER REGISTER DESCRIPTIONS  1S-35

86CM65 Dual Display Accelerator
53 Inccwporded
Flat Panel Power Management Status Register (SR46)
| Read Only  |     | Address: 3C5H, Index 46H  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
|           | 4                     | 3  2  1  |     |
| --------- | --------------------- | -------- | --- |
|           | R                     | R  R  R  | R   |
| Bits 4-0  | Reserved              |          |     |
| Bit 5     | STBS -Standby Status  |          |     |
o
= Not in Standby mode
1 = In Standby mode
| Bit 6  | IDPDN -Idle Power Down State  |     |     |
| ------ | ----------------------------- | --- | --- |
o  = Not in idle power down state
1 = In idle power down state
This is the state immediately after a panel power down sequence.
| Bit 7  | IDPUP -Idle Power Up State  |     |     |
| ------ | --------------------------- | --- | --- |
0= Not in idle power up state
1 = In idle power up state
This is the state immediately after a panel power up sequence.
CLUT Control Register (SR47)
| Read/Write  |     | Address: 3C5H, Index 47H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6      | 5  4         | 3  2              |     |
| --------- | ------------ | ----------------- | --- |
| R  R      | R  R         | R  R  CLUTSELECT  |     |
| Bits 1-0  | CLUT SELECT  |                   |     |
00 = CLUT1 and CLUT2 enabled and mirrored for CPU writes
01 = CLUT1 only for CPU writes and reads mapped at 3C7H, 3CaH, 3C9H
10 = CLUT2 only for CPU writes and reads mapped at 3C7H, 3CaH, 3C9H
11 = Reserved
| Bits 7-2  | Reserved  |     |     |
| --------- | --------- | --- | --- |
18-36 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
Icon Mode Register (SR48)
Read/Write Address: 3C5H, Index 48H
Power-On Default: OOH
7 654 3
R ICON MAP 2Y
Bit 0 lEN -Icon Enable
o = Hardware icon disabled
1 = Hardware icon enabled
Bit 1 IMOD -Icon Mode
o
= 4 opaque colors
1 = 3 opaque colors and 1 transparent color
When this bit is cleared to 0, the color of each icon pixel (2 bits/pixel) is defined as:
00 = Color 0
01 = Color 1
10 = Color 2
11 = Color 3
When this bit is set to 1, the color of each icon pixel (2 bits/pixel) is defined as:
00 = Color 0
01 = Color 1
10 = Color 2
11 = Transparent (the current frame buffer pixel is not overwritten)
The hardware icon colors are defined in SR49.
Bit 2 2X -Double X
o
= Horizontal size is 64 pixels
1 = Horizontal size is 128 pixels
If this bit is set to 1, each pixel is duplicated in the horizontal direction.
Bit 3 2Y -Double Y
o
= Vertical size is 64 pixels
1 = Vertical size is 128 pixels
If this bit is set to 1, each pixel is duplicated in the vertical direction.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-37

86CM65 Dual Display Accelerator
S3lnoorpol'llted
Bits 6-4 ICON MAP
000 = Select hardware icon map 0
001 = Select hardware icon map 1
010 = Select hardware icon map 2
011 = Select hardware icon map 3
100 = Select hardware icon map 4
101 = Select hardware icon map 5
110 = Select hardware icon map 6
111 = Select hardware icon map 7
The icon maps are located in contiguous memory starting at the location pro
grammed in SR4E.
Bit 7 Reserved
Icon Color Stack Register (SR49)
Read/Write Address: 3C5H, Index 49H
Power-On Default: Undefined
This register allows four 24 bits/pixel colors to be defined for the hardware icon. Twelve 8-bit in
dexed registers are stacked at this address. A read of SR48 resets the index to O. Each read or write
of this register increments the index by 1, so the entire content can be read/written via successive
accesses. The colors used for the icon are selected via SR48_1. Colors data for color depths other
than 24 bits/pixel use the appropriate number of low-order bits.
7 6 5 432 1 o
COLOR DATA
Bits 7-0 COLOR DATA
Index 0 = Color 0 low (blue) byte
Index 1 = Color 0 middle (green) byte
Index 2 = Color 0 high (red) byte
Index 3 =C olor 1 low (blue) byte
Index 4 = Color 1 middle (green) byte
Index 5 = Color 1 high (red) byte
Index 6 = Color 2 low (blue) byte
Index 7 = Color 2 middle (green) byte
Index 8 = Color 2 high (red) byte
Index 9 = Color 3 low (blue) byte
Index A = Color 3 middle (green) byte
Index B = Color 3 high (red) byte
18-38 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorporated
Icon X Position High Register (SR4A)
| Read/Write  |     | Address: 3C5H, Index 4AH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
| R  R  | R  R  | R     |       |
X POSITION HIGH
| Bits 1"()  | X POSITION HIGH  |     |     |
| ---------- | ---------------- | --- | --- |
Value = High order 3 bits of the icon horizontal coordinate
The low order bits are found in SR4B.
| Bits 7·2  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Icon X Position Low Register (SR4B)
| Read/Write  |     | Address: 3C5H, Index 4BH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 543  | 2   | 1  o  |
| ----- | ---- | --- | ----- |
X POSITION LOW
| Bits 7"()  | X POSITION LOW  |     |     |
| ---------- | --------------- | --- | --- |
Value = Low order 8 bits of the icon horizontal coordinate
The high order 3 bits are found in SR4A.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-39

••
r
86CM65 Dual Display Accelerator
83 Incorporated
Icon Y Position High Register (SR4C)
| ReadJWrite  |     | Address: 3C5H, Index 4CH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6      | 5  4             | 3  2                | 1  0  |
| --------- | ---------------- | ------------------- | ----- |
| R  R      | R  R             | R  Y POSITION HIGH  |       |
| Bits 1-0  | Y POSITION HIGH  |                     |       |
Value = High order 3 bits of the icon vertical coordinate
The low order bits are found in SR4D.
| Bits 7-2  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Icon Y Position Low Register (SR4D)
| ReadJWrite  |     | Address: 3C5H, Index 4DH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
o
| 7  6  | 543  | 2   | 1   |
| ----- | ---- | --- | --- |
Y POSITION LOW
| Bits 7-0  | Y POSITION LOW  |     |     |
| --------- | --------------- | --- | --- |
Value = Low order 8 bits of the icon vertical coordinate
The high order 3 bits are found in SR4C.
18-40 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

••
r
86CM65 Dual Display Accelerator
S3 Inoorporned
Icon Address Register (SR4EI
| Read/Write  | Address: 3C5H, Index 4EH  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: OOH
| 7  6  | 543  | 2  1  | o   |
| ----- | ---- | ----- | --- |
ICON ADDRESS
| Bits 7-0  | ICON ADDRESS  |     |     |
| --------- | ------------- | --- | --- |
Value = Base address in the frame buffer for the hardware icon maps
The address is specified in 8K increments if the memory size is 2 MBytes or less and
in 8K increments starting at the 2-MByte boundary if the memory size is 4 MBytes.
The selection of a specific icon map is made via SR48_6-4.
Dual-Scan STN Data Address Register (SR4f)
| Read/Write  | Address: 3C5H, Index 4FH  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: OOH
DD-STN DATA ADDRESS ADJUSTMENT
| Bits 7-0  | DD-STN DATA ADDRESS ADJUSTMENT  |     |     |
| --------- | ------------------------------- | --- | --- |
Value = Number of 8K units to reserve between the top of video memory and the
start of the STN data area.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-41

86CM65 Dual Display Accelerator
S3 __r poRted
Dual-8can STN Frame Buffer Size Low Register (SR50)
| Read/Write  |     | Address: 3C5H, Index 50H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
DD-STN FRAME BUFFER SIZE LOW
| Bits 7'()  | DD-STN FRAME BUFFER SIZE LOW  |     |     |
| ---------- | ----------------------------- | --- | --- |
Value = lower byte of the STN frame buffer size in quadwords
The STN frame buffer size in quadwords is calculated using the following equation:
Frame Buffer Size = Horizontal size (in quadwords) x 1/2 vertical size (in lines)
Horizontal Size = [(SR61+1) x 3 x 8/641 quadwords rounded up to the nearest integer.
Note that the value programmed in SR61 is in 8-pixel characters and data in the
frame buffer is 3 bits/pixel. An equivalent formula is:
Horizontal Size = horizontal resolution in pixels x 3/64 (rounded up).
1/2 Vertical Size = 1/2 [SR69 + 11 or:
1/2 Vertical Size = 1/2 vertical resolution in lines
Dual·Scan STN Frame Buffer Size High Register ISR51)
| Read/Write  |     | Address: 3C5H, Index 51H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6  | 543  | 2   | 1   |
| ----- | ---- | --- | --- |
DD-STN FRAME BUFFER SIZE HIGH
| Bits 7'()  | DD-STN FRAME BUFFER SIZE HIGH  |     |     |
| ---------- | ------------------------------ | --- | --- |
Value = upper byte of STN frame buffer size in quadwords
See SRSO for an explanation of how to determine the value to be programmed in this
register.
18-42 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorporatad
Flat Panel PWM Register (SR52)
Read/Write Address: 3C5H, Index 52H
Power-On Default: OOH
7 3 2
R PWM CLOCK DIVIDE R R
Bit 0 PWM -Pulse Width Modulation Enable
o
= PWM disabled
1 = PWM enabled
If the DRAM type is not 512Kx32 and this bit is set to 1, pin M17 acts as the PWM
signal.
Bit 1 PSC -PWM Source Clock Select
0= Generate PWM signal from the 14.31818 MHz reference clock
1 - Generate PWM signal from the PCI clock (SCLK)
Bits 3-2 Reserved
Bits 6-4 PWM CLOCK DIVIDE
000 = PWM source clock is not pre-divided
001 = PWM source clock is pre-divided by 1.5
010 = PWM source clock is pre-divided by 2
100 = PWM source clock is pre-divided by 3
All other values are reserved.
PWM clock frequency = PWM source clock/pre-divisor/256
The inversion of this is the PWM period used in the PWM duty cycle specification in
SR53.
Bit 7 Reserved
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-43

86CM65 Dual Display Accelerator
8a Incorporllted
Flat Panel PWM Duty Cycle Register (SR53)
| Read/Write  | Address: 3C5H, Index 53H  |     |
| ----------- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6  | 543  | 2  1  |
| ----- | ---- | ----- |
PWM DUTY CYCLE
| Bits 7'()  | PWM DUlY CYCLE  |     |
| ---------- | --------------- | --- |
Value =2 56 be/pi
where x = high time of the PWM signal and p = period of the PWM signal, both in
nanoseconds. The period is determined as explained for SR52_6-4. A programmed
value of OOH causes the PWM signal to be DC low. A programmed value of FFH
causes the PWM signal to be DC high.
Flat Panel Horizontal Compensation 1 Register (SR54)
| Read/Write  | Address: 3C5H, Index 54H  |     |
| ----------- | ------------------------- | --- |
Power-On Default: OOH
| 6   | 5  4  3  | 2  1  |
| --- | -------- | ----- |
0
| R          | R  HCE  GRAPH EXP                         | TEXT EXP  |
| ---------- | ----------------------------------------- | --------- |
| Bits 1'()  | TEXT EXP -Text Mode Horizontal Expansion  |           |
00 = Horizontal expansion disabled
01 = Horizontal expansion enabled up to a maximum expansion factor of 1.25.
10 = Reserved
11 = Horizontal expansion enabled up to the horizontal panel size. For VGA panels,
9-dot text modes will be forced to 8-dot text modes
The 11 b setting will normally be used unless the expansion causes the text to look
bad. In this case, the 01 setting can be used for panels larger than 800 columns to
limit the expansion and eliminate the undesirable visual effects.
| Bits 3·2  | GRAPH EXP -Graphics Mode Horizontal Expansion  |     |
| --------- | ---------------------------------------------- | --- |
00 = Horizontal expansion disabled
01 = Horizontal expansion enabled up to a maximum expansion factor of 1.25.
10 = Reserved
11 = Horizontal expansion enabled up to the horizontal panel size. For VGA panels,
9-dot text modes will be forced to 8-dot text modes
The 11 b setting will normally be used unless the expansion causes the text to look
bad. In this case, the 01 setting can be used for panels larger than 800 columns to
limit the expansion and eliminate the undesirable visual effects.
18-44 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S31ncorporated
Bit 4 HCE -Horizontal Centering Enable
o
= Horizontal centering disabled
1 = Horizontal centering enabled
Bits 6-5 Reserved
Bit 7 FPLG -Flat Panel Line Graphics Enable
0= The ninth dot of a text character (SR1_0 = 0) is the same color as the background
1 = Special line graphics character codes enabled
This bit performs the same function as AR10_2 in CRT mode.
Flat Panel Horizontal Compensation 2 Register (SR55)
Read/Write Address: 3C5H, Index 55H
Power-On Default: OOH
The bits in this register control enabling of horizontal expansion in specific text/graphics modes.
They are effective only if text mode horizontal expansion is enabled via SR54_1-0. Horizontal expan
sion for all other modes not controlled by these bits is controlled by SR54_3-0.
7 6 5
Bit 0 40C -40-character Text Mode Horizontal Expansion Enable
o
= Horizontal expansion disabled in 4O-character text mode
1 = Horizontal expansion enabled in 40-character text mode
This bit is effective only if text mode horizontal expansion is enabled via SR54_1-0.
Bit 1 BOC -BO-character Text Mode Horizontal Expansion Enable
o
= Horizontal expansion disabled in BO-character text mode
1 = Horizontal expansion enabled in BO-character text mode
This bit is effective only iftext mode horizontal expansion is enabled via SR54_1-0.
BIt 2 640C -640-column Graphics Mode Horizontal Expansion Enable
o
= Horizontal expansion disabled in 640-column graphics mode
1 = Horizontal expansion enabled in 640-column graphics mode
This bit is effective only if graphics mode horizontal expansion is enabled via
SR54_3-2.
Bit 3 BOOC -800-column Graphics Mode Horizontal Expansion Enable
o
= Horizontal expansion disabled in 800-column graphics mode
1 = Horizontal expansion enabled in BOO-column graphics mode
This bit is effective only if graphics mode horizontal expansion is enabled via
SR54_3-2.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-45

86CM65 Dual Display Accelerator
8a Inoorpo..-d
| Bit 4  | 1024C -1024-column Graphics Mode Horizontal Expansion Enable  |     |
| ------ | ------------------------------------------------------------- | --- |
0= Horizontal expansion disabled in 1024-column graphics mode
1 = Horizontal expansion enabled in 1024-column graphics mode
This bit is effective only if graphics mode horizontal expansion is enabled via
SR54_3-2.
| Bits 7-5  | Reserved  |     |
| --------- | --------- | --- |
Flat Panel Vertical Compensation 1 Register (SRS61
| Read/Write  | Address: 3CSH, Index 56H  |     |
| ----------- | ------------------------- | --- |
Power-On Default: OOH
| 7  6      | 5                                       | o   |
| --------- | --------------------------------------- | --- |
| R  R      | R                                       |     |
| Bits 1-0  | TEXT EXP -Text Mode Vertical Expansion  |     |
00 = Vertical expansion disabled
01 = Vertical expansion enabled up to a maximum of 480 lines
10 = Reserved
11 = Vertical expansion enabled up to the vertical panel size
The 11 b setting will normally be used unless the expansion causes the text to look
bad. In this case, the 01 setting can be used for panels larger than 480 lines to limit
the expansion and eliminate the undesirable visual effects.
| Bits 3-2  | GRAPH EXP -Graphics Mode Vertical Expansion  |     |
| --------- | -------------------------------------------- | --- |
00 = Vertical expansion disabled
01 = Vertical expansion enabled up to a maximum of 480 lines
10 = Reserved
11 = Vertical expansion enabled up to the horizontal panel size.
The 11 b setting will normally be used unless the expansion causes the text to look
bad. In this case, the 01 setting can be used for panels larger than 480 lines to limit
the expansion and eliminate the undesirable visual effects.
| Bit 4  | VCE -Vertical Centering Enable  |     |
| ------ | ------------------------------- | --- |
o
= Vertical centering disabled
1 = Vertical centering enabled
| Bits 7-5  | Reserved  |     |
| --------- | --------- | --- |
18-46 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
Sllncorpornod
Flat Panel Vertical Compensation 2 Register (SR57)
Read/Write Address: 3C5H. Index 57H
Power-On Default: OOH
The bits in this register control enabling of vertical expansion in specific text/graphics modes. Verti
cal expansion for all other modes not controlled by these bits is controlled by SR56_3-0.
Bit 0 350T -350-line Text Mode Vertical Expansion Enable
o
= Vertical expansion disabled in 350-line text mode
1 = Vertical expansion enabled in 350-line text mode
This bit is effective only if text mode vertical expansion is enabled via SR56_1-0.
Bit 1 200T -200/400-line Text Mode Vertical Expansion Enable
0= Vertical expansion disabled in 200/400-line text mode
1 = Vertical expansion enabled in 200/400-line text mode
This bit is effective only if text mode vertical expansion is enabled via SR56_1-0.
Bit 2 350G -350-line Graphics Mode Vertical Expansion Enable
o
= Vertical expansion disabled in 350-line graphics mode
1 = Vertical expansion enabled in 350-line graphics mode
Bit 3 200G -200/400-line Graphics Mode Vertical Expansion Enable
o
= Vertical expansion disabled in 200/400-line graphics mode
1 = Vertical expansion enabled in 200/400-line graphics mode
This bit is effective only if graphics mode vertical expansion is enabled via SR56_3-2.
Bit 4 480G -480-line Graphics Mode Vertical Expansion Enable
o
= Vertical expansion disabled in 480-line graphics mode
1 = Vertical expansion enabled in 480-line graphics mode
This bit is effective only if graphics mode vertical expansion is enabled via SR56_3-2.
Bit 5 600G -600-line Graphics Mode Vertical Expansion Enable
o
= Vertical expansion disabled in 600-line graphics mode
1 = Vertical expansion enabled in 600-line graphics mode
This bit is effective only if graphics mode vertical expansion is enabled via SR56_3-2.
Bit 6 768G -768-line Graphics Mode Vertical Expansion Enable
o
= Vertical expansion disabled in 768-line graphics mode
1 = Vertical expansion enabled in 768-line graphics mode
This bit is effective only if graphics mode vertical expansion is enabled via SR56_3-2.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-47

86CM65 Dual Display Accelerator
sa Incorporated
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
Flat Panel Horizontal Border Register (SR58)
| Read Only  |     | Address: 3C5H. Index 58H  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6  | 5  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
FP HORIZONTAL BORDER 7-0
| Bits 7-()  | FP HORIZONTAL BORDER 7-0  |     |     |
| ---------- | ------------------------- | --- | --- |
9-bit Value = number of character clocks per horizontal line not used by the video
image.
Bit 8 of this value is in SR59_0.
Flat Panel Horizontal Expansion Factor Register (SR59)
| Read Only  |     | Address: 3C5H. Index 59H  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7                    |                                          | 3  2  | 1       |
| -------------------- | ---------------------------------------- | ----- | ------- |
| R  HORIZ EXP FACTOR  |                                          | R  R  | R  HB8  |
| Bit 0                | HB8 -Flat Panel Horizontal Border Bit 8  |       |         |
Bits 7-0 are in SR5S.
| Bits 3-1  | Reserved          |     |     |
| --------- | ----------------- | --- | --- |
| Bits 6-4  | HORIZ EXP FACTOR  |     |     |
000 = panel size < image size
001 = 1 1I8x image size> panel size ~ image size
010 = illegal
011 = 1 1/4x image size> panel size ~ 1 1/8x image size
100 = 11/2x image size> panel size ~ 11/4x image size
101 = illegal
110 = 2x image size> panel size ~ 1 1/2x image size
111 = panel size ~ 2x image size
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
18-48 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
Flat Panel Vertical Border Register (SR5A)
| Read Only  |     | Address: 3C5H, Index 5AH  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
FP VERTICAL BORDER 7-0
| Bits 7-0  | FP VERTICAL BORDER 7-0  |     |     |
| --------- | ----------------------- | --- | --- |
9-bit Value = number of lines not used by the video image
Bit 8 of this value is SR5B_0.
Flat Panel Vertical Expansion Factor Register (SR5B)
| Read Only  |     | Address: 3C5H, Index 5BH  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: OOH
| Bit 0  | VB8 -Flat Panel Vertical Border Bit 8  |     |     |
| ------ | -------------------------------------- | --- | --- |
Bits 7-0 are in SR5A.
Bit 1 . VED -Vertical Expansion Detect
o  = No vertical expansion
1 = Automatic vertical expansion is being done or would be being done if enabled.
This bit is used only for test puposes.
| Bit 2  | VCD -Vertical Centering Detect  |     |     |
| ------ | ------------------------------- | --- | --- |
o
= No vertical centering
1 = Automatic vertical centering is being done (it must be enabled)
This bit is used only for test puposes.
| Bit 3  | LRI -Line Repeat Indicator  |     |     |
| ------ | --------------------------- | --- | --- |
o
= Current scan line will be repeated on the next scan line
1 = Current scan line will not be repeated on on the next scan line
This bit is used only for test puposes.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-49

86CM65 Dual Display Accelerator
83 Incorporated
Bits 7-4 VERT EXP FACTOR
0000 = No expansion
0001 = Illegal
0010 = Double every third line
0011 = Expand 16-line text to 19-1ine text
0100 = Double every fifth line
0101 = Expand 14-line text to 19-1ine text
0110 = Double every fourth line
0111 = Double every second line
1000 = Double every line
1001 = Double three lines and triple the fourth, repeat
1010 = Expand 8-line text to 19-1ine text
1011 = Double four lines and triple the fifth, repeat
1100 = Double two lines and triple the third, repeat
1101 = Illegal
1110 = Double one line and triple the second, repeat
1111 = Quadruple every line
Flat Panel Display Enable Position Control Register (SR5C)
Read/Write Address: 3C5H, Index 5CH
Power-On Default: Undefined
The fields in this register are effective only for Enhanced modes (8 bits/pixel or higher). The BIOS
should program this register to 77H on reset.
7 6 5 4 3 2 1 o
FPDEC2 FPDEC1
Bits 3-0 FPDEC1 -Flat Panel Display Enable Control 1
value = starting position of the horizontal and vertical display enables for Controller 1
This field should normally be left at its default value of 0111 b. A smaller value causes
the display enables to be moved earlier by the difference between the programmed
value and the nominal value. A larger value causes the display enables to be moved
later by the difference between the programmed value and the nominal value. Each
difference unit causes a shift of 1 DClK.
Bits 7-4 FPDEC2 -Flat Panel Display Enable Control 2
value = starting pOSition of the horizontal and vertical display enables for Controller 2
This field should normally be left at its default value of 0111 b. A smaller value causes
the display enables to be moved earlier by the difference between the programmed
value and the nominal value. A larger value causes the display enables to be moved
later by the difference between the programmed value and the nominal value. Each
difference unit causes a shift of 1 DClK.
18-50 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

••
r
86CM65 Dual Display Accelerator
53 Incorporllted
Flat Panel/CRT Sync Position Control Register (SR5DI
| Read/Write  |     | Address: 3C5H, Index 5DH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: 77H
The fields in this register are effective only for Enhanced modes (8 bits/pixel or higher). The BIOS
should program this register to 77H on reset.
o
| 7  6       | 5  4                                      | 3  2       | 1   |
| ---------- | ----------------------------------------- | ---------- | --- |
| FP/CRTSC2  |                                           | FP/CRTSC1  |     |
| Bits 3-0   | FP/CRTSC1 -Flat Panel/CRT Sync Control 1  |            |     |
value = starting position of the horizontal and vertical syncs for Controller 1
This field should normally be left at its default value of 0111 b. A smaller value causes
the syncs to be moved earlier by the difference between the programmed value and
the nominal value. A larger value causes the syncs to be moved later by the differ
ence between the programmed value and the nominal value. Each difference unit
causes a shift of 1 DClK.
| Bits 7-4  | FP/CRTSC2 -Flat Panel Sync Control 2  |     |     |
| --------- | ------------------------------------- | --- | --- |
value = starting position of the horizontal and vertical display enables for Controller 2
This field should normally be left at its default value of 0111 b. A smaller value causes
the syncs to be moved earlier by the difference between the programmed value and
the nominal value. A larger value causes the syncs to be moved later by the differ
ence between the programmed value and the nominal value. Each difference unit
causes a shift of 1 DClK.
FIFO Control Register (SR5F)
| Read/Write  | Address: 3C5H, Index 5FH  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: OOH
|     | 5   |     | o   |
| --- | --- | --- | --- |
7  6
| R  R   | R                  |     | C1F  |
| ------ | ------------------ | --- | ---- |
| Bit 0  | Controller 1 FIFO  |     |      |
o = Normal operation
1 = Controller 1 FIFO memory access requests disabled
This bit is used only for test purposes. When set, CR22_7 must also be set for Control
ler 1.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-51

86CM65 Dual Display Accelerator
sa Incorporated
| Bit 1  | C2F -Controller 2 FIFO  |     |     |
| ------ | ----------------------- | --- | --- |
o  = Normal operation
1 = Controller 2 FIFO memory access requests disabled
This bit is used only for test purposes. When set, CR22_7 must also be set for Control
ler 2.
| Bit 2  | SWF -STN Write FIFO  |     |     |
| ------ | -------------------- | --- | --- |
o  = Normal operation
1 = STN write FIFO memory access requests disabled
This bit is used only for test purposes.
| Bit 3  | SRF -STN Read FIFO  |     |     |
| ------ | ------------------- | --- | --- |
o
= Normal operation
1 = STN read FIFO memory access requests disabled
This bit is used only for test purposes.
| Bit 4  | C2FR -Controller 2 FIFO Rate  |     |     |
| ------ | ----------------------------- | --- | --- |
o = 2 MCLK reads for Controller 2 FIFO
1 = 2 MCLK reads for Controller 2 FIFO
This bit is set to 1 when 1-cycle EDO operation is selected (CR36_3-2 = OOb)
| Bits 7-5  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Flat Panel Horizontal Total Register (SR60)
| Read/Write  |     | Address: 3C5H, Index 60H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 5   | 3  2  | o   |
| ----- | --- | ----- | --- |
|       | 4   | 1     |     |
FP HORIZONTAL TOTAL 7-0
| Bits 7-0  | FP HORIZONTAL TOTAL 7-0  |     |     |
| --------- | ------------------------ | --- | --- |
9-bit Value = (number of character clocks in one scan line) -5
A character clock is always 8 FPSCLKs (FP dot clocks). The programmed value is inde
pendent of horizontal compensation and applies to all modes. Bit 8 of this value is
SR66_0.
18-52 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Inoorporated
Flat Panel Horizontal Panel Size Register (SR61)
| Read/Write  |     | Address: 3C5H, Index 61H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
FP HORIZONTAL PANEL SIZE 7-(J
| Bits 7-0  | FP HORIZONTAL PANEL SIZE 7-0  |     |     |
| --------- | ----------------------------- | --- | --- |
9-bit Value = [horizontal panel resolution in character clocks] -1
A character clock is always 8 FPSCLKs (FP dot clocks). For example, for a VGA panel
with a horizontal resolution of 640, the programmed value would be the binary
equivalent of [640/8]-1. The programmed value is independent of horizontal compen
sation and applies to all modes. Bit 8 of this value is SR66_1.
Flat Panel Horizontal Blank Start Register (SR62)
| Read/Write  |     | Address: 3C5H, Index 62H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
o
| 7  6  | 5  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
FP HORIZONTAL BLANK START 7-0
| Bits 7-0  | FP HORIZONTAL BLANK START 7-0  |     |     |
| --------- | ------------------------------ | --- | --- |
9-bit Value = character clock counter value at which blanking begins
A character clock is always 8 FPSCLKs (FP dot clocks). The programmed value is inde
pendent of horizontal compensation and applies to all modes. Bit 8 of this value is
SR66_2.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 18-53

86CM65 Dual Display Accelerator
S3 Incorporated
Flat Panel Horizontal Blank End Register (SR63)
Read/Write Address: 3C5H, Index 63H
Power-On Default: Undefined
7 6 5 43210
R R R FP HORIZONTAL BLANK END 4-0
Bits 4.() FP HORIZONTAL BLANK END 4-0
6-bit Value = least significant 6 bits of the character clock counter value at which
blanking ends
A character clock is always 8 FPSCLKs (FP dot clocks). To obtain this value, add the
desired width of the vertical blanking pulse in character clocks to the value in the FP
Horizontal Blank Start register, also in character clocks. The 5 least significant bits of
this value are programmed into this field. The programmed value is independent of
horizontal compensation and applies to all modes. Bit 5 ofthis value is SR65_7. If the
horizontal blank period is more than 64 character clocks, then SR66_3 must be set to
1.
Bits 7-5 Reserved
, Flat Panel Horizontal Sync Start Register (SR64)
Read/Write Address: 3C5H, Index 64H
Power-On Default: Undefined
7 654 3 2 1 o
FP HORIZONTAL SYNC START 7-0
Bits 7-0 FP HORIZONTAL SYNC START 7-0
8-bit Value = character clock counter value at which the horizontal sync pulse (LP) be
comes active
A character clock is always 8 FPSCLKs (FP dot clocks). The programmed value is inde
pendent of horizontal compensation and applies to all modes. Bit 8 of this value is
SR66_4. '
18-54 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorporated
Flat Panel Horizontal Sync End Register (SR65)
| Read/Write  | Address: 3C5H, Index 65H  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: Undefined
| Bits 4-0  | FP HORIZONTAL SYNC END 4-0  |     |     |
| --------- | --------------------------- | --- | --- |
5-bit Value = least significant 5 bits of the character clock counter value at which the
horizontal sync pulse (LP) becomes inactive
A character clock is always 8 FPSCLKs (FP dot clocks). To obtain this value, add the
desired width of the horizontal sync pulse in character clocks to the value in the FP
Horizontal Sync Start register. The 5 least significant bits of this value are pro
grammed into this field. The programmed value is independent of horizontal compen
sation and applies to all modes. If the horizontal sync period is more than 32
character clocks, SR66_5 must be set to 1.
| Bits 6-5  | Reserved                           |     |     |
| --------- | ---------------------------------- | --- | --- |
| Bit 7     | BE5 -FP Horizontal Sync End Bit 5  |     |     |
Bits 4-0 are in this register.
Flat Panel Horizontal Overflow Register (SR66)
| Read/Write  | Address: 3C5H, Index 66H  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: Undefined
| 7  6   | I                          | I  H~ssl  | 0    |
| ------ | -------------------------- | --------- | ---- |
| R  R   | H:E51 H:ssl H!P            | H:Ssl     | HTS  |
| Bit 0  | FP Horizontal Total Bit 8  |           |      |
Bits '-0 are in SR60.
| Bit 1  | FP Horizontal Panel Size Bit 8  |     |     |
| ------ | ------------------------------- | --- | --- |
Bits '-0 are in SR61.
| Bit 2  | FP Horizontal Blank Start Bit 8  |     |     |
| ------ | -------------------------------- | --- | --- |
Bits '-0 are in SR62.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS  18-55

86CM65 Dual Display Accelerator
sa Incorporated
| Bit 3  | FP Horizontal Blank Period  |     |
| ------ | --------------------------- | --- |
o = Flat panel horizontal blank period is 64 character clocks or less
1 = Flat panel horizontal blank period is greater than 64 character clocks
| Bit 4  | FP Horizontal Sync Start Bit 8  |     |
| ------ | ------------------------------- | --- |
Bits 7-0 are in SR64.
| Bit 5  | FP Horizontal Sync Period  |     |
| ------ | -------------------------- | --- |
o  = Flat panel horizontal sync period is 32 character clocks or less
1 = Flat panel horizontal sync period is greater than 32 character clocks
| Bits 7-6  | Reserved  |     |
| --------- | --------- | --- |
Flat Panel Vertical Total Register (SR68)
| Read/Write  | Address: 3C5H, Index 6SH  |     |
| ----------- | ------------------------- | --- |
Power-On Default Undefined
o
| 7  6  | 543  | 2  1  |
| ----- | ---- | ----- |
FPVERTICAL TOTAL 7-0
| Bits 7'()  | FP VERTICAL TOTAL 7-0  |     |
| ---------- | ---------------------- | --- |
11-bit Value = [number of scan lines from one vertical sync pulse (FLM) active to the
next vertical sync pulse active) -2
The programmed value is independent of vertical compensation and applies to all
modes. Bits 10-8 ofthis value are SR6E_2-0.
18-56 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorporated
Flat Panel Vertical Panel Size Register (SR69)
| Read/Write  | Address: 3C5H, Index 69H  |     |
| ----------- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 54321  | o   |
| ----- | ------ | --- |
FP VERTICAL PANEL SIZE 7-0
| Bits 7-0  | FP VERTICAL PANEL SIZE 7-0  |     |
| --------- | --------------------------- | --- |
11-bit Value = [vertical panel resolution in scan IinesJ-1
For example, for a VGA panel with a vertical resolution of 480, the programmed value
would be the binary equivalent of 480 -1. The programmed value is independent of
vertical compensation and applies to all modes. Bits 10-8 of this value are SR6E_6-4.
Flat Panel Vertical Blank Start Register (SR6A)
| Read/Write  | Address: 3C5H, Index 6AH  |     |
| ----------- | ------------------------- | --- |
Power-On Default: Undefined
o
| 7  6  | 5  432  | 1   |
| ----- | ------- | --- |
FP VERTICAL BLANK START 7-0
| Bits 7-0  | FP VERTICAL BLANK START 7-0  |     |
| --------- | ---------------------------- | --- |
11-bit Value = scan line counter value at which blanking begins
The programmed value is independent of vertical compensation and applies to all
modes. Bits 10-8 of this value are SR6F _2-0.
EXTENDED SEQUENCER REGISTER DESCRIPTIONS  18-57

86CM65 Dual Display Accelerator
S3 Incorporeted
Flat Panel Vertical Blank End Register (SR6B)
| Read/Write  |     | Address: 3C5H, Index 6BH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default Undefined
| 7  6  | 543  | 2   | 1  o  |
| ----- | ---- | --- | ----- |
FP VERTICAL BLANK END 7-0
| Bits 7'()  | FP VERTICAL BLANK END 7-0  |     |     |
| ---------- | -------------------------- | --- | --- |
Value = least significant 8 bits of the scan line counter value at which blanking ends
To obtain this value, add the desired width of the vertical blanking pulse in scan lines
to the value in the FP Vertical Blank Start register, also in scan lines. The 8 least sig
nificant bits of this value are programmed into this field. The programmed value is in
dependent of vertical compensation and applies to all modes.
Flat Panel Vertical Sync Start Register (SR6C)
| Read/Write  |     | Address: 3C5H, Index 6CH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
o
| 7  6  | 5  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
FP VERTICAL SYNC START 7-0
| Bits 7'()  | FP VERTICAL SYNC START 7-0  |     |     |
| ---------- | --------------------------- | --- | --- |
11-bit Value = [scan line counter value at which the vertical sync pulse (FLM) be
comes active]-1
The programmed value is independent of vertical compensation and applies to all
modes. Bits 10-8 of this value are SR6F _6-4.
18-58 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorpora. ...
Flat Panel Vertical Sync End Register (SR6D)
| ReadJWrite  |     | Address: 3C5H, Index 6DH  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: Undefined
|           |                           | I                            |       | I     |
| --------- | ------------------------- | ---------------------------- | ----- | ----- |
|           | 6  5                      |                              | I  I  | I     |
| 7         |                           | 4                            | 3  2  | 1  0  |
| R         | R  R                      | R  FP VERTICAL SYNC END 3-0  |       |       |
| Bits 3-0  | FP VERTICAL SYNC END 3-0  |                              |       |       |
4-bit Value = least significant 4 bits of the character clock counter value at which the
vertical sync pulse (FLM) becomes inactive
To obtain this value, add the desired width of the vertical sync pulse in scan lines to
the value in the FP Vertical Sync Start register, also in scan lines. The 4 least signifi
cant bits of this value are programmed into this field. The programmed value is inde
pendent of vertical compensation and applies to all modes.
| Bits 7-4  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
Flat Panel Vertical Overflow 1 Register (SR6E)
| ReadJWrite  |     | Address: 3C5H, Index 6EH  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: Undefined
|           | 5                                    | 4   | 3          |       |
| --------- | ------------------------------------ | --- | ---------- | ----- |
| 7         | 6                                    |     | 2          | 1  0  |
| R         | VPS10-8                              |     | R  VT10-8  |       |
| Bits 2-0  | VT10-S -FP Vertical Total Bits 10-8  |     |            |       |
Bits 7-0 are in SR6S.
|           | Bit 3  Reserved                            |     |     |     |
| --------- | ------------------------------------------ | --- | --- | --- |
| Bits 6-4  | VPS10-S -FP Vertical Panel Size Bits 10-S  |     |     |     |
Bits 7-0 are in SR69.
|     | Bit 7  Reserved  |     |     |     |
| --- | ---------------- | --- | --- | --- |
EXTENDED SEQUENCER REGISTER DESCRIPTIONS 1S-59

86CM65 Dual Display Accelerator
sa Inoorporated
Flat Panel Vertical Overflow 2 Register (SR6F)
| ReadJWrite  |     | Address: 3C5H, Index 6FH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6      | 5  4                                        | ·3  2  | 1  0     |
| --------- | ------------------------------------------- | ------ | -------- |
| R         | VSS10-8                                     | R      | VBS10-8  |
| Bits2"()  | VBS10-8 -FP Vertical Blank Start Bits 10-8  |        |          |
Bits 7-0 are in SR6A.
| Bit3      | Reserved                                   |     |     |
| --------- | ------------------------------------------ | --- | --- |
| Bits 6-4  | VSS10-8 -FP Vertical Sync Start Bits 10-8  |     |     |
Bits 7-0 are in SR6C.
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
18-60 EXTENDED SEQUENCER REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorpor.ted
Section 19: Extended CRTC Register Descriptions
The 86CM65 has additional registers to extend the functions beyond VGA. These registers are located
in CRT Controller address space at locations not used by the IBM® VGA. All of these registers are
read/Write protected at power-up by hardware reset. In order to read/write these registers, CR38 and/or
CR39 must be loaded with a changed key pattern (see the register descriptions). The registers will
remain unlocked until the key pattern is reset by altering a significant bit. If a register or bit is noted
as paired, there are two identical registers or bit at that address, with access controlled via SR26. One
register or bit is used by controller 1 and the other for controller 2. If a register or bit is noted as shared,
there is a single register or bit shared by controller 1 or controller 2.
In the following register descriptions, 'R' stands for reserved (write =0, read = undefined). See Appendix
A for a table listing each register in this section and its page number.
CRT Test 1 Register (CTR22)
Read/Write Address: 3?5H, Index 22H
Power-On Default: OOH Paired
This register is accessible at Index 22H (instead of CR22) when CR39 = A5H.
o
T~D I 6 5 4 3 2 1
R R R R R R R
Bits 6-0 Reserved
Bit 7 TDD -Test DAC Data
o
= Normal operation
1 =2 4 bits of data are provided to the DAC by internal counters.
This bit must be set for the appropriate controller when either SR5F_ 0 = 1 (disabling
Controller 1 frame buffer accesses) or SR5F _1 = 1 (disabling Controller 2 frame buffer
accesses).
EXTENDED CRTC REGISTER DESCRIPTIONS 19-1

86CM65 Dual Display Accelerator
S3 Incorporated
Device ID High Register (CR2D)
| Read Only  |     | Address: 375H, Index 2DH  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: BSH
This register should contain the same value as the upper byte of the PCI Device ID (Index 02H) register.
| 7  6  | 543  | 2  1  | o   |
| ----- | ---- | ----- | --- |
CHIP ID HIGH
Bits 7-0
CHIP ID HIGH
value =B BH (hardwired)
Device ID Low Register (CR2EI
| Read Only  |     | Address: 375H, Index 2EH  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: 12H
o
| 7  6  | 543  | 2  1  |     |
| ----- | ---- | ----- | --- |
CHIPID LOW
| Bits 7-0  | CHIP ID LOW  |     |     |
| --------- | ------------ | --- | --- |
value = 12H (hardwired)
Revision Register (CR2F)
Read Only
Address: 375H, Index 2FH
Power-On Default: xxH
o
| 7  6  | 5  4  | 3  2  |     |
| ----- | ----- | ----- | --- |
REVISION LEVEL
| Bits 7-0  | REVISION LEVEL  |     |     |
| --------- | --------------- | --- | --- |
This value will vary by chip revision.
19-2 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorpon.ed
Chip ID/REV Register (CR30)
| Read Only  |     | Address: 3?5H, Index 30H  |     |
| ---------- | --- | ------------------------- | --- |
Power-On Default: E1H
When the software detects EH in the upper nibble of this register, it should then use CR2D, CR2E and
CR2F for chip ID information.
| 7  6    | 5  4  | 3  2             | 1  o  |
| ------- | ----- | ---------------- | ----- |
| CHIPID  |       | REVISION STATUS  |       |
Bits 7~ CHIP ID AND REVISION STATUS
Memory Configuration Register (CR31)
| Read/Write  |     | Address: 375H, Index 31H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6    | 5  4                                     | 3  2      | 1  0     |
| ------- | ---------------------------------------- | --------- | -------- |
| HST     |                                          | ENH  VGA  | SCRN     |
| R  DFF  | R  R                                     | MAP  168  | 2.PG  R  |
| Bit 0   | Reserved                                 |           |          |
| Bit 1   | SCRN 2.PG -Enable Two-Page Screen Image  |           |          |
o  = Normal Mode
1 = Enable 2K x 1K  x 4 map image screen for 1024 x 768 or 800 x 600 screen
resolution, or 2K x 512 x 8 map image screen for 640 x 480 screen resolution
| Bit 2  | VGA 168 -Enable VGA 16-bit Memory Bus Width  |     |     |
| ------ | -------------------------------------------- | --- | --- |
o
= 8-bit memory bus operation
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
Note: This bit is forced to 1 for Controller 2 operation.
| Bits 5-4  | Reserved  |     |     |
| --------- | --------- | --- | --- |
EXTENDED CRTC REGISTER DESCRIPTIONS  19-3

86CM65 Dual Display Accelerator
83 Incorpontod
| Bit 6  | HST DFF -Enable High Speed Text Display Font Fetch Mode  |     |     |
| ------ | -------------------------------------------------------- | --- | --- |
o = Normal font access mode
1 = Enable high speed text display
Setting this bit to 1 is only required for DCLK rates greater than 40 MHz. See bit 5 of
CR3A.
Note: This bit is paired.
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
Backward Compatibility 1 Register (CR32)
| Read/Write  |     | Address: 375H, Index 32H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6  | 5  4  | 3  2  | 1  0  |
| ----- | ----- | ----- | ----- |
| VGA   | INT   |       |       |
R
| R  FXPG  | R  EN  | FCCH  | R  R  |
| -------- | ------ | ----- | ----- |
Bits 1~ Reserved
| Bit 2  | FCCH -Force Character Clock High  |     |     |
| ------ | --------------------------------- | --- | --- |
o
= Normal character clock
1 = Force horizontal timings to be based on undivided DCLK even if SR1_3 is set to 1
to divide DCLK by 2
| Bit 3  | Reserved                  |     |     |
| ------ | ------------------------- | --- | --- |
| Bit 4  | INT EN -Interrupt Enable  |     |     |
o
= All interrupt generation disabled
1 = Interrupt generation enabled
| Bit 5  | Reserved                                    |     |     |
| ------ | ------------------------------------------- | --- | --- |
| Bit 6  | VGA FXPG -Use Standard VGA Memory Wrapping  |     |     |
0= Memory accesses extending past a 256K boundary do not wrap
1 = Memory accesses extending past a 256K boundary wrap at the boundary
The standard 256K VGA memory page always ends on a natural 256K boundary and
accesses beyond this boundary will wrap. If the starting address is moved via bits 4-0
of CR69 (or bits 5-4 of CR31 and bits 1-0 of CR51l, the 256K page may not end on a
256K boundary and accesses past the boundary will not wrap. This is the case when
this bit is cleared to O. For standard VGA compatibility when the page base address is
moved, this bit is set to 1 to cause wrapping at a 256K boundary.
Note: This bit is forced to 0 for Controller 2 operation.
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
19-4 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorporated
Backward Compatibility 2 Register (CR33)
| Read/Write  |     | Address: 375H. Index 33H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6     | 5  4                                                                   | 3  2     | 1  0    |
| -------- | ---------------------------------------------------------------------- | -------- | ------- |
| LOCK     | BDR  LOCK VCLK=                                                        |          | DIS     |
| R  PLTW  | SEL  DACW                                                              | -DCK  R  | VDE  R  |
| Bit 0    | Reserved                                                               |          |         |
| Bit 1    | DIS VDE -Disable Vertical Display End Extension Bits Write Protection  |          |         |
o  = VDE protection enabled
1 = Disables the write protect setting of the bit 7 of CR11 on bits 1 and 6 of CR7
| Bit 2  | Reserved                            |     |     |
| ------ | ----------------------------------- | --- | --- |
| Bit 3  | VCLK = -DCK -VCLK is Inverted DCLK  |     |     |
o  = VCLK is determined by other bit settings
1 = VCLK is forced to inverted DCLK
Note: This bit is paired.
| Bit 4  | LOCK DACW -Lock RAMDAC Writes  |     |     |
| ------ | ------------------------------ | --- | --- |
o = Enable writes to RAMDAC registers
1 = Disable writes to RAMDAC registers
Note: This bit is paired.
| Bit 5  | BDR SEL -Blank/Border Select  |     |     |
| ------ | ----------------------------- | --- | --- |
o
= BLANK active time is defined by CR2 and CR3
1 = BLANK is active during entire display inactive period (no border)
Note: This bit is paired.
| Bit 6  | LOCK PL TW -Lock Palette/Border Color Registers  |     |     |
| ------ | ------------------------------------------------ | --- | --- |
o
= Unlock Palette/Border Color registers
1 = Lock Palette/Border Color registers
Note: This bit is paired.
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
EXTENDED CRTC REGISTER DESCRIPTIONS  19-5

86CM65 Dual Display Accelerator
53 InoorporlittHI
Backward Compatibility 3 Register (CR34)
| Read/Write  |     | Address: 3?5H, Index 34H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
| 7  6     | 5  4                           | 3  2    | 1    | 0    |
| -------- | ------------------------------ | ------- | ---- | ---- |
| lOCK     | lOCK  ENB                      | PCI     | PCI  | PCI  |
| ClKS  R  | 8/9D  SFF                      | R  RET  | ABT  | SNP  |
| Bit 0    | PCI SNP -PCI DAC snoop method  |         |      |      |
o = Handling of PCI master aborts and retries during DAC cycles controlled by bits 1
and 2 ofthis register
1 = PCI master aborts and retries are not handled during DAC cycles
| Bit 1  | PCI ABT -PCI master aborts during DAC cycles  |     |     |     |
| ------ | --------------------------------------------- | --- | --- | --- |
o
= PCI master aborts handled during DAC cycles
1 = PCI master aborts not handled during DAC cycles
Bit 0 of this register must be cleared to 0 for this bit to be effective.
| Bit 2  | PCI RET -PCI retries during DAC cycles  |     |     |     |
| ------ | --------------------------------------- | --- | --- | --- |
o
= PCI retries handled during DAC cycles
1 = PCI retries not handled during DAC cycles
Bit 0 of this register must be cleared to 0 for this bit to be effective.
| Bit 3  | Reserved                                           |     |     |     |
| ------ | -------------------------------------------------- | --- | --- | --- |
| Bit 4  | ENB SFF -Enable Start Display FIFO Fetch Register  |     |     |     |
o = Start Display FIFO Fetch register (CR3B) disabled
1 = Start Display FIFO Fetch register (CR3B) enabled
Note: This bit is paired.
| Bit 5  | lOCK B!9D -lock 8/9 Dots  |     |     |     |
| ------ | ------------------------- | --- | --- | --- |
0= Bit 0 of SR1 is unlocked
1 = Bit 0 of SR1 is locked
This bit locks/unlocks selection of either an B dot or 9 dot character clock.
| Bit 6  | Reserved                      |     |     |     |
| ------ | ----------------------------- | --- | --- | --- |
| Bit 7  | lOCK ClKS -lock Clock Select  |     |     |     |
o
= Bits 3-2 of 3C2H are unlocked
1 = Bits 3-2 of 3C2H are locked
This bit lockS/unlocks selection of the the DClK frequency.
19-6 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Incorporated
CRT Register Lock Register (CR35)
| Read/Write             |                                              | Address: 375H, Index 35H  |       |
| ---------------------- | -------------------------------------------- | ------------------------- | ----- |
| Power-On Default: OOH  |                                              | Paired                    |       |
| 7                      | 6  5  4                                      | 3  2                      | 1  0  |
| LOCK  LOCK             | LOCK  LOCK                                   |                           |       |
| CR12  CR1              | HTMG  VTMG                                   | R  R                      | R  R  |
| Bits 3-0               | Reserved                                     |                           |       |
| Bit 4                  | °LO CK VTMG -Lock Vertical Timing Registers  |                           |       |
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
| Bit 5  | LOCK HTMG -Lock Horizontal Timing Registers  |     |     |
| ------ | -------------------------------------------- | --- | --- |
0= Horizontal timing registers are unlocked
1 = The following horizontal timing registers are locked:
CROO
. CR1
CR2
CR3
CR4
CR5
CR17 (bit 2)
All these registers (except bit 2 of CR17) are also locked by bit 7 of the Vertical Re
trace End register (CR11).
| Bit 6  | °LO CK CR1  |     |     |
| ------ | ----------- | --- | --- |
= CR1 and 3C2H_6 unlocked
1 = CR1 and 3C2H_6 locked
| Bit 7  | LOCK CR12  |     |     |
| ------ | ---------- | --- | --- |
0= CR12 and 3C2H_7 unlocked
1 = CR12 and 3C2H310cked
EXTENDED CRTC REGISTER DESCRIPTIONS 19-7

86CM65 Dual Display Accelerator
83 Incorporated
Configuration 1 Register (CR36)
Read/Write* Address: 315H, Index 36H
Power-On Default: Depends on Strapping
* Bits 1-0 are read only. The other bits can be written only after OA5H is written to CR39.
This register samples the reset state from PO bus pins [7:0J. These pins have internal' pull-downs and
their states are inverted, so non-reserved register bits will default to 1 if the corresponding pin is not
pulled up. Other configuration strapping bits are found in CR37 and CR68 and CR6F.
o
765 4 3 2 1
MEM SIZE R MEMTYPE R R
Bits 1-0 Reserved
Bit 3-2 MEM TYPE
00 = 1-cycle Extended Data Out (EDO) operation
01 = Reserved
10 = 2-cycle EDO mode
11 = Fast page mode
Bit 4 Reserved
Bits 7-5 MEM SIZE
000 = 4 MBytes (valid only for 512Kx32 DRAMs)
100 = 2 MBytes
110 = 1 MByte (valid only for 256Kx16 DRAMs)
All other values are reserved. These PD bits should not be strapped, as they are over
written by the BIOS after boot up.
19-8 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
sa Incorporated
Configuration 2 Register (CR37)
| Read/Write*  |     | Address: 375H, Index 37H  |     |
| ------------ | --- | ------------------------- | --- |
Power-On Default: Depends on Strapping
* These bits can be written only after OA5H is written to CR39.
This register samples the reset state from PO bus pins [15:7]. These pins have internal pull-downs and
their states are inverted, so non-reserved register bits will default to 1 if the corresponding pin is not
pulled up. Other configuration strapping bits are found in CR36, CR68 and CR6F.
o
| 7  6        | 5  4               | 3  2   | 1      |
| ----------- | ------------------ | ------ | ------ |
| PANEL TYPE  | R                  | CS  R  | BS  R  |
| Bit 0       | Reserved           |        |        |
| Bit 1       | BS -Boundary Scan  |        |        |
o = Boundary scanning enabled (allows testing for bad solder connections. See
Section 5.)
1 = Boundary scanning disabled (normal operation)
| Bit 2  | Reserved          |     |     |
| ------ | ----------------- | --- | --- |
| Bit 3  | CS -Clock Select  |     |     |
o  = Use external DCLK and MCLK (test purposes only)
1 = Use internal DCLK, MCLK
| Bits 4    | Reserved    |     |     |
| --------- | ----------- | --- | --- |
| Bits 7·5  | PANEL TYPE  |     |     |
OEMs can strap PD[15:13] to allow identification of up to 8 different panel types. The
coding used is defined by each OEM.
EXTENDED CRTC REGISTER DESCRIPTIONS  19-9

86CM65 Dual Display Accelerator
83 Incorporeteti
Register Lock 1 Register (CR3S)
| Read/Write             |     | Address: 315H, Index 38H  |     |
| ---------------------- | --- | ------------------------- | --- |
| Power-On Default: OOH  |     | Shared                    |     |
Loading 01xx10xx (e.g., 48H) into this register unlocks the extended CRTC registers from CR2D through
CR3F for read/writes. (x = don't care)
o
| 7  6  | 5  4  | 3  2  | 1   |
| ----- | ----- | ----- | --- |
=1
| =0  =1  |     | =0  |     |
| ------- | --- | --- | --- |
Register Lock 2 Register (CR39)
| Read/Write             |     | Address: 315H, Index 39H  |     |
| ---------------------- | --- | ------------------------- | --- |
| Power-On Default: OOH  |     | Shared                    |     |
Loading 101xxxxx (e.g., AOH) unlocks the extended CRTC registers from CR40 through CRFF for
reading/writing (x = don't care). Loading A5H allows bits 7-2 of CR36, bits 7-0 of CR37, bits 7-0 of CR68
and bits 7-0 of CR6F to be written and alsoselects the CTR registers at Indexes 22H-29H instead of the
CR registers at those same indices.
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
= 1
= 1  =0
Miscellaneous 1 Register (CR3A)
| Read/Write  |     | Address: 3?5H, Index 3AH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
I
| 7  6      | 5  4                                      | 3  2      | 1  0     |
| --------- | ----------------------------------------- | --------- | -------- |
| pelRB     | HST  ENH                                  | TOP  ENB  | REF-GNT  |
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
19-10 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Incorpor8t.d
Bit 3 TOP MEM -Enable Top of Memory Access
0= Top of memory access disabled
1 = Simultaneous VGA text and Enhanced modes are enabled. CPU and CRTC
accesses are then directed to the top 32-or 64-KByle area of display memory
depending on whether address bit 13 is 0 or 1 respectively.
Note: This bit is paired.
Bit 4 ENH 256 -Enable 8 Bits/Pixel or Greater Color Enhanced Mode
o
= Attribute controller shift registers configured for 4-bit modes
1 = Attribute controller shift register configured for 8-, 16-and 24/32-bit color
Enhanced modes
Note: This bit is paired.
Bit 5 HST DFW -Enable High Speed Text Font Writing
o
= Disable high speed text font writing
1 = Enable high speed text font writing
Setting this bit to 1 is only required for DCLK rates greater than 40 MHz. See bit 6 of
CR31.
Bit 6 Reserved
Bit 7 PCIRB DISA -PCI Read Bursts Disabled
o = PCI read burst cycles enabled
1 = PCI read burst cycles disabled
Note: Bit 7 of CR66 must be set to 1 before this bit is set to 1.
Start Display FIFO Register (CR3B)
Read/Write Address: 375H, Index 3BH
Power-On Default: OOH Paired
This value must lie in the horizontal blanking period and is typically 5 less than the value pro
grammed in CRO. This parameter helps to ensure that adequate time is available during horizontal
blanking for activities such as RAM refresh that require control of the display memory. Bit 9 of this
value is bit 6 of CR5D. This register must be enabled by setting bit 4 of CR34 to 1 and CR63_4 -3 to
01b.
o
7 6 543 2 1
START DISPLAY FIFO FETCH
Bits 7~ START DISPLAY FIFO FETCH
9-bit Value = the time in character clocks from the active display start until the restart
of fetching of FIFO data after the start of horizontal blanking. This register contains
the low-order 8 bits ofthis value.
EXTENDED CRTC REGISTER DESCRIPTIONS 19-11

86CM65 Dual Display Accelerator
S3 InDorporllted
Interlace Retrace Start Register (CR3C)
Read/Write Address: 315H, Index 3CH
Power-On Default: OOH Paired
This value allows determination of the even/odd row active display starting positions when operat
ing in an interlaced mode. This register is enabled by bit 5 of CR42.
Bits 7-0 INTERLACE RETRACE START POSITION
Value = offset in terms of character clocks for Interlaced mode start/end in even/odd
frames.
NTSC/PAL Control Register ICR3D)
Read/Write Address: 315H, Index 3DH
Power-On Default: OOH
7 6 3 2 , o
R R 1VOUTPUT 1V
Bit 0 TV -Enable TV Mode
o
= Disable TV mode
1 = Enable TV mode
Bit 3-' TV OUTPUT
xOO = AG = luma; AR = chroma IS-Video)
011 = AG = composite; AR = composite INTSC/PAL)
111 = AG = composite; AR = black burst (NTSC/PAL)
All other values are reserved
Bit 4 B/W -Black and White Video
o
= Color TV output
1 = Black and white TV output
Bit 5 N/P = NTSC/PAL
o
= NTSC output
1 = PAL output
Bits 7-6 Reserved
19-12 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorpo. .t ed
System Configuration Register (CR40)
Address: 3?5H, Index 40H
Read/Write
Power-On Default: 30H
E~H
| I  :  I  | :  I  :  I                               | :  I  :  I  | :  I  :  I  | I   |
| -------- | ---------------------------------------- | ----------- | ----------- | --- |
| Bit 0    | EN ENH -Enable Enhanced Register Access  |             |             |     |
o
= Enhanced register access disabled
1 = Enhanced register (x2E8H) access enabled
| Bits 7-1  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
BIOS Flag Register (CR41)
| Read/Write  |     | Address: 3?5H, Index 41H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
o
| 7   | 6  543  |     | 2  1  |     |
| --- | ------- | --- | ----- | --- |
BIOS-FLAG-REGISTER-l
| Bits 7-0  | BIOS-FLAG-REGISTER-1  |     |     |     |
| --------- | --------------------- | --- | --- | --- |
Used by the video BIOS.
Mode Control Register (CR42)
| Read/Write  |     | Address: 3?5H, Index 42H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
|     | 6   | 4   |     |     |
| --- | --- | --- | --- | --- |
I :  I
|           | R                           | R        |             |       |
| --------- | --------------------------- | -------- | ----------- | ----- |
|           |                             | I  :  I  | :  I  :  I  | :  I  |
| Bits 4-0  | Reserved                    |          |             |       |
| Bit 5     | INTL MODE -Interlaced Mode  |          |             |       |
o = Noninterlaced
1 = Interlaced
This bit enables the function of CR3C.
Note: This bit is paired.
EXTENDED CRTC REGISTER DESCRIPTIONS 19-13

••
86CM65 Dual Display Accelerator
".
S3 Incorpon.ed
| Bits 7-6  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
Extended Mode Register (CR43)
| Read/Write             |     |     | Address: 375H, Index 43H  |     |
| ---------------------- | --- | --- | ------------------------- | --- |
| Power-On Default: OOH  |     |     | Paired                    |     |
I
| 7  6          | 5                                  | 4   | 3  2     | 1  0  |
| ------------- | ---------------------------------- | --- | -------- | ----- |
| HCTR  CURSOR  |                                    |     | CHR      |       |
| X2  BLINK     |                                    | R   | BLNK  R  | R  R  |
| Bits 2-0      | Reserved                           |     |          |       |
| Bit 3         | CHR BLNK -Character Blink Control  |     |          |       |
o  = Blink every 32 frames
1 = Blink every 64 frames
| Bit 4     | Reserved      |     |     |     |
| --------- | ------------- | --- | --- | --- |
| Bits &-5  | CURSOR BLINK  |     |     |     |
00 = Blink every 16 frames
01 = Blink every 32 frames
1x = Blink every 64 frames
| Bit 7  | HCTR X2 -Horizontal Counter Double Mode  |     |     |     |
| ------ | ---------------------------------------- | --- | --- | --- |
o
= Disable horizontal counter double mode
1 = Enable horizontal counter double mode (horizontal CRT parameters are doubled)
Hardware Graphics Cursor Mode Register (CR45)
| Read/Write  |     |     | Address: 375H, Index 45H  |     |
| ----------- | --- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6   | 5                                          | 4     | 3  2  | 1  0    |
| ------ | ------------------------------------------ | ----- | ----- | ------- |
|        |                                            | HWGC  |       | HWGC    |
| R  R   | R                                          | 1280  | R  R  | R  ENB  |
| Bit 0  | HWGC ENB -Hardware Graphics Cursor Enable  |       |       |         |
o = Hardware graphics cursor disabled in any mode
1 = Hardware graphics cursor enabled in Enhanced mode
| Bits 3-1  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |

86CM65 Dual Display Accelerator
S3 IncorpDratad
Bit 4 HWGC 1280 -Hardware Cursor Right Storage
o
= Function disabled
1 = For 4 bits/pixel, the last 256 bytes in each 1-KByte line of the hardware cursor start
address become the hardware graphics cursor storage area. For 8 bits/pixel, the
last 512 bytes in each 2-KByte line of the hardware cursor start address become
the hardware graphics cursor storage area. In either case, bits 1-0 of CR4D must
be 11b.
Bits 7~ Reserved
Hardware Graphics Cursor Origin-X Registers (CR46, CR47)
Read/Write Address: 375H, Index 46H, 47H
Power-On Default: OOOOH
The high order three bits are written into CR46 and the low order byte is written into CR47.
Bits 10-0 HWGC ORG X(H) (L) -X-Coordinate of Cursor Left Side
Bits 15-11 Reserved
Hardware Graphics Cursor Origin-V Registers (CR48, CR49)
ReadlWrite Address: 375H, Index 48H, 49H
Power-On Default: Undefined
The high order three bits are written into CR48 and the low order byte is written into CR49.
Bits 10-0 HWGC ORG V (H)(L) -V-Coordinate of Cursor Upper Line
The cursor X, Y position is registered upon writing HWGC ORG Y (H).
Bits 15-11 Reserved
EXTENDED CRTC REGISTER DESCRIPTIONS 19-15

86CM65 Dual Display Accelerator
sa Incorporated
Hardware Graphics Cursor Foreground Color Stack Register (CR4A)
Read,write Address: 3?5H, Index 4AH
Power-On Default: Undefined
TRUE COLOR FOREGROUND STACK (0-2)
Bits 7~ TRUE COLOR FOREGROUND STACK (0-2)
Three foreground color registers are stacked at this address. The stack pointer (com
mon with CR4B) is reset to 0 by reading the Hardware Graphics Cursor Mode register
(CR45). Each write to this register (CR4A) increments the stack pointer by 1, so three
writes provide 24 bits oftrue color information.
Hardware Graphics Cursor Background Color Stack Register (CR4B)
Read,write Address: 3?5H, Index 4BH
Power-On Default: Undefined
Bits 7~ TRUE COLOR BACKGROUND STACK (0-2)
Three background color registers are stacked at this address. The stack pointer (com
mon with CR4A) is reset to 0 by reading the Hardware Graphics Cursor Mode register
(CR45). Each write to this register (CR4B) increments the stack pointer by 1, so three
writes provide 24 bits of true color information.
Hardware Graphics Cursor Storage Start Address Registers (CR4C, CR4D)
Read,write Address: 3?5H, Index 4CH, 4DH
Power-On Default: Undefined
The high order four bits are written into CR4C and the low order byte is written into CR4D.
Bits 11~ HWGC STA(H)(L) -Hardware Graphics Cursor Storage Start Address
Bits 15-12 Reserved
19-16 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
sa Inoorpordeci
Hardware Graphics Cursor Pattern Display Start X-PXL-Position Register (CR4E)
| Read/Write  |     | Address: 375H, Index 4EH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6      | 5  4                                                                    | 3  2  | 1  0  |
| --------- | ----------------------------------------------------------------------- | ----- | ----- |
| R  R      | HWGC PAT DISP START x-pas                                               |       |       |
| Bits 5-0  | HWGC PAT DISP START X-POS -HWGC Pattern Display Start-X Pixel Position  |       |       |
This value is the offset (in pixels) from the left side of the 64x64 cursor pixel pattern
from which the cursor is displayed. This allows a partial cursor to be displayed at the
left border of the display.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Hardware Graphics Cursor Pattern Disp Start Y-PXL-Position Register (CR4F)
| Read/Write  |     | Address: 375H, Index 4FH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Undefined
| 7  6  | 5  4  | 3  2  | o   |
| ----- | ----- | ----- | --- |
1
HWGC PAT DISP START v-pas
R  R
| Bits 5-0  | HWGC PAT DISP START V-POS -HWGC Pattern Display Start-V Pixel Position  |     |     |
| --------- | ----------------------------------------------------------------------- | --- | --- |
This value is the offset (in pixels) from the top of the 64x64 cursor pixel pattern from
which the cursor is displayed. This allows a partial cursor to be displayed at the top
ofthe display.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
EXTENDED CRTC REGISTER DESCRIPTIONS  19-17

86CM65 Dual Display Accelerator
53 Incorporated
Extended System Cont 1 Register (CR50)
| Read/Write  |     | Address: 315H, Index 50H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| I         | I                                                                    |       |       |
| --------- | -------------------------------------------------------------------- | ----- | ----- |
| 7  6      | 5  4                                                                 | 3  2  | 1  0  |
| GE-SCR-W  | PXL-LNGH                                                             |       | GESW  |
| 1  0      | 1  0                                                                 | R  R  | R  2  |
| Bit 0     | Extension bit 2 of the screen width definition. See bits 7-6 below.  |       |       |
| Bits 3-1  | Reserved                                                             |       |       |
| Bits 5-4  | PXL-LNGH -Pixel Length Select                                        |       |       |
00 = 1 byte (Default). This corresponds to a pixel length of 4 or 8 bits/pixel in 42E8H3
01 = 2 bytes. 16 bits/pixel
10 = Reserved
11 = 4 bytes. 32 bits/pixel
These bits select the pixel length for Enhanced mode command execution through
the Graphics Engine.
| Bits 7-6  | GE-SCR-W -Graphics Engine Command Screen Pixel Width  |     |     |
| --------- | ----------------------------------------------------- | --- | --- |
Bit 0 of this register is the most significant bit of this definition.
000 = 1024 (or 2048 if bit 1 of CR31 =1) (Default)
001 = 640
010 = 800 (or 1600x1200x4 if bit 2 of 4AE8H = 0)
011 = 1280
100 = 1152
101 = Reserved
110 = 1600
111 = Reserved
Extended System Control 2 Register (CR51)
| Read/Write             |                                           | Address: 315H, Index 51H  |     |
| ---------------------- | ----------------------------------------- | ------------------------- | --- |
| Power-On Default: OOH  |                                           | Paired                    |     |
| Bits 3-0               | Reserved                                  |                           |     |
| Bits 5-4               | LOG-SCR-W -Logical Screen Width Bits 9-8  |                           |     |
These are two extension bits of the Offset register (CR13)
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
19-18 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Incorporated
Extended BIOS Flag' Register (CR52)
| ReadlWrite  |     | Address: 315H. Index 52H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
,
| 7  6  | 5   | 3  2  | o   |
| ----- | --- | ----- | --- |
4
EXT-BIOS-FLAG-REGISTER-1
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-1  |     |     |
| --------- | ------------------------- | --- | --- |
See the S3 video BIOS documentation for the coding of this register.
Extended Memory Control' Register (CR53)
| Read/Write  |     | Address: 315H. Index 53H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: See Bit Descriptions
,
I  I
| 7  6      | 5  4                                                                     | 3  2        | 0   |
| --------- | ------------------------------------------------------------------------ | ----------- | --- |
| SWP       | MMIO  MMIO                                                               | BIG ENDIAN  |     |
| R  NBL    | WIN  SELECT                                                              | LlNADDR     | R   |
| Bit 0     | Reserved                                                                 |             |     |
| Bits 2-'  | BIG ENDIAN LIN ADDR -Big Endian Data Byte swap (linear addressing only)  |             |     |
00 = No swap (Default)
01 = Swap bytes within each word
. 10 = Swap all bytes in doublewords (bytes reversed)
11 = Reserved
| Bits 4-3  | MMIO SELECT  |     |     |
| --------- | ------------ | --- | --- |
00 = Disable MMIO
01 = New MMIO (relocatable) enabled (Default for PCI)
10 = Trio64-type MMIO enabled at window selected by bit 5 of this register
11 = Trio64-type MMIO and new MMIO enabled
Refer to the MMIO explanation in Section 16 for more information.
| Bit 5  | MMIO WIN -Trio64-type MMIO Window  |     |     |
| ------ | ---------------------------------- | --- | --- |
0= Tri064-type MMIO window enabled at A8000H -AFFFFH. AOOOOH -A7FFF
available for image transfers (Default)
1 = Trio64-type MMIO window enabled at B8000H -BFFFFH. AOOOOH -B7FFFH are not
used (no image transfer area)
Bits 4-3 of this register must be programmed to 10b for this bit to be effective.
EXTENDED CRTC REGISTER DESCRIPTIONS  19-19

86CM65 Dual Display Accelerator
S3 Incorporated
| Bit 6  | SWP NBL -Swap Nibbles  |     |     |     |
| ------ | ---------------------- | --- | --- | --- |
o = No nibble swap (Default)
1 = Swap nibbles in each byte of a linear memory address read or write operation
| Bit 7  | Reserved  |     |     |     |
| ------ | --------- | --- | --- | --- |
Extended Memory Control 2 Register (CR54)
| Read/Write  |     | Address: 315H. Index 54H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
| 7   | 654  | 3   |     |     |
| --- | ---- | --- | --- | --- |
M PARAMETER
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
| Bits 2. 7-3  | M PARAMETER  |     |     |     |
| ------------ | ------------ | --- | --- | --- |
6-bit Value = maximum number of MCLKs that the CPU and Graphics Engine can use
to access memory before giving up control of the memory bus. Bit 2 is the high order
bit of this value. The M parameter for LBP accesses is specified in CR76_5-0.
Extended RAMDAC Control Register (CR55)
| Read/Write  |     | Address: 315H. Index 55H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
~
| I  :  I   | :  I  :  I  | I  :  I  | :  I  :  I  | :  I  |
| --------- | ----------- | -------- | ----------- | ----- |
| Bits 3-C  | Reserved    |          |             |       |
19-20 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Incorporated
| Bit 4  | MS/X11 -Hardware Cursor MS/X11 Mode  |     |     |
| ------ | ------------------------------------ | --- | --- |
o = MS-Windows mode (Default)
1 = X11-Windows mode
This bit select the type of decoding used for the 64x64x2 storage array of the hard
ware graphics cursor. See the Programming the Hardware Cursor section for a de
scription of the decoding.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
External Sync Control 1 Register (CR56)
| Read/Write  |     | Address: 3?5H, Index 56H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: DOH
2
| 7  6   | 5  4                           | 3        | 1  0     |
| ------ | ------------------------------ | -------- | -------- |
|        |                                | DIS      | DIS      |
| R  R   | R  R                           | R  VSYN  | HSYN  R  |
| Bit 0  | Reserved                       |          |          |
| Bit 1  | DIS HSYN -Tri-state off HSYNC  |          |          |
o
= HSYNC output buffer tri-stated on
, = HSYNC output buffer tri-stated off
| Bit 2  | DIS VSYN -Tri-state off VSYNC  |     |     |
| ------ | ------------------------------ | --- | --- |
o  = VSYNC output buffer tri-stated on
1 = VSYNC output buffer tri-stated off
| Bits 7-3  | Reserved  |     |     |
| --------- | --------- | --- | --- |
EXTENDED CRTC REGISTER DESCRIPTIONS 19-21

86CM65 Dual Display Accelerator
Linear Address Window Control Register (CR58)
| Read/Write  |     | Address: 315H, Index 58H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: 10H
| 7  6      | 5  4                                  | 3  2  | 1  I  0   |
| --------- | ------------------------------------- | ----- | --------- |
| RAS       | ENB                                   |       | LAW-SIZE  |
| PRE  R    | R  LA                                 | R  R  | 1  0      |
| Bits 1-0  | LAW-SIZE -Linear Address Window Size  |       |           |
00 = 64 KBytes (Default)
01 = 1 MByte
10 = 2 MBytes
11 = Reserved
The 64K window is not available if new MMIO is enabled ICR53_3 = 1).
| Bits 3-2  | Reserved                          |     |     |
| --------- | --------------------------------- | --- | --- |
| Bit 4     | ENB LA -Enable Linear Addressing  |     |     |
0= Disable linear addressing
1 = Enable linear addressing (Default)
Enabling linear addressing disables access to the AOOOH-AFFFH region unless bank
ing is enabled via bit 0 of CR31, the window size is set to 64K via bits 1-0 of this regis
ter and AOOOH is speCified as the base in CR59-5A.
| Bits 6-5  | Reserved                             |     |     |
| --------- | ------------------------------------ | --- | --- |
| Bit 7     | RAS PRE -RAS Pre-charge Time Adjust  |     |     |
0= RAS pre-charge (high) time is defined by CR68_3 or MM81EC_16 (Default)
1 = RAS pre-charge (high) time is decreased by 0.5 MCLKs over that specified by
CR68_3 and the corresponding RAS low time (CR68_2) is increased by 0.5
MCLKs. This leaves the total cycle time unchanged.
19c22 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Incorporated
Linear Address Window Position Registers (CR59-5A)
Read/Write Address: 315H, Index 59H-5AH
Power-On Default: OOOOH
CR59 contains the upper byte (15-8) and CR5A contains the lower byte (7-0). These registers specify
the Linear Address Window Position in 32-bit CPU address space. The Linear Address Window resides
on a 64KB, 1M B or 2MB memory boundary (size-aligned boundary). Some LSBs of this register
(illustrated by "xx. . xx" in the following table) are ignored because ofthe size-aligned boundary scheme.
LAW Linear Address Window
Size Position Register Bit(s)
64KB 31-25 24 23 22 21 20 19 18 17 16
1MB 31-25 24 23 22 21 20 xx xx xx xx
2MB 31-25 24 23 22 21 xx xx xx xx xx
Bits 15-0 LlNEAR-ADDRESS-WINDOW-POSITION -LA Window Position Bits 31-16
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
EXTENDED CRTC REGISTER DESCRIPTIONS 19-23

86CM65 Dual Display Accelerator
General Output Port Register (CR5C)
| ReadIWrite  |     | Address: 315H, Index 5CH  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
o
| 7  6  | 543  |     | 2   | 1   |
| ----- | ---- | --- | --- | --- |
GENERAL-QUT-PORT
| Bits 7-0  | GENERAL-OUT-PORT  |     |     |     |
| --------- | ----------------- | --- | --- | --- |
This register can be used in a variety of ways. See Section 13 for a complete descrip
tion.
Extended Horizontal Overflow Register (CR5D)
| ReadIWrite             |                                                     | Address: 315H, Index 5DH  |      |          |
| ---------------------- | --------------------------------------------------- | ------------------------- | ---- | -------- |
| Power-On Default: OOH  |                                                     | Paired                    |      |          |
| 7  6                   | 5  4                                                | 3                         | 2    | 1  0     |
| SFF                    | EHS  SHS                                            | EHB                       | SHB  | HOE  HT  |
| R  8                   | 6  8                                                | 7                         | 8    | 8  8     |
| Bit 0                  | HT 8 -Horizontal Total (CRO) Bit 8                  |                           |      |          |
| Bit 1                  | HOE 8 -Horizontal Display End (CR1) Bit 8           |                           |      |          |
| Bit 2                  | SHB 8 -Start Horizontal Blank (CR2) Bit 8           |                           |      |          |
| Bit 3                  | EHB 7 -End Horizontal Blank (CR3) Bit 6             |                           |      |          |
| Bit 4                  | SHS 8 -Start Horizontal Sync Position (CR4) B.it 8  |                           |      |          |
| Bit 5                  | EHS 6 -End Horizontal Sync (CR5) Bit 6              |                           |      |          |
| Bit 6                  | SFF 8 -Start FIFO Fetch (CR3B) Bit 8                |                           |      |          |
| Bit 7                  | Reserved                                            |                           |      |          |
19-24 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorporllted
Extended Vertical Overflow Register (CR5E)
| ReadJWrite             |       | Address: 375H, Index 5EH  |       |
| ---------------------- | ----- | ------------------------- | ----- |
| Power-On Default: OOH  |       | Paired                    |       |
| 7  6                   | 5  4  | 3  2                      | 1  0  |
vr
| LCM    | VRS                                           | SVB    | VDE     |
| ------ | --------------------------------------------- | ------ | ------- |
| R  10  | R  10                                         | R  10  | 10  10  |
| Bit 0  | VT 10 -Vertical Total (CR6) Bit 10            |        |         |
| Bit 1  | VDE 10 -Vertical Display End (CR12) Bit 10    |        |         |
| Bit 2  | SVB 10 -Start Vertical Blank (CR15) Bit 10    |        |         |
| Bit 3  | Reserved                                      |        |         |
| Bit 4  | VRS 10 -Vertical Retrace Start (CR10) Bit 10  |        |         |
| Bit 5  | Reserved                                      |        |         |
| Bit 6  | LCM 10 -Line Compare Position (CR18) Bit 10   |        |         |
| Bit 7  | Reserved                                      |        |         |
Extended Memory Control 3 Register (CR60)
| ReadJWrite  |     | Address: 375H, Index 60H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
PRIMARY STREAM FIFO N PARAMETER
| Bits 7-0  | PRIMARY STREAM FIFO N PARAMETER  |     |     |
| --------- | -------------------------------- | --- | --- |
Value = Number of MCLKs allocated to screen refresh FIFO filling before control of
the memory bus is relinquished. This value is effective only when the FIFO is at or
above its threshold value (low priority).
EXTENDED CRTC REGISTER DESCRIPTIONS 19-25

86CM65 Dual Display Accelerator
S3 lnoorporated
Extended Memory Control 4 Register (CR61)
| Read/Write  |     | Address: 3?5H, Index 61H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
o
| 7              |                                                           | 4  3  | 2  1  |     |
| -------------- | --------------------------------------------------------- | ----- | ----- | --- |
| R  BIG ENDIAN  |                                                           | R  R  | R  R  | R   |
| Bits 4-0       | Reserved                                                  |       |       |     |
| Bits 6-5       | BIG ENDIAN -Big Endian Data Bye Swap (image writes only)  |       |       |     |
00 = No swap (Default)
01 = Swap bytes within each word
10 = Swap all bytes in doublewords (bytes reversed)
11 = Reserved
| Bit 7  | Reserved  |     |     |     |
| ------ | --------- | --- | --- | --- |
Start FIFO Fetch Register (CR63)
| Read/Write             |                                       | Address: 3?5H, Index 63H  |       |     |
| ---------------------- | ------------------------------------- | ------------------------- | ----- | --- |
| Power-On Default: OOH  |                                       | Paired                    |       |     |
| 7  6                   | 5                                     | 4  3                      | 2  1  | o   |
| R  R                   | R                                     | FIFO FETCH                | R  R  | R   |
| Bits 2-0               | Reserved                              |                           |       |     |
| Bits 4-3               | FIFO FETCH -Start Display FIFO Fetch  |                           |       |     |
00 = Start FIFO fetch on falling edge of the internal HSYNC signal
01 = Start FIFO fetch at horizontal total (CR34_4 = 0) or at value programmed in
CR3B (CR34_4 = 1)
10 = Start FIFO fetch on rising edge of the internal HSYNC signal delayed by 4
character clocks
11 = Start FIFO fetch on rising edge of the internal HSYNC signal delayed by 6
character clocks
| Bits 7-5  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
19-26 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
Extended Miscellaneous Control Register (CR65)
| Read/Write             |                                 | Address: 375H, Index 65H  |           |     |
| ---------------------- | ------------------------------- | ------------------------- | --------- | --- |
| Power-On Default: OOH  |                                 | Paired                    |           |     |
|                        | 4                               | 3                         |           |     |
|                        | DLYBLANK                        | I :                       | I :  I :  | I   |
|                        | 1                               | 0                         |           |     |
| Bits 2"()              | Reserved                        |                           |           |     |
| Bits 4-3               | DLK BLANK -Delay BLANK by DCLK  |                           |           |     |
00 = No delay of BLANK
01 = Delay BLANK for 1 DCLK
10 = Delay BLANK for 2 DCLKs (required for color mode 12)
11 = Delay BLANK for 3 DCLKs
| Bits 7-5  | Reserved  |     |     |     |
| --------- | --------- | --- | --- | --- |
Extended Miscellaneous Control 1 Register (CR66)
| Read/Write  |     | Address: 375H, Index 66H  |     |     |
| ----------- | --- | ------------------------- | --- | --- |
Power-On Default: OOH
| 7  6   | 5  4                                 | 3    | 2  1         | 0   |
| ------ | ------------------------------------ | ---- | ------------ | --- |
| PCI    |                                      | PCI  | SW           | EN  |
| DE  R  | R  R                                 | DIS  | R  RST  ENH  |     |
| Bit 0  | °EN  ENH -Enable Enhanced Functions  |      |              |     |
= Disable enhanced functions
1 = Enable enhanced functions
This bit is a duplicate of 4AE8_0. Writing to this location also update the bit value at
the other location.
Note: This bit is paired.
| Bit 1  | SW RST -Software Reset  |     |     |     |
| ------ | ----------------------- | --- | --- | --- |
o = No function
1 = Software reset of the Graphics Engine
Setting this bit has the same function as setting 42E8H (writeL1 5-14 to lOb.
| Bit 2  | Reserved  |     |     |     |
| ------ | --------- | --- | --- | --- |
EXTENDED CRTC REGISTER DESCRIPTIONS 19-27

86CM65 Dual Display Accelerator
8a Incorporated
| Bit 3  | PCI DIS -PCI Disconnect  |     |     |
| ------ | ------------------------ | --- | --- |
0= No effect
1 = An attempt to write data with the Command FIFO or LPB output FIFO full or to
read data with the Command FIFO not empty generates a PCI bus disconnect
cycle
Bit 7 of this register must also be set to 1 to enable this feature.
| Bits 6-4  | Reserved                           |     |     |
| --------- | ---------------------------------- | --- | --- |
| Bit 7     | PCI DE -PCI bus disconnect enable  |     |     |
o  = PCI bus disconnect disabled
1 = PCI bus disconnect enabled
Setting this bit to 1 allows PCI burst cycles to be interrupted if AD[1:0] .;: OOb or if the
address during the burst goes outside the address ranges supported by the 86CM65.
See also bit 3 of this register.
Extended Miscellaneous Control 2 Register (CR67)
| Read/Write             |                                            | Address: 375H, Index 67H           |         |
| ---------------------- | ------------------------------------------ | ---------------------------------- | ------- |
| Power-On Default: OOH  |                                            | Paired                             |         |
|                        | I  I                                       | I                                  |         |
| 7  I  6                | 5  4                                       | 3  2                               | 1  0    |
| COLOR MODE             |                                            | STREAMS                            | VCLK    |
| 3  2                   | 1  0                                       | MODE                               | R  PHS  |
| Bit 0                  | VCLK PHS -VCLK Phase With Respect to DCLK  |                                    |         |
|                        | 0= VCLK is 1800                            | out of phase with DCLK (inverted)  |         |
1 = VCLK is in phase with DCLK
| Bit 1     | Reserved      |     |     |
| --------- | ------------- | --- | --- |
| Bits 3-2  | STREAMS MODE  |     |     |
00 = Streams Processor disabled
01 = Secondary stream overlaid on VGA mode background
10 = Reserved
11 = Full Streams Processor operation (primary and secondary streams from all
supported sources)
The Streams Processor should only be enabled or disabled during the VSYNC period.
19-28 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorpo...ud
Bits 7-4 COLOR MODE -RAMDAC Color Mode
0000 = Mode 0: 8-bit color, 1 pixelNCLK
0001 = Mode 8: 8-bit color, 2 pixelsNCLK
0011 = Mode 9: 1S-bit color, 1 pixelNCLK
0101 = Mode 10: 16-bit color, 1 pixelNCLK
0111 = Mode 12: 640x480x24-bit color (packed), 1 pixelNCLK
1101 = Mode 13: 24-bit color, (not packed) 1 pixelNCLK
All other mode values are reserved.
Configuration 3 Register (CR68)
Read/Write Address: 37SH, Index 68H
Power-On Default: Depends on Strapping
This is of the power-on strapping bits (along with CR36, CR37 and CR6F) . PD[23:16] are sampled on
power-on reset and their states are written to bits 7-0 of this register. These pins have internal
pull-downs and the states of pins are inverted, so this register will default to FFH if no pins are pulled
up. ASH must be written to CR39 to provide reacl/Write access to this register.
I I I
7 6 5 4 3 2 1 0
BIOS RAS- RAS-
R 3 2 1 PCG LOW CAS/OE STR
Bits 1-0 CAS,OE Stretch Time
00 = approximately 6.S ns stretch (nominal)
01 = approximately 5 ns stretch (nominal)
10 = approximately 3.5 ns stretch (nominal)
. 11 = no stretch
This parameter adjusts the timing for the rising edges of the CAS and OE signals.
This allows stretching of the signal active time for CAS and OE to allow more time for
valid pixel data to be available. The delay time shown above is an approximation. It is
affected by both process and signal loading and must be measured for each design.
Bit 2 RAS-LOW -RAS Low Timing Select
0=4.S MCLKs
1 = 3.S MCLKs
This parameter specifies the length of the RAS active time for a single row/column ac
cess. RAS may be held low longer to accommodate additional page mode accesses
to the same row.
Bit 3 RAS-PCG -RAS Precharge Timing Select
o
=3.S MCLKs
1 =2.S MCLKs
When RAS goes high to end a memory cycle, this parameter specifies the minimum
period it must be held high before beginning another memory access cycle.
EXTENDED CRTC REGISTER DESCRIPTIONS 19-29

III.
r
86CM65 Dual Display Accelerator
53 Incorpom.d
| Bits 6-4  | BIOS -Reserved for use by the video BIOS.  |     |     |
| --------- | ------------------------------------------ | --- | --- |
| Bit 7     | Reserved                                   |     |     |
Extended System Control 3 Register (CR69)
| Read/Write             |                  | Address: 375H, Index 69H  |     |
| ---------------------- | ---------------- | ------------------------- | --- |
| Power-On Default: DOH  |                  | Paired                    |     |
| 7  6                   | 5  4             | 3  210                    |     |
| R  R                   | R  R             | R  DISP-START-ADDR        |     |
| Bits 2-0               | DISP-START-ADDR  |                           |     |
This field contains the upper 3 bits (18-16) of the display start address, allowing ad
dressing of up to 2 MBytes of display memory.
| Bits 7-3  | Reserved  |     |     |
| --------- | --------- | --- | --- |
Extended System Control 4 Register (CR6A)
| Read/Write             |     | Address: 375H, Index 6AH  |     |
| ---------------------- | --- | ------------------------- | --- |
| Power-On Default: OOH  |     | Paired                    |     |
o
| 7  6      | 5  4              | 3  2              | 1   |
| --------- | ----------------- | ----------------- | --- |
| R  R      | R                 | CPU-BASE-ADDRESS  |     |
| Bits 4-0  | CPU-BASE-ADDRESS  |                   |     |
This field contains the upper 5 bits (18-141 ofthe CPU base address, allowing access
ing of up to 2 MBytes of display memory via 64K pages. If linear addressing is
enabled and a 64 KByte window is specified, these bits specify the 64K page to be ac
cessed at the base address specified in CR59 and CR5A. Otherwise, the base address
is normally at AOOOH.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
19-30 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
Extended BIOS Flag 3 Register ICR6BI
| Read/Write  | Address: 315H, Index 6BH  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: OOH
| 7  6  | 543  | 2  1  | o   |
| ----- | ---- | ----- | --- |
EXT-BIOS-FLAG-REGISTER-3
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-3  |     |     |
| --------- | ------------------------- | --- | --- |
This register is reserved for use by the 53 BIOS.
Extended BIOS Flag 4 Register ICR6C1
| Read/Write  | Address: 315H, Index 6CH  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: OOH
| 7  6  | 543  | 2  1  | o   |
| ----- | ---- | ----- | --- |
EXT-BIOS-FLAG-REGISTER-4
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-4  |     |     |
| --------- | ------------------------- | --- | --- |
This register is reserved for use by the 53 BIOS.
Extended BIOS Flag 5 Register ICR6DI
| Read/Write  | Address: 315H, Index 6DH  |     |     |
| ----------- | ------------------------- | --- | --- |
Power-On Default: OOH
o
| 7  6  | 543  | 2  1  |     |
| ----- | ---- | ----- | --- |
EXT-BIOS-FLAG-REGISTER-5
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-5  |     |     |
| --------- | ------------------------- | --- | --- |
This register is reserved for use by the 53 BIOS.
EXTENDED CRTC REGISTER DESCRIPTIONS 19-31

86CM65 Dual Display Accelerator
S3 Incorporated
Extended BIOS Flag 6 Register (CR6E)
| ReadJWrite  |     | Address: 375H, Index 6EH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
EXT-BIOS-FLAG-REGISTER-6
| Bits 7-0  | EXT-BIOS-FLAG-REGISTER-6  |     |     |
| --------- | ------------------------- | --- | --- |
This register is reserved for use by the S3 BIOS.
Configuration 4 Register (CR6F)
| ReadJWrite  |     | Address: 375H, Index 6FH  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: Depends on Strapping
This is the fourth byte of power-on strapping bits. PD[28:24) are sampled at reset and the values are
written to bits 4-0 of this register. A5H must be written to CR39 to provide read/write access to this
register. Non-reserved bits will power up with a value of 1 if the corresponding pins are not pulled
high.
| 7  6   | 5                                      |     | o   |
| ------ | -------------------------------------- | --- | --- |
| R  R   | R                                      |     | R   |
| Bit 0  | Reserved                               |     |     |
| Bit 1  | IOSEL -Serial Port I/O Address Select  |     |     |
o
= MMFF20 is accessed at I/O address OOOE8H
1 = MMFF20 is accessed at I/O address 000E2H
Bit 2 of this register must be cleared to 0 for this bit to have effect.
| Bit 2  | 10EN -Serial Port Address Type Select  |     |     |
| ------ | -------------------------------------- | --- | --- |
0= MMFF20 is accessed at the I/O port defined in bit 1 of this register or at its MMIO
address
1 = MMFF20 is accessed at its MMIO address only (no I/O)
Enabling I/O access allows the serial port to be used for 12C communications when
the 86CM65 is disabled.
19-32 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Incorpor.ted
Bits 4-3 WE Delay
00 = 3 units delay
01 = 2 units delay
10 = 1 unit delay
11 = 0 units delay
Both the rising and falling edges of WE are delayed by the amount specified in these
bits.
Bits 7-5 Reserved
Dual Image Control Register (CR71)
Read/Write Address: 375H, Index71H
Power-On Default: OOH Paired
7 6 I S~FF I 4 3 2 1 0
R R R R R SOC R
Bit 0 Reserved
Bit 1 SOC -Screen Off Control
0= Use SR1_5 for screen off control
1 = Use CR71_5 for screen off control
SR1_5 is a shared bit, so both screens have to be on or off ifthis bit is used. CR71_5 is
paired, allowing independent on/off selection for each screen.
Bits 4-2 . Reserved
Bit 5 SOFF -Screen Off
0= Screen on
1 = Screen off
This is the same as blanking. The control signals are still active.
Bits 7-6 Reserved
EXTENDED CRTC REGISTER DESCRIPTIONS 19-33

86CM65 Dual Display Accelerator
8s Inoorporated
Extended Memory Control 5 Register (CR72)
Read/Write) Address: 375H, Index 72H
Power-On Default: OOH
Bits 7-0 SECONDARY STREAM FIFO N PARAMETER
Value = Number of MCLKs allocated to screen refresh FIFO filling before control of
the memory bus is relinquished. This value is effective only when the FIFO is at or
above its threshold value (low priority).
Extended Memory Control 6 Register (CR73)
Read/Write) Address: 375H, Index 73H
Power-On Default: OOH
Bits 6.() CONTROLLER 2 FIFO N PARAMETER
Value = Number of MCLKs allocated to screen refresh FIFO filling before control of
the memory bus is relinquished. This value is effective only when the FIFO is at or
above its threshold value (low priority) as specified in SR29_7-6.
Bit 7 MIUS -MIU Synchronization
0= synchronize Memory Interface Unit (MIU) control registers every MCLK rising edge
1 = synchronize MIU control registers on the first MCLK rising edge after every falling
edge of CLK32 (32 KH~ clock).
The MIU control registers are written using SCLK. They must then be synchronized to
MCLK. Setting this bit to 1 causes this synchronization to occur less frequently,
thereby reducing power consumption.
19-34 EXTENDED CRTC REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 IncorpordH
Extended Memory Control 7 Register (CR74)
| Read/Write)  |     | Address: 3?5H, Index 73H  |     |
| ------------ | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6      | 5  4                | 3  2    | 1     |
| --------- | ------------------- | ------- | ----- |
| R  R      | R  R                | R  SFR  | R  R  |
| Bits 1-0  | Reserved            |         |       |
| Bit 2     | SFR -SNT FIFO Rate  |         |       |
o = 2 MCLK STN FIFO reads/writes
1 = 1 MCLK STN FIFO reads/writes for 1-cycle EDO operation (CR36_3-2 = OOb)
Extended Memory Control 8 Register (CR75)
| Read/Write)  |     | Address: 315H, Index 75H  |     |
| ------------ | --- | ------------------------- | --- |
Power-On Default: OOH
|       |      | 2   | o   |
| ----- | ---- | --- | --- |
| 7  6  | 543  |     | 1   |
STN FIFO N PARAMETER
| Bits 7-0  | STN FIFO N PARAMETER  |     |     |
| --------- | --------------------- | --- | --- |
Value = Number of MCLKs allocated to screen refresh FIFO filling before control of
the memory bus is relinquished. This value is effective only when the FIFO is at or
above its threshold value (low priority) as specified in SR29.
Extended Memory Control 9 Register (CR76)
| Read/Write)  |     | Address: 3?5H, Index 76H  |     |
| ------------ | --- | ------------------------- | --- |
Power-On Default: OOH
| 7  6     | 5                |                  | o   |
| -------- | ---------------- | ---------------- | --- |
|          | 432              |                  | 1   |
| R  R     |                  | LPB M PARAMETER  |     |
| BitsS-O  | LPB M PARAMETER  |                  |     |
Value = maximum number of MCLKs that the LPB can use to access memory before
giving up control of the memory bus.
| Bits 7-6  | Reserved  |     |     |
| --------- | --------- | --- | --- |
EXTENDED CRTC REGISTER DESCRIPTIONS  19-35

86CM65 Dual Display Accelerator
sa Incorpo...ud

86CM65 Dual Display Accelerator
S3 Incorporat.d
Section 20: Enhanced Commands Register Descriptions
These registers support the Enhanced mode drawing commands. Access to these registers is enabled
via bit 0 of the System Configuration register (CR40).
In the following register descriptions, 'R' stands for reserved (write = 0, read = undefined). See Appendix
A for a table listing each of the registers in this section and its page number.
Subsystem Status Register
| Read Only  | Address: 42E8H  |     |     |     |     |
| ---------- | --------------- | --- | --- | --- | --- |
Power-On Default: OOOOH
This read-only register provides information on interrupt status, monitor I.D. and the number of bits
per pixel. See the Subsystem Control (42E8H, Write Only) register for details on enabling and clearing
interrupts.
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  | 4  3  2     | 1  0  |
| ----------- | ----------- | -------- | ----- | ----------- | ----- |
|             |             | PXL      |       | FIFO  FIFO  | VSY   |
GE
| R  R  R                                         | R  R  R  | R  R  LNG  | R  R  | R  EMP  OVF  BSY  | INT  |
| ----------------------------------------------- | -------- | ---------- | ----- | ----------------- | ---- |
| Bit 0  VSY INT -Vertical Sync Interrupt Status  |          |            |       |                   |      |
o
= No interrupt
1 = Interrupt generated if enabled
| Bit 1  GE BSY -Graphics Engine Busy Interrupt Status  |     |     |     |     |     |
| ----------------------------------------------------- | --- | --- | --- | --- | --- |
o  = No interrupt
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
| Bits 4-6  Reserved  |     |     |     |     |     |
| ------------------- | --- | --- | --- | --- | --- |
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-1

III.
r
86CM65 Dual Display Accelerator
83 Inoorporated
| Bit 7  PXL LNG -Pixel Length (# of bit planes)  |     |     |     |     |     |
| ----------------------------------------------- | --- | --- | --- | --- | --- |
o
=4-bit
1 = 8-bit
This reflects the number of bit planes when CR50_5-4 = OOb.
| Bits 15-8  Reserved  |     |     |     |     |     |
| -------------------- | --- | --- | --- | --- | --- |
Subsystem Control Register
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
1 = Enable if CR32_4 = 1
| Bit 9  GE BSY-Graphics Engine Busy Interrupt Enable  |     |     |     |     |     |
| ---------------------------------------------------- | --- | --- | --- | --- | --- |
0= Disable
i = Enabie if CR32_4 = 1
| Bit 10  FIFO-ENB OVF -Command FIFO Overflow Interrupt Enable  |     |     |     |     |     |
| ------------------------------------------------------------- | --- | --- | --- | --- | --- |
0= Disable
1 = Enable if CR32_4  = 1
20-2 ENHANCED COMMANDS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Incorporned
|     | Bit 11  FIFO-ENS EMP -Command FIFO Empty Interrupt Enable  |     |     |     |     |     |     |
| --- | ---------------------------------------------------------- | --- | --- | --- | --- | --- | --- |
0= Disable
1 = Enable if CR32_4 = 1
| Bits 13-12  | Reserved                                |     |     |     |     |     |     |
| ----------- | --------------------------------------- | --- | --- | --- | --- | --- | --- |
| Bits 15-14  | GE-RST -Graphics Engine Software Reset  |     |     |     |     |     |     |
00 = No change
01 = Graphics Engine enabled
10 = Reset
11 = Reserved
Advanced Function Control Register
| Read/Write  |     | Address: 4AE8H  |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- |
Power-On Default: OOOOH
This register enables or disables the Enhanced display functions.
| 15  | 14  13                                      | 12  11  10  | 9  8  7  | 6  5  | 4  3  | 2  1  | 0     |
| --- | ------------------------------------------- | ----------- | -------- | ----- | ----- | ----- | ----- |
|     |                                             |             |          |       |       | ENH   | ENS   |
| R   | R                                           | R  R  R     | R  R     | R     | LA    | R     |       |
|     | R                                           |             | R        | R     | R     | PL    | EHFC  |
|     | Bit 0  ENS EHFC -Enable Enhanced Functions  |             |          |       |       |       |       |
o
= Enable VGA and VESA planar (4 bits/pixel) modes
1 = Enable all other modes (Enhanced and VESA non-planar)
|     | Bit 1  Reserved                            |     |     |     |     |     |     |
| --- | ------------------------------------------ | --- | --- | --- | --- | --- | --- |
|     | Bit 2  ENH PL -Enhanced mode pixel length  |     |     |     |     |     |     |
o  = 4 bits/pixel enhanced mode
1 = 8 or more bits/pixel enhanced mode
CR50_5-4 are used to differentiate between 8-, 16-and 32-bit pixel lengths.
|     | Bit 3  Reserved                      |     |     |     |     |     |     |
| --- | ------------------------------------ | --- | --- | --- | --- | --- | --- |
|     | Bit 4  LA -Enable Linear Addressing  |     |     |     |     |     |     |
o  = Disable linear addressing
1 = Enable linear addressing
This bit is ORed with bit 4 of CR58 and is equivalent to it.
|     | Bits 15-5  Reserved  |     |     |     |     |     |     |
| --- | -------------------- | --- | --- | --- | --- | --- | --- |
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-3

86CM65 Dual Display Accelerator
sa Incorporated
Current V-Position Register
Read/Write Address: 82E8H
Power-On Default: Undefined
For line draws (solid, textured, short stroke or polyline), rectangle draws and image transfers, writing
to this register defines the vertical screen coordinate at which the first pixel will be drawn. For BitBLT s,
this is the vertical coordinate for the upper left hand corner of the destination. For PatBL Ts, this is the
vertical coordinate ofthe upper left hand corner ofthe off-screen pattern. Reading this register produces
the current vertical drawing coordinate.
Bits 11-0 CURRENT V-POSITION
Bits 15-12 Reserved
Current X-Position Register
Read/Write Address: 86E8H
Power-On Default: Undefined
For line draws (solid, textured, short stroke or polyline), rectangle draws and image transfers, writing
to this register defines the horizontal screen coordinate at which the first pixel will be drawn. For
BitBLT s, this is the horizontal coordinate for the upper left hand corner of the destination. For PatBLT s,
this is the horizontal coordinate of the upper left hand corner of the off-screen pattern. Reading this
register produces the current horizontal drawing coordinate.
Bits 11-0 CURRENT X-POSITION
Bits 15-12 Reserved
20-4 ENHANCED COMMANDS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorporated
Destination V·Positlon/Axial Step Constant Register
Read/Write Address: BAEBH
Power-On Default: Undefined
For BitBlT s and PatBlT s, this register defines the vertical position for the top of the destination
rectangle. For solid and textured line draws, this is axial step constant used in the definition of the line.
Bits 11-{) DESTINATION V-POSITION
Bits 15-12 Reserved
LINE PARAMETER AXIAL STEP CONSTANT
Axial Step Constant = 2 * (min(ldxl,ldYIlI In other words, when drawing a line from point A to point B,
determine the change in the X coordinate from A to B and the change in the V coordinate from A to B.
Take the smaller of the two changes and multiply its absolute value by 2.
Bits 13-0 LINE PARAMETER AXIAL STEP CONSTANT
Bits 15-14 Reserved
Destination X·Position/Diagonal Step Constant Register
Read/Write Address: BEEBH
Power-On Default: Undefined
For BitBlT s and PatBlT s, this register defines the horizontal position for the left side of the destination
rectangle. For solid and textured line draws, this is diagonal step constant used in the definition of the
line.
Bits 11-{) DESTINATION X-POSITION
Bits 15-12 Reserved
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-5

••
r 86CM65 Dual Display Accelerator
83 InoDl'POreted
Diagonal Step Constant = 2 * [min<ldxl,ldyl) -max(ldxl,ldyl)]. See the Destination V-Position/Axial Step
Constant (8AE8H) register for an explanation of the terms used in this equation.
Bits 13-0 LINE PARAMETER DIAGONAL STEP CONSTANT
Bits 15-14 Reserved
Line Error Term Register
Read/Write Address: 92E8H
Power-On Default: Undefined
This register specifies the initial error term for solid and textured line draws.
Error Term = 2 * min<ldxl,ldyl) -max(ldxl,ldyl-1 if the starting X < the ending X
Error Term = 2 * min<ldxl,ldyl) -max<ldxl,ldYI if the starting X ~ the ending X
See the Destination V-Position/Axial Step Constant (8AE8H) register for an explanation of the terms
used in these equations.
Bits 13-0 LINE PARAMETERJERROR TERM
Bits 15-14 Reserved
Major AxIs Pixel Count Register
Read/Write Address: 96E8H
Power-On Default: Undefined
This register specifies the length (in pixels) of the major (longest) axis for solid and textured lines and
the width for rectangles, image transfers, BitBlT s and PatBlT s.
Bits 11-0 RECTANGLE WIDTH/LINE PARAMETER MAX
The value is the number of pixels along the major axis -1.
Bits 15-12 Reserved
20-6 ENHANCED COMMANDS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
sa Incorponteci
Graphics Processor Status Register
| Read Only  | Address: 9AE8H  |     |     |     |     |
| ---------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
| I  I                   | I  I    |             | I  I  | 14131 2      | I  I     |
| ---------------------- | ------- | ----------- | ----- | ------------ | -------- |
| 15  14  13             | 12  11  | 10  9  8    | 7  6  | 5            | 1  0     |
| FIFO-STATUS            |         | HDW         |       | FIFO-STATUS  |          |
| 9  10  11              | 12  13  | AE  BSY  R  | 1  2  | 3  4  5      | 6  7  8  |
| Bits 7-0  FIFO-STATUS  |         |             |       |              |          |
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
1111111111111 = 0 FIFO slots available
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

86CM65 Dual Display Accelerator
sa Incorporaud
Drawing Command Register
| Write Only  |     | Address: 9AE8H  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the drawing command and a number of associated control parameters.
| I  I      |             | J               | I  I       |            |          |
| --------- | ----------- | --------------- | ---------- | ---------- | -------- |
| 15  14    | 13  12  11  | 10  9           | 8  7  6    | 5  ·4  3   | 2  1  0  |
| CMD-TYPE  | BYTE        | BUS SIZE  WAIT  | DRWG-DIR.  | DIR  LAST  | PX       |
PRAv\
| 2  1   | 0  SWP                                     | R  1  0  | YES  2  1  | 0  YES  TYP  POF  | MD  =1  |
| ------ | ------------------------------------------ | -------- | ---------- | ----------------- | ------- |
| Bit 0  | This bit must always be programmed to 1.   |          |            |                   |         |
| Bit 1  | PX MD -Select Across the Plane Pixel Mode  |          |            |                   |         |
o
= Single pixel transferred at a time
1 = Multiple pixels transferred at a time (across the plane mode)
| Bit 2  | LAST POF -Last Pixel Off  |     |     |     |     |
| ------ | ------------------------- | --- | --- | --- | --- |
o = Last pixel of line or vector draw will be drawn
1 = Last pixel of line or vector draw will not be drawn
| Bit 3  | DIR TYP -Select Radial Direction Type  |     |     |     |     |
| ------ | -------------------------------------- | --- | --- | --- | --- |
o  = x-y (axial)
1 = Radial
| Bit 4  | DRAW YES -Draw Pixel  |     |     |     |     |
| ------ | --------------------- | --- | --- | --- | --- |
o
= Move the current position only -don't draw
1 = Draw pixel(s)
| Bits 7-5  | DRWG-DIR -Select Drawing Direction  |     |     |     |     |
| --------- | ----------------------------------- | --- | --- | --- | --- |
In the following table, radial drawing angle is measured counterclockwise from the X
axis. For axial line draws, the line is drawn from left to right or a +X and from right to
left for a -X, down for a +Y and up for a -V. X or Y maj specifies the longest axis.
|     |                   | =   | =                  |     |     |
| --- | ----------------- | --- | ------------------ | --- | --- |
|     | 7-5  Radial (biU  | 1)  | x-v (Axial -bit 3  |     |     |
0)
|     | 000  |     | -Y,Xmaj,-X  |     |     |
| --- | ---- | --- | ----------- | --- | --- |
00
|     | 001  | 450   | -Y,Xmaj,+X   |     |     |
| --- | ---- | ----- | ------------ | --- | --- |
|     | 010  | 900   | -Y,Ymaj,-X   |     |     |
|     | 011  | 1350  | -Y,Ymaj,+X   |     |     |
|     | 100  | 1800  | +Y,Xmaj,-X   |     |     |
|     | 101  |       | +Y,X maj,+X  |     |     |
2250
|     | 110     | 2700       | +Y,Ymaj,-X  |     |     |
| --- | ------- | ---------- | ----------- | --- | --- |
|     | 1 1 1   | 3 ·It~>o   | ~  ."       |     |     |
I I I
| Bit 8  | WAIT YES -Wait for CPU Data  |     |     |     |     |
| ------ | ---------------------------- | --- | --- | --- | --- |
0= Use Graphics Engine-based data
1 = Wait for data to be transferred to or from the CPU through the E2E8H port
20-8 ENHANCED COMMANDS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorporated
Bits 10-9 BUS SIZE -Select image write (E2E8H, E2EAH) bus transfer width
00 = 8 bits
01 = 16 bits
10 = 32 bits. All doubleword bits beyond the image rectangle width are discarded.
Each line starts with a fresh doubleword. The current drawing position ends up
one pixel below the lower left hand corner of the image rectangle.
11 = 32 bits. This setting applies only to image transfers across the plane (each bit
transferred is converted to a pixel). Only bits from the end of the line width to the
next byte boundary are discarded. Data for the next line begins with the next
byte. The current drawing position ends up one pixel to the right of the top right
corner of the image rectangle.
This parameter applies only to writing data through the Pixel Data Transfer (E2E8H,
E2EAH) registers (programmed I/O or memory-mapped I/O).
Bit 11 Reserved
Bit 12 BYTE SWP -Enable Byte Swap
0= High byte first, low byte second
1 = Low byte first, high byte second
Bits 15-13 CMD-TYPE -Select Command Type
000 = NOP. This is used to set up short stroke vector drawing without writing a pixel.
001 = Draw Line. If bit 3 of this register is cleared to 0, the axial step constant,
diagonal step constant and error term are used to draw the line. If bit 3 is set to
1, the line will be drawn at the angle specified by bits 7-5 and with a length in
pixels as specified by the Major Axis Pixel Count (96E8H) register.
010 = Rectangle Fill. The position, width and height of a rectangle are defined. The
rectangle is filled with a solid color if it not used for an image transfer.
110 = BitBL T. A rectangle of defined location, width and height is moved to another
defined location in display memory.
111 = PatBLT. An 8x8 pixel patterned rectangle of defined location is transferred
repeatedly to a destination rectangle of defined location, width and height. The
pattern copy is always aligned to an 8 pixel boundary and transfers continue
until the pattern is tiled into the entire destination rectangle. The starting X
coordinate of the source pattern rectangle should always be on an 8 pixel
boundary.
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-9

86CM65 Dual Display Accelerator
S3 Inllorporeted
Short Stroke Vector Transfer Register
| Write Only  |     | Address: 9EE8H  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-On Default: Undefined
This register defines two short stroke vectors. These are drawn one at a time based on the setting of
the BYTE SWAP bit (bit 12) in the Command (9AE8H) register.
| I  I      |               | I  I  I       | 161        |         | I  I  I       |
| --------- | ------------- | ------------- | ---------- | ------- | ------------- |
| 15  14    | 13  12        | 11  10  9  8  | 7          | 5  4    | 3  2  1  0    |
| DRWG-DIR  | DRW           | PIXEL-LENGTH  | DRWG-DIR.  | DRW     | PIXEL-LENGTH  |
| 2  1      | 0  -MV        | 3  2  1  0    | 2  1       | 0  -MV  | 3  2  1  0    |
| Bits 3-0  | PIXEL-LENGTH  |               |            |         |               |
Value = # pixels -1
| Bit 4  | DRW -MV -Draw Pixel  |     |     |     |     |
| ------ | -------------------- | --- | --- | --- | --- |
o  = Move current position only -don't draw
1 = Draw pixel
Bits 7-5  DRWG-DIR.-Select Drawing Direction (measured counterclockwise from the X axis)
000 = 00
001 =450
010 =900
011 = 1350
100 = 1800
101 = 2250
110 =2700
110=3150
| Bits 15-8  | These bits duplicate bits 7-0 to define the second short stroke vector.  |     |     |     |     |
| ---------- | ------------------------------------------------------------------------ | --- | --- | --- | --- |
20-10 ENHANCED COMMANDS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
sa Incorporatad
Background Color Register
Read/Write Address: A2E8H
Power-On Default Undefined
See the Enhanced Mode Bitmap Accessing Through the Graphics Engine section in the Functional
Description for a detailed explanation of how and when this color value is used when writing a pixel
to display memory.
I I I I
15 1 14 1 13 1 12 1 11 1 10 1 9 1 8 1 7 1 6 1 5 1 4 3 2 1 0
BACKGROUND COLOR
I I I I I I I I
31 30 29 28 27 26 25 24 23 1 22 1 21 1 20 1 19 1 18 1 17 1 16
BACKGROUND COLOR
Bits 31-0 BACKGROUND COLOR
If bit 9 of BEE8_EH is set to 1 for programmed I/O (not MMIO), this becomes a 32-bit
register. If bit 9 of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode
with 16-bit registers, the upper and lower doublewords are read or written sequen
tially, depending on the state of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the
lower 16 bits are accessed. If RSF = 1, the upper 16 bits are accessed. The RSF flag
toggles automatically when a doubleword is read or written.
Foreground Color Register
Read/Write Address: A6E8H
Power-On Default: Undefined
See the Enhanced Mode Bitmap Accessing Through the Graphics Engine section in the Functional
Description for a detailed explanation of how and when this color value is used when writing a pixel
to display memory.
I J I
15 14 1 13.1 12 1 11 1 10 1 9 1 8 1 7 1 6 1 5 1 4 1 3 1 2 1 0
FOREGROUND COLOR
I I I I I I I I I I I I I I I
31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16
FOREGROUND COLOR
Bits 31-0 FOREGROUND COLOR
If bit 9 of BEE8_EH is set to 1 for programmed I/O (not MMIO), this becomes a 32-bit
register. If bit 9 of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode
with 16-bit registers, the upper and lower doublewords are read or written sequen
tially, depending on the state of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the
lower 16 bits are accessed. If RSF = 1, the upper 16 bits are accessed. The RSF flag
toggles automatically when a doubleword is read or written.
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-11

86CM65 Dual Display Accelerator
83 Incorporated
Bitplane Write Mask Register
Read/Write Address: AAE8H
Power-On Default: Undefined
I I I I I I I I I I I I I I I
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
BIT-PLANE WRITE MASK
31 1 30 1 29 1 28 1 27 1 26 1 25 1 24 1 23 122 1 21 1 20 1 19 1 18 1 17 1 16
BIT-PLANE WRITE MASK
Bits 31-0 BIT-PLANE WRITE MASK
If bit i = 0, bitplane i is not updated
If bit i = 1, bitplane i is updated
Bits 31-0 control planes 31-0 respectively. If bit 9 of BEE8_EH is set to 1 for pro
grammed I/O (not MMIO), this becomes a 32-bit register. If bit 9 of BEE8_EH is cleared
to 0, this is two 16-bit registers. In 32 bpp mode with 16-bit registers, the upper and
lower doublewords are read or written sequentially, depending on the state of the
RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the lower 16 bits are accessed. If RSF =
1, the upper 16 bits are accessed. The RSF flag toggles automatically when a double
word is read or written.
Bitplane Read Mask Register
Read/Write Address: AEE8H
Power-On Default: Undefined
15 1 14 1 13 1 12 1 11 1 10 1 9 1 8 1 7 1 6 1 5 1 4 1 3 1 2 1 1 1 0
BIT-PLANE READ MASK
I I I I I I I I I I I I I I I
31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16
BIT-PLANE READ MASK
Bits 31-0 BIT-PLANE READ MASK
If bit i = 0, bitplane i is not used as a data source
If bit i = 1, bitplane i is used as a data source
Bit-plane read mask forBitBLT and image transfer functions. Bits 31-0 control planes
31-0 respectively. If bit 9 of BEE8_EH is set to 1 for programmed I/O (not MMIO), this
becomes a 32-bit register. If bit 9 of BEE8_EH is cleared to 0, this is two 16-bit regis
ters. In 32 bpp mode with 16-bit registers, the upper and lower doublewords are read
or written sequentially, depending on the state of the RSF flag (bit 4 of BEE8H, Index
EHI. If RSF = 0, the lower 16 bits are accessed. if RSF = i, the upper 16 bits are ac
cessed. The RSF flag toggles automatically when a doubleword is read or written.
20-12 ENHANCED COMMANDS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
Color Compare Register
| Read/Write  | Address: B2E8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-On Default: Undefined
This register contains the color value that is compared against the current bitmap color if the color
compare option is turned on by setting bit 8 of the Pixel Control (BEE8H, Index OEH) to 1. Bit 7 of the
Pixel Control register determines whether a match or a non-match results in a pixel update.
| I  I        | I  i  1     | 1  J  I  | 1  J  l  | 1  I  I  | J   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
COMPARISON COLOR WITH SOURCE
| I  I  | I  I  I  | I  I  I  | I  I  I  | I  I  I  | I   |
| ----- | -------- | -------- | -------- | -------- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
COMPARISON COLOR WITH SOURCE
| Bits 31-0  COMPARISON COLOR WITH SOURCE  |     |     |     |     |     |
| ---------------------------------------- | --- | --- | --- | --- | --- |
If bit 9 of BEE8_EH is set to 1 for programmed I/O (not MMIO), this becomes a 32-bit
register. If bit 9 of BEE8_EH is cleared to 0, this is two 16-bit registers. In 32 bpp mode
with 16-bit registers, the upper and lower doublewords are read or written sequen
tially, depending on the state of the RSF flag (bit 4 of BEE8H, Index EH). If RSF = 0, the
lower 16 bits are accessed. If RSF = 1, the upper 16 bits are accessed. The RSF flag
toggles automatically when a doubleword is read or written.
Background and Foreground Mix Registers
| Read/Write  | Address: B6E8H (Background), BAE8H (Foreground)  |     |     |     |     |
| ----------- | ------------------------------------------------ | --- | --- | --- | --- |
Power-On Default: Undefined
See the Enhanced Mode Bitmap AcceSSing Through the Graphics Engine section in the Functional
Description for a detailed explanation of how and when these registers are used when writing a pixel
to display memory.
|             |             |          | I        | I  I      | I   |
| ----------- | ----------- | -------- | -------- | --------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1   | 0   |
|             |             |          | CLR-SRC  | MIX-TYPE  |     |
| R  R  R     | R  R  R     | R  R  R  | 1  0  R  | 3  2  1   | 0   |
Bits 3-D
MIX-TYPE -Select Mix Type
In the general case, a new color is defined. A logical operation such as AND or OR is
then performed between it and the current bitmap color. If the bitplane to be written
is enabled, the result of this logical "mix" is written to the bitmap as the new pixel
color. The following table shows the mix types available (I = logical NOT).
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-13

••
r
86CM65 Dual Display Accelerator
sa Inoorporeted
|                                         | 0000  !current             |     | 1000  !current OR !new      |     |
| --------------------------------------- | -------------------------- | --- | --------------------------- | --- |
|                                         | 0001  logical zero         |     | 1001  current OR Inew       |     |
|                                         | 0010  logical one          |     | 1010  Icurrent OR new       |     |
|                                         | 0011  leave current as is  |     | 1011  current OR new        |     |
|                                         | 0100  !new                 |     | 1100  current AND new       |     |
|                                         | 0101  current XOR new      |     | 1101  !current AND new      |     |
|                                         | 0110  !(current XOR new)   |     | 1110  current AND !new      |     |
|                                         | 0111  new                  |     | 1111  ! current AN D !n ew  |     |
| Bit 4  Reserved                         |                            |     |                             |     |
| Bits 6-5  ClR-SRC -Select Color Source  |                            |     |                             |     |
00 = Background Color register is the color source
01 = Foreground Color register is the color source
10 = CPU data (the CPU is the color source)
11 = Display memory (the display memory is the color source)
| Bits 15-7  Reserved  |     |     |     |     |
| -------------------- | --- | --- | --- | --- |
Read Register Data Register
| Read Only  | Address: BEE8H  |     |     |     |
| ---------- | --------------- | --- | --- | --- |
Power-On Default: Undefined
A read of this register produces a read of the register speCified by bits 2-0 of the Read Register Select
(BEE8H, Index OFH) register. Each read of BEE8H causes the read index (bits 2-0 of BEE8H, Index OFH)
to increment by one. Registers BEE8H, Indices OH to OEH, 9AE8H and 42E8H can thus be rapidly read
by successive reads from BEE8H.
Note: Writes to the BEE8H registers (exceptthe read index register, Index OFH) are pipelined. Therefore,
to correctly read back a write to one of these registers, issue a NOP drawing command (a write to
9AE8H with bits 15-13 programmed to OOOb) immediately after the BEE8H register write. Next, write
the desired register index to BEE8H, Index OFH and read the data from BEE8H.
The BEE8H registers are written directly by writing to BEE8H with the appropriate register index in bits
15-12.
o
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  |
| ----------- | ----------- | -------- | -------- | -------- |
20-14 ENHANCED COMMANDS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Incorpont.d
Minor Axis Pixel Count Register
Write Only Address: BEE8H, Index OH
Power-On Default: Undefined
This register specifies the height for rectangles, image transfers, BitBLT s and PatBL Ts.
Bits 11-0 RECTANGLE HEIGHT
Value = (number of pixels in the height ofthe rectangle) -1
Bits 15-12 INDEX = OH
Top Scissors
Write Only Address: BEE8H, Index 1H
Power-On Default: Undefined
This register specifies the top of the clipping rectangle. It is the lowest Y value that will be drawn.
Bits 11-0 CLIPPING TOP LIMIT
Bits 15-12 INDEX = 1H
Left Scissors
Write Only Address: BEE8H, Index 2H
Power-On Default: Undefined
This register specifies the left side of the clipping rectangle. It is the lowest X value that will be drawn.
Bits 11-0 CLIPPING LEFT LIMIT
Bits 15-12 INDEX = 2H
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-15

86CM65 Dual Display Accelerator
S3 Inoorporatod
Bottom Scissors
| Write Only  | Address: BEE8H, Index 3H  |     |     |     |     |
| ----------- | ------------------------- | --- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the bottom of the clipping rectangle. It is the highest Yvalue that will be drawn.
| Bits 11-0  CLIPPING BOTTOM LIMIT  |     |     |     |     |     |
| --------------------------------- | --- | --- | --- | --- | --- |
| Bits 15-12  INDEX = 3H            |     |     |     |     |     |
Right Scissors
| Write Only  | Address: BEE8H, Index 4H  |     |     |     |     |
| ----------- | ------------------------- | --- | --- | --- | --- |
Power-On Default: Undefined
This register specifies the right side of the clipping rectangle. It is the highest X value that will be drawn.
| Bits 11-0  CLIPPING RIGHT LIMIT  |     |     |     |     |     |
| -------------------------------- | --- | --- | --- | --- | --- |
| Bits 15-12  INDEX = 4H           |     |     |     |     |     |
Pixel Control Register
| Write Only  | Address: BEE8H, Index OAH  |     |     |     |     |
| ----------- | -------------------------- | --- | --- | --- | --- |
Power-On Default: Undefined
See Bitmap Access Through the Graphics Engine in the Enhanced Mode Programming section for an
explanation of how and when bits 7-6 of this register are used when writing a pixel to display memory.
I
| 15  14  13  | 12  11  10  | 9  8  | 7  6  5  | 4  3  2  | 1  0  |
| ----------- | ----------- | ----- | -------- | -------- | ----- |
DT-EX-SRC
| 1  0  1             | 0  R  R  | R  R  | 1  0  R  | R  R  R  | R  R  |
| ------------------- | -------- | ----- | -------- | -------- | ----- |
| Bits 5-0  Reserved  |          |       |          |          |       |
20-16 ENHANCED COMMANDS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorporeted
Bits 7-6 DT-EX-SRC -Select Mix Register
00 = Foreground Mix register is always selected
01 = Reserved
10 = CPU data determines Mix register selected
11 = Display memory current value determines Mix register selected
Bits 11-8 Reserved
Bits 15-12 INDEX = OAH
Multifunction Control Miscellaneous 2 Register
Write Only Address: BEE8H, Index ODH
Power-On Default: DOOOH
Bits 2-0 DST-BASE -Destination Base Address
000 = First destination memory address is in the 1st MByte of display memory
001 = First destination memory address is in the 2nd MByte of display memory
010 = First destination memory address is in the 3rd MByte of display memory
011 = First destination memory address is in the 4th MByte of display memory
This field supersedes bits 1-0 of BEE8H, Index E if any of these 3 bits are set to 1.
Bit 3 Reserved
Bits 6-4SRC-BASE -Source Base Address
000 = First source memory address is in the 1st MByte of display memory
001 = First source memory address is in the 2nd MByte of display memory
010 = First source memory address is in the 3rd MByte of display memory
011 = First source memory address is in the 4th MByte of display memory
This field supersedes bits 3-2 of BEE8H, Index E if any of these three bits are set to 1.
Bits 11-7 Reserved
Bits 15-12 INDEX = ODH
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-17

••
r
86CM65 Dual Display Accelerator
sa Incorpogted
Multifunction Control Miscellaneous Register
| Write Only  |     | Address: BEE8H, Index OEH  |     |     |     |
| ----------- | --- | -------------------------- | --- | --- | --- |
Power-On Default: EOOOH
| 15  14  13                                                    | 12  11  | 10  9          | 8  7  6      | 5  4  1      | 1        |
| ------------------------------------------------------------- | ------- | -------------- | ------------ | ------------ | -------- |
|                                                               |         |                |              | 3  2         | 1  0     |
|                                                               |         | 1C  CMR  ENB   | SRC  EXT     | RSF  SRC-BA  | DEST-BA  |
| 1  1  1                                                       | 0  R    | EDO  32B  CMP  | NE  R  CLIP  | 21  20       | 21  20   |
| Bits 1-0  DEST-BA 21 20 -Destination Base Address Bits 21-20  |         |                |              |              |          |
00 = First destination memory address is in the 1st MByte of display memory
01 = First destination memory address is in the 2nd MByte of display memory
10 = First destination memory address is in the 3rd MByte of display memory
11 = First destination memory address is in the 4th MByte of display memory
This field is superseded by bits 2-0 of BEE8H, Index D if any of the BEE8H Index D bits
is setto 1.
| Bits 3-2  SRC-BA 21 20 -Source Base Address Bits 21-20  |     |     |     |     |     |
| ------------------------------------------------------- | --- | --- | --- | --- | --- |
00 = First source memory address is in the 1st MByte of display memory
01 = First source memory address is in the 2nd MByte of display memory
10 = First source memory address is in the 3rd MByte of display memory
11 = First source memory address is in the 4th MByte of display memory
This field is superseded by bits 6-4 of BEE8H Index D if any of the BEE8H Index D bits
is setto 1.
| Bit 4  RSF -Select Upper Word in 32 Bits/Pixel Mode  |     |     |     |     |     |
| ---------------------------------------------------- | --- | --- | --- | --- | --- |
o
= Selects lower 16 bits for accesses to 32-bit registers in 32 bpp mode
1 = Selects upper 16 bits for accesses to 32-bit registers in 32 bpp mode
| Bit 5  EXT CLIP -Enable External Clipping  |     |     |     |     |     |
| ------------------------------------------ | --- | --- | --- | --- | --- |
o
= Only pixels inside the clipping rectangle are drawn
1 = Only pixels outside the clipping rectangle are drawn
| Bit 6  Reserved                                                                |     |     |     |     |     |
| ------------------------------------------------------------------------------ | --- | --- | --- | --- | --- |
| Bit 7  SRC NE -Don't Update Bitmap if Source Not Equal to Color Compare Color  |     |     |     |     |     |
o  = Don't update current bitmap if the Color Compare (B2E81 register value is equal to
the color value of the source bitmap
1 = Don't update current bitmap if the Color Compare (B2E81 register value is not
equal to the color value of the source bitmap
This bit is only active if bit 8 of this register is set to 1.
| Bit 8  ENB CMP -Enable Color Compare  |     |     |     |     |     |
| ------------------------------------- | --- | --- | --- | --- | --- |
o  = Disable color comparison
1 = Enable color comparison
20-18 ENHANCED COMMANDS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
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
Read Register Select Register
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
1000 = 42E8H (Bits 15-12 ofthe read data are forced to 0)
1001 = Reserved
1010 = BEE8H, Index ODH
The read register index increments by one with each reading of BEE8H.
Bits 11-4 Reserved
Bits 15-12 INDEX = OFH
ENHANCED COMMANDS REGISTER DESCRIPTIONS 20-19

86CM65 Dual Display Accelerator
sa lnoorpot'. ....
Pixel Data Transfer Register
Write Only Address: E2E8H
Power-On Default: Undefined
A" data from the CPU to the Graphics Engine must pass through this register.
Bits 15-0 IMAGE WRITE DATA
Pixel Data Transfer -Extension Register
Write Only Address: E2EAH
Power-On Default: Undefined
This register is an extension of E2E8H for 32-bit operations .
. Bits 15-0 IMAGE WRITE DATA
20-20 ENHANCED COMMANDS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorpora.ad
Section 21: Streams Processor Register Descriptions
Streams Processor registers can only be accessed via memory-mapped 1/0. The register identifier
MMxxxx means that this register is memory mapped at offset xxxx.
Primary Stream Contro11MM8180)
| Read/Write  | Address: B1BOH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
| 15  14  13  | 12  11  10  | 9  8  | 7  6  5  | 4  3  2  | 1  0  |
| ----------- | ----------- | ----- | -------- | -------- | ----- |
| R  R  R     | R  R  R     | R  R  | R  R  R  | R  R  R  | R  R  |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| R  PSFC                                              | R   | PSIDF  | R  R  R  | R  R  R  | R  R  |
| ---------------------------------------------------- | --- | ------ | -------- | -------- | ----- |
| Bits 23'()  Reserved                                 |     |        |          |          |       |
| Bits 26-24  PSIDF -Primary Stream Input Data Format  |     |        |          |          |       |
000 = RGB-B ICLUn
001 = Reserved
010 = Reserved
011 = KRGB-16 11.5.5.5)
100 = Reserved
101 = RGB-16 (5.6.5)
110 = RGB-24IB.B.B)
111 = XRGB-32 (X.B.B.B)
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

86CM65 Dual Display Accelerator
83 Incorporated
Color/Chroma Key ControIIMM8184)
| Read/Write  | Adds: 8184H  |     |     |
| ----------- | ------------ | --- | --- |
Power-on Default: OOOOOOOOH
|     | I  I  | I  I  I  | I  I  I  |
| --- | ----- | -------- | -------- |
15  I  14  I  13  I  12  11  10  9  8  7  6  5  4  3  121  1  I  0
|     | G/U/Cb KEY (LOW)  |     | BNlCr KEY (LOW)  |
| --- | ----------------- | --- | ---------------- |
31130J29j28I27126125124  23  I  22  I  21  I  20  I  19  I  18  I  17.1  16
| I  I                                                  | I  I  I  |        |                |
| ----------------------------------------------------- | -------- | ------ | -------------- |
| R  R  R                                               | KC  R    | RGBCC  | R!Y KEY (LOW)  |
| Bits 7-0  BN/Cr key value (lower bound for chroma)    |          |        |                |
| Bits 15-8  G/U/Cb key value (lower bound for chroma)  |          |        |                |
| Bits 23-16  R/Y key value (lower bound for chroma)    |          |        |                |
| Bits 26-24  RGB CC -RGB Color Comparison Precision    |          |        |                |
000 = Compare bit 7 of RGB (compare red bit 7'5, green bit 7's and blue bit 7's)
001 = Compare bits 7-6 of RGB
010 = Compare bits 7-5 of RGB
011 = Compare bits 7-4 of RGB
100 = Compare bits 7-3 of RGB
101 = Compare bits 7-2 of RGB
110 = Compare bits 7-1 of RGB
111 = Compare bits 7-0 of RGB
| Bit 27  Reserved          |     |     |     |
| ------------------------- | --- | --- | --- |
| Bit 28  KC -Key Controll  |     |     |     |
0= Extract key data from input stream key bit lif present). (KRGB-16, 1.5.5.5 only)
If the K bit is 0, the pixel from the other stream is used (transparent). If the K bit is
1, the key bit streams pixel is used (opaque)
1 = Enable color or chroma keying for all modes other than KRGB-16
| Bits 31-29  Reserved  |     |     |     |
| --------------------- | --- | --- | --- |
21-2 STREAMS PROCESSOR REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorpora''''
Secondary Stream Control (MM8190)
Read/Write Address: 8190H
Power-on Default: OOOOOOOOH
I I I I I I I I I I I
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
R R R R DDA HORIZONTAL ACCUMULATOR
I I I I I I I I I I I
31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16
I I I I I I I I I
R SFC SDIF R R R R R R R R
Bits 11-0 DDA Horizontal Accumulator Initial Value
Value = 2 (WO-1) -/W1-1), where WO is the line width in pixels before scaling and W1
is the line width in pixels after scaling. This is a signed value.
When this field is programmed, the value does not take effect until the next VSYNC.
Bits 23-12 Reserved
Bits 26-24 SDIF -Secondary Stream Input Data Format
000 = Reserved
001 = YCbCr-16 /4.2.2), 16-240 input range
010 = YUV-16 /4.2.2), 0-255 input range
011 = KRGB-16 /1.5.5.5)
100 = YUV /2.1.1)
101 = RGB-16 /5.6.5)
110 = RGB-24 /8.8.8)
111 = XRGB-32 /X.8.8.8
When this field is programmed, the value does not take effect until the next VSYNC.
Bit 27 Reserved
Bits 30-28 SFC -Secondary Stream Filter Characteristics
000 = Secondary stream
001 = Secondary stream, linear, 0-2-4-2-0, for X stretch
010 = Secondary stream, bi-linear, for 2X to 4X stretch
011 = Secondary stream, linear, 1-2-2-2-1, for 4X stretch
Other values reserved
When this field is programmed, the value does not take effect until the next VSYNC.
Bit 31 Reserved
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-3

86CM65 Dual Display Accelerator
sa Inoorporateci
Chroma Key Upper Bound (MM8194)
| Read/Write  | Address: 8194H  |     |
| ----------- | --------------- | --- |
Power-on Default: OOOOOOOOH
15  1 14  1 13  1 12  1 11  1 10  1  9  1  8  71615141312111 0
U/Cb KEY (UPPER)  VlCr KEY (UPPER)
31130129128127126125124  23  1 22  1 21  1 20  1 19  1 18  1 17  1 16
RIRIRIRIRJRLRIR  Y KEY (UPPER)
| Bits 7-0  VlCr key value (upper bound)   |     |     |
| ---------------------------------------- | --- | --- |
| Bits 15-8  U!Cb key value (upper bound)  |     |     |
| Bits 23-16  Y key value (upper bound)    |     |     |
| Bits 31-24  Reserved                     |     |     |
Secondary Stream Stretch/Filter Constants (MM8198)
| Read/Write  | Address: 8198H  |     |
| ----------- | --------------- | --- |
Power-on Default: OOOOOOOOH
15  14  13  12  11  10  1  9  1  8  1  7  1  6  1  5  1  4  1  3  1  2  1  1  1  0
| R  R  R  | R  R  | K2 HORIZONTAL SCALE FACTOR  |
| -------- | ----- | --------------------------- |
31  30  29  28  27  26  1 25  1 24  1 23  1 22  1 21  1 20  1 19  1 18  1 17  1 16
R
| R  R                                   | R  R  | Kl HORIZONTAL SCALE FACTOR  |
| -------------------------------------- | ----- | --------------------------- |
| Bits 10-0  K1 Horizontal Scale Factor  |       |                             |
Value =W
O-1, where WO is the width in pixels of the initial output window (before
scaling)
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 15-11  Reserved                    |     |     |
| --------------------------------------- | --- | --- |
| Bits 26-16  K2 Horizontal Scale Factor  |     |     |
Value = WO-W1, where WO is the initial (unsealed) window width in pixels and W1 is
the final output window width in pixels. This is a signed value and will always be
negative.
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 31-27  Reserved  |     |     |
| --------------------- | --- | --- |
21-4 STREAMS PROCESSOR REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
Blend Control (MM81AO)
| Read/Write  | Address: 81AOH  |     |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
|             | I  I        |       |       |       | I  I  |       |
| ----------- | ----------- | ----- | ----- | ----- | ----- | ----- |
| 15  14  13  | 12  11  10  | 9  8  | 7  6  | 5  4  | 3  2  | 1  0  |
| R  R  R     | KP          | R  R  | R  R  | R     | KS    | R  R  |
31  30  29  28127126  25  24  23  22  21  20  1 19  1 18  17  16
|                     | I  I             |     |       |       | I  I  |       |
| ------------------- | ---------------- | --- | ----- | ----- | ----- | ----- |
| R  R  R             | R  R  COMP MODE  |     | R  R  | R  R  | R  R  | R  R  |
| Bits 1-0  Reserved  |                  |     |       |       |       |       |
Ks
Bits4-2
Value = secondary stream blend coefficient
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 9-5  Reserved  |     |     |     |     |     |     |
| ------------------- | --- | --- | --- | --- | --- | --- |
| Bits 12·10  Kp      |     |     |     |     |     |     |
Value = primary stream blend coefficient
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 23·13  Reserved      |     |     |     |     |     |     |
| ------------------------- | --- | --- | --- | --- | --- | --- |
| Bits 26-24  Compose Mode  |     |     |     |     |     |     |
. 000 = Secondary stream opaque overlay on primary stream
001 = Primary stream opaque overlay on secondary stream
010 = Dissolve, !Pp x Kp + Ps x (8 -Kp)1I8, ignore Ks
011 = Fade, !Pp x Kp + Ps x Ks1/8, where Kp + Ks must be ~ 8
100 = Reserved
101 = Color key on primary stream (secondary stream overlay on primary stream)
110 = Color or chroma key on secondary stream (primary stream overlay on
secondary stream)
111 = Reserved
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 31·27  Reserved  |     |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- | --- |
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-5

86CM65 Dual Display Accelerator
S3 Incorporated
Primary Stream Frame Buffer Address 0 (MM81CO)
| Read/Write  | Address: 81COH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
If a primary stream is enabled, this register specifies the starting address in the frame buffer.
| I  I        | I  I  I     | I  I  I  | I  I  I  | I  I  I  | I   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
PRIMARY BUFFER ADDRESS 0
| I  I  | I  I  I  | I  I  I  | I  I  I  | I  I  I  | I   |
| ----- | -------- | -------- | -------- | -------- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| I  I     | I  I  I  | I  I  I  | I  I                         |     |     |
| -------- | -------- | -------- | ---------------------------- | --- | --- |
| R  R  R  | R  R  R  | R  R  R  | R  PRIMARY BUFFER ADDRESS 0  |     |     |
Value = Primary stream frame buffer starting address 0
Bits 21-0
This value must be quadword aligned.
| Bits 31·22  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
Primary Stream Frame Buffer Address 1 (MM81C4)
| Read/Write  | Address: 81C4H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
If the primary stream is double buffered, this register specifies the starting address in the frame buffer
for the second buffer.
| I  I        | I  I  I     | I  I  I  | I  I  I  | I  I  I  | I   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
PRIMARY BUFFER ADDRESS 1
| I  I  | I  I  I  | I  I  I  | I  I  I  | I  I  I  | I   |
| ----- | -------- | -------- | -------- | -------- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| I  I     | I  I  I  | I  I  I  | I  I                         |     |     |
| -------- | -------- | -------- | ---------------------------- | --- | --- |
| R  R  R  | R  R  R  | R  R  R  | R  PRIMARY BUFFER ADDRESS 1  |     |     |
Value = Primary stream frame buffer starting address 1
Bits 21-0
This value must be quadword aligned.
| Bits 31·22  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
21-6 STREAMS PROCESSOR REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorporatod
Primary Stream Stride (MM81C8)
| Read/Write  |     | Address: 81C8H  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-on Default: Undefined
|             |     | I  I  I    | I  I  I                | I  I  I  | I  I     |
| ----------- | --- | ---------- | ---------------------- | -------- | -------- |
| 15  14  13  | 12  | 11  10  9  | 8  7  6                | 5  4  3  | 2  1  0  |
| R  R  R     | R   |            | PRIMARY STREAM STRIDE  |          |          |
|             |     | I  I  I    | I  I  I                | I  I  I  | I  I     |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
|                                   |     | I  I  I  | I  I  I  | I  I  I  | I  I     |
| --------------------------------- | --- | -------- | -------- | -------- | -------- |
| R  R  R                           | R   | R  R  R  | R  R  R  | R  R  R  | R  R  R  |
| Bits 11-0  Primary stream stride  |     |          |          |          |          |
Value = byte offset of vertically adjacent pixels in the primary stream buffer(s)
If double buffering is used, the stride must be the same for both buffers.
| Bits 31-12  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
Double Buffer/LPB Support (MM81CC)
| Read/Write  |     | Address: 81CCH  |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- |
Power-on Default: xxxxxxOOH
I
| 15  14  13  | 12  | 11  10  9  | 8  7  6    | 5  4  3      | 2  1  0   |
| ----------- | --- | ---------- | ---------- | ------------ | --------- |
| R  R  R     | R   | R  R  R    | R  R  LST  | LSL  LIS  R  | SBS  PBS  |
I
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
I
| R  R  R                                   | R   | R  R  R  | R  R  R  | R  R  R  | R  R  R  |
| ----------------------------------------- | --- | -------- | -------- | -------- | -------- |
| Bit 0  PBS -Primary Stream Buffer Select  |     |          |          |          |          |
0= Primary frame buffer starting address 0 (MM81CO_21-0) used for the primary
stream
1 = Primary frame buffer starting address 1 (MM81C4_21-0) used for the primary
stream
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-7

86CM65 Dual Display Accelerator
83 Incorporated
Bits 2-1 SBS -Secondary Stream Buffer Select
00 = Secondary frame buffer starting address 0 (MMB1 DO_21-0) used for the
secondary stream
01 = Secondary frame buffer starting address 1 (MMB1D4_21-O) used for the
secondary stream
10 = Secondary frame buffer starting address 0 (MMB1DO_21-0) used for the
secondary stream and LPB frame buffer starting address 0 (MMFFOC_21-0) used
for the LPB input stream OR secondary frame buffer starting address 1
(MMB1D4_21-0) used for the secondary stream and LPB frame buffer starting
address 1 (MMFF10_21-0) used for the LPB input stream. Which alternative
applies is determined by LPB starting address register selected by bit 4 of this
register
11 = Secondary frame buffer starting address 0 (MMB1DO_21-0) used for the
secondary stream and LPB frame buffer starting address 1 (MMFF10_21-0) used
for the LPB input stream OR secondary frame buffer starting address 1
(MMB1 D4_21-0) used for the secondary stream and LPB frame buffer starting
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
o
= The value programmed into bit 4 of this register takes effect immediately
1 = The value programmed into bit 4 of this register takes effect at the next end of
frame (completion of writing all the data for a frame into the frame buffer)
Bit 6 LST -LPB Input Buffer Select Toggle
o
= End of frame (completion of writing all the data for a frame into the frame buffer)
has no effect on the setting of bit 4 of this register
1 = End of frame causes the setting of bit 4 of this register to toggle
Bits 31-7 Reserved
21-B STREAMS PROCESSOR REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 Incorpor.ucil
Secondary Stream Frame Buffer Address 0 (MM81DO)
| Read/Write  | Address: 81DOH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
If a secondary stream is enabled, this register specifies the starting address in the frame buffer
| I  I        | I  I  I     | I  I  I  | I  I  I  | I  I  I  | I   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
SECONDARY BUFFER ADDRESS 0
I
,  30  ,  29  ,  28  27  ,  26  ,  25  ,  24  ,  23  ,  22  ,  21  ,  20  ,  19  ,  18  ,  17  ,  16
31
R  ,  R  ,  R  ,  R  ,  R  ,  R  ,  R  ,  R  ,  R  ,  R  ,  SECONDARY BUFFER ADDRESS 0
| Bits 21-0  Value = Secondary stream frame buffer starting address 0  |     |     |     |     |     |
| -------------------------------------------------------------------- | --- | --- | --- | --- | --- |
This value must be quadword aligned.
| Bits 31-22  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
Secondary Stream Frame Buffer Address 1 (MM81D4)
| Read/Write  | Address: 81D4H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
If the secondary stream is double buffered, this register specifies the starting address in the frame
buffer for the second buffer.
| J   | J   | 1   |     |     |     |
| --- | --- | --- | --- | --- | --- |
15  14  ,  13  ,  12  11  ,  10  ,  9  8  ,  7  ,  6  ,  5' 4  ,  3  ,  2  ,  1  ,  0
SECONDARY BUFFER ADDRESS 1
| I  I  | I  I  I  | I  I  I  | I  I  I  | I  I  I  | I   |
| ----- | -------- | -------- | -------- | -------- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
R  I  R  I  R  I  R  I  R  I  R  I  R  I  R  I  R  I  R  I  SECONDARY BUFFER ADDRESS 1
| Bits 21-0  Value = Secondary stream frame buffer starting address 1  |     |     |     |     |     |
| -------------------------------------------------------------------- | --- | --- | --- | --- | --- |
This value must be quadword aligned.
| Bits 31-22  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-9

86CM65 Dual Display Accelerator
sa Incorporated
Secondary Stream Stride (MM81D8)
| Read/Write  |     | Address: 81D8H  |     |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- | --- |
Power-on Default: Undefined
|         |         | I       | I  I  | I  I  I                  | I     | I  I  | I     | I   |
| ------- | ------- | ------- | ----- | ------------------------ | ----- | ----- | ----- | --- |
| 15  14  | 13  12  | 11  10  | 9     | 8  7  6                  | 5  4  | 3     | 2  1  | 0   |
| R  R    | R  R    |         |       | SECONDARY STREAM STRIDE  |       |       |       |     |
31  30  29  28  27  1 26  1 25  1 24  1 23  1 22  1 21  1 20  1  19  1  18  1  17  1  16
|            |                          | I     | I  I  | I  I  I  | I     | I  I  | I     | I   |
| ---------- | ------------------------ | ----- | ----- | -------- | ----- | ----- | ----- | --- |
| R  R       | R  R                     | R  R  | R     | R  R  R  | R  R  | R     | R  R  | R   |
| Bits 11-0  | Secondary stream stride  |       |       |          |       |       |       |     |
=
Value  byte offset of vertically adjacent pixels in the secondary stream buffer(s)
If double buffering is used, the stride must be the same for both buffers.
| Bits 31-12  | Reserved  |     |     |     |     |     |     |     |
| ----------- | --------- | --- | --- | --- | --- | --- | --- | --- |
Opaque Overlay Control (MM81 DC)
| Read/Write  |     | Address: 81DCH  |     |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- | --- |
Power-on Default: Undefined except bits 31-30 are OOb.
When an opaque overlay mode is being used (bits 26-24 of MM81AO = OOOb or 001b), the fields in this
register can be programmed to eliminate the fetching of the pixels for the rectangular area under the
top (opaque) window. This reduces the memory bandwidth requirements. The bottom window should
be full-screen when this feature is enabled. None of the fields in this register have an effect unless bit
31 is set to 1. Note that only horizontal coordinates must be specified. The vertical coordinates are
handled automatically by the hardware.
15  14  13  12  11  10  1  9  I  8  J  7  1  6  I  5  J  4  I  3  2  1  0
|       | 1   | 1   |                   |     |     |     |       |     |
| ----- | --- | --- | ----------------- | --- | --- | --- | ----- | --- |
| R  R  | R   |     | PIXEL STOP FETCH  |     |     |     | R  R  | R   |
|       | I   | I   | I  I              |     |     |     |       |     |
31  30  29  28  27  26  25  24  1 23  1 22  I·  21  1 20  1  19  18  17  16
| DOC  TSS  | R         |     | PIXEL RESUME FETCH  |     |     |     | R  R  | R   |
| --------- | --------- | --- | ------------------- | --- | --- | --- | ----- | --- |
| Bits 2-0  | Reserved  |     |                     |     |     |     |       |     |
21-10 STREAMS PROCESSOR REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorponted
Bits 12-3 Pixel Stop Fetch
Value = [Offset in quadwords from the background starting pixel horizontal position
to the first pixel of the line not to be fetched from memory (hidden background)] + 1
quadword
If the primary stream is the background, MM81 FO_26-16 define the starting position
for each line in the background window (XO) and MM81F8_26-16 define the first pixel
position for each line in the top window (X1). The latter is the first background pixel
that does not need to be fetched. The value programmed in this field is then [(X1 -
XO) x bytes per pixel/8] + 1. If the result is a fraction, it is rounded up the next highest
integer. This gives the required quadword offset (0) for this field. This value is also
used in the calculation for the field value of bits 28-19 of this register.
If the secondary stream is the background, the value is [(XO -X1) x bytes per pixel/8]
+ 1.
Bits 18·13 Reserved
Bits 28·19 Pixel Resume Fetch
Value = {Offset in quadwords from the background starting pixel horizontal position
to the line position of the resumption of pixel fetching from memory (i.e., visible back
ground)} -1 quadword
The value is determined by adding the Pixel Stop Fetch field value (0) above (bits 12-
3) to the width in quadwords of the top window (W). The width of the top window in
pixels (P) is found in MM81 F4_26-16 if the primary stream is on top and in
MM81FC_26-16 if the secondary stream is on top. W in quadwords = P x bytes per
pixel/8. If this is a fraction, the result is truncated to the next lowest integer. The value
in this field is then [W + 0]-1.
Bit 29 Reserved
Bit 30 TSS -Top Stream Select
o
= Secondary stream on top
1 = Primary stream on top
Bit 31 OOC -Opaque Overlay Control Enable
o = Opaque overlay control disabled
1 = Opaque overlay control enabled
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-11

86CM65 Dual Display Accelerator
S3 lnoorporated
K1 Vertical Scale Factor (MM81EO)
| ReadJWrite  | Address: 81EOH  |     |     |     |     |
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
Value = (height (in lines) of the initial output window (before scaling)) -1
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 31-11  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
K2 Vertical Scale Factor (MM81E4)
| ReadJWrite  | Address: 81E4H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
|             |         | I  I   | I  I  I  L                | I  I  I  | I     |
| ----------- | ------- | ------ | ------------------------- | -------- | ----- |
| 15  14  13  | 12  11  | 10  9  | 8  7  6  5                | 4  3  2  | 1  0  |
| R  R  R     | R  R    |        | K2 VERTICAL SCALE FACTOR  |          |       |
|             |         | I  I   | I  I  I  I                | I  I  I  | I     |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
|                                      |       | I  I  | I  I  I  J  | I  I  I  | I     |
| ------------------------------------ | ----- | ----- | ----------- | -------- | ----- |
| R  R  R                              | R  R  | R  R  | R  R  R  R  | R  R  R  | R  R  |
| Bits 10-0  K2 Vertical Scale Factor  |       |       |             |          |       |
Value = (height (in lines) of the initial output window (before scaling)l-(height (in
lines) of the final output window (after scaling)]
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 31-11  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
21-12 STREAMS PROCESSOR REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorporated
DDA Vertical Accumulator Initial Value (MM81E8)
| ReadIWrite  | Address: 81E8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
| 15  14  13  | 12            | I                         | 1  I     | 1              |          |
| ----------- | ------------- | ------------------------- | -------- | -------------- | -------- |
|             | 11  I  10  I  | 9  I  8  7                | 6  I  5  | 4  3  I  2  I  | 1  I  0  |
| R  R  R     | R             | DDA VERTICAL ACCUMULATOR  |          |                |          |
31  30  29  28  27  1 26  1 25  1 24  1 23  1 22  1 21  1 20  1 19  1 18  1 17  1 16
R  R  R  R  R  1  R  1  R  1  R  l  R  1  R  1  R  1  R  1  R  1  R  1  R  1  R
| Bits 11-0  DDA Vertical Accumulator Initial Value  |     |     |     |     |     |
| -------------------------------------------------- | --- | --- | --- | --- | --- |
Value = 2's complement of [height (in lines) of the output window after scaling] -1
When this field is programmed, the value does not take effect until the next VSYNC.
| Bits 31·12  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
Streams FIFO and RAS Controls (MM81 ECI
| ReadIWrite  | Address: 81ECH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: 00003000H
I  J
15  14  I  13  12  I  11  10  9  I  8  I  7  I  6  I  5  4  I  3  I  2  I  1  I  0
| RL  PFIFO THRESHOLD  |     | SFIFO THRESHOLD  |     | FIFO ALLOCATION  |     |
| -------------------- | --- | ---------------- | --- | ---------------- | --- |
31  30129128127126  25124123122121  20  1 19  1 18  117  1 16
R  RIRlRJRLR  R  I  R  I  R  I  R  I  R  R  I  R  I EWS I  R  I  RP
| Bits 4-0  Streams FIFO Allocation  |     |     |     |     |     |
| ---------------------------------- | --- | --- | --- | --- | --- |
00000 = Primary Stream = 24 slots, Secondary Stream = 0 slots
01000 = Primary Stream = 16 slots, Secondary Stream = 8 slots
01100 = Primary Stream = 12 slots, Secondary Stream =12 slots
10000 = Primary Stream = 8 slots, Secondary Stream = 16 slots
11000 = Primary Stream = 0 slots, Secondary Stream = 24 slots
All other values are reserved and must not be programmed. Each slot holds one
quadword.
| Bits 9-5  Secondary FIFO Threshold  |     |     |     |     |     |
| ----------------------------------- | --- | --- | --- | --- | --- |
Value = Number of secondary FIFO slots
When the secondary FIFO empties down to this value, an internal signal is generated
requesting re-filling of the secondary FIFO. This value must be less than or equal to
the secondary stream FIFO size speCified in bits 4-0.
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-13

86CM65 Dual Display Accelerator
83 Incorporated
| Bits 14-10  Primary FIFO Threshold  |     |     |     |     |     |
| ----------------------------------- | --- | --- | --- | --- | --- |
Value = Number of primary FIFO slots
When the primary FIFO empties down to this value, an internal signal is generated re
questing re-filling of the primary FIFO. This value must be less than or equal to the
primary stream FIFO size speCified in bits 4-0.
| Bit 15  RL -RAS Low Time Control  |     |     |     |     |     |
| --------------------------------- | --- | --- | --- | --- | --- |
o
= RAS low time specified by CR68_2 (3.5 or 4.5 MCLKs)
1 = RAS low time = 2.5 MCLKs
| Bit 16  RP -RAS Pre-Charge Control  |     |     |     |     |     |
| ----------------------------------- | --- | --- | --- | --- | --- |
o = RAS pre-charge specified by CR68_3 (2.5 or 3.5 MCLKs)
1 = RAS pre-charge = 1.5 MCLKs
| Bit 17  Reserved                                                     |     |     |     |     |     |
| -------------------------------------------------------------------- | --- | --- | --- | --- | --- |
| Bit 18  EWS -EDO Memory Wait State Control (LPB Memory Cycles Only)  |     |     |     |     |     |
o  = Standard 2-cycle memory operation
1 = 1-cycle EDO memory operation (requires EDO memory capable ofthis)
| Bits 31-19  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
Primary Stream Window Start Coordinates (MM81FOI
| Read/Write  | Address: 81FOH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
|             |         | I  I      | I                       | I  I  I  | I  I     |
| ----------- | ------- | --------- | ----------------------- | -------- | -------- |
| 15  14  13  | 12  11  | 10  9  8  | 7  I  6  I              | 5  4  3  | 2  1  0  |
| R  R  R     | R  R    |           | PRIMARY STREAM Y-START  |          |          |
|             |         | I  I      | I  I  I                 | I  I  I  | I  I     |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| R  R  R                            | R  R  |     | PRIMARY STREAM X-START  |     |     |
| ---------------------------------- | ----- | --- | ----------------------- | --- | --- |
| Bits 10-0  Primary Stream V-Start  |       |     |                         |     |     |
Value = Screen line number +1 of the first line of the primary stream window
| Bits 15-11  Reserved                |     |     |     |     |     |
| ----------------------------------- | --- | --- | --- | --- | --- |
| Bits 26-16  Primary Stream X-Start  |     |     |     |     |     |
Value = Screen pixel number + 1 of the first pixel of the primary stream window
| Bits 31-27  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
21-14 STREAMS PROCESSOR REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
53 Incorponted
Primary Stream Window Size IMM81F4)
| ReadJWrite  | Address: 81F4H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
|             |         | I  I      | I  I  I  I             | I  I  I  | I     |
| ----------- | ------- | --------- | ---------------------- | -------- | ----- |
| 15  14  13  | 12  11  | 10  9  8  | 7  6  5                | 4  3  2  | 1  0  |
| R  R  R     | R  R    |           | PRIMARY STREAM HEIGHT  |          |       |
31  30  29  28  27  26  I  25  I  24  I  23  I  22  1  21  I  20  1  19  I  18  I  17  I  16
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
Secondary Window Start Coordinates IMM81 F8)
| ReadJWrite  | Address: 81F8H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
|             |         | I  I      | I  I  I  I                | I  I  I  | I     |
| ----------- | ------- | --------- | ------------------------- | -------- | ----- |
| 15  14  13  | 12  11  | 10  9  8  | 7  6  5                   | 4  3  2  | 1  0  |
| R  R  R     | R  R    |           | SECONDARY STREAM Y-START  |          |       |
31  30  29  28  27  26  I  25  I  24  I  23  I  22  I  21  I  20  I  19  I  18  I  17  I 16
| R  R  R                              | R  R  |     | SECONDARY STREAM X-START  |     |     |
| ------------------------------------ | ----- | --- | ------------------------- | --- | --- |
| Bits 10-0  Secondary Stream Y-Start  |       |     |                           |     |     |
Value = Screen line number +1 ofthe first line of the secondary stream window
| Bits 15-11  Reserved                  |     |     |     |     |     |
| ------------------------------------- | --- | --- | --- | --- | --- |
| Bits 26-16  Secondary Stream X-Start  |     |     |     |     |     |
Value = Screen pixel number + 1 of the first pixel of the secondary stream window
| Bits 31-27  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
STREAMS PROCESSOR REGISTER DESCRIPTIONS 21-15

86CM65 Dual Display Accelerator
S3 Incorporated
Secondary Window Size (MM81 Fe)
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

••
r
86CM65 Dual Display Accelerator
53 Inoorponoted
Section 22: Local Peripheral Bus Register Descriptions
LPB registers can only be accessed via memory-mapped I/O. The register identifier MMxxxx means
that the register is memory mapped at offset xxxx from the base address.
LPB Mode (MMFFOO)
| Read/Write  | Address: FFOOH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
|             |         |           |          | I        | I     |
| ----------- | ------- | --------- | -------- | -------- | ----- |
| 15  14  13  | 12  11  | 10  9  8  | 7  6  5  | 4  3  2  | 1  0  |
R  R  LBA  CHS  CVS  LHS  LVS  R  R  CBS  SF  LR  LPB MODE  LE
|                        |            | 24       | 23  22  | I           | I  17  |
| ---------------------- | ---------- | -------- | ------- | ----------- | ------ |
| 31  30  29             | 28  27     | 26  25   | 21      | 20  19  18  | 16     |
|                        |            |          |         | I           | I      |
| l)I  BAS  10D          | R  R  ILC  | SNO  CS  | R  VFT  | R  R  R     | MBS    |
| Bit 0  LE -LPB Enable  |            |          |         |             |        |
o = LPB Disabled
1 = LPB Enabled
Once enabled, the LPB is reset either by a system reset or via bit 4 of this register.
| Bits 3-1  LPB MODE  |     |     |     |     |     |
| ------------------- | --- | --- | --- | --- | --- |
000 = SceniC/MX2 Mode. Pins K1 and L 1 act as VREO/VRDY and CREO/CRDY
respectively.
001 = Video 16 Mode. Pins K1 and L 1 act as HS and VS respectively. This mode is
also used for 'Z!V Port operation.
010 = Video 8 In Mode. Pins K1 and L 1 to act as HS and VS respectively and the
86CM65 expects video data in 8-bit units (LD[7:0)).
100 = Pass-through Mode. 32-bit data from the output FIFO is passed directly to the
decimation input to the video FIFO. This allows decimation of CPU-provided
data.
All other values are reserved.
LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS 22-1

86CM65 Dual Display Accelerator
S3 Incorpo...ud
Bit 4 LR-LPB Reset
0= No effect
1 = Reset LPB
This bit should be set and then reset before switching between LPB modes.
Bit 5 SF -Skip Frames
o
= Write all received frames to memory
1 = Write every other received frame to memory (1, 3, etc.)
Bit 6 CBS -Color Byte Swap
0= Incoming video is in U01, Vo, VOl, VI format, byte swap enabled
1 = Incoming video is in Va, U01, VI, Val format (e.g., SM7110), no byte swap
Bits 8-7 Reserved
Bit 9 LVS -LPB Vertical Sync Input Polarity
0= LPB vertical sync input is active low
1 = LPB vertical sync input is active high
Bit 10 LHS -LPB Horizontal Sync Input Polarity
o
= LPB horizontal sync input is active low
1 = LPB horizontal sync input is active high
Bit 11 CVS -CPU VSVNC (Write Only)
Writing a 1 to this bit causes the 86CM65 to do whatever functions it is programmed
to do upon receipt of a VSVNC. For example, values programmed in certain registers
only take effect at the next VSVNC.
Bit 12 CHS -CPU HSVNC (Write Only)
Writing a 1 to this bit causes the 86CM65 to do whatever functions it is programmed
to do upon receipt of an HSVNC.
Bit 13 LBA -Load Base Address (Write Only)
Writing a 1 to this bit immediately loads the base address currently being pointed to.
Bits 15-14 Reserved
Bits 17-16 MBS -Maximum LPB to Scenic/MX2 Compressed Data Burst Size (Scenic/MX2 mode
only)
00 = Burst 1 32-bit word
01 = Burst 2 32-bit words
10 = Burst 3 32-bit words
11 = Burst all 32-bit words (until empty)
With a setting of 11b, software must ensure that no more than eight 32-bit words are
burst to the Scenic/MX2 in a single burst. For example, if the FIFO is full (8 entries),
no more entries should be written until the burst is complete.
Bits 20-18 Reserved
22-2 LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
sa Incorporated
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
o = LPB clock driven by SCLK
1 = LPB clock driven by LCLK
LCLK is used when an external peripheral is connected to the LPB. SCLK is used for
pass-through mode.
Bit 25 SNO -Sync Non-Overlap
0= No effect
1 = Don't add stride after first HSYNC
This bit must be set when the first HSYNC does not occur within the VSYNC active pe
riod.
Bit 26 ILC -Invert LCLK
o = Use LCLK as received
1 = Invert the LCLK input
Bits 28-27 Reserved
Bit 29 100 -Invert Odd/Even Frame Indicator
o = Odd/Even frame indicator unchanged
1 = Odd/Even fram indicator inverted
This inverts either the input on the ODD pin or the automatic odd/even frame indica
tor generated during 'Z).J Port operation.
Bit 30 BAS -Base Address Select
o = Normal operation
1 = Use state of the odd/even frame indicator (as affected by bit 29 of this register) to
select LPB base address 0 or LPB base address 1
This bit and bit 29 are used to support display of interlaced TV output.
Bit 31 'Z).J-'Z).J Port Enable
o
= 'Z).J Port operation disabled
1 = 'Z).J Port operation enabled
This enables automatic detection of odd/even fields when the LPB is operated in
Video 16 mode.
LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS 22-3

86CM65 Dual Display Accelerator
S3 Incorporllted
LPB FIFO Status (MMFF04)
| Read Only  | Address: FF04H  |     |     |     |     |
| ---------- | --------------- | --- | --- | --- | --- |
Power-on Default: 00000008H
| 15  14  | 13  12  11      | 10  9  8  | 7  6  5  | 4  3  2          | 1  0  |
| ------- | --------------- | --------- | -------- | ---------------- | ----- |
| R  R    | OFAE  OFE  OFF  | R  R  R   | R  R  R  | R  OFIFO STATUS  |       |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
VF1AE VF1E  VF1F  R  R  R  R  R  R  ~FOAE SST ODDS  R  R  R  R
| Bits 3-0  | LPB Output FIFO Status  |     |     |     |     |
| --------- | ----------------------- | --- | --- | --- | --- |
0000 = 0 FIFO slots free
0001 = 1 FIFO slot.free
0010 = 2 FIFO slots free
0011 = 3 FIFO slots free
0100 = 4 FIFO slots free
0101 = 5 FIFO slots free
0110 = 6 FIFO slots free
0111 =7  FIFO slots free
1000 = 8 FIFO slots free
Each slot contains 4 bytes
| Bits 10-4  | Reserved                   |     |     |     |     |
| ---------- | -------------------------- | --- | --- | --- | --- |
| Bit 11     | OFF -LPB Output FIFO Full  |     |     |     |     |
o  = Output FIFO not full
1 = Output FIFO full
| Bit 12  | OFE -LPB Output FIFO Empty  |     |     |     |     |
| ------- | --------------------------- | --- | --- | --- | --- |
o = Output FIFO not empty
1 = Output FIFO empty
| Bit 13  | OFAE -LPB Output FIFO Almost Empty  |     |     |     |     |
| ------- | ----------------------------------- | --- | --- | --- | --- |
o = Output FIFO has something other than 1 slot filled
1 = Output FIFO has one slot filled
| Bits 19-14  | Reserved  |     |     |     |     |
| ----------- | --------- | --- | --- | --- | --- |
Bit 20
ODD Pin Signal Input Status
0= ODD pin input is low
1 = ODD pin input is high
| Bit 21  | BST -Base Address Select Status  |     |     |     |     |
| ------- | -------------------------------- | --- | --- | --- | --- |
o
= LPB base address 0 selected for storage of video data
1 = LPB base address 1 selected for storage of video data
| Bit 22  | VFOAE -LPB Video FIFO 0 Almost Empty  |     |     |     |     |
| ------- | ------------------------------------- | --- | --- | --- | --- |
o = Video FIFO 0 has something other than 1 slot filled
1 = Video FIFO 0 has one slot filled
22-4 LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
| Bits 28-23  Reserved                 |     |     |     |     |     |
| ------------------------------------ | --- | --- | --- | --- | --- |
| Bit 29  VF1F -LPB Video FIFO 1 Full  |     |     |     |     |     |
0= Video FIFO 1 not full
1 = Video FIFO 1 full
| Bit 30  VF1E -LPB Video FIFO 1 Empty  |     |     |     |     |     |
| ------------------------------------- | --- | --- | --- | --- | --- |
0= Video FIFO 1 not empty
1 = Video FIFO 1 empty
| Bit 31  VF1AE -LPB Video FIFO 1 Almost Empty  |     |     |     |     |     |
| --------------------------------------------- | --- | --- | --- | --- | --- |
o  = Video FIFO 1 has something other than 1 slot filled
1 = Video FIFO 1 has one slot filled
LPB Interrupt Flags (MMFF08)
| Read/Write  | Address: FF08H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  | 4  3  2           | 1  0  |
| ----------- | ----------- | -------- | ----- | ----------------- | ----- |
| R  R  R     | R  R  R     | R  R  R  | R  R  | R  SPS  EFI  ELI  | FEI   |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| R  R  R                                             | R  R  R  | R  SPW  R  | R  R  | R  SPM  EFM  ELM  | FEM  |
| --------------------------------------------------- | -------- | ---------- | ----- | ----------------- | ---- |
| Bit 0  FEI -LPB Output FIFO Empty Interrupt Status  |          |            |       |                   |      |
o
= No interrupt
1 = LPB output FIFO empty
Writing a 1 to this bit clears the interrupt.
| Bit 1  ELI -End of Line Interrupt Status  |     |     |     |     |     |
| ----------------------------------------- | --- | --- | --- | --- | --- |
o  = No interrupt
1 = The 86CM65 has received an HSYNC input on pin K1
Writing a 1 to this bit clears the interrupt.
| Bit 2  EFI -End of Frame Interrupt Status  |     |     |     |     |     |
| ------------------------------------------ | --- | --- | --- | --- | --- |
o  = No interrupt
1 = The 86CM65 has received a VSYNC input on pin L 1
Writing a 1 to this bit clears the interrupt.
| Bit 3  SPS -Serial Port Start Detect Interrupt Status  |     |     |     |     |     |
| ------------------------------------------------------ | --- | --- | --- | --- | --- |
o -
No interrupt
1 = The 86CM65 has detected a serial port start condition
A serial port start condition occurs when pin M3 is driven low by another device
while pin M2 is not being driven low. Writing a 1 to this bit clears the interrupt.
LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS 22-5

86CM65 Dual Display Accelerator
S3 Inoorporated
Bits 15-4 Reserved
Bit 16 FEM -LPB Output FIFO Empty Interrupt Enable Mask
o
= LPB output FIFO empty interrupt disabled
1 = LPB output FIFO empty interrupt enabled
Bit 17 ELM -End of Line Interrupt Enable Mask
0= End of Line interrupt disabled
1 = End of Line interrupt enabled
Bit 18 EFM -End of Frame Interrupt Enable Mask
o = End of frame interrupt disabled
1 = End of frame interrupt enabled
Bit 19 SPM -Serial Port Start Detect Interrupt Mask
o
= Serial port start detect interrupt disabled
1 = Serial port start detect interrupt enabled
Bits 23·20 Reserved
Bit 24 SPW· Serial Port Wait
0= Release SPCLK to float high
1 = Drive SPCLK low upon receipt of a serial port start condition
Setting this bit to 1 enables serial port wait states until the host is ready to process
the data.
Bit 31·25 Reserved
22·6 LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 InCDrpDr.ud
LPB Frame Buffer Address 0 (MMFFOC)
| Read/Write  | Address: FFOCH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
| I  I        | I  I  I     | I  I  I  | I  I  I  | I  I  I  | I   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
LPB BUFFER ADDRESS 0
| I  I  | I  I  I  | I  I  I  | I  I  I  | I  I  I  | I   |
| ----- | -------- | -------- | -------- | -------- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| I  I                                   | I  I  I  | I  I  I  | I  I                     |     |     |
| -------------------------------------- | -------- | -------- | ------------------------ | --- | --- |
| R  R  R                                | R  R  R  | R  R  R  | R  LPB BUFFER ADDRESS 0  |     |     |
| Bits 21-0  LPB Frame Buffer Address 0  |          |          |                          |     |     |
Value = starting address 0 (offset in bytes from the start of the frame buffer) for writ
ing LPB data to the frame buffer
o.
This value will normally be the same as the secondary stream frame buffer address
The value must start on an a-byte boundary.
| Bits 31-22  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
LPB Frame Buffer Address 1 (MMFF10)
| Read/Write  | Address: FF10H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
| I  I        | I  I  I     | I  I  I  | I  I  I  | I  I  I  | I   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
LPB BUFFER ADDRESS 1
| I  I  | I  I  I  | I  I  I  | I  I  I  | I  I  I  | I   |
| ----- | -------- | -------- | -------- | -------- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| I  I                                   | I  I  I  | I  I  I  | I  I                     |     |     |
| -------------------------------------- | -------- | -------- | ------------------------ | --- | --- |
| R  R  R                                | R  R  R  | R  R  R  | R  LPB BUFFER ADDRESS 1  |     |     |
| Bits 21-0  LPB Frame Buffer Address 1  |          |          |                          |     |     |
Value = starting address 1 (offset in bytes from the start of the frame buffer) for writ
ing LPB data to the frame buffer
This value will normally be the same as the secondary stream frame buffer address 1.
Both address 0 and address 1 are defined when double buffering is used. The value
must start on an a-byte boundary.
| Bits 31-22  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS 22-7

86CM65 Dual Display Accelerator
53 Incorporated
LPB Direct Read/Write Address (MMFF14)
Read/Write Address: FF14H
Power-on Default: Undefined
I I I I I I I I I I I I I
15 1 14 1 13 12 11 10 9 8 7 6 5 4 3 2 1 0
LPB DIRECT READJWRITE ADDRESS
31 I 30 I 29 I 28 I 27 I 26 I 25 I 24 1 23 1 22 1 21 1 20 1 19 1 18 1 17 1 16
R I R I R I R I R I R I R I R I TT 1 LPB READJWRITE ADDRESS
Bits 20-0 LPB Direct Read/Write Address
Value = address of Scenic/MX2 register to read/Write
Bits 23-21 TT -Transaction Type (Scenic/MX2)
000 = Register write
001 = Register read
110 = Compressed video data write from the output FIFO. This value is automatically
generated by hardware when data is written to the output FIFO.
Bits 31-24 Reserved
LPB Direct Read/Write Data (MMFF18)
Read/Write Address: FF18H
Power-on Default: Undefined
I I I I I I I I I I I I I I
15 14 13 12 11 10 19 8 7 6 5 4 3 2 1 0
LPB DIRECT READJWRITE DATA
31 1 30 1 29 1 28 1 27 1 26 1 25 1 24·1 23 1 22 1 21 1 20 1 19 1 18 1 17 1 16
LPB DIRECT READJWRITE DATA
Bits 31-0 LPB Direct Read/Write Data
A write to this register triggers a read/write sequence based on the address informa
tion in MMFF14_23-0.
22-8 LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
LPB General Purpose Input/Output Port (MMFF1C)
| Read/Write -see bit definitions  |     | Address: FF1CH  |     |     |     |
| -------------------------------- | --- | --------------- | --- | --- | --- |
Power-on Default: Undefined
15  14  13  12  11  10  9  8  7  1  615  1  4  3  1  2  1  1  1  0
| R  R  R  | R  R  R  | R  R  | LPB GIP  | LPB GOP  |     |
| -------- | -------- | ----- | -------- | -------- | --- |
|          |          |       | J  I     | I        |     |
31  30  29  28  27  26  25  24  23.1  22  21  20  19  18  I.  17  1 16
R  R  R  R  R  R  R  R  R  1  R  1  R  1  R  R  1  R  1  R  1  R
| Bits 3-0  LPB General Purpose Output Data Port  |     |     |     |     |     |
| ----------------------------------------------- | --- | --- | --- | --- | --- |
These bits are driven onto the LPB LD[3:0] lines whenever a write is performed to
CRSC. STWR is asserted (low) at this time for use as an enable strobe for latching the
data into an external buffer.
| Bits 7-4  LPB General Purpose Input Data Port (Read only)  |     |     |     |     |     |
| ---------------------------------------------------------- | --- | --- | --- | --- | --- |
Whenever a write is performed to CRSC, STWR is asserted (low). This strobe can be
used to enable a register to drive data onto any or all of the LD[7:4] lines. This data is
then latched into these bits.
| Bits 31-8  Reserved  |     |     |     |     |     |
| -------------------- | --- | --- | --- | --- | --- |
Serial Port (MMFF20)
| Read/Write  | Address: FF20H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
This register can also be accessed at 110 ports E2H or E8H. See the Serial Communications Port de
scription in Section 4.
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  | 0   |
| ----------- | ----------- | -------- | -------- | -------- | --- |
R  R  R  B4M  B3M  B2M  B1M  BOM  R  R  R  SPE  SDR  SCR  SOW  SCW
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
| R  R  R                         | R  R  R  | R  R  R  | R  R  R  | R  R  R  | R   |
| ------------------------------- | -------- | -------- | -------- | -------- | --- |
| Bit 0  sew -Serial Clock Write  |          |          |          |          |     |
0= Pin M2 is driven low
1 = Pin M2 is tri-stated
Pin M2 carries the DDC/12C clock, depending on the operational mode. When pin M2
is tri-stated, other devices may drive this line. The actual state of the pin is read via
bit 2 ofthis register.
LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS 22-9

86CM65 Dual Display Accelerator
S3 Incorpor• ••d
Bit 1 SOW -Serial Data Write
0= Pin M3 is driven low
1 = Pin M3 is tri-stated
Pin M3 carries the DDC/12C data, depending on the operational mode. When pin M3 is
tri-stated, other devices may drive this line. The actual state of the pin is read via bit 3
of this register.
Bit 2 SCR -Serial Clock Read (Read Only)
o
= Pin M2 is low
1 = Pin M2 is tri-stated (no device is driving this line)
Bit 3 SDR -Serial Data Read (Read Only)
o
= Pin M3 is low
1 = Pin M3 is tri-stated (no device is driving this line)
Bit 4 SPE -Serial Port Enable
0= Use of bits 1-0 of this register disabled
1 = Use of bits 1-0 of this register enabled
Bits 5·7 Reserved
Bit 8 BOM -Bit 0 Mirror (Read Only)
o
= Pin M2 is driven low
1 = Pin M2 is tri-stated
Bit 9 B 1M -Bit 1 Mirror (Read Only)
o
= Pin M3 is driven low
1 = Pin M3 is tri-stated
Bit 10 B2M -Bit 2 Mirror (Read Only)
o
= Pin M2 is low
1 = Pin M2 is tri-stated (no device is driving this line)
Bit 11 B3M -Bit 3 Mirror (Read Only)
o
= Pin M3 is low
1 = Pin M3 is tri-stated (no device is driving this line)
22-10 LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS

| . .   |     |     |     |
| ----- | --- | --- | --- |
86CM65 Dual Display Accelerator
S3 Incorpor.ud
| Bit 12  B4M -Bit 4 Mirror (Read Only)  |     |     |     |
| -------------------------------------- | --- | --- | --- |
o = Use of bits 1-0 of this register disabled
1 = Use of bits 1-0 of this register enabled
This bit mirrors bit 4 and allows reading ofthis data on byte lane 2 at I/O address E2H.
| Bits 31-13  Reserved  |     |     |     |
| --------------------- | --- | --- | --- |
LPB Video Input Window Size (MMFF24)
| Read/Write  | Address: FF24H  |     |     |
| ----------- | --------------- | --- | --- |
Power-on Default: Undefined
This register applies only to Video 8 In or Video 16 mode
15  14  13  12  11  I  10  I  9  I  8  I  7  I  6  I  5  I  4  I  3  I  2  I  1  I  0
| R  R  R  | R   | VIDEO INPUT LINE WIDTH  |     |
| -------- | --- | ----------------------- | --- |
I  J  I  I
31  30  29  28  27  1 26  25  24  1 23  1 22  1 21  1 20  1 19.1  18  17  16
| R  R  R                            | R  R  1  | R  1  R  1  | VIDEO INPUT WINDOW HEIGHT  |
| ---------------------------------- | -------- | ----------- | -------------------------- |
| Bits 11-0  Video Input Line Width  |          |             |                            |
Value = [# pixels x 2] -2 for Video 8 mode
Value = # pixels -2 for Video 16 mode
This is the width of the displayed line after the offset speCified in MMFF28_11-o. Be
fore the 2 is subtracted, the number of pixels must be a multiple of 4. For example, in
Video 16 mode, if the line width is 637 pixels, this must be rounded up to 640. The
programmed value is then 640 -2 = 638.
| Bits 15·12  Reserved                   |     |     |     |
| -------------------------------------- | --- | --- | --- |
| Bits 24-16  Video Input Window Height  |     |     |     |
Value = [height in lines of each video input frame] -1
This is the number of displayed lines -1 after the offset specified in MMFF28_24_16.
| Bits 31·25  Reserved  |     |     |     |
| --------------------- | --- | --- | --- |
LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS 22-11

86CM65 Dual Display Accelerator
LPB Video Data Offsets (MMFF28)
| Read/Write  | Address: FF28H  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
This register applies only to Video 8 In or Video 16 mode
15  14  13  12  11  I  10  I  9  I  8  I  7  I  6  I  5  I  4  I  3  I  2  I  1  I  0
| R  R  R                                  | R        | HORIZONTAL VIDEO DATA OFFSET  |                             |                      |        |
| ---------------------------------------- | -------- | ----------------------------- | --------------------------- | -------------------- | ------ |
| 31  30  29                               | 28  I    | I                             |                             | I                    |        |
|                                          | 27       | 26  1 25  24  1 23.1          | 22  I  21  I                | 20  19  1  18  1 17  | 1  16  |
| R  R  R                                  | R  R  1  | R  1  R  1                    | VERTICAL VIDEO DATA OFFSET  |                      |        |
| Bits 11-0  Horizontal Video Data Offset  |          |                               |                             |                      |        |
Value = [number of LCLKs between HSYNC and the start of valid pixel data] -2
| Bits 15-12  Reserved                    |     |     |     |     |     |
| --------------------------------------- | --- | --- | --- | --- | --- |
| Bits 24-16  Vertical Video Data Offset  |     |     |     |     |     |
Value = number of HSYNCs between VSYNC and the first valid data line
| Bits 31-25  Reserved  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
LPB Horizontal Decimation Control (MMFF2C)
| Read/Write  | Address: FF2CH  |     |     |     |     |
| ----------- | --------------- | --- | --- | --- | --- |
Power-on Default: Undefined
15  1  14  1 13  1 12  1  11  1 10  1  9  1  8  1  7  1  6  1  5  1  4  1  3  1  2  1  1  1  0
VIDEO DATA BYTE MASK
31  1 30  1 29  1 28  1 27  1 26  1 25  1 24  1 23  1 22  1 21  1 20  1 19  1 18  1 17  1  16
VIDEO DATA BYTE MASK·
| Bits 31-0  Video Data Byte Mask  |     |     |     |     |     |
| -------------------------------- | --- | --- | --- | --- | --- |
Each 32 bytes of video data input is compared with this mask. If a bit in this mask is 1,
the corresponding byte is discarded. If a bit is a 0, the corresponding byte is passed
to the video memory. In Video 16 mode, each bit masks 2 bytes. In pass-through
mode, each bit masks 4 bytes. Normally, decimation starts with bit 0 after an HSYNC.
If a horizontal video data offset is specified in MMFF28_11-0 (video 8 or 16 modes
only), decimation aligns with the start of data after the offset.
22-12 LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 Incorpor.ud
LPB Vertical Decimation ControIIMMFF30)
| Read/Write  |     | Address: FF30H  |     |     |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
| I  I        | I  I "  | I   | I  I  | I     | I  I  | I     | I  I  | I     | I   |
| ----------- | ------- | --- | ----- | ----- | ----- | ----- | ----- | ----- | --- |
| 15  14  13  | 12      | 10  | 9     | 8  7  | 6     | 5  4  | 3     | 2  1  | 0   |
VIDEO DATA LINE MASK
| I  I  | I  I  | I   | J  I  | I   | I  I  | I   | I  I  | I   | I   |
| ----- | ----- | --- | ----- | --- | ----- | --- | ----- | --- | --- |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
VIDEO DATA LINE MASK
| Bits 31-0  Video Data Line Mask  |     |     |     |     |     |     |     |     |     |
| -------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Each 32 lines of video data input is compared with this mask. If a.bit in the mask is 0,
the corresponding line is discarded. If a bit is a 1, the corresponding line is passed to
the video memory. If a vertical video data offset is specified in MMFF28_24-16 (video
8 or 16 modes only), decimation does not align with the starting line after the offset
and instead starts from VSYNC.
LPB Une Stride (MMFF34)
| Read/Write  |     | Address: FF34H  |     |     |     |     |     |     |     |
| ----------- | --- | --------------- | --- | --- | --- | --- | --- | --- | --- |
Power-on Default: OOOOOOOOH
|             |     | I       | I  I  | I     | I  I         | I     | I  I  | I     | I   |
| ----------- | --- | ------- | ----- | ----- | ------------ | ----- | ----- | ----- | --- |
| 15  14  13  | 12  | 11  10  | 9     | 8  7  | 6            | 5  4  | 3     | 2  1  | 0   |
| R  R  R     | R   |         |       |       | LINE STRIDE  |       |       |       |     |
|             |     | I       | J  I  | I     | I  I         | I     | I  I  | I     | I   |
31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
|                         |     | I   | I  I  | I     | I  I  | I     | I  I  | I     | I   |
| ----------------------- | --- | --- | ----- | ----- | ----- | ----- | ----- | ----- | --- |
| R  R  R                 | R   | R   | R     | R  R  | R     | R  R  | R     | R  R  | R   |
| Bits 11-0  Line Stride  |     |     |       |       |       |       |       |       |     |
Value = byte offset of vertically adjacent pixels
This offset is added to the line starting address each HSYNC to get the new line start
ing address. Each line must begin on an 8-byte boundary.
| Bits 31-12  Reserved  |     |     |     |     |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS 22-13

86CM65 Dual Display Accelerator
53 Incorpol'llted
LPB Output FIFO (MMFF40)
Read/Write Address: FF4OH, FF44H •.. ,FF5CH
Power-on Default: OOOOOOOOH
Writes to any of the addresses in this 8 doubleword address range will be transferred to the LPB input
FIFO. This allows efficient use of the MOVSD assembly language instruction. Accesses must be to
doubleword addresses.
J I I I
15 1 14 1 13 1 12 11 10 9 8 1 71 6 1 5 1 4 1 3 1 2 1 1 1 0
OUTPUT FIFO DATA
I I I I I I I I I I I I I I I
31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16
OUTPUT FIFO DATA
Bits 31-0 Output FIFO Data
Note: Software must never transfer more compressed data than there is room for in
the output FIFO. This information is read from MMFF04_3-0.
22-14 LOCAL PERIPHERAL BUS REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
83 IMorpomod
Section 23: pel Register Descriptions
The PCI specification defines a configuration register space. These registers allow device relocation,
device independent system address map construction and automatic configurations. The 86CM65
provides a subset of these registers, which are described below.
The configuration register space occupies 256 bytes. When a configuration read or write command is
issued, the AD[7:0] lines contain the address of the register in this space to be accessed. The 86CM65
supports or returns 0 for the first 64 bytes of this space.
In the following register descriptions, 'R' stands for reserved (write =0 , read =u ndefined). See Appendix
A for a table listing each of the registers in this section and its page number.
VendorlD
Read Only Address: OOH
Power-On Default: 5333H
This read-only register identifies the device manufacturer.
15 14 13 12 11 10 5 4 3 2 1 o
Vendor 10
Bits 15-0 Vendor ID
This is hardwired to 5333H to identify S3 Incorporated.
PCI REGISTER DESCRIPTIONS 23-1

86CM65 Dual Display Accelerator
83 Inoorpol'llted
DevicelD
| Read Only  | Address: 02H  |     |     |     |     |
| ---------- | ------------- | --- | --- | --- | --- |
Power-On Default: 8812H
o
| 15  14  13  | 12  11  10  | 9  8  7  | 6  5  4  | 3  2  1  |     |
| ----------- | ----------- | -------- | -------- | -------- | --- |
Device ID
| Bits 15-0  Device 10  |     |     |     |     |     |
| --------------------- | --- | --- | --- | --- | --- |
This is hardwired to 8812H
Command
| Read/Write  | Address: 04H  |     |     |     |     |
| ----------- | ------------- | --- | --- | --- | --- |
Power-On Default: OOOOH
This register controls which types of PCI cycles the 86CM65 can generate and respond to.
| 15  14  13                                   | 12  11  10  | 9  8  7  | 6  5  4    | 3  2  1  | 0    |
| -------------------------------------------- | ----------- | -------- | ---------- | -------- | ---- |
|                                              |             |          | DAC        | MEM      | I/O  |
| R  R  R                                      | R  R  R     | R  R  R  | R  SNP  R  | R  R     |      |
| Bit 0  I/O -Enable Response to I/O Accesses  |             |          |            |          |      |
o
= Response to I/O space accesses is disabled
1 = Response to I/O space accesses enabled
| Bit 1  MEM -Enable Response to Memory Accesses  |     |     |     |     |     |
| ----------------------------------------------- | --- | --- | --- | --- | --- |
o
= Response to memory space accesses is disabled
1 = Response to memory space accesses enabled
| Bits 4-2  Reserved                               |     |     |     |     |     |
| ------------------------------------------------ | --- | --- | --- | --- | --- |
| Bit 5  DAC SNP -RAMDAC Register Access Snooping  |     |     |     |     |     |
o  = 86CM65 claims and responds to all RAMDAC register access cycles
1 = 86CM65 performs RAMDAC register writes but does not claim the PCI cycle.
RAMDAC register read accesses are performed by the 86CM65.
| Bits 15-6  Reserved  |     |     |     |     |     |
| -------------------- | --- | --- | --- | --- | --- |
23-2 PCI REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
-
Status
Read/Write Address: 06H
Power-On Default: 0200H
Bits 8-0 Reserved
Bits 10-9 DEVSEL -Device Select Timing
This is hardwired to 01 to select medium DEVSEL timing.
Bits 15-11 Reserved
Class Code
Read Only Address: 08H
Power-On Default: 300004xH
This register is hardwired to 300004xH. The 3 specifies that the 86CM65 is a VGA-compatible display
controller. The "x· in the revision 10 will change with each revision.
I I I I
15 14 13 1 12 11 101 9 1 8 7 1 6 1 5 1 4 1 3 1 2 1 1 1 0
PROGRAMMING INTERFACE REVISION 10
31 1 30 1 29 I 28 I 27 1 26 I 25 I 24 23 I 22 I 21 I 20 I 19 I 18 I 17 I 16
BASE CLASS CODE SUB-CLASS
PCI REGISTER DESCRIPTIONS 23-3

86CM65 Dual Display Accelerator
S3 Incorporated
Base Address 0
| Read/Write  | Address: 12H (high) 10H (low)  |     |     |     |     |
| ----------- | ------------------------------ | --- | --- | --- | --- |
Power-On Default: 0000 OOOOH
This is a 32-bit register in PCI configuration space that provides for address relocation. The 86CM65
maps the upper 6 bits of the register to the Linear Address Window Position register CR59_7-2.
Consequently, these bits map to system address bits [31:26).
I
| 15  14  13                          | 12  11  10  | 9  8  7  | 6  5  | 4  3  2       | 1  0  |
| ----------------------------------- | ----------- | -------- | ----- | ------------- | ----- |
| R  R  R                             | R  R  R     | R  R  R  | R  R  | R  PREF       | MSI   |
|                                     |             |          |       | =0  TYPE =00  | =0    |
| Bit 0  MSI -Memory Space Indicator  |             |          |       |               |       |
This is hardwired to 0 to specify that the base registers map into memory space
| Bits 2-1  TYPE -Type of Address Relocation  |     |     |     |     |     |
| ------------------------------------------- | --- | --- | --- | --- | --- |
This is hardwired to OOb (locate anywhere in 32-bit address space)
| Bit 3  PREF -Prefetchable  |     |     |     |     |     |
| -------------------------- | --- | --- | --- | --- | --- |
This is hardwired to 0 (does not meet the prefetchable requirements)
| Bits 22-4  Reserved         |     |     |     |     |     |
| --------------------------- | --- | --- | --- | --- | --- |
| Bits 31-23  BASE ADDRESS 0  |     |     |     |     |     |
See the description for the Linear Address Window Position registers (CR59, CR5A).
Writes to CR59 will also update this field.
23-4 PCI REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3 InDorpo.dod
BIOS ROM Base Address
| Read/Write  | Address: 32H (high) 30H (low)  |     |     |
| ----------- | ------------------------------ | --- | --- |
Power-On Default: OOOC OOOOH
This is a 32-bit register in PCI configuration space that provides for video BIOS ROM address relocation.
| Bit 0  | ADE -Address Decode Enable  |     |     |
| ------ | --------------------------- | --- | --- |
o  = Accesses to the BIOS ROM address space defined in this register are disabled
1 = Accesses to the BIOS ROM address space defined in this register are enabled
| Bits 15-1   | Reserved               |     |     |
| ----------- | ---------------------- | --- | --- |
| Bits 31-16  | BIOS ROM BASE ADDRESS  |     |     |
These are the upper 16 bits of the BIOS ROM address.
Interrupt Une
Address: 3CH
Read/Write
Power-On Default: OOH
This register contains interrupt line routing information written by the POST program during power-on
initialization.
| 7  6  | 543  | 2  1  | o   |
| ----- | ---- | ----- | --- |
INTERRUPT LINE
| Bits 7-0  | INTERRUPT LINE  |     |     |
| --------- | --------------- | --- | --- |
PCI REGISTER DESCRIPTIONS 23-5

86CM65 Dual Display Accelerator
Interrupt Pin
| Read Only  |     | Address: 3DH  |     |
| ---------- | --- | ------------- | --- |
Power-On Default: 01H
I
| 7  6  | 5  4  | 3  2  | 1  o  |
| ----- | ----- | ----- | ----- |
INTERRUPT PIN
Bits 7~ INTERRUPT PIN
This is hardwired to a value of 1 to specify that INTA is the interrupt pin used.
23-6 PCI REGISTER DESCRIPTIONS

86CM65 Dual Display Accelerator
S3lncorponlted
Appendix A: Register Reference
This Appendix contains tables listing all the registers in each of categories corresponding to Sections
17-25 of this data book.
• VGA
• Extended Sequencer
• Extended CRTC
• Enhanced Commands
• Streams Processor
• LPB
• PCI Configuration Space
Within each table, registers are listed in order of increasing addresses/indices. Name, address, register
bit descriptions with read/write status and the page number of the detailed register description are
provided for each register. All addresses and indices are hexadecimal values.
REGISTER REFERENCE A-1

86CM65 Dual Display Accelerator
83 Incorporated
A.1  VGA REGISTERS
? = B for monochrome, D for color.
Table A·1.  VGA Registers
| Add  Index              |                                        | Register Name    | Description  |
| ----------------------- | -------------------------------------- | ---------------- | ------------ |
| ress  Bitls)            |                                        | Bit Descri.rnon  | Page         |
| General or External Re  | isters                                 |                  |              |
| 3C2                     | Miscellaneous Output                   |                  | 17·1         |
| 0  W                    | Color emulation. Address based at 3Dx  |                  |              |
W  Enable CPU access of video memory
1
| 3-2  W  | Video DCLK select. Enable DCLK PLL loading  |     |     |
| ------- | ------------------------------------------- | --- | --- |
| 4  W    | Reserved                                    |     |     |
W  Select the high 64K page of memory
5
| 6  W    | Make HSYNC an active low signal                        |     |       |
| ------- | ------------------------------------------------------ | --- | ----- |
| 7  W    | Make VSYNC an active low signal                        |     |       |
| 7-6  W  | (Alternate) Vertical graphics resolution               |     |       |
| 3CC     | Miscellaneous Output                                   |     | 17·1  |
| 0  R    | Color emulation. Address based at 3Dx                  |     |       |
| 1  R    | Enable CPU access of video memory                      |     |       |
| 3-2  R  | Video DCLK select. Enable DCLK PLL loading             |     |       |
| 4  R    | Reserved                                               |     |       |
| 5  R    | Select the high 64K page of memory                     |     |       |
| 6  R    | Make HSYNC an active low sional                        |     |       |
| 7  R    | Make VSYNC an active low sional                        |     |       |
| 7-6  R  | (Alternate) Vertical oraphics resolution               |     |       |
| 3lA     | Feature Control                                        |     | 17·3  |
| 2-0  W  | Reserved                                               |     |       |
| 3  W    | VSYNC is ORed with the internal display enable signal  |     |       |
W  Reserved
7-4
| 3CA     | Feature Control                                        |     | 17·3  |
| ------- | ------------------------------------------------------ | --- | ----- |
| 2-0  R  | Reserved                                               |     |       |
| 3  R    | VSYNC is ORed with the internal display enable signal  |     |       |
| 7-4  R  | Reserved                                               |     |       |
| 3C2     | Input Status 0                                         |     | 17·3  |
| 3-0  R  | Reserved                                               |     |       |
| 4  R    | The internal SENSE signal is a logical 1               |     |       |
| 6-5  R  | Reserved                                               |     |       |
| 7  R    | Vertical retrace interrupt to the CPU is pending       |     |       |
A-2  REGISTER REFERENCE

86CM65 Dual Display Accelerator
Table A·1. VGA Registers (continued)
| Add  Index    |                                                     | Register Name    | Description  |
| ------------- | --------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                 | Bit Description  | Page         |
| 37A           | Input Status 1                                      |                  | 17-4         |
| 0             | R  The display in not in active display mode        |                  |              |
| 1             | R  Reserved                                         |                  |              |
| 2             | R  Reserved =1                                      |                  |              |
| 3             | R  Vertical retrace period is active                |                  |              |
| 5-4           | R  Feedback of two color outputs for test purposes  |                  |              |
| 7-6           | R  Reserved                                         |                  |              |
| 3C3           | Video Subsystem Enable                              |                  | 17·4         |
| 0             | W                                                   |                  |              |
Enable 86CM65
| 7-1  | RMI  Reserved  |     |     |
| ---- | -------------- | --- | --- |
Sequencer Registers
Sequencer Index
| 3C4      |                                                            |     | 17·5  |
| -------- | ---------------------------------------------------------- | --- | ----- |
| 4-0      | RMI  Index to the seauencer reoister to be accessed        |     |       |
| 7-5      | AMI  Reserved                                              |     |       |
| 3C5      | Sequencer Data                                             |     | 17·5  |
| 7-0      | RMI  Data to or from the sequencer reoister accessed       |     |       |
| 3C5  00  | Reset (SRO)                                                |     | 17·6  |
| 0        | AMI  Asynchronous reset (not functional for the Trio64V+)  |     |       |
| 1        | RMI  Synchronous reset (not functional for the Tri064V+)   |     |       |
| 7-2      | RMI  Reserved                                              |     |       |
| 3C5  01  | Clocking Mode (SR1)                                        |     | 17·6  |
| 0        | AMI                                                        |     |       |
Character clocks are 8 dots wide
| 1   | AMI  Reserved                                                 |     |     |
| --- | ------------------------------------------------------------- | --- | --- |
| 2   | AMI  Load the video serializers every second character clock  |     |     |
AMI
| 3   | The internal character clock is 1/2 the DCLK freauency        |     |       |
| --- | ------------------------------------------------------------- | --- | ----- |
| 4   | AMI  Load the video serializers every fourth character clock  |     |       |
| 5   | AMI  Screen is turned off -Shared                             |     |       |
| 02  | Enable Write Plane (SR2)                                      |     | 17·7  |
3C5
| 3-0      | AMI  Enables a CPU write to the corresponding color plane  |     |       |
| -------- | ---------------------------------------------------------- | --- | ----- |
| 7-4      | AMI  Reserved                                              |     |       |
| 3C5  03  | Character Font Select (SR3)                                |     | 17·8  |
AMI
4,1-0  Select Font B -Shared
| 5,3-2  | AMI  Select Font A -Shared  |     |     |
| ------ | --------------------------- | --- | --- |
| 7-6    | AMI  Reserved               |     |     |
REGISTER REFERENCE A-3

86CM65 Dual Display Accelerator
8a Incorporeted
Table A-1. VGA Registers (continued)
| Add  Index    |                                                                | Register Name    | Description  |
| ------------- | -------------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                            | Bit Description  | Page         |
| 3C5  04       | Memory Mode Control (SR4)                                      |                  | 17-9         |
| 0             | AMI  Reserved                                                  |                  |              |
| 1             | AMI  Memory access to 256K allowed (required for VGA) -Shared  |                  |              |
| 2             | AMI  Sequential addressing for CPU video memory accesses       |                  |              |
| 3             | RNoJ  Modulo 4 addressing for CPU video memory accesses -      |                  |              |
Shared
| 7-4  | AMI  Reserved  |     |     |
| ---- | -------------- | --- | --- |
CRT Controller Registers
| 314  | CRT Controller Index  |     | 17-10  |
| ---- | --------------------- | --- | ------ |
AMI  Index to the CRTC register to be accessed
7-0
| 315  | CRT Controller Data                              |     | 17-10  |
| ---- | ------------------------------------------------ | --- | ------ |
| 7-0  | AMI  Data to or from the CRTC register accessed  |     |        |
00
| 315      | Horizontal Total (CRO) -Paired                               |     | 17-11  |
| -------- | ------------------------------------------------------------ | --- | ------ |
| 7-0      | AMI  Number of characters in a line -5                       |     |        |
| 315  01  | Horizontal Display End (CR1) -Paired                         |     | 17-11  |
| 7-0      | AMI  One less than the total number of displayed characters  |     |        |
| 315  02  | Start Horizontal Blank (CR2) -Paired                         |     | 17-12  |
| 7-0      | AMI  Character count where horizontal blankinQ starts        |     |        |
| 315      | End Horizontal Blank (CR3) -Paired                           |     | 17-12  |
03
| 4-0  | AMI  End position of horizontal blanking      |     |     |
| ---- | --------------------------------------------- | --- | --- |
| 6-5  | AMI  Display enable skew in character clocks  |     |     |
| 7    | AMI  Reserved                                 |     |     |
315  04  Start Horizontal Sync Position (CR4) -Paired  17-13
| 7-0      | AMI  Character count where HSYNC goes active           |     |        |
| -------- | ------------------------------------------------------ | --- | ------ |
| 315  05  | End Horizontal Sync Position (CR5) -Paired             |     | 17-13  |
| 4-0      | AMI  Position where HSYNC goes inactive                |     |        |
| 6-5      | AMI  Horizontal retrace end delay in character clocks  |     |        |
| 7        | AMI  End horizontal blanking bit 5                     |     |        |
| 315  06  | Vertical Total (CR6) -Paired                           |     | 17-14  |
| 7-0      | AMI  Number of lines -2                                |     |        |
A-4 REGISTER REFERENCE

86CM65 Dual Display Accelerator
sa Incorponted
Table A·1. VGA Registers (continued)
| Add  Index    |                                                      | Register Name    | Description  |
| ------------- | ---------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                  | Bit Description  | Page         |
| 375  07       | CRTC Overflow (CR7) • Paired                         |                  | 17·14        |
| 0             | RMI  Vertical total bit 8                            |                  |              |
| 1             | RNV  Vertical display end bit 8                      |                  |              |
| 2             | RNV  Vertical retrace start bit 8                    |                  |              |
| 3             | RNV  Start vertical blank bit 8                      |                  |              |
| 4             | RMI  Line compare bit 8                              |                  |              |
| 5             | RMI  Vertical total bit 9                            |                  |              |
| 6             | RNV  Vertical display end bit 9                      |                  |              |
| 7             | RMI  Vertical retrace start bit 9                    |                  |              |
| 375  08       | Preset Row Scan (CRa) • Paired                       |                  | 17·15        |
| 4-0           | RNV  Line where first character row begins           |                  |              |
| 6-5           | RMI  Number of bytes to pan horizontally             |                  |              |
| 7             | RMI  Reserved                                        |                  |              |
| 375  09       | Maximum Scan Une (CR9) • Paired                      |                  | 17·15        |
| 4-0           | RMI  Character height in scan lines -1               |                  |              |
| 5             | RNV  Start vertical blank bit 9                      |                  |              |
| 6             | RMI  Line compare bit 9                              |                  |              |
| 7             | RNV  Double scanning (repeat each line) enabled      |                  |              |
| 375  OA       | Cursor Start Scan Une (CRA) • Shared                 |                  | 17·16        |
| 4-0           | RMI  Cursor starting line within the character cell  |                  |              |
| 5             | RMI  Turns off the cursor                            |                  |              |
| 7-6           | RMI  Reserved                                        |                  |              |
| 375  OB       | Cursor End Scan Une (CRB) • Shared                   |                  | 17·16        |
| 4-0           | RMI  Cursor ending line within the character cell    |                  |              |
| 6-5           | RMI  Cursor skew to right in characters              |                  |              |
| 7             | RMI  Reserved                                        |                  |              |
| 375  OC       | Start Address High (CRC) • Paired                    |                  | 17·17        |
| 7-0           | RMI  Bits 15 -8 of the display start address         |                  |              |
Start Address Low (CRD) • Paired
| 375  OD  |                                             |     | 17·17  |
| -------- | ------------------------------------------- | --- | ------ |
| 7-0      | RNV  Bits 7-0 of the display start address  |     |        |
375  OE  Cursor Location Address High (& Hardware Cursor  17·17
Forearound Color in Enhanced Mode) (CRE) • Shared
| 7-0  | RNV  Bits 15 -8 of the cursor location start address  |     |     |
| ---- | ----------------------------------------------------- | --- | --- |
375  OF  Cursor Location Address Low (& Hardware Cursor  17·17
Background Color in Enhanced Mode) (CRF) • Shared
| 7-0  | RMI  Bits 7-0 of the cursor location start address  |     |     |
| ---- | --------------------------------------------------- | --- | --- |
REGISTER REFERENCE A-5

86CM65 Dual Display Accelerator
83 Inoorponted
Table A-1. VGA Registers (continued)
| Add  Index    |                                                                | Register Name    | Description  |
| ------------- | -------------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                            | Bit Description  | Paae         |
| 375  10       | Vertical Retrace Start (CR10 -Paired                           |                  | 17-18        |
| 7-0           | RNJ  Vertical retrace start in scan lines                      |                  |              |
| 375  11       | Vertical Retrace End (CR11) -Paired                            |                  | 17-18        |
| 3-0           | RNJ  Vertical retrace end in scan lines                        |                  |              |
| 4             | RNJ  Clear the vertical retrace interrupt flip-flop            |                  |              |
| 5             | RNJ  Disable vertical interrupts                               |                  |              |
| 6             | RNJ  Five RAM refresh cvcles per horizontal line               |                  |              |
| 7             | RNJ  Lock writes to CRO-CR7                                    |                  |              |
| 375  12       | Vertical Display End (CR12) -Paired                            |                  | 17-19        |
| 7-0           | RNJ  Number of scan lines of active video                      |                  |              |
| 375  13       | Offset (CR13) -Paired                                          |                  | 17-19        |
| 7-0           | RNJ  Memory start address jump from one scan line to the next  |                  |              |
| 375  14       | Underline Location (CR14) -Paired                              |                  | 17-20        |
| 4-0           | RNJ  Horizontal scan line where underline occurs               |                  |              |
| 5             | RNJ  Memory address counter increment is 4 character clocks    |                  |              |
| 6             | RNJ  Memory accessed as doublewords                            |                  |              |
| 7             | RNJ  Reserved                                                  |                  |              |
| 375  15       | Start Vertical Blank (CR15) -Paired                            |                  | 17-20        |
| 7-0           | RNJ  Horizontal scan line where vertical blankinQ starts       |                  |              |
17-21
| 375  16     | End Vertical Blank (CR16) -Paired                       |     |        |
| ----------- | ------------------------------------------------------- | --- | ------ |
| 7-0         | RNJ  Horizontal scan line where vertical blanking ends  |     |        |
| 375  17     | CRTC Mode Control (CR17) -Paired                        |     | 17-21  |
| 0           | RNJ  Enable bank 2 mode for CGA emulation               |     |        |
| 1           | RNJ  Enable bank 4 mode for CGA emulation               |     |        |
| 2           | RNJ  Use horizontal retrace clock divided by 2          |     |        |
| 3           | RNJ  Enable count by 2 mode                             |     |        |
| 4           | RNJ  Reserved                                           |     |        |
| 5           | RNJ  Enable CGA mode address wrap                       |     |        |
| 6           | RNJ  Use byte address mode                              |     |        |
| 7           | RNJ  Horizontal and vertical retrace signals enabled    |     |        |
| 375  18     | Line Compare (CR18) -Paired                             |     | 17-23  |
| 7-0         | RNJ  Line at which memory address counter cleared to 0  |     |        |
| 375  22     | CPU Latch Data (CR22) -Pairad                           |     | 17-23  |
| 7-0         | R  Value in the CPU latch in the graphics controller    |     |        |
| 375  24,26  | Attribute Controller Flag/Index -Paired                 |     | 17-24  |
R  Value of the attribute controller index data at 3COH
5-0
| 6   | R  Reserved                                      |     |     |
| --- | ------------------------------------------------ | --- | --- |
| 7   | R  State of inverted internal address flip-flop  |     |     |
A-6 REGISTER REFERENCE

86CM65 Dual Display Accelerator
83 Inoorporated
Table A-1. VGA Registers (continued)
| Add  Index    |      | Register Name    | Description  |
| ------------- | ---- | ---------------- | ------------ |
| ress  Bit(s)  | R/W  | Bit Description  | Page         |
Graphics Controller Registers
| 3CE  | Graphics Controller Index                                      |     | 17-25  |
| ---- | -------------------------------------------------------------- | --- | ------ |
| 3-0  | RMI  Index to the graphics controller register to be accessed  |     |        |
RMI  Reserved
74
| 3CF      | Graphics Controller Data                                        |     | 17-25  |
| -------- | --------------------------------------------------------------- | --- | ------ |
| 7-0      | RMI  Data to or from the araphics controller register accessed  |     |        |
| 3CF  00  | Set/Reset (GRO)                                                 |     | 17-26  |
| 3-0      | R/W  Color value for CPU memory writes                          |     |        |
| 74       | RMI  Reserved                                                   |     |        |
| 3CF  01  | Enable Set/Reset (GR1)                                          |     | 17-26  |
| 3-0      | RMI  Enable planes for writing GRO data                         |     |        |
| 74       | RMI  Reserved                                                   |     |        |
| 3CF  02  | Color Compare (GR2)                                             |     | 17-27  |
RMI
3-0  Reference color for color compare operations
| 74       | R/W  Reserved                                                 |     |        |
| -------- | ------------------------------------------------------------- | --- | ------ |
| 3CF  03  | Raster Operation/Rotate Counter (GR3)                         |     | 17-27  |
| 2-0      | R/W  Number of riaht rotate positions for a CPU memory write  |     |        |
| 4-3      | RMI  Select raster operation (logical function)               |     |        |
| 7-5      | RMI  Reserved                                                 |     |        |
| 3CF  04  | Read Plane Select (GR4)                                       |     | 17-28  |
| 1-0      | RMI  Select planes for reading                                |     |        |
| 7-2      | R/W  Reserved                                                 |     |        |
| 3CF  05  | Graphics Controller Mode (GR5)                                |     | 17-29  |
| 1-0      | RMI  Select write mode                                        |     |        |
| 2        | RMI  Reserved                                                 |     |        |
| 3        | RMI  Enable read compare operation                            |     |        |
| 4        | RMI  Select odd/even addressing                               |     |        |
| 5        | RMI  Select odd/even shift mode -Shared                       |     |        |
| 6        | RMI  Select 256 color shift mode -Shared                      |     |        |
RMI
7  Reserved
| 3CF  06  | Memorv Map Mode Control (GR6)                      |     | 17-30  |
| -------- | -------------------------------------------------- | --- | ------ |
| 0        | RMI  Select araphics mode memory addressina        |     |        |
| 1        | RMI  Chain odd/even planes                         |     |        |
| 3-2      | RMI  Select memory mapping                         |     |        |
| 74       | RMI  Reserved                                      |     |        |
| 3CF  07  | Color Don't Care (GR7)                             |     | 17-31  |
| 3-0      | RMI  Select color plane used for color comparison  |     |        |
| 74       | RMI  Reserved                                      |     |        |
REGISTER REFERENCE A-7

86CM65 Dual Display Accelerator
S3 InoorporlltH
Table A-1. VGA Registers (continued)
| Add  Index    |                                                                  | Register Name    | Description  |
| ------------- | ---------------------------------------------------------------- | ---------------- | ------------ |
| rass  Bit(s)  | R/W                                                              | Bit Description  | Page         |
| 3CF  08       | Bit Mask (GR8)                                                   |                  | 17-31        |
| 7-0           | R/IN  Each bit is a mask for the corresponding memory plane bit  |                  |              |
Attribute Registers
| 3CO  | Attribute Controller Index                                       |     | 17-32  |
| ---- | ---------------------------------------------------------------- | --- | ------ |
| 4-0  | R/IN  Index to the attribute controller reoister to be accessed  |     |        |
5  R/IN  Enable video display
| 7-6           | R/IN  Reserved                                                    |     |        |
| ------------- | ----------------------------------------------------------------- | --- | ------ |
| 3C1/0         | Attribute Controller Data                                         |     | 17-33  |
| 7-0           | R/IN  Data to or from the attribute controller register accessed  |     |        |
| 3C1/0  OO-OF  | Palette Register (ARo-ARF)                                        |     | 17-33  |
| 5.Q           | R/IN  Color value                                                 |     |        |
7-6  Reserved
RNJ
| 3C1/0  10  | Attribute Mode Control (AR10)  |     | 17-34  |
| ---------- | ------------------------------ | --- | ------ |
0  R/IN  Select graphics mode
1  R/IN  Select monochrome display
2  R/IN  Enable line graphics characters
3  R/IN  Enable blinkino
4  R/IN  Reserved
5  R/IN  Enable top pannino
6  R/IN  Select 256 color mode
7  R/IN  Bits 5-4 of video outllut come from AR 14 1-0
| 3C1/0  11  | Border Color (AR11) -Shared                              |     | 17-35  |
| ---------- | -------------------------------------------------------- | --- | ------ |
| 7-0        | R/IN  Border color value                                 |     |        |
| 3C1/0  12  | Color Plane Enable (AR12)                                |     | 17-35  |
| 3-0        | R/IN  Display plane enable                               |     |        |
| 5-4        | R/IN  Select inputs to bits 5-4 of 3?AH                  |     |        |
| 7-6        | R/IN  Reserved                                           |     |        |
| 3C1/0  13  | Horizontal Pixel Panning (AR13)                          |     | 17-36  |
| 3-0        | R/IN  Number of pixels to shift the display to the left  |     |        |
| 7-4        | R/IN  Reserved                                           |     |        |
| 3C1/0  14  | Pixel Padding (AR14)                                     |     | 17-37  |
| 1-0        | R/IN  Bits 5-4 ofthe video output if ARlO 7 = 1          |     |        |
| 3-2        | R/IN  Bits 7-6 of the video output                       |     |        |
| 7-4        | R/IN  Reserved                                           |     |        |
A-8 REGISTER REFERENCE

••
r
86CM65 Dual Display Accelerator
53 Incorpo. ...d
Table A-1. VGA Registers (continued)
| Add  Index  |     | Register Name    | Description  |
| ----------- | --- | ---------------- | ------------ |
| Bit(s)      |     | Bit Description  | Page         |
| ress  R/W   |     |                  |              |
RAMDAC Registers
| 3C6        | DACMask                                               |     | 17-38  |
| ---------- | ----------------------------------------------------- | --- | ------ |
| 7-0  R/IN  | Pixel read mask                                       |     |        |
| 3C7        | DAC Read Index                                        |     | 17-38  |
| 7-0  W     | Index to palette register to be read                  |     |        |
| 3C7        | DACStatus                                             |     | 17-39  |
| 1-0  R     | Shows whether previous DAC cvcle was a read or write  |     |        |
| 7-2  R     | Reserved                                              |     |        |
-
| 3C8  | DAC Write Index  |     | 17-39  |
| ---- | ---------------- | --- | ------ |
7-0
R/IN  Index to palette register to be written
| 3C9        | DACData                                                   |     | 17-40  |
| ---------- | --------------------------------------------------------- | --- | ------ |
| 7-0  R/IN  | Data from register pointed to by DAC Read or Write Index  |     |        |
REGISTER REFERENCE A-9

86CM65 Dual Display Accelerator
sa Incorporated
A.2  EXTENDED SEQUENCER REGISTERS
Table A-2.  Extended Sequencer Registers
| Add  Index  |     | Register Name  | Description  |
| ----------- | --- | -------------- | ------------ |
Bit(s)
| ress     | R/W                                       | Bit Description  | Page  |
| -------- | ----------------------------------------- | ---------------- | ----- |
| 3C5  OS  | Unlock Extended Sequencer (SRS)           |                  | 1S-1  |
| 7-0      | RNV  Load xxxxOll Ob to unlock SR9-SRl C  |                  |       |
09
| 3C5      | R/W  Extended Sequencer 9             |     | 1S-2  |
| -------- | ------------------------------------- | --- | ----- |
| 6-0      | RNV  Reserved = 1                     |     |       |
| 7        | RNV  Memory-mapped I/O only (no PIO)  |     |       |
| 3C5  OA  | Extended Sequencer A (SRA)            |     | 1S-3  |
| 4-0      | RNV  Reserved                         |     |       |
| 5        | RNV  PD[63:0) not tri-stated          |     |       |
| 6        | RNV  Reserved                         |     |       |
RNV
7  2 MCLK memory writes
| 3C5  OD  | Extended Sequencer D (SRD)         |     | 1S-4  |
| -------- | ---------------------------------- | --- | ----- |
| 0        | RNV  Drive LPBEN pin with logic 1  |     |       |
| 3-1      | RNV                                |     |       |
Reserved
| 3-1      | RNV  Reserved                                            |     |       |
| -------- | -------------------------------------------------------- | --- | ----- |
| 5-4      | RNV  HSYNC control for Green PC requirements             |     |       |
| 7-6      | RNV  VSYNC control for Green PC requirements             |     |       |
| 3C5  09  | Extended Sequencer 9 (SR9)                               |     | 18-2  |
| 1-0      | RNV  Reserved                                            |     |       |
| 2        | RNV  Controller 1 virtual DCLK off when CR67 3-2 = 11 b  |     |       |
| 3        | RNV  Controller 1 virtual DCLK off in Standby            |     |       |
| 4        | RNV  Controller 1 virtual DCLK off in Suspend            |     |       |
| 5        | RNV  Controller 1 true DCLK off in Standby               |     |       |
| 6        | RNV  Controller 1 true DCLK off in Suspend               |     |       |
| 7        | RNV  MMIO-only                                           |     |       |
| 3C5  10  | MCLK Value Low (SR10)                                    |     | 1S-5  |
| 4-0      | RNV  MCLK N-divider value                                |     |       |
| 6-5      | R/VV  MCLKR value                                        |     |       |
| 7        | RNV  Reserved                                            |     |       |
| 3C5  11  | MCLK Value High (SR11)                                   |     | 1S-5  |
| 6-0      | R/VV  MCLK M-divider value                               |     |       |
| 7        | RNV  Reserved                                            |     |       |
A-l0 REGISTER REFERENCE

86CM65 Dual Display Accelerator
53 Inoorponted
Table A-2. Extended Sequencer Registers (continued)
| Add  Index    |      | Register Name    | Description  |
| ------------- | ---- | ---------------- | ------------ |
| ress  Bit(s)  | R/W  | Bit Description  | Page         |
DCLK Value Low (SR12)
| 3C5  12  |                            |     | 18-6  |
| -------- | -------------------------- | --- | ----- |
| 5-0      | RMI  DCLK N-divider value  |     |       |
| 7..£     | RMI  DCLK Rvalue           |     |       |
|          | DCLK Value High (SR13)     |     | 18-6  |
3C5  13
| 7-0      | RMI  DCLK M-divider value                               |     |        |
| -------- | ------------------------------------------------------- | --- | ------ |
| 3C5  14  | CLKSYN Control 1 (SR14)                                 |     | 18-7   |
| 0        | RMI  DCLK PLL powered down (test only)                  |     |        |
| 1        | RMI  MCLK PLL powered down (test only)                  |     |        |
| 3        | RMI  Test MCLK (test only)                              |     |        |
| 4        | RMI  Clear clock synthesizer counters (test only)       |     |        |
| 5        | RMI  Pin 146 tri-stated                                 |     |        |
| 6        | RMI  MCLK is input on pin N1  (test only)               |     |        |
| 7        | RMI  DCLK is input on pin A1 (test only)                |     |        |
| 3C5  15  | CLKSYN Control 2 (SR15)                                 |     | 18-8   |
| 0        | RMI  Load new MCLK frequency                            |     |        |
| 1        | RMI  Load new DCLK frequency                            |     |        |
| 2        | RMI  MCLK output on pin C3 (test only)                  |     |        |
| 3        | RMI  DCLK output on pin M1 (test only)                  |     |        |
| 4        | RMI  Divide DCLK by 2                                   |     |        |
| 5        | RMI  Load MCLK and DCLK PLL values immediately          |     |        |
| 6        | RMI  Invert DCLK                                        |     |        |
| 7        | RMI  Enable 2 MCLK memory writes                        |     |        |
| 3C5  16  | CLKSYN Test High (SR16)                                 |     | 18-9   |
| 7-0      | RMI  Reserved                                           |     |        |
| 3C5  17  | CLKSYN Test High (SR17)                                 |     | 18-10  |
| 7-0      | RMI  Reserved                                           |     |        |
| 3C5  18  | RAMDAC/CLKSYN Control (SR18)                            |     | 18-10  |
| 0        | RMI  RAMDAC test counter enabled (test only)            |     |        |
| 1        | RMI  Reset RAMDAC test counter                          |     |        |
| 2        | RMI  Place red data on internal data bus (test onlv)    |     |        |
| 3.       | RMI  Place green data on internal data bus (test only)  |     |        |
| 4        | RMI  Place blue data on internal data bus (test onlv)   |     |        |
| 5        | RMI  Power-down RAMDAC                                  |     |        |
| 6        | RMI  Select 1 cycle CLUT write                          |     |        |
| 7        | RMI  RAMDAC clock doubled mode enabled                  |     |        |
REGISTER REFERENCE A-11

86CM65 Dual Display Accelerator
Table A-2. Extended Sequencer Registers (continued)
| Add  Index    |                                                            | Register Name    | Description  |
| ------------- | ---------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                        | Bit Description  | Page         |
| 3C5  1A       | Extended Sequencer 1A (SR1A)                               |                  | 18-11        |
| 3-0           | RNI/  Reserved                                             |                  |              |
| 5-4           | RNV  Select functions of pins C3 and C15                   |                  |              |
| 6             | RNI/  Reserved                                             |                  |              |
| 7             | RNV  RAMDAC and CLUTs powered with 5V (overrides SR1 B 0)  |                  |              |
| 3C5  1B       | Extended Sequencer 1B (SR1B)                               |                  | 18-12        |
| 0             | R  RAMDAC and CLUTs powered with 5V                        |                  |              |
| 7-1           | RNV  Reserved  =  1                                        |                  |              |
| 3C5  1C       | Extended S~uencer 1C (SR1C)                                |                  | 18-12        |
| 1-0           | RNV  Reserved                                              |                  |              |
| 2             | RNI/  TV encoder clock off when encoder disabled           |                  |              |
| 3             | RNI/  TV encoder clock off in Standby                      |                  |              |
| 4             | RNI/  TV encoder clock off in Suspend                      |                  |              |
| 5             | RNV  LCLK off when LPB disabled                            |                  |              |
RNV  LCLK off in Standby
6
| 7        | RNV  LCLK off in Suspend                    |     |        |
| -------- | ------------------------------------------- | --- | ------ |
| 3C5  1D  | Extended Sequencer 1D (SR1D)                |     | 18-13  |
| 2-0      | RNI/  Reserved                              |     |        |
| 3        | RNV  SP DCLK branch 1 off when SP disabled  |     |        |
| 4        | RNV  SP DCLK branch 1 off in Standby        |     |        |
| 5        | RNV  SP DCLK branch 1 off in Suspend        |     |        |
| 6        | RNV  SP DCLK branch 2 off in Standby        |     |        |
| 7        | RNV  SP DCLK branch 2 off in Suspend        |     |        |
| 3C5  1E  | Extended Sequencer 1E (SR1E)                |     | 18-14  |
RNV
0  Controller 1 DCLK off when Controller 1 disabled
| 1    | RNV  Reserved                                          |     |     |
| ---- | ------------------------------------------------------ | --- | --- |
| 2    | RNV  Controller 2 DCLK off when Controller 2 disabled  |     |     |
| 3    | RNV  Controller 2 DCLK off in Standby                  |     |     |
| 4    | RNV  Controller 2 DCLK off in Standby                  |     |     |
| 6-5  | RNV  Reserved                                          |     |     |
| 7    | RNV  Bus interface SCLK off in Suspend                 |     |     |
A-12 REGISTER REFERENCE

86CM65 Dual Display Accelerator
53 Incorporated
Table A·2. Extended Sequencer Registers (continued)
| Add  Index    |                               | Register Name    | Description  |
| ------------- | ----------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                           | Bit Description  | Page         |
| 3C5  1F       | Extended Seauencer 1F (SR1F)  |                  | 18·15        |
RMI
0  GE MClK off in Suspend
| 1   | RMI  DM MClK off in Suspend   |     |     |
| --- | ----------------------------- | --- | --- |
| 2   | RMI  BIU MClK off in Suspend  |     |     |
RMI
3  lPB MClK off in Suspend
| 4   | RMI  Controller 1 and 2/SP MClK off in Suspend  |     |     |
| --- | ----------------------------------------------- | --- | --- |
| 5   | R/W  Enable MClK off in Suspend                 |     |     |
6
R/W  Reserved
| 7        | RMI  Flat panel MClK branch off in Suspend     |     |        |
| -------- | ---------------------------------------------- | --- | ------ |
| 3C5  20  | Extended Sequencer 20 (SR20)                   |     | 18-16  |
| 0        | R/W  Reserved                                  |     |        |
| 1        | RMI  DAC off in Standby                        |     |        |
| 2        | RMI  DAC off in Suspend                        |     |        |
| 3        | RMI  DClK Pll off in Suspend                   |     |        |
| 4        | R/W  MClK Pll off in Suspend                   |     |        |
| 6-5      | RMI  Reserved                                  |     |        |
| 7        | RMI  Pads in suspend configuration in Suspend  |     |        |
| 3C5  21  | Extended Sequencer 21 (SR21)                   |     | 18·17  |
| 0        | RMI  Disable ClUT1                             |     |        |
| 1        | RMI  Disable monitor sense circuit             |     |        |
RMI  ClUT1 powered down in Standby
2
| 3        | RMI  ClUT1 powered down in Suspend                   |     |        |
| -------- | ---------------------------------------------------- | --- | ------ |
| 4        | RMI  Disable ClUT2                                   |     |        |
| 5        | RMI  ClUT2 powered down when Controller 2 diasabled  |     |        |
| 6        | R/W  ClUT2 powered down in Standby                   |     |        |
| 7        | RMI  ClUT2 powered down in Suspend                   |     |        |
| 3C5  22  | DCLKO Value Low (SR22)                               |     | 18·18  |
| 5-0      | RMI                                                  |     |        |
DClKO N-divider value
| 7-6      | RMI  DClKO R value       |     |        |
| -------- | ------------------------ | --- | ------ |
| 3C5  23  | DCLKO Value High (SR23)  |     | 18·18  |
| 7-0      | RMI                      |     |        |
DClKO M-divider value
| 3C5  24  | DCLK1 Value Low (SR24)      |     | 18·19  |
| -------- | --------------------------- | --- | ------ |
| 5-0      | RMI  DClK1 N-divider value  |     |        |
7-6
R/W  DClK1 R value
| 3C5  25  | DCLK1 Value High (SR25)     |     | 18·19  |
| -------- | --------------------------- | --- | ------ |
| 7-0      | R/W  DClK1 M-divider value  |     |        |
REGISTER REFERENCE A·13

86CM65 Dual Display Accelerator
S3 Inoorpol'llud
Table A-2. Extended Sequencer Registers (continued)
| Add  Index    |                                                                 | Register Name    | Description  |
| ------------- | --------------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                             | Bit Description  | Page         |
| 3C5  26       | Paired Register ReadIWrite Select (SR26)                        |                  | 18-20        |
| 0             | RNV  Certain CRTC register reads are disabled for controller 1  |                  |              |
| 1             | RMI  Reads of all paired controller 1 registers are disabled    |                  |              |
| 2             | RNV  Enable writes to controller 2 registers                    |                  |              |
| 3             | RNV  Disable writes to controller 1 registers                   |                  |              |
| 7-4           | RNV  Reserved                                                   |                  |              |
| 3C5  27       | MCLK Control (SR27)                                             |                  | 18-21        |
| 1-0           | RMI  Select I MCKl source                                       |                  |              |
| 3-2           | RNV  Select MClK divider                                        |                  |              |
| 7-4           | RNV  Reserved                                                   |                  |              |
| 3C5  28       | DCLK Control (SR28)                                             |                  | 18-22        |
| 1-0           | RNV  Select I DCKLA source                                      |                  |              |
| 3-2           | RMI  Select DClKl divider                                       |                  |              |
| 5-4           | RNV  Select IDCKlB source                                       |                  |              |
| 7-6           | RMI  Select DClK2 divider                                       |                  |              |
| 3C5  29       | Flat Panel Frame Buffer (SR29)                                  |                  | 18-23        |
RNV
1-0  STN write FIFO threshold
| 5-2      | RNV  STN read FIFO threshold           |     |        |
| -------- | -------------------------------------- | --- | ------ |
| 7-6      | RNV  Controller 2 FIFO threshold       |     |        |
| 3C5  30  | Architectural Configuration (SR30)     |     | 18-24  |
| 0        | RMI  Select single or dual-scan panel  |     |        |
| 7-1      | RMI  Reserved                          |     |        |
|          | Flat Panel Display Mode (SR31)         |     | 18-24  |
3C5  31
| 0   | RMI  CRT test mode                  |     |     |
| --- | ----------------------------------- | --- | --- |
| 1   | RNV  Select flat panel data source  |     |     |
| 2   | RNV  Select CRT/lV data source      |     |     |
| 3   | RNV  Controller test mode           |     |     |
| 4   | RMI  Enable flat panel display      |     |     |
| 5   | RNV  Reserved                       |     |     |
RNV
6  Hardware icon controlled by controller 2
| 7   | RNV  Hardware cursor controlled by controller 2  |     |     |
| --- | ------------------------------------------------ | --- | --- |
A-14 REGISTER REFERENCE

86CM65 Dual Display Accelerator
S3 In"orpornllCi
Table A·2. Extended Sequencer Registers (continued)
| Add  Index    |                                                      | Register Name    | Description  |
| ------------- | ---------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                  | Bit Description  | Page         |
| 3C5  32       | Flat Panel Polarity Control (SR32)                   |                  | 18·26        |
| 0             | R/VV  Tri-state memory interface signals             |                  |              |
| 1             | RNV  CRT HSYNC polarity during simultaneous display  |                  |              |
| 2             | RNV  CRT VSYNC polarity during simultaneous display  |                  |              |
| 3             | RNV  Reserved                                        |                  |              |
| 4             | RNV  Flat panel data polarity                        |                  |              |
| 5             | R/VV  FPDE polarity is active low                    |                  |              |
RNV
6  FPHSYNC/LP polarity is active low
| 7        | RNV  FPVSYNC/FLM polarity is active low  |     |        |
| -------- | ---------------------------------------- | --- | ------ |
| 3C5  34  | Flat Panel AC Modulation (SR34)          |     | 18·27  |
RNV  Clock period units for MOD pulse
6-0
| 7        | RNV  Enable MOD output on pin 615              |     |        |
| -------- | ---------------------------------------------- | --- | ------ |
| 3C5  35  | Flat Panel Modulation Clock Select (SR35)      |     | 18-27  |
| 3-0      | RNV  Reserved                                  |     |        |
| 4        | RNV  MOD clock select                          |     |        |
| 7-5      | RNV  Reserved                                  |     |        |
| 3C5  36  | Flat Panel Dither Control (SR36)               |     | 18-28  |
| 0        | R/VV  Select number of bits for dithering      |     |        |
| 2-1      | RNV  Reserved                                  |     |        |
| 5-3      | R/VV  Select number of bits in the base color  |     |        |
RNV
7-6  Dither control
| 3C5  37  | Flat Panel FRC Weight Select RAM (SR37)  |     | 18-28  |
| -------- | ---------------------------------------- | --- | ------ |
| 3-0      | R/VV  Weight select value pointer        |     |        |
| 7-4      | R/VV  Reserved                           |     |        |
3C5  38  Flat Panel FRC Weight Select RAM Data (SR38)  18·29
| 7-0      | RNV  Weight select data              |     |     |
| -------- | ------------------------------------ | --- | --- |
| 3C5  39  | Flat Panel Algorithm Control (SR39)  |     |     |
18·29
| 1-0      | RNV  Select STN or TFT panel type  |     |        |
| -------- | ---------------------------------- | --- | ------ |
| 2        | RNV  Reserved                      |     |        |
| 4-3      | RNV  Select FRC gray levels        |     |        |
| 7-5      | RNV  Reserved                      |     |        |
| 3C5  3A  | Flat Panel FRC Tuning 1 (SR3A)     |     | 18·30  |
| 7-0      | RNV  FRC tuning data 15-8          |     |        |
| 3C5  3B  | Flat Panel FRC Tuning 2 (SR3B)     |     | 18·30  |
| 7-0      | RNV  FRC tuning data 7-0           |     |        |
| 3C5  3C  | Flat Panel FRC Tuning 3 (SR3C)     |     | 18·30  |
RNV
1-0  FRCtuning
| 2    | RNV  STN test mode  |     |     |
| ---- | ------------------- | --- | --- |
| 7-2  | RNV  Reserved       |     |     |
REGISTER REFERENCE  A-15

86CM65 Dual Display Accelerator
sa InDorporated
Table A-2. Extended Sequencer Registers (continued)
| Add  Index    |                                                          | Register Name    | Description  |
| ------------- | -------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                      | Bit Description  | Page         |
| 3C5  3D       | Flat Panel Configuration 1 (SR3D)                        |                  | 18-31        |
| 2-0           | RNV  Data output format                                  |                  |              |
| 3             | RNV  Panel output configuration select                   |                  |              |
| 4             | RNV  Disable LP and FPSCLK during vertical blank         |                  |              |
| 5             | RNV  Disable FPSCLK during first line of vertical blank  |                  |              |
| 6             | RNV  Select flat panel data drive strength               |                  |              |
| 7             | RNV  Select the FPSCLK drive stregth                     |                  |              |
| 3C5  40       | Flat Panel Dither Control (SR40)                         |                  | 18-32        |
| 0             | RNV  Reserved                                            |                  |              |
| 3-1           | RNV  FPSCLK delay                                        |                  |              |
| 4             | RNV                                                      |                  |              |
Force flat panel data and control signals low
| 5   | RNV  FPSCLK forced low during non-display interval  |     |     |
| --- | --------------------------------------------------- | --- | --- |
| 6   | RNV  Double edge pixel clocking for TFT panels      |     |     |
RNV  Enable FPPOL output
7
| 3C5  41  | Flat Panel Power Sequence Control (SR41)  |     | 18-33  |
| -------- | ----------------------------------------- | --- | ------ |
| 1-0      | RNV  Reserved                             |     |        |
RNV  Power down phase timing
2
| 3   | RNV  Power up phase timing  |     |     |
| --- | --------------------------- | --- | --- |
5-4  Reserved
RNV  Standv timer resolution
7-6
| 3C5  42  | Flat Panel Power Management Control (SR42)  |     | 18·33  |
| -------- | ------------------------------------------- | --- | ------ |
| 0        | RNV  Reserved                               |     |        |
| 1        | RNV  Enable software suspend                |     |        |
| 3-2      | RNV  Reserved                               |     |        |
| 4        | RNV  Enable hardware standby                |     |        |
| 5        | RNV  Enable software standby                |     |        |
| 7-6      | RNV  Suspend debounce timer value           |     |        |
| 3C5  43  | Flat Panel Standby Control (SR43)           |     | 18-34  |
| 5-0      | RNV  Standby timer timeout value            |     |        |
RNV
6  Enable activity mode
| 7        | RNV  Reserved                       |     |        |
| -------- | ----------------------------------- | --- | ------ |
| 3C5  44  | Flat Panel Power Management (SR44)  |     | 18-34  |
RNV
3-0  Reserved
| 4        | R  Specify STANDBY pin function         |     |        |
| -------- | --------------------------------------- | --- | ------ |
| 7-5      | R  Reserved                             |     |        |
| 3C5  45  | Flat Panel PLL Power Management (SR45)  |     | 18-35  |
| 1-0      | RNV  Suspend to PLL power down time     |     |        |
| 3-2      | RNV  Select DRAM refresh type           |     |        |
| 7-4      | RNV  Reserved                           |     |        |
A-16 REGISTER REFERENCE

86CM65 Dual Display Accelerator
53 Incorporated
Table A-2. Extended Sequencer Registers (continued)
| Add  Index    |                                            | Register Name    | Description  |
| ------------- | ------------------------------------------ | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                        | Bit Description  | Page         |
| 3C5  46       | Flat Panel Power Management Status (SR46)  |                  | 18-36        |
| 4-0           | R  Reserved                                |                  |              |
| 5             | R  1  =  in Standby mode                   |                  |              |
=
| 6   | R  1  in idle power down state  |     |     |
| --- | ------------------------------- | --- | --- |
=
| 7        | R  1  in idle power UP state           |     |        |
| -------- | -------------------------------------- | --- | ------ |
| 3C5  47  | CLUT Control (SR47)                    |     | 18-36  |
| 1-0      | RNV  Select CLUT for reads and writes  |     |        |
| 7-2      | RNV  Reserved                          |     |        |
| 3C5  48  | Icon Mode (SR48)                       |     | 18-37  |
| 0        | RNV  Enable hardware icon              |     |        |
| 1        | RNV  Select icon mode                  |     |        |
| 2        | RNV  Double X size                     |     |        |
| 3        | RNV  Double Y size                     |     |        |
RNV
6-4  Select icon mag
| 7        | RNY  Reserved            |     |        |
| -------- | ------------------------ | --- | ------ |
| 3C5  49  | Icon Color Stack (SR49)  |     | 18-38  |
RNV
7-0  Values for four 24 bits/pixel colors
| 3C5  4A  | Icon X Position High (SR4A)                         |     | 18-39  |
| -------- | --------------------------------------------------- | --- | ------ |
| 1-0      | RNY  High order 3 bits of icon horizontal position  |     |        |
| 7-2      | RNV  Reserved                                       |     |        |
| 3C5  4B  | Icon X Position Low (SR4B)                          |     | 18-39  |
| 7-0      | RNV  Low order 8 bits of icon horizontal position   |     |        |
| 3C5  4C  | Icon Y Position High (SR4C)                         |     | 18-40  |
| 1-0      | RNV  High order 3 bits of icon vertical position    |     |        |
| 7-2      | RNV  Reserved                                       |     |        |
| 3C5  4D  | Icon Y Position Low (SR4D)                          |     | 18-40  |
| 7-0      | RNY  Low order 8 bits of icon vertical position     |     |        |
| 3C5  4E  | Icon Address (SR4E)                                 |     | 18-41  |
| 7-0      | RNV  Icon map base address                          |     |        |
| 3C5  4F  | Dual-5can STN Data Address (SR4F)                   |     | 18-41  |
| 7-0      | RNY  STN panel data start address adjustment        |     |        |
REGISTER REFERENCE A-17

86CM65 Dual Display Accelerator
S3 Incorpar.ted
Table A-2. Extended Sequencer Registers (continued)
| Add  Index    |                                             | Register Name    | Description  |
| ------------- | ------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                         | Bit Description  | Page         |
|               | Dual-5can STN Frame Buffer Size Low (SR50)  |                  | 18-42        |
3C5  50
| 7-0      | R  STN frame buffer size low byte            |     |        |
| -------- | -------------------------------------------- | --- | ------ |
| 3C5  51  | Dual-Scan STN Frame Buffer Size High (SR51)  |     | 18-42  |
| 7-0      | R  STN frame buffer size high byte           |     |        |
| 3C5  52  | Flat Panel PWM Register (SR52)               |     | 18-43  |
| 0        | R!W  Enable PWM                              |     |        |
| 1        | R!W  PWM source clock select                 |     |        |
| 3-2      | R/W  Reserved                                |     |        |
| 6-4      | R!W  PWM clock divide                        |     |        |
R!W  Reserved
| 3C5  53  | Flat Panel PWM Duty Cycle (SR53)                            |     | 18-44  |
| -------- | ----------------------------------------------------------- | --- | ------ |
| 7-0      | R!W  Specify PWM duty cycle                                 |     |        |
| 3C5  54  | Flat Panel Horizontal Compensation 1 (SR54)                 |     | 18-44  |
| 1-0      | R!W  Text mode horizontal expansion                         |     |        |
| 3-2      | R!W  Graphics mode horizontal expansion                     |     |        |
| 4        | R!W  Enable horizontal centering                            |     |        |
| 6-5      | R!W  Reserved                                               |     |        |
| 7        | R!W  Enable line graphics character codes                   |     |        |
| 3C5  55  | Flat Panel Horizontal Compensation 2 (SR55)                 |     | 18-45  |
| 0        | R!W  Enable 40-character text mode horizontal expansion     |     |        |
| 1        | R!W  Enable SO-character text mode horizontal expansion     |     |        |
| 2        | R!W  Enable 640-column graphics mode horizontal expansion   |     |        |
| 3        | R!W  Enable SOO-column graphics mode horizontal expansion   |     |        |
| 4        | R!W  Enable 1024-column graphics mode horizontal expansion  |     |        |
R!W  Reserved
| 3C5  56  | Flat Panel Horizontal Compensation 1 (SR56)  |     | 18-46  |
| -------- | -------------------------------------------- | --- | ------ |
R!W
| 1-0      | Text mode vertical expansion                               |     |        |
| -------- | ---------------------------------------------------------- | --- | ------ |
| 3-2      | R!W  Graphics mode vertical expansion                      |     |        |
| 4        | R!W  Enable vertical centering                             |     |        |
| 7-5      | R!W  Reserved                                              |     |        |
| 3C5  57  | Flat Pane Vertical Compensation 1 (SR57)                   |     | 18-47  |
| 0        | R!W  Enable 350-line text mode vertical expansion          |     |        |
| 1        | R!W  Enable 200/400-line text mode vertical expansion      |     |        |
| 2        | R!W  Enable 350-line graphics mode vertical expansion      |     |        |
| 3        | R!W  Enable 200/400-line oraphics mode vertical expansion  |     |        |
| 4        | R!W  Enable 4S0-line oraphics mode vertical expansion      |     |        |
| 5        | R!W  Enable 600-line oraohics mode vertical expansion      |     |        |
| 6        | R!W  Enable 768-line graphics mode vertical expansion      |     |        |
| 7        | R!W  Reserved                                              |     |        |
A-1B REGISTER REFERENCE

86CM65 Dual Display Accelerator
S3 Incarparded
Table A-2. Extended Sequencer Registers (continued)
| Add  Index    |                                                                  | Register Name    | Description  |
| ------------- | ---------------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                              | Bit Description  | Page         |
| 58            | Flat Panel Horizontal Border (SR58)                              |                  |              |
| 3C5           |                                                                  |                  | 18-48        |
| 7-0           | R  Character clocks per horizontal line not used by video imaQe  |                  |              |
3C5  59  Flat Panel Horizontal Expansion Factor (SR59)  18-48
| 0        | R  Bit 8 of SR58                            |     |        |
| -------- | ------------------------------------------- | --- | ------ |
| 3-'      | R  Reserved                                 |     |        |
| 6-4      | R  Horizontal expansion factor              |     |        |
| 7        | R  Reserved                                 |     |        |
| 3C5  5A  | Flat Panel Vertical Border (SR5A)           |     | 18-49  |
| 7-0      | R  Number of lines not used by video imaae  |     |        |
3C5  5B  Flat Panel Horizontal Expansion Factor (SR5B)  18-49
| 0  ,  | R  Bit 8 of SR5A  |     |     |
| ----- | ----------------- | --- | --- |
R  Automatic vertical expansion detect
| 2    | R  Automatic vertical centering detect                        |     |        |
| ---- | ------------------------------------------------------------- | --- | ------ |
| 3    | R  o =  Current scan line will be repeated on next scan line  |     |        |
| 6-4  | R  Vertical expansion factor                                  |     |        |
| 7    | R  Reserved                                                   |     |        |
|      | Flat Panel Display Enable Position Control (SR5C)             |     | 18-50  |
3C5  5C
| 3-0      | RNV  Display enable start postion for Controller ,   |     |        |
| -------- | ---------------------------------------------------- | --- | ------ |
| 7-4      | RNV  Display enable start position for Controller 2  |     |        |
| 3C5  5D  | Flat Panel/CRT Sync Position Control (SR5D)          |     | 18-51  |
| 3-0      | RNV  Sync start position for Controller'             |     |        |
| 7-4      | RNV  Sync start position for Controller 2            |     |        |
| 3C5  5F  | FIFO Control (SR5f)                                  |     | 18-51  |
| ,        | RNV                                                  |     |        |
0  Controller' FIFO memory access requests disabled (test)
RNJ  Controller 2 FIFO memory access requests disabled (test)
| 2        | RNV  STN Write FIFO memory access requests disabled (test)  |     |        |
| -------- | ----------------------------------------------------------- | --- | ------ |
| 3        | RNV  SNT READ FIFO memorv access requests disabled (test)   |     |        |
| 4        | RNV  , MCLK reads for Controller 2 FIFO                     |     |        |
| 7-5      | RNV  Reserved                                               |     |        |
| 60       | Flat Panel Horizontal Total (SR60)                          |     |        |
| 3C5      |                                                             |     | 18-52  |
| 7-0      | RNV  character clocks/line -5                               |     |        |
| 3C5  61  | Flat Panel Horizontal Panel Size (SR61)                     |     | 18-53  |
| 7-0      | RNJ  Horizontal panel resolution -,                         |     |        |
| 3C5  62  | Flat Panel Horizontal Blank Start (SR63)                    |     | 18-53  |
| 7-0      | RNJ  Character clock counter value at blank start           |     |        |
| 3C5  63  | Flat Panel Horizontal Blank End (SR63)                      |     | 18-54  |
RNV
4-0  Character clock counter value at blank end
| 7-5  | RNV  Reserved  |     |     |
| ---- | -------------- | --- | --- |
REGISTER REFERENCE  A-19

86CM65 Dual Display Accelerator
Table A·2. Extended Sequencer Registers (continued)
| Add  Index    |                                                    | Register Name    | Description  |
| ------------- | -------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                | Bit Description  | Page         |
| 3C5  64       | Flat Panel Horizontal SynC Start (SR64)            |                  | 18-54        |
| 7-0           | RNI/  Character clock counter value at sync start  |                  |              |
| 3C5  65       | Flat Panel Horizontal SynC End (SR65)              |                  | 18-55        |
| 4-0           | RNI/  Character clock counter value at sync end    |                  |              |
| 6-5           | RNI/  Reserved                                     |                  |              |
| 7             | 'RNI/  Horizontal sync end bit 5                   |                  |              |
| 3C5  66       | Flat Panel Horizontal Overflow (SR66)              |                  | 18-55        |
| 0             | RNI/  Flat panel horizontal total bit 8            |                  |              |
Flat panel horizontal panel size bit 8
| 1        | RNI/                                                                  |     |        |
| -------- | --------------------------------------------------------------------- | --- | ------ |
| 2        | RNI/  Flat panel horizontal blank start bit 8                         |     |        |
| 3        | RNI/  Flat panel horizontal blank period areater than 64 char clocks  |     |        |
| 4        | RNI/  Flat panel horizontal sync start bit 8                          |     |        |
| 5        | RNI/  Flat panel horizontal sync period greater than 32 char clocks   |     |        |
| 7-6      | RNI/  Reserved                                                        |     |        |
| 3C5  68  | Flat Panel Vertical Total (SR68)                                      |     | 18·56  |
| 7-0      | RNI/  Scan lines between vertical syncs -2                            |     |        |
| 3C5  69  | Flat Panel Vertical Panel Size (SR69)                                 |     | 18·57  |
| 7-0      | RNI/  '  Vertical panel resolution -1                                 |     |        |
| 3C5  6A  | Flat Panel Vertical Blank Start (SR6A)                                |     | 18-57  |
| 7-0      | RNI/  Scan line counter value at blank start -1                       |     |        |
| 3C5  6B  | Flat Panel Vertical Blank End (SR6B)                                  |     | 18·58  |
| 4-0      | RNI/  Scan line counter value at blank end                            |     |        |
| 7-5      | RNI/  Reserved                                                        |     |        |
| 3C5  6C  | Flat Panel Vertical SynC Start (SR6C)                                 |     | 18·58  |
| 7-0      | RNI/  Scan line counter value at sync start -1                        |     |        |
| 3C5  6D  | Flat Panel Vertical Sync End (SR6D)                                   |     | 18-59  |
| 3-0      | RNI/  Scan line counter value at sync end                             |     |        |
| 7-4      | RNI/  Reserved                                                        |     |        |
| 3C5  6E  | Flat Panel Vertical Overflow 1 (SR6E)                                 |     | 18·59  |
| 2-0      | RNI/  Flat panel vertical total bits 10-8                             |     |        |
| 3        | RNI/  Reserved                                                        |     |        |
| 6-4      | RNI/  Flat panel vertical panel size bits 10-8                        |     |        |
| 7        | RfIN  Reserved                                                        |     |        |
| 3C5  6F  | Flat Panel Vertical Overflow 2 (SR6F)                                 |     | 18-60  |
| 2-0      | RNI/  Flat panel vertical blank start bits 10-8                       |     |        |
| 3        | RNI/  Reserved                                                        |     |        |
| 6-4      | Rf\N  Flat panel vertical sync start bits 10-8                        |     |        |
| 7        | Rf\N  Reserved                                                        |     |        |
A-20 REGISTER REFERENCE

86CM65 Dual Display Accelerator
53 Incorponted
A.3 EXTENDED CRTC REGISTERS
All of these registers are read/write protected at power-up by hardware reset. In order to read/write
these registers, the Register Lock 1 register (CR3B) must be loaded with a binary unlock key pattern
(see the register description). CTR registers are unlocked by setting CR39 = A5H. The registers will
remain unlocked until the key pattern is reset. 1 = B for monochrome, D for color.
Table A-3.  Extended CRTC Registers
| Add  Index    |                           | Register Name    | Description  |
| ------------- | ------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                       | Bit Description  | Page         |
| 375  22       | RNI/  CRT Test 1 (CTR22)  |                  | 19-1         |
| 6-0           | RNI/  Reserved            |                  |              |
| 7             | RNI/                      |                  |              |
Provide pixel data to DAC (Test) -Paired
| 375  2D  | Device ID High (CR2D)            |     | 19-2  |
| -------- | -------------------------------- | --- | ----- |
| 7-0      | R  High byte of device 10 (SSH)  |     |       |
Device ID Low (CR2E)
| 375  2E  |                                                                |     | 19-2  |
| -------- | -------------------------------------------------------------- | --- | ----- |
| 7-0      | R  Low byte of device 10 (12H)                                 |     |       |
| 315  2F  | Revision (CR2F)                                                |     | 19-2  |
| 7-0      | R  4x                                                          |     |       |
| 375  30  | Chip ID/Rev (CR30)                                             |     | 19-3  |
| 7-0      | R  Chip Identification -El H                                   |     |       |
| 375  31  | Memory Configuration (CR31)                                    |     | 19-3  |
| 0        | RNI/  Reserved                                                 |     |       |
| 1        | RNI/  Enable two-page screen image                             |     |       |
| 2        | RNI/  Enable VGA l6-Bit Memorv Bus Width                       |     |       |
| 3        | RNI/  Use Enhanced mode memory mapping                         |     |       |
| 5-4      | RNI/  Reserved                                                 |     |       |
| 6        | RNI/  Enable high speed text dis[llay font fetch mode -Paired  |     |       |
7
RNI/  Reserved
| 375  32  | Backward Compatibil/1Y 1 (CR32)                        |     | 19-4  |
| -------- | ------------------------------------------------------ | --- | ----- |
| 1-0      | RNI/  Reserved                                         |     |       |
| 2        | RNI/  Force internal dot clock to be not divided bv 2  |     |       |
| 3        | RNI/  Reserved                                         |     |       |
| 4        | RNI/  Enable interrupt generation                      |     |       |
| 5        | RNI/  Reserved                                         |     |       |
| 6        | RNI/  Standard VGA memory wrap at 256K boundary        |     |       |
| 7        | RNI/  Reserved                                         |     |       |
REGISTER REFERENCE A-21

86CM65 Dual Display Accelerator
Table A-3. Extended CRTC Registers (continued)
| Add  Index    |                                                                  | Register Name    | Description  |
| ------------- | ---------------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                              | Bit Description  | Page         |
| 375  33       | Backward Compatibility 2 (CR33)                                  |                  | 19-5         |
| 0             | AMI  Reserved                                                    |                  |              |
| 1             | AMI  Disable write protection provided by CRll 7 on CR7 1,6      |                  |              |
| 2             | AMI  Reserved                                                    |                  |              |
| 3             | AMI  VCLK is inverted DCLK -Paired                               |                  |              |
| 4             | AMI  Disable writes to RAMDAC registers (3C6H-3C9H) -Paired      |                  |              |
| 5             | AMI  BLANK signal active during non-active video_period -Paired  |                  |              |
| 6             | AMI  Disable writes to ARQ-ARF registers -Paired                 |                  |              |
| 7             | AMI  Reserved                                                    |                  |              |
| 375  34       | Backward Compatibility 3 (CR34)                                  |                  | 19-6         |
| 0             | AMI  PCI DAC snoop method select                                 |                  |              |
| 1             | RNY  Disable PCI master abort handling during DAC snoop          |                  |              |
| 2             | AMI  Disable PCI retry handling during DAC snoop                 |                  |              |
| 3             | AMI  Reserved                                                    |                  |              |
| 4             | AMI  Enable Display Start FIFO Fetch register (CR3B) -Paired     |                  |              |
AMI
5  Force to 8 dots/character text mode
| 6   | AMI  Reserved                     |     |     |
| --- | --------------------------------- | --- | --- |
| 7   | AMI  Lock 3C2H 3-2 (DCLK select)  |     |     |
35
| 375      | CRT Register Lock (CR35) -Paired                              |     | 19-7  |
| -------- | ------------------------------------------------------------- | --- | ----- |
| 3-0      | RNY  Reserved                                                 |     |       |
| 4        | ANY  Lock Vertical Timing registers                           |     |       |
| 5        | AMI  Lock Horizontal Timing registers                         |     |       |
| 6        | ANY  Lock CRl and 3C2H 6                                      |     |       |
| 7        | AMI  Lock CR12 and 3C2H 7                                     |     |       |
| 375  36  | Configuration 1 (CR36)                                        |     | 19-8  |
| 1-0      | AMI  Reserved                                                 |     |       |
| 3-2      | RNY  Select Memory page mode (fast page, EDO or l-cycle EDO)  |     |       |
| 4        | ANY  Reserved                                                 |     |       |
Define display memory size
| 7-5      | ANY                     |     |       |
| -------- | ----------------------- | --- | ----- |
| 375  37  | Configuration 2 (CR37)  |     | 19-8  |
| 0        | ANY  Reserved           |     |       |
ANY  Disable test mode (outputs tri-stated)
1
| 2    | ANY  Reserved                 |     |     |
| ---- | ----------------------------- | --- | --- |
| 3    | ANY  Use internal MCLK, DCLK  |     |     |
| 4    | ANY  Reserved                 |     |     |
| 7-5  | ANY  Define paneltype         |     |     |
A-22 REGISTER REFERENCE

86CM65 Dual Display Accelerator
sa Inaorporated
Table A-3. Extended CRTC Registers (continued)
| Add  Index    |                                                                | Register Name    | Description  |
| ------------- | -------------------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                                            | Bit Description  | Page         |
| 315  38       | Register Lock 1 (CR38) -Shared                                 |                  | 19-10        |
| 7-0           | R/IN  Unlock S3 VGA registers (CR3D-CR3C)                      |                  |              |
| 315  39       | Register Lock 2 (CR39) -Shared                                 |                  | 19-10        |
| 7-0           | R/IN  Unlock System Control and System Extension registers     |                  |              |
| 1-0           | R/IN  Select alternate refresh count per horizontal line       |                  |              |
| 2             | R/IN  Enable alternate refresh count (CR3A 1-0)                |                  |              |
| 3             | R/IN  Enable simultaneous VGA text and Enhanced modes -Paired  |                  |              |
| 4             | R/IN  Enable 8-, 16-or 24/32-bit color Enhanced modes -Paired  |                  |              |
| 5             | R/IN  Enable high speed text font writing                      |                  |              |
| 6             | R/IN  Reserved                                                 |                  |              |
| 7             | RMI  Disable PCI bus read burst cycles                         |                  |              |
| 315  3A       | Miscellaneous 1 (CR3A)                                         |                  | 19-10        |
| 315  3B       | Start Display FIFO Fetch (CR3B) -Paired                        |                  | 19-11        |
7-0  Specify start of display FIFO fetches for screen refreshing
RMI
| 315  3C  | Interlace Retrace Start (CR3C) -Paired               |     | 19-12  |
| -------- | ---------------------------------------------------- | --- | ------ |
| 7-0      | RMI  Specify interlaced mode retrace start position  |     |        |
NTSC/PAL Control (CR3D)
| 315  3D  |                                     |     | 19-12  |
| -------- | ----------------------------------- | --- | ------ |
| 0        | R/IN  Enable "TV mode               |     |        |
| 3-1      | RMI  Select "TV output              |     |        |
| 4        | R/IN  Select black and white video  |     |        |
| 5        | RMI  Select NTSC or PAL             |     |        |
| 7-6      | R/IN  Reserved                      |     |        |
REGISTER REFERENCE A-23

86CM65 Dual Display Accelerator
S3 Incorporllted
Table A·3. Extended CRTC Registers (continued)
| Add  Index    |                                            | Register Name    | Description  |
| ------------- | ------------------------------------------ | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                        | Bit Description  | Page         |
| 375  40       | $ystem Configuration (CR40)                |                  | 19·13        |
| 0             | RNV  Enable Enhanced mode register access  |                  |              |
| 7·1           | RNV  Reserved                              |                  |              |
| 375  41       | BIOS Flag (CR41)                           |                  | 19·13        |
| 7-0           | RNI/  Used by the video BIOS               |                  |              |
| 375  42       | Mode Control (CR42)                        |                  | 19·13        |
| 4-0           | RNV  Reserved                              |                  |              |
| 5             | RNV  Select Interlaced mode -Paired        |                  |              |
Reserved
| 7~       | RNI/                                                        |     |        |
| -------- | ----------------------------------------------------------- | --- | ------ |
| 375  43  | Extended Mode (CR43) • Paired                               |     | 19·14  |
| 2-0      | RNV  Reserved                                               |     |        |
| 3        | RNV  Select character blink rate                            |     |        |
| 4        | RNV  Reserved                                               |     |        |
| 6-5      | RNV  Select cursor blink rate                               |     |        |
| 7        | RNI/  Enable horizontal counter double mode                 |     |        |
| 375  45  | Hardware Graphics Cursor Mode (CR45)                        |     | 19·14  |
| 0        | RNI/  Enable hardwaregrat:>hics cursor                      |     |        |
| 3-1      | RNI/  Reserved                                              |     |        |
| 4        | RNI/  Set up space at right of bit map for hardware cursor  |     |        |
| 7-5      | RNI/  Reserved                                              |     |        |
A-24 REGISTER REFERENCE

86CM65 Dual Display Accelerator
53 Incorporated
Table A-3. Extended CRTC Registers (continued)
| Add  Index    |      | Register Name    | Description  |
| ------------- | ---- | ---------------- | ------------ |
| ress  Bit(s)  | R/W  | Bit Description  | Page         |
375  46-47  Hardware Graphics Cursor Origin-X (CR46-CR47)  19-15
R/W
| 10-0   | X-coordinate of the hardware cursor left side  |     |     |
| ------ | ---------------------------------------------- | --- | --- |
| 15-11  | RMI  Reserved                                  |     |     |
375  48-49  Hardware Graphics Cursor Origin-V (CR48-CR49)  19-15
| 10-0   | R/W  V-coordinate of the hardware cursor upper line  |     |     |
| ------ | ---------------------------------------------------- | --- | --- |
| 15-11  | R/W  Reserved                                        |     |     |
375  4A  Hardware Gr~hics Cursor Foreground Stack (CR4A)  19-16
| 7-0  | R/W  Hardware cursor forearound color (3 reaisters)  |     |     |
| ---- | ---------------------------------------------------- | --- | --- |
375  4B  Hardware Graphics Cursor Background Stack (CR4B)  19-16
| 7-0  | R/W  Hardware cursor backaround color (3 reaisters)  |     |     |
| ---- | ---------------------------------------------------- | --- | --- |
375  4C-4D  Hardware Graphics Cursor Start Address (CR4C-CR4D)  19-16
| 12-0   | RMI  Hardware cursor start address  |     |     |
| ------ | ----------------------------------- | --- | --- |
| 15-13  | R/W  Reserved                       |     |     |
375  4E  Hardware Graphics Cursor Pattem Display Start X-Pixel  19-17
Position (CR4E)
R/W  Hardware cursor displaystart x-coordinate
5-0
| 7-6  | R/W  Reserved  |     |     |
| ---- | -------------- | --- | --- |
375  4F  Hardware Graphics Cursor Pattem Display Start V-Pixel  19-17
Position (CR4F)
| 5-0  | R/W  Hardware cursor display start v-coordinate  |     |     |
| ---- | ------------------------------------------------ | --- | --- |
| 7-6  | RMI  Reserved                                    |     |     |
REGISTER REFERENCE  A-25

86CM65 Dual Display Accelerator
S3 Incorporated
Table A·3. Extended CRTC Registers (continued)
| Add  Index     |                                | Register Name    | Description  |
| -------------- | ------------------------------ | ---------------- | ------------ |
| dress  Bitls)  | R/W                            | Bit Description  | Page         |
| 315  50        | Extended System Cont 1 (CR50)  |                  | 19·18        |
0  RNV  Most significant bit of screen width definition (see bits 7-6)
| 3-'      | RNV  Reserved                             |     |        |
| -------- | ----------------------------------------- | --- | ------ |
| 5-4      | RNV  Pixel length select                  |     |        |
| 7-6      | RNV  With bit 0, screen width definition  |     |        |
| 315  51  | Extended System Cont 2 (CR51)· Paired     |     | 19-18  |
| 3-0      | RNI  Reserved                             |     |        |
| 5-4      | RNV  Logical screen width bits 9-8        |     |        |
RNV
| 7-6      | Reserved                     |     |        |
| -------- | ---------------------------- | --- | ------ |
| 315  52  | Extended BIOS Flag 1 ICR52)  |     | 19·19  |
| 7-0      | RNV  Used by the video BIOS  |     |        |
53
| 315  | Extended Memory Cont 1 ICR53)  |     | 19·19  |
| ---- | ------------------------------ | --- | ------ |
0  RNV  Reserved
| 2-1  | RNV  Big endian byte swap select for linear addressing  |     |     |
| ---- | ------------------------------------------------------- | --- | --- |
| 4-3  | RNV  Memory-mapped I/O type select                      |     |     |
5  RNV  MMIO window select (A8000H or B8000H)
6  RNV  Enable nibble swap
7  RNV  Reserved
| 315  54  | Extended Memory Cont 2 ICR54)                                      |     | 19·20  |
| -------- | ------------------------------------------------------------------ | --- | ------ |
| 1-0      | RNV  Big end ian byte swap select (not linear addressing or image  |     |        |
transfers)
| 2,7-3    | RNI  Specifv M parameter for CPU and Graphics Engine accesses  |     |        |
| -------- | -------------------------------------------------------------- | --- | ------ |
| 315  55  | Extended DAC Contro11CR55)                                     |     | 19·20  |
| 3-0      | RNI  Reserved                                                  |     |        |
3  RNV  Reserved
4  RNV  Enable X-1' windows hardware cursor mode
| 7-5      | RNV  Reserved                 |     |        |
| -------- | ----------------------------- | --- | ------ |
| 315  56  | External SytlC Cont 1 ICR56)  |     | 19·21  |
0  ,  RNV  Reserved
RNI  HSYNC output buffer tri-stated
2  RNV  VSYNC output buffer tri-stated
| 7-3  | RNV  Reserved  |     |     |
| ---- | -------------- | --- | --- |
A-26 REGISTER REFERENCE

86CM65 Dual Display Accelerator
83 Incorporllted
Table A-3. Extended CRTC Registers (continued)
| Add  Index    |                                               | Register Name    | Description  |
| ------------- | --------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  |                                               | Bit Description  |              |
| R/W           |                                               |                  | P~ge         |
| 315  58       | Linear Address Window Control (CR58)          |                  | 19-22        |
| 1-0  R!W      | Linear addressing window size                 |                  |              |
| 3-2  R!W      | Reserved                                      |                  |              |
| 4  R!W        | Enable linear addressi~                       |                  |              |
| 6-5  R!W      | Reserved                                      |                  |              |
| 7  R!W        | RAS pre-charge timing adjustment              |                  |              |
| 315  59-5A    | Linear Address Window Position (CR59-5A)      |                  | 19-23        |
| 15-0  R!W     | Linear addressina window position bits 31-16  |                  |              |
| 315  5C       | General Out Port (CR5C)                       |                  | 19-24        |
| 7-0  R!W      | General Output Port                           |                  |              |
| 315  5D       | Extended Horizontal Overflow (CR5D)           |                  | 19-24        |
| 0  R!W        | Horizontal total bit 8 (CRO)                  |                  |              |
| 1  RNI/       | Horizontal display end bit 8 (CR1)            |                  |              |
| 2  R!W        | Start horizontal blank bit 8 (CR2)            |                  |              |
| 3  R!W        | End horizontal blank bit 7 (CR3. CR5)         |                  |              |
| 4  RNI/       | Start horizontal sync position bit 8 (CR4)    |                  |              |
| 5  R!W        | End horizontal sync position bit 6 (CR5)      |                  |              |
| 6  R!W        | Start FIFO Fetch bit 8 (CR3B)                 |                  |              |
| 7  RNI/       | Reserved                                      |                  |              |
| 315  5E       | Extended Vertical Overflow (CR5E)             |                  | 19-25        |
| 0  R!W        | Vertical total bit 10 (CR6)                   |                  |              |
| 1  R!W        | Vertical display end bit 10 (CR 12)           |                  |              |
R!W  Start vertical blank bit 10 (CR 15)
2
| 3  R!W     | Reserved                                             |     |        |
| ---------- | ---------------------------------------------------- | --- | ------ |
| 4  RNI/    | Vertical retrace start bit 10 (CR1 0)                |     |        |
| 5  RNI/    | Reserved                                             |     |        |
| 6  RNI/    | Line compare position bit 10 (CR18)                  |     |        |
| 7  R!W     | Reserved                                             |     |        |
| 315  60    | Extended Memory Control 3 (CR60)                     |     | 19-25  |
| 7-0  RNI/  | Specify N parameter for primary stream FIFO control  |     |        |
| 315  61    | Extended Memory Control 4 (CR611                     |     | 19-26  |
| 4-0  RNI/  | Reserved                                             |     |        |
R!W
| 6-5      | Bia endian byte swap select for imaae writes  |     |        |
| -------- | --------------------------------------------- | --- | ------ |
| 7  R!W   | Reserved                                      |     |        |
| 315  63  | Horizontal TIming Control (CR63)-Paired       |     | 19-26  |
R!W  Delav horizontal timingjlllrameters by DCLKs
2-0
| 4-3  R!W  | Delav horizontal timina parameters bv character clocks  |     |     |
| --------- | ------------------------------------------------------- | --- | --- |
| 7-5  R!W  | Reserved                                                |     |     |
REGISTER REFERENCE A-27

86CM65 Dual Display Accelerator
Table A-3. Extended CRTC Registers (continued)
| Add  Index    |      | Register Name    | Description  |
| ------------- | ---- | ---------------- | ------------ |
| ress  Bit(s)  | R/W  | Bit Description  | Page         |
375  65  Extended Miscellaneous Control (CR65)-Paired  19-27
| 2-0      | RNV  Reserved                            |     |        |
| -------- | ---------------------------------------- | --- | ------ |
| 4-3      | RNV  Delay BLANK by DCLK                 |     |        |
| 7-5      | RNV  Reserved                            |     |        |
| 375  66  | Extended Miscellaneous Control 1 (CR66)  |     | 19-27  |
RNV
| 0   | Enable enhanced functions -Paired           |     |     |
| --- | ------------------------------------------- | --- | --- |
| 1   | R/W  Software reset of the Graphics Engine  |     |     |
| 2   | R/W  Reserved                               |     |     |
RNV  PCI disconnect on write with FIFO full or read with FIFO empty
3
| 6-4  | RNV  Reserved                                    |     |        |
| ---- | ------------------------------------------------ | --- | ------ |
| 7    | RNV  Enable PCI bus disconnect                   |     |        |
| 375  | Extended Miscellaneous Control 2 (CR67) -Paired  |     | 19-28  |
QI
| 0        | RNV  VCLK is in phase with DCLK           |     |        |
| -------- | ----------------------------------------- | --- | ------ |
| 1        | RNV  Reserved                             |     |        |
| 3-2      | R/W  Streams Processor mode select        |     |        |
| 7-4      | R/W  Select RAMDAC color mode             |     |        |
| 375  68  | Configuration 3 (CR68)                    |     | 19-29  |
| 1-0      | RNV  CAS. DE stretch time selection       |     |        |
| 2        | RNV  RAS low timing select                |     |        |
| 3        | RNV  RAS precharge timing select          |     |        |
| 6-4      | RNV  Video BIOS area                      |     |        |
| 7        | RNV  Reserved                             |     |        |
| 375  69  | Extended System Control 3 (CR69) -Paired  |     | 19-30  |
| 2-0      | RNV  Display start address bits 18-16     |     |        |
RNV
| 7-3      | Reserved                          |     |        |
| -------- | --------------------------------- | --- | ------ |
| 375  6A  | Extended System Control 4 (CR6A)  |     | 19-30  |
| 4-0      | RNV  CPU base address bits 18-14  |     |        |
| 7-5      | R/W  Reserved                     |     |        |
| 375  6B  | Extended BIOS Flag 3 (CR6B)       |     | 19-31  |
| 7-0      | RNV  Used by the video BIOS       |     |        |
| 375  6C  | Extended BIOS Flag 4 (CR6C)       |     | 19-31  |
| 7-0      | RNV  Used bv the video BIOS       |     |        |
| 375  60  | Extended BIOS Flag 5 (CR6D)       |     | 19-31  |
| 7-0      | RNV  Used I::lY the video BIOS    |     |        |
| 375  6E  | Extended BIOS Flag 6 (CR6E)       |     | 19-32  |
| 7-0      | RNV  Used by the video BIOS       |     |        |
A-28 REGISTER REFERENCE

86CM65 Dual Display Accelerator
S3 Incorporlltod
Table A-3. Extended CRTC Registers (continued)
| Add  Index    |                                                   | Register Name    | Description  |
| ------------- | ------------------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                               | Bit Description  | Page         |
| 315  6F       | Configuration 4 (CR6F)                            |                  | 19-32        |
| 0             | R/W  Reserved                                     |                  |              |
| 1             | R/W  Select I/O address for Serial Port register  |                  |              |
| 2             | R/W  Disable effect of bit 1 of this register     |                  |              |
| 4-3           | R/W  WE delay                                     |                  |              |
| 7-5           | R/W  Reserved                                     |                  |              |
315  71  Extended Miscellaneous Control 2 (CR71) -Paired  19-33
| 0        | R/W  Reserved                                |     |        |
| -------- | -------------------------------------------- | --- | ------ |
| 1        | R/W  Screen off bit select                   |     |        |
| 4-2      | R/W  Reserved                                |     |        |
| 5        | R/W  Screen off                              |     |        |
| 7-6      | R/W  Reserved                                |     |        |
| 315  72  | Extended Memorv Control 5 (CR72)             |     | 19-34  |
| 7-0      | R/W  Secondary_stream FIFO Nparameter value  |     |        |
| 315  73  | Extended Memory Control 6 (CR73)             |     | 19-34  |
| 7-0      | R/W  Controller 2 FIFO N parameter value     |     |        |
| 315  74  | Extended Memory Control 7 (CR74              |     | 19-35  |
| 1-0      | R/W  Reserved                                |     |        |
| 2        | R/W  1 MCLK STN FIFO reads/Writes            |     |        |
| 7-3      | R/W  Reserved                                |     |        |
| 315  75  | Extended Memory Control 8 (CR75)             |     | 19-35  |
| 7-0      | R/W  STN FIFO N parameter value              |     |        |
| 315  76  | Extended Memory Control 9 (CR76)             |     | 19-35  |
R/W  LPB M parameter value
5-0
| 7-6  | R/W  Reserved  |     |     |
| ---- | -------------- | --- | --- |
REGISTER REFERENCE A-29

86CM65 Dual Display Accelerator
A.4 ENHANCED COMMANDS REGISTERS
This section lists the registers which support .the enhanced drawing functions. All of these registers
are enabled only if bit 0 of the System Configuration register (CR40) is set to 1.
| Table A-4.  Enhanced Commands Registers  |                                            |                  |              |
| ---------------------------------------- | ------------------------------------------ | ---------------- | ------------ |
| Add  Index                               |                                            | Register Name    | Description  |
| ress  Bit(s)                             | R/W                                        | Bit Description  | Page         |
| 42E8                                     | Subsystem Status                           |                  | 20-1         |
| 0                                        | R  Vertical sync interrupt status          |                  |              |
| 1                                        | R  Graphics Engine busy interrupt status   |                  |              |
| 2                                        | R  Command FIFO overflow interrupt status  |                  |              |
| 3                                        | R  Command FIFO empty interrupt status     |                  |              |
| 6-4                                      | R  Reserved                                |                  |              |
| 7                                        | R  4 or 8 bit planes                       |                  |              |
| 15-8                                     | R  Reserved                                |                  |              |
| 42E8                                     | Subsystem Control                          |                  | 20-2         |
| 0                                        | W  Clear vertical sync interrupt status    |                  |              |
W  Clear Graphics Engine busy interrupt status
1
| 2      | W  Clear Command FIFO overflow interruPt status  |     |     |
| ------ | ------------------------------------------------ | --- | --- |
| 3      | W  Clear Command FIFO empty interrupt status     |     |     |
| 7-4    | W  Reserved                                      |     |     |
| 8      | W  Vertical sync interrupt enabled               |     |     |
| 9      | W  Graphics Engine busy interrupt enabled        |     |     |
| 10     | W  Command FIFO overflow interrupt enabled       |     |     |
| 11     | W  Command FIFO empty interrupt enabled          |     |     |
| 13-12  | W  Reserved                                      |     |     |
| 15-14  | W  Graphics Engine software reset selection      |     |     |
20-3
| 4AE8  | Advanced Function Control            |     |     |
| ----- | ------------------------------------ | --- | --- |
| 0     | R!W  Enable Enhanced mode functions  |     |     |
| 1     | R!W  Reserved                        |     |     |
R!W
| 2   | Specify 4 bits/pixel Enhanced mode  |     |     |
| --- | ----------------------------------- | --- | --- |
| 3   | R!W  Reserved                       |     |     |
| 4   | R!W  Enable linear addressing       |     |     |
R!W  Reserved
15-5
| 82E8   | Current Y -Position                    |     | 20-4  |
| ------ | -------------------------------------- | --- | ----- |
| 11-0   | R!W  Pixel vertical screen coordinate  |     |       |
| 15-12  | R!W  Reserved                          |     |       |
20-4
| 86E8   | Current X-Position                       |     |     |
| ------ | ---------------------------------------- | --- | --- |
| 11-0   | R!W  Pixel horizontal screen coordinate  |     |     |
| 15-12  | R!W  Reserved                            |     |     |

86CM65 Dual Display Accelerator
53 Incorpora.ad
Table A-4. Enhanced Commands Registers (continued)
| Add  Index   |     | Register Name    | Description  |
| ------------ | --- | ---------------- | ------------ |
| Bit(s)  R/W  |     | Bit Description  | Page         |
ress
| SAES        | Destination V Position/Axial Step Constant                         |     | 20-5  |
| ----------- | ------------------------------------------------------------------ | --- | ----- |
| 11-01  RNY  | Specifies ending vertical coordinate or axial step constant for a  |     |       |
| 13-0        | number of drawing commands                                         |     |       |
| 15-12  ANY  | Reserved (Bits 15-14 for step constant)                            |     |       |
|             | Destination X Position/Diagonal Step Constant                      |     | 20-5  |
SEES
| 11-01  ANY  | Specifies ending horizontal coordinate or diagonal step  |     |       |
| ----------- | -------------------------------------------------------- | --- | ----- |
| 13-0        | constant for a number of drawing commands                |     |       |
| 15-12  RNY  | Reserved (Bits 15-14 for step constant)                  |     |       |
| 92ES        | Line Error Term                                          |     | 20-6  |
| 13-0  RNY   | Error term for line draws                                |     |       |
| 15-14  ANY  | Reserved                                                 |     |       |
| 96ES        | Maior Axis Pixel Count                                   |     | 20-6  |
| 11-0  ANY   | Length of the longest axis (pixels -1)                   |     |       |
| 15-12  ANY  | Reserved                                                 |     |       |
| 9AES        | Graphics Processor Status                                |     | 20-7  |
R  Low 8 bits of field showing FI Fa slots available (see bits 15-11)
7-{J
| 8  R      | Reserved                                   |     |       |
| --------- | ------------------------------------------ | --- | ----- |
| 9  R      | Graphics Engine busy                       |     |       |
| 10  R     | All FIFO slots empty                       |     |       |
| 15-11  R  | High 5 bits of FIFO status (see bits 7-0)  |     |       |
| 9AES      | Drawing Command                            |     | 20-S  |
| 0  W      | Must be programmed to 1                    |     |       |
| 1  W      | Select across the plane pixel mode         |     |       |
| 2  W      | Last pixel will not be drawn               |     |       |
| 3  W      | Select radial drawing direction            |     |       |
| 4  W      | Draw pixels                                |     |       |
| 7-5  W    | Select drawing direction                   |     |       |
| 8  W      | Wait for CPU data                          |     |       |
| 10-9  W   | Select system bus size                     |     |       |
| 11  W     | Reserved                                   |     |       |
| 12  W     | Enable byte swap                           |     |       |
| 15-13  W  | Select command type                        |     |       |
REGISTER REFERENCE A-31

86CM65 Dual Display Accelerator
Table A-4. Enhanced Commands Registers (continued)
| Add  Index    |                                    | Register Name    | Description  |
| ------------- | ---------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                | Bit Description  | Page         |
| gEES          | Short Stroke Vector Transfer       |                  | 20-10        |
| 3-0           | W  Length of vector 1 (pixels -1)  |                  |              |
4  W  Draw pixels
| 7-5   | W  Select drawing direction                                    |     |        |
| ----- | -------------------------------------------------------------- | --- | ------ |
| 15-8  | W  Duplicate of bits 7-0 to define second short stroke vector  |     |        |
| A2ES  | Background Color                                               |     | 20-11  |
| 31-0  | R!W  Background color value                                    |     |        |
| A6ES  | Foreground Color                                               |     | 20-11  |
| 31-0  | R!W  Foreground Color value                                    |     |        |
| AAES  | Bitplane Write Mask                                            |     | 20·12  |
| 31-0  | R!W  Each bit enables updating of corresponding bit plane      |     |        |
| AEES  | Bltplane Read Mask                                             |     | 20·12  |
| 31-0  | R!W  Each bit enables reading of corresponding bit plane       |     |        |
| B2ES  | Color Compare                                                  |     | 20-13  |
| 31-0  | R!W  Color value to be compared with current bitmap color      |     |        |
| B6ES  | Background Mix                                                 |     | 20-13  |
| 3-0   | W  Select mix type                                             |     |        |
4  W  Reserved
| 6-5   | W  Select color source  |     |        |
| ----- | ----------------------- | --- | ------ |
| 15-7  | W  Reserved             |     |        |
| BAES  | Foreground Mix          |     | 20·13  |
| 3-0   | W  Select mix type      |     |        |
4  W  Reserved
| 6-5   | W  Select color source  |     |     |
| ----- | ----------------------- | --- | --- |
| 15-7  | Reserved                |     |     |
W
| BEES     | Read Register Data                                     |     | 20·14  |
| -------- | ------------------------------------------------------ | --- | ------ |
| 15-0     | R  Data from register selected bv bits 2-0 of BEE8H E  |     |        |
| BEES  0  | Minor Axis Pixel Count                                 |     | 20-15  |
| 11-0     | W  Rectangle height (pixels -1)                        |     |        |
| 15-12    | W  Reserved                                            |     |        |
| BEES  1  | Top Scissors                                           |     | 20·15  |
| 11-0     | W  Top side of the clipping rectangle                  |     |        |
| 15-12    | W  Reserved                                            |     |        |
| BEES  2  | Left Scissors                                          |     | 20·15  |
| 11-0     | W  Left side of the clipping rectangle                 |     |        |
| 15-12    | W  Reserved                                            |     |        |
A~32 REGISTER REFERENCE

86CM65 Dual Display Accelerator
S3lnoorporllted
Table A-4. Enhanced Commands Registers (continued)
| Add  Index    |                                           | Register Name    | Description  |
| ------------- | ----------------------------------------- | ---------------- | ------------ |
| ress  Bit(s)  | R/W                                       | Bit Description  | Page         |
| BEES  3       | Bottom Scissors                           |                  | 20-16        |
| 11-0          | W  Bottom side of the clipping rectangle  |                  |              |
| 15-12         | W  Reserved                               |                  |              |
| BEES  4       | Right Scissors                            |                  | 20·16        |
| 11-0          | W  Right side of the clipping rectangle   |                  |              |
| 15-12         | W  Reserved                               |                  |              |
A
| BEES     | Pixel Control                                                   |     | 20-16  |
| -------- | --------------------------------------------------------------- | --- | ------ |
| 5-0      | W  Reserved                                                     |     |        |
| 7-6      | W  Select mix register                                          |     |        |
| 11-8     | W  Reserved                                                     |     |        |
| 15-12    | W  OAH (index)                                                  |     |        |
| BEES  D  | Multifunction Control Miscellaneous 2                           |     | 20·17  |
| 2-0      | W  Destination base address location in memory                  |     |        |
| 3        | W  Reserved                                                     |     |        |
| 6-4      | W  Source base address location in memory                       |     |        |
| 11-7     | W  Reserved                                                     |     |        |
| 15-12    | W  ODH (index)                                                  |     |        |
| BEES  E  | Multifunction Control Miscellaneous                             |     | 20·1S  |
| 1-0      | W  Destination base address bits 21-20                          |     |        |
| 3-2      | W  Source base address bits 21-20                               |     |        |
| 4        | W  Select lJPper word for 32-bit register accesses              |     |        |
| 5        | W  Onlvpixels outside the clipping rectan~le are drawn          |     |        |
| 6        | W  Reserved                                                     |     |        |
| 7        | W  Don't update bitmap if source is not equal to color compare  |     |        |
color
| 8        | W  Enable color comparison          |     |        |
| -------- | ----------------------------------- | --- | ------ |
| 9        | W  Select 32-bit command registers  |     |        |
| 11-10    | W  Reserved                         |     |        |
| 15-12    | W  OEH (index)                      |     |        |
| BEES  F  | Read Register Select                |     | 20-19  |
Select register to be read
| 2-0    | W                                                              |     |        |
| ------ | -------------------------------------------------------------- | --- | ------ |
| 11-4   | W  Reserved                                                    |     |        |
| 15-12  | W  OFH (index)                                                 |     |        |
| E2ES   | Pixel Data Transfer                                            |     | 20·20  |
| 15-0   | W  Data transfer register (CPU to Graphics Engine) -low word   |     |        |
| E2EA   | Pixel Data Transfer-Extension                                  |     | 20-20  |
| 15-0   | W  Data transfer register (CPU to Graphics Engine) -high word  |     |        |
REGISTER REFERENCE A-33

86CM65 Dual Display Accelerator
S31ncorpomed
A.5 STREAMS PROCESSOR REGISTERS
| Table A-5.  Streams Processor Registers  |                                                              |                  |              |
| ---------------------------------------- | ------------------------------------------------------------ | ---------------- | ------------ |
| Add  Index                               |                                                              | Register Name    | Description  |
| dress  Bit!s)                            | R/W                                                          | Bit Description  | Page         |
| 8180                                     | Primary Stream Control                                       |                  | 21-1         |
| 23-0                                     | R/IN  Reserved                                               |                  |              |
| 26-24                                    | R/IN  Primary stream input data format                       |                  |              |
| 27                                       | R/IN  Reserved                                               |                  |              |
| 30-28                                    | R/IN  Primary stream filter characteristics                  |                  |              |
| 31                                       | R/IN  Reserved                                               |                  |              |
| 8184                                     | Color/Chroma Key Control                                     |                  | 21-2         |
| 7-0                                      | R/IN  BN/Cr key value (lower bound for chroma)               |                  |              |
| 15-8                                     | R/IN  G/U/Cb key value (lower bound for chroma)              |                  |              |
| 23-16                                    | R/IN  RIY key value (lower bound for chroma)                 |                  |              |
| 26-24                                    | R/IN  RGB color comparison precision                         |                  |              |
| 27                                       | R/IN  Reserved                                               |                  |              |
| 28                                       | R/IN  Color key control (full compare or bit 16 of 1.5.5.5)  |                  |              |
| 31-29                                    | R/IN  Reserved                                               |                  |              |
| 8190                                     | Secondary Stream Control                                     |                  | 21-3         |
| 11-0                                     | R/IN  DDA horizontal accumulator initial value               |                  |              |
| 23-12                                    | R/IN  Reserved                                               |                  |              |
| 26-24                                    | R/IN  Secondary stream input data format                     |                  |              |
| 27                                       | R/IN  Reserved                                               |                  |              |
| 30-28                                    | R/IN '  Secondary stream filter characteristics              |                  |              |
| 31                                       | R/IN  Reserved                                               |                  |              |
| 8194                                     | Chroma Key Upper Bound                                       |                  | 21-4         |
| 7-0                                      | R/IN  VlCr key value (upper bound)                           |                  |              |
| 15-8                                     | R/IN  U/Cb key value (upper bound)                           |                  |              |
| 23-16                                    | R/IN  Y key value (upper bound)                              |                  |              |
| 31-24                                    | R/IN  Reserved                                               |                  |              |
| 8198                                     | Secondary Stream Stretch/Riter Constants                     |                  | 21-4         |
| 10-0                                     | R/IN  K1 horizontal scale factor                             |                  |              |
| 15-11                                    | R/IN  Reserved                                               |                  |              |
| 26-16                                    | R/IN  K2 horizontal scale factor                             |                  |              |
| 31-27                                    | R/IN  Reserved                                               |                  |              |
A-34 REGISTER REFERENCE

86CM65 Dual Display Accelerator
S3 I ...r porlltod
Table A-5. Streams Processor Registers (continued)
Register Name
| Add  Index     |                                           |                  | Description  |
| -------------- | ----------------------------------------- | ---------------- | ------------ |
| dress  Bit(s)  | R/W                                       | Bit Description  | Page         |
| 81AO           | Blend Control                             |                  | 21-5         |
| 1-0            | RNV  Reserved                             |                  |              |
| 4-2            | RMI  Secondary_ stream blend coefficient  |                  |              |
| 9-5            | RMI  Reserved                             |                  |              |
| 12-10          | RNV  Primary stream blend coefficient     |                  |              |
| 23-13          | RNV  Reserved                             |                  |              |
RNV
| 26-24  | Compose mode                           |     |       |
| ------ | -------------------------------------- | --- | ----- |
| 31-27  | RNV  Reserved                          |     |       |
| 81CO   | Primary Stream Frame Buffer Address 0  |     | 21-6  |
RNV  Primary stream frame buffer starting address 0
21-0
| 31-22  | RNV  Reserved                                   |     |       |
| ------ | ----------------------------------------------- | --- | ----- |
| 81C4   | Primary Stream Frame Buffer Address 1           |     | 21-6  |
| 21-0   | Primary stream frame buffer starting address 1  |     |       |
RMI
| 31-22  | RNV  Reserved                               |     |       |
| ------ | ------------------------------------------- | --- | ----- |
| 81C8   | Primary Stream Stride                       |     | 21-7  |
| 11-0   | RNV  Primary stream stride                  |     |       |
| 31-12  | RNV  Reserved                               |     |       |
| 81CC   | Double Buffer/LPB Support                   |     | 21-7  |
| 0      | RNV  Select primary frame buffer address 1  |     |       |
RNV
| 2-1  | Select secondary frame buffer address         |     |     |
| ---- | --------------------------------------------- | --- | --- |
| 3    | RNV  Reserved                                 |     |     |
| 4    | RNV  Select LPB frame buffer start address 1  |     |     |
RNV
| 5     | LPB input buffer select loading at end of frame          |     |       |
| ----- | -------------------------------------------------------- | --- | ----- |
| 6     | RJ/W  Selected LPB input buffer toggles at end of frame  |     |       |
| 31-7  | RMI  Reserved                                            |     |       |
|       | Secondary Stream Frame Buffer Address 0                  |     | 21-9  |
8100
| 21-0   | RNV  Secondary stream frame buffer startina address 0  |     |        |
| ------ | ------------------------------------------------------ | --- | ------ |
| 31-22  | RNV  Reserved                                          |     |        |
| 8104   | Secondal"Y_ Stream Frame Buffer Address 1              |     | 21-9   |
| 21-0   | RNV  Secondary stream frame buffer starting address 1  |     |        |
| 31-22  | RNV  Reserved                                          |     |        |
| 81D8   | Secondary Stream Stride                                |     | 21-10  |
| 11-0   | RMI  Second~rystream stride                            |     |        |
| 31-12  | RNV  Reserved                                          |     |        |
REGISTER REFERENCE A-35

86CM65 Dual Display Accelerator
83 Incorponted
Table A-5. Streams Processor Registers (continued)
| Add  Index     |                | Register Name    | Description  |
| -------------- | -------------- | ---------------- | ------------ |
| dress  Bit(s)  | R/W            | Bit Description  | Page         |
| 81DC           | Blend Control  |                  | 21-10        |
| 2-0            | R!W  Reserved  |                  |              |
R!W  Pixel stop fetch position
12-3
| 18-13  | R!W  Reserved                    |     |     |
| ------ | -------------------------------- | --- | --- |
| 28-19  | R!W  Pixel start fetch position  |     |     |
Reserved
| 29     | RMI                                          |     |        |
| ------ | -------------------------------------------- | --- | ------ |
| 30     | R!W  Primary stream on top                   |     |        |
| 31     | R!W  Enable opaque overlay control           |     |        |
| 81EO   | K1 Vertical Scale Factor                     |     | 21-12  |
| 10-0   | R!W  Kl vertical scale factor                |     |        |
| 31-11  | RMI  Reserved                                |     |        |
| 81E4   | K2 Vertical Scale Factor                     |     | 21-12  |
| 10-0   | RMI  K2 vertical scale factor                |     |        |
| 31-11  | RMI  Reserved                                |     |        |
| 81E8   | DDA Vertical Accumulator Initial Value       |     | 21-13  |
| 11-0   | R!W  DDA vertical accumulator initial value  |     |        |
| 31-12  | RMI  Reserved                                |     |        |
| 81EC   | Streams FIFO and RAS Controls                |     | 21-13  |
| 4-0    | RMI  Streams FIFO allocation                 |     |        |
| 9-5    | R!W  Secondary FIFO threshold                |     |        |
| 14-10  | R!W  Primary FIFO threshold                  |     |        |
| 15     | R!W  RAS low time control                    |     |        |
| 16     | R!W  RAS precharge control                   |     |        |
| 17     | RMI  Reserved                                |     |        |
Specify memory size for LPB memory cvcles
| 18     | RMI                                      |     |        |
| ------ | ---------------------------------------- | --- | ------ |
| 31-19  | RMI  Reserved                            |     |        |
| 81FO   | Primary Stream Window Start Coordinates  |     | 21·14  |
| 10-0   | RMI  Primary stream Y start              |     |        |
| 15-11  | R!W  Reserved                            |     |        |
| 26-16  | RMI  Primary stream X start              |     |        |
| 31-27  | RMI  Reserved                            |     |        |
| 81F4   | Primary Stream Window Size               |     | 21·15  |
| 10-0   | R!W  Primary stream heiaht               |     |        |
| 15-11  | RMI  Reserved                            |     |        |
| 26-16  | R!W  Primary stream width                |     |        |
| 31-27  | R!W  Reserved                            |     |        |
A-36 REGISTER REFERENCE

86CM65 Dual Display Accelerator
53 Incorporatad
Table A-5. Streams Processor Registers (continued)
| Add  Index     |                                            | Register Name    | Description  |
| -------------- | ------------------------------------------ | ---------------- | ------------ |
| dress  Bit(s)  | R/W                                        | Bit Description  | Page         |
| 81F8           | Secondary Stream Window Start Coordinates  |                  | 21-15        |
| 10-0           | RtN  Secondary stream Y start              |                  |              |
| 15-11          | RtN  Reserved                              |                  |              |
| 26-16          | RtN  Secondary stream X start              |                  |              |
| 31-27          | RMI  Reserved                              |                  |              |
| 81FC           | Secondary Stream Window Size               |                  | 21-16        |
| 10-0           | RtN  Secondary stream height               |                  |              |
RtN
| 15-11  | Reserved                     |     |     |
| ------ | ---------------------------- | --- | --- |
| 26-16  | RMI  Secondary stream width  |     |     |
| 31-27  | RMI  Reserved                |     |     |
REGISTER REFERENCE A-37

86CM65 Dual Display Accelerator
S3 Inoorporated
A.6 LOCAL PERIPHERAL BUS REGISTERS
| Table A-6.  Local Peripheral Bus Registers  |     |     |     |
| ------------------------------------------- | --- | --- | --- |
Register Name
| Add  Index     |                                                  |                  | Description  |
| -------------- | ------------------------------------------------ | ---------------- | ------------ |
| dress  Bitls)  | R/W                                              | Bit Description  | Page         |
| FFOO           | LPBMode                                          |                  | 22-1         |
| 0              | RNJ  Enable LPB                                  |                  |              |
| 3-1            | RNJ  LPB mode                                    |                  |              |
| 4              | RNJ  Reset LPB                                   |                  |              |
| 5              | RNI  Write every other received frame to memory  |                  |              |
| 6              | RNJ  No byte swap for incoming video             |                  |              |
| 8-7            | RNJ  Reserved                                    |                  |              |
| 9              | RNJ  LPB vertical sync is active high            |                  |              |
| 10             | RNJ  LPB horizontal sync is active high          |                  |              |
| 11             | W  CPUVSYNC                                      |                  |              |
| 12             | W  CPU HSYNC                                     |                  |              |
| 13             | W  Load base address currently pointed to        |                  |              |
| 15-14          | RNJ  Reserved                                    |                  |              |
| 17-16          | RNJ  Maximum compressed data bust size           |                  |              |
| 20-18          | RNI  Reserved                                    |                  |              |
| 22-21          | RNI  Video FIFO threshold                        |                  |              |
| 23             | RNI  Reserved                                    |                  |              |
| 24             | RNI  LPB clock driven by LCLK                    |                  |              |
| 25             | RNJ  Don't add stride after first HSYNC          |                  |              |
| 26             | RNJ  Invert the LCLK input                       |                  |              |
| 30-27          | RNJ  Reserved                                    |                  |              |
| 31             | RNI  Reserved                                    |                  |              |
| FF04           | LPB FIFO Status                                  |                  | 22-4         |
| 3'()           | R  LPB output FIFO status                        |                  |              |
| 10-4           | R  Reserved                                      |                  |              |
| 11             | R  LPB output FIFO full                          |                  |              |
| 12             | R  LPB output FIFO empty                         |                  |              |
| 13             | R  LPB output FIFO almost empty                  |                  |              |
| 21-14          | R  Reserved                                      |                  |              |
| 20             | R  LPB video FIFO 0 full                         |                  |              |
| 21             | R  LPB video FIFO 0 empty                        |                  |              |
| 22             | R  LPB video FIFO 0 almost emJ)ty                |                  |              |
| 28-23          | R  Reserved                                      |                  |              |
| 29             | R  LPB video FIFO 1 full                         |                  |              |
| 30             | R  LPB video FIFO 1 empty                        |                  |              |
| 31             | R  LPB video FIFO 1 almost empty                 |                  |              |
A-3S REGISTER REFERENCE

86CM65 Dual Display Accelerator
sa Incorporated
Table A-6. Local Peripheral Bus Registers (continued)
| Add  Index     |                                                           | Register Name    | Description  |
| -------------- | --------------------------------------------------------- | ---------------- | ------------ |
| dress  Bit(s)  | R/W                                                       | Bit Description  | Page         |
| FF08           | LPB Interrupt Flags                                       |                  | 22-5         |
| 0              | RNI  LPB Output FIFO empty                                |                  |              |
| 1              | RN.J  HSYNC (end of line) input on gin 202                |                  |              |
| 2              | RN.J  VSYNC (end of frame) input on j:lin 203             |                  |              |
| 3              | RNI  Serial port start condition detected                 |                  |              |
| 154            | RN.J  Reserved                                            |                  |              |
| 16             | RNI  Enable LPB output FIFO empty interrupt               |                  |              |
| 17             | RNI  Enable HSYNC (end of line) input interrupt           |                  |              |
| 18             | RNI  Enable VSYNC (end of frame) input interrupt          |                  |              |
| 19             | RNI  Enable serial port start condition detect interrupt  |                  |              |
RN.J
| 23-20  | Reserved                                                           |     |       |
| ------ | ------------------------------------------------------------------ | --- | ----- |
| 24     | RN.J  Drive SPCLK low on receipt of a serial port start condition  |     |       |
| 31-25  | RNI  Reserved                                                      |     |       |
|        | LPB Frame Buffer Address 0                                         |     | 22-7  |
FFOC
| 21-0   | RN.J  LPB frame buffer address 0                     |     |       |
| ------ | ---------------------------------------------------- | --- | ----- |
| 31-22  | RNI  Reserved                                        |     |       |
| FF10   | LPB Frame Buffer Address 1                           |     | 22-7  |
| 21-0   | RN.J  LPB frame buffer address 1                     |     |       |
| 31-22  | RN.J  Reserved                                       |     |       |
| FF14   | LPB Direct Read/Write Address                        |     | 22-8  |
| 20-0   | RN.J  Address of MPEG decoder address to read/write  |     |       |
| 23-21  | RN.J  MPEG decoder transaction type                  |     |       |
| 31-24  | RN.J  Reserved                                       |     |       |
| FF18   | LPB Direct Read/Write Data                           |     | 22-8  |
| 31-0   | RNI  LPB direct read/Write data                      |     |       |
| FF1C   | LPB General Purpose Inp_ut/Olltput Port              |     | 22-9  |
| 3-0    | RNI  General purpose output data port                |     |       |
| 7-4    | R  General purpose input data port                   |     |       |
| 31-8   | RN.J  Reserved                                       |     |       |
REGISTER REFERENCE A-39

86CM65 Dual Display Accelerator
83 lnoorporated
Table A-6. Local Peripheral Bus Registers (continued)
| Add  Index     |              | Register Name    | Description  |
| -------------- | ------------ | ---------------- | ------------ |
| dress  Bit(s)  | R/W          | Bit Description  | Page         |
| FF20           | Serial Port  |                  | 22·9         |
o = Serial clock write on pin 205, 1 = pin 205 tri-state
| 0   | R/IN  |     |     |
| --- | ----- | --- | --- |
o = Serial data write on pin 206, 1 = pin 206 tri-state
| 1   | R/IN  |     |     |
| --- | ----- | --- | --- |
o = Serial clock low on pin 205, 1 = pin 205 tri-state
| 2   | R   |     |     |
| --- | --- | --- | --- |
R  o = Serial data low on pin 206, 1 = pin 206 tri-state
3
| 4      | RNI/  Enable serial port function             |     |        |
| ------ | --------------------------------------------- | --- | ------ |
| 5-7    | R/IN  Reserved                                |     |        |
| 8      | R  Bit 0 mirror (data on byte lane 2 at E2H)  |     |        |
| 9      | R  Bit 1 mirror (data on byte lane 2 at E2H)  |     |        |
| 10     | R  Bit 2 mirror (data on byte lane 2 at E2H)  |     |        |
| 11     | R  Bit 3 mirror (data on byte lane 2 at E2H)  |     |        |
| 12     | R  Bit 4 mirror (data on byte lane 2 at E2H)  |     |        |
| 31-13  | R/IN  Reserved                                |     |        |
| FF24   | LPB Video Input Window Size                   |     | 22·11  |
Video input line width
| 11-0   | RNI/                                |     |        |
| ------ | ----------------------------------- | --- | ------ |
| 15-12  | R/IN  Reserved                      |     |        |
| 24-16  | R/IN  Video input window height     |     |        |
| 31-25  | R/IN  Reserved                      |     |        |
| FF28   | LPB Video Data Offsets              |     | 22·12  |
| 11-0   | R/IN  Horizontal video data offset  |     |        |
| 15-12  | R/IN  Reserved                      |     |        |
| 24-16  | RNI/  Vertical video data offset    |     |        |
| 31-25  | R/IN  Reserved                      |     |        |
| FF2C   | LPB Horizontal Decimation Control   |     | 22·12  |
| 31-0   | R/IN  Video data byte mask          |     |        |
| FF30   | LPB Vertical Decimation Control     |     | 22·13  |
| 7-0    | R  Video data line mask             |     |        |
| FF34   | LPB Line Stride                     |     | 22·13  |
| 11-0   | R/IN  Line stride                   |     |        |
| 31-12  | R/IN  Reserved                      |     |        |
| FF40   | LPB Output FIFO                     |     | 22·14  |
| 31-0   | R/IN  Output FIFO data              |     |        |

86CM65 Dual Display Accelerator
83 Incorporated
A.7  PCI CONFIGURATION SPACE REGISTERS
When a PCI configuration read or write command is issued, AD[7:0] contain the address ofthe register
in the configuration space to be accessed.
| Table A-7.  PCI Configuration Space Registers  |      |                  |              |
| ---------------------------------------------- | ---- | ---------------- | ------------ |
| Add  Index                                     |      | Register Name    | Description  |
| dress  Bltls)                                  | R/W  | Bit Description  | Page         |
00
|       | VendorlD                                              |     | 23-1  |
| ----- | ----------------------------------------------------- | --- | ----- |
| 15-0  | R  Hardwired to 5333H                                 |     |       |
| 02    | DevicelD                                              |     | 23-2  |
| 15-0  | R  Hardwired to 8812H                                 |     |       |
| 04    | Command                                               |     | 23-2  |
| 0     | RNJ  Response to I/O space accesses enabled           |     |       |
| 1     | RNJ  Response to memory space accesses enabled        |     |       |
| 4-2   | RNJ  Reserved                                         |     |       |
| 5     | RNJ  Enable DAC snooping                              |     |       |
| 15-6  | RNJ  Reserved                                         |     |       |
| 06    | Status                                                |     | 23-3  |
| 8-0   | RNV  Reserved                                         |     |       |
| 10-9  | RNJ  Hardwired to select medium device select timing  |     |       |
RNJ
| 15-11  | Reserved                                                        |     |       |
| ------ | --------------------------------------------------------------- | --- | ----- |
| 08     | Class Code                                                      |     | 23-3  |
| 31-0   | R  Hardwired to indicate VGA-compatible display controller and  |     |       |
revision level
| 10     | Base Address 0                                                      |     | 23-4  |
| ------ | ------------------------------------------------------------------- | --- | ----- |
| 0      | RNV  Hardwired to indicate base registers map into memory space     |     |       |
| 2-1    | RNJ  Hardwired to allow mapping anYWhere in 32-bit address space    |     |       |
| 3      | RNJ  Hardwired to indicate does not meet prefetchable requirements  |     |       |
| 22-4   | RNV  Reserved                                                       |     |       |
| 31-23  | RNV  Base address 0                                                 |     |       |
| 30     | BIOS Base Address                                                   |     | 23-5  |
RNJ
| 0      | Enable access to BIOS ROM address space  |     |       |
| ------ | ---------------------------------------- | --- | ----- |
| 15-1   | RNJ  Reserved                            |     |       |
| 31-16  | RNJ  Upper 16 bits of BIOS ROM address   |     |       |
| 3C     | Interrupt LIne                           |     | 23-3  |
| 7-0    | RNJ  Interrupt line routing information  |     |       |
| 3D     | Interrupt Pin                            |     | 23-6  |
| 7-0    | R  Hardwired to specify use of INTA      |     |       |
REGISTER REFERENCE A-41

86CM65 Dual Display Accelerator
S3 Incorporllted

S3 86CM65 Dual Display Accelerator
83 Incorpol'llted
Appendix B: Panel Programming Examples
B-1 PANEL PROGRAMMING EXAMPLES

S3 86CM65 Dual Display Accelerator
8a Incorporated
Programming Example: VGA TFT (640 x 480)
Panel Type: VGA
| Horizontal resolution  | 640     | 640     | 640     |     |
| ---------------------- | ------- | ------- | ------- | --- |
| Vertical resolution    | 480     | 480     | 480     |     |
| Dot Clock (MHz)        | 25.175  | 31.500  | 31.500  |     |
| Horizontal fraq (kHz)  | 31.5    | 37.9    | 37.5    |     |
| Refresh rate (Hz)      | 60.0    | 72.0    | 75.0    |     |
Register Description  Register Value  Register Description  Register Value
SR30  Architecture Configuration  010rll  SR50  STN FBSize Low  IF
| SR31  FP Display Mode   | 100rD2    | SR51  STN FB Size High    |     | lC     |
| ----------------------- | --------- | ------------------------- | --- | ------ |
| SR32  FP Pin Control    | 06 or F6  | SR52  PWMControl          |     | 20,21  |
| SR33  Reserved          | 00        | SR53  PWM Duty Cycle      |     | F7     |
| SR34  FP AC Modulation  | 01        | SR54  FP H. Compensation  |     | IF     |
SR35  FP Miscellaneous Control  10  SRSS  FP H. Compensation Ctl  03
SR36  FP Dither Control  00, FO, Al, 59  SR56  FPV. Compensation  IF
SR37  FP Weight Decode Pointer  00  SR57  FP V. Compensation Ctl  OF
| SR38  FP Weight Decode  | 00  | SR58  FP H. Border  |     | read only  |
| ----------------------- | --- | ------------------- | --- | ---------- |
SR39  FP Algorithm Control  00  SR59  FP H. Expansion Factor  read only
| SR3A  FP FRC Tuning 1  | 00  | SRSA  FPV. Border  |     | read only  |
| ---------------------- | --- | ------------------ | --- | ---------- |
SR3B  FP FRC Tuning 2  00  SR5B  FP V. Expansion Factor  read only
SR3C  FP FRC Tuning 3  00  SR5C  FP Display Enable Position  77
SR3D  FP Configuration  01,00,02  SR5D  FP Syncs Position  77
| SR3E  Reserved  | 00  | SR5E  Reserved  |     | 00  |
| --------------- | --- | --------------- | --- | --- |
| SR3F  Reserved  | 00  | SR5F  Reserved  |     | 00  |
ax, Cx, Ex, ax
| SR40  FP Pin Configuration  |     | SR60  FP H. Total  |     | 5F  53  64  |
| --------------------------- | --- | ------------------ | --- | ----------- |
SR41  FP Power Sequence Ctl  OOorOC  SR61  FP H. Panel Size  4F  4F  4F
| SR42  FP Power Mngmt Ctl  | 910rB3  | FP H. Blank Start  |     | 50      |
| ------------------------- | ------- | ------------------ | --- | ------- |
|                           |         | SR62               |     | 50  4F  |
SR43  FP Standby Ctl  010r41  SR53  FP H. Blank End  02  06  07
SR44  FP Power Mngmt  010rl0  SR64  FP H. Sync Start  52  53  52
SR45  FP PLL Power Mngmt  00,01,02,03  SR65  FP H. Sync End  9E  9B  9A
SR46  FP Power Mngmt St81us  read only  SR66  FP H. Overflow 1  00  00  00
| SR47  CLUT Control  | 00,01,02  | SR67  Reserved    |     | 00  00  00  |
| ------------------- | --------- | ----------------- | --- | ----------- |
| SR48  Icon Mode     | 00        | SR68  FPV. Total  |     | OB  06  F2  |
SR49  Icon Color Stack  00  SR69  FP V. Panel Size  DF  OF  OF
SR4A  Icon X Position High  00  SR6A  FP V. Blank Start  E7  E7  DF
SR4B  Icon X Position Low  00  SR6B  FP V. Blank End  04  FF  F2
SR4C  Icon Y Position High  00  SR6C  FP V. Sync Start  E9  E8  EO
SR4D  Icon Y Position Low  00  SR6D  FPV. Sync End  OB  OB  03
| SR4E  Icon Address  | 00  | SR6E  FP V. Overflow 1  |     | 12  12  11  |
| ------------------- | --- | ----------------------- | --- | ----------- |
SR4F  STN Data Address  00  SR6F  FP V. Overflow 2  11  11  11
B-2  PANEL PROGRAMMING EXAMPLES

S3 86CM65 Dual Display Accelerator
83 Incorporated
Programming Example: SVGA TFT (800 x 600)
Panel T~IHI: SVGA
| Horizontal resolution  | 800  800        | 800  800        |     |     |
| ---------------------- | --------------- | --------------- | --- | --- |
| Vertical resolution    | 600  600        | 600  600        |     |     |
| Dot Clock (MHz)        | 36.000  40.000  | 50.000  49.500  |     |     |
| Horizontal freq (kHz)  | 35.1  37.9      | 48.1  46.9      |     |     |
| Refresh rate (Hz)      | 56  60          | 72  75          |     |     |
Register Description  Register Valua  Register Description  Register Valua
SR30  Architecture Configuration  01 or 11  SR50  STN FBSize Low  87
| SR31  FP Display Mode   | 100rD2    | SR51  STN FB Size High    | 2C     |     |
| ----------------------- | --------- | ------------------------- | ------ | --- |
| SR32  FP Pin Control    | 06 or F6  | SR52  PWMControl          | 20,21  |     |
| SR33  Reserved          | 00        | SR53  PWM Duty Cycle      | F7     |     |
| SR34  FP AC Modulation  | 01        | SR54  FP H. Compensation  | 1F     |     |
SR35  FP Miscellaneous Control  10  SR55  FP H. Compensation Ctl  07
SR36  FP Dither Control  00, FO, A1, 59  SR56  FP V. Compensation  1F,15
SR37  FP Weight Decode Pointer  00  SR57  FP V. Compensation Ctl  1F, OF
| SR38  FP Weight Decode  | 00  | SR58  FP H. Border  | read only  |     |
| ----------------------- | --- | ------------------- | ---------- | --- |
SR39  FP Algorithm Control  00  SR59  FP H. Expansion Factor  read only
| SR3A  FP FRC Tuning 1  |     | SR5A  FPV. Border  | read only  |     |
| ---------------------- | --- | ------------------ | ---------- | --- |
00
SR3B  FP FRC Tuning 2  00  SR5B  FP V. Expansion Factor  read only
SR3C  FP FRC Tuning 3  00  SR5C  FP Display Enable Position  77
SR3D  FP Configuration  01,00,02  SR5D  FP Syncs Position  77
| SR3E  Reserved  | 00  | SR5E  Reserved  | 00  |     |
| --------------- | --- | --------------- | --- | --- |
| SR3F  Reserved  | 00  | SR5F  Reserved  | 00  |     |
SR40  FP Pin Configuration  8x, Cx, Ex, 8x  SR60  FPH. Total  7B  7F  70  7F
SR41  FP Power Sequence Ctl  00 or OC  SR61  FP H. Panel Size  63  63  63  63
SR42  FP Power Mngmt Ctl  910rB3  SR62  FP H. Blank Start  63  63  63  63
SR43  FP Standby Ctl  010r41  SR63  FP H. Blank End  1E  02  00  02
SR44  FP Power Mngmt  01 or 10  SR64  FP H. Sync Start  67  69  6B  66
SR45  FP PLL Power Mngmt  00,01,02,03  SR65  FP H. Sync End  90  19  1A  10
SR46  FP Power Mngmt Status  read only  SR66  FP H. Overflow 1  00  00  00  00
| SR47  CLUT Control  | 00,01,02  | SR67  Reserved    |         |         |
| ------------------- | --------- | ----------------- | ------- | ------- |
|                     |           |                   | 00  00  | 00  00  |
| SR48  Icon Mode     | 00        | SR68  FPV. Total  | 6F  72  | 98  6F  |
SR49  Icon Color Stack  00  SR69  FPV. Panel Size  57  57  57  57
SR4A  Icon X Position High  00  SR6A  FP V. Blank Start  57  57  57  57
SR4B  Icon X Position Low  00  SR6B  FP V. Blank End  6F  72  98  6F
SR4C  Icon Y Position High  00  SR6C  FP V. Sync Start  58  58  7C  58
SR4D  Icon Y Position Low  00  SR6D  FPV. Sync End  OA  OC  02  OB
SR4E  Icon Address  00  SR6E  FP V. Overflow 1  22  22  22  22
SR4F  STN Data Address  00  SR6F  FP V. Overflow 2  22  22  22  22
B-3 PANEL PROGRAMMING EXAMPLES

S3 86CM65 Dual Display Accelerator
83 Inoorpomed
Programming Example: XGA TFT (1024 x 768)
Panel Type: XGA
| Horizontal resolution  | 1024   | 1024    | 1024    |     |
| ---------------------- | ------ | ------- | ------- | --- |
| Vertical resolution    | 768    | 768     | 768     |     |
| Dot Clock (MHz)        | 65.00  | 75.000  | 78.750  |     |
| Horizontal fraq (kHz)  | 4B.4   | 57.5    | 60      |     |
| Refresh rate (Hz)      | 60     | 70      | 75      |     |
Register DescriJ)tion  Register Value  Register DescriPtion  Register Value
SR30  Architecture Configuration  01 or 11  SR50  STN FBSize Low  FF
| SR31  FP Display Mode     | 100rD2    | SR51  STN FB Size High        |     | 47     |
| ------------------------- | --------- | ----------------------------- | --- | ------ |
| SR32  FP Pin Control      | 06 or F6  | SR52  PWMControl              |     | 20,21  |
| SR33  Reserved            | 00        | SR53  PWM Duty Cycle          |     | F7     |
| SR34  FP AC Modulation    | 01        | SR54  FP H. Compensation      |     | 1F,15  |
| FP Miscellaneous Control  | 10        |                               |     |        |
| SR35                      |           | SR55  FP H, Compensation Ctl  |     | OF,07  |
SR36  FP Dither Control  00, FO, A1, 59  SR56  FP V. Compensation  1F,15
SR37  FP Weight Decode Pointer  00  SR57  FP V. Compensation Ctl  3F, 1F, OF
| SR38  FP Weight Decode  | 00  | SRSS  FP H. Border  |     | read only  |
| ----------------------- | --- | ------------------- | --- | ---------- |
SR39  FP Algorithm Control  00  SR59  FP H. Expansion Factor  read only
| SR3A  FP FRC Tuning 1  | 00  | SRSA  FPV. Border  |     | read only  |
| ---------------------- | --- | ------------------ | --- | ---------- |
SR3B  FP FRC Tuning 2  00  SR5B  FP V. Expansion Factor  read only
SR3C  FP FRC Tuning 3  00  SR5C  FP Display Enable Position  77
SR3D  FP Configuration  01,00,02  SR5D  FP Syncs Position  77
| SR3E  Reserved  | 00  | SR5E  Reserved  |     | 00  |
| --------------- | --- | --------------- | --- | --- |
| SR3F  Reserved  | 00  | SR5F  Reserved  |     | 00  |
ex, Cx, Ex, ex
| SR40  FP Pin Configuration  |     | SR60  FP H. Total  |     | A3  A1  9F  |
| --------------------------- | --- | ------------------ | --- | ----------- |
SR41  FP Power Sequence Ctl  OOorOC  SR61  FP H. Panel Size  7F  7F  7F
SR42  FP Power Mngmt Ctl  910rB3  SR62  FP H. Blank Start  7F  7F  7F
SR43  FP Standby Ctl  010r41  SR63  FP H. Blank End  06  04  02
| SR44  FP Power Mngmt  | 010r10  |                         |     |             |
| --------------------- | ------- | ----------------------- | --- | ----------- |
|                       |         | SR64  FP H. Sync Start  |     | 63  83  82  |
SR45  FP PLL Power Mngmt  00, 01, 02, 03  SR65  FP H. Sync End  94  94  BE
SR46  FP Power Mngmt Status  read only  SR66  FP H. Overflow 1  00  00  00
| SR47  CLUT Control  | 00,01,02  | SR67  Reserved    |     | 00  00  00  |
| ------------------- | --------- | ----------------- | --- | ----------- |
| SR48  Icon Mode     | 00        | SR68  FPV. Total  |     | 24  24  1E  |
SR49  Icon Color Stack  00  SR69  FP V. Panel Size  FF  FF  FF
SR4A  Icon X Position High  00  SR6A  FP V. Blank Start  FF  FF  FF
SR4B  Icon X Position Low  00  SR6B  FP V. Blank End  24  24  1E
SR4C  Icon Y Position High  00  SR6C  FP V. Sync Start  02  02  00
SR4D  Icon Y Position Low  00  SR6D  FP V. Sync End  08  08  03
| SR4E  Icon Address  | 00  | SR6E  FP V. Overflow 1  |     | 23  22  23  |
| ------------------- | --- | ----------------------- | --- | ----------- |
SR4F  STN Data Address  00  SR6F  FP V. Overflow 2  32  32  32
B-4 PANEL PROGRAMMING EXAMPLES

S3 86CM65 Dual Display Accelerator
Appendix C: Panel Attachment Examples
C-1 PANEL ATTACHMENT EXAMPLES

S3 86CM65 Dual Display Accelerator
sa Inoorpol'llteci
| Panel Hook-Up Diagram - | Hitachi Color TFT 1024 x 768  |     |          |                    |
| ----------------------- | ----------------------------- | --- | -------- | ------------------ |
| Aurora64V+              |                               |     | DATA81T  | Hitachi Color TFT  |
BO Pin IDS Connector  Signal Names  8GA Pin's #  DESCRIPTION  TX31D02VC1CAA
| J22orJ23  |     |     |     | 1024 x 768  |
| --------- | --- | --- | --- | ----------- |
CNI Molex
| 3   | FPDCLK   | 83   |                       | DCLK (CNI-2)   |
| --- | -------- | ---- | --------------------- | -------------- |
| 6   | FPHSYNC  | C4   |                       | HSYNC(CNI-4    |
| 8   | FPVSYNC  | A3   |                       | VSYNC (CNI-5)  |
| 64  | FPVDE    | 815  |                       | DTMG (CNHl1I   |
| 10  | FPDO     | B4   | First Pixel Red Data  | RAO(CNI-7)     |
| 11  | FPDl     | A4   |                       | RAI (CNI-8)    |
| 13  | FPD2     |      |                       | RA2 (CN1-10l   |
C5
| 14  | FPD3  | 85  |                         | RA3 (CN1-lll  |
| --- | ----- | --- | ----------------------- | ------------- |
| 16  | FPD4  | A5  |                         | RA4 (CNI-13)  |
| 17  | FPD5  | 06  |                         | RA5 (CNI-14)  |
| 19  | FPD6  | C6  | First Pixel Green Data  | GAO (CNI-16)  |
| 20  | FPD7  | 86  |                         | GAl ICNI-17l  |
| 22  | FPDB  | A6  |                         | GA2 (CN1-19)  |
| 23  | FPD9  | C7  |                         | GA3(CNI-20    |
GA4 (CNI-22)
| 25  | FPD10  | B7   |                        |               |
| --- | ------ | ---- | ---------------------- | ------------- |
| 26  | FPD11  | A7   |                        | GA5(CNI-23    |
| 28  | FPD12  | 08   | First Pixel Blue Data  | BAO (CNI-25)  |
| 29  | FPD13  | C8   |                        | BAI (CNI-26   |
| 31  | FPD14  | B8   |                        | BA2 (CNI-28)  |
| 32  | FPD15  | AS   |                        | BA3 CNI-29)   |
| 34  | FPD16  | C9   |                        | BA4 (CNI-31)  |
| 35  | FPD17  | B9   |                        | BAS (CNI-32)  |
| 37  | FPD18  | A9   | Second Pixel Red Data  | RBO (CNI-34)  |
| 38  | FPD19  | Cl0  |                        | RBI CNI-20    |
| 40  | FPD20  | Bl0  |                        | RB2 (CNI-37)  |
| 41  | FPD21  |      |                        | RB3 (CNI-38)  |
Al0
| 43     | FPD22    | Cll  |                          | RB4 (CNI-4Ol       |
| ------ | -------- | ---- | ------------------------ | ------------------ |
| 44     | FPD23    | Bl1  |                          | RB5 (CNI-4ll       |
| 46     | FPD24    | All  | Second Pixel Green data  | GBO (CNI-43)       |
| 47     | FPD25    | D12  |                          | GBI (CNI-44)       |
| 49     | FPD26    | C12  |                          | GB2 (CNI-46l       |
| 50     | FPD27    | B12  |                          | GB3 (CNl-47)       |
| 52     | FPD28    | A12  |                          | GB4 (CNI-49)       |
| 53     | FPD29    | C13  |                          | GB5 (CNI-SO)       |
| 55     | FPD30    | B13  | Second Pixel Blue Data   | BBO (CN 1-52)      |
| 56     | FPD31    | A13  |                          | BBI CNI-53         |
| 58     | FPD32    | D14  |                          | BB2 (CN 1-55)      |
| 59     | FPD33    | C14  |                          | BB3 (CNI-56)       |
| 61     | FPD34    | B14  |                          | BB4 (CNI-5B1       |
| 62     | FPD35    | A14  |                          | BB5 CNI-59         |
| 71 73  | VDD LCD  | nla  |                          | VDD(3.3Vl onlY     |
| 75     | VDD LCD  | nla  |                          | Pins 63 64 and 65  |
| 74     | FPPOL    | C15  |                          |                    |
| 77     | VEE LCD  |      |                          |                    |
nla
| 2457      | GND  | nla    |     | VSS Pins are         |
| --------- | ---- | ------ | --- | -------------------- |
| 9 12 15   | GND  | nla    |     | 1 3 6 9 12 15 18     |
| 1821 24   | GND  | nla    |     | 21 24 27 30 33 36    |
| 27 30 33  | GND  | nla    |     | 39 42 45 48 51  54   |
| 63942     | GND  | , nla  |     | 57  60 68 67 and 68  |
| 4548 51   | GND  | ' nla  |     |                      |
| 54 57 60  | GND  | ! nla  |     |                      |
| 63,65,79  | GND  | nla    |     |                      |
C-2 PANEL ATTACHMENT EXAMPLES

S3 86CM65 Dual Display Accelerator
83 Incorporated
| Panel Hook-Up Diagram - | Sharp Color DSTN 640 x 48016 Bit  |     |              |
| ----------------------- | --------------------------------- | --- | ------------ |
| AURORA64V+              |                                   |     | Sharp Color  |
DSTN
| 64 & 10 Pin Connector Sianal Name  |     | BGAPin  | LM64C08P  |
| ---------------------------------- | --- | ------- | --------- |
| Resolution                         |     |         | 640X480   |
16 Bit
Interface
| 3   | FPDCLK   | B3   | XCKICNl-3)      |
| --- | -------- | ---- | --------------- |
| 6   | FPHSYNC  | C4   | LP(CNl-2)       |
| 8   | FPVSYNC  | A3   | YDICN1-l)       |
| 64  | FPVDE    | B15  | I nlc           |
| 10  | FPDO     | B4   | DLO ICN2-17)    |
| 11  | FPDl     | A4   |                 |
| 13  | FPD2     | C5   | DL1 ICN2-18)    |
| 14  | FPD3     | B5   |                 |
| 16  | FPD4     | A5   | DL2ICN2-19))    |
| 17  | FPD5     | D6   |                 |
| 19  | FPD6     | C6   | DL3 ICN2-20))   |
| 20  | FPD7     | B6   |                 |
| 22  | FPDB     | A6   | DL4 ICN2-21)    |
| 23  | FPD9     | C7   |                 |
| 25  | FPD10    | B7   | DL5 ICN2-22)    |
| 26  | FPD11    | A7   |                 |
| 28  | FPD12    | DB   | DL6 ICN2-23)    |
| 29  | FPD13    | CB   |                 |
| 31  | FPD14    | BB   | DL7 ICN2-24)    |
| 32  | FPD15    | AB   |                 |
| 34  | FPD16    | C9   |                 |
| 35  | FPD17    | B9   |                 |
| 37  | FPD1B    | A9   | DUO (CNl-8)     |
| 38  | FPD19    | Cl0  |                 |
| 40  | FPD20    | Bl0  | DUl (CNl-8)     |
| 41  | FPD21    | Al0  |                 |
|     | FPD22    | Cll  | DU2 (CN 1-1 0)  |
43
| 44  | FPD23  | Bl1  |              |
| --- | ------ | ---- | ------------ |
| 46  | FPD24  | All  | DU3(CN1-11)  |
| 47  | FPD25  | 012  |              |
| 49  | FPD26  | C12  | DU4 CNl-12   |
| 50  | FPD27  | B12  |              |
| 52  | FPD2B  | A12  | DU5ICNl-13)  |
| 53  | FPD29  | C13  |              |
|     | FPD30  | B13  | DU6 CNl-14   |
55
| 56                  | FPD31        | A13              |                  |
| ------------------- | ------------ | ---------------- | ---------------- |
| 56                  | FPD32        | D14              | DU7ICNl-15)      |
| 59                  | FPD33        | C14              |                  |
| 61                  | FPD34        | B14              |                  |
| 62                  | FPD35        | A14              |                  |
|                     | (+1.BV Min)  |                  | Vcon( CNl-121    |
| 71                  | VDD LCD      |                  | (+5V)(CN1-5)     |
| 7375                | VDD LCD      |                  | OnJOffICN1-41    |
| 77                  | VEE LCD      | Acfust with R43  | Vee +27VlCNl-7   |
| 2 4 5 7 9 12 15     | GND          | NJA              | Vss (CN1-8)      |
| 18 21  24 27 30 42  | GND          | NLA              | Vss CN2-16 25)   |
| 27 30 33 36 39 51   | GND          | N/A              |                  |
| 45 48 51 54 57 60   | GND          | N1A              |                  |
| 63 65 79            | GND          | N/A              |                  |
| J24(PIN 1)          | (+12Vl       |                  | To BKL inverter  |
C-3 PANEL ATTACHMENT EXAMPLES

III.
r
S3 86CM65 Dual Display Accelerator
83 Incorporated
| Panel Hook-Up Diagram - | Sharp Color DSTN 640 x 480 16 Bit  |     |              |
| ----------------------- | ---------------------------------- | --- | ------------ |
| AURORA64V+              |                                    |     | Sharp Color  |
OSTN
| 64 & 10 Pin Connector Sional Name  |     | BGAPin  | LM64CI5J35P  |
| ---------------------------------- | --- | ------- | ------------ |
640X4BO
Resolution
| Interface  |          |     | 16 Bit       |
| ---------- | -------- | --- | ------------ |
| 3          | FPOCLK   | B3  | XCK(CN1-l0)  |
| 6          | FPHSYNC  | C4  | LP CNI-6     |
| 8          | FPVSYNC  | A3  | YO (CNI-4)   |
I nIc
| 64  | FPVOE  | B15  |               |
| --- | ------ | ---- | ------------- |
| 10  | FPOO   | B4   | DLO (CNI-ll)  |
| 11  | FPDl   | A4   |               |
| 13  | FPD2   | C5   | 0L1 (CNI-I3)  |
| 14  | FPD3   | B5   |               |
| 16  | FPD4   | AS   | DL2 (CNI-17)  |
| 17  | FP05   | 06   |               |
| 19  | FPD6   | C6   | 0L3 ICNI-19)  |
| 20  | FP07   | B6   |               |
| 22  | FPD8   | A6   | OL4 (CN1-l)   |
| 23  | FP09   | C7   |               |
| 25  | FPD10  | B7   | OL5 (CNI-31   |
| 26  | FPOll  | A7   |               |
| 28  | FP012  | 08   | OL6(CNI-5)    |
| 29  | FP013  | C8   |               |
| 31  | FPD14  | B8   | OL7 (CNI-7)   |
| 32  | FPD15  | A6   |               |
| 34  | FPD16  | C9   |               |
| 35  | FPD17  | B9   |               |
| 37  | FPD18  | A9   | DUO (CNI-28)  |
| 38  | FPD19  | Cl0  |               |
| 40  | FPD20  | Bl0  | OUI (CNI-26)  |
| 41  | FPD21  | Al0  |               |
| 43  | FPD22  | Cl1  | OU2 (CNI-24)  |
| 44  | FPD23  | Bl1  |               |
| 46  | FPD24  | All  | OU3 (CNI-22)  |
| 47  | FPD25  | 012  |               |
| 49  | FPD26  | C12  | DU4~CNI-23l   |
| 50  | FPD27  | B12  |               |
| 52  | FPD28  | A12  | DU5 (CNI-25)  |
53
|                    | FPD29       | C13              |                  |
| ------------------ | ----------- | ---------------- | ---------------- |
| 55                 | FP030       | B13              | OU6 CNl-29       |
| 56                 | FPD31       | A13              |                  |
| 58                 | FP032       | 014              | OU7 (CNI-31)     |
| 59                 | FP033       | C14              |                  |
| 61                 | FPD34       | B14              |                  |
| 62                 | FP035       | A14              |                  |
|                    | (+I,BVMinl  |                  | Vcon CNI-12      |
| 71                 | VDD LCD     |                  | Vdd(CNI-14 161   |
| 7375               | VOD LCD     |                  | On/Off CNI-18    |
| 77                 | VEE LCD     | Ad'ust with R43  | N/A              |
| 2 4 5 7 9 12 15    | GNO         | N/A              | Vss ICNI-2 8 9)  |
| 18 21 24 27 30 42  | GND         | N/A              | Vss(CNI-15 21)   |
| 27 30 33 36 39 51  | GND         | N:e.             | VssICNI-27 30    |
| 45 48 51 54 57 60  | GND         | N/A              |                  |
| 63 65 79           | GND         | NtA              |                  |
| J24(PIN 1)         | (+I2V)      |                  | To BKL inverter  |
C-4 PANEL ATTACHMENT EXAMPLES

S3 86CM65 Dual Display Accelerator
83 Incorperated
| Panel Hook-Up Diagram - | Sharp Color DSTN 800 x 600 16 Bit  |     |              |
| ----------------------- | ---------------------------------- | --- | ------------ |
| AURORA64V+              |                                    |     | Sharp Color  |
DSTN
| 64 & 10 Pin Connector Sienal Name  |          | 8GAPin  | LMSOC03P       |
| ---------------------------------- | -------- | ------- | -------------- |
| Resolution                         |          |         | BOOX600        |
| Interface                          |          |         | 168it          |
| 3                                  | FPDCLK   | 83      | XCK (CN1-10)   |
| 6                                  | FPHSYNC  | C4      | LP (CNI-6)     |
| 8                                  | FPVSYNC  | A3      | YD CNl-4       |
| 64                                 | FPVDE    | 815     | nJe            |
| 10                                 | FPDO     | 84      | DLO CNI-ll     |
| 11                                 | FPDl     | A4      |                |
| 13                                 | FPD2     | C5      | DLI CNI-13     |
| 14                                 | FPD3     | 85      |                |
| 16                                 | FPD4     | AS      | DL2(CN 1-1 ZL  |
| 17                                 | FPD5     | D6      |                |
| 19                                 | FPD6     | C6      | DL3 CNl-19     |
| 20                                 | FPD7     | B6      |                |
| 22                                 | FPD8     | A6      | DL4(CN1-l1     |
| 23                                 | FPD9     | C7      |                |
| 25                                 | FPD10    | 87      | DL5 CNl-3      |
| 26                                 | FPDll    | A7      |                |
| 28                                 | FPD12    | D8      | DL6ICNl-5)     |
C8
| 29  | FPD13  |      |               |
| --- | ------ | ---- | ------------- |
| 31  | FPD14  | 88   | DL7ICNl-7)    |
| 32  | FPD15  | AS   |               |
| 34  | FPD16  | C9   |               |
| 35  | FPD17  | B9   |               |
| 37  | FPD18  | AS   | DUO ICNl-28)  |
| 38  | FPD19  | Cl0  |               |
| 40  | FPD20  | Bl0  | DUI ICNI-26)  |
| 41  | FPD21  | Al0  |               |
| 43  | FPD22  | Cll  | DU2 CNl-24)   |
| 44  | FPD23  | Bll  |               |
|     | FPD24  |      | DU3ICNl-22)   |
| 46  |        | All  |               |
| 47  | FPD25  | D12  |               |
| 49  | FPD26  | C12  | DU4ICNl-23)   |
| 50  | FPD27  | B12  |               |
| 52  | FPD28  | A12  | DU5 (CNl-25)  |
| 53  | FPD29  | C13  |               |
| 55  | FPD30  | 813  | DU6 CNl-29    |
| 56  | FPD31  | A13  |               |
56
|       | FPD32       | D14              | UD7 ICNI-31)    |
| ----- | ----------- | ---------------- | --------------- |
| 59    | FPD33       | C14              |                 |
| 61    | FPD34       | 814              |                 |
| 62    | FPD35       | A14              |                 |
|       | (+l.SVMin)  |                  | Veonl CNl-12)   |
| 71    | VDD LCD     |                  | Vdd(CNl-14 16)  |
| 7375  | VDD LCD     |                  | OnJOffICN1-18)  |
| 77    | VEE LCD     | A(fust with R43  | NA              |
Vss (CN1-2 8 9)
| 2 4 5 7 9 12 15     | GND     | N/A   |                  |
| ------------------- | ------- | ----- | ---------------- |
| 18 21 24 27 30 42   | GND     | NiO.  | Vss(CNI-15 21    |
| 27 30 33 36 39 51   | GND     | N/A   | Vss(CNl-27 30)   |
| 45 48 51  54 57 60  | GND     | NiO.  |                  |
| 63 65 79            | GND     | N/A   |                  |
| J24(PIN 1)          | (+12V)  |       | To BKL inverter  |
C-5 PANEL ATTACHMENT EXAMPLES

S3 86CM65 Dual Display Accelerator
83 Incorporated
| Panel Hook-Up Diagram - | Hitachi Color STN 640 x 48016 Bit  |            |                    |
| ----------------------- | ---------------------------------- | ---------- | ------------------ |
| Aurora64V+              |                                    |            | Hitachi Color STN  |
| 64&10Pin                | Signal's Names                     | BGAPin's#  | lMG9460ZUCC        |
IDC Connector
640 x 480116 Bitl
| J22orJ23  |          |      | CN1 (Hiroset  |
| --------- | -------- | ---- | ------------- |
| 3         | FPDClK   | B3   | Cl2 (CN1-10l  |
| 6         | FPHSYNC  | C4   | Cll (CNI-6    |
| 8         | FPVSYNC  | A3   | FlM (CNI-4l   |
| 64        | FPVDE    | B15  | Infa          |
| 10        | FPDO     | B4   | lDO (CN1-11l  |
| 11        | FPDl     | A4   |               |
lDl (CNI-13l
| 13  | FPD2   | C5   |               |
| --- | ------ | ---- | ------------- |
| 14  | FPD3   | B5   |               |
| 16  | FPD4   | A5   | lD2 (CNI-I71  |
| 17  | FPD5   | D6   |               |
| 19  | FPD6   | C6   | LD3 (CNI-19l  |
| 20  | FPD7   | B6   |               |
| 22  | FPDB   | A6   | lD4 (CNI-ll   |
| 23  | FPD9   | C7   |               |
| 25  | FPD10  | B7   | LD5 (CNI-3l   |
| 26  | FPDll  | A7   |               |
| 28  | FPD12  | D8   | LD6 (CNI-5l   |
| 29  | FPD13  | C8   |               |
| 31  | FPD14  | B8   | LD7 (CNI-7l   |
| 32  | FPD15  | A8   |               |
| 34  | FPD16  | C9   |               |
| 35  | FPD17  | B9   |               |
| 37  | FPD18  | A9   | UDO (CNI-28l  |
| 38  | FPD19  | Cl0  |               |
| 40  | FPD20  | Bl0  | UDI (CNI-26l  |
| 41  | FPD21  | Al0  |               |
| 43  | FPD22  | Cl1  | UD2 (CNI-24l  |
| 44  | FPD23  | Bl1  |               |
UD3(CNI-22
| 46  | FPD24  | A11  |               |
| --- | ------ | ---- | ------------- |
| 47  | FPD25  | D12  |               |
| 49  | FPD26  | C12  | UD4 (CNI-23l  |
| 50  | FPD27  | B12  |               |
| 52  | FPD28  | A12  | UD5 (CNI-25l  |
| 53  | FPD29  | C13  |               |
| 55  | FPD30  | B13  | UD6 CNI-29    |
| 56  | FPD31  | A13  |               |
|     | FPD32  | D14  | UD7 (CNI-31l  |
58
| 59     | FPD33    | C14    |                  |
| ------ | -------- | ------ | ---------------- |
| 61     | FPD34    | B14    |                  |
| 62     | FPD35    | A14    |                  |
| 71 73  | VDD LCD  | I nla  | DisD off Pin 18  |
! n/a
| 7375  | VDD LCD  |      | VDD Pin 14 16  |
| ----- | -------- | ---- | -------------- |
| 74    | FPPOL    | C15  | nla            |
VCON Pin 12
77
|                 | VEE LCD  |        | nla           |
| --------------- | -------- | ------ | ------------- |
| 2457            | GND      | I nla  | GNDS Pins     |
| 9 12 15         | GND      | I nla  | 289 15        |
| 1821 24         | GND      | I nla  | 21 27 and 30  |
| 27 30 33        | GND      | nla    |               |
| 36 39 42        | GND      | nla    |               |
| 45 48 51        | GND      | nla    |               |
| 54, 57, 50, 79  | GND      | nla    |               |
C-6 PANEL ATTACHMENT EXAMPLES

S3 86CM65 Dual Display Accelerator
83 Incorporated
| Panel Hook-Up Diagram - | Hitachi Color STN 800 x 60016 Bit  |              |                    |
| ----------------------- | ---------------------------------- | ------------ | ------------------ |
| Aurora64V+              |                                    |              | Hitachi Color STN  |
|                         | Signal's Names                     | BGA Pin's #  |                    |
| 64&10Pin                |                                    |              | LMG9900ZWCC        |
I DC Connector
800 x 600 16 Bit
| J22orJ23  |          |      | CN 1(Hirose)  |
| --------- | -------- | ---- | ------------- |
| 3         | FPDCLK   | B3   | CL2 (CN1-l0)  |
| 6         | FPHSYNC  | C4   | CLl (CNHl)    |
| 8         | FPVSYNC  | A3   | FLM (CNl-4)   |
| 64        | FPVDE    | B15  | n/a           |
| 10        | FPDO     | B4   | LDO(CN1-ll)   |
| 11        | FPDl     | A4   |               |
| 13        | FPD2     | C5   | LOl (CNl-13)  |
| 14        | FPD3     | B5   |               |
| 16        | FPD4     | A5   | L02 (CNl-17)  |
| 17        | FPD5     | 06   |               |
| 19        | FPD6     | C6   | L03 (CNl-19)  |
| 20        | FPD7     | B6   |               |
| 22        | FPD8     | A6   | LD4 (CN1-1)   |
| 23        | FPD9     | C7   |               |
| 25        | FPD10    | B7   | LD5 (CNl-3)   |
| 26        | FPDll    | A7   |               |
| 28        | FPD12    | D8   | LD6 (CNl-5)   |
| 29        | FPD13    |      |               |
C8
| 31     | FPD14    | B8   | LD7 (CNl-7)      |
| ------ | -------- | ---- | ---------------- |
| 32     | FPD15    | AS   |                  |
| 34     | FPD16    | C9   |                  |
| 35     | FPD17    | B9   |                  |
| 37     | FPD18    | A9   | UDO (CNl-28)     |
| 38     | FPD19    | Cl0  |                  |
| 40     | FPD20    | Bl0  | UDl (CNl-26)     |
| 41     | FPD21    | Al0  |                  |
| 43     | FPD22    | Cll  | UD2 (CNl-24)     |
| 44     | FPD23    | Bll  |                  |
| 46     | FPD24    | All  | UD3 (CNl-22)     |
| 47     | FPD25    | D12  |                  |
| 49     | FPD26    | C12  | UD4 (CNl-23)     |
| 50     | FPD27    | B12  |                  |
| 52     | FPD28    | A12  | UD5 (CNl-25)     |
| 53     | FPD29    | C13  |                  |
| 55     | FPD30    | B13  | UD6 (CNl-29)     |
| 56     | FPD31    | A13  |                  |
| 58     | FPD32    | D14  | UD7 CNl-31)      |
| 59     | FPD33    | C14  |                  |
| 61     | FPD34    | B14  |                  |
| 62     | FPD35    | A14  |                  |
| 71 73  | VDD LCD  | nla  | DisD off Pin 18  |
VDD Pin 14 16
| 7375  | VDD LCD  | nla  |      |
| ----- | -------- | ---- | ---- |
| 74    | FPPOL    | C15  | nla  |
VCON Pin 12
| 77              | VEE LCD  |        | n/a           |
| --------------- | -------- | ------ | ------------- |
| 24 57           | GND      | nla    | GNDS Pins     |
| 9 12 15         | GND      | nla    | 289 15        |
| 1821 24         | GND      | nla    | 21 27 and 30  |
| 27 30 33        | GND      | nla    |               |
| 36 39 42        | GND      | I nla  |               |
| 4548 51         | GND      | ; nla  |               |
| 54, 57, 60, 79  | GND      |        |               |
nla
C-7 PANEL ATTACHMENT EXAMPLES

••
r
S3 86CM65 Dual Display Accelerator
sa Incorporated
| Panel Hook-Up Diagram - | Hitachi Color STN 800 x 600 16 Bit  |              |                   |
| ----------------------- | ----------------------------------- | ------------ | ----------------- |
| Aurora64V+              |                                     |              | H~achi Color STN  |
| 64& 10 Pin              | Signal's Names                      | BGA Pin's #  | LMG9960ZWCC       |
ID C Connector
800 x 600 (16 Bitl
| J22orJ23  |          |      | CN1(Hirose)      |
| --------- | -------- | ---- | ---------------- |
| 3         | FPDCLK   | B3   | CL2 (CN1-l0)     |
| 6         | FPHSYNC  | C4   | CL1 (CNHl)       |
| 8         | FPVSYNC  | A3   | FLM (CN1-4)      |
| 64        | FPVDE    | B15  | nla              |
| 10        | FPDO     | 64   | LDO(CN1-11}      |
| 11        | FPDl     | A4   |                  |
| 13        | FPD2     | C5   | LDl (CNl-131     |
| 14        | FPD3     | 65   |                  |
| 16        | FPD4     | A5   | LD2 (CNl-17)     |
| 17        | FPD5     | D6   |                  |
| 19        | FPD6     | C6   | LD3 (CNl-191     |
| 20        | FPD7     | B6   |                  |
| 22        | FPD8     | A6   | LD4 (CN1-1)      |
| 23        | FPD9     | C7   |                  |
| 25        | FPD10    | B7   | lO5 CNl-3        |
| 26        | FPDll    | A7   |                  |
| 28        | FPD12    | D8   | LD6(CNl-5)       |
| 29        | FPD13    | C8   |                  |
| 31        | FPD14    | 68   | LD7(CNl-7}       |
| 32        | FPD15    | AS   |                  |
| 34        | FPD16    | C9   |                  |
| 35        | FPD17    | B9   |                  |
| 37        | FPD18    | A9   | UDO (CNl-28)     |
| 38        | FPD19    | Cl0  |                  |
| 40        | FPD20    | Bl0  | UDl (CNl-26)     |
| 41        | FPD21    | Al0  |                  |
| 43        | FPD22    | Cll  | UD2 (CNl-241     |
| 44        | FPD23    | 611  |                  |
| 46        | FPD24    | All  | UD3 (CNl-221     |
| 47        | FPD25    | D12  |                  |
| 49        | FPD26    | C12  | UD4 (CN1-231     |
| 50        | FPD27    | 612  |                  |
| 52        | FPD28    | A12  | UD5 (CNl-25)     |
| 53        | FPD29    | C13  |                  |
| 55        | FPD30    | B13  | UD6 (CN1-29)     |
| 56        | FPD31    | A13  |                  |
| 58        | FPD32    | D14  | UD7 (CN 1-311    |
| 59        | FPD33    | C14  |                  |
| 61        | FPD34    | 614  |                  |
| 62        | FPD35    | A14  |                  |
| 71 73     | VDD LCD  | nla  | DisD off Pin 18  |
nla
| 7375  | VDD LCD  |      | VDD Pin 14 16  |
| ----- | -------- | ---- | -------------- |
| 74    | FPPOL    | C15  | n/a            |
VCON Pin 12
I nla
| 77        | VEE LCD  |       |               |
| --------- | -------- | ----- | ------------- |
| 2457      | GND      | nla   | GNDS Pins     |
| 9 12 15   | GND      | _nia  | 289 15        |
| 1821 24   | GND      | nla   | 21 27 and 30  |
| 27 30 33  | GND      | nla   |               |
| 36 39 42  | GND      | nla   |               |
| 4548 51   | GND      | nla   |               |
nla
| 54 57 60 79  | GND  |     |     |
| ------------ | ---- | --- | --- |
C-8 PANEL ATTACHMENT EXAMPLES

S3 86CM65 Dual Display Accelerator
53 Incorponted
| Panel Hook-Up Diagram - | Toshiba Color TFT 800 x 600 18 Bit  |         |                    |
| ----------------------- | ----------------------------------- | ------- | ------------------ |
| Aurora64V + (M65)       |                                     |         | Toshiba color TFT  |
| 64& 10 Pin              | Signal Name                         | BGAPin  | NLB060AC2<Hl1      |
IDC Connector
800X600 (18 Bit)
| 3   | FPDCLK   | B3   | NCLK  CN1-o1   |
| --- | -------- | ---- | -------------- |
| 6   | FPHSYNC  | C4   | n/a            |
| 8   | FPVSYNC  | A3   | I n/a          |
| 64  | FPVDE    | B15  | ENAB (CN2-D8)  |
| 10  | FPDO     | B4   | RO CN1-031     |
| 11  | FPDl     | A4   |                |
| 13  | FPD2     | C5   | R1 (CN1-04)    |
| 14  | FPD3     | B5   |                |
R2 (CN1-p5)
| 16  | FPD4   | A5   |               |
| --- | ------ | ---- | ------------- |
| 17  | FPD5   | D6   |               |
| 19  | FPD6   | C6   | R3 (CN1-D6)   |
| 20  | FPD7   | B6   |               |
| 22  | FPD8   | A6   | R4 CN1-D7     |
| 23  | FPD9   | C7   |               |
| 25  | FPD10  | B7   | R5(CN1,QB)    |
| 26  | FPD11  | A7   |               |
| 2B  | FPD12  | D8   | GO (CN1-Dl0   |
| 29  | FPD13  | C8   |               |
| 31  | FPD14  | B8   | Gl (CN1-Dl1)  |
| 32  | FPD15  | A8   |               |
| 34  | FPD16  | C9   | G2 (CN1-D121  |
| 35  | FPD17  | B9   |               |
| 37  | FPD18  | A9   | G3 (CN1-o13)  |
| 38  | FPD19  | Cl0  |               |
G4 (CN1-D14)
| 40    | FPD20    | Bl0  |               |
| ----- | -------- | ---- | ------------- |
| 41    | FPD21    | Al0  |               |
| 43    | FPD22    | Cll  | G5 (CN1-D15)  |
| 44    | FPD23    | B11  |               |
| 46    | FPD24    | All  | BO (CN2-D21   |
| 47    | FPD25    | D12  |               |
| 49    | FPD26    | C12  | Bl (CN2-03)   |
| 50    | FPD27    | B12  |               |
| 52    | FPD28    | A12  | B2 (CN2-04)   |
| 53    | FPD29    | C13  |               |
| 55    | FPD30    | B13  | B3 (CN2-D5)   |
| 56    | FPD31    | A13  |               |
| 58    | FPD32    | D14  | B2 (CN2-D61   |
| 59    | FPD33    | C14  |               |
| 61    | FPD34    | B14  | B3 (CN2-p7)   |
| 62    | FPD35    | A14  |               |
| 71    | VDD LCD  | N/A  | VDD(CN2-p9)   |
| 7375  | VDD LCD  | N/A  | VDD(CN2-clQ)  |
NA
| 77               | VEE LCD  |      |               |
| ---------------- | -------- | ---- | ------------- |
| 2 4 5 7 9 12 15  | GND      | N/A  | GND CN1-o2 9  |
| 18 21 24 27 30   | GND      | N/A  | GND (CN2-o1)  |
| 33 36 39 42      | GND      | N/A  |               |
| 45 48 51 54 57   | GND      | N/A  |               |
| 60 79            | GND      | N/A  |               |
C-9 PANEL ATIACHMENT EXAMPLES

S3 86CM65 Dual Display Accelerator
S3 Incorpol'llted
| Panel Hook-Up Diagram - | Hitachi Color TFT 800 x 600  |     |                                   |     |
| ----------------------- | ---------------------------- | --- | --------------------------------- | --- |
| Aurora64V+              |                              |     | Hitachi  8x6 TFTllX26D81VC1CAA-l  |     |
64 & 10 Pin  Signal Name  6GA Pin Number  CNI 40Pin  Signal Description
| IDC Connector  |          |      | (Hirose)  |        |
| -------------- | -------- | ---- | --------- | ------ |
| 3              | FPDCLK   | 63   | 2         | DCLK   |
| 6              | FPHSYNC  | C4   | 4         | HSYNC  |
| 8              | FPVSYNC  | A3   | 5         | VSYNC  |
| 64             | FPVDE    | 615  | 37        | DTMG   |
| 10             | FPDO     | 84   | 9         | RO     |
A4
| 11  | FPDl  |     |     |     |
| --- | ----- | --- | --- | --- |
| 13  | FPD2  | C5  | 10  | Rl  |
| 14  | FPD3  | 65  |     |     |
A5
| 16  | FPD4   |     | 11  | R2  |
| --- | ------ | --- | --- | --- |
| 17  | FPD5   | D6  |     |     |
| 19  | FPD6   | C6  | 13  | R3  |
| 20  | FPD7   | 66  |     |     |
| 22  | FPD8   | AS  | 14  | R4  |
| 23  | FPD9   | C7  |     |     |
| 25  | FPD10  | 67  | 15  | R5  |
| 26  | FPD11  | A7  |     |     |
19
| 28    | FPD12    | D8   |      | GO         |
| ----- | -------- | ---- | ---- | ---------- |
| 29    | FPD13    | C8   |      |            |
| 31    | FPD14    | 68   | 20   | Gl         |
| 32    | FPD15    | AS   |      |            |
| 34    | FPD16    | C9   | 21   | G2         |
| 35    | FPD17    | 69   |      |            |
| 37    | FPD18    | A9   | 23   | G3         |
| 38    | FPD19    | CIO  |      |            |
| 40    | FPD20    | 610  | 24   | G4         |
| 41    | FPD21    | A10  |      |            |
| 43    | FPD22    | Cll  | 25   | G5         |
| 44    | FPD23    | 611  |      |            |
| 46    | FPD24    | Al1  | 29   | 60         |
| 47    | FPD25    | D12  |      |            |
| 49    | FPD26    | C12  | 30   | 61         |
| 50    | " FPD27  | 612  |      |            |
| 52    | FPD28    | A12  | 31   | 62         |
| 53    | FPD29    | C13  |      |            |
| 55    | FPD30    | 613  | 33   | 83         |
| 56    | FPD31    | A13  |      |            |
| 58    | FPD32    | D14  | 34   | 64         |
| 59    | FPD33    | C14  |      |            |
| 35    | FPD34    | 614  | 35   | 65         |
| 62    | FPD35    | A14  |      |            |
| 71    | VDD LCD  | N/A  | 39   | VDD (+5Vl  |
| 7375  | VDD LCD  | N/A  | 40   | VDD (+5VI  |
| 74    | FPPOL    | C15  | N/A  |            |
| 77    | VEE LCD  |      | N/A  | N/A        |
VSS
| 2457         | GND  | N/A  | 1 3678       |      |
| ------------ | ---- | ---- | ------------ | ---- |
| 9 12 15      | GND  | N/A  | 12 16 17 18  | VSS  |
| 821 24       | GND  | N:A  | 22 26 27 28  | VSS  |
| 273033       | GND  | N/A  | 3236         | VSS  |
| 363942       | GND  | N:A  |              |      |
| 454851       | GND  | N/A  |              |      |
| 54 57 60 79  | GND  | N/A  |              |      |
C-10 PANEL ATTACHMENT EXAMPLES

86CM65 Dual Display Accelerator
53 Incorporated
Index
| 24 bits/pixel            |             |             |       | chroma keying        |                   | 9-8,21-2,21-4  |
| ------------------------ | ----------- | ----------- | ----- | -------------------- | ----------------- | -------------- |
| packed mode description  |             |             | 10-3  | enable               | 21-2              |                |
| 3.3 volt operation       |             | 5-6, 18-11  |       | clipping             | 16-8,20-15,20-18  |                |
| 32 bitS/pixel operation  |             | 20-18       |       | clock generator      |                   |                |
| 4 bitS/pixel             | 19-18,20-3  |             |       | DC specifications    |                   | 4-1            |
|                          |             |             |       | frequency synthesis  |                   | 8-1            |
| A                        |             |             |       | new DCLK PLL load    |                   | 18-8           |
new MCLK and DCLK PLL load  18-9
| activity function during Standby  |     |        | 18-34            |                      |              |        |
| --------------------------------- | --- | ------ | ---------------- | -------------------- | ------------ | ------ |
|                                   |     |        |                  | new MCLK PLL load    |              | 18-8   |
| axial step constant               |     | 16-9   |                  | CLUT                 |              |        |
|                                   |     |        |                  | accessing            | 10-3,18-36   |        |
| B                                 |     |        |                  | power down CLUT1     |              | 18-17  |
|                                   |     |        |                  | power down CLUT2     |              | 18-17  |
| background color                  |     | 20-11  |                  | updating             | 10-3, 18-36  |        |
| background/foreground mix         |     |        | 16-2,16-4, 16-9- | write cycle control  |              | 18-11  |
16-14, 16-16 -16-22
|                            |     |              |        | color compare            | 16-2,16-8,20-18  |              |
| -------------------------- | --- | ------------ | ------ | ------------------------ | ---------------- | ------------ |
| big endian addressing      |     | 16-6         |        | VGA                      | 17-27, 17-31     |              |
| BIOS                       |     |              |        | color depth (bpp)        |                  | 19-18        |
| See video BIOS             |     |              |        | color keying             | 9-8,21-2         |              |
| BitBLT across the plane    |     |              | 16-18  | enable                   | 21-2             |              |
| BitBLT  through the plane  |     |              | 16-17  | in KRGB mode             |                  | 21-2         |
| bitS/pixel                 |     |              |        | color space conversion   |                  | 9-4 -9-5     |
| See color depth            |     |              |        | composite TV output      |                  | 10-3, 19-12  |
| black burst TV output      |     | 10-3, 19-12  |        | configuration strapping  |                  | 19-8         |
| blank/border select        |     | 19-5         |        | at reset                 | 5-1, 5-3         |              |
blending  9-7,21-5  unlocking access to registers  19-10,19-12
| blinking  11-12, 19-14  |       |        |     | CPU base address  |        |     |
| ----------------------- | ----- | ------ | --- | ----------------- | ------ | --- |
| byte mode addressing    |       | 17-22  |     | specify           | 19-30  |     |
| byte swap               | 20-9  |        |     | CRT output        | 10-1   |     |
cursor
| c                   |            |               |     | end  17-16               |        |               |
| ------------------- | ---------- | ------------- | --- | ------------------------ | ------ | ------------- |
|                     |            |               |     | location address         |        | 17-17         |
| CAS                 |            |               |     | start                    | 17-16  |               |
| stretch time        | 7-3,19-29  |               |     | cursor blinking          |        | 11-12, 19-14  |
| character blinking  |            | 11-12, 19-14  |     | cursor location address  |        | 17-17         |
character clock
| dot clocks per  |       | 17-6  |     |     |     |     |
| --------------- | ----- | ----- | --- | --- | --- | --- |
| halving         | 17-6  |       |     |     |     |     |
chip ID  19-2 -19-3
| chip wakeup  | 14-1  |     |     |     |     |     |
| ------------ | ----- | --- | --- | --- | --- | --- |
INDEX  1-1

86CM65 Dual Display Accelerator
sa Incorporated
| D   |     |     | E           |      |     |
| --- | --- | --- | ----------- | ---- | --- |
|     |     |     | EDO memory  | 7-1  |     |
DCLK
| control                          | 8-3                      |                    | enable                          |              |        |
| -------------------------------- | ------------------------ | ------------------ | ------------------------------- | ------------ | ------ |
| dividing                         | 8-3, 18-22 -18-23        |                    | chroma keying                   | 21-2         |        |
| external input                   | 18-8                     |                    | color keying                    | 21-2         |        |
| for controller A and B           |                          | 18-22              | dithering                       | 18-28        |        |
| for controllers 1 and 2          |                          | 8-3                | Enhanced mode                   | 20-3         |        |
| halving                          | 18-9                     |                    | flat panel display              | 18-25        |        |
| inverted                         | 18-9,19-5                |                    | hardware graphics cursor        |              | 19-14  |
| loading new frequency            |                          | 8-2, 18-8 -18-9    | hardware icon                   | 18-37        |        |
| outputfor testing                |                          | 18-8               | linear addressing               | 19-22,20-3   |        |
| programming                      | 8-2, 18-6                |                    | LPB  22-1                       |              |        |
| source selection                 | 8-3, 18-22               |                    | memory mapped I/O               |              | 19-19  |
| debounce timer                   | 18-34                    |                    | TV output                       | 19-12        |        |
| decimation                       | 12-8,22-12               |                    | end horizontal blank            | 17-12        |        |
|                                  |                          | 20-17              |                                 |              | 17-13  |
| destination base address         |                          |                    | end horizontal sync position    |              |        |
| destination X position           |                          | 20-5               | end vertical blank              | 17-21        |        |
| DEVSEL timing                    | 6-1                      |                    | Enhanced mode                   |              |        |
| diagonal step constant           |                          | 16-9,20-5          | background color                | 20-11        |        |
| digitizer interface              | 12-7                     |                    | clipping                        | 20-15,20-18  |        |
| display active status            |                          | 17-4               | color compare                   | 20-18        |        |
| display FIFO fetch               |                          |                    | color depth                     | 19-18        |        |
|                                  | 19-6                     |                    |                                 | 20-9         |        |
| enable                           |                          |                    | command types                   |              |        |
| specify start position           |                          | 19-11              | destination base address        |              | 20-17  |
| display memory                   |                          |                    | destination X position          |              | 20-5   |
| 2 MCLK writes                    | 18-3, 18-9               |                    | diagonal step constant          |              | 20-5   |
| access control                   | 7-10                     |                    | drawing commands                |              | 20-8   |
| configurations                   | 7-1                      |                    | enable  16-1,20-3               |              |        |
| EDO support                      | 7-6                      |                    | enable 8 bpp or greater         |              | 19-11  |
| functional timing                |                          | 7-2,7-4,7-7        | memory mapping                  | 19-3         |        |
| refresh                          | 7-2                      |                    | minor axis pixel count          |              | 20-15  |
| refresh cycle control            |                          | 7-2, 17-19         | programming                     | 16-7         |        |
| size specification               |                          | 5-1                | screen width                    | 19-18        |        |
| tri-state all interface signals  |                          | 18-26              | select mix register             | 20-17        |        |
| display pitch                    | 17-19                    |                    | short stroke vector             | 20-10        |        |
| dithering                        | 11-3,11-11,18-28 -18-29  |                    | source base address             |              | 20-17  |
|                                  |                          |                    | extended data out (EDO) memory  |              | 7-1    |
| enable                           | 18-28                    |                    |                                 |              |        |
| doubleword mode addressing       |                          | 17-19 -17-20,      |                                 |              |        |
| 19-3                             |                          |                    | F                               |              |        |
| drawing commands                 |                          | 16-9 -16-22, 20-8  |                                 |              |        |
| drawing direction                | 20-8                     |                    | fast page mode memory           |              | 7-1    |
| drive strength                   |                          |                    | FIFO status                     | 20-7         |        |
| flat panel data outputs          |                          | 5-7                | FIFO threshold                  |              |        |
| 10Ls  4-2                        |                          |                    | primary stream                  | 21-14        |        |
| DuoView display                  |                          |                    | secondary stream                | 21-13        |        |
| image destination                |                          | 11-13              | STN read                        | 18-23        |        |
| programming                      | 11-14                    |                    | STN write                       | 18-23        |        |
| setup                            | 11-12                    |                    | use explained                   | 7-10         |        |
1-2  INDEX

86CM65 Dual Display Accelerator
83 Incorporated
| flat panel                         |     |            |               |        | vertical expansion        |        | 11-11         |     |
| ---------------------------------- | --- | ---------- | ------------- | ------ | ------------------------- | ------ | ------------- | --- |
| control signal polarities          |     |            | 18-26         |        | green PC                  |        |               |     |
| data polarity                      |     | 18-26      |               |        | HSYNCNSYNC control        |        | 5-7, 18-4     |     |
| data signal drive strength         |     |            | 18-31         |        |                           |        |               |     |
| display enable                     |     | 18-25      |               |        | H                         |        |               |     |
| display enable positioning         |     |            | 18-50         |        |                           |        |               |     |
| force outputs low                  |     | 18-32      |               |        | hardware graphics cursor  |        |               |     |
| horizontal and vertical expansion  |     |            |               | 11-11  | background color          |        | 19-16         |     |
| horizontal centering               |     |            | 11-11, 18-45  |        | controller source         |        | 18-25         |     |
| horizontal expansion               |     |            | 11-11,18-45   |        | enable                    | 19-14  |               |     |
| horizontal expansion factor        |     |            | 18-48         |        | foreground color          |        | 19-16         |     |
| line graphics enable               |     |            | 18-45         |        | pattern display x origin  |        | 19-17         |     |
| power sequencing                   |     | 5-4,18-33  |               |        | pattern display y origin  |        | 19-17         |     |
| power-on strapping for panel type  |     |            |               | 19-9   | programming               |        | 16-23 -16-24  |     |
| single versus dual scan select     |     |            |               | 18-24  | storage start address     |        | 19-16         |     |
STN panel support  11-1  Windows/X-Windows modes  16-23,19-21
| sync positioning           |        | 18-51        |        |     | x origin               | 19-15  |        |     |
| -------------------------- | ------ | ------------ | ------ | --- | ---------------------- | ------ | ------ | --- |
| TFT panel support          |        | 11-9         |        |     | yorigin                | 19-15  |        |     |
| vertical centering         |        | 11-11,18-46  |        |     | hardware icon          |        |        |     |
| vertical expansion         |        | 11-11,18-46  |        |     | color programming      |        | 18-38  |     |
| vertical expansion factor  |        |              | 18-50  |     | controller source      |        | 18-25  |     |
| FLM                        |        |              |        |     | double size            | 18-37  |        |     |
| polarity                   | 18-26  |              |        |     | enable                 | 18-37  |        |     |
| font selection             | 17-8   |              |        |     | icon map base address  |        | 18-41  |     |
| FPDE                       |        |              |        |     | icon map select        |        | 18-38  |     |
| function select            |        | .18-27       |        |     | mode select            | 18-37  |        |     |
FPPOL function select  18-11  position programming  18-39 -18-40
| FPSCLK                                       |        |        |        |        | programming                   | 16-25  |        |     |
| -------------------------------------------- | ------ | ------ | ------ | ------ | ----------------------------- | ------ | ------ | --- |
| delay                                        | 18-32  |        |        |        | high speed text display       |        | 19-4   |     |
| disable during first line of vertical blank  |        |        |        | 18-31  | high speed text font writing  |        | 19-11  |     |
| disable during vertical blank                |        |        |        | 18-31  | horizontal blank              |        |        |     |
| drive strength                               |        | 18-31  |        |        | end  17-12                    |        |        |     |
| function during blanking                     |        |        | 18-32  |        | start  17-12                  |        |        |     |
| frame buffer                                 |        |        |        |        | horizontal centering          |        | 11-11  |     |
| See display memory                           |        |        |        |        | horizontal display end        |        | 17-11  |     |
| frame rate control                           |        | 11-3   |        |        | horizontal expansion          |        | 11-11  |     |
| enable                                       | 18-29  |        |        |        | horizontal sync pOSition      |        |        |     |
| gray levels                                  | 18-29  |        |        |        | end  17-13                    |        |        |     |
| FRC                                          |        |        |        |        | start  17-13                  |        |        |     |
| See frame rate control                       |        |        |        |        | horizontal total              | 17-11  |        |     |
HSYNC
| G   |     |     |     |     | control for power management  |       |     | 18-4  |
| --- | --- | --- | --- | --- | ----------------------------- | ----- | --- | ----- |
|     |     |     |     |     | polarity                      | 17-2  |     |       |
general output port
|              |       |     |     |     | polarity during simultaneous display  |     |        | 18-26  |
| ------------ | ----- | --- | --- | --- | ------------------------------------- | --- | ------ | ------ |
| description  | 13-2  |     |     |     | skew by character clocks              |     | 17-13  |        |
LPB  22-9
| GOPO function select  |     | 18-11  |     |     |     |     |     |     |
| --------------------- | --- | ------ | --- | --- | --- | --- | --- | --- |
Graphics Engine
| accessing bitmap through  |       |       | 16-2, 16-4  |     |     |     |     |     |
| ------------------------- | ----- | ----- | ----------- | --- | --- | --- | --- | --- |
| busy status               | 20-7  |       |             |     |     |     |     |     |
| enable                    | 20-3  |       |             |     |     |     |     |     |
| software reset            |       | 20-3  |             |     |     |     |     |     |
graphics mode
INDEX  1-3

86CM65 Dual Display Accelerator
|                                        |                   |                  |             |       | enable                    | 22-1        |                  |
| -------------------------------------- | ----------------- | ---------------- | ----------- | ----- | ------------------------- | ----------- | ---------------- |
|                                        |                   |                  |             |       | frame buffer address      |             | 22-7             |
| I square C                             |                   |                  |             |       | general output port       |             | 22-9             |
| See serial port                        |                   |                  |             |       | input window size         |             | 22-11            |
| icon                                   |                   |                  |             |       | interrupts                | 22-5        |                  |
| See hardware icon                      |                   |                  |             |       | introduction              |             | 12-1             |
| 10, chip                               | 19-2 -19-3        |                  |             |       | line stride               | 22-13       |                  |
| idle power down status                 |                   | 18-36            |             |       | mode select               |             | 22-1             |
| idle power up status                   |                   | 18-36            |             |       | output FIFO               |             | 22-4,22-14       |
| image transfer across the plane        |                   |                  | 16-15       |       | read/write registers      |             | 22-8             |
| image transfer through the plane       |                   |                  | 16-13       |       | reset                     | 22-2        |                  |
| initialization                         | 5-1               |                  |             |       | SceniC/MX2 interface      |             | 12-1             |
| interlaced operation                   |                   | 19-12 -19-13     |             |       | skip frames               |             | 22-2             |
| TV output                              | 22-3              |                  |             |       | sync polarity             |             | 22-2             |
| interrupt                              |                   |                  |             |       | video FIFO                | 22-3        |                  |
| enable                                 | 13-2, 19-4        |                  |             |       | LPBEN pin logic level     |             | 18-4             |
| FIFO empty interrupt enable            |                   |                  | 20-3        |       |                           |             |                  |
| FIFO empty interrupt status            |                   |                  | 20-1        |       | M                         |             |                  |
| FIFO overflow interrupt enable         |                   |                  | 20-2        |       |                           |             |                  |
| FIFO overflow interrupt status         |                   |                  | 20-1        |       | M parameter               | 7-10,19-20  |                  |
| generation                             |                   | 13-2             |             |       | LPB  19-35                |             |                  |
| Graphics Engine busy interrupt status  |                   |                  |             | 20-1  | See also PLL m parameter  |             |                  |
| Graphics Engine interrupt enable       |                   |                  |             | 20-2  | maximum scan line         |             | 17-15            |
| LPB  22-5                              |                   |                  |             |       | MCLK                      |             |                  |
| vertical retrace interrupt clear       |                   |                  | 17-18       |       | dividing                  | 18-21       |                  |
| vertical retrace interrupt enable      |                   |                  | 17-18,20-1- |       | external input            |             | 18-7             |
| 20-2                                   |                   |                  |             |       | loading new frequency     |             | 8-3, 18-8 -18-9  |
| vertical retrace interrupt status      |                   |                  | 17-3        |       | output for testing        |             | 18-8             |
|                                        |                   |                  |             |       | programming               |             | 8-3, 18-5        |
| L                                      |                   |                  |             |       | source selection          |             | 8-3, 18-21       |
|                                        |                   |                  |             |       | mechanical dimensions     |             | 2-1              |
| LCLK                                   |                   |                  |             |       | memory                    |             |                  |
| invert                                 | 22-3              |                  |             |       | See display memory        |             |                  |
| select                                 | 12-1,22-3         |                  |             |       | memory mapped I/O         |             |                  |
| line compare                           | 17-23             |                  |             |       | at B7000H window          |             | 16-5             |
| line error term                        |                   | 16-9             |             |       | described                 | 16-4        |                  |
| linear addressing                      |                   |                  |             |       | enable                    | 19-19       |                  |
| enable                                 | 16-1, 19-22,20-3  |                  |             |       | new  16-6                 |             |                  |
| explained                              | 16-1              |                  |             |       | packed registers          |             | 16-5             |
| window position                        |                   | 19-23, 23-4      |             |       | memory mapping            |             |                  |
| window size                            |                   | 19-22            |             |       | EnhancedNGA modes         |             | 19-3             |
| little endian addressing               |                   | 16-6             |             |       | minor axis pixel count    |             | 20-15            |
| Local Peripheral Bus                   |                   |                  |             |       | MIU synchronization       |             | 19-34            |
| See LBP                                |                   |                  |             |       | MMIO                      |             |                  |
| LP                                     |                   |                  |             |       | See memory mapped I/O     |             |                  |
| disable during vertical blank          |                   |                  | 18-31       |       | MOD                       |             |                  |
| polarity                               | 18-26             |                  |             |       | function select           |             | 18-27            |
| LPB                                    |                   |                  |             |       | modulation                |             |                  |
| burst size                             | 22-2              |                  |             |       | clock select              |             | 18-27            |
| color byte swap                        |                   | 22-2             |             |       | enable                    | 18-27       |                  |
| decimation                             |                   | 12-8,22-12       |             |       | period                    | 18-27       |                  |
| digitizer interface                    |                   | 12-7             |             |       |                           |             |                  |
| double buffering                       |                   | 12-7, 12-9,22-7  |             |       |                           |             |                  |
1-4  INDEX

86CM65 Dual Display Accelerator
53 I ..o rporated
| N                         |             |        |        | vendor 1.0.       | 6-1         |           |     |     |
| ------------------------- | ----------- | ------ | ------ | ----------------- | ----------- | --------- | --- | --- |
|                           |             |        |        | pin descriptions  |             | 3-3 -3-6  |     |     |
| N parameter               | 7-10,19-34  |        |        | pin list          |             |           |     |     |
| controller 2 FIFO         |             | 19-34  |        | alphabetical      | 3-9         |           |     |     |
| See also PLL n parameter  |             |        |        | numerical         | 3-10 -3-12  |           |     |     |
| primary stream FIFO       |             |        | 19-25  | pitch  17-19      |             |           |     |     |
STN FIFO  19-35  PLL M parameter  8-1, 18-5 -18-6, 18-18 -18-19
nibble swap  19-20  PLL N parameter  8-1, 18-5 -18-6, 18-18 -18-19
| NTSC output               | 10-3, 19-12  |     |     | PLL power up/down time  |        |                                | 18-35  |     |
| ------------------------- | ------------ | --- | --- | ----------------------- | ------ | ------------------------------ | ------ | --- |
|                           |              |     |     | PLL R parameter         |        | 8-1, 18-5 -18-6, 18-18 -18-19  |        |     |
| o                         |              |     |     | polarity                |        |                                |        |     |
|                           |              |     |     | enable                  | 18-32  |                                |        |     |
| ODD input                 | 3-7, 12-8    |     |     | power management        |        | 5-4                            |        |     |
| odd/even frame indicator  |              |     |     | HSYNC control           |        | 5-7,18-4                       |        |     |
| invert                    | 22-3         |     |     | VSYNC control           |        | 18-4                           |        |     |
5-4, 18-33
| OE  |     |     |     | power sequencing  |     |     |     |     |
| --- | --- | --- | --- | ----------------- | --- | --- | --- | --- |
stretch time  7-3,19-29  programming requirements  5-4, 18-34
| offset  17-19              |     |     |       | programming               | 16-7  |        |        |     |
| -------------------------- | --- | --- | ----- | ------------------------- | ----- | ------ | ------ | --- |
|                            |     |     |       | requirements after reset  |       |        | 5-4    |     |
| p                          |     |     |       | programming examples      |       |        |        |     |
|                            |     |     |       | BitBLT across the plane   |       |        | 16-18  |     |
| packed registers for MMIO  |     |     | 16-5  | BitBLTthrough the plane   |       |        | 16-17  |     |
| paired registers           |     |     |       |                           |       | 16-23  |        |     |
hardware cursor
| enabling for reads  |     | 18-20  |     | hardware icon  |     | 16-25  |     |     |
| ------------------- | --- | ------ | --- | -------------- | --- | ------ | --- | --- |
enabling for writes  18-20  image transfer across the plane  16-15
| explained  | 11-14  |     |     | image transfer through the plane  |     |     |        | 16-13  |
| ---------- | ------ | --- | --- | --------------------------------- | --- | --- | ------ | ------ |
| listof     | 11-14  |     |     | pattern fill across the plane     |     |     | 16-21  |        |
PAL output  10-3,19-12  pattern fill through the plane  16-20
| palette registers               |                     | 17-33  |        | rectangle fill solid      |        | 16-12  |        |     |
| ------------------------------- | ------------------- | ------ | ------ | ------------------------- | ------ | ------ | ------ | --- |
| lock access                     | 19-5                |        |        | short stroke vectors      |        | 16-22  |        |     |
| panning                         | 17-15,17-34, 17-36  |        |        | solid line                | 16-9   |        |        |     |
| pass-through                    | 12-8                |        |        | textured line             |        | 16-10  |        |     |
| clock select for                |                     | 22-3   |        | PWM                       |        |        |        |     |
| PatBLT                          |                     |        |        | clock pre-devide select   |        |        | 18-43  |     |
| See pattern fill                |                     |        |        | duty cycle specification  |        |        | 18-44  |     |
| pattern fill                    | 20-9                |        |        | enable                    | 18-43  |        |        |     |
| pattern fill across the plane   |                     |        | 16-21  | explained                 | 11-11  |        |        |     |
| pattern fill through the plane  |                     |        | 16-20  | source clock select       |        | 18-43  |        |     |
PCIBus
| BIOS ROM access enable                   |      |        | 23-5   | Q                         |     |     |        |     |
| ---------------------------------------- | ---- | ------ | ------ | ------------------------- | --- | --- | ------ | --- |
| BIOS ROM base address                    |      |        | 23-5   |                           |     |     |        |     |
| configuration                            |      | 6-1    |        | quadword mode addressing  |     |     | 17-19  |     |
| device 1.0.                              | 6-1  |        |        |                           |     |     |        |     |
| DEVSEL timing                            |      | 6-1    |        |                           |     |     |        |     |
| disable read bursts                      |      |        | 19-11  |                           |     |     |        |     |
| enable disconnect                        |      | 19-28  |        |                           |     |     |        |     |
| enable I/O accesses                      |      |        | 23-2   |                           |     |     |        |     |
| enable memory accesses                   |      |        | 23-2   |                           |     |     |        |     |
| linear addressing base address           |      |        | 23-4   |                           |     |     |        |     |
| master abort handling during DAC cycles  |      |        | 10-    |                           |     |     |        |     |
3,19-6
| RAMDAC snoop method               |     |     | 19-6        |     |     |     |     |             |
| --------------------------------- | --- | --- | ----------- | --- | --- | --- | --- | ----------- |
| retry handling during DAC cycles  |     |     | 10-3, 19-6  |     |     |     |     |             |
|                                   |     |     |             |     |     |     |     | INDEX  1-5  |

86CM65 Dual Display Accelerator
S3 Incorpo. ....d
| R                        |               |             |             |     | shared registers                |        | 11-14        |        |
| ------------------------ | ------------- | ----------- | ----------- | --- | ------------------------------- | ------ | ------------ | ------ |
|                          |               |             |             |     | short stroke vector             |        | 16-22,20-10  |        |
| R parameter              |               |             |             |     | simultaneous display            |        | 11-13        |        |
| See PLL R parameter      |               |             |             |     | slow DRAM refresh select        |        |              | 18-35  |
| RAMDAC                   |               |             |             |     | solid line drawing              |        | 16-9         |        |
| 3.3V power select        |               | 18-11       |             |     | source base address             |        | 20-17        |        |
| AC specifications        |               | 4-3         |             |     | standby mode                    |        |              |        |
| access                   | 17-38 -17-40  |             |             |     | activity function enable        |        |              | 18-34  |
| accessing                | 10-3          |             |             |     | description                     | 5-4    |              |        |
| bus snooping             |               | 10-3        |             |     | hardware enable                 |        | 18-33        |        |
| clock doubled operation  |               |             | 10-2,18-11  |     | software enable                 |        | 18-34        |        |
| color mode select        |               | 19-29       |             |     | status                          | 18-36  |              |        |
| color modes              |               | 10-1 -10-3  |             |     | timeout value                   |        | 18-34        |        |
| data source              | 18-24         |             |             |     | timer resolution                |        | 18-33        |        |
| DC characteristics       |               | 4-1         |             |     | start address                   | 17-17  |              |        |
| DC specifications        |               | 4-1         |             |     | start horizontal blank          |        | 17-12        |        |
| lock writes              | 19-5          |             |             |     | start horizontal sync position  |        |              | 17-13  |
| PCI bus snooping         |               | 19-6        |             |     | start vertical blank            |        | 17-20        |        |
| power down               |               | 18-11       |             |     | stepping information            |        | 19-2 -19-3   |        |
| sense generation         |               | 10-3        |             |     | STN panel                       |        |              |        |
| RAS                      |               |             |             |     | data bus sizes supported        |        |              | 11-1   |
low time select  7-3,19-29,21-14  data output configurations  11-1, 11-9
| precharge time select  |       |     | 7-3,21-14  |     | dithering           | 11-3, 18-28  |        |     |
| ---------------------- | ----- | --- | ---------- | --- | ------------------- | ------------ | ------ | --- |
| read mask              | 16-4  |     |            |     | FIFO clocking rate  |              | 19-35  |     |
real mode  16-1  frame buffer size specification  11-6, 18-42
rectangle fill solid drawing  16-12  frame buffer starting address  18-41
refresh, DRAM  7-2,7-10,17-19,19-10  frame buffer starting location  11-6
| type used during Suspend        |              |        | 18-35  |        | frame rate control        |            | 11-3            |             |
| ------------------------------- | ------------ | ------ | ------ | ------ | ------------------------- | ---------- | --------------- | ----------- |
| reset                           |              |        |        |        | functional timing         |            | 11-1            |             |
| Graphics Engine                 |              | 20-3   |        |        | modulation                | 11-1       |                 |             |
| LPB  22-2                       |              |        |        |        | output format             |            | 18-31           |             |
| programming requirements        |              |        |        | 18-34  | selection                 | 11-1,11-9  |                 |             |
| programming requirements after  |              |        |        | 5-4    | strapping, configuration  |            |                 | 5-1         |
| system                          | 5-1          |        |        |        | streams processor         |            |                 |             |
| revision status                 | 19-2 -19-3   |        |        |        | blending                  | 9-7,21-5   |                 |             |
| ROMEN function select           |              |        | 18-11  |        | chroma keying             |            | 21-4            |             |
| row scan count                  |              | 17-15  |        |        | color space conversion    |            |                 | 9-4 -9-5    |
|                                 |              |        |        |        | color/chroma keying       |            |                 | 9-8,21-2    |
| s                               |              |        |        |        | compose modes             |            | 9-5,21-5        |             |
|                                 |              |        |        |        | double buffering          |            | 9-2,21-6 -21-7  |             |
| S-Video                         | 10-3, 19-12  |        |        |        | FIFO control              |            | 9-8,21-13       |             |
| scaling  9-4                    |              |        |        |        | filter characteristics    |            |                 | 21-1, 21-3  |
| screen off                      | 17-7,19-33   |        |        |        | filter constants          |            | 21-4            |             |
| screen width                    | 19-18        |        |        |        | input data formats        |            | 21-1,21-3       |             |
| self-refresh DRAM select        |              |        | 18-35  |        | introduction              |            | 9-1             |             |
| SENSE                           |              |        |        |        | mode select               |            | 19-28           |             |
| circuit enabled                 |              | 18-17  |        |        | opaque overlay            |            | 9-6,21-10       |             |
| status of internal signal       |              |        | 17-3   |        | primary stream input      |            |                 | 9-2         |
| serial port                     | 13-2         |        |        |        | primary stream stride     |            |                 | 21-7        |
| add wait states                 |              | 22-6   |        |        | primary stream window     |            |                 | 21-14       |
| at I/O address                  |              | 13-2   |        |        | scaling                   | 9-4,21-12  |                 |             |
| I/O address select              |              | 19-32  |        |        | secondary stream input    |            |                 | 9-2         |
| register                        | 22-9 -22-10  |        |        |        | secondary stream stride   |            |                 | 21-10       |
1-6  INDEX

86CM65 Dual Display Accelerator
sa Incorpontod
| secondary stream window  |     | 21-15  |     | V   |     |     |     |
| ------------------------ | --- | ------ | --- | --- | --- | --- | --- |
STWR
| function select         |      | 18-11  |     | VCLK                        |        |        |        |
| ----------------------- | ---- | ------ | --- | --------------------------- | ------ | ------ | ------ |
| super VGA support       |      | 15-2   |     | inversion of DCLK           |        | 19-5   |        |
| suspend mode            |      |        |     | phase with respect to DCLK  |        |        | 19-28  |
| debounce timer          |      | 18-34  |     | vertical blank              |        |        |        |
| description             | 5-6  |        |     | end                         | 17-21  |        |        |
| PLL power up/down time  |      | 18-35  |     | start                       | 17-20  |        |        |
| software enable         |      | 18-33  |     | vertical centeri ng         |        | 11-11  |        |
|                         |      |        |     | vertical display end        |        | 17-19  |        |
| T                       |      |        |     | vertical expansion          |        | 11-11  |        |
vertical retrace
| test load, AC               | 4-3           |        |     | enable interrupt          |        | 17-18       |        |
| --------------------------- | ------------- | ------ | --- | ------------------------- | ------ | ----------- | ------ |
| test mode                   | 5-1,19-9      |        |     | end                       | 17-18  |             |        |
| text mode                   |               |        |     | start                     | 17-18  |             |        |
| vertical expansion          |               | 11-11  |     | vertical size             | 17-2   |             |        |
| textured line drawing       |               | 16-10  |     | vertical total            | 17-14  |             |        |
| TFT panel                   |               |        |     | VGA compatibility         |        | 15-1,17-1   |        |
| data bus sizes supported    |               | 11-9   |     | VGA graphics mode select  |        |             | 17-34  |
| data output configurations  |               | 11-9   |     | VGA memory bus width      |        | 19-3        |        |
| dithering                   | 11-11, 18-28  |        |     | VGA memory mapping        |        | 19-3 -19-4  |        |
| dual edge clocking          |               | 18-32  |     | video BIOS                |        |             |        |
| enable polarity function    |               | 18-32  |     | access enable (PCI)       |        | 23-5        |        |
| functional timing           |               | 11-9   |     | base address (PCI)        |        | 23-5        |        |
| output format               |               | 18-31  |     | video display enable      |        | 17-32       |        |
| tri-state off               |               |        |     | VSYNC                     |        |             |        |
| HSYNC                       | 19-21         |        |     | active status             |        | 17-4        |        |
memory interface signals  18-26·  control for power management  18-4
| PO lines  | 18-3   |     |     | polarity                              | 17-2  |     |        |
| --------- | ------ | --- | --- | ------------------------------------- | ----- | --- | ------ |
| VSYNC     | 19-21  |     |     | polarity during simultaneous display  |       |     | 18-26  |
TV
| interlaced operation         |        | 12-8   |     | w                     |             |               |     |
| ---------------------------- | ------ | ------ | --- | --------------------- | ----------- | ------------- | --- |
| interlaced output            |        | 22-3   |     |                       |             |               |     |
| output to CRT or flat panel  |        | 12-8   |     | wakeup                | 14-1        |               |     |
| TV output                    | 10-3   |        |     | WE                    |             |               |     |
| black and white              |        | 19-12  |     | delay                 | 19-33       |               |     |
| enable                       | 19-12  |        |     | delay time            | 7-3         |               |     |
| two page screen              |        | 19-3   |     | word mode addressing  |             | 17-19, 17-22  |     |
|                              |        |        |     | write mask            | 16-2, 16-8  |               |     |
u
x
| underline location                  |     | 17-20       |              |                        |              |       |     |
| ----------------------------------- | --- | ----------- | ------------ | ---------------------- | ------------ | ----- | --- |
| unlocking                           |     |             |              | X-Windows              | 16-23,19-21  |       |     |
| configuration strapping registers   |     |             | 19-10,19-12  |                        |              |       |     |
| Enhanced registers                  |     | 19-13       |              | z                      |              |       |     |
| extended sequencer registers        |     |             | 18-1         |                        |              |       |     |
| pseudocode for                      |     | 14-1        |              | ZV Port                |              |       |     |
| 53 VGA registers                    |     | 19-1,19-10  |              | enable                 | 22-3         |       |     |
| system control/extension registers  |     |             | 19-10,19-    | interface              | 12-9         |       |     |
| 12                                  |     |             |              | Video 16 mode setting  |              | 22-1  |     |
INDEX  1-7

SR59
SR5A
FP Registers for TFT Panels
SR5B
Reg Panel Size
SR5C
Parameters/registers
SR5D
Horizontal resolution
SR5E
Vertical resolution
SR5F
Dot Clock (MHz)
SR60
Horizontal freq (kHz)
SR61
Refresh rate (Hz)
SR62
SR63
SR30
SR64
SR31
SR65
SR32
SR66
SR33
SR67
SR34
SR68
SR35
SR69
SR36
SR6A
SR37
SR6B
SR37
SR6C
SR38
SR6D
SR39
SR6E
SR3A
SR6F
SR3B
SR3C
SR3D
SR3E
SR3F
SR40
SR41
SR42
SR43
SR44
SR45
SR46
SR47
SR48
SR49
SR4A
SR4B
SR4C
SR4D
SR4E
SR4F
SR50
SR51
SR52
SR53
SR54
SR55
SR56
SR57
SR58

86CM65 Dual Display Accelerator

