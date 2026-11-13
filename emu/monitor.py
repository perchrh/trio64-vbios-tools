"""monitor.py - the display model of the emulator: what an attached monitor does to the SENSE line.

Milestone 5 of the clean-room scope (docs/cleanroom/spec-d-sense.md) has POST classify the display
through 3C2h bit 4 (STATUS_0, "Monitor Sense Status"): the RAMDAC's analog comparators drive the
internal SENSE signal when a driven AR/AG/AB output exceeds 330 mV +/- 20 %, and the data book says
the information "can be used to detect the existence and type of monitor" (T64-SENSE-1, the Trio32/
Trio64 data book 8.4, section 14 STATUS_0). On the Trio64 the signal is active low: 3C2h bit 4 reads
0 while the condition holds and 1 when it does not (spec-d SENSE-1; the Vision964 excerpt's "SENSE
goes active" wording is that chip's polarity and is not transferred).

The model reads DAC palette register 0: the sense procedure drives that entry through the standard
palette path (3C8h, then the RGB triple at 3C9h) and selects it through the attribute controller, and
SENSE-2 pins the entry to 0 so that emulators modelling the sense from a single palette entry see the
same one (86Box reads vgapal[0] in vid_svga.c). The drive value is full scale 63 (the M5-DAC project
choice: full scale clears the threshold with margin).

What the display kind means here is which analog outputs it terminates (its load): a colour display
loads all three lines, a monochrome display only the green one (Vision964 8.2.7 extract), and with
nothing connected there is no load. The truth table that follows (spec-d SENSE-3), driving one channel
of palette register 0 to full scale and reading 3C2h bit 4:

  colour display: bit 4 = 0 for the red, the green and the blue drive
  monochrome:     bit 4 = 0 only for the green drive
  no display:     bit 4 stays 1 for all three drives

vgaemu.py uses this when Machine.monitor is set (None, the default, keeps the old constant 0x10 at
3C2h, so every existing test sees exactly what it saw before). tests.py's t_sense POSTs once per kind
and asserts the classification results of spec-d SENSE-5/6/7 and SENSE-8.
"""

# An unloaded DAC output at full scale (63) rises to about 0.7 V (Vision964 8.2.7 extract); the
# comparator threshold is 330 mV +/- 20 % of that (T64-SENSE-1). In 6-bit DAC units the nominal
# threshold is 30, the tolerance band 24..36.
DAC_FULL_MV = 700.0
SENSE_THRESH_MV = 330.0
SENSE_TOL = 0.20
SENSE_THRESH = round(SENSE_THRESH_MV / DAC_FULL_MV * 63)      # 30
SENSE_THRESH_MIN = round(SENSE_THRESH_MV * (1 - SENSE_TOL) / DAC_FULL_MV * 63)   # 24
SENSE_THRESH_MAX = round(SENSE_THRESH_MV * (1 + SENSE_TOL) / DAC_FULL_MV * 63)   # 36

# Which analog outputs (red, green, blue) the display terminates.
LOADS = {'colour': (True, True, True),
         'mono': (False, True, False),
         'none': (False, False, False)}
KINDS = tuple(LOADS)


class Monitor:
    """One display attached to the card. kind is one of KINDS. sense_bit4() is the value 3C2h bit 4
    reads while the given DAC palette entry drives the analog outputs."""

    def __init__(self, kind):
        if kind not in LOADS:
            raise ValueError('monitor kind %r: one of %s' % (kind, ', '.join(KINDS)))
        self.kind = kind
        self.load = LOADS[kind]

    def sense_bit4(self, entry):
        """3C2h bit 4 with DAC palette entry `entry` (an (r, g, b) triple of 6-bit values) on the
        outputs: 0 (active low, T64-SENSE-1) when a terminated channel is driven to at least the
        comparator threshold, else 1. Gives the SENSE-3 truth table for full-scale single-channel
        drives; an entry below the threshold on every terminated channel reads 1."""
        return 0 if any(entry[c] >= SENSE_THRESH and self.load[c] for c in range(3)) else 1

    def __repr__(self):
        return 'Monitor(%s)' % self.kind
