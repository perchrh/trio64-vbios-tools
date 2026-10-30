; Trio64V+ patch p1 code: fast VBE 4F05 set window and the window set booster entry. Follows
; rompatch/p12ext.asm (2.04.07), whose font load and mode 13h scroll this build takes from the shared
; rompatch/font32.asm and rompatch/scr13.asm. The 4F05 fast path differs: 1.03-08 neither keeps the
; bank at 0040:04FE nor refuses 4F05 with linear addressing on, so neither does the fast path.
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
