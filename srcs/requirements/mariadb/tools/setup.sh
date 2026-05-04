#!/bin/bash
set -e

DATA_DIR=/var/lib/mysql
RUN_DIR=/run/mysqld

# Ensure runtime dir exists with correct ownership
mkdir -p "$RUN_DIR"
chown -R mysql:mysql "$RUN_DIR"

# ── First-time initialisation ─────────────────────────────────────────────────
if [ ! -d "$DATA_DIR/mysql" ]; then
    echo "[setup.sh] Initialising MariaDB data directory..."
    mysql_install_db --user=mysql --datadir="$DATA_DIR" > /dev/null

    # Start a temporary instance (no networking) to run SQL setup
    mysqld_safe --skip-networking &
    TEMP_PID=$!

    # Wait until the socket is ready
    for i in $(seq 1 30); do
        mysqladmin -u root status > /dev/null 2>&1 && break
        sleep 1
    done

    echo "[setup.sh] Running database bootstrap..."
    mysql -u root << EOF
-- Harden root (local only)
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Application database
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

-- Application user (reachable from any host inside the Docker network)
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- Remove anonymous users and test database
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;

FLUSH PRIVILEGES;
EOF

    echo "[setup.sh] Bootstrap done. Stopping temporary instance..."
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait "$TEMP_PID"
    echo "[setup.sh] Temporary instance stopped."
fi

# ── Start MariaDB in the foreground (PID 1) ───────────────────────────────────
echo "[setup.sh] Starting MariaDB..."
exec mysqld_safe
