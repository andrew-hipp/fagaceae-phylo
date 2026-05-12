# fagaceae-phylo

Spliced phylogenies of Fagaceae (oaks, beeches, chestnuts), built in R for downstream use in host-association and comparative studies. The repository contains independent subprojects organized by year; each is self-contained under its own directory.

Scripts by Andrew Hipp (ahipp@mortonarb.org). Phylogenies by Althaus / Hipp et al. (2026) (_Quercus_), and Elliot Gardner (exg258@case.edu) and Kasey Pham (kxp574@case.edu) (Fagaceae).

## Subprojects

### `galls_2022/`
Phylogenies for cynipid gall-wasp host-oak associations. Mature and operational, with archived output runs.

- **Input:** reference tree (`DATA/supertimetree.hyboakconstrained.climateTips.tre`) plus the host-oak spreadsheet (`DATA/Global Cynipini host oak list 20220520.xlsx`).
- **Pipeline:** `simplePhylo()` splices taxa onto the reference tree using `trName`, `position`, and `tip` columns from the spreadsheet.
- **Output:** timestamped `.tre`, `.pdf`, and missing-taxa `.csv` files in `OUT/`.
- The authoritative host-oak spreadsheet lives on Google Drive (see `DATA/ACTIVE.VERSION.OF.EXCEL.ON.GOGGLE.DRIVE.txt`); the local copy is a snapshot.

### `galls_2026/`
Updated Fagaceae phylogenetics combining HybSeq and resequencing data (Gardner/Zhou datasets) with the RADseq *Quercus* phylogeny from Althaus et al. (2026) welded in. Work in progress.

- **Trees:** `fagaceae_graft_noconf_apr30_prune.tre` — Fagaceae backbone with broad sampling across *Quercus*, *Lithocarpus*, *Castanopsis*, *Castanea*, *Fagus*, and *Nothofagus*.
- **Metadata:** `fagaceae_gardner_zhou_info_2026may04.csv` (HybSeq + Zhou specimens) and `Quercus_Hipp-et-al_metadata_2026-05-05.xlsx` (RADseq *Quercus* specimens).
- **Host-oak data:** `Cynipini_host_oaks_2026-05-06.xlsx` — updated host-oak spreadsheet, maintained in-repo (unlike the 2022 version).
- **Name reconciliation:** `names_to_check.csv` maps taxon names between previous and new trees (renames, spelling fixes, removals).

## Running the analysis

There is no build system, test suite, or linter — each subproject is a script-driven R workflow with `00.makeTree.R` as the entry point.

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

## Dependencies

- [`ape`](https://cran.r-project.org/package=ape) — phylogenetic tree I/O and manipulation
- [`phytools`](https://cran.r-project.org/package=phytools) — extended phylogenetic tools
- [`magrittr`](https://cran.r-project.org/package=magrittr) — pipe operators
- [`openxlsx`](https://cran.r-project.org/package=openxlsx) — reading Excel spreadsheets
- `simplePhylo()` — sourced at runtime from [andrew-hipp/morton](https://github.com/andrew-hipp/morton); not an installed package

## Directory convention

Each subproject follows the same layout:

```
DATA/      input data (trees, spreadsheets, metadata)
SCRIPTS/   R analysis scripts; entry point is 00.makeTree.R
OUT/       timestamped outputs (YYMMDD_HhMM): .tre, .pdf, missing-tips .csv
```

`galls_2022/` additionally has a `WORKING/` directory containing the R workspace and a Jupyter notebook demonstrating an example run.

## Citations

The RADseq *Quercus* phylogeny used in `galls_2026/` was first published in:

> Althaus KN, Hahn M, Alvarez-Clare S, Cavender-Bares J, Coombes AJ, González-Elizondo MS, González-Rodríguez A, Manos PS, Rodríguez-Correa H, Valencia-Ávalos S, et al. 2026. Timing and origins of Mexican and Central American oak diversity. *Proceedings of the National Academy of Sciences of the United States of America* 123: e2537040123.

## License

See [LICENSE](LICENSE).

## Authorship

This README file was written by Claude Code (claude.ai/code) interactively with Andrew Hipp, 2026-05-12.