#!/bin/bash

for conf in `sudo find /etc/apache2/sites-available -type f -name "*.conf"`; do

    . ${dwlDir}/virtualhost-env.sh;

    if [ "$DWL_USER_DNS_PORT" == "80" ] || [ "$DWL_USER_DNS_PORT" == "443" ]; then

        echo "> configure virtualhost for ${DWL_USER_DNS} with path ${DWL_USER_DNS_DATA}";

        echo "- Update ServerAdmin, DocumentRoot, ServerName";

        sudo sed -i "s|# ServerAdmin|ServerAdmin ${DWL_HTTP_SERVERADMIN:-contact@$DWL_USER_DNS_SERVERNAME}|g" ${DWL_USER_DNS_CONF};
        sudo sed -i "s|# DocumentRoot|DocumentRoot ${DWL_HTTP_DOCUMENTROOT:-/var/www/html}|g" ${DWL_USER_DNS_CONF};
        sudo sed -i "s|# ServerName|ServerName ${DWL_USER_DNS_SERVERNAME}|g" ${DWL_USER_DNS_CONF};

    fi

done;
