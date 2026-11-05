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
| Q0F | After 4F02h of 101h, AH=0Fh must not return S3's private `69h`. Choose a **project extended-mode number** in 20h-7Eh that this ROM's AH=00h restores as the same banked 101h mode (VBE 1.2's restorable-result recommendation), and document that number in the clean ROM. Milestone 4 does not prove the benchmark reads AL. Until the clean ROM assigns the number, the contract requires only: restorable via AH=00h, no vendor private ID. | VBE-45; milestone contract |
| MCLK / T64-MEM-7 | **Board/project policy**, not a public chip rating. Data book MEM-1 remains 60 MHz. Default clean build for the DSP-3364P: nearest PLL at or below 60 MHz (59.96 MHz). Optional build clocks up to 70 MHz are an explicit board overclock policy (observed 69.8 MHz on that card); they must not be worded as an 86C764X datasheet rating. | POST-22/-23; T64-MEM-7 |
| FIFO / MODE-136 | No unexplained reference-derived constants in the crossing copy. For milestones 1-4 the clean ROM **chooses and documents** M (CR54) for mode 101h and VGA return from public latency/capacity constraints or a bounded DSP-3364P underrun observation. The old floor((t-23)/6) formula is cut from the clean copy until re-derived. | MODE-136/-137/-148; MQ-12 |
| POST-41 | Cite [`primary-extracts/v53c16256h-power-up-and-refresh.md`](primary-extracts/v53c16256h-power-up-and-refresh.md): **200 ms** pause, then at least eight RAS-containing initialization cycles. Do not prescribe "eight CPU reads". State that initialization accesses are not memory-test results; name how the Trio64 produces RAS cycles when the sequence is chosen. | POST-41 |
| ROM-8 | Project naming policy: own identification string and version suffix; no prescribed "Version " text or first-256-byte placement from a reference BIOS. | ROM-8 |
| ROM-9 | No "IBM" bytes at offset 1Eh until a public expansion-ROM or demonstrated client need is shown. | ROM-9 |
| CONV-3/-12 | Cut from the milestone-1-4 clean copy (Windows driver acceptance is out of scope). | CONV-3, CONV-12 |
| Index/lock | Keep CONV-8/-9 as **project-chosen** contracts (AGENTS), not data-book guarantees; attribute-controller behaviour stays with B00-9 / B10-4. | CONV-8, CONV-9 |

Primary pages for the next leak review: [`primary-extracts/`](primary-extracts/).
