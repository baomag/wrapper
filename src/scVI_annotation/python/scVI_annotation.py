import warnings 
warnings.simplefilter(action="ignore", category=FutureWarning)

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import scvi
import scanpy as sc

# Input: ref = reference; infile = query; outfile = h5ad file; outcsv = csv file
# Parameters: 
# https://docs.scvi-tools.org/en/stable/tutorials/notebooks/scarches_scvi_tools.html

sc.set_figure_params(figsize=(10, 10))
scvi.settings.seed = 0

# load reference
adata_ref = sc.read("/storage/chentemp/zz4/adult_dev_compare/data/adult_reference/all/major_clean_major_scvi_Cluster_clean.h5ad")
#adata_ref = sc.read("/storage/singlecell/maggie/ABCA4/seurath52merge/reannotated_samples_merged.h5ad")
print(adata_ref)
# Check if the cell count for each cell type of the reference is balanced
#print(adata_ref.obs.seurat_v3.value_counts())

sc.pp.highly_variable_genes(adata_ref, flavor="seurat_v3", n_top_genes=10000)
data_ref = adata_ref[:, adata_ref.var.highly_variable].copy()
print(adata_ref)

scvi.model.SCVI.setup_anndata(adata_ref, batch_key="sampleid")
arches_params = dict(
		use_layer_norm="both",
		use_batch_norm="none",
		encode_covariates=True,
		dropout_rate=0.2,
		n_layers=2,
)

# We train the reference using the standard SCVI workflow, except we add a few non-default parameters that were identified to work well with scArches
vae_ref = scvi.model.SCVI(adata_ref, **arches_params)
vae_ref.train(accelerator = "gpu")

adata_ref.obsm["X_scVI"] = vae_ref.get_latent_representation()
sc.pp.neighbors(adata_ref, use_rep="X_scVI")
sc.tl.leiden(adata_ref)
sc.tl.umap(adata_ref)

#adata_query = sc.read("/storage/singlecell/maggie/multi/1.cellqc/result/merged_cleaned_sampleid_multi.h5ad")
#adata_query = sc.read("/storage/singlecell/maggie/ABCA4/seurath52merge/tomreh_controls_merged.rds")
adata_query = sc.read("/storage/singlecell/maggie/owen/seurath52merge/unannotated_4sample_merged.h5ad")

## The following chunk of code is temporary
#adata_query = sc.read("/storage/singlecell/maggie/owen/seurath52merge/4samples_merged_count_matrix.mtx")
#adata_query = adata_query.transpose()
#names = pd.read_csv("/storage/singlecell/maggie/owen/seurath52merge/4samples_merged_gene_names.csv", header = None)
#id = pd.read_csv("/storage/singlecell/maggie/owen/seurath52merge/4samples_merged_cell_id.csv", header = None)
#adata_query.var.index = names[0]
#adata_query.obs.index = id[0]
## End of the chunk of the code

scvi.model.SCVI.prepare_query_anndata(adata_query, vae_ref)

vae_ref_scan = scvi.model.SCANVI.from_scvi_model(
		vae_ref,
		unlabeled_category="Unknown",
#		labels_key="celltype",
		labels_key="majorclass",
)

vae_ref_scan.train(max_epochs=100)

adata_ref.obsm["X_scANVI"] = vae_ref_scan.get_latent_representation()
sc.pp.neighbors(adata_ref, use_rep="X_scANVI")
sc.tl.leiden(adata_ref)
sc.tl.umap(adata_ref)

vae_q = scvi.model.SCANVI.load_query_data(
		adata_query,
		vae_ref_scan,
)

vae_q.train(
		max_epochs=250,
		plan_kwargs=dict(weight_decay=0.0),
		check_val_every_n_epoch=10,
		batch_size = 640
)

adata_query.obsm["X_scANVI"] = vae_q.get_latent_representation()
adata_query.obs["celltype"] = vae_q.predict()

adata_full = adata_query.concatenate(adata_ref)
#adata_full.obs.batch.cat.rename_categories(["Query", "Reference"], inplace=True)
adata_full.obs.batch.cat.rename_categories(["Query", "Reference"])

sc.pp.neighbors(adata_full, use_rep="X_scANVI")
sc.tl.leiden(adata_full)
sc.tl.umap(adata_full)

sc.pl.umap(
		adata_full,
		color=["batch", "celltype"],
		frameon=False,
		ncols=1,
		size=3,
		save="/storage/chentemp/maggie/owen/seurath52annotation/owen_merged_annotated_UMAP.png",
)

adata_full.write("/storage/singlecell/maggie/owen/seurath52annotation/owen_merged_annotated.h5ad")
adata_query.obs.to_csv("/storage/singlecell/maggie/owen/seurath52annotation/owen_merged_annotated.csv")
