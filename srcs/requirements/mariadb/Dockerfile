FROM debian:buster

# MariaDBのインストール
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# MariaDB設定ファイルのコピー
COPY ./conf/my.cnf /etc/mysql/my.cnf

# MariaDB初期化スクリプトのコピー
COPY ./tools/setup-mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-mariadb.sh

# データディレクトリの所有権を設定
RUN mkdir -p /var/lib/mysql /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

# ポート3306を開放
EXPOSE 3306

# MariaDBを起動
CMD ["/usr/local/bin/setup-mariadb.sh"]