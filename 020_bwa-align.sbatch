#!/bin/bash

#SBATCH --job-name=bwa_UPDATE_HERE

# Inputs:  FastQ.gz files from 010_cutadapt.sbatch
#          (define CUTADAPTDIR below),
#          and an indexed reference sequence from 015_index-reference-sequences.sbatch
#          (define FASTAREF below).
# Outputs: sorted and indexed BAM files, plus tables of read counts

#SBATCH --partition=main

#SBATCH --array=UPDATE_HERE

#SBATCH --cpus-per-task=10
#SBATCH --mem=50000MB
#SBATCH --time=2:00:00

#SBATCH --requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --export=ALL

# Directory for log files must exist for this job script to work
#                    V
#SBATCH --output=slurm-logs/job%j.node%n.%N.index%a.out
#SBATCH  --error=slurm-logs/job%j.node%n.%N.index%a.err
#SBATCH --mail-type=ALL
################################
#SBATCH --mail-user=UPDATE_HERE
######################################################################

FASTAREF=UPDATE_HERE
CUTADAPTDIR=UPDATE_HERE
OUTDIR=UPDATE_HERE

######################################################################
date +"%Y-%m-%d %H:%M"
module purge
module load bwa samtools
module list
hostname

echo This is task $SLURM_ARRAY_TASK_ID

libindex=$SLURM_ARRAY_TASK_ID
######################################################################

cd $CUTADAPTDIR
pwd
R1FILES=( $(ls *_R1_trimmed.fastq.gz) )
libcodearray=( $(ls *_R1_trimmed.fastq.gz | sed 's/_R1_trimmed.fastq.gz//') )

libcode=${libcodearray[libindex-1]}

#mkdir $OUTDIR
cd $OUTDIR
pwd

srun bwa mem -t 9 \
     $FASTAREF \
     ${CUTADAPTDIR}/${libcode}_R1_trimmed.fastq.gz \
     ${CUTADAPTDIR}/${libcode}_R2_trimmed.fastq.gz |
    samtools sort -o ${libcode}_bwa_sorted.bam
srun samtools index   ${libcode}_bwa_sorted.bam

## drop secondary alignments:
srun samtools view -h -F 2048 ${libcode}_bwa_sorted.bam \
                   -b -o ${libcode}_bwa_unique.bam
srun samtools index   ${libcode}_bwa_unique.bam

srun samtools idxstats ${libcode}_bwa_unique.bam \
    > ${libcode}_idxstats.tsv

srun samtools flagstat ${libcode}_bwa.bam > ${libcode}_flagstat.txt
srun samtools stats   ${libcode}_bwa.bam > ${libcode}_stats.txt

######################################################################
module list
date +"%Y-%m-%d %H:%M"
