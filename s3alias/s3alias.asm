; S3ALIAS.COM 0.8 - mode number alias TSR for Pinball Illusions' S3 driver on the Trio64V2/DX VBIOS 2.x
;
; Purpose
;   Pinball Illusions has its own S3 driver that sets 640x480x256 with INT 10h AH=00 mode 49h and
;   800x600x256 with mode 4Bh, the numbers of an older S3 BIOS. In BIOS 2.04.x these numbers are other
;   modes (49h = 640x480 15-bit colour, 4Bh = 1024x768 15-bit colour), so the game gets a wrong picture.
;   The 8-bit modes are 59h (VESA 101h) and 5Ah (VESA 103h) here. The fix is a TSR and not in the ROM
;   because changing the ROM's own mode numbers would break programs that use this BIOS's numbering.
;
; Usage
;   S3ALIAS          install (once, before starting the game); stays resident, about 300 bytes
;   It cannot be removed again; reboot to get rid of it. Installing it twice chains a second copy,
;   which is harmless.
;
; What it does and the expected outcome
;   INT 10h AH=00 with AL = 49h becomes AL = 59h, AL = 4Bh becomes AL = 5Ah. Bit 7 of AL (do not
;   clear video memory) is kept. Every other call goes to the BIOS unchanged.
;   Expect: the message "S3ALIAS 0.8: installed ..." at install; Pinball Illusions shows its tables in
;   640x480 and 800x600 with correct colours. Run S3TEST and S3COMPAT without S3ALIAS: S3COMPAT sets
;   every S3 mode through AH=00, and its lines for 49h (VESA 110h) and 4Bh (VESA 116h) would fail.
bits 16
org 0x100
start:  jmp init
old10   dd 0
; resident INT 10h handler
isr:    or ah,ah
        jnz .chain
        push ax
        and al,0x7F
        cmp al,0x49
        je .m49
        cmp al,0x4B
        je .m4b
        pop ax
.chain: jmp far [cs:old10]
.m49:   pop ax
        add al,0x10             ; 49h -> 59h (bit 7 unchanged)
        jmp far [cs:old10]
.m4b:   pop ax
        add al,0x0F             ; 4Bh -> 5Ah (bit 7 unchanged)
        jmp far [cs:old10]
resend:                         ; everything from here is freed after installation
init:   mov ax,0x3510           ; hook INT 10h
        int 0x21
        mov [old10],bx
        mov [old10+2],es
        mov dx,isr
        mov ax,0x2510
        int 0x21
        mov dx,msg
        mov ah,9
        int 0x21
        mov dx,resend+15        ; keep PSP + handler, in paragraphs
        shr dx,4
        mov ax,0x3100
        int 0x21
msg     db 'S3ALIAS 0.8: installed, mode 49h->59h (640x480x8), 4Bh->5Ah (800x600x8)',13,10,'$'
