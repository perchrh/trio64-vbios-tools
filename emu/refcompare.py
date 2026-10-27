#!/usr/bin/env python3
"""refcompare.py - the EGA/CGA behaviour of the ROM against the unpatched S3 reference BIOS 2.04.07.

    python3 emu/refcompare.py --ref REF2047.BIN --upper STOCK.BIN --rom S3V2P14.BIN
    make ref-compare REF=REF2047.BIN UPPER=STOCK.BIN ROM=S3V2P14.BIN

Goal (AGENTS.md): in the CGA, MDA and EGA modes (00h-07h, 0Dh-10h) the ROM behaves like the reference
BIOS. Both run the same INT 10h calls in the emulator: mode sets at 200, 350 and 400 lines and without
the clear, AH=06h/07h scrolls with random windows and fills, AH=08h/09h/0Ah/0Eh text output, AH=0Ch/0Dh
pixels, palettes (AH=0Bh, AX=10xxh), pages, cursor, fonts, AH=12h, AH=1Ah, AH=1Ch. After each call
the registers a program gets back (with bits 31-16), the BIOS data area, video memory (A000-BFFF and the
four planes), the DAC and the standard VGA registers (MISC, SR00-04, CR00-18, GR00-08, AR00-14) must
be the same. The S3 extended registers are not compared: the ROM sets the memory clock, the pedestal
and the FIFO bit on purpose. Exit code 1 when any call differs; the differences are listed.
"""
import argparse
import os, sys, random, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from vgaemu import Machine
from unicorn.x86_const import *
ap = argparse.ArgumentParser(description=__doc__.split('\n')[1])
ap.add_argument('--ref', required=True, help='S3 reference BIOS 2.04.07 (32 KB)')
ap.add_argument('--upper', required=True, help='image with the upper half (the stock 64 KB dump)')
ap.add_argument('--rom', required=True, help='the ROM to compare (64 KB)')
a = ap.parse_args()
ref=open(a.ref,'rb').read(); up=open(a.upper,'rb').read()[0x8000:]
A=Machine(ref[:0x8000]+up); A.post(); B=Machine(open(a.rom,'rb').read()); B.post()
R32=(UC_X86_REG_EAX,UC_X86_REG_EBX,UC_X86_REG_ECX,UC_X86_REG_EDX,UC_X86_REG_ESI,UC_X86_REG_EDI)
def std(m):
    r=m.r
    return (r['misc'],tuple(r['seq'].get(i,0) for i in range(5)),tuple(r['crtc'].get(i,0) for i in range(0x19)),
            tuple(r['gc'].get(i,0) for i in range(9)),tuple(r['atc'].get(i,0) for i in range(0x15)))
def state(m): return std(m)+(m.mem(0x400,0x100),m.mem(0xA0000,0x20000),tuple(bytes(p) for p in m.planes),tuple(map(tuple,m.dac)))
names=['misc','seq','crtc','gc','atc','bda','mem','planes','dac']
def call(m,ax,**kw):
    for reg,v in zip(R32,(0x11110000,0x22220000,0x33330000,0x44440000,0x55550000,0x66660000)): m.mu.reg_write(reg,v)
    res=m.int10(ax,**kw); return res,tuple(m.mu.reg_read(r)>>16 for r in R32)
n=0; bad=collections.Counter(); ex=[]
def both(label,ax,**kw):
    global n
    ra=call(A,ax,**kw); rb=call(B,ax,**kw); n+=1
    sa,sb=state(A),state(B)
    d=[names[i] for i,(x,y) in enumerate(zip(sa,sb)) if x!=y]
    if ra!=rb: d.append('regs')
    if d:
        bad[(label.split()[0],tuple(d))]+=1
        if len(ex)<12: ex.append((label,'%04X'%ax,d, [ (i,sa[2][i],sb[2][i]) for i in range(0x19) if sa[2][i]!=sb[2][i]] if 'crtc' in d else ''))
def fill(seed):
    rnd=random.Random(seed); data=bytes(rnd.randrange(256) for _ in range(0x20000))
    for m in (A,B):
        m.mu.mem_write(0xA0000,data); m.planes=[bytearray(data[p*0x8000:p*0x8000+0x8000]*2) for p in range(4)]
rnd=random.Random(7)
MODES=(0,1,2,3,4,5,6,7,0x0D,0x0E,0x0F,0x10)
for lines in (0,1,2):
    for mode in MODES:
        both('scanlines',0x1200|lines,bx=0x30); fill(mode); both('modeset %02X'%mode,mode); both('noclear',mode|0x80)
both('scanlines',0x1202,bx=0x30)
for mode in MODES:
    both('modeset',mode)
    rows=A.mem(0x484,1)[0]+1; cols=A.mem(0x44A,1)[0]
    for _ in range(14):
        r0=rnd.randrange(rows); r1=rnd.randrange(r0,rows); c0=rnd.randrange(cols); c1=rnd.randrange(c0,cols)
        for ah in (6,7):
            fill(n); both('scroll',(ah<<8)|rnd.choice((0,1,2,5)),bx=rnd.randrange(256)<<8,cx=(r0<<8)|c0,dx=(r1<<8)|c1)
    for k in range(30):
        both('cursor',0x0200,dx=(rnd.randrange(rows)<<8)|rnd.randrange(cols))
        f=rnd.choice((0x09,0x0A,0x0E,0x08))
        both('textout',(f<<8)|rnd.randrange(256),bx=rnd.randrange(256),cx=rnd.choice((1,2,3,7,80)))
    for k in range(40):
        both('pixel',0x0C00|rnd.randrange(256),cx=rnd.randrange(640),dx=rnd.randrange(200))
        both('pixelrd',0x0D00,cx=rnd.randrange(640),dx=rnd.randrange(200))
    for ax,kw in ((0x0B00,dict(bx=0x0005)),(0x0B00,dict(bx=0x0101)),(0x1000,dict(bx=0x0302)),(0x1001,dict(bx=0x0400)),(0x1003,dict(bx=0)),(0x1003,dict(bx=1)),
                  (0x1010,dict(bx=5,cx=0x1020,dx=0x3000)),(0x1007,dict(bx=3)),(0x1013,dict(bx=0x0100)),(0x0500|1,{}),(0x0500,{}),(0x0100,dict(cx=0x0607)),(0x0F00,{}),(0x1A00,{}),
                  (0x1111,dict(bx=0)),(0x1112,dict(bx=0)),(0x1114,dict(bx=0)),(0x1130,dict(bx=0x0300)),(0x1201,dict(bx=0x0033)),(0x1200,dict(bx=0x0034)),(0x1C00,dict(cx=7))):
        both('func %04X'%ax,ax,**kw)
print('%d calls in modes 00h-07h and 0Dh-10h: %s' % (n, 'no difference' if not bad else '%d differ' % sum(bad.values())))
for k, v in sorted(bad.items()):
    print('  %4d x %-10s %s' % (v, k[0], ', '.join(k[1])))
for e in ex:
    print('  e.g.', e)
sys.exit(1 if bad else 0)
