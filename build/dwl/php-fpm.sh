#!/bin/bash

if [ "`sudo service php${DWL_PHP_VERSION}-fpm status | grep 'Active: active (running)' | wc -l`" == "0" ]; then
    sudo service php${DWL_PHP_VERSION}-fpm start;
fi

sudo service php${DWL_PHP_VERSION}-fpm restart;