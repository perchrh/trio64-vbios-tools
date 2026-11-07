; pll.inc - legal MCLK PLL pairs from the floor pair upward.
; Built by the integer formula the tools use (s3compat pllcalc):
;   f_kHz = (14318 * (M+2) / (N+2)) >> R
; VCO in 135000..270000 kHz, M 1-127, N 1-31, R 0-3, SR10 bit 7 clear.
; One entry per kHz. Ties: smaller N, then smaller R, then smaller M.
; The floor pair SR10=41h SR11=28h is 50113 kHz here (50.114 MHz with
; the 14.31818 MHz reference). The highest entry covers a 66.67 MHz
; datasheet maximum plus 25 percent (83333 kHz).
pll_tab:
        dd 50113
        db 0x41, 0x28
        dd 50510
        db 0x47, 0x7D
        dd 50560
        db 0x46, 0x6F
        dd 50624
        db 0x45, 0x61
        dd 50709
        db 0x44, 0x53
        dd 50828
        db 0x43, 0x45
        dd 50908
        db 0x47, 0x7E
        dd 51007
        db 0x42, 0x37
        dd 51135
        db 0x45, 0x62
        dd 51306
        db 0x41, 0x29
        dd 51455
        db 0x46, 0x71
        dd 51544
        db 0x43, 0x46
        dd 51647
        db 0x45, 0x63
        dd 51902
        db 0x42, 0x38
        dd 52158
        db 0x45, 0x64
        dd 52260
        db 0x43, 0x47
        dd 52350
        db 0x46, 0x73
        dd 52499
        db 0x41, 0x2A
        dd 52669
        db 0x45, 0x65
        dd 52797
        db 0x42, 0x39
        dd 52976
        db 0x43, 0x48
        dd 53095
        db 0x44, 0x57
        dd 53181
        db 0x45, 0x66
        dd 53245
        db 0x46, 0x75
        dd 53692
        db 0x41, 0x2B
        dd 54139
        db 0x46, 0x77
        dd 54203
        db 0x45, 0x68
        dd 54289
        db 0x44, 0x59
        dd 54408
        db 0x43, 0x4A
        dd 54587
        db 0x42, 0x3B
        dd 54715
        db 0x45, 0x69
        dd 54885
        db 0x41, 0x2C
        dd 55034
        db 0x46, 0x79
        dd 55124
        db 0x43, 0x4B
        dd 55226
        db 0x45, 0x6A
        dd 55482
        db 0x42, 0x3C
        dd 55737
        db 0x45, 0x6B
        dd 55840
        db 0x43, 0x4C
        dd 55929
        db 0x46, 0x7B
        dd 56078
        db 0x41, 0x2D
        dd 56249
        db 0x45, 0x6C
        dd 56377
        db 0x42, 0x3D
        dd 56556
        db 0x43, 0x4D
        dd 56675
        db 0x44, 0x5D
        dd 56760
        db 0x45, 0x6D
        dd 56824
        db 0x46, 0x7D
        dd 57272
        db 0x41, 0x2E
        dd 57719
        db 0x46, 0x7F
        dd 57783
        db 0x45, 0x6F
        dd 57868
        db 0x44, 0x5F
        dd 57987
        db 0x43, 0x4F
        dd 58166
        db 0x42, 0x3F
        dd 58294
        db 0x45, 0x70
        dd 58465
        db 0x41, 0x2F
        dd 58703
        db 0x43, 0x50
        dd 58806
        db 0x45, 0x71
        dd 59061
        db 0x42, 0x40
        dd 59317
        db 0x45, 0x72
        dd 59419
        db 0x43, 0x51
        dd 59658
        db 0x41, 0x30
        dd 59828
        db 0x45, 0x73
        dd 59956
        db 0x42, 0x41
        dd 60135
        db 0x43, 0x52
        dd 60254
        db 0x44, 0x63
        dd 60340
        db 0x45, 0x74
        dd 60851
        db 0x41, 0x31
        dd 61362
        db 0x45, 0x76
        dd 61448
        db 0x44, 0x65
        dd 61567
        db 0x43, 0x54
        dd 61746
        db 0x42, 0x43
        dd 61874
        db 0x45, 0x77
        dd 62044
        db 0x41, 0x32
        dd 62283
        db 0x43, 0x55
        dd 62385
        db 0x45, 0x78
        dd 62641
        db 0x42, 0x44
        dd 62896
        db 0x45, 0x79
        dd 62999
        db 0x43, 0x56
        dd 63237
        db 0x41, 0x33
        dd 63408
        db 0x45, 0x7A
        dd 63536
        db 0x42, 0x45
        dd 63715
        db 0x43, 0x57
        dd 63834
        db 0x44, 0x69
        dd 63919
        db 0x45, 0x7B
        dd 64431
        db 0x41, 0x34
        dd 64942
        db 0x45, 0x7D
        dd 65027
        db 0x44, 0x6B
        dd 65146
        db 0x43, 0x59
        dd 65325
        db 0x42, 0x47
        dd 65453
        db 0x45, 0x7E
        dd 65624
        db 0x41, 0x35
        dd 65862
        db 0x43, 0x5A
        dd 65965
        db 0x45, 0x7F
        dd 66220
        db 0x42, 0x48
        dd 66578
        db 0x43, 0x5B
        dd 66817
        db 0x41, 0x36
        dd 67115
        db 0x42, 0x49
        dd 67294
        db 0x43, 0x5C
        dd 67413
        db 0x44, 0x6F
        dd 67612
        db 0x27, 0x53
        dd 67685
        db 0x29, 0x66
        dd 67735
        db 0x2B, 0x79
        dd 68010
        db 0x22, 0x24
        dd 68285
        db 0x2B, 0x7A
        dd 68335
        db 0x29, 0x67
        dd 68408
        db 0x27, 0x54
        dd 68521
        db 0x25, 0x41
        dd 68607
        db 0x2A, 0x71
        dd 68726
        db 0x23, 0x2E
        dd 68836
        db 0x2B, 0x7B
        dd 68905
        db 0x26, 0x4B
        dd 68986
        db 0x29, 0x68
        dd 69203
        db 0x21, 0x1B
        dd 69387
        db 0x2B, 0x7C
        dd 69442
        db 0x28, 0x5F
        dd 69544
        db 0x25, 0x42
        dd 69637
        db 0x29, 0x69
        dd 69800
        db 0x22, 0x25
        dd 69937
        db 0x2B, 0x7D
        dd 69999
        db 0x27, 0x56
        dd 70158
        db 0x23, 0x2F
        dd 70288
        db 0x29, 0x6A
        dd 70396
        db 0x24, 0x39
        dd 70488
        db 0x2B, 0x7E
        dd 70567
        db 0x25, 0x43
        dd 70695
        db 0x26, 0x4D
        dd 70794
        db 0x27, 0x57
        dd 70874
        db 0x28, 0x61
        dd 70939
        db 0x29, 0x6B
        dd 70993
        db 0x2A, 0x75
        dd 71039
        db 0x2B, 0x7F
        dd 71590
        db 0x21, 0x1C
        dd 72186
        db 0x2A, 0x77
        dd 72240
        db 0x29, 0x6D
        dd 72305
        db 0x28, 0x63
        dd 72385
        db 0x27, 0x59
        dd 72484
        db 0x26, 0x4F
        dd 72612
        db 0x25, 0x45
        dd 72783
        db 0x24, 0x3B
        dd 72891
        db 0x29, 0x6E
        dd 73021
        db 0x23, 0x31
        dd 73180
        db 0x27, 0x5A
        dd 73379
        db 0x22, 0x27
        dd 73542
        db 0x29, 0x6F
        dd 73635
        db 0x25, 0x46
        dd 73737
        db 0x28, 0x65
        dd 73976
        db 0x21, 0x1D
        dd 74193
        db 0x29, 0x70
        dd 74274
        db 0x26, 0x51
        dd 74453
        db 0x23, 0x32
        dd 74572
        db 0x2A, 0x7B
        dd 74658
        db 0x25, 0x47
        dd 74771
        db 0x27, 0x5C
        dd 74844
        db 0x29, 0x71
        dd 75169
        db 0x22, 0x28
        dd 75494
        db 0x29, 0x72
        dd 75567
        db 0x27, 0x5D
        dd 75680
        db 0x25, 0x48
        dd 75766
        db 0x2A, 0x7D
        dd 75885
        db 0x23, 0x33
        dd 76064
        db 0x26, 0x53
        dd 76145
        db 0x29, 0x73
        dd 76362
        db 0x21, 0x1E
        dd 76601
        db 0x28, 0x69
        dd 76703
        db 0x25, 0x49
        dd 76796
        db 0x29, 0x74
        dd 76959
        db 0x22, 0x29
        dd 77158
        db 0x27, 0x5F
        dd 77317
        db 0x23, 0x34
        dd 77447
        db 0x29, 0x75
        dd 77555
        db 0x24, 0x3F
        dd 77726
        db 0x25, 0x4A
        dd 77854
        db 0x26, 0x55
        dd 77953
        db 0x27, 0x60
        dd 78033
        db 0x28, 0x6B
        dd 78098
        db 0x29, 0x76
        dd 78749
        db 0x21, 0x1F
        dd 79399
        db 0x29, 0x78
        dd 79464
        db 0x28, 0x6D
        dd 79544
        db 0x27, 0x62
        dd 79643
        db 0x26, 0x57
        dd 79771
        db 0x25, 0x4C
        dd 79942
        db 0x24, 0x41
        dd 80050
        db 0x29, 0x79
        dd 80180
        db 0x23, 0x36
        dd 80339
        db 0x27, 0x63
        dd 80538
        db 0x22, 0x2B
        dd 80701
        db 0x29, 0x7A
        dd 80794
        db 0x25, 0x4D
        dd 80896
        db 0x28, 0x6F
        dd 81135
        db 0x21, 0x20
        dd 81352
        db 0x29, 0x7B
        dd 81433
        db 0x26, 0x59
        dd 81612
        db 0x23, 0x37
        dd 81817
        db 0x25, 0x4E
        dd 81930
        db 0x27, 0x65
        dd 82003
        db 0x29, 0x7C
        dd 82328
        db 0x22, 0x2C
        dd 82653
        db 0x29, 0x7D
        dd 82726
        db 0x27, 0x66
        dd 82839
        db 0x25, 0x4F
        dd 83044
        db 0x23, 0x38
        dd 83223
        db 0x26, 0x5B
        dd 83304
        db 0x29, 0x7E
pll_end:
PLL_N equ (pll_end - pll_tab) / 6
