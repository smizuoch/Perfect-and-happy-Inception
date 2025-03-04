#!/bin/bash

# WordPress APIからキーを取得
KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

# PHP形式に変換
ESCAPED_KEYS=$(echo "$KEYS" | sed "s/define(/define(/" | sed "s/');/');/")

# wp-config.phpファイル内のプレースホルダーを実際のキーに置き換え
sed -i "/put your unique phrase here/d" /var/www/html/wp-config.php
sed -i "/Authentication unique keys and salts/a\\$ESCAPED_KEYS" /var/www/html/wp-config.php