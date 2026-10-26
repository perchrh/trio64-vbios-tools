# Trio64V2/DX VBIOS test tools

DOS tools written while modifying the video BIOS of a Gainward S3 Trio64V2/DX card
(86C775, 2 MB EDO, board ICUVGA-GW503A). The current ROM is 2.04.11-p9.
All tools need a 386 or later and run in plain DOS (no EMM386 needed).

| Tool | Purpose | Run |
| --- | --- | --- |
| VSHOW.COM 2.2 | VESA mode viewer: test picture, measured refresh and line frequency, LCD line pattern, interactive menu, run through all modes | `VSHOW /H` for the parameter list |
| S3TEST.COM | Regression test for the ROM patches (signature, clocks, EDO, pedestal, refresh, booster, LFB, 4F05/4F06, CR50, flip-flop) | `S3TEST > S3TEST.LOG` |
| S3COMPAT.COM 1.7 | VGA/SVGA/VESA compatibility test: IBM reference registers, VGA BIOS functions, every VESA mode, datasheet rules, VRAM | `S3COMPAT > S3COMPAT.LOG` (`/Q` skips the VRAM test, `/I` pauses per mode) |

S3TEST checks for the ROM signature `2.04.11-p9`; change the two strings and the
`cmp word [si+8],'p9'` line in `s3test/s3test.asm` for another version.

## Building

NASM 2.x (tested with 2.16.01):

    make            # Linux, macOS, WSL
    build.bat       # DOS or Windows with nasm.exe on the PATH

The .COM files land in `build/`.

## S3COMPAT reference data

`s3compat/vgaref.inc` is generated and committed, so a normal build needs nothing else.
It holds the standard VGA register values per mode (from the ROM's VGA parameter table,
which matches IBM byte for byte) and IBM's INT 10h AH=1Bh state blocks. To regenerate it:

    cd s3compat
    python3 gen_vgaref.py <ROM image> <folder with CRTC.COL GENERAL.COL DSTATE.COL>

`s3compat/dac_col.bin` is IBM's default 256-colour DAC table (DAC.COL).
The `.COL` files come from VGATEST (Kent Quirk and Ed McNierney, PC Tech Journal,
November 1988, Copyright 1988 Ziff Communications Co.); check that their terms suit
your repository before publishing it.
