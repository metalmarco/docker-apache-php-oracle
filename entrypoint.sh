#!/bin/bash

#Start syslog
#rsyslogd

#Clone source
#cd /var/www/html && [ -z "$GIT_SOURCE_REPO" ] || git clone -c http.sslVerify=false $GIT_SOURCE_REPO
mkdir -p /run/httpd
chown root:apache /run/httpd
chmod 0710 /run/httpd

#cd /var/www/html && [ -z "$GIT_SOURCE_REPO" ] || if [ -d $LOCAL_REPO/.git ]; then pushd $LOCAL_REPO; git pull; popd; else git clone -c http.sslVerify=false $GIT_SOURCE_REPO; fi
cd /var/www/html && [ -z "$GIT_SOURCE_REPO" ] || if [ -d $LOCAL_REPO/.git ]; then git pull; else git clone -c http.sslVerify=false $GIT_SOURCE_REPO .; fi


#GET/SET Environment
[ -z "$ENVIRONMENT" ] && ENVIRONMENT=dev
echo "Docker environment:" $ENVIRONMENT

/usr/sbin/httpd -DFOREGROUND

#Start Apache
#/usr/sbin/apache2 -D FOREGROUND & tail -f /var/log/syslog
#/usr/sbin/apache2 -D FOREGROUND