#!/bin/bash -l
#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 08:00:00
#SBATCH -J Trimmomatic_RNA
#SBATCH --mail-user alonso.lois.miguel@gmail.com
#SBATCH --mail-type=ALL

cat $0
echo USER = $USER
echo QOS = $SLURM_JOB_QOS
echo JOB = $SLURM_JOBID

module load bioinfo-tools
module load java
module load trimmomatic

#filepaths
input_dir="/proj/genomeanalysis2023/Genome_Analysis/3_Thrash_2017/RNA_untrimmed/"
output_dir="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/01_preprocessing/fastqc_trim/"

#Running trimmomatic
for input_file_R1 in "${input_dir}"/*.1.fastq.gz; do
  input_file_R2=$(echo "$input_file_R1" | sed 's/\.1\.fastq\.gz/\.2.fastq.gz/')
  file_basename=$(basename "$input_file_R1" .1.fastq.gz)
  output_file_R1_paired="${output_dir}/${file_basename}.1_paired_trimmed.fastq.gz"
  output_file_R1_unpaired="${output_dir}/${file_basename}.1_unpaired_trimmed.fastq.gz"
  output_file_R2_paired="${output_dir}/${file_basename}.2_paired_trimmed.fastq.gz"
  output_file_R2_unpaired="${output_dir}/${file_basename}.2_unpaired_trimmed.fastq.gz"

  trimmomatic PE -threads 4 -phred33 \
    "$input_file_R1" \
    "$input_file_R2" \
    "$output_file_R1_paired" \
    "$output_file_R1_unpaired" \
    "$output_file_R2_paired" \
    "$output_file_R2_unpaired" \
    ILLUMINACLIP:/sw/bioinfo/trimmomatic/0.39/snowy/adapters/TruSeq3-PE.fa:2:30:10 \
    LEADING:3 \
    TRAILING:3 \
    SLIDINGWINDOW:4:15 \
    MINLEN:36
done

