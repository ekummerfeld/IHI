#!/bin/bash
# generate some data
java -cp jar/tetrad.jar edu.cmu.tetrad.algcomparison.simstudy.generate
# run R script to create missing data
Rscript R/main.R
