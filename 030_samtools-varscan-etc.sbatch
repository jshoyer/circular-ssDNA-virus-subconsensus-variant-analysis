#!/bin/bash

#SBATCH --job-name=varscan_CabLCV

# Inputs:  sorted and indexed BAM files, from 020_bwa-align.sbatch
#          (Names specified based on contents of CUTADAPTDIR -- define below),
#          a BED file with "chromosome" lengths.  (Define bedfile below
#          and an indexed reference sequence from 015_index-reference-sequences.sbatch
#          (define FASTAREF below).
# Outputs: VCF files (and intermediate files)


######################################################################

#SBATCH --partition=main

#SBATCH --array=3-5,9-11
# 14 libraries total.
# #14 is mutagenized plasmid (pNSB1101).
# #12 is parental DNA-A plasmid.
# #1, 2, and 6-8 were inoculated with WT virus.
# #3-5 and 9-11  were inoculated with mutagenized virus.

#SBATCH --cpus-per-task=2
#SBATCH --mem=60000MB
#SBATCH --time=2:00:00

#SBATCH --requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --output=slurm-logs/job%j.node%n.%N.index%a.out
#SBATCH --error=slurm-logs/job%j.node%n.%N.index%a.err
#SBATCH --export=ALL
######################################################################
#SBATCH --mail-type=ALL
#SBATCH --mail-user=UPDATE_HERE

######################################################################

# Dependencies:
# module loads below
#     VarScan v2.4.3 or higher (below)

################################################################################

OUTDIR=/projects/f_deenr_1/duffy-nsf-pire/results/2019-11-17_cablcv
date +"%Y-%m-%d %H:%M"
#fossil sha3 $(pwd)/03_samtools-varscan-etc-calcuv.sbatch
#fossil sha3 $(pwd)/030A_samtools-varscan-etc-plant-samples.sbatch
#fossil sha3 $(pwd)/030B_samtools-varscan-parental-plasmid.sbatch
#fossil sha3 $(pwd)/030C_samtools-varscan-mutagenized-plasmid.sbatch
fossil sha3 $(pwd)/030D_samtools-varscan-mutant-inoculated-plant-samples.sbatch

cd $OUTDIR
echo This is task $SLURM_ARRAY_TASK_ID
pwd
libindex=$SLURM_ARRAY_TASK_ID

module purge
module load samtools # Use 1.8, not 1.3.1
#           so that mpileup -d 0 option (below) will work.
module load java     #/9.0.4
module list
hostname

BEDFILE=cablcv.bed
# This was done in earlier 010A script:
#fossil artifact e6243538b881ee $BEDFILE \
#       -R pire.fossil
# Used for getting subsets of reads -- below.

#BEDFILE=parental-CabLCV-DNA-A-pNSB1090.bed
#BEDFILE=mutant-CabLCV-DNA-A-pNSB1101.bed

CUTADAPTDIR=/projects/f_deenr_1/duffy-nsf-pire/results/2019-04-30_calcuv
#FASTAREF=cablcv-plus-phix174-plus-Athaliana-tair10.fasta
FASTAREF=mutagenized-cablcv-plus-phix174-plus-Athaliana-tair10.fasta  # D.

#FASTAREF=cablcv-plasmid-plus-phix174-plus-E-coli-DH10-CP001637.fasta  # B.
#FASTAREF=cablcv-mutant-plasmid-plus-phix174-plus-E-coli-DH10.fasta    # C.
# 01_index-reference-sequences-calcuv.sbatch

cd $CUTADAPTDIR
pwd
R1FILES=( $(ls *_R1_trimmed.fastq.gz) )
libcodearray=( $(ls *_R1_trimmed.fastq.gz | sed 's/_R1_trimmed.fastq.gz//') )


library=${libcodearray[libindex-1]}
echo $library

cd $OUTDIR
pwd

# http://www.htslib.org/workflow/#mapping_to_variant
####################################################

samtools view -b -o ${library}_virus.bam \
	 -L $BEDFILE \
	 ${library}_bwa_sorted.bam
# Note that supplementary alignments are included.

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

#PILEUPSTEPS=
srun samtools mpileup -s -d 1000000000 \
     -f $FASTAREF \
     ${library}_virus_marked_duplicates.bam \
     > ${library}.mpileup

# Equivalent to what `samtools depth` would yield:
cut -f 1,2,4 ${library}.mpileup > ${library}_depth.txt

######################################################################

# Very lenient variant calling:
srun java -jar varscan.jar mpileup2snp \
          ${library}.mpileup \
     --min-var-freq 0.001 \
     --p-value 0.999999 \
     --output-vcf   \
     > ${library}_varscan-snp.vcf.tsv

srun java -jar varscan.jar mpileup2indel \
     ${library}.mpileup \
     --min-var-freq 0.001 \
     --p-value 0.999999 \
     --output-vcf   \
     > ${library}_varscan-indel.vcf.tsv


######################################################################

module list
date +"%Y-%m-%d %H:%M"
