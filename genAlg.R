#Implementation of Genetic Algorithm
#--------------------------------------

geneticalgo<-function(set_size,popln_size,generations,dependantvarfile,datafile){
	descriptor_list<-names(datafile) #get all the Descriptors into a list
	len=length(descriptor_list)
	subsets=matrix(0,nrow=popln_size,ncol=set_size)
	for(individual in c(1:popln_size)){
      	         select<-sample(len,set_size,replace=FALSE)   #Initialisation
	         subsets[individual,]=select
	}
	#create all the arrays and matrices required further
	#----------------------------------------------------
	RMSE=numeric(popln_size)
	coefficients=matrix(0,nrow=popln_size,ncol=set_size+1)
	fitness=0*c(1:popln_size)
	matingpopln=matrix(0,nrow=popln_size,ncol=set_size)
	childpopln=matrix(0,nrow=popln_size,ncol=set_size)
	bestrmse=0*c(1:popln_size)
	RMSE_child=numeric(popln_size)
	coefficients_child=matrix(0,nrow=popln_size,ncol=set_size+1)
	fit_child=0*c(1:popln_size)

	gen=2
	while(gen<=generations){         
			#Building a Model
			#----------------
			for(individual in c(1:popln_size)){
      			                 a=subsets[individual,]
      			                 X<-as.matrix(datafile[a])
	      		                 Y<-dependantvarfile[,1]
	      		                 linearmodel=lm(Y~X,data=datafile)
      			                 coefficients[individual,]=coef(linearmodel)
	      		                 res<-residuals(linearmodel)
      			                 RMSE[individual]<-sqrt(mean((res^2)))
	      	        }
      	                #RMSE_avg=mean(RMSE)
			#calculating fitness
			#--------------------
			for (i in 1:length(RMSE)){
     				fitness[i]=(1/RMSE[i]) 
	      	        }

			avgfit=mean(fitness)

			#Mating Population
			#------------------
			fit_best=which(fitness>avgfit)
			l_fit=length(fit_best)
			matingpopln[1:l_fit,]=subsets[fit_best[1:l_fit],] #making sure all the best chromosomes are taken into mating popln.

			#RouletteWheel selection
			#----------------------
			probabilities=numeric(popln_size)
			for (i in c(1:popln_size)){
	    			  probabilities[i]=fitness[i]/sum(fitness)
		 	}    
			prob_max=max(probabilities)
			prob_sum=sum(probabilities)

			size=l_fit+1
			while (size<=popln_size){
      		                  rndnumb=sample(c(1:popln_size),1)
            		          n=runif(1,min=0,max=max(probabilities))
		                  nj=probabilities[rndnumb]
      		                  if (n>nj){
            		                   matingpopln[size,]=subsets[rndnumb,]
				           size=size+1
      	       	                  }
		        }	

      		#Mutation and singlepoint crossover
	      	#-------------------------------------
			k=1
			while (k<=popln_size){
      		                     n=runif(1,min=0,max=1)
            		             if(n<=0.1){
	                  	            rn=sample(c(1:set_size),1)         #select the point of mutation
		                            rn1=sample(c(1:popln_size),1)      #select the individual to be mutated
      		                            rn2=subsets[rn1,]                  
            		                    rn3=sample(c(1:len),1)             #select a random gene from the pool,to replace the point of mutation.
                  		            rn2[rn]=rn3                        #mutate
		                            childpopln[k,]=rn2
      		                            k=k+1
            		             }else {
               			        s=sample(c(1:popln_size),2)
	                  	        s1=matingpopln[s[1],]                  #select 2 individuals
	      	                        s2=matingpopln[s[2],]
      	      	                        if (is.logical(all.equal(s1,s2))){
            	      	 		     #do not do anything both the individuals are same            
	            	                }else{
      	            	                     rn=sample(c(1:set_size),1)      #select the point of cross-over
            	            	             hn=s1[1:rn]                     #crossover
	                  	             s1[1:rn]=s2[1:rn]               
      	                  	             s2[1:rn]=hn                           
	      	              	             childpopln[k,]=s1
      	      	        	             if(k>=popln_size){
            	      	                            break
                  	      	             } else {
			      	      	          k=k+1
				                  childpopln[k,]=s2
		             	                  k=k+1
				               }
            		                }
	              	             }
     			 } 


			for (indiv in c(1:popln_size)){
      			                a=childpopln[indiv,]
	      		                X<-as.matrix(datafile[a])
		      	                Y<-dependantvarfile[,1]
	      		                linearmodel1=lm(Y~X,data=datafile)
	      		                coefficients_child[indiv,]=coef(linearmodel1)
		      	                res<-residuals(linearmodel1)
	      		                RMSE_child[indiv]<-sqrt(mean((res^2)))
	      	       }

      	               #RMSE_childavg=mean(RMSE_child)
			for (i in 1:length(RMSE_child)){
     				fit_child[i]=(1/RMSE_child[i])
	         	}
	               #Make sure that the fittest individual between child and initial population is taken into second generation
                       #-----------------------------------------------------------------------------------------------------
			fpbest=max(fitness)
			chbest=max(fit_child)
			if(fpbest>chbest){
      		                firstpopbest=which.max(fitness)
            		        bestrmse[gen]=RMSE[firstpopbest]
	   			poplnbest=subsets[firstpopbest,]
	      	                poplncoeff=coefficients[firstpopbest,]
      	      	                childpopln[2,]=poplnbest
              
			} else{
      	      	               childpopbest=which.max(fit_child)
	            	       poplnbest=childpopln[childpopbest,]
		               poplncoeff=coefficients_child[childpopbest,]
      		               bestrmse[gen]=min(RMSE_child)
        		 }
 
			if(bestrmse[gen]==bestrmse[gen-1]){
      			         passedgen=passedgen+1
			         if(passedgen==200){
      			                break
			         }
      		        }
			else{
			       passedgen=0
			}
		   subsets=childpopln    #make the child population as the next generation's population
		   gen=gen+1             #go to next generation
	  }

	x=c(2:gen)
	y=bestrmse[2:gen]
	plot(x,y)
	print (gen)
	print (bestrmse[gen-1])
	print (names(datafile[poplnbest]))
	print (poplncoeff)
   }       
      