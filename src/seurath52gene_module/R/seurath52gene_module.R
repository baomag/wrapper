library(dplyr)
library(Seurat)
library(ggplot2)
library(RColorBrewer)

# Input: annoated, integrated, clustered data
# Output: feature plot with gene module score colored
# Parameters: features (a list of gene names)

# Read in Seurat object and list of features to plot
x = readRDS(infile)
#features = read.table(features, header = FALSE, sep='\t')
features = read.csv(features, header = FALSE)
features = as.character(features[[1]])
features = list(features)
print(features)
print(str(features))

# Data prepossessing (not necessary if already clustered)
#all.genes <- rownames(x)
#x <- ScaleData(x, features = all.genes)
#x <- RunPCA(x, verbose = FALSE, features = all.genes)
#x <- RunUMAP(x, dims = 1:30)

# Change default assay to RNA
DefaultAssay(x) = "RNA"

# Calculate gene module score
x = AddModuleScore(x, features = features, name = "cell_cycle")

# Plot gene scores
p = FeaturePlot(x, features = "cell_cycle1", label = TRUE, repel = TRUE) +
	scale_colour_gradientn(colours = rev(brewer.pal(n = 11, name = "RdBu")))

# Save plot
ggsave(p, filename = sprintf('%s/%s_gene_score_feature.png', outdir, bname) , height=height, width=width)

# Save object
saveRDS(x, file = sprintf('%s/%s_gene_score_added.rds', outdir, bname))
