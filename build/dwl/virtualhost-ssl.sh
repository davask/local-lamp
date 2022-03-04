#!/bin/bash

for conf in `sudo find /etc/apache2/sites-available -type f -name "*.conf"`; do

    . ${dwlDir}/virtualhost-env.sh;

    if [ "$DWL_USER_DNS_PORT" == "443" ]; then

        cat << MIT
- Configure virtualhost-ssl 
  virtualhost ${DWL_USER_DNS}:${DWL_USER_DNS_PORT}
  For ${DWL_USER_DNS_DATA} 
  Container port : ${DWL_USER_DNS_PORT_CONTAINER}
  Key : ${APACHE_SSL_DIR}/${DWL_USER_DNS}/apache.key
  Cert : ${APACHE_SSL_DIR}/${DWL_USER_DNS}/apache.crt
MIT

        if sudo [ -f "${APACHE_SSL_DIR}/${DWL_USER_DNS}/apache.key" ]; then

            echo "- Update SSL Certificat public key for domain";
            sudo sed -i "s|# SSLCertificateFile|SSLCertificateFile ${APACHE_SSL_DIR}/${DWL_USER_DNS}/apache.crt|g" ${DWL_USER_DNS_CONF};

        fi
        if sudo [ -f "${APACHE_SSL_DIR}/${DWL_USER_DNS}/apache.crt" ]; then

            echo "- Update SSL Certificat private key for domain";
            sudo sed -i "s|# SSLCertificateKeyFile|SSLCertificateKeyFile ${APACHE_SSL_DIR}/${DWL_USER_DNS}/apache.key|g" ${DWL_USER_DNS_CONF};

        fi
    fi

done;
