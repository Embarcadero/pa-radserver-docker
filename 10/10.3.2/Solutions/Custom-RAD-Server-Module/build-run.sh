#!/bin/bash

if [ "$1" == '' ] || [ "$2" == '' ] || [ "$3" == '' ]; then
    echo "RAD Server Docker pa-radserver-custom-module Build-Run Script";
    echo "Place RAD Server endpoint custom resource module in this directory and pass it as the third argument.";
    echo "Required arguments: RAD Server database (InterBase) host and port and module filename";
    echo "ex: build-run.sh example.com 3050 module.so";
else
    if [ -e ./$1]; then
        bash ./build.sh $3;

        bash ./run.sh $1 $2;
    else
        echo "The RAD Server endpoint custom resource module needs to be in this directory.";
    fi
fi