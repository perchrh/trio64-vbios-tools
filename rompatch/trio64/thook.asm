; Trio64 patch p1: the mode set hook (Phoenix 1.5-07; INT 10h AH=00 table entry and, through h4f02,
; 4F02's call). Clears the Windows refusal mark (CR52 bit 3) so wcheck asks again for the new mode, sets
; the mode, then resets the attribute controller flip-flop. The S3 register lock is put back as found.
bits 16
%include "bios.inc"
org THOOK

; In: AL = mode, DS = 0000h (the dispatcher's). Out: what MODESET returns. Keeps what MODESET keeps.
hook:
        push    ax
        push    bx
        push    dx
        call    GETCRTC
        call    L_unlk
        mov     al, 0x52                ; forget the refusal: a new mode
        call    RDREG
        and     ah, 0xF7
        out     dx, ax
        call    L_relk
        pop     dx
        pop     bx
        pop     ax
        call    MODESET
        pushf
        push    ax
        push    dx
        call    GETCRTC
        add     dl, 6                   ; reset the ATC flip-flop (3BAh/3DAh)
        in      al, dx
        pop     dx
        pop     ax
        popf
        ret
