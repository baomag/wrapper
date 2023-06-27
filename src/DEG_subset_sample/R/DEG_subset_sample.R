library(sets)
library(reshape2)
library(dplyr)

# This code filter compare-sample/sample_time DEGs from Monocle 3
# parameters: q - q-value cutoff; n - number of cells expressed; f - fold change; 
# default number: q = 0.05; n = 1000

# Read models
compare_sample = read.csv(infile)

# filter based on metrics
filtered_model = subset(compare_sample, compare_sample$q_value < q_val)
filtered_model = subset(filtered_model, filtered_model$num_cells_expressed >= number)

# sort based on q value
sorted_model = filtered_model[order(filtered_model$q_value, decreasing = FALSE),]

# write csv
write.csv(sorted_model, file =sprintf('%s/%s_%s_sorted_model.csv', outdir, bname, celltype), quote = FALSE, sep = ",", row.names = FALSE)
