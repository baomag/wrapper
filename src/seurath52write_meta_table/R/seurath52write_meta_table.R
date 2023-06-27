library(dplyr)
library(Seurat)
library(patchwork)

# parameters: feature (ex. celltype), values (ex. Cone or Rod), multiple_values (true or false)

# read full metadata
metadata <- read.table(infile)

# taking subset of metadata
meta_sub <- subset(metadata, grepl(paste(values, collapse="|"), metadata$feature))

# write table		How to change basename	Why do we always save as compressed file?
write.table(meta_sub, file=gzfile(sprintf('%s/%s_%s_metadata.txt.gz', outdir, bname, values)), col.names=T, row.names=F, quote=F, sep='\t')

