@echo off
rem Builds the DOS test tools with NASM 3.02: nasm.exe on the PATH, or the path in NASM,
rem for example: set NASM=nasm\nasm-3.02\nasm.exe   (a relative path is made absolute)
if "%NASM%"=="" set NASM=nasm
if exist "%NASM%" for %%I in ("%NASM%") do set NASM=%%~fI
if exist "%NASM%.exe" for %%I in ("%NASM%.exe") do set NASM=%%~fI
if not exist build mkdir build
"%NASM%" -f bin -icommon\ -o build\VSHOW.COM vshow\vshow.asm
"%NASM%" -f bin -icommon\ -o build\S3TEST.COM s3test\s3test.asm
cd s3compat
"%NASM%" -f bin -i..\common\ -o ..\build\S3COMPAT.COM s3compat.asm
cd ..
"%NASM%" -f bin -icommon\ -o build\S3ALIAS.COM s3alias\s3alias.asm
"%NASM%" -f bin -icommon\ -o build\VGALOG.COM vgalog\vgalog.asm
"%NASM%" -f bin -icommon\ -o build\S3REGS.COM s3regs\s3regs.asm
"%NASM%" -f bin -icommon\ -o build\S3REGS32.EXE s3regs\s3regs32.asm
copy runall.bat build\RUNALL.BAT
copy clean.bat build\CLEAN.BAT
