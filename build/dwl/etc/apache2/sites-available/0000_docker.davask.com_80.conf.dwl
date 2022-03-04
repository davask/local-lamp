<VirtualHost *:80>

    # ServerAdmin

    # ServerName
    # ServerAlias

    # DocumentRoot

    <FilesMatch \.php$>
        SetHandler proxy:fcgi://localhost:9000
    </FilesMatch>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet