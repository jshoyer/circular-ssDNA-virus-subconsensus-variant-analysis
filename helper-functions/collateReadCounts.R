
# Adapted from read-count-helper-functions.R
# starting on 2019-05-24

#' These helper function assume that input tables
#' from samtools idxstats
#' are in a very specific format.
#' This required revision of the function.
#' See ../2019-05-22_seq-capture-ms/work-up-read-counts-and-variant-calls.R
#' for relatively simple example input data.

library(dplyr)
library(tidyr)

#idxSuffix <- "_defaults_with-host_idxstats.tsv"

collateReadCounts <-
    function(filePaths, ##<< e.g. dir(.., full.names = TRUE)
             filePrefixes,        ##<< e.g. file name prefix
             numRefSequencesOfInterest = 9, ##<< Lump all the others together
             totalNumRefSequences = 908,    ##<< Could easily determine automatically
             sumThemUp = TRUE,    ##<< Sum ACMV + EACMCV, DNA-A + DNA-B, etc.
             ...)
{
    numFiles = length(filePaths)

    idxstatList <- vector("list", numFiles)
    virusMappingList <- vector("list", numFiles)
    unmappedHostAssigned <- vector("list", numFiles)
    unmappedVirusAssigned <- vector("list", numFiles)

    hostMappingReadCount <- numeric(numFiles)
    ## ToDo: classify slightly better
    #unmappedVirusAssigned <- numeric(numFiles)
    #unmappedHostAssigned <- numeric(numFiles)

    for (i in 1:numFiles) {
        ## Should error-check here: throw an error if the file is empty.
        idxstatList[[i]] <- read.delim(filePaths[i],
                                       header = FALSE,
                                       col.names = c("refSequenceName",
                                                     "refSequenceLength",
                                                     "numMappedReads",
                                                     "numUnmappedReads"))
        ##  Last column includes reads that been assigned (based on their pair)
        virusMappingList[[i]] <- idxstatList[[i]][c(1:numRefSequencesOfInterest,
                                                    totalNumRefSequences + 1),  ## Unmapped unassigned
                                                                                ## * row
                                                  ]
        ## Problem here (I think) when host is omitted:
        ## very last row gets called as host.
        hostRows <- idxstatList[[i]][(numRefSequencesOfInterest + 1):totalNumRefSequences, ]
        hostMappingReadCount[i] <- sum(hostRows[ , 3])
        unmappedHostAssigned[i] <- sum(hostRows[ , 4])

        ## (consider renaming this, if I ever use it)
        unmappedVirusAssigned[i] <- sum(
            idxstatList[[i]][1:numRefSequencesOfInterest,
                             4])
    }

    virusMappingDf <- do.call(rbind, virusMappingList)

    virusMappingDf$filePrefix <- rep(filePrefixes, each = numRefSequencesOfInterest + 1)

    virusMappingSelected <- select(virusMappingDf,
                                   filePrefix,
                                   refSequenceName, numMappedReads,)
    virusMappingWide <-
        spread(virusMappingSelected, refSequenceName, numMappedReads)

    virusMappingWide <- select(virusMappingWide, -"*")
    virusMappingWide$host <- hostMappingReadCount

    virusMappingWide <- select(virusMappingWide,
                               "libraryFastQfile" = filePrefix,
                               "ACMV_A" =  "ACMV_DNA-A_v2",
                               "ACMV_B" =  "ACMV_DNA-B_v3",
                               "EACMCV_A" = "EACMCV_DNA-A",
                               "EACMCV_B" = "EACMCV_DNA-B",
                               host = host,
                               "SEGS1" = "SEGS-1_AY836366",
                               "SEGS2" = "SEGS-2_AY836367",
                               phiX174 = "phiX174_J02482",
                               CabLCV_A = "CabLCV_DNA-A",
                               CabLCV_B = "CabLCV_DNA-B",
                               E_coli = "CP001637.1",
                               TYLCV = TYLCV_AF024715,
                               ToMoV_A = "ToMoV_DNA-A_L14460",
                               ToMoV_B = "ToMoV_DNA-B_L14461",
                               pUC119 = "pUC119_BamHI-to-HindIII-inclusive",
                               )

    #' Ugh!
    virusMappingWide$unmapped <-
        virusMappingDf$numUnmappedReads[
                       (numRefSequencesOfInterest + 1) * (1:numFiles)]

    if (sumThemUp) {
    virusMappingWide <-
        mutate(virusMappingWide,
               readsACMV = ACMV_A + ACMV_B,
               readsEACMCV = EACMCV_A + EACMCV_B,
               virusReads = readsACMV + readsEACMCV,
               mappedReads = virusReads + SEGS1 + SEGS2 + host +
                   phiX174 + E_coli + pUC119 +
                   CabLCV_A + CabLCV_B + TYLCV + ToMoV_A + ToMoV_B,
               ## The following is NOT complete,
               ## because unmappedVirusAssigned is missing.
               #totalReads = mappedReads + unmapped,
               readsACMV_A_rel = ACMV_A/mappedReads,
               readsEACMCV_A_rel = EACMCV_A/mappedReads,
               readsVirus_rel   = virusReads/mappedReads,
               )
    }

    return(virusMappingWide)
}

attr(collateReadCounts, 'ex') <- function() {  #  Examples:
    #' Cf. ../2019-05-22_seq-capture-ms/work-up-read-counts-and-variant-calls.R

    inputFilePath20190523 <-
        "../2019-05-22_seq-capture-ms/2019-05-23_tables"

    inputTables20190523 <-
        dir(inputFilePath20190523,
            pattern = "_with-host_unique_idxstats.tsv",
            full.names = TRUE)
    filePaths <- inputTables20190523
    filePrefixes <- 1:21
    #filePaths <- inputTables20190705
    #filePrefixes <- filePrefixes20190705
}
