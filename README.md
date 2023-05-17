# Genome-Analysis
## PURPOSE OF THE STUDY
  To constrain the metabolic contributions from uncultivated groups in the nGOM during periods of low DO.

We start off with 2 sets of RNA sequences: **SRR4342137.1** & **SRR4342137.2** (taken from _D1_) and **SRR4342139.1** & **SRR4342139.2** (taken from _D3_); and 2 sets of DNA sequences: **SRR4342129.1** & **SRR4342129.2** (taken from _D1_) and **SRR4342133.1** & **SRR4342133.2** (taken from _D3_). These “.1” and “.2” refer to paired end reads and identify the respective forward and reverse.

## ASSESSMENT OF QUALITY
Although the DNA sequences had already undergone trimming, I employed FastQC to evaluate their quality. By running FastQC on the trimmed DNA sequences, insights into the quality of the bases, the length distribution of the sequences, and the presence of any overrepresented sequences were gained.

![image](https://github.com/maserez/Genome-Analysis/assets/129284184/9d4c03d7-87db-438c-a467-6a186e020757)
![image](https://github.com/maserez/Genome-Analysis/assets/129284184/9986c4ae-3586-4ef2-9a74-3cc518088459)

RNA sequences often contain quality-related issues such as adaptor contamination, contaminants, and low-quality bases. To address these concerns, I utilized FastQC to assess the quality of the raw RNA sequences. Running FastQC on these sequences allowed us to identify and characterize any existing quality-related problems, providing insights into potential preprocessing requirements for subsequent analysis steps.

![image](https://github.com/maserez/Genome-Analysis/assets/129284184/54d8b4d2-4b3f-4cb7-9122-e6f1378ab7b3) 
![image](https://github.com/maserez/Genome-Analysis/assets/129284184/f4c9c1e4-c093-4a43-850e-cb16f4107f8e)

## TRIMMING
Trimming is a crucial step of preprocessing that allows for the removal of adapter sequences (short DNA sequences introduced during library preparation to facilitate the sequencing process), standardize read length and increase quality overall. The raw RNA sequences were trimmed using Trimmomatic software by removing the adapter TruSeq3-PE, which was found following the original paper by Thrash to NCBI webpage. Trimmomatic also employs quality trimming algorithms to identify and remove bases with low-quality scores, ensuring that only high-quality bases are retained.

Following the trimming process, I performed a subsequent FastQC analysis to evaluate the impact of the trimming process on the quality of the data. By comparing the FastQC results before and after trimming, I was able to assess how the trimming process influenced the quality of the RNA sequences.

![image](https://github.com/maserez/Genome-Analysis/assets/129284184/347359b4-8af7-49f9-bc1e-2c6998d4bded)
![image](https://github.com/maserez/Genome-Analysis/assets/129284184/7efdef70-dfdc-4558-8765-47b963aaec05)

Comparing FastQC reports before and after trimming it becomes apparent that the overall quality of the RNA sequences improved significantly. While the raw sequences returned several “fail” and “warning” results: _[PASS]Basic Statistics, [FAIL]Per base sequence quality, [FAIL]Per tile sequence quality, [PASS]Per sequence quality scores, [WARNING]Per base sequence content, [WARNING]Per sequence GC content, [PASS]Per base N content, [PASS]Sequence Length Distribution, [WARNING]Sequence Duplication Levels, [FAIL]Overrepresented sequences, [FAIL]Adapter Content_, the trimmed sequences returned fewer “fail” messages: _[PASS]Basic Statistics, [PASS]Per base sequence quality, [WARNING]Per tile sequence quality, [PASS]Per sequence quality scores, [WARNING]Per base sequence content, [PASS]Per sequence GC content, [PASS]Per base N content, [WARNING]Sequence Length Distribution, [WARNING]Sequence Duplication Levels, [FAIL]Overrepresented sequences, [PASS]Adapter Content_.

## GENOME ASSEMBLY
Megahit was used for metagenomic assembly (meaning that it was performed on our DNA sequences). Megahit software that utilizes De Bruijn graph-based algorithms to assemble short DNA reads into longer contigs, thus allowing the representation of the original genomic sequences of the organisms present in each sample.

The output of megahit was divided into two assembles: SRR4342129 and SRR4342133, respectively.
The options used for this analysis, as recorded in options.json file, were:

![image](https://github.com/maserez/Genome-Analysis/assets/129284184/dfa42a7b-886a-4587-8220-c32f1c062c01)

* 	"min_contig_len": 200: This sets the minimum length of contigs that will be reported in the final output. Contigs shorter than this value will be discarded.
* 	"k_min": 21, "k_max": 141, "k_step": 10, "k_list": [21, 29, 39, 59, 79, 99, 119, 141], "auto_k": true: Size of the k-mers (short, overlapping fragments of the reads) used in the assembly process.
* 	"min_count": 2: This is the minimum abundance for a k-mer to be included in the graph.

Megahit output was:

![image](https://github.com/maserez/Genome-Analysis/assets/129284184/7fcddf75-dc32-48e1-9835-2b6996444672)

## BINNING
Binning works by clustering contigs into individual bins that represent distinct genomes. Metabat was employed for this purpose. Metabat’s software works by leveraging differential coverage signals and tetranucleotide frequency to identify genomic signatures specific to different organisms within the metagenomic dataset.

The input for my metabat BATCh script was the “.fa” file megahit produced for each assemble. The output of metabat was again divided into SRR4342129 and SRR4342133 assembles, one per site of sampling. Since D1 was oxic and D3 was hypoxic, it made sense to keep results (bins) separated, as it would make sense to expect different species in environments so dissimilar as these.

SRR4342129 resulted on 27 bins, while SRR4342133 resulted on 33 bins.

## COMPLETENESS AND CONTAMINATION
CheckM was used to evaluate the quality of the obtained MAGs, the output of which consists of an assessment of completeness and contamination. CheckM employs a set of single-copy marker genes to estimate the completeness of each genome, this serves as a measure of how much of the expected genome is present in the assembled contigs. CheckM also identifies potential contamination by comparing the presence of marker genes across multiple genomes within the dataset.

![image](https://github.com/maserez/Genome-Analysis/assets/129284184/db0c6ea2-d763-49ed-b889-26004ed786b6)
![image](https://github.com/maserez/Genome-Analysis/assets/129284184/3ec5282c-3158-4639-92fd-1015071f769c)

When inspecting bin_stats_ext.tsv file for **SRR4342129**: 
* Bin.13 = k__bacteria – low completeness value (8.62) and 0.0 contamination.
* Bin.10 = p__Euryarchaeota – 39,86 completeness and 2,4 contamination
* Bin.12 = k__bacteria - 'Completeness': 88.79310344827586, 'Contamination': 44.294670846394986
* Bin.11 = p__Euryarchaeota' - 'Completeness': 73.63076923076922, 'Contamination': 41.859649122807014
* Bin.17 = 'root' 'Completeness': 100.0, 'Contamination': 1077.9671717171718
* Bin.15 = k__Bacteria' - 'Completeness': 97.43589743589743, 'Contamination': 4.700854700854701
* Bin.18 = 'k__Bacteria' - 'Completeness': 81.70846394984326, 'Contamination': 53.234064785788924
* Bin.1 = 'k__Bacteria' - 'Completeness': 73.6415882967607, 'Contamination': 2.4033437826541273
* Bin.2 = 'k__Archaea' - 'Completeness': 94.33656957928804, 'Contamination': 132.51804829474733
* Bin.21= 'k__Archaea' - 'Completeness': 14.485981308411215, 'Contamination': 0.0
* Bin.20 = 'k__Bacteria' - 'Completeness': 94.01709401709402, 'Contamination': 4.131054131054131
* Bin.22 = 'k__Bacteria' - 'Completeness': 30.9547152194211, 'Contamination': 0.8403361344537815
* Bin.25 = 'k__Bacteria' - 'Completeness': 24.76489028213166, 'Contamination': 1.7241379310344827
* Bin.16 = 'k__Bacteria' - 'Completeness': 55.91615956727519, 'Contamination': 0.19157088122605362
* Bin.19 = 'p__Cyanobacteria' - 'Completeness': 79.81719367588934, 'Contamination': 1.0869565217391304
* Bin.3 = 'k__Bacteria' - 'Completeness': 18.96551724137931, 'Contamination': 0.0
* Bin.23 = 'k__Bacteria' - 'Completeness': 61.01942344335854, 'Contamination': 5.851619644723093
* Bin.24 = 'p__Proteobacteria' - 'Completeness': 70.25067750677506, 'Contamination': 37.59485094850948
* Bin.27 = 'k__Bacteria' - 'Completeness': 80.76923076923077, 'Contamination': 0.0
* Bin.7 = 'root' – 'Completeness': 0.0, 'Contamination': 0.0
* Bin.14 = 'k__Bacteria' - 'Completeness': 69.66666666666667, 'Contamination': 1.1111111111111112
* Bin.4 = 'p__Euryarchaeota' - 'Completeness': 71.6, 'Contamination': 0.0
* Bin.26 = 'k__Bacteria' - 'Completeness': 74.22705759419756, 'Contamination': 0.20898641588296762
* Bin.6 = 'o__Actinomycetales' - 'Completeness': 82.26512226512227, 'Contamination': 2.252252252252252
* Bin.9 = 'k__Archaea' - 'Completeness': 92.05607476635514, 'Contamination': 200.76683441169422
* Bin.5 = 'k__Bacteria' - 'Completeness': 70.49229317395408, 'Contamination': 3.0135262661214215
* Bin.8 = 'f__Rhodobacteraceae' - 'Completeness': 83.07653457653457, 'Contamination': 3.189754689754689

1. **High-quality bins**: Bin.15, Bin.20, and Bin.8 show high completeness and relatively low contamination, likely representing good quality genome assemblies.
2. **Moderate-quality bins**: Bin.12, Bin.11, and Bin.2 show high completeness but also high contamination. These bins may represent genomes that are mostly complete, but have some contamination that needs to be addressed.
3. **Low-quality bins**: Bin.13, Bin.7, and Bin.21 show low completeness. These bins might not have assembled well, or they could represent organisms for which CheckM doesn't have a good set of marker genes. I won’t be getting rid of these bins, since the very purpose of the study is to find and study species that haven’t been properly characterized in the past, which would give validity to my second guess.
4. **Potential issues**: Bin.17 stands out as having 100% completeness but also very high contamination (1077.97). This suggests that there may be a problem with this bin, such as multiple genomes being grouped together.

When inspecting bin_stats_ext.tsv file for **SRR4342133**:
* Bin.13 = 'root' - 'Completeness': 0.0, 'Contamination': 0.0
* Bin.14 = 'k__Bacteria' - 'Completeness': 32.94148380355277
* Bin.12 = 'k__Bacteria' - 'Completeness': 52.74527452745274, 'Contamination': 1.4851485148514851
* Bin.10 = 'p__Euryarchaeota' - 'Completeness': 72.18245614035088, 'Contamination': 25.22051282051282
* Bin.17 = 'root' - 'Completeness': 100.0, 'Contamination': 593.3291245791246
* Bin.18 = 'k__Bacteria' - 'Completeness': 24.45141065830721, 'Contamination': 0.6896551724137931
* Bin.15 = 'p__Bacteroidetes' - 'Completeness': 82.84126984126985, 'Contamination': 2.4761904761904763
* Bin.19 = 'k__Bacteria' - 'Completeness': 25.61128526645768, 'Contamination': 0.0
* Bin.16 = 'k__Bacteria' - 'Completeness': 100.0, 'Contamination': 120.18286311389758
* Bin.2 = 'k__Bacteria' - 'Completeness': 7.68025078369906, 'Contamination': 0.0
* Bin.11 = 'f__Rhodobacteraceae' - 'Completeness': 68.0844155844156, 'Contamination': 5.238095238095238
* Bin.21 = 'k__Bacteria' - 'Completeness': 62.38021238021238, 'Contamination': 7.051282051282051
* Bin.1 = 'c__Gammaproteobacteria' - 'Completeness': 86.7617245361653, 'Contamination': 2.5528169014084505
* Bin.20 = 'k__Bacteria' - 'Completeness': 98.27586206896552, 'Contamination': 92.31974921630095
* Bin.24 = 'p__Euryarchaeota' - 'Completeness': 64.8, 'Contamination': 4.933333333333333
* Bin.23 = 'o__Actinomycetales' - 'Completeness': 83.61647361647363, 'Contamination': 4.1763191763191765
* Bin.22 = 'k__Bacteria' - 'Completeness': 93.60639360639361, 'Contamination': 0.0
* Bin.26 = 'k__Bacteria' - 'Completeness': 96.55172413793103, 'Contamination': 46.9435736677116
* Bin.25 = 'c__Gammaproteobacteria' - 'Completeness': 48.85057471264368, 'Contamination': 8.71647509578544
* Bin.31 = 'root' - 'Completeness': 12.5, 'Contamination': 0.0
* Bine27 = 'p__Actinobacteria' - 'Completeness': 60.23193760262726, 'Contamination': 3.6206896551724137
* Bin.29 = 'k__Bacteria' - 'Completeness': 63.86138613861386, 'Contamination': 0.9900990099009901
* Bin.32 = 'k__Bacteria' - 'Completeness': 19.234360410831002, 'Contamination': 0.16806722689075632
* Bin.30 = 'p__Euryarchaeota' - 'Completeness': 73.70148448043186, 'Contamination': 0.8
* Bin.3 = 'k__Bacteria' - 'Completeness': 95.6255935422602, 'Contamination': 3.4188034188034186
* Bin.7 = 'root' - 'Completeness': 0.0, 'Contamination': 0.0,
* Bin.33 = 'k__Archaea' - 'Completeness': 78.75280059746079, 'Contamination': 48.13915857605178
* Bin.8 = 'root' - 'Completeness': 100.0, 'Contamination': 243.23442760942763
* Bin.4 = 'k__Bacteria' - 'Completeness': 91.20879120879121, 'Contamination': 0.0
* Bin.28 = 'k__Bacteria' - 'Completeness': 95.33468559837728, 'Contamination': 1.1494252873563218
* Bin.5 = 'f__Rhodobacteraceae' - 'Completeness': 62.81097496752449, 'Contamination': 14.320198793042245
* Bin.6 = 'k__Bacteria' - 'Completeness': 74.80381912430595, 'Contamination': 16.49763353617309
* Bin.9 = 'c__Gammaproteobacteria' - 'Completeness': 93.2636469221835, 'Contamination': 0.900116144018583

1. **High-quality bins**: Bin.1, Bin.3, Bin.23, and Bin.4 show high completeness and low contamination, likely representing good quality genome assemblies.
2. **Moderate-quality bins**: Bin.10, Bin.11, Bin.15, and Bin.24 show high completeness but also high contamination. These bins may represent genomes that are mostly complete but have some contamination that needs to be addressed.
3. **Low-quality bins**: Bin.13, Bin.7, and Bin.31 show low completeness.
4. **Potential issues**: Bin.8 and Bin.17 stand out as having 100% completeness but also very high contamination. This suggests that there may be a problem with these bins, such as multiple genomes being grouped together. These bins might need manual curation or a different binning approach.
5. **Bins with high completeness and high contamination**: Bins like Bin.16, Bin.20, and Bin.26 show high completeness and high contamination. These bins represent genomes that are mostly complete but have significant contamination.
6. **Bins with high contamination but moderate completeness**: Bin.33 and Bin.6 have high contamination but moderate completeness. 

Again, I won’t be getting rid of these bins, since the very purpose of the study is to find and study species that haven’t been properly characterized in the past.

## ANNOTATION
Functional annotation of the assembled sequences was done using Prokka, a software which has been designed for prokaryotic genomes. Prokka performs 3 distinct actions:

1.	_Gene prediction_: Prodigal software to identify open reading frames (ORFs) within the MAGs.
2.	_Protein Homology Search_: compares predicted protein sequences against various databases. 
3.	_Functional classification_: assigns functional annotations to the predicted genes based on the previous step. 

The input for Prokka were the “.fa” files obtained with metabat (one per bin). The output is once again divided into two assembles, SRR4342129 and SRR4342133, each consisting of 27 and 33 bins. Inside each bin, the following files can be found:

![image](https://github.com/maserez/Genome-Analysis/assets/129284184/09b37710-8dbc-4023-8f08-6b3367281b0d)

The functional annotations obtained from Prokka serve as a valuable resource for downstream analyses, including comparative genomics, metabolic pathway reconstruction, and gene expression quantification.

## ALIGNMENT OF SEQUENCES
This step involves mapping the sequences read back to the reference genome. BWA (Burrows-Wheeler Aligner) was employed for this step. The input for BWA were the “.fa” files produced by metabat (one per bin) along with the fastq.gz files of the trimmed RNA sequences. The output is a collection of “.bam”, “.bai” and .”stats” files: one per bin, with different bins per assembly.

![image](https://github.com/maserez/Genome-Analysis/assets/129284184/59a99107-8ad7-4035-b74a-e6484516fb45)

When inspecting the “.stats” file, there are 4 columns (1st column: identifier, 2nd column: sequence length, 3rd column: number of reads mapped to the corresponding sequences, 4th column: number of reads that have multiple alignments). For most bins, a majority of sequences had non-zero length, implying that BWA was able to map the reads to the reference genome and calculate the sequence lengths. However, a significant number of sequences have zero or very few mapped reads. This suggests that a large portion of my input data didn’t align to these regions of the reference genome. Considering there are from 27 to 33 bins per assemble, each of which is being mapped against the whole reference genome, I would say these results are not too bad.

![image](https://github.com/maserez/Genome-Analysis/assets/129284184/ad8adc02-5d5b-4459-bde0-41b67db074ce)

## QUANTIFICATION OF GENE EXPRESSION
HTSeq was used for quantifying Gene Expression Levels. After the preprocessing steps that included quality control, adapter trimming, and the mapping of the reads in which the preprocessed RNA-seq reads where aligned to the MAGs using BWA, Htseq was employed to count the number of reads aligning to each gene. It utilized the alignment files generated in the previous step and assigned each read to its corresponding gene feature. The resulting counts serve as a measure of gene expression levels.

The input files for HTSeq were “.gff” files corresponding to each bin from prokka’s output, and bam files from the previously run bwa analysis. The output is one file named “htseq_counts.txt” per each bin. Still, there are different sets of bins for assembles SRR4342129 and SRR4342133. When inspecting these files, the following data is stored:

![image](https://github.com/maserez/Genome-Analysis/assets/129284184/96afe6a6-ca0c-4797-9689-5eb73947e155)

From these text files we can run an R script by merging all of them into a csv count_matrix.csv (getting rid of summary at the end). All differentially expressed genes will represent potential adaptations of these microbial communities to low DO environments, providing insights into their strategies for survival and maintenance of metabolic activities.

![80dd2490-d447-42a1-8893-1f730d01da06](https://github.com/maserez/Genome-Analysis/assets/129284184/00c85067-f7b4-47d2-bc25-4599f982e8e3)

Most of the genes are not being expressed by most bins, however some of these bins are highly expressed and if we were to move forward in our analyses those would be the ones we would care about.


## PHYLOGENY
In addition to gene expression analysis, a phylogenetic analysis was performed to investigate the evolutionary relationships between the microbial organisms present in the ¡ samples. PhyloPhlan was employed for this purpose. It utilizes a set of marker genes present in the genomes of different organisms to construct a phylogenetic tree that shows their evolutionary relationships.

The genomes assembled from the metagenomic data served as the foundation for PhyloPhlan analysis, specifically, the “.faa” files from Prokka, which contain the protein sequences predicted from the genome. Phylophlan also takes a configuration file named “supermatrix_aa.cfg” as input. This file is used to determine how to process the protein sequences and construct the phylogenetic tree. 

For assemble SRR4342129 the following tree was obtained:

![image](https://github.com/maserez/Genome-Analysis/assets/129284184/d8c97e4f-a82b-423a-80a4-b08c1ed285f1)

For assembles SRR4342133:

![image](https://github.com/maserez/Genome-Analysis/assets/129284184/3e47f6df-5861-4ebd-87ec-cd01166627e4)

