#!/bin/bash

if [ "$1" == '' ]; then
    echo "RAD Server Docker pa-radserver-ib-custom-module Build-Run Script";
    echo "Place RAD Server endpoint custom resource module in this directory and pass it as the first argument";
    echo "Required argument: module filename";
    echo "ex: build.sh module.so";
else
    bash ./build.sh $1

    bash ./run-production.sh
fi