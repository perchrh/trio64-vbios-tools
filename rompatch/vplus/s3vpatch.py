#!/usr/bin/env python3
"""s3vpatch.py - build the Trio64V+ ROM (1.03-08-p1) from the S3 Trio64V+ BIOS 1.03-08.

    python3 rompatch/vplus/s3vpatch.py 1_03_08.BIN -o S3VPP1.BIN [--size 32|64] [--mclk MHZ [--memtype edo1|fpm]]
                                       [--nasm nasm] [-q]
    make vrom OUT=S3VPP1.BIN [MCLK=55 [MEMTYPE=edo1]]

Needs python3 (no packages) and NASM 3.02, as s3patch.py (the Trio64V2 build) does; it uses the
assembler driver and the shared patch code of s3patch.py next to it.

Input
  1_03_08.BIN  the S3 Trio64V+ BIOS 1.03-08 ("S3 86C765 Video BIOS", 09/03/96), 32 KB, as in
               reference/vplus/1_03_08.bin (the upper half of the Gainward GW503A stock dump), or a
               64 KB image with it in the lower half (the upper half of the input is not used)

Output
  32 KB (--size 64: 64 KB, the upper 32 KB zeros, for a 64 KB EEPROM)

What is applied (the backport of 2.04.07-p1 to p21, docs/vplus-backport.md)
  code   assembled with nasm at the addresses in vplus/bios.inc:
         vhooks.asm  mode set hook (forget the Windows refusal, real linear base back from CR6B,
                     attribute controller flip-flop reset after the mode set); the booster (64 KB
                     linear window at A0000h in banked packed modes, on at the end of a banked 4F02
                     and at the first bank switch, not under Windows enhanced mode)
         vext.asm    fast 4F05 BH=0 at the INT 10h entry, the window set booster entry, 32-bit font
                     load and mode 13h scroll
         shared with the Trio64V2 build (rompatch/): clear32.asm (S3/VESA mode set clear), p13fill.asm,
         p13move.asm, p13bfill.asm, p13bfa.asm, p13df.asm (text and planar scrolls, AH=09h text,
         VGA mode set clear)
  MCLK   (only with --mclk) the MCLK PLL entry of --memtype, at most 60 MHz; without it the MCLK is as
         in 1.03-08 (52.79 MHz with 1-cycle EDO, 59.96 MHz with fast page or 2-cycle EDO, picked by the
         card's strapping)
  sign-on "1.03-08-p1", checksum byte 7FFF

Not applied, and why (docs/vplus-backport.md): the VCO fix (the Trio64V+ post divider R has 2 bits, at
most divide by 8, so 12.6 MHz for 10Dh-10Fh cannot come from a VCO of 135 MHz or more), the FIFO fix,
CR23/CR26, the POST delay and the DDC fixes (Trio64V2 registers or code 1.03-08 does not have), the
VBE 2.0 functions (out of scope), MCLK and the black level (card decisions).

Every byte that is replaced is compared with the expected original first; on any mismatch nothing is
written and the exit code is 1. The result is checked before it is written: the 32 KB sum to 00 and
declare 32 KB, the free block that the code does not use is still zeros, and with the known 1.03-08
image the SHA-256 of the build that passed the emulator tests.
"""
import argparse, hashlib, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
SHARED = os.path.dirname(HERE)                  # rompatch/: s3patch.py and the shared .asm files
sys.path.insert(0, SHARED)
import s3patch  # noqa: E402
from s3patch import PatchError, sig_match, call_target, jmp, call, speed_sites, mclk_put  # noqa: E402

LEVEL = 'p1'
VERSION = '1.03-08'
REF_SHA = '0da79703951db097b3cbb8f9d4041f72f6205db9a11760a58bc9820431e5dba6'   # 32 KB 1.03-08 image
RESULT_SHA = '47418ec6f2bf21b51f0c860508f20ee6fbc6fb311a5130c5dd5ae7c240de26de'  # 1.03-08-p1 (NASM 3.02), emulator tests passed
# SHA-256 (first 16 hex digits) of each assembled block in the tested build, made with NASM 3.02 (see
# s3patch.BLOCK_SHA)
BLOCK_SHA = {
    'vhooks.asm': 'f830c6adc0a588ce', 'vext.asm': 'ebc946aa9b0f79e1',
    'p13fill.asm': 'bebe3a6e43ddd275', 'p13df.asm': '7e785b4ba99b8749',
    'p13move.asm': '5f4a4e020f008747', 'p13bfill.asm': '882888314f88b876',
    'p13bfa.asm': 'bfff24ae94b812aa', 'clear32.asm': '329ca478763cce08',
}
FREE_START, FREE_END = 0x7AE0, 0x7FF0   # free in 1.03-08 from 7AD9h (zeros); 7FF0h-7FF6h: 'Cardex1'

# Patch sites in 1.03-08. The shared ones (clr ... ah09b) have the 2.04.07 signatures of s3patch.SIG,
# byte for byte; the others are 1.03-08 code.
SITES = dict(modetab=0x51DD, m4f02=0x48F9, w4f05=0x49A6, wfn=0x4996, int10=0x5217, cr59=0x102F,
             clr=0x0E50, vclr=0x1ABF, font=0x0B29, scr=0x207D, txfull=0x1D5D, txwmov=0x1D6C,
             txwfil=0x1D7E, plfull=0x1FAE, plwin=0x1FF9, ah09a=0x239A, ah09b=0x239E)
SHARED_SIG = ('clr', 'vclr', 'font', 'scr', 'txfull', 'txwmov', 'txwfil', 'plfull', 'plwin', 'ah09a', 'ah09b')
SIG = dict({k: s3patch.SIG[k] for k in SHARED_SIG},
    m4f02='60 2e 8e 1e ?? ?? e8 ?? ?? 61 c3',           # 4F02: pusha / mov ds,[cs:SEG_BDA] / call MODESET / popa / ret
    w4f05='c6 46 11 01 80 ff 01 77 0e c6 46 11 00 74 05 e8 ?? ?? eb 03 e8 ?? ?? 89 56 0a c3',  # 4F05: BH=0 calls WSET
    wfn='80 ff 01 77 0a 74 05 e8 ?? ?? eb 03 e8 ?? ?? cb',  # window function (4F01 WinFuncPtr): BH=0 calls WSET
    int10='fb fc 80 fc 0e 74 ?? 80 fc 0c 74 ?? 80 fc 0d 74 ?? 50 53 51 52 56 57 55 06 1e 8b ec',
    cr59='b0 6b e8 ?? ?? b0 59 ef 32 e4 fe c0 ef',      # mode set: CR59 = CR6B, CR5A = 00h (not patched; hook relies on it)
)
# MCLK (build option): POST picks the MCLK PLL pair (SR11 = M, then SR10 = N/R) by the strapped memory
# type, CR36 bit 3 (code at 0A3Bh): 1-cycle EDO A8h (52.79 MHz in 1.03-08), 2-cycle EDO and fast page
# A6h (59.96 MHz). The Trio64V+ limit is 60 MHz for every type (16.67 ns MCLK cycle, data book table
# 4-6, MEM-1; its feature list names 50 MHz for EDO, which 1.03-08 itself exceeds).
MCLK_ENTRY = {'edo1': 0x00A8, 'fpm': 0x00A6}
MCLK_MAX = {'edo1': 60.0, 'fpm': 60.0}

# Code at bios.inc addresses: (symbol, original bytes)
SYMSIG = [('UNLOCK', '52 50 e8 0b 00 b8 38 48 ef b8 39 a5 ef 58 5a c3'),
          ('GETCRTC', '50 ba cc 03 ec ba b4 03 a8 01 74 03 ba d4 03 58 c3'),
          ('RDREG', 'ee 42 8a e0 ec 4a 86 c4 c3'),
          ('MODESET', 'e8 ?? ?? 50 52 e8 ?? ?? b0 35 e8 ?? ?? 80 e4 cf ef'),
          ('INT_AH0E', 'e9 ?? ?? e9 ?? ?? e9 ?? ?? 8b c6 80 fc 4f'),
          ('SEG_SCR', '00 00 00 00 00 a0'),
          ('WSET', '52 53 8b da ba c4 03 b0 04 e8')]

# The new code: (file, ROM offset or the bios.inc symbol for it, bytes allowed there, labels the
# patch sites use), assembled in this order (s3patch.assemble)
BLOCKS = [
    ('vhooks.asm', 0x7AE0, 0x7BA8 - 0x7AE0, ('hook', 'h4f02', 'bon')),
    ('vext.asm', 0x7BA8, 0x7CC7 - 0x7BA8, ('int10x', 'font', 'scr13', 'wsetx')),   # calls bon
    ('p13fill.asm', 'P13A', 0x7CEA - 0x7CC7, ('wfillt', 'wfill')),
    ('p13df.asm', 'DFDN', 0x7CF2 - 0x7CEA, ('dfdn',)),
    ('p13move.asm', 'P13B', 21, ('wmove',)),               # dead: old clear loop
    ('p13bfill.asm', 'BFILL', 0x7D0B - 0x7CF2, ('bfill0', 'bfill')),
    ('p13bfa.asm', 'P13C', 14, ('bfilla',)),               # dead: old font loop
    ('clear32.asm', 'CLEAR32', 0x7D2E - 0x7D0B, ('clear',)),
]


def patch(lo, nasm='nasm', mclk=None, memtype='edo1'):
    """lo: the 32 KB 1.03-08 image; mclk: MHz for the MCLK entry of memtype (None: as 1.03-08).
    Returns (new 32 KB, log lines)."""
    d = bytearray(lo)
    log = []
    m = re.search(rb'S3 86C765 Video BIOS\. Version (\d\.\d\d-\d\d)\r\n', d[:0x100])
    if not m:
        raise PatchError('no "S3 86C765 Video BIOS. Version x.xx-xx" sign-on in the first 256 bytes')
    if m.group(1).decode() != VERSION:
        raise PatchError('BIOS version %s: only the Trio64V+ BIOS %s is supported' % (m.group(1).decode(), VERSION))
    if sum(d) & 0xFF:
        raise PatchError('the 32 KB do not checksum to 00: not a clean %s image' % VERSION)
    if d[0:3] != b'\x55\xAA\x40':
        raise PatchError('no 55AAh ROM header with 32 KB size at offset 0')
    if bytes(d[FREE_START - 7:FREE_END]) != bytes(FREE_END - FREE_START + 7):
        raise PatchError('%04X-%04X is not free (already patched?)' % (FREE_START, FREE_END - 1))
    sym = s3patch.bios_symbols(os.path.join(HERE, 'bios.inc'))
    site = SITES

    # 1. the original code must be where bios.inc and SITES say
    for k, off in site.items():
        if k in SIG and not sig_match(d, off, SIG[k]):
            raise PatchError('%s: original code not found at %04X' % (k, off))
    for k, sig in SYMSIG:
        if not sig_match(d, sym[k], sig):
            raise PatchError('%s: not found at %04X' % (k, sym[k]))
    if (call_target(d, sym['MODESET']), call_target(d, sym['MODESET'] + 5)) != (sym['UNLOCK'], sym['GETCRTC']):
        raise PatchError('the mode set at %04X does not call UNLOCK/GETCRTC' % sym['MODESET'])
    if struct.unpack_from('<H', d, site['modetab'])[0] != sym['MODESET']:
        raise PatchError('INT 10h AH=00 table entry at %04X is not the mode set' % site['modetab'])
    if call_target(d, site['m4f02'] + 6) != sym['MODESET'] or struct.unpack_from('<H', d, site['m4f02'] + 4)[0] != sym['SEG_BDA']:
        raise PatchError('VBE 4F02 does not call the mode set at %04X with DS from %04X' % (sym['MODESET'], sym['SEG_BDA']))
    if (call_target(d, site['w4f05'] + 0x0F), call_target(d, site['wfn'] + 7)) != (sym['WSET'], sym['WSET']):
        raise PatchError('4F05 and the window function do not call the window set at %04X' % sym['WSET'])
    if call_target(d, site['cr59'] + 2) != sym['RDREG']:
        raise PatchError('the mode set CR59 write at %04X does not read CR6B with RDREG' % site['cr59'])
    if struct.unpack_from('<HHH', d, sym['SEG_SCR']) != (0, 0, 0xA000) or sym['SEG_BDA'] != sym['SEG_SCR'] + 2 \
            or sym['SEG_VID'] != sym['SEG_SCR'] + 4:
        raise PatchError('SEG_SCR/SEG_BDA/SEG_VID are not the words 0000h, 0000h, A000h at %04X' % sym['SEG_SCR'])
    if struct.unpack_from('<H', d, site['clr'] + 3)[0] != sym['SEG_VID']:
        raise PatchError('mode set clear does not load ES from %04X' % sym['SEG_VID'])
    if struct.unpack_from('<H', d, site['scr'] + 0x57)[0] != sym['SEG_SCR']:
        raise PatchError('mode 13h scroll does not load DS from %04X' % sym['SEG_SCR'])
    i = site['int10'] + 2
    if (i + 3 + 2 + d[i + 4], i + 5) != (sym['INT_AH0E'], sym['INT_NEXT']):
        raise PatchError('INT 10h entry targets differ from bios.inc')
    if (site['scr'] + 6, site['scr'] + 6 + d[site['scr'] + 5]) != (sym['SCR_FULL'], sym['SCR_WIN']):
        raise PatchError('mode 13h scroll targets differ from bios.inc')
    if site['clr'] + 0x1A != sym['CLR_RET']:
        raise PatchError('mode set clear return differs from bios.inc')
    if (sym['P13B'], sym['P13C']) != (site['clr'] + 5, site['font'] + 3):
        raise PatchError('P13B/P13C are not the dead code after the clear and font load jumps')
    if not sig_match(d, 0x0A3B, 'b3 10 be a6 00 b0 36 e8 ?? ?? f6 c4 08 75 03 be a8 00 e8'):
        raise PatchError('POST does not pick the MCLK entries A6h/A8h by CR36 bit 3 at 0A3Bh')

    def put(off, old, new, why):
        old, new = (bytes.fromhex(x) if isinstance(x, str) else bytes(x) for x in (old, new))
        if bytes(d[off:off + len(old)]) != old:
            raise PatchError('%04X: expected %s, found %s (%s)' % (off, old.hex(' '), d[off:off + len(old)].hex(' '), why))
        d[off:off + len(new)] = new
        log.append('%04X  %-17s -> %-17s %s' % (off, old.hex(' '), new.hex(' '), why))

    # 2. code
    blocks, lab = s3patch.assemble(sym, nasm, (HERE, SHARED), BLOCKS)
    patch.blocks = blocks
    for off, code, name in blocks:
        if off >= FREE_START and off + len(code) > FREE_END:
            raise PatchError('%s does not fit the free block' % name)
        d[off:off + len(code)] = code
        log.append('%04X-%04X  %-12s %s' % (off, off + len(code) - 1, name,
                   ', '.join('%s %04X' % (k, lab[k]) for b in BLOCKS if b[0] == name for k in b[3])))

    a = site['modetab']
    put(a, struct.pack('<H', sym['MODESET']), struct.pack('<H', lab['hook']), 'INT 10h AH=00 table: mode set via the hook')
    a = site['m4f02'] + 6
    put(a, d[a:a + 3], call(a, lab['h4f02']), 'VBE 4F02: mode set via the hook, then the booster unless Windows runs')
    speed_sites(d, put, site, sym, lab, tags=False)
    if mclk is not None:
        mclk_put(d, put, MCLK_ENTRY, memtype, mclk, MCLK_MAX[memtype])

    # 3. sign-on and checksum
    s = m.start(1)
    end = d.index(b'\x00', s)
    txt = bytes(d[s:end]).replace(VERSION.encode(), (VERSION + '-' + LEVEL).encode(), 1)
    stop = end
    while stop < 0x100 and d[stop] == 0:
        stop += 1
    if s + len(txt) + 1 > stop:
        raise PatchError('no room for the longer sign-on')
    d[s:s + len(txt) + 1] = txt + b'\x00'
    log.append('%04X  sign-on "%s"' % (s, txt.split(b'\r')[0].decode()))
    d[0x7FFF] = 0
    d[0x7FFF] = (-sum(d)) & 0xFF
    log.append('7FFF  checksum %02X -> %02X' % (lo[0x7FFF], d[0x7FFF]))
    return bytes(d), log


def used_ranges(sym):
    """The bytes the blocks may use: [(start, end)]."""
    return [((sym[o] if isinstance(o, str) else o), (sym[o] if isinstance(o, str) else o) + room)
            for _, o, room, _ in BLOCKS]


def verify(img, size):
    errs = []
    if len(img) != size * 1024:
        errs.append('image is %d bytes, not %d' % (len(img), size * 1024))
    if sum(img[:0x8000]) & 0xFF:
        errs.append('the 32 KB checksum is not 00')
    if img[0x8000:] != bytes(len(img) - 0x8000):
        errs.append('upper 32 KB is not all zeros')
    if img[0:3] != b'\x55\xAA\x40':
        errs.append('ROM header 55AAh with 32 KB size missing')
    sym = s3patch.bios_symbols(os.path.join(HERE, 'bios.inc'))
    used = set(i for a, b in used_ranges(sym) for i in range(a, b))
    stray = [i for i in range(FREE_START, FREE_END) if img[i] and i not in used]
    if stray:
        errs.append('free block not zeros outside the code: %s' % ', '.join('%04X' % i for i in stray[:8]))
    return errs


def diagnose(nasm, output, img):
    """As s3patch.diagnose, with the blocks of this build."""
    try:
        v = s3patch.subprocess.run([nasm, '-v'], capture_output=True, text=True).stdout.strip()
    except OSError:
        v = '(nasm -v failed)'
    out = ['assembler: %s (the tested build used NASM %s)' % (v or '?', s3patch.TESTED_NASM)]
    diff = [n for _, c, n in getattr(patch, 'blocks', []) if hashlib.sha256(c).hexdigest()[:16] != BLOCK_SHA.get(n)]
    out.append('blocks assembled differently: %s' % ', '.join(diff) if diff else
               'every block is as in the tested build: the difference is in the patch sites')
    with open(output + '.untested', 'wb') as f:
        f.write(img)
    out.append('the untested image is in %s.untested; do not flash it' % output)
    return out


def main():
    ap = argparse.ArgumentParser(description='build %s-%s from the S3 Trio64V+ BIOS %s' % (VERSION, LEVEL, VERSION))
    ap.add_argument('input', help='the Trio64V+ BIOS 1.03-08: 32 KB, or a 64 KB image with it in the lower half')
    ap.add_argument('-o', '--output', required=True, help='the result (32 KB, or 64 KB with --size 64)')
    ap.add_argument('--size', type=int, choices=(32, 64), default=32, help='output size in KB (64: zeros above)')
    ap.add_argument('--mclk', type=float, help='MCLK in MHz for the memory type of --memtype, at most 60 '
                    '(default: as 1.03-08, 52.79 for 1-cycle EDO, 59.96 for fast page/2-cycle EDO)')
    ap.add_argument('--memtype', choices=sorted(MCLK_ENTRY), default='edo1',
                    help='the MCLK entry --mclk sets: edo1 (1-cycle EDO) or fpm (fast page and 2-cycle EDO)')
    ap.add_argument('--nasm', default='nasm', help='nasm executable (default: nasm on PATH)')
    ap.add_argument('-q', '--quiet', action='store_true', help='print only the result line')
    a = ap.parse_args()
    try:
        src = open(a.input, 'rb').read()
        if len(src) not in (0x8000, 0x10000):
            raise PatchError('input is %d bytes; expected 32768 or 65536' % len(src))
        lo = src[:0x8000]
        new_lo, log = patch(lo, a.nasm, a.mclk, a.memtype)
        img = new_lo + bytes(0x8000 if a.size == 64 else 0)
        errs = verify(img, a.size)
        known = hashlib.sha256(lo).hexdigest() == REF_SHA and RESULT_SHA and a.mclk is None
        out_sha = hashlib.sha256(new_lo).hexdigest()
        if known and out_sha != RESULT_SHA:
            errs.append('result differs from the tested build (SHA-256 of the 32 KB %s, expected %s)' % (out_sha, RESULT_SHA))
            errs += diagnose(a.nasm, a.output, img)
        if errs:
            raise PatchError('result check failed:\n  ' + '\n  '.join(errs))
    except (PatchError, OSError) as e:
        print('s3vpatch: %s' % e, file=sys.stderr)
        return 1
    with open(a.output, 'wb') as f:
        f.write(img)
    if not a.quiet:
        ref = hashlib.sha256(lo).hexdigest() == REF_SHA
        print('base %s%s' % (VERSION, ' (the known 1.03-08 image)' if ref else ''))
        for line in log:
            print('  ' + line)
    print('%s: %s-%s, %d KB, checksum %02X (the lower 32 KB sums to 00), SHA-256 of the 32 KB %s%s'
          % (a.output, VERSION, LEVEL, a.size, img[0x7FFF], out_sha,
             ', identical to the tested build' if known or out_sha == RESULT_SHA else
             ', MCLK build option: the code is the tested build, the MCLK is yours to check on the card'
             if a.mclk is not None else ''))
    return 0


if __name__ == '__main__':
    sys.exit(main())
