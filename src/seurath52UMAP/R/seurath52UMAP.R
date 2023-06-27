library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# input: infile
# output: UMAP

abca4=readRDS(infile, refhook = NULL)

# Plot UMAP
# abca4 <- RunUMAP(abca4, dims = 1:30)

# p = DimPlot(pbmc, reduction = "umap")
# ggsave(p, filename = sprintf('%s/%s_UMAP.pdf', outdir, bname), height=height, width=width)

lapply(
	c('celltype', 'sampleid', 'timepoint', 'seurat_clusters')
	, function (groupby) {
		p = DimPlot(abca4, reduction = "umap", label=F, group.by=groupby)
		ggsave(p, filename = sprintf('%s/%s_UMAP_%s_wolabel.png', outdir, bname, groupby), height=height, width=width)
		p = DimPlot(abca4, reduction = "umap", label=T, group.by=groupby)
		ggsave(p, filename = sprintf('%s/%s_UMAP_%s_wilabel.png', outdir, bname, groupby), height=height, width=width)
	})
