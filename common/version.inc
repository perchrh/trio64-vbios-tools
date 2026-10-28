; version.inc - version numbers shared by all tools; every tool includes it near its top.
;
; VERSION  the tool version, printed by every tool on its first line of output and in its messages.
;          All tools share it. Change it here, or override it for one build:
;              make VERSION=0.9          (or: nasm -DVERSION="'0.9'" ...)
; ROMVER   the ROM sign-on version S3TEST expects (its signature test and title line). Override:
;              make ROMVER=2.04.07-p13   (or: nasm -DROMVER="'2.04.07-p13'" ...)
%ifndef VERSION
%define VERSION '1.0'
%endif
%ifndef ROMVER
%define ROMVER '2.04.07-p16'
%endif
