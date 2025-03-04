NAME = inception

all: $(NAME)

$(NAME):
	@mkdir -p /home/$(USER)/data/wordpress
	@mkdir -p /home/$(USER)/data/mariadb
	@docker compose -f ./srcs/compose.yml up -d --build

down:
	@docker compose -f ./srcs/compose.yml down

env:
	@git clone https://github.com/smizuoch/inception_env.git ./srcs

resolve:
	sudo cp

re: down all

clean: down
	@docker system prune -a

fclean: clean
	@docker volume rm $$(docker volume ls -q)
	@sudo rm -rf /home/$(USER)/data/wordpress
	@sudo rm -rf /home/$(USER)/data/mariadb

.PHONY: all down re clean fclean