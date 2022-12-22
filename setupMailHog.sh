#!/bin/bash

# TODO:
#       - update for different version of PHP
#       - change to php-fpm


sudo apt-get -y install golang-go

go get github.com/mailhog/MailHog

sudo sed -i 's|;sendmail_path =|sendmail_path = /home/bj/go/bin/mhsendmail|' /etc/php/7.1/apache2/php.ini

echo "@reboot bj      /home/bj/go/bin/MailHog &> /dev/null nohup &" | sudo tee  /etc/cron.d/mailHog > /dev/null


# restarting apache2 here because we a lazily using just the php module instead of php-fpm for now
sudo systemctl restart apache2.service

# start MailHog to verify it all worked
/home/bj/go/bin/MailHog
