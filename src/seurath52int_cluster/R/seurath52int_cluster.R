library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# input: infile
# output: labeled UMAP, RDS

cell.combined=readRDS(infile, refhook = NULL)
str(cell.combined)

# Visualize top 10 variable features
# plot1=VariableFeaturePlot(abca4)
# plot1
# plot2=LabelPoints(plot = plot1, points = top10, repel = TRUE)
# Top 10 variable features with labels
# plot2
# ggsave(plot2, filename =sprintf('%s/%s_top10_features.pdf', outdir, bname), height = height, width = width)

# clustering
cell.combined <- ScaleData(cell.combined, verbose = FALSE)
cell.combined <- RunPCA(cell.combined, npcs = 30, verbose = FALSE)
cell.combined <- RunUMAP(cell.combined, reduction = "pca", dims = 1:30)
cell.combined <- FindNeighbors(cell.combined, reduction = "pca", dims = 1:30)
cell.combined <- FindClusters(cell.combined, resolution = 0.5)

# finding clusters
saveRDS(cell.combined, file=sprintf('%s/%s_int_cluster.rds', outdir, bname))
