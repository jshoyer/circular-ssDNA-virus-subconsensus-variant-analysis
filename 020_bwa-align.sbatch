#!/bin/bash

#SBATCH --job-name=CabLCV_A_plasmid

# Inputs: FastQ.gz files
#         $FASTAREF is defined and created below.
# Outputs: sorted and indexed BAM files, plus tables of read counts

#SBATCH --array=12
# 14 libraries total.
# #14 is mutagenized plasmid (pNSB1101).
#12 is parental DNA-A plasmid.
# Array number is only used
# to get the correct input fastq pair --
# just one library for this plasmid,
# so no reason to run multiple jobs like this in parallel.

#SBATCH --cpus-per-task=10
#SBATCH --mem=50000MB
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1

#SBATCH --output=job%j_%x_node%n.%N.index%a.out
#SBATCH --error=job%j_%x_node%n.%N.index%a.err  # optional
######################################################################

# Alter these if you want input or output in a different directory:
FASTQDIR="."
CUTADAPTDIR="."
OUTDIR="."
OUTDIR_2=$(pwd)

FASTAREF=$OUTDIR_2/cablcv-DNA-A-1.2mer-plus-Ecoli-CP001637.fasta
BEDFILE=cablcv-plasmids.bed
# UPDATE_HERE:
module load bwa samtools java
VARSCAN_JAR=~/miniconda3/share/varscan-2.4.4-1/VarScan.jar

echo This is task $SLURM_ARRAY_TASK_ID

libindex=$SLURM_ARRAY_TASK_ID
######################################################################

cd $FASTQDIR
INPUTFASTQR1=( $(ls ${FASTQDIR}/*_R1.fastq.gz) )
libcodearray=( $(ls *_R1.fastq.gz | sed 's/_R1.fastq.gz//') )
library=${libcodearray[$libindex-1]}
echo $library

cd $CUTADAPTDIR
pwd

cutadapt -j 0\
     --nextseq-trim=20\
     -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC \
     -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT \
     -q 30\
     -o ${library}_R1_trimmed.fastq.gz\
     -p ${library}_R2_trimmed.fastq.gz\
     ${FASTQDIR}/${library}_R1.fastq.gz\
     ${FASTQDIR}/${library}_R2.fastq.gz\
     > ${library}_cutadapt-report.txt

######################################################################

cd $OUTDIR_2;  pwd
#INDEX_STEPS=
cp data/genomes/parental-CabLCV-DNA-A-pNSB1090.fasta $FASTAREF
cat  CP001637.1.fasta  >> $FASTAREF
srun bwa index      $FASTAREF
srun samtools faidx $FASTAREF

################################

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
    > ${library}_unique_idxstats.tsv

srun samtools flagstat ${library}.bam > ${library}_flagstat.txt
srun samtools stats   ${library}.bam > ${library}_stats.txt

########################################

# $BEDFILE must be present
srun samtools view -b -o ${library}_plasmid.bam \
	 -L $BEDFILE \
	 ${library}.bam
samtools index ${library}_plasmid.bam

########################################

#PILEUPSTEPS=
srun samtools mpileup -s -d 1000000000 \
     -f $FASTAREF \
     ${library}_plasmid.bam \
     > ${library}.mpileup
cut -f 1,2,4 ${library}.mpileup > ${library}_depth.txt

######################################################################

#VARSCAN=
srun java -jar $VARSCAN_JAR mpileup2snp \
          ${library}.mpileup \
     --min-var-freq 0.0001 \
     --p-value 0.999999 \
     --output-vcf   \
     > ${library}_varscan-snp.vcf.tsv

srun java -jar $VARSCAN_JAR mpileup2indel \
     ${library}.mpileup \
     --min-var-freq 0.0001 \
     --p-value 0.999999 \
     --output-vcf   \
     > ${library}_varscan-indel.vcf.tsv

######################################################################

# If using multiple directories:
OPTIONAL_FILE_MOVE="
mv ${library}_unique_idxstats.tsv \
   ${library}_flagstat.txt ${library}_stats.txt \
   ${library}_depth.txt \
   ${library}_varscan-snp.vcf.tsv \
   ${library}_varscan-indel.vcf.tsv \
   $OUTDIR_2
"

######################################################################

# https://sites.google.com/view/cluster-user-guide
sacct --units=G --format=MaxRSS,MaxDiskRead,MaxDiskWrite,Elapsed,NodeList -j $SLURM_JOBID

module list
samtools --version
java -version
date +"%Y-%m-%d %H:%M"
