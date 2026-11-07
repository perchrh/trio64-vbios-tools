; Trio64 patch p1: the window set entry into the booster (Phoenix 1.5-07).
bits 16
%include "bios.inc"
org TWSET

; ---- window set (4F05 and the window function call WSET for any BH; the jump at WSET replaces its
;      'push dx / push bx / mov ax,014Fh'): with BH = 0 the booster first, then the replaced
;      instructions ----
wsetp:  or      bh, bh
        jnz     .x
        call    L_bon
.x:     push    dx
        push    bx
        mov     ax, 0x014F
        jmp     WSET+5
