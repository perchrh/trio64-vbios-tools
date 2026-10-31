; The window path of the mode 13h scroll (scr13.asm): line by line. Included in scr13.asm, or, where
; bios.inc defines SCR13W (the Trio64 build, short of one free block for all of it), assembled on its
; own at SCR13W by scr13w.asm, which scr13 jumps to. In: as at scr13's .win; EAX pushed. Returns from
; the scroll (pop eax, add sp,4, ret) as the full-width path does.
        shl bx,3                ; window: line by line
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
