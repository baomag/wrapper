#!/usr/bin/env bash
# vim: set noexpandtab tabstop=2:

f=/storage/chen/home/u244209/ABCA4/wrapper/seurath52marker/main/raw_feature_bc_matrix_biomarker.rds
bname=$(basename "$f" _biomarker.rds)
marker=/storage/chen/home/u244209/ABCA4/hs_marker.txt

# Rod
slurmtaco.sh -- ../seurath52feature.sh -b "$bname" -c "Rod" -m "$marker" -- "$f"
