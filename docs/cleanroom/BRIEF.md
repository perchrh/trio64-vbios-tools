# Brief: the clean-room specification of a Trio64 video BIOS (dirty side)

You write one part of the behaviour specification that a separate "clean side" will implement a
Trio64 (S3 86C764X) video BIOS from. The clean ROM is written from scratch, with no base code (decided
2 November 2026, [#145](https://github.com/perchrh/trio64-vbios-tools/issues/145); [docs/clean-room.md](../clean-room.md) "Decisions of 2 November 2026"):
specify the whole behaviour, the standard VGA functions included. SeaVGABIOS (LGPLv3, branch
claude/slim-vgabios of /home/user/seabios_fork) is a comparison implementation only: its vgasrc/ may
be read for facts, never as a base. Read first, in /home/user/trio64-vbios-tools: [AGENTS.md](../../AGENTS.md), [docs/clean-room.md](../clean-room.md),
(its section "The parts of the clean ROM": your part is one of items 1-6), [docs/chip-rules.md](../chip-rules.md) (data
book rules with IDs), [docs/bios-rules.md](../bios-rules.md) (standard function rules, the format to follow).

## Rules (hard)

- You are on the dirty side, but what you write goes to the clean side after a leak review. Write
  BEHAVIOUR: registers, values, ranges, formulas, order constraints, inputs and outputs, error cases.
  Never instruction sequences, routine structure, or code from any BIOS.
- Each value must rest on a public source: the S3 Trio32/Trio64 data book (datasheets/, cite "T32/64"
  with section/table, or the rule ID of [docs/chip-rules.md](../chip-rules.md)), VESA (VBE 1.2/2.0 in standards/vesa and
  README "VESA standards"; DMT timings as published industry figures), IBM/VGA references
  ([docs/bios-rules.md](../bios-rules.md) sources), VGADOC (standards/thoegersen). Cite it in a Source column.
- Black-box observation is allowed for checking: run the reference ROM (reference/trio64/1_5_07.bin,
  Phoenix, and our patched build) in the emulator (emu/vgaemu.py, Machine.chip = 'trio64', python at
  /home/user/trio64-vbios-tools/.venv/bin/python3; m = Machine(rom64k); m.post(); m.int10(ax, bx=..);
  registers in m.r['crtc'], m.r['seq'], m.r['gc'], m.r['atc'], m.r['misc'], memory m.mem(addr, n)),
  and the card logs in README and [docs/764-rom.md](../764-rom.md) (S3REGS dumps). But do NOT copy the
  reference ROM's per-mode register bytes or tables into the specification: derive values from the
  standards and the data book, and put the observed reference values only into your part's ORACLE
  file (it stays on the dirty side and is used to check the clean ROM), saying where they agree or
  differ from your derived values and why.
- Never read or use the Phoenix VGA BIOS source material (an SRC/phx folder or similar, if you find
  one): not even to look things up. Do not read riplin's disassembly either.
- Where the public sources do not settle a behaviour, write it as an open question (numbered) rather
  than taking it from the reference ROM.
- ASCII only (no long dashes, no emoji, no accented letters). Tables like [docs/bios-rules.md](../bios-rules.md):
  | ID | Rule | Source | Strength | Checked by | with IDs per part (given in your assignment).
- Checked by: name an existing test (S3TEST line, S3COMPAT line, emu test in emu/tests.py) or
  "not checked" plus what test would check it.

## Output

Write your part to the file named in your assignment (in /home/user/trio64-vbios-tools/docs/cleanroom/),
and the oracle to the ORACLE file named there. Do not commit, do not touch other files; the session
that started you integrates and commits. Return: rule count, open questions, and anything you could
not settle.
