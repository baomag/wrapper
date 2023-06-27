library(sets)
library(reshape2)
library(dplyr)

#This code filter compare-treatment/treatment_time DEGs from Monocle 3
#parameters: q - q-value cutoff; n - number of cells expressed; f - fold change; 
#default number: q = 0.01; n = 100; s: 1; f: 0.5

print(number)
print(q_val)
print(slope)
print(fold)

# Read models
treatment_time = read.csv(infile)
compare_treatment = read.csv(model)

# Dcast treatment_time model
xx=subset(treatment_time, treatment_time$term %in% 'treatmentcontrol')
term_combined = dcast(xx, gene_id~term, value.var = 'estimate')
xx_sub = select(xx, c("gene_id", "normalized_effect"))
treatment_time_new = merge(term_combined, xx_sub, by = "gene_id")

# Combine full and compare model
compare_sub = select(compare_treatment, c('gene_id', 'num_cells_expressed', 'q_value'))
combined_model = merge(treatment_time_new, compare_sub, by = 'gene_id')

# Filtering
filtered_model = subset(combined_model, combined_model$q_value < q_val)
filtered_model = subset(filtered_model, filtered_model$num_cells_expressed >= number)
filtered_model = subset(filtered_model, abs(filtered_model$treatmentcontrol) >= slope)
filtered_model = subset(filtered_model, abs(filtered_model$normalized_effect) >= fold)

# sort based on fold change
sorted_model = filtered_model[order(filtered_model$treatmentcontrol, decreasing = TRUE),]

# write csv
write.csv(sorted_model, file =sprintf('%s/%s_%s_sorted_model.csv', outdir, bname, celltype), quote = FALSE, sep = ",", row.names = FALSE)
