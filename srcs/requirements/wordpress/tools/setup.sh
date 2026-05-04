#!/bin/bash
set -e

WP_PATH=/var/www/wordpress

# ── Wait for MariaDB ──────────────────────────────────────────────────────────
echo "[setup.sh] Waiting for MariaDB to be ready..."
for i in $(seq 1 30); do
    mysqladmin ping \
        -h mariadb \
        -u "${MYSQL_USER}" \
        -p"${MYSQL_PASSWORD}" \
        --silent > /dev/null 2>&1 && break
    echo "[setup.sh] Attempt $i/30 – MariaDB not ready yet, retrying in 3s..."
    sleep 3
done

# ── Install WordPress (idempotent) ────────────────────────────────────────────
if [ ! -f "${WP_PATH}/wp-config.php" ]; then

    echo "[setup.sh] Downloading WordPress core..."
    wp core download \
        --allow-root \
        --path="${WP_PATH}"

    echo "[setup.sh] Creating wp-config.php..."
    wp config create \
        --allow-root \
        --path="${WP_PATH}" \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost=mariadb:3306 \
        --dbcharset=utf8mb4

    echo "[setup.sh] Installing WordPress..."
    wp core install \
        --allow-root \
        --path="${WP_PATH}" \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email

    echo "[setup.sh] Creating secondary user..."
    wp user create \
        --allow-root \
        --path="${WP_PATH}" \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}"

    # Fix permissions after WP-CLI writes as root
    chown -R www-data:www-data "${WP_PATH}"

    echo "[setup.sh] WordPress installation complete."
else
    echo "[setup.sh] WordPress already installed, skipping."
fi

# ── Start PHP-FPM in the foreground (PID 1) ───────────────────────────────────
echo "[setup.sh] Starting PHP-FPM 7.3..."
exec php-fpm7.3 -F
