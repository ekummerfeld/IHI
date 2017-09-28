#!/bin/bash

#create aliases for the java programs
GENERATE=edu.cmu.tetrad.algcomparison.simstudy.generate
ANALYZE=edu.cmu.tetrad.algcomparison.simstudy.analyze

#it is important to pay attention to these args
#these arguments set the parameters of the generated data
NRUNS="500"
NVARS="100"
NSAMPLES="2000"
AVGD="2"
SEED=$(date +%s)
#these arguments are what go into generate.java
GEN_ARGS="-nr $NRUNS -nv $NVARS -ss $NSAMPLES -ad $AVGD -seed $SEED"
###############################################################################
#these are the arguments that the R portion needs
#how to hanlde the missing data before sending it back to tetrad
#valid options are impute, omit, both
NA_HANDLING_METHOD="omit"
#what algorithm to use to generate missing data
LOSS_METHOD="ul"
#currently only needed if loss method = ul
PROBABILITY="1"

R_ARGS="-n $NA_HANDLING_METHOD -l $LOSS_METHOD -p $PROBABILITY"
###############################################################################
TIME=/usr/bin/time
TIME_ARGS="-o timing.txt --append"
echo $GEN_ARGS $R_ARGS >> "timing.txt"
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

# Run generate.java with arguments given by GEN_ARGS
echo java -cp jar/tetrad.jar $GENERATE $GEN_ARGS
$TIME $TIME_ARGS -f "generate.java execution time: %E" java -cp jar/tetrad.jar $GENERATE $GEN_ARGS >> generate.out

if [ $? -eq 0 ]
  then
    echo "Simulation complete. \
Data saved to save/1/ and generate output written to generate.out"
  else
    echo "Error! Simulation failed to run! Exiting..."
    exit
fi
PREFIX=$(date +%s).vanilla
echo "Analyzing the vanilla data..."
echo "java -cp jar/tetrad.jar $ANALYZE -prefix $PREFIX. analyze.out"
$TIME $TIME_ARGS -f "analyze.java execution time: %E" java -cp jar/tetrad.jar $ANALYZE -prefix $PREFIX. >> analyze.out

if [ $? -eq 0 ]
  then
    echo "Analysis complete. algcomparison results can be found in \
results/$PREFIX.comparison.txt"
  else
    echo "Error! analyze.java failed to run! Exiting..."
    exit
fi
#run R/main.R to create missing values in acoordance with R_ARGS
echo Rscript R/main.R $R_ARGS
$TIME $TIME_ARGS -f "main.R execution time: %E" Rscript R/main.R $R_ARGS >> R.out

if [ $? -eq 0 ]
  then
    echo "main.R completed. R console outout is in R.out."
  else
    "Error! R/main.R failed to run! Exiting..."
    exit
fi
# this moves the data in impute and omit (if they exist) into save/1/data
# and then runs analyze.java on them and then puts the comparison in results
for dir in $DIRS
do
  if [ -d $dir ]
    then
      PREFIX=$(date +%s).$NA_HANDLING_METHOD.$LOSS_METHOD$PROBABILITY
      mv -T $dir/ save/1/data/
      echo "moving $dir to save/1/data and running analyze.java..."
      echo java -cp jar/tetrad.jar $ANALYZE -prefix $PREFIX.
      $TIME $TIME_ARGS -f "analyze.java execution time: %E" java -cp jar/tetrad.jar $ANALYZE -prefix $PREFIX. >> analyze.out
      if [ $? -eq 0 ]
        then
          echo "Analysis complete. algcomparison results can be found in \
results/$PREFIX.comparison.txt"
        else
          echo "Error! analyze.java failed to run! Exiting..."
          exit
      fi
  fi
done
