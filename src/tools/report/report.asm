; REPORT.COM - pack a RUNALL into one deflate ZIP named from the S3 part (DOS, 386+)
;
; Purpose
;   Bundles the files RUNALL leaves behind into one ZIP and gives that archive the chip's part
;   name, which is what CHIPID /Z was meant to do by renaming runall.zip. The ZIP is method 8
;   (deflate, RFC 1951), which Info-ZIP's unzip on Linux reads: the PKZIP container of PKWARE's
;   APPNOTE (local header signature 04034b50h, central directory 02014b50h, end record
;   06054b50h) around a deflate stream. Each read chunk (4 KB) becomes its own block: a
;   dynamic-Huffman block (BTYPE=10, the codes built per chunk) when that is the smallest, else a
;   fixed-Huffman block (BTYPE=01), else - when even that is not smaller than the chunk plus the
;   5 bytes of a stored block - a stored block (BTYPE=00), so a VGALOG dump of near-random bytes
;   does not grow. The matcher is LZ77 over a 32 KB window with 13-bit hash chains of at most 32
;   candidates and one-step lazy matching - an effort in the range of Info-ZIP zip's levels 4-5
;   on text, the kind of file a run leaves. The
;   window and the hash tables come from a block got with INT 21h AH=48h after AH=4Ah keeps the
;   program's own 64 KB (the stack at PSP:FFFEh stays inside it); when the DOS has no memory for
;   them, every file is stored (method 0, version 1.0) as before, a ZIP unzip reads as well.
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
;   dumps of runall.bat), s3regs3.txt.
;   A missing file is a line "missing <name>" on stderr and is left out. Stdout is the version
;   line and the archive name. Exit 0 when the archive was written, 1 when it was not.
;
bits 16
org 0x100
cpu 386
%include "version.inc"

ZMAX    equ 40
ZE_SIZ  equ 36
ZE_OFS  equ 0
ZE_CRC  equ 4
ZE_CS   equ 8
ZE_SZ   equ 12
ZE_TIM  equ 16
ZE_DAT  equ 18
ZE_ATR  equ 20
ZE_NL   equ 22
ZE_NAM  equ 23
BUFSZ   equ 4096
WSIZE   equ 32768                   ; the LZ77 window: deflate's maximum distance
HSIZE   equ 8192                    ; hash table entries: a 13-bit hash of 3 bytes
MAXCHAIN equ 32                     ; candidates per hash: the match effort (zip level 4-5 range)
AWIN    equ 0                       ; window, in the AH=48h block (reached over FS)
AHEAD   equ WSIZE                   ; HSIZE words: most recent window index per hash
APREV   equ AHEAD+HSIZE*2           ; WSIZE words: previous window index per hash
NEEDPARA equ (APREV+WSIZE*2+15)>>4  ; paragraphs the block must have
ABITSZ  equ 1024                    ; archive bit buffer
SCRSZ   equ BUFSZ*9/8+16            ; one chunk's bits in the worst case (9 bits per byte)

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
        call allocmem
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
        mov eax,[zippos]
        mov [datastart],eax
        cmp byte [compok],1
        jne .plain
        call deflate                    ; method 8: the compressed stream, [fcrc], [fsize]
        jc .io
        jmp .cs
.plain: call copyfile                    ; method 0: the file itself, [fcrc], [fsize]
        jc .io
.cs:    mov eax,[zippos]
        sub eax,[datastart]
        mov [fcsz],eax
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
        mov ax,[zver]                   ; version needed: 2.0 deflate, else 1.0 stored
        stosw
        xor ax,ax
        stosw                           ; flags
        mov ax,[zmet]
        stosw                           ; method: 8 deflate, else 0 stored
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

; Write the crc, the compressed and the uncompressed size back over the local header.
; Leaves the file pointer at the end.
patch:  mov eax,[entofs]
        add eax,14
        call zipseek
        jc .bad
        mov eax,[fcrc]
        mov [scratch],eax
        mov eax,[fcsz]
        mov [scratch+4],eax
        mov eax,[fsize]
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
        imul di,bx,ZE_SIZ
        add di,zents
        mov eax,[entofs]
        mov [di+ZE_OFS],eax
        mov eax,[fcrc]
        mov [di+ZE_CRC],eax
        mov eax,[fcsz]
        mov [di+ZE_CS],eax
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
        imul si,bx,ZE_SIZ
        add si,zents
        mov di,hdr
        mov ax,0x4B50
        stosw
        mov ax,0x0201                   ; 50 4B 01 02
        stosw
        xor ax,ax
        stosw                           ; version made by: DOS
        mov ax,[zver]
        stosw
        xor ax,ax
        stosw                           ; flags
        mov ax,[zmet]
        stosw                           ; method
        mov ax,[si+ZE_TIM]
        stosw
        mov ax,[si+ZE_DAT]
        stosw
        mov eax,[si+ZE_CRC]
        stosd
        mov eax,[si+ZE_CS]
        stosd
        mov eax,[si+ZE_SZ]
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

; Get the compressor's memory: shrink our own block to the 64 KB the program starts with (the
; stack at PSP:FFFEh stays inside it), then allocate the window and hash tables above it.
; Out: [compok] 1 when the block is there, [bufseg] its segment, [zver]/[zmet] the ZIP version
; and method to write (2.0/8 deflate, else 1.0/0 stored). Keeps nothing.
allocmem:
        mov byte [compok],0
        mov word [zver],10
        mov word [zmet],0
        mov ah,0x4A                     ; ES = PSP
        mov bx,0x1000
        int 0x21
        jc .d
        mov ah,0x48
        mov bx,NEEDPARA
        int 0x21
        jc .d
        mov [bufseg],ax
        mov byte [compok],1
        mov word [zver],20
        mov word [zmet],8
.d:     ret

; Compress the whole file [srcb] into the archive as one method-8 stream: fixed-Huffman blocks
; of one read chunk each, a stored block when the deflate bits would not be smaller, and a
; final block at the end. Out: [fcrc], [fsize]. CF=1 on a read or write error. Keeps DS, ES.
deflate:
        push ds
        mov ax,[bufseg]
        mov es,ax
        mov di,AHEAD
        mov cx,HSIZE
        mov ax,0xFFFF
        rep stosw
        mov di,APREV
        mov cx,WSIZE
        rep stosw
        pop ds
        mov ax,ds
        mov es,ax                       ; ES back to our own data: the block is reached over FS
        mov dword [apos],0
        mov dword [wacc],0
        mov dword [wnbits],0
        mov dword [wpos],0
        mov dword [fcrc],0xFFFFFFFF
        mov dword [fsize],0
.rd:    mov bx,[srcb]
        mov ah,0x3F
        mov cx,BUFSZ
        mov dx,iobuf
        int 0x21
        jc .bad
        movzx eax,ax
        mov [chn],eax
        test eax,eax
        jz .fin
        mov cx,ax
        call crcbuff
        mov eax,[chn]
        add [fsize],eax
        call compchunk
        jc .bad
        jmp .rd
.fin:   mov ax,[bufseg]
        mov fs,ax
        mov eax,[wacc]                  ; the final block continues the archive stream's bits
        mov [sacc],eax
        mov eax,[wnbits]
        mov [snbits],eax
        mov dword [spos],0
        mov eax,1                       ; BFINAL = 1
        mov cl,1
        call sbitv
        mov eax,1                       ; BTYPE = 01, fixed Huffman
        mov cl,2
        call sbitv
        xor eax,eax                     ; end of block, symbol 256: 7-bit code 0000000
        mov cl,7
        call shut
        call commitfix
        jc .bad
        call rfinal
        jc .bad
        xor dword [fcrc],0xFFFFFFFF
        clc
        ret
.bad:   stc
        ret

; Compress the [chn] bytes at iobuf as one non-final deflate block, first into the scratch bit
; stream, then commit: a dynamic-Huffman block (BTYPE=10) when the codes can be built and its bits
; are the fewest, else a fixed-Huffman block (BTYPE=01), else a stored block (BTYPE=00) when even
; that is not smaller than the chunk plus 5 bytes.
; In: [apos] = absolute offset of iobuf[0]. Out: [apos] += [chn]. CF=1 on a write error.
; Keeps DS, ES.
compchunk:
        mov ax,[bufseg]
        mov fs,ax
        mov eax,[wacc]
        mov [saveacc],eax
        mov eax,[wnbits]
        mov [savenbits],eax
        call parsechunk                 ; the tokens, the frequencies, the window
        call builddyn
        mov byte [dynok],0
        jc .bd                          ; builddyn failed: no dynamic block, dynok stays 0
        mov byte [dynok],1
.bd:    call fixbits                    ; -> [fbits]
        cmp byte [dynok],1
        je .dd
        mov dword [dbits],0x7FFFFFFF
        jmp .dc
.dd:    call dynbits                    ; -> [dbits]
.dc:    mov eax,[dbits]
        cmp eax,[fbits]
        jbe .d1
        mov eax,[fbits]
.d1:    mov ebx,[chn]
        add ebx,5
        shl ebx,3                       ; a stored block costs chn+5 bytes
        cmp eax,ebx
        jb .emit
        jmp .stored
.emit:  mov eax,[saveacc]               ; the scratch stream starts where the archive stream is
        mov [sacc],eax
        mov eax,[savenbits]
        mov [snbits],eax
        mov dword [spos],0
        mov eax,[dbits]
        cmp eax,[fbits]
        jbe .ed
        call emitfixed
        jmp .cm
.ed:    call emitdyn
.cm:    call commitfix
        jc .bad
        jmp .fin
.stored:
        mov eax,[saveacc]               ; the archive stream as it was before this chunk
        mov [wacc],eax
        mov eax,[savenbits]
        mov [wnbits],eax
        xor eax,eax                     ; BFINAL = 0
        mov cl,1
        call rbitv
        jc .bad
        xor eax,eax                     ; BTYPE = 00, stored
        mov cl,2
        call rbitv
        jc .bad
        cmp dword [wnbits],0
        je .al
        mov eax,[wacc]                  ; skip to the byte boundary the stored block starts at
        call rbyte
        jc .bad
        mov dword [wacc],0
        mov dword [wnbits],0
.al:    mov ax,[chn]                    ; LEN
        call rbyte
        jc .bad
        mov ax,[chn]
        shr ax,8
        call rbyte
        jc .bad
        mov ax,[chn]                    ; NLEN
        not ax
        call rbyte
        jc .bad
        mov ax,[chn]
        not ax
        shr ax,8
        call rbyte
        jc .bad
        call rbuf                       ; the LEN/NLEN bytes went through abit
        jc .bad
        mov cx,[chn]
        mov dx,iobuf
        call zipwr
        jc .bad
.fin:   mov eax,[chn]
        add [apos],eax
        clc
        ret
.bad:   stc
        ret

; Parse the [chn] bytes at iobuf into tokens: tlen[k] (0 = a literal, else the match length) and
; tdist[k] (the literal byte, or the match distance), [ntok] tokens. Counts flit[]/fdist[] and
; inserts every position into the window and hash tables. FS = [bufseg]. Keeps DS, ES.
parsechunk:
        mov ax,[bufseg]
        mov fs,ax
        push es
        push ds
        mov ax,ds
        mov es,ax
        mov edi,flit
        mov ecx,288+32
        xor eax,eax
        rep stosw                       ; the frequencies of this chunk only
        pop ds
        pop es
        mov esi,0                       ; i, index in iobuf
        mov dword [ktok],0              ; k, token index (findmatch clobbers EDI)
.l:     cmp esi,[chn]
        jae .eob
        lea eax,[esi+2]
        cmp eax,[chn]
        jae .lit
        mov eax,[apos]
        add eax,esi
        mov ebp,eax                     ; p
        call findmatch
        cmp word [blen],3
        jb .lit
        lea eax,[esi+3]
        cmp eax,[chn]
        jae .emitm
        mov ax,[blen]                   ; one-step lazy: a longer match at p+1 wins
        mov [svlen],ax
        mov ax,[bdist]
        mov [svdist],ax
        mov eax,[apos]
        add eax,esi
        inc eax
        mov ebp,eax
        call findmatch
        mov ax,[blen]
        cmp ax,[svlen]
        ja .lit
        mov ax,[svlen]
        mov [blen],ax
        mov ax,[svdist]
        mov [bdist],ax
.emitm: mov eax,[blen]
        mov ecx,[ktok]
        mov [tlen+ecx*2],ax
        mov eax,[bdist]
        mov [tdist+ecx*2],ax
        movzx ebx,word [blen]
        call lentok
        inc word [flit+eax*2]
        movzx ebx,word [bdist]
        call disttok
        inc word [fdist+eax*2]
        mov eax,[apos]
        add eax,esi
        movzx ecx,word [blen]
.ins:   push eax
        push ecx
        call insertq
        pop ecx
        pop eax
        inc eax
        loop .ins
        movzx eax,word [blen]
        add esi,eax
        inc dword [ktok]
        jmp .l
.lit:   movzx eax,byte [iobuf+esi]
        mov ecx,[ktok]
        mov word [tlen+ecx*2],0
        mov [tdist+ecx*2],ax
        inc word [flit+eax*2]
        mov eax,[apos]
        add eax,esi
        call insertq
        inc esi
        inc dword [ktok]
        jmp .l
.eob:   mov eax,[ktok]
        mov [ntok],eax
        inc word [flit+256*2]           ; the end-of-block symbol
        ret

; EBP = p (absolute offset), ESI = i in iobuf, FS = [bufseg]. Out: [blen] (0 when no match of 3
; or more bytes), [bdist]. The candidate distances come from the hash chains as window indexes;
; every candidate is verified byte for byte against the window and the chunk, so a stale chain
; entry can only cost a match, never produce a wrong one.
; Clobbers EAX, EBX, ECX, EDX, EDI.
findmatch:
        mov word [blen],0
        mov word [bdist],0
        movzx eax,byte [iobuf+esi]
        shl eax,10
        movzx ebx,byte [iobuf+esi+1]
        shl ebx,5
        xor eax,ebx
        movzx ebx,byte [iobuf+esi+2]
        xor eax,ebx
        and eax,HSIZE-1
        mov edi,eax                     ; h
        movzx edx,word [fs:AHEAD+edi*2]
        mov [ccand],dx
        xor ecx,ecx
.chain: cmp word [ccand],0xFFFF
        je .done
        cmp cx,MAXCHAIN
        jae .done
        movzx edx,word [ccand]
        mov eax,ebp
        sub eax,edx
        and eax,WSIZE-1
        jnz .d1
        mov eax,WSIZE                   ; the slot of p still holds the byte WSIZE back
.d1:    mov [cdist],eax
        cmp eax,ebp
        ja .nx                          ; before the start of the file
        mov ebx,[chn]
        sub ebx,esi
        cmp ebx,258
        jbe .ml
        mov ebx,258
.ml:    cmp ebx,3
        jb .nx
        xor eax,eax                     ; len
.cmp:   cmp eax,ebx
        jae .ce
        movzx ecx,byte [iobuf+esi+eax]  ; the byte at p+len
        push eax
        push ecx
        mov eax,ebp
        sub eax,[cdist]
        add eax,[esp+4]                 ; the byte at p-d+len
        cmp eax,[apos]
        jae .qc
        and eax,WSIZE-1
        movzx ecx,byte [fs:eax+AWIN]
        jmp .qd
.qc:    sub eax,[apos]
        movzx ecx,byte [iobuf+eax]
.qd:    pop edx
        pop eax
        cmp cl,dl
        jne .ce
        inc eax
        jmp .cmp
.ce:    cmp eax,3
        jb .nx
        mov edx,eax                     ; len
        cmp ax,[blen]
        jbe .ck
        mov [blen],ax
        mov eax,[cdist]
        mov [bdist],ax
.ck:    cmp edx,ebx                     ; len reached the maximum: stop the chain
        jae .done
        jmp .nx
.nx:    movzx edx,word [ccand]
        movzx edx,word [fs:APREV+edx*2]
        mov [ccand],dx
        inc ecx
        jmp .chain
.done:  ret

; EAX = absolute offset q: insert its 3-byte hash into the tables when 3 bytes are in reach,
; and put the byte into the window when it is still only in the chunk. Keeps ESI, EBP, EDI.
insertq:
        push ebx
        push ecx
        push edx
        mov [qsave],eax
        mov ebx,[apos]
        add ebx,[chn]
        cmp eax,ebx
        jae .now                        ; q+2 past the chunk: no hash
        call getbyte
        movzx ebx,al
        shl ebx,10
        mov eax,[qsave]
        inc eax
        call getbyte
        movzx ecx,al
        shl ecx,5
        xor ebx,ecx
        mov eax,[qsave]
        add eax,2
        call getbyte
        movzx edx,al
        xor ebx,edx
        and ebx,HSIZE-1                 ; h
        mov eax,[qsave]
        mov ecx,eax
        and ecx,WSIZE-1                 ; r
        movzx edx,word [fs:AHEAD+ebx*2]
        mov [fs:APREV+ecx*2],dx
        mov [fs:AHEAD+ebx*2],cx
.now:   mov eax,[qsave]
        cmp eax,[apos]
        jb .d
        mov ecx,eax
        and eax,WSIZE-1
        sub ecx,[apos]
        movzx edx,byte [iobuf+ecx]
        mov [fs:eax+AWIN],dl
.d:     pop edx
        pop ecx
        pop ebx
        ret

; EAX = absolute offset q -> AL = the byte there: the window (FS) when q < [apos], the current
; chunk (iobuf) otherwise. Keeps EBX, ECX, EDX, ESI, EDI, EBP.
getbyte:
        cmp eax,[apos]
        jae .cur
        and eax,WSIZE-1
        mov al,[fs:eax+AWIN]
        ret
.cur:   sub eax,[apos]
        mov al,[iobuf+eax]
        ret

; AL = byte: emit it as a fixed-Huffman literal (RFC 1951 3.2.6).
emitlit: cmp al,143
        ja .hi
        movzx eax,al
        add eax,0x30
        mov cl,8
        jmp shut
.hi:    movzx eax,al
        add eax,0x190-144
        mov cl,9
        jmp shut

; BX = match length 3..258 -> EAX = length symbol 257..285, CL = extra bit count, EDX = extra value.
lentok: cmp bx,258
        jne .s
        mov eax,285
        xor ecx,ecx
        xor edx,edx
        ret
.s:     mov cx,27                       ; symbol 285 (length 258) is handled above
.l:     movzx eax,byte [lenbase+ecx]
        cmp bx,ax
        jae .f
        dec ecx
        jns .l
        ret
.f:     mov eax,257
        add eax,ecx
        movzx edx,byte [lenbase+ecx]
        sub bx,dx
        movzx ecx,byte [lenextra+ecx]
        movzx edx,bx
        ret

; BX = distance 1..32768 -> EAX = distance code 0..29, CL = extra bit count, EDX = extra value.
disttok:
        mov cx,29
.l:     movzx eax,word [distbase+ecx*2]
        cmp bx,ax
        jae .f
        dec ecx
        jns .l
        ret
.f:     mov eax,ecx
        movzx edx,word [distbase+ecx*2]
        sub bx,dx
        movzx ecx,byte [distextra+ecx]
        movzx edx,bx
        ret

; BX = match length 3..258: emit it as a fixed-Huffman length symbol (RFC 1951 3.2.5/3.2.6).
emitlen:
        call lentok                     ; EAX symbol, CL extra bits, EDX extra value
        push edx
        push ecx
        cmp eax,279
        ja .h8
        sub eax,256                     ; 7-bit code
        mov cl,7
        jmp .g
.h8:    add eax,0xC0-280                ; 8-bit code
        mov cl,8
.g:     call shut
        pop ecx
        pop eax
        call sbitv
        ret

; BX = distance 1..32768: emit it as a fixed-Huffman distance code.
emitdist:
        call disttok                    ; EAX code, CL extra bits, EDX extra value
        push edx
        push ecx
        mov cl,5                        ; the code is its own 5-bit Huffman code
        call shut
        pop ecx
        pop eax
        call sbitv
        ret

; Emit the tokens as a non-final fixed-Huffman block into the scratch stream.
emitfixed:
        xor eax,eax                     ; BFINAL = 0
        mov cl,1
        call sbitv
        mov eax,1                       ; BTYPE = 01
        mov cl,2
        call sbitv
        mov esi,0
.l:     cmp esi,[ntok]
        jae .eob
        movzx eax,word [tlen+esi*2]
        test eax,eax
        jnz .m
        movzx eax,word [tdist+esi*2]
        call emitlit
        jmp .n
.m:     movzx ebx,word [tlen+esi*2]
        call emitlen
        movzx ebx,word [tdist+esi*2]
        call emitdist
.n:     inc esi
        jmp .l
.eob:   xor eax,eax                     ; end of block
        mov cl,7
        call shut
        ret

; Emit the tokens as a non-final dynamic-Huffman block into the scratch stream (RFC 1951 3.2.7).
; Needs the codes from builddyn: llit/clit, ldist/cdistc, cll/ccode, rlsym/rlx/rlb, nlit/ndist/ncl/nrl.
emitdyn:
        xor eax,eax                     ; BFINAL = 0
        mov cl,1
        call sbitv
        mov eax,2                       ; BTYPE = 10
        mov cl,2
        call sbitv
        mov eax,[nlit]
        sub eax,257
        mov cl,5
        call sbitv                      ; HLIT
        mov eax,[ndist]
        dec eax
        mov cl,5
        call sbitv                      ; HDIST
        mov eax,[ncl]
        sub eax,4
        mov cl,4
        call sbitv                      ; HCLEN
        mov esi,0                       ; the code-length code lengths, in the permuted order
.cl:    cmp esi,[ncl]
        jae .seq
        movzx eax,byte [clorder+esi]
        movzx eax,byte [cll+eax]
        mov cl,3
        call sbitv
        inc esi
        jmp .cl
.seq:   mov esi,0                       ; the RLE-coded lit/len and dist code lengths
.rl:    cmp esi,[nrl]
        jae .tok
        movzx eax,byte [rlsym+esi]
        movzx ecx,byte [cll+eax]
        push esi
        movzx eax,word [ccode+eax*2]
        call shut
        pop esi
        movzx ecx,byte [rlb+esi]
        jcxz .nx
        movzx eax,word [rlx+esi*2]
        call sbitv
.nx:    inc esi
        jmp .rl
.tok:   mov esi,0
.tl:    cmp esi,[ntok]
        jae .eob
        movzx eax,word [tlen+esi*2]
        test eax,eax
        jnz .m
        movzx eax,word [tdist+esi*2]    ; a literal
        push esi
        movzx ecx,byte [llit+eax]
        movzx eax,word [clit+eax*2]
        call shut
        pop esi
        jmp .n
.m:     movzx ebx,word [tlen+esi*2]
        call lentok                     ; EAX symbol, CL extra bits, EDX extra value
        push edx
        push ecx
        push eax
        movzx ecx,byte [llit+eax]
        movzx eax,word [clit+eax*2]
        call shut
        pop eax
        pop ecx
        pop eax
        call sbitv                      ; the length's extra bits
        movzx ebx,word [tdist+esi*2]
        call disttok
        push edx
        push ecx
        push eax
        movzx ecx,byte [ldist+eax]
        movzx eax,word [cdistc+eax*2]
        call shut
        pop eax
        pop ecx
        pop eax
        call sbitv                      ; the distance's extra bits
.n:     inc esi
        jmp .tl
.eob:   mov eax,256                     ; end of block
        movzx ecx,byte [llit+256]
        movzx eax,word [clit+256*2]
        call shut
        ret

; The bits of the fixed-Huffman block over the tokens -> [fbits] (dword).
fixbits:
        mov dword [fbits],10            ; block header + end of block
        mov esi,0
.l:     cmp esi,[ntok]
        jae .d
        movzx eax,word [tlen+esi*2]
        test eax,eax
        jnz .m
        movzx eax,word [tdist+esi*2]
        cmp eax,143
        jbe .f8
        add dword [fbits],9
        jmp .n
.f8:    add dword [fbits],8
        jmp .n
.m:     movzx ebx,word [tlen+esi*2]
        call lentok
        cmp eax,279
        ja .h8
        add dword [fbits],7
        jmp .hx
.h8:    add dword [fbits],8
.hx:    movzx ecx,cl
        add [fbits],ecx
        movzx ebx,word [tdist+esi*2]
        call disttok
        add dword [fbits],5
        movzx ecx,cl
        add [fbits],ecx
.n:     inc esi
        jmp .l
.d:     ret

; The bits of the dynamic-Huffman block over the tokens -> [dbits] (dword).
dynbits:
        mov dword [dbits],17            ; block header + HLIT/HDIST/HCLEN
        mov eax,[ncl]
        imul eax,eax,3
        add [dbits],eax
        mov esi,0
.r:     cmp esi,[nrl]
        jae .t
        movzx eax,byte [rlsym+esi]
        movzx ecx,byte [cll+eax]
        add [dbits],ecx
        movzx ecx,byte [rlb+esi]
        add [dbits],ecx
        inc esi
        jmp .r
.t:     mov esi,0
.l:     cmp esi,[ntok]
        jae .d
        movzx eax,word [tlen+esi*2]
        test eax,eax
        jnz .m
        movzx eax,word [tdist+esi*2]
        movzx ecx,byte [llit+eax]
        add [dbits],ecx
        jmp .n
.m:     movzx ebx,word [tlen+esi*2]
        call lentok
        movzx ecx,byte [llit+eax]
        add [dbits],ecx
        movzx ecx,cl
        add [dbits],ecx
        movzx ebx,word [tdist+esi*2]
        call disttok
        movzx ecx,byte [ldist+eax]
        add [dbits],ecx
        movzx ecx,cl
        add [dbits],ecx
.n:     inc esi
        jmp .l
.d:     movzx eax,byte [llit+256]
        add [dbits],eax
        ret

; Build the dynamic Huffman codes for the parsed chunk: llit/clit (288), ldist/cdistc (32),
; cll/ccode (19), the RLE sequence rlsym/rlx/rlb, and nlit/ndist/ncl/nrl. CF=1 when a code length
; would pass its limit (15, 15, 7): the caller then emits a fixed block instead.
builddyn:
        mov esi,flit
        mov ecx,288
        mov edi,llit
        call huffman
        jc .bad
        mov esi,fdist                    ; no distance used: one dummy code
        mov ecx,30
        xor eax,eax
.ds:    add ax,[esi]
        add esi,2
        loop .ds
        test eax,eax
        jnz .dnz
        mov word [fdist],1
.dnz:   mov esi,fdist
        mov ecx,30                       ; distance codes 0..29 (30/31 never occur)
        mov edi,ldist
        call huffman
        jc .bad
        mov esi,llit                    ; canonical codes (RFC 1951 3.2.2)
        mov ecx,288
        mov edi,clit
        call canon
        mov esi,ldist
        mov ecx,30
        mov edi,cdistc
        call canon
        mov dword [nlit],257            ; trim trailing zero lengths
        mov ecx,287
.nl:    cmp ecx,256
        jbe .nd
        cmp byte [llit+ecx],0
        jne .nlf
        dec ecx
        jmp .nl
.nlf:   inc ecx
        mov [nlit],ecx
.nd:    mov dword [ndist],1
        mov ecx,29
.ndl:   cmp ecx,0
        jl .ndd                         ; signed: ecx wrapped past 0 when all lengths are 0
        cmp byte [ldist+ecx],0
        jne .ndf
        dec ecx
        jmp .ndl
.ndf:   inc ecx
        mov [ndist],ecx
.ndd:   call rle                        ; the lit/len + dist lengths, RLE-coded
        mov esi,fcl
        mov ecx,19
        mov edi,cll
        call huffman
        jc .bad
        mov esi,cll
        mov ecx,19
        mov edi,ccode
        call canon
        mov dword [ncl],19              ; trim in the permuted order, at least 4
.nc:    cmp dword [ncl],4
        jbe .ok
        mov eax,[ncl]
        dec eax
        movzx eax,byte [clorder+eax]
        cmp byte [cll+eax],0
        jne .ok
        dec dword [ncl]
        jmp .nc
.ok:    clc
        ret
.bad:   stc
        ret

; huffman: ESI = frequency array (words), ECX = symbol count, EDI = out lengths (bytes).
; Builds the Huffman code lengths. CF=1 when the depth would pass 15. Uses the sym/parent/nfreq/
; depth arrays. Clobbers EAX, EBX, ECX, EDX, ESI, EDI, EBP.
huffman:
        mov [farr],esi
        mov [outarr],edi
        mov [inn],ecx
        push edi
        push ecx
        xor eax,eax
        rep stosb                       ; clear the out lengths
        pop ecx
        pop edi
        mov dword [nsym],0              ; collect the used symbols, sorted by frequency
        xor ebx,ebx
.col:   cmp ebx,[inn]
        jae .mrg
        cmp word [esi+ebx*2],0
        je .cn
        movzx eax,word [esi+ebx*2]
        mov edx,[nsym]
.ins:   test edx,edx
        jz .pl
        movzx ebp,word [sym+edx*2-2]
        cmp word [esi+ebp*2],ax
        jbe .pl
        movzx ecx,word [sym+edx*2-2]
        mov [sym+edx*2],cx
        dec edx
        jmp .ins
.pl:    mov [sym+edx*2],bx
        inc dword [nsym]
.cn:    inc ebx
        jmp .col
.mrg:   cmp dword [nsym],1
        jbe .one
        mov edi,parent                  ; no parent yet
        mov ecx,600
        mov ax,0xFFFF
        rep stosw
        mov eax,[nsym]
        mov [head2],eax
        mov [nextnode],eax
        mov dword [head1],0
.loop:  mov eax,[nsym]                  ; two queues: the symbols, then the merged nodes
        sub eax,[head1]
        mov ebx,[nextnode]
        sub ebx,[head2]
        add eax,ebx
        cmp eax,1
        jbe .depths
        call pickmin
        mov [n1],eax
        call pickmin
        mov [n2],eax
        mov eax,[nextnode]
        mov ebx,[n1]
        mov [parent+ebx*2],ax
        mov ebx,[n2]
        mov [parent+ebx*2],ax
        mov ebx,[n1]
        call nodefreq
        mov edx,eax
        mov ebx,[n2]
        call nodefreq
        add eax,edx
        mov ebx,[nextnode]
        mov [nfreq+ebx*2],ax
        inc dword [nextnode]
        jmp .loop
.one:   cmp dword [nsym],0
        je .bad
        mov eax,[outarr]                ; a single symbol gets length 1
        movzx ebx,word [sym]
        mov byte [eax+ebx],1
        clc
        ret
.depths:
        mov edi,depth
        mov ecx,600
        xor eax,eax
        rep stosb
        mov eax,[nextnode]              ; a parent always has a higher index than its children
        dec eax
.dl:    test eax,eax
        js .dfin
        movzx ebx,word [parent+eax*2]
        cmp ebx,0xFFFF
        je .dz
        movzx ecx,byte [depth+ebx]
        inc ecx
        mov [depth+eax],cl
        jmp .dn
.dz:    mov byte [depth+eax],0
.dn:    dec eax
        jmp .dl
.dfin:  mov dword [maxd],0
        xor ebx,ebx
.cp:    cmp ebx,[nsym]
        jae .chk
        movzx eax,word [sym+ebx*2]      ; the symbol value
        movzx ecx,byte [depth+ebx]      ; its depth; EBX is the node id
        mov edx,[outarr]
        mov [edx+eax],cl
        cmp ecx,[maxd]
        jbe .nx
        mov [maxd],ecx
.nx:    inc ebx
        jmp .cp
.chk:   cmp dword [maxd],15
        ja .bad
        clc
        ret
.bad:   stc
        ret

; The smaller front of the two merge queues -> EAX = its node id, the head advances.
; Tie goes to the symbols' queue. Needs [farr], [nsym], [head1], [head2], [nextnode].
pickmin:
        mov esi,[farr]
        mov eax,[head1]
        cmp eax,[nsym]
        jae .q2
        movzx ebx,word [sym+eax*2]
        movzx ecx,word [esi+ebx*2]
        mov edx,[head2]
        cmp edx,[nextnode]
        jae .take1
        cmp word [nfreq+edx*2],cx
        jb .take2
.take1: inc dword [head1]              ; EAX already holds the queue index: the node id
        ret
.take2: mov eax,[head2]
        inc dword [head2]
        ret
.q2:    mov eax,[head2]
        inc dword [head2]
        ret

; EBX = node id -> EAX = its frequency (a symbol's, or a merged node's).
nodefreq:
        mov esi,[farr]
        cmp ebx,[nsym]
        jae .n
        movzx ebx,word [sym+ebx*2]     ; node id -> the symbol value
        movzx eax,word [esi+ebx*2]
        ret
.n:    movzx eax,word [nfreq+ebx*2]
        ret

; canon: ESI = lengths (bytes), ECX = count, EDI = out codes (words). The canonical Huffman
; codes of RFC 1951 3.2.2. Uses blc/ncd. Clobbers EAX, EBX, ECX, EDX, EDI.
canon:  mov [inn],ecx
        mov [outc],edi
        push esi
        mov edi,blc
        mov ecx,16
        xor eax,eax
        rep stosw
        pop esi
        xor ebx,ebx
.c1:    cmp ebx,[inn]
        jae .c2
        movzx eax,byte [esi+ebx]
        test eax,eax
        jz .c1n
        inc word [blc+eax*2]
.c1n:   inc ebx
        jmp .c1
.c2:    mov dword [ncode],0
        mov ecx,1
.c3:    cmp ecx,16
        jae .c4
        mov eax,[ncode]
        movzx ebx,word [blc+ecx*2-2]
        add eax,ebx
        shl eax,1
        mov [ncode],eax
        mov [ncd+ecx*2],ax
        inc ecx
        jmp .c3
.c4:    xor ebx,ebx
.c5:    cmp ebx,[inn]
        jae .cd
        movzx eax,byte [esi+ebx]
        test eax,eax
        jz .c5n
        movzx ecx,byte [esi+ebx]
        movzx eax,word [ncd+ecx*2]
        mov edx,[outc]
        mov [edx+ebx*2],ax
        inc word [ncd+ecx*2]
.c5n:   inc ebx
        jmp .c5
.cd:    ret

; RLE-code the lit/len lengths llit[0..nlit-1] plus the dist lengths ldist[0..ndist-1] into
; rlsym/rlx/rlb ([nrl] of them), counting fcl[19]. Uses seq. Clobbers EAX, EBX, ECX, EDX, ESI, EDI.
rle:    mov edi,seq
        mov ecx,[nlit]
        mov esi,0
.s1:    cmp esi,ecx
        jae .s2
        mov al,[llit+esi]
        stosb
        inc esi
        jmp .s1
.s2:    mov ecx,[ndist]
        xor esi,esi
.s3:    cmp esi,ecx
        jae .s4
        mov al,[ldist+esi]
        stosb
        inc esi
        jmp .s3
.s4:    sub edi,seq
        mov [seqlen],edi
        push edi
        mov edi,fcl
        mov ecx,19
        xor eax,eax
        rep stosw
        pop edi
        xor esi,esi                     ; i
        xor edi,edi                     ; nrl
.en:    cmp esi,[seqlen]
        jae .ed
        movzx eax,byte [seq+esi]        ; the value
        mov ebx,esi
        inc ebx
.rl:    cmp ebx,[seqlen]
        jae .rd
        movzx ecx,byte [seq+ebx]
        cmp cl,al
        jne .rd
        inc ebx
        jmp .rl
.rd:    sub ebx,esi
        mov [rem],ebx                   ; the run
        test eax,eax
        jz .z
        push eax                        ; a nonzero value: emit it once
        xor ebx,ebx
        xor ecx,ecx
        call rlemit
        pop eax
        inc esi
        dec dword [rem]
        jmp .rp
.z:     cmp dword [rem],11              ; zeros: 18 (11-138), 17 (3-10), then single 0
        jb .z2
        mov ecx,[rem]
        cmp ecx,138
        jbe .z1
        mov ecx,138
.z1:    push ecx
        mov eax,18
        lea ebx,[ecx-11]
        mov cl,7
        call rlemit
        pop ecx
        sub [rem],ecx
        add esi,ecx
        jmp .en
.z2:    cmp dword [rem],3
        jb .z3
        mov ecx,[rem]
        push ecx
        mov eax,17
        lea ebx,[ecx-3]
        mov cl,3
        call rlemit
        pop ecx
        sub [rem],ecx
        add esi,ecx
        jmp .en
.z3:    push eax
        mov eax,0
        xor ebx,ebx
        xor ecx,ecx
        call rlemit
        pop eax
        inc esi
        jmp .en
.rp:    cmp dword [rem],3               ; repeats of a nonzero value: 16 (3-6), then singles
        jb .rs
        mov ecx,[rem]
        cmp ecx,6
        jbe .r1
        mov ecx,6
.r1:    push eax
        push ecx
        mov eax,16
        lea ebx,[ecx-3]
        mov cl,2
        call rlemit
        pop ecx
        pop eax
        sub [rem],ecx
        add esi,ecx
        jmp .rp
.rs:    cmp dword [rem],0
        je .en
        push eax
        xor ebx,ebx
        xor ecx,ecx
        call rlemit
        pop eax
        inc esi
        dec dword [rem]
        jmp .rs
.ed:   mov [nrl],edi
        ret

; AL = code-length symbol 0..18, BX = extra value, CL = extra bit count: append to the RLE arrays.
rlemit: movzx edx,al
        mov [rlsym+edi],al
        mov [rlx+edi*2],bx
        mov [rlb+edi],cl
        inc edi
        inc word [fcl+edx*2]
        ret

; EAX = value, CL = bit count: append the value's low bits, LSB first, to the scratch stream.
; Keeps all registers except flags.
sbitv:  push eax
        push ecx
        push edx
        movzx edx,cl
        mov ecx,[snbits]
        shl eax,cl
        or [sacc],eax
        add [snbits],edx
        call sflush
        pop edx
        pop ecx
        pop eax
        ret

; Whole bytes out of sacc into ascr while snbits >= 8. Keeps registers.
sflush: push eax
        push ecx
.l:     mov ecx,[snbits]
        cmp ecx,8
        jb .d
        mov eax,[sacc]
        movzx edx,al
        mov ecx,[spos]
        mov [ascr+ecx],dl
        inc ecx
        mov [spos],ecx
        shr eax,8
        mov [sacc],eax
        sub dword [snbits],8
        jmp .l
.d:     pop ecx
        pop eax
        ret

; EAX = Huffman code, CL = its bit count: append the code's bits, MSB first, to the scratch
; stream (RFC 1951 3.1.1). Keeps EAX, ECX, EDX.
shut:   push eax
        push ecx
        push edx
        movzx ecx,cl
.l:     jcxz .d
        dec ecx
        mov edx,eax
        shr edx,cl
        and edx,1
        push eax
        mov eax,edx
        push ecx
        mov cl,1
        call sbitv
        pop ecx
        pop eax
        jmp .l
.d:     pop edx
        pop ecx
        pop eax
        ret

; EAX = value, CL = bit count: append the value's low bits, LSB first, to the archive stream's
; bit accumulator, flushing whole bytes into abit. CF=1 on a write error. Keeps EAX, ECX, EDX.
rbitv:  push eax
        push ecx
        push edx
        movzx edx,cl
        mov ecx,[wnbits]
        shl eax,cl
        or [wacc],eax
        add [wnbits],edx
.l:     cmp dword [wnbits],8
        jb .d
        mov eax,[wacc]
        call rbyte
        jc .e
        shr dword [wacc],8
        sub dword [wnbits],8
        jmp .l
.d:     pop edx
        pop ecx
        pop eax
        clc
        ret
.e:     pop edx
        pop ecx
        pop eax
        stc
        ret

; Empty abit to the archive, so that a direct zipwr of another buffer keeps the byte order.
; CF=1 on a write error.
rbuf:   cmp dword [wpos],0
        je .ok
        mov cx,[wpos]
        mov dx,abit
        call zipwr
        mov dword [wpos],0
        jc .bad
.ok:    clc
        ret
.bad:   stc
        ret

; Move the scratch bit stream (spos bytes at ascr plus the bits pending in sacc/snbits) onto the
; archive stream: the bytes go out, the pending bits become the archive stream's. CF=1 on error.
commitfix:
        call rbuf
        jc .bad
        mov cx,[spos]
        jcxz .a
        mov dx,ascr
        call zipwr
        jc .bad
.a:     mov eax,[sacc]
        mov [wacc],eax
        mov eax,[snbits]
        mov [wnbits],eax
        clc
        ret
.bad:   stc
        ret

; AL -> abit[wpos++]; a full buffer goes to the archive. CF=1 on a write error.
; Keeps EBX, ECX, EDX, ESI, EDI, EBP.
rbyte:  push ecx
        push edx
        movzx edx,al
        mov ecx,[wpos]
        mov [abit+ecx],dl
        inc ecx
        mov [wpos],ecx
        cmp ecx,ABITSZ
        jb .ok
        mov cx,ABITSZ
        mov dx,abit
        call zipwr
        mov dword [wpos],0
        jc .e
.ok:    pop edx
        pop ecx
        clc
        ret
.e:     pop edx
        pop ecx
        stc
        ret

; Pad the archive bit stream to a byte and empty abit. CF=1 on a write error.
rfinal: cmp dword [wnbits],0
        je .fl
        mov eax,[wacc]
        call rbyte
        jc .bad
        mov dword [wacc],0
        mov dword [wnbits],0
.fl:    call rbuf
        jc .bad
.ok:    clc
        ret
.bad:   stc
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
s_use   db 'REPORT ',VERSION,' - pack a RUNALL into one deflate ZIP',13,10
        db '  REPORT       *.log *.dbg s3regs.txt vgalog*.bin s3regs3.txt',13,10
        db '  REPORT /H    this help',13,10
        db 'Name: runall-<part>.zip, created under that name (a rename is not used).',13,10
        db 'If the DOS cannot create a long name: <part>.ZIP (86C775.ZIP).',13,10
        db 'No part: RUNALL.ZIP. Missing files are left out.',13,10
        db 'Deflate ZIP (method 8, RFC 1951), Info-ZIP unzip reads it; each chunk goes in',13,10
        db 'as a dynamic-Huffman block when that is smallest, else fixed, else stored.',13,10
        db 'No memory for the compressor: stored ZIP (method 0).',13,10,'$'
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
compok  db 0
ziph    dw 0xFFFF
srcb    dw 0xFFFF
outn    dw 0
zn      dw 0
zver    dw 10
zmet    dw 0
bufseg  dw 0
zippos  dd 0
entofs  dd 0
cdofs   dd 0
cdsz    dd 0
datastart dd 0
fcrc    dd 0
fsize   dd 0
fcsz   dd 0
ftime   dw 0
fdate   dw 0
fattr   dw 0
curname dw 0
apos    dd 0
chn     dd 0
blen    dw 0
bdist   dw 0
ccand   dw 0
cdist   dd 0
qsave   dd 0
saveacc dd 0
savenbits dd 0
sacc    dd 0
snbits  dd 0
spos    dd 0
wacc    dd 0
wnbits  dd 0
wpos    dd 0
ntok    dd 0
ktok    dd 0
dynok   db 0
svlen   dw 0
svdist  dw 0
fbits   dd 0
dbits   dd 0
nlit    dd 0
ndist   dd 0
ncl     dd 0
nrl     dd 0
seqlen  dd 0
rem     dd 0
farr    dd 0
outarr  dd 0
outc    dd 0
inarr   dd 0
inn     dd 0
nsym    dd 0
head1   dd 0
head2   dd 0
nextnode dd 0
n1      dd 0
n2      dd 0
maxd    dd 0
ncode   dd 0
lfnname db 40 dup(0)
sfnname db 16 dup(0)
nbuf    db 16 dup(0)
hdr     db 80 dup(0)
scratch db 16 dup(0)
dta     db 128 dup(0)
zents   times ZMAX*ZE_SIZ db 0
crctab  times 256 dd 0
iobuf   times BUFSZ db 0
ascr    times SCRSZ db 0
abit    times ABITSZ db 0
lenbase db 3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227
lenextra db 0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5
distbase dw 1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145, \
           8193,12289,16385,24577
distextra db 0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13
clorder db 16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15
tlen    times BUFSZ dw 0
tdist   times BUFSZ dw 0
flit    times 288 dw 0
fdist   times 32 dw 0
fcl     times 19 dw 0
llit    times 288 db 0
ldist   times 30 db 0
cll     times 19 db 0
clit    times 288 dw 0
cdistc  times 30 dw 0
ccode   times 19 dw 0
sym     times 288 dw 0
parent  times 600 dw 0
nfreq   times 600 dw 0
depth   times 600 db 0
seq     times 320 db 0
rlsym   times 320 db 0
rlx     times 320 dw 0
rlb     times 320 db 0
blc     times 16 dw 0
ncd     times 16 dw 0

%include "chip.inc"
