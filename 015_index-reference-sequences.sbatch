#!/bin/bash

#SBATCH --job-name=indexBwa_UPDATE_HERE

######################################################################

# Cf. https://rutgers-oarc.github.io/amarel/#serialjobs
#SBATCH --partition=UPDATE_HERE
#SBATCH --cpus-per-task=1
#SBATCH --mem=2000MB
#SBATCH --time=00:40:00

#SBATCH --requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1

# Directory for log files must exist for this job script to work
#                    V
#SBATCH --output=slurm-logs/job%j.node%n.%N.out
#SBATCH  --error=slurm-logs/job%j.node%n.%N.err
#SBATCH --export=ALL
#SBATCH --mail-type=ALL
################################
#SBATCH --mail-user=UPDATE_HERE

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

newfasta=UPDATE_HERE.fasta

srun bwa index      $newfasta
srun samtools faidx $newfasta

######################################################################
module list
date +"%Y-%m-%d %H:%M"
