#!/usr/bin/env bash
# vim: set noexpandtab tabstop=2:

f=/storage/singlecell/maggie/ABCA4/seurath52name/10x3v31_Organoid_NHDF_D261.rds
outdir=$(mrrdir.sh)
bname=$(basename "$f" .rds)
slurmtaco.sh -m 10G -- ../seurath52celltype_table.sh -d "$outdir" -b "$bname" -- "$f"
