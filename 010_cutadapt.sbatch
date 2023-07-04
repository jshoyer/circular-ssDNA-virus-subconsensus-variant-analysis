#!/bin/bash

#SBATCH --job-name=cutadapt_UPDATE_HERE

# Inputs:  a directory of FastQ.gz files -- raw reads
# Outputs: FastQ.gz files -- trimmed adapter-parsed reads
#          plus FastQC reports (HTML).

#SBATCH --array=UPDATE_HERE

#SBATCH --mem=500MB
#SBATCH --time=2:30:00

######################################################################

CUTADAPTDIR="." # UPDATE_HERE, if you want input and output elsewhere
module load FastQC
libindex=$SLURM_ARRAY_TASK_ID
FASTQDIR="." # UPDATE_HERE

cd $FASTQDIR
pwd
INPUTFASTQR1=( $(ls *_R1.fastq.gz) )
OUTPREFIX=( $(ls *_R1.fastq.gz | sed 's/_R1.fastq.gz//') )

cd $CUTADAPTDIR
pwd

# See Illumina adapter sequences document.
adapter_1_nebnext=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
adapter_2_nebnext=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
adapter_1_nextera=CTGTCTCTTATACACATCTCCGAGCCCACGAGAC
adapter_2_nextera=CTGTCTCTTATACACATCTGACGCTGCCGACGA

srun cutadapt\
     --nextseq-trim=20\
     # UPDATE_HERE if necessary:
     -a $adapter_1_nextera \
     -A $adapter_2_nextera \
     -q 30\
     -o ${OUTPREFIX[$libindex-1]}_R1_trimmed.fastq.gz\
     -p ${OUTPREFIX[$libindex-1]}_R2_trimmed.fastq.gz\
     ${FASTQDIR}/${INPUTFASTQR1[libindex-1]}\
     ${FASTQDIR}/${OUTPREFIX[libindex-1]}_R2.fastq.gz\
     > ${OUTPREFIX[$libindex-1]}_cutadapt-report.txt

#####################################################

fastqc ${OUTPREFIX[$libindex-1]}_R1_trimmed.fastq.gz\
       ${OUTPREFIX[$libindex-1]}_R2_trimmed.fastq.gz

######################################################################

module list
date +"%Y-%m-%d %H:%M"
