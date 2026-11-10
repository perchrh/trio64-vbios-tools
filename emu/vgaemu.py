"""vgaemu.py - run the Trio64V2 video BIOS and the DOS tools in an emulated PC (Unicorn, x86 real mode).

What is emulated
  - 1 MB of RAM with the 64 KB ROM image at C0000; the ROM is started like a system BIOS does it
    (far call to C000:0003) and then serves INT 10h.
  - A register-level model of the VGA and S3 ports: sequencer, CRTC (3D4/3B4), graphics controller,
    attribute controller with its flip-flop, misc output (its I/O select bit decides whether the
    colour or the mono CRTC ports answer), CR11 write protection of CR00-07, SR04 bit 0 reading 0 as
    on the chip, DAC with read/write indexes, input status
    (3DAh), PIT channels 0 and 2, port 61h, PCI configuration mechanism 1 and the PCI BIOS
    (INT 1Ah B101h-B10Dh) with the card's configuration header (BAR0 = E0000000 as on the real card;
    the Trio64 keeps BAR0 in CR59/CR5A).
  - One virtual clock in PIT counts (1.193182 MHz) for everything that measures time: it advances
    with every port access and every read of the BIOS tick. The PIT channels count from it, the tick
    at 0040:006C counts channel 0 periods, and the vertical retrace bit of 3DAh follows the frame period that
    the programmed CRTC and clock registers give. So refresh rates the tools measure here equal the
    rate the registers define, and call durations are plausible, but not real: the emulation runs as
    fast as the host allows, there is no real-time pacing. Every planar write to A0000-AFFFF takes
    one count; a rep stos that writes the planar window with the plain write mode is emulated in one
    step, with the same total of counts (_rep, off with rep_fast). In the packed modes the window is
    plain shadow RAM (the access hooks are off there, see _vhooks) and its writes are charged in bulk
    when the page leaves the screen (_remap), as a dword-clear of the 64 KB page, so loops that write
    video memory until a tick passes come to an end.
  - A small DOS (INT 21h) for .COM and .EXE programs (MZ header with relocations, run_exe): console and
    file output, create/close, IOCTL, InDOS, get/set vector, version, PSP (51h/62h), memory blocks
    (48h-4Ah, with MCBs in front of the environment and the program; 49h and the exit free a block, 31h
    keeps DX paragraphs, and a free block links a resident program to the next one, so the MCB chain
    can be walked), list of lists (52h, the lowest MCB),
    allocation strategy and UMB link (58h, no UMBs), country (38h), date/time (zero), Ctrl-Break,
    default drive, commit, terminate and stay resident. INT 21h goes through the vector table to a stub
    at 0050:0020, so a program that hooks INT 21h (for example a TSR that stays resident when its own
    AH=4Ch passes its hook) sees its own calls. INT 16h returns keys from a queue (Enter when empty);
    INT 15h AH=87h reports "not supported".
  - Video memory: the card's 1, 2 or 4 MB (Machine.vram) in one bytearray (vram), seen through the
    64 KB window at A0000-AFFFF. The window's 64 KB page is CR6A bits 5-0, or when they are 0, CR35
    bits 3-0 with CR51 bits 3-2 as bits 5-4, and only with CR31 bit 0 set (Trio64V+ data book, CR31,
    CR35, CR51, CR6A); the same page applies to a 64 KB linear window at A0000h (CR58 bit 4, size
    64 KB, CR59/CR5A = 000Ah). In the packed modes the window holds bytes page x 64 KB onward; in the
    16-colour and unchained modes (chain-4 and odd/even off, A0000 mapped) the four planes are the
    interleaved bytes of the same memory (plane p, address a is vram[4a + p], so a mode 13h byte at A
    is plane A AND 3 at address A / 4) and the window's plane address starts at page x 16 KB, with the
    plane logic: map mask, read map, bit mask, set/reset, latches, write modes 0-2, read modes 0 and 1.
    With linear addressing on at another base (CR58 bit 4) the window at A0000 is off: writes are
    lost and reads give FFh, as on the chip. B0000-BFFFF (text modes, CGA, MDA) is plain RAM.
What is not emulated (results that depend on it are meaningless here)
  - The linear frame buffer at the CR59/CR5A base (INT 15h AH=87h reports "not supported"), so memory
    tests through the LFB fail. Video memory itself is modelled (below).
  - The graphics engine (ports 82E8h-BEE8h): commands written to 9AE8h are counted (ge_cmds), not
    executed. The Trio64 BIOS 1.4 clears video memory with it, so its mode sets clear nothing here.
  - Real timing: CPU speed, bus waits and monitor behaviour. Durations come from the virtual clock.
  - Equipment-dependent BIOS state (AH=1Bh +26h alternate display, +2Dh flags).

Usage (see tests.py for complete examples)
  m = Machine(open('S3V2P15.BIN','rb').read())
  m.post()
  m.int10(0x0003); print(m.snapshot())         # registers after a mode set
  r = m.run_com(open('build/S3TEST.COM','rb').read(), '/V')
  print(r.stdout.decode('latin1'), r.files.get('S3TEST.DBG'))
"""
import copy
import struct
import sys
try:
    import unicorn  # noqa: F401
except ImportError:
    sys.exit('The emulator needs the unicorn package. Install it with: python3 -m venv .venv && '
             '.venv/bin/pip install .   (or: pip install unicorn), see pyproject.toml')
from unicorn import Uc, UcError, UC_ARCH_X86, UC_MODE_16, UC_HOOK_INTR, UC_HOOK_INSN, UC_HOOK_MEM_READ, \
    UC_HOOK_MEM_WRITE, UC_HOOK_BLOCK, UC_HOOK_CODE
from unicorn.x86_const import *

REGNAMES = ['MISC', 'FEAT', 'SR0', 'SR1', 'SR2', 'SR3', 'SR4'] + ['CR%02X' % i for i in range(25)] + \
           ['AR%02X' % i for i in range(21)] + ['GR%02X' % i for i in range(9)]

# PCI configuration header of the card as read on the real hardware (VSHOW /V log): 5333:8901,
# command 0003, class 030000, IRQ 10. BAR0 (E0000000 on the card) is read from CR59/CR5A, which the
# Trio64 uses as the BAR.
PCI_CONFIG = {0x00: 0x89015333, 0x04: 0x02000003, 0x08: 0x03000006,
              0x2C: 0x89015333, 0x3C: 0x0000010A}

# The chips of the Trio64 family the model can be: PCI device ID, the ID registers CR2D/CR2E/CR2F
# (CR2F = PCI revision) and CR30, and the DCLK PLL post divider: 2 bits (SR12 bits 6-5) on the
# Trio32/64/V+, 3 bits with SR12 bit 7 on the Trio64V2. Datasheets: device 8811 for the Trio32 and
# Trio64 (CR2E 10h / 11h) and the Trio64V+ (CR2E 11h, CR2F 4xh, later steppings 5xh); 8901 is the Trio64V2/DX/GX; 8814 the
# Trio64UV+ (CR2E 14h, revision "xxH": 00h here; CR30 unchanged from the Trio64V+, E1h).
CHIPS = {
    'v2':     dict(name='Trio64V2/DX', dev=0x8901, ids=(0x89, 0x01, 0x06, 0xE1), r3=True),
    'vplus':  dict(name='Trio64V+', dev=0x8811, ids=(0x88, 0x11, 0x40, 0xE1), r3=False),
    'trio64': dict(name='Trio64', dev=0x8811, ids=(0x88, 0x11, 0x00, 0xE1), r3=False),
    'trio32': dict(name='Trio32', dev=0x8811, ids=(0x88, 0x10, 0x00, 0xE1), r3=False),
    'uvplus': dict(name='Trio64UV+', dev=0x8814, ids=(0x88, 0x14, 0x00, 0xE1), r3=False),
}
# The chip codes the command lines take (--chip, CHIP=): the S3 part numbers, mapped to the CHIPS keys.
# 764X and 764P are one model apart from CR2F: the 764X model reports 20h, the GS part of the
# DSP-3364P ("86C764GSpnp"), the 764P model 00h, a value S3's Windows 95 driver gives no pnp code
# (docs/764-rom.md "Chip variants by CR2F"); the PCI revision stays 00h on both (T64-ID-1, T64-ID-2).
CHIP_CODES = {'775': 'v2', '765': 'vplus', '764': 'trio64', '764x': 'trio64', '764p': 'trio64',
              '767': 'uvplus', '732': 'trio32'}
CHIP_CR2F = {'764': 0x20, '764x': 0x20, '764p': 0x00}     # CR2F where it is not the PCI revision


def chip_ids():
    """CR2D, CR2E, CR2F and CR30 of the model's chip: CHIPS' ids, with CR2F from Machine.cr2f when set."""
    c = CHIPS[Machine.chip]['ids']
    return (c[0], c[1], c[2] if Machine.cr2f is None else Machine.cr2f, c[3])

IRET_SEG = 0x0060          # every unused vector points to 0060:0000 = IRET
DOS_STUB = 0x0520          # INT 21h vector 0050:0020: INT F1h (the emulated DOS), RETF 2 (keeps its flags)
MEM_TOP = 0x9000           # first segment after conventional memory available to programs
STUB = 0x7C00              # small code stubs (POST far call, INT 10h call) live here


def budget_msg(what, limit, knob, where):
    """The message for a run that the emulator stopped because its instruction count ran out. Unicorn
    stops at the count either way, so a hang and a call that only needs more instructions (a 4 MB clear
    traced by VGALOG, for example) look the same: the message says which budget, and where it stopped."""
    return ('instruction budget exceeded: %s did not finish within %d instructions (%s); stopped at %s, '
            'a hang or a run that needs a larger budget' % (what, limit, knob, where))


class ComResult:
    def __init__(self):
        self.stdout = bytearray()      # handle 1 and console output (AH=02h/09h)
        self.stderr = bytearray()      # handle 2
        self.files = {}                # created files: name -> bytes written
        self.exit = None               # ('exit', code), ('tsr', code, paragraphs), ('error', text), ('budget', text)
        self.dos_calls = set()         # (AH) values seen
        self.synced = set()            # files DOS was asked to put on disk after their last write: a
                                       # commit of its handle (AH=68h) or a disk reset (AH=0Dh); a
                                       # close alone may leave them in DOS's buffers or a write-behind
                                       # cache, lost at a reset (#158)


class _Plane:
    """One VGA plane as a view on the interleaved video memory: address a of plane p is vram[4a + p]."""
    def __init__(self, vram, p):
        self.v, self.p = vram, p

    def __len__(self):
        return len(self.v) // 4

    def _sl(self, i):
        start, stop, step = i.indices(len(self))
        if step != 1:
            raise ValueError('plane slices take no step')
        return slice(4 * start + self.p, 4 * stop + self.p if stop > start else 4 * start + self.p, 4)

    def __getitem__(self, i):
        if isinstance(i, slice):
            return bytes(self.v[self._sl(i)])
        return self.v[4 * i + self.p]

    def __setitem__(self, i, val):
        if isinstance(i, slice):
            self.v[self._sl(i)] = bytes(val)
        else:
            self.v[4 * i + self.p] = val

    def __bytes__(self):
        return bytes(self.v[self.p::4])

    def __iter__(self):
        return iter(self.v[self.p::4])


# The rep stos opcodes the planar fast path of Machine._rep knows (16-bit mode: the count is CX, the
# offset wraps at 64 KB), as (opcode bytes, (op, operand size)). F2h (repne) repeats stos like F3h does;
# 66h in front of or between the prefix and the opcode makes the operand a dword. The rep movs
# opcodes are left out: they are a negligible share of the planar accesses, so they keep running one
# Unicorn iteration at a time. 67h (address size) is not included either: it changes count and wrap.
_REP_OPS = {b'\xf3\xaa': ('stos', 1), b'\xf3\xab': ('stos', 2), b'\xf2\xaa': ('stos', 1),
            b'\xf2\xab': ('stos', 2)}
for _pat, (_op, _sz) in list(_REP_OPS.items()):
    _REP_OPS[b'\x66' + _pat] = _REP_OPS[_pat[:1] + b'\x66' + _pat[1:]] = (_op, 4)
# prefixes that can stand in front of the patterns (a pattern behind one starts mid-instruction)
_REP_PREFIXES = frozenset((0x26, 0x2E, 0x36, 0x3E, 0x64, 0x65, 0x66, 0x67, 0xF0, 0xF2, 0xF3))
_REP_SCAN = (None, {})                          # Machine._repscan's cache: (ROM image, its scan)


class Machine:
    def __init__(self, rom, keys=None):
        self.rom = rom
        mu = self.mu = Uc(UC_ARCH_X86, UC_MODE_16)
        mu.mem_map(0, 0x110000)
        mu.mem_write(0xC0000, rom)
        mu.mem_write(IRET_SEG * 16, b'\xCF')
        mu.mem_write(0xFF065, b'\xCF')                 # system BIOS video entry F000:F065 (INT 42h)
        for v in range(256):
            mu.mem_write(v * 4, struct.pack('<HH', 0, IRET_SEG))
        mu.mem_write(DOS_STUB, b'\xCD\xF1\xCA\x02\x00')
        mu.mem_write(0x21 * 4, struct.pack('<HH', DOS_STUB - 0x500, 0x0050))
        mu.mem_write(0x410, struct.pack('<H', 0x0020))  # equipment: 80x25 colour
        mu.mem_write(0x413, struct.pack('<H', 640))
        self.r = {'seq': {}, 'crtc': {}, 'gc': {}, 'atc': {}, 'misc': 0x67, 'feat': 0, 'si': 0, 'ci': 0,
                  'gi': 0, 'ai': 0, 'aff': 0, 'dac_w': 0, 'dac_c': 0, 'dac_r': 0, 'dac_rc': 0, 'pci': 0,
                  'st': 0, 'p61': 0}
        # PIT channels: reload value, mode, time it was loaded, latched value, byte flip-flop
        self.pit = {0x40: {'reload': 0, 'mode': 3, 't0': 0, 'latch': None, 'ff': 0, 'wff': 0},
                    0x42: {'reload': 0, 'mode': 3, 't0': 0, 'latch': None, 'ff': 0, 'wff': 0}}
        self.t = 0                                      # virtual clock in PIT counts
        self.tick_base = 0                              # BIOS ticks counted before channel 0 was reloaded
        # the system BIOS has assigned BAR0 = E0000000 before the video ROM starts; on the Trio64 the
        # BAR is CR59/CR5A (the linear frame buffer base)
        self.r['crtc'][0x59] = 0xE0
        self.r['crtc'][0x5A] = 0x00
        self.dac = [[0, 0, 0] for _ in range(256)]
        # Fault injection for the tests of S3COMPAT's DAC retry (t_s3compat_dac_retry): None, or a dict
        # op 'r' (a 3C9h read returns value ^ xor) or 'w' (a 3C9h write is dropped, the entry keeps its
        # old component), entry, comp (0-2), value (the value read or written that triggers it) and
        # count (times it acts; None = every time). Real cards showed one wrong DAC byte once per run.
        self.dac_fault = None
        self.keys = list(keys or [])
        self.com = None                                 # ComResult while a .COM runs
        self.handles = {}
        mu.hook_add(UC_HOOK_INTR, self._intr)
        mu.hook_add(UC_HOOK_INSN, self._in, None, 1, 0, UC_X86_INS_IN)
        mu.hook_add(UC_HOOK_INSN, self._out, None, 1, 0, UC_X86_INS_OUT)
        mu.hook_add(UC_HOOK_MEM_READ, self._tread, None, 0x46C, 0x46D)
        # the A0000-BFFFF access hooks exist only while the window is planar (_vhooks); it starts
        # packed, where the shadow RAM at A0000 is plain memory and a hook per access would only
        # cost time
        self.h_vw = self.h_vr = None
        self.h_reps = []                          # the rep stos block hooks (see _rephooks)
        self._reps = {}                           # the ROM image's rep stos (see _repscan)
        self.rep_fast = True                      # the rep stos fast path (_rep); off for t_stores
        self.vram = bytearray(Machine.vram << 20)     # the card's video memory (see the module docstring)
        self.win = ('packed', 0)                        # what A0000-AFFFF shows now: (kind, page base)
        self.ge_cmds = 0                                # graphics engine commands written to 9AE8h
        self.bee8 = set()                               # BEE8h indexes written (bits 15-12 of the word)
        self.ge_first = None                            # the BEE8h indexes written before the first command
        # write log for the datasheet rules that concern writes (docs/chip-rules.md): None = off, else a
        # list of (reg, index, value, old value, SR01, in vertical retrace, CR39), reg 'SR' or 'CR'
        self.wlog = None
        self.latch = [0, 0, 0, 0]
        self._wcfg_cache = None                         # decoded GC/SR state of _vwrite, None when stale
        self._frame_cache = None                        # frame() of _retrace, None when registers changed

    # ------------------------------------------------------------------ ports
    # ------------------------------------------------------------------ virtual clock
    def frame(self, xres=None):
        """Timing the programmed registers define: (Hz, pixels per line, frame period in PIT counts,
        total lines). Hz is None when the clock source is unknown. Same rules as S3COMPAT's predict."""
        r = self.r
        seq, cr = r['seq'], r['crtc']
        csel = (r['misc'] >> 2) & 3
        if csel == 0:
            clk = 25175e3
        elif csel == 1:
            clk = 28322e3
        elif csel == 3:
            n, m = seq.get(0x12, 0), seq.get(0x13, 0)
            rr = ((n >> 5) & 3) | (4 if n & 0x80 and CHIPS[Machine.chip]['r3'] else 0)
            clk = 14318180.0 * ((m & 0x7F) + 2) / (((n & 0x1F) + 2) * (1 << rr))
        else:
            return None, None, 19886, 525
        if seq.get(1, 0) & 8:
            clk /= 2
        if csel == 3 and seq.get(0x15, 0) & 0x10:
            clk /= 2
        cw = 8 if seq.get(1, 0) & 1 else 9
        htot = cr.get(0, 0) + (256 if cr.get(0x5D, 0) & 1 else 0) + 5
        hdisp = cr.get(1, 0) + (256 if cr.get(0x5D, 0) & 2 else 0) + 1
        c7 = cr.get(7, 0)
        vtot = cr.get(6, 0) + (256 if c7 & 1 else 0) + (512 if c7 & 0x20 else 0) + \
            (1024 if cr.get(0x5E, 0) & 1 else 0) + 2
        hz = clk / (htot * cw * vtot)
        cmode = cr.get(0x67, 0) >> 4
        if csel == 3:
            if cmode in (1, 3, 5):
                hz *= 2
            elif cmode == 0 and (seq.get(0x0B, 0) & 0xF0) == 0x70:
                hz /= 2
        pix = round(xres * htot / hdisp) if xres else htot * cw
        return hz, pix, max(1000, round(1193182 / hz)), vtot

    def _retrace(self):
        """Vertical retrace bit from the virtual clock: on for about 3 lines at the start of each frame.
        The frame timing is cached until a VGA register write (see _out): polling loops read 3DAh
        thousands of times without the registers changing."""
        f = self._frame_cache
        if f is None:
            f = self._frame_cache = self.frame()
        period, vtot = f[2], f[3]
        return (self.t % period) < max(60, period * 3 // max(vtot, 1))

    def _pit_count(self, ch):
        p = self.pit[ch]
        reload = p['reload'] or 0x10000
        el = self.t - p['t0']
        if p['mode'] == 3:                              # square wave counts down by 2
            return (reload - (2 * el) % reload) & 0xFFFF
        return (reload - el % reload) & 0xFFFF

    def _ci(self):
        """The CRTC register the index in 3D4h/3B4h selects. The Trio32/Trio64 decode index bits 6-0 only:
        on the DSP-3364P (Trio64) CR80-CRFF read back as CR00-CR7F (S3REGS, 31 October 2026), so CR90 is
        CR10 there (#72). The later chips have registers above 7Fh (CR80-CR93 on the Trio64V2)."""
        i = self.r['ci']
        return i & 0x7F if Machine.chip in ('trio64', 'trio32') else i

    def _dac_hit(self, op, entry, comp, value):
        """True when [dac_fault] acts on this DAC access (and counts it down)."""
        f = self.dac_fault
        if not f or f['op'] != op or (f['entry'], f['comp'], f['value']) != (entry, comp, value):
            return False
        if f['count'] is not None:
            if f['count'] <= 0:
                return False
            f['count'] -= 1
        f['hits'] = f.get('hits', 0) + 1
        return True

    def _in(self, uc, port, size, ud):
        r = self.r
        self.t += 3                                     # about one ISA I/O cycle
        if port == 0x3C5:
            if r['si'] == 0x17:                         # SR17 clock synthesizer test counter: it runs (the
                r['sr17'] = (r.get('sr17', 0) + 1) & 0xFF  # Trio64/V+ BIOS waits for it to change after
                return r['sr17']                        # a PLL reset at POST)
            v = r['seq'].get(r['si'], 0)
            return v & 0xFE if r['si'] == 4 else v      # SR04 bit 0 is reserved and reads 0
        if port in (0x3B4, 0x3B5, 0x3BA) and r['misc'] & 1:
            return 0xFF                                 # colour I/O: the mono ports are not decoded
        if port in (0x3D4, 0x3D5, 0x3DA) and not r['misc'] & 1:
            return 0xFF
        if port in (0x3D5, 0x3B5):
            i = self._ci()
            # CR36 bits 7-5 = the memory size (110b 1 MB, 100b 2 MB, 000b 4 MB); bits 3-2 the memory type:
            # 1-cycle EDO (00b) on the Trio64V2/V+ models, EDO (10b) on the Trio32/Trio64, whose 00b is
            # reserved, and fast page (11b) on the Trio64 with 4 MB, which the data book requires for it
            # (pin 50 as RAS1, T64-MEM-3; tests.py --vram 4 by hand only, make emu-test and CI stop at
            # 2 MB on the Trio64; the Trio32 takes at most 2 MB)
            c = chip_ids()
            cr36 = {1: 0xD2, 2: 0x92, 4: 0x12}[Machine.vram]
            if Machine.chip in ('trio64', 'trio32'):
                cr36 |= 0x0C if Machine.vram == 4 else 0x08
            fixed = {0x2D: c[0], 0x2E: c[1], 0x2F: c[2], 0x30: c[3], 0x36: cr36}
            return fixed.get(i, r['crtc'].get(i, 0))
        if port == 0x3CF: return r['gc'].get(r['gi'], 0)
        if port == 0x3C1: return r['atc'].get(r['ai'] & 0x1F, 0)
        if port == 0x3C0: return r['ai']
        if port == 0x3CC: return r['misc']
        if port == 0x3CA: return r['feat']
        if port == 0x3C2: return 0x10
        if port in (0x3DA, 0x3BA):
            self.t += 22                                # polling loops: keep the run time short
            r['aff'] = 0
            r['st'] ^= 0x01                             # display enable toggles
            return (r['st'] & 0x01) | (0x08 if self._retrace() else 0)
        if port == 0x3C9:
            v = self.dac[r['dac_r']][r['dac_rc']]
            if self._dac_hit('r', r['dac_r'], r['dac_rc'], v):
                v ^= self.dac_fault['xor']
            r['dac_rc'] += 1
            if r['dac_rc'] == 3:
                r['dac_rc'] = 0
                r['dac_r'] = (r['dac_r'] + 1) & 255
            return v
        if port == 0x3C6: return r.get('pel', 0xFF)        # DAC pixel mask (AX=1018h/1019h)
        if port == 0x3C7: return r.get('dac_st', 0)     # DAC state: 3 after a read index, 0 after a write index
        if port == 0x3C4: return r['si']
        if port in (0x3D4, 0x3B4): return r['ci']
        if port == 0x3CE: return r['gi']
        if port in (0x40, 0x42):
            p = self.pit[port]
            if p['latch'] is None:
                p['latch'] = self._pit_count(port)
            v = (p['latch'] >> (8 * p['ff'])) & 0xFF
            p['ff'] ^= 1
            if p['ff'] == 0:
                p['latch'] = None
            return v
        if port == 0x20:                                # PIC IRR/ISR: nothing pending, the model counts
            return 0                                    # the BIOS tick at once (_ticks)
        if port == 0x61:
            r['p61'] ^= 0x30
            return r['p61']
        if port == 0xCF8 and size == 4:
            return r['pci']
        if 0xCFC <= port <= 0xCFF:                      # PCI config data, any device answers as the card
            reg = r['pci'] & 0xFC
            if reg == 0x10:                             # BAR0 is CR59/CR5A on the Trio64
                cfg = (r['crtc'].get(0x59, 0) << 24) | (r['crtc'].get(0x5A, 0) << 16)
            else:
                cfg = self._pci_cfg(reg)
            v = cfg >> (8 * (port - 0xCFC))
            return v & {1: 0xFF, 2: 0xFFFF, 4: 0xFFFFFFFF}[size]
        return 0xFF if size == 1 else 0xFFFF

    def _out(self, uc, port, size, val, ud):
        r = self.r
        if port == 0x9AE8:                              # a graphics engine command: not modelled (a BIOS
            if self.ge_cmds == 0:                       # that clears memory with it leaves it as it was)
                self.ge_first = set(self.bee8)
            self.ge_cmds += 1
        if port == 0xBEE8 and size >= 2:
            self.bee8.add((val >> 12) & 0xF)
        elif port == 0xBEE9 and size == 1:
            self.bee8.add((val >> 4) & 0xF)

        def w8(p, v):
            self._frame_cache = None                    # a VGA register write: retrace timing may change
            if p in (0x3B4, 0x3B5, 0x3BA) and r['misc'] & 1:
                return                                  # colour I/O: the mono ports are not decoded
            if p in (0x3D4, 0x3D5, 0x3DA) and not r['misc'] & 1:
                return
            if p in (0x3D5, 0x3B5) and self._ci() <= 7 and r['crtc'].get(0x11, 0) & 0x80:
                if self._ci() == 7:                        # CR11 bit 7 protects CR00-07 except CR07 bit 4
                    r['crtc'][7] = (r['crtc'].get(7, 0) & ~0x10) | (v & 0x10)
                return
            if self.wlog is not None and p in (0x3C5, 0x3D5, 0x3B5):
                reg, i, regs = ('SR', r['si'], r['seq']) if p == 0x3C5 else ('CR', self._ci(), r['crtc'])
                self.wlog.append((reg, i, v, regs.get(i, 0), r['seq'].get(1, 0), self._retrace(),
                                  r['crtc'].get(0x39, 0)))
            if p == 0x3C4: r['si'] = v
            elif p == 0x3C5:
                r['seq'][r['si']] = v
                self._wcfg_cache = None
                if r['si'] == 4:
                    self._remap()
            elif p in (0x3D4, 0x3B4): r['ci'] = v
            elif p in (0x3D5, 0x3B5):
                r['crtc'][self._ci()] = v
                if self._ci() in self.WINDOW_CR:
                    self._remap()
            elif p == 0x3CE: r['gi'] = v
            elif p == 0x3CF:
                r['gc'][r['gi']] = v
                self._wcfg_cache = None
                if r['gi'] == 6:
                    self._remap()
            elif p == 0x3C0:
                if r['aff'] == 0: r['ai'] = v
                else: r['atc'][r['ai'] & 0x1F] = v
                r['aff'] ^= 1
            elif p == 0x3C2: r['misc'] = v
            elif p == 0x3C6: r['pel'] = v
            elif p in (0x3DA, 0x3BA): r['feat'] = v
            elif p == 0x3C8:
                r['dac_w'] = v
                r['dac_st'] = 0
                r['dac_c'] = 0
            elif p == 0x3C7:
                r['dac_r'] = v
                r['dac_st'] = 3
                r['dac_rc'] = 0
            elif p == 0x3C9:
                if not self._dac_hit('w', r['dac_w'], r['dac_c'], v & 0x3F):
                    self.dac[r['dac_w']][r['dac_c']] = v & 0x3F
                r['dac_c'] += 1
                if r['dac_c'] == 3:
                    r['dac_c'] = 0
                    r['dac_w'] = (r['dac_w'] + 1) & 255
        self.t += 2
        if port == 0xCF8:
            r['pci'] = val
            return
        if port == 0x43:                                # PIT control word
            ch = {0x00: 0x40, 0x80: 0x42}.get(val & 0xC0)
            if ch is None:
                return
            p = self.pit[ch]
            if val & 0x30 == 0:                         # counter latch
                p['latch'] = self._pit_count(ch)
                p['ff'] = 0
            else:
                p['mode'] = (val >> 1) & 7
                p['wff'] = 0
                p['latch'] = None
                p['ff'] = 0
            return
        if port in (0x40, 0x42):
            p = self.pit[port]
            if p['wff'] == 0:
                p['reload'] = (p['reload'] & 0xFF00) | (val & 0xFF)
            else:
                if port == 0x40:                        # the tick keeps counting across a reload
                    self.tick_base = self._ticks()
                p['reload'] = (p['reload'] & 0x00FF) | ((val & 0xFF) << 8)
                p['t0'] = self.t
            p['wff'] ^= 1
            return
        if size == 1:
            w8(port, val & 0xFF)
        else:
            w8(port, val & 0xFF)
            w8(port + 1, (val >> 8) & 0xFF)

    def _planar(self):
        """16-colour and unchained 256-colour modes: chain-4 off, odd/even off, A0000 64 KB window."""
        sr4 = self.r['seq'].get(4, 0)
        return not sr4 & 0x08 and sr4 & 0x04 and (self.r['gc'].get(6, 0) >> 2) & 3 == 1

    WINDOW_CR = (0x31, 0x35, 0x51, 0x58, 0x59, 0x5A, 0x6A)

    def _wkey(self):
        """What the window A0000-AFFFF shows (module docstring): ('packed', byte offset), ('planar', plane
        address) or ('off', 0) when linear addressing is on at another base than A0000h."""
        cr = self.r['crtc']
        if cr.get(0x58, 0) & 0x10 and not (cr.get(0x58, 0) & 3 == 0 and cr.get(0x59, 0) == 0
                                           and cr.get(0x5A, 0) == 0x0A):
            return ('off', 0)
        page = 0
        if cr.get(0x31, 0) & 1:                         # CR31 bit 0: the base address offset is on
            page = cr.get(0x6A, 0) & 0x3F or ((cr.get(0x35, 0) & 0x0F) | ((cr.get(0x51, 0) >> 2) & 3) << 4)
        if self._planar():
            return ('planar', page * 0x4000)
        return ('packed', page * 0x10000)

    def sync(self):
        """Write what the packed window holds back into vram (the window is plain RAM for speed)."""
        kind, base = self.win
        if kind == 'packed':
            data = self.mu.mem_read(0xA0000, 0x10000)
            n = len(self.vram)
            base %= n
            self.vram[base:base + 0x10000] = data[:n - base]

    def _vhooks(self, on):
        """The A0000-BFFFF access hooks, on only while the window is planar. In a packed window the
        shadow RAM at A0000 is plain memory, so the hooks would only add a Python call per access
        (and one virtual-clock count per write); in an off window the FFh fill of _remap already
        makes reads return FFh."""
        if on and self.h_vw is None:
            self.h_vw = self.mu.hook_add(UC_HOOK_MEM_WRITE, self._vwrite, None, 0xA0000, 0xBFFFF)
            self.h_vr = self.mu.hook_add(UC_HOOK_MEM_READ, self._vread, None, 0xA0000, 0xAFFFF)
            self._rephooks(True)
        elif not on and self.h_vw is not None:
            self.mu.hook_del(self.h_vw)
            self.mu.hook_del(self.h_vr)
            self.h_vw = self.h_vr = None
            self._rephooks(False)

    def _repscan(self):
        """The ROM image's rep stos instructions for _rep: offset in the image mapped to
        (opcode bytes, operand size). A byte scan finds the patterns also where they are not
        instruction boundaries; such an address is never executed at, and _rep checks the bytes
        again before it acts. A pattern with another prefix in front (a segment override, 67h) is
        left out: the instruction would start earlier and behave differently."""
        global _REP_SCAN
        if _REP_SCAN[0] == self.rom:
            return _REP_SCAN[1]
        reps = {}
        rom = self.rom
        for pat, (_op, sz) in _REP_OPS.items():
            o = rom.find(pat)
            while o >= 0:
                if o == 0 or rom[o - 1] not in _REP_PREFIXES:
                    reps[o] = (pat, 4 if b'\x66' in pat else sz)
                o = rom.find(pat, o + 1)
        _REP_SCAN = (rom, reps)
        return reps

    def _rephooks(self, on):
        """Block hooks at the ROM's rep stos instructions (see _rep), on only while the window is
        planar: always on, every iteration of every rep in the ROM would pay a Python call, also in
        the packed modes, where the string writes are plain memory. Unicorn translates a rep into the
        block that leads into it plus a block of its own for the iterations, so the hook at its
        address fires once per execution, after the first iteration. The blocks that contain the
        instructions are dropped when the hooks change, because a hook takes effect only in a block
        translated after it was added (as _noop_hook does)."""
        if on and not self.h_reps and self.rep_fast:
            self._reps = self._repscan()
            self.h_reps = [self.mu.hook_add(UC_HOOK_BLOCK, self._rep, None, 0xC0000 + o, 0xC0000 + o)
                            for o in self._reps]
            self.mu.ctl_remove_cache(0xC0000, 0xD0000)
        elif not on and self.h_reps:
            for h in self.h_reps:
                self.mu.hook_del(h)
            self.h_reps = []
            self.mu.ctl_remove_cache(0xC0000, 0xD0000)

    def _rep(self, uc, addr, size, ud):
        """At a rep stos of the ROM while the window is planar: when the rest of the string operation
        writes the window with the plain write mode (write mode 0, no rotate, no set/reset, bit mask
        FFh - the mode set's clears, which dominate the planar accesses of S3COMPAT /Q), emulate it
        in bulk, one strided slice per plane and run of bytes, instead of one Unicorn slow path and
        Python callback per iteration (about 4 us each). The virtual clock is charged the same total
        (one count per write, as _vwrite). Anything else (another write mode, another segment, DF
        set) is left to Unicorn, which runs it per iteration as before. A rep cannot hang by itself
        (CX bounds it), so skipping its iterations weakens no hang detection that a budget needs."""
        if self.win[0] != 'planar':
            return
        pat, osize = self._reps[addr - 0xC0000]
        if uc.reg_read(UC_X86_REG_ES) != 0xA000 or uc.reg_read(UC_X86_REG_EFLAGS) & 0x400:
            return                                              # DF set: backwards, leave it to Unicorn
        mode, mask, sr_en, sr_val, mapmask, rot, fn = self._wcfg()
        if mode or rot or fn or mask != 0xFF or sr_en or not mapmask:
            return
        if bytes(uc.mem_read(addr, len(pat))) != pat:           # the ROM image is plain RAM here
            return
        ecx, edi = uc.reg_read(UC_X86_REG_ECX), uc.reg_read(UC_X86_REG_EDI)
        n = ecx & 0xFFFF
        data = (uc.reg_read(UC_X86_REG_EAX) & (1 << (8 * osize)) - 1).to_bytes(osize, 'little') * n
        base, psize, vm = self.win[1], len(self.vram) // 4, self.vram
        total, b = n * osize, 0
        while b < total:
            w = (edi + b) & 0xFFFF
            s = (base + w) % psize
            L = min(total - b, 0x10000 - w, psize - s)
            chunk = data[b:b + L]
            for p in range(4):
                if mapmask & (1 << p):
                    vm[4 * s + p:4 * s + p + 4 * L - 3:4] = chunk
            b += L
        self.t += n
        uc.reg_write(UC_X86_REG_ECX, ecx & 0xFFFF0000)
        uc.reg_write(UC_X86_REG_EDI, (edi + n * osize) & 0xFFFF | edi & 0xFFFF0000)
        uc.reg_write(UC_X86_REG_EIP, uc.reg_read(UC_X86_REG_EIP) + len(pat))

    def _remap(self):
        """After a register write that can move the window: keep the old page, show the new one."""
        k = self._wkey()
        if k == self.win:
            return
        if self.win[0] == 'packed':
            self.t += 0x4000        # the packed page on screen was written through: charge its writes
        self.sync()                 # in bulk, as a dword-clear of the page (the hooks are off, _vhooks)
        kind, base = k
        if kind == 'packed':
            n = len(self.vram)
            base %= n
            self.mu.mem_write(0xA0000, bytes(self.vram[base:base + 0x10000]).ljust(0x10000, b'\0'))
        elif kind == 'off':
            self.mu.mem_write(0xA0000, b'\xff' * 0x10000)
        self.win = k
        self._vhooks(kind == 'planar')

    @property
    def planes(self):
        """The four planes as views on vram (after sync, so a packed window's bytes are in)."""
        self.sync()
        return [_Plane(self.vram, p) for p in range(4)]

    @planes.setter
    def planes(self, data):
        self.sync()
        for p, d in enumerate(data):
            self.vram[p:p + 4 * len(d):4] = bytes(d)
        if self.win[0] == 'packed':
            self.win = ('none', 0)
            self._remap()

    def _wcfg(self):
        """The decoded graphics-controller/sequencer state the planar writes use, cached until a GC or
        SR register is written (see _out): (write mode, bit mask, set/reset enable, set/reset value,
        map mask, rotate count, rotate function)."""
        c = self._wcfg_cache
        if c is None:
            gc, sr = self.r['gc'], self.r['seq']
            g3 = gc.get(3, 0)
            c = self._wcfg_cache = (gc.get(5, 0) & 3, gc.get(8, 0xFF), gc.get(1, 0), gc.get(0, 0),
                                    sr.get(2, 0x0F), g3 & 7, (g3 >> 3) & 3)
        return c

    def _vwrite(self, uc, acc, addr, size, val, ud):
        self.t += 1                                     # video memory writes take time too
        if addr >= 0xB0000 or self.win[0] != 'planar':
            return
        mode, mask, sr_en, sr_val, mapmask, rot, fn = self._wcfg()
        base, psize, vm = self.win[1], len(self.vram) // 4, self.vram
        if mode == 0 and fn == 0 and rot == 0 and mask == 0xFF and not sr_en:
            # the common case (the mode set clears, plane writes): every mapped plane gets the CPU byte
            for k in range(size):
                o = 4 * ((base + ((addr + k) & 0xFFFF)) % psize)
                cpu = (val >> (8 * k)) & 0xFF
                if mapmask == 0x0F:
                    vm[o:o + 4] = bytes((cpu,) * 4)
                else:
                    for p in range(4):
                        if mapmask & (1 << p):
                            vm[o + p] = cpu
            return
        latch = self.latch
        for k in range(size):
            off = (base + ((addr + k) & 0xFFFF)) % psize
            cpu = (val >> (8 * k)) & 0xFF
            if rot:
                cpu = ((cpu >> rot) | (cpu << (8 - rot))) & 0xFF
            for p in range(4):
                if not mapmask & (1 << p):
                    continue
                if mode == 1:
                    d = latch[p]
                else:
                    if mode == 2:
                        d = 0xFF if cpu & (1 << p) else 0
                    elif sr_en & (1 << p):
                        d = 0xFF if sr_val & (1 << p) else 0
                    else:
                        d = cpu
                    if fn == 1:
                        d &= latch[p]
                    elif fn == 2:
                        d |= latch[p]
                    elif fn == 3:
                        d ^= latch[p]
                    d = (d & mask) | (latch[p] & ~mask & 0xFF)
                vm[4 * off + p] = d

    def _vread(self, uc, acc, addr, size, val, ud):
        """Before the CPU reads a planar address: load the latches and put the selected plane's bytes
        (read mode 0) or the colour compare result (read mode 1: GR02 colour, GR07 colour don't care)
        into RAM, so the read returns them."""
        if self.win[0] == 'off':
            uc.mem_write(addr, b'\xff' * size)
            return
        if self.win[0] != 'planar':
            return
        gc = self.r['gc']
        plane = gc.get(4, 0) & 3
        base, psize, vm = self.win[1], len(self.vram) // 4, self.vram
        cmode = gc.get(5, 0) & 0x08                     # read mode 1: colour compare
        ccol, cdc = gc.get(2, 0), gc.get(7, 0x0F)
        data = bytearray()
        for k in range(size):
            off = (base + ((addr + k) & 0xFFFF)) % psize
            self.latch = [vm[4 * off + p] for p in range(4)]
            if cmode:
                v = 0xFF
                for p in range(4):
                    if cdc & (1 << p):
                        v &= ~(self.latch[p] ^ (0xFF if ccol & (1 << p) else 0)) & 0xFF
                data.append(v)
            else:
                data.append(vm[4 * off + plane])
        uc.mem_write(addr, bytes(data))

    def _ticks(self):
        """BIOS ticks: one per channel 0 period (IRQ 0), in step with the channel 0 counter."""
        p = self.pit[0x40]
        return self.tick_base + (self.t - p['t0']) // (p['reload'] or 0x10000)

    def _tread(self, uc, acc, addr, size, val, ud):
        self.t += 40                                    # loops that wait for the tick move time on
        uc.mem_write(0x46C, struct.pack('<H', self._ticks() & 0xFFFF))

    # ------------------------------------------------------------------ interrupts
    def _reg(self, n):
        return self.mu.reg_read(n)

    def _intr(self, uc, n, ud):
        ah = (self._reg(UC_X86_REG_AX) >> 8) & 0xFF
        if n == 0xF1:                                   # the DOS stub behind the INT 21h vector
            if self.com is not None:
                self._dos(uc, ah)
            return
        if self.com is not None:
            if n == 0x20:
                self.com.exit = ('exit', 0)
                uc.emu_stop()
                return
            if n == 0x16:
                uc.reg_write(UC_X86_REG_AX, self.keys.pop(0) if self.keys else 0x1C0D)
                return
            if n == 0x15 and ah == 0x87:
                self._ret_cf(uc, 1, ax=0x8600)
                return
        if n == 0x1A and ah == 0xB1:
            self._pcibios(uc)
            return
        # real-mode INT through the IVT: push FLAGS, CS, IP (IP already points past the INT)
        ss = self._reg(UC_X86_REG_SS)
        sp = self._reg(UC_X86_REG_SP)
        fl = self._reg(UC_X86_REG_EFLAGS) & 0xFFFF
        cs = self._reg(UC_X86_REG_CS)
        ip = self._reg(UC_X86_REG_IP)
        sp = (sp - 6) & 0xFFFF
        uc.mem_write(ss * 16 + sp, struct.pack('<HHH', ip, cs, fl))
        uc.reg_write(UC_X86_REG_SP, sp)
        off, seg = struct.unpack('<HH', uc.mem_read(n * 4, 4))
        uc.reg_write(UC_X86_REG_EFLAGS, self._reg(UC_X86_REG_EFLAGS) & ~0x300)
        uc.reg_write(UC_X86_REG_CS, seg)
        uc.reg_write(UC_X86_REG_IP, off)

    def _pci_cfg(self, reg):
        """The PCI configuration dword at reg for the chip of the model (device ID and revision)."""
        c = CHIPS[Machine.chip]
        if reg == 0x00:
            return (c['dev'] << 16) | 0x5333
        if reg == 0x2C and Machine.chip == 'v2':
            # Trio64V2 subsystem IDs (datasheet section 3.8, docs/chip-rules.md V2-PCI-1): CR81-CR84, or
            # the ROM bytes C000:0040-0043 while CR37 bit 2 is 1 (the chip powers up with 1; the model
            # starts with CR37 = 00h, so only the copy to CR81-CR84 is seen here)
            cr = self.r['crtc']
            if cr.get(0x37, 0) & 0x04:
                return struct.unpack('<I', bytes(self.rom[0x40:0x44]))[0]
            return cr.get(0x81, 0) | cr.get(0x82, 0) << 8 | cr.get(0x83, 0) << 16 | cr.get(0x84, 0) << 24
        if reg == 0x2C:                                 # no subsystem ID register before the Trio64V2
            return 0
        if reg == 0x08:
            return 0x03000000 | c['ids'][2]
        return PCI_CONFIG.get(reg, 0)

    def _pci_read(self, reg):
        reg &= 0xFC
        if reg == 0x10:
            return (self.r['crtc'].get(0x59, 0) << 24) | (self.r['crtc'].get(0x5A, 0) << 16)
        return self._pci_cfg(reg)

    def _pcibios(self, uc):
        """PCI BIOS 2.1: the card is bus 0, device 9 (BX = 0048h), the only device."""
        al = self._reg(UC_X86_REG_AX) & 0xFF
        di = self._reg(UC_X86_REG_DI)
        ok = True
        if al == 0x01:
            uc.reg_write(UC_X86_REG_EDX, 0x20494350)    # 'PCI '
            uc.reg_write(UC_X86_REG_AX, 0x0001)          # mechanism 1
            uc.reg_write(UC_X86_REG_BX, 0x0210)
            uc.reg_write(UC_X86_REG_CX, 0)
            self._ret_cf(uc, 0)
            return
        if al == 0x02:                                  # find device CX, vendor DX, index SI
            ok = (self._reg(UC_X86_REG_DX), self._reg(UC_X86_REG_CX), self._reg(UC_X86_REG_SI)) == \
                (0x5333, CHIPS[Machine.chip]['dev'], 0)
        elif al == 0x03:                                # find class ECX, index SI
            ok = (self._reg(UC_X86_REG_ECX) & 0xFFFFFF) == 0x030000 and self._reg(UC_X86_REG_SI) == 0
        elif al in (0x08, 0x09, 0x0A):                  # read config byte/word/dword
            v = self._pci_read(di) >> (8 * (di & 3))
            v &= {0x08: 0xFF, 0x09: 0xFFFF, 0x0A: 0xFFFFFFFF}[al]
            mask = {0x08: 0xFF, 0x09: 0xFFFF, 0x0A: 0xFFFFFFFF}[al]
            uc.reg_write(UC_X86_REG_ECX, (self._reg(UC_X86_REG_ECX) & ~mask & 0xFFFFFFFF) | v)
        elif al in (0x0B, 0x0C, 0x0D):                  # writes: only BAR0 matters (CR59/CR5A)
            if di & 0xFC == 0x10 and al == 0x0D:
                v = self._reg(UC_X86_REG_ECX)
                self.r['crtc'][0x59] = (v >> 24) & 0xFF
                self.r['crtc'][0x5A] = (v >> 16) & 0xFF
                self._remap()
        else:
            ok = False
        if ok and al in (0x02, 0x03):
            uc.reg_write(UC_X86_REG_BX, 0x0048)
        ax = self._reg(UC_X86_REG_AX)
        uc.reg_write(UC_X86_REG_AX, (ax & 0x00FF) | (0 if ok else 0x8600))
        self._ret_cf(uc, 0 if ok else 1)

    def _ret_cf(self, uc, cf, ax=None):
        fl = self._reg(UC_X86_REG_EFLAGS)
        uc.reg_write(UC_X86_REG_EFLAGS, (fl | 1) if cf else (fl & ~1))
        if ax is not None:
            uc.reg_write(UC_X86_REG_AX, ax)

    def _dos(self, uc, ah):
        c = self.com
        c.dos_calls.add(ah)
        ax = self._reg(UC_X86_REG_AX)
        bx = self._reg(UC_X86_REG_BX)
        cx = self._reg(UC_X86_REG_CX)
        dx = self._reg(UC_X86_REG_DX)
        ds = self._reg(UC_X86_REG_DS)
        cf = 0
        es = self._reg(UC_X86_REG_ES)
        if ah == 0x02:
            c.stdout.append(dx & 0xFF)
        elif ah == 0x09:
            a = ds * 16 + dx
            while True:
                b = uc.mem_read(a, 1)
                if b == b'$': break
                c.stdout.extend(b)
                a += 1
        elif ah == 0x30:
            uc.reg_write(UC_X86_REG_AX, 0x1606)                 # DOS 6.22
        elif ah == 0x34:
            uc.reg_write(UC_X86_REG_ES, 0x0050)                 # InDOS flag at 0050:00F0, always 0
            uc.reg_write(UC_X86_REG_BX, 0x00F0)
        elif ah == 0x35:
            off, seg = struct.unpack('<HH', uc.mem_read((ax & 0xFF) * 4, 4))
            uc.reg_write(UC_X86_REG_BX, off)
            uc.reg_write(UC_X86_REG_ES, seg)
        elif ah == 0x25:
            uc.mem_write((ax & 0xFF) * 4, struct.pack('<HH', dx, ds))
        elif ah == 0x3C:
            name = bytes(uc.mem_read(ds * 16 + dx, 64)).split(b'\0')[0].decode('latin1').upper()
            h = 5 + len(self.handles)
            self.handles[h] = name
            c.files[name] = bytearray()
            uc.reg_write(UC_X86_REG_AX, h)
        elif ah == 0x3E:
            self.handles.pop(bx, None)
        elif ah == 0x40:
            data = bytes(uc.mem_read(ds * 16 + dx, cx))
            if bx == 1: c.stdout.extend(data)
            elif bx == 2: c.stderr.extend(data)
            elif bx in self.handles:
                c.files[self.handles[bx]].extend(data)
                c.synced.discard(self.handles[bx])
            uc.reg_write(UC_X86_REG_AX, cx)
        elif ah == 0x44:
            uc.reg_write(UC_X86_REG_DX, 0x0000 if self.stdout_is_file else 0x0080)
        elif ah == 0x4A:                                # resize: only the program's own block matters
            if es == self.psp:
                if es + bx > MEM_TOP:
                    cf = 1
                    uc.reg_write(UC_X86_REG_AX, 8)
                    uc.reg_write(UC_X86_REG_BX, MEM_TOP - es)
                else:
                    self.prog_end = es + bx
                    self._mcb(es - 1, b'Z', self.psp, bx)
        elif ah == 0x48:                                # allocate above the program and earlier blocks
            seg = max(self.prog_end, self.heap) + 1
            if seg + bx > MEM_TOP:
                cf = 1
                uc.reg_write(UC_X86_REG_AX, 8)
                uc.reg_write(UC_X86_REG_BX, max(0, MEM_TOP - seg))
            else:
                self._mcb(seg - 1, b'M', self.psp, bx)
                self.heap = seg + bx
                uc.reg_write(UC_X86_REG_AX, seg)
        elif ah == 0x49:                                # free: the block's MCB gets owner 0
            if es >= 1 and self.mem((es - 1) * 16, 1) in (b'M', b'Z'):
                self.mu.mem_write((es - 1) * 16 + 1, b'\0\0')
        elif ah == 0x68:
            if self.handles.get(bx) in c.files:
                c.synced.add(self.handles[bx])
        elif ah == 0x0D:
            c.synced.update(c.files)
        elif ah == 0x50:
            pass
        elif ah in (0x51, 0x62):
            uc.reg_write(UC_X86_REG_BX, self.psp)
        elif ah == 0x52:                                # list of lists at 0070:0010, first MCB before it:
            uc.reg_write(UC_X86_REG_ES, 0x0070)         # the lowest MCB of the chain (_psp, AH=31h)
            uc.reg_write(UC_X86_REG_BX, 0x0010)
            uc.mem_write(0x0700 + 0x10 - 2, struct.pack('<H', self.mcb_first or self.psp - 0x11))
        elif ah == 0x58:                                # strategy / UMB link: first fit, no UMBs
            if ax & 0xFF in (0, 2):
                uc.reg_write(UC_X86_REG_AX, 0)
        elif ah == 0x38 and ax & 0xFF == 0:             # country info: all zero (USA date order)
            uc.mem_write(ds * 16 + dx, bytes(34))
            uc.reg_write(UC_X86_REG_BX, 1)
        elif ah == 0x19:
            uc.reg_write(UC_X86_REG_AX, (ax & 0xFF00) | 2)  # drive C:
        elif ah == 0x0B:
            uc.reg_write(UC_X86_REG_AX, ax & 0xFF00)       # no key waiting
        elif ah == 0x33:
            uc.reg_write(UC_X86_REG_DX, dx & 0xFF00)       # Ctrl-Break checking off
        elif ah in (0x2A, 0x2C):
            uc.reg_write(UC_X86_REG_CX, 0)
            uc.reg_write(UC_X86_REG_DX, 0)
        elif ah == 0x4C:                                # the program's blocks are free again
            c.exit = ('exit', ax & 0xFF)
            for s in (self.psp - 0x11, self.psp - 1):
                uc.mem_write(s * 16 + 1, b'\0\0')
            uc.emu_stop()
        elif ah == 0x31:                                # resident: its block shrinks to DX paragraphs,
            c.exit = ('tsr', ax & 0xFF, dx)             # a free block after it ends the chain
            self._mcb(self.psp - 1, b'M', self.psp, dx)
            self.res_end = self.psp + dx
            if self.res_end < MEM_TOP:
                self._mcb(self.res_end, b'Z', 0, MEM_TOP - self.res_end - 1)
            uc.emu_stop()
        else:
            cf = 1
        self._ret_cf(uc, cf)

    # ------------------------------------------------------------------ BIOS
    post_limit = 50_000_000                             # instructions the ROM initialisation may take

    def post(self, limit=None):
        """Run the ROM initialisation; returns the INT 10h vector (segment, offset). Raises RuntimeError
        when the ROM does not return to the caller's far call: a run that stops anywhere else (a loop
        that used up the budget, a HLT) is not a POST that passed (#143)."""
        limit = limit or Machine.post_limit
        self.mu.mem_write(STUB, b'\x9A\x03\x00\x00\xC0\xF4')          # call far C000:0003 ; hlt
        self._start(0, STUB, STUB + 5, limit)
        cs, ip = self._reg(UC_X86_REG_CS), self._reg(UC_X86_REG_IP)
        if cs != 0 or ip != STUB + 5:
            where = '%04X:%04X' % (cs, ip)
            if self.mu.mem_read((cs * 16 + ip - 1) & 0xFFFFF, 1) == b'\xF4':
                raise RuntimeError('POST did not return to its caller: it halted (HLT) at %s' % where)
            raise RuntimeError('POST did not return to its caller: ' +
                               budget_msg('the ROM initialisation (call far C000:0003)', limit,
                                          'Machine.post_limit', where))
        off, seg = struct.unpack('<HH', self.mu.mem_read(0x40, 4))
        self.post_entry = (seg, off)
        if Machine.noop or Machine.calls is not None:
            self._noop_hook(seg * 16 + off)
        return seg, off

    # ------------------------------------------------------------------ POST snapshots
    # SNAP_REGS: everything post() leaves in the CPU. tests.py runs POST once per process and starts
    # every machine from the snapshot (Ctx.machine), instead of running the ROM initialisation again
    # for each one.
    SNAP_REGS = [UC_X86_REG_AX, UC_X86_REG_BX, UC_X86_REG_CX, UC_X86_REG_DX, UC_X86_REG_SI, UC_X86_REG_DI,
                 UC_X86_REG_BP, UC_X86_REG_SP, UC_X86_REG_CS, UC_X86_REG_DS, UC_X86_REG_ES, UC_X86_REG_SS,
                 UC_X86_REG_EFLAGS, UC_X86_REG_EIP]

    def post_snapshot(self):
        """Everything a test can see after post(): RAM, the CPU registers, the register model and
        vram. load_post_snapshot() puts it into a fresh Machine without running POST again."""
        return {
            'mem': bytes(self.mu.mem_read(0, 0x110000)),
            'regs': {r: self.mu.reg_read(r) for r in self.SNAP_REGS},
            'vram': bytes(self.vram),
            'r': copy.deepcopy(self.r),
            'pit': copy.deepcopy(self.pit),
            'dac': copy.deepcopy(self.dac),
            't': self.t,
            'tick_base': self.tick_base,
            'win': self.win,
            'latch': list(self.latch),
            'ge_cmds': self.ge_cmds,
            'bee8': set(self.bee8),
            'ge_first': self.ge_first,
            'entry': getattr(self, 'post_entry', None),
        }

    def load_post_snapshot(self, s):
        """Start this fresh Machine from a post_snapshot() taken after post(); returns the INT 10h
        entry (segment, offset). The per-run state (keys, dac_fault, com, handles, wlog) stays as
        __init__ left it."""
        mu = self.mu
        mu.mem_write(0, s['mem'])
        for r, v in s['regs'].items():
            mu.reg_write(r, v)
        self.vram[:] = s['vram']
        self.r = copy.deepcopy(s['r'])
        self.pit = copy.deepcopy(s['pit'])
        self.dac = copy.deepcopy(s['dac'])
        self.t = s['t']
        self.tick_base = s['tick_base']
        self.win = s['win']
        self._vhooks(self.win[0] == 'planar')
        self.latch = list(s['latch'])
        self.ge_cmds = s['ge_cmds']
        self.bee8 = set(s['bee8'])
        self.ge_first = s['ge_first']
        self.post_entry = s['entry']
        self._wcfg_cache = None
        self._frame_cache = None
        return s['entry']

    # mutation testing: INT 10h calls that match one of these register patterns (dicts of 'ah', 'al',
    # 'ax', 'bh', 'bl', 'bx', 'dl' -> value) return at the ROM's entry as if the function did nothing (an
    # IRET with every register unchanged). Set Machine.noop before the machines are made.
    noop = None
    noop_hits = 0
    calls = None                                        # a set: (AX, BX, DL) of every INT 10h call after POST
    call_limit = 50_000_000                             # instructions an INT 10h call of a test may take
    vram = 2                                            # MB the CR36 bits 7-5 report: 1, 2 (the card) or 4
    chip = 'v2'                                         # CHIPS key: v2 (the card), vplus, uvplus, trio64, trio32
    cr2f = None                                         # CR2F when it is not the PCI revision (CHIP_CR2F)

    def _noop_hook(self, entry):
        def hit(uc, addr, size, ud):
            ax, bx = self._reg(UC_X86_REG_AX), self._reg(UC_X86_REG_BX)
            dx = self._reg(UC_X86_REG_DX)
            v = {'ax': ax, 'ah': ax >> 8, 'al': ax & 0xFF, 'bx': bx, 'bh': bx >> 8, 'bl': bx & 0xFF, 'dl': dx & 0xFF}
            if Machine.calls is not None:
                Machine.calls.add((ax, bx, dx & 0xFF))
            if not Machine.noop or not any(all(v[k] == x for k, x in pat.items()) for pat in Machine.noop):
                return
            Machine.noop_hits += 1
            ss, sp = self._reg(UC_X86_REG_SS), self._reg(UC_X86_REG_SP)
            ip, cs, fl = struct.unpack('<HHH', uc.mem_read(ss * 16 + sp, 6))
            uc.reg_write(UC_X86_REG_SP, (sp + 6) & 0xFFFF)
            uc.reg_write(UC_X86_REG_EFLAGS, (self._reg(UC_X86_REG_EFLAGS) & ~0xFFFF) | fl)
            uc.reg_write(UC_X86_REG_CS, cs)
            uc.reg_write(UC_X86_REG_IP, ip)
        self.mu.hook_add(UC_HOOK_CODE, hit, None, entry, entry)
        self.mu.ctl_remove_cache(entry, entry + 1)      # POST has run the entry: retranslate it with the hook

    def _start(self, cs, ip, until, count, ss=0, sp=0x7000):
        mu = self.mu
        mu.reg_write(UC_X86_REG_CS, cs)
        mu.reg_write(UC_X86_REG_SS, ss)
        mu.reg_write(UC_X86_REG_SP, sp)
        mu.reg_write(UC_X86_REG_DS, 0)
        mu.reg_write(UC_X86_REG_ES, 0)
        mu.reg_write(UC_X86_REG_EFLAGS, 0x202)
        try:
            mu.emu_start(cs * 16 + ip, until, count=count)
        except UcError as e:
            raise RuntimeError('emulation error %s at %04x:%04x' % (e, self._reg(UC_X86_REG_CS),
                                                                    self._reg(UC_X86_REG_IP)))

    def int10(self, ax, bx=0, cx=0, dx=0, es=0, di=0, si=0, bp=0):
        """INT 10h from a stub at 0000:7D00; returns a dict of the registers after the call."""
        mu = self.mu
        mu.mem_write(0x7D00, b'\xCD\x10\xF4')
        for reg, v in ((UC_X86_REG_AX, ax), (UC_X86_REG_BX, bx), (UC_X86_REG_CX, cx), (UC_X86_REG_DX, dx),
                       (UC_X86_REG_DI, di), (UC_X86_REG_SI, si), (UC_X86_REG_BP, bp)):
            mu.reg_write(reg, v)
        mu.reg_write(UC_X86_REG_CS, 0)
        mu.reg_write(UC_X86_REG_SS, 0)
        mu.reg_write(UC_X86_REG_SP, 0x7000)
        mu.reg_write(UC_X86_REG_DS, 0)
        mu.reg_write(UC_X86_REG_ES, es)
        mu.reg_write(UC_X86_REG_EFLAGS, 0x202)
        try:
            mu.emu_start(0x7D00, 0x7D02, count=Machine.call_limit)
        except UcError as e:
            raise RuntimeError('INT 10h AX=%04X: %s' % (ax, e))
        if self._reg(UC_X86_REG_IP) != 0x7D02 or self._reg(UC_X86_REG_CS) != 0:
            raise RuntimeError(budget_msg('INT 10h AX=%04X' % ax, Machine.call_limit, '--call-limit',
                                          '%04X:%04X' % (self._reg(UC_X86_REG_CS), self._reg(UC_X86_REG_IP))))
        return {k: self._reg(v) for k, v in (('ax', UC_X86_REG_AX), ('bx', UC_X86_REG_BX), ('cx', UC_X86_REG_CX),
                                              ('dx', UC_X86_REG_DX), ('es', UC_X86_REG_ES), ('bp', UC_X86_REG_BP),
                                              ('flags', UC_X86_REG_EFLAGS))}

    def snapshot(self):
        """The 62 standard registers in the order of S3COMPAT's vgalist (MISC, FEAT, SR0-4, CR00-18,
        AR00-14, GR00-08)."""
        r = self.r
        return [r['misc'], r['feat'], r['seq'].get(0, 3)] + [r['seq'].get(i, 0) for i in range(1, 5)] + \
               [r['crtc'].get(i, 0) for i in range(25)] + [r['atc'].get(i, 0) for i in range(21)] + \
               [r['gc'].get(i, 0) for i in range(9)]

    def state_block(self):
        """INT 10h AH=1Bh state block, 64 bytes."""
        self.int10(0x1B00, bx=0, es=0x0800, di=0)
        return bytes(self.mu.mem_read(0x8000, 64))

    def dac_bytes(self):
        return bytes(sum(self.dac, []))

    def mem(self, addr, n):
        return bytes(self.mu.mem_read(addr, n))

    # ------------------------------------------------------------------ DOS programs
    def _mcb(self, seg, kind, owner, paras, name=b''):
        self.mu.mem_write(seg * 16, kind + struct.pack('<HH', owner, paras) + bytes(3) + name[:8].ljust(8, b'\0'))

    def _psp(self, seg, tail, name):
        """PSP at seg:0000, environment (empty, then the program name) in the 15 paragraphs before it,
        MCBs in front of both."""
        mu = self.mu
        self.psp = seg
        self.prog_end = MEM_TOP
        self.heap = 0
        res_end = getattr(self, 'res_end', None)        # the chain: a free block from the resident
        if res_end is not None and res_end < seg - 0x11:    # program's end to this program's MCBs
            self._mcb(res_end, b'M', 0, seg - 0x11 - res_end - 1)
        first = getattr(self, 'mcb_first', None)
        if first is None or seg - 0x11 < first:
            self.mcb_first = seg - 0x11
        psp = bytearray(256)
        psp[0:2] = b'\xCD\x20'
        psp[2:4] = struct.pack('<H', MEM_TOP)              # top of memory
        psp[0x2C:0x2E] = struct.pack('<H', seg - 0x10)      # environment segment
        t = (' ' + tail.strip()).encode() if tail.strip() else b''
        psp[0x80] = len(t)
        psp[0x81:0x81 + len(t) + 1] = t + b'\r'
        mu.mem_write(seg * 16, bytes(psp))
        mu.mem_write((seg - 0x10) * 16, b'\0\0\x01\0C:\\' + name.encode() + b'\0')
        self._mcb(seg - 0x11, b'M', seg, 0x0F)
        self._mcb(seg - 1, b'Z', seg, MEM_TOP - seg, name.split('.')[0].encode())

    def _go(self, start, max_insn):
        c = self.com
        try:
            self.mu.emu_start(start, 0, count=max_insn)
        except UcError as e:
            c.exit = ('error', '%s at %04x:%04x' % (e, self._reg(UC_X86_REG_CS), self._reg(UC_X86_REG_IP)))
        if c.exit is None:              # neither an exit nor an error: the count ran out
            c.exit = ('budget', budget_msg('the program', max_insn, 'max_insn',
                                           '%04X:%04X' % (self._reg(UC_X86_REG_CS), self._reg(UC_X86_REG_IP))))
        self.com = None
        return c

    def run_com(self, com, tail='', seg=0x2000, stdout_is_file=True, max_insn=600_000_000, name='PROG.COM'):
        """Run a .COM program at seg:0100 with the command tail; returns a ComResult. The program's
        resident part stays in memory when it ends with INT 21h AH=31h."""
        mu = self.mu
        self.com = ComResult()
        self.stdout_is_file = stdout_is_file
        self._psp(seg, tail, name)
        base = seg * 16
        mu.mem_write(base + 0x100, com)
        mu.mem_write(base + 0xFFFE, b'\0\0')
        mu.ctl_remove_cache(base, base + 0x10000)      # code translated for an earlier program here (#159)
        for reg in (UC_X86_REG_CS, UC_X86_REG_DS, UC_X86_REG_ES, UC_X86_REG_SS):
            mu.reg_write(reg, seg)
        mu.reg_write(UC_X86_REG_SP, 0xFFFE)
        mu.reg_write(UC_X86_REG_EFLAGS, 0x202)
        return self._go(base + 0x100, max_insn)

    def run_exe(self, exe, tail='', seg=0x2000, stdout_is_file=True, max_insn=600_000_000, name='PROG.EXE'):
        """Run an MZ .EXE with its PSP at seg:0000 and the load image at seg+10h (relocations applied);
        returns a ComResult like run_com."""
        mu = self.mu
        sig, cblp, cp, nrel, hdr, minalloc, maxalloc, ss, sp, ck, ip, cs, relo = struct.unpack('<2s12H', exe[:26])
        if sig not in (b'MZ', b'ZM'):
            raise ValueError('not an MZ executable')
        size = (cp - 1) * 512 + (cblp or 512) - hdr * 16
        img = bytearray(exe[hdr * 16: hdr * 16 + size])
        load = seg + 0x10
        for i in range(nrel):
            o, s = struct.unpack('<HH', exe[relo + 4 * i: relo + 4 * i + 4])
            a = s * 16 + o
            img[a:a + 2] = struct.pack('<H', (struct.unpack('<H', img[a:a + 2])[0] + load) & 0xFFFF)
        self.com = ComResult()
        self.stdout_is_file = stdout_is_file
        self._psp(seg, tail, name)
        if load + (size + 15) // 16 + minalloc > MEM_TOP:
            raise ValueError('program does not fit below %04X' % MEM_TOP)
        mu.mem_write(load * 16, bytes(img))
        mu.ctl_remove_cache(seg * 16, load * 16 + len(img))   # code translated for an earlier program (#159)
        mu.reg_write(UC_X86_REG_DS, seg)
        mu.reg_write(UC_X86_REG_ES, seg)
        mu.reg_write(UC_X86_REG_SS, load + ss)
        mu.reg_write(UC_X86_REG_SP, sp)
        mu.reg_write(UC_X86_REG_CS, load + cs)
        mu.reg_write(UC_X86_REG_EFLAGS, 0x202)
        return self._go((load + cs) * 16 + ip, max_insn)

    # ------------------------------------------------------------------ Win32 console programs
    def run_pe32(self, exe, cmdline, sleep_hook=None, max_insn=200_000_000):
        """Run a 32-bit Windows console program (PE, no relocations, KERNEL32 imports only) in a flat 32-bit
        CPU of its own whose IN/OUT go to this machine's VGA/S3 and PCI model, as on the Windows 9x
        desktop. Supported imports: ExitProcess, GetStdHandle, WriteFile, FlushFileBuffers (marks the file
        synced, as a DOS commit does), CreateFileA, SetFilePointer, CloseHandle, GetCommandLineA, Sleep
        (advances GetTickCount; sleep_hook(ms_total) runs first), GetTickCount. Returns a ComResult:
        stdout, files written, synced, exit ('exit', code)."""
        from unicorn import UC_MODE_32
        from unicorn.x86_const import (UC_X86_REG_ESP, UC_X86_REG_EAX, UC_X86_REG_EIP, UC_X86_REG_EDX,
                                       UC_X86_REG_ECX)
        c = ComResult()
        lfanew = struct.unpack_from('<I', exe, 0x3C)[0]
        check_pe = exe[lfanew:lfanew + 4] == b'PE\0\0' and struct.unpack_from('<H', exe, lfanew + 4)[0] == 0x14C
        if not check_pe:
            raise ValueError('not a 32-bit PE')
        nsec = struct.unpack_from('<H', exe, lfanew + 6)[0]
        optsz = struct.unpack_from('<H', exe, lfanew + 20)[0]
        o = lfanew + 24
        entry, base, simg, shdr = (struct.unpack_from('<I', exe, o + 16)[0], struct.unpack_from('<I', exe, o + 28)[0],
                                   struct.unpack_from('<I', exe, o + 56)[0], struct.unpack_from('<I', exe, o + 60)[0])
        imp_rva = struct.unpack_from('<I', exe, o + 96 + 8)[0]
        u = Uc(UC_ARCH_X86, UC_MODE_32)
        u.mem_map(base, (simg + 0xFFF) & ~0xFFF)
        u.mem_write(base, exe[:shdr])
        for i in range(nsec):
            s = o + optsz + 40 * i
            vs, va, rs, rp = struct.unpack_from('<IIII', exe, s + 8)
            u.mem_write(base + va, exe[rp:rp + rs])
        STUBS, STACK, CMD = 0x70000000, 0x7F000000, 0x7E000000
        u.mem_map(STUBS, 0x1000)
        u.mem_map(STACK - 0x100000, 0x101000)
        u.mem_map(CMD, 0x1000)
        u.mem_write(CMD, cmdline.encode() + b'\0')
        names = []
        d = imp_rva
        while True:
            ilt, _, _, name, iat = struct.unpack('<IIIII', u.mem_read(base + d, 20))
            if not name:
                break
            k = 0
            while True:
                hn = struct.unpack('<I', u.mem_read(base + (ilt or iat) + 4 * k, 4))[0]
                if not hn:
                    break
                fn = bytes(u.mem_read(base + hn + 2, 64)).split(b'\0')[0].decode()
                u.mem_write(base + iat + 4 * k, struct.pack('<I', STUBS + 4 * len(names)))
                names.append(fn)
                k += 1
            d += 20
        u.mem_write(STUBS, b'\xF4' * 0x1000)
        st = {'tick': 0x10000, 'files': {}, 'h': {}, 'next': 8}

        def ret(esp, nargs, val):
            raddr = struct.unpack('<I', u.mem_read(esp, 4))[0]
            u.reg_write(UC_X86_REG_EAX, val & 0xFFFFFFFF)
            u.reg_write(UC_X86_REG_ESP, esp + 4 + 4 * nargs)
            u.reg_write(UC_X86_REG_EIP, raddr)

        def api(uc, addr, size, ud):
            fn = names[(addr - STUBS) // 4]
            esp = uc.reg_read(UC_X86_REG_ESP)
            a = struct.unpack('<6I', uc.mem_read(esp + 4, 24))
            if fn == 'ExitProcess':
                c.exit = ('exit', a[0])
                uc.emu_stop()
            elif fn == 'GetCommandLineA':
                ret(esp, 0, CMD)
            elif fn == 'GetTickCount':
                ret(esp, 0, st['tick'])
            elif fn == 'Sleep':
                st['tick'] += a[0]
                if sleep_hook:
                    sleep_hook(st['tick'] - 0x10000)
                ret(esp, 1, 0)
            elif fn == 'GetStdHandle':
                ret(esp, 1, 1 if a[0] == 0xFFFFFFF5 else 2)
            elif fn == 'CreateFileA':
                nm = bytes(uc.mem_read(a[0], 128)).split(b'\0')[0].decode('latin1').upper()
                h = st['next']
                st['next'] += 4
                st['h'][h] = nm
                c.files.setdefault(nm, bytearray())
                ret(esp, 7, h)
            elif fn == 'SetFilePointer':
                ret(esp, 4, 0)
            elif fn == 'WriteFile':
                data = bytes(uc.mem_read(a[1], a[2]))
                if a[0] == 1:
                    c.stdout.extend(data)
                elif a[0] == 2:
                    c.stderr.extend(data)
                else:
                    c.files[st['h'][a[0]]].extend(data)
                    c.synced.discard(st['h'][a[0]])
                if a[3]:
                    uc.mem_write(a[3], struct.pack('<I', a[2]))
                ret(esp, 5, 1)
            elif fn == 'FlushFileBuffers':           # the Win32 commit: the file counts as on disk (synced)
                if a[0] in st['h']:
                    c.synced.add(st['h'][a[0]])
                ret(esp, 1, 1 if a[0] in st['h'] else 0)
            elif fn == 'CloseHandle':
                st['h'].pop(a[0], None)
                ret(esp, 1, 1)
            else:
                raise RuntimeError('import %s not emulated' % fn)
        u.hook_add(UC_HOOK_CODE, api, None, STUBS, STUBS + 0xFFF)
        u.hook_add(UC_HOOK_INSN, lambda uc, port, size, ud: self._in(uc, port, size, ud), None, 1, 0, UC_X86_INS_IN)
        u.hook_add(UC_HOOK_INSN, lambda uc, port, size, val, ud: self._out(uc, port, size, val, ud), None, 1, 0,
                   UC_X86_INS_OUT)
        u.mem_write(STACK - 16, struct.pack('<I', STUBS + 0xFF0))     # return address of the entry point
        u.reg_write(UC_X86_REG_ESP, STACK - 16)
        try:
            u.emu_start(base + entry, STUBS + 0xFF0, count=max_insn)
        except UcError as e:
            c.exit = ('error', '%s at %08x' % (e, u.reg_read(UC_X86_REG_EIP)))
        if c.exit is None:              # neither an exit nor an error: the count ran out
            c.exit = ('budget', budget_msg('the program', max_insn, 'max_insn', '%08X' % u.reg_read(UC_X86_REG_EIP)))
        return c

    # ------------------------------------------------------------------ coverage
    def track_coverage(self):
        """Record which bytes of C000:0000-7FFF are executed (code) or read as data; returns (code, data)
        bytearrays that fill in while the machine runs. code: bit 0 executed, bit 1 a basic block starts
        there."""
        code = bytearray(0x8000)
        data = bytearray(0x8000)

        def blk(uc, addr, size, ud):
            if 0xC0000 <= addr < 0xC8000:
                for a in range(addr, min(addr + size, 0xC8000)):
                    code[a - 0xC0000] |= 1
                code[addr - 0xC0000] |= 2               # bit 1: a block (and so an instruction) starts here

        def rd(uc, acc, addr, size, val, ud):
            for a in range(addr, min(addr + size, 0xC8000)):
                data[a - 0xC0000] = 1
        self.mu.hook_add(UC_HOOK_BLOCK, blk)
        self.mu.hook_add(UC_HOOK_MEM_READ, rd, None, 0xC0000, 0xC7FFF)
        return code, data
