#!/bin/bash

# このスクリプトはDockerfileの中でCMDより前に実行する必要があります

# データベースディレクトリが空の場合のみ実行（初回起動時）
if [ ! -d "/var/lib/mysql/mysql" ]; then
    # MySQLデータディレクトリの初期化
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # サーバーを一時的に起動
    mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
ALTER USER 'root'@'127.0.0.1' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
ALTER USER 'root'@'::1' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    echo "MariaDB initialized!"
fi

# このスクリプトはエントリポイントとして使用する場合、最後にmysqld_safeを実行するべきです
# ただし、Dockerfileで直接CMDとして実行する場合は、ここでは何も実行せず終了します
