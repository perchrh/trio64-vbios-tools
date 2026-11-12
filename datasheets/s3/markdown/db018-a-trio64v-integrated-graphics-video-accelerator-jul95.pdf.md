ConfigureResultCode

S3 Incorporated logo: a stylized black “S3” mark, with the text “S3 Incorporated”.

# **Trio64V+ Integrated Graphics/Video Accelerator**

## **Table 3-1. Pin Descriptions - LPB Mode (Continued)**

| **Symbol** | **Type** | **Pin Number(s)** | **Description** |
| --- | --- | --- | --- |
| HSYNC | B | 149 | Horizontal Sync. When ESYNC (or VFCESYNC) is high, this is the horizontal sync output. When ESYNC is low, this is an input from the feature connector. |
| VSYNC | B | 150 | Vertical Sync. When ESYNC (or VFCESYNC) is high, this is the vertical sync output. When ESYNC is low, this is an input from the feature connector. |
| PA[15:0] | B | 201-199, 189- 185, 202, 184, 175, 174, 155, 154, 147, 146 | Pixel Address Lines [15:0]. The PA[15:0] function is enabled on the pins indicated for PCI configurations when LPB feature connector operation is enabled. Only PA[7:0] are enabled for VL-Bus configurations. The PA function is on the pins indicated for VFCPA[15:0] when Trio64-compatible VAFC operation is enabled. When EVIDEO (or VFCEVIDEO) is high, PA signals are outputs to the feature connector. When EVIDEO is low, PA signals are inputs and are sampled by VCLKI if bit 1 of SRB is set to 1. |
| VFCPA[15:0] | B | 144, 142, 140, 138, 134, 132, 130, 128, 127, 129, 131, 133, 136, 139, 141, 143 |
| **MISCELLANEOUS FUNCTIONS** | | | |
| **General Data, I/O and Serial Ports** | | | |
| GA[15:0] | O | 105, 103, 101, 98, 95, 93, 91, 89, 88, 90, 92, 94, 97, 100, 102, 104 | (PCI) General Address Bus. These signals provide the address for BIOS ROM reads. They are multiplexed with PD signals. Programmers must ensure that the memory bus is inactive when reading the ROM. |
| GD[7:0] | I | 53, 55, 57, 59, 63, 65, 67, 69 | (PCI) General Data Bus. These signals carry data for BIOS ROM reads. They are multiplexed with PD signals. Programmers must ensure that the memory bus is inactive when reading the ROM. |
| <u>ROMEN</u> | O | 153 | (PCI) ROM Enable. This signal provides the chip output enable input for BIOS ROM reads. |
| <u>ROMCS</u> | O | 153 | (VL) ROM Chip Select. This signal provides the chip output enable for BIOS ROM reads. It is output when bits 1-0 of SR1C are any value except 11b. |
| <u>GPIOSTR</u> | O | 151 | (VL) General Input/Output Port Write Strobe. If SR1C\_1-0 are 01b, this is asserted whenever a General Input Port access (CR55\_2 is set to 1 and the 3C8H port is read) or a General Output Port access (write to CR5C) is made. |
| GOP[1:0] | O | 190, 151 | (PCI) General Output Port Bits 1-0. If SR1C\_1 is set to 1, the value of CR5C\_0 is output on pin 151 (GOP0) and the value of CR5C\_1 is output on pin 190 (GOP1). |
| GOP[1:0] | O | 153, 151 | (VL) General Output Port Bits 1-0. If bit 1 of SR1C is set to 1, the value of CR5C\_0 is output on pin 151 (GOP0). If SR1C\_1-0 are 11b, the value of CR5C\_1 is output on pin 153 (GOP1) |

PINS 3-9

S3 Incorporated logo: a stylized black “S3” mark, with the text “S3 Incorporated”.

# **Trio64V+ Integrated Graphics/Video Accelerator**

## **Table 3-1. Pin Descriptions - LPB Mode (Continued)**

| **Symbol** | **Type** | **Pin Number(s)** | **Description** |
| --- | --- | --- | --- |
| STWR‾\overline{\text{STWR}}STWR | O | 190 | (PCI) Strobe Write. If SR1C\_1 is cleared to 0, this signal is asserted whenever a write is made to CR5C. It is used to enable a General Output Port latch. |
| SPCLK | I/O | 205 | Serial Port Clock. This is the clock for serial data transfer, either for I2C or DDC2 monitor data communications. As an output, it is programmed via MMFF20\_0. As an input, its status is read via MMFF20\_2. In either case the serial port must be enabled by setting MMFF20\_4 to 1. PD[26:25] can be strapped to allow I/O (E2H or E8H) access to the Serial Port register while the Trio64V+ is disabled. |
| SPD | I/O | 206 | Serial Port Data. This is the data signal for serial data transfer, either for I2C or DDC2 monitor data communications. As an output, it is programmed via MMFF20\_1. As an input, its status is read via MMFF20\_3. In either case the serial port must be enabled by setting MMFF20\_4 to 1. PD[26:25] can be strapped to allow I/O (E2H or E8H) access to the Serial Port register while the Trio64V+ is disabled. |
| **LOCAL PERIPHERAL BUS** | | | |
| **Scenic/MX2 Mode** | | | |
| LD[7:0] | I/O | 202, 184, 175, 174, 155, 154, 147, 146 | LPB Data. This is the Scenic Highway data bus and carries compressed data to the Scenic/MX2 and video data from the Scenic/MX2. |
| LCLK | I | 148 | LPB Clock. This clock controls transactions between the Trio64V+ and Scenic Highway peripherals |
| VREQ‾\overline{\text{VREQ}}VREQ​/VRDY | O | 203 | Video Request/Ready. This signal is part of the the Scenic Highway data transfer protocol between the Trio64V+ and the Scenic/MX2. |
| CREQ‾\overline{\text{CREQ}}CREQ​/CRDY | I | 204 | Scenic/MX2 Request/Ready. This signal is part of the the Scenic Highway data transfer protocol between the Trio64V+ and the Scenic/MX2. |
| ENFEAT‾\overline{\text{ENFEAT}}ENFEAT | O | 151 | Enable Feature Connector. This signal is connected to the Scenic/MX2 chip enable input such that the Scenic/MX2 is disabled when feature connector operation is enabled. |

3-10 PINS

S3 Incorporated logo: a stylized black “S3” mark, with the text “S3 Incorporated”.

# **Trio64V+ Integrated Graphics/Video Accelerator**

## **Table 3-1. Pin Descriptions - LPB Mode (Continued)**

| **Symbol** | **Type** | **Pin Number(s)** | **Description** |
| --- | --- | --- | --- |
| **Video 8 in and Video 16 (PCI only) Modes** | | | |
| LD[7:0] | I | 202, 184, 175, 174, 155, 154, 147. 146 | LPB Data Bus [7:0]. This is the Scenic Highway data bus and carries video data input. |
| LD[15:8] | I | 201-199, 189- 185 | (PCI) LPB Data Bus [15:8]. Scenic Highway video data input for the upper data byte in Video 16 mode. |
| HS | I | 203 | HSYNC. HSYNC input signaling the transition from one line to the next. |
| VS | I | 204 | VSYNC. VSYNC input signaling the transition from one frame to the next. |
| HD[7:0] | O | 201-199, 189- 185 | Host Data. CL-480 compressed data. |
| HSEL[2:0] | O | 178-176 | Host Select. These signals select one of five CL-480 host interface registers. |
| **Video 8 In/Out Mode (CL-480) (PCI only)** | | | |
| LD[7:0] | I | 202, 184, 175, 174, 155, 154, 147. 146 | LPB Data Bus [7:0]. This is the Scenic Highway data bus and carries video data input. |
| DS‾\overline{\text{DS}}DS |  | 179 | Data Strobe. The Trio64V+ asserts this signal to select the CL-480 for a read or write operation. |
| R/W‾\overline{\text{W}}W | O | 180 | Read/Write. The Trio64V+ drives this signal high to specify a CL-480 read cycle and low to specify a write cycle. |
| DTACK‾\overline{\text{DTACK}}DTACK | I | 181 | Data Acknowledge. The CL-480 asserts this signal when it latches compressed data from the Trio64V+ or when it has placed video data on LD[7:0]. This is an open drain signal. |
| CFLEVEL | I | 182 | Compressed Data FIFO Level. When this signal is low, the CL-480 FIFO has room for at least 44 bytes of compressed data. This is an open drain signal. |
| **POWER AND GROUND** | | | |
| VDD | I | 12, 37, 62, 81, 96, 137, 192 | Digital power supply |
| AVDD | I | 164, 169, 170 | Analog power supply (RAMDAC) |
| CLKAVDD[1:2] | I | 158, 160 | Analog power supply (clock synthesizer) |
| VSS | I | 9, 22, 32, 47, 60, 71, 87, 99, 114, 123, 126, 135, 145, 195 | Digital ground |
| AVSS | I | 159, 161, 163, 167, 173 | Analog ground |

PINS 3-11

S3 Incorporated logo: a stylized black “S3” mark, with the text “S3 Incorporated”.

**Trio64V+ Integrated Graphics/Video Accelerator**

## **3.3 PIN LISTS**

Table 3-2 lists all Trio64V+ pins alphabetically. The pin number(s) corresponding to each pin name are
given in the appropriate bus interface type column. Table 3-3 lists all pins in numerical order. The
corresponding pin name/pin number is given in the appropriate bus interface column.

## **Table 3-2. Alphabetical Pin Listing**

|  | **PIN(S)** | |
| --- | --- | --- |
| **Name** | **PCI** | **VL** |
| AB | 172 | 172 |
| AD[31:0] | 207-208, 1-6, 10-11, 13-18, 28-31, 33-36, |  |
|  | 39-46 |  |
| AG | 171 | 171 |
| AR | 168 | 168 |
| AVDD | 164, 169, 170 | 164, 169, 170 |
| AVSS | 159, 161, 163, 167, 173 | 159, 161, 163, 167, 173 |
| <u>BLANK</u> | 191 | 206 |
| <u>CAS[3:0]</u> | 82, 83, 85, 86 | 82, 83, 85, 86 |
| <u>CAS[7:4]</u> | 52, 51, 49, 48 | 52, 51, 49, 48 |
| <u>C/BE[3:0]</u> | 7, 19, 27, 38 |  |
| <u>CLKAVDD[1:2]</u> | 158, 160 | 158, 160 |
| <u>CREQ/CRDY</u> | 204 | 204 |
| <u>DEVSEL</u> | 24 |  |
| <u>ENFEAT</u> | 151 | 151 |
| ESYNC | 183 | 205 |
| EVCLK | 204 | 204 |
| EVIDEO | 203 | 203 |
| <u>FRAME</u> | 20 |  |
| GA[15:0] | 105, 103, 101, 98, 90, 92, 94, 97, |  |
|  | 100, 102, 104 |  |
| GD[7:0] | 53, 55, 57, 59, 63, 65, 67, 69 |  |
| GOP[1:0] | 190, 151 | 153, 151 |
| <u>GPIOSTR</u> |  | 151 |
| HD[7:0] | 201-199, 189-185 |  |
| HS | 203 | 203 |
| HSYNC | 149 | 149 |
| <u>IDSEL</u> | 8 |  |
| <u>INTA</u> | 152 |  |
| <u>IRDY</u> | 21 |  |
| LCLK | 148 | 148 |
| LD[7:0] | 202, 184, 175, 174, 155, 154, 147, 146 | 202, 184, 175, 174, 155, 154, 147, 146 |
| LD[15:8] | 201-199, 189-185 |  |
| <u>LOCA</u> |  | 24 |
| MA[8:0] | 80, 78, 76, 74, 72,73, 75, 77, 79 | 80, 78, 76, 74, 72, 73, 75, 77, 79 |

3-12 PINS

S3 Incorporated logo: a stylized black “S3” mark, with the text “S3 Incorporated”.

# **Trio64V+ Integrated Graphics/Video Accelerator**

Tell us how we did