#!/bin/bash

#SBATCH --job-name=cutadapt_UPDATE_HERE

# Inputs:  a directory of FastQ.gz files -- raw reads
# Outputs: FastQ.gz files -- trimmed adaptor-parsed reads

# Dependencies:
#     Cutadapt 1.16 or similar

#SBATCH --partition=main
#SBATCH --requeue

#SBATCH --array=UPDATE_HERE

#SBATCH --nodes=1
#SBATCH --ntasks=1                  # Total # of tasks across all nodes
#SBATCH --cpus-per-task=1           # Cores per task (>1 if multithread tasks)
#SBATCH --mem=500MB
#SBATCH --time=2:30:00

#SBATCH --output=job%j_%x_node%n.%N.index%a.out
#SBATCH --error=job%j_%x_node%n.%N.index%a.err  # optional
#SBATCH --export=ALL

######################################################################

CUTADAPTDIR=UPDATE_HERE

date +"%Y-%m-%d %H:%M"
hostname

echo This is task $SLURM_ARRAY_TASK_ID

module purge
module load FastQC
module list

######################################################################

libindex=$SLURM_ARRAY_TASK_ID

FASTQDIR=UPDATE_HERE

cd $FASTQDIR
pwd
INPUTFASTQR1=( $(ls *_R1_001.fastq.gz) )
OUTPREFIX=( $(ls *_R1_001.fastq.gz | sed 's/_R1_001.fastq.gz//') )

cd $CUTADAPTDIR
pwd

srun cutadapt\
     --nextseq-trim=20\
     # UPDATE_HERE if necessary:
     -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC \
     -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT \
     -q 30\
     -o ${OUTPREFIX[$libindex-1]}_R1_trimmed.fastq.gz\
     -p ${OUTPREFIX[$libindex-1]}_R2_trimmed.fastq.gz\
     ${FASTQDIR}/${INPUTFASTQR1[libindex-1]}\
     ${FASTQDIR}/${OUTPREFIX[libindex-1]}_R2_001.fastq.gz\
     > ${OUTPREFIX[$libindex-1]}_cutadapt-report.txt

#####################################################

fastqc ${OUTPREFIX[$libindex-1]}_R1_trimmed.fastq.gz\
       ${OUTPREFIX[$libindex-1]}_R2_trimmed.fastq.gz

######################################################################

module list
date +"%Y-%m-%d %H:%M"
