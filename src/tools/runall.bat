vgalog /M
s3regs before tests
S3TEST /V /S > S3TEST.LOG
S3COMPAT /V /S > S3COMPAT.LOG
VSHOW /R /V /S > VSHOW.LOG
s3regs after tests
vgalog /D

if exist c:\s3regs.txt copy c:\s3regs.txt s3regsr.txt
if exist c:\vgalog.bin copy c:\vgalog.bin vgalogr.bin
if exist runall.zip del runall.zip
zip runall.zip *.log *.dbg s3regs.txt vgalog.bin s3regsr.txt vgalogr.bin

echo 
