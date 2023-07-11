#!/bin/bash

#SBATCH --job-name=indexRefs

#SBATCH --mem=2000MB
#SBATCH --time=00:40:00

# UPDATE_HERE if not using modules
module purge
module load bwa
module load samtools
module list

######################################################################

#newfasta=UPDATE_HERE.fasta
newfasta=acmv-v3-eacmcv-segs-phiX174-calcuv-Mesculenta_v7.0.fasta
cat ref.fasta > $newfasta

## Downloaded from Phytozome
cassavaRefV7=cassava-v7.fasta
sha1sum $cassavaRefV7
cat $cassavaRefV7 >> $newfasta


srun bwa index      $newfasta
srun samtools faidx $newfasta

######################################################################

module list
date +"%Y-%m-%d %H:%M"
