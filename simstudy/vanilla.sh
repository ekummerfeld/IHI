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
TIME_ARGS="-o timing.txt --append"


#these arguments are what go into generate.java
DIRS=$(ls ./generate)

for dir in $DIRS
do
  PREFIX=vanilla
  echo "Analyzing the vanilla data..."
  echo "java $JAVA_ARGS $ANALYZE -prefix $PREFIX -dp generate/$dir analyze.out"
  $TIME $TIME_ARGS -f "analyze.java execution time: %E" java $JAVA_ARGS $ANALYZE -prefix $PREFIX -dp "generate/$dir" >> analyze.out
done
