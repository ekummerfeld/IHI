# Simstudy
TODO

General:
- [X] Pick the final file structure
  * create a tmp folder for R modified datasets?

TETRAD:
- [ ] ~~add F score as a statistic (?)~~
  * ~~at least add AHP and AHR to the statistics if not~~
- [ ] Code a way to set the seed before generating the data

Generate.java
- [X] Allow parsing in args like nruns, sample size, etc
- [ ] Allow options to set the kind of simulation (Simulations TBD)
- [X] Figure out how tetrad saves (and loads) files. Decide on whether or not modify
  * Can add prefix to output files to give metadata on the simulaton parameters.
  * However, Tetrad isn't flexible enough to support loading in files with prefixes on their names
  * Therefore, run data like Tetrad wants, except have `Analyze.java` reults output as `prefix + comparison.txt`
- [ ] ~~make the program run silently except for a finish confirmation~~ (too much work)
- [ ] Use algcomparison before exiting to save IO later

Comparison.java --> ComparisonFlexible.java
- [X] Change the class so one can set the name of the results file
- [ ] ~~Change the class to allow more flexible file naming and directory structure~~

Analyze.java
- [ ] Allow options to set which algorithm to use (algorithms TBD)
- [X] Allow parsing in dataPath, resultsPath, OutputFileName
- [ ] ~~make the program run silently except for a finish confirmation~~

JAR File
- [X] Figure out how to export JAR files from IntelliJ and also to run them via bash
- [ ] ~~See if the filesize can be made smaller~~

R
- [X] Create basic pipeline (input files, mess them up, output)
- [X] give option to impute or omit
- [X] give options on how to create missing data
  - [ ] Tune these methods
- [X] input files from /save/1/data, create missing data, and store in R/tmp
- [X] rm data in save/1/data, when handling MVs, output to that directory
 - [ ] need to create impute/omit R scripts ot take files out of tmp so tetrad will run them
- [ ] Automate collating data and create visualizations
- [X] Set up main.R to parse in args from bash
  * Need to add functionality or imputing, or omitting

run.sh
- [X] get basic script running (call generate, R, analyze)
- [ ] Once the final parameters are set, change the script so it will do everything

Pipeline
```
run.sh -> generate.java -> main.R -> analyze.java -> results_analysis.R
```
File structure
```
simstudy
│   run.sh
│   tetrad.out
|
└───R
│   │  main.R
│   |  methods.R
|   │  utils.R
|   └───tmp
│        | na.data.txt
|
└───save───1
|          |  parameters.txt
|          |
|          └───data
|          |     |  data.x.txt
|          |
|          └───graphs
|                |  graph.x.txt
└───results
    | prefix.comparison.txt
```
