FROM debian:buster

RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list \
 && sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list \
 && sed -i '/buster-updates/d' /etc/apt/sources.list

RUN echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid

RUN apt-get update && apt-get install -y mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306

CMD ["/setup.sh"]