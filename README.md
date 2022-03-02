davask/local-lamp
==========

![docker_logo](https://raw.githubusercontent.com/davask/local-lamp/master/docker_139x115.png)![docker_davask_logo](https://raw.githubusercontent.com/davask/local-lamp/master/docker_davask_161x115.png)

[![Davask Network status](https://img.shields.io/badge/Davask%20Network%20Status-In%20progress-yellow)](https://hub.docker.com/r/davask/local-lamp/)

## DOCKER

[![Docker Version](https://img.shields.io/docker/v/davask/local-lamp?style=flat-square)](https://hub.docker.com/r/davask/local-lamp/)
[![Docker Size](https://img.shields.io/docker/image-size/davask/local-lamp?style=flat-square)](https://hub.docker.com/r/davask/local-lamp/)
[![Docker Pulls](https://img.shields.io/docker/pulls/davask/local-lamp?style=flat-square)](https://hub.docker.com/r/davask/local-lamp/)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/davask/local-lamp?style=flat-square)](https://hub.docker.com/r/davask/local-lamp/)

## GITHUB

[![Github Code Size](https://img.shields.io/github/languages/code-size/davask/local-lamp?style=flat-square)](https://github.com/davask/local-lamp.git)
[![Github Directory File Count](https://img.shields.io/github/directory-file-count/davask/local-lamp?style=flat-square)](https://github.com/davask/local-lamp.git)
[![Github Total Lines](https://img.shields.io/tokei/lines/github.com/davask/local-lamp?style=flat-square)](https://github.com/davask/local-lamp.git)


This Docker container implements a last generation LAMP stack with a set of popular PHP modules. Includes support for [Composer](https://getcomposer.org/), [Bower](http://bower.io/) and [npm](https://www.npmjs.com/) package managers and a Postfix service to allow sending emails through PHP [mail()](http://php.net/manual/en/function.mail.php) function.

If you dont need support for MySQL/MariaDB, or your app runs on PHP 5.4, maybe [davask/lap](https://hub.docker.com/r/davask/lap) suits your needs better.

Includes the following components:

 * Debian 10 LTS Buster base image.
 * Apache HTTP Server 2.4
 * MariaDB 10.0
 * Postfix 2.11
 * PHP 8
 * PHP modules
    * php
    * php-cgi
    * php-cli
    * php-common
    * php-curl
    * php-dev
    * php-fpm
    * php-gd
    * php-imagick
    * php-mbstring
    * php-mysql
    * php-opcache
    * php-readline
    * php-ssh2
    * php-xml
    * php-zip
    * php-intl
    * php-mcrypt
    * php-yaml
    * php-imap
 * Development tools
    * cron
    * curl
    * expect
    * dos2unix
    * ftp
    * nano
    * sed
    * tree
    * unzip
    * vim
    * wget
    * zip
	* git
	* composer
	* npm / nodejs (todo)
	* bower (todo)

Installation from [Docker registry hub](https://registry.hub.docker.com/r/davask/local-lamp/).
----

You can download the image using the following command:

```bash
docker pull davask/local-lamp
```

Environment variables
----

This image uses environment variables to allow the configuration of some parameteres at run time:

* Variable name: 
* Default value: 
* Accepted values: 
* Description: 

Exposed port and volumes
----

The image exposes ports `22`, `80`, `443` and `3306`, and exports four volumes:

* `/dwl/home/host`, containing the user host files
* `/var/lib/mysql`, where MariaDB data files are stored.
* `/etc/apache2/sites-available`, where Apache sites availables files are stored.
* `/etc/apache2/ssl`, where Apache ssl files are stored.
* `/etc/letsencrypt`, where Let's Encrypt files are stored.

Please, refer to https://docs.docker.com/storage/volumes for more information on using host volumes.

The user and group owner id for the DocumentRoot directory `/dwl/home/host` are both 33 (`uid=33(www-data) gid=33(www-data) groups=33(www-data)`).

The user and group owner id for the MariaDB directory `/var/log/mysql` are 105 and 108 repectively (`uid=105(mysql) gid=108(mysql) groups=108(mysql)`).

Use cases
----

#### Create a temporary container for testing purposes:

```
	docker run -i -t --rm davask/local-lamp bash
```

#### Create a temporary container to debug a web app:

```
	docker run --rm -p 8080:80 -v ./volumes/home/host:/dwl/home/host davask/local-lamp
```

#### Create a container linking to another [MySQL container](https://registry.hub.docker.com/_/mysql/):

```
	docker run -d --link my-mysql-container:mysql -p 8080:80 -v ./volumes/home/host:/dwl/home/host --name my-lamp-container davask/local-lamp
```

#### Get inside a running container and open a MariaDB console:

```
	docker exec -i -t my-lamp-container bash
	mysql -u root
```

#### Using docker-composer

```
    docker network create -d bridge --subnet 192.168.0.0/24 --gateway 192.168.0.1 dwlhost
    docker-compose up -d
    docker-compose down
    docker exec -ti <nom de l instance> bash
```

#### to get localhost mysql ip address

```
    ping host.docker.internal 
    add ip to docker /etc/hosts
```