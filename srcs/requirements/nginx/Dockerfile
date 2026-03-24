FROM debian:buster

ENV DOMAIN_NAME=miltavar42.42.fr

RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list \
 && sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list \
 && sed -i '/buster-updates/d' /etc/apt/sources.list

RUN echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid

RUN apt-get update && apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}" \
    && nginx -g "daemon off;"