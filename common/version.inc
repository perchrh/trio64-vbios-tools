; version.inc - version numbers shared by all tools; every tool includes it near its top.
;
; VERSION  the tool version, printed by every tool on its first line of output and in its messages.
;          All tools share it. Change it here, or override it for one build:
;              make VERSION=0.9          (or: nasm -DVERSION="'0.9'" ...)
; ROMVER   the ROM sign-on version S3TEST expects on a Trio64V2 (its signature test and title line):
;          the level rompatch/s3patch.py builds. Override:
;              make ROMVER=2.04.07-p13   (or: nasm -DROMVER="'2.04.07-p13'" ...)
; VROMVER  the same on a Trio64V+: the level rompatch/vplus/s3vpatch.py builds (make VROMVER=...)
; TROMVER  the same on a Trio64: the level rompatch/trio64/s3tpatch.py builds (make TROMVER=...)
%ifndef VERSION
%define VERSION '1.0'
%endif
%ifndef ROMVER
%define ROMVER '2.04.07-p21'
%endif
%ifndef VROMVER
%define VROMVER '1.03-08-p1'
%endif
%ifndef TROMVER
%define TROMVER '1.5-07-p2'
%endif
