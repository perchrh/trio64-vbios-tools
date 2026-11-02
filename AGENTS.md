# AGENTS.md

Guidance for anyone, human or AI agent, changing this repository. Read README.md first: it describes
the tools, the VBIOS changes they verify and where the reference data comes from.

## Project context

- Hardware: Gainward S3 Trio64V2/DX (86C775), 2 MB EDO 40 ns, board ICUVGA-GW503A, PCI 5333:8901.
- The ROM is a 64 KB image. The lower 32 KB is the S3 reference BIOS 2.04.07 with our patches
  (currently -p23); the upper 32 KB is a copy of it (#78; p15 to p21 were built with zeros there, up to
  p14 it was the card's Trio64V+ BIOS 1.03-08). p1-p13 were developed on the card's stock 2.04.11; only the reference is patched now.
- The patched ROM images are kept outside this repository. `rompatch/` holds the ROM code (nasm) and
  `s3patch.py`, which builds the current level from the S3 reference 2.04.07 alone
  with byte assertions; only the latest level is built. A new level replaces the pinned SHA-256
  (`RESULT_SHA`) once the emulator tests pass, and `make 775-rom-test` checks it. Update `BLOCK_SHA` in
  `s3patch.py` together with `RESULT_SHA`: the first 16 hex digits of the SHA-256 of every assembled
  block of that same NASM 3.02 build (all files in `BLOCKS`, also new ones); s3patch uses them to name
  the blocks another assembler encoded differently, so a stale entry points at the wrong block. The
  repository also holds the Trio64V+ backport (`rompatch/vplus/`: `s3vpatch.py` builds 1.03-08N-pN
  from the S3 Trio64V+ BIOS 1.03-08N in `reference/64vplus/`, with the same rules: byte assertions, a
  pinned `RESULT_SHA` and `BLOCK_SHA`, the level from `VER765`; docs/765-rom.md) and the Trio64 ROM
  (`rompatch/trio64/`: `s3tpatch.py` builds 1.5-07-pN from the Phoenix S3 Trio64 BIOS 1.5-07 in
  `reference/trio64/`, the same rules, `VER764`; docs/764-rom.md), the DOS test tools (VSHOW, S3TEST, S3COMPAT, VGALOG, S3REGS, S3REGS32 for the Windows 9x desktop),
  the TSR S3ALIAS and their documentation.
- Test machine: plain DOS on a 386 or later. Monitors: an Eizo LCD (native 1600x1200) and a Dell
  2021FP (EDID over DDC2: Windows 98 identifies it with p21). The multiQ LCD (MQ215 B-1, native
  800x600, no 1280x1024 at all) shows no picture on any card or machine since 31 October 2026: a
  monitor fault, not the BIOS.

## Hard rules for the ROM

- Stay compatible with the standard VGA modes (00h-13h) and the VESA modes. Never change what a
  standard mode returns to a program; use standard VESA/VGA timings; keep 70 Hz for 320x200 and
  640x400 text/graphics.
- The RAM must stay treated as 1-cycle EDO (CR36 bits 3-2 = 00): the ROM never writes those bits, the
  card's strapping decides. The default build's MCLK is 59.96 MHz, the 1-cycle EDO maximum; do not
  raise it. Other clocks come only from the build option (`MCLK=`, `MEMTYPE=`), which sets one entry of
  the BIOS's MCLK table within the data book limit for that memory type (README "MCLK build option").
  The Trio64 ROM's option takes up to 70 MHz, above the data book's 60 MHz: the 86C764X's rated
  clock (vgamuseum), which DSP-3364P boards run (their own BIOS: 69.8 MHz; at 54.9 MHz windowed video
  streaks there, #75). Our Trio64 ROM is for the 86C764X (Trio64 PnP); the earlier 86C764 (86C764-P,
  also VL-Bus) likely accepts only 60 MHz (not verified), so builds for it stay at the default or `MCLK=60`. For the Trio64 our tools take 70 MHz as the
  chip's limit (chip.inc, T64-MEM-7):
  S3TEST's and S3COMPAT's MCLK lines and the patcher accept up to 70 MHz without a warning. Above 70 MHz, at most 100 MHz (twice 50 MHz), only as an overclock on request
  (`MCLK=... OVERCLOCK=1`, s3tpatch.py `--overclock`): the card owner's choice, never a default.
- Blank pedestal off (SR1A bit 5 = 0): the deepest black is wanted.
- Every ROM version carries a -pN suffix in the sign-on string and a correct checksum in the lower
  32 KB. The 64 KB images of all three ROMs carry the 32 KB twice, because a board may map either half
  of its EEPROM (the DSP-3364P maps the upper one, #78; the Trio64V2 card the lower one).
- Base every change on the reference image plus explicit patches with byte assertions, so a build
  fails when the bytes under a patch are not what the patch expects. Addresses go into
  `rompatch/bios.inc` (the patcher reads it too), patch sites and their original bytes into
  `s3patch.py`.
- Rejected on this card, do not retry without new evidence: SR15 bit 7 (data errors) and CR87 bit 1
  (hang), see docs/775-rom.md "Omitted".
- Fixes that change what a standard function returns, or need more ROM space than is free, stay as
  TSRs (S3ALIAS).
- The 8x14 font is missing in the BIOS and that is accepted for now. The Trio64 ROM keeps its 8x14
  font and 9x14 alternate table (S3's since 30 October 2026), to preserve the style of the era: do not
  delete them for space. It also keeps DDC1 in VBE 4F15 (only VDIF was deleted).
- A BIOS call of our ROMs leaves the index registers it touches as it found them, at least the
  sequencer index 3C4h, as S3's 2.04.07 and 1.03-08 do (S3TEST's 4F05 line checks it, fail bit 2).
  The data books do not require it; programs that set an index before an INT 10h call rely on it.
- Zero bytes are free space only when shown unused: the 00h that ends the Phoenix 9x16 alternate font
  table (7F51h) and the empty VGA parameter table slot at 3CE9h are zeros in use. Check new space with
  the annotated disassembly (below) or a broad INT 10h workload in the emulator, and give the patcher
  a check that the space is still zero in its input.
- Trio64 ROM (Phoenix 1.5-07): CR41 and CR52 bits 7-4 hold Phoenix's refresh indexes, CR6B/CR6C the
  PCI base (copied into CR59/CR5A at every mode set), CR6D is no Trio64 register; our mark is CR52
  bit 3, which Phoenix masks off. Do not keep marks in CR6B-CR6D: CR6B bit 7 and bits 1-0 have
  hardware meanings in the Trio64 data book (T64-MEM-6). Phoenix's mode sets relock SR08 but leave CR38/CR39
  unlocked (emulator, 1 November 2026), and its unlock changes AX: new code unlocks itself and leaves the lock as found.
- riplin's annotated disassembly of the Phoenix 1.5-07 EDO build (README "Sources") is a map of our
  Trio64 base: its offsets hold from 1000h to 7EFFh in every 1.5-07 build (the first 4 KB differ by
  card maker). Use it to find routines, callers and data; copy no code, tables or ROM bytes from it
  (MIT covers riplin's annotations, not the Phoenix/S3 bytes), and keep the byte assertions in
  `s3tpatch.py` as the check.

## Test tools

- Test the VBIOS, not the hardware. Use the datasheet to judge what the BIOS programmed (clock limits,
  colour modes, memory mapping rules), not to characterise the chip.
- Every test prints one result line: PASS, FAIL with a bit mask, WARN with a bit mask, or INFO. A test
  or step left out because of the chip, its ROM, the memory size or an option prints a SKIP line
  instead ("<category> <name> ...  SKIP: <reason>"), which is not a result and not counted by
  category; the summary line counts the SKIP lines. Never leave something out silently.
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
  the `2.04.07-pN` sign-on, except those also tagged `765` on our Trio64V+ ROM and `764` on our Trio64
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
- All tools share one version number (1.0.0 now), `VERSION` in `common/version.inc`; never write the
  number into a tool's strings, use `VERSION` (and `VER775` for the ROM S3TEST expects). Each tool prints its version on its first line of
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
- In Markdown files, a reference to another Markdown file is a relative link
  (`[docs/764-rom.md](docs/764-rom.md)`, from docs/ `[764-rom.md](764-rom.md)`), and so is a reference to a
  directory or source file in the repository (`[rompatch/trio64](rompatch/trio64/)`). Plain text is
  kept only in code blocks, headings and for reference ROM images.

## Verifying a change

- Build with `make`. A comment-only or documentation change must leave every .COM file byte-identical:
  build before and after and compare with `cmp`.
- A functional change is verified on the real card: S3TEST and S3COMPAT logs from the test machine are
  the final word. Compare with the previous log: the pass, fail and warn counts and every changed line
  should be explained.
- The tests are for the newest ROM: a ROM level is kept only in common/version.inc (`VER775` for the
  Trio64V2 ROM, `VER765` for the Trio64V+ ROM, `VER764` for the Trio64 ROM). The patchers read their
  `LEVEL` from it for the sign-on, and S3TEST is built with it, so a new level changes that one line;
  the emulator test `version` fails when the ROM under test is older.
- Memory configurations: the ROM supports 2 MB (the test card) and 4 MB (the 86C775 maximum, CR36
  bits 7-5 = 000b) of video memory; the Trio64V+ and Trio64 ROMs also 1 MB. On the Trio64, 4 MB is
  fast page memory only and EDO stops at 2 MB (T64-MEM-3); the Trio32 takes at most 2 MB (T64-MEM-5). The BIOS sizes the memory at every
  POST, so there is no build option for it. `make emu-test ROM=...` runs every test with 2 MB and the
  ones tagged `vram` (their result depends on the memory size) again with 4 MB, and with `CHIP=765`,
  `CHIP=764` or `CHIP=732` also with 1 MB (the Trio32 never with 4 MB, its maximum is 2 MB; a 4 MB
  Trio64 is fast page memory by its data book, and the model straps it so); a new test that reads the memory size or the VESA mode list gets the tag. Expected
  values follow the memory size, never a fixed 2 MB.
- Test coverage goal: at least 80 % of the ROM's code is executed by the tests (`make coverage ROM=...`:
  every emulator test with coverage recording, then `emu/codemap.py`, which finds the code by recursive
  descent and does not count data, padding or code nothing reaches). A new patch or a new BIOS
  function path comes with a test that runs it; `--list` shows the code no test reaches.
- EGA/CGA goal: in the CGA, MDA and EGA modes (00h-07h, 0Dh-10h) the ROM behaves exactly like the
  unpatched reference BIOS 2.04.07: same registers back, BIOS data, video memory, DAC and standard VGA
  registers after every call (`make 775-ref-compare REF775=... ROM=...`, emu/refcompare.py). Our
  changes there are speed only (32-bit stores) or VGA/S3 extended registers; a change that makes a
  difference in those modes needs a reason in README.md. The Trio64 ROM carries S3's fonts instead of
  Phoenix's (README "Trio64 ROM"): `make 764-ref-compare` compares it with 1.5-07 with those fonts only
  (`s3tpatch.py --fonts-only`), so every other difference still shows.
- Emulation is a useful extra check before hardware runs: `emu/` runs the ROM's POST and INT 10h, and
  the DOS tools on top of it, under Unicorn with a VGA register model (`make emu-test ROM=...`). It
  models registers, a planar window and a virtual clock (refresh rates there follow the programmed
  timing), but has no banked or linear video memory and no real bus speed, so keep those results
  apart from real findings; the hardware logs decide. Add a test to
  `emu/tests.py` for new behaviour the model can judge.
- Deliver changes as a pull request against main.
- A bug that has ever been on the main branch (in a ROM, a tool, the patchers or the tests) gets a
  GitHub issue before it is fixed, as issues #47-#69 do: what is wrong, the cause, the effect of the
  fix, and how it is tested. Labels: the type (`fix`; `speed` and `picture` for improvements), every
  chip whose ROM or tool has the bug by its chip code (`775`, `765`, `764`; README "Chip codes"), and the level that fixes it
  (`p22`, `1.03-08-p2`, `1.5-07-p2`, ...). The fixing commit and pull request name the issue
  (`Fixes #N`). Close it once the fix is verified on a card, and say in a comment which chips are
  still checked in the emulator only. A bug that never reached main (made and fixed on an unmerged
  branch) needs no issue.
