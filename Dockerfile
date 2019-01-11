# =============================================================================
# Base Image
#
# CentOS-7, Apache 2.4, PHP 7.2
#
# =============================================================================
FROM centos:centos7
LABEL maintainer="Marco Venezia <marco.venezia@skytv.it>"

RUN yum -y update && \
    yum -y install \
        epel-release \
        httpd \
        unzip

# -----------------------------------------------------------------------------
# Install Oracle drivers
#
# Oracle clients need to be downloaded in oracle path
# -----------------------------------------------------------------------------
ADD oracle/instantclient-basiclite-linux.x64-18.3.0.0.0dbru.zip /tmp/
RUN mkdir -p /usr/lib/oracle/18.3/client64/lib/ && \
    unzip -q /tmp/instantclient-basiclite-linux.x64-18.3.0.0.0dbru.zip -d /tmp && \
    mv /tmp/instantclient_18_3/* /usr/lib/oracle/18.3/client64/lib/ && \
    rm /tmp/instantclient-basiclite-linux.x64-18.3.0.0.0dbru.zip && \
    echo "/usr/lib/oracle/18.3/client64/lib" > /etc/ld.so.conf.d/oracle.conf && \
    ldconfig 

# -----------------------------------------------------------------------------
# Install SQL Server drivers
# -----------------------------------------------------------------------------
ADD https://packages.microsoft.com/config/rhel/7/prod.repo /etc/yum.repos.d/mssql-release.repo
RUN ACCEPT_EULA=Y yum install -y msodbcsql

# -----------------------------------------------------------------------------
# Apache 2.4 + (PHP 7.2 from Remi)
# -----------------------------------------------------------------------------
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi-php72 && \
    yum -y install \
        php72-php \
        php72-php-common \
        php72-php-devel \
        php72-php-mysqlnd \
	php72-php-mbstring \
	php72-php-soap \
	php72-php-gd \
        php72-php-ldap \
        php72-php-pear \
        php72-php-pdo \
	php72-php-intl \
	php72-php-xml \
        php72-php-oci8 \
        php72-php-sqlsrv \
        php72-php-pear \
        libaio && \
    sed -i 's/;error_log = syslog/error_log = \/dev\/stderr/' /etc/opt/remi/php72/php.ini && \
    ln -sf /dev/stdout /var/log/httpd/access_log && \
    ln -sf /dev/stderr /var/log/httpd/error_log && \
    ln -sf /usr/bin/php72-pear /usr/bin/pear && \
    ln -sf /opt/remi/php72/root/usr/share/php /usr/share/php && \
    ln -sf /var/opt/remi/php72/lib/php /var/lib/php && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    rm -f /etc/httpd/conf.d/{userdir.conf,welcome.conf}

RUN yum -y install git
#RUN sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
RUN sed -i 's/Options Indexes FollowSymLinks/Options FollowSymLinks/' /etc/httpd/conf/httpd.conf

ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

RUN mkdir -p /run/httpd
RUN chown root:apache /run/httpd
RUN chmod 0710 /run/httpd


ARG GIT_SOURCE_REPO
ARG LOCAL_REPO
ARG ENVIRONMENT

# -----------------------------------------------------------------------------
# Set ports and env variable HOME
# -----------------------------------------------------------------------------
#EXPOSE 8080
EXPOSE 80
ENV HOME /var/www

# -----------------------------------------------------------------------------
# Start
# -----------------------------------------------------------------------------
ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]

#CMD ["/usr/sbin/httpd", "-DFOREGROUND"]