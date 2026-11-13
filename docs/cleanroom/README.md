# The clean-room package

What the clean side gets for writing a Trio64 video BIOS from scratch (decided 2 November 2026,
[#145](https://github.com/perchrh/trio64-vbios-tools/issues/145); the parts it consists of: [`docs/clean-room.md`](../clean-room.md) "The parts of the clean ROM"), what stays on the dirty side, and how the result is checked. The process
and its reasons are in [`docs/clean-room.md`](../clean-room.md). Prepared 1 November 2026. The first leak review (1 November) removed the references to dirty-side
documents from [`spec-a-post.md`](spec-a-post.md); what remains for a second reader is listed under "Leak review".

**Status, 2 November 2026.** An outside review ([`review-2026-11-02.md`](review-2026-11-02.md)) found the package not yet ready
to implement from:
- MODE-130's refresh count and POST-23's example are corrected since.
- Decided by the owner on 2 November 2026 ([#145](https://github.com/perchrh/trio64-vbios-tools/issues/145), [`docs/clean-room.md`](../clean-room.md) "Decisions of 2 November 2026"):
  - the base: empty, a full new BIOS written from scratch, with the fonts of [`src/roms/fonts/`](../../src/roms/fonts/);
  - SeaVGABIOS kept as a comparison implementation;
  - the size budget: 28 KB total (set 8 November 2026; the whole 32 KB before), about 9.7 KB of
    fonts, about 18 KB for code and tables, leaving about 4 KB free for fixes and improvements;
  - release terms: the MIT licence;
  - no patched ROM images uploaded by CI; the reference ROMs stay in the repository for now;
  - the scope: four milestones on the DSP-3364P. (1) The computer is powered on cold and the colour
    monitor shows the system BIOS's POST text, legible; glitches are allowed and nothing after POST is
    required. (2) MS-DOS 6.22 boots, and MS-DOS
    EDIT loads, edits and saves a file without significant glitches. (3) Superscape 3D Bench 1.0c runs
    under MS-DOS without significant glitches. (4) Chris's 3D Benchmark runs under MS-DOS in 320x200
    and 640x480 VESA without significant glitches: the first milestone that needs parts B and C, for
    its one VESA mode. Milestone 5: the monitor sense (decided 8 November 2026: no sense in
    milestones 1-4, POST always colour, M-SENSE). Milestone 6, tentative: FreeDOS boots
    ([`freedos-1.4.md`](freedos-1.4.md)). Milestone 7, an idea (added 8 November 2026, [#117](https://github.com/perchrh/trio64-vbios-tools/issues/117)):
    DDC (VBE 4F15h) with interrupts enabled for the whole call, memory-mapped I/O and interrupts off
    only around each DDC register access — the clean ROM starts this way instead of a patch to any of
    our ROMs; wanted on every chip (Trio64 764, Trio64V+ 765, Trio64V2 775), not only the 775 the issue
    reports. The converter-friendly modes of [#115](https://github.com/perchrh/trio64-vbios-tools/issues/115)
    (720p, 1080i, 240p), likewise for every chip and ROM, are an idea for later still, outside every
    milestone so far. The rest of
    parts B and C is for later milestones;
  - the scope of the leak review: a clean-room implementation of milestones 1-4
    ([`LEAK-REVIEW.md`](LEAK-REVIEW.md) "Scope of this review").
- Added to part A since: PCI 2.3 section 6.3 as the source of the option ROM rules, and the DRAM
  power-up of the card (POST-41).
- The test harness fixes (#143) are in place: `post` fails a POST that does not return, and
  `S3TEST /C` with the emulator test `s3test_any` runs the set that needs no ROM of ours.
- Recorded since that status: MS-DOS EDIT's INT 10h calls and Chris's 3D Benchmark banking through
  CR35 ([`milestone-calls.md`](milestone-calls.md), PR #165); the MIT licence file ([`LICENSE.md`](../../LICENSE.md));
  the V53C16256H data sheet in [`datasheets/`](../../datasheets/); the independent second-reader leak
  review of 2 November 2026 (below: every current target RETURNED, no rule ID cleared).
- Applied 5 November 2026 toward the independent-review returns (still need a fresh leak review of
  the changed files before any allowlist export):
  - owner decisions in [`decisions-milestones-1-4.md`](decisions-milestones-1-4.md) (100h, AH=0Fh,
    MCLK policy, FIFO, POST-41, ROM-8/9, fonts, M2-BOOT bare MS-DOS);
  - primary extracts and full documents in [`primary-extracts/`](primary-extracts/),
    [`standards/vesa/VESA-DMT-1.0-Rev10.pdf`](../../standards/vesa/VESA-DMT-1.0-Rev10.pdf),
    [`standards/pci/pci23.pdf`](../../standards/pci/pci23.pdf),
    [`standards/vesa/vbe12.txt`](../../standards/vesa/vbe12.txt);
  - LEAK-REVIEW "May read" extended for those extracts;
  - high-impact rewrites in parts A/B/C, chip-rules, bios-rules B00-9/B00-22, and milestone-calls
    Source columns (POST-41 corrected to **200 ms** from the V53C sheet; that unit was itself the sheet's
    OCR error, corrected to **200 µs** on 8 November 2026 after the second-pass review).
- Fonts closed 5 November 2026: Gil FNTCOL16 files plus build-time tables (`fonts.py`); see
  [`asset-manifest.md`](asset-manifest.md) and [`decisions-milestones-1-4.md`](decisions-milestones-1-4.md).
- Bios-rules returns of 2 November 2026 applied 5 November 2026 (B00-5, B09-11, B10-1, B11-1, B12-1,
  B1A-1, B1C-8, TAB-9, font/state Q17, and the B-08 open-question rewrites). High-impact A/B/C and
  milestone rewrites were already in this branch. Nothing is cleared until a fresh second-reader pass.
- Still open:
  - a second-reader re-review of the changed files (nothing is cleared until then);
  - the export of a reviewed allowlist at a fixed commit to a separate repository;
  - Trio64V2/DX **driver** `VGALOG` call logs (dirty side; later milestones; after milestone 1 is fine);
  - after those logs: dirty-side **OEM / `AX=4F14h` interface contracts** (inputs, outputs, status
    only; no implementation) for later-milestone driver compatibility, then a leak review before any
    crossing;
  - mode 03h cold-boot proof on the DSP-3364P (clean acceptance, after a cleared clean build exists);
  - theretroweb reference-ROM fetch (dirty side; deferred; not a coding gate).

**On the base:** the specifications describe behaviour; their rules hold for the ROM written from scratch. Their introductions say so, and where they mention SeaVGABIOS it is the comparison implementation.

## Files here

| File | Side | What it is |
| --- | --- | --- |
| [`readings.md`](readings.md) | goes across with the specifications | the order of authority for what the clean side reads |
| [`BRIEF.md`](BRIEF.md) | dirty | the rules the specification was written under |
| [`LEAK-REVIEW.md`](LEAK-REVIEW.md) | dirty | how a file is reviewed before it crosses, and how the result is recorded |
| [`spec-a-post.md`](spec-a-post.md) | goes across after the leak review | POST start-up, the conventions drivers rely on, the PCI ROM header (plan items 1, 4, 6) |
| [`spec-b-modeset.md`](spec-b-modeset.md) | goes across after the leak review | the S3 mode set: DMT timings, clocks, colour modes, display FIFO, return to VGA (item 2) |
| [`spec-c-vbe.md`](spec-c-vbe.md) | goes across after the leak review | VBE 1.2 (4F00-4F08), the S3 mode numbers and 4F14h (items 3, 5) |
| [`milestone-calls.md`](milestone-calls.md) | its contract part goes across after the leak review | the INT 10h calls of milestones 2 (EDIT), 3 and 4, recorded on a card |
| [`freedos-1.4.md`](freedos-1.4.md) | goes across with milestone 6 | what FreeDOS 1.4 asks of the video BIOS (milestone 6, tentative), from its sources |
| issues #266, #267 (were `freedos-reports.md`) | goes across with milestone 6 | drafts of the MORE and MODE defect reports to FreeDOS |
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
- The test tools as programs and their result lines (S3TEST, S3COMPAT, VBESHOW, VGALOG, S3REGS): what
  they check is stated in their headers from public sources.

## What stays on the dirty side

The reference ROMs ([`reference/`](../../reference/)), the patched ROMs and their code ([`src/roms/`](../../src/roms/)), the oracle files,
riplin's disassembly, [`docs/764-rom.md`](../764-rom.md), the README sections on byte-level changes, the
emulator tests that compare with a reference ROM (`make 775-ref-compare`, `764-ref-compare`, the `T64_BASE`
notes), and anything from another vendor's BIOS source. The Windows DDKs in [`ddk/`](../../ddk/) (untracked
owner's copies; the 98 DDK carries S3's own driver sources): anything from another vendor's driver source is
the same.

## Checking the clean ROM (on the dirty side)

1. **Emulator**: `make emu-test ROM=CLEAN.BIN CHIP=764` with 2, 4 and 1 MB. The tests tagged `patch`
   (our ROMs' patches, and `s3test` with our ROM's signature) are skipped for a ROM that is not ours.
   `s3test_any` runs `S3TEST /C` instead: the set that needs no ROM of ours (checksum, MCLK, VGA
   clear, font load, the scrolls, AH=09h, timings), on any chip, with the version as INFO (#143).
   It is 8 result lines: the mode list and the VBE checks of S3TEST are our ROMs' and have no clean
   counterpart yet. S3COMPAT and VBESHOW run in full. `post` checks the ROM header without running it
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

4. **On the card**, with a way back: keep the card's own ROM image and a second graphics card (or a
   machine that can flash the card blind) at hand, as for every ROM so far. Flash the 64 KB image
   (the 32 KB twice), cold boot, then RUNALL (S3TEST, S3COMPAT, VBESHOW /R, VGALOG, S3REGS) and the
   programs of the milestone.

## Leak review

The procedure is in [`LEAK-REVIEW.md`](LEAK-REVIEW.md). Done once on 1 November 2026 by the dirty side (a search of the three specification files for
Phoenix, the reference ROMs, [`src/roms/`](../../src/roms/), [`docs/764-rom.md`](../764-rom.md) and riplin, then a reading of the
hits). The independent second reader of 2 November 2026 superseded that first search. Its historical
record and the current fresh second-pass record of 7 November 2026 are below. Historical notes from the first search that the second reader still treated:

- [`spec-c-vbe.md`](spec-c-vbe.md) 4F14h (OEM-1 to OEM-7) and the S3 mode numbers: outside milestones 1-4,
  deferred/cut with that scope, not cleared.
- [`spec-b-modeset.md`](spec-b-modeset.md): the PLL values for 25.175 MHz (SR12 61h, SR13 28h) equal the reference ROM's,
  because both follow the data book's procedure 9.1; the independent review kept that derivation for
  the in-scope case.
- [`docs/chip-rules.md`](../chip-rules.md): the four `[Leak review: ...]` notes are cut with their
  out-of-scope containing material; they are not approved by silence.
- Part B and part C agree on the mode list for later milestones: 102h and 104h are part C's (VBE-10);
  current crossing scope is VGA return plus 101h only.

### Authorized independent review - 2026-11-02

Date: 2026-11-02. Reviewed commit: `cbbc2ce629f22c5ffa9b4cfeb60200df8fc1396d` (descendant of the
owner-required `28e7c00`). Reviewers: eligible non-author sessions for parts A/B/C, chip/bios rules,
and the milestone contract. Root remains disqualified as a substantive reviewer.

**No current file or rule ID is cleared to cross.** Keep/rewrite/cut decisions are not clearance while
any return remains. FreeDOS files are deferred with milestone 6. Full per-file reports and inventories
stay on the dirty side (issue [#145](https://github.com/perchrh/trio64-vbios-tools/issues/145) attachments
and the MediaFire evidence zip of 2 November 2026); this section is the protocol-required README record.

| Date | File at the pinned commit | Reviewer | Decision |
| --- | --- | --- | --- |
| 2026-11-02 | [`spec-a-post.md`](spec-a-post.md) | independent_leak_review | RETURNED; full part A |
| 2026-11-02 | [`spec-b-modeset.md`](spec-b-modeset.md) | independent_leak_review | RETURNED; VGA/101h subset only |
| 2026-11-02 | [`spec-c-vbe.md`](spec-c-vbe.md) | independent_leak_review | RETURNED; 4F00, 4F01 100/101, 4F02 101, 4F05/far entry and general rules |
| 2026-11-02 | [`../chip-rules.md`](../chip-rules.md) | rules_review | RETURNED; 24 included IDs, 44 cut; 23 eligible after edits, T64-MEM-7 returned |
| 2026-11-02 | [`../bios-rules.md`](../bios-rules.md) | rules_review | RETURNED; eight rows and one question remain; B00-22 exact rewrite resolved |
| 2026-11-02 | [`milestone-calls.md`](milestone-calls.md) | freedos_review | RETURNED; The contract only; The run cut |
| 2026-11-02 | [`freedos-1.4.md`](freedos-1.4.md) | scope record only | DEFERRED to milestone 6 (milestone 5 at the time); not passed |
| 2026-11-02 | `freedos-reports.md` | scope record only | DEFERRED to milestone 6 (milestone 5 at the time); not passed; text moved to issues #266 and #267 |

Main outstanding issues at that pin (still the working list until a re-review of changed files):
rating/source gaps and POST-41 premise in A; FIFO and refresh premises in B; 100h capability policy and
AH=0Fh after 101h in C; T64-MEM-7 as a public chip rating; bios-rules rows B00-5, B09-11, B10-1,
B11-1, B12-1, B1A-1, B1C-8, TAB-9 and font/state question 17; milestone contract Source columns and
honest 100h/AH=0Fh wording. Byte-run scans found no unexplained positive match; that does not
discharge source or necessity returns. Counsel retains process, font-origin and release judgments.

Since the pin, EDIT's calls and the CR35 bank path were added to [`milestone-calls.md`](milestone-calls.md);
those additions still need Source-column hygiene and a fresh review before crossing.

### Independent second-pass review - 2026-11-07 (fresh replacement)

Reviewed commit: `b257fd66d1cef746fc15d61f5ac4c22da9911c37`. Reviewers: eligible non-author sessions `leak_review_second_pass_replacement`, `modes_chip_review`, and `bios_review`. Parent coordination only. Every first-pass return is addressed below. No clean-side write.

The milestone 1-4 implementation package is **not cleared for handoff**. Four files remain returned. The reviewed decisions permit only the exact sanitized chip subset and milestone contract described below; the unchanged full source files are not exportable.

| File | Decision | Rule IDs cleared |
| --- | --- | --- |
| spec-a-post.md | RETURNED: DRAM initialization qualification, minimum-memory failure policy and dependent mode-state rules | None |
| spec-b-modeset.md | RETURNED: FIFO bound, VGA refresh choice and exact MODE-133 provenance | None |
| spec-c-vbe.md | RETURNED: dependent mode-set/palette source gaps; exact consistency rewrites supplied | None |
| docs/bios-rules.md | RETURNED: exact public default/extent exhibits and cursor-scaling evidence | None |
| docs/chip-rules.md | KEEP/REWRITE/CUT: only the specified sanitized subset | 24, listed below |
| milestone-calls.md | KEEP/REWRITE/CUT: only the specified sanitized contract | No native IDs; contract text only |
| freedos-1.4.md and `freedos-reports.md` (now issues #266, #267) | DEFERRED to milestone 6 (milestone 5 at the time; renumbered by the M-SENSE decision of 8 November 2026), not reviewed | None |

The chip clearance applies only after the exact CH-1 through CH-8 edits and cuts in the full record. The contract clearance applies only after MC-2, MC-2b, MC-3 and MC-4. No target specification was rewritten in this review. Do not export current whole files or treat these scoped clearances as approval of the returned dependent specifications.

Cleared chip IDs (24): `T64-ID-1`, `VP-ID-1`, `T64-PCI-1`, `PLL-1`, `PLL-2`, `CLK-1`, `CLK-2`, `CLK-3`, `CLK-6`, `MEM-1`, `T64-PLL-1`, `T64-CLK-1`, `T64-CLK-2`, `T64-MEM-1`, `T64-MEM-2`, `T64-MEM-3`, `T64-MEM-5`, `T64-MEM-6`, `T64-MEM-7`, `REG-1`, `REG-3`, `T64-REG-1`, `T64-REG-2`, `T64-ENG-1`.

Key new findings:

- The rendered DRAM sheet says **200 microseconds**, while its OCR, the extract and POST-41 say 200 milliseconds. Correct the attribution; still identify how the controller guarantees the eight qualifying RAS cycles.
- The FIFO example ends when refill begins; it does not establish the claimed worst delay until the FIFO is full or arbitrary traffic's maximum wait.
- Q100 and Q0F are settled owner decisions, but Q100 needs consistent query/D0 wording. Attribute flip-flop promises and effective CR35/CR6A bank reporting also need the supplied rewrites.
- Several precise IBM/VGATEST-dependent defaults remain unsupported by an inspectable primary exhibit. A missing exhibit is not proof of copying.

Fourteen concrete candidates were scanned against all three reference ROMs at a 16-byte threshold. Thirteen have zero matches. MODE-133 has a 22-byte register-state match in each ROM; its source gap remains returned. Independent PLL, image-size and page-count derivations are recorded. The packaged reproduction command was tested and reproduces the results without a git checkout.

The full record accounts for every first-pass return individually and provides exact replacement text, cuts, source evidence, access/eligibility declarations and counsel questions. Fonts and legal/release clearance were not granted.



#### Lead: A, C and milestone contract

#### Fresh lead review: parts A, C and milestone contract

Date: 2026-11-07. Commit: b257fd66d1cef746fc15d61f5ac4c22da9911c37.
Reviewer: /root/leak_review_second_pass_replacement, a fresh eligible non-author session. The parent coordinator did not adjudicate findings. The earlier stopped lead's work was not consumed. The independent B/chip and BIOS reviewers supplied their own reports directly.

##### Eligibility, access and method

I read the complete Downloads brief in bounded chunks before any project content; then global AGENTS, verified HEAD and a clean working tree, and read the required process, README Leak review, decisions and change-map in order. I have not authored or edited the target specifications and have not read any forbidden source. The only target mutation in this review is the separately requested README review record. Downloads remains unchanged. No clean-side writes, publication, commits, issues or external messages occurred.

Access log: full spec-a-post and spec-c-vbe; milestone-calls only the contract, between independently required start and stop matches `^## The contract(?:\s|\(|$)` and `^## The run(?:\s|\(|$)`; oracle-a in full and oracle-c through the in-scope bank-function comparison (plus subsequent permitted oracle comparison text in the same bounded read); repository AGENTS in full; the three allowed PCI/DRAM/VBE primary extracts; the allowed similarity scanner; the three reference ROMs as scanner inputs; permitted PCI2.3, V53C16256H, Trio32/64 and VBE1.2 primary sources. Full target bytes were hashed; milestone text output/search was contract-only. Full B/chip/BIOS substantive coverage belongs to the independently eligible named reviewers; lead machine scans of those allowlisted targets are supplemental. No root README, docs/764-rom, forbidden links, fonts, old local reviews or stopped-lead artifacts were opened. Administrative global AGENTS and PDF skill were read, and the PDF skill used read-only.

Checks 1-6 were applied afresh. `step1-scans.json` records exact hits with line numbers and identities. Counts: A0 names/13 address lines/0 notes; B0/0/0; C5/11/0; chip7/2/2; BIOS9/197/0; contract0/0/0. All A/C hits were read in sentences; children read every B/chip/BIOS hit. A address hits are PCI notation, BDA/public header fields, checksum extent and the project's duplicated-image ranges. C address hits are BDA, public interface or mode ranges. None authorizes a private reference-ROM offset to cross. C oracle/name hits are cut with provenance prose or out-of-scope OEM material. No in-scope font byte table appeared.

Source checks used primary text, not merely the author's extracts. PCI2.3 PDF225-230 (printed211-216) confirms the header, PCIR fields, x86 INIT address and checksum. The DRAM PDF17 was rendered and visually inspected: its printed unit is **200 microseconds (200 us, glyph µs)**, although the text layer yields `200 ms`. That OCR error propagated into the extract, owner-decision wording and POST-41. The original unit is evidence; a deliberately longer project wait would need separate attribution. VBE1.2 sections3,4,6.1-6.4,6.7 establish the status distinction, query schema, mode flags, page count and far-call interface. Trio32/64 sections9.1-9.2,11.1-11.2,CR31/35/51/6A establish PLL, access preconditions and effective bank selection. The extended-sequencer SR08-SR18, CR31-CR6A, cursor, PCI configuration and strapped-memory fields were also checked directly in their primary register descriptions; the independent chip review covers the cited chip-rule primitives; unresolved dependencies are explicitly held below.

The numeric verification enumerated every allowed MCLK M/N/R tuple under the stated caps. POST-23 gives 42h/41h=59.95737875MHz; 22h/25h=69.8011275MHz; 27h/56h=69.999991111MHz; 46h/79h=55.035504375MHz, with valid VCO values. Thus the changed55MHz example and default60MHz derivation keep. Mode100/101 pictures are256000/307200bytes; image-page counts at1/2/4MB are3/7/15 and2/5/12. Mode101 columns80, rows-minus-one29, height16 and TotalMemory16/32/64 are independently derived. The PCI length32KB/512=40h is public arithmetic.

`step6-actual.log` contains actual `python emu/similarity.py FILE --min 16` runs against all three pinned reference ROMs. Six240-byte ModeInfoBlock tails (offset10h-FFh, modes100/101 at1/2/4MB) have no >=16-byte match. The unknown WinFuncPtr is excluded rather than filled with invented reference bytes. The two192-byte B00-11 palettes and two44-byte reviewer serializations of the surviving C mode rows also have zero matches. The numeric-row encoding is documented in step6-c-mode-rows.json and is not a BIOS table-layout requirement. B's independent report inventories its required candidates and the investigated22-byte MODE-133 match. The scanner's `--self-test` returns0 failures. All >32-byte concrete tables surviving this scope are covered; A's POST register catalogue contains partial/dynamic state, not a serialized >32-byte image, and the PCI structure is24bytes. Header and pointer layouts are public standards; no unknown bytes were invented to form a candidate. Contract call tables contain interface facts/counts, not a binary payload. B/BIOS layout-only tables and out-of-scope tables are inventoried in the child reports. These scans test the specified candidate representations, not hypothetical future implementation bytes or all possible table permutations.

##### Part A decisions

A-1 **returned**: POST-41's first-pass initialization premise is still incomplete. The DRAM source requires200us and eight qualifying RAS-containing initialization cycles, also after a no-clock interval exceeding its refresh interval. The specification correctly rejects arbitrary CPU reads as proof but still leaves the required controller conditions unidentified. Question to author: Which publicly documented controller condition/access class or measured external initialization behavior guarantees the eight qualifying cycles before the first relied-on test/write, including the clock-gap case? State a behavior/qualification requirement, not a vendor routine. Correct every200ms-as-datasheet claim in POST-41 and its source extract/decision companion. A conservative200ms project delay may be retained only if explicitly distinguished from the200us primary minimum.

Exact minimum source correction for POST-41, without resolving the returned controller question: replace `an initial pause of at least 200 ms after VCC` with `an initial pause of at least 200 us after VCC`. Replace the system-BIOS-assumption sentence with `The ROM must establish that the power-up pause has elapsed before relying on DRAM. At least eight RAS-containing initialization cycles are also required after a period without clocks longer than the refresh interval.` Keep the prohibition on treating arbitrary aperture reads as proved cycles. The screenshot, not the OCR spelling, resolves the unit.

A-2 **keep**: POST-21/22/23 and T64-MEM-7 now distinguish the60MHz public limit from the optional board overclock. The rating return is settled. Numeric pairs were independently reproduced. Cut Windows/card anecdotal clock details where they add no necessary milestone behavior. The legacy general patch-build AGENTS wording calling70MHz a rating does not override the explicit clean-build decision.

A-3 **rewrite**: POST-6 becomes `The target is the Trio64, identified by the public CR2E/CR30 definitions in T64-ID-1. Behavior on a Trio32 or Trio64V+ remains outside the selected target policy and is an open question. The clean ROM does not need to distinguish 86C764 from86C764X by a driver's identification table.` Source `T64-ID-1; milestone target decision`. Cut the driver-table distinction, blanket5xh claim and unnecessary T64-ID-2 dependency. If later-chip identification is retained at all, use only the independent chip review's narrow VP-ID-1 replacement; do not generalize its observed54h card to every5xh revision.

A-4 **rewrite**: remove the forbidden port-plan link and comparison-implementation paragraph. Opening replacement: `Behavior specification for the milestone1-4 clean-room Trio64 BIOS, written from scratch. This part specifies POST, caller conventions and the option ROM for the ExpertColor DSP-3364P. Public hardware requirements and explicit project choices are distinguished below.` ROM-7 Source becomes `Milestone1-4 owner decision; PCI2.3 section6.3.3.1 (VGA execution atC0000h); project image budget`. Remove other plan-item dependencies. Cut SeaVGABIOS-specific assertions in question10 and all Windows acceptance question11; no other BIOS source comparison crosses.

A-5a **rewrite**: POST-15 specifies the result/qualification without prescribing candidate iteration order: `Determine installed memory at POST and encode CR36 bits7-5 as110b for1MB,100b for2MB,000b for4MB, preserving bits4-0. A4MB result is permitted only for Trio64 fast-page memory. Do not infer installed size from the reset size straps alone. POST-16 specifies a sufficient observable test condition; test ordering is the clean implementation's choice.` Keep the public memory-size codes and qualification. 

A-5b **returned**: the unqualified1MB fallback after every memory candidate fails lacks a source or explicit failure policy. Question: `What observable minimum-memory failure policy is intended after no test candidate holds, and is the1MB code merely a project fallback or a verified-capacity claim?` Label the answer as policy or support it with public/necessary observable evidence; do not reuse a reference sizing routine.

A-6 **rewrite**: POST-4: `Change CR40 bit0 by read-modify-write, preserving bits7-1 as found, as T32/64 section11.2.2 requires. The documented reset value is30h; reserved-field encodings are hardware descriptions, not permission to overwrite the preserved bits.` This removes the simultaneous only-bit0/preset-other-bits contradiction. POST-13's final cross-reference changes `POST-27` to `POST-31`. POST-36z changes `CONV-8` to `CONV-10` and `CONV-9` to `CONV-11`.

A-7 **rewrite**: POST-40 becomes `Observe the hardware preconditions named by the affected rules: wake the device before accesses requiring it; unlock protected registers before accessing them; determine identity/configuration before applying chip-dependent limits; complete qualified DRAM initialization and clock readiness before relying on memory; establish usable addressing before memory accesses; enable enhanced-register access before its use; wait for engine idle before clearing CR40 bit0. Leave the required final POST/mode03h state and lock state before returning. Independent operations have no prescribed total order.` Source `T32/64 sections9.2,11.1,11.2,13.1; POST-41's reviewed DRAM requirements; project final-state contract`. Do not export the numbered nine-step recipe as a vendor-independent hardware-mandated total order. POST-30's `MCLK ... loaded first` must similarly be framed as a project readiness constraint, not an unsupported universal reset-order claim.

A-8 **rewrite**: CONV-4 and CONV-5 retain their useful interface contracts as **project design choices**. Replace their Sources with `AGENTS Clean-room rules: Project choices and Assembly conventions; this specification's explicit register-preservation/bounded-wait policy`. Prepend `Project design choice:` to each Rule. Move test-docstring claims entirely to Checked by; cut the Windows rationale. CONV-6 keeps its no-timer-dependence rule with the same project attribution and PCI INIT context. This settles the source-attribution return; test source was not read. CONV-8/9 keep their explicit chosen lock/index contracts. CONV-10/11 keep the non-write/aliasing constraints and unresolved hardware-field prohibition.

A-9 **rewrite**: ROM-1 Source must also cite PCI2.3 sections6.3.3.1 and6.3.3.1.3; section6.3.1.1 alone does not define the x86 size/entry/checksum. Replace the parenthetical `(a jump, called far by the system BIOS, returns far)` with `(called far by the system BIOS, returns far)`: the public interface is an entry reached by FAR CALL; a private implementation jump is unnecessary. ROM-2 replace `pointer to vital product data0000h (the Trio64 has none)` with `reserved field atPCIR offset08h=0000h (formerly the VPD pointer in older revisions)`; PCI2.3 explicitly calls it reserved. Replace `(PCI2.1)` after revision00h with `(PCI2.3 section6.3.1.2)`.

A-10 **rewrite**: ROM-3's00h padding and ROM-6's fixed size are project policies. Source text must distinguish them: `Project fixed32KB image policy; PCI2.3 section6.3.3.1.3 checksum requirement`. Replace ROM-6 with `If INIT modifies its shadowed image, it must leave a correct byte checksum over the runtime length. This project keeps the size byte40h and its PCIR structure fixed; PCI2.3 itself permits a smaller runtime length.` Keep ROM-4's duplicated EEPROM project requirement; the ranges are image packaging, not private ROM code. Cut the unrelated Trio64V2 anecdote. ROM-8/9 keep: own text; no unsupportedIBM literal/offset. First-pass ROM/source return is settled by these exact public-source corrections; no private placement crosses.

A-11 **cut**: CONV-3/12, their Windows obligations, later-chip erratum discussion in POST-32 and Sources disagree, unnecessary driver test citations, and all forbidden-link destinations from the clean copy. POST-32 keeps the public T32/64 D000h/E000h reset/default justification as a labeled project warm-start policy, with no ENG-1 dependency. POST-27 keeps the45MHz power-on/book rule and a generic prior-software clock warning, cutting its named Windows-driver example. Questions remain observable requirements questions, never reference-state defaults.

A-12 **returned**: POST-34/36/37 and CONV-7 depend on unresolved partB VGA FIFO/refresh and BIOS standard-table/font provenance. Question: update the exact dependent citations after those source returns are settled, then demonstrate that the POST final state and mode03h restore contract refer only to cleared rules. This is a dependency hold, not an allegation that all the listed public bits were copied. POST-36m/36s and question8 must not silently turn an open VGA timing choice into an approved value. Question4's old6-MCLK FIFO note is cut with the rejected old formula.

A-13 **rewrite**: POST-36p says all CR46-CR4F are undefined at power-on, but the primary T32/64 CR46/47 entry (PDF196, printed16-3) gives0000h for the X-origin pair. Replace `undefined at power-on and unused while bit0=0` with `not used while the hardware cursor is disabled; CR46/47 have a documented0000h reset value and CR48-CR4F are documented undefined`. Keep the project choice not to program unused cursor data.

A-14 **rewrite**: POST-1's invalid-BDF fallback, POST-9's recovery write and POST-10's prohibition on BAR assignment are project initialization policy around the public PCI interface. Add `Project initialization policy` to those Source cells for these choices; PCI defines the address and fields but does not mandate those fallback algorithms. No bus-scanning or reference routine structure is introduced.

All remaining A rule content is **keep** as public state, hardware preconditions, arithmetic or explicitly marked project policy, subject to the named source/dependency holds. No A rule ID currently clears because returned findings remain. Hardware questions5-9,12-14 may remain as questions without prescribed answers; other-chip questions1/2 are deferred and Windows question11 cut. No unrun hardware validation is represented as passed.

##### Part C decisions

C-1 **rewrite**: narrow the introduction to `Milestones1-4 provide the reviewed 4F00h,4F01h queries for100h/101h,4F02h set of101h,4F05h and its far entry, and general status/index contracts. Other functions and modes are deferred. The ROM is written from scratch.` Cut port-plan/SeaVGABIOS links and comparison prose, oracle link/provenance paragraph, the remaining `SeaVGABIOS's vbe.c` sentence, and S3M-1..6/OEM-1..10 in their entirety. S3M-2's incorrect README attribution is deferred, not silently cleared. Cut modes other than100h/101h, VBE-42/46/48/52/60..68/70..75/80..83 and associated later-mode/Windows questions. Fixed DAC6-bit hardware facts remain in VBE-24/44 without requiring4F08h. Keep only the banked101h consequences of shared rows and VBE-35's zero direct-color fields; no other-mode examples cross.

C-2 **rewrite**: VBE-1's last sentence becomes `For an implemented function, AX=004Fh means success and AX=014Fh failure. An unimplemented function follows VBE-3 and returns AL other than4Fh.` VBE-3 becomes `Any VBE function outside the implemented milestone set00h,01h,02h,05h returns AL other than4Fh and leaves video state unchanged; AX=0100h is this project's permitted refusal result. This includes03h,04h,06h-FFh.` Remove its current4F03h result dependency. VBE-2 Source adds `Project failure atomicity/preserve-state policy (AGENTS Project choices)`; the VBE mode-set failure quote does not alone define all-function atomicity. VBE-4/5 keep their explicit chosen IF/index/lock attribution; change VBE-5's lock Strength to must(project) to agree with CONV-8.

C-3 **rewrite**: the owner Q100 decision is valid project policy, but VBE-30/31 still contradict it. Replace VBE-30 with `For CX=0100h or0101h, also accepting bit15 as a project extension, return AX=004Fh and exactly256bytes of the corresponding public ModeInfoBlock; preserve other registers. The100h query is an explicit project extension to the listed-mode input contract. Other query numbers or reserved bits9-14 fail with014Fh and leave the caller's buffer unchanged.` Source `VBE1.2 section6.3; decisions Q100; project query extension`. Replace VBE-31 with `For100h, D0=0 regardless of fitted memory. For101h, D0=1 only when it is supported and one full image fits. D1=1,D3=1,D4=1,D5-15=0. D2=0 unless all standard output functions are implemented for that mode. Thus without banked output100h reports001Ah and101h001Bh when supported.` VBE-11/12 retain only image-fit arithmetic plus the explicit Q100 policy override. The first-pass100h **policy** return is settled; the current contradictory wording needs this decided rewrite before export.

C-4 **rewrite**: VBE-10/20..27/32..37 within100h/101h scope describe public information blocks and project window/character choices. Add `Project interface choice` to the Source/Strength of VBE-33 and VBE-37 and to the non-null WinFuncPtr table row; VBE1.2 permits a null pointer, and does not mandate choosing the tallest divisible font. Formulas/public field widths keep, including the independently checked page counts and zero direct-color fields. Remove any implication that unused/zero fields are reference-ROM data. VBE-37 must say `both queryable modes100h and101h`, replacing `every listed mode`, for the Q100 extension. The bank function is called in the active101h mode, not proof that100h is settable.

C-5 **rewrite**: VBE-40 removes the named Windows call example; the public BX interface is enough. VBE-41 retains only101h success and failures for100h/other out-of-scope extended modes/reserved flags under the milestone policy. VBE-43's all-installed-memory clear is explicitly a project choice; the standard clear flag alone does not specify every offscreen byte. VBE-45 **keep** within101h: Q0F's40h/ C0h memory-preserve behavior and AH00h40h reinitialization are this ROM's assigned interface, not S3 numbering. The old AH0F return is settled. BDA field values are public VGA semantics applied by project policy; the formula derivations agree. Do not export the oracle's69h value or font pointer.

C-6 **rewrite**: VBE-44's final clause becomes `Attribute-controller accesses follow B00-9; no final flip-flop state is promised.` Its Source and Checked by must drop the final-state expectation. Add `CR31 bit3=1` to the banked101h mapping output, citing T32/64 CR31 and partB MODE-127. For the in-scope default pitch spell out `640bytes per line, CR13=50h, CR51 bits5-4=0, CR43 bit2=0`, citing public offset encoding and partB, not deferredVBE-60. Fixed DAC width stays6bits from hardware. DAC initialization uses only BIOS palette content eventually cleared by its independent review. VBE-47's independence from prior mode keeps subject to that dependency.

C-7 **rewrite**: VBE-53 becomes `After4F02h101h, CR6A bits5-0, CR35 bits3-0 and CR51 bits3-2 are zero. A successful4F05h set establishes the requested effective64KB bank; for bank0 it must clear the old fields as well as CR6A. The caller may subsequently changeCR35 directly. The BIOS does not promise those fields remain zero after client writes.` Source T32/64 CR31/35/51/6A. VBE-55 becomes `Get returns the current effective64KB page: useCR6A bits5-0 when nonzero; otherwise useCR35 bits3-0 withCR51 bits3-2 as page bits5-4. Return the page inDX, AX=004Fh and preserve other registers.` This follows the primary register mux and repairs the conflict with the observed benchmark's directCR35 banking; merely readingCR6A would incorrectly report bank0. VBE-51/54/57 otherwise keep the101h range and explicit failure-policy choices.

C-8 **rewrite**: VBE-56 retains farCALL/RETF, BH/BL/DX inputs, no need to preloadAX, permittedAX/DX clobber and get result. Keep other registers/index/locks/IF as explicit project contracts, not extra VBE1.2 claims. Delete `uses only a few words of the caller's stack, and calls no INT`: neither cited public interface defines those restrictions, and they prescribe unnecessary internal implementation. Source `VBE1.2 section6.7; project preservation policy CONV-4/8/9 and VBE-4/5`. Out-of-range calls leave mapping unchanged as the existing project decision, with no claim that VBE1.2 far status reports errors.

C-9 **rewrite**: CR35 units note becomes `T32/64 CR31/35/6A define64KB pages for this mapping. The milestone4 program's observed directCR35 bank writes require CR6A=0 and the old-field mapping to be active after mode set. This is an external compatibility requirement; it prescribes no BIOS or caller routine.` Remove links to The run or any routine/disassembly details. The contract observation may support necessity; primary register definitions establish the encoding.

C-10 **returned**: VBE-41/44/47's promised101h set and palette depend on unresolved B MODE-133/136 and BIOS default-VGA/palette provenance. Question: provide the cleared mode-state and palette rule references after those returns are resolved, then review the resulting dependent mode-set contract. No C ID currently clears while those returns remain. General public status/schema rules were reviewed but are not file clearance by themselves.

##### Milestone contract decisions

MC-1 **keep**: observed caller inputs/counts are explicitly partial black-box observations, and ordering describes the caller, not BIOS internals. The omission list prevents falsely claiming an exhaustive workload. Q100/Q0F and the bareMS-DOS/emptyPATH boot policy are explicit owner decisions. The author may keep these requirements without a vendor implementation trace.

MC-2 **rewrite**: Sources of repeated `AH=00h AL=03h` rows become `OBS-M4-320/OBS-M4-640 as appropriate; bios-rules B00-1/B00-22`. Repeated `AH=12h BL=34h` rows become `OBS-M4-320/OBS-M4-640 as appropriate; VGADOC INT10h AH12h BL34h; bios-rules B12.34-1`. The combined first640 row gets `OBS-M4-640; VGADOC/RBIL AX1A00h,AH00h,AH12h BL34h`. The 4F01 source becomes `OBS-M4-640; VBE1.2 section6.3; decisions Q100; partC VBE-10/30/31`. The4F02 source becomes `OBS-M4-640; VBE1.2 section6.4; partC VBE-40/41/43/44`. These exact Source replacements settle the first-pass repeated-row source omissions; OBS-only input counts do not justify outputs.

MC-2b **rewrite**: in the EDIT `AH=01h,CX=0607h` row, replace What the program needs with `Apply the documented cursor-emulation semantics to the supplied8-line-cell shape; no exact resulting CR0A/CR0B pair is specified by this contract.` Source becomes `OBS-EDIT; RBIL INT10h AH12h BL34h; bios-rules B12.34-1`. This avoids importing B01-4's currently returned exact-scaling exhibit through a contract citation.

MC-3 **rewrite**: banking bullet becomes `No4F05h or WinFuncPtr call was observed during drawing in the recorded window-call trace. The program uses directCR35 banking. After4F02h101h, require CR6A=00h, CR51 bits3-2=0, CR35 bits3-0=0, and CR31 bits0 and3=1. Sources: observed client interface requirement; T32/64 CR31/35/51/6A; partC VBE-44/VBE-53. The4F01h window fields and far entry must describe the implemented interface truthfully.` Cut `details in The run` and all navigation to that excluded section. Do not infer how its bank routine is implemented.

MC-4 **cut**: The run and all material below its heading, all S3REGS4F03h instrumentation, and the richer-shell aside from the clean copy. I did not read The run. Preserve only the affirmative M2-BOOT requirement. Milestone5 files remain deferred, unreviewed and uncleared.

MC-5 **keep**: the resulting contract is independently safe requirements text after the exact MC-2/3/4 edits; its observations and requirements carry sources and policy. It does not certify that partsA/B/C implement the requirements. The contract has no native rule IDs; only the specified sanitized contract is cleared. The unchanged full milestone file is never cleared. If the owner needs a currently materialized clean copy, produce it later from these decisions; this review writes no clean-side copy.

##### First-pass return closure and limits

A rating: settled. A public ROM/source attribution: settled with exact editsA-8/9/10; source claims not silently inherited. A POST-41: still returnedA-1 (and corrected unit), minimum-memory fallback/dependencies separatelyA-5b/12. B FIFO: still returned; B101h refresh source settled with actual-clock rewrite; VGA refresh still returned. C100h policy and AH0F assignment: settled; Q100 contradictions have exact corrections and mode-set dependencies remain returned. ChipT64-MEM-7 rating: settled as board policy; old four notes settled by scope cuts, new driver notes cut. BIOS eight rows/question17: use the independent per-item closure matrix. Contract sources100h/AH0F: settled with MC edits. S3M-2/OEM/other modes and FreeDOS files: deferred, not cleared.

Counsel: process sufficiency and isolation; font origin/licensing and any eventual equal bytes; public-source redistribution/quotation; release license and distribution; any later necessary driver-derived identification transfer. Engineering review is not legal clearance. No glyph file was opened or licensed here. Hardware cold boot, DRAM retention, FIFO behavior and milestone execution remain acceptance work; this was a source/leak review, not hardware validation.


#### Independent B and chip review

#### Independent part B and chip-rule second-reader review, 2026-11-07

Reviewer: /root/leak_review_second_pass_20261107/modes_chip_review (eligible non-author session).
Pinned commit: b257fd66d1cef746fc15d61f5ac4c22da9911c37; independently verified with git rev-parse HEAD.

##### Eligibility and access

I have not authored or edited any reviewed file. Before project access I read the complete user brief at C:\Users\kristoffer.sjothun\Downloads\leak-review-brief.md, then global .codex/AGENTS.md, then the required process section, Leak review section, owner decisions and review-2026-11-02.md in that order. I have not read Phoenix sources, riplin, any other BIOS source, the port plan, patch source/change logs, S3ALIAS source, BRIEF.md, or milestone-calls The run. No target, shared README or clean-side file was edited. The stopped lead's later substantive material was not consumed; my findings below are independently generated. The lead's initial authorization delegated global scans; I also reran B/chip scans and in-scope table checks myself.

Source/access log (all repository paths relative to the pinned checkout):
- docs/clean-room.md: only The process section.
- docs/cleanroom/README.md: only Leak review section.
- docs/cleanroom/decisions-milestones-1-4.md and review-2026-11-02.md: full permitted files.
- docs/cleanroom/spec-b-modeset.md and docs/chip-rules.md: full files, including all notes and out-of-scope text, for scoped cuts.
- docs/cleanroom/oracle-b-modeset.md: overview, differences, write order, memory/VGA-return sections, and mode comparison tables through 114h. Only comparison evidence; no oracle bytes proposed to cross.
- docs/cleanroom/spec-a-post.md and spec-c-vbe.md: citation-ID search; specific POST-6/22/23 and CONV-8/9 rows in A.
- docs/bios-rules.md: source/cross-reference searches including B00-7/8/9 and VGATEST citations. Independent bios reviewer supplied their own source-gap assessment; no disqualified-lead conclusions used.
- docs/cleanroom/primary-extracts/v53c16256h-power-up-and-refresh.md and dmt-640x480-60hz.md: full.
- AGENTS.md: full, as explicitly allowed by brief. Its conflicting legacy chip-rating/default statements are not used to override the milestone owner decision.
- docs/765-rom.md: targeted revision/Hercules/54h matches and nearby lines only, including the card observation at lines 234-237. No linked code opened.
- emu/similarity.py: full permitted tool; run on independent candidates against the three allowlisted reference ROMs. Reference ROMs accessed as bytes by this tool only.
- datasheets/trio32-trio64-graphics-accelerators-mar1995-683a4e3d90be5389587761.pdf: extracted text for permitted primary-source lookup; read selected relevant pages, particularly PDF 56,58,60,63,64,72-74,92-94,191-192,203,207.
- datasheets/V53C16256H-1.PDF: PDF pages 1 and 7 directly checked; revision/date June 1998, Rev2.3.
- datasheets/db018-a-trio64v-integrated-graphics-video-accelerator-jul95-6838e75548745379014663.pdf: search for identification then PDF193, printed17-2.
- Explicitly allowlisted public https://glenwing.github.io/docs/VESA-DMT-1.10.pdf: PDF page10 directly read (download stored only in this review folder); matches extract. A web screenshot attempt failed with cache miss; local fitz extraction/render succeeded.
- PDF skill read as read-only workflow. Only read-only extraction/rendering, no PDF authoring.
- Existence enumeration only: datasheets and standards. The sparse checkout has no standards/thoegersen or primary VGATEST table. No other discovered repository file read.

All shell commands used the pinned repository, C:\tmp, or this task directory explicitly as working directory. Scratch only under modes-chip. No large run: checked free C: space (about3.54GB) before further outputs. Parent coordinator owns archival cleanup; this folder is active evidence and must not be deleted until included in the canonical archive.

##### Six checks and numerical evidence

1. Independent prescribed case-insensitive name scan: B has 0 hits; chip has7 name hits (lines77,79,80,179,180,183,190). Separate note scan adds the two notes at61 and65. Prescribed offset scan: B0; chip2 (line70 V2 PCI ROM offsets, line229 PCI vendor:device identifier). Every hit was read in its sentence. Both chip offset hits are cut with their out-of-scope sections; 5333:88F0 is PCI notation, not a ROM offset. PLL-2's test_s3patch.py is a test name, not provenance; remove that clean-copy test-source reference as below. Other name hits are cut.
2. Every in-scope B/chip row names a data-book section/register, a chip ID resting on a book, IBM/VGADOC/VBE/DMT, or a marked project choice. Important exceptions are the driver-ID additions (cut), MODE-139's forbidden plan citation (rewrite), MODE-143's unsupported final ATC state (rewrite), MODE-133's unverified exact IBM table claim (returned), and MODE-136's incorrect description of its named source (returned). A source label alone was not accepted as verification for the returned values.
3. Direct public-source and arithmetic checks: PLL 25.175 target gives M40,N1,R3, SR12=61h,SR13=28h, VCO200.45452MHz, output25.056815MHz, error-0.4694538%, line31321.01875Hz and frame59.6590833Hz. This is the first N of T32/64 section9.1 procedure, within0.5%; same bytes in oracle do not make this a leak. MODE130 actual clock n2 gives501.1363 refreshes/8ms, n3 gives751.70445. DRAM requirement512/8ms is verified in primary sheet pages1,7. T32/64 section7.2 expressly says cycles per horizontal line, during horizontal blanking. The book therefore supports the stated per-line controller rule; actual card retention remains an acceptance check, not proof of copied code. The mode101 nominal FIFO expression71*25.175/59.96=29.8103bytes is arithmetically correct but does not prove its source premise: see B-1. T64-MEM-7 formula gives69.8011275MHz and is explicitly board policy, not a public chip rating.
4. B describes public state/constraints, not a vendor routine sequence. The forbidden-plan links must be cut. MODE-139 lock restore is a project contract, not public hardware behavior. MODE-142 correctly declines to prescribe order among independent state writes. The old114h worked example, old FIFO formula, other modes and chipset/driver/OEM material do not cross. No BIOS sign-on string, private packed mode record or routine name was found in the in-scope B copy.
5. Driver tables T64-ID-2/AV-ID-1 and INF material in VP-ID-1 are not required for DSP-3364P VGA/101h. Cut rather than infer entitlement from a driver table. Necessary V+ boundary knowledge can retain the public4xh statement plus the narrowly identified54h card observation, without generalizing all5xh values. Existing four chip first-pass notes are settled by cutting their out-of-scope containers, not by deleting note markers. T64-MEM-7's69.8 observation serves only explicitly labeled board policy. No reference BIOS implementation is a source for a retained register sequence.
6. Numeric candidate manifest is numeric-candidates.json, generator numeric-check.py, raw output numeric-check-results.txt and per-candidate *-similarity.txt. The three in-scope mode101 numeric row candidates (44/44/64bytes) produce no>=16-byte match in any of three ROMs. MODE133 has34bytes in stated SR01..04 || GR00..08 || AR00..14 order and matches22bytes in each ROM: candidate0C..21 is GR08=FF followed by AR00..0F identity palette and AR10..14=41,00,0F,00,00. Exact dirty offsets remain only in evidence logs. This positive match is not proof of improper copying; its primary table/explicit derivation is unresolved (B-4). No font data occurred. No exclusion range was used to hide it.

Numeric table inventory for parent-wide scan: the full B mode table, timing table and derived-per-mode table contain more than32bytes. Only101h rows survive this scope; other rows are cut. Our three retained-row serializations use explicit little-endian32-bit fields, with timing clock inHz and derived rounded clock inkHz/frame rate in hundredthsHz. These are reviewer search serializations, not a mandated clean BIOS table layout. MODE133 is a distinct explicit34-byte inline register table and was scanned directly. The remaining B/chip tables are prose rule catalogues, not encoded numeric payloads. In-scope chip rows contain no standalone>32-byte numeric data table; driver/OEM tables are cut. Parent's global text/token scans may supplement, but do not replace, these direct candidates.

##### README-ready file record: spec-b-modeset.md

Date2026-11-07; commit b257fd66d1cef746fc15d61f5ac4c22da9911c37; reviewer modes_chip_review. Decision: RETURNED, VGA/101h subset. No B rule ID is cleared to cross while the returns below remain. Full file read; other modes cut from clean copy.

B-1. RETURNED: MODE-136 and dependent MODE-103/MODE-148, MQ-11/MQ-12. The previous FIFO-premise return is NOT settled. T32/64 printed7-8/7-9 (PDF63/64) describes M+1 other memory accesses, giving one entry plus M page accesses as an example. Its9+2*M expression ends when memory access is returned for FIFO filling, not when the FIFO is full again. It does not state that arbitrary CPU/graphics traffic has only one entry. As an illustration of the missing bound,32 separate9-MCLK entries would consume288MCLKs and120.92bytes at the stated nominal clock ratio, exceeding a64byte FIFO; this is not asserted as the actual controller worst case. Returned question: What primary controller guarantee, fully stated conservative derivation including possible page changes/refill latency/higher-priority work, or necessary observable hardware test supports M31 for the permitted1/2/4MB cases and the lower-MCLK fallback? Replace the false 'worst wait ... full again' statement; distinguish an owner-selected provisional value from a proved safe requirement. The old112/56/23/C formula and114h example remain cut. A card acceptance check must not be represented as already passed.

B-2. REWRITE: MODE-130 (101h refresh). The DRAM source part of the previous refresh return is SETTLED. Replace its current31.469kHz clause with: 'Use the horizontal rate produced by the programmed PLL. For MODE-119,25.056815MHz/800=31.32101875kHz; n=2 gives501.1363cycles in8ms and n=3 gives751.70445, so n=3 and CR3A=17h.' Replace the concluding source-premise sentence with: 'This derivation uses T32/64 section7.2 and CR3A: refresh is performed per horizontal line during horizontal blanking. Retention and the fitted part revision remain hardware acceptance questions.' Source: T32/64 section7.2/CR3A and V53C16256H Rev2.3 June1998 pages1,7. Hardware confirmation may remain in MQ-5 without falsely presenting the public per-line rule as a copied BIOS behavior.

B-3. RETURNED: MODE-147/MQ-5 VGA refresh. The previous refresh return is only PARTLY settled overall. MODE-147 still sends the VGA count to MQ-5, which asks whether to keep CR3A bit2=0 with CR11 bit6=0 or override it; it does not select a final VGA contract. Returned question: Specify the VGA refresh count and controlling register fields for the allowed VGA modes, from public IBM/controller timing and the fitted DRAM requirement; distinguish that rule from remaining retention testing. Do not merely refer back to the open question.

B-4. RETURNED: MODE-133 and its exact 'as IBM mode13h'34-byte state. The22-byte reference match was investigated. The specification names IBM/VGATEST through B00-7, but an inspectable primary VGATEST table was not available in the permitted evidence. Independent bios reviewer likewise could establish bit meanings for many fields but not the complete exact IBM table. Returned question: Supply an allowlisted inspectable primary table for the exact bytes, or replace the IBM equivalence assertion with a complete functional derivation and explicitly attributed project defaults for unused fields, the identity palette and black overscan. The equality is not by itself a leak finding, but it cannot be cleared solely from the oracle or B00-7 repeating the source label.

B-5. REWRITE: MODE-143. Replace with: 'This ROM preserves the sequencer, graphics-controller and CRTC index registers as the caller left them (project contract, CONV-9). Before each first access to the attribute controller, establish its index state by reading Input Status1 (B00-9). No final attribute-controller flip-flop state is specified.' Source: CONV-9/project decision and B00-9. The original final-index-state claim is not supported by B00-9, which explicitly states no final state.

B-6. REWRITE: MODE-139 Source and lock attribution. Replace the forbidden-plan source with 'T32/64 section11.2, CR35 and CR11; CONV-8 (project lock-preservation contract), decisions-milestones-1-4 Index/lock.' Add 'Project contract:' before the sentence restoring the three lock values. Hardware unlock values48h/A5h/06h and CR35/CR11 programming preconditions keep. This removes the port-plan dependency without introducing a vendor routine order.

B-7. REWRITE: introduction and scope. Use: 'Behavior specification for the milestone1-4 clean-room Trio64 BIOS on the ExpertColor DSP-3364P: setting banked VBE101h and returning to standard VGA modes00h-13h. The ROM is written from scratch. Register definitions and requirements come from the named public standards and data books; project choices are labeled.' Cut the port-plan link, item numbers tied to it, the SeaVGABIOS comparison paragraph, and source links to that plan in MODE-102/131/139. MODE-102 is wholly out of scope. MODE-131 instead cites VBE1.2 banked-window scope and the milestone owner decision.

B-8. CUT/scope rewrite: mode/timing/derived tables retain only101h; MODE-101 becomes 'The sole settable packed VBE mode in milestones1-4 is101h:640x480x8, pitch640,307200bytes. Mode100h is queryable but not settable under partC Q100.' Source: VBE1.2 and decisions Q100. Cut MODE-102 and MODE-137 entirely. MODE-104/106/109/113/119/120/122/124/125/126 retain only the101h and VGA consequences:640x480@60 total800x525 negative/negative; PPC=DPC8; extension bits0; MODE11961h/28h; mode0DCLK<=80MHz and PCI-half-clock floor; clock doubling disabled; CR67 high nibble0; pitch640,offset80; engine width640/one-byte codeCR50=40h. Cut all other mode rows/clauses, the entire114h example, MQ-1/2/9/10/13/15, all4F06/4F07 obligations, and Windows/other-chip acceptance questions. For MODE128 retain display start/bank zero at mode set and CR6A for4F05; delete the later4F07 sentence and do not interpret 'old fields stay0' as forbidding client CR35 banking described by partC.

B-9. REWRITE: MODE-112/115 and MQ-16 attribution, not silent DMT equivalence. Current no-border programming is already a specification choice. Add to their Source/Strength: 'Project blanking choice using T32/64 table11-2 register encoding; DMT fixes active area, totals and sync positions but includes an8pixel/8line border.' Replace MQ-16 recommendation with: 'DMT640x480@60 includes8pixel horizontal and8line vertical borders. MODE-112/115 currently choose to blank those regions while retaining DMT active area, syncs and totals. A change to DMT border programming requires an explicit project decision and new derived register values.' Do not present HA/HT-1 or Vactive-1/Vtotal-1 as the exact DMT border. Update broken DMT link to the allowlisted public PDF. This is a source-attribution rewrite, not approval of unrun hardware positioning.

B-10. KEEP: MODE-119's25.175MHz pair and in-scope PLL derivation; previous pair concern SETTLED. T32/64 section9.1 provides the allowed procedure, range and tolerance. The first N=1 gives M40,R3 and independently reproduces61h/28h. Keep the stated rounding choice as a project interpretation; MQ-4 remains an observable design/source ambiguity, with no reference-ROM value used as authority.

B-11. KEEP within the scoped copy, subject to inherited B-1/B-3/B-4 returns: MODE-105,107,108,110,111,114,116,117,118,121,123,127,129,132,134,135,138,140,141,142,144,145,146,149,150. The remaining surviving IDs are exact scoped rewrites described above. MODE-140 strength should agree with MODE-138/data book 'should' for screen-off M/N programming; it currently calls it 'must' parenthetically. MODE-149 must preserve the caller's CR40 bit0 under CONV-8; its except-as-found qualification supplies that. MODE-150's BIOS flag registers are a non-write constraint only; remove 'item5 of the plan'. No routine-layout inference is cleared. MQ-3/4/6/7/8/11/12/14/16 may survive only as observable questions, not requirements; trim Windows and non101 references. MQ-5 remains returned as B-3.

##### README-ready file record: docs/chip-rules.md

Date2026-11-07; commit b257fd66d1cef746fc15d61f5ac4c22da9911c37; reviewer modes_chip_review. All findings for the24 retained IDs are KEEP/REWRITE/CUT below, with no chip-row return left. Clearance applies only to the explicitly sanitized milestone copy, not the unchanged entire source file. B's FIFO return is not discharged by this chip primitive catalogue.

CH-1. KEEP: T64-MEM-7 as explicitly marked project/board policy, not a public86C764X rating. Previous rating return SETTLED. MEM-1 remains60MHz; observed69.8011275MHz does not expand that public limit. REWRITE MEM-1: delete '(for the Trio64 our tools take70MHz,T64-MEM-7)' and append 'The DSP-3364P optional overclock policy is separately T64-MEM-7; it is not a data-book rating.' Keep the60MHz Trio32/64 portion and the policy distinction; out-of-scope chip clauses may be cut. The legacy AGENTS wording calling70MHz rated is not imported.

CH-2. CUT: T64-ID-2 and AV-ID-1 including both review notes, names/codes from the driver table and code-path identifiers. No cited public data book or necessary milestone compatibility need supports their crossing; POST-6 says the variant distinction is unnecessary. Also cut the added driver-INF sentences in V2-ID-1/T3D-ID-1/T3D2X-ID-1 with their entire out-of-scope rows. This does not adjudicate whether a future necessary driver interface could be documented.

CH-3. REWRITE VP-ID-1 Rule: 'The Trio64V+ data book gives PCI device8811h, CR2E=11h, CR30=E1h, and CR2F with upper nibble4 and a revision-dependent lower nibble. A recorded Hercules Terminator64 card has revision54h; an upper-nibble4-only classification therefore does not cover that observed card. This observation identifies that card only; classification of other5xh codes is outside milestones1-4.' Source: 'V+ section13.3, CR2F, CR30; docs/765-rom.md On the cards (observed Hercules revision54h).' Strength: 'information (public definition and named card observation)'. Checked by: 'Chip identification observation; other revisions not established here.' Cut INF lists, quoted third-party PR material, blanket bit6 identification, and unknown41h/50h/51h classification. POST-6 must receive the same narrow rewrite or simply omit the unused later-chip detail. Rev54 observation was checked directly in allowlisted card record; V+CR2F primary page193 confirms4xh.

CH-4. REWRITE T64-MEM-2 'bit9 in CR5D bit6' to 'bit8 in CR5D bit6'. Append: 'The CR3B prose calls it bit9, but also specifies a9-bit value with eight low bits; the CR5D bit6 definition explicitly names CR3B bit8.' Source: T32/64 CR3B and CR5D (PDF192/207). B's bit8 form is correct. This corrects a public-source inconsistency, not a ROM-derived extension.

CH-5. REWRITE source/housekeeping: PLL-2 Source becomes 'T32/64 section9.1 and SR10-SR13' (directly verified); delete test_s3patch.py clause from Checked by. REG-3 Source becomes 'T32/64 section9.2 and SR15' (directly verified). Remove links to forbidden implementation files and dirty patch logs from introductory/Checked-by material; do not export any of those targets. Preserve observable test names where useful. Introductory Sources replacement: 'Each retained rule identifies its public data-book source or explicitly labeled project policy/necessary observation. The milestone copy contains only the rule IDs cleared in this record.'

CH-6. REWRITE the retained CR6B datasheet-gap note: 'The book conflicts about the location of the PD-width and stretch fields. Follow T64-MEM-6: do not program either disputed field until resolved for the target chip.' Delete the contradictory statement that tools assume sections6.2/7.1 are right. KEEP T64-MEM-6 itself as an explicit public-source conflict and non-write constraint. Keep the unrelated public PLL typographical corrections only where needed by retained rules.

CH-7. KEEP remaining retained public rule content, with chip scope trimmed as needed: T64-ID-1,T64-PCI-1,PLL-1,CLK-1,CLK-2,CLK-3,CLK-6,T64-PLL-1,T64-CLK-1,T64-CLK-2,T64-MEM-1,T64-MEM-3,T64-MEM-5,REG-1,T64-REG-1,T64-REG-2,T64-ENG-1. They name public hardware definitions/preconditions, not reference BIOS code. The bits/lock sequences are hardware requirements; no private vendor routine order crosses. T64-MEM-1's FIFO capacity/M/N primitives keep; they do not prove MODE136's complete latency claim.

CH-8. CUT/defer all other56 IDs and their containing non-scope prose: T64-ID-2,VP-SYS-1,UV-ID-1,AV-ID-1,V2-ID-1,T3D-ID-1,T3D2X-ID-1,V2-PCI-1,V2-PLL-1,V2-PLL-2,V2-PLL-3,V2-CLK-1,V2-CLK-2,CLK-4,CLK-5,VP-MEM-1,VP-MEM-2,VP-MEM-3,VP-MEM-4,VP-MEM-5,VP-MEM-6,MEM-2,T64-MEM-4,T64-MEM-8,T64-MEM-9,V2-MEM-1,V2-MEM-2,V2-MEM-3,V2-MEM-4,REG-2,T64-REG-3,ENG-1,V2-REG-1,V2-REG-2,V2-REG-3,V2-REG-4,V2-REG-5,V2-REG-6,V2-REG-7,T64-DDC-1,VP-DDC-1,UV-SYS-1,UV-SYS-2,UV-SYS-3,UV-SYS-4,UV-SYS-5,UV-SYS-6,UV-MEM-1,UV-REG-1,UV-REG-2,OEM-1,OEM-2,OEM-3,OEM-4,OEM-5,OEM-6. Cut whole OEM, Vision864 and Vision968 comparison sections, non-scope datasheet-error clauses, driver/source inventory entries not needed by retained rules. The four first-pass observation notes are settled by those cuts; their disappearance alone was not accepted as approval. If T64-MEM-8 is wanted later, its old FIFO formula and observations require a separate review, not inheritance from MODE136.

IDs cleared ONLY for the specified sanitized chip copy (24): T64-ID-1,VP-ID-1,T64-PCI-1,PLL-1,PLL-2,CLK-1,CLK-2,CLK-3,CLK-6,MEM-1,T64-PLL-1,T64-CLK-1,T64-CLK-2,T64-MEM-1,T64-MEM-2,T64-MEM-3,T64-MEM-5,T64-MEM-6,T64-MEM-7,REG-1,REG-3,T64-REG-1,T64-REG-2,T64-ENG-1. Exact edits/cuts above are conditions of that decision. No unreviewed text or ID crosses because it shares the file.

##### Counsel and limits

Counsel retains process sufficiency, public-document/asset license and release judgment, and any later proposal to transfer driver-derived identification material. This is an engineering leak review, not legal clearance. No fonts were inspected or cleared in this task. FIFO safety/card retention are engineering acceptance/source questions, not legal conclusions. No clean-side write, commit, PR, issue or external message was made.

##### Final evidence verification addendum

Viewed rendered primary images directly after text extraction: trio-page-64.png (FIFO example expressly before refill starts), dram-page-7.png (parameter52:512cycles,8ms), dmt-page-10.png (8pixel/8line borders and timing), trio-page-207.png (CR5D bit6 is CR3B bit8). No ambiguous Greek micro-unit is used by the refresh finding. POST41 power-on units are outside this B/chip judgment; reading its author extract was not verification of the200ms assertion.

A/B/C chip citation closure: the24-ID sanitized set includes every in-scope A chip dependency. T64-ID-2 is cut as unnecessary driver-derived identification; ENG-1 is cut as the later-chip exception (T64-ENG-1 is retained); V2-REG-6 in B MQ14 is later-chip comparison only and cut, without importing its three-HSYNC requirement into the Trio64. All other80 catalogue IDs are explicitly accounted for by24 retained and56 cut. Source text files remain unchanged.


#### Independent BIOS review

#### Independent second-pass leak review: docs/bios-rules.md

Date: 2026-11-07. Commit: b257fd66d1cef746fc15d61f5ac4c22da9911c37.
Reviewer: /root/leak_review_second_pass_20261107/bios_review, an eligible non-author child session.
Target SHA-256: 9c93e21c6e06eb2b9ed47a909005ac109d3a2e28943d3e027ac07a64c8ad03a3.
Scope: the complete 1,170-line bios-rules.md, including all 325 rule rows and all open-question/source-disagreement prose, for milestones 1-4.

Decision: **RETURNED**. No rule ID in this file is cleared to cross at this commit. This is a source/expression review, not an assertion that a missing exhibit proves copying. Exact rewrites below are proposed review decisions; no reviewed file or clean-side file was edited.

##### Eligibility and access

Before any project content I read the entire supplied C:\Users\kristoffer.sjothun\Downloads\leak-review-brief.md, using a 22,000-token output budget, as plain tool-output text. I confirmed that I had authored or edited no file under review and had read no forbidden material. I then read C:\Users\kristoffer.sjothun\.codex\AGENTS.md, the required process section, cleanroom README Leak review section, decisions-milestones-1-4.md and review-2026-11-02.md, and the allowlisted repository AGENTS.md. Eligibility remained intact throughout.

I did not open Phoenix source, riplin's disassembly or its prohibited section, any VGA BIOS implementation source, patcher/ROM source, src/tools/s3alias, emu/tests.py, BRIEF.md, asset-manifest.md, docs/seavgabios-trio64.md, fonts.py, font binaries, or milestone-calls.md/The run. No font bitmap table appears in bios-rules.md, so the conditional permission for fonts/README.md was not used. Links in the allowed documents were not treated as permission to follow them. I received no substantive adjudication from the disqualified root coordinator and did not consume the stopped lead's substantive review artifacts.

The only project files whose content I read were the prerequisites above; docs/bios-rules.md in full; specific relevant observations/search hits in oracle-a-post.md and oracle-b-modeset.md; the MODE-133 row in spec-b-modeset.md for an explicitly requested cross-file public-source check; and the public VGADOC VGABIOS.TXT, VGAREGS.TXT and EGAREGS.TXT passages specified below. I inspected the fresh eligible replacement lead's actual step6 log, which includes its independently generated C candidates as well as my two palettes. I did not adopt its C adjudications.

##### The six ordered checks

1. **Search:** independently ran the brief's name pattern, address pattern and leak-note search. Results: 9 name-hit lines, 197 address-hit lines, zero leak notes. Every hit was read in its full sentence during the full-file reading. The 197 address hits name public BDA fields, interrupt vectors, public field offsets, video-memory apertures/ranges and caller buffers. None prescribes a private C000 ROM offset. Exact inventories are step1-names.txt and step1-addresses.txt. An initial ripgrep command used grep's -E flag and failed; the corrected pattern was run and its 197 count independently reproduced by the saved inventory script.
2. **Sources:** inventoried all 325 rule rows: zero empty Source cells. Every row names a public reference or an explicitly identified project choice. A source name alone does not establish every appended claim: the exceptions below identify value support, overbroad success semantics and project-test-as-provenance problems. source-inventory.csv records every row and Source cell. Public sources inspected are listed below; I did not pretend that project tests prove IBM behavior.
3. **Values:** checked exact first-pass rows, public status conventions, public table layouts, palette formulas, cursor-emulation premises, and standard mode-state facts against allowed primary references. Compared relevant oracle A postconditions (lines 54-58) and oracle B VGA-return observations (87-101): their reference-specific pointers, return indices and extended registers are not imported into bios-rules. The oracle does not independently establish IBM defaults. Remaining exact-value provenance gaps are returned below. Other values are public API constants, public hardware fields, publicly described formats, explicit behavioral formulas, or labeled project contracts; no reference-only value was cleared merely because it matched.
4. **Expression:** public BDA/vector/table layouts are allowed standard interfaces. No vendor routine name, instruction sequence, sign-on string or private reference-ROM table layout is prescribed. B00-8's first sentence does impose an inadequately sourced operation order; rewrite below removes that order while retaining required observable end state. Open questions are explicitly nonrequirements, including the revised font/state question 17. Their answers still require future review. The opaque state-buffer rule and public class layouts are kept as distinct interface contracts, not a license to copy private packing.
5. **Observed behavior:** all nine name hits have decisions below. Public RBIL quirks may remain as warnings without vendor names; reference build levels and project-only test allowances do not belong in the clean copy. No reference-BIOS implementation is required by these decisions.
6. **Byte runs:** generated two concrete tables from B00-11: 192-byte EGA and 192-byte CGA DAC tables, i=00h..3Fh, RGB bytes in that order with no padding. The eligible replacement lead ran the actual emu/similarity.py FILE --min 16 command against each of all three default reference ROMs. Both commands exited 0; each reported 0 runs against each ROM. No font or standard-table exclusions were supplied. I read that actual output in replacement/step6-actual.log. This discharges the byte-run check for the materialized palette values; it does not discharge the source returns below.

##### First-pass returns, individually

| First-pass item | Second-pass decision and settled status |
| --- | --- |
| B00-5 | **RETURNED, still unsettled.** Ferraro 11.2.1 directly supports erasure when AL bit7 is clear, but does not give the exact 0720h text fill, 32KB extent, or all-plane graphics extent now attributed to VGATEST. The rewritten row names a publication instead of S3TEST, which improves provenance wording but does not provide an inspectable primary exhibit. Author question: supply the precise public article/test-data passage establishing each fill and extent (including mode07 and mode13), or split the rule into the sourced erasure requirement and explicit project choices/open questions. Do not use our tests or a reference-ROM match as the source. |
| B09-11 | **KEEP, settled.** The full register-preservation contract is explicitly project choice. The public references identify interface outputs; the row no longer asserts another BIOS's dispatcher structure. |
| B10-1 | **KEEP, settled.** Standard VGA supported subfunctions are separated from the project's unsupported-input no-op contract. Treat the list as this standard VGA scope, not a claim that no vendor extension exists anywhere. |
| B11-1 | **KEEP, settled.** Same separation of public standard font interfaces and explicit unsupported-input project choice. |
| B12-1 | **REWRITE, not correct as-is; settled only by the exact rewrite below.** Its first sentence falsely applies AL=12h to all supported BL values. Official RBIL BL10 returns BX/CX (and notes AH differences); BL20 returns no output. BL30-36 have AL=12h. Its unsupported no-op choice also needs to be labeled as the source of AL preservation, not inferred from the success indicator. |
| B1A-1 | **REWRITE, not correct as-is; settled only by the exact rewrite below.** Input AL=1Ah is within 02h-FFh and is unsupported. Being the success output for a different input does not remove it from unsupported inputs. The chosen no-op returns the same byte on that unsupported call; acknowledge the ambiguous success-looking value. |
| B1C-8 | **REWRITE, not correct as-is; settled only by the exact rewrite below.** The no-op policy is explicit, but input AL=1Ch also lies in the unsupported range and returns unchanged. A success indicator cannot prove support for that invalid input. No source guarantees a no-op solely from the success indicator. |
| TAB-9 | **REWRITE, mapping issue settled by the exact rewrite below; asset provenance/release remains for counsel.** The row correctly separates CP437 code mapping from glyph designs. Cut its links to the dirty src/roms/fonts directory and the unreviewed asset manifest from the clean copy. No bitmap was reviewed here; this is not clearance of a font export. |
| Fonts/state open question 17 (lines1076-1079) | **KEEP, settled.** It asks for documented buffer extent, public operations and externally visible changes, explicitly forbids assuming private fields/vector-swapping/calling behavior, and is under the nonrequirement/future-review preface. |

B00-22, which had an exact first-pass rewrite, is **KEEP**: it is now a project postcondition limited to fields initialized by the named public rules, with retained state expressly preserved. This pass independently examined that wording; the first-pass keep was not treated as clearance.

##### Exact rewrites and cuts

Apply these only to a future reviewed clean copy, not to this pinned evidence.

**W1, B12-1, Rule column:**

> The standard VGA functions BL=30h-36h return AL=12h when supported; BL=10h and BL=20h have the outputs specified by B12.10-1 through B12.10-4 and B12.20-1 through B12.20-3. Project design choice for a BL value this implementation does not support: leave every register and all BIOS data, video memory and video-register state unchanged. Consequently an unsupported call entered with AL=12h also returns AL=12h; callers must not use that value alone as proof of support for an invalid input.

Source column: `RBIL INT 10/AH=12h/BL=10h,20h,30h-36h; Ferraro 11.13.3-11.13.9; project design choice (unsupported no-op)`.

**W2, B1A-1, Rule column:**

> Supported inputs are AL=00h (query) and AL=01h (set); success returns AL=1Ah. Project design choice for unsupported inputs AL=02h-FFh: leave every register and all BIOS data, video memory and video-register state unchanged. This includes input AL=1Ah, so a returned AL=1Ah does not by itself prove support when the input was invalid.

Source: `RBIL INT 10/AX=1A00h and AX=1A01h; project design choice (unsupported no-op)`.

**W3, B1C-8, Rule column:**

> Supported inputs are AL=00h-02h; success returns AL=1Ch. Project design choice for unsupported inputs AL=03h-FFh: leave every register and all BIOS data, video memory and video-register state unchanged. This includes input AL=1Ch, so a returned AL=1Ch does not by itself prove support when the input was invalid.

Source: `RBIL INT 10/AH=1Ch; Ferraro 11.15.3; project design choice (unsupported no-op)`.

**W4, TAB-9, Rule column:**

> Character codes use the IBM PC CP437 mapping: code c selects glyph slot c. This specifies the code mapping only, not a glyph bitmap design. Font assets must come from the separately approved project asset package and its provenance record; this rule does not authorize copying any reference-BIOS glyph bytes.

Keep the existing public mapping/slot citations. The owner-selected Gil provenance can be identified in the separately reviewed asset handoff; the dirty directory and unreviewed manifest links are **CUT** here.

**W5, B00-8, Rule column:**

> When the call returns, the screen is on (SR01 bit5=0), the sequencer runs (SR00=03h), and the attribute controller permits normal display (PAS=1). CR11 bit7 is set in the standard-mode state; a program clears it before writing CR00-07. This rule specifies the observable final state, not an implementation-wide register-write order.

Source: public register definitions plus independently supplied standard mode defaults; retain the existing reference to Ferraro 10.6.1 for PAS. The removed sentence requires all registers to be written while both blanked and reset, but its cited source lists output values rather than proving that complete order constraint. If the author wants a stricter hardware-required sequence, provide the exact public hardware passage as a separate rule.

**W6, General rule in Conventions and its repeated copies:**

> Project design choice: a register not named as an output is returned as the caller gave it, except where a rule explicitly specifies otherwise. This preservation contract is not inferred solely from a public source listing no output.

Apply to B00-2, B0F-5, B06-9, B08-7, B0E-13, B0B-12 and B10-2 Source columns by appending `project design choice (register preservation)` where preservation exceeds the cited output list. Their behavioral contract can remain; do not label that inference as IBM or RBIL guarantees. B09-11 already does this correctly.

**W7, B1002-2:**

> RBIL advises callers to pass BH=00h to avoid problems on some adapters. The public entry does not establish behavior for other BH values.

Source remains RBIL AX=1002h. Cut `so a BIOS ignores BH`: it does not follow from the documented caller precaution.

**W8, B04-1:**

> The cited standard light-pen interface excludes VGA. Project design choice for AH=04h on this VGA implementation: return AH=00h (no light-pen trigger); preserve other registers under the general project rule.

Source: `RBIL INT 10/AH=04h (except VGA); Ferraro 11.4.1; project design choice`. Absence of a VGA light pen does not turn a nonapplicable function's output into a publicly specified VGA postcondition. This rewrite labels the existing benign output as policy rather than silently inventing a standards guarantee.

**W9, MODE-9:**

> The published VGA state example gives 2000h as mode13h's page-length field even though 320x200 one-byte pixels occupy 64000 bytes. A program must not size the visible mode13h buffer from 0040:004Ch.

Replace Source with `Ferraro Table9.15, mode13h (printed p314); MODE-4 and the one-byte pixel format`. This preserves the public value using an independently inspectable publication rather than the missing VGATEST exhibit. Table9.15 contains 2000h explicitly.

**W10, B1013-3:** keep its rule but replace Source with `Ferraro Table9.6, Attribute Controller Registers (printed p305): AR10 bit7 clear and AR14=00h in the listed standard modes`. The accessible primary table independently supports those fields.

**W11, B03-3:**

> Some BIOSes change AX during AH=03h, including returning AX=0000h. A caller must not depend on AX; the documented outputs are those of B03-1.

Source remains RBIL INT10/AH03 and VGADOC. Vendor naming adds no needed compatibility fact. For B00-3, **KEEP** the warning and publicly documented alternate AL values; remove the vendor-name quote from its Source cell and cite `RBIL INT10/AH00; VGADOC VGABIOS.TXT` directly.

**W12, source conventions/prose:** replace the introductory IBM source phrase that points at `s3compat/vgaref.inc` and project checks with:

> IBM behavior claims cite a named public publication and its precise passage or table. Project test encodings are checks only and are not provenance. Where the public exhibit is unavailable or insufficient, the claim remains returned or an open question.

The `s3compat/vgaref.inc` link is **CUT**. Likewise rewrite Sources disagree passages at lines525-526,533-534,538-542 and790-792 so the resolution names the actual public source or explicitly remains unresolved; a phrase such as `the behavior S3COMPAT encodes` or `B09-2 follows S3TEST` is not independent provenance. B09-2's within-page repetition is itself supported by Ferraro11.7.2; retain that rule and cite Ferraro, but not project test authority. B101B-2's 0.30/0.59/0.11 formula is directly supported by Ferraro11.11.7 equation11.1; retain its stated one-unit tolerance as the project's permitted numerical tolerance and remove the unsupported claim that project rounding proves IBM's exact arithmetic.

**CUT, project-only Checked by annotations:** remove explicit reference image/build identifiers and allowances from B05-3 (`against 2.04.07`), B06-9 (`against 2.04.07`), B1100-4 (the WARN/base-ROM missing-font suffix), B1121-3 (the WARN/base-ROM suffix), and B12.20-1 (`the 2.04.07 base does nothing`). Keep independently exportable test descriptions only; the existing test sources themselves are not cleared by this review. The mode-independent rule text in these rows is retained. This settles the corresponding step-one hits without changing standard contracts. The reference-ROM mention in the open-question source convention is **KEEP** as a process statement about dirty-side observations, not permission for clean access; no ROM path or source link is exported.

##### Remaining returns after these rewrites

**R1, B00-5: RETURNED**, exact fill/extent exhibit requested above.

**R2, exact VGATEST-dependent values/behaviors: RETURNED** for the portions listed here. The primary VGATEST publication/test-data material was not available in the allowlisted checkout and was not independently located from the named November1988 citation; I did not open the project's vgaref.inc or tests as a substitute. Ferraro is now independently available and supplies a possible public alternative for some fields, but it does not establish all the precise assertions below.

| IDs/portion | Question to author |
| --- | --- |
| B00-7, exact standard-mode parameter values; B00-18, exact mode-set cursor values; B01-4, exact 0607h -> 0Dh/0Eh emulation result | Supply the inspectable public default-register/cursor table or an explicit derivation for every prescribed state. Ferraro Table9.6 is an independently located candidate for default registers; cite the specific mode/row and reconcile differing 200/350/400-line examples rather than treating a project encoding as IBM evidence. |
| B00-10 and B00-11 | Supply primary support for the per-mode default-DAC selection and the entire CGA mapping, including unused/repeated entries. EGA weights have a public derivation (VGADOC EGAREGS primary/secondary RGB bits; Ferraro8.2.11 Table8.10; six-bit maximum63 gives42 and21), but the current Source column cites emulator helpers. Split the EGA derivation from any remaining CGA source gap, and name a primary source rather than the helpers. Ferraro8.3.5 Table8.14 provides a primary candidate for the 256-colour defaults, but its OCR must not be silently repaired from reference ROM bytes. |
| B06-8 | Supply the specific published AH06/07 CGA byte-fill contract. Ferraro11.6.1's attribute/blank-line description does not alone establish raw repeated BH bytes in every CGA graphics byte. |
| B09-6 | Supply the specific published graphics-character background-zeroing contract. Ferraro11.7.2 expressly describes foreground-only drawing and says writing a space in graphics has no effect; naming VGATEST without its relevant exhibit does not independently resolve that disagreement. |
| B0B-8 and its use in BDA-11/B1B state expectations | Supply the public default CRT_PALETTE values for modes0Dh-13h. Ferraro Table9.15 shows30h for those examples, while this rule prescribes3Fh. The document's own mode-set question11 already recognizes possible prior-mode contamination of IBM state observations. Resolve that uncertainty before exporting an unconditional must. |
| B1B-12's claim about IBM bit4 in captured state blocks | Supply the original published state observation and its setup, or cut the exact IBM assertion and leave the documented disagreement as an open question. RBIL/VGADOC define the flag; the claimed contrary captured default is not proved by a project check masking that bit. |

These returns are specific evidence gaps and, where identified, actual discrepancies between the claim and an inspected source. They are not a blanket rejection of the other publicly sourced fields in those rows.

**R3, B01-5: RETURNED.** The rule acknowledges garbled Ferraro Tables11.23/11.24 yet asserts exact scaling class boundaries and an unrestricted underline-to-bottom-lines behavior. The inspected OCR gives a full-block alternative involving End<Start and a height-dependent underline entry, which the rule does not fully state. Supply a legible public table/erratum or reduce the rule to the clearly documented high-level classes and leave exact boundaries open. Do not reconstruct missing inequalities from BIOS implementation or emulator test expectations.

**R4, B1C00-2: REWRITE** (a clarification, not a remaining source return):

> Let N be the number of 64-byte blocks returned in BX by AX=1C00h for state selection CX. A subsequent AX=1C01h with the same CX writes no more than 64*N bytes into the caller's buffer at the separately supplied ES:BX pointer.

The existing text reuses BX as both block count and buffer offset. This rewrite preserves the public interface and avoids an implementer treating the supplied buffer offset as the size.

##### Other material kept

Except for the specific findings above, **KEEP** the other rule contracts, open questions and source-disagreement notes as public-source interface facts, explicitly labeled project decisions, or nonrequirements awaiting future observation. This covers the public standard-mode geometry, video-memory mappings, BDA/vector addresses, cursor/page/pixel/string/palette/font function inputs and outputs, published parameter/save-pointer/font/static/state layouts, and formulas for geometry and grey summing. Numeric coincidences with a reference ROM do not invalidate these public definitions. This finding does not constitute individual-ID clearance while returns remain.

The standard state layouts B1C-3/B1C-5 and TAB-13/TAB-17 are **KEEP** under the public-format exception: official RBIL and VGADOC publish them. Their physical placement relative to one another remains opaque per B1C-6 and question24; no private offsets or headers may be inferred.

##### Table inventory

| Candidate | Extent and serialization | Result/disposition |
| --- | --- | --- |
| B00-11 EGA | bios-ega64.bin,192 bytes, i=0..63 and RGB for each i | all 3 ROMs zero runs >=16; no exclusion |
| B00-11 CGA | bios-cga64.bin,192 bytes, same order | all 3 ROMs zero runs >=16; no exclusion |
| TAB-13 parameter entry |64-byte public record layout, no full per-mode value table in file | layout kept; do not fill unspecified bytes for similarity as though they were supplied data |
| TAB-17 dynamic save area |256-byte runtime buffer,17 meaningful values and reserved remainder | layout only; no concrete table bytes supplied |
| B1B-1..14 |64-byte runtime state block with dynamic fields/pointers | no single concrete full record; per-mode facts are not a specified ROM encoding |
| B1C-3 |70-byte public hardware-state class with runtime register/latch values | layout only |
| B1C-5 |772-byte public DAC-state class with runtime palette | layout only; the distinct formula palettes were scanned above |
| B12.35-1/2 |128-byte caller buffer | intentionally opaque; no layout or byte values supplied |
| TAB-8/10/11 font formats |glyph/alternate layouts may exceed32 bytes when populated | no concrete glyph bytes in this file; no font source exception triggered |
| MODE/BDA/TAB rule tables and function lists |relational facts, sizes and field definitions | no prescribed byte record order; manufacturing a register/BDA/metadata concatenation would invent the very private representation the brief forbids |

Palette hashes are in palette-inventory.json. Source inventory includes all 325 rule IDs, including the document's literal B0Dh-1 and B101Bh-1 spellings.

##### Public source evidence and access limitations

- Pinned `standards/thoegersen/VGABIOS.TXT`: standard modes; font subfunctions; AH12 BL10/20/30-36; AH1A; AH1B fields; AH1C hardware/DAC layouts. Materialized from the pinned git object solely in this review directory.
- Pinned `standards/thoegersen/VGAREGS.TXT`: attribute control/PAS, sequencer and graphics bits. Its SR04 bit2 prose is not a reliable basis for silently deciding odd/even polarity; no such correction was inferred from a reference ROM.
- Pinned `standards/thoegersen/EGAREGS.TXT`, opening palette definitions: primary RGB bits0-2 and secondary bits3-5.
- Official Ralf Brown release61: https://www.cs.cmu.edu/~ralf/files.html and https://www.cs.cmu.edu/~ralf/interrupt-list/inter61a.zip . Extracted only INTERRUP.A. Relevant source line ranges in the locally retained text:2133-2147 (AH04 exclusion);2538-2551 (BH caller precaution);3091-3107 (BL10);3161-3265 (BL20,30-36);3913-3949 (1A);4105-4161 (1C and public formats). No source code implementation was opened.
- Ferraro3rd-edition1994 primary scan/OCR, located through PCjs's public book list: https://archive.org/details/programmers-guide-to-the-ega-vga-and-super-vga-cards-1994 . Retained only the 2.84MB OCR, not the 545MB PDF. Read the cited API prose and tables:11.2.1 erasure;11.6.1 scrolling;11.7.2 drawing;11.11.7 grey formula;11.13.7 cursor classes;11.15.3 state;8.2.11/8.2.13 and8.3.5 palette definitions;9.6 default registers and9.15 state. The small formula demonstration at Listing11.1 is public explanatory arithmetic, not VGA BIOS implementation source; no BIOS implementation listing was read. Some table OCR is garbled, which is explicitly treated as a limitation above.
- Attempts to locate the named VGATEST November1988 material found the public magazine catalog (https://www.pcjs.org/documents/magazines/pctj/) and its issue link but did not obtain the relevant primary article/data. No unrelated VGATEST program/source was used. Do not characterize this as proof that the publication lacks the data.
- Relevant oracle observations were comparisons only. They were not promoted to public-source provenance and are not part of any clean export.

##### Counsel and handoff

Counsel retains process adequacy/AI prior-exposure risk, release/distribution judgments, and independent approval of font origin, notice and redistribution terms. This review clears only the CP437 mapping concept after W4; it does not approve Gil files, a font generator, bitmap identity with IBM/S3, or the unreviewed asset manifest. No legal conclusion is drawn from a zero-run similarity result.

**IDs cleared to cross: none.** All first-pass returns are accounted for individually above. B00-5 remains returned; W1-W4 resolve wording defects only after application and fresh review; R2/R3 still require author evidence or narrower replacement requirements. The complete record, inventories and scan candidates stay on the dirty side. No external message, issue, PR or clean-side write was made.

## Fonts (closed 5 November 2026)

The similarity check shows SeaVGABIOS's 8x8, 8x14 and 8x16 fonts byte for byte equal to S3's and
Phoenix's fonts over runs of up to 3.6 KB: all of them carry the IBM VGA font.

Since 2 November 2026 (#141) our patched ROMs build all five font tables from Joseph Gil's FNTCOL16
files in [`src/roms/fonts/`](../../src/roms/fonts/). That folder holds the unmodified files and Gil's
notice: the individual fonts public domain, and the US Copyright Office position that bitmap fonts
are not registrable (57 FR 6201). The tables include the 9-dot alternates, built by
[`fonts.py`](../../src/roms/fonts/fonts.py) from PP_ROMAN.F16 and STANDARD.F14.

Owner decision of 5 November 2026 ([#145](https://github.com/perchrh/trio64-vbios-tools/issues/145)):
that Gil source plus the generated tables is the **closed** font package for the clean ROM
([`asset-manifest.md`](asset-manifest.md)). FreeDOS cpidos is not kept as an alternative. The glyphs
still match IBM / historical S3 tables; the project relies on Gil's notice for a permissive release.
The similarity check excludes font ranges given with `--fonts`, but that says nothing about their
provenance.
