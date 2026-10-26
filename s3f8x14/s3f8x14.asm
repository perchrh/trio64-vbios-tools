; S3F8X14.COM - 8x14 font TSR for VGA BIOSes without one (made for the Trio64V2/DX VBIOS 2.x)
;
; Purpose
;   S3's BIOS 2.04.x has no 8x14 font: INT 10h AX=1130h BH=02h returns its 8x16 table and BH=05h its
;   9x16 alternates. Where the IBM BIOS uses the 8x14 font, 2.04.x loads the first 14 rows of every
;   8x16 character (cut descenders and box characters): in 350-line text modes (00h-03h after
;   AX=1201h BL=30h, 07h) and for AX=1101h and 1111h. Modes 0Fh and 10h get 21 rows of 16 lines
;   instead of 25 rows of 14, and AX=1122h sets the 8x16 font for graphics characters. Other BIOSes
;   without the font (some later S3 BIOSes, other vendors) fail in the same places. S3F8X14 keeps the
;   8x14 font and the 9x14 alternate characters resident and puts them in every one of those places,
;   so the result is what the IBM BIOS gives. A BIOS that has its own 8x14 font (S3 1.01.04) gets
;   ours instead, which is the same standard IBM VGA 8x14 set (font8x14.inc, from BIOS 1.01.04).
;   The font does not fit in our ROM (README "Kept outside the ROM").
;
;   FIX8X14 1.0.8 (BTTR Software, GPL) does the same job and was the model for which calls to cover;
;   no code was taken from it. Differences: S3F8X14 also handles AX=1101h, 1111h, the 350-line text
;   modes and AX=1130h BH=05h itself (FIX8X14 relies on the BIOS asking for the font through
;   AX=1130h, which S3 2.04.x does but other BIOSes need not), and it returns the BIOS's CX and DL
;   for AX=1130h BH=02h (FIX8X14's TSR returns CX = DL = 0 there).
;
; Usage
;   S3F8X14              install; stays resident, 4.3 KB
;   S3F8X14 /U           unload it again
;   S3F8X14 /H, /?, /HELP  parameter list
;   A second install is refused while S3F8X14 is resident. Unloading only works while S3F8X14 is the
;   last program that hooked INT 10h; otherwise it says so and stays resident (unload the later TSR
;   first, or reboot). Exit code 0 = done, 1 = refused or bad argument.
;
; What it does
;   AH=00h      the BIOS sets the mode; then, in a text mode (00h-03h, 07h) with character height 14
;               (BDA 0485h, the 350-line modes), the 8x14 font is loaded into block 0 with AX=1100h
;               (the CRTC stays as the BIOS set it), plus the 9x14 alternate characters when the mode
;               uses 9-dot characters (SR01 bit 0 = 0, mode 07h). In modes 0Fh and 10h AX=1121h BL=2
;               sets the 8x14 font for graphics characters: INT 43h points to it, 25 rows, height 14.
;               AX is returned as the BIOS returned it.
;   AX=1101h    becomes AX=1100h with the 8x14 font, BH=14, CX=256, DX=0 (block in BL as given)
;   AX=1111h    becomes AX=1110h with the same font (rows and CRTC recalculated as for 1111h)
;   AX=1122h    becomes AX=1121h with the 8x14 font, CX=14 (BL and DL as given)
;   AX=1130h    BH=02h: the BIOS fills CX and DL, then ES:BP = the 8x14 font; BH=05h: the same with
;               ES:BP = the 9x14 alternate table (character code, 14 rows; 0 ends it)
;   Every other call goes to the BIOS unchanged. The caller's registers are kept except what the
;   function returns. The handler calls the BIOS with PUSHF / CALL FAR, not INT 10h, so it never
;   runs into itself; a BIOS that asks for the font through INT 10h AX=1130h (S3 2.04.x) gets it.
;
; Expected outcome (emu/tests.py s3f8x14, on our 2.04.11-p10, stock 2.04.11, 2.04.07 and 1.01.04)
;   - mode 03h at 350 lines, AX=1101h and AX=1111h: all 256 characters in plane 2 are the 8x14 font
;   - mode 07h at 350 lines: the 8x14 font with the 20 9x14 alternates on top
;   - modes 0Fh and 10h: 25 rows, character height 14, INT 43h = the resident font
;   - AX=1122h: INT 43h = the resident font, character height 14
;   - AX=1130h BH=02h in 400-line mode 03h: the resident font with CX=16 and DL=24 from the BIOS
;   With S3F8X14 resident, S3COMPAT's "AX=1130 BH=2 8x14 font" and "VGA 10h" lines PASS instead of WARN.
;
; How a resident copy is found
;   The INT 10h vector must point to offset isr in a segment that holds the signature at offset sig.
;   That segment is the resident copy's PSP; /U puts its saved INT 10h vector back and frees it.
bits 16
org 0x100
%include "version.inc"
start:  jmp init
old10   dd 0
sig     db 'S3F8X14 '           ; identifies a resident copy (see the header)
SIGLEN  equ 8
mode_in db 0                    ; AL of the current AH=00h call

; ---------------- resident INT 10h handler ----------------
isr:    or ah,ah
        jz setmode
        cmp ah,0x11
        jne .chain
        cmp al,0x01
        je .text                ; 1101h -> 1100h
        cmp al,0x11
        je .text                ; 1111h -> 1110h
        cmp al,0x22
        je .gfx                 ; 1122h -> 1121h
        cmp al,0x30
        je .info
.chain: jmp far [cs:old10]

; AX=1101h/1111h: load the 8x14 font into a text mode, BL = block (as given). Keeps all registers.
.text:  push bx
        push cx
        push dx
        push bp
        push es
        dec al                  ; 01h -> 00h, 11h -> 10h
        mov bh,14
        mov cx,256
        xor dx,dx
        push cs
        pop es
        mov bp,font8x14
        pushf
        call far [cs:old10]
        pop es
        pop bp
        pop dx
        pop cx
        pop bx
        iret

; AX=1122h: the 8x14 font for graphics characters, BL and DL = rows (as given). Keeps all registers.
.gfx:   push cx
        push bp
        push es
        dec al                  ; 22h -> 21h
        mov cx,14
        push cs
        pop es
        mov bp,font8x14
        pushf
        call far [cs:old10]
        pop es
        pop bp
        pop cx
        iret

; AX=1130h: the BIOS fills CX and DL (and ES:BP for the other tables); BH=2 and BH=5 get ours.
.info:  cmp bh,2
        je .i2
        cmp bh,5
        jne .chain
        pushf
        call far [cs:old10]
        push cs
        pop es
        mov bp,font9x14
        iret
.i2:    pushf
        call far [cs:old10]
        push cs
        pop es
        mov bp,font8x14
        iret

; AH=00h: set the mode in the BIOS, then load the 8x14 font where the mode needs it.
; Returns AX as the BIOS returned it; all other registers are kept.
setmode:
        mov [cs:mode_in],al
        pushf
        call far [cs:old10]
        push ax
        push bx
        push cx
        push dx
        push si
        push bp
        push ds
        push es
        mov al,[cs:mode_in]
        and al,0x7F
        cmp al,0x0F
        je .g350
        cmp al,0x10
        je .g350
        cmp al,0x03
        jbe .txt
        cmp al,0x07
        jne .done
.txt:   xor bx,bx
        mov ds,bx
        cmp word [0x485],14     ; 350-line text: the BIOS set character height 14
        jne .done
        mov ax,0x1100           ; 8x14 font into block 0, CRTC as the BIOS set it
        mov bx,0x0E00
        mov cx,256
        xor dx,dx
        push cs
        pop es
        mov bp,font8x14
        pushf
        call far [cs:old10]
        mov dx,0x3C4            ; 9-dot characters (SR01 bit 0 = 0): the 9x14 alternates as well
        mov al,1
        out dx,al
        inc dx
        in al,dx
        test al,1
        jnz .done
        mov si,font9x14
.alt:   mov dl,[cs:si]          ; character code, 0 = end
        or dl,dl
        jz .done
        inc si
        xor dh,dh
        mov bp,si               ; ES = CS from above
        mov ax,0x1100
        mov bx,0x0E00
        mov cx,1
        pushf
        call far [cs:old10]
        add si,14
        jmp .alt
.g350:  mov ax,0x1121           ; 640x350 graphics: INT 43h = 8x14 font, 25 rows, height 14
        mov bl,2
        mov cx,14
        push cs
        pop es
        mov bp,font8x14
        pushf
        call far [cs:old10]
.done:  pop es
        pop ds
        pop bp
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        iret

%include "font8x14.inc"
resend:                         ; everything from here is freed after installation

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

; ---------------- install ----------------
install:
        call findres
        jne .go
        mov dx,s_twice
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21
.go:    mov ax,0x3510           ; hook INT 10h
        int 0x21
        mov [old10],bx
        mov [old10+2],es
        mov dx,isr
        mov ax,0x2510
        int 0x21
        mov es,[0x2C]           ; free the environment copy, the resident part does not need it
        mov ah,0x49
        int 0x21
        mov word [0x2C],0
        mov dx,s_inst
        mov ah,9
        int 0x21
        mov dx,resend+15        ; keep PSP + handler + font, in paragraphs
        shr dx,4
        mov ax,0x3100
        int 0x21

; ---------------- unload ----------------
unload: call findres
        je .go
        mov dx,s_notres         ; not installed, or not the last INT 10h hook
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21
.go:    push ds                 ; ES = resident copy: put its saved vector back
        lds dx,[es:old10]
        mov ax,0x2510
        int 0x21
        pop ds
        mov bx,[es:0x2C]        ; environment (0 when freed at install)
        or bx,bx
        jz .fp
        push es
        mov es,bx
        mov ah,0x49
        int 0x21
        pop es
.fp:    mov ah,0x49             ; the resident PSP, handler and font
        int 0x21
        jc .fe
        mov dx,s_unl
        mov ah,9
        int 0x21
        mov ax,0x4C00
        int 0x21
.fe:    mov dx,s_free
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21

s_use   db 'S3F8X14 ',VERSION,' - 8x14 font for VGA BIOSes without one (Trio64V2 BIOS 2.x and others)',13,10
        db '  S3F8X14             install (4.3 KB resident)',13,10
        db '  S3F8X14 /U          unload',13,10
        db '  S3F8X14 /H, /?, /HELP  this help',13,10,'$'
s_bad   db 'S3F8X14 ',VERSION,': bad argument.',13,10,13,10,'$'
s_inst  db 'S3F8X14 ',VERSION,': installed, 8x14 font for 350-line modes and AX=1101h/1111h/1122h/1130h',13,10,'$'
s_twice db 'S3F8X14 ',VERSION,': already installed.',13,10,'$'
s_unl   db 'S3F8X14 ',VERSION,': unloaded.',13,10,'$'
s_notres db 'S3F8X14 ',VERSION,': not unloaded: S3F8X14 is not installed, or another program hooked INT 10h',13,10
        db 'after it (unload that one first).',13,10,'$'
s_free  db 'S3F8X14 ',VERSION,': INT 10h restored, but its memory could not be freed.',13,10,'$'
