; Trio64V+ patch p1 code: fast VBE 4F05 set window, the window set booster entry, the 32-bit font load
; and the 32-bit mode 13h scroll. Follows rompatch/p12ext.asm (2.04.07); the font and scroll code is the
; same, the 4F05 fast path differs: 1.03-08 neither keeps the bank at 0040:04FE nor refuses 4F05 with
; linear addressing on, so neither does the fast path.
bits 16
cpu 386
%include "bios.inc"
org 0x7BA8

; ---- INT 10h entry (jumped to after STI/CLD): fast VBE 4F05 BH=0 (set window) ----
; The same result as 1.03-08's 4F05 BH=0 (AX = 004Fh, CR6A = bank, x4 in planar modes, every other
; register kept, the SR index put back) without the dispatcher, the S3 unlock of the sequencer (SR08)
; and its restore. CR38/CR39 are left unlocked as 1.03-08 leaves them.
int10x: cmp ax,0x4F05
        je .v5
        cmp ah,0x0E             ; the instruction the jump replaced
        jne .c
        jmp INT_AH0E
.c:     jmp INT_NEXT
.v5:    or bh,bh                ; get (BH=1) and bad BH: the normal path
        jnz .c
        push dx
        push bx
        mov bx,dx               ; BX = bank (64 KB units)
        mov dx,0x3D4
        mov ax,0x4838           ; unlock CR40-FF (the BIOS leaves them unlocked, a program may not)
        out dx,ax
        mov ax,0xA539
        out dx,ax
        mov al,0x58             ; linear addressing off: the first bank switch of a banked mode turns
        out dx,al               ; the booster on
        inc dx
        in al,dx
        dec dx
        test al,0x10
        jnz .nl
        call L_bon
.nl:    mov dl,0xC4             ; SR04 bit 3 = 0: planar (4 bpp), bank x 4
        in al,dx
        mov ah,al               ; AH = SR index, put back below
        mov al,0x04
        out dx,al
        inc dx
        in al,dx
        dec dx
        xchg al,ah
        out dx,al
        test ah,0x08
        jnz .c4
        shl bx,2
.c4:    mov dl,0xD4             ; CR6A = bank
        mov al,0x6A
        mov ah,bl
        out dx,ax
        pop bx
        pop dx
        mov ax,0x004F
        iret

; ---- window set (the window function, C000:4996 calls 49C1, jumps here): turn the booster on, then
;      the replaced instructions ----
wsetx:  call L_bon
        push dx
        push bx
        mov bx,dx
        jmp WSET+4

; ---- font load into plane 2 : CX characters of BH bytes from DS:SI to ES:DI,
;      DX bytes skipped after each (32 - BH) ----
font:   push ax
.l:     push cx
        mov cl,bh
        xor ch,ch
        push cx
        shr cx,2
        rep movsd
        pop cx
        and cx,3
        rep movsb
        pop cx
        add di,dx
        loop .l
        or al,0xFF
        pop ax
        ret

; ---- mode 13h scroll : 32-bit moves and fills for AH=06h; AH=07h (DF set) ----
;      runs the original word code. Keeps EAX: the 1.03-08 dispatcher saves the 16-bit registers
;      only, and AH=0Eh scrolls without it (p12ext.asm of 2.04.07 does not keep EAX bits 31-16 there,
;      README "To do")
scr13:  cmp byte [bp+0x1],0x07
        je .orig
        push eax
        cmp cx,[0x44A]
        jne .win
        mov bx,ax               ; full width: one block move and one fill
        mov al,cl
        mul dh
        mul word [0x485]
        mov cx,ax
        shl cx,1                ; dwords (the original: shl cx,2 words)
        mov ax,0xA000
        mov es,ax
        mov ds,ax
        rep movsd
        mov cx,bx
        shr cx,1                ; words to fill
        mov al,[bp+0x3]
        mov ah,al
        mov dx,ax
        shl eax,16
        mov ax,dx
        shr cx,1
        rep stosd
        adc cx,cx
        rep stosw
        pop eax
        add sp,4
        ret
.win:   shl bx,3                ; window: line by line
        shl cx,1                ; dwords per line
        mov al,[0x485]
        mul dh
        push dx
        mov dx,ax
        mov ax,0xA000
        mov ds,ax
        mov es,ax
        or dx,dx
        jz .f
.ml:    mov ax,cx
        rep movsd
        mov cx,ax
        add si,bx
        add di,bx
        dec dx
        jnz .ml
.f:     pop dx
        mov ds,[cs:SEG_SCR]
        mov al,[0x485]
        mul dl
        mov dx,ax
        mov al,[bp+0x3]
        mov ah,al
        mov si,ax
        shl eax,16
        mov ax,si
        mov si,cx
.fl:    mov cx,si
        rep stosd
        add di,bx
        dec dx
        jnz .fl
        pop eax
        add sp,4
        ret
.orig:  cmp cx,[0x44A]
        jne .ow
        jmp SCR_FULL
.ow:    jmp SCR_WIN
