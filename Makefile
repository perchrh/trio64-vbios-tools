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
     build/S3F8X14.COM

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

# s3f8x14.asm includes the font (font8x14.inc) from its own folder
build/S3F8X14.COM: s3f8x14/s3f8x14.asm s3f8x14/font8x14.inc common/version.inc | build
	$(NASM) -f bin -icommon/ -is3f8x14/ $(DEFS) -o $@ $<

# Emulator tests (python3 with the unicorn package, see pyproject.toml):
#   make emu-test ROM=path/to/S3V2P9.BIN
# Uses the virtual environment .venv when there is one, otherwise python3 (override with PYTHON=...).
PYTHON ?= $(if $(wildcard .venv/bin/python3),.venv/bin/python3,python3)
emu-test: all
	@test -n "$(ROM)" || { echo "emu-test: set ROM to the 64 KB VBIOS image, e.g. make emu-test ROM=S3V2P9.BIN"; exit 2; }
	$(PYTHON) emu/tests.py --rom "$(ROM)" --build build --logs emu/logs

clean:
	rm -rf build

.PHONY: all clean emu-test
