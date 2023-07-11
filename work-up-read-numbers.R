
#' Just use the filenames for metadata.

library(dplyr)
library(tidyr) # v1.0.0 or higher

source("helper-functions/collateReadCounts.R")
source("helper-functions/readSamtoolsDepth.R")

inputFilePath20200108 <-
    "../2020-01-08_tomov-and-bp-test/2020-09-17_tables"

inputTables20200108 <-
    dir(inputFilePath20200108,
        pattern = "_unique_idxstats.tsv",
        full.names = TRUE)

filePrefixes20200108 <- sub(
    "../2020-01-08_tomov-and-bp-test/2020-09-17_tables/",
    "", inputTables20200108)
filePrefixes20200108 <- sub(
    "_L001_unique_idxstats.tsv",
    "", filePrefixes20200108)

readCounts20200108 <-
    collateReadCounts(
        ##filePaths =
        inputTables20200108,
        #filePrefixes =
        filePrefixes20200108,
        numRefSequencesOfInterest = 13, # backbone + 12 virus-related sequences
        numHostSequences = 13,
        sumThemUp = FALSE)

#' no plasmid controls.

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

#filePrefixes20200108 = gsub("_L001_depth.txt", "",
filePrefixes20200108 <- gsub("_depth.txt", "",
                             depthFileNames20200108)

#' both segments have reads.
#' ignore warning -- see note on planned improvement above.
depthList20200108 <- readSamtoolsDepth(depthFiles20200108,
                                       filePrefixes20200108)

depth20200108 <- do.call(rbind, depthList20200108)

depth20200108$libraryCode <- sub("_S[0-9]+", "",
                                 depth20200108$readGroup)
levels(depth20200108$chrom) <- c("ToMoV DNA-A",   "ToMoV DNA-B")
depth20200108 <- mutate(depth20200108,
                        depth1k = depth/1000)
#depth20200108 <-
#    left_join(depth20200108, libMetadata20200108slim,
#              by = "libraryCode")

#' ** Split groups
depth20200108_t2 <- filter(depth20200108, grepl("T2", libraryCode))
#' Remove "SP_", to make sort order match other panels:
depth20200108_t2$readGroup[depth20200108_t2$readGroup == "T2-SP_S7"] <- "T2_S7"
depth20200108_t2$readGroup[depth20200108_t2$readGroup == "T2-SP-2_S8"] <- "T2-2_S8"

depth20200108_not_t2 <- filter(depth20200108,
                               libraryCode %in% c("T4", "T4-2", "T4-BP", "T4-BP-2",
                                                  "T6", "T6-2", "T6-BP", "T6-BP-2",
                                                  "T7", "T7-2", "T7-BP", "T7-BP-2")
                               )

depth20200108_T6 <- filter(depth20200108_not_t2,
                            grepl("T6", libraryCode))

#' ** Average depth
readGroup <- rep(unique(depth20200108$libraryCode), each = 2)
segmentNamesOriginal <- c("ToMoV_DNA-A", "ToMoV_DNA-B")
chrom <- rep(c("DNA-A", "DNA-B"), 18)
meanDepthTable <- data.frame(readGroup, chrom)

for (j in 1:18) {
    for (i in 1:2) {
        segmentI <- filter(depthList20200108[[j]],
                           chrom == segmentNamesOriginal[i])
        meanDepthTable$meanDepth[(j - 1) * 2 + i] <-
            mean(segmentI$depth)
    }
}


#' ** Write files
if (FALSE) {
dir.create("../2020-01-08_tomov-and-bp-test/working-data")
write.csv(readCounts20200108,
          "../2020-01-08_tomov-and-bp-test/working-data/read-counts-ToMoV-libraries_2020-09-17.csv")

write.csv(meanDepthTable,
          "../2020-01-08_tomov-and-bp-test/working-data/mean-read-depth_ToMoV_2020-01-flowcell.csv")
write.csv(pivot_wider(meanDepthTable,
                      names_from = chrom,
                      values_from = meanDepth),
          "../2020-01-08_tomov-and-bp-test/working-data/mean-read-depth-wider_ToMoV_2020-01-flowcell.csv")
}
