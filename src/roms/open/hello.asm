; Open PCI option ROM: a POST-time "hello world" for any conventional PCI card.
; The BIOS maps the ROM, calls the entry point at offset 3 (CF=1) and the code
; prints "Hello world" on the INT 10h teletype and beeps high-low high-low
; (four tones: 1200 Hz, 600 Hz, 1200 Hz, 600 Hz) on the PC speaker, then
; returns with CF=0 so the BIOS keeps the image. The old PCI BIOS convention
; of a second call with CF=0 (run-time) is answered with an immediate return.
;
; Entry (init, CF=1): AX = bus number in AH, device/function in AL; the
; routine preserves every register and returns by RETF, status in CF
; (0 = success, the image stays; 1 = error). Called in real mode only.
;
; The image is exactly 32 KB (the header length byte 02h and the PCIR image
; length say so; build.py pads and fixes the checksum at offset 6), meant to
; be flashed twice into a 64 KB EEPROM: a board may map either half. The
; vendor/device IDs stay 0000h/0000h here (a generic ROM); build.py writes
; --vendor/--device into both the legacy header and the PCIR structure.
;
; Header layout: PCI Firmware Specification, expansion ROM header (type 00)
; and PCI data structure ("PCIR", code type 0 = Intel x86 PC-AT); beep via
; PIT channel 2 (ports 43h/42h/61h), timing via INT 1Ah AH=00h tick waits.
; Assembler: NASM 3.02, -f bin (src/roms/open/build.py).
bits 16
cpu 386
org 0

; ---------------------------------------------------------------------------
; Expansion ROM header (type 00). The checksum byte at 06h is patched by
; build.py so the sum of all 32768 image bytes is 0 mod 256.
; ---------------------------------------------------------------------------
        db 0x55, 0xAA           ; 00h: signature
        db 0x40                 ; 02h: image length in 512-byte units (32 KB)
        jmp near init           ; 03h: init entry point (3 bytes, to 06h)
        db 0                    ; 06h: checksum (patched by build.py)
        db 0, 0, 0              ; 07h: reserved
        dw 0                    ; 0Ah: vendor ID (build.py --vendor)
        dw 0                    ; 0Ch: device ID (build.py --device)
        dw 0                    ; 0Eh: reserved
        dw pcir                 ; 10h: offset of the PCI data structure

; ---------------------------------------------------------------------------
; PCI data structure ("PCIR"). Image length and code type say: one 32 KB
; x86 image, the last (only) one in the file.
; ---------------------------------------------------------------------------
pcir:   db "PCIR"               ; 00h: signature
        dw 0                    ; 04h: vendor ID (build.py --vendor)
        dw 0                    ; 06h: device ID (build.py --device)
        dw 0                    ; 08h: device list pointer (none)
        dw 0x40                 ; 0Ah: image length in 512-byte units (32 KB)
        dw 0                    ; 0Ch: revision of this data structure
        db 0                    ; 0Eh: code type 0 = Intel x86, PC-AT compatible
        db 0x80                 ; 0Fh: indicator: last image
        dw 0                    ; 10h: reserved

; ---------------------------------------------------------------------------
; Init entry. CF=1: POST-time initialization; CF=0: the old PCI BIOS
; run-time call, answered at once. All registers preserved, status in CF.
; ---------------------------------------------------------------------------
init:   jnc .ret                ; run-time call: nothing to do
        pusha
        push ds
        push es
        push cs
        pop ds                  ; DS = ROM segment, strings are org 0 offsets
        in al, 0x61              ; remember the speaker gate as found
        mov [spk], al
        mov si, hello
.pr:    lodsb
        or al, al
        jz .prd
        mov ah, 0x0E            ; INT 10h teletype output
        mov bx, 0x0007          ; page 0, attribute 07h
        int 0x10
        jmp .pr
.prd:   mov si, tones           ; four tones: high, low, high, low
        mov bp, 4
.beep:  lodsw                   ; AX = PIT channel 2 divisor
        call speaker_on
        mov cx, 5               ; tone: about 270 ms (5 ticks of 55 ms)
        call wait_ticks
        call speaker_off
        mov cx, 2               ; gap: about 110 ms
        call wait_ticks
        dec bp
        jnz .beep
        mov al, [spk]           ; restore the speaker gate as found
        out 0x61, al
        pop es
        pop ds
        popa
.ret:   clc                     ; CF=0: keep the image
        retf

; ---------------------------------------------------------------------------
; speaker_on: PIT channel 2 to square wave, gate on.
; In: AX = divisor (1193182 / Hz). Out: nothing. Kept: BX, CX, SI, BP, DS.
; ---------------------------------------------------------------------------
speaker_on:
        push ax
        mov bl, al              ; divisor low then high into channel 2
        out 0x42, al
        mov al, ah
        out 0x42, al
        mov al, 0xB6            ; channel 2, mode 3 (square wave), both bytes
        out 0x43, al
        in al, 0x61             ; gate and output on (bits 0 and 1)
        or al, 3
        out 0x61, al
        pop ax
        ret

; ---------------------------------------------------------------------------
; speaker_off: PIT channel 2 gate off.
; In: nothing. Out: nothing. Kept: BX, CX, SI, BP, DS.
; ---------------------------------------------------------------------------
speaker_off:
        push ax
        in al, 0x61
        and al, 0xFC
        out 0x61, al
        pop ax
        ret

; ---------------------------------------------------------------------------
; wait_ticks: wait about CX BIOS ticks (INT 1Ah AH=00h, 18.2 per second),
; counted on the low word of the midnight counter, modulo 65536.
; In: CX = ticks. Out: nothing. Kept: SI, BP, DS.
; Clobbers: AX, CX, DX, BX (BX holds the start count).
; ---------------------------------------------------------------------------
wait_ticks:
        mov ah, 0
        int 0x1A
        mov bx, dx              ; start count
.wt:    mov ah, 0
        int 0x1A
        sub dx, bx              ; (now - start) mod 65536
        cmp dx, cx
        jb .wt
        ret

; ---------------------------------------------------------------------------
; Data
; ---------------------------------------------------------------------------
hello:  db "Hello world", 0x0D, 0x0A, 0
tones:  dw 994, 1989, 994, 1989  ; 1200 Hz, 600 Hz, 1200 Hz, 600 Hz
spk:    db 0                    ; port 61h as found on entry
