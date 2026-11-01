# Builds the DOS tools for the Trio64V2/DX VBIOS project. Needs NASM 3.02 (the ROM build checks the result against a NASM 3.02 build).
# NASM: the assembler, nasm on the PATH or a path, for example make NASM=nasm/nasm-3.02/nasm (a relative
# path is made absolute, since the S3COMPAT rule runs in s3compat/). Every target uses it: the tools, the
# ROM build and the emulator tests.
NASM ?= nasm
NASMBIN := $(if $(findstring /,$(NASM)),$(abspath $(NASM)),$(NASM))
NASMVER := $(shell "$(NASMBIN)" -v 2>/dev/null)
ifeq ($(findstring version 3.02,$(NASMVER)),)
$(warning $(NASMBIN): $(if $(NASMVER),$(NASMVER),not found); the project uses NASM 3.02 (make NASM=path/to/nasm))
endif

# Versions come from common/version.inc; override for one build with
#   make clean && make VERSION=0.9 ROMVER=2.04.07-p13
DEFS :=
ifdef VERSION
DEFS += -DVERSION="'$(VERSION)'"
endif
ifdef ROMVER
DEFS += -DROMVER="'$(ROMVER)'"
endif
ifdef VROMVER
DEFS += -DVROMVER="'$(VROMVER)'"
endif
ifdef TROMVER
DEFS += -DTROMVER="'$(TROMVER)'"
endif

all: build/VSHOW.COM build/S3TEST.COM build/S3COMPAT.COM build/S3ALIAS.COM build/VGALOG.COM \
     build/S3REGS.COM build/S3REGS32.EXE build/RUNALL.BAT build/CLEAN.BAT build/ZIP.EXE

# runall.bat: VGALOG /M, S3REGS, S3TEST, S3COMPAT and VSHOW /R with /V and /S, S3REGS, VGALOG /D, then
# RUNALL.ZIP with Info-ZIP's zip (DOS line ends); clean.bat deletes what a run leaves behind
build/RUNALL.BAT: runall.bat | build
	cp $< $@

# Info-ZIP Zip 3.0, the 16-bit real-mode DOS build (ZIP16.EXE of the FreeDOS 1.3 package), for RUNALL.BAT;
# its licence is infozip/LICENSE
build/ZIP.EXE: infozip/ZIP.EXE | build
	cp $< $@

build/CLEAN.BAT: clean.bat | build
	cp $< $@

build:
	mkdir -p build

# common/ holds the /V debug log code shared by VSHOW, S3TEST and S3COMPAT
VDEBUG = common/vdebug.inc common/vdebug.mac common/version.inc common/chip.inc

build/VSHOW.COM: vshow/vshow.asm $(VDEBUG) | build
	"$(NASMBIN)" -f bin -icommon/ $(DEFS) -o $@ $<

build/S3TEST.COM: s3test/s3test.asm $(VDEBUG) | build
	"$(NASMBIN)" -f bin -icommon/ $(DEFS) -o $@ $<

# s3compat.asm includes vgaref.inc (reference tables) from its own folder
build/S3COMPAT.COM: s3compat/s3compat.asm s3compat/vgaref.inc $(VDEBUG) | build
	cd s3compat && "$(NASMBIN)" -f bin -i../common/ $(DEFS) -o ../$@ s3compat.asm

build/S3ALIAS.COM: s3alias/s3alias.asm common/version.inc | build
	"$(NASMBIN)" -f bin -icommon/ $(DEFS) -o $@ $<

build/VGALOG.COM: vgalog/vgalog.asm common/version.inc | build
	"$(NASMBIN)" -f bin -icommon/ $(DEFS) -o $@ $<

build/S3REGS.COM: s3regs/s3regs.asm common/version.inc common/chip.inc | build
	"$(NASMBIN)" -f bin -icommon/ $(DEFS) -o $@ $<

# Win32 console program for Windows 9x; the PE header is written in the source (no linker)
build/S3REGS32.EXE: s3regs/s3regs32.asm common/version.inc | build
	"$(NASMBIN)" -f bin -icommon/ $(DEFS) -o $@ $<

# Emulator tests (python3 with the unicorn package, see pyproject.toml):
#   make emu-test ROM=path/to/S3V2P15.BIN          every test with 2 MB, then the memory-size dependent
#                                                  ones (tag vram) again with 4 MB
#   make emu-test ROM=... VRAM=4                   every test with one size only (2 or 4 MB)
#   make emu-test ROM=S3VPP1.BIN CHIP=vplus        our Trio64V+ ROM on the Trio64V+ model (CHIP: the chip of
#                                                  the model, v2 by default; tests.py --chip); on the
#                                                  Trio64V+, Trio64 and Trio32 the vram tests run with
#                                                  1 MB too (cards sold with 1 MB, upgradable to 2 MB)
# Uses the virtual environment .venv when there is one, otherwise python3 (override with PYTHON=...).
PYTHON ?= $(if $(wildcard .venv/bin/python3),.venv/bin/python3,python3)
# emu-test runs this many tests at a time (default: every CPU; JOBS=1 for one after the other)
JOBS ?= $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
CHIP ?= v2
# the log folders of emu-test: $(LOGS) (2 MB), $(LOGS)4 (4 MB) and $(LOGS)1 (1 MB)
LOGS ?= emu/logs
# extra tests.py arguments for every run of emu-test, e.g. EMUARGS="--skip s3compat_full" (CI uses it to
# split the tests over parallel jobs)
EMUARGS ?=
emu-test: all
	@test -n "$(ROM)" || { echo "emu-test: set ROM to the 64 KB VBIOS image, e.g. make emu-test ROM=S3V2P15.BIN"; exit 2; }
ifdef VRAM
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs $(LOGS) -j $(JOBS) --chip $(CHIP) --vram $(VRAM) $(EMUARGS)
else
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs $(LOGS) -j $(JOBS) --chip $(CHIP) $(EMUARGS)
ifneq ($(CHIP),trio32)
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs $(LOGS)4 -j $(JOBS) --chip $(CHIP) --vram 4 -t vram $(EMUARGS)
endif
ifneq ($(filter vplus trio64 trio32,$(CHIP)),)
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs $(LOGS)1 -j $(JOBS) --chip $(CHIP) --vram 1 -t vram $(EMUARGS)
endif
endif

# Test coverage of the ROM code (needs capstone too: pip install .[coverage]); fails under 80 %
#   make coverage ROM=S3V2P15.BIN
#   make coverage ROM=S3VPP1.BIN CHIP=vplus
coverage: all
	@test -n "$(ROM)" || { echo "coverage: set ROM to the 64 KB VBIOS image"; exit 2; }
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs emu/logs --chip $(CHIP) --coverage emu/logs/COVER.BIN
	$(PYTHON) emu/codemap.py --rom "$(ROM)" --cover emu/logs/COVER.BIN --list --fail-under 80

# The S3 reference BIOS 2.04.07 (32 KB) in the repository: the default REF of 775-ref-compare and 775-rom-test
# and the default IN of rom; give REF=... or IN=... for another copy
REF ?= reference/v2/2_04_07.bin
IN ?= $(REF)

# EGA/CGA behaviour against the unpatched reference BIOS (AGENTS.md goal)
#   make 775-ref-compare ROM=S3V2P15.BIN [REF=REF2047.BIN]
775-ref-compare:
	@test -n "$(REF)" -a -n "$(ROM)" || { echo "775-ref-compare: set ROM (and REF, default reference/v2/2_04_07.bin)"; exit 2; }
	$(PYTHON) emu/refcompare.py --ref "$(REF)" --rom "$(ROM)"

clean:
	rm -rf build

# MCLK build option of 775-rom and 765-rom: MCLK = MHz for the memory type MEMTYPE (default edo1, 1-cycle EDO;
# fpm = fast page and 2-cycle EDO; sgram on the Trio64V2/GX), within the data book limits (rompatch/
# s3patch.py, rompatch/vplus/s3vpatch.py); without MCLK the default build
MCLKOPT = $(if $(MCLK),--mclk $(MCLK) $(if $(MEMTYPE),--memtype $(MEMTYPE)))

# ROM patcher (python3 and nasm): the current level from the S3 reference BIOS 2.04.07
#   make 775-rom OUT=S3V2P22.BIN [IN=REF2047.BIN] [MCLK=55 [MEMTYPE=edo1]]     (64 KB, the 32 KB twice)
#   make 775-rom-test [REF=REF2047.BIN] [STOCK=STOCK.BIN] [ROM=S3V2P15.BIN]
775-rom:
	@test -n "$(IN)" -a -n "$(OUT)" || { echo "775-rom: set OUT, e.g. make 775-rom OUT=S3V2P15.BIN (IN defaults to reference/v2/2_04_07.bin)"; exit 2; }
	python3 rompatch/s3patch.py --nasm "$(NASMBIN)" "$(IN)" -o "$(OUT)" $(MCLKOPT)

775-rom-test:
	@test -n "$(REF)" || { echo "775-rom-test: set REF (2.04.07, 32 KB, default reference/v2/2_04_07.bin); STOCK (the stock 64 KB dump) and ROM are optional"; exit 2; }
	python3 rompatch/test_s3patch.py --nasm "$(NASMBIN)" --ref "$(REF)" $(if $(STOCK),--stock "$(STOCK)") $(if $(ROM),--rom "$(ROM)")

# The Trio64V+ ROM (rompatch/vplus): the backport to the S3 Trio64V+ BIOS 1.03-08 in
# reference/64vplus/1_03_08.bin (VREF), docs/vplus-backport.md
#   make 765-rom OUT=S3VPP1.BIN [VREF=...] [VSIZE=64] [MCLK=55 [MEMTYPE=edo1]]   (32 KB; VSIZE=64: 64 KB, the 32 KB twice)
#   make 765-rom-test [VREF=...] [ROM=S3VPP1.BIN]
#   make 765-ref-compare ROM=S3VPP1.BIN [VREF=...]               (EGA/CGA behaviour against 1.03-08)
#   make emu-test ROM=S3VPP1.BIN CHIP=vplus [LOGS=emu/vlogs]
VREF ?= reference/64vplus/1_03_08.bin
VSIZE ?= 32
TSIZE ?= 64
765-rom:
	@test -n "$(OUT)" || { echo "765-rom: set OUT, e.g. make 765-rom OUT=S3VPP1.BIN (VREF defaults to reference/64vplus/1_03_08.bin)"; exit 2; }
	python3 rompatch/vplus/s3vpatch.py --nasm "$(NASMBIN)" --size $(VSIZE) "$(VREF)" -o "$(OUT)" $(MCLKOPT)

765-rom-test:
	python3 rompatch/vplus/test_s3vpatch.py --nasm "$(NASMBIN)" --ref "$(VREF)" --v2ref "$(REF)" $(if $(ROM),--rom "$(ROM)")

765-ref-compare:
	@test -n "$(ROM)" || { echo "765-ref-compare: set ROM (our Trio64V+ ROM; VREF defaults to reference/64vplus/1_03_08.bin)"; exit 2; }
	$(PYTHON) emu/refcompare.py --chip vplus --ref "$(VREF)" --rom "$(ROM)"

# The Trio64 ROM (rompatch/trio64): built on the Phoenix S3 Trio64 BIOS 1.5-07 in reference/trio64/1_5_07.bin
# (TREF; another card's 1.5-07 build is accepted too), docs/trio64-backport.md
#   make 764x-rom OUT=S3T64P3.BIN [TREF=...] [TSIZE=32] [MCLK=55]   (64 KB, the 32 KB twice; TSIZE=32: 32 KB)
#   make 764x-rom OUT=S3T64P3.BIN MCLK=69.8   (up to 70 MHz, the Trio64 limit of our tools; the data book gives 60)
#   make 764x-rom OUT=S3T64OC.BIN MCLK=85 OVERCLOCK=1   (above 70 MHz, at most 100 MHz)
#   make 764-rom-test [TREF=...] [ROM=S3T64P3.BIN]
#   make 764-ref-compare ROM=S3T64P3.BIN [TREF=...]              (EGA/CGA behaviour against 1.5-07)
#   make emu-test ROM=S3T64P3.BIN CHIP=trio64 [LOGS=emu/tlogs]
TREF ?= reference/trio64/1_5_07.bin
# 764x-rom is for the 86C764X (Trio64 PnP, MCLK 55-70 MHz), 764p-rom for the 86C764-P (50-60 MHz): the same
# ROM, only the MCLK range the build option accepts differs (T64-MEM-7); without MCLK the two are identical.
764x-rom 764p-rom:
	@test -n "$(OUT)" || { echo "$@: set OUT, e.g. make $@ OUT=S3T64P3.BIN (TREF defaults to reference/trio64/1_5_07.bin)"; exit 2; }
	python3 rompatch/trio64/s3tpatch.py --nasm "$(NASMBIN)" --size $(TSIZE) --model $(subst -rom,,$@) "$(TREF)" -o "$(OUT)" $(if $(MCLK),--mclk $(MCLK) $(if $(OVERCLOCK),--overclock))

764-rom-test:
	python3 rompatch/trio64/test_s3tpatch.py --nasm "$(NASMBIN)" --ref "$(TREF)" --vref "$(VREF)" $(if $(ROM),--rom "$(ROM)")

764-ref-compare: | build
	@test -n "$(ROM)" || { echo "764-ref-compare: set ROM (our Trio64 ROM; TREF defaults to reference/trio64/1_5_07.bin)"; exit 2; }
	python3 rompatch/trio64/s3tpatch.py --fonts-only --fonts "$(VREF)" "$(TREF)" -o build/T64FONTS.BIN
	$(PYTHON) emu/refcompare.py --chip trio64 --ref build/T64FONTS.BIN --rom "$(ROM)"

# All four chips' ROMs, each at its memory clocks, into build/roms/<chip>-<level>/ (level from
# common/version.inc) with 8.3 names for a DOS disk: the chip code, M and the clock, for example
# build/roms/775-P22/775M60.BIN, build/roms/764X-P3/764XM70.BIN. On the 775 and 765 the clock goes into the
# edo1 entry (MEMTYPE; 1-cycle EDO), on the 764 models into their one entry. The images keep each target's
# size (775 and 764 64 KB, 765 VSIZE).
#   make roms [CLOCKS_775="50 55 60"] [CLOCKS_765=...] [CLOCKS_764X="55 60 70"] [CLOCKS_764P="50 55 60"]
CLOCKS_775 ?= 50 55 60
CLOCKS_765 ?= 50 55 60
CLOCKS_764X ?= 55 60 70
CLOCKS_764P ?= 50 55 60
level = $(shell sed -n "s/^%define $(1) '.*-\(p[0-9]*\)'.*/\1/p" common/version.inc | tr a-z A-Z)
ROMDIR_775 = build/roms/775-$(call level,ROMVER)
ROMDIR_765 = build/roms/765-$(call level,VROMVER)
ROMDIR_764X = build/roms/764X-$(call level,TROMVER)
ROMDIR_764P = build/roms/764P-$(call level,TROMVER)
roms:
	@mkdir -p $(ROMDIR_775) $(ROMDIR_765) $(ROMDIR_764X) $(ROMDIR_764P)
	@set -e; \
	for m in $(CLOCKS_775); do $(MAKE) --no-print-directory 775-rom OUT=$(ROMDIR_775)/775M$$m.BIN MCLK=$$m; done; \
	for m in $(CLOCKS_765); do $(MAKE) --no-print-directory 765-rom OUT=$(ROMDIR_765)/765M$$m.BIN MCLK=$$m; done; \
	for m in $(CLOCKS_764X); do $(MAKE) --no-print-directory 764x-rom OUT=$(ROMDIR_764X)/764XM$$m.BIN MCLK=$$m; done; \
	for m in $(CLOCKS_764P); do $(MAKE) --no-print-directory 764p-rom OUT=$(ROMDIR_764P)/764PM$$m.BIN MCLK=$$m; done
	@ls -lR build/roms

.PHONY: all clean emu-test 775-rom roms 775-rom-test coverage 775-ref-compare 765-rom 765-rom-test 765-ref-compare 764x-rom 764p-rom 764-rom-test 764-ref-compare
