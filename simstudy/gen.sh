#!/bin/bash

#create aliases for the java programs
GENERATE=edu.cmu.tetrad.algcomparison.simstudy.generate
ANALYZE=edu.cmu.tetrad.algcomparison.simstudy.analyze
JAVA_ARGS="-Xmx49152m -cp jar/tetrad.jar"

TIME=/usr/bin/time
TIME_ARGS="-o timing.txt --append"


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


VARS="10 100"
SAMPLES="100 1000"

for var in $VARS
do
  for sample in $SAMPLES
  do
    # this script redirects stdout when running tetrad or main.R to a *.out
    # So, delete the files if they exist to keep info only relevant to current sim
    OUTPUT_FILES="generate.out analyze.out R.out"
    for file in $OUTPUT_FILES
    do
      if [ -f $file ]
        then
          rm -r $file
        fi
    done

    NRUNS="500"
    NVARS=$var
    NSAMPLES=$sample
    AVGD="2"
    # change this so you can reproduce data
    SEED=$(date +%s)

    GEN_ARGS="-nr $NRUNS -nv $NVARS -ss $NSAMPLES -ad $AVGD -seed $SEED"
    echo $GEN_ARGS $R_ARGS >> "timing.txt"
    # Run generate.java with arguments given by GEN_ARGS
    echo java $JAVA_ARGS $GENERATE $GEN_ARGS
    $TIME $TIME_ARGS -f "generate.java execution time: %E" java $JAVA_ARGS $GENERATE $GEN_ARGS >> generate.out
    check_error generate.java "Data saved to save/1/ and generate output written to generate.out"
  done
done
