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
    rate the registers define, and call durations are plausible, but not real.
    Every write to A0000-BFFFF also takes one count, so loops that write video memory until a tick
    passes come to an end.
  - A small DOS (INT 21h) for .COM and .EXE programs (MZ header with relocations, run_exe): console and
    file output, create/close, IOCTL, InDOS, get/set vector, version, PSP (51h/62h), memory blocks
    (48h-4Ah, with MCBs in front of the environment and the program), list of lists (52h, first MCB),
    allocation strategy and UMB link (58h, no UMBs), country (38h), date/time (zero), Ctrl-Break,
    default drive, commit, terminate and stay resident. INT 21h goes through the vector table to a stub
    at 0050:0020, so a program that hooks INT 21h (for example a TSR that stays resident when its own
    AH=4Ch passes its hook) sees its own calls. INT 16h returns keys from a queue (Enter when empty);
    INT 15h AH=87h reports "not supported".

What is not emulated (results that depend on it are meaningless here)
  - Video memory beyond one 64 KB window: A0000-BFFFF is plain RAM, plus a model of the four planes
    (map mask, read map, bit mask, set/reset, latches, write modes 0-2, read mode 0) for the 16-colour
    and unchained modes. There is no banking or LFB memory, so memory tests through banks or the LFB
    fail.
  - Real timing: CPU speed, bus waits and monitor behaviour. Durations come from the virtual clock.
  - Equipment-dependent BIOS state (AH=1Bh +26h alternate display, +2Dh flags).

Usage (see tests.py for complete examples)
  m = Machine(open('S3V2P14.BIN','rb').read())
  m.post()
  m.int10(0x0003); print(m.snapshot())         # registers after a mode set
  r = m.run_com(open('build/S3TEST.COM','rb').read(), '/V')
  print(r.stdout.decode('latin1'), r.files.get('S3TEST.DBG'))
"""
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

IRET_SEG = 0x0060          # every unused vector points to 0060:0000 = IRET
DOS_STUB = 0x0520          # INT 21h vector 0050:0020: INT F1h (the emulated DOS), RETF 2 (keeps its flags)
MEM_TOP = 0x9000           # first segment after conventional memory available to programs
STUB = 0x7C00              # small code stubs (POST far call, INT 10h call) live here


class ComResult:
    def __init__(self):
        self.stdout = bytearray()      # handle 1 and console output (AH=02h/09h)
        self.stderr = bytearray()      # handle 2
        self.files = {}                # created files: name -> bytes written
        self.exit = None               # ('exit', code) or ('tsr', code, paragraphs) or None (did not end)
        self.dos_calls = set()         # (AH) values seen


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
        self.keys = list(keys or [])
        self.com = None                                 # ComResult while a .COM runs
        self.handles = {}
        mu.hook_add(UC_HOOK_INTR, self._intr)
        mu.hook_add(UC_HOOK_INSN, self._in, None, 1, 0, UC_X86_INS_IN)
        mu.hook_add(UC_HOOK_INSN, self._out, None, 1, 0, UC_X86_INS_OUT)
        mu.hook_add(UC_HOOK_MEM_READ, self._tread, None, 0x46C, 0x46D)
        mu.hook_add(UC_HOOK_MEM_WRITE, self._vwrite, None, 0xA0000, 0xBFFFF)
        mu.hook_add(UC_HOOK_MEM_READ, self._vread, None, 0xA0000, 0xAFFFF)
        self.planes = [bytearray(0x10000) for _ in range(4)]
        self.latch = [0, 0, 0, 0]

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
            rr = ((n >> 5) & 3) | (4 if n & 0x80 else 0)
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
        """Vertical retrace bit from the virtual clock: on for about 3 lines at the start of each frame."""
        hz, pix, period, vtot = self.frame()
        return (self.t % period) < max(60, period * 3 // max(vtot, 1))

    def _pit_count(self, ch):
        p = self.pit[ch]
        reload = p['reload'] or 0x10000
        el = self.t - p['t0']
        if p['mode'] == 3:                              # square wave counts down by 2
            return (reload - (2 * el) % reload) & 0xFFFF
        return (reload - el % reload) & 0xFFFF

    def _in(self, uc, port, size, ud):
        r = self.r
        self.t += 3                                     # about one ISA I/O cycle
        if port == 0x3C5:
            v = r['seq'].get(r['si'], 0)
            return v & 0xFE if r['si'] == 4 else v      # SR04 bit 0 is reserved and reads 0
        if port in (0x3B4, 0x3B5, 0x3BA) and r['misc'] & 1:
            return 0xFF                                 # colour I/O: the mono ports are not decoded
        if port in (0x3D4, 0x3D5, 0x3DA) and not r['misc'] & 1:
            return 0xFF
        if port in (0x3D5, 0x3B5):
            i = r['ci']
            fixed = {0x30: 0xE1, 0x2D: 0x89, 0x2E: 0x01, 0x2F: 0x06, 0x36: 0x92}  # Trio64V2 rev 06, EDO 2 MB
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
                cfg = PCI_CONFIG.get(reg, 0)
            v = cfg >> (8 * (port - 0xCFC))
            return v & {1: 0xFF, 2: 0xFFFF, 4: 0xFFFFFFFF}[size]
        return 0xFF if size == 1 else 0xFFFF

    def _out(self, uc, port, size, val, ud):
        r = self.r

        def w8(p, v):
            if p in (0x3B4, 0x3B5, 0x3BA) and r['misc'] & 1:
                return                                  # colour I/O: the mono ports are not decoded
            if p in (0x3D4, 0x3D5, 0x3DA) and not r['misc'] & 1:
                return
            if p in (0x3D5, 0x3B5) and r['ci'] <= 7 and r['crtc'].get(0x11, 0) & 0x80:
                if r['ci'] == 7:                        # CR11 bit 7 protects CR00-07 except CR07 bit 4
                    r['crtc'][7] = (r['crtc'].get(7, 0) & ~0x10) | (v & 0x10)
                return
            if p == 0x3C4: r['si'] = v
            elif p == 0x3C5: r['seq'][r['si']] = v
            elif p in (0x3D4, 0x3B4): r['ci'] = v
            elif p in (0x3D5, 0x3B5): r['crtc'][r['ci']] = v
            elif p == 0x3CE: r['gi'] = v
            elif p == 0x3CF: r['gc'][r['gi']] = v
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

    def _vwrite(self, uc, acc, addr, size, val, ud):
        self.t += 1                                     # video memory writes take time too
        if addr >= 0xB0000 or not self._planar():
            return
        gc, sr = self.r['gc'], self.r['seq']
        mode = gc.get(5, 0) & 3
        mask, sr_en, sr_val = gc.get(8, 0xFF), gc.get(1, 0), gc.get(0, 0)
        mapmask = sr.get(2, 0x0F)
        rot, fn = gc.get(3, 0) & 7, (gc.get(3, 0) >> 3) & 3     # GR03: rotate count, function (0 replace,
        for k in range(size):                                   # 1 AND, 2 OR, 3 XOR with the latch)
            off = (addr + k) & 0xFFFF
            cpu = (val >> (8 * k)) & 0xFF
            if rot:
                cpu = ((cpu >> rot) | (cpu << (8 - rot))) & 0xFF
            for p in range(4):
                if not mapmask & (1 << p):
                    continue
                if mode == 1:
                    d = self.latch[p]
                else:
                    if mode == 2:
                        d = 0xFF if cpu & (1 << p) else 0
                    elif sr_en & (1 << p):
                        d = 0xFF if sr_val & (1 << p) else 0
                    else:
                        d = cpu
                    if fn == 1:
                        d &= self.latch[p]
                    elif fn == 2:
                        d |= self.latch[p]
                    elif fn == 3:
                        d ^= self.latch[p]
                    d = (d & mask) | (self.latch[p] & ~mask & 0xFF)
                self.planes[p][off] = d

    def _vread(self, uc, acc, addr, size, val, ud):
        """Before the CPU reads a planar address: load the latches and put the selected plane's bytes
        (read mode 0) or the colour compare result (read mode 1: GR02 colour, GR07 colour don't care)
        into RAM, so the read returns them."""
        if not self._planar():
            return
        gc = self.r['gc']
        plane = gc.get(4, 0) & 3
        cmode = gc.get(5, 0) & 0x08                     # read mode 1: colour compare
        ccol, cdc = gc.get(2, 0), gc.get(7, 0x0F)
        data = bytearray()
        for k in range(size):
            off = (addr + k) & 0xFFFF
            self.latch = [self.planes[p][off] for p in range(4)]
            if cmode:
                v = 0xFF
                for p in range(4):
                    if cdc & (1 << p):
                        v &= ~(self.latch[p] ^ (0xFF if ccol & (1 << p) else 0)) & 0xFF
                data.append(v)
            else:
                data.append(self.planes[plane][off])
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

    def _pci_read(self, reg):
        reg &= 0xFC
        if reg == 0x10:
            return (self.r['crtc'].get(0x59, 0) << 24) | (self.r['crtc'].get(0x5A, 0) << 16)
        return PCI_CONFIG.get(reg, 0)

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
                (0x5333, 0x8901, 0)
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
            elif bx in self.handles: c.files[self.handles[bx]].extend(data)
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
        elif ah in (0x49, 0x68, 0x50):
            pass
        elif ah in (0x51, 0x62):
            uc.reg_write(UC_X86_REG_BX, self.psp)
        elif ah == 0x52:                                # list of lists at 0070:0010, first MCB before it
            uc.reg_write(UC_X86_REG_ES, 0x0070)
            uc.reg_write(UC_X86_REG_BX, 0x0010)
            uc.mem_write(0x0700 + 0x10 - 2, struct.pack('<H', self.psp - 0x11))
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
        elif ah == 0x4C:
            c.exit = ('exit', ax & 0xFF)
            uc.emu_stop()
        elif ah == 0x31:
            c.exit = ('tsr', ax & 0xFF, dx)
            uc.emu_stop()
        else:
            cf = 1
        self._ret_cf(uc, cf)

    # ------------------------------------------------------------------ BIOS
    def post(self):
        """Run the ROM initialisation; returns the INT 10h vector (segment, offset)."""
        self.mu.mem_write(STUB, b'\x9A\x03\x00\x00\xC0\xF4')          # call far C000:0003 ; hlt
        self._start(0, STUB, STUB + 5, 50_000_000)
        off, seg = struct.unpack('<HH', self.mu.mem_read(0x40, 4))
        if Machine.noop or Machine.calls is not None:
            self._noop_hook(seg * 16 + off)
        return seg, off

    # mutation testing: INT 10h calls that match one of these register patterns (dicts of 'ah', 'al',
    # 'ax', 'bh', 'bl', 'bx', 'dl' -> value) return at the ROM's entry as if the function did nothing (an
    # IRET with every register unchanged). Set Machine.noop before the machines are made.
    noop = None
    noop_hits = 0
    calls = None                                        # a set: (AX, BX, DL) of every INT 10h call after POST

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
            mu.emu_start(0x7D00, 0x7D02, count=50_000_000)
        except UcError as e:
            raise RuntimeError('INT 10h AX=%04X: %s' % (ax, e))
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
        desktop. Supported imports: ExitProcess, GetStdHandle, WriteFile, CreateFileA, SetFilePointer,
        CloseHandle, GetCommandLineA, Sleep (advances GetTickCount; sleep_hook(ms_total) runs first),
        GetTickCount. Returns a ComResult: stdout, files written, exit ('exit', code)."""
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
                if a[3]:
                    uc.mem_write(a[3], struct.pack('<I', a[2]))
                ret(esp, 5, 1)
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
