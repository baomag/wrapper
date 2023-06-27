library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# input: normalized data 
# parameter: nfeatures, resolution, algorithm
# output: unlabeled UMAP, RDS

abca4=readRDS(infile, refhook = NULL)

# Identify highly variable features
abca4=FindVariableFeatures(abca4, selection.method = "vst", nfeatures = nfeatures)
top10=head(VariableFeatures(abca4), 10)
# top10

# Visualize top 10 variable features
# plot1=VariableFeaturePlot(abca4)
# plot1
# plot2=LabelPoints(plot = plot1, points = top10, repel = TRUE)
# Top 10 variable features with labels
# plot2
# ggsave(plot2, filename =sprintf('%s/%s_top10_features.pdf', outdir, bname), height = height, width = width)

# Scaling data
all.genes <- rownames(abca4)
abca4 <- ScaleData(abca4, features = all.genes)

# PCA
abca4 <- RunPCA(abca4, npcs = npcs, features = VariableFeatures(object = abca4))

# Clustering
abca4 <- FindNeighbors(abca4, dims = 1:30)
abca4 <- FindClusters(abca4, resolution = resolution, algorithm = algorithm)
# head(Idents(abca4), 10)

# UMAP
abca4 <- RunUMAP(abca4, dims = 1:30)
p = DimPlot(abca4, reduction = "umap", label=T)		
ggsave(p, filename = sprintf('%s/%s_UMAP.png', outdir, bname), height=height, width=width)

# finding clusters
saveRDS(abca4, file=sprintf('%s/%s_clustering.rds', outdir, bname))
