VOLUME_DB = /home/trindran/data/mariadb

VOLUME_WP = /home/trindran/data/wordpress

COMPOSE_PATH = srcs/docker-compose.yml 


up:	
		@mkdir -p $(VOLUME_DB) $(VOLUME_WP)
		docker compose -f $(COMPOSE_PATH) up --build

build:
		docker compose -f $(COMPOSE_PATH) build
stop:
		docker compose -f $(COMPOSE_PATH) stop
down:
		docker compose -f $(COMPOSE_PATH) down
