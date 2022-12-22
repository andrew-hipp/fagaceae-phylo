library(ape)
library(phytools)
library(magrittr)
library(openxlsx)
source('https://raw.githubusercontent.com/andrew-hipp/morton/master/R/simplePhylo.R')

# set working directory
setwd('galls_2022/WORKING/')

# set variables:
now <- format(Sys.time(), "%y%m%d_%Hh%M")
# data to export from dat
datCols <- c('Species','trName', 'position', 'justification', 'reference', 'notes')

# get data
tr.gardner <- read.tree('../DATA/supertimetree.hyboakconstrained.climateTips.tre')
dat <- read.xlsx('../DATA/Global Cynipini host oak list 20220520.xlsx',1)
dat.nodes <- dat[which(!is.na(dat$tip)), ]

# make tree
tr.graham <- simplePhylo(
  tips = dat$trName,
  tr = tr.gardner,
  nodes = dat.nodes
)

# write results
write.tree(tr.graham, paste('../OUT/tr.graham_', now, '.tre', sep = ''))

pdf(paste('../OUT/tr.graham_', now, '.pdf', sep = ''), 8.5, 11)
plot(tr.graham, cex = 0.4)
dev.off()

dat.out <- dat[which(!dat$trName %in% tr.graham$tip.label), datCols]
write.csv(dat.out,
          paste('../OUT/tr.graham.missingTips_', now, '.csv', sep = ''))
