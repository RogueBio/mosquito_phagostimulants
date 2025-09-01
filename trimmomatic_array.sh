#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=02:00:00
#SBATCH --array=0-191
#SBATCH --job-name=trimmomatic_array
#SBATCH --output=/home/ar9416e/mosquito_sex/trimmed_reads/trim_%A_%a.log

# Load required modules
module load Java/17.0.6
module load Trimmomatic/0.39-Java-17

# Adapter file 
adapter_file="/home/ar9416e/git_repos/Illumina_adapters/illumina_adapters_trimmomatic.fa"

# Check adapter file exists
if [[ ! -f "$adapter_file" ]]; then
  echo "Error: Adapter file not found at $adapter_file"
  exit 1
fi

# Setup directories
raw_data_dir="/home/ar9416e/mosquito_phagostimulants/trimmed_reads/trimmed_poly_tails"
output_dir="/home/ar9416e/mosquito_sex/trimmed_reads/trimmomatic_reads"
mkdir -p "$output_dir"

# Find all R1 and R2 fastq.gz files
R1_files=($(find "$raw_data_dir" -type f -name '*R1_*.fastq.gz' ! -name '._*' | sort))
R2_files=($(find "$raw_data_dir" -type f -name '*R2_*.fastq.gz' ! -name '._*' | sort))


# Debug info
echo "Number of R1 files: ${#R1_files[@]}"
echo "Number of R2 files: ${#R2_files[@]}"

# Get file for this array index
R1=${R1_files[$SLURM_ARRAY_TASK_ID]}
R2=${R2_files[$SLURM_ARRAY_TASK_ID]}

echo "SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "R1: $R1"
echo "R2: $R2"

# Extract safe base name (e.g., UH-3040-1-1vf-p_S13_L001)
base=$(basename "$R1" | sed 's/_R1_.*.fastq.gz//')
base_trimmed="${base}_trimmed"

# Define output file paths
output_R1_paired="${output_dir}/${base_trimmed}_R1_paired.fastq.gz"
output_R1_unpaired="${output_dir}/${base_trimmed}_R1_unpaired.fastq.gz"
output_R2_paired="${output_dir}/${base_trimmed}_R2_paired.fastq.gz"
output_R2_unpaired="${output_dir}/${base_trimmed}_R2_unpaired.fastq.gz"
trim_log="${output_dir}/${base_trimmed}_trim_log.txt"

# Skip if already done and non-empty
if [[ -s "$output_R1_paired" && -s "$output_R2_paired" ]]; then
  echo "Output already exists for $base, skipping."
  exit 0
fi

# Run Trimmomatic
echo "Running Trimmomatic for sample: $base"

java -jar /opt/software/eb/software/Trimmomatic/0.39-Java-17/trimmomatic-0.39.jar \
  PE \
  -threads 4 \
  -phred33 \
  "$R1" "$R2" \
  "$output_R1_paired" "$output_R1_unpaired" \
  "$output_R2_paired" "$output_R2_unpaired" \
  ILLUMINACLIP:"$adapter_file":2:30:10 \
  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 \
  -trimlog "$trim_log"

# Check success
if [[ $? -eq 0 ]]; then
  echo " Trimmomatic completed for $base"
else
  echo " Trimmomatic failed for $base"
  exit 1
fi

# Post-trimming sanity check
if [[ ! -s "$output_R1_paired" || ! -s "$output_R2_paired" ]]; then
  echo " Warning: Output paired files are empty for $base"
fi

# Optional: Print summary of reads trimmed
echo "Trimming summary:"
grep 'Input Read' "$trim_log" || echo "No summary found."
