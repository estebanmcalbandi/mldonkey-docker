FROM ubuntu:18.04

RUN apt-get update && echo yes |apt-get install --no-install-recommends -y mldonkey-server 

# Limpiamos 
RUN rm -rf /var/lib/apt/lists/* -v && rm -rf /var/log/mldonkey -v && rm /var/lib/mldonkey/* -v

# Cambio identificadores del usuario mldonkey
RUN usermod --uid=1000 mldonkey && usermod --gid=100 mldonkey

ENV MLDONKEY_DIR=/var/lib/mldonkey 
ENV LC_ALL=C.UTF-8 
ENV LANG=C.UTF-8 
ENV MLDONKEY_ADMIN_PASSWORD='Passw0rd-'

VOLUME /var/lib/mldonkey

EXPOSE 4080 
EXPOSE 4000 
EXPOSE 4001 
EXPOSE 20562 
EXPOSE 20566/udp 
EXPOSE 16965/udp

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD /entrypoint.sh
