COMPOSE_FILE = ./srcs/docker-compose.yml

DATA_FOLDER = /data/
DATA_PATH = $(addprefix $(HOME), $(DATA_FOLDER))

all:
	@echo "$(CYAN)\n Launching \n$(RESET)"
	@mkdir -p $(DATA_PATH)mariadb $(DATA_PATH)wordpress
	@docker compose -f $(COMPOSE_FILE) up --build -d
	@sleep 17
	@echo "\n$(BOLD)$(GREEN)Launched [ ✔ ]\n$(RESET)"

start:
	@echo "$(CYAN)\n starting containers \n$(RESET)";
	@if [ -n "$$(docker ps -aq)" ]; then \
		docker compose -f $(COMPOSE_FILE) start; \
		echo "\n$(BOLD)$(GREEN)Containers started [ ✔ ]\n$(RESET)"; \
	else \
		echo "\n$(BOLD)$(RED)No Docker containers found\n$(RESET)\n"; \
	fi

stop:
	@echo "$(CYAN)\n stopping containers \n$(RESET)";
	@if [ -n "$$(docker ps -aq)" ]; then \
		docker compose -f $(COMPOSE_FILE) stop; \
		echo "\n$(BOLD)$(GREEN)Containers stopped [ ✔ ]\n$(RESET)"; \
	else \
		echo "\n$(BOLD)$(RED)No Docker containers found\n$(RESET)\n"; \
	fi

restart: stop start
	@if [ -n "$$(docker ps -aq)" ]; then \
		echo "\n$(BOLD)$(GREEN)Containers restarted [ ✔ ]\n$(RESET)"; \
	fi

remove_containers:
	@if [ -n "$$(docker ps -aq)" ]; then \
		echo "$(CYAN)\n stopping and removing docker containers \n$(RESET)"; \
		docker compose -f $(COMPOSE_FILE) down; \
		echo "\n$(BOLD)$(GREEN)Containers stopped and removed [ ✔ ]\n$(RESET)"; \
	else \
		echo "\n$(BOLD)$(RED)No Docker containers found\n$(RESET)\n"; \
	fi

remove_volumes:
	@if [ -n "$$(docker volume ls -q)" ]; then \
		echo "$(CYAN)\n removing docker volumes \n$(RESET)"; \
		docker compose -f $(COMPOSE_FILE) down --volumes; \
		echo "\n$(BOLD)$(GREEN)Volumes removed [ ✔ ]\n$(RESET)"; \
	else \
		echo "\n$(BOLD)$(RED)No Docker volumes found\n$(RESET)"; \
	fi

remove_images:
	@if [ -n "$$(docker images -aq)" ]; then \
		echo "$(CYAN)\n removing docker images \n$(RESET)"; \
		docker compose -f $(COMPOSE_FILE) down --rmi all; \
		echo "\n$(BOLD)$(GREEN)Images removed [ ✔ ]\n$(RESET)"; \
	else \
		echo "\n$(BOLD)$(RED)No Docker images found\n$(RESET)"; \
	fi

clean: remove_containers remove_volumes remove_images
	@echo "\n$(BOLD)$(GREEN)cleaned [ ✔ ]\n$(RESET)"

fclean: clean prune
	@if [ -d $(DATA_PATH) ]; then \
		echo "$(CYAN)\n deleting $(DATA_PATH) \n$(RESET)"; \
		sudo rm -rdf $(DATA_PATH); \
	else \
		echo "\n$(BOLD)$(RED)No $(DATA_PATH) found$(RESET)"; \
	fi
	@echo "\n$(BOLD)$(GREEN)fcleaned [ ✔ ]\n$(RESET)"

re: fclean all

prune:
	@echo "$(CYAN)\n pruning docker system \n$(RESET)"
	@docker system prune -fa
	@echo "\n$(BOLD)$(GREEN)Pruned [ ✔ ]\n$(RESET)"

check_status:
	@echo "\n$(CYAN)docker ps -a $(RESET)" && docker ps -a
	@echo "\n$(CYAN)docker volume ls $(RESET)" && docker volume ls
	@echo "\n$(CYAN)docker images -a $(RESET)" && docker images -a
	@echo "\n$(CYAN)docker network ls $(RESET)" && docker network ls
	@if [ -d $(DATA_PATH) ]; then \
		echo "\n$(CYAN)ls -la $(DATA_PATH) $(RESET)" && ls -la $(DATA_PATH); \
	else \
		echo "\n$(CYAN)ls -la $(DATA_PATH) \n$(RESET)No $(DATA_PATH) found."; \
	fi

check_logs:
	@if [ -n "$$(docker ps -aq)" ]; then \
		echo "$(CYAN)\n showing docker logs \n$(RESET)"; \
		echo "\n$(CYAN)Nginx logs:$(RESET)"; docker logs nginx; \
		echo "\n$(CYAN)Mariadb logs:$(RESET)"; docker logs mariadb; \
		echo "\n$(CYAN)WordPress logs:$(RESET)"; docker logs wordpress; \
	else \
		echo "\n$(BOLD)$(RED)No Docker containers found.$(RESET)\n"; \
	fi

.PHONY: all start stop restart remove_containers remove_volumes remove_images \
		clean fclean re prune check_status check_logs

# COLORS
RESET = \033[0m
RED = \033[91m
GREEN = \033[92m
CYAN = \033[96m

# FORMAT
BOLD = \033[1m
