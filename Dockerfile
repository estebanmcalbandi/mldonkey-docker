FROM ubuntu:18.04

# Actualizamos e instalamos el servidor
RUN apt -y update 
RUN echo yes | apt install --no-install-recommends -y mldonkey-server
ENV PATH="${PATH}:/usr/lib/mldonkey"

#RUN rm -rf /var/lib/apt/lists/* 
RUN rm -rf /var/log/mldonkey 
RUN rm -rf /var/lib/mldonkey/*

# Definimos algunas variables
# C.UTF-8 es un locale neutro (no reglas de idiomas, no tildes, no ordenación humana)()
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8 

# Asignamos el UID y el GID para el usuario mldonkey
ENV MLDONKEY_UID='3000'
RUN usermod -u ${MLDONKEY_UID} mldonkey

ENV MLDONKEY_GID='568'
RUN groupmod -g ${MLDONKEY_GID} mldonkey

# Asignamos los permisos adecuados a la carpeta /var/lib/mldonkey
RUN chown mldonkey:mldonkey /var/lib/mldonkey

# Asignamos un shell al usuario mldonkey
RUN chsh -s /bin/bash mldonkey

# Asignamos la carpeta (también el home del usuario mldonkey) donde se almacenarán las configuraciones y descargas
# Si no está asignada esta variable, se crea una carpeta .mldonkey oculta en el directorio del usuario que ejecuta
ENV MLDONKEY_DIR=/var/lib/mldonkey

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
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh