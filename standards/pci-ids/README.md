# pci-ids/

The PCI ID database (`pci.ids`), version 2026.11.09 (dated 2026-11-09 03:15:02), copied unmodified
from the PCI ID Project's repository:
[github.com/pciutils/pciids/blob/master/pci.ids](https://github.com/pciutils/pciids/blob/master/pci.ids)
(raw file fetched 10 November 2026).

- SHA-256 of the copy: `78ad8a9c006924ea1ec7932e481eaa4c85ceb7fd59b8722c8a08e2f24fadf90e`
- Licence, stated in the file's own header (kept intact at the top of `pci.ids`): the file can be
  distributed under either the GNU General Public License (version 2 or higher) or the 3-clause BSD
  License. The database is a compilation of factual data; the copyright covers only the aggregation
  and formatting (Martin Mares and Albert Pool). The project site is
  [pci-ids.ucw.cz](https://pci-ids.ucw.cz/); the vendor list for S3 Graphics (5333h), where the Trio
  models are listed among the other S3 parts, is browsable at
  [admin.pci-ids.ucw.cz/read/PC/5333](https://admin.pci-ids.ucw.cz/read/PC/5333).

Of use here: the PCI vendor and device IDs and names of the Trio64 family and its relatives, under
vendor `5333` "S3 Graphics Ltd." - `8811` 86c764/765 [Trio32/64/64V+], `8812` 86cM65 [Aurora64V+],
`8814` 86c767 [Trio 64UV+], `8901` 86c775/86c785 [Trio 64V2/DX or /GX], `8904` 86c365, 86c366
[Trio 3D], `8a13` 86c360 [Trio 3D/1X], 86c362, 86c368 [Trio 3D/2X] - cited as PCI-IDS by
[`docs/chip-rules.md`](../docs/chip-rules.md) (AV-ID-1, T3D-ID-1, T3D2X-ID-1 and the ID rows). It is
a public source for the clean side (owner decision, 10 November 2026): the vendor:device IDs are
hardware facts, not vendor-BIOS or vendor-driver material, so they may cross; the reading order is
[`docs/cleanroom/readings.md`](../docs/cleanroom/readings.md).
