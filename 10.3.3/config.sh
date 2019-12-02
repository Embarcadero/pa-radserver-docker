#!/bin/bash

docker exec -it $1 sh -c "apt-get update && apt-get install -y nano ; nano /etc/ems/emsserver.ini; service apache2 restart"