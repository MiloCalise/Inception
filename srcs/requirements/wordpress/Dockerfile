FROM debian:buster

RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list \
 && sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list \
 && sed -i '/buster-updates/d' /etc/apt/sources.list

RUN echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    curl \
    mariadb-client

RUN mkdir -p /var/www/html

COPY conf/www.conf /etc/php/7.3/fpm/pool.d/

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

WORKDIR /var/www/html

EXPOSE 9000

CMD ["/setup.sh"]