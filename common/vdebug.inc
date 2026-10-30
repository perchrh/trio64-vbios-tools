; vdebug.inc - /V debug log shared by VSHOW, S3TEST and S3COMPAT (386+, NASM)
;
; Purpose
;   With /V a tool writes a second file, <TOOL>.DBG in the current directory, with raw information
;   about how the code ran on the real card: the environment, every INT 10h call with its registers
;   in and out and its duration, register dumps, 4F00/4F01 blocks, per-frame timer counts and memory
;   mismatches. The normal output (stdout) is not changed by /V.
;   The file is written and committed (INT 21h AH=68h) at every test start and before every INT 10h
;   call that sets a mode or calls VBE (except 4F05), so after a freeze its last lines show the call
;   that hung.
;
; Line format (one record per line, fields separated by spaces, all numbers hex unless noted)
;   D:ENV ...                         environment, once at the start
;   D:PCI ...                         PCI configuration of the display controller
;   D:HEX tag oooo: xx xx ...          16 bytes of a memory block (tag says which block)
;   D:TEST name                       a test starts (S3COMPAT, S3TEST) or a mode is shown (VSHOW)
;   D:RES text                        the normal result line(s) of the test, copied
;   D:I10> AX= BX= CX= DX= SI= DI= BP= DS= ES= FL=    INT 10h call, before (I10>2 = nested call)
;   D:I10< AX= BX= CX= DX= SI= DI= BP= DS= ES= FL= T= after; T = duration in PIT counts (decimal,
;                                     1 count = 0.838 us)
;   D:REG MISC= FEAT=, SR00:, GR00:, CRxx:, AR00:, DAC:, BDA49:, BDA84:   register dump
;   D:FRM n=  c c c ...               PIT counts per frame of a refresh measurement (decimal)
;   D:MEM a= exp= got=                a memory mismatch (address, expected, read)
;   D:END lost=                       end of the log; lost = bytes dropped because the buffer was full
;
; Tool contract
;   vinit   AX = a free 64 KB segment for the buffer, DS:DX -> ASCIIZ file name. Creates the file,
;           hooks INT 10h, sets PIT channel 0 to mode 2 (same 18.2 Hz tick, readable counter) and
;           writes the environment. On failure it prints a note on stderr and /V stays off. The hook
;           passes EAX-EDI to the BIOS and back to the caller with bits 31-16 unchanged by the logging
;           (before 30 October 2026 it handed back the timer reading in EAX bits 31-16).
;   vdone   before every program exit (no-op when /V is off): unhooks INT 10h, PIT back to mode 3,
;           writes D:END, closes the file.
;   All other routines do nothing while [vflag] = 0, keep all registers (32-bit too) and work with any
;   DS/ES. Set [vquiet] = 1 around timed code that calls INT 10h (it then passes calls through).
;   INT 10h calls made while DOS is active (InDOS set, for example console output) are not logged.

; The VS macro is in vdebug.mac, which the tool includes near its top.

; ---------------------------------------------------------------- output primitives
vput:   ; AL -> buffer (drops and counts when full)
        push di
        push es
        mov es,[cs:vseg]
        mov di,[cs:vptr]
        cmp di,0xFFF0
        jae .lost
        mov [es:di],al
        inc word [cs:vptr]
        pop es
        pop di
        ret
.lost:  inc dword [cs:vlost]
        pop es
        pop di
        ret

vstr:   ; inline zero-terminated string after the call
        push bp
        mov bp,sp
        push si
        push ax
        mov si,[bp+2]
.l:     mov al,[cs:si]
        inc si
        or al,al
        jz .e
        cmp byte [cs:vflag],1
        jne .l
        call vput
        jmp .l
.e:     mov [bp+2],si
        pop ax
        pop si
        pop bp
        ret

vnl:    cmp byte [cs:vflag],1
        jne .r
        push ax
        mov al,13
        call vput
        mov al,10
        call vput
        pop ax
.r:     ret

vsp:    cmp byte [cs:vflag],1
        jne .r
        push ax
        mov al,' '
        call vput
        pop ax
.r:     ret

vhex8:  ; EAX
        ror eax,16
        call vhex4
        ror eax,16
vhex4:  ; AX
        xchg al,ah
        call vhex2
        xchg al,ah
vhex2:  ; AL
        cmp byte [cs:vflag],1
        jne .r
        push ax
        shr al,4
        call .n
        pop ax
        push ax
        and al,0x0F
        call .n
        pop ax
.r:     ret
.n:     add al,'0'
        cmp al,'9'
        jbe .o
        add al,7
.o:     jmp vput

vdec:   ; EAX unsigned, decimal
        cmp byte [cs:vflag],1
        jne .r
        pushad
        mov ebx,10
        xor cx,cx
.d:     xor edx,edx
        div ebx
        push dx
        inc cx
        or eax,eax
        jnz .d
.p:     pop ax
        add al,'0'
        call vput
        loop .p
        popad
.r:     ret

vstrz:  ; DS:SI zero-terminated text (for example a test name)
        cmp byte [cs:vflag],1
        jne .r
        push si
        push ax
.l:     lodsb
        or al,al
        jz .e
        call vput
        jmp .l
.e:     pop ax
        pop si
.r:     ret

vcopyc: ; as vcopy, but the first line continues a D:RES line the caller has started
        cmp byte [cs:vflag],1
        jne vcopy.r
        pushad
        mov bl,0
        jmp vcopy.go
vcopy:  ; DS:SI, CX bytes of normal output -> "D:RES" lines (line breaks start a new D:RES)
        cmp byte [cs:vflag],1
        jne .r
        pushad
        mov bl,1                        ; at line start
.go:    jcxz .t
.l:     lodsb
        cmp al,13
        je .n
        cmp al,10
        je .nl
        cmp bl,1
        jne .c
        VS 'D:RES '
        mov bl,0
.c:     call vput
        jmp .n
.nl:    cmp bl,1
        je .n
        call vnl
        mov bl,1
.n:     loop .l
.t:     cmp bl,1
        je .x
        call vnl
.x:     popad
.r:     ret

vblk:   ; DS:SI block, CX bytes; [cs:vtag] holds the 4-character tag naming the block
        cmp byte [cs:vflag],1
        jne .r
        jcxz .r
        pushad
        xor bx,bx                       ; offset
.ln:    VS 'D:HEX '
        mov eax,[cs:vtag]
        call vput
        shr eax,8
        call vput
        shr eax,8
        call vput
        shr eax,8
        call vput
        call vsp
        mov ax,bx
        call vhex4
        mov al,':'
        call vput
        mov dx,16
.b:     call vsp
        lodsb
        call vhex2
        inc bx
        dec cx
        jz .e
        dec dx
        jnz .b
        call vnl
        jmp .ln
.e:     call vnl
        popad
.r:     ret

vmem:   ; EAX address, EBX expected, ECX read
        cmp byte [cs:vflag],1
        jne .r
        VS 'D:MEM a='
        call vhex8
        VS ' exp='
        xchg eax,ebx
        call vhex8
        xchg eax,ebx
        VS ' got='
        xchg eax,ecx
        call vhex8
        xchg eax,ecx
        call vnl
.r:     ret

vframes:; [vfr] = [vfrn] cumulative PIT counts at successive retrace starts -> per-frame counts
        cmp byte [cs:vflag],1
        jne .r
        pushad
        VS 'D:FRM n='
        movzx eax,word [cs:vfrn]
        call vdec
        mov cx,[cs:vfrn]
        cmp cx,2
        jb .e
        dec cx
        mov si,vfr
.l:     call vsp
        mov eax,[cs:si+4]
        sub eax,[cs:si]
        call vdec
        add si,4
        loop .l
.e:     call vnl
        popad
.r:     ret

vmedian:; EAX = median of the per-frame PIT counts in [vfr]/[vfrn] (0 if fewer than 2 entries).
        ; Used for the refresh result too: one long interrupt (a disk cache writing) only stretches
        ; one frame, which moves the mean but not the median.
        push ebx
        push ecx
        push esi
        push edi
        xor eax,eax
        movzx ecx,word [cs:vfrn]
        cmp cx,2
        jb .x
        dec cx                          ; CX = number of periods
        xor si,si
.d:     mov eax,[cs:vfr+si+4]           ; periods into vsrt
        sub eax,[cs:vfr+si]
        mov [cs:vsrt+si],eax
        add si,4
        loop .d
        movzx ecx,word [cs:vfrn]
        dec cx
        mov si,4                        ; insertion sort
.o:     movzx ebx,cx
        shl bx,2
        cmp si,bx
        jae .s
        mov eax,[cs:vsrt+si]
        mov di,si
.i:     or di,di
        jz .p
        cmp [cs:vsrt+di-4],eax
        jbe .p
        mov ebx,[cs:vsrt+di-4]
        mov [cs:vsrt+di],ebx
        sub di,4
        jmp .i
.p:     mov [cs:vsrt+di],eax
        add si,4
        jmp .o
.s:     shr cx,1                        ; middle element
        shl cx,2
        mov si,cx
        mov eax,[cs:vsrt+si]
.x:     pop edi
        pop esi
        pop ecx
        pop ebx
        ret

vflush: ; write the buffer to the file and commit it (call only when DOS may be used)
        cmp byte [cs:vflag],1
        jne .r
        pusha
        push ds
        mov cx,[cs:vptr]
        jcxz .x
        mov bx,[cs:vhand]
        mov ds,[cs:vseg]
        xor dx,dx
        mov ah,0x40
        int 0x21
        mov word [cs:vptr],0
        mov bx,[cs:vhand]
        mov ah,0x68
        int 0x21
.x:     pop ds
        popa
.r:     ret

; ---------------------------------------------------------------- start and end
vinit:  ; AX = buffer segment, DS:DX -> ASCIIZ file name
        pusha
        push es
        mov [cs:vseg],ax
        mov word [cs:vptr],0
        xor cx,cx
        mov ah,0x3C
        int 0x21
        jc .fail
        mov [cs:vhand],ax
        mov ah,0x34                     ; InDOS flag
        int 0x21
        mov [cs:vindos],bx
        mov [cs:vindos+2],es
        mov byte [cs:vflag],1
        cli                             ; PIT channel 0 mode 2, full period
        mov al,0x34
        out 0x43,al
        xor al,al
        out 0x40,al
        out 0x40,al
        sti
        call venv
        call vflush
        mov ax,0x3510                   ; hook INT 10h
        int 0x21
        mov [cs:vold10],bx
        mov [cs:vold10+2],es
        push ds
        push cs
        pop ds
        mov dx,vi10
        mov ax,0x2510
        int 0x21
        pop ds
        mov byte [cs:vhooked],1
        pop es
        popa
        ret
.fail:  push ds
        push cs
        pop ds
        mov dx,vs_fail
        mov cx,vs_fail_len
        mov bx,2
        mov ah,0x40
        int 0x21
        pop ds
        pop es
        popa
        ret

vdone:  cmp byte [cs:vflag],1
        jne .r
        pusha
        cmp byte [cs:vhooked],1
        jne .u
        push ds
        lds dx,[cs:vold10]
        mov ax,0x2510
        int 0x21
        pop ds
        mov byte [cs:vhooked],0
.u:     cli
        mov al,0x36                     ; PIT channel 0 back to mode 3
        out 0x43,al
        xor al,al
        out 0x40,al
        out 0x40,al
        sti
        VS 'D:END lost='
        mov eax,[cs:vlost]
        call vdec
        call vnl
        call vflush
        mov bx,[cs:vhand]
        mov ah,0x3E
        int 0x21
        mov byte [cs:vflag],0
        popa
.r:     ret

; ---------------------------------------------------------------- environment
venv:   pushad
        push ds
        push es
        ; CPU: 386 if the AC flag cannot be toggled, 486 if ID cannot, else CPUID
        VS 'D:ENV CPU='
        pushfd
        pop eax
        mov ecx,eax
        xor eax,0x40000
        push eax
        popfd
        pushfd
        pop eax
        push ecx
        popfd
        xor eax,ecx
        test eax,0x40000
        jnz .c4
        VS '386'
        jmp .cd
.c4:    mov eax,ecx
        xor eax,0x200000
        push eax
        popfd
        pushfd
        pop eax
        push ecx
        popfd
        xor eax,ecx
        test eax,0x200000
        jnz .c5
        VS '486'
        jmp .cd
.c5:    VS 'CPUID '
        xor eax,eax
        db 0x0F,0xA2                    ; cpuid
        mov [cs:vtag],ebx
        mov [cs:vtag2],edx
        mov [cs:vtag3],ecx
        mov si,vtag
        mov cx,12
.cv:    mov al,[cs:si]
        call vput
        inc si
        loop .cv
        VS ' sig='
        mov eax,1
        db 0x0F,0xA2
        call vhex8
.cd:    ; DOS version, memory
        VS ' DOS='
        mov ah,0x30
        int 0x21
        push ax
        movzx eax,al
        call vdec
        mov al,'.'
        call vput
        pop ax
        movzx eax,ah
        call vdec
        VS ' PSPTOP='
        mov ax,[cs:2]
        call vhex4
        xor ax,ax
        mov es,ax
        VS ' BASEKB='
        movzx eax,word [es:0x413]
        call vdec
        VS ' EQUIP='
        mov ax,[es:0x410]
        call vhex4
        call vnl
        ; vectors
        VS 'D:ENV'
        mov si,vecs
.v:     mov bl,[cs:si]
        cmp bl,0xFF
        je .vd
        VS ' INT'
        mov al,bl
        call vhex2
        mov al,'='
        call vput
        movzx bx,bl
        shl bx,2
        mov ax,[es:bx+2]
        call vhex4
        mov al,':'
        call vput
        mov ax,[es:bx]
        call vhex4
        inc si
        jmp .v
.vd:    VS ' SAVEPTR='
        mov ax,[es:0x4AA]
        call vhex4
        mov al,':'
        call vput
        mov ax,[es:0x4A8]
        call vhex4
        call vnl
        ; system BIOS date and model
        VS 'D:ENV SYSBIOS='
        mov ax,0xF000
        mov ds,ax
        mov si,0xFFF5
        mov cx,8
.sb:    lodsb
        cmp al,32
        jb .sn
        cmp al,126
        ja .sn
        call vput
.sn:    loop .sb
        VS ' MODEL='
        mov al,[0xFFFE]
        call vhex2
        ; video ROM: header size and checksum over it
        mov ax,0xC000
        mov ds,ax
        VS ' VROM='
        mov ax,[0]
        call vhex4
        VS ' SIZE='
        movzx eax,byte [2]
        shl eax,9
        call vhex8
        movzx ecx,byte [2]
        shl ecx,9
        xor si,si
        xor bl,bl
.ck:    add bl,[si]
        inc si
        dec ecx
        jnz .ck
        VS ' SUM='
        mov al,bl
        call vhex2
        call vnl
        mov dword [cs:vtag],'VROM'
        xor si,si
        mov cx,256
        call vblk
        ; BIOS data area
        xor ax,ax
        mov ds,ax
        mov dword [cs:vtag],'BDA '
        mov si,0x400
        mov cx,256
        call vblk
        ; PCI display controller (class 03xxxx), configuration header 00h-3Fh
        mov ax,0xB101
        xor edi,edi
        int 0x1A
        jc .np
        cmp edx,0x20494350              ; 'PCI '
        jne .np
        VS 'D:PCI BIOS='
        push ax
        mov ax,bx
        call vhex4
        VS ' MECH='
        pop ax
        call vhex2
        mov ax,0xB103                   ; find class code 030000h (VGA), index 0
        mov ecx,0x030000
        xor si,si
        int 0x1A
        jc .pn
        or ah,ah
        jnz .pn
        VS ' BUS='
        mov al,bh
        call vhex2
        VS ' DEVFN='
        mov al,bl
        call vhex2
        call vnl
        xor di,di
.pc:    push bx
        push di
        mov ax,0xB10A
        int 0x1A
        pop di
        pop bx
        VS 'D:PCI '
        mov ax,di
        call vhex2
        mov al,'='
        call vput
        mov eax,ecx
        call vhex8
        call vnl
        add di,4
        cmp di,0x40
        jb .pc
        jmp .pe
.pn:    VS ' no VGA class device'
        call vnl
        jmp .pe
.np:    VS 'D:PCI no PCI BIOS'
        call vnl
.pe:    pop es
        pop ds
        popad
        ret

; ---------------------------------------------------------------- register dump
vregs:  cmp byte [cs:vflag],1
        jne .r
        pushad
        push ds
        push es
        mov dx,0x3CC
        in al,dx
        mov [cs:vmisc],al
        mov bx,0x3B4
        test al,1
        jz .m
        mov bx,0x3D4
.m:     mov [cs:vcrt],bx
        mov dx,0x3C4                    ; keep the index registers
        in al,dx
        mov [cs:vsx],al
        mov dx,0x3CE
        in al,dx
        mov [cs:vgx],al
        mov dx,bx
        in al,dx
        mov [cs:vcx],al
        mov dx,0x3C4                    ; unlock S3 registers (the tools do the same)
        mov ax,0x0608
        out dx,ax
        mov dx,bx
        mov ax,0x4838
        out dx,ax
        mov ax,0xA539
        out dx,ax
        VS 'D:REG MISC='
        mov al,[cs:vmisc]
        call vhex2
        VS ' FEAT='
        mov dx,0x3CA
        in al,dx
        call vhex2
        call vnl
        VS 'D:REG SR00:'                ; SR00-SR1F
        mov dx,0x3C4
        xor ah,ah
        mov cx,32
        call .idx
        call vnl
        VS 'D:REG GR00:'
        mov dx,0x3CE
        xor ah,ah
        mov cx,9
        call .idx
        call vnl
        VS 'D:REG CR00:'
        mov dx,[cs:vcrt]
        xor ah,ah
        mov cx,25
        call .idx
        call vnl
        mov ah,0x30                     ; CR30-CR6F and CR80-CR9F, 16 per line
.cl:    VS 'D:REG CR'
        mov al,ah
        call vhex2
        mov al,':'
        call vput
        mov cx,16
        mov dx,[cs:vcrt]
        call .idx
        call vnl
        cmp ah,0x70
        jne .c2
        mov ah,0x80
.c2:    cmp ah,0xA0
        jb .cl
        VS 'D:REG AR00:'                ; AR00-14, palette address source off while reading 00-0F
        mov dx,[cs:vcrt]
        add dx,6
        in al,dx
        xor ah,ah
.al:    mov dx,0x3C0
        mov al,ah
        cmp al,0x10
        jb .ap
        or al,0x20
.ap:    out dx,al
        inc dx
        in al,dx
        call vsp
        call vhex2
        mov dx,[cs:vcrt]
        add dx,6
        in al,dx
        inc ah
        cmp ah,0x15
        jb .al
        mov dx,0x3C0
        mov al,0x20
        out dx,al
        call vnl
        VS 'D:REG DAC:'                 ; DAC 0-15
        mov dx,0x3C7
        xor al,al
        out dx,al
        mov dx,0x3C9
        mov cx,16
.dl:    call vsp
        in al,dx
        call vhex2
        in al,dx
        call vhex2
        in al,dx
        call vhex2
        loop .dl
        call vnl
        xor ax,ax
        mov ds,ax
        VS 'D:REG BDA49:'
        mov si,0x449
        mov cx,0x1E
.b1:    call vsp
        lodsb
        call vhex2
        loop .b1
        call vnl
        VS 'D:REG BDA84:'
        mov si,0x484
        mov cx,7
.b2:    call vsp
        lodsb
        call vhex2
        loop .b2
        call vnl
        mov dx,0x3C4                    ; restore the index registers
        mov al,[cs:vsx]
        out dx,al
        mov dx,0x3CE
        mov al,[cs:vgx]
        out dx,al
        mov dx,[cs:vcrt]
        mov al,[cs:vcx]
        out dx,al
        pop es
        pop ds
        popad
.r:     ret
.idx:   ; DX index port, AH first index, CX count: print ' xx' each, AH advanced
        mov al,ah
        out dx,al
        inc dx
        in al,dx
        dec dx
        call vsp
        call vhex2
        inc ah
        loop .idx
        ret

; ---------------------------------------------------------------- INT 10h tracer
vtnow:  ; EAX = BIOS tick (low 16 bits) * 65536 + elapsed PIT counts in the tick
        push ebx
        push es
        xor ax,ax
        mov es,ax
        pushf
        cli
.rd:    mov bx,[es:0x46C]               ; tick, counter, tick again: retry when the tick moved in between
        xor al,al
        out 0x43,al                     ; latch channel 0
        in al,0x40
        mov ah,al
        in al,0x40
        xchg al,ah
        cmp bx,[es:0x46C]
        jne .rd
        not ax                          ; AX = counts elapsed in the tick
        push ax
        mov al,0x0A                     ; PIC IRR: IRQ0 pending while interrupts are off means the
        out 0x20,al                     ; counter has already wrapped but the tick is not counted yet
        in al,0x20
        test al,1
        pop ax
        jz .ok
        cmp ax,0x8000                   ; only early in the new period (a late count is the old one)
        jae .ok
        inc bx
.ok:    popf
        shl ebx,16
        mov bx,ax
        mov eax,ebx
        pop es
        pop ebx
        ret

vregl:  ; print the register set at CS:SI (ax bx cx dx si di bp ds es f)
        pushad
        mov di,vrnames
        mov cx,10
.l:     call vsp
        mov al,[cs:di]
        call vput
        mov al,[cs:di+1]
        call vput
        mov al,'='
        call vput
        mov ax,[cs:si]
        call vhex4
        add si,2
        add di,2
        loop .l
        popad
        ret

vi10:   cmp byte [cs:vquiet],0
        jne .chain
        push es
        push bx
        les bx,[cs:vindos]
        cmp byte [es:bx],0
        pop bx
        pop es
        je .log
.chain: jmp far [cs:vold10]
.log:   mov [cs:vi_eax],eax             ; the 32-bit registers go to the BIOS and back to the caller
        mov [cs:vi_eax+4],ebx           ; unchanged by the logging (vtnow uses EAX)
        mov [cs:vi_eax+8],ecx
        mov [cs:vi_eax+12],edx
        mov [cs:vi_eax+16],esi
        mov [cs:vi_eax+20],edi
        mov [cs:vi_ax],ax
        mov [cs:vi_bx],bx
        mov [cs:vi_cx],cx
        mov [cs:vi_dx],dx
        mov [cs:vi_si],si
        mov [cs:vi_di],di
        mov [cs:vi_bp],bp
        mov [cs:vi_ds],ds
        mov [cs:vi_es],es
        mov bp,sp
        mov ax,[ss:bp+4]                ; caller's flags
        mov [cs:vi_f],ax
        inc byte [cs:vdepth]
        VS 'D:I10>'
        cmp byte [cs:vdepth],1
        je .d1
        mov al,[cs:vdepth]
        add al,'0'
        call vput
.d1:    mov si,vi_ax
        call vregl
        call vnl
        cmp byte [cs:vdepth],1          ; flush before risky calls, only from the program itself
        jne .nf
        mov ax,[cs:vi_ax]
        cmp word [cs:vptr],0xC000
        jae .fl
        cmp ah,0x00
        je .fl
        cmp ah,0x11
        je .fl
        cmp ah,0x12
        je .fl
        cmp ah,0x1C
        je .fl
        cmp ah,0x4F
        jne .nf
        cmp al,0x05
        je .nf
.fl:    sti
        call vflush
        cli
.nf:    call vtnow
        mov [cs:vt0],eax
        push dword [cs:vt0]             ; nested INT 10h calls (the BIOS calls itself) overwrite
        push word [cs:vi_f]             ; the globals: keep start time and caller flags on the stack
        mov ax,[cs:vi_f]
        and ax,0xFDFF                   ; enter the BIOS with IF=0, like a real INT
        push ax
        mov eax,[cs:vi_eax]
        mov ebx,[cs:vi_eax+4]
        mov ecx,[cs:vi_eax+8]
        mov edx,[cs:vi_eax+12]
        mov esi,[cs:vi_eax+16]
        mov edi,[cs:vi_eax+20]
        mov bp,[cs:vi_bp]
        mov es,[cs:vi_es]
        mov ds,[cs:vi_ds]
        popf
        pushf
        call far [cs:vold10]
        pushf
        pop word [cs:vo_f]
        mov [cs:vo_eax],eax
        mov [cs:vo_eax+4],ebx
        mov [cs:vo_eax+8],ecx
        mov [cs:vo_eax+12],edx
        mov [cs:vo_eax+16],esi
        mov [cs:vo_eax+20],edi
        mov [cs:vo_ax],ax
        mov [cs:vo_bx],bx
        mov [cs:vo_cx],cx
        mov [cs:vo_dx],dx
        mov [cs:vo_si],si
        mov [cs:vo_di],di
        mov [cs:vo_bp],bp
        mov [cs:vo_ds],ds
        mov [cs:vo_es],es
        pop word [cs:vi_f]
        pop dword [cs:vt0]
        call vtnow
        sub eax,[cs:vt0]
        mov [cs:vt0],eax
        VS 'D:I10<'
        cmp byte [cs:vdepth],1
        je .d2
        mov al,[cs:vdepth]
        add al,'0'
        call vput
.d2:    mov si,vo_ax
        call vregl
        VS ' T='
        mov eax,[cs:vt0]
        call vdec
        call vnl
        dec byte [cs:vdepth]
        mov bp,sp                       ; result flags with the caller's IF
        mov ax,[cs:vo_f]
        and ax,0xFDFF
        mov bx,[cs:vi_f]
        and bx,0x0200
        or ax,bx
        mov [ss:bp+4],ax
        mov eax,[cs:vo_eax]
        mov ebx,[cs:vo_eax+4]
        mov ecx,[cs:vo_eax+8]
        mov edx,[cs:vo_eax+12]
        mov esi,[cs:vo_eax+16]
        mov edi,[cs:vo_eax+20]
        mov es,[cs:vo_es]
        mov ds,[cs:vo_ds]
        mov bp,[cs:vo_bp]
        iret

; ---------------------------------------------------------------- data
vecs    db 0x10,0x1D,0x1F,0x43,0x6D,0xFF
vrnames db 'AXBXCXDXSIDIBPDSESFL'
vs_fail db '/V: cannot create the debug file, /V ignored.',13,10
vs_fail_len equ $-vs_fail
align 4
vlost   dd 0
vindos  dd 0
vold10  dd 0
vi_eax  dd 0,0,0,0,0,0                  ; EAX EBX ECX EDX ESI EDI of the call (vi10)
vo_eax  dd 0,0,0,0,0,0                  ; and after it
vt0     dd 0
vtag    dd 0
vtag2   dd 0
vtag3   dd 0
vfr     times 33 dd 0
vsrt    times 33 dd 0
vfrn    dw 0
vseg    dw 0
vptr    dw 0
vhand   dw 0
vcrt    dw 0
vi_ax   dw 0
vi_bx   dw 0
vi_cx   dw 0
vi_dx   dw 0
vi_si   dw 0
vi_di   dw 0
vi_bp   dw 0
vi_ds   dw 0
vi_es   dw 0
vi_f    dw 0
vo_ax   dw 0
vo_bx   dw 0
vo_cx   dw 0
vo_dx   dw 0
vo_si   dw 0
vo_di   dw 0
vo_bp   dw 0
vo_ds   dw 0
vo_es   dw 0
vo_f    dw 0
vflag   db 0
vquiet  db 0
vdepth  db 0
vhooked db 0
vmisc   db 0
vsx     db 0
vgx     db 0
vcx     db 0
