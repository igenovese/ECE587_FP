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
ARGS=" -max:inst 1000000"

# Set the branch predictor
# Predictor A = PAp
A_L1_SIZE=4 									# L1 SIZE = N
A_HIST_SIZE=8									# HIST SIZE = W
A_L2_SIZE=$((2**($A_L1_SIZE+$A_HIST_SIZE)))		# L2 SIZE = 2^(N+W)


# Predictor B = PAg
B_L1_SIZE=8		# L1 SIZE = N
B_HIST_SIZE=16	# L2 SIZE = W
B_L2_SIZE=$((2**$B_HIST_SIZE))

# Meta Predictor
META_SIZE=32


ARGS="${ARGS} -bpred 2lev_comb"
ARGS="${ARGS} -bpred:2lev_comb $A_L1_SIZE $A_L2_SIZE $A_HIST_SIZE $B_L1_SIZE $B_HIST_SIZE $B_L2_SIZE $META_SIZE" 



# Print the instructions for the simulator
echo "Simulator args:"
echo $ARGS

# Wait a bit
sleep 1

# Run simulator
./Run.pl -db ./bench.db -dir results/gcc1 -benchmark gcc -sim $PWD/ss3/sim-outorder -args "-fastfwd 1000000 -max:inst 1000000"
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

