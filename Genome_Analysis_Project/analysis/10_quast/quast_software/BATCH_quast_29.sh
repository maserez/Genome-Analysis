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
fa_path="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/03_metabat/metabat_results"
out_path="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/04_quast/quast_results"

# Create a temporary directory
temp_dir=$(mktemp -d -t quast-XXXXX)

# Copy all .fa files to the temporary directory
find $fa_path -name "*.fa" -exec cp {} $temp_dir \;

QUAST_HOME=/sw/bioinfo/quast/5.0.2/snowy/bin


python $QUAST_HOME/metaquast.py $SRCDIR/$DATA -o /domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/10_quast -t 2 --max-ref-number 0

# Running metaQUAST for all bins
python $QUAST_HOME/metaquast.py $temp_dir -o "${out_path}/global_stats" -t 2 --max-ref-number 0

# Remove the temporary directory
rm -rf $temp_dir

