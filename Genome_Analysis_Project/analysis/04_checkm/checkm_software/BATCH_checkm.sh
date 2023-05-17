#!/bin/bash -l
#SBATCH -A uppmax2023-2-8 -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 15:00:00
#SBATCH -J CheckM
#SBATCH --mail-user alonso.lois.miguel@gmail.com
#SBATCH --mail-type=ALL

cat $0
echo USER = $USER
echo QOS = $SLURM_JOB_QOS
echo JOB = $SLURM_JOBID

module load bioinfo-tools
module load CheckM

#filepaths
fa_path="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/03_metabat/metabat_results"
out_path="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/04_checkm/checkm_results"

# Running CheckM
for dir in ${fa_path}; do
  checkm lineage_wf -t 4 --reduced_tree -x fa "${input_folder}" "${output_folder}"
done
