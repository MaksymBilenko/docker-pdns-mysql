FROM ubuntu:latest

ENV MYSQL_HOST localhost
ENV MYSQL_PORT 3306
ENV MYSQL_DBNAME pdns
ENV MYSQL_DBUSER pdns
ENV MYSQL_DBPASS pdns
ENV RECURSOR1 8.8.8.8
ENV RECURSOR2 8.8.4.4
ENV ALLOW_RECURSION_MASK 0.0.0.0\/0

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q update && apt-get -q install pdns-backend-mysql -y
RUN apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "#!/bin/bash \n\
    set -e \n\
    mv /etc/powerdns/pdns.d/pdns.local.gmysql.conf{,_old} \n\
    echo gmysql-host=\$MYSQL_HOST >> /etc/powerdns/pdns.d/pdns.local.gmysql.conf \n\
    echo gmysql-port=\$MYSQL_PORT >> /etc/powerdns/pdns.d/pdns.local.gmysql.conf \n\
    echo gmysql-dbname=\$MYSQL_DBNAME >> /etc/powerdns/pdns.d/pdns.local.gmysql.conf \n\
    echo gmysql-user=\$MYSQL_DBUSER >> /etc/powerdns/pdns.d/pdns.local.gmysql.conf \n\
    echo gmysql-password=\$MYSQL_DBPASS >> /etc/powerdns/pdns.d/pdns.local.gmysql.conf \n\
    sed -i s/..recursor=/recursor=\$RECURSOR1\\ \$RECURSOR2/g /etc/powerdns/pdns.conf \n\
    sed -i s/allow-recursion=127.0.0.1/allow-recursion=\$ALLOW_RECURSION_MASK/g /etc/powerdns/pdns.conf \n\
    cat /etc/powerdns/pdns.d/pdns.local.gmysql.conf \n\
    rm -f /etc/powerdns/pdns.d/pdns.simplebind.conf \n\
    exec \"\$@\"" \
    > /entrypoint.sh && \
    chmod +x /entrypoint.sh

CMD ["/etc/init.d/pdns", "monitor"]
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 53/udp
EXPOSE 53/tcp
