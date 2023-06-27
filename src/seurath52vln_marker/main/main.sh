#!/usr/bin/env bash
# vim: set noexpandtab tabstop=2:

f=/storage/chen/home/u244209/wrapper/src/seurath52marker/main/raw_feature_bc_matrix_biomarker.rds
bname=$(basename "$f" _biomarker.rds)
marker=/storage/chen/home/u244209/ABCA4/hs_marker.txt

# slurmtaco.sh -- ../seurath52vln.sh -b "$bname" -c "Rod" -m "$marker" -- "$f"
slurmtaco.sh -- ../seurath52vln_marker.sh -b "$bname" -c "Cone" -m "$marker" -- "$f"
# slurmtaco.sh -- ../seurath52vln.sh -b "$bname" -c "AC" -m "$marker" -- "$f"
# slurmtaco.sh -- ../seurath52vln.sh -b "$bname" -c "BC" -m "$marker" -- "$f"
# slurmtaco.sh -- ../seurath52vln.sh -b "$bname" -c "HC" -m "$marker" -- "$f"
# slurmtaco.sh -- ../seurath52vln.sh -b "$bname" -c "MG" -m "$marker" -- "$f"
# slurmtaco.sh -- ../seurath52vln.sh -b "$bname" -c "Astro" -m "$marker" -- "$f"
# slurmtaco.sh -- ../seurath52vln.sh -b "$bname" -c "Microglia" -m "$marker" -- "$f"
# slurmtaco.sh -- ../seurath52vln.sh -b "$bname" -c "RGC" -m "$marker" -- "$f"
# slurmtaco.sh -- ../seurath52vln.sh -b "$bname" -c "RPE" -m "$marker" -- "$f"
