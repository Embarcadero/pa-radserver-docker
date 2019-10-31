# pa-radserver-docker
Docker script for RAD Studio Linux deployment including RAD Server engine

To build using the Dockerfile use the build.sh script. Note: The Dockerfile requires the radserver_docker.sh script in the same directory
./build.sh [db host] [port]
EX: ./build.sh yourhost.com 3050

To pull the Docker Hub version ot pa-radserver Docker use the pull.sh script
./pull.sh

To pull and run the Docker Hub version of pa-radserver Docker for a non-production environment use the pull-run.sh script
./pull-run.sh [db host] [port]
EX: ./pull-run.sh yourhost.com 3050

To pull and run the Docker Hub version of pa-radserver Docker for a production environment use the pull-run-production.sh script
./pull-run-production.sh [db host] [port]
EX: ./pull-run-production.sh yourhost.com 3050

To run the Docker Hub version of pa-radserver Docker for a non-production environment use the pull-run.sh script
./run.sh [db host] [port]
./run.sh yourhost.com 3050

To run the Docker Hub version of pa-radserver Docker for a production environment use the run-production.sh script
./run-production.sh [db host] [port]
./run-production.sh yourhost.com 3050

To configure the emsserver.ini file of an already running instance of pa-radserver run the config.sh script
./config.sh
The config.sh script will restart apache automatically. 

The Solutions directory contains possible usage scenarios for using the pa-radserver Docker image. 
The Custom-RAD_Server-Module solution is for the scenario in which the user has a custom module they want to deploy to RAD Server. The custom endpoint resource module needs to be in the same directory as the Dockerfile when the build-run.sh script is called. 
./pull.sh
./build-run.sh [db host] [port] [module file name]
./build-run.sh yourhost.com 3050 samplemodule.so

The Example-Child-Image solution is for the scenario in which the user wants to add other items to the docker image. The user can add apt packages other custom items through the Dockerfile. 
./pull.sh
./build-run.sh [db host] [port] [module file name]
./build-run.sh yourhost.com 3050 samplemodule.so

This software is Copyright 2019 Embarcadero Technologies, Inc.

You may only use this software if you are an authorized licensee of an Embarcadero developer tools product. This software is considered a Redistributable as defined in the software license agreement that comes with the Embarcadero Products and is governed by the terms of such software license agreement (https://www.embarcadero.com/products/rad-studio/rad-studio-eula).
