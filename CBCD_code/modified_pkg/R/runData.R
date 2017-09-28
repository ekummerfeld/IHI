runData = function(filename, # location of data file in csv format (CHECK DATA SEP!), no header 
                   e, #experimental configuration: 
                   #         -vector of length n with 0 for obs, 1 for inter and -1 for unobs          
                   sep = " ", # separator between data
                   header = TRUE, # variable names in header of data
                   test="bayes", 
                   #         -"classic" classic correlation test (p-value = 0.05)
                   #         -"bayes" integrating over the parameters
                   #         -"BIC" (default) BIC-based approximation of the bayes test, faster and almost as good
                   #         -the prior parameters are a little different, only p as the prior prob. is needed.
                   schedule=n-2, #testing properties
                   #         -independence test scheduling
                   #         -maximum conditioning set size for the independence tests
                   #         -if a number T it means all tests up to intervention tests size T
                   #           (can be Inf, default n-2 so all possible conditioning test sizes)
                   weight="log",
                   #         -how to determine the weights from the dependencies:
                   #         -"log" take log of the probability
                   #         -"constant" the most likely option (dep or indep) gets weight 1
                   #         -for "hard-deps": see option 3 below
                   #         -for competing algorithms, pc and so on, use any of the above.
                   encode="new_wmaxsat_acyclic_sufficient.pl", 
                   #         - which encoding to use, gives the file in the ASP/ directory
                   solver="clingo", #which solver to use
                   #         -"clingo", or "pcalg-pc","pcalg-cpc","pcalg-fci","pcalg-cfci" or "bnlearn" for score based learning
                   p=0.1, alpha=1.5,   ##eq. sample size for the bayes test
                   #p        -for bayes and BIC tests the apriori probability of 
                   #         -for classic test using algorithms the p-value threshold
                   #         -for BIC-based score based learning the prior parameter
                   #alpha    -for bayes test the eq. sample size
                   verbose=1, #how much information to print
                   clingoconf="--configuration=crafty --time-limit=260000 --quiet=1,0",
                   restrict = c() #what restrictions apply to model space, note that encode file 
                   #tells which restrictions are forced by the learned model space
  
                   # USE THE FOLLOWING COMBINATIONS
                   # 1) bayes or BIC test with log or constant weights and new_wmaxsat**
                   # 2) classic test with constant weights and new_wmaxsat**
                   # 3) classic test with constant weight and new_maxindep** for hard-deps
                   
                   
                   
                   ){
  

  cat('1st stage: Loading data.\n')
  
  D = list()
  D[[1]] = getData(filename, e, sep, header)

  #setting n globally
  global_n<<-n<<-D[[1]]$n
  global_indeps<<-list()
  
  cat('1st stage: Done.\n')
  
  ##############################################################################
  cat('2nd stage: Run the learning algorithm.\n')  
  
  if ( any( solver== c("pcalg-pc","pcalg-cpc","pcalg-fci","pcalg-cfci")  )) {
    L<-learn.pcalg(D,algo=solver,p_threshold=p,test);
  } else if ( any( solver== c("bnlearn")  ) ) {
    L<-learn.bnlearn(D,p_threshold=p,test);    
  } else {   #clingo or test
    L<-learn( D, #data
              test=test,schedule=schedule,
              weight=weight,encode=encode,
              p=p, alpha=alpha, clingoconf=clingoconf,verbose=1)
  }
  
  
  cat('2nd stage: Done.\n')  
  print(L)
}