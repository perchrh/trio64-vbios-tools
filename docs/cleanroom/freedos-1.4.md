# FreeDOS 1.4: what it asks of the video BIOS

The compatibility target of the clean ROM's milestone 6, tentative since 2 November 2026 ([`docs/clean-room.md`](../clean-room.md) "Decisions of 2 November 2026"). From a reading of the
FreeDOS 1.4 sources (GitLab group FreeDOS, tag `FreeDOS-v1.4` where it exists; the installer FDI and its
language scripts from their default branches; EDIT's console code from its `unstable` branch, since the
1.4 tag lacks it), 1 November 2026. Nothing was built or run. The sources are GPL, BSD or MIT: their
behaviour is a public fact and this file may cross to the clean side; their code may not go into a
public-domain ROM.

What runs at boot and install: the installer calls `vmode /p 0` (V8Power) on every screen clear, and for
other languages `vfont`; the installed AUTOEXEC loads `fdapm APMDOS` and `ctmouse`; other languages add
`DISPLAY CON=(EGA,,1)` and `MODE CON CP PREP/SEL/REFRESH`.

## Requirements, by how many packages use them

| # | Requirement | Used by |
| --- | --- | --- |
| FD-1 | BDA 0484h (rows - 1) right after every mode set, font load (AX=1111h/1112h/1114h) and VBE text mode | CTMOUSE, MODE, DISPLAY, NANSI, V8Power, FreeCOM, EDIT, HTMLHELP, FDISK, kernel |
| FD-2 | AH=0Fh: AL the mode with bit 7 clear in normal use, AH the columns, BH the page | V8Power, MODE, FreeCOM, EDIT, HTMLHELP, FDISK, GRAPHICS, kernel |
| FD-3 | AH=00h, also as a hook target: CTMOUSE and DISPLAY call the BIOS, then read 0449h, 0484h and 0485h | V8Power, MODE, NANSI, EDIT, HTMLHELP, kernel; CTMOUSE, DISPLAY |
| FD-4 | AH=11h: AX=1111h/1112h/1114h with BL=0, 1100h and 1110h (user font), 1101h/1102h/1104h, 1121h-1124h, 1130h with BH=2, 3, 4, 6 | MODE, V8Power, NANSI, EDIT, kernel, DISPLAY, vfont |
| FD-5 | BDA 044Ah columns (EDIT and the kernel read the low byte only) | CTMOUSE, NANSI, V8Power, FreeCOM, EDIT, MORE, kernel |
| FD-6 | AH=01h, 02h, 03h; AH=01h with CGA-style shapes (0607h, 0107h, 0707h) and the BIOS's cursor emulation for 14- and 16-line cells; AH=03h returns the shape as set | V8Power, NANSI, FreeCOM, EDIT, HTMLHELP, FDISK, CTMOUSE, kernel |
| FD-7 | AH=12h BL=10h in EGA form (BH, BL, CX changed) | MODE, NANSI, EDIT, FDISK, FDAPM, DISPLAY |
| FD-8 | Direct text memory at B800h/B000h, at offset 0 or 044Eh; A000h in the graphics modes | CTMOUSE, NANSI, EDIT, HTMLHELP, FDISK, GRAPHICS |
| FD-9 | AX=1A00h: AL=1Ah, BL=08h; cheap and without side effects (EDIT calls it at every screen height lookup) | CTMOUSE, MODE, DISPLAY, EDIT, FDAPM |
| FD-10 | BDA 0463h (CRTC port), 0485h (cell height: `vfont /f16` loads only at 16), 0462h (page), 044Eh (start), 0450h (cursors) | CTMOUSE, NANSI, MODE, FDAPM, V8Power, DISPLAY, FreeCOM |
| FD-11 | AH=06h/07h; AH=08h, 09h, 0Ah; AH=0Eh (all kernel console output); AH=05h (V8Power on every installer screen) | V8Power, NANSI, FreeCOM, EDIT, kernel, FDISK, MODE |
| FD-12 | AH=12h BL=30h (350 or 400 lines, AL=12h back); BL=36h (screen off/on); BL=20h (alternate print screen) | MODE, EDIT; FDAPM; NANSI |
| FD-13 | VBE: 4F00h with version 1.2 or later (MODE), at every `vmode` call (V8Power) and with a 'VBE2' stamp (FDAPM); 4F03h returning the VGA mode number below 100h in a VGA mode; 4F01h and 4F02h | MODE, V8Power, FDAPM; 4F02h hooked by CTMOUSE and DISPLAY |
| FD-14 | MODE's 132 columns: it takes every listed mode whose 4F01h attributes say text with BIOS output (`attributes AND 16h = 06h`; bit 0 is not checked, so list only modes the hardware has), compares the low bytes of XResolution and YResolution with columns and rows, and sets it with 4F02h. It reaches 109h (132x25), 10Ah (132x43), 10Bh (132x50), 10Ch (132x60) and 108h (80x60) | MODE |
| FD-15 | MODE also calls 4F01h for the current mode, normally 03h; if that fails, it uses two variables uninitialised (a MODE bug). A 4F01h answer for the VGA text modes (attributes 07h, XResolution 80, YResolution the rows) avoids it | MODE |
| FD-16 | Real VGA registers that read back: GRC 3, 4, 5, 8 (CTMOUSE's graphics cursor, which also keeps the screen under it in off-screen memory inside A000h-AFFFFh), GRC 6 (DISPLAY), SEQ 01h and CRTC 17h (FDAPM), CRTC 0Fh on 3B4h and 3D4h (MODE), 3DAh (EDIT) | CTMOUSE, DISPLAY, FDAPM, MODE, EDIT |
| FD-17 | 044Ch close to rows x columns x 2 (MORE computes its lines from it); 0465h bit 5 mirrors the blink state (FDISK); 0466h (GRAPHICS) | MORE, FDISK, GRAPHICS |
| FD-18 | AX=1003h (FDISK); AX=1009h, 1015h, AH=0Dh (GRAPHICS reads the palette and pixels) | FDISK, GRAPHICS |
| FD-19 | INT 10h AH=F4h/F5h (EGA Register Interface): CTMOUSE as shipped (RIL code not built) still calls them in modes 0Dh-12h; the BIOS must return with no side effect and every register kept | CTMOUSE |
| FD-20 | AX=4F10h (DPMS): FDAPM calls it and ignores the result; it also always switches the screen with AH=12h BL=36h, SEQ 01h bit 5 and CRTC 17h bit 7 | FDAPM |

Not used by anything found: AH=1Bh, AH=1Ch, the save pointer table at 04A8h.

## FreeDOS use cases we support (decision of 1 November 2026)

For the clean ROM, and for our patched ROMs where the space allows:

- `MODE CON COLS=132` with `LINES=25`, `43`, `50` and `60`, and `MODE CON LINES=60` (80x60): the VBE
  text modes 109h, 10Ah, 10Bh, 10Ch and 108h, listed and answered by 4F01h as FD-14 describes.
- CTMOUSE with a visible mouse cursor in those modes, so the number 0449h holds there must be one
  CTMOUSE takes as text (below).
- MORE and MODE as they are; their own defects in this area are reported to FreeDOS (below), and the
  ROM does not work around them.

## Defects found in FreeDOS (master of April 2026 unchanged since 1.4)

The texts to file on FreeDOS's GitLab are issues #266 (MORE) and #267 (MODE) on this repository's GitHub
(they were drafted in the since-removed freedos-reports.md, #125).

- **MORE** (`base/more`, `MORE.C`, `GetScreenSize`): the line count is the page size at 0040:004Ch
  divided by 2 x columns. A BIOS that rounds the page size up (IBM's 4 KB pages, SeaVGABIOS's 2 KB
  rounding) gives too many lines: 31 on a 132x25 screen (8192 bytes), 51 on an 80x50 screen (8192 or
  8256 bytes). BDA 0484h (rows - 1) is the number to use; it is right on every EGA and VGA BIOS.
- **MODE** (`base/mode`, `MODEVGA.C`, the VESA path): `xcols` and `xlines` are set only when 4F01h
  for the current mode succeeds and describes a text mode. A BIOS that answers 4F01h only for the modes
  in its VBE list (VBE 1.2: "mode number must be one of those returned by Function 0"), which is every
  S3 BIOS measured, leaves them uninitialised in the first search pass.



CTMOUSE, NANSI, HTMLHELP and V8Power take only modes 00h-03h and 07h in 0449h as text. With any other number
CTMOUSE draws no mouse cursor, NANSI falls back to slow BIOS output, and HTMLHELP resets the screen to mode
03h. VBE 1.2 asks that AH=0Fh return a number with which AH=00h sets the mode again, which a 132-column mode
cannot share with 03h. Open question for the specification (part C): which number 0449h holds in 108h-10Ch,
and whether FreeDOS's behaviour there is accepted. Answered below and in issue #103: the OEM or VBE
number is allowed (VBE 1.2 chapter 3 leaves it to the OEM), and FreeDOS's behaviour is accepted as far
as the IBM PS/2 book goes; what is missing on the FreeDOS side is a VBE-based text test for those
numbers.

## The 0449h number in the VBE text modes (issue #103), 13 November 2026

Findings for the later FreeDOS experiment (milestone 6), recorded in full in issue #103. Sources: the
standards in [../../standards/](../../standards/) and the FreeDOS sources at https://gitlab.com/FreeDOS
(master, re-read 2026-11-13).

### What the standards say

- IBM PS/2 and PC BIOS Interface Technical Reference (Apr 87,
  [`standards/PS2_and_PC_BIOS_Interface_Technical_Reference_Apr87.epub`](../../standards/PS2_and_PC_BIOS_Interface_Technical_Reference_Apr87.epub)):
  Fig. 2-3 defines modes 00h-13h
  with the text (A/N) modes 00h-03h and 07h, and nothing above 13h. INT 10h AH=0Fh returns "mode
  currently set" per the AH=00h table; the BIOS data area lists 40:49 as "Display Mode set" with no
  range restriction. The book is silent on OEM modes, so neither our ROMs nor the FreeDOS programs
  violate a written IBM rule there. For IBM modes the FreeDOS test "text iff 0449h in 00h-03h/07h" is
  exactly right (43/50-line text still reports 03h: font loads change the rows, not the number).
- VBE 1.2 (VS911022, [`standards/vesa/vbe12.txt`](../../standards/vesa/vbe12.txt)): chapter 3 -
  VESA-unaware TSRs call VGA 0Fh and later
  00h, and VESA recommends that whatever 0Fh returns ("it is up to the OEM to define this number") be
  usable with AH=00h to set the mode again; our ROMs satisfy this by storing the S3 number that AH=00h
  re-sets (storing 03h would break the recommendation). Function 03h returns the current VESA mode in
  BX; 6.3 ModeAttributes D4 = 0 text / 1 graphics, D2 = BIOS output functions supported. In Super VGA
  modes the authoritative text test is therefore 4F03h + 4F01h D4, not 0449h.

Verdict: the ROM side is conformant; the FreeDOS programs are incomplete against VBE 1.2, not wrong
against the IBM book. This answers the open question in [spec-c-vbe.md](spec-c-vbe.md) part C item 1:
0449h may hold the OEM/VBE number in 108h-10Ch.

### Why FreeDOS does not auto-detect today

NANSI has had the `/Tnn` switch since 1991 (revision 1.8, "tell nansi about new text modes") precisely
for non-IBM text modes; its documentation says the default table marks only 00h-03h and 07h as text,
"Worse yet, BIOS can't tell you what kind of mode it's in", and ships per-card examples (`/t54`-/`t57`
Paradise, `/t4F`-/`t51` OTI-067, `/t50`-/`t5A` Trident TVGA8900 - OEM text numbers of the 54h/55h class
our ROMs store). Its source notes that without `/T` it "may think VESA text is gfx". CTMOUSE's
`@setvideo` has the same static table (modes 0-3/7 text, other graphics) and hooks 4F02h but still
classifies by the 0449h number. The reasons are still valid: the table is consulted per character in a
resident hot loop, and real VBE 1.2 VBIOSes are unreliable (our record: #73, #108, #267, and a VBE 1.2
card that hangs in 4F02h, [../764-rom.md](../764-rom.md)). MODE is the one place that safely uses 4F01h
attributes, because it runs as a user command, not resident. The user-side workaround needs no code
change: `NANSI.SYS /T54 /T55` for the S3 numbers, `/T109 /T10A` for VBE-compliant BIOSes.

### Proposed FreeDOS-side fix (for the experiment; additive and fail-closed)

In CTMOUSE, NANSI, HTMLHELP and V8Power, keep the existing legacy test first, unchanged; only when 0449h
is not 00h-03h/07h, call 4F03h, and if BX (bit 14 masked off, the LFB bit) is >= 0100h, call 4F01h for
it and take the mode as text iff ModeAttributes D4 = 0 (plus D2 where BIOS output matters). Check
AL = 4Fh after both calls, give 4F01h an ES:DI 256-byte buffer, preserve all registers, run the probe
once per mode change (CTMOUSE's existing 4F02h hook or `@setvideo`), never per character or per
interrupt, and treat any failure as today's answer.

Safety: on every BIOS that stores 00h-03h/07h the legacy test returns before any VBE call, so the code
path, the INT 10h call count and the result are identical to the current binaries; on a VBE 1.x BIOS
(AL != 4Fh) or in a standard VGA mode (BX < 0100h) the answer is the same as today; in a VBE graphics
mode D4 is set, still not text. The only changed outcome is this issue's case: a non-legacy number in
0449h while the current mode is a VBE text mode (our 54h/55h/19h/1Ah, or 108h-10Ch on VBE-compliant
BIOSes).

Cross-references: issue #103 (self-contained description), #266 and #267 (the MORE and MODE defects,
filed from the removed freedos-reports.md by PR #268), #265 (the missing 108h/10Bh/10Ch modes).

## Our ROMs against these (emulator, 1 November 2026)

Trio64 1.5-07-p3, Trio64V+ 1.03-08-p1 and Trio64V2 2.04.07-p22 (builds with this machine's NASM 2.16; the
Trio64 one fails its pinned SHA, the others are MCLK=55 builds), Trio64/V+/V2 register models, 2 MB:

| Check | All three ROMs | Requirement |
| --- | --- | --- |
| AX=1A00h | AL=1Ah, BL=08h | FD-9: met |
| VBE text modes listed | 109h and 10Ah only | FD-14: `COLS=132 LINES=50` and `LINES=60` find no mode |
| 4F01h for mode 03h | 014Fh | FD-15: MODE's uninitialised-variable path |
| 4F03h in mode 03h | BX=0003h | FD-13: met |
| 0449h after 4F02h 109h / 10Ah | 55h / 54h (Trio64, V+), 19h / 1Ah (V2) | CTMOUSE draws no cursor, NANSI and HTMLHELP as above |
| 044Ch in 109h / 10Ah | 8192 / 16384 against 6600 / 11352 | FD-17: MORE counts 31 and 62 lines on a 25- and 43-line screen |
| 044Ch after AX=1112h in mode 03h | 8256 (50 lines: 8000) | FD-17: MORE computes 51 lines; to compare with IBM's value before calling it ours |
| AH=F4h in mode 12h | AX, BX, CX, DX returned as given | FD-19: met |

Not checked here: the cursor emulation, AH=12h BL=30h with 1112h, and everything on a card. The card check
of that milestone is FreeDOS 1.4 itself.
