#ECgnfinder.py
#---------------

import operator
import sys
import math

#Read in the testfile that has the testsequence
#Read line by line and make sure that the first line begins with'>'
#if not raise an exception

testfile=open(sys.argv[1],'r')
line=testfile.readline()
if not line.startswith(">"):
        raise TypeError("Not a Fasta File")
    
title=line[1:].rstrip()
sequence_lines=[]
while 1:
    line=testfile.readline().rstrip()
    if line == "":
        break
    sequence_lines.append(line)

testsequence="".join(sequence_lines)

#Training with the ffn and faa files of the E.Coli
#seq from the ffn file
fasta=open("outffn.fasta",'r').readlines()
seq=''
title1=[]

for line in fasta:
    if line.startswith(">"):
        try:
            y=line[:-1]
            title1.append(y)
        except IndexError:
            pass
    else:
        seq+=line[:-1]

#Count Number of each nucleotide in the sequence, part of implementing
#the Random Sequence model

A=seq.count('A')
T=seq.count('T')
G=seq.count('G')
C=seq.count('C')

L=len(seq)
FrA=operator.truediv(A,L)
FrT=operator.truediv(T,L)
FrG=operator.truediv(G,L)
FrC=operator.truediv(C,L)

nucleotideFreq={}
nucleotideFreq['A']=FrA
nucleotideFreq['T']=FrT
nucleotideFreq['G']=FrG
nucleotideFreq['C']=FrC

#Reading in faa file
aafasta=open("outfaa.fasta",'r').readlines()
seque=''
faatitle=[]
for line in aafasta:
    if line.startswith(">"):
        try:
            y=line[:-1]
            faatitle.append(y)
        except IndexError:
            pass
    else:
        seque+=line[:-1]+'_'

#Once we have read in the ffn and faa file, as a part of training,
#we have to teach that a set of 3 different codons represent an amino acid.
#One way of acheiving that is concatenate aminoacid with the codons it is represented
#by. 
#The concatenation of amino acid and the codon will become easy if we have both
# in a list or string of the same length.
#Here we are splitting the seq string obtained from ffn file into set of 3 codons
#and appending them into a list called tripletseq

tripletseq=[]
for n in range(0,len(seq),3):
        triplet=seq[n:n+3]
        tripletseq.append(triplet)

#Concatenating or matching
matchedseq=''
for f in range(0,len(tripletseq)):
        match=seque[f]+tripletseq[f]
        matchedseq+=match
             
        
#Getting the codon usage
codonusage={}
for n in range(0,len(matchedseq),4):
    codon = matchedseq[n:n+4]
    if codonusage.has_key(codon):
        codonusage[codon] += 1
    else:
        codonusage[codon] = 1

totalcodons= 0
for h in codonusage:
    totalcodons += int(codonusage.get(h))


#codon frequency
    
codonFreq={}
for codon in codonusage.iterkeys():
    Freq=operator.truediv(codonusage[codon],totalcodons)
    T=list(codon)
    matchsplit="".join(T[1:4])    
    codonFreq[matchsplit]= Freq
#Print the codon frquency table into output file.
Outfile=open("CodonFrequecyTable.txt",'w')
for codn in codonFreq.keys():
    print >>Outfile, codn,'\t',codonFreq[codn]

Outfile.close()

#Finding ORF's in the testsequence
for n in range(0,len(testsequence)):
    ORF1=testsequence[0:len(testsequence)-2]
    ORF2=testsequence[1:len(testsequence)-1]
    ORF3=testsequence[2:len(testsequence)]

#getting ORFs in the reverse direction
#complement bases
complement_map={'A':'T','T':'A','G':'C','C':'G'}
compl=map(complement_map.get,testsequence)
compl.reverse()
complementtestsequence="".join(compl)

for n in range(0,len(complementtestsequence)):
    ORF4=complementtestsequence[0:len(complementtestsequence)-2]
    ORF5=complementtestsequence[1:len(complementtestsequence)-1]
    ORF6=complementtestsequence[2:len(complementtestsequence)]

#Function that builds Probabilistic model based on the codon usage table,
#implements random sequence model and
#compares probabilistic model with the random model
#gives maximum likelihood ratio
#log (ProbabilisticModel/RandomModel)= log ProbabilisticModel + log RandomModel
#this gives maximum likelihood

def ORF_Freq(ORF,codonFre,nuclFre):
    indivcodonfreq=[]
    indivNucl=[]
    for i in range(0,len(ORF),3):
        codons=ORF[i:i+3]
        if codonFre.has_key(codons):
            val=codonFre.get(codons)
            Frequency=math.log10(val)
            indivcodonfreq.append(Frequency)
    for j in range(0,len(ORF)):
        base=ORF[j]
        if nuclFre.has_key(base):
            basefreq=nuclFre.get(base)
            base_frequency=math.log10(basefreq)
            indivNucl.append(base_frequency)
    ProbabilisticModel=sum(indivcodonfreq)
    RandomSequenceModel=sum(indivNucl)
    Prob= ProbabilisticModel - RandomSequenceModel
    return Prob
    

frame1 = ORF_Freq(ORF1,codonFreq,nucleotideFreq)
print 'ORF1',':', frame1
frame2 = ORF_Freq(ORF2,codonFreq,nucleotideFreq)
print 'ORF2',':', frame2
frame3 = ORF_Freq(ORF3,codonFreq,nucleotideFreq)
print 'ORF3',':', frame3
frame4=ORF_Freq(ORF4,codonFreq,nucleotideFreq)
print 'ORF4',':', frame4
frame5=ORF_Freq(ORF5,codonFreq,nucleotideFreq)
print 'ORF5',':', frame5
frame6=ORF_Freq(ORF6,codonFreq,nucleotideFreq)
print 'ORF6',':', frame6




            
            
        
        

    
    




    


        
    
        
