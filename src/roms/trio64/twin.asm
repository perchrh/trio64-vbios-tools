; Trio64 patch p1: the window set and get keep the sequencer index (Phoenix 1.5-07).
; Phoenix's window set (WSET) and get (GWIN), behind 4F05 and the window function, read SR04 (chain 4)
; through RDREG and leave the 3C4h index at 04h; S3's own BIOSes (2.04.07, 1.03-08) leave it as found,
; and a program that set an SR index before the call (S3TEST's 4F05 line) finds it changed. Both
; 'call RDREG' for SR04 are replaced by a call to sr04.
bits 16
%include "bios.inc"
org TWIN

; ---------------- SR04 with the index kept ----------------
; In: DX = 3C4h (AL = 04h, set by the caller, not needed). Out: AH = SR04, AL = the SR index as found,
; which is back in 3C4h. Keeps the others. The callers use AH only.
sr04:   in      al, dx                  ; the index as found
        mov     ah, al
        mov     al, 0x04
        out     dx, al
        inc     dx
        in      al, dx                  ; SR04
        dec     dx
        xchg    al, ah
        out     dx, al                  ; the index back
        ret
