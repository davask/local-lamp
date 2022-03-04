#!/bin/bash

for conf in `sudo find /etc/apache2/sites-available -type f -name "*.conf"`; do

    . ${dwlDir}/virtualhost-env.sh;

    if [ "${DWL_USER_DNS_PORT}" == "443" ]; then

        cat << MIT
- Configure openssl 
  virtualhost ${DWL_USER_DNS}:${DWL_USER_DNS_PORT}
  For ${DWL_USER_DNS_DATA} 
  Container port : ${DWL_USER_DNS_PORT_CONTAINER}
  Key : ${APACHE_SSL_DIR}/${DWL_USER_DNS}/apache.key
  Cert : ${APACHE_SSL_DIR}/${DWL_USER_DNS}/apache.crt
MIT

        if sudo [ ! -d "${APACHE_SSL_DIR}/${DWL_USER_DNS}" ]; then
            sudo mkdir -p "${APACHE_SSL_DIR}/${DWL_USER_DNS}";
            sudo chmod 700 "${APACHE_SSL_DIR}/${DWL_USER_DNS}";
        fi

        if [ "`sudo find "${APACHE_SSL_DIR}/${DWL_USER_DNS}" -type f | wc -l`" == "0" ]; then

            echo "- Generate ssl for ${DWL_USER_DNS}";

            sudo openssl req \
                -newkey rsa:2048 -nodes -keyout "${APACHE_SSL_DIR}/${DWL_USER_DNS}"/apache.key \
                -x509 -days 90 -out "${APACHE_SSL_DIR}/${DWL_USER_DNS}"/apache.crt \
                -subj "/C=${DWL_SSLKEY_C}/ST=${DWL_SSLKEY_ST}/L=${DWL_SSLKEY_L}/O=${DWL_SSLKEY_O}/CN=${DWL_SSLKEY_CN}";

            echo "";

        fi

    fi

done;