NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

DATA_PATH = /home/miltavar42/data

all:
	$(COMPOSE) up --build -d

down:
	$(COMPOSE) down

clean:
	docker system prune -af

fclean: down clean
	sudo rm -rf $(DATA_PATH)/mariadb/*
	sudo rm -rf $(DATA_PATH)/wordpress/*