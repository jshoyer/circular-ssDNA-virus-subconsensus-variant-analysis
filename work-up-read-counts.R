
#' mailto:j.s.hoyer@wustl.edu

#' Inputs:
#' idxstats tables
#'
#' Outputs:
#' a collated table of read counts,
#' optionally written to disk:
writeOutputTables <- FALSE

source("helper-functions/collateReadCounts.R")


inputFilePath20170803 <- "../2017-08-03_calcuv/2019-11-19_tables"

fileNames20170803 <- dir(
    inputFilePath20170803,
    pattern = "idxstats.tsv",
    )
filePaths20170803 <- dir(
    inputFilePath20170803,
    full.names = TRUE,
    pattern = "idxstats.tsv",
    )

filePrefix20170803 <-
    gsub("_L001_defaults_with-host_no-supp_idxstats.tsv",
         "",
         fileNames20170803)
#' Potential for confusion: two "S7" libraries (one on each flowcell).
#' In this case we do not need to get rid of any prefix.

#' One option:
#' Drop the plasmid libraries for most purposes:
#filePaths20170803 <- filePaths20170803[c(-12, -13)]
#filePrefix20170803 <- filePrefix20170803[c(-12, -13)]

readCounts20170803 <-
    collateReadCounts(filePaths20170803,
                      libraryIDs = filePrefix20170803,
                      numRefSequencesOfInterest = 3,
                      totalNumRefSequences = 10,
                      sumThemUp = FALSE)

######################################################################

writeWorkedUpReadCounts20170803 <- function()
{
    workingData20170803 <- "../2017-08-03_calcuv/working-data"
    write.csv(
        readCounts20170803,
        "read-counts_2017-08-03-flowcell_2019-11-19-tables.csv")

}

if (writeOutputTables) {
    writeWorkedUpReadCounts20170803()
}
