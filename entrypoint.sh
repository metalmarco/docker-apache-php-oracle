#!/bin/bash

#Start syslog
#rsyslogd

#Clone source
ENTRYPOINT cd /var/www/html && [ -z "$GIT_SOURCE_REPO" ] || git clone $GIT_SOURCE_REPO


#GET/SET Environment
[ -z "$ENVIRONMENT" ] && ENVIRONMENT=dev
echo "Docker environment:" $ENVIRONMENT

/usr/sbin/httpd -DFOREGROUND

#Start Apache
#/usr/sbin/apache2 -D FOREGROUND & tail -f /var/log/syslog
#/usr/sbin/apache2 -D FOREGROUND