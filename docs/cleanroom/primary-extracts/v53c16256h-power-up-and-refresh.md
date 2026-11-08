# V53C16256H: refresh and power-on (extract)

Source: Mosel Vitelic V53C16256H, 256K x 16 Fast Page Mode CMOS DRAM, Rev. 2.3, June 1998,
[`datasheets/dram/V53C16256H-1.PDF`](../../../datasheets/dram/V53C16256H-1.PDF). The DSP-3364P fits this part
(outside review of 2 November 2026; POST-41, MODE-130).

ASCII paraphrase of the cited pages for the leak reviewer. Prefer the PDF on any conflict.

## Refresh interval (page 1 Features; AC parameter 52 on page 7)

- Features: "Refresh Interval: 512 cycles/8 ms".
- Description: "The V53C16256H has symmetric address and accepts 512 cycle 8ms interval."
- AC Characteristics parameter 52, symbol tREF: Refresh Interval (512 Cycles), 8 ms (all speed grades).

So the part needs 512 RAS-containing refresh cycles in every 8 ms window.

## Power-On (page 17; the section begins at the end of page 16's write-cycle text)

> Power-On
>
> After application of the VCC supply, an initial pause of 200 ms is required followed by a
> minimum of 8 initialization cycles (any combination of cycles containing a RAS clock). Eight
> initialization cycles are required after extended periods of bias without clocks (greater than
> the Refresh Interval).
>
> During Power-On, the VCC current requirement of the V53C16256H is dependent on the input levels
> of RAS and CAS. If RAS is low during Power-On, the device will go into an active cycle and ICC
> will exhibit current transients. It is recommended that RAS and CAS track with VCC or be held at
> a valid VIH during Power-On to avoid current surges.

Notes for the specification:

- The pause is **200 ms**, not 200 us (POST-41 previously said us; corrected from this page).
- The eight cycles must be RAS-containing initialization cycles. The sheet does not say that eight
  CPU reads of the VGA aperture are enough by themselves; the clean ROM must state which controller
  accesses produce qualifying RAS cycles on the Trio64.
- Initialization cycles are not memory-test results.
