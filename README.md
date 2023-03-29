# pa-radserver-docker
Docker script to build RAD Studio Linux deployment image including RAD Server engine

**Note:** *This image needs a different container running InterBase to function.*

- Container available on [Docker Hub](https://hub.docker.com/r/radstudio/pa-radserver)
- DocWiki [PAServer Documentation](http://docwiki.embarcadero.com/RADStudio/en/PAServer,_the_Platform_Assistant_Server_Application)
- DocWiki [RAD Server Docker Deployment](https://docwiki.embarcadero.com/RADStudio/en/RAD_Server_Docker_Deployment)
- More information on [RAD Studio](https://www.embarcadero.com/products/rad-studio)
- Other containers: [PAServer](https://github.com/Embarcadero/paserver-docker) and [RAD Server with InterBase](https://github.com/Embarcadero/pa-radserver-ib-docker).

The image defaults to running **PAServer** on port `64211` with the _password_ `securepass`, and **Broadwayd** on port `8082`

The 10.x images use Ubuntu 18.04.6 LTS (Bionic Beaver) while the 11.x images use Ubuntu 22.04.1 LTS (Jammy Jellyfish)

## Instructions

If you want to modify or build from GitHub without using [Docker Hub](https://hub.docker.com/r/radstudio/pa-radserver), you can build the Dockerfile with the `build.sh` script. **Note:** The Dockerfile requires the `paserver_docker.sh` script in the same directory

Usage: `./build.sh [db host] [port]`
```
./build.sh yourhost.com 3050
```

To pull the [Docker Hub version of pa-radserver](https://hub.docker.com/r/radstudio/pa-radserver) image use the `pull.sh` script
```
./pull.sh
```
or
```
docker pull radstudio/pa-radserver:latest
```
Where `latest` is the desired tag.

To pull and run the [Docker Hub version of pa-radserver](https://hub.docker.com/r/radstudio/pa-radserver) image for a debug/non-production environment use the `pull-run.sh` script

Usage: `./pull-run.sh [db host] [port]`
```
./pull-run.sh yourhost.com 3050
```

To pull and run the [Docker Hub version of pa-radserver](https://hub.docker.com/r/radstudio/pa-radserver) image for a production/non-debug environment use the `pull-run-production.sh` script

Usage: `./pull-run-production.sh [db host] [port]`
```
./pull-run-production.sh yourhost.com 3050
```

To run the Docker Hub version of pa-radserver Docker for a non-production environment use the `run.sh` script

Usage: `./run.sh [db host] [port]`
```
./run.sh yourhost.com 3050
```

To run the [Docker Hub version of pa-radserver](https://hub.docker.com/r/radstudio/pa-radserver) image for a production/non-debug environment use the `run-production.sh` script

Usage: `./run-production.sh [db host] [port]`
```
./run-production.sh yourhost.com 3050
```

To configure the `emsserver.ini` file of an already running instance of pa-radserver run the `config.sh` script
```
./config.sh
```
The `config.sh` script will restart apache automatically. 

The Solutions directory contains possible usage scenarios for using the pa-radserver Docker image. 
The Custom-RAD_Server-Module solution is for the scenario in which the user has a custom module they want to deploy to RAD Server. The custom endpoint resource module needs to be in the same directory as the Dockerfile when the `build-run.sh` script is called.

Usage: `./build-run.sh [db host] [port] [module file name]`
```
./pull.sh
./build-run.sh yourhost.com 3050 samplemodule.so
```

The Example-Child-Image solution is for the scenario in which the user wants to add other items to the docker image. The user can add apt packages other custom items through the Dockerfile. 

Usage: `./build-run.sh [db host] [port] [module file name]`
```
./pull.sh
./build-run.sh yourhost.com 3050 samplemodule.so
```

--- 

This software is Copyright &copy; 2023 by [Embarcadero Technologies, Inc.](https://www.embarcadero.com/)

_You may only use this software if you are an authorized licensee of an Embarcadero developer tools product. See the latest [software license agreement](https://www.embarcadero.com/products/rad-studio/rad-studio-eula) for any updates._

![Embarcadero(Black-100px)](https://user-images.githubusercontent.com/821930/211648635-c0db6930-120c-4456-a7ea-dc7612f01451.png#gh-light-mode-only)
![Embarcadero(White-100px)](https://user-images.githubusercontent.com/821930/211649057-7f1f1f07-a79f-44d4-8fc1-87c819386ec6.png#gh-dark-mode-only)

