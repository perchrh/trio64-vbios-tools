# AGENTS.md

Guidance for anyone, human or AI agent, changing this repository. Read README.md first: it describes
the tools, the VBIOS changes they verify and where the reference data comes from.

## Project context

- Hardware: Gainward S3 Trio64V2/DX (86C775), 2 MB EDO 40 ns, board ICUVGA-GW503A, PCI 5333:8901.
- The ROM is a 64 KB image. The lower 32 KB is BIOS 2.04.11 with our patches (currently -p13); the
  upper 32 KB is the Trio64V+ BIOS 1.03-08 and must stay byte-identical to the stock dump.
- The patched ROM images are kept outside this repository. `rompatch/` holds the ROM code (nasm) and
  `s3patch.py`, which builds p13 (or p12 with `--target p12`) from the stock 2.04.11 dump or the S3
  reference 2.04.07 with byte assertions; it must keep reproducing the pinned p12 and p13 SHA-256 from
  the stock dump (`make rom-test`); a new patch level gets a new target and a new pinned hash. The
  repository also holds the DOS test tools (VSHOW, S3TEST, S3COMPAT, VGALOG, S3REGS, S3REGS32 for the Windows 9x desktop),
  the TSR S3ALIAS and their documentation.
- Test machine: plain DOS on a 386 or later. Monitors: an Eizo LCD (native 1600x1200) and a multiQ
  LCD (native 800x600, does not support 1280x1024 at all). "Out of range" on the multiQ in
  1280x1024 modes is the monitor, not the BIOS.

## Hard rules for the ROM

- Stay compatible with the standard VGA modes (00h-13h) and the VESA modes. Never change what a
  standard mode returns to a program; use standard VESA/VGA timings; keep 70 Hz for 320x200 and
  640x400 text/graphics.
- The RAM must stay treated as 1-cycle EDO (CR36 bits 3-2 = 00). MCLK is 59.96 MHz, the 1-cycle EDO
  maximum. Do not raise it.
- Blank pedestal off (SR1A bit 5 = 0): the deepest black is wanted.
- Every ROM version carries a -pN suffix in the sign-on string and a correct checksum in both halves.
- Base every change on the stock image plus explicit patches with byte assertions, so a build fails
  when the bytes under a patch are not what the patch expects.
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
- The S3 2.04.07 reference BIOS has been examined, but its data is not used in the tests yet.
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
- All tools share one version number (0.8 now), `VERSION` in `common/version.inc`; never write the
  number into a tool's strings, use `VERSION` (and `ROMVER` for the ROM S3TEST expects). Each tool prints its version on its first line of
  output and in its error messages. Bump them all together, and only when asked.

## Assembly conventions

- NASM 2.x, `-f bin`, 16-bit .COM files (`bits 16`, `org 0x100`), `cpu 386` where 32-bit registers are
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
- Emulation is a useful extra check before hardware runs: `emu/` runs the ROM's POST and INT 10h, and
  the DOS tools on top of it, under Unicorn with a VGA register model (`make emu-test ROM=...`). It
  models registers, a planar window and a virtual clock (refresh rates there follow the programmed
  timing), but has no banked or linear video memory and no real bus speed, so keep those results
  apart from real findings; the hardware logs decide. Add a test to
  `emu/tests.py` for new behaviour the model can judge.
- Deliver changes as a pull request against main.
