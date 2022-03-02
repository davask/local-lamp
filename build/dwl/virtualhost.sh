#!/bin/bash

for conf in `sudo find /etc/apache2/sites-available -type f -name "*.conf"`; do

    . ${dwlDir}/virtualhost-env.sh;

    echo "> configure virtualhost for ${DWL_USER_DNS} with path ${DWL_USER_DNS_CONF}";

    echo "Update virtualhost for top domain + domain";

    sudo sed -i "s|# ServerAdmin|ServerAdmin ${DWL_HTTP_SERVERADMIN:-contact@$DWL_USER_DNS_SERVERNAME}|g" ${DWL_USER_DNS_CONF};

    sudo sed -i "s|# DocumentRoot|DocumentRoot ${DWL_HTTP_DOCUMENTROOT:-/var/www/html}|g" ${DWL_USER_DNS_CONF};

    echo "Handle virtualhost/ssl for domain";

    sudo sed -i "s|# ServerName|ServerName ${DWL_USER_DNS_SERVERNAME}|g" ${DWL_USER_DNS_CONF};

done;
