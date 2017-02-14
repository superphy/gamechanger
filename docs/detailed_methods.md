# Detailed Materials and Methods
## Salmonella analyses
### Download of the _Salmonella genomes_
The master assembly summary file was downloaded from:

    ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/Salmonella_enterica/assembly_summary.txt

using the command:

    wget ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/Salmonella_enterica/assembly_summary.txt
   
All closed, complete genomes, and their file paths were identified using the commands suggested on the NCBI website:
    
    grep 'Complete Genome' assembly_summary.txt > closed_senterica.txt
    cut -f 20 closed_senterica.txt | sed -e 's/\(.*\)\(GCA_.*\)/ftp:\/\/ftp.ncbi.nlm.nih.gov\/genomes\/all\/\2\/\2_genomic.fna.gz/' > closed_senterica_files.txt
    
The 211 genomes thus identified were downloaded using the following command:
 
    wget -v --ftp-user=anonymous --ftp-password=chadlaing@inoutbox.com -i closed_senterica_files.txt

### Panseq analyses of the closed genomes
In order to use the GenBank accession as the strain name for subsequent analyses, the following script was run:

    perl src/single_file_check.pl data/senterica_complete/genomes/
    
The fasta files with modified headers from this process were used in all further analyses.
    
    
In order to determine a "core" set of genomic regions present in the closed _Salmonella enterica_ genomes, Panseq was run with the following settings:

    queryDirectory  /home/chad/workspace/fronvite/data/senterica_complete/genomes/
    baseDirectory   /home/chad/workspace/fronvite/analyses/seneterica_panseq/
    numberOfCores   3
    mummerDirectory /usr/bin/
    blastDirectory  /usr/bin/
    muscleExecutable    /usr/bin/muscle
    fragmentationSize   1000
    percentIdentityCutoff   90
    coreGenomeThreshold	190
    runMode pan
    overwrite   1
    nameOrId	name
    minimumNovelRegionSize  1000
    
To establish a pool of regions representative of the species, we selected a "core" to be 90% of the initial population (190 / 211).

Panseq was run with the following command:

    perl ~/workspace/Panseq/lib/panseq.pl senterica.batch
    
### Getting a cohort of non-_Salmonella enterica_ for comparsion
 
 We wished to limit the set of potential species-specific markers by screening them against a small number of diverse bacterial species.
 
    wget -v --ftp-user=anonymous --ftp-password=chadlaing@inoutbox.com ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/assembly_summary.txt

Closed genomes from closely related species were selected as follows, for each species (_Escherichia coli_, _Citrobacter_, _Shigella_, _Klebsiella_, _Staphylococcus_, _Listeria_ ):

    grep 'Complete Genome' assembly_summary.txt | grep 'Escherichia coli' | head -5 >> screen_genomes.txt
    
The list of file locations was obtained as before:

    cut -f 20 screen_genomes.txt | sed -e 's/\(.*\)\(GCA_.*\)/ftp:\/\/ftp.ncbi.nlm.nih.gov\/genomes\/all\/\2\/\2_genomic.fna.gz/' > screen_files.txt
    
And were downloaded with:

    wget -v --ftp-user=anonymous --ftp-password=chadlaing@inoutbox.com -i ../screen_files.txt
    

In order to use the GenBank accession as the strain name for subsequent analyses, the following script was run:

    perl src/single_file_check.pl data/screen/genomes/

The potential core genomic regions were screened against this set using Panseq with the following settings:

    queryFile  /home/chad/workspace/fronvite/analyses/senterica_panseq/coreGenomeFragments.fasta
    queryDirectory /home/chad/workspace/fronvite/data/screen/genomes/
    baseDirectory   /home/chad/workspace/fronvite/analyses/seneterica_screen/
    numberOfCores   3
    mummerDirectory /usr/bin/
    blastDirectory  /usr/bin/
    muscleExecutable    /usr/bin/muscle
    fragmentationSize   0
    percentIdentityCutoff   90
    coreGenomeThreshold	1000
    runMode pan
    overwrite   1
    nameOrId	name
    minimumNovelRegionSize  1000

and run with:

    perl ~/workspace/Panseq/lib/panseq.pl analyses/seneterica_screen.batch
    
Only 276 hits, so we submitted the entire potential core to the online NCBI blast website.
We split the coreGenomeFragments.fasta file into two parts, as all together were exceeding the memory usage of the NCBI server. The two _S. enterica_ potential core files were created as follows:

    head -3832 coreGenomeFragments.fasta > senterica_core1.fasta
    tail -3832 coreGenomeFragments.fasta > senterica_core2.fasta

Megablast was used, searching across bacteria (taxid:2), and excluding Salmonella (taxid:590). The results files for these two searches are `0CWKWMSB013-Alignment-HitTable.csv` and `0D02XD14013-Alignment-HitTable.csv` respectively. 
  
The two `.csv` files were combined into a single results file:

    cat 0CWKWMSB013-Alignment-HitTable.csv >> combined_blast.csv
    cat 0D02XD14013-Alignment-HitTable.csv >> combined_blast.csv 
  
 We removed any core genomic fragments that had identity to any non-_Salmonella_ bacterial species with the following command:

    perl src/senterica_specific.pl analyses/senterica_panseq/coreGenomeFragments.fasta analyses/combined_blast.csv > analyses/only_salmonella_megablast.fasta

To further identify matches, we submitted the `only_salmonella_megablast.fasta` to a more exhaustive blast search.

Blastn was used, searching across bacteria (taxid:2), and excluding Salmonella (taxid:590), with a word size 11, evalue of 0.001, and filtering and masking turned off. The 1482 regions were split into two separate files to reduce the load on the BLAST servers before submission:
    
    head -100 panGenome.fasta > panGenome_1.fasta | 4KHRCYSS015-Alignment-HitTable.csv
    head -200 panGenome.fasta | tail -100 > panGenome_2.fasta | 4KJ2ZMM1014-Alignment-HitTable.csv
    head -300 panGenome.fasta | tail -100 > panGenome_3.fasta | 4KJDRA4N015-Alignment-HitTable.csv
    head -400 panGenome.fasta | tail -100 > panGenome_4.fasta | 4KJB4JS4014-Alignment-HitTable.csv
    head -600 panGenome.fasta | tail -200 > panGenome_5.fasta | 4KMET4B6015-Alignment-HitTable.csv
    head -800 panGenome.fasta | tail -200 > panGenome_6.fasta | 4KN6FUWJ015-Alignment-HitTable.csv
    head -1000 panGenome.fasta | tail -200 > panGenome_7.fasta | 4KN8UMN9014-Alignment-HitTable.csv
    head -1200 panGenome.fasta | tail -200 > panGenome_8.fasta | 4KNTGF9B014-Alignment-HitTable.csv
    head -1400 panGenome.fasta | tail -200 > panGenome_9.fasta |  4KNV4YZ8014-Alignment-HitTable.csv
    head -1600 panGenome.fasta | tail -200 > panGenome_10.fasta | 4KP6V9MU014-Alignment-HitTable.csv
    head -1800 panGenome.fasta | tail -200 > panGenome_11.fasta | 4KP87TVV015-Alignment-HitTable.csv
    head -2000 panGenome.fasta | tail -200 > panGenome_12.fasta | 4KPW77AE015-Alignment-HitTable.csv
    head -2200 panGenome.fasta | tail -200 > panGenome_13.fasta | 4KPXSX9K014-Alignment-HitTable.csv
    head -2400 panGenome.fasta | tail -200 > panGenome_14.fasta | 4KR7S5Y2014-Alignment-HitTable.csv
    head -2600 panGenome.fasta | tail -200 > panGenome_15.fasta | 4KR919NP015-Alignment-HitTable.csv
    head -2800 panGenome.fasta | tail -200 > panGenome_16.fasta | 4KRXUY5A015-Alignment-HitTable.csv
    tail -164 panGenome.fasta > panGenome_17.fasta | 4KRYBEKV015-Alignment-HitTable.csv
    
All the blast .csv files were combines into a single file for subsequent analyses with:

    cat analyses/panseq_species_specific/*Alignment-HitTable.csv >> analyses/panseq_species_specific/all_allignment_hit_table.csv
    
And then sorted to remove any newlines between files

    cat analyses/panseq_species_specific/all_allignment_hit_table.csv | sort | tac > analyses/panseq_species_specific/sorted_all_alignment_hit_table.csv

Once again, we removed any core genomic fragments that had identity to any non-_Salmonella_ bacterial species with the following command:

    perl src/senterica_specific.pl analyses/panseq_species_specific/panGenome.fasta analyses/panseq_species_specific/sorted_all_alignment_hit_table.csv > analyses/only_salmonella_blastn.fasta

The `analyses/only_salmonella_blastn.fasta` file was searched against GenBank using taxid:54736 to identify any _Salmonella_ specific regions that were present among _S. enterica_ and _S. bongori_. The results were found in:

    analyses/405_species_specific_regions/8FGYTCRX014-Alignment-HitTable.csv
    
    
To remove any core genomic fragments that had identity to _Salmonella bongori_, the following was run:
  
      perl src/senterica_specific.pl analyses/only_salmonella_blastn.fasta analyses/405_species_specific_regions/8FGYTCRX014-Alignment-HitTable.csv  > analyses/405_species_specific_regions/only_salmonella_enterica_blastn.fasta

    
    
To get the binary presence / absence data for the set of _S. enterica_ specific regions, the following was run:

    head -1 analyses/panseq_spcies_specific/binary_table.txt > analyses/senterica_species_specific_binary_table.txt
    grep '>' analyses/only_salmonella_blastn.fasta | cut -d '|' -f 2 | xargs -I idxs grep idxs analyses/panseq_species_specific/binary_table.txt >> analyses/senterica_species_specific_binary_table.txt


A Figure based on the binary presence / absence data for the _S. enterica_ species specific regions was created using the following R script:

    R --vanilla < src/senterica_core_distribution.R 
    
This R script produces an outputfile, "core_output_R.txt", which summarizes the number of _S. enterica_ specific regions found in each of the 4939 genomes. Counts of the number of genomes containing at least a given number of species-specific regions were computed as follows:

    cat core_output_R.txt | cut -f 3 -d " " | awk '$1>400' | wc
    
All _S. enterica_ genomes were downloaded with the following:
    
    cut -f 20 data/senterica_complete/assembly_summary.txt | sed -e 's/\(.*\)\(GCA_.*\)/ftp:\/\/ftp.ncbi.nlm.nih.gov\/genomes\/all\/\2\/\2_genomic.fna.gz/' > data/all_senterica_files.txt
    

### Salmonella specific regions across S. enterica

The _S. enterica_ specific regions were screened against all assembled _S. enterica_ genomes from GenBank, using Panseq with the following settings:

    queryFile  /home/chad/workspace/fronvite/analyses/only_salmonella_megablast.fasta
    queryDirectory /home/chad/workspace/fronvite/data/all_senterica/
    baseDirectory   /home/chad/workspace/fronvite/analyses/seneterica_specific_all_assemblies/
    numberOfCores   3
    mummerDirectory /usr/bin/
    blastDirectory  /usr/bin/
    muscleExecutable    /usr/bin/muscle
    fragmentationSize   0
    percentIdentityCutoff   90
    coreGenomeThreshold	1000
    runMode pan
    overwrite   1
    nameOrId	name
    minimumNovelRegionSize  0

### Salmonella enterica pan-genome analyses
The pan-genome of all _S. enterica_ was determined using Panseq with the following settings:
    queryDirectory /home/chad/workspace/fronvite/data/all_senterica/
    baseDirectory   /home/chad/workspace/fronvite/analyses/panseq_all_senterica/
    numberOfCores   22
    mummerDirectory /usr/bin/
    blastDirectory  /usr/bin/
    muscleExecutable    /usr/bin/muscle
    fragmentationSize   0
    percentIdentityCutoff   90
    coreGenomeThreshold	10000
    runMode pan
    overwrite   1
    nameOrId	name
    minimumNovelRegionSize  0

To avoid computing SNP alignments, the core was set at 10000 genomes. Following the calculation of the pan-genome, the pan-genome fragments were analyzed for potential paralogs using cd-hit with the following settings:

	cd-hit-est -i pangenome_fragments.fasta -o senterica_90.fasta -c 0.90 -n 8 -d 0 -M 90000 -T 22

The set of 31484 initial pan-genome fragments was reduced to 31230, which were used in the following Panseq run to identify the distribution of the Pan-genome.
    queryFile    /home/chad/workspace/fronvite/analyses/senterica_90.fasta
    queryDirectory /home/chad/workspace/fronvite/data/all_senterica/
    baseDirectory   /home/chad/workspace/fronvite/analyses/panseq_cdhit_senterica/
    numberOfCores   22
    mummerDirectory /usr/bin/
    blastDirectory  /usr/bin/
    muscleExecutable    /usr/bin/muscle
    fragmentationSize   0
    percentIdentityCutoff   90
    coreGenomeThreshold	10000
    runMode pan
    overwrite   1
    nameOrId	name
    minimumNovelRegionSize  0

    perl ~/panseq/lib/panseq.pl panseq_cdhit_senterica.batch

The binary.phylip file was used to create a maximum likelihood tree with RAxML:
	/usr/bin/raxmlHPC-PTHREADS-SSE3 -T 22 -m BINGAMMA -s binary.phylip -n senterica_tree -p 17

## _S. enterica_ core-genome phylogeny

    queryFile    /home/chad/analyses/fronvite/senterica_90.fasta
    queryDirectory  /home/chad/analyses/senterica_full/
    baseDirectory   /home/chad/analyses/panseq_cdhit_senterica_core/
    numberOfCores   12
    mummerDirectory /usr/bin/
    blastDirectory  /usr/bin/
    muscleExecutable    /usr/bin/muscle
    fragmentationSize   0
    percentIdentityCutoff   90
    coreGenomeThreshold     4501
    runMode pan
    overwrite   1
    nameOrId        name
    minimumNovelRegionSize  1000


    /usr/bin/raxmlHPC-PTHREADS-SSE3 -T 22 -m GTRGAMMA -s snp.phylip -n senterica_cor
    e -p 17 --no-bfgs



## Converting the binary pan-genome tree from ID to name

    perl src/convert_phylip_conversion.pl analyses/panseq_cdhit_senterica/phylip_name_conversion.txt > analyses/panseq_cdhit_senterica/phylip_name_conversion_fix.txt

    perl ~/workspace/Panseq/lib/treeNumberToName.pl analyses/panseq_cdhit_senterica/RAxML_bestTree.senterica_tree analyses/panseq_cdhit_senterica/phylip_name_conversion_fix.txt > analyses/panseq_cdhit_senterica/raxml_best_tree_with_names.tre


## Generating a binary presence / absence file of the 405 specific regions

    perl src/species_specific_binary_regions.pl analyses/405_species_specific_regions/only_salmonella_blastn.fasta analyses/panseq_cdhit_senterica/binary_table_fixed_headers.txt > analyses/405_species_specific_regions/405_binary_table.txt


## Generating a heatmap from the core SNP tree and species specific data
The `analyses/subspecies_tree_matrix.png` file was generated with:

    R --vanilla < src/subspecies_tree_matrix.R 
    

## Generating a heatmap from the core SNP tree and species specific data, showing the top ten serovars

    R --vanilla < src/serovar_tree_matrix.R 
    
Generated the output file serovar_tree_matrix.png, which was copied to the `analyses` folder.

## Average number of species-specific regions for a serovar
Computed via:

    perl src/serovar_most_least.pl analyses/metadata_all_quality.txt > analyses/serovar_most_least_10.txt



## Converting the core SNP tree from ID to name
The original `phylip_name_conversion.txt` file listed the entire filename, rather than the accession number. To fix this, the `phylip_name_conversion.txt` file was converted to the same format, using:

    perl src/convert_phylip_conversion.pl analyses/panseq_cdhit_senterica_core/phylip_name_conversion.txt > analyses/panseq_cdhit_senterica_core/phylip_name_conversion_fix.txt


    perl ~/workspace/Panseq/lib/treeNumberToName.pl analyses/panseq_cdhit_senterica_core/RAxML_bestTree.senterica_core analyses/panseq_cdhit_senterica_core/phylip_name_conversion_fix.txt > analyses/panseq_cdhit_senterica_core/raxml_best_tree_with_names.tre


## Removing bad data from the analyses
Using the initial 4939 genomes, the core phylogenetic tree showed an outgroup with two genomes that far exceeded the genetic distance of any of the _S. enterica_ subspecies (Supplementary Figure 1). This tree `analyses/core_tree_with_bad_data.png` was generated with:

     R --vanilla < src/core_tree_with_bad_data.R

A blastn search of the GenBank nr database revealed these two geneomes (GCA_001570325 and GCA_001570345) to be _Citrobacter_ contamination. These two genomes were removed from subsequent analyses.


### Generating contig counts for each genome

    ls data/all_senterica/* | sort | xargs grep -c '>' > analyses/genome_contig_counts.txt

### Adding contig counts to the core region counts

    perl src/add_contig_counts.pl analyses/genome_contig_counts.txt analyses/core_output_R.txt > analyses/genome_contig_core_counts.txt 


### Creating a single metadata file form the core, contig, and species
    
    perl src/combine_contig_counts_with_metadata.pl analyses/genome_contig_core_counts.txt analyses/metadata_final.csv > analyses/metadata_all.txt

A plot of No. Contigs vs. No. Core Regions 'analyses/core_vs_contigs.png' was created from the above with:

    R --vanilla < src/plot_contigs_core.R 


### Adding quality to the metadata file, and creating a list of those below the quality threshold

    perl src/add_quality_to_metadata.pl analyses/metadata_all.txt analyses/poor_quality.txt > analyses/metadata_all_quality.txt


### Removing the poor quality columns from tab-delimited data
This is a naive and slow approach, could have used `cut -f- ...` but this works.

    perl src/remove_poor_quality_columns.pl analyses/poor_quality.txt analyses/panseq_cdhit_senterica/binary_table_fixed_headers.txt > analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt 

Testing that all poor quality columns have been removed:

    head -n 1 analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt | grep -f analyses/poor_quality.txt 

### Identify which "species-specific region" was found in the _Citrobacter_ strains

    perl src/get_columns.pl analyses/panseq_cdhit_senterica/binary_table_fixed_headers.txt GCA_001570325
    4465

    perl src/get_columns.pl analyses/panseq_cdhit_senterica/binary_table_fixed_headers.txt GCA_001570345
    4466

    cut -f1,4465,4466 analyses/405_species_specific_regions/405_binary_table.txt  > analyses/405_species_specific_regions/citrobacter_binary_table.txt

Identified >lcl|GCA_000006945_2_ASM694v2_genomic_fna|AE006468.2_Salmonella_enterica_subsp._enterica_serovar_Typhimurium_str._LT2__complete_genome__3630001..3631000_ as being the "species specific" region with identity to _Citrobacter_. The downloaded file `8FAXYYG6014-Alignment.xml` containes the BLAST result of this region against all non _Salmonella_ in GenBank.


## Remove bad data from the species-specific binary table

perl src/remove_poor_quality_columns.pl analyses/poor_quality.txt analyses/405_species_specific_regions/405_binary_table.txt > analyses/405_species_specific_regions/405_binary_table_bad_removed.txt

## Sub-species specific and species-specific marker identification

Identification of all most biased species-specific markers:
    
    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/405_species_specific_regions/405_binary_table_bad_removed.txt  --mode="binary" --one="subspecies houtenae" > analyses/subspecies_houtenae_species_specific.txt 
    
    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/405_species_specific_regions/405_binary_table_bad_removed.txt  --mode="binary" --one="subspecies salamae" > analyses/subspecies_salamae_species_specific.txt
    
    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/405_species_specific_regions/405_binary_table_bad_removed.txt  --mode="binary" --one="subspecies arizonae" > analyses/subspecies_arizonae_species_specific.txt 
    
    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/405_species_specific_regions/405_binary_table_bad_removed.txt  --mode="binary" --one="subspecies diarizonae" > analyses/subspecies_diarizonae_species_specific.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/405_species_specific_regions/405_binary_table_bad_removed.txt  --mode="binary" --one="subspecies enterica" > analyses/subspecies_enterica_species_specific.txt 
    
    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/405_species_specific_regions/405_binary_table_bad_removed.txt  --mode="binary" --one="subspecies indica" > analyses/subspecies_indica_species_specific.txt 

### Identification of any perfectly present / absent markers from the species-specific set

    perl src/perfect_group_markers.pl analyses/subspecies_houtenae_species_specific.txt > analyses/perfect_subspecies_houtenae_species_specific.txt 
    
    perl src/perfect_group_markers.pl analyses/subspecies_salamae_species_specific.txt > analyses/perfect_subspecies_salamae_species_specific.txt 

    perl src/perfect_group_markers.pl analyses/subspecies_arizonae_species_specific.txt > analyses/perfect_subspecies_arizonae_species_specific.txt
    
    perl src/perfect_group_markers.pl analyses/subspecies_diarizonae_species_specific.txt > analyses/perfect_subspecies_diarizonae_species_specific.txt 
    
    perl src/perfect_group_markers.pl analyses/subspecies_enterica_species_specific.txt > analyses/perfect_subspecies_enterica_species_specific.txt
    
    perl src/perfect_group_markers.pl analyses/subspecies_indica_species_specific.txt > analyses/perfect_subspecies_indica_species_specific.txt
    
    

## Identification of the minimum marker set for species-specific identification
    
    perl src/smallest_marker_set.pl analyses/405_species_specific_regions/405_binary_table_bad_removed.txt > analyses/minimum_species_specific_markers.txt


## Identification of subspecies-specific markers within the pan-genome

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="subspecies houtenae" > analyses/subspecies_houtenae_pan.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="subspecies arizonae" > analyses/subspecies_arizonae_pan.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="subspecies diarizonae" > analyses/subspecies_diarizonae_pan.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="subspecies salamae" > analyses/subspecies_salamae_pan.txt 

     feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="subspecies enterica" > analyses/subspecies_enterica_pan.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="subspecies indica" > analyses/subspecies_indica_pan.txt 

### Identification of any perfectly present / absent markers from the species-specific set
    
    perl src/perfect_group_markers.pl analyses/subspecies_houtenae_pan.txt > analyses/perfect_subspecies_houtenae_pan.txt 

    perl src/perfect_group_markers.pl analyses/subspecies_salamae_pan.txt > analyses/perfect_subspecies_salamae_pan.txt 
    
    perl src/perfect_group_markers.pl analyses/subspecies_arizonae_pan.txt > analyses/perfect_subspecies_arizonae_pan.txt 

    perl src/perfect_group_markers.pl analyses/subspecies_diarizonae_pan.txt > analyses/perfect_subspecies_diarizonae_pan.txt 
    
    perl src/perfect_group_markers.pl analyses/subspecies_enterica_pan.txt > analyses/perfect_subspecies_enterica_pan.txt 

    perl src/perfect_group_markers.pl analyses/subspecies_indica_pan.txt > analyses/perfect_subspecies_indica_pan.txt 
    
Counting the number of each subspecies specific regions:

    wc analyses/perfect_*_pan.txt

The number 3 was subtracted from each count, to account for the 3 header lines


### Identification of any perfectly present / absent markers from the pan-genome within serovars of enterica

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="serovar Typhi" > analyses/serovar_Typhi_pan.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="serovar Typhimurium" > analyses/serovar_Typhimurium_pan.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="serovar Enteritidis" > analyses/serovar_Enteritidis_pan.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="serovar Heidelberg" > analyses/serovar_Heidelberg_pan.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="serovar Paratyphi" > analyses/serovar_Paratyphi_pan.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="serovar Kentucky" > analyses/serovar_Kentucky_pan.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="serovar Agona" > analyses/serovar_Agona_pan.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="serovar Weltevreden" > analyses/serovar_Weltevreden_pan.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="serovar Bareilly" > analyses/serovar_Bareilly_pan.txt 

    feht --info=analyses/metadata_all_quality.txt --datafile=analyses/panseq_cdhit_senterica/binary_table_fixed_headers_bad_removed.txt --mode="binary" --one="serovar Newport" > analyses/serovar_Newport_pan.txt 
    
    
## Identification of universal markers for serovar

    grep -Pc '\t752\t0\t'  analyses/serovar_Typhimurium_pan.txt 
    grep -Pc '\t0\t752\t'  analyses/serovar_Typhimurium_pan.txt 

    grep -Pc '\t1969\t0\t'  analyses/serovar_Typhi_pan.txt 
    grep -Pc '\t0\t1969\t'  analyses/serovar_Typhi_pan.txt 

    grep -Pc '\t409\t0\t'  analyses/serovar_Enteritidis_pan.txt  
    grep -Pc '\t0\t409\t'  analyses/serovar_Enteritidis_pan.txt  

    grep -Pc '\t201\t0\t'  analyses/serovar_Heidelberg_pan.txt   
    grep -Pc '\t0\t201\t'  analyses/serovar_Heidelberg_pan.txt   

    grep -Pc '\t161\t0\t'  analyses/serovar_Paratyphi_pan.txt    
    grep -Pc '\t0\t161\t'  analyses/serovar_Paratyphi_pan.txt    

    grep -Pc '\t155\t0\t'  analyses/serovar_Kentucky_pan.txt     
    grep -Pc '\t0\t155\t'  analyses/serovar_Kentucky_pan.txt     

    grep -Pc '\t136\t0\t'  analyses/serovar_Agona_pan.txt     
    grep -Pc '\t0\t136\t'  analyses/serovar_Agona_pan.txt     
   
    grep -Pc '\t119\t0\t'  analyses/serovar_Weltevreden_pan.txt   
    grep -Pc '\t0\t119\t'  analyses/serovar_Weltevreden_pan.txt   
       
    grep -Pc '\t106\t0\t'  analyses/serovar_Bareilly_pan.txt     
    grep -Pc '\t0\t106\t'  analyses/serovar_Bareilly_pan.txt       
 
    


    

## Putative functional assignment of the 405 _S. enterica_ species specific regions
The 405 regions were screened across the GenBank `nr` database using `blastx` with the following settings:

    max hits: 10
    taxid limit: 1236 (gammaproteobacteria)
    e-value threshold: 0.001
    
To avoid overloading the server, the regions were divided into four files, the first containing 102 regions, and the subsequenct each containing 101. They were generated as follows, with the downloaded Blast xml file listed after each.

    head -n 204 analyses/only_salmonella_blastn.fasta > analyses/405_species_specific_regions/only_salmonella_blastn_1.fasta | 7TZN4GVW015-Alignment.xml
    
    head -n 406 analyses/only_salmonella_blastn.fasta | tail -n 202 > analyses/405_species_specific_regions/only_salmonella_blastn_2.fasta | 7U114V5C014-Alignment.xml
    
    head -n 608 analyses/only_salmonella_blastn.fasta | tail -n 202 > analyses/405_species_specific_regions/only_salmonella_blastn_3.fasta | 7WNBU1KA015-Alignment.xml

     head -n 810 analyses/only_salmonella_blastn.fasta | tail -n 202 > analyses/405_species_specific_regions/only_salmonella_blastn_4.fasta | 7WP4E59X014-Alignment.xml

A supplementary file containing the putative function of all 405 regions was created as follows:

    python src/se_specific_annotation_parse.py analyses/405_species_specific_regions/7TZN4GVW015-Alignment.xml > analyses/405_species_specific_regions/7TZN4GVW015_function.txt

    python src/se_specific_annotation_parse.py analyses/405_species_specific_regions/7U114V5C014-Alignment.xml > analyses/405_species_specific_regions/7U114V5C014_function.txt

    python src/se_specific_annotation_parse.py analyses/405_species_specific_regions/7WNBU1KA015-Alignment.xml > analyses/405_species_specific_regions/7WNBU1KA015_function.txt

    python src/se_specific_annotation_parse.py analyses/405_species_specific_regions/7WP4E59X014-Alignment.xml > analyses/405_species_specific_regions/7WP4E59X014_function.txt
    
    cat analyses/405_species_specific_regions/*_function.txt > analyses/405_species_specific_regions/405_specific_function.txt


### Removing the single _S. bongori_ and _Citrobacter spp._ regions
Searched for `lcl|1476306755000` and `lcl|2952612439000` and deleted the rows from `analyses/405_species_specific_regions/405_specific_function.txt`


### Histogram of functional categories
The frequency of the putative functions, taking the top functional hit, for each of the remaining 403 regions was created as follows:

    perl src/functional_counts.pl analyses/405_species_specific_regions/405_specific_function.txt > analyses/405_species_specific_regions/functional_frequency.txt
    
Allowing for multiple annotations of the same putative protein, the fequency of each was generated as follows:

    

## SISTR analyses of missing serovars

The list of _S. enterica_ missing serovar designations was created as follows:

    grep 'NA' all_senterica_metadata.csv > missing_serovar.csv
    grep 'enterica' missing_serovar.csv > enterica_missing_serovar.csv
    ls data/all_senterica/* | grep -f data/names_without_serovar.txt > data/files_without_serovar.txt
    cat data/files_without_serovar.txt | xargs -I fs cp fs data/files_needing_serovar/

These 121 genomes were uploaded to the sistr-app, and 115 were successfully analyzed. The downloaded file from this analysis is 

    data/uploaded-115_genomes-results_summary_table.csv 

The predicted serotypes were then added to the master metadatafile as follows:

    perl src/add_sistr_results.pl data/uploaded-115_genomes-results_summary_table.csv data/all_senterica_metadata.csv > data/new_metadata.csv

It was determined that NA serotypes still existed, so to expidite the process, the commandline version of SISTR was installed as follows:
    
    sudo pip install git+https://github.com/peterk87/sistr_cmd.git@0.1.1
   
The 200 _S. enterica_ still requiring serovar identification were identified by:

    grep ',NA' data/new_metadata.csv > data/senterica_na.csv

And were isolated for analyses via:

    cut -d "," -f 1 data/senterica_na.csv > data/senterica_names_na.csv
    ls data/all_senterica/* | grep -f data/senterica_names_na.csv > data/senterica_files_na.txt
    cat data/senterica_files_na.txt | xargs -I fs cp fs data/files_needing_serovar
    
The commandline version of SISTR was wrapped and parallelized, and was run on the 200 genomes as follows:

    perl src/sistr_wrapper.pl data/files_needing_serovar/ analyses/

The final .csv files were combined into a single CSV with all of the predicted types, with:

    ls analyses/sistr_200/*| xargs tail -qn 1 > analyses/sistr_200_results.csv
   
A final metadata sheet containing all of the serovars was constructed using the following (the final "1" flag at the end is to deal with the different order that the commandline version of SISTR outputs):

    perl src/add_sistr_results.pl analyses/sistr_200_results.csv data/new_metadata.csv 1 > analyses/metadata_final.csv

A summary table of the subspecies and serovar distribution was created as follows:
 
    perl src/summary_table.pl analyses/metadata_final.csv > analyses/serovar_summary_table.txt

## Analyses of pan-genome binary data and core-gene SNP data for markers statistically predictive of group

The headers on the binary and snp data tables were not identical to the metadata table, and were made consistent with the following script:

    perl src/convert_headers.pl analyses/panseq_cdhit_senterica/binary_table.txt > analyses/panseq_cdhit_senterica/binary_table_fixed_headers.txt

and

    perl src/convert_headers.pl analyses/panseq_cdhit_senterica_core/snp_table.txt  > analyses/panseq_cdhit_senterica_core/snp_table_fixed_headers.txt


