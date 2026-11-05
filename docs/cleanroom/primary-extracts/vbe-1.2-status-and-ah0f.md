# VBE 1.2 (VS911022): status, AH=0Fh advice, ModeAttributes (extract)

Source: VESA Super VGA BIOS Extension Standard VS911022, 22 October 1991
(VBE version 1.2), retyped text
[`standards/vesa/vbe12.txt`](../../../standards/vesa/vbe12.txt). Used for
part C returned generalizations (status / failure, AH=0Fh reinit advice,
ModeAttributes D0) and related VBE- rows.

ASCII paraphrase. Prefer `vbe12.txt` on any conflict. Section numbers below
match that retype (chapter 3 compatibility note; 6.1 status; 6.3 mode info).

## Compatibility with VGA BIOS AH=00h / AH=0Fh (chapter 3)

VESA-aware applications set and query Super VGA modes with VBE 02h and 03h,
not with VGA BIOS 00h or 0Fh.

VESA-unaware applications (old pop-up programs, other TSRs, MS-DOS CLS) may
call VGA BIOS 0Fh to read the present mode and later call VGA BIOS 00h to
restore or reinitialize that mode.

VESA recommends that whatever value 0Fh returns (the OEM defines the number)
be usable to reinitialize the video mode through VGA BIOS 00h. The BIOS
should therefore keep track of the last Super VGA mode in effect.

It is recommended, but not mandatory, to support output functions (TTY
output, scroll, set pixel, and so on) in Super VGA modes. If the BIOS
extension does not support those output functions, ModeAttributes bit D2
(returned by VBE 01h) should be clear.

## 6.1 Status information

Every VBE function returns status in AX:

| Condition | Value |
| --- | --- |
| Function is supported | AL == 4Fh |
| Function is not supported | AL != 4Fh |
| Function call successful | AH == 00h |
| Function call failed | AH == 01h |

Software should treat a non-zero AH as a general failure. Later VBE versions
may define further error codes.

## 6.3 ModeAttributes (4F01h ModeInfoBlock)

Bit D0: mode supported in hardware for the present video configuration
(0 = not supported; 1 = supported). May block a mode that needs a monitor
type that is not connected.

From VBE 1.2, every ModeInfoBlock field must hold valid data except the
Direct Color fields, which are valid only when MemoryModel is 6 (Direct
Color) or 7 (YUV). Bit D1 is reserved and must be set to 1. Bit D2 marks
BIOS support for standard output functions in the mode.

| Bit | Meaning |
| --- | --- |
| D0 | 1 = mode supported in hardware |
| D1 | 1 (reserved) |
| D2 | 1 = output functions supported by BIOS |
| D3 | 1 = color mode; 0 = monochrome |
| D4 | 1 = graphics mode; 0 = text mode |
| D5-D15 | Reserved |

## Related fields cited with D0 returns

- WinFuncPtr: dword pointer to the window function in the ModeInfoBlock
  (used with the window attribute / granularity / size / segment fields).
- Function 03h returns the current VESA mode in BX; unlike VGA 0Fh it does
  not return the memory-clear bit in that word (call VGA 0Fh for that bit).
