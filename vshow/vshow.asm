; VSHOW.COM 0.8 - VESA mode viewer for LCD and monitor checks of the Trio64V2/DX VBIOS (386+)
;
; Purpose
;   A visual test: it shows what a VESA mode set by the BIOS looks like on a real monitor, and measures
;   the timing the monitor receives. S3TEST and S3COMPAT check registers; VSHOW checks the picture.
;
; Usage
;   VSHOW                list all VESA modes the BIOS reports (4F00 mode list, 4F01 per mode)
;   VSHOW mode [/L]      set one mode (hex: 106, 0x106 or 106h) and draw the test picture
;   VSHOW /I [/L]        interactive: list of the modes VSHOW can show, arrows select, Enter shows,
;                        any key returns to the list, L toggles the line pattern, Esc quits
;   VSHOW /A [/L]        every graphics mode in turn: picture and info per mode, a beep when the mode
;                        is up, any key for the next mode, Esc stops; a summary is printed at the end
;   VSHOW /H, /?, /HELP  parameter list
;   /L                   alternating 1-pixel vertical lines over the whole screen instead of the bars
;
; The test picture and what to expect
;   16 colour bars           every bar a solid, distinct colour (direct colour modes use the 4F01 masks)
;   single-pixel checkers    bottom half: a sharp, even grey texture; smearing or moire = wrong LCD
;                            clock/phase or a monitor scaler
;   1-pixel white frame      all four edges visible and straight: the visible area is exactly XRes x YRes
;   /L line pattern          sharp vertical lines everywhere when the LCD clock (total pixels per line)
;                            and phase are right; beats or vertical bands when the clock is wrong
;   info box                 mode number and size, measured refresh in Hz, line frequency in kHz and the
;                            total lines from the CRTC; compare with the monitor's OSD and with the
;                            intended timing (for example 1280x1024 DMT: 60.0 Hz, 64.0 kHz, 1066 lines)
;   Errors are printed as "VSHOW 0.8: mode XXXX: <reason>[, BIOS status XXXX]", for example when 4F01
;   or 4F02 fail or the mode is a text mode or uses a memory model VSHOW cannot draw.
;
; Supported: 4 bpp planar, 8 bpp packed and 15/16/24/32 bpp direct colour modes, banked access through
; window A or B with the BIOS window granularity (no LFB use, so it also works without one).
bits 16
cpu 386
org 0x100

; Command line parser: a hex mode number and the switches /L, /A, /I, /H, /?, /HELP.
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
        jcxz .bad
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
        cmp al,'l'
        jne .sw2
        mov byte [lines],1
        jmp .p
.sw2:   cmp al,'a'
        jne .sw3
        mov byte [allm],1
        jmp .p
.sw3:   cmp al,'i'
        jne .sw4
        mov byte [allm],2
        jmp .p
.sw4:   cmp al,'?'
        je .help
        cmp al,'h'
        je .help
.bad:   mov dx,s_bad
        call dputs
        mov dx,s_use
        call dputs
        mov ax,0x4C01
        int 0x21
.help:  mov dx,s_use
        call dputs
        mov ax,0x4C00
        int 0x21
.d:     cmp byte [allm],1
        je runall
        cmp byte [allm],2
        je menu
        jcxz list
        mov [mode],bx
        jmp show

; No mode given: print every mode from the 4F00 list with its 4F01 size and colour depth.
; Expect the standard VESA modes and the S3 extra modes; '(n/a)' marks modes the BIOS lists but cannot
; set with this memory or monitor, 'text' marks text modes.
list:   mov dx,s_use
        call dputs
        mov dword [vib],'VBE2'
        mov ax,0x4F00
        mov di,vib
        int 0x10
        cmp ax,0x004F
        je .ok
        mov dx,s_novbe
        call dputs
        mov ax,0x4C01
        int 0x21
.ok:    mov dx,s_list
        call dputs
        push ds
        lds si,[vib+0x0E]
        mov di,mlist
        mov cx,200
.cp:    lodsw
        mov [es:di],ax
        add di,2
        cmp ax,0xFFFF
        je .cd
        loop .cp
        mov word [es:di],0xFFFF
.cd:    pop ds
        mov si,mlist
        mov byte [ncol],0
.l:     lodsw
        cmp ax,0xFFFF
        je .e
        mov [mode],ax
        push si
        mov ax,0x4F01
        mov cx,[mode]
        mov di,mi
        int 0x10
        cmp ax,0x004F
        jne .n
        mov ax,[mode]
        call dhex4
        mov dl,' '
        call dputc
        movzx eax,word [mi+0x12]
        call ddec
        mov dl,'x'
        call dputc
        movzx eax,word [mi+0x14]
        call ddec
        mov dl,'x'
        call dputc
        movzx eax,byte [mi+0x19]
        call ddec
        test byte [mi],0x10
        jnz .g
        mov dx,s_text
        call dputs
.g:     test byte [mi],1
        jnz .s
        mov dx,s_na
        call dputs
.s:     inc byte [ncol]
        cmp byte [ncol],3
        jb .tab
        mov byte [ncol],0
        mov dx,s_crlf
        call dputs
        jmp .n
.tab:   mov dl,9
        call dputc
        test byte [mi],1
        jnz .n
        cmp byte [mi+0x12],0
.n:     pop si
        jmp .l
.e:     mov dx,s_crlf
        call dputs
        mov ax,0x4C00
        int 0x21

; One mode: picture until a key is pressed, then text mode and one line with the measured values.
show:   call showone
        jnc .ok
        mov dx,[emsg]
        jmp efail
.ok:    xor ah,ah
        int 0x16
        mov ax,3
        int 0x10
        mov dx,s_ver
        call dputs
        mov si,s_info1
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
        int 0x21

sfail:  mov [emsg],dx
        stc
        ret

; set [mode], draw the test picture and the info box; CF + [emsg] on error (no mode change done then,
; except when the mode set itself failed)

; Checks the 4F01 data (supported, graphics, memory model, a readable+writable window), sets the mode,
; draws the picture and measures the timing. Expect the mode set to return 004Fh.
showone:
        mov word [st],0
        mov ax,0x4F01
        mov cx,[mode]
        mov di,mi
        int 0x10
        cmp ax,0x004F
        je .i1
        mov [st],ax
        mov dx,s_e4f01
        jmp sfail
.i1:    test byte [mi],1
        jnz .i2
        mov dx,s_esup
        jmp sfail
.i2:    test byte [mi],0x10
        jnz .i3
        mov dx,s_etext
        jmp sfail
.i3:    mov al,[mi+0x1B]                ; memory model
        mov bl,[mi+0x19]
        cmp al,3
        jne .m4
        cmp bl,4
        je .mok
        jmp .munk
.m4:    cmp al,4
        jne .m6
        cmp bl,8
        je .mok
        jmp .munk
.m6:    cmp al,6
        jne .munk
        cmp bl,15
        jb .munk
        cmp bl,32
        jbe .mok
.munk:  mov dx,s_emodel
        jmp sfail
.mok:   ; window: A if readable+writable, else B
        mov ax,[mi+8]
        mov [wseg],ax
        mov byte [wnum],0
        mov al,[mi+2]
        and al,5
        cmp al,5
        je .w
        mov ax,[mi+0x0A]
        mov [wseg],ax
        mov byte [wnum],1
        mov al,[mi+3]
        and al,5
        cmp al,5
        je .w
        mov dx,s_ewin
        jmp sfail
.w:     movzx eax,word [mi+4]           ; granularity KB
        or eax,eax
        jnz .w2
        mov eax,64
.w2:    shl eax,10
        mov [gran],eax
        movzx eax,word [mi+0x12]
        mov [xres],ax
        movzx eax,word [mi+0x14]
        mov [yres],ax
        mov ax,[mi+0x10]
        mov [pitch],ax
        movzx ax,byte [mi+0x19]
        add ax,7
        shr ax,3
        mov [bpp],ax                    ; bytes per pixel (15 -> 2)
        call mkcol
        mov ax,0x4F02
        mov bx,[mode]
        and bx,0x3FFF
        int 0x10
        cmp ax,0x004F
        je .set
        mov [st],ax
        mov dx,s_e4f02
        jmp sfail
.set:   mov dword [curbank],0xFFFFFFFF
        cmp byte [mi+0x1B],3
        jne .pk
        call planar
        jmp .txt
.pk:    call packed
.txt:   ; info box in the middle
        mov si,s_info1
        call fmt1
        mov ax,[yres]
        shr ax,1
        sub ax,24
        mov [ty],ax
        call drawline
        call measure
        mov si,s_info2
        call fmt2
        add word [ty],16
        call drawline
        call fmt3
        add word [ty],16
        call drawline
        call beep
        clc
        ret

fmt3:   mov di,tbuf
        cmp byte [allm],1
        je .a
        mov si,s_info3
        call cpy
        jmp .z
.a:     cmp byte [allm],2
        jne .a1
        mov si,s_back
        call cpy
        jmp .z
.a1:    mov si,s_m
        call cpy
        movzx eax,word [mnum]
        call bdec
        mov si,s_of
        call cpy
        movzx eax,word [mcnt]
        call bdec
        mov si,s_next
        call cpy
.z:     xor al,al
        stosb
        ret

; /A: every mode VSHOW can show, in list order. Expect a beep for each mode once its picture is up;
; the summary lists each mode with its measured Hz/kHz, or the reason it was skipped.
runall: mov dword [vib],'VBE2'
        mov ax,0x4F00
        mov di,vib
        int 0x10
        cmp ax,0x004F
        je .ok
        mov dx,s_novbe
        call dputs
        mov ax,0x4C01
        int 0x21
.ok:    push ds                         ; copy the mode list
        lds si,[vib+0x0E]
        mov di,mlist
        mov cx,200
.cp:    lodsw
        mov [es:di],ax
        add di,2
        cmp ax,0xFFFF
        je .cd
        loop .cp
        mov word [es:di],0xFFFF
.cd:    pop ds
        mov si,mlist                    ; count them
        xor cx,cx
.cn:    lodsw
        cmp ax,0xFFFF
        je .cc
        inc cx
        jmp .cn
.cc:    mov [mcnt],cx
        mov word [mnum],0
        mov word [rptr],rbuf
        mov word [mptr],mlist
.l:     mov si,[mptr]
        lodsw
        cmp ax,0xFFFF
        je .done
        mov [mptr],si
        inc word [mnum]
        mov [mode],ax
        call showone
        jc .skip
        xor ah,ah                       ; any key: next, Esc: stop
        int 0x16
        mov [lastkey],al
        call fmt1                       ; result line (fmt* write tbuf through DI)
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
        jmp .l
.skip:  mov di,[rptr]                   ; "Mode 0109: is a text mode, skipped"
        mov si,s_m
        call rcpyz
        mov ax,[mode]
        call bhex4
        mov si,s_colon0
        call rcpyz
        mov si,[emsg]
        call rcpyd
        mov si,s_skip
        call rcpyz
        mov [rptr],di
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
        call dputs
        mov dx,rbuf
        call dputz
        mov ax,0x4C00
        int 0x21

; ---------------------------------------------------------------- interactive menu (/I)
LROWS   equ 19                          ; list rows on screen
LTOP    equ 3

; /I: interactive menu over the modes modeok accepts.
menu:   mov dword [vib],'VBE2'
        mov ax,0x4F00
        mov di,vib
        int 0x10
        cmp ax,0x004F
        je .ok
        mov dx,s_novbe
        call dputs
        mov ax,0x4C01
        int 0x21
.ok:    push ds
        lds si,[vib+0x0E]
        mov di,mlist
        mov cx,200
.cp:    lodsw
        mov [es:di],ax
        add di,2
        cmp ax,0xFFFF
        je .cd
        loop .cp
        mov word [es:di],0xFFFF
.cd:    pop ds
        ; keep the modes VSHOW can show
        mov si,mlist
        xor bx,bx                       ; entry count
.f:     lodsw
        cmp ax,0xFFFF
        je .fd
        mov [mode],ax
        push si
        push bx
        mov ax,0x4F01
        mov cx,[mode]
        mov di,mi
        int 0x10
        pop bx
        pop si
        cmp ax,0x004F
        jne .f
        call modeok
        jc .f
        mov di,bx
        shl di,3                        ; 8 bytes: mode, xres, yres, bpp
        mov ax,[mode]
        mov [elist+di],ax
        mov ax,[mi+0x12]
        mov [elist+di+2],ax
        mov ax,[mi+0x14]
        mov [elist+di+4],ax
        movzx ax,byte [mi+0x19]
        mov [elist+di+6],ax
        inc bx
        cmp bx,200
        jb .f
.fd:    mov [ecnt],bx
        mov word [sel],0
        mov word [top],0
        mov byte [stat],0
        or bx,bx
        jnz .draw
        mov dx,s_none
        call dputs
        mov ax,0x4C01
        int 0x21
.draw:  mov ax,3
        int 0x10
        mov ah,1                        ; hide the cursor
        mov cx,0x2000
        int 0x10
        call mdraw
.key:   xor ah,ah
        int 0x16
        cmp al,27
        je .quit
        cmp al,13
        je .show
        or al,0x20
        cmp al,'l'
        jne .k1
        xor byte [lines],1
        call mdraw
        jmp .key
.k1:    mov al,ah
        mov bx,[sel]
        cmp al,0x48                     ; up
        jne .k2
        or bx,bx
        jz .key
        dec bx
        jmp .mv
.k2:    cmp al,0x50                     ; down
        jne .k3
        inc bx
        cmp bx,[ecnt]
        jae .key
        jmp .mv
.k3:    cmp al,0x49                     ; page up
        jne .k4
        sub bx,LROWS
        jns .mv
        xor bx,bx
        jmp .mv
.k4:    cmp al,0x51                     ; page down
        jne .k5
        add bx,LROWS
        cmp bx,[ecnt]
        jb .mv
        mov bx,[ecnt]
        dec bx
        jmp .mv
.k5:    cmp al,0x47                     ; home
        jne .k6
        xor bx,bx
        jmp .mv
.k6:    cmp al,0x4F                     ; end
        jne .key
        mov bx,[ecnt]
        dec bx
.mv:    mov [sel],bx
        call mdraw
        jmp .key
.show:  mov di,[sel]
        shl di,3
        mov ax,[elist+di]
        mov [mode],ax
        call showone
        jc .err
        xor ah,ah
        int 0x16
        call fmt1                       ; status line: last result
        mov di,stat
        mov si,s_last
        call rcpyz
        mov si,tbuf
        call rcpy
        mov si,s_sep2
        call rcpyz
        push di
        call fmt2
        pop di
        mov si,tbuf
        call rcpy
        mov byte [di],0
        jmp .draw
.err:   mov di,stat
        mov si,s_m
        call rcpyz
        mov ax,[mode]
        call bhex4
        mov si,s_colon0
        call rcpyz
        mov si,[emsg]
        call rcpyd
        mov byte [di],0
        jmp .draw
.quit:  mov ax,3
        int 0x10
        mov ax,0x4C00
        int 0x21

; Same acceptance rules as showone, without setting the mode: used to build the menu.
modeok: ; mode info in mi: CF if VSHOW cannot show it (same rules as showone); keeps BX
        push bx
        call .chk
        pop bx
        ret
.chk:   test byte [mi],1
        jz .no
        test byte [mi],0x10
        jz .no
        mov al,[mi+0x1B]
        mov bl,[mi+0x19]
        cmp al,3
        jne .m4
        cmp bl,4
        je .yes
        jmp .no
.m4:    cmp al,4
        jne .m6
        cmp bl,8
        je .yes
        jmp .no
.m6:    cmp al,6
        jne .no
        cmp bl,15
        jb .no
        cmp bl,32
        ja .no
.yes:   clc
        ret
.no:    stc
        ret

mdraw:  ; whole menu screen
        push es
        mov ax,0xB800
        mov es,ax
        xor di,di
        mov ax,0x0720
        mov cx,80*25
        rep stosw
        pop es
        mov si,s_mt1
        mov dx,0x0002
        mov bl,0x0F
        call wtext
        mov si,s_mt2
        mov dx,0x0102
        mov bl,0x07
        call wtext
        mov si,s_pon
        cmp byte [lines],1
        je .pl
        mov si,s_poff
.pl:    mov dx,0x0030
        mov bl,0x0E
        call wtext
        ; keep the selection visible
        mov ax,[sel]
        cmp ax,[top]
        jae .t1
        mov [top],ax
.t1:    mov bx,[top]
        add bx,LROWS
        cmp ax,bx
        jb .t2
        sub ax,LROWS-1
        mov [top],ax
.t2:    xor cx,cx                       ; screen row index
.r:     mov bx,[top]
        add bx,cx
        cmp bx,[ecnt]
        jae .rd
        push cx
        mov di,tbuf                     ; "  0106   1280 x 1024 x 4  "
        mov al,' '
        stosb
        stosb
        mov si,bx
        shl si,3
        mov ax,[elist+si]
        call bhex4
        mov al,' '
        stosb
        stosb
        stosb
        movzx eax,word [elist+si+2]
        call bdec
        mov al,'x'
        stosb
        movzx eax,word [elist+si+4]
        call bdec
        mov al,'x'
        stosb
        movzx eax,word [elist+si+6]
        call bdec
.pad:   cmp di,tbuf+28
        jae .pe
        mov al,' '
        stosb
        jmp .pad
.pe:    xor al,al
        stosb
        pop cx
        push cx
        mov dh,cl
        add dh,LTOP
        mov dl,2
        mov bl,0x07
        mov ax,[top]
        add ax,cx
        cmp ax,[sel]
        jne .nh
        mov bl,0x70
.nh:    mov si,tbuf
        call wtext
        pop cx
        inc cx
        cmp cx,LROWS
        jb .r
.rd:    ; position indicator and status line
        mov di,tbuf
        mov si,s_m
        call cpy
        movzx eax,word [sel]
        inc eax
        call bdec
        mov si,s_of
        call cpy
        movzx eax,word [ecnt]
        call bdec
        xor al,al
        stosb
        mov si,tbuf
        mov dx,(LTOP+LROWS+1)*256+2
        mov bl,0x07
        call wtext
        mov si,stat
        mov dx,0x1802
        mov bl,0x0A
        call wtext
        ret

wtext:  ; SI zero-terminated text, DH row, DL column, BL attribute
        push es
        mov ax,0xB800
        mov es,ax
        movzx ax,dh
        imul ax,ax,80
        movzx cx,dl
        add ax,cx
        shl ax,1
        mov di,ax
        mov ah,bl
.l:     lodsb
        or al,al
        jz .e
        stosw
        jmp .l
.e:     pop es
        ret

rcpy:   lodsb                           ; copy zero-terminated SI to DI (without the zero)
        or al,al
        jz .r
        stosb
        jmp rcpy
.r:     ret
rcpyz:  jmp rcpy
rcpyd:  lodsb                           ; copy '$'-terminated SI to DI
        cmp al,'$'
        je .r
        stosb
        jmp rcpyd
.r:     ret

; Audible confirmation that a mode is up (useful when the monitor shows nothing or 'out of range').
beep:   ; 1 kHz on the PC speaker for about 0.15 s (PIT channel 2)
        push es
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
        mov dx,s_mode
        call dputs
        mov ax,[mode]
        call dhex4
        mov dx,s_colon
        call dputs
        pop dx
        call dputs
        cmp word [st],0
        je .x
        mov dx,s_status
        call dputs
        mov ax,[st]
        call dhex4
.x:     mov dx,s_crlf
        call dputs
        mov ax,0x4C01
        int 0x21

; ---------------------------------------------------------------- colours
; EGA 16 colours as 8-bit RGB; for direct colour modes packed with the 4F01 masks
egargb  db 0,0,0, 0,0,0xAA, 0,0xAA,0, 0,0xAA,0xAA, 0xAA,0,0, 0xAA,0,0xAA, 0xAA,0x55,0, 0xAA,0xAA,0xAA
        db 0x55,0x55,0x55, 0x55,0x55,0xFF, 0x55,0xFF,0x55, 0x55,0xFF,0xFF, 0xFF,0x55,0x55, 0xFF,0x55,0xFF, 0xFF,0xFF,0x55, 0xFF,0xFF,0xFF

; Build the 16 bar colours for the current mode from the 4F01 field sizes and positions, so a wrong
; mask in 4F01 shows up as wrong bar colours.
mkcol:  xor bx,bx
.l:     cmp byte [mi+0x1B],6
        je .d
        movzx eax,bl                    ; palette index
        jmp .s
.d:     xor edx,edx
        imul si,bx,3
        mov al,[egargb+si]              ; red
        mov cl,[mi+0x1F]
        mov ch,[mi+0x20]
        call field
        mov al,[egargb+si+1]
        mov cl,[mi+0x21]
        mov ch,[mi+0x22]
        call field
        mov al,[egargb+si+2]
        mov cl,[mi+0x23]
        mov ch,[mi+0x24]
        call field
        mov eax,edx
.s:     mov di,bx
        shl di,2
        mov [coltab+di],eax
        inc bx
        cmp bx,16
        jb .l
        ret
field:  ; AL 8-bit value, CL size, CH position -> OR into EDX
        push ebx
        push cx
        movzx eax,al
        mov bl,8
        sub bl,cl
        jns .r
        xor bl,bl
.r:     mov cl,bl
        shr eax,cl
        pop cx
        push cx
        mov cl,ch
        shl eax,cl
        or edx,eax
        pop cx
        pop ebx
        ret

; pattern colour (0-15) for pixel CX,BP
patcol: mov ax,cx
        or ax,ax
        jz .w
        inc ax
        cmp ax,[xres]
        je .w
        mov ax,bp
        or ax,ax
        jz .w
        inc ax
        cmp ax,[yres]
        je .w
        cmp byte [lines],1
        jne .bar
        mov al,15
        test cl,1
        jz .r
        xor al,al
.r:     ret
.bar:   mov ax,cx
        shl ax,4
        xor dx,dx
        div word [xres]
        mov bx,bp
        shl bx,1
        cmp bx,[yres]
        jb .r
        mov bx,cx
        xor bx,bp
        test bl,1
        jz .r
        xor al,al
        ret
.w:     mov al,15
        ret

; Packed and direct colour modes: write every pixel through the bank window.
packed: xor bp,bp
.y:     xor cx,cx
.x:     call patcol
        call putpix
        inc cx
        cmp cx,[xres]
        jb .x
        inc bp
        cmp bp,[yres]
        jb .y
        ret

putpix: ; AL colour index at CX,BP (packed/direct, or planar when model 3)
        cmp byte [mi+0x1B],3
        je putpl
        push cx
        movzx ebx,al
        mov eax,[coltab+ebx*4]
        mov [pval],eax
        movzx eax,bp
        movzx ebx,word [pitch]
        imul eax,ebx
        movzx ebx,cx
        movzx edx,word [bpp]
        imul ebx,edx
        add eax,ebx
        mov cx,[bpp]
        mov si,pval
.b:     call addr                       ; EAX linear -> ES:DI
        mov dl,[si]
        mov [es:di],dl
        inc si
        inc eax
        loop .b
        push ds
        pop es
        pop cx
        ret

; Pixel address to bank + offset using the BIOS window granularity, as a VESA 1.2 program does.
addr:   ; EAX linear offset -> ES:DI in the window, switching banks as needed (keeps EAX)
        push eax
        push edx
        push ebx
        xor edx,edx
        div dword [gran]                ; EAX bank, EDX offset in bank
        cmp eax,[curbank]
        je .s
        mov [curbank],eax
        push dx
        mov dx,ax
        mov ax,0x4F05
        movzx bx,byte [wnum]
        int 0x10
        pop dx
.s:     mov di,dx
        mov es,[wseg]
        pop ebx
        pop edx
        pop eax
        ret

; 16-colour planar modes: write mode 2 through the graphics controller, so the same picture appears.
planar: mov dx,0x3CE
        mov ax,0x0005
        out dx,ax
        mov ax,0x0003
        out dx,ax
        mov ax,0xFF08
        out dx,ax
        mov ax,0x0001
        out dx,ax
        xor bp,bp
.y:     xor cx,cx                       ; byte column
.x:     mov ax,cx
        shl ax,3+4
        xor dx,dx
        div word [xres]
        mov [col],al
        mov byte [pat],0xFF
        cmp byte [lines],1
        jne .nl
        mov byte [col],15
        mov byte [pat],0xAA
        jmp .f
.nl:    mov bx,bp
        shl bx,1
        cmp bx,[yres]
        jb .f
        mov byte [pat],0xAA
        test bp,1
        jz .f
        mov byte [pat],0x55
.f:     mov al,0
        or bp,bp
        jz .fw
        mov bx,bp
        inc bx
        cmp bx,[yres]
        je .fw
        or cx,cx
        jnz .fr
        mov al,0x80
.fr:    mov bx,cx
        inc bx
        shl bx,3
        cmp bx,[xres]
        jne .fs
        or al,0x01
.fs:    mov [frm],al
        jmp .wr
.fw:    mov byte [frm],0xFF
.wr:    call putbyte
        inc cx
        mov ax,cx
        shl ax,3
        cmp ax,[xres]
        jb .x
        inc bp
        cmp bp,[yres]
        jb .y
        ret

putbyte:
        movzx eax,bp
        movzx ebx,word [pitch]
        imul eax,ebx
        movzx ebx,cx
        add eax,ebx
        call addr
        mov dx,0x3C4
        mov ax,0x0F02
        out dx,ax
        mov byte [es:di],0
        mov ah,[col]
        mov al,2
        out dx,ax
        mov al,[frm]
        not al
        and al,[pat]
        mov [es:di],al
        mov ax,0x0F02
        out dx,ax
        mov al,[frm]
        or al,al
        jz .n
        mov dx,0x3CE
        mov ah,al
        mov al,8
        out dx,ax
        mov al,[es:di]
        mov byte [es:di],0xFF
        mov ax,0xFF08
        out dx,ax
.n:     push ds
        pop es
        ret

putpl:  ; one planar pixel: colour AL at CX,BP (write mode 2 with bit mask)
        push cx
        push ax
        movzx eax,bp
        movzx ebx,word [pitch]
        imul eax,ebx
        movzx ebx,cx
        shr ebx,3
        add eax,ebx
        call addr
        mov dx,0x3CE
        mov ax,0x0205
        out dx,ax
        and cl,7
        mov ah,0x80
        shr ah,cl
        mov al,8
        out dx,ax
        mov dx,0x3C4
        mov ax,0x0F02
        out dx,ax
        mov al,[es:di]
        pop ax
        mov [es:di],al
        mov dx,0x3CE
        mov ax,0x0005
        out dx,ax
        mov ax,0xFF08
        out dx,ax
        push ds
        pop es
        pop cx
        ret

; Info text drawn with the ROM 8x16 font (AX=1130h BH=6) inside a black box.
drawline:                               ; tbuf centred at row [ty], black box behind it
        push es
        push bp
        mov ax,0x1130
        mov bh,6
        int 0x10
        mov [font],bp
        mov [font+2],es
        pop bp
        pop es
        mov si,tbuf
        xor cx,cx
.n:     lodsb
        or al,al
        jz .c
        inc cx
        jmp .n
.c:     add cx,2
        shl cx,3
        mov ax,[xres]
        sub ax,cx
        shr ax,1
        mov [tx],ax
        ; black box
        mov [tw],cx
        xor di,di
.by:    xor si,si
.bx:    mov cx,[tx]
        add cx,si
        mov bp,[ty]
        add bp,di
        xor al,al
        push si
        push di
        call putpix
        pop di
        pop si
        inc si
        cmp si,[tw]
        jb .bx
        inc di
        cmp di,16
        jb .by
        ; glyphs
        add word [tx],8
        mov word [tch],tbuf
.g:     mov si,[tch]
        lodsb
        or al,al
        jz .done
        mov [tch],si
        movzx bx,al
        shl bx,4
        xor di,di                       ; row
.gr:    push ds
        lds si,[font]
        mov dl,[si+bx]
        pop ds
        mov [grow],dl
        xor si,si                       ; column
.gc:    shl byte [grow],1
        jnc .gn
        mov cx,[tx]
        add cx,si
        mov bp,[ty]
        add bp,di
        mov al,15
        push si
        push di
        push bx
        call putpix
        pop bx
        pop di
        pop si
.gn:    inc si
        cmp si,8
        jb .gc
        inc bx
        inc di
        cmp di,16
        jb .gr
        add word [tx],8
        jmp .g
.done:  ret

; ---------------------------------------------------------------- text formatting into tbuf
fmt1:   ; "Mode 0106  1280x1024x4"
        mov di,tbuf
        mov si,s_m
        call cpy
        mov ax,[mode]
        call bhex4
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
        movzx eax,byte [mi+0x19]
        call bdec
        xor al,al
        stosb
        ret
fmt2:   ; "60.2 Hz  64.0 kHz  1066 lines total"
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
        ret
cpy:    lodsb
        or al,al
        jz .r
        stosb
        jmp cpy
.r:     ret
bhex4:  push ax
        mov al,ah
        call bhex2
        pop ax
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
        mov dx,0x3DA
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

; Refresh: PIT channel 0 in mode 2, 30 frames between rising edges of 3DAh bit 3, Hz x 10 =
; 30 * 1193182 * 10 / counts. Line frequency: Hz times the CRTC vertical total (CR06, CR07 bits 0/5,
; CR5E bit 0, plus 2). Expect both to match the monitor OSD within about 0.1 Hz and 0.1 kHz.
measure:
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
        mov cx,30
.l:     call waitvr
        jc .z
        loop .l
        mov ecx,[pel]
        sub ecx,[t0]
        jz .z
        mov eax,357954600               ; 30 frames * 1193182 Hz * 10
        xor edx,edx
        div ecx
        mov [hz],ax
.z:     pushf
        cli
        mov al,0x36                     ; ch0 back to mode 3
        out 0x43,al
        xor al,al
        out 0x40,al
        out 0x40,al
        popf
        ; vertical total from the CRTC (incl. S3 CR5E bit 0) -> line frequency
        mov dx,0x3D4
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
dhex4:  push ax
        mov al,ah
        call dhex2
        pop ax
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
ddec:   push di
        mov di,nbuf
        call bdec
        mov byte [di],0
        mov dx,nbuf
        call dputz
        pop di
        ret

s_use   db 'VSHOW 0.8 - VESA mode viewer for monitor and LCD checks',13,10
        db '  VSHOW               list the VESA modes the BIOS reports',13,10
        db '  VSHOW mode [/L]     show one mode; mode in hex: 106, 0x106 or 106h',13,10
        db '  VSHOW /I [/L]       interactive: arrows select a mode, Enter shows it,',13,10
        db '                      any key returns to the list, L toggles the pattern, Esc quits',13,10
        db '  VSHOW /A [/L]       every graphics mode in turn: beep when shown,',13,10
        db '                      any key = next mode, Esc = stop, summary at the end',13,10
        db '  /L                  1-pixel vertical line pattern (LCD clock/phase adjustment)',13,10
        db '                      instead of the colour bars',13,10
        db '  /H, /?, /HELP       this help',13,10
        db 'Each mode shows a white frame, the pattern, the mode, measured refresh,',13,10
        db 'line frequency and total lines; any key returns.',13,10,'$'
s_bad   db 'VSHOW 0.8: bad argument.',13,10,13,10,'$'
s_novbe db 'VSHOW 0.8: no VESA BIOS (4F00 failed).',13,10,'$'
s_list  db 13,10,'Mode  Resolution',13,10,'$'
s_text  db ' text$'
s_na    db ' (n/a)$'
s_crlf  db 13,10,'$'
s_mode  db 'VSHOW 0.8: mode $'
s_colon db ': $'
s_status db ', BIOS status $'
s_e4f01 db 'mode info (4F01) failed$'
s_esup  db 'not supported with this memory/monitor$'
s_etext db 'is a text mode$'
s_emodel db 'memory model / colour depth not supported by VSHOW$'
s_ewin  db 'no readable+writable window$'
s_e4f02 db 'mode set (4F02) failed$'
s_sep   db ', $'
s_ver   db 'VSHOW 0.8: $'
s_m     db 'Mode ',0
s_hz    db ' Hz  ',0
s_khz   db ' kHz  ',0
s_lines db ' lines total',0
s_info1 db 0
s_info2 db 0
s_info3 db 'Press any key',0
s_back  db 'Any key: back to the list',0
s_last  db 'Last: ',0
s_mt1   db 'VSHOW 0.8 - supported graphics modes',0
s_mt2   db 'Up/Down/PgUp/PgDn select, Enter show, L line pattern, Esc quit',0
s_pon   db '  [pattern: lines] ',0
s_poff  db '  [pattern: bars]  ',0
s_none  db 'VSHOW 0.8: no graphics mode VSHOW can show.',13,10,'$'
s_of    db ' of ',0
s_next  db ': any key = next mode, Esc = stop',0
s_sep2  db ', ',0
s_crlf0 db 13,10,0
s_colon0 db ': ',0
s_skip  db ', skipped',13,10,0
s_stopped db 'Stopped with Esc.',13,10,0
s_res   db 'VSHOW 0.8 /A results:',13,10,'$'

lines   db 0
allm    db 0
lastkey db 0
wnum    db 0
ncol    db 0
col     db 0
pat     db 0
frm     db 0
grow    db 0
mode    dw 0
emsg    dw 0
mnum    dw 0
mcnt    dw 0
rptr    dw 0
mptr    dw 0
st      dw 0
wseg    dw 0
xres    dw 0
yres    dw 0
pitch   dw 0
bpp     dw 0
tx      dw 0
ty      dw 0
tw      dw 0
tch     dw 0
hz      dw 0
khz     dw 0
vtot    dw 0
pprev   dw 0
align 4
gran    dd 0
curbank dd 0
pval    dd 0
pel     dd 0
pwt     dd 0
t0      dd 0
font    dd 0
coltab  times 16 dd 0
tbuf    times 80 db 0
nbuf    times 16 db 0
section .bss
mi      resb 256
vib     resb 512
mlist   resb 420
rbuf    resb 8192
elist   resb 1600
stat    resb 100
ecnt    resw 1
sel     resw 1
top     resw 1
