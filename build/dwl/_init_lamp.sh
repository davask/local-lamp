#!/bin/bash

cat << EOB
    
    **********************************************
    *                                            *
    *    Docker image: davask/local-lamp               *
    *    https://github.com/davask/local-lamp   *
    *                                            *
    **********************************************

    SERVER SETTINGS
    ---------------
    · PHP date timezone [DATE_TIMEZONE]: $DWL_PHP_DATETIMEZONE

EOB

dwlDir="/dwl";

. ${dwlDir}/envvar.sh
. ${dwlDir}/user.sh
. ${dwlDir}/ssh.sh
echo ">> Os initialized";
echo ">> Base initialized";

. ${dwlDir}/permission.sh
echo ">> Permission assigned";

. ${dwlDir}/activateconf.sh
echo ">> Dwl conf activated";

. ${dwlDir}/virtualhost.sh
echo ">> Virtualhost generic update";

. ${dwlDir}/openssl.sh
echo ">> Openssl initialized";

. ${dwlDir}/certbot.sh
echo ">> Certbot initialized";

. ${dwlDir}/virtualhost-ssl.sh
echo ">> SSL initialized";

. ${dwlDir}/virtualhost-tsl.sh
echo ">> TSL initialized";

. ${dwlDir}/php.sh
echo ">> Php initialized";

. ${dwlDir}/mariadb.sh
echo ">> MariaDB initialized";

. ${dwlDir}/apache2.sh
echo ">> Apache2 initialized";

. ${dwlDir}/php-fpm.sh
echo ">> PHP-FPM initialized";

# . ${dwlDir}/get-wordpress.sh
. ${dwlDir}/fix-wordpress-permissions.sh
echo ">> Wordpress initialized";

. ${dwlDir}/custom.sh
echo ">> custom initialized";

if [ "`dpkg --get-selections | awk '{print $1}' | grep sendmail$ | wc -l`" == "1" ]; then
  sudo service sendmail start;
  echo ">> Sendmail initialized";
fi

tail -f /dev/null;