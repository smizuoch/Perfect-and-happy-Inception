FROM debian:buster

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# SSL証明書の生成
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=JP/ST=Tokyo/L=Tokyo/O=42Tokyo/OU=42Tokyo/CN=smizuoch.42.fr"

# Nginxの設定ファイルをコピー
COPY ./nginx.conf /etc/nginx/sites-available/default

# ポート443を開放
EXPOSE 443

# Nginxをフォアグラウンドで実行
CMD ["nginx", "-g", "daemon off;"]