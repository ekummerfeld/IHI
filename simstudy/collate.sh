#!/bin/bash

PREFIX=""
OUTPUT="vanilla.data.csv"
DIRS=$(ls ./generate)

COUNT=0
for dir in $DIRS
do
  if [ $COUNT -eq 0 ]
  then
    sed -n '53,56p' generate/$dir/results/$PREFIX* >> data/$OUTPUT
    let COUNT=COUNT+1
  fi
  sed -n '54,56p' generate/$dir/results/$PREFIX* >> data/$OUTPUT
done

egrep -lRZ " +" data/$OUTPUT | xargs -0 -l sed -i -e 's/ \+/,/g'
