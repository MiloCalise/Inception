*This project has been created as part of the 42 curriculum by miltavar42.*

# 🐳 Inception

## 📖 Description

Inception is a system administration project focused on building a secure and modular web infrastructure using Docker. The goal is to set up multiple interconnected services inside containers, orchestrated with Docker Compose, while respecting strict rules regarding security, isolation, and reproducibility.

The infrastructure includes:

* A **NGINX** container with SSL/TLS support
* A **WordPress** container running with PHP-FPM
* A **MariaDB** container as the database
* Persistent storage using Docker volumes

This project emphasizes understanding containerization concepts and building a production-like environment from scratch.

---

## ⚙️ Instructions

### 📦 Prerequisites

* Docker
* Docker Compose
* A Linux environment (VM recommended)

---

### 🚀 Build & Run

Build and start the project:

```bash
make
```

---

### 🌐 Access the website

Open your browser and go to:

```text
https://miltavar.42.fr
```

⚠️ A security warning may appear due to the self-signed SSL certificate (this is expected).

---

### 🧹 Clean the project

Stop and remove containers:

```bash
make down
make clean
make fclean
```

## 🏗️ Project Architecture

```
inception/
├── Makefile
└── srcs/
    ├── docker-compose.yml
    ├── requirements/
    │   ├── mariadb/
    │   ├── nginx/
    │   └── wordpress/
```

Each service has:

* Its own **Dockerfile**
* Configuration files
* Startup scripts

---

## 🧠 Technical Choices

### 🖥️ Virtual Machines vs Docker

* **VMs**: heavy, full OS per instance, high resource usage
* **Docker**: lightweight, shares host kernel, faster startup
  👉 Docker was chosen for efficiency and scalability.

---

### 🔐 Secrets vs Environment Variables

* **Environment Variables**: simple, but exposed in container config
* **Secrets**: secure, stored separately and not exposed
  👉 Environment variables were used for simplicity in this project, but secrets are preferred in production.

---

### 🌐 Docker Network vs Host Network

* **Host network**: no isolation, containers share host network
* **Docker network**: isolated, internal DNS (containers communicate via service names)
  👉 Docker network ensures better isolation and security.

---

### 💾 Docker Volumes vs Bind Mounts

* **Volumes**: managed by Docker, portable, safer
* **Bind mounts**: linked to host filesystem, more control but less portable
  👉 Bind mounts are used here to store data in `/home/miltavar42/data/`.

---

## 🔧 Features

* Secure HTTPS setup with TLS (NGINX)
* WordPress fully configured automatically
* MariaDB secured with user authentication
* Persistent data (WordPress + database)
* Container isolation and communication via Docker network

---

## 📚 Resources

### 📖 Documentation

* Docker official docs: https://docs.docker.com/
* Medium 1 : https://medium.com/@ssterdev/inception-guide-42-project-part-i-7e3af15eb671
* Medium 2 : https://medium.com/@imyzf/inception-3979046d90a0

---

### 🤖 AI Usage

AI (ChatGPT) was used for:

* Debugging Docker and container issues
* Understanding networking between containers
* Fixing configuration errors (NGINX, PHP-FPM, MariaDB)
* Improving scripts and best practices (idempotency, clean setup)
* Making the Readme.md

---

## ✅ Final Notes

This project demonstrates:

* Practical use of Docker in a multi-service architecture
* Understanding of web infrastructure basics
* Ability to debug complex system interactions

---

🚀 *Inception is not just about making it work — it's about understanding how everything connects together.*
