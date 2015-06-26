import numpy
import math
import operator
import sys
##Training with 411 sequences
#To get Nucleotide frequencies
infile=open("outffn_MM.fasta","r").readlines()
seq=''
title=[]
for line in infile:
        if line.startswith('>'):
                try:
                        y=line[:-1]
                        title.append(y)
                except IndexError:
                        pass
        else:
                seq+=line[:-1]

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
#getting codon frequencies.These are used to get the initial probabilities in the markov
#chain formula
codonusage={}
for n in range(0,len(seq),3):
        codon=seq[n:n+3]
        if codonusage.has_key(codon):
                codonusage[codon]+=1
        else:
                codonusage[codon]=1

totalcodons=0
for h in codonusage:
        totalcodons += int(codonusage.get(h))

codonFreq={}
for codon in codonusage.iterkeys():
        Freq=operator.truediv(codonusage[codon],totalcodons)
        codonFreq[codon]=Freq
#list of codons used to generate Transition Matrix
codons=['ATA','ATC','ATT','ATG','ACA','ACC','ACG','ACT','ACT','AAC','AAT','AAA','AAG','AGC','AGT','AGA','AGG','CTA','CTC','CTG','CTT','CCA','CCC','CCG','CCT','CAC','CAT','CAA','CAG','CGA','CGC','CGG','CGT','GTA','GTC','GTG','GTT','GCA','GCC','GCG','GCT','GAC','GAT','GAA','GAG','GGA','GGC','GGG','GGT','TCA','TCC','TCG','TCT','TTC','TTT','TTA','TTG','TAC','TAA','TAG','TGC','TGT','TGA','TGG']

#Creating a Matrix with all values initialised to 1 which is the psudocount
TM=numpy.zeros((len(codons),len(codons)),int)
for i in range(0,len(codons)):
        for j in range(0,len(codons)):
                TM[i][j]=1                
#building transition matrix taking sequence by sequence 
infileforTM=open("outffn_MM.fasta","r").read()
Rec=infileforTM.split('>')
allseq=[]
for i in Rec:
        i='>'+i
        allseq.append(i)
for s in allseq:
        splitS=s.split('\n')
        trainingseq="".join(splitS[1:])
        for k in range(0,len(trainingseq),3):
                b1=trainingseq[k:k+3]
                b2=trainingseq[k+3:k+6]
                for t in range(0,len(codons)):
                        if codons[t]==b1:
                                v=t
                for j in range(0,len(codons)):
                        if codons[j]==b2:
                                v1=j
                if b1=='' or b2=='':
                        TM[v][v1]+=0
                else:
                        TM[v][v1]+=1

TMProb=numpy.zeros((len(codons),len(codons)),float)
TRM={}
for i in range(0,len(codons)):
        for j in range(0,len(codons)):
                d=sum(TM[i])
                att=codons[i]+codons[j]
                w=operator.truediv(TM[i][j],d)
                TRM[att]=w
                TMProb[i][j]=w

#definition that calculates log likelihood for each ORF
def ORF_Freq(ORF,codonFre,initposmatrix,nuclFre):
    codonfreq=[]
    indivNucl=[]
    start=''
    global initprob
    initprob=0.0
    for k in range(0,len(ORF),3):
            v12=ORF[k:k+3]
            v34=ORF[k+3:k+6]
            Z=v12+v34
            if codonFre.has_key(Z):
                    val=codonFre.get(Z)
                    Frequency=math.log10(val)
                    codonfreq.append(Frequency)        
    for j in range(0,len(ORF)):
            base=ORF[j]
            if nuclFre.has_key(base):
                    basefreq=nuclFre.get(base)
                    base_frequency=math.log10(basefreq)
                    indivNucl.append(base_frequency)
    start=ORF[0:3]
    if initposmatrix.has_key(start):
            initp=initposmatrix[start]
            initprob=initprob + (math.log10(initp))
        
    #TransitionProbabilities=sum(codonfreq)
    #ProbabilisticModel=operator.mul(initprob,TransitionProbabilities)
    ProbModel= initprob + (sum(codonfreq))
    RandomSequenceModel=sum(indivNucl)
    Prob= ProbModel - RandomSequenceModel
    return Prob
#definition that gives forward ORFs
def getforwardorfs(eachseq):
        global orf1
        orf1=''
        global orf2
        orf2=''
        global orf3
        orf3=''
        for i in range(0,len(eachseq)):
                orf1=eachseq[0:len(eachseq)-2]
                orf2=eachseq[1:len(eachseq)-1]
                orf3=eachseq[2:len(eachseq)]
        return (orf1,orf2,orf3)
#definition to get reverse ORFs
def getreverseorfs(eachseq):
        global orf4
        orf4=''     
        global orf5
        orf5=''
        global orf6
        orf6=''
        complement_map={'A':'T','T':'A','G':'C','C':'G'}
        compl=map(complement_map.get,eachseq)
        compl.reverse()
        complementtestsequence="".join(compl)
        for k in range(0,len(complementtestsequence)):
                orf4=complementtestsequence[0:len(complementtestsequence)-2]
                orf5=complementtestsequence[1:len(complementtestsequence)-1]
                orf6=complementtestsequence[2:len(complementtestsequence)]
        return (orf4,orf5,orf6)
        
#takiing in the input file and getting likelihoods for each ORF                
testfile=open(sys.argv[1],"r").read()
records=testfile.split('>')
seqlist=[]
count=0
for i in records:
        i='>'+i
        seqlist.append(i)
for sq in seqlist:
        splitCR=sq.split('\n')
        tsequence="".join(splitCR[1:])
        a=getforwardorfs(tsequence)
        b=getreverseorfs(tsequence)
        print '----------------------------------'
        frame1 = ORF_Freq(a[0],TRM,codonFreq,nucleotideFreq)
        print 'ORF1',':', frame1
        frame2 = ORF_Freq(a[1],TRM,codonFreq,nucleotideFreq)
        print 'ORF2',':', frame2
        frame3 = ORF_Freq(a[2],TRM,codonFreq,nucleotideFreq)
        print 'ORF3',':', frame3
        frame4=ORF_Freq(b[0],TRM,codonFreq,nucleotideFreq)
        print 'ORF4',':', frame4
        frame5=ORF_Freq(b[1],TRM,codonFreq,nucleotideFreq)
        print 'ORF5',':', frame5
        frame6=ORF_Freq(b[2],TRM,codonFreq,nucleotideFreq)
        print 'ORF6',':', frame6
        
        
        
        




        
        









                


                
        


        
                            
                    
                            
                                                    

                    
                    
                
                            
                    
            
