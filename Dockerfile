FROM ubuntu:18.04

# Actualizamos e instalamos el servidor
RUN apt -y update 
RUN echo yes | apt install --no-install-recommends -y mldonkey-server

RUN rm -rf /var/lib/apt/lists/* 
RUN rm -rf /var/log/mldonkey 
RUN rm -rf /var/lib/mldonkey/*

# Copiamos el script de entrada
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Definimos algunas variables
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV MLDONKEY_DIR=/var/lib/mldonkey
ENV MLDONKEY_UID='568'
ENV MLDONKEY_GID='568'
ENV MLDONKEY_ADMIN_PASSWORD='Passw0rd-'

# Defino las carpetas temp e incoming como volúmenes
VOLUME /var/lib/mldonkey

# Exponemos todos los puertos necesarios
EXPOSE 4080
EXPOSE 4000
EXPOSE 4001
EXPOSE 20562
EXPOSE 20566/udp
EXPOSE 16965/udp

# Definimos el script de entrada
CMD /entrypoint.sh