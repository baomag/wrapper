#!/bin/bash
#SBATCH --job-name=tmp.zM3JNt5Zuj
#SBATCH --partition=short
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=2G
#SBATCH --time=12:00:00
#SBATCH -o out_slurm/tmp.zM3JNt5Zuj-%j.out
#SBATCH -e out_slurm/tmp.zM3JNt5Zuj-%j.err

start=$(date +%s)
echo "starting at $(date) on $(hostname)"

# Print the SLURM job ID.
echo "SLURM_JOBID=$SLURM_JOBID"

# Run the application
../seurath52feature.sh -b raw_feature_bc_matrix -c Rod -m /storage/chen/home/u244209/ABCA4/hs_marker.txt -- /storage/chen/home/u244209/ABCA4/wrapper/seurath52marker/main/raw_feature_bc_matrix_biomarker.rds

end=$(date +%s)
echo "ended at $(date) on $(hostname). Time elapsed: $(date -u -d @$((end-start)) +'%H:%M:%S')"
exit 0
