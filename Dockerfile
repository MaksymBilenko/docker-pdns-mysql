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

RUN echo "#!/bin/bash \n\
    set -e \n\
    sed -i s/gmysql-host=.*/gmysql-host=\$MYSQL_HOST/g /etc/powerdns/pdns.d/pdns.local.gmysql.conf \n\
    sed -i s/gmysql-port=.*/gmysql-port=\$MYSQL_PORT/g /etc/powerdns/pdns.d/pdns.local.gmysql.conf \n\
    sed -i s/gmysql-dbname=.*/gmysql-dbname=\$MYSQL_DBNAME/g /etc/powerdns/pdns.d/pdns.local.gmysql.conf \n\
    sed -i s/gmysql-user=.*/gmysql-user=\$MYSQL_DBUSER/g /etc/powerdns/pdns.d/pdns.local.gmysql.conf \n\
    sed -i s/gmysql-password=.*/gmysql-password=\$MYSQL_DBPASS/g /etc/powerdns/pdns.d/pdns.local.gmysql.conf \n\
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
