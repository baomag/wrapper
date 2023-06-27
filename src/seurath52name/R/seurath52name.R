library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# input: infile 
# parameter: ids
# output: UMAP.pdf

abca4 <- readRDS(infile)

new.cluster.ids=read.table(ids, header=T)
new.cluster.ids=new.cluster.ids[, 2]

names(new.cluster.ids) <- levels(abca4)
abca4 <- RenameIdents(abca4, new.cluster.ids)

#p = DimPlot(abca4, reduction = "umap", label=T)
#ggsave(p, filename = sprintf('%s/%s_labeled_UMAP.pdf', outdir, bname) , height=5, width=6, useDingbats=F)
#ggsave(p, filename = sprintf('%s/%s_labeled_UMAP.png', outdir, bname) , height=5, width=6)
saveRDS(abca4, file=sprintf('%s/%s.rds', outdir, bname))

