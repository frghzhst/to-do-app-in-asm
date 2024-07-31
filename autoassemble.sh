#!/bin/bash

$srcname
$objname
$exname
$run

echo "what is the name of the source file: "
read srcname
echo "what will the obj file name be: "
read objname
echo "what will the exe name be: "
read exname
echo "run when done compiling(yes or no)?"
read run
echo "compiling"
nasm -f elf32 $srcname -o $objname
echo "assembled"
ld -m elf_i386 $objname -o $exname
echo "linked"

if [[ $run == "yes" ]]; then
	./$exname
	echo "finished running with an exit status of $?"
else
	echo "exiting script"
fi
