This document will serve as a log of notes describing the squirrel genotypes from Compiled_Genotypes_Post2015.xlsx and their consolidation into Compiled_Genotypes_Post2015_clean.xlsx.

The original Compiled_Genotypes_Post2015.xlsx spreadsheet is more descriptive of the genotyping issues encountered by Arianne including conflicting genotypes of the same individual and potential mixups in the field or lab. The "clean" version is my (*Ty's) attempt at resolving these issues into a useable genotype file. This document will serve as a record of the differences between the two; changes are being recorded here for posterity. Grid-year subheadings below are sheets corresponding to 96-well extraction plates. Allele conflicts were resolved by using the allele from the genotyping run with the higher call rate unless otherwise stated. Allele call revisions were done by Anh Dao on 01/13/2021 for some calls that were originally conflicting between runs. Anh was nice enough to give us a second opinion on the genemapper results and call the genotypes based on their peak profile; "revised" is referring to her experience.


KL2015
-KL150173: allele conflict at 25b (186/190); revised allele call as 190
-KL150119: allele conflict at 32b (281/283); revised allele call as 283

KLSU15
-KL150271: allele conflict at 37b (172/182); revised call as 182
-KL150271: allele conflict at 49a (188/202); revised call as 188
-KL150422: multiple conflicts and possible contamination; replacing with KL150272 (from RsRExtracts_Aug12)
-KL150451 may be contaminated; will have to closely watch pedigree info
-KL150246: allele conflict at 03a (227/231); using 227 bc it was called more often

KLSU16
-KL160201: multiple allele conflicts; revised calls
-SU160119: allele conflict at 31a (137/139); revised calls as 137
-KL160246: allele conflict at 37b (159/182); using 182
-SU160170: allele conflict at 03a (229/233); only gtyped once; using 0
-KL160218: multiple allele conflicts; revised calls
-KL160258: multiple allele conflicts; revised calls
-KL160259: multiple allele conflicts; revised calls
-KL160311: multiple allele conflicts; revised calls
-SU160101: multiple allele conflicts; revised calls
-SU160174: multiple allele conflicts; revised calls
-SU160180: multiple allele conflicts; revised calls

SU16KL17
-has a slot for a third allele at locus 23. Only one sample is an apparent triploid here (KL170115 is 180/199/199; revised call as 0/0). Deleting 23c column.
-KL170156 appears to have been extracted twice. The ID given to the 2nd extraction is KL170104 (KL170104 is listed under dna1 of TISSUE_CATALOGUE_Until2018.xls) but 156 and 104 conflict at multiple loci. KL170157 has a nearly identical genotype to KL170104 (1 allele off). Comment mentions a possible sibling mixup. My guess is the 2nd tissue sample (104) was from 157 instead of 156. Removing KL170104 since it is a duplicate of KL170157.
-SU160160 has call rate of 0 and this comment: "Believed to have been switched between columns 11 and 12 in June 26 run (negative showed clean peaks); genotypes taken only from June 12 run (all highlighted samples failed to genotype 'original' run)". Deleting because it contains no data. Arianne said this was resolved.
-SU160207 has conflicts among re-extractions that are all off by 2 nucleotides (could be allele calling error). Revised calls.
-SU160162: multiple allele conflicts; revised calls
-KL170274 is present twice in SU16KL17 but not in the reextracts sheets. Using the one with no conflicting alleles
-KL170155: allele conflict at 03a (227/231); revised call as 227
-KL170252: allele conflict at 03a (227/231); revised call as 227
-KL170253: allele conflict at 42b (248/250); using 250
-KL170315: allele conflict at 14a (276/278); revised call as 0
-KL170316: allele conflict at 03a (227/231) and 14a (282/284); revised calls as 227 and 282
-KL170334: allele conflict at 37b (159/172); revised call as 172
-KL170326: allele conflict at 03a (231/233); revised call as 231
-KL170259: allele conflict at 55a (262/264); revised call as 264
-KL170272: multiple allele conflicts; revised calls
-KL170273: multiple allele conflicts; revised calls
-KL170350: multiple allele conflicts; revised calls

KLSU17
-KL170248: allele conflicts at 25a (184/188) and 25b (188/190); revised calls as 0/0
-KL170301: allele conflict at 25b (190/192) and 49b (194/202); only gtyped once, out of tissue; revised calls as 192 and 202
-KL170405: allele conflict at 50b (287/293); revised call as 293
-KL170231: multiple allele conflicts; revised calls

SU17KL18
-the dna2 sample for SU170211 is listed as SU170148 but they have a number of conflicting genotypes. SU170148 is genetically identical to another squirrel, SU170210. It appears that SU170148 and SU170210 are the same individual. 211 and 210 may have had their dna2 sample mixed up but dna2 for SU170210 was not used. Deleting SU170148 from this sheet because it is a duplicate of SU170210.
-SU170201 failed genotyping and has no dna2. Deleting because it has no data

KLSU18
-according to TISSUE_CATALOGUE_Until2018.xls, tubes containing SU180166 and SU180178 were dropped. One sample was recovered and placed into well F9. Genotype was the same as SU180177, the dna2 sample for SU180178. Thus the recovered sample belonged to SU180178 but it's a duplicate of SU180177 so deleting.
-SU180158: allele conflict at 03a (227/231); revised call as 231
-SU180212: allele conflict at 23a (195/197); revised call as 197

KL2018_Redos
-KL180335 = KL180336; KL180337 = KL180338; both squirrels are from the same litter. This plate contains 335, 336, and 338. The problem is that 335 matches 338 instead of 336(12 mismatches between 335 and 336). Likely that the sibs were mixed up when taking the second dna sample so that 336 is what 337 should be. KL180337 (the dna2 of 338) was not genotyped. Deleting KL180335 because it is a duplicate of KL180338.
-this appears to be the only plate containing a word in the label ("redo", "extracts", etc) that has samples appearing for the first time. In other words, Rruns_July29 30, RSReExtracts_Aug12, and RSReruns_Aug16 have all been consolidated with the samples in their original plate-sheets (I hope)
-KL180348: multiple allele conflicts; revised calls