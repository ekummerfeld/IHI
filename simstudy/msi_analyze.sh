#!/bin/bash -l
#PBS -l walltime=196:00:00,nodes=1:ppn=1,mem=51200mb
#PBS -m abe
#PBS -M arix@umn.edu
module load java
cd github/IHI/simstudy
bash analyze.sh
