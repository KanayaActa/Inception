# srcs/requirements/mariadb/Dockerfile
FROM debian:buster

RUN apt-get update && apt-get install -y mariadb-server

# 必要であればmy.cnfをコピー
COPY ./conf/my.cnf /etc/mysql/my.cnf

# 初期化スクリプトをコンテナに配置
COPY ./tools/init_db.sh /usr/local/bin/init_db.sh
RUN chmod +x /usr/local/bin/init_db.sh

# エントリポイントスクリプトを配置
COPY ./tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3306

# エントリポイントを指定
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

