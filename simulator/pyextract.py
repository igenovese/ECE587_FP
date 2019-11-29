#!/usr/bin/python3

import sys
import re
 
COMMA = ", "

def ExtractNumber(str):
	#print("Extracting:", str)
	return re.search(r'\d+\.\d+', str).group()

def ExtractParams(str):
	return re.findall(r'\d+ ', str)

filename = sys.argv[1]
print("Extracting from file: ", filename)

validResults = False

with open(filename, "rt") as myfile:

	for oneline in myfile:
		if "Combined 2-level predictor config" in oneline:
			params = ExtractParams(oneline)
			#print(params)
			validResults = True
		if "IPC" in oneline:
			ipc = ExtractNumber(oneline)
			validResults = True
		if "bpred_addr_rate" in oneline:
			addr_rate = ExtractNumber(oneline)
			validResults = True
		if "bpred_dir_rate" in oneline:
			dir_rate = ExtractNumber(oneline)
			validResults = True

myfile.close()                   # close the file

if validResults == True:

	# Assemble the list
	parmlist = filename + COMMA
	for n in params:
		parmlist = parmlist + n + COMMA
	parmlist = parmlist + ipc + COMMA  
	parmlist = parmlist + addr_rate + COMMA
	parmlist = parmlist + dir_rate + "\n"
	print(parmlist)

	f = open(sys.argv[2], "a")
	f.write(parmlist)
	f.close()


