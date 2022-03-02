FROM debian:10

LABEL org.opencontainers.image.authors="contact@davask.com"
LABEL Description="Cutting-edge LAMP stack, based on Debian 10 LTS. Includes .htaccess support and preconfigured PHP8 features, including composer." \
License="Apache License 2.0" \
Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 [HOST WWW SSL PORT NUMBER]:443 -p [HOST DB PORT NUMBER]:3306 -v [HOST WWW DOCUMENT ROOT]:/var/www/html -v [HOST DB DOCUMENT ROOT]:/var/lib/mysql davask/lamp" \
Version="1.0"
LABEL dwl.server.os="debian 10" \
dwl.server.http="apache 2.4" \
dwl.server.https="openssl" \
dwl.server.certificat="letsencrypt"

USER root

# Update packages
RUN apt-get update
RUN apt-get upgrade -y

# Update locales
RUN apt-get install -y apt-utils locales
RUN sed -i 's|#  UTF-8| UTF-8|g' /etc/locale.gen && \
locale-gen ""

# declare locales env
ENV LANG ${CONF_LOCAL}
ENV LANGUAGE ${CONF_LOCAL_LANG}

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

# declare main user
ENV DWL_USER_ID ${CONF_USER_ID}
ENV DWL_USER_NAME ${CONF_USER_NAME}
ENV DWL_USER_PASSWD ${CONF_USER_PASSWD}
# declare main user
ENV DWL_SSH_ACCESS ${CONF_SSH_ACCESS}

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

# install certbot
RUN wget https://dl.eff.org/certbot-auto; \
mv certbot-auto /usr/sbin; \
chmod a+x /usr/sbin/certbot-auto; \
certbot-auto --noninteractive --os-packages-only; \
mkdir -p /etc/lestencrypt/live

RUN apt-get install -y \
perl

RUN apt-get install -y \
composer

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

# Configure apache virtualhost.conf
COPY ./build/etc/apache2/sites-available /dwl/etc/apache2/

# Configure website htpasswd
COPY ./build/shield/.htaccess /dwl/shield/var/www/html/.htaccess

# Configure default website
COPY ./build/var/www/html /dwl/var/www/html
RUN rm -rdf /var/www/html && cp -rdf /dwl/var/www/html /var/www

# RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list
# RUN apt-key adv --fetch-keys 'https://packages.sury.org/php/apt.gpg'
# RUN apt-get update

# RUN apt-get install -y \
# 	php8.1 \
# 	php8.1-cgi \
# 	php8.1-cli \
# 	php8.1-common \
# 	php8.1-curl \
# 	php8.1-dev \
# 	php8.1-fpm \
# 	php8.1-gd \
# 	php8.1-imagick \
# 	php8.1-mbstring \
# 	php8.1-mysql \
# 	php8.1-opcache \
# 	php8.1-readline \
# 	php8.1-ssh2 \
# 	php8.1-xml \
# 	php8.1-zip \
# 	php8.1-intl \
# 	php8.1-mcrypt \
# 	php8.1-yaml \
# 	php8.1-imap
    
# RUN apt-get install -y apache2
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

# COPY index.php /var/www/html/

COPY ./build/dwl/activateconf.sh \
./build/dwl/apache2.sh \
./build/dwl/custom.sh \
./build/dwl/envvar.sh \
./build/dwl/openssl.sh \
./build/dwl/permission.sh \
./build/dwl/ssh.sh \
./build/dwl/user.sh \
./build/dwl/virtualhost-env.sh \
./build/dwl/virtualhost-ssh.sh \
./build/dwl/virtualhost.sh \
/dwl/

COPY ./build/dwl/_init_lamp.sh /usr/sbin/

RUN chmod +x /usr/sbin/_init_lamp.sh
RUN chown root:sudo -R /dwl
# RUN chown -R www-data:www-data /var/www/html

# VOLUME /var/www/html
# VOLUME /var/log/httpd
# VOLUME /var/lib/mysql
# VOLUME /var/log/mysql
# VOLUME /etc/apache2

EXPOSE 22
EXPOSE 80
# EXPOSE 443
# EXPOSE 3306

HEALTHCHECK --interval=5m --timeout=3s \
CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/usr/sbin/_init_lamp.sh"]
WORKDIR /var/www
USER admin

