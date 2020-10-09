#!/bin/bash

#SBATCH --job-name=bwa_pACMV_A

# Inputs:  FastQ.gz files from 010_cutadapt.sbatch
#          (define CUTADAPTDIR below),
#          and an indexed reference sequence from 015_index-reference-sequences.sbatch
#          (define FASTAREF below;
#           can generate directy by uncommenting the relevant lines.)
# Outputs: sorted and indexed BAM files, plus tables of read counts
#          VCF files (and intermediate files)

######################################################################

#SBATCH --partition=main

#SBATCH --array=1-3

#SBATCH --cpus-per-task=5
#SBATCH --mem=50000MB
#SBATCH --time=2:00:00

#SBATCH --requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1

# Directory for log files must exist for this job script to work
#                    V
#SBATCH --output=slurm-logs/job%j.node%n.%N.index%a.out
#SBATCH --error=slurm-logs/job%j.node%n.%N.index%a.err
#SBATCH --mail-type=ALL
################################
#SBATCH --mail-user=UPDATE_HERE
######################################################################

FASTAREF=pBluescript-II_KS_+_ACMV_DNA-A_1.4mer-plus-CP001637.fasta
CUTADAPTDIR="."
OUTDIR="."

######################################################################
date +"%Y-%m-%d %H:%M"
module purge
# Dependencies:
module load bwa samtools java
#     VarScan v2.4.3 (or similar)
module list
hostname

date +"%Y-%m-%d %H:%M"
cd $OUTDIR
echo This is task $SLURM_ARRAY_TASK_ID
pwd
libindex=$SLURM_ARRAY_TASK_ID
######################################################################

##  Alternative method:
##  uncomment to index reference once here.
##  $FASTAREF defined above

#cp pBluescript-II_KS_+_ACMV_DNA-A_1.4mer.fasta $FASTAREF
#COLI_CHR=CP001637.1.fasta
#sha1sum $COLI_CHR
# fa97c15d4387f6b06877ffe798b669ac5aec0f3c
#cat $COLI_CHR >> $FASTAREF
#srun bwa index $FASTAREF
#srun samtools faidx $FASTAREF

cd $CUTADAPTDIR
pwd
R1FILES=( $(ls *_R1_trimmed.fastq.gz) )
libcodearray=( $(ls *_R1_trimmed.fastq.gz | sed 's/_R1_trimmed.fastq.gz//') )

library=${libcodearray[libindex-1]}
echo $library

cd $OUTDIR
pwd

srun bwa mem -t 4 \
     $FASTAREF \
     ${CUTADAPTDIR}/${library}_R1_trimmed.fastq.gz \
     ${CUTADAPTDIR}/${library}_R2_trimmed.fastq.gz |
    samtools view -b - |
    samtools sort -@2 -o ${library}.bam
srun samtools index   ${library}.bam

srun samtools idxstats ${library}.bam \
    > ${library}_idxstats.tsv

####################################################

srun java -jar igvtools.jar \
     count -w 1 --bases \
     ${library}.bam \
     ${library}.wig ${OUTDIR}/${FASTAREF}

srun samtools mpileup -s -d 100000000000 \
     -f ${FASTAREF} \
     ${library}.bam \
     > ${library}.mpileup
cut -f 1,2,4 ${library}.mpileup > ${library}_depth.txt

######################################################################

# Very lenient variant calling:
srun java -jar varscan.jar mpileup2snp \
     ${library}.mpileup \
     --min-var-freq 0.0001 \
     --p-value 0.9999 \
     --output-vcf   \
     > ${library}_varscan-snp.vcf.tsv

srun java -jar varscan.jar mpileup2indel \
     ${library}.mpileup \
     --min-var-freq 0.0001 \
     --p-value 0.9999 \
     --output-vcf   \
     > ${library}_varscan-indel.vcf.tsv

######################################################################
module list
date +"%Y-%m-%d %H:%M"
