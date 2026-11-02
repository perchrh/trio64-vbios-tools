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
in part A were corrected: read these three places as new.

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

### What the reviewer may and may not open

- May open, to compare with: the reference ROMs in [`reference/`](../../reference/) (`trio64/1_5_07.bin`,
  `64vplus/1_03_08n.bin` (S3's 1.03-08N since 2 November 2026; the first review knew it as
  `1_03_08.bin`), `v2/2_04_07.bin`), the oracle files, [`docs/764-rom.md`](../764-rom.md), the emulator and its tests.
- Must not open: the Phoenix VGA BIOS source material and riplin's disassembly (see "Who reviews").
- Step 6: `python3 emu/similarity.py FILE --min 16` compares with the three reference ROMs above by
  default. The text mode fonts are a known match: the tables our ROMs now build from Joseph Gil's
  public domain collection ([`rompatch/fonts/`](../../rompatch/fonts/), #141) are byte for byte S3's, and S3's equal IBM's
  VGA font. A font table in a file under review is therefore reported as a long run; pass its range
  with `--fonts START-END` and judge its source (Gil's files, or the reference ROM) rather than the
  match.

### Open items

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
