# Builds the DOS test tools for the Trio64V2/DX VBIOS project. Needs NASM 2.x.
NASM ?= nasm

all: build/VSHOW.COM build/S3TEST.COM build/S3COMPAT.COM

build:
	mkdir -p build

build/VSHOW.COM: vshow/vshow.asm | build
	$(NASM) -f bin -o $@ $<

build/S3TEST.COM: s3test/s3test.asm | build
	$(NASM) -f bin -o $@ $<

# s3compat.asm includes vgaref.inc and dac_col.bin from its own folder
build/S3COMPAT.COM: s3compat/s3compat.asm s3compat/vgaref.inc s3compat/dac_col.bin | build
	cd s3compat && $(NASM) -f bin -o ../$@ s3compat.asm

clean:
	rm -rf build

.PHONY: all clean
