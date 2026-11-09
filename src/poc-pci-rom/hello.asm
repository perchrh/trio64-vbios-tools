; Open PCI option ROM: a POST-time identity banner for any conventional PCI card
; (PCI 2.1 and later; the image follows the expansion ROM header and PCI data
; structure of PCI Local Bus Specification 2.1/2.3, section 6.3, and the
; project's option ROM rules ROM-1 to ROM-4, docs/cleanroom/spec-a-post.md).
; The BIOS maps the ROM, copies the image to RAM, far-calls the entry point
; at offset 3 and the code prints its identity banner on the INT 10h teletype
; (the name and version, then the card's vendor:device IDs read from the PCI
; data structure, like a VGA BIOS printing its signoff) and
; beeps high-low high-low (four tones: 1200 Hz, 600 Hz, 1200 Hz, 600 Hz) on
; the PC speaker, holds the text for about 1 s more (the string is up for
; about 2.5 s in all) and returns with CF=0.
;
; Entry (init): AX = bus number in AH, device/function in AL; the routine
; preserves every register and returns by RETF, status in CF (0 = success,
; 1 = error). Called in real mode only, from the RAM copy. The entry does
; not test CF: not every system BIOS calls with CF=1 (the emulator starts
; a ROM with CF=0, and so do BIOSes without the old PCI BIOS double call),
; so the work runs on the first call whatever CF says.
;
; The work runs once per machine, not once per image copy: a 64 KB part
; carries the 32 KB image once plus FFh padding (PAD=64) and a BIOS that
; scans the ROM window for 55h AAh (or calls the entry twice, the old PCI
; BIOS CF=0 convention) would otherwise run every copy and beep again. The
; done flag
; therefore lives in the BIOS data area at 0040:00FFh (the inter-application
; communication area), which all shadow copies of the image share. The
; image itself is never written: the port 61h value is kept on the stack,
; and the image sum stays 00h (ROM-6).
;
; The image is exactly 32 KB (the Initialization Size byte 02h and the PCIR
; Image Length say so; build.py pads with 00h and fixes the checksum at
; offset 6, ROM-3), meant to be flashed twice into a 64 KB EEPROM: a board
; may map either half (ROM-4). The vendor/device IDs stay 0000h/0000h here;
; build.py writes --vendor/--device into the PCI data structure. A PCI 2.1
; POST skips an image whose IDs do not match the card (section 6.3.2), so
; build with the card's real IDs.
;
; Beep via PIT channel 2 (ports 43h/42h/61h). The tone waits latch-read PIT
; channel 0 (counter latch command, the channel is never reprogrammed) and
; need no interrupt and no BIOS tick: the system BIOS may call the ROM with
; interrupts off (CONV-6). Assembler: NASM 3.02, -f bin (src/poc-pci-rom/build.py).
bits 16
cpu 386
org 0

; ---------------------------------------------------------------------------
; Expansion ROM header, PCI 2.1/2.3 section 6.3.3.1 (PC-compatible). The
; checksum byte at 06h is patched by build.py so the sum of all 32768 image
; bytes is 0 mod 256. The pointer to the PCI data structure is at 18h-19h
; (PCI 2.1 moved it from the old 10h); 06h-17h is application data.
; ---------------------------------------------------------------------------
        db 0x55, 0xAA           ; 00h: signature
        db 0x40                 ; 02h: Initialization Size, 512-byte units (32 KB)
        jmp near init           ; 03h: init entry point (3 bytes, to 06h)
        db 0                    ; 06h: checksum (patched by build.py)
        times 17 db 0           ; 07h-17h: reserved (application unique data)
        dw pcir                 ; 18h: offset of the PCI data structure
        times 6 db 0            ; 1Ah-1Fh: pad to the DWORD-aligned PCIR

; ---------------------------------------------------------------------------
; PCI data structure ("PCIR"), PCI 2.1/2.3 section 6.3.1.2: 18h bytes, DWORD
; aligned. Image length and code type say: one 32 KB x86 image, the last
; (only) one in the file. The vendor/device IDs must match the card (the POST
; checks them, section 6.3.2); build.py writes --vendor/--device into +04h/+06h.
; ---------------------------------------------------------------------------
pcir:   db "PCIR"               ; 00h: signature
        dw 0                    ; 04h: vendor ID (build.py --vendor)
        dw 0                    ; 06h: device ID (build.py --device)
        dw 0                    ; 08h: reserved (VPD pointer in PCI 2.0)
        dw 0x18                 ; 0Ah: length of this data structure
        db 0                    ; 0Ch: revision of this data structure
        db 0, 0, 0              ; 0Dh: class code (generic: 000000h)
        dw 0x40                 ; 10h: Image Length, 512-byte units (32 KB)
        dw 0                    ; 12h: revision level of the code
        db 0                    ; 14h: Code Type 0 = Intel x86, PC-AT compatible
        db 0x80                 ; 15h: Indicator: last image
        dw 0                    ; 16h: reserved

; ---------------------------------------------------------------------------
; Init entry. The work runs on the first call, whatever CF says (not every
; BIOS sets CF=1 for the init call). The done flag is 0040:00FFh in the BIOS
; data area, shared by every shadow copy of every image in the part, so a
; second call - or a second copy of the image that a BIOS scanning the ROM
; window also found - returns at once. All registers preserved,
; status in CF. The image is never written (ROM-6): the port 61h value is
; kept on the stack, not in a data byte inside the image.
; ---------------------------------------------------------------------------
init:   pusha
        push ds
        push es
        push cs
        pop ds                  ; DS = ROM segment, strings are org 0 offsets
        push ds
        mov ax, 0x0040
        mov ds, ax              ; DS = 0040h: the BIOS data area
        mov al, [0x00FF]        ; the done flag (inter-application area, 0040:00FFh)
        mov byte [0x00FF], 1
        pop ds
        or al, al
        jnz .ret                ; already ran on this machine
        in al, 0x61             ; remember the speaker gate as found
        push ax                 ; on the stack, not in the image
        mov si, banner
        call puts
        mov si, card            ; "Card "
        call puts
        mov ax, [pcir+4]        ; the vendor ID the image was built for
        call puthex
        mov al, ':'
        call putc
        mov ax, [pcir+6]        ; the device ID
        call puthex
        mov si, crlf
        call puts
        mov si, tones           ; four tones: high, low, high, low
        mov bp, 4
.beep:  lodsw                   ; AX = PIT channel 2 divisor
        call speaker_on
        mov cx, 5               ; tone: about 275 ms (5 PIT wraps of 54.9 ms)
        call wait_pit
        call speaker_off
        mov cx, 2               ; gap: about 110 ms
        call wait_pit
        dec bp
        jnz .beep
        pop ax                  ; the speaker gate as found
        out 0x61, al
        mov cx, 18              ; hold the text on screen: about 1 s (18 PIT
        call wait_pit           ; wraps of 54.9 ms), after the about 1.5 s of
                                ; beeps: readable, and no more than 1.5 s added
.ret:   pop es
        pop ds
        popa
        clc                     ; CF=0: success
        retf

; ---------------------------------------------------------------------------
; speaker_on: PIT channel 2 to square wave, gate on.
; In: AX = divisor (1193182 / Hz). Out: nothing. Kept: BX, CX, SI, BP, DS.
; The control word goes to port 43h first: it selects channel 2, mode 3 and
; the low-then-high byte order (and resets the byte pointer), so the count
; bytes that follow land in channel 2. Writing the count first would depend
; on channel 2's byte order as the BIOS left it, which is undefined when the
; BIOS never programmed channel 2.
; ---------------------------------------------------------------------------
speaker_on:
        push ax
        mov al, 0xB6            ; channel 2, mode 3 (square wave), both bytes
        out 0x43, al
        pop ax
        out 0x42, al            ; count low
        mov al, ah
        out 0x42, al            ; count high
        in al, 0x61             ; gate and output on (bits 0 and 1)
        or al, 3
        out 0x61, al
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
; wait_pit: wait CX wraps of the PIT channel 0 counter, each 54.9 ms
; (channel 0 runs at 1193182/65536 Hz). The counter is latch-read only
; (command 00h to port 43h), never reprogrammed, and the wait needs no
; interrupt and no BIOS tick: the system BIOS may call the ROM with
; interrupts off (CONV-6). A wrap is the count jumping up as it wraps
; past zero; channel 0 counts down.
; In: CX = wraps. Out: nothing. Kept: SI, BP, DS.
; Clobbers: AX, BX, CX.
; ---------------------------------------------------------------------------
wait_pit:
        call pit_read
        mov bx, ax              ; baseline count
.wl:    call pit_read
        cmp ax, bx              ; not below: the counter wrapped past zero (or
        jb .wl                  ; stopped counting; a wait must not hang on it)
        mov bx, ax
        loop .wl
        ret

; ---------------------------------------------------------------------------
; pit_read: AX = the current PIT channel 0 count, latch-read.
; In: nothing. Out: AX = count. Kept: BX, CX, DX, SI, BP, DS.
; Clobbers: nothing but AX.
; ---------------------------------------------------------------------------
pit_read:
        mov al, 0x00            ; counter latch command, channel 0
        out 0x43, al
        in al, 0x40             ; least significant byte first
        mov ah, al
        in al, 0x40
        xchg al, ah             ; AX = MSB in AH, LSB in AL
        ret

; ---------------------------------------------------------------------------
; Data
; ---------------------------------------------------------------------------
banner: db "PoC PCI option ROM 1.0", 0x0D, 0x0A, 0
card:   db "Card ", 0
crlf:   db 0x0D, 0x0A, 0
tones:  dw 994, 1989, 994, 1989  ; 1200 Hz, 600 Hz, 1200 Hz, 600 Hz

; ---------------------------------------------------------------------------
; puts: print the 0-terminated string at DS:SI on the INT 10h teletype.
; In: SI. Out: nothing. Kept: BX, CX, BP, DS. Clobbers: AX, SI.
; ---------------------------------------------------------------------------
puts:   lodsb
        or al, al
        jz .d
        mov ah, 0x0E            ; teletype output
        mov bx, 0x0007          ; page 0, attribute 07h
        int 0x10
        jmp puts
.d:     ret

; ---------------------------------------------------------------------------
; putc: print AL on the INT 10h teletype.
; In: AL. Out: nothing. Kept: BX, CX, BP, DS. Clobbers: AH.
; ---------------------------------------------------------------------------
putc:   mov ah, 0x0E
        mov bx, 0x0007
        int 0x10
        ret

; ---------------------------------------------------------------------------
; puthex: print AX as four hex digits on the INT 10h teletype.
; In: AX. Out: nothing. Kept: BX, BP, DS. Clobbers: AX, CX.
; ---------------------------------------------------------------------------
puthex: mov cx, 4
.h:     rol ax, 4
        push ax
        and al, 0x0F
        add al, '0'
        cmp al, '9'
        jbe .o
        add al, 'A'-'9'-1       ; 0Ah-0Fh: 'A'-'F'
.o:     mov ah, 0x0E
        mov bx, 0x0007
        int 0x10
        pop ax
        loop .h
        ret
