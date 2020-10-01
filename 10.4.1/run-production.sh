#!/bin/bash

if [ "$1" == '' ] || [ "$2" == '' ]; then
    echo "RAD Server Docker pa-radserver Run Script";
    echo "Required arguments: RAD Server database (InterBase) host and port";
    echo "ex: run-production.sh example.com 3050";
else
    docker run -d --mount source=ems,target=/etc/ems -e DB_PORT=$2 -e DB_HOST=$1 -e CONFIG=PRODUCTION -p 80:80 radstudio/pa-radserver
fi
