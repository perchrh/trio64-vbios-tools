; p13: word move for the text scroll window (AH=06h/07h, one line per call). Assembled at P13B, the
; dead bytes of the old 16-bit mode set clear loop (1442h, 21 bytes).
bits 16
cpu 386
%include "bios.inc"
org P13B

; ---- wmove: CX words from DS:SI to ES:DI with 32-bit moves, in the direction of DF (DF set: SI and DI
;      are the last word); CX, SI, DI are changed (the caller saves them), EAX is not used ----
wmove:  shr cx,1
        jnc .e
        movsw                   ; odd word first
.e:     call DFDN
        jz .s
        dec si                  ; downwards: the dword holds the last two words
        dec si
        dec di
        dec di
.s:     rep movsd
        ret
