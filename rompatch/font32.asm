; 32-bit font load into plane 2 (p12 of 2.04.07): replaces the 8-bit loop of the S3 font load at the
; 'font' site (s3patch.SIG). Shared by the Trio64V+ build (rompatch/vplus) and the Trio64 build
; (rompatch/trio64), assembled at FONT32 of their bios.inc; 2.04.07 has its copy in p12ext.asm.
bits 16
cpu 386
%include "bios.inc"
org FONT32

; ---- font load into plane 2 : CX characters of BH bytes from DS:SI to ES:DI,
;      DX bytes skipped after each (32 - BH) ----
font:   push ax
.l:     push cx
        mov cl,bh
        xor ch,ch
        push cx
        shr cx,2
        rep movsd
        pop cx
        and cx,3
        rep movsb
        pop cx
        add di,dx
        loop .l
        or al,0xFF
        pop ax
        ret
