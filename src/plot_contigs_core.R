#!/usr/bin/env R

library(ggplot2)

metadata <- read.csv(file="analyses/metadata_all.txt", header=TRUE, sep="\t", row.names = 1)

#guides are named by the attributes within the aes()
scatter <- ggplot(metadata, aes(contigs,core)) + geom_point(aes(colour=subspecies, size=10, alpha=0.5)) + theme_bw() + theme(title = element_text(size=20), axis.text = element_text(size=20), legend.text=element_text(size=15)) + scale_x_continuous(name = "No. Contigs") + scale_y_continuous(name="No. Species Specific Regions") + guides(subspecies = guide_legend(), size = "none", alpha="none")



png("analyses/core_vs_contigs.png", width=1000, height=1000)
scatter
dev.off()
