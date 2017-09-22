#!/bin/bash
#create aliases for the java programs
GENERATE=edu.cmu.tetrad.algcomparison.simstudy.generate
ANALYZE=edu.cmu.tetrad.algcomparison.simstudy.analyze

#it is important to pay attention to these args
GEN_ARGS="-nr 100 -nv 100 -ss 100 -ad 2"
R_ARGS="-n derp -l ul -p .99"

# deletes tetrad.out (if it is there) when a new simulation is being run
if [ -f tetrad.out ]; then
    rm tetrad.out
fi
# Run generate.java with arguments given by GEN_ARGS
echo java -cp jar/tetrad.jar $GENERATE $GEN_ARGS >> tetrad.out
java -cp jar/tetrad.jar $GENERATE $GEN_ARGSs >> tetrad.out

if [ $? -eq 0 ]
  then
    echo "Simulation complete. \
Data saved to save/1/ and tetrad output written to tetrad."
  else
    echo "Error! Simulation failed to run! Exiting..."
    exit
fi
#run R/main.R to create missing values in acoordance with R_ARGS
echo Rscript R/main.R $R_ARGS
Rscript R/main.R $R_ARGS

if [ $? -ne 0 ]
  then
    echo "Error! R/main.R failed to run! Exiting..."
    exit
fi
