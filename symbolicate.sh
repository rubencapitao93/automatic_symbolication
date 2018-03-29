#!/bin/bash

## check if two arguments were provided
if [ "$#" -ne 2 ]; then
	echo "Usage: $0 [Path] [File]"
	exit 1
fi

## print information to the user
echo "Opening application: [$1]"
echo "Reading crash file: [$2]"
echo "Starting to translate"
echo ""
echo "-----------------------"
echo ""

## read the file in loop
while read line; do

	## confirm that the current line has both a stack and decimal addresses
	if [[ $line = *"0x"* ]] && [[ $line = *" + "* ]]; then
		
		## check for anything that starts with '0x' and assume it is the stack address
		stackAddress=`echo "$line" | sed 's/^.*\(0x.*\)/\1/g;s/ .*//g'`

		decimalAddress=`echo "$line" | sed 's/.* + //g;s/ .*//g'`
		loadAddress=`echo "obase=16;ibase=10;$(($stackAddress-$decimalAddress))" | bc`
		
		## translate the memory addresses to function names (if those are found on the symbols)
		## to do this, we use the official `atos` command
		atos -o "$1" -l $loadAddress $stackAddress -arch arm64
	else

		## to have a readable crash log, let's divide this by thread
		if [[ $line = *"Thread"* ]]; then
			echo ""
			echo "$line"
		fi
	fi
	       
done < <(tr -d '\r' < "$2") 
## it's possible to use only "$2" in the line above, however, in some files, we get a "syntax error: invalid arithmetic operator"
## to fix this, we remove the carriage returns from the file's lines.

echo ""
echo "-----------------------"