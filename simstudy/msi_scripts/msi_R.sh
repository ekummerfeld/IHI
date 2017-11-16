#!/bin/bash -l
#PBS -l walltime=96:00:00,nodes=1:ppn=24,pmem=2580mb
#PBS -m abe
#PBS -M arix@umn.edu
module load R
cd github/IHI/simstudy
bash R.sh
