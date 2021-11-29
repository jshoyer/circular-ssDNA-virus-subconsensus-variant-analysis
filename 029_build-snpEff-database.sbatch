#!/bin/bash

#SBATCH --job-name=snpEffDB

# Build database, per https://pcingola.github.io/SnpEff/se_buildingdb

#SBATCH --partition=main
#SBATCH --requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=500MB
#SBATCH --time=00:05:00    # Total run time limit (HH:MM:SS)

# Directory for log files must exist:
#SBATCH --output=slurm-logs/job%j.node%n.%N.index%a
#Remove space to get STDERR in a separate file.
#V
# SBATCH  --error=slurm-logs/job%j.node%n.%N.index%a.err
#SBATCH --export=ALL
#SBATCH --mail-type=ALL
##########################################
#SBATCH --mail-user=UPDATE_HERE
##########################################

date +"%Y-%m-%d %H:%M"
hostname

module use /projects/community/modulefiles
module purge
module load java
# I guess this is not even strictly necessary:
module load snpEff
module list
fossil sha3 $(pwd)/033D_build-snpEff-database_mutagenized.sbatch
pwd

echo "CabLCV_mutagenized.genome : CabLCV_mutagenized" >> snpEff.config
mkdir -vp data/CabLCV_mutagenized data/genomes
fossil artifact 30b2b597e05a229560 data/CabLCV_mutagenized/genes.gff
# cablcv-DNA-A.gff3
fossil artifact 1bc72e6c4e data/genomes/CabLCV_mutagenized.fa  # sequences/mutagenized

java -jar /projects/community/snpEff/snpEff.jar \
     build -gff3 -v CabLCV_mutagenized
# Creates data/CabLCV/snpEffectPredictor.bin


######################################################################

module list
date +"%Y-%m-%d %H:%M"
