; p8: correct VBE 4F06 BL=3 (get maximum scan line length). SI = BIOS mode info ([si+5] YRes, [si+9] bpp)
bits 16
cpu 386
org 0x7F71
%include "bios.inc"
bl3:    call MEMSIZE            ; DX = video memory in 64 KB units
        xor ax,ax
        mov bl,[si+9]
        cmp bl,4
        jne .np
        shr dx,2                ; planar: memory per plane
.np:    div word [si+5]         ; AX = bytes per line that fit with YRes lines
        cmp ax,8184             ; CRTC offset limit: 1023 x 8 bytes
        jbe .a
        mov ax,8184
.a:     and al,0xF8
        mov [bp+0x16],ax        ; BX = maximum bytes per scan line
        shl ax,3                ; bits per line
        cmp bl,4
        je .p
        cmp bl,15
        jne .b
        mov bl,16
.b:     xor bh,bh
        xor dx,dx
        div bx
.p:     mov [bp+0x12],ax        ; CX = maximum pixels per scan line
        mov word [bp+0x0E],0
        ret
