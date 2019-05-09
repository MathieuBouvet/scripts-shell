#!/bin/bash

while getopts ":a:b" opt; do
	case $opt in
		a)
			echo "-a was triggered, parameter: $OPTARG"
			;;
		b)
			echo "-b was triggered"
			;;
		\?)
			echo "Invalid option: -$OPTARG"
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument"
			exit 1
			;;
	esac
done
shift "$(($OPTIND -1))"
echo $1
echo $2
