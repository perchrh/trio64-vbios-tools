; VGASHOW.COM - standard video mode viewer (MDA/CGA/EGA/VGA modes 00h-13h) for monitor and LCD checks
; of the Trio64-family VBIOS (386+). VBESHOW shows the VESA modes (4F00 list, set with 4F02); VGASHOW
; shows every mode before VBE, set with INT 10h AH=00h.
;
; Purpose
;   A visual test of the standard modes: it sets each mode, fills the screen with a test pattern and
;   measures the timing the monitor receives (refresh and line frequency from the PIT and the CRTC,
;   as VBESHOW does). S3TEST and S3COMPAT check registers; VGASHOW checks the picture of the
;   standard modes, which VBESHOW never sets.
;
; Usage
;   VGASHOW                list the 15 standard modes with their resolution and colour depth
;   VGASHOW mode [/S]      set one mode (hex: 0D, 0x0D or 0Dh) and show it; any key returns
;   VGASHOW /A [/S]        every mode in turn, in order 00h-13h: a beep when the mode is up, any
;                          key for the next, Esc stops; a summary is printed at the end
;   VGASHOW /R [/S]        robot: as /A, but each mode stays about 0.5 s (9 BIOS ticks) and no key
;                          is needed (Esc still stops); for logs: VGASHOW /R /V > VGASHOW.LOG
;   /V                     debug log in VGASHOW.DBG (see src/tools/common/vdebug.inc): the NASM
;                          version, the ROM version, every INT 10h call, registers and per-frame
;                          timer counts of each mode shown
;   /S                     silent: no key waits (batch runs, the emulator)
;   /H, /?, /HELP          parameter list
;
; The test pattern and what to expect
;   Text modes (00h-03h, 07h): a large checker of 0xDB and space on B800h (B000h in 07h), cursor
;   hidden. Graphics modes: 16 vertical bars, written directly to A0000h (planar modes with the
;   graphics controller map mask set to all planes; CGA modes 04h-06h get their interleaved 16 KB
;   filled). After each mode the result line prints: mode, resolution, colour depth, measured
;   refresh in Hz, line frequency in kHz and the CRTC total lines, e.g. mode 12h:
;   "Mode 12h  640x480x16 graphics, 60.0 Hz  31.5 kHz  525 lines total". Compare with the monitor's
;   OSD. Expected on the current ROM (standard timings): 07h 720x400 70.1 Hz 31.5 kHz 449 lines,
;   03h 640x350 70.1 Hz 31.5 kHz 449 lines, 12h 640x480 60.0 Hz 31.5 kHz 525 lines,
;   13h 320x200 70.1 Hz 31.5 kHz 449 lines.
;   The CRTC and status ports come from MISC (3CCh) bit 0, so the mono modes (07h, 0Fh) are measured
;   at 3B4h/3BAh, where 3D4h/3DAh are not decoded (#193).
;   All standard modes are at most 31.5 kHz line frequency and 70 Hz, safe for every VGA monitor;
;   no monitor warning is printed.
;
; Emulator test (emu/tests.py t_vgashow): the list prints all 15 modes; "VGASHOW 13" exits 0 and
; prints the result line with Hz and kHz; /R /S runs through all 15 modes without keys and prints
; the "/R results:" summary with a line per mode; /V writes VGASHOW.DBG with D:TEST mode, D:REG and
; D:FRM records. All PASS on the current ROMs.
;
; Cleanroom rule (AGENTS.md): VGASHOW stays cleanroom permissible. It observes (measures, fills,
; prints) and every expectation comes from a public source (IBM mode timings); nothing in it may be
; taken from a reference or patched ROM - a mode list, a register value, a timing or a tolerance.
; Such a change needs an owner decision first and drops the `cleanroom` tag of the `vgashow`
; emulator test (#201).
bits 16
cpu 386
org 0x100
%include "version.inc"
%include "vdebug.mac"

; Command line parser: a hex mode number and the switches /A, /R, /V, /S, /H, /?, /HELP.
; Anything else prints "bad argument" and the usage text.
start:  cld
        mov si,0x81
        xor bx,bx
        xor cx,cx                       ; digits seen
.p:     lodsb
        cmp al,13
        je .d
        cmp al,' '
        je .sep
        cmp al,9
        je .sep
        cmp al,'/'
        je .sw
        cmp al,'-'
        je .sw
        cmp al,'0'                      ; 0x prefix
        jne .h
        cmp byte [si],'x'
        je .x
        cmp byte [si],'X'
        jne .h
.x:     inc si
        jmp .p
.h:     mov ah,al
        or ah,0x20
        cmp ah,'h'                      ; trailing h
        jne .h1
        or cx,cx
        jz .bad
        jmp .p
.h1:    sub al,'0'
        cmp al,9
        jbe .dig
        mov al,ah
        sub al,'a'
        cmp al,5
        ja .bad
        add al,10
.dig:   shl bx,4
        or bl,al
        inc cx
        cmp cx,4
        ja .bad
        jmp .p
.sep:   jmp .p
.sw:    lodsb
        or al,0x20
        mov ah,al
.swe:   mov al,[si]                     ; skip the rest of the switch word (/help)
        cmp al,' '
        je .swd
        cmp al,13
        je .swd
        cmp al,'/'
        je .swd
        cmp al,'-'
        je .swd
        inc si
        jmp .swe
.swd:   mov al,ah
        cmp al,'a'
        jne .sw2
        mov byte [allm],1
        jmp .p
.sw2:   cmp al,'r'                      ; /R robot: /A without keys
        jne .sw3
        mov byte [allm],1
        mov byte [robot],1
        jmp .p
.sw3:   cmp al,'v'
        jne .sw4s
        mov byte [vreq],1
        jmp .p
.sw4s:  cmp al,'s'
        jne .sw5
        mov byte [silent],1
        jmp .p
.sw5:   cmp al,'?'
        je .help
        cmp al,'h'
        je .help
.bad:   mov dx,s_bad
        call dputs
        mov dx,s_use
        call dputs
        mov ax,0x4C01
        jmp vexit
.help:  mov dx,s_use
        call dputs
        mov ax,0x4C00
        jmp vexit
.d:     cmp byte [vreq],1               ; /V: debug log in VGASHOW.DBG
        jne .d1
        push bx
        push cx
        mov ax,cs
        add ax,0x2000
        cmp ax,[2]
        ja .vm
        sub ax,0x1000
        mov dx,s_vname
        call vinit
        jmp .vd
.vm:    mov dx,s_vnomem
        call dputs
.vd:    pop cx
        pop bx
.d1:    cmp byte [allm],1
        je runall
        jcxz list
        mov [mode],bx
        jmp show

; No mode given: print the usage and every standard mode with its resolution and colour depth.
list:   mov dx,s_use
        call dputs
        mov dx,s_list
        call dputs
        mov si,mtab
        mov cx,MTN
.l:     mov ah,0
        mov al,[si]
        mov [mode],ax
        call loadent
        call fmt1
        mov dx,tbuf
        call dputz
        mov dx,s_crlf
        call dputs
        mov si,[entp]                   ; fmt1 clobbered SI
        add si,11
        loop .l
        mov ax,0x4C00
        jmp vexit

; One mode: show it, wait for a key (unless /S), then mode 03h and the result line.
show:   call showone
        jnc .ok
        mov dx,[emsg]
        jmp efail
.ok:    cmp byte [silent],1
        je .p
        xor ah,ah
        int 0x16
.p:     mov ax,3
        int 0x10
        mov dx,s_ver
        call dputs
        call fmt1
        mov dx,tbuf
        call dputz
        mov dx,s_sep
        call dputs
        call fmt2
        mov dx,tbuf
        call dputz
        mov dx,s_crlf
        call dputs
        mov ax,0x4C00
        jmp vexit

sfail:  mov [emsg],dx
        stc
        ret

; ---------------------------------------------------------------- mode table
; 11 bytes per entry: db mode, db kind (0 text, 1 packed 8bpp, 2 planar, 3 CGA), dw xres, dw yres,
; db colours, dw bytes-per-line, dw text segment. Resolutions and colour depths are the IBM
; standard mode attributes (public); the fill patterns below are ours.
mtab:   db 0x00, 0
        dw 320, 200
        db 16
        dw 0
        dw 0xB800
        db 0x01, 0
        dw 640, 200
        db 16
        dw 0
        dw 0xB800
        db 0x02, 0
        dw 640, 350
        db 16
        dw 0
        dw 0xB800
        db 0x03, 0
        dw 640, 350
        db 16
        dw 0
        dw 0xB800
        db 0x04, 3
        dw 320, 200
        db 4
        dw 80
        dw 0
        db 0x05, 3
        dw 320, 200
        db 4
        dw 80
        dw 0
        db 0x06, 3
        dw 640, 200
        db 2
        dw 80
        dw 0
        db 0x07, 0
        dw 720, 400
        db 2
        dw 0
        dw 0xB000
        db 0x0D, 2
        dw 320, 200
        db 16
        dw 40
        dw 0
        db 0x0E, 2
        dw 640, 200
        db 16
        dw 80
        dw 0
        db 0x0F, 2
        dw 640, 350
        db 2
        dw 80
        dw 0
        db 0x10, 2
        dw 640, 350
        db 16
        dw 80
        dw 0
        db 0x11, 2
        dw 640, 480
        db 2
        dw 80
        dw 0
        db 0x12, 2
        dw 640, 480
        db 16
        dw 80
        dw 0
        db 0x13, 1
        dw 320, 200
        db 8
        dw 320
        dw 0
MTN     equ 15

; loadent: SI = mtab entry -> [entp],[kind],[xres],[yres],[ncol],[bpline],[tseg]; keeps SI
loadent: mov [entp],si
        mov al,[si+1]
        mov [kind],al
        mov ax,[si+2]
        mov [xres],ax
        mov ax,[si+4]
        mov [yres],ax
        mov al,[si+6]
        mov [ncol],al
        mov ax,[si+7]
        mov [bpline],ax
        mov ax,[si+9]
        mov [tseg],ax
        ret

; showone: set [mode] with AH=00h, pick the CRTC/status ports from MISC bit 0, draw the pattern,
; measure. CF + [emsg] on failure.
showone: mov si,mtab
        mov cx,MTN
        mov al,[mode]
.f:     cmp [si],al
        je .found
        add si,11
        loop .f
        mov dx,s_badmode
        jmp sfail
.found: call loadent
        VS 'D:TEST mode '
        push ax
        mov ax,[mode]
        call vhex4
        pop ax
        call vnl
        call vflush
        mov ah,0                        ; AH=00h: set mode, clear memory
        mov al,[mode]
        int 0x10
        mov dx,0x3CC                    ; MISC: bit 0 selects the CRTC port pair
        in al,dx
        test al,1                       ; colour: 3D4h/3DAh; mono: 3B4h/3BAh, where 3D4h is not decoded
        mov ax,0x3D4
        mov cx,0x3DA
        jnz .col
        mov ax,0x3B4
        mov cx,0x3BA
.col:   mov [crtcp],ax
        mov [statusp],cx
        cmp byte [kind],0
        jne .g
        call textfill
        jmp .m
.g:     call gfxfill
.m:     call measure
        call vframes                    ; /V: raw timing, registers of the mode as shown
        call vregs
        call vflush
        call beep
        clc
        ret

; ---------------------------------------------------------------- pattern drawing
; textfill: checker of 0xDB/space on the text segment, cursor hidden. Uses the BDA columns/rows.
textfill: push ds
        push es
        mov ax,0x0100                   ; hide the cursor
        mov cx,0x2000
        int 0x10
        mov ax,[tseg]
        mov es,ax
        mov ax,0x0040
        mov ds,ax
        movzx cx,word [0x004A]          ; columns
        movzx bx,byte [0x0084]
        inc bx                          ; rows
        pop ds
        xor di,di
        xor dx,dx                       ; row
.trow:  push cx
        xor si,si                       ; column
.tcol:  mov ax,si
        add ax,dx
        shr ax,3
        test al,1
        mov al,0x20
        je .sp
        mov al,0xDB
.sp:    mov ah,0x07
        stosw
        inc si
        cmp si,cx
        jb .tcol
        pop cx
        inc dx
        cmp dx,bx
        jb .trow
        pop es
        ret

; gfxfill: 16 vertical bars in A0000h. Planar modes: map mask all planes, one byte = 8 pixels of the
; bar colour. Packed 13h: one byte per pixel. CGA modes: the interleaved 16 KB filled linearly with
; a 64-byte pattern. One line of the pattern is built in [pat], then copied per row.
gfxfill: push ds
        push es
        mov ax,cs
        mov ds,ax
        cmp byte [kind],3               ; CGA: 64-byte pattern over all 16 KB
        jne .pb
        mov word [bpline],64
.pb:    mov di,pat
        mov cx,[bpline]
        xor bx,bx                       ; column
.pl:    mov ax,bx
        movzx eax,ax
        movzx ecx,byte [ncol]
        mul ecx                         ; col * colours
        mov cx,[bpline]
        div cx                          ; AX = bar 0..ncol-1
        cmp byte [kind],3
        jne .np
        cmp byte [ncol],2               ; 640x200x2: one bit per pixel
        jne .c4
        test al,1
        jz .z
        mov al,0xFF
        jmp .st
.z:     xor al,al
        jmp .st
.c4:    mov ah,0x55                     ; 320x200x4: four 2-bit pixels per byte
        mul ah
        jmp .st
.np:    ; packed or planar: the byte is the colour index
.st:    stosb
        inc bx
        cmp bx,[bpline]
        jb .pl
        mov ax,0xA000
        mov es,ax
        xor di,di
        cmp byte [kind],3
        jne .nr
        mov cx,256                      ; 0x4000 / 64
        jmp .fr
.nr:    movzx eax,word [yres]
        mov cx,ax
.fr:    push cx
        mov cx,[bpline]
        mov si,pat
        rep movsb
        pop cx
        loop .fr
        cmp byte [kind],2               ; planar: put the map mask back to one plane
        jne .done
        mov dx,0x3CE
        mov al,6
        out dx,al
        inc dx
        mov al,1
        out dx,al
.done:  pop es
        pop ds
        ret

; ---------------------------------------------------------------- /A and /R
; Every mode in turn, 00h-13h. A beep for each mode once its pattern is up; any key for the next
; mode (Esc stops), or about 0.5 s each with /R. The summary lists each mode with the measured
; Hz/kHz and lines.
runall: mov word [rptr],rbuf
        mov si,mtab
        mov word [mnum],0
        mov byte [lastkey],0
.l:     mov ax,si
        sub ax,mtab
        cmp ax,MTN*11
        jae .done                       ; all 15 entries shown
        mov ah,0
        mov al,[si]
        mov [mode],ax
        inc word [mnum]
        call showone
        jc .skip
        cmp byte [robot],1
        je .r
        cmp byte [silent],1
        je .k1
        xor ah,ah
        int 0x16
        mov [lastkey],al
        jmp .k1
.r:     call rwait
        mov [lastkey],al
.k1:    call fmt1
        mov di,[rptr]
        mov si,tbuf
        call rcpy
        mov si,s_sep2
        call rcpyz
        mov [rptr],di
        call fmt2
        mov di,[rptr]
        mov si,tbuf
        call rcpy
        mov si,s_crlf0
        call rcpyz
        mov [rptr],di
        cmp byte [lastkey],27
        je .stop
        mov si,[entp]
        add si,11
        jmp .l
.skip:  mov di,[rptr]
        mov si,s_m
        call rcpyz
        mov al,[mode]
        call bhex2
        mov al,'h'
        stosb
        mov si,s_colon0
        call rcpyz
        mov si,[emsg]
        call rcpyd
        mov si,s_skip
        call rcpyz
        mov [rptr],di
        mov si,[entp]
        add si,11
        jmp .l
.stop:  mov di,[rptr]
        mov si,s_stopped
        call rcpyz
        mov [rptr],di
.done:  mov ax,3
        int 0x10
        mov di,[rptr]
        mov byte [di],0
        mov dx,s_res
        cmp byte [robot],1
        jne .rh
        mov dx,s_resr
.rh:    call dputs
        mov dx,rbuf
        call dputz
        mov ax,0x4C00
        jmp vexit

rcpy:   lodsb                           ; copy zero-terminated SI to DI (without the zero)
        or al,al
        jz .r
        stosb
        jmp rcpy
.r:     ret
rcpyz:  jmp rcpy                        ; zero-terminated, like rcpy
rcpyd:  lodsb                           ; copy '$'-terminated SI to DI (the emsg strings)
        cmp al,'$'
        je .r
        stosb
        jmp rcpyd
.r:     ret

rwait:  push es
        push bx
        xor ax,ax
        mov es,ax
        mov bx,[es:0x46C]
.w:     mov ah,1                        ; a key waiting?
        int 0x16
        jz .n
        xor ah,ah
        int 0x16
        cmp al,27
        je .x
.n:     mov ax,[es:0x46C]
        sub ax,bx
        cmp ax,9
        jb .w
        xor al,al
.x:     pop bx
        pop es
        ret

beep:   ; 1 kHz on the PC speaker for about 0.15 s (PIT channel 2)
        cmp byte [robot],1              ; /R: no beep
        jne .b
        ret
.b:     push es
        mov al,0xB6
        out 0x43,al
        mov ax,1193
        out 0x42,al
        mov al,ah
        out 0x42,al
        in al,0x61
        or al,3
        out 0x61,al
        xor ax,ax
        mov es,ax
        mov bx,[es:0x46C]
        add bx,3
.w:     cmp bx,[es:0x46C]
        jne .w
        in al,0x61
        and al,0xFC
        out 0x61,al
        pop es
        ret

efail:  push dx
        mov ax,3
        int 0x10
        mov dx,s_mode
        call dputs
        mov al,[mode]
        call dhex2
        mov dx,s_colon
        call dputs
        pop dx
        call dputs
        mov dx,s_crlf
        call dputs
        mov ax,0x4C01
        jmp vexit

; ---------------------------------------------------------------- text formatting into tbuf
fmt1:   ; "Mode 07h  720x400x2 text"
        push es
        mov ax,ds
        mov es,ax                       ; stosb below writes tbuf in the data segment
        mov di,tbuf
        mov si,s_m
        call cpy
        mov al,[mode]
        call bhex2
        mov al,'h'
        stosb
        mov al,' '
        stosb
        stosb
        movzx eax,word [xres]
        call bdec
        mov al,'x'
        stosb
        movzx eax,word [yres]
        call bdec
        mov al,'x'
        stosb
        movzx eax,byte [ncol]
        call bdec
        cmp byte [kind],0
        jne .g
        mov si,s_text
        call cpy
        jmp .z
.g:     mov si,s_gfx
        call cpy
.z:     xor al,al
        stosb
        pop es
        ret
fmt2:   ; "70.1 Hz  31.5 kHz  449 lines total"
        push es
        mov ax,ds
        mov es,ax
        mov di,tbuf
        movzx eax,word [hz]
        call bdec10
        mov si,s_hz
        call cpy
        movzx eax,word [khz]
        call bdec10
        mov si,s_khz
        call cpy
        movzx eax,word [vtot]
        call bdec
        mov si,s_lines
        call cpy
        xor al,al
        stosb
        pop es
        ret
cpy:    lodsb
        or al,al
        jz .r
        stosb
        jmp cpy
.r:     ret
bhex2:  push ax
        shr al,4
        call .n
        pop ax
        and al,15
.n:     add al,'0'
        cmp al,'9'
        jbe .o
        add al,7
.o:     stosb
        ret
bdec:   push ebx
        push ecx
        push edx
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
        stosb
        loop .p
        pop edx
        pop ecx
        pop ebx
        ret
bdec10: xor edx,edx
        mov ebx,10
        div ebx
        push dx
        call bdec
        mov al,'.'
        stosb
        pop ax
        add al,'0'
        stosb
        ret

; ---------------------------------------------------------------- refresh measurement (PIT ch0)
rdcnt:  xor al,al
        out 0x43,al
        in al,0x40
        mov ah,al
        in al,0x40
        xchg al,ah
        ret
pupd:   push ax
        push bx
        call rdcnt
        mov bx,[pprev]
        mov [pprev],ax
        sub bx,ax
        movzx ebx,bx
        add [pel],ebx
        add [pwt],ebx
        pop bx
        pop ax
        ret
waitvr: mov dword [pwt],0
        mov dx,[statusp]                ; 3DAh colour, 3BAh mono (MISC bit 0)
.a:     call pupd
        cmp dword [pwt],300000
        ja .t
        in al,dx
        test al,8
        jnz .a
.b:     call pupd
        cmp dword [pwt],300000
        ja .t
        in al,dx
        test al,8
        jz .b
        clc
        ret
.t:     stc
        ret

; Refresh: PIT channel 0 in mode 2, 30 frames between rising edges of the status port's bit 3,
; Hz x 10 = 1193182 * 10 / median counts per frame. Line frequency: Hz times the CRTC vertical
; total (CR06, CR07 bits 0/5, S3 CR5E bit 0, plus 2), read at the port MISC bit 0 selected.
measure:
        mov word [vfrn],0
        mov word [hz],0
        mov word [khz],0
        pushf
        cli
        mov al,0x34                     ; ch0 mode 2, same 18.2 Hz rate
        out 0x43,al
        xor al,al
        out 0x40,al
        out 0x40,al
        popf
        call rdcnt
        mov [pprev],ax
        mov dword [pel],0
        call waitvr
        jc .z
        mov eax,[pel]
        mov [t0],eax
        push di
        mov di,vfr                      ; PIT count at every retrace start, for /V
        mov [di],eax
        mov word [vfrn],1
        mov cx,30
.l:     call waitvr
        jc .zd
        add di,4
        mov eax,[pel]
        mov [di],eax
        inc word [vfrn]
        loop .l
        pop di
        call vmedian                    ; median frame period: robust against one long interrupt
        or eax,eax
        jz .z
        mov ecx,eax
        mov eax,11931820                ; Hz*10 = 1193182 * 10 / counts per frame
        xor edx,edx
        div ecx
        mov [hz],ax
.z:     cmp byte [vflag],1              ; /V keeps mode 2 for its call timing (vdone restores)
        je .z3
        pushf
        cli
        mov al,0x36                     ; ch0 back to mode 3
        out 0x43,al
        xor al,al
        out 0x40,al
        out 0x40,al
        popf
.z3:    ; vertical total from the CRTC at [crtcp] (incl. S3 CR5E bit 0) -> line frequency
        mov dx,[crtcp]
        mov ax,0x4838
        out dx,ax
        mov ax,0xA539
        out dx,ax
        mov al,6
        out dx,al
        inc dx
        in al,dx
        movzx bx,al
        dec dx
        mov al,7
        out dx,al
        inc dx
        in al,dx
        dec dx
        test al,1
        jz .v1
        add bx,0x100
.v1:    test al,0x20
        jz .v2
        add bx,0x200
.v2:    mov al,0x5E
        out dx,al
        inc dx
        in al,dx
        test al,1
        jz .v3
        add bx,0x400
.v3:    add bx,2
        mov [vtot],bx
        movzx eax,word [hz]             ; kHz*10 = Hz*10 * lines / 1000
        movzx ebx,bx
        imul eax,ebx
        xor edx,edx
        mov ebx,1000
        div ebx
        mov [khz],ax
        ret
.zd:    pop di                          ; timeout inside the frame loop
        jmp .z

; ---------------------------------------------------------------- /V helpers and exit
vexit:  push ax                         ; AX = exit code (AH=4Ch on entry)
        mov bx,1
        mov ah,0x68                     ; commit a redirected log
        int 0x21
        call vdone                      ; close the /V log
        mov ah,0x0D                     ; SMARTDRV: the log and VGASHOW.DBG
        int 0x21
        pop ax
        int 0x21

; /V debug log (shared with VBESHOW, S3TEST and S3COMPAT)
%include "vdebug.inc"

; ---------------------------------------------------------------- DOS output
dputs:  mov ah,9
        int 0x21
        ret
dputz:  push si
        mov si,dx
.l:     lodsb
        or al,al
        jz .e
        mov dl,al
        mov ah,2
        int 0x21
        jmp .l
.e:     pop si
        ret
dputc:  mov ah,2
        int 0x21
        ret
dhex2:  push ax
        shr al,4
        call .n
        pop ax
        and al,15
.n:     add al,'0'
        cmp al,'9'
        jbe .o
        add al,7
.o:     mov dl,al
        push ax
        mov ah,2
        int 0x21
        pop ax
        ret

; ---------------------------------------------------------------- data
s_use   db 'VGASHOW ',VERSION,' - standard video mode viewer (MDA/CGA/EGA/VGA modes 00h-13h)',13,10
        db '  VGASHOW               list the 15 standard modes with resolution and colour depth',13,10
        db '  VGASHOW mode [/S]     show one mode; mode in hex: 0D, 0x0D or 0Dh; any key returns',13,10
        db '  VGASHOW /A [/S]       every mode in turn (00h-13h): beep when shown,',13,10
        db '                        any key = next mode, Esc = stop, summary at the end',13,10
        db '  VGASHOW /R [/S]       robot: as /A, each mode about 0.5 s, no keys (Esc stops); for',13,10
        db '                        logs of every mode switch, e.g. VGASHOW /R /V > VGASHOW.LOG',13,10
        db '  /V                    debug log: ROM version, BIOS calls, registers and timing in VGASHOW.DBG',13,10
        db '  /S                    silent: no key waits',13,10
        db '  /H, /?, /HELP         this help',13,10
        db 'Each mode shows a test pattern (checker in text modes, 16 bars in graphics modes),',13,10
        db 'then the result line: mode, resolution, measured refresh, line frequency and total',13,10
        db 'lines; any key returns. All standard modes are at most 31.5 kHz and 70 Hz, safe for',13,10
        db 'every VGA monitor.',13,10,'$'
s_vname db 'VGASHOW.DBG',0
s_vnomem db 'VGASHOW ',VERSION,': not enough memory for the /V debug buffer, /V ignored.',13,10,'$'
s_bad   db 'VGASHOW ',VERSION,': bad argument.',13,10,13,10,'$'
s_badmode db 'no such mode (00h-13h)$'
s_list  db 13,10,'Mode  Resolution',13,10,'$'
s_crlf  db 13,10,'$'
s_mode  db 'VGASHOW ',VERSION,': mode $'
s_colon db ': $'
s_ver   db 'VGASHOW ',VERSION,': $'
s_m     db 'Mode ',0
s_text  db ' text',0
s_gfx   db ' graphics',0
s_hz    db ' Hz  ',0
s_khz   db ' kHz  ',0
s_lines db ' lines total',0
s_sep   db ', $'
s_sep2  db ', ',0
s_crlf0 db 13,10,0
s_colon0 db ': ',0
s_skip  db ', skipped',13,10,0
s_stopped db 'Stopped with Esc.',13,10,0
s_res   db 'VGASHOW ',VERSION,' /A results:',13,10,'$'
s_resr  db 'VGASHOW ',VERSION,' /R results:',13,10,'$'

silent  db 0
allm    db 0
robot   db 0
vreq    db 0
lastkey db 0
mode    dw 0
emsg    dw 0
entp    dw 0
mnum    dw 0
rptr    dw 0
kind    db 0
ncol    db 0
crtcp   dw 0
statusp dw 0
xres    dw 0
yres    dw 0
bpline     dw 0
tseg    dw 0
hz      dw 0
khz     dw 0
vtot    dw 0
pprev   dw 0
align 4
pel     dd 0
pwt     dd 0
t0      dd 0
tbuf    times 96 db 0
pat     times 320 db 0
section .bss
rbuf    resb 4096
