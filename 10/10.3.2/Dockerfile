FROM ubuntu:bionic

ARG dbhost=localhost
ARG dbport=3050
ARG password=embtdocker
ENV DB_HOST=$dbhost
ENV DB_PORT=$dbport
ENV PA_SERVER_PASSWORD=$password

COPY radserver_docker.sh ./radserver_docker.sh


#INSTALL APACHE AND OTHER LIBS

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -yy install --no-install-recommends \
    apache2 \
    unzip \
    xorg libgl1-mesa-dev libosmesa-dev libgtk-3-bin build-essential libcurl3 libcurl-openssl1.0-dev \
    && apt-get -y autoremove \
    && apt-get -y autoclean
#====END OTHER LIBS

#====GET ZIP FILES====
ADD http://altd.embarcadero.com/getit/public/libraries/RADServer/RADServerInstallerLinux_1032.zip ./radserver.zip
ADD http://altd.embarcadero.com/releases/studio/20.0/PAServer/Release2/LinuxPAServer20.0.tar.gz ./paserver.tar.gz

RUN unzip radserver.zip
RUN tar xvzf paserver.tar.gz
#========END ZIP FILES

RUN touch ./radserverlicense.slip

RUN sh ./radserver_install.sh -silent

RUN mv PAServer-20.0/* .

#populate emsserver.ini with interbase connection data
RUN cp /etc/ems/objrepos/emsserver.ini /etc/ems/emsserver.ini
RUN echo "#!/bin/bash" > ./emsscript.sh
RUN echo "sed -i 's/\\\r\$//' /etc/ems/emsserver.ini" >> ./emsscript.sh
RUN echo "sed -i ':a;N;\$!ba;s#\\\[!DBINSTANCENAME\\\]\\\n#$dbhost$ForwardSlash$dbport\\\n#g' /etc/ems/emsserver.ini" >> ./emsscript.sh
RUN echo "sed -i ':a;N;\$!ba;s#\\\[!DBPATH\\\]\\\n#/etc/ems/emsserver.ib\\\n#g' /etc/ems/emsserver.ini" >> ./emsscript.sh
RUN echo "sed -i ':a;N;\$!ba;s#\\\[!DBUSERNAME\\\]\\\n#sysdba\\\n#g' /etc/ems/emsserver.ini" >> ./emsscript.sh
RUN echo "sed -i ':a;N;\$!ba;s#\\\[!DBPASSWORD\\\]\\\n#masterkey\\\n#g' /etc/ems/emsserver.ini" >> ./emsscript.sh
RUN echo "sed -i ':a;N;\$!ba;s#\\\[!MASTERSECRET\\\]\\\n# \\\n#g' /etc/ems/emsserver.ini" >> ./emsscript.sh
RUN echo "sed -i ':a;N;\$!ba;s#\\\[!APPSECRET\\\]\\\n# \\\n#g' /etc/ems/emsserver.ini" >> ./emsscript.sh
RUN echo "sed -i ':a;N;\$!ba;s#\\\[!APPLICATIONID\\\]\\\n# \\\n#g' /etc/ems/emsserver.ini" >> ./emsscript.sh
RUN echo "sed -i ':a;N;\$!ba;s#\\\[!SERVERPORT\\\]\\\n#8080\\\n#g' /etc/ems/emsserver.ini" >> ./emsscript.sh
RUN echo "sed -i ':a;N;\$!ba;s#\\\[!CONSOLEUSER\\\]\\\n#consoleuser\\\n#g' /etc/ems/emsserver.ini" >> ./emsscript.sh
RUN echo "sed -i ':a;N;\$!ba;s#\\\[!CONSOLEPASS\\\]\\\n#consolepass\\\n#g' /etc/ems/emsserver.ini" >> ./emsscript.sh
RUN echo "sed -i ':a;N;\$!ba;s#\\\[!CONSOLEPORT\\\]\\\n#8081\\\n#g' /etc/ems/emsserver.ini" >> ./emsscript.sh
RUN echo "sed -i ':a;N;\$!ba;s#\\\[!RESOURCESFILES\\\]\\\n#/etc/ems/objrepos\\\n#g' /etc/ems/emsserver.ini" >> ./emsscript.sh
RUN sh ./emsscript.sh
#=============================end ems population

RUN sed -e '/\/opt\/interbase\/bin\/ibmgr/ { N; d; }' /tmp/rssetup.sh  -i
RUN sh /tmp/rssetup.sh swaggerui RS,RC,SUI

RUN sh /tmp/apachesetup.sh radserver radconsole RS,RC

#=====CLEAN UP==========
RUN rm RADServer.bin
RUN rm radserverlicense.slip
RUN rm radserver.zip
RUN rm InterBase_2017_EN.zip
RUN rm PAServer-20.0 -r
RUN rm paserver.tar.gz
RUN rm radserver_install.sh
RUN rm /opt/interbase -r
RUN rm /usr/interbase
RUN echo "#!/bin/bash" > ./cleaninstnacename.sh
RUN echo "sed -i ':a;N;\$!ba;s#InstanceName=localhost/3050\\\n#InstanceName=\\\n#g' /etc/ems/emsserver.ini" >> ./cleaninstnacename.sh
RUN sh ./cleaninstnacename.sh
RUN rm ./cleaninstnacename.sh
RUN echo "" > /var/www/html/index.html
#======END CLEAN UP=====

RUN service apache2 restart

EXPOSE 80 
EXPOSE 64211
EXPOSE 8082

#need this to make the apache daemon run in foreground
#prevent container from ending when docker is started
RUN chmod +x ./radserver_docker.sh
CMD ./radserver_docker.sh
