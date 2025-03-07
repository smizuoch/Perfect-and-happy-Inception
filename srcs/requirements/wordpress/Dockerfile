# このDockerfileは WordPressコンテナを構築するために使用されます
# EXPOSE ポート9000はDockerにこのコンテナがこのポートを使用することを伝えるための方法です
# ca-certificates、php7.4-fpm、php7.4-mysql、wget、tarをインストールし、設定ファイルをコピーします
# RUN sedコマンドはpath infoを修正するためにphp.iniファイルを変更します
# RUN wgetはコマンドラインからWordPressをインストールするために使用されるwp-cli.pharファイルをダウンロードします
# 最後にフォルダを作成し、www-dataユーザーに権限を設定します
# そして、WordPressをインストールするために使用されるsetup.shスクリプトを実行します
# そしてフォアグラウンドでphp-fpm7.4サーバーを起動します

FROM	debian:bullseye

EXPOSE	9000

ARG		PHPPATH=/etc/php/7.4/fpm

RUN		apt update && apt install --no-install-recommends --no-install-suggests -y \
		ca-certificates \
		php7.4-fpm \
		php7.4-mysql \
		wget \
		tar && \
		rm -rf /var/lib/apt/lists/*

RUN		service php7.4-fpm stop

COPY	conf/www.conf ${PHPPATH}/pool.d/

RUN		sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${PHPPATH}/php.ini && \
		sed -i "s/listen = \/run\/php\/php$PHP_VERSION_ENV-fpm.sock/listen = 9000/g" ${PHPPATH}/pool.d/www.conf && \
		sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' ${PHPPATH}/pool.d/www.conf && \
		sed -i 's/;daemonize = yes/daemonize = no/g' ${PHPPATH}/pool.d/www.conf

RUN		wget --no-check-certificate https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
		chmod +x wp-cli.phar && \
		mv wp-cli.phar /usr/local/bin/wp

RUN		mkdir -p /run/php/ && \
		mkdir -p /var/run/php/ && \
		mkdir -p /var/www/inception/

RUN		chown -R www-data:www-data /var/www/inception/

COPY	conf/wp-config.php /tmp/

COPY	tools/setup.sh /bin/
RUN		chmod +x /bin/setup.sh

CMD		["setup.sh", "php-fpm7.4", "--nodaemonize"]