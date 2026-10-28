; S3REGS.COM - register snapshot of a Trio64-family card (Trio32, Trio64, Trio64V+, Trio64V2) for comparing states (DOS)
;
; Purpose
;   Writes the registers the BIOS and drivers program to S3REGS.TXT, in the same text format as
;   S3REGS32.EXE writes from the Windows 9x desktop. Used to see what another driver (the S3 Windows 9x
;   driver) leaves in the chip, compared with what our BIOS sets: memory clock (SR10/SR11), clocks,
;   FIFO and memory arbitration (CR54, CR60, CR90-CR93), linear addressing (CR58-CR5A, CR6D), CR87,
;   SR15 and the rest. Runs on any VGA; it changes nothing and leaves every index and lock as it was.
;
; Usage
;   S3REGS [label]       append one snapshot with the label (up to 60 characters) to S3REGS.TXT
;   S3REGS /H, /?, /HELP  parameter list
;   Useful places: plain DOS with our ROM; after "Restart in MS-DOS mode" or exiting Windows (what the
;   Windows driver left); in a full-screen and a windowed DOS box (Windows may show virtual values
;   there, the driver traps the VGA and S3 ports of DOS boxes). Exit code 0 = written, 1 = error.
;
; What is read (format in the README, section "Windows 9x driver test")
;   MISC (3CCh), FEAT (3CAh), PEL mask (3C6h), BIOS video mode (0040:0049), VBE mode (4F03h), BIOS tick
;   SR00-SR1F   with SR08 = 06h for the extended ones, SR08 restored
;   CR00-CRFF   with CR38 = 48h and CR39 = A5h, both restored; CR45, CR4A and CR4B are not read (a read
;               moves the hardware cursor colour stack) and show as "--"
;   GR00-GR08   PCI configuration 00h-3Fh of device 5333:8901 (PCI BIOS)
;   The attribute controller is not read: reading AR00-0F needs the palette address source bit
;   cleared, which blanks the screen, and it touches the 3C0h flip-flop a driver may be using.
;   The 3C4h, 3CEh and 3D4h index registers are put back.
bits 16
org 0x100
cpu 386
%include "version.inc"

start:  cld
        mov si,0x81                     ; command line: /H or a label
.sk:    lodsb
        cmp al,' '
        je .sk
        cmp al,9
        je .sk
        dec si
        cmp al,'/'
        jne .lab
        mov al,[si+1]
        or al,0x20
        cmp al,'h'
        je help
        cmp al,'?'
        je help
.lab:   mov di,label                    ; copy the label up to CR, 60 characters
        mov cx,60
.lc:    lodsb
        cmp al,13
        je .ld
        stosb
        loop .lc
.ld:    mov byte [di],0
        mov di,obuf
        call snapshot
        ; append to S3REGS.TXT
        mov ax,0x3D01                   ; open for writing
        mov dx,fname
        int 0x21
        jnc .op
        mov ah,0x3C                     ; or create it
        xor cx,cx
        mov dx,fname
        int 0x21
        jc ferr
.op:    mov bx,ax
        mov ax,0x4202                   ; to the end
        xor cx,cx
        xor dx,dx
        int 0x21
        mov cx,di
        sub cx,obuf
        mov dx,obuf
        mov ah,0x40
        int 0x21
        jc ferr
        mov ah,0x3E
        int 0x21
        mov dx,s_ok
        mov ah,9
        int 0x21
        mov ax,0x4C00
        int 0x21
ferr:   mov dx,s_ferr
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21
help:   mov dx,s_use
        mov ah,9
        int 0x21
        mov ax,0x4C00
        int 0x21

; Snapshot into DS:DI (advanced). Keeps the indexes and the S3 lock registers as found.
snapshot:
        mov si,s_head
        call str
        mov si,label
        call str
        mov si,s_dos
        call str
        mov si,s_misc                   ; MISC FEAT PEL MODE VBE TICK
        call str
        mov dx,0x3CC
        in al,dx
        mov [misc],al
        ; CRTC port from MISC bit 0; the indexes are saved before the INT 10h AX=4F03h below, which
        ; may move them (the Trio64V+ BIOS 1.03 leaves the CRTC index at 39h)
        mov word [crtc],0x3B4
        test byte [misc],1
        jz .c
        mov word [crtc],0x3D4
.c:     mov dx,0x3C4
        in al,dx
        mov [sri],al
        mov dx,0x3CE
        in al,dx
        mov [gri],al
        mov dx,[crtc]
        in al,dx
        mov [cri],al
        mov al,[misc]
        call hex2
        mov si,s_feat
        call str
        mov dx,0x3CA
        in al,dx
        call hex2
        mov si,s_pel
        call str
        mov dx,0x3C6
        in al,dx
        call hex2
        mov si,s_mode
        call str
        push es
        xor ax,ax
        mov es,ax
        mov al,[es:0x449]
        mov ebx,[es:0x46C]
        pop es
        call hex2
        mov si,s_vbe
        call str
        push bx
        push di
        mov ax,0x4F03
        int 0x10
        mov dx,bx
        pop di
        pop bx
        cmp ax,0x004F
        jne .nv
        mov ax,dx
        call hex4
        jmp .tk
.nv:    mov si,s_dash4
        call str
.tk:    mov si,s_tick
        call str
        mov eax,ebx
        call hex8
        call crlf
        ; save the locks
        mov al,0x38
        call rdcr
        mov [cr38],ah
        mov al,0x39
        call rdcr
        mov [cr39],ah
        mov dx,0x3C4
        mov al,0x08
        out dx,al
        inc dx
        in al,dx
        mov [sr08],al
        mov al,0x06                     ; unlock
        out dx,al
        mov dx,[crtc]
        mov ax,0x4838
        out dx,ax
        mov ax,0xA539
        out dx,ax
        ; SR00-SR1F
        xor bl,bl
.sr:    test bl,15
        jnz .sr1
        mov si,s_sr
        call str
        mov al,bl
        call hex2
        mov al,':'
        stosb
.sr1:   mov al,' '
        stosb
        mov dx,0x3C4
        mov al,bl
        out dx,al
        inc dx
        in al,dx
        cmp bl,0x08
        jne .sr2
        mov al,[sr08]                   ; SR08 as found, not our unlock value
.sr2:   call hex2
        inc bl
        test bl,15
        jnz .sr3
        call crlf
.sr3:   cmp bl,0x20
        jb .sr
        ; CR00-CRFF
        xor bl,bl
.cr:    test bl,15
        jnz .cr1
        mov si,s_cr
        call str
        mov al,bl
        call hex2
        mov al,':'
        stosb
.cr1:   mov al,' '
        stosb
        cmp bl,0x45
        je .skp
        cmp bl,0x4A
        je .skp
        cmp bl,0x4B
        je .skp
        mov al,bl
        call rdcr
        mov al,ah
        cmp bl,0x38
        jne .cr2
        mov al,[cr38]
.cr2:   cmp bl,0x39
        jne .cr3
        mov al,[cr39]
.cr3:   call hex2
        jmp .cr4
.skp:   mov ax,'--'
        stosw
.cr4:   inc bl
        test bl,15
        jnz .cr5
        call crlf
.cr5:   or bl,bl
        jnz .cr
        ; GR00-GR08
        mov si,s_gr
        call str
        xor bl,bl
.gr:    mov al,' '
        stosb
        mov dx,0x3CE
        mov al,bl
        out dx,al
        inc dx
        in al,dx
        call hex2
        inc bl
        cmp bl,9
        jb .gr
        call crlf
        ; restore locks and indexes
        mov dx,[crtc]
        mov al,0x39
        mov ah,[cr39]
        out dx,ax
        mov al,0x38
        mov ah,[cr38]
        out dx,ax
        mov al,[cri]
        out dx,al
        mov dx,0x3C4
        mov al,0x08
        mov ah,[sr08]
        out dx,ax
        mov al,[sri]
        out dx,al
        mov dx,0x3CE
        mov al,[gri]
        out dx,al
        ; PCI configuration of the card (5333:8901, 8811 or 8814, common/chip.inc)
        mov si,s_pci
        call str
        call chipfind
        jc .np
        mov bx,[chipbx]
        xor si,si
.pc:    mov al,' '
        stosb
        push di
        mov di,si
        mov ax,0xB10A
        int 0x1A
        pop di
        mov eax,ecx
        call hex8
        add si,4
        cmp si,0x40
        jb .pc
        jmp .pe
.np:    mov si,s_na
        call str
.pe:    call crlf
        call crlf
        ret

rdcr:   mov dx,[crtc]                   ; CR index AL -> AH (index register left at AL)
        out dx,al
        inc dx
        in al,dx
        mov ah,al
        ret

str:    lodsb                           ; copy the 0-terminated string at SI to DI
        or al,al
        jz .e
        stosb
        jmp str
.e:     ret
crlf:   mov ax,0x0A0D
        stosw
        ret
hex8:   push eax
        shr eax,16
        call hex4
        pop eax
hex4:   push ax
        mov al,ah
        call hex2
        pop ax
hex2:   push ax
        shr al,4
        call .n
        pop ax
        push ax
        and al,15
        call .n
        pop ax
        ret
.n:     add al,'0'
        cmp al,'9'
        jbe .o
        add al,7
.o:     stosb
        ret

fname   db 'S3REGS.TXT',0
s_head  db 'S3REGS ',VERSION,' [',0
s_dos   db '] DOS',13,10,0
s_misc  db 'MISC=',0
s_feat  db ' FEAT=',0
s_pel   db ' PEL=',0
s_mode  db ' MODE=',0
s_vbe   db ' VBE=',0
s_tick  db ' TICK=',0
s_dash4 db '----',0
s_sr    db 'SR',0
s_cr    db 'CR',0
s_gr    db 'GR00:',0
%include "chip.inc"
s_pci   db 'PCI00:',0
s_na    db ' n/a',0
s_ok    db 'S3REGS ',VERSION,': snapshot appended to S3REGS.TXT',13,10,'$'
s_ferr  db 'S3REGS ',VERSION,': cannot write S3REGS.TXT',13,10,'$'
s_use   db 'S3REGS ',VERSION,' - Trio64-family register snapshot, appended to S3REGS.TXT',13,10
        db '  S3REGS [label]      one snapshot with an optional label (up to 60 characters)',13,10
        db '  S3REGS /H, /?, /HELP  this help',13,10
        db 'For the Windows 9x desktop use S3REGS32.EXE (same format).',13,10,'$'
misc    db 0
sri     db 0
gri     db 0
cri     db 0
cr38    db 0
cr39    db 0
sr08    db 0
crtc    dw 0x3D4
label   times 62 db 0
obuf:
