NA_HANDLING_METHOD="omit"
#what algorithm to use to generate missing data
LOSS_METHOD="ul"
#currently only needed if loss method = ul
PROBABILITY=".99"
DIR="ss100nv10"
R_ARGS="-n $NA_HANDLING_METHOD -l $LOSS_METHOD -p $PROBABILITY -d $DIR"

Rscript R/main.R $R_ARGS
