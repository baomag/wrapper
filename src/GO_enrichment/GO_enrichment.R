DEGs.marker_fetalRPE_PG_fibroblast.rds
DEGs_PG_fibroblast_foveal.vs.PG_fibroblast_nasal.csv
[sangbaek@mhgcp-h00 test_GOpathway]$ vi run_GOpathwayFromDEGs.R
source("/storage/chen/data_share_folder/22_10x_hs_AnteriorSegment_data/scAtacQC/Retina_function_cellmarker.R",encoding="UTF-8")
source("/storage/chen/data_share_folder/22_10x_hs_AnteriorSegment_data/scAtacQC/Rsrc_tidytree.R")

# load library
library(Seurat)
library(dplyr)
library(Matrix)
library(ggplot2)
library(reticulate)
library(cowplot)
library(ggrepel)

library(ensembldb);library(AnnotationDbi);library(org.Hs.eg.db);library(biomaRt)
library(EnsDb.Hsapiens.v86);library(rentrez);library(clusterProfiler);library(ReactomePA)
library(DOSE);library(msigdbr);library(enrichplot);library(cowplot);library(ggupset)


# get parameters
args = commandArgs(trailingOnly=TRUE)
print(args)
if (length(args)!=2) {
  stop("please type 2 parameters:input DEG rds file(w/path), prefix: data_title", call.=FALSE)
} else {
  # default output file
  finrds <- args[1]
  prefix <- args[2]
}

if(F){
  finrds<-"/storage/singlecell/sangbaek/307_10xscRNA_RPE/18_celltype_scAnno/out_5_markers_downsample.1k/out_1_DEG_byCelltype_byRegion_2/out_DEGs_bySubset_fetalRPE/DEGs.marker_fetalRPE_Fibroblast.rds"
  prefix<-"DEG_fibroblast"
}

# output dir
dirOut <- setDir(dirIn=getwd(),dirOut=paste0("out_geneEnrichment_DEGs_",prefix))

# Read deg
degT <-readRDS(finrds)
degT$gene <-rownames(degT)
head(degT)
#bName <- tools::file_path_sans_ext(fin1)
#sTitle <- bName


# draw volcano plot
setwd(dirOut)
RunVolcanoPlot2(DEGout = degT, fcvalue = 1, adjpValue = 0.01,prefix = prefix,dirOut)


# GOpathway
runGOpathwayanalysis(dirIn=dirOut, dirOut, finrds=degT, prefix='rpe', fc.cutoff=1,padj.cutoff =0.01)



print("Process was done!")






