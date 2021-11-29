
#' mailto:j.s.hoyer@wustl.edu
#' Started 2019-08-21

library(lattice)
library(ggplot2)
theme_set(theme_bw())

named_vec <- c("none" = "black",
               "CP_Ser56Asn" = "#309432",  # dark green
               "Rep_L145" = "darkorchid2",
               "Iteron" = "red")
#' Using both red and green is potentially not colorblind-friendly.
#' However, the data points are far apart
#' and the (fully saturated) colors differ in the HSV value channel.
color_scale <- scale_color_manual(values = named_vec)

readr::local_edition(1)
source("../2017-08-03_calcuv/work-up-variant-calls.R")

#' No spontaneous mutations on DNA-B
#' became majority variants:
filter(variants20170803dnaB, freqProp > 0.5) %>%
    select(libraryFilePrefix, pos, ref, alt, freqProp) %>%
    arrange(desc(freqProp))

#' Mutations swept to high levels in two plants,
#' while other putative majority variants
#' must be interpreted cautiously:
filter(variants20170803dnaA, freqProp > 0.5) %>%
    select(libraryFilePrefix, pos, ref, alt, freqProp) %>%
    arrange(desc(freqProp))


filter(variants20170803dnaB, freqProp > 0.1) %>%
    select(libraryFilePrefix, pos, ref, alt, freqProp) %>%
    arrange(pos, libraryFilePrefix)

filter(variants20170803dnaA, freqProp > 0.1) %>%
    select(libraryFilePrefix, pos, ref, alt, freqProp) %>%
    arrange(pos, libraryFilePrefix)


#' Useful, but too busy/too many colors:
ggplot(variants20170803sans13) +
    geom_point(aes(pos, freqProp, color = libraryFilePrefix)) +
    facet_grid(vars(chrom)) +
    ylab("Variant allele frequency") + xlab("Genomic position")


######################################################################
dev.new(width = 7.25, height = 9.75)

ggplot(variants20170803_001) +
    geom_point(aes(pos, freqProp, alpha = 0.5, color = special_interest)) +
    color_scale +
    facet_grid(vars(libraryFilePrefix), vars(chrom)) +
    scale_y_continuous(limits = c(0, 1), breaks = c(0, 0.5, 1)) +
    guides(fill = FALSE, alpha = FALSE) +
    ylab("Variant allele frequency") + xlab("Genomic position") +
    theme(legend.position = "top")

ggplot(variants20170803sans13) +
    geom_point(aes(pos, freqProp, alpha = 0.5)) +
    facet_grid(vars(libraryFilePrefix), vars(chrom)) +
    ylim(c(0, 1)) +
    guides(fill = FALSE, alpha = FALSE) +
    ylab("Variant allele frequency") + xlab("Genomic position")
######################################################################


ggplot(variants20170803dnaA) +
    geom_point(aes(pos, freqProp, alpha = 0.5)) +
    facet_wrap(vars(libraryFilePrefix)) +
    ylim(c(0, 1)) +
    ylab("Variant allele frequency") + xlab("Genomic position")

## 2020-02-06:
#dev.new(width = 10.21097, height = 4.522917)
ggplot(variants20170803dnaB) +
    geom_point(aes(pos, freqProp, alpha = 0.5)) +
    facet_wrap(vars(libraryFilePrefix)) +
    ylim(c(0, 1)) +
    xlim(c(0, 2583)) +
    ylab("Variant allele frequency") + xlab("Genomic position")
