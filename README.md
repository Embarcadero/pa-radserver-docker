# pa-radserver-docker
Docker script for RAD Studio Linux deployment including RAD Server engine

- [Container available on Docker Hub](https://hub.docker.com/r/radstudio/paserver)
- [PAServer Documentation](http://docwiki.embarcadero.com/RADStudio/en/PAServer,_the_Platform_Assistant_Server_Application)
- [More information on RAD Studio](https://www.embarcadero.com/products/rad-studio)

The image defaults to running **PAServer** on port `64211` with the _password_ `securepass`, and **Broadwayd** on port `8082`

The 10.x images use Ubuntu 18.04.6 LTS (Bionic Beaver) while the 11.x images use Ubuntu 22.04.1 LTS (Jammy Jellyfish)

## Instructions

If you want to modify or build from GitHub without using [Docker Hub](https://hub.docker.com/r/radstudio/paserver), you can build the Dockerfile with the `build.sh` script. **Note:** The Dockerfile requires the `paserver_docker.sh` script in the same directory
```
./build.sh [db host] [port]
```
EX: `./build.sh yourhost.com 3050`

To pull the Docker Hub version of pa-radserver Docker use the `pull.sh` script
```
./pull.sh
```

To pull and run the Docker Hub version of pa-radserver Docker for a non-production environment use the `pull-run.sh` script
```
./pull-run.sh [db host] [port]
```
EX: `./pull-run.sh yourhost.com 3050`

To pull and run the Docker Hub version of pa-radserver Docker for a production environment use the `pull-run-production.sh` script
```
./pull-run-production.sh [db host] [port]
```
EX: `./pull-run-production.sh yourhost.com 3050`

To run the Docker Hub version of pa-radserver Docker for a non-production environment use the `run.sh` script
```
./run.sh [db host] [port]
```
EX: `./run.sh yourhost.com 3050`

To run the Docker Hub version of pa-radserver Docker for a production environment use the `run-production.sh` script
```
./run-production.sh [db host] [port]
```
EX: `./run-production.sh yourhost.com 3050`

To configure the `emsserver.ini` file of an already running instance of pa-radserver run the `config.sh` script
```
./config.sh
```
The `config.sh` script will restart apache automatically. 

The Solutions directory contains possible usage scenarios for using the pa-radserver Docker image. 
The Custom-RAD_Server-Module solution is for the scenario in which the user has a custom module they want to deploy to RAD Server. The custom endpoint resource module needs to be in the same directory as the Dockerfile when the `build-run.sh` script is called. 
```
./pull.sh
./build-run.sh [db host] [port] [module file name]
./build-run.sh yourhost.com 3050 samplemodule.so
```

The Example-Child-Image solution is for the scenario in which the user wants to add other items to the docker image. The user can add apt packages other custom items through the Dockerfile. 
```
./pull.sh
./build-run.sh [db host] [port] [module file name]
./build-run.sh yourhost.com 3050 samplemodule.so
```

_This software is Copyright © [Embarcadero Technologies, Inc.](https://www.embarcadero.com/)_

_You may only use this software if you are an authorized licensee of an Embarcadero developer tools product. This software is considered a Redistributable as defined in the software license agreement that comes with the Embarcadero Products and is governed by the terms of such [software license agreement](https://www.embarcadero.com/products/rad-studio/rad-studio-eula)._

![Embarcadero(Black-100px)](https://user-images.githubusercontent.com/821930/211648635-c0db6930-120c-4456-a7ea-dc7612f01451.png#gh-light-mode-only)
![Embarcadero(White-100px)](https://user-images.githubusercontent.com/821930/211649057-7f1f1f07-a79f-44d4-8fc1-87c819386ec6.png#gh-dark-mode-only)
