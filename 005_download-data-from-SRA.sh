#!/usr/bin/env bash

# Kibandameno inoculated with ACMV and EACMCV (mixed infection)
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/086/SRR12491586/SRR12491586_1.fastq.gz -o SRR12491586_plant-4-size-selected-DNA-ACMV-EACMCV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/086/SRR12491586/SRR12491586_2.fastq.gz -o SRR12491586_plant-4-size-selected-DNA-ACMV-EACMCV_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/087/SRR12491587/SRR12491587_1.fastq.gz -o SRR12491587_plant-4-size-selected-DNA-ACMV-EACMCV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/087/SRR12491587/SRR12491587_2.fastq.gz -o SRR12491587_plant-4-size-selected-DNA-ACMV-EACMCV_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/088/SRR12491588/SRR12491588_1.fastq.gz -o SRR12491588_plant-4-total-DNA-ACMV-EACMCV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/088/SRR12491588/SRR12491588_2.fastq.gz -o SRR12491588_plant-4-total-DNA-ACMV-EACMCV_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/093/SRR12491593/SRR12491593_1.fastq.gz -o SRR12491593_plant-4-total-DNA-ACMV-EACMCV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/093/SRR12491593/SRR12491593_2.fastq.gz -o SRR12491593_plant-4-total-DNA-ACMV-EACMCV_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/004/SRR12491604/SRR12491604_1.fastq.gz -o SRR12491604_plant-1-size-selected-DNA-ACMV-EACMCV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/004/SRR12491604/SRR12491604_2.fastq.gz -o SRR12491604_plant-1-size-selected-DNA-ACMV-EACMCV_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/005/SRR12491605/SRR12491605_1.fastq.gz -o SRR12491605_plant-1-size-selected-DNA-ACMV-EACMCV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/005/SRR12491605/SRR12491605_2.fastq.gz -o SRR12491605_plant-1-size-selected-DNA-ACMV-EACMCV_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/090/SRR12494890/SRR12494890_1.fastq.gz -o SRR12494890_plant-1-total-DNA-ACMV-EACMCV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/090/SRR12494890/SRR12494890_2.fastq.gz -o SRR12494890_plant-1-total-DNA-ACMV-EACMCV_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR125/057/SRR12518357/SRR12518357_1.fastq.gz -o SRR12518357_plant-1-total-DNA-ACMV-EACMCV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR125/057/SRR12518357/SRR12518357_2.fastq.gz -o SRR12518357_plant-1-total-DNA-ACMV-EACMCV_R2.fastq.gz
# Two libraries represented twice,
# despite my best efforts to get them deduplicated:
# SRR12494890 and SRR12518357,
# SRR12491316 and SRR12494891.
# SRR12491316 refers incorrectly to TempliPhi.

# ACMV virion libraries
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR139/096/SRR13943396/SRR13943396_1.fastq.gz -o SRR13943396_virion-ACMV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR139/096/SRR13943396/SRR13943396_2.fastq.gz -o SRR13943396_virion-ACMV_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR139/097/SRR13943397/SRR13943397_1.fastq.gz -o SRR13943397_virion-ACMV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR139/097/SRR13943397/SRR13943397_2.fastq.gz -o SRR13943397_virion-ACMV_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR139/098/SRR13943398/SRR13943398_1.fastq.gz -o SRR13943398_virion-ACMV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR139/098/SRR13943398/SRR13943398_2.fastq.gz -o SRR13943398_virion-ACMV_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR139/099/SRR13943399/SRR13943399_1.fastq.gz -o SRR13943399_virion-ACMV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR139/099/SRR13943399/SRR13943399_2.fastq.gz -o SRR13943399_virion-ACMV_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR139/000/SRR13943400/SRR13943400_1.fastq.gz -o SRR13943400_virion-ACMV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR139/000/SRR13943400/SRR13943400_2.fastq.gz -o SRR13943400_virion-ACMV_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR139/001/SRR13943401/SRR13943401_1.fastq.gz -o SRR13943401_virion-ACMV_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR139/001/SRR13943401/SRR13943401_2.fastq.gz -o SRR13943401_virion-ACMV_R2.fastq.gz
