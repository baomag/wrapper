args <- commandArgs(trailingOnly = TRUE)

library(monocle3)
library(Seurat)
library(dplyr)
library(ggplot2)

# input: infile as preprossed cds stored in rds
# parameters: num_dim (default 50)

cds <- readRDS(infile)

# cds preprocessing
cds <- preprocess_cds(cds, num_dim = num_dim)
cds <- align_cds(cds, alignment_group = "sampleid")

# reduce dimension
cds <- reduce_dimension(cds)

# cluster cells
cds <- cluster_cells(cds)

# learn the tragectory graph
cds <- learn_graph(cds, use_partition = FALSE)

# plot UMAP colored by real time (early and late)
p <- plot_cells(cds,
	color_cells_by = "timepoint",
	label_cell_groups=FALSE,
	label_leaves=TRUE,
	label_branch_points=TRUE,
	graph_label_size=1.5)

ggsave(p, filename = sprintf('%s/%s_clustered_clocktime.png', outdir, bname) , height=height, width=width)

# plot UMAP colored by celltpes
p <- plot_cells(cds,
	color_cells_by = "celltype",
	label_cell_groups=FALSE,
	label_leaves=TRUE,
	label_branch_points=TRUE,
	graph_label_size=1.5)

ggsave(p, filename = sprintf('%s/%s_clustered_celltypes.png', outdir, bname) , height=height, width=width)

# helper function to help identify the root node by cell clock time (early/late)
get_earliest_principal_node <- function(cds, time_bin="PRPC"){
	cell_ids <- which(colData(cds)[, "celltype"] == time_bin)

	closest_vertex <-
		cds@principal_graph_aux[["UMAP"]]$pr_graph_cell_proj_closest_vertex
	closest_vertex <- as.matrix(closest_vertex[colnames(cds), ])
	root_pr_nodes <-
		igraph::V(principal_graph(cds)[["UMAP"]])$name[as.numeric(names
			(which.max(table(closest_vertex[cell_ids,]))))]
	root_pr_nodes
}

# order the cells by the programmatically identified root node
cds <- order_cells(cds, root_pr_nodes=get_earliest_principal_node(cds))

# plot UMAP colored by pseudotime
p <- plot_cells(cds,
	color_cells_by = "pseudotime",
	label_cell_groups=FALSE,
	label_leaves=FALSE,
	label_branch_points=FALSE,
	graph_label_size=1.5)

ggsave(p, filename = sprintf('%s/%s_clustered_pseudotime.png', outdir, bname) , height=height, width=width)

saveRDS(cds, file=sprintf('%s/%s_pseudotime.rds', outdir, bname))

