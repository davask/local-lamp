#!/bin/bash
#
# This script configures WordPress file permissions based on recommendations
# from http://codex.wordpress.org/Hardening_WordPress#File_permissions
#
# Author: Michael Conigliaro <mike [at] conigliaro [dot] org>
#

if [ "${DWL_USER_NAME}" == "" ]; then
    export DWL_USER_NAME=${DWL_USER_NAME:-`whoami`};
    echo "Set DWL_USER_NAME as ${DWL_USER_NAME}";
fi

# allow wordpress to manage wp-config.php (but prevent world access)
HTTPDUSER=`ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`;

# reset to safe defaults
sudo find /home/${DWL_USER_NAME}/files -exec chown ${DWL_USER_NAME}:${HTTPDUSER} {} \;
sudo find /home/${DWL_USER_NAME}/files -type d -exec chmod 775 {} \;
sudo find /home/${DWL_USER_NAME}/files -type f -exec chmod 664 {} \;

if [ -f /home/${DWL_USER_NAME}/files/wp-config.php ]; then
    sudo chmod 660 /home/${DWL_USER_NAME}/files/wp-config.php
fi