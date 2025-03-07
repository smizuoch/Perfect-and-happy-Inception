# 変数
NAME		= inception
SRCS		= ./srcs
COMPOSE		= $(SRCS)/compose.yml
HOST_URL	= smizuoch.42.fr
HIDE		= /dev/null

# メッセージ定義
HOST_ADD	= "$(HOST_URL) をホストファイルに追加しました"
FAIL		= "Docker Compose の起動に失敗しました"
UP		= "コンテナが正常に起動しました"
DOWN		= "コンテナを停止しました"
BKP		= "データのバックアップを作成しました"
NX_CLN		= "Nginx コンテナを削除しました"
WP_CLN		= "WordPress コンテナを削除しました"
DB_CLN		= "MariaDB コンテナを削除しました"
NX_FLN		= "Nginx イメージを削除しました"
WP_FLN		= "WordPress イメージを削除しました"
DB_FLN		= "MariaDB イメージを削除しました"
HOST_RM		= "ホストファイルから $(HOST_URL) を削除しました"

# ホストファイル編集関数
define add_host
	grep -q "$(HOST_URL)" /etc/hosts || echo "127.0.0.1 $(HOST_URL)" | sudo tee -a /etc/hosts > /dev/null
endef

define remove_host
	sudo sed -i '/$(HOST_URL)/d' /etc/hosts
endef

# ルール
all: $(NAME)

$(NAME): up

# ホストファイルにURLを追加し、docker composeを使ってコンテナを起動
up: create_dir
	@$(call add_host) && echo " $(HOST_ADD)"
	@docker compose -p $(NAME) -f $(COMPOSE) up --build -d || (echo " $(FAIL)" && exit 1)
	@echo " $(UP)"

# docker composeを使ってコンテナを停止
down:
	@docker compose -p $(NAME) down
	@echo " $(DOWN)"

create_dir:
	@mkdir -p ~/data/database
	@mkdir -p ~/data/wordpress_files

# ホームディレクトリにあるdataフォルダのバックアップを作成
backup:
	@if [ -d ~/data ]; then sudo tar -czvf ~/data.tar.gz -C ~/ data/ > $(HIDE) && echo " $(BKP)" ; fi

# コンテナを停止し、ボリュームを削除し、コンテナを削除
clean:
	@docker compose -p $(NAME) -f $(COMPOSE) down -v
	@if [ -n "$$(docker ps -a --filter "name=nginx" -q)" ]; then docker rm -f nginx > $(HIDE) && echo " $(NX_CLN)" ; fi
	@if [ -n "$$(docker ps -a --filter "name=wordpress" -q)" ]; then docker rm -f wordpress > $(HIDE) && echo " $(WP_CLN)" ; fi
	@if [ -n "$$(docker ps -a --filter "name=mariadb" -q)" ]; then docker rm -f mariadb > $(HIDE) && echo " $(DB_CLN)" ; fi

# データをバックアップし、コンテナ、イメージ、ホストURLを削除
fclean: clean backup
	@sudo rm -rf ~/data
	@if [ -n "$$(docker image ls $(NAME)-nginx -q)" ]; then docker image rm -f $(NAME)-nginx > $(HIDE) && echo " $(NX_FLN)" ; fi
	@if [ -n "$$(docker image ls $(NAME)-wordpress -q)" ]; then docker image rm -f $(NAME)-wordpress > $(HIDE) && echo " $(WP_FLN)" ; fi
	@if [ -n "$$(docker image ls $(NAME)-mariadb -q)" ]; then docker image rm -f $(NAME)-mariadb > $(HIDE) && echo " $(DB_FLN)" ; fi
	@$(call remove_host) && echo " $(HOST_RM)"

status:
	@clear
	@echo "\nCONTAINERS\n"
	@docker ps -a
	@echo "\nIMAGES\n"
	@docker image ls
	@echo "\nVOLUMES\n"
	@docker volume ls
	@echo "\nNETWORKS\n"
	@docker network ls --filter "name=$(NAME)_all"
	@echo ""

# すべてのコンテナ、イメージ、ボリューム、ネットワークを削除してクリーンな状態で開始
prepare:
	@echo "\nPreparing to start with a clean state..."
	@echo "\nCONTAINERS STOPPED\n"
	@if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa) ; fi
	@echo "\nCONTAINERS REMOVED\n"
	@if [ -n "$$(docker ps -qa)" ]; then docker rm $$(docker ps -qa) ; fi
	@echo "\nIMAGES REMOVED\n"
	@if [ -n "$$(docker images -qa)" ]; then docker rmi -f $$(docker images -qa) ; fi
	@echo "\nVOLUMES REMOVED\n"
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q) ; fi
	@echo "\nNETWORKS REMOVED\n"
	@if [ -n "$$(docker network ls -q)" ]; then docker network rm $$(docker network ls -q) 2> /dev/null || true ; fi 
	@echo ""

re: fclean all

# review command
start: 
	@docker compose -p $(NAME) -f $(COMPOSE) start

stop:
	@docker compose -p $(NAME) -f $(COMPOSE) stop

logs:
	@docker compose -p $(NAME) -f $(COMPOSE) logs

# .env
env:
	@curl -s https://raw.githubusercontent.com/smizuoch/inception_env/main/.env > ./srcs/.env

.PHONY: all up down create_dir clean fclean status backup prepare re start stop logs env