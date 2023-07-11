#!/usr/bin/env bash

# Plant total vs size-selected DNA:
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/089/SRR12494889/SRR12494889_1.fastq.gz -o tomato-Lanai_ToMoV_T2_replicate1_SRR12494889_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/089/SRR12494889/SRR12494889_2.fastq.gz -o tomato-Lanai_ToMoV_T2_replicate1_SRR12494889_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/015/SRR12491315/SRR12491315_1.fastq.gz -o tomato-Lanai_ToMoV_T2_replicate2_SRR12491315_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/015/SRR12491315/SRR12491315_2.fastq.gz -o tomato-Lanai_ToMoV_T2_replicate2_SRR12491315_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/083/SRR12491583/SRR12491583_1.fastq.gz -o tomato-Lanai_ToMoV_T2-size-selected_replicate1_SRR12491583_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/083/SRR12491583/SRR12491583_2.fastq.gz -o tomato-Lanai_ToMoV_T2-size-selected_replicate1_SRR12491583_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/082/SRR12491582/SRR12491582_1.fastq.gz -o tomato-Lanai_ToMoV_T2-size-selected_replicate2_SRR12491582_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/082/SRR12491582/SRR12491582_2.fastq.gz -o tomato-Lanai_ToMoV_T2-size-selected_replicate2_SRR12491582_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/085/SRR12491585/SRR12491585_1.fastq.gz -o tomato-Lanai_ToMoV_T2-virions_replicate1_SRR12491585_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/085/SRR12491585/SRR12491585_2.fastq.gz -o tomato-Lanai_ToMoV_T2-virions_replicate1_SRR12491585_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/084/SRR12491584/SRR12491584_1.fastq.gz -o tomato-Lanai_ToMoV_T2-virions_replicate2_SRR12491584_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/084/SRR12491584/SRR12491584_2.fastq.gz -o tomato-Lanai_ToMoV_T2-virions_replicate2_SRR12491584_R2.fastq.gz


# Whitefly total vs size-selected DNA:
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR125/055/SRR12518355/SRR12518355_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T4_replicate1_SRR12518355_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR125/055/SRR12518355/SRR12518355_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T4_replicate1_SRR12518355_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/014/SRR12491314/SRR12491314_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T4_replicate2_SRR12491314_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/014/SRR12491314/SRR12491314_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T4_replicate2_SRR12491314_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/003/SRR12491603/SRR12491603_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T4-size-selected_replicate1_SRR12491603_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/003/SRR12491603/SRR12491603_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T4-size-selected_replicate1_SRR12491603_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/002/SRR12491602/SRR12491602_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T4-size-selected_replicate2_SRR12491602_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/002/SRR12491602/SRR12491602_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T4-size-selected_replicate2_SRR12491602_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/001/SRR12491601/SRR12491601_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T6_replicate1_SRR12491601_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/001/SRR12491601/SRR12491601_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T6_replicate1_SRR12491601_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/000/SRR12491600/SRR12491600_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T6_replicate2_SRR12491600_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/000/SRR12491600/SRR12491600_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T6_replicate2_SRR12491600_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/099/SRR12491599/SRR12491599_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T6-size-selected_replicate1_SRR12491599_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/099/SRR12491599/SRR12491599_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T6-size-selected_replicate1_SRR12491599_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/098/SRR12491598/SRR12491598_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T6-size-selected_replicate2_SRR12491598_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/098/SRR12491598/SRR12491598_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T6-size-selected_replicate2_SRR12491598_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/097/SRR12491597/SRR12491597_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T7_replicate1_SRR12491597_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/097/SRR12491597/SRR12491597_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T7_replicate1_SRR12491597_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/096/SRR12491596/SRR12491596_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T7_replicate2_SRR12491596_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/096/SRR12491596/SRR12491596_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T7_replicate2_SRR12491596_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/095/SRR12491595/SRR12491595_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T7-size-selected_replicate1_SRR12491595_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/095/SRR12491595/SRR12491595_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T7-size-selected_replicate1_SRR12491595_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/094/SRR12491594/SRR12491594_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T7-size-selected_replicate2_SRR12491594_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/094/SRR12491594/SRR12491594_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T7-size-selected_replicate2_SRR12491594_R2.fastq.gz


# Virions from whiteflies: few reads
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR125/054/SRR12518354/SRR12518354_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T14-V_replicate1_SRR12518354_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR125/054/SRR12518354/SRR12518354_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T14-V_replicate1_SRR12518354_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/013/SRR12491313/SRR12491313_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T14-V_replicate2_SRR12491313_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/013/SRR12491313/SRR12491313_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T14-V_replicate2_SRR12491313_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/092/SRR12491592/SRR12491592_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T16-V_replicate1_SRR12491592_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/092/SRR12491592/SRR12491592_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T16-V_replicate1_SRR12491592_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/091/SRR12491591/SRR12491591_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T16-V_replicate2_SRR12491591_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/091/SRR12491591/SRR12491591_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T16-V_replicate2_SRR12491591_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/090/SRR12491590/SRR12491590_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T18-V_replicate1_SRR12491590_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/090/SRR12491590/SRR12491590_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T18-V_replicate1_SRR12491590_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/089/SRR12491589/SRR12491589_1.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T18-V_replicate2_SRR12491589_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR124/089/SRR12491589/SRR12491589_2.fastq.gz -o Bemisia_tabaci_MEAM1_ToMoV_T18-V_replicate2_SRR12491589_R2.fastq.gz

# Several libraries represented twice,
# despite our best efforts to get them deduplicated,
# unable to be removed:
# SRR12494887
# SRR12494888
# SRR12518356
