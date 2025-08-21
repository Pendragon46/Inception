#! /bin/sh


install_db()
{
    mkdir -p /run/mysqld
    touch /run/mysqld/mysqld.sock
    chown -R mysql:mysql /run/mysqld/
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
}

configure_database()
{
    mariadbd --user=mysql --datadir=/var/lib/mysql &

    mariadb -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$(cat /run/secrets/root_pass)');"
    mariadb -e "DROP USER IF EXISTS ''@'localhost';"
    mariadb -e "DELETE FROM mysql.user WHERE User = '';"
    mariadb -e "CREATE DATABASE $DATABASE_NAME;"
    mariadb -e "CREATE USER '$DATABASE_USER'@'%' IDENTIFIED BY '$(cat /run/secrets/db_pass)';"
    mariadb -e "GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$DATABASE_USER'@'%' IDENTIFIED BY '$(cat /run/secrets/db_pass)';"
    mariadb -e "FLUSH PRIVILEGES;"

    # Kill the background process
    pkill mariadbd

    # reload it in foreground
    mariadbd --user=mysql --datadir=/var/lib/mysql
}

install_db
configure_database