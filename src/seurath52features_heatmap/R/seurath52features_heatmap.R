library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# Input: infile (merged seurat object), genes_to_plot (text file containing name of cell markers to be plotted), groupby (groupby treatment or sampleid or timepoint)
# Output: heatmap

x = readRDS(infile)

# read in the features to be plotted from a table and convert it into a list of strings
gene_list <- read.table(genes_to_plot, header = T)$symbol
features <- as.character(gene_list)

# scale the data first
x <- ScaleData(x, features = features)

# randomly sample 100 cells from the dataset
sample_col = sample(colnames(x@assays$RNA@counts), 100)

# subset the cells sampled
samples = subset(x, cells=colnames(x)[colnames(x@assays$RNA@counts) %in% sample_col])

# plot heatmap and store it
p = DoHeatmap(samples, features = features, group.by = group)
ggsave(p, filename = sprintf('%s/%s_heatmap.png', outdir, bname), height=height, width=width)

