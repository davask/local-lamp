#!/bin/bash

for conf in `sudo find /etc/apache2/sites-available -type f -name "*.conf"`; do

    . ${dwlDir}/virtualhost-env.sh;

    if [ "$DWL_USER_DNS_PORT" == "80" ] && [ ! -f "/etc/php/${DWL_PHP_VERSION}/fpm/pool.d/${DWL_USER_DNS_SERVERNAME}.conf" ]; then

        echo "> configure fpm for ${DWL_USER_DNS}";

        echo "- Update PoolName, UserName";

        sudo cp ${dwlDir}/etc/php/${DWL_PHP_VERSION}/fpm/pool.d/docker.davask.com.conf.dwl /etc/php/${DWL_PHP_VERSION}/fpm/pool.d/${DWL_USER_DNS_SERVERNAME}.conf;
        sudo sed -i "s|# PoolName|${DWL_USER_DNS_SERVERNAME:-docker.davask.com}|g" /etc/php/${DWL_PHP_VERSION}/fpm/pool.d/${DWL_USER_DNS_SERVERNAME}.conf;
        sudo sed -i "s|# UserName|${DWL_USER_NAME:-admin}|g" /etc/php/${DWL_PHP_VERSION}/fpm/pool.d/${DWL_USER_DNS_SERVERNAME}.conf;

    fi

done;


echo "Start php${DWL_PHP_VERSION}-fpm"

if [ "`sudo service "php${DWL_PHP_VERSION}-fpm" status | grep '[ ok ] php-fpm'${DWL_PHP_VERSION}' is running.' | wc -l`" == "0" ]; then
    sudo service "php${DWL_PHP_VERSION}-fpm" start;
fi

sudo service "php${DWL_PHP_VERSION}-fpm" restart;