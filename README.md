# mldonkey-docker
mlDonkey 3.1.6 dockerizado en Ubuntu 18.04 en una imagen de 90MB (solo eDonkey y Kademlia). Este repositorio aloja el Dockerfile para construir la imagen Docker de mlDonkey.

Cada día es más complicado instalar mlDonkey debido a su falta de mantenimiento y la dificultad para encontrar todo lo que necesitamos en nuestro sistema operativo. Una forma de seguir disfrutando de este magnífico programa p2p es ejecutarlo dentro de un contenedor Docker y en una plataforma en la que funcionaba bien. Esto lo mantiene aislado del sistema operativo instalado en tu ordenador, lo que lo mantendrá funcionando durante años.

Necesitarás [instalar Docker](https://docs.docker.com/engine/install/) primero.


## Modificaciones

- Deshabilitados todos los protocolos obsoletos.
- Reemplazadas las URLs de actualización obsoletas con emule-security.org.
- Aumentado "client_buffer_size" a 5000000 para optimización del ancho de banda.
- Aumentado "max_upload_slots" a 10 para compartir más fácilmente.
- Disminuido "ED2K-upload_timeout" a 60 para evitar colas llenas de clientes inactivos.


## Uso

### Para obtener la imagen:

    docker pull estebanmcalbandi/mldonkey-ubuntu

***o***

    git clone https://github.com/estebanmcalbandi/mldonkey-docker.git && cd mldonkey-docker

    docker build -t estebanmcalbandi/mldonkey-ubuntu .


### Para crear el contenedor:

    docker create --name mldonkey-ubuntu --restart=always \
    -p 4080:4080 -p 4000:4000 -p 4001:4001 \
    -p 20562:20562 -p 20566:20566/udp -p 16965:16965/udp \
    -v "<$HOME/Downloads/mlDonkey>:/var/lib/mldonkey/incoming/files" \
    estebanmcalbandi/mldonkey-ubuntu

Debemos eliminar "<>" y personalizar su contenido. mlDonkey almacena los datos dentro del directorio del contenedor /var/lib/mldonkey/incoming/files, por lo que lo montamos en el sistema de archivos local para un acceso fácil.


### Para ejecutar el contenedor:

Abre los puertos 20562/tcp, 20566/udp y 16965/udp en tu router y sistema operativo.

    docker start mldonkey-ubuntu

Luego puedes acceder a mlDonkey como http://127.0.0.1:4080 o usando "mldonkey-gui" instalado desde el repositorio de tu distribución o https://pkgs.org/download/mldonkey-gui.

- Usuario: admin
- Contraseña: Passw0rd-

![imagen](https://github.com/estebanmcalbandi/mldonkey-docker/blob/main/d.png)

Puedes cambiar la contraseña por defecto más tarde desde las líneas de comandos de telnet, web o GUI:

    useradd admin <NuevaPassw0rd->

Debemos eliminar "<>" y personalizar su contenido. El directorio incoming pertenece al usuario del contenedor "mldonkey" (uid=101, gid=101), por lo que necesitamos cambiar los permisos para acceso total:

    sudo chmod -R 777 <~/Downloads/mlDonkey>

Debemos eliminar "<>" y personalizar su contenido.


### Otros montajes opcionales:

    -v "</var/lib/mldonkey>:/var/lib/mldonkey" \
    -v "</tmp/mldonkey>:/var/lib/mldonkey/temp" \
    -v "<$HOME/Video/mlDonkey>:/var/lib/mldonkey/shared" \

Debemos eliminar "<>" y personalizar su contenido. Si estos directorios no se montan en un lugar diferente, residirán en la partición raíz del sistema, que es donde Docker almacena los datos por defecto. Asegúrate de tener suficiente espacio libre en ella.

## Problemas conocidos:

Al crear el contenedor recibimos el error:
> Error response from daemon: create </home/wibol/Downloads/mlDonkey>: "</home/wibol/Downloads/mlDonkey>" includes invalid characters for a local volume name, only "[a-zA-Z0-9][a-zA-Z0-9_.-]" are allowed. If you intended to pass a host directory, use absolute path.

Para resolverlo debemos eliminar "<>" del punto de montaje local.

## Enlaces:

[mlDonkey en Docker - Página Web](https://mldonkey.wibol.eu/ "mldonkey-ubuntu image web.")

[mlDonkey en Docker - Docker](https://hub.docker.com/r/wibol/mldonkey-ubuntu "mldonkey-ubuntu image repository in Docker.")

[mlDonkey en Docker - Linux Mint](https://forums.linuxmint.com/viewtopic.php?t=396180 "mldonkey-ubuntu installation tutorial in Linux Mint.")
