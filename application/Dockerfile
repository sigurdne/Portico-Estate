#
# The Portico Estate application
#

FROM ubuntu:18.04
MAINTAINER Sigurd Nes <sigurdne@online.no>

#
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y subversion locales
RUN apt-get install -y less vim-tiny

RUN locale-gen --purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN mkdir -p /var/www/html

# Download Portico Estate into /var/www/html/portico
RUN rm /var/www/html/portico/* -rf
# Produksjon:
# RUN svn export svn://svn.savannah.nongnu.org/fmsystem/branches/Version-2_0-branch /var/www/html/portico # revision
# Test:
# RUN svn export --trust-server-cert --non-interactive https://github.com/PorticoEstate/PorticoEstate.git/trunk /var/www/html/portico # revision
RUN svn export --trust-server-cert https://github.com/PorticoEstate/PorticoEstate.git/trunk /var/www/html/portico # revision 10533.
RUN svn export --trust-server-cert https://github.com/PorticoEstate/PE_custom.git/trunk/BK_COMMON /var/www/html/portico --force
RUN svn export --trust-server-cert https://github.com/PorticoEstate/PE_custom.git/trunk/BK_EBE /var/www/html/portico --force

VOLUME /var/www/html/portico
ENTRYPOINT /usr/bin/tail -f /dev/null

# NOTE TO SELF:
# docker build -t sigurdne/portico_estate_application . && docker push sigurdne/portico_estate_application
# docker run --name sigurdne_portico_estate_application -i -t sigurdne/portico_estate_application
# docker exec -i -t sigurdne_portico_estate_application bash #by Name
# docker rm $(docker ps -a -q)
# docker push sigurdne/portico_estate_application
