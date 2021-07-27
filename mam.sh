#
# Starts MySQL, Apache2, and Memcached using services because WSL2 doesn't support systemctl
#

#!/bin/bash

echo "Starting services..."

sudo service mysql start

sudo service apache2 start

sudo service memcached start

echo "Services started."
