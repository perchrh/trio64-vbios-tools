; S3REGS32.EXE - register snapshot of a Trio64-family card from the Windows 9x desktop (Win32 console)
;
; Purpose
;   The same snapshot as S3REGS.COM (format in the README, section "Windows 9x driver test"), taken
;   while the Windows 9x display driver runs the card, so its settings can be compared with our BIOS:
;   memory clock (SR10/SR11), pixel clock, FIFO and memory arbitration (CR54, CR60, CR90-CR93), linear
;   addressing (CR58-CR5A), CR66, CR67, CR87, SR15 and the rest. With /W it watches the registers and
;   logs every change with a time stamp, to catch what the driver does when a DOS box goes full screen,
;   a video plays through the overlay or the display settings change.
;
; Usage (Windows 95/98/ME console; Windows NT does not allow the port access)
;   S3REGS32 [label]         append one snapshot with the label to S3REGS.TXT
;   S3REGS32 /W n [label]    snapshot, then watch for n seconds (1-3600, every 100 ms), appending one
;                            line per changed register: "+<ms> CRxx old->new"; then a closing snapshot
;   S3REGS32 /H, /?          parameter list
;   Exit code 0 = written, 1 = error.
;
; What is read and what is left alone
;   MISC, FEAT, PEL mask; SR00-SR1F (SR08 = 06h while reading, restored); CR00-CRFF (CR38 = 48h and
;   CR39 = A5h while reading, restored); GR00-GR08; PCI configuration 00h-3Fh of 5333:8901 through
;   ports CF8h/CFCh (CF8h restored). CR45, CR4A and CR4B are not read (a read moves the hardware cursor
;   colour stack) and the attribute controller is not touched. The 3C4h, 3CEh and 3D4h index registers
;   are put back. Watch mode ignores CR46-CR4F (hardware cursor position and pattern address, they
;   follow the mouse).
;   Windows 9x lets a Win32 program use the I/O ports unless a virtual device traps them; the S3
;   driver traps the VGA ports for DOS boxes, not for the desktop, so the desktop values are real.
;
; Build: nasm -f bin -o S3REGS32.EXE s3regs32.asm (the PE header is written out below; no linker).
bits 32
%include "version.inc"

BASE    equ 0x400000
TEXTVA  equ 0x401000
BUFSZ   equ 0x10000                     ; output buffer
STATESZ equ 0x200                       ; one register state: 32 SR + 256 CR + 9 GR + MISC

; ---------------------------------------------------------------- headers
        section hdr start=0 vstart=BASE
mz:     db 'MZ'
        times 0x3A db 0
        dd pe - BASE                    ; e_lfanew
        times 0x40 - ($ - mz) db 0
pe:     db 'PE',0,0
        dw 0x014C                       ; i386
        dw 1                            ; one section
        dd 0, 0, 0
        dw opt_end - opt                ; size of the optional header
        dw 0x010F                       ; relocations stripped, executable, 32-bit
opt:    dw 0x010B                       ; PE32
        db 2, 50                        ; linker version
        dd text_raw                     ; size of code
        dd text_raw                     ; size of initialised data
        dd 0                            ; size of uninitialised data
        dd entry - BASE                 ; entry point
        dd TEXTVA - BASE                ; base of code
        dd TEXTVA - BASE                ; base of data
        dd BASE                         ; image base
        dd 0x1000                       ; section alignment
        dd 0x200                        ; file alignment
        dw 4, 0                         ; OS version 4.0
        dw 0, 0                         ; image version
        dw 4, 0                         ; subsystem version 4.0 (Windows 95)
        dd 0
        dd image_size                   ; size of image
        dd 0x200                        ; size of headers
        dd 0                            ; checksum
        dw 3                            ; console subsystem
        dw 0
        dd 0x100000, 0x1000, 0x100000, 0x1000   ; stack reserve/commit, heap reserve/commit
        dd 0
        dd 16                           ; data directories
        dd 0, 0                         ; export
        dd imp - BASE, imp_end - imp    ; import
        times 2*14 dd 0
opt_end:
        db '.text',0,0,0
        dd text_vsize                   ; virtual size
        dd TEXTVA - BASE                ; RVA
        dd text_raw                     ; size of raw data
        dd 0x200                        ; file offset
        dd 0, 0
        dw 0, 0
        dd 0xE0000060                   ; code, initialised data, execute, read, write
        times 0x200 - ($ - mz) db 0

; ---------------------------------------------------------------- code and data
        section text start=0x200 vstart=TEXTVA
tstart:
entry:  cld
        call [GetCommandLineA]
        mov esi,eax
        cmp byte [esi],'"'              ; skip the program name
        jne .bare
        inc esi
.q:     lodsb
        or al,al
        jz .args
        cmp al,'"'
        jne .q
        jmp .args
.bare:  lodsb
        or al,al
        jz .args0
        cmp al,' '
        jne .bare
        jmp .args
.args0: dec esi
.args:  call skipsp
        cmp byte [esi],'/'
        jne .label
        mov al,[esi+1]
        or al,0x20
        cmp al,'h'
        je help
        cmp al,'?'
        je help
        cmp al,'w'
        jne help
        add esi,2                       ; /W n
        call skipsp
        xor ecx,ecx
.num:   movzx eax,byte [esi]
        sub al,'0'
        cmp al,9
        ja .nd
        imul ecx,ecx,10
        add ecx,eax
        inc esi
        jmp .num
.nd:    or ecx,ecx
        jz help
        cmp ecx,3600
        ja help
        mov [watch_s],ecx
        call skipsp
.label: mov edi,label                   ; up to 60 characters
        mov ecx,60
.lc:    lodsb
        or al,al
        jz .ld
        cmp al,13
        je .ld
        cmp al,10
        je .ld
        stosb
        loop .lc
.ld:    mov byte [edi],0
        call [GetTickCount]
        mov [t0],eax
        ; first snapshot
        mov edi,obuf
        mov esi,s_snap
        call str
        call snapshot
        call fwrite
        jc ferr
        cmp dword [watch_s],0
        je done
        ; watch: state A = what the snapshot read
        mov edi,obuf
        mov esi,s_watch
        call str
        mov eax,[watch_s]
        call dec32
        mov esi,s_watch2
        call str
        call fwrite
        jc ferr
        mov eax,[watch_s]
        imul eax,eax,1000
        mov [t_end],eax
.wl:    push dword 100
        call [Sleep]
        call [GetTickCount]
        sub eax,[t0]
        mov [t_now],eax
        mov esi,stateA                  ; current into B, compare with A
        mov edi,stateB
        call readstate
        mov edi,obuf
        call diff
        cmp edi,obuf
        je .nc
        call fwrite
        jc ferr
.nc:    mov esi,stateB                  ; B becomes the reference
        mov edi,stateA
        mov ecx,STATESZ/4
        rep movsd
        mov eax,[t_now]
        cmp eax,[t_end]
        jb .wl
        mov edi,obuf                    ; closing snapshot
        mov esi,s_end
        call str
        call snapshot
        call fwrite
        jc ferr
done:   mov edi,obuf
        mov esi,s_ok
        call str
        call conout
        push dword 0
        call [ExitProcess]
ferr:   mov edi,obuf
        mov esi,s_ferr
        call str
        call conout
        push dword 1
        call [ExitProcess]
help:   mov edi,obuf
        mov esi,s_use
        call str
        call conout
        push dword 0
        call [ExitProcess]

skipsp: cmp byte [esi],' '
        je .s
        cmp byte [esi],9
        jne .r
.s:     inc esi
        jmp skipsp
.r:     ret

; Append obuf..EDI to S3REGS.TXT. CF on error. Keeps nothing.
fwrite: mov eax,edi
        sub eax,obuf
        mov [wlen],eax
        push dword 0                    ; template
        push dword 0x80                 ; FILE_ATTRIBUTE_NORMAL
        push dword 4                    ; OPEN_ALWAYS
        push dword 0                    ; security
        push dword 1                    ; FILE_SHARE_READ
        push dword 0x40000000           ; GENERIC_WRITE
        push dword fname
        call [CreateFileA]
        cmp eax,-1
        je .e
        mov [hfile],eax
        push dword 2                    ; FILE_END
        push dword 0
        push dword 0
        push eax
        call [SetFilePointer]
        push dword 0
        push dword written
        push dword [wlen]
        push dword obuf
        push dword [hfile]
        call [WriteFile]
        push eax
        push dword [hfile]
        call [CloseHandle]
        pop eax
        or eax,eax
        jz .e
        clc
        ret
.e:     stc
        ret

; Write obuf..EDI to the console.
conout: mov eax,edi
        sub eax,obuf
        mov [wlen],eax
        push dword -11                  ; STD_OUTPUT_HANDLE
        call [GetStdHandle]
        push dword 0
        push dword written
        push dword [wlen]
        push dword obuf
        push eax
        call [WriteFile]
        ret

; ---------------- register access (keeps the indexes and locks as found) ----------------
; Read all registers into the state at EDI: SR00-1F, CR00-FF, GR00-08, MISC. Keeps ESI.
readstate:
        push esi
        push edi
        mov dx,0x3CC
        in al,dx
        mov [edi+297],al                ; MISC
        mov word [crtc],0x3B4
        test al,1
        jz .c
        mov word [crtc],0x3D4
.c:     mov dx,0x3C4                    ; save indexes and locks
        in al,dx
        mov [sri],al
        mov dx,0x3CE
        in al,dx
        mov [gri],al
        mov dx,[crtc]
        in al,dx
        mov [cri],al
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
        mov al,0x06
        out dx,al
        mov dx,[crtc]
        mov ax,0x4838
        out dx,ax
        mov ax,0xA539
        out dx,ax
        xor ebx,ebx                     ; SR00-1F -> +0
.sr:    mov dx,0x3C4
        mov al,bl
        out dx,al
        inc dx
        in al,dx
        mov [edi+ebx],al
        inc ebx
        cmp ebx,32
        jb .sr
        mov al,[sr08]
        mov [edi+8],al
        xor ebx,ebx                     ; CR00-FF -> +32
.cr:    xor ah,ah
        cmp bl,0x45
        je .cs
        cmp bl,0x4A
        je .cs
        cmp bl,0x4B
        je .cs
        mov al,bl
        call rdcr
.cs:    mov [edi+32+ebx],ah
        inc ebx
        cmp ebx,256
        jb .cr
        mov al,[cr38]
        mov [edi+32+0x38],al
        mov al,[cr39]
        mov [edi+32+0x39],al
        xor ebx,ebx                     ; GR00-08 -> +288
.gr:    mov dx,0x3CE
        mov al,bl
        out dx,al
        inc dx
        in al,dx
        mov [edi+288+ebx],al
        inc ebx
        cmp ebx,9
        jb .gr
        mov dx,[crtc]                   ; restore locks and indexes
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
        pop edi
        pop esi
        ret

rdcr:   mov dx,[crtc]                   ; CR index AL -> AH
        out dx,al
        inc dx
        in al,dx
        mov ah,al
        ret

; Full snapshot text at EDI (advanced): header, MISC FEAT PEL TICK, SR, CR, GR, PCI. Reads into stateA.
snapshot:
        mov esi,s_head
        call str
        mov esi,label
        call str
        mov esi,s_win
        call str
        push edi
        mov edi,stateA
        call readstate
        pop edi
        mov esi,s_misc
        call str
        mov al,[stateA+297]
        call hex2
        mov esi,s_feat
        call str
        mov dx,0x3CA
        in al,dx
        call hex2
        mov esi,s_pel
        call str
        mov dx,0x3C6
        in al,dx
        call hex2
        mov esi,s_tick
        call str
        call [GetTickCount]
        call hex8
        call crlf
        xor ebx,ebx                     ; SR rows
.sr:    test bl,15
        jnz .s1
        mov esi,s_sr
        call str
        mov al,bl
        call hex2
        mov al,':'
        stosb
.s1:    mov al,' '
        stosb
        mov al,[stateA+ebx]
        call hex2
        inc ebx
        test bl,15
        jnz .s2
        call crlf
.s2:    cmp ebx,32
        jb .sr
        xor ebx,ebx                     ; CR rows
.cr:    test bl,15
        jnz .c1
        mov esi,s_cr
        call str
        mov al,bl
        call hex2
        mov al,':'
        stosb
.c1:    mov al,' '
        stosb
        cmp bl,0x45
        je .cd
        cmp bl,0x4A
        je .cd
        cmp bl,0x4B
        je .cd
        mov al,[stateA+32+ebx]
        call hex2
        jmp .c2
.cd:    mov ax,'--'
        stosw
.c2:    inc ebx
        test bl,15
        jnz .c3
        call crlf
.c3:    cmp ebx,256
        jb .cr
        mov esi,s_gr                    ; GR
        call str
        xor ebx,ebx
.gr:    mov al,' '
        stosb
        mov al,[stateA+288+ebx]
        call hex2
        inc ebx
        cmp ebx,9
        jb .gr
        call crlf
        mov esi,s_pci                   ; PCI 5333:8901 or 8811 (the Trio64 family), mechanism 1
        call str
        mov dx,0xCF8
        in eax,dx
        mov [cf8],eax
        mov ecx,0x80000000              ; bus 0, device 0..31, function 0
.fd:    mov eax,ecx
        mov dx,0xCF8
        out dx,eax
        mov dx,0xCFC
        in eax,dx
        cmp eax,0x89015333              ; Trio64V2/DX/GX
        je .fo
        cmp eax,0x88115333              ; Trio32, Trio64, Trio64V+
        je .fo
        add ecx,0x800
        cmp ecx,0x80010000
        jb .fd
        mov esi,s_na
        call str
        jmp .pe
.fo:    xor ebx,ebx
.pr:    mov al,' '
        stosb
        mov eax,ecx
        or eax,ebx
        mov dx,0xCF8
        out dx,eax
        mov dx,0xCFC
        in eax,dx
        call hex8
        add ebx,4
        cmp ebx,0x40
        jb .pr
.pe:    mov eax,[cf8]
        mov dx,0xCF8
        out dx,eax
        call crlf
        call crlf
        ret

; Changes from stateA to stateB as "+<ms> NAME old->new" lines at EDI (advanced).
diff:   xor ebx,ebx
.l:     mov al,[stateA+ebx]
        cmp al,[stateB+ebx]
        je .n
        cmp ebx,32+0x45                 ; cursor position, pattern address and colour stack
        jb .y
        cmp ebx,32+0x4F
        jbe .n
.y:     mov al,'+'
        stosb
        mov eax,[t_now]
        call dec32
        mov al,' '
        stosb
        cmp ebx,32
        jb .sr
        cmp ebx,288
        jb .cr
        cmp ebx,297
        je .mi
        mov ax,'GR'
        stosw
        mov eax,ebx
        sub eax,288
        jmp .nm
.mi:    mov esi,s_misc0
        call str
        jmp .v
.sr:    mov ax,'SR'
        stosw
        mov eax,ebx
        jmp .nm
.cr:    mov ax,'CR'
        stosw
        mov eax,ebx
        sub eax,32
.nm:    call hex2
.v:     mov al,' '
        stosb
        mov al,[stateA+ebx]
        call hex2
        mov ax,'->'
        stosw
        mov al,[stateB+ebx]
        call hex2
        call crlf
.n:     inc ebx
        cmp ebx,298
        jb .l
        ret

; ---------------- text helpers ----------------
str:    lodsb                           ; 0-terminated ESI -> EDI
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
hex4:   push eax
        mov al,ah
        call hex2
        pop eax
hex2:   push eax
        shr al,4
        call .n
        pop eax
        push eax
        and al,15
        call .n
        pop eax
        ret
.n:     add al,'0'
        cmp al,'9'
        jbe .o
        add al,7
.o:     stosb
        ret
dec32:  push ebx                        ; EAX unsigned decimal
        push ecx
        push edx
        mov ebx,10
        xor ecx,ecx
.d:     xor edx,edx
        div ebx
        push edx
        inc ecx
        or eax,eax
        jnz .d
.p:     pop eax
        add al,'0'
        stosb
        loop .p
        pop edx
        pop ecx
        pop ebx
        ret

; ---------------- data ----------------
fname   db 'S3REGS.TXT',0
s_head  db 'S3REGS32 ',VERSION,' [',0
s_win   db '] Win32',13,10,0
s_misc  db 'MISC=',0
s_misc0 db 'MISC',0
s_feat  db ' FEAT=',0
s_pel   db ' PEL=',0
s_tick  db ' TICK=',0
s_sr    db 'SR',0
s_cr    db 'CR',0
s_gr    db 'GR00:',0
s_pci   db 'PCI00:',0
s_na    db ' n/a',0
s_snap  db 0
s_watch db 'WATCH ',0
s_watch2 db ' s, changes as +<ms> REG old->new (CR46-4F not compared):',13,10,0
s_end   db 'END OF WATCH',13,10,0
s_ok    db 'S3REGS32 ',VERSION,': written to S3REGS.TXT',13,10,0
s_ferr  db 'S3REGS32 ',VERSION,': cannot write S3REGS.TXT',13,10,0
s_use   db 'S3REGS32 ',VERSION,' - Trio64-family register snapshot from the Windows 9x desktop, appended to S3REGS.TXT',13,10
        db '  S3REGS32 [label]       one snapshot with an optional label',13,10
        db '  S3REGS32 /W n [label]  snapshot, then log every register change for n seconds (every 100 ms)',13,10
        db '  S3REGS32 /H, /?        this help',13,10,0
        align 4
watch_s dd 0
t0      dd 0
t_now   dd 0
t_end   dd 0
wlen    dd 0
written dd 0
hfile   dd 0
cf8     dd 0
crtc    dw 0x3D4
sri     db 0
gri     db 0
cri     db 0
cr38    db 0
cr39    db 0
sr08    db 0
label   times 64 db 0

; imports from KERNEL32.DLL
        align 4
imp:    dd ilt - BASE, 0, 0, dllname - BASE, iat - BASE
        dd 0, 0, 0, 0, 0
imp_end:
%macro IMPORTS 0-*
ilt:
%rep %0
        dd hn_%1 - BASE
%rotate 1
%endrep
        dd 0
iat:
%rep %0
%1:     dd hn_%1 - BASE
%rotate 1
%endrep
        dd 0
%rep %0
hn_%1:  dw 0
        db %str(%1),0
        align 2
%rotate 1
%endrep
%endmacro
        IMPORTS ExitProcess, GetStdHandle, WriteFile, CreateFileA, SetFilePointer, CloseHandle, GetCommandLineA, Sleep, GetTickCount
dllname db 'KERNEL32.DLL',0
        align 16
text_end:
text_size  equ text_end - tstart
text_raw   equ (text_size + 0x1FF) & ~0x1FF
obuf       equ TEXTVA + text_raw            ; uninitialised: output buffer and two register states
stateA     equ obuf + BUFSZ
stateB     equ stateA + STATESZ
text_vsize equ text_raw + BUFSZ + 2*STATESZ
image_size equ 0x1000 + ((text_vsize + 0xFFF) & ~0xFFF)
        times text_raw - text_size db 0
