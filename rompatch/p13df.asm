; p13: the direction test the p13 fill and move helpers share. Assembled in free space at DFDN (7FAFh).
bits 16
cpu 386
%include "bios.inc"
org DFDN

; ---- dfdn: ZF = 0 when DF is set (string ops run downwards); keeps every register ----
dfdn:   push ax
        pushf
        pop ax
        test ah,0x04            ; DF = flags bit 10
        pop ax
        ret

