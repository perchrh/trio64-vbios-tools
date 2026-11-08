# Third-party reference texts

The order in which the clean room reads these, and the books that are not stored here, is
[`docs/cleanroom/readings.md`](../docs/cleanroom/readings.md). This folder is the catalogue of
the copies. VGADOC sits under the VESA standards and under Ralf Brown's Interrupt List.

## thoegersen/

Nine files from VGADOC 4b by Finn Thøgersen (1991-95), copied unmodified (CRLF line endings, kept
by `.gitattributes`). The author's original site:
[Finn Thøgersen's VGADOC](https://web.archive.org/web/20081217030257/http://home.worldonline.dk/finth/)
(archived at the Wayback Machine).
Its licence, README.1ST, is included unmodified as it requires: the
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

## rbil-all/

Ralf Brown's Interrupt List, release 61 (16 July 2000), copied unmodified. The official source and
new releases: [www.cs.cmu.edu/~ralf/files.html](https://www.cs.cmu.edu/~ralf/files.html). Not public domain:
its notice (in `INTERRUP.1ST`, kept intact) permits use and redistribution in any way, including
conversion to another format, provided Ralf Brown's name and addresses, the contributor credits
and the release information are preserved; the credit requirement is waived for excerpts
totaling less than 2000 lines, and corrections are asked to go to the maintainer rather than be
distributed as modified lists. Programs contributed by others in the distribution keep their
authors' rights.

Of use here: `MEMORY.LST` (the BIOS data area, tables M0024-M0027, cited by
[`docs/bios-rules.md`](../docs/bios-rules.md) BDA-1, BDA-14 to BDA-17), `INTERRUP.A`
(INT 10h, including AH=12h BL=30h-35h), `GLOSSARY.LST`, `BIBLIO.LST`. The reading order is
[`docs/cleanroom/readings.md`](../docs/cleanroom/readings.md) row 9; the list outranks VGADOC and
is outranked only by the standards and data books.
