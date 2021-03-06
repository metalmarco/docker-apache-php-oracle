# Supported tags and respective `Dockerfile` links

-   [`latest`] Centos 7 + Apache 2.4 + PHP 7.2
-   [`php72_remi`] Centos 7 + Apache 2.4 + PHP 7.2
-   [`php56_webtatic`] Centos 7 + Apache 2.4 + PHP 5.6

# Info
Release based on official [centos] (https://hub.docker.com/_/centos/) images with addition of:

- Apache
- PHP
- PDO
- OCI8
- SQLSRV
- MySQL
- GD


# Build


	docker build -t "metalmarco/docker-apache-php-oracle-ldap:latest" .

# Run

	docker run -dit --privileged \
 	--name docker-apache-php-oracle-ldap \
 	-p 8080:8080 \
 	 -v /local_repo:/var/www/html \
	 --restart unless-stopped \
	 metalmarco/docker-apache-php-oracle-ldap


# Usage
This docker requires 3 Environment Variables:

	- GIT_SOURCE_REPO: html/php project source repo
	- LOCAL_REPO: the name of the subfolder in the /var/www/html folder in which to clone the repo
	- ENVIRONMENT: optional ENV variable that can be used by the PHP application

