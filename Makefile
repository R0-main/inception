# Makefile
USER=rguigneb
DATA_DIR = /home/$(USER)/data
SRCS=./srcs
COMPOSE_YML=$(SRCS)/docker-compose.yml
DK_COMPOSE=docker-compose -f $(COMPOSE_YML)

# add hosts..

all: setup up

setup:
	@echo "Creating data directories..."
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	@echo "Data directories created successfully!"

up: setup
	$(DK_COMPOSE) up -d --build

down:
	$(DK_COMPOSE) down

clean-data:
	@echo "Removing data directories..."
	@sudo rm -rf $(DATA_DIR)
	@echo "Data directories removed successfully!"

clean: down
	docker system prune -af
	docker volume prune -f

fclean: clean
	@sudo rm -rf $(DATA_DIR)
	@echo "All data directories removed!"

re: fclean all

.PHONY: all setup up down clean fclean re
