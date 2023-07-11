#!/bin/bash

#SBATCH --job-name=bwaTomato020

#SBATCH --array=1-24
# 24 samples from tomato and whiteflies.
# Virion preps from whiteflies (1 to 6)
# have neglible virus-mapping reads.

#SBATCH --cpus-per-task=10
#SBATCH --mem=50000MB
#SBATCH --time=2:00:00

######################################################################

FASTAREF=tomato4-MEAM1-tomov3-tylcv-acmv-eacmcv-segs-phiX174-calcuv.fasta
# UPDATE_HERE if you want input or output in another directory:
CUTADAPTDIR="."
OUTDIR="."

######################################################################
module purge
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

cd $OUTDIR
pwd

srun bwa mem -t 9 \
     $OUTDIR/$FASTAREF \
     ${CUTADAPTDIR}/${library}_R1_trimmed.fastq.gz \
     ${CUTADAPTDIR}/${library}_R2_trimmed.fastq.gz |
    samtools sort -o ${library}.bam
srun samtools index   ${library}.bam

## drop secondary alignments:
srun samtools view -h -F 2048 ${library}.bam \
                   -b -o ${library}_unique.bam
srun samtools index   ${library}_unique.bam

srun samtools idxstats ${library}_unique.bam \
    > ${library}_unique_idxstats.tsv

srun samtools flagstat ${library}.bam > ${library}_flagstat.txt
srun samtools stats   ${library}.bam > ${library}_stats.txt

srun samtools depth ${library}.bam > ${library}_depth.txt
# Rather than running `samtools depth` directly
# I typically pull identical output from an mpileup file
# with a different job script.

######################################################################

module list
date +"%Y-%m-%d %H:%M"
