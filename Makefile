# 変数 ----------------------------------------------------------------------

NAME		= inception
SRCS		= ./srcs
COMPOSE		= $(SRCS)/docker-compose.yml
HOST_URL	= smizuoch.42.fr

# ルール ---------------------------------------------------------------------

all: $(NAME)

$(NAME): up

# ホストファイルにURLを追加し、Docker Composeでコンテナを起動する
up: create_dir
	@sudo hostsed add 127.0.0.1 $(HOST_URL) > $(HIDE) && echo " $(HOST_ADD)"
	@docker compose -p $(NAME) -f $(COMPOSE) up --build || (echo " $(FAIL)" && exit 1)
	@echo " $(UP)"

# Docker Composeでコンテナを停止する
down:
	@docker compose -p $(NAME) down
	@echo " $(DOWN)"

create_dir:
	@mkdir -p ${HOME}/data/database
	@mkdir -p ${HOME}/data/wordpress_files

# データフォルダのバックアップをホームディレクトリに作成する
backup:
	@if [ -d ~/data ]; then sudo tar -czvf ~/data.tar.gz -C ~/ data/ > $(HIDE) && echo " $(BKP)" ; fi

# コンテナを停止し、ボリュームとコンテナを削除する
clean:
	@docker compose -f $(COMPOSE) down -v
	@if [ -n "$$(docker ps -a --filter "name=nginx" -q)" ]; then docker rm -f nginx > $(HIDE) && echo " $(NX_CLN)" ; fi
	@if [ -n "$$(docker ps -a --filter "name=wordpress" -q)" ]; then docker rm -f wordpress > $(HIDE) && echo " $(WP_CLN)" ; fi
	@if [ -n "$$(docker ps -a --filter "name=mariadb" -q)" ]; then docker rm -f mariadb > $(HIDE) && echo " $(DB_CLN)" ; fi

# データをバックアップし、コンテナ、イメージ、およびホストファイルからURLを削除する
fclean: clean backup
	@sudo rm -rf ~/data
	@if [ -n "$$(docker image ls $(NAME)-nginx -q)" ]; then docker image rm -f $(NAME)-nginx > $(HIDE) && echo " $(NX_FLN)" ; fi
	@if [ -n "$$(docker image ls $(NAME)-wordpress -q)" ]; then docker image rm -f $(NAME)-wordpress > $(HIDE) && echo " $(WP_FLN)" ; fi
	@if [ -n "$$(docker image ls $(NAME)-mariadb -q)" ]; then docker image rm -f $(NAME)-mariadb > $(HIDE) && echo " $(DB_FLN)" ; fi
	@sudo hostsed rm 127.0.0.1 $(HOST_URL) > $(HIDE) && echo " $(HOST_RM)"

status:
	@clear
	@echo "\nコンテナ一覧\n"
	@docker ps -a
	@echo "\nイメージ一覧\n"
	@docker image ls
	@echo "\nボリューム一覧\n"
	@docker volume ls
	@echo "\nネットワーク一覧\n"
	@docker network ls --filter "name=$(NAME)_all"
	@echo ""

# クリーンな状態で始めるために全てのコンテナ、イメージ、ボリューム、ネットワークを削除する
prepare:
	@echo "\n初期状態にクリーニングします...\n"
	@echo "\nコンテナを停止中...\n"
	@if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa) ;	fi
	@echo "\nコンテナを削除中...\n"
	@if [ -n "$$(docker ps -qa)" ]; then docker rm $$(docker ps -qa) ; fi
	@echo "\nイメージを削除中...\n"
	@if [ -n "$$(docker images -qa)" ]; then docker rmi -f $$(docker images -qa) ; fi
	@echo "\nボリュームを削除中...\n"
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q) ; fi
	@echo "\nネットワークを削除中...\n"
	@if [ -n "$$(docker network ls -q) " ]; then docker network rm $$(docker network ls -q) 2> /dev/null || true ; fi 
	@echo ""

re: fclean all

# レビュー用コマンド
start: 
	docker compose -f ./srcs/docker-compose.yml start

stop:
	docker compose -f ./srcs/docker-compose.yml stop

logs:
	docker compose -f ./srcs/docker-compose.yml logs

# envファイルをダウンロードする
env:
	@curl -s https://raw.githubusercontent.com/smizuoch/inception_env/main/.env > ./srcs/.env


# カスタム設定 ----------------------------------------------------------------

HIDE		= /dev/null 2>&1

RED			= \033[0;31m
GREEN		= \033[0;32m
RESET		= \033[0m

MARK		= $(GREEN)✔$(RESET)
ADDED		= $(GREEN)追加しました$(RESET)
REMOVED		= $(GREEN)削除しました$(RESET)
STARTED		= $(GREEN)起動しました$(RESET)
STOPPED		= $(GREEN)停止しました$(RESET)
CREATED		= $(GREEN)作成しました$(RESET)
EXECUTED	= $(GREEN)実行しました$(RESET)

# メッセージ -----------------------------------------------------------------

UP			= $(MARK) $(NAME)		$(EXECUTED)
DOWN		= $(MARK) $(NAME)		$(STOPPED)
FAIL		= $(RED)✔$(RESET) $(NAME)		$(RED)失敗しました$(RESET)

HOST_ADD	= $(MARK) ホスト $(HOST_URL)		$(ADDED)
HOST_RM		= $(MARK) ホスト $(HOST_URL)		$(REMOVED)

NX_CLN		= $(MARK) コンテナ nginx		$(REMOVED)
WP_CLN		= $(MARK) コンテナ wordpress		$(REMOVED)
DB_CLN		= $(MARK) コンテナ mariadb		$(REMOVED)

NX_FLN		= $(MARK) イメージ $(NAME)-nginx	$(REMOVED)
WP_FLN		= $(MARK) イメージ $(NAME)-wordpress	$(REMOVED)
DB_FLN		= $(MARK) イメージ $(NAME)-mariadb	$(REMOVED)

BKP			= $(MARK) バックアップ $(HOME)	$(CREATED)

# ターゲット ---------------------------------------------------------------

.PHONY: all up down create_dir clean fclean status backup prepare re