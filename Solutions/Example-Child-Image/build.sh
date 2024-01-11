#!/bin/bash

if [ "$1" = '' ] || [ "$2" = '' ]; then
    echo "RAD Server Docker pa-radserver-child Build Script";
    echo "Required arguments: RAD Server database (InterBase) host and port";
    echo "ex: build.sh example.com 3050";
else
    docker build --build-arg password=securepass --build-arg dbhost=$1 --build-arg dbport=$2 -t pa-radserver-child .
fi