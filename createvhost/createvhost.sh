#!/bin/bash
# Check for root privileges

# createvhost
# usage : createvhost vhost_name [ sources_directory ]
# if sources_directory is ommited, it will vhost directory will 

if [ $EUID -ne 0 ]; then
	echo "ERROR : must be logged as root. Try with sudo ;)"
	exit 1
fi

if [ -z $1 ]; then
	echo "ERROR : first parameter must be set to a vhost server name"
	exit 1
fi
sourcesDir=""
if [ -n $2 ]; then
	sourcesDir=$2
fi
vhostName=$1
workingDirectory=$(pwd)
# TODO : edit /etc/hosts, to add vhost to point to 127.0.0.1
# would be nice to check if vhost doesn't already exist
# DONE

hostPresent=$(grep $1 /etc/hosts)
if [ -z "$hostPresent" ]; then
	echo "127.0.0.1 $vhostName www.$vhostName" >> /etc/hosts
fi

# TODO : make the directories db, logs, public
# Maybe add a default index.php in public/
# DONE

mkdir -p $vhostName
chown mathieu:www-data $vhostName
#echo "<?php echo 'Hello World ;)'?>" > $sourcesDir/$1/public/index.php
#chown mathieu:www-data $sourcesDir/$1/public/index.php

# TODO : create vhostName.conf in /etc/apache2/sites-available/
# using template file in ~/.config/createvhost
# must replace server_name by wanted serverName and document_root by sourcesDir
sed -e 's|###vhost_name###|'${vhostName}'|g; s|###document_root###|'${workingDirectory}'|g; s|###sources_dir###|'${sourcesDir}'|g' ~/.config/createvhost/apache-conf.template > /etc/apache2/sites-available/$vhostName.conf

# TODO : activate site using sudo a2ensite serverName.conf
sudo a2ensite $vhostName.conf
sudo systemctl reload apache2

# TODO : restart apache2 : sudo systemctl restart apache2