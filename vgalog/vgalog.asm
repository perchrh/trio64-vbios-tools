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
;   VGALOG /U        unload: puts INT 10h back, closes VGALOG.BIN and frees the memory
;   VGALOG /H, /?, /HELP  parameter list
;   A second install is refused while VGALOG is resident. Unloading only works while VGALOG is the last
;   program that hooked INT 10h; otherwise it says so and stays resident. A new install overwrites
;   VGALOG.BIN, so copy it away between runs. Calls made while DOS is busy are passed on but not logged.
;   Exit code 0 = done, 1 = refused, bad argument or the file could not be created.
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
;   The message "VGALOG <version> installed ..." at install and "VGALOG <version>: unloaded" with /U;
;   the watched program runs as without VGALOG.
;
; How a resident copy is found
;   The INT 10h vector must point to offset isr in a segment that holds the signature at offset sig.
;   That segment is the resident copy's PSP; /U uses its saved vector and file handle.
;   VGALOG.BIN size = 32 bytes per logged call.
bits 16
org 0x100
%include "version.inc"
start:  jmp init
old10   dd 0
sig     db 'VGALOG01'           ; identifies a resident copy (see the header)
SIGLEN  equ 8
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

; ---------------- command line ----------------
init:   mov si,0x81
.p:     lodsb
        cmp al,13
        je install
        cmp al,' '
        je .p
        cmp al,9
        je .p
        cmp al,'/'
        je .sw
        cmp al,'-'
        jne bad
.sw:    lodsb
        or al,0x20
        mov ah,al
.sk:    mov al,[si]             ; skip the rest of the switch word (/help)
        cmp al,' '
        je .sd
        cmp al,13
        je .sd
        cmp al,'/'
        je .sd
        inc si
        jmp .sk
.sd:    cmp ah,'u'
        je unload
        cmp ah,'h'
        je help
        cmp ah,'?'
        je help
bad:    mov dx,s_bad
        mov ah,9
        int 0x21
        mov dx,s_use
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21
help:   mov dx,s_use
        mov ah,9
        int 0x21
        mov ax,0x4C00
        int 0x21

; ---------------- resident copy? -> ZF=1 and ES = its segment ----------------
findres:
        mov ax,0x3510
        int 0x21
        cmp bx,isr
        jne .r
        mov si,sig
        mov di,sig
        mov cx,SIGLEN
        repe cmpsb              ; DS:SI = our signature, ES:DI = the same offset in the hook's segment
.r:     ret

; ---------------- install ----------------
install:
        call findres
        jne .go
        mov dx,s_twice
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21
.go:    push cs
        pop es
        mov [mypsp],cs
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
        mov es,[0x2C]                   ; free the environment copy, the resident part does not need it
        mov ah,0x49
        int 0x21
        mov word [0x2C],0
        mov dx,msg
        mov ah,9
        int 0x21
        mov dx,resend+15                ; keep PSP + handler, in paragraphs
        shr dx,4
        mov ax,0x3100
        int 0x21
.err:   mov dx,msge
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21

; ---------------- unload ----------------
unload: call findres
        je .go
        mov dx,s_notres                 ; not installed, or not the last INT 10h hook
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21
.go:    push ds                         ; ES = resident copy: put its saved vector back
        lds dx,[es:old10]
        mov ax,0x2510
        int 0x21
        pop ds
        mov ah,0x51                     ; close its file as the resident program (the handle is its own)
        int 0x21
        push bx
        mov bx,es
        mov ah,0x50
        int 0x21
        mov bx,[es:handle]
        mov ah,0x3E
        int 0x21
        pop bx
        mov ah,0x50
        int 0x21
        mov bx,[es:0x2C]                ; environment (0 when freed at install)
        or bx,bx
        jz .fp
        push es
        mov es,bx
        mov ah,0x49
        int 0x21
        pop es
.fp:    mov ah,0x49                     ; the resident PSP and handler
        int 0x21
        jc .fe
        mov dx,s_unl
        mov ah,9
        int 0x21
        mov ax,0x4C00
        int 0x21
.fe:    mov dx,s_free
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21

fname   db 'VGALOG.BIN',0
msg     db 'VGALOG ',VERSION,' installed, logging INT 10h AH=00 and 4F01/4F02/4F06 to VGALOG.BIN',13,10,'$'
msge    db 'VGALOG ',VERSION,': cannot create VGALOG.BIN',13,10,'$'
s_use   db 'VGALOG ',VERSION,' - logs INT 10h AH=00 and VBE 4F01/4F02/4F06 calls to VGALOG.BIN',13,10
        db '  VGALOG              install (VGALOG.BIN is created new in the current directory)',13,10
        db '  VGALOG /U           unload (INT 10h restored, VGALOG.BIN closed)',13,10
        db '  VGALOG /H, /?, /HELP  this help',13,10,'$'
s_bad   db 'VGALOG ',VERSION,': bad argument.',13,10,13,10,'$'
s_twice db 'VGALOG ',VERSION,': already installed.',13,10,'$'
s_unl   db 'VGALOG ',VERSION,': unloaded, VGALOG.BIN closed.',13,10,'$'
s_notres db 'VGALOG ',VERSION,': not unloaded: VGALOG is not installed, or another program hooked INT 10h',13,10
        db 'after it (unload that one first).',13,10,'$'
s_free  db 'VGALOG ',VERSION,': INT 10h restored, but its memory could not be freed.',13,10,'$'
