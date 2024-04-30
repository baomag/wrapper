library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# input: files 
# parameter: numthreads
# output: rds of integrated samples 

# read object and store in abca4 object list
abca4.list=parallel::mclapply(
	files
	, function(f) {
		abca4=readRDS(f)
		abca4	
	}
	, mc.cores=numthreads
	)

### # normalize and identify variable features for each dataset independently
### abca4.list <- lapply(X = abca4.list, FUN = function(x) {
###     x <- NormalizeData(x)
###     x <- FindVariableFeatures(x, selection.method = "vst", nfeatures = 2000)
### })

# select features that are repeatedly variable across datasets for integration
features <- SelectIntegrationFeatures(object.list = abca4.list)
print("features selected")

# integrate data
cell.anchors <- FindIntegrationAnchors(object.list = abca4.list, anchor.features = features)
print("cell anchor found")
cell.combined <- IntegrateData(anchorset = cell.anchors)
print("cells combined")

DefaultAssay(cell.combined) <- "integrated"

# save RDS
print("saving RDS to.....")
saveRDS(cell.combined, file=sprintf('%s/%s_integrate.rds', outdir, bname))
