#!/bin/bash
#

if [ $EUID -ne 0 ]; then
	echo "ERROR : must be logged as root. Try with sudo ;)"
	exit 1
fi

if [ -z $1 ]; then
	echo "ERROR : first parameter must be set to a vhost server name"
	exit 1
fi
vhostName=$1

# Delete line in /etc/hosts
#sudo cp /etc/hosts /etc/hosts.backup
sudo sed -i '/'${vhostName}'/d' /etc/hosts
# a2dissite

sudo a2dissite ${vhostName}.conf
sudo systemctl reload apache2

# delete vhost configuration file
sudo rm /etc/apache2/sites-available/${vhostName}.conf