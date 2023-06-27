library(dplyr)
library(Seurat)

# input: rds with object to be splitted
# parameter: splitby 
# output: rds with splitted object

x = readRDS(infile)

xx = SplitObject(x,split.by=splitby)

saveRDS(xx, file=sprintf('%s/%s_split.rds', outdir, bname))
