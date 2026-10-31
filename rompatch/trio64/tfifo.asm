; Trio64 patch p2: the display FIFO M parameter computed at each mode set (#75).
;
; Phoenix's mode set writes CR54 (M: bits 7-3, the memory cycles the CPU and the graphics engine may
; take before the display FIFO is filled again) from its mode table. Its values were chosen for its
; interlaced defaults and a 70 MHz MCLK; with the 60 Hz defaults (#68) and the 54.9 MHz of the
; reference build they let the FIFO run dry under load (streaks in windowed video on the DSP-3364P,
; #75). This code runs in the mode set where Phoenix writes CR67 (the colour mode): the DCLK (SR12,
; SR13), CR3A and CR54 are set by then, the S3 registers are unlocked and the screen is still off
; (SR01 bit 5), as the data book wants while M changes. In the packed modes (CR3A bit 4) it lowers M to
; what the memory bandwidth allows, never raises it:
;
;   t   = 112 x MCLK / (DCLK x bytes per pixel)    MCLKs in which the display drains 112 of the
;                                                  FIFO's 128 bytes (16 entries of 8 bytes)
;   M+1 = (t - 18) / 5                             two entry cycles of up to 9 MCLKs, then 5 MCLKs per
;                                                  access (the data book: 2 per page cycle, 6-9 per
;                                                  entry cycle; the DSP-3364P streaked at M = 19 with
;                                                  54.9 MHz and not at 69.8 MHz, which puts the mean
;                                                  cost at 3.5 to 4.7 MCLKs)
;
; DCLK = 14.31818 MHz x (M+2) / ((N+2) x 2^R) from SR13 (M) and SR12 (N bits 4-0, R bits 6-5). Bytes per
; pixel = (CR67 bits 7-5 + 3) / 2: 1 (0xh, 1xh: 8 bpp), 2 (3xh 15 bpp, 5xh 16 bpp), 3 (7xh), 4 (Dxh 32 bpp).
; 112 x MCLK in kHz is the immediate of the imul at kmclk, which s3tpatch.py writes from the build's MCLK
; PLL pair at 3B5h. The code is in two parts: this one (in the 97 bytes of the deleted VDIF code) and
; tfifo2.asm (in the padding after the first sign-on block), which it jumps to.
bits 16
cpu 386
%include "bios.inc"
org TFIFO

; In: AL = 67h, DX = CRTC port, ES:DI = Phoenix's mode table entry (CR67 at +0Bh), the S3 registers
; unlocked. Out: CR67 written from the table, AX = 67h with AH = that value (the caller tests it).
; Keeps every register but AH.
fifo:
        mov     ah, [es:di + 0x0B]
        out     dx, ax                  ; CR67, as the call site did
        pushad
        mov     di, dx
        mov     bl, ah
        mov     al, 0x3A
        call    RDREG
        test    ah, 0x10                ; a packed (enhanced) mode?
        jz      .out
        shr     bl, 5                   ; bytes per pixel = (CR67 bits 7-5 + 3) / 2
        add     bl, 3
        shr     bl, 1
        movzx   ebp, bl
        mov     dl, 0xC4                ; DCLK PLL: SR12 = N/R, SR13 = M
        mov     al, 0x12
        out     dx, al
        inc     dx
        in      al, dx
        xchg    cx, ax                  ; CL = N/R
        dec     dx
        mov     al, 0x13
        out     dx, al
        inc     dx
        in      al, dx
        and     ax, 0x7F
        inc     ax
        inc     ax
        movzx   eax, ax
        imul    eax, ebp
        imul    esi, eax, 14318         ; ESI = (M+2) x bytes per pixel x 14318
        movzx   eax, cl
        and     al, 0x1F
        inc     ax
        inc     ax                      ; N+2
kmclk   equ     $ + 3
        imul    eax, eax, 0x5DCC30      ; x 112 x MCLK kHz (s3tpatch.py writes the build's)
        shr     cl, 5
        and     cl, 3
        shl     eax, cl                 ; x 2^R: at most 33 x 112 x 100 MHz x 8 < 2^32
        jmp     TFIFO2
.out:   popad
        ret
