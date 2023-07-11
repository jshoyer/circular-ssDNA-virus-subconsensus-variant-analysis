#!/bin/bash

#SBATCH --job-name=bwaCassava020

# Inputs:  FastQ.gz files from 010_cutadapt.sbatch
#          (define CUTADAPTDIR below),
#          and an indexed reference sequence from 015_index-reference-sequences.sbatch
#          (define FASTAREF below).
# Outputs: sorted and indexed BAM files, plus tables of read counts

#SBATCH --array=1-8
# 1-8 are Kibandameno samples (2 DNA conditions x 2 plants x 2 tech-reps)

#SBATCH --cpus-per-task=10
#SBATCH --mem=50000MB
#SBATCH --time=2:00:00

######################################################################

FASTAREF=acmv-v3-eacmcv-segs-phiX174-calcuv-Mesculenta_v7.0.fasta
CUTADAPTDIR="." # UPDATE_HERE, if desired
OUTDIR="." # UPDATE_HERE

######################################################################
# UPDATE_HERE if not using modules
module load bwa samtools

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

srun samtools depth ${library}.bam > ${library}_depth.txt
# Rather than running `samtools depth` directly
# I typically pull identical output from an mpileup file
# with a different job script.

######################################################################

module list
date +"%Y-%m-%d %H:%M"
