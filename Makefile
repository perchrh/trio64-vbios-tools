# Builds the DOS tools for the Trio64V2/DX VBIOS project. Needs NASM 2.x.
NASM ?= nasm

all: build/VSHOW.COM build/S3TEST.COM build/S3COMPAT.COM build/S3ALIAS.COM build/VGALOG.COM

build:
	mkdir -p build

build/VSHOW.COM: vshow/vshow.asm | build
	$(NASM) -f bin -o $@ $<

build/S3TEST.COM: s3test/s3test.asm | build
	$(NASM) -f bin -o $@ $<

# s3compat.asm includes vgaref.inc (reference tables) from its own folder
build/S3COMPAT.COM: s3compat/s3compat.asm s3compat/vgaref.inc | build
	cd s3compat && $(NASM) -f bin -o ../$@ s3compat.asm

build/S3ALIAS.COM: s3alias/s3alias.asm | build
	$(NASM) -f bin -o $@ $<

build/VGALOG.COM: vgalog/vgalog.asm | build
	$(NASM) -f bin -o $@ $<

clean:
	rm -rf build

.PHONY: all clean
