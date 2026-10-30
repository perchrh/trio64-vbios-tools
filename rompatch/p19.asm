; S3 Trio64V2/DX VBIOS patch p19 code block at C000:7CC8 (free in the reference)
; - cr2326: CR23 = 00h, then CR26 = 00h (called at 1A62 in the mode set, in place of 'mov ax,0026h /
;   out dx,ax'). Trio64V2 datasheet section 4.2: CR23 "must be 00H before CR26 is written", and "the
;   BIOS must write 00H to [CR26] upon each mode set (assuming CR23 is at its default value of 00H)";
;   a driver that used vertical interpolation (CR23, CR26, section 3.2.2) may leave CR23 set. 2.04.07
;   wrote CR26 only; 2.04.11 clears CR23 first when the BIOS data area mode is above 13h, this does it
;   on every mode set (CR23 is reserved and 00h by default). In: DX = CRTC. Out: AX = 0026h.
; - ddcin / ddcout: interrupts off for the whole DDC operation of VBE 4F15 (called at 5D01 and 5D54 in
;   place of 'call GETCRTC' and 'call SR0DRST'), as 2.04.11 does with pushf/cli ... popf: a timer
;   interrupt in the middle of a bit would stretch it. The INT 10h entry (210D) starts with sti, so sti
;   at the end restores the state 2.04.11's popf restores. Registers as GETCRTC and SR0DRST.
bits 16
org 0x7CC8
%include "bios.inc"
cr2326:
        mov     ax, 0x0023              ; CR23 = 00h
        out     dx, ax
        mov     ax, 0x0026              ; CR26 = 00h
        out     dx, ax
        ret
ddcin:
        cli
        jmp     GETCRTC
ddcout:
        sti
        jmp     SR0DRST
