#
# Apache/php-server with xsl, postgres, mysql, mssql
#

FROM ubuntu:22.04
LABEL maintainer="Sigurd Nes <sigurdne@online.no>"

# php8.3

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get install -y software-properties-common
#RUN apt-get install -y language-pack-en-base
#ENV LC_ALL en_US.UTF-8
RUN add-apt-repository -y ppa:ondrej/php
RUN add-apt-repository -y ppa:ondrej/apache2
RUN apt-get update && apt-get install -y wkhtmltopdf
RUN apt-get install -y software-properties-common
RUN apt-get -y upgrade
RUN apt-get install -y apt-utils
RUN apt-get install -y supervisor
RUN apt-get install -y apache2
RUN apt-get install -y mysql-client-core-8.0
RUN apt-get install -y libapache2-mod-php8.3 \
	php8.3 php8.3-curl php8.3-intl \
	php8.3-xdebug php8.3-apcu php8.3-dev \
	php8.3-xsl php8.3-sybase php8.3-pgsql \
	php8.3-gd php8.3-imagick php8.3-imap php8.3-redis \
	php8.3-soap php8.3-zip php8.3-mbstring php-pear \
	libaio1 locales
RUN apt-get install -y php8.3-mysql
RUN apt-get install -y git
RUN apt-get install -y less vim-tiny
RUN apt-get install -y apg
RUN apt-get install -y sudo

# REDIS (php 8.3)
# https://askubuntu.com/questions/1433463/php8-1-redis-module-for-ubuntu-20-04


# MSSQL-support

RUN curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17
# optional: for bcp and sqlcmd
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18

# Temorary workaround to install sqlsrv
# https://stackoverflow.com/questions/75424070/docker-unixodbc-h-no-such-file-or-directory-pecl-install-sqlsrv-error-with-u
# RUN apt-get install unixodbc-dev=2.3.7 unixodbc=2.3.7 odbcinst1debian2=2.3.7 odbcinst=2.3.7
RUN apt-get install -y unixodbc
RUN apt-get install -y unixodbc-dev
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv
RUN printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/8.3/mods-available/sqlsrv.ini
RUN printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/8.3/mods-available/pdo_sqlsrv.ini
RUN phpenmod -v 8.3 sqlsrv pdo_sqlsrv

RUN locale-gen --purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Supervisor #
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APP_DOCUMENT_ROOT /var/www/html


EXPOSE 80
EXPOSE 443

RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod ssl
RUN a2ensite default-ssl.conf


# PHP
ENV PHP_INI ""
ENV XDEBUG_REMOTE_PORT ""
#
ADD php8/app.ini /etc/php/8.3/apache2/conf.d/91-app.ini
ADD php8/app.ini /etc/php/8.3/cli/conf.d/91-app.ini


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
