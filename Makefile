# Builds the DOS tools for the Trio64V2/DX VBIOS project. Needs NASM 2.x.
NASM ?= nasm

# Versions come from common/version.inc; override for one build with
#   make clean && make VERSION=0.9 ROMVER=2.04.07-p13
DEFS :=
ifdef VERSION
DEFS += -DVERSION="'$(VERSION)'"
endif
ifdef ROMVER
DEFS += -DROMVER="'$(ROMVER)'"
endif

all: build/VSHOW.COM build/S3TEST.COM build/S3COMPAT.COM build/S3ALIAS.COM build/VGALOG.COM \
     build/S3REGS.COM build/S3REGS32.EXE

build:
	mkdir -p build

# common/ holds the /V debug log code shared by VSHOW, S3TEST and S3COMPAT
VDEBUG = common/vdebug.inc common/vdebug.mac common/version.inc

build/VSHOW.COM: vshow/vshow.asm $(VDEBUG) | build
	$(NASM) -f bin -icommon/ $(DEFS) -o $@ $<

build/S3TEST.COM: s3test/s3test.asm $(VDEBUG) | build
	$(NASM) -f bin -icommon/ $(DEFS) -o $@ $<

# s3compat.asm includes vgaref.inc (reference tables) from its own folder
build/S3COMPAT.COM: s3compat/s3compat.asm s3compat/vgaref.inc $(VDEBUG) | build
	cd s3compat && $(NASM) -f bin -i../common/ $(DEFS) -o ../$@ s3compat.asm

build/S3ALIAS.COM: s3alias/s3alias.asm common/version.inc | build
	$(NASM) -f bin -icommon/ $(DEFS) -o $@ $<

build/VGALOG.COM: vgalog/vgalog.asm common/version.inc | build
	$(NASM) -f bin -icommon/ $(DEFS) -o $@ $<

build/S3REGS.COM: s3regs/s3regs.asm common/version.inc | build
	$(NASM) -f bin -icommon/ $(DEFS) -o $@ $<

# Win32 console program for Windows 9x; the PE header is written in the source (no linker)
build/S3REGS32.EXE: s3regs/s3regs32.asm common/version.inc | build
	$(NASM) -f bin -icommon/ $(DEFS) -o $@ $<

# Emulator tests (python3 with the unicorn package, see pyproject.toml):
#   make emu-test ROM=path/to/S3V2P14.BIN
# Uses the virtual environment .venv when there is one, otherwise python3 (override with PYTHON=...).
PYTHON ?= $(if $(wildcard .venv/bin/python3),.venv/bin/python3,python3)
emu-test: all
	@test -n "$(ROM)" || { echo "emu-test: set ROM to the 64 KB VBIOS image, e.g. make emu-test ROM=S3V2P14.BIN"; exit 2; }
	$(PYTHON) emu/tests.py --rom "$(ROM)" --build build --logs emu/logs

# Test coverage of the ROM code (needs capstone too: pip install .[coverage]); fails under 80 %
#   make coverage ROM=S3V2P14.BIN
coverage: all
	@test -n "$(ROM)" || { echo "coverage: set ROM to the 64 KB VBIOS image"; exit 2; }
	$(PYTHON) emu/tests.py --rom "$(ROM)" --build build --logs emu/logs --coverage emu/logs/COVER.BIN
	$(PYTHON) emu/codemap.py --rom "$(ROM)" --cover emu/logs/COVER.BIN --list --fail-under 80

# EGA/CGA behaviour against the unpatched reference BIOS (AGENTS.md goal)
#   make ref-compare REF=REF2047.BIN UPPER=STOCK.BIN ROM=S3V2P14.BIN
ref-compare:
	@test -n "$(REF)" -a -n "$(UPPER)" -a -n "$(ROM)" || { echo "ref-compare: set REF, UPPER and ROM"; exit 2; }
	$(PYTHON) emu/refcompare.py --ref "$(REF)" --upper "$(UPPER)" --rom "$(ROM)"

clean:
	rm -rf build

# ROM patcher (python3 and nasm): the current level from the S3 reference BIOS 2.04.07
#   make rom IN=REF2047.BIN UPPER=STOCK.BIN OUT=S3V2P14.BIN
#   make rom-test REF=REF2047.BIN UPPER=STOCK.BIN [ROM=S3V2P14.BIN]
rom:
	@test -n "$(IN)" -a -n "$(OUT)" -a -n "$(UPPER)" || { echo "rom: set IN, UPPER and OUT, e.g. make rom IN=REF2047.BIN UPPER=STOCK.BIN OUT=S3V2P14.BIN"; exit 2; }
	python3 rompatch/s3patch.py --nasm $(NASM) "$(IN)" --upper "$(UPPER)" -o "$(OUT)"

rom-test:
	@test -n "$(REF)" -a -n "$(UPPER)" || { echo "rom-test: set REF (2.04.07, 32 KB) and UPPER (the stock 64 KB image)"; exit 2; }
	python3 rompatch/test_s3patch.py --nasm $(NASM) --ref "$(REF)" --upper "$(UPPER)" $(if $(ROM),--rom "$(ROM)")

.PHONY: all clean emu-test rom rom-test coverage ref-compare
