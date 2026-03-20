# USER_DOC.md

## 🧾 Overview

This project provides a complete web infrastructure using Docker. It includes:

* **NGINX**: Web server handling HTTPS connections
* **WordPress**: Website application (PHP-FPM)
* **MariaDB**: Database storing WordPress data

All services are containerized and connected through a Docker network.

---

## 🚀 Start and Stop the Project

### ▶️ Start the services

```bash
make
```

This will:

* Build Docker images
* Create and start all containers
* Initialize the database and WordPress

---

### ⏹️ Stop and clean the services

```bash
make down
```

```bash
make clean
```

---

## 🌐 Access the Website

Open your browser and go to:

```text
https://miltavar42.42.fr
```

* HTTPS is required (HTTP will not work)
* A security warning may appear (self-signed certificate)

---

## 🔐 Access the Administration Panel

Go to:

```text
https://miltavar42.42.fr/wp-admin
```

Login using credentials defined in the `.env` file:

* `WP_ADMIN_USER`
* `WP_ADMIN_PASSWORD`

---

## 🔑 Credentials Management

All credentials are stored in the `.env` file:

```env
MYSQL_DATABASE=...
MYSQL_USER=...
MYSQL_PASSWORD=...
MYSQL_ROOT_PASSWORD=...

WP_ADMIN_USER=...
WP_ADMIN_PASSWORD=...
WP_ADMIN_EMAIL=...

WP_USER=...
WP_USER_PASSWORD=...
```

👉 To change credentials:

1. Edit `.env`
2. Run:

```bash
make down
make clean
sudo rm -rf ~/Data/mariadb/*
sudo rm -rf ~/Data/wordpress/*
make
```

---

## ✅ Check Services Status

### Check running containers:

```bash
docker ps
```

---

### Check logs:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

---

### Verify services manually

* Website loads → NGINX + WordPress OK
* Login works → WordPress OK
* Database connected → no errors in logs

---

## 🔁 Persistence Check

1. Add content in WordPress
2. Restart project:

```bash
make clean
make
```

👉 Content must still be present

---

## ⚠️ Common Issues

* **502 Bad Gateway** → PHP-FPM / NGINX issue
* **Database connection error** → MariaDB not ready or wrong credentials
* **Website not loading** → check containers and logs

---

## 🎯 Summary

This stack provides a secure, containerized WordPress website with persistent storage and isolated services.
