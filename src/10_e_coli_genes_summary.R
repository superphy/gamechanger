#!/usr/bin/env R

library(ggplot2)

#this is the pres / abs of the "conserved genome fragments" among the 2324 genomes
tableData <- read.table(file='core_counts_2324/binary_table.txt', header=TRUE,sep="\t",row.names=1)

#this is the pres / abs of the "e coli specific fragments" among the 2324 genomes
speciesTableData <- read.table(file='species_specific_check/binary_table.txt', header=TRUE, sep="\t", row.names=1)

#this is the contig count for each genome, as well as the size of the genome
contigCountData <- as.matrix(read.table(file='number_contigs_genomes_2324.txt', sep="\t", header=FALSE, row.names=1))

conservedGenomeSums <- as.matrix(colSums(tableData))
speciesSpecificSums <- as.matrix(colSums(speciesTableData))

cRn <- row.names(conservedGenomeSums)
sRn <- row.names(speciesSpecificSums)
countRn <- row.names(contigCountData)

#check that all of the same names are used in both tables
#there should be no difference among the sets
setdiff(cRn, countRn)

#data needs to be also be in the same order
finalData <- cbind(conservedGenomeSums, speciesSpecificSums, contigCountData)

colnames(finalData) <- c('conserved','specific','contigs','genome_size')
head(finalData)

#To get the specis italicized, need to use expressions
xAxisTitle <- expression(paste("No. of ", italic("E. coli "), "species-specific regions"))
yAxisTitle <- "No. of conserved\ncore genome regions"
p <- ggplot(as.data.frame(finalData), aes(specific,conserved))
p <- p + geom_point(alpha=0.33, colour="red", aes(size=genome_size / contigs / 1000000))  + scale_x_discrete(xAxisTitle, breaks=c(0:10)) + scale_y_continuous(yAxisTitle) + scale_size_area(guide_legend(title = "Genome size (Mbp)\n/ No. Contigs")) + theme_minimal()

ggsave(file="specific_scatter.png")


#save output as table in file
write.table(finalData, file="genome_quality_e_coli_specific.txt", quote=FALSE, sep="\t")