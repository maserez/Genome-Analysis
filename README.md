## Data divided into:
  # Oxic - D1:
    SRR4342129 - metagenomics (DNA)
    SRR4342137 - metatranscriptomics (RNA)
  # Hypoxic - D3
    SRR4342133 - metagenomics (DNA)
    SRR4342139 - metatranscriptomics (RNA)
            
  ## Data origins:   
    Six samples representing hypoxic (n = 4) and oxic (n = 2) dissolved oxygen (DO) concentrations were picked from among those
    previously reported (https://ami-journals.onlinelibrary.wiley.com/doi/10.1111/1462-2920.12853) at stations D1, D2, D3, E2, E2A,
    and E4. In the case of this study, we will focuse exlusively on D1 and D3. The samples have been categorized according to their oxygen content.
    Hypoxic samples, such as D1, contain very low levels of oxygen, whereas oxic samples, like D3, are characterized by the presence of ample or
    normal levels of oxygen. This difference in oxygen levels significantly impacts the characteristics and behaviors of the organisms within these samples.
  
## What would be the main steps you need to take?
1. Quality control of the trimmed DNA sequences as well as the raw (untrimmed) RNA sequences
2. Trimming raw RNA sequences: cleaning up raw RNA sequence data (unwanted sequences such as adapters, low-quality bases, and undetermined bases) to ensure accuracy in the downstream analysis.
3. Quality control of the trimmed RNA sequences and comparison between the trimmed and the untrimmed results.
4. Assembly of the already trimmed metagenomic (DNA) data: processed DNA sequences are assembled into longer contiguous sequences named contigs - helps in reconstructing the original genomic sequences of the organisms present in the sample.
5. Binning:grouping assembled sequences (contigs) into sets that belong to the same genome based on various characteristics such as coverage pattern...
6. Completeness and contamination analysis: assessing the quality of the assembled genomes. Completeness checks how much of the expected genome is present in the assembled sequences. Contamination analysis identifies any sequences that might have originated from different genomes.
7. Functional annotation of the assembled sequences:  predicting and assigning biological functions to the genes present in the assembled sequences. Includes the identification of coding sequences, rRNA, tRNA, and other functional elements.
8. Alignment of sequences: sequenced reads are mapped back to the assembled contigs or reference genome. Allows for the identification of the location of each read in the genome, which can be used for various downstream analyses (gene expression).
9. Quantification of gene expression: number of reads that map to each gene in a genome is counted - measure of that gene's expression level. Allows for the study of how the functional activity of organisms vary under different conditions.
10. Phylogenetic analysis:  constructing a phylogenetic tree that shows the evolutionary relationships between the organisms present in the samples.

##Proposed software
        # (1 & 3) FastQC -> https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
        # (2) Trimmomatic -> http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf
        # (3) Megahit -> https://github.com/voutcn/megahit
        # (4) Metbat -> https://bitbucket.org/berkeleylab/metabat/wiki/Home
        # (5) CheckM for binning evaluation -> https://github.com/Ecogenomics/CheckM/wiki/Quick-Start
        # (6) Prokka  -> https://github.com/tseemann/prokka#invoking-prokka
        # (7) Bwa -> http://bio-bwa.sourceforge.net/bwa.shtml
          #SAMtools / BCFtools for post-mapping analyses
        # (8) HTseq -> https://htseq.readthedocs.io/en/release_0.9.1/count.html#count
        # (9) Phylophlan -> https://github.com/biobakery/phylophlan/wiki 
        
## Estimated duration of analysis
    # FastQC - 15 min
    # Trimmomatic ~
    # Metabat - 30 min 
    # CheckM - 2 hours
    # Quast - 45 min
    # Prokka - 1 hour
    # PhyloPhlan - 6 hours
    # BWA - 4-6 hours
    # Htseq ~

    
## DATA MANAGEMENT PLAN
    # Data and code separated.
    # Data files should have unique and informative names in the format: XXX_name_name when required. Read files named as their SRA accessions.
    # There should be a README file per folder, explaining what's it used for 
    # Datafiles, specially big data files, should be compressed. UPPMAX directory can store up to 32 Gb.
    
      # genome_analyses/
        analyses
          01_preprocessing
            trimming_software
              conditionA.trim.fast1.gz -> ../.../.../...
              conditionB.trim.fast1.gz -> ../.../.../...
            fastqc_raw
              fastqc_report.txt
            fastqc_trim
              fastqc_report.txt
          02_megahit #genome assembly
            megahit_software
            megahit_results
          03_metabar #binning
            metabat_software
            metabat_results
          04_checkm #completness and contamination
            checkm_software
            checkm_results
          05_prokka #annotation
            prokka_software
            prokka_results
          06_phylophlan #phylogeny
            phylophlan_software
            phylophlan_results
          07_bwa #mapping
            bwa_software
            bwa_results
          08_htseq #gene expression
            htseq_software
            htseq_results
       
