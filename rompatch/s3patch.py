#!/usr/bin/env python3
"""s3patch.py - build the current ROM (2.04.07-p22) from the S3 Trio64V2/DX reference BIOS 2.04.07.

    python3 rompatch/s3patch.py REF2047.BIN -o S3V2P22.BIN [--no-vco-fix] [--mclk MHZ [--memtype edo1|fpm|sgram]]
                                [--nasm nasm] [-q]
    make 775-rom IN=REF2047.BIN OUT=S3V2P22.BIN [MCLK=55 [MEMTYPE=edo1]]

Needs python3 (no packages) and NASM 3.02 (another version may encode some instructions differently).

Input
  REF2047.BIN  the S3 reference BIOS 2.04.07 (86C775/86C785), 32 KB, or a 64 KB image with it in the
               lower half (the upper half of the input is not used)

Output
  64 KB: the patched 32 KB twice, so that a board which maps the upper half of its 64 KB EEPROM finds
  the BIOS as well as one that maps the lower half, as the Trio64 and Trio64V+ ROMs do (#78). The
  Gainward GW503A maps the lower half. The PCI ROM header declares one 32 KB image, the last one, so
  firmware that reads the ROM through PCI ignores the copy. (p15 to p21 had zeros in the upper half,
  p14 and earlier the card's Trio64V+ BIOS 1.03-08.)

What is applied (docs/775-rom.md of trio64-vbios-tools, "Features and changes compared to the reference BIOS 2.04.07" and "Byte-level changes")
  data   MCLK 59.96 MHz, POST flags 05h (blank pedestal off, the board flags of the card), CR80 POST
         value 00h, CR41/CR52 60 Hz defaults for 1280x1024 and 1600x1200, 640x480 line total 800,
         320x240 @ 60 Hz CRTC tables and refresh entries, CR50 for 512x384, 1600x1200 vertical display
         end (1200 lines, the reference has 1201)
  code   assembled with nasm from the .asm files next to this script, at the addresses in bios.inc:
         p12ext.asm (fast 4F05, 32-bit font load, 32-bit mode 13h scroll), crtc240.asm (320x240 CRTC
         tables), hooks.asm (mode set hook with LFB base restore, FIFO fix and ATC flip-flop reset;
         booster, on at the end of a banked 4F02 (p18) and at the first bank switch (p16); LFB base and linear test fixes), vbe4f06.asm (4F06 BL=3), clear32.asm (32-bit S3/VESA
         mode set clear), p13*.asm (32-bit text and planar scroll fills, text window moves, AH=09h);
         p14: the VGA mode set clear in place as a jump to wfill
  VCO    (unless --no-vco-fix) the 22 refresh entries whose DCLK PLL runs its VCO below 170 MHz get a
         larger post divider R and new M/N for exactly the same pixel clock, VCO in 170-340 MHz. The data
         book allows 135-340 MHz (the result check uses that); 170 MHz is XFree86's minimum, kept here
         because the ROM was built and tested with it
  p16    the booster no longer at the end of VBE 4F02 (the reference instruction stays at 56F7h): the
         window set at 584Bh (4F05 BH=0 slow path and the window function) and the fast 4F05 path call
         it, so a banked 4F02 leaves CR58-CR5A as the reference does (S3 Windows 9x driver)
  p17    no booster while Windows runs in enhanced mode (INT 2Fh AX=1600h, asked once per mode
         set, wincheck.asm in the free bytes 7C8B-7CFA): Windows 98's S3 driver restores a full-screen
         DOS box with the booster on with a MISC the monitor cannot show
  p18    the booster on again at the end of a banked VBE 4F02 (as up to p15), still refused under
         Windows enhanced mode: in plain DOS every bank switch path gets it (INT 10h 4F05, the window
         function, the 4F0A protected-mode code, direct CR6A writes), not only the first two
  p19    as the S3 BIOS 2.04.11: the DDC delay of VBE 4F15 (ddcwait.asm in place at 5F4E) sets PIT
         channel 2 with B6h, the 4F15 probe passes its 0255h delay in AX (5E07), and interrupts are off
         for the whole 4F15 operation (p19.asm: ddcin, ddcout); every mode set writes CR23 = 00h before
         CR26 = 00h (p19.asm: cr2326, Trio64V2 datasheet section 4.2)
  p20    POST passes its delay before the graphics engine reset in AX (14E2): the delay with RAM
         refresh off (CR88 bit 6) is 0Ah PIT clocks (8 us) as S3 meant, not the CR88 word left in AX
         (4088h, 13.8 ms); 2.04.07 and 2.04.11 both load BX there
  p21    the 32-bit mode 13h scroll (p12ext.asm scr13) keeps EAX: AH=0Eh reaches it without the
         dispatcher that saves the 32-bit registers, and a line feed on the last row returned EAX bits
         31-16 = 0000h
  MCLK   (only with --mclk) the MCLK PLL entry POST uses for --memtype, the memory type the card is
         strapped for (CR36 bits 3-2): edo1 at most 60 MHz, fpm (fast page and 2-cycle EDO) and sgram at
         most 66.67 MHz (V2-MEM-1); without it 59.96 MHz for edo1 and fpm, 66.2 MHz for sgram. The code
         is the tested build either way; the result SHA-256 is checked only without --mclk
  sign-on "2.04.07-p22", checksum byte 7FFF

Every byte that is replaced is compared with the expected original first; on any mismatch nothing is
written and the exit code is 1. The result is checked before it is written: the lower 32 KB sums to 00
and declares 32 KB, the upper 32 KB is a copy of it, every DCLK VCO in the data book's 135-340 MHz (unless --no-vco-fix),
and with the known reference image the SHA-256 (of the lower 32 KB) of the build that passed the
emulator tests.
"""
import argparse, hashlib, os, re, shutil, struct, subprocess, sys, tempfile



def rom_level(name, version):
    """The level (pN) of one of our ROMs from common/version.inc, the one place the ROM levels are kept:
    `%define NAME 'VERSION-pN'` with NAME = VER775 (Trio64V2), VER765 (Trio64V+) or VER764 (Trio64).
    The patchers write it into the sign-on; S3TEST, built from the same file, expects it."""
    inc = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'common', 'version.inc')
    m = re.search(r"^%%define %s '%s-(p\d+)'" % (name, re.escape(version)), open(inc).read(), re.M)
    if not m:
        raise SystemExit('%s: no line %%define %s \'%s-pN\'' % (inc, name, version))
    return m.group(1)


VERSION = '2.04.07'
LEVEL = rom_level('VER775', VERSION)            # the sign-on level: common/version.inc VER775
REF_SHA = '25d64cd7cbefdf756e2bdce53de2c308c553fc69fb203fdae72f1fa4e6805337'    # 32 KB reference image
RESULT_SHA = '5e53224067199327bc211cc269578c36399eafa746e15e64230ac192c6aaa041'  # 2.04.07-p22 (NASM 3.02), emulator tests passed;
# the SHA-256 of the lower 32 KB, as in s3tpatch.py and s3vpatch.py (p21, until the upper half became a copy,
# #78, it was taken over the 64 KB with zeros above: 515bf9fe..., the same lower 32 KB)
# SHA-256 (first 16 hex digits) of each assembled block in the tested build, made with NASM 3.02: when
# the result differs, these name the blocks another assembler encoded differently (NASM 2.16.01 puts
# the REP prefix before the operand-size prefix in REP MOVSD/STOSD, 3.02 after it)
BLOCK_SHA = {
    'wincheck.asm': 'd885136ca6b113c3', 'p19.asm': 'b778a484de923cb0',
    'ddcwait.asm': 'c8494a1b6d4144f2', 'hooks.asm': 'e33cecbd0d98ec75',
    'p12ext.asm': 'b16a86f728fb3f8c', 'crtc240.asm': 'c82f2ec50dacb61d',
    'vbe4f06.asm': 'bdd213f1622291bb', 'clear32.asm': '28a181904074b700',
    'p13df.asm': '7e785b4ba99b8749', 'p13fill.asm': 'a81b8264916f413c',
    'p13move.asm': 'a9696e8fdb426c67', 'p13bfill.asm': '973ba6c5bf3d0cff',
    'p13bfa.asm': 'a4192aa0cbf344d3',
}
TESTED_NASM = '3.02'
FREE_START, FREE_END = 0x7C8B, 0x7FE3   # free space the new code uses (end exclusive); 7C89-7C8A: the word count of the descender glyph load at 3FC7
HERE = os.path.dirname(os.path.abspath(__file__))


class PatchError(Exception):
    pass


def bios_symbols(path=os.path.join(HERE, 'bios.inc')):
    """The addresses in bios.inc ('%define NAME 0xVALUE')."""
    sym = {}
    for line in open(path):
        m = re.match(r'%define\s+(\w+)\s+0x([0-9A-Fa-f]+)', line)
        if m:
            sym[m.group(1)] = int(m.group(2), 16)
    return sym


# Patch sites in 2.04.07 and the original code at each ('??' = any byte, relative addresses). The
# replaced routines are matched in full, so the new code does what the old one did.
SITES = dict(modetab=0x20D3, m4f02=0x56D9, boost=0x56F7, bl3=0x59B7, base=0x5CCD, lfb=0x5CE9,
             clr=0x143D, int10=0x210D, vclr=0x2C29, font=0x1224, scr=0x31F5, memsize=0x1B0F,
             old4f06=0x59C0, txfull=0x2ED5, txwmov=0x2EE4, txwfil=0x2EF6, plfull=0x3126,
             plwin=0x3171, ah09a=0x3512, ah09b=0x3516, cr26=0x1A62, ddcin=0x5D01, ddcout=0x5D53,
             ddcax=0x5E07, postdly=0x14E1)
SIG = dict(
    m4f02='8e 1e ?? ?? e8 ?? ?? 61 8a d8 24',            # mov ds,[cs:SEG_BDA] / call MODESET
    boost='c7 06 fe 04 00 00 c3 c6 46 1b 01',            # mov word [4FEh],0 / ret
    bl3='0e b4 00 c3 b8 ff 03 33 d2 8b da 8a 5c',        # 4F06 BL=3: mov ax,3FFh / xor dx,dx
    base='8a dc 8b c3 0b c0 74 06 5e 5f 5a 59',          # mov ax,bx / or ax,ax
    lfb='58 e8 ?? ?? 25 00 10 5a 58 c3 c6 46 1b 00',     # and ax,1000h
    clr='2e 8e 06 ?? ?? 33 ff 50 51 b9 00 80 33 c0 f3 ab 59 58 fe c4 ef e2 e9 b4 00 ef 1f 07 61 c3',
    int10='fb fc 80 fc 0e 74 42 80 fc 0c 74 40 80 fc 0d 74 3e 66 50',
    vclr='b7 a0 b5 80 32 db 8e c3 33 ff f3 ab c3',       # VGA clear: ES = BX (BL = 0), rep stosw from 0
    font='50 51 8a cf 32 ed f3 a4 59 03 fa e2 f4 0c ff 58 c3',
    scr='3b 0e 4a 04 75 27 8b d8 8a c1 f6 e6 f7 26 85 04 8b c8 c1 e1 02 b8 00 a0 8e c0 8e d8 f3 a5 '
        '8b cb d1 e9 8a 46 03 8a e0 f3 ab 83 c4 04 c3 c1 e3 03 c1 e1 02 a0 85 04 f6 e6 52 8b d0 b8 '
        '00 a0 8e d8 8e c0 0b d2 74 0d 8b c1 f3 a5 8b c8 03 f3 03 fb 4a 75 f3 5a 2e 8e 1e ?? ?? a0 '
        '85 04 f6 e2 8b d0 8a 46 03 8a e0 8b f1 f3 ab 03 fb 8b ce 4a 75 f5',
    memsize='50 e8 ?? ?? e8 ?? ?? b0 36 e8 53 06',       # call UNLOCK / call GETCRTC / mov al,36h / call RDREG
    old4f06='8b da 8a 5c 09 f7 e3 8b c8 e8 ?? ?? 33 c0 8b 5c 05 f7 f3 3b c1 77 02 8b c8 89 4e 12 c1 e8 03 '
            '89 46 16 c7 46 0e 00 00 eb cf',             # the old 4F06 BL=3 routine (dead after p8)
    txfull='8b cb b0 20 8a 66 03 f3 ab eb 27',              # text scroll full width: blank fill, jmp
    txwmov='51 56 8b c7 f3 a5 8b f8 5e 59 03 f3 03 fb fe ce 75 ee',   # text window: line moves
    txwfil='b0 20 8a 66 03 51 57 f3 ab 5f 59 03 fb fe ca 75 f4',      # text window: blank lines
    plfull='33 c0 f3 aa ef fe c0 ef 83 c4 04 c3',          # planar full width: set/reset fill
    plwin='33 c0 8b f1 f3 aa 03 fb 8b ce 4a 75 f5 ba ce 03',  # planar window: fill lines
    ah09a='97 f3 ab c3',                                   # AH=09h text: char/attribute words
    ah09b='e8 ?? ?? f3 ab c3',                             # AH=09h text, page > 0
    cr26='b8 26 00 ef 33 c0 ba c4 03 ec',                  # mode set: CR26 = 00h (mov ax,0026h / out dx,ax)
    ddcin='e8 ?? ?? b0 53 e8 ?? ?? 50 80 cc 10 ef',        # 4F15: call GETCRTC / CR53 bit 4 (MMIO) on
    ddcout='58 e8 ?? ?? 1f c3',                            # 4F15 end: pop ax / call SR0DRST / pop ds / ret
    ddcax='bb 55 02 e8 ?? ??',                             # 4F15 probe: mov bx,0255h / call DDCWAIT
    postdly='53 bb 0a 00 e8 ?? ?? 5b b8 66 02 ef',         # POST: push bx / mov bx,000Ah / call DDCWAIT / pop bx / CR66 = 02h
)
# Code at bios.inc addresses: (symbol, original bytes)
SYMSIG = [('UNLOCK', '52 50 e8 0b 00 b8 38 48 ef b8 39 a5 ef 58 5a c3'),
          ('GETCRTC', '50 ba cc 03 ec ba b4 03 a8 01 74 03 ba d4 03 58 c3'),
          ('RDREG', 'ee 42 8a e0 ec 4a 86 c4 c3'),
          ('INT_AH0E', 'e9 ?? ?? e9 ?? ?? e9 ?? ?? 8b c6 80 fc 4f'),
          ('SEG_SCR', '00 00 00 00 00 a0'),
          ('DFDN', '00 00 00 00 00 00 00 00'),
          ('WSET', '52 53 8b da ba c4 03 b0 04 e8'),
          ('SR0DRST', '52 ba c4 03 ef 5a c3'),
          # the 2.04.07 DDC delay, replaced in full by ddcwait.asm (p19)
          ('DDCWAIT', '50 53 51 52 57 8b d8 83 fb 00 74 49 d1 e3 72 45 ba 61 00 ec 8a c8 0c 01 ee e8 3f 00 '
                      '8b f8 9c fa b0 86 e6 43 e4 80 b0 00 e6 42 e6 42 e4 80 9d e8 29 00 8b d0 e8 24 00 f7 d8 '
                      '03 c2 3b c3 72 f5 b0 86 e6 43 e4 80 8b c7 e6 42 86 c4 e6 42 e4 80 ba 61 00 8a c1 ee 5f '
                      '5a 59 5b 58 c3 9c fa b0 80 e6 43 e4 80 e4 42 86 c4 e4 42 86 c4 9d c3')]

# Data patches: (offset, old, new, purpose)
DATA = [
    (0x00C7, '28 41', '41 42', 'MCLK PLL at POST: SR11 = 41h, SR10 = 42h (59.96 MHz)'),
    (0x00D1, '02', '05', 'POST flags: blank pedestal off (bit 1), the card\'s board flags (bits 0 and 2)'),
    (0x00D3, '10', '00', 'CR80 POST value 00h, as on the card'),
    (0x00DE, '08 80', '88 81', 'CR41/CR52 refresh fields: 1280x1024 and 1600x1200 default 60 Hz'),
    (0x04C1, '5e 4f 50 81', '5f 4f 50 82', '640x480x8/x32 @ 60 Hz: line total 800'),
    (0x089F, 'c1 03 82 48 33', '40 7e 82 3c 28', '320x240x8 refresh entry: CRTC table 7E40h, 60 Hz, 25.06 MHz'),
    (0x08AD, 'f5 0c 82 48 33', '60 7e 82 3c 28', '320x240x15/16 refresh entry: CRTC table 7E60h, 60 Hz'),
    (0x095C, '60', '40', 'CR50 for 512x384x8/x32'),
    (0x0B1A, 'c2 9f a0 85', 'c3 9f a0 86', '640x480x15/16 @ 60 Hz: line total 800'),
    (0x0CEE, 'b0', 'af', '1600x1200 @ 60 Hz: CR12 vertical display end AFh, 1200 lines (the reference has 1201)'),
]

# The new code: (file, ROM offset or the bios.inc symbol for it, bytes allowed there, labels the
# patch sites use). Each file is assembled with -DL_<label> for the labels of the files before it.
BLOCKS = [
    ('wincheck.asm', 0x7C8B, 0x7CC8 - 0x7C8B, ('wcheck', 'wclear', 'lfbchk')),   # p17
    ('p19.asm', 0x7CC8, 0x7CFB - 0x7CC8, ('cr2326', 'ddcin', 'ddcout')),
    ('ddcwait.asm', 'DDCWAIT', 0x6D, ('ddcwait',)),         # in place of the 2.04.07 DDC delay
    ('hooks.asm', 0x7E80, 0x7F58 - 0x7E80, ('hook', 'bon', 'basefix')),          # calls wincheck.asm
    ('p12ext.asm', 0x7CFB, 0x7E40 - 0x7CFB, ('int10x', 'font', 'scr13', 'wsetx', 'b4f02')),  # calls bon (hooks.asm)
    ('crtc240.asm', 0x7E40, 0x40, ('crtc8', 'crtc16')),
    ('vbe4f06.asm', 0x7F71, 0x7FAF - 0x7F71, ('bl3',)),
    ('clear32.asm', 'CLEAR32', 0x7FE3 - 0x7FC0, ('clear',)),
    ('p13df.asm', 'DFDN', 0x7FC0 - 0x7FAF, ('dfdn',)),
    ('p13fill.asm', 'P13A', 41, ('wfillt', 'wfill')),      # dead: old 4F06 BL=3 code
    ('p13move.asm', 'P13B', 21, ('wmove',)),               # dead: old clear loop (p11)
    ('p13bfill.asm', 'BFILL', 0x7F71 - 0x7F58, ('bfill0', 'bfill')),
    ('p13bfa.asm', 'P13C', 14, ('bfilla',)),               # dead: old font loop (p12)
]


def hexb(s):
    return bytes.fromhex(s)


def sig_match(img, off, sig):
    toks = sig.split()
    if off < 0 or off + len(toks) > len(img):
        return False
    return all(t == '??' or img[off + i] == int(t, 16) for i, t in enumerate(toks))


def rel16(at, length, to):
    return struct.pack('<h', to - (at + length))


def call_target(img, at):
    assert img[at] == 0xE8
    return (at + 3 + struct.unpack_from('<h', img, at + 1)[0]) & 0xFFFF


def assemble(sym, nasm, srcdirs=(HERE,), blocks=None):
    """Assemble the blocks (default BLOCKS). Each file is taken from the first of srcdirs that has it,
    and '%include "bios.inc"' finds the bios.inc of the first directory (NASM searches the -i paths
    in order), so the Trio64V+ patcher (vplus/s3vpatch.py) can assemble the shared files here with
    its own addresses. Returns [(offset, bytes, file)] and the labels."""
    tmp = tempfile.mkdtemp(prefix='s3patch_')
    if os.sep in nasm or '/' in nasm:       # NASM runs in tmp: a relative path must not depend on it
        nasm = os.path.abspath(nasm)
    srcdirs = [os.path.abspath(d) for d in srcdirs]
    try:
        out, labels = [], {}
        for name, org, room, want in BLOCKS if blocks is None else blocks:
            org = sym[org] if isinstance(org, str) else org
            src = next((os.path.join(d, name) for d in srcdirs if os.path.exists(os.path.join(d, name))), None)
            if src is None:
                raise PatchError('%s not found in %s (keep the .asm files and bios.inc next to the patcher)'
                                 % (name, ', '.join(srcdirs)))
            binf, mapf = os.path.join(tmp, name + '.bin'), os.path.join(tmp, name + '.map')
            with open(os.path.join(tmp, name), 'w') as f:  # the source plus a map file for the labels
                f.write('%%include "%s"\n[map symbols %s]\n' % (src.replace('\\', '/'), mapf.replace('\\', '/')))
            cmd = [nasm, '-f', 'bin'] + ['-i' + d + os.sep for d in srcdirs] + ['-o', binf] + \
                  ['-DL_%s=0x%04X' % kv for kv in sorted(labels.items())] + [os.path.join(tmp, name)]
            try:
                # in the temporary directory: NASM looks for an %include in the current directory
                # before the -i paths, so a bios.inc where the patcher is started must not count
                r = subprocess.run(cmd, capture_output=True, text=True, cwd=tmp)
            except OSError as e:
                raise PatchError('cannot run nasm (%s): %s' % (nasm, e))
            if r.returncode:
                raise PatchError('nasm failed on %s:\n%s' % (name, r.stderr))
            code = open(binf, 'rb').read()
            got = {}
            for line in open(mapf):
                p = line.split()
                if len(p) == 3 and re.fullmatch(r'[0-9A-Fa-f]+', p[0]):
                    got[p[2]] = int(p[0], 16)
            for k in want:
                if k not in got:
                    raise PatchError('%s: label %s missing' % (name, k))
                labels[k] = got[k]
            if got[want[0]] != org:
                raise PatchError('%s: assembled at %04X, expected %04X' % (name, got[want[0]], org))
            if len(code) > room:
                raise PatchError('%s: %d bytes, only %d free at %04X' % (name, len(code), room, org))
            out.append((org, code, name))
        out.sort()
        for (o1, c1, n1), (o2, c2, n2) in zip(out, out[1:]):
            if o1 + len(c1) > o2:
                raise PatchError('%s overlaps %s' % (n1, n2))
        return out, labels
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


# ------------------------------------------------------------------ DCLK PLL
# Trio64V2 DCLK PLL (docs/chip-rules.md): f = 14.31818 MHz * (M+2) / ((N+2) * 2^R) with M 1-127 and N
# 1-31 (PLL-2), R in SR12 bits 6-5 plus bit 7 as the third bit, of which only 100b (divide by 16) is
# defined among the codes with bit 7 set (V2-PLL-3).
def rcode(nr):
    return ((nr >> 5) & 3) | (4 if nr & 0x80 else 0)


def pll(m, nr):
    vco = 14.31818 * (m + 2) / ((nr & 0x1F) + 2)
    return vco, vco / (1 << rcode(nr))


def pll_rule(m, nr):
    """None when the M and N/R bytes follow the datasheet, else what is wrong."""
    if not 1 <= m <= 0x7F:
        return 'M = %d (1-127)' % m
    if not nr & 0x1F:
        return 'N = 0 (1-31)'
    if nr & 0x80 and nr & 0x60:
        return 'reserved R code %s' % format(nr >> 5, '03b')
    return None


def refresh_entries(img):
    """The refresh entries of the S3 mode table at 0158h: 9 bytes per mode (mode, VGA parameter pointer,
    4 flag bytes, refresh list pointer). A list has 14-byte entries (CRTC table pointer, refresh index
    in bits 2-0 of byte 2, Hz, PLL M, N/R, ...); the pointer gives its last (highest refresh) entry and
    the list runs downwards to the entry with bit 7 of byte 2 set."""
    seen, o = [], 0x158
    while o < 0x400 and img[o] != 0xFF:
        r = struct.unpack_from('<H', img, o + 7)[0]
        if 0x100 <= r < 0x7F00:
            e = r
            for _ in range(16):
                if e not in seen:
                    seen.append(e)
                if img[e + 2] & 0x80:
                    break
                e -= 14
        o += 9
    return sorted(seen)


def vco_fix(d, log, lo=170.0):
    n = 0
    for e in refresh_entries(d):
        m, nr = d[e + 4], d[e + 5]
        vco, f = pll(m, nr)
        if vco >= lo:
            continue
        r, nn = rcode(nr), nr & 0x1F         # r = 4 (bit 7): no larger R left, refused below
        best = None                         # same pixel clock: (M'+2)/(N'+2)/2^R' = (M+2)/(N+2)/2^R
        for r2 in range(r + 1, 4):
            for n2 in range(1, 32):
                num = (m + 2) * (n2 + 2) * (1 << (r2 - r))
                if num % (nn + 2) == 0 and 1 <= num // (nn + 2) - 2 <= 0x7F:
                    m2 = num // (nn + 2) - 2
                    if lo <= pll(m2, n2 | (r2 << 5))[0] <= 340:
                        best = best or (m2, n2, r2)   # smallest R', then smallest N'
        if not best:
            raise PatchError('refresh entry %04X: no M/N/R with the same clock %.3f MHz and the VCO in range' % (e, f))
        m2, n2, r2 = best
        nr2 = (r2 << 5) | n2                 # r2 <= 3: bit 7 stays clear
        d[e + 4], d[e + 5] = m2, nr2
        v2, f2 = pll(m2, nr2)
        assert abs(f2 - f) < 1e-9
        log.append('%04X  %02X %02X -> %02X %02X  DCLK %.2f MHz %3d Hz: VCO %.1f -> %.1f MHz'
                   % (e + 4, m, nr, m2, nr2, f, d[e + 3], vco, v2))
        n += 1
    return n


# ------------------------------------------------------------------ MCLK (build option)
# POST picks the MCLK PLL pair (SR11 = M, then SR10 = N/R) by the memory type the card is strapped for
# (CR36 bits 3-2, code at 14A5h): 1-cycle EDO C7h, 2-cycle EDO and fast page C9h (bit 3 set), SGRAM
# CBh (01b, the Trio64V2/GX). --mclk sets the entry of --memtype; the others stay. The limits are the
# Trio64V2 data book's (V2-MEM-1): 60 MHz for 1-cycle EDO, 66 MHz (15 ns) for fast page and SGRAM; it
# gives no separate value for 2-cycle EDO, which shares the fast page entry.
MCLK_ENTRY = {'edo1': 0x00C7, 'fpm': 0x00C9, 'sgram': 0x00CB}
MCLK_MAX = {'edo1': 60.0, 'fpm': 66.67, 'sgram': 66.67}
MCLK_MIN = 40.0     # no data book minimum; a guard against typing errors (2.04.07's own lowest is 50.11)
FREF = 14.31818


# MCLK PLL pairs (SR10 N/R byte, SR11 M byte, images) that the Trio32/Trio64/Trio64V+ BIOS images at hand
# (PCI 5333:8811: Phoenix, Diamond, ELSA, Hercules, Number Nine, Octek, S3) load at POST, from the survey
# in docs/764-rom.md ("The MCLK of the BIOS images at hand"). Left out: Diamond's 40h 1Dh (N = 0,
# PLL-2) and the Trio32's 23h 28h (VCO 120.3 MHz, below 135 MHz, PLL-1).
KNOWN_MCLK_8811 = [
    (0x42, 0x41, 9),        # 59.96 MHz: Phoenix 1.5-06 and Trio64V+ 1.01-05/1.02-02, Diamond, ELSA, Hercules
    (0x46, 0x79, 3),        # 55.04 MHz: Phoenix 1.3-08 and 1.5-07 builds
    (0x42, 0x38, 3),        # 51.90 MHz: Phoenix 1.3-08 and 1.4-04 (Trio32, Trio64)
    (0x41, 0x2C, 2),        # 54.89 MHz: Phoenix 1.5-07 CP764 (our reference), Diamond Stealth64 Video
    (0x42, 0x39, 2),        # 52.80 MHz: Phoenix 1.4-04 (DSP3332P), S3 1.03-08 (Trio64V+)
    (0x22, 0x25, 2),        # 69.80 MHz: Phoenix 1.5-07 "764 M70" (the DSP-3364P)
    (0x41, 0x2A, 1),        # 52.50 MHz: Phoenix 1.5-07 VIEWTOP
    (0x41, 0x2B, 1),        # 53.69 MHz: Phoenix 1.5-04 (miroCRYSTAL)
    (0x42, 0x3C, 1),        # 55.48 MHz: Phoenix 1.5-07
    (0x41, 0x2E, 1),        # 57.27 MHz: Phoenix Trio64V+ 1.01-05 (Octek)
    (0x42, 0x3E, 1),        # 57.27 MHz: Number Nine
    (0x45, 0x74, 1),        # 60.34 MHz: ELSA 1.02.00
]
KNOWN_TOLERANCE = 0.5       # MHz: a known pair this close to the request is taken instead of the computed one


def mclk_pll(target, fmax, fmin=MCLK_MIN, known=()):
    """The MCLK PLL setting for target MHz, at most fmax: (M, N/R byte, MHz, VCO MHz, source). With known
    (a list like KNOWN_MCLK_8811), a pair other BIOSes of the chip use is taken when it is within
    KNOWN_TOLERANCE MHz of target and inside the limits: the closest, then the one more images use.
    Otherwise the closest setting the PLL allows: R 0-3 in SR10 bits 6-5 (bit 7 reserved, V2-PLL-3),
    M 1-127, N 1-31 (PLL-2) and its VCO in 135-270 MHz (PLL-1; the Trio64V2 raises only the DCLK PLL
    maximum). Ties: the smaller N, then R."""
    if not fmin <= target <= fmax:
        raise PatchError('MCLK %.2f MHz: outside %.2f-%.2f MHz' % (target, fmin, fmax))
    cand = []
    for nr, m, uses in known:
        n, r = nr & 0x1F, (nr >> 5) & 3
        vco = FREF * (m + 2) / (n + 2)
        f = vco / (1 << r)
        if not nr & 0x80 and 1 <= n and 1 <= m <= 127 and 135 <= vco <= 270 and fmin <= f <= fmax + 1e-9 \
                and abs(f - target) <= KNOWN_TOLERANCE:
            cand.append(((round(abs(f - target), 3), -uses), m, nr, f, vco, uses))
    if cand:
        k, m, nr, f, vco, uses = min(cand)
        return m, nr, f, vco, 'the pair of %d BIOS image%s at hand' % (uses, 's' if uses > 1 else '')
    best = None
    for r in range(4):
        for n in range(1, 32):
            for m in range(1, 128):
                vco = FREF * (m + 2) / (n + 2)
                f = vco / (1 << r)
                if 135 <= vco <= 270 and fmin <= f <= fmax + 1e-9:
                    key = (abs(f - target), n, r)
                    if best is None or key < best[0]:
                        best = (key, m, (r << 5) | n, f, vco)
    if best is None:
        raise PatchError('MCLK %.2f MHz: no PLL setting in range' % target)
    return best[1:] + ('computed',)


def mclk_put(d, put, entries, memtype, mhz, fmax, known=()):
    """Set the MCLK entry of memtype to mhz (all three patchers; known: see mclk_pll). Returns the MHz."""
    m, nr, f, vco, src = mclk_pll(mhz, fmax, known=known)
    a = entries[memtype]
    put(a, d[a:a + 2], bytes([m, nr]), 'MCLK for %s (build option): %.2f MHz, VCO %.1f MHz, PLL %02Xh %02Xh (%s)'
        % (memtype, f, vco, nr, m, src))
    return f


# ------------------------------------------------------------------ the patcher
def jmp(at, to):
    return b'\xE9' + rel16(at, 3, to)


def call(at, to):
    return b'\xE8' + rel16(at, 3, to)


def jcc(op, at, to):
    """A short conditional or unconditional jump at 'at'."""
    r = to - (at + 2)
    assert -128 <= r <= 127
    return bytes([op, r & 0xFF])


def speed_sites(d, put, site, sym, lab, tags=True, skip=()):
    """The patch sites the other builds share (vplus/s3vpatch.py, trio64/s3tpatch.py: the same
    signatures in 1.03-08 and Phoenix 1.5-07): the window set booster entry, the fast 4F05 jump, the
    32-bit mode set clears, font load, scrolls and AH=09h. put(off, old, new, why) checks the old bytes;
    tags=False leaves the 2.04.07 levels out of the log; skip names the sites a build leaves out
    ('wset', 'clr', 'int10': Phoenix has its own window set, clears with the engine and keeps its
    4F05)."""
    def t(why, lv):
        return '%s (%s)' % (why, lv) if tags else why
    if 'wset' not in skip:
        a = sym['WSET']
        put(a, '52 53 8b da', jmp(a, lab['wsetx']) + b'\x90', t('VBE window set (4F05, window function): booster on', 'p16'))
    if 'clr' not in skip:
        a = site['clr']
        put(a, d[a:a + 5], jmp(a, lab['clear']) + b'\x90\x90', t('S3/VESA mode set clear: rep stosd', 'p11'))
    if 'int10' not in skip:
        a = site['int10'] + 2
        put(a, '80 fc 0e', jmp(a, lab['int10x']), t('INT 10h entry: fast 4F05 BH=0', 'p12'))
    a = site['font']
    put(a, '50 51 8a', jmp(a, lab['font']), t('font load: rep movsd per character', 'p12'))
    a = site['scr']
    put(a, '3b 0e 4a', jmp(a, lab['scr13']), t('mode 13h scroll AH=06h: 32-bit', 'p12'))
    a = site['txfull']                      # mov cx,bx / call wfillt / jmp short (the old target)
    back = a + 11 + d[a + 10] - (0x100 if d[a + 10] > 0x7F else 0)
    new = b'\x8b\xcb' + call(a + 2, lab['wfillt']) + jcc(0xEB, a + 5, back)
    put(a, SIG['txfull'], new + b'\x90' * (11 - len(new)), t('text scroll full width: blank fill with wfill', 'p13'))
    a = site['txwmov']                      # push cx/si/di, call wmove, pop, next line
    new = b'\x51\x56\x57' + call(a + 3, lab['wmove']) + b'\x5f\x5e\x59\x03\xf3\x03\xfb\xfe\xce'
    new += jcc(0x75, a + len(new), a)
    put(a, SIG['txwmov'], new + b'\x90' * (18 - len(new)), t('text scroll window: line moves with wmove', 'p13'))
    a = site['txwfil']                      # mov al,20h / mov ah,[bp+3] / call wfill / next line
    new = b'\xb0\x20\x8a\x66\x03' + call(a + 5, lab['wfill']) + b'\x03\xfb\xfe\xca'
    new += jcc(0x75, a + len(new), a + 5)
    put(a, SIG['txwfil'], new + b'\x90' * (17 - len(new)), t('text scroll window: blank lines with wfill', 'p13'))
    a = site['plfull']
    put(a, '33 c0 f3 aa', call(a, lab['bfill0']) + b'\x90', t('planar scroll full width: fill with bfill', 'p13'))
    a = site['plwin']                       # xor ax,ax / call bfilla (DI moved as rep stosb) / next line
    new = b'\x33\xc0' + call(a + 2, lab['bfilla']) + b'\x03\xfb\x4a'
    new += jcc(0x75, a + len(new), a + 2)
    put(a, SIG['plwin'][:38], new + b'\x90' * (13 - len(new)), t('planar scroll window: fill lines with bfilla', 'p13'))
    a = site['ah09a'] + 1
    put(a, 'f3 ab c3', jmp(a, lab['wfill']), t('AH=09h text: char/attribute with wfill', 'p13'))
    a = site['ah09b'] + 3
    put(a, 'f3 ab c3', jmp(a, lab['wfill']), t('AH=09h text, page > 0: with wfill', 'p13'))
    a = site['vclr'] + 4                    # xor bl,bl / mov es,bx / xor di,di / jmp wfill (9 bytes in place)
    put(a, '32 db 8e c3 33 ff f3 ab c3', b'\x32\xdb\x8e\xc3\x33\xff' + jmp(a + 6, lab['wfill']),
        t('VGA mode set clear: in place, rep stosw replaced by a jump to wfill', 'p14'))


def patch(lo, nasm='nasm', vcofix=True, mclk=None, memtype='edo1'):
    """lo: the lower 32 KB (2.04.07); mclk: MHz for the MCLK entry of memtype (None: the default build).
    Returns (new lower 32 KB, log lines)."""
    d = bytearray(lo)
    log = []
    m = re.search(rb'S3 86C775/86C785 Video BIOS\. Version (2\.04\.\d\d)\r\n', d[:0x100])
    if not m:
        raise PatchError('no "S3 86C775/86C785 Video BIOS. Version 2.04.xx" sign-on in the first 256 bytes')
    if m.group(1).decode() != VERSION:
        raise PatchError('BIOS version %s: only the reference BIOS %s is supported' % (m.group(1).decode(), VERSION))
    if sum(d) & 0xFF:
        raise PatchError('the lower 32 KB do not checksum to 00: not a clean %s image' % VERSION)
    if d[0:2] != b'\x55\xAA':
        raise PatchError('no 55AAh ROM header at offset 0')
    if bytes(d[FREE_START:FREE_END]) != bytes(FREE_END - FREE_START) or d[FREE_START - 1] != 0:
        raise PatchError('%04X-%04X is not free (already patched?)' % (FREE_START, FREE_END - 1))
    sym, site = bios_symbols(), SITES

    # 1. the original code must be where bios.inc and SITES say
    for k, off in site.items():
        if k in SIG and not sig_match(d, off, SIG[k]):
            raise PatchError('%s: original code not found at %04X' % (k, off))
    for k, sig in SYMSIG:
        if not sig_match(d, sym[k], sig):
            raise PatchError('%s: not found at %04X' % (k, sym[k]))
    ms = sym['MEMSIZE']
    if (call_target(d, ms + 1), call_target(d, ms + 4)) != (sym['UNLOCK'], sym['GETCRTC']):
        raise PatchError('memory size routine at %04X does not call UNLOCK/GETCRTC' % ms)
    if call_target(d, site['m4f02'] + 4) != sym['MODESET']:
        raise PatchError('VBE 4F02 does not call the mode set at %04X' % sym['MODESET'])
    if struct.unpack_from('<H', d, site['m4f02'] + 2)[0] != sym['SEG_BDA']:
        raise PatchError('VBE 4F02 does not load DS from %04X' % sym['SEG_BDA'])
    if struct.unpack_from('<H', d, site['modetab'])[0] != sym['MODESET']:
        raise PatchError('INT 10h AH=00 table entry at %04X is not the mode set' % site['modetab'])
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
    if (sym['P13A'], sym['P13B'], sym['P13C']) != (site['old4f06'], site['clr'] + 5, site['font'] + 3):
        raise PatchError('P13A/P13B/P13C are not the dead code after the p8, p11 and p12 jumps')
    if (call_target(d, site['ddcin']), call_target(d, site['ddcout'] + 1), call_target(d, site['ddcax'] + 3)) != \
            (sym['GETCRTC'], sym['SR0DRST'], sym['DDCWAIT']):
        raise PatchError('VBE 4F15 does not call GETCRTC, SR0DRST and DDCWAIT where expected')
    if not sig_match(d, 0x14A5, 'b3 10 be c9 00 b0 36 e8 ?? ?? f6 c4 08 75 0b be cb 00 f6 c4 04 75 03 be c7 00 e8'):
        raise PatchError('POST does not pick the MCLK entries C7h/C9h/CBh by CR36 bits 3-2 at 14A5h')
    if call_target(d, site['postdly'] + 4) != sym['DDCWAIT']:
        raise PatchError('POST engine reset does not call DDCWAIT at %04X' % (site['postdly'] + 4))

    def put(off, old, new, why):
        old, new = (hexb(x) if isinstance(x, str) else bytes(x) for x in (old, new))
        if bytes(d[off:off + len(old)]) != old:
            raise PatchError('%04X: expected %s, found %s (%s)' % (off, old.hex(' '), d[off:off + len(old)].hex(' '), why))
        d[off:off + len(new)] = new
        log.append('%04X  %-17s -> %-17s %s' % (off, old.hex(' '), new.hex(' '), why))

    # 2. data
    for off, old, new, why in DATA:
        put(off, old, new, why)
    if mclk is not None:
        mclk_put(d, put, MCLK_ENTRY, memtype, mclk, MCLK_MAX[memtype])

    # 3. code
    blocks, lab = assemble(sym, nasm)
    patch.blocks = blocks                   # for the diagnosis in main when the result differs
    for off, code, name in blocks:
        d[off:off + len(code)] = code
        log.append('%04X-%04X  %-12s %s' % (off, off + len(code) - 1, name,
                   ', '.join('%s %04X' % (k, lab[k]) for b in BLOCKS if b[0] == name for k in b[3])))

    a = site['modetab']
    put(a, struct.pack('<H', sym['MODESET']), struct.pack('<H', lab['hook']), 'INT 10h AH=00 table: mode set via the hook')
    a = site['m4f02'] + 4
    put(a, d[a:a + 3], call(a, lab['hook']), 'VBE 4F02: mode set via the hook')
    a = site['boost']
    put(a, 'c7 06 fe 04 00 00', call(a, lab['b4f02']) + b'\x90' * 3, 'VBE 4F02 end: booster on unless Windows runs (p18)')
    a = site['bl3'] + 4
    put(a, 'b8 ff 03 33 d2', call(a, lab['bl3']) + b'\xEB\xF8', 'VBE 4F06 BL=3: corrected routine, then mov ah,0 / ret')
    a = site['base'] + 2
    put(a, '8b c3 0b c0', call(a, lab['basefix']) + b'\x90', 'LFB base read: real base while the booster is on')
    a = site['lfb'] + 4
    put(a, '25 00 10', call(a, lab['lfbchk']), '4F05/4F03 linear test ignores the booster window')
    a = site['cr26']
    put(a, 'b8 26 00 ef', call(a, lab['cr2326']) + b'\x90', 'mode set: CR23 = 00h before CR26 = 00h (p19)')
    a = site['ddcin']
    put(a, d[a:a + 3], call(a, lab['ddcin']), 'VBE 4F15: interrupts off for the DDC operation (p19, as 2.04.11)')
    a = site['ddcout'] + 1
    put(a, d[a:a + 3], call(a, lab['ddcout']), 'VBE 4F15 end: interrupts on again (p19)')
    a = site['ddcax']
    put(a, 'bb 55 02', 'b8 55 02', 'VBE 4F15 probe: delay count in AX, not BX (p19, as 2.04.11)')
    a = site['postdly'] + 1
    put(a, 'bb 0a 00', 'b8 0a 00', 'POST delay before the engine reset: count 0Ah in AX, not BX (p20)')
    speed_sites(d, put, site, sym, lab)

    # 4. DCLK VCO
    if vcofix:
        vlog = []
        n = vco_fix(d, vlog)
        log += vlog
        if n:
            log.append('      %d refresh entries: VCO moved into 170-340 MHz, same pixel clock' % n)

    # 5. sign-on and checksum
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


def verify(img, vcofix):
    errs = []
    if len(img) != 0x10000:
        errs.append('image is %d bytes, not 65536' % len(img))
    if sum(img[:0x8000]) & 0xFF:
        errs.append('lower 32 KB checksum is not 00')
    if img[0x8000:] != img[:0x8000]:
        errs.append('upper 32 KB is not a copy of the lower 32 KB')
    if img[0:2] != b'\x55\xAA' or img[2] != 0x40:
        errs.append('ROM header 55AAh with 32 KB size missing')
    if vcofix:
        for e in refresh_entries(img):
            vco, f = pll(img[e + 4], img[e + 5])
            if not 135 <= vco <= 340:
                errs.append('refresh entry %04X: VCO %.1f MHz' % (e, vco))
    return errs


def diagnose(nasm, output, img):
    """Why the result differs: the assembler version, the blocks whose code differs from the tested
    build; the image goes to OUTPUT.untested for a comparison (never to OUTPUT)."""
    out = []
    try:
        v = subprocess.run([nasm, '-v'], capture_output=True, text=True).stdout.strip()
    except OSError:
        v = '(nasm -v failed)'
    out.append('assembler: %s (the tested build used NASM %s)' % (v or '?', TESTED_NASM))
    diff = [n for _, c, n in getattr(patch, 'blocks', [])
            if hashlib.sha256(c).hexdigest()[:16] != BLOCK_SHA.get(n)]
    if diff:
        out.append('blocks assembled differently: %s' % ', '.join(diff))
        if TESTED_NASM not in v:
            out.append('another NASM version encodes some instructions differently: build with NASM %s '
                       '(make 775-rom ... NASM=/path/to/nasm)' % TESTED_NASM)
    else:
        out.append('every block is as in the tested build: the difference is in the data patches')
    with open(output + '.untested', 'wb') as f:
        f.write(img)
    out.append('the untested image is in %s.untested; do not flash it' % output)
    return out


def main():
    ap = argparse.ArgumentParser(description='build %s-%s from the S3 reference BIOS %s' % (VERSION, LEVEL, VERSION))
    ap.add_argument('input', help='the reference BIOS: 32 KB, or a 64 KB image with it in the lower half')
    ap.add_argument('-o', '--output', required=True, help='64 KB result')
    ap.add_argument('--no-vco-fix', action='store_true', help='leave refresh entries with a VCO below 170 MHz')
    ap.add_argument('--mclk', type=float, help='MCLK in MHz for the memory type of --memtype (default: 59.96 '
                    'for 1-cycle EDO and for fast page/2-cycle EDO, 66.2 for SGRAM, as the default build)')
    ap.add_argument('--memtype', choices=sorted(MCLK_ENTRY), default='edo1',
                    help='the MCLK entry --mclk sets: edo1 (1-cycle EDO, at most 60 MHz), fpm (fast page and '
                         '2-cycle EDO, 66.67 MHz), sgram (Trio64V2/GX, 66.67 MHz); default edo1')
    ap.add_argument('--nasm', default='nasm', help='nasm executable (default: nasm on PATH)')
    ap.add_argument('-q', '--quiet', action='store_true', help='print only the result line')
    a = ap.parse_args()
    try:
        src = open(a.input, 'rb').read()
        if len(src) not in (0x8000, 0x10000):
            raise PatchError('input is %d bytes; expected 32768 or 65536' % len(src))
        lo = src[:0x8000]                       # a 64 KB input: only its lower half is used
        new_lo, log = patch(lo, a.nasm, not a.no_vco_fix, a.mclk, a.memtype)
        img = new_lo * 2                        # the 32 KB twice (#78)
        errs = verify(img, not a.no_vco_fix)
        known = hashlib.sha256(lo).hexdigest() == REF_SHA and not a.no_vco_fix and RESULT_SHA and a.mclk is None
        out_sha = hashlib.sha256(new_lo).hexdigest()
        if known and out_sha != RESULT_SHA:
            errs.append('result differs from the tested build (SHA-256 %s, expected %s)' % (out_sha, RESULT_SHA))
            errs += diagnose(a.nasm, a.output, img)
        if errs:
            raise PatchError('result check failed:\n  ' + '\n  '.join(errs))
    except (PatchError, OSError) as e:
        print('s3patch: %s' % e, file=sys.stderr)
        return 1
    with open(a.output, 'wb') as f:
        f.write(img)
    if not a.quiet:
        ref = hashlib.sha256(lo).hexdigest() == REF_SHA
        print('base %s%s' % (VERSION, ' (the known reference image)' if ref else ''))
        for line in log:
            print('  ' + line)
    print('%s: %s-%s, 64 KB (the 32 KB twice), checksum %02X (the 32 KB sum to 00), SHA-256 of the 32 KB %s%s'
          % (a.output, VERSION, LEVEL, img[0x7FFF], out_sha,
             ', identical to the tested build' if known or out_sha == RESULT_SHA else
             ', MCLK build option: the code is the tested build, the MCLK is yours to check on the card'
             if a.mclk is not None else ''))
    return 0


if __name__ == '__main__':
    sys.exit(main())
