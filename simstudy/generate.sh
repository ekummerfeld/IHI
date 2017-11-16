#!/bin/bash

#create aliases for the java programs
GENERATE=edu.cmu.tetrad.algcomparison.simstudy.generate
ANALYZE=edu.cmu.tetrad.algcomparison.simstudy.analyze
JAVA_ARGS="-Xmx49152m -cp jar/tetrad.jar"

TIME=/usr/bin/time
TIME_ARGS="-o logs/timing.txt --append"


# function to perform error checking
check_error() {
  if [ $? -eq 0 ]
  then
    echo "$1 complete. $2"
  else
    echo "Error! $1 failed to run! Exiting..."
    exit
  fi
}


VARS="30 100"
SAMPLES="100 200 300 400 500 600 700 800 900 1000"

for var in $VARS
do
  for sample in $SAMPLES
  do
    # this script redirects stdout when running tetrad or main.R to a *.out
    # So, delete the files if they exist to keep info only relevant to current sim
    NRUNS="200"
    NVARS=$var
    NSAMPLES=$sample
    AVGD="2"
    # change this so you can reproduce data
    SEED=$(date +%s)

    GEN_ARGS="-nr $NRUNS -nv $NVARS -ss $NSAMPLES -ad $AVGD -seed $SEED"
    echo $GEN_ARGS $R_ARGS >> "logs/timing.txt"
    # Run generate.java with arguments given by GEN_ARGS
    echo "Running java $JAVA_ARGS $GENERATE $GEN_ARGS"
    $TIME $TIME_ARGS -f "generate.java execution time: %E" java $JAVA_ARGS $GENERATE $GEN_ARGS >> logs/generate.log
    echo "The seed was $SEED." >> logs/generate.log
    check_error generate.java "Data saved to generate/ and output written to logs/generate.log"
  done
done
