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
	if [ ! -s $2/src/main.$1 ]; then
		mv $2/main.$1 $2/src
		cat ~/.shell-scripts-templates/projectGenerator/templates/$1.start > $2/src/main.$1
	else
		echo "A starter file already exists at "$2
	fi
}

# createSimpleDirs
# USAGE : createSimpleDirs path
# create sources and headers dirs in project root if not exist
createSimpleDirsForC(){
	mkdir -p $1/sources
	mkdir -p $1/headers
}
createSimpleDirsForCpp(){
	mkdir -p $1/src
	mkdir -p $1/build
	mkdir -p $1/bin
}

# generateC_Cpp
# USAGE generateC_Cpp langage path
# generate a c or c++ project
generateC_Cpp(){
	loadMakefile $1 $2
	loadStarterFile $1 $2
}

projectPath=$PWD;
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
	createSimpleDirsForC $2
	generateC_Cpp $fileExtension $projectPath

elif [ $1 = "Cpp" ] || [ $1 = "cpp" ] || [ $1 = "c++" ] || [ $1 = "C++" ] || [ $1 = "h" ]; then
	fileExtension="cpp";
	
	# get last directory using shell expansion to strip evrything except the last directory name
	directory=${projectPath##*/}; 

	if [ $directory = "src" ]; then
		# if we are in src, we strip it, because we want to execute from the project root,
		# which is just above in the directory tree
		projectPath=${projectPath%/src}
	fi
	echo $projectPath
	createSimpleDirsForCpp $projectPath
	generateC_Cpp $fileExtension $projectPath
else
	echo "ERROR : invalid or unsupported langage"
	exit 1
fi
cd $projectPath
make
gnome-terminal -e 'bash -c "bin/run && echo && echo Press ENTER to continue && read line && exit"'

