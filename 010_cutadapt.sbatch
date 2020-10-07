#!/bin/bash

#SBATCH --job-name=cutadapt_Plasmid

# Inputs:  a directory of FastQ.gz files -- raw reads
# Outputs: FastQ.gz files -- trimmed adaptor-parsed reads

# Dependencies:
#     Cutadapt 1.16 or similar
#     fastQC

#SBATCH --partition=main
#SBATCH --requeue

#SBATCH --array=1-12

#SBATCH --nodes=1
#SBATCH --ntasks=1                  # Total # of tasks across all nodes
#SBATCH --cpus-per-task=1           # Cores per task (>1 if multithread tasks)
#SBATCH --mem=500                  # Real memory (RAM) required (MB)
#SBATCH --time=0:30:00              # Total run time limit (HH:MM:SS)

# Directory for log files MUST exist before running this job script.
#                V
#SBATCH --output=slurm-logs/job%j.node%n.%N.index%a.out
#SBATCH --error=slurm-logs/job%j.node%n.%N.index%a.err
#SBATCH --export=ALL
#SBATCH --mail-type=ALL
#########################################
#SBATCH --mail-user=UPDATE_HERE

######################################################################

date +"%Y-%m-%d %H:%M"

CUTADAPTDIR="."

module purge
module load FastQC
module list  # 

echo This is task $SLURM_ARRAY_TASK_ID

######################################################################

libindex=$SLURM_ARRAY_TASK_ID

FASTQDIR="."
cd $FASTQDIR
pwd
INPUTFASTQR1=( $(ls *_R1.fastq.gz) )
OUTPREFIX=( $(ls *_R1.fastq.gz | sed 's/_R1.fastq.gz//') )

cd $CUTADAPTDIR
pwd

srun cutadapt\
     --nextseq-trim=20\
     -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
     -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
     -q 30\
     -o ${OUTPREFIX[$libindex-1]}_R1_trimmed.fastq.gz\
     -p ${OUTPREFIX[$libindex-1]}_R2_trimmed.fastq.gz\
     ${FASTQDIR}/${INPUTFASTQR1[libindex-1]}\
     ${FASTQDIR}/${OUTPREFIX[libindex-1]}_R2.fastq.gz\
     > ${OUTPREFIX[$libindex-1]}_cutadapt-report.txt

#####################################################

fastqc ${OUTPREFIX[$libindex-1]}_R1_trimmed.fastq.gz\
       ${OUTPREFIX[$libindex-1]}_R2_trimmed.fastq.gz

# Compare metrics for the untrimmed reads, if you like.
#cd $FASTQDIR
#fastqc ${OUTPREFIX[$libindex-1]}_R1.fastq.gz\
#       ${OUTPREFIX[$libindex-1]}_R2.fastq.gz

######################################################################

module list
date +"%Y-%m-%d %H:%M"
