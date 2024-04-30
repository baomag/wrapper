library(monocle3)
library(Seurat)
library(dplyr)
library(ggplot2)

# input: infile as preprossed cds stored in rds
# parameters: num_dim (default 50)

cds <- readRDS(infile)

# Define genes to be plotted
features1 = c("OTX2", "OPN1MW")
features2 = c("PDE6H","GNAT2")

# plot UMAP colored by selected gene expression
p1 <- plot_cells(cds, genes = features1)
p2 <- plot_cells(cds, genes = features2)
ggsave(p1, filename = sprintf('%s/%s_featureplot_controls.png', outdir, bname) , height=height, width=width)
ggsave(p2, filename = sprintf('%s/%s_featureplot_tests.png', outdir, bname) , height=height, width=width)

# subset cds
cds_subset1 <- cds[rowData(cds)$gene_short_name %in% features1,]
cds_subset2 <- cds[rowData(cds)$gene_short_name %in% features2,]

# plot gene expression by pseudotime grouped by clock time
p1 = plot_genes_in_pseudotime(cds_subset1, color_cells_by="timepoint")
p2 = plot_genes_in_pseudotime(cds_subset2, color_cells_by="timepoint")

ggsave(p1, filename = sprintf('%s/%s_pseudotime_tragectory_controls.png', outdir, bname) , height=height, width=width)
ggsave(p2, filename = sprintf('%s/%s_pseudotime_tragectory_tests.png', outdir, bname) , height=height, width=width)

