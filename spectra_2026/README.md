# spectra_2026

## Purpose

This folder builds a species-level oak (*Quercus*) phylogeny whose tips match the species in a leaf spectral dataset (fresh and dry leaf spectra), for use in comparative analyses of spectral traits. The workflow:

1. starts from a dated, single-tip-per-species *Quercus* tree,
2. relabels tips to the names used in the spectral dataset (synonyms, determinations, spelling),
3. grafts in a small number of spectral-data species that are not in the tree, and
4. prunes the tree to the species that have spectral data.

## Directory layout

```
spectra_2026/
├── data/       input trees and spreadsheets
│   └── ARCHIVE/  superseded trees and review spreadsheets
├── scripts/    R scripts, run in numbered order
└── out/        date-stamped outputs (YYYY-MM-DD)
```

## Running the analysis

Both scripts use paths relative to the **repository root** (`fagaceae-phylo/`). Run them in order:

```r
source('spectra_2026/scripts/01_readRename.R')
source('spectra_2026/scripts/02_graft.R')
```

Each script reads its own inputs, so they don't have to run in the same R session. `02_graft.R` finds the relabelled tree with `dir(..., patt = '01.relabelled')` and stops with an error if `out/` holds anything other than exactly one `01.relabelled.*.tre` file. Before re-running on a later date, move or delete the older one.

### Dependencies

- `ape`: tree I/O, `keep.tip`, `ladderize`
- `openxlsx`: reading the spreadsheets
- `simplePhylo()`: sourced at runtime from [andrew-hipp/morton](https://github.com/andrew-hipp/morton) (needs an internet connection)
- R ≥ 4.1 (the scripts use the native pipe `|>`)

## Scripts

### `01_readRename.R`: read and relabel

- Reads the input tree (NEXUS) `data/20261007_OakSingleTip20260921_fixedtree_standard_p04_beastfile_resampled_50000_annotated_fulllabels.tre` (329 tips). Tip labels are pipe-delimited (`species|country|state|source|section|clade|sample`), and only the first field (species name) is kept. 
- Reads the list of spectral-data species from `data/Species.names_fresh_dry.xlsx`, sheet `combined` (column `sciname_simple`). Source: Jeannine Cavender-Bares.
- Reads the name crosswalk from `data/tipsToAdd_2026-10-30.xlsx`, sheet `SpectralPhyloName-Matchup` (columns `originalName`, `spectralPhyloName`, `MissingTip`, `Notes`).
- Flags every crosswalk row with a value in `spectralPhyloName`, `MissingTip`, or `Notes` as "trouble" and writes those rows to `out/troubledTips.<date>.csv` for review.
- Renames tree tips from `originalName` to `spectralPhyloName` wherever a `spectralPhyloName` is given, and warns if any `originalName` is not in the tree.
- Writes `out/01.relabelled.<date>.tre`.

### `02_graft.R`: graft, prune, report

- Reads the relabelled tree, the spectral species list (`Species.names_fresh_dry.xlsx`, sheet `combined`), and the welding matrix `data/weldingMatrix_2026-11-03.xlsx` (columns `Species`, `tip`, `position`, `node`, `distUp`, `justification`, `reference`, `notes`).
- Skips rows with `tip == 'EXCLUDE'` and passes the rest to `simplePhylo()`, which attaches each species relative to the tip given in `node`. In the 2026-11-03 matrix, 19 species are excluded and 2 are grafted:
  - *Q. glauca*: sister to *Q. annulata* (source: unpublished whole-genome resequencing data, Lin Lin & Min Deng, pers. comm.)
  - *Q. wutaishanica*: sister to *Q. mongolica* (treated as a synonym)
- Ladderizes the welded tree, then prunes it to the species in `dat_spectra$sciname_simple`.
- Writes:
  - `out/02.relab_welded.<date>.tre`: full welded tree (331 tips)
  - `out/03.relab_welded_pruned.<date>.tre`: **final tree pruned to spectral species (197 tips)**. This is the tree to use for analysis
  - `out/missing.tips.<date>.txt`: spectral-data species that are not in the welded tree (20 on 2026-11-03)

## Data files

| File | Contents |
|---|---|
| `20261007_OakSingleTip20260921_fixedtree_standard_p04_beastfile_resampled_50000_annotated_fulllabels.tre` | Input dated tree (NEXUS), one tip per species, full sample labels. The file name indicates a BEAST analysis on a fixed topology, with the annotated summary tree from 50,000 resampled trees. This tree is almost identical to Althaus et al. 2026 (https://doi.org/10.1073/pnas.2537040123), with the addition of a few taxa that were not included in that study. The tree was (as in Althaus et al.) inferred using RAxML and time-calibrated using BEAST2. |
| `20261007_OakSingleTip20260921_fixedtree_standard_p04_beastfile_annotated.tre` | Companion annotated tree from the same analysis (not used by the scripts) |
| `Species.names_fresh_dry.xlsx` | Species in the spectral dataset; sheets `dry` (215), `fresh` (192), `combined` (217) |
| `tipsToAdd_2026-10-30.xlsx` | Name reconciliation between tree and spectral data. The scripts read only `SpectralPhyloName-Matchup`; the other sheets (`JCB-sp not found`, `Missing Tips v2`, `Species with RAD-SEQ data`) hold working notes and review |
| `weldingMatrix_2026-11-03.xlsx` | Placement or exclusion decision, with justification, for each spectral species missing from the tree |
| `weldingMatrix_PREVIEW_2026-11-03.csv` | CSV copy of the welding matrix, so it can be viewed without opening Excel (primarily, on GitHub). Not read by the scripts; the `.xlsx` is authoritative |
| `ARCHIVE/` | Earlier trees (`20231119_mcc_meanheight_p04.trees`, `GeoHiSSE_tree.tre`) and an earlier review spreadsheet (2026-09-01) |

## Current status (outputs dated 2026-11-03)

- The final tree is `out/03.relab_welded_pruned.2026-11-03.tre` (197 tips). This matches the "Finalized tree (v1)" commit. Re-running the revised scripts on 2026-11-03 produced output files identical to the ones in that commit.
- 20 of the 217 spectral species are not in the tree (`out/missing.tips.2026-11-03.txt`):
  - 19 are marked `EXCLUDE` in the welding matrix, for reasons such as no sample, a synonym of a species already in the tree, or uncertain identity.
  - `Fagus_grandifolia` is not in the welding matrix. It cannot be placed because the input tree contains only *Quercus*.
- The spectral species list contains both `Quercus_gambelii` and `Quercus_gambelli`, and both are excluded. The latter spelling is an orthographic variant retained for consistency with the trait dataset.
- `out/troubledTips.2026-11-03.csv` lists the 35 crosswalk rows with renames or notes, for review.

## Notes for re-running

- Outputs are date-stamped (`format(Sys.time(), "%Y-%m-%d")`), so re-running on the same day overwrites that day's files.
- `out/` must exist before running.
- When you update a spreadsheet, save it with a new date in the file name and update the hard-coded path in the script.

## Authorship
This README was drafted by Claude (Anthropic's Claude Opus 5.5, via Claude Code) in an interactive session with Andrew Hipp on 2026-11-03. Claude wrote it by reading the scripts, data files, and outputs in this folder. Andrew Hipp reviewed and edited it on 2026-11-03 at 14:17 CST, adding the data provenance and resolving the open TODOs; Claude then updated it to match the revised scripts. After Andrew Hipp fixed `02_graft.R` and re-ran both scripts, Claude checked this README against the scripts and the regenerated outputs on 2026-11-03 at 14:21 CST. All scripts are by Andrew (ahipp@mortonarb.org)