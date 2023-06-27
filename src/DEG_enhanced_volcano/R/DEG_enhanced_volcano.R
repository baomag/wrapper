library(dplyr)
library(monocle3)
library(Seurat)
library(ggplot2)
library(EnhancedVolcano)

# Input: infile (csv table containing columns for variable names, fold change/slope, and p-value)
# Output: enhanced volcano plot

# read table
mydf = read.csv(infile, header = TRUE)

# plot heatmap and store it
p = EnhancedVolcano(mydf, lab = 'gene_id', x = 'treatmentcontrol', y = 'p_value', xlab = "Fold Change")
ggsave(p, filename = sprintf('%s/%s_enhanced_volcano.png', outdir, bname))

