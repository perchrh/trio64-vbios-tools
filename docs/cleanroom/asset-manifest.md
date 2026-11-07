# Incorporated assets (clean ROM)

Manifest of third-party material that may ship with a clean-room Trio64 video BIOS.
Owner decision of 5 November 2026 ([#145](https://github.com/perchrh/trio64-vbios-tools/issues/145)):
the font set is **closed** for this project. Not legal advice.

## Fonts (Joseph Gil FNTCOL16)

| Asset | Path | Role |
| --- | --- | --- |
| Source bitmap fonts (unmodified) | [`src/roms/fonts/VGA-ROM.F08`](../../src/roms/fonts/VGA-ROM.F08), [`VGA-ROM.F14`](../../src/roms/fonts/VGA-ROM.F14), [`VGA-ROM.F16`](../../src/roms/fonts/VGA-ROM.F16), [`PP_ROMAN.F16`](../../src/roms/fonts/PP_ROMAN.F16), [`STANDARD.F14`](../../src/roms/fonts/STANDARD.F14) | Gil FNTCOL16 v1.6 individual fonts |
| Gil notice | [`src/roms/fonts/COPYLEFT.TXT`](../../src/roms/fonts/COPYLEFT.TXT) | preserved with the files |
| Build | [`src/roms/fonts/fonts.py`](../../src/roms/fonts/fonts.py) | builds the five ROM tables from those files |
| Description | [`src/roms/fonts/README.md`](../../src/roms/fonts/README.md) | how 8-dot / 9-dot tables are composed |

**Decision.** Use Gil's individual fonts (his notice: public domain / free to use) and **generate
the ROM tables at build time** from them (`fonts.py`: main 8x8 / 8x14 / 8x16 tables plus the 9x14
and 9x16 alternate tables). No font bytes are taken from a BIOS image or from another project's
source. That set is the complete text-mode font package for the clean ROM; FreeDOS cpidos is no
longer the named alternative for this project.

**Licence posture (project).** Gil's `COPYLEFT.TXT` is kept intact. The compilation notice stays with
the folder; the individual bitmaps are used under the terms stated there. The generated tables are
outputs of our build script from those sources, not a redistributed Gil archive entry under a new
name.

**Implementation.** Already on the dirty side for all three patched ROMs (#141; patchers call
`fonts.py`). The clean side receives the same `src/roms/fonts/` tree (files + `COPYLEFT.TXT` +
`fonts.py`) after allowlist export.

**Note.** The glyphs match IBM VGA / historical S3 tables byte for byte (documented in the fonts
README). The owner treats Gil's notice as sufficient project provenance for a permissive release;
distribution questions outside that notice remain ordinary release diligence, not an open clean-room
blocker.
