import numpy as np
import pandas as pd
import scanpy as sc

## input: infile, sample (a list of strings representing sample id wanted to extract)

# Read h5ad object
adata = sc.read_h5ad(infile)

# Subset based on sampleid
subdata = adata[adata.obs.sampleid.isin(sample)]

# Save subsetted object
subdata.write_h5ad('%s/%s.h5ad' % (outdir, bname))
