#!/usr/bin/env R

library(ggtree)

#core tree based on 4501 core
#tree <- read.tree(file="analyses/panseq_cdhit_senterica_core/raxml_best_tree_with_names.tre")

#binary tree of whole pan-genome
tree <- read.tree(file="analyses/panseq_cdhit_senterica_core/raxml_best_tree_with_names_bad_removed.tre")

#text labels for genomes
metadata <- read.csv(file="analyses/metadata_final.csv", header=TRUE, sep="\t")

#binary pan-genome matrix
#matrix of binary data to display
binary.data <- read.csv(file="analyses/405_species_specific_regions/405_binary_table.txt", sep="\t", row.names=1, header=TRUE)

t.binary.data <- t(binary.data)

out.tree <- ggtree(tree)


#attach the metadata
out.tree <- out.tree %<+% metadata +
    geom_tippoint(aes(color=subspecies, shape="circle", size=10))

#attach the binary data
#the binary data is displayed as white=absence, black=presence, with a grey border around each cell
#offset and width determined from trial and error
#the column labels in ggtree can't be rotated well -- we turn them off to use geom_text() later
hm <- gheatmap(out.tree, t.binary.data, offset= 0.1, width=1, low="red", high="black", color="black", colnames=FALSE)
#%>% scale_x_ggtree()

png("analyses/subspecies_tree_matrix.png", width=2000, height=2000)
hm
dev.off()
