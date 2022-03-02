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
echo ">> Os Base initialized";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/permission.sh
echo ">> Permission assigned";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/activateconf.sh
echo ">> Dwl conf activated";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/virtualhost.sh
echo ">> Virtualhost generic update";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/openssl.sh
echo ">> Openssl initialized";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/certbot.sh
echo ">> Certbot initialized";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/virtualhost-ssl.sh
echo ">> SSL initialized";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/virtualhost-tsl.sh
echo ">> TSL initialized";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/php.sh
echo ">> Php initialized";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/mariadb.sh
echo ">> MariaDB initialized";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/apache2.sh
echo ">> Apache2 initialized";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/php-fpm.sh
echo ">> PHP-FPM initialized";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
# . ${dwlDir}/get-wordpress.sh
. ${dwlDir}/fix-wordpress-permissions.sh
echo ">> Wordpress initialized";
echo "";

echo ">>>>>>>>>>>>>>>>>>>>>>";
. ${dwlDir}/custom.sh
echo ">> custom initialized";
echo "";

if [ "`dpkg --get-selections | awk '{print $1}' | grep sendmail$ | wc -l`" == "1" ]; then
  echo ">>>>>>>>>>>>>>>>>>>>>>";
  sudo service sendmail start;
  echo ">> Sendmail initialized";
  echo "";
fi

cat << EOB
    
-----------
END OF INIT
-----------

EOB

tail -f /dev/null;