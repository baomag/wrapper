import scanpy as sc
import numpy as np
import pandas as pd
import anndata as ad

# read in organoid, fetal, and adult data
organoid = sc.read("/storage/singlecell/maggie/ABCA4/seurath52merge/reannotated_samples_merged.h5ad")
fetal = sc.read("/storage/singlecell/zz4/fetal_snakemake/results/cellbygene/adata_normalized.h5ad")
adult = sc.read("/storage/singlecell/zz4/fetal_snakemake/data/adult_reference/all/major_clean_major_scvi_Cluster_clean.h5ad)

# read in marker list from a csv file
file = open("/storage/chen/home/u244209/ABCA4/cell_cycle_g2m_genes.csv", "r")
data = list(csv.reader(file, delimiter=","))
file.close()
markers = sum(data, [])

# add meta to each object to denote which type of data
organoid.obs["source"] = "organoid"
fetal.obs["source"] = "fetal"
adult.obs["source"] = "adult"

# check cell type names in fetal and adult data
print(fetal.obs.majorclass.unique().tolist())
print(adult.obs.majorclass.unique().tolist())

# unify cell type names and column names for cell types
fetal.obs["celltype"]=fetal.obs.majorclass.replace({
	"PRPC":"RPC", "NRPC":"RPC", "Rod Precursor":"Rod", "ML_Cone":"Cone", "Cone Precursor":"Cone",
	"HC1":"HC", "AC Precursor":"AC", "RGC Precursor":"RGC", "OFF_MGC":"MG", "HC0":"HC",
	"OFF-BC":"BC", "GABAergic":"Other", "ON-BC":"BC", "BC Precursor":"BC", "ON_MGC":"MG",
	"RBC":"BC", "S_Cone":"Cone", "Glycinergic":"Other", "dual ACs":"AC", "SACs":"AC"})
adult.obs["celltype"]=adult.obs.majorclass.replace({
	"Astrocyte":"Astro", "Microglia":"Other"})

# merge all samples
full = ad.concat([fetal, organoid])
full = ad.concat([full, adult])

# plot dotplots groupby sampleid, celltype, and source
sc.pl.dotplot(full,markers,groupby = "sampleid", save = "dotplot_full_g2m_sampleid.png")
sc.pl.dotplot(full,markers,groupby = "celltype", save = "dotplot_full_g2m_celltype.png")
sc.pl.dotplot(full,markers,groupby = "source", save = "dotplot_full_g2m_source.png")

# subset full anndata
# organoid1 = full[full.obs['source'].isin(["organoid"])]
