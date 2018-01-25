FILES=$(ls case1/save/1/data)


for  file in $FILES 
do
  diff case1/save/1/data/$file case2/save/1/data/$file
done
