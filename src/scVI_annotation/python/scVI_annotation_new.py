# Importing libraries
import warnings
warnings.simplefilter(action="ignore", category=FutureWarning)

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import scvi
import scanpy as sc

# Set up figure parameters and seed
sc.set_figure_params(figsize=(10, 10))
scvi.settings.seed = 0

# Load reference data
# Adult reference
#adata_ref = sc.read("/storage/chentemp/zz4/adult_dev_compare/data/adult_reference/all/major_clean_major_scvi_Cluster_clean.h5ad")
# Fetal reference (Can also use for organoid)
adata_ref = sc.read("/storage/chentemp/zz4/adult_dev_compare/results/adata_object_UMAP/ALL.h5ad")

# Preprocess reference data
sc.pp.highly_variable_genes(adata_ref, flavor="seurat_v3", n_top_genes=10000)
data_ref = adata_ref[:, adata_ref.var.highly_variable].copy()

# Setup SCVI for reference
scvi.model.SCVI.setup_anndata(adata_ref, batch_key="sampleid")
arches_params = dict(
		    use_layer_norm="both",
				    use_batch_norm="none",
						    encode_covariates=True,
								    dropout_rate=0.2,
										    n_layers=2,
												)

# Train reference data
vae_ref = scvi.model.SCVI(adata_ref, **arches_params)
vae_ref.train(accelerator="gpu")

# Perform clustering and UMAP on reference data
adata_ref.obsm["X_scVI"] = vae_ref.get_latent_representation()
sc.pp.neighbors(adata_ref, use_rep="X_scVI")
sc.tl.leiden(adata_ref)
sc.tl.umap(adata_ref)

# Load query data
#adata_query = sc.read("/storage/chentemp/maggie/owen/seurath52merge/crb1_merged.h5ad")
adata_query = sc.read("/storage/chentemp/maggie/ABCA4/seurath52merge/reannotated_samples_merged.h5ad")

# Prepare query data for SCVI
scvi.model.SCVI.prepare_query_anndata(adata_query, vae_ref)

# Train SCANVI model
vae_ref_scan = scvi.model.SCANVI.from_scvi_model(
		    vae_ref,
				    unlabeled_category="Unknown",
						    labels_key="majorclass",
								)
vae_ref_scan.train(max_epochs=100)

# Perform clustering and UMAP on reference data with SCANVI
adata_ref.obsm["X_scANVI"] = vae_ref_scan.get_latent_representation()
sc.pp.neighbors(adata_ref, use_rep="X_scANVI")
sc.tl.leiden(adata_ref)
sc.tl.umap(adata_ref)

# Load query data for SCANVI
vae_q = scvi.model.SCANVI.load_query_data(
		    adata_query,
				    vae_ref_scan,
						)

# Train SCANVI model on query data
vae_q.train(
		    max_epochs=250,
				    plan_kwargs=dict(weight_decay=0.0),
						    check_val_every_n_epoch=10,
								    batch_size=640
										)

# Get latent representation and predictions for query data
adata_query.obsm["X_scANVI"] = vae_q.get_latent_representation()
adata_query.obs["celltype"] = vae_q.predict()

# Concatenate query and reference data
adata_full = adata_query.concatenate(adata_ref)
adata_full.obs.batch.cat.rename_categories(["Query", "Reference"])

# Perform clustering and UMAP on combined data
sc.pp.neighbors(adata_full, use_rep="X_scANVI")
sc.tl.leiden(adata_full)
sc.tl.umap(adata_full)

# Save final annotated data and cell type predictions
adata_full.write("/storage/chentemp/maggie/ABCA4/scvi_annotation/scvi_annotated_ABCA4_full.h5ad")
adata_query.write("/storage/chentemp/maggie/ABCA4/scvi_annotation/scvi_annotated_ABCA4.h5ad")
adata_query.obs.to_csv("/storage/chentemp/maggie/ABCA4/scvi_annotation/scvi_annotated_ABCA4.csv")

# Plot UMAP and save results
sc.pl.umap(
		    adata_full,
				    color=["batch", "celltype"],
						    frameon=False,
								    ncols=1,
										    size=3,
														)
fig = plt.gcf()
fig.set_size_inches(5, 5)
plt.savefig(
		    "/storage/chentemp/maggie/ABCA4/scvi_annotation/scvi_annotated_ABCA4_UMAP.png",
				    dpi=600,
						)

