#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 10:00:00
#SBATCH -J Bwa
#SBATCH --mail-type=ALL
#SBATCH --mail-user alonso.lois.miguel@gmail.com

# Load modules
cd $SNIC_TMP
module load bioinfo-tools
module load bwa/0.7.17
module load samtools/1.14

# Commands
export SRCDIR=/home/mial5254/Genome-Analysis/Genome_Analysis_Project
DNA_path=/analysis/03_metabat/metabat_results/try_final/SRR4342133_assemble
RNA_path=/analysis/01_preprocessing/fastqc_trim/RNA_trim
cd $SNIC_TMP
cp $SRCDIR$DNA_path/*.fa .
n=0
for i in *.fa;
do

n=$((n+1))
base=$(basename $i .fa)
bwa index $i

# SRR4342139
bwa mem -t 2 $i \
$SRCDIR$RNA_path/SRR4342139.1_paired_trimmed.fastq.gz \
$SRCDIR$RNA_path/SRR4342139.2_paired_trimmed.fastq.gz \
| samtools view -b - | samtools sort -o map_SRR4342139_${base}.bam -
samtools index map_SRR4342139_${base}.bam
samtools idxstats map_SRR4342139_${base}.bam > map_SRR4342139_${base}.stats
echo "DONE $i and $n"

cp map*${base}* $SRCDIR/analysis/07_bwa/bwa_results_33_39

done

