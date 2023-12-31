#!/bin/bash

#SBATCH --job-name=indexBwa_CassavaRefs

#SBATCH --mem=40000MB
#SBATCH --time=02:40:00

######################################################################

module load bwa
module load samtools
module list
pwd

#OUTDIR=UPDATE_HERE   # if desired
#mkdir $OUTDIR
#cd $OUTDIR
#pwd

#FASTAREF=UPDATE_HERE
FASTAREF=acmv-v3-eacmcv-segs-phiX174-cablcv-calcuv-tomov-tylcv-pUC119_AM560v7.fasta
cat ref.fasta > $FASTAREF

## v7 AM560-2 genome assembly was downloaded from Phytozome for the paper.   /\
# I would recommend using a more recent genome assembly for most purposes going forward.
cassavaRefV7=cassava-v7.fasta
sha1sum $cassavaRefV7
cat $cassavaRefV7 >> $FASTAREF

srun bwa index      $FASTAREF
srun samtools faidx $FASTAREF

######################################################################
module list
date +"%Y-%m-%d %H:%M"
