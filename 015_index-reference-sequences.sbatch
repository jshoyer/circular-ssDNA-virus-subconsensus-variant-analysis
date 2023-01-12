#!/bin/bash

#SBATCH --job-name=indexRef

###############################

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

export MODULEPATH=$MODULEPATH:/projects/community/modulefiles
module purge
module load bwa samtools
module list
hostname

pwd
######################################################################

#OUTDIR=UPDATE_HERE   # if desired
#mkdir $OUTDIR
#cd $OUTDIR
#pwd

# Creating sequence files with Fossil -- remember to specify repository
#newfasta=cablcv-plus-phix174-plus-Athaliana-tair10.fasta
#newfasta=cablcv-plasmid-plus-phix174-plus-E-coli-DH10-CP001637.fasta  # B.
#newfasta=cablcv-mutant-plasmid-plus-phix174-plus-E-coli-DH10.fasta   # C.
newfasta=mutagenized-cablcv-plus-phix174-plus-Athaliana-tair10.fasta # D.

# A.
#cablcvFile=cablcv.fasta
#fossil artifact 2e4272c9ad1a431ab $cablcvFile     -R ~/fossil-repos/pire.fossil
# D.
cablcvFile=mutagenized-cablcv.fasta
fossil artifact 1bc72e6c4e083 $cablcvFile     -R ~/fossil-repos/pire.fossil

# B.
#cablcvFile=parental-CabLCV-DNA-A-pNSB1090.fasta
#fossil artifact 45555df3af804953d2a236 $cablcvFile     -R ~/fossil-repos/pire.fossil

# C.
#cablcvFile=mutant-CabLCV-DNA-A-pNSB1101.fasta
#fossil artifact 17714843529776d $cablcvFile     -R ~/fossil-repos/pire.fossil

cat $cablcvFile            > $newfasta

fossil artifact e6243538b881ee cablcv.bed     -R ~/fossil-repos/pire.fossil
#fossil artifact 6f3d90bc051c031c6c parental-CabLCV-DNA-A-pNSB1090.bed  -R ~/fossil-repos/pire.fossil
#fossil artifact 212cec37eca57a895c0c6949 mutant-CabLCV-DNA-A-pNSB1101.bed  -R ~/fossil-repos/pire.fossil

#phix174.fasta:
fossil artifact 6f595e1ee7  -R ~/fossil-repos/pire.fossil \
          >> $newfasta
 	       # 70 characters wide (23a6a383dabf is 60)

# A. TAIR10
TAIR10_chr_all=TAIR10_chr_all.fas
sha1sum $TAIR10_chr_all
# 1f1529aad68c291186f7b2292bc4b8d7fd3671b3
cat $TAIR10_chr_all    >> $newfasta

# B. and C.
COLI_CHR=/projects/f_deenr_1/duffy-nsf-pire/data-downloads/ncbi/CP001637.1.fasta
sha1sum $COLI_CHR
# fa97c15d4387f6b06877ffe798b669ac5aec0f3c
#cat $COLI_CHR >> $newfasta

srun bwa index      $newfasta
srun samtools faidx $newfasta

######################################################################
module list  # just in case
date +"%Y-%m-%d %H:%M"
