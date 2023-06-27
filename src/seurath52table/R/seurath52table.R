library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# input: infile 
# output: cell proportion table, RDS

x <- readRDS(infile)
#x <- LoadH5Seurat(infile)

# Create table of cell type proportions
xx=table(x$celltype)
#xx=table(x$scpred_prediction)
#xx=table(x$majorclass)
#xx=xx/sum(xx)

# save table
#write.table(xx, file=sprintf('%s/%s_cell_prop.txt', outdir, bname), quote=F, sep='\t', row.names=F, col.names=T)
write.table(xx, file=sprintf('%s/%s_cell_count.txt', outdir, bname), quote=F, sep='\t', row.names=F, col.names=T)

# save RDS
# saveRDS(abca4, file=sprintf('%s/%s_table.rds', outdir, bname))
