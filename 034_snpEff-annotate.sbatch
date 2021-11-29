#!/bin/bash

#SBATCH --job-name=snpEff


#SBATCH --array=3-5,9-11
# 14 libraries total.
# 3-5,9-11 -- mutant inoculum.

#SBATCH --partition=main
#SBATCH --requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1            # Cores per task (>1 if multithread tasks)
#SBATCH --mem=500MB
#SBATCH --time=00:05:00              # Total run time limit (HH:MM:SS)

# Directory for log files must exist:
#SBATCH --output=slurm-logs/job%j.node%n.%N.index%a
#Remove space to get STDERR in a separate file.
#V
# SBATCH  --error=slurm-logs/job%j.node%n.%N.index%a.err
#SBATCH --export=ALL
#SBATCH --mail-type=ALL
##########################################
#SBATCH --mail-user=UPDATE_HERE
##########################################

date +"%Y-%m-%d %H:%M"
hostname

module use /projects/community/modulefiles
module purge
module load java
# I guess this is not even strictly necessary:
module load snpEff
module list

fossil sha3 $(pwd)/034D_snpEff-annotate_mutagenized.sbatch
OUTPUT_DIR=$(pwd)
pwd

########################################

echo This is task $SLURM_ARRAY_TASK_ID
pwd
libindex=$SLURM_ARRAY_TASK_ID

#source 000_config.sh
# Defines $TRIMMED_READS_DIR

cd $TRIMMED_READS_DIR
pwd
#R1FILES=( $(ls *_R1_adapter.fastq.gz) )
libcodearray=( $(ls *_R1_adapter.fastq.gz | sed 's/_R1_adapter.fastq.gz//') )
library=${libcodearray[libindex-1]}
echo $library

cd $OUTPUT_DIR
pwd

###################################################
# Prerequisite: build database with 033_ job script

java -jar /projects/community/snpEff/snpEff.jar \
     -c snpEff.config CabLCV_mutagenized ${library}_varscan-snp.vcf.tsv \
     -no-downstream  -no-intergenic  -no-upstream \
     -stats ${library} \
     > ${library}_snp.ann.vcf.tsv
java -jar /projects/community/snpEff/snpEff.jar \
     -c snpEff.config CabLCV_mutagenized ${library}_varscan-indel.vcf.tsv \
     -no-downstream  -no-intergenic  -no-upstream \
     -stats ${library} \
     > ${library}_indel.ann.vcf.tsv
# https://pcingola.github.io/SnpEff/se_outputsummary

######################################################################

module list
date +"%Y-%m-%d %H:%M"
