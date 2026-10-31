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
%define GWIN     0x5148     ; VBE window get (BH = 1 -> DX = bank): after WSET in 4F05 and the window function
%define P13C     0x0EAC     ; bfilla: the old 8-bit font load loop after the font jump (dead, 14 bytes)
; the new code, in the space s3tpatch.py frees or finds unused (see its FREE list)
%define TBON     0x0B4C     ; bon, relk (tbon.asm): the end of the refresh lists after their compaction
%define THOOK    0x0BA6     ; hook (thook.asm): right after tbon.asm, up to 0BCFh
%define TLOCK    0x0831     ; wcheck, unlk (tlock.asm): the register block of 1600x1200 (removed), all 64
                            ; bytes (0871h, right after it, is named by a word at 01C7h and stays)
%define TGLUE    0x0DEF     ; h4f02 (tglue.asm): after wmove, the rest of a removed CRTC table
%define TWSET    0x4DD1     ; wsetp (twset.asm): the end of the VESA mode map after its compaction
%define SCR13    0x7F91     ; scr13 (scr13.asm): the zeros at the end of the image, after S3's fonts
                            ; (the 9x16 alternate table ends at 7F90h)
%define SCR13W   0x0130     ; the window path of scr13 (scr13w.asm): the zero padding after the second
                            ; sign-on block (in use up to 012Ch in the builds at hand)
%define FONT32   0x0604     ; font (font32.asm): the end of the mode table after its compaction
%define P13A     0x4EBE     ; wfillt/wfill (p13fill.asm): the 4F01 records of 118h-120h
%define DFDN     0x4E2E     ; dfdn (p13df.asm): the 4F01 record of 106h
%define BFILL    0x0D79     ; bfill0/bfill (p13bfill.asm): a CRTC table of a removed interlaced entry
%define P13B     0x0DDD     ; wmove (p13move.asm): a CRTC table of a removed interlaced entry
%define TWIN     0x4D70     ; sr04 (twin.asm): the end of the first VESA list after its compaction
%define TFIFO    0x52E1     ; fifo (tfifo.asm): the deleted VDIF code of 4F15, all 97 bytes (p2)
%define TFIFO2   0x00AE     ; fifo2 (tfifo2.asm): the zero padding after the first sign-on block, up to
                            ; 00E3h (the p2 sign-on ends at 00ABh)
