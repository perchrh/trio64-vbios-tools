#!/usr/bin/env python3
"""s3tpatch.py - build the Trio64 ROM (1.5-07-p3) from the Phoenix S3 Trio64 BIOS 1.5-07.

    python3 rompatch/trio64/s3tpatch.py 1_5_07.BIN -o S3T64P3.BIN [--size 64|32] [--mclk MHZ [--overclock]] [--nasm nasm] [-q]
    make 764x-rom OUT=S3T64P3.BIN [MCLK=55] [MCLK=69.8 OVERCLOCK=1]

Needs python3 (no packages) and NASM 3.02, as s3patch.py (the Trio64V2 build) does; it uses the
assembler driver and the shared patch code of s3patch.py.

Input
  1_5_07.BIN   a Phoenix S3 Trio64 BIOS 1.5-07 ("Phoenix S3 TRIO64 Enhanced VGA BIOS. Version 1.5-07"),
               32 KB, or a 64 KB image with it in the lower half. reference/trio64/1_5_07.bin is the CP764
               build (08/19/96); every 1.5-07 build at hand has the same code from 1000h to 7EFFh and
               differs only in the first 4 KB (sign-on, memory clock, per-mode memory timing bytes), so
               another card's own 1.5-07 dump is accepted when its code is that code and its tables have
               the reference layout; its clock and timing bytes are kept. The pinned SHA-256 is that of
               the reference build.

Output
  64 KB: the patched 32 KB twice, so that a board which maps the upper half of its 64 KB EEPROM finds
  the BIOS as well as one that maps the lower half (the ExpertColor DSP-3364P maps the upper half: with
  zeros there the card stayed dark at POST, #78); --size 32: the 32 KB alone, for a 32 KB EEPROM

What is applied (docs/764-rom.md)
  tables  the refresh entries that run interlaced are removed where the mode has non-interlaced rates
          (1024x768 and 1280x1024 at 8, 15 and 16 bpp, and the 2xxh modes of the same timings), so each
          mode defaults to its lowest non-interlaced rate; the modes that exist only interlaced on the
          Trio64 are removed (106h 1280x1024x4, 118h 1024x768x16M, 119h/11Ah 1280x1024x32K/64K, 120h
          1600x1200: S3 modes 6Eh, 78h, 79h, 7Ah, 7Ch) from the mode table, both VESA lists and the mode
          map; the refresh lists, the mode table and the lists are moved together, every pointer
          rewritten, and the freed bytes hold the new code
  POST    CR52 = 80h instead of 00h: the 800x600 modes default to 60 Hz instead of 56 Hz (VESA DMT, as
          the Trio64V2 ROM)
  code    assembled with nasm at the addresses in trio64/bios.inc: tbon.asm and tlock.asm (booster with
          the Windows check), thook.asm (mode set hook: Windows mark cleared, ATC flip-flop reset),
          tglue.asm and twset.asm (the entries from 4F02 and the window set), twin.asm (the window set
          and get read SR04 with the sequencer index kept); shared with the other builds (rompatch/):
          font32.asm, scr13.asm with scr13w.asm (its window path, a block of its own here), p13fill.asm,
          p13move.asm, p13bfill.asm, p13bfa.asm, p13df.asm (32-bit font load, mode 13h scroll, text and
          planar scrolls, AH=09h text, VGA mode set clear)
  FIFO    (p2, #75) tfifo.asm (in the VDIF code's place) and tfifo2.asm (in the sign-on padding
          00AEh-00E3h): at the mode set's CR67 write (site cr67) the display FIFO M (CR54 bits 7-3) is
          lowered in the packed modes to what the memory bandwidth allows, (t - 23) / 6 (p3, #82; p2: / 5) with
          t = 112 x MCLK / (DCLK x bytes per pixel); 112 x MCLK in kHz is written into the code (kmclk)
          from the final MCLK pair at 3B5h, so --mclk builds follow
  fonts   S3's fonts from the Trio64V+ BIOS 1.03-08 (--fonts, default reference/64vplus/1_03_08n.bin; the
          same bytes as in 2.04.07) in place of Phoenix's, all five tables whole: S3's 9-dot alternate
          tables are 63 bytes longer, so the 8x16 font and the 9x16 table move up (S3FONTS) and the eight
          references to them are rewritten (FONT_REFS); --fonts-only applies only these, the reference
          of make 764-ref-compare
  DDC     VBE 4F15 without VDIF (DDC_SITES, DDC_FREED): 97 bytes free, DDC1 and DDC2B kept
  MCLK    (only with --mclk) the single MCLK PLL entry at 3B5h, at most 70 MHz (MCLK_MAX); without it
          the build's own clock stays (54.9 MHz in the reference build). The data book gives 60 MHz
          (MEM-1, DATABOOK_MAX); 70 MHz is the clock the 86C764X is rated for in card databases
          (vgamuseum) and the one DSP-3364P boards run (their own BIOS: 69.8 MHz, model tag "764 M70";
          on the card it posts and runs windowed video without the streaks of 54.9 MHz, #75). Our tools
          take 70 MHz as the Trio64's limit (common/chip.inc), so up to 70 MHz nothing warns or fails.
          --model says which Trio64 the build is for (MODELS): 764x, the 86C764X (Trio64 PnP), takes
          55-70 MHz and is the default; 764p, the earlier 86C764-P (also VL-Bus), takes 50-60 MHz.
          A --mclk outside the model's range is refused (above it, --overclock allows up to 100 MHz)
          With --overclock up to 100 MHz (OVERCLOCK_MAX, twice the 50 MHz the BIOSes run at their
          lowest): the card owner's choice, never the default
  sign-on "1.5-07-p3", checksum byte 7FFF

Not applied: the fast 4F05 path (Phoenix's 4F05 is short: 6 OUTs for a bank in 101h in the emulator, 14 in
1.5-07-p1 with the booster check and the sequencer index kept), the 32-bit S3/VESA
mode set clear (Phoenix clears with the graphics engine), the base restore (Phoenix writes CR59/CR5A
back at every mode set), the Trio64V2 register fixes and VBE 2.0.

Every byte that is replaced is compared with the expected original first; on any mismatch nothing is
written and the exit code is 1. The result is checked before it is written: the 32 KB sum to 00 and
declare 32 KB, no interlaced entry is the first of any refresh list, and with the reference image the
SHA-256 of the build that passed the emulator tests.
"""
import argparse, hashlib, os, re, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
SHARED = os.path.dirname(HERE)
sys.path.insert(0, SHARED)
import s3patch  # noqa: E402
from s3patch import PatchError, sig_match, call_target, jmp, call, speed_sites, mclk_put  # noqa: E402

VERSION = '1.5-07'
LEVEL = s3patch.rom_level('VER764', VERSION)   # the sign-on level: common/version.inc VER764
REF_SHA = '6a28c6b2bd8f98cfe21e1a889d18e1d03d97427fbc6a4b6ca984f943e4962519'   # 32 KB CP764 build
CODE_SHA = '055ec20d44308727b044d1939807886559098a4d527e5cb9a94832d6e9b89d98'  # 1000h-7EFFh: the code of every 1.5-07 build
RESULT_SHA = 'f6eb2bf00ea05abae16946c7f3493fdf747a5124bd1b80e3361876b68445904e'  # 1.5-07-p3 of the reference (NASM 3.02), emulator tests passed
BLOCK_SHA = {
    'tlock.asm': 'a7e351fa30fbd436', 'tbon.asm': '05086e5b9273202d',
    'thook.asm': 'dc98e69ad2549c22', 'tglue.asm': '1b3f0fbe0e6d3aa4',
    'font32.asm': '8d11cc74c14ffc30', 'scr13.asm': '6bf14a59c964b8d3',
    'p13fill.asm': '466a65fde38ca9a1', 'p13df.asm': '7e785b4ba99b8749',
    'p13move.asm': '2a4ce99637fc0ce5', 'p13bfill.asm': 'e420891842c6096f',
    'p13bfa.asm': 'bef577de13494d8c', 'twin.asm': 'b6e0009a74fd8ca0',
    'twset.asm': '63d4c435841f7207', 'scr13w.asm': '8ddf861c37d1cfd3',
    'tfifo2.asm': 'ea0850f2e6745701',
    'tfifo.asm': '456df5ae06ba71d8',
}

# ---------------------------------------------------------------- the 1.5-07 tables (first 4 KB and 4D28h)
ENT = 12                                        # refresh entry: CRTC table, index (bit 7: first), PLL, ...
LISTS = (0x087C, 0x0BD0)                        # every refresh list, end to end
MTAB = 0x0522                                   # mode table: 9 bytes per mode (mode, register block,
                                                # flags, ..., refresh list end), FFh at the end
VLIST = 0x4D28                                  # VESA modes for 4F00 and 4F02 (FFFFh), then the 2xxh list
VMAP = 0x4D82                                   # per VESA mode: S3 mode, 4F01 record; 80h 00 00 for the
                                                # FFFFh of the first list; FFh at the end
# interlaced refresh entries (CR42 bit 5 after the mode set, emulator) with their first 5 bytes (CRTC
# table, index, PLL index, flags), which every 1.5-07 build has
ILACE = {0x0924: '7b 07 80 27 00', 0x0954: '7b 07 80 27 00', 0x0984: 'bb 07 82 2e 00', 0x0990: 'bb 07 82 2e c0',
         0x0A50: '79 0d 80 27 10', 0x0A80: '7b 07 80 27 30', 0x0A8C: 'dd 0d 82 2a d0', 0x0A98: '3b 08 80 29 81',
         0x0B28: '7b 07 80 27 00', 0x0B58: '7b 07 80 27 00', 0x0B94: 'bb 07 82 2e 00'}
REMOVE = {0x6E: 0x0106, 0x78: 0x0118, 0x79: 0x0119, 0x7A: 0x011A, 0x7C: 0x0120}   # S3 mode: VESA mode
# what only the removed entries and modes use: the 1600x1200 register block, two CRTC tables, the 4F01
# records of the removed modes (no code or table refers to them otherwise)
DROPPED = [(0x0831, 0x0871), (0x0D79, 0x0D92), (0x0DDD, 0x0DF6), (0x4E2E, 0x4E3A), (0x4EBE, 0x4EEE)]
# zero runs the build has from the start: the image end after the 9x16 alternate font table (7E30h, 17-byte
# entries; its 00h at 7F51h, and its last glyph's blank rows before that, look like free space but are
# not; S3's fonts take 7F52h-7F90h of it), the padding after the second sign-on block from 0130h (the
# card makers' second blocks end at 011Dh to 012Ch; the first block's padding takes the longer sign-on)
UNUSED = [(0x7F52, 0x7FFF), (0x0130, 0x0184), (0x00AE, 0x00E4)]
ALT916 = (0x7E30, 0x7F51)                        # the 9x16 alternate font table and its 00h

SITES = dict(modetab=0x568C, m4f02=0x4C12, int10=0x56C6, post52=0x0E97, mclk=0x0354,
             vclr=0x1D88, font=0x0EA9, scr=0x237C, txfull=0x2046, txwmov=0x2055, txwfil=0x2067,
             plfull=0x22AD, plwin=0x22F8, ah09a=0x26D4, ah09b=0x26D8, wsr04=0x5134, gsr04=0x5163,
             cr67=0x0503)
SHARED_SIG = ('vclr', 'font', 'scr', 'txfull', 'txwmov', 'txwfil', 'plfull', 'plwin', 'ah09a', 'ah09b')
SIG = dict({k: s3patch.SIG[k] for k in SHARED_SIG},
    m4f02='60 2e 8e 1e ?? ?? e8 ?? ?? 61 c3',           # 4F02: pusha / mov ds,[cs:SEG_BDA] / call MODESET / popa / ret
    int10='fb fc 80 fc 0e 74 ?? 80 fc 0c 74 ?? 80 fc 0d 74 ?? 50 53 51 52 56 57 55 06 1e 8b ec 2e 8e 1e ?? ??',
    post52='e8 ?? ?? e8 ?? ?? b8 41 00 ef b8 52 00 ef e8 ?? ?? c3',   # POST: CR41 = 00h, CR52 = 00h
    cr67='b0 67 26 8a 65 0b ef 80 fc d0',             # mode set: CR67 from the mode table entry (ES:DI+0Bh)
    wsr04='e8 ?? ?? f6 c4 08',                          # window set: call RDREG (SR04) / test ah,08h
    gsr04='e8 ?? ?? 33 d2',                             # window get: call RDREG (SR04) / xor dx,dx
    mclk='be b5 03 b8 1b 00 ef b0 1a 2e 8a 64 01 ef b0 10 2e 8a 64 01 ef fe c0 2e 8a 24 ef',  # POST MCLK from 3B5h
)
SYMSIG = [('GETCRTC', '50 ba cc 03 ec ba b4 03 a8 01 74 03 ba d4 03 58 c3'),
          ('RDREG', 'ee 42 8a e0 ec 4a 86 c4 c3'),
          ('INT_AH0E', 'e9 ?? ?? e9 ?? ?? e9 ?? ?? 8b c6 80 fc 4f'),
          ('SEG_SCR', '00 00 00 00 00 a0'),
          ('WSET', '52 53 b8 4f 01 80 ff 00 75 18 8b da ba c4 03 b0 04 e8 ?? ?? f6 c4 08 75 03 c1 e3 02 e8'),
          ('GWIN', '53 b8 4f 01 80 ff 01 75 24 e8 ?? ?? b0 6a e8 ?? ?? 8a dc 80 e3 7f ba c4 03 b0 04 e8 ?? ?? 33 d2')]
# S3's fonts, taken from the Trio64V+ BIOS 1.03-08 (the same bytes as in 2.04.07, on the Trio64V2 card):
# (name, offset in 1.03-08, length, SHA-256 there, address here). They replace Phoenix's fonts, which
# take 5720h-7F51h, and lie end to end from 5720h to 7F90h: S3's 9-dot alternate tables have 20 and 19
# entries, Phoenix's 18 and 17, so the 9x14 table grows into the 8x16 font's place and the 8x16 font
# and the 9x16 table move up by 29 and 63 bytes, into the zeros after the 9x16 table (UNUSED, checked).
# The 8x8 and 8x14 fonts and the 9x14 table keep their addresses.
FONT_SRC = os.path.join(os.path.dirname(SHARED), 'reference', '64vplus', '1_03_08n.bin')
S3FONTS = [
    ('8x8', 0x526C, 0x0800, '75c79a7e7fa423dda67ec6d6d76cec86b63f85677726368750c75b0920ddf319', 0x5720),
    ('8x14', 0x5A6C, 0x0E00, '657ca6588b6bf729f0ed71a3d3c781a465bd30cdfb11eb5fc7e27594c0717ea1', 0x5F20),
    ('9x14 alternate', 0x686C, 301, 'eeca821495071577f416370bb31f075aff1344d2170a1696901e708b8ac61b17', 0x6D20),
    ('8x16', 0x6998, 0x1000, 'a8bad6fd78475a6bc2a05438c19207a9bb8c0f4f4099f60384e158cdc3eba580', 0x6E4D),
    ('9x16 alternate', 0x7998, 324, 'ebaabb3ef79a22c92935d68766b4543b3851289921b7806a0e82345635c8e224', 0x7E4D),
]
FONTS = (0x5720, 0x7F91)                        # where S3's fonts lie, end to end
PHX_FONTS = (0x5720, 0x7F52)                    # Phoenix's fonts (the code area's, CODE_SHA; then ALT916)
# Phoenix's references to the two tables that move (riplin's disassembly names these and no others; a
# scan for the words finds no others in the code): mov bx/si with the address, and the AX=1130h
# table at 315Ah (8x14, 8x8, 8x8 upper, 9x14, 8x16, 9x16)
FONT_REFS = {0x1B29: 0x6E30, 0x1B39: 0x6E30, 0x2FBE: 0x6E30, 0x2FFD: 0x6E30, 0x3119: 0x6E30, 0x3162: 0x6E30,
             0x3164: 0x7E30, 0x477B: 0x7E30}
FONT_REF_OP = {0x1B29: 0xBB, 0x1B39: 0xBB, 0x2FBE: 0xBE, 0x2FFD: 0xBE, 0x3119: 0xBE, 0x477B: 0xBE}
FONT_TAB = (0x315A, '20 5f 20 57 20 5b 20 6d 30 6e 30 7e')
# VDIF deleted from VBE 4F15 (31 October 2026, for space; docs/764-rom.md): BL=02h, read VDIF (a
# format VESA withdrew), fails with AH=01h. DDC1 and DDC2B stay as in 1.5-07 (DDC1 was deleted for a
# while and put back the same day: monitors of the era that speak DDC1 alone keep their EDID).
# (offset, old, new):
DDC_SITES = [
    (0x5603, '80 fb 02 77 2e', '80 fb 01 77 2e'),   # 4F15: BL above 01h fails (AH = 01h)
    (0x562A, 'e8 b4 fc 74 03 eb 05 90', 'eb 0a' + ' 00' * 6),   # its BL=02h branch, dead now: to the exit
]
# VESADDCReadVDIF (52E1h-5341h), zeroed: riplin's disassembly shows no caller but the BL=02h branch
DDC_FREED = [(0x52E1, 0x5342, '53 51 52 e8 5b 00')]
MCLK_ENTRY = {'any': 0x03B5}                    # the one MCLK pair (SR11, SR10), whatever the memory type
DATABOOK_MAX = 60.0                             # MEM-1: 16.67 ns on the Trio32/Trio64 (named in --help only)
MCLK_MAX = 70.0                                 # --mclk without --overclock: the 86C764X's 70 MHz, our Trio64 limit
# The two Trio64 models, identical for this ROM except the MCLK they take (--model; T64-MEM-7):
# (lowest MHz, highest MHz, name)
MODELS = {'764x': (55.0, 70.0, '86C764X (Trio64 PnP)'), '764p': (50.0, 60.0, '86C764-P')}
OVERCLOCK_MAX = 100.0                           # --overclock: at most twice 50 MHz (the user's limit)

BLOCKS = [
    ('tlock.asm', 'TLOCK', 0x0871 - 0x0831, ('wcheck', 'unlk')),
    ('tbon.asm', 'TBON', 0x0BA6 - 0x0B4C, ('bon', 'relk')),      # calls wcheck, unlk
    ('thook.asm', 'THOOK', 0x0BD0 - 0x0BA6, ('hook',)),           # calls unlk, relk
    ('tglue.asm', 'TGLUE', 0x0DF6 - 0x0DEF, ('h4f02',)),          # calls hook, bon
    ('twset.asm', 'TWSET', 0x4DE0 - 0x4DD1, ('wsetp',)),          # calls bon
    ('font32.asm', 'FONT32', 0x0631 - 0x0604, ('font',)),
    ('scr13w.asm', 'SCR13W', 0x0184 - 0x0130, ('scr13w',)),
    ('scr13.asm', 'SCR13', 0x7FFF - 0x7F91, ('scr13',)),          # jumps to scr13w
    ('p13fill.asm', 'P13A', 0x4EEE - 0x4EBE, ('wfillt', 'wfill')),
    ('p13df.asm', 'DFDN', 0x4E3A - 0x4E2E, ('dfdn',)),
    ('p13move.asm', 'P13B', 0x0DEF - 0x0DDD, ('wmove',)),
    ('p13bfill.asm', 'BFILL', 0x0D92 - 0x0D79, ('bfill0', 'bfill')),
    ('p13bfa.asm', 'P13C', 14, ('bfilla',)),                      # dead: the old font loop
    ('twin.asm', 'TWIN', 0x4D82 - 0x4D70, ('sr04',)),
    ('tfifo.asm', 'TFIFO', 0x5342 - 0x52E1, ('fifo', 'kmclk')),      # in the VDIF code zeroed before
    ('tfifo2.asm', 'TFIFO2', 0x00E4 - 0x00AE, ('fifo2',)),          # in the sign-on padding
]


def lists_of(d):
    """The mode table as [(entry offset, mode, block, list end)] and each mode's refresh entries."""
    modes = []
    a = MTAB
    while d[a] != 0xFF:
        if a > 0x0700:
            raise PatchError('mode table at %04X has no end' % MTAB)
        modes.append((a, d[a], struct.unpack_from('<H', d, a + 1)[0], struct.unpack_from('<H', d, a + 7)[0]))
        a += 9
    chains = {}
    for e, m, blk, end in modes:
        if not (LISTS[0] <= end < LISTS[1] and (end - LISTS[0]) % ENT == 0):
            raise PatchError('mode %02X: refresh list end %04X outside the lists' % (m, end))
        p, chain = end, []
        while True:
            chain.append(p)
            if d[p + 2] & 0x80:
                break
            p -= ENT
            if p < LISTS[0]:
                raise PatchError('mode %02X: refresh list without a first entry' % m)
        chains[m] = chain[::-1]
    return modes, a, chains


def edit_tables(d, log):
    """Remove the interlaced entries and modes and move the tables together (see the file header).
    Returns the freed ranges [(start, end)]."""
    for e, b in ILACE.items():
        if bytes(d[e:e + 5]) != bytes.fromhex(b):
            raise PatchError('refresh entry %04X: expected %s, found %s' % (e, b, d[e:e + 5].hex(' ')))
    modes, mend, chains = lists_of(d)
    if not set(REMOVE) <= {m for _, m, _, _ in modes}:
        raise PatchError('mode table lacks one of %s' % ', '.join('%02X' % m for m in REMOVE))
    for _, m, _, _ in modes:
        ch = chains[m]
        inter = [e for e in ch if e in ILACE]
        if m in REMOVE:
            if ch != inter:
                raise PatchError('mode %02X: expected interlaced entries only, list %s' % (m, ch))
        elif inter and (inter != ch[:1] or len(ch) < 2):
            raise PatchError('mode %02X: an interlaced entry that is not the first of several' % m)
    # refresh lists: the kept entries end to end, new first entries marked
    order = list(range(LISTS[0], LISTS[1], ENT))
    keep = [e for e in order if e not in ILACE]
    newpos = {e: LISTS[0] + i * ENT for i, e in enumerate(keep)}
    old = bytes(d)
    region = b''.join(old[e:e + ENT] for e in keep)
    d[LISTS[0]:LISTS[1]] = region + bytes(LISTS[1] - LISTS[0] - len(region))
    for _, m, _, _ in modes:
        ch = chains[m]
        if m not in REMOVE and ch[0] in ILACE:
            d[newpos[ch[1]] + 2] |= 0x80
    log.append('%04X-%04X  refresh lists: %d interlaced entries removed, %d kept, first entries marked'
               % (LISTS[0], LISTS[1] - 1, len(ILACE), len(keep)))
    # mode table
    tab = b''
    for e, m, blk, end in modes:
        if m in REMOVE:
            continue
        ent = bytearray(old[e:e + 9])
        struct.pack_into('<H', ent, 7, newpos[end])
        tab += bytes(ent)
    tab += b'\xff'
    d[MTAB:mend + 1] = tab + bytes(mend + 1 - MTAB - len(tab))
    log.append('%04X-%04X  mode table: S3 modes %s removed, list ends rewritten'
               % (MTAB, mend, ', '.join('%02Xh' % m for m in sorted(REMOVE))))
    free = [(LISTS[0] + len(region), LISTS[1]), (MTAB + len(tab), mend + 1)]
    # VESA lists and the mode map (code area: the same in every 1.5-07 build)
    l1, a = [], VLIST
    while struct.unpack_from('<H', d, a)[0] != 0xFFFF:
        l1.append(struct.unpack_from('<H', d, a)[0])
        a += 2
    l2 = []
    a += 2
    while struct.unpack_from('<H', d, a)[0] != 0xFFFF:
        l2.append(struct.unpack_from('<H', d, a)[0])
        a += 2
    lend = a + 2
    mp, a = [], VMAP
    while d[a] != 0xFF:
        mp.append(bytes(d[a:a + 3]))
        a += 3
    mapend = a + 1
    if len(mp) != len(l1) + 9 or mp[len(l1)] != b'\x80\x00\x00':
        raise PatchError('VESA mode map at %04X does not follow the list at %04X' % (VMAP, VLIST))
    rmv = set(REMOVE.values())
    for i, v in enumerate(l1):
        if v in rmv and REMOVE.get(mp[i][0]) != v:
            raise PatchError('VESA mode %03Xh maps to S3 mode %02Xh' % (v, mp[i][0]))
    keep1 = [i for i, v in enumerate(l1) if v not in rmv]
    if len(l1) - len(keep1) != len(REMOVE):
        raise PatchError('VESA list lacks one of %s' % ', '.join('%03Xh' % v for v in sorted(rmv)))
    lists = b''.join(struct.pack('<H', l1[i]) for i in keep1) + b'\xff\xff' + \
        b''.join(struct.pack('<H', v) for v in l2 if v not in rmv) + b'\xff\xff'
    d[VLIST:lend] = lists + bytes(lend - VLIST - len(lists))
    mpb = b''.join(mp[i] for i in keep1) + b''.join(mp[len(l1):]) + b'\xff'
    d[VMAP:mapend] = mpb + bytes(mapend - VMAP - len(mpb))
    log.append('%04X-%04X  VESA lists and mode map: %s removed' % (VLIST, mapend - 1, ', '.join('%03Xh' % v for v in sorted(rmv))))
    free += [(VLIST + len(lists), lend), (VMAP + len(mpb), mapend)]
    for lo, hi in DROPPED:
        d[lo:hi] = bytes(hi - lo)
    log.append('            freed: %s' % ', '.join('%04X-%04X' % (lo, hi - 1) for lo, hi in free + DROPPED))
    return free + DROPPED


def put_fonts(d, src, log):
    """Replace Phoenix's fonts in d by S3's from src (1.03-08) and point Phoenix's references to the
    moved tables (FONT_REFS) at their new places; every table and reference is checked first."""
    new = {}
    for name, so, ln, sha, at in S3FONTS:
        if hashlib.sha256(bytes(src[so:so + ln])).hexdigest() != sha:
            raise PatchError('font source: the %s font at %04X is not that of 1.03-08' % (name, so))
    if bytes(d[FONT_TAB[0]:FONT_TAB[0] + 12]) != bytes.fromhex(FONT_TAB[1]):
        raise PatchError('the AX=1130h font table at %04X is not 1.5-07\'s' % FONT_TAB[0])
    for a, old in FONT_REFS.items():
        if struct.unpack_from('<H', d, a)[0] != old or (a in FONT_REF_OP and d[a - 1] != FONT_REF_OP[a]):
            raise PatchError('font reference %04X: expected %02X %04X' % (a, FONT_REF_OP.get(a, 0), old))
    if bytes(d[PHX_FONTS[1]:FONTS[1]]) != bytes(FONTS[1] - PHX_FONTS[1]):
        raise PatchError('%04X-%04X, where the fonts grow, is not free' % (PHX_FONTS[1], FONTS[1] - 1))
    d[FONTS[0]:FONTS[1]] = bytes(FONTS[1] - FONTS[0])
    end = FONTS[0]
    for name, so, ln, sha, at in S3FONTS:
        if at != end:
            raise PatchError('font %s at %04X, expected %04X (end to end)' % (name, at, end))
        d[at:at + ln] = src[so:so + ln]
        end = at + ln
        log.append('%04X-%04X  %s font: S3\'s (1.03-08)' % (at, end - 1, name))
    if end != FONTS[1]:
        raise PatchError('the fonts end at %04X, expected %04X' % (end, FONTS[1]))
    moved = {0x6E30: [x[4] for x in S3FONTS if x[0] == '8x16'][0], 0x7E30: [x[4] for x in S3FONTS if x[0] == '9x16 alternate'][0]}
    for a, old in sorted(FONT_REFS.items()):
        struct.pack_into('<H', d, a, moved[old])
        log.append('%04X  %04X -> %04X  font reference (%s)' % (a, old, moved[old],
                   'AX=1130h table' if a not in FONT_REF_OP else 'mov %s' % ('bx' if FONT_REF_OP[a] == 0xBB else 'si')))


def patch(lo, nasm='nasm', mclk=None, fonts=None, overclock=False, model='764x'):
    """lo: the 32 KB 1.5-07 image, fonts: the 1.03-08 image (default FONT_SRC). Returns (new 32 KB,
    log lines)."""
    d = bytearray(lo)
    log = []
    m = re.search(rb'Phoenix S3 TRIO64 Enhanced VGA BIOS\. Version (\d\.\d-\d\d)', d[:0x100])
    if not m:
        raise PatchError('no "Phoenix S3 TRIO64 Enhanced VGA BIOS. Version x.x-xx" sign-on in the first 256 bytes')
    if m.group(1).decode() != VERSION:
        raise PatchError('BIOS version %s: only the Phoenix Trio64 BIOS %s is supported' % (m.group(1).decode(), VERSION))
    if sum(d) & 0xFF:
        raise PatchError('the 32 KB do not checksum to 00: not a clean %s image' % VERSION)
    if d[0:3] != b'\x55\xAA\x40':
        raise PatchError('no 55AAh ROM header with 32 KB size at offset 0')
    if CODE_SHA and hashlib.sha256(bytes(d[0x1000:0x7F00])).hexdigest() != CODE_SHA:
        raise PatchError('1000h-7EFFh is not the code of the 1.5-07 builds (another version, or already patched?)')
    a = ALT916[0]
    while d[a] and a < ALT916[1]:
        a += 17
    if a != ALT916[1] or d[a]:
        raise PatchError('the 9x16 alternate font table at %04X does not end at %04X' % ALT916)
    for lo_, hi in UNUSED:
        if bytes(d[lo_:hi]) != bytes(hi - lo_):
            raise PatchError('%04X-%04X is not free (another build, or already patched?)' % (lo_, hi - 1))
    sym = s3patch.bios_symbols(os.path.join(HERE, 'bios.inc'))
    site = SITES
    for k, off in site.items():
        if k in SIG and not sig_match(d, off - (2 if k == 'cr67' else 0), SIG[k]):
            raise PatchError('%s: original code not found at %04X' % (k, off))
    for k, sig in SYMSIG:
        if not sig_match(d, sym[k], sig):
            raise PatchError('%s: not found at %04X' % (k, sym[k]))
    if struct.unpack_from('<H', d, site['modetab'])[0] != sym['MODESET']:
        raise PatchError('INT 10h AH=00 table entry at %04X is not the mode set' % site['modetab'])
    if call_target(d, site['m4f02'] + 6) != sym['MODESET'] or struct.unpack_from('<H', d, site['m4f02'] + 4)[0] != sym['SEG_BDA']:
        raise PatchError('VBE 4F02 does not call the mode set at %04X with DS from %04X' % (sym['MODESET'], sym['SEG_BDA']))
    if struct.unpack_from('<HHH', d, sym['SEG_SCR']) != (0, 0, 0xA000) or sym['SEG_BDA'] != sym['SEG_SCR'] + 2 \
            or sym['SEG_VID'] != sym['SEG_SCR'] + 4:
        raise PatchError('SEG_SCR/SEG_BDA/SEG_VID are not the words 0000h, 0000h, A000h at %04X' % sym['SEG_SCR'])
    if struct.unpack_from('<H', d, site['scr'] + 0x57)[0] != sym['SEG_SCR']:
        raise PatchError('mode 13h scroll does not load DS from %04X' % sym['SEG_SCR'])
    i = site['int10'] + 2
    if (i + 3 + 2 + d[i + 4], i + 5) != (sym['INT_AH0E'], sym['INT_NEXT']):
        raise PatchError('INT 10h entry targets differ from bios.inc')
    if (site['scr'] + 6, site['scr'] + 6 + d[site['scr'] + 5]) != (sym['SCR_FULL'], sym['SCR_WIN']):
        raise PatchError('mode 13h scroll targets differ from bios.inc')
    for k, base in (('wsr04', 'WSET'), ('gsr04', 'GWIN')):
        if call_target(d, site[k]) != sym['RDREG'] or not sym[base] < site[k] < sym[base] + 0x2D:
            raise PatchError('%s: the SR04 read at %04X is not a call of RDREG in %s' % (k, site[k], base))
    if sym['P13C'] != site['font'] + 3:
        raise PatchError('P13C is not the dead code after the font load jump')

    def put(off, old, new, why):
        old, new = (bytes.fromhex(x) if isinstance(x, str) else bytes(x) for x in (old, new))
        if bytes(d[off:off + len(old)]) != old:
            raise PatchError('%04X: expected %s, found %s (%s)' % (off, old.hex(' '), d[off:off + len(old)].hex(' '), why))
        d[off:off + len(new)] = new
        log.append('%04X  %-17s -> %-17s %s' % (off, old.hex(' '), new.hex(' '), why))

    # 1. tables, then the sign-on (its padding holds code too)
    edit_tables(d, log)
    s = m.start(1)
    end = d.index(b'\x00', s)
    txt = bytes(d[s:end]).replace(VERSION.encode(), (VERSION + '-' + LEVEL).encode(), 1)
    stop = end
    top = sym['TFIFO2']   # tfifo2.asm follows in this padding
    while stop < top and d[stop] == 0:
        stop += 1
    if s + len(txt) + 1 > stop:
        raise PatchError('no room for the longer sign-on')
    d[s:s + len(txt) + 1] = txt + b'\x00'
    log.append('%04X  sign-on "%s"' % (s, txt.split(b'\r')[0].decode()))

    put_fonts(d, open(FONT_SRC, 'rb').read() if fonts is None else fonts, log)

    for lo_, hi, sig in DDC_FREED:                  # the VDIF code: zeroed first, tfifo.asm goes there
        if not sig_match(d, lo_, sig):
            raise PatchError('%04X: not the VDIF code (%s)' % (lo_, sig))
        d[lo_:hi] = bytes(hi - lo_)
        log.append('%04X-%04X  VBE 4F15: VDIF code zeroed (%d bytes free)' % (lo_, hi - 1, hi - lo_))

    # 2. code, each block into space that is zero now
    blocks, lab = s3patch.assemble(sym, nasm, (HERE, SHARED), BLOCKS)
    patch.blocks = blocks
    for off, code, name in blocks:
        if name != 'p13bfa.asm' and bytes(d[off:off + len(code)]) != bytes(len(code)):
            raise PatchError('%s: %04X-%04X is not free' % (name, off, off + len(code) - 1))
        d[off:off + len(code)] = code
        log.append('%04X-%04X  %-12s %s' % (off, off + len(code) - 1, name,
                   ', '.join('%s %04X' % (k, lab[k]) for b in BLOCKS if b[0] == name for k in b[3])))

    # 3. sites
    a = site['modetab']
    put(a, struct.pack('<H', sym['MODESET']), struct.pack('<H', lab['hook']), 'INT 10h AH=00 table: mode set via the hook')
    a = site['m4f02'] + 6
    put(a, d[a:a + 3], call(a, lab['h4f02']), 'VBE 4F02: mode set via the hook, then the booster unless Windows runs')
    a = sym['WSET']
    put(a, '52 53 b8 4f 01', jmp(a, lab['wsetp']) + b'\x90\x90', 'VBE window set (4F05, window function): booster on with BH = 0')
    for k in ('wsr04', 'gsr04'):
        a = site[k]
        put(a, d[a:a + 3], call(a, lab['sr04']), 'VBE window %s: SR04 read with the sequencer index kept'
            % ('set' if k == 'wsr04' else 'get'))
    speed_sites(d, put, site, sym, lab, tags=False, skip=('wset', 'clr', 'int10'))
    for a, old, new in DDC_SITES:
        put(a, old, new, 'VBE 4F15: VDIF deleted')
    a = site['cr67']
    put(a, '26 8a 65 0b ef', call(a, lab['fifo']) + b'\x90\x90',
        'mode set: CR67, then the display FIFO M (CR54) lowered to what the memory bandwidth allows')
    a = site['post52'] + 10
    put(a, 'b8 52 00', 'b8 52 80', 'POST: CR52 = 80h, 800x600 defaults to 60 Hz (VESA DMT) instead of 56 Hz')
    if mclk is not None:
        fmin, fmax, name = MODELS[model]
        if mclk < fmin:
            raise PatchError('--mclk %g is below the %g MHz the %s takes (--model)' % (mclk, fmin, name))
        if mclk > fmax and not overclock:
            raise PatchError('--mclk %g is above the %g MHz the %s takes (--model; --overclock for more)'
                             % (mclk, fmax, name))
        mclk_put(d, put, MCLK_ENTRY, 'any', mclk, OVERCLOCK_MAX if overclock else fmax,
                 known=s3patch.KNOWN_MCLK_8811)    # the pairs Trio32/64/V+ BIOSes use first
    k = round(112 * 1000 * mclk_of(d))             # 112 x MCLK kHz for the FIFO code, from the final 3B5h pair
    a = lab['kmclk']
    put(a, d[a:a + 4], struct.pack('<I', k), 'FIFO code: 112 x MCLK = %d (MCLK %.2f MHz)' % (k, mclk_of(d)))

    # 4. checksum
    d[0x7FFF] = 0
    d[0x7FFF] = (-sum(d)) & 0xFF
    log.append('7FFF  checksum %02X -> %02X' % (lo[0x7FFF], d[0x7FFF]))
    return bytes(d), log


def verify(img, size):
    errs = []
    if len(img) != size * 1024:
        errs.append('image is %d bytes, not %d' % (len(img), size * 1024))
    if sum(img[:0x8000]) & 0xFF:
        errs.append('the 32 KB checksum is not 00')
    if len(img) > 0x8000 and img[0x8000:] != img[:0x8000]:
        errs.append('upper 32 KB is not a copy of the lower 32 KB')
    if img[0:3] != b'\x55\xAA\x40':
        errs.append('ROM header 55AAh with 32 KB size missing')
    try:
        modes, _, chains = lists_of(img)
        if {m for _, m, _, _ in modes} & set(REMOVE):
            errs.append('an interlaced-only mode is still in the mode table')
        ilace_crtc = {bytes.fromhex(b)[:2] for b in ILACE.values()}   # the CRTC tables of the interlaced entries
        for m, ch in chains.items():
            if any(bytes(img[e:e + 2]) in ilace_crtc and img[e + 3] == bytes.fromhex(ILACE[x])[3]
                   for e in ch for x in ILACE if bytes(img[e:e + 2]) == bytes.fromhex(ILACE[x])[:2]):
                errs.append('mode %02X: an interlaced entry is still in its refresh list' % m)
    except PatchError as e:
        errs.append(str(e))
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
               'every block is as in the tested build: the difference is in the patch sites or tables')
    with open(output + '.untested', 'wb') as f:
        f.write(img)
    out.append('the untested image is in %s.untested; do not flash it' % output)
    return out


def mclk_of(img):
    """The MCLK in MHz of the PLL pair at 3B5h (M, then N and R)."""
    m, nr = img[0x3B5], img[0x3B6]
    return 14.31818 * (m + 2) / ((nr & 0x1F) + 2) / (1 << ((nr >> 5) & 3))


def main():
    ap = argparse.ArgumentParser(description='build %s-%s from the Phoenix S3 Trio64 BIOS %s' % (VERSION, LEVEL, VERSION))
    ap.add_argument('input', help='a Phoenix Trio64 BIOS 1.5-07: 32 KB, or a 64 KB image with it in the lower half')
    ap.add_argument('-o', '--output', required=True, help='the result (64 KB, the 32 KB twice; 32 KB with --size 32)')
    ap.add_argument('--size', type=int, choices=(32, 64), default=64, help='output size in KB (default 64: the 32 KB twice)')
    ap.add_argument('--mclk', type=float, help='MCLK in MHz for the single MCLK entry, at most %g (default: the '
                    'build\'s own; the data book gives %g)' % (MCLK_MAX, DATABOOK_MAX))
    ap.add_argument('--model', choices=sorted(MODELS), default='764x',
                    help='the Trio64 model: 764x (86C764X, MCLK 55-70 MHz, the default) or 764p (86C764-P, 50-60 MHz)')
    ap.add_argument('--overclock', action='store_true', help='allow --mclk above %g MHz, up to %g MHz: an overclock, '
                    'the card owner\'s choice' % (MCLK_MAX, OVERCLOCK_MAX))
    ap.add_argument('--nasm', default='nasm', help='nasm executable (default: nasm on PATH)')
    ap.add_argument('--fonts', default=FONT_SRC, help='the Trio64V+ BIOS 1.03-08 to take S3\'s fonts from '
                    '(default reference/64vplus/1_03_08n.bin)')
    ap.add_argument('--fonts-only', action='store_true', help='apply the fonts only (and the checksum): the '
                    'reference make 764-ref-compare compares our ROM with')
    ap.add_argument('-q', '--quiet', action='store_true', help='print only the result line')
    a = ap.parse_args()
    try:
        src = open(a.input, 'rb').read()
        if len(src) not in (0x8000, 0x10000):
            raise PatchError('input is %d bytes; expected 32768 or 65536' % len(src))
        lo = src[:0x8000]
        fonts = open(a.fonts, 'rb').read()
        if a.fonts_only:
            d, log = bytearray(lo), []
            if sum(d) & 0xFF or hashlib.sha256(bytes(d[0x1000:0x7F00])).hexdigest() != CODE_SHA:
                raise PatchError('not a clean %s image (checksum or the code 1000h-7EFFh)' % VERSION)
            put_fonts(d, fonts, log)
            d[0x7FFF] = 0
            d[0x7FFF] = (-sum(d)) & 0xFF
            with open(a.output, 'wb') as f:
                f.write(bytes(d) * (2 if a.size == 64 else 1))
            print('%s: %s with S3\'s fonts only (the 764-ref-compare reference)' % (a.output, VERSION))
            return 0
        if a.overclock and a.mclk is None:
            raise PatchError('--overclock needs --mclk')
        new_lo, log = patch(lo, a.nasm, a.mclk, fonts, a.overclock, a.model)
        img = new_lo * (2 if a.size == 64 else 1)
        errs = verify(img, a.size)
        known = hashlib.sha256(lo).hexdigest() == REF_SHA and RESULT_SHA and a.mclk is None
        out_sha = hashlib.sha256(new_lo).hexdigest()
        if known and out_sha != RESULT_SHA:
            errs.append('result differs from the tested build (SHA-256 of the 32 KB %s, expected %s)' % (out_sha, RESULT_SHA))
            errs += diagnose(a.nasm, a.output, img)
        if errs:
            raise PatchError('result check failed:\n  ' + '\n  '.join(errs))
    except (PatchError, OSError) as e:
        print('s3tpatch: %s' % e, file=sys.stderr)
        return 1
    with open(a.output, 'wb') as f:
        f.write(img)
    if not a.quiet:
        ref = hashlib.sha256(lo).hexdigest() == REF_SHA
        print('base %s%s' % (VERSION, ' (the reference CP764 build)' if ref else ' (another 1.5-07 build: its own clock and timing bytes kept)'))
        for line in log:
            print('  ' + line)
    print('%s: %s-%s, %d KB, checksum %02X (the lower 32 KB sums to 00), SHA-256 of the 32 KB %s%s'
          % (a.output, VERSION, LEVEL, a.size, img[0x7FFF], out_sha,
             ', identical to the tested build' if known or out_sha == RESULT_SHA else
             ', MCLK build option: the code is the tested build, the MCLK is yours to check on the card'
             if a.mclk is not None else ''))
    f = mclk_of(img)
    if f > MODELS[a.model][1]:
        print('OVERCLOCK: MCLK %.2f MHz is above %g MHz; check the memory with S3COMPAT\'s VRAM test (S3TEST '
              'fails its MCLK line by design)' % (f, MODELS[a.model][1]))
    return 0


if __name__ == '__main__':
    sys.exit(main())
