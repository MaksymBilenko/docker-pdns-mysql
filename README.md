docker-pdns-mysql
=================
Docker container with PowerDNS with REST-API service with MySQL backend based on [ubuntu:latest](https://registry.hub.docker.com/_/ubuntu/)
More detailed about [REST-API](https://github.com/PowerDNS/pdns/tree/master/pdns/docs/httpapi)

Usage:

    docker run --rm --name powerdns -e RECURSOR=10.0.1.1 -e RECURSOR2=8.8.8.8 -e MYSQL_HOST=mysqld.domain.com -e MYSQL_DBPASS=powersecret --dns=10.0.1.1 --dns=8.8.8.8 --dns-search=domain.com -p 53:53/tcp -p 53:53/udp sath89/pdns-mysql
