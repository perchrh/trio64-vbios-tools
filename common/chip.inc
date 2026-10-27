; chip.inc - which Trio64-family chip the card has, and that chip's limits (VSHOW, S3TEST, S3COMPAT,
; S3REGS). Include it once, in the code part of a tool; it needs no other include.
;
; chipfind   finds the card through the PCI BIOS (INT 1Ah AX=B102h, vendor 5333h): device 8901h is the
;            Trio64V2/DX/GX; device 8811h is the Trio32 or Trio64 (Trio32/Trio64 datasheet: hardwired
;            to 8811 for both; CR2E = 10h Trio32, 11h Trio64) or, with revision bit 6 set (4xh), the
;            Trio64V+ (Trio64V+ datasheet: CR2E = 11h, CR2F = 4xh). CR2E is read with the S3 registers
;            unlocked (CR38 = 48h) and CR38 put back.
;            Out: CF=1 when none of them is found ([chip] = CHIP_NONE); else CF=0 and [chip] = CHIP_*,
;            [chipbx] = the PCI bus/device/function (BX of the PCI BIOS), [chipdev], [chiprev] and the
;            limits below. Keeps every register except flags.
; chipname   DX -> the '$' string with the chip's name ([chip])
;
; Limits per chip (kHz): [vcomin], [vcomax] the DCLK/MCLK PLL VCO range, [r3bit] = 1 when SR12/SR10
; bit 7 is the third bit of the post divider R (Trio64V2 only), [dsingle] the highest pixel clock
; without clock doubling (8 and 15/16 bpp), [ddouble] the pixel rate of clock-doubled 8 bpp, [dpack24]
; packed 24 bpp, [d32] 32 bpp. Sources: Trio64V2/DX/GX datasheet (VCO 170-340 MHz, 3-bit R; 95, 170,
; 75 and 50 MHz) and XFree86 s3_Trio64DAC.c (170000-340000 kHz); Trio32/Trio64 datasheet (March 1995,
; section 9.1: 135 MHz <= 2^R x fOUT <= 270 MHz, R 2 bits in bits 6-5 of SR10/SR12; table 8-1: 80 MHz
; at 8 and 15/16 bpp, 135 MHz clock doubled, 75 MHz packed 24, 50 MHz at 24 bpp true colour); the
; Trio64V+ datasheet gives the same PLL range and table 8-1.

CHIP_NONE   equ 0
CHIP_T32    equ 1
CHIP_T64    equ 2
CHIP_T64VP  equ 3
CHIP_T64V2  equ 4

chipfind:
        pushad
        mov byte [chip],CHIP_NONE
        mov si,chipdevs
.d:     lodsw
        or ax,ax
        jz .no
        mov cx,ax
        push si
        mov dx,0x5333
        mov ax,0xB102
        xor si,si
        int 0x1A
        pop si
        jc .d
        or ah,ah
        jnz .d
        mov [chipbx],bx
        mov [chipdev],cx
        mov ax,0xB108                   ; revision ID (configuration byte 08h) -> CL
        mov di,8
        int 0x1A
        mov [chiprev],cl
        mov al,CHIP_T64V2
        cmp word [chipdev],0x8901
        je .set
        mov al,CHIP_T64VP               ; 8811: revision 4xh is the Trio64V+
        test byte [chiprev],0x40
        jnz .set
        call .cr2e                      ; else CR2E: 10h Trio32, 11h Trio64
        mov al,CHIP_T32
        cmp ah,0x10
        je .set
        mov al,CHIP_T64
.set:   mov [chip],al
        movzx si,al                     ; the limits of that chip
        dec si
        imul si,si,CHIPLIM
        add si,chiplims
        mov di,vcomin
        mov cx,CHIPLIM
.cp:    mov al,[si]
        mov [di],al
        inc si
        inc di
        loop .cp
        popad
        clc
        ret
.no:    popad
        stc
        ret

.cr2e:  mov dx,0x3CC                    ; CR2E -> AH (colour or mono CRTC address), CR38 kept
        in al,dx
        mov dx,0x3B4
        test al,1
        jz .c1
        mov dx,0x3D4
.c1:    in al,dx
        push ax                         ; the CRTC index
        mov al,0x38
        out dx,al
        inc dx
        in al,dx
        mov bl,al                       ; CR38 as found
        mov al,0x48
        out dx,al
        dec dx
        mov al,0x2E
        out dx,al
        inc dx
        in al,dx
        mov bh,al
        dec dx
        mov al,0x38
        mov ah,bl
        out dx,ax
        pop ax
        out dx,al
        mov ah,bh
        ret

chipname:
        push bx
        movzx bx,byte [chip]
        shl bx,1
        mov dx,[chipnames+bx]
        pop bx
        ret

chipdevs    dw 0x8901, 0x8811, 0
chipnames   dw s_chipnone, s_chipt32, s_chipt64, s_chipt64vp, s_chipt64v2
s_chipnone  db 'no Trio64-family chip found$'
s_chipt32   db 'Trio32$'
s_chipt64   db 'Trio64$'
s_chipt64vp db 'Trio64V+$'
s_chipt64v2 db 'Trio64V2/DX/GX$'

; vcomin, vcomax, dsingle, ddouble, dpack24, d32 (dd, kHz), r3bit (db): one row per chip, CHIP_T32 first
chiplims:
        dd 135000, 270000, 80000, 135000, 75000, 50000      ; Trio32
        db 0
CHIPLIM equ $-chiplims
        dd 135000, 270000, 80000, 135000, 75000, 50000      ; Trio64
        db 0
        dd 135000, 270000, 80000, 135000, 75000, 50000      ; Trio64V+
        db 0
        dd 170000, 340000, 95000, 170000, 75000, 50000      ; Trio64V2/DX/GX
        db 1

chip    db CHIP_NONE
chiprev db 0
chipbx  dw 0
chipdev dw 0
vcomin  dd 170000                       ; the V2 values until chipfind ran
vcomax  dd 340000
dsingle dd 95000
ddouble dd 170000
dpack24 dd 75000
d32     dd 50000
r3bit   db 1
