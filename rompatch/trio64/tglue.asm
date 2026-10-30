; Trio64 patch p1: the entries from Phoenix 1.5-07's code into the hook and the booster.
bits 16
%include "bios.inc"
org TGLUE

; ---- VBE 4F02 (the call at 4C18 replaces 'call MODESET', DS = 0000h): the mode set through the hook,
;      then the booster as in 2.04.07-p18: on after a banked mode set unless Windows runs ----
h4f02:  call    L_hook
        jmp     L_bon

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
