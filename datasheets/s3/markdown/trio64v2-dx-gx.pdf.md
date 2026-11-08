Trio64V2/DX & GX Graphics/Video Accelerators
Trio64V2/DX & GX
Graphics/Video
Accelerators
Preliminary
April 1997
S3 Incorporated
P.O. Box 58058
Santa Clara, CA 95052-8058

Trio64V2/DX & GX Graphics/Video Accelerators
NOTATIONAL CONVENTIONS
The following notational conventions are used in this data book:
Signal names are shown in all uppercase letters. For example, XD.
A bar over a signal name indicates an active low signal. For example, OE.
n-m indicates a bit field from bit n to bit m. For example, 7-0 specifies bits 7 through 0, inclusive.
n:m indicates a signal (pin) range from n to m. For example D[7:0] specifies data lines 7 through 0, inclusive
Use of a trailing letter H indicates a hexadecimal number. For example, 7AH is a hexadecimal number.
Use of a trailing letter b indicates a binary number. For example, 010b is a binary number.
When numerical modifiers such as K or M are used, they refer to binary rather than decimal form. Thus, for example, 1 KByte would be
equivalent to 1024, not 1,000 bytes.
NOTICES
© Copyright 1997 S3 Incorporated. All rights reserved. If you have received this document from S3 Incorporated in electronic form, you
are permitted to make the following copies for business use related to products of S3 Incorporated: one copy onto your computer for the
purpose of on-line viewing, and one printed copy. With respect to all documents, whether received in hard copy or electronic form, other
use, copying or storage, in whole or in part, by any means electronic, mechanical, photocopying or otherwise, is not permitted without
the prior written consent of S3 Incorporated, P.O. Box 58058., Santa Clara CA 95052-8058. S3, True Acceleration and ViRGE are registered
trademarks of S3 Incorporated. The S3 Corporate Logo, S3 on Board, S3 on Board design, S3d design, Trio, Trio64V+, Trio64V2/DX,
Trio64V2/GX, Plato, S3d, Scenic, Scenic Highway, Sonic, SonicVibes, S3S, S3FM, InfiniPatch, InfiniRate, Audio Card on a Chip, QuickRamp,
Aurora64V+, DuoView, Streams Processor, Galileo, No Compromise Integration, No Compromise Acceleration and Innovations in
Acceleration are trademarks of S3 Incorporated. Other trademarks referenced in this document are owned by their respective companies.
The material in this document is for information only and is subject to change without notice. S3 Incorporated reserves the right to make
changes in the product design without reservation and without notice to its users.
Additional information may be obtained from:
S3 Incorporated, Literature Department P.O. Box 58058, Santa Clara, CA 95052-8058.
Telephone: 408-588-8000, Fax: 408-980-5444

Trio64V2/DX & GX Graphics/Video Accelerators
Table of Contents
List of Figures  .  .  .  .  .  .  .  .  .  .  .  iv Section 4: Register Changes from
|     |     | the Trio64V+  .  .  .  .  .  .  .  .  .  .  .  . 4-1 |     |     |
| --- | --- | ---------------------------------------------------- | --- | --- |
List of Tables .  .  .  .  .  .  .  .  .  .  .  .  . v 4.1 REGISTERS CHANGED .  .  .  .  .  .  .  4-1
|                         |                       | 4.2 NEW REGISTERS .  .  .  .  .  .  .  .  .  .  |     | 4-6 |
| ----------------------- | --------------------- | ----------------------------------------------- | --- | --- |
| Section 1: Introduction |  .  .  .  .  .  . 1-1 |                                                 |     |     |
1.1 OVERVIEW  .  .  .  .  .  .  .  .  .  .  .  .  .  1-3 Section 5: Electrical Data  .  .  .  .  . 5-1
1.2 S3 Streams Processor  .  .  .  .  .  .  .  1-3 5.1 MAXIMUM RATINGS .  .  .  .  .  .  .  .  5-1
1.3 S3 Scenic Highway .  .  .  .  .  .  .  .  .  1-4 5.2 DC SPECIFICATIONS .  .  .  .  .  .  .  .  5-1
|                                     |     | 5.3 AC SPECIFICATIONS .  .  .  .  .  .  .  .  |     | 5-3 |
| ----------------------------------- | --- | --------------------------------------------- | --- | --- |
| 1.4 CHANGES FROM THE Trio64V+ .  .  |     | 1-4                                           |     |     |
5.3.1 RAMDAC AC Specifications  .  .  5-3
| 1.5 ABOUT THIS DATA BOOKLET .  .  .  |                                      | 1-5                        |                                |     |
| ------------------------------------ | ------------------------------------ | -------------------------- | ------------------------------ | --- |
|                                      |                                      | 5.3.2 Clock Timing         |  .  .  .  .  .  .  .  .  .  .  | 5-4 |
|                                      |                                      | 5.3.3 Input/Output Timing  |  .  .  .  .  .  .              | 5-5 |
| Section 2: Pins                      |  .  .  .  .  .  .  .  .  .  .  . 2-1 |                            |                                |     |
| 2.1 PINOUT DIAGRAMS                  |  .  .  .  .  .  .  .  .              | 2-1                        |                                |     |
|                                      |                                      | Section 6: Mechanical Data |  .  .  .  . 6-1                |     |
| 2.2 PIN DESCRIPTIONS                 |  .  .  .  .  .  .  .  .              | 2-4                        |                                |     |
2.3 PIN LISTS .  .  .  .  .  .  .  .  .  .  .  .  .  .  2-9 6.1 THERMAL SPECIFICATIONS .  .  .  .  6-1
|     |     | 6.2 MECHANICAL DIMENSIONS .  .  .  .  |     | 6-1 |
| --- | --- | ------------------------------------- | --- | --- |
Section 3: Functional Changes from
| the Trio64V+  .  .  .  .  .  .  .  .  .  .  .  . 3-1 |                          |     |     |     |
| ---------------------------------------------------- | ------------------------ | --- | --- | --- |
| 3.1  MEMORY SUPPORT                                  |  .  .  .  .  .  .  .  .  | 3-1 |     |     |
3.1.1 SGRAM Support (Trio64V2/GX
| Only)                                          |  .  .  .  .  .  .  .  .  .  .  .  .  .  .  | 3-1 |     |     |
| ---------------------------------------------- | ------------------------------------------ | --- | --- | --- |
| 3.1.2 DRAM Speed .  .  .  .  .  .  .  .  .  .  |                                            | 3-2 |     |     |
| 3.2  VIDEO DISPLAY ENHANCEMENTS                |                                            | 3-2 |     |     |
| 3.2.1 Decimation                               |  .  .  .  .  .  .  .  .  .  .  .           | 3-2 |     |     |
| 3.2.2 Vertical Filtering                       |  .  .  .  .  .  .  .  .                    | 3-3 |     |     |
3.2.3 Automatic Line/Frame Indicators3-3
| 3.2.4 Odd/Even Frame Detection             |                             |  .  .  3-3 |     |     |
| ------------------------------------------ | --------------------------- | ---------- | --- | --- |
| 3.2.5 FIFO Fetching Enhancements           |                             |  .  3-4    |     |     |
| 3.2.6 Color Keying on Index .  .  .  .  .  |                             | 3-4        |     |     |
| 3.3 COLOR ADJUSTMENTS .  .  .  .  .  .     |                             | 3-5        |     |     |
| 3.4 BLANK PEDESTAL                         |  .  .  .  .  .  .  .  .  .  | 3-6        |     |     |
| 3.5 1-CYCLE LINEAR ADDRESSING .  .         |                             | 3-6        |     |     |
| 3.6 DCLK PLL FREQUENCY                     |  .  .  .  .  .  .           | 3-6        |     |     |
| 3.7 PD DRIVE CURRENT                       |  .  .  .  .  .  .  .  .     | 3-6        |     |     |
| 3.8 PCI SUBSYSTEM ID                       |  .  .  .  .  .  .  .  .     | 3-6        |     |     |
| 3.9 VIDEO 16 LPB INTERFACE .  .  .  .  .   |                             | 3-8        |     |     |
| 3.10 FUTURE COMPATIBILITY                  |  .  .  .  .  .              | 3-8        |     |     |
| 3.11 NAND TREE TESTING                     |  .  .  .  .  .  .  .        | 3-8        |     |     |
| PRELIMINARY                                |                             |            |     | iii |

Trio64V2/DX & GX Graphics/Video Accelerators
List of Figures
| # Title                             |                                       | Page |
| ----------------------------------- | ------------------------------------- | ---- |
| 2-1 Trio64V2/DX Pinout              |  .  .  .  .  .  .  .                  | 2-2  |
| 2-2 Trio64V2/GX Pinout              |  .  .  .  .  .  .  .                  | 2-3  |
| 3-1 2-MByte SGRAM Configuration .   |                                       | 3-2  |
| 3-2 Odd/Even Field Detection        |  .  .  .  .                           | 3-4  |
| 3-3 Video 16 Interface              |  .  .  .  .  .  .  .  .               | 3-7  |
| 5-1 Clock Waveform Timing           |  .  .  .  .  .                        | 5-4  |
| 5-2 Input Timing                    |  .  .  .  .  .  .  .  .  .  .  .      | 5-5  |
| 5-3 Output Timing                   |  .  .  .  .  .  .  .  .  .  .         | 5-7  |
| 5-4 Odd/Even Field Detection Timing |                                       | 5-9  |
| 5-5 Reset Timing                    |  .  .  .  .  .  .  .  .  .  .  . 5-10 |      |
6-1 208-pin PQFP Mechanical
| Dimensions .  .  .  .  .  .  .  .  .  .  .  .  |     | 6-2 |
| ---------------------------------------------- | --- | --- |
iv PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
List of Tables
| # Title                      |                             | Page |
| ---------------------------- | --------------------------- | ---- |
| 2-1 Pin Descriptions         |  .  .  .  .  .  .  .  .  .  | 2-4  |
| 2-2 Alphabetical Pin Listing |  .  .  .  .  .              | 2-9  |
2-3 Numerical Pin Listing .  .  .  .  .  .  . 2-11
| 3-1 NAND Tree Test Order .  .  .  .  .  .  |     | 3-9 |
| ------------------------------------------ | --- | --- |
| 5-1 Absolute Maximum Ratings .  .  .       |     | 5-1 |
5-2 RAMDAC/Clock Synthesizer DC
| Specifications .  .  .  .  .  .  .  .  .  .  .  |                 | 5-1     |
| ----------------------------------------------- | --------------- | ------- |
| 5-3 RAMDAC Characteristics .  .  .  .  .        |                 | 5-1     |
| 5-4 Digital DC Specifications .  .  .  .  .     |                 | 5-2     |
| 5-5 RAMDAC AC Specifications                    |  .  .  .        | 5-3     |
| 5-6 RAMDAC Output Specifications .              |                 | 5-3     |
| 5-7 Clock Waveform Timing                       |  .  .  .  .  .  | 5-4     |
| 5-8 SCLK-Referenced Input Timing                |                 |  .  5-5 |
| 5-9 LCLK-Referenced Input Timing                |                 |  .  5-6 |
| 5-10 MCLK-Referenced Input Timing .             |                 | 5-6     |
| 5-11 SDCLK-Referenced Input Timing              |                 | 5-6     |
| 5-12 SCLK-Referenced Output Timing              |                 | 5-7     |
| 5-13 LCLK-Referenced Output Timing              |                 | 5-8     |
| 5-14 MCLK-Referenced Output Timing              |                 | 5-8     |
| 5-15 SDCLK-Referenced Output Timing             |                 | 5-8     |
5-16 Feature Connector Timing - Output
from Trio64V2 to Feature
| Connector .  .  .  .  .  .  .  .  .  .  .  .  .  |     | 5-9 |
| ------------------------------------------------ | --- | --- |
5-17 Feature Connector Timing - Output
from Feature Connector to
| Trio64V2 .  .  .  .  .  .  .  .  .  .  .  .  .  .  |                                       | 5-9  |
| -------------------------------------------------- | ------------------------------------- | ---- |
| 5-18 Odd/Even Field Detection Timing               |                                       | 5-10 |
| 5-19 Reset Timing                                  |  .  .  .  .  .  .  .  .  .  .  . 5-10 |      |
PRELIMINARY v

Trio64V2/DX & GX Graphics/Video Accelerators

Trio64V2/DX & GX Graphics/Video Accelerators
Section 1: Introduction
High-Performance Integrated Graphics/Video Accelerators
• High-performance 64-bit graphics engine
• Single cycle CPU writes to video memory
• Integrated 24-bit RAMDAC and programmable dual-clock synthesizer with 170 MHz output
pixel rate
• Unique S3 Streams Processor for hardware-assisted video playback
• S3 Scenic Highway for direct interface to live video and MPEG-1 peripherals
• Trio64V2/DX(cid:212) is a DRAM-based pin compatible upgrade to the Trio64V+(cid:212)
• Trio64V2/GX(cid:212) is a higher performance SGRAM/DRAM-based chip with a pinout optimized
for synchronous operation
S3 Streams Processor Features
• On-the-fly stretching and blending of primary RGB stream and RGB or YUV (video) secon-
dary stream
• Horizontal and vertical interpolation for smooth upscaling
• Improved secondary stream decimation
• Each stream can have different color depths
• YUV data is color space converted
• Contrast, saturation and brightness controls
Advanced Playback Capabilities
• High-quality hardware-assisted video playback (up to 1024x768x16 bits/pixel)
• Support for Indeo(cid:212) , Cinepak(cid:212) , and software-accelerated MPEG-1 video playback
Game and Presentation Effects.
• Hardware double-buffering support for high-quality tear-free playback
• 2-D scrolling and sprite plane support
• Color and chroma keying for overlaying of graphics onto video and video onto graphics
• Arithmetic blending of two pixel streams for fade-in/fade-out transition effects
PRELIMINARY INTRODUCTION 1-1

Trio64V2/DX & GX Graphics/Video Accelerators
S3 Scenic Highway Interface
• Industry standard video digitizers
• MPEG-1 audio/video decoders
S3 Trio64V+ Compatibility (DX)
• Pin compatible with fast page/EDO DRAMs
• BIOS and driver backwards compatibility
• Same 208-pin PQFP package
High Non-Interlaced Screen Resolution Support
• 1280x1024x256 colors at 85 Hz refresh
• 1024x768x64K colors at 85 Hz refresh
• 800x600x16.7M colors at 85 Hz refresh
High-Performance Memory Interface
• 64-bit interface
• Supports 1-, 2-, or 4-MByte frame buffer (4 MBytes only with fast page/EDO DRAMs)
• Supports fast page mode DRAM (66 MHz), 1-cycle EDO DRAM (60 MHz - 480 MB/s band-
width), 256Kx32 SGRAM (66 MHz - 528 MB/s bandwidth)
Supports CPUs with Big or Little Endian Byte Ordering
Glueless PCI 2.1 Local Bus Support
Multimedia Support Hooks
• 8-bit bidirectional feature connector
• S3 Scenic Highway
• Serial communications bus (I2C)
Full Software Support
• Drivers for Windows® 3.11, Windows NT(cid:212) , Windows 95(cid:212) , OS/2® 2.1 and 3.0 (Warp(cid:212) ),
SCO® UNIX®
Green PC/Monitor Plug and Play Support
• Full hardware and BIOS support for VESA® Display Power Management Signaling (DPMS)
monitor power savings modes
• DDC monitor communications support
Extensive Static/Dynamic Power Management
1-2 INTRODUCTION PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
1.1 OVERVIEW
The S3® Trio64V2/DX and Trio64V2/GX graphics/video accelerators (hereinafter referred to as the
Trio64V2/DX and Trio64V2/GX respectively), combine high-performance graphics and high-quality
video acceleration features with the capability to directly interface to live video and MPEG-1 peripher-
als. They incorporate an enhanced version of the 64-bit graphics accelerator core and high-performance
170 MHz true-color RAMDAC that are found in S3’s existing Trio64V+ accelerator. Note that the term
Trio64V2(cid:212) graphics/video accelerator (or Trio64V2) is used when the discussion applies equally to the
Trio64V2/DX and Trio64V2/GX.
All display applications that require high-quality video playback (from a CD-ROM or hard drive), or live
video input capability, can take advantage of the new features. The Trio64V2 accelerates/enhances
software MPEG-1/Indeo/Cinepak video playback by providing arbitrary scaling with high-quality linear
interpolation in both the horizontal and vertical dimensions and color space conversion (RGB to YUV).
By performing these tasks in hardware and relieving the CPU of a substantial overhead, the Trio64V2
offers high-quality video playback with window sizes of up to 1024x768x16 bits/pixel at high frame
rates. The Trio64V2 has an S3 Scenic Highway(cid:212) interface that provides a direct interface to MPEG-1
audio/video decoder devices and live video digitizers to attain full-motion video.
1.2 S3 Streams Processor
The S3 Streams Processor(cid:212) allows the mixing of three separate display streams. The primary stream
can be RGB data of any color depth. The secondary stream can be RGB or YUV (video) data of any
color depth. YUV data is color space converted to RGB. The third stream, the hardware cursor, overlays
the other two streams. Horizontal and vertical interpolation allow smooth upscaling of the secondary
stream.
Arithmetic blending of a primary graphics stream and secondary graphics/video enables dramatic
transition effects for game applications. Color and chroma keying allow opaque or transparent overlays
of one stream on the other. Hardware-assisted double buffering of both primary and secondary data
streams is also provided to enable high-quality “tear-free” playback.
The Trio64V2 also enhances game acceleration, with support for a sprite plane where sprites are
actually rendered into a sprite plane memory. Sprites can be overlaid onto the background without
saving and restoring the background.
The Streams Processor is located in the pixel datapath between the display memory and the RAMDAC
that drives the RGB signals to the monitor. One of the key advantages of this architecture is that it
permits processing of pixel streams on the fly at display refresh rates. This eliminates the need to first
write back processed (scaled or color-space-converted) data into the frame buffer before sending it to
the RAMDAC. This saves memory storage and memory bandwidth.
The Streams Processor also enables simultaneous display of graphics and video of different color
depths. For example, it is possible to display 24 bits/pixel-equivalent video on top of an 8-bit graphics
background. This also saves memory bandwidth and storage capacity while permitting higher frame
rates because of reduced bandwidth requirements.
In addition, if an opaque rectangular window of one stream is overlaid onto another background
window of a second stream, it is not necessary to fetch and refresh the hidden pixels. This provides
additional memory bandwidth savings.
PRELIMINARY INTRODUCTION 1-3

Trio64V2/DX & GX Graphics/Video Accelerators
The contrast, saturation and brightness of the video stream can be adjusted. This allows the viewer to
adjust for personal preferences.
1.3 S3 Scenic Highway
The S3 Scenic Highway interface directly connects to standard MPEG-1 audio/video decoders as well
as industry standard video digitizers. This provides easy implementation of MPEG-1 or digital video
daughtercards that directly plug into the Scenic Highway connector or, alternately, ISA cards, where
a ribbon cable is also necessary.
The Streams Processor and Scenic Highway are tightly coupled to provide optimal live video playback.
The hardware automatically switches capture and display buffers without software intervention.
1.4 CHANGES FROM THE Trio64V+
The Trio64V2/DX is a pin-compatible and software-backward-compatible upgrade to the Trio64V+. It
has the same DRAM options as the Trio64V+ and is designed primarily to provide improved video
performance. The Trio64V2/GX has the same functionality as the Trio64V2/DX except that it provides
greater memory bandwidth by using SGRAMs. The Trio64V2/GX pinout is optimized for SGRAMs and
is not compatible with the DX pinout. However, the Trio64V2/GX can be used with fast page or EDO
DRAMs.
The significant enhancements to the Trio64V+ are:
• Vertical filtering is added
• LPB decimation is changed to provide better handling of YUV/YCbCr data in addition to the
Trio64V+ decimation scheme
• New Streams FIFO fetching scheme based on separate N values for the Primary and Secon-
dary Streams and new FIFO fetch start timing
• Video brightness, contrast and saturation adjustment is provided
• Color keying can be based on the index or color value for 8 bpp modes
• SGRAMs are supported at 66 MHz (1 or 2 MBytes)
• Fast page mode operation is supported at 66 MHz and 1-cycle EDO operation is supported at
60 MHz.
• End of line and end of frame indicators automatically generated in LPB Pass-Through mode
• Odd/Even field detection provided for video input
• Blank pedestal RAMDAC support is added
• 1-cycle linear addressing for CPU accesses to video memory
• PCI subsystem ID and subsystem vendor ID supported
• PD output drive programmable between 4 and 8 ma
1-4 INTRODUCTION PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
The following Trio64V+ features are not supported:
• VL-Bus
• CL-480 interface
• Trio64-compatible VAFC
• Trio64-compatible mode
1.5 ABOUT THIS DATA BOOKLET
For the most part, this data booklet describes how the Trio64V2 differs from the Trio64V+. There-
fore, users will also need the Trio64V+ data book. For convenience, the Pins, Electrical Data and Me-
chanical Data sections of this data booklet are complete.
PRELIMINARY INTRODUCTION 1-5

Trio64V2/DX & GX Graphics/Video Accelerators

Trio64V2/DX & GX Graphics/Video Accelerators
Section 2: Pins
2.1 PINOUT DIAGRAMS
The Trio64V2/DX and Trio64V2/GX each comes in a 208-pin PQFP package. The Trio64V2/DX provides
a Trio64V+-compatible pinout for use with fast page/EDO memory and is shown in Figure 2-1. The
pinout for the Trio64V2/GX is optimized for use of SGRAM memory and is shown in Figure 2-2. The
Trio64V2/GX can also be used with fast page/EDO memory.
PRELIMINARY PINS 2-1

3 4 5 6 7 8 9 01 11 21 31 41 51 61 71 81 91 02 12 22 32 42 52 62 72 82 92 03 13 23 33 43 53 63 73 83 93 04 14 24 34 44 54 64 74 84 94 05
159 102
160 101
161 100
162 99
163 98
164 97
165 96 166 95
167 94
168 93
169 92
170 91
171 90
172 89
173 88
174 87
175 86
176 85
177 84
178 83
179 82
180 81
181 80
182 79
183 78
184 77
185 76
186 75
187 74
188 73
189 72 190 71
191 70
192 69
193 68
194 67
195 66
196 65
197 64
198 63
199 62
200 61
201 60
202 59
203 58
204 57
205 56
206 55
451 351 251 151 051 941 841 741 641 541 441 341 241 141 041 931 831 731 631 531 431 331 231 131 031 921 821 721 621 521 421 321 221 121 021 911 811 711 611 511 411 311 211 111 011 901 801 701 XOUT
CLKAVDD1
AVSS
CLKAVDD2
AVSS
VREF
AVSS
AVDD
PDOWN RSET
AVSS
AR
AVDD
AVDD
AG
AB
AVSS
LD4/PA4
LD5/PA5
VSS
NO CONNECT
VDD
NO CONNECT Trio64V2/DX
VDD
NO CONNECT
VDD (Trio64V+-COMPATIBLE
ESYNC
LD6/PA6 CONFIGURATION)
LD8/PA8
LD9/PA9
LD10/PA10
LD11/PA11
ST L W D1 R 2 / / G P O A P 12 1 TOP VIEW
BLANK
VDD
RESET
SCLK
VSS
VCLKI
RESERVED FOR PCI GNT
RESERVED FOR PCI REQ
LD13/PA13
LD14/PA14
LD15/PA15
LD7/PA7
VREQ/VRDY/HS/EVIDEO
CREQ/CRDY/VS/EVCLK
SPCLK
SPD
AD31 AD30
KV2PIN2
NIX
92DA
3AP/3DL
82DA
2AP/2DL
72DA
NEMOR
62DA
ATNI
52DA
0POG/TAEFNE
42DA
CNYSV
3EB/C
CNYSH
LESDI
KLCV/KLCL
SSV
1AP/1DL
32DA
0AP/0DL
22DA
SSV
DDV
74DP
12DA
23DP
02DA
64DP
91DA
33DP
81DA
54DP
71DA
43DP
61DA
44DP
2EB/C
DDV
EMARF
53DP
YDRI
SSV
SSV
34DP
YDRT
63DP
LESVED
24DP
POTS
73DP
RAP
14DP
1EB/C
83DP
51DA
04DP
41DA
93DP
31DA
SSV
21DA
EW
SSV
0EO
11DA
SSV
01DA
36DP
9DA
84DP
8DA
26DP
DDV
94DP
0EB/C
16DP
7DA
05DP
6DA
06DP
5DA
15DP
4DA
SSV
3DA
95DP
2DA
25DP
1DA
85DP
0DA
35DP
SSV
75DP
4SAC
45DP
5SAC
65DP
1EO/1SAR
55DP
6SAC
51AG/51DP
7SAC
Trio64V2/DX & GX Graphics/Video Accelerators
PD0/GA0
PD14/GA14
PD1/GA1
PD13/GA13
PD2/GA2
VSS
PD12/GA12
ANALOG PD3/GA3
SECTION V P D D D 11/GA11
(SEPARATE POWER AND GROUND) PD4/GA4
PD10/GA10
PD5/GA5
PD9/GA9
PD6/GA6
PD8/GA8
PD7/GA7
VSS
CAS0
CAS1
RAS0
CAS2
CAS3
VDD
MA8
MA0
MA7
MA1
MA6
MA2
MA5
MA3
MA4 VSS
PD31
PD16/GD0
PD30
PD17/GD1
PD29
PD18/GD2
PD28
PD19/GD3
VDD
PD27
VSS
PD20/GD4
PD26
PD21/GD5
PD25
PD22/GD6
PD24 PD23/GD7
Figure 2-1. Trio64V2/DX Pinout
2-2 PINS PRELIMINARY

3 4 5 6 7 8 9 01 11 21 31 41 51 61 71 81 91 02 12 22 32 42 52 62 72 82 92 03 13 23 33 43 53 63 73 83 93 04 14 24 34 44 54 64 74 84 94 05
159 102
160 101
161 100
162 99
163 98
164 97
165 96 166 95
167 94
168 93
169 92
170 91
171 90
172 89
173 88
174 87
175 86
176 85
177 84
178 83
179 82
180 81
181 80
182 79 183 78
184 77
185 76
186 75
187 74 188 73
189 72
190 71
191 70
192 69
193 68
194 67
195 66
196 65
197 64
198 63
199 62
200 61
201 60
202 59
203 58
204 57
205 56
206 55
451 351 251 151 051 941 841 741 641 541 441 341 241 141 041 931 831 731 631 531 431 331 231 131 031 921 821 721 621 521 421 321 221 121 021 911 811 711 611 511 411 311 211 111 011 901 801 701 XOUT
CLKAVDD1
AVSS
CLKAVDD2
AVSS
VREF
AVSS
AVDD
PDOWN RSET
AVSS
AR
AVDD
AVDD
AG
AB
AVSS
LD4/PA4
LD5/PA5
VSS
NO CONNECT/CS Trio64V2/GX
VDDPAD
DSF
VDD (SGRAM-OPTIMIZED
MA9
N V O D D C P O A N D N E (5 C V T ) CONFIGURATION)
LD6/PA6
LD8/PA8
LD9/PA9
L L D D 1 1 0 1 / / P P A A 1 1 0 1 TOP VIEW
LD12/PA12
STWR/GOP1
BLANK
VDD
RESET
SCLK
VSS
VCLKI
RESERVED FOR PCI GNT
RESERVED FOR PCI REQ
LD13/PA13
LD14/PA14
LD15/PA15
LD7/PA7
VREQ/VRDY/HREF/EVIDEO&ESYNC
CREQ/CRDY/VS/EVCLK
SPCLK
NO CONNECT
AD31 AD30
KV2PINSR
NIX
92DA
3AP/3DL
82DA
2AP/2DL
72DA
DPS/NEMOR
62DA
ATNI
52DA
0POG/TAEFNE
42DA
CNYSV
3EB/C
CNYSH
LESDI
KLCV/KLCL
SSV
1AP/1DL
32DA
0AP/0DL
22DA
SSV
DDV
74DP
12DA
23DP
02DA
64DP
91DA
33DP
81DA
54DP
71DA
43DP
61DA
44DP
2EB/C
DAPDDV
EMARF
53DP
YDRI
SSV
SSV
34DP
YDRT
63DP
LESVED
24DP
POTS
73DP
RAP
14DP
1EB/C
83DP
51DA
04DP
41DA
93DP
31DA
DAPDDV
21DA
EW
DAPDDV
SACDS/0EO
11DA
SSV
01DA
36DP
9DA
84DP
8DA
26DP
DAPDDV
94DP
0EB/C
16DP
7DA
05DP
6DA
06DP
5DA
15DP
4DA
SSV
3DA
95DP
2DA
25DP
1DA
85DP
0DA
35DP
SSV
75DP
4SAC/4MQD
45DP
5SAC/5MQD
65DP
1EO/1SAR/SARDS
55DP
6SAC/6MGD
51AG/51DP
7SAC/7MQD
Trio64V2/DX & GX Graphics/Video Accelerators
PD0/GA0
PD14/GA14
PD1/GA1
PD13/GA13
PD2/GA2
VSS
PD12/GA12
ANALOG PD3/GA3
VDDPAD SECTION PD11/GA11
(SEPARATE POWER AND GROUND) PD4/GA4
PD10/GA10
PD5/GA5
PD9/GA9
PD6/GA6
PD8/GA8
PD7/GA7
VSS
CAS0/DQM0
CAS1/DQM1
RAS0/SDCLK
CAS2/DQM2
CAS3/DQM3
VDDPAD (5V)
MA8
MA0 MA7
MA1
MA6
MA2
MA5 MA3
MA4
VSS (SEE NOTE)
PD31
PD16/GD0
PD30
PD17/GD1
PD29
PD18/GD2
PD28
PD19/GD3
VDDCORE
PD27
VSS
PD20/GD4
PD26
PD21/GD5
PD25
PD22/GD6
PD24 PD23/GD7
NOTE: SEE SECTION 3.10 FOR SPECIAL INFORMATION REGARDING PIN 71
Figure 2-2. Trio64V2/GX Pinout
PRELIMINARY PINS 2-3

Trio64V2/DX & GX Graphics/Video Accelerators
2.2 PIN DESCRIPTIONS
The following table provides a brief description of each pin. The following abbreviations are used for
pin types.
I - Input signal
O - Output signal
B - Bidirectional signal
Table 2-1. Pin Descriptions
Symbol Type Description
PCI BUS INTERFACE
Address and Data
AD[31:0] B Multiplexed Address/Data Bus. A bus transaction (cycle) consists of an
address phase followed by one or more data phases.
C/BE[3:0] I Bus Command/Data Byte Enables. These signals carry the bus command
during the address phase and the byte enables during the data phase.
Bus Control
SCLK I PCI System Clock.
INTA O Interrupt Request.
IRDY I Initiator Ready. A bus data phase is completed when both IRDY and
TRDY are asserted on the same cycle.
TRDY O Target Ready. A bus data phase is completed when both IRDY and TRDY
are asserted on the same cycle.
DEVSEL O Device Select. Trio64V2 drives this signal active when it decodes its
address as the target of the current access.
IDSEL I Initialization Device Select. This input is the chip select for PCI
configuration register reads/writes.
RESET I System Reset. Asserting this signal forces the registers and state
machines to a known state.
FRAME I Cycle Frame. This signal is asserted by the bus master to indicate the
beginning of a bus transaction. It is deasserted during the final data phase
of a bus transaction.
PAR O Parity. Trio64V2 asserts this signal to verify even parity during reads.
STOP O Stop. Trio64V2 asserts this signal to indicate a target disconnect or retry.
2-4 PINS PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
Table 2-1. Pin Descriptions (continued)
Symbol Type Description
CLOCK SOURCE +
XIN I Reference Frequency Input. If an external crystal is used, it is connected
between XOUT and this pin. A stable external frequency source can also
be input via this pin. If this is done, the input voltage must be the same
as AVDD. If PD11 is strapped high at power-on, this becomes the DCLK
(dot clock) input, bypassing the internal oscillator. This is normally only
used for test purposes.
XOUT O Crystal Output. If an external 14.318 MHz crystal is used, it is connected
between XIN and this pin. This pin drives the crystal via an internal
oscillator.
DISPLAY MEMORY INTERFACE
Address and Data
MA[9:0] O Memory Address Bus. The memory row and column addresses are
multiplexed on these lines. MA9 is the SGRAM/SDRAM bank select pin
for the Trio64V2/GX.
PD[63:0] B Memory Data Bus Lines.
DRAM Memory Control
RAS[1:0] O Row Address Strobe
CAS[7:0] O Column Address Strobes.
WE O Write Enable.
OE[1:0] O Output Enables.
SGRAM Memory Control (Trio64V2/GX)
SDCLK O SGRAM Clock.
SDRAS O SGRAM Row Address Strobe.
SDCAS O SDRAM Column Address Strobe.
DQM[7:0] O SGRAM Data Input/Output Masks.
CS O SGRAM Chip Select.
DSF O SGRAM Special Function.
WE O Write Enable.
VIDEO INTERFACE
PDOWN I Power Down. Asserting this signal turns off the RGB analog output from
the DACs.
VREF Voltage Reference. This pin is tied to VSS through a 0.1 m F capacitor.
RSET Reference Resistor. This pin is tied to VSS through an external resistor to
control the full-scale current value.
AR O Analog Red. Analog red output to the monitor.
AG O Analog Green. Analog green output to the monitor.
AB O Analog Blue. Analog blue signal to the monitor.
PRELIMINARY PINS 2-5

Trio64V2/DX & GX Graphics/Video Accelerators
Table 2-1. Pin Descriptions (continued)
Symbol Type Description
ENFEAT O Enable Feature Connector. Setting SRD_0 to 1 drives this signal low
when SR1C_1-0 are 00b. This also enables all feature connector
operations.
BLANK B Video Blank.
ESYNC I External SYNC. When ESYNC is driven low, HSYNC, VSYNC and BLANK
become inputs. When ESYNC is high, HSYNC, VSYNC and BLANK
become outputs. For the Trio64V2/GX, this signal is the same as EVIDEO.
EVIDEO I External Video. When this input is high, PA[15:0] are outputs to the
feature connector. For the Trio64V2/GX, this signal is the same as ESYNC.
EVCLK I External VCLK. When this input is asserted low, VCLK is an input to the
internal RAMDAC. When this input is high, VCLK is output to the feature
connector.
VCLK B Video/Pixel Clock. When EVCLK is high, this signal is an output to the
feature connector. When EVCLK is low, this becomes an input used only
for test purposes.
VCLKI I VCLK Input. The VCLKI function is enabled when LPB VAFC (16-bit)
feature connector operation is enabled. Setting bit 1 of SRB to 1 causes
VCLKI to be used to clock in feature connector pixel data to the internal
RAMDAC.
HSYNC B Horizontal Sync. When ESYNC is high, this is the horizontal sync output.
When ESYNC is low, this is an input from the feature connector.
VSYNC B Vertical Sync. When ESYNC is high, this is the vertical sync output. When
ESYNC is low, this is an input from the feature connector.
PA[15:0] B Pixel Address Lines [15:0]. These are the data lines when feature
connector operation is enabled. When EVIDEO is high, PA signals are
outputs to the feature connector.
2-6 PINS PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
Table 2-1. Pin Descriptions (Continued)
Symbol Type Description
MISCELLANEOUS FUNCTIONS
General Data, I/O and Serial Ports
GA[15:0] O ROM Address Bus. These signals provide the address for BIOS ROM
reads. They are multiplexed with MD signals. Programmers must ensure
that the memory bus is inactive when reading the ROM.
GD[7:0] I ROM Data Bus. These signals carry data for BIOS ROM reads. They are
multiplexed with MD signals. Programmers must ensure that the
memory bus is inactive when reading the ROM.
ROMEN O ROM Enable. This signal provides the chip output enable input for BIOS
ROM reads.
GOP[1:0] O General Output Port Bits 1-0. If SR1C_1 is set to 1, the value of CR5C_0
is output on pin 151 (GOP0) and the value of CR5C_1 is output on pin 190
(GOP1).
STWR O Strobe Write. If SR1C_1 is cleared to 0, this signal is asserted whenever a
write is made to CR5C. It is used to enable a General Output Port latch.
SPCLK I/O Serial Port Clock. This is the clock for serial data transfer, either for I2C or
DDC2 monitor data communications. As an output, it is programmed via
MMFF20_0. As an input, its status is read via MMFF20_2. In either case
the serial port must be enabled by setting MMFF20_4 to 1.
SPD I/O Serial Port Data. This is the data signal for serial data transfer, either for
I2C or DDC2 monitor data communications. As an output, it is
programmed via MMFF20_1. As an input, its status is read via
MMFF20_3. In either case the serial port must be enabled by setting
MMFF20_4 to 1.
SCENIC HIGHWAY
Bidirectional Mode
LD[7:0] I/O LPB Data. This is the Scenic Highway data bus.
LCLK I LPB Clock. This clock controls transactions between the Trio64V2 and
Scenic Highway peripherals
VREQ/VRDY O Video Request/Ready.
CREQ/CRDY I Decoder Request/Ready.
Video 8 and 16 Modes
LD[15:0] I LPB Data Bus [15:0]. Video data input. LD[7:0] are used in Video 8 mode.
HREF I HSYNC input signaling the transition from one line to the next.
VS I VSYNC input signaling the transition from one frame to the next.
PRELIMINARY PINS 2-7

Trio64V2/DX & GX Graphics/Video Accelerators
Table 2-1. Pin Descriptions (Continued)
Symbol Type Description
POWER AND GROUND
VDD I Digital power (5V)
VDDPAD I Pad digital power (5V for Trio64V2/DX and Trio64V2/GX using EDO
meomory. 3.3V for Trio64V2/GX using synchronous memory.)
AVDD I Analog power supply (RAMDAC).
CLKAVDD[1:2] I Analog power supply (clock synthesizer, 1 = DCLK, 2 = MCLK)
VSS I Digital ground
AVSS I Analog ground
2-8 PINS PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
2.3 PIN LISTS
Table 2-2 lists all pins alphabetically. Table 2-3 lists all pins in numerical order.
Table 2-2. Alphabetical Pin Listing
Name PIN(S)
AB 172
AD[31:16] 207, 208, 1, 2, 3, 4, 5, 6, 10, 11, 13, 14, 15,16, 17, 18
AD[15:0] 28, 29, 30, 31, 33, 34, 35, 36, 39, 40, 41, 42, 43, 44, 45, 46
AG 171
AR 168
AVDD 164, 169, 170
AVSS 159, 161, 163, 167, 173
BLANK 191
CAS[7:0] 52, 51, 49, 48, 82, 83, 85, 86
C/BE[3:0] 7, 19, 27, 38
CLKAVDD[1:2] 158, 160
CREQ/CRDY 204
CS 177 (GX)
DEVSEL 24
DQM[7:0] 52, 51, 49, 48, 82, 83, 85, 86 (GX)
DSF 179 (GX)
ENFEAT 151
ESYNC 203
EVCLK 204
EVIDEO 203
FRAME 20
GA[15:0] 105, 103, 101, 98, 95, 93, 91, 89, 88, 90, 92, 94, 97, 100, 102, 104
GD[7:0] 53, 55, 57, 59, 63, 65, 67, 69
GOP[1:0] 190, 151
HREF 203
HSYNC 149
IDSEL 8
INTA 152
IRDY 21
LCLK 148
LD[15:0] 201, 200, 199, 189, 188, 187, 186, 185, 202, 184, 175, 174, 155, 154, 147, 146
MA[9:0] 181, 80, 78, 76, 74, 72, 73, 75, 77, 79 (MA9 only on GX)
NO CONNECT 183, 206
OE[1:0] 50, 124
PA[15:0] 201, 200, 199, 189, 188, 187, 186, 185, 202, 184, 175, 174, 155, 154, 147, 146
PAR 26
PRELIMINARY PINS 2-9

Trio64V2/DX & GX Graphics/Video Accelerators
Table 2-2. Alphabetical Pin Listing (Continued)
Name PIN(S)
PD[63:48] 122, 120, 118, 116, 113, 111, 109, 107, 106, 108, 110, 112, 115, 117, 119, 121
PD[47:32] 144, 142, 140, 138, 134, 132, 130, 128, 127, 129, 131, 133, 136, 139, 141, 143
PD[31:16] 70, 68, 66, 64, 61, 58, 56, 54, 53, 55, 57, 59, 63, 65, 67, 69
PD[15:0] 105, 103, 101, 98, 95, 93, 91, 89, 88, 90, 92, 94, 97, 100, 102, 104
PDOWN 165
RAS[1:0] 50, 84
RESERVED 197, 198
RESET 193
ROMEN 153
RSET 166
SCLK 194
SDCAS 124 (GX)
SDCLK 84 (GX)
SDRAS 50 (GX)
SPCLK 205
SPD 206 (DX), 153 (GX)
STOP 25
STWR 190
TRDY 23
VCLK 148
VCLKI 196
VDD 12, 62, 180, 192
VDDPAD 32 (GX), 37, 96, 126 (GX), 137, 178
VDDPAD (5V) 81, 182
VREQ/VRDY 203
VREF 162
VS 204
VSS 9, 22, 32 (DX), 47, 60, 71, 87, 99, 114, 123, 126 (DX), 135,
145, 176, 195
VSYNC 150
WE 125
XIN 156
XOUT 157
2-10 PINS PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
Table 2-3. Numerical Pin Listing
| Number | Pin                  | Number | Pin            |
| ------ | -------------------- | ------ | -------------- |
| 1      | AD29                 | 43     | AD3            |
| 2      | AD28                 | 44     | AD2            |
| 3      | AD27                 | 45     | AD1            |
| 4      | AD26                 | 46     | AD0            |
| 5      | AD25                 | 47     | VSS            |
| 6      | AD24                 | 48     | CAS4/DQM4      |
| 7      | C/BE3                | 49     | CAS5/DQM5      |
| 8      | IDSEL                | 50     | RAS1/OE1/SDRAS |
| 9      | VSS                  | 51     | CAS6/DQM6      |
| 10     | AD23                 | 52     | CAS7/DQM7      |
| 11     | AD22                 | 53     | PD23/GD7       |
| 12     | VDD                  | 54     | PD24           |
| 13     | AD21                 | 55     | PD22/GD6       |
| 14     | AD20                 | 56     | PD25           |
| 15     | AD19                 | 57     | PD21/GD5       |
| 16     | AD18                 | 58     | PD26           |
| 17     | AD17                 | 59     | PD20/GD4       |
| 18     | AD16                 | 60     | VSS            |
| 19     | C/BE2                | 61     | PD27           |
| 20     | FRAME                | 62     | VDD            |
| 21     | IRDY                 | 63     | PD19/GD3       |
| 22     | VSS                  | 64     | PD28           |
| 23     | TRDY                 | 65     | PD18/GD2       |
| 24     | DEVSEL               | 66     | PD29           |
| 25     | STOP                 | 67     | PD17/GD1       |
| 26     | PAR                  | 68     | PD30           |
| 27     | C/BE1                | 69     | PD16/GD0       |
| 28     | AD15                 | 70     | PD31           |
| 29     | AD14                 | 71     | VSS            |
| 30     | AD13                 | 72     | MA4            |
| 31     | AD12                 | 73     | MA3            |
| 32     | VSS//VDDPAD (Note 1) | 74     | MA5            |
| 33     | AD11                 | 75     | MA2            |
| 34     | AD10                 | 76     | MA6            |
| 35     | AD9                  | 77     | MA1            |
| 36     | AD8                  | 78     | MA7            |
| 37     | VDDPAD               | 79     | MA0            |
| 38     | C/BE0                | 80     | MA8            |
| 39     | AD7                  | 81     | VDDPAD (5V)    |
| 40     | AD6                  | 82     | CAS3/DQM3      |
| 41     | AD5                  | 83     | CAS2/DQM2      |
| 42     | AD4                  | 84     | RAS0/SDCLK     |
PRELIMINARY PINS   2-11

Trio64V2/DX & GX Graphics/Video Accelerators
Table 2-3.  Numerical Pin Listing (Continued)
| Number | Pin                  | Number | Pin                       |
| ------ | -------------------- | ------ | ------------------------- |
| 85     | CAS1/DQM1            | 127    | PD39                      |
| 86     | CAS0/DQM0            | 128    | PD40                      |
| 87     | VSS                  | 129    | PD38                      |
| 88     | PD7/GA7              | 130    | PD41                      |
| 89     | PD8/GA8              | 131    | PD37                      |
| 90     | PD6/GA6              | 132    | PD42                      |
| 91     | PD9/GA9              | 133    | PD36                      |
| 92     | PD5/GA5              | 134    | PD43                      |
| 93     | PD10/GA10            | 135    | VSS                       |
| 94     | PD4/GA4              | 136    | PD35                      |
| 95     | PD11/GA11            | 137    | VDDPAD                    |
| 96     | VDDPAD               | 138    | PD44                      |
| 97     | PD3/GA3              | 139    | PD34                      |
| 98     | PD12/GA12            | 140    | PD45                      |
| 99     | VSS                  | 141    | PD33                      |
| 100    | PD2/GA2              | 142    | PD46                      |
| 101    | PD13/GA13            | 143    | PD32                      |
| 102    | PD1/GA1              | 144    | PD47                      |
| 103    | PD14/GA14            | 145    | VSS                       |
| 104    | PD0/GA0              | 146    | LD0/PA0                   |
| 105    | PD15/GA15            | 147    | LD1/PA1                   |
| 106    | PD55                 | 148    | LCLK/VCLK                 |
| 107    | PD56                 | 149    | HSYNC                     |
| 108    | PD54                 | 150    | VSYNC                     |
| 109    | PD57                 | 151    | ENFEAT/GOP0               |
| 110    | PD53                 | 152    | INTA                      |
| 111    | PD58                 | 153    | ROMEN//ROMEN/SPD (Note 1) |
| 112    | PD52                 | 154    | LD2/PA2                   |
| 113    | PD59                 | 155    | LD3/PA3                   |
| 114    | VSS                  | 156    | XIN                       |
| 115    | PD51                 | 157    | XOUT                      |
| 116    | PD60                 | 158    | CLKAVDD1                  |
| 117    | PD50                 | 159    | AVSS                      |
| 118    | PD61                 | 160    | CLKAVDD2                  |
| 119    | PD49                 | 161    | AVSS                      |
| 120    | PD62                 | 162    | VREF                      |
| 121    | PD48                 | 163    | AVSS                      |
| 122    | PD63                 | 164    | AVDD                      |
| 123    | VSS                  | 165    | PDOWN                     |
| 124    | OE0/SDCAS            | 166    | RSET                      |
| 125    | WE                   | 167    | AVSS                      |
| 126    | VSS//VDDPAD (Note 1) | 168    | AR                        |
2-12   PINS PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
Table 2-3.  Numerical Pin Listing (Continued)
| Number | Pin                      | Number | Pin                  |
| ------ | ------------------------ | ------ | -------------------- |
| 169    | AVDD                     | 189    | LD12/PA12            |
| 170    | AVDD                     | 190    | STWR/GOP1            |
| 171    | AG                       | 191    | BLANK                |
| 172    | AB                       | 192    | VDD                  |
| 173    | AVSS                     | 193    | RESET                |
| 174    | LD4/PA4                  | 194    | SCLK                 |
| 175    | LD5/PA5                  | 195    | VSS                  |
| 176    | VSS                      | 196    | VCLKI                |
| 177    | NO CONNECT//CS (Note 1)  | 197    | Reserved for PCI GNT |
| 178    | VDDPAD                   | 198    | Reserved for PCI REQ |
| 179    | NO CONNECT//DSF (Note 1) | 199    | LD13/PA13            |
| 180    | VDD                      | 200    | LD14/PA14            |
| 181    | NO CONNECT//MA9 (Note 1) | 201    | LD15/PA15            |
| 182    | VDD (5V for GX)          | 202    | LD7/PA7              |
183 ESYNC//NO CONNECT (Note 1) 203 VREQ/VRDY/HREF/EVIDEO&ESYNC
| 184 | LD6/PA6   | 204 | CREQ/CRDY/VS/EVCLK       |
| --- | --------- | --- | ------------------------ |
| 185 | LD8/PA8   | 205 | SPCLK                    |
| 186 | LD9/PA9   | 206 | SPD//NO CONNECT (Note 1) |
| 187 | LD10/PA10 | 207 | AD31                     |
| 188 | LD11/PA11 | 208 | AD30                     |
Note
1. Listings with two entries separated by // are for the Trio64V2/DX and Trio64V2/GX
configurations respectively.
PRELIMINARY PINS   2-13

Trio64V2/DX & GX Graphics/Video Accelerators

Trio64V2/DX & GX Graphics/Video Accelerators
Section 3: Functional Changes from the Trio64V+
3.1 MEMORY SUPPORT
The Trio64V2/GX adds support for SGRAMs operating at 66 MHz. Fast page or EDO DRAMs are still
supported as an alternative and can be operated at a higher MCLK speed than allowed by the Trio64V+.
This is true for both the Trio64V2/DX and Trio64V2/GX.
3.1.1 SGRAM Support (Trio64V2/GX Only)
SGRAM support is enabled via power-on strapping bits CR36_32 = 01b. SGRAMs require that their
operating mode be programmed after reset. The following register bits are added to support this
requirement.
CR88
Bits 4-3 SGRAM CAS Latency
00 = Reserved
01 = Reserved (for 1 MCLK)
10 = 3 MCLKs
11 = 2 MCLKs
Bit 5 SGRAM Set Mode Register
Bit 6 Disable RAM Refresh
During each power-on cycle, the BIOS must first disable RAM refresh by setting CR88_6 to 1. After
the CAS latency is programmed, CR88_5 is programmed to 1 to generate a mode programming cycle.
This bit is automatically cleared to 0 after the programming cycle. DRAM refresh is then enabled by
clearing CR88_6 to 0.
Special SGRAM features such as block write and write-per-bit are not supported. 4-MByte
SGRAM/SDRAM configuration are not supported (only 1 or 2 MBytes). A 2-MByte SGRAM configuration
is shown in Figure 3-1.
PRELIMINARY FUNCTIONAL CHANGES 3-1

Trio64V2/DX & GX Graphics/Video Accelerators
PD[63:0]
256Kx32 256Kx32
SDCAS PD[31:0] SDCAS PD[63:32]
SDRAS SDRAS
DQM0 DQM4
DQM1 DQM5
DQM2 DQM6
DQM3 DQM7
WE WE
Trio64V2/GX
CS CS
SDCLK SDCLK
DSF DSF
MA[9:0]
SGRAM CONTROL
2MBSGRAM
1ST MBYTE 2ND MBYTE
Figure 3-1. 2-MByte SGRAM Configuration
3.1.2 DRAM Speed
The maximum MCLK rate is 66 MHz for fast page operation and 60 MHz for 1-cycle EDO operation.
3.2 VIDEO DISPLAY ENHANCEMENTS
The Trio64V2 provides a number of enhancements for displaying video in a secondary window.
3.2.1 Decimation
In the horizontal decimation scheme presently implemented in the Trio64V+, each bit in the horizontal
decimation mask register corresponds to a byte in Video 8 Mode, 2 bytes in Video 16 mode and 4 bytes
in pass-through mode. Any type of data could be decimated. This type of decimation is supported by
the Trio64V2 when MMFF00_7 = 0. If MMFF00_7 is set to 1, an alternate decimation scheme is used
that is better suited for YUV/YCbCr data.
The new decimation scheme works as follows:
1. Only YUV 4:2:2 data should be decimated.
2. All LPB modes (Video 8, Video 16, pass-through) use the same decimation scheme.
3. The LPB Horizontal Decimation Control register (MMFF2C) is programmed, with each bit corre-
sponding to the Y of a YU or YV pair. A 0 specifies that the corresponding Y (luma) be kept
and a 1 specifies that the corresponding Y be dropped.
4. The number of 0’s programmed in MMFF2C must be 0 or a multiple of 4.
3-2 FUNCTIONAL CHANGES PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
5. Kept Y’s are paired sequentially, with each Y pair being assigned the UV pair associated with the
first Y in the pair.
The starting conditions for decimation are the same as for the Trio64V+.
3.2.2 Vertical Filtering
Vertical filtering significantly improves the appearance of stretched video windows. Use of vertical
filtering of video data requires that CR23 and CR26 be programmed per the CR26 register description
in Section 4 and that the following new register bit be set.
MM81E8_15
0 = Line replication used
1 = Vertical filtering (interpolation) enabled
In general, there are no restrictions on the use of vertical filtering. However, in the following cases:
1 MByte, 40 MHz 1-cycle EDO @ 75 Hz
1 MByte, 66 MHz fast page @ 60 Hz
vertical filtering should not be enabled unless the horizontal stretch factor is 2 or greater.
With vertical filtering enabled, memory bandwidth savings mode can be enabled by setting
MM81E8_14 to 1. This reduces line fetches. In addition, the UV/CbCr color components can be dropped
by setting CR87_0 to 1. This is effective when both vertical filtering is enabled (MM81E8_15 = 1) and
memory bandwidth savings mode is enabled (MM81E8_14 = 1). When vertical filtering is off, bandwidth
savings can be achieved by setting MM81E8_13 = 1.
3.2.3 Automatic Line/Frame Indicators
In LPB pass-through mode, there may be no indication of end of line (HSYNC) and end of frame
(VSYNC). The Trio64V2 provides a method of automatically generating these indicators via the
following bit.
MMFF00_14 - Auto Sync Generation
0 = No auto sync generation
1 = HSYNC and VSYNC automatically generated based on the horizontal count programmed in
MMFF28_11-0 and the vertical count programmed in MMFF28_24-16. When the horizontal count value
is reached, the stride (MMFF34_11-0) is added to the address to start the next line.
3.2.4 Odd/Even Frame Detection
The Trio64V2 provides automatic detection of odd/even frame when operating in the LPB Video 8 or
Video 16 mode. This is enabled via the following bit:
MMFF00_30 - Odd/Even Field Detection Enable
0 = Odd/Even field detection disabled
1 = Odd/Even field detection enabled
PRELIMINARY FUNCTIONAL CHANGES 3-3

Trio64V2/DX & GX Graphics/Video Accelerators
The detection technique is based on the protocol specified by the SAA7110, as follows:
Each time the vertical sync input (VS) transitions from high to low, the state of the horizontal sync input
(HREF) is latched. A logic 0 for HREF indicates the odd/top field is being sent. A logic 1 indicates the
even/bottom field is being sent. This is shown in Figure 3-2.
ODD/TOP FIELD EVEN/BOTTOM FIELD
VS VS
HREF HREF
Figure 3-2. Odd/Even Field Detection
This value is EXCLUSIVE-ORed with the value of MMFF00_29 to allow polarity inversion, and the result
(status) is latched in MMFF00_28.
For video input devices that do not provide sync signals in conformance with the SAA7110 protocol,
alternate signals must be provided that meet the timing requirements given the AC timings in Section
5.
3.2.5 FIFO Fetching Enhancements
Several enhancements have been added to optimize the use of memory bandwidth for display FIFO
fetching when a secondary video window is displayed.
In full Streams Processor mode (CR67_3-2 = 11b), display FIFO fetching automatically begins as soon
as possible after the start of blanking. This starting position can be delayed by number of character
clocks programmed in CR85_2-0. In other Streams modes, FIFO fetch start is controlled as for the
Trio64V+ via CR3B.
A separate register (CR72_7-0) is provided for a Secondary Stream N value. This is used to ensure that
adequate secondary stream pixel data is fetched each line to prevent display problems.
L parameters, which control the length of FIFO fetches, have been added for both the primary and
secondary stream FIFOs. See the descriptions of CR90, CR91, CR92 and CR93. Use of these registers
eliminates unnecessary FIFO fetches.
3.2.6 Color Keying on Index
The following register bit adds flexibility to the color keying capability for VGA and 8-bit enhanced
modes.
3-4 FUNCTIONAL CHANGES PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
MM8184_29
0 = Color keying based on color value for VGA and 8-bit enhanced modes
1 = Color keying based on comparison of color index value with the value specified in MM8184_7-0
3.3 COLOR ADJUSTMENTS
The following new register controls color adjustments. Color adjustment should be enabled only for
YUV/YCbCr secondary stream formats. They must be disabled (MM819C_15 = 0 and MM819C_31 = 0)
for secondary stream RGB formats.
MM819C - Color Adjustment Register
Bits 7-0 Brightness Control
Value = SBBBBBBB
where S is the sign bit (1 = negative) and BBBBBBB is the brightness adjustment factor. The larger the
number, the greater the brightness. The programmed value is multiplied by 2 by the hardware. The
value is in 2’s complement format.
Bits 12-8 Contrast Control
Value = C.CCCC
Where C.CCCC is the contrast adjustment, which can vary from 0 to 1.9375. The value is in 2’s
complement format.
Bit 15 Brightness and Contrast Enable
0 = Brightness and contrast control disabled
1 = Brightness and contrast control enabled
Bit 20-16 Hue and Saturation Factor 1
Value = SF.FFF
where S is the sign bit (1 = negative) and the F.FFF is the factor [SAT * cos A]. SAT is the saturation,
which can vary from -2 to 1.875 and A is the hue angle, the cosine of which varies from -1 to +1. The
value is in 2’s complement format.
Bits 28-24 Hue and Saturation Factor 2
Value = SF.FFF
where S is the sign bit (1 = negative) and the F.FFF is the factor [SAT * sin A]. SAT is the saturation,
which can vary from -2 to 1.875 and A is the hue angle, the sine of which varies from -1 to +1. The value
is in 2’s complement format.
Bit 31 Hue and Saturation Control Enable
0 = Hue and saturation control disabled
1 = Hue and saturation control enabled
PRELIMINARY FUNCTIONAL CHANGES 3-5

Trio64V2/DX & GX Graphics/Video Accelerators
3.4 BLANK PEDESTAL
BLANK pedestal support is enabled by setting SR1A_5 to 1. This white level output remains at 17.6 mA
(typical) above the black level output. However, the black level output is raised to 1.45 mA (typical)
over the BLANK output level of 0 mA. RAMDAC output using the BLANK pedestal is recommended for
some monitors.
3.5 1-CYCLE LINEAR ADDRESSING
Setting CR87_1 to 1 enables 1-cycle linear addressing of video memory. The memory must be capable
of supporting this mode of operation. The default (CR87_1 = 0 ) is 2-cycle operation if SRA_7 and SR15_7
are set to 1.
3.6 DCLK PLL FREQUENCY
The maximum DCLK PLL frequency has been increased to 340 MHz. The DCLK PLL R divider field has
been increased to 3 bits by adding SR12_7. When SR12_7-5 = 100b, the frequency divider is 16.
3.7 PD DRIVE CURRENT
The drive current of PD[63:0] is programmable via CR80_4. The default value of 0 selects 8 ma drive
current; setting this bit to 1 selects 4 ma drive current.
3.8 PCI SUBSYSTEM ID
The Subsystem ID and Subsystem Vendor ID are located in a 32-bit read only register at PCI
Configuration Space Index 2C. These registers reflect the content of 4 new read/write CR registers as
follows:
Register CR Space PCI Configuration Space
Subsystem Vendor ID Low Byte CR81 Index 2CH
Subsystem Vendor ID High Byte CR82 Index 2DH
Subsystem ID Low Byte CR83 Index 2EH
Subsystem ID High Byte CR84 Index 2FH
These registers allow identification of particular vendors using the same graphics chip. The following
design allows the subsystem identification to be handled by software (no hardwiring).
For add-in card cases, the system BIOS will typically attempt to read the subsystem ID information
before the video BIOS is run. When this occurs, Trio64V2 will check a read/write Subsystem ID Source
bit (CR37_2), which defaults to 1 on power-up. This bit is defined as follows:
CR37_2 - Subsystem ID Source
0 = Read subsystem ID information from chip registers
1 = Read subsystem ID information from BIOS
On power-up, with this bit set to 1, the following occurs:
3-6 FUNCTIONAL CHANGES PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
1. The PCI bus is claimed and held by the Trio64V2 when an attempt to read the subsystem ID
occurs.
2. Video ROM BIOS locations C0040-C0043 are read, depending on which BE[0:3] lines are enabled.
For example, if only BE0 is enabled, then the byte at C0040 will be read. The information in
C0040-C0043 is editable using S3’s Video BIOS edit utility, and thus can be tailored by each
vendor.
3. The PCI bus is released.
4. (Some time later) The video BIOS is run. This copies the information in C0040-C0043 to CR81-
CR83 (and the mirrored PCI2C-PCI2F). It also resets CR37_2 to 0. Until this step is taken, all sub-
system register accesses will generate the sequence listed in steps 1-3 above.
From this point on until the next hard re-boot, all subsystem register accesses will be directed to the
PCI subsystem registers. A soft reset (e.g., CTL-ALT-DEL) does not change the state of CR37_2 and thus
does not affect the subsystem ID read process.
Motherboard designs incorporate the video BIOS and system BIOS in the same ROM, so care must be
taken that the Trio64V2 does not generate a video ROM access cycle. To accomplish this, PD10 is pulled
low at reset to latch a 0 in CR37_2. The system BIOS must then load the subsystem ID information in
the Trio64V2 before any ID scanning takes place. To do this, it must turn on the Trio64V2, enable I/O
accesses in the PCI configuration space, unlock the CR registers, program the subsystem ID information
in the registers described above, then turn off the Trio64V2.
Trio64V2
SAA7110
Y[7:0] LD[7:0]
UV[7:0] LD[15:7]
LLC2 LCLK
HREF HREF
VS VS
SDA SPD
SCK SPCLK
V16
Figure 3-3. Video 16 Interface
PRELIMINARY FUNCTIONAL CHANGES 3-7

Trio64V2/DX & GX Graphics/Video Accelerators
3.9 VIDEO 16 LPB INTERFACE
The Video 16 interface is unchanged from the Trio64V+ except that HREF should be used instead of
HS. However, the YUV connections are not explicitly stated in the Trio64V+ data book and are shown
in Figure 3-3.
3.10 FUTURE COMPATIBILITY
For pin-compatibility with future S3 chips, special consideration must be taken with the board design
regarding pin 71. Contact your S3 technical representative for details.
3.11 NAND TREE TESTING
NAND-tree scanning is enabled when PD9 is pulled low at reset. All pins in the NAND-tree list become
inputs. SPCLK (pin 205) is the output pin for the scan and RESET cannot be tested and must not be
connected. MA[9:0] are output-only pins and are not tested. In addition, VSYNC and the analog pins
are not included in the the scan.
The tester drives high logic to the pins in the NAND tree. It then sequentially drives and holds each
input low and records the state of the SPCLK pin. Testing follows the order shown in Table 3-1, starting
with pin 206 and moving down each column until pin 204 is reached. If all pin connections are good,
the output will be a perfect square wave. If this pattern is broken, the location of the incorrect signal
level in the sequence identifies the bad connection.
3-8 FUNCTIONAL CHANGES PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
Table 3-1. NAND Tree Test Order
| # Pin              | # Pin          | # Pin                  |
| ------------------ | -------------- | ---------------------- |
| 206 SPD            | 054 PD24       | 121 PD48               |
| 207 AD31           | 055 PD22/GD6   | 122 PD63               |
| 208 AD30           | 056 PD25       | 127 PD39               |
| 001 AD29           | 057 PD21/GD5   | 128 PD40               |
| 002 AD28           | 058 PD26       | 129 PD38               |
| 003 AD27           | 059 PD20/GD4   | 130 PD41               |
| 004 AD26           | 061 PD27       | 131 PD37               |
| 005 AD25           | 063 PD19/GD3   | 132 PD42               |
| 006 AD24           | 064 PD28       | 133 PD36               |
| 007 C/BE3          | 065 PD18/GD2   | 134 PD43               |
| 008 IDSEL          | 066 PD29       | 136 PD35               |
| 010 AD23           | 067 PD17/GD1   | 138 PD44               |
| 011 AD22           | 068 PD30       | 139 PD34               |
| 013 AD21           | 069 PD16/GD0   | 140 PD45               |
| 014 AD20           | 070 PD31       | 141 PD33               |
| 015 AD19           | 082 CAS3/DQM3  | 142 PD46               |
| 016 AD18           | 083 CAS2/DQM2  | 143 PD32               |
| 017 AD17           | 084 RAS0/SDCLK | 144 PD47               |
| 018 AD16           | 085 CAS1/DQM1  | 146 LD0/PA0            |
| 019 C/BE2          | 086 CAS0/DQM0  | 147 LD1/PA1            |
| 020 FRAME          | 088 PD7/GA7    | 148 LCLK/VCLK          |
| 021 IRDY           | 089 PD8/GA8    | 148 *LCLK/VCLK         |
| 023 TRDY           | 090 PD6/GA6    | 151 ENFEAT/GOP0        |
| 024 DEVSEL         | 091 PD9/GA9    | 153 ROMEN//ROMEN/SPD   |
| 025 STOP           | 092 PD5/GA5    | 154 LD2/PA2            |
| 026 PAR            | 093 PD10/GA10  | 155 LD3/PA3            |
| 027 C/BE1          | 094 PD4/GA4    | 174 LD4/PA4            |
| 028 AD15           | 095 PD11/GA11  | 175 LD5/PA5            |
| 029 AD14           | 097 PD3/GA3    | 177 N/C//CS            |
| 030 AD13           | 098 PD12/GA12  | 179 N/C//DSF           |
| 031 AD12           | 100 PD2/GA2    | 183 ESYNC//N/C         |
| 033 AD11           | 101 PD13/GA13  | 184 LD6/PA6            |
| 034 AD10           | 102 PD1/GA1    | 185 LD8/PA8            |
| 035 AD9            | 103 PD14/GA14  | 186 LD9/PA9            |
| 036 AD8            | 104 PD0/GA0    | 187 LD10/PA10          |
| 038 C/BE0          | 105 PD15/GA15  | 188 LD11/PA11          |
| 039 AD7            | 106 PD55       | 189 LD12/PA12          |
| 040 AD6            | 107 PD56       | 190 STWR/GOP1          |
| 041 AD5            | 108 PD54       | 191 BLANK              |
| 042 AD4            | 109 PD57       | 194 SCLK               |
| 043 AD3            | 110 PD53       | 196 VCLKI              |
| 044 AD2            | 111 PD58       | 197 Reserved (PCI GNT) |
| 045 AD1            | 112 PD52       | 198 Reserved (PCI REQ) |
| 046 AD0            | 113 PD59       | 199 LD13/PA13          |
| 048 CAS4/DQM4      | 115 PD51       | 200 LD14/PA14          |
| 049 CAS5/DQM5      | 116 PD60       | 201 LD15/PA15          |
| 050 RAS1/OE1/SDRAS | 117 PD50       | 202 LD7/PA7            |
| 051 CAS6/DQM6      | 118 PD61       | 203 VREQ/VRDY/HREF/    |
| 052 CAS7/DQM7      | 119 PD49       | EVIDEO/ESYNC           |
| 053 PD23/GD7       | 120 PD62       | 204 CREQ/CRDY/VS/EVCLK |
 Pin names are given as DX name//GX name for the cases where the names are different.
* Pin #148 is connected to two consecutive NAND gates in the NAND tree.
| PRELIMINARY |     | FUNCTIONAL CHANGES  3-9 |
| ----------- | --- | ----------------------- |

Trio64V2/DX & GX Graphics/Video Accelerators

Trio64V2/DX & GX Graphics/Video Accelerators
Section 4: Register Changes from the Trio64V+
4.1 REGISTERS CHANGED
Register Bit(s) Description
SR1 4 When this bit is set, up to 3 HSYNCs may elapse before the screen is
turned off. Software must be careful to allow this amount of time to
pass before writing to registers that must be programmed during
screen off.
SRA 4-0 LPB N parameter. These are the 5 low order bits of a six bit value
controlling the time the LPB has control of the memory bus. The most
significant bit of this field is always 1.
SRD 1 0 = No function (Trio64-compatible VAFC feature connector eliminated)
SR12 7 Third bit of the PLL R divider. When SR12_7-5 = 100b, the frequency
divider is 16.
SR1C 1-0 The VL-Bus selections are eliminated.
CR2D 7-0 Device ID High = 89H
CR2E 7-0 Device ID Low = 01H
CR2F 7-0 Revision ID = xxH (varies with stepping)
CR32 3 Reserved = 0. This bit should never be set to 1.
CR36 1-0 Reserved - Hardwired to boot in PCI mode
CR36 3-2 00 = 1-cycle EDO
01 = SGRAM
10 = 2-cycle EDO
11 = Fast page
CR36 4 Reserved (no VL-Bus)
CR37 0 Reserved (no VL-Bus)
CR37 1 NAND Tree Testing
0 = Enable NAND tree testing
1 = Normal operation
CR37 2 Subsystem ID Source
0 = Read subsystem ID information from chip registers
1 = Read subsystem ID information from BIOS
CR37 4 Reserved (no VL-Bus)
CR40 0 This bit must only be programmed during screen off (SR1_5 = 1) or
during the vertical retrace period.Setting SR1_5 to 1 may take up to 3
HSYNCs to take effect.
PRELIMINARY REGISTER CHANGES 4-1

Trio64V2/DX & GX Graphics/Video Accelerators
CR40 4 Reserved (no VL-Bus)
CR52 2 No VL-Bus General Input Port
CR53 4-3 No VL-Bus power-on default
CR54 2 This is the lsb of the M parameter (not the msb as before)
CR58 3 Reserved (no VL-Bus)
CR66 0 This bit must only be programmed during screen off (SR1_5 = 1) or
during the vertical retrace period.Setting SR1_5 to 1 may take up to 3
HSYNCs to take effect.
CR68 2 SGRAM tRP (Refresh to Actiive Command Period)
0 = 4t
1 = 3t
CR68 3 SGRAM tRC (Precharge Command Period)
0 = 10t
1 = 9t
CR68 7 Reserved
CR69 3 Reserved (2 MByte maximum memory)
CR6A 5 Reserved (2 MByte maximum memory)
CR6F 0 0 = Trio64V2/DX mode and pinout
1 = Trio64V2/GX mode and pinout
CR6F 3 PD Hold Time (SGRAM only)
0 = Adjust PD hold time
1 = No effect
The BIOS must program this to 0 at power-up for SGRAM
configurations.
BEE8H_D The power-on default value is changed to “Undefined”.
BEE8H_E The power-on default value is changed to “Undefined”. Software must
initialize this register appropriately before the Graphics Engine is used.
This is a two step process as explained in the description for BEE8H,
read only.
MM8184 29 Color Keying on Index
0 = Color keying based on color value
1 = Color keying based on comparison of color index value with value
specified in MM8184_7-0
MM8190 31 Luma-only Interpolation
0 = All YUV values interpolated when vertical filtering enabled
1 = Only Y (luma) values interpolated when vertical filtering enabled
MM81CC 7 Enable Register Load
0 = No effect
1 = Enable function of CR66_5 = 1 (load registers on VSYNC)
This bit is automatically cleared to 0 after being set.
MM81E8 13 Memory Bandwidth Saving Mode 1
0 = Disable memory bandwidth savings mode 1
1 = Enable memory bandwidth savings mode 1
This bit is effective when vertical filtering is disabled. This function
should not be used if the line length is greater than 720 bytes.
4-2 REGISTER CHANGES PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
MM81E8 14 Memory Bandwidth Savings Mode 2
0 = Disable memory bandwidth savings mode 2
1 = Enable memory bandwidth savings mode 2
This bit is effective when vertical filtering is enabled.
MM81E8 15 Vertical Filtering
0 = Line replication used
1 = Vertical filtering (interpolation) enabled
MM81E8 18 Reserved
MM81EC 4-0 Streams FIFO Sizes
00000 = Primary Stream = 64 slots; Secondary Stream_NEXT = 0 slots
00100 = Primary Stream = 48 slots; Secondary Stream_NEXT = 16 slots
01000 = Primary Stream = 40 slots; Secondary Stream_NEXT = 24 slots
01100 = Primary Stream = 32 slots; Secondary Stream_NEXT = 32 slots
10000 = Primary Stream = 24 slots; Secondary Stream_NEXT = 40 slots
10100 = Primary Stream = 20 slots; Secondary Stream_NEXT = 44 slots
11000 = Primary Stream = 16 slots; Secondary Stream_NEXT = 48 slots
11100 = Primary Stream = 0 slots; Secondary Stream_NEXT = 64 slots
(the following apply only when vertical filtering is disabled)
00010 = Primary Stream = 64 slots; Secondary Stream = 90 slots
11110 = Primary Stream = 90 slots (Enhanced mode only)
Each slot holds one quadword.
MM81EC 9-5 Value = (# of secondary stream FIFO slots)/F, where F = 2 if the
secondary stream is using the 64-slot FIFO and 4 if it is using the 90-
slot FIFO.
In other words, each unit represents 2 or 4 FIFO slots
MM81EC 14-10 Value = (# of primary stream FIFO slots)/F, where F = 2 if the primary
stream is using the 64-slot FIFO and 4 if it is using the 90-slot FIFO.
In other words, each unit represents 2 or 4 FIFO slots
MMFF00 3-1 011 = Reserved (no Video 8 in/out mode)
MMFF00 7 Horizontal Decimation Type
0 = Trio64V+-type horizontal decimation
1 = New horizontal decimation type described in Section 3.2.1.
MMFF00 14 Auto Sync Generation
0 = No auto sync generation
1 = HSYNC and VSYNC automatically generated based on the horizontal
count programmed in MMFF28_11-0 and the vertical count
programmed in MMFF28_24-16. When the horizontal count value is
reached, the stride (MMFF34_11-0) is added to the address to start the
next line.
This bit is used for LPB pass-through mode.
PRELIMINARY REGISTER CHANGES 4-3

Trio64V2/DX & GX Graphics/Video Accelerators
MMFF00 20 Video HSYNC
0 = Horizontal window size value used to reset horizontal counter and
start a new line in Video 8 and 16 modes
1 = HREF input used to reset horizontal counter and start a new line in
Video 8 and 16 modes.
This register must be programmed to 1 when the width of an incoming
live video line may be less than the programmed size.
MMFF00 23-21 Video FIFO Threshold
000 = 1 slot
001 = 2 slots
010 = 4 slots
011 = 6 slots
100 = 8 slots
101 = 10 slots
110 = 12 slots
111 = 14 slots
When the number of video FIFO slots programmed in this register are
filled, a request is made to the memory controller to empty the FIFO.
MMFF00 28 Odd/even field Indicator (Read Only)
0 = Odd field being processed
1 = Even field being processed
This bit is valid when interlaced video data is being input via the LPB
using Video 8 or Video 16 mode.
MMFF00 29 Odd/Even Field Indicator Invert
0 = Odd/even field definition specified by bit 28 of this register
1 = Odd/even field definition inverted from the definition in bit 28 of this
register
MMFF00 30 Odd/Even Field Detection Enable
0 = Odd/even field detection disabled
1 = Odd/even field detection enabled
This function can be enabled when the LPB is operating in its Video 8 or
Video 16 mode.
MMFF00 31 Reserved (no CL-480 support)
MMFF04 4 Video FIFO Flush
0 = No Video FIFO flush
1 = Video FIFO flush in process
This bit is used for test purposes only.
MMFF04 7-5 LPB FIFO Write Pointer Status
Value = State of LPB FIFO write pointer
This bit is used for test purposes only.
MMFF04 10-8 LPB FIFO Read Pointer Status
Value = State of LPB FIFO read pointer
This bit is used for test purposes only.
4-4 REGISTER CHANGES PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
MMFF04 18-14 Video FIFO Write Pointer Status
Value = State of video FIFO write pointer
This bit is used for test purposes only.
MMFF04 27-23 video FIFO Read Pointer Status
Value = State of Video FIFO read pointer
This bit is used for test purposes only.
MMFF04 28 Frame Dropping Status
0 = Current frame dropped
1 = Current frame being passed to memory
MMFF28 11-0 Auto Sync Horizontal Size
Value = (number of pixels/line)/2
This value is valid only for pass-through mode and is used to generate
automatic HSYNCs. The original definition for these bits still applies for
Video 8 or 16 mode.
MMFF28 24-16 Auto Sync Vertical Size
Value = number of lines of video per frame
This value is valid only for pass-through mode and is used to generate
automatic VSYNCs. The original definition for these bits still applies for
Video 8 or 16 mode.
MMFF2C 31-0 Decimation for 4:2:2 input only. See the description in Section 3.
PCI Index 02H 15-0 Device ID = 8901H
PCI Index 08H 7-0 Revision ID = xxH (varies with stepping)
PRELIMINARY REGISTER CHANGES 4-5

Trio64V2/DX & GX Graphics/Video Accelerators
4.2 NEW REGISTERS
Extended Sequencer 1A Register (SR1A)
| Read/Write |     | Address: 3C5H, Index 1AH |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
| 7 6      | 5 4                         | 3 2       | 1 0       |
| -------- | --------------------------- | --------- | --------- |
| R R      | BP FCTD                     | DCLK PLLA | MCLK PLLA |
| Bits 1-0 | MCLK PLLA - MCLK PLL Adjust |           |           |
Value = PLL gain adjustment factor
This function is used for S3 testing.
| Bits 3-2 | DCLK PLLA - DCLK PLL Adjust |     |     |
| -------- | --------------------------- | --- | --- |
Value = PLL gain adjustment factor
This function is used for S3 testing.
| Bit 4 | FCTD - Filter Capacitor Test Disable |     |     |
| ----- | ------------------------------------ | --- | --- |
0 = No effect
1 = Filter capacitor test mode disabled
This function is used for S3 testing.
Note: This bit must be set to 1 by the BIOS upon reset.
| Bit 5 | BP - BLANK Pedestal |     |     |
| ----- | ------------------- | --- | --- |
0 = No BLANK pedestal
1 = Add BLANK Pedestal to RAMDAC output
| Bits 7-6 | Reserved |     |     |
| -------- | -------- | --- | --- |
4-6  REGISTER CHANGES PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
Extended Sequencer 1B Register (SR1B)
| Read/Write |     | Address: 3C5H, Index 1BH |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
| 7 6      | 5 4                                        | 3 2          | 1 0 |
| -------- | ------------------------------------------ | ------------ | --- |
| R R      | R R                                        | R DAC OUTPUT |     |
| Bits 2-0 | DAC OUTPUT - RAMDAC Output Current Control |              |     |
The higher the value in this field, the lower the maximum DAC output current.
This function is used for S3 testing.
| Bits 7-3 | Reserved |     |     |
| -------- | -------- | --- | --- |
Synchronization 1 Register (CTR23)
| Read/Write |     | Address: 3?5H, Index 23H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
This register must be 00H before CR26 is written. For this to be effective, A5H must first be pro-
grammed into CR39.
| 7 6      | 5 4      | 3 2 | 1 0 |
| -------- | -------- | --- | --- |
| R R      | R R      | R R | R R |
| Bits 7-0 | Reserved |     |     |
Synchronization 2 Register (CTR26)
| Read Only |     | Address: 3?5H, Index 26H |     |
| --------- | --- | ------------------------ | --- |
Power-On Default: 00H
The BIOS must write 00H to this register upon each mode set (assuming CR23 is at its default value
of 00H). Drivers should write 00H to this register after writing 00H to CR23 before enabling vertical
interpolation. For this to be effective, A5H must first be programmed into CR39.
| 7 6      | 5 4      | 3 2 | 1 0 |
| -------- | -------- | --- | --- |
| R R      | R R      | R R | R R |
| Bits 7-0 | Reserved |     |     |
PRELIMINARY REGISTER CHANGES  4-7

Trio64V2/DX & GX Graphics/Video Accelerators
Extended Memory Control 5 Register (CR72)
| Read/Write |     | Address: 3?5H, Index 72H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
| 7 6 | 5 4 | 3 2 | 1 0 |
| --- | --- | --- | --- |
SECONDARY STREAM FIFO N PARAMETER
| Bits 7-0 | SECONDARY STREAM FIFO N PARAMETER |     |     |
| -------- | --------------------------------- | --- | --- |
Value = Number of MCLKs allocated to screen refresh FIFO filling before control of
the memory bus is relinquished.
This value is effective only when the FIFO is at or above its threshold value (low prior-
ity).
Drive Current Control Register (CR80)
| Read/Write |     | Address: 3?5H, Index 80H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
| 7 6      | 5 4                    | 3 2 | 1 0 |
| -------- | ---------------------- | --- | --- |
| R R      | R PDD                  | R R | R R |
| Bits 3-0 | Reserved               |     |     |
| Bit 4    | PDD - PD Drive Current |     |     |
0 = PD[63:0] drive current is 8 ma
1 = PD[63:0] drive current is 4 ma
| Bits 7-5 | Reserved |     |     |
| -------- | -------- | --- | --- |
PCI Subsystem Vendor ID Shadow Low Register (CR81)
| Read/Write |     | Address: 3?5H, Index 81H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
| 7 6 | 5 4 | 3 2 | 1 0 |
| --- | --- | --- | --- |
PCI SUBSYSTEM VENDOR ID LOW BYTE
| Bits 7-0 | PCI SUBSYSTEM VENDOR ID LOW BYTE |     |     |
| -------- | -------------------------------- | --- | --- |
This register shadows the byte at PCI configuration space index 2CH.
4-8  REGISTER CHANGES PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
PCI Subsystem Vendor ID Shadow High Register (CR82)
| Read/Write |     | Address: 3?5H, Index 82H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
| 7 6 | 5 4 | 3 2 | 1 0 |
| --- | --- | --- | --- |
PCI SUBSYSTEM VENDOR ID HIGH BYTE
| Bits 7-0 | PCI SUBSYSTEM VENDOR ID HIGH BYTE |     |     |
| -------- | --------------------------------- | --- | --- |
This register shadows the byte at PCI configuration space index 2DH.
PCI Subsystem ID Shadow Low Register (CR83)
| Read/Write |     | Address: 3?5H, Index 83H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
| 7 6 | 5 4 | 3 2 | 1 0 |
| --- | --- | --- | --- |
PCI SUBSYSTEM ID LOW BYTE
| Bits 7-0 | PCI SUBSYSTEM ID LOW BYTE |     |     |
| -------- | ------------------------- | --- | --- |
This register shadows the byte at PCI configuration space index 2EH.
PCI Subsystem ID Shadow High Register (CR84)
| Read/Write |     | Address: 3?5H, Index 84H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
| 7 6 | 5 4 | 3 2 | 1 0 |
| --- | --- | --- | --- |
PCI SUBSYSTEM ID HIGH BYTE
| Bits 7-0 | PCI SUBSYSTEM ID HIGH BYTE |     |     |
| -------- | -------------------------- | --- | --- |
This register shadows the byte at PCI configuration space index 2FH.
PRELIMINARY REGISTER CHANGES  4-9

Trio64V2/DX & GX Graphics/Video Accelerators
FIFO Fetch Delay Register (CR85)
| Read/Write |     | Address: 3?5H, Index 85H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
| 7 6      | 5 4              | 3 2                | 1 0 |
| -------- | ---------------- | ------------------ | --- |
| R R      | R R              | R FIFO FETCH DELAY |     |
| Bits 2-0 | FIFO FETCH DELAY |                    |     |
Value = number of character clocks to delay start of FIFO fetching.
This value only applies to full Streams Processor mode (CR67_3-2 = 11b), where FIFO
fetching automatically begins as soon as feasible after the start of blanking.
| Bits 7-3 | Reserved |     |     |
| -------- | -------- | --- | --- |
DAC Power Up Register (CR86)
| Read/Write |     | Address: 3?5H, Index 86H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
| 7 6      | 5 4               | 3 2 | 1 0 |
| -------- | ----------------- | --- | --- |
| DPSD     | DAC POWER UP TIME |     |     |
| Bits 6-0 | DAC POWER UP TIME |     |     |
value = number of character clocks from the start of blanking at which the internal
DACs are powered up
This value must be at least 1 less than the End Horizontal Blank value programmed in
CR5D_3, CR5_7 and CR3_4-0. A value of 1 less starts DAC power up 1 character clock
before the end of blanking. A value of 2 less starts DAC power up 2 character clocks
before the end of blanking, etc. When the DACs power up, there is a voltage spike
that affects the RGB outputs if they are active. Powering up the DACs earlier reduces
the power savings but also reduces the chance that the power up voltage spike will af-
fect the active display.
| Bit 7 | DPSD - DAC Power Saving Disable |     |     |
| ----- | ------------------------------- | --- | --- |
0 = RAMDAC power saving enabled (DAC turned off at BLANK start and on at
    position programmed in bits 6-0 of this register
1 = RAMDAC power saving disabled (RAMDAC never powered down)
4-10  REGISTER CHANGES PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
Miscellaneous Control Register (CR87)
| Read/Write |     | Address: 3?5H, Index 87H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
| 7 6   | 5 4                | 3 2 | 1 0     |
| ----- | ------------------ | --- | ------- |
| R R   | R R                | R R | 1LA DUV |
| Bit 0 | DUV - Drop UV/CbCr |     |         |
0 = Pass UV/CbCr color components to the line buffer
1 = Drop UV/CbCr color components before writing to the line buffer
This bit is used to reduce the bandwidth requirements for live video. It is effective
when vertical filtering is enabled (MM81E8_15 = 1) and memory bandwidth savings
mode is enabled (MM81E8_14 = 1).
| Bit 1 | 1LA - 1-cycle Linear Addressing |     |     |
| ----- | ------------------------------- | --- | --- |
0 = Disable 1-cycle linear addressing
1 = Enable 1-cycle linear addressing write operation
If this bit is set, the video memory must be capable of supporting 1-cycle operation.
| Bits 7-2 | Reserved |     |     |
| -------- | -------- | --- | --- |
Synchronous DRAM Control Register (CR88)
| Read/Write |     | Address: 3?5H, Index 88H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
This register is valid only for the Trio64V2/GX.
| 7 6   | 5 4                | 3 2   | 1 0   |
| ----- | ------------------ | ----- | ----- |
| R DR  | SMS                | SCL R | PDD R |
| Bit 0 | Reserved           |       |       |
| Bit 1 | PDD - PD Bus Delay |       |       |
0 = No delay
1 = Delay PD bus output by 1/2 MCLK (memory writes)
| Bit 2    | Reserved                |     |     |
| -------- | ----------------------- | --- | --- |
| Bits 4-3 | SCL - SGRAM CAS Latency |     |     |
00 = Reserved
01 = Reserved (for 1 MCLK)
10 = 3 MCLKs
11 = 2 MCLKs
PRELIMINARY REGISTER CHANGES  4-11

Trio64V2/DX & GX Graphics/Video Accelerators
| Bit 5 | SMS - SGRAM Set Mode Register |     |     |
| ----- | ----------------------------- | --- | --- |
After the CAS latency is programmed, this bit is programmed to 1 to generate a
mode programming cycle. This bit is automatically cleared to 0 after the program-
ming cycle.
| Bit 6 | DR - Disable RAM Refresh |     |     |
| ----- | ------------------------ | --- | --- |
0 = RAM refresh enabled
1 = RAM refresh disabled
| Bit 7 | Reserved |     |     |
| ----- | -------- | --- | --- |
Primary Stream FIFO Fetch Control 1 Register (CR90)
| Read/Write |     | Address: 3?5H, Index 90H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
| 7 6      | 5 4                                               | 3 2 | 1 0     |
| -------- | ------------------------------------------------- | --- | ------- |
| EL1 R    | R R                                               | R   | L1 10-8 |
| Bits 2-0 | L1 10-8 - Primary Stream L1 Parameter (Bits 10-8) |     |         |
These are bits 10-8 of the primary stream L1 parameter. See the description of the pri-
mary stream L1 parameter in the description for CR91.
| Bits 6-3 | Reserved                  |     |     |
| -------- | ------------------------- | --- | --- |
| Bit 7    | EL1 - Enable L1 Parameter |     |     |
0 = Primary stream display fetch length control (L1 parameter) disabled
1 = Primary stream display fetch length control (L1 parameter) enabled
Primary Stream FIFO Fetch Control 2 (CR91)
| Read/Write |     | Address: 3?5H, Index 91H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
These are the lower 8 bits of an 11-bit value used in conjunction with the M and N parameters to op-
timize performance. If the primary stream display FIFO is being filled when this value is reached,
FIFO filling will be stopped and memory control will be switched to the M parameter. The upper
three bits are bits 2-0 of CR90.
| 7 6 | 5 4 | 3 2 | 1 0 |
| --- | --- | --- | --- |
L1 7-0
| Bits 7-0 | L1 7-0 - Primary Stream L1 Parameter (Bits 7-0) |     |     |
| -------- | ----------------------------------------------- | --- | --- |
11-bit Value = [(number of bytes of displayed pixels per scan line) ‚  8] - 1. This regis-
ter contains the least significant 8 bits of this value.
4-12  REGISTER CHANGES PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
Secondary Stream FIFO Fetch Control 1 Register (CR92)
| Read/Write |     | Address: 3?5H, Index 92H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
| 7 6      | 5 4                                                 | 3 2 | 1 0     |
| -------- | --------------------------------------------------- | --- | ------- |
| EL2 R    | R R                                                 | R   | L2 10-8 |
| Bits 2-0 | L2 10-8 - Secondary Stream L2 Parameter (Bits 10-8) |     |         |
These are bits 10-8 of the secondary stream L2 parameter. See the description of the
primary stream L2 parameter in the description for CR93.
| Bits 6-3 | Reserved                  |     |     |
| -------- | ------------------------- | --- | --- |
| Bit 7    | EL2 - Enable L2 Parameter |     |     |
0 = Secondary stream display fetch length control (L2 parameter) disabled
1 = Secondary stream display fetch length control (L2 parameter) enabled
Secondary Stream FIFO Fetch Control 2 (CR93)
| Read/Write |     | Address: 3?5H, Index 93H |     |
| ---------- | --- | ------------------------ | --- |
Power-On Default: 00H
These are the lower 8 bits of an 11-bit value used in conjunction with the M and N parameters to op-
timize performance. If the secondary stream display FIFO is being filled when this value is reached,
FIFO filling will be stopped and memory control will be switched to the M parameter. The upper
three bits are bits 2-0 of CR92.
| 7 6 | 5 4 | 3 2 | 1 0 |
| --- | --- | --- | --- |
L2  7-0
| Bits 7-0 | L2 7-0 - Secondary Stream L2 Parameter (Bits 7-0) |     |     |
| -------- | ------------------------------------------------- | --- | --- |
11-bit Value =  [(number of bytes of displayed pixels per scan line) ‚  8] - 1. This regis-
ter contains the least significant 8 bits of this value.
PRELIMINARY REGISTER CHANGES  4-13

Trio64V2/DX & GX Graphics/Video Accelerators
Color Adjustment Register (MM819C)
| Read/Write |     | Offset: 819C |     |     |     |
| ---------- | --- | ------------ | --- | --- | --- |
Power-on Default: 00000000H
| 15 14    | 13 12                           | 11 10 9 8   | 7 6   | 5 4 3 2 1      | 0   |
| -------- | ------------------------------- | ----------- | ----- | -------------- | --- |
| BCE R    | R                               | CONTRAST    |       | BRIGHTNESS     |     |
| 31 30    | 29 28                           | 27 26 25 24 | 23 22 | 21 20 19 18 17 | 16  |
| HSE R    | R                               | HUE/SAT 2   | R R   | R HUE/SAT 1    |     |
| Bits 7-0 | BRIGHTNESS - Brightness Control |             |       |                |     |
Value = SBBBBBBB
where S is the sign bit (1 = negative) and BBBBBBB is the brightness adjustment fac-
tor. The larger the number, the greater the brightness. The value can range from -256
to 254 because the programmed value is shifted left by 1, thereby multiplying the
value by 2. The value is in 2’s complement format.
| Bits 12-8 | CONTRAST- Contrast Control |     |     |     |     |
| --------- | -------------------------- | --- | --- | --- | --- |
Value = C.CCCC
This is the contrast adjustment, which can vary from 0 to 1.9375. The value is in 2’s
complement format.
| Bits 14-13 | Reserved                             |     |     |     |     |
| ---------- | ------------------------------------ | --- | --- | --- | --- |
| Bits 15    | BCE - Brightness and Contrast Enable |     |     |     |     |
0 = Brightness and contrast control disabled
1 = Brightness and contrast control enabled
This control should be enabled only for YUV/YCbCr secondary stream formats and
must be disabled for RGB secondary stream formats.
| Bits 20-16 | HUE/SAT 1 - Hue and Saturation Factor 1 |     |     |     |     |
| ---------- | --------------------------------------- | --- | --- | --- | --- |
Value = SF.FFF
where S is the sign bit (1 = negative) and F.FFF is the factor [SAT * cosine A]. SAT is
the saturation, which can vary from -2 to 1.85 and A is the hue angle, the cosine of
which can vary from -1 to +1. The value is in 2’s complement format.
| Bits 23-21             | Reserved |     |     |             |     |
| ---------------------- | -------- | --- | --- | ----------- | --- |
| 4-14  REGISTER CHANGES |          |     |     | PRELIMINARY |     |

Trio64V2/DX & GX Graphics/Video Accelerators
| Bits 28-24 HUE/SAT 2 - Hue and Saturation Factor 2 |     |     |     |     |     |
| -------------------------------------------------- | --- | --- | --- | --- | --- |
Value = SF.FFF
where S is the sign bit (1 = negative) and F.FFF is the factor [SAT * sine A]. SAT is the
saturation, which can vary from -2 to 1.85 and A is the hue angle, the sine of which
can vary from -1 to +1. The value is in 2’s complement format.
| Bits 30-29 Reserved                            |     |     |     |     |     |
| ---------------------------------------------- | --- | --- | --- | --- | --- |
| Bit 31 HSE - Hue and Saturation Control Enable |     |     |     |     |     |
0 = Hue and saturation control disabled
1 = Hue and saturation control enabled
This control should be enabled only for YUV/YCbCr secondary stream formats and
must be disabled for RGB secondary stream formats.
PCI Configuration Space Subsystem ID
| Read Only | Address: 2CH |     |     |     |     |
| --------- | ------------ | --- | --- | --- | --- |
Power-On Default: 00000000H
This register is a shadow of CR81-CR84.
| 15 14 13 | 12 11 10 | 9 8 7 | 6 5 4 | 3 2 1 | 0   |
| -------- | -------- | ----- | ----- | ----- | --- |
SUBSYSTEM VENDOR ID
| 31 30 29 | 28 27 26 | 25 24 23 | 22 21 20 | 19 18 17 | 16  |
| -------- | -------- | -------- | -------- | -------- | --- |
SUBSYSTEM ID
| Bits 15-0 SUBSYSTEM VENDOR ID |     |     |     |                        |     |
| ----------------------------- | --- | --- | --- | ---------------------- | --- |
| Bits 31-16 SUBSYSTEM ID       |     |     |     |                        |     |
| PRELIMINARY                   |     |     |     | REGISTER CHANGES  4-15 |     |

Trio64V2/DX & GX Graphics/Video Accelerators

Trio64V2/DX & GX Graphics/Video Accelerators
Section 5: Electrical Data
5.1 MAXIMUM RATINGS
Table 5-1. Absolute Maximum Ratings
| Ambient temperature | 0(cid:176) |  C to 70 (cid:176) C |     |     |     |
| ------------------- | ---------- | -------------------- | --- | --- | --- |
-40(cid:176)  C to 125(cid:176)  C
Storage temperature
| DC Supply Voltage                   | -0.5V to 7.0V     |     |     |     |     |
| ----------------------------------- | ----------------- | --- | --- | --- | --- |
| I/O Pin Voltage with respect to VSS | -0.5V to VDD+0.5V |     |     |     |     |
5.2 DC SPECIFICATIONS
Note: In all cases below, digital VDD = 5V –  5% and the operating temperature is 0(cid:176)  C to 70 (cid:176) C.
Table 5-2. RAMDAC/Clock Synthesizer DC Specifications
| Symbol       | Parameter                  | Min  | Typical | Max  | Unit |
| ------------ | -------------------------- | ---- | ------- | ---- | ---- |
| AVDD         | DAC supply voltage         | 4.75 | 5       | 5.25 | V    |
| AVDD (CLOCK) | PLL supply voltage         | 4.75 | 5       | 5.25 | V    |
| VREF         | Internal voltage reference | 1.10 | 1.235   | 1.35 | V    |
Table 5-3. RAMDAC Characteristics
|                          |     | Min | Typical | Max  | Unit |
| ------------------------ | --- | --- | ------- | ---- | ---- |
| Resolution Each DAC      |     |     | 8       |      | bits |
| LSB Size                 |     |     | 66      |      | m A  |
| Integral Linearity Error |     |     |         | –  1 | LSB  |
–
| Differential Linearity Error |     |      |      |  1                   | LSB       |
| ---------------------------- | --- | ---- | ---- | -------------------- | --------- |
| Output Full-Scale Current    |     | 15.4 | 17.6 | 19.8                 | mA        |
| DAC to DAC Mismatch          |     |      |      | 5%                   |           |
| Power Supply Rejection Ratio |     |      |      | 0.5                  | %/ % AVDD |
| Output Compliance            |     | 0.0  |      | 1.5                  | V         |
| Output Capacitance           |     |      |      | 30                   | pF        |
| Glitch Impulse               |     |      | 75   |                      | pV-Sec    |
| PRELIMINARY                  |     |      |      | ELECTRICAL DATA  5-1 |           |

Trio64V2/DX & GX Graphics/Video Accelerators
| Table 5-4. Digital DC Specifications (VDD = 5V – |     |  5%, Operating Temperature 0(cid:176) |  C to 70(cid:176) |     |
| ------------------------------------------------ | --- | ------------------------------------- | ----------------- | --- |
 C)
| Symbol | Parameter                | Min         | Max          | Unit |
| ------ | ------------------------ | ----------- | ------------ | ---- |
| VIL    | Input Low Voltage        | -0.5        | 0.8          | V    |
| VIH    | Input High Voltage       | 2.4         | VDD +0.5     | V    |
| VOL    | Output Low Voltage       |             | VSS + 0.4    | V    |
| VOH    | Output High Voltage      | 2.4         |              | V    |
| IOL1   | Output Low Current       | 8 (Note 1)  |              | mA   |
| IOH1   | Output High Current      | -4          |              | mA   |
| IOL2   | Output Low Current       | 16 (Note 2) |              | mA   |
| IOH2   | Output High Current      | -8          |              | mA   |
| IOL3   | Output Low Current       | 24 (Note 3) |              | mA   |
| IOH3   | Output High Current      | -12         |              | mA   |
| IOZ    | Output Tri-state Current |             | 1            | m A  |
| CIN    | Input Capacitance        |             | 5            | pF   |
| COUT   | Output Capacitance       |             | 5            | pF   |
| ICC    | Power Supply Current     |             | TBD (Note 4) | mA   |
Notes
1. IOL1, IOH1 for pins ROMEN, INTA, STWR, HSYNC, VSYNC, VCLK, BLANK, ENFEAT,
MA[8:0], CAS[7:0], PD[63:0], AD[31:0], LD[7:0], VREQ/VRDY, SPCLK, SPD
2. IOL2, IOH2 for pins OE[1:0], WE, RAS[1:0]
3. IOL3, IOH3 for pins PAR, STOP, DEVSEL, TRDY
4. ICC measured for a resolution of TBD.
| 5-2  ELECTRICAL DATA |     |     |     | PRELIMINARY |
| -------------------- | --- | --- | --- | ----------- |

Trio64V2/DX & GX Graphics/Video Accelerators
5.3 AC SPECIFICATIONS
5.3.1 RAMDAC AC Specifications
Table 5-5. RAMDAC AC Specifications
| Parameter                 |     |     | Typical | Max | Unit | Notes |
| ------------------------- | --- | --- | ------- | --- | ---- | ----- |
| DAC Output Delay          |     |     | 5       |     | ns   | 1     |
| DAC Output Rise/Fall Time |     |     | 3       |     | ns   | 2     |
| DAC Output Settling Time  |     |     | 15      |     | ns   |       |
| DAC-to-DAC Output Skew    |     |     | 2       | 5   | ns   | 3     |
Notes
1. Measured from the 50% point of VCLK to the 50% point of full scale transition
2. Measured from 10% to 90% full scale
3 With DAC outputs equally loaded
Table 5-6. RAMDAC Output Specifications
| Description       | IOUT (mA)       | VOUT (V)        |     | BLANK | Input Data |     |
| ----------------- | --------------- | --------------- | --- | ----- | ---------- | --- |
| White (with BLANK | 19.05 (typical) | 0.714 (typical) |     | 1     |            | FFH |
pedestal)
| White            | 17.6 (typical) | 0.66 (typical |     | 1   |     | FFH  |
| ---------------- | -------------- | ------------- | --- | --- | --- | ---- |
| Data (with BLANK | Data + 1.45    | Data + 0.054  |     | 1   |     | Data |
pedestal)
| Data              | Data           | Data  |     | 1   |     | Data |
| ----------------- | -------------- | ----- | --- | --- | --- | ---- |
| Black (with BLANK | 1.45 (typical) | 0.054 |     | 1   |     | 00H  |
pedestal)
| Black (no pedestal) | 0   |     | 0   | 1   |            | 00H |
| ------------------- | --- | --- | --- | --- | ---------- | --- |
| BLANK               | 0   |     | 0   | 0   | Don’t Care |     |
Notes for Table 5-6
1. Condition for VOUT is a 75 Ohm doubly terminated load, use of the internal VREF and
RSET = 147 Ohms.
2, No sync pedestal is provided. Sync output levels are the same as for black output.
3. The BLANK pedestal is active when SR1A_5 = 1.
| PRELIMINARY |     |     |     |     | ELECTRICAL DATA  5-3 |     |
| ----------- | --- | --- | --- | --- | -------------------- | --- |

Trio64V2/DX & GX Graphics/Video Accelerators
5.3.2 Clock Timing
T
HIGH
2.4V
1.5V
0.8V
T
LOW
T
|     |     | CYC | DCLKTIME |     |
| --- | --- | --- | -------- | --- |
Figure 5-1.  Clock Waveform Timing
Table 5-7. Clock Waveform Timing
| Symbol | Parameter                       | Min   | Max | Units Notes |
| ------ | ------------------------------- | ----- | --- | ----------- |
| TCYC   | SCLK Cycle Time                 | 30    | 125 | ns 1        |
|        | LCLK Cycle Time                 | 30    | 200 | ns          |
|        | MCLK Cycle Time (fast page)     | 15    | 100 | ns          |
|        | MCLK Cycle Time (1-cycle EDO)   | 16.67 | 100 | ns          |
|        | DCLK Cycle Time (VGA Mode)      | 25    | 100 | ns 1        |
|        | DCLK Cycle Time (Enhanced Mode) | 12.5  | 100 | ns 1, 2     |
|        | SDCLK Cycle Time                | 15    | 100 | ns          |
| THIGH  | SCLK High Time                  | 12    | 80  | ns          |
|        | LCLK High Time                  | 12    | 160 | ns          |
|        | SDCLK High Time                 | 6     | 80  | ns          |
| TLOW   | SCLK Low Time                   | 12    | 80  | ns          |
|        | LCLK Low Time                   | 12    | 160 | ns          |
|        | SDCLK Low Time                  | 6     | 80  | ns          |
|        | SCLK, LCLK, SDCLK Slew Rate     | 1     | 4   | V/ns 3      |
Notes
1. fDCLK ‡  1/2 fSCLK to ensure valid writes to the PLLs.
2. The maximimum DCLK with the Streams Processor enabled and single clocking is 80 MHz. With
the Streams Processor disabled and single clocking, the maximum DCLK is 95 MHz. The maxi-
mum DCLK rate with clock doubling is 170 MHz, with two 8-bit pixels clocked into the RAM-
DAC each clock at 85 MHz.
3. Rise and fall times are specified in terms of the edge rate measured in V/ns. This slew rate
must be met across the minimum peak-to peak portion of the clock waveform.
| 5-4  ELECTRICAL DATA |     |     |     | PRELIMINARY |
| -------------------- | --- | --- | --- | ----------- |

Trio64V2/DX & GX Graphics/Video Accelerators
5.3.3 Input/Output Timing
CLOCK
1.5 V
|     |       | T T   |       |     |     |
| --- | ----- | ----- | ----- | --- | --- |
|     |       | SU H  |       |     |     |
|     | INPUT | 1.5 V | 1.5 V |     |     |
TCLKIN
Figure 5-2.  Input Timing
Table 5-8. SCLK-Referenced Input Timing
PCI Bus
| Symbol | Parameter                                     |     |     | Min | Units |
| ------ | --------------------------------------------- | --- | --- | --- | ----- |
| TSU    | AD[31:0], C/BE[3:0], FRAME, IRDY, IDSEL setup |     |     | 7   | ns    |
| TH     | AD[31:0] hold                                 |     |     | 1   | ns    |
| TH     | C/BE[3:0], FRAME, IRDY, IDSEL hold            |     |     | 1   | ns    |
Miscellaneous
| Symbol      | Parameter                        |     |     | Min                  | Units |
| ----------- | -------------------------------- | --- | --- | -------------------- | ----- |
| TSU         | ROM data GD[7:0] setup (PCI)     |     |     | 5                    | ns    |
| TH          | ROM data GD[7:0] hold (PCI)      |     |     | 7                    | ns    |
| TSU         | General Input Port GD[7:0] setup |     |     | 5                    | ns    |
| TH          | General Input Port GD[7:0] hold  |     |     | 7                    | ns    |
| PRELIMINARY |                                  |     |     | ELECTRICAL DATA  5-5 |       |

Trio64V2/DX & GX Graphics/Video Accelerators
Table 5-9. LCLK-Referenced Input Timing
Scenic/MX2 Interface
| Symbol | Parameter     | Min | Units |
| ------ | ------------- | --- | ----- |
| TSU    | LD[7:0] setup | 10  | ns    |
| TH     | LD[7:0] hold  | 9   | ns    |
| TSU    | CREQ/CRDY     | 6   | ns    |
| TH     | CREQ/CRDY     | 8   | ns    |
SAA7110 Interface
| Symbol | Parameter                                          | Min | Units |
| ------ | -------------------------------------------------- | --- | ----- |
| TSU    | LD[7:0] setup (also LD[15:8] for 16-bit interface) | 6   | ns    |
| TH     | LD[7:0] hold (also LD[15:8] for 16-bit interface)  | 8   | ns    |
| TSU    | HS setup                                           | 6   | ns    |
| TH     | HS hold                                            | 7   | ns    |
| TSU    | VS setup                                           | 6   | ns    |
| TH     | VS hold                                            | 7   | ns    |
Table 5-10. MCLK-Referenced Input Timing
| Symbol | Parameter                                    | Min  | Units |
| ------ | -------------------------------------------- | ---- | ----- |
| TSU    | PD[63:0] setup to MCLK high (2-cycle EDO)    | 0    | ns    |
| TH     | PD[63:0] hold from MCLK high (2-cycle EDO)   | 12.5 | ns    |
| TSU    | PD[63:0] setup to following CAS low (1-cycle | 0    | ns    |
EDO)
| TH  | PD[63:0] hold from following CAS low (1-cycle | 15  | ns  |
| --- | --------------------------------------------- | --- | --- |
EDO)
| TSU | PD[63:0] setup to CAS high (fast page)  | 0   | ns  |
| --- | --------------------------------------- | --- | --- |
| TH  | PD[63:0] hold from CAS high (fast page) | 15  | ns  |
Note
1. The timing reference in each of the three cases above is to the event that causes the latching
of the read data. The MCLK used to latch 2-cycle EDO data is an internal signal that cannot be
directly observed. The CAS signals used to latch read data in the other operational modes are
derived from the internal MCLK.
Table 5-11. SDCLK-Referenced Input Timing
| Symbol               | Parameter       | Min | Units       |
| -------------------- | --------------- | --- | ----------- |
| TSU                  | PD[63:0] setup  | 13  | ns          |
| TH                   | PD[63:0] hold   | 4   | ns          |
| 5-6  ELECTRICAL DATA |                 |     | PRELIMINARY |

Trio64V2/DX & GX Graphics/Video Accelerators
CLOCK
1.5 V
MAX
MIN
|     | OUTPUT | 1.5 V | 1.5 V |
| --- | ------ | ----- | ----- |
TCLKOUT
Figure 5-3.  Output Timing
The minimum delay is the minimum time after the clock edge that the valid signal state from the
previous cycle will begin transition to the next state (become invalid).
The maximum delay is the maximum time after the clock edge that the signal state is valid for the next
cycle.
Table 5-12. SCLK-Referenced Output Timing
PCI Bus
| Parameter            |     | Min Max | Units Notes      |
| -------------------- | --- | ------- | ---------------- |
| AD[31:0] valid delay |     | 2 16    | ns 1             |
| DEVSEL, PAR          |     | 2 11    | ns Medium DEVSEL |
delay timing used
| STOP delay |     | 2 11 | ns  |
| ---------- | --- | ---- | --- |
| TRDY delay |     | 2 11 | ns  |
| INTA delay |     | 2 11 | ns  |
Miscellaneous
| Parameter                    |     | Min Max | Units Notes |
| ---------------------------- | --- | ------- | ----------- |
| ROMEN delay                  |     | 4 10    | ns          |
| ROM address valid delay      |     | 5 30    | ns          |
| AD[7:0] ROM data valid delay |     | 5 30    | ns          |
Note
1. Due to the timing for TRDY for read cycles, data is not sampled on the clock edge immediately
following its becoming valid. This guarantees the PCI 2.1 specification time of 11 ns.
| PRELIMINARY |     |     | ELECTRICAL DATA  5-7 |
| ----------- | --- | --- | -------------------- |

Trio64V2/DX & GX Graphics/Video Accelerators
Table 5-13. LCLK-Referenced Output Timing
Scenic/MX2 Interface
| Parameter                   | Min Max | Units Notes |
| --------------------------- | ------- | ----------- |
| VREQ/VRDY active delay      | 2 11    | ns 7 ns typ |
| LD[7:0] valid delay         | 2 15    | ns 8 ns typ |
| LD[7:0] tri-state from LCLK | 7 15    | ns          |
Table 5-14. MCLK-Referenced Output Timing
| Parameter               | Min Max | Units Notes |
| ----------------------- | ------- | ----------- |
| PD[63:0] valid delay    | 5 8     | ns 1        |
| MA[8:0] valid delay     | 6 8     | ns          |
| CAS[7:0] active delay   | 5 12    | ns          |
| CAS[7:0] inactive delay | 5 14    | ns          |
| RAS[1:0] active delay   | 2 6     | ns          |
| RAS[1:0] inactive delay | 0 7     | ns          |
| OE[1:0] active delay    | 6 12    | ns          |
| WE active delay         | 7 12    | ns          |
Note
1. The maximum delay time is for 1-cycle operation.
Table 5-15. SDCLK-Referenced Output Timing
| Parameter               | Min Max | Units Notes |
| ----------------------- | ------- | ----------- |
| PD[63:0] valid delay    | 2 8     | ns          |
| MA[9:0] valid delay     | 5 9     | ns          |
| DQM[7:0] active delay   | 4 8     | ns          |
| DQM[7:0] inactive delay | 8 13    | ns          |
| SDRAS active delay      | 4 8     | ns          |
| SDRAS inactive delay    | 6 11    | ns          |
| SDCAS active delay      | 4 8     | ns          |
| SDCAS inactive delay    | 6 11    | ns          |
| CS active delay         | 4 8     | ns          |
| CS inactive delay       | 6 12    | ns          |
| WE active delay         | 4 8     | ns          |
| WE inactive delay       | 6 12    | ns          |
5-8  ELECTRICAL DATA PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators
Table 5-16. Feature Connector Timing - Output from Trio64V2 to Feature Connector
| Symbol | Parameter                             | Min | Units Notes |
| ------ | ------------------------------------- | --- | ----------- |
| TSU    | PA[15:0], BLANK setup to VCLK rising  | 5   | ns          |
| TH     | PA[15:0], BLANK hold from VCLK rising | 5   | ns          |
Table 5-17. Feature Connector Timing - Output from Feature Connector to Trio64V2
| Symbol | Parameter                     | Min Max | Units Notes |
| ------ | ----------------------------- | ------- | ----------- |
| TSU    | PA[15:0], BLANK setup to VCLK | 6       | ns          |
 rising
| TH  | PA[15:0], BLANK hold from VCLK | 6   | ns  |
| --- | ------------------------------ | --- | --- |
rising
|     | VCLK            | 25 40 | ns 1 |
| --- | --------------- | ----- | ---- |
|     | VCLK duty cycle | 40 60 | %    |
|     | VCLK high time  | 10 25 | ns   |
|     | VCLK low time   | 10 25 | ns   |
|     | VCLK slew rate  | 1 4   | V/ns |
Notes
1. This corresponds to the VESA VAFC specification of a maximum clock of 37.5 MHz.
t
HPW
HSYNC
t D
|     | LD 1st Data |     |     |
| --- | ----------- | --- | --- |
t
VPW
VSYNC
t
SU
t
H
HSYNC
Figure 5-4.  Odd/Even Field Detection Timing
| PRELIMINARY |     |     | ELECTRICAL DATA  5-9 |
| ----------- | --- | --- | -------------------- |

Trio64V2/DX & GX Graphics/Video Accelerators
Table 5-18. Odd/Even Field Detection Timing
| Symbol | Parameter                                | Min    | Max     |
| ------ | ---------------------------------------- | ------ | ------- |
| TD     | Time from HSYNC falling edge to 1st data | 2 m s  |         |
| TSU    | HSYNC high to VSYNC falling edge         | 3 ns   |         |
| TH     | HSYNC high after VSYNC falling edge      | 3 ns   |         |
| THPW   | HSYNC pulse width                        | 1 LCLK | 6 m s   |
| TVPW   | VSYNC pulse width                        | 1 LCLK | 528 m s |
T
LOW
RESET
T
H
SYSTEM
CONFIGURATION
DATA
RESETTM T
SU
Figure 5-5.  Reset Timing
Table 5-19. Reset Timing
| Symbol                | Parameter                         | Min  | Units       |
| --------------------- | --------------------------------- | ---- | ----------- |
| TLOW                  | RESET active pulse width          | 1000 | ns          |
| TSU                   | PD[28:0] setup to RESET inactive  | 20   | ns          |
| TH                    | PD[28:0] hold from RESET inactive | 10   | ns          |
| 5-10  ELECTRICAL DATA |                                   |      | PRELIMINARY |

Trio64V2/DX & GX Graphics/Video Accelerators
Section 6: Mechanical Data
6.1 THERMAL SPECIFICATIONS
| Parameter            |                | Min | Typ | Max | Unit          |
| -------------------- | -------------- | --- | --- | --- | ------------- |
| Thermal Resistance Q | JC             |     | 5   |     | (cid:176) C/W |
| Thermal Resistance Q | JA (Still Air) |     | 24  |     | (cid:176) C/W |
(cid:176)
| Junction Temperature |     |     |     | 125 | C   |
| -------------------- | --- | --- | --- | --- | --- |
6.2 MECHANICAL DIMENSIONS
Trio64V2DX and Trio64V2/GX come in 208-pin PQFP packages. The mechanical dimensions are given
in Figure 6-1.
| PRELIMINARY |     |     |     | MECHANICAL DATA  6-1 |     |
| ----------- | --- | --- | --- | -------------------- | --- |

Trio64V2/DX & GX Graphics/Video Accelerators
30.60 SQUARE (BASIC)
28.0 SQUARE (BASIC)
| 651 |     | 501 |
| --- | --- | --- |
401
751
| 802 |     | 35  |
| --- | --- | --- |
| 1   |     | 25  |
0.50 (BASIC) 0.22±0.05
XAM 01.4
COPLANARITY = 0.08 MAX
ENALP EGAG 52.0 50.0±51.0
| LI N E A R  D I M   | E N S IO N S |     |
| ------------------- | ------------ | --- |
| A R E   IN  M I L L | IM E T E R S | °7  |
 - °0
NIM 52.0 0.60 + 0 . 1 5
- 0 . 1 0
1.30 REF
MECHDIM
Figure 6-1.  208-pin PQFP Mechanical Dimensions
6-2  MECHANICAL DATA PRELIMINARY

Trio64V2/DX & GX Graphics/Video Accelerators

Trio64V2/DX & GX Graphics/Video Accelerators
S3 Incorporated, P.O. Box 58058, Santa Clara, CA 95052-8058 Tel: 408-588-8000, Fax: 408-980-5444
Printed in USA DB028-0.7
