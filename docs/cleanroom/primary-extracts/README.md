# Primary extracts for leak review

Permitted primary-source pages the independent review of 2 November 2026 needed to close
verification returns (A-1, B-1, POST-41, MODE-130). The reviewer may read this folder and the
full PDFs it cites ([`LEAK-REVIEW.md`](../LEAK-REVIEW.md) "May read").

| Extract | Full document in the repository | Closes |
| --- | --- | --- |
| [`v53c16256h-power-up-and-refresh.md`](v53c16256h-power-up-and-refresh.md) | [`datasheets/V53C16256H-1.PDF`](../../../datasheets/V53C16256H-1.PDF) | POST-41, MODE-130 / MQ-5 refresh premise |
| [`dmt-640x480-60hz.md`](dmt-640x480-60hz.md) | [`standards/vesa/VESA-DMT-1.0-Rev10.pdf`](../../../standards/vesa/VESA-DMT-1.0-Rev10.pdf) | part B 101h timing and border (MQ-16) |
| PCI Local Bus 2.3 section 6.3 | owner-held (README "Missing documents"); not in-tree yet | part A ROM-/PCI- rows |
| VBE 1.2 (VS911022) failure / AH=0Fh clauses | owner-held retype (`vbe12.txt`); in-tree stand-in: [`standards/thoegersen/VESA.TXT`](../../../standards/thoegersen/VESA.TXT) and VBE 2.0 [`standards/vesa/vbe20.pdf`](../../../standards/vesa/vbe20.pdf) | part C returned generalizations |

Add the PCI 2.3 section 6.3 extract (and the VBE 1.2 retype if its terms allow) under this folder when
available, then name the paths in LEAK-REVIEW "May read".
