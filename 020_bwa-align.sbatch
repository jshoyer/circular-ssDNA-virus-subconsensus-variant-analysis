#!/bin/bash

#SBATCH --job-name=bwa_CabLCV

# Inputs:  FastQ.gz files from 010_cutadapt.sbatch
#          (define CUTADAPTDIR below),
#          and an indexed reference sequence from 015_index-reference-sequences.sbatch
#          (define FASTAREF below).
# Outputs: sorted and indexed BAM files, plus tables of read counts

#SBATCH --array=3-5,9-11
# 14 libraries total.
# #14 is mutagenized plasmid (pNSB1101).
# #12 is parental DNA-A plasmid.
# #1, 2, and 6-8 were inoculated with WT virus.
# #3-5 and 9-11  were inoculated with mutagenized virus.

#SBATCH --cpus-per-task=10
#SBATCH --mem=50000MB
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1

#SBATCH --output=job%j_%x_node%n.%N.index%a.out
#SBATCH --error=job%j_%x_node%n.%N.index%a.err  # optional
######################################################################

#FASTAREF=cablcv-plasmid-plus-phix174-plus-E-coli-DH10-CP001637.fasta  # B.
FASTAREF=viruses-mutagenized-cablcv-plus-phix174-plus-Athaliana-tair10.fasta

CUTADAPTDIR="."
OUTDIR="."

######################################################################

module purge
module load bwa samtools
module list
hostname

echo This is task $SLURM_ARRAY_TASK_ID

libindex=$SLURM_ARRAY_TASK_ID

######################################################################

cd $CUTADAPTDIR
#pwd
R1FILES=( $(ls *_R1_trimmed.fastq.gz) )
libcodearray=( $(ls *_R1_trimmed.fastq.gz | sed 's/_R1_trimmed.fastq.gz//') )

libcode=${libcodearray[libindex-1]}

cd $OUTDIR
pwd

srun bwa mem -t 9 \
     $FASTAREF \
     ${CUTADAPTDIR}/${libcode}_R1_trimmed.fastq.gz \
     ${CUTADAPTDIR}/${libcode}_R2_trimmed.fastq.gz |
    samtools sort -o ${libcode}.bam
srun samtools index   ${libcode}.bam

## drop secondary alignments:
srun samtools view -h -F 2048 ${libcode}.bam \
                   -b -o ${libcode}_unique.bam
srun samtools index   ${libcode}_unique.bam

srun samtools idxstats ${libcode}_unique.bam \
    > ${libcode}_unique_idxstats.tsv

srun samtools flagstat ${libcode}.bam > ${libcode}_flagstat.txt
srun samtools stats   ${libcode}.bam > ${libcode}_stats.txt
#srun samtools depth  ${libcode}.bam > ${libcode}_depth.txt

######################################################################

module list
date +"%Y-%m-%d %H:%M"
