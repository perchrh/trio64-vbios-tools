# Info-ZIP Zip for DOS

`ZIP.EXE` is Info-ZIP's Zip 3.0, the 16-bit real-mode DOS build (`BIN/ZIP16.EXE` of the FreeDOS 1.3
package `archiver/zip.zip`, from the FreeDOS repository at ibiblio.org), unchanged apart from its
name. `make` copies it to `build/ZIP.EXE`, next to `RUNALL.BAT`, which packs a run's logs into
RUNALL.ZIP with it. It runs on plain DOS and in a Windows DOS box without a DOS extender.

`LICENSE` is the Info-ZIP licence (version 2007-Mar-4), which allows passing on the program in
binary form when the licence text goes with it. The source code is at http://infozip.sourceforge.net/.
