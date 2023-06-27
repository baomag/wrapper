library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# input: infile seurath52table rds
# parameter: 
# output:

abca4 <- readRDS(infile)
str(abca4)

# create data frame
celltype <- data.frame(
	barcode=names(Idents(abca4))
	, celltype=Idents(abca4)
	)

# save table as txt file
write.table(celltype, file=gzfile(sprintf('%s/%s.txt.gz', outdir, bname)), quote=F, sep='\t', row.names=F, col.names=T)
