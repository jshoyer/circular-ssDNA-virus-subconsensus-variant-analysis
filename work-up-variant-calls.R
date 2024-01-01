
#' Input 1: metadata tables
source("read-in-metadata_veg6.R")

#' Input 2: VCF files,
#' generated with sbatch job scripts:
inputFilePath20200406 <-
    "../2020-04-06_vegprop-and-temp-4/2020-04-07_tables"

#' Other input: library-to-plant-table_temperature-veg2.txt
source("read-in-metadata_temperature-veg2.R")

source("helper-functions/vcf-helper-functions.R")

variants20200406 <-
    loopThroughVCF(inputFilePath20200406,
                   getRidOfClutter = FALSE,
                   numCheck = 44)

#' Some VCF columns are currently only useful for troubleshooting:
variants20200406 <- select(variants20200406,
                           -info, -format, -sample1,
                           -id, -qual, -filter)
#with(variants20200406, table(libraryFilePrefix))

variants20200406 <-
    mutate(variants20200406,
           #dnaSampleCode = substr(libraryFilePrefix, 1, 8),
           dnaSampleCode = sub("[AB]", "", libraryFilePrefix),
           variantID = paste0(chrom, "_", ref, pos, alt),
           variantPos = paste0(chrom, "_", pos))

variants20200406_temperature <- left_join(metadata_20200406_temperature,
                                          variants20200406,
                                          by = "dnaSampleCode")

variants20200406_temperature <-
    mutate(variants20200406_temperature,
           observation = paste0(chrom, ref, pos, alt, plantID),
           observationByLineage = paste0(chrom, ref, pos, alt, lineage))

#' Replicates arbitrarily designated A and B
variants20200406_replicateA <- filter(variants20200406,
                                      grepl("A", libraryFilePrefix))

variants20200406_replicateB <- filter(variants20200406,
                                      grepl("B", libraryFilePrefix))
#' (could also use the ‘replicate code’ column introduced below.)

variants20200406_wider1 <-
    full_join(variants20200406_replicateA,
              variants20200406_replicateB,
              by = c("chrom", "pos", "ref", "alt",
                     "dnaSampleCode",
                     ##"plantID",
                     "virusCalledAgainst", "segmentCalledAgainst",
                     "variantID", "variantPos"),
              suffix = c("ReplicateA", "ReplicateB"))
#with(variants20200406_wider1, table(dnaSampleCode))

variants20200406_wider1 <- select(variants20200406_wider1,
                                  -libraryFilePrefixReplicateA,
                                  -libraryFilePrefixReplicateB)

variants20200406_wider1 <-
    mutate(variants20200406_wider1,
           observation = paste0(chrom, ref, pos, alt, dnaSampleCode),
           #observationByLineage = paste0(chrom, ref, pos, alt, lineage),
           freqPropMean =
               rowSums(cbind(freqPropReplicateA,
                             freqPropReplicateB)/2),
           freqPropMeanNoNA =
               rowSums(cbind(freqPropReplicateA,
                             freqPropReplicateB),
                       na.rm = TRUE)/2)

#' We will probably want
#' to analyze the temperature and vegetative propagation experiments
#' both separately and jointly.
#' One approach:
#' explicitly split data from the two experiments.
#' Make sure the control libraries are removed before here:
if (FALSE) {

variants20200406_temperature_wider1 <- filter(variants20200406_wider1,
                                              grepl("M", dnaSampleCode))
variants20200406_vegProp_wider1 <- filter(variants20200406_wider1,
                                          grepl("X", dnaSampleCode))
}
#' Second approach: left_join
variants20200406_vegprop <- left_join(metadata_20200406_vegprop,
                                      variants20200406,
                                      #by = "dnaSampleCode")
                                      by = c("libraryFastQfilePrefix" =
                                                 "libraryFilePrefix"))
#which(! variants20200406_vegprop$dnaSampleCode.x
#      == variants20200406_vegprop$dnaSampleCode.y)
variants20200406_vegprop <- mutate(variants20200406_vegprop,
                                   dnaSampleCode = dnaSampleCode.x)
variants20200406_vegprop <- select(variants20200406_vegprop,
                                  -dnaSampleCode.x, -dnaSampleCode.y)

variants20200406_vegprop_wider1 <-
    left_join(metadata_20200406_vegprop_nonredundant,
              variants20200406_wider1,
              by = "dnaSampleCode")

variants20200406_vegprop_0030 <- filter(variants20200406_vegprop_wider1,
                                        freqPropReplicateA >= 0.03,
                                        freqPropReplicateB >= 0.03)

variants20200406_wider1 <- select(variants20200406_wider1,
                                  -libraryFilePrefixReplicateA,
                                  -libraryFilePrefixReplicateB)

variants20200406_temperature_wider1 <- left_join(metadata_20200406_temperature_nonredundant,
                                                 variants20200406_wider1,
                                                 by = "dnaSampleCode")

variants20200406_temperature_wider1 <-
    mutate(variants20200406_temperature_wider1,
           observation = paste0(chrom, ref, pos, alt, plantID),
           observationByLineage = paste0(chrom, ref, pos, alt, lineage),
           freqPropMean =
               rowSums(cbind(freqPropReplicateA,
                             freqPropReplicateB)/2),
           freqPropMeanNoNA =
               rowSums(cbind(freqPropReplicateA,
                             freqPropReplicateB),
                       na.rm = TRUE)/2)


#' Filter based on estimated allele frequency
variants20200406_temperature_0010 <-
    filter(variants20200406_temperature_wider1,
           freqPropReplicateA >= 0.01,
           freqPropReplicateB >= 0.01)

variants20200406_temperature_0010_one <-
    filter(variants20200406_temperature_wider1,
           freqPropReplicateA >= 0.01 |
           freqPropReplicateB >= 0.01,
           ! is.na(freqPropReplicateA),
           ! is.na(freqPropReplicateB))

variants20200406_temperature_0030 <-
    filter(variants20200406_temperature_wider1,
           freqPropReplicateA >= 0.03,
           freqPropReplicateB >= 0.03)

variants20200406_temperature_0030_one <-
    filter(variants20200406_temperature_wider1,
           freqPropReplicateA >= 0.03 |
           freqPropReplicateB >= 0.03,
           ! is.na(freqPropReplicateA),
           ! is.na(freqPropReplicateB))

variants20200406_temperature_0500 <- filter(variants20200406_temperature_wider1,
                                            freqPropReplicateA >= 0.5,
                                            freqPropReplicateB >= 0.5)

#' Write tables
if (FALSE) {
    write.csv(variants20200406_temperature_0030_one,
              "variant-calls-at-least-3percent_temperature-expt_2020-04-07_tables.csv")
    write.csv(variants20200406_temperature_wider1,
              "variant-calls_temperature-expt_2020-04-07_tables.csv")
}

#' Write tables
if (FALSE) {
    write.csv(variants20200406_vegprop_0030,
              "variant-calls-at-least-3percent_vegprop-expt_2020-04-07_tables_v2.csv")
    write.csv(variants20200406_vegprop_wider1,
              "variant-calls_vegprop-expt_2020-04-07_tables.csv")
}
