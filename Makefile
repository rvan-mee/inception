COMPOSE_FILE = srcs/docker-compose.yml

all: build run

build:
	@mkdir -p ${HOME}/data
	@mkdir -p ${HOME}/data/db
	@mkdir -p ${HOME}/data/wp
	@docker compose -f $(COMPOSE_FILE) build

run:
	@mkdir -p ${HOME}/data
	@mkdir -p ${HOME}/data/db
	@mkdir -p ${HOME}/data/wp
	@docker compose -f $(COMPOSE_FILE) up --remove-orphans # -d

stop:
	@docker compose -f $(COMPOSE_FILE) stop

restart: stop build run

prune: stop
	docker system prune -fa
	sudo rm -rf ${HOME}/data

exec-mariadb:
	docker exec -it mariadb bash

exec-wp:
	docker exec -it wordpress bash

exec-nginx:
	docker exec -it nginx bash

.PHONY: all build run stop restart logs prune
