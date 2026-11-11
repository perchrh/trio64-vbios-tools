# Primary extracts for leak review

Permitted primary-source pages the independent review of 2 November 2026 needed to close
verification returns (A-1, B-1, POST-41, MODE-130). The reviewer may read this folder and the
full documents it cites ([`LEAK-REVIEW.md`](../LEAK-REVIEW.md) "May read").

| Extract | Full document in the repository | Closes |
| --- | --- | --- |
| [`v53c16256h-power-up-and-refresh.md`](v53c16256h-power-up-and-refresh.md) | [`datasheets/dram/V53C16256H-1.PDF`](../../../datasheets/dram/V53C16256H-1.PDF) | POST-41, MODE-130 / MQ-5 refresh premise |
| [`dmt-640x480-60hz.md`](dmt-640x480-60hz.md) | VESA DMT 1.0 Rev. 10; the PDF was removed from the repository (9963092), the public copy is [VESA-DMT-1.13.pdf](https://glenwing.github.io/docs/VESA-DMT-1.13.pdf) | part B 101h timing and border (MQ-16) |
| [`pci-2.3-section-6.3.md`](pci-2.3-section-6.3.md) | [`standards/pci/pci23.pdf`](../../../standards/pci/pci23.pdf) | part A ROM-/PCI- rows (ROM-1..6, POST-1) |
| [`vbe-1.2-status-and-ah0f.md`](vbe-1.2-status-and-ah0f.md) | [`standards/vesa/vbe12.txt`](../../../standards/vesa/vbe12.txt) | part C status / failure, AH=0Fh reinit, ModeAttributes D0 |
| [`vision964-sense-input-utilization.md`](vision964-sense-input-utilization.md) | [`datasheets/s3/pdf/86c964-vision964.pdf`](../../../datasheets/s3/pdf/86c964-vision964.pdf) (section 8.2.7; verbatim the same in the Vision864 book) | milestone 5, the monitor sense (M-SENSE): the S3 BIOS sense procedure and classification |
| [`ibm-bios-power-on-mode-and-mono-state.md`](ibm-bios-power-on-mode-and-mono-state.md) | IBM PS/2 and PC BIOS Interface Technical Reference, April 1987 (owner's copy, not in the repository; a scanned copy is at the Internet Archive: [archive.org/details/bitsavers_ibmpcps2PSTechnicalReferenceApr87_5816663](https://archive.org/details/bitsavers_ibmpcps2PSTechnicalReferenceApr87_5816663)) | milestone 5, the monitor sense (M-SENSE): the power-on mode by display type (03h colour / 07h mono) and the software-visible monochrome and grey-summing state |
| [`ferraro-table-8-14-color-register-defaults.md`](ferraro-table-8-14-color-register-defaults.md) | Ferraro, "Programmer's Guide to the EGA, VGA, and Super VGA Cards", 3rd edition, section 8.3.5 and Table 8.14 (owner-supplied full text, 8 November 2026; the printed row indices verified the transcription) | bios-rules B00-10 (mode 13h's 256-colour default DAC loading) and B00-11 (the 16-colour defaults, entry 6 the brown exception) |
| [`trio32-64-enhanced-mode-graphics-engine.md`](trio32-64-enhanced-mode-graphics-engine.md) | [`datasheets/s3/pdf/358_357_86c732-86c764_trio32_64.pdf`](../../../datasheets/s3/pdf/358_357_86c732-86c764_trio32_64.pdf) (sections 6.1, 7.4, 13, 13.1, 13.3.3, 9AE8h) | chip-rules ENG-2, ENG-3, ENG-4 and spec-b MODE-151: the graphics engine's rectangle fill and access path (engine clear of video memory, no PCI bus traffic, expected faster than CPU writes) |
| [`trio64vplus-15.2-engine-access.md`](trio64vplus-15.2-engine-access.md) | [`datasheets/s3/pdf/db018-a-trio64v-integrated-graphics-video-accelerator-jul95.pdf`](../../../datasheets/s3/pdf/db018-a-trio64v-integrated-graphics-video-accelerator-jul95.pdf) (section 15.2; the V2 and UV+ books inherit it) | the same, the V+ form (Pixel Data Transfer registers E2E8h/E2EAh) |
