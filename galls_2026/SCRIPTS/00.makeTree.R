library(ape)
library(phytools)
library(magrittr)
# library(openxlsx)
source('https://raw.githubusercontent.com/andrew-hipp/morton/master/R/simplePhylo.R')

# # set working directory
# if(!endsWith(tolower(getwd()), 'fagaceae-phylo')) stop('launch this within fagaceae-phylo root directory')

# set variables:
now <- format(Sys.time(), "%y%m%d_%Hh%M")
# data to export from dat
datCols <- c('Species','trName', 'position', 'justification', 'reference', 'notes')

# get data
tr.gardner <- read.tree('galls_2026/DATA/fagaceae_graft_noconf_apr30_prune.tre')
tr.gardner <- drop.tip(tr.gardner, c(
  'Quercus_salicifolia|QUE002791', 
  'Quercus_pringlei|QUE004078',
  'Quercus_rehderiana|QUE001495',
  'Quercus_mongolica_var._grosseserrata|QUE002913'
  ))

tr.gardner$tip.label <- strsplit(tr.gardner$tip.label, '|', fixed = T) |> sapply(FUN = '[', 1)

dat <- read.csv('galls_2026/DATA/Cynipini_host_oaks_2026-05-06_AR.csv')
dat$tip[dat$tip == ''] <- NA
dat.nodes <- dat[which(!is.na(dat$tip) & dat$comments_ar == 'retain'), ]

# make tree
tr.graham <- simplePhylo(
  tips = dat$trName[dat$comments_ar == 'retain'],
  tr = tr.gardner,
  nodes = dat.nodes, 
  prune = T
) |> ladderize()

# write results
write.tree(tr.graham, paste('galls_2026/OUT/tr.graham_', now, '.tre', sep = ''))

pdf(paste('galls_2026/OUT/tr.graham_', now, '.pdf', sep = ''), 8.5, 11)
plot(tr.graham, cex = 0.4)
dev.off()

dat.out <- dat[which(!dat$trName %in% tr.graham$tip.label), datCols]
write.csv(dat.out,
          paste('galls_2026/OUT/tr.graham.missingTips_', now, '.csv', sep = ''))
