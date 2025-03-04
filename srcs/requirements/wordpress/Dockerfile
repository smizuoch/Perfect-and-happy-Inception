FROM debian:buster

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    php7.3 \
    php7.3-fpm \
    php7.3-mysql \
    php7.3-json \
    php7.3-curl \
    php7.3-gd \
    php7.3-mbstring \
    php7.3-xml \
    php7.3-zip \
    php7.3-soap \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# WordPress CLI のインストール
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# PHP-FPM の設定ファイルをコピー
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/

# WordPress のセットアップスクリプトとwp-config.phpをコピー
COPY ./conf/wp-config.php /tmp/wp-config.php
COPY ./tools/setup-wordpress.sh /usr/local/bin/
COPY ./tools/generate-keys.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/setup-wordpress.sh /usr/local/bin/generate-keys.sh

# ディレクトリを作成
RUN mkdir -p /run/php /var/www/html

WORKDIR /var/www/html

EXPOSE 9000

# スクリプトを実行して PHP-FPM を起動
CMD ["/usr/local/bin/setup-wordpress.sh"]