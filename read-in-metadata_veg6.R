
library(dplyr)

libraryToPlant_20200406_vegprop <-
    read.delim("library-to-plant-table_veg6.txt")

#' it may become important to distinguish
#' what went into library prep (a pooled pair of RCA reactions)
#' from the total DNA sample
#' used as input for those RCA reactions.
#' (And in principle the plants themselves,
#'  though samples were taken from each one exactly once,
#'  so that is a nonissue for this particular experiment.)

plants_20200406_vegprop <-
    read.delim("plant-table_veg6.txt")

metadata_20200406_vegprop <-
    left_join(libraryToPlant_20200406_vegprop,
              plants_20200406_vegprop,
              by = "plantID")
#' The phrase “virus only” is not good
#' for the the full plant metadata table,
#' which includes mock-inoculated plants.
#' I think it is the best phrase for figure legends though.
metadata_20200406_vegprop <-
    mutate(metadata_20200406_vegprop,
           segsTreatment2 = segsTreatment)
levels(metadata_20200406_vegprop$segsTreatment2) <-
    c("Virus only", "SEGS-1", "SEGS-2")

metadata_20200406_vegprop_nonredundant <-
    filter(metadata_20200406_vegprop,
           replicateCode == "A")
metadata_20200406_vegprop_nonredundant <-
    select(metadata_20200406_vegprop_nonredundant,
           -replicateCode, -libraryFastQfilePrefix, -sampleNum)


#' One-time construction of plant table:
if (FALSE) {
    tableByPlant_vegprop <-
        select(metadata_20200406_vegprop_nonredundant,
               -dnaSampleCode)
    tableByPlant_vegprop <- mutate(tableByPlant_vegprop,
                                   lineage = plantID,
                                   temperature = 28)
    write.table(tableByPlant_vegprop,
                "plant-table_vegetative-propagation.txt",
                sep = "\t", quote = FALSE,
                row.names = FALSE)
}
#' Checked an initial version of this table
#' (artifact 08801240b2be5f048)
#' and then edited it.
#' Cf. a more comprehensive version
#' made with examine-metadata.R
