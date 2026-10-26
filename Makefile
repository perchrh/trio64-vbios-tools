# Builds the DOS tools for the Trio64V2/DX VBIOS project. Needs NASM 2.x.
NASM ?= nasm

# Versions come from common/version.inc; override for one build with
#   make clean && make VERSION=0.9 ROMVER=2.04.11-p10
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
#   make emu-test ROM=path/to/S3V2P9.BIN
# Uses the virtual environment .venv when there is one, otherwise python3 (override with PYTHON=...).
PYTHON ?= $(if $(wildcard .venv/bin/python3),.venv/bin/python3,python3)
emu-test: all
	@test -n "$(ROM)" || { echo "emu-test: set ROM to the 64 KB VBIOS image, e.g. make emu-test ROM=S3V2P9.BIN"; exit 2; }
	$(PYTHON) emu/tests.py --rom "$(ROM)" --build build --logs emu/logs

clean:
	rm -rf build

# ROM patcher (python3 and nasm): p13 (or TARGET=p12) from the stock 2.04.11 dump or the S3 reference 2.04.07
#   make rom IN=STOCK.BIN OUT=S3V2P13.BIN [TARGET=p12] [UPPER=STOCK.BIN]
#   make rom-test STOCK=STOCK.BIN [REF=REF2047.BIN] [P12=S3V2P12.BIN] [P13=S3V2P13.BIN]
rom:
	@test -n "$(IN)" -a -n "$(OUT)" || { echo "rom: set IN and OUT, e.g. make rom IN=STOCK.BIN OUT=S3V2P13.BIN"; exit 2; }
	python3 rompatch/s3patch.py --nasm $(NASM) "$(IN)" -o "$(OUT)" $(if $(TARGET),--target $(TARGET)) $(if $(UPPER),--upper "$(UPPER)")

rom-test:
	@test -n "$(STOCK)" || { echo "rom-test: set STOCK to the 64 KB stock image"; exit 2; }
	python3 rompatch/test_s3patch.py --nasm $(NASM) --stock "$(STOCK)" $(if $(REF),--ref "$(REF)") $(if $(P12),--p12 "$(P12)") $(if $(P13),--p13 "$(P13)")

.PHONY: all clean emu-test rom rom-test
