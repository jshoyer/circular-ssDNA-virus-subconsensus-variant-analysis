
#' Use the input filenames as simple metadata.
library(dplyr)
library(tidyr) # v1.0.0 or higher

source("helper-functions/collateReadCounts.R")
source("helper-functions/readSamtoolsDepth.R")


inputTables20200108 <-
    dir(
        pattern = "_unique_idxstats.tsv",
        full.names = TRUE)

filePrefixes20200108 <- sub(
    "_L001_unique_idxstats.tsv",
    "", filePrefixes20200108)

readCounts20200108 <-
    collateReadCounts(
        ##filePaths =
        inputTables20200108,
        #filePrefixes =
        filePrefixes20200108,
        sumThemUp = TRUE)

readCounts20200108$libraryCode <-
    sub("_S[0-9]+", "", readCounts20200108$libraryFastQfile)


#' ** Depth
# helper-functions/readSamtoolsDepth.R

depthFiles20200108 <-
    dir(inputFilePath20200108,
        pattern = "depth",
        full.names = TRUE)
depthFileNames20200108 <-
    dir(inputFilePath20200108,
        pattern = "depth")

filePrefixes20200108 == gsub("_L001_depth.txt", "",
                             depthFileNames20200108)

depthList20200108 <- readSamtoolsDepth(depthFiles20200108,
                                       filePrefixes20200108)

depth20200108 <- do.call(rbind, depthList20200108)

depth20200108$libraryCode <- sub("_S[0-9]+", "",
                                 depth20200108$readGroup)
segmentNames <- c("ACMV DNA-A",   "ACMV DNA-B",
                                 "EACMCV DNA-A", "EACMCV DNA-B")
levels(depth20200108$chrom) <- segmentNames
depth20200108 <- mutate(depth20200108,
                        depth1k = depth/1000)

depth20200108_kx4 <- filter(depth20200108,
                            grepl("KX4", libraryCode))
#depth20200108_kx1 <- filter(depth20200108,
#                            grepl("KX1", libraryCode))

segmentNamesOriginal <- c("ACMV_DNA-A_v2",
                          "ACMV_DNA-B_v3",
                          "EACMCV_DNA-A",
                          "EACMCV_DNA-B")

readGroup8 <- rep(unique(depth20200108$libraryCode), each = 4)
chrom4 <- rep(segmentNames, 8)
meanDepthTable <- data.frame(readGroup8, chrom4)

for (j in 1:8) {
    for (i in 1:4) {
        segmentI <- filter(depthList20200108[[j]],
                           chrom == segmentNamesOriginal[i])
        meanDepthTable$meanDepth[(j - 1) * 4 + i] <-
            mean(segmentI$depth)
    }
}

#' ** Write files
if (FALSE) {
dir.create("../2020-01-08_tomov-and-bp-test/working-data")
write.csv(readCounts20200108,
          "../2020-01-08_tomov-and-bp-test/working-data/read-counts_2020-01-13.csv")

write.csv(meanDepthTable,
          "../2020-01-08_tomov-and-bp-test/working-data/mean-read-depth_ACMV-EACMCV_2020-01-flowcell.csv")
write.csv(pivot_wider(meanDepthTable,
                      names_from = chrom,
                      values_from = meanDepth),
          "../2020-01-08_tomov-and-bp-test/working-data/mean-read-depth-wider_ACMV-EACMCV_2020-01-flowcell.csv")
}
