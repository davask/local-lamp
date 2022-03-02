FROM debian:10

LABEL org.opencontainers.image.authors="contact@davask.com"
LABEL Description="Cutting-edge LAMP stack, based on Debian 10 LTS. Includes .htaccess support and preconfigured PHP8 features, including composer." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 [HOST WWW SSL PORT NUMBER]:443 -p [HOST DB PORT NUMBER]:3306 -v [HOST WWW DOCUMENT ROOT]:/var/www/html -v [HOST DB DOCUMENT ROOT]:/var/lib/mysql davask/lamp" \
	Version="1.0"

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
# declare main user
ENV DWL_USER_ID ${CONF_USER_ID}
ENV DWL_USER_NAME ${CONF_USER_NAME}
ENV DWL_USER_PASSWD ${CONF_USER_PASSWD}
# declare main user
ENV DWL_SSH_ACCESS ${CONF_SSH_ACCESS}

RUN apt install -y \
acl \
apt-transport-https \
build-essential \
ca-certificates \
lsb-release \
nano \
openssh-server \
openssl \
software-properties-common \
sudo \
unzip \
wget \
zip

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

COPY ./build/dwl/custom.sh \
./build/dwl/envvar.sh \
./build/dwl/permission.sh \
./build/dwl/ssh.sh \
./build/dwl/user.sh \
/dwl/

COPY ./build/dwl/_init_lamp.sh /usr/sbin/

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
#     git git-extras
# RUN apt-get install -y \
#     nano vim \
#     composer \
#     bc autoconf automake gcc libc6-dev libtool make pkg-config \
#     tree sed curl ftp tidy expect
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

# RUN a2enmod deflate env expires filter ext_filter headers mime rewrite setenvif 
RUN chmod +x /usr/sbin/_init_lamp.sh
RUN chown root:sudo -R /dwl
# RUN chown -R www-data:www-data /var/www/html

# VOLUME /var/www/html
# VOLUME /var/log/httpd
# VOLUME /var/lib/mysql
# VOLUME /var/log/mysql
# VOLUME /etc/apache2

EXPOSE 22
# EXPOSE 80
# EXPOSE 443
# EXPOSE 3306

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/usr/sbin/_init_lamp.sh"]
WORKDIR /home/admin
USER admin

