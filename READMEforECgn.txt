
A. Function of the Program
-- --------------------------------------
The Goal of this program is to build a simple codon-usage gene finder for finding genes in E.Coli.
Given a sequence of nucleotides, this program finds out in which particular reading frame,
out of the 6 reading frames possible, there are genes that are similar to those found in E.Coli.
That is it gives maximum likelihood of each Reading Frame. If a Open Reading Frame has a positive
 likelihood value it is more likely to be similar to E.Coli. 
Based on the codon usage table that is obtained from matching genes and corresponding proteins they are 
translated into(in this case ffn file has genes, and faa file has proteins), a probabilistic model is built. This model is compared to Random sequence model,
in which the nucleotide frequency is computed. This comparision is by taking their log ratio and this gives the maximum likelihood.


B.Input/Output
- ---------------------------
The Training process, generating codon usage table, building probabilistic model, comparing with the random frequency model are all performed in the same program
ECgnfinder.py.
This program runs with the syntax
                                      ECgnfinder.py inputfile
outffn.fasta(102 genes) and outfaa.fasta(102 translated proteins) are the two Fasta files that are used in the program and thus they should be in the same Python
folder from where the ECgnfinder.py is running.
The codon usage table is output as a file called CodonFrequencyTable.txt

C.Sample usage
-- -------------------
test.fasta that is zipped along in the folder has a test sequence from E.Coli.
When ECgnfinder is run on this the output has ORF1 with maximum value and this would confirm that it is a gene of E.Coli.
If a single Nucleotide is added at the beginning of the sequence in the test.fasta file, the ORF2 would have the maximum value.


