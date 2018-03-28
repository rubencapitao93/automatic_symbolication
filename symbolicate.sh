#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 [Path] [File]"
	exit 1
fi

echo "Reading $1"

while read line; do
	stackAddress=`echo "$line" | sed 's/^.*\(0x.*\)/\1/g;s/ .*//g'`
	if [[ "$stackAddress" = *"0x"* ]]; then # if there's no address on this line, skip
		decimalAddress=`echo "$line" | sed 's/.* + //g;s/ .*//g'`
		echo "$stackAddress + $decimalAddress"
	fi
	       
done < $1