; MCLK.COM - show, set or test the memory clock (DOS, 386+)
;
; Purpose
;   Measures the card, not the BIOS. Without a switch it only reports: the chip, the amount and
;   type of video memory, the memory clock (MCLK) the BIOS programmed, and the MCLK range for this
;   chip. It changes nothing then. /S sets the memory clock, /T searches for the highest clock at
;   which the video memory still works.
;
;   The clocks are pairs of the MCLK PLL (SR10, SR11) from pll.inc, in rising order. A clock is
;   loaded by writing SR11, SR10, then setting and clearing SR15 bit 0. The lowest pair, and the
;   low end of the range on the screen, is SR10=41h SR11=28h (50.114 MHz at 14.31818 MHz; 50113
;   kHz by the same integer formula as S3COMPAT): the lowest pair at or above 50 MHz, the EDO
;   clock in the Trio64V+ feature list (MEM-1). The data books give no minimum MCLK. The high end is
;   the chip's datasheet MCLK maximum (MEM-1, V2-MEM-1): 60 MHz on the Trio32, Trio64 and Trio64V+,
;   66.67 MHz on the Trio64UV+, on the Trio64V2 60 MHz for 1-cycle EDO and 66.67 MHz for the other
;   strapped memory types (CR36 bits 3-2). On the Trio64 the 70 MHz board policy (T64-MEM-7) is
;   not used here. The cap is that maximum plus 25 percent: 60 MHz gives 75 MHz, 66.67 MHz gives
;   83.333 MHz. Trio3D and Trio3D/2X have no datasheet maximum in this tree: /S and /T refuse.
;
; Output without a switch (also the start of /S and /T)
;   MCLK 1.0.0
;   Chip:         Trio64V2/DX 86C775          chipname, chippart (chip.inc)
;   Memory:       2 MB 1-cycle EDO            VBE 4F00 total memory (CR36 bits 7-5 when 4F00
;                                             fails), type from CR36 bits 3-2
;   Memory clock: 59.956 MHz                  SR10/SR11 as found
;   The datasheet supports 50.113 MHz to 60.000 MHz on this chip; the memory
;   speed and the hardware determine what you can get.
;
; /S MHz: set the clock
;   Programs the highest pair at or below the request and leaves it there; no memory test. The
;   BIOS programs its own clock again at the next boot. A request below the lowest pair or above
;   the cap is refused. A pair above the datasheet maximum is set only after the Y question
;   (below). After the write SR10 and SR11 are read back; when they differ the clock found at the
;   start is put back (exit 1). The run ends with one result line, either
;     Memory clock set to 57.479 MHz (requested 57.500 MHz, SR10=41 SR11=2E read back): OK
;   (the pair was written and reads back as written; exit 0), or a line that starts with "ERROR:"
;   and says why and that the clock was not changed (exit 1): below the lowest pair, above the
;   cap, the question not answered with Y, no datasheet maximum, or SR10/SR11 read back other
;   than written (then the clock found at the start is put back).
;
; /T: test steps
;   0.5 MHz steps from the lowest pair up to the cap, or /P for finer steps, or /I to start
;   higher. The screen is blanked for the run and mode 03h is restored at the end, with the clock
;   found at the start put back.
;   The recommended maximum ("Recommended max" line) is always a clock this run tested and passed,
;   and at least 1 percent below the highest clock that passed: the highest passing step at or
;   below 99 percent of it (integer kHz, step x 100 <= highest x 99). When no passing step is that
;   low (one step passed, or the run started too close to the highest) the line says "none"
;   instead of naming an untested clock: run again with a lower /I. Reaching the cap with every
;   step clean is handled the same way, from the last step under the cap. A recommendation is
;   followed by the /S command that sets it ("To use it: MCLK /S 73.737").
;
; The Y question
;   /T always, and /S above the datasheet maximum, ask once on stderr before the first PLL write:
;   it names the clock (/S) or the range (/T) and waits for a key from the BIOS keyboard (INT 16h,
;   so a redirected stdin cannot answer it; keys typed before the prompt are dropped). Only Y or y
;   goes on; any other key ends the run with the PLL untouched, an "ERROR: Not confirmed" line and exit 1.
;   The answer goes into the log. /H, a bad argument, no chip, no datasheet maximum and a request
;   out of range end before the question, also without a PLL write.
;   /Y answers the question with Y, for a run without a person at the keyboard (a batch file): the
;   question still goes to stderr, followed by "Y (/Y)", no key is read, and the log says
;   "Confirmed: /Y given" where a pressed Y gives "Confirmed: Y pressed".
;
; Usage
;   MCLK                 report only, changes nothing
;   MCLK /S 57.5         set the pair at or below 57.5 MHz
;   MCLK /T              test 0.5 MHz steps from the lowest pair up to the cap
;   MCLK /T /P           finer steps: the next PLL pair at least 0.1 MHz up, instead of 0.5 MHz
;                        (the table has pairs 46 kHz apart; finer than 0.1 MHz is not needed)
;   MCLK /T /I 52.5      start at 52.5 MHz (a pair at or below the request, not below the lowest)
;   MCLK /S 70 /Y        /Y: yes to every question, no key is read (with /S or /T)
;   MCLK /H              the help
;   /P and /I go only with /T, /Y only with /S or /T, /S not with /T: otherwise "bad argument".
;   Esc during a test pass stops the sweep and puts the clock found at the start back.
;   Exit codes: report 0 (1 when no chip is found). /S 0 when the clock was set, 1 otherwise. /T 0
;   when at least one step passed and the sweep was not stopped, 1 otherwise (a later step that
;   fails is the result, not a failed run). A key other than Y at the question is exit 1.
;   Not part of RUNALL: /S and /T change the memory clock and the memory test is slow on purpose.
;
; Each /T step, before the test: a line ending in "testing", flushed, so a hang names that clock.
; The memory test writes a pattern across the whole aperture and reads it back (address XOR
; 5AA5C33Ch, the inverted pattern, alternating 55555555h/AAAAAAAAh), twice, plus a row ping-pong
; at a 2048-byte stride. From the second step on, a full write at the candidate is read back at
; the previous clock (a write error) and a write at the previous clock is read at the candidate
; (a read error).
;
bits 16
org 0x100
cpu 386
%include "version.inc"

FLOOR_KHZ equ 50113
BOOK60    equ 60000
BOOK67    equ 66667
PSTEP_KHZ equ 100                       ; /P: the smallest step, 0.1 MHz

start:  cld
        push cs
        pop es
        mov ax,0x4400                   ; stdout a file? commit, and mirror lines to the screen
        mov bx,1
        int 0x21
        test dl,0x80
        jnz .args
        mov byte [tofile],1
.args:  call parse
        cmp byte [dohelp],1
        je help
        cmp byte [badarg],1
        je baduse
        call open_chip
        jc nochip
        call read_clocks
        call read_cr36
        call vbe_size
        call choose_book
        call header
        cmp byte [doset],1
        je setclk
        cmp byte [dotest],1
        je .test
        call relock                     ; report only: nothing was changed
        mov ax,0x4C00
        int 0x21
.test:  cmp byte [nobook],1
        je nodata
        call choose_start
        jc toohigh
        call confirm
        jc declined
        call video_on
        jc nomode
        call blank
        call sweep
        jmp finish

; ---------------------------------------------------------------------------
; argument tail. Sets [dohelp], [badarg], [doset] with [sreq], [dotest], [precise], [havei] with
; [ireq], [yesall]. /P and /I without /T, /Y without /S or /T, or /S together with /T, are a bad
; argument.

parse:  mov si,0x81
.op:    lodsb
        cmp al,13
        je .chk
        cmp al,' '
        je .op
        cmp al,9
        je .op
        cmp al,'/'
        je .sw
        cmp al,'-'
        jne .bad
.sw:    lodsb
        cmp al,'?'
        je .hlp
        or al,0x20
        cmp al,'h'
        je .hlp
        cmp al,'p'
        jne .ii
        mov byte [precise],1
        jmp .op
.ii:    cmp al,'i'
        jne .ss
        call skipsp
        call parsemhz
        jc .bad
        mov [ireq],eax
        mov byte [havei],1
        jmp .op
.ss:    cmp al,'s'
        jne .tt
        call skipsp
        call parsemhz
        jc .bad
        mov [sreq],eax
        mov byte [doset],1
        jmp .op
.tt:    cmp al,'t'
        jne .yy
        mov byte [dotest],1
        jmp .op
.yy:    cmp al,'y'
        jne .bad
        mov byte [yesall],1
        jmp .op
.chk:   mov al,[doset]                  ; the end of the tail: check the combination
        or al,[dotest]
        jnz .c2
        cmp byte [yesall],1             ; /Y without /S or /T: nothing to answer
        je .bad
.c2:    cmp byte [dotest],1
        je .t
        mov al,[precise]
        or al,[havei]
        jnz .bad
        ret
.t:     cmp byte [doset],1
        je .bad
        ret
.hlp:   mov byte [dohelp],1
        ret
.bad:   mov byte [badarg],1
        ret

; SI at a gap or a number. Leaves SI on the character after the number.
skipsp: cmp byte [si],' '
        je .s
        cmp byte [si],9
        jne .r
.s:     inc si
        jmp skipsp
.r:     ret

; "52.5" or "50.114" -> EAX kHz (3 decimal places). CF on a bad token.
parsemhz:
        xor ebx,ebx
        xor ecx,ecx
        xor edx,edx                     ; fraction stays 0 when there is no decimal point
        xor edi,edi                     ; 1 once a digit has been seen
.n:     lodsb
        cmp al,'0'
        jb .dot
        cmp al,'9'
        ja .dot
        mov edi,1
        imul ebx,ebx,10
        sub al,'0'
        movzx eax,al
        add ebx,eax
        jmp .n
.dot:   cmp al,'.'
        jne .end
        xor edx,edx                     ; fraction, up to 3 digits
.f:     lodsb
        cmp al,'0'
        jb .end
        cmp al,'9'
        ja .end
        cmp cl,3
        jae .bad
        imul edx,edx,10
        sub al,'0'
        movzx eax,al
        add edx,eax
        inc cl
        mov edi,1
        jmp .f
.end:   dec si                          ; the byte that ended the number
        test edi,edi
        jz .bad
        cmp cl,1
        jne .c2
        imul edx,edx,100
        jmp .join
.c2:    cmp cl,2
        jne .join
        imul edx,edx,10
.join:  imul eax,ebx,1000
        add eax,edx
        clc
        ret
.bad:   stc
        ret

; ---------------------------------------------------------------------------
; identity, memory, clocks. Nothing here changes the PLL.

open_chip:
        call chipfind
        jnc .ok
        call chipidregs                 ; ports may still answer
        stc
        ret
.ok:    clc
        ret

read_clocks:
        mov dx,0x3C4
        in al,dx
        mov [sridx],al
        mov al,0x08
        call rdsr
        mov [sr08],al
        call unlocksr
        mov al,0x10
        call rdsr
        mov [post10],al
        mov al,0x11
        call rdsr
        mov [post11],al
        mov al,0x15
        call rdsr
        mov [post15],al
        ret

; CR36, with the CRTC index and the lock bytes put back. Byte I/O only.
read_cr36:
        mov dx,0x3CC
        in al,dx
        mov dx,0x3B4
        test al,1
        jz .m
        mov dx,0x3D4
.m:     in al,dx
        mov [cridx],al
        mov al,0x38
        out dx,al
        inc dx
        in al,dx
        mov [cr38],al
        mov al,0x48
        out dx,al
        dec dx
        mov al,0x39
        out dx,al
        inc dx
        in al,dx
        mov [cr39],al
        mov al,0xA5
        out dx,al
        dec dx
        mov al,0x36
        out dx,al
        inc dx
        in al,dx
        mov [cr36],al
        dec dx
        mov al,0x39
        out dx,al
        inc dx
        mov al,[cr39]
        out dx,al
        dec dx
        mov al,0x38
        out dx,al
        inc dx
        mov al,[cr38]
        out dx,al
        dec dx
        mov al,[cridx]
        out dx,al
        ret

; 4F00 total memory, in 64 KB blocks. 0 when the call fails. Does not set a mode.
vbe_size:
        push di
        push es
        push cs
        pop es
        mov di,vbebuf
        mov cx,128
        xor ax,ax
        rep stosw
        mov dword [vbebuf],'VESA'
        mov di,vbebuf
        mov ax,0x4F00
        int 0x10
        cmp ax,0x004F
        jne .z
        mov ax,[vbebuf+0x12]
        mov [vbebanks],ax
        jmp .r
.z:     mov word [vbebanks],0
.r:     pop es
        pop di
        ret

; [book] and [capk]. Trio3D has no datasheet MCLK maximum in this tree: [nobook]=1.
; Trio64 uses MEM-1 (60 MHz), not the 70 MHz board policy.
choose_book:
        mov dword [book],BOOK60
        cmp byte [chip],CHIP_T3D
        je .no
        cmp byte [chip],CHIP_T3D2X
        je .no
        cmp byte [chip],CHIP_T64UVP
        jne .v2
        mov dword [book],BOOK67
        jmp .cap
.v2:    cmp byte [chip],CHIP_T64V2
        jne .cap
        test byte [cr36],0x0C           ; 00b is 1-cycle EDO, 60 MHz; the others 66.67
        jz .cap
        mov dword [book],BOOK67
.cap:   mov eax,[book]
        mov ebx,5
        mul ebx
        shr eax,2                       ; +25 percent
        mov [capk],eax
        clc
        ret
.no:    mov byte [nobook],1
        stc
        ret

; ---------------------------------------------------------------------------
; header: the report. Printed before any PLL write and before the mode set. Also sets [banks]
; (test_kb) for the sweep.

header: call lbegin
        mov si,s_title
        call lstr
        call lend
        call line_chip
        call line_mem
        call line_clock
        cmp byte [nobook],1
        je .nb
        call line_book
        ret
.nb:    call lbegin
        mov si,s_nodata
        call lstr
        call lend
        ret

; "Chip:         Trio64V2/DX 86C775". Without a chip: the ID registers, for the log.
line_chip:
        call lbegin
        mov si,s_chip
        call lstr
        cmp byte [chip],CHIP_NONE
        je .na
        call chipname
        call lstrd
        mov al,' '
        call lc
        call chippart
        call lstrd
        jmp .e
.na:    mov si,s_na
        call lstr
        mov al,[chipcr2d]
        call phex2
        mov al,' '
        call lc
        mov al,[chipcr2e]
        call phex2
        mov al,' '
        call lc
        mov al,[chipcr2f]
        call phex2
        mov al,' '
        call lc
        mov al,[chipcr30]
        call phex2
        mov al,')'
        call lc
.e:     call lend
        ret

; "Memory:       2 MB 1-cycle EDO": the amount the test walks (VBE 4F00, else the CR36 size,
; bits 7-5, written by the BIOS at POST), then the CR36 type (the strap, bits 3-2).
line_mem:
        call lbegin
        mov si,s_mem
        call lstr
        call size_si                    ; [szkb] for test_kb's fallback
        call test_kb
        call pmem
        mov al,' '
        call lc
        call type_si
        call lstr
        call lend
        ret

; "Memory clock: 59.956 MHz", from SR10/SR11 as found.
line_clock:
        call lbegin
        mov si,s_clock
        call lstr
        mov bl,[post10]
        mov bh,[post11]
        call pll_khz
        call pmhz
        call lend
        ret

; The range: the lowest pair to the datasheet maximum, on two lines.
line_book:
        call lbegin
        mov si,s_book1
        call lstr
        mov eax,FLOOR_KHZ
        call pmhz
        mov si,s_book2
        call lstr
        mov eax,[book]
        call pmhz
        mov si,s_book3
        call lstr
        call lend
        call lbegin
        mov si,s_book4
        call lstr
        call lend
        ret

; AX = KB -> "2 MB", "1.5 MB", "640 KB", or "unknown size" for 0. Keeps AX.
pmem:   push ax
        push dx
        or ax,ax
        jz .unk
        test ax,0x01FF                  ; not a multiple of 512 KB: KB
        jnz .kb
        movzx eax,ax
        push eax
        shr eax,10
        call pdec
        pop eax
        test ax,0x0200
        jz .mb
        mov si,s_half
        call lstr
.mb:    mov si,s_mb
        call lstr
        jmp .r
.kb:    movzx eax,ax
        call pdec
        mov si,s_kb
        call lstr
        jmp .r
.unk:   mov si,s_unk
        call lstr
.r:     pop dx
        pop ax
        ret

; SI -> size name. Also [szkb] for the fallback aperture.
size_si:
        mov al,[cr36]
        shr al,5
        and ax,7
        mov bx,ax
        shl bx,1
        cmp byte [chip],CHIP_T64UVP
        je .uv
        mov ax,[szkb64+bx]
        mov [szkb],ax
        mov si,[sztab+bx]
        ret
.uv:    mov ax,[uvkb+bx]
        mov [szkb],ax
        mov si,[uvtab+bx]
        ret

type_si:
        mov al,[cr36]
        shr al,2
        and ax,3
        mov bx,ax
        shl bx,1
        cmp byte [chip],CHIP_T64
        je .t
        cmp byte [chip],CHIP_T32
        jne .v
.t:     mov si,[type64+bx]
        ret
.v:     mov si,[typetab+bx]
        ret

; AX = KB the test will walk. Prefer the VBE total (64 KB units); else the CR36 size.
test_kb:
        mov ax,[vbebanks]
        or ax,ax
        jz .cr
        mov bx,ax
        mov [banks],ax
        mov ax,64
        mul bx                          ; DX:AX = banks * 64, fits for 4 MB
        ret
.cr:    mov ax,[szkb]
        mov bx,ax
        shr bx,6                        ; KB / 64 = banks
        mov [banks],bx
        ret

; "Start 73.737 MHz, step 0.500 MHz, cap 75.000 MHz (datasheet maximum + 25%)", after a
; "Requested ... is below" line when /I asked for less than the lowest pair.
line_start:
        cmp byte [clamped],1
        jne .s
        call lbegin
        mov si,s_below
        call lstr
        mov eax,[ireq]
        call pmhz
        mov si,s_bel2
        call lstr
        call lend
.s:     call lbegin
        mov si,s_start
        call lstr
        mov bx,[curi]
        call entry
        call pmhz
        mov si,s_step
        call lstr
        cmp byte [precise],1
        je .p
        mov eax,500
        call pmhz
        jmp .e
.p:     mov eax,PSTEP_KHZ
        call pmhz
        mov si,s_prec
        call lstr
.e:     mov si,s_cap
        call lstr
        mov eax,[capk]
        call pmhz
        mov si,s_plus
        call lstr
        call lend
        ret

; ---------------------------------------------------------------------------
; the sweep

; CF when /I is above the cap. Otherwise [curi] is the first pair.
choose_start:
        mov eax,FLOOR_KHZ
        cmp byte [havei],1
        jne .pick
        mov eax,[ireq]
        cmp eax,FLOOR_KHZ
        jae .hi
        mov byte [clamped],1
        mov eax,FLOOR_KHZ
        jmp .pick
.hi:    cmp eax,[capk]
        ja .over
.pick:  call find_le
        jc .over
        mov [curi],bx
        call line_start
        clc
        ret
.over:  call lbegin
        mov si,s_over
        call lstr
        mov eax,[ireq]
        call pmhz
        call lend
        stc
        ret

; /T's question: the range it will program, then ask. Out: CF as ask. Clobbers AX, BX, CX, DX,
; SI, DI.
confirm:
        call lbegin
        mov si,s_warn1
        call lstr
        mov bx,[curi]
        call entry
        call pmhz
        mov si,s_warn2
        call lstr
        mov eax,[capk]
        call pmhz
        mov si,s_warn3
        call lstr
        mov si,s_risk
        call lstr
        call ask
        jc .r
        mov si,s_yes
        call yesline
        clc
.r:     ret

; The log line after a Y: "Confirmed: Y pressed" or, with /Y, "Confirmed: /Y given", then the
; text at SI. Clobbers AX, CX, DX, SI, DI.
yesline:
        push si
        call lbegin
        mov si,s_conf
        call lstr
        mov si,s_ykey
        cmp byte [yesall],1
        jne .k
        mov si,s_yarg
.k:     call lstr
        pop si
        call lstr
        jmp lend

; The one question of a run, before the first PLL write. In: the warning and the prompt in the
; line buffer up to DI (lbegin, lstr ...); they go to stderr only (meant for the person at the
; screen). The answer goes to the log: a "Not confirmed" line here, the caller's line on Y.
; Keys already in the BIOS keyboard buffer are dropped first, so only a key pressed after the
; prompt counts. The key is read with INT 16h AH=00h, not from stdin.
; With /Y ([yesall]) no key is read: "Y (/Y)" follows the prompt on stderr and the answer is Y.
; Out: CF clear when Y or y was pressed (or /Y given), CF set for any other key. Clobbers AX, BX,
; CX, DX, SI, DI.
ask:    cmp byte [yesall],1
        jne .key
        mov si,s_yecho                  ; the prompt, then "Y (/Y)" as if typed
        call lstr
        mov ax,0x0A0D
        stosw
        call lerr
        clc
        ret
.key:   call lerr
        push es
        mov ax,0x40
        mov es,ax
        cli
        mov ax,[es:0x1C]                ; keyboard buffer head = tail: nothing waiting
        mov [es:0x1A],ax
        sti
        pop es
        xor ah,ah
        int 0x16
        mov [answer],al
        call lbegin
        mov al,[answer]
        cmp al,' '
        jb .e
        cmp al,0x7E
        ja .e
        call lc                         ; echo a printable key after the prompt
.e:     mov ax,0x0A0D
        stosw
        call lerr
        mov al,[answer]
        or al,0x20
        cmp al,'y'
        jne .no
        clc
        ret
.no:    call lbegin
        mov si,s_no
        call lstr
        call lend
        stc
        ret

; /S: program the highest pair at or below [sreq] and leave it; no memory test. Refuses a request
; below the lowest pair or above the cap, asks above the datasheet maximum. Reads SR10/SR11 back
; and puts the clock found at the start back when they differ. Ends the program: exit 0 when the
; clock was set, 1 otherwise; SR08 and the sequencer index as found.
setclk: cmp byte [nobook],1
        je nodata
        mov eax,[sreq]
        cmp eax,FLOOR_KHZ
        jb .low
        cmp eax,[capk]
        ja .high
        call find_le
        jc .low
        mov [curi],bx
        call entry
        mov [curk],eax
        mov [cur10],dl
        mov [cur11],dh
        cmp eax,[book]
        jbe .go
        call lbegin                     ; above the datasheet maximum: ask first
        mov si,s_sw1
        call lstr
        mov eax,[curk]
        call pmhz
        mov si,s_sw2
        call lstr
        mov eax,[book]
        call pmhz
        mov si,s_sw3
        call lstr
        mov si,s_risk
        call lstr
        call ask
        jc declined
        mov si,s_yes2
        call yesline
.go:    mov bl,[cur10]
        mov bh,[cur11]
        call loadp
        call settle
        mov al,0x10
        call rdsr
        mov [prv10],al                  ; what the registers hold now
        mov al,0x11
        call rdsr
        mov [prv11],al
        cmp al,[cur11]
        jne .bad
        mov al,[prv10]
        cmp al,[cur10]
        jne .bad
        call lbegin                     ; "Memory clock set to 57.479 MHz (requested 57.500 MHz,
        mov si,s_set                    ;  SR10=41 SR11=2E read back): OK"
        call lstr
        mov eax,[curk]
        call pmhz
        mov si,s_setreq
        call lstr
        mov eax,[sreq]
        call pmhz
        mov si,s_setsr
        call lstr
        mov al,[cur10]
        call phex2
        mov si,s_sr11
        call lstr
        mov al,[cur11]
        call phex2
        mov si,s_setok
        call lstr
        call lend
        call lbegin
        mov si,s_set2
        call lstr
        call lend
        call relock
        mov ax,0x4C00
        int 0x21
.bad:   mov bl,[post10]                 ; the pair did not take: back to the clock found
        mov bh,[post11]
        call loadp
        call settle
        call lbegin                     ; "ERROR: memory clock not set to 57.479 MHz: SR10/SR11
        mov si,s_setbad                 ;  read back as SR10=.. SR11=..; the clock found ..."
        call lstr
        mov eax,[curk]
        call pmhz
        mov si,s_setbd1
        call lstr
        mov al,[prv10]
        call phex2
        mov si,s_sr11
        call lstr
        mov al,[prv11]
        call phex2
        mov si,s_setbd2
        call lstr
        call lend
        jmp .x
.low:   call lbegin                     ; "ERROR: 45.000 MHz is below 50.113 MHz, the lowest ..."
        mov si,s_err
        call lstr
        mov eax,[sreq]
        call pmhz
        mov si,s_low
        call lstr
        mov eax,FLOOR_KHZ
        call pmhz
        mov si,s_low2
        call lstr
        mov si,s_unch
        call lstr
        call lend
        jmp .x
.high:  call lbegin                     ; "ERROR: 90.000 MHz is above the cap: 75.000 MHz (...)"
        mov si,s_err
        call lstr
        mov eax,[sreq]
        call pmhz
        mov si,s_high2
        call lstr
        mov eax,[capk]
        call pmhz
        mov si,s_plus
        call lstr
        mov si,s_unch
        call lstr
        call lend
.x:     call relock
        mov ax,0x4C01
        int 0x21

video_on:
        mov ax,0x4F02
        mov bx,0x0101
        int 0x10
        cmp ax,0x004F
        je .ok
        call lbegin
        mov si,s_nomode
        call lstr
        call lend
        stc
        ret
.ok:    mov byte [vid],1
        clc
        ret

blank:  mov dx,0x3C4
        mov al,0x01
        out dx,al
        inc dx
        in al,dx
        or al,0x20
        out dx,al
        ret

sweep:  cmp word [banks],0
        jne .go
        call lbegin
        mov si,s_nomem
        call lstr
        call lend
        ret
.go:    call run_step
        jc .end
        mov bx,[npass]
        shl bx,1
        mov ax,[curi]
        mov [passi+bx],ax
        inc word [npass]
        call next_i
        jc .end
        jmp .go
.end:   ret

; Next pair after [curi]. CF when the next request would pass the cap.
; 0.5 MHz: the highest pair at or below [curk] + 0.5 MHz. /P: the first pair at or above
; [curk] + 0.1 MHz (the table is in rising order). Keeps ECX.
next_i: cmp byte [precise],1
        je .p
        mov eax,[curk]
        add eax,500
        jc .no
        cmp eax,[capk]
        ja .no
        call find_le
        jc .no
        cmp bx,[curi]
        jbe .no
        mov [curi],bx
        clc
        ret
.p:     push ecx
        mov ecx,[curk]
        add ecx,PSTEP_KHZ
        mov bx,[curi]
.pl:    inc bx
        cmp bx,PLL_N
        jae .pno
        push bx
        call entry
        pop bx
        cmp eax,ecx
        jb .pl                          ; less than 0.1 MHz up: skip the pair
        cmp eax,[capk]
        ja .pno
        mov [curi],bx
        pop ecx
        clc
        ret
.pno:   pop ecx
.no:    stc
        ret

; Program [curi], say so, test. CF on a failure or Esc. A pass leaves the clock at [curi].
run_step:
        mov bx,[curi]
        call entry
        mov [curk],eax
        mov [cur10],dl
        mov [cur11],dh
        call line_testing
        mov bl,[cur10]
        mov bh,[cur11]
        call loadp
        call settle
        mov al,0x10
        call rdsr
        cmp al,[cur10]
        jne .prog
        mov al,0x11
        call rdsr
        cmp al,[cur11]
        jne .prog
        call mem_all
        jc .bad
        call line_pass
        clc
        ret
.prog:  mov byte [phase],8
        call line_fail
        stc
        ret
.bad:   call line_fail
        stc
        ret

; ---------------------------------------------------------------------------
; PLL load. BL = SR10, BH = SR11. SR15 bit 0 is pulsed and left clear; bits 5 and 7 stay clear.

unlocksr:
        mov dx,0x3C4
        mov al,0x08
        out dx,al
        inc dx
        mov al,0x06
        out dx,al
        ret

loadp:  call unlocksr
        mov dx,0x3C4
        mov al,0x11
        out dx,al
        inc dx
        mov al,bh
        out dx,al
        dec dx
        mov al,0x10
        out dx,al
        inc dx
        mov al,bl
        out dx,al
        dec dx
        mov al,0x15
        out dx,al
        inc dx
        in al,dx
        and al,0x5E                     ; drop bit 0, bit 5 and bit 7
        or al,0x01
        out dx,al
        and al,0x5E
        out dx,al
        ret

; AL = sequencer index -> AL = data. Clobbers DX.
rdsr:   mov dx,0x3C4
        out dx,al
        inc dx
        in al,dx
        ret

; Two BIOS ticks. Reading 0040:006C is enough: on a machine the byte changes every tick,
; and the emulator advances its tick when that byte is read.
settle: push ax
        push es
        mov ax,0x40
        mov es,ax
        mov al,[es:0x6C]
        call .w
        call .w
        pop es
        pop ax
        ret
.w:     cmp al,[es:0x6C]
        je .w
        mov al,[es:0x6C]
        ret

; BL = SR10, BH = SR11 -> EAX kHz. f = (14318 * (M+2) / (N+2)) >> R.
pll_khz:
        push ecx
        push edx
        movzx eax,bh
        and al,0x7F
        add eax,2
        mov ecx,14318
        mul ecx
        movzx ecx,bl
        and cl,0x1F
        add ecx,2
        div ecx
        mov cl,bl
        shr cl,5
        and cl,3
        shr eax,cl
        pop edx
        pop ecx
        ret

; ---------------------------------------------------------------------------
; memory. CF and [phase] on failure. Esc sets [stopped].

mem_all:
        mov byte [roundn],2
.r:     mov dword [xorc],0x5AA5C33C
        mov byte [phase],1
        call pat_fill
        jc .bad
        mov dword [xorc],0xA55A3CC3
        mov byte [phase],2
        call pat_fill
        jc .bad
        mov byte [phase],3
        call pat_bits
        jc .bad
        mov byte [phase],4
        call pat_row
        jc .bad
        dec byte [roundn]
        jnz .r
        cmp word [npass],0
        je .ok
        call split
        jc .bad
.ok:    clc
        ret
.bad:   stc
        ret

; Write the xor pattern at the candidate, read it at the previous passing clock,
; then the other way round. Leaves the candidate clock loaded.
split:  mov bx,[npass]
        dec bx
        shl bx,1
        mov bx,[passi+bx]
        call entry
        mov [prv10],dl
        mov [prv11],dh
        mov dword [xorc],0x5AA5C33C
        mov byte [phase],5
        call pat_write
        jc .r
        mov bl,[prv10]
        mov bh,[prv11]
        call loadp
        call settle
        call pat_read
        jc .r
        call pat_write
        jc .r
        mov bl,[cur10]
        mov bh,[cur11]
        call loadp
        call settle
        mov byte [phase],6
        call pat_read
.r:     ret

pat_fill:
        call pat_write
        jc .r
        call pat_read
.r:     ret

pat_write:
        xor si,si
.b:     cmp si,[banks]
        jae .ok
        call chkesc
        jc .r
        call setbank
        jc .bank
        mov ax,0xA000
        mov es,ax
        xor di,di
        movzx ebx,si
        shl ebx,16
.w:     mov eax,ebx
        or ax,di
        xor eax,[xorc]
        mov [es:di],eax
        add di,4
        jnz .w
        inc si
        jmp .b
.ok:    clc
        ret
.bank:  mov byte [phase],7
        stc
.r:     ret

pat_read:
        xor si,si
.b:     cmp si,[banks]
        jae .ok
        call chkesc
        jc .r
        call setbank
        jc .bank
        mov ax,0xA000
        mov es,ax
        xor di,di
        movzx ebx,si
        shl ebx,16
.w:     mov eax,ebx
        or ax,di
        xor eax,[xorc]
        cmp [es:di],eax
        jne .bad
        add di,4
        jnz .w
        inc si
        jmp .b
.ok:    clc
        ret
.bad:   mov [errexp],eax
        mov eax,[es:di]
        mov [errgot],eax
        mov [errbank],si
        mov [erroff],di
        stc
        ret
.bank:  mov byte [phase],7
        stc
.r:     ret

pat_bits:
        xor si,si
.b:     cmp si,[banks]
        jae .ok
        call chkesc
        jc .r
        call setbank
        jc .bank
        mov ax,0xA000
        mov es,ax
        xor di,di
        movzx ebx,si
        shl ebx,16
.ww:    mov eax,0x55555555
        test di,4
        jz .k
        mov eax,0xAAAAAAAA
.k:     xor eax,ebx
        mov [es:di],eax
        add di,4
        jnz .ww
        xor di,di
.rr:    mov eax,0x55555555
        test di,4
        jz .k2
        mov eax,0xAAAAAAAA
.k2:    xor eax,ebx
        cmp [es:di],eax
        jne .bad
        add di,4
        jnz .rr
        inc si
        jmp .b
.ok:    clc
        ret
.bad:   mov [errexp],eax
        mov eax,[es:di]
        mov [errgot],eax
        mov [errbank],si
        mov [erroff],di
        stc
        ret
.bank:  mov byte [phase],7
        stc
.r:     ret

; Four write/read pairs of two dwords 2048 bytes apart, on every such pair.
pat_row:
        xor si,si
.b:     cmp si,[banks]
        jae .ok
        call chkesc
        jc .r
        call setbank
        jc .bank
        mov ax,0xA000
        mov es,ax
        xor di,di
        movzx ebx,si
        shl ebx,16
.p:     cmp di,0xF000
        ja .nb
        mov cx,4
.rp:    push cx
        mov eax,ebx
        mov ax,di
        xor eax,0x3C5AA53C
        mov [es:di],eax
        mov bp,di
        add bp,0x800
        mov eax,ebx
        mov ax,bp
        xor eax,0x3C5AA53C
        mov [es:bp],eax
        mov eax,ebx
        mov ax,di
        xor eax,0x3C5AA53C
        cmp [es:di],eax
        jne .bad
        mov eax,ebx
        mov ax,bp
        xor eax,0x3C5AA53C
        cmp [es:bp],eax
        jne .bad2
        pop cx
        loop .rp
        add di,0x800
        jmp .p
.nb:    inc si
        jmp .b
.ok:    clc
        ret
.bad:   pop cx
        mov [errexp],eax
        mov eax,[es:di]
        mov [errgot],eax
        mov [errbank],si
        mov [erroff],di
        stc
        ret
.bad2:  pop cx
        mov [errexp],eax
        mov eax,[es:bp]
        mov [errgot],eax
        mov [errbank],si
        mov [erroff],bp
        stc
        ret
.bank:  mov byte [phase],7
        stc
.r:     ret

; SI = bank. CF when 4F05 does not return 004Fh.
setbank:
        push ax
        push bx
        push dx
        mov ax,0x4F05
        xor bx,bx
        mov dx,si
        int 0x10
        cmp ax,0x004F
        pop dx
        pop bx
        pop ax
        je .ok
        stc
        ret
.ok:    clc
        ret

; CF when Esc is waiting.
chkesc: push ax
        mov ah,0x0B
        int 0x21
        or al,al
        jz .no
        mov ah,0x01
        int 0x16
        cmp al,0x1B
        je .yes
        cmp ah,0x01
        jne .no
.yes:   mov ah,0x00
        int 0x16
        mov byte [stopped],1
        pop ax
        stc
        ret
.no:    pop ax
        clc
        ret

; ---------------------------------------------------------------------------
; result lines

line_testing:
        call step_head
        mov si,s_testing
        call lstr
        call lend
        ret

line_pass:
        call step_head
        mov si,s_pass
        call lstr
        call lend
        ret

line_fail:
        call step_head
        cmp byte [stopped],1
        jne .f
        mov si,s_stop
        call lstr
        jmp .e
.f:     mov si,s_fail
        call lstr
        mov al,[phase]
        call phase_si
        call lstr
        cmp byte [phase],7
        jae .e
        cmp byte [phase],8
        je .e
        mov si,s_bankw
        call lstr
        movzx eax,word [errbank]
        call pdec
        mov si,s_off
        call lstr
        mov ax,[erroff]
        call phex4
        mov si,s_exp
        call lstr
        mov eax,[errexp]
        call phex8
        mov si,s_got
        call lstr
        mov eax,[errgot]
        call phex8
.e:     call lend
        ret

step_head:
        call lbegin
        mov si,s_stepw
        call lstr
        mov eax,[curk]
        call pmhz
        mov si,s_sr
        call lstr
        mov al,[cur10]
        call phex2
        mov si,s_sr11
        call lstr
        mov al,[cur11]
        call phex2
        mov al,' '
        call lc
        ret

; AL = phase -> SI = name
phase_si:
        cmp al,1
        jne .2
        mov si,s_fill
        ret
.2:     cmp al,2
        jne .3
        mov si,s_inv
        ret
.3:     cmp al,3
        jne .4
        mov si,s_bits
        ret
.4:     cmp al,4
        jne .5
        mov si,s_row
        ret
.5:     cmp al,5
        jne .6
        mov si,s_write
        ret
.6:     cmp al,6
        jne .7
        mov si,s_read
        ret
.7:     cmp al,7
        jne .8
        mov si,s_bankn
        ret
.8:     mov si,s_prog
        ret

; ---------------------------------------------------------------------------
; restore and summary

finish: mov bl,[post10]
        mov bh,[post11]
        call loadp
        call settle
        cmp byte [vid],1
        jne .idx
        mov ax,0x0003
        int 0x10
.idx:   mov dx,0x3C4
        mov al,0x08
        out dx,al
        inc dx
        mov al,[sr08]
        out dx,al
        dec dx
        mov al,[sridx]
        out dx,al
        call summary
        mov al,1
        cmp byte [stopped],1
        je .x
        cmp word [npass],0
        je .x
        xor al,al
.x:     mov ah,0x4C
        int 0x21

summary:
        cmp word [npass],0
        je .none
        mov bx,[npass]
        dec bx
        shl bx,1
        mov bx,[passi+bx]
        mov si,s_high
        call show_pair
        mov bx,[npass]                  ; highest x 99, the limit for step x 100
        dec bx
        shl bx,1
        mov bx,[passi+bx]
        call entry
        imul eax,eax,99
        mov [reclim],eax
        mov cx,[npass]                  ; the passes below the highest, highest first
        dec cx
.cand:  jcxz .nrec
        dec cx
        mov bx,cx
        shl bx,1
        mov bx,[passi+bx]
        call entry
        imul eax,eax,100
        cmp eax,[reclim]
        ja .cand
        mov si,s_pub                    ; a tested pass at least 1 percent below the highest
        push bx
        call show_pair                  ; lend clobbers BX
        pop bx
        call lbegin                     ; "To use it: MCLK /S 73.737"
        mov si,s_use1
        call lstr                       ; clobbers AL: the entry after it
        call entry
        call pkhz
        call lend
        jmp .rest
.nrec:  call lbegin                     ; no tested pass that low: no value
        mov si,s_pub
        call lstr
        mov si,s_pub1
        call lstr
        call lend
        jmp .rest
.none:  call lbegin
        mov si,s_none
        call lstr
        call lend
.rest:  call lbegin
        mov si,s_rest
        call lstr
        mov bl,[post10]
        mov bh,[post11]
        call pll_khz
        call pmhz
        mov si,s_sr
        call lstr
        mov al,[post10]
        call phex2
        mov si,s_sr11
        call lstr
        mov al,[post11]
        call phex2
        call lend
        ret

; SI = label, BX = table index. Prints the label, the frequency and SR10/SR11. Clobbers BX.
show_pair:
        push bx
        call lbegin
        call lstr
        pop bx
        push bx
        call entry
        call pmhz
        mov si,s_sr
        call lstr
        pop bx
        call entry
        mov al,dl
        call phex2
        mov si,s_sr11
        call lstr
        mov al,dh
        call phex2
        call lend
        ret

; ---------------------------------------------------------------------------
; table walk. EAX = highest kHz. BX = index of the highest entry at or below it.

find_le:
        push ecx
        push edx
        push esi
        push ebp
        xor cx,cx
        xor dx,dx
        mov dx,0xFFFF
        xor si,si
.l:     cmp cx,PLL_N
        jae .d
        mov ebp,[pll_tab+si]
        cmp ebp,eax
        ja .n
        mov dx,cx
.n:     add si,6
        inc cx
        jmp .l
.d:     cmp dx,0xFFFF
        je .no
        mov bx,dx
        clc
        jmp .r
.no:    stc
.r:     pop ebp
        pop esi
        pop edx
        pop ecx
        ret

; BX = index -> EAX kHz, DL = SR10, DH = SR11. Keeps BX.
entry:  push bx
        movzx eax,bx
        imul eax,eax,6
        mov si,pll_tab
        add si,ax
        mov eax,[si]
        mov dl,[si+4]
        mov dh,[si+5]
        pop bx
        ret

; ---------------------------------------------------------------------------
; early exits that have not changed the PLL

nochip: call lbegin
        mov si,s_title
        call lstr
        call lend
        call line_chip
        mov ax,0x4C01
        int 0x21

nodata: call relock
        call lbegin
        mov si,s_nodat2
        call lstr
        call lend
        mov ax,0x4C01
        int 0x21

toohigh:
declined:
        call relock
        mov ax,0x4C01
        int 0x21

nomode: call relock
        mov ax,0x4C01
        int 0x21

; SR08 and the sequencer index, as read_clocks found them.
relock: mov dx,0x3C4
        mov al,0x08
        out dx,al
        inc dx
        mov al,[sr08]
        out dx,al
        dec dx
        mov al,[sridx]
        out dx,al
        ret

baduse: mov dx,s_bad
        mov ah,9
        int 0x21
        mov ax,0x4C01
        int 0x21

help:   mov dx,s_use
        mov ah,9
        int 0x21
        mov ax,0x4C00
        int 0x21

; ---------------------------------------------------------------------------
; line buffer

lbegin: push cs
        pop es
        mov di,line
        ret

; SI -> zero terminated text, copied to DI. Keeps SI.
lstr:   push si
.l:     lodsb
        or al,al
        jz .d
        stosb
        jmp .l
.d:     pop si
        ret

; DX -> '$' string (chipname, chippart).
lstrd:  push si
        mov si,dx
.l:     lodsb
        cmp al,'$'
        je .d
        stosb
        jmp .l
.d:     pop si
        ret

lc:     stosb
        ret

lend:   mov ax,0x0A0D
        stosw
        mov cx,di
        sub cx,line
        mov [llen],cx
        push ds
        mov dx,line
        mov bx,1
        mov ah,0x40
        int 0x21
        cmp byte [tofile],1
        jne .r
        mov ah,0x68
        mov bx,1
        int 0x21
        mov dx,line
        mov cx,[llen]
        mov bx,2
        mov ah,0x40
        int 0x21
.r:     pop ds
        ret

; The line buffer up to DI, as it is (no CR LF added), to stderr only.
lerr:   mov cx,di
        sub cx,line
        mov dx,line
        mov bx,2
        mov ah,0x40
        int 0x21
        ret

phex8:  push eax
        shr eax,16
        call phex4
        pop eax
phex4:  push ax
        mov al,ah
        call phex2
        pop ax
phex2:  push ax
        shr al,4
        call hexd
        pop ax
        and al,0x0F
hexd:   cmp al,10
        jb .d
        add al,'A'-10
        jmp lc
.d:     add al,'0'
        jmp lc

pdec:   push eax
        push ebx
        push ecx
        push edx
        xor cx,cx
        mov ebx,10
.a:     xor edx,edx
        div ebx
        push dx
        inc cx
        test eax,eax
        jnz .a
.b:     pop ax
        add al,'0'
        call lc
        loop .b
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret

; EAX kHz -> "50.113 MHz". Keeps every register (and DI moves on).
pmhz:   call pkhz
        push si
        mov si,s_mhz
        call lstr
        pop si
        ret

; EAX kHz -> "50.113", the form /S and /I take. Keeps every register (and DI moves on).
pkhz:   push eax
        push ebx
        push ecx
        push edx
        xor edx,edx
        mov ebx,1000
        div ebx
        push dx                         ; remainder is 0..999; a 16-bit push matches pop ax
        call pdec
        mov al,'.'
        call lc
        pop ax
        call p3
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret

; AX = 0..999, three digits.
p3:     xor dx,dx
        mov bx,100
        div bx
        add al,'0'
        call lc
        mov ax,dx
        xor dx,dx
        mov bx,10
        div bx
        add al,'0'
        call lc
        mov al,dl
        add al,'0'
        jmp lc

; ---------------------------------------------------------------------------
; data

tofile  db 0
dohelp  db 0
badarg  db 0
precise db 0
havei   db 0
doset   db 0
dotest  db 0
yesall  db 0                    ; /Y: answer the question with Y, read no key
clamped db 0
nobook  db 0
vid     db 0
stopped db 0
answer  db 0
phase   db 0
roundn  db 0
sridx   db 0
sr08    db 0
post10  db 0
post11  db 0
post15  db 0
cridx   db 0
cr38    db 0
cr39    db 0
cr36    db 0
cur10   db 0
cur11   db 0
prv10   db 0
prv11   db 0
ireq    dd 0
sreq    dd 0
book    dd 0
capk    dd 0
curk    dd 0
xorc    dd 0
curi    dw 0
npass   dw 0
banks   dw 0
vbebanks dw 0
szkb    dw 0
errbank dw 0
erroff  dw 0
errexp  dd 0
errgot  dd 0
reclim  dd 0
llen    dw 0
passi   times 256 dw 0

s_title db 'MCLK ',VERSION,0
s_chip  db 'Chip:         ',0
s_na    db 'not found (CR2D-CR30 ',0
s_mem   db 'Memory:       ',0
s_clock db 'Memory clock: ',0
s_book1 db 'The datasheet supports ',0
s_book2 db ' to ',0
s_book3 db ' on this chip; the memory',0
s_book4 db 'speed and the hardware determine what you can get.',0
s_mb    db ' MB',0
s_half  db '.5',0
s_kb    db ' KB',0
s_unk   db 'unknown size,',0
s_start db 'Start ',0
s_step  db ', step ',0
s_prec  db ' or more (/P)',0
s_cap   db ', cap ',0
s_plus  db ' (datasheet maximum + 25%)',0
s_below db 'Requested ',0
s_bel2  db ' is below the lowest clock; starting there',0
s_over  db 'Start is above the cap: ',0
s_mhz   db ' MHz',0
s_sr    db ' SR10=',0
s_sr11  db ' SR11=',0
s_stepw db 'STEP ',0
s_testing db 'testing',0
s_pass  db 'PASS',0
s_fail  db 'FAIL ',0
s_stop  db 'STOP',0
s_fill  db 'fill',0
s_inv   db 'invert',0
s_bits  db 'bits',0
s_row   db 'row',0
s_write db 'write',0
s_read  db 'read',0
s_bankn db 'bank',0
s_prog  db 'program',0
s_bankw db ' bank ',0
s_off   db ' off ',0
s_exp   db ' exp ',0
s_got   db ' got ',0
s_high  db 'Highest ',0
s_pub   db 'Recommended max ',0
s_pub1  db 'none: no tested step 1% or more below the highest (run again with a lower /I)',0
s_use1  db 'To use it: MCLK /S ',0
s_none  db 'No step passed',0
s_rest  db 'Restored ',0
s_set   db 'Memory clock set to ',0
s_setreq db ' (requested ',0
s_setsr db ', SR10=',0
s_setok db ' read back): OK',0
s_set2  db 'The BIOS sets its own clock again at the next boot.',0
s_err   db 'ERROR: ',0
s_unch  db '; the clock was not changed',0
s_setbad db 'ERROR: memory clock not set to ',0
s_setbd1 db ': SR10/SR11 read back as SR10=',0
s_setbd2 db '; the clock found at the start was put back',0
s_low   db ' is below ',0
s_low2  db ', the lowest clock MCLK sets',0
s_high2 db ' is above the cap: ',0
s_nomode db 'Mode 101h was not set; the clock was not changed',0
s_nomem db 'No video memory to test',0
s_nodata db 'No datasheet MCLK maximum for this chip in MCLK',0
s_nodat2 db 'ERROR: /S and /T need the datasheet maximum; the clock was not changed',0
s_warn1 db 'MCLK /T changes the memory clock of this card. It programs the MCLK PLL from',13,10,0
s_warn2 db ' up to ',0
s_warn3 db ' (the datasheet maximum plus 25 percent).',13,10
        db 'The clock found at the start is put back at the end.',13,10,0
s_sw1   db 'MCLK /S sets the memory clock to ',0
s_sw2   db ', above the datasheet maximum',13,10
        db 'of ',0
s_sw3   db '.',13,10,0
s_risk  db 'A clock above what the memory takes can corrupt video memory or hang the',13,10
        db 'machine (then reset it). Press Y to continue, any other key to quit: ',0
s_conf  db 'Confirmed: ',0
s_ykey  db 'Y pressed',0
s_yarg  db '/Y given',0
s_yecho db 'Y (/Y)',0
s_yes   db ', the clock steps start',0
s_yes2  db 0
s_no    db 'ERROR: Not confirmed: the clock was not changed',0
s_4     db '4 MB',0
s_2     db '2 MB',0
s_15    db '1.5 MB',0
s_1     db '1 MB',0
s_05    db '0.5 MB',0
s_res   db 'reserved',0
s_edo1  db '1-cycle EDO',0
s_sgram db 'SGRAM',0
s_edo2  db '2-cycle EDO',0
s_fpm   db 'fast page',0
s_edo   db 'EDO',0

sztab   dw s_4, s_res, s_res, s_res, s_2, s_res, s_1, s_05
uvtab   dw s_res, s_res, s_res, s_res, s_2, s_15, s_1, s_05
szkb64  dw 4096, 0, 0, 0, 2048, 0, 1024, 512
uvkb    dw 0, 0, 0, 0, 2048, 1536, 1024, 512
typetab dw s_edo1, s_sgram, s_edo2, s_fpm
type64  dw s_res, s_res, s_edo, s_fpm

s_bad   db 'MCLK ',VERSION,': bad argument. MCLK /H for help.',13,10,'$'
s_use   db 'MCLK ',VERSION,' - show, set or test the memory clock (MCLK)',13,10
        db 13,10
        db '  MCLK            show the chip, the memory and the memory clock',13,10
        db '  MCLK /S 57.5    set the memory clock to 57.5 MHz (or the step just below)',13,10
        db '  MCLK /T         test the memory in 0.5 MHz steps from 50.113 MHz up to the',13,10
        db '                  datasheet maximum + 25%, and recommend a clock',13,10
        db '  MCLK /T /P      test in steps of 0.1 MHz or more',13,10
        db '  MCLK /T /I 55   start the test at 55 MHz',13,10
        db '  MCLK /S 70 /Y   /Y answers yes to every question (no key is read)',13,10
        db '  MCLK /H         this help',13,10
        db 13,10
        db '/S asks for Y above the datasheet maximum, /T always. The BIOS sets its own',13,10
        db 'clock again at the next boot. Esc stops a test; the old clock is put back.',13,10,'$'

%include "chip.inc"
%include "pll.inc"

vbebuf  times 256 db 0
line    times 512 db 0
