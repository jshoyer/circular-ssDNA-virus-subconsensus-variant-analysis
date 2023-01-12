#!/bin/bash

#SBATCH --job-name=bwa_CabLCV

# Inputs:  FastQ.gz files from 010_cutadapt.sbatch
#          (define CUTADAPTDIR below),
#          and an indexed reference sequence from 015_index-reference-sequences.sbatch
#          (define FASTAREF below).
# Outputs: sorted and indexed BAM files, plus tables of read counts


######################################################################

#SBATCH --partition=main

#SBATCH --array=3-5,9-11
# 14 libraries total.
# #14 is mutagenized plasmid (pNSB1101).
# #12 is parental DNA-A plasmid.
# #1, 2, and 6-8 were inoculated with WT virus.
# #3-5 and 9-11  were inoculated with mutagenized virus.

#SBATCH --cpus-per-task=10
#SBATCH --mem=50000MB
#SBATCH --time=2:00:00

#SBATCH --requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --export=ALL

#SBATCH --output=job%j_%x_node%n.%N.index%a.out
#SBATCH --error=job%j_%x_node%n.%N.index%a.err  # optional
######################################################################

# Prerequisite:
# sbatch 01_ script to trim reads -- see below for directory.
#        01_index-reference-sequences-calcuv.sbatch

#FASTAREF=cablcv-plus-phix174-plus-Athaliana-tair10.fasta
#FASTAREF=cablcv-plasmid-plus-phix174-plus-E-coli-DH10-CP001637.fasta  # B.
#FASTAREF=cablcv-mutant-plasmid-plus-phix174-plus-E-coli-DH10.fasta   # C.
FASTAREF=mutagenized-cablcv-plus-phix174-plus-Athaliana-tair10.fasta

# use proper cutadapt-trimmed reads:
#CUTADAPTDIR=/projects/f_deenr_1/duffy-nsf-pire/results/2019-04-30_calcuv
# I copied the files from the preceding directory to this one:
CUTADAPTDIR=/projects/f_deenr_1/duffy-nsf-pire/results/2019-11-17_cablcv
# Therefore the files are in the current directory
# and we could dispense with the $CUTADAPTDIR variable.
# However, it is easier to keep it, for now.

# Previously:
#FASTQDIR_1="/projects/f_deenr_1/duffy-nsf-pire/illumina-fastq/2017-02-10_pilot"

#OUTDIR=/projects/f_deenr_1/duffy-nsf-pire/results/2019-11-17_cablcv
# same

######################################################################

module purge
module load bwa samtools
module list
hostname

echo This is task $SLURM_ARRAY_TASK_ID

libindex=$SLURM_ARRAY_TASK_ID

######################################################################

#cd $CUTADAPTDIR
#pwd
R1FILES=( $(ls *_R1_trimmed.fastq.gz) )
libcodearray=( $(ls *_R1_trimmed.fastq.gz | sed 's/_R1_trimmed.fastq.gz//') )

libcode=${libcodearray[libindex-1]}

#cd $OUTDIR
pwd

srun bwa mem -t 9 \
     $FASTAREF \
     ${CUTADAPTDIR}/${libcode}_R1_trimmed.fastq.gz \
     ${CUTADAPTDIR}/${libcode}_R2_trimmed.fastq.gz |
    #samtools view -h -F 256 - |
    #samtools view -h -F 2048 - |
    samtools sort -T /mnt/scratch -o ${libcode}_bwa_sorted.bam
srun samtools index   ${libcode}_bwa_sorted.bam

## drop secondary alignments:
srun samtools view -h -F 256 ${libcode}_bwa_sorted.bam \
                   -b -o ${libcode}_bwa_sorted_no-supp.bam
srun samtools index   ${libcode}_bwa_sorted_no-supp.bam

srun samtools idxstats ${libcode}_bwa_sorted_no-supp.bam \
    > ${libcode}_defaults_with-host_no-supp_idxstats.tsv

srun samtools flagstat ${libcode}_bwa_sorted.bam > ${libcode}_flagstat.txt
srun samtools stats   ${libcode}_bwa_sorted.bam > ${libcode}_stats.txt
#srun samtools depth  ${libcode}_bwa_sorted.bam > ${libcode}_depth.txt

######################################################################

module list
date +"%Y-%m-%d %H:%M"
