@echo off
rem Builds the DOS test tools. Needs nasm.exe on the PATH.
if not exist build mkdir build
nasm -f bin -icommon\ -o build\VSHOW.COM vshow\vshow.asm
nasm -f bin -icommon\ -o build\S3TEST.COM s3test\s3test.asm
cd s3compat
nasm -f bin -i..\common\ -o ..\build\S3COMPAT.COM s3compat.asm
cd ..
nasm -f bin -o build\S3ALIAS.COM s3alias\s3alias.asm
nasm -f bin -o build\VGALOG.COM vgalog\vgalog.asm
