#!/bin/bash
NA_HANDLING_METHOD="both"
#what algorithm to use to generate missing data
LOSS_METHOD="ul"
#currently only needed if loss method = ul
PROBABILITY=".99"

DIRS=$(ls ./generate)

make_directory() {
  if [ ! -d $1 ]
  then
    mkdir $1
  fi
}

make_directory impute
make_directory omit

for dir in $DIRS
do

  make_directory impute/$dir
  make_directory impute/$dir/save
  make_directory impute/$dir/save/1
  make_directory impute/$dir/save/1/data
  make_directory omit/$dir
  make_directory omit/$dir/save
  make_directory omit/$dir/save/1
  make_directory omit/$dir/save/1/data

  cp -r generate/$dir/save/1/graph/  impute/$dir/save/1/graph/
  cp -r generate/$dir/save/1/graph/  omit/$dir/save/1/graph/
  cp  generate/$dir/save/1/parameters.txt  impute/$dir/save/1/parameters.txt
  cp  generate/$dir/save/1/parameters.txt  omit/$dir/save/1/parameters.txt
  R_ARGS="-n $NA_HANDLING_METHOD -l $LOSS_METHOD -p $PROBABILITY -d $dir"
  echo Rscript R/main.R $R_ARGS
  Rscript R/main.R $R_ARGS >> logs/R.log
done
