#!/bin/bash -l
#PBS -l walltime=8:00:00, nodes=1:ppn=8,pmem=8gb
#PBS -m abe
#PBS -m arix@umn.edu

module load R
cd github/IHI/simstudy
bash run.sh << output.txt
