; ROMVER.COM - print the video ROM version S3TEST reads (DOS, 386+)
;
; Purpose
;   Prints the sign-on version in the ROM mapped at C000. The scan is romfind in
;   src/tools/common/romver.inc, the same routine S3TEST's signature line uses: "Version "
;   inside C000:0000-00FF, then at most 12 characters, stopping before a byte below 20h.
;   Changes nothing.
;
; Usage
;   ROMVER           tool version, then the ROM version, on stdout
;   ROMVER /Q, -q    the ROM version only
;   ROMVER /H, /?    this help
;   Exit code 0 when a version string was found, 1 when not.
;
bits 16
org 0x100
cpu 386
%include "version.inc"

start:  cld
        mov si,0x81
.op:    lodsb
        cmp al,13
        je .run
        cmp al,' '
        je .op
        cmp al,9
        je .op
        cmp al,'/'
        je .sw
        cmp al,'-'
        jne .op
.sw:    lodsb
        or al,0x20
        cmp al,'h'
        je help
        cmp al,'?'
        je help
        cmp al,'q'
        jne .op
        mov byte [quiet],1
        jmp .op

.run:   cmp byte [quiet],1
        je .q
        mov dx,s_title
        mov ah,9
        int 0x21
.q:     call romfind
        jc .no
        mov si,romvbuf
        mov cx,[romvlen]
        jcxz .nl
.p:     lodsb
        mov dl,al
        mov ah,2
        int 0x21
        loop .p
.nl:    mov dx,s_nl
        mov ah,9
        int 0x21
        call doneio
        mov ax,0x4C00
        int 0x21
.no:    mov dx,s_none
        mov ah,9
        int 0x21
        call doneio
        mov ax,0x4C01
        int 0x21

help:   mov dx,s_use
        mov ah,9
        int 0x21
        call doneio
        mov ax,0x4C00
        int 0x21

; Commit stdout and reset the disk, so a redirected ROMVER listing survives SMARTDRV.
doneio: push ax
        push bx
        mov bx,1
        mov ah,0x68
        int 0x21
        mov ah,0x0D
        int 0x21
        pop bx
        pop ax
        ret

quiet   db 0
s_title db 'ROMVER ',VERSION,13,10,'$'
s_nl    db 13,10,'$'
s_none  db 'ROMVER ',VERSION,': no version string in C000:0000-00FF',13,10,'$'
s_use   db 'ROMVER ',VERSION,' - print the video ROM version S3TEST reads',13,10
        db '  ROMVER       tool version, then the ROM version',13,10
        db '  ROMVER /Q    the ROM version only; -q is the same',13,10
        db '  ROMVER /H    this help',13,10
        db 'Exit 0 when "Version " is in C000:0000-00FF, 1 when not.',13,10
        db 'The scan is src/tools/common/romver.inc (S3TEST t_rom): up to 12 characters,',13,10
        db 'stopping before a byte below 20h.',13,10,'$'

%include "romver.inc"
