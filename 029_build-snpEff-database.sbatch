#!/bin/bash

#SBATCH --job-name=snpEffDB

# Build database, per https://pcingola.github.io/SnpEff/se_buildingdb

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=500MB
#SBATCH --time=00:05:00    # HH:MM:SS

SNPEFF_JAR=snpEff.jar

echo "CabLCV_mutagenized.genome : CabLCV_mutagenized" >> snpEff.config

java -jar $SNPEFF_JAR \
     build -gff3 -v CabLCV_mutagenized
# Creates data/CabLCV/snpEffectPredictor.bin


######################################################################

module list
date +"%Y-%m-%d %H:%M"
