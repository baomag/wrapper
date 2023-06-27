library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)
library(SeuratDisk)

# input: infile
# output: normalized rds

abca4 <- LoadH5Seurat(infile)

# Normalize data
abca4=NormalizeData(abca4, normalization.method = "LogNormalize", scale.factor = 10000)

saveRDS(abca4, file=sprintf('%s/%s_normalized.rds', outdir, bname))

