#!/bin/bash

#SBATCH --job-name=indexBwa_Plasmid

#SBATCH --partition=main
#SBATCH --cpus-per-task=1
#SBATCH --mem=25000                  # Real memory (RAM) required (MB)
#SBATCH --time=01:00:00              # Total run time limit (HH:MM:SS)

#SBATCH --requeue
#SBATCH --nodes=1
#SBATCH --ntasks=1

# Log file directory MUST exist before running this job script.
#                V
#SBATCH --output=slurm-logs/job%j.node%n.%N.index%a.out
#SBATCH --error=slurm-logs/job%j.node%n.%N.index%a.err
#SBATCH --export=ALL
#SBATCH --mail-type=ALL
#########################################
#SBATCH --mail-user=UPDATE_HERE

######################################################################
date +"%Y-%m-%d %H:%M"

module purge
# Dependencies:
module load bwa samtools
module list
hostname

######################################################################

FASTAREF_1=pBluescript-II_KS_+_ACMV_DNA-A_1.4mer-plus-CP001637.fasta
cat pBluescript-II_KS_+_ACMV_DNA-A_1.4mer.fasta > $FASTAREF_1

FASTAREF_2=pUC19_ACMV_DNA-B_1.5mer-plus-CP001637.fasta
cat pUC19_ACMV_DNA-B_1.5mer.fasta > $FASTAREF_2

FASTAREF_3=pBluescript_II_KS_+_EACMCV_DNA-A_1.6mer-plus-CP001637.fasta
cat pBluescript_II_KS_+_EACMCV_DNA-A_1.6mer.fasta > $FASTAREF_3

FASTAREF_4=pSL1180_EACMCV_DNA-B_1.6mer-plus-CP001637.fasta
cat pSL1180_EACMCV_DNA-B_1.6mer.fasta > $FASTAREF_4


COLI_CHR=CP001637.1.fasta
sha1sum $COLI_CHR
# fa97c15d4387f6b06877ffe798b669ac5aec0f3c

cat $COLI_CHR >> $FASTAREF_1
srun bwa index $FASTAREF_1
srun samtools faidx $FASTAREF_1

cat $COLI_CHR >> $FASTAREF_2
srun bwa index $FASTAREF_2
srun samtools faidx $FASTAREF_2

cat $COLI_CHR >> $FASTAREF_3
srun bwa index $FASTAREF_3
srun samtools faidx $FASTAREF_3

cat $COLI_CHR >> $FASTAREF_4
srun bwa index $FASTAREF_4
srun samtools faidx $FASTAREF_4

######################################################################
module list
date +"%Y-%m-%d %H:%M"
