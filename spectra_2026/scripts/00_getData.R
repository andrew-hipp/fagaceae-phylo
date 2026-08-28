library(ape)
library(openxlsx)

tr <- read.nexus('data/20231119_mcc_meanheight_p04.trees')
tr$tip.label <- strsplit(tr$tip.label, '|', fixed = T) |> 
    sapply(FUN = '[', 1)
dat <- read.xlsx('data/Species.names_fresh_dry.xlsx', sheet = 'combined')

missing <- setdiff(dat$sciname_simple, tr$tip.label)
writeLines(missing, 'out/missing.tips.txt')

tr.pruned <- keep.tip(tr, intersect(tr$tip.label, dat$sciname_simple))

write.tree(
    tr.pruned,
    'out/prunedTree.tre')