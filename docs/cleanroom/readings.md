# Recommended readings for the clean room

What the clean side reads, in order of authority. A source counts only for its own subject.
A later guide does not add a requirement the standard does not have. Recorded 6 November 2026.
The process is in [`docs/clean-room.md`](../clean-room.md). The files kept in this repository
are catalogued in [`standards/README.md`](../../standards/README.md) and
[`datasheets/`](../../datasheets/).

Among the VGA behaviour guides, Ralf Brown's Interrupt List outranks Ferraro's book (owner,
6 November 2026). Both outrank VGADOC. None of those three outranks the S3 data book, the PCI
specification, a VESA standard, the card's DRAM data sheet, or the IBM BIOS technical reference.

## Standards and data books

| Order | Read | For |
| --- | --- | --- |
| 1 | S3 Trio32/Trio64 data book, March 1995, in [`datasheets/`](../../datasheets/) | The chip: wake-up, unlock, PCI configuration, memory, clocks, registers |
| 2 | PCI Local Bus Specification 2.3, section 6.3, [`standards/pci/pci23.pdf`](../../standards/pci/pci23.pdf) | The option ROM image. Extract: [`primary-extracts/pci-2.3-section-6.3.md`](primary-extracts/pci-2.3-section-6.3.md) |
| 3 | The DRAM data sheet of the parts on the card. V53C16256H for the DSP-3364P is in [`datasheets/`](../../datasheets/) | Power-up and refresh, and how high the memory clock may go on that card. The chip book still sets the chip's own maximum |
| 4 | VBE 1.2, VS911022, [`standards/vesa/vbe12.txt`](../../standards/vesa/vbe12.txt) | The VBE calls this ROM reports. Milestone 4. A later VBE does not add requirements |
| 5 | VESA DMT 1.0 Rev. 10, [`standards/vesa/VESA-DMT-1.0-Rev10.pdf`](../../standards/vesa/VESA-DMT-1.0-Rev10.pdf). DMT 1.13 is a check only | 640x480 at 60 Hz, and later DMT modes |
| 6 | IBM "Personal System/2 and Personal Computer BIOS Interface Technical Reference", April 1987 | INT 10h and the BIOS data area, where that book states them |

VESA DPMS 1.0 (August 1993) is not in hand. It would sit here for the sync states of 4F10h. Until then, the lower DPMS notes below are only a stand-in.

## Guides

| Order | Read | Sits under |
| --- | --- | --- |
| 7 | Ralf Brown's Interrupt List | INT 10h and the BIOS data area. The first guide to consult |
| 8 | Ferraro, "Programmer's Guide to the EGA, VGA, and Super VGA Cards", 3rd edition | The same VGA behaviour, where the Interrupt List is silent. Table 9.23 documents the bytes `IBM` at `C000:001E` |
| 9 | VGADOC 4b, the nine files in [`standards/thoegersen/`](../../standards/thoegersen/) | VBE, the VGA registers, and the S3 book. It has errors; the standard wins. `VESA.TXT` records 4F10h as 00h On, 01h Standby, 02h Suspend, 04h Off |
| 10 | VBE 1.0 (VS891001) and Brad Haakenson, "Examining the VESA VBE 2.0 Specification" (July 1995) | How VBE 1.2 and 2.0 relate. They do not make this ROM a VBE 2.0 BIOS |

## Secondary notes

| Order | Read | Good for |
| --- | --- | --- |
| 11 | X11 DPMS client, 1996 (`dpms.h`, `dpmsconst.h`, `dpmsproto.h`, `DPMS.c`). What it states: [`docs/clean-room.md`](../clean-room.md) "The X11 project" | Level names: On 0, Standby 1, Suspend 2, Off 3. Off is 04h in 4F10h. No sync-line behaviour |
| 12 | The charter.net DPMS explanation | Sync map only, and it is not DPMS 1.0: Normal both on, Standby horizontal off and vertical on, Suspend horizontal on and vertical off, Off both off |
| 13 | Toby Opferman, "How To Use Super VGA (VESA 1.x Non-Linear)" | How a program calls 4F02h and 4F05h |

## Not an input to milestones 1-4

GTF 1.1, E-DDC 1.2, E-EDID Release A Revision 2, CVT 1.2, Joe Miseli's 2007 Xorg EDID talk, VBE/SCI 1.0, and VBE/AF 0.7. They stay for later timings, DDC, or EDID. VBE/SCI and VBE/AF are not video BIOS functions of this ROM.

Gil's FNTCOL16 files ([`rompatch/fonts/`](../../rompatch/fonts/)) are the glyph bits, with his notice. They do not say how a mode set loads a font.

For milestone 1, read rows 1, 2, 3, 6, then 7 and 8. VBE and DMT join at milestone 4.
