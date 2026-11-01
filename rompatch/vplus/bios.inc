; bios.inc - addresses in the S3 Trio64V+ BIOS 1.03-08 (32 KB, reference/64vplus/1_03_08.bin) that the
;            Trio64V+ patch code uses (C000:offset)
;
; s3vpatch.py reads these lines too (the name, then the value), for its own checks of the BIOS code at
; these addresses. The shared files of rompatch/ (clear32.asm, p13*.asm) include this file instead of
; rompatch/bios.inc when s3vpatch.py assembles them (it puts this directory first in the -i paths).
%define MODESET  0x1545     ; mode set (AL = mode), the INT 10h AH=00 handler
%define UNLOCK   0x0B61     ; CR38 = 48h, CR39 = A5h (keeps AX, DX)
%define GETCRTC  0x0B71     ; DX = 3B4h/3D4h (keeps AX)
%define RDREG    0x42AD     ; AL = index at port DX -> AH = value, AL = index
%define SEG_SCR  0x11B5     ; word 0000h: DS for the BIOS data area (scroll code)
%define SEG_BDA  0x11B7     ; word 0000h: DS for the BIOS data area (INT 10h and VBE code)
%define SEG_VID  0x11B9     ; word A000h: video segment
%define INT_AH0E 0x5254     ; INT 10h entry: jump to the AH=0Eh handler
%define INT_NEXT 0x521E     ; INT 10h entry after 'cmp ah,0Eh / jz': AH=0Ch/0Dh tests, then the dispatcher
%define SCR_FULL 0x2083     ; mode 13h scroll, original full-width path
%define SCR_WIN  0x20AA     ; mode 13h scroll, original window path
%define CLR_RET  0x0E6A     ; end of the S3/VESA mode set clear: pop ds / pop es / popa / ret
%define P13B     0x0E55     ; wmove: the old 16-bit clear loop after the clear jump (dead, 21 bytes)
%define P13C     0x0B2C     ; bfilla: the old 8-bit font load loop after the font jump (dead, 14 bytes)
%define WSET     0x49C1     ; VBE window set (BX = window, DX = bank): 4F05 BH=0 and the window function
; the new code in the free block 7AE0-7FEF (the reference has zeros from 7AD9h; 7FF0h holds 'Cardex1')
%define FONT32   0x7C05     ; font (font32.asm)
%define SCR13    0x7C21     ; scr13 (scr13.asm)
%define P13A     0x7CC7     ; wfillt/wfill (p13fill.asm)
%define DFDN     0x7CEA     ; dfdn (p13df.asm)
%define BFILL    0x7CF2     ; bfill0/bfill (p13bfill.asm)
%define CLEAR32  0x7D0B     ; clear (clear32.asm)
