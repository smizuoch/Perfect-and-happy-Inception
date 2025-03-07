#!/bin/bash

# WordPress ディレクトリに移動
cd /var/www/html

echo "Starting WordPress setup..."

# WordPress がインストールされていない場合はダウンロード
if [ ! -f index.php ]; then
    echo "Downloading WordPress..."
    # WordPress の最新版をダウンロード
    wp core download --allow-root
    
    echo "Copying wp-config.php..."
    # 事前に作成したwp-config.phpをコピー
    cp /tmp/wp-config.php /var/www/html/wp-config.php
    
    echo "Generating security keys..."
    # セキュリティキーを生成
    if [ -f /usr/local/bin/generate-keys.sh ]; then
        /usr/local/bin/generate-keys.sh
    fi

    # データベースに接続できるまで待機
    echo "Waiting for database connection..."
    while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
        sleep 1
    done

    echo "Installing WordPress..."
    # WordPress をインストール
    wp core install --url=https://${DOMAIN_NAME} \
                    --title="42 Inception" \
                    --admin_user=admin \
                    --admin_password=admin_password \
                    --admin_email=admin@example.com \
                    --skip-email \
                    --allow-root

    echo "Creating additional user..."
    # 追加ユーザーを作成
    wp user create ${WORDPRESS_DB_USER} user@example.com \
                   --user_pass=${WORDPRESS_DB_PASSWORD} \
                   --role=author \
                   --allow-root

    echo "Updating permalink structure..."
    # パーマリンク設定を更新
    wp option update permalink_structure '/%postname%/' --allow-root
    
    echo "WordPress installed successfully!"
fi

echo "Setting proper permissions..."
# 所有者とパーミッションを適切に設定
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;
chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
# PHP-FPM をフォアグラウンドで実行
exec php-fpm7.3 -F