# Leak review: instructions

How to review a file before it crosses from the dirty side to the clean side (`docs/clean-room.md`
"The process", step 2). The aim: what crosses describes behaviour that a public source or a black-box
observation supports, and nothing in it expresses a reference BIOS's code or data. This is not legal
advice; the lawyer of `docs/clean-room.md` judges the process as a whole.

## Who reviews

- Not the author of the file. A person or a separate agent session that may read the dirty material
  (the reference ROMs, the oracle files, `docs/trio64-backport.md`) to compare with, but has not written
  the file under review.
- Never with the Phoenix VGA BIOS source material or riplin's disassembly open: the reviewer compares
  against the reference ROMs' observed behaviour and bytes, not against anyone's source.

## What is reviewed

Everything that goes to the clean side, each time it changes:

- `spec-a-post.md`, `spec-b-modeset.md`, `spec-c-vbe.md`;
- `docs/chip-rules.md` (the clean side's copy) and `docs/bios-rules.md` with its open questions;
- every answer given through the wall (`docs/clean-room.md` step 4) before it is added to a
  specification;
- test expectations moved to the clean repository (`docs/clean-room.md` "Next steps").

The oracle files, `BRIEF.md` and this file never cross and are not reviewed.

## The checks, in order

1. **Search.** Look for names that point at dirty material, then read each hit in its sentence:

       grep -n -i -E 'phoenix|riplin|reference rom|reference/|rompatch|backport|oracle|s3patch|1\.5-07|1\.03-08|2\.04\.0|2\.04\.1|-p[0-9]+\b' FILE
       grep -n -E '\b[0-9A-F]{4}h?:[0-9A-F]{4}h?\b|\b[0-9A-F]{4}h-[0-9A-F]{4}h\b' FILE

   The second line finds ROM offsets and address ranges, which describe a BIOS image, not behaviour.
   Also read every sentence that carries a `[Leak review: ...]` note.

2. **Sources.** Every rule names a source in its Source column: the data book (T32/64 with section or
   table, or a `docs/chip-rules.md` rule ID that rests on one), VESA, the IBM references, VGADOC, or
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

Per file and review, add a section to the "Leak review" part of `docs/cleanroom/README.md`:

- the date, the file and its commit, the reviewer;
- each finding with its decision: **keep** (and why), **rewrite** (the new text), **cut** (from the
  clean side's copy), or **returned** (to the author, with the question);
- the items left for the lawyer, if any.

Remove a `[Leak review: ...]` note when its sentence is decided: rewritten, cut, or kept with the
reason recorded. A file crosses only when every finding is decided and nothing is returned.

## Open items (1 November 2026)

- `spec-c-vbe.md` 4F14h (OEM-1 to OEM-7) and the S3 mode numbering: observed behaviour of S3's
  BIOSes, kept for compatibility (step 5), still to be confirmed by a second reader.
- `spec-b-modeset.md`: the 25.175 MHz PLL pair equal to the reference ROM's, derived (step 3).
- `docs/chip-rules.md`: the four sentences marked `[Leak review: ...]` (step 5).
- The three specifications: the first review (1 November 2026) was the dirty side's own search; the
  full review by a second reader, steps 1-6, is still to be done.
