#!/bin/bash

# Benchmarks gcc, go, li, m88ksim, pearl, ijpeg, vortex


# GCC
BENCH="gcc"
for D in $BENCH"_results"/*.out; do
	python3 ./pyextract.py $D $BENCH"_results.txt"	
done

# pearl
BENCH="pearl"
for D in $BENCH"_results"/*.out; do
	python3  ./pyextract.py $D $BENCH"_results.txt"	
done

# vortex
BENCH="vortex"
for D in $BENCH"_results"/*.out; do
	python3 ./pyextract.py $D $BENCH"_results.txt"	
done

# ijpeg
BENCH="ijpeg"
for D in $BENCH"_results"/*.out; do
	python3 ./pyextract.py $D $BENCH"_results.txt"	
done


