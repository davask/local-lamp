#!/bin/bash

if sudo [ ! -d /dwl/live ]; then
    sudo mkdir -p /dwl/live;
fi
if sudo [ -f /dwl/live/backup.list ]; then
    sudo rm /dwl/live/backup.list;
fi
sudo touch /dwl/live/backup.list;

if sudo [ ! -d /dwl/live/conf ]; then
    sudo mkdir -p /dwl/live/conf;
fi
sudo rm -rdf /dwl/live/conf/*;

if sudo [ ! -d /dwl/live/backup ]; then
    sudo mkdir -p /dwl/live/backup;
fi

for conf in `sudo find /dwl/live/backup -type f -name "*\.conf\.dwl"`; do

    DWL_USER_DNS_DATA=`echo ${conf} | awk -F '[/]' '{print $5}' | sed "s|\.conf\.dwl||g"`;

    if sudo [ ! -f "/etc/apache2/sites-available/${DWL_USER_DNS_DATA}.conf.dwl" ]; then

        sudo echo ${DWL_USER_DNS_DATA} | sudo tee -a /dwl/live/backup.list;

    else

        sudo rm -rdf ${conf};

    fi

done;

for conf in `sudo find /etc/apache2/sites-available -type f -name "*\.conf\.dwl"`; do

    DWL_USER_DNS_DATA=`echo ${conf} | awk -F '[/]' '{print $5}' | sed "s|\.conf\.dwl||g"`;

    sudo echo ${DWL_USER_DNS_DATA} | sudo tee -a /dwl/live/backup.list;

    sudo mv -f ${conf} /dwl/live/backup;

done;

for DWL_USER_DNS_DATA in `cat /dwl/live/backup.list`; do

    if sudo [ ! -f "/etc/apache2/sites-available/${DWL_USER_DNS_DATA}.conf" ]; then
        sudo cp -rdf /dwl/live/backup/${DWL_USER_DNS_DATA}.conf.dwl /etc/apache2/sites-available/${DWL_USER_DNS_DATA}.conf;
    fi

done;

for conf in `sudo find /dwl/etc/apache2/sites-available -type f -name "*\.conf"`; do

    sudo cp -rdf ${conf} /dwl/live/conf;

done;

for conf in `sudo find /dwl/live/conf -type f -name "*\.conf"`; do

    DWL_USER_DNS_DATA=`echo ${conf} | awk -F '[/]' '{print $5}' | sed "s|\.conf||g"`;

    if sudo [ ! -f "/etc/apache2/sites-available/${DWL_USER_DNS_DATA}.conf" ]; then
        echo "DNS Activated: ${DWL_USER_DNS_DATA}.conf";
        sudo cp -rdf ${conf} /etc/apache2/sites-available/${DWL_USER_DNS_DATA}.conf;
    else
        echo "DNS Unchanged: ${DWL_USER_DNS_DATA}.conf";
    fi

done;