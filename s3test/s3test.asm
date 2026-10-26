; S3TEST.COM - regression test for the patched Trio64V2/DX VBIOS (386+)
; The tool version (VERSION) and the ROM version it expects (ROMVER) come from common/version.inc.
;
; Purpose
;   Confirms that every change made to the stock 2.04.11 ROM is present and working. It is the
;   quick check to run after flashing a new ROM version. S3COMPAT is the broad compatibility test.
;
; Usage
;   S3TEST [/V] > S3TEST.LOG
;   /V  debug log in S3TEST.DBG (common/vdebug.inc): every INT 10h call (except during the throughput
;       benchmark), the result line, a register dump after every test and the raw retrace counts.
;       The normal output is the same with or without /V.
;   Output is buffered while the video modes switch and written to stdout at the end.
;   Exit code 0 = every test passed, 1 = at least one failed.
;
; Tests and expected outcomes (each line ends in PASS or FAIL)
;   ROM signature    the first 256 bytes of C000 contain ROMVER (now "2.04.11-p9")
;   ROM checksum     bytes C000:0000-7FFF add up to 00
;   MCLK             SR10 = 42h, SR11 = 41h after POST: 59.96 MHz memory clock
;   Memory type      CR36 bits 3-2 = 00: the RAM is still run as 1-cycle EDO
;   Pedestal         SR1A bit 5 = 0 (no blank pedestal, deepest black) and bit 4 = 1
;   Refresh defaults CR41 bits 7-5 = 100b and CR52 bits 2-0 = 001b: 1280x1024 and 1600x1200
;                    default to 60 Hz
;   Each mode in modelist: the mode set returns 004Fh, the measured refresh is within 1.5 Hz of
;                    the expected value, the pedestal is still off, and depending on the mode type:
;                    VGA (F_VGA)       linear addressing off, CR90 bit 7 = 0 (FIFO fix), and the
;                                      real frame buffer base back in CR59 after the booster
;                    banked (F_BOOST)  booster active: CR58 linear addressing on with a 64 KB
;                                      window, CR59/CR5A = 000Ah, real base saved in CR6D
;                    linear (F_LFB)    linear addressing on, window 1 MB or larger, CR59 = CR6D
;                    no flag           only status, refresh and pedestal (106h, planar)
;   4F03 in boosted 101h reports 0101h (no linear bit although CR58 has LA on)
;   4F01 PhysBasePtr equals CR6D << 24 (the real base, not the booster's 000A0000h)
;   4F05 set bank 3, then get bank: 004Fh and 3
;   320 KB written through banks 0-4 and read back: 0 errors
;   Banked write throughput at least 60000 KB/s (the booster; 83700 KB/s measured on p7)
;   4F03 in 4101h reports 4101h
;   4F06 BL=3 in 101h: 4368 bytes and 4368 pixels (2 MB / 480 lines, rounded down to 8)
;   CR50 in 151h (512x384x8) = 40h (pixel length 00, was the reserved 10b in stock)
;   ATC flip-flop: left in the data state before a mode set, it is back in the index state after
;
bits 16
org 0x100
%include "version.inc"
%include "vdebug.mac"
F_VGA   equ 1
F_BOOST equ 2
F_LFB   equ 4

start:  cld
        mov word [bp_],obuf
        mov si,0x81                     ; /V: debug log in S3TEST.DBG
.op:    lodsb
        cmp al,13
        je .opd
        cmp al,'/'
        jne .op
        lodsb
        and al,0xDF
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
.opd:   mov dx,s_title
        call puts
        mov ax,[bp_]
        mov [vls],ax
        call t_rom
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
        push si
        call t_mode
        pop si
        jmp .ml
.mld:   call t_func
        call t_ff
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
; Expect: signature ROMVER (now "2.04.11-p9") within C000:0000-00FF, and an 8-bit checksum of 00 over the
; lower 32 KB (the half the VGA BIOS runs from).
t_rom:  mov dx,s_sig
        call puts
        push ds
        mov ax,0xC000
        mov ds,ax
        xor si,si
        mov cx,0x100
.f:     cmp dword [si],'2.04'
        je .fv
        inc si
        loop .f
        pop ds
        mov dx,s_nover
        call puts
        xor al,al
        call result
        jmp .ck
.fv:    mov bx,si                       ; print the version found, up to the line end
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

; ---------------- POST state ----------------
; Read the registers the BIOS set at boot, before any mode set by this program.
; Expect: SR10/SR11 = 42h/41h (59.96 MHz MCLK), CR36 bits 3-2 = 00 (1-cycle EDO),
; SR1A & 30h = 10h (pedestal off), CR41 bits 7-5 = 100b and CR52 bits 2-0 = 001b (60 Hz defaults).
t_post: call unlock
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
; CR58, CR59, CR5A, CR6D, CR90 and SR1A. Expect status 004Fh, refresh within 15 (1.5 Hz) of
; [m_hz], SR1A bit 5 clear, plus the checks selected by [m_flags] (see the file header).
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
        mov dx,s_regs
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
        mov ax,[m_flags]
        test al,F_VGA
        jz .nv
        test byte [r58],0x10
        jnz .fail
        test byte [r90],0x80    ; FIFO fix
        jnz .fail
        mov al,[r59]
        cmp al,0
        je .fail
        cmp al,[r6d]            ; real base restored (if booster ran before)
        je .ok
        cmp byte [r6d],0
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
        cmp al,[r6d]
        jne .fail
.ok:    mov al,1
        jmp .res
.fail:  xor al,al
.res:   call result
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
        ; 4F01 PhysBasePtr == CR6D<<24
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
        movzx ebx,byte [r6d]
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
        jne .f6
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

; Print PASS (AL=1) or FAIL (AL=0) and count it.
result: push ax                 ; AL=1 pass
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

; mode, expected Hz*10, flags

; Modes tested by t_mode: mode, expected refresh in tenths of Hz, check flags.
; The expected values are the rates set by the p4b-p9 timing changes and the unchanged stock
; rates (70 Hz text/320x200, 72 Hz 400x300).
modelist:
        dw 0x0003,700,F_VGA
        dw 0x0013,700,F_VGA
        dw 0x0012,597,F_VGA
        dw 0x012E,700,F_BOOST     ; 320x200x8
        dw 0x0131,597,F_BOOST     ; 320x240x8  (p4b)
        dw 0x0133,597,F_BOOST     ; 320x240x16 (p5/p6)
        dw 0x0101,597,F_BOOST     ; 640x480x8  (p6 800-px line)
        dw 0x4101,597,F_LFB
        dw 0x0111,597,F_BOOST     ; 640x480x16 (p6)
        dw 0x0141,722,F_BOOST     ; 400x300x8  (unchanged 72 Hz)
        dw 0x0103,603,F_BOOST     ; 800x600x8
        dw 0x4103,603,F_LFB
        dw 0x0105,601,F_BOOST     ; 1024x768x8
        dw 0x0106,602,0           ; 1280x1024x4 (p9: DMT 60 Hz, 108.4 MHz)
        dw 0x0107,602,F_BOOST     ; 1280x1024x8 (p6 60 Hz, DMT)
        dw 0x0120,600,F_BOOST     ; 1600x1200x8 (p6 60 Hz)
        dw 0x0003,700,F_VGA       ; back to text: FIFO fix, base restore
        dw 0x0013,700,F_VGA
        dw 0xFFFF

s_vname db 'S3TEST.DBG',0
s_vnomem db '/V: not enough memory for the debug buffer, /V ignored.',13,10,'$'
s_title db 'S3TEST ',VERSION,' - Trio64V2/DX VBIOS ',ROMVER,' test suite',13,10,13,10,'$'
s_romver db ROMVER
ROMVLEN equ $-s_romver
s_sig   db 'ROM signature ',ROMVER,' ............ $'
s_nover db '(no version string)$'
s_cks   db 'ROM checksum (C000:0000-7FFF) = $'
s_mclk  db 'MCLK SR10 SR11 (42 41 = 59.96 MHz) .. $'
s_edo   db 'CR36 memory type (bits 3-2 = 00 EDO)  $'
s_ped   db 'SR1A pedestal off, bit 4 set ........ $'
s_ref   db 'Refresh defaults CR41 CR52 (88 x1) .. $'
s_mode  db 'Mode $'
s_st    db ' st $'
s_hz    db ' Hz $'
s_exp   db ' (exp $'
s_regs  db ') CR58 59 5A 6D 90 SR1A: $'
s_f03   db '4F03 in boosted 101h (0101) ......... $'
s_f03l  db '4F03 in linear 4101h (4101) ......... $'
s_f01   db '4F01 PhysBasePtr = CR6D<<24 ......... $'
s_0000  db '0000$'
s_f05   db '4F05 set bank 3 / get (004F 0003) ... $'
s_dat   db 'Banked data check 320 KB, errors .... $'
s_thr   db 'Banked write throughput (>=60000) ... $'
s_kbs   db ' KB/s$'
s_f06   db '4F06 BL=3 max line 101h (4368/4368) $'
s_c50   db 'CR50 in 512x384x8 151h (40) ........ $'
s_ff    db 'ATC flip-flop reset by mode set ..... $'
s_pass  db '  PASS',13,10,'$'
s_fail  db '  FAIL',13,10,'$'
s_sum1  db 13,10,'Passed: $'
s_sum2  db '  Failed: $'
s_sum3  db 13,10,'$'

npass   dw 0
vls     dw 0                    ; /V: start of the current line in obuf
nfail   dw 0
bp_     dw 0
m_mode  dw 0
m_hz    dw 0
m_flags dw 0
m_st    dw 0
m_meas  dw 0
tmp     dw 0
tmp2    dw 0
errs    dd 0
pel     dd 0
pwt     dd 0
pprev   dw 0
kbs     dd 0
r58     db 0
r59     db 0
r5a     db 0
r6d     db 0
r90     db 0
r1a     db 0
mibuf   times 256 db 0
obuf:
