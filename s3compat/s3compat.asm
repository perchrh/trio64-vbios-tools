; S3COMPAT.COM 0.8 - VGA / SVGA / VESA compatibility test for the Trio64V2/DX VBIOS (386+)
;
; Purpose
;   Tests the video BIOS, not the chip: does every standard VGA mode and BIOS function behave like the
;   IBM VGA BIOS, does every VESA mode the BIOS lists work banked and linear, and are the registers the
;   BIOS programs inside the limits of the Trio64V2 datasheet. Test ideas follow VGATEST (PC Tech
;   Journal 1988), SVGATEST, VBETest and X-VESA.
;
; Usage
;   S3COMPAT [/I] [/Q] [/V] > S3COMPAT.LOG
;   /I  wait for a key after each mode (look at the screen)      /Q  skip the 2 MB VRAM test
;   /V  debug log in S3COMPAT.DBG (common/vdebug.inc): every INT 10h call with registers and duration,
;       a register dump and the result line after every test, 4F00/4F01/AH=1Bh blocks, per-frame
;       timer counts, memory mismatches. The normal log is the same with or without /V. Needs 64 KB
;       more memory and runs longer (the debug file is committed before every mode set).
;   A notice on stderr says the run takes about 3 minutes; a key starts it, Esc cancels.
;   When stdout is a file, every test line is written and committed (INT 21h AH=68h) before the next
;   test starts, so after a freeze the last line in the log is the test that hung.
;   Exit code 0 = no FAIL, 1 = at least one FAIL.
;
; Result lines
;   <test name> ... <details>  PASS | FAIL xxxx | WARN xx | INFO
;   FAIL/WARN carry a bit mask per test, explained at the routine and in the log header. Detail lines
;   show REG=actual(expected), masked to the bits under test. INFO lines report without judging.
;
; Run order and expected outcome on the p9 ROM (219 pass, 0 fail, 4 warn on p8 before the 350-line
; and palette additions; the four warnings are known stock items)
;   1. ROM version string                      INFO
;   2. POST: MCLK PLL and memory type           PASS (59.96 MHz, VCO in 135-340 MHz, 1-cycle EDO)
;   3. Initial state, setup                     INFO, PASS (mode 03, baseline, VRAM zeroed)
;   4. VGA modes 00h-13h and the 350-line text modes against the IBM reference
;                                               PASS; mode 10h WARN 01 (8x16 font used, 8x14 missing)
;   5. Mode X family and 80x50 text             PASS
;   6. VGA BIOS functions (cursor .. AH=1B)     PASS; AX=1130 BH=2 WARN 01 (8x14 font missing)
;   7. VESA global (4F00, 4F08, 4F04, 4F0A)     PASS
;   8. Every VESA mode, banked and linear       PASS; 106h WARN 02 (108 MHz above the 95 MHz
;                                               datasheet single-clock limit, works on the card);
;                                               4104 WARN 20 (LFB offered on a planar mode, stock)
;   9. S3 modes via AH=00 vs the same via 4F02   PASS
;  10. VESA functions (4F01-4F09, VRAM, LFB)     PASS
;  11. Pass 2: VGA modes right after VESA modes  as step 4 (leftover state must not matter)
;  12. Cleanup: mode 03 vs the baseline          PASS, VRAM zeroed, the DOS screen restored
;
; Reference data (vgaref.inc): IBM register values and AH=1Bh state blocks per VGA mode, and IBM's
; default 256-colour DAC, from the VGATEST tables; the 350-line entries from the IBM parameter table.
bits 16
cpu 386
org 0x100

%include "vdebug.mac"
%macro PS 1+
        call ps
        db %1,0
%endmacro
%macro TB 1+
        call tbegin
        db %1,0
%endmacro
%macro FAILB 1
        or word [fails],%1
%endmacro
%macro WARNB 1
        or word [warns],%1
%endmacro
%macro RC 1
        mov ax,(%1<<8)|3
        call readreg
%endmacro
%macro RS 1
        mov ax,(%1<<8)|2
        call readreg
%endmacro

; Program start: memory check (log buffer, screen save), options, stdout-is-file test, PIT channel 0
; to mode 2 (same 18.2 Hz tick, but a counter that can be read precisely), startup notice, then the
; test sequence listed in the file header.
start:  cld
        mov ax,cs
        add ax,0x1000
        mov [logseg],ax
        add ax,0x1000
        mov [scrseg],ax
        add ax,0x1000
        cmp ax,[2]
        jbe .mok
        mov dx,s_nomem
        mov ah,9
        int 0x21
        mov ax,0x4C02
        int 0x21
.mok:   mov si,0x81                     ; options
.op:    lodsb
        cmp al,13
        je .opd
        cmp al,'/'
        jne .op
        lodsb
        and al,0xDF
        cmp al,'I'
        jne .o2
        mov byte [interact],1
.o2:    cmp al,'Q'
        jne .o3
        mov byte [quick],1
.o3:    cmp al,'V'
        jne .op
        mov byte [vreq],1
        jmp .op
.opd:   mov ax,0x4400                   ; stdout a file? then write + commit after every test step
        mov bx,1
        int 0x21
        jc .nf
        test dl,0x80
        jnz .nf
        mov byte [tofile],1
.nf:    cli                             ; PIT ch0 mode 2 (same rate) for precise timing
        mov al,0x34
        out 0x43,al
        xor al,al
        out 0x40,al
        out 0x40,al
        sti
        mov dx,s_start                  ; notice on stderr (not redirected by >)
        mov cx,s_start_len
        mov bx,2
        mov ah,0x40
        int 0x21
        xor ah,ah                       ; wait for a key, Esc cancels
        int 0x16
        cmp al,27
        jne .go
        cli
        mov al,0x36                     ; timer back to mode 3
        out 0x43,al
        xor al,al
        out 0x40,al
        out 0x40,al
        sti
        mov ax,0x4C00
        int 0x21
.go:    cmp byte [vreq],1               ; /V: debug log in S3COMPAT.DBG (needs 64 KB more)
        jne .gs
        mov ax,cs
        add ax,0x4000
        cmp ax,[2]
        ja .gm
        sub ax,0x1000
        mov dx,s_vname
        call vinit
        jmp .gs
.gm:    mov dx,s_vnomem
        mov ah,9
        int 0x21
.gs:    call save_screen
        PS 'S3COMPAT 0.8 - VGA/SVGA/VESA compatibility test for the Trio64V2 VBIOS',13,10
        PS 'Values in detail lines: REG=actual(expected), masked to the bits under test.',13,10
        PS 'VGA fail bits: 1 regs vs IBM  2 BIOS data/AH=0F/AH=1B  4 S3 ext left on',13,10
        PS '  8 refresh  10 memory  20 default DAC (256/EGA/CGA)  40 refresh vs CRTC/PLL math',13,10
        PS 'VGA xxh 350 = the mode at 350 scan lines (AH=12 BL=30 first).',13,10
        PS 'VESA fail bits: 1 4F01  2 window  4 layout  8 set/4F03  10 refresh  20 memory',13,10
        PS '  40 4F06  80 4F07/4F09  100 CRTC geometry vs 4F01  200 datasheet clock/colour',13,10
        PS '  400 refresh vs CRTC/PLL math  800 datasheet memory mapping (CR31/CR58-5A)',13,10
        PS 'Line info: measured kHz, H = total pixels per line (LCD clock setting), V = total lines.',13,10
        PS '16-colour VESA modes: memory bit 20 = separate pattern per plane at every bank.',13,10
        PS 'VESA warn bits: 1 refresh math factor 2  2 DCLK above datasheet max',13,10
        PS '  4 CR50 GE pixel length/width  10 interlace on  20 LFB on planar',13,10
        call bios_id
        call setup
        call post_tests
        mov byte [pass],1
        PS 13,10,'--- VGA BIOS modes vs IBM reference tables (VGATEST, IBM parameter table) ---',13,10
        call vga_pass
        call modex_all
        PS 13,10,'--- VGA BIOS functions ---',13,10
        call bios_tests
        PS 13,10,'--- VESA BIOS ---',13,10
        call vesa_global
        PS 13,10,'--- VESA modes (every listed mode, banked and linear) ---',13,10
        call vesa_modes
        PS 13,10,'--- S3 SVGA modes via INT 10h AH=00 (same registers as the VESA set) ---',13,10
        call svga_modes
        PS 13,10,'--- VESA functions ---',13,10
        call vesa_func
        mov byte [pass],2
        PS 13,10,'--- Pass 2: VGA modes set right after a VESA mode (leftover state) ---',13,10
        call vga_pass
        call modex_all
        call cleanup
        cli
        mov al,0x36
        out 0x43,al
        xor al,al
        out 0x40,al
        out 0x40,al
        sti
        PS 13,10,'Passed: '
        movzx eax,word [npass]
        call pdec
        PS '  Failed: '
        movzx eax,word [nfail]
        call pdec
        PS '  Warnings: '
        movzx eax,word [nwarn]
        call pdec
        PS '  Info: '
        movzx eax,word [ninfo]
        call pdec
        PS 13,10
        mov byte [tofile],1             ; console: buffer is printed now, in text mode
        call restore_screen             ; before the console write, so the summary lands below the old screen
        call flush
        call vdone
        mov ax,0x4C00
        cmp word [nfail],0
        je .x
        mov al,1
.x:     int 0x21

; ======================================================================

; INFO: print the version string (searched for '2.04' in the first 512 bytes of C000).
bios_id:
        PS 'ROM: '
        push es
        mov ax,0xC000
        mov es,ax
        xor si,si
        mov cx,0x200
.f:     cmp dword [es:si],'2.04'
        je .g
        inc si
        loop .f
        pop es
        PS '(version string not found)',13,10
        ret
.g:     mov cx,24
.p:     mov al,[es:si]
        cmp al,32
        jb .e
        call putc
        inc si
        loop .p
.e:     pop es
        PS 13,10
        ret

; POST state checked against the datasheet

; POST state against the datasheet. Fail bits:
;   1 MCLK PLL VCO outside 135-340 MHz or N = 0
;   2 CR36 bits 3-2 not 00 (not 1-cycle EDO) or MCLK above 60 MHz (1-cycle EDO needs >= 16.67 ns)
post_tests:
        call unlock
        TB 'MCLK PLL (SR10/SR11) vs datasheet'
        call tdots
        RS 0x10
        mov [pn],al
        RS 0x11
        mov [pm],al
        mov al,[pn]
        mov ah,[pm]
        call pllcalc                    ; -> [vco],[fout] kHz
        PS 'MCLK '
        mov eax,[fout]
        call pkhz
        PS ' VCO '
        mov eax,[vco]
        call pkhz
        cmp dword [vco],135000
        jb .f1
        cmp dword [vco],340000
        ja .f1
        test byte [pn],0x1F
        jz .f1
        jmp .c2
.f1:    FAILB 1
.c2:    RC 0x36
        mov [tmpb],al
        PS ' CR36='
        mov al,[tmpb]
        call phex2
        test byte [tmpb],0x0C           ; 00 = 1-cycle EDO
        jnz .f2
        cmp dword [fout],60000          ; 1-cycle EDO: MCLK cycle >= 16.67 ns
        jbe .ok
.f2:    FAILB 2
.ok:    call tend
        ret

; AL = N byte (SR10/SR12 style), AH = M byte -> [vco], [fout] in kHz

; PLL: f = 14.31818 MHz * (M+2) / ((N+2) * 2^R); R is 2 bits plus bit 7 of the N byte (Trio64V2).
pllcalc:
        push ebx
        push ecx
        push edx
        movzx ecx,al
        and cl,0x1F
        add ecx,2
        movzx ebx,ah
        and bl,0x7F
        add ebx,2
        mov dl,al
        shr dl,5
        and dl,3
        test al,0x80
        jz .r
        or dl,4
.r:     mov [prr],dl
        mov eax,14318
        imul eax,ebx
        xor edx,edx
        div ecx
        mov [vco],eax
        mov cl,[prr]
        shr eax,cl
        mov [fout],eax
        pop edx
        pop ecx
        pop ebx
        ret

pkhz:   push eax                        ; print EAX kHz as MHz with 2 decimals
        push edx
        push ebx
        xor edx,edx
        mov ebx,1000
        div ebx
        push edx
        call pdec
        mov al,'.'
        call putc
        pop eax
        xor edx,edx
        mov ebx,10
        div ebx
        cmp eax,10
        jae .t
        push eax
        mov al,'0'
        call putc
        pop eax
.t:     call pdec
        PS 'MHz'
        pop ebx
        pop edx
        pop eax
        ret


; ======================================================================
; known starting point and clean exit
SCRSAVE equ 0x8000                      ; DOS screen copy at scrseg:8000 (state buffers use 0-7FFF)

; Remember the DOS screen (mode, cursor, font height, text pages) so it can be put back at the end.
save_screen:
        mov ah,0x0F
        int 0x10
        and al,0x7F
        mov [omode],al
        mov [opage],bh
        mov ah,3
        int 0x10
        mov [ocur],dx
        mov [oshape],cx
        push ds
        push es
        xor ax,ax
        mov ds,ax
        mov al,[0x484]
        mov ah,[0x485]
        mov si,[0x44E]
        pop es
        pop ds
        mov [orows],ax
        mov [ostart],si
        cmp byte [omode],3
        ja .x
        push ds
        push es
        mov es,[scrseg]
        mov di,SCRSAVE
        mov ax,0xB800
        mov ds,ax
        xor si,si
        mov cx,0x4000                   ; all 32 KB of text pages
        rep movsw
        pop es
        pop ds
.x:     ret

restore_screen:
        cmp byte [omode],3
        jbe .t
        mov ax,3
        int 0x10
        ret
.t:     movzx ax,byte [omode]
        int 0x10
        mov ah,[orows+1]                ; font height the prompt had
        cmp ah,8
        jne .f14
        mov ax,0x1112
        xor bl,bl
        int 0x10
        jmp .c
.f14:   cmp ah,14
        jne .c
        mov ax,0x1111
        xor bl,bl
        int 0x10
.c:     push ds
        push es
        mov ax,0xB800
        mov es,ax
        xor di,di
        mov ds,[cs:scrseg]
        mov si,SCRSAVE
        mov cx,0x4000
        rep movsw
        pop es
        pop ds
        mov al,[opage]
        mov ah,5
        int 0x10
        mov ah,1
        mov cx,[oshape]
        int 0x10
        mov ah,2
        mov bh,[opage]
        mov dx,[ocur]
        int 0x10
        ret

; Known starting point. INFO: the registers as found. Then mode 03, a baseline snapshot of the
; registers in statelist, and all of VRAM zeroed through the 64 KB window (fail bit 1: 4F02 101h failed).
setup:  ; log what the card looked like, then put it into a known state
        call unlock
        TB 'Initial state: mode '
        mov al,[omode]
        call phex2
        PS ' rows '
        movzx eax,byte [orows]
        inc eax
        call pdec
        call sp1
        mov si,showlist
.l:     lodsw
        cmp ax,0xFFFF
        je .d
        push ax
        call pname
        mov al,'='
        call putc
        pop ax
        call readreg
        call phex2
        call sp1
        cmp byte [col],70
        jb .l
        PS 13,10,'      '
        jmp .l
.d:     mov byte [infoflag],1
        call tend
        TB 'Setup: mode 03, baseline, VRAM zeroed'
        call flush
        mov ax,3
        int 0x10
        call unlock
        mov si,statelist
        mov cx,STATEN
        mov di,basesnap
        call snap
        mov dword [vbeinfo],'VESA'
        mov ax,0x4F00
        mov di,vbeinfo
        int 0x10
        cmp ax,0x004F
        jne .nv
        mov ax,[vbeinfo+0x12]
        mov [banks],ax
.nv:    call zero_vram
        jnc .z
        FAILB 1
.z:     mov ax,3
        int 0x10
        call unlock
        call tdots
        movzx eax,word [banks]
        shl eax,6
        call pdec
        PS 'KB zeroed'
        call tend
        ret

zero_vram:                              ; all banks to 0 through the 64K window, CF if 4F02 failed
        mov ax,0x4F02
        mov bx,0x0101
        int 0x10
        cmp ax,0x004F
        jne .f
        xor si,si
.b:     call setbank
        push es
        mov ax,0xA000
        mov es,ax
        xor di,di
        xor eax,eax
        mov cx,0x4000
        rep stosd
        pop es
        inc si
        cmp si,[banks]
        jb .b
        clc
        ret
.f:     stc
        ret

; Leave the card in a known state. Mode 03 must give the same registers as the baseline from setup
; (WARN 01 if not, the differences are printed), the S3 extensions must be off (fail 4), then VRAM is
; zeroed again (fail 1) and mode 03 set.
cleanup:
        PS 13,10,'--- Final state ---',13,10
        TB 'Mode 03 after all tests vs baseline'
        call flush
        mov ax,3
        int 0x10
        call unlock
        call tdots
        mov si,statelist
        mov cx,STATEN
        mov di,snapA
        call snap
        mov si,statelist
        mov cx,STATEN
        mov bx,snapA
        mov di,basesnap
        mov dx,0
        call cmpsnap
        cmp byte [mm_n],0
        je .s
        PS 'leftover from the tests'
        WARNB 1
.s:     mov si,vgaext
        mov dx,4
        call extchk
        call tend
        TB 'Cleanup: VRAM zeroed, mode 03'
        call flush
        call zero_vram
        jnc .z
        FAILB 1
.z:     mov ax,3
        int 0x10
        call tdots
        call tend
        ret

; registers shown in the initial state line
showlist: db 0,0, 2,0x10, 2,0x11, 2,0x12, 2,0x13, 2,0x15, 2,0x18, 2,0x1A
        db 3,0x31, 3,0x36, 3,0x3A, 3,0x42, 3,0x50, 3,0x51, 3,0x58, 3,0x59, 3,0x5A
        db 3,0x5D, 3,0x5E, 3,0x67, 3,0x69, 3,0x6A, 3,0x6D, 3,0x90, 3,0x91
        dw 0xFFFF
; registers compared between the start and the end (mode 03 both times). SR12/SR13 (DCLK PLL) are
; left out: mode 03 uses clock select 1 (28 MHz), so they only hold whatever the last VESA mode set
statelist: db 0,0, 2,1, 2,2, 2,3, 2,4, 2,0x0A, 2,0x0B, 2,0x0D, 2,0x10, 2,0x11
        db 2,0x15, 2,0x18, 2,0x1A
%assign i 0
%rep 25
        db 3,i
%assign i i+1
%endrep
        db 3,0x31, 3,0x32, 3,0x33, 3,0x35, 3,0x3A, 3,0x3C, 3,0x40, 3,0x42
        db 3,0x43, 3,0x50, 3,0x51, 3,0x53, 3,0x54, 3,0x58, 3,0x59, 3,0x5A, 3,0x5D
        db 3,0x5E, 3,0x60, 3,0x65, 3,0x66, 3,0x67, 3,0x69, 3,0x6A, 3,0x6B, 3,0x6C
        db 3,0x90
        db 5,5, 5,6, 4,0x10
STATEN  equ ($-statelist)/2

; ======================================================================
; VGA pass
VENT    equ 114

; All entries of vgaref: modes 00h-06h, 0Dh, 0Eh, 10h-13h at 400/480 lines and modes 00h-03h at
; 350 lines. Run twice: pass 1 from a clean state, pass 2 right after a VESA mode (prevesa).
vga_pass:
        mov word [vi],0
.l:     mov ax,[vi]
        cmp ax,VGAN
        jae .d
        imul si,ax,VENT
        add si,vgaref
        mov [ent],si
        call vga_one
        inc word [vi]
        jmp .l
.d:     ret

prevesa dw 0x4101,0x0111,0x0105,0x0103,0x4111,0x0101,0x0112,0x0107,0x4103,0x0131,0x0133,0x0102,0x0120
        dw 0x0101,0x0105,0x4101,0x0111     ; for the four 350-line entries

; One VGA mode against the IBM reference. Fail bits:
;   1  MISC, FEAT, SR, CRTC, ATC or GR register differs from IBM (all 62, detail lines show which)
;   2  AH=1Bh state block differs from IBM (bit 4 of +2Dh ignored), or AH=0Fh mode/columns/page wrong
;   4  an S3 extension is still on (vgaext: clock select, CR31, CR58, CR67, CR51, CR43, CR5D, CR5E,
;      CR69, CR90 bit 7, SR15, SR18)
;   8  measured refresh more than 1.5 Hz from the reference (70 Hz, 60 Hz for 11h/12h)
;   10 memory test of the mode's video memory failed
;   20 default DAC not loaded as IBM does: 256-colour table (13h), CGA palette (04h-06h, 0Dh, 0Eh),
;      EGA palette (all others, also in 350-line text)
;   40 measured refresh does not match the rate predicted from the CRTC and clock registers
; Warn bit 1: mode 10h reports 21 rows / 16 lines in AH=1Bh because the 8x14 font is missing (known).
; The 350-line entries select 350 scan lines with AH=12h BL=30h AL=01h first and go back to 400 after.
; Expect PASS for every entry (WARN 01 for mode 10h).
vga_one:
        TB 'VGA '
        mov si,[ent]
        mov al,[si]
        call phex2
        PS 'h'
        test byte [si+1],0x80
        jz .s1
        PS ' 350'
.s1:    cmp byte [pass],2
        jne .s2
        PS ' after '
        mov si,[vi]
        shl si,1
        mov ax,[prevesa+si]
        call phex4
.s2:    call flush
        cmp byte [pass],2
        jne .s
        mov si,[vi]
        shl si,1
        mov bx,[prevesa+si]
        mov ax,0x4F02
        int 0x10
.s:     mov si,[ent]
        test byte [si+1],0x80
        jz .s400
        mov ax,0x1201                   ; 350-line variant: alternate select 350 scan lines
        mov bl,0x30
        int 0x10
        mov si,[ent]
.s400:  movzx ax,byte [si]
        int 0x10
        call unlock
        call tdots
        ; standard registers vs IBM
        mov si,vgalist
        mov cx,62
        mov di,snapA
        call snap
        mov si,vgalist
        mov cx,62
        mov bx,snapA
        mov di,[ent]
        add di,5
        mov dx,1
        call cmpsnap
        ; AH=1B dynamic state vs IBM
        mov di,dsbuf
        mov cx,32
        xor ax,ax
        rep stosw
        mov di,dsbuf
        xor bx,bx
        mov ah,0x1B
        int 0x10
        mov dword [vtag],'1B  '         ; /V: the state block
        mov si,dsbuf
        mov cx,64
        call vblk
        mov si,dsbuf+4
        mov di,[ent]
        add di,67
        mov cx,47
        mov bl,4
.dl:    mov al,[si]
        mov ah,[di]
        cmp bl,0x2D
        jne .dc
        and ax,0xEFEF                   ; bit 4 cursor emulation flag: reporting detail
.dc:    cmp al,ah
        je .dn
        push si
        mov si,[ent]
        cmp byte [si],0x10
        pop si
        jne .dfl
        cmp bl,0x22
        je .dkn
        cmp bl,0x23
        jne .dfl
.dkn:   WARNB 1                         ; mode 10h: 8x16 font used, 8x14 missing (known)
        jmp .dn
.dfl:   push bx
        mov ah,bl
        mov bl,al
        mov bh,[di]
        mov al,6
        call mm_add
        pop bx
        FAILB 2
.dn:    inc si
        inc di
        inc bl
        loop .dl
        ; AH=0F
        mov ah,0x0F
        int 0x10
        mov si,[ent]
        mov cl,[si+68]                  ; columns from AH=1B reference
        cmp al,[si]
        jne .f0
        cmp ah,cl
        jne .f0
        or bh,bh
        jz .ext
.f0:    FAILB 2
        mov bl,al
        mov bh,[si]
        mov ax,0x0007
        call mm_add
        ; S3 extensions must be inactive in VGA modes
.ext:   mov si,vgaext
        mov dx,4
        call extchk
        ; refresh
        call measure
        mov [hz],ax
        mov si,[ent]
        movzx bx,byte [si+2]
        imul bx,bx,10
        sub ax,bx
        jns .p
        neg ax
.p:     cmp ax,15
        jbe .m1
        FAILB 8
.m1:    call predict
        mov [phz],ax
        call cmphz                      ; -> fail 40 / warn
        jnc .m2
        FAILB 0x40
.m2:    PS 'Hz '
        movzx eax,word [hz]
        call pdec10
        mov al,'/'
        call putc
        movzx eax,word [phz]
        call pdec10
        xor ax,ax
        call lineinfo
        ; default DAC loaded by the mode set, as the IBM VGA BIOS does it:
        ; 13h the 256-colour table, 04h-06h/0Dh/0Eh (200 lines) the CGA palette, all others the EGA palette
        mov si,[ent]
        mov al,[si]
        cmp al,0x13
        jne .dg
        call dac_256
        jmp .mem
.dg:    mov byte [cgapal],0
        cmp al,4
        jb .de
        cmp al,6
        jbe .dcg
        cmp al,0x0D
        jb .de
        cmp al,0x0E
        ja .de
.dcg:   mov byte [cgapal],1
.de:    call dac_ega
.mem:   mov si,[ent]
        mov al,[si+1]
        and al,0x7F
        mov cx,[si+3]
        call memtest
        jnc .e
        FAILB 0x10
.e:     mov si,[ent]
        test byte [si+1],0x80
        jz .e4
        mov ax,0x1202                   ; back to 400 scan lines for the following modes
        mov bl,0x30
        int 0x10
.e4:    call pause
        call tend
        ret

; DAC 0-63 after the mode set. [cgapal]=0: EGA 64-colour palette, colour bits 5-0 = r g b R G B,
; component = 2Ah * (R, G or B bit 2-0) + 15h * (r, g or b bit 5-3).
; [cgapal]=1: CGA palette of the 200-line modes, bits 2-0 = R G B, bit 4 = intensity (+15h on all
; three), bits 3 and 5 ignored, and colour 6 is brown (green 15h instead of 2Ah).
; Expect every entry to match; the first mismatch fails bit 20 and is printed.
dac_ega:
        mov di,dacbuf
        xor al,al
        mov cx,64
        call dacread
        xor bx,bx
        mov si,dacbuf
.l:     mov ax,0x2004                   ; red: 2Ah if bit 2, 15h if bit 5
        call dexp
        cmp dl,[si]
        jne .bad
        mov ax,0x1002                   ; green: bits 1 and 4
        call dexp
        cmp byte [cgapal],1
        jne .g
        mov cl,bl
        and cl,0x17
        cmp cl,6
        jne .g
        mov dl,0x15                     ; CGA brown
.g:     cmp dl,[si+1]
        jne .bad
        mov ax,0x0801                   ; blue: bits 0 and 3
        call dexp
        cmp dl,[si+2]
        jne .bad
        add si,3
        inc bx
        cmp bx,64
        jb .l
        ret
.bad:   FAILB 0x20
        PS ' DAC#'
        mov al,bl
        call phex2
        cmp byte [cgapal],1
        je .bc
        PS ' not EGA'
        ret
.bc:    PS ' not CGA'
        ret

; expected component for DAC entry BL: AL = bit worth 2Ah, AH = bit worth 15h (EGA); CGA uses bit 4 for 15h
dexp:   mov dl,0
        test bl,al
        jz .1
        add dl,0x2A
.1:     cmp byte [cgapal],1
        jne .2
        mov ah,0x10
.2:     test bl,ah
        jz .3
        add dl,0x15
.3:     ret

; Mode 13h: DAC 0-247 must equal IBM's default table (248-255 are 0 in IBM and not compared).
dac_256:
        mov di,dacbuf
        xor al,al
        mov cx,256
        call dacread
        mov si,dacbuf
        mov di,dac_col
        mov cx,744
        xor bx,bx
.l:     mov al,[si+bx]
        cmp al,[di+bx]
        jne .bad
        inc bx
        loop .l
        ret
.bad:   FAILB 0x20
        PS ' DAC#'
        mov ax,bx
        mov cl,3
        div cl
        call phex2
        PS ' wrong'
        ret

; Read CX DAC entries from index AL into DI (R, G, B, 6 bit each).
dacread:                                ; AL = first, CX = count, DI = dest
        push dx
        mov dx,0x3C7
        out dx,al
        mov dx,0x3C9
        imul cx,cx,3
.l:     in al,dx
        stosb
        loop .l
        pop dx
        ret

; Video memory test of a VGA mode: write an address-derived pattern and read it back.
; Text and CGA modes at B800 (the mode's page size), planar modes plane by plane at A000, chain-4 64 KB.
memtest:                                ; AL type, CX bytes -> CF on error
        cmp al,1
        je .lin8
        cmp al,2
        je .lin8
        cmp al,3
        je mplan
        mov ax,0xA000
        xor cx,cx                       ; 65536
        jmp mlin
.lin8:  mov ax,0xB800
        jmp mlin

mlin:   push es
        mov es,ax
        mov [mlen],cx
        xor di,di
.w:     mov ax,di
        xor al,ah
        add al,0x5B
        stosb
        dec word [mlen]
        jnz .w
        mov [mlen],cx
        xor di,di
.r:     mov ax,di
        xor al,ah
        add al,0x5B
        cmp al,[es:di]
        jne .bad
        inc di
        dec word [mlen]
        jnz .r
        pop es
        clc
        ret
.bad:   pushad                          ; /V: first mismatch
        movzx ebx,al
        movzx ecx,byte [es:di]
        mov ax,es
        movzx eax,ax
        shl eax,4
        movzx edx,di
        add eax,edx
        call vmem
        popad
        pop es
        stc
        ret

mplan:  push es
        mov ax,0xA000
        mov es,ax
        mov dx,0x3CE
        mov ax,0x0005
        out dx,ax
        mov ax,0x0003
        out dx,ax
        mov ax,0xFF08
        out dx,ax
        mov ax,0x0001
        out dx,ax
        xor bx,bx
.wp:    mov dx,0x3C4
        mov ah,1
        mov cl,bl
        shl ah,cl
        mov al,2
        out dx,ax
        xor di,di
.w:     mov ax,di
        xor al,ah
        add al,bl
        add al,0x37
        stosb
        or di,di
        jnz .w
        inc bx
        cmp bx,4
        jb .wp
        mov dx,0x3C4
        mov ax,0x0F02
        out dx,ax
        xor bx,bx
.rp:    mov dx,0x3CE
        mov al,4
        mov ah,bl
        out dx,ax
        xor di,di
.r:     mov ax,di
        xor al,ah
        add al,bl
        add al,0x37
        cmp al,[es:di]
        jne .bad
        inc di
        jnz .r
        inc bx
        cmp bx,4
        jb .rp
        mov dx,0x3CE
        mov ax,0x0004
        out dx,ax
        pop es
        clc
        ret
.bad:   pushad                          ; /V: first mismatch, address = plane:offset
        movzx ecx,byte [es:di]
        movzx edx,bx                    ; plane
        movzx ebx,al                    ; expected
        mov eax,edx
        shl eax,16
        mov ax,di
        call vmem
        popad
        mov dx,0x3CE
        mov ax,0x0004
        out dx,ax
        pop es
        stc
        ret

; ======================================================================
; Mode X family: misc, hz10, count, regs...
mxtab:  db 0x63
        dw 701
        db 2
        dw 0x0014,0xE317
        db 'Mode Y 320x200 unchained$'
        db 0xE3
        dw 599
        db 10
        dw 0x0D06,0x3E07,0x4109,0xEA10,0xAC11,0xDF12,0x0014,0xE715,0x0616,0xE317
        db 'Mode X 320x240$'
        db 0x63
        dw 701
        db 3
        dw 0x4009,0x0014,0xE317
        db 'Mode X 320x400$'
        db 0xE7
        dw 602
        db 18
        dw 0x6B00,0x5901,0x5A02,0x8E03,0x5E04,0x8A05,0x0D06,0x3E07,0x4109,0xEA10,0xAC11,0xDF12,0x2D13,0x0014,0xE715,0x0616,0xE317
        dw 0x0000
        db 'Mode X 360x240$'
        db 0xE7
        dw 602
        db 18
        dw 0x6B00,0x5901,0x5A02,0x8E03,0x5E04,0x8A05,0x0D06,0x3E07,0x4009,0xEA10,0xAC11,0xDF12,0x2D13,0x0014,0xE715,0x0616,0xE317
        dw 0x0000
        db 'Mode X 360x480$'
        db 0
mxtext: db 'Text 80x50 (AX=1112)$'

; Mode X family (unchained 256-colour modes made from 13h by register writes, as games do) and
; 80x50 text (AX=1112h). Fail bits: 1 font height (CR09) wrong in 80x50, 2 BIOS data rows/height
; wrong, 4 S3 extension left on, 8 refresh off by more than 1.5 Hz, 10 planar memory test,
; 40 refresh vs register prediction. Expect PASS: tests the FIFO fix (CR90) after VESA modes in pass 2.
modex_all:
        mov si,mxtab
.l:     cmp byte [si],0
        je .t
        mov [ent],si
        call modex_one
        mov si,[ent]
        movzx cx,byte [si+3]
        add si,4
        shl cx,1
        add si,cx
.s:     lodsb
        cmp al,'$'
        jne .s
        jmp .l
.t:     ; 80x50 text
        TB 'Text 80x50 (AX=1112)'
        cmp byte [pass],2
        jne .t1
        PS ' (pass 2)'
.t1:    call flush
        mov ax,3
        int 0x10
        mov ax,0x1112
        xor bl,bl
        int 0x10
        call unlock
        call tdots
        push es
        xor ax,ax
        mov es,ax
        mov al,[es:0x484]
        mov ah,[es:0x485]
        pop es
        cmp ax,0x0831
        je .t2
        FAILB 2
.t2:    RC 9
        and al,0x1F
        cmp al,7
        je .t3
        FAILB 1
.t3:    mov si,vgaext
        mov dx,4
        call extchk
        call measure
        mov [hz],ax
        sub ax,701
        jns .t4
        neg ax
.t4:    cmp ax,15
        jbe .t5
        FAILB 8
.t5:    PS 'Hz '
        movzx eax,word [hz]
        call pdec10
        call tend
        mov ax,3
        int 0x10
        ret

; One Mode X variant: mode 13h, then sequencer/misc/CRTC writes from mxtab, measure, memory test.
modex_one:
        call tbeginx
        mov si,[ent]
        movzx cx,byte [si+3]
        add si,4
        shl cx,1
        add si,cx
        cmp word [si],0
        jne .n
        add si,2
.n:     mov dx,si
        call puts
        cmp byte [pass],2
        jne .n2
        PS ' after 4101'
.n2:    call flush
        cmp byte [pass],2
        jne .s
        mov ax,0x4F02
        mov bx,0x4101
        int 0x10
.s:     mov ax,0x13
        int 0x10
        call unlock
        mov si,[ent]
        mov dx,0x3C4
        mov ax,0x0604
        out dx,ax
        mov ax,0x0100
        out dx,ax
        mov dx,0x3C2
        mov al,[si]
        out dx,al
        mov dx,0x3C4
        mov ax,0x0300
        out dx,ax
        mov dx,0x3D4
        mov al,0x11
        out dx,al
        inc dx
        in al,dx
        and al,0x7F
        out dx,al
        dec dx
        movzx cx,byte [si+3]
        add si,4
.r:     lodsw
        out dx,ax
        loop .r
        call tdots
        mov si,vgaext
        mov dx,4
        call extchk
        call measure
        mov [hz],ax
        mov si,[ent]
        sub ax,[si+1]
        jns .p
        neg ax
.p:     cmp ax,15
        jbe .q
        FAILB 8
.q:     call predict
        mov [phz],ax
        call cmphz
        jnc .q2
        FAILB 0x40
.q2:    PS 'Hz '
        movzx eax,word [hz]
        call pdec10
        mov al,'/'
        call putc
        movzx eax,word [phz]
        call pdec10
        xor ax,ax
        call lineinfo
        call mplan
        jnc .m
        FAILB 0x10
.m:     call pause
        call tend
        ret

; ======================================================================
; VGA BIOS function tests (after VGATEST)

; VGA BIOS functions, after VGATEST tests 2-12. Each test is one result line; fail bits per test:
;   AH=01/02/03 cursor   1 CR0A/CR0B not 0D/0E for shape 0607h (emulation), 2 AH=03 shape,
;                        4 CR0E/CR0F or AH=03 position, 8 emulation off (AH=12 BL=34) not honoured
;   AH=04 light pen      1 a light pen reported (the VGA has none)
;   AH=05 pages          1 CR0C/CR0D start address not page * page size (mode 03 page 3, 0Dh page 7)
bios_tests:
        ; ---- cursor
        mov ax,3
        int 0x10
        TB 'AH=01/02/03 cursor + emulation'
        call tdots
        mov ah,1
        mov cx,0x0607
        int 0x10
        RC 0x0A
        and al,0x1F
        mov bl,al
        mov bh,0x0D
        cmp bl,bh
        je .c1
        mov ax,0x0A03
        call mm_add
        FAILB 1
.c1:    RC 0x0B
        and al,0x1F
        mov bl,al
        mov bh,0x0E
        cmp bl,bh
        je .c2
        mov ax,0x0B03
        call mm_add
        FAILB 1
.c2:    mov ah,3
        xor bh,bh
        int 0x10
        cmp cx,0x0607
        je .c3
        FAILB 2
.c3:    mov ah,2
        xor bh,bh
        mov dx,0x0510
        int 0x10
        RC 0x0E
        mov ah,al
        push ax
        RC 0x0F
        pop bx
        mov bl,al
        cmp bx,5*80+16
        je .c4
        FAILB 4
.c4:    mov ah,3
        xor bh,bh
        int 0x10
        cmp dx,0x0510
        je .c5
        FAILB 4
.c5:    mov ax,0x1201                   ; emulation off
        mov bl,0x34
        int 0x10
        cmp al,0x12
        je .c6
        FAILB 8
.c6:    mov ah,1
        mov cx,0x0607
        int 0x10
        RC 0x0A
        and al,0x1F
        cmp al,6
        jne .c7
        RC 0x0B
        and al,0x1F
        cmp al,7
        je .c8
.c7:    FAILB 8
.c8:    mov ax,0x1200
        mov bl,0x34
        int 0x10
        call tend
        ; ---- light pen
        TB 'AH=04 light pen not present'
        call tdots
        mov ah,4
        int 0x10
        or ah,ah
        jz .l1
        FAILB 1
.l1:    call tend
        ; ---- pages
        TB 'AH=05 pages (mode 03 p3, mode 0D p7)'
        call tdots
        mov ax,3
        int 0x10
        mov ax,0x0503
        int 0x10
        call pgchk
        mov ax,0x0D
        int 0x10
        mov ax,0x0507
        int 0x10
        call pgchk
        mov ax,0x0500
        int 0x10
        call tend
        ; ---- scroll
        call scroll_test
        ; ---- text I/O
        call textio
        ; ---- pixels
        call pixels
        ; ---- palette
        call palette_tests
        ; ---- save/restore
        call saverest
        ; ---- fonts
        call fonts
        ; ---- alternate select
        call altsel
        ; ---- DCC, static table, EGA info
        call misc_bios
        ret

; Active page start in CR0C/CR0D must equal 40:4E (halved in word mode).
pgchk:  push es
        xor ax,ax
        mov es,ax
        mov bl,[es:0x462]
        mov cx,[es:0x44E]
        pop es
        mov [tmpw],cx
        RC 0x0C
        mov ah,al
        push ax
        RC 0x0D
        pop dx
        mov dl,al                       ; DX = start register
        RC 0x17
        mov cx,[tmpw]
        test al,0x40
        jnz .b
        shr cx,1                        ; word mode
.b:     cmp dx,cx
        je .ok
        FAILB 1
        PS ' start='
        mov ax,dx
        call phex4
        PS '('
        mov ax,cx
        call phex4
        PS ')'
.ok:    ret

; fill text rows with 'A'+row
tfill:  push es
        mov ax,0xB800
        mov es,ax
        xor di,di
        mov dl,0
.r:     mov cx,80
        mov al,'A'
        add al,dl
        mov ah,7
        rep stosw
        inc dl
        cmp dl,25
        jb .r
        pop es
        ret
tget:   ; DH row DL col -> AX char/attr
        push es
        push bx
        mov ax,0xB800
        mov es,ax
        movzx bx,dh
        imul bx,bx,80
        movzx ax,dl
        add bx,ax
        shl bx,1
        mov ax,[es:bx]
        pop bx
        pop es
        ret
texp:   ; DX pos, BX expected
        call tget
        cmp ax,bx
        je .ok
        FAILB 1
        PS ' @'
        mov ax,dx
        call phex4
.ok:    ret

; AH=06/07 scroll up/down, whole screen and a window. Fail bit 1: a character/attribute at a checked
; position differs (blank lines must carry the fill attribute).
scroll_test:
        mov ax,3
        int 0x10
        TB 'AH=06/07 scroll full and window'
        call tdots
        call tfill
        mov ax,0x0601
        mov bh,0x1E
        xor cx,cx
        mov dx,0x184F
        int 0x10
        mov dx,0x0000
        mov bx,0x0742
        call texp
        mov dx,0x174F
        mov bx,0x0759
        call texp
        mov dx,0x1800
        mov bx,0x1E20
        call texp
        mov ax,0x0701
        mov bh,0x07
        xor cx,cx
        mov dx,0x184F
        int 0x10
        mov dx,0x0000
        mov bx,0x0720
        call texp
        mov dx,0x0105
        mov bx,0x0742
        call texp
        call tfill
        mov ax,0x0602
        mov bh,0x70
        mov cx,0x0505
        mov dx,0x0A0A
        int 0x10
        mov dx,0x0505
        mov bx,0x0748
        call texp
        mov dx,0x0504
        mov bx,0x0746
        call texp
        mov dx,0x090A
        mov bx,0x7020
        call texp
        mov dx,0x0B05
        mov bx,0x074C
        call texp
        call tend
        ret

; AH=08/09/0A/0E in text modes 01h and 03h. Fail bits: 1 AH=09 char+attribute or count,
; 2 AH=0A keeps the attribute, 4 AH=0Eh teletype position. Graphics modes 04h, 0Dh, 12h, 13h:
; AH=09 then AH=08 must read the same character back (fail 1).
textio: mov byte [tmpb],1
.m:     TB 'AH=08/09/0A/0E text I/O mode '
        mov al,[tmpb]
        call phex2
        call flush
        movzx ax,byte [tmpb]
        int 0x10
        call tdots
        mov ah,2
        xor bh,bh
        mov dx,0x0203
        int 0x10
        mov ax,0x0951
        mov bx,0x001E
        mov cx,3
        int 0x10
        mov dx,0x0205
        call rdch
        cmp ax,0x1E51
        je .a
        FAILB 1
.a:     mov dx,0x0206
        call rdch
        cmp ax,0x0720
        je .b
        FAILB 1
.b:     mov ah,2
        xor bh,bh
        mov dx,0x0206
        int 0x10
        mov ax,0x0A52
        xor bh,bh
        mov cx,1
        int 0x10
        mov dx,0x0206
        call rdch
        cmp ax,0x0752
        je .c
        FAILB 2
.c:     mov ah,2
        xor bh,bh
        mov dx,0x0300
        int 0x10
        mov ax,0x0E5A
        xor bx,bx
        int 0x10
        mov ah,3
        xor bh,bh
        int 0x10
        cmp dx,0x0301
        je .d
        FAILB 4
.d:     mov dx,0x0300
        call rdch
        cmp al,'Z'
        je .e
        FAILB 4
.e:     call tend
        add byte [tmpb],2
        cmp byte [tmpb],5
        jb .m
        ; graphics modes: write char, read back via font match
        mov si,gtmodes
.g:     lodsb
        or al,al
        jz .gd
        mov [tmpb],al
        push si
        TB 'AH=09/08 graphics char mode '
        mov al,[tmpb]
        call phex2
        call flush
        movzx ax,byte [tmpb]
        int 0x10
        call tdots
        mov ah,2
        xor bh,bh
        mov dx,0x0101
        int 0x10
        mov ax,0x0941
        mov bx,0x0003
        mov cx,1
        int 0x10
        mov dx,0x0101
        call rdch
        cmp al,'A'
        je .g1
        FAILB 1
.g1:    call tend
        pop si
        jmp .g
.gd:    ret
gtmodes db 4,0x0D,0x12,0x13,0

rdch:   mov ah,2
        xor bh,bh
        int 0x10
        mov ah,8
        xor bh,bh
        int 0x10
        ret

; ---- pixels: mode, colours, maxx, maxy
pxtab:  db 4,4
        dw 319,199
        db 6,2
        dw 639,199
        db 0x0D,16
        dw 319,199
        db 0x0E,16
        dw 639,199
        db 0x10,16
        dw 639,349
        db 0x11,2
        dw 639,479
        db 0x12,16
        dw 639,479
        db 0x13,0
        dw 319,199
        db 0xFF

; AH=0C/0D in modes 04h, 06h, 0Dh, 0Eh, 10h, 11h, 12h, 13h at corners and inner points.
; Fail bits: 1 read back differs, 2 XOR write (colour bit 7) did not clear the pixel,
; 4 mode 13h pixel not at A000:y*320+x.
pixels: mov si,pxtab
.m:     cmp byte [si],0xFF
        je .d
        mov [ent],si
        TB 'AH=0C/0D pixels mode '
        mov si,[ent]
        mov al,[si]
        call phex2
        call flush
        mov si,[ent]
        movzx ax,byte [si]
        int 0x10
        call tdots
        mov word [vi],0
.p:     cmp word [vi],6
        jae .x
        call pxy
        call pcol
        mov [tmpb],al
        mov ah,0x0C
        xor bh,bh
        int 0x10
        call pxy
        mov ah,0x0D
        xor bh,bh
        int 0x10
        cmp al,[tmpb]
        je .n
        FAILB 1
.n:     inc word [vi]
        jmp .p
.x:     mov si,[ent]
        cmp byte [si+1],0
        je .m13
        mov word [vi],2                 ; XOR the same colour onto point 2 -> 0
        call pcol
        or al,0x80
        push ax
        call pxy
        pop ax
        mov ah,0x0C
        xor bh,bh
        int 0x10
        call pxy
        mov ah,0x0D
        xor bh,bh
        int 0x10
        or al,al
        jz .e
        FAILB 2
        jmp .e
.m13:   push es                         ; mode 13: pixel (100,50) lives at A000:50*320+100
        mov ax,0xA000
        mov es,ax
        mov al,[es:50*320+100]
        pop es
        mov [tmpb],al
        mov word [vi],5
        call pcol
        cmp al,[tmpb]
        je .e
        FAILB 4
.e:     call tend
        mov si,[ent]
        add si,6
        jmp .m
.d:     ret
pcol:   mov al,[vi]                     ; -> AL colour for point [vi]
        mov ah,5
        mul ah
        add al,3
        mov si,[ent]
        mov ah,[si+1]
        or ah,ah
        jz .r
        dec ah
        and al,ah
.r:     ret
pxy:    mov si,[ent]                    ; -> CX,DX for point [vi]
        mov bx,[vi]
        xor cx,cx
        xor dx,dx
        cmp bx,0
        je .r
        mov cx,1
        cmp bx,1
        je .r
        mov cx,2
        mov dx,1
        cmp bx,2
        je .r
        mov cx,[si+2]
        mov dx,[si+4]
        cmp bx,3
        je .r
        dec cx
        cmp bx,4
        je .r
        mov cx,100
        mov dx,50
.r:     ret

; Palette and DAC functions. Fail bits per test:
;   1000/1007   1 AR register not written, 2 read back wrong
;   1001/1008   1 overscan AR11 not written, 2 read back wrong
;   1002/1009   1 the 17 registers read back differ
;   1003        1 blink off not in AR10 bit 3, 2 blink on not set
;   1010/1015, 1012/1017   1 single DAC entry, 2 block read back, 4 hardware readback via 3C7/3C9
;   3C6/3C7     1 pixel mask not FFh, 2 status not 3 after a read index, 4 status not 0 after write index
;   1013/101A   1 colour page select not read back
;   101B        1 grey value of an entry more than 1 off (30R+59G+11B)/100 of IBM's default
palette_tests:
        mov ax,0x12
        int 0x10
        TB 'AX=1000/1007 palette register'
        call tdots
        mov ax,0x1000
        mov bx,0x0502
        int 0x10
        mov ax,0x0204
        call readreg
        cmp al,5
        je .a
        FAILB 1
.a:     mov ax,0x1007
        mov bl,2
        int 0x10
        cmp bh,5
        je .b
        FAILB 2
.b:     call tend
        TB 'AX=1001/1008 overscan'
        call tdots
        mov ax,0x1001
        mov bh,0x0F
        int 0x10
        mov ax,0x1104
        call readreg
        cmp al,0x0F
        je .c
        FAILB 1
.c:     mov ax,0x1008
        int 0x10
        cmp bh,0x0F
        je .d
        FAILB 2
.d:     mov ax,0x1001
        xor bh,bh
        int 0x10
        call tend
        TB 'AX=1002/1009 all palette regs'
        call tdots
        mov ax,0x1002
        mov dx,paltab
        int 0x10
        mov di,palrd
        mov ax,0x1009
        mov dx,di
        int 0x10
        mov si,paltab
        mov di,palrd
        mov cx,17
        repe cmpsb
        je .e
        FAILB 1
.e:     call tend
        mov ax,3
        int 0x10
        TB 'AX=1003 blink/intensity'
        call tdots
        mov ax,0x1003
        xor bl,bl
        int 0x10
        mov ax,0x1004
        call readreg
        test al,8
        jz .f
        FAILB 1
.f:     mov ax,0x1003
        mov bl,1
        int 0x10
        mov ax,0x1004
        call readreg
        test al,8
        jnz .g
        FAILB 2
.g:     call tend
        TB 'AX=1010/1015, 1012/1017 DAC'
        call tdots
        mov ax,0x1010
        mov bx,5
        mov dh,0x11
        mov cx,0x2233
        int 0x10
        mov ax,0x1015
        mov bx,5
        int 0x10
        cmp dh,0x11
        jne .h1
        cmp cx,0x2233
        je .h
.h1:    FAILB 1
.h:     mov di,dacpat                   ; block of 16 at index 0x20
        mov cx,48
        xor al,al
.hp:    stosb
        add al,7
        and al,0x3F
        loop .hp
        mov ax,0x1012
        mov bx,0x20
        mov cx,16
        mov dx,dacpat
        int 0x10
        mov ax,0x1017
        mov bx,0x20
        mov cx,16
        mov dx,dacbuf
        int 0x10
        mov si,dacpat
        mov di,dacbuf
        mov cx,48
        repe cmpsb
        je .i
        FAILB 2
.i:     mov di,dacbuf                   ; hardware readback
        mov al,0x20
        mov cx,16
        call dacread
        mov si,dacpat
        mov di,dacbuf
        mov cx,48
        repe cmpsb
        je .j
        FAILB 4
.j:     call tend
        TB 'DAC mask/status regs 3C6/3C7'
        call tdots
        mov dx,0x3C6
        in al,dx
        cmp al,0xFF
        je .k
        FAILB 1
.k:     mov dx,0x3C7
        xor al,al
        out dx,al
        in al,dx
        and al,3
        cmp al,3
        je .k2
        FAILB 2
.k2:    mov dx,0x3C8
        xor al,al
        out dx,al
        mov dx,0x3C7
        in al,dx
        and al,3
        jz .k3
        FAILB 4
.k3:    call tend
        mov ax,0x12
        int 0x10
        TB 'AX=1013/101A colour paging'
        call tdots
        mov ax,0x1013
        mov bx,0x0100
        int 0x10
        mov ax,0x1013
        mov bx,0x0301
        int 0x10
        mov ax,0x101A
        int 0x10
        cmp bx,0x0301
        je .l
        FAILB 1
.l:     mov ax,0x1013
        mov bx,0x0000
        int 0x10
        mov ax,0x1013
        mov bx,0x0001
        int 0x10
        call tend
        mov ax,0x13
        int 0x10
        TB 'AX=101B grey summing vs IBM'
        call tdots
        mov ax,0x101B
        xor bx,bx
        mov cx,256
        int 0x10
        mov di,dacbuf
        xor al,al
        mov cx,256
        call dacread
        mov si,dacbuf
        mov di,dac_col
        mov cx,744                      ; entries 0-247, each component vs grey of the default
.m:     call greyof
        sub al,[si]
        jns .m1
        neg al
.m1:    cmp al,1
        jbe .m2
        test word [fails],1
        jnz .m2
        FAILB 1
        PS 'DAC#'
        mov ax,si
        sub ax,dacbuf
        push cx
        mov cl,3
        div cl
        pop cx
        call phex2
        PS '='
        mov al,[si]
        call phex2
        PS '('
        call greyof
        call phex2
        PS ') '
.m2:    inc si
        inc di
        loop .m
        call tend
        ret

; IBM grey summing formula for one DAC entry of dac_col.
greyof: ; DI -> component inside dac_col: AL = (30R+59G+11B+50)/100 of that entry
        push bx
        push dx
        push di
        mov ax,di
        sub ax,dac_col
        mov bl,3
        div bl
        movzx ax,al
        imul ax,ax,3
        add ax,dac_col
        mov di,ax
        movzx ax,byte [di]
        imul ax,ax,30
        mov bx,ax
        movzx ax,byte [di+1]
        imul ax,ax,59
        add bx,ax
        movzx ax,byte [di+2]
        imul ax,ax,11
        add ax,bx
        add ax,50
        mov bl,100
        div bl
        pop di
        pop dx
        pop bx
        ret
paltab  db 0,1,2,3,4,5,0x14,7,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3D,0

; AH=1Ch save state in mode 03 (cursor 5,5, DAC entry 1 changed), mode 13h, restore. Fail bits:
; 1 AH=1Ch not supported, 2 registers after restore differ from mode 03 with the cursor at 5,5,
; 4 BIOS mode byte not 03, 8 DAC entry 1 not restored.
saverest:
        mov ax,3
        int 0x10
        TB 'AH=1C save/restore video state'
        call tdots
        mov ax,0x1C00
        mov cx,7
        int 0x10
        cmp al,0x1C
        je .a
        FAILB 1
        jmp .x
.a:     mov [tmpw],bx
        PS 'size '
        movzx eax,word [tmpw]
        shl eax,6
        call pdec
        mov ah,2
        xor bh,bh
        mov dx,0x0505
        int 0x10
        mov ax,0x1010
        mov bx,1
        mov dh,1
        mov cx,0x0203
        int 0x10
        push es
        mov es,[scrseg]
        xor bx,bx
        mov ax,0x1C01
        mov cx,7
        int 0x10
        pop es
        mov ax,0x13
        int 0x10
        push es
        mov es,[scrseg]
        xor bx,bx
        mov ax,0x1C02
        mov cx,7
        int 0x10
        pop es
        call unlock
        mov si,vgaref+3*VENT+5          ; mode 03 expectation, cursor at 5,5
        mov di,snapB
        mov cx,62
        rep movsb
        mov word [snapB+7+0x0E],0x9501  ; CR0E=01 CR0F=95 (405)
        mov si,vgalist
        mov cx,62
        mov di,snapA
        call snap
        mov si,vgalist
        mov cx,62
        mov bx,snapA
        mov di,snapB
        mov dx,2
        call cmpsnap
        push es
        xor ax,ax
        mov es,ax
        mov al,[es:0x449]
        pop es
        cmp al,3
        je .b
        FAILB 4
.b:     mov ax,0x1015
        mov bx,1
        int 0x10
        cmp dh,1
        jne .c
        cmp cx,0x0203
        je .x
.c:     FAILB 8
.x:     call tend
        ret

; Font information and loading. Fail bits per test:
;   1130 BH=3   1 CX/DL wrong (16 / 24 rows), 2 glyph 1 not the IBM 8x8 smiley
;   1130 BH=4   1 upper-half 8x8 glyph wrong
;   1130 BH=6   2 glyph 1 not the IBM 8x16 smiley
;   1130 BH=2   WARN 01 when the 8x14 pointer equals the 8x16 one (known: no 8x14 font in this ROM)
;   1130 BH=1   1 INT 43h in mode 13h not the 8x8 font
;   1111/1112/1114 load   1 BIOS rows/height wrong, 2 CR09 character height wrong
fonts:  mov ax,3
        int 0x10
        TB 'AX=1130 BH=3 8x8 font'
        call tdots
        mov bh,3
        call fptr
        mov [f8],ax
        mov [f8+2],dx
        cmp cx,16
        jne .f1
        cmp bl,24
        je .f1b
.f1:    FAILB 1
.f1b:   mov si,g8
        mov bx,8
        mov cx,8
        call fcmp
        jz .f2
        FAILB 2
.f2:    call tend
        TB 'AX=1130 BH=4 8x8 upper half'
        call tdots
        mov bh,4
        call fptr
        mov si,g8u
        xor bx,bx
        mov cx,8
        call fcmp
        jz .u2
        FAILB 1
.u2:    call tend
        TB 'AX=1130 BH=6 8x16 font'
        call tdots
        mov bh,6
        call fptr
        mov [f16],ax
        mov [f16+2],dx
        mov si,g16
        mov bx,16
        mov cx,16
        call fcmp
        jz .f3
        FAILB 2
.f3:    call tend
        TB 'AX=1130 BH=2 8x14 font'
        call tdots
        mov bh,2
        call fptr
        cmp ax,[f16]
        jne .f4
        PS 'same as 8x16 (known, 8x14 TSR)'
        WARNB 1
.f4:    call tend
        mov ax,0x13
        int 0x10
        TB 'AX=1130 BH=1 INT43 in mode 13'
        call tdots
        mov bh,1
        call fptr
        cmp ax,[f8]
        jne .f5
        cmp dx,[f8+2]
        je .f6
.f5:    FAILB 1
.f6:    call tend
        ; font loads
        mov word [vi],0
.ld:    mov si,[vi]
        imul si,si,5
        add si,fldtab
        mov [ent],si
        mov ax,3
        int 0x10
        mov si,[ent]
        mov ax,[si]
        xor bl,bl
        int 0x10
        TB 'AX='
        mov si,[ent]
        mov ax,[si]
        call phex4
        PS ' font load rows/height'
        call tdots
        push es
        xor ax,ax
        mov es,ax
        mov al,[es:0x484]
        mov ah,[es:0x485]
        pop es
        mov si,[ent]
        cmp ax,[si+2]
        je .l1
        FAILB 1
.l1:    RC 9
        and al,0x1F
        inc al
        mov si,[ent]
        cmp al,[si+3]
        je .l2
        FAILB 2
.l2:    call tend
        inc word [vi]
        cmp word [vi],3
        jb .ld
        mov ax,3
        int 0x10
        ret
fldtab  dw 0x1111
        db 27,14,0
        dw 0x1112
        db 49,8,0
        dw 0x1114
        db 24,16,0
g8      db 0x7E,0x81,0xA5,0x81,0xBD,0x99,0x81,0x7E
g8u     db 0x78,0xCC,0xC0,0xCC,0x78,0x18,0x0C,0x78
g16     db 0x00,0x00,0x7E,0x81,0xA5,0x81,0x81,0xBD,0x99,0x81,0x81,0x7E,0x00,0x00,0x00,0x00

; AX=1130h: BH = font -> DX:AX pointer, CX bytes per character, BL = rows - 1.
fptr:   push es                         ; BH -> DX:AX font ptr, CX, BL=DL
        push bp
        mov ax,0x1130
        int 0x10
        mov ax,bp
        mov [tmpd],ax
        mov [tmpd+2],es
        mov bl,dl
        pop bp
        pop es
        mov ax,[tmpd]
        mov dx,[tmpd+2]
        ret
fcmp:   ; DX:AX font, BX = bytes/char, SI = expected glyph 1, CX = len -> ZF
        push es
        push di
        mov es,dx
        mov di,ax
        add di,bx
        repe cmpsb
        pop di
        pop es
        ret

; AH=12h alternate select. Fail bits per test:
;   BL=30 scan lines  1 not supported, 2 350 lines not set (CR12) or 40:85 not 14, 4 400 not restored
;   BL=31 palette     1 not supported, 2 palette reloaded although disabled, 4 not reloaded when enabled
;   BL=32 video       1 not supported or CR01 changed
;   BL=33 grey        1 not supported, 2 grey summing not applied in 13h, 4 still applied after off
;   BL=36 screen      1 SR01 bit 5 not set/cleared
altsel: TB 'AH=12 BL=30 350 / 400 scan lines'
        call tdots
        mov ax,0x1201
        mov bl,0x30
        int 0x10
        cmp al,0x12
        je .a
        FAILB 1
.a:     mov ax,3
        int 0x10
        call getvde
        cmp ax,350
        je .b
        FAILB 2
.b:     push es
        xor ax,ax
        mov es,ax
        mov al,[es:0x485]
        pop es
        cmp al,14
        je .c
        FAILB 2
.c:     mov ax,0x1202
        mov bl,0x30
        int 0x10
        mov ax,3
        int 0x10
        call getvde
        cmp ax,400
        je .d
        FAILB 4
.d:     call tend
        TB 'AH=12 BL=31 default palette loading'
        call tdots
        mov ax,0x1201
        mov bl,0x31
        int 0x10
        cmp al,0x12
        je .e
        FAILB 1
.e:     mov ax,0x1010
        mov bx,1
        mov dh,1
        mov cx,0x0203
        int 0x10
        mov ax,3
        int 0x10
        mov ax,0x1015
        mov bx,1
        int 0x10
        cmp dh,1
        jne .f
        cmp cx,0x0203
        je .g
.f:     FAILB 2
.g:     mov ax,0x1200
        mov bl,0x31
        int 0x10
        mov ax,3
        int 0x10
        mov ax,0x1015
        mov bx,1
        int 0x10
        cmp dh,0
        jne .h
        cmp cx,0x002A
        je .i
.h:     FAILB 4
.i:     call tend
        TB 'AH=12 BL=32 video disable/enable'
        call tdots
        mov ax,0x1201
        mov bl,0x32
        int 0x10
        mov [tmpb],al
        mov ax,0x1200
        mov bl,0x32
        int 0x10
        cmp al,0x12
        jne .j
        cmp byte [tmpb],0x12
        jne .j
        RC 1
        cmp al,0x4F
        je .k
.j:     FAILB 1
.k:     call tend
        TB 'AH=12 BL=33 grey summing on mode set'
        call tdots
        mov ax,0x1200
        mov bl,0x33
        int 0x10
        cmp al,0x12
        je .l
        FAILB 1
.l:     mov ax,0x13
        int 0x10
        mov di,dacbuf
        mov al,1
        mov cx,1
        call dacread
        mov di,dac_col+3
        call greyof
        mov ah,al
        mov si,dacbuf
        mov cx,3
.gc:    mov al,[si]
        sub al,ah
        jns .gp
        neg al
.gp:    cmp al,1
        jbe .gn
        FAILB 2
.gn:    inc si
        loop .gc
.m:     mov ax,0x1201
        mov bl,0x33
        int 0x10
        mov ax,0x13
        int 0x10
        mov di,dacbuf
        mov al,1
        mov cx,1
        call dacread
        mov si,dacbuf
        mov di,dac_col+3
        mov cx,3
        repe cmpsb
        je .n
        FAILB 4
.n:     call tend
        mov ax,3
        int 0x10
        TB 'AH=12 BL=36 screen off/on (SR01.5)'
        call tdots
        mov ax,0x1201
        mov bl,0x36
        int 0x10
        cmp al,0x12
        jne .o
        RS 1
        test al,0x20
        jz .o
        mov ax,0x1200
        mov bl,0x36
        int 0x10
        RS 1
        test al,0x20
        jz .p
.o:     FAILB 1
.p:     call tend
        ret

; Fail bit 1 per test: AH=1Ah display combination not 08h (VGA colour) or set not accepted;
; AH=12h BL=10h not 'colour, 256 KB' (BX=0003h); AH=1Bh static table not the IBM modes mask
; (FFh E0h 0Fh) and 7 scan line flags.
misc_bios:
        mov ax,3
        int 0x10
        TB 'AH=1A display combination code'
        call tdots
        mov ax,0x1A00
        int 0x10
        cmp al,0x1A
        jne .a
        cmp bx,0x0008
        jne .a
        mov ax,0x1A01
        mov bx,0x0008
        int 0x10
        cmp al,0x1A
        je .b
.a:     FAILB 1
.b:     call tend
        TB 'AH=12 BL=10 EGA info'
        call tdots
        mov ah,0x12
        mov bl,0x10
        int 0x10
        cmp bx,0x0003
        je .c
        FAILB 1
.c:     call tend
        TB 'AH=1B static functionality table'
        call tdots
        mov di,dsbuf
        xor bx,bx
        mov ah,0x1B
        int 0x10
        cmp al,0x1B
        jne .d
        push es
        les si,[dsbuf]
        mov eax,[es:si]
        mov bl,[es:si+7]
        pop es
        mov [tmpd],eax
        mov al,[tmpd]
        call phex2
        mov al,[tmpd+1]
        call phex2
        mov al,[tmpd+2]
        call phex2
        and dword [tmpd],0x00FFFFFF
        cmp dword [tmpd],0x000FE0FF
        jne .d
        cmp bl,7
        je .e
.d:     FAILB 1
.e:     call tend
        ret

; Vertical display end from CR12, CR07 bits 1/6 and CR5E bit 1, plus 1.
getvde: RC 0x12                         ; -> AX = vertical display end + 1 (incl. CR5E)
        movzx bx,al
        RC 7
        test al,2
        jz .1
        or bh,1
.1:     test al,0x40
        jz .2
        or bh,2
.2:     RC 0x5E
        test al,2
        jz .3
        or bh,4
.3:     mov ax,bx
        inc ax
        ret

; ======================================================================
; VESA global

; VBE functions that do not depend on a mode. Fail/warn bits per test:
;   4F00 VESA   fail 1 status, signature or version < 1.2; warn 1 wrote past 256 bytes, warn 2 mode
;               list inside the caller's buffer
;   OEM string  INFO
;   4F00 VBE2   fail 1 status/signature or wrote past 512 bytes; vendor/product/revision printed
;   modes       fail 1 a standard mode 100h-107h or 110h-11Ah missing from the list
;   4F08        fail 1 claims an 8-bit DAC or reports other than 6 bits (the DAC is 6 bit)
;   4F04        fail 1 state buffer size call failed
;   4F0A        fail 1 no protected mode interface
;   4F01 guard  fail 1 4F01 writes past 256 bytes
vesa_global:
        ; 4F00 with VESA signature: must not write past 256 bytes
        mov di,vbeinfo
        mov cx,768
        mov al,0xCC
        rep stosb
        mov dword [vbeinfo],'VESA'
        mov ax,0x4F00
        mov di,vbeinfo
        int 0x10
        mov [tmpw],ax
        mov dword [vtag],'4F00'         ; /V: the info block
        mov si,vbeinfo
        mov cx,256
        call vblk
        TB '4F00 VESA sig: '
        mov ax,[vbeinfo+4]
        mov al,ah
        call phex2
        mov al,'.'
        call putc
        mov al,[vbeinfo+4]
        call phex2
        call sp1
        movzx eax,word [vbeinfo+0x12]
        shl eax,6
        call pdec
        PS 'KB'
        call tdots
        cmp word [tmpw],0x004F
        jne .f0
        cmp dword [vbeinfo],'VESA'
        jne .f0
        cmp word [vbeinfo+4],0x0102
        jb .f0
        jmp .g0
.f0:    FAILB 1
.g0:    mov si,vbeinfo+256
        mov cx,512
.gl:    cmp byte [si],0xCC
        jne .gw
        inc si
        loop .gl
        jmp .gm
.gw:    PS 'wrote past 256 bytes '
        WARNB 1
.gm:    ; mode list must not live inside the caller's buffer for VBE 1.x callers
        mov ax,[vbeinfo+0x10]
        mov bx,ds
        cmp ax,bx
        jne .gn
        PS 'mode list inside buffer '
        WARNB 2
.gn:    call tend
        push ds                         ; copy mode list
        lds si,[vbeinfo+0x0E]
        mov di,mlist
        mov cx,127
.cp:    lodsw
        stosw
        cmp ax,0xFFFF
        je .cd
        loop .cp
        mov ax,0xFFFF
        stosw
.cd:    pop ds
        mov ax,[vbeinfo+0x12]
        mov [banks],ax
        ; OEM string
        TB 'OEM string: '
        push ds
        lds si,[vbeinfo+6]
        mov cx,48
.os:    lodsb
        or al,al
        jz .oe
        call putc
        loop .os
.oe:    pop ds
        mov byte [infoflag],1
        call tend
        ; 4F00 with VBE2 signature
        mov di,vbe2buf
        mov cx,768
        mov al,0xCC
        rep stosb
        mov dword [vbe2buf],'VBE2'
        mov ax,0x4F00
        mov di,vbe2buf
        int 0x10
        mov [tmpw],ax
        mov dword [vtag],'VBE2'         ; /V: the 512-byte info block
        mov si,vbe2buf
        mov cx,512
        call vblk
        TB '4F00 VBE2 sig, 512 byte block'
        call tdots
        cmp word [tmpw],0x004F
        jne .v1
        cmp dword [vbe2buf],'VESA'
        jne .v1
        mov si,vbe2buf+512
        mov cx,256
.vl:    cmp byte [si],0xCC
        jne .v1
        inc si
        loop .vl
        jmp .v2
.v1:    FAILB 1
.v2:    cmp word [vbe2buf+4],0x0200
        jb .v4
        mov si,0x16                     ; vendor, product, revision strings
.v3:    push si
        call sp1
        mov al,'"'
        call putc
        push ds
        lds si,[vbe2buf+si]
        mov ax,ds
        or ax,si
        jz .vz
        mov cx,32
.vs:    lodsb
        or al,al
        jz .vz
        call putc
        loop .vs
.vz:    pop ds
        mov al,'"'
        call putc
        pop si
        add si,4
        cmp si,0x22
        jb .v3
.v4:    call tend
        ; required standard modes present
        TB 'Standard modes 100-107,110-11A listed'
        call tdots
        mov si,reqmodes
.rq:    lodsw
        cmp ax,0xFFFF
        je .rqd
        mov bx,ax
        push si
        mov si,mlist
.sr:    lodsw
        cmp ax,0xFFFF
        je .miss
        cmp ax,bx
        je .fnd
        jmp .sr
.miss:  mov ax,bx
        call phex4
        call sp1
        FAILB 1
.fnd:   pop si
        jmp .rq
.rqd:   call tend
        ; 4F08: DAC is 6 bit only
        TB '4F08 DAC width (6 bit hardware)'
        call tdots
        mov ax,0x4F08
        mov bx,0x0800
        int 0x10
        mov [tmpw],ax
        mov [tmpw2],bx
        mov ax,0x4F08
        mov bx,0x0001
        int 0x10
        mov [tmpw3],bx
        mov ax,[tmpw]
        call phex4
        call sp1
        mov al,[tmpw3+1]
        call phex2
        cmp byte [tmpw3+1],6
        jne .f8
        cmp word [tmpw],0x004F
        jne .o8
        cmp byte [tmpw2+1],8
        je .f8
.o8:    jmp .r8
.f8:    FAILB 1
.r8:    call tend
        ; 4F04 size
        TB '4F04 state buffer size'
        call tdots
        mov ax,0x4F04
        xor dl,dl
        mov cx,0x000F
        int 0x10
        mov [tmpw],ax
        mov [sbsize],bx
        movzx eax,word [sbsize]
        shl eax,6
        call pdec
        PS ' bytes'
        cmp word [tmpw],0x004F
        je .s4
        FAILB 1
.s4:    call tend
        ; 4F0A
        TB '4F0A protected mode interface'
        call tdots
        push es
        mov ax,0x4F0A
        xor bl,bl
        int 0x10
        mov [tmpw],ax
        mov [tmpw2],cx
        pop es
        mov ax,[tmpw]
        call phex4
        call sp1
        mov ax,[tmpw2]
        call phex4
        cmp word [tmpw],0x004F
        jne .fa
        cmp word [tmpw2],0
        jne .ra
.fa:    FAILB 1
.ra:    call tend
        ; 4F01 guard
        TB '4F01 writes 256 bytes only'
        call tdots
        mov di,mibuf
        mov cx,512
        mov al,0xCC
        rep stosb
        mov ax,0x4F01
        mov cx,0x101
        mov di,mibuf
        int 0x10
        mov si,mibuf+256
        mov cx,256
.mg:    cmp byte [si],0xCC
        jne .mgf
        inc si
        loop .mg
        jmp .mgo
.mgf:   FAILB 1
.mgo:   call tend
        ret
reqmodes dw 0x100,0x101,0x102,0x103,0x104,0x105,0x106,0x107
        dw 0x110,0x111,0x112,0x113,0x114,0x115,0x116,0x117,0x118,0x119,0x11A,0xFFFF

; ======================================================================
; known refresh rates (Hz*10) from the p7 tables
knownhz dw 0x12E,700,0x131,597,0x133,597,0x101,597,0x111,597,0x141,722
        dw 0x103,603,0x105,601,0x107,600,0x120,600,0

; Every mode in the 4F00 list: vesa_one (banked), then vesa_lfb when 4F01 offers a linear buffer.
vesa_modes:
        mov word [mi],0
.l:     mov si,[mi]
        shl si,1
        mov ax,[mlist+si]
        cmp ax,0xFFFF
        je .d
        mov [vm],ax
        mov byte [lfbmode],0
        call vesa_one
        cmp byte [lfbav],0
        je .n
        mov byte [lfbmode],1
        call vesa_lfb
.n:     inc word [mi]
        jmp .l
.d:     ret

getinfo:                                ; [vm] -> mibuf, CF on error
        mov di,mibuf
        mov cx,128
        xor ax,ax
        rep stosw
        mov ax,0x4F01
        mov cx,[vm]
        and cx,0x3FFF
        mov di,mibuf
        int 0x10
        cmp ax,0x004F
        je .o
        stc
        ret
.o:     mov dword [vtag],'4F01'         ; /V: the mode info block
        mov si,mibuf
        mov cx,256
        call vblk
        clc
        ret

presmode:                               ; print WxHxBPP
        call sp1
        movzx eax,word [mibuf+0x12]
        call pdec
        mov al,'x'
        call putc
        movzx eax,word [mibuf+0x14]
        call pdec
        mov al,'x'
        call putc
        movzx eax,byte [mibuf+0x19]
        call pdec
        ret

; One VESA mode, banked. Fail bits:
;   1  4F01 failed            2  window A not 64 KB granularity/size at A000h, readable+writable
;   4  4F01 layout implausible (pitch < width, size > memory, colour masks not 5:5:5, 5:6:5 or 8:8:8)
;   8  4F02 failed or 4F03 reports another mode     10 refresh outside 56-90 Hz or off the known rate
;   20 first/last byte through the window wrong (planar: per plane at every bank, see planchk)
;   40 4F06 BL=1 pitch differs from 4F01            80 4F07 start get/set or 4F09 8-bit palette wrong
;   100 CRTC geometry (pitch, YRes, XRes) vs 4F01   200 datasheet colour mode / clock rules (dschk)
;   400 refresh vs CRTC/PLL prediction              800 memory mapping rules (mapchk)
; Warn bits: 1 refresh prediction off by a factor 2, 2 DCLK above datasheet maximum, 4 CR50 pixel
; length, 10 interlace on, 20 LFB on a planar mode. INFO for modes the BIOS marks unsupported.
; Expect PASS (106h WARN 02).
vesa_one:
        mov byte [lfbav],0
        TB 'VESA '
        mov ax,[vm]
        call phex4
        call getinfo
        jnc .i1
        call tdots
        FAILB 1
        jmp .end
.i1:    call presmode
        call flush
        call tdots
        test byte [mibuf],1
        jnz .sup
        PS 'not supported in 2 MB'
        mov byte [infoflag],1
        jmp .end
.sup:   test byte [mibuf],0x80
        jz .nl
        cmp dword [mibuf+0x28],0
        je .nl
        mov byte [lfbav],1
.nl:    mov byte [istext],0
        test byte [mibuf],0x10
        jnz .gfx
        mov byte [istext],1
        jmp .set
.gfx:   mov al,[mibuf+2]                ; window A
        and al,7
        cmp al,7
        jne .wf
        cmp word [mibuf+4],64
        jne .wf
        cmp word [mibuf+6],64
        jne .wf
        cmp word [mibuf+8],0xA000
        je .lay
.wf:    FAILB 2
.lay:   call layout
.set:   mov ax,0x4F02
        mov bx,[vm]
        int 0x10
        cmp ax,0x004F
        jne .sf
        mov ax,0x4F03
        int 0x10
        and bx,0x3FFF
        cmp bx,[vm]
        je .s2
.sf:    FAILB 8
        jmp .end
.s2:    call unlock
        call measure
        mov [hz],ax
        cmp ax,560
        jb .hf
        cmp ax,900
        jbe .h2
.hf:    FAILB 0x10
.h2:    mov si,knownhz
.kl:    lodsw
        or ax,ax
        jz .k3
        mov bx,ax
        lodsw
        cmp bx,[vm]
        jne .kl
        sub ax,[hz]
        jns .k2
        neg ax
.k2:    cmp ax,15
        jbe .k3
        FAILB 0x10
.k3:    call predict
        mov [phz],ax
        call cmphz
        jnc .k4
        FAILB 0x400
.k4:    cmp byte [istext],1
        je .rep
        cmp byte [mibuf+0x1B],3
        jne .pk
        call planchk                    ; 16-colour modes: every plane, every bank
        jc .mf
        jmp .g6
.pk:    xor ebx,ebx                     ; first and last visible bytes via window A
        call bankrw
        jc .mf
        call lastoff
        call bankrw
        jnc .g6
.mf:    FAILB 0x20
.g6:    mov ax,0x4F06
        mov bl,1
        int 0x10
        cmp ax,0x004F
        jne .f6
        cmp bx,[mibuf+0x10]
        je .g7
.f6:    FAILB 0x40
.g7:    mov ax,0x4F07
        xor bx,bx
        xor cx,cx
        mov dx,1
        int 0x10
        mov [tmpw],ax
        mov ax,0x4F07
        mov bx,1
        int 0x10
        mov [tmpw2],dx
        mov [tmpw3],cx
        mov ax,0x4F07
        xor bx,bx
        xor cx,cx
        xor dx,dx
        int 0x10
        cmp word [tmpw],0x004F
        jne .f7
        cmp word [tmpw2],1
        jne .f7
        cmp word [tmpw3],0
        jne .f7
        cmp byte [mibuf+0x19],8
        jne .ds
        cmp byte [mibuf+0x1B],4
        jne .ds
        mov dword [pal],0x00030201
        mov ax,0x4F09
        xor bl,bl
        mov cx,1
        mov dx,7
        mov di,pal
        int 0x10
        mov [tmpw],ax
        mov dword [pal2],0
        mov ax,0x4F09
        mov bl,1
        mov cx,1
        mov dx,7
        mov di,pal2
        int 0x10
        cmp word [tmpw],0x004F
        jne .f7
        mov eax,[pal2]
        and eax,0x00FFFFFF
        cmp eax,0x00030201
        je .ds
.f7:    FAILB 0x80
.ds:    call dschk
.rep:   PS ' Hz '
        movzx eax,word [hz]
        call pdec10
        mov al,'/'
        call putc
        movzx eax,word [phz]
        call pdec10
        cmp byte [csel],3
        jne .rp
        PS ' DCLK '
        mov eax,[dclk]
        call pkhz
.rp:    mov ax,[mibuf+0x12]
        cmp byte [istext],1
        jne .rq
        xor ax,ax
.rq:    call lineinfo
        call pause
.end:   call tend
        ret

; 16-colour modes: a different byte per plane at the start and end of every 64 KB bank, read back
; with read map select. Catches bank or plane mixups. Fail bit 20 of vesa_one.
planchk:                                ; CF on error
        movzx eax,word [mibuf+0x10]
        movzx edx,word [mibuf+0x14]
        imul eax,edx
        mov [psize],eax
        mov di,offl
        xor ecx,ecx
.b:     cmp ecx,[psize]
        jae .e
        mov [di],ecx
        add di,4
        mov eax,ecx
        add eax,0xFFFF
        cmp eax,[psize]
        jae .n
        mov [di],eax
        add di,4
.n:     add ecx,0x10000
        jmp .b
.e:     mov eax,[psize]
        dec eax
        mov [di],eax
        add di,4
        mov [offend],di
        mov dx,0x3CE                    ; write mode 0, no set/reset, no rotate, all bits
        mov ax,0x0005
        out dx,ax
        mov ax,0x0001
        out dx,ax
        mov ax,0x0003
        out dx,ax
        mov ax,0xFF08
        out dx,ax
        mov word [cur],offl
.w:     mov si,[cur]
        cmp si,[offend]
        jae .r0
        call pbank                      ; -> DI offset in window, BL base value
        xor cx,cx
.wp:    mov dx,0x3C4
        mov ah,1
        shl ah,cl
        mov al,2
        out dx,ax
        call pval                       ; AL = value for plane CL
        push es
        push word 0xA000
        pop es
        mov [es:di],al
        pop es
        inc cx
        cmp cx,4
        jb .wp
        add word [cur],4
        jmp .w
.r0:    mov dx,0x3C4
        mov ax,0x0F02
        out dx,ax
        mov word [cur],offl
.r:     mov si,[cur]
        cmp si,[offend]
        jae .ok
        call pbank
        xor cx,cx
.rp:    mov dx,0x3CE
        mov al,4
        mov ah,cl
        out dx,ax
        call pval
        mov ah,al
        push es
        push word 0xA000
        pop es
        mov al,[es:di]
        pop es
        cmp al,ah
        jne .bad
        inc cx
        cmp cx,4
        jb .rp
        add word [cur],4
        jmp .r
.ok:    mov dx,0x3CE
        mov ax,0x0004
        out dx,ax
        clc
        ret
.bad:   mov dx,0x3CE
        mov ax,0x0004
        out dx,ax
        PS 'plane '
        mov al,cl
        call phex2
        PS ' @'
        mov si,[cur]
        mov ax,[si+2]
        call phex4
        mov si,[cur]
        mov ax,[si]
        call phex4
        call sp1
        stc
        ret
pval:   ; BL base, CL plane -> AL = BL + CL*47h
        mov al,0x47
        mul cl
        add al,bl
        ret
pbank:  ; SI -> offset entry: set bank, DI = offset in window, BL = pattern base for this entry
        mov ebx,[si]
        mov di,bx
        push si
        mov esi,ebx
        shr esi,16
        call setbank
        pop si
        mov ax,si
        sub ax,offl
        shr ax,2
        mov bl,0x1D
        mul bl
        add al,0x5A
        mov bl,al
        ret

; Printed after the refresh: line frequency in kHz, H = total pixels per line (the 'clock' value an
; LCD's manual adjustment wants) and V = total lines, from CR00/CR01/CR06/CR07/CR5D/CR5E.
lineinfo:                               ; AX = XRes for VESA graphics modes, 0 = VGA dot method
        mov [li_x],ax
        RC 0x5D
        mov [li_5d],al
        RC 0
        movzx ecx,al
        test byte [li_5d],1
        jz .h1
        add ecx,256
.h1:    add ecx,5                       ; character clocks per line
        cmp word [li_x],0
        je .vga
        RC 1
        movzx ebx,al
        test byte [li_5d],2
        jz .h2
        add ebx,256
.h2:    inc ebx                         ; displayed character clocks
        movzx eax,word [li_x]
        imul eax,ecx
        xor edx,edx
        div ebx                         ; total pixels = XRes * total / displayed
        jmp .h
.vga:   RS 1
        mov bl,9
        test al,1
        jz .c9
        mov bl,8
.c9:    movzx ebx,bl
        imul ecx,ebx
        test al,8
        jz .c1
        shl ecx,1
.c1:    mov eax,ecx
.h:     mov [li_h],ax
        RC 6
        movzx ebx,al
        RC 7
        test al,1
        jz .v1
        add bx,0x100
.v1:    test al,0x20
        jz .v2
        add bx,0x200
.v2:    RC 0x5E
        test al,1
        jz .v3
        add bx,0x400
.v3:    add bx,2
        mov [li_v],bx
        movzx eax,word [hz]             ; kHz*10 = Hz*10 * lines / 1000
        movzx ebx,bx
        imul eax,ebx
        xor edx,edx
        mov ebx,1000
        div ebx
        call sp1
        call pdec10
        PS 'kHz H'
        movzx eax,word [li_h]
        call pdec
        PS ' V'
        movzx eax,word [li_v]
        call pdec
        ret

lastoff:                                ; EBX = offset of last dword of visible area
        movzx eax,word [mibuf+0x10]
        movzx edx,word [mibuf+0x14]
        imul eax,edx
        sub eax,4
        mov ebx,eax
        ret

; One VESA mode with the linear frame buffer (mode | 4000h). Fail bits: 8 set failed or 4F03 has no
; linear bit, 20 first/last dword through the LFB (INT 15h AH=87h copies) wrong, 800 mapping rules.
; Warn 20: INT 15h AH=87h not available (LFB not testable).
vesa_lfb:
        TB 'VESA '
        mov ax,[vm]
        or ax,0x4000
        call phex4
        PS ' linear'
        call flush
        call tdots
        mov ax,0x4F02
        mov bx,[vm]
        or bx,0x4000
        int 0x10
        cmp ax,0x004F
        jne .f
        mov ax,0x4F03
        int 0x10
        mov ax,bx
        and ax,0x3FFF
        cmp ax,[vm]
        jne .f
        test bx,0x4000
        jnz .ok
.f:     FAILB 8
        jmp .end
.ok:    call unlock
        call mapchk
        xor ebx,ebx
        call lfbrw
        jc .w
        jnz .mf
        call lastoff
        call lfbrw
        jc .w
        jz .end
.mf:    FAILB 0x20
        jmp .end
.w:     PS 'INT 15h AH=87 failed (no LFB access) '
        WARNB 0x20
.end:   call tend
        ret

; 4F01 layout plausibility

; 4F01 plausibility: bytes per line >= XRes * bpp, the page fits in memory, direct colour masks.
layout: movzx eax,word [mibuf+0x12]
        movzx ebx,byte [mibuf+0x19]
        imul eax,ebx
        add eax,7
        shr eax,3
        mov bl,[mibuf+0x1B]
        cmp bl,3
        jne .np
        movzx eax,word [mibuf+0x12]
        shr eax,3
.np:    movzx ecx,word [mibuf+0x10]
        cmp ecx,eax
        jb .lf
        movzx eax,word [mibuf+0x10]
        movzx edx,word [mibuf+0x14]
        imul eax,edx
        cmp bl,3
        jne .np2
        shl eax,2
.np2:   movzx edx,byte [mibuf+0x1D]
        inc edx
        imul eax,edx
        movzx edx,word [banks]
        shl edx,16
        cmp eax,edx
        ja .lf
        cmp bl,6
        jne .ok
        movzx eax,byte [mibuf+0x1F]
        movzx edx,byte [mibuf+0x21]
        add eax,edx
        mov dl,[mibuf+0x23]
        add eax,edx
        movzx edx,byte [mibuf+0x19]
        cmp dl,24
        jbe .mk
        mov dl,24
.mk:    cmp eax,edx
        jne .lf
        mov si,pos24                    ; field sizes/positions: R, G, B
        cmp byte [mibuf+0x19],24
        jae .fp
        mov si,pos16
        cmp byte [mibuf+0x21],6
        je .fp
        mov si,pos15
.fp:    mov di,mibuf+0x1F
        mov cx,6
        repe cmpsb
        je .ok
        PS 'masks '
.lf:    FAILB 4
.ok:    ret
pos15   db 5,10,5,5,5,0
pos16   db 5,11,6,5,5,0
pos24   db 8,16,8,8,8,0

; Datasheet checks of the registers the BIOS programmed for the current VESA mode:
; pitch (CR13 + CR51 bits 5-4 / CR43 bit 2, unit from CR31/CR14/CR17) = 4F01 BytesPerScanLine,
; vertical display end = YRes * character height, horizontal display end a multiple of XRes (fail 100);
; CR67 colour mode fits the bpp, packed 24 bpp needs SR0B 7xh, clock doubling (CR67 mode 1) needs
; SR18 bit 7 and SR15 bit 4 or 6 and nothing else may use SR18 bit 7, DCLK VCO 135-340 MHz (fail 200);
; DCLK above 95 MHz (170 doubled, 75 packed 24, 50 at 32 bpp) is WARN 02; CR50 pixel length
; WARN 04; interlace WARN 10.
dschk:  call rdall
        ; CRTC pitch (CR13 + CR51 5-4, or CR43 bit 2) in the addressing unit (CR31.3 -> dwords)
        movzx ax,byte [q_r13]
        mov bl,[q_r51]
        shr bl,4
        and bl,3
        jz .p1
        mov ah,bl
        jmp .p2
.p1:    test byte [q_r43],4
        jz .p2
        mov ah,1
.p2:    mov cx,8
        test byte [q_r31],8
        jnz .p3
        test byte [q_r14],0x40
        jnz .p3
        mov cx,4
        test byte [q_r17],0x40
        jz .p3
        mov cx,2
.p3:    mul cx
        cmp ax,[mibuf+0x10]
        je .v
        FAILB 0x100
        mov [tmpw],ax
        PS 'pitch='
        movzx eax,word [tmpw]
        call pdec
        call sp1
.v:     ; vertical display end vs YRes
        call getvde
        mov [tmpw],ax
        mov al,[q_r09]
        and ax,0x1F
        inc ax
        test byte [q_r09],0x80
        jz .v1
        shl ax,1
.v1:    mul word [mibuf+0x14]
        cmp ax,[tmpw]
        je .h
        FAILB 0x100
        PS 'vde='
        movzx eax,word [tmpw]
        call pdec
        call sp1
.h:     ; horizontal display end must be a clean multiple of XRes
        movzx ax,byte [q_r01]
        test byte [q_r5d],2
        jz .h1
        inc ah
.h1:    inc ax
        shl ax,4                        ; *8 *2
        xor dx,dx
        div word [mibuf+0x12]
        or dx,dx
        jz .cm
        FAILB 0x100
        PS 'hde '
.cm:    ; CR67 colour mode vs BPP (datasheet table 8-1 / CR67 definition)
        mov al,[q_r67]
        shr al,4
        mov [cmode],al
        mov bl,[mibuf+0x19]
        mov bh,[mibuf+0x1B]
        cmp bh,3
        jne .c1
        mov si,cm_pl
        jmp .c9
.c1:    cmp bl,8
        jne .c2
        mov si,cm_8
        jmp .c9
.c2:    cmp bl,15
        je .c15
        cmp bl,16
        jne .c3
        cmp byte [mibuf+0x21],5
        je .c15
        mov si,cm_16
        jmp .c9
.c15:   mov si,cm_15
        jmp .c9
.c3:    mov si,cm_24
.c9:    lodsb
        cmp al,0xFF
        je .cbad
        cmp al,[cmode]
        je .cok
        jmp .c9
.cbad:  FAILB 0x200
        mov ax,0x6703
        mov bl,[q_r67]
        and bl,0xF0
        mov bh,0
        call mm_add
.cok:   cmp byte [mibuf+0x19],24
        jne .cok2
        cmp byte [cmode],0
        jne .cok2
        RS 0x0B
        and al,0xF0
        cmp al,0x70
        je .cok2
        FAILB 0x200
        mov bl,al
        mov bh,0x70
        mov ax,0x0B02
        call mm_add
.cok2:  ; clock doubling pairing (SR18_7, SR15 bit 4 or 6)
        mov al,[q_rs18]
        and al,0x80
        cmp byte [cmode],1
        jne .d1
        or al,al
        jz .dbad
        test byte [q_rs15],0x50
        jnz .d2
.dbad:  FAILB 0x200
        mov ax,0x1802
        mov bl,[q_rs18]
        mov bh,0x80
        call mm_add
        jmp .d2
.d1:    or al,al
        jnz .dbad
.d2:    ; PLL limits
        cmp byte [csel],3
        jne .mm
        cmp dword [vco],135000
        jb .vb
        cmp dword [vco],340000
        ja .vb
        test byte [q_rs12],0x1F
        jnz .lim
.vb:    FAILB 0x200
        PS 'VCO '
        mov eax,[vco]
        call pkhz
        call sp1
.lim:   mov eax,95000
        cmp byte [cmode],1
        jne .l1
        mov eax,170000
.l1:    cmp byte [cmode],7
        jne .l2
        mov eax,75000
.l2:    cmp byte [cmode],13
        jne .l3
        mov eax,50000
.l3:    cmp [dclk],eax
        jbe .mm
        WARNB 2
.mm:    call mapchk
        ; CR50 GE pixel length and width (warn only)
        mov al,[q_r50]
        shr al,4
        and al,3
        mov bl,[mibuf+0x19]
        mov ah,0
        cmp bl,8
        jbe .g1
        mov ah,1
        cmp bl,16
        jbe .g1
        mov ah,3
        cmp bl,32
        je .g1
        jmp .g2
.g1:    cmp byte [mibuf+0x1B],3
        je .g2
        cmp al,ah
        je .g2
        WARNB 4
.g2:
.g3:    test byte [q_r42],0x20
        jz .g6
        WARNB 0x10
.g6:    ret
cm_pl   db 0,0xFF
cm_8    db 0,1,0xFF
cm_15   db 3,0xFF
cm_16   db 5,0xFF
cm_24   db 13,7,0,0xFF

; CR31 / CR58 / CR59-5A against the datasheet rules for the mode in use

; Memory mapping rules: linear addressing (CR58 bit 4) needs enhanced mapping (CR31 bit 3); in a
; banked mode LA on is only allowed as the booster's 64 KB window at A0000h (CR59/5A = 000Ah) with
; CR31 bit 0; in an LFB mode the window is 2 MB or more and CR59/5A equals PhysBasePtr; plain banking
; above 64 KB needs CR31 bit 0. Fail bit 800; LFB offered on a planar mode is WARN 20.
mapchk: call rdall
        test byte [q_r58],0x10          ; linear addressing needs enhanced mapping first
        jz .a
        mov bl,[q_r31]
        test bl,8
        jnz .a
        cmp byte [mibuf+0x1B],3
        jne .f31
        WARNB 0x20                      ; BIOS offers LFB on a planar mode
        PS 'LFB on planar mode '
        jmp .a
.f31:   FAILB 0x800
        mov ax,0x3103
        mov bh,8
        call mm_add
.a:     test byte [q_r58],0x10
        jz .nola
        cmp byte [lfbmode],1
        je .lfb
        ; LA on in a banked mode: datasheet 64K window at A0000 with CR31 bit 0
        mov al,[q_r58]
        and al,3
        jnz .bb
        cmp word [q_r59],0x0A00           ; q_r59=00, q_r5a=0A
        jne .bb
        test byte [q_r31],1
        jnz .ok
.bb:    FAILB 0x800
        mov ax,0x5803
        mov bl,[q_r58]
        mov bh,0x10
        call mm_add
        ret
.lfb:   mov al,[q_r58]
        and al,3
        cmp al,2                        ; window >= 2 MB
        jb .lb
        movzx eax,byte [q_r59]
        shl eax,8
        mov al,[q_r5a]
        shl eax,16
        cmp eax,[mibuf+0x28]
        je .ok
.lb:    FAILB 0x800
        mov ax,0x5803
        mov bl,[q_r58]
        mov bh,0x12
        call mm_add
        ret
.nola:  cmp byte [lfbmode],1
        je .lb
        ; plain banking: more than 64K of window space needs CR31 bit 0
        movzx eax,word [mibuf+0x10]
        movzx edx,word [mibuf+0x14]
        imul eax,edx
        cmp eax,0x10000
        jbe .ok
        test byte [q_r31],1
        jnz .ok
        FAILB 0x800
.ok:    ret

rdall:  mov si,rdlist
.l:     lodsb
        cmp al,0xFF
        je .d
        mov ah,[si]
        inc si
        push ax
        call readreg
        pop bx
        mov di,[si]
        add si,2
        mov [di],al
        jmp .l
.d:     ret
rdlist: db 3,0x00
        dw q_r00
        db 3,0x01
        dw q_r01
        db 3,0x09
        dw q_r09
        db 3,0x13
        dw q_r13
        db 3,0x14
        dw q_r14
        db 3,0x17
        dw q_r17
        db 3,0x31
        dw q_r31
        db 3,0x34
        dw q_r34
        db 3,0x3B
        dw q_r3b
        db 3,0x42
        dw q_r42
        db 3,0x43
        dw q_r43
        db 3,0x50
        dw q_r50
        db 3,0x51
        dw q_r51
        db 3,0x58
        dw q_r58
        db 3,0x59
        dw q_r59
        db 3,0x5A
        dw q_r5a
        db 3,0x5D
        dw q_r5d
        db 3,0x67
        dw q_r67
        db 2,0x12
        dw q_rs12
        db 2,0x15
        dw q_rs15
        db 2,0x18
        dw q_rs18
        db 0xFF

; Refresh predicted from the registers: clock (25.175 / 28.322 MHz or the DCLK PLL), SR01 dot clock
; divide and 8/9 dots, SR15 bit 4, horizontal and vertical totals incl. the S3 overflow bits, and the
; clocks per pixel of the colour mode (CR67, SR0B).
predict:                                ; -> AX = Hz*10 (0 = unknown), [csel], [dclk]
        mov ax,0x0000
        call readreg
        shr al,2
        and al,3
        mov [csel],al
        mov eax,25175
        cmp byte [csel],0
        je .c
        mov eax,28322
        cmp byte [csel],1
        je .c
        cmp byte [csel],3
        je .pll
        xor ax,ax
        ret
.pll:   RS 0x12
        mov [q_rs12],al
        mov bl,al
        RS 0x13
        mov ah,al
        mov al,bl
        call pllcalc
        mov eax,[fout]
.c:     mov [dclk],eax
        mov [tmpd],eax
        RS 1
        mov [tmpb],al
        test al,8
        jz .c1
        shr dword [tmpd],1
.c1:    cmp byte [csel],3
        jne .c2
        RS 0x15
        test al,0x10
        jz .c2
        shr dword [tmpd],1
.c2:    RC 0
        movzx ecx,al
        RC 0x5D
        test al,1
        jz .c3
        add ecx,256
.c3:    add ecx,5
        mov ebx,9
        test byte [tmpb],1
        jz .c4
        mov ebx,8
.c4:    imul ecx,ebx
        mov [tmpd2],ecx
        RC 6
        movzx ecx,al
        RC 7
        test al,1
        jz .v1
        add ecx,0x100
.v1:    test al,0x20
        jz .v2
        add ecx,0x200
.v2:    RC 0x5E
        test al,1
        jz .v3
        add ecx,0x400
.v3:    add ecx,2
        imul ecx,[tmpd2]
        mov eax,[tmpd]
        mov ebx,10000
        mul ebx
        div ecx
        cmp byte [csel],3
        jne .r
        push ax
        RC 0x67
        shr al,4
        mov bl,al
        RS 0x0B
        mov bh,al
        pop ax
        cmp bl,1
        je .x2
        cmp bl,3
        je .x2
        cmp bl,5
        je .x2
        or bl,bl
        jnz .r
        and bh,0xF0
        cmp bh,0x70
        jne .r
        shr ax,1
        ret
.x2:    shl ax,1
.r:     ret

; Measured vs predicted refresh within 2 % (at least 1 Hz). A factor 2 either way is WARN 01.
cmphz:  ; [hz] measured vs [phz] predicted: CF=1 fail, factor 2 -> warn
        movzx eax,word [phz]
        or eax,eax
        jz .ok
        movzx ebx,word [hz]
        call near_
        jnc .ok
        shl eax,1
        call near_
        jnc .w
        shr eax,2
        call near_
        jnc .w
        stc
        ret
.w:     WARNB 1
.ok:    clc
        ret
near_:  ; |ebx-eax| <= max(eax/50,10) -> CF=0
        push eax
        push ecx
        mov ecx,eax
        sub ecx,ebx
        jns .a
        neg ecx
.a:     push ecx
        xor edx,edx
        mov ecx,50
        div ecx
        pop ecx
        cmp eax,10
        jae .b
        mov eax,10
.b:     cmp ecx,eax
        pop ecx
        pop eax
        ja .f
        clc
        ret
.f:     stc
        ret

; ======================================================================
; S3 internal modes via AH=00 compared with the same mode set via 4F02

; S3 internal modes via INT 10h AH=00 (the BIOS's own numbers, used by S3 drivers in games) against
; the same mode set through 4F02. First the VESA list must match the ROM's VESA->S3 table (WARN 01).
svga_modes:
        mov si,mlist                    ; ROM table must match the BIOS mode list
        mov di,s3map
        mov cx,NMAP
.c:     lodsw
        cmp ax,[di]
        jne .bad
        add di,3
        loop .c
        mov word [mi],0
.l:     mov ax,[mi]
        cmp ax,NMAP
        jae .d
        imul si,ax,3
        add si,s3map
        mov ax,[si]
        mov [vm],ax
        mov al,[si+2]
        mov [im],al
        call svga_one
        inc word [mi]
        jmp .l
.d:     ret
.bad:   TB 'VESA list differs from ROM table, skipped'
        WARNB 1
        call tend
        ret

; Fail bits: 1 AH=0Fh or 40:49 mode number wrong, 2 registers (extlist) differ from the 4F02 set,
; 4 first/last byte through the window wrong. INFO when 4F01 marks the mode unsupported.
svga_one:
        TB 'AH=00 '
        mov al,[im]
        call phex2
        PS 'h = VESA '
        mov ax,[vm]
        call phex4
        call flush
        call getinfo
        jc .na
        test byte [mibuf],1
        jnz .ok
.na:    call tdots
        PS 'not supported in 2 MB'
        mov byte [infoflag],1
        jmp .end
.ok:    call presmode
        call flush
        call tdots
        movzx ax,byte [im]
        int 0x10
        call unlock
        mov ah,0x0F
        int 0x10
        and al,0x7F
        cmp al,[im]
        je .a
        FAILB 1
        mov bl,al
        mov bh,[im]
        mov ax,0x0007
        call mm_add
.a:     push es
        xor ax,ax
        mov es,ax
        mov al,[es:0x449]
        pop es
        and al,0x7F
        cmp al,[im]
        je .b
        FAILB 1
.b:     mov si,extlist
        mov cx,EXTN
        mov di,snapA
        call snap
        test byte [mibuf],0x10
        jz .s
        xor ebx,ebx
        call bankrw
        jc .mf
        call lastoff
        call bankrw
        jnc .s
.mf:    FAILB 4
.s:     mov ax,0x4F02
        mov bx,[vm]
        int 0x10
        call unlock
        mov si,extlist
        mov cx,EXTN
        mov di,snapB
        call snap
        mov si,extlist
        mov cx,EXTN
        mov bx,snapA
        mov di,snapB
        mov dx,2
        call cmpsnap
.end:   call tend
        ret

; ======================================================================
; VESA functions (mostly in 640x480x8, mode 101h)
setm:   mov ax,0x4F02
        int 0x10
        push ax
        call unlock
        pop ax
        ret

; VBE functions in 640x480x8 (101h). Fail bits per test:
;   invalid mode 17Fh   1 4F01 accepted, 2 4F02 accepted, 4 current mode changed
;   clear / D15         1 memory cleared despite D15, 2 not cleared without it
;   4F05 + WinFuncPtr   1 get bank, 2 no WinFuncPtr, 4 far call does not switch, 8 get after far call
;   4F06                1 set 1024 pixels (or CR13/CR51 pitch), 2 set 2048 bytes,
;                       4 BL=3 maximum not min(8184, memory / 480) rounded down to 8 (p8 fix)
;   4F07                1 start address (CR0C/CR0D/CR69 bits 3-0) or read back, 4 wait-for-retrace set
;   4F09                1 set, 2 get differs, 4 DAC hardware differs, 8 set during retrace
;   4F04 round trip     1 save/restore failed, 2 registers differ, 4 DAC entry, 8 mode not 101h
; Then the 2 MB VRAM test (unless /Q) and the banked/LFB cross check.
vesa_func:
        mov word [vm],0x101
        call getinfo
        ; invalid mode
        TB '4F01/4F02 reject invalid mode 17Fh'
        call tdots
        mov bx,0x101
        call setm
        mov ax,0x4F01
        mov cx,0x17F
        mov di,dsbuf
        int 0x10
        cmp ax,0x004F
        jne .a
        FAILB 1
.a:     mov ax,0x4F02
        mov bx,0x17F
        int 0x10
        cmp ax,0x004F
        jne .b
        FAILB 2
.b:     mov ax,0x4F03
        int 0x10
        and bx,0x3FFF
        cmp bx,0x101
        je .c
        FAILB 4
.c:     call tend
        ; clear / don't clear
        TB '4F02 clear / D15 keep memory'
        call tdots
        mov bx,0x101
        call setm
        call marks
        mov bx,0x8101
        call setm
        mov ax,0x4F03
        int 0x10
        mov [tmpw],bx
        PS '4F03='
        mov ax,[tmpw]
        call phex4
        call sp1
        call markchk
        cmp eax,0x55AA33CC
        jne .d1
        cmp edx,0x0FF0C33C
        je .d2
.d1:    FAILB 1
.d2:    mov bx,0x101
        call setm
        call markchk
        or eax,edx
        jz .d3
        FAILB 2
.d3:    call tend
        ; banking
        TB '4F05 bank set/get + WinFuncPtr'
        call tdots
        mov bx,0x101
        call setm
        mov ax,0x4F05
        xor bx,bx
        mov dx,7
        int 0x10
        mov ax,0x4F05
        mov bx,0x0100
        int 0x10
        cmp dx,7
        je .e
        FAILB 1
.e:     mov eax,[mibuf+0x0C]
        or eax,eax
        jnz .e1
        FAILB 2
        jmp .e3
.e1:    mov [winfn],eax
        xor bx,bx
        mov dx,9
        call far [winfn]
        push es
        mov ax,0xA000
        mov es,ax
        mov dword [es:0x10],0x13579BDF
        pop es
        mov si,8
        call setbank
        push es
        mov ax,0xA000
        mov es,ax
        mov dword [es:0x10],0x2468ACE0
        pop es
        xor bx,bx
        mov dx,9
        call far [winfn]
        push es
        mov ax,0xA000
        mov es,ax
        mov eax,[es:0x10]
        pop es
        cmp eax,0x13579BDF
        je .e2
        FAILB 4
.e2:    mov ax,0x4F05
        mov bx,0x0100
        int 0x10
        cmp dx,9
        je .e3
        FAILB 8
.e3:    call tend
        ; logical scan line
        TB '4F06 logical width 1024/2048/max'
        call tdots
        mov bx,0x101
        call setm
        mov ax,0x4F06
        xor bl,bl
        mov cx,1024
        int 0x10
        cmp ax,0x004F
        jne .f1
        cmp bx,1024
        jne .f1
        cmp cx,1024
        jne .f1
        cmp dx,480
        jb .f1
        mov [tmpw],dx
        PS 'lines '
        movzx eax,word [tmpw]
        call pdec
        call sp1
        mov word [mibuf+0x10],1024      ; datasheet pitch from CR13/CR51
        call rdall
        call pitchreg
        cmp ax,1024
        je .f2
.f1:    FAILB 1
.f2:    mov ax,0x4F06
        mov bl,2
        mov cx,2048
        int 0x10
        cmp ax,0x004F
        jne .f3
        cmp bx,2048
        jne .f3
        cmp cx,2048
        je .f4
.f3:    FAILB 2
.f4:    mov ax,0x4F06
        mov bl,3
        int 0x10
        mov [tmpw],bx
        mov [tmpw2],cx
        cmp ax,0x004F
        jne .f5
        PS 'max '
        movzx eax,word [tmpw]
        call pdec
        mov al,'/'
        call putc
        movzx eax,word [tmpw2]
        call pdec
        movzx eax,word [banks]          ; expected: min(8184, memory / 480 lines) rounded to 8, pixels = bytes at 8 bpp
        shl eax,16
        xor edx,edx
        mov ecx,480
        div ecx
        cmp eax,8184
        jbe .f4a
        mov eax,8184
.f4a:   and al,0xF8
        cmp ax,[tmpw]
        jne .f5
        cmp ax,[tmpw2]
        je .f6
.f5:    FAILB 4                         ; VBE 2.0 'get maximum scan line length' wrong
.f6:    mov ax,0x4F06
        xor bl,bl
        mov cx,640
        int 0x10
        mov word [mibuf+0x10],640
        call tend
        ; display start
        TB '4F07 start incl. CR69 above 256K'
        call tdots
        mov bx,0x101
        call setm
        mov cx,8
        mov dx,100
        call startchk
        xor cx,cx
        mov dx,3000
        call startchk
        mov ax,0x4F07
        mov bx,0x0080
        xor cx,cx
        xor dx,dx
        int 0x10
        cmp ax,0x004F
        je .g1
        FAILB 4
.g1:    call tend
        ; palette
        TB '4F09 256 entries, DAC readback'
        call tdots
        mov bx,0x101
        call setm
        mov di,palbuf
        xor cx,cx
.p:     mov al,cl
        and al,0x3F
        stosb
        mov al,cl
        shr al,2
        stosb
        mov al,cl
        xor al,0x2A
        and al,0x3F
        stosb
        xor al,al
        stosb
        inc cx
        cmp cx,256
        jb .p
        mov ax,0x4F09
        xor bl,bl
        mov cx,256
        xor dx,dx
        mov di,palbuf
        int 0x10
        cmp ax,0x004F
        je .p1
        FAILB 1
.p1:    mov di,palbuf2
        mov cx,512
        xor ax,ax
        rep stosw
        mov ax,0x4F09
        mov bl,1
        mov cx,256
        xor dx,dx
        mov di,palbuf2
        int 0x10
        mov si,palbuf
        mov di,palbuf2
        mov cx,256
.p2:    mov eax,[si]
        xor eax,[di]
        and eax,0x00FFFFFF
        jz .p3
        FAILB 2
.p3:    add si,4
        add di,4
        loop .p2
        mov di,dacbuf                   ; hardware: R,G,B order
        xor al,al
        mov cx,256
        call dacread
        mov si,palbuf
        mov di,dacbuf
        mov cx,256
.p4:    mov al,[si+2]
        cmp al,[di]
        jne .p5
        mov al,[si+1]
        cmp al,[di+1]
        jne .p5
        mov al,[si]
        cmp al,[di+2]
        je .p6
.p5:    FAILB 4
.p6:    add si,4
        add di,3
        loop .p4
        mov ax,0x4F09
        mov bl,0x80
        mov cx,1
        mov dx,3
        mov di,palbuf
        int 0x10
        cmp ax,0x004F
        je .p7
        FAILB 8
.p7:    call tend
        ; save / restore
        TB '4F04 save/restore round trip'
        call tdots
        mov bx,0x101
        call setm
        mov ax,0x4F07
        xor bx,bx
        xor cx,cx
        mov dx,40
        int 0x10
        mov ax,0x1010
        mov bx,7
        mov dh,1
        mov cx,0x0203
        int 0x10
        mov si,extlist
        mov cx,EXTN
        mov di,snapA
        call snap
        RC 0x0C
        mov [tmpw],ax
        RC 0x0D
        mov [tmpw+1],al
        push es
        mov es,[scrseg]
        xor bx,bx
        mov ax,0x4F04
        mov dl,1
        mov cx,0x0F
        int 0x10
        pop es
        cmp ax,0x004F
        je .r1
        FAILB 1
.r1:    mov ax,3
        int 0x10
        push es
        mov es,[scrseg]
        xor bx,bx
        mov ax,0x4F04
        mov dl,2
        mov cx,0x0F
        int 0x10
        pop es
        cmp ax,0x004F
        je .r2
        FAILB 1
.r2:    call unlock
        mov si,extlist
        mov cx,EXTN
        mov di,snapB
        call snap
        mov si,extlist
        mov cx,EXTN
        mov bx,snapB
        mov di,snapA
        mov dx,2
        call cmpsnap
        mov ax,0x1015
        mov bx,7
        int 0x10
        cmp dh,1
        jne .r3
        cmp cx,0x0203
        je .r4
.r3:    FAILB 4
.r4:    mov ax,0x4F03
        int 0x10
        and bx,0x3FFF
        cmp bx,0x101
        je .r5
        FAILB 8
.r5:    call tend
        ; VRAM test
        cmp byte [quick],1
        je .nv
        call vram_test
.nv:    call lfb_cross
        mov ax,3
        int 0x10
        ret

pitchreg:                               ; from rdall values -> AX bytes per line
        movzx ax,byte [q_r13]
        mov bl,[q_r51]
        shr bl,4
        and bl,3
        jz .1
        mov ah,bl
        jmp .2
.1:     test byte [q_r43],4
        jz .2
        mov ah,1
.2:     mov cx,8
        test byte [q_r31],8
        jnz .3
        mov cx,4
.3:     mul cx
        ret

; 4F07 to (x, y): CR0C/CR0D/CR69 must hold (y*640+x)/4 and 4F07 BL=1 must return x and y.
startchk:                               ; CX=x DX=y in 101h, pitch 640
        mov [tmpw],cx
        mov [tmpw2],dx
        mov ax,0x4F07
        xor bx,bx
        int 0x10
        cmp ax,0x004F
        jne .f
        RC 0x0D
        movzx ebx,al
        RC 0x0C
        mov bh,al
        RC 0x69
        and eax,0x0F
        shl eax,16
        or ebx,eax
        shl ebx,2                       ; dword units (CR31.3)
        movzx eax,word [tmpw2]
        imul eax,eax,640
        movzx ecx,word [tmpw]
        add eax,ecx
        and eax,0xFFFFFFFC
        cmp eax,ebx
        jne .f
        mov ax,0x4F07
        mov bx,1
        int 0x10
        cmp cx,[tmpw]
        jne .f
        cmp dx,[tmpw2]
        jne .f
        ret
.f:     FAILB 1
        PS 'y='
        movzx eax,word [tmpw2]
        call pdec
        call sp1
        ret

marks:  xor si,si
        call setbank
        push es
        mov ax,0xA000
        mov es,ax
        mov dword [es:0],0x55AA33CC
        pop es
        mov si,[banks]
        dec si
        call setbank
        push es
        mov ax,0xA000
        mov es,ax
        mov dword [es:0xFFFC],0x0FF0C33C
        pop es
        ret
markchk:                                ; -> EAX, EDX
        xor si,si
        call setbank
        push es
        mov ax,0xA000
        mov es,ax
        mov eax,[es:0]
        pop es
        push eax
        mov si,[banks]
        dec si
        call setbank
        push es
        mov ax,0xA000
        mov es,ax
        mov edx,[es:0xFFFC]
        pop es
        pop eax
        ret

; All VRAM through the banks with two patterns (address XOR 5AA5C33Ch, then inverted), written fully
; before reading: catches MCLK too fast for the RAM and bank aliasing. Fail bit 1, the error count and
; the first bad address are printed. Expect 0 errors at 59.96 MHz.
vram_test:
        TB 'VRAM all banks, 2 patterns (MCLK)'
        call tdots
        mov bx,0x101
        call setm
        mov dword [vrerr],0
        mov dword [vpat],0
.pat:   xor si,si                       ; write
.wb:    call setbank
        push es
        mov ax,0xA000
        mov es,ax
        xor di,di
        movzx ebx,si
        shl ebx,16
.w:     mov eax,ebx
        or ax,di
        xor eax,0x5AA5C33C
        xor eax,[vpat]
        mov [es:di],eax
        add di,4
        jnz .w
        pop es
        inc si
        cmp si,[banks]
        jb .wb
        xor si,si                       ; verify
.rb:    call setbank
        push es
        mov ax,0xA000
        mov es,ax
        xor di,di
        movzx ebx,si
        shl ebx,16
.r:     mov eax,ebx
        or ax,di
        xor eax,0x5AA5C33C
        xor eax,[vpat]
        cmp [es:di],eax
        je .n
        cmp dword [vrerr],16            ; /V: the first 16 mismatches
        jae .v1
        pushad
        mov ebx,eax
        mov ecx,[es:di]
        movzx eax,si
        shl eax,16
        mov ax,di
        call vmem
        popad
.v1:    cmp dword [vrerr],0
        jne .n2
        mov ecx,ebx
        or cx,di
        mov [vfirst],ecx
.n2:    inc dword [vrerr]
.n:     add di,4
        jnz .r
        pop es
        inc si
        cmp si,[banks]
        jb .rb
        cmp dword [vpat],0
        jne .done
        mov dword [vpat],0xFFFFFFFF
        jmp .pat
.done:  movzx eax,word [banks]
        shl eax,6
        call pdec
        PS 'KB '
        cmp dword [vrerr],0
        je .ok
        FAILB 1
        mov eax,[vrerr]
        call pdec
        PS ' errors, first at '
        mov eax,[vfirst]
        shr eax,16
        call phex4
        mov eax,[vfirst]
        call phex4
.ok:    call tend
        ret

; banked write at bank 5 visible through the LFB, LFB write at the end visible through banks

; The banked window and the LFB must be the same memory: write at bank 5 and read through the LFB,
; write the last 256 bytes through the LFB and read through the last bank. Fail bits 1 and 2;
; WARN 01 when INT 15h AH=87h is not available.
lfb_cross:
        TB 'Banked window and LFB same memory'
        call tdots
        mov bx,0x101
        call setm
        mov si,5
        call setbank
        push es
        mov ax,0xA000
        mov es,ax
        mov di,0x100
        mov cx,64
        mov eax,0x10203040
.w:     stosd
        add eax,0x01010101
        loop .w
        pop es
        mov bx,0xC101
        call setm
        mov eax,[mibuf+0x28]
        add eax,0x50100
        mov [lfbsrc],eax
        call bufphys
        mov edx,eax                     ; dst = cmpbuf
        mov eax,[lfbsrc]
        mov cx,128
        call xfer
        jc .x
        mov si,cmpbuf
        mov cx,64
        mov eax,0x10203040
.c:     cmp [si],eax
        jne .f1
        add eax,0x01010101
        add si,4
        loop .c
        jmp .lw
.f1:    FAILB 1
.lw:    mov di,cmpbuf                   ; LFB write at the last 256 bytes
        mov cx,64
        mov eax,0xA0B0C0D0
.w2:    stosd
        add eax,0x00010203
        loop .w2
        movzx edx,word [banks]
        shl edx,16
        sub edx,256
        add edx,[mibuf+0x28]
        call bufphys
        mov cx,128
        call xfer
        jc .x
        mov bx,0x8101
        call setm
        mov si,[banks]
        dec si
        call setbank
        push es
        mov ax,0xA000
        mov es,ax
        mov di,0xFF00
        mov cx,64
        mov eax,0xA0B0C0D0
.c2:    cmp [es:di],eax
        jne .f2
        add eax,0x00010203
        add di,4
        loop .c2
        pop es
        jmp .e
.f2:    pop es
        FAILB 2
        jmp .e
.x:     PS 'INT 15h AH=87 failed '
        WARNB 1
.e:     call tend
        ret
bufphys:                                ; EAX = physical address of cmpbuf
        movzx eax,word [cs:segds]
        mov ax,ds
        movzx eax,ax
        shl eax,4
        add eax,cmpbuf
        ret

; INT 15h AH=87h block move (the only way to reach the LFB from real mode without a DOS extender).
xfer:   ; EAX src phys, EDX dst phys, CX words -> CF
        push si
        push es
        push ds
        pop es
        mov di,gdt
        push cx
        push eax
        mov cx,24
        xor ax,ax
        push di
        rep stosw
        pop di
        pop eax
        pop cx
        mov word [gdt+0x10],0xFFFF
        mov [gdt+0x12],ax
        ror eax,16
        mov [gdt+0x14],al
        mov byte [gdt+0x15],0x93
        mov [gdt+0x17],ah
        mov word [gdt+0x18],0xFFFF
        mov [gdt+0x1A],dx
        ror edx,16
        mov [gdt+0x1C],dl
        mov byte [gdt+0x1D],0x93
        mov [gdt+0x1F],dh
        push ds
        pop es
        mov si,gdt
        mov ah,0x87
        int 0x15
        pop es
        pop si
        ret

lfbrw:  ; EBX = offset in LFB: write 4 bytes then read back -> CF xfer error, ZF ok
        mov eax,0xC33C5AA5
        xor eax,ebx
        mov [cmpbuf],eax
        mov [lfbpat],eax
        mov edx,[mibuf+0x28]
        add edx,ebx
        mov [lfbsrc],edx
        call bufphys
        mov cx,2
        call xfer
        jc .r
        mov dword [cmpbuf],0
        mov edx,0
        call bufphys
        mov edx,eax
        mov eax,[lfbsrc]
        mov cx,2
        call xfer
        jc .r
        mov eax,[cmpbuf]
        cmp eax,[lfbpat]
        clc
.r:     ret

bankrw: ; EBX = linear offset: write/read 4 bytes through window A -> CF on error
        mov esi,ebx
        shr esi,16
        call setbank
        mov di,bx
        push es
        mov ax,0xA000
        mov es,ax
        mov eax,0xC33C5AA5
        xor eax,ebx
        mov [es:di],eax
        mov edx,[es:di]
        pop es
        cmp eax,edx
        jne .b
        clc
        ret
.b:     pushad                          ; /V: offset, written, read
        mov ecx,edx
        xchg eax,ebx
        call vmem
        popad
        stc
        ret

; ======================================================================
; register access

; Read a register: AL type (0 MISC, 1 FEAT, 2 SR, 3 CR, 4 AR, 5 GR), AH index -> AL.
; AR00-0F are read with the palette address source bit clear (the screen blanks for a moment),
; otherwise the ATC returns the index.
readreg:                                ; AL type AH index -> AL
        push dx
        push bx
        mov bl,al
        cmp bl,0
        jne .1
        mov dx,0x3CC
        in al,dx
        jmp .x
.1:     cmp bl,1
        jne .2
        mov dx,0x3CA
        in al,dx
        jmp .x
.2:     cmp bl,2
        jne .3
        mov dx,0x3C4
        jmp .ix
.3:     cmp bl,3
        jne .4
        mov dx,0x3D4
        jmp .ix
.4:     cmp bl,4
        jne .5
        mov dx,0x3DA
        in al,dx
        mov dx,0x3C0
        mov al,ah
        cmp al,0x10
        jb .4p                          ; AR00-0F only readable with PAS=0 (screen blanks briefly)
        or al,0x20
.4p:    out dx,al
        inc dx
        in al,dx
        mov bl,al
        mov dx,0x3DA
        in al,dx
        mov dx,0x3C0
        mov al,0x20
        out dx,al
        mov al,bl
        jmp .x
.5:     mov dx,0x3CE
.ix:    mov al,ah
        out dx,al
        inc dx
        in al,dx
.x:     pop bx
        pop dx
        ret

; Register snapshot and comparison helpers (lists of type, index pairs).
snap:   ; SI list (type,idx), CX n, DI dest
.l:     mov ax,[si]
        call readreg
        mov [di],al
        add si,2
        inc di
        loop .l
        ret

cmpsnap:                                ; SI list, BX actual, DI expected, CX n, DX fail bit
.l:     mov al,[bx]
        cmp al,[di]
        je .n
        push bx
        mov bl,al
        mov bh,[di]
        mov ax,[si]
        call mm_add
        pop bx
        or [fails],dx
.n:     add si,2
        inc bx
        inc di
        loop .l
        ret

extchk: ; SI list (type,idx,mask,exp) FF-terminated, DX fail bit
.l:     mov al,[si]
        cmp al,0xFF
        je .d
        mov ah,[si+1]
        call readreg
        and al,[si+2]
        cmp al,[si+3]
        je .n
        mov bl,al
        mov bh,[si+3]
        mov ax,[si]
        call mm_add
        or [fails],dx
.n:     add si,4
        jmp .l
.d:     ret

unlock: push ax
        push dx
        mov dx,0x3C4
        mov ax,0x0608
        out dx,ax
        mov dx,0x3D4
        mov ax,0x4838
        out dx,ax
        mov ax,0xA539
        out dx,ax
        pop dx
        pop ax
        ret

setbank:                                ; SI = bank
        push ax
        push bx
        push dx
        mov ax,0x4F05
        xor bx,bx
        mov dx,si
        int 0x10
        pop dx
        pop bx
        pop ax
        ret

; refresh: 30 frames timed by summing PIT channel 0 counter differences (no BIOS tick needed)
; -> AX = Hz*10, 0 = no retrace seen
rdcnt:  xor al,al                       ; latch ch0 -> AX
        out 0x43,al
        in al,0x40
        mov ah,al
        in al,0x40
        xchg al,ah
        ret
pupd:   ; add elapsed PIT counts since last call to [pel] and [pwt]
        push ax
        push bx
        call rdcnt
        mov bx,[pprev]
        mov [pprev],ax
        sub bx,ax                       ; counts down: prev - cur (mod 65536)
        movzx ebx,bx
        add [pel],ebx
        add [pwt],ebx
        pop bx
        pop ax
        ret

; Refresh in Hz x 10: PIT channel 0 counts between rising edges of 3DAh bit 3 for 30 frames,
; Hz x 10 = 11931820 / median counts per frame (the median ignores a frame stretched by a long
; interrupt, for example a disk cache writing the /V log). 0 when no retrace is seen within ~0.25 s.
measure:
        push bx
        push cx
        push dx
        pushf
        cli
        mov al,0x34                     ; ch0 mode 2, full period (same 18.2 Hz tick)
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
        mov cx,30
.l:     call waitvr
        jc .zd
        add di,4
        mov eax,[pel]
        mov [di],eax
        loop .l
        pop di
        mov word [vfrn],31
        call vframes
        call vmedian                    ; median frame period: robust against one long interrupt
        or eax,eax
        jz .z
        mov ecx,eax
        mov eax,11931820                ; Hz*10 = 1193182 * 10 / counts per frame
        xor edx,edx
        div ecx
        jmp .x
.zd:    pop di
.z:     VS 'D:FRM timeout',13,10
        xor ax,ax
.x:     pop dx
        pop cx
        pop bx
        ret
waitvr: ; wait for the start of vertical retrace, CF on timeout (~0.25 s)
        mov dword [pwt],0
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

pause:  cmp byte [interact],1
        jne .r
        push ax
        xor ah,ah
        int 0x16
        pop ax
.r:     ret

; ======================================================================
; test line framework

; Test line framework: tbegin prints the name and flushes the log, so a freeze leaves the name of
; the test that hung as the last line; tend prints PASS/FAIL/WARN/INFO with the bit mask and details.
tbegin: mov word [fails],0
        mov word [warns],0
        mov byte [mm_n],0
        mov byte [infoflag],0
        push bp
        mov bp,sp
        push si
        push ax
        mov si,[bp+2]
        mov [vname],si
        VS 'D:TEST '                    ; /V: test name and a flushed debug log
        call vstrz
        call vnl
.l:     lodsb
        or al,al
        jz .e
        call putc
        jmp .l
.e:     mov [bp+2],si
        pop ax
        pop si
        pop bp
        call flush                      ; the test that started last is on disk
        push ax
        mov ax,[optr]                   ; start of this test's lines in the log buffer
        mov [vline0],ax
        pop ax
        call vflush
        ret
tbeginx:
        mov word [fails],0
        mov word [warns],0
        mov byte [mm_n],0
        mov byte [infoflag],0
        VS 'D:TEST (mode X)',13,10
        mov word [vname],0
        push ax
        mov ax,[optr]
        mov [vline0],ax
        pop ax
        call vflush
        ret

; write the buffered text to stdout and commit it, so a freeze loses nothing

; Write the log buffer to stdout and commit it (INT 21h AH=68h) when stdout is a file.
flush:  cmp byte [tofile],1
        jne .r
        pusha
        push ds
        push es
        mov cx,[optr]
        jcxz .x
        mov ds,[cs:logseg]
        xor dx,dx
        mov bx,1
        mov ah,0x40
        int 0x21
        push cs
        pop ds
        mov word [optr],0
        mov ah,0x68                     ; commit file (DOS 3.3+)
        mov bx,1
        int 0x21
.x:     pop es
        pop ds
        popa
.r:     ret
tdots:  push ax
.l:     cmp byte [col],38
        jae .r
        mov al,' '
        call putc
        jmp .l
.r:     pop ax
        ret
tend:   push ax
        cmp word [fails],0
        jne .f
        cmp byte [infoflag],0
        jne .i
        cmp word [warns],0
        jne .w
        inc word [npass]
        PS '  PASS',13,10
        jmp .x
.f:     inc word [nfail]
        PS '  FAIL '
        mov ax,[fails]
        call phex4
        PS 13,10
        jmp .x
.w:     inc word [nwarn]
        PS '  WARN '
        mov al,[warns]
        call phex2
        PS 13,10
        jmp .x
.i:     inc word [ninfo]
        PS '  INFO',13,10
.x:     call mm_flush
        cmp byte [vflag],1              ; /V: copy the result line(s), then a register dump
        jne .nv
        pusha
        push ds
        VS 'D:RES '
        mov si,[vname]
        or si,si
        jz .nn
        call vstrz                      ; the test name went to the log before the test ran
.nn:    mov si,[vline0]
        mov cx,[optr]
        sub cx,si
        mov ds,[logseg]
        call vcopyc
        pop ds
        popa
        call vregs
.nv:    call flush
        pop ax
        ret

mm_add: push si
        movzx si,byte [mm_n]
        inc byte [mm_n]
        cmp si,24
        jae .x
        shl si,2
        mov [mmbuf+si],ax
        mov [mmbuf+si+2],bx
.x:     pop si
        ret
mm_flush:
        movzx cx,byte [mm_n]
        jcxz .r
        xor si,si
        xor dl,dl
.l:     cmp si,24*4
        jae .more
        or dl,dl
        jnz .s
        PS '      '
.s:     mov ax,[mmbuf+si]
        call pname
        mov al,'='
        call putc
        mov al,[mmbuf+si+2]
        call phex2
        mov al,'('
        call putc
        mov al,[mmbuf+si+3]
        call phex2
        PS ') '
        inc dl
        cmp dl,6
        jb .n
        PS 13,10
        xor dl,dl
.n:     add si,4
        loop .l
        jmp .e
.more:  PS '+more'
        mov dl,1
.e:     or dl,dl
        jz .r
        PS 13,10
.r:     ret
pname:  ; AL type, AH idx
        push ax
        cmp al,0
        jne .1
        PS 'MISC'
        jmp .x
.1:     cmp al,1
        jne .2
        PS 'FEAT'
        jmp .x
.2:     cmp al,6
        jne .3
        PS 'DS+'
        jmp .h
.3:     cmp al,7
        jne .4
        PS 'AH0F'
        jmp .x
.4:     movzx bx,al
        shl bx,1
        mov dx,[pfx+bx]
        call puts
.h:     pop ax
        push ax
        mov al,ah
        call phex2
.x:     pop ax
        ret
pfx     dw 0,0,p_sr,p_cr,p_ar,p_gr
p_sr    db 'SR$'
p_cr    db 'CR$'
p_ar    db 'AR$'
p_gr    db 'GR$'

; ---- output
putc:   push di
        push fs
        mov fs,[cs:logseg]
        mov di,[cs:optr]
        cmp di,0xFFF0
        jae .s
        mov [fs:di],al
        inc word [cs:optr]
.s:     cmp al,10
        jne .c
        mov byte [cs:col],0
        jmp .x
.c:     cmp al,32
        jb .x
        inc byte [cs:col]
.x:     pop fs
        pop di
        ret
ps:     push bp
        mov bp,sp
        push si
        push ax
        mov si,[bp+2]
.l:     lodsb
        or al,al
        jz .e
        call putc
        jmp .l
.e:     mov [bp+2],si
        pop ax
        pop si
        pop bp
        ret
puts:   push si
        push ax
        mov si,dx
.l:     lodsb
        cmp al,'$'
        je .e
        call putc
        jmp .l
.e:     pop ax
        pop si
        ret
sp1:    push ax
        mov al,' '
        call putc
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
nib:    push ax
        add al,'0'
        cmp al,'9'
        jbe .o
        add al,7
.o:     call putc
        pop ax
        ret
pdec:   push eax
        push ebx
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
        call putc
        loop .p
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret
pdec10: push eax
        push edx
        push ebx
        xor edx,edx
        mov ebx,10
        div ebx
        push dx
        call pdec
        mov al,'.'
        call putc
        pop ax
        add al,'0'
        call putc
        pop ebx
        pop edx
        pop eax
        ret

; ======================================================================
; /V debug log (shared with VSHOW and S3TEST)
%include "vdebug.inc"

; ======================================================================
; data
%include "vgaref.inc"

; VGA snapshot list: MISC FEAT SR0-4 CR0-18 AR0-14 GR0-8 (62)

; The 62 registers compared with the IBM reference, in the order of the vgaref snapshots.
vgalist: db 0,0, 1,0
%assign i 0
%rep 5
        db 2,i
%assign i i+1
%endrep
%assign i 0
%rep 25
        db 3,i
%assign i i+1
%endrep
%assign i 0
%rep 21
        db 4,i
%assign i i+1
%endrep
%assign i 0
%rep 9
        db 5,i
%assign i i+1
%endrep

; S3 extensions that must be off in standard VGA modes: type,idx,mask,expected
vgaext: db 0,0,0x08,0x00                ; clock select 0/1 (25/28 MHz)
        db 3,0x31,0x08,0x00             ; enhanced mapping off
        db 3,0x58,0x10,0x00             ; linear addressing off
        db 3,0x67,0xFC,0x00             ; colour mode 0, streams off
        db 3,0x51,0x3F,0x00             ; extended start/pitch bits
        db 3,0x43,0x04,0x00
        db 3,0x5D,0xFF,0x00             ; horizontal overflow
        db 3,0x5E,0x57,0x00             ; vertical overflow
        db 3,0x69,0x0F,0x00             ; display start bits 19-16
        db 3,0x90,0x80,0x00             ; FIFO L1 (p3 fix)
        db 2,0x15,0x10,0x00             ; DCLK/2 off
        db 2,0x18,0x80,0x00             ; clock doubling off
        db 0xFF

; registers compared between AH=00 and 4F02 sets, and in 4F04 round trip
extlist: db 0,0, 2,1, 2,2, 2,3, 2,4
%assign i 0
%rep 25
        db 3,i
%assign i i+1
%endrep
        db 3,0x31, 3,0x3A, 3,0x3B, 3,0x3C, 3,0x42, 3,0x43, 3,0x50, 3,0x51
        db 3,0x54, 3,0x5D, 3,0x5E, 3,0x60, 3,0x67, 3,0x69, 3,0x90, 3,0x91
        db 2,0x12, 2,0x13, 2,0x15, 2,0x18, 5,5, 5,6, 4,0x10
EXTN    equ ($-extlist)/2

s_start db 'S3COMPAT 0.8: the test takes about 3 minutes. The screen will change modes',13,10
        db 'constantly. Wait for the DOS prompt to come back.',13,10
        db 'Press any key to start, Esc to cancel.',13,10
s_start_len equ $-s_start
s_vname db 'S3COMPAT.DBG',0
s_vnomem db '/V: not enough memory for the debug buffer, /V ignored.',13,10,'$'
s_nomem db 'Not enough memory (needs 256 KB free).',13,10,'$'

align 4
logseg  dw 0
scrseg  dw 0
segds   dw 0
optr    dw 0
col     db 0
interact db 0
silent  db 0
lastbeep dw 0
ledhb   db 0
ledsec  db 2
omode   db 0
opage   db 0
ocur    dw 0
oshape  dw 0
orows   dw 0
ostart  dw 0
tofile  db 0
quick   db 0
vreq    db 0                            ; /V given
vline0  dw 0                            ; log buffer offset where the current test started
vname   dw 0                            ; its name (TB text), 0 = none
pass    db 0
npass   dw 0
nfail   dw 0
nwarn   dw 0
ninfo   dw 0
fails   dw 0
warns   dw 0
infoflag db 0
mm_n    db 0
ent     dw 0
vi      dw 0
mi      dw 0
vm      dw 0
im      db 0
hz      dw 0
phz     dw 0
mlen    dw 0
tmpb    db 0
cgapal  db 0                            ; 1 = expect the CGA palette in dac_ega
tmpb2   db 0
tmpw    dw 0
tmpw2   dw 0
tmpw3   dw 0
istext  db 0
lfbav   db 0
lfbmode db 0
cmode   db 0
csel    db 0
pn      db 0
pm      db 0
prr     db 0
banks   dw 32
sbsize  dw 0
align 4
tmpd    dd 0
tmpd2   dd 0
t0      dd 0
pel     dd 0
psize   dd 0
offl    times 40 dd 0
offend  dw 0
cur     dw 0
li_x    dw 0
li_h    dw 0
li_v    dw 0
li_5d   db 0
pwt     dd 0
pprev   dw 0
vco     dd 0
fout    dd 0
dclk    dd 0
pal     dd 0
pal2    dd 0
winfn   dd 0
vrerr    dd 0
vfirst  dd 0
vpat    dd 0
lfbsrc  dd 0
lfbpat  dd 0
f8      dd 0
f16     dd 0
q_r00     db 0
q_r01     db 0
q_r09     db 0
q_r13     db 0
q_r14     db 0
q_r17     db 0
q_r31     db 0
q_r34     db 0
q_r3b     db 0
q_r42     db 0
q_r43     db 0
q_r50     db 0
q_r51     db 0
q_r58     db 0
q_r59     db 0
q_r5a     db 0
q_r5d     db 0
q_r67     db 0
q_rs12    db 0
q_rs15    db 0
q_rs18    db 0
align 4
gdt     times 48 db 0
mmbuf   times 96 db 0
snapA   times 128 db 0
basesnap times 128 db 0
snapB   times 128 db 0
dsbuf   times 64 db 0
palrd   times 20 db 0
dacpat  times 48 db 0
dacbuf  times 768 db 0
cmpbuf  times 256 db 0
palbuf  times 1024 db 0
palbuf2 times 1024 db 0
vbeinfo times 768 db 0
vbe2buf times 768 db 0
mibuf   times 512 db 0
mlist   times 256 db 0
endprog:
