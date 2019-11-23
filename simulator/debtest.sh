#!/bin/bash

# Run.pl Change directory results/gcc1
# Doing gcc
# Installing gcc

# Run.pl Install and RunCommand = ln -s /media/ryan/Shared/school/587/project/ECE587_FP/simulator/bench/little/cc1.ss run.gcc
ln -s /media/ryan/Shared/school/587/project/ECE587_FP/simulator/bench/little/cc1.ss run.gcc

# Pre-run gcc
cp /media/ryan/Shared/school/587/project/ECE587_FP/simulator/input/ref/varasm.i .

# Run gcc
/media/ryan/Shared/school/587/project/ECE587_FP/simulator/ss3/sim-outorder -fastfwd 1000000 -max:inst 1000000 -bpred 2lev_comb run.gcc varasm.i -quiet -funroll-loops -fforce-mem -fcse-follow-jumps -fcse-skip-blocks -fexpensive-optimizations -fstrength-reduce -fpeephole -fschedule-insns -finline-functions -fschedule-insns2 -O -o varasm.s > varasm.out

