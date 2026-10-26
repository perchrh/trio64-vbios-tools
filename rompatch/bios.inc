; bios.inc - addresses in the lower 32 KB that the patch code uses (C000:offset)
;
; The defaults are those of BIOS 2.04.11 (the stock Gainward/Cardex image). s3p12.py assembles every
; file with -D for the BIOS it patches (2.04.07: see PROFILES in s3p12.py), so the same source serves
; both versions.
%ifndef MODESET
%define MODESET  0x2686     ; mode set (AL = mode), the INT 10h AH=00 handler
%endif
%ifndef UNLOCK
%define UNLOCK   0x125C     ; CR38 = 48h, CR39 = A5h (keeps AX, DX)
%endif
%ifndef GETCRTC
%define GETCRTC  0x126C     ; DX = 3B4h/3D4h (keeps AX)
%endif
%ifndef RDREG
%define RDREG    0x2179     ; AL = index at port DX -> AH = value, AL = index
%endif
%ifndef MEMSIZE
%define MEMSIZE  0x1B1A     ; DX = video memory in 64 KB units
%endif
%ifndef SEG_SCR
%define SEG_SCR  0x1D4F     ; word 0000h: DS for the BIOS data area (scroll code)
%endif
%ifndef SEG_BDA
%define SEG_BDA  0x1D51     ; word 0000h: DS for the BIOS data area (VBE code)
%endif
%ifndef SEG_VID
%define SEG_VID  0x1D53     ; word A000h: video segment
%endif
%ifndef INT_AH0E
%define INT_AH0E 0x2161     ; INT 10h entry: jump to the AH=0Eh handler
%endif
%ifndef INT_NEXT
%define INT_NEXT 0x211F     ; INT 10h entry after 'cmp ah,0Eh / jz': AH=0Ch/0Dh tests, then the dispatcher
%endif
%ifndef SCR_FULL
%define SCR_FULL 0x3206     ; mode 13h scroll, original full-width path
%endif
%ifndef SCR_WIN
%define SCR_WIN  0x322D     ; mode 13h scroll, original window path
%endif
%ifndef CLR_RET
%define CLR_RET  0x1457     ; end of the S3/VESA mode set clear: pop ds / pop es / popa / ret
%endif
