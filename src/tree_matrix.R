#!/usr/bin/env R
library(ape)
library(ggtree)
library(RColorBrewer)

#tree generated from parsnp
tree <- read.tree(file="data/parsnp.tree")
tree

#metadata to annotate the tree with
metadata <- read.csv(file="fws_metadata_insilico.csv", sep=",", stringsAsFactors=FALSE)

#align the tree labels with dots, but hide the "matching name" because it is long and combines the name and serotype
#geom_tiplab(size=0, align=TRUE) will align the labels but not display them
#Also display the support values for the tree that are less than 1, and colour red
out.tree <- ggtree(tree, size=1) + scale_y_continuous(expand=c(0, 0.3)) + geom_tiplab(size=0, align=TRUE) + theme_tree2(axis.text.x = element_text(size=16))

#support values
out.tree <- out.tree + geom_text2(aes(subset=(!isTip & label<1), label=label), size=5, hjust="right", nudge_x=-0.005, color="red")
#out.tree <- out.tree + geom_text2(aes(subset=!isTip, label=node), hjust=-.3, color = "red")

#out.tree <-  out.tree %>% collapse(node=21)
#cp + geom_point2(aes(subset=(node == 21)), size=5, shape=23, fill="steelblue")

#matrix of binary data to display
genotype <- read.csv(file="data/STEC_AMR_compiled.csv", sep=",", row.names=1, header=TRUE)

write.table(genotype, file="dataout.txt")
#use a nice colour theme
colorScale <- brewer.pal(5,"Dark2")
#set the reference genomes to black
colorScale[3] <- "black"

#having hidden the label, add labels from the metadata for "name" and "serotype"
#x=max(x) will align the labels vertically, at the end of the tree
#colour the labels by location
out.tree <- out.tree %<+% metadata + geom_text(aes(x=max(x), label=strain, color=serotype), hjust="left", nudge_x = 0.01, size=4) + geom_text(aes(x=max(x), label=serotype, color=serotype), hjust="left", nudge_x = 0.14, size=4)

#the binary data is displayed as white=absence, black=presence, with a grey border around each cell
#offset and width determined from trial and error
#the column labels in ggtree can't be rotated well -- we turn them off to use geom_text() later
hm <- gheatmap(out.tree, genotype, offset=0.2, width=1, low="white", high="black", colnames=FALSE, color="grey") %>% scale_x_ggtree()

#the labels for the matrix columns require the correct location information, given here
df <- get_heatmap_column_position(hm, by="bottom")

png("stec_amr_hq.png", width=1500, height=2000)
#add the gene names as text, and rotate 90 degrees and align
hm + geom_text(data=df, size=5, aes(x,y,label=label), hjust=0, nudge_y=-6, angle=90)
#out.tree
dev.off()
