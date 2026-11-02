# The clean-room package

What the clean side gets for writing a Trio64 video BIOS from scratch (decided 2 November 2026,
[#145](https://github.com/perchrh/trio64-vbios-tools/issues/145); the earlier plan built on SeaVGABIOS: [`docs/seavgabios-trio64.md`](../seavgabios-trio64.md)), what stays on the dirty side, and how the result is checked. The process
and its reasons are in [`docs/clean-room.md`](../clean-room.md). Prepared 1 November 2026. The first leak review (1 November) removed the references to dirty-side
documents from [`spec-a-post.md`](spec-a-post.md); what remains for a second reader is listed under "Leak review".

**Status, 2 November 2026.** An outside review ([`review-2026-11-02.md`](review-2026-11-02.md)) found the package not yet ready
to implement from:
- MODE-130's refresh count and POST-23's example are corrected since.
- Decided by the owner on 2 November 2026 ([#145](https://github.com/perchrh/trio64-vbios-tools/issues/145), [`docs/clean-room.md`](../clean-room.md) "Decisions of 2 November 2026"):
  - the base: empty, a full new BIOS written from scratch, with the fonts of [`rompatch/fonts/`](../../rompatch/fonts/);
  - SeaVGABIOS kept as a comparison implementation;
  - the size budget: the whole 32 KB, about 9.7 KB of fonts, about 23 KB for code and tables;
  - release terms: the MIT licence;
  - no patched ROM images uploaded by CI; the reference ROMs stay in the repository for now;
  - the scope: two milestones on the DSP-3364P. (1) The card posts and shows a picture with readable
    text; glitches are allowed and nothing after POST is required. (2) MS-DOS 6.22 boots, and MS-DOS
    EDIT loads, edits and saves a file without significant glitches. Parts B and C and
    [`freedos-1.4.md`](freedos-1.4.md) are for later milestones.
- Added to part A since: PCI 2.3 section 6.3 as the source of the option ROM rules, and the DRAM
  power-up of the card (POST-41).
- The test harness fixes (#143) are in place: `post` fails a POST that does not return, and
  `S3TEST /C` with the emulator test `s3test_any` runs the set that needs no ROM of ours.
- Still open:
  - the record of the INT 10h calls MS-DOS 6.22 and EDIT make on the card (the contract of milestone 2);
  - the licence file and the asset manifest;
  - the export of a reviewed allowlist at a fixed commit to a separate repository;
  - the second-reader leak review, whose handover is in [`LEAK-REVIEW.md`](LEAK-REVIEW.md).

**On the base:** the specifications describe behaviour; their rules hold for the ROM written from scratch. Their introductions say so, and where they mention SeaVGABIOS it is the comparison implementation.

## Files here

| File | Side | What it is |
| --- | --- | --- |
| [`BRIEF.md`](BRIEF.md) | dirty | the rules the specification was written under |
| [`LEAK-REVIEW.md`](LEAK-REVIEW.md) | dirty | how a file is reviewed before it crosses, and how the result is recorded |
| [`spec-a-post.md`](spec-a-post.md) | goes across after the leak review | POST start-up, the conventions drivers rely on, the PCI ROM header (plan items 1, 4, 6) |
| [`spec-b-modeset.md`](spec-b-modeset.md) | goes across after the leak review | the S3 mode set: DMT timings, clocks, colour modes, display FIFO, return to VGA (item 2) |
| [`spec-c-vbe.md`](spec-c-vbe.md) | goes across after the leak review | VBE 1.2 (4F00-4F08), the S3 mode numbers and 4F14h (items 3, 5) |
| [`freedos-1.4.md`](freedos-1.4.md) | goes across | what FreeDOS 1.4 asks of the video BIOS (a later milestone since 2 November 2026), from its sources |
| [`freedos-reports.md`](freedos-reports.md) | goes across | drafts of the MORE and MODE defect reports to FreeDOS |
| [`review-2026-11-02.md`](review-2026-11-02.md) | dirty only | the outside feasibility review of 2 November 2026: its findings, our checks and where each went |
| [`oracle-a-post.md`](oracle-a-post.md), [`oracle-b-modeset.md`](oracle-b-modeset.md), [`oracle-c-vbe.md`](oracle-c-vbe.md) | dirty only | what the reference ROMs do in the emulator and on the card, compared with the specification; the expected values for checking the clean ROM, never handed over |

## What goes to the clean side

- The three specification files above, after the leak review.
- The public documents: the S3 Trio32/Trio64 data book ([`datasheets/`](../../datasheets/)), VBE 2.0 ([`standards/vesa/`](../../standards/vesa/)),
  the VBE 1.2 text, VGADOC ([`standards/thoegersen/`](../../standards/thoegersen/)), and the other public sources of
  [`docs/clean-room.md`](../clean-room.md) "Public documents for the clean side".
- [`docs/chip-rules.md`](../chip-rules.md): rules from the data books only, except its section "S3 OEM functions (4F14h)",
  which is taken from BIOS images and goes only through [`spec-c-vbe.md`](spec-c-vbe.md).
- [`docs/bios-rules.md`](../bios-rules.md), after a leak review of its open questions: its rules rest on public sources, but
  its open-question lists were written while reading another vendor's BIOS source.
- SeaVGABIOS (branch `claude/slim-vgabios` of perchrh/seabios_fork), under its LGPLv3, as a comparison
  implementation and a source of facts: none of its code goes into the ROM.
- The test tools as programs and their result lines (S3TEST, S3COMPAT, VSHOW, VGALOG, S3REGS): what
  they check is stated in their headers from public sources.

## What stays on the dirty side

The reference ROMs ([`reference/`](../../reference/)), the patched ROMs and their code ([`rompatch/`](../../rompatch/)), the oracle files,
riplin's disassembly, [`docs/764-rom.md`](../764-rom.md), the README sections on byte-level changes, the
emulator tests that compare with a reference ROM (`make 775-ref-compare`, `764-ref-compare`, the `T64_BASE`
notes), and anything from another vendor's BIOS source.

## Checking the clean ROM (on the dirty side)

1. **Emulator**: `make emu-test ROM=CLEAN.BIN CHIP=764` with 2, 4 and 1 MB. The tests tagged `patch`
   (our ROMs' patches, and `s3test` with our ROM's signature) are skipped for a ROM that is not ours.
   `s3test_any` runs `S3TEST /C` instead: the set that needs no ROM of ours (checksum, MCLK, VGA
   clear, font load, the scrolls, AH=09h, timings), on any chip, with the version as INFO (#143).
   It is 8 result lines: the mode list and the VBE checks of S3TEST are our ROMs' and have no clean
   counterpart yet. S3COMPAT and VSHOW run in full. `post` checks the ROM header without running it
   and fails a POST that does not return (#143). On the card, run `S3TEST /C`.
2. **The oracle**: the register state after POST and after each mode set compared with
   [`oracle-a-post.md`](oracle-a-post.md) and [`oracle-b-modeset.md`](oracle-b-modeset.md), the 4F00/4F01 blocks with [`oracle-c-vbe.md`](oracle-c-vbe.md). Where the
   oracle notes a reference value that the specification deliberately does not follow (non-DMT
   timings, the FIFO M), the specification wins.
3. **Similarity**: `python3 emu/similarity.py CLEAN.BIN --fonts S-E ... --tables S-E ...` lists
   every byte run of 32 or more that the clean ROM shares with Phoenix 1.5-07, S3 1.03-08 and S3
   2.04.07, apart from the font tables and the tables a public standard defines (give their offsets,
   from `nm out/vgarom.o`). Exit code 1 when any other run is found; each one is investigated.
   The slim SeaVGABIOS of 1 November 2026 passes with its three fonts (`vgafont8`, `vgafont14`,
   `vgafont16`) and the IBM video parameter and save pointer tables given:

       python3 emu/similarity.py slim.bin --fonts 409E-509D --fonts 509E-5E9D --fonts 5E9E-669D --tables 38B8-4053

4. **On the card**: [`docs/seavgabios-trio64.md`](../seavgabios-trio64.md) "Clean-room steps", step 4 (written for the SeaVGABIOS
   plan; the card steps hold for the ROM written from scratch).

## Leak review

The procedure is in [`LEAK-REVIEW.md`](LEAK-REVIEW.md), with the handover for the second reader (2 November 2026); the results are recorded here. Done once on 1 November 2026 by the dirty side (a search of the three specification files for
Phoenix, the reference ROMs, [`rompatch/`](../../rompatch/), [`docs/764-rom.md`](../764-rom.md) and riplin, then a reading of the
hits). Left for a second reader to judge:

- [`spec-c-vbe.md`](spec-c-vbe.md) 4F14h (OEM-1 to OEM-7) and the open questions on the S3 mode numbers rest on
  the observed behaviour of S3's BIOSes, not on a public document; they cross as behaviour only.
- [`spec-b-modeset.md`](spec-b-modeset.md): the PLL values for 25.175 MHz (SR12 61h, SR13 28h) equal the reference ROM's,
  because both follow the data book's procedure 9.1; the derivation is in the rule.
- [`docs/chip-rules.md`](../chip-rules.md): four sentences on what Phoenix's BIOSes do (T64-MEM-9, and the CR61/CR62,
  CR3B and fixed-M notes of "Related chip: the Vision864") carry a leak review note: observed BIOS
  behaviour, to keep as behaviour or cut from the clean side's copy.
- Part B and part C agree on the mode list: 102h and 104h are part C's (VBE-10), 4F01 reports 32 bits
  per pixel for the 4-byte modes (MQ-9, MQ-15 of part B answered).

## Font origin (to settle before distribution)

The similarity check shows SeaVGABIOS's 8x8, 8x14 and 8x16 fonts byte for byte equal to S3's and
Phoenix's fonts over runs of up to 3.6 KB: all of them carry the IBM VGA font.

Since 2 November 2026 (#141) our patched ROMs build all five font tables from Joseph Gil's FNTCOL16 files in [`rompatch/fonts/`](../../rompatch/fonts/). That folder holds the unmodified files and Gil's notice: the individual fonts public domain, and the US Copyright Office position that bitmap fonts are not registrable (57 FR 6201). The tables include the 9-dot alternates, taken from PP_ROMAN.F16 and STANDARD.F14.

Those files are the clean side's candidate font source. They equal IBM's glyphs byte for byte, though, so whether they are free to distribute everywhere (not only in the US) is still a question for the lawyer of [`docs/clean-room.md`](../clean-room.md); the FreeDOS cpidos fonts (GPL 2 or later) remain the named alternative. The similarity check excludes font ranges given with `--fonts`, but that says nothing about their provenance.
