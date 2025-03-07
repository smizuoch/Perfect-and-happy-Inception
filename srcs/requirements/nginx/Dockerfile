# このDockerfileはnginxコンテナのイメージをビルドするために使用されます。
# EXPOSEポートは443で、これはコンテナがこのポートを利用することをDockerに伝える方法です。
# nginxとopensslをインストールし、自己署名証明書を作成して設定ファイルをコピーします。
# ARGコマンドは、.envファイルによって提供されるcompose.ymlファイルから引数を受け取ります。
# これがDockerfileに引数を渡す唯一の方法です。
# RUN echoは秘密情報でserver.confファイルを完成させます。
# 最後から2番目のRUNは、/var/www/の所有者としてwww-dataユーザーを定義します。
# 最後に、nginxサーバーをフォアグラウンドで起動します。

FROM	debian:bullseye

EXPOSE	443

RUN		apt update && apt install -y --no-install-recommends --no-install-suggests \
		nginx \
		openssl && \
		rm -rf /var/lib/apt/lists/*

ARG		CERT_FOLDER CERTIFICATE KEY COUNTRY STATE LOCALITY ORGANIZATION UNIT COMMON_NAME

RUN mkdir -p ${CERT_FOLDER} && \
	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out ${CERTIFICATE} \
    -keyout ${KEY} \
    -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${UNIT}/CN=${COMMON_NAME}"

COPY	conf/nginx.conf	/etc/nginx/
COPY	conf/server.conf	/etc/nginx/conf.d/

RUN		echo "\tserver name ${COMMON_NAME};\n\
			\tssl_certificate ${CERTIFICATE};\n\
			\tssl_certificate_key ${KEY};\n\
			}" >> /etc/nginx/conf.d/server.conf

RUN		mkdir -p /var/www/
RUN		chown -R www-data:www-data /var/www/

CMD		["nginx", "-g", "daemon off;"]