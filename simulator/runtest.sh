#!/bin/bash

cd ss3
make clean
make
cd ..
sleep 1

# Print current working directory
echo "Current directory is: $PWD"

# Simulator arguments
#########################################################################################
# Fast forward number of instructions
ARGS="-fastfwd 1000000"

# Set the max number of instructions
ARGS+=" -max:inst 1000000"

# Set the branch predictor
ARGS+=" -bpred:2lev_comb 8 32 16 8 256 65535 1024"
#ARGS+=" -bpred:2lev 4 16 32 0"



# Print the instructions for the simulator
echo "Simulator args:"
echo $ARGS

# Wait a bit
sleep 1

# Run simulator
#./Run.pl -db ./bench.db -dir results/gcc1 -benchmark gcc -sim $PWD/ss3/sim-outorder -args "-fastfwd 1000000 -max:inst 1000000"

./Run.pl -db ./bench.db -dir results/gcc1 -benchmark gcc -sim $PWD/ss3/sim-outorder -args "$ARGS"


