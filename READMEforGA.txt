There are two programmes involved in the project.
Programs were written in R ( on Windows OS)

There should be two files read into R before running these functions.
One with the response variable values and the other with the independent variable values.

1) bruteforce.R

A function to do brute force evaluation of different sized subsets of descriptors.
---------------------------------------------------------------------------------------------------
The function takes in the subset size (3,4,5 ,etc...), datafile with the values for all 
descriptors, dependent variables file.
Please load the gtools package before running this function.
To use the function:
                                      bruteforce(set_size,datafile,dependentvarfile)
          e.g. for 3-subset :  bruteforce(3,descriptor_infile,dependentvar)
Function prints the minimum RMSE value, best set of Descriptors, Coefficients for that set.


$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
2)genAlg.R


A function to implement the genetic algorithm
-----------------------------------------------------------
The function takes in the subset size(3,4,5,etc..), population size, number of generations, 
datafile with the values for all the descriptors, dependent variables file.
To use the function :
                            geneticalgo(set_size, popln_size, generations, dependentvarfile, datafile)
            e.g. for 3-subset, 100 as population size, for 1000 generations
                            geneticalgo(3,100,1000, dependentvar,descriptor_infile)
Function prints the generation at which the population converged, minimum RMSE value, best set of descriptors,
coefficients for the best set.
