vgalog /M
s3regs before tests
S3TEST /V /S > S3TEST.LOG
S3COMPAT /V /S > S3COMPAT.LOG
VSHOW /R /V /S > VSHOW.LOG
s3regs after tests
vgalog /D

copy c:\s3regs.txt s3regsr.txt
copy c:\vgalog.bin vgalogr.bin
zip runall.zip *.log s3regs.txt vgalog.bin s3regsr.txt vgalogr.bin

echo 
