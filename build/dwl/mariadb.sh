#!/bin/bash

# sudo /usr/bin/mysqld_safe --timezone=${DATE_TIMEZONE}&

echo "Start MariaDB"

if [ "`sudo service mysql status | grep '[ ok ] mysql is running.' | wc -l`" == "0" ]; then
    echo "Start MariaDB";
    sudo service mysql start;
    echo "";
fi

echo "Reload MariaDB";
sudo service mysql reload;
echo "";
