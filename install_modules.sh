#! /bin/bash

echo -e "\e[1;31mThis script will install the needed services, files and update configurations\e[0m";
echo -e "\e[1;31mfor the app to run. This is NOT an unattended script, and some input will be needed.\e[0m";
echo;

# For future uses perhaps..
# echo -e "\e[1;34mInput the versions to install:";
# read -p "PHP (default 7.1): " phpVersion;
# if [ -z "$phpVersion" ]; then
#     phpVersion=7.1;
# fi
# echo -e "\e[0m";
phpVersion=7.1;

## Setup required repositories/install requirements
# Need this to do add-apt-repository (Especially in Docker)
sudo apt install -y software-properties-common
# For PHP
sudo add-apt-repository -y ppa:ondrej/php
# For Percona
sudo apt install gnupg2
wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb

sudo apt update

## PHP
sudo apt install -y php$phpVersion

#Notes: some modules included in newer versions of PHP - wddx 7.4, JSON 8.0
phpModules=("ctype" "curl" "dom" "exif" "fileinfo" "ftp" "gd" "gettext" "igbinary" "json" "mbstring" "memcached" "mysqli" "mysqlnd" "opcache" "pdo" "phar" "readline" "redis" "shmop" "simplexml" "soap" "sockets" "sysvmsg" "sysvsem" "sysvshm" "tokenizer" "wddx" "xml" "xmlreader" "xmlwriter" "xsl" "zmq")
for m in ${phpModules[@]}; do
    sudo apt install -y php$phpVersion-$m
done

## Apache
sudo apt install -y apache2
apacheModules=("access_compat" "auth_basic" "authz_core" "autoindex" "deflate" "env" "mime" "negotiation" "php$phpVersion" "proxy" "reqtimeout" "status" "alias" "authn_core" "authz_host" "autoindex" "dir" "filter" "mpm_prefork" "negotiation" "proxy" "proxy_wstunnel" "setenvif" "status" "alias" "authn_file" "authz_user" "deflate" "dir" "mime" "mpm_prefork" "php$phpVersion" "proxy_http" "reqtimeout" "setenvif")

sudo a2enmod ${apacheModules[@]}
# for m in ${apacheModules[@]}; do
#     sudo a2enmod $m
# done

## Percona/MySQL
sudo apt install -y percona-server-server-5.7

echo -e "\e[1;31mCopying database dump.. \e[0m";
## TODO don't think this local IP is static
rsync --progress -avh bj@192.168.0.230:/home/bj/Documents/dev_dump_sql.tar.xz /tmp
# rsync --progress -avh bj@192.168.0.230:/home/bj/Documents/TRANSCORE_DAT.sql /tmp
echo -e "\e[1;31mUnzipping...\e[0m";
tar -xf /tmp/dev_dump_sql.tar.xz
echo -e "\e[1;31mLoading into MySQL\e[0m";

# mysql -u root -p'root' -e "create database development_MGN_APP";
# mysql -u root -p'root' development_MGN_APP < ./dev_dump_sql/development_MGN_APP.sql
# For some reason, these DBs are needed although not in another installation
mysql -u root -p'root' -e "create database development_MGN_DOCSTORE";
mysql -u root -p'root' -e "create database SIMPLISHIP";
mysql -u root -p'root' -e "create database TRANSCORE_DAT";


# mysql -u base_user -pbase_user_pass -e "create database new_db; GRANT ALL PRIVILEGES ON new_db.* TO new_db_user@localhost IDENTIFIED BY 'new_db_user_pass'"

## Redis and Memcache
sudo apt install -y redis-server memcached

## Setup Some Configs

# Websockets for Apache
sudo sed -i '10i \\tProxyRequests Off' /etc/apache2/sites-available/000-default.conf;
sudo sed -i '11i \\tProxyPass "/ws"  "ws://localhost:12347/"' /etc/apache2/sites-available/000-default.conf;
sudo sed -i '12i \\tProxyPassReverse "/ws"  "ws://localhost:12347/"' /etc/apache2/sites-available/000-default.conf;


## Setup users and groups
# skipping this
# make dev group
# add user if wanted
# add www-data to dev
# make /var/www/html/ group=dev
# make dev have full access to www
# make /var/www in general with html and logs

mkdir $HOME/repo
sudo mkdir -p /var/www/logs
sudo chmod -R 777 /var/www
# Point to a repo directory for the user
sudo ln -s $HOME/repo/ /var/www/html 

# Set Ratchet to start at startup
#TODO actually convert the cron to a service
(crontab -l 2>/dev/null; echo "@reboot $(which php) /var/www/html/ratchet/bin/push-server.php &") | crontab -

## Restart all the services
echo -e "\e[1;31mRestarting services..."
# For Docker: service apache2 restart
sudo systemctl restart apache2 mysql redis-server memcached

echo -e "\e[1;31mServices restarted.."
echo -e "\e[1;31mApache, PHP, MySQL, Redis, and Memcache have been installed. Remember to copy over serverConf.ini.\e[0m";

