# Simstudy
TODO

General:
- [ ] Pick the final file structure

Generate.java
- [X] Allow parsing in args like nruns, sample size, etc  
- [ ] Allow options to set the kind of simulation (Simulations TBD)  
- [ ] Figure out how tetrad saves (and loads) files. Decide on whether or not modify  
- [ ] make the program run silently except for a finish confirmation  

Comparison.java --> ComparisonFlexible.java  
- [X] Change the class so one can set the name of the results file  
- [ ] Change the class to allow more flexible file naming and directory structure  

Analyze.java
- [ ] Allow options to set which algorithm to use  
- [ ] Allow parsing in dataPath, resultsPath, OutputFileName  
- [ ] make the program run silently except for a finish confirmation  

JAR File  
- [X] Figure out how to export JAR files from IntelliJ and also to run them via bash  
- [ ] See if the filesize can be made smaller

R
- [X] Create basic pipeline (input files, mess them up, output)  
- [X] give option to impute or omit  
- [X] give options on how to create missing data  
  - [ ] Tune these methods  
- [ ] Automate collating data and create visualiations  

run.sh
- [X] get basic script running (call generate, R, analyze)  
- [ ] Once the final parameters are set, change the script so it will do everything

Pipeline  
```
run.sh    
│
└─── generate.java
│   
└─── main.R
│
└─── analyze.java
│
└─── results_analysis.R
```
