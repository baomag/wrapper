library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)
library(stringr)

# input: infile seurath52table rds
# output: id_add_meta.rds (object with metadata now containing sample id(ex.HUCR_D137) and celltype (ex.cone, rod))

#x <- readRDS(infile)
abca4 <- readRDS(infile)

# add the sampleid column based on bname
#x[['sampleid']]=bname
abca4[['sampleid']]=bname
#abca4[['celltype']]=Idents(abca4)

# extract time from bname and assign to Time column in each sample
#x[['Time']]=str_extract(bname,"D[0-9]+")

# rename the cells so repeated cell name can be distinguished between samples
abca4 = RenameCells(abca4, gsub(" ","", paste(bname)))

# add treatment control or abca4
# temporary code, only for this specific task, need to be generalized
#if (grepl('NHDF', bname)) {
#	abca4[['treatment']]="control"
#}else{
#	abca4[['treatment']]="abca4"
#}
#abca4[['treatment']]="control"

# add early or late timepoint
# temporary code, only for this specific task, need to be generalized
#abca4[['timepoint']]=ifelse(grepl('D1', abca4@meta.data[['sampleid']]), 'early', 'late')
abca4[['timepoint']]=ifelse(grepl('D1', abca4@meta.data[['sampleid']]), 'late', 'early')

# save RDS
#saveRDS(x, file=sprintf('%s/%s_add_meta.rds', outdir, bname))
#write.table(cbind(barcode=colnames(x), x@meta.data), file=gzfile(sprintf('%s/%s_metadata.txt.gz', outdir, bname)), col.names=T, row.names=F, quote=F, sep='\t')
saveRDS(abca4, file=sprintf('%s/%s_add_meta.rds', outdir, bname))
write.table(cbind(barcode=colnames(abca4), abca4@meta.data), file=gzfile(sprintf('%s/%s_metadata.txt.gz', outdir, bname)), col.names=T, row.names=F, quote=F, sep='\t')
