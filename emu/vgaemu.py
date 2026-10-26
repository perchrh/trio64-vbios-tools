"""vgaemu.py - run the Trio64V2 video BIOS and the DOS tools in an emulated PC (Unicorn, x86 real mode).

What is emulated
  - 1 MB of RAM with the 64 KB ROM image at C0000; the ROM is started like a system BIOS does it
    (far call to C000:0003) and then serves INT 10h.
  - A register-level model of the VGA and S3 ports: sequencer, CRTC (3D4/3B4), graphics controller,
    attribute controller with its flip-flop, misc output, DAC with read/write indexes, input status
    (3DAh toggles retrace on every read), PCI configuration mechanism 1,
    PIT channels 0 and 2 (a counter that runs down a fixed amount per read), port 61h,
    the card's PCI configuration header (BAR0 = E0000000, as on the real card).
  - The BIOS timer tick at 0040:006C advances every 20 reads.
  - A small DOS (INT 21h) for .COM programs: console and file output, create/close, IOCTL, InDOS,
    get/set vector, version, PSP, free memory, commit, terminate and stay resident. INT 16h returns
    keys from a queue (Enter when empty), INT 15h AH=87h and the PCI BIOS (INT 1Ah) report "not
    supported".

What is not emulated (results that depend on it are meaningless here)
  - Video memory: A0000-BFFFF is plain RAM, so memory tests through banks, planes or the LFB fail.
  - Real timing: refresh rates, line frequencies and call durations are artefacts of the model.
  - The reserved bit 0 of SR04 reads back as written (the real chip returns 0).
  - Equipment-dependent BIOS state (AH=1Bh +26h alternate display, +2Dh flags).

Usage (see tests.py for complete examples)
  m = Machine(open('S3V2P9.BIN','rb').read())
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
    UC_HOOK_BLOCK, UC_HOOK_CODE
from unicorn.x86_const import *

REGNAMES = ['MISC', 'FEAT', 'SR0', 'SR1', 'SR2', 'SR3', 'SR4'] + ['CR%02X' % i for i in range(25)] + \
           ['AR%02X' % i for i in range(21)] + ['GR%02X' % i for i in range(9)]

# PCI configuration header of the card as read on the real hardware (VSHOW /V log): 5333:8901,
# command 0003, class 030000, IRQ 10. BAR0 (E0000000 on the card) is read from CR59/CR5A, which the
# Trio64 uses as the BAR.
PCI_CONFIG = {0x00: 0x89015333, 0x04: 0x02000003, 0x08: 0x03000006,
              0x2C: 0x89015333, 0x3C: 0x0000010A}

IRET_SEG = 0x0060          # every unused vector points to 0060:0000 = IRET
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
        mu.mem_write(0x410, struct.pack('<H', 0x0020))  # equipment: 80x25 colour
        mu.mem_write(0x413, struct.pack('<H', 640))
        self.r = {'seq': {}, 'crtc': {}, 'gc': {}, 'atc': {}, 'misc': 0x67, 'feat': 0, 'si': 0, 'ci': 0,
                  'gi': 0, 'ai': 0, 'aff': 0, 'dac_w': 0, 'dac_c': 0, 'dac_r': 0, 'dac_rc': 0, 'pci': 0,
                  'st': 0, 'pit': {0x40: [0xFFFF, 0], 0x42: [0xFFFF, 0]}, 'p61': 0}
        # the system BIOS has assigned BAR0 = E0000000 before the video ROM starts; on the Trio64 the
        # BAR is CR59/CR5A (the linear frame buffer base)
        self.r['crtc'][0x59] = 0xE0
        self.r['crtc'][0x5A] = 0x00
        self.dac = [[0, 0, 0] for _ in range(256)]
        self.tick = 0
        self.keys = list(keys or [])
        self.com = None                                 # ComResult while a .COM runs
        self.handles = {}
        mu.hook_add(UC_HOOK_INTR, self._intr)
        mu.hook_add(UC_HOOK_INSN, self._in, None, 1, 0, UC_X86_INS_IN)
        mu.hook_add(UC_HOOK_INSN, self._out, None, 1, 0, UC_X86_INS_OUT)
        mu.hook_add(UC_HOOK_MEM_READ, self._tread, None, 0x46C, 0x46D)

    # ------------------------------------------------------------------ ports
    def _in(self, uc, port, size, ud):
        r = self.r
        if port == 0x3C5: return r['seq'].get(r['si'], 0)
        if port in (0x3D5, 0x3B5):
            i = r['ci']
            fixed = {0x30: 0xE1, 0x2E: 0x01, 0x2F: 0x06, 0x36: 0x92}   # chip id Trio64V2, EDO 2 MB
            return fixed.get(i, r['crtc'].get(i, 0))
        if port == 0x3CF: return r['gc'].get(r['gi'], 0)
        if port == 0x3C1: return r['atc'].get(r['ai'] & 0x1F, 0)
        if port == 0x3C0: return r['ai']
        if port == 0x3CC: return r['misc']
        if port == 0x3CA: return r['feat']
        if port == 0x3C2: return 0x10
        if port in (0x3DA, 0x3BA):
            r['aff'] = 0
            r['st'] ^= 0x09
            return r['st']
        if port == 0x3C9:
            v = self.dac[r['dac_r']][r['dac_rc']]
            r['dac_rc'] += 1
            if r['dac_rc'] == 3:
                r['dac_rc'] = 0
                r['dac_r'] = (r['dac_r'] + 1) & 255
            return v
        if port == 0x3C6: return 0xFF
        if port == 0x3C7: return 3
        if port == 0x3C4: return r['si']
        if port in (0x3D4, 0x3B4): return r['ci']
        if port == 0x3CE: return r['gi']
        if port in (0x40, 0x42):
            p = r['pit'][port]
            if p[1] == 0:
                p[0] = (p[0] - 60) & 0xFFFF
            v = (p[0] >> (8 * p[1])) & 0xFF
            p[1] ^= 1
            return v
        if port == 0x61:
            r['p61'] ^= 0x30
            return r['p61']
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
            elif p in (0x3DA, 0x3BA): r['feat'] = v
            elif p == 0x3C8:
                r['dac_w'] = v
                r['dac_c'] = 0
            elif p == 0x3C7:
                r['dac_r'] = v
                r['dac_rc'] = 0
            elif p == 0x3C9:
                self.dac[r['dac_w']][r['dac_c']] = v & 0x3F
                r['dac_c'] += 1
                if r['dac_c'] == 3:
                    r['dac_c'] = 0
                    r['dac_w'] = (r['dac_w'] + 1) & 255
        if port == 0xCF8:
            r['pci'] = val
            return
        if size == 1:
            w8(port, val & 0xFF)
        else:
            w8(port, val & 0xFF)
            w8(port + 1, (val >> 8) & 0xFF)

    def _tread(self, uc, acc, addr, size, val, ud):
        self.tick += 1
        uc.mem_write(0x46C, struct.pack('<H', (self.tick // 20) & 0xFFFF))

    # ------------------------------------------------------------------ interrupts
    def _reg(self, n):
        return self.mu.reg_read(n)

    def _intr(self, uc, n, ud):
        ah = (self._reg(UC_X86_REG_AX) >> 8) & 0xFF
        if self.com is not None:
            if n == 0x21:
                self._dos(uc, ah)
                return
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
                self._ret_cf(uc, 1, ax=0x8100)
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
        elif ah in (0x49, 0x4A, 0x68, 0x50):
            pass
        elif ah == 0x51:
            uc.reg_write(UC_X86_REG_BX, self.psp)
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
        return seg, off

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
    def run_com(self, com, tail='', seg=0x2000, stdout_is_file=True, max_insn=600_000_000):
        """Run a .COM program at seg:0100 with the command tail; returns a ComResult. The program's
        resident part stays in memory when it ends with INT 21h AH=31h."""
        mu = self.mu
        self.com = c = ComResult()
        self.stdout_is_file = stdout_is_file
        self.psp = seg
        base = seg * 16
        psp = bytearray(256)
        psp[0:2] = b'\xCD\x20'
        psp[2:4] = struct.pack('<H', 0x9000)                 # top of memory
        psp[0x2C:0x2E] = struct.pack('<H', seg - 0x10)      # environment segment
        t = (' ' + tail.strip()).encode() if tail.strip() else b''
        psp[0x80] = len(t)
        psp[0x81:0x81 + len(t) + 1] = t + b'\r'
        mu.mem_write(base, bytes(psp))
        mu.mem_write(base + 0x100, com)
        mu.mem_write(base + 0xFFFE, b'\0\0')
        for reg in (UC_X86_REG_CS, UC_X86_REG_DS, UC_X86_REG_ES, UC_X86_REG_SS):
            mu.reg_write(reg, seg)
        mu.reg_write(UC_X86_REG_SP, 0xFFFE)
        mu.reg_write(UC_X86_REG_EFLAGS, 0x202)
        try:
            mu.emu_start(base + 0x100, 0, count=max_insn)
        except UcError as e:
            c.exit = ('error', '%s at %04x:%04x' % (e, self._reg(UC_X86_REG_CS), self._reg(UC_X86_REG_IP)))
        self.com = None
        return c

    # ------------------------------------------------------------------ coverage
    def track_coverage(self):
        """Record which bytes of C000:0000-7FFF are executed (code) or read as data; returns (code, data)
        bytearrays that fill in while the machine runs."""
        code = bytearray(0x8000)
        data = bytearray(0x8000)

        def blk(uc, addr, size, ud):
            if 0xC0000 <= addr < 0xC8000:
                for a in range(addr, min(addr + size, 0xC8000)):
                    code[a - 0xC0000] = 1

        def rd(uc, acc, addr, size, val, ud):
            for a in range(addr, min(addr + size, 0xC8000)):
                data[a - 0xC0000] = 1
        self.mu.hook_add(UC_HOOK_BLOCK, blk)
        self.mu.hook_add(UC_HOOK_MEM_READ, rd, None, 0xC0000, 0xC7FFF)
        return code, data
