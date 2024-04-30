library(Seurat)
library(SeuratDisk)

# Read seurat object from rds and convert it to h5ad file

x = readRDS(infile)

SaveH5Seurat(x, seuratfile)

Convert(seuratfile, dest=outfile, assay=assay)
# Convert(seuratfile, dest=outfile, assay = "RNA")

# WARNING: Code not fully developed, need wrapper and adjustments
# NOTE: infile = seurat rds, seruatfile = filename and path of output h5seurat file, outfile = filename and path of h5ad file

