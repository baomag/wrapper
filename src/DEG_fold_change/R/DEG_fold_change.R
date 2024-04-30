library(Seurat)

# read merged rds file
x = readRDS(infile)

# Subset patient and control cells and store the name of the cells
abca4_cells=colnames(x)[x@meta.data$treatment == "abca4"]
control_cells=colnames(x)[x@meta.data$treatment == "control"]

# Calculate fold change and return a data frame
fc = FoldChange(x, abca4_cells, control_cells)
