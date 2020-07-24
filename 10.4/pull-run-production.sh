#!/bin/bash

if [ "$1" == '' ] || [ "$2" == '' ]; then
    echo "RAD Server Docker pa-radserver Pull-Run Script";
    echo "Required arguments: RAD Server database (InterBase) host and port";
    echo "ex: pull-run-production.sh example.com 3050";
else
    docker pull radstudio/pa-radserver

    bash ./run-production.sh $1 $2
fi