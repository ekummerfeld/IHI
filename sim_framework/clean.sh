#!/bin/bash

OUTPUT_FILES="generate.out analyze.out R.out timing.txt"
for file in $OUTPUT_FILES
do
  if [ -f logs/$file ]
    then
      rm -r logs/$file
    fi
done
