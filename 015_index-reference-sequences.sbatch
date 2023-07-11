#!/bin/bash

#SBATCH --job-name=indexRefs

#SBATCH --mem=20000MB
#SBATCH --time=00:50:00

# UPDATE_HERE if not using modules
module purge
module load bwa samtools
module list
pwd

#newfasta=UPDATE_HERE.fasta
newfasta=tomato4-MEAM1-tomov3-tylcv-acmv-eacmcv-segs-phiX174-calcuv.fasta
cat ref.fasta > $newfasta

## From solgenomics.net
tomatoRefV4=S_lycopersicum_chromosomes.4.00.fa.gz
sha1sum $tomatoRefV4
zcat $tomatoRefV4 >> $newfasta

meam1Ref=GCA_001854935.1_ASM185493v1_genomic.fna.gz
sha1sum $meam1Ref
zcat $meam1Ref >> $newfasta


srun bwa index      $newfasta
srun samtools faidx $newfasta

######################################################################

module list
date +"%Y-%m-%d %H:%M"
