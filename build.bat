@echo off
rem Builds the DOS test tools with NASM 3.02: nasm.exe on the PATH, or the path in NASM,
rem for example: set NASM=nasm\nasm-3.02\nasm.exe   (a relative path is made absolute)
rem The output is the Makefile's tools list: the programs, RUNALL.BAT, CLEAN.BAT and Info-ZIP's
rem ZIP.EXE that RUNALL.BAT calls, with its licence as ZIP-LIC.TXT. The build stops at the first
rem command that fails (#144).
if "%NASM%"=="" set NASM=nasm
if exist "%NASM%" for %%I in ("%NASM%") do set NASM=%%~fI
if exist "%NASM%.exe" for %%I in ("%NASM%.exe") do set NASM=%%~fI
if not exist build mkdir build
"%NASM%" -f bin -icommon\ -o build\VSHOW.COM vshow\vshow.asm
if errorlevel 1 goto fail
"%NASM%" -f bin -icommon\ -o build\S3TEST.COM s3test\s3test.asm
if errorlevel 1 goto fail
cd s3compat
"%NASM%" -f bin -i..\common\ -o ..\build\S3COMPAT.COM s3compat.asm
if errorlevel 1 goto failcd
cd ..
"%NASM%" -f bin -icommon\ -o build\S3ALIAS.COM s3alias\s3alias.asm
if errorlevel 1 goto fail
"%NASM%" -f bin -icommon\ -o build\VGALOG.COM vgalog\vgalog.asm
if errorlevel 1 goto fail
"%NASM%" -f bin -icommon\ -o build\S3REGS.COM s3regs\s3regs.asm
if errorlevel 1 goto fail
"%NASM%" -f bin -icommon\ -o build\S3REGS32.EXE s3regs\s3regs32.asm
if errorlevel 1 goto fail
copy /y runall.bat build\RUNALL.BAT >nul
if errorlevel 1 goto fail
copy /y clean.bat build\CLEAN.BAT >nul
if errorlevel 1 goto fail
copy /y infozip\ZIP.EXE build\ZIP.EXE >nul
if errorlevel 1 goto fail
copy /y infozip\LICENSE build\ZIP-LIC.TXT >nul
if errorlevel 1 goto fail
echo build: done
exit /b 0
:failcd
cd ..
:fail
echo build: FAILED at the step above
exit /b 1
