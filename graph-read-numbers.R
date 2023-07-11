
library(ggplot2)
theme_set(theme_bw())
library(cowplot)
source("../2020-01-08_tomov-and-bp-test/work-up-read-numbers.R")

#' ** All dual-inoculated plants
ggplot(readCounts20200108) +
    ylab("Number of DNA-B-mapping reads") +
    xlab("Number of DNA-A-mapping reads") +
    geom_point(aes(ToMoV_A, ToMoV_B,
                   alpha = 0.5)) +
    coord_fixed() +
    geom_abline(intercept = 0, slope = 1, linetype = "dashed")

#' Plotting on a log scale
#' is hard to interpret
ggplot(readCounts20200108) +
    ylab("log10(number of DNA-B-mapping reads)") +
    xlab("log10(number of DNA-A-mapping reads)") +
    geom_point(aes(log10(ToMoV_A), log10(ToMoV_B),
                   alpha = 0.5)) +
    coord_fixed() +
    geom_abline(intercept = 0, slope = 1, linetype = "dashed")


#' ** Depth of coverage
#dev.off()

pdf("read-depth-2020-01-08-flowcell_source-tomato-plant-T2.pdf",
    height = 7)
ggplot(depth20200108_t2) +
    geom_area(aes(pos, depth1k)) +
    facet_grid(cols = vars(chrom),
               rows = vars(readGroup)) +
    ylab("Read depth (10^3 reads)") +
    xlab("Genomic position") +
    panel_border(remove = TRUE) +
    scale_x_continuous(sec.axis = dup_axis())
dev.off()

pdf("read-depth-2020-01-08-flowcell_pools-whitefly.pdf",
    height = 10)
ggplot(depth20200108_not_t2) +
    geom_area(aes(pos, depth1k)) +
    facet_grid(cols = vars(chrom),
               rows = vars(readGroup)) +
    ylab("Read depth (10^3 reads)") +
    xlab("Genomic position") +
    panel_border(remove = TRUE) +
    scale_x_continuous(sec.axis = dup_axis())
dev.off()


#' Just one pool of whiteflies
pdf("T6_2020-01-08-flowcell_read-depth.pdf",
    width = 7.5,
    height = 4.5)
ggplot(depth20200108_T6) +
    geom_area(aes(pos, depth1k)) +
    facet_grid(cols = vars(chrom),
               rows = vars(readGroup)) +
    ylab("Read depth (10^3 reads)") +
    ylim(0, 15.5) +
    scale_x_continuous(sec.axis = dup_axis()) +
    panel_border(remove = TRUE) +
    xlab("Genomic position")
dev.off()
