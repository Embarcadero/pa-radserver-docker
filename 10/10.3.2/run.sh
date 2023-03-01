#!/bin/bash

if [ "$1" == '' ] || [ "$2" == '' ]; then
    echo "RAD Server Docker pa-radserver Run Script";
    echo "Required arguments: RAD Server database (InterBase) host and port";
    echo "ex: run.sh example.com 3050";
else
    echo "PAServer Password: securepass"
    docker run -it --mount source=ems,target=/etc/ems -e DB_PORT=$2 -e DB_HOST=$1 -e PA_SERVER_PASSWORD=securepass -p 80:80 -p 64211:64211 -p 8082:8082 radstudio/pa-radserver
fi
