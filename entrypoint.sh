#!/bin/bash 
    set -e 
    mv /etc/powerdns/pdns.conf{,_old} 
    echo launch=gmysql >> /etc/powerdns/pdns.conf 
    echo gmysql-host=$MYSQL_HOST >> /etc/powerdns/pdns.conf 
    echo gmysql-port=$MYSQL_PORT >> /etc/powerdns/pdns.conf 
    echo gmysql-dbname=$MYSQL_DBNAME >> /etc/powerdns/pdns.conf 
    echo gmysql-user=$MYSQL_DBUSER >> /etc/powerdns/pdns.conf 
    echo gmysql-password=$MYSQL_DBPASS >> /etc/powerdns/pdns.conf 
    echo recursor=$RECURSOR >> /etc/powerdns/pdns.conf 
    echo allow-recursion=$ALLOW_RECURSION_MASK >> /etc/powerdns/pdns.conf 
    echo experimental-json-interface=$EXPERIMENTAL_JSON_INTERFACE >> /etc/powerdns/pdns.conf 
    echo experimental-api-key=$EXPERIMENTAL_JSON_API_KEY >> /etc/powerdns/pdns.conf 
    echo webserver=$WEBSERVER >> /etc/powerdns/pdns.conf 
    echo webserver-password=$WEBSERVER_PASSWORD >> /etc/powerdns/pdns.conf 
    echo webserver-address=0.0.0.0 >> /etc/powerdns/pdns.conf 
if [ -f /mnt/recursors.conf ]; then
    echo forward-zones-file=/mnt/recursors.conf >> /etc/powerdns/pdns.conf
fi
    cat /etc/powerdns/pdns.conf 
    exec "$@"
