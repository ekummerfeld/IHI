#!/bin/bash

#create aliases for the java programs
GENERATE=edu.cmu.tetrad.algcomparison.simstudy.generate
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



VARS="10 100 1000"
SAMPLES="100 1000 10000"

###############################################################################
#these are the arguments that the R portion needs
#how to hanlde the missing data before sending it back to tetrad
#valid options are impute, omit, both
NA_HANDLING_METHOD="omit"
#what algorithm to use to generate missing data
LOSS_METHOD="ul"
#currently only needed if loss method = ul
PROBABILITY=".99"

R_ARGS="-n $NA_HANDLING_METHOD -l $LOSS_METHOD -p $PROBABILITY"
###############################################################################
#using the the systems timer to benchmark the porgram.
#Its not the most accurate but suittable for our purposes.
TIME=/usr/bin/time
TIME_ARGS="-o timing.txt --append"




for var in $VARS
do
  for sample in $SAMPLES
  do
    # this script redirects stdout when running tetrad or main.R to a *.out
    # So, delete the files if they exist to keep info only relevant to current sim
    OUTPUT_FILES="generate.out analyze.out R.out timing.txt"
    for file in $OUTPUT_FILES
    do
      if [ -f $file ]
        then
          rm -r $file
        fi
      done
  # same idea for the dirs omit and impute. Bash uses the existence of these dirs
  # to help run analyze.java so don't mess with the file structure at the moment
    DIRS="omit impute"
    for dir in $DIRS
    do
      if [ -d $dir ]
        then
          rm -r $dir
        fi
    done
  #it is important to pay attention to these args
  #these arguments set the parameters of the generated data
    NRUNS="500"
    NVARS=$var
    NSAMPLES=$sample
    AVGD="2"
    # change this so you can reproduce data
    SEED=$(date +%s)
    #these arguments are what go into generate.java
    GEN_ARGS="-nr $NRUNS -nv $NVARS -ss $NSAMPLES -ad $AVGD -seed $SEED"
    echo $GEN_ARGS $R_ARGS >> "timing.txt"
    # Run generate.java with arguments given by GEN_ARGS
    echo java $JAVA_ARGS $GENERATE $GEN_ARGS
    $TIME $TIME_ARGS -f "generate.java execution time: %E" java $JAVA_ARGS $GENERATE $GEN_ARGS >> generate.out
    check_error generate.java "Data saved to save/1/ and generate output written to generate.out"

    PREFIX=$SEED.vanilla
    echo "Analyzing the vanilla data..."
    echo "java $JAVA_ARGS $ANALYZE -prefix $PREFIX. analyze.out"

    # this analyzes the vanilla data before R does anything
    $TIME $TIME_ARGS -f "analyze.java execution time: %E" java $JAVA_ARGS $ANALYZE -prefix $PREFIX. >> analyze.out

    check_error analyze.java "algcomparison results can be found in results/$PREFIX.comparison.txt"

    #run R/main.R to create missing values in acoordance with R_ARGS
    echo Rscript R/main.R $R_ARGS
    $TIME $TIME_ARGS -f "main.R execution time: %E" Rscript R/main.R $R_ARGS >> R.out

    check_error main.R "R console output in R.out"

    # this moves the data in impute and omit (if they exist) into save/1/data
    # and then runs analyze.java on them and then puts the comparison in results
    for dir in $DIRS
    do
      if [ -d $dir ]
        then
          PREFIX=$SEED.$NA_HANDLING_METHOD.$LOSS_METHOD$PROBABILITY
          mv -T $dir/ save/1/data/
          echo "moving $dir to save/1/data and running analyze.java..."
          echo java $JAVA_ARGS $ANALYZE -prefix $PREFIX.
          $TIME $TIME_ARGS -f "analyze.java execution time: %E" java $JAVA_ARGS $ANALYZE -prefix $PREFIX. >> analyze.out
          check_error analyze.java "algcomparison results can be found in results/$PREFIX.comparison.txt"
      fi
    done
  done
done
