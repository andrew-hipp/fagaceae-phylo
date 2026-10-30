library(ape)
library(openxlsx)

tr <- read.nexus('spectra_2026/data/20261007_OakSingleTip20260921_fixedtree_standard_p04_beastfile_resampled_50000_annotated_fulllabels.tre')
tr$tip.label <- strsplit(tr$tip.label, '|', fixed = T) |> 
    sapply(FUN = '[', 1)

dat <- read.xlsx('spectra_2026/data/Species.names_fresh_dry.xlsx', sheet = 'combined')
dat_tips <- read.xlsx('spectra_2026/data/tipsToAdd_2026-10-30.xlsx', sheet = 'SpectralPhyloName-Matchup')
dat_tips$trouble <- 
    apply(dat_tips[c("spectralPhyloName", "MissingTip", "Notes")], 1, is.na) |>
    t() |>
    apply(MARGIN = 1, FUN = all) |> 
    xor(y = TRUE) 

write.csv(dat_tips[which(dat_tips$trouble), ], 'spectra_2026/out/troubledTips.csv')
## NOW NEED TO UPDATE THE SYNONYMS
### THEN SPLICE IN THE OTHERS

missing <- setdiff(dat$sciname_simple, tr$tip.label)


writeLines(missing, 'spectra_2026/out/missing.tips.txt')

tr.pruned <- keep.tip(tr, intersect(tr$tip.label, dat$sciname_simple))

write.tree(
    tr.pruned,
    'spectra_2026/out/prunedTree.tre')