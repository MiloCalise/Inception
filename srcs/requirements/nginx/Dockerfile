FROM debian:buster

RUN apt-get update && apt-get install -y \
        nginx \
        openssl \
        gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Self-signed TLS certificate (replace with a real cert in production)
RUN mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out  /etc/nginx/ssl/nginx.crt \
        -subj "/C=FR/ST=IDF/L=Paris/O=42School/OU=miltavar42/CN=miltavar42.42.fr"

COPY conf/nginx.conf.template /etc/nginx/conf.d/nginx.conf.template

EXPOSE 443

# envsubst replaces $DOMAIN_NAME at runtime, then starts nginx in foreground
CMD ["sh", "-c", \
    "envsubst '$DOMAIN_NAME' \
        < /etc/nginx/conf.d/nginx.conf.template \
        > /etc/nginx/conf.d/default.conf \
    && nginx -g 'daemon off;'"]
