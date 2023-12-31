SRCS_PATH = ./srcs/
YML_FILE = docker-compose.yml
COMPOSE_FILE = $(addprefix $(SRCS_PATH), $(YML_FILE))

DB_FOLDER = /data/
DB_PATH = $(addprefix $(HOME), $(DB_FOLDER))

all:
	echo "$(YELLOW)\n. . . Launching . . .\n$(RESET)"
	mkdir -p $(DB_PATH)mariadb $(DB_PATH)wordpress
	@docker compose -f $(COMPOSE_FILE) up --build -d
	@echo "\n$(BOLD)$(GREEN)Launched [ ✔ ]\n$(RESET)"

start:
	@echo "$(YELLOW)\n. . . starting containers . . . \n$(RESET)";
	@if [ -n "$$(docker ps -aq)" ]; then \
		docker compose -f $(COMPOSE_FILE) start; \
		echo "\n$(BOLD)$(GREEN)Containers started [ ✔ ]\n$(RESET)"; \
	else \
		echo "\n$(BOLD)$(RED)No Docker containers found.$(RESET)\n"; \
	fi

stop:
	@echo "$(YELLOW)\n. . . stopping containers . . . \n$(RESET)";
	@if [ -n "$$(docker ps -aq)" ]; then \
		docker compose -f $(COMPOSE_FILE) stop; \
		echo "\n$(BOLD)$(GREEN)Containers stopped [ ✔ ]\n$(RESET)"; \
	else \
		echo "\n$(BOLD)$(RED)No Docker containers found.$(RESET)\n"; \
	fi

restart: stop start
	@if [ -n "$$(docker ps -aq)" ]; then \
		echo "\n$(BOLD)$(GREEN)Containers restarted [ ✔ ]\n$(RESET)"; \
	fi

remove_containers:
	@if [ -n "$$(docker ps -aq)" ]; then \
		echo "$(YELLOW)\n. . . stopping and removing docker containers . . . \n$(RESET)"; \
		docker compose -f $(COMPOSE_FILE) down; \
		echo "\n$(BOLD)$(GREEN)Containers stopped and removed [ ✔ ]\n$(RESET)"; \
	else \
		echo "\n$(BOLD)$(RED)No Docker containers found.$(RESET)\n"; \
	fi

remove_volumes:
	@if [ -n "$$(docker volume ls -q)" ]; then \
		echo "$(YELLOW)\n. . . removing docker volumes . . . \n$(RESET)"; \
		docker compose -f $(COMPOSE_FILE) down --volumes; \
		echo "\n$(BOLD)$(GREEN)Volumes removed [ ✔ ]\n$(RESET)"; \
	else \
		echo "\n$(BOLD)$(RED)No Docker volumes found.\n$(RESET)"; \
	fi

remove_images:
	@if [ -n "$$(docker images -aq)" ]; then \
		echo "$(YELLOW)\n. . . removing docker images . . . \n$(RESET)"; \
		docker compose -f $(COMPOSE_FILE) down --rmi all; \
		echo "\n$(BOLD)$(GREEN)Images removed [ ✔ ]\n$(RESET)"; \
	else \
		echo "\n$(BOLD)$(RED)No Docker images found.\n$(RESET)"; \
	fi

clean: remove_containers remove_volumes remove_images
	@echo "\n$(BOLD)$(GREEN)cleaned [ ✔ ]\n$(RESET)"

fclean: clean #prune
	@if [ -d $(DB_PATH) ]; then \
		echo "$(YELLOW)\n. . . deleting $(DB_PATH) . . . \n$(RESET)"; \
		sudo rm -rdf $(DB_PATH); \
	else \
		echo "\n$(BOLD)$(RED)No $(DB_PATH) found$(RESET)"; \
	fi
	@echo "\n$(BOLD)$(GREEN)fcleaned [ ✔ ]\n$(RESET)"

re: fclean all

prune:
	@echo "$(YELLOW)\n. . . pruning docker system . . . \n$(RESET)"
	@docker system prune -fa
	@echo "\n$(BOLD)$(GREEN)Pruned [ ✔ ]\n$(RESET)"

check_status:
	@echo "\n$(YELLOW)docker ps -a $(RESET)" && docker ps -a
	@echo "\n$(YELLOW)docker volume ls $(RESET)" && docker volume ls
	@echo "\n$(YELLOW)docker images -a $(RESET)" && docker images -a
	@echo "\n$(YELLOW)docker network ls $(RESET)" && docker network ls
	@if [ -d $(DB_PATH) ]; then \
		echo "\n$(YELLOW)ls -la $(DB_PATH) $(RESET)" && ls -la $(DB_PATH); \
	else \
		echo "\n$(YELLOW)ls -la $(DB_PATH) \n$(RESET)No $(DB_PATH) found."; \
	fi

check_logs:
	@if [ -n "$$(docker ps -aq)" ]; then \
		echo "$(YELLOW)\n. . . showing docker logs . . . \n$(RESET)"; \
		echo "\n$(YELLOW)Nginx logs:$(RESET)"; docker logs nginx; \
		echo "\n$(YELLOW)Mariadb logs:$(RESET)"; docker logs mariadb; \
		echo "\n$(YELLOW)WordPress logs:$(RESET)"; docker logs wordpress; \
	else \
		echo "\n$(BOLD)$(RED)No Docker containers found.$(RESET)\n"; \
	fi

.PHONY: all start stop restart remove_containers remove_volumes remove_images \
		clean fclean re prune check_status check_logs

RESET = \033[0m
WHITE = \033[37m
GREY = \033[90m
RED = \033[91m
DRED = \033[31m
GREEN = \033[92m
DGREEN = \033[32m
YELLOW = \033[93m
DYELLOW = \033[33m
BLUE = \033[94m
DBLUE = \033[34m
MAGENTA = \033[95m
DMAGENTA = \033[35m
CYAN = \033[96m
DCYAN = \033[36m