# fagaceae-phylo

[![DOI](https://zenodo.org/badge/546717251.svg)](https://doi.org/10.5281/zenodo.20141954)

Spliced phylogenies of Fagaceae (oaks, beeches, chestnuts), built in R for downstream use in host-association and comparative studies. The repository contains independent subprojects organized by year; each is self-contained under its own directory.

## Authors
Scripts by Andrew Hipp (ahipp@mortonarb.org). Phylogenies by Althaus / Hipp et al. (2026) (_Quercus_), and Elliot Gardner (exg258@case.edu) and Kasey Pham (kxp574@case.edu) (Fagaceae).  

The Hyb-Seq phylogeny has not previously been published. Authorship for that phylogeny:
- Elliot M. Gardner
- Mira Garner
- Marlene Hahn
- Lindsey Worcester
- Joan Pereira
- Deby Arifiani
- Sahromi
- M. Socorro González-Elizondo
- Tiange Lang
- Chuck Cannon
- Paul S. Manos
- Andrew L. Hipp

## Subprojects

### `galls_2022/`
Phylogenies for cynipid gall-wasp host-oak associations. Mature and operational, with archived output runs.

- **Input:** reference tree (`DATA/supertimetree.hyboakconstrained.climateTips.tre`) plus the host-oak spreadsheet (`DATA/Global Cynipini host oak list 20220520.xlsx`).
- **Pipeline:** `simplePhylo()` splices taxa onto the reference tree using `trName`, `position`, and `tip` columns from the spreadsheet.
- **Output:** timestamped `.tre`, `.pdf`, and missing-taxa `.csv` files in `OUT/`.
- The authoritative host-oak spreadsheet lives on Google Drive (see `DATA/ACTIVE.VERSION.OF.EXCEL.ON.GOGGLE.DRIVE.txt`); the local copy is a snapshot.

### `galls_2026/`
Updated Fagaceae phylogenetics combining HybSeq and resequencing data (Gardner/Zhou datasets) with the RADseq *Quercus* phylogeny from Althaus et al. (2026) welded in. This is the version used for published gall wasp analyses with Graham Stone's research group.

- **Trees:** `fagaceae_graft_noconf_apr30_prune.tre` — Fagaceae backbone with broad sampling across *Quercus*, *Lithocarpus*, *Castanopsis*, *Castanea*, *Fagus*, and *Nothofagus*.
- **Metadata:** `fagaceae_gardner_zhou_info_2026may04.csv` (HybSeq + Zhou specimens) and `Quercus_Hipp-et-al_metadata_2026-05-05.xlsx` (RADseq *Quercus* specimens).
- **Host-oak data:** `Cynipini_host_oaks_2026-05-06.xlsx` — updated host-oak spreadsheet, maintained in-repo (unlike the 2022 version).
- **Name reconciliation:** `names_to_check.csv` maps taxon names between previous and new trees (renames, spelling fixes, removals).

### `spectra_2026/`
Species-level *Quercus* phylogeny whose tips match the species in a leaf spectral dataset (fresh and dry leaf spectra; species list from Jeannine Cavender-Bares), for comparative analyses of spectral traits. See [`spectra_2026/README.md`](spectra_2026/README.md) for full details.

- **Input tree:** a dated, single-tip-per-species *Quercus* tree (RAxML topology, BEAST2 time calibration), nearly identical to Althaus et al. (2026) with a few added taxa.
- **Pipeline:** `01_readRename.R` relabels tips to spectral-dataset names using the crosswalk in `tipsToAdd_2026-10-30.xlsx`; `02_graft.R` uses `simplePhylo()` to graft species listed in `weldingMatrix_2026-11-03.xlsx`, then prunes to the spectral species.
- **Output:** date-stamped (`YYYY-MM-DD`) trees and reports in `out/`. The final analysis tree is `out/03.relab_welded_pruned.2026-11-03.tre` (197 tips); species that could not be placed are listed in `out/missing.tips.2026-11-03.txt`.

## Running the analysis

There is no build system, test suite, or linter — each subproject is a script-driven R workflow; run its numbered scripts in order, starting with the lowest-numbered one (`00.makeTree.R` in the `galls_*` folders).

**galls_2022** (run from `galls_2022/WORKING/` or the repo root):
```r
source('galls_2022/SCRIPTS/00.makeTree.R')
```
The script auto-detects and sets the working directory.

**galls_2026** (must be run from the repo root):
```r
source('galls_2026/SCRIPTS/00.makeTree.R')
```
The script enforces that the working directory ends with `fagaceae-phylo` and errors out otherwise. `galls_2026/OUT/` must already exist — it is not created automatically.

**spectra_2026** (run from the repo root, scripts in numbered order):
```r
source('spectra_2026/scripts/01_readRename.R')
source('spectra_2026/scripts/02_graft.R')
```
`02_graft.R` expects exactly one `01.relabelled.*.tre` file in `spectra_2026/out/`; move or delete older ones before re-running on a later date. `spectra_2026/out/` must already exist.

## Dependencies

- [`ape`](https://cran.r-project.org/package=ape) — phylogenetic tree I/O and manipulation
- [`phytools`](https://cran.r-project.org/package=phytools) — extended phylogenetic tools
- [`magrittr`](https://cran.r-project.org/package=magrittr) — pipe operators
- [`openxlsx`](https://cran.r-project.org/package=openxlsx) — reading Excel spreadsheets
- `simplePhylo()` — sourced at runtime from [andrew-hipp/morton](https://github.com/andrew-hipp/morton); not an installed package (requires an internet connection)
- R ≥ 4.1 for `spectra_2026/` (its scripts use the native pipe `|>`)

## Directory convention

The `galls_*` subprojects follow the same layout:

```
DATA/      input data (trees, spreadsheets, metadata)
SCRIPTS/   R analysis scripts; entry point is 00.makeTree.R
OUT/       timestamped outputs (YYMMDD_HhMM): .tre, .pdf, missing-tips .csv
```

`galls_2022/` additionally has a `WORKING/` directory containing the R workspace and a Jupyter notebook demonstrating an example run.

`spectra_2026/` uses lowercase `data/`, `scripts/`, and `out/`, with numbered scripts (`01_…`, `02_…`) run in sequence instead of a single `00.makeTree.R`, and `YYYY-MM-DD` date stamps on outputs. Superseded inputs are kept in `data/ARCHIVE/`.

## Citations

The RADseq *Quercus* phylogeny used in `galls_2026/`, and the basis of the input tree for `spectra_2026/`, was first published in:

> Althaus KN, Hahn M, Alvarez-Clare S, Cavender-Bares J, Coombes AJ, González-Elizondo MS, González-Rodríguez A, Manos PS, Rodríguez-Correa H, Valencia-Ávalos S, et al. 2026. Timing and origins of Mexican and Central American oak diversity. *Proceedings of the National Academy of Sciences of the United States of America* 123: e2537040123.

## License

See [LICENSE](LICENSE).

## Authorship

This README file was written by Claude Code (claude.ai/code) interactively with Andrew Hipp, 2026-05-12; AH update 2026-08-07; Claude Code updated it 2026-11-03 to add `spectra_2026/`.
