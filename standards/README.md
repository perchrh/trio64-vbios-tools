# Third-party reference texts

## thoegersen/

Nine files from VGADOC 4b by Finn Thoegersen (1991-95), copied unmodified (CRLF line endings, kept
by `.gitattributes`). Its licence, README.1ST, is included unmodified as it requires: the
information may be used in any project, the collection or a subset may be redistributed free of
charge with README.1ST, and the source must be credited. It is a subset, so it is not distributed
under VGADOC's name.

| File | Contents | Use here |
| --- | --- | --- |
| README.1ST | Licence and contact | Required with every copy |
| INTRO.TXT | Introduction, notation, terms | How to read the others |
| VGABIOS.TXT | The standard INT 10h functions (AH=00h-1Ch), in Ralf Brown's style | Interface reference for the standard VGA functions, the AH=1Bh state table and AH=1Ch |
| VGAREGS.TXT | The VGA registers | Register meanings |
| EGAREGS.TXT, CGA.TXT | EGA and CGA registers | The EGA and CGA modes (00h-07h, 0Dh-10h) |
| VESA.TXT | VBE 1.0-2.0 and 4F10 (VBE/PM) | Quick reference; the VESA standards decide (README "VESA standards") |
| S3.TXT | S3 chips up to the Trio32/Trio64: IDs, extended CR and SR registers, PLLs, S3 INT 10h functions and mode lists of S3 boards | Cross-check of the data books and of the S3 mode numbers |
| PCI.TXT | PCI configuration mechanisms and the PCI BIOS (INT 1Ah B1xxh) | What POST uses to find the card |

Left out: the other vendors' chips, the monitor list, external clock and RAMDAC chips, and the
WHATVGA programs. The `phatcode.exe` that came in the downloaded archive is not part of VGADOC.
