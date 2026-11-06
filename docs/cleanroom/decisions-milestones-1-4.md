# Owner decisions that close independent-review returns (milestones 1-4)

Recorded 5 November 2026 to answer returns the independent leak review of 2 November 2026 would not
invent ([#145](https://github.com/perchrh/trio64-vbios-tools/issues/145),
[`README.md`](README.md) "Authorized independent review - 2026-11-02"). Dirty side only until the
changed specification rows pass a fresh leak review. Not legal advice.

These follow from the already decided milestone scope (DSP-3364P; POST; MS-DOS/EDIT; Superscape;
Chris's 3D Benchmark with VESA **101h** only).

| ID | Decision | Spec effect |
| --- | --- | --- |
| Q100 | Mode **100h** is queryable: 4F01h returns its public 640x400x8 geometry and window fields. It is **not** settable in milestones 1-4: ModeAttributes bit D0 clear (not supported in this configuration), and 4F02h BX=0100h returns the unsupported-mode failure status of part C. It may appear in the 4F00h list only if the list is allowed to name unsupported modes that 4F01h reports with D0 clear; otherwise omit it from the list and still answer 4F01h. Prefer: **list 101h then FFFFh** for the milestone-4 clean copy; still succeed 4F01h for CX=0100h with D0 clear so Chris's queries get AX=004Fh without a false "settable" claim. | VBE-10/-11/-12 and mode table; milestone contract |
| Q0F | After 4F02h of 101h, AH=0Fh returns AL = **40h** (0040:0049h holds 40h). INT 10h AH=00h with AL = 40h sets the same banked 101h mode again, and AL bit 7 keeps memory as in a normal mode set. 40h is this ROM's number: it sits in 20h-7Eh, it is not S3's 69h, and it is not one of 20h, 60h or 7Fh, which the unsupported-mode test already uses. Milestone 4 does not show that the benchmark reads AL. Assigned 6 November 2026. | VBE-45; milestone contract |
| MCLK / T64-MEM-7 | **Board/project policy**, not a public chip rating. Data book MEM-1 remains 60 MHz. Default clean build for the DSP-3364P: nearest PLL at or below 60 MHz (59.96 MHz). Optional build clocks up to 70 MHz are an explicit board overclock policy (observed 69.8 MHz on that card); they must not be worded as an 86C764X datasheet rating. | POST-22/-23; T64-MEM-7 |
| FIFO / MODE-136 | For mode 101h, M = **31** (CR54 = F8h) and CR60 = FFh. The data book gives a 16-position FIFO and a worst wait of 9 + 2*M MCLKs (one slow entry cycle, then M page cycles). At 25.175 MHz and 59.96 MHz that wait drains about 30 bytes at M = 31, inside both the 128-byte FIFO (2 MB and 4 MB) and the 64-byte FIFO (1 MB). M = 31 is the 5-bit maximum. The old (t - 23) / 6 formula stays out of the clean copy. If a build's MCLK is low enough that the same wait would drain more than the FIFO, lower M until it fits. Assigned 6 November 2026. | MODE-136; MODE-148 |
| POST-41 | Cite [`primary-extracts/v53c16256h-power-up-and-refresh.md`](primary-extracts/v53c16256h-power-up-and-refresh.md): **200 ms** pause, then at least eight RAS-containing initialization cycles. Do not prescribe "eight CPU reads". State that initialization accesses are not memory-test results; name how the Trio64 produces RAS cycles when the sequence is chosen. | POST-41 |
| ROM-8 | Project naming policy: own identification string and version suffix; no prescribed "Version " text or first-256-byte placement from a reference BIOS. | ROM-8 |
| ROM-9 | No "IBM" bytes at offset 1Eh until a public expansion-ROM or demonstrated client need is shown. | ROM-9 |
| CONV-3/-12 | Cut from the milestone-1-4 clean copy (Windows driver acceptance is out of scope). | CONV-3, CONV-12 |
| Index/lock | Keep CONV-8/-9 as **project-chosen** contracts (AGENTS), not data-book guarantees; attribute-controller behaviour stays with B00-9 / B10-4. | CONV-8, CONV-9 |
| Fonts | **Closed.** Use Joseph Gil's FNTCOL16 individual fonts in [`rompatch/fonts/`](../../rompatch/fonts/) and generate the five ROM tables with [`fonts.py`](../../rompatch/fonts/fonts.py) (including the 9-dot alternates). Gil's notice (`COPYLEFT.TXT`) is the project licence basis; no BIOS- or other-project-sourced font bytes. FreeDOS cpidos is not the project alternative. Manifest: [`asset-manifest.md`](asset-manifest.md). Already implemented (#141). | clean-room fonts; allowlist export |
| M2-BOOT | Milestone 2 acceptance boots MS-DOS 6.22 **without** `CONFIG.SYS` and **without** `AUTOEXEC.BAT`, and with an **empty PATH**. The contract is EDIT's recorded INT 10h calls only ([`milestone-calls.md`](milestone-calls.md)). Shell helpers (CLS, DOSKEY, and other AUTOEXEC/PATH programs) are out of scope: no ownership work and no surround call table in the clean contract. | milestone 2; milestone-calls |

Primary pages for the next leak review: [`primary-extracts/`](primary-extracts/).
