; p13: byte fill for the planar scroll (modes 0Dh-12h, AH=06h/07h): the BIOS writes with set/reset
; (write mode 0, GR01 = 0Fh), so the data byte does not matter and 32-bit stores fill four bytes per bus
; write. Assembled in free space at BFILL (bios.inc; 7F58h, 25 bytes); the Trio64V+ build (rompatch/vplus)
; uses this file too.
bits 16
cpu 386
%include "bios.inc"
org BFILL

; ---- bfill0: AX = 0, then bfill (the planar scroll leaves AX = 0 for its GR00/GR01 writes after) ----
bfill0: xor ax,ax
; ---- bfill: CX bytes of AL at ES:DI in the direction of DF (DF set: DI is the last byte); keeps every
;      register ----
bfill:  push cx
        push di
        push ax
        mov ah,al
        shr cx,1
        jnc .w
        stosb                   ; odd byte first
.w:     call DFDN
        jz .f
        dec di                  ; downwards: DI = the last word (the byte below DI and DI itself)
.f:     call L_wfill
        pop ax
        pop di
        pop cx
        ret
