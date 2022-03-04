#!/bin/bash

if sudo [ -d /home/${DWL_USER_NAME}/files ]; then
    sudo rm -rdf ${DWL_HTTP_DOCUMENTROOT:-/var/www/html};
    sudo ln -sf /home/${DWL_USER_NAME}/files ${DWL_HTTP_DOCUMENTROOT:-/var/www/html};
else
    if [ ! -d /home/${DWL_USER_NAME}/files ]; then
        sudo mkdir -p /home/${DWL_USER_NAME}/files;
        sudo cp /dwl/home/host/files/index.html /var/www/html/index.html
    fi
    sudo rm -rdf ${DWL_HTTP_DOCUMENTROOT:-/var/www/html};
    sudo ln -sf /home/${DWL_USER_NAME}/files ${DWL_HTTP_DOCUMENTROOT:-/var/www/html};
fi

if [ "$DWL_SHIELD_HTTP" == "true" ]; then
    DWL_APACHE2_SHIELD="/dwl/shield/htaccess";
    echo "> Generate htpasswd with htpasswd -b -c '$DWL_APACHE2_SHIELD/.htpasswd $DWL_USER_NAME $DWL_USER_PASSWD'";
    if sudo [ ! -d $DWL_APACHE2_SHIELD ]; then
        sudo mkdir -p $DWL_APACHE2_SHIELD;
    fi
    htpasswd -b -c $DWL_APACHE2_SHIELD/.htpasswd $DWL_USER_NAME $DWL_USER_PASSWD;
    if sudo [ ! -f /etc/apache2/sites-available/0000_override.rules_0.conf ]; then
        sudo cp /dwl/etc/apache2/sites-available/0000_override.rules_0.conf /etc/apache2/sites-available
    fi
    if [ ! -f /var/www/html/.htaccess ]; then
        sudo cp /dwl/shield/htaccess/.htaccess /var/www/html/.htaccess
    fi
fi

for conf in `sudo find /etc/apache2/sites-available -type f -name "*.conf"`; do

    DWL_USER_DNS_CONF=${conf};

    DWL_USER_DNS_DATA=`echo ${DWL_USER_DNS_CONF} | awk -F '[/]' '{print $5}' | sed "s|\.conf||g"`;

    echo "a2ensite ${DWL_USER_DNS_DATA}";
    sudo a2ensite ${DWL_USER_DNS_DATA};
    echo "";

done;

echo "Start apache2"

if [ "`sudo service apache2 status | grep '[ ok ] apache2 is running.' | wc -l`" == "0" ]; then
    echo "Start APACHE2";
    sudo service apache2 start;
    echo "";
fi

echo "Reload APACHE2";
sudo service apache2 reload;
echo "";
