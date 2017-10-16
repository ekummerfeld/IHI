#!/bin/bash -l
#PBS -l walltime=24:00:00,nodes=1:ppn=8,pmem=8000mb
#PBS -m abe
#PBS -M arix@umn.edu


module load java
java -version
cd github/IHI/simstudy
rm timing.txt
bash gen.sh
