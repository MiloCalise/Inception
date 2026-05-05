NAME        := inception
COMPOSE     := srcs/docker-compose.yml
ENV_FILE    := srcs/.env
DATA_PATH   := /home/miltavar42/data

# ── Colours ───────────────────────────────────────────────────────────────────
GREEN  := \033[0;32m
YELLOW := \033[0;33m
RED    := \033[0;31m
RESET  := \033[0m

# ─────────────────────────────────────────────────────────────────────────────

all: up

## up : create data dirs, build images and start containers
up: create_dirs
	@echo "$(GREEN)[$(NAME)] Building and starting containers...$(RESET)"
	docker-compose --env-file $(ENV_FILE) -f $(COMPOSE) up -d --build
	@echo "$(GREEN)[$(NAME)] Done. Site: https://miltavar42.42.fr$(RESET)"

## build : (re)build images without starting
build:
	@echo "$(YELLOW)[$(NAME)] Building images...$(RESET)"
	docker-compose --env-file $(ENV_FILE) -f $(COMPOSE) build

## start : start already-built containers
start:
	docker-compose --env-file $(ENV_FILE) -f $(COMPOSE) start

## stop : stop containers without removing them
stop:
	docker-compose --env-file $(ENV_FILE) -f $(COMPOSE) stop

## restart : stop + start
restart: stop start

## down : stop and remove containers + network
down:
	docker-compose --env-file $(ENV_FILE) -f $(COMPOSE) down

## clean : down + remove volumes + images + data dirs
clean: down
	@echo "$(RED)[$(NAME)] Removing volumes, images and data contents...$(RESET)"
	docker-compose --env-file $(ENV_FILE) -f $(COMPOSE) down \
	    --volumes --rmi all --remove-orphans
	sudo rm -rf $(DATA_PATH)/mariadb && mkdir -p $(DATA_PATH)/mariadb
	sudo rm -rf $(DATA_PATH)/wordpress && mkdir -p $(DATA_PATH)/wordpress
	@echo "$(RED)[$(NAME)] Clean done.$(RESET)"

## fclean : clean + prune all unused Docker objects
fclean: clean
	docker system prune -af

## re : fclean + up
re: fclean up

## logs : tail container logs
logs:
	docker-compose --env-file $(ENV_FILE) -f $(COMPOSE) logs -f

## ps : show running containers
ps:
	docker-compose --env-file $(ENV_FILE) -f $(COMPOSE) ps

## status : alias for ps
status: ps

## create_dirs : ensure host data directories exist before volume mount
create_dirs:
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress

help:
	@grep -E '^## ' Makefile | sed 's/## /  /'

.PHONY: all up build start stop restart down clean fclean re \
        logs ps status create_dirs help
