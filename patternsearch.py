import re
import numpy
import sys

#Open and read in contents from Inputlines file into an array
inputlinesfile=open(sys.argv[1],"r")
inputlines = inputlinesfile.readlines()

#Read in contents from Patterns files into an array
patternfile=open(sys.argv[2],"r")
patterns = patternfile.readlines()

Mode1 = []
Mode2 = []
Mode3 = []

#Function to compute Levenshein Distance
#--------------------------
def getLevensheinDistance(string1,string2):
    n = len(string1)
    m = len(string2)

    #makeing sure that no. of rows is shorter than no. of columns
    #to reduce the complexity when doing dynamic programming
    if n>m:
        string1,string2 = string2,string1
        n,m=m,n

    DistM = numpy.zeros(((n+1),(m+1)),int)

    for i in range(1,(n+1)):
        for j in range(1,(m+1)):
            DistM[i][0]= i
            DistM[0][j]= j

    for i in range(1,(n+1)):
        for j in range(1,(m+1)):
            score_up = DistM[i-1][j]
            score_left = DistM[i][j-1]
            score_diagonal = DistM[i-1][j-1]
            min_score = min(score_up,score_left,score_diagonal)
            if(string1[i-1] == string2[j-1]):
                DistM[i][j] = min_score + 0
            else:
                DistM[i][j] = min_score + 1

    edit_distance = DistM[n][m]
    return edit_distance        

#Pattern Searching and Matching
for pattern in patterns:
    for line in inputlines:
        searchline = line.rstrip("\n")#remove the new line character
        searchpattern = pattern.rstrip("\n")

        #Exact Match
        if (searchpattern==searchline):
            Mode1.append(searchline)
                 
        #any match in the line
        if(re.search(searchpattern,searchline)):
            Mode2.append(searchline)
            
        #Approximate match with edit distance<=1
        #For every word and given pattern find out edit distance using
        #Levenshein Distance
        searchline_words = searchline.split()
        validEdit = []
        #check if the pattern string has more than one word, if so split it
        #and calculate distance with every word from pattern string.
        if (len(searchpattern.split())>1):
            pattern_split = searchpattern.split()
            for pattern_word in range(0,len(pattern_split)):
                for word in range(0,len(searchline_words)):
                    editD = getLevensheinDistance(searchline_words[word],pattern_split[pattern_word])
                    if (editD <= 1):
                        validEdit.append(searchline_words[word])
        else:
            for word in range(0,len(searchline_words)):
                editD = getLevensheinDistance(searchline_words[word],searchpattern)
                #if there is a word with edit distance less than 1 in a particular line
                #add that word into validEdit array
                if (editD <= 1):
                    validEdit.append(searchline_words[word])
                    
        #if in a given line there are one or more words with edit distance
        # greater than or equal to 1, consider that line
        if(len(validEdit) >= 1):
            Mode3.append(searchline)
        

#Making sure that a line is present only once in a given Module
#In other words removing the duplicate lines
Mode1 = list(set(Mode1))
Mode2 = list(set(Mode2))
Mode3 = list(set(Mode3))

print "Mode1: Exact Match Lines"
print "-----------------------------"
for line in range(0,len(Mode1)):
    print Mode1[line]

print "Mode2: Any word match Lines"
print "-----------------------"
for line in range(0,len(Mode2)):
    print Mode2[line]

print "Mode3: Approximate Match with Edit distance <=1"
print "--------------------------"
for line in range(0,len(Mode3)):
    print Mode3[line]
