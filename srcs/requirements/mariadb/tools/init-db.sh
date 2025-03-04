#!/bin/bash

# データディレクトリが空の場合はデータベースを初期化
# ディレクトリの有無をログ出力
echo "Checking if /var/lib/mysql/mysql exists..."
if [ -d "/var/lib/mysql/mysql" ]; then
    echo "MariaDB database directory exists, skipping initialization."
else
    echo "MariaDB database directory not found. Initializing..."
    
    # mysql_install_dbを条件分岐の中に移動
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # 権限を確実に設定
    chown -R mysql:mysql /var/lib/mysql
    
    # MariaDBを起動
    echo "Starting temporary MariaDB server for initialization..."
    mysqld --user=mysql --bootstrap &
    MYSQL_PID=$!
    
    # サーバーが起動するのを待つ
    echo "Waiting for MariaDB to be ready..."
    # 残りの初期化処理
    # ...
    echo "Initializing MariaDB database..."
    
    # データベースの初期化
    # mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # MariaDBを起動
    /usr/bin/mysqld_safe --datadir=/var/lib/mysql &
    
    # MariaDBが起動するまで待機
    until mysqladmin ping >/dev/null 2>&1; do
        echo "Waiting for MariaDB to be ready..."
        sleep 1
    done
    
    # データベースとユーザーの設定
    mysql -u root << EOF
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

# まず既存のユーザーを削除してからクリーンに作成する
DROP USER IF EXISTS '${MYSQL_USER}'@'%';
DROP USER IF EXISTS '${MYSQL_USER}'@'localhost';

# リモートホストからのアクセスを許可
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF
    
    # MariaDBをシャットダウン
    mysqladmin -u root shutdown
    
    echo "MariaDB initialized successfully!"
fi

# mysql_install_db --user=mysql --datadir=/var/lib/mysql

# 権限を確実に設定
chown -R mysql:mysql /var/lib/mysql
chmod 777 /var/run/mysqld

echo "Starting MariaDB server..."
exec mysqld --user=mysql