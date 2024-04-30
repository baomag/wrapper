import numpy as np
import pandas as pd
import scanpy as sc
import anndata as ad

## This code read in a table containing sample id and path information to merge >2 scanpy adata together
## The input files should be in h5ad files and the data should already went througth the quality control (although optional)
## This code will also create unique cell namesa and a new column in obs for sample id
## Other metadata (time, region, age, etc), however, need to be added using another wrapper
## The merged object output from this code will be suitable for running scVI cell type annotation

# Input: infile (txt file with sample id in it), indir (str), outdir (mirror directory), bname(str)
# indir = /storage/singlecell/maggie/multi/1.cellqc/result
# infile = samples_multi.txt

# read input sample information (sampleid)
df = pd.read_csv(infile, sep = '\t')

# first the first h5ad file and store as merged anndata
merged = sc.read_h5ad('/'.join([indir,df.sampleid[0]])+'.h5ad')
# change index to avoid duplicates
merged.obs.index = [df.sampleid[0] + '_' + x for x in merged.obs.index]
# add column of sampleid
merged.obs['sampleid'] = df.sampleid[0]

# drop the first row of the sample data frame since it's already added
df = df.drop(0)

# concat the rest of the samples to the same anndata in a for loop
for id in df.sampleid:
	# read the corresponding h5ad file
	print('/'.join([indir,id])+'.h5ad')
	f = sc.read_h5ad('/'.join([indir,id])+'.h5ad')
	# change the index so duplicated cells won't be dropped
	f.obs.index = [id + '_' + x for x in f.obs.index]
	# add a new obs of sampleid
	f.obs['sampleid'] = id
	# concat anndata
	merged = ad.concat([merged, f])

# save object as a merged h5ad file
merged.write_h5ad('%s/%s.h5ad' % (outdir, bname))
