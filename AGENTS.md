# AGENTS.md

Guidance for anyone, human or AI agent, changing this repository. Read README.md first: it describes
the tools, the VBIOS changes they verify and where the reference data comes from.

## Project context

- Hardware: Gainward S3 Trio64V2/DX (86C775), 2 MB EDO 40 ns, board ICUVGA-GW503A, PCI 5333:8901.
- The ROM is a 64 KB image. The lower 32 KB is the S3 reference BIOS 2.04.07 with our patches
  (currently -p21); the upper 32 KB is zeros (from p15; up to p14 it was the card's Trio64V+ BIOS
  1.03-08). p1-p13 were developed on the card's stock 2.04.11; only the reference is patched now.
- The patched ROM images are kept outside this repository. `rompatch/` holds the ROM code (nasm) and
  `s3patch.py`, which builds the current level from the S3 reference 2.04.07 alone
  with byte assertions; only the latest level is built. A new level replaces the pinned SHA-256
  (`RESULT_SHA`) once the emulator tests pass, and `make rom-test` checks it. Update `BLOCK_SHA` in
  `s3patch.py` together with `RESULT_SHA`: the first 16 hex digits of the SHA-256 of every assembled
  block of that same NASM 3.02 build (all files in `BLOCKS`, also new ones); s3patch uses them to name
  the blocks another assembler encoded differently, so a stale entry points at the wrong block. The
  repository also holds the Trio64V+ backport (`rompatch/vplus/`: `s3vpatch.py` builds 1.03-08-pN
  from the S3 Trio64V+ BIOS 1.03-08 in `reference/vplus/`, with the same rules: byte assertions, a
  pinned `RESULT_SHA` and `BLOCK_SHA`, `LEVEL` for its sign-on; docs/vplus-backport.md) and the Trio64 ROM
  (`rompatch/trio64/`: `s3tpatch.py` builds 1.5-07-pN from the Phoenix S3 Trio64 BIOS 1.5-07 in
  `reference/trio64/`, the same rules, `TROMVER`; docs/trio64-backport.md), the DOS test tools (VSHOW, S3TEST, S3COMPAT, VGALOG, S3REGS, S3REGS32 for the Windows 9x desktop),
  the TSR S3ALIAS and their documentation.
- Test machine: plain DOS on a 386 or later. Monitors: an Eizo LCD (native 1600x1200) and a multiQ
  LCD (native 800x600, does not support 1280x1024 at all). "Out of range" on the multiQ in
  1280x1024 modes is the monitor, not the BIOS.

## Hard rules for the ROM

- Stay compatible with the standard VGA modes (00h-13h) and the VESA modes. Never change what a
  standard mode returns to a program; use standard VESA/VGA timings; keep 70 Hz for 320x200 and
  640x400 text/graphics.
- The RAM must stay treated as 1-cycle EDO (CR36 bits 3-2 = 00): the ROM never writes those bits, the
  card's strapping decides. The default build's MCLK is 59.96 MHz, the 1-cycle EDO maximum; do not
  raise it. Other clocks come only from the build option (`MCLK=`, `MEMTYPE=`), which sets one entry of
  the BIOS's MCLK table within the data book limit for that memory type (README "MCLK build option").
- Blank pedestal off (SR1A bit 5 = 0): the deepest black is wanted.
- Every ROM version carries a -pN suffix in the sign-on string and a correct checksum in the lower
  32 KB; the upper 32 KB is zeros.
- Base every change on the reference image plus explicit patches with byte assertions, so a build
  fails when the bytes under a patch are not what the patch expects. Addresses go into
  `rompatch/bios.inc` (the patcher reads it too), patch sites and their original bytes into
  `s3patch.py`.
- Rejected on this card, do not retry without new evidence: SR15 bit 7 (data errors) and CR87 bit 1
  (hang), see README "Omitted".
- Fixes that change what a standard function returns, or need more ROM space than is free, stay as
  TSRs (S3ALIAS).
- The 8x14 font is missing in the BIOS and that is accepted for now.

## Test tools

- Test the VBIOS, not the hardware. Use the datasheet to judge what the BIOS programmed (clock limits,
  colour modes, memory mapping rules), not to characterise the chip.
- Every test prints one result line: PASS, FAIL with a bit mask, WARN with a bit mask, or INFO.
  Known stock behaviour that is acceptable is a WARN, never a FAIL. A FAIL must mean the BIOS is wrong.
- Expected values come from an independent reference: IBM tables (VGATEST), the VBE 2.0
  specification, VESA DMT, the datasheet, or a formula (EGA/CGA palettes, grey summing, 4F06
  maximum). Do not take expected values from the ROM under test unless the source is cross-checked,
  as the VGA parameter table is against VGATEST.
- The ROM under test is built from the S3 2.04.07 reference BIOS; its data is not used as expected
  values in the tests.
- The tools run on the whole Trio64 family (Trio32, Trio64, Trio64V+, Trio64V2) and on its stock
  BIOSes. Chip limits (VCO range, DCLK maxima, R bits) come from `common/chip.inc`, after the chip is
  found; never write the Trio64V2 values into a test. A check whose expectation is a choice of our
  BIOS rather than a standard (default refresh rates, the mode list, the S3 mode numbers, VBE 2.0
  functions on a VBE 1.x BIOS) is WARN or INFO on another BIOS. S3TEST picks its test set by the chip
  (Trio64V2: our 2.04.07 ROM; Trio64V+: our 1.03-08 ROM; Trio64: our Phoenix 1.5-07 ROM; others: only
  the tests that need no ROM of ours). The emulator tests tagged `patch` are skipped for a ROM without
  the `2.04.07-pN` sign-on, except those also tagged `vplus` on our Trio64V+ ROM and `t64` on our Trio64
  ROM; `--chip` selects the chip model.
- Runs are non-interactive (to look at a mode, use VSHOW). Output must be redirectable to a
  file; anything meant for the person at the screen goes to stderr.
- Write and commit the log (INT 21h AH=40h, then AH=68h) before each test starts, so that after a
  freeze the last line in the log names the test that hung.
- Start from a known state and leave one: set mode 03, take a baseline, zero VRAM without destroying
  the DOS screen, and restore the screen and the PIT at the end.
- Exit code 0 when nothing failed, 1 otherwise.
- VSHOW, S3TEST and S3COMPAT take /V: a debug log in <TOOL>.DBG (common/vdebug.inc). New code paths
  should log what is needed to diagnose them from a hardware run (raw values, not verdicts), with
  `D:` records in the documented format. /V must not change the normal output, and nothing may be
  logged inside timed loops (set `vquiet` around timed code that calls INT 10h).
- All tools share one version number (1.0 now), `VERSION` in `common/version.inc`; never write the
  number into a tool's strings, use `VERSION` (and `ROMVER` for the ROM S3TEST expects). Each tool prints its version on its first line of
  output and in its error messages. Bump them all together, and only when asked.

## Assembly conventions

- NASM 3.02 (the project's assembler; the pinned ROM SHA-256 is of a 3.02 build), `-f bin`, 16-bit .COM files (`bits 16`, `org 0x100`), `cpu 386` where 32-bit registers are
  used. No other build dependencies: tables are `db` data in the source or in an `.inc` file.
- Use local labels (`.name`) inside routines; NASM reports clashes as "inconsistently redefined".
  Avoid names that NASM treats as reserved or instructions (`r13`, `wait`, `bpl` and similar).
- Say in the routine comment what goes in and out (registers, flags) and which registers are kept.
  Preserve the registers callers rely on; several bugs came from helpers clobbering AH, BX or DI.
- Read port values in the size the hardware defines (`movzx` for byte fields, not `[dword]` reads of
  byte variables).
- VGA specifics that bite: the attribute controller flip-flop (read 3DAh before using 3C0h); AR00-0F
  are only readable with the palette address source bit clear; S3 registers need the unlock
  (SR08 = 06h, CR38 = 48h, CR39 = A5h); restore PIT channel 0 to mode 3 when the program reprograms it.
- Real mode only: reach the LFB with INT 15h AH=87h, not with protected mode or unreal mode tricks.

## Documentation

- Documentation is part of the change, not an afterthought. Each source file starts with a header
  block: purpose, usage, every test and the outcome expected on the current ROM. Each test routine has
  a comment block listing its fail and warn bits and what each one means.
- When a test or an expectation changes, update the header, the routine block, the bit legend printed
  in the log and README.md in the same change.
- Record why a choice was made (for example why a fix is a WARN, why a timing was kept) next to the
  code or in README.md, with the source.
- Generated documents and README text: no long dashes, no emoji, no accented letters such as e-acute.

## Verifying a change

- Build with `make`. A comment-only or documentation change must leave every .COM file byte-identical:
  build before and after and compare with `cmp`.
- A functional change is verified on the real card: S3TEST and S3COMPAT logs from the test machine are
  the final word. Compare with the previous log: the pass, fail and warn counts and every changed line
  should be explained.
- The tests are for the newest ROM: a new level changes `LEVEL` in rompatch/s3patch.py and `ROMVER` in
  common/version.inc together (for the Trio64V+ ROM `LEVEL` in rompatch/vplus/s3vpatch.py and
  `VROMVER`, for the Trio64 ROM `LEVEL` in rompatch/trio64/s3tpatch.py and `TROMVER`); the emulator test `version` fails when they differ or when the ROM under test is older.
- Memory configurations: the ROM supports 2 MB (the test card) and 4 MB (the 86C775 maximum, CR36
  bits 7-5 = 000b) of video memory; the Trio64V+ and Trio64 ROMs also 1 MB. The BIOS sizes the memory at every
  POST, so there is no build option for it. `make emu-test ROM=...` runs every test with 2 MB and the
  ones tagged `vram` (their result depends on the memory size) again with 4 MB, and with `CHIP=vplus`
  or `CHIP=trio64` also with 1 MB; a new test that reads the memory size or the VESA mode list gets the tag. Expected
  values follow the memory size, never a fixed 2 MB.
- Test coverage goal: at least 80 % of the ROM's code is executed by the tests (`make coverage ROM=...`:
  every emulator test with coverage recording, then `emu/codemap.py`, which finds the code by recursive
  descent and does not count data, padding or code nothing reaches). A new patch or a new BIOS
  function path comes with a test that runs it; `--list` shows the code no test reaches.
- EGA/CGA goal: in the CGA, MDA and EGA modes (00h-07h, 0Dh-10h) the ROM behaves exactly like the
  unpatched reference BIOS 2.04.07: same registers back, BIOS data, video memory, DAC and standard VGA
  registers after every call (`make ref-compare REF=... ROM=...`, emu/refcompare.py). Our
  changes there are speed only (32-bit stores) or VGA/S3 extended registers; a change that makes a
  difference in those modes needs a reason in README.md.
- Emulation is a useful extra check before hardware runs: `emu/` runs the ROM's POST and INT 10h, and
  the DOS tools on top of it, under Unicorn with a VGA register model (`make emu-test ROM=...`). It
  models registers, a planar window and a virtual clock (refresh rates there follow the programmed
  timing), but has no banked or linear video memory and no real bus speed, so keep those results
  apart from real findings; the hardware logs decide. Add a test to
  `emu/tests.py` for new behaviour the model can judge.
- Deliver changes as a pull request against main.
