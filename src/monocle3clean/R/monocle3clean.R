library(monocle3)
library(Seurat)
library(dplyr)
library(ggplot2)

cell_type <- celltype 

meta <- read.table(meta, header=T)
meta <- subset(meta, sampleid %in% samples)

#print(meta[(meta$sampleid %in% samples), ])
# meta[meta$sampleid, ] <- meta[(meta$sampleid %in% samples),]
# meta=meta[(meta$sampleid %in% samples), ]

nam <- paste(cell_type, collapse = "_")
seurat_object <- readRDS(infile)
cells <- meta[meta$celltype %in% cell_type, ]$barcode

#print("test seurat object colnames")
#print(colnames(seurat_object))
common_cells <- intersect(cells, colnames(seurat_object))
seurat_object <- subset(seurat_object, cells = common_cells)

expression_matrix <- seurat_object@assays$RNA@counts
cell_metadata <- seurat_object@meta.data
gene_annotation <- data.frame(row.names = rownames(expression_matrix))
gene_annotation$gene_short_name <- rownames(expression_matrix)
cds <- new_cell_data_set(expression_matrix, cell_metadata = cell_metadata,
	gene_metadata = gene_annotation)

## Step 1: Normalize and pre-process the data
cds <- preprocess_cds(cds, num_dim = 100)
##
## Step 2: Remove batch effects with cell alignment
cds <- align_cds(cds, alignment_group = "orig.ident")

## Step 3: Reduce the dimensions using UMAP
cds <- reduce_dimension(cds)

## Step 4: Cluster the cells
cds <- cluster_cells(cds)

## Step 5: Learn a graph
cds <- learn_graph(cds, use_partition = FALSE)

## Step 7: Save rds
saveRDS(cds, file=sprintf('%s/%s_monocle3_clean.rds', outdir, bname))

#write.csv(pseudotime(cds, reduction_method = "UMAP"), file=sprintf('%s/%s_monocle3_clean.csv', outdir, bname)) 
