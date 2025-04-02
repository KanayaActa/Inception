#!/bin/bash

echo "🚀 init_db.sh started"
echo "📦 MYSQL_DATABASE=${MYSQL_DATABASE}"
echo "👤 MYSQL_USER=${MYSQL_USER}"
echo "🔐 MYSQL_PASSWORD=${MYSQL_PASSWORD}"
echo "🔐 MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}"

# 初期化済みかどうかをフラグファイルで判定
if [ ! -f "/var/lib/mysql/.initialized" ]; then
    echo "📁 MariaDB data directory not initialized. Initializing..."

    # データディレクトリの初期化
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    echo "✅ mysql_install_db completed"

    echo "⚙️ Running mysqld bootstrap to configure database..."
    mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    # フラグファイル作成（次回以降は初期化スキップ）
    touch /var/lib/mysql/.initialized
    echo "✅ MariaDB initialized and ready!"
else
    echo "📂 MariaDB already initialized. Skipping setup."
fi

echo "🚀 Starting mysqld_safe server..."
exec mysqld_safe --datadir=/var/lib/mysql --bind-address=0.0.0.0

