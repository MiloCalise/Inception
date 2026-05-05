FROM debian:buster

RUN sed -i 's|http://deb.debian.org|http://archive.debian.org|g' /etc/apt/sources.list \
    && sed -i '/buster-updates/d' /etc/apt/sources.list \
    && sed -i 's|http://security.debian.org|http://archive.debian.org|g' /etc/apt/sources.list \
    && apt-get update && apt-get install -y \
        php7.3-fpm \
        php7.3-mysql \
        php7.3-curl \
        php7.3-gd \
        php7.3-mbstring \
        php7.3-xml \
        php7.3-zip \
        curl \
        wget \
        mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL \
        https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        -o /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

RUN mkdir -p /var/www/wordpress \
    && chown -R www-data:www-data /var/www/wordpress

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 9000

ENTRYPOINT ["/setup.sh"]
