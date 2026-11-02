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

       grep -n -i -E 'phoenix|riplin|reference rom|reference/|rompatch|backport|oracle|s3patch|1\.5-07|1\.03-08|2\.04\.0|2\.04\.1|-p[0-9]+\b' FILE
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

## Handover to the reviewer (2 November 2026)

Prepared by the dirty side (the author of the files under review); the review itself, steps 1-6 above,
is the reviewer's. Review the files as they are on `main` at the commit you start from, and name that
commit in the record.

### Files to review

| File | Crosses as | Notes |
| --- | --- | --- |
| [`spec-a-post.md`](spec-a-post.md) | specification | first full review |
| [`spec-b-modeset.md`](spec-b-modeset.md) | specification | first full review; the 25.175 MHz PLL pair (step 3) |
| [`spec-c-vbe.md`](spec-c-vbe.md) | specification | first full review; 4F14h and the S3 mode numbers (step 5) |
| [`docs/chip-rules.md`](../chip-rules.md) | the clean side's copy | the four `[Leak review: ...]` sentences (step 5); its section "S3 OEM functions (4F14h)" crosses only through part C |
| [`docs/bios-rules.md`](../bios-rules.md) | public-source rules | its open-question lists, written while reading another vendor's BIOS source |
| [`freedos-1.4.md`](freedos-1.4.md) | requirements | not in the first review. Its section "Our ROMs against these" measures our patched ROMs by level (1.5-07-p3, 1.03-08-p1, 2.04.07-p22): dirty-side material, to cut from the clean side's copy or keep with a reason (step 5) |
| [`freedos-reports.md`](freedos-reports.md) | defect reports to FreeDOS | not in the first review. About FreeDOS's MORE and MODE; it names S3 BIOSes as a class (4F01h for mode 03h) |

What changed in these files since the first review (1 November 2026), from `git log`: file references
became links (20b5502); [`freedos-1.4.md`](freedos-1.4.md) and [`freedos-reports.md`](freedos-reports.md) are new; in
[`docs/chip-rules.md`](../chip-rules.md) T64-MEM-8 and T64-MEM-9 were added (the latter carries one of the four notes)
and the Trio64V2 DCLK VCO range became the data book's 135-340 MHz (c22779d). On 2 November 2026,
after an outside review ([`review-2026-11-02.md`](review-2026-11-02.md)), MODE-130 of part B (the refresh count per line,
now derived from the DRAM data sheet), MQ-5 and its worked example, and the 55 MHz example of POST-23
in part A were corrected: read these three places as new. Later on 2 November 2026 part B's source note
was changed from DMT rev. 0.7 to rev. 10 (the revision at hand; its timings of this part were checked
against the specification's table and agree), and MQ-16 (the DMT border of 640x480) was added; the oracle
file's "DMT has no border" was corrected.

### The searches, run by the author as a pre-check (counts of lines, not findings)

| File | Step 1, names | Step 1, offsets | `[Leak review: ...]` notes |
| --- | --- | --- | --- |
| spec-a-post.md | 1 | 14 | 0 |
| spec-b-modeset.md | 0 | 0 | 0 |
| spec-c-vbe.md | 5 | 11 | 0 |
| docs/chip-rules.md | 11 | 3 | 4 |
| docs/bios-rules.md | 8 | 208 | 0 |

Known false positives of the offset search: addresses in the BIOS data area (0040:0049h and the like)
and the far pointers of the IBM tables and the VBE blocks, which the IBM references and VESA define;
nearly all of bios-rules.md's 208 lines are of this kind. Read them anyway: a ROM offset (C000:xxxx, or
a four-digit hex address inside the 32 KB image) among them is a finding.

### What the reviewer may read, and what not

The lists name files and folders of this repository at the commit under review. A file in neither list
is not read: ask the owner first. Reading a forbidden file by mistake ends the session as a reviewer:
say so in the record, and the review is done again by another session.

**May read.**

| What | Why |
| --- | --- |
| The files under review (the table above) | the object of the review |
| This file, [`docs/clean-room.md`](../clean-room.md), [`README.md`](README.md) of this folder | the process and the rules |
| The reference ROMs: [`reference/trio64/1_5_07.bin`](../../reference/trio64/1_5_07.bin), [`reference/64vplus/1_03_08n.bin`](../../reference/64vplus/1_03_08n.bin) (the first review knew it as `1_03_08.bin`), [`reference/v2/2_04_07.bin`](../../reference/v2/2_04_07.bin) | to compare bytes and behaviour with (steps 3 and 6) |
| The oracle files: [`oracle-a-post.md`](oracle-a-post.md), [`oracle-b-modeset.md`](oracle-b-modeset.md), [`oracle-c-vbe.md`](oracle-c-vbe.md) | what the dirty side observed, to tell observation from copying |
| [`docs/764-rom.md`](../764-rom.md), [`docs/765-rom.md`](../765-rom.md), [`docs/775-rom.md`](../775-rom.md), except the section "Cross-check with riplin's annotated disassembly" of [`docs/764-rom.md`](../764-rom.md) | measurements of the reference ROMs and the cards |
| The emulator: [`emu/vgaemu.py`](../../emu/vgaemu.py) and [`emu/similarity.py`](../../emu/similarity.py) (step 6) to read and run; [`emu/tests.py`](../../emu/tests.py) to run, not to read | to run a reference ROM and observe it; the test file's comments describe our patches from the inside (see below) |
| The data sheets and public references in [`datasheets/`](../../datasheets/) and named in [`docs/bios-rules.md`](../bios-rules.md) | the public sources a statement may rest on |
| [`review-2026-11-02.md`](review-2026-11-02.md) | which places changed after the outside review |
| The repository-root [`README.md`](../../README.md), only the sections "Windows 9x driver test", "Missing documents" and "VESA standards", and the S3ALIAS row of the tool table | spec A and spec C cite them: the black-box record of S3's Windows 9x driver, the public standards and the missing documents. The Windows section also describes our own patches as observed on the card (the p15 booster, the mode set hook that restores CR59/CR5A from CR6D): behaviour of our ROM, not reference code. The other sections are not read: the ROM sections and "MCLK build option" describe our patches byte by byte ([`README.md`](README.md) of this folder, "What stays on the dirty side") |
| [`AGENTS.md`](../../AGENTS.md), the whole file | the specifications cite its project rules ("Hard rules for the ROM", "Assembly conventions"); it holds no code, names riplin's disassembly only as a pointer, and its two reference ROM offsets (7F51h, 3CE9h) can be checked against the reference ROMs |

**Must not read.**

| What | Why |
| --- | --- |
| The Phoenix VGA BIOS source material (an `SRC/phx` folder or similar, wherever found) | a vendor's source: the review compares with the ROMs' observed bytes and behaviour, not with anyone's source |
| riplin's annotated disassembly ([hag](https://github.com/riplin/hag) `research/s3/bios/86c764x.asm`), and the section of [`docs/764-rom.md`](../764-rom.md) that cites it | the same: an expression of the Phoenix code, with names for its routines |
| Any other VGA BIOS source code (SeaVGABIOS, the BIOS source [`docs/bios-rules.md`](../bios-rules.md) mentions, others) | the same; and a reviewer who has read it cannot tell what a file under review took from it |
| Our patch code and patchers: [`rompatch/`](../../rompatch/) (its `bios.inc` files map routines of the reference ROMs), and the change logs [`docs/764-changes.md`](../764-changes.md), [`docs/765-changes.md`](../765-changes.md), [`docs/775-changes.md`](../775-changes.md) | they describe the reference code from the inside, with its addresses, and carry routine names from riplin's disassembly (`VESADDCReadVDIF` in `s3tpatch.py`, for one); not needed to compare behaviour |
| [`BRIEF.md`](BRIEF.md) | the clean implementer's brief, not dirty material, but the reviewer has no use for it and must not write to the clean side |
| [`s3alias/`](../../s3alias/) (S3ALIAS's source, its header included) | our TSR's code; the owner does not allow it for the review. The README's tool table row is enough for the mode numbers (49h to 59h, 4Bh to 5Ah) |

Step 6: `python3 emu/similarity.py FILE --min 16` compares with the three reference ROMs above by
default. The text mode fonts are a known match: the tables our ROMs now build from Joseph Gil's public
domain collection (#141) are byte for byte S3's, and S3's equal IBM's VGA font. A font table in a file
under review is therefore reported as a long run; pass its range with `--fonts START-END` and judge its
source (Gil's files, or the reference ROM) rather than the match. The fonts' origin is documented in
`rompatch/fonts/README.md`; the reviewer takes it from there only if a font table turns up, and reads
that one file, not the rest of `rompatch/`.

### Open items

- [`spec-c-vbe.md`](spec-c-vbe.md) S3M-2 quotes the S3ALIAS header ("sets 640x480x256 with INT 10h AH=00 mode 49h ...")
  and cites it as "README"; the quote is not in README.md, and the reviewer may not read [`s3alias/`](../../s3alias/). The
  reviewer checks S3M-2 against the README's tool table row only and records the citation as to be fixed.
- [`spec-c-vbe.md`](spec-c-vbe.md) 4F14h (OEM-1 to OEM-7) and the S3 mode numbering: observed behaviour of S3's
  BIOSes, kept for compatibility (step 5), to be confirmed by the reviewer.
- [`spec-b-modeset.md`](spec-b-modeset.md): the 25.175 MHz PLL pair equal to the reference ROM's, derived (step 3).
- [`docs/chip-rules.md`](../chip-rules.md): the four sentences marked `[Leak review: ...]` (step 5).
- [`freedos-1.4.md`](freedos-1.4.md) and [`freedos-reports.md`](freedos-reports.md): first review.
- The three specifications: the first review (1 November 2026) was the dirty side's own search; the
  full review by a second reader, steps 1-6, is still to be done.
- Not to review now: the monitor sense decision of our ROMs (#134, #139) and the font change (#141)
  touched no file that crosses; the specifications say nothing yet on the monitor sense at POST
  (an open point for part A, decided on the clean side from the IBM references, not from our ROMs).
