
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
    function(vectorOfFileNames, ##<< e.g. dir(.., full.names = TRUE)
             libraryIDs,        ##<< e.g. file name prefix
             numRefSequencesOfInterest = 9, ##<< Lump all the others together
             totalNumRefSequences = 908,    ##<< Could easily determine automatically
             sumThemUp = TRUE,    ##<< Sum ACMV + EACMCV, DNA-A + DNA-B, etc.
             ...)
{
    numLibraries = length(vectorOfFileNames)

    idxstatList <- vector("list", numLibraries)
    virusMappingList <- vector("list", numLibraries)
    unmappedHostAssigned <- vector("list", numLibraries)
    unmappedVirusAssigned <- vector("list", numLibraries)

    hostMappingReadCount <- numeric(numLibraries)
    ## ToDo: classify slightly better
    #unmappedVirusAssigned <- numeric(numLibraries)
    #unmappedHostAssigned <- numeric(numLibraries)

    for (i in 1:numLibraries) {
        idxstatList[[i]] <- read.delim(vectorOfFileNames[i],
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
        hostRows <- idxstatList[[i]][(numRefSequencesOfInterest + 1):totalNumRefSequences, ]
        hostMappingReadCount[i] <- sum(hostRows[ , 3])
        unmappedHostAssigned[i] <- sum(hostRows[ , 4])

        unmappedVirusAssigned[i] <- sum(
            idxstatList[[i]][1:numRefSequencesOfInterest,
                             4])
    }

    virusMappingDf <- do.call(rbind, virusMappingList)

    virusMappingDf$filePrefix <- rep(libraryIDs, each = numRefSequencesOfInterest + 1)

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
                               "SEGS1" = AY836366.1,
                               "SEGS2" = AY836367.1,
                               phiX174 = "phi-X174_NC_001422.1",
                               CaLCuV_A = "CaLCuV_DNA-A",
                               CaLCuV_B = "CaLCuV_DNA-B",
                               )

    #' Ugh!
    virusMappingWide$unmapped <- virusMappingDf$numUnmappedReads[10 * (1:numLibraries)]

    if (sumThemUp) {
    virusMappingWide <-
        mutate(virusMappingWide,
               readsACMV = ACMV_A + ACMV_B,
               readsEACMCV = EACMCV_A + EACMCV_B,
               virusReads = readsACMV + readsEACMCV,
               mappedReads = virusReads + SEGS1 + SEGS2 + host,
               ## The following is NOT complete,
               ## because
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
    vectorOfFileNames <- inputTables20190523
    libraryIDs <- 1:21
    #vectorOfFileNames <- inputTables20190705
    #libraryIDs <- filePrefixes20190705
}
