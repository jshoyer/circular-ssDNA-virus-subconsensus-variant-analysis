
libraryToPlant_20200406_temperature <-
    read.delim("library-to-plant-table_temperature-veg2.txt")

source("read-in-metadata_temperature-veg2_part2.R")

metadata_20200406_temperature <-
    left_join(libraryToPlant_20200406_temperature,
              plantMetadataSlim,
              by = "plantID")

#write.csv(metadata_20200406_temperature, "metadata_20200406_temperature.csv")

metadata_20200406_temperature_nonredundant <-
    filter(metadata_20200406_temperature,
           replicateCode == "A")
metadata_20200406_temperature_nonredundant <-
    select(metadata_20200406_temperature_nonredundant,
           -replicateCode, -libraryFastQfilePrefix)
