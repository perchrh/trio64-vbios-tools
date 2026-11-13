# Part D: the monitor sense at POST (milestone 5)

Behaviour specification for a clean-room Trio64 video BIOS, milestone 5 of
[`docs/clean-room.md`](../clean-room.md) "Scope". It says what POST does with the data book's SENSE
mechanism to detect the display (colour, monochrome or none) and what it then leaves in the BIOS
data area and the chip. It describes behaviour only: registers, values, order constraints, inputs
and outputs. How the code gets there is the clean side's choice.

The target card is the ExpertColor DSP-3364P (S3 86C764X, Trio64, PCI 5333:8811); the ROM must
also work with 1 MB and 4 MB Trio64 boards and with EDO memory. The base is the same as parts A-C:
the ROM is written from scratch (2 November 2026, [#145](https://github.com/perchrh/trio64-vbios-tools/issues/145)).

Written 13 November 2026. Part A's POST-42 is the milestones 1-4 case (no sense, always colour);
this part is milestone 5 and replaces it there. Parts A (POST), B (the mode set) and C (VBE 1.2)
are separate; where a rule here depends on them it says so.

## Conventions

- **IDs.** `SENSE-n`. An ID is never reused for another rule.
- **Polarity.** On the Trio64 the SENSE signal is **active low**: STATUS_0 (3C2h) bit 4 reads 0
  when a driven analog output exceeds the comparator threshold, and 1 when it does not. The
  Vision964 excerpt's "SENSE goes active" language is that chip's polarity and must not be
  transferred (see the extract's own caution).

## Rules

| ID | Rule | Source | Strength | Checked by |
| --- | --- | --- | --- | --- |
| SENSE-1 | STATUS_0 (3C2h) bit 4 is the Monitor Sense Status: the internal RAMDAC analog comparators drive the internal SENSE signal active low when any AR, AG or AB output exceeds 330 mV +/- 20%; the data book says the information "can be used to detect the existence and type of monitor". 3C2h bits 3-2 select the VGA clock and are unrelated to bit 4; a sense read must restore them (T64-CLK-1) | T64-SENSE-1 (T32/64 8.4, section 14 STATUS_0) | must | emu t_sense, each display kind (monitor model `emu/monitor.py`, `Machine.monitor`: 3C2h bit 4 from DAC palette register 0 and the display's load); card: POST with each display type on the DSP-3364P |
| SENSE-2 | The sense procedure: POST drives the three analog outputs one at a time (red, green, blue) through the standard palette path - write DAC palette register 0 (PEL address 0 at 3C8h, then the RGB triple at 3C9h) with 63 on the driven channel and 0 on the other two, select palette register 0 through the attribute controller, read 3C2h bit 4 - and restores the palette and the attribute controller to their power-on state afterwards. Palette register 0 is pinned so the driven entry is the same one emulators that model the sense from a single palette entry can see (86Box reads vgapal[0], see "Emulator coverage"). The drive value 63 is a project choice (the data book gives only the threshold; full scale clears it with margin, an unloaded output rises to about 0.7 V against a 264-396 mV threshold, a monitor-terminated output stays below it) | Vision964 8.2.7 extract ([`primary-extracts/vision964-sense-input-utilization.md`](primary-extracts/vision964-sense-input-utilization.md)) for the procedure and classification; M5-DAC decision (full scale, project choice); T64-SENSE-1 for the polarity | must | emu t_sense (drive trace: full-scale single-channel drives of palette register 0 at the 3C2h reads of POST); card: POST with each display type on the DSP-3364P |
| SENSE-3 | Classification truth table: no monitor - 3C2h bit 4 stays 1 for all three drives; monochrome monitor - bit 4 goes 0 only when the green output is driven; colour monitor - bit 4 goes 0 for each of the three. (An output terminated by a monitor's load stays below the threshold; an unloaded output rises above it.) | Vision964 8.2.7 extract; T64-SENSE-1 for the Trio64 polarity and threshold | must | emu t_sense (classification per display kind); card: POST with each display type on the DSP-3364P |
| SENSE-4 | Order: the sense runs at POST before the first mode set (nothing is displayed yet); after it, the DAC palette, the attribute controller and 3C2h bits 3-2 are as before the sense | M5-DAC decision; T64-CLK-1 | must (project choice for the placement) | emu t_sense (DAC entry 0, attribute controller and 3C2h bits 3-2 equal the no-monitor POST) |
| SENSE-5 | Colour result: power-on mode 03h; 0040:0089h bit 2 (monochrome display) = 0 and bit 1 (grey summing) = 0; 0040:0087h bit 1 (mono monitor) = 0; equipment word 0040:0010h bits 5-4 = 10b (80x25 colour) | IBM extract ([`primary-extracts/ibm-bios-power-on-mode-and-mono-state.md`](primary-extracts/ibm-bios-power-on-mode-and-mono-state.md)), Figure 2-4 item 5c (power-on default mode with a colour display is 3); RBIL M0006/M0024/M0027 via bios-rules BDA-1, BDA-14, BDA-16; part A POST-34 | must | emu t_sense (colour kind); card: POST with a colour display |
| SENSE-6 | Monochrome result: power-on mode 07h; 0040:0089h bit 2 = 1; 0040:0087h bit 1 = 1; equipment word 0040:0010h bits 5-4 = 11b (80x25 monochrome) | IBM extract, Figure 2-4 item 5d (power-on default mode with a monochrome display is 7); RBIL M0006/M0024/M0027 via bios-rules BDA-1, BDA-14, BDA-16 | must | emu t_sense (mono kind); card: POST with a monochrome display |
| SENSE-7 | No-display result: behave exactly as on a colour monitor (SENSE-5); no "no display" bit is invented in the BIOS data area - "none" and "colour" share the colour path. No public source defines a no-display contract, so this is a project choice | M5-NODISP decision (no public no-display source); POST-42 stays the milestones 1-4 case | must (project design choice) | emu t_sense (none kind) |
| SENSE-8 | Software-visible state: INT 10h AH=12h BL=10h returns BH = 00h colour mode in effect (30x range), BH = 01h monochrome mode in effect (3Bx range); INT 10h AH=1Bh state block byte DI+2Dh bit 2 = 1 monochrome display attached, bit 1 = summing active, bit 0 = all modes on all displays (the same bits 0040:0089h holds) | IBM extract, pages 2-32 (AH=12h BL=10h) and 2-41 (state block 2Dh); bios-rules BDA-16, B1B-7 | must (BH), should (2Dh) | S3COMPAT AH=12 BL=10 lines; emu state block check |
| SENSE-9 | Monochrome modes' addressing: in 07h and 0Fh the CRTC and input status 1 are at 3B4h/3BAh (MISC bit 0 = 0) and 0040:0063h = 3B4h; in every other mode at 3D4h/3DAh and 0040:0063h = 3D4h. A VGA sets every mode on whatever display is attached: a monochrome mode on a colour display, or a colour mode on a monochrome display, is not refused, and a mode set of 07h/0Fh makes the equipment word bits 5-4 = 11b, of any colour mode 10b | RBIL MEM 0040:0063h; IBM (VGATEST MISC, state block 1Eh = 3D4h); bios-rules MODE-14, MODE-15, BDA-1 | must (MODE-14, BDA-1), should (MODE-15) | emu t_mono; S3COMPAT 'Mode nnh' fail 1 |
| SENSE-10 | Grey summing switch: INT 10h AH=12h BL=33h with AL = 0 enables summing, AL = 1 disables; when enabled, summing occurs during AH=00h colour register loading and AH=10h palette register calls; INT 10h AH=10h AL=1Bh replaces each colour register's red, green and blue with the weighted sum 30% red + 59% green + 11% blue | IBM extract, pages 2-34 (AH=12h BL=33h) and 2-22 (AH=10h AL=1Bh); bios-rules B00-12 | must | S3COMPAT 'AH=12 BL=33 ...' lines |

## Open questions

1. **[Open decision (owner)]** Does POST set 0040:0089h bit 1 (grey summing) = 1 when the sense found
   a monochrome display? The IBM book defines the bit and the AH=12h BL=33h switch (SENSE-10) but
   the extract states no POST default for it; POST-42's colour case sets it 0. Proposed until a
   source says otherwise: 1 on monochrome, 0 otherwise, labelled a project choice.
2. **[Open observation - card/bench]** Which DAC palette a mode set loads in 07h and 0Fh (a
   monochrome palette, or the EGA palette), and what DAC entries 40h-FFh hold after a mode set of a
   mode other than 13h - bios-rules open question 4. Needed for monochrome output to be correct;
   until observed, label it.
3. **[Open observation - card/bench]** Mode 07h with 200 lines selected (AH=12h BL=30h AL=00h):
   350 or 400 lines, and which font - bios-rules open question 9.
4. **[Answered 13 November 2026 - emulator done, card open]** `emu/monitor.py` adds the monitor
   model (colour / monochrome / none): a display kind says which analog outputs it terminates, and
   3C2h bit 4 is computed from DAC palette register 0 with the Trio64 polarity (SENSE-1, active
   low on a terminated channel driven over the 330 mV threshold; SENSE-2 pins the entry to 0).
   `Machine.monitor` selects it in `emu/vgaemu.py` (None keeps the constant 0x10 at 3C2h), and
   `t_sense` in `emu/tests.py` POSTs once per kind and asserts the mode, the BDA bits and
   0040:0063h for each of the three display types, the AH=12h BL=10h / state block bits, and that
   the sense restored the DAC, the attribute controller and 3C2h bits 3-2 (XFAIL until a ROM
   implements this part; run the suite with a display attached via `make emu-test ROM=...
   MONITOR=colour`, tests.py `--monitor`). The card observation stays open in issue #200: POST
   with each display type on the DSP-3364P.

## Emulator coverage

- **Our emulator** (`emu/vgaemu.py` + `emu/monitor.py`) is where the SENSE classification is
  tested: `Machine.monitor` attaches a display of a kind, and a 3C2h read returns bit 4 computed
  from DAC palette register 0 and the display's load with the Trio64 polarity (SENSE-1..3), bits
  3-2 from the written MISC. `t_sense` (emu/tests.py, XFAIL until a ROM implements this part)
  POSTs once per kind and checks the classification results; `tests.py --monitor` (make
  `MONITOR=`) runs the whole suite with a display attached.
- **86Box** can be a whole-system smoke test only. Its SVGA core (`vid_svga.c`, `svga_in` case
  0x3c2) models 3C2h bit 4 from DAC palette entry 0: with a cable connected, bit 4 goes 0 when any
  of entry 0's channels is >= 0x26 (38) or their sum >= 0x4e (78); with no cable the threshold is
  10 (an IBM PS/55 quirk). That covers the drive-and-read loop and a full-scale drive (63 clears
  both thresholds), and our ROM override in a VM is proven ([`../../86box-runs.md`](../../86box-runs.md)),
  but 86Box has no monochrome-load model on the sense line and follows the IBM polarity (sense
  asserts with a monitor attached), the opposite of the Trio64's - so it cannot be the oracle for
  the colour/mono/none classification. The classification test belongs in our own emulator, and
  the mono branch additionally on the card with a monochrome display.

## What this part does not cover

- The sense with a warm boot (spec-a open question 3, the setup port): unchanged by milestone 5.
- DDC/EDID monitor identification (milestone 7, an idea): a separate mechanism, not SENSE.
- The VESA text modes and FreeDOS (milestone 6): see [`freedos-1.4.md`](freedos-1.4.md); the sense
  result feeds only the power-on mode and the BDA flags above.
