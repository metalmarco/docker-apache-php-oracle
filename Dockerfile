FROM php:5.4-apache
RUN apt-get update && apt-get install -y \
        libldb-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libicu-dev \
        libmysqlclient18 \
        libc6 \
        libaio1 \
        zlib1g \
        make \
        php5-dev \
        php-pear \
        libcurl4-gnutls-dev \
        unzip \
        libcurl4-gnutls-dev \
        libxml2-dev

RUN docker-php-ext-install intl pdo_mysql mbstring sockets soap calendar ldap \
    && pecl install xdebug

ADD instantclient-basic-linux.x64-12.1.0.2.0.zip /tmp/
ADD instantclient-sdk-linux.x64-12.1.0.2.0.zip /tmp/

RUN unzip /tmp/instantclient-basic-linux.x64-12.1.0.2.0.zip -d /usr/local/ \
    && unzip /tmp/instantclient-sdk-linux.x64-1libldap2-dev2.1.0.2.0.zip -d /usr/local/ \
    && ln -s /usr/local/instantclient_12_1 /usr/local/instantclient \
    && ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so \
    && docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient \
    && docker-php-ext-install oci8
    && docker-php-ext-install ldap

#ADD php.ini $PHP_INI_DIR/conf.d/php.ini
#ADD website.conf /etc/apache2/sites-available/website.conf
#ADD libpdf_php.so /tmp/libpdf_php.so

#RUN a2ensite website
#RUN a2enmod rewrite