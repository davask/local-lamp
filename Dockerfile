FROM debian:10

LABEL org.opencontainers.image.authors="contact@davask.com" \
Description="Cutting-edge LAMP stack, based on Debian 10 LTS. Includes .htaccess support and preconfigured PHP8 features, including composer." \
License="Apache License 2.0" \
Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 [HOST WWW SSL PORT NUMBER]:443 -p [HOST DB PORT NUMBER]:3306 -v [HOST WWW DOCUMENT ROOT]:/var/www/html  davask/lamp" \
Version="1.0"

LABEL dwl.server.os="debian 10" \
dwl.server.http="apache 2.4" \
dwl.server.https="openssl" \
dwl.server.certificat="letsencrypt" \
dwl.app.language="php8.0" \
dwl.app.cms="WordPress 5.9"

USER root

# declare locales env
ENV DWL_LOCAL_LANG ${DWL_LOCAL_LANG:-en_US.UTF-8}
ENV DWL_LOCAL ${DWL_LOCAL:-en_US.UTF-8}

# declare main user
ENV DWL_SSH_ACCESS ${DWL_SSH_ACCESS:-false}
ENV DWL_USER_ID ${DWL_USER_ID:-1000}
ENV DWL_USER_NAME ${DWL_USER_NAME:-dwl}
ENV DWL_USER_PASSWD ${DWL_USER_PASSWD:-dwl}

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

# declare php
ENV DWL_PHP_VERSION 8.0
ENV DWL_PHP_DATETIMEZONE Europe/Paris

# Update packages
RUN apt-get update
RUN apt-get upgrade -y

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
locales \
lsb-release \
make \
nano \
openssh-server \
openssl \
perl \
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

# Update locales
RUN sed -i 's|# '${DWL_LOCAL:-en_US.UTF-8}'| '${DWL_LOCAL:-en_US.UTF-8}'|g' /etc/locale.gen && \
locale-gen
ENV LANG ${DWL_LOCAL:-en_US.UTF-8}
ENV LANGUAGE ${DWL_LOCAL_LANG:-en_US:en}
ENV LC_ALL ${DWL_LOCAL:-en_US.UTF-8}

RUN apt-get install -y \
git git-extras

RUN apt-get install -y \
apache2 \
apache2-utils

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
libmcrypt-dev \
composer

RUN apt-get install -y \
sendmail-bin \
sendmail

RUN echo 'include(`/etc/mail/tls/starttls.m4'\'')dnl' | tee -a /etc/mail/sendmail.mc; \
echo 'include(`/etc/mail/tls/starttls.m4'\'')dnl' | tee -a /etc/mail/submit.mc; \
sendmailconfig

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

# copy conf files
COPY ./build/dwl /dwl
RUN /usr/bin/dos2unix /dwl/*

# static configuration
RUN cp -rdf /dwl/etc/ssh/sshd_config /etc/ssh/sshd_config
RUN cp -rdf /dwl/etc/ssh/sshd_config.factory-defaults /etc/ssh/sshd_config.factory-defaults

# Configure apache
RUN cp -rdf /dwl/etc/apache2/apache2.conf /etc/apache2/apache2.conf
RUN cp -rdf /dwl/etc/apache2/mods-available/ssl.conf /etc/apache2/mods-available/ssl.conf

# Configure apache virtualhost.conf
RUN find /etc/apache2/sites-enabled/ -type l -exec rm -i "{}" \;
RUN rm -rf /etc/apache2/sites-available
RUN cp -rdf /dwl/etc/apache2/sites-available /etc/apache2/sites-available

# Configure default website
RUN rm -rdf /var/www/html && cp -rdf /dwl/home/host/files /var/www/html

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

RUN update-alternatives --set php /usr/bin/php${DWL_PHP_VERSION} \
&& update-alternatives --set phar /usr/bin/phar${DWL_PHP_VERSION} \
&& update-alternatives --set phar.phar /usr/bin/phar.phar${DWL_PHP_VERSION} \
&& update-alternatives --set phpize /usr/bin/phpize${DWL_PHP_VERSION} \
&& update-alternatives --set php-config /usr/bin/php-config${DWL_PHP_VERSION}

# RUN apt-get install -y \
#     nodejs npm
# RUN npm install -g bower grunt-cli gulp

RUN chmod +x /dwl/_init_lamp.sh
RUN printenv | tee -a /dwl/log/env/$(whoami).env
RUN chown root:sudo -R /dwl

VOLUME /dwl/home/host
VOLUME /etc/apache2/sites-available
VOLUME /etc/apache2/ssl
VOLUME /etc/letsencrypt

EXPOSE 22
EXPOSE 80
EXPOSE 443
EXPOSE 3306

HEALTHCHECK --interval=5m --timeout=3s \
CMD curl -f http://localhost/ || exit 1

USER admin
RUN printenv | sudo tee -a /dwl/log/env/$(whoami).env

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/dwl/_init_lamp.sh"]
WORKDIR /var/www
