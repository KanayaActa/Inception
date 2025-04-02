# srcs/requirements/nginx/Dockerfile
FROM debian:buster

RUN apt-get update && apt-get install -y nginx openssl

# SSL証明書用のディレクトリを作成
RUN mkdir -p /etc/nginx/ssl

# SSL証明書を生成
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=XX/ST=State/L=City/O=Organization/OU=Unit/CN=miwasa.42.fr"

# NGINXの設定をコピー
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# ポート443を公開
EXPOSE 443

# NGINXを起動
CMD ["nginx", "-g", "daemon off;"]
