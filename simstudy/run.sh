#!/bin/bash
# generate some data
generate=edu.cmu.tetrad.algcomparison.simstudy.generate
args="-nv 100 -nr 200 -ss 1000 -ad 2" 
java -cp jar/tetrad.jar $generate $args 
# run R script to create missing data
#Rscript R/main.R
