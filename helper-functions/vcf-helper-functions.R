
#' mailto:j.s.hoyer@wustl.edu
#' Started in 2018.
#'
#' I am sure that there are better ways
#' to read in VarScan output tables!

library(dplyr)
library(tidyr)

#' Clumsy method to initialize dataframe:
GT <- vector()
GQ <- vector()
SDP <- vector()
DP <- vector()
RD <- vector()
AD <- vector()
FREQ <- vector()
PVAL <- vector()
RBQ <- vector()
ABQ <- vector()
RDF <- vector()
RDR <- vector()
ADF <- vector()
ADR <- vector()

emptyDf <- data.frame(
    GT, GQ, SDP, DP, RD, AD,
    FREQ, PVAL, RBQ, ABQ, RDF, RDR, ADF, ADR)

rm( GT, GQ, SDP, DP, RD, AD,
    FREQ, PVAL, RBQ, ABQ, RDF, RDR, ADF, ADR)


readVarscanVCF <- function(filepath,
                           ...)
{
    table1 <-
        read.delim(filepath, sep = "\t", skip = 24,
                   stringsAsFactors = FALSE,
                   header = FALSE,
                   col.names = c("chrom", "pos", "id", "ref", "alt", "qual",
                                 "filter", "info", "format", "sample1"),
                   colClasses = c("factor", "integer", "factor", "character", "character", "factor",
                                  "factor", "character", "character", "character"),
                   ...)
    if (dim(table1)[1] > 0) {
    table2 <-
        read.delim(
            textConnection(table1$sample1),
            sep = ":",
            header = FALSE,
            stringsAsFactors = FALSE,
            col.names = c("GT", "GQ", "SDP", "DP", "RD", "AD",
            "FREQ", "PVAL", "RBQ", "ABQ", "RDF", "RDR", "ADF", "ADR")
        )
    } else {
        table2 <- emptyDf
    }
    return(cbind(table1, table2))
}

attr(readVarscanVCF, 'ex') <- function() {  #  Examples:
    #readVarscanVCF(
    #    "../2018-05-04_temperature/2019-01-28_tables/
    ## Pathological example:
    ## for past version of the function,
    ## if all ref or alt bases are 'T', they get interpreted as TRUE.
    readVarscanVCF(
        "../2019-02-08_temperature-a/2019-02-12_tables/cdtmp1FC_29_S29_varscan-snp.vcf.tsv")
}

getRidOfVarscanClutter <- function(dataFrame)
{
    select(dataFrame,
           -info,
           -GT,
           -GQ,
           -SDP,
           -DP,
           -RD,
           -AD,
           ##PVAL,
           -RBQ,
           -ABQ,
           -RDF,
           -RDR,
           -ADF,
           -ADR,
           -format,
           -sample1)
}

######################################################################

## Adapted from ../2018-08-31_optimization/work-up-variant-call-data.R
loopThroughVCF <-
    function(vcfPath,
             numCheck, # expected number present?
             filterByP = TRUE,
             getRidOfClutter = TRUE,
             ...)
{
    varscanTableFiles <-
        dir(vcfPath,
            pattern = "vcf",
            full.names = TRUE)

    numTables <- length(varscanTableFiles)
    if (numTables != numCheck) {  } # fail
    varscanList <- vector("list", numTables)
    libraryFilePrefixes <-
        gsub(vcfPath,
             "",
             varscanTableFiles)
    libraryFilePrefixes <- sub("/", "", libraryFilePrefixes)
    libraryFilePrefixes <-
        gsub("_varscan-indel.vcf.tsv",
             "",
             libraryFilePrefixes)
    libraryFilePrefixes <-
        gsub("_varscan-snp.vcf.tsv",
             "",
             libraryFilePrefixes)

    for (i in 1:numTables) {
        varscanList[[i]] <- readVarscanVCF(varscanTableFiles[i])
        if (dim(varscanList[[i]])[1] > 0) {
            varscanList[[i]]$libraryFilePrefix <- libraryFilePrefixes[i]
        }
    }

    varDf <- do.call(rbind, varscanList)
    # ?  varDf <- select(varDf, libraryFilePrefix, everything())
    varDf$freq100 <- as.numeric(gsub("%", "", varDf$FREQ))
    varDf$freqProp <- (varDf$freq100)/100

    if (getRidOfClutter) {
        varDf <- getRidOfVarscanClutter(varDf)
    }
    if (filterByP) {
        varDf <- filter(varDf, PVAL < 0.05)
    }
    return(varDf)
}

attr(loopThroughVCF, 'ex') <- function() {  #  Examples:
    vcfPath <- "../2018-05-04_temperature/2019-01-28_tables"
    head(loopThroughVCF(vcfPath, 130))
}

######################################################################

#idxSuffix <- "_defaults_with-host_idxstats.tsv"
