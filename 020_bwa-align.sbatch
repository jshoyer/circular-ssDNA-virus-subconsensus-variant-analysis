#!/bin/bash

#SBATCH --job-name=bwa_UPDATE_HERE

# Inputs:  FastQ.gz files from 010_cutadapt.sbatch
#          (define CUTADAPTDIR below),
#          and an indexed reference sequence from 015_index-reference-sequences.sbatch
#          (define FASTAREF below).
# Outputs: sorted and indexed BAM files, plus tables of read counts

#SBATCH --array=UPDATE_HERE

#SBATCH --cpus-per-task=10
#SBATCH --mem=50000MB
#SBATCH --time=2:00:00

######################################################################

FASTAREF=UPDATE_HERE
CUTADAPTDIR="." # UPDATE_HERE, if desired
OUTDIR="." # UPDATE_HERE

######################################################################

module load bwa samtools
module list

echo This is task $SLURM_ARRAY_TASK_ID

libindex=$SLURM_ARRAY_TASK_ID
######################################################################

cd $CUTADAPTDIR
pwd
R1FILES=( $(ls *_R1_trimmed.fastq.gz) )
libcodearray=( $(ls *_R1_trimmed.fastq.gz | sed 's/_R1_trimmed.fastq.gz//') )

library=${libcodearray[libindex-1]}

#mkdir $OUTDIR
cd $OUTDIR
pwd

srun bwa mem -t 9 \
     $FASTAREF \
     ${CUTADAPTDIR}/${library}_R1_trimmed.fastq.gz \
     ${CUTADAPTDIR}/${library}_R2_trimmed.fastq.gz |
    samtools sort -o ${library}.bam
srun samtools index   ${library}.bam

## drop secondary alignments:
srun samtools view -h -F 2048 ${library}.bam \
                   -b -o ${library}_unique.bam
srun samtools index   ${library}_unique.bam

srun samtools idxstats ${library}_unique.bam \
    > ${library}_idxstats.tsv

srun samtools flagstat ${library}.bam > ${library}_flagstat.txt
srun samtools stats   ${library}.bam > ${library}_stats.txt

#srun samtools depth ${library}.bam > ${library}_depth.txt
# Rather than running `samtools depth` directly
# I typically pull identical output from an mpileup file
# in next job script.

######################################################################

module list
date +"%Y-%m-%d %H:%M"
