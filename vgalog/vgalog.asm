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
;   VGALOG /M        install in memory mode: every INT 10h call except the text and pixel functions is
;                    kept in a 32 KB ring buffer in memory (the last 1024 calls), nothing is written to
;                    disk. For Windows 9x: load it before Windows (AUTOEXEC.BAT), use Windows, then
;                    VGALOG /D in a DOS box or after leaving Windows.
;   VGALOG /D        memory mode: write the ring buffer to VGALOG.BIN (oldest call first); the buffer
;                    is kept, so /D can be repeated. With no call logged yet it writes no file and says
;                    "No events registered, not writing output file" (exit code 0). Run in a DOS box
;                    while Windows runs, the calls logged during the write may be mixed into it
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
; Memory mode (/M, dumped with /D): a 16-byte file header, then 32 bytes per call, oldest first
;   header  'VGALOGM1', dd calls logged in total, dw records in the file, dw 0
;   +0  dw call number (low 16 bits of the total)
;   +2  AX, +4 BX, +6 CX, +8 DX, +10 ES, +12 DI as the caller gave them
;   +14 AX, +16 BX, +18 CX, +20 DX returned
;   +22 low byte of the returned flags (bit 0 = CF)    +23 nesting depth (0 = called by a program,
;       1 or more = the BIOS or another handler called INT 10h from inside a call)
;   +24 BIOS tick (0040:006C) low word at the call
;   +26 SR10, +27 SR11 (memory clock PLL), +28 CR58, +29 CR59, +30 CR5A, +31 CR6D after the call
;       (read with the S3 registers unlocked; SR08, CR38, CR39 and the indexes are put back)
;   Not logged in memory mode (they would fill the buffer): AH=02h, 03h, 08h, 09h, 0Ah, 0Ch, 0Dh, 0Eh,
;   13h. Under Windows the calls of DOS boxes may see virtual register values (the display driver
;   traps their VGA ports); the calls the driver makes itself run with the real ones.
;
; Expected outcome
;   The message "VGALOG <version> installed ..." at install and "VGALOG <version>: unloaded" with /U;
;   the watched program runs as without VGALOG.
;
; How a resident copy is found
;   The INT 10h vector points to offset isr in a segment that holds the signature at offset sig: that
;   segment is the resident copy's PSP (findres). /U needs this (it can only unhook as the last INT 10h
;   hook) and uses the copy's saved vector and file handle. /D and the install check also search the
;   DOS memory control block chain (findmem), with the upper memory blocks linked in for the walk: in
;   a Windows 9x DOS box Windows hooks INT 10h after a VGALOG loaded before it, which still logs.
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
mmode   db 0                    ; 1 = memory mode (/M)
depth   db 0                    ; INT 10h nesting in memory mode
rtotal  dd 0                    ; calls logged in memory mode
rnext   dw 0                    ; next ring slot (0..RBN-1)
RBN     equ 1024                ; ring slots of 32 bytes, at ring (after the resident code)

; resident INT 10h handler
isr:    cmp byte [cs:mmode],0
        jne misr
        or ah,ah
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

; ---- memory mode: every call except text/pixel output into the ring buffer ----
misr:   cmp ah,0x02
        je .pass
        cmp ah,0x03
        je .pass
        cmp ah,0x08
        jb .go
        cmp ah,0x0A
        jbe .pass
        cmp ah,0x0C
        jb .go
        cmp ah,0x0E
        jbe .pass
        cmp ah,0x13
        jne .go
.pass:  jmp far [cs:old10]
.go:    push bp                         ; caller's BP, DS, SI (BP and DS go to the BIOS unchanged)
        push ds
        push si
        push cs
        pop ds
        mov si,[rnext]                  ; take the next slot: SI = its offset
        inc word [rnext]
        and word [rnext],RBN-1
        shl si,5
        add si,ring
        push ax
        mov ax,[rtotal]
        mov [si],ax
        add word [rtotal],1
        adc word [rtotal+2],0
        pop ax
        mov [si+2],ax
        mov [si+4],bx
        mov [si+6],cx
        mov [si+8],dx
        mov [si+10],es
        mov [si+12],di
        push ax
        mov al,[depth]
        mov [si+23],al
        push es
        xor ax,ax
        mov es,ax
        mov ax,[es:0x46C]
        pop es
        mov [si+24],ax
        pop ax
        inc byte [depth]
        mov bp,sp                       ; [bp] caller SI, [bp+2] caller DS, [bp+4] caller BP
        xchg si,[bp]                    ; keep the slot there, SI = caller's SI
        mov ds,[bp+2]
        mov bp,[bp+4]
        pushf
        call far [cs:old10]
        ; stack: slot, DS, BP (caller's), IP, CS, caller flags
        pushf                           ; result flags
        push bp
        mov bp,sp                       ; [bp] BIOS BP, +2 result flags, +4 slot, +6 DS, +8 BP, +10 IP,
        push ds                         ; +12 CS, +14 caller flags
        push si
        push cs
        pop ds
        mov si,[bp+4]
        mov [si+14],ax
        mov [si+16],bx
        mov [si+18],cx
        mov [si+20],dx
        push ax
        mov ax,[bp+2]
        mov [si+22],al
        call s3regs                     ; SR10 SR11 CR58 CR59 CR5A CR6D -> [si+26..31]
        dec byte [depth]
        mov ax,[bp+2]                   ; the BIOS result flags with the caller's interrupt flag
        and ax,0xFDFF
        test word [bp+14],0x0200
        jz .ni
        or ax,0x0200
.ni:    mov [bp+14],ax
        pop ax
        pop si
        pop ds
        pop bp                          ; BP as the BIOS returned it (AX=1130h returns ES:BP)
        add sp,8                        ; result flags, slot, DS, BP
        iret

; SR10, SR11, CR58, CR59, CR5A, CR6D into [SI+26..31] (DS = CS). Unlocks the S3 registers and puts
; SR08, CR38, CR39 and the 3C4h/3D4h indexes back. Keeps all registers.
s3regs: push ax
        push bx
        push cx
        push dx
        mov dx,0x3C4
        in al,dx
        mov bl,al                       ; BL = SR index
        mov al,0x08
        out dx,al
        inc dx
        in al,dx
        mov bh,al                       ; BH = SR08
        mov al,0x06
        out dx,al
        dec dx
        mov al,0x10
        out dx,al
        inc dx
        in al,dx
        mov [si+26],al
        dec dx
        mov al,0x11
        out dx,al
        inc dx
        in al,dx
        mov [si+27],al
        dec dx
        mov al,0x08
        mov ah,bh
        out dx,ax
        mov al,bl
        out dx,al
        mov dx,0x3D4
        in al,dx
        mov bl,al                       ; BL = CR index
        mov al,0x38
        call rd
        mov bh,ah                       ; BH = CR38
        mov al,0x39
        call rd
        mov cl,ah                       ; CL = CR39
        mov ax,0x4838
        out dx,ax
        mov ax,0xA539
        out dx,ax
        mov al,0x58
        call rd
        mov [si+28],ah
        mov al,0x59
        call rd
        mov [si+29],ah
        mov al,0x5A
        call rd
        mov [si+30],ah
        mov al,0x6D
        call rd
        mov [si+31],ah
        mov al,0x39
        mov ah,cl
        out dx,ax
        mov al,0x38
        mov ah,bh
        out dx,ax
        mov al,bl
        out dx,al
        pop dx
        pop cx
        pop bx
        pop ax
        ret

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
resend:                                 ; everything from here is freed after installation (file mode)
ring:                                   ; memory mode: RBN x 32 bytes of ring buffer from here

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
        cmp ah,'m'
        je minst
        cmp ah,'d'
        je dump
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

; ---------------- resident copy anywhere in DOS memory? -> ZF=1 and ES = its segment ----------------
; In: nothing. The INT 10h vector first (findres); then the MCB chain from the first MCB (INT 21h
; AH=52h, the word before the list of lists) with the UMBs linked in (AX=5803h, put back after): a
; program block (owner = the paragraph after its MCB) other than this copy, with the signature at
; offset sig. Stops at a block that is neither 'M' nor 'Z'. Changes AX, BX, CX, DX, SI, DI.
findmem:
        call findres
        je .r
        mov ax,0x5802                   ; UMB link state as found (AL)
        int 0x21
        push ax
        mov ax,0x5803
        mov bx,1                        ; link the UMBs into the chain for the walk
        int 0x21
        mov ah,0x52
        int 0x21
        mov ax,[es:bx-2]                ; first MCB
        xor dl,dl                       ; DL = 1 when found
.l:     mov es,ax
        mov bx,ax
        inc bx                          ; the block's first paragraph
        cmp [es:1],bx                   ; owned by itself: a program's PSP block
        jne .n
        mov cx,cs
        cmp bx,cx                       ; not this copy
        je .n
        mov es,bx
        mov si,sig
        mov di,si
        mov cx,SIGLEN
        repe cmpsb
        je .f
        mov es,ax
.n:     cmp byte [es:0],'M'
        jne .e                          ; 'Z' ends the chain, anything else is no MCB
        add ax,[es:3]
        inc ax
        jmp .l
.f:     inc dl                          ; ES = the resident copy
.e:     pop bx
        xor bh,bh                       ; the link state as found
        and bl,1
        mov ax,0x5803
        int 0x21
        cmp dl,1                        ; ZF = found
.r:     ret

; ---------------- install ----------------
install:
        call findmem
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

; ---------------- install in memory mode ----------------
minst:  call findmem
        jne .go
        mov dx,s_twice
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21
.go:    mov byte [mmode],1
        mov [mypsp],cs
        mov ax,0x3510
        int 0x21
        mov [old10],bx
        mov [old10+2],es
        mov dx,isr
        mov ax,0x2510
        int 0x21
        mov es,[0x2C]
        mov ah,0x49
        int 0x21
        mov word [0x2C],0
        mov dx,msgm
        mov ah,9
        int 0x21
        mov dx,ring+RBN*32+15           ; PSP + handler + ring buffer, in paragraphs
        shr dx,4
        mov ax,0x3100
        int 0x21

; ---------------- dump the ring buffer of a resident memory-mode copy ----------------
dump:   call findmem
        jne .nm
        cmp byte [es:mmode],1
        je .go
.nm:    mov dx,s_notm
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21
.go:    mov eax,[es:rtotal]             ; header
        mov [dhdr+8],eax
        mov cx,RBN
        cmp eax,RBN
        jae .f
        mov cx,ax
.f:     test cx,cx                      ; no calls since /M: nothing to write, say so
        jz .none
        mov [dhdr+12],cx
        mov [dcnt],cx
        mov ax,[es:rnext]               ; oldest slot = rnext - count
        sub ax,cx
        and ax,RBN-1
        mov [dfirst],ax
        push es
        mov ah,0x3C
        xor cx,cx
        mov dx,fname
        int 0x21
        pop es
        jc .err
        mov bx,ax
        mov ah,0x40
        mov cx,16
        mov dx,dhdr
        int 0x21
        jc .err
        ; part 1: dfirst .. end (or count), part 2: 0 ..
        mov ax,RBN
        sub ax,[dfirst]
        cmp ax,[dcnt]
        jbe .p1
        mov ax,[dcnt]
.p1:    mov cx,ax
        sub [dcnt],ax
        shl cx,5
        mov dx,[dfirst]
        shl dx,5
        add dx,ring
        push ds
        push es
        pop ds
        mov ah,0x40
        int 0x21
        pop ds
        jc .err
        mov cx,[dcnt]
        jcxz .cl
        shl cx,5
        mov dx,ring
        push ds
        push es
        pop ds
        mov ah,0x40
        int 0x21
        pop ds
        jc .err
.cl:    mov ah,0x3E
        int 0x21
        mov dx,s_dump
        mov ah,9
        int 0x21
        mov ax,0x4C00
        int 0x21
.none:  mov dx,s_none                   ; VGALOG.BIN is left as it is (not created, not emptied)
        mov ah,9
        int 0x21
        mov ax,0x4C00
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
        cmp byte [es:mmode],0           ; memory mode: no file
        jne .nf
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
.nf:    mov bx,[es:0x2C]                ; environment (0 when freed at install)
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
        cmp byte [es:mmode],0
        je .um
        mov dx,s_unlm
.um:    mov ah,9
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
msgm    db 'VGALOG ',VERSION,' installed in memory mode: the last 1024 INT 10h calls (no text/pixel output), VGALOG /D writes them',13,10,'$'
s_dump  db 'VGALOG ',VERSION,': ring buffer written to VGALOG.BIN',13,10,'$'
s_none  db 'VGALOG ',VERSION,': No events registered, not writing output file',13,10,'$'
s_notm  db 'VGALOG ',VERSION,': /D needs VGALOG resident in memory mode (VGALOG /M).',13,10,'$'
dhdr    db 'VGALOGM1',0,0,0,0,0,0,0,0
dcnt    dw 0
dfirst  dw 0
s_use   db 'VGALOG ',VERSION,' - logs INT 10h AH=00 and VBE 4F01/4F02/4F06 calls to VGALOG.BIN',13,10
        db '  VGALOG              install (VGALOG.BIN is created new in the current directory)',13,10
        db '  VGALOG /M           install in memory mode: last 1024 INT 10h calls in RAM (for Windows 9x)',13,10
        db '  VGALOG /D           memory mode: write the calls to VGALOG.BIN',13,10
        db '  VGALOG /U           unload (INT 10h restored, VGALOG.BIN closed)',13,10
        db '  VGALOG /H, /?, /HELP  this help',13,10,'$'
s_bad   db 'VGALOG ',VERSION,': bad argument.',13,10,13,10,'$'
s_twice db 'VGALOG ',VERSION,': already installed.',13,10,'$'
s_unl   db 'VGALOG ',VERSION,': unloaded, VGALOG.BIN closed.',13,10,'$'
s_unlm  db 'VGALOG ',VERSION,': unloaded (memory mode; the calls not written with /D are gone).',13,10,'$'
s_notres db 'VGALOG ',VERSION,': not unloaded: VGALOG is not installed, or another program hooked INT 10h',13,10
        db 'after it (unload that one first).',13,10,'$'
s_free  db 'VGALOG ',VERSION,': INT 10h restored, but its memory could not be freed.',13,10,'$'
