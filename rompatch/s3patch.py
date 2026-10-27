#!/usr/bin/env python3
"""s3patch.py - apply the p12 or p13 patch set to an S3 Trio64V2/DX video BIOS (86C775/86C785).

    python3 rompatch/s3patch.py IN.BIN -o OUT.BIN [--target p13|p12] [--upper STOCK.BIN] [--no-vco-fix]
                                [--nasm nasm] [-q]
    make rom IN=IN.BIN OUT=OUT.BIN [TARGET=p12] [UPPER=STOCK.BIN]

Needs python3 (no packages) and nasm 2.x.

Supported base BIOS versions (the lower 32 KB, sign-on "S3 86C775/86C785 Video BIOS. Version ..."):
  2.04.11  the Gainward/Cardex stock BIOS of the ICUVGA-GW503A board; with --target p12 the result is
           byte for byte the p12 build (S3V2P12.BIN), with p13 (the default) the p13 build; both are
           checked against their SHA-256 when the input is the known stock image
  2.04.07  the S3 reference BIOS; same patches, with the addresses of that version; with the stock
           upper half the result is checked against the SHA-256 of the build the emulator tests passed

Targets
  p12      everything up to p12 (below)
  p13      p12 plus 32-bit stores in the text scroll (AH=06h/07h fills, window line moves), the planar
           scroll fills (modes 0Dh-12h) and AH=09h in text modes: p13df.asm, p13fill.asm, p13move.asm
           and p13bfill.asm, the last three partly in dead code that p8 and p11 left (P13A, P13B)

Input
  IN.BIN   64 KB image (lower half BIOS 2.04.xx, upper half the Trio64V+ BIOS 1.03-08), or the 32 KB
           lower half alone. With a 32 KB input, --upper gives the upper half: a 64 KB image (its upper
           32 KB are used, e.g. a dump of the stock card) or a 32 KB file of the upper half. The upper
           half is copied unchanged and must already checksum to 00.

What is applied (the README of trio64-vbios-tools, section "Byte-level changes", has the details)
  data   MCLK 59.96 MHz, POST flags (blank pedestal off), CR41/CR52 60 Hz defaults for 1280x1024 and
         1600x1200, 640x480 line total 800, 320x240 @ 60 Hz CRTC tables and refresh entries, CR50 for
         512x384; 2.04.07 also gets the stock board flags (0xD1 = 05) and CR80 POST value (0xD3 = 00)
  code   assembled with nasm from the .asm files next to this script into the free space 7CFB-7FE2:
         p12ext.asm (fast 4F05, 32-bit VGA clear and font load, 32-bit mode 13h scroll), crtc240.asm
         (320x240 CRTC tables), hooks.asm (mode set hook with LFB base restore, FIFO fix and ATC
         flip-flop reset; booster; LFB base and linear test fixes), vbe4f06.asm (4F06 BL=3),
         clear32.asm (32-bit S3/VESA mode set clear); addresses from bios.inc, overridden per version
  VCO    (unless --no-vco-fix) every refresh entry whose DCLK PLL runs its VCO below 170 MHz gets a
         larger post divider R and new M/N for exactly the same pixel clock, VCO in 170-340 MHz
         (smallest R, then smallest N; 2.04.07 has 30 such entries in 16 places, 2.04.11 none)
  sign-on "-p12" or "-p13" after the version number, checksum byte 7FFF

Every byte that is replaced is compared with the expected original first; on any mismatch nothing is
written and the exit code is 1. The result is checked before it is written: both 32 KB halves sum to 00,
the upper half is unchanged, every DCLK VCO in 170-340 MHz (unless --no-vco-fix).
"""
import argparse, hashlib, os, re, shutil, struct, subprocess, sys, tempfile

TARGETS = ('p12', 'p13')
FREE_START, FREE_END = 0x7CFB, 0x7FE3          # the code and tables go here (end exclusive)

# Known images: (SHA-256 of the 64 KB input, target) -> SHA-256 of the result
STOCK_SHA = '0451420801d1912338cd812b21c43f4ea812bd51299a25790c9e7d118ff00a2f'
REF_SHA = 'd79bb2a44c246c1292633147ccee4e7525544ed56167cb476ccfc7060a3b8930'   # 2.04.07 + stock upper half
KNOWN_INPUT = {STOCK_SHA: 'stock 2.04.11 (Gainward ICUVGA-GW503A)',
               REF_SHA: 'S3 reference 2.04.07 (32 KB, SHA-256 25d64cd7...) with the stock upper half'}
KNOWN = {
    (STOCK_SHA, 'p12'): ('S3V2P12.BIN', '165c2185c98e4dbad25013b71dc0b26f0fe14aab0ab7fd1975961e4a3839e772'),
    (REF_SHA, 'p12'): ('the 2.04.07-p12 build (emulator tests passed)',
                       'c13fcbe0daefa43871087c7b3c80b8b1312aa73934a28989f0972756f61badd6'),
    (STOCK_SHA, 'p13'): ('the 2.04.11-p13 build (S3V2P13.BIN, emulator tests passed)',
                         '5c3242cb5510754a76e0c0612790afcfb684948494a62d5f5ec033e189105d45'),
    (REF_SHA, 'p13'): ('the 2.04.07-p13 build (emulator tests passed)',
                       'b050b04536cd4a2d0faeacd05d9a044c457dff8e61b3eb8f2fae2353bb2ac024'),
}

# ------------------------------------------------------------------ per-version addresses
# sym: BIOS routines and words the new code uses. site: patch sites, with the original bytes
# ('??' = any byte) that must be there; 'at' marks where the replacement starts inside 'old'.
PROFILES = {
    '2.04.11': dict(
        sym=dict(MODESET=0x2686, UNLOCK=0x125C, GETCRTC=0x126C, RDREG=0x2179, MEMSIZE=0x1B1A,
                 SEG_SCR=0x1D4F, SEG_BDA=0x1D51, SEG_VID=0x1D53, INT_AH0E=0x2161, INT_NEXT=0x211F,
                 SCR_FULL=0x3206, SCR_WIN=0x322D, CLR_RET=0x1457, P13A=0x59E1, P13B=0x1442, P13C=0x1227, DFDN=0x7FAF),
        site=dict(modetab=0x20DE, m4f02=0x56FA, boost=0x5718, bl3=0x59D8, base=0x5CF2, lfb=0x5D0E,
                  clr=0x143D, int10=0x2118, vclr=0x2C34, font=0x1224, scr=0x3200, memsize=0x1B1A,
                  old4f06=0x59E1, txfull=0x2EE0, txwmov=0x2EEF, txwfil=0x2F01, plfull=0x3131,
                  plwin=0x317C, ah09a=0x351D, ah09b=0x3521),
        d1=0x07, d3=0x00),
    '2.04.07': dict(
        sym=dict(MODESET=0x267B, UNLOCK=0x125C, GETCRTC=0x126C, RDREG=0x216E, MEMSIZE=0x1B0F,
                 SEG_SCR=0x1D44, SEG_BDA=0x1D46, SEG_VID=0x1D48, INT_AH0E=0x2156, INT_NEXT=0x2114,
                 SCR_FULL=0x31FB, SCR_WIN=0x3222, CLR_RET=0x1457, P13A=0x59C0, P13B=0x1442, P13C=0x1227, DFDN=0x7FAF),
        site=dict(modetab=0x20D3, m4f02=0x56D9, boost=0x56F7, bl3=0x59B7, base=0x5CCD, lfb=0x5CE9,
                  clr=0x143D, int10=0x210D, vclr=0x2C29, font=0x1224, scr=0x31F5, memsize=0x1B0F,
                  old4f06=0x59C0, txfull=0x2ED5, txwmov=0x2EE4, txwfil=0x2EF6, plfull=0x3126,
                  plwin=0x3171, ah09a=0x3512, ah09b=0x3516),
        d1=0x02, d3=0x10),
}

# The original code at each site (same in both versions, relative addresses as ??). The replaced
# routines are matched in full, so the new code does what the old one did.
SIG = dict(
    m4f02='8e 1e ?? ?? e8 ?? ?? 61 8a d8 24',            # mov ds,[cs:SEG_BDA] / call MODESET
    boost='c7 06 fe 04 00 00 c3 c6 46 1b 01',            # mov word [4FEh],0 / ret
    bl3='0e b4 00 c3 b8 ff 03 33 d2 8b da 8a 5c',        # 4F06 BL=3: mov ax,3FFh / xor dx,dx
    base='8a dc 8b c3 0b c0 74 06 5e 5f 5a 59',          # mov ax,bx / or ax,ax
    lfb='58 e8 ?? ?? 25 00 10 5a 58 c3 c6 46 1b 00',     # and ax,1000h
    clr='2e 8e 06 ?? ?? 33 ff 50 51 b9 00 80 33 c0 f3 ab 59 58 fe c4 ef e2 e9 b4 00 ef 1f 07 61 c3',
    int10='fb fc 80 fc 0e 74 42 80 fc 0c 74 40 80 fc 0d 74 3e 66 50',
    vclr='b7 a0 b5 80 32 db 8e c3 33 ff f3 ab c3',
    font='50 51 8a cf 32 ed f3 a4 59 03 fa e2 f4 0c ff 58 c3',
    scr='3b 0e 4a 04 75 27 8b d8 8a c1 f6 e6 f7 26 85 04 8b c8 c1 e1 02 b8 00 a0 8e c0 8e d8 f3 a5 '
        '8b cb d1 e9 8a 46 03 8a e0 f3 ab 83 c4 04 c3 c1 e3 03 c1 e1 02 a0 85 04 f6 e6 52 8b d0 b8 '
        '00 a0 8e d8 8e c0 0b d2 74 0d 8b c1 f3 a5 8b c8 03 f3 03 fb 4a 75 f3 5a 2e 8e 1e ?? ?? a0 '
        '85 04 f6 e2 8b d0 8a 46 03 8a e0 8b f1 f3 ab 03 fb 8b ce 4a 75 f5',
    memsize='50 e8 ?? ?? e8 ?? ?? b0 36 e8 53 06',       # call UNLOCK / call GETCRTC / mov al,36h / call RDREG
    unlock='52 50 e8 0b 00 b8 38 48 ef b8 39 a5 ef 58 5a c3',
    getcrtc='50 ba cc 03 ec ba b4 03 a8 01 74 03 ba d4 03 58 c3',
    rdreg='ee 42 8a e0 ec 4a 86 c4 c3',
    ah0e='e9 ?? ?? e9 ?? ?? e9 ?? ?? 8b c6 80 fc 4f',
    segs='00 00 00 00 00 a0',
    # p13: the old 4F06 BL=3 routine after its first 5 bytes (dead once p8 calls the new one)
    old4f06='8b da 8a 5c 09 f7 e3 8b c8 e8 ?? ?? 33 c0 8b 5c 05 f7 f3 3b c1 77 02 8b c8 89 4e 12 c1 e8 03 '
            '89 46 16 c7 46 0e 00 00 eb cf',
    txfull='8b cb b0 20 8a 66 03 f3 ab eb 27',              # text scroll full width: blank fill, jmp
    txwmov='51 56 8b c7 f3 a5 8b f8 5e 59 03 f3 03 fb fe ce 75 ee',   # text window: line moves
    txwfil='b0 20 8a 66 03 51 57 f3 ab 5f 59 03 fb fe ca 75 f4',      # text window: blank lines
    plfull='33 c0 f3 aa ef fe c0 ef 83 c4 04 c3',          # planar full width: set/reset fill
    plwin='33 c0 8b f1 f3 aa 03 fb 8b ce 4a 75 f5 ba ce 03',  # planar window: fill lines
    ah09a='97 f3 ab c3',                                   # AH=09h text: char/attribute words
    ah09b='e8 ?? ?? f3 ab c3',                             # AH=09h text, page > 0
)

# Data patches at fixed offsets, same in both versions: (offset, old, new, purpose)
DATA = [
    (0x00C7, '28 41', '41 42', 'MCLK PLL at POST: SR11 = 41h, SR10 = 42h (59.96 MHz)'),
    (0x00DE, '08 80', '88 81', 'CR41/CR52 refresh fields: 1280x1024 and 1600x1200 default 60 Hz'),
    (0x04C1, '5e 4f 50 81', '5f 4f 50 82', '640x480x8/x32 @ 60 Hz: line total 800'),
    (0x089F, 'c1 03 82 48 33', '40 7e 82 3c 28', '320x240x8 refresh entry: CRTC table 7E40h, 60 Hz, 25.06 MHz'),
    (0x08AD, 'f5 0c 82 48 33', '60 7e 82 3c 28', '320x240x15/16 refresh entry: CRTC table 7E60h, 60 Hz'),
    (0x095C, '60', '40', 'CR50 for 512x384x8/x32'),
    (0x0B1A, 'c2 9f a0 85', 'c3 9f a0 86', '640x480x15/16 @ 60 Hz: line total 800'),
]

# ------------------------------------------------------------------ the new code (nasm)
# The sources sit next to this script; bios.inc holds the 2.04.11 addresses as defaults and every file
# is assembled with -D for the BIOS being patched, and with -DL_<label> for the labels of the blocks
# before it. (target, file, ROM offset or the bios.inc symbol for it, bytes allowed there, labels)
HERE = os.path.dirname(os.path.abspath(__file__))
BLOCKS = [
    ('p12', 'p12ext.asm', 0x7CFB, 0x7E40 - 0x7CFB, ('int10x', 'vclr', 'font', 'scr13')),
    ('p12', 'crtc240.asm', 0x7E40, 0x40, ('crtc8', 'crtc16')),
    ('p12', 'hooks.asm', 0x7E80, 0x7F58 - 0x7E80, ('hook', 'boost', 'basefix', 'lfbchk')),
    ('p12', 'vbe4f06.asm', 0x7F71, 0x7FAF - 0x7F71, ('bl3',)),
    ('p12', 'clear32.asm', 0x7FC0, 0x7FE3 - 0x7FC0, ('clear',)),
    ('p13', 'p13df.asm', 'DFDN', 0x7FC0 - 0x7FAF, ('dfdn',)),
    ('p13', 'p13fill.asm', 'P13A', 41, ('wfillt', 'wfill')),       # dead: old 4F06 BL=3 code
    ('p13', 'p13move.asm', 'P13B', 21, ('wmove',)),                # dead: old clear loop (p11)
    ('p13', 'p13bfill.asm', 0x7F58, 0x7F71 - 0x7F58, ('bfill0', 'bfill')),
    ('p13', 'p13bfa.asm', 'P13C', 14, ('bfilla',)),                # dead: old font loop (p12)
]


class PatchError(Exception):
    pass


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


def assemble(sym, nasm, target='p13', srcdir=HERE):
    """Assemble the blocks of the target with the addresses in sym. Returns [(offset, bytes, file)] and
    the labels."""
    tmp = tempfile.mkdtemp(prefix='s3patch_')
    try:
        out, labels = [], {}
        for lvl, name, org, room, want in BLOCKS:
            if TARGETS.index(lvl) > TARGETS.index(target):
                continue
            org = sym[org] if isinstance(org, str) else org
            src = os.path.join(srcdir, name)
            if not os.path.exists(src):
                raise PatchError('%s not found (keep the .asm files and bios.inc next to s3patch.py)' % src)
            binf, mapf = os.path.join(tmp, name + '.bin'), os.path.join(tmp, name + '.map')
            with open(os.path.join(tmp, name), 'w') as f:  # the source plus a map file for the labels
                f.write('%%include "%s"\n[map symbols %s]\n' % (src.replace('\\', '/'), mapf.replace('\\', '/')))
            cmd = [nasm, '-f', 'bin', '-i' + srcdir + os.sep, '-o', binf] + \
                  ['-D%s=0x%04X' % kv for kv in sorted(sym.items())] + \
                  ['-DL_%s=0x%04X' % kv for kv in sorted(labels.items())] + [os.path.join(tmp, name)]
            try:
                r = subprocess.run(cmd, capture_output=True, text=True)
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
def pll(m, nr):
    n, r = nr & 0x1F, (nr >> 5) & 3
    vco = 14.31818 * (m + 2) / (n + 2)
    return vco, vco / (1 << r)


def refresh_entries(img):
    """The refresh entries of the S3 mode table at 0158h: 9 bytes per mode (mode, VGA parameter pointer,
    4 flag bytes, refresh list pointer); each list has 14-byte entries, bit 7 of byte 2 marks the last."""
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
                e += 14
        o += 9
    return seen


def vco_fix(d, log, lo=170.0):
    n = 0
    for e in refresh_entries(d):
        m, nr = d[e + 4], d[e + 5]
        vco, f = pll(m, nr)
        if vco >= lo:
            continue
        r, nn = (nr >> 5) & 3, nr & 0x1F
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
        nr2 = (nr & 0x80) | (r2 << 5) | n2
        d[e + 4], d[e + 5] = m2, nr2
        v2, f2 = pll(m2, nr2)
        assert abs(f2 - f) < 1e-9
        log.append('%04X  %02X %02X -> %02X %02X  DCLK %.2f MHz %3d Hz: VCO %.1f -> %.1f MHz'
                   % (e + 4, m, nr, m2, nr2, f, d[e + 3], vco, v2))
        n += 1
    return n


# ------------------------------------------------------------------ the patcher
def patch(lo, nasm='nasm', vcofix=True, target='p13'):
    """lo: the lower 32 KB. Returns (new lower 32 KB, version, log lines)."""
    d = bytearray(lo)
    log = []
    m = re.search(rb'S3 86C775/86C785 Video BIOS\. Version (2\.04\.\d\d)\r\n', d[:0x100])
    if not m:
        raise PatchError('no "S3 86C775/86C785 Video BIOS. Version 2.04.xx" sign-on in the first 256 bytes')
    ver = m.group(1).decode()
    if ver not in PROFILES:
        raise PatchError('BIOS version %s is not supported (only %s)' % (ver, ', '.join(PROFILES)))
    if sum(d) & 0xFF:
        raise PatchError('the lower 32 KB do not checksum to 00: not a clean %s image' % ver)
    if d[0:2] != b'\x55\xAA':
        raise PatchError('no 55AAh ROM header at offset 0')
    if bytes(d[FREE_START:FREE_END]) != bytes(FREE_END - FREE_START) or d[FREE_START - 1] != 0:
        raise PatchError('%04X-%04X is not free (already patched?)' % (FREE_START, FREE_END - 1))
    prof = PROFILES[ver]
    sym, site = prof['sym'], prof['site']

    # 1. the original code must be where the profile says
    for k, off in site.items():
        if k in SIG and not sig_match(d, off, SIG[k]):
            raise PatchError('%s: original code not found at %04X' % (k, off))
    checks = [('unlock', sym['UNLOCK']), ('getcrtc', sym['GETCRTC']), ('rdreg', sym['RDREG']),
              ('ah0e', sym['INT_AH0E']), ('segs', sym['SEG_SCR'])]
    for k, off in checks:
        if not sig_match(d, off, SIG[k]):
            raise PatchError('%s: not found at %04X' % (k, off))
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
        raise PatchError('INT 10h entry targets differ from the profile')
    if (site['scr'] + 6, site['scr'] + 6 + d[site['scr'] + 5]) != (sym['SCR_FULL'], sym['SCR_WIN']):
        raise PatchError('mode 13h scroll targets differ from the profile')
    if site['clr'] + 0x1A != sym['CLR_RET']:
        raise PatchError('mode set clear return differs from the profile')

    def put(off, old, new, why):
        old, new = (hexb(x) if isinstance(x, str) else bytes(x) for x in (old, new))
        if bytes(d[off:off + len(old)]) != old:
            raise PatchError('%04X: expected %s, found %s (%s)' % (off, old.hex(' '), d[off:off + len(old)].hex(' '), why))
        d[off:off + len(new)] = new
        log.append('%04X  %-17s -> %-17s %s' % (off, old.hex(' '), new.hex(' '), why))

    # 2. data
    put(0x00D1, [prof['d1']], [0x05], 'POST flags: blank pedestal off, stock board flags (bits 0 and 2)')
    if prof['d3'] != 0:
        put(0x00D3, [prof['d3']], [0x00], 'CR80 POST value as the stock BIOS')
    for off, old, new, why in DATA:
        put(off, old, new, why)

    # 3. code
    blocks, lab = assemble(sym, nasm, target)
    for off, code, name in blocks:
        d[off:off + len(code)] = code
        log.append('%04X-%04X  %-12s %s' % (off, off + len(code) - 1, name,
                   ', '.join('%s %04X' % (k, lab[k]) for b in BLOCKS if b[1] == name for k in b[4])))

    def jmp(at, to):
        return b'\xE9' + rel16(at, 3, to)

    def call(at, to):
        return b'\xE8' + rel16(at, 3, to)

    a = site['modetab']
    put(a, struct.pack('<H', sym['MODESET']), struct.pack('<H', lab['hook']), 'INT 10h AH=00 table: mode set via the hook')
    a = site['m4f02'] + 4
    put(a, d[a:a + 3], call(a, lab['hook']), 'VBE 4F02: mode set via the hook')
    a = site['boost']
    put(a, 'c7 06 fe 04 00 00', call(a, lab['boost']) + b'\x90' * 3, 'VBE 4F02 end: booster')
    a = site['bl3'] + 4
    put(a, 'b8 ff 03 33 d2', call(a, lab['bl3']) + b'\xEB\xF8', 'VBE 4F06 BL=3: corrected routine, then mov ah,0 / ret')
    a = site['base'] + 2
    put(a, '8b c3 0b c0', call(a, lab['basefix']) + b'\x90', 'LFB base read: real base while the booster is on')
    a = site['lfb'] + 4
    put(a, '25 00 10', call(a, lab['lfbchk']), '4F05/4F03 linear test ignores the booster window')
    a = site['clr']
    put(a, d[a:a + 5], jmp(a, lab['clear']) + b'\x90\x90', 'S3/VESA mode set clear: rep stosd (p11)')
    a = site['int10'] + 2
    put(a, '80 fc 0e', jmp(a, lab['int10x']), 'INT 10h entry: fast 4F05 BH=0 (p12)')
    a = site['vclr'] + 4
    put(a, '32 db 8e', jmp(a, lab['vclr']), 'VGA mode set clear: rep stosd (p12)')
    a = site['font']
    put(a, '50 51 8a', jmp(a, lab['font']), 'font load: rep movsd per character (p12)')
    a = site['scr']
    put(a, '3b 0e 4a', jmp(a, lab['scr13']), 'mode 13h scroll AH=06h: 32-bit (p12)')

    if target == 'p13':
        def jcc(op, at, to):                # short conditional or unconditional jump at 'at'
            r = to - (at + 2)
            assert -128 <= r <= 127
            return bytes([op, r & 0xFF])

        a = site['txfull']                  # mov cx,bx / call wfillt / jmp short (the old target)
        back = a + 11 + d[a + 10] - (0x100 if d[a + 10] > 0x7F else 0)
        new = b'\x8b\xcb' + call(a + 2, lab['wfillt']) + jcc(0xEB, a + 5, back)
        put(a, SIG['txfull'], new + b'\x90' * (11 - len(new)), 'text scroll full width: blank fill with wfill (p13)')
        a = site['txwmov']                  # push cx/si/di, call wmove, pop, next line
        new = b'\x51\x56\x57' + call(a + 3, lab['wmove']) + b'\x5f\x5e\x59\x03\xf3\x03\xfb\xfe\xce'
        new += jcc(0x75, a + len(new), a)
        put(a, SIG['txwmov'], new + b'\x90' * (18 - len(new)), 'text scroll window: line moves with wmove (p13)')
        a = site['txwfil']                  # mov al,20h / mov ah,[bp+3] / call wfill / next line
        new = b'\xb0\x20\x8a\x66\x03' + call(a + 5, lab['wfill']) + b'\x03\xfb\xfe\xca'
        new += jcc(0x75, a + len(new), a + 5)
        put(a, SIG['txwfil'], new + b'\x90' * (17 - len(new)), 'text scroll window: blank lines with wfill (p13)')
        a = site['plfull']
        put(a, '33 c0 f3 aa', call(a, lab['bfill0']) + b'\x90', 'planar scroll full width: fill with bfill (p13)')
        a = site['plwin']                   # xor ax,ax / call bfilla (DI moved as rep stosb) / next line
        new = b'\x33\xc0' + call(a + 2, lab['bfilla']) + b'\x03\xfb\x4a'
        new += jcc(0x75, a + len(new), a + 2)
        put(a, SIG['plwin'][:38], new + b'\x90' * (13 - len(new)), 'planar scroll window: fill lines with bfill (p13)')
        a = site['ah09a'] + 1
        put(a, 'f3 ab c3', jmp(a, lab['wfill']), 'AH=09h text: char/attribute with wfill (p13)')
        a = site['ah09b'] + 3
        put(a, 'f3 ab c3', jmp(a, lab['wfill']), 'AH=09h text, page > 0: with wfill (p13)')

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
    txt = bytes(d[s:end]).replace(ver.encode(), (ver + '-' + target).encode(), 1)
    pad = d.index(b'\x00', s)
    stop = pad
    while stop < 0x100 and d[stop] == 0:
        stop += 1
    if s + len(txt) + 1 > stop:
        raise PatchError('no room for the longer sign-on')
    d[s:s + len(txt) + 1] = txt + b'\x00'
    log.append('%04X  sign-on "%s"' % (s, txt.split(b'\r')[0].decode()))
    d[0x7FFF] = 0
    d[0x7FFF] = (-sum(d)) & 0xFF
    log.append('7FFF  checksum %02X -> %02X' % (lo[0x7FFF], d[0x7FFF]))
    return bytes(d), ver, log


def verify(img, upper, vcofix):
    errs = []
    if len(img) != 0x10000:
        errs.append('image is %d bytes, not 65536' % len(img))
    if sum(img[:0x8000]) & 0xFF:
        errs.append('lower 32 KB checksum is not 00')
    if sum(img[0x8000:]) & 0xFF:
        errs.append('upper 32 KB checksum is not 00')
    if img[0x8000:] != upper:
        errs.append('upper 32 KB changed')
    if img[0:2] != b'\x55\xAA' or img[0x8000:0x8002] != b'\x55\xAA':
        errs.append('ROM header 55AAh missing')
    if vcofix:
        for e in refresh_entries(img):
            vco, f = pll(img[e + 4], img[e + 5])
            if not 170 <= vco <= 340:
                errs.append('refresh entry %04X: VCO %.1f MHz' % (e, vco))
    return errs


def main():
    ap = argparse.ArgumentParser(description='apply the p12 or p13 patch set to an S3 Trio64V2/DX BIOS 2.04.11 or 2.04.07')
    ap.add_argument('input', help='64 KB image, or the 32 KB lower half')
    ap.add_argument('-o', '--output', required=True, help='64 KB result')
    ap.add_argument('--upper', help='source of the upper 32 KB (64 KB image or 32 KB file) for a 32 KB input')
    ap.add_argument('--target', choices=TARGETS, default=TARGETS[-1], help='patch level (default %(default)s)')
    ap.add_argument('--no-vco-fix', action='store_true', help='leave refresh entries with a VCO below 170 MHz')
    ap.add_argument('--nasm', default='nasm', help='nasm executable (default: nasm on PATH)')
    ap.add_argument('-q', '--quiet', action='store_true', help='print only the result line')
    a = ap.parse_args()
    try:
        src = open(a.input, 'rb').read()
        if len(src) == 0x10000:
            lo, upper = src[:0x8000], src[0x8000:]
            if a.upper:
                raise PatchError('--upper is only for a 32 KB input')
        elif len(src) == 0x8000:
            if not a.upper:
                raise PatchError('32 KB input: give the upper half with --upper (e.g. the stock 64 KB image)')
            u = open(a.upper, 'rb').read()
            if len(u) == 0x10000:
                u = u[0x8000:]
            if len(u) != 0x8000:
                raise PatchError('--upper must be 64 KB or 32 KB')
            lo, upper = src, u
        else:
            raise PatchError('input is %d bytes; expected 32768 or 65536' % len(src))
        if upper[:2] != b'\x55\xAA' or sum(upper) & 0xFF:
            raise PatchError('upper 32 KB: no 55AAh header or checksum not 00')
        new_lo, ver, log = patch(lo, a.nasm, not a.no_vco_fix, a.target)
        img = new_lo + upper
        errs = verify(img, upper, not a.no_vco_fix)
        in_sha = hashlib.sha256(lo + upper).hexdigest()
        known = None if a.no_vco_fix else KNOWN.get((in_sha, a.target))
        out_sha = hashlib.sha256(img).hexdigest()
        if known and out_sha != known[1]:
            errs.append('result differs from %s (SHA-256 %s, expected %s)' % (known[0], out_sha, known[1]))
        if errs:
            raise PatchError('result check failed:\n  ' + '\n  '.join(errs))
    except (PatchError, OSError) as e:
        print('s3patch: %s' % e, file=sys.stderr)
        return 1
    with open(a.output, 'wb') as f:
        f.write(img)
    if not a.quiet:
        print('base %s%s' % (ver, ' = ' + KNOWN_INPUT[in_sha] if in_sha in KNOWN_INPUT else ''))
        for line in log:
            print('  ' + line)
    print('%s: %s-%s, checksums %02X/%02X (both halves sum to 00), SHA-256 %s%s'
          % (a.output, ver, a.target, img[0x7FFF], img[0xFFFF], out_sha,
             ', identical to ' + known[0] if known else ''))
    return 0


if __name__ == '__main__':
    sys.exit(main())
