#!/bin/bash

# WordPress ディレクトリに移動
cd /var/www/html

# WordPress がインストールされていない場合はダウンロード
if [ ! -f index.php ]; then
    # WordPress の最新版をダウンロード
    wp core download --allow-root
    
    # 事前に作成したwp-config.phpをコピー
    cp /tmp/wp-config.php /var/www/html/wp-config.php
    
    # セキュリティキーを生成
    /usr/local/bin/generate-keys.sh

    # WordPress をインストール
    wp core install --url=https://${DOMAIN_NAME} \
                    --title="42 Inception" \
                    --admin_user=admin \
                    --admin_password=admin_password \
                    --admin_email=admin@example.com \
                    --skip-email \
                    --allow-root

    # 追加ユーザーを作成
    wp user create ${WORDPRESS_DB_USER} user@example.com \
                   --user_pass=${WORDPRESS_DB_PASSWORD} \
                   --role=author \
                   --allow-root

    # パーマリンク設定を更新
    wp option update permalink_structure '/%postname%/' --allow-root
    
    echo "WordPress installed successfully!"
fi

# 所有者を www-data に変更
chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
# PHP-FPM をフォアグラウンドで実行
exec php-fpm7.3 -F