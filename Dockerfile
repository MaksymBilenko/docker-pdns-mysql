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
ENV EXPERIMENTAL_JSON_API_KEY changeme
ENV WEBSERVER yes
ENV WEBSERVER_PASSWORD changeme

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update&&apt-get install curl jq -y
RUN curl -s "${POWERDNS_JENKINS}/artifact/`curl -s ${POWERDNS_JENKINS}/api/json | jq -r '.artifacts[0].fileName'`" -o /tmp/pdns.deb && dpkg -i /tmp/pdns.deb
RUN apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /entrypoint.sh

CMD ["/etc/init.d/pdns", "monitor"]
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 53/udp
EXPOSE 53/tcp
