; Trio64 patch p1: the entry from Phoenix 1.5-07's 4F02 into the hook and the booster (the window set
; entry is twset.asm).
bits 16
%include "bios.inc"
org TGLUE

; ---- VBE 4F02 (the call at 4C18 replaces 'call MODESET', DS = 0000h): the mode set through the hook,
;      then the booster as in 2.04.07-p18: on after a banked mode set unless Windows runs ----
h4f02:  call    L_hook
        jmp     L_bon
