FROM radstudio/pa-radserver:12.1.1

ARG password=embtdocker
ARG ModuleName=module
ARG ModuleFile
ARG dbhost
ARG dbport
ENV PA_SERVER_PASSWORD=$password
ENV DB_HOST=$dbhost
ENV DB_PORT=$dbport

COPY $ModuleFile /etc/ems/$ModuleFile

RUN echo "#!/bin/bash" > ./emsscript.sh

#populate emsserver.ini with module data
ARG FindValue=:a;N;\$!ba;s#\\\[Server\\\.Packages\\\]
ARG ReplaceValue=#\\\[Server\\\.Packages\\\]
ARG ForwardSlash=/
ARG PoundG=#g
ARG EmsIni=/etc/ems/emsserver.ini
RUN echo -n "sed -i '" >> ./emsscript.sh
RUN echo -n "$FindValue" >> ./emsscript.sh
RUN echo -n "\\" >> ./emsscript.sh
RUN echo -n "n" >> ./emsscript.sh
RUN echo -n "$ReplaceValue" >> ./emsscript.sh
RUN echo -n "\\" >> ./emsscript.sh
RUN echo -n "n" >> ./emsscript.sh
RUN echo -n "/etc/ems/$ModuleFile=$ModuleName" >> ./emsscript.sh
RUN echo -n "$PoundG' " >> ./emsscript.sh
RUN echo -n "$EmsIni" >> ./emsscript.sh
RUN echo  "" >> ./emsscript.sh
RUN sh ./emsscript.sh
