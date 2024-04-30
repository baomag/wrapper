library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# input: infile
# output: UMAP

x=readRDS(infile, refhook = NULL)

if (need_cluster == TRUE){

	# Identify highly variable features
	x=FindVariableFeatures(x, selection.method = "vst", nfeatures = nfeatures)
	top10=head(VariableFeatures(x), 10)

	# Scaling data
	all.genes <- rownames(x)
	x <- ScaleData(x, features = all.genes)

	# PCA
	x <- RunPCA(x, npcs = npcs, features = VariableFeatures(object = x))

	# Clustering
	x <- FindNeighbors(x, dims = 1:30)
	x <- FindClusters(x, resolution = resolution, algorithm = algorithm)
}

# Plot UMAP
x <- RunUMAP(x, dims = 1:30)

# p = DimPlot(pbmc, reduction = "umap")
# ggsave(p, filename = sprintf('%s/%s_UMAP.pdf', outdir, bname), height=height, width=width)

if (need_cluster == TRUE){
	saveRDS(x, file=sprintf('%s/%s_clustered.rds', outdir, bname))
}

lapply(
	c('celltype', 'sampleid', 'timepoint', 'seurat_clusters')
	, function (groupby) {
		p = DimPlot(x, reduction = "umap", label=F, group.by=groupby)
		ggsave(p, filename = sprintf('%s/%s_UMAP_%s_wolabel.png', outdir, bname, groupby), height=height, width=width)
		p = DimPlot(x, reduction = "umap", label=T, group.by=groupby)
		ggsave(p, filename = sprintf('%s/%s_UMAP_%s_wilabel.png', outdir, bname, groupby), height=height, width=width)
	})
