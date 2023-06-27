args <- commandArgs(trailingOnly = TRUE)
input_path <- args[1]
input_meta <- args[2]
output_results_path <- args[3]

library(ArchR)
library(parallel)
library(stringi)
set.seed(1)
setwd(input_path)
library(BSgenome.Hsapiens.UCSC.hg38)

# prepare to import atac-seq data
addArchRGenome("hg38")
addArchRThreads(threads = 20)

projorganoid1 <- loadArchRProject("Save-projorganoid1")

projorganoid2 <- filterDoublets(projorganoid1)

cells <- getCellNames(projorganoid2)
meta.data <- read.csv(input_meta)
rownames(meta.data) <- meta.data$X
meta.data$X2 <- stri_replace_last(rownames(meta.data), fixed = "_", "#")
# code to be changed based on cell type
meta.data$scpred_prediction <- plyr::mapvalues(meta.data$majorclass, from = c("AC Precursor", "BC Precursor", "Cone Precursor", "GABAergic", "HC0",
		"NRPC", "OFF-BC", "ON-BC", "PRPC", "RGC Precursor", "Rod Precursor"), 
	to = c("AC", "BC", "Cone", "AC", "HC", "RPC", "BC", "BC", "RPC", "RGC", "Rod"))

common_cells <- intersect(cells, meta.data$X2)

projorganoid3 <- subsetArchRProject(projorganoid2, cells = common_cells, force = TRUE)
rownames(meta.data) <- meta.data$X2
for (col in colnames(meta.data)) {
	    projorganoid3@cellColData[, col] <- meta.data[rownames(projorganoid3@cellColData), col]
}
write.table(projorganoid3@cellColData, paste(output_results_path, "projorganoid3_cellColData.csv", sep = ""))

# add an Iterative LSI-based dimensionality reduction to an
# ArchRProject
projorganoid3 <- addIterativeLSI(ArchRProj = projorganoid3, useMatrix = "TileMatrix",
	    name = "IterativeLSI", iterations = 2, clusterParams = list(resolution = c(0.2),
				        sampleCells = 10000, n.start = 10), varFeatures = 25000, dimsToUse = 1:30,
			    force = T)

# add cluster information to an ArchRProject
projorganoid3 <- addClusters(input = projorganoid3, reducedDims = "IterativeLSI",
	    method = "Seurat", name = "Clusters", resolution = 0.8, force = T)

# add a UMAP embedding of a reduced dimensions object to an
# ArchRProject
projorganoid3 <- addUMAP(ArchRProj = projorganoid3, reducedDims = "IterativeLSI",
	    name = "UMAP", nNeighbors = 30, minDist = 0.5, metric = "cosine", force = T)

addArchRThreads(threads = 1)
projorganoid3 <- addGroupCoverages(ArchRProj = projorganoid3, groupBy = "scpred_prediction",
	    threads = 1)
addArchRThreads(threads = 20)

pathToMacs2 <- findMacs2()
projorganoid3 <- addReproduciblePeakSet(ArchRProj = projorganoid3, groupBy = "scpred_prediction",
	    pathToMacs2 = pathToMacs2)
# Add a Peak Matrix to the ArrowFiles of an ArchRProject
projorganoid3 <- addPeakMatrix(projorganoid3)

saveArchRProject(ArchRProj = projorganoid2, outputDirectory = "Save-projorganoid2",
	    load = FALSE)

saveArchRProject(ArchRProj = projorganoid3, outputDirectory = "Save-projorganoid3",
	    load = FALSE)

