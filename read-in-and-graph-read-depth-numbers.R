
#' This script was used in making the figure
#' for the resource announcement paper
#' and also for calculating minimum and average coverage.

library(dplyr)
library(tidyr) # v1.0.0 or higher
library(ggplot2)
theme_set(theme_minimal())

source("helper-functions/readSamtoolsDepth.R")

#' Input files were made with sbatch job scripts
inputFilePath20170822 <-
    "."  # specify another path to the tables, if desired

#' ** Read in files
depthFiles20170822 <-
    dir(inputFilePath20170822,
        pattern = "depth.txt",
        full.names = TRUE)
depthFileNames20170822 <-
    dir(inputFilePath20170822,
        pattern = "depth.txt")

depthFilePrefixes20170822 <- gsub("_depth.txt", "",
                             depthFileNames20170822)

depthList20170822 <- readSamtoolsDepth(depthFiles20170822,
                                       depthFilePrefixes20170822)

depth20170822full <- do.call(rbind, depthList20170822)

#' More reader-friendly labels:
levels(depth20170822full$chrom) <- c("CP001637.1",
                                     "pBluescript ACMV DNA-A",
                                     "pUC19 ACMV DNA-B",
                                     "pBluescript EACMCV DNA-A",
                                     "pSL1180 EACMCV DNA-B")

depth20170822_coli <- filter(depth20170822full,
                             chrom == "CP001637.1")

depth20170822_plasmid <- filter(depth20170822full,
                                chrom != "CP001637.1")

#' ** Average and minimum (over 18000-fold) coverage
min(depth20170822_plasmid$depth)
mean(depth20170822_plasmid$depth)  # 157,000-fold
median(depth20170822_plasmid$depth)

depth20170822_aa <- filter(depth20170822full,
                           chrom == "pBluescript ACMV DNA-A")
min(depth20170822_aa$depth)   # 49444
mean(depth20170822_aa$depth)
median(depth20170822_aa$depth)

depth20170822_ab <- filter(depth20170822full,
                           chrom == "pUC19 ACMV DNA-B")
min(depth20170822_ab$depth)   # only 18291
mean(depth20170822_ab$depth)
median(depth20170822_ab$depth)

depth20170822_ea <- filter(depth20170822full,
                           chrom == "pBluescript EACMCV DNA-A")
min(depth20170822_ea$depth)   # 52565
mean(depth20170822_ea$depth)
median(depth20170822_ea$depth)

depth20170822_eb <- filter(depth20170822full,
                           chrom == "pSL1180 EACMCV DNA-B")
min(depth20170822_eb$depth)   # 53609
mean(depth20170822_eb$depth)
median(depth20170822_eb$depth)

#'unique(depth20170822full$readGroup)


#' ** Figure: depth for one library for each plasmid
depth20170822_oneofeach <- filter(depth20170822_plasmid,
                                  readGroup %in% c("AA1_S1",
                                                   "AB1_S4",
                                                   "EA1_S7",
                                                   "EB1_S10"))

depth20170822_oneofeach$depth10to5th <-
    depth20170822_oneofeach$depth/100000

pdf("read-depth_20170822_one-library-for-each-of-four-plasmids.pdf",
    height = 4,
    width = 7)
ggplot(depth20170822_oneofeach) +
    geom_area(aes(pos, depth10to5th)) +
    ylim(0, 3) +
    ylab("Read depth (10^5 reads)") + xlab("Plasmid coordinate") +
    facet_grid(rows = vars(readGroup))
dev.off()

#' *** Diagram annotation: get the scale right in Adobe Illustrator
#'
#' X-axis: 482.646 pt - 57.845 pt = 424.801 --> 8000 nt
ptsPerNucleotide <- 424.801 / 8000

xScaleFactor <- 2781 / 155.74 * ptsPerNucleotide
310.24 * xScaleFactor  #  --> 294.1671 pts

#' Start coordinate for partial tandem dimer --
#' first base for each:
#' 1264
#' 1177
#' 1675
#' 1245
57.845 + 1264 * ptsPerNucleotide
57.845 + 1177 * ptsPerNucleotide
57.845 + 1675 * ptsPerNucleotide
57.845 + 1245 * ptsPerNucleotide

#' ** Sets of graphs for individual plasmids (3 libraries each)
pdf("read-depth_20170822_ACMV-DNA-A.pdf",
    height = 3,
    width = 7.5)
ggplot(depth20170822_aa) +
    geom_area(aes(pos, depth)) +
    ylab("Read depth") + xlab("Plasmid coordinate") +
    facet_grid(cols = vars(chrom),
               rows = vars(readGroup))
dev.off()

pdf("read-depth_20170822_ACMV-DNA-B.pdf",
    height = 3,
    width = 7.5)
ggplot(depth20170822_ab) +
    geom_area(aes(pos, depth)) +
    ylab("Read depth") + xlab("Plasmid coordinate") +
    facet_grid(cols = vars(chrom),
               rows = vars(readGroup))
dev.off()


pdf("read-depth_20170822_EACMCV-DNA-A.pdf",
    height = 3,
    width = 7.5)
ggplot(depth20170822_ea) +
    geom_area(aes(pos, depth)) +
    ylab("Read depth") + xlab("Plasmid coordinate") +
    facet_grid(cols = vars(chrom),
               rows = vars(readGroup))
dev.off()

pdf("read-depth_20170822_EACMCV-DNA-B.pdf",
    height = 3,
    width = 7.5)
ggplot(depth20170822_eb) +
    geom_area(aes(pos, depth)) +
    ylab("Read depth") + xlab("Plasmid coordinate") +
    facet_grid(cols = vars(chrom),
               rows = vars(readGroup))
dev.off()
