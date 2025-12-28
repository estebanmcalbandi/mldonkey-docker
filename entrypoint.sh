#!/bin/sh

# Si no existe el fichero de configuración, es la primera vez que se lanza
# Creamos una configuración personalizada
if [ ! -f /var/lib/mldonkey/downloads.ini ]; then
    su - mldonkey -c "MLDONKEY_DIR=\"$MLDONKEY_DIR\" mldonkey" &

    echo 'Waiting for mldonkey to start...'
    sleep 3

     # Aunque lo ejecute root, la ejecición la realiza el usuario mldonkey
    mldonkey_command -p "" "set run_as_user mldonkey" "save"
    
    # Nombre del cliente
    mldonkey_command -p "" "set client_name emc2" "save"

    # Client buffer size a 5MB
    mldonkey_command -p "" "set client_buffer_size 5000000" "save"

   
    # IPs desde las que se permite la conexión
    mldonkey_command -p "" "set allowed_ips 0.0.0.0/0" "save"

    # Activo kad
    mldonkey_command -p "" "set enable_kademlia true" "save"
    mldonkey_command -p "" "set enable_bittorrent false" "save"
    mldonkey_command -p "" "set enable_overnet false" "save"
    mldonkey_command -p "" "set enable_directconnect false" "save"
    mldonkey_command -p "" "set enable_fileTP false" "save"

    # Diversos valores de configuración
    mldonkey_command -p "" "set max_hard_upload_rate 1000" "save"
    mldonkey_command -p "" "set max_hard_download_rate 0" "save"
    mldonkey_command -p "" "set max_upload_slots 10" "save"

    # Configuro ED2K
    mldonkey_command -p "" "set ED2K-connect_only_preferred_server false" "save"
    mldonkey_command -p "" "set ED2K-max_connected_servers 4" "save"
    mldonkey_command -p "" "set ED2K-min_left_servers 5" "save"
    mldonkey_command -p "" "set ED2K-firewalled-mode false" "save"
    mldonkey_command -p "" "set ED2K-port 20562" "save"
    mldonkey_command -p "" "set ED2K-upload_timeout 60." "save"

    mldonkey_command -p "" "set max_concurrent_downloads 150" "save"
    
    # Descargas y sus permisos
    mldonkey_command "set core.download_dir /descargas" "save"
    mldonkey_command -p "" "set filenames_utf8 true" "save"
    mldonkey_command -p "" "set create_file_mode 644" "save"
    mldonkey_command -p "" "set create_dir_mode 755" "save"
    mldonkey_command -p "" "set create_file_sparse true" "save"

    # Algunas listas que hay que actualizar
    mldonkey_command -p "" "urlremove http://www.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz" "save"
    mldonkey_command -p "" "urlremove http://www.gruk.org/server.met.gz" "save"
    mldonkey_command -p "" "urlremove http://update.kceasy.com/update/fasttrack/nodes.gzip" "save"
    mldonkey_command -p "" "urlremove http://dchublist.com/hublist.config.bz2" "save"
    mldonkey_command -p "" "urladd server.met http://upd.emule-security.org/server.met 25" "save"
    mldonkey_command -p "" "urladd kad http://upd.emule-security.org/nodes.dat 0" "save"
    mldonkey_command -p "" "urladd guarding.p2p http://upd.emule-security.org/ipfilter.zip 250" "save"
    mldonkey_command -p "" "urladd geoip.dat http://upd.emule-security.org/ip-to-country.csv.zip 0" "save"

    # Cambiamos la contraseña si la hay y apagamos el servicio    
    mldonkey_command -p "" "passwd 'P@ssw0rd'"
    mldonkey_command -p 'P@ssw0rd' "kill"
    

    # First port 6209 is for overnet, second 16965 for kad, we leave all the same
    # Ojo: Overnet ya no funciona
    sed -i '0,/   port =/s/   port =.*/  port = 6209/' /var/lib/mldonkey/donkey.ini
    sed -i '0,/   port =/s/   port =.*/  port = 16965/' /var/lib/mldonkey/donkey.ini
    sed -i 's/  port =/   port =/' /var/lib/mldonkey/donkey.ini
fi

# Lanzo finalmente el servicio
su - mldonkey -c "MLDONKEY_DIR=\"$MLDONKEY_DIR\" mldonkey"