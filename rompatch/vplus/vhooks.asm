; Trio64V+ patch p1 code block at C000:7AE0 (free in the S3 Trio64V+ BIOS 1.03-08)
; - mode set hook: forget the Windows refusal, put the real linear base back if the booster left the
;   64 KB window at A0000h there, mode set, attribute controller flip-flop reset
; - booster (bon): banked VESA packed modes use the linear path through a 64 KB window at A0000h,
;   switched on at the end of a banked 4F02 and at the first bank switch (as 2.04.07-p18), not under
;   Windows enhanced mode (wcheck, as p17)
; The 2.04.07 code this follows is rompatch/hooks.asm and rompatch/wincheck.asm. Differences: no FIFO
; fix (CR90 is a Trio64V2 register), and the real base comes from CR6B, where 1.03-08 keeps the PCI base
; (bits 31-24) from POST and writes it back to CR59 (CR5A = 00h) at every mode set (1015h); so CR6D
; only holds wcheck's refusal mark here. 1.03-08 has no linear frame buffer modes (VBE 1.2), so the
; LFB base read and linear test fixes of 2.04.07 have nothing to fix.
bits 16
%include "bios.inc"
org 0x7AE0

; ---------------- mode set hook (INT 10h AH=00 table) ----------------
; In: AL = mode, DS = 0000h (the dispatcher's). Out: what MODESET returns. Keeps what MODESET keeps.
hook:
        push    ax
        push    dx
        call    UNLOCK
        call    GETCRTC
        call    wclear                  ; a new mode: wcheck asks Windows again
        call    restore_base
        pop     dx
        pop     ax
        call    VFIX                    ; MODESET, then the dot clock of 10Dh-10Fh (vfix.asm, p2)
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

; ---------------- VBE 4F02 (the call at 48FF replaces 'call MODESET', DS = 0000h) ----------------
; The mode set through the hook, then the booster as in 2.04.07-p18: on after a banked mode set unless
; Windows runs in enhanced mode, so a banked 4F02 of the Windows driver leaves CR58-CR5A as 1.03-08 does.
h4f02:
        call    hook
        jmp     bon

; put the real linear base (CR6B) back into CR59/CR5A if the booster left 000Ah there (1.03-08 does it
; at the mode set too; this covers its mode set paths that end early). In: DX = CRTC, unlocked.
; Keeps every register except AX.
restore_base:
        mov     al, 0x5A
        call    RDREG
        cmp     ah, 0x0A
        jne     .r
        mov     al, 0x59
        call    RDREG
        or      ah, ah
        jnz     .r
        mov     al, 0x6B
        call    RDREG
        or      ah, ah
        jz      .r
        mov     al, 0x59
        out     dx, ax
        mov     ax, 0x005A
        out     dx, ax
.r:     ret

; ---------------- booster on (end of a banked 4F02, the 4F05 set window paths) ----------------
; In: nothing. Turns the booster on if the mode is a banked packed mode with a known linear base, linear
; addressing is off and Windows does not run in enhanced mode (wcheck); does nothing otherwise (also
; when it is already on). Keeps every register.
bon:
        push    ax
        push    dx
        call    UNLOCK
        call    GETCRTC
        mov     al, 0x58
        call    RDREG
        test    ah, 0x10                ; linear addressing on (the booster, or a program's window)
        jnz     .done
        mov     al, 0x31
        call    RDREG
        and     ah, 0x09                ; banking + enhanced memory mapping (packed modes)
        cmp     ah, 0x09
        jne     .done
        mov     al, 0x59
        call    RDREG
        or      ah, ah                  ; unknown linear base: no booster
        jz      .done
        call    wcheck                  ; Windows enhanced mode: no booster
        jc      .done
        mov     al, 0x58
        call    RDREG
        and     ah, 0xEC                ; LA off, 64 KB window
        out     dx, ax
        mov     ax, 0x0059              ; window base = 000A0000h
        out     dx, ax
        mov     ax, 0x0A5A
        out     dx, ax
        mov     al, 0x58
        call    RDREG
        or      ah, 0x10                ; LA on
        out     dx, ax
.done:  pop     dx
        pop     ax
        ret

; ---------------- booster allowed? ----------------
; In: DX = CRTC, S3 registers unlocked. Out: CF=0 the booster may go on, CF=1 not: Windows runs in
; enhanced mode (INT 2Fh AX=1600h returns AL other than 00h/80h), remembered as CR6D = 01h until the
; next mode set, so INT 2Fh is asked once per mode set. Keeps every register.
wcheck:
        push    ax
        mov     al, 0x6D
        call    RDREG
        cmp     ah, 0x01                ; refused before in this mode
        je      .no
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
        mov     ax, 0x016D              ; CR6D = 01h: refused for this mode
        out     dx, ax
.no:    pop     ax
        stc
        ret
.ok:    pop     ax
        clc
        ret

; ---------------- forget the refusal (before every mode set) ----------------
; In: DX = CRTC, S3 registers unlocked. CR6D = 01h (wcheck's mark) becomes 00h. Keeps every register.
wclear:
        push    ax
        mov     al, 0x6D
        call    RDREG
        cmp     ah, 0x01
        jne     .r
        xor     ah, ah
        out     dx, ax
.r:     pop     ax
        ret
