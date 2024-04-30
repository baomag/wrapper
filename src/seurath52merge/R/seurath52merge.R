library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)
library(SeuratDisk)

# input: infile seurath52add_meta.rds
# output: rds with new seurat object that merged 8 samples

objlist=parallel::mclapply(
	files
	, function(f) {
		obj=readRDS(f)
#		obj <- LoadH5Seurat(f)
		obj
	}
	, mc.cores=numthreads
	)
str(objlist)

if (length(objlist)>1) {
	x=merge(x=objlist[[1]], y=objlist[-1])
} else {
	x=objlist[[1]]
}
str(x)
saveRDS(x, file=sprintf('%s/%s_merged.rds', outdir, bname))
#SaveH5Seurat(x, sprintf('%s/%s_merged.h5seurat', outdir, bname))
write.table(cbind(barcode=colnames(x), x@meta.data), file=gzfile(sprintf('%s/%s_metadata.txt.gz', outdir, bname)), col.names=T, row.names=F, quote=F, sep='\t')
