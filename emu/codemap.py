#!/usr/bin/env python3
"""codemap.py - which bytes of the video BIOS are code, and how much of that code the tests execute.

    python3 emu/tests.py --rom S3V2P15.BIN --coverage cov.bin      (records what the tests execute)
    python3 emu/codemap.py --rom S3V2P15.BIN --cover cov.bin [--list] [--min 8]
    make coverage ROM=S3V2P15.BIN

Needs python3 with the capstone package (pyproject.toml, extra "coverage").

The code of the lower 32 KB is found by recursive descent with capstone (16-bit x86): from the POST
entry (offset 3), the INT 10h entry (from the ROM header's jump and the vectors POST sets are taken from
the executed code), every basic block the tests ran, and every direct jump, call and loop target found
on the way. Indirect jumps and calls through a word table in the ROM (jmp/call [cs:bx+table] and
[bx+table] with CS) add the table's entries as long as they point to plausible code. Everything not
reached this way is data (tables, fonts, strings, padding) or code nothing reaches (old routines our
patches jump around); neither counts.

Coverage = bytes of code the tests executed / bytes of code. --list prints the code ranges no test
executed (at least --min bytes), with the nearest entry point before them, to see which functions
need tests.
"""
import argparse, os, struct, sys

try:
    import capstone
    from capstone import x86_const as X
except ImportError:
    print('codemap.py needs the capstone package: pip install capstone', file=sys.stderr)
    sys.exit(2)

ROMSZ = 0x8000
STOP = {'ret', 'retf', 'iret', 'jmp', 'ljmp', 'hlt'}
BRANCH = {'jmp', 'call', 'loop', 'loope', 'loopne', 'jcxz', 'jecxz'}


def is_jcc(mn):
    return mn.startswith('j') and mn not in ('jmp',)


class Map:
    def __init__(self, rom):
        self.rom = rom
        self.md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
        self.md.detail = True
        self.code = bytearray(ROMSZ)          # 1: instruction byte, 2: instruction start
        self.entries = set()
        self.tables = {}

    def insn(self, off):
        for i in self.md.disasm(self.rom[off:off + 16], off):
            return i
        return None

    def plausible(self, off, n=3):
        """n instructions decode at off without running out of the ROM or into zero padding."""
        for _ in range(n):
            if not 0x60 <= off < ROMSZ:
                return False
            i = self.insn(off)
            if i is None or self.rom[off:off + 2] == b'\x00\x00':
                return False
            if i.mnemonic in STOP:
                return True
            off += i.size
        return True

    def table(self, base):
        """Word table of code offsets at base. Zero words before the first entry are skipped (a table
        indexed from a nonzero number, e.g. [si+table] with SI = 2 * BH and BH >= 2)."""
        out = []
        for k in range(128):
            a = base + 2 * k
            if a + 2 > ROMSZ or self.code[a] or self.code[a + 1]:
                break
            t = struct.unpack_from('<H', self.rom, a)[0]
            if t == 0 and not out and k < 4:
                continue
            if not self.plausible(t):
                break
            out.append(t)
        return out

    def walk(self, seeds):
        work = list(seeds)
        while work:
            off = work.pop()
            while 0 <= off < ROMSZ and not self.code[off] & 2:
                i = self.insn(off)
                if i is None:
                    break
                if any(self.code[off + k] & 1 for k in range(i.size)):
                    break                       # runs into the middle of a known instruction
                for k in range(i.size):
                    self.code[off + k] |= 1
                self.code[off] |= 2
                mn = i.mnemonic
                if (mn in BRANCH or is_jcc(mn)) and i.operands:
                    op = i.operands[0]
                    if op.type == X.X86_OP_IMM:
                        t = op.imm & 0xFFFF
                        if t < ROMSZ:
                            work.append(t)
                            if mn == 'call':
                                self.entries.add(t)
                    elif op.type == X.X86_OP_MEM and mn in ('jmp', 'call'):
                        mem = op.mem
                        seg_cs = mem.segment == X.X86_REG_CS or i.prefix[1] == 0x2E
                        if mem.base in (X.X86_REG_BX, X.X86_REG_SI, X.X86_REG_DI) and mem.disp and \
                                (seg_cs or mem.segment == X.X86_REG_INVALID):
                            base = mem.disp & 0xFFFF
                            if base < ROMSZ and base not in self.tables:
                                ents = self.table(base)
                                self.tables[base] = ents
                                for t in ents:
                                    self.entries.add(t)
                                    work.append(t)
                if mn in ('ljmp', 'lcall') and len(i.operands) == 2:
                    seg, t = i.operands[0].imm, i.operands[1].imm
                    if seg == 0xC000 and t < ROMSZ:
                        work.append(t)
                if mn in STOP:
                    break
                off += i.size


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[1])
    ap.add_argument('--rom', required=True)
    ap.add_argument('--cover', required=True, help='coverage file of emu/tests.py --coverage')
    ap.add_argument('--list', action='store_true', help='list the code ranges no test executed')
    ap.add_argument('--min', type=int, default=8, help='smallest unexecuted range to list (bytes)')
    ap.add_argument('--fail-under', type=float, default=0, help='exit code 1 when coverage is below this %')
    a = ap.parse_args()
    rom = open(a.rom, 'rb').read()[:ROMSZ]
    cov = open(a.cover, 'rb').read()
    ex = cov[:ROMSZ]
    m = Map(rom)
    seeds = [3] + [i for i in range(ROMSZ) if ex[i] & 2]
    m.entries.update(seeds[:1])
    m.walk(seeds)
    code = [i for i in range(ROMSZ) if m.code[i] & 1]
    run = [i for i in code if ex[i] & 1]
    pct = 100.0 * len(run) / max(1, len(code))
    outside = sum(1 for i in range(ROMSZ) if ex[i] & 1 and not m.code[i] & 1)
    print('code %d bytes (%d tables), executed by the tests %d bytes: %.1f%%' %
          (len(code), len(m.tables), len(run), pct))
    if outside:
        print('note: %d executed bytes outside the code map' % outside)
    if a.list:
        ents = sorted(m.entries)
        i = 0
        gaps = []
        while i < ROMSZ:
            if m.code[i] & 1 and not ex[i] & 1:
                j = i
                while j < ROMSZ and (not ex[j] & 1) and (m.code[j] & 1 or (j + 1 < ROMSZ and m.code[j + 1] & 1 and not ex[j + 1] & 1)):
                    j += 1
                n = sum(1 for k in range(i, j) if m.code[k] & 1)
                if n >= a.min:
                    e = max([x for x in ents if x <= i] or [0])
                    gaps.append((n, i, j, e))
                i = j
            else:
                i += 1
        for n, i, j, e in sorted(gaps, key=lambda g: g[1]):
            print('%04X-%04X %5d bytes not executed (entry %04X)' % (i, j - 1, n, e))
    return 1 if pct < a.fail_under else 0


if __name__ == '__main__':
    sys.exit(main())
