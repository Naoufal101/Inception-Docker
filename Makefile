VOLUMES_DIR = ~/data
MARIADB_VOLUME = ${VOLUMES_DIR}/data_base
WP_VOLUME = ${VOLUMES_DIR}/wordpress_files

COMPOSE_FILE = srcs/docker-compose.yaml
DC = sudo docker compose

all: build

prepare:
	@mkdir -p ${MARIADB_VOLUME} ${WP_VOLUME}

build: prepare
	$(DC) -f $(COMPOSE_FILE) build

up: prepare
	$(DC) -f $(COMPOSE_FILE) up

up-d: prepare
	$(DC) -f $(COMPOSE_FILE) up -d

down:
	$(DC) -f $(COMPOSE_FILE) down

stop:
	$(DC) -f $(COMPOSE_FILE) stop

fclean:
	$(DC) -f $(COMPOSE_FILE) down --rmi all -v
	sudo rm -rf ${VOLUMES_DIR}

re: fclean build
#Remember Remove Sudo!!!!!!!!!!!!!!!!!!!!