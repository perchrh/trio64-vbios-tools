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
     build/S3REGS.COM build/S3REGS32.EXE build/RUNALL.BAT

# runall.bat: S3TEST, S3COMPAT and VSHOW /R with /V and /S, their logs next to them (DOS line ends)
build/RUNALL.BAT: runall.bat | build
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
emu-test: all
	@test -n "$(ROM)" || { echo "emu-test: set ROM to the 64 KB VBIOS image, e.g. make emu-test ROM=S3V2P15.BIN"; exit 2; }
ifdef VRAM
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs $(LOGS) -j $(JOBS) --chip $(CHIP) --vram $(VRAM)
else
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs $(LOGS) -j $(JOBS) --chip $(CHIP)
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs $(LOGS)4 -j $(JOBS) --chip $(CHIP) --vram 4 -t vram
ifneq ($(filter vplus trio64 trio32,$(CHIP)),)
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs $(LOGS)1 -j $(JOBS) --chip $(CHIP) --vram 1 -t vram
endif
endif

# Test coverage of the ROM code (needs capstone too: pip install .[coverage]); fails under 80 %
#   make coverage ROM=S3V2P15.BIN
#   make coverage ROM=S3VPP1.BIN CHIP=vplus
coverage: all
	@test -n "$(ROM)" || { echo "coverage: set ROM to the 64 KB VBIOS image"; exit 2; }
	$(PYTHON) emu/tests.py --nasm "$(NASMBIN)" --rom "$(ROM)" --build build --logs emu/logs --chip $(CHIP) --coverage emu/logs/COVER.BIN
	$(PYTHON) emu/codemap.py --rom "$(ROM)" --cover emu/logs/COVER.BIN --list --fail-under 80

# The S3 reference BIOS 2.04.07 (32 KB) in the repository: the default REF of ref-compare and rom-test
# and the default IN of rom; give REF=... or IN=... for another copy
REF ?= reference/v2/2_04_07.bin
IN ?= $(REF)

# EGA/CGA behaviour against the unpatched reference BIOS (AGENTS.md goal)
#   make ref-compare ROM=S3V2P15.BIN [REF=REF2047.BIN]
ref-compare:
	@test -n "$(REF)" -a -n "$(ROM)" || { echo "ref-compare: set ROM (and REF, default reference/v2/2_04_07.bin)"; exit 2; }
	$(PYTHON) emu/refcompare.py --ref "$(REF)" --rom "$(ROM)"

clean:
	rm -rf build

# MCLK build option of rom and vrom: MCLK = MHz for the memory type MEMTYPE (default edo1, 1-cycle EDO;
# fpm = fast page and 2-cycle EDO; sgram on the Trio64V2/GX), within the data book limits (rompatch/
# s3patch.py, rompatch/vplus/s3vpatch.py); without MCLK the default build
MCLKOPT = $(if $(MCLK),--mclk $(MCLK) $(if $(MEMTYPE),--memtype $(MEMTYPE)))

# ROM patcher (python3 and nasm): the current level from the S3 reference BIOS 2.04.07
#   make rom OUT=S3V2P21.BIN [IN=REF2047.BIN] [MCLK=55 [MEMTYPE=edo1]]     (upper 32 KB: zeros)
#   make rom-test [REF=REF2047.BIN] [STOCK=STOCK.BIN] [ROM=S3V2P15.BIN]
rom:
	@test -n "$(IN)" -a -n "$(OUT)" || { echo "rom: set OUT, e.g. make rom OUT=S3V2P15.BIN (IN defaults to reference/v2/2_04_07.bin)"; exit 2; }
	python3 rompatch/s3patch.py --nasm "$(NASMBIN)" "$(IN)" -o "$(OUT)" $(MCLKOPT)

rom-test:
	@test -n "$(REF)" || { echo "rom-test: set REF (2.04.07, 32 KB, default reference/v2/2_04_07.bin); STOCK (the stock 64 KB dump) and ROM are optional"; exit 2; }
	python3 rompatch/test_s3patch.py --nasm "$(NASMBIN)" --ref "$(REF)" $(if $(STOCK),--stock "$(STOCK)") $(if $(ROM),--rom "$(ROM)")

# The Trio64V+ ROM (rompatch/vplus): the backport to the S3 Trio64V+ BIOS 1.03-08 in
# reference/vplus/1_03_08.bin (VREF), docs/vplus-backport.md
#   make vrom OUT=S3VPP1.BIN [VREF=...] [VSIZE=64] [MCLK=55 [MEMTYPE=edo1]]   (32 KB; VSIZE=64: 64 KB, upper half zeros)
#   make vrom-test [VREF=...] [ROM=S3VPP1.BIN]
#   make vref-compare ROM=S3VPP1.BIN [VREF=...]               (EGA/CGA behaviour against 1.03-08)
#   make emu-test ROM=S3VPP1.BIN CHIP=vplus [LOGS=emu/vlogs]
VREF ?= reference/vplus/1_03_08.bin
VSIZE ?= 32
vrom:
	@test -n "$(OUT)" || { echo "vrom: set OUT, e.g. make vrom OUT=S3VPP1.BIN (VREF defaults to reference/vplus/1_03_08.bin)"; exit 2; }
	python3 rompatch/vplus/s3vpatch.py --nasm "$(NASMBIN)" --size $(VSIZE) "$(VREF)" -o "$(OUT)" $(MCLKOPT)

vrom-test:
	python3 rompatch/vplus/test_s3vpatch.py --nasm "$(NASMBIN)" --ref "$(VREF)" --v2ref "$(REF)" $(if $(ROM),--rom "$(ROM)")

vref-compare:
	@test -n "$(ROM)" || { echo "vref-compare: set ROM (our Trio64V+ ROM; VREF defaults to reference/vplus/1_03_08.bin)"; exit 2; }
	$(PYTHON) emu/refcompare.py --chip vplus --ref "$(VREF)" --rom "$(ROM)"

# The Trio64 ROM (rompatch/trio64): built on the Phoenix S3 Trio64 BIOS 1.5-07 in reference/trio64/1_5_07.bin
# (TREF; another card's 1.5-07 build is accepted too), docs/trio64-backport.md
#   make trom OUT=S3T64P1.BIN [TREF=...] [VSIZE=64] [MCLK=55]   (32 KB; VSIZE=64: 64 KB, upper half zeros)
#   make trom-test [TREF=...] [ROM=S3T64P1.BIN]
#   make tref-compare ROM=S3T64P1.BIN [TREF=...]              (EGA/CGA behaviour against 1.5-07)
#   make emu-test ROM=S3T64P1.BIN CHIP=trio64 [LOGS=emu/tlogs]
TREF ?= reference/trio64/1_5_07.bin
trom:
	@test -n "$(OUT)" || { echo "trom: set OUT, e.g. make trom OUT=S3T64P1.BIN (TREF defaults to reference/trio64/1_5_07.bin)"; exit 2; }
	python3 rompatch/trio64/s3tpatch.py --nasm "$(NASMBIN)" --size $(VSIZE) "$(TREF)" -o "$(OUT)" $(if $(MCLK),--mclk $(MCLK))

trom-test:
	python3 rompatch/trio64/test_s3tpatch.py --nasm "$(NASMBIN)" --ref "$(TREF)" --vref "$(VREF)" $(if $(ROM),--rom "$(ROM)")

tref-compare:
	@test -n "$(ROM)" || { echo "tref-compare: set ROM (our Trio64 ROM; TREF defaults to reference/trio64/1_5_07.bin)"; exit 2; }
	$(PYTHON) emu/refcompare.py --chip trio64 --ref "$(TREF)" --rom "$(ROM)"

.PHONY: all clean emu-test rom rom-test coverage ref-compare vrom vrom-test vref-compare trom trom-test tref-compare
