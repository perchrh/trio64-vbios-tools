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
;   VGALOG /T        memory mode with a port trace: as /M, and during every mode set (AH=00h and AX=4F02h,
;                    with the calls the BIOS makes from inside them) VGALOG single-steps the BIOS and keeps
;                    each access to a VGA or S3 port in a second ring buffer of 64 KB (the last 16384
;                    events), in program order: the port, the value and whether it was read or written.
;                    Needs about 100 KB of conventional memory. A mode set runs slower while traced (a
;                    trap per instruction: about half a second for a 256 KB clear on a 386).
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
; Chip and ROM block, 32 bytes, read when VGALOG is installed (before Windows, so not virtualised), in
; both kinds of file after their header (so files from different cards and ROMs can be told apart):
;   +0  CR2D, CR2E, CR2F, CR30: the chip (88 11 = 86C732/764 Trio32/Trio64 or, CR2F bit 6 set, the
;       86C765 Trio64V+; 89 01 = 86C775/785 Trio64V2), read with the S3 registers unlocked
;   +4  CR36 (memory size and type, as strapped)    +5  ROM size in 512-byte blocks (C000:0002)
;   +6  SR10, +7 SR11 (the memory clock PLL the POST set)
;   +8  the ROM version: the word after "Version" or "Vers." in C000:0000-00FFh (for our ROMs
;       "2.04.07-p21", "1.03-08N-p4", "1.5-07-p2"), up to 15 characters, zero-padded
;   +24 8 bytes 0 (reserved)
;
; File mode: a 16-byte header 'VGALOGF1' and 8 bytes 0, the chip and ROM block, then the records.
; Record format, 16 bytes per record, two records per call
;   +0  'B' before the call, 'A' after it        +1  0
;   +2  AX in    +4  BX in    +6  CX in    +8  DX in   (the same in both records)
;   +10 AX returned ('A' only, 0 in 'B')
;   +12 CR67, CR13, CR51, CR31 after the call ('A' only): colour mode, pitch, pitch/start overflow,
;       memory configuration. Read without unlocking the S3 registers, as the BIOS left them.
;   A 'B' record without its 'A' record is the call that hung.
;
; Memory mode (/M, dumped with /D): a 48-byte file header, then 32 bytes per call, oldest first
;   header  'VGALOGM2', dd calls logged in total, dw records in the file, dw flags (bit 0 = the trace
;           part follows), then the chip and ROM block (32 bytes); the calls start at file offset 48.
;           ('VGALOGM1', before 1 November 2026: no flags, no block, the calls at offset 16.)
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
; Port trace (/T): after the calls, a second part
;   header  'VGALOGT1', dd events in total, dd events in the file (at most 16384)
;   then 4 bytes per event, oldest first:
;   +0  dw port (a marker: the call number of the record it belongs to)
;   +2  db value (written or read)
;   +3  db bits 1-0 kind: 0 = written (OUT, OUTS), 1 = read (IN), 2 = written as the high byte of a word
;          OUT to port - 1 (OUT DX,AX to 3D4h gives 3D4h kind 0, then 3D5h kind 2), 3 = marker: a logged
;          call starts here, +0 its call number (record +0), +2 its nesting depth
;       bits 7-2 repeats: that many more identical accesses follow (63 = 63 or more), so a polling loop
;          on 3DAh or 9AE8h takes one event
;   Traced ports: 3B0h-3DFh (VGA, DAC), CF8h-CFFh (PCI configuration) and those whose bits 9-0 are 2E8h
;   or 2EAh (the S3 graphics engine 82E8h-BEE8h and E2E8h, 42E8h, 4AE8h, 46E8h). Not traced: INS (the BIOS
;   reads no ports into memory), the code of other interrupts the BIOS calls (INT 15h, 1Ah: the CPU
;   clears the trap flag in them), the high word of a 32-bit OUT. A mode set the BIOS runs from inside
;   a traced call through INT 10h is traced too (VGALOG sets the trap flag again in its handler). Under
;   Windows the trap reaches VGALOG only if Windows reflects it to the DOS box (not checked).
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
;   VGALOG.BIN size = 48 + 32 bytes per logged call (and with /T 16 + 4 per trace event).
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
tflag   db 0                    ; 1 = port trace (/T)
tron    db 0                    ; 1 while a traced mode set runs
tpend   db 0                    ; an IN ran at the last trap: 1 = byte, 2 = word (value read at this one)
tlv     db 0                    ; 1 = tlast holds an event that may take repeats
tpport  dw 0                    ; the port of that IN
tseg    dw 0                    ; the trace ring: 64 KB, 16384 events of 4 bytes
tnext   dw 0                    ; byte offset of the next event in tseg
tlast   dw 0                    ; byte offset of the last event
ttotal  dd 0                    ; events in total
oldi1   dd 0                    ; INT 1 vector while a mode set is traced
info    times 32 db 0           ; the chip and ROM block (see the header), filled at install

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
        call tstart                     ; /T: a mode set, or a call inside one: trace it
        inc byte [depth]
        mov bp,sp                       ; [bp] caller SI, [bp+2] caller DS, [bp+4] caller BP
        xchg si,[bp]                    ; keep the slot there, SI = caller's SI
        mov ds,[bp+2]
        mov bp,[bp+4]
        pushf                           ; the BIOS's IRET frame: no trap flag, so the trace ends there
        cmp byte [cs:tron],0
        je .call
        push bp                         ; traced: set the trap flag; the first trap comes after the call
        mov bp,sp                       ; instruction, at the BIOS's entry
        pushf
        or byte [bp-1],1
        popf
        pop bp
.call:  call far [cs:old10]
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
        call tstop                      ; the traced mode set ended: INT 1 back
        dec byte [depth]
        mov ax,[bp+2]                   ; the BIOS result flags with the caller's interrupt and trap
        and ax,0xFCFF                   ; flags (a call from inside a traced one goes on being traced)
        push bx
        mov bx,[bp+14]
        and bx,0x0300
        or ax,bx
        pop bx
        mov [bp+14],ax
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

; /T, before the BIOS call (DS = CS, SI = the call's slot, AX = the caller's AX, [depth] = its depth).
; A mode set at depth 0 (AH=00h, AX=4F02h) starts the trace: INT 1 hooked, tron = 1. Every call while
; tron is 1 gets a marker event. Keeps all registers.
tstart: cmp byte [tflag],0
        je .r
        cmp byte [tron],0
        jne .mark                       ; a call from inside the traced one
        cmp byte [depth],0
        jne .r
        test ah,ah
        jz .on
        cmp ax,0x4F02
        jne .r
.on:    push es
        push ax
        xor ax,ax
        mov es,ax
        cli
        mov ax,[es:4]
        mov [oldi1],ax
        mov ax,[es:6]
        mov [oldi1+2],ax
        mov word [es:4],i1
        mov [es:6],cs
        sti
        pop ax
        pop es
        mov byte [tron],1
        mov byte [tpend],0
.mark:  push ax
        push bx
        mov bx,[si]                     ; the call number
        mov al,[depth]
        mov ah,3
        call tput
        mov byte [tlv],0                ; nothing merges into a marker
        pop bx
        pop ax
.r:     ret

; /T, after the BIOS call (DS = CS): at depth 1 (the traced mode set itself) INT 1 is put back and
; tron cleared. Keeps all registers.
tstop:  cmp byte [tron],0
        je .r
        cmp byte [depth],1
        jne .r
        push es
        push ax
        xor ax,ax
        mov es,ax
        cli
        mov ax,[oldi1]
        mov [es:4],ax
        mov ax,[oldi1+2]
        mov [es:6],ax
        sti
        pop ax
        pop es
        mov byte [tron],0
        mov byte [tpend],0
.r:     ret

; INT 1 (single step) while a mode set is traced: the trap comes before each instruction of the BIOS.
; Logs the port access of the instruction about to run (OUT, OUTS: port and value are known now) or of
; the one that just ran (IN: the value is in AL/AX now). Keeps all registers.
i1:     push bp
        mov bp,sp                       ; [bp+2] IP, [bp+4] CS of the next instruction
        push ds                         ; [bp-2] the traced DS
        push si                         ; [bp-4] SI
        push ax                         ; [bp-6] AX
        push bx                         ; [bp-8] BX
        cmp byte [cs:tpend],0
        je .dec
        mov bx,[cs:tpport]              ; the IN that just ran
        mov al,[bp-6]
        mov ah,1
        call tev
        cmp byte [cs:tpend],1
        je .pd
        inc bx
        mov al,[bp-5]
        call tev
.pd:    mov byte [cs:tpend],0
.dec:   lds si,[bp+2]
        xor bx,bx                       ; BL = segment prefix (0 = none), BH bit 0 = 66h, bit 1 = REP
.pf:    lodsb
        cmp al,0x66
        je .p66
        cmp al,0xF3
        je .prep
        cmp al,0xF2
        je .prep
        cmp al,0x67
        je .pf
        cmp al,0x26
        je .pseg
        cmp al,0x2E
        je .pseg
        cmp al,0x36
        je .pseg
        cmp al,0x3E
        je .pseg
        cmp al,0x64
        je .pseg
        cmp al,0x65
        je .pseg
        cmp al,0xE4
        jb .str
        cmp al,0xEF
        ja .x
        cmp al,0xE8
        jb .imm
        cmp al,0xEC
        jb .x
        mov bx,dx                       ; EC-EF: the port is DX
        jmp .io
.imm:   mov bl,[si]                     ; E4-E7: the port is the immediate byte
        xor bh,bh
.io:    test al,2
        jz .in                          ; E4, E5, EC, ED: IN
        push ax
        mov ah,0
        mov al,[bp-6]                   ; OUT: AL to the port
        call tev
        pop ax
        test al,1
        jz .x
        inc bx                          ; OUT of a word: AH to the next port
        mov al,[bp-5]
        mov ah,2
        call tev
        jmp .x
.in:    mov [cs:tpport],bx
        and al,1
        inc ax
        mov [cs:tpend],al               ; 1 = byte, 2 = word
        jmp .x
.p66:   or bh,1
        jmp .pf
.prep:  or bh,2
        jmp .pf
.pseg:  mov bl,al
        jmp .pf
.str:   cmp al,0x6E                     ; OUTSB, OUTSW (INS not traced)
        jb .x
        cmp al,0x6F
        ja .x
        test bh,2
        jz .os
        jcxz .x                         ; REP with CX = 0 does nothing
.os:    push ax
        mov ax,[bp-2]                   ; the source segment: DS or the prefix's
        cmp bl,0x26
        jne .s1
        mov ax,es
.s1:    cmp bl,0x2E
        jne .s2
        mov ax,[bp+4]
.s2:    cmp bl,0x36
        jne .s3
        mov ax,ss
.s3:    cmp bl,0x64
        jne .s4
        mov ax,fs
.s4:    cmp bl,0x65
        jne .s5
        mov ax,gs
.s5:    mov ds,ax
        mov si,[bp-4]
        mov bx,dx
        mov al,[si]
        mov ah,0
        call tev
        pop ax
        test al,1
        jz .x
        inc bx
        mov al,[si+1]
        mov ah,2
        call tev
.x:     pop bx
        pop ax
        pop si
        pop ds
        pop bp
        iret

; A trace event: BX = port, AL = value, AH = kind (0 written, 1 read, 2 high byte of a word written).
; Only the VGA, PCI configuration and S3 engine ports; the same access as the last event adds a repeat.
; Keeps all registers.
tev:    cmp bx,0x3B0
        jb .no
        cmp bx,0x3DF
        jbe .ok
        cmp bx,0xCF8
        jb .s3
        cmp bx,0xCFF
        jbe .ok
.s3:    push bx
        and bx,0x3FD
        cmp bx,0x2E8
        pop bx
        jne .no
.ok:    cmp byte [cs:tlv],0
        je tput
        push es
        push di
        mov es,[cs:tseg]
        mov di,[cs:tlast]
        cmp [es:di],bx
        jne .new
        cmp [es:di+2],al
        jne .new
        push ax
        mov al,[es:di+3]
        and al,3
        cmp al,ah
        pop ax
        jne .new
        cmp byte [es:di+3],0xFC
        jae .d
        add byte [es:di+3],4
.d:     pop di
        pop es
.no:    ret
.new:   pop di
        pop es
; A new event: BX = port (or call number), AL = value, AH = kind. Keeps all registers.
tput:   push es
        push di
        mov es,[cs:tseg]
        mov di,[cs:tnext]
        mov [es:di],bx
        mov [es:di+2],ax
        mov [cs:tlast],di
        mov byte [cs:tlv],1
        add word [cs:tnext],4
        add word [cs:ttotal],1
        adc word [cs:ttotal+2],0
        pop di
        pop es
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
        cmp ah,'t'
        je tinst
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
        call getinfo                    ; the file header and the chip and ROM block first
        mov bx,ax
        mov ah,0x40
        mov cx,16
        mov dx,fhdr
        int 0x21
        mov ah,0x40
        mov cx,32
        mov dx,info
        int 0x21
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

; ---------------- install in memory mode with the port trace ----------------
tinst:  mov ax,[2]                      ; the end of our memory block (PSP+2)
        mov bx,cs
        sub ax,bx
        cmp ax,TPARA
        jae .ok
        mov dx,s_tmem
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21
.ok:    mov byte [tflag],1
        mov ax,cs
        add ax,TPARA - 0x1000
        mov [tseg],ax
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
        call getinfo
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
        cmp byte [tflag],0
        je .m
        mov dx,msgt
.m:     mov ah,9
        int 0x21
        mov dx,ring+RBN*32+15           ; PSP + handler + ring buffer, in paragraphs
        shr dx,4
        cmp byte [tflag],0
        je .k
        mov dx,TPARA                    ; and the trace ring
.k:     mov ax,0x3100
        int 0x21
TPARA   equ ((ring - $$ + 0x100 + RBN*32 + 15) >> 4) + 0x1000   ; PSP + code + call ring, then the 64 KB trace ring

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
        mov al,[es:tflag]               ; flags: bit 0 = the trace part follows
        mov [dhdr+14],al
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
        push ds                         ; the resident copy's chip and ROM block
        push es
        pop ds
        mov ah,0x40
        mov cx,32
        mov dx,info
        int 0x21
        pop ds
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
.cl:    cmp byte [es:tflag],0
        je .cf
        call tdump
        jc .err
.cf:    mov ah,0x3E
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

; The trace part of /D: header, then the events oldest first. In: BX = file handle, ES = the resident
; copy. Out: CF = 1 on a write error. Changes AX, CX, DX, SI, DI.
tdump:  mov eax,[es:ttotal]
        mov [thdr+8],eax
        xor si,si                       ; SI = the oldest event's offset
        mov edi,eax
        shl edi,2                       ; EDI = bytes to write: all 64 KB once the ring is full
        cmp eax,16384
        jb .h
        mov si,[es:tnext]
        mov edi,0x10000
        mov eax,16384
.h:     mov [thdr+12],eax
        mov ah,0x40
        mov cx,16
        mov dx,thdr
        int 0x21
        jc .r
.l:     test edi,edi                    ; pieces of at most 32 KB that do not wrap at 64 KB
        jz .r
        mov ecx,0x8000
        cmp edi,ecx
        jae .a
        mov ecx,edi
.a:     movzx eax,si
        neg eax
        add eax,0x10000                 ; bytes up to the end of the segment
        cmp ecx,eax
        jbe .b
        mov ecx,eax
.b:     sub edi,ecx
        mov dx,si
        add si,cx
        push ds
        mov ds,[es:tseg]
        mov ah,0x40
        int 0x21
        pop ds
        jnc .l
.r:     ret

; The chip and ROM block into info (DS = CS): CR2D-CR30 and CR36 with the S3 registers unlocked (CR38,
; CR39 and the CRTC index put back), SR10/SR11 (through s3regs, which also puts SR08 and the indexes
; back), the ROM size and version from C000h. Keeps all registers.
getinfo:
        pusha
        push es
        mov si,info + 6 - 26            ; s3regs: SR10 SR11 -> info+6/+7 (and CR58-CR6D -> +8..+11,
        call s3regs                     ; overwritten by the version below)
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
        mov di,info
        mov al,0x2D
.id:    push ax
        call rd
        mov [di],ah
        inc di
        pop ax
        inc ax
        cmp al,0x31
        jb .id
        mov al,0x36
        call rd
        mov [info+4],ah
        mov al,0x39
        mov ah,cl
        out dx,ax
        mov al,0x38
        mov ah,bh
        out dx,ax
        mov al,bl
        out dx,al
        mov ax,0xC000
        mov es,ax
        mov al,[es:2]
        mov [info+5],al
        mov di,info+8                   ; the version: clear, then the word after "Vers"
        mov cx,16
        xor al,al
.z:     mov [di],al
        inc di
        loop .z
        xor si,si
.f:     cmp dword [es:si],'Vers'
        je .w
        inc si
        cmp si,0x100 - 4
        jb .f
        jmp .r
.w:     add si,4
.s1:    mov al,[es:si]                  ; the rest of the word ("ion", ".")
        cmp al,' '
        jbe .s2
        inc si
        cmp si,0x100
        jb .s1
        jmp .r
.s2:    mov al,[es:si]                  ; the blanks after it
        cmp al,' '
        jne .c
        inc si
        cmp si,0x100
        jb .s2
        jmp .r
.c:     mov di,info+8
        mov cx,15
.cl:    mov al,[es:si]
        cmp al,' '
        jbe .r                          ; ends at a blank, CR, LF or 0
        cmp al,'('
        je .r
        mov [di],al
        inc di
        inc si
        cmp si,0x100
        jae .r
        loop .cl
.r:     pop es
        popa
        ret

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
msgt    db 'VGALOG ',VERSION,' installed in memory mode with the port trace of the mode sets (AH=00h, 4F02h), VGALOG /D writes them',13,10,'$'
s_tmem  db 'VGALOG ',VERSION,': not enough memory for /T (about 100 KB)',13,10,'$'
thdr    db 'VGALOGT1',0,0,0,0,0,0,0,0
s_dump  db 'VGALOG ',VERSION,': ring buffer written to VGALOG.BIN',13,10,'$'
s_none  db 'VGALOG ',VERSION,': No events registered, not writing output file',13,10,'$'
s_notm  db 'VGALOG ',VERSION,': /D needs VGALOG resident in memory mode (VGALOG /M).',13,10,'$'
dhdr    db 'VGALOGM2',0,0,0,0,0,0,0,0
fhdr    db 'VGALOGF1',0,0,0,0,0,0,0,0
dcnt    dw 0
dfirst  dw 0
s_use   db 'VGALOG ',VERSION,' - logs INT 10h AH=00 and VBE 4F01/4F02/4F06 calls to VGALOG.BIN',13,10
        db '  VGALOG              install (VGALOG.BIN is created new in the current directory)',13,10
        db '  VGALOG /M           install in memory mode: last 1024 INT 10h calls in RAM (for Windows 9x)',13,10
        db '  VGALOG /T           as /M, and every VGA/S3 port access of the mode sets (AH=00h, 4F02h)',13,10
        db '  VGALOG /D           memory mode: write the calls (and the trace) to VGALOG.BIN',13,10
        db '  VGALOG /U           unload (INT 10h restored, VGALOG.BIN closed)',13,10
        db '  VGALOG /H, /?, /HELP  this help',13,10,'$'
s_bad   db 'VGALOG ',VERSION,': bad argument.',13,10,13,10,'$'
s_twice db 'VGALOG ',VERSION,': already installed.',13,10,'$'
s_unl   db 'VGALOG ',VERSION,': unloaded, VGALOG.BIN closed.',13,10,'$'
s_unlm  db 'VGALOG ',VERSION,': unloaded (memory mode; the calls not written with /D are gone).',13,10,'$'
s_notres db 'VGALOG ',VERSION,': not unloaded: VGALOG is not installed, or another program hooked INT 10h',13,10
        db 'after it (unload that one first).',13,10,'$'
s_free  db 'VGALOG ',VERSION,': INT 10h restored, but its memory could not be freed.',13,10,'$'
