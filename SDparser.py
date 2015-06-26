import re
import sys
import time
infile=open("exactMass.txt",'r').readlines()
mass={}
for element in infile:
    y=element.split()
    mass[y[0]]=y[1]
molwt=0.0
Cn=0
Nn=0
On=0
Molwt=[]
CountC=[]
CountN=[]
CountO=[]
CPU=[]
walltime=[]
cmpdfile=open(sys.argv[1],'r').readlines()
outfile1=open("Counts.txt",'w')
count=0
d=re.compile('^\s\s\s.*')
for line in cmpdfile:
    startCPU=time.clock()
    startwall=time.time()
    if d.search(line):
        k=line.split()
        w=mass[k[3]]
        if k[3]=='C':
            Cn=Cn+1
        if k[3]=='N':
            Nn=Nn+1
        if k[3]=='O':
            On=On+1
        molwt=molwt+ float(w)
    if line.startswith('$$$$'):
        Molwt.append(molwt)
        CountC.append(Cn)
        CountN.append(Nn)
        CountO.append(On)
        print >>outfile1,Cn,'\t',Nn,'\t',On
        endCPU=time.clock()- startCPU
        endwall=time.time()- startwall
        CPU.append(endCPU)
        walltime.append(endwall)
        molwt=0.0
        Cn=0
        Nn=0
        On=0
        count=count+1
avgMolecularwt=sum(Molwt)/len(Molwt)
avgTimepermol=sum(walltime)/len(walltime)
avgCPUtime=sum(CPU)/len(CPU)
print "avgMolecularwt","=",avgMolecularwt
print "avgTimepermol","=",avgTimepermol
print "averageCPUTime","=",avgCPUtime
print "No. of Molecules","=",count

