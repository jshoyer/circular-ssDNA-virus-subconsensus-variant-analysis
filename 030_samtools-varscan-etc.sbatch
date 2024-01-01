#!/bin/bash

#SBATCH --job-name=varscanVegTemp20200406

# Inputs:  sorted and indexed BAM files, from 020_bwa-align.sbatch
#          (Names specified based on contents of CUTADAPTDIR -- define below),
#          a BED file with "chromosome" lengths.  (Define bedfile below)
#          and an indexed reference sequence from 015_index-reference-sequences.sbatch
#          (define FASTAREF below).
# Outputs: VCF files (and intermediate files)

######################################################################

#SBATCH --array=1-202

#SBATCH --cpus-per-task=2
#SBATCH --mem=12000MB
#SBATCH --time=4:00:00

######################################################################

# Dependencies:
module load samtools #/1.3.1
module load java     #/9.0.4
#     VarScan v2.4.4 (below)

################################################################################

OUTDIR="." # UPDATE_HERE, if desired

cd $OUTDIR
echo This is task $SLURM_ARRAY_TASK_ID
pwd
libindex=$SLURM_ARRAY_TASK_ID

BEDFILE=acmv-eacmcv-clones.bed
# Used for getting subsets of reads -- below.

CUTADAPTDIR="." # UPDATE_HERE
# same as OUTDIR

FASTAREF=acmv-v3-eacmcv-segs-phiX174-cablcv-calcuv-tomov-tylcv-pUC119_AM560v7.fasta

cd $CUTADAPTDIR
pwd
R1FILES=( $(ls *_R1_trimmed.fastq.gz) )
libcodearray=( $(ls *_R1_trimmed.fastq.gz | sed 's/_R1_trimmed.fastq.gz//') )

library=${libcodearray[libindex-1]}
echo $library

cd $OUTDIR
pwd

# http://www.htslib.org/workflow/wgs-call.html
####################################################

srun samtools view -b -o ${library}_virus.bam \
	 -L $BEDFILE \
	 ${library}.bam

srun java -jar picard.jar MarkDuplicates \
    I=${library}_virus.bam \
    O=${library}_virus_marked_duplicates.bam \
    REMOVE_SEQUENCING_DUPLICATES=true \
    REMOVE_DUPLICATES=false \
    VALIDATION_STRINGENCY=LENIENT \
    M=${library}_virus_marked_dup_metrics.txt
## I do not see any reason to keep 'optical' sequencing_duplicates

srun samtools index ${library}_virus_marked_duplicates.bam

########################################

srun samtools mpileup -s -d 1000000000 \
     -f $FASTAREF \
     ${library}_virus.bam \
     > ${library}_virus.mpileup
# Equivalent to what `samtools depth` would yield:
cut -f 1,2,4 ${library}_virus.mpileup > ${library}_depth.txt

######################################################################

# Very lenient variant calling:
srun java -jar varscan.jar mpileup2snp \
          ${library}_virus.mpileup \
     --min-var-freq 0.001 \
     --p-value 0.999999 \
     --output-vcf   \
     > ${library}_varscan-snp.vcf.tsv

srun java -jar varscan.jar mpileup2indel \
     ${library}_virus.mpileup \
     --min-var-freq 0.001 \
     --p-value 0.999999 \
     --output-vcf   \
     > ${library}_varscan-indel.vcf.tsv

######################################################################

# https://sites.google.com/view/cluster-user-guide
sacct --units=G --format=MaxRSS,MaxDiskRead,MaxDiskWrite,Elapsed,NodeList -j $SLURM_JOBID

module list
date +"%Y-%m-%d %H:%M"
