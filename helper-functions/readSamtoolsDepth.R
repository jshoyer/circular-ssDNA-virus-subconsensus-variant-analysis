
#' Started 2019-11-07

readSamtoolsDepth <- function(filePaths,
                              filePrefixes,
                              ...)
{
    numFiles <- length(filePaths)
    depthList <- vector("list", numFiles)
    for (i in 1:numFiles) {
        depthList[[i]] <-
            read.delim(filePaths[i],
                       sep = "\t", header = FALSE,
                       col.names = c("chrom", "pos", "depth"),
                       ...)
        depthList[[i]]$readGroup <-
            rep(filePrefixes[i],
                dim(depthList[[i]])[1])
    }
    return(depthList)
    #do.call(rbind, depthList)
}
