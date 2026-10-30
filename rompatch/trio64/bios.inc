; bios.inc - addresses in the Phoenix S3 Trio64 BIOS 1.5-07 (reference/trio64/1_5_07.bin, the CP764 build;
;            the code 1000h-7EFFh is the same in every 1.5-07 build) that the Trio64 patch code uses
;            (C000:offset)
;
; s3tpatch.py reads these lines too (the name, then the value). The shared files of rompatch/ include this
; file instead of rompatch/bios.inc when s3tpatch.py assembles them (this directory first in the -i paths).
%define MODESET  0x1819     ; mode set (AL = mode), the INT 10h AH=00 handler
%define GETCRTC  0x0FDD     ; DX = 3B4h/3D4h (keeps AX)
%define RDREG    0x4640     ; AL = index at port DX -> AH = value, AL = index
%define SEG_SCR  0x1486     ; word 0000h: DS for the BIOS data area (scroll code)
%define SEG_BDA  0x1488     ; word 0000h: DS for the BIOS data area (INT 10h and VBE code)
%define SEG_VID  0x148A     ; word A000h: video segment
%define INT_AH0E 0x5703     ; INT 10h entry: jump to the AH=0Eh handler
%define INT_NEXT 0x56CD     ; INT 10h entry after 'cmp ah,0Eh / jz'
%define SCR_FULL 0x2382     ; mode 13h scroll, original full-width path
%define SCR_WIN  0x23A9     ; mode 13h scroll, original window path
%define WSET     0x5123     ; VBE window set (BH = window, DX = bank): 4F05 and the window function, any BH
%define P13C     0x0EAC     ; bfilla: the old 8-bit font load loop after the font jump (dead, 14 bytes)
; the new code, in the space s3tpatch.py frees or finds unused (see its FREE list)
%define TBON     0x0B4C     ; bon, unlk, relk (tbon.asm): the end of the refresh lists after their compaction
%define TLOCK    0x0831     ; wcheck (tlock.asm): the register block of 1600x1200 (removed)
%define THOOK    0x0140     ; hook (thook.asm): the zero padding after the second sign-on block
%define TGLUE    0x085A     ; h4f02, wsetp (tglue.asm): the rest of the 1600x1200 register block
%define SCR13    0x7F52     ; scr13 (scr13.asm): the zeros at the end of the image (the 9x16 alternate font
                            ; table, 7E30h, ends with its 00h at 7F51h)
%define FONT32   0x0604     ; font (font32.asm): the end of the mode table after its compaction
%define P13A     0x4EBE     ; wfillt/wfill (p13fill.asm): the 4F01 records of 118h-120h
%define DFDN     0x4E2E     ; dfdn (p13df.asm): the 4F01 record of 106h
%define BFILL    0x0D79     ; bfill0/bfill (p13bfill.asm): a CRTC table of a removed interlaced entry
%define P13B     0x0DDD     ; wmove (p13move.asm): a CRTC table of a removed interlaced entry
