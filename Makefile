
USER		=	rguigneb
DATA_DIR	=	/home/$(USER)/data
SRCS		=	./srcs
COMPOSE_YML	=	$(SRCS)/docker-compose.yml
DK_COMPOSE	=	docker compose -f $(COMPOSE_YML)

GREEN		=	\033[1;32m
YELLOW		=	\033[1;33m
RED			=	\033[1;31m
BLUE		=	\033[1;34m
BOLD		=	\033[1m
RESET		=	\033[0m

all: setup up

setup:
	@echo "$(YELLOW)$(BOLD)🛠️  Creating data directories...$(RESET)"
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	@echo "$(BLUE)$(BOLD)📝 Configuring /etc/hosts for rguigneb.42.fr...$(RESET)"
	@if ! grep -q "127.0.0.1 rguigneb.42.fr" /etc/hosts; then \
		echo "127.0.0.1 rguigneb.42.fr" | sudo tee -a /etc/hosts > /dev/null; \
	fi
	@echo "$(GREEN)$(BOLD)✅ Data directories created successfully!$(RESET)"

up: setup
	@echo "$(YELLOW)$(BOLD)🚀 Starting services with Docker Compose...$(RESET)"
	@$(DK_COMPOSE) up -d --build
	@sudo chown -R 33:33 $(DATA_DIR)/wordpress
	@sudo chmod -R 755 $(DATA_DIR)/wordpress
	@echo "$(GREEN)$(BOLD)✅ Services up and running!$(RESET)"

down:
	@echo "$(RED)$(BOLD)⛔ Stopping containers...$(RESET)"
	@$(DK_COMPOSE) down
	@echo "$(GREEN)$(BOLD)✅ Containers stopped!$(RESET)"

clean: down
	@echo "$(RED)$(BOLD)🧹 Removing data directories...$(RESET)"
	@sudo rm -rf $(DATA_DIR)
	@echo "$(GREEN)$(BOLD)✅ Data directories removed!$(RESET)"

fclean: clean
	@echo "$(RED)$(BOLD)🔥 Removing ALL Docker containers...$(RESET)"
	@docker rm -f $$(docker ps -aq) 2>/dev/null || true

	@echo "$(RED)$(BOLD)🔥 Removing ALL Docker images...$(RESET)"
	@docker rmi -f $$(docker images -aq) 2>/dev/null || true

	@echo "$(RED)$(BOLD)🔥 Removing ALL Docker volumes...$(RESET)"
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

	@echo "$(RED)$(BOLD)🔥 Removing ALL Docker networks...$(RESET)"
	@docker network rm $$(docker network ls -q | grep -v "bridge\|host\|none") 2>/dev/null || true

	@echo "$(RED)$(BOLD)🔥 Removing Docker build cache...$(RESET)"
	@docker builder prune -af

	@echo "$(GREEN)$(BOLD)🧨 Docker environment completely cleaned!$(RESET)"
	@sudo rm -rf $(DATA_DIR)

re: fclean all

.PHONY: all setup up down clean fclean re
