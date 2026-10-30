; p13: word fill for the text scroll (AH=06h/07h) and AH=09h in text modes. Assembled at P13A, the dead
; bytes of the old 4F06 BL=3 routine (59C0h, 41 bytes); the Trio64V+ build (rompatch/vplus) assembles it
; in its free block.
bits 16
cpu 386
%include "bios.inc"
org P13A

; ---- wfillt: the text scroll's blank: AL = 20h, AH = the fill attribute [bp+3] of the scroll call ----
wfillt: mov al,0x20
        mov ah,[bp+0x3]
; ---- wfill: CX words of AX at ES:DI with 32-bit stores, in the direction of DF (DF set: DI is the
;      last word, as for rep stosw); keeps every register including EAX bits 31-16 (AH=0Eh scrolls
;      through here without the dispatcher that saves the 32-bit registers) ----
wfill:  push cx
        push di
        push eax
        push ax
        shl eax,16
        pop ax                  ; EAX = AX:AX
        shr cx,1
        jnc .e
        stosw                   ; odd word first, so the dwords stay in step with DF
.e:     call DFDN
        jz .s
        dec di                  ; downwards: the dword holds the last two words
        dec di
.s:     rep stosd
        pop eax
        pop di
        pop cx
        ret
