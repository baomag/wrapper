args <- commandArgs(trailingOnly = TRUE)

library(monocle3)
library(Seurat)
library(dplyr)

cds <- readRDS(infile)

# create simple model
#simple_model <- fit_models(cds, model_formula_str = "~treatment")
sample_model <- fit_models(cds, model_formula_str = "~sampleid")
#fit_coefs_simple_model <- coefficient_table(simple_model)
fit_coefs_sample_model <- coefficient_table(sample_model)
#write.table(
#	fit_coefs_simple_model[, c(-4, -5)]
#	, file = sprintf('%s/%s_%s_simple_model.csv', outdir, bname, celltype)
#	, quote = FALSE
#	, sep = ","
#	, row.names = FALSE
#	)

write.table(
	fit_coefs_sample_model[, c(-4, -5)]
	, file = sprintf('%s/%s_%s_sample_model.csv', outdir, bname, celltype)
	, quote = FALSE
	, sep = ","
	, row.names = FALSE
	)


# Creating models
#treatment_time_models <- fit_models(cds, model_formula_str = "~ treatment + timepoint", verbose = TRUE, expression_family = "negbinomial")
#print('==> treatment time model')
#str(treatment_time_models)
#fit_coefs_treatment_time_models <- coefficient_table(treatment_time_models)
#print('==> fit coefs treatment time model')
#str(fit_coefs_treatment_time_models)
#time_models <- fit_models(cds, model_formula_str = "~ timepoint", expression_family = "negbinomial", verbose = TRUE)
#print('==> time model')
#str(time_models)
#fit_coefs_time_models <- coefficient_table(time_models)
#print('==> fit coefs time model')
#str(fit_coefs_time_models)
#compare_treatment <- compare_models(treatment_time_models, time_models)
#print('==> compare treatment')
#str(compare_treatment)

# Write tables
#write.table(
#	fit_coefs_treatment_time_models[, c(-4, -5)]
#	, file = sprintf('%s/%s_%s_treatment_time_models.csv', outdir, bname, celltype)
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
#write.table(
#	compare_treatment
#	, file = sprintf('%s/%s_%s_compare_treatment.csv', outdir, bname, celltype)
#	, quote = FALSE
#	, sep = ","
#	, row.names = FALSE)
