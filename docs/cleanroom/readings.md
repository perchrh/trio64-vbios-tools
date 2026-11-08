# Ranked information sources for the clean room

What the clean side may rely on, in order of authority, for a Trio64 ROM and milestones 1-4
on the DSP-3364P. Recorded 6 November 2026. The process is in
[`docs/clean-room.md`](../clean-room.md). Copies kept in this repository are catalogued in
[`standards/README.md`](../../standards/README.md) and [`datasheets/`](../../datasheets/).

A source counts only for its own subject. When two sources disagree, the one that owns the
subject wins. A guide does not add a requirement the standard does not have.

Among the VGA behaviour guides, Ralf Brown's Interrupt List outranks Ferraro's book (owner,
6 November 2026). Both outrank VGADOC. None of those three outranks the S3 data book, the PCI
specification, a VESA standard, the card's DRAM data sheet, or the IBM BIOS technical reference.

## 1. Standards and data books

Cite these first.

| Order | Source | Authority for |
| --- | --- | --- |
| 1 | S3 Trio32/Trio64 data book, March 1995, in [`datasheets/`](../../datasheets/) | The chip: wake-up, unlock, PCI configuration, memory, clocks, registers |
| 2 | PCI Local Bus Specification 2.3, section 6.3, [`standards/pci/pci23.pdf`](../../standards/pci/pci23.pdf). Extract: [`primary-extracts/pci-2.3-section-6.3.md`](primary-extracts/pci-2.3-section-6.3.md) | The option ROM image: header, PCIR, initialisation entry, AX = bus/device/function, checksum |
| 3 | The DRAM data sheet of the parts on the card. V53C16256H for the DSP-3364P is in [`datasheets/`](../../datasheets/) | Power-up and refresh, and how high the memory clock may go on that card. The chip book still sets the chip's own maximum |
| 4 | VBE 1.2, VS911022, [`standards/vesa/vbe12.txt`](../../standards/vesa/vbe12.txt) | The VBE version this ROM reports. Milestone 4 calls (4F00h, 4F01h, 4F02h, the window) |
| 5 | VBE 2.0, [`standards/vesa/vbe20.pdf`](../../standards/vesa/vbe20.pdf) | Read with 1.2. It clarifies those functions and records what 2.0 added. Milestone 4 does not take a 2.0-only requirement from it |
| 6 | VBE 3.0, owner's copy `vbe3.pdf` (September 1998). Not posted here: VESA allows only VBE 2.0 online | Read where it clarifies VBE 2.0. It does not add VBE 3 functions to milestones 1-4 |
| 7 | VESA DMT 1.0 Rev. 10, [`standards/vesa/VESA-DMT-1.0-Rev10.pdf`](../../standards/vesa/VESA-DMT-1.0-Rev10.pdf). DMT 1.13 is a check only | 640x480 at 60 Hz, and later DMT modes |
| 8 | IBM "Personal System/2 and Personal Computer BIOS Interface Technical Reference", April 1987 | INT 10h and the BIOS data area, where that book states them |

VESA DPMS 1.0 (August 1993) is not in hand. When it is, it sits in this group for the sync states of 4F10h. Until then the DPMS notes in section 3 are only a stand-in.

## 2. Guides to those standards

Use these when the standard is silent or hard to apply.

| Order | Source | Sits under |
| --- | --- | --- |
| 9 | Ralf Brown's Interrupt List, release 61 (16 July 2000), in [`standards/rbil-all/`](../../standards/rbil-all/) (the BIOS data area in `MEMORY.LST`, tables M0024-M0027; the notice in `INTERRUP.1ST`) | The first guide for INT 10h and the BIOS data area |
| 10 | Ferraro, "Programmer's Guide to the EGA, VGA, and Super VGA Cards", 3rd edition (1994, ISBN 0-201-62490-7); a readable copy is at the Internet Archive: [archive.org/details/programmersguidetotheegavgaandsupervgacardsbyrichardf.ferraro19943rdedition](https://archive.org/details/programmersguidetotheegavgaandsupervgacardsbyrichardf.ferraro19943rdedition) | The same VGA behaviour, where the Interrupt List is silent. Table 9.23 documents the bytes `IBM` at `C000:001E` |
| 11 | VGADOC 4b, the nine files in [`standards/thoegersen/`](../../standards/thoegersen/) | VBE, the VGA registers, and the S3 book. It has errors; the standard wins. `VESA.TXT` records 4F10h as 00h On, 01h Standby, 02h Suspend, 04h Off |
| 12 | VBE 1.0 (VS891001) and Brad Haakenson, "Examining the VESA VBE 2.0 Specification" (July 1995) | How VBE 1.2 and 2.0 relate. They sit under the VBE 2.0 text, which is row 5 |

## 3. Secondary explanations

Useful, and not a specification.

| Order | Source | What it is good for |
| --- | --- | --- |
| 13 | X11 DPMS client, 1996 (`dpms.h`, `dpmsconst.h`, `dpmsproto.h`, `DPMS.c`). What it states: [`docs/clean-room.md`](../clean-room.md) "The X11 project" | Level names only: version 1.2, On 0, Standby 1, Suspend 2, Off 3, and the timeout order. Off is 04h in 4F10h. No sync-line behaviour |
| 14 | DPMS explanations, not the 1993 standard. The charter.net page, and the link collection at [VESA Display Power Management Signaling](https://grokipedia.com/page/VESA_Display_Power_Management_Signaling) | The sync map: On both active, Standby horizontal inactive and vertical pulsed, Suspend horizontal pulsed and vertical inactive, Off both inactive. The collection cites the X.Org DPMS extension for that table. It is a finding aid, not a text to implement from |
| 15 | Toby Opferman, "How To Use Super VGA (VESA 1.x Non-Linear)" | How a program calls 4F02h and 4F05h. An application note, below VBE 1.2 |

## 4. Authoritative in their own subject, not for milestones 1-4

GTF 1.1, E-DDC 1.2, E-EDID Release A Revision 2, Joe Miseli's 2007 Xorg EDID talk, VBE/SCI 1.0, and VBE/AF 0.7. Keep them for later timings, DDC, or EDID. VBE/SCI and VBE/AF are not functions of this ROM.

CVT 1.2 (copyright 2003-2013; the file checked 6 November 2026) is not a source for a 1995-1999 VGA BIOS. It defines timings from 2003 onward. It does not contain the IBM VGA timings or a video BIOS. The one occurrence of "VGA" in it is the name "quarter-VGA" for 320x240. A second copy of the same PDF adds nothing.

MCCS 2.2a (VESA Monitor Control Command Set, 13 January 2011, copyright 2006-2011) is not a source for that BIOS either. It is VCP codes a monitor accepts over DDC/CI. It has no VGA mode set and no option ROM.

A monitor made after 2003, including one from 2013, does not change this when it is plugged into the VGA connector. It locks to the timings the card already sends (IBM and DMT). It does not ask the BIOS to compute CVT timings. MCCS is only for optional controls such as brightness, and the picture does not depend on it.

## 5. Not a behaviour source

- Gil's FNTCOL16 files ([`src/roms/fonts/`](../../src/roms/fonts/)) are the glyph bits, with his notice. They do not say how a mode set loads a font.
- A reference BIOS image, an oracle, or a Phoenix observation checks a result. It is not a source to cite.

## How to use the order

Milestone 1 reads rows 1, 2, 3 and 8, then 9 and 10. VBE and DMT are not required for POST text.

Milestone 4 reads rows 4, 5 and 7 with those: VBE 1.2 for the calls, VBE 2.0 beside it, and DMT for 640x480 at 60 Hz. VBE 3.0 (row 6) is read with VBE 2.0 where it clarifies 2.0, and it adds no milestone 1-4 function.
