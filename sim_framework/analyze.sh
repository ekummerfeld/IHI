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
  OMIT_PREFIX="ul.omit."
  IMPUTE_PREFIX="ul.impute."
  OMIT="omit/$dir"
  IMPUTE="impute/$dir"
  ANAL_ARGS="-nr $NRUNS"
  echo "Analyzing the modified data in omit..."
  echo "java $JAVA_ARGS $ANALYZE -prefix $OMIT_PREFIX -dp $OMIT analyze.out"
  $TIME $TIME_ARGS -f "analyze.java execution time: %E" java $JAVA_ARGS $ANALYZE $ANAL_ARGS -prefix $OMIT_PREFIX -dp $OMIT >> analyze.out
    echo "java $JAVA_ARGS $ANALYZE -prefix $IMPUTE_PREFIX -dp $IMPUTE analyze.out"
  $TIME $TIME_ARGS -f "analyze.java execution time: %E" java $JAVA_ARGS $ANALYZE -prefix $IMPUTE_PREFIX -dp $IMPUTE >> analyze.out
  mv $OMIT/results/$OMIT_PREFIX"comparison.txt" generate/$dir/results/$OMIT_PREFIX"comparison.txt"
  mv $IMPUTE/results/$IMPUTE_PREFIX"comparison.txt" generate/$dir/results/$IMPUTE_PREFIX"comparison.txt"
done
