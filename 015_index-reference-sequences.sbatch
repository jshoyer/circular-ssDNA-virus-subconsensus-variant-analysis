#!/bin/bash

#SBATCH --job-name=indexBwa_UPDATE_HERE

#SBATCH --mem=2000MB
#SBATCH --time=00:40:00

######################################################################

module load bwa
module load samtools
module list
pwd

#OUTDIR=UPDATE_HERE   # if desired
#mkdir $OUTDIR
#cd $OUTDIR
#pwd

FASTAREF=UPDATE_HERE.fasta

srun bwa index      $FASTAREF
srun samtools faidx $FASTAREF

######################################################################
module list
date +"%Y-%m-%d %H:%M"
