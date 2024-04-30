args <- commandArgs(trailingOnly = TRUE)

library(monocle3)
library(Seurat)
library(dplyr)

cds <- readRDS(infile)

# create simple model
simple_model <- fit_models(cds, model_formula_str = "~treatment")
fit_coefs_simple_model <- coefficient_table(simple_model)
write.table(
	fit_coefs_simple_model[, c(-4, -5)]
	, file = sprintf('%s/%s_%s_simple_model.csv', outdir, bname, celltype)
	, quote = FALSE
	, sep = ","
	, row.names = FALSE
	)

# Creating models
treatment_pseudotime_models <- fit_models(cds, model_formula_str = "~ treatment + pseudotime", verbose = TRUE, expression_family = "negbinomial")
fit_coefs_treatment_pseudotime_models <- coefficient_table(treatment_pseudotime_models)
print('==> fit coefs treatment pseudotime model')
str(fit_coefs_treatment_pseudotime_models)
pseudotime_models <- fit_models(cds, model_formula_str = "~ pseudotime", expression_family = "negbinomial", verbose = TRUE)
print('==> pseudotime model')
str(pseudotime_models)
fit_coefs_pseudotime_models <- coefficient_table(pseudotime_models)
print('==> fit coefs pseudotime model')
str(fit_coefs_pseudotime_models)
compare_treatment <- compare_models(treatment_pseudotime_models, pseudotime_models)
print('==> compare treatment')
str(compare_treatment)

# Write tables
write.table(
	fit_coefs_treatment_pseudotime_models[, c(-4, -5)]
	, file = sprintf('%s/%s_%s_treatment_pseudotime_models.csv', outdir, bname, celltype)
	, quote = FALSE
	, sep = ","
	, row.names = FALSE
	)
write.table(
	fit_coefs_pseudotime_models[, c(-4, -5)]
	, file = sprintf('%s/%s_%s_pseudotime_models.csv', outdir, bname, celltype)
	, quote = FALSE, sep = ","
	, row.names = FALSE
	)
write.table(
	compare_treatment
	, file = sprintf('%s/%s_%s_compare_treatment.csv', outdir, bname, celltype)
	, quote = FALSE
	, sep = ","
	, row.names = FALSE)
