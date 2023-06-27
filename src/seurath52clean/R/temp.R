library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# Read data
abca4.data <- Read10X_h5(infile)
abca4 <- CreateSeuratObject(counts = abca4.data, project = "abca4", min.cells = 3, min.features = 200)

# QC Metrics
abca4[["percent.mt"]] <- PercentageFeatureSet(abca4, pattern = "^MT-")
# Violin plot for QC Metrics
p1 <- VlnPlot(abca4, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3, pt.size=0)
ggsave(p1, file=sprintf('%s/%s_violin.pdf', outdir, bname), height=height, width=width)

# Feature plot for nCount VS percent.mt
plot1 <- FeatureScatter(abca4, feature1 = "nCount_RNA", feature2 = "percent.mt")
plot2 <- FeatureScatter(abca4, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
ggsave(plot1 + plot2, file=sprintf('%s/%s_feature.pdf', outdir, bname), height=height, width = width)

# Find subset (need here?)
abca4 <- subset(abca4, subset = nFeature_RNA > nfeaturelower & percent.mt < mito)
p1 <- VlnPlot(abca4, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3, pt.size=0)
ggsave(p1, file=sprintf('%s/%s_violin_xxx.pdf', outdir, bname), height=height, width=width)

# clean cells
saveRDS()

x=readRDS('xx/xxx.rds')

# Normalize data
abca4 <- NormalizeData(abca4, normalization.method = "LogNormalize", scale.factor = 10000)

# Identify highly variable features
abca4 <- FindVariableFeatures(abca4, selection.method = "vst", nfeatures = 12000)
top10 <- head(VariableFeatures(abca4), 10)
# top10

# Visualize top 10 variable features
plot1 <- VariableFeaturePlot(abca4)
# plot1
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
# Top 10 variable features with labels
# plot2
# ggsave(plot1 + plot2, filename = outfile, height = height, width = width)

# Scaling data
all.genes <- rownames(abca4)
abca4 <- ScaleData(abca4, features = all.genes)

# PCA
abca4 <- RunPCA(abca4, features = VariableFeatures(object = abca4))

# Clustering
abca4 <- FindNeighbors(abca4, dims = 1:10)
abca4 <- FindClusters(abca4, resolution = 0.5)
# head(Idents(abca4), 10)

# UMAP
abca4 <- RunUMAP(abca4, dims = 1:10)
# p = DimPlot(abca4, reduction = "umap", label=T)
# ggsave(p, file=outfile, height=height, width=width)

# Find Cluster Biomarkers
abca4.markers <- FindAllMarkers(abca4, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.5)
abca4.markers %>%
  group_by(cluster) %>%
  slice_max(n = 2, order_by = avg_log2FC)
abca4.markers %>%
  group_by(cluster) %>%
  top_n(n = 10, wt = avg_log2FC) -> top10
print("show result: top 10")
# saveRDS(top10, file = outfile, ascii = FALSE, version = NULL, compress = TRUE, refhook = NULL)
write.table(top10, file=outfile, quote=T, sep='\t', row.names=F, col.names=T)
p2 <- DoHeatmap(abca4, features = top10$gene) + NoLegend()
# ggsave(p2, filename = outfile, height = height, width = width)
