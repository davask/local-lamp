#!/bin/bash
DWL_PHP_VERSION="`php --version | grep -e '^PHP' | awk '{print $2}'`";
DWL_PHP_VERSION="${PHP_VERSION:0:3}";
if [ -f /etc/php/${DWL_PHP_VERSION}/apache2/php.ini ]; then
    echo "Update /etc/php/${DWL_PHP_VERSION}/apache2/php.ini";
    sudo sed -i "s|;date.timezone =|date.timezone = ${DWL_PHP_DATETIMEZONE}|g" /etc/php/${DWL_PHP_VERSION}/apache2/php.ini;
fi
if [ -f /etc/php/${DWL_PHP_VERSION}/cli/php.ini ]; then
    echo "Update /etc/php/${DWL_PHP_VERSION}/cli/php.ini";
    sudo sed -i "s|;date.timezone =|date.timezone = ${DWL_PHP_DATETIMEZONE}|g" /etc/php/${DWL_PHP_VERSION}/cli/php.ini;
fi
if [ -f /etc/php/${DWL_PHP_VERSION}/fpm/php.ini ]; then
    echo "Update /etc/php/${DWL_PHP_VERSION}/fpm/php.ini";
    sudo sed -i "s|;date.timezone =|date.timezone = ${DWL_PHP_DATETIMEZONE}|g" /etc/php/${DWL_PHP_VERSION}/fpm/php.ini;
fi