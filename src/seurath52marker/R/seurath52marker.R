library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# input: infile (/storage/chen/home/u244209/ABCA4/wrapper/seurath52cluster/main/raw_feature_bc_matrix_clustering.rds)
# parameter: nTop
# output: top10 table, RDS

abca4 <- readRDS(infile)

# Find Cluster Biomarkers
abca4.markers <- FindAllMarkers(abca4, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.5)
abca4.markers %>%
  group_by(cluster) %>%
  slice_max(n = 2, order_by = avg_log2FC)
  abca4.markers %>%
    group_by(cluster) %>%
    top_n(n = nTop, wt = avg_log2FC) -> top10

# save top10 as table
    write.table(top10, file=sprintf('%s/%s_top10.txt', outdir, bname), quote=T, sep='\t', row.names=F, col.names=T)

# finding biomarkers
saveRDS(abca4, file=sprintf('%s/%s_biomarker.rds', outdir, bname))
#saveRDS(top10, file=sprintf('%s/%s_top10.rds', outdir, bname))
