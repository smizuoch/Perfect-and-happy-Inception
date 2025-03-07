#!/bin/bash

# このスクリプトはビルドコンテナ内で実行されます
# /var/www/inception/ フォルダの所有権を www-data ユーザーに変更します
# その後、wp-config.php ファイルが /var/www/inception/ フォルダにあることを確認します
# もしまだなければ、WordPress のコアファイルをダウンロードします
# WordPress がインストールされていない場合はインストールします
# 管理者ユーザーとパスワードがまだ設定されていない場合は設定します
# これらの変数は .env ファイルで設定されています
# 最後から2番目の行では、最も気に入った raft テーマをダウンロードして有効化します
# 最後に、exec $@ は Dockerfile の次の CMD を実行します
# この場合: フォアグラウンドで php-fpm7.4 サーバーを起動します

# set -ex # コマンドを表示し、エラー時に終了（デバッグモード）

chown -R www-data:www-data /var/www/inception/

if [ ! -f "/var/www/inception/wp-config.php" ]; then
   mv /tmp/wp-config.php /var/www/inception/
fi

sleep 10

wp --allow-root --path="/var/www/inception/" core download || true

if ! wp --allow-root --path="/var/www/inception/" core is-installed;
then
    wp  --allow-root --path="/var/www/inception/" core install \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL
fi;

if ! wp --allow-root --path="/var/www/inception/" user get $WP_USER;
then
    wp  --allow-root --path="/var/www/inception/" user create \
        $WP_USER \
        $WP_EMAIL \
        --user_pass=$WP_PASSWORD \
        --role=$WP_ROLE
fi;

# wp --allow-root --path="/var/www/inception/" theme install raft --activate 

exec $@