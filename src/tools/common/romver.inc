; romver.inc - the one video ROM version scan.
;
; "Version " in C000:0000-00FF, then at most 12 characters, stopping before a byte below 20h.
; Every caller uses romfind: ROMVER.COM prints the text, S3TEST's signature line prints it and
; compares it with VER775 / VER765 / VER764, S3COMPAT's "ROM:" line prints it, and the /V debug
; log (vdebug.inc) records it as D:ENV ROM=.
;
; romfind  out: CF set when "Version " is not in that window.
;          CF clear: [romvbuf] holds the characters (romvlen of them), romvnext is the byte
;          that ended the run (or the byte after 12 characters).
;          Keeps DS, ES, SI, DI, BX, CX. Clobbers AX.
romfind:
        push ds
        push es
        push si
        push di
        push bx
        push cx
        push cs
        pop es
        mov di,romvbuf
        mov cx,12
        xor ax,ax
        rep stosb
        mov word [cs:romvlen],0
        mov byte [cs:romvnext],0
        mov ax,0xC000
        mov ds,ax
        xor si,si
        mov cx,0x100
.f:     cmp dword [si],'Vers'
        jne .n
        cmp dword [si+4],'ion '
        je .hit
.n:     inc si
        loop .f
        stc
        jmp .out
.hit:   add si,8
        xor bx,bx
        mov cx,12
.p:     mov al,[si]
        cmp al,' '
        jb .stop
        mov [cs:romvbuf+bx],al
        inc si
        inc bx
        loop .p
.stop:  mov [cs:romvlen],bx
        mov al,[si]
        mov [cs:romvnext],al
        clc
.out:   lahf
        pop cx
        pop bx
        pop di
        pop si
        pop es
        pop ds
        sahf
        ret

romvlen  dw 0
romvnext db 0
romvbuf  db 12 dup(0)
