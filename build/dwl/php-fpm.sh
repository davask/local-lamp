#!/bin/bash

echo "Start php${DWL_PHP_VERSION}-fpm"

if [ "`sudo service "php${DWL_PHP_VERSION}-fpm" status | grep '[ ok ] php-fpm'${DWL_PHP_VERSION}' is running.' | wc -l`" == "0" ]; then
    sudo service "php${DWL_PHP_VERSION}-fpm" start;
fi

sudo service "php${DWL_PHP_VERSION}-fpm" restart;