#! /bin/bash

# Check for root privileges
if [ $EUID -ne 0 ]; then
	echo "ERROR : must be logged as root. Try with sudo ;)"
	exit 1
fi
#check if file exists
if [ -z $1 ] || [ ! -f $1 ]; then
	echo "ERROR : expects first parameter to be a script file."
	exit 1
fi

sourceLines=$(grep -E '^source ' $1 | cut -d ' ' -f 2)

if [ -n "$sourceLines" ]; then
	

	# Put shebang in temp file
	head -n 1 $1 > temp

	for src in $sourceLines; do
		# Check if .sh files are present
		if [ -f $(dirname $1)/$src  ]; then
			# Append all included file. Avoid copying first line : shebang
			tail -n +2 $(dirname $1)/$src >> temp
			echo " " >> temp
		fi
	done
	# Append rest of main file. (Except first line, and all source lines)
	grep -vE 'source |^#!' $1 >> temp
else
	cat $1 > temp
fi

chmod a+x temp

scriptName=$(basename $1 | cut -d . -f 1)

mv temp /usr/local/bin/$scriptName

echo $scriptName deployed