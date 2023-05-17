#!/bin/bash -l
#SBATCH -A uppmax2023-2-8 -M snowy
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 16:00:00
#SBATCH -J Prokka
#SBATCH --mail-user alonso.lois.miguel@gmail.com
#SBATCH --mail-type=ALL

cat $0
echo USER = $USER
echo QOS = $SLURM_JOB_QOS
echo JOB = $SLURM_JOBID

module load bioinfo-tools
module load prokka/1.45-5b58020

#filepaths
fa_path="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/03_metabat/try_final"
out_path="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/05_prokka/prokka_results"

for dir in ${fa_path}/*assemble; do

  dir_name=$(basename ${dir})
  out_dir="${out_path}/${dir_name}"
  mkdir -p ${out_dir}

  for input_file in ${dir}/*.fa; do

    file_basename=$(basename ${input_file} .fa)
    file_out_dir="${out_dir}/${file_basename}"
    mkdir -p ${file_out_dir}
    prokka --force --outdir ${file_out_dir} --prefix ${file_basename}_anno ${input_file}

  done
done
