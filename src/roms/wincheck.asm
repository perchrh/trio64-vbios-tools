; S3 Trio64V2/DX VBIOS patch p17 code block at C000:7C8B (free in the reference;
; 7C8A is not: it is the high byte of the word count at 7C89 that the descender glyph load at 3FC7 reads): no booster under
; Windows enhanced mode, and the linear mode test moved here from hooks.asm
; - wcheck: called by bon before it turns the booster on
; - wclear: called by the mode set hook (restore_base) before every mode set
; - lfbchk: the 4F05/4F03 linear test (p7, unchanged)
; Why: with the booster on in a full-screen DOS box, Windows 98's S3 driver restores the box after
; Alt+Tab with MISC = 63h (the fixed 25 MHz clock, 400-line sync) and the monitor cannot show it
; (VSHOW 101h/103h every time on the card; without the booster as rarely as with the stock BIOS).
; README "Windows 9x driver test".
bits 16
org 0x7C8B
%include "bios.inc"

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

; ---------------- linear mode test (called instead of 'and ax,1000h' in 4F05/4F03) ----------------
; In: AH = CR58. ZF=1 if not a linear frame buffer mode (LA off, or booster's 64 KB window)
lfbchk:
        test    ah, 0x10
        jz      .r
        test    ah, 0x03
.r:     ret
