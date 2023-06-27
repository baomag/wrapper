args <- commandArgs(trailingOnly = TRUE)

library(monocle3)
library(Seurat)
library(dplyr)

cds <- readRDS(infile)

# Creating models
sample_time_models <- fit_models(cds, model_formula_str = "~ sampleid + timepoint", verbose = TRUE, expression_family = "negbinomial")
#print('==> sample time model')
#str(sample_time_models)
#fit_coefs_sample_time_models <- coefficient_table(sample_time_models)
#print('==> fit coefs sample time model')
#str(fit_coefs_sample_time_models)
time_models <- fit_models(cds, model_formula_str = "~ timepoint", expression_family = "negbinomial", verbose = TRUE)
#print('==> time model')
#str(time_models)
#fit_coefs_time_models <- coefficient_table(time_models)
#print('==> fit coefs time model')
#str(fit_coefs_time_models)
compare_sample <- compare_models(sample_time_models, time_models)
print('==> compare sample')
str(compare_sample)

# Write tables
#write.table(
#	fit_coefs_sample_time_models[, c(-4, -5)]
#	, file = sprintf('%s/%s_%s_sample_time_models.csv', outdir, bname, celltype)
#	, quote = FALSE
#	, sep = ","
#	, row.names = FALSE
#	)
#write.table(
#	fit_coefs_time_models[, c(-4, -5)]
#	, file = sprintf('%s/%s_%s_time_models.csv', outdir, bname, celltype)
#	, quote = FALSE, sep = ","
#	, row.names = FALSE
#	)
write.table(
	compare_sample
	, file = sprintf('%s/%s_%s_compare_sample.csv', outdir, bname, celltype)
	, quote = FALSE
	, sep = ","
	, row.names = FALSE)
