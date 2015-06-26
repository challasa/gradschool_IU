# A function to do brute force evaluation of different sized subsets of descriptors.
#------------------------------------------------------------------------------------
#The function takes in the subset size (3,4,5 ,etc...), datafile with the values for all descriptors, dependent variables file.
#To run the function:
#  e.g. for 3-subset :  bruteforce(3,descriptor_infile,dependentvar)
#Function prints the minimum RMSE value, best set of Descriptors, Coefficients for that set.

bruteforce<-function(set_size,datafile,dependentvarfile){
	descriptor_list<-names(datafile) #get all the Descriptors into a list
	l=length(descriptor_list)
	subset <- combinations(l,set_size)#generate all combinations
	dimensions<-dim(subset)
	no_of_combinations<-dimensions[1]

	RMSE<-numeric(no_of_combinations)#create an empty array to store RMSE values
	coefficients=matrix(0,nrow=no_of_combinations,ncol=(set_size+1))#an empty matrix to store Coefficients estimated by each model
	#Model Building(using lm)
      #------------------------
	for(i in (1:no_of_combinations)){
         	a=subset[i,]
	        X<-as.matrix(datafile[a])
      	        Y<-dependentvarfile[,1]
                linearmodel=lm(Y~X,data=datafile)
                coefficients[i,]=coef(linearmodel)
	       #linearmodel=svm(Y~X,data=descriptor_infile,kernel="linear")
      	        residualz <-residuals(linearmodel)
	        RMSE[i]<-sqrt(mean((residualz^2)))
      }
	minRM=which.min(RMSE)
	min_RMSE=min(RMSE)
	bestset<-descriptor_list[subset[minRM,]]
	bestcoefficients<-coefficients[minRM,]
	print (min_RMSE)
	print (bestset)
	print (bestcoefficients)

 }


