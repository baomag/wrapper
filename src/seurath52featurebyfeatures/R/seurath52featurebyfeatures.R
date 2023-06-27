library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# input: infile
# output: feature plot.png

abca4 <- readRDS(infile)
DefaultAssay(abca4) <- "RNA"

# Temporary code
#abca4 = NormalizeData(abca4, normalization.method = "LogNormalize", scale.factor = 10000)
#abca4 = SplitObject(abca4,split.by="sampleid")

# Function to plot splited feature plots on the same plot
FeaturePlotSingle<- function(obj, feature, metadata_column, ...){
	all_cells<- colnames(obj)
	#groups<- levels(obj@meta.data[, metadata_column])
	groups<- unique(obj@meta.data[, metadata_column])
	minimal<- min(obj[['RNA']]@data[feature, ])
	maximal<- max(obj[['RNA']]@data[feature, ])
	ps<- list()
	for (group in groups) {
		subset_indx<- obj@meta.data[, metadata_column] == group
		subset_cells<- all_cells[subset_indx]
		p<- FeaturePlot(obj, features = feature, cells= subset_cells, ...) +
		scale_color_viridis_c(limits=c(minimal, maximal), direction = 1) +
		ggtitle(group) +
		theme(plot.title = element_text(size = 10, face = "bold"))
		ps[[group]]<- p
	}


	return(ps)
}

p_list <- FeaturePlotSingle(abca4, feature = features, metadata_column = split_group, pt.size = 0.05, order =TRUE)
layout1<-"
ABC
DEF
"
layout2<-"
AB
"
p <- wrap_plots(p_list ,guides = 'collect', design = layout1)
#p <- wrap_plots(p_list ,guides = 'collect', design = layout2)
#p <- FeaturePlot(abca4, features = features, pt.size= 1, split.by=split_group, keep.scale = "all") + theme(legend.position = c(0.1,0.2)) + guides(group = guide_legend(nrow = 2)) 
ggsave(p, filename = sprintf('%s/%s_featurebyfeature.png', outdir, bname) , height=height, width=width)

# use lapply
#lapply(
#	names(abca4)
#	, function(name){
#		x=abca4[[name]]
#		DefaultAssay(x) <- "RNA"
#		p <- FeaturePlot(x, features = features, pt.size= 1, split.by=split_group, keep.scale = "all") + theme(legend.position = c(0.1,0.2))
#		ggsave(p, filename = sprintf('%s/%s_%s_featurebyfeature.png', outdir, bname, name) , height=height, width=width)
#	})
