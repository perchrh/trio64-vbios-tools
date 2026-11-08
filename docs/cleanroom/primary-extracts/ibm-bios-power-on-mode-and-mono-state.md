# IBM BIOS reference: power-on mode by display type, monochrome state (extract)

Source: IBM "Personal System/2 and Personal Computer BIOS Interface Technical Reference",
April 1987, the owner's copy (readings.md row 8; an epub text conversion provided by the
owner on 8 November 2026, lightly OCR-corrected here). A scanned copy is at the Internet
Archive: [archive.org/details/bitsavers_ibmpcps2PSTechnicalReferenceApr87_5816663](https://archive.org/details/bitsavers_ibmpcps2PSTechnicalReferenceApr87_5816663). Not in the repository. Kept for
milestone 5, the monitor sense (decisions M-SENSE): it states the power-on contract and
the software-visible monochrome state that a sense result feeds.

## Power-on default mode by display type (Figure 2-4 notes, item 5, page 2-13)

Verbatim, for Personal System/2 products except Model 30:

> c. The power-on default mode with a color display attached is 3.
> d. The power-on default mode with a monochrome display attached is 7.

So the power-on mode is chosen by the type of display attached: mode 03h on a colour
display, mode 07h on a monochrome display. The book states nothing for no display
attached; that case was a project decision for milestone 5 and is now decided (8 November
2026, decision M5-NODISP in [`../decisions-milestones-1-4.md`](../decisions-milestones-1-4.md)):
no monitor detected means behave exactly as on a colour monitor.

## The monochrome state is software-visible

- **INT 10h AH=12h BL=10h** (Return EGA information), page 2-32: "(BH) = 00H - Color
  mode in effect (30x address range), = 01H - Monochrome mode in effect (3Bx address
  range)". Software asks which of the two is active.
- **INT 10h AH=1Bh** (functionality/state information), state block byte DI+2DH,
  page 2-41: "Bit 2 = 1 - Monochrome display attached, Bit 1 = 1 - Summing active,
  Bit 0 = 1 - All modes on all displays active". The same bits the BIOS data area
  holds at 0040:0089h (bios-rules BDA-16).
- **INT 11h / BIOS data area 40:10h**, page 2-46: the equipment word "is set during
  the POST"; bits 5-4 are the video mode type (01 = 40x25 color, 10 = 80x25 color,
  11 = 80x25 monochrome).

## Grey summing

- **INT 10h AH=12h BL=33h** (Summing to gray shades), page 2-34: "(AL) = 0 - Enable
  summing, = 1 - Disable summing", with the note: "When enabled, summing occurs
  during (AH) = 00H (Set Mode) color register loading and (AH) = 10H (Set Palette
  Registers)."
- **INT 10h AH=10h AL=1Bh** (Sum color values to gray shades), page 2-22: "This call
  reads red, green, and blue values found in color registers, performs a weighted sum
  (30% red + 59% green + 11% blue), then writes the result into each red, green, and
  blue component of the color register (original data is not retained)."

## What the book does not define

- The sense procedure itself (which outputs to drive and with what DAC values): the
  book is a BIOS interface reference, not POST internals. That comes from the S3
  books: the procedure and classification from
  [`vision964-sense-input-utilization.md`](vision964-sense-input-utilization.md), the
  mechanism and threshold from the Trio32/64 data book section 8.4.
- The bit definitions of 0040:0087h and 0040:0088h: the book lists both as "Video
  Control States" (page 3-9) without bit definitions, and 0040:0089h as "Reserved".
  The bit detail the project uses comes from RBIL and VGADOC (bios-rules BDA-14,
  BDA-16), which rank below this book but are the only public sources stating the
  bits. RBIL is in the repository since 8 November 2026:
  [`standards/rbil-all/MEMORY.LST`](../../../standards/rbil-all/MEMORY.LST), tables
  M0024 (0040:0087h, bit 1 "mono monitor"), M0025/M0026 (0040:0088h) and M0027
  (0040:0089h, bit 2 "mono display", bit 1 "gray scale summing enabled").
- The behaviour with no display attached: nothing in the book; decided as M5-NODISP (8
  November 2026): behave exactly as on a colour monitor.
