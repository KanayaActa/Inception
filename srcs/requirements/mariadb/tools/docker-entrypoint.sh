#!/bin/bash
# srcs/requirements/mariadb/tools/docker-entrypoint.sh

# ここで「初回だけ」DBの初期化を実行
/usr/local/bin/init_db.sh

# 初期化後、mysqld_safeをPID1として実行し続ける
exec mysqld_safe

