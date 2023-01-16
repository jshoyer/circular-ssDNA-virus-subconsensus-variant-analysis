#!/bin/bash

#SBATCH --job-name=indexRef

#SBATCH --mem=2000MB
#SBATCH --time=00:40:00
#SBATCH --nodes=1
#SBATCH --ntasks=1

#SBATCH --output=job%j_%x_node%n.%N.index%a.out
#SBATCH --error=job%j_%x_node%n.%N.index%a.err  # optional

######################################################################

module load bwa samtools

#OUTDIR=UPDATE_HERE   # if desired
#mkdir $OUTDIR
#cd $OUTDIR
#pwd

#newfasta=viruses-cablcv-plus-phix174-plus-Athaliana-tair10.fasta
newfasta=viruses-mutagenized-cablcv-plus-phix174-plus-Athaliana-tair10.fasta # D.

cat data/genomes/CabLCV_mutagenized.fa  > $newfasta
cat data/genomes/other.fasta  >> $newfasta

TAIR10_chr_all=TAIR10_chr_all.fas.gz
sha1sum $TAIR10_chr_all
# caf6550d05df855caad3ef35aafcd8d57028fc21
zcat $TAIR10_chr_all    >> $newfasta

# B. and C.
COLI_CHR=CP001637.1.fasta
sha1sum $COLI_CHR
#cat $COLI_CHR >> $newfasta

srun bwa index      $newfasta
srun samtools faidx $newfasta

######################################################################
module list  # just in case
date +"%Y-%m-%d %H:%M"
