; Trio64V+ patch p2 code block at C000:7D2E (free in the S3 Trio64V+ BIOS 1.03-08)
; - fit: VBE 4F02 refuses a mode whose picture does not fit into the video memory, the modes 4F01 marks
;   unsupported (1.03-08 set them anyway: 118h, 119h, 11Ah with 2 MB; with 1 MB also 107h, 112h,
;   115h-117h, 120h). The rule is 4F01's own (C000:4898), so the two always agree.
; - vbe32: the VBE dispatcher keeps the upper halves of the 32-bit registers. Its INT 10h entry saves
;   the 16-bit registers only, and 4F06 (among others) computes in EAX, ECX and EDX, so the caller got
;   them back changed; the 2.04.07 dispatcher keeps them. The handlers return their results in the
;   INT 10h stack frame (BP), so restoring all eight 32-bit registers changes no result.
; - msx: the mode set, then in 320x200 at 15, 16 and 32 bpp (S3 modes 65h-67h, VESA 10Dh-10Fh) the dot
;   clock halved (SR01 bit 3). 1.03-08 ran these modes at a 12.6 MHz DCLK with the PLL VCO at 101 MHz,
;   below the 135 MHz minimum (PLL-1); the Trio64V+ post divider stops at 8, so 12.6 MHz cannot come
;   from a VCO in range. Their refresh entries now give 25.06 MHz (VCO 200.5 MHz, the PLL pair of
;   640x480), and SR01 bit 3 divides it by 2 for the CRTC, so the timing stays as it was (31.3 kHz,
;   69.8 Hz instead of 70.3 Hz). Whether the RAMDAC path of these modes follows SR01 bit 3 is to be
;   seen on a card; the emulator and S3COMPAT model the CRTC side only.
bits 16
cpu 386
%include "bios.inc"
org 0x7D2E

; ---- the mode set (called from the hook in place of MODESET; first in this block: its address is VFIX) ----
; In and out: as MODESET. Keeps every register, the flags and the sequencer index.
msx:    call    MODESET
        pushf
        push    ax
        push    dx
        push    ds
        xor     ax,ax
        mov     ds,ax
        mov     al,[0x449]
        cmp     al,0x65                 ; 320x200x15
        jb      .r
        cmp     al,0x67                 ; 320x200x32
        ja      .r
        mov     dx,0x3C4
        in      al,dx
        push    ax                      ; the sequencer index, put back below
        mov     ax,0x0100               ; synchronous reset while the dot clock changes
        out     dx,ax
        mov     al,0x01
        out     dx,al
        inc     dx
        in      al,dx
        or      al,0x08                 ; SR01 bit 3: dot clock = DCLK / 2
        out     dx,al
        dec     dx
        mov     ax,0x0300               ; reset off
        out     dx,ax
        pop     ax
        out     dx,al
.r:     pop     ds
        pop     dx
        pop     ax
        popf
        ret

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
