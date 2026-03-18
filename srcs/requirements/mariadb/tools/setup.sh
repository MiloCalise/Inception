#!/bin/bash

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

mysqld_safe &

sleep 10

mariadb -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

mariadb -e "DROP USER IF EXISTS '${MYSQL_USER}'@'localhost';"
mariadb -e "DROP USER IF EXISTS '${MYSQL_USER}'@'%';"

mariadb -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"

mariadb -e "FLUSH PRIVILEGES;"

mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

exec mysqld_safe