; p19: the DDC delay of the 4F15 code (C000:5F4E-5FBA in place), as in the S3 BIOS 2.04.11.
; In: AX = delay in PIT input clocks (1.193 MHz, 0.84 us each); 0 or 8000h and above: no delay.
; Out: nothing; keeps every register. PIT channel 2 runs mode 3 with AX * 2 (mode 3 counts down by 2),
; the routine waits until the count reloads, then loads FFFFh. Port 61h bit 0 (gate) is on meanwhile;
; bit 1 (speaker) stays as it was, so nothing is heard.
; Why: 2.04.07 wrote 86h to port 43h, which is only a latch command for channel 2, then loaded the count
; in whatever access mode channel 2 had and never read that latch; the 8254 ignores a second latch while
; one is pending, so its first read returned a stale count and most delays came out far too short (the
; DDC clock then runs as fast as the bus allows). 2.04.11 sets channel 2 with B6h (mode 3, low then high
; byte). Callers: the DDC code (5E0A, 5F10, 5F21) and POST (14E5, the wait with RAM refresh off before
; the graphics engine reset; it loaded its count 0Ah into BX, not AX, in 2.04.07 and 2.04.11 alike, so
; the delay used the CR88 word left in AX: fixed in p20).
bits 16
%include "bios.inc"
org DDCWAIT
ddcwait:
        push    ax
        push    bx
        push    cx
        push    dx
        mov     bx, ax
        cmp     bx, byte 0
        jz      .done
        shl     bx, 1                   ; mode 3 counts by 2
        jc      .done
        mov     dx, 0x61
        in      al, dx
        mov     cl, al                  ; port 61h as it was
        or      al, 0x01                ; gate channel 2 on (bit 1, the speaker, unchanged)
        out     dx, al
        mov     al, 0xB6                ; channel 2: low then high byte, mode 3, binary
        out     0x43, al
        pushf
        cli
        mov     al, 0xB6
        out     0x43, al
        in      al, 0x80                ; I/O delay
        mov     ax, bx
        out     0x42, al
        xchg    al, ah
        out     0x42, al
        in      al, 0x80
        popf
.wait:  call    .read                   ; until the count reloads (goes up)
        cmp     ax, bx
        mov     bx, ax
        jc      .wait
        mov     al, 0xB6
        out     0x43, al
        in      al, 0x80
        mov     ax, 0xFFFF
        out     0x42, al
        xchg    al, ah
        out     0x42, al
        in      al, 0x80
        mov     dx, 0x61
        mov     al, cl
        out     dx, al
.done:  pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
; AX = channel 2 count (latched)
.read:  pushf
        cli
        mov     al, 0x80                ; latch channel 2
        out     0x43, al
        in      al, 0x80
        in      al, 0x42
        xchg    al, ah
        in      al, 0x42
        xchg    al, ah
        popf
        ret
        times 0x6D - ($ - $$) nop       ; the rest of the old routine (dead)
