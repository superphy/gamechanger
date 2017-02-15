#!/usr/bin/env R

library(ape)
library(ggtree)
library(RColorBrewer)


#brew me up some fresh color
bColor <- c(brewer.pal(n=8, name = "Dark2"), brewer.pal(n=3, name="Pastel1"))


#core tree based on 4501 core
#tree <- read.tree(file="analyses/panseq_cdhit_senterica_core/raxml_best_tree_with_names.tre")

#binary tree of whole pan-genome
tree <- read.tree(file="analyses/panseq_cdhit_senterica/raxml_best_tree_with_names_root.tree")
#tree

badData <- read.csv(file="analyses/poor_quality.txt", header=FALSE)
badGenomes <- as.vector(badData[,1])

tree <- drop.tip(tree, badGenomes)
#tree

#text labels for genomes
metadata <- read.csv(file="analyses/metadata_final.csv", header=TRUE, sep="\t")

#binary pan-genome matrix
#matrix of binary data to display
binary.data <- read.csv(file="analyses/405_species_specific_regions/405_binary_table.txt", sep="\t", row.names=1, header=TRUE)

t.binary.data <- t(binary.data)

out.tree <- ggtree(tree)


#attach the metadata
out.tree <- out.tree %<+% subset(metadata,serovar %in% c("Typhi","Typhimurium","Enteritidis","Heidelberg","Paratyphi","Kentucky","Agona","Weltevreden","Bareilly","Newport")) +
    geom_tippoint(aes(color=serovar, shape="circle", size=10))  + scale_color_manual(values=bColor) + theme(legend.text=element_text(size=20)) + guides(color = guide_legend(override.aes = list(size = 15)), shape="none", size="none", hm="none")

#attach the binary data
#the binary data is displayed as white=absence, black=presence, with a grey border around each cell
#offset and width determined from trial and error
#the column labels in ggtree can't be rotated well -- we turn them off to use geom_text() later
hm <- gheatmap(out.tree, t.binary.data, offset= 0.01, width=1, low="red", high="black", color="black", colnames=FALSE)
#%>% scale_x_ggtree()

png("analyses/senterica_pan_tree_matrix.png", width=2000, height=2000)
hm
dev.off()
