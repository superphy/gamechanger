#!/usr/bin/env R
library(ggplot2)

data <- read.csv(file="data/panseq_cdhit_senterica/binary_table.txt", sep="\t", header=TRUE, row.names=1)

rSums <- rowSums(data)
print(hist(rSums, xlim=c(0,5000), breaks=100))

png("histogram_senterica.png", width=2000, height=2000)
ggplot(data, aes(x=rSums)) + geom_histogram(binwidth= 100, colour="white", fill="black") + theme(panel.background = element_rect(fill = 'white', colour = 'black'), text = element_text(size=80), axis.text.x = element_text(angle=90, hjust=0, size=50, vjust=0), axis.title.x = element_text(margin = margin(t=100)), axis.text.y=element_text(size=50), axis.title.y = element_text(margin = margin(r=100)))+ scale_x_continuous(name="No. genomes", limits=c(0,5000)) + scale_y_continuous(name="No. of pan-genome regions", limits=c(0, 20000), expand=c(0,0))