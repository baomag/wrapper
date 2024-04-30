library(Seurat)
library(ggplot2)

# input: merged data 
# nfeatures = 2000
# output: ridgeplot and dimplot, RDS of seurat object with cell cycle score added

abca4=readRDS(infile, refhook = NULL)

s.genes <- cc.genes$s.genes
g2m.genes <- cc.genes$g2m.genes

# Data preprocessing
abca4 = NormalizeData(abca4)
abca4=FindVariableFeatures(abca4, selection.method = "vst", nfeatures = nfeatures)
abca4 <- ScaleData(abca4, features = rownames(abca4))

# Assign cell cycle scores
abca4 = CellCycleScoring(abca4, s.features = s.genes, g2m.features = g2m.genes, set.ident = TRUE)
head(abca4[[]])

# Visualize cell cycle markers
p = RidgePlot(abca4, features = c("PCNA", "TOP2A", "MCM6", "MKI67", "TMPO","HMGB2","KIF20B","CTCF"), ncol = 2)
ggsave(p, filename = sprintf('%s/%s_cell_cycle_ridgeplot.png', outdir, bname), height=height, width=width)

# Run PCA on cell cycle genes to see how much do cells seperate by cell cycles
#abca4 <- RunPCA(abca4, features = c(s.genes, g2m.genes))
#p = DimPlot(abca4)
#ggsave(p, filename = sprintf('%s/%s_cell_cycle_dimplot.png', outdir, bname), height=height, width=width)

# Save object
#saveRDS(abca4, file=sprintf('%s/%s_cell_cycle.rds', outdir, bname))
