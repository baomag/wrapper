library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# input: infile
# For organoid project RPC gene dot plot, input is the scVI_annotated_merged rds and group by sampleid
# parameter: cell, marker (/storage/chen/home/u244209/ABCA4/hs_marker.txt)
# output: dotplot.pdf

abca4 <- readRDS(infile)

marker <- read.table(marker, header = TRUE, sep='\t')

# subest the seurat object to only include interested cell type
# abca4 = subset(xx, majorclass=="PRPC")

# Provide level of sampleid
mylevel = c("Multi_H9_D35","Multi_H9_D47","Multi_organoid_NRL_D075","Multi_H9_D100","3V31_942_D112", 
	"Multi_NRL_GFP_D123","Multi_organoid_D133","Multi_organoid_D183","Multi_organoid_NRL_D206","Multi_organoid_NRL_D243")

# Relevel the sampleid column of metadata
abca4@meta.data$sampleid <- factor(x = abca4@meta.data$sampleid, levels = mylevel)

features = unique(marker$symbol)
# features = cc.genes$s.genes
# features = cc.genes$g2m.genes

#Idents(abca4)=factor(Idents(abca4), levels=unique(marker$celltype))

#1. if the input is merged data or a single sample, use the following code:
#p <- DotPlot(abca4, features = features, group.by= "orig.ident") + RotatedAxis()
p <- DotPlot(abca4, features = features, group.by= "sampleid") + RotatedAxis()
ggsave(p, filename = sprintf('%s/%s_dotplot.pdf', outdir, bname) , height=height, width=width)

#2. if the input is split data (split by orig.ident), use the following code:
#lapply(
#	names(abca4)
#	, function(name){
#		x<-abca4[[name]]
#		x=subset(x,cells=colnames(x)[x@meta.data[, 'celltype'] %in% c("Cone","Rod","RPE")])
#		x@meta.data$celltype <- factor(x@meta.data$celltype, levels = c("Cone","Rod","RPE"))
#		p <- DotPlot(x, features = features) + RotatedAxis()
#		ggsave(p, filename = sprintf('%s/%s_%s_dotplot.pdf', outdir, bname, name) , height=height, width=width)
#	})
