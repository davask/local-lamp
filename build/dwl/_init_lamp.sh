#!/bin/bash

cat << EOB
    
**********************************************
*                                            *
*    Docker image: davask/local-lamp         *
*    https://github.com/davask/local-lamp    *
*                                            *
**********************************************

SERVER SETTINGS
---------------
· PHP date timezone [DATE_TIMEZONE]: $DWL_PHP_DATETIMEZONE

-------------
START OF INIT
-------------

EOB

dwlDir="/dwl";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/envvar.sh
. ${dwlDir}/user.sh
. ${dwlDir}/ssh.sh
echo ">> OS BASE INITIALIZED";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/permission.sh
echo ">> PERMISSION ASSIGNED";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/activateconf.sh
echo ">> DWL CONF ACTIVATED";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/virtualhost.sh
echo ">> VIRTUALHOST GENERIC UPDATE";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/openssl.sh
echo ">> OPENSSL INITIALIZED";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/certbot.sh
echo ">> CERTBOT INITIALIZED";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/virtualhost-ssl.sh
echo ">> SSL INITIALIZED";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/virtualhost-tsl.sh
echo ">> TSL INITIALIZED";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/php.sh
echo ">> PHP INITIALIZED";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/mariadb.sh
echo ">> MARIADB INITIALIZED";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/apache2.sh
echo ">> APACHE2 INITIALIZED";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/php-fpm.sh
echo ">> PHP-FPM INITIALIZED";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
# . ${dwlDir}/get-wordpress.sh
. ${dwlDir}/fix-wordpress-permissions.sh
echo ">> WORDPRESS INITIALIZED";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/custom.sh
echo ">> CUSTOM INITIALIZED";
echo "";

if [ "`dpkg --get-selections | awk '{print $1}' | grep sendmail$ | wc -l`" == "1" ]; then
  echo ">>>>>>>>>>>>>>>>>>>>>>";
  sudo service sendmail start;
  echo ">> SENDMAIL INITIALIZED";
  echo "";
fi

cat << EOB
    
-----------
END OF INIT
-----------

EOB

tail -f /dev/null;