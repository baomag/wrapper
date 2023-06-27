# vim: set noexpandtab tabstop=2:

library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# Read data
abca4.data <- Read10X_h5(infile)
abca4 <- CreateSeuratObject(counts = abca4.data, project = "abca4", min.cells = 3, min.features = 200)

# QC Metrics
abca4[["percent.mt"]] <- PercentageFeatureSet(abca4, pattern = "^MT-")

# Find subset
abca4 <- subset(abca4, subset = nFeature_RNA > nfeaturelower & percent.mt < mito)
p <- VlnPlot(abca4, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3, pt.size=0)
ggsave(p, file=sprintf('%s/%s_violin_af_subset.pdf', outdir, bname), height=height, width=width)

saveRDS(abca4, file=sprintf('%s/%s_clean.rds', outdir, bname))
