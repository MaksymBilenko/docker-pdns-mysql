#!/bin/bash 
    set -e 
    mv /etc/powerdns/pdns.d/pdns.local.gmysql.conf{,_old} 
    echo launch=gmysql >> /etc/powerdns/pdns.d/pdns.local.gmysql.conf 
    echo gmysql-host=$MYSQL_HOST >> /etc/powerdns/pdns.d/pdns.local.gmysql.conf 
    echo gmysql-port=$MYSQL_PORT >> /etc/powerdns/pdns.d/pdns.local.gmysql.conf 
    echo gmysql-dbname=$MYSQL_DBNAME >> /etc/powerdns/pdns.d/pdns.local.gmysql.conf 
    echo gmysql-user=$MYSQL_DBUSER >> /etc/powerdns/pdns.d/pdns.local.gmysql.conf 
    echo gmysql-password=$MYSQL_DBPASS >> /etc/powerdns/pdns.d/pdns.local.gmysql.conf 
    sed -i s/..recursor=/recursor=$RECURSOR1\ $RECURSOR2/g /etc/powerdns/pdns.conf 
    sed -i s/allow-recursion=127.0.0.1/allow-recursion=$ALLOW_RECURSION_MASK/g /etc/powerdns/pdns.conf 
if [ -f /mnt/recursors.conf ]; then
    echo forward-zones-file=/mnt/recursors.conf >> /etc/powerdns/pdns.conf
fi
    cat /etc/powerdns/pdns.d/pdns.local.gmysql.conf 
    rm -f /etc/powerdns/pdns.d/pdns.simplebind.conf 
    exec "$@"
