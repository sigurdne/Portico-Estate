FROM php:8-apache

LABEL maintainer="Sigurd Nes <sigurdne@gmail.com>"

# Install necessary packages
RUN apt-get update  && apt-get install -y software-properties-common \
     apt-utils libcurl4-openssl-dev libicu-dev libxslt-dev libpq-dev zlib1g-dev libpng-dev libc-client-dev libkrb5-dev libzip-dev libonig-dev \
     supervisor \ 
     git \
     less vim-tiny \
     apg \
     sudo \
     libaio1 locales wget

# Install PHP extensions
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install curl intl xsl pdo_pgsql pdo_mysql gd imap soap zip mbstring

# Install PECL extensions
RUN pecl install xdebug apcu && docker-php-ext-enable xdebug apcu

# MSSQL-support
RUN wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.asc.gpg
RUN echo "deb [arch=amd64] https://packages.microsoft.com/debian/$(cat /etc/debian_version | cut -d. -f1)/prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update

RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17
# optional: for bcp and sqlcmd
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18

# Install sqlsrv
RUN apt-get install -y unixodbc
RUN apt-get install -y unixodbc-dev
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv

# Configure locales
RUN locale-gen --purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APP_DOCUMENT_ROOT /var/www/html

EXPOSE 80
EXPOSE 443

RUN apt-get update && apt-get install -y ssl-cert

RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod ssl
RUN a2ensite default-ssl.conf

# PHP
ENV PHP_INI ""
ENV XDEBUG_REMOTE_PORT ""
ADD php8/app.ini /usr/local/etc/php/conf.d/91-app.ini
#ADD php8/app.ini /etc/php/8.0/cli/conf.d/91-app.ini

# Add image configuration and scripts
ADD start.sh /start.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Others
ENV HOME /root
WORKDIR /root

# Command on startup
CMD ["/run.sh"]


# NOTE TO SELF:
# docker build -t sigurdne/portico_estate_webserver .
# docker run --name sigurdne_portico_estate_webserver -i -t sigurdne/portico_estate_webserver
# docker exec -i -t sigurdne_portico_estate_webserver bash #by Name
# docker rm $(docker ps -a -q)
# docker push sigurdne/portico_estate_webserver
