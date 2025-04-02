# srcs/requirements/mariadb/Dockerfile
FROM debian:buster

RUN apt-get update && apt-get install -y mariadb-server mariadb-client

# MariaDBの設定をコピー
COPY ./conf/my.cnf /etc/mysql/my.cnf

# 初期化スクリプトをコピー
COPY ./tools/init_db.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init_db.sh

# ポート3306を公開
EXPOSE 3306

# エントリポイントスクリプトを作成
RUN echo '#!/bin/bash\n\
# 初期化スクリプトを実行\n\
/usr/local/bin/init_db.sh\n\
# MariaDBを起動（PID 1として適切に実行）\n\
exec mysqld_safe' > /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

# エントリポイントを設定
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
