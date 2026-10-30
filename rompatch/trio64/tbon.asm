; Trio64 patch p1: the booster and its Windows check (Phoenix 1.5-07). Follows rompatch/vplus/vhooks.asm,
; with three differences the Phoenix BIOS asks for:
; - Phoenix locks the S3 registers again after its calls (CR38/CR39 = 00h) and its own unlock routine
;   changes AX, so bon unlocks itself and puts CR38/CR39 back as it found them;
; - the refusal mark is CR52 bit 3: CR6D is not a Trio64 register in the data book, and Phoenix uses
;   CR6C (bit 7 into CR5A at every mode set, and the state save reads it as a mode number); CR52 is a
;   BIOS flag register of which Phoenix uses bits 7-4 only (refresh indexes, written at POST);
; - no base restore: Phoenix writes CR59 from CR6B and CR5A from CR6C bit 7 at every mode set.
bits 16
%include "bios.inc"
org TBON

; ---------------- booster on (end of a banked 4F02, the window set with BH = 0) ----------------
; In: nothing. Turns the booster on (linear addressing with a 64 KB window at A0000h) if the mode is a
; banked packed mode (CR31 bits 0 and 3) with a known linear base (CR59), linear addressing is off and
; Windows does not run in enhanced mode (wcheck); does nothing otherwise. Keeps every register and the
; S3 register lock as found.
bon:
        push    ax
        push    bx
        push    dx
        call    GETCRTC
        call    unlk                    ; BX = CR38/CR39 as found
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
        call    L_wcheck                ; Windows enhanced mode: no booster
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
.done:  call    relk
        pop     dx
        pop     bx
        pop     ax
        ret

; ---------------- unlock / lock as found ----------------
; unlk: In: DX = CRTC. Out: BL = CR38, BH = CR39 as found, both unlocked. Keeps the others but AX.
; relk: In: DX = CRTC, BX from unlk. Puts CR38/CR39 back. Keeps the others but AX.
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
relk:   mov     al, 0x39
        mov     ah, bh
        out     dx, ax
        mov     al, 0x38
        mov     ah, bl
        out     dx, ax
        ret
