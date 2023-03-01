#!/bin/bash

if [ "$1" == '' ] || [ "$2" == '' ]; then
    echo "RAD Server Docker pa-radserver-child Build-Run Script";
    echo "Required arguments: RAD Server database (InterBase) host and port";
    echo "ex: build-run.sh example.com 3050";
else
    bash ./build.sh $1 $2

    bash ./run.sh $1 $2
fi