# Leak review: instructions

How to review a file before it crosses from the dirty side to the clean side ([`docs/clean-room.md`](../clean-room.md)
"The process", step 2). The aim: what crosses describes behaviour that a public source or a black-box
observation supports, and nothing in it expresses a reference BIOS's code or data. This is not legal
advice; the lawyer of [`docs/clean-room.md`](../clean-room.md) judges the process as a whole.

## Who reviews

- Not the author of the file. A person or a separate agent session that may read the dirty material
  (the reference ROMs, the oracle files, [`docs/764-rom.md`](../764-rom.md)) to compare with, but has not written
  the file under review.
- Never with the Phoenix VGA BIOS source material or riplin's disassembly open: the reviewer compares
  against the reference ROMs' observed behaviour and bytes, not against anyone's source.
- What the reviewer may read and what not is listed under "What the reviewer may read, and what not"
  below.

## What is reviewed

Everything that goes to the clean side, each time it changes:

- [`spec-a-post.md`](spec-a-post.md), [`spec-b-modeset.md`](spec-b-modeset.md), [`spec-c-vbe.md`](spec-c-vbe.md);
- [`docs/chip-rules.md`](../chip-rules.md) (the clean side's copy) and [`docs/bios-rules.md`](../bios-rules.md) with its open questions;
- every answer given through the wall ([`docs/clean-room.md`](../clean-room.md) step 4) before it is added to a
  specification;
- test expectations moved to the clean repository ([`docs/clean-room.md`](../clean-room.md) "Next steps").

The oracle files, [`BRIEF.md`](BRIEF.md) and this file never cross and are not reviewed.

## The checks, in order

1. **Search.** Look for names that point at dirty material, then read each hit in its sentence:

       grep -n -i -E 'phoenix|riplin|reference rom|reference/|rompatch|src/roms|backport|oracle|s3patch|1\.5-07|1\.03-08|2\.04\.0|2\.04\.1|-p[0-9]+\b' FILE
       grep -n -E '\b[0-9A-F]{4}h?:[0-9A-F]{4}h?\b|\b[0-9A-F]{4}h-[0-9A-F]{4}h\b' FILE

   The second line finds ROM offsets and address ranges, which describe a BIOS image, not behaviour.
   Also read every sentence that carries a `[Leak review: ...]` note.

2. **Sources.** Every rule names a source in its Source column: the data book (T32/64 with section or
   table, or a [`docs/chip-rules.md`](../chip-rules.md) rule ID that rests on one), VESA, the IBM references, VGADOC, or
   a black-box observation stated as such. A rule without one is returned to the author.

3. **Values.** For every register value, table, timing and constant, ask where it comes from:
   - derived from a public source by a formula or procedure the rule states: keeps;
   - equal to the reference ROM's value but derivable (for example the data book's PLL procedure
     gives the same SR12/SR13 pair): keeps, with the derivation in the rule;
   - taken only from the reference ROM: returned to the author, to derive it or turn it into an open
     question.

   Compare with the oracle file of the same part: a value the spec states that the oracle shows only
   in the reference ROM, with no derivation, is a leak.

4. **Expression.** The text describes inputs, outputs, register states, ranges, error cases and order
   constraints. Returned to the author:
   - instruction sequences, pseudo-code that follows a BIOS's routine structure, or the order of
     operations of a routine where no standard or the data book requires that order;
   - a BIOS's table layout, field order or encoding (per-mode register blocks, refresh lists, mode
     map records), unless a public standard defines it (the IBM video parameter table, the VBE
     information blocks);
   - comments, names or strings copied from a BIOS (routine names, labels, the sign-on text).

5. **Observed BIOS behaviour.** A sentence that says what a reference BIOS does (marked
   `[Leak review: ...]`, or found in step 1) is allowed only when:
   - it is something a program can see from outside (register values after a call, return values,
     memory contents), and
   - the clean side needs it: compatibility with programs or drivers written for that BIOS (the S3
     mode numbers, 4F14h), or a warning about a behaviour not to copy.

   Rewrite it without the BIOS's name where the behaviour alone is enough ("a BIOS may leave
   CR61/CR62 written; they have no function on the Trio64"). Cut it from the clean side's copy where
   the clean side does not need it.

6. **Byte runs.** Any table in the file longer than 32 bytes is checked against the reference ROMs
   (write it to a file and run `python3 emu/similarity.py FILE --min 16`); a run found is investigated
   as in step 3.

## Recording the result

Per file and review, add a section to the "Leak review" part of [`docs/cleanroom/README.md`](README.md):

- the date, the file and its commit, the reviewer;
- each finding with its decision: **keep** (and why), **rewrite** (the new text), **cut** (from the
  clean side's copy), or **returned** (to the author, with the question);
- the items left for the lawyer, if any.

Remove a `[Leak review: ...]` note when its sentence is decided: rewritten, cut, or kept with the
reason recorded. A file crosses only when every finding is decided and nothing is returned.

## Handover to the reviewer (7 November 2026)

Prepared by the dirty side (the author of the files under review); the review itself, steps 1-6 above,
is the reviewer's. Review the files as they are on `main` at the commit you start from, and name that
commit in the record (`e224454` when this handover was written).

This is the second pass. The independent review of 2 November 2026, at commit
`cbbc2ce629f22c5ffa9b4cfeb60200df8fc1396d`, returned every file and cleared no rule ID
([`README.md`](README.md) "Authorized independent review - 2026-11-02"). Since then the dirty side has
rewritten the returned places, and the owner has decided several returns
([`decisions-milestones-1-4.md`](decisions-milestones-1-4.md)). This pass reads the files under review in
full again, as they now stand, and says for each return in that record whether it is settled. A rule ID
crosses only when this pass clears it; the keep, rewrite and cut decisions of 2 November are not
clearance.

### Scope of this review

Decided by the owner on 2 November 2026 ([#145](https://github.com/perchrh/trio64-vbios-tools/issues/145)): the review covers a clean-room implementation of
milestones 1-4 ([`docs/clean-room.md`](../clean-room.md) "Decisions of 2 November 2026"): the card posts with readable
text; MS-DOS 6.22 with EDIT; Superscape 3D Bench 1.0c; Chris's 3D Benchmark in 320x200 and 640x480
VESA. What crosses now is what the clean side needs for these:

- part A in full (POST, the conventions, the option ROM);
- [`docs/bios-rules.md`](../bios-rules.md) and the rules of [`docs/chip-rules.md`](../chip-rules.md) the parts cite;
- of part B: the return to the VGA modes, the VGA clocks (with the 25.175 MHz PLL pair) and the rules
  for the one VESA mode of milestone 4, 101h (640x480 in 256 colours, recorded on a card,
  [`milestone-calls.md`](milestone-calls.md));
- of part C: 4F00h, 4F01h (for 100h and 101h, which the program asks for) and 4F02h for that mode, the
  window function (4F05h and its far entry WinFuncPtr), and the general rules (return codes, index
  registers);
- the contract part of [`milestone-calls.md`](milestone-calls.md); its part "The run" stays on the dirty side.

Rules outside this scope (the other modes, 4F03h-4F08h beyond 4F05h if milestone 4 does not need
them, 4F14h and the S3 mode numbers, the S3 OEM functions) are not reviewed now and are cut from the
clean side's copy; the record names the rule IDs that crossed. [`freedos-1.4.md`](freedos-1.4.md) and
[`freedos-reports.md`](freedos-reports.md) belong to milestone 5 (tentative) and are reviewed with it.

### Files to review

| File | Crosses as | Notes |
| --- | --- | --- |
| [`spec-a-post.md`](spec-a-post.md) | specification | second full review; returned on 2 November; rewritten on 5 November (#168), POST-6 changed on 7 November |
| [`spec-b-modeset.md`](spec-b-modeset.md) | specification | second review of the VGA return and 101h; MODE-136 (the FIFO M of 101h), MODE-137, MODE-148, MODE-103, MQ-11 and MQ-12 are new since the pin; the 25.175 MHz PLL pair (step 3) |
| [`spec-c-vbe.md`](spec-c-vbe.md) | specification | second review of 4F00h, 4F01h (100h, 101h), 4F02h (101h), 4F05h and its far entry, and the general rules; VBE-45 (AH=0Fh after 101h returns 40h) and the CR35 units note are new since the pin; 4F14h and the S3 mode numbers stay out of scope |
| [`docs/chip-rules.md`](../chip-rules.md) | the clean side's copy | the IDs the parts cite; the four `[Leak review: ...]` notes of the first pass are gone (#168), two new ones at T64-ID-2 and AV-ID-1 (step 5); T64-MEM-7 was returned |
| [`docs/bios-rules.md`](../bios-rules.md) | public-source rules | the returned rows B00-5, B09-11, B10-1, B11-1, B12-1, B1A-1, B1C-8, TAB-9 and question 17, rewritten on 5 November (#168) |
| [`milestone-calls.md`](milestone-calls.md) | requirements | only its part "The contract" crosses; since the pin it holds EDIT's calls (milestone 2), the benchmark's bank switching through CR35 and the milestone 2 boot policy (#168), none of them reviewed yet; "The run" names our ROMs and what they answered |
| [`freedos-1.4.md`](freedos-1.4.md) | requirements | not in this review (milestone 5). Its section "Our ROMs against these" measures our patched ROMs by level (1.5-07-p3, 1.03-08-p1, 2.04.07-p22): dirty-side material, to cut from the clean side's copy or keep with a reason (step 5) |
| [`freedos-reports.md`](freedos-reports.md) | defect reports to FreeDOS | not in this review (milestone 5). About FreeDOS's MORE and MODE; it names S3 BIOSes as a class (4F01h for mode 03h) |

### What changed since the reviewed commit `cbbc2ce`

From `git log cbbc2ce..main` on the files above (merges left out). Changes before `cbbc2ce` were in front
of the review of 2 November and are in its record.

- **2 November 2026, after the pin.** [`milestone-calls.md`](milestone-calls.md): EDIT's calls
  (milestone 2) and the benchmark's bank switching through CR35 (758bffd, e58a7fd, 642472a, 5876edb);
  [`spec-c-vbe.md`](spec-c-vbe.md): the note on the units of CR35 now says that programs which bank
  through CR35 themselves need 64 KB units (758bffd).
- **5 November 2026.** The independent review's returns recorded (ae82d60), then the rewrites (#168,
  9fb921f) in all six files: parts A, B and C, [`docs/chip-rules.md`](../chip-rules.md) (the four notes
  cut or rewritten), [`docs/bios-rules.md`](../bios-rules.md) (the returned rows and question 17) and the
  contract of [`milestone-calls.md`](milestone-calls.md) (Source columns, 100h and AH=0Fh wording). The
  owner decisions in [`decisions-milestones-1-4.md`](decisions-milestones-1-4.md) and the four
  [`primary-extracts/`](primary-extracts/) came with it.
- **6 November 2026.** Part B: MODE-136 now fixes M = 31 (CR54 = F8h) with CR60 = FFh for 101h, from the
  data book's FIFO size and wait (T32/64 7.4, T64-MEM-1, T64-MEM-8); MODE-137 no longer covers 101h,
  MODE-148 takes the same pair for the VGA modes, the old M formula is marked as not a milestone 1-4
  rule, and MODE-103, MQ-11 and MQ-12 follow (afdda72, 512df1f). Part C and the contract: AH=0Fh after
  101h returns AL = 40h, and AH=00h with AL = 40h sets the same banked 101h again (VBE-45, decision Q0F,
  afdda72). [`docs/chip-rules.md`](../chip-rules.md) gained VP-SYS-1, VP-MEM-3 to VP-MEM-6, MEM-2, the
  section "Monitor communication (DDC)" (T64-DDC-1, VP-DDC-1) and one datasheet error (MM81EC bit
  numbers): data book text only (90f30ee); the 4F14h table moved the Hercules Graphite Terminator D2g
  under the Trio64V+ (7dba4fd).
- **7 November 2026.** [`docs/chip-rules.md`](../chip-rules.md): T64-ID-2 (the Trio32/Trio64 parts by
  CR2F) and AV-ID-1 (the Aurora64V+ device ID), *derived* from S3's Windows 95 driver 2.41.07, each with a
  `[Leak review: ...]` note (b60f46d, 8d8e6e0); the driver's table itself is in
  [`docs/764-rom.md`](../764-rom.md) "Chip variants by CR2F". VP-ID-1 now rests the Trio64V+ revisions
  5xh on S3's driver INF (52h-5Fh) besides the card record, with no note (1b7eacb, 4ca7c61). V2-ID-1
  gained a sentence from the same INF, and T3D-ID-1 and T3D2X-ID-1 are new, from S3 driver INFs too
  (c20d8fd); none of the three is cited by a part. Part A: POST-6 says the 86C764 and 86C764X are told
  apart by CR2F (T64-ID-2), which the ROM does not need, and that later Trio64V+ steppings report 5xh
  (b60f46d, 1b7eacb). File paths in [`docs/chip-rules.md`](../chip-rules.md),
  [`docs/bios-rules.md`](../bios-rules.md) (TAB-9) and [`decisions-milestones-1-4.md`](decisions-milestones-1-4.md)
  moved under `src/` (#174, 7729a0e). [`docs/bios-rules.md`](../bios-rules.md): the legend of S3COMPAT's
  default DAC check (1afbea1), a tool name only.

### The searches, run by the author as a pre-check (counts of lines, not findings)

Run on 7 November 2026 at `e224454`.

| File | Step 1, names | Step 1, offsets | `[Leak review: ...]` notes |
| --- | --- | --- | --- |
| spec-a-post.md | 0 | 13 | 0 |
| spec-b-modeset.md | 0 | 0 | 0 |
| spec-c-vbe.md | 5 | 11 | 0 |
| docs/chip-rules.md | 7 | 2 | 2 |
| docs/bios-rules.md | 9 | 197 | 0 |
| milestone-calls.md | 3 | 7 | 0 |

The milestone-calls.md counts are of the whole file; read only the hits in "The contract" (above the
heading "The run"). Known false positives of the offset search: addresses in the BIOS data area
(0040:0049h and the like) and the far pointers of the IBM tables and the VBE blocks, which the IBM
references and VESA define; nearly all of bios-rules.md's 197 lines are of this kind. Read them anyway:
a ROM offset (C000:xxxx, or a four-digit hex address inside the 32 KB image) among them is a finding.

### What the reviewer may read, and what not

The lists name files and folders of this repository at the commit under review. A file in neither list
is not read: ask the owner first. Reading a forbidden file by mistake ends the session as a reviewer:
say so in the record, and the review is done again by another session.

**May read.**

| What | Why |
| --- | --- |
| The files under review (the table above) | the object of the review |
| This file, [`docs/clean-room.md`](../clean-room.md), [`README.md`](README.md) of this folder | the process, the rules and the record of the first pass |
| The reference ROMs: [`reference/trio64/1_5_07.bin`](../../reference/trio64/1_5_07.bin), [`reference/64vplus/1_03_08n.bin`](../../reference/64vplus/1_03_08n.bin) (the first review knew it as `1_03_08.bin`), [`reference/v2/2_04_07.bin`](../../reference/v2/2_04_07.bin) | to compare bytes and behaviour with (steps 3 and 6) |
| The oracle files: [`oracle-a-post.md`](oracle-a-post.md), [`oracle-b-modeset.md`](oracle-b-modeset.md), [`oracle-c-vbe.md`](oracle-c-vbe.md) | what the dirty side observed, to tell observation from copying |
| [`docs/764-rom.md`](../764-rom.md), [`docs/765-rom.md`](../765-rom.md), [`docs/775-rom.md`](../775-rom.md), except the section "Cross-check with riplin's annotated disassembly" of [`docs/764-rom.md`](../764-rom.md) | measurements of the reference ROMs and the cards. One sentence of [`docs/764-rom.md`](../764-rom.md) outside that section, on memory sizing, names a routine and its offset from riplin's disassembly; reading it is not a breach, but it is no source for a finding |
| The emulator: [`emu/vgaemu.py`](../../emu/vgaemu.py) and [`emu/similarity.py`](../../emu/similarity.py) (step 6) to read and run; [`emu/tests.py`](../../emu/tests.py) to run, not to read | to run a reference ROM and observe it; the test file's comments describe our patches from the inside (see below) |
| The data sheets and public references in [`datasheets/`](../../datasheets/) and named in [`docs/bios-rules.md`](../bios-rules.md) | the public sources a statement may rest on |
| [`datasheets/V53C16256H-1.PDF`](../../datasheets/V53C16256H-1.PDF) and [`primary-extracts/v53c16256h-power-up-and-refresh.md`](primary-extracts/v53c16256h-power-up-and-refresh.md) | POST-41 and MODE-130 DRAM premises (independent review A-3 / B-1) |
| [`primary-extracts/dmt-640x480-60hz.md`](primary-extracts/dmt-640x480-60hz.md), and VESA DMT 1.0 Rev. 10 from its public copy (named in the repository-root README, "VESA standards") | part B 101h timing and border (MQ-16). The PDF was removed from the repository (9963092); the extract's link to `standards/vesa/` no longer resolves |
| [`standards/pci/pci23.pdf`](../../standards/pci/pci23.pdf) and [`primary-extracts/pci-2.3-section-6.3.md`](primary-extracts/pci-2.3-section-6.3.md) | part A ROM header / PCI data structure / INIT (ROM-1..6, POST-1) |
| [`standards/vesa/vbe12.txt`](../../standards/vesa/vbe12.txt) and [`primary-extracts/vbe-1.2-status-and-ah0f.md`](primary-extracts/vbe-1.2-status-and-ah0f.md) | part C status / failure, AH=0Fh reinit advice, ModeAttributes D0 |
| [`decisions-milestones-1-4.md`](decisions-milestones-1-4.md) | owner decisions that close Q100, Q0F, MCLK, FIFO, POST-41, ROM-8/9 |
| [`primary-extracts/README.md`](primary-extracts/README.md) | index of extracts |
| [`review-2026-11-02.md`](review-2026-11-02.md) | which places changed after the outside review |
| The repository-root [`README.md`](../../README.md), only the sections "Windows 9x driver test", "Missing documents" and "VESA standards", and the S3ALIAS row of the tool table | spec A and spec C cite them: the black-box record of S3's Windows 9x driver, the public standards and the missing documents. The Windows section also describes our own patches as observed on the card (the p15 booster, the mode set hook that restores CR59/CR5A from CR6D): behaviour of our ROM, not reference code. The other sections are not read: the ROM sections and "MCLK build option" describe our patches byte by byte ([`README.md`](README.md) of this folder, "What stays on the dirty side") |
| [`AGENTS.md`](../../AGENTS.md), the whole file | the specifications cite its project rules ("Hard rules for the ROM", "Assembly conventions"), and its section "Clean-room rules and parts A/B/C" is what the files under review were written to; it holds no code, names riplin's disassembly only as a pointer, and its two reference ROM offsets (7F51h, 3CE9h) can be checked against the reference ROMs |

**Must not read.**

| What | Why |
| --- | --- |
| The Phoenix VGA BIOS source material (an `SRC/phx` folder or similar, wherever found) | a vendor's source: the review compares with the ROMs' observed bytes and behaviour, not with anyone's source |
| riplin's annotated disassembly ([hag](https://github.com/riplin/hag) `research/s3/bios/86c764x.asm`), and the section of [`docs/764-rom.md`](../764-rom.md) that cites it | the same: an expression of the Phoenix code, with names for its routines |
| Any other VGA BIOS source code (SeaVGABIOS, the BIOS source [`docs/bios-rules.md`](../bios-rules.md) mentions, others), and [`docs/seavgabios-trio64.md`](../seavgabios-trio64.md), the plan for a SeaVGABIOS port, which parts A, B and C link to | the same; and a reviewer who has read it cannot tell what a file under review took from it |
| Our patch code and patchers: [`src/roms/`](../../src/roms/) (its `bios.inc` files map routines of the reference ROMs), except `src/roms/fonts/README.md` (step 6), and the change logs [`docs/764-changes.md`](../764-changes.md), [`docs/765-changes.md`](../765-changes.md), [`docs/775-changes.md`](../775-changes.md) | they describe the reference code from the inside, with its addresses, and carry routine names from riplin's disassembly (`VESADDCReadVDIF` in `s3tpatch.py`, for one); not needed to compare behaviour. TAB-9 and the decision "Fonts" link to `src/roms/fonts/`: do not follow those links |
| [`BRIEF.md`](BRIEF.md) | the clean implementer's brief, not dirty material, but the reviewer has no use for it and must not write to the clean side |
| [`src/tools/s3alias/`](../../src/tools/s3alias/) (S3ALIAS's source, its header included) | our TSR's code; the owner does not allow it for the review. The README's tool table row is enough for the mode numbers (49h to 59h, 4Bh to 5Ah) |

Step 6: `python3 emu/similarity.py FILE --min 16` compares with the three reference ROMs above by
default. The text mode fonts are a known match: the tables our ROMs now build from Joseph Gil's public
domain collection (#141) are byte for byte S3's, and S3's equal IBM's VGA font. A font table in a file
under review is therefore reported as a long run; pass its range with `--fonts START-END` and judge its
source (Gil's files, or the reference ROM) rather than the match. The fonts' origin is documented in
`src/roms/fonts/README.md`; the reviewer takes it from there only if a font table turns up, and reads
that one file, not the rest of `src/roms/`.

### Open items

- The returns of 2 November, the working list for this pass ([`README.md`](README.md) "Authorized
  independent review - 2026-11-02"): rating and source gaps and the POST-41 premise in part A; the FIFO
  and refresh premises in part B (MODE-136 and MODE-130 now rest on the data book and the DRAM data
  sheet); the 100h capability policy and AH=0Fh after 101h in part C (decisions Q100 and Q0F); T64-MEM-7
  as a public chip rating; the bios-rules rows B00-5, B09-11, B10-1, B11-1, B12-1, B1A-1, B1C-8, TAB-9 and
  question 17; the Source columns of the milestone contract and its 100h and AH=0Fh wording. Record each
  as settled or still returned.
- [`docs/chip-rules.md`](../chip-rules.md): T64-ID-2 and AV-ID-1 carry `[Leak review: ...]` notes;
  POST-6 cites T64-ID-2, and VP-ID-1, which POST-6 also cites, now rests the revisions 5xh partly on S3's
  driver INF without a note. A driver's identification table is neither data book nor black-box
  observation of a BIOS: decide under steps 2 and 5 whether the clean side needs it (POST-6 says the ROM
  does not need to tell the two Trio64 parts apart).
- Parts A, B and C link to [`docs/seavgabios-trio64.md`](../seavgabios-trio64.md) (spec C: "It covers
  items 3 and 5 of ..."), which the reviewer may not read. Decide whether the link is cut from the clean
  side's copy; the links were there at the first pass too.
- [`spec-c-vbe.md`](spec-c-vbe.md) S3M-2 quotes the S3ALIAS header ("sets 640x480x256 with INT 10h AH=00 mode 49h ...")
  and cites it as "README"; the quote is not in README.md, and the reviewer may not read
  [`src/tools/s3alias/`](../../src/tools/s3alias/). Deferred with the S3 mode numbers (outside milestones
  1-4); the citation is to be fixed before that later review.
- [`spec-c-vbe.md`](spec-c-vbe.md) 4F14h (OEM-1 to OEM-7) and the S3 mode numbering: observed behaviour of S3's
  BIOSes, kept for compatibility (step 5); outside the scope of milestones 1-4 and cut from the clean
  side's copy. Dirty-side next step: Trio64V2/DX driver `VGALOG` call logs, then OEM / `AX=4F14h`
  **interface** contracts (inputs, outputs, status only) for a later leak review before any crossing.
- [`spec-b-modeset.md`](spec-b-modeset.md): the 25.175 MHz PLL pair equal to the reference ROM's, derived (step 3);
  kept for the in-scope case by the independent review.
- [`milestone-calls.md`](milestone-calls.md): "The run" now also holds the benchmark's bank routine, read
  from the program's own disassembly (a DJGPP program, not a BIOS), and a port trace of our 1.5-07-p5;
  it stays on the dirty side. What the contract takes from it (CR6A = 00h, CR51 bits 3-2 = 0, CR31 bits
  0 and 3 with 64 KB pages in CR35 after 4F02h 101h) is in the contract, which cites "spec C" without
  rule IDs (VBE-44 and VBE-53 hold these rules); its Source column is a return of the first pass.
- [`freedos-1.4.md`](freedos-1.4.md) and [`freedos-reports.md`](freedos-reports.md): deferred with milestone 5.
- Not to review now: the monitor sense decision of our ROMs (#134, #139) and the font change (#141)
  touched no file that crosses; the specifications say nothing yet on the monitor sense at POST
  (an open point for part A, decided on the clean side from the IBM references, not from our ROMs).
