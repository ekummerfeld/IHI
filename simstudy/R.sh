NA_HANDLING_METHOD="omit"
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

for dir in $DIRS
do
  make_directory rout/$dir
  make_directory rout/$dir
  make_directory rout/$dir/save
  make_directory rout/$dir/save/1
  make_directory rout/$dir/save/1/data

  cp -r generate/$dir/save/1/graph/  rout/$dir/save/1/graph/
  cp  generate/$dir/save/1/parameters.txt  rout/$dir/save/1/parameters.txt
  R_ARGS="-n $NA_HANDLING_METHOD -l $LOSS_METHOD -p $PROBABILITY -d $dir"
  echo Rscript R/main.R $R_ARGS
  Rscript R/main.R $R_ARGS
done
