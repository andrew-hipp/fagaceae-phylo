# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

R-based phylogenetic analysis project for constructing working phylogenies of Fagaceae (oaks, beeches, chestnuts). The repository contains independent subprojects organized by year:

- **`galls_2022/`** - Phylogenetic trees for cynipid gall wasp host-oak associations. Mature, with archived output runs.
- **`galls_2026/`** - Updated Fagaceae phylogenetics using HybSeq and resequencing data (Gardner/Zhou datasets) with RADseq Quercus phylogeny welded in (from Althaus et al. 2026). Work in progress.
- **`spectra_2026/`** - Species-level Quercus phylogeny relabelled, grafted, and pruned to match the species in a leaf spectral dataset (fresh/dry spectra). Has its own detailed `README.md`; final tree is `out/03.relab_welded_pruned.2026-11-03.tre` (197 tips).

## Running the Analysis

There is no build system, test suite, or linter. Each subproject has a script-based R workflow.

**galls_2022** — run from `galls_2022/WORKING/` or the repo root:
```r
source('galls_2022/SCRIPTS/00.makeTree.R')
```
The script auto-detects and sets the working directory to `galls_2022/WORKING/`.

**galls_2026** — must be run from the repo root (`fagaceae-phylo/`):
```r
source('galls_2026/SCRIPTS/00.makeTree.R')
```
The script checks that the working directory ends with `fagaceae-phylo` and stops with an error otherwise. Note: `galls_2026/OUT/` must exist before running — R will not create it automatically.

**spectra_2026** — run from the repo root (paths are relative to it), scripts in numbered order:
```r
source('spectra_2026/scripts/01_readRename.R')
source('spectra_2026/scripts/02_graft.R')
```
Each script reads its own inputs, so they need not share a session. `02_graft.R` stops unless exactly one `01.relabelled.*.tre` exists in `spectra_2026/out/` — move/delete older ones before re-running on a later date. `out/` must already exist.

All three subprojects source `simplePhylo()` at runtime from the external [andrew-hipp/morton](https://github.com/andrew-hipp/morton) GitHub repo via URL.

## R Dependencies

- `ape` - phylogenetic tree manipulation (read/write Newick, tree operations)
- `phytools` - extended phylogenetic tools
- `magrittr` - pipe operators
- `openxlsx` - reading Excel spreadsheets
- `simplePhylo()` - sourced from GitHub at runtime (not an installed package)
- R ≥ 4.1 for `spectra_2026/` (native pipe `|>`)

## Architecture

### Subproject Structure

The two `galls_*` subprojects follow the same directory convention:
- `DATA/` - Input data (phylogenetic trees, spreadsheets, metadata)
- `SCRIPTS/` - R analysis scripts (entry point: `00.makeTree.R`)
- `OUT/` - Timestamped outputs (`YYMMDD_HhMM`): `.tre` (Newick), `.pdf` (visualization), `.csv` (unplaced taxa)

`galls_2022/` also has a `WORKING/` directory for the R workspace and a Jupyter notebook with an example run.

`spectra_2026/` differs: lowercase `data/`, `scripts/`, `out/`; numbered scripts (`01_readRename.R`, `02_graft.R`) instead of `00.makeTree.R`; outputs date-stamped `YYYY-MM-DD` (re-running the same day overwrites); superseded inputs in `data/ARCHIVE/`.

### Data Pipeline (galls_2022, operational)

1. **Input**: Reference tree (`DATA/supertimetree.hyboakconstrained.climateTips.tre`) + host-oak spreadsheet (`DATA/Global Cynipini host oak list 20220520.xlsx`)
2. **Processing**: `simplePhylo()` attaches taxa from the spreadsheet onto the reference tree using `trName`, `position`, and `tip` columns
3. **Output**: Timestamped `.tre`, `.pdf`, and missing-taxa `.csv` in `OUT/`

galls_2022 note: The authoritative host-oak spreadsheet for galls_2022 subfolder is on Google Drive (see `DATA/ACTIVE.VERSION.OF.EXCEL.ON.GOGGLE.DRIVE.txt`); the local `.xlsx` is a snapshot.
galls_2026 note: active spreadsheet for taxon additions is in the repository

### Data Files (galls_2026, in development)

- `fagaceae_graft_noconf_apr30_prune.tre` - New Fagaceae phylogeny (Newick) with bootstrap values and broad sampling across Quercus, Lithocarpus, Castanopsis, Castanea, Fagus, and Nothofagus
- `fagaceae_gardner_zhou_info_2026may04.csv` - Sample metadata (122+ specimens) from HybSeq and Zhou resequencing datasets, with herbarium/locality/coordinate data
- `Quercus_Hipp-et-al_metadata_2026-05-05.xlsx` - Quercus specimen metadata from RADseq tree (published initially in Althaus KN, Hahn M, Alvarez-Clare S, Cavender-Bares J, Coombes AJ, González-Elizondo MS, González-Rodríguez A, Manos PS, Rodríguez-Correa H, Valencia-Ávalos- S, et al. 2026. Timing and origins of Mexican and Central American oak diversity. Proceedings of the National Academy of Sciences of the United States of America 123: e2537040123.)
- `Cynipini_host_oaks_2026-05-06.xlsx` - Updated host-oak spreadsheet for cynipid gall wasps (2026 version, maintained in-repo)
- `names_to_check.csv` - Taxon name mapping between previous and new trees (renames, spelling corrections, removals)

### Data Pipeline (spectra_2026, operational)

1. **Input**: dated single-tip-per-species Quercus tree (NEXUS, `data/20261007_OakSingleTip..._resampled_50000_annotated_fulllabels.tre`; pipe-delimited tip labels, only the first field — species — is kept) + spectral species list (`data/Species.names_fresh_dry.xlsx`, sheet `combined`, column `sciname_simple`)
2. **Relabel** (`01_readRename.R`): renames tips using the crosswalk `data/tipsToAdd_2026-10-30.xlsx`, sheet `SpectralPhyloName-Matchup` (`originalName` → `spectralPhyloName`); writes `out/troubledTips.<date>.csv` and `out/01.relabelled.<date>.tre`
3. **Graft & prune** (`02_graft.R`): `simplePhylo()` attaches non-`EXCLUDE` rows of `data/weldingMatrix_2026-11-03.xlsx`, then ladderizes and prunes to spectral species; writes `out/02.relab_welded.<date>.tre`, `out/03.relab_welded_pruned.<date>.tre` (final), and `out/missing.tips.<date>.txt`
4. Spreadsheet paths are hard-coded; when a spreadsheet is updated, save it with a new date in the filename and update the script. `data/weldingMatrix_PREVIEW_*.csv` is a GitHub-viewable copy only — the `.xlsx` is authoritative.
