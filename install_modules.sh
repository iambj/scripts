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

## Percona/MySQL
sudo apt install -y percona-server-server-5.7

echo -e "\e[1;31mCopying database dump.. \e[0m";
## TODO don't think this local IP is static
rsync --progress -avh bj@192.168.0.230:/home/bj/Documents/dev_dump_sql.tar.xz /tmp
echo -e "\e[1;31mUnzipping...\e[0m";
tar -xf /tmp/dev_dump_sql.tar.xz
echo -e "\e[1;31mLoading into MySQL\e[0m";
# TODO tar is putting the sqldump in the current directory, not leaving it in /tmp
# mysql -u root -p'root' -e "create database development_MGN_APP";
# mysql -u root -p'root' development_MGN_APP < ./dev_dump_sql/development_MGN_APP.sql

# mysql -u base_user -pbase_user_pass -e "create database new_db; GRANT ALL PRIVILEGES ON new_db.* TO new_db_user@localhost IDENTIFIED BY 'new_db_user_pass'"

## Redis and Memcache
sudo apt install -y redis-server memcached

## Setup Some Configs

# Websockets for Apache
sudo sed -i '10i \\tProxyRequests Off' /etc/apache2/sites-available/000-default.conf;
sudo sed -i '11i \\tProxyPass "/ws"  "ws://localhost:12347/' /etc/apache2/sites-available/000-default.conf;
sudo sed -i '12i \\tProxyPassReverse "/ws"  "ws://localhost:12347/' /etc/apache2/sites-available/000-default.conf;


## Restart all the services
echo -e "\e[1;31mRestarting services..."
# For Docker: service apache2 restart
sudo systemctl restart apache2 mysql redis-server memcached

echo -e "\e[1;31mServices restarted.."
echo -e "\e[1;31mApache, PHP, MySQL, Redis, and Memcache have been installed. Remember to copy over serverConf.ini.\e[0m";