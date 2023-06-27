#!/bin/bash
#SBATCH --job-name=tmp.fOdEB4DSSg
#SBATCH --partition=short
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=10G
#SBATCH --time=12:00:00
#SBATCH -o out_slurm/tmp.fOdEB4DSSg-%j.out
#SBATCH -e out_slurm/tmp.fOdEB4DSSg-%j.err

start=$(date +%s)
echo "starting at $(date) on $(hostname)"

# Print the SLURM job ID.
echo "SLURM_JOBID=$SLURM_JOBID"

# Run the application
../seurath52celltype_table.sh -d /storage/singlecell/maggie/wrapper/src/seurath52celltype_table/main -b 10x3v31_Organoid_NHDF_D261 -- /storage/singlecell/maggie/ABCA4/seurath52name/10x3v31_Organoid_NHDF_D261.rds

end=$(date +%s)
echo "ended at $(date) on $(hostname). Time elapsed: $(date -u -d @$((end-start)) +'%H:%M:%S')"
exit 0
