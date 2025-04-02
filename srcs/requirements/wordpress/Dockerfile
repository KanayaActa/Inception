# srcs/requirements/wordpress/Dockerfile
FROM debian:buster

RUN apt-get update && apt-get install -y \
    php7.3-fpm \
    php7.3-mysql \
    php7.3-gd \
    php7.3-curl \
    php7.3-mbstring \
    php7.3-xml \
    php7.3-zip \
    wget \
    curl \
    mariadb-client

# PHP-FPMの実行に必要なディレクトリを作成
RUN mkdir -p /run/php

# PHP-FPMをネットワークでリッスンするように設定
RUN sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf

# WordPress用のディレクトリを作成
RUN mkdir -p /var/www/html

# WordPress CLIをダウンロード
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# WordPressセットアップスクリプトをコピー
COPY ./tools/wp_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp_setup.sh

# 作業ディレクトリを設定
WORKDIR /var/www/html

# ポート9000を公開
EXPOSE 9000

# PHP-FPMを起動し、WordPressをセットアップ
CMD ["wp_setup.sh"]
