library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)
library(pheatmap)
library(RColorBrewer)

# Input: infile (merged seurat object), DEGs (text file containing name of DEGs to be plotted), groupby (groupby treatment or sampleid or timepoint)
# Output: pheatmap

samples = readRDS(infile)

# normalize the data
samples <- NormalizeData(samples)

# scale the data
samples <- ScaleData(samples, features = rownames(samples))

# aggregate count matrix columns by sampleid and return seuret object
samples_sum = AggregateExpression(samples, group.by = "sampleid", return.seurat = TRUE)

# get count matrix of subsetted data
counts = samples_sum@assays$RNA@counts

# read in the DEGs to be plotted from a table and convert it into a list of strings
degs = read.table(degs, header=F)
features = degs$V1

# subset the count by the DEGs
counts = counts[rownames(counts) %in% features,]

# create a separate metadata containing sampleid and treatment info
mm = unique(samples@meta.data[, c('sampleid', 'timepoint', 'treatment')])
rownames(mm)=mm$sampleid

# reorder the rows of the metadata based on the order to the count matrix 
mm=mm[colnames(counts), ]

# define color schemes for the heatmap
heat_colors <- rev(brewer.pal(11, "PuOr"))

# plot heatmap and store it
p = pheatmap(counts, color = heat_colors, cluster_rows = TRUE, cluster_cols = TRUE, show_rownames = FALSE, annotation = mm, 
	show_colnames = FALSE, border_color = NA, fontsize = 10, scale = "row", fontsize_row = 10, height = 20)
ggsave(p, filename = sprintf('%s/%s_pheatmap.png', outdir, bname))

