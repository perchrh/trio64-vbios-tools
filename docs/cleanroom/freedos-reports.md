# FreeDOS defect reports (drafts)

Ready-to-file texts for the two FreeDOS defects summarised in [freedos-1.4.md](freedos-1.4.md), "Defects found
in FreeDOS". Not yet filed; tracked in issue #103.

## Report 1: https://gitlab.com/FreeDOS/base/more/-/issues

**Title:** MORE shows too many lines per page when the BIOS page size at 0040:004Ch is rounded up (132x25, 80x50)

`GetScreenSize()` in `SOURCE/MORE/MORE.C` takes the number of lines from the regen buffer size:

    LINES = bios_screensize / bios_screencols / 2;   /* 0040:004Ch / 0040:004Ah / 2 */

The page size is not rows x columns x 2 on most BIOSes; it is rounded up. IBM's VGA BIOS uses 4096 for
80x25, which works only because the 96 spare bytes are less than one line. Elsewhere the result is too
large:

| Screen | 0040:004Ch | MORE computes | Rows |
| --- | --- | --- | --- |
| 80x50 (MODE CON LINES=50, AX=1112h) | 8192 or 8256 | 51 | 50 |
| 132x25 (VBE 109h, S3 BIOSes) | 8192 | 31 | 25 |
| 132x43 (VBE 10Ah, S3 BIOSes) | 16384 | 62 | 43 |

SeaVGABIOS rounds text pages up to 2 KB (`calc_page_size`), so it gives the same 8192 for 132x25.
MORE then scrolls lines off the top before it prompts.

Suggested fix: take the rows from 0040:0084h + 1, which every EGA and VGA BIOS keeps right after mode sets
and font loads (MODE, EDIT and the kernel already use it), and fall back to 25 when it reads 0. Checked on
the FreeDOS 1.4 tag and on master (2026-03-13); the function is unchanged.

## Report 2: https://gitlab.com/FreeDOS/base/mode/-/issues

**Title:** MODE's VESA text mode search uses `xcols`/`xlines` uninitialised when 4F01h fails for the current mode

In `SOURCE/MODE/MODEVGA.C`, the VESA path (used for `MODE CON COLS=132`, `LINES=30/34/60`) declares
`unsigned int i, xcols, xlines;` and sets `xcols`/`xlines` only inside

    if ( (r.x.ax == 0x004f) && ((vesabuffer[0] & 0x16) == 0x06) ) { ... }

after AX=4F01h with CX = the current mode (from 4F03h, normally 0003h). The first search pass then
compares every listed mode with `xcols`/`xlines`. When 4F01h for the current mode fails, or the current
mode is not a text mode, both are uninitialised: the first pass may skip the right mode, or, if the stack
happens to hold 0, accept the first text mode in the list whatever its size.

4F01h for mode 03h does fail on real BIOSes: VBE 1.2 defines 4F01h for "one of those returned by
Function 0", and S3 BIOSes (Trio64 family, measured in an emulator) answer 014Fh for 0003h, which is not
in their list.

Suggested fix: initialise `xcols = cols; xlines = lines;` before the 4F01h call for the current mode, so
a failed call means "only the requested dimensions matter", as the second pass already does. Checked on
the FreeDOS 1.4 tag and on master (2026-04-11); the code is unchanged.
