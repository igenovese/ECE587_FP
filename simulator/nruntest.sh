#!/bin/bash


# Set to true to enable screen output, false to write to file
DEBUG="false"

# Branch predictor
########################################################################################
# Predictor A = PAg
PAg_L1_SIZE=4 									# L1 SIZE = N
PAg_HIST_SIZE=8									# HIST SIZE = W
PAg_L2_SIZE=256
#PAg_L2_SIZE=$((2**$PAg_HIST_SIZE))
PAg_XOR=0

# Predictor B = PAp
PAp_L1_SIZE=8		# L1 SIZE = N
PAp_HIST_SIZE=16	# L2 SIZE = W
PAp_L2_SIZE=16777216		# L2 SIZE = 2^(N+W)
#PAp_L2_SIZE=$((2**($PAp_L1_SIZE+$PAp_HIST_SIZE)))		# L2 SIZE = 2^(N+W)
PAp_XOR=0

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
	ARGS="-fastfwd 100"

	# Set the max number of instructions
	ARGS="${ARGS} -max:inst 1000000"

	ARGS="${ARGS} -bpred 2lev_comb"	
	ARGS="${ARGS} -bpred:2lev_comb $PAg_L1_SIZE $PAg_L2_SIZE $PAg_HIST_SIZE $PAg_XOR $PAp_L1_SIZE $PAp_L2_SIZE $PAp_HIST_SIZE $PAp_XOR $META_SIZE" 
}


################################################################################################################
# 
# Defines for the simulation result output files
RUN="default"
function make_file_names {
	OUTFILE_GCC="results_script/gcc_2lev_$1.out"	
	OUTFILE_IJPEG="results_script/ijpeg_2lev_$1.out"
	OUTFILE_PEARL="results_script/pearl_2lev_$1.out"
	OUTFILE_VORTEX="results_script/vortex_2lev_$1.out"	
}

###############################################################################################################
#
# Function to run the simulations
#
function run_simulations {

	if [ $DEBUG = "true" ]; then
		./Run.pl -db ./bench.db -dir results/gcc -benchmark gcc -sim $PWD/ss3/sim-outorder -args "$ARGS"	
	else
		# Run simulator
		#./Run.pl -db ./bench.db -dir results/go  -benchmark go -sim $PWD/ss3/sim-outorder -args "$ARGS" &> $OUTFILE_GO 
		./Run.pl -db ./bench.db -dir results/gcc -benchmark gcc -sim $PWD/ss3/sim-outorder -args "$ARGS" &> $OUTFILE_GCC 
		#./Run.pl -db ./bench.db -dir results/m88ksim -benchmark m88ksim -sim $PWD/ss3/sim-outorder -args "$ARGS" &> $OUTFILE_M88KSIM 
		#./Run.pl -db ./bench.db -dir results/li -benchmark li -sim $PWD/ss3/sim-outorder -args "$ARGS" &> $OUTFILE_LI 
		./Run.pl -db ./bench.db -dir results/ijpeg -benchmark ijpeg -sim $PWD/ss3/sim-outorder -args "$ARGS" &> $OUTFILE_IJPEG
		./Run.pl -db ./bench.db -dir results/perl -benchmark perl -sim $PWD/ss3/sim-outorder -args "$ARGS" &> $OUTFILE_PEARL 
		./Run.pl -db ./bench.db -dir results/vortex -benchmark vortex -sim $PWD/ss3/sim-outorder -args "$ARGS" &> $OUTFILE_VORTEX 
		#./Run.pl -db ./bench.db -dir results/fpppp -benchmark fpppp -sim $PWD/ss3/sim-outorder -args "$ARGS" 2> $OUTFILE_FPPPP 
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


##############################################################################################################
#
# Do a single test of all benchmarks with a specific configuration
#
##############################################################################################################
RUN_NUM=1

function do_sim_run {
	PAg_L1_SIZE=$1
	PAg_HIST_SIZE=$2
	PAg_L2_SIZE=$(( 2**$PAg_HIST_SIZE ))
	PAg_XOR=$3
	PAp_L1_SIZE=$4
	PAp_HIST_SIZE=$5
	PAp_L2_SIZE=$((2**($PAp_L1_SIZE+$PAp_HIST_SIZE)))	
	PAp_XOR=$6
	META_SIZE=$7
	NAME="PAG-$1-$2-$3_PAP-$4-$5-$6_$7"	

	if(($PAp_L2_SIZE)) && ((PAg_L2_SIZE));
	then
		echo "-----------------------------------------------------------------------------------------------------------------"
		echo "Run ID: $NAME"
		echo "PAg: L1 = $PAg_L1_SIZE, HIST = $PAg_HIST_SIZE, L2 = $PAg_L2_SIZE, XOR = $PAg_XOR"  
		echo "PAp: L1 = $PAp_L1_SIZE, HIST = $PAp_HIST_SIZE, L2 = $PAp_L2_SIZE, XOR = $PAp_XOR"
		echo "META: $META_SIZE "
		echo "Run $RUN_NUM"

		make_sim_args
		make_file_names $NAME	
		run_simulations

		((RUN_NUM++))
	fi
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
# USE:	Call function do_sim_run() with the function arguments:
# 		PAg L1 Size
#		PAg History Size
#		PAp L1 Size
#		PAp History Size
#		Meta SIze
#		Run-ID --> the name will be appended to the end of the output file name
# 
#		<PAg L1>, <PAg History>, <PAg XOR>,  <PAp L1>, <PAp History>, <PAp XOR>, <Meta Size>, <Run-ID name>


# Pass in just the bits



# Meta Size
for meta in 128 256 512 1024 4096
do
	# PAg N (L1 Size in entries)
	for PAGn in 4 8 16 32
	do
		# PAg W (Hist Width)
		for PAGw in 4 8 16 32
		do
			#PAp N (L1 Size in entries)
			for PAPn in 4 8 16 32
			do
				#PAp W (Hist Width)
				for PAPw in 4 8 16 32
				do					
					do_sim_run $PAGn $PAGw 0 $PAPn $PAPw 0 $meta
				done
			done
		done
	done
done



