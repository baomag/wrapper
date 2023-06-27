library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# Input: infile (merged seurat object), DEGs (text file containing name of DEGs to be plotted), groupby (groupby treatment or sampleid or timepoint)
# Output: heatmap

abca4 = readRDS(infile)

# read in the DEGs to be plotted from a table and convert it into a list of strings
degs = read.table(degs, header=F)
features = degs$V1

# scale the data first
abca4 <- ScaleData(abca4, features = rownames(abca4))

# randomly sample 100 cells from the dataset
sample_col = sample(colnames(abca4@assays$RNA@counts), 100)

# subset the cells sampled
samples = subset(abca4, cells=colnames(abca4)[colnames(abca4@assays$RNA@counts) %in% sample_col])

# plot heatmap and store it
p = DoHeatmap(samples, features = features, group.by = group)
ggsave(p, filename = sprintf('%s/%s_heatmap.png', outdir, bname))

