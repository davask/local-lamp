FROM debian:10

LABEL org.opencontainers.image.authors="contact@davask.com" \
Description="Cutting-edge LAMP stack, based on Debian 10 LTS. Includes .htaccess support and preconfigured PHP8 features, including composer." \
License="Apache License 2.0" \
Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 [HOST WWW SSL PORT NUMBER]:443 -p [HOST DB PORT NUMBER]:3306 -v [HOST WWW DOCUMENT ROOT]:/var/www/html -v [HOST DB DOCUMENT ROOT]:/var/lib/mysql davask/lamp" \
Version="1.0"

LABEL dwl.server.os="debian 10" \
dwl.server.http="apache 2.4" \
dwl.server.https="openssl" \
dwl.server.certificat="letsencrypt" \
dwl.app.language="php8.0" \
dwl.app.cms="WordPress 5.9"

# declare locales env
ENV DWL_LOCAL_LANG ${DWL_LOCAL_LANG}
ENV DWL_LOCAL ${DWL_LOCAL}
ENV LANG ${DWL_LOCAL_LANG}
ENV LANGUAGE ${DWL_LOCAL_LANG}

# declare main user
ENV DWL_SSH_ACCESS ${CONF_SSH_ACCESS}
ENV DWL_USER_ID ${CONF_USER_ID}
ENV DWL_USER_NAME ${CONF_USER_NAME}
ENV DWL_USER_PASSWD ${CONF_USER_PASSWD}

# Apache conf
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_SSL_DIR /etc/apache2/ssl

# create apache2 ssl directories
RUN mkdir -p ${APACHE_SSL_DIR}
RUN chmod 700 ${APACHE_SSL_DIR}

ENV DWL_HTTP_SERVERADMIN admin@davask.com
ENV DWL_HTTP_DOCUMENTROOT /var/www/html
ENV DWL_HTTP_SHIELD false

# declare openssl
ENV DWL_SSLKEY_C "EU"
ENV DWL_SSLKEY_ST "France"
ENV DWL_SSLKEY_L "Vannes"
ENV DWL_SSLKEY_O "davask - docker container"
ENV DWL_SSLKEY_CN "davask.com"

# declare letsencrypt
ENV DWL_CERTBOT_EMAIL admin@davask.com
ENV DWL_CERTBOT_DEBUG false

# declare php
ENV DWL_PHP_VERSION 8.0
ENV DWL_PHP_DATETIMEZONE Europe/Paris

USER root

# Update packages
RUN apt-get update
RUN apt-get upgrade -y

# Update locales
RUN apt-get install -y apt-utils locales
RUN sed -i 's|#  UTF-8| UTF-8|g' /etc/locale.gen && \
locale-gen ""

RUN apt-get install -y \
acl \
apt-transport-https \
apt-utils \
autoconf \
automake \
bc \
binutils \
build-essential \
ca-certificates \
cron \
curl \
expect \
dos2unix \
ftp \
gcc \
htop \
libc6-dev \
libtool \
lsb-release \
make \
nano \
openssh-server \
openssl \
pkg-config \
sed \
software-properties-common \
sudo \
tidy \
tree \
unzip \
vim \
wget \
zip

RUN apt-get install -y \
git git-extras

RUN apt-get update && \
apt-get install -y apache2 apache2-utils

# Configure PHP
# RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php${DWL_PHP_VERSION}.list
RUN apt-key adv --fetch-keys 'https://packages.sury.org/php/apt.gpg'
RUN apt-get update

RUN apt-get install -y \
php${DWL_PHP_VERSION} \
php${DWL_PHP_VERSION}-cgi \
php${DWL_PHP_VERSION}-cli \
php${DWL_PHP_VERSION}-common \
php${DWL_PHP_VERSION}-curl \
php${DWL_PHP_VERSION}-dev \
php${DWL_PHP_VERSION}-fpm \
php${DWL_PHP_VERSION}-gd \
php${DWL_PHP_VERSION}-imagick \
php${DWL_PHP_VERSION}-mbstring \
php${DWL_PHP_VERSION}-mysql \
php${DWL_PHP_VERSION}-opcache \
php${DWL_PHP_VERSION}-readline \
php${DWL_PHP_VERSION}-ssh2 \
php${DWL_PHP_VERSION}-xml \
php${DWL_PHP_VERSION}-zip \
php${DWL_PHP_VERSION}-intl \
php${DWL_PHP_VERSION}-mcrypt \
php${DWL_PHP_VERSION}-yaml \
php${DWL_PHP_VERSION}-imap

RUN apt-get install -y \
perl \
libmcrypt-dev \
composer

RUN apt-get install -y \
sendmail-bin \
sendmail

# install certbot
RUN wget https://dl.eff.org/certbot-auto; \
mv certbot-auto /usr/sbin; \
chmod a+x /usr/sbin/certbot-auto; \
certbot-auto --noninteractive --os-packages-only; \
mkdir -p /etc/lestencrypt/live

# clean install
RUN apt-get upgrade -y
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# create admin user
RUN useradd -r \
--comment "dwl ssh user" \
--no-create-home \
--shell /bin/bash \
--uid 999 \
--no-user-group \
admin;
RUN echo "admin ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/admin
RUN chmod 0440 /etc/sudoers.d/admin

# static configuration
COPY ./build/etc/ssh/sshd_config \
./build/etc/ssh/sshd_config.factory-defaults \
/etc/ssh/

# Configure apache
COPY ./build/etc/apache2/apache2.conf /dwl/etc/apache2/apache2.conf
RUN cp -rdf /dwl/etc/apache2/apache2.conf /etc/apache2/apache2.conf

RUN a2dissite 000-default && rm -f /etc/apache2/sites-available/000-default.conf
RUN a2dissite default-ssl && rm -f /etc/apache2/sites-available/default-ssl.conf
COPY ./build/etc/apache2/mods-available/ssl.conf /etc/apache2/mods-available/ssl.conf

# Configure apache virtualhost.conf
COPY ./build/etc/apache2/sites-available /dwl/etc/apache2/

# Configure website htpasswd
COPY ./build/shield/.htaccess /dwl/shield/var/www/html/.htaccess

# Configure default website
COPY ./build/var/www/html /dwl/var/www/html
RUN rm -rdf /var/www/html && cp -rdf /dwl/var/www/html /var/www

RUN a2enmod \
cgi \
deflate \
env \
expires \
ext_filter \
filter \
headers \
mime \
remoteip \
rewrite \
setenvif \
ssl

RUN a2enconf \
php${DWL_PHP_VERSION}-fpm

RUN update-alternatives --set php /usr/bin/php${DWL_PHP_VERSION}
RUN update-alternatives --set phar /usr/bin/phar${DWL_PHP_VERSION}
RUN update-alternatives --set phar.phar /usr/bin/phar.phar${DWL_PHP_VERSION}
RUN update-alternatives --set phpize /usr/bin/phpize${DWL_PHP_VERSION}
RUN update-alternatives --set php-config /usr/bin/php-config${DWL_PHP_VERSION}

# RUN apt-get install -y mariadb-server
# RUN apt-get install -y postfix

# RUN apt-get install -y \
#     nodejs npm
# RUN npm install -g bower grunt-cli gulp

# ENV LOG_STDOUT **Boolean**
# ENV LOG_STDERR **Boolean**
# ENV LOG_LEVEL warn
# ENV ALLOW_OVERRIDE All
# ENV DATE_TIMEZONE UTC
# ENV TERM dumb

COPY ./build/dwl /dwl
RUN /usr/bin/dos2unix /dwl/*

RUN chmod +x /dwl/_init_lamp.sh
RUN chown root:sudo -R /dwl

# VOLUME /var/www/html
# VOLUME /var/log/httpd
# VOLUME /var/lib/mysql
# VOLUME /var/log/mysql
# VOLUME /etc/apache2

EXPOSE 22
EXPOSE 80
EXPOSE 443
# EXPOSE 3306

HEALTHCHECK --interval=5m --timeout=3s \
CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/dwl/_init_lamp.sh"]
WORKDIR /var/www
USER admin

