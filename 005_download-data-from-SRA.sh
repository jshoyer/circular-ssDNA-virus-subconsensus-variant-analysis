#!/usr/bin/env bash

# Coastal field samples C9 and C45 from 2015:
# EACMV only
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/024/SRR24008624/SRR24008624_1.fastq.gz -o field_sample_C09_replicateA__SRR24008624_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/024/SRR24008624/SRR24008624_2.fastq.gz -o field_sample_C09_replicateA__SRR24008624_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/023/SRR24008623/SRR24008623_1.fastq.gz -o field_sample_C09_replicateB__SRR24008623_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/023/SRR24008623/SRR24008623_2.fastq.gz -o field_sample_C09_replicateB__SRR24008623_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/019/SRR24008619/SRR24008619_1.fastq.gz -o field_sample_C45_replicateA__SRR24008619_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/019/SRR24008619/SRR24008619_2.fastq.gz -o field_sample_C45_replicateA__SRR24008619_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/018/SRR24008618/SRR24008618_1.fastq.gz -o field_sample_C45_replicateB__SRR24008618_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/018/SRR24008618/SRR24008618_2.fastq.gz -o field_sample_C45_replicateB__SRR24008618_R2.fastq.gz
# (C45 is #4 in ASCIIbetical order)

# Other 2015 field samples: mixed infection
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/097/SRR24008597/SRR24008597_1.fastq.gz -o field_sample_C16_replicateA__SRR24008597_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/097/SRR24008597/SRR24008597_2.fastq.gz -o field_sample_C16_replicateA__SRR24008597_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/096/SRR24008596/SRR24008596_1.fastq.gz -o field_sample_C16_replicateB__SRR24008596_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/096/SRR24008596/SRR24008596_2.fastq.gz -o field_sample_C16_replicateB__SRR24008596_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/093/SRR24008593/SRR24008593_1.fastq.gz -o field_sample_C17_replicateA__SRR24008593_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/093/SRR24008593/SRR24008593_2.fastq.gz -o field_sample_C17_replicateA__SRR24008593_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/020/SRR24008620/SRR24008620_1.fastq.gz -o field_sample_C17_replicateB__SRR24008620_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/020/SRR24008620/SRR24008620_2.fastq.gz -o field_sample_C17_replicateB__SRR24008620_R2.fastq.gz



curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/006/SRR24008606/SRR24008606_1.fastq.gz -o field_sample_N29_replicateA__SRR24008606_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/006/SRR24008606/SRR24008606_2.fastq.gz -o field_sample_N29_replicateA__SRR24008606_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/005/SRR24008605/SRR24008605_1.fastq.gz -o field_sample_N29_replicateB__SRR24008605_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/005/SRR24008605/SRR24008605_2.fastq.gz -o field_sample_N29_replicateB__SRR24008605_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/015/SRR24008615/SRR24008615_1.fastq.gz -o field_sample_W01_replicateA__SRR24008615_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/015/SRR24008615/SRR24008615_2.fastq.gz -o field_sample_W01_replicateA__SRR24008615_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/014/SRR24008614/SRR24008614_1.fastq.gz -o field_sample_W01_replicateB__SRR24008614_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/014/SRR24008614/SRR24008614_2.fastq.gz -o field_sample_W01_replicateB__SRR24008614_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/010/SRR24008610/SRR24008610_1.fastq.gz -o field_sample_W18_replicateA__SRR24008610_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/010/SRR24008610/SRR24008610_2.fastq.gz -o field_sample_W18_replicateA__SRR24008610_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/009/SRR24008609/SRR24008609_1.fastq.gz -o field_sample_W18_replicateB__SRR24008609_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/009/SRR24008609/SRR24008609_2.fastq.gz -o field_sample_W18_replicateB__SRR24008609_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/002/SRR24008602/SRR24008602_1.fastq.gz -o field_sample_W46_replicateA__SRR24008602_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/002/SRR24008602/SRR24008602_2.fastq.gz -o field_sample_W46_replicateA__SRR24008602_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/001/SRR24008601/SRR24008601_1.fastq.gz -o field_sample_W46_replicateB__SRR24008601_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/001/SRR24008601/SRR24008601_2.fastq.gz -o field_sample_W46_replicateB__SRR24008601_R2.fastq.gz




curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/011/SRR24008611/SRR24008611_1.fastq.gz -o greenhouse_sample_C09_replicateA__SRR24008611_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/011/SRR24008611/SRR24008611_2.fastq.gz -o greenhouse_sample_C09_replicateA__SRR24008611_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/000/SRR24008600/SRR24008600_1.fastq.gz -o greenhouse_sample_C09_replicateB__SRR24008600_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/000/SRR24008600/SRR24008600_2.fastq.gz -o greenhouse_sample_C09_replicateB__SRR24008600_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/095/SRR24008595/SRR24008595_1.fastq.gz -o greenhouse_sample_C16_replicateA__SRR24008595_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/095/SRR24008595/SRR24008595_2.fastq.gz -o greenhouse_sample_C16_replicateA__SRR24008595_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/094/SRR24008594/SRR24008594_1.fastq.gz -o greenhouse_sample_C16_replicateB__SRR24008594_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/094/SRR24008594/SRR24008594_2.fastq.gz -o greenhouse_sample_C16_replicateB__SRR24008594_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/022/SRR24008622/SRR24008622_1.fastq.gz -o greenhouse_sample_C17_replicateA__SRR24008622_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/022/SRR24008622/SRR24008622_2.fastq.gz -o greenhouse_sample_C17_replicateA__SRR24008622_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/021/SRR24008621/SRR24008621_1.fastq.gz -o greenhouse_sample_C17_replicateB__SRR24008621_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/021/SRR24008621/SRR24008621_2.fastq.gz -o greenhouse_sample_C17_replicateB__SRR24008621_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/017/SRR24008617/SRR24008617_1.fastq.gz -o greenhouse_sample_C45_replicateA__SRR24008617_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/017/SRR24008617/SRR24008617_2.fastq.gz -o greenhouse_sample_C45_replicateA__SRR24008617_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/016/SRR24008616/SRR24008616_1.fastq.gz -o greenhouse_sample_C45_replicateB__SRR24008616_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/016/SRR24008616/SRR24008616_2.fastq.gz -o greenhouse_sample_C45_replicateB__SRR24008616_R2.fastq.gz


curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/003/SRR24008603/SRR24008603_1.fastq.gz -o greenhouse_sample_N29_replicateB__SRR24008603_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/003/SRR24008603/SRR24008603_2.fastq.gz -o greenhouse_sample_N29_replicateB__SRR24008603_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/004/SRR24008604/SRR24008604_1.fastq.gz -o greenhouse_sample_N29_replicateA__SRR24008604_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/004/SRR24008604/SRR24008604_2.fastq.gz -o greenhouse_sample_N29_replicateA__SRR24008604_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/013/SRR24008613/SRR24008613_1.fastq.gz -o greenhouse_sample_W01_replicateA__SRR24008613_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/013/SRR24008613/SRR24008613_2.fastq.gz -o greenhouse_sample_W01_replicateA__SRR24008613_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/012/SRR24008612/SRR24008612_1.fastq.gz -o greenhouse_sample_W01_replicateB__SRR24008612_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/012/SRR24008612/SRR24008612_2.fastq.gz -o greenhouse_sample_W01_replicateB__SRR24008612_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/007/SRR24008607/SRR24008607_1.fastq.gz -o greenhouse_sample_W18_replicateB__SRR24008607_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/007/SRR24008607/SRR24008607_2.fastq.gz -o greenhouse_sample_W18_replicateB__SRR24008607_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/008/SRR24008608/SRR24008608_1.fastq.gz -o greenhouse_sample_W18_replicateA__SRR24008608_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/008/SRR24008608/SRR24008608_2.fastq.gz -o greenhouse_sample_W18_replicateA__SRR24008608_R2.fastq.gz

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/098/SRR24008598/SRR24008598_1.fastq.gz -o greenhouse_sample_W46_replicateB__SRR24008598_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/098/SRR24008598/SRR24008598_2.fastq.gz -o greenhouse_sample_W46_replicateB__SRR24008598_R2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/099/SRR24008599/SRR24008599_1.fastq.gz -o greenhouse_sample_W46_replicateA__SRR24008599_R1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR240/099/SRR24008599/SRR24008599_2.fastq.gz -o greenhouse_sample_W46_replicateA__SRR24008599_R2.fastq.gz
