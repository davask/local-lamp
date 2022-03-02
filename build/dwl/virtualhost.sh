#!/bin/bash

for conf in `sudo find /etc/apache2/sites-available -type f -name "*.conf"`; do

    DWL_USER_DNS_CONF="${conf}";

    DWL_USER_DNS_DATA="`echo ${DWL_USER_DNS_CONF} | awk -F '[/]' '{print $5}' | sed "s|\.conf||g"`";

    if [[ ! ("${DWL_USER_DNS_DATA}" =~ ^[0-9X]+_[a-z.-]+_[0-9]+) ]]; then
        continue;
    fi

    DWL_USER_DNS="`echo ${DWL_USER_DNS_DATA} | awk -F '[_]' '{print $2}'`";
    DWL_USER_DNS_PORT="`echo ${DWL_USER_DNS_DATA} | awk -F '[_]' '{print $3}'`";
    DWL_USER_DNS_PORT_CONTAINER="`echo ${DWL_USER_DNS_DATA} | awk -F '[_]' '{print $1}'`";
    DWL_USER_DNS_SERVERNAME="`echo \"${DWL_USER_DNS}\" | awk -F '[.]' '{print $(NF-1)\".\"$NF}'`";

    echo "> configure virtualhost for ${DWL_USER_DNS} with path ${DWL_USER_DNS_CONF}";

    echo "Update virtualhost for top domain + domain";

    sudo sed -i "s|# ServerAdmin|ServerAdmin ${DWL_HTTP_SERVERADMIN:-contact@$DWL_USER_DNS_SERVERNAME}|g" ${DWL_USER_DNS_CONF};

    sudo sed -i "s|# DocumentRoot|DocumentRoot ${DWL_HTTP_DOCUMENTROOT:-/var/www/html}|g" ${DWL_USER_DNS_CONF};

    echo "Handle virtualhost/ssl for domain";

    sudo sed -i "s|# ServerName|ServerName ${DWL_USER_DNS_SERVERNAME}|g" ${DWL_USER_DNS_CONF};

done;
