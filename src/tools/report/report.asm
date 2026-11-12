;
; Purpose
;   Bundles the files RUNALL leaves behind into one ZIP and gives that archive the chip's part
;   name, which is what CHIPID /Z was meant to do by renaming runall.zip. The ZIP itself is made
;   by Info-ZIP's ZIP.EXE (the 16-bit zip 2.32 binary shipped next to this source as ZIP.EXE,
;   license in ZIP-LICENSE.txt): REPORT only enumerates the run's files and calls
;   ZIP.EXE -q <archive> <names...> with INT 21h AH=4Bh, waiting for it with AH=4Dh. The command
;   tail of a PSP holds at most 126 bytes, so a long list goes in several execs; ZIP.EXE updates
;   the archive it finds, so the batches add up to one archive. ZIP.EXE needs about 455 KB of
;   contiguous free DOS memory, so REPORT shrinks its own block (AH=4Ah) to its 64 KB before the
;   first exec (the stack at PSP:FFFEh stays inside the block, where DOS saves the exec return).
;   Info-ZIP's unzip on Linux reads what ZIP.EXE writes (deflate, method 8).
;
;   Windows 98 DOS can create a new file with a long name, and cannot rename an existing file to
;   one: CHIPID /Z calls INT 21h AX=7156h and the archive stays runall.zip. REPORT never renames.
;   It probes the long name with AX=716Ch (Ralf Brown: DX=0012h is bit 4 create plus bit 1
;   truncate; carry set before the call, so an unsupported call returns carry set), deletes the
;   probe's empty file again and hands that name to ZIP.EXE. If the probe is refused, ZIP.EXE gets
;   the 8.3 name <part>.ZIP instead (86C775.ZIP; 86C362/86C368 becomes 86C362.ZIP, the text before
;   the slash; 86C764-P becomes 86C764.ZIP, the text before the hyphen, and runall-86c764-p.zip
;   stays as the long form). An existing file of either name is deleted first. With no part, the
;   name is RUNALL.ZIP. A slash in the part becomes a hyphen, and the long name is lower case.
;   After the archive is written, a leftover runall.zip and the other form of this part's name are
;   deleted.
;
; Usage
;   REPORT           pack the run's files and print the archive name on stdout
;   REPORT /H, /?    this help
;   Files, in order: *.log, *.dbg, s3regs.txt, vgalog*.bin (VGALOG.BIN, the per-tool VGALOG0.BIN...
;   dumps of runall.bat), s3regs3.txt.
;   A missing file is a line "missing <name>" on stderr and is left out. Stdout is the version
;   line and the archive name. Exit 0 when the archive was written, 1 when it was not.
;
bits 16
org 0x100
cpu 386
%include "version.inc"

ZMAX    equ 40                         ; names the namelist holds
NAMLEN  equ 13                         ; one 8.3 name plus its 0

start:  cld
        mov ax,ds
        mov es,ax
        mov si,0x81
.opt:   lodsb
        cmp al,13
        je .go
        cmp al,' '
        je .opt
        cmp al,9
        je .opt
        cmp al,'/'
        je .sw
        cmp al,'-'
        jne .opt
.sw:    lodsb
        cmp al,'?'
        je help
        or al,0x20
        cmp al,'h'
        je help
        jmp .opt

.go:    mov dx,s_title
        call puts
        call chipfind                   ; src/tools/common/chip.inc; CF=1 when no part
        jc .noname
        call chippart                   ; DX -> '$' part
        mov si,dx
        cmp byte [si],'$'
        je .noname
        call makename
        jmp .ch
.noname:
        call plainname
.ch:    call choose                     ; [outn], [usedlong]; old archives deleted
        mov ah,0x1A                     ; our DTA, not the command tail at PSP:80h
        mov dx,dta
        int 0x21
        mov dx,pat_log
        call addwild
        mov dx,pat_dbg
        call addwild
        mov si,fn_regs
        call addnamed
        mov dx,pat_vlog
        call addwild
        mov si,fn_regsr
        call addnamed
        cmp word [zn],0
        jne .cd
        mov si,s_none
        call eputs
        jmp fail
.cd:    call shrink                     ; room for ZIP.EXE's buffers
        call execzip                    ; AL: 0 ok, 2 no ZIP.EXE, 3 it failed
        test al,al
        jz .ok
        cmp al,2
        je .nozip
        mov si,s_zipfail
        jmp .msg
.nozip: mov si,s_nozip
.msg:   call eputs
        jmp fail
.ok:    mov dx,[outn]                   ; the archive must be there now
        xor cx,cx
        mov ah,0x4E
        int 0x21
        jnc .have
        cmp byte [usedlong],1
        jne failmsg
        mov word [outn],sfnname         ; the DOS made the 8.3 name after all
        mov dx,[outn]
        xor cx,cx
        mov ah,0x4E
        int 0x21
        jc failmsg
.have:  call dropold
        call putname
        mov ax,0x4C00
        int 0x21

help:   mov dx,s_use
        call puts
        mov ax,0x4C00
        int 0x21

; Build runall-<part>.zip and <PART>.ZIP from the '$' part at DX. Sets [named]. Keeps nothing.
makename:
        pushad
        mov ax,ds
        mov es,ax
        cld
        mov byte [named],1
        mov si,s_pref
        mov di,lfnname
        call scopy0
        mov si,dx
.lp:    lodsb
        cmp al,'$'
        je .le
        cmp al,'/'
        jne .ll
        mov al,'-'
        jmp .ls
.ll:    cmp al,'A'
        jb .ls
        cmp al,'Z'
        ja .ls
        add al,0x20
.ls:    stosb
        jmp .lp
.le:    mov si,s_suf
        call scpyz
        mov si,dx
        mov di,sfnname
        xor cx,cx
.sp:    cmp cx,8
        jae .se
        lodsb
        cmp al,'$'
        je .se
        cmp al,'/'
        je .se
        cmp al,'-'
        je .se
        cmp al,'a'
        jb .su
        cmp al,'z'
        ja .su
        sub al,0x20
.su:    stosb
        inc cx
        jmp .sp
.se:    mov si,s_SUF
        call scpyz
        popad
        ret

; No part: both names are the 8.3 archive. Keeps nothing.
plainname:
        pushad
        mov ax,ds
        mov es,ax
        cld
        mov byte [named],0
        mov byte [usedlong],0
        mov si,s_run
        mov di,sfnname
        call scpyz
        mov si,s_run
        mov di,lfnname
        call scpyz
        popad
        ret

; Choose the archive name and delete old files of both forms. Long name when the DOS takes an
; AX=716Ch create (probed, then closed and deleted, so ZIP.EXE starts from nothing), else the
; 8.3 name. Out: [outn], [usedlong]. Keeps nothing.
choose:
        cmp byte [named],1
        jne .sfn
        mov dx,lfnname
        call delany
        mov dx,sfnname
        call delany
        call trylong                    ; CF=1 when refused
        jnc .long
.sfn:   mov byte [usedlong],0
        mov word [outn],sfnname
        mov dx,sfnname
        call delany
        ret
.long:  mov bx,[ziph]                   ; close and delete the probe's empty file
        mov ah,0x3E
        int 0x21
        mov word [ziph],0xFFFF
        mov dx,lfnname
        call delany
        mov byte [usedlong],1
        mov word [outn],lfnname
        ret

; AX=716Ch create-or-truncate (RBIL DX bit 4 + bit 1). CF set on entry. CF=1 when refused.
; Out on success: [ziph], [usedlong], [outn].
trylong:
        stc
        mov ax,0x716C
        mov bx,0x0002                   ; read/write, sharing compatibility
        xor cx,cx
        mov dx,0x0012
        mov si,lfnname
        xor di,di                       ; BX bit 10 clear: DI is not a numeric tail
        int 0x21
        jc .no
        cmp ax,0x7100
        je .no
        mov [ziph],ax
        mov byte [usedlong],1
        mov word [outn],lfnname
        clc
        ret
.no:    stc
        ret

; Delete leftover names that are not the archive just written. Ignores errors.
dropold:
        cmp byte [named],1
        jne .d
        mov dx,s_old
        call delany
        cmp byte [usedlong],1
        jne .was8
        mov dx,sfnname
        call delany
        jmp .d
.was8:  mov dx,lfnname
        call delany
.d:     ret

; DX -> name. Long-name delete (SI=0, no wildcards), then the 8.3 delete. Keeps DX.
delany: push dx
        stc
        mov ax,0x7141
        xor si,si
        xor cx,cx
        int 0x21
        pop dx
        mov ah,0x41
        int 0x21
        ret

; Pattern at DX: every match goes into the namelist, or one "missing" line when there is none.
addwild:
        push dx
        xor cx,cx
        mov ah,0x4E
        int 0x21
        pop dx
        jnc .hit
        mov si,dx
        call miss
        ret
.hit:   test byte [dta+0x15],0x18       ; directory or volume label
        jnz .nx
        mov si,dta+0x1E
        call addname
.nx:    mov ah,0x4F
        int 0x21
        jnc .hit
        ret

; SI -> one file name: added when it is there, else a "missing" line.
addnamed:
        push si
        mov dx,si
        xor cx,cx
        mov ah,0x4E
        int 0x21
        jc .m
        mov si,dta+0x1E
        call addname
        pop si
        ret
.m:     pop si
        call miss
        ret

; SI -> ASCIZ name: append to the namelist while it fits (ZMAX names). Keeps SI.
addname:
        cmp word [zn],ZMAX
        jae .d
        push ax
        push cx
        push di
        push es
        mov ax,[zn]
        mov cx,NAMLEN
        mul cx
        mov di,namelist
        add di,ax
        mov ax,ds
        mov es,ax
        cld
        call scpyz
        inc word [zn]
        pop es
        pop di
        pop cx
        pop ax
.d:     ret

; Shrink our own block to the 64 KB the program starts with, so the child gets the rest of the
; memory (ZIP.EXE wants about 455 KB contiguous). The whole 64 KB stays ours on purpose: the
; stack at PSP:FFFEh is inside it, and DOS saves the return from the exec (AH=4Bh) on the
; caller's stack, where the child's memory block must not reach. Ignores errors. Keeps nothing.
shrink:
        mov ax,ds
        mov es,ax
        mov bx,0x1000
        mov ah,0x4A
        int 0x21
        ret

; Run ZIP.EXE over the namelist, one command-tail-sized batch per exec (ZIP.EXE updates the
; archive it finds, so the batches add up). Out: AL = 0 ok, 2 ZIP.EXE not found, 3 it failed.
; Keeps nothing.
execzip:
        mov word [nextname],0
.l:     call buildtail
        jnc .go
        xor al,al
        ret
.go:    mov ax,ds
        mov es,ax
        xor ax,ax
        mov [execblk],ax                ; inherit the environment
        mov word [execblk+2],tailbuf    ; the command tail
        mov [execblk+4],ds
        mov [execblk+6],ax              ; FCBs zero: inherit handles 0-2
        mov [execblk+8],ax
        mov [execblk+0x0C],ax
        mov [execblk+0x0E],ax
        mov dx,progname
        mov bx,execblk
        mov ax,0x4B00
        int 0x21
        jc .nozip
        mov ah,0x4D                     ; wait for the child: AL = its exit code
        int 0x21
        cmp al,1                        ; 0 ok, 1 warnings
        ja .zipfail
        jmp .l
.nozip: mov al,2
        ret
.zipfail:
        mov al,3
        ret

; Build one command tail: " -q " <archive> then as many " NAME" as fit in the 126 bytes a PSP
; tail holds. Advances [nextname]. CF=1 when no name is left. Keeps nothing.
buildtail:
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        mov ax,ds
        mov es,ax
        cld
        mov di,tailbuf+1
        mov si,s_zipargs                ; " -q "
        call scopy0
        mov si,[outn]
        call scopy0
        mov bx,[nextname]
.n:     cmp bx,[zn]
        jae .e
        mov ax,bx
        mov cx,NAMLEN
        mul cx
        mov si,namelist
        add si,ax
        push di
        call namelen                    ; CX = name length, SI kept
        pop di
        mov ax,di
        sub ax,tailbuf+1                ; chars used so far
        add ax,cx
        inc ax                          ; the separating space
        cmp ax,126
        ja .e
        mov al,' '
        stosb
        call scopy0
        inc bx
        jmp .n
.e:     cmp bx,[nextname]
        je .none
        mov [nextname],bx
        mov al,13
        stosb                           ; the CR after the counted bytes
        mov ax,di
        sub ax,tailbuf+1
        mov [tailbuf],al                ; the count, not counting the CR
        clc
        jmp .x
.none:  stc
.x:     pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret

; SI -> ASCIZ, CX = length, SI kept.
namelen:
        push si
        xor cx,cx
.l:     lodsb
        or al,al
        jz .d
        inc cx
        jmp .l
.d:     pop si
        ret

; DS:SI ASCIZ -> ES:DI, the terminating 0 is not copied. DI after the last byte.
scopy0: lodsb
        or al,al
        jz .d
        stosb
        jmp scopy0
.d:     ret

; DS:SI ASCIZ -> ES:DI, including the 0. DI after the 0.
scpyz:  lodsb
        stosb
        or al,al
        jnz scpyz
        ret

; Print [outn] and CR/LF on stdout.
putname:
        mov si,[outn]
        call slen
        mov dx,si
        mov bx,1
        mov ah,0x40
        int 0x21
        mov dx,s_crlf
        mov cx,2
        mov bx,1
        mov ah,0x40
        int 0x21
        ret

; SI -> ASCIZ "missing <name>" on stderr.
miss:   push si
        mov si,s_miss
        call slen
        mov dx,si
        mov bx,2
        mov ah,0x40
        int 0x21
        pop si
        call eputs
        ret

; DX -> '$' string on stdout (the version line and the help).
puts:   mov ah,9
        int 0x21
        ret

; SI -> ASCIZ plus CR/LF on stderr.
eputs:  call slen
        mov dx,si
        mov bx,2
        mov ah,0x40
        int 0x21
        mov dx,s_crlf
        mov cx,2
        mov bx,2
        mov ah,0x40
        int 0x21
        ret

; SI -> ASCIZ, CX = length, SI kept. Same as namelen; stderr writes use this name.
slen:   jmp namelen

failmsg:
        mov si,s_cant
        call eputs
fail:   mov dx,[outn]
        or dx,dx
        jz .m
        call delany                     ; the partial archive
.m:     mov ax,0x4C01
        int 0x21

s_title db 'REPORT ',VERSION,13,10,'$'
s_use   db 'REPORT ',VERSION,' - pack a RUNALL into one ZIP with ZIP.EXE',13,10
        db '  REPORT       *.log *.dbg s3regs.txt vgalog*.bin s3regs3.txt',13,10
        db '  REPORT /H    this help',13,10
        db 'Name: runall-<part>.zip, created under that name (a rename is not used).',13,10
        db 'If the DOS cannot create a long name: <part>.ZIP (86C775.ZIP).',13,10
        db 'No part: RUNALL.ZIP. Missing files are left out.',13,10
        db 'The archive is made by ZIP.EXE (Info-ZIP zip 2.32, 16-bit, shipped with the tools;',13,10
        db 'deflate, method 8, which Info-ZIP unzip reads). It needs about 455 KB free memory.',13,10,'$'
s_cant  db 'REPORT: cannot write the archive',0
s_nozip db 'REPORT: cannot run ZIP.EXE (is it next to REPORT.COM or in the PATH?)',0
s_zipfail db 'REPORT: ZIP.EXE failed',0
s_none  db 'REPORT: no files to pack',0
s_miss  db 'missing ',0
s_crlf  db 13,10
s_pref  db 'runall-',0
s_suf   db '.zip',0
s_SUF   db '.ZIP',0
s_run   db 'RUNALL.ZIP',0
s_old   db 'runall.zip',0
s_zipargs db ' -q ',0
progname db 'ZIP.EXE',0
pat_log db '*.log',0
pat_dbg db '*.dbg',0
fn_regs db 's3regs.txt',0
pat_vlog db 'vgalog*.bin',0
fn_regsr db 's3regs3.txt',0

named   db 0
usedlong db 0
ziph    dw 0xFFFF
outn    dw 0
zn      dw 0
nextname dw 0
lfnname db 40 dup(0)
sfnname db 16 dup(0)
namelist times ZMAX*NAMLEN db 0
tailbuf db 128 dup(0)
execblk db 16 dup(0)
dta     db 128 dup(0)

%include "chip.inc"
