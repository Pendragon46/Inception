#! /bin/sh

create_sock()
{
    mkdir -p /run/mysqld
    touch /run/mysqld/mysqld.sock
    chown -R mysql:mysql /run/mysqld/
}

configure_database()
{
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    mariadbd --user=mysql --datadir=/var/lib/mysql &
    while ! mariadb-admin ping -s ; do
        sleep 1
    done

    mariadb -e "DROP USER IF EXISTS ''@'localhost';"
    mariadb -e "DELETE FROM mysql.user WHERE User = '';"

    mariadb -e "CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;"
    mariadb -e "CREATE USER IF NOT EXISTS '$DATABASE_USER'@'%' IDENTIFIED BY '$(cat /run/secrets/db_pass)';"
    mariadb -e "GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$DATABASE_USER'@'%' IDENTIFIED BY '$(cat /run/secrets/db_pass)';"
    mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/db_root_pass)';"
    mariadb -u root -p$(cat /run/secrets/db_root_pass) -e "FLUSH PRIVILEGES;"

    # Kill the background process
    pkill mariadbd   
}
execute_mariadb()
{
    exec mariadbd --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
}
create_sock
if [ ! -d /var/lib/mysql/mysql ];then
    configure_database
fi
execute_mariadb