library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)
library(SeuratDisk)

# input: infile 
# output: vlnplot.pdf

abca4 <- readRDS(infile)

DefaultAssay(abca4) <- "RNA"

#abca4_subset = subset(abca4, subset=(abca4@meta.data$celltype %in% subtype))
if(subtype_column!='') {
	abca4_subset=subset(abca4, cells=colnames(abca4)[abca4@meta.data[, subtype_column] %in% subtype])
}

p <- VlnPlot(abca4_subset, features = features, pt.size=0) + theme(axis.text.x = element_blank())
ggsave(p, filename = sprintf('%s/%s_vln.png', outdir, bname) , height=height, width=width)
