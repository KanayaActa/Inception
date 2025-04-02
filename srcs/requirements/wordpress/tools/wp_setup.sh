#!/bin/bash

echo "Starting WordPress setup..."

# MariaDBが準備完了するまで待機
echo "Waiting for MariaDB to be ready..."

# ディレクトリの所有権を確認
chown -R www-data:www-data /var/www/html

# 接続試行回数を増やす
for i in {1..60}; do
    if mysql -h mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1;" >/dev/null 2>&1; then
        echo "MariaDB is ready!"
        break
    fi

    # 60回試しても接続できない場合は終了
    if [ $i -eq 60 ]; then
        echo "Could not connect to MariaDB after 60 attempts. Exiting."
        exit 1
    fi

    echo "Waiting for MariaDB... $i/60"
    sleep 2
done

# ディレクトリのファイルを確認
ls -la /var/www/html/

# WordPressの初期設定
cd /var/www/html/

# はじめにディレクトリの所有権を設定
chown -R www-data:www-data /var/www/html

# WordPressのコアファイルがない場合はダウンロード
if [ ! -f /var/www/html/wp-load.php ]; then
    echo "Downloading WordPress core files..."
    wp core download --allow-root
    echo "WordPress core files downloaded successfully."
fi

# wp-config.phpが存在しない場合は作成
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create --dbname=${MYSQL_DATABASE} \
                     --dbuser=${MYSQL_USER} \
                     --dbpass=${MYSQL_PASSWORD} \
                     --dbhost=mariadb \
                     --allow-root
    echo "wp-config.php created successfully."
fi

# WordPressがインストールされていない場合はインストール
wp core is-installed --allow-root || {
    echo "Installing WordPress..."
    wp core install --url=${DOMAIN_NAME} \
                    --title=${WP_TITLE} \
                    --admin_user=${WP_ADMIN_USER} \
                    --admin_password=${WP_ADMIN_PASSWORD} \
                    --admin_email=${WP_ADMIN_EMAIL} \
                    --skip-email \
                    --allow-root
    echo "WordPress installed successfully."

    # 追加ユーザーを作成
    echo "Creating additional user..."
    wp user create ${WP_USER} ${WP_USER_EMAIL} \
                   --user_pass=${WP_USER_PASSWORD} \
                   --role=author \
                   --allow-root
    echo "Additional user created successfully."
}

echo "WordPress setup completed!"

# PHP-FPMを起動
echo "Starting PHP-FPM..."
exec php-fpm7.3 -F
