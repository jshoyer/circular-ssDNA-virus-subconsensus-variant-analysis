#!/bin/bash

#SBATCH --job-name=Megahit2021

#SBATCH --array=2
#       --array=1-32  # to assemble all

#SBATCH --cpus-per-task=8
#SBATCH --mem=20000
#SBATCH --time=04:00:00

######################################################################

OUTDIR="."   # specify, if desired
#mkdir $OUTDIR
#cd $OUTDIR
echo "Output directory:  $OUTDIR"

TRIMMED_READ_DIR="."

megahit=megahit
$megahit --version  # MEGAHIT v1.1.2;  conda install -c bioconda megahit

######################################################################

echo This is task $SLURM_ARRAY_TASK_ID
libindex=$SLURM_ARRAY_TASK_ID
cd $TRIMMED_READ_DIR
pwd
R1FILES=( $(ls *_R1_trimmed.fastq.gz) )
libcodearray=( $(ls *_R1_trimmed.fastq.gz | sed 's/_R1_trimmed.fastq.gz//') )
library=${libcodearray[libindex-1]}

######################################################################

srun $megahit -1 ${TRIMMED_READ_DIR}/${library}_R1_trimmed.fastq.gz \
     	-2 ${TRIMMED_READ_DIR}/${library}_R2_trimmed.fastq.gz \
     	--verbose \
	-t 8 \
	--k-min 31   \
	--min-count 3 \
	--min-contig-len 500 \
	--no-mercy \
	-o $OUTDIR/$library
# Cf. memory limit above (megabytes)
# https://github.com/voutcn/megahit/wiki/MEGAHIT-Memory-setting
# ‘By default -m is 0.9’, i.e. 90% of available memory is used.


#######################
# https://sites.google.com/view/cluster-user-guide/amarel
sacct --units=G --format=MaxRSS,MaxDiskRead,MaxDiskWrite,Elapsed,NodeList -j $SLURM_JOBID
module list
date +"%Y-%m-%d %H:%M"
