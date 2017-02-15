#!/usr/bin/env R
library(ggplot2)

 data <- read.table('analyses/senterica_species_specific_binary_table.txt', sep="\t", header=TRUE, row.names=1)


cVals <- sort(colSums(data))
cn <- seq(1,length(cVals),1)
rVals <- rowSums(data)

gData <- data.frame(names=cn,theValues=cVals)

#order the factors from high to low

#gData$names <- factor(gData$names, levels=gData$names[order(gData$theValues)])


p <- ggplot(gData, aes(x=names, y=theValues)) + theme_light(base_size=70) + theme(axis.ticks=element_line(size=10)) + geom_point(shape=18, alpha=1/3, size=15, colour="#141411") + scale_x_continuous(name="Individual genomes", breaks=c(0,1000,2000,3000,4000,5000)) + scale_y_continuous(name="No. of S. enterica specific regions")

#+ scale_color_gradient2(low="red", high="black", midpoint=203)
#h <- ggplot(gData, aes(x=names)) + geom_histogram(binwidth=1, colour="black", fill="black")

write.table(gData, "analyses/core_output_R.txt")

png("analyses/senterica_specific_plot.png", width=2000, height=2000)
p
