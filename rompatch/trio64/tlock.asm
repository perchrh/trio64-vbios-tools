; Trio64 patch p1: the Windows check of the booster (Phoenix 1.5-07), with its refusal mark in CR52 bit 3
; (tbon.asm says why there), and the unlock that keeps the lock state (unlk; relk is in tbon.asm).
bits 16
%include "bios.inc"
org TLOCK

; ---------------- booster allowed? ----------------
; In: DX = CRTC, S3 registers unlocked. Out: CF=0 the booster may go on, CF=1 not: Windows runs in
; enhanced mode (INT 2Fh AX=1600h returns AL other than 00h/80h), remembered in CR52 bit 3 until the next
; mode set, so INT 2Fh is asked once per mode set. Keeps every register.
wcheck:
        push    ax
        mov     al, 0x52
        call    RDREG
        test    ah, 0x08                ; refused before in this mode
        jnz     .no
        push    bx
        push    cx
        push    dx
        mov     ax, 0x1600              ; Windows enhanced mode installation check
        int     0x2F
        pop     dx
        pop     cx
        pop     bx
        test    al, 0x7F                ; 00h or 80h: not running
        jz      .ok
        mov     al, 0x52
        call    RDREG
        or      ah, 0x08                ; CR52 bit 3: refused for this mode
        out     dx, ax
.no:    pop     ax
        stc
        ret
.ok:    pop     ax
        clc
        ret

; ---------------- unlock as found ----------------
; unlk: In: DX = CRTC. Out: BL = CR38, BH = CR39 as found, both unlocked. Keeps the others but AX.
; relk (tbon.asm) puts them back.
unlk:   mov     al, 0x38
        call    RDREG
        mov     bl, ah
        mov     al, 0x39
        call    RDREG
        mov     bh, ah
        mov     ax, 0x4838
        out     dx, ax
        mov     ax, 0xA539
        out     dx, ax
        ret
