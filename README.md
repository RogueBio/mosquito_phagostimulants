# Mosquito Data

## Introduction

Mosquito feeding is a combination of processes that are precisely regulated, guided by a hierarchy of stimuli influencing meal acceptance, ingestion, and digestion. The malaria parasite modulates feeding by stimulating mosquito probing and increasing blood meal size. In this study, firstly, we mechanistically dissect the roles of meal temperature, feeding mode and meal composition in shaping the feeding behaviour of Anopheles coluzzii, a major malaria vector, by measuring metrics of the mosquito gut and abdomen. We then explored the role of the Plasmodium-derived intermediate metabolite (E)-4-Hydroxy-3-methyl-but-2-enyl pyrophosphate (HMBPP) in the feeding behaviour of this mosquito by measuring meal size and distribution in the gut. Lastly, we explored the neuromodulatory pathways associated with phagostimulants such as ATP and HMBPP, and how they modulate the transcriptome of the mosquito gut. Our findings reveal that temperature acts as a primary trigger for meal acceptance and phagostimulation, regulating both blood and nectar feeding. We demonstrate that feeding mode dictates nectar acquisition efficiency, influencing how mosquitoes process and sort different meal types. Furthermore, we unpick the complex processes, governed by phagostimulants and other sensory cues, that determine diet destination. We also found that parasite-derived HMBPP and host-derived ATP modulate the expression of behavioural, physiological, and immune response genes in mosquito. By manipulating these feeding mechanisms, we propose an innovative approach: phagostimulant-enhanced feeding-killing traps, designed to exploit mosquito feeding preferences to disrupt malaria transmission. These mechanistic insights not only advance our understanding of mosquito feeding biology but also lay the foundation for precision-targeted, behaviour-driven mosquito control strategies. This research represents a potential paradigm shift in vector control, moving beyond conventional insecticidal approaches toward exploiting the mosquito’s own feeding circuitry. 

## Aims
- Determine transcriptional changes in the guts (midgut and crop) associated with mosquito feeding on minimum stimuli Mix Feeding Solution (MFS)
- Determine transcriptional changes in the gut(midgut and crop) associated with mosquito feeding on MFS and (E)-4-Hydroxy-3-methyl-but-2-enyl pyrophosphate (HMBPP) mix
- Determine transcriptional changes in the gut(midgut and crop) associated with mosquito feeding on MFS and ATP mix

- Determine transcriptional changes in the heads associated with mosquito feeding on minimum stimuli Mix Feeding Solution (MFS)
- Determine transcriptional changes in the heads associated with mosquito feeding on MFS and (E)-4-Hydroxy-3-methyl-but-2-enyl pyrophosphate (HMBPP) mix
- Determine transcriptional changes in the heads associated with mosquito feeding on MFS and ATP mix

Fed at 37°C at the start of the scotophase on a XX light phase, mosquitoes were mated and fed on day 5 after emerging

## Project Pipeline Overview

Raw Read Quality Control
➤ Tool: FastQC
➤ Purpose: Assess the quality of raw sequencing reads.

Read Trimming
➤ Tool: Trimmomatic 
➤ Purpose: Remove adapter sequences and low-quality bases.

Post-trimming Quality Control
➤ Tool: FastQC
➤ Purpose: Confirm improvement in read quality after trimming.

Transcriptome Alignment / Quantification
➤ Tool: Salmon
➤ Purpose: Quasi-mapping reads to the transcriptome and quantifying transcript abundance.

Gene-level Aggregation and Differential Expression Analysis
➤ Tools: tximport → DESeq2
➤ Purpose: Import transcript-level estimates and perform differential gene expression analysis.

## Data Organisation: Directory Structure and Scripts

```mosquito_phagostimulants/
├── FastQC_results/           # Quality reports for raw reads (FastQC output)
├── trimmed_reads/            # Trimmed FASTQ files (from Trimmomatic)
├── trimmed_fastqc_results/   # QC reports for trimmed reads (FastQC)
├── alignments/               # Quantification output (e.g., Salmon results)
├── logs/                     # Log files from trimming, alignment, etc.

git_repos/
├── Reference_genome/         # An. gambiae PEST genome/transcriptome (FASTA, GTF)
├── rnaseq_data/              # Raw data and RNA-seq processing scripts
│   ├── fastqc_array.sh             # Script to run FastQC on raw reads
│   ├── trimmomatic_array.sh        # Script for adapter trimming and quality filtering
│   └──  salmon_alignment.sh             # Script to quantify expression using Salmon 
  ```
  

## Metadata


 <pre> ```
   
   ``` </pre>

## Installation / Requirements

- `FastQC/0.12.1-Java-17`
- `Java/17.0.6`
- `Trimmomatic/0.39-Java-17`
- `R` (v4.2.0)
  - Packages: `DESeq2`, `tximport`, `pheatmap`, `ggplot2

## How to run
