; Trio64 patch p2: the second part of tfifo.asm (the display FIFO M parameter, #75), in the zero padding
; after the first sign-on block (00AEh-00E3h; the sign-on ends at 00ABh, two bytes are left for a longer
; level suffix). In: EAX = (N+2) x 2^R x 112 x MCLK kHz, ESI = (M+2) x bytes per pixel x 14318,
; DI = CRTC port, the registers of the mode set on the stack (pushad by tfifo.asm).
; Out: CR54 lowered when the computed M is lower than Phoenix's; the registers popped, back to the mode
; set.
bits 16
cpu 386
%include "bios.inc"
org TFIFO2

fifo2:
        xor     edx, edx                ; EAX can reach 2^31: no cdq
        div     esi                     ; t = 112 x MCLK / (DCLK x bytes per pixel), in MCLKs
        cmp     eax, 31 * 5 + 18 + 5
        jae     .out                    ; M of 31 or more (or a stray DCLK): nothing to lower
        sub     ax, 18 + 5              ; M = (t - 18) / 5 - 1
        jae     .pos
        xor     ax, ax
.pos:   mov     bl, 5
        div     bl                      ; AL = M, at most 30
        shl     al, 3
        xchg    cx, ax                  ; CL = M in bits 7-3
        mov     dx, di
        mov     al, 0x54
        call    RDREG
        cmp     ah, cl
        jbe     .out                    ; Phoenix's M is not higher
        and     ah, 0x07
        or      ah, cl
        out     dx, ax
.out:   popad
        ret
