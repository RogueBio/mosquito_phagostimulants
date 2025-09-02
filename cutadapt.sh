#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --job-name=trim_polyA
#SBATCH --output=/home/ar9416e/mosquito_phagostimulants/logs/cutadapt_logs/cutadapt_%A_%a.log

#SBATCH --array=0-46

# Load Cutadapt
module load cutadapt/4.2-GCCcore-11.3.0

# Directories
input_dir="
/home/ar9416e/mosquito_phagostimulants/raw_data/raw_files"
output_dir="/home/ar9416e/mosquito_phagostimulants/trimmed_reads/trimmed_cutadapt"
mkdir -p "$output_dir"
mkdir -p logs

# Collect input files
R1_files=($(find "$input_dir" -type f -name '*_1.fq.gz' | sort))
R2_files=($(find "$input_dir" -type f -name '*_2.fq.gz' | sort))

# Select file based on SLURM_ARRAY_TASK_ID
R1=${R1_files[$SLURM_ARRAY_TASK_ID]}
R2=${R2_files[$SLURM_ARRAY_TASK_ID]}

# Extract base sample name (e.g., UJ-3092-25-1B)
sample_name=$(basename "$R1" _1.fq.gz)

# Construct output filenames
R1_out="${output_dir}/${sample_name}_cut_1.fq.gz"
R2_out="${output_dir}/${sample_name}_cut_2.fq.gz"

# Output paths
R1_out="${output_dir}/${cut_base_R1}.fastq.gz"
R2_out="${output_dir}/${cut_base_R2}.fastq.gz"

# Run Cutadapt to remove polyA/T/C/G tails
echo "Processing ${sample_name}"
cutadapt \
  -a "A{20}" -a "C{20}" \
  -A "T{20}" -A "G{20}" \
  -m 20 \
  -o "$R1_out" \
  -p "$R2_out" \
  "$R1" "$R2"

# Check result
if [[ $? -eq 0 ]]; then
  echo "PolyA/T trimming done for ${sample_name}"
else
  echo "Cutadapt failed for ${sample_name}"
  exit 1
fi
