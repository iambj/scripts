#
# Starts MySQL, Apache2, and Memcached using services because WSL2 doesn't support systemctl
#

#!/bin/bash

usage() {	
cat <<HELP
	$(basename $0) [OPTION] 
	
	-k Kills the WebSocket server found by name of the script that started it
	-w Starts the default WebSocket server	

HELP
exit 1	

}

# Show help on --help
if [ "$1" = "--help" ]
then
	usage
fi


if [ "$1" = "-k" ]
then
	ID=$(ps aux | grep "push-server.php" | awk '{print $2}' | head -1)
	echo "Killing WebSocket Server PID: " $ID
	kill $ID
	exit 1
fi

echo "Starting services..."

sudo service mysql start

sudo service apache2 start

sudo service memcached start

echo "Services started."

if [ "$1" = "-w" ]
then
	echo "Starting WebSocket Server"
	
	$(which php) /home/bj/repo/mgn_tms/ratchet/bin/push-server.php &
	echo "WS PID: " $!
fi

