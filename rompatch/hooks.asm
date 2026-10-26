; S3 Trio64V2/DX VBIOS patch p7 code block at C000:7E80
; - mode set hook: restore real LFB base if booster was active, mode set, FIFO fix, ATC flip-flop reset
; - booster: banked VESA packed modes use the linear path through a 64 KB window at A0000
; - LFB base read fix and 4F05/4F03 linear-mode test fix
bits 16
org 0x7E80
%include "bios.inc"

; ---------------- mode set hook (INT10 AH=00 table, VBE 4F02 internal call) ----------------
hook:
        push    ax
        push    dx
        call    UNLOCK
        call    GETCRTC
        call    restore_base
        pop     dx
        pop     ax
        call    MODESET
        pushf
        push    ax
        push    dx
        push    ds
        xor     ax, ax
        mov     ds, ax
        call    GETCRTC
        cmp     byte [0x449], 0x13
        ja      .ff
        mov     al, 0x38
        call    RDREG
        push    ax
        mov     al, 0x39
        call    RDREG
        push    ax
        mov     ax, 0x4838
        out     dx, ax
        mov     ax, 0xA539
        out     dx, ax
        mov     al, 0x90                ; FIFO fix: CR90 bit 7 off in VGA modes
        call    RDREG
        and     ah, 0x7F
        out     dx, ax
        pop     ax
        out     dx, ax
        pop     ax
        out     dx, ax
.ff:    add     dl, 6                   ; reset ATC flip-flop
        in      al, dx
        pop     ds
        pop     dx
        pop     ax
        popf
        ret

; restore real LFB base (CR59/CR5A) if the booster left 000A there. In: DX=CRTC, unlocked
restore_base:
        mov     al, 0x5A
        call    RDREG
        cmp     ah, 0x0A
        jne     .r
        mov     al, 0x59
        call    RDREG
        or      ah, ah
        jnz     .r
        mov     al, 0x6D
        call    RDREG
        or      ah, ah
        jz      .r
        mov     al, 0x59
        out     dx, ax
        mov     ax, 0x005A
        out     dx, ax
.r:     ret

; ---------------- end of VBE 4F02 (replaces 'mov word [0x4fe],0') ----------------
boost:
        mov     word [0x4FE], 0         ; original instruction (DS=0)
        push    ax
        push    dx
        call    UNLOCK
        call    GETCRTC
        mov     al, 0x58
        call    RDREG
        test    ah, 0x10                ; linear frame buffer mode set: leave alone
        jnz     .done
        mov     al, 0x31
        call    RDREG
        and     ah, 0x09                ; banking + enhanced memory mapping (packed modes)
        cmp     ah, 0x09
        jne     .done
        mov     al, 0x59
        call    RDREG
        or      ah, ah                  ; unknown LFB base: no booster
        jz      .done
        mov     al, 0x6D                ; save real base (bits 31-24) in BIOS flag CR6D
        out     dx, ax
        mov     al, 0x58
        call    RDREG
        and     ah, 0xEC                ; LA off, 64 KB window
        out     dx, ax
        mov     ax, 0x0059              ; window base = 000A0000
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

; ---------------- LFB base read (called from 0x5CF4 instead of 'mov ax,bx') ----------------
; In: BX = CR59:CR5A, DX = CRTC. Out: AX = real base bits 31-16, flags from 'or ax,ax'
basefix:
        mov     ax, bx
        cmp     ax, 0x000A
        jne     .r
        mov     al, 0x6D
        call    RDREG
        xor     al, al
.r:     or      ax, ax
        ret

; ---------------- linear mode test (called from 0x5D12 instead of 'and ax,1000h') ----------------
; In: AH = CR58. ZF=1 if not a linear frame buffer mode (LA off, or booster's 64 KB window)
lfbchk:
        test    ah, 0x10
        jz      .r
        test    ah, 0x03
.r:     ret
