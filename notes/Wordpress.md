
Wordpress is a CMS (Content Management System). It is a tool for creating website without having to code .


### Requirements

- *Web Server with php-fpm*:
		Wordpress is written in php and the server need a CGI (`CGI allows web servers to execute scripts or programs`) to correctly serve it. Php-fpm is a Fast CGI process Manager.

-  *Database ([[Mariadb]])*

### WP-CLI
wp-cli is a command line interface for managing wordpress .
- Installation 
```sh
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
# move to somewhere in the PATH env and rename it to wp
sudo mv wp-cli.phar /usr/local/bin/wp

```

- [wp core download](https://developer.wordpress.org/cli/commands/core/download/)
```sh
#download wp core file | PATH should already exist
wp core download --path=$PATH
```
 - [wp config create](https://developer.wordpress.org/cli/commands/config/create/)
```sh
#Generates a wp-config.php file. check link to see option
wp config create 
```
- [wp core install](https://developer.wordpress.org/cli/commands/core/install/)
```sh
#Wordpress installation. check link to see option
wp core install 

```

--------------

[install wordpress](https://www.digitalocean.com/community/tutorials/install-wordpress-on-ubuntu)