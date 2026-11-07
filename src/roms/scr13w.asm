; The window path of the 32-bit mode 13h scroll as a block of its own, at SCR13W of bios.inc (the
; Trio64 build, where no free block holds all of scr13.asm); scr13 jumps here (scr13w.inc).
bits 16
cpu 386
%include "bios.inc"
org SCR13W

scr13w:
%include "scr13w.inc"
