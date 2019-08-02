#!/bin/bash

if [ -z $1 ]; then
	echo "ERROR : expects first parameter to be the class name"
	exit 1;
fi
path=$PWD

# place ourselves in src directory if possible
# TODO : implement a skiping option
if [ -d ${path}/src ]; then
	path=${path}/src
fi

# TODO : implement a force option
if [ ! -e $path/main.cpp ]; then
	echo "A main file must exist at "$path" in order to generate classes"
	exit 1;
fi

name=${1^}
if [ ! -s $path/$name.h ]; then
	# if definition file is empty or does not exist, create it
	cat ~/.shell-scripts-templates/cppClassGenerator/classDefinition.template | 
	sed "s/%HEADER_DEF%/${name^^}/g; s/%CLASS_NAME%/${name}/g" > $path/$name.h
	echo "Generating definition file... OK"
else
	echo "definition file already exists for class "$name
fi

if [ ! -s $path/$name.cpp ]; then
	# if implementation file is empty or does not exist, create it
	cat ~/.shell-scripts-templates/cppClassGenerator/classImplementation.template | sed "s/%CLASS_NAME%/${name}/" > $path/$name.cpp
	echo "Generating implementation file... OK"
else
	echo "implementation file already exists for class "$name
fi