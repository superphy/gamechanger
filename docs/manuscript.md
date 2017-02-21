# Pan-genome analyses of the species _Salmonella enterica_, and identification of genomic markers predictive for species, subspecies, and serovar.


### Chad R Laing^1^, Matthew D Whiteside^1^, and Victor PJ Gannon^1^

#### ^1^ National Microbiology Laboratory @ Lethbridge, Public Health           Agency of Canada, Lethbridge, Alberta, T1J 3Z4


# Abstract
Food safety is a global concern, with upwards of 2.2 million deaths due to enteric diarrheal disease every year. Current whole-genome sequencing platforms allow routine sequencing for surveillance, and during outbreak situations; however, a remaining challenge is the identification of genomic markers that are predictive of strain groups that pose the most significant health threats to humans, or that can persist in environments related to human health.

We have previously developed the software program Panseq, which identifies the pan-genome among a group of sequences, and the SuperPhy platform, which utilizes this pan-genome information to identify biomarkers that are predictive of groups of bacterial strains.

In this study, we examined the pan-genome of 4893 genomes of _Salmonella enterica_, an enteric pathogen responsible for the loss of more disability adjusted life years than any other. We identified a pan-genome of 25.3 Mbp, a strict core of 1.5Mbp present in all genomes, and a conserved core of 3.2 Mbp found in at least 96% of the genomes of this study. We also identified 404 genomic regions of 1000bp that were specific to the species _S. enterica_. These species-specific regions were found to have functions related to the propagation and colonization of the host. For each of the six subspecies, markers unique to each were identified. No serovar had pan-genome regions that were present in all of its representative genomes and absent in all others; however, each serovar did have genomic regions that were universally present among all constituent members, and statistically predictive of the serovar. The phylogeny based on SNPs within the conserved core genome was found to be highly concordant to that produced by a phylogeny using the presence / absence of the entire pan-genome.

Future studies could develop these predictive regions into candidates for vaccine development, as well as simple and rapid diagnostic tests for both _in silico_ and wet-lab environments, with uses ranging from food safety to public health. Lastly, the tools and methods described in this study could be applied as a pan-genomics framework to other population genomic studies seeking to identify markers for bacterial species or specific sub-groups.


# Introduction
The global burden of bacterial enteric disease, much of it foodborne, results in an estimated 2.2 million deaths per year, and an annual loss of 112,000 disability adjusted life years in the United States alone [@Bergholz2014; @Scallan2015]. Nationwide molecular diagnostic networks, such as PulseNet in North America, were designed to enable the rapid identification of outbreaks by fingerprinting the etiological agents of disease, and keeping nationwide databases of previous fingerprints associated with human disease. Since its inception, PulseNet has relied on Pulsed-Field Gel Electrophoresis (PFGE) for fingerprinting of bacterial pathogens. It has been estimated that PulseNet prevents 277,000 illnesses from bacterial pathogens annually in the United States, reducing the costs associated with medical care and lack of productivity due to worker illness [@Scharff2016].

Despite the usefulness of PulseNet, the PFGE technique itself is often unable to distinguish between related and unrelated strains, due to its reliance on rare-cutting restriction enzyme sites within the genome [@Allard2012]. Additionally, the interpretation of the banding patterns among labs requires extensive training and standardization to enable meaningful comparisons. Lastly, the banding patterns provide no information on the actual content of the genomes they represent, so important information regarding human virulence, such as the presence or absence of known toxins, is not available.

Lastly, while the presence of known virulence factors has been correlated with severe human disease in a number of bacterial species, it has also been shown that some lineages or clades within these same species, while possessing the known virulence factors, are rarely associated with human disease [@Waryah2016; @Lupolova2016]. Thus, other factors within the genome that influence the expression of key virulence factors, or otherwise modulate the virulence of these strains need to be taken into consideration when attempting to predict the strains of a bacterial species that are potential human health threats [@Opijnen2012]. 

Whole-genome sequencing (WGS) has become the _de facto_ standard for the complete characterization of bacterial pathogens, in both ongoing surveillance and outbreak investigations [@DengXdenBakkerHC2016; @Franz2016]. It allows clear definition between outbreak-related strains and those from unrelated sources, the ability to identify routes of transmission, and the ability to perform source attribution of bacterial contaminants [@DenBakker2014]. It is currently being utilized worldwide, including the characterization of all _Listeria monocytogenes_ isolated in the United States, all _Salmonella_ isolated by Public Health England as part of routine surveillance [@Ashton2016], and a large-scale survey of _Staphylococcus aureus_ in continental Europe, which demonstrated the applicability of WGS for the identification of the emergence and spread of clinically relevant _Staphylococcus aureus_ [@Aanensen2016]. 

It has been shown that _in silico_ prediction of antimicrobial resistance [@Zhao2016; @Tyson2015; @McDermott2016], serotype [@Levine2016; @Yoshida2016], and other traditional sub-typing schemes such as multi-locus sequence typing [@Sheppard2012] can be accurately reproduced from bacterial genome sequences. However, given the more complex task of identifying bacterial isolates that are most likely to cause disease in humans, methods that can correctly identify markers that predict such strains from the genome sequence alone are needed. In addition, markers that can identify bacteria likely to exhibit particular phenotypes, such as the ability to survive in a particular niche, or the ability to tolerate harsh environments such as those found in food processing plants are also required.  

We have previously developed the software platform Panseq, for the analyses of thousands of genomes in a pan-genome context, where both the presence / absence of the accessory genome and SNPs within the shared core-genome are computed [@Laing2010]. Additionally, we recently released a platform for the predictive genomics of _Escherichia coli_, called SuperPhy, in which markers statistically biased within groups of bacteria, based on any metadata category, can be identified [@Whiteside2016].

In this study we use our previously created software to examine the pan-genome of _Salmonella enterica_, a species that contains human-adapted strains responsible for typhoid fever, as well as a large number of non-typhoidal strains that cause an estimated 93.8 million annual cases of enteric illness worldwide [@Gal-Mor2014; @Majowicz2010]. The species _S. enterica_ is divided into six subspecies: _enterica_, _salamae_, _arizonae_, _diarizonae_, _houtenae_, and _indica_. Over 99% of human disease caused by _S. enterica_ is done so by subspecies _enterica_, with the World Health Organization estimating that _S. enterica_ infections from contaminated food alone constitute a loss of 6.43 million disability adjusted life years worldwide, more than any other enteric pathogen [@Kirk2015]. Within _S. enterica_, we identified species- and subspecies-specific markers, as well as markers predictive of serotype for subspecies enterica. While this study focused on _S. senterica_, the tools and approach are broadly applicable to any species or collection of genomes. 


# Materials and Methods
All commands and analyses parameters used to analyze the data and generate the Figures are available as Supplementary File 1. The scripts used for analyses are available at `https://github.com/superphy/gamechanger`. The following is a summary of the methods used. 

## Data Collection
All _S. enterica_ genomes were downloaded from GenBank in nucleotide fasta format. A full listing of the initial 4939 genomes, including GenBank identifier, subspecies, serovar, the number of species-specific core regions present, the number of contigs, and whether the genome passed the quality filtering steps are listed in Supplementary File 2.

## Serovar identification
Most of the _S. enterica_ genomes on GenBank had serovar provided as part of their metadata; however, 321 were missing this designation. The SISTR web-server, as well as the SISTR commandline app were used to predict the serotype for these strains [@Yoshida2016].
 
## Pan-genome analyses
Panseq (commit:1d0ab9d37e8e358d266e1d0aa80e9b27f28a1def) was used to identify the pan-genome of the 4939 strains of this study [@Laing2010]. Genomes were initially fragmented into 1000bp segments, and subsequently clustered using cd-hit v.4.6 to remove potential duplicates / paralogues from the analyses using a 90% sequence identity threshold [@Fu2012]. Initially Panseq was used to determine the distribution of the pan-genome among the genomes at a 90% sequence identity threshold, from which a "conserved core" was identified. Within the conserved core, Panseq was then used to identify single-nucleotide polymorphisms.

## Identification of _S. enterica_ species-specific regions
To identify regions that were likely to represent the species as a whole, we initially examined the 211 closed _S. enterica_ genomes in GenBank (Supplementary File 2), and identified 3832 regions of 1000 bp that were found in 90% (190) of the 211 closed genomes using Panseq, at a 90% sequence identity threshold. These regions were then screened against the online GenBank `nr` database using `megablast` as a first-pass filter with default parameters, searching across bacteria (taxid:2), and excluding all _Salmonella_ (taxid:590) hits that had greater than 80% identity across 80% of the query length from the results. The remaining 1482 genomic regions were subsequently screened against the online GenBank `nr` database of all bacteria (taxid:2), using the `blastn` algorithm, to identify matches that were missed using the less-specific `megablast` algorithm, with word size 11, an e-value cutoff of 0.001, and excluding all _Salmonella_ (taxid:590). These results were filtered in the same manner, leaving 405 potentially species-specific regions. Lastly, these regions were compared against _S. bongori_ genomes in GenBank; one _S. bongori_ hit was identified, which left 404 genomic regions present in _S. enterica_ but no other bacterial genomic sequences within the GenBank `nr` database.

The putative function of these regions was determined by screening them across the GenBank `nr` database using `blastx` with "max hits:10", "taxid limit:1236 (gammaproteobacteria)", and an "e-value threshold: 0.001". The best matching hit above a 90% sequence identity threshold was used for the putative functional assignment.

## Identification of subspecies- and serovar-specific regions
The Fisher's Exact test, using Bonferonni correction for multiple testing was applied as in the SuperPhy platform [@Whiteside2016], implemented here as the standalone program `feht` (https://github.com/chadlaing/feht). The input for the program was Supplementary File 2, which contained metadata for all the strains, as well as the `binary_table.txt` output file from the Panseq analyses, which denotes the presence / absence of each 1000bp pan-genome region among all the strains.

## _S. enterica_ phylogenetic analyses
The phylogeny based on SNPs within the core genome was generated using RAxML v8.2.9, with the `snp.phylip` output file from Panseq [@Stamatakis2014]. The phylogeny based on the presence / absence of the pan-genome was also generated using RAxML v8.2.9, with the `binary.phylip` output file from Panseq.

## Generation of figures and tables
The R-statistical language v3.3.2 was used to generate the summary Figures and Tables [@R_stats]. The R-scripts and all others used for the analyses can be found at `https://github.com/superphy/gamechanger/tree/master/src`. The `ggtree` package for R was used in the generation of the phylogenetic tree images [@Yu2016].


# Results
## _S. enterica_ pan-genome
We initially determined the size and distribution of the _S. enterica_ pan-genome as genome fragments of 1000bp in size, across the 4939 genome sequences of this study, which are summarized by subspecies in Table 1, and withing subspecies enterica by serotype in Table 2. As can be seen in Figure @figure_senterica_pan_histogram, the pan-genome comprised of 4939 _S. enterica_ genomes was found to be 25.3 Mbp in size, with 70% of the pan-genome present in fewer than 100 strains. Conversely, the core genome was found to be 1.5 Mbp in size, with all but 200 genomes (96%) containing 3.2 Mbp of shared genomic core. Only 17% of the pan-genome was found in greater than 100 genomes, but fewer than 4739 genomes. 

## _S. enterica_ species-specific regions
To identify regions of _S. enterica_ that were likely to be shared among most genomes of the species, we examined all 211 closed genomes of _S. enterica_ in GenBank, looking for genomic regions that were present in at least 190 (90%) of these genomes. We identified 3832 regions of 1000 bp that were present in at least 90% of the closed genomes. These regions were subsequently screened against the GenBank `nr` database, and any present in non-_Salmonella_ genomes were removed, leaving 404 putative _S. enterica_ species-specific regions (Supplementary File 3).

 Figure @figure_senterica_specific_plot shows the carriage of these 404 regions among the 4939 genomes of this study. All but 105 genomes contained at least 330 of these putative _S. enterica_ specific regions. A stark difference in carriage of these species specific markers was observed, with 4742 genomes containing at least 350 species-specific markers, while only 2674 genomes contained 360 or more species-specific markers. 

## Quality filtering for subsequent analyses
To ensure the quality of the genomes in use for subsequent analyses, we plotted carriage of the 404 species specific regions versus the number of contigs that each sequenced genome was comprised of (Figure @figure_core_vs_contig). As can be seen, the two genomes marked in yellow contained only one, and the same, species-specific region each, despite being comprised of relatively few contigs. Subsequent searches identified these two genomes as _Citrobacter spp._ contamination, mislabeled as _S. enterica_ (GCA_001570325 and GCA_001570345). The "_Salmonella enterica_ species-specific region" found in both of the contaminant _Citrobacter_ genomes, did not match any other _Citrobacter spp._ in GenBank above the thresholds used for determining presence / absence in this study. However, due to the presence of this region in what have been identified as _Citrobacter_ genomes, the region was removed from subsequent analyses.

The majority of genomes (4913) were from subspecies enterica, with genomes from the five other _S. enterica_ subspecies present in drastically fewer numbers (Table 1). All genomes from subspecies enterica contained greater than 250 species-specific regions, which was more than the genomes from any other subspecies, with the exception of enterica genomes that were of poor quality and comprised of many thousands of contigs (Table 2). Genomes from subspecies houtenae and arizonae contained fewer than 100 species-specific regions, while genomes from diarizone, indica, and salamae contained between 100 and 200 species-specific regions. All regions were screened against _Salmonella bongori_ to ensure specificity to _S. enterica_; one region was found to also be present in genomes from _S. bongori_ and was removed from further analyses.

Within subspecies enterica, a negative linear relationship was observed among the number of species-specific regions contained within a genome, and the number of contigs the genome was comprised of, with the worst-case genome (GCA_000495155) being comprised of 6945 contigs, but containing only 13 species-specific regions. Other genomes such as _S. enterica_ Bovismorbificans strain GCA_001114865 contained both few contigs (140) as well as fewer species-specific regions (209) than other enterica genomes. Additional searches discovered sequencing gaps within the genome totalling over 464 Kbp. A final outlier genome harbored nearly 5000 contigs, but also contained 403 of the species-specific regions. It was determined that this sequence (GCA_000765055) was actually a combination of multiple genomes in a single file. 

Given the above information, all genomes from the five subspecies other than enterica were included in subsequent analyses, while the thresholds for inclusion of enterica genomes were set at a maximum of 1000 contigs, and a minimum of 250 species-specific regions. Following this quality filtering, 43 genomes were removed, leaving 4870 _S. enterica_ enterica genomes for the following analyses.


## Phylogeny of _S. enterica_ using the conserved core genome
Based on the distribution of the pan-genome presented in Figure @figure_senterica_pan_histogram, the "conserved core" of _S. enterica_ was set at greater than 4500 genomes, to fully capture the conserved genomic regions within the species. A phylogeny based on the SNPs among these shared regions was created, and is shown along with the distribution of the _S. enterica_ species specific regions in Figure @figure_senterica_core_phylogeny. As can be seen, the majority of the genomes are subspecies enterica, and the other five subspecies are relatively more distant in the order of indica, salamae, houtenae, diarizonae, and arizonae. However, the order of subspecies in order of declining species specific regions is: enterica, diarizonae, salamae, indica, houtenae, and arizonae, which is shown in Figure @figure_core_vs_contig. 

The serovar distribution within subspecies enterica was shown to be largely concordant with phylogeny, as demonstrated in Figure @figure_senterica_serovar_core_phylogeny, where the ten most abundant serovars in the current study are highlighted. However, not all serovars clustered as monophyletic groups, as can be seen with serovar Bareilly; nor were all clades found to be comprised of single serovars, demonstrated by the clade containing genomes of serovars Bareilly and Agona. 
 
The large clades within the phylogenetic tree also demonstrate clade-specific patterns of presence / absence for the 403 species-specific markers. Among the most abundant serovars Typhimiurium, Heidelberg, Newport, and Enteritidis were found to contain the most species-specific markers, and group together near the center of the tree. Likewise, serovars Agona, Welevreden, and Kentucky contained fewer species-specific regions, and group together near the bottom of the tree, closer to the non-enterica sub-species genomes.
 
Table 4 considers all serovars with at least 10 members in the dataset, and the average number of species-specific markers per serovar. As can be seen, the serovars with the largest average number of species-specific regions were: Enteritidis (401.7), Anatum (401.5), Muenchen (400.5), Hadar (400.3), and Typhimurium (400.1); conversely, the serovars with the fewest average number of species-specific regions were: Derby (360.7), Montevideo (360.1), Typhi (358.1), Bovismorbificans (355.3), and Cerro (342.0).
 
 
## Phylogeny of _S. enterica_ using the pan-genome
A phylogeny based on the presence / absence of the pan-genome among the 4893 _S. enterica_ genomes was created, and is shown along with the distribution of the _S. enterica_ species specific regions in @figure_senterica_pan_phylogeny. As can be seen this phylogeny based on the presence / absence of the entire 25.3 Mbp pan-genome is highly concordant to the phylogeny based on the SNPs found in the conserved core of the same strains (Figure @figure_senterica_pan_phylogeny). In both trees the serovars cluster together and in the same relation to each other, for example serovars Typhi and Paratyphi strains form a discrete monophyletic clade. However, the branch lengths in the pan-genome tree are larger than those in the conserved SNP tree, due to the larger variation among the presence / absence of the pan-genome than to sequence variation among shared regions.


## Identification of a minimum set of species-specific genomic markers for the identification of subspecies _S. enterica_.
Within the 404 species-specific markers, there were none that were also specific for any of the subspecies. That is, a marker was always present in genomes from at least two subspecies.
 
 We next determined that the presence of a minimum set of two genomic regions was required to unambiguously identify genomes of _S. enterica_, within the 4893 genomes of the current study. A combination of two genomic regions were all that was required, and two such markers that were also present in the most _S. enterica_ genomes were found at the following locations within the Typhimurium reference genome LT2: (1336001 .. 1337000) and (2467001 .. 2468000) (Supplementary File 3). All members of _S. enterica_ examined contained at least one of these markers, but many other combinations within the 404 species-specific markers are possible. 
 
 
## Putative functional identification of the _S. enterica_ species-specific regions
 The putative function of the 404 quality-filtered _S. enterica_ species-specific regions were determined form the GenBank `nr` database. The annotation of each of the 404 regions is available as Supplementary File 1. Table 3 summarizes the frequency of functional annotation categories, after annotating each region with the single best match. As can be seen, hypothetical proteins accounted for the majority (64) of the 404 annotations, with secreted effector and membrane proteins being the next most frequent category among the species-specific regions. Other membrane, transport, and secretion proteins were observed. The species-specific regions also included proteins involved in core metabolic functions, protein and DNA synthesis, and response to stress.  

## Identification of subspecies specific markers from the pan-genome
Having identified species-specific markers, we employed the same techniques, utilizing the presence / absence of all pan-genome markers, just the 404 species-specific ones, to identify subspecies-specific markers. The number of markers that were completely unique to a subspecies is given in Table 5. Subspecies arizonae contained the most unique markers, at 207, and enterica contained the least, at 9.
 
## Identification of universal serovar markers within subspecies enterica from the pan-genome
Subspecies enterica genomes were the vast majority of those available, so we attempted to identified serovar-specific markers for the top five serovars, in the same manner that we identified subspecies-specific markers. We found that there were no genomic markers that uniquely defined any of the serovars based on their presence or absence; however, there were a number of genomic regions that were universally conserved in their presence or absence among serovars, even though theses same markers were both present and absent in genomes of other serotypes. The number of markers universal for presence or absence among the enterica serovars is shown in Table 6.

#Discussion
## _S. enterica_ pan-genome 
Previous examinations of the _S. enterica_ pan-genome were based on relatively small datasets of 45 and 73 genomes [@Jacobsen2011; @Leekitcharoenphon2012]. While others have analyzed thousands of _S. enterica_ genomes, the analyses were not conducted to examine the population structure. For example, in demonstrating the software program Roary, 1000 _S._ Typhi genomes were used to test the program [@Page2015]. Likewise, the GenomeTrackR project utilized 32 _S. enterica_ genomes to identify a _S. enterica_ core, which was subsequently used as the basis for genetic distance estimates for nearly 20,000 genomes [@Pettengill2016].

Previous estimates placed the core-genome size of _S. enterica_ at ~2800 gene families, and the pan-genome at ~10,000 gene families [@Jacobsen2011]. The current study identified a strict core of 1.5 Mbp, and a conserved core of 3.2 Mbp shared among 96% of the genomes, which given an average gene size of 1000bp is ~1500 and ~ 3200 genes respectively, with a much larger pan-genome at ~25,300 genes. Previous analyses found _S. enterica_ to have a closed pan-genome [@Jacobsen2011], and thus the rate of discovery for new genomic regions would decrease for each new genome of the species sequenced [@Tettelin2005]. 

In line with _S. enterica_ having a closed pan-genome, when we compared it to _Escherichia coli_, a related bacterial species with an open pan-genome [@Tettelin2005], we found that the _E. coli_ pan-genome was larger (37.4 Mbp), despite the fact that the _E. coli_ study used less than half the number of strains in the current _Salmonella enterica_ study. Additionally, more of the pan-genome of _S. enterica_ was distributed among more genomes than in _E. coli_ [@Whiteside2016]. Specifically, in _S. enterica_ 70% of the pan-genome was found to belong to 100 or fewer of the genomes examined, while in _E. coli_ 80% of the pan-genome was found in 100 or fewer genomes. 

It should be noted that erroneously labelled, and poor quality assemblies, can greatly affect the size, analyses, and composition of the pan-genome. Software tools to evaluate assembly quality have been created to help researchers identify bad data. These include QUAST [@Gurevich2013], which summarizes the assembly statistics including average contig size and number of contigs; as well as CGAL [@Rahman2013], which uses a likelihood approach to infer assembly quality rather than summary statistics. As demonstrated in the current study, having a known set of species-specific genome regions can facilitate rapid quality assessment and filtering of genome assemblies. Others have proposed whole-genome MLST for this purpose as well [@Babenko2016,@Yoshida2016], but the benefit of a pan-genome analysis is that it is schema free. 


## _S. enterica_ species-specific regions
The host intestinal environment consists of a multitude of bacterial species competing for scarce nutritional sources such as carbohydrates, direct antagonistic competition with other bacterial cells, and competition for access to the host intestine, where stable attachment and colonization of the local environment are possible [@Sana2016]. The normal intestinal microflora offer protection to the host against enteric pathogens such as _S. enterica_, but intestinal disruption from virulence factors and effector proteins secreted by the pathogen itself, or external factors including antibiotics, have been shown to alter the composition of the microbiota, and allow pathogens such as _S. enterica_ to capitalize on the fluctuating environment [@Ng2013].
 
Nutritional competition exists for free metabolic compounds, such as carbohydrates that are readily available, as well as others that are sequestered in forms such as the intestinal mucus, which is composed of sialic sugar acids [@McDonald2016]. In the gut, these sugar acids exists as a conjugate in the alpha form, which to be useful for bacteria such as _Salmonella_, need to be converted to the beta form by a mutarotase enzyme [@Severi2008]. In this study we identified n-acetylneuraminic acid mutarotases as species-specific genomic regions, along with sialic acid transporters. It is likely the presence of these systems allow _S. enterica_ to more efficiently compete with the host microbiota by efficiently utilizing scarce metabolic sources. 

It was also previously found that sialic acid on the surface of host colon cells increased colonization by _S._ Typhi, and disialylation of these cells reduced the adherence of the _Salmonella_ strains by 41% [@Sakarya2010]. This was also demonstrated in _S._ Typhimurium, where following antibiotic treatment, the presence of free sialic acid increased, and the ability to utilize it was correlated with levels of bacterial colonization of the host gut [@Ng2013].

The ability to utilize sialic acids has previously been shown to be present in 452 bacterial species, including other pathogens such as _Vibrio cholerae_, but the genomic regions found in the current study were sufficiently diverse at the nucleotide level to be determinative for _S. enterica_ [@McDonald2016].

In addition to species-specific regions used to gain a metabolic advantage, a number of secretion system and effector proteins were identified as diagnostic of _S. enterica_. These included components of the Type VI secretion system (T6SS), which is a contact-dependent, syringe-like secretion system that allows _S. enterica_ to directly kill other competing bacteria that it comes into physical contact with [@Brunet2015], and is encoded on the _Salmonella_ Pathogenicity Island 6 [@Sana2016]. It has been demonstrated that silencing the T6SS via H-NS repression (histone-like nucleoid structuring), reduces inter-bacterial killing of _S. enterica_ [@Brunet2015]. It was also previously shown that commensal bacteria are killed by _S. enterica_ in a T6SS-dependent manner, that the T6SS was required for _Salmonella_ to establish infection in the host gut, and that increased concentrations of bile salts resulted in a concomitant increase in T6SS anti-bacterial activity [@Sana2016]. The T6SS itself has been shown to be independently acquired from four separate lineages within five of the six _S. enterica_ subspecies [@Desai2013].

Like the T6SS, the type III secretion system (T3SS) found within _S. enterica_ is a syringe like apparatus that injects effector proteins into host cells [@Kubori2000]. There are two T3SS found within _S. enterica_: the first is encoded on the Salmonella Pathogenicity Island 1 (SPI1) and is required for invasion into host cells; the second is encoded on Salmonella Pathogenicity Island 2 (SPI2), and is required for survival and proliferation within the host macrophage cells [@Hensel1998; Bijlsma2005]. The innate host immune system utilizes the inflammatory response to help reduce the proliferation of bacterial pathogens [@Sun2016]. _S. enterica_ has developed a means of regulating host inflammation via the SPI1 T3SS, whereby secreted effector proteins target the NF-kB signalling pathway reduce inflammation and host tissue damage, and allow increased _S. enterica_ propagation within the host. _S. enterica_ also relies on free long-chain fatty acids within the host to regulate T3SS expression, and help cue the bacteria for host intestinal colonization [@Golubeva2016]. 

The current study identified many secretion system and effector proteins as being species-specific, as well as proteins for attachment to the host, such as fimbriae. These proteins allow _S. enterica_ to be competitive within the intestinal environment, and take up residence within the host, where it can proliferate.

Effector proteins and other virulence factors aid in the colonization of the host, and are frequently horizontally acquired and present on mobile elements such as integrated bacteriophages [@MorenoSwitt2013]. Previous work identified clusters of phages that carried virulence factors such as adhesins and antimicrobial resistance determinants within _S. enterica_ [@MorenoSwitt2013]. Additionally, many of the genes associated with bacteriophage in _S. enterica_ have been found to be of the putative and hypothetical class [@Penades2015]. 

The current study identified a large accessory gene pool that contained many hypothetical and putative genes, which were also the most abundant category of species-specific genomic regions. The proteins of putative and unknown function may aid in colonizing warm-blooded animals, or specific animal or environmental niches. Previous studies identified genotype / phenotype correlations of _S._ Typhimurium that had particular gene complements associated with specific food sources [@Hayden2016]. The same study also postulated that specific phage repertoires may give phylogenetically distant strains a similar accessory gene content, and therefore similar niche specificity. Previously, 285 gene families were identified as being recruited into _S. enterica_, where most of these genes had unknown function, but were postulated to be important for its survival and infection of its host [@Desai2013]. It is therefore not surprising to find that the most abundant species-specific category of genomic regions are those of unknown or  putative function; they likely represent genes enhancing the ability of _S. enterica_ to propagate within warm-blooded animals, but have not yet been fully characterized. The other genomic regions diagnostic of _S. enterica_ include means for disseminating these fitness genes within the population, competing for resources in the host, and attaching and proliferating. The _S. enterica_ species-specific regions give a good overview of what make it such an effective pathogen and intestinal inhabitant.


## Specific regions for subspecies and serovar

The phylogenetic relationship of the six _S. enterica_ subspecies has been previously described, which the current study recapitulates [@Desai2013]. However, the number of species-specific regions found within each subspecies does not follow the same pattern. For example, diarizonae is more distantly related to enterica than subspecies indica, but contains more species-specific regions, and the branch lengths on the tree are shorter. This indicates that although the diarizonae strains diverged longer ago than the houtenae strains, they have accumulated less genomic change. Both subspecies diarizone and houtenae strains are associated with reptile-acquired salmonellosis [@Schroter2004; @Horvath2016], but the differences in genomic change may reflect the specific reptile niches that each inhabit.

Genomic regions specific to each subspecies were identified, the presence of which were unambiguously indicative of each subspecies. The most abundant subspecies in the current analyses, enterica, had the fewest specific markers present (9), while the most distantly related subspecies arizonae, had the most specific markers (207). These results indicate that just as core genome size decreases with the number of genomes examined, so too do the number of markers "core" to each subspecies. As more genomes in subspecies arizone and closely related subspecies are examined, we would expect fewer genomic regions to remain specific for the subspecies. This has important implications for designing a set of markers indicative for subspecies, indicating that a group of redundant markers should be used, and that a sampling of the diversity within a subspecies is first required to identify genomic regions that are truly core.

This was also observed within serotype for subspecies enterica strains. The original study examining the pan-genome of _S. enterica_ used a set of 45 genomes and was able to identify unique gene families for each serotype examined, with Enteritidis having the fewest (29), and Typhi having the most (349) [@Jacobsen2011]. The results of the current study showed no unique genomic regions for any of the serovars with a sample set of 4893 quality filtered genomes. Although genomic regions universally present for each serovar were observed, and followed the same pattern with Enteritidis having the fewest (18), and Typhi having the most (288), these regions were also observed among genomes of other serotypes. 

When examining the average number of the 404 species-specific regions found among the enterica serovars, it was interesting to observe that Enteritidis, which had the fewest number of universal genomic regions, had the highest average number of species-specific regions; likewise Typhi, which had the most universally shared genomic regions, had one of the lowest averages of species-specific regions present. These results indicate that Enteritidis is the serovar that is closest to being the "core" example of a _S. enterica_ genome, while Typhi is the serovar that is the most divergent. _S._ Enteritidis is the most common cause of enteric _Salmonella_ infection, causing upwards of one quarter of all infections, and is prevalent in chickens as well as their eggs [@Chai2012]. Conversely, _S._ Typhi is a human adapted serovar, responsible for Typhoid fever, and observed to have undergone genome degradation, rearrangement, and acquisition through horizontal gene-transfer, as it has evolved within its human host [@Klemm2016; @Sabbagh2010]. It thus appears that genomic change enabling adaptation to a host creates a genomic pool that distinguishes a group from others of the same species. At the same time, genetically similar serovars not undergoing selection for genomic change are much harder to individually distinguish as separate groups, but much easier to identify as members of the subspecies.   

## Core and Pan-genome comparison
Most phylogentic studies focus on variation within homologues in the core genome to infer evolutionary relationships [@Treangen2014], as paralogues and horizontally transfered elements confound the evolutionary signal found in genes obtained through vertical descent over time [@Gabaldon2013]. While this approach is undoubtedly useful for long-term evolutionary analyses, when attempting to identify phenotypic linkages between phylogenetic clades, the accessory genome needs to be taken into account, as non-ubiquitous genomic regions allow different groups within the species to occupy and thrive in specific niches [@Polz2013]. Additionally, it has recently been shown that regulatory switching to non-homologous regulatory regions acquired via horizontal gene transfer happens across the domain bacteria [@Oren2014]. It was further shown that regulatory regions can move without the genes they regulate moving, and that at least 16% of the differences in expression observed within an _E. coli_ population were explained by this regulatory switching. 

It is therefore prudent to examine both the accessory genome, and not just genes, but non-coding DNA as well, as both have been shown to influence gene expression, and niche specificity. And while it may at first seem that the concordance between a phylogeny based on core genome SNPs and the presence / absence of pan-genome regions would not be high, recent studies have shown just that. For example, in a study examining _E. coli_ lineage ST131, the core and accessory genomes showed high concordance, and the combined analyses of both allowed the analyses of the evolution of the _E. coli_ lineage at a resolution not possible if only a portion of all genomes had been considered [@McNally2016]. The current study shows the same concordant relationship within _S. enterica_ between the core and accessory genome, indicating that the accessory genome is not just randomly acquired genomic material, but that selection within specific niches establishes a complement of genes and regulatory elements that enable the survival of the _S. enterica_ strains present. It also suggests that to understand why particular clades are more virulent, or possess a particular phenotype, a pan-genomic approach should be used in comparative analyses.


# Conclusions
We examined a quality filtered set of 4893 genomes, the largest pan-genomic study of the _S. enterica_ species to date. We identified a pan-genome of 25.3 Mbp, a strict core of 1.5Mbp present in all genomes, and a conserved core of 3.2 Mbp found in at least 96% of the genomes of this study. In addition we identified 404 species-specific regions, within which a minimum set of two was required to unambiguously identify a genome as being part of the species _S. enterica_. These species-specific regions were found to have functions related to the propagation and colonization in the host, including the utilization of sialic acid in intestinal mucus, secretion systems for attachment to the host, and the killing of the host microbiota. Within subspecies enterica, the species-specific regions were found most frequently in serovar Enteritidis. Each of the six subspecies was found to have genomic regions specific to it, the number of which appeared correlated to how well sampled the diversity within the subspecies was. No serovar had pan-genome regions that were present in all of its representative genomes and absent in all other genomes; however, each serovar did have genomic regions that were universally present among all constituent members, and statistically predictive of the serovar. _S._ Typhi, which is host-adapted to humans, was found to have the most universal markers predictive of its serotype. The phylogeny based on SNPs within the conserved core genome was found to be highly concordant to that produced by a phylogeny using the presence / absence of the entire pan-genome, and both agreed with previous phylogenies of _S. enterica_. Together, the core and accessory genome offered a more complete picture of the diversity within the genomes than either alone. The genomic regions identified in this study that are predictive of the species _S. enterica_, its six subspecies, and the serotype groups within subspecis enterica, could be developed into a simple and rapid diagnostic tool, with uses ranging from food safety to public health. Additionally the tools and methods described in this study could be generally applicable as a pan-genomics framework for future population studies, or those looking for genotype / phenotype linkages.


# Tables
|Subspecies|No.|
-----------|----
|enterica|4913|
|arizonae|7|
|diarizonae|7|
|houtenae|4|
|salamae|4|
|indica|1|

: Table 1.  The frequency of the subspecies observed within the study set of 4937 _Salmonella enterica_ genomes, prior to any quality filtering.



|Serovar|No.|
--------|---
|Typhi|1977|
|Typhimurium|758|
|Enteritidis|413|
|Heidelberg|201|
|Paratyphi|158|
|Kentucky|155|
|Agona|136|
|Weltevreden|120|
|Bareilly|106|
|Newport|82|
|Tennessee|77|
|Montevideo|69|
|Saintpaul|48|
|Infantis|39|
|Senftenberg|35|
|Bovismorbificans|34|
|Hadar|33|
|Muenchen|30|
|Anatum|27|
|Schwarzengrund|27|
|Dublin|24|
|Cerro|21|

: Table 2. The serovars with more than 20 representatives in the current study set of 4937 _Salmonella enterica_ genomes, and their frequency, prior to any quality filtering. The list of all serovars and their frequency within the current study is available as Supplementary File 2.


Putative protein function|Frequency
-------------------------|---------
hypothetical|64
secreted effector|10
membrane|7
secretion system apparatus|5
uncharacterised|5
fimbrial|5
pathogenicity island 2 effector|4
fimbrial assembly|4
outer membrane usher|4
mfs transporter|3
oxidoreductase|3
histidine kinase|3
putative inner membrane|3
putative cytoplasmic|3
lysr family transcriptional regulator|3
transcriptional regulator|2
permease|2
outer membrane|2
type iii secretion|2
phosphoglycerate transport|2
arac family transcriptional regulator|2
conserved hypothetical|2
methyl-accepting chemotaxis|2
hybrid sensor histidine kinase/response regulator|2
glycosyl transferase, partial|2
phenylacetaldehyde dehydrogenase|2
pathogenicity island 1 effector|2
n-acetylneuraminic acid mutarotase, partial|2
type iii secretion system|2
transcriptional regulator, partial|2
cytoplasmic|2
fimbrial chaperone|2
putative sialic acid transporter|2

: Table 3. The putative function of the _S. enterica_ species-specific regions for functions that were identified more than once, utilizing the best hit for each region. The complete list of all putative functions is available as Supplemental File 1.


Serovar|Average no. species-specific regions
-------|-----
Enteritidis|401.7
Anatum|401.5
Muenchen|400.5
Hadar|400.3
Typhimurium|400.1
Newport|399.8
Thompson|399.7
Saintpaul|399.6
I|399.0
Heidelberg|397.4
Dublin|395.2
Infantis|394.9
Braenderup|392.8
Weltevreden|390.0
Bareilly|388.5
Kentucky|380.3
Plymouth/Zega|377.9
Senftenberg|376.5
Mbandaka|374.5
C1:g|374.1
Reading|370.4
Agona|369.5
Tennessee|368.3
Schwarzengrund|362.3
Paratyphi|361.5
Derby|360.7
Montevideo|360.1
Typhi|358.1
Bovismorbificans|355.3
Cerro|342.0

:Table 4. The average number of species-specific genomic regions found among serovars of subspecies enterica, that contained at least 10 representative genomes, within the 4870 quality filtered subpecies enterica genomes of this study.


Subspecies|No. Markers
----------|------------
arizonae|207
diarizonae|93
enterica|9
houtenae|134
indica|192
salamae|135

:Table 5. The number of subspecies-specific pan-genome markers that were universally present or absent among members of the subspecies, and not absent or present among genomes from any other subspecies.


Serovar|No. universally present|No. universally absent
-------|-----|-----
Typhi|288|2720
Typhimurium|41|698
Enteritidis|18|440
Heidelberg|121|840
Paratyphi|65|202
Kentucky|177|331
Agona|161|638
Weltevreden|426|608
Bareilly|87|436
Newport|226|360

:Table 6. The number of pan-genome regions that were universally present and absent, as well as statistically over- or under-represented in comparison to all other genomes, within the ten most abundant serotypes within the 4870 subspecies enterica genomes of this study.



# Figures
(@figure_senterica_pan_histogram) Figure 1
The distribution of the _Salmonella enterica_ pan-genome, as 1000bp fragments, among 4939 whole-genome sequences. 

(@figure_senterica_specific_plot) Figure 2
The carriage of the 404 _S. enterica_ species-specific regions among each of the 4939 genomes of this study. Each dot represents a single _S. enterica_ genome, which are arranged in order from those that contain the fewest species-specific regions to those that contain the most.

(@figure_core_vs_contig) Figure 3
The carriage of the 404 _S. enterica_ species-specific regions, and the number of contigs that each of the 4939 genomes of this study were distributed amongst. Colours indicate the subspecies within _S. enterica_, or contamination from ther species as follows: red: arizonae, yellow: _Citrobacter_ contamination, lime: diarizonae, teal: enterica, blue: houtenae, lavender: indica, magenta: salamae.

(@figure_senterica_core_phylogeny) Figure 4
The phylogeny of the 4893 _S. enterica_ genomes post quality-filtering. The six subspecies are highlighted as follows: red: arizonae, yellow: diarizonae, lime: enterica, teal: houtenae, blue: indica, magenta: salamae. The matrix to the right of the phylogeny represents the 404 species-specific regions, with red being the absence of the region, and black being the presence of the region, for each of the genomes of the study.

(@figure_senterica_serovar_core_phylogeny) Figure 5
The phylogeny of the 4893 _S. enterica_ genomes post quality-filtering based on SNPs found within the conserved core genome. The ten most abundant serotypes of subspecies enterica in the current study are highlighted as follows: dark green: Agona, dark orange: Bareilly, purple: Enteritidis, magenta: Heidelberg, light green: Kentucky, yellow: Newport, brown: Paratyphi, grey: Typhi, pink: Typhimurium, light blue: Weltevreden. The matrix to the right of the phylogeny represents the 404 species-specific regions, with red being the absence of the region, and black being the presence of the region, for each of the genomes of the study.

(@figure_senterica_pan_phylogeny) Figure 6
The phylogeny of the 4893 _S. enterica_ genomes post quality-filtering based on the presence / absence of the entire pan-genome as 1000bp fragments. The ten most abundant serotypes of subspecies enterica in the current study are highlighted as follows: dark green: Agona, dark orange: Bareilly, purple: Enteritidis, magenta: Heidelberg, light green: Kentucky, yellow: Newport, brown: Paratyphi, grey: Typhi, pink: Typhimurium, light blue: Weltevreden. The matrix to the right of the phylogeny represents the 404 species-specific regions, with red being the absence of the region, and black being the presence of the region, for each of the genomes of the study.

