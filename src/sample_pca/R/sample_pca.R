library(Seurat)
library(ggplot2)
library(ggfortify)

# input: 6 samples merged data
# output: pca plots
# parameters: nfeatures = 2000, pr,cone,rod = TRUE/FALSE
# Reference: https://github.com/jiho/autoplot/blob/master/R/pca_autoplot.R

samples=readRDS(infile,refhook = NULL)
if (pr){
	samples = subset(samples, cells=colnames(samples)[samples@meta.data$celltype %in% c("Rod","Cone")])
}
if (cone){
	samples = subset(samples, cells=colnames(samples)[samples@meta.data$celltype %in% c("Cone")])
}
if (rod){
	samples = subset(samples, cells=colnames(samples)[samples@meta.data$celltype %in% c("Rod")])
}

# normalize
samples = NormalizeData(samples, normalization.method = "LogNormalize", scale.factor = 10000)

# find highly variable features
samples = FindVariableFeatures(samples, selection.method = "vst", nfeatures = nfeature)

# split samples by sampleid
ss_samples = SplitObject(samples,split.by="sampleid")

# store gene expression table of each sample in a list
sample_gene_expression = c()
for (item in ss_samples){
	sample_gene_expression = append(sample_gene_expression,GetAssayData(item))
	#sample_gene_expression = append(sample_gene_expression,item@assays$RNA@counts)
}

smean = matrix(ncol = nfeature)
for (i in 1:length(sample_gene_expression)){
	each_sample = sample_gene_expression[[i]]
	# subset each sample to include only the highly variable features
	each_sample = each_sample[rownames(each_sample) %in% VariableFeatures(samples),]
	# scale each sample by its features
	each_sample = ScaleData(each_sample, features = rownames(each_sample))
	# convert each sample to a matrix format
	each_sample = as.matrix(each_sample)
	# calculate mean gene expression across all cells for each sample
	smean = rbind(smean,t(as.matrix(rowMeans(each_sample))))
}

smean = smean[2:7,]
rownames(smean) = names(ss_samples)
smean = as.data.frame(smean)
smean = cbind(smean,rownames(smean))
colnames(smean)[nfeature+1] = "sampleid"
treatment =  c("abca4", "abca4", "abca4", "abca4", "control", "control")
smean = cbind(smean,treatment)

# run pca
#pca_res <- prcomp(t(smean), scale. = TRUE)
pca_res <- prcomp(smean[,1:nfeature], scale. = TRUE)
print(pca_res)

# extract PC1 and PC2
pc1 = pca_res$x[,"PC1"]
pc2 = pca_res$x[,"PC2"]
# calculate the standard variance for each pc
svar = pca_res$sdev**2
# calculate the percent explained by each pc
percent_explained = svar / sum(svar)
percent_explained = round(percent_explained * 100, digit = 2)

# prepare the data frame for pca plotting
pca_res$sampleid = rownames(pca_res$x)
pca_res$treatment = c("abca4", "abca4", "abca4", "abca4", "control", "control")

# plot pca
#pca_plot = ggplot(data = pca_res, aes(x = PC1, y = PC2))+ geom_point(aes(color = pca_res$sampleid)) +
#					xlab(paste("PC1 (",percent_explained[1],"%)")) + ylab(paste("PC2 (",percent_explained[2],"%)")) +
#
#					+	theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
#						panel.background = element_blank(), axis.line = element_line(colour = "black"))


pca_plot = autoplot(pca_res, data = smean, colour = "treatment", size = 4) +
theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
	panel.background = element_blank(), axis.line = element_line(colour = "black"))

# save plot
if (pr){
	ggsave(pca_plot, filename = sprintf('%s/%s_pr.png', outdir, bname) , height=height, width=width)
}
if (cone){
	ggsave(pca_plot, filename = sprintf('%s/%s_cone.png', outdir, bname) , height=height, width=width)
}
if (rod){
	ggsave(pca_plot, filename = sprintf('%s/%s_rod.png', outdir, bname) , height=height, width=width)
}
if (rod == FALSE & cone == FALSE & pr == FALSE){
	ggsave(pca_plot, filename = sprintf('%s/%s_full.png', outdir, bname) , height=height, width=width)
}

# get top genes for pc1 and pc2
pca1 = pca_res$rotation[, 'PC1']
pca2 = pca_res$rotation[, 'PC2']
top30_pca1 = names(head(sort(abs(pca1), decreasing=TRUE), n=30))
top30_pca2 = names(head(sort(abs(pca2), decreasing=TRUE), n=30))

# form data frame of feature names vs actual pca value before plotting
pca1_genes = data.frame(top30_pca1, pca1[top30_pca1])
colnames(pca1_genes)=c("feature","val")
pca1_genes = pca1_genes[order(pca1_genes$val,decreasing=TRUE),]
pca2_genes = data.frame(top30_pca2, pca2[top30_pca2])
colnames(pca2_genes)=c("feature","val")
pca2_genes = pca2_genes[order(pca2_genes$val,decreasing=TRUE),]

# plot pca1 features
pca1_genes$y=factor(pca1_genes$feature, levels=rev(pca1_genes$feature))
pc1_plot = ggplot(pca1_genes, aes(x = val, y = y)) + geom_point(colour="blue") + xlab("PC_1")+
theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
	panel.background = element_blank(), axis.line = element_line(colour = "black"))
if (pr){
	ggsave(pc1_plot, filename = sprintf('%s/%s_pc1ft_pr.png', outdir, bname) , height=height, width=width)
}
if (cone){
	ggsave(pc1_plot, filename = sprintf('%s/%s_pc1ft_cone.png', outdir, bname) , height=height, width=width)
}
if (rod){
	ggsave(pc1_plot, filename = sprintf('%s/%s_pc1ft_rod.png', outdir, bname) , height=height, width=width)
}
if (rod == FALSE & cone == FALSE & pr == FALSE){
	ggsave(pc1_plot, filename = sprintf('%s/%s_pc1ft_full.png', outdir, bname) , height=height, width=width)
}

# plot pca2 features
pca2_genes$y=factor(pca2_genes$feature, levels=rev(pca2_genes$feature))
pc2_plot = ggplot(pca2_genes, aes(x = val, y = y)) + geom_point(colour="blue") + xlab("PC_2")+
theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
	panel.background = element_blank(), axis.line = element_line(colour = "black"))
if (pr){
	ggsave(pc2_plot, filename = sprintf('%s/%s_pc2ft_pr.png', outdir, bname) , height=height, width=width)
}
if (cone){
	ggsave(pc2_plot, filename = sprintf('%s/%s_pc2ft_cone.png', outdir, bname) , height=height, width=width)
}
if (rod){
	ggsave(pc2_plot, filename = sprintf('%s/%s_pc2ft_rod.png', outdir, bname) , height=height, width=width)
}
if (rod == FALSE & cone == FALSE & pr == FALSE){
	ggsave(pc2_plot, filename = sprintf('%s/%s_pc2ft_full.png', outdir, bname) , height=height, width=width)
}


