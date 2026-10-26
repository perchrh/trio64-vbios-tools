; font8x14.inc - the 8x14 VGA character set for S3F8X14.COM
; 256 characters x 14 bytes, top row first, bit 7 = leftmost pixel. Taken from the S3 86C775/86C785
; Video BIOS 1.01.04 (10/23/96), C000:5DA7, the table INT 10h AX=1130h BH=02h returns there. It is the
; standard IBM VGA 8x14 font: byte-identical to FIX8X14.FNT of FIX8X14 1.0.8 (BTTR Software).
font8x14:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h   ; 00h
        db 00h,00h,7Eh,81h,0A5h,81h,81h,0BDh,99h,81h,7Eh,00h,00h,00h   ; 01h
        db 00h,00h,7Eh,0FFh,0DBh,0FFh,0FFh,0C3h,0E7h,0FFh,7Eh,00h,00h,00h   ; 02h
        db 00h,00h,00h,6Ch,0FEh,0FEh,0FEh,0FEh,7Ch,38h,10h,00h,00h,00h   ; 03h
        db 00h,00h,00h,10h,38h,7Ch,0FEh,7Ch,38h,10h,00h,00h,00h,00h   ; 04h
        db 00h,00h,18h,3Ch,3Ch,0E7h,0E7h,0E7h,18h,18h,3Ch,00h,00h,00h   ; 05h
        db 00h,00h,18h,3Ch,7Eh,0FFh,0FFh,7Eh,18h,18h,3Ch,00h,00h,00h   ; 06h
        db 00h,00h,00h,00h,00h,18h,3Ch,3Ch,18h,00h,00h,00h,00h,00h   ; 07h
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0E7h,0C3h,0C3h,0E7h,0FFh,0FFh,0FFh,0FFh,0FFh   ; 08h
        db 00h,00h,00h,00h,3Ch,66h,42h,42h,66h,3Ch,00h,00h,00h,00h   ; 09h
        db 0FFh,0FFh,0FFh,0FFh,0C3h,99h,0BDh,0BDh,99h,0C3h,0FFh,0FFh,0FFh,0FFh   ; 0Ah
        db 00h,00h,1Eh,0Eh,1Ah,32h,78h,0CCh,0CCh,0CCh,78h,00h,00h,00h   ; 0Bh
        db 00h,00h,3Ch,66h,66h,66h,3Ch,18h,7Eh,18h,18h,00h,00h,00h   ; 0Ch
        db 00h,00h,3Fh,33h,3Fh,30h,30h,30h,70h,0F0h,0E0h,00h,00h,00h   ; 0Dh
        db 00h,00h,7Fh,63h,7Fh,63h,63h,63h,67h,0E7h,0E6h,0C0h,00h,00h   ; 0Eh
        db 00h,00h,18h,18h,0DBh,3Ch,0E7h,3Ch,0DBh,18h,18h,00h,00h,00h   ; 0Fh
        db 00h,00h,80h,0C0h,0E0h,0F8h,0FEh,0F8h,0E0h,0C0h,80h,00h,00h,00h   ; 10h
        db 00h,00h,02h,06h,0Eh,3Eh,0FEh,3Eh,0Eh,06h,02h,00h,00h,00h   ; 11h
        db 00h,00h,18h,3Ch,7Eh,18h,18h,18h,7Eh,3Ch,18h,00h,00h,00h   ; 12h
        db 00h,00h,66h,66h,66h,66h,66h,66h,00h,66h,66h,00h,00h,00h   ; 13h
        db 00h,00h,7Fh,0DBh,0DBh,0DBh,7Bh,1Bh,1Bh,1Bh,1Bh,00h,00h,00h   ; 14h
        db 00h,7Ch,0C6h,60h,38h,6Ch,0C6h,0C6h,6Ch,38h,0Ch,0C6h,7Ch,00h   ; 15h
        db 00h,00h,00h,00h,00h,00h,00h,00h,0FEh,0FEh,0FEh,00h,00h,00h   ; 16h
        db 00h,00h,18h,3Ch,7Eh,18h,18h,18h,7Eh,3Ch,18h,7Eh,00h,00h   ; 17h
        db 00h,00h,18h,3Ch,7Eh,18h,18h,18h,18h,18h,18h,00h,00h,00h   ; 18h
        db 00h,00h,18h,18h,18h,18h,18h,18h,7Eh,3Ch,18h,00h,00h,00h   ; 19h
        db 00h,00h,00h,00h,18h,0Ch,0FEh,0Ch,18h,00h,00h,00h,00h,00h   ; 1Ah
        db 00h,00h,00h,00h,30h,60h,0FEh,60h,30h,00h,00h,00h,00h,00h   ; 1Bh
        db 00h,00h,00h,00h,00h,0C0h,0C0h,0C0h,0FEh,00h,00h,00h,00h,00h   ; 1Ch
        db 00h,00h,00h,00h,28h,6Ch,0FEh,6Ch,28h,00h,00h,00h,00h,00h   ; 1Dh
        db 00h,00h,00h,10h,38h,38h,7Ch,7Ch,0FEh,0FEh,00h,00h,00h,00h   ; 1Eh
        db 00h,00h,00h,0FEh,0FEh,7Ch,7Ch,38h,38h,10h,00h,00h,00h,00h   ; 1Fh
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h   ; 20h
        db 00h,00h,18h,3Ch,3Ch,3Ch,18h,18h,00h,18h,18h,00h,00h,00h   ; 21h
        db 00h,66h,66h,66h,24h,00h,00h,00h,00h,00h,00h,00h,00h,00h   ; 22h
        db 00h,00h,6Ch,6Ch,0FEh,6Ch,6Ch,6Ch,0FEh,6Ch,6Ch,00h,00h,00h   ; 23h
        db 18h,18h,7Ch,0C6h,0C2h,0C0h,7Ch,06h,86h,0C6h,7Ch,18h,18h,00h   ; 24h
        db 00h,00h,00h,00h,0C2h,0C6h,0Ch,18h,30h,66h,0C6h,00h,00h,00h   ; 25h
        db 00h,00h,38h,6Ch,6Ch,38h,76h,0DCh,0CCh,0CCh,76h,00h,00h,00h   ; 26h
        db 00h,30h,30h,30h,60h,00h,00h,00h,00h,00h,00h,00h,00h,00h   ; 27h
        db 00h,00h,0Ch,18h,30h,30h,30h,30h,30h,18h,0Ch,00h,00h,00h   ; 28h
        db 00h,00h,30h,18h,0Ch,0Ch,0Ch,0Ch,0Ch,18h,30h,00h,00h,00h   ; 29h
        db 00h,00h,00h,00h,66h,3Ch,0FFh,3Ch,66h,00h,00h,00h,00h,00h   ; 2Ah
        db 00h,00h,00h,00h,18h,18h,7Eh,18h,18h,00h,00h,00h,00h,00h   ; 2Bh
        db 00h,00h,00h,00h,00h,00h,00h,00h,18h,18h,18h,30h,00h,00h   ; 2Ch
        db 00h,00h,00h,00h,00h,00h,0FEh,00h,00h,00h,00h,00h,00h,00h   ; 2Dh
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,18h,18h,00h,00h,00h   ; 2Eh
        db 00h,00h,02h,06h,0Ch,18h,30h,60h,0C0h,80h,00h,00h,00h,00h   ; 2Fh
        db 00h,00h,7Ch,0C6h,0CEh,0DEh,0F6h,0E6h,0C6h,0C6h,7Ch,00h,00h,00h   ; 30h
        db 00h,00h,18h,38h,78h,18h,18h,18h,18h,18h,7Eh,00h,00h,00h   ; 31h
        db 00h,00h,7Ch,0C6h,06h,0Ch,18h,30h,60h,0C6h,0FEh,00h,00h,00h   ; 32h
        db 00h,00h,7Ch,0C6h,06h,06h,3Ch,06h,06h,0C6h,7Ch,00h,00h,00h   ; 33h
        db 00h,00h,0Ch,1Ch,3Ch,6Ch,0CCh,0FEh,0Ch,0Ch,1Eh,00h,00h,00h   ; 34h
        db 00h,00h,0FEh,0C0h,0C0h,0C0h,0FCh,06h,06h,0C6h,7Ch,00h,00h,00h   ; 35h
        db 00h,00h,38h,60h,0C0h,0C0h,0FCh,0C6h,0C6h,0C6h,7Ch,00h,00h,00h   ; 36h
        db 00h,00h,0FEh,0C6h,06h,0Ch,18h,30h,30h,30h,30h,00h,00h,00h   ; 37h
        db 00h,00h,7Ch,0C6h,0C6h,0C6h,7Ch,0C6h,0C6h,0C6h,7Ch,00h,00h,00h   ; 38h
        db 00h,00h,7Ch,0C6h,0C6h,0C6h,7Eh,06h,06h,0Ch,78h,00h,00h,00h   ; 39h
        db 00h,00h,00h,18h,18h,00h,00h,00h,18h,18h,00h,00h,00h,00h   ; 3Ah
        db 00h,00h,00h,18h,18h,00h,00h,00h,18h,18h,30h,00h,00h,00h   ; 3Bh
        db 00h,00h,06h,0Ch,18h,30h,60h,30h,18h,0Ch,06h,00h,00h,00h   ; 3Ch
        db 00h,00h,00h,00h,00h,7Eh,00h,00h,7Eh,00h,00h,00h,00h,00h   ; 3Dh
        db 00h,00h,60h,30h,18h,0Ch,06h,0Ch,18h,30h,60h,00h,00h,00h   ; 3Eh
        db 00h,00h,7Ch,0C6h,0C6h,0Ch,18h,18h,00h,18h,18h,00h,00h,00h   ; 3Fh
        db 00h,00h,7Ch,0C6h,0C6h,0DEh,0DEh,0DEh,0DCh,0C0h,7Ch,00h,00h,00h   ; 40h
        db 00h,00h,10h,38h,6Ch,0C6h,0C6h,0FEh,0C6h,0C6h,0C6h,00h,00h,00h   ; 41h
        db 00h,00h,0FCh,66h,66h,66h,7Ch,66h,66h,66h,0FCh,00h,00h,00h   ; 42h
        db 00h,00h,3Ch,66h,0C2h,0C0h,0C0h,0C0h,0C2h,66h,3Ch,00h,00h,00h   ; 43h
        db 00h,00h,0F8h,6Ch,66h,66h,66h,66h,66h,6Ch,0F8h,00h,00h,00h   ; 44h
        db 00h,00h,0FEh,66h,62h,68h,78h,68h,62h,66h,0FEh,00h,00h,00h   ; 45h
        db 00h,00h,0FEh,66h,62h,68h,78h,68h,60h,60h,0F0h,00h,00h,00h   ; 46h
        db 00h,00h,3Ch,66h,0C2h,0C0h,0C0h,0DEh,0C6h,66h,3Ah,00h,00h,00h   ; 47h
        db 00h,00h,0C6h,0C6h,0C6h,0C6h,0FEh,0C6h,0C6h,0C6h,0C6h,00h,00h,00h   ; 48h
        db 00h,00h,3Ch,18h,18h,18h,18h,18h,18h,18h,3Ch,00h,00h,00h   ; 49h
        db 00h,00h,1Eh,0Ch,0Ch,0Ch,0Ch,0Ch,0CCh,0CCh,78h,00h,00h,00h   ; 4Ah
        db 00h,00h,0E6h,66h,6Ch,6Ch,78h,6Ch,6Ch,66h,0E6h,00h,00h,00h   ; 4Bh
        db 00h,00h,0F0h,60h,60h,60h,60h,60h,62h,66h,0FEh,00h,00h,00h   ; 4Ch
        db 00h,00h,0C6h,0EEh,0FEh,0FEh,0D6h,0C6h,0C6h,0C6h,0C6h,00h,00h,00h   ; 4Dh
        db 00h,00h,0C6h,0E6h,0F6h,0FEh,0DEh,0CEh,0C6h,0C6h,0C6h,00h,00h,00h   ; 4Eh
        db 00h,00h,38h,6Ch,0C6h,0C6h,0C6h,0C6h,0C6h,6Ch,38h,00h,00h,00h   ; 4Fh
        db 00h,00h,0FCh,66h,66h,66h,7Ch,60h,60h,60h,0F0h,00h,00h,00h   ; 50h
        db 00h,00h,7Ch,0C6h,0C6h,0C6h,0C6h,0D6h,0DEh,7Ch,0Ch,0Eh,00h,00h   ; 51h
        db 00h,00h,0FCh,66h,66h,66h,7Ch,6Ch,66h,66h,0E6h,00h,00h,00h   ; 52h
        db 00h,00h,7Ch,0C6h,0C6h,60h,38h,0Ch,0C6h,0C6h,7Ch,00h,00h,00h   ; 53h
        db 00h,00h,7Eh,7Eh,5Ah,18h,18h,18h,18h,18h,3Ch,00h,00h,00h   ; 54h
        db 00h,00h,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,00h,00h,00h   ; 55h
        db 00h,00h,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,6Ch,38h,10h,00h,00h,00h   ; 56h
        db 00h,00h,0C6h,0C6h,0C6h,0C6h,0D6h,0D6h,0FEh,7Ch,6Ch,00h,00h,00h   ; 57h
        db 00h,00h,0C6h,0C6h,6Ch,38h,38h,38h,6Ch,0C6h,0C6h,00h,00h,00h   ; 58h
        db 00h,00h,66h,66h,66h,66h,3Ch,18h,18h,18h,3Ch,00h,00h,00h   ; 59h
        db 00h,00h,0FEh,0C6h,8Ch,18h,30h,60h,0C2h,0C6h,0FEh,00h,00h,00h   ; 5Ah
        db 00h,00h,3Ch,30h,30h,30h,30h,30h,30h,30h,3Ch,00h,00h,00h   ; 5Bh
        db 00h,00h,80h,0C0h,0E0h,70h,38h,1Ch,0Eh,06h,02h,00h,00h,00h   ; 5Ch
        db 00h,00h,3Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,3Ch,00h,00h,00h   ; 5Dh
        db 10h,38h,6Ch,0C6h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h   ; 5Eh
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0FFh,00h   ; 5Fh
        db 30h,30h,18h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h   ; 60h
        db 00h,00h,00h,00h,00h,78h,0Ch,7Ch,0CCh,0CCh,76h,00h,00h,00h   ; 61h
        db 00h,00h,0E0h,60h,60h,78h,6Ch,66h,66h,66h,7Ch,00h,00h,00h   ; 62h
        db 00h,00h,00h,00h,00h,7Ch,0C6h,0C0h,0C0h,0C6h,7Ch,00h,00h,00h   ; 63h
        db 00h,00h,1Ch,0Ch,0Ch,3Ch,6Ch,0CCh,0CCh,0CCh,76h,00h,00h,00h   ; 64h
        db 00h,00h,00h,00h,00h,7Ch,0C6h,0FEh,0C0h,0C6h,7Ch,00h,00h,00h   ; 65h
        db 00h,00h,38h,6Ch,64h,60h,0F0h,60h,60h,60h,0F0h,00h,00h,00h   ; 66h
        db 00h,00h,00h,00h,00h,76h,0CCh,0CCh,0CCh,7Ch,0Ch,0CCh,78h,00h   ; 67h
        db 00h,00h,0E0h,60h,60h,6Ch,76h,66h,66h,66h,0E6h,00h,00h,00h   ; 68h
        db 00h,00h,18h,18h,00h,38h,18h,18h,18h,18h,3Ch,00h,00h,00h   ; 69h
        db 00h,00h,06h,06h,00h,0Eh,06h,06h,06h,06h,66h,66h,3Ch,00h   ; 6Ah
        db 00h,00h,0E0h,60h,60h,66h,6Ch,78h,6Ch,66h,0E6h,00h,00h,00h   ; 6Bh
        db 00h,00h,38h,18h,18h,18h,18h,18h,18h,18h,3Ch,00h,00h,00h   ; 6Ch
        db 00h,00h,00h,00h,00h,0ECh,0FEh,0D6h,0D6h,0D6h,0C6h,00h,00h,00h   ; 6Dh
        db 00h,00h,00h,00h,00h,0DCh,66h,66h,66h,66h,66h,00h,00h,00h   ; 6Eh
        db 00h,00h,00h,00h,00h,7Ch,0C6h,0C6h,0C6h,0C6h,7Ch,00h,00h,00h   ; 6Fh
        db 00h,00h,00h,00h,00h,0DCh,66h,66h,66h,7Ch,60h,60h,0F0h,00h   ; 70h
        db 00h,00h,00h,00h,00h,76h,0CCh,0CCh,0CCh,7Ch,0Ch,0Ch,1Eh,00h   ; 71h
        db 00h,00h,00h,00h,00h,0DCh,76h,66h,60h,60h,0F0h,00h,00h,00h   ; 72h
        db 00h,00h,00h,00h,00h,7Ch,0C6h,70h,1Ch,0C6h,7Ch,00h,00h,00h   ; 73h
        db 00h,00h,10h,30h,30h,0FCh,30h,30h,30h,36h,1Ch,00h,00h,00h   ; 74h
        db 00h,00h,00h,00h,00h,0CCh,0CCh,0CCh,0CCh,0CCh,76h,00h,00h,00h   ; 75h
        db 00h,00h,00h,00h,00h,66h,66h,66h,66h,3Ch,18h,00h,00h,00h   ; 76h
        db 00h,00h,00h,00h,00h,0C6h,0C6h,0D6h,0D6h,0FEh,6Ch,00h,00h,00h   ; 77h
        db 00h,00h,00h,00h,00h,0C6h,6Ch,38h,38h,6Ch,0C6h,00h,00h,00h   ; 78h
        db 00h,00h,00h,00h,00h,0C6h,0C6h,0C6h,0C6h,7Eh,06h,0Ch,0F8h,00h   ; 79h
        db 00h,00h,00h,00h,00h,0FEh,0CCh,18h,30h,66h,0FEh,00h,00h,00h   ; 7Ah
        db 00h,00h,0Eh,18h,18h,18h,70h,18h,18h,18h,0Eh,00h,00h,00h   ; 7Bh
        db 00h,00h,18h,18h,18h,18h,00h,18h,18h,18h,18h,00h,00h,00h   ; 7Ch
        db 00h,00h,70h,18h,18h,18h,0Eh,18h,18h,18h,70h,00h,00h,00h   ; 7Dh
        db 00h,00h,76h,0DCh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h   ; 7Eh
        db 00h,00h,00h,00h,10h,38h,6Ch,0C6h,0C6h,0FEh,00h,00h,00h,00h   ; 7Fh
        db 00h,00h,3Ch,66h,0C2h,0C0h,0C0h,0C2h,66h,3Ch,0Ch,06h,7Ch,00h   ; 80h
        db 00h,00h,0CCh,0CCh,00h,0CCh,0CCh,0CCh,0CCh,0CCh,76h,00h,00h,00h   ; 81h
        db 00h,0Ch,18h,30h,00h,7Ch,0C6h,0FEh,0C0h,0C6h,7Ch,00h,00h,00h   ; 82h
        db 00h,10h,38h,6Ch,00h,78h,0Ch,7Ch,0CCh,0CCh,76h,00h,00h,00h   ; 83h
        db 00h,00h,0CCh,0CCh,00h,78h,0Ch,7Ch,0CCh,0CCh,76h,00h,00h,00h   ; 84h
        db 00h,60h,30h,18h,00h,78h,0Ch,7Ch,0CCh,0CCh,76h,00h,00h,00h   ; 85h
        db 00h,38h,6Ch,38h,00h,78h,0Ch,7Ch,0CCh,0CCh,76h,00h,00h,00h   ; 86h
        db 00h,00h,00h,00h,3Ch,66h,60h,66h,3Ch,0Ch,06h,3Ch,00h,00h   ; 87h
        db 00h,10h,38h,6Ch,00h,7Ch,0C6h,0FEh,0C0h,0C6h,7Ch,00h,00h,00h   ; 88h
        db 00h,00h,0CCh,0CCh,00h,7Ch,0C6h,0FEh,0C0h,0C6h,7Ch,00h,00h,00h   ; 89h
        db 00h,60h,30h,18h,00h,7Ch,0C6h,0FEh,0C0h,0C6h,7Ch,00h,00h,00h   ; 8Ah
        db 00h,00h,66h,66h,00h,38h,18h,18h,18h,18h,3Ch,00h,00h,00h   ; 8Bh
        db 00h,18h,3Ch,66h,00h,38h,18h,18h,18h,18h,3Ch,00h,00h,00h   ; 8Ch
        db 00h,60h,30h,18h,00h,38h,18h,18h,18h,18h,3Ch,00h,00h,00h   ; 8Dh
        db 00h,0C6h,0C6h,10h,38h,6Ch,0C6h,0C6h,0FEh,0C6h,0C6h,00h,00h,00h   ; 8Eh
        db 38h,6Ch,38h,00h,38h,6Ch,0C6h,0C6h,0FEh,0C6h,0C6h,00h,00h,00h   ; 8Fh
        db 18h,30h,60h,00h,0FEh,66h,60h,7Ch,60h,66h,0FEh,00h,00h,00h   ; 90h
        db 00h,00h,00h,00h,0CCh,76h,36h,7Eh,0D8h,0D8h,6Eh,00h,00h,00h   ; 91h
        db 00h,00h,3Eh,6Ch,0CCh,0CCh,0FEh,0CCh,0CCh,0CCh,0CEh,00h,00h,00h   ; 92h
        db 00h,10h,38h,6Ch,00h,7Ch,0C6h,0C6h,0C6h,0C6h,7Ch,00h,00h,00h   ; 93h
        db 00h,00h,0C6h,0C6h,00h,7Ch,0C6h,0C6h,0C6h,0C6h,7Ch,00h,00h,00h   ; 94h
        db 00h,60h,30h,18h,00h,7Ch,0C6h,0C6h,0C6h,0C6h,7Ch,00h,00h,00h   ; 95h
        db 00h,30h,78h,0CCh,00h,0CCh,0CCh,0CCh,0CCh,0CCh,76h,00h,00h,00h   ; 96h
        db 00h,60h,30h,18h,00h,0CCh,0CCh,0CCh,0CCh,0CCh,76h,00h,00h,00h   ; 97h
        db 00h,00h,0C6h,0C6h,00h,0C6h,0C6h,0C6h,0C6h,7Eh,06h,0Ch,78h,00h   ; 98h
        db 00h,0C6h,0C6h,38h,6Ch,0C6h,0C6h,0C6h,0C6h,6Ch,38h,00h,00h,00h   ; 99h
        db 00h,0C6h,0C6h,00h,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,00h,00h,00h   ; 9Ah
        db 00h,18h,18h,3Ch,66h,60h,60h,66h,3Ch,18h,18h,00h,00h,00h   ; 9Bh
        db 00h,38h,6Ch,64h,60h,0F0h,60h,60h,60h,0E6h,0FCh,00h,00h,00h   ; 9Ch
        db 00h,00h,66h,66h,3Ch,18h,7Eh,18h,7Eh,18h,18h,00h,00h,00h   ; 9Dh
        db 00h,0F8h,0CCh,0CCh,0F8h,0C4h,0CCh,0DEh,0CCh,0CCh,0C6h,00h,00h,00h   ; 9Eh
        db 00h,0Eh,1Bh,18h,18h,18h,7Eh,18h,18h,18h,18h,0D8h,70h,00h   ; 9Fh
        db 00h,18h,30h,60h,00h,78h,0Ch,7Ch,0CCh,0CCh,76h,00h,00h,00h   ; A0h
        db 00h,0Ch,18h,30h,00h,38h,18h,18h,18h,18h,3Ch,00h,00h,00h   ; A1h
        db 00h,18h,30h,60h,00h,7Ch,0C6h,0C6h,0C6h,0C6h,7Ch,00h,00h,00h   ; A2h
        db 00h,18h,30h,60h,00h,0CCh,0CCh,0CCh,0CCh,0CCh,76h,00h,00h,00h   ; A3h
        db 00h,00h,76h,0DCh,00h,0DCh,66h,66h,66h,66h,66h,00h,00h,00h   ; A4h
        db 76h,0DCh,00h,0C6h,0E6h,0F6h,0FEh,0DEh,0CEh,0C6h,0C6h,00h,00h,00h   ; A5h
        db 00h,3Ch,6Ch,6Ch,3Eh,00h,7Eh,00h,00h,00h,00h,00h,00h,00h   ; A6h
        db 00h,38h,6Ch,6Ch,38h,00h,7Ch,00h,00h,00h,00h,00h,00h,00h   ; A7h
        db 00h,00h,30h,30h,00h,30h,30h,60h,0C6h,0C6h,7Ch,00h,00h,00h   ; A8h
        db 00h,00h,00h,00h,00h,00h,0FEh,0C0h,0C0h,0C0h,00h,00h,00h,00h   ; A9h
        db 00h,00h,00h,00h,00h,00h,0FEh,06h,06h,06h,00h,00h,00h,00h   ; AAh
        db 00h,0C0h,0C0h,0C6h,0CCh,0D8h,30h,60h,0DCh,86h,0Ch,18h,3Eh,00h   ; ABh
        db 00h,0C0h,0C0h,0C6h,0CCh,0D8h,30h,66h,0CEh,9Eh,3Eh,06h,06h,00h   ; ACh
        db 00h,00h,18h,18h,00h,18h,18h,3Ch,3Ch,3Ch,18h,00h,00h,00h   ; ADh
        db 00h,00h,00h,00h,36h,6Ch,0D8h,6Ch,36h,00h,00h,00h,00h,00h   ; AEh
        db 00h,00h,00h,00h,0D8h,6Ch,36h,6Ch,0D8h,00h,00h,00h,00h,00h   ; AFh
        db 11h,44h,11h,44h,11h,44h,11h,44h,11h,44h,11h,44h,11h,44h   ; B0h
        db 55h,0AAh,55h,0AAh,55h,0AAh,55h,0AAh,55h,0AAh,55h,0AAh,55h,0AAh   ; B1h
        db 0DDh,77h,0DDh,77h,0DDh,77h,0DDh,77h,0DDh,77h,0DDh,77h,0DDh,77h   ; B2h
        db 18h,18h,18h,18h,18h,18h,18h,18h,18h,18h,18h,18h,18h,18h   ; B3h
        db 18h,18h,18h,18h,18h,18h,18h,0F8h,18h,18h,18h,18h,18h,18h   ; B4h
        db 18h,18h,18h,18h,18h,0F8h,18h,0F8h,18h,18h,18h,18h,18h,18h   ; B5h
        db 36h,36h,36h,36h,36h,36h,36h,0F6h,36h,36h,36h,36h,36h,36h   ; B6h
        db 00h,00h,00h,00h,00h,00h,00h,0FEh,36h,36h,36h,36h,36h,36h   ; B7h
        db 00h,00h,00h,00h,00h,0F8h,18h,0F8h,18h,18h,18h,18h,18h,18h   ; B8h
        db 36h,36h,36h,36h,36h,0F6h,06h,0F6h,36h,36h,36h,36h,36h,36h   ; B9h
        db 36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h   ; BAh
        db 00h,00h,00h,00h,00h,0FEh,06h,0F6h,36h,36h,36h,36h,36h,36h   ; BBh
        db 36h,36h,36h,36h,36h,0F6h,06h,0FEh,00h,00h,00h,00h,00h,00h   ; BCh
        db 36h,36h,36h,36h,36h,36h,36h,0FEh,00h,00h,00h,00h,00h,00h   ; BDh
        db 18h,18h,18h,18h,18h,0F8h,18h,0F8h,00h,00h,00h,00h,00h,00h   ; BEh
        db 00h,00h,00h,00h,00h,00h,00h,0F8h,18h,18h,18h,18h,18h,18h   ; BFh
        db 18h,18h,18h,18h,18h,18h,18h,1Fh,00h,00h,00h,00h,00h,00h   ; C0h
        db 18h,18h,18h,18h,18h,18h,18h,0FFh,00h,00h,00h,00h,00h,00h   ; C1h
        db 00h,00h,00h,00h,00h,00h,00h,0FFh,18h,18h,18h,18h,18h,18h   ; C2h
        db 18h,18h,18h,18h,18h,18h,18h,1Fh,18h,18h,18h,18h,18h,18h   ; C3h
        db 00h,00h,00h,00h,00h,00h,00h,0FFh,00h,00h,00h,00h,00h,00h   ; C4h
        db 18h,18h,18h,18h,18h,18h,18h,0FFh,18h,18h,18h,18h,18h,18h   ; C5h
        db 18h,18h,18h,18h,18h,1Fh,18h,1Fh,18h,18h,18h,18h,18h,18h   ; C6h
        db 36h,36h,36h,36h,36h,36h,36h,37h,36h,36h,36h,36h,36h,36h   ; C7h
        db 36h,36h,36h,36h,36h,37h,30h,3Fh,00h,00h,00h,00h,00h,00h   ; C8h
        db 00h,00h,00h,00h,00h,3Fh,30h,37h,36h,36h,36h,36h,36h,36h   ; C9h
        db 36h,36h,36h,36h,36h,0F7h,00h,0FFh,00h,00h,00h,00h,00h,00h   ; CAh
        db 00h,00h,00h,00h,00h,0FFh,00h,0F7h,36h,36h,36h,36h,36h,36h   ; CBh
        db 36h,36h,36h,36h,36h,37h,30h,37h,36h,36h,36h,36h,36h,36h   ; CCh
        db 00h,00h,00h,00h,00h,0FFh,00h,0FFh,00h,00h,00h,00h,00h,00h   ; CDh
        db 36h,36h,36h,36h,36h,0F7h,00h,0F7h,36h,36h,36h,36h,36h,36h   ; CEh
        db 18h,18h,18h,18h,18h,0FFh,00h,0FFh,00h,00h,00h,00h,00h,00h   ; CFh
        db 36h,36h,36h,36h,36h,36h,36h,0FFh,00h,00h,00h,00h,00h,00h   ; D0h
        db 00h,00h,00h,00h,00h,0FFh,00h,0FFh,18h,18h,18h,18h,18h,18h   ; D1h
        db 00h,00h,00h,00h,00h,00h,00h,0FFh,36h,36h,36h,36h,36h,36h   ; D2h
        db 36h,36h,36h,36h,36h,36h,36h,3Fh,00h,00h,00h,00h,00h,00h   ; D3h
        db 18h,18h,18h,18h,18h,1Fh,18h,1Fh,00h,00h,00h,00h,00h,00h   ; D4h
        db 00h,00h,00h,00h,00h,1Fh,18h,1Fh,18h,18h,18h,18h,18h,18h   ; D5h
        db 00h,00h,00h,00h,00h,00h,00h,3Fh,36h,36h,36h,36h,36h,36h   ; D6h
        db 36h,36h,36h,36h,36h,36h,36h,0FFh,36h,36h,36h,36h,36h,36h   ; D7h
        db 18h,18h,18h,18h,18h,0FFh,18h,0FFh,18h,18h,18h,18h,18h,18h   ; D8h
        db 18h,18h,18h,18h,18h,18h,18h,0F8h,00h,00h,00h,00h,00h,00h   ; D9h
        db 00h,00h,00h,00h,00h,00h,00h,1Fh,18h,18h,18h,18h,18h,18h   ; DAh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh   ; DBh
        db 00h,00h,00h,00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh   ; DCh
        db 0F0h,0F0h,0F0h,0F0h,0F0h,0F0h,0F0h,0F0h,0F0h,0F0h,0F0h,0F0h,0F0h,0F0h   ; DDh
        db 0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh   ; DEh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,00h,00h,00h   ; DFh
        db 00h,00h,00h,00h,00h,76h,0DCh,0D8h,0D8h,0DCh,76h,00h,00h,00h   ; E0h
        db 00h,00h,00h,00h,7Ch,0C6h,0FCh,0C6h,0C6h,0FCh,0C0h,0C0h,40h,00h   ; E1h
        db 00h,00h,0FEh,0C6h,0C6h,0C0h,0C0h,0C0h,0C0h,0C0h,0C0h,00h,00h,00h   ; E2h
        db 00h,00h,00h,00h,0FEh,6Ch,6Ch,6Ch,6Ch,6Ch,6Ch,00h,00h,00h   ; E3h
        db 00h,00h,0FEh,0C6h,60h,30h,18h,30h,60h,0C6h,0FEh,00h,00h,00h   ; E4h
        db 00h,00h,00h,00h,00h,7Eh,0D8h,0D8h,0D8h,0D8h,70h,00h,00h,00h   ; E5h
        db 00h,00h,00h,00h,66h,66h,66h,66h,7Ch,60h,60h,0C0h,00h,00h   ; E6h
        db 00h,00h,00h,00h,76h,0DCh,18h,18h,18h,18h,18h,00h,00h,00h   ; E7h
        db 00h,00h,7Eh,18h,3Ch,66h,66h,66h,3Ch,18h,7Eh,00h,00h,00h   ; E8h
        db 00h,00h,38h,6Ch,0C6h,0C6h,0FEh,0C6h,0C6h,6Ch,38h,00h,00h,00h   ; E9h
        db 00h,00h,38h,6Ch,0C6h,0C6h,0C6h,6Ch,6Ch,6Ch,0EEh,00h,00h,00h   ; EAh
        db 00h,00h,1Eh,30h,18h,0Ch,3Eh,66h,66h,66h,3Ch,00h,00h,00h   ; EBh
        db 00h,00h,00h,00h,00h,7Eh,0DBh,0DBh,7Eh,00h,00h,00h,00h,00h   ; ECh
        db 00h,00h,03h,06h,7Eh,0DBh,0DBh,0F3h,7Eh,60h,0C0h,00h,00h,00h   ; EDh
        db 00h,00h,1Ch,30h,60h,60h,7Ch,60h,60h,30h,1Ch,00h,00h,00h   ; EEh
        db 00h,00h,00h,7Ch,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,00h,00h,00h   ; EFh
        db 00h,00h,00h,0FEh,00h,00h,0FEh,00h,00h,0FEh,00h,00h,00h,00h   ; F0h
        db 00h,00h,00h,18h,18h,7Eh,18h,18h,00h,00h,0FFh,00h,00h,00h   ; F1h
        db 00h,00h,30h,18h,0Ch,06h,0Ch,18h,30h,00h,7Eh,00h,00h,00h   ; F2h
        db 00h,00h,0Ch,18h,30h,60h,30h,18h,0Ch,00h,7Eh,00h,00h,00h   ; F3h
        db 00h,00h,0Eh,1Bh,1Bh,18h,18h,18h,18h,18h,18h,18h,18h,18h   ; F4h
        db 18h,18h,18h,18h,18h,18h,18h,18h,0D8h,0D8h,70h,00h,00h,00h   ; F5h
        db 00h,00h,00h,18h,18h,00h,7Eh,00h,18h,18h,00h,00h,00h,00h   ; F6h
        db 00h,00h,00h,00h,76h,0DCh,00h,76h,0DCh,00h,00h,00h,00h,00h   ; F7h
        db 00h,38h,6Ch,6Ch,38h,00h,00h,00h,00h,00h,00h,00h,00h,00h   ; F8h
        db 00h,00h,00h,00h,00h,00h,18h,18h,00h,00h,00h,00h,00h,00h   ; F9h
        db 00h,00h,00h,00h,00h,00h,00h,18h,00h,00h,00h,00h,00h,00h   ; FAh
        db 00h,0Fh,0Ch,0Ch,0Ch,0Ch,0Ch,0ECh,6Ch,3Ch,1Ch,00h,00h,00h   ; FBh
        db 00h,0D8h,6Ch,6Ch,6Ch,6Ch,6Ch,00h,00h,00h,00h,00h,00h,00h   ; FCh
        db 00h,70h,0D8h,30h,60h,0C8h,0F8h,00h,00h,00h,00h,00h,00h,00h   ; FDh
        db 00h,00h,00h,00h,7Ch,7Ch,7Ch,7Ch,7Ch,7Ch,00h,00h,00h,00h   ; FEh
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h   ; FFh

; 9x14 alternate characters (INT 10h AX=1130h BH=05h): character code, 14 rows; 0 ends the list.
; From the same BIOS, C000:6BA7.
font9x14:
        db 1Dh, 00h,00h,00h,00h,24h,66h,0FFh,66h,24h,00h,00h,00h,00h,00h   ; 1Dh
        db 22h, 00h,63h,63h,63h,22h,00h,00h,00h,00h,00h,00h,00h,00h,00h   ; 22h
        db 2Bh, 00h,00h,00h,18h,18h,18h,0FFh,18h,18h,18h,00h,00h,00h,00h   ; 2Bh
        db 2Dh, 00h,00h,00h,00h,00h,00h,0FFh,00h,00h,00h,00h,00h,00h,00h   ; 2Dh
        db 4Dh, 00h,00h,0C3h,0E7h,0FFh,0DBh,0C3h,0C3h,0C3h,0C3h,0C3h,00h,00h,00h   ; 4Dh
        db 54h, 00h,00h,0FFh,0DBh,99h,18h,18h,18h,18h,18h,3Ch,00h,00h,00h   ; 54h
        db 56h, 00h,00h,0C3h,0C3h,0C3h,0C3h,0C3h,0C3h,66h,3Ch,18h,00h,00h,00h   ; 56h
        db 57h, 00h,00h,0C3h,0C3h,0C3h,0C3h,0DBh,0DBh,0FFh,66h,66h,00h,00h,00h   ; 57h
        db 58h, 00h,00h,0C3h,0C3h,66h,3Ch,18h,3Ch,66h,0C3h,0C3h,00h,00h,00h   ; 58h
        db 59h, 00h,00h,0C3h,0C3h,0C3h,66h,3Ch,18h,18h,18h,3Ch,00h,00h,00h   ; 59h
        db 5Ah, 00h,00h,0FFh,0C3h,86h,0Ch,18h,30h,61h,0C3h,0FFh,00h,00h,00h   ; 5Ah
        db 6Dh, 00h,00h,00h,00h,00h,0E6h,0FFh,0DBh,0DBh,0DBh,0DBh,00h,00h,00h   ; 6Dh
        db 76h, 00h,00h,00h,00h,00h,0C3h,0C3h,0C3h,66h,3Ch,18h,00h,00h,00h   ; 76h
        db 77h, 00h,00h,00h,00h,00h,0C3h,0C3h,0DBh,0DBh,0FFh,66h,00h,00h,00h   ; 77h
        db 91h, 00h,00h,00h,00h,6Eh,3Bh,1Bh,7Eh,0D8h,0DCh,77h,00h,00h,00h   ; 91h
        db 9Bh, 00h,18h,18h,7Eh,0C3h,0C0h,0C0h,0C3h,7Eh,18h,18h,00h,00h,00h   ; 9Bh
        db 9Dh, 00h,00h,0C3h,66h,3Ch,18h,0FFh,18h,0FFh,18h,18h,00h,00h,00h   ; 9Dh
        db 9Eh, 00h,0FCh,66h,66h,7Ch,62h,66h,6Fh,66h,66h,0F3h,00h,00h,00h   ; 9Eh
        db 0F1h, 00h,00h,18h,18h,18h,0FFh,18h,18h,18h,00h,0FFh,00h,00h,00h   ; F1h
        db 0F6h, 00h,00h,18h,18h,00h,00h,0FFh,00h,00h,18h,18h,00h,00h,00h   ; F6h
        db 0
