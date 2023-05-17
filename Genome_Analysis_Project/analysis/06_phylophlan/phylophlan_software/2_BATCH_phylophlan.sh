#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 10:00:00
#SBATCH -J Phylophlan_2_step
#SBATCH --mail-type=ALL
#SBATCH --mail-user alonso.lois.miguel@gmail.com

# Load modules
cd $SNIC_TMP

# Commands
export SRCDIR=$HOME

source $SRCDIR/.bashrc
​
# Loading modules
module load conda
export CONDA_ENVS_PATH=$SRCDIR/genome_analysis_test/envs
​
source activate phylophlan
​
# Create variables
outdir=$SRCDIR/2023_GA/GA_Project/01_analyses/07_phylogenetics/tmp_class
configs=$SRCDIR/genome_analysis_test/envs/configs
bins=$SRCDIR/2023_GA/GA_Project/01_analyses/02_binning
​
cd $outdir
phylophlan_metagenomic -i $outdir/input/metagenome -d SGB.Jul20


#!/bin/bash -l
#SBATCH -A uppmax2023-2-8 -M snowy
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 16:00:00
#SBATCH -J Phylophlan_Classification
#SBATCH --mail-user ioannis.alexopoulos.6549@student.uu.se
#SBATCH --mail-type=ALL

cat $0
echo USER = $USER
echo QOS = $SLURM_JOB_QOS
echo JOB = $SLURM_JOBID

source ~/.bashrc

# Loading modules
module load conda
export CONDA_ENVS_PATH=/domus/h1/iealexop/meta_omics_iii/envs

source activate phylophlan

# Create variables
outdir=/domus/h1/iealexop/meta_omics_iii/analyses/005_phylogeny
configs=/domus/h1/iealexop/meta_omics_iii/envs/configs
annotation=/domus/h1/iealexop/meta_omics_iii/data/annotation

cd $outdir

# Check that the configuration directory exists
if [ -d "/domus/h1/iealexop/meta_omics_iii/envs/phylophlan/lib/python3.11/site-packages/phylophlan/phylophlan_configs/" ]; then
    echo "The configuration directory exists."
else
    echo "The configuration directory does not exist!"
fi

# Run PhyloPhlAn with each temporary directory as input
phylophlan_metagenomic -i $outdir/input/metagenome/SRR4342129_assemble -d SGB.Jul20
phylophlan_metagenomic -i $outdir/input/metagenome/SRR4342133_assemble -d SGB.Jul20y

