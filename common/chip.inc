; chip.inc - which Trio64-family chip the card has, and that chip's limits (VSHOW, S3TEST, S3COMPAT,
; S3REGS). Include it once, in the code part of a tool; it needs no other include.
;
; chipfind   finds the card through the PCI BIOS (INT 1Ah AX=B102h, vendor 5333h): device 8901h is the
;            Trio64V2/DX/GX; device 8814h the Trio64UV+ (Trio64UV+ datasheet section 4.1: CR2E = 14h);
;            device 8811h is the Trio32 or Trio64 (Trio32/Trio64 datasheet: hardwired to 8811 for
;            both; CR2E = 10h Trio32, 11h Trio64) or, with revision bit 6 set (4xh), the Trio64V+
;            (Trio64V+ datasheet: CR2E = 11h, CR2F = 4xh). CR2E is read with the S3 registers
;            unlocked (CR38 = 48h) and CR38 put back. docs/chip-rules.md T64-ID-1, VP-ID-1, UV-ID-1,
;            V2-ID-1.
;            Out: CF=1 when none of them is found ([chip] = CHIP_NONE); else CF=0 and [chip] = CHIP_*,
;            [chipbx] = the PCI bus/device/function (BX of the PCI BIOS), [chipdev], [chiprev] and the
;            limits below. Keeps every register except flags.
; chipname   DX -> the '$' string with the chip's name ([chip])
;
; Limits per chip (kHz), rule IDs from docs/chip-rules.md:
;   [vcomin]   DCLK PLL VCO minimum used for a FAIL-free result: 135 MHz (Trio32/64/V+ datasheet
;              section 9.1, PLL-1); 170 MHz on the Trio64V2, from XFree86 s3_Trio64DAC.c (V2-PLL-2)
;   [vcodsmin] DCLK PLL VCO minimum the datasheet gives: 135 MHz on every chip (the Trio64V2 datasheet
;              changes only the maximum, section 3.6). A VCO from [vcodsmin] up to [vcomin] is a WARN
;   [vcomax]   DCLK PLL VCO maximum: 270 MHz, 340 MHz on the Trio64V2 (section 3.6, V2-PLL-1)
;   [mvcomax]  MCLK PLL VCO maximum: 270 MHz on every chip (the Trio64V2 raises the DCLK PLL only)
;   [r3bit]    1 when SR12 bit 7 is the third bit of the DCLK post divider R (Trio64V2 only; SR10 bit 7
;              stays reserved, V2-PLL-3)
;   [dsingle]  highest DCLK without clock doubling (8 and 15/16 bpp), [ddouble] the pixel rate of
;              clock-doubled 8 bpp, [dpack24] packed 24 bpp, [d32] 32 bpp: Trio32/Trio64 and Trio64V+
;              table 8-1 (80, 135, 75, 50 MHz); Trio64V2 table 5-7 note 2 (95, 170 MHz)
;   [dstream]  highest single-clocked DCLK with the Streams Processor on (CR67 bits 3-2 = 11b): 80 MHz
;              (Trio64V2 table 5-7 note 2, V2-CLK-2; the same as [dsingle] on the other chips)
;   [mclkmax]  highest MCLK: 60 MHz (16.67 ns cycle) on the Trio32 and Trio64V+ (clock tables 4-6),
;              70 MHz on the Trio64: the data book gives 60 MHz, but the 86C764X is rated for 70 MHz
;              (vgamuseum) and the ExpertColor DSP-3364P runs 69.8 MHz with its own BIOS; our limit for
;              the Trio64 since 31 October 2026 (T64-MEM-7; the 86C764X's limit, the earlier 86C764
;              likely accepts 60 MHz only, and the two have the same PCI ID),
;              66.67 MHz (15 ns) on the Trio64UV+ (table 6-7); on the Trio64V2 the memory type decides
;              (60 MHz 1-cycle EDO, else 66.67 MHz, V2-MEM-1), this field holds the higher one (MEM-1)
; The Trio64UV+ book lists only its changes from the Trio64V+: its PLL and colour mode limits are the
; Trio64V+ ones (docs/chip-rules.md, inheritance).

CHIP_NONE   equ 0
CHIP_T32    equ 1
CHIP_T64    equ 2
CHIP_T64VP  equ 3
CHIP_T64V2  equ 4
CHIP_T64UVP equ 5

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
        mov al,CHIP_T64UVP
        cmp word [chipdev],0x8814
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

chipdevs    dw 0x8901, 0x8811, 0x8814, 0
chipnames   dw s_chipnone, s_chipt32, s_chipt64, s_chipt64vp, s_chipt64v2, s_chipt64uvp
s_chipnone  db 'no Trio64-family chip found$'
s_chipt32   db 'Trio32$'
s_chipt64   db 'Trio64$'
s_chipt64vp db 'Trio64V+$'
s_chipt64v2 db 'Trio64V2/DX/GX$'
s_chipt64uvp db 'Trio64UV+$'

; vcomin, vcomax, dsingle, ddouble, dpack24, d32 (dd, kHz), r3bit (db), vcodsmin, mvcomax, dstream,
; mclkmax (dd, kHz): one row per chip, CHIP_T32 first
chiplims:
        dd 135000, 270000, 80000, 135000, 75000, 50000      ; Trio32
        db 0
        dd 135000, 270000, 80000, 60000
CHIPLIM equ $-chiplims
        dd 135000, 270000, 80000, 135000, 75000, 50000      ; Trio64
        db 0
        dd 135000, 270000, 80000, 70000                     ; MCLK 70 MHz (T64-MEM-7)
        dd 135000, 270000, 80000, 135000, 75000, 50000      ; Trio64V+
        db 0
        dd 135000, 270000, 80000, 60000
        dd 170000, 340000, 95000, 170000, 75000, 50000      ; Trio64V2/DX/GX
        db 1
        dd 135000, 270000, 80000, 66667
        dd 135000, 270000, 80000, 135000, 75000, 50000      ; Trio64UV+
        db 0
        dd 135000, 270000, 80000, 66667

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
vcodsmin dd 135000
mvcomax dd 270000
dstream dd 80000
mclkmax dd 66667
