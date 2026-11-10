@echo off
rem Builds the DOS test tools with NASM 3.02: nasm.exe on the PATH, or the path in NASM,
rem for example: set NASM=nasm\nasm-3.02\nasm.exe   (a relative path is made absolute)
rem The output is the Makefile's tools list: the programs (including CHIPID.COM, ROMVER.COM and
rem REPORT.COM), RUNALL.BAT and CLEAN.BAT. RUNALL packs its logs with REPORT.COM.
rem Sources live under src\tools\. The build stops at the first command that fails (#144).
if "%NASM%"=="" set NASM=nasm
if exist "%NASM%" for %%I in ("%NASM%") do set NASM=%%~fI
if exist "%NASM%.exe" for %%I in ("%NASM%.exe") do set NASM=%%~fI
if not exist build mkdir build
"%NASM%" -f bin -isrc\tools\common\ -o build\VBESHOW.COM src\tools\vbeshow\vbeshow.asm
"%NASM%" -f bin -isrc\tools\common\ -o build\VGASHOW.COM src\tools\vgashow\vgashow.asm
if errorlevel 1 goto fail
"%NASM%" -f bin -isrc\tools\common\ -o build\S3TEST.COM src\tools\s3test\s3test.asm
if errorlevel 1 goto fail
cd src\tools\s3compat
"%NASM%" -f bin -i..\common\ -o ..\..\..\build\S3COMPAT.COM s3compat.asm
if errorlevel 1 goto failcd
cd ..\..\..
"%NASM%" -f bin -isrc\tools\common\ -o build\S3ALIAS.COM src\tools\s3alias\s3alias.asm
if errorlevel 1 goto fail
"%NASM%" -f bin -isrc\tools\common\ -o build\VGALOG.COM src\tools\vgalog\vgalog.asm
if errorlevel 1 goto fail
"%NASM%" -f bin -isrc\tools\common\ -o build\S3REGS.COM src\tools\s3regs\s3regs.asm
if errorlevel 1 goto fail
"%NASM%" -f bin -isrc\tools\common\ -o build\S3REGS32.EXE src\tools\s3regs\s3regs32.asm
if errorlevel 1 goto fail
"%NASM%" -f bin -isrc\tools\common\ -o build\CHIPID.COM src\tools\chipid\chipid.asm
if errorlevel 1 goto fail
"%NASM%" -f bin -isrc\tools\common\ -o build\ROMVER.COM src\tools\romver\romver.asm
if errorlevel 1 goto fail
"%NASM%" -f bin -isrc\tools\common\ -o build\REPORT.COM src\tools\report\report.asm
if errorlevel 1 goto fail
copy /y src\tools\runall.bat build\RUNALL.BAT >nul
if errorlevel 1 goto fail
copy /y src\tools\clean.bat build\CLEAN.BAT >nul
if errorlevel 1 goto fail
echo build: done
exit /b 0
:failcd
cd ..\..\..
:fail
echo build: FAILED at the step above
exit /b 1
