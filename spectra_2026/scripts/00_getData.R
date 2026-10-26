library(ape)
library(openxlsx)

tr <- read.nexus('spectra_2026/data/20261007_OakSingleTip20260921_fixedtree_standard_p04_beastfile_resampled_50000_annotated_fulllabels.tre')
tr$tip.label <- strsplit(tr$tip.label, '|', fixed = T) |> 
    sapply(FUN = '[', 1)
dat <- read.xlsx('spectra_2026/data/Species.names_fresh_dry.xlsx', sheet = 'combined')

missing <- setdiff(dat$sciname_simple, tr$tip.label)
writeLines(missing, 'spectra_2026/out/missing.tips.txt')

tr.pruned <- keep.tip(tr, intersect(tr$tip.label, dat$sciname_simple))

write.tree(
    tr.pruned,
    'spectra_2026/out/prunedTree.tre')