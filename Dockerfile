FROM ubuntu:18.04

# Actualizamos e instalamos el servidor
RUN apt -y update 
RUN echo yes | apt install --no-install-recommends -y mldonkey-server
ENV PATH="${PATH}:/usr/lib/mldonkey"

RUN rm -rf /var/lib/apt/lists/* 
RUN rm -rf /var/log/mldonkey 
RUN rm -rf /var/lib/mldonkey/*

# Definimos algunas variables
# C.UTF-8 es un locale neutro (no reglas de idiomas, no tildes, no ordenación humana)()
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8 

# Asignamos el UID y el GID para el usuario mldonkey
ENV MLDONKEY_USER='user'
ENV MLDONKEY_UID='3000'
ENV MLDONKEY_GID='568'
RUN useradd  --home-dir $MLDONKEY_DIR --uid ${MLDONKEY_UID} --gid ${MLDONKEY_GID} --shell /bin/bash ${MLDONKEY_USER}
RUN chown $MLDONKEY_UID:$MLDONKEY_GID /var/lib/mldonkey

# Defino las carpetas temp e incoming como volúmenes
VOLUME /var/lib/mldonkey
VOLUME /var/lib/mldonkey/incoming
VOLUME /var/lib/mldonkey/temp

# Exponemos todos los puertos necesarios
EXPOSE 4080
EXPOSE 4000
EXPOSE 4001
EXPOSE 20562
EXPOSE 20566/udp
EXPOSE 16965/udp

# Definimos el script de entrada
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
