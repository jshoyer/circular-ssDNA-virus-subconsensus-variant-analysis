#!/bin/bash

#SBATCH --job-name=cutadapt_CabLCV

# Inputs:  a directory of FastQ.gz files -- raw reads
# Outputs: FastQ.gz files -- trimmed adaptor-parsed reads

# This script is more complicated than others
# because libraries for this experiment
# were sequenced across two flowcells
# (2017-02-10 and 2017-08-03)

######################################################################

# Dependencies:
#     Cutadapt 1.16 or similar

#SBATCH --partition=main
#SBATCH --requeue

#SBATCH --array=7-13


#SBATCH --nodes=1
#SBATCH --ntasks=1                  # Total # of tasks across all nodes
#SBATCH --cpus-per-task=1           # Cores per task (>1 if multithread tasks)
#SBATCH --mem=500MB
#SBATCH --time=0:30:00

#SBATCH --output=job%j_%x_node%n.%N.index%a.out
#SBATCH --error=job%j_%x_node%n.%N.index%a.err  # optional
#SBATCH --export=ALL

######################################################################

CUTADAPTDIR=/projects/f_deenr_1/duffy-nsf-pire/results/2019-04-30_calcuv

date +"%Y-%m-%d %H:%M"
hostname

echo This is task $SLURM_ARRAY_TASK_ID

module purge
module load FastQC
module list

######################################################################

libindex=$SLURM_ARRAY_TASK_ID

FASTQDIR_1="/projects/f_deenr_1/duffy-nsf-pire/illumina-fastq/2017-02-10_pilot"
FASTQDIR_2="/projects/f_deenr_1/duffy-nsf-pire/illumina-fastq/2017-08-03_calcuv"

cd $FASTQDIR_1
pwd

## Fully qualified paths:
INPUTFASTQR1_SET1=( $(ls ${FASTQDIR_1}/*_R1.fastq.gz) )
# (cf. past sbatch job scripts)
OUTPREFIX_SET1=( $(ls *_R1.fastq.gz | sed 's/_R1.fastq.gz//') )

# Drop the FastQ files associated with *cassava* virus pilot
# (7 to 12 for that MiSeq flowcell)
INPUTFASTQR1=(${INPUTFASTQR1_SET1[@]:0:6})
OUTPREFIX=(${OUTPREFIX_SET1[@]:0:6})

# Add #7 to 13 (later MiSeq flowcell) to array:
cd $FASTQDIR_2
pwd
INPUTFASTQR1=( ${INPUTFASTQR1[@]} $(ls ${FASTQDIR_2}/*_R1.fastq.gz) )
OUTPREFIX=( ${OUTPREFIX[@]} $(ls *_R1.fastq.gz | sed 's/_R1.fastq.gz//') )

## Again, need fully qualified paths:
INPUTFASTQR2_single=$( echo ${INPUTFASTQR1[libindex-1]} | sed 's/_R1_/_R2_/')
# (cf. older scripts)

cd $CUTADAPTDIR
pwd

srun cutadapt\
     --nextseq-trim=20\
     -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC \
     -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT \
     -q 30\
     -o ${OUTPREFIX[$libindex-1]}_R1_trimmed.fastq.gz\
     -p ${OUTPREFIX[$libindex-1]}_R2_trimmed.fastq.gz\
     ${INPUTFASTQR1[libindex-1]}\
     $INPUTFASTQR2_single \
     > ${OUTPREFIX[$libindex-1]}_cutadapt-report.txt

#TROUBLESHOOT=
echo
echo 'Full paths: ' ${INPUTFASTQR1[@]}
echo 'Prefixes:   ' ${OUTPREFIX[@]}
echo
echo 'Library' $libindex
echo ${OUTPREFIX[libindex-1]}
echo '1. ' ${INPUTFASTQR1[libindex-1]}
echo '2. ' $INPUTFASTQR2_single

#####################################################

fastqc ${OUTPREFIX[$libindex-1]}_R1_trimmed.fastq.gz\
       ${OUTPREFIX[$libindex-1]}_R2_trimmed.fastq.gz

######################################################################

module list
date +"%Y-%m-%d %H:%M"
