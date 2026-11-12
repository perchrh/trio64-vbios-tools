; chip.inc - which Trio64-family chip the card has, and that chip's limits (VBESHOW, S3TEST, S3COMPAT,
; S3REGS, CHIPID). Include it once, in the code part of a tool; it needs no other include.
;
; chipfind   finds the card through the PCI BIOS (INT 1Ah AX=B102h, vendor 5333h):
;            8901h Trio64V2/DX/GX; 8A13h Trio3D/2X (S3 NT 5.30.05 INF DEV_8A13); 8904h Trio3D
;            (S3 Win9x 4.10.01.2204-2.61.06 INF DEV_8904 "S3 Inc. Trio3D"; 86C365); 8814h Trio64UV+;
;            8811h Trio32/Trio64 (CR2E 10h/11h) or Trio64V+ when revision bit 6 is set
;            (4xh in the data book; later steppings 5xh, also bit 6).
;            On a find it also runs chipidregs. docs/chip-rules.md T64-ID-1, VP-ID-1, UV-ID-1, V2-ID-1.
;            Out: CF=1 when none of them is found ([chip] = CHIP_NONE); else CF=0 and [chip] = CHIP_*,
;            [chipbx] = the PCI bus/device/function (BX of the PCI BIOS), [chipdev], [chiprev],
;            [chipcr2d]-[chipcr30] and the limits below. Keeps every register except flags.
; chipidregs reads CR2D-CR30 into [chipcr2d]..[chipcr30] and CR6F into [chipcr6f] (V2-ID-1: bit 0 is
;            the Trio64V2/GX). CR38 and CR39 are unlocked and restored with the CRTC index (colour or
;            mono). Used by chipfind and by CHIPID.COM when PCI is absent. Keeps every register except
;            flags.
; chipname   DX -> the '$' string with the chip's market name ([chip]). On CHIP_T64V2, CR6F bit 0
;            selects Trio64V2/DX vs Trio64V2/GX.
; chippart   DX -> the '$' string with the S3 part number for [chip] (README "Chip codes"): 86C732,
;            86C764X or 86C764-P (the PCI revision is 00h on both: by CR2F as S3's Windows 95 driver
;            2.41.07 does, 20h, 30h, 03h or 12h the 86C764X ("86C764..pnp"), any other value the
;            86C764-P, T64-ID-2; chipvar names the maker), 86C765, 86C775 or 86C785 (CR6F bit 0),
;            86C767, 86C365 (Trio3D), 86C362/86C368 (Trio3D/2X). S3's Windows 95 Trio INF (w9524107)
;            lists one Have Disk row for PCI 8901 ("Trio64V2"); DX vs GX is not a PCI revision there.
;            S3 Win9x 2.61.06 (9x26106) INF: PCI 8904 = Trio3D; S3 NT 5.30.05 (53005) INF: PCI 8A13
;            = Trio3D/2X.
; chipvar    In: AL = CR2F (for example [chipcr2f] after chipfind). Out: DX -> the '$'
;            name of the Trio32/Trio64 variant that CR2F codes, by S3's Windows 95 driver 2.41.07
;            (S3_2.DRV, its chip name table; docs/764-rom.md "Chip variants by CR2F"): Trio64 20h GS,
;            30h NEC, 03h UMC, 12h TSMC, each "86C764..pnp", the 86C764X; any other value the plain
;            86C764 (the earlier 764P, or a code the driver does not know); Trio32 22h 86C732GSpnp,
;            else 86C732. On the other chips the driver names no variants. *Derived*: a driver, not a
;            data book; the line that shows it is INFO only. Keeps every register except DX and flags.
;            Assembled only when the tool defines CHIPVAR before the include.
;
; Limits per chip (kHz), rule IDs from docs/chip-rules.md:
;   [vcomin]   DCLK PLL VCO minimum below which a VCO in the datasheet range is a WARN: 135 MHz on every
;              chip (datasheet section 9.1, PLL-1, worded "should": "Programmed PLL M and PLL N values
;              should be consistent with the following constraints: 1. 135 MHz < (M+2)fREF/(N+2) < 270 MHz").
;              The Trio64V2 datasheet raises only the DCLK PLL maximum, 340 MHz (section 3.6), and states no
;              minimum (V2-PLL-2), so its minimum is the same 135 MHz
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
CHIP_T3D    equ 6                       ; Trio3D, PCI 8904h
CHIP_T3D2X  equ 7                       ; Trio3D/2X, PCI 8A13h

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
        call chipidregs                 ; CR2D-CR30 (also CR2E for the 8811 Trio32/Trio64 split)
        mov al,CHIP_T64V2
        cmp word [chipdev],0x8901
        je .set
        mov al,CHIP_T3D2X               ; 8A13h: S3 NT 5.30.05 INF "Trio3D/2X"
        cmp word [chipdev],0x8A13
        je .set
        mov al,CHIP_T3D                 ; 8904h: S3 Win9x 2.61.06 INF "S3 Inc. Trio3D"
        cmp word [chipdev],0x8904
        je .set
        mov al,CHIP_T64UVP
        cmp word [chipdev],0x8814
        je .set
        mov al,CHIP_T64VP               ; 8811: revision bit 6 (4xh, 5xh) is the Trio64V+
        test byte [chiprev],0x40
        jnz .set
        mov al,CHIP_T32                 ; else CR2E: 10h Trio32, 11h Trio64
        cmp byte [chipcr2e],0x10
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

; CR2D-CR30 -> [chipcr2d]..[chipcr30], CR6F -> [chipcr6f]; CR38/CR39 and the CRTC index restored.
chipidregs:
        pusha
        mov dx,0x3CC
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
        mov al,0x39
        out dx,al
        inc dx
        in al,dx
        mov bh,al                       ; CR39 as found
        mov al,0xA5
        out dx,al
        dec dx
        mov si,chipcr2d
        mov al,0x2D
.rd:    out dx,al
        inc dx
        push ax
        in al,dx
        mov [si],al
        inc si
        pop ax
        dec dx
        inc al
        cmp al,0x31
        jb .rd
        mov al,0x6F                     ; V2-ID-1: bit 0 = Trio64V2/GX
        out dx,al
        inc dx
        in al,dx
        mov [chipcr6f],al
        dec dx
        mov al,0x39
        mov ah,bh
        out dx,ax
        mov al,0x38
        mov ah,bl
        out dx,ax
        pop ax
        out dx,al
        popa
        ret

chipname:
        push bx
        cmp byte [chip],CHIP_T64V2      ; V2: CR6F bit 0 is GX (V2-ID-1)
        jne .t
        mov dx,s_chipt64v2dx
        test byte [chipcr6f],1
        jz .e
        mov dx,s_chipt64v2gx
        jmp .e
.t:     movzx bx,byte [chip]
        shl bx,1
        mov dx,[chipnames+bx]
.e:     pop bx
        ret

chippart:
        push bx
        cmp byte [chip],CHIP_T64V2
        jne .t
        mov dx,s_part775
        test byte [chipcr6f],1
        jz .e
        mov dx,s_part785
        jmp .e
.t:     cmp byte [chip],CHIP_T64        ; Trio64: the pnp codes in CR2F are the 86C764X (T64-ID-2)
        jne .t2
        mov dx,s_part764x
        mov bl,[chipcr2f]
        cmp bl,0x20
        je .e
        cmp bl,0x30
        je .e
        cmp bl,0x03
        je .e
        cmp bl,0x12
        je .e
        mov dx,s_part764p
        jmp .e
.t2:    movzx bx,byte [chip]
        shl bx,1
        mov dx,[chipparts+bx]
.e:     pop bx
        ret

%ifdef CHIPVAR                          ; only the tools that show the variant (S3TEST) carry it
chipvar:
        push si
        push ax
        mov si,cv_t64
        cmp byte [chip],CHIP_T64
        je .l
        mov si,cv_t32
        cmp byte [chip],CHIP_T32
        je .l
        mov dx,s_cvnone
        jmp .x
.l:     mov ah,al
.n:     lodsb                           ; table: code, then the name offset; FFh ends it, then the default
        cmp al,0xFF
        je .d
        cmp al,ah
        je .d
        add si,2
        jmp .n
.d:     mov dx,[si]
.x:     pop ax
        pop si
        ret

cv_t64      db 0x20
            dw s_cv64gs
            db 0x30
            dw s_cv64nec
            db 0x03
            dw s_cv64umc
            db 0x12
            dw s_cv64tsmc
            db 0xFF
            dw s_cv64
cv_t32      db 0x22
            dw s_cv32gs
            db 0xFF
            dw s_cv32
s_cv64gs    db '86C764GSpnp (764X)$'
s_cv64nec   db '86C764NECpnp (764X)$'
s_cv64umc   db '86C764UMCpnp (764X)$'
s_cv64tsmc  db '86C764TSMCpnp (764X)$'
s_cv64      db '86C764, no pnp code (764P or unknown)$'
s_cv32gs    db '86C732GSpnp$'
s_cv32      db '86C732, no pnp code$'
s_cvnone    db 'no variant codes for this chip$'
%endif

chipdevs    dw 0x8901, 0x8A13, 0x8904, 0x8811, 0x8814, 0
chipnames   dw s_chipnone, s_chipt32, s_chipt64, s_chipt64vp, s_chipt64v2dx, s_chipt64uvp, \
               s_chipt3d, s_chipt3d2x
chipparts   dw s_partnone, s_part732, s_part764x, s_part765, s_part775, s_part767, \
               s_part365, s_part362
s_chipnone  db 'no Trio64-family chip found$'
s_chipt32   db 'Trio32$'
s_chipt64   db 'Trio64$'
s_chipt64vp db 'Trio64V+$'
s_chipt64v2dx db 'Trio64V2/DX$'           ; CR6F bit 0 clear (V2-ID-1)
s_chipt64v2gx db 'Trio64V2/GX$'           ; CR6F bit 0 set
s_chipt64uvp db 'Trio64UV+$'
s_chipt3d   db 'Trio3D$'                  ; PCI 8904h
s_chipt3d2x db 'Trio3D/2X$'               ; PCI 8A13h (53005 INF)
s_partnone  db '$'
s_part732   db '86C732$'
s_part764x  db '86C764X$'                  ; PCI 8811, rev bit 6 clear, CR2F 20h/30h/03h/12h (T64-ID-2)
s_part764p  db '86C764-P$'                 ; PCI 8811, rev bit 6 clear, any other CR2F
s_part765   db '86C765$'                  ; PCI 8811 with rev bit 6 set (VP-ID-1)
s_part775   db '86C775$'                  ; PCI 8901, CR6F bit 0 clear
s_part785   db '86C785$'                  ; PCI 8901, CR6F bit 0 set
s_part767   db '86C767$'
s_part365   db '86C365$'                  ; Trio3D
s_part362   db '86C362/86C368$'           ; Trio3D/2X (README)

; vcomin, vcomax, dsingle, ddouble, dpack24, d32 (dd, kHz), r3bit (db), vcodsmin, mvcomax, dstream,
; mclkmax (dd, kHz): one row per chip, CHIP_T32 first. Trio3D / Trio3D/2X: no row in chip-rules yet;
; MCLK up to 100 MHz so a stock 75 MHz POST is not a false FAIL (docs/764-rom.md MCLK table).
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
        dd 135000, 340000, 95000, 170000, 75000, 50000      ; Trio64V2/DX/GX
        db 1
        dd 135000, 270000, 80000, 66667
        dd 135000, 270000, 80000, 135000, 75000, 50000      ; Trio64UV+
        db 0
        dd 135000, 270000, 80000, 66667
        dd 135000, 340000, 95000, 170000, 75000, 50000      ; Trio3D
        db 0
        dd 135000, 270000, 80000, 100000
        dd 135000, 340000, 95000, 170000, 75000, 50000      ; Trio3D/2X
        db 0
        dd 135000, 270000, 80000, 100000

chip    db CHIP_NONE
chiprev db 0
chipbx  dw 0
chipdev dw 0
chipcr2d db 0                           ; CR2D-CR30 from chipidregs / chipfind
chipcr2e db 0
chipcr2f db 0
chipcr30 db 0
chipcr6f db 0                           ; CR6F: V2 DX/GX strap (bit 0)
vcomin  dd 135000                       ; the V2 values until chipfind ran
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
