
library(dplyr)
library(tidyr)

#' Inputs:
#'    text files in this directory --
#'    plant metadata table, qPCR/Qubit/library tables

#' ** Plant metadata
plantMetadata <- read.delim(
              "plant-table_temperature-veg2.txt"),
    stringsAsFactors = FALSE,
    na.strings = "N/A")

#' Maybe I should just delete the last line in the file
#' (row 156,
#'  likely a copy-paste or drag-formula-down error)
#' rather than doing this:
plantMetadata <- filter(plantMetadata,
                        ! is.na(temperature))

#' End of Round 0 was complicated:
plantMetadata <- mutate(plantMetadata,
       colorOfCutting = Progated.color.of..cutting.kept..for.transplanting)
# 'no trans' --> not transplanted

#' Alternate way to label passage number
#' (round of propagation + 1):
passage1 <- plantMetadata$Date.Leaf.Sampled == "2017-06-14"
passageD <- plantMetadata$Date.Leaf.Sampled == "2017-06-16"  # Dispensable.
passage2 <- plantMetadata$Date.Leaf.Sampled == "2017-08-09"
passage3 <- plantMetadata$Date.Leaf.Sampled == "2017-09-18"
plantMetadata$passage[passageD] <- "D"  # Dispensable.
plantMetadata$passage[passage1] <- 1
plantMetadata$passage[passage2] <- 2
plantMetadata$passage[passage3] <- 3

#' Redundant and unfortunate:
plantMetadata$round <-
    as.factor(paste("Round", as.numeric(plantMetadata$passage) - 1))

plantMetadata$temperatureFac <-
    factor(paste0(plantMetadata$temperature, " °C"),
           levels = c("32 °C", "30 °C", "28 °C"))
## Opposite order from default,
## so default ggplot2 colors will match hot-cold intuition.

plantMetadataSlim <- select(plantMetadata,
                            temperature, temperatureFac,
                            virusTreatment,
                            passage, round,
                            ## direct vegetative parent:
                            directVegParent = Cuttings.taken.from.ID,
                            lineage = Replicate.s.Mother.Plant.ID,
                            Phenotype,
                            plantID = Unique.ID)

## Define differently, for convenience:
fromTissueCulture <- is.na(plantMetadataSlim$lineage)
#' Here I define the "lineage"
#' of a set of plants vegetatively propagated one from the next
#' based on the ID of the initial plant that came from tissue culture:
plantMetadataSlim$lineage[fromTissueCulture] <-
    plantMetadataSlim$plantID[fromTissueCulture]


#' ** Virus qPCR and Qubit total DNA numbers
temperatureMeta <- read.delim(
    "virus-titers-and-total-DNA_temperature-veg2.txt"),
    stringsAsFactors = FALSE)

temperatureMetaSlim <- select(temperatureMeta, plantID,
                              copyNumberA, copyNumberE)
plantMetadataSlim <- left_join(plantMetadataSlim,
                               temperatureMetaSlim,
                               by = "plantID")


#' *** Virus titers
dualBombarded <- filter(temperatureMeta,
                        !is.na(copyNumberE) & !is.na(copyNumberA))
