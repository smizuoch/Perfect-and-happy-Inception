FROM debian:buster

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    mariadb-server \
    gettext \
    && rm -rf /var/lib/apt/lists/*

# MariaDBの設定ファイルをコピー
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# データベース初期化スクリプトをコピー
COPY ./tools/init-db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-db.sh && \
    envsubst < /usr/local/bin/init-db.sh > /usr/local/bin/init-db-tmp.sh

# データディレクトリの作成と権限設定
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

# 必要なディレクトリを作成
RUN mkdir -p /var/lib/mysql

# ポートを開放
EXPOSE 3306

# 初期化スクリプトを実行
CMD ["init-db-tmp.sh"]