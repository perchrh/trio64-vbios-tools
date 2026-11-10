vgalog /M /XL
s3regs before tests
s3regs before S3TEST
S3TEST /V /S > S3TEST.LOG
vgalog /D
if exist vgalog.bin ren vgalog.bin vgalog0.bin
vgalog /U
vgalog /M /XL
s3regs before S3COMPAT
S3COMPAT /V /S > S3COMPAT.LOG
vgalog /D
if exist vgalog.bin ren vgalog.bin vgalog1.bin
vgalog /U
vgalog /M /XL
s3regs before VBESHOW
VBESHOW /R /V /S > VBESHOW.LOG
vgalog /D
if exist vgalog.bin ren vgalog.bin vgalog2.bin
vgalog /U
vgalog /M /XL
s3regs before VGASHOW
VGASHOW /R /V /S > VGASHOW.LOG
vgalog /D
if exist vgalog.bin ren vgalog.bin vgalog3.bin
vgalog /U
vgalog /M /XL
s3regs after tests
vgalog /D

if exist c:\s3regs.txt copy c:\s3regs.txt s3regsr.txt
if exist c:\vgalog.bin copy c:\vgalog.bin vgalogr.bin
report

echo 
