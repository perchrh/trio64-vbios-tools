; S3TEST.COM - regression test for the patched Trio64V2/DX VBIOS (386+)
; The tool version (VERSION) and the ROM version it expects (ROMVER) come from common/version.inc.
;
; Purpose
;   Confirms that every change made to the BIOS (2.04.07, the S3 reference BIOS) is present and working. It is the
;   quick check to run after flashing a new ROM version. S3COMPAT is the broad compatibility test.
;
; Usage
;   S3TEST [/V] > S3TEST.LOG
;   S3TEST /H (or /?) prints the parameters and the monitor note below.
;   /V  debug log in S3TEST.DBG (common/vdebug.inc): every INT 10h call (except during the throughput
;       benchmark), the result line, a register dump after every test and the raw retrace counts.
;       The normal output is the same with or without /V.
;   Output is buffered while the video modes switch and written to stdout at the end.
;   Exit code 0 = every test passed, 1 = at least one failed.
;   Monitor: the modes reach a 75 kHz line frequency (1600x1200 at 60 Hz; 1280x1024 at 60 Hz is
;   64 kHz). LCDs refuse what they cannot show; an old fixed-frequency or low-end CRT can be damaged by
;   a line frequency above its range. The /H help says so.
;   The report ends with "Time spent: x.y s", the run time from the BIOS tick (with /V it includes
;   writing the debug log, so it is the one line that differs from a run without /V).
;
; Tests and expected outcomes (each line ends in PASS or FAIL)
;   ROM signature    the first 256 bytes of C000 contain 'Version ' followed by ROMVER (now
;                    "2.04.07-p14"); the version found is printed, also for other BIOS versions
;   ROM checksum     bytes C000:0000-7FFF add up to 00
;   Chip ID          INFO, not counted: CR2D CR2E CR2F CR30 and the PCI revision ID, so the log shows
;                    the stepping (89 01 06 E1, PCI 06 on the test card)
;   MCLK             SR10 = 42h, SR11 = 41h after POST: 59.96 MHz memory clock
;   Memory type      CR36 bits 3-2 = 00: the RAM is still run as 1-cycle EDO
;   Pedestal         SR1A bit 5 = 0 (no blank pedestal, deepest black) and bit 4 = 1
;   Refresh defaults CR41 bits 7-5 = 100b and CR52 bits 2-0 = 001b: 1280x1024 and 1600x1200
;                    default to 60 Hz
;   Each mode in modelist: the mode set returns 004Fh, the measured refresh is within 1.5 Hz of
;                    the expected value, the total line length is the expected one, the pedestal is
;                    still off, and depending on the mode type:
;                    VGA (F_VGA)       linear addressing off, CR90 bit 7 = 0 (FIFO fix), and
;                                      CR59/CR5A back to the real base (CR59 at POST) and 00 after
;                                      the booster
;                    banked (F_BOOST)  booster active: CR58 linear addressing on with a 64 KB
;                                      window, CR59/CR5A = 000Ah, real base saved in CR6D
;                    linear (F_LFB)    linear addressing on, window 1 MB or larger, CR59 = the real
;                                      base
;                    no flag           only status, refresh, line length and pedestal (106h,
;                                      planar)
;                    The line length is the total in pixels of the mode's resolution,
;                    xres * (CR00 + 5) / (CR01 + 1) with CR5D bits 0 and 1 as bit 8. Expected: the VGA
;                    totals (900 for 720-pixel text, 400 for 320, 800 for 640) and the VESA DMT totals
;                    for 60 Hz (1056, 1344, 1688, 2160); 320x240 is 640x480 halved (400). It is not
;                    checked for 400x300 (stock 72 Hz, no DMT timing).
;   4F03 in boosted 101h reports 0101h (no linear bit although CR58 has LA on)
;   4F01 PhysBasePtr equals the real base (CR59 at POST, the PCI BAR), not the booster's 000A0000h
;   4F05 set bank 3, then get bank: 004Fh and 3
;   320 KB written through banks 0-4 and read back: 0 errors
;   Banked write throughput at least 60000 KB/s (the booster; 83700 KB/s measured on p7)
;   4F03 in 4101h reports 4101h
;   4F06 BL=3 in 101h: 4368 bytes and 4368 pixels (2 MB / 480 lines, rounded down to 8)
;   CR50 in 151h (512x384x8) = 40h (pixel length 00, was the reserved 10b in stock)
;   ATC flip-flop: left in the data state before a mode set, it is back in the index state after
;   VGA mode set clear (p12): after filling video memory, mode 13h leaves A000 all 00, mode 12h all four
;                    planes 00, mode 03h B800:0000-7FFF 0720h (fail bits 1 13h, 2 12h, 4 03h)
;   Font load (p12): plane 2 holds the 8x16 font after AX=1114h and the 8x8 font after AX=1112h, as the
;                    tables of AX=1130h BH=06h/03h (fail bits 1 8x16, 2 8x8)
;   Mode 13h scroll (p12): AH=06h full screen and a window, AH=07h a window, AH=06h AL=0, each checked
;                    pixel by pixel (fail bits 1, 2, 4, 8)
;   Text scroll (p13): mode 03h, AH=06h/07h full screen, even, odd and one-cell-wide windows, AL=0
;                    window and full screen, every cell checked (fail bits 1-40h, one per case)
;   AH=09h text (p13): counts 1, 2, 3, 5, 80 on page 0 and 3 on page 1, every cell of page 0 checked
;                    (fail bits 1-20h)
;   Planar scroll (p13): modes 12h and 0Dh, AH=06h/07h full screen and windows (widths 16, 18, 3),
;                    AL=0, every byte of the four planes checked (fail bits 1-80h); the S3 mode 6Ah
;                    (800x600x4) on its own line (fail bits 1 AH=06h full, 2 AH=07h window, 4 AL=0)
;   4F05 (p12 fast path): registers and the 3C4h index kept, CR6A set, planar 102h bank x 4 in CR6A and
;                    0040:00FE, refused in linear 4101h (fail bits 1, 2, 4, 8, 10h)
;   Timings, INFO lines not counted: mode set 03h, 4F02 101h with the clear, one 4F05, one mode 13h
;                    scroll, a text clear and a mode 12h clear with AH=06h AL=0 (shortest of 3 runs)
;
bits 16
org 0x100
%include "version.inc"
%include "vdebug.mac"
F_VGA   equ 1
F_BOOST equ 2
F_LFB   equ 4

start:  cld
        call tickrd
        mov [runt0],eax
        mov word [bp_],obuf
        mov si,0x81                     ; /V: debug log in S3TEST.DBG
.op:    lodsb
        cmp al,13
        je .opd
        cmp al,'/'
        jne .op
        lodsb
        cmp al,'?'
        je .hlp
        and al,0xDF
        cmp al,'H'
        je .hlp
        cmp al,'V'
        jne .op
        mov ax,cs
        add ax,0x2000
        cmp ax,[2]
        ja .vm
        sub ax,0x1000
        mov dx,s_vname
        call vinit
        jmp .opd
.vm:    mov dx,s_vnomem
        mov ah,9
        int 0x21
        jmp .opd
.hlp:   mov dx,s_help                   ; /H, /?: the parameters and the monitor note
        mov ah,9
        int 0x21
        mov ax,0x4C00
        int 0x21
.opd:   mov dx,s_title
        call puts
        mov ax,[bp_]
        mov [vls],ax
        mov [lst],ax
        call t_rom
        call t_chip
        call t_post
        mov si,modelist
.ml:    lodsw
        cmp ax,0xFFFF
        je .mld
        mov [m_mode],ax
        lodsw
        mov [m_hz],ax
        lodsw
        mov [m_flags],ax
        lodsw
        mov [m_xres],ax
        lodsw
        mov [m_line],ax
        push si
        call t_mode
        pop si
        jmp .ml
.mld:   call t_func
        call t_ff
        call t_vclr
        call t_font
        call t_scr13
        call t_txscr
        call t_ah09
        call t_plscr
        call t_bank
        call t_time
        ; final: text mode, write report
        mov ax,0x0003
        int 0x10
        mov dx,s_sum1
        call puts
        movzx eax,word [npass]
        call pdec
        mov dx,s_sum2
        call puts
        movzx eax,word [nfail]
        call pdec
        mov dx,s_sum3
        call puts
        call catsum
        mov dx,s_sum4                   ; run time (own line, so logs compare without it)
        call puts
        call runtime
        mov dx,s_sum5
        call puts
        mov cx,[bp_]
        sub cx,obuf
        mov dx,obuf
        mov bx,1
        mov ah,0x40
        int 0x21
        call vdone
        mov ax,0x4C00
        cmp word [nfail],0
        je .ex
        mov al,1
.ex:    int 0x21

; ---------------- ROM identity ----------------
; Expect: 'Version ' and ROMVER (now "2.04.07-p14") within C000:0000-00FF, and an 8-bit checksum of 00 over the
; lower 32 KB (the half the VGA BIOS runs from).
t_rom:  mov dx,s_sig
        call puts
        push ds
        mov ax,0xC000
        mov ds,ax
        xor si,si
        mov cx,0x100
.f:     cmp dword [si],'Vers'
        jne .fn
        cmp dword [si+4],'ion '
        je .fs
.fn:    inc si
        loop .f
        pop ds
        mov dx,s_nover
        call puts
        xor al,al
        call result
        jmp .ck
.fs:    add si,8
        mov bx,si                       ; print the version found, up to the line end
        mov cx,12
.pv:    mov al,[si]
        cmp al,' '
        jb .pe
        push ds                         ; putc works on our segment
        push cs
        pop ds
        call putc
        pop ds
        inc si
        loop .pv
.pe:    push es                         ; compare with ROMVER, which must end there
        push cs
        pop es
        mov si,bx
        mov di,s_romver
        mov cx,ROMVLEN
        repe cmpsb
        pop es
        mov al,0
        jne .pr
        cmp byte [si],'!'               ; next character: end of the version (space, CR, 0)
        jae .pr
        mov al,1
.pr:    pop ds
        call result
.ck:    push ds
        mov ax,0xC000
        mov ds,ax
        xor si,si
        xor bl,bl
        mov cx,0x8000
.s:     lodsb
        add bl,al
        loop .s
        pop ds
        mov dx,s_cks
        call puts
        mov al,bl
        call phex2
        cmp bl,0
        sete al
        call result
        ret

; ---------------- chip identification (INFO) ----------------
; CR2D/CR2E = device ID (89h 01h), CR2F = revision ID (varies with stepping, datasheet section 4.1),
; CR30 = chip ID (E1h), then the PCI revision ID (configuration byte 08h) of device 5333:8901, which
; should equal CR2F. Prints one line ending in INFO; it is not a test and not counted.
t_chip: call unlock
        mov dx,s_chip
        call puts
        mov al,0x2D
.c:     push ax
        call rdcr
        mov al,ah
        call phex2
        pop ax
        cmp al,0x30
        je .p
        call sp1
        inc al
        jmp .c
.p:     mov dx,s_pci
        call puts
        mov ax,0xB102                   ; find 5333:8901, index 0
        mov cx,0x8901
        mov dx,0x5333
        xor si,si
        int 0x1A
        jc .np
        or ah,ah
        jnz .np
        mov ax,0xB108                   ; configuration byte 08h (revision ID) -> CL
        mov di,8
        int 0x1A
        jc .np
        or ah,ah
        jnz .np
        mov al,cl
        call phex2
        jmp .e
.np:    mov dx,s_na
        call puts
.e:     mov al,2
        call ccount
        mov dx,s_info
        call puts
        ret

; ---------------- POST state ----------------
; Read the registers the BIOS set at boot, before any mode set by this program.
; Expect: SR10/SR11 = 42h/41h (59.96 MHz MCLK), CR36 bits 3-2 = 00 (1-cycle EDO),
; SR1A & 30h = 10h (pedestal off), CR41 bits 7-5 = 100b and CR52 bits 2-0 = 001b (60 Hz defaults).
t_post: call unlock
        mov al,0x59                     ; the real LFB base, as the system BIOS assigned it (PCI BAR0)
        call rdcr
        mov [base],ah
        mov dx,s_mclk
        call puts
        mov al,0x10
        call rdsr
        mov bl,ah
        mov al,ah
        call phex2
        call sp1
        mov al,0x11
        call rdsr
        mov bh,ah
        mov al,ah
        call phex2
        cmp bx,0x4142           ; SR11=41 SR10=42
        sete al
        call result
        mov dx,s_edo
        call puts
        mov al,0x36
        call rdcr
        mov al,ah
        call phex2
        test ah,0x0C
        setz al
        call result
        mov dx,s_ped
        call puts
        mov al,0x1A
        call rdsr
        mov al,ah
        call phex2
        mov al,ah
        and al,0x30
        cmp al,0x10
        sete al
        call result
        mov dx,s_ref
        call puts
        mov al,0x41
        call rdcr
        mov bl,ah
        mov al,ah
        call phex2
        call sp1
        mov al,0x52
        call rdcr
        mov bh,ah
        mov al,ah
        call phex2
        mov al,bl
        and al,0xE0
        cmp al,0x80             ; 1280x1024 field = 4 (60 Hz)
        jne .bad
        mov al,bh
        and al,0x07
        cmp al,0x01             ; 1600x1200 field = 1 (60 Hz)
        jne .bad
        mov al,1
        jmp .r
.bad:   xor al,al
.r:     call result
        ret

; ---------------- one mode ----------------
; Set [m_mode] (AH=00 for VGA modes, 4F02 for VESA), measure the refresh rate and read
; the line length from CR00, CR01 and CR5D, and CR58, CR59, CR5A, CR6D, CR90 and SR1A. Expect status
; 004Fh, refresh within 15 (1.5 Hz) of [m_hz], a line of exactly [m_line] pixels at [m_xres] (when
; [m_line] is not 0), SR1A bit 5 clear, plus the checks selected by [m_flags] (see the file header).
t_mode: VS 'D:TEST mode '
        push ax
        mov ax,[m_mode]
        call vhex4
        pop ax
        call vnl
        call vflush
        mov ax,[m_mode]
        cmp ax,0x100
        jb .vga
        mov bx,ax
        mov ax,0x4F02
        int 0x10
        mov [m_st],ax
        jmp .set
.vga:   xor ah,ah
        int 0x10
        mov word [m_st],0x004F
.set:   call unlock
        call measure            ; -> AX = Hz*10
        mov [m_meas],ax
        call linelen
        call mcat                       ; the category: the VGA BIOS standard of the mode, VBE above 0FFh
        mov dx,s_mode
        call puts
        mov ax,[m_mode]
        call phex4
        mov dx,s_st
        call puts
        mov ax,[m_st]
        call phex4
        mov dx,s_hz
        call puts
        movzx eax,word [m_meas]
        call pdec10
        mov dx,s_exp
        call puts
        movzx eax,word [m_hz]
        call pdec10
        cmp word [m_line],0
        je .nl
        mov dx,s_line
        call puts
        movzx eax,word [m_lmeas]
        call pdec
        mov dx,s_exp
        call puts
        movzx eax,word [m_line]
        call pdec
.nl:    mov dx,s_regs
        call puts
        mov al,0x58
        call rdcr
        mov [r58],ah
        mov al,ah
        call phex2
        call sp1
        mov al,0x59
        call rdcr
        mov [r59],ah
        mov al,ah
        call phex2
        call sp1
        mov al,0x5A
        call rdcr
        mov [r5a],ah
        mov al,ah
        call phex2
        call sp1
        mov al,0x6D
        call rdcr
        mov [r6d],ah
        mov al,ah
        call phex2
        call sp1
        mov al,0x90
        call rdcr
        mov [r90],ah
        mov al,ah
        call phex2
        call sp1
        mov al,0x1A
        call rdsr
        mov [r1a],ah
        mov al,ah
        call phex2
        ; checks
        cmp word [m_st],0x004F
        jne .fail
        mov ax,[m_meas]
        sub ax,[m_hz]
        jns .p
        neg ax
.p:     cmp ax,15               ; +-1.5 Hz
        ja .fail
        test byte [r1a],0x20    ; pedestal off
        jnz .fail
        mov ax,[m_line]         ; line length, exact
        or ax,ax
        jz .lk
        cmp word [m_lrem],0
        jne .fail
        cmp ax,[m_lmeas]
        jne .fail
.lk:
        mov ax,[m_flags]
        test al,F_VGA
        jz .nv
        test byte [r58],0x10
        jnz .fail
        test byte [r90],0x80    ; FIFO fix
        jnz .fail
        mov al,[r59]            ; real base restored, CR5A cleared
        cmp al,0
        je .fail
        cmp al,[base]
        jne .fail
        cmp byte [r5a],0
        jne .fail
        jmp .ok
.nv:    test al,F_BOOST
        jz .nb
        mov al,[r58]
        and al,0x13
        cmp al,0x10
        jne .fail
        cmp byte [r59],0
        jne .fail
        cmp byte [r5a],0x0A
        jne .fail
        cmp byte [r6d],0
        je .fail
        jmp .ok
.nb:    test al,F_LFB
        jz .ok
        test byte [r58],0x10
        jz .fail
        test byte [r58],0x03
        jz .fail
        mov al,[r59]
        cmp al,[base]
        jne .fail
.ok:    mov al,1
        jmp .res
.fail:  xor al,al
.res:   call result
        ret

; Line length of the current mode: [m_lmeas] = [m_xres] * htotal / hdisplay, [m_lrem] = remainder,
; with htotal = CR00 + 5 and hdisplay = CR01 + 1 in character clocks (CR5D bits 0 and 1 are bit 8 of
; each). The ratio makes it independent of the pixel clock mode and the character width. Needs the
; S3 registers unlocked. Keeps all registers.
linelen:
        pushad
        mov al,0x5D
        call rdcr
        mov bl,ah
        mov al,0x00
        call rdcr
        movzx eax,ah
        test bl,1
        jz .h
        add eax,256
.h:     add eax,5
        movzx ecx,word [m_xres]
        mul ecx
        push eax
        mov al,0x01
        call rdcr
        movzx ecx,ah
        test bl,2
        jz .d
        add ecx,256
.d:     inc ecx
        pop eax
        xor edx,edx
        div ecx
        mov [m_lmeas],ax
        mov [m_lrem],dx
        popad
        ret

; ---------------- VBE function tests ----------------
; In 101h with the booster active: 4F03, 4F01 PhysBasePtr, 4F05 set/get, banked data check,
; banked throughput. Then 4F03 in 4101h, 4F06 BL=3 in 101h and CR50 in 151h (p8 changes).
t_func: mov ax,0x4F02
        mov bx,0x0101
        int 0x10
        call unlock
        ; 4F03 must report 0101 (no linear bit)
        mov ax,0x4F03
        int 0x10
        mov [tmp],bx
        mov dx,s_f03
        call puts
        mov ax,[tmp]
        call phex4
        cmp word [tmp],0x0101
        sete al
        call result
        ; 4F01 PhysBasePtr == the real base from POST (with the booster on, CR59/5A hold 000Ah)
        mov ax,0x4F01
        mov cx,0x0101
        mov di,mibuf
        int 0x10
        mov al,0x6D
        call rdcr
        mov [r6d],ah
        mov dx,s_f01
        call puts
        mov eax,[mibuf+0x28]
        push eax
        shr eax,16
        call phex4
        mov dx,s_0000
        call puts
        pop eax
        movzx ebx,byte [base]
        shl ebx,24
        cmp eax,ebx
        jne .f1
        or ebx,ebx
        jz .f1
        mov al,1
        jmp .r1
.f1:    xor al,al
.r1:    call result
        ; 4F05 set bank 3, get
        mov ax,0x4F05
        xor bx,bx
        mov dx,3
        int 0x10
        mov [tmp],ax
        mov ax,0x4F05
        mov bx,0x0100
        int 0x10
        mov [tmp2],dx
        mov dx,s_f05
        call puts
        mov ax,[tmp]
        call phex4
        call sp1
        mov ax,[tmp2]
        call phex4
        cmp word [tmp],0x004F
        jne .f5
        cmp word [tmp2],3
        jne .f5
        mov al,1
        jmp .r5
.f5:    xor al,al
.r5:    call result
        ; data integrity, 5 banks
        call verify
        mov dx,s_dat
        call puts
        mov eax,[errs]
        call pdec
        cmp dword [errs],0
        sete al
        call result
        ; throughput
        mov byte [vquiet],1             ; no INT 10h logging while timing
        call bench
        mov byte [vquiet],0
        mov dx,s_thr
        call puts
        mov eax,[kbs]
        call pdec
        mov dx,s_kbs
        call puts
        cmp dword [kbs],60000
        setae al
        call result
        ; linear mode: 4F03 must report 4101
        mov ax,0x4F02
        mov bx,0x4101
        int 0x10
        mov ax,0x4F03
        int 0x10
        mov [tmp],bx
        mov dx,s_f03l
        call puts
        mov ax,[tmp]
        call phex4
        cmp word [tmp],0x4101
        sete al
        call result
        ; p8: 4F06 BL=3 maximum line length in 101h = 4368 bytes / 4368 pixels (2 MB / 480 lines)
        mov ax,0x4F02
        mov bx,0x0101
        int 0x10
        mov ax,0x4F06
        mov bl,3
        int 0x10
        mov [tmp],ax
        mov [tmp2],bx
        mov [m_meas],cx
        mov dx,s_f06
        call puts
        movzx eax,word [tmp2]
        call pdec
        mov al,'/'
        call putc
        movzx eax,word [m_meas]
        call pdec
        cmp word [tmp],0x004F
        je .s6
        mov dx,s_st             ; the function failed: show its status (VBE 1.2 has no BL=3)
        call puts
        mov ax,[tmp]
        call phex4
        jmp .f6
.s6:
        cmp word [tmp2],4368
        jne .f6
        cmp word [m_meas],4368
        jne .f6
        mov al,1
        jmp .r6
.f6:    xor al,al
.r6:    call result
        ; p8: CR50 in 512x384x8 (151h) = 40h (pixel length 00, was 60h)
        mov ax,0x4F02
        mov bx,0x0151
        int 0x10
        call unlock
        mov al,0x50
        call rdcr
        mov [tmp],ax
        mov dx,s_c50
        call puts
        mov al,[tmp+1]
        call phex2
        cmp byte [tmp+1],0x40
        sete al
        call result
        ret

; ---------------- ATC flip-flop reset after mode set ----------------
; Put the attribute controller flip-flop in the data state (one write to 3C0h), set mode 03,
; then write 31h to 3C0h. If the BIOS reset the flip-flop, 31h lands in the index register and
; reads back from 3C0h. Expect 31h (index 11h with palette address source set).
t_ff:   mov ax,0x0003
        int 0x10
        mov dx,0x3DA
        in al,dx
        mov dx,0x3C0
        mov al,0x20
        out dx,al               ; flip-flop now in data state
        mov ax,0x0003
        int 0x10                ; must reset it
        mov dx,0x3C0
        mov al,0x31             ; if in index state: index 11h + PAS
        out dx,al
        in al,dx                ; index readback
        mov [tmp],al
        mov dx,0x3DA
        in al,dx
        mov dx,0x3C0
        mov al,0x20
        out dx,al
        mov dx,s_ff
        call puts
        mov al,[tmp]
        call phex2
        mov al,[tmp]
        and al,0x3F
        cmp al,0x31
        sete al
        call result
        ret


; ---------------- VGA mode set clear (p12: 32-bit) ----------------
; Video memory filled with a pattern, then the mode set again: mode 13h leaves A000:0000-FFFF 00, mode 12h
; all four planes 00 (64 KB each, read map 0-3), mode 03h B800:0000-7FFF 0720h words. Fail bits:
; 1 mode 13h, 2 mode 12h, 4 mode 03h.
t_vclr: VS 'D:TEST vga clear'
        call vnl
        call vflush
        push es
        mov byte [tmp],0
        mov ax,0x0013
        int 0x10
        mov ax,0xA000
        mov es,ax
        xor di,di
        mov cx,0x8000
        mov ax,0x5555
        rep stosw
        mov ax,0x0013
        int 0x10
        xor di,di
        mov cx,0x8000
        xor ax,ax
        repe scasw
        je .m12
        or byte [tmp],1
.m12:   mov ax,0x0012
        int 0x10
        xor di,di                       ; write mode 0, map mask 0Fh: all planes
        mov cx,0x8000
        mov ax,0xAAAA
        rep stosw
        mov ax,0x0012
        int 0x10
        mov bl,0
.pl:    mov dx,0x3CE
        mov al,0x04
        mov ah,bl
        out dx,ax                       ; read map = plane BL
        xor di,di
        mov cx,0x8000
        xor ax,ax
        repe scasw
        je .pn
        or byte [tmp],2
.pn:    inc bl
        cmp bl,4
        jb .pl
        mov ax,0x0003
        int 0x10
        mov ax,0xB800
        mov es,ax
        xor di,di
        mov cx,0x4000
        mov ax,0x55AA
        rep stosw
        mov ax,0x0003
        int 0x10
        xor di,di
        mov cx,0x4000
        mov ax,0x0720
        repe scasw
        je .e
        or byte [tmp],4
.e:     pop es
        mov dx,s_vclr
        jmp bits_result

; ---------------- font load (p12: 32-bit) ----------------
; Mode 03h with AX=1114h: plane 2 holds the 8x16 font of AX=1130h BH=06h at 32 bytes per character;
; after AX=1112h the 8x8 font of BH=03h (8 bytes per character). The mode set loads the font with the
; same routine, plus the 9x16 alternates in 9-dot modes, which is why 1114h is used for the check. Plane 2 is read with SR04 = 06h, GR04 = 02h,
; GR05 = 00h, GR06 = 04h; the next mode set puts them back. Fail bits: 1 8x16, 2 8x8.
t_font: VS 'D:TEST font load'
        call vnl
        call vflush
        mov byte [tmp],0
        mov ax,0x0003
        int 0x10
        mov ax,0x1114                   ; 8x16 (the mode set adds the 9x16 alternates in 9-dot modes)
        xor bl,bl
        int 0x10
        mov bh,6
        mov cx,16
        call fchk
        jz .f8
        or byte [tmp],1
.f8:    mov ax,0x1112
        xor bl,bl
        int 0x10
        mov bh,3
        mov cx,8
        call fchk
        jz .e
        or byte [tmp],2
.e:     mov ax,0x0003
        int 0x10
        mov dx,s_font
        jmp bits_result

; Plane 2 against the BIOS font table BH (AX=1130h), CX bytes per character -> ZF=1 when equal.
fchk:   push ds
        push es
        push cx
        mov ax,0x1130
        int 0x10                        ; ES:BP = table
        pop cx
        push es
        pop ds
        mov si,bp
        push cx
        mov dx,0x3C4
        mov ax,0x0604
        out dx,ax
        mov dx,0x3CE
        mov ax,0x0204
        out dx,ax
        mov ax,0x0005
        out dx,ax
        mov ax,0x0406
        out dx,ax
        pop cx
        mov ax,0xA000
        mov es,ax
        xor di,di
        mov bx,256
.c:     push cx
        push di
        repe cmpsb
        pop di
        pop cx
        jne .r
        add di,32
        dec bx
        jnz .c
.r:     pop es
        pop ds
        ret

; ---------------- mode 13h scroll (p12: 32-bit for AH=06h) ----------------
; A000 is filled with (7x + 13y) mod 256, then each case is checked pixel by pixel against the same
; formula: A AH=06h AL=1 full screen, fill 1Fh; B AH=06h AL=2 rows 3-10, columns 5-20, fill 05h;
; C AH=07h AL=1 the same window, fill 44h; D AH=06h AL=0 rows 1-3, columns 2-4, fill 33h.
; Fail bits 1 A, 2 B, 4 C, 8 D.
t_scr13:
        VS 'D:TEST mode 13h scroll'
        call vnl
        call vflush
        mov byte [tmp],0
        mov si,scrtab
.n:     cmp word [si],0
        je .e
        push si
        mov ax,0x0013
        int 0x10
        call fill13
        mov ax,[si]
        mov bx,[si+2]
        mov cx,[si+4]
        mov dx,[si+6]
        int 0x10
        pop si
        push si
        call chk13
        pop si
        jz .ok
        mov al,[si+19]                  ; fail bit (the byte after the 0 at +18)
        or [tmp],al
.ok:    add si,20
        jmp .n
.e:     mov dx,s_scr
        jmp bits_result

fill13: push es
        mov ax,0xA000
        mov es,ax
        xor di,di
        xor dx,dx                       ; y
.y:     mov ax,dx
        imul ax,ax,13
        mov cx,320
.x:     stosb
        add al,7
        loop .x
        inc dx
        cmp dx,200
        jb .y
        pop es
        ret

; SI = case: +8 x0, +10 x1, +12 y0, +14 y1, +16 shift (lines, + = up, - = down), +3 fill (BH). ZF=1 when
; every pixel is as expected.
chk13:  push es
        mov ax,0xA000
        mov es,ax
        xor di,di
        xor bp,bp                       ; y
.y:     xor cx,cx                       ; x
.x:     mov bx,bp                       ; BX = source line for an unchanged pixel
        cmp cx,[si+8]
        jb .p
        cmp cx,[si+10]
        ja .p
        cmp bp,[si+12]
        jb .p
        cmp bp,[si+14]
        ja .p
        mov ax,[si+16]
        or ax,ax
        js .dn
        mov bx,[si+14]                  ; up: lines y0..y1-shift come from y+shift, the rest is fill
        sub bx,ax
        cmp bp,bx
        jg .fl
        mov bx,bp
        add bx,ax
        jmp .p
.dn:    neg ax                          ; down: lines y0+shift..y1 come from y-shift
        mov bx,[si+12]
        add bx,ax
        cmp bp,bx
        jl .fl
        mov bx,bp
        sub bx,ax
.p:     mov ax,bx                       ; expected (7x + 13 * source line) mod 256
        imul ax,ax,13
        mov dx,cx
        imul dx,dx,7
        add ax,dx
        jmp .c
.fl:    mov al,[si+3]
.c:     cmp al,[es:di]
        jne .r
        inc di
        inc cx
        cmp cx,320
        jb .x
        inc bp
        cmp bp,200
        jb .y
        xor ax,ax                       ; ZF=1
.r:     pop es
        ret

scrtab: ;   AX      BX      CX      DX      x0  x1   y0  y1   shift  -   bit
        dw 0x0601, 0x1F00, 0x0000, 0x1827, 0,  319, 0,  199,  8
        db 0, 1
        dw 0x0602, 0x0500, 0x0305, 0x0A14, 40, 167, 24, 87,   16
        db 0, 2
        dw 0x0701, 0x4400, 0x0305, 0x0A14, 40, 167, 24, 87,   -8
        db 0, 4
        dw 0x0600, 0x3300, 0x0102, 0x0304, 16, 39,  8,  31,   24
        db 0, 8
        dw 0

; ---------------- text scroll (p13: 32-bit fills and window moves) ----------------
; Mode 03h. B800 is filled with the cell word P(c, r) = (7c + 13r) mod 256 | ((5c + 11r) mod 128) << 8,
; then each case is checked cell by cell against the same formula (fill: 20h with attribute BH):
; A AH=06h AL=1 full screen, fill 1Fh; B AH=07h AL=2 full screen, fill 07h; C AH=06h AL=2 rows 3-10,
; columns 5-20 (even width), fill 70h; D AH=07h AL=1 rows 3-10, columns 5-21 (odd width), fill 4Eh;
; E AH=06h AL=0 rows 1-3, columns 2-4, fill 33h; F AH=06h AL=0 full screen, fill 07h; G AH=07h AL=3
; rows 2-9, column 1 (one cell wide), fill 2Ah. Fail bits 1 A, 2 B, 4 C, 8 D, 10h E, 20h F, 40h G.
t_txscr:
        VS 'D:TEST text scroll'
        call vnl
        call vflush
        mov byte [tmp],0
        mov si,txstab
.n:     cmp word [si],0
        je .e
        push si
        mov ax,0x0003
        int 0x10
        call filltx
        mov ax,[si]
        mov bx,[si+2]
        mov cx,[si+4]
        mov dx,[si+6]
        int 0x10
        pop si
        push si
        call chktx
        pop si
        jz .ok
        mov al,[si+19]                  ; fail bit (the byte after the 0 at +18)
        or [tmp],al
.ok:    add si,20
        jmp .n
.e:     mov ax,0x0003
        int 0x10
        mov dx,s_txs
        jmp bits_result

; B800:0000 = P(c, r) for 80 x 25 cells.
filltx: push es
        mov ax,0xB800
        mov es,ax
        xor di,di
        xor dx,dx                       ; r
.r:     xor cx,cx                       ; c
.c:     call ptx
        stosw
        inc cx
        cmp cx,80
        jb .c
        inc dx
        cmp dx,25
        jb .r
        pop es
        ret

; AX = P(CX, DX) (column CX, row DX)
ptx:    push bx
        mov ax,cx
        imul ax,ax,7
        mov bx,dx
        imul bx,bx,13
        add al,bl                       ; character
        mov bx,cx
        imul bx,bx,5
        push dx
        imul dx,dx,11
        add bl,dl
        pop dx
        and bl,0x7F
        mov ah,bl                       ; attribute
        pop bx
        ret

; SI = case: +8 c0, +10 c1, +12 r0, +14 r1, +16 shift (rows, + = up, - = down, 99 = clear), +3 fill
; attribute (BH). ZF=1 when every cell is as expected.
chktx:  push es
        mov ax,0xB800
        mov es,ax
        xor di,di
        xor dx,dx                       ; r
.r:     xor cx,cx                       ; c
.c:     push dx                         ; DX = source row for an unchanged cell
        cmp cx,[si+8]
        jb .p
        cmp cx,[si+10]
        ja .p
        cmp dx,[si+12]
        jb .p
        cmp dx,[si+14]
        ja .p
        mov ax,[si+16]
        or ax,ax
        js .dn
        mov bx,[si+14]                  ; up: rows r0..r1-shift come from r+shift, the rest is fill
        sub bx,ax
        cmp dx,bx
        jg .fl
        add dx,ax
        jmp .p
.dn:    neg ax                          ; down: rows r0+shift..r1 come from r-shift
        mov bx,[si+12]
        add bx,ax
        cmp dx,bx
        jl .fl
        sub dx,ax
.p:     call ptx
        jmp .k
.fl:    mov al,0x20
        mov ah,[si+3]
.k:     pop dx
        cmp ax,[es:di]
        jne .x
        add di,2
        inc cx
        cmp cx,80
        jb .c
        inc dx
        cmp dx,25
        jb .r
        xor ax,ax                       ; ZF=1
.x:     pop es
        ret

txstab: ;   AX      BX      CX      DX      c0  c1  r0  r1  shift  -   bit
        dw 0x0601, 0x1F00, 0x0000, 0x184F, 0,  79, 0,  24, 1
        db 0, 1
        dw 0x0702, 0x0700, 0x0000, 0x184F, 0,  79, 0,  24, -2
        db 0, 2
        dw 0x0602, 0x7000, 0x0305, 0x0A14, 5,  20, 3,  10, 2
        db 0, 4
        dw 0x0701, 0x4E00, 0x0305, 0x0A15, 5,  21, 3,  10, -1
        db 0, 8
        dw 0x0600, 0x3300, 0x0102, 0x0304, 2,  4,  1,  3,  99
        db 0, 0x10
        dw 0x0600, 0x0700, 0x0000, 0x184F, 0,  79, 0,  24, 99
        db 0, 0x20
        dw 0x0703, 0x2A00, 0x0201, 0x0901, 1,  1,  2,  9,  -3
        db 0, 0x40
        dw 0

; ---------------- AH=09h in text modes (p13: 32-bit stores) ----------------
; Mode 03h, B800 filled with P(c, r) as in the text scroll test. AH=09h 'Q' attribute 1Eh at row 5,
; column 10 with CX = 1, 2, 3, 5 and 80 (fail bits 1, 2, 4, 8, 10h), and on page 1 (B800:1000) with
; CX = 3 (fail bit 20h, the BIOS's code path for pages above 0): CX cells become 1E51h, every other
; cell keeps P(c, r) (the cells of a count running past the row continue on the next rows, as on
; the IBM BIOS).
t_ah09: VS 'D:TEST AH=09h text'
        call vnl
        call vflush
        mov byte [tmp],0
        mov si,ah09tab
.n:     cmp word [si],0
        je .e
        push si
        mov ax,0x0003
        int 0x10
        call filltx
        mov ax,[si+4]                   ; page
        mov ah,0x05
        int 0x10
        mov ah,0x02
        mov bh,[si+4]
        mov dx,0x050A
        int 0x10
        mov ax,0x0951
        mov bl,0x1E
        mov bh,[si+4]
        mov cx,[si]
        int 0x10
        mov ax,0x0500
        int 0x10
        pop si
        push si
        call chk09
        pop si
        jz .ok
        mov al,[si+2]
        or [tmp],al
.ok:    add si,6
        jmp .n
.e:     mov ax,0x0003
        int 0x10
        mov dx,s_ah09
        jmp bits_result

; SI = case: +0 count, +4 page. Page 0 cells are P(c, r) except the CX cells from (10, 5); page 1
; (filltx only filled B800:0000-0F9F, page 1 starts at 1000h): its CX cells from (10, 5) are 1E51h.
chk09:  push es
        mov ax,0xB800
        mov es,ax
        cmp byte [si+4],0
        jne .pg1
        xor di,di
        xor dx,dx
.r:     xor cx,cx
.c:     mov ax,dx                       ; cell index r * 80 + c
        imul ax,ax,80
        add ax,cx
        sub ax,5 * 80 + 10
        jb .p
        cmp ax,[si]
        jae .p
        mov ax,0x1E51
        jmp .k
.p:     call ptx
.k:     cmp ax,[es:di]
        jne .x
        add di,2
        inc cx
        cmp cx,80
        jb .c
        inc dx
        cmp dx,25
        jb .r
        xor ax,ax
        jmp .x
.pg1:   mov di,0x1000 + (5 * 80 + 10) * 2
        mov cx,[si]
.q:     cmp word [es:di],0x1E51
        jne .x
        add di,2
        loop .q
        xor ax,ax
.x:     pop es
        ret

ah09tab: ;  count, fail bit, 0, page
        dw 1
        db 1, 0
        dw 0
        dw 2
        db 2, 0
        dw 0
        dw 3
        db 4, 0
        dw 0
        dw 5
        db 8, 0
        dw 0
        dw 80
        db 0x10, 0
        dw 0
        dw 3
        db 0x20, 0
        dw 1
        dw 0

; ---------------- planar scroll (p13: 32-bit set/reset fills) ----------------
; Modes 12h (80 bytes x 480 lines, 16-line characters) and 0Dh (40 x 200, 8-line characters), with
; the geometry taken from the BIOS data area (44Ah columns, 485h character height, 484h rows - 1).
; Every plane p is filled with Q(p, x, y) = (7x + 13y + 85p) mod 256 (x byte column, y scan line), then
; each case is checked byte by byte in all four planes (fill: FFh in the planes of the colour BH, else
; 00h). Mode 12h: A AH=06h AL=1 full screen, colour 0Eh; B AH=07h AL=2 full screen, 05h; C AH=06h
; AL=3 rows 3-10, columns 5-20, 0Ah; D AH=07h AL=1 rows 3-10, columns 5-22 (18 bytes, not a multiple of
; 4), 03h; E AH=06h AL=0 rows 1-3, columns 2-4, 0Fh; F AH=06h AL=0 full screen, 09h. Mode 0Dh: G AH=06h
; AL=1 full screen, 0Ch; H AH=07h AL=1 rows 3-10, columns 5-22, 06h. Fail bits 1 A, 2 B, 4 C, 8 D,
; 10h E, 20h F, 40h G, 80h H.
t_plscr:
        VS 'D:TEST planar scroll'
        call vnl
        call vflush
        mov si,plstab
        mov dx,s_pls
        call plrun
        VS 'D:TEST planar scroll 6Ah'
        call vnl
        call vflush
        mov si,plst6a
        mov dx,s_pl6a
; SI = table, DX = result text
plrun:  mov byte [tmp],0
        push dx
.n:     cmp word [si],0
        je .e
        push si
        mov ax,[si+20]                  ; mode
        int 0x10
        push es
        xor ax,ax
        mov es,ax
        mov ax,[es:0x44A]
        mov [plbpl],ax
        movzx ax,byte [es:0x485]
        mov [plchh],ax
        movzx bx,byte [es:0x484]
        inc bx
        mul bx
        mov [pllines],ax
        pop es
        call fillpl
        mov ax,[si]
        mov bx,[si+2]
        mov cx,[si+4]
        mov dx,[si+6]
        int 0x10
        pop si
        push si
        call chkpl
        pop si
        jz .ok
        mov al,[si+19]                  ; fail bit (the byte after the 0 at +18)
        or [tmp],al
.ok:    add si,22
        jmp .n
.e:     mov ax,0x0003
        int 0x10
        pop dx
        jmp bits_result

; Q(p, x, y) into AL: plane [plp], CX = x, DX = y
qpl:    push bx
        mov ax,cx
        imul ax,ax,7
        mov bx,dx
        imul bx,bx,13
        add al,bl
        mov bl,[plp]
        imul bx,bx,85
        add al,bl
        pop bx
        ret

; Fill the four planes with Q: write mode 0, no set/reset, bit mask FFh, one plane at a time.
fillpl: push es
        mov ax,0xA000
        mov es,ax
        mov dx,0x3CE
        mov ax,0x0005
        out dx,ax
        mov ax,0x0001
        out dx,ax
        mov ax,0x0003
        out dx,ax
        mov ax,0xFF08
        out dx,ax
        mov byte [plp],0
.p:     mov dx,0x3C4
        mov ah,1
        mov cl,[plp]
        shl ah,cl
        mov al,0x02
        out dx,ax
        xor di,di
        xor dx,dx                       ; y
.y:     xor cx,cx                       ; x
.x:     call qpl
        stosb
        inc cx
        cmp cx,[plbpl]
        jb .x
        inc dx
        cmp dx,[pllines]
        jb .y
        inc byte [plp]
        cmp byte [plp],4
        jb .p
        mov dx,0x3C4
        mov ax,0x0F02
        out dx,ax
        pop es
        ret

; SI = case (as txstab, in character cells; +3 colour). ZF=1 when every byte of every plane is as
; expected. Uses read map select (GR04) per plane and puts it back to 0.
chkpl:  push es
        push bp
        mov ax,0xA000
        mov es,ax
        mov byte [plp],0
.p:     mov dx,0x3CE
        mov ah,[plp]
        mov al,0x04
        out dx,ax
        xor di,di
        xor dx,dx                       ; y
.y:     mov ax,dx                       ; BP = character row of y
        push dx
        xor dx,dx
        div word [plchh]
        mov bp,ax
        pop dx
        xor cx,cx                       ; x
.x:     push dx                         ; DX = source line for an unchanged byte
        cmp cx,[si+8]
        jb .q
        cmp cx,[si+10]
        ja .q
        cmp bp,[si+12]
        jb .q
        cmp bp,[si+14]
        ja .q
        mov ax,[si+16]
        or ax,ax
        js .dn
        mov bx,[si+14]                  ; up: rows r0..r1-shift come from r+shift, the rest is fill
        sub bx,ax
        cmp bp,bx
        jg .fl
        imul ax,[plchh]
        add dx,ax
        jmp .q
.dn:    neg ax                          ; down: rows r0+shift..r1 come from r-shift
        mov bx,[si+12]
        add bx,ax
        cmp bp,bx
        jl .fl
        imul ax,[plchh]
        sub dx,ax
.q:     call qpl
        jmp .k
.fl:    mov bl,[si+3]
        mov al,0
        push cx
        mov cl,[plp]
        shr bl,cl
        pop cx
        test bl,1
        jz .k
        mov al,0xFF
.k:     pop dx
        cmp al,[es:di]
        jne .x0
        inc di
        inc cx
        cmp cx,[plbpl]
        jb .x
        inc dx
        cmp dx,[pllines]
        jb .y
        inc byte [plp]
        cmp byte [plp],4
        jb .p
        xor ax,ax                       ; ZF=1
.x0:    pushf
        mov dx,0x3CE
        mov ax,0x0004
        out dx,ax
        popf
        pop bp
        pop es
        ret

plstab: ;   AX      BX      CX      DX      c0  c1  r0  r1  shift  -   bit  mode
        dw 0x0601, 0x0E00, 0x0000, 0x1D4F, 0,  79, 0,  29, 1
        db 0, 1
        dw 0x12
        dw 0x0702, 0x0500, 0x0000, 0x1D4F, 0,  79, 0,  29, -2
        db 0, 2
        dw 0x12
        dw 0x0603, 0x0A00, 0x0305, 0x0A14, 5,  20, 3,  10, 3
        db 0, 4
        dw 0x12
        dw 0x0701, 0x0300, 0x0305, 0x0A16, 5,  22, 3,  10, -1
        db 0, 8
        dw 0x12
        dw 0x0600, 0x0F00, 0x0102, 0x0304, 2,  4,  1,  3,  99
        db 0, 0x10
        dw 0x12
        dw 0x0600, 0x0900, 0x0000, 0x1D4F, 0,  79, 0,  29, 99
        db 0, 0x20
        dw 0x12
        dw 0x0601, 0x0C00, 0x0000, 0x1827, 0,  39, 0,  24, 1
        db 0, 0x40
        dw 0x0D
        dw 0x0701, 0x0600, 0x0305, 0x0A16, 5,  22, 3,  10, -1
        db 0, 0x80
        dw 0x0D
        dw 0
; S3 mode 6Ah (800x600x4, 100 bytes a line, 16-line characters, all in the first 64 KB of each plane)
plst6a: dw 0x0601, 0x0E00, 0x0000, 0x2463, 0,  99, 0,  36, 1
        db 0, 1
        dw 0x6A
        dw 0x0702, 0x0500, 0x0305, 0x1440, 5,  64, 3,  20, -2
        db 0, 2
        dw 0x6A
        dw 0x0600, 0x0B00, 0x0102, 0x0503, 2,  3,  1,  5,  99
        db 0, 4
        dw 0x6A
        dw 0

; ---------------- VBE 4F05 (p12: fast path from the INT 10h entry) ----------------
; In 101h: 4F05 BH=0 DX=5 returns 004Fh with BX, CX, DX, SI, DI unchanged (fail 1), keeps the 3C4h index
; and SR08 (fail 2) and sets CR6A = 05h (fail 4). In planar 102h DX=2 gives CR6A = 08h and 0040:00FE =
; 0008h (fail 8). In linear 4101h it is refused with 034Fh and CR6A stays (fail 10h). CR6A is compared
; in its bank field, bits 4-0 (Trio64V2 datasheet: bit 5 reserved with 2 MB); the reserved bits 7-6 read
; back as 1 on the card (p12 hardware log: C3h after bank 3), which the first version of this test
; counted as fail 4 and 8.
t_bank: VS 'D:TEST 4F05'
        call vnl
        call vflush
        mov byte [tmp],0
        mov ax,0x4F02
        mov bx,0x0101
        int 0x10
        call unlock
        mov al,0x08
        call rdsr
        mov [tmp2],ah                   ; SR08 before
        mov dx,0x3C4
        mov al,0x02
        out dx,al                       ; SR index 02h
        mov ax,0x4F05
        xor bx,bx
        mov cx,0x1234
        mov dx,5
        mov si,0x5678
        mov di,0x9ABC
        int 0x10
        cmp ax,0x004F
        jne .f1
        or bx,bx
        jne .f1
        cmp cx,0x1234
        jne .f1
        cmp dx,5
        jne .f1
        cmp si,0x5678
        jne .f1
        cmp di,0x9ABC
        je .r1
.f1:    or byte [tmp],1
.r1:    mov dx,0x3C4
        in al,dx
        cmp al,0x02
        jne .f2
        mov al,0x08
        call rdsr
        cmp ah,[tmp2]
        je .r2
.f2:    or byte [tmp],2
.r2:    mov al,0x6A
        call rdcr
        and ah,0x1F                     ; bank field CR6A bits 4-0 (2 MB); bits 7-6 read 1 on the card
        cmp ah,0x05
        je .pl
        or byte [tmp],4
.pl:    mov ax,0x4F02
        mov bx,0x0102
        int 0x10
        mov ax,0x4F05
        xor bx,bx
        mov dx,2
        int 0x10
        call unlock
        mov al,0x6A
        call rdcr
        and ah,0x1F
        cmp ah,0x08
        jne .f8
        push es
        xor ax,ax
        mov es,ax
        cmp word [es:0x4FE],0x0008
        pop es
        je .lf
.f8:    or byte [tmp],8
.lf:    mov ax,0x4F02
        mov bx,0x4101
        int 0x10
        call unlock
        mov al,0x6A
        call rdcr
        mov [tmp2],ah
        mov ax,0x4F05
        xor bx,bx
        mov dx,7
        int 0x10
        cmp ax,0x034F
        jne .f10
        call unlock
        mov al,0x6A
        call rdcr
        cmp ah,[tmp2]
        je .e
.f10:   or byte [tmp],0x10
.e:     mov dx,s_bank
        jmp bits_result

; Print the test name at DX, the fail bits in [tmp] and PASS (bits 0) or FAIL.
bits_result:
        call puts
        mov al,[tmp]
        call phex2
        cmp byte [tmp],0
        sete al
        call result
        ret

; ---------------- timings (INFO, not counted) ----------------
; PIT channel 0 in mode 2 and the BIOS tick give a 32-bit time in 1/1193182 s; each value is the
; shortest of 3 runs: mode set 03h, 4F02 101h (with the 2 MB clear), one 4F05 (1000 calls, per call),
; one AH=06h full-screen scroll in mode 13h, AH=06h AL=0 full screen in mode 03h and in mode 12h.
; INT 10h logging (/V) is off while timing.
t_time: VS 'D:TEST timings'
        call vnl
        call vflush
        mov byte [vquiet],1
        pushf
        cli
        mov al,0x34
        out 0x43,al
        xor al,al
        out 0x40,al
        out 0x40,al
        popf
        mov dx,s_t03
        mov bx,tm_03
        call time3
        mov dx,s_t101
        mov bx,tm_101
        call time3
        mov ax,0x4F02
        mov bx,0x0101
        int 0x10
        mov dx,s_t05
        mov bx,tm_05
        call time3
        mov ax,0x0013
        int 0x10
        mov dx,s_tscr
        mov bx,tm_scr
        call time3
        mov ax,0x0003
        int 0x10
        mov dx,s_ttcl
        mov bx,tm_tcl
        call time3
        mov ax,0x0012
        int 0x10
        mov dx,s_tpcl
        mov bx,tm_pcl
        call time3
        mov ax,0x0003
        int 0x10
        mov byte [vquiet],0
        cmp byte [vflag],1              ; /V keeps mode 2 for its call timing (vdone restores)
        je .r
        pushf
        cli
        mov al,0x36
        out 0x43,al
        xor al,al
        out 0x40,al
        out 0x40,al
        popf
.r:     ret

; DX = line text, BX = routine to time. Prints "text <ms or us with one decimal>  INFO".
time3:  push dx
        mov dword [tmin],0xFFFFFFFF
        mov cx,3
.l:     push cx
        push bx
        call tstamp
        mov [tst],eax
        call bx
        call tstamp
        sub eax,[tst]
        cmp eax,[tmin]
        jae .n
        mov [tmin],eax
.n:     pop bx
        pop cx
        loop .l
        pop dx
        call puts
        mov eax,[tmin]                  ; tenths: counts * 10000 / 1193182
        mov ecx,10000
        mul ecx
        mov ecx,1193182
        div ecx
        call pdec10
        mov al,2
        call ccount
        mov dx,s_tinfo
        call puts
        ret

; EAX = BIOS tick * 65536 + PIT channel 0 counts elapsed in this tick (mode 2: counts down by 1).
tstamp: push es
        push bx
        push dx
        xor ax,ax
        mov es,ax
.r:     mov bx,[es:0x46C]
        call rdcnt
        mov dx,ax
        cmp bx,[es:0x46C]
        jne .r
        mov ax,bx
        shl eax,16
        mov ax,0xFFFF
        sub ax,dx
        pop dx
        pop bx
        pop es
        ret

tm_03:  mov ax,0x0003
        int 0x10
        ret
tm_101: mov ax,0x4F02
        mov bx,0x0101
        int 0x10
        ret
tm_05:  mov cx,1000
.l:     push cx
        mov ax,0x4F05
        xor bx,bx
        mov dx,cx
        and dx,7
        int 0x10
        pop cx
        loop .l
        ret
tm_scr: mov ax,0x0601
        mov bx,0x0700
        xor cx,cx
        mov dx,0x1827
        int 0x10
        ret
tm_tcl: mov ax,0x0600
        mov bx,0x0700
        xor cx,cx
        mov dx,0x184F
        int 0x10
        ret
tm_pcl: mov ax,0x0600
        mov bx,0x0100
        xor cx,cx
        mov dx,0x1D4F
        int 0x10
        ret

; Unlock the S3 extended registers: SR08 = 06h, CR38 = 48h, CR39 = A5h.
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

; Read CRTC register AL into AH (port 3D4h/3D5h).
rdcr:   push dx
        mov dx,0x3D4
        out dx,al
        inc dx
        in al,dx
        mov ah,al
        pop dx
        ret

; Read sequencer register AL into AH (port 3C4h/3C5h).
rdsr:   push dx
        mov dx,0x3C4
        out dx,al
        inc dx
        in al,dx
        mov ah,al
        pop dx
        ret

; Refresh rate: PIT channel 0 in mode 2 (same 18.2 Hz tick, counter readable), the counts between
; rising edges of the vertical retrace bit (3DAh bit 3) for 30 frames; Hz x 10 = 11931820 / median
; counts per frame. The median ignores a frame stretched by a long interrupt (for example a disk
; cache writing), which the old edge count over 9 ticks could not. 0 when no retrace is seen.
measure:                        ; -> AX = Hz*10
        push ebx
        push ecx
        push edx
        push di
        pushf
        cli
        mov al,0x34
        out 0x43,al
        xor al,al
        out 0x40,al
        out 0x40,al
        popf
        call rdcnt
        mov [pprev],ax
        mov dword [pel],0
        mov word [vfrn],0
        call waitvr
        jc .z
        mov di,vfr
        mov eax,[pel]
        mov [di],eax
        mov cx,30
.l:     call waitvr
        jc .z
        add di,4
        mov eax,[pel]
        mov [di],eax
        loop .l
        mov word [vfrn],31
        call vframes
        call vmedian
        or eax,eax
        jz .z
        mov ecx,eax
        mov eax,11931820
        xor edx,edx
        div ecx
        jmp .x
.z:     VS 'D:FRM timeout',13,10
        xor eax,eax
.x:     cmp byte [vflag],1              ; /V keeps mode 2 for its call timing (vdone restores)
        je .r
        pushf
        cli
        push ax
        mov al,0x36                     ; ch0 back to mode 3
        out 0x43,al
        xor al,al
        out 0x40,al
        out 0x40,al
        pop ax
        popf
.r:     pop di
        pop edx
        pop ecx
        pop ebx
        ret
rdcnt:  xor al,al               ; latch channel 0 -> AX
        out 0x43,al
        in al,0x40
        mov ah,al
        in al,0x40
        xchg al,ah
        ret
pupd:   push ax                 ; add the PIT counts since the last call to [pel] and [pwt]
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
waitvr: push dx                 ; wait for the start of vertical retrace, CF on timeout (~0.25 s)
        push ax
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
        pop ax
        pop dx
        clc
        ret
.t:     pop ax
        pop dx
        stc
        ret

; Select 64 KB bank SI in window A through VBE 4F05.
setbank:                        ; SI = bank
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

; Write a hashed pattern (address * 9E3779B1h) to banks 0-4 through A000 and read it back.
; [errs] counts the mismatching dwords; expect 0.
verify: mov dword [errs],0
        push es
        mov ax,0xA000
        mov es,ax
        xor si,si
.wb:    call setbank
        xor di,di
        mov cx,16384
.w:     movzx eax,di
        mov edx,esi
        shl edx,16
        or eax,edx
        imul eax,eax,0x9E3779B1
        stosd
        loop .w
        inc si
        cmp si,5
        jb .wb
        xor si,si
.rb:    call setbank
        xor di,di
        mov cx,16384
.r:     movzx eax,di
        mov edx,esi
        shl edx,16
        or eax,edx
        imul eax,eax,0x9E3779B1
        cmp eax,[es:di]
        je .ok
        inc dword [cs:errs]
.ok:    add di,4
        loop .r
        inc si
        cmp si,5
        jb .rb
        pop es
        ret

; Banked write speed: fill banks 0-4 with rep stosd repeatedly for about 2 s (36 ticks).
; [kbs] = KB written per second.
bench:  push es
        xor ax,ax
        mov es,ax
        mov bx,[es:0x46C]
.sy:    cmp bx,[es:0x46C]
        je .sy
        mov bx,[es:0x46C]
        add bx,36               ; ~2 s
        xor ebp,ebp
.l:     xor si,si
.b:     call setbank
        push es
        mov ax,0xA000
        mov es,ax
        xor di,di
        mov cx,16384
        mov eax,0x1F1F1F1F
        rep stosd
        pop es
        inc ebp
        inc si
        cmp si,5
        jb .b
        cmp bx,[es:0x46C]
        jne .l
        pop es
        mov eax,ebp             ; KB/s = blocks*64*18.2065/36
        mov ebx,1165217
        mul ebx
        mov ebx,36000
        div ebx
        mov [kbs],eax
        ret

; Test categories: every result line starts with one (5 columns): the standard the expected values
; come from (IBM CGA/EGA/VGA BIOS, VESA VBE), the S3 chip, or the ROM image itself. The summary
; counts the lines per category.
NCAT    equ 7
catnames db 'ROM  MDA  CGA  EGA  VGA  VBE  S3   '

; AL = 0 pass, 1 fail, 2 info: count it for the category at the start of the current line (lst)
ccount: pusha
        push es
        push ds
        pop es
        movzx bx,al
        shl bx,1
        xor cx,cx
.c:     mov si,cx
        imul si,si,5
        add si,catnames
        mov di,[lst]
        push cx
        mov cx,3
        repe cmpsb
        pop cx
        je .f
        inc cx
        cmp cx,NCAT
        jb .c
        jmp .x                          ; no category (cannot happen)
.f:     imul si,cx,6
        add si,bx
        inc word [catcnt+si]
.x:     mov ax,[bp_]                    ; the next line starts after this one
        add ax,8                        ; (the result text and CR LF follow)
        mov [lst],ax
        pop es
        popa
        ret

; mode [m_mode] -> its category printed: 07h/0Fh MDA, 00h-06h CGA, 0Dh-10h EGA, other VGA modes VGA,
; VESA modes (100h and up) VBE
mcat:   pusha
        mov ax,[m_mode]
        mov si,5                        ; VBE
        cmp ax,0x100
        jae .p
        and al,0x7F
        mov si,1                        ; MDA
        cmp al,0x07
        je .p
        cmp al,0x0F
        je .p
        mov si,2                        ; CGA
        cmp al,0x06
        jbe .p
        mov si,3                        ; EGA
        cmp al,0x0D
        jb .v
        cmp al,0x10
        jbe .p
.v:     mov si,4                        ; VGA
.p:     imul si,si,5
        add si,catnames
        push es
        push ds
        pop es
        mov di,[bp_]
        mov cx,5
        rep movsb
        pop es
        mov [bp_],di
        popa
        ret

; Summary by category, one line each with its counts ("VGA  PASS 12  FAIL 0  INFO 1")
catsum: xor cx,cx
.l:     mov bx,cx
        imul bx,bx,6
        mov ax,[catcnt+bx]
        or ax,[catcnt+bx+2]
        or ax,[catcnt+bx+4]
        jz .n
        push cx
        mov si,cx
        imul si,si,5
        add si,catnames
        push es
        push ds
        pop es
        mov di,[bp_]
        mov cx,5
        rep movsb
        pop es
        mov [bp_],di
        mov dx,s_cp
        call puts
        movzx eax,word [catcnt+bx]
        call pdec
        mov dx,s_cf
        call puts
        movzx eax,word [catcnt+bx+2]
        call pdec
        mov dx,s_ci
        call puts
        movzx eax,word [catcnt+bx+4]
        call pdec
        mov dx,s_sum3
        call puts
        pop cx
.n:     inc cx
        cmp cx,NCAT
        jb .l
        ret

; Print PASS (AL=1) or FAIL (AL=0) and count it.
result: push ax                 ; AL=1 pass
        push ax
        xor al,1                        ; ccount: 0 pass, 1 fail
        call ccount
        pop ax
        or al,al
        jz .f
        inc word [npass]
        mov dx,s_pass
        jmp .p
.f:     inc word [nfail]
        mov dx,s_fail
.p:     call puts
        cmp byte [vflag],1              ; /V: copy the result line, register dump, flush
        jne .nv
        pusha
        mov si,[vls]
        mov cx,[bp_]
        sub cx,si
        call vcopy
        mov ax,[bp_]
        mov [vls],ax
        popa
        call vregs
        call vflush
.nv:    pop ax
        ret

; Output helpers: everything goes to the buffer obuf, written to stdout at the end.
putc:   push di                 ; AL -> buffer
        mov di,[bp_]
        mov [di],al
        inc word [bp_]
        pop di
        ret
puts:   push si                 ; DX -> '$' string
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
pdec:   push ebx                ; EAX unsigned
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
        ret
; Run time from the BIOS tick (0040:006C, 18.2 per second; a tick that falls inside a long CLI is lost).
; tickrd: EAX = the tick count. runtime: prints the time since [runt0] as "x.y s" (midnight handled).
tickrd: push es
        xor ax,ax
        mov es,ax
        pushf
        cli
        mov eax,[es:0x46C]
        popf
        pop es
        ret
runtime:
        push edx
        push ecx
        call tickrd
        sub eax,[runt0]
        jae .p
        add eax,0x1800B0                ; past midnight: ticks per day
.p:     mov ecx,655360                  ; tenths of a second: ticks * 10 * 65536 / 1193182
        mul ecx
        mov ecx,1193182
        div ecx
        call pdec10
        pop ecx
        pop edx
        ret

pdec10: push edx                ; EAX = value*10 -> "x.y"
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
        ret

; /V debug log (shared with VSHOW and S3COMPAT)
%include "vdebug.inc"

; Modes tested by t_mode: mode, expected refresh in tenths of Hz, check flags, horizontal
; resolution, expected total line length in pixels (0 = not checked).
; The expected refresh values are the rates set by the p4b-p9 timing changes and the unchanged
; stock rates (70 Hz text/320x200, 72 Hz 400x300). The line lengths are the VGA totals and the
; VESA DMT totals (see the file header); stock has 792/796 pixels in 640x480, 416 in 320x240 and
; 1696/2112 in the interlaced 1280x1024 and the 97.9 Hz 1600x1200.
modelist:
        dw 0x0003,700,F_VGA,720,900
        dw 0x0013,700,F_VGA,320,400
        dw 0x0012,597,F_VGA,640,800
        dw 0x012E,700,F_BOOST,320,400     ; 320x200x8
        dw 0x0131,597,F_BOOST,320,400     ; 320x240x8  (p4b)
        dw 0x0133,597,F_BOOST,320,400     ; 320x240x16 (p5/p6)
        dw 0x0101,597,F_BOOST,640,800     ; 640x480x8  (p6 800-px line)
        dw 0x4101,597,F_LFB,640,800
        dw 0x0111,597,F_BOOST,640,800     ; 640x480x16 (p6)
        dw 0x0141,722,F_BOOST,400,0       ; 400x300x8  (unchanged 72 Hz)
        dw 0x0103,603,F_BOOST,800,1056    ; 800x600x8
        dw 0x4103,603,F_LFB,800,1056
        dw 0x0105,601,F_BOOST,1024,1344   ; 1024x768x8
        dw 0x0106,602,0,1280,1688         ; 1280x1024x4 (p9: DMT 60 Hz, 108.4 MHz)
        dw 0x0107,602,F_BOOST,1280,1688   ; 1280x1024x8 (p6 60 Hz, DMT)
        dw 0x0120,600,F_BOOST,1600,2160   ; 1600x1200x8 (p6 60 Hz)
        dw 0x0003,700,F_VGA,720,900       ; back to text: FIFO fix, base restore
        dw 0x0013,700,F_VGA,320,400
        dw 0xFFFF

s_vname db 'S3TEST.DBG',0
s_vnomem db '/V: not enough memory for the debug buffer, /V ignored.',13,10,'$'
s_title db 'S3TEST ',VERSION,' - Trio64V2/DX VBIOS ',ROMVER,' test suite',13,10
        db 'Category column: ROM (image), CGA EGA VGA (IBM BIOS standards), VBE (VESA), S3 (chip).',13,10,13,10,'$'
s_romver db ROMVER
ROMVLEN equ $-s_romver
s_sig   db 'ROM  ROM signature ',ROMVER,' ............ $'
s_nover db '(no version string)$'
s_cks   db 'ROM  ROM checksum (C000:0000-7FFF) = $'
s_chip  db 'S3   Chip ID CR2D 2E 2F 30, PCI rev ...... $'
s_pci   db ', PCI $'
s_na    db 'n/a$'
s_info  db '  INFO',13,10,'$'
s_mclk  db 'S3   MCLK SR10 SR11 (42 41 = 59.96 MHz) .. $'
s_edo   db 'S3   CR36 memory type (bits 3-2 = 00 EDO)  $'
s_ped   db 'S3   SR1A pedestal off, bit 4 set ........ $'
s_ref   db 'S3   Refresh defaults CR41 CR52 (88 x1) .. $'
s_mode  db 'Mode $'
s_st    db ' st $'
s_hz    db ' Hz $'
s_exp   db ' (exp $'
s_line  db ') line $'
s_regs  db ') CR58 59 5A 6D 90 SR1A: $'
s_f03   db 'VBE  4F03 in boosted 101h (0101) ......... $'
s_f03l  db 'VBE  4F03 in linear 4101h (4101) ......... $'
s_f01   db 'VBE  4F01 PhysBasePtr = real base ........ $'
s_0000  db '0000$'
s_f05   db 'VBE  4F05 set bank 3 / get (004F 0003) ... $'
s_dat   db 'VBE  Banked data check 320 KB, errors .... $'
s_thr   db 'VBE  Banked write throughput (>=60000) ... $'
s_kbs   db ' KB/s$'
s_f06   db 'VBE  4F06 BL=3 max line 101h (4368/4368) $'
s_c50   db 'S3   CR50 in 512x384x8 151h (40) ........ $'
s_ff    db 'VGA  ATC flip-flop reset by mode set ..... $'
s_vclr  db 'VGA  VGA mode set clear 13h 12h 03h ..... $'
s_font  db 'EGA  Font load 8x16 and 8x8 in plane 2 .. $'
s_scr   db 'VGA  Mode 13h scroll AH=06h/07h data .... $'
s_txs   db 'CGA  Text scroll AH=06h/07h cells ....... $'
s_ah09  db 'CGA  AH=09h text char/attribute count ... $'
s_pls   db 'EGA  Planar scroll 12h/0Dh AH=06h/07h ... $'
s_pl6a  db 'S3   Planar scroll S3 6Ah AH=06h/07h .... $'
s_bank  db 'VBE  4F05 regs, SR index, CR6A, planar, LFB $'
s_t03   db 'CGA  Time: mode set 03h (ms) ............ $'
s_t101  db 'VBE  Time: 4F02 101h with clear (ms) .... $'
s_t05   db 'VBE  Time: 4F05 set window (us) ......... $'
s_tscr  db 'VGA  Time: mode 13h scroll AH=06h (ms) .. $'
s_ttcl  db 'CGA  Time: text clear AH=06h AL=0 (ms) .. $'
s_tpcl  db 'VGA  Time: mode 12h clear AH=06h AL=0 (ms) $'
s_tinfo db '  INFO',13,10,'$'
s_pass  db '  PASS',13,10,'$'
s_fail  db '  FAIL',13,10,'$'
s_sum1  db 13,10,'Passed: $'
s_sum2  db '  Failed: $'
s_sum3  db 13,10,'$'
s_cp    db 'PASS $'
s_cf    db '  FAIL $'
s_ci    db '  INFO $'
s_help  db 'S3TEST ',VERSION,' - regression test for the Trio64V2/DX VBIOS ',ROMVER,13,10
        db '  S3TEST [/V] > S3TEST.LOG',13,10
        db '  /V                  debug log in S3TEST.DBG (BIOS calls, registers, timing)',13,10
        db '  /H, /?              this help',13,10
        db 'Exit code 0 = every test passed, 1 = at least one failed.',13,10
        db 'Monitor: the modes reach a 75 kHz line frequency (1600x1200 at 60 Hz). An LCD shows',13,10
        db 'out of range and takes no harm; an old fixed-frequency or low-end CRT can be damaged',13,10
        db 'by a line frequency above its range: do not use one.',13,10,'$'
s_sum4  db 'Time spent: $'
s_sum5  db ' s',13,10,'$'

npass   dw 0
lst     dw 0                            ; start of the current result line in obuf
catcnt  times 7*3 dw 0                  ; per category: PASS, FAIL, INFO
vls     dw 0                    ; /V: start of the current line in obuf
nfail   dw 0
bp_     dw 0
m_mode  dw 0
m_hz    dw 0
m_flags dw 0
m_xres  dw 0
m_line  dw 0
m_lmeas dw 0
m_lrem  dw 0
m_st    dw 0
m_meas  dw 0
tmp     dw 0
tmp2    dw 0
tmin    dd 0
runt0   dd 0                            ; BIOS tick at the start
plbpl   dw 0                            ; planar scroll test: bytes per line, character height, lines
plchh   dw 0
pllines dw 0
plp     db 0                            ; plane
tst     dd 0
errs    dd 0
pel     dd 0
pwt     dd 0
pprev   dw 0
kbs     dd 0
r58     db 0
r59     db 0
r5a     db 0
r6d     db 0
base    db 0                    ; CR59 at POST: the real LFB base (bits 31-24)
r90     db 0
r1a     db 0
mibuf   times 256 db 0
obuf:
