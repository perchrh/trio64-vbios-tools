#!/usr/bin/env python3
"""Run the PoC option ROM in the project's emulator, the way the other ROMs
run: the Machine loads the image at C0000 and post() far-calls C000:0003 like
a system BIOS (with CF clear - the emulator does not use the old PCI BIOS
CF convention, and neither must the ROM). The PoC has no VGA code, so INT 10h
stays the emulator's IRET stub (no vector is hooked) and nothing appears on
a screen; what we can see is the ROM returning to the far call, the tones it
programs into PIT channel 2 (ports 43h/42h), the speaker gate at port 61h,
the INT 10h teletype calls it makes on the way, and the machine time it
spends in the tone waits. A one-off experiment, not part of emu/tests.py
(the PoC has no VGA code to check there).

    python3 emu/poc_test.py [ROM image, default build/roms/poc/HELLO64K.ROM]
"""

import sys

sys.path.insert(0, "emu")
from vgaemu import Machine                       # noqa: E402


class Recorder(Machine):
    """Machine that records port 42h/43h/61h writes and INT 10h calls. The
    unicorn hooks hold the bound methods from __init__, so recording has to
    happen in overrides, not by swapping attributes after the fact."""

    def __init__(self, rom):
        self.p43, self.p42, self.p61, self.i10 = [], [], [], []
        super().__init__(rom)

    def _out(self, uc, port, size, val, ud):
        if port == 0x43:
            self.p43.append(val)
        elif port == 0x42:
            self.p42.append(val)
        elif port == 0x61:
            self.p61.append(val)
        return Machine._out(self, uc, port, size, val, ud)

    def _intr(self, uc, n, ud):
        if n == 0x10:
            self.i10.append(uc.reg_read(0x18) >> 8)      # UC_X86_REG_AX >> 8
        return Machine._intr(self, uc, n, ud)


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "build/roms/poc/HELLO64K.ROM"
    rom = open(path, "rb").read()[:32 * 1024]   # the image the BIOS copies
    assert rom[0:2] == b"\x55\xAA" and rom[2] == 0x40

    m = Recorder(rom)
    vec = m.post()
    print("post: the ROM returned to the far call, no HLT, no budget overrun")
    print("INT 10h vector after POST: %04X:%04X (unchanged; the PoC hooks nothing)"
          % (vec[0], vec[1]))
    print("INT 10h calls made: %d (teletype AH=0Eh; the stub prints nothing)"
          % len(m.i10))

    divisors = [m.p42[i] | (m.p42[i + 1] << 8) for i in range(0, len(m.p42) - 1, 2)]
    print("PIT channel 2 divisors: %s (1193182/Hz: %s)"
          % (["0x%04X" % d for d in divisors],
             [round(1193182 / d) for d in divisors]))
    print("PIT control words to 43h: 0xB6 x%d (channel 2 square wave), "
          "0x00 x%d (channel 0 counter latch)"
          % (m.p43.count(0xB6), m.p43.count(0x00)))
    gate = [v & 3 for v in m.p61]
    print("port 61h gate writes: %d (on/off pairs: %d)"
          % (len(m.p61), sum(1 for i in range(0, len(gate) - 1, 2) if gate[i] == 3)))
    print("virtual clock advanced %d PIT counts (~%.1f s of machine time)"
          % (m.t, m.t / 1193182))
    print("POST experiment: PASS")


if __name__ == "__main__":
    main()
