; S3ALIAS.COM 0.8 - mode number alias TSR for Pinball Illusions' S3 driver on the Trio64V2/DX VBIOS 2.x
;
; Purpose
;   Pinball Illusions has its own S3 driver that sets 640x480x256 with INT 10h AH=00 mode 49h and
;   800x600x256 with mode 4Bh, the numbers of an older S3 BIOS. In BIOS 2.04.x these numbers are other
;   modes (49h = 640x480 15-bit colour, 4Bh = 1024x768 15-bit colour), so the game gets a wrong picture.
;   The 8-bit modes are 59h (VESA 101h) and 5Ah (VESA 103h) here. The fix is a TSR and not in the ROM
;   because changing the ROM's own mode numbers would break programs that use this BIOS's numbering.
;
; Usage
;   S3ALIAS              install (before starting the game); stays resident, about 300 bytes
;   S3ALIAS /U           unload it again
;   S3ALIAS /H, /?, /HELP  parameter list
;   A second install is refused while S3ALIAS is resident. Unloading only works while S3ALIAS is the
;   last program that hooked INT 10h; otherwise it says so and stays resident (unload the later TSR
;   first, or reboot). Exit code 0 = done, 1 = refused or bad argument.
;
; What it does and the expected outcome
;   INT 10h AH=00 with AL = 49h becomes AL = 59h, AL = 4Bh becomes AL = 5Ah. Bit 7 of AL (do not
;   clear video memory) is kept. Every other call goes to the BIOS unchanged.
;   Expect: "S3ALIAS 0.8: installed ..." at install and "S3ALIAS 0.8: unloaded" with /U; Pinball
;   Illusions shows its tables in 640x480 and 800x600 with correct colours. Run S3TEST and S3COMPAT
;   without S3ALIAS: S3COMPAT sets every S3 mode through AH=00, and its lines for 49h (VESA 110h) and
;   4Bh (VESA 116h) would fail.
;
; How a resident copy is found
;   The INT 10h vector must point to offset isr in a segment that holds the signature at offset sig.
;   That segment is the resident copy's PSP; /U puts its saved INT 10h vector back and frees it.
bits 16
org 0x100
start:  jmp init
old10   dd 0
sig     db 'S3ALIAS1'           ; identifies a resident copy (see the header)
SIGLEN  equ 8
; resident INT 10h handler
isr:    or ah,ah
        jnz .chain
        push ax
        and al,0x7F
        cmp al,0x49
        je .m49
        cmp al,0x4B
        je .m4b
        pop ax
.chain: jmp far [cs:old10]
.m49:   pop ax
        add al,0x10             ; 49h -> 59h (bit 7 unchanged)
        jmp far [cs:old10]
.m4b:   pop ax
        add al,0x0F             ; 4Bh -> 5Ah (bit 7 unchanged)
        jmp far [cs:old10]
resend:                         ; everything from here is freed after installation

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
.go:    mov ax,0x3510           ; hook INT 10h
        int 0x21
        mov [old10],bx
        mov [old10+2],es
        mov dx,isr
        mov ax,0x2510
        int 0x21
        mov es,[0x2C]           ; free the environment copy, the resident part does not need it
        mov ah,0x49
        int 0x21
        mov word [0x2C],0
        mov dx,s_inst
        mov ah,9
        int 0x21
        mov dx,resend+15        ; keep PSP + handler, in paragraphs
        shr dx,4
        mov ax,0x3100
        int 0x21

; ---------------- unload ----------------
unload: call findres
        je .go
        mov dx,s_notres         ; not installed, or not the last INT 10h hook
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21
.go:    push ds                 ; ES = resident copy: put its saved vector back
        lds dx,[es:old10]
        mov ax,0x2510
        int 0x21
        pop ds
        mov bx,[es:0x2C]        ; environment (0 when freed at install)
        or bx,bx
        jz .fp
        push es
        mov es,bx
        mov ah,0x49
        int 0x21
        pop es
.fp:    mov ah,0x49             ; the resident PSP and handler
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

s_use   db 'S3ALIAS 0.8 - INT 10h AH=00 mode alias for Pinball Illusions on the Trio64V2 BIOS 2.x',13,10
        db '  S3ALIAS             install: mode 49h -> 59h (640x480x8), 4Bh -> 5Ah (800x600x8)',13,10
        db '  S3ALIAS /U          unload',13,10
        db '  S3ALIAS /H, /?, /HELP  this help',13,10,'$'
s_bad   db 'S3ALIAS 0.8: bad argument.',13,10,13,10,'$'
s_inst  db 'S3ALIAS 0.8: installed, mode 49h->59h (640x480x8), 4Bh->5Ah (800x600x8)',13,10,'$'
s_twice db 'S3ALIAS 0.8: already installed.',13,10,'$'
s_unl   db 'S3ALIAS 0.8: unloaded.',13,10,'$'
s_notres db 'S3ALIAS 0.8: not unloaded: S3ALIAS is not installed, or another program hooked INT 10h',13,10
        db 'after it (unload that one first).',13,10,'$'
s_free  db 'S3ALIAS 0.8: INT 10h restored, but its memory could not be freed.',13,10,'$'
