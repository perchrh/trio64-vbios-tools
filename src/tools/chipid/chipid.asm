; CHIPID.COM - name the Trio64-family chip from PCI and CR2D-CR30 / CR6F (DOS, 386+)
;
; Purpose
;   Prints the same identification S3TEST's Chip ID INFO line uses: CR2D CR2E CR2F CR30, the PCI
;   device and revision, the market name and the S3 part number. Classification is src/tools/common/chip.inc
;   (chipfind, chipidregs, chipname, chippart): 8901h (V2; CR6F bit 0 = DX/GX), 8A13h Trio3D/2X
;   (S3 NT 5.30.05 INF), 8904h Trio3D (S3 Win9x 2.61.06 INF; 86C365), 8814h UV+, 8811h (rev bit 6
;   = V+; else CR2E = Trio32/Trio64). Changes nothing.
;
; Usage
;   CHIPID           one line to stdout
;   CHIPID /H, /?    this help
;   Exit code 0 when a Trio64-family PCI device was found, 1 when not (CR2D-CR30 and CR6F are still
;   printed when the ports answer).
;
bits 16
org 0x100
cpu 386
%include "version.inc"

start:  cld
        mov si,0x81
.sk:    lodsb
        cmp al,' '
        je .sk
        cmp al,9
        je .sk
        dec si
        cmp al,'/'
        jne .go
        mov al,[si+1]
        or al,0x20
        cmp al,'h'
        je help
        cmp al,'?'
        je help
.go:    mov dx,s_title
        call puts
        call chipfind                   ; src/tools/common/chip.inc: PCI + chipidregs on a find
        pushf
        jnc .id
        call chipidregs                 ; no PCI hit: still try CR2D-CR30 and CR6F
.id:    mov dx,s_cr
        call puts
        mov al,[chipcr2d]
        call phex2
        call sp1
        mov al,[chipcr2e]
        call phex2
        call sp1
        mov al,[chipcr2f]
        call phex2
        call sp1
        mov al,[chipcr30]
        call phex2
        mov dx,s_cr6f
        call puts
        mov al,[chipcr6f]
        call phex2
        mov dx,s_pci
        call puts
        popf
        jc .np
        mov ax,[chipdev]
        call phex4
        mov dx,s_rev
        call puts
        mov al,[chiprev]
        call phex2
        call sp1
        call chipname
        call puts
        call sp1
        call chippart
        call puts
        mov dx,s_nl
        call puts
        mov ax,0x4C00
        int 0x21
.np:    mov dx,s_na
        call puts
        mov ax,0x4C01
        int 0x21

help:   mov dx,s_use
        call puts
        mov ax,0x4C00
        int 0x21

puts:   push ax                         ; DX -> '$' string to stdout
        mov ah,9
        int 0x21
        pop ax
        ret

sp1:    push ax
        mov dl,' '
        mov ah,2
        int 0x21
        pop ax
        ret

phex4:  push ax
        mov al,ah
        call phex2
        pop ax
phex2:  push ax
        shr al,4
        call nib
        pop ax
        push ax
        and al,0x0F
        call nib
        pop ax
        ret

nib:    and al,0x0F
        add al,'0'
        cmp al,'9'
        jbe .o
        add al,7
.o:     mov dl,al
        mov ah,2
        int 0x21
        ret

s_title db 'CHIPID ',VERSION,13,10,'$'
s_cr    db 'CR2D-CR30 $'
s_cr6f  db ' CR6F $'
s_pci   db ', PCI $'
s_rev   db ' rev $'
s_na    db 'n/a',13,10,'$'
s_nl    db 13,10,'$'
s_use   db 'CHIPID ',VERSION,' - name the Trio64-family chip from PCI',13,10
        db '  CHIPID       print CR2D-CR30, CR6F, PCI device/rev, name and S3 part',13,10
        db '  CHIPID /H    this help',13,10
        db 'Exit 0 when a listed PCI 5333 device is found, 1 otherwise.',13,10
        db '8901: CR6F bit 0 clear = Trio64V2/DX 86C775, set = /GX 86C785.',13,10
        db '8A13 = Trio3D/2X 86C362/86C368; 8904 = Trio3D 86C365.',13,10
        db 'Uses src/tools/common/chip.inc (chipfind / chipidregs / chippart).',13,10,'$'

%include "chip.inc"
