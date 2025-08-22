
Mariadb is a relationnal database management system (SQL). Manage data for dynamic website.
### Installation

-  Alpine
```bash
apk add mariadb
apk add mariadb-client #The client is not automatically installed in alpine

mkdir -p /run/mysqld
touch /run/mysqld/mysqld.sock
chown -R mysql:mysql /run/mysqld/
mariadb-install-db --user=mysql --datadir=/var/lib/mysql

```

- Debian
```sh
apt install mariadb-server 
```


### Command

- Command to improve security
```shell
mysql-secure-installation # or mariadb-secure-installation 
```
equivalent to 
```bash
	
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('newpassword');
DROP USER IF EXISTS ''@'localhost';
flush privileges;

```

- Wordpress (container)
```sh
mariadbd --user=mysql --datadir=/var/lib/mysql &

# input these command
CREATE DATABASE wordpress_db;
CREATE USER 'wp_user'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wp_user'@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EXIT

# Kill the background daemon
pkill mariadbd

# reload it in foreground
#mariadb listen by default to localhost request, to accept remote request specify the address with bind-adress= ip adress
mariadbd --user=mysql --datadir=/var/lib/mysql
```

------

[digital-ocean](https://www.digitalocean.com/community/tutorials/install-wordpress-on-ubuntu)