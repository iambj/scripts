#! /bin/bash

## Setup required repositories
# Need this to do add-apt-repository (Especially in Docker)
sudo apt install software-properties-common
# For PHP
sudo add-apt-repository ppa:ondrej/php
# For Percona
sudo apt install gnupg2
wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb

sudo apt update

## PHP
sudo apt install -y php7.1

phpModules=("ctype" "curl" "dom" "exif" "fileinfo" "ftp" "gd" "gettext" "igbinary" "json" "mbstring" "memcached" "mysqli" "mysqlnd" "opcache" "pdo" "phar" "readline" "redis" "shmop" "simplexml" "soap" "sockets" "sysvmsg" "sysvsem" "sysvshm" "tokenizer" "wddx" "xml" "xmlreader" "xmlwriter" "xsl" "zmq")
for m in ${phpModules[@]}; do
    sudo apt install -y php7.1-$m
done

## Apache
sudo apt install -y apache2
apacheModules=("access_compat" "auth_basic" "authz_core" "autoindex" "deflate" "env" "mime" "negotiation" "php7.1" "proxy" "reqtimeout" "status" "alias" "authn_core" "authz_host" "autoindex" "dir" "filter" "mpm_prefork" "negotiation" "proxy" "proxy_wstunnel" "setenvif" "status" "alias" "authn_file" "authz_user" "deflate" "dir" "mime" "mpm_prefork" "php7.1" "proxy_http" "reqtimeout" "setenvif")

sudo a2enmod ${apacheModules[@]}
# for m in ${apacheModules[@]}; do
#     sudo a2enmod $m
# done

echo -e "\e[1;34mRestarting Apache..."
sudo systemctl restart apache2;
echo -e "Restarting Apache.\e[0m";
# For Docker: service apache2 restart

## Percona/MySQL
sudo apt install percona-server-server-5.7

echo -e "\e[1;31mCopying database dump.. \e[0m";
## TODO don't think this local IP is static
rsync --progress -avh bj@192.168.0.230:/home/bj/Documents/dev_dump_sql.tar.xz /tmp
echo -e "\e[1;31mUnzipping...\e[0m";
tar -xf /tmp/dev_dump_sql.tar.xz
echo -e "\e[1;31mLoading into MySQL\e[0m";
mysql -u root -p'root' < /tmp/dev_dump_sql.sql


echo -e "\e[1;31mApache and PHP have been installed. Remember to copy over serverConf.ini.\e[0m";


