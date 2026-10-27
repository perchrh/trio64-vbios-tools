; chip.inc - which Trio64-family chip the card has, and that chip's limits (VSHOW, S3TEST, S3COMPAT,
; S3REGS). Include it once, in the code part of a tool; it needs no other include.
;
; chipfind   finds the card through the PCI BIOS (INT 1Ah AX=B102h, vendor 5333h): device 8901h is the
;            Trio64V2/DX/GX, 8811h the Trio64 or, from revision 40h on, the Trio64V+, 8810h the Trio32.
;            Out: CF=1 when none of them is found ([chip] = CHIP_NONE); else CF=0 and [chip] = CHIP_*,
;            [chipbx] = the PCI bus/device/function (BX of the PCI BIOS), [chipdev], [chiprev] and the
;            limits below. Keeps every register except flags.
; chipname   DX -> the '$' string with the chip's name ([chip])
;
; Limits per chip (kHz): [vcomin], [vcomax] the DCLK/MCLK PLL VCO range, [r3bit] = 1 when SR12/SR10
; bit 7 is the third bit of the post divider R (Trio64V2 only), [dsingle] the highest DCLK without
; clock doubling at 8 bpp, [ddouble] with it, [dpack24] packed 24 bpp, [d32] 32 bpp. Sources: Trio64V2
; datasheet for the V2 (VCO 170-340 MHz with the 3-bit R, DCLK 95/170/75/50 MHz); XFree86 / X.Org
; xf86-video-s3 (s3_Trio64DAC.c, s3_driver.c) for the Trio32/Trio64/Trio64V+ (VCO 135-270 MHz,
; 2-bit R, 135 MHz at 8 bpp, 80 MHz at 16 bpp, 50 MHz at 24/32 bpp) until their datasheets are checked.

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
        mov al,CHIP_T32
        cmp word [chipdev],0x8810
        je .set
        mov al,CHIP_T64
        cmp byte [chiprev],0x40
        jb .set
        mov al,CHIP_T64VP
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

chipname:
        push bx
        movzx bx,byte [chip]
        shl bx,1
        mov dx,[chipnames+bx]
        pop bx
        ret

chipdevs    dw 0x8901, 0x8811, 0x8810, 0
chipnames   dw s_chipnone, s_chipt32, s_chipt64, s_chipt64vp, s_chipt64v2
s_chipnone  db 'no Trio64-family chip found$'
s_chipt32   db 'Trio32$'
s_chipt64   db 'Trio64$'
s_chipt64vp db 'Trio64V+$'
s_chipt64v2 db 'Trio64V2/DX/GX$'

; vcomin, vcomax, dsingle, ddouble, dpack24, d32 (dd, kHz), r3bit (db): one row per chip, CHIP_T32 first
chiplims:
        dd 135000, 270000, 80000, 135000, 50000, 50000
        db 0
CHIPLIM equ $-chiplims
        dd 135000, 270000, 80000, 135000, 50000, 50000      ; Trio64
        db 0
        dd 135000, 270000, 80000, 135000, 50000, 50000      ; Trio64V+
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
