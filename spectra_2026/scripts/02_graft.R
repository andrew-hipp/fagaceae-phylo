library(openxlsx)
library(ape)
source('https://raw.githubusercontent.com/andrew-hipp/morton/master/R/simplePhylo.R')

tr.relabelled <- read.tree(
  dir('spectra_2026/out/', patt = '01.relabelled', full = T)
)
dat_weld <- read.xlsx('spectra_2026/data/weldingMatrix_2026-11-03.xlsx') 

now <- format(Sys.time(), "%Y-%m-%d")

## make tree
tr.welded <- simplePhylo(
  tips = dat_weld$Species[dat_weld$tip != 'EXCLUDE'],
  tr = tr.relabelled,
  nodes = dat_weld[dat_weld$tip != 'EXCLUDE', ], 
  prune = F
) |> ladderize()

## THEN PRUNE TO JUST WHAT'S THERE, REPORT AND WRITE
tr.pruned <- keep.tip(tr.welded, intersect(tr.welded$tip.label, dat_spectra$sciname_simple))

missing <- setdiff(dat_spectra$sciname_simple, tr.welded$tip.label)
writeLines(
  missing, 
  paste('spectra_2026/out/missing.tips', now, 'txt', sep = '.')
  )

write.tree(
  tr.welded,
  paste('spectra_2026/out/02.relab_welded', now, 'tre', sep = '.')
  )

write.tree(
    tr.pruned,
    paste('spectra_2026/out/03.relab_welded_pruned', now, 'tre', sep = '.')
    )
