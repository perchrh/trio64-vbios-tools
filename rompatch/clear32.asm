; p11: video memory clear of the S3/VESA mode set with 32-bit stores (jumped to from C000:143D).
; The original loop (143D-1453) wrote 32768 words per 64 KB bank with rep stosw; this one writes 16384
; dwords per bank. DX = CRTC port, AX = 006Ah (CR6A index, bank 0), CX = number of banks; EAX is kept for
; the caller (the routine saves only the 16-bit registers with PUSHA). Ends at 1457 (pop ds/es, popa, ret).
; Assembled at CLEAR32 (bios.inc); the Trio64V+ build (rompatch/vplus) uses this file too.
bits 16
cpu 386
%include "bios.inc"
org CLEAR32
clear:  push eax
.l:     mov es,[cs:SEG_VID]      ; A000h
        db 0x33,0xFF            ; xor di,di (the encoding p11 was built with)
        push ax
        push cx
        mov cx,0x4000
        db 0x66,0x33,0xC0       ; xor eax,eax
        rep stosd
        pop cx
        pop ax
        inc ah                  ; next bank
        out dx,ax
        loop .l
        mov ah,0                ; bank 0
        out dx,ax
        pop eax
        jmp CLR_RET
