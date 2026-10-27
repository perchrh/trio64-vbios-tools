; p13: byte fill with the end pointer of rep stosb, for the planar scroll window loop. Assembled at P13C,
; the dead bytes of the old font load loop after the p12 jump (1227h in 2.04.11, 14 bytes).
bits 16
cpu 386
%include "bios.inc"
org P13C

; ---- bfilla: bfill, then DI moved by CX in the direction of DF, as rep stosb leaves it; keeps CX ----
bfilla: call L_bfill
        call DFDN
        jnz .d
        add di,cx
        ret
.d:     sub di,cx
        ret
