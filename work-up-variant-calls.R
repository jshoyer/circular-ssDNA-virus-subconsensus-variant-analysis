
#' mailto:j.s.hoyer@wustl.edu

#' Inputs:
#' annotated VCF files
#'
#' Outputs:
#' collated tables of variant calls,
#' optionally written to disk:
writeOutputTables <- FALSE

source("helper-functions/vcf-helper-functions.R")


inputFilePath20170803 <- "../2017-08-03_calcuv/2019-11-19_tables"

######################################################################

readr::local_edition(1)
variants20170803 <-
    loopThroughVCF(inputFilePath20170803,
                   13 * 2,    # <-- still need to check/fix the numCheck argument
                   filterByP = FALSE,
                   getRidOfClutter = FALSE)
#' Currently this only works if the file path
#' includes annotated VCF files and NOT their not-annotated parent VCF files

#variants20170803$flowcell <- "2017-08-03" OR 2017-02-10

#' Some VCF columns are only useful for troubleshooting:
variants20170803 <- select(variants20170803,
                           -info, -format, -sample1)

variants20170803 <- mutate(variants20170803,
                           allele = paste0(chrom, pos, ref, "to", alt))

#' Positions of special interest:
variants20170803$special_interest <- "none"
variants20170803$special_interest[
  variants20170803$chrom == "CabLCV_DNA-A" &
  variants20170803$pos == 327] <- "CP_Ser56Asn"
variants20170803$special_interest[
  variants20170803$chrom == "CabLCV_DNA-A" &
  variants20170803$pos %in% 2005:2007] <- "Rep_L145"
variants20170803$special_interest[
  variants20170803$chrom == "CabLCV_DNA-B" &
  variants20170803$pos %in% 2386:2394] <- "Iteron"

## Few reads for 13_S7
# because that is a plasmid library.
# open 2019-08-20_tables/13_S7_*.vcf.tsv
variants20170803sans13 <- filter(variants20170803,
                                 libraryFilePrefix != "13_S7")
variants20170803sans13 <- filter(variants20170803sans13,
                                 libraryFilePrefix != "12_S6")

variants20170803_12 <-

    filter(variants20170803,
           #freqProp > 0.5,
           libraryFilePrefix == "12_S6") %>%
    arrange(freqProp)

variants20170803_13 <-

    filter(variants20170803,
                              #freqProp > 0.5,
           libraryFilePrefix == "13_S7") %>%
    arrange(freqProp)

variants20170803dnaA <- filter(variants20170803sans13, chrom == "CabLCV_DNA-A")
variants20170803dnaB <- filter(variants20170803sans13, chrom == "CabLCV_DNA-B")

variants20170803slim <- select(variants20170803sans13,
                               chrom, pos, ref, alt, allele,
                               geneName, aminoAcidEffect, effect,
                               geneName2, aminoAcidEffect2, effect2,
                               freqProp,
                               freq100,
                               special_interest,
                               libraryFilePrefix)

variants20170803spread <-
    select(variants20170803slim, -freq100) %>%
    spread(libraryFilePrefix, value = freqProp)

#' In percentage format, for humans (written below)
variants20170803spread2A <-
    select(variants20170803slim, -freqProp) %>%
    filter(chrom == "CabLCV_DNA-A") %>%
    arrange(pos) %>%
    spread(libraryFilePrefix, value = freq100)
variants20170803spread2B <-
    select(variants20170803slim, -freqProp) %>%
    filter(chrom == "CabLCV_DNA-B") %>%
    arrange(pos) %>%
    spread(libraryFilePrefix, value = freq100)

#' ** Variants present at 1% or higher:
variants20170803_001 <- filter(variants20170803slim,
                               freq100 >= 1)
variants20170803spread_001 <-
    select(variants20170803_001, -freq100) %>%
    spread(libraryFilePrefix, value = freqProp)

#' NB: some libraries have no variants above 1% detected!

variants20170803spread2A_001 <-
    select(variants20170803_001, -freqProp) %>%
    filter(chrom == "CabLCV_DNA-A") %>%
    arrange(pos) %>%
    spread(libraryFilePrefix, value = freq100)
variants20170803spread2B_001 <-
    select(variants20170803_001, -freqProp) %>%
    filter(chrom == "CabLCV_DNA-B") %>%
    arrange(pos) %>%
    spread(libraryFilePrefix, value = freq100)


######################################################################

writeWorkedUpVariantCalls20170803 <- function()
{
    workingData20170803 <- "../2017-08-03_calcuv/working-data"

    write.csv(
        variants20170803spread2A,
        "variant-call-matrix-CabLCV-DNA-A_2017-08-03-flowcell_2019-11-19-tables.csv",
        na = "")
    write.csv(
        variants20170803spread2B,
        "variant-call-matrix-CabLCV-DNA-B_2017-08-03-flowcell_2019-11-19-tables.csv",
        na = "")

    write.csv(
        variants20170803spread2A_001,
        "variant-call-1%-matrix-CabLCV-DNA-A_2017-08-03-flowcell_2019-11-19-tables.csv",
        na = "")
    write.csv(
        variants20170803spread2B_001,
        "variant-call-1%-matrix-CabLCV-DNA-B_2017-08-03-flowcell_2019-11-19-tables.csv",
        na = "")

    write.csv(
        variants20170803,
        "variant-calls-2017-08-03-flowcell_2019-11-19-tables.csv")
}

if (writeOutputTables) {
    writeWorkedUpVariantCalls20170803()
}
