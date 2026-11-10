; S3COMPAT.COM - VGA / SVGA / VESA compatibility test for Trio64-family video BIOSes (386+)
;
; Purpose
;   Tests the video BIOS, not the chip: does every standard VGA mode and BIOS function behave like the
;   IBM VGA BIOS, does every VESA mode the BIOS lists work banked and linear, and are the registers the
;   BIOS programs inside the limits of the chip (Trio32, Trio64, Trio64V+, Trio64UV+ or
;   Trio64V2/DX/GX, found through PCI by src/tools/common/chip.inc, which holds each chip's VCO range, DCLK and
;   MCLK maxima and their sources; docs/chip-rules.md lists every rule). Test ideas follow VGATEST (PC Tech Journal 1988), SVGATEST, VBETest and X-VESA.
;
; Usage
;   S3COMPAT [/Q] [/V] [/B] [/N s] [/U] > S3COMPAT.LOG
;   S3COMPAT /H (or /?) prints the parameters and the monitor note below.
;   /S  silent: no start notice and monitor warning on stderr, no key press (for batch runs).
;   /Q  skip the 2 MB VRAM test   (to look at a mode on the screen, use VSHOW)
;   /B  set CR31 bit 2 (the 16-bit VGA bus, spec-b MQ-8 of #200) for the whole run, so the planar
;       sections 0Dh-12h run with the bit set; cleanup puts it back before the mode 03 comparison
;   /N s retention check (spec-b MQ-5 of #200): after the VRAM test, the pattern is written, the
;       card left alone for s seconds (1-60, the mode stays up) and the pattern verified;
;       without /N a SKIP line
;   /U  SR18 bit 6 stress (spec-a Q7 of #200): in 101h the VRAM pattern is written once, then for
;       SR18 bit 6 cleared and set a burst of 64 palette loads runs and the pattern is verified;
;       without /U a SKIP line
;   /V  debug log in S3COMPAT.DBG (src/tools/common/vdebug.inc): the NASM version that assembled this
;       tool (D:ENV NASM=), the ROM version (D:ENV ROM=), every INT 10h call with registers and duration,
;       a register dump and the result line after every test, 4F00/4F01/AH=1Bh blocks, per-frame
;       timer counts, memory mismatches. The normal log is the same with or without /V. Needs 64 KB
;       more memory and runs longer (the debug file is committed before every mode set).
;   A notice on stderr says the run takes about 3 minutes; a key starts it, Esc cancels.
;   When stdout is a file, every test line is written and committed (INT 21h AH=68h) before the next
;   test starts, so after a freeze the last line in the log is the test that hung.
;   Exit code 0 = no FAIL, 1 = at least one FAIL.
;   Every test or step left out prints a line with its name, "SKIP:" and the reason, not counted as a
;   result; the summary line counts them ("Skipped: N"): the SR1A and subsystem ID lines on chips other
;   than the Trio64V2, the 8x14 glyph checks when the ROM has no 8x14 font (Trio64V2 2.04.07: the
;   8x16 font is checked instead), the VRAM test with /Q, once before the VGA mode lines the CR90 bit 7
;   check on chips other than the Trio64V2 (#72), once before the VESA mode lines the register rules of
;   the other chips (registers this chip does not have), and the banked window/LFB cross check when 4F01
;   offers 101h no LFB (VBE 1.x, #73).
;
; Result lines
;   <test name> ... <details>  PASS | FAIL xxxx | WARN xx | INFO
;   FAIL/WARN carry a bit mask per test, explained at the routine and in the log header. Detail lines
;   show REG=actual(expected), masked to the bits under test. INFO lines report without judging.
;   DAC checks (the default DAC of every VGA mode, AX=101Bh): a wrong entry is read a second time and
;   then the BIOS call is made again; only a value wrong on all three reads is a FAIL. Wrong once is
;   WARN 02 (right on the second read) or WARN 04 (right after the call again), printed as
;   "DAC#xx=rr,gg,bb exp rr,gg,bb" and the outcome; the 86C775 card had one such byte in some runs.
;   Monitor: the test sets line frequencies up to 91 kHz (1280x1024 at 85 Hz, 4F14 refresh test) and
;   75 kHz (1600x1200 at 60 Hz), and the DPMS test stops the syncs for a moment. LCDs refuse what they
;   cannot show; an old fixed-frequency or low-end CRT can be damaged by a line frequency above its
;   range. The start notice on stderr says so and waits for a key (Esc cancels); /S skips both, and
;   the /H help says so too.
;   The last line, "Time spent: x.y s", is the run time from the key press on, from the BIOS tick
;   (with /V it includes writing the debug log, so it is the one line that differs without /V).
;
; Run order and expected outcome on the p9 ROM (219 pass, 0 fail, 4 warn on p8 before the 350-line
; and palette additions; the four warnings are known stock items)
;   1. ROM version string                      INFO
;      Chip ID (CR2D-CR30, PCI, S3 part)        INFO (89 01 06 E1, PCI 8901 rev 06 Trio64V2/DX
;                                                   86C775 on the test card; /GX 86C785 when CR6F
;                                                   bit 0 is set)
;   2. POST: MCLK PLL and memory type           PASS (50.11 MHz, VCO in 135-270 MHz, 1-cycle EDO
;      limit 60 MHz)
;      SR1A bit 4 set at POST (Trio64V2 only)   PASS
;      PCI subsystem ID from the ROM (Trio64V2)  PASS (ROM 40h = CR81-84 = PCI 2Ch, CR37 bit 2 = 0)
;   3. Initial state, setup                     INFO, PASS (mode 03, baseline, VRAM zeroed)
;   4. VGA modes 00h-13h and the 350-line text modes against the IBM reference
;                                               PASS; mode 10h WARN 01 (8x16 font used, 8x14 missing)
;   5. Mode X family and 80x50 text             PASS
;   6. VGA BIOS functions (cursor .. AH=1B)     PASS; AX=1130 BH=2 WARN 01 (8x14 font missing)
;      More: AH=13h write string, CGA graphics scroll 04h/06h, AH=09h/0Ah glyphs and XOR in 04h, 06h,
;      0Dh, 12h, AX=1120h-1124h, the video save pointer table (dynamic save area, alphanumeric and
;      graphics character set overrides)    PASS; AX=1120-1124 WARN 01 (1122h: no 8x14 font)
;   7. VESA global (4F00, 4F08, 4F04, 4F0A)     PASS
;   8. Every VESA mode, banked and linear       PASS; 106h WARN 02 (108 MHz above the 95 MHz
;                                               datasheet single-clock limit, works on the card);
;                                               4104 WARN 20 (LFB offered on a planar mode, stock)
;   9. S3 modes via AH=00 vs the same via 4F02   PASS
;  10. VESA functions (4F01-4F09, VRAM, LFB)     PASS
;      Bench observations (#200): the 4F07 display start near the end of memory (spec-c 11) and the
;      planar 102h pages past 256 KB/plane (spec-c 4) always run; the SR18 bit 6 palette load stress
;      (spec-a Q7) with /U and the retention check (spec-b MQ-5) with /N, a SKIP line without
;      More VBE: 4F00 capabilities vs 4F08, 4F04 per state mask, invalid subfunctions refused,
;      undefined functions 4F0B-4F1F refused, 4F0A table layout, 4F10 DPMS states (the monitor
;      sees the syncs stop for a moment), 4F15 DDC EDID, 4F14 S3 OEM functions (query, mode list
;      and resolutions, refresh control with every rate of 101h-107h measured; the monitor sees each
;      rate)
;                                               PASS; 4F15 INFO without DDC2, WARN 01 when the
;                                               monitor gives no EDID
;  11. Pass 2: VGA modes right after VESA modes  as step 4 (leftover state must not matter)
;  12. Cleanup: mode 03 vs the baseline          PASS, VRAM zeroed, the DOS screen restored
;
; Reference data (vgaref.inc): IBM register values and AH=1Bh state blocks per VGA mode, and IBM's
; default 256-colour DAC, from the VGATEST tables; the 350-line entries from the IBM parameter table.
bits 16
cpu 386
org 0x100
%include "version.inc"

%include "vdebug.mac"
%macro PS 1+
        call ps
        db %1,0
%endmacro
; Test categories, printed in front of every result line and counted for the summary by category:
; the standard the expected values come from (IBM MDA/CGA/EGA/VGA BIOS, VESA VBE) or the S3 chip.
C_MDA   equ 0
C_CGA   equ 1
C_EGA   equ 2
C_VGA   equ 3
C_VBE   equ 4
C_S3    equ 5
NCAT    equ 6
%macro TB 2+                            ; category, title
        mov byte [tcat],%1
        call tbegin
        db %2,0
%endmacro
%macro SKIPL 3                          ; category, line text, reason: a test or step this card does not get
        mov byte [tcat],%1
        call tskip
        db %2,0
        db %3,0
%endmacro
%macro TBK 1+                           ; title; the category is already in [tcat]
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
        cmp al,'?'
        je .hlp
        and al,0xDF
        cmp al,'H'
        je .hlp
        cmp al,'S'
        jne .o2
        mov byte [silent],1
.o2:    cmp al,'Q'
        jne .o3
        mov byte [quick],1
.o3:    cmp al,'V'
        jne .o4
        mov byte [vreq],1
        jmp .op
.o4:    cmp al,'B'
        jne .o5
        mov byte [busbit],1
        jmp .op
.o5:    cmp al,'U'
        jne .o6
        mov byte [lutsw],1
        jmp .op
.o6:    cmp al,'N'
        jne .op
        mov byte [retsw],1
.ns:    lodsb                           ; the number, after any spaces
        cmp al,' '
        je .ns
        dec si
        xor bx,bx
        xor cx,cx
.nd:    lodsb
        cmp al,'0'
        jb .ne
        cmp al,'9'
        ja .ne
        imul bx,bx,10
        sub al,'0'
        movzx ax,al
        add bx,ax
        inc cx
        cmp cx,2
        ja .nbad
        jmp .nd
.ne:    dec si
        or cl,cl
        jz .nbad
        or bx,bx
        jz .nbad
        cmp bx,60
        ja .nbad
        mov [retsec],bx
        jmp .op
.nbad:  mov dx,s_badarg
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21
.hlp:   mov dx,s_help                   ; /H, /?: the parameters and the monitor note
        mov ah,9
        int 0x21
        mov ax,0x4C00
        int 0x21
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
        cmp byte [silent],1             ; /S: no notice, no key
        je .go
        mov dx,s_start                  ; notice and monitor warning on stderr (not redirected by >)
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
.go:    call tickrd                     ; run time from here (after the key)
        mov [runt0],eax
        cmp byte [vreq],1               ; /V: debug log in S3COMPAT.DBG (needs 64 KB more)
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
        call chipfind                   ; the chip and its datasheet limits (src/tools/common/chip.inc)
        PS 'S3COMPAT ',VERSION,' - VGA/SVGA/VESA compatibility test for Trio64-family video BIOSes',13,10
        PS 'Chip: '
        call chipname
        call psd
        PS ' '
        call chippart                   ; S3 part number (86C764X or 86C764-P by CR2F, 86C765, ...)
        call psd
        PS 13,10
        PS 'Category column: MDA CGA EGA VGA (IBM BIOS standards), VBE (VESA), S3 (chip).',13,10
        PS 'Values in detail lines: REG=actual(expected), masked to the bits under test.',13,10
        PS 'VGA fail bits: 1 regs vs IBM  2 BIOS data/AH=0F/AH=1B  4 S3 ext left on',13,10
        PS '  8 refresh  10 memory  20 default DAC (256/EGA/CGA)  40 refresh vs CRTC/PLL math',13,10
        PS 'VGA warn bits: 1 mode 10h without 8x14 font  2 DAC entry wrong once, right on a 2nd read',13,10
        PS '  4 DAC entry right after the mode set again (also AX=101B: warn 2/4, fail 1 = wrong 3 times)',13,10
        PS 'Mode xxh 350 = the mode at 350 scan lines (AH=12 BL=30 first).',13,10
        PS 'VESA fail bits: 1 4F01  2 window  4 layout  8 set/4F03  10 refresh  20 memory',13,10
        PS '  40 4F06  80 4F07/4F09  100 CRTC geometry vs 4F01  200 datasheet clock/colour',13,10
        PS '  400 refresh vs CRTC/PLL math  800 datasheet memory mapping (CR31/CR58-5A)',13,10
        PS '  1000 datasheet register rule (SR15 bit 5, CR66 bits 3/7, Trio64UV+ CR83, Trio64V2 CR32)',13,10
        PS 'Line info: measured kHz, H = total pixels per line (LCD clock setting), V = total lines.',13,10
        PS '16-colour VESA modes: memory bit 20 = separate pattern per plane at every bank.',13,10
        PS 'VESA warn bits: 1 refresh math factor 2  2 DCLK above datasheet max',13,10
        PS '  4 CR50 GE pixel length/width  10 interlace on  20 LFB on planar',13,10
        PS '  40 default refresh not the VESA DMT 60 Hz (70 Hz at 400 lines) rate',13,10
        PS '  8 DCLK VCO in the datasheet range, below [vcomin] (135 MHz on every chip: never)',13,10
        PS '  80 datasheet register rule not yet confirmed on a card (CR86; Trio64V2 CR90/CR91 L1)',13,10
        call bios_id
        call chip_id
        call setup
        call post_tests
        cmp byte [busbit],1              ; /B: CR31 bit 2 for the whole run, restored by cleanup
        jne .nb
        call cr31_bset
        PS 'CR31 bit 2 (16-bit VGA bus) set for this run (/B); cleanup restores it.',13,10
.nb:
        mov byte [pass],1
        PS 13,10,'--- VGA BIOS modes vs IBM reference tables (VGATEST, IBM parameter table) ---',13,10
        call vskips                     ; the CR90 check of the VGA lines: Trio64V2 only (#72)
        call vga_pass
        call modex_all
        PS 13,10,'--- VGA BIOS functions ---',13,10
        call bios_tests
        call bios_more
        PS 13,10,'--- VESA BIOS ---',13,10
        call vesa_global
        PS 13,10,'--- VESA modes (every listed mode, banked and linear) ---',13,10
        call rskips                     ; the register rules of other chips, named once
        call vesa_modes
        PS 13,10,'--- S3 SVGA modes via INT 10h AH=00 (same registers as the VESA set) ---',13,10
        call svga_modes
        PS 13,10,'--- VESA functions ---',13,10
        call vesa_func
        call vesa_more
        call bench_more                 ; the #200 bench observations
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
        PS '  Skipped: '                ; tests and steps not run on this card (SKIP lines)
        movzx eax,word [nskip]
        call pdec
        PS 13,10
        call catsum
        PS 'Time spent: '         ; run time (own line, so logs compare without it)
        call runtime
        PS ' s',13,10
        mov byte [tofile],1             ; console: buffer is printed now, in text mode
        call restore_screen             ; before the console write, so the summary lands below the old screen
        call flush                      ; AH=68h on the log when stdout is a file
        call vdone
        mov ah,0x0D                     ; SMARTDRV: the log and S3COMPAT.DBG
        int 0x21
        mov ax,0x4C00
        cmp word [nfail],0
        je .x
        mov al,1
.x:     int 0x21

; ======================================================================

; INFO: the sign-on version, via romfind (src/tools/common/romver.inc). Same scan as S3TEST's
; signature line, ROMVER and the /V log: "Version " in C000:0000-00FF, at most 12 characters.
; S3 BIOSes 1.x and 2.x sign on with 'Video BIOS. Version x.yy.zz'.
bios_id:
        PS 'ROM: '
        call romfind
        jc .no
        mov si,romvbuf
        mov cx,[romvlen]
        jcxz .nl
.p:     mov al,[cs:si]
        call putc
        inc si
        loop .p
.nl:    PS 13,10
        ret
.no:    PS '(version string not found)',13,10
        ret

; INFO: chip identification, so a log shows which stepping produced it. CR2D-CR30 and the S3 part
; come from src/tools/common/chip.inc (chipfind / chipidregs / chippart): on 8901h, CR6F bit 0 selects
; Trio64V2/DX 86C775 vs /GX 86C785 (V2-ID-1; S3's Windows 95 Trio INF lists one PCI 8901 row). The
; test card reads 89 01 06 E1, PCI 8901 rev 06 Trio64V2/DX 86C775. No pass or fail.
chip_id:
        TB C_S3,'Chip ID CR2D 2E 2F 30, PCI rev ...... '
        call chipfind                   ; refreshes PCI + chipidregs
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
        PS ', PCI '
        cmp byte [chip],CHIP_NONE       ; chipfind: 5333:8901, 8811 or 8814
        je .np
        mov ax,[chipdev]
        call phex4
        PS ' rev '
        mov al,[chiprev]
        call phex2
        call sp1
        call chipname
        call psd
        PS ' '
        call chippart
        call psd
        jmp .e
.np:    PS 'n/a'
.e:     mov byte [infoflag],1
        call tend
        ret

; POST state checked against the datasheet

; POST state against the datasheet (rule IDs from docs/chip-rules.md).
; MCLK line, fail bits:
;   1 MCLK PLL VCO outside the datasheet range, 135 MHz to [mvcomax] (270 MHz on every chip: the
;     Trio64V2 raises only the DCLK PLL maximum), or N = 0 or M = 0 (PLL-1, PLL-2)
;   2 MCLK above the chip's maximum (MEM-1): [mclkmax], 60 MHz (16.67 ns) on the Trio32 and
;     Trio64V+, 70 MHz on the Trio64 (T64-MEM-7), 66.67 MHz (15 ns) on the Trio64UV+; on the Trio64V2 by the memory type in CR36 bits
;     3-2 (V2-MEM-1): 00 1-cycle EDO 60 MHz (16.67 ns), 01 SGRAM, 10 2-cycle EDO and 11 fast page
;     66.67 MHz (15 ns). Which memory type a card should use is not a datasheet rule (S3TEST checks
;     the 1-cycle EDO of our card)
; warn bits:
;   1 SR10 bit 7 set: reserved on every chip; the Trio64V2 adds a third R bit for the DCLK PLL only
;     (SR12 bit 7, V2-PLL-3), so it is not taken as an R bit here
; SR1A line (Trio64V2 only), fail bit 1: SR1A bit 4 (FCTD) not set; the BIOS must set it upon reset
;   (Trio64V2 datasheet section 4.2, V2-REG-1)
; Subsystem ID line (Trio64V2 only, section 3.8, V2-PCI-1): the video BIOS copies the subsystem IDs
;   from ROM C000:0040-0043 to CR81-CR84, which PCI configuration 2Ch-2Fh mirrors, and clears CR37
;   bit 2 (until then the chip answers a PCI read of 2Ch by reading the ROM itself). Fail bits:
;   1 CR37 bit 2 still 1, 2 CR81-CR84 differ from the ROM bytes, 4 PCI 2Ch differs from the ROM bytes
post_tests:
        call unlock
        TB C_S3,'MCLK PLL (SR10/SR11) vs datasheet'
        call tdots
        RS 0x10
        mov [pn],al
        RS 0x11
        mov [pm],al
        mov al,[pn]
        and al,0x7F                     ; SR10 bit 7 is reserved, not an R bit (V2-PLL-3)
        mov ah,[pm]
        call pllcalc                    ; -> [vco],[fout] kHz
        PS 'MCLK '
        mov eax,[fout]
        call pkhz
        PS ' VCO '
        mov eax,[vco]
        call pkhz
        mov eax,[vcodsmin]
        cmp [vco],eax
        jb .f1
        mov eax,[mvcomax]
        cmp [vco],eax
        ja .f1
        test byte [pn],0x1F
        jz .f1
        test byte [pm],0x7F
        jz .f1
        jmp .c1
.f1:    FAILB 1
.c1:    test byte [pn],0x80             ; reserved bit set
        jz .c2
        WARNB 1
.c2:    RC 0x36
        mov [tmpb],al
        PS ' CR36='
        mov al,[tmpb]
        call phex2
        mov eax,[mclkmax]               ; the chip's maximum (MEM-1)
        cmp byte [chip],CHIP_T64V2      ; the memory type limits are the Trio64V2's (V2-MEM-1)
        jne .c3
        mov eax,60000                   ; 00 = 1-cycle EDO: MCLK cycle >= 16.67 ns
        test byte [tmpb],0x0C
        jz .c3
        mov eax,66667                   ; SGRAM, 2-cycle EDO, fast page: MCLK cycle >= 15 ns
.c3:    cmp [fout],eax
        jbe .ok
        FAILB 2
.ok:    call tend
        cmp byte [chip],CHIP_T64V2      ; SR1A exists on the Trio64V2 only
        je .s1a
        SKIPL C_S3,'SR1A bit 4 (FCTD) set at POST','SR1A is a Trio64V2 register'
        SKIPL C_S3,'PCI subsystem ID: ROM 40h, CR81-84','CR81-CR84 are Trio64V2 registers'
        jmp .x
.s1a:   call unlock
        TB C_S3,'SR1A bit 4 (FCTD) set at POST'
        call tdots
        RS 0x1A
        mov [tmpb],al
        PS 'SR1A='
        mov al,[tmpb]
        call phex2
        test byte [tmpb],0x10
        jnz .s1
        FAILB 1
.s1:    call tend
        call unlock
        TB C_S3,'PCI subsystem ID: ROM 40h, CR81-84'
        call tdots
        push es
        mov ax,0xC000
        mov es,ax
        mov eax,[es:0x40]
        pop es
        mov [subrom],eax
        mov si,subcr                    ; CR81-CR84 -> subcr, low byte first
        mov ah,0x81
.sc:    mov al,3
        push ax
        call readreg
        mov [si],al
        pop ax
        inc si
        inc ah
        cmp ah,0x85
        jb .sc
        mov ax,0xB10A                   ; PCI configuration dword 2Ch
        mov bx,[chipbx]
        mov di,0x2C
        int 0x1A
        mov [subpci],ecx
        RC 0x37
        mov [tmpb],al
        PS 'ROM '
        mov eax,[subrom]
        call phex8
        PS ' CR '
        mov eax,[subcr]
        call phex8
        PS ' PCI '
        mov eax,[subpci]
        call phex8
        PS ' CR37='
        mov al,[tmpb]
        call phex2
        test byte [tmpb],0x04
        jz .p1
        FAILB 1
.p1:    mov eax,[subrom]
        cmp eax,[subcr]
        je .p2
        FAILB 2
.p2:    cmp eax,[subpci]
        je .p3
        FAILB 4
.p3:    call tend
.x:     ret

phex8:  push eax                        ; print EAX as 8 hex digits
        shr eax,16
        call phex4
        pop eax
        push eax
        call phex4
        pop eax
        ret

; AL = SR12 (DCLK N and R) -> CF=1 when it holds a reserved R code: on the Trio64V2 ([r3bit]) bit 7 is
; the third R bit and only 100b (divide by 16) of the codes with bit 7 set is defined (Trio64V2
; datasheet section 3.6, V2-PLL-3). Keeps every register.
rcheck: cmp byte [r3bit],1
        jne .ok
        test al,0x80
        jz .ok
        test al,0x60
        jz .ok
        stc
        ret
.ok:    clc
        ret

; AL = N byte (SR10/SR12 style), AH = M byte -> [vco], [fout] in kHz

; PLL: f = 14.31818 MHz * (M+2) / ((N+2) * 2^R); R is 2 bits, plus bit 7 of the N byte on the Trio64V2.
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
        cmp byte [r3bit],1              ; bit 7 is R bit 2 on the Trio64V2 only
        jne .r
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

psd:    push si                         ; print the '$' string at DX to the log
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
        TB C_VGA,'Initial state: mode '
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
        TB C_VGA,'Setup: mode 03, baseline, VRAM zeroed'
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
        mov ax,[vbeinfo+4]              ; VBE version: the VBE 2.0 functions are tested from 2.0 on
        mov [vbever],ax
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
        call cr31_brestore              ; /B: CR31 back before the mode 03 comparison (state list)
        PS 13,10,'--- Final state ---',13,10
        TB C_VGA,'Mode 03 after all tests vs baseline'
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
        TB C_VGA,'Cleanup: VRAM zeroed, mode 03'
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

; All entries of vgaref: modes 00h-07h, 0Dh-0Fh, 10h-13h at 400/480 lines and modes 00h-03h at
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

prevesa dw 0x4101,0x0111,0x0105,0x0103,0x4111,0x0101,0x0112,0x0101,0x0107,0x4103,0x0101,0x0131,0x0133,0x0102,0x0120
        dw 0x0101,0x0105,0x4101,0x0111  ; idx 7 = 07h and idx 10 = 0Fh get 0101; then the four 350-line entries

; One VGA mode against the IBM reference. Fail bits:
;   1  MISC, FEAT, SR, CRTC, ATC or GR register differs from IBM (all 62, detail lines show which)
;   2  AH=1Bh state block differs from IBM (bit 4 of +2Dh ignored), or AH=0Fh mode/columns/page wrong
;   4  an S3 extension is still on (vgaext: clock select, CR31, CR58, CR67, CR51, CR43, CR5D, CR5E,
;      CR69, CR90 bit 7 in mode 13h only (Trio64V2; p25/#166; SKIP on other chips, #72), SR15, SR18)
;   8  measured refresh more than 1.5 Hz from the reference (70 Hz, 60 Hz for 11h/12h)
;   10 memory test of the mode's video memory failed
;   20 default DAC not loaded as IBM does: 256-colour table (13h), CGA palette (04h-06h, 0Dh, 0Eh),
;      EGA palette (all others, also in 350-line text); the same entry wrong on a second read and
;      again after the mode set is made a second time (dac_mode)
;   40 measured refresh does not match the rate predicted from the CRTC and clock registers
; Warn bit 1: mode 10h reports 21 rows / 16 lines in AH=1Bh because the 8x14 font is missing (known).
; Warn bit 2: a default DAC entry read wrong once, right on the second read (a port read glitch).
; Warn bit 4: a default DAC entry wrong on two reads, right after the mode set again (a DAC write
;   that did not land once). Neither is the BIOS's table: it loaded the right value the second time.
; The 350-line entries select 350 scan lines with AH=12h BL=30h AL=01h first and go back to 400 after.
; Expect PASS for every entry (WARN 01 for mode 10h).
vga_one:
        mov si,[ent]
        mov al,[si]
        call modecat
        TBK 'Mode '
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
        call vmset
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
        ; 13h the 256-colour table, 04h-06h/0Dh/0Eh (200 lines) the CGA palette, 07h/0Fh the mono grayscale
        ; palette (dac_mon; a mono display takes the green output), all others the EGA palette
        mov si,[ent]
        mov al,[si]
        cmp al,0x13
        jne .d0
        call dac_256
        jmp .mem
.d0:    cmp al,0x07
        je .dm
        cmp al,0x0F
        je .dm
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
        jmp .mem
.dm:    call dac_mono
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
.e4:
        call tend
        ret

; Mode set of the current entry [ent], as vga_one makes it: in pass 2 first the VESA mode of
; prevesa, for a 350-line entry AH=12h BL=30h AL=01h, then AH=00h, then the S3 unlock. Also the
; second try of a DAC check (dac_mode). In: [ent], [vi], [pass]. Keeps all registers.
vmset:  pusha
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
        popa
        ret

; DAC 0-63 after the mode set. [cgapal]=0: EGA 64-colour palette, colour bits 5-0 = r g b R G B,
; component = 2Ah * (R, G or B bit 2-0) + 15h * (r, g or b bit 5-3).
; [cgapal]=1: CGA palette of the 200-line modes, bits 2-0 = R G B, bit 4 = intensity (+15h on all
; three), bits 3 and 5 ignored, and colour 6 is brown (green 15h instead of 2Ah).
; Builds the 64 expected entries in dacexp, then dac_mode checks them (fail 20, warn 2/4).
dac_ega:
        xor bx,bx
        mov di,dacexp
.l:     mov ax,0x2004                   ; red: 2Ah if bit 2, 15h if bit 5
        call dexp
        mov [di],dl
        mov ax,0x1002                   ; green: bits 1 and 4
        call dexp
        cmp byte [cgapal],1
        jne .g
        mov cl,bl
        and cl,0x17
        cmp cl,6
        jne .g
        mov dl,0x15                     ; CGA brown
.g:     mov [di+1],dl
        mov ax,0x0801                   ; blue: bits 0 and 3
        call dexp
        mov [di+2],dl
        add di,3
        inc bx
        cmp bx,64
        jb .l
        mov si,dacexp
        mov cx,64
        jmp dac_mode

; Modes 07h/0Fh: the mono default palette (VGATEST DAC.MON, dac_mon in vgaref.inc), a grayscale ramp
; R=G=B; a mono display takes the green output (the data book's mono signal). Entries 0-63, as dac_ega does.
dac_mono:
        mov si,dac_mon
        mov cx,64
        jmp dac_mode

; Mode 13h: DAC 0-247 must equal IBM's default table (248-255 are 0 in IBM and not compared).
dac_256:
        mov si,dac_col
        mov cx,248
        ; fall through

; Default DAC of the mode just set against the expected table (vga_one, bit 20 and warn 2/4).
; In: SI -> expected entries (R, G, B), CX = number of entries from 0. dacconf reads the DAC; a
; mismatch is read a second time and, if still there, the mode is set again (vmset) and read once
; more. Only a mismatch on all three reads is a FAIL: then the BIOS loaded a wrong value twice. A
; byte wrong once (a port read or a DAC write that did not land, seen on the cards once per run at
; most, docs/765-rom.md) is WARN 2 (right on the second read) or WARN 4 (right after the mode set
; again). The first mismatch is printed: " DAC#xx=rr,gg,bb exp rr,gg,bb" and the outcome (dacrep);
; on a FAIL of the EGA/CGA check " not EGA" or " not CGA" follows.
dac_mode:
        push bp
        xor dl,dl
        mov bp,vmset
        call dacconf
        pop bp
        or al,al
        jz .r
        call dacrep
        cmp al,1
        jne .n1
        WARNB 2
        ret
.n1:    cmp al,2
        jne .n2
        WARNB 4
        ret
.n2:    FAILB 0x20
        mov si,[ent]
        cmp byte [si],0x13
        je .r
        cmp byte [cgapal],1
        je .bc
        PS ' not EGA'
        ret
.bc:    PS ' not CGA'
.r:     ret

; Compare DAC entries 0 to CX-1 with an expected table, one read through 3C7h/3C9h.
; In: SI -> expected (R, G, B per entry), CX = entries (at most 256), DL = tolerance per component.
; Out: CF clear when every component is within DL; CF set: BX = first entry outside, dacbuf holds
; the read. Keeps SI, CX, DX and DI; changes AX and BX.
dacchk: push cx
        push di
        mov di,dacbuf
        xor al,al
        call dacread
        pop di
        pop cx
        push cx
        imul cx,cx,3
        xor bx,bx
.l:     mov al,[dacbuf+bx]
        sub al,[si+bx]                  ; 6-bit values: the difference fits in a signed byte
        jns .p
        neg al
.p:     cmp al,dl
        ja .bad
        inc bx
        loop .l
        pop cx
        clc
        ret
.bad:   mov ax,bx
        mov bl,3
        div bl
        movzx bx,al
        pop cx
        stc
        ret

; Check the DAC (dacchk) and confirm a mismatch before it counts as the BIOS's: read again, then
; repeat the BIOS call (BP -> a routine that keeps all registers) and check a third time.
; In: SI, CX, DL as dacchk, BP. Out: AL = 0 all within DL on the first read, 1 right on the second
; read, 2 right after the call again, 3 still wrong. AL nonzero: [dacbad] = first read's entry,
; [dacv1] its R, G, B; for 3 also [dacbad2] and dacbuf = the third read. Keeps SI, CX, DX, BP.
; /V: one D:DAC record per read (try=n, "ok" or the entry with got= and exp=).
dacconf:
        push bx
        mov al,1
        call .try
        jnc .ok0
        mov [dacbad],bl
        imul bx,bx,3
        mov ax,[dacbuf+bx]
        mov [dacv1],ax
        mov al,[dacbuf+bx+2]
        mov [dacv1+2],al
        mov al,2
        call .try
        mov al,1
        jnc .r
        call bp
        mov al,3
        call .try
        mov al,2
        jnc .r
        mov [dacbad2],bl
        mov al,3
        jmp .r
.ok0:   xor al,al
.r:     pop bx
        ret
.try:   VS 'D:DAC try='                 ; AL = try number -> CF, BX as dacchk
        call vhex2
        call dacchk
        jc .tb
        VS ' ok'
        call vnl
        clc
        ret
.tb:    pushf
        push ax
        push di
        VS ' i='
        mov al,bl
        call vhex2
        VS ' got='
        imul di,bx,3
        push di
        add di,dacbuf
        call .v3
        VS ' exp='
        pop di
        add di,si
        call .v3
        call vnl
        pop di
        pop ax
        popf
        ret
.v3:    mov al,[di]                     ; DI -> 3 bytes, logged as "rr gg bb"
        call vhex2
        VS ' '
        mov al,[di+1]
        call vhex2
        VS ' '
        mov al,[di+2]
        jmp vhex2

; Print the outcome of dacconf: " DAC#xx=rr,gg,bb exp rr,gg,bb" for the first read's entry, then
; AL=1 " ok on 2nd read", AL=2 " ok after the call again", AL=3 " again same" when the third read is
; wrong at the same entry with the same value, else " again DAC#yy=rr,gg,bb".
; In: AL (1-3), SI -> expected table, dacconf's results. Keeps all registers.
dacrep: pusha
        mov dl,al
        PS ' DAC#'
        mov al,[dacbad]
        call phex2
        PS '='
        mov di,dacv1
        call .p3
        PS ' exp '
        movzx di,byte [dacbad]
        imul di,di,3
        add di,si
        call .p3
        cmp dl,1
        jne .n1
        PS ' ok on 2nd read'
        jmp .r
.n1:    cmp dl,2
        jne .n2
        PS ' ok after the call again'
        jmp .r
.n2:    PS ' again '
        movzx di,byte [dacbad2]
        imul di,di,3
        add di,dacbuf
        mov al,[dacbad2]
        cmp al,[dacbad]
        jne .d
        mov ax,[di]
        cmp ax,[dacv1]
        jne .d
        mov al,[di+2]
        cmp al,[dacv1+2]
        jne .d
        PS 'same'
        jmp .r
.d:     PS 'DAC#'
        mov al,[dacbad2]
        call phex2
        PS '='
        call .p3
.r:     popa
        ret
.p3:    mov al,[di]                     ; DI -> 3 bytes, printed as "rr,gg,bb"
        call phex2
        mov al,','
        call putc
        mov al,[di+1]
        call phex2
        mov al,','
        call putc
        mov al,[di+2]
        jmp phex2

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
        cmp al,5
        je .linB
        mov ax,0xA000
        xor cx,cx                       ; 65536
        jmp mlin
.lin8:  mov ax,0xB800
        jmp mlin
.linB:  mov ax,0xB000                   ; mono text mode 07h: the window is B000h, 32 KB
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
        db 17                           ; 17 register writes (the 0 word after them is padding)
        dw 0x6B00,0x5901,0x5A02,0x8E03,0x5E04,0x8A05,0x0D06,0x3E07,0x4109,0xEA10,0xAC11,0xDF12,0x2D13,0x0014,0xE715,0x0616,0xE317
        dw 0x0000
        db 'Mode X 360x240$'
        db 0xE7
        dw 602
        db 17
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
        TB C_VGA,'Text 80x50 (AX=1112)'
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
.m:
        call tend
        ret

; ======================================================================
; VGA BIOS function tests (after VGATEST)

; VGA BIOS functions, after VGATEST tests 2-12. Each test is one result line; fail bits per test:
;   AH=01/02/03 cursor   1 CR0A/CR0B not 0D/0E for shape 0607h (emulation), 2 AH=03 shape,
;                        4 CR0E/CR0F or AH=03 position, 8 emulation off (AH=12 BL=34) not honoured
;   AH=04 light pen      1 a light pen reported (the VGA has none)
;   AH=05 pages          1 CR0C/CR0D start address not 40:4E, 2 40:62 not the page or 40:4E not page *
;                        page size of the IBM BIOS (mode 03h: 1000h, 0Dh: 2000h), so a call that does
;                        nothing fails too
bios_tests:
        ; ---- cursor
        mov ax,3
        int 0x10
        TB C_CGA,'AH=01/02/03 cursor + emulation'
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
        TB C_CGA,'AH=04 light pen not present'
        call tdots
        mov ah,4
        int 0x10
        or ah,ah
        jz .l1
        FAILB 1
.l1:    call tend
        ; ---- pages
        TB C_CGA,'AH=05 pages (mode 03 p3, mode 0D p7)'
        call tdots
        mov ax,3
        int 0x10
        mov ax,0x0503
        int 0x10
        mov ax,0x0003                   ; page 3, start 3 * 1000h
        mov cx,0x3000
        call pgchk
        mov ax,0x0D
        int 0x10
        mov ax,0x0507
        int 0x10
        mov ax,0x0007                   ; page 7, start 7 * 2000h
        mov cx,0xE000
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
        ; ---- AH=0Bh, PEL mask, text font loads
        call bios_gaps
        ret

; Functions no other test checks (found by emu/mutants.py: each one turned into a call that does
; nothing passed every test). Expected values from the IBM PC AT/PS/2 BIOS interface and the IBM mode
; tables (vgaref.inc, mode 04h: AR00 00h, AR01-03 13h/15h/17h = palette 1 with intensity, BDA 466h 30h).
;   AH=0Bh CGA colours    mode 04h: 1 BH=1 BL=0: AR01-03 = 12h/14h/16h (palette 0, intensity kept),
;                         2 BDA 466h bit 5 = 0, 4 BH=1 BL=1: AR01-03 = 13h/15h/17h and bit 5 = 1,
;                         8 BH=0 BL=01h: background AR00 = 01h, 10h border AR11 = 01h, 20h BDA 466h
;                         = 21h (colour 1, palette 1, BL bit 4 = 0: intensity off) and AR01-03 =
;                         03h/05h/07h; mode 03h: 40h BH=0 BL=04h: border AR11 = 04h
;   AX=1018h/1019h PEL    1 AX=1018h BL=0Fh: 3C6h = 0Fh, 2 AX=1019h returns BL = 0Fh, 4 BL=FFh back
;   AX=1100h/1101h fonts  mode 03h: 1 AX=1100h (ES:BP glyph, CX=1, DX=41h, BL=0, BH=16): plane 2 at
;                         41h * 32 holds the glyph, 2 AX=1101h BL=0: 'A' there is the glyph of the
;                         8x14 table of AX=1130h BH=2 (CX bytes; this BIOS has no 8x14 font and gives
;                         the 8x16 one, the known WARN of the font tests; 'A' is overwritten with AAh
;                         first, so a call that does nothing fails), 4 AX=1102h: the 8x8 glyph of
;                         AX=1130h BH=3, 8 AX=1104h: the 8x16 glyph of BH=6, 10h AX=1110h (8x8 user
;                         glyph): in plane 2, 20h and recalculated: BDA 485h = 8, 484h = 49, CR09 = 7,
;                         40h AX=1103h: SR03 = the block specifier BL (05h, then 00h)
;   AH=12h BL=20h         WARN 1 INT 05h (cleared first) does not point into the video BIOS segment
;                         (INT 10h's) afterwards: no alternate print screen. Known: 2.04.07 has none,
;                         the subfunction is a RET (IBM's VGA BIOS has one)
bios_gaps:
        mov ax,4
        int 0x10
        TB C_CGA,'AH=0B CGA background, border, palette'
        call tdots
        mov ax,0x0B00                   ; palette 0 (intensity of the mode set kept)
        mov bx,0x0100
        int 0x10
        mov si,cgap0
        call ar13
        je .a1
        FAILB 1
.a1:    call rd466
        test al,0x20
        jz .a2
        FAILB 2
.a2:    mov ax,0x0B00                   ; palette 1
        mov bx,0x0101
        int 0x10
        mov si,cgap1
        call ar13
        jne .a3
        call rd466
        test al,0x20
        jnz .a4
.a3:    FAILB 4
.a4:    mov ax,0x0B00                   ; background blue, BL bit 4 = 0: intensity off
        mov bx,0x0001
        int 0x10
        mov ax,0x0004                   ; AR00
        call readreg
        cmp al,0x01
        je .a5
        FAILB 8
.a5:    mov ax,0x1104                   ; AR11 overscan
        call readreg
        cmp al,0x01
        je .a6
        FAILB 0x10
.a6:    call rd466
        and al,0x3F
        cmp al,0x21
        jne .a7
        mov si,cgap1n
        call ar13
        je .a8
.a7:    FAILB 0x20
.a8:    mov ax,3
        int 0x10
        mov ax,0x0B00
        mov bx,0x0004
        int 0x10
        mov ax,0x1104
        call readreg
        cmp al,0x04
        je .a9
        FAILB 0x40
.a9:    mov ax,3
        int 0x10
        call tend
        TB C_VGA,'AX=1018/1019 PEL mask'
        call tdots
        mov ax,0x1018
        mov bl,0x0F
        int 0x10
        mov dx,0x3C6
        in al,dx
        cmp al,0x0F
        je .p1
        FAILB 1
.p1:    mov ax,0x1019
        xor bx,bx
        int 0x10
        cmp bl,0x0F
        je .p2
        FAILB 2
.p2:    mov ax,0x1018
        mov bl,0xFF
        int 0x10
        mov dx,0x3C6
        in al,dx
        cmp al,0xFF
        je .p3
        FAILB 4
.p3:    call tend
        TB C_EGA,'AX=1100-1104, 1110 text fonts'
        call tdots
        mov ax,3
        int 0x10
        mov bp,g16                      ; ES:BP = our glyph
        call ld1
        mov si,g16
        mov cx,16
        call pl2cmp
        je .f1
        FAILB 1
.f1:    mov bp,aa16                     ; 'A' = AAh, then the ROM 8x14 font into block 0
        call ld1
        mov ax,0x1101
        xor bl,bl
        int 0x10
        mov bh,6                        ; no 8x14 font (known): AX=1130h BH=2 gives the 8x16 table
        call fptr
        push dx                         ; (not in [tmpd]: fptr uses it)
        push ax
        mov bh,2
        call fptr
        pop bx
        pop si
        mov cx,14
        cmp ax,bx
        jne .f1b
        cmp dx,si
        jne .f1b
        mov cx,16
.f1b:   mov bh,2
        call romglyph
        je .f2
        FAILB 2
.f2:    mov bp,aa16                     ; AX=1102h: the 8x8 font
        call ld1
        mov ax,0x1102
        xor bl,bl
        int 0x10
        mov bh,3
        mov cx,8
        call romglyph
        je .f3
        FAILB 4
