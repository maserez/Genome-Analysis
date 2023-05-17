#!/bin/bash -l
#SBATCH -A uppmax2023-2-8 -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 10:00:00
#SBATCH -J Megahit_DNA
#SBATCH --mail-user alonso.lois.miguel@gmail.com
#SBATCH --mail-type=ALL

cat $0
echo USER = $USER
echo QOS = $SLURM_JOB_QOS
echo JOB = $SLURM_JOBID

module load bioinfo-tools
module load megahit

#filepaths
input_dir="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/data/trimmed_data/DNA_trimmed"
output_dir="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/02_megahit/DNA_megahit"

for forward_file in "${input_dir}"/*_1.paired.trimmed.fastq.gz; do
        file_basename=$(basename "$forward_file" _1.paired.trimmed.fastq.gz)
        reverse_file="${input_dir}/${file_basename}_2.paired.trimmed.fastq.gz"
        output_file="${output_dir}/${file_basename}_assemble"

megahit -1 "${forward_file}" -2 "${reverse_file}" -o "${output_file}" --kmin-1pass
done

