#!/bin/bash

#SBATCH --job-name=cutadapt_CabLCV

# Inputs:  a directory of FastQ.gz files -- raw reads
# Outputs: FastQ.gz files -- trimmed adapter-parsed reads

#SBATCH --array=1-11
# This job script is for the infected plant samples --
# plasmid reads are trimmed with a seperate job script.
# (Note that the DNA-B plasmid has Nextera adapter sequences.)


#SBATCH --nodes=1
#SBATCH --ntasks=1                  # Total # of tasks across all nodes
#SBATCH --cpus-per-task=1           # Cores per task (>1 if multithread tasks)
#SBATCH --mem=500MB
#SBATCH --time=0:30:00

#SBATCH --output=job%j_%x_node%n.%N.index%a.out
#SBATCH --error=job%j_%x_node%n.%N.index%a.err  # optional
#SBATCH --export=ALL

######################################################################

# Change this (and FASTQDIR_1, below)
# if you want input or output in a different directory.
CUTADAPTDIR="."

echo This is task $SLURM_ARRAY_TASK_ID
libindex=$SLURM_ARRAY_TASK_ID

module load FastQC

FASTQDIR_1="."
#cd $FASTQDIR_1
pwd

## Fully qualified paths:
INPUTFASTQR1=( $(ls ${FASTQDIR_1}/*_R1.fastq.gz) )
OUTPREFIX=( $(ls *_R1.fastq.gz | sed 's/_R1.fastq.gz//') )
INPUTFASTQR2_single=$( echo ${INPUTFASTQR1[$libindex-1]} | sed 's/_R1/_R2/')

cd $CUTADAPTDIR
pwd

srun cutadapt\
     --nextseq-trim=20\
     -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC \
     -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT \
     -q 30\
     -o ${OUTPREFIX[$libindex-1]}_R1_trimmed.fastq.gz\
     -p ${OUTPREFIX[$libindex-1]}_R2_trimmed.fastq.gz\
     ${INPUTFASTQR1[libindex-1]}\
     $INPUTFASTQR2_single \
     > ${OUTPREFIX[$libindex-1]}_cutadapt-report.txt

#####################################################

fastqc ${OUTPREFIX[$libindex-1]}_R1_trimmed.fastq.gz\
       ${OUTPREFIX[$libindex-1]}_R2_trimmed.fastq.gz

######################################################################

module list
date +"%Y-%m-%d %H:%M"
