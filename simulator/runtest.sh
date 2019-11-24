#!/bin/bash

#	1. Choose whether to to turn debug on/off



# Set to true to enable screen output, false to write to file
DEBUG="true"

# Branch predictor
########################################################################################
# Predictor A = PAp
A_L1_SIZE=4 									# L1 SIZE = N
A_HIST_SIZE=8									# HIST SIZE = W
A_L2_SIZE=$((2**($A_L1_SIZE+$A_HIST_SIZE)))		# L2 SIZE = 2^(N+W)
A_XOR=0

# Predictor B = PAg
B_L1_SIZE=8		# L1 SIZE = N
B_HIST_SIZE=16	# L2 SIZE = W
B_L2_SIZE=$((2**$B_HIST_SIZE))
B_XOR=0

# Meta Predictor
META_SIZE=32



# Simulator arguments
#########################################################################################
# Fast forward number of instructions
#ARGS="-fastfwd 1000000"

# Set the max number of instructions
#ARGS=" -max:inst 1000000"

#ARGS="${ARGS} -bpred 2lev_comb"	
#ARGS="${ARGS} -bpred:2lev_comb $A_L1_SIZE $A_L2_SIZE $A_HIST_SIZE $A_XOR $B_L1_SIZE $B_L2_SIZE $B_HIST_SIZE $B_XOR $META_SIZE" 

function make_sim_args {
	ARGS="-fastfwd 1000000"

	# Set the max number of instructions
	ARGS=" -max:inst 1000000"

	ARGS="${ARGS} -bpred 2lev_comb"	
	ARGS="${ARGS} -bpred:2lev_comb $A_L1_SIZE $A_L2_SIZE $A_HIST_SIZE $A_XOR $B_L1_SIZE $B_L2_SIZE $B_HIST_SIZE $B_XOR $META_SIZE" 
}


################################################################################################################
# 
# Defines for the simulation result output files
RUN="default"
OUTFILE_GO="results/go_2lev_$RUN.out"
OUTFILE_GCC="results/gcc_2lev_$RUN.out"
OUTFILE_M88KSIM="results/m88ksim_2lev_$RUN.out"
OUTFILE_LI="results/li_2lev_$RUN.out"
OUTFILE_IJPEG="results/ijpeg_2lev_$RUN.out"
OUTFILE_PEARL="results/pearl_2lev_$RUN.out"
OUTFILE_VORTEX="results/vortex_2lev_$RUN.out"
OUTFILE_FPPPP="results/fpppp_2lev_$RUN.out"

###############################################################################################################
#
# Function to run the simulations
#
function run_simulations {

	if [ $DEBUG = "true" ]; then
		./Run.pl -db ./bench.db -dir results/gcc -benchmark gcc -sim $PWD/ss3/sim-outorder -args "$ARGS"	
	else
		# Run simulator
		./Run.pl -db ./bench.db -dir results/go  -benchmark go -sim $PWD/ss3/sim-outorder -args "$ARGS" 2> $OUTFILE_GO 
		./Run.pl -db ./bench.db -dir results/gcc -benchmark gcc -sim $PWD/ss3/sim-outorder -args "$ARGS" 2> $OUTFILE_GCC 
		#./Run.pl -db ./bench.db -dir results/m88ksim -benchmark m88ksim -sim $PWD/ss3/sim-outorder -args "$ARGS" 2> $OUTFILE_M88KSIM 
		./Run.pl -db ./bench.db -dir results/li -benchmark li -sim $PWD/ss3/sim-outorder -args "$ARGS" 2> $OUTFILE_LI 
		./Run.pl -db ./bench.db -dir results/ijpeg -benchmark ijpeg -sim $PWD/ss3/sim-outorder -args "$ARGS" 2> $OUTFILE_IJPEG
		./Run.pl -db ./bench.db -dir results/perl -benchmark perl -sim $PWD/ss3/sim-outorder -args "$ARGS" 2> $OUTFILE_PEARL 
		#./Run.pl -db ./bench.db -dir results/vortex -benchmark vortex -sim $PWD/ss3/sim-outorder -args "$ARGS" 2> $OUTFILE_VORTEX 
		./Run.pl -db ./bench.db -dir results/fpppp -benchmark fpppp -sim $PWD/ss3/sim-outorder -args "$ARGS" 2> $OUTFILE_FPPPP 
	fi	
}
###################################################################################################################


#Available benchmarks
#go
#gcc
#m88ksim
#li
#ijpeg
#perl
#vortex
#fpppp			->CHECK



function do_sim_run {
	A_L1_SIZE=$1
	A_HIST_SIZE=$2
	B_L1_SIZE=$3
	B_HIST_SIZE=$4
	META_SIZE=$5
	RUN=$6

	echo "-----------------------------------------------------------------------------------------------------------------"
	echo "Run ID: $6 PAp: L1 = $A_L1_SIZE, HIST = $A_HIST_SIZE  PAg: L1 = $B_L1_SIZE, HIST = $B_HIST_SIZE  META: $META_SIZE "

	make_sim_args
	run_simulations
}


##############################################################################################################
#
#                  MAIN
#
##############################################################################################################

#cd ss3
#make clean
#make
#cd ..

# Wait a bit
sleep 1

# Begin simulations
RUN="test"

# USE:	Call function do_sim_run() with the function arguments:
# 		A L1 Size
#		A History Size
#		B L1 Size
#		B History Size
#		Meta SIze
#		Run-ID --> the name will be appended to the end of the output file name
# A_L1, A_Hist, B_L1, B_Hist, Meta, Run-ID


do_sim_run 8 8 8 8 128 "test"



