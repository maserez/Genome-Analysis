#!/bin/bash -l
#SBATCH -A uppmax2023-2-8 -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 09:00:00
#SBATCH -J conda_setting
#SBATCH --mail-user alonso.lois.miguel@gmail.com
#SBATCH --mail-type=ALL

cat $0
echo USER = $USER
echo QOS = $SLURM_JOB_QOS
echo JOB = $SLURM_JOBID

# Setting up a conda environment to use phylophlan

mkdir ~/genome_analysis_test/envs

module load conda
export CONDA_ENVS_PATH=~/genome_analysis_test/envs
conda create -n "phylophlan" -c bioconda phylophlan=3.0

mkdir ~/genome_analysis_test/envs/configs

source activate phylophlan
phylophlan_write_default_configs.sh ~/genome_analysis_test/envs/configs
source deactivate

