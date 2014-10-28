FROM ubuntu:latest

ENV MYSQL_HOST localhost
ENV MYSQL_PORT 3306
ENV MYSQL_DBNAME pdns
ENV MYSQL_DBUSER pdns
ENV MYSQL_DBPASS pdns
ENV RECURSOR 8.8.8.8
ENV ALLOW_RECURSION_MASK 0.0.0.0/0
ENV POWERDNS_JENKINS https://autotest.powerdns.com/job/auth-git-semistatic-deb-amd64/lastSuccessfulBuild
ENV EXPERIMENTAL_JSON_INTERFACE yes
ENV WEBSERVER yes
ENV WEBSERVER_PASSWORD changeme

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update&&apt-get install curl jq -y
RUN curl -s "${POWERDNS_JENKINS}/artifact/`curl -s ${POWERDNS_JENKINS}/api/json | jq -r '.artifacts[0].fileName'`" -o /tmp/pdns.deb && dpkg -i /tmp/pdns.deb
RUN apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "#!/bin/bash \n\
    set -e \n\
    mv /etc/powerdns/pdns.conf{,_old} \n\
    echo launch=gmysql >> /etc/powerdns/pdns.conf \n\
    echo gmysql-host=\$MYSQL_HOST >> /etc/powerdns/pdns.conf \n\
    echo gmysql-port=\$MYSQL_PORT >> /etc/powerdns/pdns.conf \n\
    echo gmysql-dbname=\$MYSQL_DBNAME >> /etc/powerdns/pdns.conf \n\
    echo gmysql-user=\$MYSQL_DBUSER >> /etc/powerdns/pdns.conf \n\
    echo gmysql-password=\$MYSQL_DBPASS >> /etc/powerdns/pdns.conf \n\
    echo recursor=\$RECURSOR >> /etc/powerdns/pdns.conf \n\
    echo allow-recursion=\$ALLOW_RECURSION_MASK >> /etc/powerdns/pdns.conf \n\
    echo experimental-json-interface=\$EXPERIMENTAL_JSON_INTERFACE >> /etc/powerdns/pdns.conf \n\
    echo webserver=\$WEBSERVER >> /etc/powerdns/pdns.conf \n\
    echo webserver-password=\$WEBSERVER_PASSWORD >> /etc/powerdns/pdns.conf \n\
    echo webserver-address=0.0.0.0 >> /etc/powerdns/pdns.conf \n\
    cat /etc/powerdns/pdns.conf \n\
    exec \"\$@\"" \
    > /entrypoint.sh && \
    chmod +x /entrypoint.sh

CMD ["/etc/init.d/pdns", "monitor"]
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 53/udp
EXPOSE 53/tcp
