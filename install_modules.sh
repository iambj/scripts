#! /bin/bash

# Need this to do add-apt-repository (Especially in Docker)
sudo apt install software-properties-common

## PHP
sudo add-apt-repository ppa:ondrej/php
sudo apt update
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

echo "Restarting Apache..";
sudo systemctl restart apache2;
echo "Restarting Apache.";
# For Docker: service apache2 restart

echo -e "\e[1;31mApache and PHP have been installed. Remember to copy over serverConf.ini.\e[0m";


