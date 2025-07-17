USER=rguigneb
DATA_DIR = /home/$(USER)/data
SRCS=./srcs
COMPOSE_YML=$(SRCS)/docker-compose.yml
DK_COMPOSE=docker compose -f $(COMPOSE_YML)

all: setup up

setup:
	@echo "Creating data directories..."
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	@if [ ! -d $(DATA_DIR)/static-website ]; then \
		mkdir -p $(DATA_DIR)/static-website; \
		git clone --single-branch --branch hugo-config git@github.com:R0-main/MinesWeeper.git $(DATA_DIR)/static-website ;\
		echo "Directory exists"; \
	fi
	@echo "Configuring /etc/hosts for rguigneb.42.fr..."
	@if ! grep -q "127.0.0.1 rguigneb.42.fr" /etc/hosts; then \
		echo "127.0.0.1 rguigneb.42.fr" | sudo tee -a /etc/hosts > /dev/null; \
	fi
	@echo "Data directories created successfully!"

up: setup
	$(DK_COMPOSE) up -d --build
	@sudo chown -R 33:33 $(DATA_DIR)/wordpress
	@sudo chmod -R 755 $(DATA_DIR)/wordpress

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
