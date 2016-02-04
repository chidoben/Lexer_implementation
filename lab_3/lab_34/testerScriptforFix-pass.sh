#!/bin/bash

#superscript
# just good command to know: llvm-dis < test1_fix.bc
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo '-----------------Compiling-----------------'
make


for i in {1..10}
do
	echo '---------Executing test'$i 'fix-pass------------'
	command='opt -load ./p34.so -fix-pass test"$i".bc -o test"$i"_fix.bc' # create correct bitcode
	eval $command

	echo '-----Executing fixed code and comparing----'
	command='lli < test"$i"_fix.bc > test"$i"_fix.out' # generate output with fixed code
	eval $command
	result=$(diff -y test"$i".out test"$i"_fix.out) #compare outputs

	if [ $? -eq 0 ]
	then
			printf ${GREEN}
	        echo "$result"
	        echo 'Correct result for test'$i
	        printf "${NC}\n\n"
	else
			printf ${RED}
	        echo 'Incorrect result for test'$i
	        echo "$result"
	        printf "${NC}\n\n"
	fi
done

for i in {1..5}
do
	echo '---------Executing test'$i 'def-pass------------'
	command='opt -load ./p34.so -def-pass test"$i".bc -o test"$i"_def.bc 2> test"$i"Answer.def' # create correct bitcode
	eval $command

	file1=$(sort test"$i"Answer.def > test"$i"Answer.def.sorted)
	file1=$(sort test"$i".def > test"$i".def.sorted)
	result=$(diff -y test"$i"Answer.def.sorted test"$i".def.sorted) #compare outputs

	if [ $? -eq 0 ]
	then
			printf ${GREEN}
	        echo "$result"
	        echo 'Correct result for test'$i
	        printf "${NC}\n\n"
	else
			printf ${RED}
	        echo 'Incorrect result for test'$i
	        echo "$result"
	        printf "${NC}\n\n"
	fi
done