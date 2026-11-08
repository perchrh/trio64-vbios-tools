# Vision964 section 8.2.7: SENSE Input Utilization (extract)

Source: Vision964 Graphics Accelerator data book, section 8.2.7 "SENSE Input
Utilization" (page 8-6), in
[`datasheets/s3/pdf/86c964-vision964.pdf`](../../../datasheets/s3/pdf/86c964-vision964.pdf)
(markdown copy:
[`datasheets/s3/markdown/86c964-vision964.pdf.md`](../../../datasheets/s3/markdown/86c964-vision964.pdf.md);
that conversion is lossy on this two-column page, so this excerpt is the
authoritative text, provided by the owner on 8 November 2026). The same section,
verbatim the same, is in the Vision864 book (db008-b, section 8.2.7,
[`datasheets/s3/pdf/db008-b-86c864-vision864-graphics-accelerator.pdf`](../../../datasheets/s3/pdf/db008-b-86c864-vision864-graphics-accelerator.pdf)).
Kept for milestone 5, the monitor sense (decisions M-SENSE).

## Verbatim excerpt

> The SENSE output of the RAMDAC is used by the BIOS to detect the existence and
> type of monitor connected to the system. The BIOS sequentially drives the three
> analog outputs (red, *green*, blue) and determines whether or not the SENSE
> *signal* is driven active. If no monitor is present, SENSE will never *go
> active*. If a monochrome monitor is present, SENSE will go active only when the
> green output is driven. If a color monitor is present, SENSE will go active
> when each of the outputs is driven. DOS uses special palette colors when in
> monochrome mode. No S3 enhanced mode drivers use monochrome palettes.

## What it answers, and what it does not

- It states the sense **procedure** and the **classification** a BIOS derives
  from it: drive the red, green and blue outputs one after another and watch
  SENSE; no monitor, a monochrome monitor (only the green output loaded) and a
  color monitor (every output loaded) give three distinct patterns.
- **Polarity caution.** On the Vision964 the SENSE input comes from an external
  RAMDAC, and the excerpt's active/inactive statements are that chip's. They
  must not be transferred to the Trio64, whose internal comparators drive SENSE
  active low whenever an AR, AG or AB output exceeds 330 mV +/- 20% (Trio32/64
  data book section 8.4; the same text is section 8.5 of the Trio64V+ book and
  section 10.4 of the Aurora64V+ book). For a Trio64 sense routine the truth
  table is derived from that definition: an output loaded by a monitor's
  termination stays below the threshold, an unloaded output rises above it.
- It does **not** state what the BIOS then sets (the BIOS data area flags, the
  power-on mode, grey summing, any beep) nor the DAC values used to drive the
  outputs. Those come from the IBM reference material the owner provides for
  milestone 5.
