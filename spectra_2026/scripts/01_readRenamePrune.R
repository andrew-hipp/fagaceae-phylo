library(ape)
library(openxlsx)

now <- format(Sys.time(), "%Y-%m-%d")

tr <- read.nexus('spectra_2026/data/20261007_OakSingleTip20260921_fixedtree_standard_p04_beastfile_resampled_50000_annotated_fulllabels.tre')
tr$tip.label <- strsplit(tr$tip.label, '|', fixed = T) |> 
    sapply(FUN = '[', 1)

dat_spectra <- read.xlsx('spectra_2026/data/Species.names_fresh_dry.xlsx', sheet = 'combined')
dat_tips <- read.xlsx('spectra_2026/data/tipsToAdd_2026-10-30.xlsx', sheet = 'SpectralPhyloName-Matchup')
dat_tips$trouble <- 
    apply(dat_tips[c("spectralPhyloName", "MissingTip", "Notes")], 1, is.na) |>
    t() |>
    apply(MARGIN = 1, FUN = all) |> 
    xor(y = TRUE) 

write.csv(dat_tips[which(dat_tips$trouble), ], paste('spectra_2026/out/troubledTips', now, 'csv', sep = '.'))
tips.replaceEm <- dat_tips[which(!is.na(dat_tips$spectralPhyloName)), 2]
names(tips.replaceEm) <- dat_tips[which(!is.na(dat_tips$spectralPhyloName)), 1]

## NOW NEED TO UPDATE THE SYNONYMS
if(any(!names(tips.replaceEm) %in% tr$tip.label)) warning('** some replacement tips not in the tree **')
tr$tip.label[match(names(tips.replaceEm), tr$tip.label)] <-
    as.character(tips.replaceEm)

write.tree(
    tr,
    paste('spectra_2026/out/01.relabelled', now, 'tre', sep = '.')
)
