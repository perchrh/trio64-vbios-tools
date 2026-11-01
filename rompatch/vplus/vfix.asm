; Trio64V+ patch p2 code block at C000:7D2E (free in the S3 Trio64V+ BIOS 1.03-08)
; - fit: VBE 4F02 refuses a mode whose picture does not fit into the video memory, the modes 4F01 marks
;   unsupported (1.03-08 set them anyway: 118h, 119h, 11Ah with 2 MB; with 1 MB also 107h, 112h,
;   115h-117h, 120h). The rule is 4F01's own (C000:4898), so the two always agree.
; - vbe32: the VBE dispatcher keeps the upper halves of the 32-bit registers. Its INT 10h entry saves
;   the 16-bit registers only, and 4F06 (among others) computes in EAX, ECX and EDX, so the caller got
;   them back changed; the 2.04.07 dispatcher keeps them. The handlers return their results in the
;   INT 10h stack frame (BP), so restoring all eight 32-bit registers changes no result.
bits 16
cpu 386
%include "bios.inc"
org 0x7D2E

; ---- 4F02, after the mode number lookup (jumped to from 4924h, the code it replaces first) ----
; In: DS = CS, DI = 3 x the index of the mode in the VESA list, CX = the caller's BX, BP = the INT 10h
; frame. Out: as 1.03-08 when the mode fits (BX = the S3 mode number, on to the mode set at 48EDh);
; otherwise AX = 014Fh through the frame, as for an unknown mode (4904h), and nothing is changed.
fit:    mov si,MODELIST         ; the replaced instructions: SI = the mode's 3-byte entry
        add si,di
        push si
        push cx
        mov si,[si+1]           ; the mode's information record, as 4F01 reads it
        mov cx,[si+1]           ; BytesPerScanLine
        cmp byte [si+0x0B],3    ; memory model 3 (16 colours): four planes
        jne .p
        shl cx,2
.p:     mov ax,[si+5]           ; YResolution
        mul cx                  ; DX = the 64 KB units the picture needs, rounded down (as 4F01)
        mov cl,dl
        call MEMSIZE            ; DL = the video memory in 64 KB units (DH = 0; keeps AX)
        cmp cl,dl               ; 4F01: supported only below the memory size
        pop cx
        pop si
        jae .no
        mov bl,[si]             ; the replaced instructions: BX = the S3 mode number
        xor bh,bh
        jmp M4F02_SET
.no:    mov byte [bp+0x11],1    ; AH = 01h: failed (as 4904h)
        ret

; ---- VBE dispatcher (the call at 47CDh): the function, with the 32-bit registers kept ----
; In: SI = 2 x the function index (the dispatcher's). Out: what the function returns (in the frame).
vbe32:  pushad
        call word [cs:si+VBE_TAB]
        popad
        ret
