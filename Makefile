# Builds the DOS tools and the patched ROMs for the Trio64V2/DX VBIOS project. Needs NASM 3.02
# (the ROM build checks the result against a NASM 3.02 build).
# NASM: the assembler, nasm on the PATH or a path, for example make NASM=nasm/nasm-3.02/nasm (a relative
# path is made absolute, since the S3COMPAT rule runs in src/tools/s3compat/). Every target uses it: the
# tools, the ROM build and the emulator tests.
#
# Layout: src/tools/ (DOS tools and shared includes), src/roms/ (ROM patchers and assembly). Outputs
# still go to build/ (tools) and build/roms/ (ROM images).
NASM ?= nasm
NASMBIN := $(if $(findstring /,$(NASM)),$(abspath $(NASM)),$(NASM))
NASMVER := $(shell "$(NASMBIN)" -v 2>/dev/null)
ifeq ($(findstring version 3.02,$(NASMVER)),)
$(warning $(NASMBIN): $(if $(NASMVER),$(NASMVER),not found); the project uses NASM 3.02 (make NASM=path/to/nasm))
endif

TOOLS_SRC = src/tools
ROMS_SRC = src/roms
COMMON = $(TOOLS_SRC)/common

# Versions come from src/tools/common/version.inc; override for one build with
#   make clean && make VERSION=0.9 VER775=2.04.07-p13
DEFS :=
ifdef VERSION
DEFS += -DVERSION="'$(VERSION)'"
endif
ifdef VER775
DEFS += -DVER775="'$(VER775)'"
endif
ifdef VER765
DEFS += -DVER765="'$(VER765)'"
endif
ifdef VER764
DEFS += -DVER764="'$(VER764)'"
endif

# make tools: the DOS tools, S3REGS32.EXE, CHIPID.COM, ROMVER.COM and the batch files into build/
# make all: tools and every chip's ROM at its memory clocks (make roms)
# make clean: removes build/ (tools and ROM images)
TOOLS = build/VSHOW.COM build/S3TEST.COM build/S3COMPAT.COM build/S3ALIAS.COM build/VGALOG.COM \
        build/S3REGS.COM build/S3REGS32.EXE build/CHIPID.COM build/ROMVER.COM build/RUNALL.BAT build/CLEAN.BAT \
        build/ZIP.EXE
all: tools roms
tools: $(TOOLS)

# runall.bat: VGALOG /M, S3REGS, S3TEST, S3COMPAT and VSHOW /R with /V and /S, S3REGS, VGALOG /D, then
# RUNALL.ZIP with Info-ZIP's zip (DOS line ends); clean.bat deletes what a run leaves behind
build/RUNALL.BAT: $(TOOLS_SRC)/runall.bat | build
	cp $< $@

# Info-ZIP Zip 3.0, the 16-bit real-mode DOS build (ZIP16.EXE of the FreeDOS 1.3 package), for RUNALL.BAT;
# its licence is infozip/LICENSE
build/ZIP.EXE: infozip/ZIP.EXE | build
	cp $< $@

build/CLEAN.BAT: $(TOOLS_SRC)/clean.bat | build
	cp $< $@

build:
	mkdir -p build

# src/tools/common/ holds the /V debug log code shared by VSHOW, S3TEST and S3COMPAT
VDEBUG = $(COMMON)/vdebug.inc $(COMMON)/vdebug.mac $(COMMON)/version.inc $(COMMON)/chip.inc \
         $(COMMON)/romver.inc

build/VSHOW.COM: $(TOOLS_SRC)/vshow/vshow.asm $(VDEBUG) | build
	"$(NASMBIN)" -f bin -i$(COMMON)/ $(DEFS) -o $@ $<

build/S3TEST.COM: $(TOOLS_SRC)/s3test/s3test.asm $(VDEBUG) | build
	"$(NASMBIN)" -f bin -i$(COMMON)/ $(DEFS) -o $@ $<

build/ROMVER.COM: $(TOOLS_SRC)/romver/romver.asm $(COMMON)/version.inc $(COMMON)/romver.inc | build
	"$(NASMBIN)" -f bin -i$(COMMON)/ $(DEFS) -o $@ $<

# s3compat.asm includes vgaref.inc (reference tables) from its own folder
build/S3COMPAT.COM: $(TOOLS_SRC)/s3compat/s3compat.asm $(TOOLS_SRC)/s3compat/vgaref.inc $(VDEBUG) | build
	cd $(TOOLS_SRC)/s3compat && "$(NASMBIN)" -f bin -i../common/ $(DEFS) -o ../../../$@ s3compat.asm

build/S3ALIAS.COM: $(TOOLS_SRC)/s3alias/s3alias.asm $(COMMON)/version.inc | build
	"$(NASMBIN)" -f bin -i$(COMMON)/ $(DEFS) -o $@ $<

build/VGALOG.COM: $(TOOLS_SRC)/vgalog/vgalog.asm $(COMMON)/version.inc | build
	"$(NASMBIN)" -f bin -i$(COMMON)/ $(DEFS) -o $@ $<

build/S3REGS.COM: $(TOOLS_SRC)/s3regs/s3regs.asm $(COMMON)/version.inc $(COMMON)/chip.inc | build
	"$(NASMBIN)" -f bin -i$(COMMON)/ $(DEFS) -o $@ $<

build/CHIPID.COM: $(TOOLS_SRC)/chipid/chipid.asm $(COMMON)/version.inc $(COMMON)/chip.inc | build
	"$(NASMBIN)" -f bin -i$(COMMON)/ $(DEFS) -o $@ $<

# Win32 console program for Windows 9x; the PE header is written in the source (no linker)
build/S3REGS32.EXE: $(TOOLS_SRC)/s3regs/s3regs32.asm $(COMMON)/version.inc | build
	"$(NASMBIN)" -f bin -i$(COMMON)/ $(DEFS) -o $@ $<

# Emulator tests (python3 with the unicorn package, see pyproject.toml):
#   make emu-test ROM=path/to/S3V2P15.BIN          every test with 2 MB, then the memory-size dependent
#                                                  ones (tag vram) again with 4 MB
#   make emu-test ROM=... VRAM=4                   every test with one size only (2 or 4 MB)
#   make emu-test ROM=S3VPP1.BIN CHIP=765        our Trio64V+ ROM on the Trio64V+ model (CHIP: the chip of
#                                                  the model, v2 by default; tests.py --chip); on the
#                                                  Trio64V+, Trio64 and Trio32 the vram tests run with
#                                                  1 MB too (cards sold with 1 MB, upgradable to 2 MB)
# Uses the virtual environment .venv when there is one, otherwise python3 (override with PYTHON=...).
PYTHON ?= $(if $(wildcard .venv/bin/python3),.venv/bin/python3,python3)
# emu-test runs this many tests at a time (default: every CPU; JOBS=1 for one after the other)
JOBS ?= $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
CHIP ?= 775
# the log folders of emu-test: $(LOGS) (2 MB), $(LOGS)4 (4 MB) and $(LOGS)1 (1 MB)
LOGS ?= emu/logs
# extra tests.py arguments for every run of emu-test, e.g. EMUARGS="--skip s3compat_full" (CI uses it to
# split the tests over parallel jobs)
EMUARGS ?=
# Depends on tools only (not make all / roms): building every ROM image before each emu-test would be
# slow and is not needed when ROM= points at an image already built.
emu-test: tools
	@test -n "$(ROM)" || { echo "emu-test: set ROM to the 64 KB VBIOS image, e.g. make emu-test ROM=S3V2P15.BIN"; exit 2; }
ifdef VRAM
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs $(LOGS) -j $(JOBS) --chip $(CHIP) --vram $(VRAM) $(EMUARGS)
else
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs $(LOGS) -j $(JOBS) --chip $(CHIP) $(EMUARGS)
ifneq ($(CHIP),732)
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs $(LOGS)4 -j $(JOBS) --chip $(CHIP) --vram 4 -t vram $(EMUARGS)
endif
ifneq ($(filter 775 765 764 764x 764p 732,$(CHIP)),)
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs $(LOGS)1 -j $(JOBS) --chip $(CHIP) --vram 1 -t vram $(EMUARGS)
endif
endif

# Test coverage of the ROM code (needs capstone too: pip install .[coverage]); fails under 80 %
#   make coverage ROM=S3V2P15.BIN
#   make coverage ROM=S3VPP1.BIN CHIP=765
coverage: tools
	@test -n "$(ROM)" || { echo "coverage: set ROM to the 64 KB VBIOS image"; exit 2; }
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs emu/logs --chip $(CHIP) --coverage emu/logs/COVER.BIN
	$(PYTHON) emu/codemap.py --rom "$(ROM)" --cover emu/logs/COVER.BIN --list --fail-under 80

# The tools and the emulator tests on the stock reference ROMs (#143): every test, the ones tagged patch too
# (tests.py --stock), so S3TEST, S3COMPAT, VSHOW, VGALOG and S3REGS run on S3's and Phoenix's own BIOSes
# and leave their logs in emu/stock-775, emu/stock-765 and emu/stock-764x (2 MB). Failures are expected
# (a stock BIOS lacks our changes) and do not stop make; the logs are the result.
#   make stock-test [STOCK_CHIPS="775 765 764x"] [EMUARGS=...]
STOCK_CHIPS ?= 775 765 764x
stock-test: tools
	@for c in $(STOCK_CHIPS); do \
	  case $$c in 775) r="$(REF775)";; 765) r="$(REF765)";; *) r="$(REF764)";; esac; \
	  echo "== stock $$c: $$r"; \
	  $(PYTHON) emu/tests.py --stock --nasm "$(NASMBIN)" --rom "$$r" --build build --logs emu/stock-$$c \
	    -j $(JOBS) --chip $$c $(EMUARGS) || true; \
	done; echo "stock-test: logs in emu/stock-*; failures are expected on a stock BIOS"

# The S3 reference BIOS 2.04.07 (32 KB) in the repository: the default REF775 of 775-ref-compare and 775-rom-test
# and the default IN of 775-rom; give REF775=... or IN=... for another copy
REF775 ?= reference/v2/2_04_07.bin
IN ?= $(REF775)

# EGA/CGA behaviour against the unpatched reference BIOS (AGENTS.md goal)
#   make 775-ref-compare ROM=S3V2P15.BIN [REF775=REF2047.BIN]
775-ref-compare:
	@test -n "$(REF775)" -a -n "$(ROM)" || { echo "775-ref-compare: set ROM (and REF775, default reference/v2/2_04_07.bin)"; exit 2; }
	$(PYTHON) emu/refcompare.py --ref "$(REF775)" --rom "$(ROM)"

# Removes build/ (the DOS tools and the ROM images under build/roms/)
clean:
	rm -rf build

# MCLK build option of 775-rom and 765-rom: MCLK = MHz for the memory type MEMTYPE (default edo1, 1-cycle EDO;
# fpm = fast page and 2-cycle EDO; sgram on the Trio64V2/GX), within the data book limits (src/roms/
# s3patch.py, src/roms/vplus/s3vpatch.py); without MCLK the default build
MCLKOPT = $(if $(MCLK),--mclk $(MCLK) $(if $(MEMTYPE),--memtype $(MEMTYPE)))

# ROM patcher (python3 and nasm): the current level from the S3 reference BIOS 2.04.07
#   make 775-rom OUT=S3V2P22.BIN [IN=REF2047.BIN] [SIZE775=32] [MCLK=55 [MEMTYPE=edo1]]   (64 KB, the 32 KB twice; SIZE775=32: 32 KB)
#   make 775-rom-test [REF775=REF2047.BIN] [STOCK=STOCK.BIN] [ROM=S3V2P15.BIN]
775-rom:
	@test -n "$(IN)" -a -n "$(OUT)" || { echo "775-rom: set OUT, e.g. make 775-rom OUT=S3V2P15.BIN (IN defaults to reference/v2/2_04_07.bin)"; exit 2; }
	python3 $(ROMS_SRC)/s3patch.py --nasm "$(NASMBIN)" --size $(SIZE775) "$(IN)" -o "$(OUT)" $(MCLKOPT)

775-rom-test:
	@test -n "$(REF775)" || { echo "775-rom-test: set REF775 (2.04.07, 32 KB, default reference/v2/2_04_07.bin); STOCK (the stock 64 KB dump) and ROM are optional"; exit 2; }
	python3 $(ROMS_SRC)/test_s3patch.py --nasm "$(NASMBIN)" --ref "$(REF775)" $(if $(STOCK),--stock "$(STOCK)") $(if $(ROM),--rom "$(ROM)")

# The Trio64V+ ROM (src/roms/vplus): the backport to the S3 Trio64V+ BIOS 1.03-08 in
# reference/64vplus/1_03_08n.bin (REF765), docs/765-rom.md
#   make 765-rom OUT=S3VPP1.BIN [REF765=...] [SIZE765=32] [MCLK=55 [MEMTYPE=edo1]]   (64 KB, the 32 KB twice; SIZE765=32: 32 KB)
#   make 765-rom-test [REF765=...] [ROM=S3VPP1.BIN]
#   make 765-ref-compare ROM=S3VPP1.BIN [REF765=...]               (EGA/CGA behaviour against 1.03-08)
#   make emu-test ROM=S3VPP1.BIN CHIP=765 [LOGS=emu/vlogs]
REF765 ?= reference/64vplus/1_03_08n.bin
SIZE775 ?= 64
SIZE765 ?= 64
SIZE764 ?= 64
765-rom:
	@test -n "$(OUT)" || { echo "765-rom: set OUT, e.g. make 765-rom OUT=S3VPP1.BIN (REF765 defaults to reference/64vplus/1_03_08n.bin)"; exit 2; }
	python3 $(ROMS_SRC)/vplus/s3vpatch.py --nasm "$(NASMBIN)" --size $(SIZE765) "$(REF765)" -o "$(OUT)" $(MCLKOPT)

765-rom-test:
	python3 $(ROMS_SRC)/vplus/test_s3vpatch.py --nasm "$(NASMBIN)" --ref "$(REF765)" --ref775 "$(REF775)" $(if $(ROM),--rom "$(ROM)")

765-ref-compare:
	@test -n "$(ROM)" || { echo "765-ref-compare: set ROM (our Trio64V+ ROM; REF765 defaults to reference/64vplus/1_03_08n.bin)"; exit 2; }
	$(PYTHON) emu/refcompare.py --chip 765 --ref "$(REF765)" --rom "$(ROM)"

# The Trio64 ROM (src/roms/trio64): built on the Phoenix S3 Trio64 BIOS 1.5-07 in reference/trio64/1_5_07.bin
# (REF764; another card's 1.5-07 build is accepted too), docs/764-rom.md
#   make 764x-rom OUT=S3T64P3.BIN [REF764=...] [SIZE764=32] [MCLK=55]   (64 KB, the 32 KB twice; SIZE764=32: 32 KB)
#   make 764x-rom OUT=S3T64P3.BIN MCLK=69.8   (up to 70 MHz, the Trio64 limit of our tools; the data book gives 60)
#   make 764x-rom OUT=S3T64OC.BIN MCLK=85 OVERCLOCK=1   (above 70 MHz, at most 100 MHz)
#   make 764-rom-test [REF764=...] [ROM=S3T64P3.BIN]
#   make 764-ref-compare ROM=S3T64P3.BIN [REF764=...]              (EGA/CGA behaviour against 1.5-07)
#   make emu-test ROM=S3T64P3.BIN CHIP=764 [LOGS=emu/tlogs]
REF764 ?= reference/trio64/1_5_07.bin
# 764x-rom is for the 86C764X (Trio64 PnP, MCLK 55-70 MHz), 764p-rom for the 86C764-P (50-60 MHz): the same
# ROM, only the MCLK range the build option accepts differs (T64-MEM-7); without MCLK the two are identical.
764x-rom 764p-rom:
	@test -n "$(OUT)" || { echo "$@: set OUT, e.g. make $@ OUT=S3T64P3.BIN (REF764 defaults to reference/trio64/1_5_07.bin)"; exit 2; }
	python3 $(ROMS_SRC)/trio64/s3tpatch.py --nasm "$(NASMBIN)" --size $(SIZE764) --model $(subst -rom,,$@) "$(REF764)" -o "$(OUT)" $(if $(MCLK),--mclk $(MCLK) $(if $(OVERCLOCK),--overclock))

764-rom-test:
	python3 $(ROMS_SRC)/trio64/test_s3tpatch.py --nasm "$(NASMBIN)" --ref "$(REF764)" --ref765 "$(REF765)" $(if $(ROM),--rom "$(ROM)")

764-ref-compare: | build
	@test -n "$(ROM)" || { echo "764-ref-compare: set ROM (our Trio64 ROM; REF764 defaults to reference/trio64/1_5_07.bin)"; exit 2; }
	python3 $(ROMS_SRC)/trio64/s3tpatch.py --fonts-only "$(REF764)" -o build/T64FONTS.BIN
	$(PYTHON) emu/refcompare.py --chip 764 --ref build/T64FONTS.BIN --rom "$(ROM)"

# All four chips' ROMs, each at its memory clocks, into build/roms/<chip>-<level>/ (level from
# src/tools/common/version.inc) with 8.3 names for a DOS disk: the chip code, M and the clock, for example
# build/roms/775-P22/775M60.BIN, build/roms/764X-P3/764XM70.BIN. On the 775 and 765 the clock goes into the
# edo1 entry (MEMTYPE; 1-cycle EDO), on the 764 models into their one entry. The images keep each target's
# size (SIZE775, SIZE765, SIZE764: 64 KB, the 32 KB twice, unless set to 32).
#   make roms [CLOCKS_775="50 55 60"] [CLOCKS_765=...] [CLOCKS_764X="55 60 70"] [CLOCKS_764P="50 55 60"]
CLOCKS_775 ?= 50 55 60
CLOCKS_765 ?= 50 55 60
CLOCKS_764X ?= 55 60 70
CLOCKS_764P ?= 50 55 60
level = $(shell sed -n "s/^%define $(1) '.*-\(p[0-9]*\)'.*/\1/p" $(COMMON)/version.inc | tr a-z A-Z)
ROMDIR_775 = build/roms/775-$(call level,VER775)
ROMDIR_765 = build/roms/765-$(call level,VER765)
ROMDIR_764X = build/roms/764X-$(call level,VER764)
ROMDIR_764P = build/roms/764P-$(call level,VER764)
roms:
	@mkdir -p $(ROMDIR_775) $(ROMDIR_765) $(ROMDIR_764X) $(ROMDIR_764P)
	@set -e; \
	for m in $(CLOCKS_775); do $(MAKE) --no-print-directory 775-rom OUT=$(ROMDIR_775)/775M$$m.BIN MCLK=$$m; done; \
	for m in $(CLOCKS_765); do $(MAKE) --no-print-directory 765-rom OUT=$(ROMDIR_765)/765M$$m.BIN MCLK=$$m; done; \
	for m in $(CLOCKS_764X); do $(MAKE) --no-print-directory 764x-rom OUT=$(ROMDIR_764X)/764XM$$m.BIN MCLK=$$m; done; \
	for m in $(CLOCKS_764P); do $(MAKE) --no-print-directory 764p-rom OUT=$(ROMDIR_764P)/764PM$$m.BIN MCLK=$$m; done
	@ls -lR build/roms

# Every ROM and every emulator test in one go: make roms, then make emu-test on each image it built, with
# the chip model of its folder (775, 765, 764x, 764p) and the memory sizes emu-test uses for that chip
# (2 and 4 MB, and 1 MB). The logs go to emu/all/<image>, for example emu/all/775M60 (2 MB), emu/all/775M604
# (4 MB) and emu/all/775M601 (1 MB). A failing image does not stop the others; the summary names every
# failed image and make fails when there is one. The CLOCKS_* variables of make roms choose the images
# (CLOCKS_775=60 tests one Trio64V2 image), JOBS and EMUARGS pass on to emu-test.
#   make test-all [CLOCKS_775=...] [CLOCKS_765=...] [CLOCKS_764X=...] [CLOCKS_764P=...] [EMUARGS=...]
test-all: tools roms
	@fail=""; \
	for e in $(foreach m,$(CLOCKS_775),775:$(ROMDIR_775)/775M$(m).BIN) \
	         $(foreach m,$(CLOCKS_765),765:$(ROMDIR_765)/765M$(m).BIN) \
	         $(foreach m,$(CLOCKS_764X),764x:$(ROMDIR_764X)/764XM$(m).BIN) \
	         $(foreach m,$(CLOCKS_764P),764p:$(ROMDIR_764P)/764PM$(m).BIN); do \
	  c=$${e%%:*}; r=$${e#*:}; n=$$(basename $$r .BIN); \
	  echo "== test-all: $$r (CHIP=$$c)"; \
	  $(MAKE) --no-print-directory emu-test ROM=$$r CHIP=$$c LOGS=emu/all/$$n || fail="$$fail $$n"; \
	done; \
	if [ -n "$$fail" ]; then echo "test-all: FAIL:$$fail (logs in emu/all/)"; exit 1; fi; \
	echo "test-all: every image passed (logs in emu/all/)"

# The release zip, build/trio64-tools-<VERSION>.zip (VERSION from src/tools/common/version.inc, or VERSION=...):
# trio64/tools/ with the tools and Info-ZIP's licence (ZIP-LIC.TXT, which its licence asks to pass on
# with ZIP.EXE). With ROMS=1 also trio64/roms/, every chip's ROM at its memory clocks (make roms); the
# default leaves them out (README "Release zip").
#   make dist [ROMS=1]
DISTVER = $(or $(VERSION),$(shell sed -n "s/^%define VERSION '\(.*\)'.*/\1/p" $(COMMON)/version.inc))
DISTZIP = build/trio64-tools-$(DISTVER).zip
dist: tools $(if $(ROMS),roms)
	rm -rf build/dist $(DISTZIP)
	mkdir -p build/dist/trio64/tools
	cp $(TOOLS) build/dist/trio64/tools/
	cp infozip/LICENSE build/dist/trio64/tools/ZIP-LIC.TXT
	$(if $(ROMS),cp -R build/roms build/dist/trio64/roms)
	$(PYTHON) -m zipfile -c $(DISTZIP) build/dist/trio64
	@$(PYTHON) -m zipfile -l $(DISTZIP)

# the release version, for scripts (CI names its artifact with it)
version:
	@echo $(DISTVER)

.PHONY: all tools dist version clean emu-test test-all stock-test 775-rom roms 775-rom-test coverage 775-ref-compare 765-rom 765-rom-test 765-ref-compare 764x-rom 764p-rom 764-rom-test 764-ref-compare
