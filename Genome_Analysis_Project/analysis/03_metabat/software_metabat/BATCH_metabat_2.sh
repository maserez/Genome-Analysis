#!/bin/bash -l
#SBATCH -A uppmax2023-2-8 -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J Metabat
#SBATCH --mail-user alonso.lois.miguel@gmail.com
#SBATCH --mail-type=ALL

cat $0
echo USER = $USER
echo QOS = $SLURM_JOB_QOS
echo JOB = $SLURM_JOBID

module load bioinfo-tools
module load MetaBat/2.12.1

#filepaths
fa_path_2="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/02_megahit/DNA_megahit/SRR4342133_assemble/final.contigs.fa"
out_path="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/03_metabat/metabat_results/SRR4342133_assemble/"

#running metabat
output_prefix_2="${out_path}/$(basename ${fa_path_2})"
metabat2 -i "${fa_path_2}" -o "${output_prefix_2}"

