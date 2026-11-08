Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated
Trio64UV+
UMA
Graphics/Video
Accelerator
March 1996
S3 Incorporated
2770 San Tomas Expressway
P.O. Box 58058
Santa Clara, CA 95052-8058

Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated
NOTATIONAL CONVENTIONS
The following notational conventions are used in this data book:
Signal names are shown in all uppercase letters. For example, XD.
A bar over a signal name indicates an active low signal. For example. DE.
nOm indicates a bit field from bit n to bit m. For example, 7-0 specifies bits 7 through 0, inclusive.
nom indicates a signal (pin) range from n to m. For example 0[7:0] specifies data lines 7 through 0, inclusive
Use of a trailing letter H indicates a hexadecimal number. For example, 7AH is a hexadecimal number.
Use of a trailing letter b indicates a binary number. For example, 010b is a binary number.
When numerical modifiers such as K or M are used, they refer to binary rather than decimal form. Thus, for example, 1 KByte would be
equivalentto 1024, not 1,000 bytes.
NOTICES
© Copyright 1996 S3lncorporated. All rights reserved. If you have received this document from S31ncorporated in electric form, you are
permitted to make the following copies for business use related to products of S3 Incorporated: one copy onto your computer for the
purpose of on-line viewing, and one printed copy. With respectto all documents, whether received in hard copy or electronic form, other
use, copying or storage, in whole or in part, by any means electronic, mechanical, photocopying or otherwise, is permitted without the
prior written consent of S31ncorporated, P.O. Box 58058., Santa Clara CA 95052-8058. S3 and True Acceleration are registered trademarks
of S3 Incorporated. The S3 Corporate Logo, S3 on Board, S3 on Board design, S3d design, Vision968, Trio, Tri064, Trio64V+, Tri064UV+,
ViRGE, ViRGENX, S3d, Scenic, Scenic/MX1, Scenic/MX2, Scenic Highway, Sonic, Sonic/AD, Aurora64V+, DuoView, Cooperative Accel
erator Architecture, Streams Processor, MIC, Galileo, Native-MPEG, No Compromise Integration, No Compromise Acceleration and
Innovations in Acceleration are trademarks of S3 Incorporated. Other trademarks referenced in this document are owned by their
respective companies. The material in this document is for information only and is subject to change without notice. S3 Incorporated
reserves the right to make changes in the product design without reservation and without notice to its users.
Additional information may be obtained from:
S31ncorporated, Literature Department P.O. Box 58058, Santa Clara, CA 95052-8058.
Telephone: 408-980-5400, Fax: 408-980-5444

Tri064UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Table of Contents
| List of Figures  |     | iv  | Section 4: Register Changes from  |     |     |
| ---------------- | --- | --- | --------------------------------- | --- | --- |
Tri064V+  .............. 4-1
| List of Tables  | .   |     | 4.1  REGISTERS CHANGED. . . . . . .  |     | 4-1  |
| --------------- | --- | --- | ------------------------------------ | --- | ---- |
.V
|                          |     |        | 4.2  NEW REGISTERS  | . . . . . . . . . .  | 4-4  |
| ------------------------ | --- | ------ | ------------------- | -------------------- | ---- |
| Section 1: Introduction  |     | . 1-1  |                     |                      |      |
Section 5: Programming
| 1.1  OVERViEW  | ............. 1-2  |     |     |     |     |
| -------------- | ------------------ | --- | --- | --- | --- |
1.2  ADVANCED ARCHITECTURE/  Considerations  . .......... 5-1
| FEATURE SET  | ........... 1-2  |     | 5.1  SYSTEMNIDEO BIOS  |     |     |
| ------------ | ---------------- | --- | ---------------------- | --- | --- |
1,3  UNIFIED MEMORY ARCHITECTURE  INITIALIZATION PROCESS. .  5-1
(UMA) ................ 1-2  5.2  MODE SETS . . . . . . . . . . . . .  5-2
| 1.4  STREAMS PROCESSOR SUPPORT  |     | 1-2  |     |     |     |
| ------------------------------- | --- | ---- | --- | --- | --- |
1.5  MULTIMEDIA SUPPORT FEATURES 1-3
|                                  |     |         | Section 6: Electrical Data  | ..... 6-1  |     |
| -------------------------------- | --- | ------- | --------------------------- | ---------- | --- |
| 1.6  FEATURES ADDED TO Trio64V+  |     | .  1-3  |                             |            |     |
6.1  MAXIMUM RATINGS ........ 6-1
1.7  FEATURES REMOVED FROM
|           |                     |     | 6.2  DC SPECIFICATIONS  | . . . . . . . .  | 6-1  |
| --------- | ------------------- | --- | ----------------------- | ---------------- | ---- |
| Trio64V+  | .............. 1-3  |     |                         |                  |      |
|           |                     |     | 6.3  AC SPECIFICATIONS  | . . . . . . . .  | 6-3  |
1.8  INTRODUCTION TO THIS DATA
|                                            |               |                  | 6.3.1  RAMDAC AC Specifications  |              | . .  6-3  |
| ------------------------------------------ | ------------- | ---------------- | -------------------------------- | ------------ | --------- |
| BOOKLET. . . . . . . . . . . ..            |               | 1-3              |                                  |              |           |
|                                            |               |                  | 6.3.2  Clock Timing              | ....         | 6-4       |
|                                            |               |                  | 6.3.3  Input/Output Timing       | . . . . . .  | 6-5       |
| Section 2: Pins                            | .  . .  . .   | .  .  . ... 2-1  |                                  |              |           |
| 2.1  PINOUT DIAGRAMS                       | ........ 2-1  |                  |                                  |              |           |
|                                            |               |                  | Section 7: Mechanical Data       | .... 7-1     |           |
| 2.2  PIN DESCRIPTIONS                      | ........ 2-3  |                  |                                  |              |           |
|                                            |               |                  | 7.1  THERMAL SPECIFICATIONS.     |              | 7-1       |
| 2.3  PIN LISTS . . . . . . . . . . . . ..  |               | 2-8              |                                  |              |           |
7.2  MECHANICAL DIMENSIONS .... 7-1
Section 3: Functional Changes
| from Tri064V+                          | . .  . ........ 3-1  |                   |     |     |     |
| -------------------------------------- | -------------------- | ----------------- | --- | --- | --- |
| 3.1  RESET/POWER-ON STRAPPING..        |                      | 3-1               |     |     |     |
| 3.2  MEMORY INTERFACE                  |                      | ....... 3-1       |     |     |     |
| 3.2.1  Memory Map . . . . . . . . . .  |                      | 3-2               |     |     |     |
| 3.2.2  Address Translation             |                      | . . . . . .  3-2  |     |     |     |
| 3.2.3  Dram Types Supported            |                      | .... 3-2          |     |     |     |
| 3.3  MEMORY ARBITRATION.               |                      | . . . ..  3-2     |     |     |     |
| 3.3.1  Protocol Description            |                      | . . . . ..  3-2   |     |     |     |
| 3.3.2  Arbitration Timing Diagrams     |                      | .  3-3            |     |     |     |
| 3.4  MIXED VOLTAGE SUPPORT. . ..       |                      | 3-6               |     |     |     |
| 3.5  OPERATING MODES. . . . . . ..     |                      | 3-7               |     |     |     |
iii

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
List of Figures
#
| TI~                                     |     | ~~   |
| --------------------------------------- | --- | ---- |
| 2-1  Pinout . . . . . . . . . . . . ..  |     | 2-2  |
3-1  System and Memory Interface
| Block Diagram                  | ......  | 3-1  |
| ------------------------------ | ------- | ---- |
| 3-2  Memory Map . . . . . . .  |         | 3-2  |
| 3-3  Address Translation       | .. .    | 3-3  |
3-4  VUMA-Style Low Priority
| Arbitration                | .....   | 3-4  |
| -------------------------- | ------- | ---- |
| 3-5  S3 3-Pin Arbitration  | ...     | 3-5  |
| 3-6  2-Pin Arbitration     | ......  | 3-5  |
3-7  Early Withdrawal of the Bus Grant 3-6
| 5-1  BIOS Initialization Process  |              | 5-1  |
| --------------------------------- | ------------ | ---- |
| 5-2  Mode Setting                 | . . . . . .  | 5-2  |
| 6-1  Clock Waveform Timing.       |              | 6-4  |
| 6-2  Input Timing                 | .......      | 6-5  |
| 6-3  Output Timing                | ......       | 6-7  |
7-1  208-pin PQFP Mechanical
| Dimensions . . . . . . . .  |     | 7-2  |
| --------------------------- | --- | ---- |
iv

Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated
List of Tables
# Title Page
2-1 Pin Descriptions . 2-3
2-2 Alphabetical Pin Listing . 2-8
Numerical Pin Listing. . . 2-10
3-1 Operating Modes. . . . 3-7
6-1 Absolute Maximum Ratings 6-1
6-2 RAMDAC/Clock Synthesizer DC
Specifications . . . . . . . . 6-1
6-3 RAMDAC Characteristics. . 6-1
6-4 Digital DC Specifications . . 6-2
6-5 RAMDAC AC Specifications 6-3
6-6 RAMDAC Output Specifications. 6-3
6-7 Clock Waveform Timing . . .. 6-4
6-8 SCLK-Referenced Input Timing 6-5
6-9 LCLK-Referenced Input Timing 6-5
6-10 MCLK-Referenced Input Timing 6-6
6-11 ACLK-Referenced Input Timing 6-6
6-12 SCLK-Referenced Output Timing 6-7
6-13 LCLK-Referenced Output Timing 6-7
6-14 MCLK-Referenced Output Timing 6-8
6-15 ACLK-Referenced Output Timing 6-8
6-16 Feature Connector Timing -Output
from Trio64UV+ to Feature
Connector . . . . . . . . . . . .. 6-8
6-17 Feature Connector Timing -Output
from Feature Connector to
Trio64UV+. . . . . . . . . . . .. 6-9
v

II·
Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Section 1: Introduction
High-Performance Integrated Graphics/Video • Arithmetic blending of two pixel
Accelerator streams for fade-in/fade-out transition ef
fects
• High-performance 64-bit graphics engine
Unified Memory Architecture (UMA)
• Integrated 24-bit RAMDAC with 135 MHz
output pixel rate and programmable
dual-clock synthesizer • UMA shares system memory between
the host CPU and the graphics/video
• Unique 53 Streams Processor for hard
subsystem
ware-assisted video playback
• System memory arbitration compatible
• 53 Scenic Highway for direct interface to with all major core logic vendors
live video and MPEG-1 peripherals
• 64-bit DRAM memory interface
S3 Streams Processor Features • 0.5-, 1-, 1.5 or 2-MByte configurable
frame buffer
• Supports on-the-fly stretching and blend • Fast page and EDO mode memory sup
ing of primary RGB stream and RGB or
port
. YUV/YCbCr (video) secondary stream
• Each stream can have different color Mixed Voltage Support
depths
• 5V core, 5V or 3.3V memory bus opera
• YUV data is color space converted on
the fly tion
• Compatible with 5V or 3.3V memories
Advanced Playback Capabilities
• Compatible with 5V or 3.3V UMA core
logic
• High-quality hardware-assisted video
playback (up to 1024x768xB bits/pixel)
S3 Scenic Highway Interface
• Support for Indeo, Cinepak, and soft
ware-accelerated MPEG-1 video playback • Philips SAA7110/SAA7111 video
digitizers
Game and Presentation Effects • 53 Scenic/MX2 MPEG-1 audio/video
decoder
• Hardware double-buffering support for
high-quality tear-free playback
• 2-D scrolling and sprite plane support
• Color and chroma keying for overlaying
of graphics onto video and video onto
graphics
INTRODUCTION 1-1

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
High Resolution Non-Interlaced Screen Support and will be supported in many next generation
Pentium/PCI core logic designs.
• 1280x1024x256 colors
• 1024x768x256 colors 1.2 ADVANCED
• 800x600x64K colors ARCHITECTURE/FEATURE SET
• 640x480x16.7M colors
Tri064UV+ provides a 64-bit high performance
Glueless PCI 2.1 Bus Support graphics engine and a 64-bit DRAM interface. The
full 64-bit memory data path is used in all frame
Multimedia Support Hooks buffer configurations, which range in size from
0.5 to 2 MBytes. Fast-page and EDO mode
• 8-bit bidirectional feature connector DRAMs are supported.
• S3 Scenic Highway
• 12C bus 1.3 UNIFIED MEMORY
ARCHITECTURE (UMA)
Full Software Support
Tri064UV+ is the first product offered by S3 to
• Drivers for Windows 3.11, Windows NT,
Windows 95, OS/2 2.1 and 3.0 (Warp), support UMA operation. This architecture re
SCQ UNIX serves a portion of main system memory as
graphics memory, thus eliminating the need for
a separate graphics frame buffer. This allows
Green PC/Monitor Plug and Play Support
system manufacturers to dramatically reduce the
graphics subsystem cost. Since the graphics
• Full hardware and BIOS support for
VESA Display Power Management Sig memory is now an integral part ofthe host mem
naling (DPMS) monitor power savings ory bus, CPU accesses to graphics memory are
modes no longer constrained by PCI bandwidth limita
tions. This drastically reduces the software over
• Extensive static/dynamic power manage
head of many common graphics operations.
ment
• DDC monitor communications support
1.4 STREAMS PROCESSOR
Industry-Standard 20S-pin PQFP package SUPPORT
1.1 OVERVIEW The 53 Streams Processor™ technology proc
esses data from the graphics frame buffer, com
poses it and outputs the result to the internal
The S3®Tri064UV+TM UMA graphics/video accel DACs for generation of the analog RGB outputs
erator (hereinafter referred to as the Tri064UV+) to the monitor. Data is composed from up to 3
is the newest member of the extremely success independent streams: (1) Primary Stream-RGB
ful TrioTM family of products. Based on the graphics data; (2) Secondary Stream-RGB or
Tri064V+TM integrated graphics/video accelera YUV/YCbCr (video) data from another region
tor, Tri064UV+ addS Unified Memory Architec within the frame buffer; and (3) a 64x64x2 hard
ture (UMA) support allowing system memory to ware cursor.
be shared between the host CPU and the graph
ics/video sl,!bsystem. UMA support provides a Arithmetic blending of a primary graphics stream
full-featured solution for motherboard designs and secondary graphics/video enables dramatic
that dramatically reduces the graphics subsys transition effects for game and multimedia appli
tem cost and foo~rint. Tri064UV+ is targeted at cations. Color and chroma keying allow opaque
entry-level Intel Pentium™ systems and or transparent overlays of one stream on the
equivalents. It has been developed in conjunc other.
tion with all major PC system core logic vendors
1-2 INTRODUCTION

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Simultaneous display of graphics and video of • Relocation of Serial Port register to I/O
different color depths is provided. For example, port via power-on strapping
it is possible to display true color (24-bit) video
data on top of an 8-bit graphics background. This
can improve video quality and frame rates while
reducing memory bandwidth and storage re
1.8 INTRODUCTION TO THIS DATA
quirements.
BOOKLET
1.5 MULTIMEDIA SUPPORT
This data booklet largely describes the areas in
FEATURES
which Tri064UV+ differs from Tri064V+. It does
contain complete pin descriptions and electrical
Tri064UV+ supports the S3 Scenic HighwayTM and mechanical specification sections. Other
local peripheral bus for direct connection to video wise, the Tri064V+ data book must be used in
input devices like the S3 Scenic/MX2™ conjunction with this data booklet.
AudioNideo MPEG decoder and the Philips®
video digitizers. The Streams Processor and Sce
nic Highway are tightly coupled to provide opti
mal live video playback. The hardware
automatically switches capture and display buff
ers without software intervention.
1.6 FEATURES ADDED TO Trio64V+
• Arbitration logic for UMA memory
• Support for system memory DRAMs [FP
and EDO SIMMs]
• Support for 0.5-and 1.5-MByte frame
buffers
• Optional disabling of DRAM refresh
(core logic refreshes DRAM instead)
• Mixed voltage operation
1.7 FEATURES REMOVED FROM
Trio64V+
• VL-Bus™ support
• Tri064™ -compatible mode
• Tri064-type VAFC feature connector sup-
port (multiplexed on PD lines)
• 16-bit VAFC feature connector on the
LPB
• Video 8 In/Out LPB mode
Video 16 LPB mode
• CL-480 support
• 4-MByte memory support
• 1-cycle EDO operation
INTRODUCTION 1-3

.6Ja
p• -
Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Section 2: Pins
2.1 PINOUT DIAGRAMS
Trio64UV+ comes in a 208-pin PQFP package. The pinout is shown in Figure 2-1.
PINS 2-1

Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporatad
XOUT MD231RD7
ClKAVDDl MD39
AVSS VSS
CLKAVDD2 MD7IRA7
AVSS MD54
VREF MD221RD6
AVS8 MOOS
Pi: A iO V W O N O M M D ~ 53 M
RBET VDDMEM
AYSS MD21/RDS
AR MD37
AVDO MD5JRAS
AYOO M052
~ ~
AB MD2iWRD4
AVS8 MOO6
LDOJPAD MD4IRA4
LD1IPA1 MAg
LD2IPA2 MAS
LD3IPA3 MA11
LD4IPA4 MA7
L05IPV:: Trio64UV+ ~~~RE
LD6IPA6 MA6
lCC:~~~ TOP VIEW :::
HSYNC V55
VSYNC MA3
VDOCORE MA2
AeLK MA1
MPR MAO
if<m't VOOMEM
~ MOS.
VDDLPB MD191RD3
'YFiEQlYRDYIEVlDEOIHS MOOS
CREQ/CRDYIEVCLKNS MD3IRA3
ESYNC V55
iliNi MD50
ENFEATIGOPO MD181RD2
"iNTA MOM
~RlGOP1 MD2IRA2
V55 MD49
RESERVED FOR PCI REQ MD17IRD1
RESERVED FOR PCI GNT MD33
SPCLK MD1IRA1
SPO M048
iiOMEN V58
"R'ESEf MD161RDO
Aoo1 MD32
AD30 VDDCORE
A~' --~MTMTMTMTnTnTnTTnTnTnTnTnTnTnTnMTMTMTMTMTnTnTnTnTTnTnTnTnTnTnTnnTMTMTnTr-_MoomM
Figure 2-1. Pinout
2-2 PINS

r-~ .
Trio64UV+ UMA Graphics/VideoAccelerator
53 Incorporated
2.2 PIN DESCRIPTIONS
The following table provides a brief description of each pin on Trio64UV+. The following abbreviations
are used for pin types.
I -Input signal
o -
Output signal
B -Bidirectional signal
Table 2-1. Pin Descriptions
Symbol Type Description
PCI BUS INTERFACE
Address and Data
AD[31:0[ B Multiplexed Address/Data Bus. A bus transaction (cycle) consists of an
address phase followed by one or more data phases.
C/BE[3:0] I Bus Command/Data Byte Enables. These signals carry the bus command
durinQ the addressQhase and the byte enables durinQ the data phase.
Bus Control
SCLK I PCI System Clock.
INTA 0 Interrupt Request.
IRDY I Initiator Ready. A bus data phase is completed when both IRDY and
TRDY are asserted on the same cycle.
TRDY 0 Target Ready. A bus data phase is completed when both IRDY and TRDY
are asserted on the same cycle.
DEVSEL 0 Device Select. Tri064UV+ drives this signal active when it decodes its
address as the target of the current access.
IDSEL I Initialization Device Select. This input is the chip select for PCI
confiQuration reQister reads/writes.
RESET I System Reset. Asserting this signal forces the registers and state
machines to a known state.
FRAME I Cycle Frame. This signal is asserted by the bus master to indicate the
beginning of a bus transaction. It is deasserted during the final data phase
of a bus transaction.
PAR 0 Parity. Tri064UV+ asserts this signal to verify even parity during reads.
STOP 0 Stop. Tri064UV+ asserts this signal to indicate a target disconnect.
PINS 2-3

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporatad
Table 2-1. Pin Descriptions (continued)
Symbol Type Description
CLOCK CONTROL
XIN I Reference Frequency Input. If an external crystal is used, it is connected
between XOUT and this pin. A stable external frequency source can also
be input via this pin. If this is done, the input voltage must be the same
as AVDD. If MDll is strapped high at power-on, this becomes the DCLK
(dot clock) input, bypassing the internal oscillator. This is normally only
used for test purposes.
XOUT 0 Crystal Output. If an external 14.318 MHz crystal is used, it is connected
between XIN and this pin. This pin drives the crystal via an internal
oscillator.
DISPLAY MEMORY INTERFACE
Address and Data
MA[11:0] 0 Memory Address Bus. The memory row and column addresses are
multiplexed on these lines.
MD[63:0] B Memory Data Bus Lines.
Memory Control
RAS 0 Row Address Strobe
CAS[7:0] 0 Column Address Strobes.
WE 0 Write Enable
Arbitration
MREQ 0 Memory Bus Request.
MGNT I Memory Bus Grant.
MPR 0 Priority. Tri064UV+ asserts this signal to indicate a high priority bus
request. This is not used with 2-pin arbitration schemes.
ACLK I Clock. This input is normally connected to the host CPU clock. It is used
by Tri064UV+ to synchronize the memory bus arbitration with the host
system. It may also be used as the s'}'Stem MCLK.
VIDEO INTERFACE
PDOWN I Power Down. Asserting this signal turns off the RGB analog output from
the DACs.
VREF Voltage Reference. This pin is tied to Vss through a 0.1 ~F capacitor.
RSET Reference Resistor. This pin is tied to Vss through an external resistor to
control the full-scale current value.
AR 0 Analog Red. Analog red output to the monitor.
AG 0 Analog Green. Analog green output to the monitor.
AB 0 Analog Blue. Analog blue signal to the monitor.
2-4 PINS

Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated
Table 2-1. Pin Descriptions (continued)
Symbol Type Description
ENFEAT 0 Enable Feature Connector. Setting SRD_O to 1 drives this signal low
when SRl C_l-0 are OOb. This also enables all feature connector
operations.
BLANK B Video Blank.
ESYNC I External SYNC. When ESYNC is driven low, HSYNC, VSYNC and BLANK
become inputs. When ESYNC is high, HSYNC, VSYNC and BLANK
become outputs.
EVIDEO I External Video. When this input is high, PA[7:0] are outputs to the feature
connector.
EVCLK I External VCLK. When this input is asserted low, VCLK is an input to the
intemal RAMDAC. When this input is high, VCLK is output to the feature
connector.
VCLK B Video/Pixel Clock. When EVCLK is high, this signal is an output to the
feature connector. When EVCLK is low, this becomes an input used only
for test purposes.
HSYNC B Horizontal Sync. When ESYNC is high, this is the horizontal sync output.
When ESYNC is low, this is an input from the feature connector.
VSYNC B Vertical Sync. When ESYNC is high, this is the vertical sync output. When
ESYNC is low, this is an input from the feature connector.
PA[7:0] B Pixel Address Lines [7:0). The PA[7:0) function is enabled on the pins
indicated for PCI configurations when LPB feature connector operation is
enabled. When EVIDEO is high, PA signals are outputs to the feature
connector.
PINS 2-5

Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated
Table 2-1. Pin Descriptions (Continued)
Symbol Type Description
MISCELLANEOUS FUNCTIONS
General Data, I/O and Serial Ports
RA[15:0] 0 ROM Address Bus. These signals provide the address for BIOS ROM
reads. They are mUltiplexed with MD signals. Programmers must ensure
that the memory bus is inactive when reading the ROM. This function is
only used in test mode.
RD[7:0] I ROM Data Bus. These signals carry data for BIOS ROM reads. They are
multiplexed with MD signals. Programmers must ensure that the
memory bus is inactive when reading the ROM. This function is only
used in test mode.
ROMEN 0 ROM Enable. This signal provides the chip output enable input for BIOS
ROM reads. This function is only used in test mode.
GOP[1:0] 0 General Output Port Bits 1-0. If SR1 C_1 is set to 1, the value of CR5C_O
is output on pin 196 (GOPO) and the value of CR5C_1 is output on pin 198
(GOP1).
STWR 0 Strobe Write. If SR1 C_1 is cleared to 0, this signal is asserted whenever a
write is made to CR5C. It is used to enable a General Output Port latch.
SPCLK I/O Serial Port Clock. This is the clock for serial data transfer, either for 12C or
DDC2 monitor data communications. As an output, it is programmed via
MMFF20_0. As an input, its status is read via MMFF20_2. In either case
the serial port must be enabled by setting MMFF20 4 to 1.
SPD I/O Serial Port Data. This is the data signal for serial data transfer, either for
12C or DDC2 monitor data communications. As an output, it is
programmed via MMFF20_1. As an input, its status is read via
MMFF20_3. In either case the serial port must be enabled by setting
MMFF20 4 to 1.
SCENIC HIGHWAY
Scenic/MX2 Mode
LD[7:0] I/O LPB Data. This is the Scenic Highway data bus and carries compressed
data to Scenic/MX2 and video data from Scenic/MX2.
LCLK I LPB Clock. This clock controls transactions between Trio64UV+ and
Scenic Highway peripherals
VREQNRDY 0 Video Request/Ready. This signal is part of the the Scenic Highway data
transfer protocol between Trio64UV+ and Scenic/MX2.
CREO/CRDY I Scenic/MX2 Request/Ready. This signal is part of the the Scenic Highway
data transfer protocol between Trio64UV+ and Scenic/MX2.
ENFEAT 0 Enable Feature Connector. This signal is connected to Scenic/MX2 chip
enable input such that Scenic/MX2 is disabled when feature connector
operation is enabled.
Video 8 Mode
LD[7:0] I LPB Data Bus [7:0]. This is the Scenic Highway data bus and carries video
data input.
HS I HSYNC. HSYNC input signaling the transition from one line to the next.
VS I VSYNC. VSYNC input signaling the transition from one frame to the next.
2-6 PINS

Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated
Table 2-1. Pin Descriptions (Continued)
Symbol Type Description
POWER AND GROUND
VDDCORE I Core digital power supply
VDDLPB I LPB power supply
VDDMEM I Memory subsystem digital power supply (3.3V or 5V -see Section 3.4 for
more information on mixed voltage operation)
VDDMTOL I 3.3V or 5V tolerance for memory subsystem (see Section 3.4 for more
information on mixed voltage operation)
VDDSYS I PCI Bus subsystem digital power supply
AVDD I Analog power supply (RAMDAC). This must be the same voltage as
VDDCORE.
CLKAVDD[l :21 I Analog power supply (clock synthesizer, 1 = MCLK, 2 = DCLK). This must
be the same voltage as VDDCORE.
VSS I Digital ground
AVSS I Analog ground
PINS 2-7

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
2.3 PIN LISTS
Table 2-2 lists all pins alphabetically. Table 2-3 lists all pins in numerical order.
Table 2-2. Alphabetical Pin Listing
PIN(S}
Name
AB 172
ACLK 187
AD[31:16] 206,207,208,3,4,5,6,7,11,12,13,15,16,17,18,19
AD[15:0] 30,31,32,33,34,35,36,38,40,41,42,43,44,46,47,48
AG 171
AR 168
AVDD 164,169,170
AVSS 159,161,163,167,173
BLANK 195
CAS[7:0] 114,112,117,110,113,111,116,108
C/BE[3:0] 8,20,29,39
CLKAVDD[l :2] 158,160
CREO/CRDY 193
DEVSEL 24
ENFEAT 196
ESYNC 194
EVCLK 194
EVIDEO 192
FRAME 21
RA[15:0] 154,149,145,137,133,129,123,119, 101,97,92,87,68,63, 59, 53
RD[7:0] 104,99,94,89,70,65,61,56
GOP[1:0] 198,196
HS 192
HSYNC 184
IDSEL 9
INTA 197
IRDY 22
LCLK 183
LD[7:0] 182,181,180,178,177,176,175,174
MA[11:0] 84,81,86,85,83,80,79,78,76,75,74,73
MD[63:48] 153,148,144,141,136,132,128,122,5,100,96,91,71,66, 62, 58
MD[47:32] 155,151,146,139,134,130,125,120,103,98,93,88,69, 64, 60,55
MD[31:16] 152,147,143,140,135,131,126,121,104,99,94,89,70, 65, 61,56
MD[15:0] 154, 149, 145, 137, 133, 129, 123, 119, 101, 97, 92, 87, 68, 63, 59, 53
2-8 PINS

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Table 2·2. Alphabetical Pin Listing (Continued)
PIN(S)
Name
MGNT 189
MPR 188
MREQ 190
PA[7:0] 182, 181, 18~ 17a 177, 17~ 17~ 174
PAR 27
PDOWN 165
RAS 107
RESERVED 50,51,52,200,201
RESET 205
ROMEN 204
RSET 166
SCLK 1
SPCLK 202
SPD 203
STOP 26
STWR 198
TRDY 23
VCLK 183
VDDCORE 54,82, 142, 186
VDDLPB 191
VDDMEM 72,95,124
VDDMTOL 109
VDDSYS 10,28,45
VREO/VRDY 192
VREF 162
VS 193
VSS 2,14,25,37,49,57,67,77,90,102,106,115,127,138,150, 179, 199
VSYNC 185
WE 118
XIN 156
XOUT 157
PINS 2-9

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Table 2·3.  Numerical Pin Listing
| Number  | Pin  | Number  | Pin  |
| ------- | ---- | ------- | ---- |
1
|     | SCLK  | 43  | AD4  |
| --- | ----- | --- | ---- |
VSS
| 2   |       | 44  | AD3     |
| --- | ----- | --- | ------- |
| 3   | AD28  | 45  | VDDSVS  |
| 4   | AD27  | 46  | AD2     |
| 5   | AD26  | 47  | AD1     |
| 6   | AD25  | 48  | ADO     |
VSS
| 7   | AD24    | 49  |           |
| --- | ------- | --- | --------- |
| 8   | C/BE3   | 50  | RESERVED  |
| 9   | IDSEL   | 51  | RESERVED  |
| 10  | VDDSVS  | 52  | RESERVED  |
| 11  | AD23    | 53  | MDO       |
| 12  |         |     | VDDCORE   |
|     | AD22    | 54  |           |
| 13  | AD21    | 55  | MD32      |
| 14  | VSS     | 56  | MD16      |
| 15  | AD20    | 57  | VSS       |
| 16  | AD19    | 58  | MD48      |
| 17  | AD18    | 59  | MD1       |
| 18  | AD17    | 60  | MD33      |
| 19  | AD16    | 61  | MD17      |
| 20  | C/BE2   | 62  | MD49      |
| 21  | FRAME   | 63  | MD2       |
| 22  | IRDY    | 64  | MD34      |
| 23  | TRDY    | 65  | MD18      |
| 24  | DEVSEL  | 66  | MD50      |
| 25  | VSS     | 67  | VSS       |
| 26  | STOP    | 68  | MD3       |
| 27  | PAR     | 69  | MD35      |
| 28  | VDDSVS  | 70  | MD19      |
| 29  | C/BE1   | 71  | MD51      |
VDDMEM
| 30  | AD15  | 72  |      |
| --- | ----- | --- | ---- |
| 31  | AD14  | 73  | MAO  |
| 32  | AD13  | 74  | MA1  |
| 33  | AD12  | 75  | MA2  |
| 34  | AD11  |     | MA3  |
76
VSS
| 35  | AD10   | 77  |       |
| --- | ------ | --- | ----- |
| 36  | AD9    | 78  | MA4   |
| 37  | VSS    | 79  | MA5   |
| 38  | AD8    | 80  | MA6   |
| 39  | C/BEO  | 81  | MA10  |
VDDCORE
| 40  | AD7  | 82  |       |
| --- | ---- | --- | ----- |
| 41  | AD6  | 83  | MA7   |
| 42  | AD5  | 84  | MA11  |
2-10  PINS

Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated
Table 2-3. Numerical Pin Listing (Continued)
| Number  | Pin   | Number  | Pin   |
| ------- | ----- | ------- | ----- |
| 85      | MA8   | 127     | VSS   |
| 86      | MA9   | 128     | MD57  |
| 87      | MD4   | 129     | MD10  |
| 88      | MD36  | 130     | MD42  |
| 89      | MD20  | 131     | MD26  |
| 90      | VSS   |         | MD58  |
132
| 91   | MD52     | 133  | MDll      |
| ---- | -------- | ---- | --------- |
| 92   | MD5      | 134  | MD43      |
| 93   | MD37     | 135  | MD27      |
| 94   | . MD21   | 136  | MD59      |
| 95   | VDDMEM   | 137  | MD27      |
| 96   | MD53     | 138  | VSS       |
| 97   | MD6      | 139  | MD44      |
| 98   | MD38     | 140  | MD28      |
| 99   | MD22     | 141  | MD60      |
| 100  | MD54     | 142  | VDDCORE   |
| 101  | MD7      | 143  | MD29      |
| 102  | VSS      | 144  | MD61      |
| 103  | MD39     | 145  | MD13      |
| 104  | MD23     | 146  | MD45      |
| 105  | MD55     | 147  | MD30      |
| 106  | VSS      | 148  | MD62      |
| 107  | RAS      | 149  | MD14      |
| 108  | CASO     | 150  | VSS       |
| 109  | VDDMTOL  | 151  | MD46      |
| 110  | CAS4     | 152  | MD31      |
| 111  | CAS2     | 153  | MD63      |
| 112  | CAS6     | 154  | MD15      |
| 113  | CAS3     | 155  | MD47      |
| 114  | CAS7     | 156  | XIN       |
| 115  | VSS      | 157  | XOUT      |
| 116  | CASl     | 158  | CLKAVDD1  |
| 117  | CAS5     | 159  | AVSS      |
| 118  | WE       | 160  | CLKAVDD2  |
| 119  | MD8      | 161  | AVSS      |
| 120  | MD40     | 162  | VREF      |
| 121  | MD24     | 163  | AVSS      |
| 122  | MD56     | 164  | AVDD      |
| 123  | MD9      | 165  | PDOWN     |
| 124  | VDDMEM   | 166  | RSET      |
| 125  | MD41     | 167  | AVSS      |
| 126  | MD25     | 168  | AR        |
PINS  2-11

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Table 2-3. Numerical Pin Listing (Continued)
Number Pin
169 AVDD
170 AVDD
171 AG
172 AB
173 AVSS
174 LDO/PAO
175 LD1/PA1
176 LD2/PA2
177 LD3/PA3
178 LD4/PA4
179 VSS
180 LD5/PA5
181 LD6/PA6
182 LD7/PA7
183 LCLKNCLK
184 HSYNC
185 VSYNC
186 VDDCORE
187 ACLK
188 MPR
189 MGNT
190 MREQ
191 VDDLPB
192 VREQNRDY/HS/EVIDEO
193 CREO/CRDYNS/EVCLK
194 ESYNC
195 BLANK
196 EN FEAT/GO PO
197 INTA
198 STWR/GOP1
199 VSS
200 RESERVED
201 RESERVED
202 SPCLK
203 SPD
204 ROMEN
205 RESET
206 AD31
207 AD30
208 AD29
2-12 PINS

Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated
Section 3: Functional Changes from Trio64V +
3.1  RESET/POWER-ON STRAPPING  The  default values for some of the former
(Tri064V+) power-on strapping bits have been
changed so that Tri064UV+ will power up in a
The logic levels on PD[28:0] are latched in regis
standard, operational configuration, e.g., in fast
ter bits for Tri064V+ and these pins are pulled up  page memory mode using internal MCLK and
internally. However, only the logic value on
DCLK.
MD11 is latched in a register bit (CR37 _3) for
Tri064UV+ and all MD pin pull-ups are removed.
MD11 can only be strapped in a test configuration  3.2  MEMORY INTERFACE
(to allow use of external MCLK and DCLK) and
must never be strapped in an operational system.
|     | Tri064UV+ system and  | memory interface is  |
| --- | --------------------- | -------------------- |
shown in Figure 3-1.
PCI
I
| ACLK  | T   |     |
| ----- | --- | --- |
1  J-
| 1   |     | PENTIUM  |
| --- | --- | -------- |
MREQ
CPU
MGNT
MPR
| WE  | WE  MEMORY  |     |
| --- | ----------- | --- |
Trio64UV+
| RASfx-fi  RASfx-l:01  | CONTROLLER  | HOST  |
| --------------------- | ----------- | ----- |
| CAw,Oi  cASrf:Oi      |             | BUS   |
| MA[11:0]  MA[11:0]    |             |       |
T (
!
| l   | l   | DATA  |
| --- | --- | ----- |
BUFFER
| DRAM  •••  | DRAM   |          |
| ---------- | ------ | -------- |
| ROWX-1     | ROW 0  |          |
| I          | I      |          |
| MD [63:0]  |        | TELLS8D  |
Figure 3·1. System and Memory Interface Block Diagram
Note to Figure 3-1
1. Tri064UV+ drives MA[ 11 :0] only to DRAM row x-1. This is the first (physically) installed bank.
The DRAM assigned to Tri064UV+ is then mapped by the core logic to the highest area of mem
ory.
FUNCTIONAL CHANGES FROM Tri064V+ 3-1

Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporatad
3.2.1 Memory Map 3.2.3 DRAM Types Supported
Tri064UV+ UMA frame buffer is located at the Tri064UV+ supports Fast Page and EDO memory
very top of physical memory. This is illustrated in SIMM configuration, with EDO strongly pre
by Figure 3-2. ferred for its higher bandwidth. SDRAM pins are
reserved for future use.
3.2.2 Address Translation
3.3 MEMORY ARBITRATION
Address translation for MA[ 11 :0] varies among
core logic companies. Tri064UV+ supports a 3.3.1 Protocol Description
number of these variations as shown in Figure
3-3. The blank cells are for addresses above A20.
These are always driven high by Tri064UV+ be The arbitration scheme allows the core logic and
Tri064UV+ to share memory resources effec
cause it is always located at the top of the mem
ory address space. The desired map is selected tively while minimizing performance degrada
tion. The core logic is the memory owner;
via CR81_6-4.
Tri064UV+ requests the memory when it needs
access. In order to communicate the urgency of
I
TOPOF
_- SYSTEM
..-- MEMORY
ROWX-1
INCREASING •
•
PHYSICAL •
ADDRESS
D
ROW 0
TELMEMMP
Figure 3-2. Memory Map
Notes to Figure 3-2
1. "Top of system memory" refers to top of me,mory as reported to the operating system. The
U MA frame buffer is located above that (and could be mapped by the core logic to a higher,
non-contiguous location).
2. The UMA frame buffer is not accessible to the Operating System as system memory, but device
drivers could access this region through the core logic memory controller (MC). This region
must be made non-cacheable as no bus snooping is done.
3. PCI masters can access the UMA frame buffer only through Tri064UV+. Therefore:
A. The MC must ignore PCI master accesses with the UMA frame buffer as the target (the MC
cannot claim the cycle)
B. Tri064UV+ must implement a standard PCI base address for the UMA frame buffer.
3-2 FUNCTIONAL CHANGES FROM Tri064V+

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
VUMA standard (symmetric and asymmetric x9 and x10)
MA11  MA10  MA9  MAS  MA7  MAS  MAS  MA4  MA3  MA2  MA1  MAO
| Row  |     |     | A20  A19  | A1B  | A17  | A16  | A15  A14  | A13  | A12  |
| ---- | --- | --- | --------- | ---- | ---- | ---- | --------- | ---- | ---- |
| Col  |     |     | A11  A10  | A9   | AB   | A7   | A6  A5    | A4   | A3   |
VUMA (asymmetric xS)
MA11  MA10  MA9  MAS  MA7  MAS  MAS  MA4  MA3  MA2  MA1  MAO
|      |     |      |           |      |      |      | A14     | A13  |      |
| ---- | --- | ---- | --------- | ---- | ---- | ---- | ------- | ---- | ---- |
| Row  |     | A11  | A20  A19  | A1B  | A17  | A16  | A15     |      | A12  |
| Col  |     |      | A10       | A9   | AB   | A7   | A6  A5  | A4   | A3   |
Alternate A (10x10. 11x10)
MA11  MA10  MA9  MAS  MA7  MAS  MAS  MA4  MA3  MA2  MA1  MAO
| Row  |     |      | A20  A19  | A1B  | A17  | A16  | A15  A14  | A13  | A12  |
| ---- | --- | ---- | --------- | ---- | ---- | ---- | --------- | ---- | ---- |
| Col  |     | A11  | A10       | A9   | AB   | A7   | A6  A5    | A4   | A3   |
Alternate B (11x11)
MA11  MA10  MA9  MAS  MA7  MAS  MAS  MA4  MA3  MA2  MA1  MAO
| Row  |      |     | A20  A19  | A1B  | A17  | A16  | A15  A14  | A13  | A12  |
| ---- | ---- | --- | --------- | ---- | ---- | ---- | --------- | ---- | ---- |
| Col  | A11  |     | A10       | A9   | AB   | A7   | A6  A5    | A4   | A3   |
Alternate C (12xS. 12x10)
MA11  MA10  MA9  MAS  MA7  MAS  MAS  MA4  MA3  MA2  MA1  MAO
| Row  A11  |     |     | A20  A19  | A1B  | A17  | A16  | A15  A14  | A13  | A12  |
| --------- | --- | --- | --------- | ---- | ---- | ---- | --------- | ---- | ---- |
| Col       |     |     | A10       | A9   | A8   | A7   | A6  A5    | A4   | A3   |
Figure 3-3. Address Translation
a given request. there are two types of requests:  not asserted. It also has no meaning when a 2-pin
high priority and normal (i.e .• low priority). A four  arbitration scheme is selected via CRB1_1-0.
pin interface controls this communication:
|     |     |     |     |     | ACLK - | Arbitration Clock provides timing for  |     |     |     |
| --- | --- | --- | --- | --- | ------ | -------------------------------------- | --- | --- | --- |
MREQ - Memory Request indicates to the core  these arbitration signals. all of which are sam
logic that Tri064UV+ wants control of the mem  pled on the rising edge. This is the same clock as
| ory.  |     |     |     |     | the host clock.  |     |     |     |     |
| ----- | --- | --- | --- | --- | ---------------- | --- | --- | --- | --- |
MGNT  - Memory Grant indicates to the
|     |     |     |     |     | 3.3.2  | Arbitration Timing Diagrams  |     |     |     |
| --- | --- | --- | --- | --- | ------ | ---------------------------- | --- | --- | --- |
Tri064UV+ that access to the memory has been
granted.
Tri064UV+ supports several protocols for both
MPR -Memory Priority indicates the priority of a  normal and high priority memory arbitration. The
given request. A high state indicates a high pri  timing diagrams for the VUMA protocols are
ority request. while a low state indicates a normal  presented in this section. The Intel 5MBA proto-
request. This pin has no meaning when MREQ is
FUNCTIONAL CHANGES FROM Tri064V+ 3-3

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporatad
col is also supported. Contact Intel for the speci Figure 3-4 illustrates the basic (low priority)
fications. VUMA-style synchronous arbitration protocol for
a 2-cycle EDO read. This protocol is selected
when CR81_1-0 = OOb.
ACLK
ill
CAS[7:0]
MA[ll:0] ROW ADDRESS
WE
(6)
MD[63:0] DO
RECEIPT OF GRANT DETECTED HERE
"-'-__- + ____- + _____________________
MiiEci (1) -1,(7)
MGNT (3) mcom (8)
Figure 3-4. VUMA-Style Low Priority Arbitration
Notes to Figure 3-4
1. Tri064UV+ asserts MREQ to access memory when necessary, for example a graphics engine
command or as the display FIFO begins to empty.
2. The core logic responds by driving RAS, CAS[7:0] and WE high for at least one clock.
3. The core logic alerts Tri064UV+ that it has granted the bus by asserting MGNT. RAS, ""'C"7A=S7.:[7:-::0'"'"],
and WE float for one clock, after which Trio64UV+ takes over by driving the row address. Note
that the floating signals are held high by internal or external pull-ups.
4. The time between recognition of the grant and assertion of RAS is programmable via CR83_3-2.
5. The RAS to CAS time is programmable (CR583 and CR83_ 4).
6. The time between RAS high and MREQ high is programmable via CR83_'-O. A value of 1 cycle is
shown.
7. One clock after Tri064UV+ has finished its memory accesses, it deasserts MREQ and floats RAS,
CAS[7:0] and WE for one clock. RAS, CAS[7:0] and WE must have been held high for one clock
prior to this time. The MA and MD busses are both tri-stated.
8. The core logic responds by deasserting MGNT one cycle later.
3-4 FUNCTIONAL CHANGES FROM Tri064V+

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Figure 3-5 shows the operation of a high priority Figure 3-6 shows a high priority request using
request using the S3 3-pin arbitration (CR81_1-0 2-pin arbitration (see CR81_1-0).
= 10b).
T1 T2 T3 T4 T5 TO T7 T. 19
"eLK
MREQ~ _______________________________________________ _
\~.tl~)
~ \ J
__- -'_'--_________- J/(2)
Figure 3-5. S3 3-Pin Arbitration
Notes to Figure 3-5
1. Tri064UV+ requests memory control.
2. If the core logic does not respond with MGNT soon enough, causing the display FIFO to hit its
near-empty watermark, Tri064UV+ raises the priority of its request by asserting MPR, and keep
ing it asserted until memory is granted.
3. The core logic asserts MGNT soon thereafter in response to the high priority request. Note that
the request could have been issued as high priority from its onset if necessary. The worst-case
latency for the core logic to respond to a high priority request is defined as 35 ACLKs in the
VUMA specification.
T1 T2 T3 T4 T5 T6 T1 T8 T9
ACLK
\ (2)
Figure 3-6. 2-Pin Arbitration
Notes to Figure 3-6
1. Tri064UV+ requests memory control. The request is low priority.
2. If the core logic does not respond with MGNT soon enough, causing the FIFO to hit its near
empty watermark, Tri064UV+ pulses the MREQ signal. This coverts the request to high priority.
3. The core logic asserts MGNT soon thereafter in response to the high priority request. The worst
case latency for the core logic to respond to a high priority request is defined as 35 ACLKs in
FUNCTIONAL CHANGES FROM Tri064V+ 3-5

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Figure 3-7 shows a situation where the core logic
needs memory control back before Trio64UV+ is
done.
T1 T2 T3 T4 TS T& T7 Ta T9
ACLK
J
MREQ _______________________- -'/(2)
I
MGNT
_________- '(1)
Figure 3-7. Early Withdrawal of the Bus Grant
Notes to Figure 3-7
1. This example begins with Trio64UV+ having memory control. The core logic deasserts MGNT
when it needs memory control (e.g., for DRAM refresh) before Trio64UV+ is done.
2. Trio64UV+ must respond to this request as soon as possible by deasserting MREQ.
The worst-case latency for Trio64UV+ to respond is screen resolution dependent. The worst
case is approximately 80 ACLKs, but this is not guaranteed.
3. After giving up memory control in this way, it is likely that Trio64UV+ will immediately start re
questing again since it presumably has unfinished tasks which need access to memory. MREQ
needs to be deasserted for at least two full clock cycles.
3.4 MIXED VOLTAGE SUPPORT If 5V memories are used with 3.3V core
logic, VDDMEM for Trio64UV+ must be set
to 3.3V and VDDMTOL must be set to 5V.
Trio64UV+ is designed as an OEM selectable
If 3.3V memories are used with 3.3V core
5V/3.3V voltage part in order to interface with
logic, both VDDMEM and VDDMTOL must
forthcoming 3.3V memories and core logic.
be set to 3.3V. With 5V core logic and
Trio64UV+ has two isolated digital power planes
memories, both VDDMEM and VDDMTOL
as described below.
must be set to 5V.
1. All core functions in Trio64UV+ are still 5V,
A single digital ground plane is used.
and are powered by VDDCORE. The LPB is !
also 5V and is powered by VDDLPB. The
PCI subsystem is 5V and is powered by r
VDDSYS.
~t
2. The memory interface unit is powered by
VDDMEM. VDDMEM can be connected to
a 5V or 3.3V source, and all output levels
from this portion of Trio64UV+ will be
driven to the VDDMEM source level. The
affected signals are MD[63:01. MA[11:0],
CAS[7:0], RAS and WE.
3-6 FUNCTIONAL CHANGES FROM Trio64V+

..:.
r
Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
3.5 OPERATING MODES
Tri064UV+ supports two operating modes as
shown in Table 3-1.
Table 3-1. Operating Modes
UMA DRAM Operating
Arbitration Refresh Mode
Owner
Enabled CPU UMAmode
(Note 1)
Disabled Tri064UV+ Test
(Note 2)
Notes
1. UMA Mode is the "normal" operational
mode. This mode is selected when
CR82_ 1-0 = OOb.
2. Test mode is used for validation when
Tri064UV+ operates out of a private mem
ory bank. In addition, UMA arbitration is
turned off, giving Tri064UV+ unlimited ac
cess to memory. This mode also allows
Tri064UV+ to operate as a standalone
Tri064V+ with virtually complete function
ality. This "mode is selected when CR82_1-
0= 11 b.
f
r
J
FUNCTIONAL CHANGES FROM Tri064V+ 3-7

••
r
Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporatad
Section 4: Register Changes from Trio64V +
4.1 REGISTERS CHANGED
Register Bit/s) Description
SRA 6 Reserved (RAS1 eliminated)
SRD 1 0= Reserved (Trio64-compatible VAFC feature connector eliminated)
SR1C 1-0 The VL-Bus selections are eliminated.
CR2E 7-0 New chip ID = 14H
CR2F 7-0 Revision ID = xxH
CR34 4 Reserved (CR3B not used)
CR36 1-0 Reserved -Hardwired to boot in PCI mode
CR36 3-2 MD pin values are not latched into these bits on reset. The default value
is 11 b (fast page mode DRAM operation). 1-cycle EDO operation is not
supported.
CR36 4 Reserved (no VL-Bus)
CR36 7-5 000 = Reserved (4 MBytes not supported)
101 = 1.5 MBytes
111 = 0.5 MBvte
CR37 0 Reserved (no VL-Bus)
CR37 2 Reserved (no VL-Bus)
CR37 3 An MD pin value is not latched into this bit on reset. The default value is
1 (use intemal clocks).
CR37 4 Reserved (no VL-Bus)
CR3B 7-0 Reserved (Replaced byCR85 1-0)
CR40 4 Reserved (no VL-Bus)
CR53 4-3 No VL-Bus power-on default
CR58 1-0 11 = Reserved (no 4-MByte window). For a 0.5 MByte frame buffer, the
linear addressing window size should be set to 1 MByte. For a 1.5
MByte frame buffer, the linear addressing window size should be set to
2 MBytes. In either case, software must not write beyond the size
specified for the frame buffer.
CR58 3 Reserved (no VL-Bus)
CR59,CR5A 15-0 No VL-Bus power-on default. No 4-MBvte window.
CR5D 6 Reserved (CR3B not used)
REGISTER CHANGES FROM Trio64V+ 4-1

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
CR68 1-0 MD pin values are not latched into these bits on reset. The default value
is 11 b (no stretch).
CR68 2 An MD pin value is not latched into this bit on reset. The default value is
1 (3.5 MCLKs).
CR68 3 An MD pin value is not latched into this bit on reset. The default value is
1 (2.5 MCLKs).
CR68 7 Reserved
CR69 4 Reserved (2 MByte maximum memory)
CR6A 5 Reserved (2 MByte maximum memory)
CR6F 0 Reserved (hardwired to select LPB mode).
CR6F 2-1 Reserved (with no strapping, remapping the Serial Port register to an
I/O port is not useful).
CR6F 4-3 MD pin values are not latched into these bits on reset. The default value
is 11 b (no delay).
MM81EC 2-0 Streams FIFO Sizes
000 = Primary Stream = 48 slots; Secondary Stream = 0 slots
001 = Reserved
010= Primary Stream = 32 slots; Secondary Stream = 16 slots
011 = Primary Stream = 24 slots; Secondary Stream = 24 slots
100 = Primary Stream = 16 slots; Secondary Stream = 32 slots
101 = Reserved
110 = Reserved
111 = Primary Stream = 0 slots; Secondary Stream = 48 slots
Each slot holds one quadword.
MM81EC 8-3 Secondary Stream Low Water Mark
Value = Low watermark threshold (expressed in # of free FIFO slots)
This value must be ~ the secondary stream FIFO size specified by the
Streams FIFO size bits and < the secondary stream high watermark.
MM81EC 14-9 Primary Stream Low Watermark
Value = Low watermark threshold (expressed in # of free FIFO slots)
This value must be ~ the primary stream FIFO size specified by the
Streams FIFO size bits and < the primary stream high watermark.
MM81EC 17-15 Unchanged from Tri064V+.
MM81EC 18 This bit must be set to 1 when LPB operation is enabled.
MM81EC 24-19 Secondary Stream High Watermark
Value = High watermark threshold (expressed in # of free FIFO slots)
This value must be ~ the secondary stream FIFO size specified by the
Streams FIFO size bits and ~ the secondary stream low watermark.
MM81EC 30-25 Primary Stream High Watermark
Value = High watermark threshold (expressed in # of free FIFO slots)
This value must be ~ the primary stream FIFO size specified by the
Streams FIFO size bits and ~ the primary stream low watermark.
MM81EC 31 Reserved
4-2 REGISTER CHANGES FROM Trio64V+

fl·
Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
MMFFOO 3-1 001 = Reserved (no video 16 model
all = Reserved (no video 8 in/out model
MMFFOO 31 Reserved (no CL-480 support)
PCI Index 02H 15-0 Device ID = 8814H
PCI Index 08H 7-0 Revision ID = xxH
REGISTER CHANGES FROM Trio64V+ 4-3

••
r
Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated
4.2 NEW REGISTERS
UMA Control 1 Register (CR81)
Read/Write Address: 3?5H, Index 81H
Power-On Default: OOH
7 3 2
R ADDRESS TRANS R R ARB SELECT
Bits 1-0 ARB SELECT -Arbitration Type Select
00 = VUMA 2-pin arbitration
01 = Intel 2-pin arbitration
10 = S3 3-pin arbitration
11 = Reserved
Bits 3-2 Reserved
Bits 6-4 ADDRESS TRANS -Memory Address Translation Scheme Select
000 = VUMA Standard (Row -MA[8:01. Col -MA[8:0])
001 = VUMA Asymmetrical x8 (Row -MA[9:0]. Col -MA[7:0])
010 = Alternate A (Row -MA[8:0], Col -MA[9, 7:0])
011 = Alternate B (Row -MA[8:01. Col -MA[10. 7:0])
100 = Alternate C (Row -MA[11, 8:0], Col -MA[7:0])
101 = Reserved
110 = Reserved
111 = Reserved
Bit 7 Reserved
4-4 REGISTER CHANGES FROM Trio64V+

Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated
UMA Control 2 Register (CR82)
| ReadlWrite  |     | Address: 3?5H, Index 82H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
o
| 7  6      | 5  4                     | 3  2    |          |
| --------- | ------------------------ | ------- | -------- |
| R  R      |                          | R  MCS  | OP MODE  |
| Bits 1-0  | OP MODE -Operating Mode  |         |          |
00 = UMA mode (standard operation)
01 = Reserved
10 = Reserved
11 = Test mode (used for validation when Trio64UV+ operates out of a private
memory bank. In addition, UMA arbitration is turned off, giving Tri064UV+
unlimited access to memory. This mode also allows Tri064UV+ to operate as
a standalone Trio64V+ with virtually complete functionality.)
| Bit 2  | MCS -Memory Clock Select  |     |     |
| ------ | ------------------------- | --- | --- |
o  = Use internal MCLK
1 = Use external ACLK for MCLK
| Bit 3     | Reserved        |     |     |
| --------- | --------------- | --- | --- |
| Bits 5-4  | Reserved = OOb  |     |     |
| Bits 7-6  | Reserved        |     |     |
REGISTER CHANGES FROM Tri064V+ 4-5

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
UMA Control 3 Register (CR831
| Read/Write  | Address: 3?5H, Index 83H  |     |
| ----------- | ------------------------- | --- |
Power-On Default: OOH
| 7                   | 4  3       | 2          |
| ------------------- | ---------- | ---------- |
| R                   | R=O  IRHD  | MREO HOLD  |
| Bits 1-0  MREOHOLD  |            |            |
00 = Raise MREO high (releasing the bus) 3 cycles after the rising edge of RAS
01 = Raise MREO high (releasing the bus) 2 cycles after the rising edge of RAS
10 = Raise MREO high (releasing the bus) 1 cycle after the rising edge of RAS
11 = Raise MREO high (releasing the bus) 0 cycles after the rising edge of RAS
A value of 11b must not be used with VUMA-style arbitration. With VUMA-style arbi
tration, the memory signals are tri-stated on the same clock edge used to drive MREO
high.
| Bits 3-2  IRHD -Initial RAS High Decrease  |     |     |
| ------------------------------------------ | --- | --- |
00 = Decrease RAS high by 0 clocks after MGNT asserted
01 = Decrease RAS high by 1 clock after MGNT asserted
10 = Decrease RAS high by 2 clocks after MGNT asserted
11 = Decrease RAS high by 3 clocks after MGNT asserted
This function is only valid for the first RAS cycle after the memory bus is granted to
Tri064UV+. The reduction is from the RAS high time specified by CR58_7, CR68_3 and
MM81EC_16. However, no matter what settings are programmed, the actual initial
RAS high time will never be reduced to less than 2 clocks.
| Bit 4  Reserved = 0            |     |     |
| ------------------------------ | --- | --- |
| Bit 5  RHI -RAS Hold Increase  |     |     |
0= Delay RAS high by one clock from the last CAS high
1 = RAS driven high on same clock edge as last CAS high
| Bit 6  BH -Bus Hold  |     |     |
| -------------------- | --- | --- |
o = Hold the bus (keep MREO low) until the chipset preempts by raising MGNT high
1 = Release the bus (raise MREO) as soon as Tri064UV+ has completed its memory
access activity
| Bit 7  Reserved  |     |     |
| ---------------- | --- | --- |
4-6 REGISTER CHANGES PROM Tri064V+

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
UMA Control 4 Register (CR84)
| Read/Write  |     | Address: 3?5H, Index 84H  |     |
| ----------- | --- | ------------------------- | --- |
Power-On Default: OOH
| 7   | 5  4  | 3   | 1   |
| --- | ----- | --- | --- |
RAA
| R      | BGO  MeB                     | R   |     |
| ------ | ---------------------------- | --- | --- |
| Bit 0  | Reserved = 0                 |     |     |
| Bit 1  | RAA -ROM Access Arbitration  |     |     |
o = ROM access arbitration not used
1 = ROM access arbitration enabled
Setting this bit causes the memory control unit to check for no memory activity be
fore performing the ROM access. This may delay the ROM access, but may also pre
vent screen flicker during soft resets. This function is only used in test mode.
| Bit 2  | Reserved =0                               |     |     |
| ------ | ----------------------------------------- | --- | --- |
| Bit 3  | Reserved                                  |     |     |
| Bit 4  | MBC -Memory Control Output Buffer Select  |     |     |
0= Memory control (MA[11:01. WE) output buffers are 24 mA
1 = Memory control (MA[11:01. WE) output buffers are 16 mA
When using 3.3V memory interface operation, the drive values are 18 mA for a set
ting of 0 and 12 mA for a setting of 1.
| Bit 5  | BGO -Bus Giveup Override  |     |     |
| ------ | ------------------------- | --- | --- |
o = N value overrides high watermark in deciding when to give up the memory bus
1 = High watermark alone determines when to give up the memory bus
| Bit 6  | AHW -Above High Watermark Request  |     |     |
| ------ | ---------------------------------- | --- | --- |
o
= Bus requests when the FIFO is above its high watermark are allowed
1 = Bus requests when the FIFO is above is high watermark are not made
| Bit 7  | Reserved  |     |     |
| ------ | --------- | --- | --- |
REGISTER CHANGES FROM Tri064V+ 4-7

Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated
UMA Control 5 Register (CR8S)
| ReadMlrite  | Address: 3?5H, Index 85H  |     |
| ----------- | ------------------------- | --- |
Power-On Default: OOH
| 7  6      | 5  4                                           | 1  0   |
| --------- | ---------------------------------------------- | ------ |
| R  R      | R  R                                           | SRDRA  |
| Bits 1-0  | SRDRA -Screen Refresh Data Request Adjustment  |        |
00 = Streams FIFO filling request initiated at earliest time after start of blanking
01 = Streams FIFO filling request initiated 1 character clock later than the time
specified by setting these bits to OOb
10 = Streams FIFO filling request initiated 2 character clocks later than the time
specified by setting these bits to OOb
11 = Streams FIFO filling request initiated 3 character clocks later than the time
specified by setting these bits to OOb
The default setting (OOb) takes into consideration the worst case latency for obtaining
the memory bus once it is requested. If the latency for a given system is less, these
bits can be programmed to allow more time during blanking for other activities.
| Bit 2  | LPBP -LPB Priority  |     |
| ------ | ------------------- | --- |
o = An LPB memory access request is given a high priority
1 = An LPB memory access request is given a low priority
The default (0) setting provides the maximum assurance that all incoming video data
is written to memory.
| Bit 3  | OOPS -Disable DAC Power Saving  |     |
| ------ | ------------------------------- | --- |
0= Enable DAC power saving
1 = Disable DAC power saving
The default (0) setting allows the DACs to be automatically powered down during the
blanking period to reduce power consumption.
| Bits 7-4  | Reserved  |     |
| --------- | --------- | --- |
4-8 REGISTER CHANGES FROM Trio64V+

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
UMA Control 6 Register (CR86)
ReadIWrite Address: 3?5H, Index 86H
Power-On Default: OOH
This register is only effective if automatic DAC power saving is enabled ICR85_3 = 0).
7 6 5 432 o
R DAC POWER UP TIME
Bits 6-0 DAC POWER UP TIME
value = number of character clocks from the start of blanking at which the internal
DACs are powered up
This value must be at least 1 less than the End Horizontal Blank value programmed in
CR5D_3, CR5_7 and CR3_ 4-0. A value of 1 less starts DAC power up 1 character clock
before the end of blanking. A value of 2 less starts DAC power up 2 character clocks
before the end of blanking, etc. When the DACs power up, there is a voltage spike
that affects the RGB outputs if they are active. Powering up the DACs earlier reduces
the power savings but also reduces the chance that the power up voltage spike will af
fect the active display.
Bit 7 Reserved
REGISTER CHANGES FROM Tri064V+ 4-9

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporatad
Section 5: Programming Considerations
5.1 SYSTEM/VIDEO BIOS
INITIALIZATION PROCESS
The flowchart for the BIOS initialization process
is shown in Figure 5-1.
VES NO
USE OEFAUlTFB SIZE
US F E B S C I M ZE O S IID C IO A I L lY L · S u J g : t Z n Z r: S 1f ' X l' ' 1' C II U D U a Z P I A I'l U " LT
SET F8 SIZE TO 0 MB & DISABLE
CALL·ltl:O'D'Zft C~'r S:IU • 0
CALL· DISABLI: IIUIOllY
CALL· UQmr:S'l' cuuarr
KIIlOJt.'r 8I.Z.... .W.. IU LllGAL
PCI BASE REGISTER FOR FB
BASt: ADDRESS MUST BE IN
DEVICE DEPEHDEH1 PC)
cotElGURATION SPACE TO
PREVENT os FROM RELOCATING.
ac IIJST IGNORE MEMORY
WRrrES TO FOOL os r\lTo
BELEYING THERE IS NO RAM IN
THAT REGION, va NOT ALLOW IT TO
ASSIGN SPACE TO OTHER DEVICE.
Figure 5-1. BIOS Initialization Process
PROGRAMMING CONSIDERATIONS 5-1

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
5.2 MODE SETS
Software must ensure that a mode change is as
transparent to the user as possible. This includes
determination of when the UMA frame buffer
size will change and subsequent automatic BIOS
notification.This is illustrated by the flowchart in
Figure 5-2.
Even though Windows 95™ will possibly support
dynamic resolution changes without OS reboot,
the Tri064UV+ architecture may require reboot
for resolution/color changes that alter the UMA
frame buffer size. Reboot is required for a grow
ing UMA frame buffer, but optional for a shrink
ing one (though recovering 'extra' memory for
OS use is highly recommended).
Figure 5·2. Mode Setting
5-2 PROGRAMMING CONSIDERATIONS

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Section 6: Electrical Data
6.1  MAXIMUM RATINGS
Table 6-1.  Absolute Maximum Ratings
| Ambient temperature  | 0° C to 70° C  |     |     |     |     |
| -------------------- | -------------- | --- | --- | --- | --- |
Storage temperature
-40° C to 125° C
| DC Supply VoltaQe                    | -0.5V to 7.0V      |     |     |     |     |
| ------------------------------------ | ------------------ | --- | --- | --- | --- |
| I/O Pin Voltage with respect to Vss  | -O.5V to VDD+0.5V  |     |     |     |     |
6.2  DC SPECIFICATIONS
Note: In all cases below, digital VDD = 3.3 or 5V ± 5% and the operating temperature is 0° C to 70° C.
Table 6-2.  RAMDAC/Clock Synthesizer DC Specifications
| Symbol        | Parameter                   | Min   | Typical  | Max   | Unit  |
| ------------- | --------------------------- | ----- | -------- | ----- | ----- |
| AVDD          | DAC supply voltage          | 4.75  | 5        | 5.25  | V     |
| AVDD (CLOCK)  | PLL supply voltaQe          | 4.75  | 5        | 5.25  | V     |
| VREF          | Internal voltage reference  | 1.10  | 1.235    | 1.35  | V     |
Table 6-3.  RAMDAC Characteristics
|                           |     | Min  | Typical  | Max  | Unit  |
| ------------------------- | --- | ---- | -------- | ---- | ----- |
| Resolution Each DAC       |     |      | 8        |      | bits  |
| LSB Size                  |     |      | 66       |      | JJA   |
| Integral Linearity Error  |     |      |          |      | LSB   |
±1
| Differential Linearity Error  |     |       |       | ± 1   | LSB        |
| ----------------------------- | --- | ----- | ----- | ----- | ---------- |
| Output Full-Scale Current     |     | 15.4  | 17.6  | 19.8  | mA         |
| DAC to DAC Mismatch           |     |       |       | 5%    |            |
| Power Supply Rejection Ratio  |     |       |       | 0.5   | %/ % AVDD  |
| Output Compliance             |     | 0.0   |       | 1.5   | V          |
| Output Capacitance            |     |       |       |       | pF         |
30
| Glitch Impulse  |     |              | 75  |                      | pV-Sec  |
| --------------- | --- | ------------ | --- | -------------------- | ------- |
|                 |     | PRELIMINARY  |     | ELECTRICAL DATA 6-'  |         |

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Digital DC Specifications (VDD = 3.3V/ 5V ± 5%, Operating Temperature 0° C to 70° C)
Table 6·4.
| Symbol  Parameter               | Min (3.3V/5V)       | Max (3.3V/ 5V)  | Unit  |
| ------------------------------- | ------------------- | --------------- | ----- |
| VIL  Input Low VoltaQe          | -0.5                | 0.8/1.0         | V     |
| Inp_ut High Voltage             | 2.0/1.65            |                 | V     |
| VIH                             |                     | VDD +0.5        |       |
| VOL  Output Low Voltage         |                     | Vss + 0.4       | V     |
| VOH  Output High Voltage        | 2.4                 |                 | V     |
| IOL1  Output Low Current        | 3/4 (Notes 1, 5)    |                 | mA    |
| IOHl  Output High Current       | -1.5/-2             |                 | mA    |
| IOL2  Output Low Current        | 6/8 (Notes 2, 5)    |                 | mA    |
| IOH2  Output High Current       | -3/-4               |                 | mA    |
| IOL3  Output Low Current        | 18/24 (Notes 3, 5)  |                 | mA    |
| IOH3  Output High Current       | -9/-12              |                 | mA    |
| IOL4  Output Low Current        | 18/24 (Notes 4, 5)  |                 | mA    |
| IOH4  Output High Current       | -9/-12              |                 | mA    |
| loz  Output Tr i-state Current  |                     | 1               | I!A   |
| CIN  Input Capacitance          |                     | 5               | pF    |
pF
| COUT  Output Capacitance   |     | 5             |     |
| -------------------------- | --- | ------------- | --- |
| Icc  Power Supply Current  |     | 350 (Note 5)  | mA  |
Notes for Table 6·4
1.  lOLl, IOHl for pins LCLK, LD[7:0). MD[63:0)
2.  IOL2, IOH2 for pins ROMEN, INTA, STWR, HSYNC, VSYNC, BLANK, ENFEAT,
AD[31:0), VREQJVRDY, SPCLK, SPD, MREQ, MPR, CAS[7:0)
3.  IOl3, IOH3 for pins WE, MA[11:0). This assumes CR843 = 0 (default).
If CR84_4 = 1, the drive levels for these pins are 12/16 rnA.
4.  IOL4,IoH4 for pins PAR, STOP, DEVSEL, TRDY, RAS
5.  Icc measured for a resolution of 1024x768x8 with a 75 MHz DCLK and a 66 MHz MCLK at 25°C
and 5V.
6.  An output signal multiplexed on one of these pins has the same drive level.
7.  Single value table entries are valid for both 3.3V and 5.V operation.
| 6-2 ELECTRICAL DATA  | PRELIMINARY  |     |     |
| -------------------- | ------------ | --- | --- |

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
6.3  AC SPECIFICATIONS
Note: All AC timings are based on an 80 pF test load.
6.3.1  RAMDAC AC Specifications
Table 6-5.  RAMDAC AC Specifications
| Parameter                  |     |     | Typical  | Max  | Unit  | Notes  |
| -------------------------- | --- | --- | -------- | ---- | ----- | ------ |
| DAC Output Delay           |     |     | 5        |      | ns    | 1      |
| DAC Output Rise/Fall Time  |     |     | 3        |      | ns    | 2      |
| DAC Output Settling Time   |     |     | '5       |      | ns    |        |
| DAC-to-DAC Output Skew     |     |     | 2        | 5    | ns    | 3      |
Notes for Table 6-5
1.  Measured from the 50% point of VCLK to the 50% point of full scale transition
2.  Measured from 10% to 90% full scale
3  With DAC outputs equally loaded
Table 6-6.  RAMDAC Output Specifications
| Description   | lOUT (rnA)    | VOUT(V)       |       | BLANK  |     | Input Data  |
| ------------- | ------------- | ------------- | ----- | ------ | --- | ----------- |
| White         | 17.6 typical  | 0.66 typical  |       | 1      |     | FFH         |
| Data          | Data          |               | Data  | 1      |     | Data        |
| Data (sync)   | Data          |               | Data  | 1      |     | Data        |
| Black         | 0             |               | 0     | 1      |     | OOH         |
| Black (sync)  | 0             |               | 0     | 1      |     | OOH         |
| BLANK         | 0             |               | 0     | 0      |     | Don't Care  |
Note
1.Condition for VOUT is a 75 Ohm doubly terminated load, RSET = 147 Ohms and use of internal VREF.
|     |     | PRELIMINARY  |     |     | ELECTRICAL DATA 6-3  |     |
| --- | --- | ------------ | --- | --- | -------------------- | --- |

Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated
6.3.2  Clock Timing
| -THIGH- | SV CLOCK  | -THIGH- | 3.3V CLOCK  |
| ------- | --------- | ------- | ----------- |
2.4V  2.0V
2.0V ... - .................... -........... .  1.6V ...................................... .
1.SV ..... .. .... -....... --.-_.---.  ----.-............ -..... .  1.3V ....................................................................... .
O.BV ....... -............... -.-..... -.. -....  .-........................  . .. .  1.1V ........................................................................... .
|                     | O.4V  |                     | O.7V  |
| ------------------- | ----- | ------------------- | ----- |
|                     | -T    |                     | -T    |
|                     | LOW-  |                     | LOW-  |
| I+-----Tcyc-----·I  |       | I+-----Tcyc-----·I  |       |
CLJ(TIME
Figure 6-1. Clock Waveform Timing
Table 6-7.  Clock Waveform Timing
| Symbol  Parameter                |     | Min  Max   | Units  Notes  |
| -------------------------------- | --- | ---------- | ------------- |
| Tcyc  SCLK Cycle Time            |     | 30  125    | ns  1         |
| LCLK Cycle Time                  |     | 30  200    | ns            |
| MCLK Cycle Time                  |     | 15  100    | ns            |
| ACLK Cycle Time                  |     | 15  100    | ns            |
| DCLK Cycle Time (VGA Mode)       |     | 25  100    | ns  1         |
| DCLK Cycle Time (Enhanced Mode)  |     | 12.5  100  | ns  1,2       |
| THIGH  SCLK High Time            |     | 12  80     | ns            |
| LCLK High Time                   |     | 12  160    | ns            |
| ACLK High Time                   |     | 6  60      | ns            |
| TLow  SCLK Low Time              |     | 12  80     | ns            |
| LCLK Low Time                    |     | 12  160    | ns            |
6  60
ACLK Low Time  ns
| SCLK Slew Rate  |     | 1  4  | V/ns  3  |
| --------------- | --- | ----- | -------- |
| LCLK Slew Rate  |     | 1  4  | V/ns  3  |
Notes to Table 6-7
1.  fDcLK ~ 1/2 fSCLKto ensure valid writes to the PLLs.
2.  For DCLK rates above 80 MHz, clock doubling is used. The maximum DCLK rate with clock
doubling is 67.5 MHz.
3.  Rise and fali times are specified in terms of the edge rate measured in V/ns. This slew rate
must be met across the minimum peak-to peak portion of the clock waveform.
6-4 ELECTRICAL DATA  PRELIMINARY

,I.
Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
6.3.3  Input/Output Timing
\
| 5VCLOCK  | 1.5V- |     | 3 .. 3VCLOCK  | 1.3V-f- |     |     |     |
| -------- | ----- | --- | ------------- | ------- | --- | --- | --- |
~
|     | +--Tsu-+-T | H-+  |     | +--Tsu-+- |     | T H-+  |     |
| --- | ---------- | ---- | --- | --------- | --- | ------ | --- |
-
1-
| 5VINPUT  | -+. . 1.5V  | 1.5V    | 3 .. 3V INPUT  | 1.3V  |     |     | 1.3V  |
| -------- | ----------- | ------- | -------------- | ----- | --- | --- | ----- |
|          |             | ....,1- |                | -I-   |     | -f- |       |
eLKIN
1-
Figure 6 .. 2. Input Timing
Table 6-8.  SCLK-Referenced Input Timing
PCIBus
| Symbol  | Parameter                                       |     |     |     | Min  |     | Units  |
| ------- | ----------------------------------------------- | --- | --- | --- | ---- | --- | ------ |
| Tsu     | AD[31 :0]' C/BE[3:0], FRAME. IRDY. IDSEL setup  |     |     |     | 7    |     | ns     |
| TH      | AD[31 :0] hold                                  |     |     |     | 1    |     | ns     |
| TH      | C/BE[3:0], FRAME, IRDY, IDSEL hold              |     |     |     | 1    |     | ns     |
| Tsu     | RD[7:0] setu~                                   |     |     |     | 6    |     | ns     |
| TH      | RD[7:0] hold                                    |     |     |     | 1    |     | ns     |
Table 6-9.  LCLK-Referenced Input Timing
Scenic/MX2 Interface
| Symbol  | Parameter      |     |     |     | Min  |     | Units  |
| ------- | -------------- | --- | --- | --- | ---- | --- | ------ |
| Tsu     | LD[7:0] setup  |     |     |     | 10   |     | ns     |
| TH      | LD[7:0] hold   |     |     |     | 9    |     | ns     |
| Tsu     | CREO/CRDY      |     |     |     | 6    |     | ns     |
| TH      | CREO/CRDY      |     |     |     | 8    |     | ns     |
SAA7110 Interface
| Symbol  | Parameter      |     |     |     | Min  |     | Units  |
| ------- | -------------- | --- | --- | --- | ---- | --- | ------ |
| Tsu     | LD[7:0] setup  |     |     |     | 6    |     | ns     |
| TH      | LD[7:0] hold   |     |     |     | 8    |     | ns     |
| Tsu     | HS setup       |     |     |     | 6    |     | ns     |
| TH      | HS hold        |     |     |     | 7    |     | ns     |
6
| Tsu  | VS setup  |     |              |     |     |                         | ns  |
| ---- | --------- | --- | ------------ | --- | --- | ----------------------- | --- |
| TH   | VS hold   |     |              |     | 7   |                         | ns  |
|      |           |     | PRELIMINARY  |     |     | ELECTRICAL DATA 6 .. 5  |     |

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Table 6-10.  MCLK-Referenced Input Timing
| Symbol  | Parameter                                   | Min   | Units  |
| ------- | ------------------------------------------- | ----- | ------ |
| Tsu     | MD[63:0] setup to MCLK high (2-cycle EDO)   | 0     | ns     |
| TH      | MD[63:0] hold from MCLK high (2-cycle EDO)  | 12.5  | ns     |
| Tsu     | MD[63:0] setup to CAS high (fast page)      | 0     | ns     |
| TH      | MD[63:0] hold from CAS high (fast page)     | 15    | ns     |
Note
1.  The timing reference in each of the two cases above is to the event that causes the latching
of the read data. The MCLK used to latch 2-cycle EDO data is an internal signal that cannot be
directly observed. The CAS signals used to latch read data in fast page mode is derived from
the internal MCLK. If the memory subsystem is driven with ACLK (CR82_2 = 1), the same tim
ing relationships and values hold.
Table 6-11.  ACLK-Referenced Input Timing
| Symbol  | Parameter  | Min  | Units  |
| ------- | ---------- | ---- | ------ |
|         | MGNTsetup  | 6    | ns     |
Tsu
| TH  | MGNT hold  | 1   | ns  |
| --- | ---------- | --- | --- |
6-6 ELECTRICAL DATA  PRELIMINARY

~.
| r   |     | Trio64UV+ UMA Graphics/Video Accelerator  |     |     |
| --- | --- | ----------------------------------------- | --- | --- |
S3 Incorporated
| SV CLOCK 1.SV  |     | 3.3V CLOCK 1.3V  |     |     |
| -------------- | --- | ---------------- | --- | --- |
-MAX-
-MAX-
|           | -MIN-         |                    | -MIN-          |       |
| --------- | ------------- | ------------------ | -------------- | ----- |
| SVOUTPUT  | 1.SV ___      | 1.SV  3.3V OUTPUT  | 1.3V __        | 1.3V  |
|           | J '\1\/\/",O- |                    | / \/\/\/.,.,0- |       |
---.Jjt:lClClClCll'---
Figure 6·3. Output Timing
The minimum delay is the minimum time after the clock edge that the valid signal state from the previous
cycle will begin transition to the next state (become invalid).
The maximum delay is the maximum time after the clock edge that the signal state is valid for the next
cycle.
Table 6-12.  SCLK-Referenced Output Timing
PCIBus
| Parameter              |     | Min  Max  | Units  Notes       |     |
| ---------------------- | --- | --------- | ------------------ | --- |
| AD[31 :OJ valid delay  |     | 2  16     | ns  1              |     |
| DEVSEL,PAR             |     | 2  11     | ns  Medium DEVSEL  |     |
| delay                  |     |           | timing used        |     |
| STOP delay             |     | 2  11     | ns                 |     |
TRDYdeiay
|             |     | 2  11  | ns  |     |
| ----------- | --- | ------ | --- | --- |
| INTA delay  |     | 2  11  | ns  |     |
Miscellaneous
| ROMEN delay           |     | 4  10  | ns  |     |
| --------------------- | --- | ------ | --- | --- |
| RA[15:0J valid delay  |     | 5  30  | ns  |     |
Note
1.  Due to the timing for TROY for read cycles, data is not sampled on the clock edge immediately
following its becoming valid. This guarantees the PCI 2.1 specification time of 11 ns.
Table 6-13.  LCLK-Referenced Output Timing
Scenic/MX2 Interface
| Parameter                    |     | Min  Max     | Units  Notes         |     |
| ---------------------------- | --- | ------------ | -------------------- | --- |
| VREQNRDY active delay        |     | 2  11        | ns  7 ns typ         |     |
| LD[7:0] valid delay          |     | 2  15        | ns  8 ns typ         |     |
| LD[7:0] tri-state from LCLK  |     | 7  15        | ns                   |     |
|                              |     | PRELIMINARY  | ELECTRICAL DATA 6-7  |     |

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Table 6-14.  MCLK-Referenced Output Timing
| Parameter              |     | Min  | Max  Units  | Notes  |
| ---------------------- | --- | ---- | ----------- | ------ |
| MD[63:0J valid dela~   |     | 2    | 10          | ns  1  |
| MA[ll :OJ valid delay  |     |      | 8           | ns     |
1.5
| CAS[7:0J active delay    |     | 1    | 5.5  | ns  |
| ------------------------ | --- | ---- | ---- | --- |
| CAS[7:0J inactive delay  |     | 1    | 5.5  | ns  |
| RAS active delay         |     | 1    | 5    | ns  |
| RAS inactive delay       |     | 1    | 6.5  | ns  |
| WE active delay          |     | 1.5  | 4.5  | ns  |
Table 6-15.  ACLK-Referenced Output Timing
| Parameter  |     |     |     | Notes  |
| ---------- | --- | --- | --- | ------ |
MREQ, MPR active delay
Table 6-16.  Feature Connector Timing -Output from Trio64UV+ to Feature Connector
| Symbol               | Parameter                             |              | Min  | Units  Notes  |
| -------------------- | ------------------------------------- | ------------ | ---- | ------------- |
| Tsu                  | PA[7:0J. BLANK setup to VCLK rising   |              | 5    | ns            |
| TH                   | PA[7:0J. BLANK hold from VCLK rising  |              | 5    | ns            |
| 6-8 ELECTRICAL DATA  |                                       | PRELIMINARY  |      |               |

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Table 6-17.  Feature Connector Timing -Outputfrom Feature Connector to Trio64UV+
| Symbol  Parameter                  | Min  Max  | Units  Notes  |
| ---------------------------------- | --------- | ------------- |
| Tsu  PA[7:0]' BLANK setup to VCLK  | 6         | ns  1         |
rising
| TH  PA[7:0], BLANK hold from VCLK  | 6   | ns  1  |
| ---------------------------------- | --- | ------ |
rising
| VCLK             | 25  40  | ns  1  |
| ---------------- | ------- | ------ |
| VCLK duty cycle  | 40  60  | %      |
| VCLK hiqh time   | 10  25  | ns     |
| VCLK low time    | 10  25  | ns     |
| VCLK slew rate   | 1  4    | V/ns   |
Note
,.  Pixel data is clocked into the internal RAMDAC using VCLK for the pass-through feature
connector.
PRELIMINARY  ELECTRICAL DATA 6-9

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporatad

r-~   .
Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
Section 7: Mechanical Data
7.1  THERMAL SPECIFICATIONS
| Parameter  | Min  | Typ  | Max  | Unit  |
| ---------- | ---- | ---- | ---- | ----- |
5
| Thermal Resistance 9JC              |     |     |      | °C/W  |
| ----------------------------------- | --- | --- | ---- | ----- |
| Thermal Resistance 9JA (Still Air)  |     | 24  |      | °C/W  |
| Junction Temperature                |     |     | 125  | °C    |
7.2  MECHANICAL DIMENSIONS
Trio64UV+ comes in a 208-pin PQFP package. The mechanical dimensions are given in Figure 7-1.
MECHANICAL DATA 7-1

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
1+------ 30.60 SQUARE (BASIC) ------+1
28.0 SQUARE (BASIC)
..,
'"
LINEAR DIMENSIONS
ARE IN MILLIMETERS
~ Ij L~.6:~8:1g
REF~
'" -+11.30
~ MECIi:IIN
Figure 7-1. 20S-pin PQFP Mechanical Dimensions
7-2 MECHANICAL DATA

Trio64UV+ UMA Graphics/Video Accelerator
53 Incorporated

Trio64UV+ UMA Graphics/Video Accelerator
S3 Incorporated
S31ncorporated, P.O. Box 58058, Santa Clara, CA 95052-8058 Tel: 408-980-5400, Fax: 408-980-5444
Printed in USA DB024-A

Update
83 Trio64UV + Data Book
S3 Incorporated
S3 Trio64UV+ Data Book Update
1. (page 19-11 of the Tri064V+ data book) The combination of CR66_3 = 1 and CR66_7= 0 is illegal and causes
a system hang.
2. (page 6-8 of the Tri064UV+ data booklet) The maximum active delays for the -MREQ and MPR signals should
be changed from 5 ns to 10 ns.
3. (page 4-6 of the Tri064UV+ data booklet) The setting of CR83_1-0 = 11 is illegal and causes on-screen noise.
4. (pages 20-17 and 20-18 of the "Fri064V+ data book) The power-on default values for the BEE8H, Indices D
and E are given in the data book as DOOOH and EOOOH respectively. These defaults should be given as
"Undefined", with a note that these registers must be initialized appropriately by software before the Graphics
Engine is used.
Because writes to these registers are pipelined (see the explanation in the description of the BEE8H read only
register), the ''working" copy of each register does not get written until a Graphics Engine command is issued
after a write. This is why the default states of the ''working'' registers are undefined immediately after power
up, i.e., no command has been issued to load the reset value. Software must use this two step method to
initialize these registers, paying particular attention to bit 5 of BEE8H, Index E. If this is set incorrectly, the
entire image could be clipped.
© Copyright 1996 53 Incorporated. All rights reserved. If you have received this document from 53 Incorporated in electronic form, you are permitted to make the following copies for
business use related to products of 53 Incorporated: one copy onto your computer for the purpose of on-line viewing, and one printed copy. Wnh respect to all documents, whether received
in hard copy or electronic form, other use, copying or storage. in whole or in part, by any means electronic, mechanical, photocopying or otherwise, is not permitted wnhout the prior written
consent of 53 Incorporated, P.O. Box 58058., Santa Clara CA 95052-8058. 53 and True Acceleration are registered trademarks of 53 Incorporated. The 53 Corporate Logo. 53 on Board,
53 on Board design, S3d design, Vision968, Trio, Tri064. Tri084V+, Trio64UV+, ViRGE, ViRGENX, S3d, Scenic, ScenicJMX2, Scenic Highway, Sonic, Sonic/AD, Aurora64V+, DuoView,
Cooperative Accelerator Architecture, Streams Processor, MIC, Galileo, Native-MPEG, No Compromise Integration, No Compromise Acceleration and Innovations in Acceleration are
trademarks of 53 Incorporated. Other trademarks referenced in this document are owned by their respective companies. The material in this document is for information only and is subject
to change without notice. 53 Incorporated reserves the right to make changes in the product design without reservation and wnhout notice to ns users.
S3lncorporated, P.O. Box 58058., Santa Clara, CA 95052-8058 Printed in USA 5/96
Telephone: 408-980-5400, Fax: 408-980-5444 ER010-B

