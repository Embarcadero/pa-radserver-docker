FROM ubuntu:jammy
# jammy is the code name of 22.04 LTS

ARG dbhost=localhost
ARG dbport=3050
ARG password=embtdocker
ENV DB_HOST=$dbhost
ENV DB_PORT=$dbport
ENV PA_SERVER_PASSWORD=$password

#INSTALL APACHE AND OTHER LIBS
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yy --no-install-recommends install \
    apache2 \
    build-essential \
    libcurl4-openssl-dev \
    libcurl4 \
    libgl1-mesa-dev \
    libgtk-3-bin \
    libosmesa-dev \
    libpython3.10 \
    unzip \
    xorg
RUN apt-get -y autoremove && apt-get -y autoclean
#====END OTHER LIBS

WORKDIR /

COPY radserver_docker.sh radserver_docker.sh

# Fix "strings: '/lib/libc.so.6': No such file"
RUN ln -s /lib/x86_64-linux-gnu/libc.so.6 /lib/libc.so.6

#====GET ZIP FILES====
ADD https://altd.embarcadero.com/getit/public/libraries/RADServer/RADServerLinux-20240402.zip ./radserver.zip
ADD https://altd.embarcadero.com/releases/studio/23.0/121/LinuxPAServer23.0.tar.gz ./paserver.tar.gz

RUN unzip radserver.zip
RUN tar xvzf paserver.tar.gz
#========END ZIP FILES

# fix "uname -a | grep Ubuntu" bug in the radserver_install.sh
RUN sed -i "s/uname -a | grep/awk -F= '\/^NAME\/\{print \$2\}' \/etc\/os-release | grep/" radserver_install.sh

RUN touch radserverlicense.slip

RUN sh ./radserver_install.sh -silent

RUN mv PAServer-23.0/* .

# link to installed libpython3.10
RUN mv lldb/lib/libpython3.so lldb/lib/libpython3.so_
RUN ln -s /lib/x86_64-linux-gnu/libpython3.10.so.1 lldb/lib/libpython3.so

#populate emsserver.ini with interbase connection data
RUN cp /etc/ems/objrepos/emsserver.ini /etc/ems/emsserver.ini
RUN /bin/echo -e "#!/bin/bash\n\
sed -i 's/\\\r\$//' /etc/ems/emsserver.ini\n\
sed -i ':a;N;\$!ba;s#\\\[!DBINSTANCENAME\\\]\\\n#$dbhost$ForwardSlash$dbport\\\n#g' /etc/ems/emsserver.ini\n\
sed -i ':a;N;\$!ba;s#\\\[!DBPATH\\\]\\\n#/etc/ems/emsserver.ib\\\n#g' /etc/ems/emsserver.ini\n\
sed -i ':a;N;\$!ba;s#\\\[!DBUSERNAME\\\]\\\n#sysdba\\\n#g' /etc/ems/emsserver.ini\n\
sed -i ':a;N;\$!ba;s#\\\[!DBPASSWORD\\\]\\\n#masterkey\\\n#g' /etc/ems/emsserver.ini\n\
sed -i ':a;N;\$!ba;s#\\\[!MASTERSECRET\\\]\\\n# \\\n#g' /etc/ems/emsserver.ini\n\
sed -i ':a;N;\$!ba;s#\\\[!APPSECRET\\\]\\\n# \\\n#g' /etc/ems/emsserver.ini\n\
sed -i ':a;N;\$!ba;s#\\\[!APPLICATIONID\\\]\\\n# \\\n#g' /etc/ems/emsserver.ini\n\
sed -i ':a;N;\$!ba;s#\\\[!SERVERPORT\\\]\\\n#8080\\\n#g' /etc/ems/emsserver.ini\n\
sed -i ':a;N;\$!ba;s#\\\[!CONSOLEUSER\\\]\\\n#consoleuser\\\n#g' /etc/ems/emsserver.ini\n\
sed -i ':a;N;\$!ba;s#\\\[!CONSOLEPASS\\\]\\\n#consolepass\\\n#g' /etc/ems/emsserver.ini\n\
sed -i ':a;N;\$!ba;s#\\\[!CONSOLEPORT\\\]\\\n#8081\\\n#g' /etc/ems/emsserver.ini\n\
sed -i ':a;N;\$!ba;s#\\\[!RESOURCESFILES\\\]\\\n#/etc/ems/objrepos\\\n#g' /etc/ems/emsserver.ini\n\
"\
>> emsscript.sh

RUN sh ./emsscript.sh
#=============================end ems population

# fix "uname -a | grep Ubuntu" and "System has not been booted with systemd 
# as init system (PID 1)" bugs in the apachesetup.sh and rssetup.sh
RUN sed -i "s/uname -a | grep/awk -F= '\/^NAME\/\{print \$2\}' \/etc\/os-release | grep/" /tmp/apachesetup.sh ; \
sed -i "s/uname -a | grep/awk -F= '\/^NAME\/\{print \$2\}' \/etc\/os-release | grep/" /tmp/rssetup.sh ; \
sed -i "s/systemctl restart apache2.service/service apache2 restart/" /tmp/apachesetup.sh ; \
sed -i "s/systemctl status apache2.service --no-pager/service apache2 status/" /tmp/apachesetup.sh

RUN sed -e '/\/opt\/interbase\/bin\/ibmgr/ { N; d; }' /tmp/rssetup.sh  -i
RUN /tmp/rssetup.sh swaggerui RS,RC,SUI

RUN sh /tmp/apachesetup.sh radserver radconsole RS,RC

#=====CLEAN UP==========
RUN rm RADServer.bin
RUN rm radserverlicense.slip
RUN rm radserver.zip
RUN rm InterBase_2020_Linux.zip
RUN rm PAServer-23.0 -r
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

#Apache
EXPOSE 80 
# PAServer
EXPOSE 64211
# broadwayd
EXPOSE 8082

#need this to make the apache daemon run in foreground
#prevent container from ending when docker is started
RUN chmod +x ./radserver_docker.sh
CMD ./radserver_docker.sh
