#!/bin/bash

#SBATCH --job-name=snpEff


#SBATCH --array=3-5,9-11
# 14 libraries total.
# 3-5,9-11 -- mutant inoculum.

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=500MB
#SBATCH --time=00:05:00   # HH:MM:SS

##########################################

module use /projects/community/modulefiles
module purge
module load java
# I guess this is not even strictly necessary:
module load snpEff

SNPEFF_JAR=snpEff.jar

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

java -jar $SNPEFF_JAR \
     -c snpEff.config CabLCV_mutagenized ${library}_varscan-snp.vcf.tsv \
     -no-downstream  -no-intergenic  -no-upstream \
     -stats ${library} \
     > ${library}_snp.ann.vcf.tsv
java -jar $SNPEFF_JAR \
     -c snpEff.config CabLCV_mutagenized ${library}_varscan-indel.vcf.tsv \
     -no-downstream  -no-intergenic  -no-upstream \
     -stats ${library} \
     > ${library}_indel.ann.vcf.tsv
# https://pcingola.github.io/SnpEff/se_outputsummary

######################################################################

module list
date +"%Y-%m-%d %H:%M"
