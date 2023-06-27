args <- commandArgs(trailingOnly = TRUE)

library(monocle3)
library(Seurat)
library(dplyr)

# inputs: infile (merged sample rds), celltype, outdir

set.seed(0)

seurat_object <- readRDS(infile)
# subset seurat object 
seurat_object = subset(seurat_object, cells=colnames(seurat_object)[seurat_object@meta.data$celltype %in% celltype])

# add batch
seurat_object@meta.data$batch <- colnames(seurat_object)

# data preprocessing
seurat_object <- NormalizeData(seurat_object)
#seurat_object <- FindVariableFeatures(seurat_object, selection.method = "vst", nfeatures = 10000)
print('==> seurat_object')
str(seurat_object)

# make expression matrix
#expression_matrix <- seurat_object@assays$RNA@counts[VariableFeatures(seurat_object), ]
expression_matrix <- seurat_object@assays$RNA@counts
cell_metadata <- seurat_object@meta.data
gene_annotation <- data.frame(row.names = rownames(expression_matrix))
gene_annotation$gene_short_name <- rownames(expression_matrix)
print('==> gene_annotation')
str(gene_annotation)

# convert seurat object to cds format
cds <- new_cell_data_set(expression_matrix, cell_metadata = cell_metadata, gene_metadata = gene_annotation)
print('==> cds')
str(cds)
saveRDS(cds, file=sprintf('%s/%s_%s_convert.rds', outdir, bname, paste(celltype, collapse='_')))

