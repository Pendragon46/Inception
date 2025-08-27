#! /bin/sh

#install wp-cli
install_cli()
{
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
}

#create dir and config user and download wordpress.
#in alpine RAM allocated for execution php script is 128M \
#which is not enough to run wp core download so we execute it with limit set to 512
#adduser D-pass Hno-home S-sysuser
download_create_config()
{
    mkdir -p /var/www/html/wordpress
    if ! id -u www-data &>/dev/null;then
        adduser -D -H -S -G www-data www-data
    fi
    if [ ! -e /var/www/html/wordpress/wp-config.php ]; then
        php -d memory_limit=512M $(which wp) core download --path=/var/www/html/wordpress
        chown -R www-data:www-data /var/www/html/wordpress/
        chmod -R 755 /var/www/html/wordpress/
        wp config create --dbhost=mariadb:3306 \
                         --dbname=$DATABASE_NAME \
                         --dbuser=$DATABASE_USER \
                         --path=/var/www/html/wordpress \
                         --dbpass=$(cat /run/secrets/db_pass) \
                         --allow-root
    fi
}

installation()
{
    if ! wp core is-installed --path=/var/www/html/wordpress 2>/dev/null; then
        wp core install  --path=/var/www/html/wordpress \
                         --url=$DOMAIN_NAME \
                         --title=trindran \
                         --admin_user=$WP_ADMIN_USER \
                         --admin_email=admin@test.com\
                         --admin_password=$(cat /run/secrets/wp_admin_pass) \
                         --skip-email
        
    fi
    if ! wp user exists $WP_USER --path=/var/www/html/wordpress &>/dev/null; then
        wp user create $WP_USER user@test.com --role=editor --user_pass=$(cat /run/secrets/wp_user_pass) --path=/var/www/html/wordpress
    fi
}

run_php_fpm()
{
    echo "Start php-fpm83 -F"
    exec php-fpm83 -F
}

install_cli
download_create_config
installation
run_php_fpm