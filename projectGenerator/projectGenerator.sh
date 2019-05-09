#!/bin/bash


# loadMakefile
# USAGE : loadMakefile language path
# copy language specific makefile template in project path
loadMakefile(){
	if [ ! -e $2/makefile ]; then
		cat ~/.shell-scripts-templates/projectGenerator/templates/$1.template > $2/makefile
	else
		echo "A makefile already exists at "$2
	fi
}

# loadStarterFile
# USAGE : loadStarterFile langauge path fileExtension
# copy language specific starter file in project path
# only if starter file does not exist or is empty
loadStarterFile(){
	if [ ! -s $2/main.$1 ]; then
		cat ~/.shell-scripts-templates/projectGenerator/templates/$1.start > $2/main.$1
	else
		echo "A starter file already exists at "$2
	fi
}

# createSimpleDirs
# USAGE : createSimpleDirs path
# create sources and headers dirs in project root if not exist
createSimpleDirs(){
	mkdir -p $1/sources
	mkdir -p $1/headers
}

# generateC_Cpp
# USAGE generateC_Cpp langage path
# generate a c or c++ project
generateC_Cpp(){
	loadMakefile $1 $2
	loadStarterFile $1 $2
	createSimpleDirs $2
}

projectPath=$(pwd)
#check if a langage is provided
if [ -z $1 ]; then
	echo "ERROR : expects first parameter to be set to a langage"
	exit 1;
fi
#check if directory is provided
if [ ! -z $2 ] && [ -d $2 ]; then
	projectPath=$2
fi
#check which langage is provided
if [ $1 = "C" ] || [ $1 = "c" ]; then
	fileExtension="c"
	generateC_Cpp $fileExtension $projectPath
elif [ $1 = "Cpp" ] || [ $1 = "cpp" ] || [ $1 = "c++" ] || [ $1 = "C++" ]; then
	fileExtension="cpp";
	generateC_Cpp $fileExtension $projectPath

else
	echo "ERROR : invalid or unsupported langage"
	exit 1
fi 

