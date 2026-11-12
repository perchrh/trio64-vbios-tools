# Testing the ROMs in 86Box

How the DOS test tools were run under 86Box with our ROM and with the stock Trio64V+ BIOS images, all
headless through 86Box's automation socket, on 11-12 November 2026. 86Box is an extra check only: the
hardware logs from the test machine remain the final word ([AGENTS.md](../AGENTS.md), "Verifying a
change"). The result archives are in [results/](../results/) as `86box-*.zip`.

## Recipe

1. Build tools and ROMs: `make clean all NASM=nasm/nasm-3.02/nasm` (tools land in `build/`, on D: in
   the VM; ROMs in `build/roms/<chip>-P<N>/`).
2. In the VM's `86box.cfg` pick the 86Box card for the chip (`s3_trio64v2dx_pci`, `s3_trio64vplus_pci`,
   `s3_trio64_pci`) and a `bios` variant from `vid_s3.c`, with `memory = 2`.
3. Copy the ROM image over the variant's ROM file name in `test/roms/video/s3/` (VM-local override;
   needs the `--vmpath` launch below) and in `build/src/roms/video/s3/` (executable-local, read in
   every launch style). Use the default build of the ROM (no `MCLK=`), whose lower 32 KB is the pinned
   `RESULT_SHA`.
4. Start headless (86Box built with `-D AUTOMATION=ON`):
   `env -u DISPLAY QT_QPA_PLATFORM=offscreen ./build/src/86Box --vmpath <vm dir> --vmname test --automation unix:/tmp/86box-auto.sock -N`.
5. Over the socket: `reset hard`, then `wait text <ms> <sign-on string>` to prove which ROM booted;
   poll `status`/`text` until the screen shows the REPORT `.zip` line and the DOS prompt (run done);
   then `quit`.
6. Extract the results from the VHD on the host: `cp dos71.vhd c.vhd && qemu-img convert -O raw c.vhd
   c.img && mcopy -i c.img@@32256 ::/trio64/RUNALL~1.ZIP results/<long-name>.zip`.
7. Read `S3TEST.LOG` / `S3COMPAT.LOG` in the zip; keep the 86Box artifacts (below) apart from hardware
   findings.

## The machine

A VM called `test` in `~/.local/share/86Box/Virtual Machines/test/`: an ECS P6BXT-A+ (i440BX,
`prosignias31x_bx`), Celeron 533, 64 MB RAM, DOS 7.1 on `dos71.vhd` (FAT16, partition at sector 63), and
the CD-ROM drive pointed at [`build/`](../build/) so the tools are on D:. Its `AUTOEXEC.BAT` copies the
tools from D: to `C:\trio64` and runs [`RUNALL.BAT`](../build/RUNALL.BAT) automatically, so a boot is a
full test run; `REPORT.COM` packs the logs into `runall-<chip>.zip` in `C:\trio64`.

## Choosing the video BIOS in 86Box

86Box resolves a relative ROM name (`roms/video/s3/...`) against a list of ROM paths. Start the VM
the way the VM manager starts a named machine, with `--vmpath <vm dir> --vmname <name>`: then the
startup log shows `# ROM path: .../Virtual Machines/test/roms/` first and the VM-local directory is
searched (there is no `-C` switch; a bare config path as the last argument is just the config). The
executable-local copy is `build/src/roms` (a symlink to the roms set), so replacing the file there
works for every launch style; we did both.

For these S3 PCI cards 86Box loads the first 32 KB of the ROM file (`rom_init(..., 0xc0000, 0x8000,
...)`), which for our 64 KB images is exactly the patched lower half. So the active override for our
ROM is:

    ~/.local/share/86Box/Virtual Machines/test/roms/video/s3/ASUS PCI-V775V2C (S3 Trio64V2 PCI).bin

copied from `build/roms/775-P27/775M50.BIN` (the default build; its lower 32 KB is the pinned
`RESULT_SHA` of [`src/roms/s3patch.py`](../src/roms/s3patch.py)). After `make clean all
NASM=nasm/nasm-3.02/nasm`, copy the new image over that path and restart the VM; the next boot runs
it (verified on screen: `wait text` matched `2.04.07-p27` during POST, and S3TEST reports
`ROM signature 2.04.07-p27 PASS`).

## Headless automation

The 86Box build with the control socket enabled (`cmake -D AUTOMATION=ON`, binary `build/src/86Box`)
runs without any display: `QT_QPA_PLATFORM=offscreen` with `DISPLAY` unset. Launch:

    env -u DISPLAY QT_QPA_PLATFORM=offscreen ./build/src/86Box \
        --vmpath "~/.local/share/86Box/Virtual Machines/test/" --vmname test \
        --automation unix:/tmp/86box-auto.sock -N

The socket speaks one line per request, one JSON line per reply (`doc/specifications/automation.md`
in the 86Box tree). Commands used: `status`, `text` (text screen via the BIOS data area), `wait text
<ms> <string>` (run until a screen row matches), `screenshot <png>`, `key down/up <scancode>` (set-1
codes, to type into DOS), `reset hard`, `quit`, `log`, `info`. Small helper scripts (one command per
line, connect, print the JSON) drove it from Python over the Unix socket; the boot check was
`wait text 20000 2.04.07-p27` after `reset hard`, and run completion was detected as: `bios_mode == 3`
for three consecutive `status` polls, then a `text` read containing the REPORT `.zip` line and the
`C:\trio64>` prompt.

## Getting the results out

The zip does not fit on a 1.44 MB floppy (2,060,808 bytes > 1,457,664), and the guest did not pick up
a floppy media swap while inserted, so the VHD is read on the host instead, after a clean `quit`:

    cp .../test/dos71.vhd copy.vhd && qemu-img convert -O raw copy.vhd raw.img
    mcopy -i raw.img@@32256 ::/trio64/RUNALL~1.ZIP results/<long-name>.zip

(partition 1 starts at sector 63, so the mtools offset is 63*512 = 32256). The archives were saved
with names naming the ROM under test, e.g. `results/86box-86c765-hercules-terminator-64-video-PCI-stock-runall.zip`.

## The runs

The Trio64V+ images were tested with `gfxcard = s3_trio64vplus_pci` and each `bios` variant from
`vid_s3.c` (`cardex_trio64vplus_pci`, `stealth64v_2001_pci`, `terminator_64v_pci`, `miromediatv_pci`,
`mirovideo22sd_pci`, `px_trio64vplus_pci`), `memory = 2`, same disk. All runs detected the chip as
Trio64V+ 86C765; our own run as Trio64V2/DX 86C775 with MCLK 50.11 MHz.

| ROM under test | S3TEST | S3COMPAT |
|---|---|---|
| our 2.04.07-p27 (`86box-86c775-our-2.04.07-p27-runall.zip`) | 38 pass, 2 fail, 0 skip | 225 pass, 23 fail, 9 warn |
| Cardex `S3T64VP.VBI` | 18 pass, 11 fail, 8 skip | 120 pass, 24 fail |
| Diamond Stealth64 Video 2001 | 16 pass, 13 fail, 8 skip | 100 pass, 39 fail |
| Hercules Terminator 64 Video | 15 pass, 14 fail, 8 skip | 116 pass, 26 fail |
| miroMEDIA TV | 15 pass, 14 fail, 8 skip | 112 pass, 31 fail |
| Phoenix `octekmirage64.VBI` | 16 pass, 13 fail, 8 skip | 118 pass, 25 fail |
| miroVIDEO 22SD | hung, see below | hung, see below |

The `ROM signature ... FAIL` line in every stock-ROM run is expected: S3TEST looks for our patched
`1.03-08N-p11` sign-on, and the stock images report 1.03-08, 1.02-02, 1.01-05 or none. The remaining
failures in all runs are 86Box model artifacts, not BIOS findings: banked-write throughput (86Box has
no real bus speed), the ATC flip-flop check, SR04/DAC readback in the CGA/MDA text modes, the PCI
subsystem ID read from config space (00000000), AH=1C state size and the video save pointer table,
and VESA modes whose measured refresh comes out doubled (139.5 vs 69.7 Hz) or off by 0.1 Hz by the
virtual clock. Refresh rates and line frequencies matched everywhere (CGA 70.0 Hz, VGA 59.9 Hz).

## Our ROMs on their own chips: 765 and 764

The same procedure with our other two ROMs, each overriding the stock image of a card we also have
on hardware (README "Chip codes"): the Trio64V+ ROM (`build/roms/765-P11/765M50.BIN`, the default
build whose lower 32 KB is the pinned `RESULT_SHA` of
[`src/roms/vplus/s3vpatch.py`](../src/roms/vplus/s3vpatch.py)) over `Hercules Terminator 64 Video (S3
Trio64V+ PCI).BIN` with `gfxcard = s3_trio64vplus_pci`, `bios = terminator_64v_pci`, `memory = 2`;
and the Trio64 ROM (the default `make 764x-rom` image, sign-on `1.5-07-p6`) over `86c764x1.bin` with
`gfxcard = s3_trio64_pci`, `bios = px_trio64_pci`, `memory = 2` (2 MB, not 4: no Trio64 card was built
with more). POST matched `1.03-08N-p11` resp. `1.5-07-p6` on screen, and both runs report
`ROM signature ... PASS`:

| ROM under test | archive in [results/](../results/) | S3TEST | S3COMPAT |
|---|---|---|---|
| our 1.03-08N-p11 (Trio64V+ 86C765) | `86box-86c765-our-1.03-08N-p11-runall.zip` | 18 pass, 11 fail, 8 skip | 119 pass, 24 fail, 4 warn, 7 skip |
| our 1.5-07-p6 (Trio64 86C764) | `86box-86c764-our-1.5-07-p6-runall.zip` | 18 pass, 8 fail, 8 skip | 118 pass, 21 fail, 3 warn, 7 skip |

The 86Box model reads the Phoenix-variant chip as 86C764-P; our ROM targets the 86C764X, and the
`764`-tagged tests key off the ROM sign-on, which matched. The failures are the same 86Box artifacts
as above (the 765 run adds the doubled/rounded VBE refresh measurements). After these runs the VM
config was restored to the Trio64V2/DX card with our 2.04.07-p27 override.

## Where the findings are documented

The behaviour differences seen across the eight runs (VCO and MCLK of the stock images, VBE mode
lists and versions, standard-mode coverage) are documented per chip, not here:
[docs/765-rom.md](765-rom.md) (the stock Trio64V+ images and our 1.03-08N-p11),
[docs/764-rom.md](764-rom.md) (our 1.5-07-p6 on the Trio64 model) and [docs/775-rom.md](775-rom.md)
(our 2.04.07-p27 on the Trio64V2/DX model).

## Limitations of 86Box for these tests

What did not work, and what to expect when it shows up in a log:

- DDC: the miroVIDEO 22SD run (`mirovideo22sd_pci`) never finished: S3COMPAT hung in the `4F15` DDC/EDID
test. The last record in its `S3COMPAT.DBG` is the `INT 10h AX=4F15 BX=0100` call entry with no return
after more than 10 minutes of emulated time. 86Box does serve a default EDID on the DDC bus
(`ddc_init()` in `src/video/vid_ddc.c` always installs one, custom EDID only with `monitor_edid` /
`monitor_edid_path` in the VM's `[Video]` section), so the hang is not a missing EDID: this BIOS's
DDC poll loop never completes against 86Box's S3 DDC model. The other five V+ ROMs return from 4F15
quickly. No zip was produced for this ROM; the partial logs (S3TEST complete, S3COMPAT up to the DDC
test) were kept out of `results/` to avoid passing off an incomplete run as a result. On real
hardware with a DDC monitor this test completes (the card's Dell 2021FP answers EDID over DDC2).
- Floppy copy-out: the result zip is ~1.1-2.1 MB, larger than a 1.44 MB floppy's 1,457,664 bytes, and
  the guest did not pick up a floppy media swap while inserted; read the VHD on the host instead
  (recipe step 6).
- Model artifacts that show up as FAIL/WARN in every run, on our ROMs and the stock ones alike: no
  real bus speed (throughput test), the ATC flip-flop, AH=1C state size, the video save pointer table,
  and VBE refresh measurements doubled or off by 0.1 Hz by the virtual clock (the `vberef` reproducer
  also has a units bug of its own, so on the card it printed HZ10=0 as well; `vbe2` is the corrected
  probe, and the PIT-latch probe `vbe4` gives the same vsync edge counts on the card and in 86Box
  (68/59 vs 69/59 for modes 03h/101h), so the remaining refresh offset is the probe's sampling, not
  the emulator - see [docs/775-rom.md](775-rom.md) "In 86Box"). None of these are BIOS bugs; judge them
  against the hardware logs, not the 86Box ones. Two entries from an earlier draft of
  this list turned out not to be 86Box artifacts: the PCI subsystem ID (config 2Ch-2Fh read 00000000 in
  the 7.0 build we ran; with the CR81-CR84 shadow mapping it reads 89015333, the same as the card -
  CR81-84 hold the ROM bytes C000:0040-0043, see chip-rules V2-PCI-1) and the SR04/DAC readback in
  CGA/MDA text modes (86Box reads SR04=09h and DAC entry 01 = 090909, the same as the card; the
  FAIL/WARN came from comparing against the IBM VGA reference values, not against the card). See
  [docs/775-rom.md](775-rom.md) "In 86Box".
