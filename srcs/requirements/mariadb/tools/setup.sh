#!/bin/bash
set -e

DATA_DIR=/var/lib/mysql
RUN_DIR=/run/mysqld
INIT_FLAG="${DATA_DIR}/.inception_initialized"

mkdir -p "$RUN_DIR"
chown -R mysql:mysql "$RUN_DIR"

if [ ! -d "${DATA_DIR}/mysql" ]; then
    echo "[setup.sh] Initialising MariaDB data directory..."
    mysql_install_db --user=mysql --datadir="$DATA_DIR" > /dev/null
fi

if [ ! -f "$INIT_FLAG" ]; then
    echo "[setup.sh] Starting temporary instance for bootstrap..."
    mysqld_safe --skip-networking &
    TEMP_PID=$!

    for i in $(seq 1 30); do
        mysqladmin -u root status > /dev/null 2>&1 && break
        sleep 1
    done

    echo "[setup.sh] Running database bootstrap..."
    mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF

    touch "$INIT_FLAG"
    echo "[setup.sh] Bootstrap done."
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait "$TEMP_PID"
fi

echo "[setup.sh] Starting MariaDB..."
exec mysqld_safe