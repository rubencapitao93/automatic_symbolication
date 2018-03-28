#!/bin/bash

## check if two arguments were provided
if [ "$#" -ne 2 ]; then
	echo "Usage: $0 [Path] [File]"
	exit 1
fi

## print information to the user
echo "Opening application: [$1]"
echo "Reading crash file: [$2]"

## read the file in loop
while read line; do
	## check for anything that starts with '0x' and assume it is the stack address
	stackAddress=`echo "$line" | sed 's/^.*\(0x.*\)/\1/g;s/ .*//g'`

	## confirm that one was found
	if [[ "$stackAddress" = *"0x"* ]]; then 
		decimalAddress=`echo "$line" | sed 's/.* + //g;s/ .*//g'`
		loadAddress=`echo "obase=16;ibase=10;$(($stackAddress-$decimalAddress))" | bc`
		
		## debug only
		## echo "$stackAddress + $decimalAddress"
		
		## translate the memory addresses to function names (if those are found on the symbols)
		## to do this, we use the official `atos` command
		atos -o "$1" -l $loadAddress $stackAddress -arch arm64
	fi
	       
done < <(tr -d '\r' < "$2") 
## it's possible to use only "$2" in the line above, however, in some files, we get a "syntax error: invalid arithmetic operator"
## to fix this, we remove the carriage returns from the file's lines.