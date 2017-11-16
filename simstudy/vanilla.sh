#!/bin/bash
ANALYZE=edu.cmu.tetrad.algcomparison.simstudy.analyze
JAVA_ARGS="-Xmx49152m -cp jar/tetrad.jar"
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

TIME=/usr/bin/time
TIME_ARGS="-o logs/timing.txt --append"

#these arguments are what go into generate.java
DIRS=$(ls ./generate)

for dir in $DIRS
do
  NRUNS="200"
  PREFIX="vanilla"
  FOLDER="generate/$dir"

  echo "Analyzing the data in $FOLDER"
  echo "Running java $JAVA_ARGS $ANALYZE -prefix $PREFIX -dp $FOLDER -nr $NRUNS"
  $TIME $TIME_ARGS java $JAVA_ARGS $ANALYZE -prefix $PREFIX -dp $FOLDER -nr $NRUNS >> logs/vanilla.log
  check_error analyze.java "vanilla.comparison.txt written to $FOLDER/results."
done
