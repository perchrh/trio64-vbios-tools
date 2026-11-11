; REPORT.COM - pack a RUNALL into one stored ZIP named from the S3 part (DOS, 386+)
;
; Purpose
;   Bundles the files RUNALL leaves behind into one ZIP and gives that archive the chip's part
;   name, which is what CHIPID /Z was meant to do by renaming runall.zip. The ZIP is method 0
;   (stored): no compression, the PKZIP container Info-ZIP's unzip reads (PKWARE APPNOTE, local
;   header signature 04034b50h, central directory 02014b50h, end record 06054b50h).
;
;   Windows 98 DOS can create a new file with a long name, and cannot rename an existing file to
;   one: CHIPID /Z calls INT 21h AX=7156h and the archive stays runall.zip. REPORT never renames.
;   It creates the archive under the final name with AX=716Ch (Ralf Brown: DX=0012h is bit 4
;   create plus bit 1 truncate), so the file is born as runall-<part>.zip. If that call is
;   refused, AH=3Ch creates the 8.3 name <part>.ZIP instead (86C775.ZIP; 86C362/86C368 becomes
;   86C362.ZIP, the text before the slash; 86C764-P becomes 86C764.ZIP, the text before the hyphen,
;   and runall-86c764-p.zip). An existing file of either name is deleted first.
;   After the archive is written, a zero-length write at the new end truncates the file, so a
;   create that left the old bytes in place cannot keep a previous end record past the new one.
;   With no part, the name is RUNALL.ZIP. A slash in the
;   part becomes a hyphen, and the long name is lower case. After the archive is written, a
;   leftover runall.zip and the other form of this part's name are deleted. Carry is set before
;   every AH=71h call so an unsupported call returns carry set (RBIL AH=71h: otherwise a DOS
;   older than 7.00 can return carry clear and AX=7100h).
;
; Usage
;   REPORT           pack the run's files and print the archive name on stdout
;   REPORT /H, /?    this help
;   Files, in order: *.log, *.dbg, s3regs.txt, vgalog*.bin (VGALOG.BIN, the per-tool VGALOG0.BIN...
;   dumps of runall.bat, VGALOGR.BIN), s3regs3.txt.
;   A missing file is a line "missing <name>" on stderr and is left out. Stdout is the version
;   line and the archive name. Exit 0 when the archive was written, 1 when it was not.
;
bits 16
org 0x100
cpu 386
%include "version.inc"

ZMAX    equ 40
ZE_SIZ  equ 32
ZE_OFS  equ 0
ZE_CRC  equ 4
ZE_SZ   equ 8
ZE_TIM  equ 12
ZE_DAT  equ 14
ZE_ATR  equ 16
ZE_NL   equ 18
ZE_NAM  equ 19
BUFSZ   equ 4096

start:  cld
        mov ax,ds
        mov es,ax
        call crcinit
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
        mov word [ziph],0xFFFF
        mov word [srcb],0xFFFF
        call chipfind                   ; src/tools/common/chip.inc; CF=1 when no part
        jc .noname
        call chippart                   ; DX -> '$' part
        mov si,dx
        cmp byte [si],'$'
        je .noname
        call makename
        jmp .open
.noname:
        call plainname
.open:  call openzip
        jc failmsg
.pk:    mov ah,0x1A                     ; our DTA, not the command tail at PSP:80h
        mov dx,dta
        int 0x21
        mov dx,pat_log
        call addwild
        cmp al,2
        je failmsg
        mov dx,pat_dbg
        call addwild
        cmp al,2
        je failmsg
        mov si,fn_regs
        call addnamed
        cmp al,2
        je failmsg
        mov dx,pat_vlog
        call addwild
        cmp al,2
        je failmsg
        mov si,fn_regsr
        call addnamed
        cmp al,2
        je failmsg
        cmp word [zn],0
        jne .cd
        mov si,s_none
        call eputs
        jmp fail
.cd:    call wrcent
        jc failmsg
        call zipcut                     ; drop any bytes past the archive just written
        call commit
        call zipclose
        call dropold
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

; Open the archive. Long name first when we have a part; else AH=3Ch. CF=1 when neither opens.
; Out: [ziph], [usedlong], [outn].
openzip:
        cmp byte [named],1
        jne .sfn
        mov dx,lfnname
        call delany
        mov dx,sfnname
        call delany
        call trylong
        jnc .ok
.sfn:   mov dx,sfnname
        call delany
        xor cx,cx
        mov ah,0x3C
        int 0x21
        jc .bad
        mov [ziph],ax
        mov byte [usedlong],0
        mov word [outn],sfnname
.ok:    clc
        ret
.bad:   stc
        ret

; AX=716Ch create-or-truncate (RBIL DX bit 4 + bit 1). CF set on entry. CF=1 when refused.
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

; Pattern at DX: every match, or one "missing" line when there is none. AL=2 on a write error.
addwild:
        push dx
        xor cx,cx
        mov ah,0x4E
        int 0x21
        pop dx
        jnc .hit
        mov si,dx
        call miss
        xor al,al
        ret
.hit:   test byte [dta+0x15],0x18       ; directory or volume label
        jnz .nx
        mov si,dta+0x1E
        mov di,nbuf
        mov ax,ds
        mov es,ax
        cld
        call scpyz
        mov si,nbuf
        call addfile
        cmp al,2
        je .bad
        cmp al,1
        jne .nx
        mov si,nbuf
        call miss
.nx:    mov ah,0x4F
        int 0x21
        jnc .hit
        xor al,al
        ret
.bad:   mov al,2
        ret

; SI -> one file. A missing file is a warning (AL=0). AL=2 on a write error.
addnamed:
        call addfile
        cmp al,1
        jne .k
        mov si,[curname]
        call miss
        xor al,al
.k:     ret

; SI -> file name. AL=0 added, AL=1 missing, AL=2 the archive could not be written.
; Closes the source file. Does not close the archive.
addfile:
        mov [curname],si
        mov dx,si
        mov ax,0x3D00
        int 0x21
        jnc .op
        mov al,1
        ret
.op:    mov [srcb],ax
        mov bx,ax
        mov ax,0x5700                   ; CX=time, DX=date
        int 0x21
        mov [ftime],cx
        mov [fdate],dx
        mov si,[curname]
        mov dx,si
        mov ax,0x4300
        int 0x21
        jnc .at
        mov cx,0x20                     ; archive bit, when the attribute cannot be read
.at:    mov [fattr],cx
        mov si,[curname]
        call wrlocal
        jc .io
        call copyfile
        jc .io
        call patch
        jc .io
        call storeent
        jc .io
        call srcclose
        xor al,al
        ret
.io:    call srcclose
        mov al,2
        ret

srcclose:
        cmp word [srcb],0xFFFF
        je .d
        mov bx,[srcb]
        mov ah,0x3E
        int 0x21
        mov word [srcb],0xFFFF
.d:     ret

; Local header at the current end, crc and sizes still zero (patched after the copy).
; SI -> name. CF=1 on a short write. [entofs] is the header's offset.
wrlocal:
        mov ax,ds
        mov es,ax
        cld
        mov eax,[zippos]
        mov [entofs],eax
        mov di,hdr
        mov ax,0x4B50
        stosw
        mov ax,0x0403                   ; 50 4B 03 04
        stosw
        mov ax,10                       ; version needed: 1.0, stored
        stosw
        xor ax,ax
        stosw                           ; flags
        stosw                           ; method 0
        mov ax,[ftime]
        stosw
        mov ax,[fdate]
        stosw
        xor eax,eax
        stosd
        stosd
        stosd
        call namelen                    ; CX = length, SI kept
        mov ax,cx
        stosw
        xor ax,ax
        stosw
        push si
        rep movsb
        pop si
        mov cx,di
        sub cx,hdr
        mov dx,hdr
        call zipwr
        ret

; Read [srcb] to the end, writing it and folding the CRC. CF=1 on error.
; Out: [fsize] byte count, [fcrc] the ZIP crc (final xor already applied).
copyfile:
        mov dword [fcrc],0xFFFFFFFF
        mov dword [fsize],0
.rd:    mov bx,[srcb]
        mov ah,0x3F
        mov cx,BUFSZ
        mov dx,iobuf
        int 0x21
        jc .bad
        or ax,ax
        jz .eof
        mov cx,ax
        movzx eax,ax
        add [fsize],eax
        call crcbuff
        mov cx,ax
        mov dx,iobuf
        call zipwr
        jc .bad
        jmp .rd
.eof:   xor dword [fcrc],0xFFFFFFFF
        clc
        ret
.bad:   stc
        ret

; Write the crc and both sizes back over the local header. Leaves the file pointer at the end.
patch:  mov eax,[entofs]
        add eax,14
        call zipseek
        jc .bad
        mov eax,[fcrc]
        mov [scratch],eax
        mov eax,[fsize]
        mov [scratch+4],eax
        mov [scratch+8],eax
        mov bx,[ziph]
        mov ah,0x40
        mov cx,12
        mov dx,scratch
        int 0x21
        jc .bad
        cmp ax,12
        jne .bad
        mov eax,[zippos]
        call zipseek
        ret
.bad:   stc
        ret

; One central-directory row for the file just written. CF=1 when the table is full.
storeent:
        mov bx,[zn]
        cmp bx,ZMAX
        jae .full
        mov ax,bx
        mov cl,5
        shl ax,cl                       ; * 32
        mov di,zents
        add di,ax
        mov eax,[entofs]
        mov [di+ZE_OFS],eax
        mov eax,[fcrc]
        mov [di+ZE_CRC],eax
        mov eax,[fsize]
        mov [di+ZE_SZ],eax
        mov ax,[ftime]
        mov [di+ZE_TIM],ax
        mov ax,[fdate]
        mov [di+ZE_DAT],ax
        mov ax,[fattr]
        mov [di+ZE_ATR],ax
        mov si,[curname]
        call namelen
        cmp cx,12
        jbe .nl
        mov cx,12
.nl:    mov [di+ZE_NL],cl
        mov ax,ds
        mov es,ax
        cld
        push di
        add di,ZE_NAM
        rep movsb
        xor al,al
        stosb
        pop di
        inc word [zn]
        clc
        ret
.full:  stc
        ret

; Central directory and the end record. CF=1 on a short write.
wrcent: mov eax,[zippos]
        mov [cdofs],eax
        xor bx,bx
.e:     cmp bx,[zn]
        jae .end
        call wrone
        jc .bad
        inc bx
        jmp .e
.end:   mov eax,[zippos]
        sub eax,[cdofs]
        mov [cdsz],eax
        call wreocd
        ret
.bad:   stc
        ret

; BX = entry index. Writes one central header. Keeps BX.
wrone:  push bx
        mov ax,ds
        mov es,ax
        cld
        mov ax,bx
        mov cl,5
        shl ax,cl
        mov si,zents
        add si,ax
        mov di,hdr
        mov ax,0x4B50
        stosw
        mov ax,0x0201                   ; 50 4B 01 02
        stosw
        xor ax,ax
        stosw                           ; version made by: DOS
        mov ax,10
        stosw
        xor ax,ax
        stosw                           ; flags
        stosw                           ; method
        mov ax,[si+ZE_TIM]
        stosw
        mov ax,[si+ZE_DAT]
        stosw
        mov eax,[si+ZE_CRC]
        stosd
        mov eax,[si+ZE_SZ]
        stosd
        stosd
        movzx ax,byte [si+ZE_NL]
        stosw
        xor ax,ax
        stosw
        stosw
        stosw
        stosw                           ; internal attributes
        movzx eax,word [si+ZE_ATR]
        stosd
        mov eax,[si+ZE_OFS]
        stosd
        movzx cx,byte [si+ZE_NL]
        add si,ZE_NAM
        rep movsb
        mov cx,di
        sub cx,hdr
        mov dx,hdr
        call zipwr
        pop bx
        ret

wreocd: mov ax,ds
        mov es,ax
        cld
        mov di,hdr
        mov ax,0x4B50
        stosw
        mov ax,0x0605                   ; 50 4B 05 06
        stosw
        xor ax,ax
        stosw
        stosw
        mov ax,[zn]
        stosw
        stosw
        mov eax,[cdsz]
        stosd
        mov eax,[cdofs]
        stosd
        xor ax,ax
        stosw
        mov cx,di
        sub cx,hdr
        mov dx,hdr
        call zipwr
        ret

; Seek to the bytes written and write CX=0. DOS sets the file length to the file pointer,
; so an old longer archive cannot keep its end record. CF from the write.
zipcut: mov eax,[zippos]
        call zipseek
        jc .r
        mov bx,[ziph]
        xor cx,cx
        mov ah,0x40
        int 0x21
.r:     ret

; Commit and flush before we say the archive exists (same idea as VGALOG /D, #158).
commit: mov bx,[ziph]
        mov ah,0x68
        int 0x21
        mov ah,0x0D
        int 0x21
        ret

zipclose:
        cmp word [ziph],0xFFFF
        je .d
        mov bx,[ziph]
        mov ah,0x3E
        int 0x21
        mov word [ziph],0xFFFF
.d:     ret

; EAX = absolute offset in the archive. CF from the seek.
zipseek:
        push ebx
        push ecx
        push edx
        mov bx,[ziph]
        mov dx,ax
        shr eax,16
        mov cx,ax
        mov ax,0x4200
        int 0x21
        pop edx
        pop ecx
        pop ebx
        ret

; CX bytes at DX to the archive. CF=1 on error or a short write. Updates [zippos].
zipwr:  push cx                         ; some DOS builds do not keep CX across AH=40h
        mov bx,[ziph]
        mov ah,0x40
        int 0x21
        pop cx
        jc .e
        cmp ax,cx
        jne .e
        movzx eax,ax
        add [zippos],eax
        clc
        ret
.e:     stc
        ret

; CRC-32 (polynomial EDB88320h) of CX bytes at iobuf, folded into [fcrc]. Keeps registers.
crcbuff:
        pushad
        mov si,iobuf
        jcxz .d
.l:     movzx ebx,byte [si]
        inc si
        xor bl,byte [fcrc]
        movzx ebx,bl
        shl ebx,2
        mov eax,[crctab+ebx]
        mov edx,[fcrc]
        shr edx,8
        xor eax,edx
        mov [fcrc],eax
        loop .l
.d:     popad
        ret

; 256-entry table. Keeps registers.
crcinit:
        pushad
        xor bx,bx
.ti:    movzx eax,bl
        mov cx,8
.tb:    shr eax,1
        jnc .nc
        xor eax,0xEDB88320
.nc:    loop .tb
        movzx edx,bl
        shl edx,2
        mov [crctab+edx],eax
        inc bl
        jnz .ti
        popad
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
fail:   call srcclose
        mov dx,[outn]
        or dx,dx
        jz .m
        cmp word [ziph],0xFFFF
        je .gone
        call zipclose
.gone:  call delany                      ; the partial archive
.m:     mov ax,0x4C01
        int 0x21

s_title db 'REPORT ',VERSION,13,10,'$'
s_use   db 'REPORT ',VERSION,' - pack a RUNALL into one stored ZIP',13,10
        db '  REPORT       *.log *.dbg s3regs.txt vgalog*.bin s3regs3.txt',13,10
        db '  REPORT /H    this help',13,10
        db 'Name: runall-<part>.zip, created under that name (a rename is not used).',13,10
        db 'If the DOS cannot create a long name: <part>.ZIP (86C775.ZIP).',13,10
        db 'No part: RUNALL.ZIP. Missing files are left out.',13,10
        db 'Stored ZIP (method 0), no compression.',13,10,'$'
s_cant  db 'REPORT: cannot write the archive',0
s_none  db 'REPORT: no files to pack',0
s_miss  db 'missing ',0
s_crlf  db 13,10
s_pref  db 'runall-',0
s_suf   db '.zip',0
s_SUF   db '.ZIP',0
s_run   db 'RUNALL.ZIP',0
s_old   db 'runall.zip',0
pat_log db '*.log',0
pat_dbg db '*.dbg',0
fn_regs db 's3regs.txt',0
pat_vlog db 'vgalog*.bin',0
fn_regsr db 's3regs3.txt',0

named   db 0
usedlong db 0
ziph    dw 0xFFFF
srcb    dw 0xFFFF
outn    dw 0
zn      dw 0
zippos  dd 0
entofs  dd 0
cdofs   dd 0
cdsz    dd 0
fcrc    dd 0
fsize   dd 0
ftime   dw 0
fdate   dw 0
fattr   dw 0
curname dw 0
lfnname db 40 dup(0)
sfnname db 16 dup(0)
nbuf    db 16 dup(0)
hdr     db 80 dup(0)
scratch db 16 dup(0)
dta     db 128 dup(0)
zents   times ZMAX*ZE_SIZ db 0
crctab  times 256 dd 0
iobuf   times BUFSZ db 0

%include "chip.inc"
