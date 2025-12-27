FROM ubuntu:18.04

# Actualizamos e instalamos el servidor
RUN apt -y update 
RUN echo yes | apt install --no-install-recommends -y mldonkey-server

RUN rm -rf /var/lib/apt/lists/* 
RUN rm -rf /var/log/mldonkey 
RUN rm -rf /var/lib/mldonkey/*

# Copiamos el script de entrada
ADD entrypoint.sh /

# Definimos algunas variables
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV MLDONKEY_DIR=/var/lib/mldonkey
ENV MLDONKEY_UID='568'
ENV MLDONKEY_GID='568'
ENV MLDONKEY_ADMIN_PASSWORD='Passw0rd-'

# Cambio identificadores del usuario mldonkey
RUN usermod --uid=${MLDONKEY_UID} mldonkey 
RUN usermod --gid=${MLDONKEY_GID} mldonkey

# Defino las carpetas temp e incoming como volúmenes
VOLUME /var/lib/mldonkey

# Exponemos todos los puertos necesarios
EXPOSE 4080
EXPOSE 4000
EXPOSE 4001
EXPOSE 20562
EXPOSE 20566/udp
EXPOSE 16965/udp

# Limpiamos:
# Aquí habría que modificar permisos en la carpeta /var/log/mldonkey
# pero como dicha carpeta está conectada a volúmenes, no los asume
# En realidad no hay problema, ya que se asumirán los permisos presentes en las carpetas generadas
RUN chown -R ${MLDONKEY_UID}:${MLDONKEY_GID} ${MLDONKEY_DIR}

# Creamos el punto de entrada de la aplicación
# cambiamos su propiedad y activamos el suid para que se ejecute con credenciales de mldonkey

RUN chmod +x /entrypoint.sh

CMD /entrypoint.sh