; CHIPID.COM - name the Trio64-family chip from PCI and CR2D-CR30 / CR6F (DOS, 386+)
;
; Purpose
;   Prints the same identification S3TEST's Chip ID INFO line uses: CR2D CR2E CR2F CR30, the PCI
;   device and revision, the market name and the S3 part number. Classification is src/tools/common/chip.inc
;   (chipfind, chipidregs, chipname, chippart): 8901h (V2; CR6F bit 0 = DX/GX), 8A13h Trio3D/2X
;   (S3 NT 5.30.05 INF), 8904h Trio3D (S3 Win9x 2.61.06 INF; 86C365), 8814h UV+, 8811h (rev bit 6
;   = V+; else CR2E = Trio32/Trio64). Changes nothing.
;
; Usage
;   CHIPID           one line to stdout
;   CHIPID /Q, -q    S3 part only (86C775, ...), no title; empty and exit 1 when none found
;   CHIPID /Z, -z    rename runall.zip to runall-<part>.zip using the part string in chipid.out
;                    (from a prior CHIPID /Q redirect); '/' becomes '-', letters lowercased.
;                    Windows 98 DOS can create a long name and cannot rename an existing file to
;                    one, so this call changes nothing there (INT 21h AX=7156h). RUNALL uses
;                    REPORT, which creates the archive under the long name. No-op when the rename
;                    is refused, the file is empty, or DOS has no long-name rename. Exit 0.
;   CHIPID /H, /?    this help
;   Exit code 0 when a Trio64-family PCI device was found, 1 when not (without /Q, CR2D-CR30 and
;   CR6F are still printed when the ports answer). /Z alone always exits 0.
;
bits 16
org 0x100
cpu 386
%include "version.inc"

start:  cld
        mov si,0x81                     ; /Q /Z /H; '-' same as '/'; several switches allowed
.op:    lodsb
        cmp al,13
        je .opd
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
        jne .z
        mov byte [quiet],1
        jmp .op
.z:     cmp al,'z'
        jne .op
        mov byte [dozip],1
        jmp .op

.opd:   cmp byte [dozip],1              ; /Z alone: rename from chipid.out, no chip probe
        jne .run
        cmp byte [quiet],1
        je .run
        call zipren
        mov ax,0x4C00
        int 0x21

.run:   cmp byte [quiet],1
        je .qid
        mov dx,s_title
        call puts
.qid:   call chipfind                   ; src/tools/common/chip.inc: PCI + chipidregs on a find
        pushf
        cmp byte [quiet],1
        je .qout
        jnc .id
        call chipidregs                 ; no PCI hit: still try CR2D-CR30 and CR6F
.id:    mov dx,s_cr
        call puts
        mov al,[chipcr2d]
        call phex2
        call sp1
        mov al,[chipcr2e]
        call phex2
        call sp1
        mov al,[chipcr2f]
        call phex2
        call sp1
        mov al,[chipcr30]
        call phex2
        mov dx,s_cr6f
        call puts
        mov al,[chipcr6f]
        call phex2
        mov dx,s_pci
        call puts
        popf
        jc .np
        mov ax,[chipdev]
        call phex4
        mov dx,s_rev
        call puts
        mov al,[chiprev]
        call phex2
        call sp1
        call chipname
        call puts
        call sp1
        call chippart
        call puts
        mov dx,s_nl
        call puts
        mov ax,0x4C00
        int 0x21
.np:    mov dx,s_na
        call puts
        mov ax,0x4C01
        int 0x21

; /Q: part string alone (with CR/LF); no title, no CR/PCI line. Exit 1 and no text when none found.
; With /Z too: after a successful part print, rename runall.zip from that same part (no chipid.out).
.qout:  popf
        jc .qfail
        call chippart
        push dx                         ; '$' part for /Z after the CR/LF print
        call puts
        mov dx,s_nl
        call puts
        pop dx
        cmp byte [dozip],1
        jne .qok
        call ziprenp                    ; rename runall.zip from the same part string
.qok:   mov ax,0x4C00
        int 0x21
.qfail: mov ax,0x4C01
        int 0x21

help:   mov dx,s_use
        call puts
        mov ax,0x4C00
        int 0x21

puts:   push ax                         ; DX -> '$' string to stdout
        mov ah,9
        int 0x21
        pop ax
        ret

sp1:    push ax
        mov dl,' '
        mov ah,2
        int 0x21
        pop ax
        ret

phex4:  push ax
        mov al,ah
        call phex2
        pop ax
phex2:  push ax
        shr al,4
        call nib
        pop ax
        push ax
        and al,0x0F
        call nib
        pop ax
        ret

nib:    and al,0x0F
        add al,'0'
        cmp al,'9'
        jbe .o
        add al,7
.o:     mov dl,al
        mov ah,2
        int 0x21
        ret

; Rename runall.zip -> runall-<part>.zip on MS-DOS 7.0+ with LFN. Part from chipid.out (CHIPID /Q
; redirected). Keeps every register; no-op when the DOS is older, the file is missing/empty, or the
; LFN rename is refused. '/' in the part becomes '-', A-Z become a-z.
zipren: pusha
        mov ax,0x3000                   ; DOS major in AL
        int 0x21
        cmp al,7
        jb .out
        mov ax,0x3D00                   ; open chipid.out read-only
        mov dx,s_cfile
        int 0x21
        jc .out
        mov bx,ax
        mov ah,0x3F
        mov cx,32
        mov dx,partbuf
        int 0x21
        push ax
        mov ah,0x3E
        int 0x21
        pop cx                          ; bytes read
        jc .out
        or cx,cx
        jz .out
        mov si,partbuf
        add si,cx
        mov byte [si],0                 ; Asciz after the read
        mov si,partbuf
        mov di,partbuf
.cl:    lodsb                           ; strip CR/LF/space and sanitize into partbuf
        or al,al
        jz .ce
        cmp al,13
        je .ce
        cmp al,10
        je .ce
        cmp al,' '
        je .cl
        cmp al,9
        je .cl
        cmp al,'/'
        jne .lo
        mov al,'-'
        jmp .st
.lo:    cmp al,'A'
        jb .st
        cmp al,'Z'
        ja .st
        add al,0x20
.st:    stosb
        jmp .cl
.ce:    mov byte [di],0
        cmp di,partbuf
        je .out
        call zipdo
.out:   popa
        ret

; Same rename, part already in DX as a '$' string (CHIPID /Q /Z).
ziprenp:pusha
        mov ax,0x3000
        int 0x21
        cmp al,7
        jb .o
        mov si,dx
        mov di,partbuf
.c:     lodsb
        cmp al,'$'
        je .e
        cmp al,'/'
        jne .l
        mov al,'-'
        jmp .s
.l:     cmp al,'A'
        jb .s
        cmp al,'Z'
        ja .s
        add al,0x20
.s:     stosb
        jmp .c
.e:     mov byte [di],0
        cmp di,partbuf
        je .o
        call zipdo
.o:     popa
        ret

; partbuf Asciz sanitized -> rename runall.zip to runall-<part>.zip (LFN 7156h).
zipdo:  pusha
        mov di,zipname
        mov si,s_pref
        call cpyz
        dec di                          ; overwrite the 0 of the prefix
        mov si,partbuf
        call cpyz
        dec di
        mov si,s_suf
        call cpyz
        mov dx,zipname                  ; delete an older zip of that name (LFN)
        mov ax,0x7141
        xor cx,cx
        int 0x21
        mov dx,s_runall                 ; rename runall.zip -> runall-<part>.zip
        mov di,zipname
        mov ax,0x7156
        int 0x21
        popa
        ret

cpyz:   lodsb                           ; DS:SI Asciz -> ES:DI Asciz, DI after the 0
        stosb
        or al,al
        jnz cpyz
        ret

quiet   db 0
dozip   db 0
partbuf db 32 dup(0)
zipname db 32 dup(0)
s_cfile db 'chipid.out',0
s_runall db 'runall.zip',0
s_pref  db 'runall-',0
s_suf   db '.zip',0
s_title db 'CHIPID ',VERSION,13,10,'$'
s_cr    db 'CR2D-CR30 $'
s_cr6f  db ' CR6F $'
s_pci   db ', PCI $'
s_rev   db ' rev $'
s_na    db 'n/a',13,10,'$'
s_nl    db 13,10,'$'
s_use   db 'CHIPID ',VERSION,' - name the Trio64-family chip from PCI',13,10
        db '  CHIPID       print CR2D-CR30, CR6F, PCI device/rev, name and S3 part',13,10
        db '  CHIPID /Q    S3 part only (86C775, ...); -q is the same',13,10
        db '  CHIPID /Z    rename runall.zip to runall-<part>.zip when the DOS can',13,10
        db '               rename to a long name (Windows 98 DOS cannot; RUNALL uses REPORT)',13,10
        db '  CHIPID /H    this help',13,10
        db 'Exit 0 when a listed PCI 5333 device is found, 1 otherwise.',13,10
        db '8901: CR6F bit 0 clear = Trio64V2/DX 86C775, set = /GX 86C785.',13,10
        db '8A13 = Trio3D/2X 86C362/86C368; 8904 = Trio3D 86C365.',13,10
        db 'Uses src/tools/common/chip.inc (chipfind / chipidregs / chippart).',13,10,'$'

%include "chip.inc"
