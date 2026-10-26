; VGALOG.COM - TSR that logs video BIOS mode sets and VBE calls of any program to VGALOG.BIN
;
; Purpose
;   Shows what a game or driver asks the video BIOS for, also when the program hangs: every logged call
;   is written and committed to disk before the BIOS runs it and again after it returns. It was used to
;   find the mode numbers of Pinball Illusions' S3 driver (49h, 4Bh) and to follow Flight Simulator 5.0
;   in VESA 640x400. Logged: INT 10h AH=00 (VGA and S3 mode set) and VBE 4F01, 4F02 and 4F06, so it
;   covers more than VESA.
;
; Usage
;   VGALOG           install, then start the program to watch; VGALOG.BIN grows in the current directory
;   It cannot be removed again; reboot to get rid of it. Remove VGALOG.BIN between runs or it is
;   overwritten at the next install. Calls made while DOS is busy are passed on but not logged.
;
; Record format, 16 bytes per record, two records per call
;   +0  'B' before the call, 'A' after it        +1  0
;   +2  AX in    +4  BX in    +6  CX in    +8  DX in   (the same in both records)
;   +10 AX returned ('A' only, 0 in 'B')
;   +12 CR67, CR13, CR51, CR31 after the call ('A' only): colour mode, pitch, pitch/start overflow,
;       memory configuration. Read without unlocking the S3 registers, as the BIOS left them.
;   A 'B' record without its 'A' record is the call that hung.
;
; Expected outcome
;   The message "VGALOG <version> installed ..." at install; the watched program runs as without VGALOG.
;   VGALOG.BIN size = 32 bytes per logged call.
bits 16
org 0x100
%include "version.inc"
start:  jmp init
old10   dd 0
indos   dd 0
mypsp   dw 0
handle  dw 0
oldpsp  dw 0
rec     times 16 db 0

; resident INT 10h handler
isr:    or ah,ah
        jz .log
        cmp ax,0x4F01
        je .log
        cmp ax,0x4F02
        je .log
        cmp ax,0x4F06
        je .log
        jmp far [cs:old10]
.log:   push ds
        push cs
        pop ds
        mov byte [rec],'B'
        mov byte [rec+1],0
        mov [rec+2],ax
        mov [rec+4],bx
        mov [rec+6],cx
        mov [rec+8],dx
        mov word [rec+10],0
        mov dword [rec+12],0
        call flush
        pop ds
        pushf
        call far [cs:old10]
        pushf                           ; result flags
        push ds
        push cs
        pop ds
        mov byte [rec],'A'
        mov [rec+10],ax
        push ax
        push dx
        mov dx,0x3D4
        in al,dx                        ; keep the CRTC index
        push ax
        mov al,0x67
        call rd
        mov [rec+12],ah
        mov al,0x13
        call rd
        mov [rec+13],ah
        mov al,0x51
        call rd
        mov [rec+14],ah
        mov al,0x31
        call rd
        mov [rec+15],ah
        pop ax
        out dx,al
        pop dx
        pop ax
        call flush
        pop ds
        ; return the BIOS result flags with the caller's interrupt flag
        ; stack: result flags, IP, CS, caller flags
        push bp
        mov bp,sp
        push ax
        mov ax,[bp+2]
        and ax,0xFDFF
        test word [bp+8],0x0200
        jz .ni
        or ax,0x0200
.ni:    mov [bp+8],ax
        pop ax
        pop bp
        add sp,2
        iret

rd:     out dx,al                       ; CRTC register AL -> AH
        inc dx
        in al,dx
        dec dx
        mov ah,al
        ret

flush:  ; write rec (16 bytes) and commit, only if DOS is not busy. DS=CS
        push es
        push bx
        les bx,[indos]
        cmp byte [es:bx],0
        pop bx
        pop es
        jne .skip
        push ax
        push bx
        push cx
        push dx
        mov ah,0x51                     ; our PSP while writing (the handle is ours)
        int 0x21
        mov [oldpsp],bx
        mov bx,[mypsp]
        mov ah,0x50
        int 0x21
        mov ah,0x40
        mov bx,[handle]
        mov cx,16
        mov dx,rec
        int 0x21
        mov ah,0x68                     ; commit file
        mov bx,[handle]
        int 0x21
        mov bx,[oldpsp]
        mov ah,0x50
        int 0x21
        pop dx
        pop cx
        pop bx
        pop ax
.skip:  ret
resend:                                 ; everything from here is freed after installation

init:   mov [mypsp],cs
        mov ah,0x3C
        xor cx,cx
        mov dx,fname
        int 0x21
        jc .err
        mov [handle],ax
        mov ah,0x34                     ; InDOS flag
        int 0x21
        mov [indos],bx
        mov [indos+2],es
        mov ax,0x3510
        int 0x21
        mov [old10],bx
        mov [old10+2],es
        mov dx,isr
        mov ax,0x2510
        int 0x21
        mov dx,msg
        mov ah,9
        int 0x21
        mov dx,resend+15
        shr dx,4
        mov ax,0x3100
        int 0x21
.err:   mov dx,msge
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21
fname   db 'VGALOG.BIN',0
msg     db 'VGALOG ',VERSION,' installed, logging INT 10h AH=00 and 4F01/4F02/4F06 to VGALOG.BIN',13,10,'$'
msge    db 'VGALOG ',VERSION,': cannot create VGALOG.BIN',13,10,'$'
