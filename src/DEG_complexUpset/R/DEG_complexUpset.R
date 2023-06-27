library(sets)
library(reshape2)
library(dplyr)

# This code remove overlapping treatment DEGs and sample DEGs from treatment DEGs,
# sort them based on fold change, and output a table of pure treatment DEGs gene id.

# Read Models
treatment = read.csv(infile)
samples = read.csv(model)

new_treatment = subset(treatment, treatment$gene_id %in% setdiff(treatment$gene_id, samples$gene_id))

write.table(new_treatment$gene_id, file =sprintf('%s/%s_%s_DEGs.txt', outdir, bname, celltype), col.names = FALSE, row.names = FALSE)
write.csv(new_treatment, file =sprintf('%s/%s_%s_sorted_model.csv', outdir, bname, celltype), quote = FALSE, sep = ",", row.names = FALSE)
