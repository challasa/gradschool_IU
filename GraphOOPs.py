#!/usr/bin/env python

import numpy
import operator
import math
import sys
import re

global infile
f= open(sys.argv[1],'r')

#By reading in the first line,Check if the file has more than 3 columns
f1=f.readline()
d=f1.split()
if len(d)>2 or len(d)<2:
        raise TypeError('The input graph file should have only two columns')
#Read the entire file 
infile = f.readlines()

#A class to get nodes, edges, adjacency, distance matrices, calculate clustering coefficient,
#and Degree of centrality

class Graph:    
        nodes=[]
        for i in infile:
            y=i.split()
            if y[0] not in nodes:
                nodes.append(y[0])
            if y[1] not in nodes:
                nodes.append(y[1])
        
        Edges=[]
        for i in infile:
            y=i.split()
            Edges.append(y[0]+'-'+y[1])

        def getNodes(self):
            print self.nodes            

        def getEdges(self):
            print self.Edges

        def getAdjacencyMatrix(self):
            global nodeslist
            nodeslist=self.nodes
            global adjmatrix
            adjmatrix=numpy.zeros((len(nodeslist),len(nodeslist)),int)
            for i in range(len(nodeslist)):
                for j in range(0,len(infile)):
                    y=infile[j].split()
                    if nodeslist[i]==y[0]:
                        b=y[1]
                        v1=nodeslist.index(b)
                        adjmatrix[i][v1]=adjmatrix[v1][i]=1
            print adjmatrix
         #Calculating the Weight Matrix, apply Floyd-Warshall algorithm
         # to get the Distance Matrix
        def getDistanceMatrix(self):
            distmatrix=numpy.zeros((len(nodeslist),len(nodeslist)),int)
            for i in range(0,len(nodeslist)):
                for j in range(0,len(infile)):
                    y=infile[j].split()
                    if nodeslist[i]==y[0]:
                        b=y[1]
                        v1=nodeslist.index(b)
                        distmatrix[i][v1]=distmatrix[v1][i]=1
                for i in range(0,len(adjmatrix)):
                    for j in range(0,len(adjmatrix)):
                        if adjmatrix[i][j]==1:
                            distmatrix[i][j]=1
                        else:
                            distmatrix[i][j]=999
                for i in range(0,len(adjmatrix)):
                    for j in range(0,len(adjmatrix)):
                        if i==j:
                            distmatrix[i][j]=0
                for k in range(0,len(adjmatrix)):
                    for i in range(0,len(adjmatrix)):
                        for j in range(0,len(adjmatrix)):
                            if distmatrix[i][j]>distmatrix[i][k]+distmatrix[k][j]:
                                distmatrix[i][j]=distmatrix[i][k]+distmatrix[k][j]
            print distmatrix

        # Get Clustering Coefficient of the Graph based on Adjacency Matrix
        def getClusteringCoefficient(self):
            index=[]
            C_eachnode=[]
            ClusteringCoeff=0
            for i in range(0,len(adjmatrix)):
                num=0
                ejk=0
                for j in range(0,len(adjmatrix)):
                    if adjmatrix[i][j]==1:
                        num=num+1
                        index.append(j)
                for k in range(0,len(index)):
                    t1=index[k]
                    for l in range(0,len(index)):
                        t2=index[l]
                        if adjmatrix[t1][t2]==1:
                            ejk=ejk+1
                numerator=2 * (operator.truediv(ejk,2))
                denominator=num * (num-1)
                if denominator==0:
                    C_eachnode.append(0)
                else:
                    Ci=operator.truediv(numerator,denominator)
                    C_eachnode.append(Ci)
                index=[]
            ClusteringCoeff=operator.truediv(sum(C_eachnode),len(nodeslist))
            print ClusteringCoeff

        #Get  Degree Centrality of the graph based on Adjacency Matrix
        def getDegreeCentrality(self):
            CD=[]
            DegreeVertex=[]
            CD1=[]
            for i in range(0,len(adjmatrix)):
                num=0
                for j in range(0,len(adjmatrix)):
                    if adjmatrix[i][j]==1:
                        num=num+1
                DegreeVertex.append(num)
                DegreeCentrality_i=operator.truediv(num,len(adjmatrix)-1)
                CD.append(DegreeCentrality_i)
            for i in range(0,len(nodeslist)):
                n=max(CD)-CD[i]
                CD1.append(n)
            Centrality_Graph=operator.truediv(sum(CD1),(len(nodeslist)-2))
            print Centrality_Graph
        
            
                            
            
#Creating an Instance of class Graph

instance=Graph()

print "Given Graph has the following nodes"
instance.getNodes()
print ""
print ""
print "The following are the Edges"
instance.getEdges()
print ""
print "Adjacency Matrix is as Follows"
instance.getAdjacencyMatrix()
print ""
print "Distance Matrix is as Follows"
instance.getDistanceMatrix()
print ""
print "Given Graph has a Clustering Coefficient of:"
instance.getClusteringCoefficient()
print ""
print "Degree of Centrality is:"
instance.getDegreeCentrality()



    






                
    


    
    
                    
                
                
                
        
        
        


		             
        
        

        
