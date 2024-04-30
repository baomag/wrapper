library(sets)
library(reshape2)
library(dplyr)

# This code filter compare-sample/sample_time DEGs from Monocle 3
# parameters: q - q-value cutoff; n - number of cells expressed; f - fold change; 
# default number: q = 0.05; n = 200
# The revised code specifically look at the late time point (D262) DEGs between the two patients

# Read models
sample_time = read.csv(infile)
compare_sample = read.csv(model)

# Dcast sample_time model
# Subject to change if want to compare different samples or all samples
xx=subset(sample_time, sample_time$term %in% 'sampleid10x3v31_Organoid_SONR_D262')
term_combined = dcast(xx, gene_id~term, value.var = 'estimate')
xx_sub = select(xx, c("gene_id", "normalized_effect"))
sample_time_new = merge(term_combined, xx_sub, by = "gene_id")
head(sample_time_new)

# Combine full and compare model
compare_sub = select(compare_sample, c('gene_id', 'num_cells_expressed', 'q_value'))
combined_model = merge(sample_time_new, compare_sub, by = 'gene_id')

# filter based on metrics
filtered_model = subset(combined_model, combined_model$q_value < q_val)
filtered_model = subset(filtered_model, filtered_model$num_cells_expressed >= number)
filtered_model = subset(filtered_model, abs(filtered_model$sampleid10x3v31_Organoid_SONR_D262) >= slope)
filtered_model = subset(filtered_model, abs(filtered_model$normalized_effect) >= fold)

# sort based on q value
sorted_model = filtered_model[order(filtered_model$q_value, decreasing = FALSE),]

# write csv
write.csv(sorted_model, file =sprintf('%s/%s_%s_sorted_model.csv', outdir, bname, celltype), quote = FALSE, sep = ",", row.names = FALSE)
