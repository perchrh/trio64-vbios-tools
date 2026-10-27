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
#   make emu-test ROM=path/to/S3V2P15.BIN [VRAM=4]   (VRAM: the memory the model reports, 2 or 4 MB)
# Uses the virtual environment .venv when there is one, otherwise python3 (override with PYTHON=...).
PYTHON ?= $(if $(wildcard .venv/bin/python3),.venv/bin/python3,python3)
emu-test: all
	@test -n "$(ROM)" || { echo "emu-test: set ROM to the 64 KB VBIOS image, e.g. make emu-test ROM=S3V2P15.BIN"; exit 2; }
	$(PYTHON) emu/tests.py --rom "$(ROM)" --build build --logs emu/logs $(if $(VRAM),--vram $(VRAM))

# Test coverage of the ROM code (needs capstone too: pip install .[coverage]); fails under 80 %
#   make coverage ROM=S3V2P15.BIN
coverage: all
	@test -n "$(ROM)" || { echo "coverage: set ROM to the 64 KB VBIOS image"; exit 2; }
	$(PYTHON) emu/tests.py --rom "$(ROM)" --build build --logs emu/logs --coverage emu/logs/COVER.BIN
	$(PYTHON) emu/codemap.py --rom "$(ROM)" --cover emu/logs/COVER.BIN --list --fail-under 80

# EGA/CGA behaviour against the unpatched reference BIOS (AGENTS.md goal)
#   make ref-compare REF=REF2047.BIN ROM=S3V2P15.BIN
ref-compare:
	@test -n "$(REF)" -a -n "$(ROM)" || { echo "ref-compare: set REF and ROM"; exit 2; }
	$(PYTHON) emu/refcompare.py --ref "$(REF)" --rom "$(ROM)"

clean:
	rm -rf build

# ROM patcher (python3 and nasm): the current level from the S3 reference BIOS 2.04.07
#   make rom IN=REF2047.BIN OUT=S3V2P15.BIN               (upper 32 KB: zeros)
#   make rom-test REF=REF2047.BIN [STOCK=STOCK.BIN] [ROM=S3V2P15.BIN]
rom:
	@test -n "$(IN)" -a -n "$(OUT)" || { echo "rom: set IN and OUT, e.g. make rom IN=REF2047.BIN OUT=S3V2P15.BIN"; exit 2; }
	python3 rompatch/s3patch.py --nasm $(NASM) "$(IN)" -o "$(OUT)"

rom-test:
	@test -n "$(REF)" || { echo "rom-test: set REF (2.04.07, 32 KB); STOCK (the stock 64 KB dump) and ROM are optional"; exit 2; }
	python3 rompatch/test_s3patch.py --nasm $(NASM) --ref "$(REF)" $(if $(STOCK),--stock "$(STOCK)") $(if $(ROM),--rom "$(ROM)")

.PHONY: all clean emu-test rom rom-test coverage ref-compare
