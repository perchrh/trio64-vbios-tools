; version.inc - version numbers shared by all tools; every tool includes it near its top.
;
; VERSION  the tool version, printed by every tool on its first line of output and in its messages.
;          All tools share it. Change it here, or override it for one build:
;              make VERSION=0.9          (or: nasm -DVERSION="'0.9'" ...)
; VER775   the level of our Trio64V2 ROM: rompatch/s3patch.py writes it into the sign-on, and S3TEST
;          expects it on a Trio64V2 (its signature test and title line). This file is the one place the
;          ROM levels are kept: a new level changes only this line. Override for the tools alone (the
;          patchers read the line below, not the override):
;              make VER775=2.04.07-p13   (or: nasm -DVER775="'2.04.07-p13'" ...)
; VER765  the same for our Trio64V+ ROM: rompatch/vplus/s3vpatch.py, S3TEST on a Trio64V+ (make VER765=...)
; VER764  the same for our Trio64 ROM: rompatch/trio64/s3tpatch.py, S3TEST on a Trio64 (make VER764=...)
%ifndef VERSION
%define VERSION '1.0.0'
%endif
%ifndef VER775
%define VER775 '2.04.07-p22'
%endif
%ifndef VER765
%define VER765 '1.03-08-p1'
%endif
%ifndef VER764
%define VER764 '1.5-07-p3'
%endif
