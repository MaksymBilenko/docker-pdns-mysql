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

COPY entrypoint.sh /entrypoint.sh

CMD ["/etc/init.d/pdns", "monitor"]
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 53/udp
EXPOSE 53/tcp
