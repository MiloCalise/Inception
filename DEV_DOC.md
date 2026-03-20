# DEV_DOC.md

## 🛠️ Environment Setup

### 📦 Prerequisites

* Docker
* Docker Compose
* Linux environment (VM recommended)

---

## 📁 Project Structure

```text
inception/
├── Makefile
└── srcs/
    ├── docker-compose.yml
    ├── .env
    ├── requirements/
    │   ├── mariadb/
    │   ├── nginx/
    │   └── wordpress/
```

---

## ⚙️ Configuration

### 🔑 Environment Variables

All configuration is defined in:

```text
srcs/.env
```

This file contains:

* Database credentials
* WordPress users
* Domain name

---

## 🚀 Build and Launch

### Build and run:

```bash
make
```

This executes:

```bash
docker compose -f srcs/docker-compose.yml up --build
```

---

### Stop:

```bash
make down
make clean
make fclean
```

---

## 🐳 Docker Management

### List containers:

```bash
docker ps
```

---

### Access a container:

```bash
docker exec -it <container_name> bash
```

Example:

```bash
docker exec -it mariadb bash
```

---

### View logs:

```bash
docker logs <container_name>
```

---

### Restart a container:

```bash
docker restart <container_name>
```

---

## 💾 Data Storage & Persistence

Data is stored on the host machine:

```text
/home/<login>/data/
├── mariadb/
└── wordpress/
```

---

### 🔄 How persistence works

* MariaDB stores database files in `/var/lib/mysql`
* WordPress stores site data in `/var/www/html`
* These directories are mounted as **bind mounts**

👉 Even if containers are deleted, data remains.

---

## 🔧 Volumes Configuration

Defined in `docker-compose.yml`:

```yaml
volumes:
  mariadb:
    driver_opts:
      device: /home/<login>/data/mariadb

  wordpress:
    driver_opts:
      device: /home/<login>/data/wordpress
```

---

## 🌐 Networking

* All containers are connected via a Docker network
* Services communicate using container names:

```text
wordpress → mariadb
nginx → wordpress
```

---

## 🧠 Key Concepts

### Docker Compose

* Orchestrates multiple services
* Defines networks, volumes, and dependencies

---

### PHP-FPM

* Handles PHP execution
* Communicates with NGINX via port 9000

---

### NGINX

* Reverse proxy
* Handles HTTPS and forwards PHP requests

---

## 🧪 Debugging Tips

### Check PHP-FPM:

```bash
docker exec -it wordpress netstat -tulnp
```

---

### Check DB connection:

```bash
docker exec -it mariadb mysql -u user -p
```

---

### Check volumes:

```bash
docker volume inspect <volume_name>
```

---

## ⚠️ Common Issues

* Wrong PHP version → mismatch config
* Socket vs TCP (must use port 9000)
* Missing volumes → data loss
* Wrong permissions → container crashes

---

## 🎯 Summary

This project demonstrates:

* Multi-container architecture
* Service isolation
* Persistent storage
* Real-world deployment practices using Docker
