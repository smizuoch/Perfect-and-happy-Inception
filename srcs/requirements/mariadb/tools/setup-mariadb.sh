#!/bin/bash

# データディレクトリが空かどうかチェック
if [ ! -d "/var/lib/mysql/mysql" ]; then
    # 初期データベースディレクトリの作成
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # MySQLサーバーを起動
    /usr/bin/mysqld_safe --datadir=/var/lib/mysql &
    sleep 5

    # 初期設定用のSQLコマンド
    mysql -u root << EOF
# rootパスワードを設定
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

# リモートからのrootアクセスを削除
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

# 匿名ユーザーを削除
DELETE FROM mysql.user WHERE User='';

# testデータベースを削除
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

# WordPressデータベースとユーザーを作成
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

# 権限変更を反映
FLUSH PRIVILEGES;
EOF

    # MySQLサーバーを停止
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
    sleep 5
    
    echo "MariaDB has been initialized."
else
    echo "MariaDB data directory already exists, skipping initialization."
fi

echo "Starting MariaDB server..."
# MariaDBをフォアグラウンドで実行
exec mysqld_safe