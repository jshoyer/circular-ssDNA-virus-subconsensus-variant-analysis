#!/bin/bash

#SBATCH --job-name=indexBwa_UPDATE_HERE

######################################################################

#SBATCH --partition=main
#SBATCH --cpus-per-task=1
#SBATCH --mem=2000MB
#SBATCH --time=00:40:00

#SBATCH --requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1

#SBATCH --output=job%j_%x_node%n.%N.index%a.out
#SBATCH --error=job%j_%x_node%n.%N.index%a.err  # optional
#SBATCH --export=ALL

######################################################################

date +"%Y-%m-%d %H:%M"

module purge
module load bwa
module load samtools
module list
pwd
hostname

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
