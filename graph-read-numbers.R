
library(ggplot2)
theme_set(theme_bw())
library(cowplot)
source("work-up-read-numbers.R")

#' ** All dual-inoculated plants
ggplot(readCounts20200108) +
    ylab("Number of EACMCV-mapping reads") +
    xlab("Number of ACMV-mapping reads") +
    geom_point(aes(readsACMV, readsEACMCV,
                   alpha = 0.5))
    #coord_fixed() +
    #geom_abline(intercept = 0, slope = 1, linetype = "dashed")

#' Plotting on a log scale
#' is hard to interpret
#' and does not add anything.
ggplot(readCounts20200108) +
    ylab("log10(number of EACMCV-mapping reads)") +
    xlab("log10(number of ACMV-mapping reads)") +
    geom_point(aes(log10(readsACMV), log10(readsEACMCV),
                   alpha = 0.5))


#' ** Depth of coverage
#dev.off()

#' The following
#' took several minutes.
pdf("2020-01-08-flowcell_samtools-depth.pdf",
    width = 7.5,
    height = 9)
ggplot(depth20200108) +
    geom_area(aes(pos, depth1k)) +
    facet_grid(cols = vars(chrom),
               rows = vars(readGroup)) +
    ylab("Read depth (10^3 reads)") +
    #ylim(0, 15.
    scale_x_continuous(sec.axis = dup_axis()) +
    panel_border(remove = TRUE) +
    xlab("Genomic position")
dev.off()

#' One of the two plants
pdf("KX4_2020-01-08-flowcell_read-depth.pdf",
    width = 7.5,
    height = 4.5)
ggplot(depth20200108_kx4) +
    geom_area(aes(pos, depth1k)) +
    facet_grid(cols = vars(chrom),
               rows = vars(readGroup)) +
    ylab("Read depth (10^3 reads)") +
    ylim(0, 15.5) +
    scale_x_continuous(sec.axis = dup_axis()) +
    panel_border(remove = TRUE) +
    xlab("Genomic position")
dev.off()
