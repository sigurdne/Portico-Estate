#
# Apache/php-server with xsl, postgres, mysql, mssql
#

FROM ubuntu:18.04
MAINTAINER Sigurd Nes <sigurdne@online.no>

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update # Date 2017-08-15
RUN apt-get -y upgrade
RUN apt-get install -y apt-utils
RUN apt-get install -y supervisor
RUN apt-get install -y apache2
RUN apt-get install -y mysql-client-core-5.7
RUN apt-get install -y libapache2-mod-php7.2 \
	php7.2 php7.2-curl php7.2-intl php7.2-mysql \
	php-xdebug php-apcu php7.2-dev php7.2-xmlrpc \
	php7.2-xsl php7.2-sybase php7.2-pgsql \
	php7.2-json php7.2-gd php-imagick php7.2-imap \
	php7.2-soap php7.2-zip php7.2-mbstring php-pear \
	libaio1 locales
RUN apt-get install -y git
RUN apt-get install -y less vim-tiny
RUN apt-get install -y apg
RUN apt-get install -y sudo
RUN apt-get install -y libapache2-mod-shib2


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

# Override default apache conf
ADD apache.conf /etc/apache2/sites-enabled/000-default.conf

# SSL
ADD apache_ssl.conf /etc/apache2/sites-available/default-ssl.conf
ADD ssl/private/apache-selfsigned.key /etc/ssl/private/apache-selfsigned.key
ADD ssl/certs/apache-selfsigned.crt /etc/ssl/certs/apache-selfsigned.crt
ADD ssl/certs/dhparam.pem /etc/ssl/certs/dhparam.pem
ADD ssl-params.conf /etc/apache2/conf-available/ssl-params.conf


ADD etc/shibboleth/sp-cert.pem  /etc/shibboleth/sp-cert.pem
ADD etc/shibboleth/sp-key.pem  /etc/shibboleth/sp-key.pem
ADD etc/shibboleth/shibboleth2.xml  /etc/shibboleth/shibboleth2.xml


EXPOSE 80 443

RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2enmod headers
RUN a2ensite default-ssl
RUN a2enconf ssl-params
# RUN /usr/sbin/shib-keygen

ADD start-shibd.sh /start-shibd.sh
CMD ["/start-shibd.sh"]
#RUN chmod +x /start-shibd.sh
#RUN service shibd



#RUN sed -i "s/^\\( *export \+LANG.*\\)/#\\1/" /etc/apache2/envvars

# PHP7
ENV PHP_INI ""
ENV XDEBUG_REMOTE_PORT ""

ADD php7/app.ini /etc/php/7.2/apache2/conf.d/91-app.ini
ADD php7/app.ini /etc/php/7.2/cli/conf.d/91-app.ini


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

