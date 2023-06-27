library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

abca4 <- readRDS(infile)

DefaultAssay(abca4) <- "RNA"

# take a subset of only rod and cone

#abca4_subset = subset(abca4, subset=(abca4@meta.data$celltype %in% subtype))
if(subtype_column!='') {
	#print(table(abca4@meta.data[, subtype_column] %in% subtype))
	abca4_subset=subset(abca4, cells=colnames(abca4)[abca4@meta.data[, subtype_column] %in% subtype])
}

# give the sample order
 abca4_subset@meta.data$sampleid <- factor(x = abca4_subset@meta.data$sampleid, levels = c("10x3v31_Organoid_JONR1_D135", 
		"10x3v31_Organoid_JONR_D262", "10x3v31_Organoid_SONR1_D135", 
		"10x3v31_Organoid_SONR_D262", "NHDF2_D130", "NHDF2_D320"))

#p <- VlnPlot(abca4_subset, features = features, pt.size=0, split.by=split_group, group.by=group) + NoLegend() + theme(axis.text.x = element_text(angle = 90, hjust = 1))
p <- VlnPlot(abca4_subset, features = features, pt.size=0, split.by=split_group, group.by=group) + theme(axis.text.x = element_blank())

ggsave(p, filename = sprintf('%s/%s_vlnbyfeature.png', outdir, bname) , height=height, width=width)
