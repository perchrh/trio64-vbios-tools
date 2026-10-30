; bios.inc - addresses in the lower 32 KB of the S3 reference BIOS 2.04.07 that the patch code uses
;             (C000:offset)
;
; s3patch.py reads these lines too (the name, then the value), for its own checks of the BIOS code at
; these addresses, so this file is the one place they are written down.
%define MODESET  0x267B     ; mode set (AL = mode), the INT 10h AH=00 handler
%define UNLOCK   0x125C     ; CR38 = 48h, CR39 = A5h (keeps AX, DX)
%define GETCRTC  0x126C     ; DX = 3B4h/3D4h (keeps AX)
%define RDREG    0x216E     ; AL = index at port DX -> AH = value, AL = index
%define MEMSIZE  0x1B0F     ; DX = video memory in 64 KB units
%define SEG_SCR  0x1D44     ; word 0000h: DS for the BIOS data area (scroll code)
%define SEG_BDA  0x1D46     ; word 0000h: DS for the BIOS data area (VBE code)
%define SEG_VID  0x1D48     ; word A000h: video segment
%define INT_AH0E 0x2156     ; INT 10h entry: jump to the AH=0Eh handler
%define INT_NEXT 0x2114     ; INT 10h entry after 'cmp ah,0Eh / jz': AH=0Ch/0Dh tests, then the dispatcher
%define SCR_FULL 0x31FB     ; mode 13h scroll, original full-width path
%define SCR_WIN  0x3222     ; mode 13h scroll, original window path
%define CLR_RET  0x1457     ; end of the S3/VESA mode set clear: pop ds / pop es / popa / ret
%define P13A     0x59C0     ; p13 code: the old 4F06 BL=3 routine after the p8 call (dead, 41 bytes)
%define P13B     0x1442     ; p13 code: the old 16-bit clear loop after the p11 jump (dead, 21 bytes)
%define P13C     0x1227     ; p13 code: the old 8-bit font load loop after the p12 jump (dead, 14 bytes)
%define DFDN     0x7FAF     ; p13: dfdn (p13df.asm), in free space
%define WSET     0x584B     ; VBE window set (BX = window, DX = bank): 4F05 BH=0 and the window function
%define SR0DRST  0x1C70     ; SR0D = AH (restores what 1C5F saved; the end of VBE 4F15)
%define DDCWAIT  0x5F4E     ; DDC delay (AX = count in PIT clocks of 0.84 us; keeps every register)
