
Php is a popular langage for creating dynamic website .


### Installation 

```sh
apt install php php-cli php-mysql php-curl php-xml php-mbstring php-zip

#php-cli : a terminal client to php
#php-mysql : module to connect interact to mysql 
#php-curl : curl module
#php-curl : xml module
#php-mbstring : Enable MultiByte string such as Unicode (japanese caractere)
```
### CGI and Fast CGI

CGI (Common Gateway Interface) is an interface that enable webservers to execute script program such as php, python, etc... Fast CGI is a fast version of CGI lol XD.

### php-fpm

```sh
apt install php-fpm
```

PHP-FastCGI Process Manager is a tool that manage a pool of FastCGI process to optimize request handling . 
The configuration file for php-fpm is stored in `/etc/php/8.3/fpm/pool.d/www.conf` . Change these :

```sh
[www]
user = www-data
group = www-data

listen = add.re.ss.ip:port
```

--------
[php-fpm](https://docs.vultr.com/how-to-install-php-and-php-fpm-on-ubuntu-24-04#install-and-configure-php-fpm)