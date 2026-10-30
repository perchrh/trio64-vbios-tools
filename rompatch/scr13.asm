; 32-bit mode 13h scroll (p12, EAX kept since p21 of 2.04.07): jumped to from the 'scr' site
; (s3patch.SIG). Shared by the Trio64V+ build (rompatch/vplus) and the Trio64 build (rompatch/trio64),
; assembled at SCR13 of their bios.inc, with SEG_SCR, SCR_FULL and SCR_WIN from there; 2.04.07 has its
; copy in p12ext.asm.
bits 16
cpu 386
%include "bios.inc"
org SCR13

; ---- mode 13h scroll : 32-bit moves and fills for AH=06h; AH=07h (DF set) ----
;      runs the original word code. Keeps EAX: the dispatchers of 1.03-08 and Phoenix 1.5-07 save the
;      16-bit registers only, and AH=0Eh scrolls without any dispatcher
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
