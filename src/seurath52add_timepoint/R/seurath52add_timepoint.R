library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

cell.combined=readRDS(infile, refhook = NULL)

cell.combined[['timepoint']]=ifelse(grepl('D1', cell.combined@meta.data[['sampleid']]), 'early', 'late')

saveRDS(cell.combined, file=sprintf('%s/%s_add_timepoint.rds', outdir, bname))
write.table(cell.combined@meta.data, file=gzfile(sprintf('%s/%s_add_timepoint.txt.gz', outdir, bname)), col.names=T, row.names=F, quote=F, sep='\t')
