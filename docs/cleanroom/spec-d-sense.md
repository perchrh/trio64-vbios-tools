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
| SENSE-1 | STATUS_0 (3C2h) bit 4 is the Monitor Sense Status: the internal RAMDAC analog comparators drive the internal SENSE signal active low when any AR, AG or AB output exceeds 330 mV +/- 20%; the data book says the information "can be used to detect the existence and type of monitor". 3C2h bits 3-2 select the VGA clock and are unrelated to bit 4; a sense read must restore them (T64-CLK-1) | T64-SENSE-1 (T32/64 8.4, section 14 STATUS_0) | must | not checked: the emulator returns a constant at 3C2h until a monitor model is added (open question 4) |
| SENSE-2 | The sense procedure: POST drives the three analog outputs one at a time (red, green, blue) through the standard palette path - write the DAC colour register (PEL address write 3C8h, then the RGB triple at 3C9h) with 63 on the driven channel and 0 on the other two, select that colour through the attribute controller, read 3C2h bit 4 - and restores the palette and the attribute controller to their power-on state afterwards. The drive value 63 is a project choice (the data book gives only the threshold; full scale clears it with margin, an unloaded output rises to about 0.7 V against a 264-396 mV threshold, a monitor-terminated output stays below it) | Vision964 8.2.7 extract ([`primary-extracts/vision964-sense-input-utilization.md`](primary-extracts/vision964-sense-input-utilization.md)) for the procedure and classification; M5-DAC decision (full scale, project choice); T64-SENSE-1 for the polarity | must | not checked (same emulator gap); card: POST with each display type on the DSP-3364P |
| SENSE-3 | Classification truth table: no monitor - 3C2h bit 4 stays 1 for all three drives; monochrome monitor - bit 4 goes 0 only when the green output is driven; colour monitor - bit 4 goes 0 for each of the three. (An output terminated by a monitor's load stays below the threshold; an unloaded output rises above it.) | Vision964 8.2.7 extract; T64-SENSE-1 for the Trio64 polarity and threshold | must | not checked (same emulator gap) |
| SENSE-4 | Order: the sense runs at POST before the first mode set (nothing is displayed yet); after it, the DAC palette, the attribute controller and 3C2h bits 3-2 are as before the sense | M5-DAC decision; T64-CLK-1 | must (project choice for the placement) | not checked |
| SENSE-5 | Colour result: power-on mode 03h; 0040:0089h bit 2 (monochrome display) = 0 and bit 1 (grey summing) = 0; 0040:0087h bit 1 (mono monitor) = 0; equipment word 0040:0010h bits 5-4 = 10b (80x25 colour) | IBM extract ([`primary-extracts/ibm-bios-power-on-mode-and-mono-state.md`](primary-extracts/ibm-bios-power-on-mode-and-mono-state.md)), Figure 2-4 item 5c (power-on default mode with a colour display is 3); RBIL M0006/M0024/M0027 via bios-rules BDA-1, BDA-14, BDA-16; part A POST-34 | must | emu t_post with a colour monitor model; card: POST with a colour display |
| SENSE-6 | Monochrome result: power-on mode 07h; 0040:0089h bit 2 = 1; 0040:0087h bit 1 = 1; equipment word 0040:0010h bits 5-4 = 11b (80x25 monochrome) | IBM extract, Figure 2-4 item 5d (power-on default mode with a monochrome display is 7); RBIL M0006/M0024/M0027 via bios-rules BDA-1, BDA-14, BDA-16 | must | emu t_post with a monochrome monitor model; card: POST with a monochrome display |
| SENSE-7 | No-display result: behave exactly as on a colour monitor (SENSE-5); no "no display" bit is invented in the BIOS data area - "none" and "colour" share the colour path. No public source defines a no-display contract, so this is a project choice | M5-NODISP decision (no public no-display source); POST-42 stays the milestones 1-4 case | must (project design choice) | emu t_post with a no-monitor model |
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
4. **[Open - dirty-side emulator task]** `emu/vgaemu.py` returns a constant 0x10 at port 3C2h, so
   no SENSE row can be checked today. A monitor model (colour / monochrome / none) that computes
   3C2h bit 4 from the DAC drive and a simulated monitor load must be added to the emulator before
   milestone 5 is implemented; the SENSE rows' "Checked by" then become an emu t_sense asserting
   the mode, the BDA bits and 0040:0063h for each of the three display types.

## What this part does not cover

- The sense with a warm boot (spec-a open question 3, the setup port): unchanged by milestone 5.
- DDC/EDID monitor identification (milestone 7, an idea): a separate mechanism, not SENSE.
- The VESA text modes and FreeDOS (milestone 6): see [`freedos-1.4.md`](freedos-1.4.md); the sense
  result feeds only the power-on mode and the BDA flags above.
