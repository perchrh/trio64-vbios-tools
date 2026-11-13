# The crossing allowlist

What may cross to the clean side, per the second-pass leak review of 7 November 2026
(commit `b257fd66d1cef746fc15d61f5ac4c22da9911c37`, recorded in
[README.md](README.md) "Independent second-pass review - 2026-11-07"). This file is the
export control document for the clean repository: **a rule ID crosses only if it is
listed here as cleared**, and only after its named conditions are applied to the
crossing copy and that copy passes a fresh leak review ([LEAK-REVIEW.md](LEAK-REVIEW.md)).

The review cleared **nothing unconditionally**. `complete_implementation_handoff_cleared`
is false; no unchanged full source file may cross. Everything not listed below stays on
the dirty side.

## Cleared to cross, conditionally

### docs/chip-rules.md — 24 rule IDs

Cleared only after the exact CH-1..CH-8 edits and cuts are applied to the crossing copy
(the full record's "Independent part B and chip-rule second-reader review"):
`T64-ID-1`, `VP-ID-1`, `T64-PCI-1`, `PLL-1`, `PLL-2`, `CLK-1`, `CLK-2`, `CLK-3`,
`CLK-6`, `MEM-1`, `T64-PLL-1`, `T64-CLK-1`, `T64-CLK-2`, `T64-MEM-1`, `T64-MEM-2`,
`T64-MEM-3`, `T64-MEM-5`, `T64-MEM-6`, `T64-MEM-7`, `REG-1`, `REG-3`, `T64-REG-1`,
`T64-REG-2`, `T64-ENG-1`.

The other 56 chip-rule IDs and the whole OEM / Vision864 / Vision968 sections are cut
(CH-8) and do not cross. The ID-INF owner decision (8 November 2026) additionally cuts
the driver-INF identification material (T64-ID-2, AV-ID-1, T3D-ID-1, T3D2X-ID-1 and the
INF parts of VP-ID-1/V2-ID-1), agreeing with CH-2.

### milestone-calls.md — the contract text only

The call contract is cleared as independently safe requirements text, only after the
MC-2, MC-2b, MC-3 and MC-4 edits (exact Source replacements, the EDIT CX=0607h row
without B01-4's returned exact scaling, the banking bullet with CR6A/CR51/CR35/CR31
values and sources, and the cut of "The run", the S3REGS 4F03h instrumentation and the
richer-shell aside). It has no native rule IDs. The observations are partial black-box
counts and cross as such; the dirty-side run material does not cross.

### Public sources cleared to cross

- The **VGATEST distribution** — PCTECHline's VGATEST, mirrored on the SimTel CD-ROM as
  [VGATEST2.ZIP](http://cd.textfiles.com/simtel/simtel/DISK2/DISC1/VGA/VGATEST2.ZIP)
  (also at The Programmer's Corner:
  [pcorner.com/list/GRAPHUTI/VGATEST.ZIP](https://www.pcorner.com/list/GRAPHUTI/VGATEST.ZIP/)) —
  is allowlisted material (owner decision, 8 November 2026). It contains the IBM reference
  tables (CRTC.COL, GENERAL.COL, DSTATE.COL, DAC.COL and the .MON variants), the READ.ME
  and the test executables; the article is "The VGA Compatibility Test", Ed McNierney and
  Kent Quirk, PC Tech Journal, November 1988, p. 48 (issue text at
  [pcjs.org](https://www.pcjs.org/documents/magazines/pctj/)). The shipped tables verified
  the citations that name them (see the VGATEST-PUB decision); the table files cross as
  public exhibits with the bios-rules citations that depend on them.
- IBM, "Personal System/2 and Personal Computer BIOS Interface Technical Reference",
  April 1987 — allowlisted by the owner on 8 November 2026. A scanned copy is at the
  Internet Archive:
  [archive.org/details/bitsavers_ibmpcps2PSTechnicalReferenceApr87_5816663](https://archive.org/details/bitsavers_ibmpcps2PSTechnicalReferenceApr87_5816663)
  ([readings.md](readings.md) row 8). It crosses as a public source for the clean side
  (INT 10h and the BIOS data area), alongside the other public sources named in
  [clean-room.md](../clean-room.md) "Public documents for the clean side"; the
  project's own extract of it
  ([primary-extracts/ibm-bios-power-on-mode-and-mono-state.md](primary-extracts/ibm-bios-power-on-mode-and-mono-state.md))
  crosses with it. The book's own text is public; this entry clears the source, not any
  rule ID derived from it — those follow the per-file decisions above.

## Not cleared (do not cross)

- [spec-a-post.md](spec-a-post.md) — RETURNED (A-1, A-5b, and the A-12 dependency hold).
- [spec-b-modeset.md](spec-b-modeset.md) — RETURNED (B-1, B-3, B-4).
- [spec-c-vbe.md](spec-c-vbe.md) — RETURNED (C-10 dependency hold).
- [bios-rules.md](../bios-rules.md) — RETURNED; **no rule ID cleared** (R1, R2, R3).
- [freedos-1.4.md](freedos-1.4.md), and the FreeDOS defect reports in the issues tagged FreeDOS
  (were `freedos-reports.md`) - milestone 6 opened 13 November 2026; still not reviewed, and nothing
  here crosses until the milestone-6 review clears it.
- Fonts and the asset manifest: no legal/release clearance granted.
- **CHIPID** ([src/tools/chipid/](../src/tools/chipid/)) and **ROMVER** ([src/tools/romver/](../src/tools/romver/),
  with [src/tools/common/romver.inc](../src/tools/common/romver.inc), via vdebug.inc) — dirty as wholes
  (owner decision, 10 November 2026, recorded on #201): CHIPID's classification rests on S3 driver
  INF/DRV material (the CR2F variant-name table, T64-ID-2), and ROMVER's whole contract is the
  "Version " sign-on convention of S3's and Phoenix's BIOSes — a vendor convention, not a public
  rule (the PCI 2.3 6.3 header is the public rule, checked by the `post` emulator test). The clean
  side replaces CHIPID with its own identifier written from the data books and the PCI ID database
  ([standards/pci-ids/](../../standards/pci-ids/), public since 10 November 2026), and does not ship
  ROMVER. Until the ROMTEST split lands, note that [src/tools/common/chip.inc](../src/tools/common/chip.inc)
  is shared with the clean-listed tools (REPORT, S3REGS, MCLK) and still carries the driver-derived
  `chippart`/`chipvar` tables: when ROMTEST shares chip.inc, those tables must be split out (the PCI
  device IDs re-sourced from PCI-IDS), so no dirty table crosses inside a shared include.

## What must happen before this allowlist is usable

1. **Owner decisions on the open returns** (A-1's qualification wording, A-5b, B-1,
   B-3/Q8, B-4, R1, R2's remainder, R3, MC-2b; the A-12/C-10 holds then resolve).
2. **Produce the sanitized crossing copies** by applying the review's exact rewrites
   and cuts to `main`'s current text (not the pinned `b257fd6` text): the chip subset
   after CH-1..CH-8, the contract after MC-2..MC-4, and the spec/bios files once their
   returns are decided. **The crossing copies do not exist yet; producing them is an
   open task.**
3. **A fresh leak review** of the produced copies against the recorded conditions
   (the protocol requires re-review of changed files before export). Until then no
   entry above may actually cross.
4. **Create the clean repository** at a fixed commit carrying this allowlist, the
   reviewed copies and the public sources ([clean-room.md](../clean-room.md)).

Nothing in this file overrides the review record; it extracts
`clearance.json` (2026-11-07) and the full record's conditions. Created 8 November 2026.
