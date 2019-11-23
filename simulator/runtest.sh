#!/bin/bash

#cd ss3
#make clean
#make
#cd ..
#sleep 5

# Print current working directory
echo "Current directory is: $PWD"

# Simulator arguments
#########################################################################################
# Fast forward number of instructions
ARGS="-fastfwd 1000000"

# Set the max number of instructions
ARGS="${ARGS} -max:inst 1000000"

# Set the branch predictor
ARGS="${ARGS} -bpred 2lev_comb"




# Print the instructions for the simulator
echo "Simulator args:"
echo $ARGS

# Wait a bit
sleep 1

# Run simulator
#./Run.pl -db ./bench.db -dir results/gcc1 -benchmark gcc -sim $PWD/ss3/sim-outorder -args "-fastfwd 1000000 -max:inst 1000000"
./Run.pl -db ./bench.db -dir results/go 	 -benchmark go 		-sim $PWD/ss3/sim-outorder -args "$ARGS" 2> results/go_2lev_default.out 
./Run.pl -db ./bench.db -dir results/gcc	 -benchmark gcc 	-sim $PWD/ss3/sim-outorder -args "$ARGS" 2> results/gcc_2lev_default.out 
./Run.pl -db ./bench.db -dir results/m88ksim -benchmark m88ksim -sim $PWD/ss3/sim-outorder -args "$ARGS" 2> results/m88ksim_2lev_default.out 
./Run.pl -db ./bench.db -dir results/li 	 -benchmark li 		-sim $PWD/ss3/sim-outorder -args "$ARGS" 2> results/li_2lev_default.out 
./Run.pl -db ./bench.db -dir results/ijpeg 	 -benchmark ijpeg 	-sim $PWD/ss3/sim-outorder -args "$ARGS" 2> results/ijpeg_2lev_default.out 
./Run.pl -db ./bench.db -dir results/perl 	 -benchmark perl 	-sim $PWD/ss3/sim-outorder -args "$ARGS" 2> results/perl_2lev_default.out 
./Run.pl -db ./bench.db -dir results/vortex  -benchmark vortex 	-sim $PWD/ss3/sim-outorder -args "$ARGS" 2> results/vortex_2lev_default.out 
./Run.pl -db ./bench.db -dir results/fpppp   -benchmark fpppp 	-sim $PWD/ss3/sim-outorder -args "$ARGS" 2> results/fpppp_2lev_default.out 


#Available benchmarks
#go
#gcc
#m88ksim
#li
#ijpeg
#perl
#vortex
#fpppp			->CHECK

