#!/bin/bash -l
#SBATCH -A uppmax2023-2-8 -M snowy
#SBATCH -p core
#SBATCH -n 14
#SBATCH -t 15:00:00
#SBATCH -J Htseq
#SBATCH --mail-user alonso.lois.miguel@gmail.com
#SBATCH --mail-type=ALL

cat $0
echo USER = $USER
echo QOS = $SLURM_JOB_QOS
echo JOB = $SLURM_JOBID

#load any required modules
module load bioinfo-tools htseq samtools

#filepaths
gff_path="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/05_prokka/assemble_33/"
bam_path="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/07_bwa/bwa_results_33_39/"
out_path="/domus/h1/mial5254/Genome-Analysis/Genome_Analysis_Project/analysis/08_htseq/htseq_results_1"

#temporary directory for preprocessed GFF files
tmp_gff_path="/tmp/${USER}_gff"
mkdir -p ${tmp_gff_path}

#loop through the bins
for bin in {1..33}
do
    gff_dir="SRR33_final.contigs_bin.${bin}"
    echo "Processing ${gff_dir}"

    #define the input files
    gff_file="${gff_path}/${gff_dir}/*.gff"
    processed_gff_file="${tmp_gff_path}/processed_bin_${bin}.gff"

    # Preprocess GFF file
    sed '/^##FASTA/Q' ${gff_file} > ${processed_gff_file}

    bam_file="${bam_path}/map_SRR4342139_final.contigs_bin.${bin}.bam"

    #define the output directory
    bin_out_dir="${out_path}/${gff_dir}"
    mkdir -p ${bin_out_dir}

    #define the output file
    output_file="${bin_out_dir}/htseq_counts.txt"

    #run htseq-count
    htseq-count -f bam -r pos -i ID -t CDS ${bam_file} ${processed_gff_file} > ${output_file}
done

# Remove temporary GFF directory
rm -r ${tmp_gff_path}

echo "HTSeq analysis completed."

