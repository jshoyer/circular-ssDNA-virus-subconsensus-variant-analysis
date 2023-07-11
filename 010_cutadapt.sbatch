#!/bin/bash

#SBATCH --job-name=cutadaptMiSeq2020

# Inputs:  a directory of FastQ.gz files -- raw reads
# Outputs: FastQ.gz files -- trimmed adapter-parsed reads
#          plus FastQC reports (HTML).

# Dependencies:
#     Cutadapt 1.16 or similar (see below)

#SBATCH --array=1-24
# 24 samples from tomato and whiteflies

#SBATCH --mem=500MB
#SBATCH --time=0:30:00

######################################################################

CUTADAPTDIR="." # UPDATE_HERE, if you want input and output elsewhere
module load FastQC
libindex=$SLURM_ARRAY_TASK_ID
FASTQDIR="." # UPDATE_HERE

cd $FASTQDIR
pwd
INPUTFASTQR1=( $(ls *_R1.fastq.gz) )
OUTPREFIX=( $(ls *_R1.fastq.gz | sed 's/_R1.fastq.gz//') )

cd $CUTADAPTDIR
pwd

# See Illumina adapter sequences document.
# Reverse complement of the Nextera Transposase Adapters.
srun cutadapt\
     --nextseq-trim=20\
     -a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC \
     -A CTGTCTCTTATACACATCTGACGCTGCCGACGA \
     -q 30\
     -o ${OUTPREFIX[$libindex-1]}_R1_trimmed.fastq.gz\
     -p ${OUTPREFIX[$libindex-1]}_R2_trimmed.fastq.gz\
     ${FASTQDIR}/${INPUTFASTQR1[libindex-1]}\
     ${FASTQDIR}/${OUTPREFIX[libindex-1]}_R2.fastq.gz\
     > ${OUTPREFIX[$libindex-1]}_cutadapt-report.txt

#####################################################

fastqc ${OUTPREFIX[$libindex-1]}_R1_trimmed.fastq.gz\
       ${OUTPREFIX[$libindex-1]}_R2_trimmed.fastq.gz

######################################################################

module list
date +"%Y-%m-%d %H:%M"
