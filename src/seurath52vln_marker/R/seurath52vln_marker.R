library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# input: infile (/storage/chen/home/u244209/ABCA4/wrapper/seurath52marker/main/raw_feature_bc_matrix_biomarker.rds)
# parameter: cell, marker (/storage/chen/home/u244209/ABCA4/hs_marker.txt)
# output: vlnplot.pdf

abca4 <- readRDS(infile)

marker <- read.table(marker, header = TRUE, sep='\t')

features = subset(marker, celltype==cell)$symbol

# check clusters for certain cell type gene markers
p <- VlnPlot(abca4, features = features, pt.size=0)

ggsave(p, filename = sprintf('%s/%s_geneVln.png', outdir, bname) , height=height, width=width)
print(sprintf('%s/%s_geneVln.png', outdir, bname))
