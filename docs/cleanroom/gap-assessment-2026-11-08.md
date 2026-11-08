# Gap assessment after the second-pass leak review — 8 November 2026

Dirty-side readiness assessment of the second-pass leak-review package
(`leak-review-2026-11-07-b257fd6-author-handoff.zip`, review pinned at commit
`b257fd66d1cef746fc15d61f5ac4c22da9911c37`, 7 November 2026) against current `main`
(55bf120, 8 November 2026). Written by a dirty-side assessment session; it is not the
reviewer and not the future implementer, and it does not re-run, overrule or pre-decide
any review finding. Facts verified in the package or the repository are stated as such;
inferences are marked.

## Executive summary

**Verdict: no — clean-room implementation of milestones 1-5 cannot meaningfully start yet.**
The second pass cleared nothing unconditionally: `complete_implementation_handoff_cleared`
is `false`, all four specification files remain RETURNED, and only two scoped, conditional
clearances exist (a 24-ID sanitized chip subset and the milestone contract text, each
conditional on exact edits). On top of that, two process gates are missing on `main`: the
review result is **not recorded** in [`README.md`](README.md) "Leak review" (the package
supplies the section and a patch (`README-review-section.md`, `README-review.patch`),
but they are not applied), and the separate clean repository does not exist.

The shortest list of what must happen first:

1. Apply the supplied README review record to `main` (dirty side, mechanical).
2. Owner decisions on the genuinely open returns: POST-41's 200 µs unit correction and
   the DRAM qualification question (A-1), the 1 MB fallback policy (A-5b), the FIFO bound
   (B-1), the VGA refresh choice (B-3), the MODE-133 IBM-equivalence provenance (B-4),
   the VGATEST-dependent bios-rules rows (R1/R2), cursor scaling (R3), and the contract's
   B01-4 dependency (MC-2b). Several of these are already answered or made moot by the
   8 November decisions (ID-INF, M-SENSE) and by the in-repo RBIL/Ferraro sources; the rest
   are one sitting of owner choices plus a few card observations.
3. Apply the review's exact rewrites and cuts to produce the sanitized crossing copies and
   an allowlist naming every rule ID that crosses.
4. A fresh leak review of the produced clean copy (the protocol requires re-review of
   changed files before export).
5. Create the clean repository at a fixed commit with the reviewed allowlist.

Everything else — milestone-1 acceptance sharpening, the verification-loop test migration,
the size-budget measurement, and the two milestone-5 sense choices — can run in parallel and
is preparatory, not blocking.

## Package inventory

Outer zip: 36,729,734 bytes, 13 files under `leak-review-2026-11-07-b257fd6/`
(integrity: `HANDOFF-CONTENTS.json` lists SHA-256 per file; `eligible-evidence-verification.json`
covers the inner archive).

| File | Size | Type | Role |
| --- | --- | --- | --- |
| `START-HERE.txt` | 1.4 KB | text | Reading order for the handoff |
| `owner-summary.md` | 4.0 KB | text | Owner-facing verdict summary |
| `clearance.json` | 1.5 KB | JSON | Machine-readable clearance scope |
| `full-review-record.md` | 81 KB | text | **The review itself**: lead (A/C/contract), independent B/chip review, independent BIOS review, with every decision and exact rewrite |
| `README-review-section.md` | 81 KB | text | The same adjudication formatted as the repo README "Leak review" section |
| `README-review.patch` | 83 KB | patch | The same as a patch against the pinned checkout's README |
| `evidence-index.md` | 2.2 KB | text | Guide to the evidence zip and the reproduction command |
| `eligible-review-evidence.zip` | 36.5 MB | zip-in-zip | Full evidence: reports, scanner, 14 candidates, all three reference ROMs, pinned inputs (specs, oracles, datasheets, standards, extracts), hashes, reproduction results |
| `eligible-evidence-verification.json` | 0.8 KB | JSON | Integrity checks of that archive |
| `migration-manifest.json` | 3.2 KB | JSON | Scratch ownership/retention record |
| `superseded-lead-eligibility-incident.md` | 2.6 KB | text | Administrative record: the first lead was stopped after a loop bug exposed "The run"; a fresh replacement lead was used |
| `superseded-lead-incident-evidence.{json,zip}` | 0.4 KB / 114 KB | JSON/zip | That incident's evidence only; not consumed by the eligible review |

**In the package but not in the repository:** the review record, clearance data, evidence
archive and incident record — none of it is committed anywhere in
`perchrh/trio64-vbios-tools`. In particular the protocol-required README record is *not*
applied on `main` (verified: `docs/cleanroom/README.md` contains no 2026-11-07 section; its
"Leak review" section still ends at the 2026-11-02 review).

**In the repository's crossing set but not in the package:** nothing material. The
package's `pinned-inputs/` carries the pinned copies of the specs A/B/C, chip-rules,
bios-rules, oracles, decisions, LEAK-REVIEW, the extracted milestone contract
(`milestone-contract-only.md`), primary extracts, AGENTS, clean-room process, the
datasheets, standards (Thoegersen, PCI 2.3), the reference ROMs and `emu/similarity.py`.
The FreeDOS files are deferred by design; fonts and `BRIEF.md` are excluded by the review
scope (fonts were never inspected or cleared).

## Stale-versus-`main` findings

The package is pinned at `b257fd6` (7 November). `main` has since gained #196 (citation
fixes, ID-INF) and #197 (reading links), plus M-SENSE, the Vision964/IBM extracts, RBIL
release 61 in-repo (`standards/rbil-all/`, commit 904dbfe) and the deleted SeaVGABIOS plan
document. Where they disagree, `main` wins; every disagreement found:

1. **Milestone numbering.** The package defers the FreeDOS files to "milestone 5"; on
   `main` the monitor sense is milestone 5 (M-SENSE, 8 November) and FreeDOS is the
   tentative milestone 6. The package's "deferred" verdict is unaffected.
2. **Driver-INF identification cuts (CH-2).** The package cuts T64-ID-2, AV-ID-1,
   T3D-ID-1, T3D2X-ID-1 and the INF parts of VP-ID-1/V2-ID-1 as review conditions. `main`'s
   decision **ID-INF** (8 November, `decisions-milestones-1-4.md`) orders the same cuts as
   an owner decision. The two agree; `main` additionally narrows POST-6 to "the two Trio64
   parts give the same PCI ID and revision", which also discharges the A-3 rewrite's
   "cut the driver-table distinction".
3. **POST-41's unit — `main` is stale, not the package.** The review's key new finding:
   the rendered V53C16256H sheet says **200 µs**; its OCR says `200 ms`, and that error
   propagated into the extract, the owner decision and POST-41. `main`'s
   `decisions-milestones-1-4.md` (POST-41 row) and the extract still say 200 ms. This is
   the one place where the package's finding supersedes `main`'s current text and needs a
   `main`-side correction (see gap G1).
4. **Citation/link fixes.** #196 changed four citations/links in the crossing files
   (e.g. DMT link, extract references). The review's exact rewrites were written against
   the `b257fd6` text and must be applied to `main`'s current text, not re-applied blind.
5. **M-SENSE / POST-42, the Vision964 and IBM sense extracts, RBIL in-repo, the Ferraro
   and RBIL reading links** (#197): none exist in the package; they postdate it. They
   answer access gaps the reviewers worked around (the BIOS reviewer had to fetch RBIL
   release 61 and the Ferraro OCR externally; both are now in-repo/readable via
   `docs/cleanroom/readings.md`).
6. **MCLK default.** The review verified POST-23's tuples including the then-new 50.11 MHz
   default (decision of 7 November); `main`'s POST-22/23 match. No disagreement.

## The review's verdict, extracted

From `clearance.json`, `owner-summary.md` and `full-review-record.md`:

- `complete_implementation_handoff_cleared: false`; `unchanged_full_source_files_cleared: []`;
  `target_specifications_edited: false`; `clean_side_written: false`; `eligible: true`.
- **spec-a-post.md — RETURNED** (no ID cleared). Returns: **A-1** (POST-41: correct the
  unit to 200 µs; identify which publicly documented controller condition guarantees the
  eight qualifying RAS cycles, including after a clock gap), **A-5b** (the unqualified 1 MB
  fallback after every memory candidate fails: policy or evidence?), **A-12** (dependency
  hold: POST-34/36/37 and CONV-7 cite the unresolved B FIFO/refresh and BIOS
  table/font provenance). Rewrites supplied verbatim: A-3 (POST-6), A-4 (introduction,
  ROM-7), A-5a (POST-15), A-6 (POST-4, POST-13 cross-ref, POST-36z), A-7 (POST-40, and
  POST-30 as project readiness), A-8 (CONV-4/5/6 as project design choices), A-9
  (ROM-1/2), A-10 (ROM-3/6), A-13 (POST-36p), A-14 (POST-1/9/10 as project
  initialization policy). Cuts: A-11 (CONV-3/12, Windows obligations, later-chip errata
  in POST-32, the Windows-driver example in POST-27, forbidden links, question 11).
  Keep: A-2 and the remainder, subject to the holds.
- **spec-b-modeset.md — RETURNED** (VGA/101h subset; no ID cleared). Returns: **B-1**
  (MODE-136 and dependents MODE-103/148, MQ-11/12: the 9+2·M example ends when refill
  begins; it does not bound the worst wait; the M=31 decision must be labelled provisional
  or supported by a derivation/test), **B-3** (MODE-147/MQ-5: pick the actual VGA refresh
  count and register fields, don't defer to the open question), **B-4** (MODE-133: the
  22-byte match in each reference ROM is not a leak finding, but the exact "as IBM mode
  13h" 34-byte state needs an inspectable primary table or a functional derivation).
  Rewrites: B-2 (MODE-130 refresh, settled with the actual-clock derivation), B-5
  (MODE-143), B-6 (MODE-139), B-7 (introduction), B-8 (scope: 101h-only tables), B-9
  (MODE-112/115 blanking as project choice vs the DMT 8-pixel/8-line border). Keep: B-10
  (MODE-119 PLL pair, settled), B-11 (the listed mode rows, subject to B-1/B-3/B-4).
- **spec-c-vbe.md — RETURNED** (no ID cleared). Return: **C-10** (VBE-41/44/47's promised
  101h set and palette depend on the B and BIOS returns). Rewrites C-1..C-9 supplied
  verbatim, including the Q100-consistent VBE-30/31 (main accepts 100h queries as a project
  extension; 100h reports D0=0, 101h 001Bh), VBE-3's refusal contract, VBE-53/55 (effective
  bank reporting through CR6A or CR35+CR51 — repairing the conflict with the benchmark's
  direct CR35 banking), VBE-56, VBE-44 (no final flip-flop promise) and the CR35-units
  note. Q100 and Q0F are accepted as settled owner policy needing exactly these rewrites.
- **docs/bios-rules.md — RETURNED, "IDs cleared to cross: none."** Settled keeps: B09-11,
  B10-1, B11-1, B00-22, TAB-9 (after rewrite W4), font/state question 17. Rewrites W1-W12
  supplied verbatim (B12-1/B1A-1/B1C-8 unsupported-input no-ops with honest success-value
  wording, B00-8 final state without the order claim, W6 register-preservation as project
  choice across seven rows, W9/W10 switching provenance to Ferraro tables, W12 cutting the
  `vgaref.inc` provenance convention, plus cuts of project-only "Checked by" annotations).
  Returns: **R1** (B00-5: exact fill/extent exhibit), **R2** (the VGATEST-dependent rows:
  B00-7, B00-18, B01-4, B00-10/B00-11, B06-8, B09-6, B0B-8 and its BDA-11/B1B use,
  B1B-12), **R3** (B01-5 cursor-scaling boundaries from garbled Ferraro tables).
- **docs/chip-rules.md — 24 IDs cleared, conditionally.** The clearance (T64-ID-1,
  VP-ID-1, T64-PCI-1, PLL-1, PLL-2, CLK-1, CLK-2, CLK-3, CLK-6, MEM-1, T64-PLL-1,
  T64-CLK-1, T64-CLK-2, T64-MEM-1/2/3/5/6/7, REG-1, REG-3, T64-REG-1/2, T64-ENG-1) applies
  only after the exact CH-1..CH-8 edits and cuts (MEM-1 rating wording, the VP-ID-1
  narrow Hercules-54h rewrite, the CR3B bit8/CR5D bit6 fix, source/housekeeping rewrites,
  the CR6B conflict note, and the cut of the other 56 IDs and whole OEM/Vision864/Vision968
  sections). B's FIFO return is explicitly not discharged by this catalogue.
- **milestone-calls.md — the contract cleared, conditionally.** MC-1 keep (observations are
  partial black-box counts); MC-5: the contract is independently safe requirements text
  after the edits. Conditions: **MC-2** (exact Source replacements for the repeated
  AH=00h/AL=03h, AH=12h/BL=34h, 4F01h and 4F02h rows), **MC-2b** (the EDIT CX=0607h row
  must not import B01-4's returned exact scaling), **MC-3** (the banking bullet rewritten
  with CR6A/CR51/CR35/CR31 values and sources, cutting "details in The run"), **MC-4**
  (The run, the S3REGS 4F03h instrumentation and the richer-shell aside cut from the clean
  copy).
- **freedos-1.4.md / freedos-reports.md — DEFERRED** (package: "to milestone 5"; on
  `main`: milestone 6), not reviewed.
- Fonts and legal/release clearance were **not granted** (counsel items); the similarity
  scans (14 candidates, 13 zero matches at the 16-byte threshold, the MODE-133 22-byte
  match investigated) are recorded but "no legal conclusion is drawn from a zero-run
  similarity result".

### Returns reconciled against `main`

| Return | Status on `main` (8 November) | Classification |
| --- | --- | --- |
| CH-2 driver-INF cuts (T64-ID-2, AV-ID-1, T3D/T3D2X-ID-1, VP-ID-1/V2-ID-1 INF parts) | Decision **ID-INF**, `decisions-milestones-1-4.md`, commit 7dfd86e (#196) | **Answered on `main`** |
| A-3 / POST-6 variant distinction | ID-INF's POST-6 narrowing (same PCI ID/revision) | **Answered on `main`** (the A-3 rewrite text still needs applying to the crossing copy) |
| Q100 policy return (first pass) | Decision Q100 (5 Nov); review accepts, supplies the C-3 rewrites | **Answered; rewrite application still open** |
| Q0F / AH=0Fh assignment | Decision Q0F (6 Nov); review keeps VBE-45 | **Answered** |
| A-1 POST-41 (200 µs + qualification question) | `main` still says 200 ms; the question is unanswered | **Still open** (and `main` needs the unit correction) |
| A-5b 1 MB fallback policy | No decision | **Still open** |
| A-12 dependent citations | Depends on B-1/B-3/B-4 and R1/R2 | **Still open** (dependency hold) |
| B-1 FIFO bound | The FIFO/MODE-136 owner decision (M=31, 6 Nov) predates the review and was **not accepted as sufficient**: the reviewer requires a derivation/test or an explicit provisional label | **Still open** (narrower: label or prove) |
| B-3 VGA refresh choice | No decision; open question 8 in spec-a is the same issue | **Still open** |
| B-4 MODE-133 provenance | No inspectable VGATEST primary located; Ferraro (now linked on `main`) does not give the complete exact table per the BIOS reviewer | **Still open** (functional-derivation route available) |
| C-10 dependent mode-set/palette | Follows B-1/B-4 and R1/R2 | **Still open** (dependency hold) |
| R1 B00-5 fill/extent | No decision | **Still open** |
| R2 VGATEST-dependent rows | Partially eased: Ferraro and RBIL 61 are now in-repo/readable (W9/W10 already switch to Ferraro; RBIL was fetched externally by the reviewer and is now in `standards/rbil-all/`) | **Partly answerable now from in-repo public sources; rest still open** |
| R3 B01-5 cursor scaling | Ferraro OCR still garbled; no legible table | **Still open** |
| MC-2 contract Source columns | `main`'s contract rows cite OBS + VGADOC/RBIL/VBE 1.2 (improved by #196) but not the exact MC-2 replacements (no part-C rule IDs, no B00-1/B00-22/B12.34-1) | **Partially applied; exact edits still open** |
| MC-2b EDIT cursor row | `main` still cites "with cursor emulation, B01-4", and B01-4 is still returned | **Still open** |
| MC-3 banking bullet | `main` has the CR6A/CR51/CR31 requirement (line 82-83) close to MC-3 but without the CR35/CR31 bit values and sources MC-3 specifies | **Partially applied; exact edits still open** |
| MC-4 cut The run | The run remains in the dirty file; the crossing copy does not exist yet | **Open, by design** (an export task, not a decision) |
| Sense/no-sense scope | Not a package return; decision **M-SENSE** (8 Nov) sets no sense in milestones 1-4, POST-42 added | **Answered on `main`** |
| FreeDOS deferral | Package defers to "milestone 5"; `main` makes it milestone 6 | **Moot** (numbering only) |

## The gap list

| # | Gap | Status | Evidence | Blocking? | Action and owner |
| --- | --- | --- | --- | --- | --- |
| G1 | **Review unrecorded.** The protocol (`LEAK-REVIEW.md` "Recording the result") requires the README record; `main`'s "Leak review" section stops at 2026-11-02 | Not done | `docs/cleanroom/README.md` (no 2026-11-07 entry); package `README-review-section.md`/`README-review.patch` | **BLOCKING** (an unrecorded review cannot clear anything for export) | Dirty side: apply the supplied section, reconciled with `main`'s drift (milestone numbering, ID-INF, M-SENSE) |
| G2 | **Undecided returns** (step-2 "still open" rows above): A-1, A-5b, B-1, B-3, B-4, R1, R2 (remainder), R3, MC-2b, and the dependency holds A-12/C-10 | Not done | `full-review-record.md` A-1/A-5b/A-12, B-1/B-3/B-4, C-10, BIOS R1/R2/R3; no matching rows in `decisions-milestones-1-4.md` | **BLOCKING** for the affected rules; each needs a decision, a rewrite (text mostly supplied) or a cut | Owner: one decisions sitting (most are label-as-project-choice or replace-with-derivation); a few need card observations (see G8) |
| G3 | **POST-41 unit correction on `main`.** The decision, extract and spec say 200 ms; the rendered sheet says 200 µs | Not done | `decisions-milestones-1-4.md` POST-41; `primary-extracts/v53c16256h-power-up-and-refresh.md`; review A-1 | **BLOCKING** (it is a factual error in a crossing rule) | Dirty side: correct the extract, decision wording and POST-41 per the review's exact minimum correction; keep any 200 ms project delay only as an explicitly distinguished conservative choice |
| G4 | **Crossing cuts and allowlist.** No sanitized crossing copy and no allowlist document exist; the review defines the scope (24 chip IDs after CH-1..8; B's 101h subset; C's function set; the contract after MC-2..4; the ID-INF and scope cuts) but nothing on `main` names the IDs that cross | Not done | `clearance.json`; CH-8's 56-ID cut list; B-8/C-1 scope rewrites; no allowlist file in the repo | **BLOCKING** for handover | Dirty side: produce the crossing copies by applying the supplied rewrites/cuts to `main`'s text, plus an allowlist naming every crossed ID; then G5 |
| G5 | **Fresh review of the produced clean copy.** The protocol requires re-review of changed files before export; every conditional clearance says "after the exact edits" | Not done | `LEAK-REVIEW.md`; `clearance.json` conditions | **BLOCKING** | Reviewer (a fresh eligible session): review the produced copies against the recorded conditions |
| G6 | **The separate clean repository** (fixed commit, decision of #145) | Not done | `clean-room.md` "Next steps"; `README.md` "Status" | **BLOCKING** before implementation starts | Dirty side/owner: create it with the reviewed allowlist, the cut-rule copies, the public sources (RBIL `standards/rbil-all/`, VGADOC, the S3 and DRAM datasheets, VBE/PCI/DMT extracts), the font package (`fonts.py` + asset manifest), the milestone contracts, the clean tests and `BRIEF.md`; keep out the oracles, reference ROMs, `src/roms/` patch code and the disassembly, per the handover's may-read/must-not-read lists |
| G7 | **Milestone contracts.** M2-4: the contract is conditionally cleared; MC-2/MC-2b/MC-3 exact edits are unapplied. Milestone 1: acceptance is "the monitor shows a picture with readable text" — no objective criterion the clean side can self-check (the `post` test checks the header and that POST returns; `t_post` checks the BDA bits; neither asserts readable text) | Partial | `milestone-calls.md` "The contract"; `clean-room.md` milestone list item 1; `README.md` test-harness notes | **BLOCKING** for M2-4 only via G4; milestone-1 precision is **PREPARATORY** | Dirty side: apply MC-2/2b/3/4; owner: define a checkable milestone-1 criterion (e.g. a named emulator test asserting mode-03h text output) |
| G8 | **Milestone 5 (the sense).** Sources are in place (T32/64 8.4; the Vision964 procedure and IBM power-on extracts; BDA-14/16 with RBIL M0024/M0027 in-repo; POST-42 for milestones 1-4). Open: the **DAC drive values** and the **no-display behaviour** — both project decisions | Partial | `primary-extracts/vision964-sense-input-utilization.md`, `ibm-bios-power-on-mode-and-mono-state.md`; POST-42; M-SENSE decision | **PREPARATORY** (milestone 5 is last; it can start with the two items as labelled open choices, since the mechanism and BDA contract are already specified) | Owner: two labelled decisions when milestone 5 is scheduled |
| G9 | **Open questions in the specs.** Sweep of spec-a questions 1-14 and the B/C questions: Q4 settled (MCLK 50.11 MHz); Q100/Q0F settled; Q1/Q2 (other chips) deferred by scope; Q3 (warm boot), Q5 (SRA bit 7), Q6 (PLL settling), Q7 (SR18 bit 6), Q9 (CR5C value) need card observations or board input; Q8 (CR3A refresh) is the same choice as the B-3 return; Q10 (sign-on) and the 4F10/4F15 policy (Q11) are project choices (4F10/4F15 unsupported is already decided in the scope); MQ-3/4/6/7/8/11/12/14/16 survive only as observable questions per B-11 | Mostly classified | `spec-a-post.md` "Open questions"; review A-11/B-11/C decisions | **PREPARATORY** — none is blocking on its own: the clean side can write correct code with each labelled (project choice, open observation, or deferred). The exception is Q8/B-3: the VGA refresh count is part of the VGA mode contract and is a G2 return | Owner: label the choices; card observations when the card is on the bench |
| G10 | **The clean side's verification loop.** Defined in outline: S3TEST/S3COMPAT/VSHOW profiles, `s3test_any` (needs no ROM of ours), `post`/`t_post`; oracles, reference ROMs and the similarity check stay dirty. But the "review the emulator tests for expectations taken from the reference ROMs and move the clean ones" step has not been done | Partial | `README.md` "Status"/test notes; `clean-room.md` "Next steps" | **PREPARATORY** (can run in parallel; without it, results cannot be judged, so it must complete before acceptance) | Dirty side: audit `emu/tests.py` expectations, split the clean set, ship it with G6 |
| G11 | **Size budget.** 32 KB total, ~9.7 KB fonts, ~23 KB for code and tables; "not measured yet; a milestone that does not fit says so before the next one starts" | Not done | `clean-room.md` "Decisions of 2 November 2026" | **PREPARATORY** — the first milestone should carry a measurement (the clean repo's first build report states its size) | Clean side (with the dirty side tracking the budget per milestone) |

## Prioritized sequence

1. **G1** — record the review in the README (dirty side; quick, unblocks the record-keeping gate).
2. **G3** — the POST-41 200 µs correction on `main` (dirty side; small, factual).
3. **G2** — owner decisions sitting for A-1 (qualification wording), A-5b, B-1 (provisional
   label or derivation), B-3/Q8 (VGA refresh choice), B-4 (functional derivation),
   R1/R2/R3 (Ferraro/RBIL-based provenance where possible, project choices or cuts
   otherwise), MC-2b. Parallel with 1-2.
4. **G4** — produce the sanitized crossing copies + allowlist from `main`'s text (dirty
   side; mostly mechanical application of the supplied rewrites). After 2-3.
5. **G5** — fresh leak review of the produced copies (reviewer). After 4.
6. **G6** — create the clean repository and hand over (dirty side/owner). After 5.
7. In parallel from the start: **G7** (milestone-1 criterion), **G8** (two sense choices,
   needed only at milestone 5), **G9** (label the open questions), **G10** (test
   migration), **G11** (first size measurement).

## What is not missing

To keep the gaps above in proportion, these are already in place:

- **The decisions.** `decisions-milestones-1-4.md` answers the first-pass returns the
  review would not invent: Q100, Q0F, MCLK 50.11 MHz, FIFO M=31 (pending the B-1 label),
  POST-41 (pending the unit correction), ROM-8/9, CONV-3/-12, index/lock attribution,
  ID-INF, Fonts (closed, Gil package + asset manifest), M2-BOOT, M-SENSE.
- **The review itself.** A complete, eligible, reproducible second-pass record with exact
  replacement text for nearly every rewrite, per-item first-pass closure, access logs and
  a tested reproduction command (14 candidates, 13 zero matches, the MODE-133 match
  investigated, scanner self-test clean).
- **The primary sources.** The datasheets, PCI 2.3, VBE 1.2, DMT, the Thoegersen VGADOC
  texts, RBIL release 61 in-repo, the Ferraro reading link, and the primary extracts —
  including the two new sense extracts for milestone 5.
- **The milestone scope and contracts.** Five milestones decided with acceptance
  descriptions; the milestone-2-4 call contract recorded from real card runs; the
  no-sense policy for milestones 1-4 fixed as POST-42.
- **The process.** `clean-room.md` and `LEAK-REVIEW.md` define the crossing, review and
  recording procedure; the font package is closed; the MIT release terms are decided;
  the test harness already has the profiles that need no ROM of ours.

The real gaps are the undecided returns (G2/G3), the mechanical application of an
already-written review (G1/G4/G5), and the clean repository (G6). Everything else is
labelling, measurement or bench work that can proceed in parallel.
