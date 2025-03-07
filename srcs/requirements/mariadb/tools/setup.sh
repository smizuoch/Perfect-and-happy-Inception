#!/bin/bash

# このスクリプトはビルド中のコンテナで実行されます
# それはmariadbサービスを開始し、.envファイルに従ってデータベースとユーザーを作成します
# 最後に、exec $@はDockerfileで次に実行されるCMDを実行します。
# この場合: "mysqld_safe"はmariadbサービスを再起動します

# set -ex # コマンドを表示してエラーで終了します（デバッグモード）

service mariadb start

mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_PASS_ROOT';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASS_ROOT');
EOF

sleep 5

service mariadb stop

exec $@ 