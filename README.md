# Simstudy
TODO
- [ ] change code so its possible to set a seed
- [ ] add the code to generate to analyze the data as soon as we generate it
- [ ] add the alogrithms we want to use
- [ ] pick the distrobutions(?)
- [ ] do some diagnostic timing to see how long run.sh takes to run

Pipeline
```
run.sh -> generate.java -> main.R -> analyze.java -> results_analysis.R
```
File structure
```
simstudy
│   run.sh
│   *.out
|
└───R
│   │  main.R
│   |  methods.R
|   │  utils.R
|
└───omit
|
└───impute
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
