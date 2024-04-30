import loompy

# hard-coded input files, will make into a pywrapper in the future

loom_files = [
"/storage/singlecell/maggie/ABCA4/velocytorun/D45_organoid_Sridhar/possorted_genome_bam_6HWH9.loom",
"/storage/singlecell/maggie/ABCA4/velocytorun/D60_organoid_Sridhar_1/possorted_genome_bam_WKSQU.loom",
"/storage/singlecell/maggie/ABCA4/velocytorun/D60_organoid_Sridhar_2/possorted_genome_bam_ZY6PA.loom",
"/storage/singlecell/maggie/ABCA4/velocytorun/D90_organoid_Sridhar/possorted_genome_bam_0PVRC.loom",
"/storage/singlecell/maggie/ABCA4/velocytorun/D104_organoid_Sridhar/possorted_genome_bam_QCJM0.loom",
"/storage/singlecell/maggie/ABCA4/velocytorun/D110_organoid_Sridhar/possorted_genome_bam_ZCH6Z.loom",
"/storage/singlecell/maggie/ABCA4/velocytorun/D205_organoid_Sridhar/possorted_genome_bam_8Z858.loom"
]
loompy.combine(
    loom_files,
    "/storage/chen/home/u244209/ABCA4/looms_merge/tomreh_combined.loom",
)
