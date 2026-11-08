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
from __future__ import annotations
from typing import Any

import sys

sys.path.insert(0, "emu")
from unicorn.x86_const import UC_X86_REG_AX     # noqa: E402
from vgaemu import Machine                       # noqa: E402


class Recorder(Machine):
    """Machine that records port 42h/43h/61h writes and INT 10h calls. The
    unicorn hooks hold the bound methods from __init__, so recording has to
    happen in overrides, not by swapping attributes after the fact."""

    def __init__(self, rom: bytes) -> None:
        self.p43, self.p42, self.p61, self.i10, self.raw = [], [], [], [], []
        super().__init__(rom)

    def _out(self, uc: Any, port: int, size: int, val: int, ud: Any) -> None:
        if port == 0x43:
            self.p43.append(val)
        elif port == 0x42:
            self.p42.append(val)
        elif port == 0x61:
            self.p61.append(val)
        if port in (0x42, 0x43):
            self.raw.append((port, val))
        return Machine._out(self, uc, port, size, val, ud)

    def _intr(self, uc: Any, n: int, ud: Any) -> None:
        if n == 0x10:
            self.i10.append(uc.reg_read(UC_X86_REG_AX) >> 8)   # AH of the call
        return Machine._intr(self, uc, n, ud)


def main() -> None:
    path = sys.argv[1] if len(sys.argv) > 1 else "build/roms/poc/HELLO64K.ROM"
    rom = open(path, "rb").read()[:32 * 1024]   # the image the BIOS copies
    assert rom[0:2] == b"\x55\xAA" and rom[2] == 0x40

    m = Recorder(rom)
    vec = m.post()
    print("post: the ROM returned to the far call, no HLT, no budget overrun")
    print("INT 10h vector after POST: %04X:%04X (unchanged; the PoC hooks nothing)"
          % (vec[0], vec[1]))
    print("INT 10h calls made: %d (teletype AH=0Eh, AH values %s; the stub prints nothing)"
          % (len(m.i10), sorted({hex(a) for a in m.i10})))

    divisors = [m.p42[i] | (m.p42[i + 1] << 8) for i in range(0, len(m.p42) - 1, 2)]
    print("PIT channel 2 divisors: %s (1193182/Hz: %s)"
          % (["0x%04X" % d for d in divisors],
             [round(1193182 / d) for d in divisors]))
    # the control word must precede the count bytes (the byte pointer it resets)
    seq = [("43", v) if p == 0x43 else ("42", v) for p, v in m.raw]
    first43 = next(i for i, (p, _) in enumerate(seq) if p == "43" and seq[i][1] == 0xB6)
    assert all(p == "43" for p, _ in seq[:first43]), "count written before the control word"
    print("PIT control words to 43h: 0xB6 x%d (channel 2 square wave, before each count), "
          "0x00 x%d (channel 0 counter latch)"
          % (m.p43.count(0xB6), m.p43.count(0x00)))
    gate = [v & 3 for v in m.p61]
    print("port 61h gate writes: %d (on/off pairs: %d)"
          % (len(m.p61), sum(1 for i in range(0, len(gate) - 1, 2) if gate[i] == 3)))
    print("virtual clock advanced %d PIT counts (~%.1f s of machine time)"
          % (m.t, m.t / 1193182))
    assert m.p43.count(0xB6) == 4, "expected exactly four tones, got %d" % m.p43.count(0xB6)
    assert sum(1 for i in range(0, len(gate) - 1, 2) if gate[i] == 3) == 4
    assert sum(m.mem(0xC0000, 0x8000)) & 0xFF == 0, "the image sum changed (ROM-6)"
    print("image sum after POST: 00h (the image is not written, ROM-6)")

    # a second init call (the old PCI BIOS CF=0 run-time call, or a second copy
    # of the image that a scanning BIOS also found) must not beep again
    import struct
    m.mu.mem_write(0x7D00, b"\x9A\x03\x00" + struct.pack("<H", vec[0]) + b"\xF4")
    from unicorn.x86_const import (UC_X86_REG_CS, UC_X86_REG_SS, UC_X86_REG_SP,
                                   UC_X86_REG_EFLAGS)
    for reg, v in ((UC_X86_REG_CS, 0), (UC_X86_REG_SS, 0), (UC_X86_REG_SP, 0x7000),
                   (UC_X86_REG_EFLAGS, 0x202)):
        m.mu.reg_write(reg, v)
    b6, g61 = m.p43.count(0xB6), len(m.p61)
    m.mu.emu_start(0x7D00, 0x7D05, count=50_000_000)
    assert m.p43.count(0xB6) == b6 and len(m.p61) == g61, \
        "a second init call beeped again (%d -> %d tones)" % (b6, m.p43.count(0xB6))
    print("second init call: no new tones (the done flag at 0040:00FF held)")
    print("POST experiment: PASS")


if __name__ == "__main__":
    main()
