NAME = inception

all: $(NAME)

$(NAME):
	@mkdir -p /home/$(USER)/data/wordpress
	@mkdir -p /home/$(USER)/data/mariadb
	@docker compose -f ./srcs/compose.yml up -d --build

down:
	@docker compose -f ./srcs/compose.yml down

env:
	@git clone https://github.com/smizuoch/inception_env.git ./srcs/env
	@cp ./srcs/env/.env ./srcs/.env
	@rm -rf ./srcs/env

resolve:
	sudo cp /etc/hosts /etc/hosts.bak
	sudo chmod 777 /etc/hosts
	sudo printf "\n127.0.0.1 smizuoch.42.fr\n" >> /etc/hosts
	sudo chmod 644 /etc/hosts

re: down all

clean: down
	@docker system prune -a
	@sudo mv /etc/hosts.bak /etc/hosts | true

fclean: clean
	@docker volume rm $$(docker volume ls -q)
	@sudo rm -rf /home/$(USER)/data/wordpress
	@sudo rm -rf /home/$(USER)/data/mariadb

.PHONY: all down re clean fclean