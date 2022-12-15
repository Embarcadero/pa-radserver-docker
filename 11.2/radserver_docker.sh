#!/bin/bash

if [ "$CONFIG" = "PRODUCTION" ]; then
	:
else
	nohup broadwayd :2 &
	export GDK_BACKEND=broadway
	export BROADWAY_DISPLAY=:2
fi

#search and replace ems ini file InstanceName
if [ "$DB_HOST" = "" ]; then
	:
else
	sed -i ':a;N;$!ba;s#InstanceName=[^\n]*#InstanceName='"${DB_HOST}/${DB_PORT}"'#g' /etc/ems/emsserver.ini
fi

/usr/sbin/apachectl -D Foreground
status=$?
if [ $status -ne 0 ]; then
	  echo "Failed to start apache: $status"
	  exit $status
fi

if [ "$CONFIG" = "PRODUCTION" ]; then
	:
else
	./paserver -password=$PA_SERVER_PASSWORD 
	status=$?
	if [ $status -ne 0 ]; then
		echo "Failed to start paserver: $status"
		exit $status
	fi
fi

while sleep 60; do
	ps aux |grep paserver |grep -q -v grep
	PA_SERVER_STATUS=$?
	ps aux |grep apache |grep -q -v grep
	APACHE_STATUS=$?
	if [ $PA_SERVER_STATUS -eq 0 -a $APACHE_STATUS -eq 0 ]; then
		echo "Complete!"
		exit 1
	fi
done
