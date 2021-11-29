
#' mailto:j.s.hoyer@wustl.edu
#' Started in 2018.
#'
#' I am sure that there are better ways
#' to read in VarScan output tables!

library(dplyr)
library(readr)
readr::local_edition(1)
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

geneName <- aminoAcidEffect <- effect <-
    geneName2 <- aminoAcidEffect2 <- effect2 <- vector()

emptyDf3 <- data.frame(
    geneName, aminoAcidEffect, effect,
    geneName2, aminoAcidEffect2, effect2)

rm( GT, GQ, SDP, DP, RD, AD,
    FREQ, PVAL, RBQ, ABQ, RDF, RDR, ADF, ADR,
   geneName, aminoAcidEffect, effect,
   geneName2, aminoAcidEffect2, effect2)


readAnnotatedVCF <- function(filepath,
                           ...)
{
    #print(filepath)
    table1 <-
        read.delim(filepath, sep = "\t", skip = 29,
                   stringsAsFactors = FALSE,
                   header = FALSE,
                   col.names = c("chrom", "pos", "id", "ref", "alt", "qual",
                                 "filter", "info", "format", "sample1"),
                   colClasses = c("factor", "integer", "factor", "character", "character", "factor",
                                  "factor", "character", "character", "character"),
                   ...)
    #numRows <- dim(table1)[1]
    if (dim(table1)[1] > 0) {
        infoTable <-
            read.delim(
                textConnection(table1$info),
                sep = ";",
                header = FALSE,
                col.names = c("ADP", "WT", "HET", "HOM", "NC", "annotations", "lossOfFunction"),
                stringsAsFactors = FALSE)
        annotationsUnparsed <- infoTable$annotations
        ## Corner case: if text string does not contain a newline,
        ## readr::read_delim assumes that it is a file name.
        ## Using readr because it does not choke
        ## on tables that start with more than 5 blank lines.
        if (dim(table1)[1] == 1) {
            annotationsUnparsed <- paste0(annotationsUnparsed, "\n")
        }
        ## Not great parsing in the following.
        ## Effects on multiple genes are separated by a comma, which we ignore.
        annTable <-
            read_delim(
                annotationsUnparsed,
                delim = "|",
                skip_empty_rows = FALSE,
                col_names = c("altAllele", "effect", "putativeImpact",
                              "geneName", "geneID", "featureType",
                              "featureID", "transcriptBiotype", "exonIntronRank",
                              "HGVS.c", "aminoAcidEffect", "cDNApos", "CDSpos", "protPos", "distanceToFeat",
                              "altAllele2", "effect2", "putativeImpact2",
                              "geneName2", "geneID2", "featureType2",
                              "featureID2", "transcriptBiotype2", "exonIntronRank2",
                              "HGVS.c2", "aminoAcidEffect2", "cDNApos2", "CDSpos2", "protPos2", "distanceToFeat2",
                              "errors"))
        ## readr skips last row if it is blank,
        ## causing off-by-one error.
        diffDimensions <- dim(annTable)[1] < dim(table1)[1]
        if (diffDimensions == 1) {
            annTable <- rbind(annTable, rep(NA, 31))
        } else if (diffDimensions > 1) {
            stop()
        }
        table3 <- select(annTable,
                         geneName, aminoAcidEffect, effect,
                         geneName2, aminoAcidEffect2, effect2)
        table3$aminoAcidEffect <- sub("p.", "", table3$aminoAcidEffect)
        table3$aminoAcidEffect2 <- sub("p.", "", table3$aminoAcidEffect2)
        ##
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
        table3 <- emptyDf3
        ## I do not think I'll ever need infoTable
        ## or (unparsed) annTable.
    }
    return(cbind(table1, table2, table3))
}
#' Watch out for WARNING_REF_DOES_NOT_MATCH_GENOME

attr(readAnnotatedVCF, 'ex') <- function() {  #  Examples:
    #readAnnotatedVCF(
    #    "../2018-05-04_temperature/2019-01-28_tables/
    ## Pathological example:
    ## for past version of the function,
    ## if all ref or alt bases are 'T', they get interpreted as TRUE.
    readAnnotatedVCF(filepath =
        "../2017-08-03_calcuv/2019-11-19_tables/10_S4_L001_snp.ann.vcf.tsv")
    #filepath = "../2017-08-03_calcuv/2019-11-19_tables/10_S4_L001_indel.ann.vcf.tsv"
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
        gsub("_L001_varscan-indel.vcf.tsv",
             "",
             libraryFilePrefixes)
    libraryFilePrefixes <-
        gsub("_L001_varscan-snp.vcf.tsv",
             "",
             libraryFilePrefixes)
    libraryFilePrefixes <-
        gsub("_L001_indel.ann.vcf.tsv",
             "",
             libraryFilePrefixes)
    libraryFilePrefixes <-
        gsub("_L001_snp.ann.vcf.tsv",
             "",
             libraryFilePrefixes)

    for (i in 1:numTables) {
        varscanList[[i]] <- readAnnotatedVCF(varscanTableFiles[i])
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
    vcfPath <- "../2017-08-03_calcuv/2019-11-19_tables"
    head(loopThroughVCF(vcfPath, 130))
}

######################################################################

#idxSuffix <- "_defaults_with-host_idxstats.tsv"
