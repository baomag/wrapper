# This code finds the differentially expressed gene in a single model by comparing two data groups
# If using more complex model (multiple sample, timepoints, etc), use Monocle3regression instead
# Note: this code is designed for a binary comparsion so the input compare_group should only contain 2 groups/unique values
# Resource:  https://satijalab.org/seurat/articles/de_vignette

# Parameters: celltype, compare_group

library(Seurat)

# subset seurat object 
seurat_object = readRDS(infile)
seurat_object = subset(seurat_object, cells=colnames(seurat_object)[seurat_object@meta.data$celltype %in% celltype])

# set identity to the compare group
# Idents(seurat_object) = "sampleid"
Idents(seurat_object) = compare_group

# Find marker genes
ident1 = unique(seurat_object@meta.data[compare_group])[[1]][1] 
print(paste("ident1 = ",ident1))
ident2 = unique(seurat_object@meta.data[compare_group])[[1]][2]
print(paste("ident2 = ",ident2))
markers <- FindMarkers(seurat_object, ident.1 = ident1, ident.2 = ident2, only.pos = FALSE)
head(markers)

# save results
write.csv(markers, file=sprintf('%s/%s_%s_DEGs.csv', outdir, bname, celltype))

# Resulting talbe intepretation
# p_val : p-value (unadjusted)
# avg_log2FC : log fold-change of the average expression between the two groups. Positive values indicate that the feature is more highly expressed in the first group.
# pct.1 : The percentage of cells where the feature is detected in the first group
# pct.2 : The percentage of cells where the feature is detected in the second group
# p_val_adj : Adjusted p-value, based on Bonferroni correction using all features in the dataset.
