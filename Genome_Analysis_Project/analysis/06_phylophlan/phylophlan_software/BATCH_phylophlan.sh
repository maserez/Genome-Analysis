#!/bin/bash -l
#SBATCH -A uppmax2023-2-8 -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 15:00:00
#SBATCH -J Phylophlan
#SBATCH --mail-user alonso.lois.miguel@gmail.com
#SBATCH --mail-type=ALL

cat $0
echo USER = $USER
echo QOS = $SLURM_JOB_QOS
echo JOB = $SLURM_JOBID
source ~/.bashrc

# Loading modules
module load conda
export CONDA_ENVS_PATH=~/genome_analysis_test/envs
source activate phylophlan

# Create variables
outdir=/home/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/06_phylophlan/phylophlan_results
configs=~/genome_analysis_test/envs/configs
annotation=/home/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/05_prokka/assemble_29
# Create directories
mkdir -p $outdir/input/metagenome

# Copy input data files
for bin in ${annotation}/*;
do
  cp ${bin}/*.faa $outdir/input/metagenome/
done

cd $outdir

phylophlan -i input/metagenome -d phylophlan --diversity high -f $configs/supermatrix_aa.cfg

