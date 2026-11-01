# The clean-room package

What the clean side gets for writing the S3 Trio64 module of SeaVGABIOS (the plan:
`docs/seavgabios-trio64.md`), what stays on the dirty side, and how the result is checked. The process
and its reasons are in `docs/clean-room.md`. Prepared 1 November 2026; the leak review of the
specification files is still to be done.

## Files here

| File | Side | What it is |
| --- | --- | --- |
| `BRIEF.md` | dirty | the rules the specification was written under |
| `spec-a-post.md` | goes across after the leak review | POST start-up, the conventions drivers rely on, the PCI ROM header (plan items 1, 4, 6) |
| `spec-b-modeset.md` | goes across after the leak review | the S3 mode set: DMT timings, clocks, colour modes, display FIFO, return to VGA (item 2) |
| `spec-c-vbe.md` | goes across after the leak review | VBE 1.2 (4F00-4F08), the S3 mode numbers and 4F14h (items 3, 5) |
| `oracle-a-post.md`, `oracle-b-modeset.md`, `oracle-c-vbe.md` | dirty only | what the reference ROMs do in the emulator and on the card, compared with the specification; the expected values for checking the clean ROM, never handed over |

## What goes to the clean side

- The three specification files above, after the leak review.
- The public documents: the S3 Trio32/Trio64 data book (`datasheets/`), VBE 2.0 (`standards/vesa/`),
  the VBE 1.2 text, VGADOC (`standards/thoegersen/`), and the other public sources of
  `docs/clean-room.md` "Public documents for the clean side".
- `docs/chip-rules.md`: rules from the data books only, except its section "S3 OEM functions (4F14h)",
  which is taken from BIOS images and goes only through `spec-c-vbe.md`.
- `docs/bios-rules.md`, after a leak review of its open questions: its rules rest on public sources, but
  its open-question lists were written while reading another vendor's BIOS source.
- SeaVGABIOS (branch `claude/slim-vgabios` of perchrh/seabios_fork), under its LGPLv3.
- The test tools as programs and their result lines (S3TEST, S3COMPAT, VSHOW, VGALOG, S3REGS): what
  they check is stated in their headers from public sources.

## What stays on the dirty side

The reference ROMs (`reference/`), the patched ROMs and their code (`rompatch/`), the oracle files,
riplin's disassembly, `docs/trio64-backport.md`, the README sections on byte-level changes, the
emulator tests that compare with a reference ROM (`make ref-compare`, `tref-compare`, the `T64_BASE`
notes), and anything from another vendor's BIOS source.

## Checking the clean ROM (on the dirty side)

1. **Emulator**: `make emu-test ROM=CLEAN.BIN CHIP=trio64` with 2, 4 and 1 MB. The tests tagged `patch`
   are skipped for a ROM that is not ours; S3TEST runs its set for other BIOSes on a Trio64 (chip,
   MCLK, memory, VGA and VESA mode lines, clears, scrolls, timings), S3COMPAT and VSHOW run in full.
2. **The oracle**: the register state after POST and after each mode set compared with
   `oracle-a-post.md` and `oracle-b-modeset.md`, the 4F00/4F01 blocks with `oracle-c-vbe.md`. Where the
   oracle notes a reference value that the specification deliberately does not follow (non-DMT
   timings, the FIFO M), the specification wins.
3. **Similarity**: `python3 emu/similarity.py CLEAN.BIN --fonts S-E ... --tables S-E ...` lists
   every byte run of 32 or more that the clean ROM shares with Phoenix 1.5-07, S3 1.03-08 and S3
   2.04.07, apart from the font tables and the tables a public standard defines (give their offsets,
   from `nm out/vgarom.o`). Exit code 1 when any other run is found; each one is investigated.
   The slim SeaVGABIOS of 1 November 2026 passes with its three fonts (`vgafont8`, `vgafont14`,
   `vgafont16`) and the IBM video parameter and save pointer tables given:

       python3 emu/similarity.py slim.bin --fonts 409E-509D --fonts 509E-5E9D --fonts 5E9E-669D --tables 38B8-4053

4. **On the card**: `docs/seavgabios-trio64.md` "Clean-room steps", step 4.

## Font origin (to settle before distribution)

The similarity check shows SeaVGABIOS's 8x8, 8x14 and 8x16 fonts byte for byte equal to S3's and
Phoenix's fonts over runs of up to 3.6 KB: all of them carry the IBM VGA font. SeaVGABIOS calls its
fonts public domain (from Joseph Gil's FNTCOL16 collection, `docs/clean-room.md`). Whether the IBM glyphs
are free to distribute is a question for the lawyer of `docs/clean-room.md`; the FreeDOS cpidos fonts
(GPL 2 or later) are the alternative that the plan already names.
