#!/bin/bash -l
#SBATCH -A uppmax2023-2-8 -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 15:00:00
#SBATCH -J QUAST
#SBATCH --mail-user alonso.lois.miguel@gmail.com
#SBATCH --mail-type=ALL

cat $0
echo USER = $USER
echo QOS = $SLURM_JOB_QOS
echo JOB = $SLURM_JOBID

module load bioinfo-tools
module load quast

#filepaths
fa_path="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/03_metabat/metabat_results/try_final/SRR4342133_assemble"
out_path="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/10_quast/quast_results_33"

# Running QUAST
for dir in ${fa_path}/*; do
  base=$(basename "$dir" .fa)
  quast.py -o "${out_path}/${base}" -t 4 "$dir"
done

