import pandas as pd
import numpy as np
import scanpy as sc
import matplotlib.pyplot as plt

gs = sc.read("/storage/singlecell/zz4/multi_organoid/results/Gene_score_matrix/gene_score.h5ad")

adata_result = sc.read("/storage/singlecell/maggie/multi/scVI_annotation/cleaned_10multi_normalized_merged.h5ad")

gs.obs.index = [x +"-0" for x in gs.obs.index]

cells = [x for x in adata_result.obs.index if x in gs.obs.index]
adata_result = adata_result[cells] 
gs = gs[cells]

gs.obsm["X_umap"] = adata_result.obsm["X_umap"]

scv.pp.normalize_per_cell(adata_result)
scv.pp.log1p(adata_result)

# Change gene name (color = ) and file name (save = ) correspondingly
sc.pl.umap(
		adata_result, 
		color="NR2E3", 
		#vmax=3, 
		frameon=False, 
		size=3, 
		save="NR2E3_gene_expression.svg", 
		title="",
)

sc.pl.umap(
		gs,
		color="NR2E3",
		vmax=3,
		frameon=False,
		size=3,
		save="NR2E3_gene_score.svg",
		title="",
)


# Temporary code for correlation matrix, need separate wrapper for it
adata_full = sc.read("/storage/singlecell/maggie/multi/scVI_annotation/merged_normalized_merged_annotated.h5ad")

#mylevel = ["Multi_H9_D35","Multi_H9_D47","Multi_organoid_NRL_D075","Multi_H9_D100","3V31_942_D112","Multi_NRL_GFP_D123",
#		"Multi_organoid_D133","Multi_organoid_D183","Multi_organoid_NRL_D206","Multi_organoid_NRL_D243", 
#		'17W1D_Fovea_retina', '17W1D_Nasal_retina', '17W1D_Temporal_retina', '17w1d_I_Ret', '17w1d_S_Ret', 
#		'Multi_Fetal_11w2d_FR', 'Multi_Fetal_11w2d_FR_2', 'Multi_Fetal_11w2d_NR', 'Multi_Fetal_13W_FR', 
#		'Multi_Fetal_13W_NR', 'Multi_Fetal_14w5d_FR', 'Multi_Fetal_14w5d_NR', 'Multi_Fetal_19W4d_FR', 
#		'Multi_Fetal_19W4d_NR', 'Multi_Fetal_20W2d_FR', 'Multi_Fetal_20W2d_NR','Multi_Fetal_23w1d_FR', 
#		'Multi_Fetal_23w1d_NR', 'Multiome_10w_FR','Multiome_10w_NR', 'Multiome_12w3d_FR', 'Multiome_12w3d_NR',
#		'Multiome_14w2d_FR', 'Multiome_14w2d_NR', 'Multiome_16w4d_FR','Multiome_16w4d_NR', 'Multiome_20w1d_FR', 
#		'Multiome_20w1d_NR','Multiome_23w4d_FR', 'Multiome_23w4d_NR', 'multi_19W3D_I_ret','multi_19W3D_N_RET', 'multi_19W3d_T_ret', 'multi_19w3d_F_ret','multi_19w3d_S_ret']

new_sampleid = ['organoid_D112', 'retina_17W1D_fovea', 'retina_17W1D_nasal', 'retina_17W1D_temporal', 'retina_17W1D_inferior', 'retina_17W1D_superior', 'retina_11W2D_fovea', 'retina_11W2D_fovea2', 'retina_11W2D_nasal', 'retina_13W_fovea', 'retina_13W_nasal', 'retina_14W5D_fovea', 'retina_14W5D_nasal', 'retina_19W4D_fovea', 'retina_19W4D_nasal', 'retina_20W2D_fovea', 'retina_20W2D_nasal', 'retina_23W1D_fovea', 'retina_23W1D_nasal', 'organoid_D35', 'organoid_D47', 'organoid_D100', 'organoid_D123', 'organoid_D133', 'organoid_D183', 'organoid_D75', 'organoid_D206', 'organoid_D243', 'retina_10W_fovea', 'retina_10W_nasal', 'retina_12W3D_fovea', 'retina_12W3D_nasal', 'retina_14W2D_fovea', 'retina_14W2D_nasal', 'retina_16W4D_fovea', 'retina_16W4D_nasal', 'retina_20W1D_fovea', 'retina_20W1D_nasal', 'retina_23W4D_fovea', 'retina_23W4D_nasal', 'retina_19W3D_inferior', 'retina_19W3D_nasal', 'retina_19W3D_temporal', 'retina_19W3D_fovea', 'retina_19W3D_superior']

adata_full.obs["sampleid"] = adata_full.obs["sampleid"].cat.rename_categories(new_sampleid)

# Plot correlation matrix of sampleid
ax = sc.pl.correlation_matrix(adata_full, 'sampleid', figsize=(10,10), save = "_fetal_organoid.png")


